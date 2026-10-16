local _, ns = ...
local L = ns.L

--[[
	A tab on Forever's character panel, below its own side tabs (Character, Reputation, Skills,
	Honor, Currency, Statistics), that opens the journal's Gear Finder.

	It is made from the same Blizzard template as those tabs (LargeSideTabButtonTemplate) and
	parented to their column, so it looks and moves as they do, but it is kept out of the panel's
	own list of them (CharacterFrame.ModeTabs.Tabs): Blizzard's code walks that list when it
	opens the panel and switches its pages, and anything an addon put there would taint it, so
	the panel could no longer open in combat. Nor is it ever shown as the selected tab: it opens
	the journal, not a page of the panel.

	The journal opens where the panel stands, so the panel is closed first, as the world map is
	for the journal's map button (UI/DungeonMap.lua). In combat the game allows an addon no such
	thing: the journal then opens over it.
]]

local CharacterTab = {}
ns.CharacterTab = CharacterTab

-- A helmet: the old Dungeon Finder's icon, for gear from dungeons. A chest piece if the client
-- lacks it.
local ICONS = { "Interface\\Icons\\INV_Helmet_08", "Interface\\Icons\\INV_Chest_Chain" }
-- Blizzard's tabs are 2 apart. With a gamepad, the right bumper's hint sits under the last of
-- them (Blizzard_GamepadSharedUtility/Tab/TabIndicators): this tab goes below that.
local TAB_GAP, GAMEPAD_HINT = 2, 26

local function LastShownTab(column)
	local last
	for _, tab in ipairs(column.Tabs or {}) do
		if tab:IsShown() then last = tab end
	end
	return last
end

local function GamepadShown()
	return InputUtil and InputUtil.IsGamepadUIEnabled and InputUtil.IsGamepadUIEnabled() == true
end

-- Under the last tab Blizzard shows; read only, nothing of Blizzard's is moved.
function CharacterTab:Anchor()
	local tab = self.tab
	if not tab then return end
	local column = tab:GetParent()
	local last = LastShownTab(column)
	tab:ClearAllPoints()
	if last then
		tab:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, -TAB_GAP - (GamepadShown() and GAMEPAD_HINT + TAB_GAP or 0))
	else
		tab:SetPoint("TOPLEFT", column, "TOPLEFT")
	end
end

-- What the tab does: opens the journal on the Gear Finder, in the panel's place.
function CharacterTab:Open()
	if CharacterFrame and CharacterFrame:IsShown() and not InCombatLockdown() and type(HideUIPanel) == "function" then
		pcall(HideUIPanel, CharacterFrame)
	end
	ns.Journal:ShowGear()
end

local function SetupTooltip(tooltip)
	if type(GameTooltip_SetTitle) ~= "function" or type(GameTooltip_AddNormalLine) ~= "function" then return false end
	GameTooltip_SetTitle(tooltip, L.GEAR_CHAR_BUTTON)
	GameTooltip_AddNormalLine(tooltip, L.GEAR_CHAR_BUTTON_TIP)
	return true
end

-- Builds the tab, once the character panel is there. False when this client has no side tabs.
function CharacterTab:Create()
	if self.tab then return true end
	local column = CharacterFrame and CharacterFrame.ModeTabs
	if not (column and ns.HasTemplate("LargeSideTabButtonTemplate")) then return false end
	local ok, tab = pcall(CreateFrame, "Frame", "AegisJournalGearFinderTab", column, "LargeSideTabButtonTemplate")
	if not (ok and tab) then return false end

	if type(tab.Icon) ~= "table" then tab.Icon = tab:CreateTexture(nil, "ARTWORK") end
	for _, icon in ipairs(ICONS) do
		if ns.FileExists(icon) then
			tab.Icon:SetTexture(icon)
			break
		end
	end
	-- As the panel's own tabs: the icon filling the tab's inside, and not selected.
	if tab.SetFillToInterior then tab:SetFillToInterior(true) end
	if tab.SetChecked then tab:SetChecked(false) end
	tab.tooltipText = L.GEAR_CHAR_BUTTON
	function tab:GetTooltipTextSetupFunction() return SetupTooltip end
	-- Not marked for the gamepad to skip, as Blizzard's tabs are: their bumpers do not reach this
	-- one, so the gamepad's cursor has to.

	if tab.SetCustomOnMouseUpHandler then
		tab:SetCustomOnMouseUpHandler(function(_, button, upInside)
			if button == "LeftButton" and upInside ~= false then CharacterTab:Open() end
		end)
	else
		tab:SetScript("OnMouseUp", function(_, button)
			if button == "LeftButton" then CharacterTab:Open() end
		end)
	end

	-- Placed again each time the panel opens, and whenever Blizzard lays its tabs out again.
	tab:HookScript("OnShow", function() CharacterTab:Anchor() end)
	if type(CharacterFrame.UpdateTabLayout) == "function" then
		hooksecurefunc(CharacterFrame, "UpdateTabLayout", function() CharacterTab:Anchor() end)
	end
	self.tab = tab
	self:Anchor()
	return true
end

local events = CreateFrame("Frame")
ns.RegisterEvents(events, "PLAYER_LOGIN")
events:SetScript("OnEvent", function(self)
	CharacterTab:Create()
	ns.UnregisterEvents(self, "PLAYER_LOGIN")
end)
