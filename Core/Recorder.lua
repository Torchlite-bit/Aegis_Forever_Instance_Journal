local addonName, ns = ...
local L = ns.L

--[[
	The recorder behind the Record tab.

	While it is on, it writes down what the client will tell an addon on Forever: dungeon
	visits and their area names, boss pulls and kills, what the loot windows held and what the
	group looted, and each quest's text, giver, place and rewards. Inside a dungeon it also turns on the game's own
	combat log, the one place boss abilities are not withheld, and turns it off again on the
	way out if it was the one that turned it on.

	Everything lands in AegisJournalDB.record, merged by dungeon, boss and quest rather than
	kept as a raw event stream, so the saved file stays small and reads directly into
	Tools/build_data.py.
]]

local Recorder = {}
ns.Recorder = Recorder

local MAX_LOG = 150
local LOOT_CREDIT_SECONDS = 120   -- loot opened this soon after a kill is credited to that boss
local REPUTATION_SECONDS = 3      -- a reputation gain this soon after a turn-in belongs to that quest
local ENTRANCE_SECONDS = 120      -- a loading screen this long is still the walk in through the portal
local GROUP_SOURCE = "group"      -- loot a group member received, off no creature the game names

local state
local listeners = {}
local currentInstanceID, lastArea
local pull, lastKill, lastTurnIn, leftFrom
-- The loot history's drops already read ("encounterID:lootListID").
local historySeen = {}

local function Stamp()
	return date("%Y-%m-%d %H:%M")
end

local function Changed()
	for _, listener in ipairs(listeners) do pcall(listener) end
end

local function Log(text)
	local log = state.log
	log[#log + 1] = date("%H:%M") .. "  " .. text
	while #log > MAX_LOG do table.remove(log, 1) end
	Changed()
end

local function Call(fn, ...)
	if type(fn) ~= "function" then return nil end
	local ok, value = pcall(fn, ...)
	if ok then return ns.Readable(value) end
	return nil
end

------------------------------------------------------------------------------------------
-- State
------------------------------------------------------------------------------------------

function Recorder:Init()
	ns.db.record = ns.db.record or {}
	state = ns.db.record
	state.log = state.log or {}
	state.visits = state.visits or {}
	state.areas = state.areas or {}
	state.encounters = state.encounters or {}
	state.loot = state.loot or {}
	state.quests = state.quests or {}
	state.entrances = state.entrances or {}
	state.vendors = state.vendors or {}
	state.combatLogs = state.combatLogs or {}
	if state.combatLog == nil then state.combatLog = true end
	-- On unless the player turns it off: recording starts on entering a dungeon.
	if state.autoRecord == nil then state.autoRecord = true end
	self:Listen(state.recording == true)
	self:ShareVendors()
end

function Recorder:OnChange(listener)
	listeners[#listeners + 1] = listener
end

function Recorder:IsRecording()
	return state ~= nil and state.recording == true
end

function Recorder:GetState()
	return state
end

function Recorder:Start()
	if self:IsRecording() then return end
	state.recording = true
	state.startedAt = Stamp()
	self:Listen(true)
	ns.Print(L.RECORD_STARTED)
	Log(L.RECORD_LOG_STARTED)
	self:NoteInstance()
end

function Recorder:Stop()
	if not self:IsRecording() then return end
	state.recording = false
	state.autoStarted = nil
	self:Listen(false)
	self:UpdateCombatLog()
	ns.Print(L.RECORD_STOPPED)
	Log(L.RECORD_LOG_STOPPED)
end

function Recorder:Toggle()
	if self:IsRecording() then self:Stop() else self:Start() end
end

function Recorder:SetCombatLog(enabled)
	state.combatLog = enabled and true or false
	self:UpdateCombatLog()
	Changed()
end

--[[
	Recording by itself in dungeons (autoRecord): it starts on the way into one, and stops on
	the way out when it was the one that started it; a recording the player started is theirs.
]]
function Recorder:SetAutoRecord(enabled)
	state.autoRecord = enabled and true or false
	Changed()
end

function Recorder:AutoRecord()
	if not state.autoRecord then return end
	local inside = ns.InInstance()
	if inside and not self:IsRecording() then
		self:Start()
		state.autoStarted = true
	elseif not inside and state.autoStarted then
		state.autoStarted = nil
		self:Stop()
	end
end

-- Keeps the recording switch and the combat-log choice; forgets everything captured.
-- Every item a recorded run saw drop, by id: those are in the game, whatever a scan said.
local seenItems

function Recorder:SawItem(itemID)
	if not state then return false end
	if not seenItems then
		seenItems = {}
		for _, sources in pairs(state.loot or {}) do
			for _, items in pairs(sources) do
				for id in pairs(items) do seenItems[id] = true end
			end
		end
	end
	return seenItems[itemID] == true
end

function Recorder:Clear()
	seenItems = nil
	for _, key in ipairs({ "log", "visits", "areas", "encounters", "loot", "quests", "entrances", "vendors", "combatLogs" }) do
		state[key] = {}
	end
	state.copiedTotal = nil
	currentInstanceID, lastArea, pull, lastKill, lastTurnIn = nil, nil, nil, nil, nil
	historySeen = {}
	Log(L.RECORD_LOG_CLEARED)
	if self:IsRecording() then self:NoteInstance() end
end

local function Count(list)
	local count = 0
	for _ in pairs(list or {}) do count = count + 1 end
	return count
end

function Recorder:Counts()
	local counts = { dungeons = 0, visits = 0, kills = 0, items = 0, quests = 0, areas = 0, entrances = 0, wares = 0 }
	for _, visit in pairs(state.visits) do
		counts.dungeons = counts.dungeons + 1
		counts.visits = counts.visits + (visit.count or 0)
	end
	for _, encounter in pairs(state.encounters) do counts.kills = counts.kills + (encounter.kills or 0) end
	for _, sources in pairs(state.loot) do
		for _, items in pairs(sources) do counts.items = counts.items + Count(items) end
	end
	counts.quests = Count(state.quests)
	for _, names in pairs(state.areas) do counts.areas = counts.areas + #names end
	counts.entrances = Count(state.entrances)
	for _, vendor in pairs(state.vendors) do counts.wares = counts.wares + Count(vendor.items) end
	-- Everything caught, and how much of it is new since the last Copy.
	counts.caught = counts.dungeons + counts.kills + counts.items + counts.quests + counts.areas + counts.entrances
		+ counts.wares + #(ns.db.travel or {})
	counts.new = math.max(0, counts.caught - (state.copiedTotal or 0))
	return counts
end

function Recorder:MarkCopied()
	state.copiedTotal = self:Counts().caught
	Changed()
end

local function SortedKeys(list)
	local keys = {}
	for key in pairs(list or {}) do keys[#keys + 1] = key end
	table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
	return keys
end

-- Every item the journal lists for a dungeon (all its wings), off a boss or off trash.
local function ListedItems(instanceID)
	local listed = {}
	for _, instance in ipairs(ns.GetInstancesByInstanceID(instanceID)) do
		for _, boss in ipairs(instance.bosses) do
			for _, row in ipairs(boss.loot or {}) do listed[row.itemID] = true end
		end
	end
	return listed
end

--[[
	What has been caught, for the Record tab's list. By dungeon, the latest visited first: its
	visits, entrance and areas, the bosses killed, and the drops the journal does not list there
	yet, off a boss, off trash and looted by the group (the ones it lists are only counted). Then the quests (new:
	no dungeon in the journal has them), the quartermasters (new: wares their faction's own
	rewards lack) and the travel marks. new adds up everything new.
]]
function Recorder:Catch()
	local catch = { places = {}, quests = {}, vendors = {}, travel = #(ns.db.travel or {}), new = 0 }
	local byID = {}
	local function Place(instanceID)
		local place = byID[instanceID]
		if place then return place end
		local visit = state.visits[instanceID] or {}
		local instance = ns.GetInstancesByInstanceID(instanceID)[1]
		place = {
			instanceID = instanceID, name = visit.name or instance and instance.name or tostring(instanceID),
			visits = visit.count or 0, last = visit.last or "", entrance = state.entrances[instanceID] ~= nil,
			areas = #(state.areas[instanceID] or {}), kills = {}, bosses = {}, trash = {}, group = {}, new = 0, listed = 0,
		}
		byID[instanceID] = place
		catch.places[#catch.places + 1] = place
		return place
	end

	for _, id in ipairs(SortedKeys(state.visits)) do Place(id) end
	for _, id in ipairs(SortedKeys(state.encounters)) do
		local fight = state.encounters[id]
		if fight.instanceID then
			local kills = Place(fight.instanceID).kills
			kills[#kills + 1] = { name = fight.name or tostring(id), kills = fight.kills or 0, wipes = fight.wipes or 0 }
		end
	end
	for _, id in ipairs(SortedKeys(state.loot)) do
		local place, listed, counted, bosses = Place(id), ListedItems(id), {}, {}
		-- Boss names sort ahead of "group" and "trash...": an item seen both ways shows under its boss.
		for _, source in ipairs(SortedKeys(state.loot[id])) do
			local unnamed = source:sub(1, 5) == "trash" and place.trash or source == GROUP_SOURCE and place.group or nil
			for _, itemID in ipairs(SortedKeys(state.loot[id][source])) do
				local item = state.loot[id][source][itemID]
				if listed[itemID] then
					if not counted[itemID] then place.listed = place.listed + 1 end
				else
					local row = { itemID = itemID, name = item.name, quality = item.quality }
					if unnamed then
						if not counted[itemID] then unnamed[#unnamed + 1] = row end
					else
						local boss = bosses[source]
						if not boss then
							boss = { name = source, items = {} }
							bosses[source] = boss
							place.bosses[#place.bosses + 1] = boss
						end
						boss.items[#boss.items + 1] = row
					end
					if not counted[itemID] then place.new = place.new + 1 end
				end
				counted[itemID] = true
			end
		end
	end
	table.sort(catch.places, function(a, b)
		if a.last ~= b.last then return a.last > b.last end
		return a.name < b.name
	end)
	for _, place in ipairs(catch.places) do catch.new = catch.new + place.new end

	for _, id in ipairs(SortedKeys(state.quests)) do
		local quest = state.quests[id]
		local entry = { questID = id, title = quest.title or tostring(id), done = quest.turnedIn ~= nil,
			new = not ns.JournalHasQuest(id) }
		catch.quests[#catch.quests + 1] = entry
		if entry.new then catch.new = catch.new + 1 end
	end
	for _, npcID in ipairs(SortedKeys(state.vendors)) do
		local vendor = state.vendors[npcID]
		local entry = { name = vendor.name or tostring(npcID), wares = 0, new = 0 }
		for itemID, ware in pairs(vendor.items or {}) do
			entry.wares = entry.wares + 1
			if ware.faction and not ns.FactionListsItem(ware.faction, itemID) then entry.new = entry.new + 1 end
		end
		catch.vendors[#catch.vendors + 1] = entry
		catch.new = catch.new + entry.new
	end
	return catch
end

--[[
	Everything recorded as text to paste in our Discord: one line per thing caught, its fields
	split by ";" (taken out of any name). The first line says which build of the journal and the
	game it came from, the player's side, and the name they want credited.
]]
local EXPORT_VERSION = 1

local function Field(value)
	if value == nil then return "" end
	if type(value) == "number" then
		if value ~= math.floor(value) then return string.format("%.4f", value) end
		return tostring(value)
	end
	return (tostring(value):gsub("[;\r\n|]", ","))
end

local function Join(list)
	local parts = {}
	for _, value in ipairs(list or {}) do parts[#parts + 1] = Field(value) end
	return table.concat(parts, ",")
end

function Recorder:Export(credit)
	local lines = {}
	local function Line(...)
		local fields = {}
		for index = 1, select("#", ...) do fields[index] = Field((select(index, ...))) end
		lines[#lines + 1] = table.concat(fields, ";")
	end
	local version = C_AddOns and C_AddOns.GetAddOnMetadata and C_AddOns.GetAddOnMetadata(addonName, "Version")
	local _, build = pcall(GetBuildInfo)
	local faction = Call(UnitFactionGroup, "player")
	Line("AEGIS RECORDING", EXPORT_VERSION, version or "?", build, date("%Y-%m-%d %H:%M"), faction, credit)
	for _, id in ipairs(SortedKeys(state.visits)) do
		local visit = state.visits[id]
		Line("VISIT", id, visit.name, visit.count)
	end
	for _, id in ipairs(SortedKeys(state.entrances)) do
		local door = state.entrances[id]
		Line("ENTRANCE", id, door.mapID, door.x, door.y)
	end
	for _, id in ipairs(SortedKeys(state.areas)) do
		for _, area in ipairs(state.areas[id]) do Line("AREA", id, area) end
	end
	for _, id in ipairs(SortedKeys(state.encounters)) do
		local fight = state.encounters[id]
		Line("ENCOUNTER", id, fight.name, fight.instanceID, fight.kills, fight.wipes, fight.lastKillSeconds, fight.area)
	end
	for _, id in ipairs(SortedKeys(state.loot)) do
		-- Last on each line: whether the journal lists the drop for that dungeon already.
		local listed = ListedItems(id)
		for _, source in ipairs(SortedKeys(state.loot[id])) do
			for _, itemID in ipairs(SortedKeys(state.loot[id][source])) do
				local item = state.loot[id][source][itemID]
				Line("LOOT", id, source, itemID, item.name, item.quality, item.nearKill, listed[itemID] and "listed" or "new")
			end
		end
	end
	for _, id in ipairs(SortedKeys(state.quests)) do
		local quest = state.quests[id]
		local pickup, turnin = quest.pickup or {}, quest.turnin or {}
		local from, to = pickup.place or {}, turnin.place or {}
		local rewards = quest.rewards or quest.offered or {}
		local reputation = {}
		for _, name in ipairs(SortedKeys(quest.reputation)) do reputation[#reputation + 1] = name .. " " .. quest.reputation[name] end
		Line("QUEST", id, quest.title, pickup.npc and pickup.npc.npcID, pickup.npc and pickup.npc.name, from.mapID, from.x, from.y,
			pickup.startItemID, turnin.npc and turnin.npc.npcID, turnin.npc and turnin.npc.name, to.mapID, to.x, to.y,
			quest.turnedIn and quest.turnedIn.xp or rewards.xp, quest.turnedIn and quest.turnedIn.money or rewards.money,
			Join(rewards.choices), Join(rewards.items), Join(reputation))
	end
	for _, spot in ipairs(ns.db.travel or {}) do
		Line("TRAVEL", spot.kind, spot.mapID, spot.x, spot.y, spot.faction, Join(spot.to), spot.area)
	end
	for _, npcID in ipairs(SortedKeys(state.vendors)) do
		local vendor = state.vendors[npcID]
		local place = vendor.place or {}
		for _, itemID in ipairs(SortedKeys(vendor.items)) do
			local ware = vendor.items[itemID]
			Line("VENDOR", npcID, vendor.name, place.mapID, place.x, place.y, itemID, ware.name, ware.price, ware.faction,
				ware.reaction, ware.cost)
		end
	end
	-- Items an /aegis items scan found the server knows nothing of.
	local scan = ns.db.missingItems
	for _, itemID in ipairs(SortedKeys(scan and scan.items)) do Line("MISSING", itemID, scan.items[itemID]) end
	-- The combat logs this recording wrote, for the Log Reader to ask for by name.
	for _, written in ipairs(state.combatLogs) do Line("COMBATLOG", written.file, written.instanceID) end
	return table.concat(lines, "\n")
end

------------------------------------------------------------------------------------------
-- Combat log
------------------------------------------------------------------------------------------

--[[
	Addons cannot read what enemies cast inside dungeons, but the game's own log file has it. The
	journal turns that log on inside dungeons and notes the file it starts: the game names it for
	the moment logging began (Logs\WoWCombatLog-MMDDYY_HHMMSS.txt). The Log Reader page asks for
	that file by name and turns it into lines the recording carries.
	Only a log this addon started is ever turned off; a log the player started is theirs.
]]
local LOG_FILES_KEPT = 20

function Recorder:CombatLogs()
	return state and state.combatLogs or {}
end

function Recorder:UpdateCombatLog()
	if not state or type(LoggingCombat) ~= "function" then return end
	local ok, logging = pcall(LoggingCombat)
	logging = ok and ns.Readable(logging)
	if logging == nil then return end

	local wanted = self:IsRecording() and state.combatLog and ns.InInstance()
	if wanted and not logging then
		if pcall(LoggingCombat, true) then
			state.combatLogOwned = true
			local file = "WoWCombatLog-" .. date("%m%d%y_%H%M%S") .. ".txt"
			table.insert(state.combatLogs, { file = file, instanceID = currentInstanceID, at = Stamp() })
			if #state.combatLogs > LOG_FILES_KEPT then table.remove(state.combatLogs, 1) end
			Log(string.format(L.RECORD_LOG_COMBATLOG_ON, file))
		end
	elseif not wanted and logging and state.combatLogOwned then
		pcall(LoggingCombat, false)
		state.combatLogOwned = nil
		Log(L.RECORD_LOG_COMBATLOG_OFF)
	end
end

------------------------------------------------------------------------------------------
-- Dungeons and areas
------------------------------------------------------------------------------------------

function Recorder:NoteArea()
	if not currentInstanceID then return end
	local area = Call(GetSubZoneText)
	if not area or area == "" or area == lastArea then return end
	lastArea = area
	local names = state.areas[currentInstanceID]
	if not names then
		names = {}
		state.areas[currentInstanceID] = names
	end
	for _, known in ipairs(names) do
		if known == area then return end
	end
	names[#names + 1] = area
	Log(string.format(L.RECORD_LOG_AREA, area))
end

--[[
	The loading screen is about to show: remember where the player stands, if outdoors. The
	client may already count the player as inside the dungeon by then, so the map decides: a
	position on a dungeon's own map is not a way in. Tried as the loading screen starts and as
	the world is left, whichever gives a position first; when neither does, why is kept for the
	log.
]]
local MAP_TYPE_DUNGEON = Enum and Enum.UIMapType and Enum.UIMapType.Dungeon or 4

function Recorder:NoteLeaving()
	if leftFrom and leftFrom.x and GetTime() - leftFrom.time < 5 then return end
	local mapID, x, y = ns.PlayerMapPosition()
	local ok, info = pcall(C_Map.GetMapInfo, mapID or 0)
	local inDungeonMap = ok and info and info.mapType == MAP_TYPE_DUNGEON
	if x and not inDungeonMap then
		leftFrom = { mapID = mapID, x = x, y = y, time = GetTime() }
	else
		leftFrom = { time = GetTime(), reason = not mapID and L.RECORD_NO_MAP or inDungeonMap and L.RECORD_IN_DUNGEON_MAP
			or L.RECORD_NO_POSITION }
	end
end

function Recorder:NoteInstance(isReload)
	local instanceID, name
	if ns.InInstance() then
		local ok, instanceName, _, _, _, _, _, _, id = pcall(GetInstanceInfo)
		if ok then instanceID, name = ns.Readable(id), ns.Readable(instanceName) end
	end

	if instanceID and instanceID ~= currentInstanceID then
		currentInstanceID, lastArea = instanceID, nil
		-- Where the player stood outside just before the loading screen is the way in.
		if leftFrom and GetTime() - leftFrom.time < ENTRANCE_SECONDS then
			if leftFrom.x then
				state.entrances[instanceID] = { mapID = leftFrom.mapID, x = leftFrom.x, y = leftFrom.y, at = Stamp() }
				Log(string.format(L.RECORD_LOG_ENTRANCE, name or tostring(instanceID)))
			else
				Log(string.format(L.RECORD_LOG_NO_ENTRANCE, name or tostring(instanceID), leftFrom.reason))
			end
		end
		leftFrom = nil
		-- A reload inside the same dungeon is not a new visit.
		if not (isReload and state.lastInstanceID == instanceID) then
			local visit = state.visits[instanceID] or { count = 0 }
			visit.name = name or visit.name
			visit.count = visit.count + 1
			visit.last = Stamp()
			state.visits[instanceID] = visit
			Log(string.format(L.RECORD_LOG_ENTERED, name or tostring(instanceID)))
		end
		state.lastInstanceID = instanceID
		self:NoteArea()
	elseif not instanceID and currentInstanceID then
		currentInstanceID, lastArea = nil, nil
		state.lastInstanceID = nil
		Log(L.RECORD_LOG_LEFT)
	end
	self:UpdateCombatLog()
end

------------------------------------------------------------------------------------------
-- Bosses and loot
------------------------------------------------------------------------------------------

function Recorder:EncounterStart(encounterID, encounterName)
	encounterID, encounterName = ns.Readable(encounterID), ns.Readable(encounterName)
	if not encounterID then return end
	local entry = state.encounters[encounterID] or { kills = 0, wipes = 0 }
	entry.name = encounterName or entry.name
	entry.instanceID = currentInstanceID or entry.instanceID
	entry.area = Call(GetSubZoneText) or entry.area
	state.encounters[encounterID] = entry
	pull = { encounterID = encounterID, started = GetTime() }
	Log(string.format(L.RECORD_LOG_PULL, entry.name or tostring(encounterID)))
end

function Recorder:EncounterEnd(encounterID, encounterName, _, _, success)
	encounterID, success = ns.Readable(encounterID), ns.Readable(success)
	if not encounterID then return end
	local entry = state.encounters[encounterID] or { kills = 0, wipes = 0 }
	entry.name = ns.Readable(encounterName) or entry.name
	state.encounters[encounterID] = entry
	if success == 1 or success == true then
		entry.kills = entry.kills + 1
		if pull and pull.encounterID == encounterID then
			entry.lastKillSeconds = math.floor(GetTime() - pull.started + 0.5)
		end
		lastKill = { name = entry.name, encounterID = encounterID, time = GetTime() }
		Log(string.format(L.RECORD_LOG_KILL, entry.name or tostring(encounterID)))
	else
		entry.wipes = entry.wipes + 1
		Log(string.format(L.RECORD_LOG_WIPE, entry.name or tostring(encounterID)))
	end
	pull = nil
end

--[[
	Who a loot slot came from, and the boss killed moments before, if any: a boss of this
	dungeon by npc id when the client says; a creature the client names but the journal does
	not know as a boss is trash (noted beside the kill, since a new dungeon's boss is not known
	yet: the combat log tells which creature the encounter was); and only when the client hides
	the corpse is the loot credited to the boss killed moments ago.
]]
local function LootSource(slot)
	local npcID
	if type(GetLootSourceInfo) == "function" then
		local ok, guid = pcall(GetLootSourceInfo, slot)
		if ok then npcID = ns.NpcIDFromGUID(guid) end
	end
	local nearKill = lastKill and GetTime() - lastKill.time <= LOOT_CREDIT_SECONDS and lastKill.name or nil
	local instance = currentInstanceID and ns.GetInstanceByInstanceID(currentInstanceID)
	if npcID and instance then
		for _, boss in ipairs(instance.bosses) do
			if boss.npcID == npcID then return boss.name end
		end
	end
	if npcID then return "trash:" .. npcID, nearKill end
	return nearKill or "trash"
end

function Recorder:LootOpened()
	if not currentInstanceID then return end
	local count = Call(GetNumLootItems) or 0
	local sources = state.loot[currentInstanceID]
	if not sources then
		sources = {}
		state.loot[currentInstanceID] = sources
	end

	local added = 0
	for slot = 1, count do
		local itemID = ns.ItemIDFromLink(Call(GetLootSlotLink, slot))
		if itemID then
			local source, nearKill = LootSource(slot)
			local items = sources[source]
			if not items then
				items = {}
				sources[source] = items
			end
			if seenItems then seenItems[itemID] = true end
			if not items[itemID] then
				local ok, _, itemName, _, _, quality = pcall(GetLootSlotInfo, slot)
				items[itemID] = {
					name = ok and ns.Readable(itemName) or nil,
					quality = ok and ns.Readable(quality) or nil,
					first = Stamp(),
					nearKill = nearKill,
				}
				added = added + 1
			end
		end
	end
	if added > 0 then Log(string.format(L.RECORD_LOG_LOOT, added)) end
end

--[[
	In a group, much of a dungeon's loot never passes through the player's own loot window. Two
	more places tell of it, and an item is taken from them only when the dungeon has none of it
	recorded yet:
	  the loot chat, for every item a group member (or the player, too fast for a window)
	    receives: it never says which creature, so such loot is filed as "group". Items pushed
	    into the bags (quest rewards) or made are not loot and are not read, and the names of the
	    players in those lines are never kept;
	  the loot history, which keeps each boss's drops for the group to roll on under the
	    encounter's name: such loot is filed under its boss.
]]
local pickupPatterns

local function HasLoot(instanceID, itemID)
	for _, items in pairs(state.loot[instanceID] or {}) do
		if items[itemID] then return true end
	end
	return false
end

local function PutLoot(instanceID, source, itemID, name)
	state.loot[instanceID] = state.loot[instanceID] or {}
	local items = state.loot[instanceID][source] or {}
	state.loot[instanceID][source] = items
	if items[itemID] then return end
	items[itemID] = { name = name, first = Stamp() }
	if seenItems then seenItems[itemID] = true end
	Log(string.format(L.RECORD_LOG_LOOT, 1))
end

-- The client's own lines for loot received ("%s receives loot: %s."), as patterns.
local function PickupPatterns()
	if pickupPatterns then return pickupPatterns end
	pickupPatterns = {}
	for _, key in ipairs({ "LOOT_ITEM", "LOOT_ITEM_MULTIPLE", "LOOT_ITEM_SELF", "LOOT_ITEM_SELF_MULTIPLE" }) do
		local template = _G[key]
		if type(template) == "string" then
			local pattern = template:gsub("([%(%)%.%+%-%*%?%[%]%^%$])", "%%%1")
			pattern = pattern:gsub("%%s", ".+"):gsub("%%d", "%%d+")
			pickupPatterns[#pickupPatterns + 1] = "^" .. pattern .. "$"
		end
	end
	return pickupPatterns
end

function Recorder:LootMessage(text)
	text = ns.Readable(text)
	if type(text) ~= "string" or not currentInstanceID then return end
	local received = false
	for _, pattern in ipairs(PickupPatterns()) do
		if text:find(pattern) then
			received = true
			break
		end
	end
	if not received then return end
	local itemID = ns.ItemIDFromLink(text)
	if not itemID or HasLoot(currentInstanceID, itemID) then return end
	PutLoot(currentInstanceID, GROUP_SOURCE, itemID, text:match("|h%[(.-)%]|h"))
end

-- The boss an encounter's drops belong to; nil for the history's bucket of everything else.
local function EncounterName(encounterID)
	local name
	if C_LootHistory.GetInfoForEncounter then
		local ok, info = pcall(C_LootHistory.GetInfoForEncounter, encounterID)
		info = ok and ns.Readable(info)
		name = type(info) == "table" and ns.Readable(info.encounterName) or nil
	end
	name = name or (state.encounters[encounterID] and state.encounters[encounterID].name)
	if type(name) ~= "string" or name == "" or name == MISCELLANEOUS then return nil end
	return name
end

function Recorder:LootHistoryDrop(encounterID, lootListID)
	encounterID, lootListID = ns.Readable(encounterID), ns.Readable(lootListID)
	if not currentInstanceID or type(encounterID) ~= "number" or type(lootListID) ~= "number" then return end
	if not (C_LootHistory and C_LootHistory.GetSortedInfoForDrop) then return end
	local key = encounterID .. ":" .. lootListID
	if historySeen[key] then return end
	local ok, drop = pcall(C_LootHistory.GetSortedInfoForDrop, encounterID, lootListID)
	drop = ok and ns.Readable(drop)
	local itemID = type(drop) == "table" and ns.ItemIDFromLink(drop.itemHyperlink)
	-- Not readable yet: the drop is asked about again at its next update.
	if not itemID then return end
	historySeen[key] = true
	local boss = EncounterName(encounterID)
	local name = ns.Readable(drop.itemHyperlink):match("|h%[(.-)%]|h")
	if boss then
		-- Off a known boss even when the loot window filed it under the creature's number.
		local items = state.loot[currentInstanceID] and state.loot[currentInstanceID][boss]
		if not (items and items[itemID]) then PutLoot(currentInstanceID, boss, itemID, name) end
	elseif not HasLoot(currentInstanceID, itemID) then
		PutLoot(currentInstanceID, GROUP_SOURCE, itemID, name)
	end
end

------------------------------------------------------------------------------------------
-- Quests
------------------------------------------------------------------------------------------

local function Quest(questID)
	local quest = state.quests[questID]
	if not quest then
		quest = {}
		state.quests[questID] = quest
	end
	return quest
end

local function Place()
	local place = { zone = Call(GetRealZoneText), area = Call(GetSubZoneText) }
	place.mapID, place.x, place.y = ns.PlayerMapPosition()
	if place.area == "" then place.area = nil end
	return place
end

local function Npc()
	local name = Call(UnitName, "npc")
	if not name then return nil end
	return { name = name, npcID = ns.NpcIDFromGUID(Call(UnitGUID, "npc")) }
end

local function ItemIDs(kind, count)
	local list = {}
	for index = 1, count or 0 do
		local itemID = ns.ItemIDFromLink(Call(GetQuestItemLink, kind, index))
		if itemID then list[#list + 1] = itemID end
	end
	return #list > 0 and list or nil
end

-- The rewards shown on the quest frame that is open now.
local function FrameRewards()
	return {
		xp = Call(GetRewardXP),
		money = Call(GetRewardMoney),
		choices = ItemIDs("choice", Call(GetNumQuestChoices)),
		items = ItemIDs("reward", Call(GetNumQuestRewards)),
	}
end

-- An NPC (or an item) offering a quest.
function Recorder:QuestDetail(startItemID)
	local questID = Call(GetQuestID)
	if not questID or questID == 0 then return end
	local quest = Quest(questID)
	quest.title = Call(GetTitleText) or quest.title
	quest.description = Call(GetQuestText) or quest.description
	quest.objective = Call(GetObjectiveText) or quest.objective
	quest.pickup = { npc = Npc(), place = Place(), startItemID = ns.Readable(startItemID) }
	if quest.pickup.startItemID == 0 then quest.pickup.startItemID = nil end
	quest.offered = FrameRewards()
	Log(string.format(L.RECORD_LOG_QUEST_OFFERED, quest.title or tostring(questID)))
end

function Recorder:QuestAccepted(questID)
	questID = ns.Readable(questID)
	if not questID then return end
	local quest = Quest(questID)
	quest.title = quest.title or Call(C_QuestLog and C_QuestLog.GetTitleForQuestID, questID)
	quest.accepted = Stamp()
end

-- The reward frame at the turn-in NPC.
function Recorder:QuestComplete()
	local questID = Call(GetQuestID)
	if not questID or questID == 0 then return end
	local quest = Quest(questID)
	quest.title = Call(GetTitleText) or quest.title
	quest.completionText = Call(GetRewardText) or quest.completionText
	quest.turnin = { npc = Npc(), place = Place() }
	quest.rewards = FrameRewards()
end

function Recorder:QuestTurnedIn(questID, xp, money)
	questID = ns.Readable(questID)
	if not questID then return end
	local quest = Quest(questID)
	quest.turnedIn = { xp = ns.Readable(xp), money = ns.Readable(money), time = Stamp() }
	lastTurnIn = { questID = questID, time = GetTime() }
	Log(string.format(L.RECORD_LOG_QUEST_DONE, quest.title or tostring(questID)))
end

-- "Reputation with Ironforge increased by 100." right after a turn-in belongs to that quest.
local reputationPattern
function Recorder:ReputationMessage(text)
	text = ns.Readable(text)
	if type(text) ~= "string" or not lastTurnIn or GetTime() - lastTurnIn.time > REPUTATION_SECONDS then return end
	if not reputationPattern then
		local template = FACTION_STANDING_INCREASED or "Reputation with %s increased by %d."
		reputationPattern = "^" .. template:gsub("%.", "%%."):gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)") .. "$"
	end
	local faction, amount = text:match(reputationPattern)
	if not faction then return end
	local quest = Quest(lastTurnIn.questID)
	quest.reputation = quest.reputation or {}
	quest.reputation[faction] = tonumber(amount)
end

------------------------------------------------------------------------------------------
-- Reputation vendors
------------------------------------------------------------------------------------------

--[[
	A quartermaster's wares: each ware's price, any other cost (items or currencies), and the
	faction and standing it needs, with the vendor and where they stand. Captured on purpose by
	the Reputation tab's Capture button (everything the vendor sells), or, while recording, as
	soon as a vendor whose wares need a standing opens their shop (only then is a vendor with
	none of those left out). The wares that need a standing join that faction's rewards at once.
]]
local merchantOpen = false
local requiresPattern, reactionOfLabel

local function StandingOf(text)
	if not requiresPattern then
		local template = ITEM_REQ_REPUTATION or "Requires %s - %s"
		requiresPattern = "^" .. template:gsub("%-", "%%-"):gsub("%%s", "(.+)") .. "$"
		reactionOfLabel = {}
		for reaction = 1, 8 do
			local label = _G["FACTION_STANDING_LABEL" .. reaction]
			if label then reactionOfLabel[label] = reaction end
		end
	end
	local faction, standing = (text or ""):match(requiresPattern)
	if faction and reactionOfLabel[standing] then return faction, reactionOfLabel[standing] end
end

-- A ware's tooltip lines: from the client's tooltip data, else read off a hidden tooltip.
local scanner
local function WareLines(index)
	local lines = {}
	if C_TooltipInfo and C_TooltipInfo.GetMerchantItem then
		local ok, data = pcall(C_TooltipInfo.GetMerchantItem, index)
		if ok and data and data.lines then
			for _, line in ipairs(data.lines) do lines[#lines + 1] = ns.Readable(line.leftText) end
			return lines
		end
	end
	scanner = scanner or CreateFrame("GameTooltip", "AegisJournalScanTooltip", nil, "GameTooltipTemplate")
	scanner:SetOwner(UIParent, "ANCHOR_NONE")
	if pcall(scanner.SetMerchantItem, scanner, index) then
		for line = 1, scanner:NumLines() or 0 do
			local region = _G["AegisJournalScanTooltipTextLeft" .. line]
			lines[#lines + 1] = region and ns.Readable(region:GetText())
		end
	end
	scanner:Hide()
	return lines
end

local function WareInfo(index)
	if C_MerchantFrame and C_MerchantFrame.GetItemInfo then
		local ok, info = pcall(C_MerchantFrame.GetItemInfo, index)
		if ok and type(info) == "table" then return ns.Readable(info.name), ns.Readable(info.price) end
	end
	local ok, name, _, price = pcall(GetMerchantItemInfo, index)
	if ok then return ns.Readable(name), ns.Readable(price) end
end

-- Other costs of a ware, as "2 Arcane Crystal + 5 Holy Water", or nil.
local function WareCost(index)
	local parts = {}
	for costIndex = 1, Call(GetMerchantItemCostInfo, index) or 0 do
		local ok, _, value, link, currencyName = pcall(GetMerchantItemCostItem, index, costIndex)
		if ok then
			value, link = ns.Readable(value), ns.Readable(link)
			local name = ns.Readable(currencyName) or (type(link) == "string" and link:match("%[(.-)%]")) or nil
			if value and name then parts[#parts + 1] = value .. " " .. name end
		end
	end
	return #parts > 0 and table.concat(parts, " + ") or nil
end

-- Every ware on the open shop: { [itemID] = { name, price, cost, faction, reaction } }.
local function ReadWares()
	local wares = {}
	for index = 1, Call(GetMerchantNumItems) or 0 do
		local itemID = ns.ItemIDFromLink(Call(GetMerchantItemLink, index))
		if itemID then
			local name, price = WareInfo(index)
			local ware = { name = name, price = price, cost = WareCost(index) }
			for _, text in ipairs(WareLines(index)) do
				local faction, reaction = StandingOf(text)
				if faction then
					ware.faction, ware.reaction = faction, reaction
					break
				end
			end
			wares[itemID] = ware
		end
	end
	return wares
end

-- A kept vendor in the shape ns.AddCapturedVendors takes.
local function VendorEntry(npcID, vendor)
	local wares, place = {}, vendor.place or {}
	for itemID, ware in pairs(vendor.items or {}) do
		wares[#wares + 1] = { itemID = itemID, price = ware.price, cost = ware.cost, faction = ware.faction,
			reaction = ware.reaction }
	end
	return { npcID = npcID, name = vendor.name, mapID = place.mapID, x = place.x, y = place.y, wares = wares }
end

function Recorder:MerchantOpen()
	return merchantOpen
end

--[[
	Keeps the open shop's wares (onPurpose: even a vendor with none that need a standing). Returns
	what was found, { name, wares, forStanding, new, factions = { name, ... } }, or nil with no shop
	open or no vendor to name. new counts the wares that joined a faction's rewards just now.
]]
function Recorder:CaptureVendor(onPurpose)
	if not merchantOpen then return nil end
	local npc = Npc()
	if not npc or not npc.npcID then return nil end
	local wares = ReadWares()
	local found = { name = npc.name, wares = 0, forStanding = 0, new = 0, factions = {} }
	local named = {}
	for _, ware in pairs(wares) do
		found.wares = found.wares + 1
		if ware.faction then
			found.forStanding = found.forStanding + 1
			if not named[ware.faction] then
				named[ware.faction] = true
				found.factions[#found.factions + 1] = ware.faction
			end
		end
	end
	table.sort(found.factions)
	if found.forStanding == 0 and not onPurpose then return found end
	local vendor = state.vendors[npc.npcID] or { items = {} }
	vendor.name, vendor.place, vendor.at = npc.name, Place(), Stamp()
	-- Seen while recording, only the wares that need a standing; captured on purpose, all of them.
	for itemID, ware in pairs(wares) do
		if onPurpose or ware.faction then vendor.items[itemID] = ware end
	end
	state.vendors[npc.npcID] = vendor
	found.new = ns.AddCapturedVendors({ VendorEntry(npc.npcID, vendor) }, true)
	Log(string.format(L.RECORD_LOG_VENDOR, npc.name, found.wares, found.new))
	return found
end

-- What the vendors kept so far sell joins their factions' rewards.
function Recorder:ShareVendors()
	local list = {}
	for npcID, vendor in pairs(state.vendors or {}) do list[#list + 1] = VendorEntry(npcID, vendor) end
	ns.AddCapturedVendors(list, true)
end

-- A shop opening or closing, heard whether recording or not: the Capture button follows it, and
-- while recording a quartermaster's wares are kept at once.
local shop = CreateFrame("Frame")
ns.RegisterEvents(shop, "MERCHANT_SHOW", "MERCHANT_CLOSED")
shop:SetScript("OnEvent", function(_, event)
	merchantOpen = event == "MERCHANT_SHOW"
	if not state then return end
	if merchantOpen and Recorder:IsRecording() then
		local ok, err = pcall(Recorder.CaptureVendor, Recorder, false)
		if not ok then Log("|cffff4040" .. event .. ": " .. tostring(err) .. "|r") end
	end
	Changed()
end)
------------------------------------------------------------------------------------------
-- Events
------------------------------------------------------------------------------------------

local HANDLERS = {
	PLAYER_ENTERING_WORLD = function(_, isReloadingUi) Recorder:NoteInstance(isReloadingUi) end,
	PLAYER_LEAVING_WORLD = function() Recorder:NoteLeaving() end,
	LOADING_SCREEN_ENABLED = function() Recorder:NoteLeaving() end,
	ZONE_CHANGED = function() Recorder:NoteArea() end,
	ZONE_CHANGED_INDOORS = function() Recorder:NoteArea() end,
	ZONE_CHANGED_NEW_AREA = function() Recorder:NoteInstance() end,
	ENCOUNTER_START = function(...) Recorder:EncounterStart(...) end,
	ENCOUNTER_END = function(...) Recorder:EncounterEnd(...) end,
	LOOT_OPENED = function() Recorder:LootOpened() end,
	-- With auto loot the window may be gone before it is drawn; the items are ready first.
	LOOT_READY = function() Recorder:LootOpened() end,
	CHAT_MSG_LOOT = function(text) Recorder:LootMessage(text) end,
	LOOT_HISTORY_UPDATE_DROP = function(...) Recorder:LootHistoryDrop(...) end,
	QUEST_DETAIL = function(startItemID) Recorder:QuestDetail(startItemID) end,
	QUEST_ACCEPTED = function(questID) Recorder:QuestAccepted(questID) end,
	QUEST_COMPLETE = function() Recorder:QuestComplete() end,
	QUEST_TURNED_IN = function(...) Recorder:QuestTurnedIn(...) end,
	CHAT_MSG_COMBAT_FACTION_CHANGE = function(text) Recorder:ReputationMessage(text) end,
}

-- Heard even while stopped: the way into a dungeon and out of it, for recording by itself there.
local ALWAYS = { PLAYER_ENTERING_WORLD = true, PLAYER_LEAVING_WORLD = true, LOADING_SCREEN_ENABLED = true }

--[[
	Stopped, the recorder listens only for the way into the world and out of it: a combat log it
	started must still be turned off, and recording by itself starts on the way into a dungeon
	(where the player stood before the loading screen is its entrance). Recording, it listens to
	the rest as well.
]]
local events = CreateFrame("Frame")
for event in pairs(ALWAYS) do events:RegisterEvent(event) end

function Recorder:Listen(on)
	for event in pairs(HANDLERS) do
		if not ALWAYS[event] then
			if on then ns.RegisterEvents(events, event) else ns.UnregisterEvents(events, event) end
		end
	end
end

events:SetScript("OnEvent", function(_, event, ...)
	if not state then return end
	if not Recorder:IsRecording() then
		if event == "PLAYER_ENTERING_WORLD" then
			-- Even when stopped, a log this addon started must still be turned off on the way out.
			Recorder:UpdateCombatLog()
			Recorder:AutoRecord()
		elseif state.autoRecord and event ~= "PLAYER_ENTERING_WORLD" and ALWAYS[event] then
			Recorder:NoteLeaving()
		end
		return
	end
	local ok, err = pcall(HANDLERS[event], ...)
	if not ok then Log("|cffff4040" .. event .. ": " .. tostring(err) .. "|r") end
	if event == "PLAYER_ENTERING_WORLD" then Recorder:AutoRecord() end
end)
