local _, ns = ...
local L = ns.L

--[[
	The world map's side panel on Forever is retail's (QuestMapFrame), with its Quests and Map
	Legend tabs hidden by the Camelot rules (QuestMapFrameOverrides). This shows the two tabs
	again, where retail has them, and teaches the legend the journal's own map icons:
	hovering its Dungeon, Raid or Flightpoint entry lights up the journal's entrances and
	flight points, as it does the client's own on retail, hovering one of those lights up its
	entry, and Cave Entrance and Transport entries join Movement for the journal's own icons.

	Blizzard's frames are only shown, anchored and hooked after their own code; nothing of
	theirs is replaced or written into.
]]

local MapLegend = {}
ns.MapLegend = MapLegend

local ENTRANCE_TEMPLATE = "AegisJournalEntrancePinTemplate"
local CAVE_TEMPLATE = "AegisJournalCavePinTemplate"
local FLIGHT_TEMPLATE = "AegisJournalFlightPinTemplate"
-- The client's own pins the legend's entries are made for.
local CLIENT_ENTRANCE_TEMPLATE = "DungeonEntrancePinTemplate"
local CLIENT_FLIGHT_TEMPLATE = "FlightPointPinTemplate"

local TRANSPORT_TEMPLATE = "AegisJournalTransportPinTemplate"

-- The entries the journal adds under Movement, in order.
local ADDED_ENTRIES = {
	{
		kind = "cave",
		Atlas = "CaveUnderground-Up",
		Name = MAP_LEGEND_CAVE or L.CAVE_LABEL,
		Tooltip = MAP_LEGEND_CAVE_TOOLTIP or L.LEGEND_CAVE_TOOLTIP,
		TemplateNames = { CAVE_TEMPLATE },
	},
	{
		kind = "transport",
		Atlas = "TaxiNode_Continent_Neutral",
		Name = L.LEGEND_TRANSPORT,
		Tooltip = L.LEGEND_TRANSPORT_TOOLTIP,
		TemplateNames = { TRANSPORT_TEMPLATE },
	},
}

-- The legend's entry for each kind of pin: "dungeon", "raid", "cave", "flight", "transport".
local entries = {}
local hooked = false

-- Camelot's metal border stops this much short of where retail's does, so its offset for the
-- tabs (5, retail's 3) leaves a gap: the tabs are pulled in to sit against the border, as on
-- retail.
local TAB_PULL_IN = 6

-- Camelot hides the tabs on every refresh of the quest log, so they are shown after it. The
-- legend's tab sits under the events tab where the client shows one, else under the quests tab.
local function ShowTabs()
	local log = QuestMapFrame
	local overrides = QuestMapFrameOverrides
	local x, y = 5, -28
	if overrides and overrides.GetQuestsTabAnchorOffset then x, y = overrides.GetQuestsTabAnchorOffset() end
	log.QuestsTab:ClearAllPoints()
	log.QuestsTab:SetPoint("TOPLEFT", log, "TOPRIGHT", x - TAB_PULL_IN, y)
	local eventsHidden = overrides and overrides.eventsTabHidden
	local above = not eventsHidden and log.EventsTab and log.EventsTab:IsShown() and log.EventsTab or log.QuestsTab
	log.QuestsTab:Show()
	log.MapLegendTab:ClearAllPoints()
	log.MapLegendTab:SetPoint("TOP", above, "BOTTOM", 0, -3)
	log.MapLegendTab:Show()
end

local function Contains(list, value)
	for _, item in ipairs(list or {}) do
		if item == value then return true end
	end
	return false
end

-- A category's entries in the order Blizzard laid them out.
local function Entries(category)
	local list = {}
	for _, child in ipairs({ category:GetChildren() }) do
		if child.templates then list[#list + 1] = child end
	end
	table.sort(list, function(a, b) return (a.layoutIndex or 0) < (b.layoutIndex or 0) end)
	return list
end

-- The journal's pins of one kind glow while their legend entry is hovered, as retail's do.
local function GlowPins(template, isRaid, on)
	if not (WorldMapFrame and WorldMapFrame.EnumeratePinsByTemplate) then return end
	for pin in WorldMapFrame:EnumeratePinsByTemplate(template) do
		if isRaid == nil or pin.isRaid == isRaid then
			if on then pin:ShowMapLegendGlow() else pin:HideMapLegendGlow() end
		end
	end
end

local function HookEntry(entry, template, isRaid)
	entry:HookScript("OnEnter", function() GlowPins(template, isRaid, true) end)
	entry:HookScript("OnLeave", function() GlowPins(template, isRaid, false) end)
end

-- Adds the journal's own entries under Movement, laid out on the category's grid as Blizzard
-- does.
local function AddEntries(category, legend)
	local list = Entries(category)
	for _, info in ipairs(ADDED_ENTRIES) do
		if ns.AtlasExists(info.Atlas) then
			local ok, entry = pcall(CreateFrame, "Button", nil, category, "MapLegendButtonTemplate")
			if ok and entry and entry.InitializeButton then
				entry:InitializeButton(info, #list + 1)
				list[#list + 1] = entry
				entries[info.kind] = entry
			end
		end
	end
	if AnchorUtil and AnchorUtil.GridLayout and GridLayoutMixin and CreateAnchor then
		local layout = AnchorUtil.CreateGridLayout(GridLayoutMixin.Direction.TopLeftToBottomRight, 2, 0, 5)
		AnchorUtil.GridLayout(list, CreateAnchor("TOPLEFT", category, "TOPLEFT", 0, -3), layout)
	end
	if category.Layout then category:Layout() end
	local scroll = legend.ScrollFrame
	if scroll.ScrollChild.Layout then scroll.ScrollChild:Layout() end
	if scroll.UpdateScrollChildRect then scroll:UpdateScrollChildRect() end
end

local function TeachLegend(legend)
	local scroll = legend and legend.ScrollFrame
	if not (scroll and scroll.ScrollChild) then return end
	local movement, last
	for _, category in ipairs({ scroll.ScrollChild:GetChildren() }) do
		last = category
		for _, entry in ipairs(Entries(category)) do
			if Contains(entry.templates, CLIENT_ENTRANCE_TEMPLATE) and entry.metaData then
				local isRaid = entry.metaData.isRaid == true
				entries[isRaid and "raid" or "dungeon"] = entry
				HookEntry(entry, ENTRANCE_TEMPLATE, isRaid)
			elseif Contains(entry.templates, CLIENT_FLIGHT_TEMPLATE) then
				movement = category
				entries.flight = entry
				HookEntry(entry, FLIGHT_TEMPLATE, nil)
			end
		end
	end
	movement = movement or last
	if movement then AddEntries(movement, legend) end
end

function MapLegend:SetUp()
	if hooked then return true end
	local log = QuestMapFrame
	if not (log and log.QuestsTab and log.MapLegendTab and log.ValidateTabs) then return false end
	hooked = true
	hooksecurefunc(log, "ValidateTabs", ShowTabs)
	ShowTabs()
	TeachLegend(log.MapLegend)
	return true
end

-- A journal pin under the mouse lights up its legend entry, as the client's own pins do.
function MapLegend:PinEnter(kind)
	local entry = entries[kind]
	if entry and entry.SetHighlightLocked then entry:SetHighlightLocked(true) end
end

function MapLegend:PinLeave(kind)
	local entry = entries[kind]
	if entry and entry.SetHighlightLocked then entry:SetHighlightLocked(false) end
end

-- The legend's entries, for the smoke test.
function MapLegend:Entry(kind)
	return entries[kind]
end

local events = CreateFrame("Frame")
ns.RegisterEvents(events, "PLAYER_LOGIN")
events:SetScript("OnEvent", function(self)
	MapLegend:SetUp()
	ns.UnregisterEvents(self, "PLAYER_LOGIN")
end)
