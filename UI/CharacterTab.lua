local _, ns = ...
local L = ns.L

--[[
	A tab on Forever's character panel, in the column of its own side tabs (Character,
	Reputation, Skills, Honor, Currency, Statistics), that opens the Gear Finder's stat weights in
	a window over the panel's right-hand pane, where its stats are: the weights to read and
	change (UI/WeightsEditor.lua), and a button that opens the Gear Finder itself.

	The tab is made from the same Blizzard template as the panel's own (LargeSideTabButtonTemplate)
	and parented to their column, so it looks and moves as they do, but it is kept out of the
	panel's list of them (CharacterFrame.ModeTabs.Tabs): Blizzard's code walks that list when it
	opens the panel and switches its pages, and anything an addon put there would taint it, so
	the panel could no longer open in combat.

	Other addons put tabs in the same column. This one keeps the first spot under Blizzard's, and
	moves another addon's tab found there down under it; it does so again once each addon has
	placed its own when the panel opens.
]]

local CharacterTab = {}
ns.CharacterTab = CharacterTab

-- A helmet: the old Dungeon Finder's icon, for gear from dungeons. A chest piece if the client
-- lacks it.
local ICONS = { "Interface\\Icons\\INV_Helmet_08", "Interface\\Icons\\INV_Chest_Chain" }
-- Blizzard's tabs are 2 apart. With a gamepad, the right bumper's hint sits under the last of
-- them (Blizzard_GamepadSharedUtility/Tab/TabIndicators): this tab goes below that.
local TAB_GAP, GAMEPAD_HINT = 2, 26
-- The panel's right-hand pane, which the window covers.
local WINDOW_WIDTH, WINDOW_LEVEL = 233, 600

local function GamepadShown()
	return InputUtil and InputUtil.IsGamepadUIEnabled and InputUtil.IsGamepadUIEnabled() == true
end

------------------------------------------------------------------------------------------
-- Where the tab goes
------------------------------------------------------------------------------------------

local function LastShownTab(column)
	local last
	for _, tab in ipairs(column.Tabs or {}) do
		if tab:IsShown() then last = tab end
	end
	return last
end

-- Whether a frame hangs from `target`, directly or through what it hangs from.
local function DependsOn(frame, target, depth)
	if depth > 12 or type(frame.GetNumPoints) ~= "function" then return false end
	for index = 1, frame:GetNumPoints() do
		local _, relative = frame:GetPoint(index)
		if relative == target then return true end
		if type(relative) == "table" and relative ~= UIParent and DependsOn(relative, target, depth + 1) then return true end
	end
	return false
end

-- Whether a frame hangs right under another, as a tab under the one above it.
local function HangsUnder(frame, above)
	local point, relative, relativePoint = frame:GetPoint(1)
	return relative == above and type(point) == "string" and point:find("^TOP") ~= nil
		and type(relativePoint) == "string" and relativePoint:find("^BOTTOM") ~= nil
end

-- The frames hung one under another from `top`, as tabs under the one above.
local function ChainEnd(top, frames)
	local last = top
	for _ = 1, #frames do
		local below
		for _, frame in ipairs(frames) do
			if HangsUnder(frame, last) then below = frame end
		end
		if not below then break end
		last = below
	end
	return last
end

-- The panel's pages (Blizzard_UIPanels_Game/Camelot/CharacterFrameConstants.lua), where another
-- addon may have parented a tab shown only with one of them.
local PAGES = { "PaperDollFrame", "ReputationFrame", "TokenFrame", "PVPRankFrame", "SkillsFrame", "StatisticsFrame" }

-- What else is shown in the column, on the panel or on its pages: not Blizzard's tabs, not this one.
local function OtherFrames(tab, column)
	local blizzard = {}
	for _, own in ipairs(column.Tabs or {}) do blizzard[own] = true end
	local parents = { column, CharacterFrame }
	for _, name in ipairs(PAGES) do
		if type(_G[name]) == "table" and _G[name].GetChildren then parents[#parents + 1] = _G[name] end
	end
	local others = {}
	for _, parent in ipairs(parents) do
		for _, child in ipairs({ parent:GetChildren() }) do
			if child ~= tab and child ~= column and not blizzard[child] and child:IsShown() then
				others[#others + 1] = child
			end
		end
	end
	return others
end

--[[
	Other addons' tabs in this tab's place, the first spot under Blizzard's: one hung under
	Blizzard's last tab, or one the game has drawn there (a frame in the column's line, a tab's
	height, its top in that spot). Top first. Never one already hanging from this tab.
]]
local function InOurPlace(tab, column, last, others)
	local found = {}
	for _, other in ipairs(others) do
		if not DependsOn(other, tab, 0) then
			local here = HangsUnder(other, last)
			if not here then
				local left, bottom = column:GetLeft(), last:GetBottom()
				local otherLeft, otherTop = other:GetLeft(), other:GetTop()
				local height = tab:GetHeight() or 0
				here = type(left) == "number" and type(bottom) == "number" and type(otherLeft) == "number"
					and type(otherTop) == "number" and math.abs(otherLeft - left) <= 4
					and otherTop <= bottom + 4 and otherTop >= bottom - height - TAB_GAP - 4
					and (other:GetHeight() or 0) >= 30 and (other:GetWidth() or 0) <= (column:GetWidth() or 64) + 16
			end
			-- A protected frame is never moved: the game would forbid it in combat, and anything
			-- hung on it would become protected too.
			local protected = type(other.IsProtected) == "function" and other:IsProtected()
			if here and not protected then found[#found + 1] = other end
		end
	end
	-- Only the first of a group moves: what hangs from it follows.
	local roots = {}
	for _, other in ipairs(found) do
		local follows = false
		for _, root in ipairs(found) do
			if root ~= other and DependsOn(other, root, 0) then follows = true end
		end
		if not follows then roots[#roots + 1] = other end
	end
	table.sort(roots, function(a, b)
		local topA, topB = a:GetTop() or 0, b:GetTop() or 0
		if topA ~= topB then return topA > topB end
		return tostring(a:GetName() or a) < tostring(b:GetName() or b)
	end)
	return roots
end

--[[
	The first spot under Blizzard's tabs is this tab's. Another addon's tab found there is moved
	down under it, with whatever hangs from that one; nothing of Blizzard's is moved.
]]
function CharacterTab:Anchor()
	local tab = self.tab
	if not tab then return end
	local column = tab:GetParent()
	local last = LastShownTab(column)
	tab:ClearAllPoints()
	if not last then
		tab:SetPoint("TOPLEFT", column, "TOPLEFT")
		return
	end
	local gamepad = GamepadShown() and GAMEPAD_HINT + TAB_GAP or 0
	local others = OtherFrames(tab, column)
	local displaced = InOurPlace(tab, column, last, others)
	tab:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, -TAB_GAP - gamepad)
	local bottom = ChainEnd(tab, others)
	for _, other in ipairs(displaced) do
		if not DependsOn(other, tab, 0) then
			other:ClearAllPoints()
			other:SetPoint("TOPLEFT", bottom, "BOTTOMLEFT", 0, -TAB_GAP)
			bottom = ChainEnd(other, others)
		end
	end
end

------------------------------------------------------------------------------------------
-- The window
------------------------------------------------------------------------------------------

--[[
	Over the panel's right-hand pane; where that is folded away, over the panel's right edge,
	below the button that unfolds it.
]]
function CharacterTab:PlaceWindow()
	local window, host = self.window, CharacterFrame.RightPaneHost
	window:ClearAllPoints()
	if host and host:IsShown() then
		window:SetAllPoints(host)
	else
		window:SetPoint("TOPRIGHT", CharacterFrame, "TOPRIGHT", 0, -56)
		window:SetPoint("BOTTOMRIGHT", CharacterFrame, "BOTTOMRIGHT", 0, 0)
		window:SetWidth(WINDOW_WIDTH)
	end
end

local function Atlas(texture, atlas, ownSize)
	if not ns.AtlasExists(atlas) then return false end
	texture:SetAtlas(atlas, ownSize == true)
	return true
end

function CharacterTab:Window()
	if self.window then return self.window end
	local window = CreateFrame("Frame", "AegisJournalStatWeightsWindow", CharacterFrame)
	-- Above the panel's own detail panes (Reputation, Skills, Honor, Currency), which are drawn
	-- a layer up from the panel itself.
	window:SetFrameStrata("HIGH")
	window:SetFrameLevel(WINDOW_LEVEL)
	window:EnableMouse(true)
	window:Hide()
	self.window = window

	-- The pane's own art, so the window reads as one of the panel's pages.
	window.Background = window:CreateTexture(nil, "BACKGROUND", nil, -8)
	window.Background:SetAllPoints()
	if not Atlas(window.Background, "UI-Character-Info-Stat-BG") then window.Background:SetColorTexture(0.05, 0.05, 0.05, 1) end
	window.Divider = window:CreateTexture(nil, "OVERLAY")
	if Atlas(window.Divider, "common-framedivider", true) then
		window.Divider:SetPoint("TOPLEFT", -6, -1)
		window.Divider:SetPoint("BOTTOMLEFT", -6, 0)
	else
		window.Divider:Hide()
	end
	window.Title = window:CreateFontString(nil, "OVERLAY", ns.Font("GameFontNormalMed3", "GameFontNormal"))
	window.Title:SetPoint("TOP", 0, -12)
	window.Title:SetText(L.WEIGHTS_TITLE)

	local holder = CreateFrame("Frame", nil, window)
	holder:SetPoint("TOPLEFT", 0, -32)
	holder:SetPoint("BOTTOMRIGHT")
	window.Editor = ns.WeightsEditor:Create(holder, {
		specMenu = function(parent) return ns.GearPanel.CreateSpecMenu(parent, 150) end,
		extra = { text = L.WEIGHTS_OPEN_FINDER, onClick = function() CharacterTab:Open() end },
	})

	window:SetScript("OnShow", function()
		CharacterTab:PlaceWindow()
		window.Editor:Refresh()
		if self.tab and self.tab.SetChecked then self.tab:SetChecked(true) end
	end)
	-- Closed with the panel, and when the player turns to another of its pages.
	window:SetScript("OnHide", function()
		window:Hide()
		if self.tab and self.tab.SetChecked then self.tab:SetChecked(false) end
	end)
	if type(CharacterFrame.ShowSubFrame) == "function" then
		hooksecurefunc(CharacterFrame, "ShowSubFrame", function() window:Hide() end)
	end
	-- Or any of the panel's own tabs clicked, the page already shown among them.
	if type(CharacterFrame.OnModeTabClicked) == "function" then
		hooksecurefunc(CharacterFrame, "OnModeTabClicked", function() window:Hide() end)
	end
	-- Placed again when the right-hand pane is folded away or unfolded.
	if type(CharacterFrame.RefreshRightPane) == "function" then
		hooksecurefunc(CharacterFrame, "RefreshRightPane", function()
			if window:IsShown() then CharacterTab:PlaceWindow() end
		end)
	end
	return window
end

-- What the tab does: the window, open or closed.
function CharacterTab:Toggle()
	local window = self:Window()
	window:SetShown(not window:IsShown())
end

-- The Gear Finder itself, in the panel's place: the journal opens where the panel stands, so the
-- panel is closed first, as the world map is for the journal's map button. In combat the game
-- allows an addon no such thing: the journal then opens over it.
function CharacterTab:Open()
	if CharacterFrame and CharacterFrame:IsShown() and not InCombatLockdown() and type(HideUIPanel) == "function" then
		pcall(HideUIPanel, CharacterFrame)
	end
	ns.Journal:ShowGear()
end

------------------------------------------------------------------------------------------
-- The tab
------------------------------------------------------------------------------------------

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
	-- As the panel's own tabs: the icon filling the tab's inside; selected while its window shows.
	if tab.SetFillToInterior then tab:SetFillToInterior(true) end
	if tab.SetChecked then tab:SetChecked(false) end
	tab.tooltipText = L.GEAR_CHAR_BUTTON
	function tab:GetTooltipTextSetupFunction() return SetupTooltip end
	-- Not marked for the gamepad to skip, as Blizzard's tabs are: their bumpers do not reach this
	-- one, so the gamepad's cursor has to.

	if tab.SetCustomOnMouseUpHandler then
		tab:SetCustomOnMouseUpHandler(function(_, button, upInside)
			if button == "LeftButton" and upInside ~= false then CharacterTab:Toggle() end
		end)
	else
		tab:SetScript("OnMouseUp", function(_, button)
			if button == "LeftButton" then CharacterTab:Toggle() end
		end)
	end

	-- Placed each time the panel opens, and again once other addons have placed their tabs; and
	-- whenever Blizzard lays its own out again.
	tab:HookScript("OnShow", function()
		CharacterTab:Anchor()
		C_Timer.After(0, function() CharacterTab:Anchor() end)
	end)
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
