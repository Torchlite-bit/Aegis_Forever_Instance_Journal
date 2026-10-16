local _, ns = ...
local L = ns.L

--[[
	The journal's page in the game's options (Options > AddOns), on the client's own settings
	panel (Blizzard_Settings_Shared): what the journal adds that a player may rather do without.
	Each box reads and writes the journal's own saved choice, so it agrees with the same box
	elsewhere (the stat weights editor's).
]]

local Options = {}
ns.Options = Options

-- Settings.VarType.Boolean, on a client that names its types.
local BOOLEAN = "boolean"

local CHECKBOXES = {
	{ variable = "AEGIS_JOURNAL_BOSS_LEVELS", name = "OPTIONS_BOSS_LEVELS", tip = "OPTIONS_BOSS_LEVELS_TIP",
		get = function() return ns.EncounterPage.ShowsBossLevels() end,
		set = function(shown) ns.EncounterPage.SetShowsBossLevels(shown) end },
	{ variable = "AEGIS_JOURNAL_ITEM_TIPS", name = "WEIGHTS_SHOW_GAINS", tip = "WEIGHTS_SHOW_GAINS_TIP",
		get = function() return ns.GearPanel.ShowsGains() end,
		set = function(shown) ns.GearPanel.SetShowsGains(shown) end },
}

function Options:Register()
	if self.category or not (Settings and Settings.RegisterVerticalLayoutCategory and Settings.RegisterProxySetting
		and Settings.CreateCheckbox and Settings.RegisterAddOnCategory) then
		return
	end
	local category = Settings.RegisterVerticalLayoutCategory(L.OPTIONS_TITLE)
	local boolean = Settings.VarType and Settings.VarType.Boolean or BOOLEAN
	for _, box in ipairs(CHECKBOXES) do
		local setting = Settings.RegisterProxySetting(category, box.variable, boolean, L[box.name], true, box.get, box.set)
		Settings.CreateCheckbox(category, setting, L[box.tip])
	end
	Settings.RegisterAddOnCategory(category)
	self.category = category
end

-- /aegis options
function Options:Open()
	if self.category and Settings.OpenToCategory then
		Settings.OpenToCategory(self.category:GetID())
	end
end

local events = CreateFrame("Frame")
ns.RegisterEvents(events, "PLAYER_LOGIN")
events:SetScript("OnEvent", function() Options:Register() end)
