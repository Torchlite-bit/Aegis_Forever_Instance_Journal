-- The journal on a client in another language (Locales/<code>.lua, Locales/<code>_content.lua),
-- checked against the English it is laid over, and clicked through so a translation cannot break
-- a page. Run once for each language the TOC lists (Tools/smoke_test.py).
local ns = ...
local Mock = WOWMOCK
local L, english = ns.L, Mock.english
local checks = 0

local function check(condition, message)
	checks = checks + 1
	if not condition then error("check failed: " .. message, 2) end
end

local LOCALE = GetLocale()
local LANGUAGE = ({ ruRU = "Russian", deDE = "German", frFR = "French", zhCN = "Simplified Chinese",
	zhTW = "Traditional Chinese" })[LOCALE]
-- A language's own script, as UTF-8 writes it: Cyrillic, the CJK ideographs. German and French
-- share English's letters: their text is told by not being the English it replaces.
local SCRIPT = ({ ruRU = "[\208\209]", zhCN = "[\228-\233]", zhTW = "[\228-\233]" })[LOCALE]
local function InLanguage(text, englishText)
	if type(text) ~= "string" or text == "" then return false end
	if SCRIPT then return text:find(SCRIPT) ~= nil end
	return englishText == nil or text ~= englishText
end

check(LANGUAGE ~= nil, "a client in a language the journal is translated into: " .. tostring(LOCALE))
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
	local given = L[key]
	if type(value) == "string" and type(given) == "string" and given ~= value then
		translated = translated + 1
		if Codes(given) ~= Codes(value) then
			wrong[#wrong + 1] = key .. " (" .. Codes(value) .. " | " .. Codes(given) .. ")"
		end
	end
end
table.sort(wrong)
check(#wrong == 0, "each translated string takes the English one's values: " .. table.concat(wrong, ", "))
check(translated > 100 and InLanguage(L.TAB_RECORD, english.TAB_RECORD) and InLanguage(L.JOURNAL_TITLE, english.JOURNAL_TITLE),
	"the interface is in " .. LANGUAGE .. ": " .. translated .. " strings")
check(InLanguage(ns.LEVEL_BRACKETS[1].text, english.LEVEL_ALL)
	and ns.LEVEL_BRACKETS[2].text:find("30", 1, true) ~= nil,
	"the level menu too: " .. tostring(ns.LEVEL_BRACKETS[2].text))
-- The Gear Finder's specs and the units their weights count in, named by the translation while
-- the generated weights stay English
local untranslated = {}
for _, class in pairs(ns.GEAR_WEIGHTS) do
	for _, spec in ipairs(class.order) do
		if not InLanguage(L.GEAR_SPEC_NAMES[spec]) then untranslated[#untranslated + 1] = spec end
		if not InLanguage(L.GEAR_UNITS[class[spec].unit]) then untranslated[#untranslated + 1] = class[spec].unit end
	end
end
local IS = ns.ItemScore
check(#untranslated == 0 and InLanguage(IS:SpecLabel(IS:Specs()[1].key)) and InLanguage(IS:SpecUnit(IS:Specs()[1].key))
	and ns.GEAR_WEIGHTS.WARRIOR.Arms.label == "Arms",
	"every spec and unit of the Gear Finder in " .. LANGUAGE .. ", the weights themselves untouched: "
	.. table.concat(untranslated, ", "))

-- The content: names laid over the data once it has loaded.
local ragefire = ns.GetInstance("RagefireChasm")
check(InLanguage(ragefire.name, ragefire.enName), "dungeon names in " .. LANGUAGE .. ": " .. tostring(ragefire.name))
local bosses, named = 0, 0
for _, kind in ipairs({ "dungeon", "raid" }) do
	for _, instance in ipairs(ns.GetInstances(kind)) do
		for _, boss in ipairs(instance.bosses or {}) do
			bosses = bosses + 1
			if InLanguage(boss.name, boss.enName) then named = named + 1 end
		end
	end
end
-- German and French keep many proper names as they are (Bazzalan, Gnomeregan's bosses).
check(named > bosses * (SCRIPT and 0.5 or 0.25), "boss names in " .. LANGUAGE .. ": " .. named .. " of " .. bosses)
local deadmines = ns.GetInstance("TheDeadmines")
check(ragefire.enName == "Ragefire Chasm" and deadmines.bosses[1].enName and (not SCRIPT or not deadmines.bosses[1].enName:find(SCRIPT)),
	"each keeps its English name, which the journal matches and records by")
check(ns.GetInstance("ScarletMonasteryLibrary").name:find(":", 1, true) or ns.GetInstance("ScarletMonasteryLibrary").name:find("\239\188\154", 1, true),
	"Scarlet Monastery's wings named 'building: wing', as its shared door reads them")
check(L.STRINGS == nil and L.BOSS_NAMES == nil, "the lookup tables let go once used")

-- A route's note follows its destination's new name
local noted = 0
for _, spot in ipairs(ns.GetTransports()) do
	for _, destination in ipairs(spot.to or {}) do
		local note = spot.notes and spot.notes[destination]
		if note then
			noted = noted + 1
			check(InLanguage(note, "Skyborne only"), "a route's note under its translated destination: " .. destination)
		end
	end
end
check(noted >= 3, "the Skyborne routes keep their notes: " .. noted)

-- A faction is found by the client's English name as by its translated one
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
check(faction and InLanguage(faction.name, faction.enName) and ns.FactionListsItem(faction.enName, listed)
	and ns.FactionListsItem(faction.name, listed), "a faction is found by its English and its " .. LANGUAGE .. " name")

-- Every page in the language: each tab, and each dungeon, raid and faction with its bosses.
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
check(opened > 100, "every boss page opens in " .. LANGUAGE .. ": " .. opened)
check(#ns.Search:Find(ragefire.name) > 0, "search finds a dungeon by its " .. LANGUAGE .. " name")

-- The Excavation Site's quests, corrected by hand over the guides': their notes and where each
-- starts, in the language too.
local untold = {}
for _, quest in ipairs(ns.GetInstance("ExcavationSiteWetlands").quests) do
	for _, text in ipairs({ quest.note or "", quest.startMap and quest.startMap.label or "" }) do
		if SCRIPT and text ~= "" and not InLanguage(text) then untold[#untold + 1] = quest.questID .. ": " .. text end
	end
end
check(#untold == 0, "the Excavation Site's quest notes and starting places in " .. LANGUAGE .. ": " .. table.concat(untold, "; "))
f:Hide()

return string.format("All %d %s checks passed (%d strings; %d of %d boss names in %s).",
	checks, LANGUAGE, translated, named, bosses, LANGUAGE)
