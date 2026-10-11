local _, ns = ...
local L = ns.L

--[[
	The journal window: the retail Encounter Journal's frame, breadcrumb bar, search box
	and bottom tabs, built on Blizzard's own templates. Blizzard_EncounterJournal does not
	load on Forever, so its frame is rebuilt here to the measurements in its XML.
]]

local Journal = {}
ns.Journal = Journal

local FRAME_NAME = "AegisJournalFrame"
local WIDTH, HEIGHT = 800, 496
local PORTRAIT = "Interface\\EncounterJournal\\UI-EJ-PortraitIcon"

-- Retail's journal opens in the left panel slot.
local DEFAULT_POINT = { point = "TOPLEFT", relativePoint = "TOPLEFT", x = 16, y = -116 }

-- The backdrop retail uses for Classic content.
local TIER_BACKGROUND_ATLAS = "UI-EJ-Classic"
local TIER_BACKGROUND_FILE = "Interface\\EncounterJournal\\UI-EJ-Classic"

local TABS = {
	{ key = "dungeons", title = L.TAB_DUNGEONS, empty = L.EMPTY_DUNGEONS, kind = "dungeon" },
	{ key = "raids", title = L.TAB_RAIDS, empty = L.EMPTY_RAIDS, kind = "raid" },
	{ key = "reputation", title = L.TAB_REPUTATION, empty = L.EMPTY_REPUTATION, factions = true },
	{ key = "record", title = L.TAB_RECORD, empty = "", record = true },
}

local frame

------------------------------------------------------------------------------------------
-- Pieces
------------------------------------------------------------------------------------------

local function CreateNavBar(parent)
	local navBar = ns.CreateFrameWithTemplate("Frame", FRAME_NAME .. "NavBar", parent, "NavBarTemplate")
	navBar:SetSize(500, 34)
	navBar:SetPoint("TOPLEFT", 61, -22)

	-- The sunken edge retail draws along the bottom and sides of the bar, beneath its art.
	local bottomLeft = ns.CreateTextureFromTemplate(navBar, "BORDER", "UI-Frame-InnerBotLeftCorner", -5)
	local bottomRight = ns.CreateTextureFromTemplate(navBar, "BORDER", "UI-Frame-InnerBotRight", -5)
	if bottomLeft and bottomRight then
		bottomLeft:ClearAllPoints()
		bottomLeft:SetPoint("BOTTOMLEFT", -3, -3)
		bottomRight:ClearAllPoints()
		bottomRight:SetPoint("BOTTOMRIGHT", 3, -3)

		local bottom = ns.CreateTextureFromTemplate(navBar, "BORDER", "_UI-Frame-InnerBotTile", -5)
		if bottom then
			bottom:ClearAllPoints()
			bottom:SetPoint("BOTTOMLEFT", bottomLeft, "BOTTOMRIGHT")
			bottom:SetPoint("BOTTOMRIGHT", bottomRight, "BOTTOMLEFT")
		end
		local left = ns.CreateTextureFromTemplate(navBar, "BORDER", "!UI-Frame-InnerLeftTile", -5)
		if left then
			left:ClearAllPoints()
			left:SetPoint("TOPLEFT", -3, 0)
			left:SetPoint("BOTTOMLEFT", bottomLeft, "TOPLEFT")
		end
		local right = ns.CreateTextureFromTemplate(navBar, "BORDER", "!UI-Frame-InnerRightTile", -5)
		if right then
			right:ClearAllPoints()
			right:SetPoint("TOPRIGHT", 3, 0)
			right:SetPoint("BOTTOMRIGHT", bottomRight, "TOPRIGHT")
		end
	end

	-- NavBarTemplate brings its own Home and overflow buttons.
	if type(NavBar_Initialize) == "function" then
		local homeData = {
			name = L.HOME,
			OnClick = function() Journal:ShowHome() end,
		}
		navBar.ready = pcall(NavBar_Initialize, navBar, "NavButtonTemplate", homeData, navBar.home, navBar.overflow)
	end
	return navBar
end

local function CreateSearchBox(parent)
	local searchBox = ns.CreateFrameWithTemplate("EditBox", FRAME_NAME .. "SearchBox", parent, "SearchBoxTemplate", "InputBoxTemplate")
	searchBox:SetSize(210, 20)
	searchBox:SetPoint("TOPRIGHT", -10, -32)
	searchBox:SetAutoFocus(false)
	searchBox:SetMaxLetters(100)
	return searchBox
end

local function CreatePanel(parent, info)
	local panel = CreateFrame("Frame", nil, parent)
	panel:SetAllPoints()
	panel:Hide()

	panel.Background = panel:CreateTexture(nil, "BACKGROUND")
	panel.Background:SetPoint("TOPLEFT", 3, -3)
	panel.Background:SetPoint("BOTTOMRIGHT", -3, 3)
	if not ns.SetAtlasOrFile(panel.Background, TIER_BACKGROUND_ATLAS, TIER_BACKGROUND_FILE) then
		panel.Background:SetColorTexture(0.06, 0.05, 0.04, 1)
	end

	panel.Title = panel:CreateFontString(nil, "OVERLAY", ns.Font("GameFontNormalLarge2", "GameFontNormalHuge"))
	panel.Title:SetPoint("TOPLEFT", 20, -17)
	panel.Title:SetText(info.title)

	panel.Empty = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableLarge")
	panel.Empty:SetPoint("CENTER", 0, 10)
	panel.Empty:SetText(info.empty)
	panel.emptyText = info.empty

	panel.key = info.key
	if info.kind then ns.InstanceSelect:Build(panel, info.kind) end
	if info.factions then ns.FactionSelect:Build(panel) end
	return panel
end

local function CreateTabs(parent)
	parent.Tabs = {}
	for index, info in ipairs(TABS) do
		local tab = ns.CreateFrameWithTemplate("Button", FRAME_NAME .. "Tab" .. index, parent,
			"PanelTabButtonTemplate", "CharacterFrameTabButtonTemplate")
		tab:SetID(index)
		tab:SetText(info.title)
		if index == 1 then
			tab:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 11, 2)
		else
			tab:SetPoint("TOPLEFT", parent.Tabs[index - 1], "TOPRIGHT", 3, 0)
		end
		tab:SetScript("OnClick", function(self)
			ns.PlaySoundKit("IG_CHARACTER_INFO_TAB")
			Journal:SelectTab(self:GetID())
		end)
		parent.Tabs[index] = tab
	end
	if type(PanelTemplates_SetNumTabs) == "function" then PanelTemplates_SetNumTabs(parent, #TABS) end
end

local function CreateJournalFrame()
	local f = ns.CreateFrameWithTemplate("Frame", FRAME_NAME, UIParent, "PortraitFrameTemplate", "ButtonFrameTemplate")
	f:SetSize(WIDTH, HEIGHT)
	f:SetFrameStrata("HIGH")
	f:SetToplevel(true)
	f:EnableMouse(true)
	f:SetClampedToScreen(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self) self:StartMoving() end)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		Journal:SavePosition()
	end)
	f:SetScript("OnShow", function() ns.PlaySoundKit("IG_SPELLBOOK_OPEN") end)
	f:SetScript("OnHide", function() ns.PlaySoundKit("IG_SPELLBOOK_CLOSE") end)
	f:Hide()

	if f.SetTitle then
		f:SetTitle(L.JOURNAL_TITLE)
	elseif f.TitleText then
		f.TitleText:SetText(L.JOURNAL_TITLE)
	end
	if f.SetPortraitToAsset then
		f:SetPortraitToAsset(PORTRAIT)
	elseif f.portrait then
		f.portrait:SetTexture(PORTRAIT)
	end

	f.Inset = ns.CreateFrameWithTemplate("Frame", nil, f, "InsetFrameTemplate")
	f.Inset:SetPoint("TOPRIGHT", -4, -60)
	f.Inset:SetPoint("BOTTOMLEFT", 4, 5)

	f.NavBar = CreateNavBar(f)
	f.SearchBox = CreateSearchBox(f)
	ns.Search:Attach(f.SearchBox, f)

	f.Panels = {}
	for index, info in ipairs(TABS) do
		f.Panels[index] = CreatePanel(f.Inset, info)
	end
	-- The book (f.EncounterPage) waits until a dungeon or faction is first opened: see Book.
	CreateTabs(f)
	for index, info in ipairs(TABS) do
		if info.record then ns.RecordPanel:Build(f.Panels[index], f.Tabs[index]) end
	end

	-- Escape closes it, like every Blizzard panel.
	table.insert(UISpecialFrames, FRAME_NAME)
	return f
end

------------------------------------------------------------------------------------------
-- Breadcrumbs
------------------------------------------------------------------------------------------

-- The dropdown arrow on an instance's breadcrumb: the other instances of its kind.
local function InstanceList(kind)
	return function()
		local list = {}
		for index, instance in ipairs(ns.GetInstances(kind)) do
			list[index] = { text = instance.name, id = index, func = function() Journal:OpenInstance(instance) end }
		end
		return list
	end
end

-- The dropdown arrow on a boss's breadcrumb: the instance's other bosses.
local function BossList(instance)
	return function()
		local list = {}
		for _, boss in ipairs(instance.bosses) do
			if not boss.trash and not ns.Items:HidesBoss(boss) then
				list[#list + 1] = { text = boss.name, id = #list + 1, func = function() Journal:OpenBoss(instance, boss) end }
			end
		end
		return list
	end
end

local function NavReset(navBar)
	if navBar.ready then pcall(NavBar_Reset, navBar) end
end

local function NavAdd(navBar, data)
	if navBar.ready then pcall(NavBar_AddButton, navBar, data) end
end

local function AddInstanceCrumb(navBar, instance)
	NavAdd(navBar, {
		id = "instance:" .. instance.key,
		name = instance.name,
		OnClick = function() Journal:OpenInstance(instance, true) end,
		listFunc = InstanceList(instance.kind),
	})
end

------------------------------------------------------------------------------------------
-- Behaviour
------------------------------------------------------------------------------------------

local function GetFrame()
	if not frame then
		-- The first open builds the window; /aegis perf reports how long that took.
		local start = debugprofilestop and debugprofilestop()
		frame = CreateJournalFrame()
		if start then ns.perfBuildMS = debugprofilestop() - start end
		Journal:ApplyPosition()
		Journal:SelectTab(ns.charDB.lastTab or 1)
	end
	return frame
end

function Journal:Toggle()
	local f = GetFrame()
	f:SetShown(not f:IsShown())
end

function Journal:Show()
	GetFrame():Show()
end

function Journal:IsShown()
	return frame ~= nil and frame:IsShown()
end

function Journal:SelectedTab()
	return GetFrame().selectedTab
end

-- The book (instance, boss and faction pages), built the first time it is needed.
local function Book(f)
	if not rawget(f, "EncounterPage") then
		local start = debugprofilestop and debugprofilestop()
		f.EncounterPage = ns.EncounterPage:Create(f.Inset)
		if start then ns.perfBookMS = debugprofilestop() - start end
	end
	return f.EncounterPage
end

function Journal:Page()
	return Book(GetFrame())
end

function Journal:SelectTab(index)
	if not TABS[index] then index = 1 end
	local f = GetFrame()
	-- Guarded: on a fallback tab without the template's textures this helper would error.
	if type(PanelTemplates_SetTab) == "function" then pcall(PanelTemplates_SetTab, f, index) end
	f.selectedTab = index
	ns.charDB.lastTab = index
	self:ShowHome()
end

-- Back to the current tab's list, with the breadcrumbs cleared to Home.
function Journal:ShowHome()
	local f = frame
	if not f then return end
	local book = rawget(f, "EncounterPage")
	if book then book:Hide() end
	for panelIndex, panel in ipairs(f.Panels) do
		panel:SetShown(panelIndex == f.selectedTab)
	end
	NavReset(f.NavBar)
end

local function ShowEncounterPage(f, instance)
	-- An instance opened from elsewhere (a map pin, a search) brings its own list tab forward.
	local tabIndex = (instance.kind == "raid" and 2) or (instance.kind == "faction" and 3) or 1
	if f.selectedTab ~= tabIndex then
		if type(PanelTemplates_SetTab) == "function" then pcall(PanelTemplates_SetTab, f, tabIndex) end
		f.selectedTab = tabIndex
		ns.charDB.lastTab = tabIndex
	end
	for _, panel in ipairs(f.Panels) do panel:Hide() end
end

-- Opens an instance's pages. fromNavBar is set when its own breadcrumb was clicked, which
-- already leaves the bar as it should be.
function Journal:OpenInstance(instance, fromNavBar)
	local f = GetFrame()
	ShowEncounterPage(f, instance)
	ns.EncounterPage:ShowInstance(Book(f), instance)
	if not fromNavBar then
		NavReset(f.NavBar)
		AddInstanceCrumb(f.NavBar, instance)
	end
end

-- Opens a boss's page within its instance, with Home > instance > boss breadcrumbs.
function Journal:OpenBoss(instance, boss, fromNavBar)
	local f = GetFrame()
	ShowEncounterPage(f, instance)
	ns.EncounterPage:ShowBoss(Book(f), instance, boss)
	if not fromNavBar then
		NavReset(f.NavBar)
		AddInstanceCrumb(f.NavBar, instance)
		NavAdd(f.NavBar, {
			id = "boss:" .. boss.name,
			name = boss.name,
			OnClick = function() Journal:OpenBoss(instance, boss, true) end,
			listFunc = BossList(instance),
		})
	end
end

function Journal:ApplyPosition()
	local position = ns.db.position or DEFAULT_POINT
	frame:ClearAllPoints()
	frame:SetPoint(position.point, UIParent, position.relativePoint, position.x, position.y)
end

function Journal:SavePosition()
	local point, _, relativePoint, x, y = frame:GetPoint(1)
	ns.db.position = { point = point, relativePoint = relativePoint, x = x, y = y }
end

function Journal:ResetPosition()
	ns.db.position = nil
	if frame then self:ApplyPosition() end
end
