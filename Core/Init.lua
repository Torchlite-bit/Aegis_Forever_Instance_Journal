local addonName, ns = ...
local L = ns.L

ns.name = addonName

BINDING_NAME_AEGISJOURNAL_TOGGLE = L.BINDING_TOGGLE

local BINDING = "AEGISJOURNAL_TOGGLE"
local DEFAULT_KEY = "SHIFT-J"

-- Actions Shift+J may already hold that are safe to take over: nothing at all, Blizzard's
-- own journal (which does not load on Forever), the two journals this one replaces, and
-- this journal's own binding from before it was renamed.
local REPLACEABLE_ACTIONS = {
	[""] = true,
	TOGGLEENCOUNTERJOURNAL = true,
	TOGGLE_ADVENTUREGUIDECLASSIC = true,
	FOREVERDUNGEONJOURNAL_TOGGLE = true,
	AEGISIJ_TOGGLE = true,
}

function ns.Print(message)
	DEFAULT_CHAT_FRAME:AddMessage("|cffffd100" .. L.JOURNAL_TITLE .. ":|r " .. message)
end

--[[
	Shift+J is offered once for each set of key bindings (the account's, and the character's
	when "Character Specific Key Bindings" is on), not forced. A key the player has already
	given to something else is left alone, and once a set has had the offer the player's own
	choices in the Key Bindings window always win.
]]
local events = CreateFrame("Frame")

local function ClaimDefaultKey()
	local set = GetCurrentBindingSet()
	ns.db.keyOfferedSets = ns.db.keyOfferedSets or {}
	if ns.db.keyOfferedSets[set] then return end
	if InCombatLockdown() then
		-- Bindings cannot change in combat: listen for its end only now, not all the time.
		events:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end
	ns.db.keyOfferedSets[set] = true

	if GetBindingKey(BINDING) then return end
	local current = GetBindingAction(DEFAULT_KEY) or ""
	if not REPLACEABLE_ACTIONS[current] then
		ns.Print(string.format(L.KEY_TAKEN, current))
		return
	end
	if SetBinding(DEFAULT_KEY, BINDING) then
		SaveBindings(set)
		ns.Print(L.KEY_CLAIMED)
	end
end

local function InitSavedVariables()
	AegisJournalDB = AegisJournalDB or {}
	AegisJournalCharDB = AegisJournalCharDB or {}
	ns.db = AegisJournalDB
	ns.charDB = AegisJournalCharDB
	ns.Recorder:Init()
	-- The player's own /aegis items scan hides what it found, as the built-in one does.
	if type(ns.db.missingItems) == "table" then ns.Items:AddUnconfirmed(ns.db.missingItems.items) end
end

-- Hidden items are asked about again a while after logging in, once a session.
local RECHECK_DELAY = 10

function AegisJournal_Toggle()
	ns.Journal:Toggle()
end

--[[
	/aegis lang <de|fr|ru|cn|tw|es|mx|pt|ko|en|off>: the journal in another of its languages from the next
	/reload, whatever the client's, to check a translation. Only its own words change: the game's
	names (spells, items, the client's own interface words) stay the client's. Saved for the
	account until /aegis lang off.
]]
local LANGUAGE_CODES = { de = "deDE", dede = "deDE", fr = "frFR", frfr = "frFR", ru = "ruRU", ruru = "ruRU",
	cn = "zhCN", zhcn = "zhCN", tw = "zhTW", zhtw = "zhTW", es = "esES", eses = "esES", mx = "esMX", esmx = "esMX",
	pt = "ptBR", ptbr = "ptBR", ko = "koKR", kr = "koKR", kokr = "koKR", en = "enUS", enus = "enUS" }
local LANGUAGE_NAMES = { deDE = "German", frFR = "French", ruRU = "Russian", zhCN = "Simplified Chinese",
	zhTW = "Traditional Chinese", esES = "Spanish (Spain)", esMX = "Spanish (Latin America)", ptBR = "Brazilian Portuguese",
	koKR = "Korean", enUS = "English" }

local function PreviewLanguage(typed)
	typed = ((typed or ""):lower():gsub("[^%a]", ""))
	if typed == "off" then
		ns.db.previewLocale = nil
		ns.Print(L.LANG_OFF)
		return
	end
	local code = LANGUAGE_CODES[typed]
	if not code then
		local now = ns.previewLocale or GetLocale()
		ns.Print(string.format(L.LANG_USAGE, LANGUAGE_NAMES[now] or now))
		return
	end
	ns.db.previewLocale = code
	ns.Print(string.format(L.LANG_SET, LANGUAGE_NAMES[code]))
	if code == "zhCN" or code == "zhTW" then ns.Print(L.LANG_FONTS) end
	if code == "koKR" then ns.Print(L.LANG_FONTS_KO) end
end

SLASH_AEGISJOURNAL1 = "/aegis"
SLASH_AEGISJOURNAL2 = "/instancejournal"
SLASH_AEGISJOURNAL3 = "/ij"
SlashCmdList.AEGISJOURNAL = function(message)
	-- The first word is the command; the rest keeps its capitals (place names).
	local command, rest = strtrim(message or ""):match("^(%S*)%s*(.-)$")
	command = command:lower()
	if command == "" then
		ns.Journal:Toggle()
	elseif command == "record" then
		ns.Recorder:Toggle()
	elseif command == "reset" then
		ns.Journal:ResetPosition()
		ns.Print(L.POSITION_RESET)
	elseif command == "perf" then
		ns.Perf:Run()
	elseif command == "where" then
		ns.Perf:Where()
	elseif command == "taxi" then
		ns.Perf:Taxi()
	elseif command == "items" then
		ns.Perf:Items()
	elseif command == "travel" then
		ns.TravelMap:Capture(rest)
	elseif command == "gear" then
		ns.Journal:ShowGear()
	elseif command == "weights" then
		ns.Journal:ShowGear()
		ns.GearPanel:ShowWeights(ns.GearPanel.panel, true)
	elseif command == "gearscan" then
		ns.GearFinder:Scan()
	elseif command == "options" then
		ns.Options:Open()
	elseif command == "areas" then
		ns.Areas:Scan()
	elseif command == "lang" then
		PreviewLanguage(rest)
	else
		ns.Print(L.SLASH_HELP)
	end
end

events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_LOGIN")
events:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" then
		if arg1 == addonName then
			InitSavedVariables()
			-- The content in the journal's language, where it has it. A mistake in a translation is
			-- reported, and the journal still opens. The quartermasters the player captured join
			-- their factions first, known by the client's names for them, so the translation covers
			-- what they add.
			local ok, problem = pcall(ns.KeepClientNames)
			if not ok then geterrorhandler()(problem) end
			ns.Recorder:ShareVendors()
			ok, problem = pcall(ns.ApplyLocale)
			if not ok then geterrorhandler()(problem) end
			self:UnregisterEvent("ADDON_LOADED")
		end
	elseif event == "PLAYER_LOGIN" then
		self:UnregisterEvent("PLAYER_LOGIN")
		ClaimDefaultKey()
		if ns.previewLocale then
			ns.Print(string.format(L.LANG_ON, LANGUAGE_NAMES[ns.previewLocale] or ns.previewLocale))
		elseif ns.db.previewLocale then
			ns.Print(L.LANG_UNAVAILABLE)
		end
		C_Timer.After(RECHECK_DELAY, function() ns.Items:RecheckUnconfirmed() end)
		-- Switching between the account's and the character's bindings brings another set.
		self:RegisterEvent("UPDATE_BINDINGS")
	elseif event == "UPDATE_BINDINGS" then
		ClaimDefaultKey()
	elseif event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		ClaimDefaultKey()
	end
end)
