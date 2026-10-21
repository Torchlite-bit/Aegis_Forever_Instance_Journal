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
	zhTW = "Traditional Chinese", esES = "Spanish (Spain)", esMX = "Spanish (Latin America)",
	ptBR = "Brazilian Portuguese", koKR = "Korean" })[LOCALE]
-- A language's own script, as UTF-8 writes it: Cyrillic, the CJK ideographs, Hangul. German, French,
-- Spanish and Portuguese share English's letters: their text is told by not being the English it
-- replaces.
local SCRIPT = ({ ruRU = "[\208\209]", zhCN = "[\228-\233]", zhTW = "[\228-\233]", koKR = "[\234-\237]" })[LOCALE]
local function InLanguage(text, englishText)
	if type(text) ~= "string" or text == "" then return false end
	if SCRIPT then return text:find(SCRIPT) ~= nil end
	return englishText == nil or text ~= englishText
end

check(LANGUAGE ~= nil, "a client in a language the journal is translated into: " .. tostring(LOCALE))
-- The Excavation Site's quest notes and starting places as the data writes them, before the
-- translation is laid over them at ADDON_LOADED.
local excavationEnglish = {}
for _, quest in ipairs(ns.GetInstance("ExcavationSiteWetlands").quests) do
	excavationEnglish[quest.questID] = { note = quest.note, label = quest.startMap and quest.startMap.label }
end
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

-- The client's Equip: wordings, where the language gives them (Core/ItemScore.lua): each a pattern
-- Lua can run, for a stat the scoring knows, false (a line worth nothing) or a pair of stats.
if L.EQUIP_PATTERNS then
	local known = {}
	for _, key in ipairs({ "HOLY CRIT", "SPELL CRIT", "RANGED CRIT", "CRIT", "SPELL HIT", "HIT", "HEALING", "SPELL POWER",
		"SPELL DAMAGE", "CASTING REGEN", "SPELL PENETRATION", "RANGED ATTACK POWER", "FERAL ATTACK POWER", "ATTACK POWER",
		"MANA PER 5", "HEALTH PER 5", "DEFENSE", "DODGE", "PARRY", "BLOCK", "BLOCK VALUE", "HASTE", "HOLY DAMAGE",
		"FIRE DAMAGE", "FROST DAMAGE", "NATURE DAMAGE", "SHADOW DAMAGE", "ARCANE DAMAGE" }) do
		known[key] = true
	end
	local bad = {}
	for index, entry in ipairs(L.EQUIP_PATTERNS) do
		local pattern = type(entry[1]) == "string" and entry[1]:gsub("{n}", function() return "(%d+%.?%d*)" end)
		local ok = pattern and pcall(string.find, "equip", pattern)
		local keys = type(entry[2]) == "table" and entry[2] or { entry[2] }
		if entry[2] ~= false then
			for _, key in ipairs(keys) do ok = ok and known[key] == true end
		end
		if not ok then bad[#bad + 1] = index .. " " .. tostring(entry[1]) .. " " .. tostring(entry[2]) end
	end
	check(#L.EQUIP_PATTERNS > 20 and #bad == 0, "the client's Equip: wordings, each one usable: " .. table.concat(bad, "; "))
end
check(("\195\137"):lower() == "\195\137" and ("\208\154"):lower() == "\208\154",
	"letters lowered as the game does, ASCII only, so the wordings are tested as the client reads them")
-- Classic lines in the client's words: the stat and number each should give, nil for none.
local SAMPLES = ({
	deDE = { { "Erhöht Eure Chance, einen kritischen Treffer zu erzielen, um 1%.", "CRIT", 1 },
		{ "Erhöht den durch Zauber und magische Effekte zugefügten Schaden gegen Untote um bis zu 48." } },
	frFR = { { "Augmente vos chances d'infliger un coup critique de 1%.", "CRIT", 1 },
		{ "Augmente les dégâts et les soins produits par les sorts et effets magiques de 12 au maximum.", "SPELL POWER", 12 },
		{ "Augmente les dégâts infligés aux morts-vivants par les sorts et effets magiques de 48 au maximum." } },
	zhCN = { { "使你造成致命一击的几率提高1%。", "CRIT", 1 },
		{ "被击中时有2%的几率使所有小队成员的所有属性提高25点，持续1分钟。" } },
	ruRU = { { "Увеличивает урон, наносимый нежити магическими заклинаниями и эффектами, не более чем на 48 ед." } },
})[LOCALE] or {}
local misread = {}
for index, sample in ipairs(SAMPLES) do
	local itemID = 990900 + index
	Mock.itemInstant[itemID] = { "INVTYPE_NECK", 4, 0, "Miscellaneous" }
	Mock.itemsCached[itemID] = true
	Mock.itemLines[itemID] = { "Equip: " .. sample[1] }
	IS:Forget()
	local stats = IS:Read(Mock.ItemLink(itemID)).stats
	local right = sample[2] and stats[sample[2]] == sample[3] or (not sample[2] and next(stats) == nil)
	if not right then
		local got = {}
		for key, value in pairs(stats) do got[#got + 1] = key .. "=" .. value end
		misread[#misread + 1] = index .. " (" .. table.concat(got, ", ") .. ")"
	end
	Mock.itemLines[itemID], Mock.itemsCached[itemID] = nil, nil
end
IS:Forget()
check(#misread == 0, "classic Equip: lines read right in " .. LANGUAGE .. ": " .. table.concat(misread, "; "))

-- The rooms inside dungeons, in the client's words (Core/Areas.lua): each one the journal uses,
-- and found again by its translated name. Two English spellings of one room (Lower Blackrock
-- Spire's Tazz'Alaor and Tazz'Alor) may share it: either is found.
check(type(L.AREA_NAMES) == "table", "the rooms inside dungeons named in " .. LANGUAGE)
do
	local used, stray = {}, {}
	for _, name in ipairs(ns.AreaNamesUsed()) do used[name] = true end
	for english, translated in pairs(L.AREA_NAMES) do
		if not used[english] or L.AREA_NAMES[ns.AreaKey(translated)] ~= translated then stray[#stray + 1] = english end
	end
	check(#stray == 0, "every translated room is one the journal uses, and is found by its name: " .. table.concat(stray, ", "))
end

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
local library, graveyard = ns.GetInstance("ScarletMonasteryLibrary"), ns.GetInstance("ScarletMonasteryGraveyard")
local door = ns.DungeonMap.SharedDoorName({ library, graveyard })
check(door ~= library.location and library.name:sub(1, #door) == door and graveyard.name:sub(1, #door) == door,
	"the Scarlet Monastery's shared door is named after the building its wings share: " .. tostring(door))
local problem = string.format(L.RECORD_LOG_NO_ENTRANCE, library.name, "x")
local fine = {}
for _, key in ipairs({ "RECORD_LOG_ENTERED", "RECORD_LOG_AREA", "RECORD_LOG_PULL", "RECORD_LOG_KILL", "RECORD_LOG_WIPE",
	"RECORD_LOG_QUEST_OFFERED", "RECORD_LOG_QUEST_DONE", "RECORD_LOG_ENTRANCE" }) do
	if ns.RecordPanel.IsProblemLine(string.format(L[key], library.name)) then fine[#fine + 1] = key end
end
check(ns.RecordPanel.IsProblemLine(problem) and #fine == 0,
	"the record log marks a missed entrance, and no other line, as a problem: " .. table.concat(fine, ", "))

-- A route's note follows its destination's new name
local noted = 0
for _, spot in ipairs(ns.GetTransports()) do
	for _, destination in ipairs(spot.to or {}) do
		local note = spot.notes and spot.notes[destination]
		if note then
			noted = noted + 1
			check(InLanguage(note, "Skyborne only") and (not SCRIPT or InLanguage(destination)),
				"a route's note under its translated destination: " .. destination)
		end
	end
end
check(noted >= 2, "the Skyborne airship's two routes keep their notes: " .. noted)

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

-- A trade camp's reward keeps its cost's English beneath the translation, for Merchant's Favor's icon
do
	local ware
	for _, standing in ipairs(ns.GetInstance("Faction2587").bosses) do
		for _, row in ipairs(standing.loot or {}) do if row.enCost then ware = row end end
	end
	check(ware and ware.enCost:find("Merchant's Favor", 1, true) and InLanguage(ware.cost, ware.enCost)
		and ns.CostIcons(ware.enCost):find("|T135725:0:0:2:0|t", 1, true),
		"Merchant's Favor in " .. LANGUAGE .. ", and its icon: " .. tostring(ware and ware.cost))
end

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
		local was = excavationEnglish[quest.questID] or {}
		local englishText = text == quest.note and was.note or was.label
		-- A bare name ("Zaruk") is the same in German and French; anything longer is not.
		local bareName = not SCRIPT and not (englishText or ""):find("[%s,]")
		if text ~= "" and not bareName and not InLanguage(text, englishText) then
			untold[#untold + 1] = quest.questID .. ": " .. text
		end
	end
end
check(#untold == 0, "the Excavation Site's quest notes and starting places in " .. LANGUAGE .. ": " .. table.concat(untold, "; "))

-- A chain's steps, kept as quests of their own for their page (Data/Generated/QuestSteps.lua), are
-- named as the chains name them, in the language too
local renamed, stepsSeen = {}, 0
for _, instance in ipairs(ns.GetInstances("dungeon")) do
	for _, quest in ipairs(instance.quests or {}) do
		for _, step in ipairs(quest.prerequisites or {}) do
			local own = ns.GetQuestStep(step.questID)
			if own then
				stepsSeen = stepsSeen + 1
				if own.name ~= step.name then renamed[#renamed + 1] = step.questID .. ": " .. tostring(own.name) end
			end
		end
	end
end
check(stepsSeen > 100 and #renamed == 0, "each step's page named as its chain names it, in " .. LANGUAGE .. ": "
	.. table.concat(renamed, "; "))
f:Hide()

return string.format("All %d %s checks passed (%d strings; %d of %d boss names in %s).",
	checks, LANGUAGE, translated, named, bosses, LANGUAGE)
