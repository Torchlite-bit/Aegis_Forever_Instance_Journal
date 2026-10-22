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

--[[
	The journal's icon, on its window and its minimap button: the Ashbringer, the game's icon
	inv_sword_2h_artifactashbringer_d_01, by its file ID. Shown round; the crop leaves out the
	icon's dark edge, so the circle holds only the picture.
]]
Journal.ICON = 1109508
Journal.ICON_CROP = { 0.08, 0.92, 0.08, 0.92 }

-- Retail's journal opens in the left panel slot.
local DEFAULT_POINT = { point = "TOPLEFT", relativePoint = "TOPLEFT", x = 16, y = -116 }

-- The backdrop retail uses for Classic content.
local TIER_BACKGROUND_ATLAS = "UI-EJ-Classic"
local TIER_BACKGROUND_FILE = "Interface\\EncounterJournal\\UI-EJ-Classic"

local TABS = {
	{ key = "dungeons", title = L.TAB_DUNGEONS, empty = L.EMPTY_DUNGEONS, kind = "dungeon" },
	{ key = "raids", title = L.TAB_RAIDS, empty = L.EMPTY_RAIDS, kind = "raid" },
	{ key = "reputation", title = L.TAB_REPUTATION, empty = L.EMPTY_REPUTATION, factions = true },
	{ key = "gear", title = L.TAB_GEAR, empty = "", gear = true },
	{ key = "record", title = L.TAB_RECORD, empty = "", record = true },
}

--[[
	The tab a character last had open is saved by its key. Before the Gear Finder came in ahead
	of Record it was saved by its place, in this order; such a number is read once that way.
]]
local OLD_TAB_ORDER = { "dungeons", "raids", "reputation", "record", "gear" }

local function TabIndex(key)
	for index, info in ipairs(TABS) do
		if info.key == key then return index end
	end
end

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
	if info.gear then ns.GearPanel:Build(panel) end
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

------------------------------------------------------------------------------------------
-- Docking
------------------------------------------------------------------------------------------

--[[
	Docked (the default; the journal's options, or /aegis dock), the journal is one of the game's
	own windows to its window manager (Blizzard_UIParentPanelManager): it opens at the top left,
	moves aside when one of the game's windows opens there and back when that one closes, and is
	put away when there is no room for both, as the game's windows are for each other. Dragged, it
	comes loose and goes where it is put; shut and opened again, it is docked again. Free, it opens
	where it was last dragged, as before.

	The manager reads a window's place from attributes on the frame itself before, and instead of,
	its shared UIPanelWindows list (UIParentPanelManager.lua:100-109): nothing of the journal's goes
	into the game's tables. Plain numbers only: a function there would be called inside the manager
	(:428-432, 773-799, 955-958). Pushable 8 is above every one of the game's windows (theirs go up
	to the group finder's 7): the journal is always the last of the row, the one that moves aside.
	Its width takes in the boss page's side tabs, 43 past the frame's right edge (CreateSideTabs).

	In combat the manager takes no addon's ShowUIPanel or HideUIPanel (:854-861), and while the
	game's menu, its options, Edit Mode or the shop is open it takes no window (:186, 198-209,
	219-222). The journal is then shown and hidden as a plain frame, which is always allowed on its
	own frame: placed by hand where the manager would put it, and following the game's windows each
	frame until it shuts. Shut by itself in combat, it stays counted in its slot till combat ends.
]]
local DOCK_LAYOUT = { area = "left", pushable = 8, whileDead = 1, width = 843 }
local SLOTS = { "left", "center", "right", "doublewide" }
-- The manager's layout (UIPanelLayoutFrame.lua), should the client not give it.
local LAYOUT = { LEFT_OFFSET = 16, TOP_OFFSET = -116, PANEl_SPACING_X = 32, RIGHT_OFFSET_BUFFER = 80 }
-- ClampUIPanelY's defaults (:1007-1019): no window's bottom below 140, none higher than -10.
local BOTTOM_CLAMP, HIGHEST_Y = 140, -10

local docked = false   -- set up as one of the game's windows; ns.db.docked is the player's choice
local managed          -- open in one of the manager's slots
local leftInSlot       -- shut by itself in combat while in a slot
local viaManager       -- being shown by ShowUIPanel
local quiet            -- shut and opened again only to change its mode or let it loose: no sounds
local loose            -- docked, but dragged loose: where the player put it, until it shuts
local releaseAfterCombat -- dragged loose in combat while in a slot: let out of it once combat ends
local over = false     -- placed by hand over the game's windows, there being no room beside them
local openedWith = {}  -- the game's windows open when it was placed by hand
local placedX, placedY -- where it was last placed by hand
local dockEvents = CreateFrame("Frame")

function Journal:IsDocked()
	return ns.db ~= nil and ns.db.docked ~= false
end

-- Always "defined", so the manager never looks the journal up by name; a place only while docked.
-- Without an area, ShowUIPanel and HideUIPanel only show and hide it (:890-894, 924-928).
local function SetDockAttributes(f, on)
	f:SetAttribute("UIPanelLayout-defined", true)
	for name, value in pairs(DOCK_LAYOUT) do
		f:SetAttribute("UIPanelLayout-" .. name, on and value or nil)
	end
end

local function LayoutValue(name)
	local value = type(GetUIPanelLayoutAttribute) == "function" and GetUIPanelLayoutAttribute(name)
	if type(value) == "number" then return value end
	return LAYOUT[name]
end

-- The window the manager holds in a slot: only read. Nil when none, or when the client won't say.
local function Slot(key)
	if type(GetUIPanel) ~= "function" then return nil end
	local ok, panel = pcall(GetUIPanel, key)
	if ok then return panel end
end

local function HeldSlot(f)
	for _, key in ipairs(SLOTS) do
		if Slot(key) == f then return key end
	end
end

-- One of the game's windows standing in a slot (one hidden directly leaves its slot behind).
local function Standing(f, key)
	local panel = Slot(key)
	if panel and panel ~= f and panel:IsShown() then return panel end
end

local function DockY(f)
	local y, top = LayoutValue("TOP_OFFSET"), UIParent:GetTop()
	if type(top) == "number" then
		local bottom = top + y - f:GetHeight() * f:GetScale()
		if bottom < BOTTOM_CLAMP then y = y + BOTTOM_CLAMP - bottom end
	end
	return math.min(y, HIGHEST_Y)
end

--[[
	Where the manager would put the journal, from its own last layout: past the last of its windows,
	32 on (:633-737), or at the top left with none open. Nil when there is no room by the manager's
	count (:1021-1031), or when a window stands centred (the game menu, the options, a lone spellbook).
]]
local function DockedPlace(f)
	local left, center = Standing(f, "left"), Standing(f, "center")
	local right, wide = Standing(f, "right"), Standing(f, "doublewide")
	if right or (center and not left) then return nil end
	local x, after = LayoutValue("LEFT_OFFSET"), nil
	if center or wide then
		after = LayoutValue("RIGHT_OFFSET")
	elseif left then
		after = LayoutValue("CENTER_OFFSET")
	end
	if after ~= nil then
		local screenRight = UIParent:GetRight()
		if type(after) ~= "number" or type(screenRight) ~= "number" then return nil end
		local room = screenRight - LayoutValue("RIGHT_OFFSET_BUFFER") - (after + DOCK_LAYOUT.width)
		if room < 0 or (room == 0 and not (center or wide)) then return nil end
		x = after + LayoutValue("PANEl_SPACING_X")
	end
	return x, DockY(f)
end

-- Measured against where it was last put, so it is not moved again every frame.
local function PlaceByHand(f, x, y)
	if x == placedX and y == placedY then return end
	placedX, placedY = x, y
	local scale = f:GetScale()
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x / scale, y / scale)
end

local function Newcomer(f)
	for _, key in ipairs(SLOTS) do
		local panel = Standing(f, key)
		if panel and not openedWith[panel] then return true end
	end
	return false
end

--[[
	A journal placed by hand: the last of the game's row. Opened with no room, it stands over the
	windows at the top left until room comes or a newer window opens. With no room after, it shuts,
	as the manager puts away a window that no longer fits beside a newer one (:699-711, 739-748).
]]
local function Follow(f, opening)
	local x, y = DockedPlace(f)
	if opening then
		over = not x
		wipe(openedWith)
		for _, key in ipairs(SLOTS) do
			local panel = Standing(f, key)
			if panel then openedWith[panel] = true end
		end
	end
	if x then
		over = false
	elseif over and not Newcomer(f) then
		x, y = LayoutValue("LEFT_OFFSET"), DockY(f)
	else
		f:Hide()
		return
	end
	PlaceByHand(f, x, y)
end

-- Each frame a journal placed by hand is on screen. A fault is reported once; it then stays put.
local function Watch(watch)
	local ok, problem = pcall(Follow, watch:GetParent(), false)
	if not ok then
		watch:Hide()
		geterrorhandler()(problem)
	end
end

-- Docked, as it shows: the manager's when the manager showed it or still holds it (shut in combat
-- and opened again), else placed by hand and following the game's windows. Loose, where it was put.
local function OnDockedShow(f)
	placedX, placedY = nil, nil
	if loose then
		managed = nil
		return
	end
	managed = docked and (viaManager or HeldSlot(f) ~= nil) or nil
	leftInSlot = nil
	if not docked or managed then return end
	Follow(f, true)
	if f:IsShown() then f.DockWatch:Show() end
end

-- Out of the manager's slot without leaving the screen: shut through the manager, so the windows
-- beside it close up, and shown again by itself where it stood, quietly.
local function Release(f)
	local point, relativeTo, relativePoint, x, y = f:GetPoint(1)
	quiet = true
	if type(HideUIPanel) == "function" then pcall(HideUIPanel, f) end
	SetDockAttributes(f, false)
	f:Show()
	if point then
		f:ClearAllPoints()
		f:SetPoint(point, relativeTo, relativePoint, x, y)
	end
	quiet = nil
	managed = nil
end

-- Dragged while docked: loose until it shuts. In combat the manager can't be asked to let it out of
-- its slot, so that waits for combat to end.
local function Loosen(f)
	loose = true
	f.DockWatch:Hide()
	if not managed then
		SetDockAttributes(f, false)
		return
	end
	if InCombatLockdown() then
		releaseAfterCombat = true
		ns.RegisterEvents(dockEvents, "PLAYER_REGEN_ENABLED")
		return
	end
	Release(f)
end

-- A window's width as the manager counts it: its own attribute, else the game's list of its
-- windows (only read), else its frame's (:100-109).
local function PanelWidth(panel)
	local width = panel:GetAttribute("UIPanelLayout-defined") and panel:GetAttribute("UIPanelLayout-width")
	if type(width) ~= "number" and type(UIPanelWindows) == "table" then
		local layout = UIPanelWindows[panel:GetName() or ""]
		width = type(layout) == "table" and layout.width or nil
	end
	if type(width) ~= "number" then width = panel:GetWidth() end
	return width * panel:GetScale()
end

--[[
	A window that widens as it opens leaves the journal beside its narrower self, over it, until the
	row is next laid out: Forever's character sheet sets its width as it shows, after the manager
	placed the row (Camelot/CharacterFrame.lua: OnShow, RefreshRightPane, SetUIPanelAttribute, with
	no new layout). So once one of the game's windows has opened, a journal second in the row is put
	where the manager would put it now, past the window's present width. Only the journal moves; the
	manager's next layout puts it in the same place.
]]
local function SettleInRow()
	local f = frame
	if not (f and docked and managed and not loose and f:IsShown()) then return end
	local left = Slot("left")
	if Slot("center") ~= f or not left or left == f or not left:IsShown() then return end
	local x = LayoutValue("LEFT_OFFSET") + PanelWidth(left) + LayoutValue("PANEl_SPACING_X")
	local scale = f:GetScale()
	local point, _, _, currentX = f:GetPoint(1)
	if point == "TOPLEFT" and type(currentX) == "number" and math.abs(currentX * scale - x) < 1 then return end
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x / scale, DockY(f) / scale)
end

if EventRegistry and EventRegistry.RegisterCallback then
	EventRegistry:RegisterCallback("UIParentPanelManager.ShowUIPanel", SettleInRow, Journal)
end

-- Combat over: a slot it left in combat goes back to the manager (UIPANEL_SKIP_SHOWN_CHECK, :1131),
-- one dragged loose in combat is let out of its slot, and a change of mode made in combat takes effect.
dockEvents:SetScript("OnEvent", function(self)
	if InCombatLockdown() then return end
	ns.UnregisterEvents(self, "PLAYER_REGEN_ENABLED")
	local f = frame
	if not f then return end
	if leftInSlot and docked and not f:IsShown() and type(HideUIPanel) == "function" then
		pcall(HideUIPanel, f, nil, true)
	end
	leftInSlot = nil
	if releaseAfterCombat and loose and f:IsShown() then Release(f) end
	releaseAfterCombat = nil
	Journal:ApplyDocking()
end)

--[[
	Sets the window up as the player chose. An open one shuts the old way (through the manager if it
	was one of its windows, so those beside it close up) and opens the new way, without its sounds.
	In combat that waits for its end: the manager can't be asked then. True when it waits.
]]
function Journal:ApplyDocking()
	local f, want = frame, self:IsDocked()
	if not f or want == docked then return false end
	if InCombatLockdown() then
		ns.RegisterEvents(dockEvents, "PLAYER_REGEN_ENABLED")
		return true
	end
	local shown = f:IsShown()
	quiet = true
	self:Hide()
	loose, releaseAfterCombat = nil, nil
	docked = want
	SetDockAttributes(f, want)
	if not want then self:ApplyPosition() end
	if shown then self:Show() end
	quiet = nil
	return false
end

-- The option (UI/Options.lua) and /aegis dock. True when the change waits for combat to end.
function Journal:SetDocked(on, fromOptions)
	ns.db.docked = on and true or false
	local waits = self:ApplyDocking()
	if not fromOptions and Settings and Settings.NotifyUpdate then pcall(Settings.NotifyUpdate, "AEGIS_JOURNAL_DOCK") end
	return waits
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
	-- Docked and placed by hand, this follows the game's windows while the journal is on screen.
	f.DockWatch = CreateFrame("Frame", nil, f)
	f.DockWatch:Hide()
	f.DockWatch:SetScript("OnUpdate", Watch)
	f:SetScript("OnDragStart", function(self)
		-- Docked, a drag lets it loose until it shuts.
		if docked and not loose then Loosen(self) end
		self:StartMoving()
	end)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		-- Only a free window keeps where it was dragged; a loose one docks again next time.
		if not docked then Journal:SavePosition() end
	end)
	f:SetScript("OnShow", function(self)
		if not quiet then ns.PlaySoundKit("IG_SPELLBOOK_OPEN") end
		OnDockedShow(self)
	end)
	f:SetScript("OnHide", function(self)
		if not quiet then
			ns.PlaySoundKit("IG_SPELLBOOK_CLOSE")
			-- Shut while loose: docked again for its next opening.
			if loose then
				loose, releaseAfterCombat = nil, nil
				SetDockAttributes(self, docked)
			end
		end
		managed = nil
		self.DockWatch:Hide()
	end)
	f:Hide()

	if f.SetTitle then
		f:SetTitle(L.JOURNAL_TITLE)
	elseif f.TitleText then
		f.TitleText:SetText(L.JOURNAL_TITLE)
	end
	-- The window's portrait is masked round by its template.
	if f.SetPortraitToAsset then
		f:SetPortraitToAsset(Journal.ICON)
	elseif f.portrait then
		f.portrait:SetTexture(Journal.ICON)
	end
	local portrait = (f.GetPortrait and f:GetPortrait()) or f.portrait
	if portrait and portrait.SetTexCoord then portrait:SetTexCoord(unpack(Journal.ICON_CROP)) end

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

	-- The template's X closes through HideUIPanel (SharedUIPanelTemplates.lua:152-164), which the
	-- game may refuse an addon's window in combat with a chat line blaming the addon. It closes the
	-- journal's own way, as the search window's X does.
	local close = rawget(f, "CloseButton")
	if close and close.SetScript then close:SetScript("OnClick", function() Journal:Hide() end) end

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
		docked = Journal:IsDocked()
		SetDockAttributes(frame, docked)
		Journal:ApplyPosition()
		Journal:SelectTab(Journal:SavedTabIndex(ns.charDB.lastTab))
	end
	return frame
end

function Journal:Toggle()
	if self:IsShown() then self:Hide() else self:Show() end
end

-- Docked and out of combat, through the game's window manager, which places it and makes room.
-- In combat, or when the manager takes no window (its menu, its options, Edit Mode, the shop), it is
-- shown as a plain frame and placed by hand (OnDockedShow).
function Journal:Show()
	local f = GetFrame()
	if f:IsShown() then return end
	if docked and not InCombatLockdown() and type(ShowUIPanel) == "function" then
		viaManager = true
		pcall(ShowUIPanel, f)
		viaManager = nil
		if f:IsShown() then return end
	end
	f:Show()
end

-- Docked and out of combat, through the manager, so the windows beside it close up (:567-589).
-- Otherwise a plain Hide; shut so in combat, it stays counted in its slot until combat ends, or
-- until the manager's own next opening or Escape clears it (:156-183, 1131).
function Journal:Hide()
	local f = frame
	if not (f and f:IsShown()) then return end
	local wasManaged = managed
	if docked and not InCombatLockdown() and type(HideUIPanel) == "function" then pcall(HideUIPanel, f) end
	if f:IsShown() then
		f:Hide()
		if wasManaged then
			leftInSlot = true
			ns.RegisterEvents(dockEvents, "PLAYER_REGEN_ENABLED")
		end
	end
end

-- The tab to reopen for what was saved: a key, or a place from before the keys.
function Journal:SavedTabIndex(saved)
	if type(saved) == "number" then saved = OLD_TAB_ORDER[saved] end
	return TabIndex(saved) or 1
end

-- Opens the journal on its Gear Finder tab: chosen first, so the last tab is not shown for nothing.
function Journal:ShowGear()
	self:SelectTab(TabIndex("gear"))
	self:Show()
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
	ns.charDB.lastTab = TABS[index].key
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
	local key = (instance.kind == "raid" and "raids") or (instance.kind == "faction" and "reputation") or "dungeons"
	local tabIndex = TabIndex(key)
	if f.selectedTab ~= tabIndex then
		if type(PanelTemplates_SetTab) == "function" then pcall(PanelTemplates_SetTab, f, tabIndex) end
		f.selectedTab = tabIndex
		ns.charDB.lastTab = key
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
			name = ns.BossTitle(boss),
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

-- Docked, the game places it: the free place is reset for when it is freed.
-- Docked, the game places it: the free place is reset for when it is freed, and a window
-- dragged loose goes back into its place now (out of combat, as docking does).
function Journal:ResetPosition()
	ns.db.position = nil
	if not frame then return end
	if not docked then
		self:ApplyPosition()
	elseif loose and frame:IsShown() and not InCombatLockdown() then
		quiet = true
		self:Hide()
		loose, releaseAfterCombat = nil, nil
		SetDockAttributes(frame, true)
		self:Show()
		quiet = nil
	end
end
