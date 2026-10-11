-- Times the journal's heavy operations against the mock client and measures the memory they
-- take and the garbage they leave, for before/after comparisons of the addon's own Lua.
-- Run with: python Tools/smoke_test.py --perf
--
-- The mock draws nothing, so these numbers are the addon's own work only, not the client's
-- rendering: use them to compare versions, and /aegis perf for numbers in the game itself.
local ns, loadedKB = ...
local Mock = WOWMOCK
local results = {}

local function KB() return collectgarbage("count") end

-- Runs fn `times` times; records milliseconds per run and kilobytes of garbage per run.
local function Measure(label, times, fn)
	collectgarbage("collect")
	collectgarbage("stop")
	local before = KB()
	local start = os.clock()
	for _ = 1, times do fn() end
	local elapsed = (os.clock() - start) * 1000 / times
	local garbage = (KB() - before) / times
	collectgarbage("restart")
	results[#results + 1] = string.format("%-44s %9.3f ms %10.2f KB", label, elapsed, garbage)
end

Mock.Fire("ADDON_LOADED", "Aegis_Forever_Instance_Journal")
Mock.Fire("PLAYER_LOGIN")
collectgarbage("collect")
local afterLogin = KB()

Measure("Build the journal (first open)", 1, function() AegisJournal_Toggle() end)
local f = AegisJournalFrame
local dungeons = ns.GetInstances("dungeon")
Measure("Build the book (first dungeon opened)", 1, function() ns.Journal:OpenInstance(dungeons[1]) end)
f.Tabs[1]:Click()
collectgarbage("collect")
local afterBuild = KB()

Measure("Close and reopen the journal", 200, function()
	AegisJournal_Toggle()
	AegisJournal_Toggle()
end)

Measure("Switch between the four bottom tabs", 100, function()
	for index = 1, 4 do f.Tabs[index]:Click() end
end)

local page = ns.Journal:Page()
Measure("Open every dungeon on every side tab", 20, function()
	for _, instance in ipairs(dungeons) do
		ns.Journal:OpenInstance(instance)
		for tab = 1, 5 do page.Tabs[tab]:Click() end
	end
end)

ns.Journal:OpenInstance(ns.GetInstance("TheDeadmines"))
page.Tabs[2]:Click()
Measure("Redraw the Deadmines loot page", 300, function() ns.LootPanel:Refresh(page.Loot) end)

Measure("Item data arriving (20 events, loot page open)", 50, function()
	for itemID = 1, 20 do Mock.Fire("GET_ITEM_INFO_RECEIVED", itemID, true) end
end)

page.Tabs[5]:Click()
Measure("Quest log update (Quests tab open)", 300, function() Mock.Fire("QUEST_LOG_UPDATE") end)
page.Tabs[1]:Click()

local factions = ns.GetFactions()
f.Tabs[3]:Click()
Measure("Open every faction", 20, function()
	for _, faction in ipairs(factions) do ns.Journal:OpenInstance(faction) end
end)
f.Tabs[3]:Click()
Measure("Reputation gained (faction grid open)", 300, function() Mock.Fire("UPDATE_FACTION") end)

Measure("Zone changes while not recording", 1000, function()
	Mock.Fire("ZONE_CHANGED")
	Mock.Fire("ZONE_CHANGED_INDOORS")
end)

Mock.instance = { name = "The Hall of Thanes", id = 3065 }
Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
Measure("Open the world map inside Hall of Thanes", 200, function()
	OpenWorldMap()
	WorldMapFrame:Hide()
end)
Mock.instance = nil
Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
Measure("Browse 20 maps with the world map open", 50, function()
	OpenWorldMap(1415)
	for mapID = 1420, 1439 do WorldMapFrame:SetMapID(mapID) end
	WorldMapFrame:Hide()
end)

collectgarbage("collect")
local final = KB()

local lines = {
	string.format("%-44s %9s    %10s", "Operation", "time/run", "garbage/run"),
}
for _, line in ipairs(results) do lines[#lines + 1] = line end
lines[#lines + 1] = ""
lines[#lines + 1] = string.format("Memory: addon loaded %.0f KB, journal window %.0f KB more, %.0f KB more after all of the above",
	loadedKB, afterBuild - afterLogin, final - afterBuild)
return table.concat(lines, "\n")
