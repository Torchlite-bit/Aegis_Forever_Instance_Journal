local addonName, ns = ...

--[[
	The journal's data, registered by the files under Data/ as they load.

	Data/Instances holds each dungeon's own data, Data/Authored what is laid over it by hand,
	and Data/Generated what Tools/build_data.py writes (abilities, recorded fights). Adding a
	dungeon is one more ns.AddInstance file and its maps; nothing in the UI names a dungeon.
]]

local instances, byKey, byInstanceID = {}, {}, {}
-- Wings of one dungeon (Scarlet Monastery's) share the client's instance id: id -> { wing, ... }.
local wingsByInstanceID, lastWing = {}, {}
local factions = {}

-- Sorted lists handed out by GetInstances and GetFactions, kept until the data changes.
-- Callers read them and never change them.
local listCache, factionList = {}, nil
local function DataChanged()
	listCache, factionList = {}, nil
end

-- Art given as a list of files the client may have: the first it has, else nil.
local function FirstFile(candidates)
	if type(candidates) ~= "table" then return candidates end
	for _, file in ipairs(candidates) do
		if type(file) == "number" or ns.FileExists(file) then return file end
	end
	return nil
end

-- The picture of a dungeon that has none of its own (Media/DungeonPlaceholder, made by
-- Tools/make_raid_art.py): 2:1, cut like the raids' pictures.
local PLACEHOLDER_ART = "Interface\\AddOns\\" .. addonName .. "\\Media\\DungeonPlaceholder"

local function UsePlaceholderArt(instance)
	instance.buttonArt = PLACEHOLDER_ART
	instance.buttonArtCoords = { 0.047, 0.953, 0, 1 }
	instance.iconArtCoords = { 0.25, 0.75, 0, 1 }
	instance.loreArtCoords = { 0.083, 0.917, 0, 1 }
	instance.placeholderArt = true
end

local function IndexInstanceID(instance)
	local id = instance.instanceID
	local first = byInstanceID[id]
	if not first then
		byInstanceID[id] = instance
		return
	end
	local wings = wingsByInstanceID[id] or { first }
	wings[#wings + 1] = instance
	wingsByInstanceID[id] = wings
	for _, wing in ipairs(wings) do wing.sharesInstanceID = true end
end

--[[
	An item the sources name but give no id for yet (City of Dalaran's newest drops) is kept
	under its name: its itemID becomes "?" and the name, so lists, favourites and pins still tell
	it from the others. Items:IsIdentified tells the two kinds apart; such an item has no icon,
	link or tooltip of its own until a recording gives its id.
]]
local function KeyUnidentified(rows)
	for _, row in ipairs(rows or {}) do
		if not row.itemID then row.itemID = "?" .. (row.name or "") end
	end
end

--[[
	A floor drawn from the client's tiles may name candidates for them (dungeons whose map folders
	are not confirmed yet): the first the client has is kept. A dungeon with a floor the client
	has none for gets no map, rather than one with a blank level.
]]
local function ResolveTiles(instance)
	local floors = instance.map and instance.map.floors
	if not floors then return end
	for _, floor in ipairs(floors) do
		if type(floor.tiles) == "table" then
			local found
			for _, prefix in ipairs(floor.tiles) do
				if ns.FileExists(prefix .. "1") then
					found = prefix
					break
				end
			end
			if not found then
				instance.map.floors = nil
				return
			end
			floor.tiles = found
		end
	end
end

function ns.AddInstance(instance)
	DataChanged()
	assert(type(instance.key) == "string", "AddInstance: key is required")
	assert(not byKey[instance.key], "AddInstance: duplicate key " .. instance.key)
	instance.kind = instance.kind or "dungeon"
	instance.bosses = instance.bosses or {}
	instance.quests = instance.quests or {}
	ResolveTiles(instance)
	for _, boss in ipairs(instance.bosses) do KeyUnidentified(boss.loot) end
	for _, quest in ipairs(instance.quests) do KeyUnidentified(quest.rewards and quest.rewards.items) end
	instance.buttonImage = FirstFile(instance.buttonImage)
	instance.loreImage = FirstFile(instance.loreImage)
	instance.buttonArt = FirstFile(instance.buttonArt)
	if not instance.buttonArt then UsePlaceholderArt(instance) end
	instances[#instances + 1] = instance
	byKey[instance.key] = instance
	if instance.instanceID then IndexInstanceID(instance) end
end

local function FindBoss(instance, name)
	for _, boss in ipairs(instance.bosses) do
		if boss.name == name then return boss end
	end
	return nil
end

--[[
	Hand-written additions from Data/Authored, laid over the dungeon's own data:
	  bosses = { ["Boss Name"] = { field = value, ... } }  merged into that boss
	  bossOrder = { "Boss Name", ... }                       run order; unlisted bosses keep theirs, after
	  addQuests = { quest, ... }                             quests the dungeon's data lacks, added after
	                                                         its own (one it already has is left alone)
	  addBosses = { boss, ... }                              bosses the dungeon's data lacks, added before
	                                                         its trash (one it already has is left alone);
	                                                         added first, so the other fields can name them
	  questPatches = { [questID] = { field = value } }       merged into that quest
	  anything else                                          replaces the instance's field
]]
local function AddBosses(instance, bosses)
	for _, boss in ipairs(bosses) do
		if not FindBoss(instance, boss.name) then
			KeyUnidentified(boss.loot)
			boss.loot = boss.loot or {}
			local at = #instance.bosses + 1
			while at > 1 and instance.bosses[at - 1].trash do at = at - 1 end
			table.insert(instance.bosses, at, boss)
		end
	end
end

function ns.AmendInstance(key, patch)
	DataChanged()
	local instance = byKey[key]
	assert(instance, "AmendInstance: unknown instance " .. tostring(key))
	if patch.addBosses then AddBosses(instance, patch.addBosses) end
	for field, value in pairs(patch) do
		if field == "addBosses" then
			-- added above, before the fields that may name them
		elseif field == "bosses" then
			for name, bossPatch in pairs(value) do
				local boss = FindBoss(instance, name)
				assert(boss, "AmendInstance: " .. key .. " has no boss named " .. name)
				for bossField, bossValue in pairs(bossPatch) do boss[bossField] = bossValue end
				KeyUnidentified(boss.loot)
			end
		elseif field == "bossOrder" then
			local ordered, placed = {}, {}
			for _, name in ipairs(value) do
				local boss = FindBoss(instance, name)
				assert(boss, "AmendInstance: " .. key .. " has no boss named " .. name)
				ordered[#ordered + 1] = boss
				placed[boss] = true
			end
			for _, boss in ipairs(instance.bosses) do
				if not placed[boss] then ordered[#ordered + 1] = boss end
			end
			instance.bosses = ordered
		elseif field == "questPatches" then
			for questID, questPatch in pairs(value) do
				local quest
				for _, candidate in ipairs(instance.quests) do
					if candidate.questID == questID then quest = candidate end
				end
				assert(quest, "AmendInstance: " .. key .. " has no quest " .. tostring(questID))
				for questField, questValue in pairs(questPatch) do quest[questField] = questValue end
			end
		elseif field == "addQuests" then
			local known = {}
			for _, quest in ipairs(instance.quests) do known[quest.questID] = true end
			for _, quest in ipairs(value) do
				if not known[quest.questID] then
					instance.quests[#instance.quests + 1] = quest
					known[quest.questID] = true
				end
			end
		else
			instance[field] = value
		end
	end
end

--[[
	The bosses' abilities, recorded fights and adds (Data/Generated/Abilities.lua, from
	Tools/build_data.py): { [instance key] = { [boss name] = { abilities, adds, encounterID } } }.
	Loaded after every other data file; what a hand-written file already gave a boss is kept.
]]
function ns.SetAbilities(byInstance)
	for key, bosses in pairs(byInstance) do
		local instance = byKey[key]
		for name, found in pairs(instance and bosses or {}) do
			local boss = FindBoss(instance, name)
			if boss then
				if boss.abilities == nil then boss.abilities = found.abilities end
				if boss.adds == nil then boss.adds = found.adds end
				if boss.encounterID == nil then boss.encounterID = found.encounterID end
			end
		end
	end
end

--[[
	Factions are registered in the shape of an instance, a standing in place of a boss:
	{ key = "Faction529", kind = "faction", factionID, name, bosses = { standing, ... } },
	each standing { name, reaction, standing = true, loot = { { itemID }, ... } }. The journal
	then draws a faction's rewards the way it draws a dungeon's loot, filters and all.
]]
-- The original game's factions all have ids below 1000; those added since (WoW: Forever's
-- own, and the Season of Discovery ones it brought along) are numbered from 2500 up.
local FIRST_NEW_FACTION_ID = 1000

function ns.AddFactions(list)
	for _, entry in ipairs(list) do
		local faction = { key = "Faction" .. entry.factionID, kind = "faction", factionID = entry.factionID, name = entry.name,
			forever = entry.factionID >= FIRST_NEW_FACTION_ID or nil }
		faction.bosses = {}
		for _, standing in ipairs(entry.standings or {}) do
			local loot = {}
			for _, itemID in ipairs(standing.items or {}) do loot[#loot + 1] = { itemID = itemID } end
			faction.bosses[#faction.bosses + 1] = {
				name = _G["FACTION_STANDING_LABEL" .. tostring(standing.reaction)] or standing.name,
				reaction = standing.reaction, standing = true, loot = loot,
			}
		end
		ns.AddInstance(faction)
		factions[#factions + 1] = faction
	end
end

--[[
	A ware a reputation vendor was seen selling (the Record tab): added to that faction's rewards
	at the standing it needs, unless the journal lists it already. The faction is known by the
	name the vendor's tooltip gives; one the journal does not have is left alone.
]]
function ns.AddVendorReward(factionName, reaction, itemID)
	for _, faction in ipairs(factions) do
		if faction.name == factionName then
			local standing
			for _, candidate in ipairs(faction.bosses) do
				for _, row in ipairs(candidate.loot) do
					if row.itemID == itemID then return false end
				end
				if candidate.reaction == reaction then standing = candidate end
			end
			if not standing then
				standing = { name = _G["FACTION_STANDING_LABEL" .. tostring(reaction)] or tostring(reaction),
					reaction = reaction, standing = true, loot = {} }
				local at = #faction.bosses + 1
				while at > 1 and (faction.bosses[at - 1].reaction or 0) > reaction do at = at - 1 end
				table.insert(faction.bosses, at, standing)
			end
			standing.loot[#standing.loot + 1] = { itemID = itemID, seen = true }
			return true
		end
	end
	return false
end

-- Whether a faction's own rewards list an item (not counting wares a vendor was seen selling).
function ns.FactionListsItem(factionName, itemID)
	for _, faction in ipairs(factions) do
		if faction.name == factionName then
			for _, standing in ipairs(faction.bosses) do
				for _, row in ipairs(standing.loot) do
					if row.itemID == itemID and not row.seen then return true end
				end
			end
			return false
		end
	end
	return false
end

-- Whether any instance in the journal has a quest.
function ns.JournalHasQuest(questID)
	for _, instance in ipairs(instances) do
		for _, quest in ipairs(instance.quests) do
			if quest.questID == questID then return true end
		end
	end
	return false
end

function ns.GetInstance(key)
	return byKey[key]
end

-- The wing the player stands in: by the area's name (wingAreas), else by the map the client
-- puts them on; else the wing they were last seen in, else the first.
local function WingHere(instanceID, wings)
	local ok, area = pcall(GetSubZoneText)
	area = ok and ns.Readable(area) or nil
	for _, wing in ipairs(wings) do
		if area and wing.wingAreas and wing.wingAreas[area] then return wing end
	end
	local mapID = ns.PlayerMapPosition()
	for _, wing in ipairs(wings) do
		for _, floor in ipairs(mapID and wing.map and wing.map.floors or {}) do
			if floor.uiMapID == mapID then return wing end
		end
	end
	return lastWing[instanceID] or wings[1]
end

-- Every instance a client instance id stands for: the wings of one that has several.
function ns.GetInstancesByInstanceID(instanceID)
	return wingsByInstanceID[instanceID] or { byInstanceID[instanceID] }
end

-- The instance the player is standing in, from GetInstanceInfo's instance id.
function ns.GetInstanceByInstanceID(instanceID)
	local wings = wingsByInstanceID[instanceID]
	if not wings then return byInstanceID[instanceID] end
	local wing = WingHere(instanceID, wings)
	lastWing[instanceID] = wing
	return wing
end

local function ByLevelThenName(a, b)
	local levelA, levelB = a.levelMin or 0, b.levelMin or 0
	if levelA ~= levelB then return levelA < levelB end
	return a.name < b.name
end

-- Instances of one kind ("dungeon" or "raid"), lowest level first. A bracket of nil means all.
function ns.GetInstances(kind, bracket)
	local cacheKey = bracket and bracket.min and (kind .. ":" .. bracket.min .. "-" .. bracket.max) or kind
	local list = listCache[cacheKey]
	if list then return list end
	list = {}
	for _, instance in ipairs(instances) do
		-- A hidden one (hidden = true) keeps its data but stays out of every list, for now.
		if instance.kind == kind and not instance.hidden and ns.InstanceInBracket(instance, bracket) then
			list[#list + 1] = instance
		end
	end
	table.sort(list, ByLevelThenName)
	listCache[cacheKey] = list
	return list
end

-- An instance belongs to a bracket when their level ranges overlap.
function ns.InstanceInBracket(instance, bracket)
	if not bracket or not bracket.min then return true end
	local low, high = instance.levelMin, instance.levelMax or instance.levelMin
	if not low then return true end
	return low <= bracket.max and high >= bracket.min
end

--[[
	Areas below a zone that the client has no map of, such as Old Ironforge beneath Ironforge.
	The client reports the player's position there on the zone's own map, so each one has a
	picture and, from two readings taken in game (calibration: the same spot's position on
	the zone's map and on the picture), the rectangle of the zone's map the picture covers.
]]
local subMaps, subMapsByKey = {}, {}

function ns.AddSubMap(subMap)
	subMap.instances = subMap.instances or {}
	-- A place the client gives no position in (the Deeprun Tram) has no calibration, and so no
	-- bounds: it is known by its zone's name instead.
	if subMap.calibration then
		local a, b = subMap.calibration[1], subMap.calibration[2]
		local width = (a.map[1] - b.map[1]) / (a.picture[1] - b.picture[1])
		local height = (a.map[2] - b.map[2]) / (a.picture[2] - b.picture[2])
		local left, top = a.map[1] - a.picture[1] * width, a.map[2] - a.picture[2] * height
		subMap.bounds = { left = left, top = top, width = width, height = height }
	end
	subMaps[#subMaps + 1] = subMap
	subMapsByKey[subMap.key] = subMap
end

function ns.GetSubMaps()
	return subMaps
end

function ns.GetSubMap(key)
	return subMapsByKey[key]
end

--[[
	Transports written into the journal (Data/Authored/Transports.lua): boats, zeppelins,
	airships, trams and portals, in the shape /aegis travel saves them:
	{ kind, mapID, x, y, area, faction, to = { destination, ... }, notes = { [destination] = note } }.
]]
local transports = {}

function ns.AddTransports(list)
	for _, spot in ipairs(list) do
		spot.to = spot.to or {}
		transports[#transports + 1] = spot
	end
end

function ns.GetTransports()
	return transports
end

-- Factions with rewards, by name.
function ns.GetFactions()
	if not factionList then
		factionList = {}
		for _, faction in ipairs(factions) do factionList[#factionList + 1] = faction end
		table.sort(factionList, function(a, b) return a.name < b.name end)
	end
	return factionList
end
