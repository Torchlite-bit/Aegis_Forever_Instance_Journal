local _, ns = ...
local L = ns.L

--[[
	/aegis perf: what the journal costs in the game itself, beside the other journal addons
	the player may have loaded.

	Memory is the client's own count for each addon. Times are milliseconds per operation,
	averaged over several runs with the journal really drawing: opening it, every dungeon on
	every side tab, every faction, and redrawing a loot page. The journal is put back the way
	it was afterwards.
]]

local Perf = {}
ns.Perf = Perf

local OTHERS = { "ForeverDungeonJournal", "AlexAtlasLoot", "AdventureGuideClassic", "MapUtils" }

local function IsLoaded(name)
	local loaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded
	if type(loaded) ~= "function" then return false end
	local ok, result = pcall(loaded, name)
	return ok and result and true or false
end

local function MemoryKB(name)
	local get = (C_AddOns and C_AddOns.GetAddOnMemoryUsage) or GetAddOnMemoryUsage
	if type(get) ~= "function" then return nil end
	local ok, kb = pcall(get, name)
	return ok and kb or nil
end

local function FirstBoss(instance)
	for _, boss in ipairs(instance.bosses) do
		if not boss.trash then return boss end
	end
	return nil
end

-- Milliseconds per run of fn.
local function Time(times, fn)
	local start = debugprofilestop()
	for _ = 1, times do fn() end
	return (debugprofilestop() - start) / times
end

local function Readable(fn, ...)
	if type(fn) ~= "function" then return nil end
	local ok, a, b, c = pcall(fn, ...)
	if not ok then return nil end
	return ns.Readable(a), ns.Readable(b), ns.Readable(c)
end

--[[
	/aegis where: where the player stands, as the journal's map data needs it: the map and
	the position on it, the area's name, and the height (which tells a level below a city
	from the streets above it). Each reading is also kept in the saved file, under "where".
]]
function Perf:Where()
	local mapID, x, y = ns.PlayerMapPosition()
	local info = mapID and Readable(C_Map.GetMapInfo, mapID)
	local area = Readable(GetSubZoneText) or ""
	local minimap = Readable(GetMinimapZoneText) or ""
	local _, _, height = Readable(UnitPosition, "player")
	ns.Print(string.format(L.WHERE, tostring(mapID), info and info.name or "?", x or 0, y or 0, area, minimap,
		height and string.format("%.1f", height) or "?"))
	ns.db.where = ns.db.where or {}
	table.insert(ns.db.where, { mapID = mapID, x = x, y = y, area = area, minimap = minimap, height = height,
		at = date("%Y-%m-%d %H:%M:%S") })
end

--[[
	/aegis taxi: what the client knows of the flight points on the player's map, before the
	world map is given flight points and transport icons: whether the map shows them by
	itself, how many it knows, and which of retail's travel icons the client has. Each reading
	is also kept in the saved file, under "taxi".
]]
local TRAVEL_ATLASES = {
	"FlightPath", "TaxiNode_Continent_Neutral", "TaxiNode_Continent_Alliance", "TaxiNode_Continent_Horde",
	"MagePortalAlliance", "MagePortalHorde",
}

function Perf:Taxi()
	local mapID = ns.PlayerMapPosition()
	local taxi = C_TaxiMap or {}
	local shows = mapID and Readable(taxi.ShouldMapShowTaxiNodes, mapID)
	local nodes = mapID and Readable(taxi.GetTaxiNodesForMap, mapID)
	local count, discovered, sample = 0, 0, {}
	for _, node in ipairs(type(nodes) == "table" and nodes or {}) do
		count = count + 1
		if not node.isUndiscovered then discovered = discovered + 1 end
		if #sample < 3 then
			sample[#sample + 1] = string.format("%s [%s]", tostring(node.name), tostring(node.atlasName or node.textureKit))
		end
	end
	local atlases = {}
	for _, atlas in ipairs(TRAVEL_ATLASES) do
		atlases[#atlases + 1] = atlas .. " " .. (ns.AtlasExists(atlas) and L.YES or L.NO)
	end
	ns.Print(string.format(L.TAXI, tostring(mapID), tostring(shows), count, discovered, table.concat(sample, ", ")))
	ns.Print(string.format(L.TAXI_ATLASES, table.concat(atlases, ", ")))
	ns.db.taxi = ns.db.taxi or {}
	table.insert(ns.db.taxi, { mapID = mapID, shows = shows, count = count, discovered = discovered,
		sample = sample, atlases = atlases, at = date("%Y-%m-%d %H:%M:%S") })
end

--[[
	/aegis items: asks the server about every item the journal lists, a few at a time, and once
	the answers have had time to come back, reports the items it never described. The client
	knows their icon and slot, but the server has nothing on them: most likely they are not in
	Forever yet. The list is kept in the saved file, under "missingItems", each with where the
	journal lists it, and comes along when a tester presses Copy on the Record tab.
]]
local ITEMS_PER_STEP, STEP_SECONDS, ANSWER_SECONDS, SHOWN_IN_CHAT = 25, 0.25, 20, 20
local scanningItems = false

-- Where each listed item drops, in English for the saved file and the recording it goes out with,
-- and as the journal names it for the chat.
local function ListedItems()
	local where, shown, order = {}, {}, {}
	local function Add(itemID, source, shownSource)
		if ns.Items:IsIdentified(itemID) and not where[itemID] then
			where[itemID], shown[itemID] = source, shownSource
			order[#order + 1] = itemID
		end
	end
	local lists = {}
	for _, kind in ipairs({ "dungeon", "raid" }) do
		for _, instance in ipairs(ns.GetInstances(kind)) do lists[#lists + 1] = instance end
	end
	for _, faction in ipairs(ns.GetFactions()) do lists[#lists + 1] = faction end
	for _, list in ipairs(lists) do
		for _, boss in ipairs(list.bosses or {}) do
			for _, row in ipairs(boss.loot or {}) do
				Add(row.itemID, (boss.enName or boss.name) .. ", " .. (list.enName or list.name), boss.name .. ", " .. list.name)
			end
		end
	end
	return where, shown, order
end

function Perf:Items()
	if scanningItems then
		ns.Print(L.ITEMS_SCANNING)
		return
	end
	scanningItems = true
	local where, shown, order = ListedItems()
	local steps = math.ceil(#order / ITEMS_PER_STEP)
	ns.Print(string.format(L.ITEMS_START, #order, math.ceil(steps * STEP_SECONDS + ANSWER_SECONDS)))
	local function Finish()
		local missing, unknown = {}, {}
		for _, itemID in ipairs(order) do
			-- Asked again: an answer that came in since is kept.
			if not ns.Items:Get(itemID).link then
				missing[itemID] = where[itemID]
				unknown[#unknown + 1] = itemID
			end
		end
		ns.db.missingItems = { at = date("%Y-%m-%d %H:%M:%S"), checked = #order, items = missing }
		-- Hidden from now on, until the server or a recorded run confirms them.
		ns.Items:AddUnconfirmed(missing)
		if ns.LootPanel then ns.LootPanel:RefreshShown() end
		ns.Print(string.format(L.ITEMS_DONE, #order, #unknown))
		for index = 1, math.min(#unknown, SHOWN_IN_CHAT) do
			ns.Print(string.format(L.ITEMS_LINE, unknown[index], shown[unknown[index]]))
		end
		if #unknown > SHOWN_IN_CHAT then ns.Print(string.format(L.ITEMS_MORE, #unknown - SHOWN_IN_CHAT)) end
		scanningItems = false
	end
	local position = 1
	local function Next()
		for _ = 1, ITEMS_PER_STEP do
			local itemID = order[position]
			if not itemID then
				C_Timer.After(ANSWER_SECONDS, Finish)
				return
			end
			ns.Items:Get(itemID)
			position = position + 1
		end
		C_Timer.After(STEP_SECONDS, Next)
	end
	Next()
end

function Perf:Run()
	if InCombatLockdown() then
		ns.Print(L.PERF_COMBAT)
		return
	end
	local journal = ns.Journal
	local wasShown = journal:IsShown()
	local results = {}

	results[#results + 1] = { L.PERF_OPEN, Time(20, function()
		journal:Toggle()
		journal:Toggle()
	end) }
	journal:Show()
	local page = journal:Page()
	local previousTab = journal:SelectedTab()

	local dungeons = ns.GetInstances("dungeon")
	results[#results + 1] = { L.PERF_DUNGEON, Time(3, function()
		for _, instance in ipairs(dungeons) do journal:OpenInstance(instance) end
	end) / #dungeons }

	-- Each side tab on its own: switching to it on every dungeon's first boss, from another tab.
	local tabNames = { L.TAB_OVERVIEW, L.TAB_LOOT, L.TAB_ABILITIES, L.TAB_MODEL, L.TAB_QUESTS }
	for tab = 1, #tabNames do
		local total, count = 0, 0
		for _, instance in ipairs(dungeons) do
			local boss = FirstBoss(instance)
			if boss then
				journal:OpenBoss(instance, boss)
				ns.EncounterPage:SetTab(page, tab == 1 and 2 or 1)
				local start = debugprofilestop()
				ns.EncounterPage:SetTab(page, tab)
				total, count = total + debugprofilestop() - start, count + 1
			end
		end
		results[#results + 1] = { string.format(L.PERF_TAB, tabNames[tab]), total / math.max(1, count) }
	end

	local factions = ns.GetFactions()
	results[#results + 1] = { L.PERF_FACTION, Time(3, function()
		for _, faction in ipairs(factions) do journal:OpenInstance(faction) end
	end) / #factions }

	journal:OpenInstance(dungeons[1])
	ns.EncounterPage:SetTab(page, ns.EncounterPage.TAB_LOOT)
	results[#results + 1] = { L.PERF_LOOT, Time(50, function() ns.LootPanel:Refresh(page.Loot) end) }

	-- Back the way it was.
	ns.EncounterPage:SetTab(page, ns.EncounterPage.TAB_OVERVIEW)
	journal:SelectTab(previousTab)
	if not wasShown then journal:Toggle() end

	collectgarbage("collect")
	if type(UpdateAddOnMemoryUsage) == "function" then UpdateAddOnMemoryUsage() end
	ns.Print(L.PERF_HEADER)
	ns.Print(string.format(L.PERF_MEMORY, ns.name, MemoryKB(ns.name) or 0))
	for _, name in ipairs(OTHERS) do
		if IsLoaded(name) then ns.Print(string.format(L.PERF_MEMORY, name, MemoryKB(name) or 0)) end
	end
	if ns.perfBuildMS then ns.Print(string.format(L.PERF_TIME, L.PERF_BUILD, ns.perfBuildMS)) end
	if ns.perfBookMS then ns.Print(string.format(L.PERF_TIME, L.PERF_BOOK, ns.perfBookMS)) end
	for _, result in ipairs(results) do ns.Print(string.format(L.PERF_TIME, result[1], result[2])) end
end
