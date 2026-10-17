-- /aegis lang: the journal previewed in German on an English client. The saved choice is read
-- before the files load (the TOC's LoadSavedVariablesFirst), so the German translation lays itself
-- over the English and the journal opens in it. Run by Tools/smoke_test.py.
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

check(GetLocale() == "enUS" and ns.previewLocale == "deDE" and ns.Speaks("deDE") and not ns.Speaks("enUS")
	and not ns.Speaks("ruRU"), "an English client previewing German")
check(L.JOURNAL_TITLE ~= english.JOURNAL_TITLE and not L.JOURNAL_TITLE:find("[\208\209]"),
	"the journal's own words in German, not Russian: " .. tostring(L.JOURNAL_TITLE))
Mock.Fire("ADDON_LOADED", "Aegis_Forever_Instance_Journal")
Mock.Fire("PLAYER_LOGIN")
check(ns.GetInstance("BlackfathomDeeps").name ~= "Blackfathom Deeps", "the dungeons' names in German too")
check(Said(string.format(english.LANG_ON, "German")), "a reminder at login that the journal is previewed")
-- The journal opens in it, and its tabs work
ns.Journal:Toggle()
check(AegisJournalFrame:IsShown(), "the journal opens in the preview")
ns.Journal:OpenBoss(ns.GetInstance("BlackfathomDeeps"), ns.GetInstance("BlackfathomDeeps").bosses[1])
ns.Journal:Toggle()
-- The command
Mock.chat = {}
SlashCmdList.AEGISJOURNAL("lang fr")
check(ns.db.previewLocale == "frFR" and Said("French"), "/aegis lang fr: French from the next reload")
SlashCmdList.AEGISJOURNAL("lang klingon")
check(ns.db.previewLocale == "frFR" and Said("Now: German"), "an unknown language: the command's help, nothing changed")
SlashCmdList.AEGISJOURNAL("lang tw")
check(ns.db.previewLocale == "zhTW" and Said("fonts"), "Chinese: a word about its fonts")
SlashCmdList.AEGISJOURNAL("lang off")
check(ns.db.previewLocale == nil, "/aegis lang off: the client's language again")
return string.format("All %d preview checks passed (German on an English client).", checks)
