-- /aegis lang: the journal previewed in another language: German on an English client, Spanish
-- on a German one, and English on a Russian one. The saved choice is read before the files load (the TOC's
-- LoadSavedVariablesFirst), so the previewed translation lays itself over the English and the
-- journal opens in it, while what is matched against the client's own text (an item's Equip:
-- lines, the room the player stands in, a boss or a faction the client names) stays the client's.
-- Run by Tools/smoke_test.py.
local ns = ...
local Mock = WOWMOCK
local L, english = ns.L, Mock.english
local checks = 0

local function check(condition, message)
	checks = checks + 1
	if not condition then error("check failed: " .. message, 2) end
end

local function Said(pattern)
	for _, line in ipairs(Mock.chat) do
		if line:find(pattern, 1, true) then return true end
	end
	return false
end

local CLIENT, PREVIEW = GetLocale(), ns.previewLocale
local NAMES = { enUS = "English", deDE = "German", esES = "Spanish (Spain)", ruRU = "Russian" }
-- What each language calls Blackfathom Deeps, Anvilmar's Rest, Booty Bay (faction 21), Zephras
-- Isle and Anvilmar's Curse (Russian is a client here, never previewed).
local WORDS = {
	enUS = { dungeon = "Blackfathom Deeps", room = "Anvilmar's Rest", faction = "Booty Bay", isle = "Zephras Isle",
		curse = "Anvilmar's Curse" },
	deDE = { dungeon = "Tiefschwarze Grotte", room = "Ambossars Ruhest\195\164tte", faction = "Beutebucht",
		isle = "Insel Zephras", curse = "Ambossars Fluch" },
	esES = { dungeon = "Cavernas de Brazanegra", room = "Reposo de Yunquemar", faction = "Bah\195\173a del Bot\195\173n",
		isle = "Isla de Zephras", curse = "Maldici\195\179n de Yunquemar" },
	ruRU = { room = "Покой Анвилмара", faction = "Пиратская Бухта", isle = "Остров Зефрас", curse = "Проклятие Анвилмара" },
}
-- An Equip: line in each client's words, worth 1% critical strike.
local CRIT_LINE = {
	enUS = "Equip: Improves your chance to get a critical strike by 1%.",
	deDE = "Equip: Erh\195\182ht Eure Chance, einen kritischen Treffer zu erzielen, um 1%.",
	ruRU = "Equip: Повышает вероятность нанесения критического удара на 1%.",
}
local client, preview = WORDS[CLIENT], WORDS[PREVIEW]
-- Previewing English on a translated client: the journal's words are the English ones.
local INTO_ENGLISH = PREVIEW == "enUS"
check(client and preview and CLIENT ~= PREVIEW and ns.Speaks(PREVIEW) and not ns.Speaks(CLIENT)
	and (CLIENT == "ruRU" or not ns.Speaks("ruRU")), "a client previewing another language: " .. tostring(CLIENT) .. " "
	.. tostring(PREVIEW))
check((L.JOURNAL_TITLE ~= english.JOURNAL_TITLE) ~= INTO_ENGLISH and not L.JOURNAL_TITLE:find("[\208\209]"),
	"the journal's own words in the previewed language, not the client's or Russian: " .. tostring(L.JOURNAL_TITLE))
Mock.Fire("ADDON_LOADED", "Aegis_Forever_Instance_Journal")
Mock.Fire("PLAYER_LOGIN")
local blackfathom = ns.GetInstance("BlackfathomDeeps")
check(blackfathom.name == preview.dungeon, "the dungeons' names in the previewed language too: " .. blackfathom.name)
check(Said(string.format(L.LANG_ON, NAMES[PREVIEW])) and (L.LANG_ON ~= english.LANG_ON) ~= INTO_ENGLISH,
	"a reminder at login that the journal is previewed, in the previewed language")

-- The client's own text, matched in the client's language
check(L.EQUIP_PATTERNS == nil and L.AREA_NAMES == nil, "the previewed language's client tables not taken up")
check((ns.ClientL.EQUIP_PATTERNS ~= nil) == (CLIENT ~= "enUS") and (ns.ClientL.AREA_NAMES ~= nil) == (CLIENT ~= "enUS"),
	"the client's own language's tables kept, where it has them")
do
	local IS, NECK = ns.ItemScore, 990901
	Mock.itemInstant[NECK] = { "INVTYPE_NECK", 4, 0, "Miscellaneous" }
	Mock.itemsCached[NECK] = true
	Mock.itemLines[NECK] = { CRIT_LINE[CLIENT] }
	IS:Forget()
	check(IS:Read(Mock.ItemLink(NECK)).stats.CRIT == 1, "an item's Equip: line read in the client's words")
	Mock.itemLines[NECK], Mock.itemsCached[NECK] = nil, nil
	IS:Forget()
end
check(ns.AreaKey(client.room) == "Anvilmar's Rest" and ns.AreaName("Anvilmar's Rest") == client.room,
	"the room the client names found by the client's name for it: " .. tostring(ns.AreaName("Anvilmar's Rest")))
check(CLIENT == "enUS" or INTO_ENGLISH or ns.AreaKey(preview.room) ~= "Anvilmar's Rest", "not by the previewed language's")
local booty
for _, faction in ipairs(ns.GetFactions()) do
	if faction.factionID == 21 then booty = faction end
end
check(booty and booty.name == preview.faction and ns.NamedAs(booty, client.faction) and ns.NamedAs(booty, "Booty Bay")
	and (CLIENT == "enUS") == (booty.clientName == nil),
	"a faction a ware's tooltip names found by the client's name, shown in the previewed language")
-- A quartermaster the player captured earlier (Tools/smoke_test.py saves him), his wares' faction
-- named in the client's words: the one Booty Bay lacked joins it as the journal loads, and the
-- Record tab counts only it as new, the other being one Booty Bay lists already.
local joined = false
for _, standing in ipairs(booty.bosses) do
	for _, row in ipairs(standing.loot) do
		if row.itemID == 990950 and row.seen then joined = true end
	end
end
check(joined, "the player's own captured ware joins the faction its tooltip names in the client's words")
local caught = ns.Recorder:Catch().vendors[1]
check(caught and caught.wares == 2 and caught.new == 1, "and only it counts as new: "
	.. tostring(caught and caught.new) .. " of " .. tostring(caught and caught.wares))
-- A route the player saved in the client's words, with a note of their own (Tools/smoke_test.py),
-- at a dock the journal has under the previewed language's: one route, with the player's note.
OpenWorldMap(1416)
local dock
for _, pin in ipairs(WorldMapFrame:ActivePins("AegisJournalTransportPinTemplate")) do
	if pin.spot.kind == "airship" then dock = pin end
end
check(dock and #dock.spot.to == 1 and dock.spot.to[1] == preview.isle and dock.spot.notes[preview.isle] == "Saved note",
	"a saved route the journal has already, under another language's name, shown once with its note: "
	.. (dock and table.concat(dock.spot.to, ", ") .. " / " .. tostring(dock.spot.notes[preview.isle]) or "no dock"))
WorldMapFrame:Hide()
-- An ability is found by the client's name for its spell, which its page shows, and by the journal's.
-- The name a search shows it under.
local function FoundCurse(text)
	for _, entry in ipairs(ns.Search:Find(text)) do
		if entry.kind == "ability" and entry.spellID == 1292602 then return entry.shownName end
	end
end
local byClient, byJournal = FoundCurse("Anvilmar's Curse"), FoundCurse(preview.curse)
check(byClient == "Anvilmar's Curse" and byJournal == preview.curse,
	"an ability found by the client's spell name and by the previewed one: " .. tostring(byClient) .. ", " .. tostring(byJournal))
local bosses, enNamed, clientNamed, apart = 0, 0, 0, 0
for _, kind in ipairs({ "dungeon", "raid" }) do
	for _, instance in ipairs(ns.GetInstances(kind)) do
		for _, boss in ipairs(instance.bosses or {}) do
			bosses = bosses + 1
			if boss.enName then enNamed = enNamed + 1 end
			if boss.clientName then
				clientNamed = clientNamed + 1
				if boss.clientName ~= boss.name then apart = apart + 1 end
			end
		end
	end
end
-- German and Spanish keep many proper names alike (Ghamoo-ra): some differ.
check(bosses > 0 and enNamed == bosses and (CLIENT == "enUS") == (clientNamed == 0) and (CLIENT == "enUS") == (apart == 0),
	"each boss keeps its English name, and the client's where it has one: " .. enNamed .. " of " .. bosses .. ", "
	.. clientNamed .. " named by the client, " .. apart .. " unlike the preview")
-- A fight the journal holds no encounter id for, ended under the client's name for its boss
do
	local dig = ns.GetInstance("ExcavationSiteWetlands")
	local saltspine
	for _, boss in ipairs(dig.bosses) do
		if boss.enName == "Saltspine" then saltspine = boss end
	end
	Mock.instance = nil
	Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
	Mock.instance = { name = "Excavation Site: Wetlands", id = dig.instanceID }
	Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
	local name = CLIENT == "enUS" and saltspine.enName or saltspine.clientName
	Mock.Fire("ENCOUNTER_END", 999999, name, 1, 5, 1)
	check(name and ns.DungeonMap:IsDefeated(dig, saltspine), "a boss marked by the client's name for his fight: " .. tostring(name))
	Mock.instance = nil
	Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
end
local header = ns.Recorder:Export("Tester"):match("^[^\n]*")
check(header:find("^AEGIS RECORDING;") and header:sub(-#(";Tester;" .. CLIENT .. ";" .. PREVIEW)) == ";Tester;" .. CLIENT .. ";" .. PREVIEW,
	"a recording says the client's language and the previewed one: " .. header)

-- Role alerts read from an ability's English name, whatever language shows it: Faldrim Anvilmar's
-- Anvilmar's Curse, nobody having written its alerts, its description left out here.
local faldrim, cursed
for _, boss in ipairs(ns.GetInstance("HallOfThanes").bosses) do
	if boss.enName == "Faldrim Anvilmar" then faldrim = boss end
end
local description = Mock.spells[1292602].description
Mock.spells[1292602].description = nil
for _, section in ipairs(ns.AbilitiesPanel:BuildSections(faldrim)) do
	for _, flag in ipairs(section.spellID == 1292602 and section.flags or {}) do
		if flag == "Curse" then cursed = true end
	end
end
Mock.spells[1292602].description = description
check(cursed, "Anvilmar's Curse's Curse alert, read from its English name")

-- A boss who ends no encounter (the Excavation Site's Highland Horror), lying dead under the name
-- the client gives him, is marked.
do
	local dig = ns.GetInstance("ExcavationSiteWetlands")
	local horror
	for _, boss in ipairs(dig.bosses) do
		if boss.enName == "Highland Horror" then horror = boss end
	end
	local name = CLIENT == "enUS" and horror.enName or horror.clientName
	check(horror and name and not horror.encounterID and not horror.npcID and (CLIENT == "enUS" or name ~= horror.name),
		"the Highland Horror, named by the client otherwise than by the preview: " .. tostring(name))
	Mock.instance = nil
	Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
	Mock.instance = { name = "Excavation Site: Wetlands", id = dig.instanceID }
	Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
	Mock.units.target = { name = name, guid = "Creature-0-1-2998-1-260999-0000F00002", dead = true }
	Mock.Fire("PLAYER_TARGET_CHANGED")
	check(ns.DungeonMap:IsDefeated(dig, horror), "marked, lying dead as the target, by the client's name for him: " .. name)
	Mock.units.target, Mock.instance = nil, nil
	Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
end

-- What goes out in a recording or the saved file is in English, with the client's language and
-- the previewed one noted.
-- One of Ragefire Chasm's drops the client has described, for a level-15 player.
local level, drop = Mock.level, ns.GetInstance("RagefireChasm").bosses[1].loot[1].itemID
Mock.level, Mock.itemInstant[drop], Mock.itemsCached[drop] = 15, { "INVTYPE_NECK", 4, 0, "Miscellaneous" }, true
SlashCmdList.AEGISJOURNAL("gearscan")
Mock.level, Mock.itemInstant[drop], Mock.itemsCached[drop] = level, nil, nil
local gearScan = ns.db.gearScan
local ragefire = ns.GetInstance("RagefireChasm")
local dropLabel = gearScan.drops[1] and gearScan.drops[1].label
check(gearScan.locale == CLIENT and gearScan.preview == PREVIEW, "a gear scan notes the client's language and the previewed one")
check(#gearScan.drops == 1 and dropLabel == "Ragefire Chasm / " .. (ragefire.bosses[1].enName or ragefire.bosses[1].name),
	"and names its drops' dungeon and boss in English: " .. tostring(dropLabel))
Mock.chat = {}
SlashCmdList.AEGISJOURNAL("items")
local missing = ns.db.missingItems
check(missing and missing.items[19507] == "High Inquisitor Fairbanks, Scarlet Monastery: Cathedral",
	"the items a scan finds missing are named in English in the saved file: " .. tostring(missing and missing.items[19507]))
-- In the chat, as the journal names them: where each item is listed first.
do
	local shownWhere, lists = {}, {}
	for _, kind in ipairs({ "dungeon", "raid" }) do
		for _, instance in ipairs(ns.GetInstances(kind)) do lists[#lists + 1] = instance end
	end
	for _, faction in ipairs(ns.GetFactions()) do lists[#lists + 1] = faction end
	for _, list in ipairs(lists) do
		for _, boss in ipairs(list.bosses or {}) do
			for _, row in ipairs(boss.loot or {}) do
				shownWhere[row.itemID] = shownWhere[row.itemID] or boss.name .. ", " .. list.name
			end
		end
	end
	-- The chat line's wording, its item and place caught.
	local pattern = L.ITEMS_LINE:gsub("[%(%)%.%+%-%*%?%[%]%^%$]", "%%%0"):gsub("%%d", "(%%d+)"):gsub("%%s", "(.+)") .. "$"
	local lines, wrong, apartFromEnglish = 0, {}, 0
	for _, line in ipairs(Mock.chat) do
		local itemID, where = line:match(pattern)
		itemID = tonumber(itemID)
		if itemID then
			lines = lines + 1
			if where ~= shownWhere[itemID] then wrong[#wrong + 1] = itemID .. " " .. where end
			if where ~= missing.items[itemID] then apartFromEnglish = apartFromEnglish + 1 end
		end
	end
	check(lines > 0 and #wrong == 0 and (apartFromEnglish > 0) ~= INTO_ENGLISH,
		"the chat names them as the journal does: " .. lines .. " lines; " .. table.concat(wrong, "; "))
end

-- The journal opens in it, and its tabs work
ns.Journal:Toggle()
check(AegisJournalFrame:IsShown(), "the journal opens in the preview")
ns.Journal:OpenBoss(blackfathom, blackfathom.bosses[1])
ns.Journal:Toggle()
-- The command
Mock.chat = {}
SlashCmdList.AEGISJOURNAL("lang fr")
check(ns.db.previewLocale == "frFR" and Said("French"), "/aegis lang fr: French from the next reload")
SlashCmdList.AEGISJOURNAL("lang klingon")
check(ns.db.previewLocale == "frFR" and Said(string.format(L.LANG_USAGE, NAMES[PREVIEW])),
	"an unknown language: the command's help, in the previewed language, nothing changed")
SlashCmdList.AEGISJOURNAL("lang tw")
check(ns.db.previewLocale == "zhTW" and Said(L.LANG_FONTS), "Chinese: a word about its fonts")
local codes = {}
for typed, code in pairs({ es = "esES", mx = "esMX", pt = "ptBR", ko = "koKR" }) do
	SlashCmdList.AEGISJOURNAL("lang " .. typed)
	if ns.db.previewLocale ~= code then codes[#codes + 1] = typed end
end
check(#codes == 0 and Said(L.LANG_FONTS_KO), "/aegis lang es, mx, pt and ko, Korean with its word about fonts: "
	.. table.concat(codes, ", "))
SlashCmdList.AEGISJOURNAL("lang off")
check(ns.db.previewLocale == nil, "/aegis lang off: the client's language again")
return string.format("All %d preview checks passed (%s previewed on a client in %s).", checks, NAMES[PREVIEW], NAMES[CLIENT])
