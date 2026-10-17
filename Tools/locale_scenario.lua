-- The journal on a Russian client (Locales/ruRU.lua, Locales/ruRU_content.lua), checked against
-- the English it is laid over, and clicked through so a translation cannot break a page.
local ns = ...
local Mock = WOWMOCK
local L, english = ns.L, Mock.english
local checks = 0

local function check(condition, message)
	checks = checks + 1
	if not condition then error("check failed: " .. message, 2) end
end

-- Cyrillic letters, as UTF-8 writes them.
local function IsRussian(text)
	return type(text) == "string" and text:find("[\208\209]") ~= nil
end

check(GetLocale() == "ruRU", "a Russian client")
Mock.Fire("ADDON_LOADED", "Aegis_Forever_Instance_Journal")
Mock.Fire("PLAYER_LOGIN")

-- A translation takes the same values as the English, in the same order: string.format would
-- fail on a code too many, or put a name where a number goes.
local CODE = "%%[%-+ #0]*%d*%.?%d*[cdiouxXeEfgGqs%%]"
local function Codes(text)
	local codes = {}
	for code in text:gmatch(CODE) do codes[#codes + 1] = code end
	return table.concat(codes, " ")
end
local translated, wrong = 0, {}
for key, value in pairs(english) do
	local russian = L[key]
	if type(value) == "string" and type(russian) == "string" and russian ~= value then
		translated = translated + 1
		if Codes(russian) ~= Codes(value) then
			wrong[#wrong + 1] = key .. " (" .. Codes(value) .. " | " .. Codes(russian) .. ")"
		end
	end
end
table.sort(wrong)
check(#wrong == 0, "each translated string takes the English one's values: " .. table.concat(wrong, ", "))
check(translated > 100 and IsRussian(L.TAB_RECORD) and IsRussian(L.JOURNAL_TITLE),
	"the interface is in Russian: " .. translated .. " strings")
check(IsRussian(ns.LEVEL_BRACKETS[1].text) and ns.LEVEL_BRACKETS[2].text:find("30", 1, true),
	"the level menu too: " .. tostring(ns.LEVEL_BRACKETS[2].text))
-- The Gear Finder's specs and the units their weights count in, named by the translation while
-- the generated weights stay English
local untranslated = {}
for _, class in pairs(ns.GEAR_WEIGHTS) do
	for _, spec in ipairs(class.order) do
		if not IsRussian(L.GEAR_SPEC_NAMES[spec] or "") then untranslated[#untranslated + 1] = spec end
		if not IsRussian(L.GEAR_UNITS[class[spec].unit] or "") then untranslated[#untranslated + 1] = class[spec].unit end
	end
end
local IS = ns.ItemScore
check(#untranslated == 0 and IsRussian(IS:SpecLabel(IS:Specs()[1].key)) and IsRussian(IS:SpecUnit(IS:Specs()[1].key))
	and ns.GEAR_WEIGHTS.WARRIOR.Arms.label == "Arms",
	"every spec and unit of the Gear Finder in Russian, the weights themselves untouched: " .. table.concat(untranslated, ", "))

-- The content: names laid over the data once it has loaded.
local ragefire = ns.GetInstance("RagefireChasm")
check(IsRussian(ragefire.name), "dungeon names in Russian: " .. tostring(ragefire.name))
local bosses, russianBosses = 0, 0
for _, kind in ipairs({ "dungeon", "raid" }) do
	for _, instance in ipairs(ns.GetInstances(kind)) do
		for _, boss in ipairs(instance.bosses or {}) do
			bosses = bosses + 1
			if IsRussian(boss.name) then russianBosses = russianBosses + 1 end
		end
	end
end
check(russianBosses > bosses / 2, "most boss names in Russian: " .. russianBosses .. " of " .. bosses)
check(ns.GetInstance("RagefireChasm").enName == "Ragefire Chasm" and ns.GetInstance("TheDeadmines").bosses[1].enName
	and not IsRussian(ns.GetInstance("TheDeadmines").bosses[1].enName),
	"each keeps its English name, which the journal matches and records by")
check(ns.GetInstance("ScarletMonasteryLibrary").name:find(":", 1, true),
	"Scarlet Monastery's wings named 'building: wing', as its shared door reads them")
check(L.STRINGS == nil and L.BOSS_NAMES == nil, "the lookup tables let go once used")

-- A route's note follows its destination's new name
local noted = 0
for _, spot in ipairs(ns.GetTransports()) do
	for _, destination in ipairs(spot.to or {}) do
		local note = spot.notes and spot.notes[destination]
		if note then
			noted = noted + 1
			check(IsRussian(destination) and IsRussian(note), "a route's note under its translated destination: " .. destination)
		end
	end
end
check(noted >= 3, "the Skyborne routes keep their notes: " .. noted)

-- A faction is found by the client's English name as by its Russian one
local faction, listed
for _, candidate in ipairs(ns.GetFactions()) do
	for _, standing in ipairs(candidate.bosses or {}) do
		for _, row in ipairs(standing.loot or {}) do
			if not listed and not row.seen and not row.listed and type(row.itemID) == "number" then
				faction, listed = candidate, row.itemID
			end
		end
	end
end
check(faction and IsRussian(faction.name) and ns.FactionListsItem(faction.enName, listed)
	and ns.FactionListsItem(faction.name, listed), "a faction is found by its English and its Russian name")

-- Every page, in Russian: each tab, and each dungeon, raid and faction with its bosses.
ns.Journal:Show()
local f = AegisJournalFrame
for _, tab in ipairs(f.Tabs) do tab:Click() end
local page = ns.Journal:Page()
local opened = 0
for _, kind in ipairs({ "dungeon", "raid", "faction" }) do
	for _, instance in ipairs(ns.GetInstances(kind)) do
		ns.Journal:OpenInstance(instance)
		for _, tab in ipairs(page.Tabs or {}) do tab:Click() end
		for _, boss in ipairs(instance.bosses or {}) do
			if not boss.trash then
				ns.Journal:OpenBoss(instance, boss)
				for _, tab in ipairs(page.Tabs or {}) do tab:Click() end
				opened = opened + 1
			end
		end
	end
end
check(opened > 100, "every boss page opens in Russian: " .. opened)
check(#ns.Search:Find(ragefire.name) > 0, "search finds a dungeon by its Russian name")

-- The Excavation Site's quests, corrected by hand over the guides': their notes and where each
-- starts, still in Russian.
local english = {}
for _, quest in ipairs(ns.GetInstance("ExcavationSiteWetlands").quests) do
	for _, text in ipairs({ quest.note or "", quest.startMap and quest.startMap.label or "" }) do
		if text ~= "" and not IsRussian(text) then english[#english + 1] = quest.questID .. ": " .. text end
	end
end
check(#english == 0, "the Excavation Site's quest notes and starting places in Russian: " .. table.concat(english, "; "))
f:Hide()

return string.format("All %d Russian checks passed (%d strings; %d of %d boss names in Russian).",
	checks, translated, russianBosses, bosses)
