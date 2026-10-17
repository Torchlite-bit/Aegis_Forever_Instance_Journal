--[[
	Stand-ins for the parts of the WoW API the journal uses, for Tools/smoke_test.py.

	This is not an emulator. Frames remember what was set on them and run their scripts
	when told to; everything else is a quiet no-op. The point is to catch errors in the
	addon's own logic (a nil called, a wrong field, a broken filter) before a client restart.
	Which templates exist follows what Aegis Probe found on the Forever client.
]]

local Mock = { chat = {}, frames = {}, bindings = {}, created = 0, xmlTemplates = {} }
WOWMOCK = Mock

-- The client's language: English, unless the runner asks for another (WOWMOCK_LOCALE).
Mock.locale = WOWMOCK_LOCALE or "enUS"
function GetLocale() return Mock.locale end
-- An error the addon hands to the client's error handler fails the test, as it would show in game.
function geterrorhandler() return function(message) error(message, 0) end end

-- Templates the probe reported missing on Forever 1.60.1.
Mock.missingTemplates = {
	ItemButtonTemplate = true, EncounterItemTemplate = true, CharacterFrameTabButtonTemplate = true,
	EncounterInstanceButtonTemplate = true, EncounterBossButtonTemplate = true,
	EncounterJournalPinTemplate = true, EncounterTabTemplate = true,
}

------------------------------------------------------------------------------------------
-- Regions (frames, textures, font strings)
------------------------------------------------------------------------------------------

local Region = {}
local RegionMeta = {
	__index = function(self, key)
		local method = Region[key]
		if method then return method end
		-- Unknown methods are quiet no-ops; unknown fields are nil, as on a real frame.
		if type(key) == "string" and key:match("^%u") then
			return function() end
		end
		return nil
	end,
}

local function CheckTemplates(template)
	if not template then return end
	for name in string.gmatch(template, "[^,%s]+") do
		if Mock.missingTemplates[name] then
			error("Couldn't find inherited node \"" .. name .. "\"", 3)
		end
	end
end

local function NewRegion(objectType, name, parent)
	Mock.created = Mock.created + 1
	local region = setmetatable({
		_type = objectType, _name = name, _parent = parent, _shown = true,
		_points = {}, _scripts = {}, _events = {}, _width = 0, _height = 0, _scroll = 0,
	}, RegionMeta)
	if name then _G[name] = region end
	-- Frames keep their child frames, for GetChildren.
	if parent and objectType ~= "Texture" and objectType ~= "FontString" and objectType ~= "MaskTexture" then
		local children = rawget(parent, "_children")
		if not children then
			children = {}
			rawset(parent, "_children", children)
		end
		children[#children + 1] = region
	end
	return region
end

function Region:GetObjectType() return self._type end
function Region:GetChildren() return unpack(rawget(self, "_children") or {}) end
function Region:GetName() return self._name end
function Region:GetParent() return self._parent end
function Region:SetParent(parent) self._parent = parent end
function Region:Show() self._shown = true; self:_RunScript("OnShow") end
function Region:Hide() local was = self._shown; self._shown = false; if was then self:_RunScript("OnHide") end end
function Region:SetShown(shown) if shown then self:Show() else self:Hide() end end
function Region:IsShown() return self._shown end
function Region:IsVisible()
	if not self._shown then return false end
	if self._parent and self._parent.IsVisible and self._parent ~= UIParent then return self._parent:IsVisible() end
	return true
end
function Region:SetPoint(...) self._points[#self._points + 1] = { ... } end
function Region:ClearAllPoints() self._points = {} end
function Region:GetNumPoints() return #self._points end
function Region:GetPoint(index)
	local point = self._points[index or 1]
	if not point then return nil end
	-- The short form SetPoint(point, x, y) is relative to the parent's same point.
	if type(point[2]) == "number" or point[2] == nil then
		return point[1], self._parent, point[1], point[2] or 0, point[3] or 0
	end
	return point[1], point[2], point[3], point[4] or 0, point[5] or 0
end
function Region:SetAllPoints(target) self._points = { { "ALL", target } } end
function Region:SetSize(width, height) self._width, self._height = width, height end
function Region:SetWidth(width) self._width = width end
function Region:SetHeight(height) self._height = height end
function Region:GetWidth() return self._width end
function Region:GetHeight() return self._height end
function Region:GetSize() return self._width, self._height end
function Region:SetText(text) self._text = text end
function Region:GetText() return self._text end
function Region:SetFormattedText(fmt, ...) self._text = string.format(fmt, ...) end
function Region:SetTexture(texture) self._texture = texture; return true end
function Region:GetTexture() return self._texture end
function Region:GetTextureFileID() return self._texture and 1 or nil end
-- A PlayerModel: the creature it shows, which way it faces and how far its camera is.
function Region:SetDisplayInfo(displayID) self._displayInfo = displayID end
function Region:ClearModel() self._displayInfo = nil end
function Region:SetFacing(facing) self._facing = facing end
function Region:GetFacing() return self._facing end
function Region:SetCamDistanceScale(scale) self._camScale = scale end
function Region:SetAtlas(atlas) self._atlas = atlas; return true end
function Region:SetTexCoord(...)
	-- As on the live client: a texture rounded with the old SetMask cannot be cropped.
	if self._mask then error("Texture:SetTextCoord(): Cannot set tex coords when texture has mask.", 2) end
	self._texCoord = { ... }
end
function Region:AddMaskTexture(mask)
	self._maskTextures = self._maskTextures or {}
	self._maskTextures[#self._maskTextures + 1] = mask
end
function Region:RemoveMaskTexture(mask)
	for index, kept in ipairs(self._maskTextures or {}) do
		if kept == mask then table.remove(self._maskTextures, index) return end
	end
end
function Region:SetColorTexture(...) self._color = { ... } end
function Region:SetID(id) self._id = id end
function Region:GetID() return self._id or 0 end

function Region:SetScript(name, handler) self._scripts[name] = handler end
function Region:GetScript(name) return self._scripts[name] end
function Region:HookScript(name, handler)
	local previous = self._scripts[name]
	self._scripts[name] = function(...)
		if previous then previous(...) end
		handler(...)
	end
end
function Region:_RunScript(name, ...)
	local handler = self._scripts[name]
	if handler then return handler(self, ...) end
end
function Region:Click(button) return self:_RunScript("OnClick", button or "LeftButton", false) end

function Region:RegisterEvent(event) self._events[event] = true end
function Region:UnregisterEvent(event) self._events[event] = nil end
function Region:IsEventRegistered(event) return self._events[event] == true end

function Region:CreateTexture(name, layer, template, subLevel)
	CheckTemplates(template)
	local texture = NewRegion("Texture", name, self)
	rawset(texture, "_layer", layer)
	rawset(texture, "_subLevel", subLevel or 0)
	return texture
end
function Region:CreateFontString(name, layer, template)
	CheckTemplates(template)
	local text = NewRegion("FontString", name, self)
	rawset(text, "_layer", layer)
	rawset(text, "_subLevel", 0)
	return text
end
-- Text and textures share a layer's sublevels: the higher is drawn on top.
function Region:SetDrawLayer(layer, subLevel)
	rawset(self, "_layer", layer)
	rawset(self, "_subLevel", subLevel or 0)
end
function Region:GetDrawLayer() return self._layer, self._subLevel end
function Region:CreateMaskTexture(name) return NewRegion("MaskTexture", name, self) end

local function ButtonTexture(self, key, texture)
	local region = self[key] or NewRegion("Texture", nil, self)
	rawset(self, key, region)
	region:SetTexture(texture)
end
function Region:SetNormalTexture(texture) ButtonTexture(self, "_normal", texture) end
function Region:GetNormalTexture() return self._normal end
function Region:SetPushedTexture(texture) ButtonTexture(self, "_pushed", texture) end
function Region:GetPushedTexture() return self._pushed end
function Region:SetHighlightTexture(texture) ButtonTexture(self, "_highlight", texture) end
function Region:GetHighlightTexture() return self._highlight end

function Region:SetScrollChild(child) self._scrollChild = child end
function Region:GetScrollChild() return self._scrollChild end
function Region:SetVerticalScroll(value)
	self._scroll = value
	self:_RunScript("OnVerticalScroll", value)
end
function Region:GetVerticalScroll() return self._scroll end
function Region:GetVerticalScrollRange()
	local child = self._scrollChild
	if not child then return 0 end
	return math.max(0, child._height - self._height)
end

-- The modern dropdown: keeps the menu generator and builds a record of it on demand.
function Region:SetupMenu(generator) self._menuGenerator = generator; self:GenerateMenu() end
-- A menu's record: its radios, checkboxes and buttons; a button holds its submenu's record.
local function MenuDescription(text)
	local description = { text = text, radios = {}, checkboxes = {}, buttons = {} }
	function description:CreateRadio(radioText, isSelected, setSelected, data)
		self.radios[#self.radios + 1] = { text = radioText, isSelected = isSelected, setSelected = setSelected, data = data }
		return {}
	end
	function description:CreateCheckbox(boxText, isSelected, setSelected)
		self.checkboxes[#self.checkboxes + 1] = { text = boxText, isSelected = isSelected, setSelected = setSelected }
		return {}
	end
	function description:CreateButton(buttonText)
		local submenu = MenuDescription(buttonText)
		self.buttons[#self.buttons + 1] = submenu
		return submenu
	end
	function description:CreateDivider() return {} end
	function description:CreateTitle(titleText) self.title = titleText; return {} end
	return description
end
-- What addons add to the client's tagged menus (Blizzard_Menu's Menu.ModifyMenu); Mock.TaggedMenu
-- builds one with only those additions.
Menu = { modifiers = {} }
function Menu.ModifyMenu(tag, callback)
	Menu.modifiers[tag] = Menu.modifiers[tag] or {}
	table.insert(Menu.modifiers[tag], callback)
end
function Mock.TaggedMenu(tag)
	local root = MenuDescription()
	for _, callback in ipairs(Menu.modifiers[tag] or {}) do callback(nil, root) end
	return root
end
function Region:GenerateMenu()
	if not self._menuGenerator then return end
	local root = MenuDescription()
	self._menuGenerator(self, root)
	self._menu = root
end

function Region:SetDisabledTexture(texture) ButtonTexture(self, "_disabled", texture) end
function Region:GetDisabledTexture() return self._disabled end
function Region:SetEnabled(enabled) self._disabledState = not enabled end
function Region:Enable() self._disabledState = false end
function Region:Disable() self._disabledState = true end
function Region:IsEnabled() return not self._disabledState end
function Region:LockHighlight() self._highlightLocked = true end
function Region:UnlockHighlight() self._highlightLocked = false end
function Region:SetFrameLevel(level) self._level = level end
function Region:GetFrameLevel() return self._level or 1 end
function Region:SetAlpha(alpha) self._alpha = alpha end
function Region:GetAlpha() return self._alpha or 1 end
function Region:SetScale(scale) self._scale = scale end
function Region:GetScale() return self._scale or 1 end
-- A frame draws in its parent's strata unless it was given its own.
function Region:SetFrameStrata(strata) self._strata = strata end
function Region:GetFrameStrata()
	if self._strata then return self._strata end
	local parent = rawget(self, "_parent")
	return parent and parent.GetFrameStrata and parent:GetFrameStrata() or "MEDIUM"
end
function Region:SetDesaturated(desaturated) self._desaturated = desaturated end
function Region:SetMask(mask) self._mask = mask end
-- As strict as the client: the fourth value, if any, is the alpha, a number.
-- Blizzard's side tabs (SidePanelTabButtonMixin) keep the handler their mouse-up calls.
function Region:SetCustomOnMouseUpHandler(handler) self.customMouseUpHandler = handler end
function Region:SetTextColor(...)
	local a = select(4, ...)
	if a ~= nil and type(a) ~= "number" then
		error("bad argument #5 to 'SetTextColor' (Usage: self:SetTextColor(colorR, colorG, colorB [, a]))", 2)
	end
	self._textColor = { ... }
end
-- As the client draws it: no wider than a width set on it. The unbounded width is the words' own.
function Region:GetUnboundedStringWidth() return #(self._text or "") * 7 end
function Region:GetStringWidth()
	local width = self:GetUnboundedStringWidth()
	if (self._width or 0) > 0 then return math.min(width, self._width) end
	return width
end
function Region:GetStringHeight()
	local lines = 1
	for _ in string.gmatch(self._text or "", "\n") do lines = lines + 1 end
	return lines * 12
end
function Region:SetChecked(checked) self._checked = checked and true or false end
function Region:GetChecked() return self._checked end
function Region:SetTitle(text) self._title = text end
function Region:SetPortraitToAsset(texture) self._portrait = texture end

------------------------------------------------------------------------------------------
-- Globals
------------------------------------------------------------------------------------------

function CreateFrame(frameType, name, parent, template)
	CheckTemplates(template)
	local frame = NewRegion(frameType, name, parent)
	frame._template = template
	Mock.frames[#Mock.frames + 1] = frame
	-- Templates from the addon's own XML bring their mixins, as the client applies them.
	local xml = template and Mock.xmlTemplates[template]
	if xml and xml.mixin then Mixin(frame, _G[xml.mixin]) end
	if template == "MapLegendButtonTemplate" then
		-- Retail's map legend entry (Blizzard_UIPanels_Game/Mainline/MapLegendFrame.lua): hovering
		-- it makes the pins of its templates glow, those its meta data matches (MetaDataMatches:
		-- the pin's GetStyle, or its isRaid).
		local function MetaDataMatches(metaData, pin)
			if not metaData then return true end
			if metaData.Style and rawget(pin, "GetStyle") ~= nil and pin:GetStyle() == metaData.Style then return true end
			if metaData.isRaid ~= nil and pin.isRaid ~= nil and metaData.isRaid == pin.isRaid then return true end
			return false
		end
		rawset(frame, "InitializeButton", function(self, info, index)
			self.nameText, self.tooltipText, self.layoutIndex = info.Name, info.Tooltip, index
			self.templates, self.metaData, self.atlas = info.TemplateNames, info.MetaData, info.Atlas
		end)
		rawset(frame, "SetHighlightLocked", function(self, locked) self.highlightLocked = locked end)
		frame:SetScript("OnEnter", function(self)
			self.highlightedPins = {}
			for _, pinTemplate in ipairs(self.templates) do
				for pin in WorldMapFrame:EnumeratePinsByTemplate(pinTemplate) do
					if MetaDataMatches(self.metaData, pin) then
						pin:ShowMapLegendGlow()
						self.highlightedPins[#self.highlightedPins + 1] = pin
					end
				end
			end
		end)
		frame:SetScript("OnLeave", function(self)
			for _, pin in ipairs(self.highlightedPins or {}) do pin:HideMapLegendGlow() end
		end)
	end
	if template == "ColoredProgressBarTemplate" then
		-- Forever's own progress bar (Blizzard_SharedXML/Camelot/ProgressBars).
		rawset(frame, "Fill", NewRegion("Texture", nil, frame))
		rawset(frame, "Text", NewRegion("FontString", nil, frame))
		rawset(frame, "ColorType", { Red = 1, Green = 2, Blue = 3, White = 4 })
		rawset(frame, "SetFillPercent", function(self, percent) self._fillPercent = percent end)
		rawset(frame, "SetFillTextureByColorType", function(self, colorType) self._fillColorType = colorType end)
	end
	return frame
end

function Mock.Fire(event, ...)
	for _, frame in ipairs(Mock.frames) do
		if frame._events[event] and frame._scripts.OnEvent then
			frame._scripts.OnEvent(frame, event, ...)
		end
	end
	-- Map data providers hear the events they registered through the map.
	for _, provider in ipairs(WorldMapFrame and WorldMapFrame._providers or {}) do
		if provider.registeredEvents and provider.registeredEvents[event] then provider:OnEvent(event, ...) end
	end
end

UIParent = CreateFrame("Frame", "UIParent")
DEFAULT_CHAT_FRAME = { AddMessage = function(_, message) Mock.chat[#Mock.chat + 1] = message end }
UISpecialFrames = {}
SlashCmdList = {}

HOME, DUNGEONS, RAIDS, REPUTATION = "Home", "Dungeons", "Raids", "Reputation"
SOUNDKIT = setmetatable({}, { __index = function() return 1 end })
function PlaySound() end

C_XMLUtil = {
	GetTemplateInfo = function(name)
		if Mock.missingTemplates[name] then return nil end
		return { type = "Frame" }
	end,
}
-- Every atlas exists, but those a test names in Mock.missingAtlases.
C_Texture = {
	GetAtlasInfo = function(name)
		if Mock.missingAtlases and Mock.missingAtlases[name] then return nil end
		return { width = 64, height = 64 }
	end,
}
Mock.missingFiles = {}
-- Every file exists but those a test names in Mock.missingFiles (with or without ".blp").
function GetFileIDFromPath(path)
	if Mock.missingFiles[path] or Mock.missingFiles[(path:gsub("%.blp$", ""))] then return nil end
	return 1
end
-- Addons the player has loaded besides this one, and the client's memory count for each.
Mock.otherAddOns = { MapUtils = 4200 }
C_AddOns = {
	GetAddOnMetadata = function() return nil end,
	IsAddOnLoaded = function(name) return name == "Aegis_Forever_Instance_Journal" or Mock.otherAddOns[name] ~= nil end,
	GetAddOnMemoryUsage = function(name)
		if name == "Aegis_Forever_Instance_Journal" then return collectgarbage("count") end
		return Mock.otherAddOns[name] or 0
	end,
}
function UpdateAddOnMemoryUsage() Mock.memoryUpdated = true end
function debugprofilestop() return os.clock() * 1000 end
--[[
	Timers run at once, unless a test defers them (Mock.deferTimers = true): then each waits in
	Mock.timers until Mock.RunTimers(seconds) moves the clock on past it, in the order they fall
	due, as the client runs them.
]]
Mock.timers = {}
C_Timer = {
	After = function(delay, callback)
		if Mock.deferTimers then
			Mock.timers[#Mock.timers + 1] = { due = Mock.time + (delay or 0), callback = callback }
		else
			callback()
		end
	end,
	NewTicker = function() return { Cancel = function() end } end,
}
function Mock.RunTimers(seconds)
	local stop = Mock.time + (seconds or 0)
	while true do
		local index
		for i, timer in ipairs(Mock.timers) do
			if timer.due <= stop and (not index or timer.due < Mock.timers[index].due) then index = i end
		end
		if not index then break end
		local timer = table.remove(Mock.timers, index)
		Mock.time = math.max(Mock.time, timer.due)
		timer.callback()
	end
	Mock.time = stop
end
-- Runs the hook after the original, as the client does.
function hooksecurefunc(target, name, hook)
	if type(target) == "string" then target, name, hook = _G, target, name end
	local original = target[name]
	target[name] = function(...)
		local results = { original(...) }
		hook(...)
		return unpack(results)
	end
end
function InCombatLockdown() return Mock.inCombat == true end

function GetBindingKey(action)
	for key, bound in pairs(Mock.bindings) do
		if bound == action then return key end
	end
	return nil
end
function GetBindingAction(key) return Mock.bindings[key] or "" end
function SetBinding(key, action) Mock.bindings[key] = action; return true end
function SaveBindings(set) Mock.bindingsSaved = set end
-- 1 is the account's bindings, 2 the character's.
function GetCurrentBindingSet() return Mock.bindingSet or 1 end

function NavBar_Initialize(bar, _, homeData) bar._nav = { homeData } end
function NavBar_Reset(bar) bar._nav = { bar._nav[1] } end
function NavBar_AddButton(bar, data) bar._nav[#bar._nav + 1] = data end
function PanelTemplates_SetNumTabs(frame, count) frame.numTabs = count end
function PanelTemplates_SetTab(frame, index) frame.selectedTab = index end

ScrollUtil = { InitScrollFrameWithScrollBar = function() end }
function ScrollFrame_OnLoad(scroll) scroll.ScrollBar = CreateFrame("EventFrame", nil, scroll) end
GameTooltip = CreateFrame("GameTooltip", "GameTooltip")
GameTooltip._lines = {}
function GameTooltip:SetOwner(owner) self._lines, self._owner, self._link = {}, owner, nil end
function GameTooltip:GetOwner() return self._owner end
function GameTooltip:AddLine(text) self._lines[#self._lines + 1] = text end
-- A two-column line is kept as "left<tab>right".
function GameTooltip:AddDoubleLine(left, right) self._lines[#self._lines + 1] = left .. "\t" .. right end

-- Retail's context menus (Blizzard_Menu/MenuUtil.lua): the last one opened, as its owner, title and buttons.
MenuUtil = {
	CreateContextMenu = function(owner, generator)
		local root = { title = nil, buttons = {} }
		function root:CreateTitle(text) self.title = text end
		function root:CreateButton(text, onClick) self.buttons[#self.buttons + 1] = { text = text, onClick = onClick } end
		generator(owner, root)
		root.owner = owner
		Mock.contextMenu = root
		return root
	end,
}
function GameTooltip:HasLine(text)
	for _, line in ipairs(self._lines) do if line == text then return true end end
	return false
end

-- Mixins, as Blizzard's SharedXMLBase has them.
function Mixin(object, ...)
	for index = 1, select("#", ...) do
		for key, value in pairs((select(index, ...))) do rawset(object, key, value) end
	end
	return object
end
function CreateFromMixins(...) return Mixin({}, ...) end

-- The map canvas framework (Blizzard_MapCanvas): data providers and pins.
MapCanvasDataProviderMixin = {}
function MapCanvasDataProviderMixin:OnAdded(map) self.owningMap = map end
function MapCanvasDataProviderMixin:GetMap() return self.owningMap end
function MapCanvasDataProviderMixin:OnMapChanged() self:RefreshAllData() end
function MapCanvasDataProviderMixin:OnShow() end
function MapCanvasDataProviderMixin:OnHide() end
function MapCanvasDataProviderMixin:RemoveAllData() end
function MapCanvasDataProviderMixin:RefreshAllData() end
function MapCanvasDataProviderMixin:RegisterEvent(event)
	self.registeredEvents = self.registeredEvents or {}
	self.registeredEvents[event] = true
end
function MapCanvasDataProviderMixin:UnregisterEvent(event)
	if self.registeredEvents then self.registeredEvents[event] = nil end
end
MapCanvasPinMixin = {}
function MapCanvasPinMixin:GetMap() return self.owningMap end
function MapCanvasPinMixin:OnLoad() end
function MapCanvasPinMixin:OnAcquired() end
function MapCanvasPinMixin:SetScalingLimits(...) self._scalingLimits = { ... } end
function MapCanvasPinMixin:UseFrameLevelType(levelType) self._frameLevelType = levelType end
function MapCanvasPinMixin:SetPosition(x, y) self._position = { x, y } end
function MapCanvasPinMixin:GetPosition() return self._position[1], self._position[2] end
function MapCanvasPinMixin:OnClick(button) if self.OnMouseClickAction then self:OnMouseClickAction(button) end end
-- As the client: the canvas sets every pin's pass-through as it hands it out, and in combat
-- SetPassThroughButtons is blocked for an addon's code.
function MapCanvasPinMixin:ShouldMouseButtonBePassthrough(button) return button == "RightButton" end
function MapCanvasPinMixin:CheckMouseButtonPassthrough(...)
	self:SetPassThroughButtons()
	local through = {}
	for index = 1, select("#", ...) do
		local button = select(index, ...)
		if self:ShouldMouseButtonBePassthrough(button) then through[#through + 1] = button end
	end
	self:SetPassThroughButtons(unpack(through))
end
function Region:SetPassThroughButtons(...)
	if Mock.inCombat then error("ADDON_ACTION_BLOCKED: Frame:SetPassThroughButtons()", 2) end
	self._passThrough = { ... }
end

-- The world map: the map it shows, its providers and pins, and the canvas pins sit on.
WorldMapFrame = CreateFrame("Frame", "WorldMapFrame", UIParent)
WorldMapFrame._shown = false
local mapCanvas = CreateFrame("Frame", nil, WorldMapFrame)
mapCanvas:SetSize(1002, 668)
WorldMapFrame.ScrollContainer = CreateFrame("ScrollFrame", nil, WorldMapFrame)
WorldMapFrame.ScrollContainer.Child = mapCanvas
-- Forever's map pin button, in the canvas's top-left corner (Camelot/Blizzard_WorldMap.lua).
WorldMapFrame.WorldMapTrackingPinButton = CreateFrame("Button", nil, WorldMapFrame.ScrollContainer)
WorldMapFrame._providers, WorldMapFrame._pools = {}, {}
function WorldMapFrame:GetCanvas() return mapCanvas end
function WorldMapFrame:GetMapID() return Mock.worldMapID end
function WorldMapFrame:OnMapChanged() end
function WorldMapFrame:AddDataProvider(provider)
	self._providers[#self._providers + 1] = provider
	provider:OnAdded(self)
	if self:IsShown() then provider:RefreshAllData(true) end
end
function WorldMapFrame:SetMapID(mapID)
	Mock.worldMapID = mapID
	self:OnMapChanged()
	for _, provider in ipairs(self._providers) do provider:OnMapChanged() end
end
function WorldMapFrame:AcquirePin(template, ...)
	local pool = self._pools[template] or { pins = {} }
	self._pools[template] = pool
	local pin
	for _, candidate in ipairs(pool.pins) do
		if not candidate._active then pin = candidate break end
	end
	if not pin then
		pin = CreateFrame("Button", nil, mapCanvas, template)
		pool.pins[#pool.pins + 1] = pin
		pin:SetScript("OnEnter", pin.OnMouseEnter)
		pin:SetScript("OnLeave", pin.OnMouseLeave)
		pin:SetScript("OnClick", function(self, button) self:OnClick(button) end)
		pin:OnLoad()
	end
	pin._active = true
	pin.owningMap = self
	pin:Show()
	pin:OnAcquired(...)
	pin:CheckMouseButtonPassthrough("RightButton")
	return pin
end
function WorldMapFrame:RemoveAllPinsByTemplate(template)
	for _, pin in ipairs(self._pools[template] and self._pools[template].pins or {}) do
		pin._active = false
		pin:Hide()
	end
end
function WorldMapFrame:ActivePins(template)
	local list = {}
	for _, pin in ipairs(self._pools[template] and self._pools[template].pins or {}) do
		if pin._active then list[#list + 1] = pin end
	end
	return list
end
WorldMapFrame.Show = function(self)
	local was = self._shown
	Region.Show(self)
	if not was then
		for _, provider in ipairs(self._providers) do provider:OnShow() end
		for _, provider in ipairs(self._providers) do provider:RefreshAllData(true) end
	end
end
WorldMapFrame.Hide = function(self)
	local was = self._shown
	Region.Hide(self)
	if was then for _, provider in ipairs(self._providers) do provider:OnHide() end end
end
-- The map's area label at its top (MapCanvasMixin's events for AreaLabelDataProvider): the
-- last one set, until cleared.
MAP_AREA_LABEL_TYPE = { AREA_NAME = 1, INVASION = 2, POI = 3 }
function WorldMapFrame:TriggerEvent(event, labelType, name, description)
	if event == "SetAreaLabel" then
		Mock.areaLabel = { type = labelType, name = name, description = description }
	elseif event == "ClearAreaLabel" then
		Mock.areaLabel = nil
	end
end
-- The client's zone label (AreaLabelDataProvider's Label, among MapCanvasMixin's dataProviders):
-- each frame it names the zone under the cursor, Mock.cursorZone = { mapID, name }, adding the
-- level range itself when the client knows it (Mock.clientZoneLevels). Mock.zoneLabel is the
-- name it shows.
WorldMapFrame.dataProviders = {}
local areaLabel = CreateFrame("Frame", nil, mapCanvas)
areaLabel.labelInfoByType = {}
function areaLabel:SetLabel(labelType, name, description)
	self.labelInfoByType[labelType] = { name = name, description = description }
end
function areaLabel:EvaluateLabels()
	local info = self.labelInfoByType[MAP_AREA_LABEL_TYPE.AREA_NAME]
	Mock.zoneLabel = info and info.name
end
areaLabel:SetScript("OnUpdate", function(self)
	self.labelInfoByType = {}
	local zone = Mock.cursorZone
	if zone then
		local levels = Mock.clientZoneLevels[zone.mapID]
		self:SetLabel(MAP_AREA_LABEL_TYPE.AREA_NAME, levels and (zone.name .. " (" .. levels[1] .. "-" .. levels[2] .. ")") or zone.name)
	end
	self:EvaluateLabels()
end)
local areaLabelProvider = { Label = areaLabel }
function areaLabelProvider:GetMap() return WorldMapFrame end
areaLabel.dataProvider = areaLabelProvider
WorldMapFrame.dataProviders[areaLabelProvider] = true
WorldMapFrame.areaLabel = areaLabel
function WorldMapFrame:IsCanvasMouseFocus() return Mock.cursorZone ~= nil end
function WorldMapFrame:GetNormalizedCursorPosition() return 0.5, 0.5 end
Mock.clientZoneLevels = {}
-- The explored pieces the client lists, by map: Mock.explored[uiMapID] = { fileDataID, ... }.
Mock.explored = {}
C_MapExplorationInfo = {
	GetExploredMapTextures = function(mapID)
		local list = {}
		for _, file in ipairs(Mock.explored[mapID] or {}) do list[#list + 1] = { fileDataIDs = { file } } end
		return list
	end,
}
QuestDifficultyColors = { difficult = { r = 1, g = 0.82, b = 0 } }
function WorldMapFrame:EnumeratePinsByTemplate(template)
	local list, index = self:ActivePins(template), 0
	return function()
		index = index + 1
		return list[index]
	end
end

-- The map's side panel as Forever's Camelot rules leave it: retail's quest log with its tabs
-- hidden on every refresh (Blizzard_UIPanels_Game/Mainline/QuestMapFrame.lua, Camelot
-- overrides), and the legend Camelot's MapLegendFrameData builds.
QuestMapFrameOverrides = { questTabHidden = true, eventsTabHidden = true, mapLegendTabHidden = true }
function QuestMapFrameOverrides.GetQuestsTabAnchorOffset() return 5, -28 end
QuestMapFrame = CreateFrame("Frame", "QuestMapFrame", WorldMapFrame)
QuestMapFrame.QuestsTab = CreateFrame("Frame", nil, QuestMapFrame)
QuestMapFrame.EventsTab = CreateFrame("Frame", nil, QuestMapFrame)
QuestMapFrame.MapLegendTab = CreateFrame("Frame", nil, QuestMapFrame)
function QuestMapFrame:ValidateTabs()
	self.EventsTab:Hide()
	self.MapLegendTab:Hide()
	self.QuestsTab:Hide()
end
function QuestMapFrame:Refresh() self:ValidateTabs() end
QuestMapFrame.MapLegend = CreateFrame("Frame", nil, QuestMapFrame)
QuestMapFrame.MapLegend.ScrollFrame = CreateFrame("ScrollFrame", nil, QuestMapFrame.MapLegend)
local legendChild = CreateFrame("Frame", nil, QuestMapFrame.MapLegend.ScrollFrame)
QuestMapFrame.MapLegend.ScrollFrame.ScrollChild = legendChild
function legendChild:Layout() self.laidOut = (self.laidOut or 0) + 1 end
local camelotLegend = {
	{ { Atlas = "QuestNormal", Name = "Local Story", TemplateNames = { "QuestPinTemplate" } } },
	{
		{ Atlas = "Dungeon", Name = "Dungeon", TemplateNames = { "DungeonEntrancePinTemplate" }, MetaData = { isRaid = false } },
		{ Atlas = "Raid", Name = "Raid", TemplateNames = { "DungeonEntrancePinTemplate" }, MetaData = { isRaid = true } },
	},
	{ { Atlas = "FlightPath", Name = "Flightpoint", TemplateNames = { "FlightPointPinTemplate" } } },
}
for categoryIndex, entries in ipairs(camelotLegend) do
	local category = CreateFrame("Frame", nil, legendChild, "MapLegendCategoryTemplate")
	category.layoutIndex = categoryIndex
	function category:Layout() self.laidOut = (self.laidOut or 0) + 1 end
	for index, info in ipairs(entries) do
		CreateFrame("Button", nil, category, "MapLegendButtonTemplate"):InitializeButton(info, index)
	end
end
GridLayoutMixin = { Direction = { TopLeftToBottomRight = 1 } }
function CreateAnchor(...) return { ... } end
AnchorUtil = {
	CreateGridLayout = function(direction, stride) return { direction = direction, stride = stride } end,
	GridLayout = function(frames, _, layout)
		for index, frame in ipairs(frames) do
			frame.gridRow = math.floor((index - 1) / layout.stride) + 1
			frame.gridColumn = (index - 1) % layout.stride + 1
		end
	end,
}
-- As Forever answers: every flight master of the continent, placed on the map asked for, and
-- maps that do not show them. Mock.taxiCalls counts the lookups.
Mock.taxiCalls, Mock.clientShowsTaxi = 0, false
C_TaxiMap = {
	ShouldMapShowTaxiNodes = function() return Mock.clientShowsTaxi end,
	GetTaxiNodesForMap = function(mapID)
		Mock.taxiCalls = Mock.taxiCalls + 1
		if mapID ~= 1455 then return {} end
		return {
			{ name = "Ironforge, Dun Morogh", atlasName = "TaxiNode_Alliance", faction = 2, position = CreateVector2D(0.556, 0.477) },
			{ name = "Thelsamar, Loch Modan", atlasName = "TaxiNode_Alliance", faction = 2, position = CreateVector2D(2.3, 1.4), isUndiscovered = true },
			{ name = "Kargath, Badlands", atlasName = "TaxiNode_Horde", faction = 1, position = CreateVector2D(0.2, 0.3) },
			{ name = "Light's Hope Chapel", atlasName = "TaxiNode_Neutral", position = CreateVector2D(0.7, 0.8) },
		}
	end,
}

-- Opens on the given map, or on the player's.
function OpenWorldMap(mapID)
	Mock.worldMapID = mapID or Mock.playerMapID or 947
	WorldMapFrame:Show()
	WorldMapFrame:SetMapID(Mock.worldMapID)
end
function HideUIPanel(frame) frame:Hide() end
function UnitIsDeadOrGhost() return Mock.ghost == true end
function SetPortraitTextureFromCreatureDisplayID(texture, displayID) texture._portrait = displayID end
function UIDropDownMenu_SetWidth() end
function UIDropDownMenu_Initialize() end
function UIDropDownMenu_SetText() end
function UIDropDownMenu_CreateInfo() return {} end
function UIDropDownMenu_AddButton() end

-- Where the player is, what the loot window holds and what quest frame is open.
Mock.time = 1000
function GetTime() return Mock.time end

Mock.subzone = ""
function IsInInstance()
	if Mock.instance then return true, "party" end
	return false, "none"
end
function GetInstanceInfo()
	if Mock.instance then return Mock.instance.name, "party", 1, "Normal", 5, 0, false, Mock.instance.id, 5, 0 end
	return "Eastern Kingdoms", "none", 0, "", 0, 0, false, 0, 0, 0
end
function GetSubZoneText() return Mock.subzone end
function GetRealZoneText() return Mock.instance and Mock.instance.name or "Ironforge" end
-- The name the minimap shows: the area's, else the zone's.
function GetMinimapZoneText()
	if Mock.subzone ~= "" then return Mock.subzone end
	return GetRealZoneText()
end
C_Map = {
	-- Inside Forever's dungeons the client gives no map, except while the loading screen into one
	-- begins, when it may already say "inside" but still report the street outside (Mock.mapAsLeaving).
	GetBestMapForUnit = function()
		if Mock.instance then return Mock.mapAsLeaving end
		return Mock.playerMapID or 1455
	end,
	GetPlayerMapPosition = function()
		return { GetXY = function() return Mock.playerX or 0.54557, Mock.playerY or 0.37791 end }
	end,
	OpenWorldMap = function(mapID) OpenWorldMap(mapID) end,
	-- Dungeon maps the world map can show by itself: Mock.nativeMaps[uiMapID] = true; zones and
	-- continents from Mock.maps.
	GetMapInfo = function(mapID)
		if Mock.nativeMaps[mapID] then return { mapID = mapID, name = "Map " .. mapID, mapType = 4 } end
		local map = Mock.maps[mapID]
		if map then return { mapID = mapID, name = map.name, mapType = map.mapType, parentMapID = map.parent } end
		return nil
	end,
	-- Each zone is a rectangle of its continent's world coordinates.
	GetWorldPosFromMapPos = function(mapID, position)
		local map = Mock.maps[mapID]
		if not map then return nil end
		local x, y = position:GetXY()
		return map.continent, CreateVector2D(map.left + x * map.width, map.top + y * map.height)
	end,
	GetMapPosFromWorldPos = function(continentID, world, mapID)
		local map = Mock.maps[mapID]
		if not map or map.continent ~= continentID then return nil end
		local x, y = world:GetXY()
		return mapID, CreateVector2D((x - map.left) / map.width, (y - map.top) / map.height)
	end,
	-- The zone under the map's cursor (Mock.cursorZone), and the levels the client knows for one.
	GetMapInfoAtPosition = function(mapID)
		local zone = Mock.cursorZone
		if zone then return { mapID = zone.mapID, name = zone.name, mapType = 3 } end
		return { mapID = mapID, name = "Map " .. mapID }
	end,
	GetMapLevels = function(mapID)
		local levels = Mock.clientZoneLevels[mapID]
		if levels then return levels[1], levels[2], 0, 0 end
		return 0, 0, 0, 0
	end,
	CanSetUserWaypointOnMap = function(mapID) return Mock.maps[mapID] ~= nil end,
	SetUserWaypoint = function(point) Mock.userWaypoint = point end,
	GetMapArtLayers = function(mapID)
		if Mock.nativeMaps[mapID] then return { { layerWidth = 1002, layerHeight = 668 } } end
		return {}
	end,
}
Mock.nativeMaps = {}
Mock.maps = {
	[947] = { name = "Azeroth", mapType = 1 },
	[1415] = { name = "Eastern Kingdoms", mapType = 2, parent = 947, continent = 0, left = 0, top = 0, width = 1000, height = 1500 },
	[1436] = { name = "Westfall", mapType = 3, parent = 1415, continent = 0, left = 340, top = 1130, width = 100, height = 120 },
	[1453] = { name = "Stormwind City", mapType = 3, parent = 1415, continent = 0, left = 420, top = 1000, width = 60, height = 50 },
	[1455] = { name = "Ironforge", mapType = 3, parent = 1415, continent = 0, left = 450, top = 700, width = 40, height = 30 },
	[1416] = { name = "Alterac Mountains", mapType = 3, parent = 1415, continent = 0, left = 380, top = 560, width = 70, height = 60 },
	[1420] = { name = "Tirisfal Glades", mapType = 3, parent = 1415, continent = 0, left = 300, top = 400, width = 90, height = 70 },
	[1427] = { name = "Searing Gorge", mapType = 3, parent = 1415, continent = 0, left = 500, top = 900, width = 50, height = 50 },
	[1414] = { name = "Kalimdor", mapType = 2, parent = 947, continent = 1, left = 0, top = 0, width = 1000, height = 1500 },
	-- Its world rectangle lies the other way round from a door's (x, y) as the game's data gives
	-- them, so a door lands on it only with its axes swapped.
	[1443] = { name = "Desolace", mapType = 3, parent = 1414, continent = 1, left = 2800, top = -1600, width = 300, height = 400 },
}
function CreateVector2D(x, y)
	return { x = x, y = y, GetXY = function(self) return self.x, self.y end }
end
UiMapPoint = { CreateFromCoordinates = function(mapID, x, y) return { uiMapID = mapID, position = CreateVector2D(x, y) } end }
C_SuperTrack = { SetSuperTrackedUserWaypoint = function(on) Mock.superTracked = on end }
Mock.cvars = { showDungeonEntrancesOnMap = "1" }
function GetCVar(name) return Mock.cvars[name] end

Mock.combatLogging = false
function LoggingCombat(on)
	if on ~= nil then Mock.combatLogging = on end
	return Mock.combatLogging
end

-- The minimap: 140 wide, its centre at (500, 400) on a scale of 1.
Minimap = CreateFrame("Frame", "Minimap", UIParent)
Minimap:SetSize(140, 140)
function Minimap:GetCenter() return 500, 400 end
function Minimap:GetEffectiveScale() return 1 end
-- The cursor, for dragging: Mock.cursorX, Mock.cursorY.
Mock.cursorX, Mock.cursorY = 0, 0
function GetCursorPosition() return Mock.cursorX, Mock.cursorY end

Mock.lootSlots = {}
function GetNumLootItems() return #Mock.lootSlots end
function GetLootSlotLink(slot) return Mock.lootSlots[slot] and Mock.lootSlots[slot].link end
function GetLootSlotInfo(slot)
	local entry = Mock.lootSlots[slot]
	return 1, entry.name, 1, nil, entry.quality
end
function GetLootSourceInfo(slot) return Mock.lootSlots[slot].guid, 1 end

Mock.quest = {}
function GetQuestID() return Mock.quest.id end
function GetTitleText() return Mock.quest.title end
function GetQuestText() return Mock.quest.text end
function GetObjectiveText() return Mock.quest.objective end
function GetRewardText() return Mock.quest.rewardText end
function GetRewardXP() return Mock.quest.xp end
function GetRewardMoney() return Mock.quest.money end
function GetNumQuestChoices() return #(Mock.quest.choices or {}) end
function GetNumQuestRewards() return #(Mock.quest.rewards or {}) end
function GetQuestItemLink(kind, index)
	local list = kind == "choice" and Mock.quest.choices or Mock.quest.rewards
	local itemID = list and list[index]
	return itemID and ("|cff0070dd|Hitem:" .. itemID .. "::::::::|h[Item]|h|r") or nil
end
-- The player's quest history and log.
Mock.questsDone, Mock.questLog, Mock.questsComplete = {}, {}, {}
Mock.level, Mock.faction = 20, "Alliance"
C_QuestLog = {
	GetTitleForQuestID = function(questID) return "Quest " .. questID end,
	IsQuestFlaggedCompleted = function(questID) return Mock.questsDone[questID] == true end,
	GetLogIndexForQuestID = function(questID) return Mock.questLog[questID] end,
	IsComplete = function(questID) return Mock.questsComplete[questID] == true end,
}
function UnitLevel() return Mock.level end
function UnitFactionGroup() return Mock.faction, Mock.faction end
function GetQuestDifficultyColor() return { r = 1, g = 1, b = 0 } end
-- As on Forever: no global GetCoinTextureString, only C_CurrencyInfo's.
C_CurrencyInfo = {
	GetCoinTextureString = function(copper)
		local gold, silver, rest = math.floor(copper / 10000), math.floor(copper / 100) % 100, copper % 100
		local parts = {}
		if gold > 0 then parts[#parts + 1] = gold .. "|TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0|t" end
		if silver > 0 then parts[#parts + 1] = silver .. "|TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0|t" end
		if rest > 0 then parts[#parts + 1] = rest .. "|TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0|t" end
		return table.concat(parts, " ")
	end,
}
function BreakUpLargeNumbers(value)
	local text = tostring(value)
	while true do
		local replaced, count = text:gsub("^(%d+)(%d%d%d)", "%1,%2")
		text = replaced
		if count == 0 then return text end
	end
end
FACTION_STANDING_INCREASED = "Reputation with %s increased by %d."

-- Reputation: the player's standing by faction id; a faction not listed is unknown.
for reaction, label in ipairs({ "Hated", "Hostile", "Unfriendly", "Neutral", "Friendly", "Honored", "Revered", "Exalted" }) do
	_G["FACTION_STANDING_LABEL" .. reaction] = label
end
FACTION_BAR_COLORS = {}
for reaction = 1, 8 do
	FACTION_BAR_COLORS[reaction] = reaction <= 3 and { r = 0.8, g = 0.3, b = 0.22 } or reaction == 4 and { r = 0.9, g = 0.7, b = 0 }
		or { r = 0, g = 0.6, b = 0.1 }
end
Mock.reputation = {
	[529] = { reaction = 6, low = 9000, high = 21000, value = 12000, description = "Defenders of the Plaguelands." },
	[576] = { reaction = 4, low = 0, high = 3000, value = 250 },
}
C_Reputation = {
	GetFactionDataByID = function(factionID)
		local entry = Mock.reputation[factionID]
		if not entry then return nil end
		return {
			factionID = factionID, name = "Faction " .. factionID, description = entry.description or "",
			reaction = entry.reaction, currentReactionThreshold = entry.low, nextReactionThreshold = entry.high,
			currentStanding = entry.value,
		}
	end,
}

-- Items: what GetItemInfoInstant answers at once, and which are already cached for GetItemInfo.
-- { equipLoc, classID, subclassID, subType }; anything unlisted is a cloth chest.
Mock.itemInstant = {
	[270227] = { "INVTYPE_NECK", 4, 0, "Miscellaneous" },
	[271096] = { "INVTYPE_WRIST", 4, 1, "Cloth" },
	[271097] = { "INVTYPE_CLOAK", 4, 1, "Cloth" },
	[270230] = { "INVTYPE_WAIST", 4, 3, "Mail" },
	[270231] = { "INVTYPE_HAND", 4, 2, "Leather" },
	[271095] = { "INVTYPE_WEAPONMAINHAND", 2, 15, "Dagger" },
}
Mock.itemsCached, Mock.itemsRequested, Mock.itemNames = {}, {}, {}
-- The toy box: Mock.toys[itemID] = true for an item it knows.
Mock.toys = {}
C_ToyBox = { GetToyInfo = function(itemID) if Mock.toys[itemID] then return itemID, "Toy " .. itemID, 134400 end end }
-- The client's name for each item class, as GetItemInfoInstant gives it.
local ITEM_CLASS_NAMES = { [0] = "Consumable", [1] = "Container", [2] = "Weapon", [4] = "Armor", [7] = "Trade Goods",
	[9] = "Recipe", [12] = "Quest", [15] = "Miscellaneous" }
-- An item asked about by id or by link.
local function ItemIDOf(item)
	if type(item) == "number" then return item end
	return tonumber(tostring(item or ""):match("item:(%d+)"))
end
local function ItemLink(itemID) return "|cff0070dd|Hitem:" .. itemID .. "::::::::|h[Item]|h|r" end
Mock.ItemLink = ItemLink
-- The Gear Finder's items: stats as C_Item.GetItemStats names them (Mock.itemStats[itemID]), the
-- level each needs (Mock.itemMinLevels) and their tooltip lines after the name
-- (Mock.itemLines[itemID] = { "text" or { text, red = true }, ... }), and the id the client
-- gives an item's tooltip data, where a test gives one (Mock.tooltipDataIDs[itemID]).
Mock.itemStats, Mock.itemMinLevels, Mock.itemLines, Mock.tooltipDataIDs = {}, {}, {}, {}
C_Item = {
	-- By id, or by link as the client also takes it.
	GetItemInfoInstant = function(item)
		local itemID = ItemIDOf(item)
		if not itemID then return nil end
		local entry = Mock.itemInstant[itemID] or { "INVTYPE_CHEST", 4, 1, "Cloth" }
		return itemID, ITEM_CLASS_NAMES[entry[2]], entry[4], entry[1], 134400 + itemID % 7, entry[2], entry[3]
	end,
	-- A cached item's name: Mock.itemNames[itemID] where a test gives one, else "Cached <id>".
	GetItemInfo = function(item)
		local itemID = ItemIDOf(item)
		if not itemID or not Mock.itemsCached[itemID] then return nil end
		local entry = Mock.itemInstant[itemID] or { "INVTYPE_CHEST", 4, 1, "Cloth" }
		return Mock.itemNames[itemID] or ("Cached " .. itemID), ItemLink(itemID), 3, 20,
			Mock.itemMinLevels[itemID] or 1, ITEM_CLASS_NAMES[entry[2]], entry[4], 1, entry[1]
	end,
	GetItemStats = function(link)
		local stats = Mock.itemStats[ItemIDOf(link)]
		if not stats then return {} end
		local copy = {}
		for key, value in pairs(stats) do copy[key] = value end
		return copy
	end,
	IsItemDataCachedByID = function(itemID) return Mock.itemsCached[itemID] == true end,
	RequestLoadItemDataByID = function(itemID) Mock.itemsRequested[itemID] = true end,
	GetItemQualityColor = function() return 0, 0.44, 0.87, "ff0070dd" end,
}
-- What the player wears: Mock.worn[inventorySlot] = itemID.
Mock.worn = {}
function GetInventoryItemLink(unit, slot)
	local itemID = unit == "player" and Mock.worn[slot]
	return itemID and ItemLink(itemID) or nil
end

-- Retail's tooltip data: an item tooltip runs the item post-calls once its lines are in, with
-- the data's id and link, as the client's TooltipDataProcessor does.
Enum = Enum or {}
Enum.TooltipDataType = { Item = 0, Spell = 1, Unit = 2 }
Mock.tooltipPostCalls = {}
TooltipDataProcessor = {
	AddTooltipPostCall = function(dataType, callback)
		Mock.tooltipPostCalls[dataType] = Mock.tooltipPostCalls[dataType] or {}
		table.insert(Mock.tooltipPostCalls[dataType], callback)
	end,
}
-- The client's settings panel (Blizzard_Settings_Shared): an addon's page, its proxy settings by
-- variable (Mock.settings) and the page last opened (Mock.openedSettings).
Mock.settings, Mock.settingsNotified = {}, {}
Settings = {
	VarType = { Boolean = "boolean", Number = "number", String = "string" },
	RegisterVerticalLayoutCategory = function(name)
		local category = { name = name, controls = {} }
		function category:GetID() return "category:" .. name end
		return category
	end,
	RegisterProxySetting = function(category, variable, variableType, name, default, getValue, setValue)
		local setting = { variable = variable, type = variableType, name = name, default = default }
		function setting:GetValue() return getValue() end
		function setting:SetValue(value) setValue(value) end
		Mock.settings[variable] = setting
		return setting
	end,
	CreateCheckbox = function(category, setting, tooltip)
		setting.tooltip = tooltip
		table.insert(category.controls, setting)
	end,
	RegisterAddOnCategory = function(category) Mock.settingsCategory = category end,
	NotifyUpdate = function(variable) Mock.settingsNotified[variable] = (Mock.settingsNotified[variable] or 0) + 1 end,
	OpenToCategory = function(categoryID) Mock.openedSettings = categoryID end,
}
-- Each copy of an item has its own guid: a worn one's names its slot (Mock.WornGUID).
function Mock.WornGUID(slot) return Mock.worn[slot] and ("Item-worn-" .. slot .. "-" .. Mock.worn[slot]) or nil end
ItemLocation = { CreateFromEquipmentSlot = function(_, slot) return { equipmentSlotIndex = slot } end }
C_Item.GetItemGUID = function(location) return Mock.WornGUID(location.equipmentSlotIndex) end
-- What the tooltip was asked to show: retail's tooltip info, its getter and the getter's arguments.
-- Mock.noItemGUIDs leaves the guids out, as a client without them would.
local function ShowItem(tooltip, link, guid, getterName, ...)
	tooltip._link = link
	tooltip._info = { getterName = getterName or "GetHyperlink", getterArgs = { ... } }
	tooltip._lines[#tooltip._lines + 1] = Mock.itemNames[ItemIDOf(link)] or link
	if Mock.noItemGUIDs then guid = nil end
	local data = { type = Enum.TooltipDataType.Item, id = ItemIDOf(link), hyperlink = link, guid = guid }
	for _, callback in ipairs(Mock.tooltipPostCalls[Enum.TooltipDataType.Item] or {}) do callback(tooltip, data) end
end
function GameTooltip:SetHyperlink(link) ShowItem(self, link) end
function GameTooltip:SetItemByID(itemID) ShowItem(self, ItemLink(itemID)) end
function GameTooltip:SetInventoryItem(unit, slot)
	local link = GetInventoryItemLink(unit, slot)
	if link then ShowItem(self, link, unit == "player" and Mock.WornGUID(slot) or nil, "GetInventoryItem", unit, slot) end
end
-- A bag's item: Mock.bagItems["bag:slot"] = { itemID, guid }.
Mock.bagItems = {}
C_Container = C_Container or {}
function C_Container.GetContainerItemLink(bag, slot)
	local item = Mock.bagItems[bag .. ":" .. slot]
	return item and ItemLink(item[1]) or nil
end
-- The bags (ContainerFrameCombinedBags): its item buttons, each with its bag and slot
-- (Mock.BagButton), drawn again by UpdateItems as the client's are.
ContainerFrameCombinedBags = CreateFrame("Frame", "ContainerFrameCombinedBags", UIParent)
ContainerFrameCombinedBags._buttons = {}
ContainerFrameCombinedBags:Hide()
function ContainerFrameCombinedBags:UpdateItems() end
function ContainerFrameCombinedBags:EnumerateValidItems() return ipairs(self._buttons) end
function Mock.BagButton(bag, slot)
	local button = CreateFrame("Button", nil, ContainerFrameCombinedBags)
	button:SetID(slot)
	-- The vendor's junk coin, in the top left as the arrow (ContainerFrame.xml), hidden.
	button.JunkIcon = button:CreateTexture(nil, "OVERLAY", nil, 5)
	button.JunkIcon:Hide()
	function button:GetBagID() return bag end
	table.insert(ContainerFrameCombinedBags._buttons, button)
	return button
end
-- The loot window: its rows (Mock.LootRow), each an item button for a loot slot, in a scroll box.
Mock.lootRows = {}
LootFrame = CreateFrame("Frame", "LootFrame", UIParent)
LootFrame:Hide()
LootFrame.ScrollBox = { ForEachFrame = function(_, callback) for _, row in ipairs(Mock.lootRows) do callback(row) end end }
LootFrameItemElementMixin = { Init = function() end }
function LootFrameItemElementMixin:GetSlotIndex() return self._slot end
-- A row the list made, or took back and gave another slot (Mock.LootRow(slot, row)).
function Mock.LootRow(slot, row)
	if not row then
		row = Mixin(CreateFrame("Frame", nil, LootFrame), LootFrameItemElementMixin)
		row.Item = CreateFrame("Button", nil, row)
		table.insert(Mock.lootRows, row)
	end
	row._slot = slot
	row:Init()
	return row
end
LOOT_SLOT_ITEM = 1
function GetLootSlotType(slot) return Mock.lootSlots[slot] and Mock.lootSlots[slot].link and 1 or 0 end
-- Group loot rolls: GroupLootFrame1-4, each with its item's icon; the item by roll (Mock.rolls).
Mock.rolls = {}
function GetLootRollItemLink(rollID) return Mock.rolls[rollID] end
function GroupLootFrame_SetupItemDisplay(frame) return frame.rollID ~= nil end
for index = 1, 4 do
	local frame = CreateFrame("Frame", "GroupLootFrame" .. index, UIParent)
	frame.IconFrame = CreateFrame("Button", nil, frame)
	frame:SetScript("OnShow", function(self) GroupLootFrame_SetupItemDisplay(self) end)
	frame:Hide()
end
-- The gamepad's roll cards (Mock.RollCard): set up by the same function, never shown as frames 1-4.
function Mock.RollCard(rollID)
	local card = CreateFrame("Frame", nil, UIParent)
	card.IconFrame = CreateFrame("Button", nil, card)
	card.rollID = rollID
	GroupLootFrame_SetupItemDisplay(card)
	return card
end
function GameTooltip:SetBagItem(bag, slot)
	local item = Mock.bagItems[bag .. ":" .. slot]
	if item then ShowItem(self, ItemLink(item[1]), item[2], "GetBagItem", bag, slot) end
end
function GameTooltip:GetPrimaryTooltipInfo() return self._info end
function GameTooltip:GetItem()
	if self._link then return Mock.itemNames[ItemIDOf(self._link)] or "Item", self._link end
end
function GetInventoryItemTexture(unit, slot)
	local itemID = unit == "player" and Mock.worn[slot]
	return itemID and 134400 + itemID % 7 or nil
end
function GetInventoryItemQuality(unit, slot)
	return unit == "player" and Mock.worn[slot] and 2 or nil
end
-- Spells the player knows, by id (674 is Dual Wield).
Mock.knownSpells = {}
function IsPlayerSpell(spellID) return Mock.knownSpells[spellID] == true end
-- Spells: what the client knows; anything unlisted is an instant with no description yet.
Mock.spells = {
	[13860] = { name = "Mind Blast", iconID = 136224, castTime = 1500,
		description = "Blasts the target for |cffffffff54|r Shadow damage." },
	[1292602] = { name = "Anvilmar's Curse", iconID = 136139, castTime = 0, description = "Curses an enemy." },
}
Mock.spellsRequested = {}
C_Spell = {
	GetSpellInfo = function(spellID)
		local spell = Mock.spells[spellID]
		if spell then return { name = spell.name, iconID = spell.iconID, castTime = spell.castTime } end
		return { name = "Spell " .. spellID, iconID = 134400, castTime = 0 }
	end,
	GetSpellDescription = function(spellID) return Mock.spells[spellID] and Mock.spells[spellID].description or "" end,
	RequestLoadSpellData = function(spellID) Mock.spellsRequested[spellID] = true end,
}

-- The classes by their client ids, gaps and all: Forever's, which has no Death Knight (6) or Monk
-- (10), and counts nine classes though the Druid is 11.
Mock.classes = {
	[1] = { "Warrior", "WARRIOR" }, [2] = { "Paladin", "PALADIN" }, [3] = { "Hunter", "HUNTER" },
	[4] = { "Rogue", "ROGUE" }, [5] = { "Priest", "PRIEST" }, [7] = { "Shaman", "SHAMAN" }, [8] = { "Mage", "MAGE" },
	[9] = { "Warlock", "WARLOCK" }, [11] = { "Druid", "DRUID" },
}
function GetNumClasses() return 9 end
function GetClassInfo(classID)
	local class = Mock.classes[classID]
	if not class then return nil end
	return class[1], class[2], classID
end
Mock.playerClass = "MAGE"
-- The player's class, with its id as the client numbers it.
function UnitClass()
	for classID, class in pairs(Mock.classes) do
		if class[2] == Mock.playerClass then return class[1], class[2], classID end
	end
	return "Mage", Mock.playerClass, 8
end
function HandleModifiedItemClick() return false end
function IsModifiedClick() return false end
INVTYPE_NECK, INVTYPE_WRIST, INVTYPE_CLOAK, INVTYPE_WAIST, INVTYPE_HAND = "Neck", "Wrist", "Back", "Waist", "Hands"
INVTYPE_WEAPONMAINHAND, INVTYPE_CHEST = "Main Hand", "Chest"

-- The vendor window: Mock.merchant = { { itemID, name, price, lines = { tooltip line, ... } }, ... }.
Mock.merchant = {}
ITEM_REQ_REPUTATION = "Requires %s - %s"
function GetBuildInfo() return "1.60.1", "70338", "Oct 1 2026", 16001 end
function GetMerchantNumItems() return #Mock.merchant end
function GetMerchantItemLink(index)
	local ware = Mock.merchant[index]
	return ware and ("|cff1eff00|Hitem:" .. ware.itemID .. "::::::::|h[" .. ware.name .. "]|h|r")
end
function GetMerchantItemInfo(index)
	local ware = Mock.merchant[index]
	if ware then return ware.name, 134400, ware.price, 1, -1, true, true, ware.costs ~= nil end
end
-- Other costs: ware.costs = { { value, name, isCurrency }, ... }.
function GetMerchantItemCostInfo(index)
	local ware = Mock.merchant[index]
	return ware and ware.costs and #ware.costs or 0
end
function GetMerchantItemCostItem(index, costIndex)
	local cost = Mock.merchant[index].costs[costIndex]
	if cost[3] then return 134400, cost[1], nil, cost[2] end
	return 134400, cost[1], "|cffffffff|Hitem:1::|h[" .. cost[2] .. "]|h|r", nil
end
C_TooltipInfo = {
	GetHyperlink = function(link)
		local itemID = ItemIDOf(link)
		if not itemID or not Mock.itemsCached[itemID] then return nil end
		local lines = { { leftText = Mock.itemNames[itemID] or ("Cached " .. itemID) } }
		for _, line in ipairs(Mock.itemLines[itemID] or {}) do
			if type(line) == "table" then
				lines[#lines + 1] = { leftText = line[1], leftColor = line.red and { r = 1, g = 0.13, b = 0.13 } or nil }
			else
				lines[#lines + 1] = { leftText = line }
			end
		end
		return { lines = lines, dataInstanceID = Mock.tooltipDataIDs[itemID] }
	end,
	GetMerchantItem = function(index)
		local ware = Mock.merchant[index]
		if not ware then return nil end
		local lines = { { leftText = ware.name } }
		for _, text in ipairs(ware.lines or {}) do lines[#lines + 1] = { leftText = text } end
		return { lines = lines }
	end,
}

Mock.units = {}
function UnitName(unit) return Mock.units[unit] and Mock.units[unit].name end
-- The loot chat's lines, and the loot history: drops by "encounterID:lootListID", encounters by id.
LOOT_ITEM, LOOT_ITEM_MULTIPLE = "%s receives loot: %s.", "%s receives loot: %sx%d."
LOOT_ITEM_SELF, LOOT_ITEM_SELF_MULTIPLE = "You receive loot: %s.", "You receive loot: %sx%d."
LOOT_ITEM_PUSHED_SELF = "You receive item: %s."
MISCELLANEOUS = "Miscellaneous"
Mock.lootHistory, Mock.lootEncounters = {}, {}
C_LootHistory = {
	GetSortedInfoForDrop = function(encounterID, lootListID) return Mock.lootHistory[encounterID .. ":" .. lootListID] end,
	GetInfoForEncounter = function(encounterID) return Mock.lootEncounters[encounterID] end,
}
function UnitGUID(unit) return Mock.units[unit] and Mock.units[unit].guid end

StaticPopupDialogs = {}
function StaticPopup_Show(name) Mock.popup = name end
YES, NO = "Yes", "No"

function strsplit(delimiter, text)
	local parts, start = {}, 1
	while true do
		local found = string.find(text, delimiter, start, true)
		if not found then
			parts[#parts + 1] = string.sub(text, start)
			break
		end
		parts[#parts + 1] = string.sub(text, start, found - 1)
		start = found + #delimiter
	end
	return unpack(parts)
end

function strtrim(text)
	text = string.gsub(text, "^%s+", "")
	text = string.gsub(text, "%s+$", "")
	return text
end
function wipe(t) for key in pairs(t) do t[key] = nil end return t end
tinsert, tremove = table.insert, table.remove
format = string.format
