local _, ns = ...
local L = ns.L

--[[
	The world map's side panel on Forever is retail's (QuestMapFrame), with its Quests and Map
	Legend tabs hidden by the Camelot rules (QuestMapFrameOverrides). This shows the two tabs
	again, where retail has them, and teaches the legend the journal's own map icons:
	hovering its Dungeon, Raid or Flightpoint entry lights up the journal's entrances and
	flight points, and its Quest and Turn In entries the journal's quest marks ("!" and "?"), as
	it does the client's own on retail; hovering one of those lights up its entry; and Cave
	Entrance and Transport entries join Movement for the journal's own icons. A quest in the log
	pointed at on the map lights its In Progress or Turn In entry only (see KeepDarkForLog).

	Blizzard's frames are only shown, anchored and hooked after their own code; nothing of
	theirs is replaced or written into.
]]

local MapLegend = {}
ns.MapLegend = MapLegend

--[[
	Every entry of the legend is a switch, as the map's filter menu is: a click hides that kind of
	marker on the world map, another shows it again, and a hidden kind's entry is dimmed.

	The journal's own markers (dungeon and raid doors, flight points, caves, transports) are hidden
	by the journal, for the account (ns.db.mapHidden). The game's quest markers are hidden by the
	game's own map filters, the ones its filter menu sets, so the two always agree: quests on offer
	("questPOILocalStory": the Quest entry), and quests in the log ("questPOI": In Progress and Turn
	In together, as the game has one filter for both). The journal's "!" and "?" marks follow those
	filters. Repeatable quests have no filter of their own, so their entry is no switch.
]]
local SWITCHES = {
	dungeon = {}, raid = {}, flight = {}, cave = {}, transport = {},
	quest = { cvar = "questPOILocalStory" }, turnin = { cvar = "questPOI" }, inprogress = { cvar = "questPOI" },
}
local DIMMED_ALPHA = 0.45

local ENTRANCE_TEMPLATE = "AegisJournalEntrancePinTemplate"
local CAVE_TEMPLATE = "AegisJournalCavePinTemplate"
local FLIGHT_TEMPLATE = "AegisJournalFlightPinTemplate"
-- The client's own pins the legend's entries are made for.
local CLIENT_ENTRANCE_TEMPLATE = "DungeonEntrancePinTemplate"
local CLIENT_FLIGHT_TEMPLATE = "FlightPointPinTemplate"
-- The journal's quest marks (UI/QuestMap.lua), and the client's quests on offer, whose entry
-- (Quest) and whose handing in (Turn In) light them up.
local QUEST_TEMPLATE = "AegisJournalQuestPinTemplate"
local CLIENT_QUEST_OFFER_TEMPLATE = "QuestOfferPinTemplate"
-- The client's marks of the quests in the log (In Progress, Turn In).
local CLIENT_QUEST_LOG_TEMPLATE = "QuestPinTemplate"

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

-- The journal's pins of one kind glow while their legend entry is hovered, as retail's do: those
-- `matches` picks, or all of them.
local function GlowPins(template, matches, on)
	if not (WorldMapFrame and WorldMapFrame.EnumeratePinsByTemplate) then return end
	for pin in WorldMapFrame:EnumeratePinsByTemplate(template) do
		if not matches or matches(pin) then
			if on then pin:ShowMapLegendGlow() else pin:HideMapLegendGlow() end
		end
	end
end

local function HookEntry(entry, template, matches)
	entry:HookScript("OnEnter", function() GlowPins(template, matches, true) end)
	entry:HookScript("OnLeave", function() GlowPins(template, matches, false) end)
end

--[[
	The client lights every entry a pointed-at pin matches, by its look (In Progress, Turn In) or by
	its quest's kind (Quest, Repeatable), and a quest in the log is of a kind too: its mark lit Quest
	beside In Progress. The kinds stand for quests on offer, so while one of the client's marks of a
	quest in the log is pointed at, their entries are put out again. Their highlight is hooked, after
	the client's code, and the pin pointed at is heard from the client's own callback; the two come in
	no set order, so each puts them out.
]]
local kindEntries = {}
local pointedAt

local function InLog(pin)
	return type(pin) == "table" and pin.pinTemplate == CLIENT_QUEST_LOG_TEMPLATE
end

local function KeepDarkForLog(entry)
	kindEntries[#kindEntries + 1] = entry
	hooksecurefunc(entry, "SetHighlightLocked", function(self, locked)
		if locked and InLog(pointedAt) then self:SetHighlightLocked(false) end
	end)
end

local function HearPointedAt()
	if not (EventRegistry and EventRegistry.RegisterCallback) then return end
	EventRegistry:RegisterCallback("MapLegendPinOnEnter", function(_, pin)
		pointedAt = pin
		if not InLog(pin) then return end
		for _, entry in ipairs(kindEntries) do entry:SetHighlightLocked(false) end
	end, MapLegend)
	EventRegistry:RegisterCallback("MapLegendPinOnLeave", function() pointedAt = nil end, MapLegend)
end

local function IsRaid(isRaid) return function(pin) return pin.isRaid == isRaid end end
local function QuestMark(kind) return function(pin) return pin.mark ~= nil and pin.mark.kind == kind end end

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
	local normal = Enum and Enum.QuestClassification and Enum.QuestClassification.Normal
	local complete = POIButtonUtil and POIButtonUtil.Style and POIButtonUtil.Style.QuestComplete
	local inProgress = POIButtonUtil and POIButtonUtil.Style and POIButtonUtil.Style.QuestInProgress
	for _, category in ipairs({ scroll.ScrollChild:GetChildren() }) do
		last = category
		for _, entry in ipairs(Entries(category)) do
			local meta = entry.metaData
			if meta and meta.questClassification ~= nil and Contains(entry.templates, CLIENT_QUEST_LOG_TEMPLATE) then
				KeepDarkForLog(entry)
			end
			if Contains(entry.templates, CLIENT_ENTRANCE_TEMPLATE) and meta then
				local isRaid = meta.isRaid == true
				entries[isRaid and "raid" or "dungeon"] = entry
				HookEntry(entry, ENTRANCE_TEMPLATE, IsRaid(isRaid))
			elseif Contains(entry.templates, CLIENT_FLIGHT_TEMPLATE) then
				movement = category
				entries.flight = entry
				HookEntry(entry, FLIGHT_TEMPLATE, nil)
			elseif meta and normal ~= nil and meta.questClassification == normal
				and Contains(entry.templates, CLIENT_QUEST_OFFER_TEMPLATE) then
				entries.quest = entry
				HookEntry(entry, QUEST_TEMPLATE, QuestMark("start"))
			elseif meta and complete ~= nil and meta.Style == complete then
				entries.turnin = entry
				HookEntry(entry, QUEST_TEMPLATE, QuestMark("turnin"))
			elseif meta and inProgress ~= nil and meta.Style == inProgress then
				entries.inprogress = entry
			end
		end
	end
	movement = movement or last
	if movement then AddEntries(movement, legend) end
	MapLegend:MakeSwitches()
end

function MapLegend:SetUp()
	if hooked then return true end
	local log = QuestMapFrame
	if not (log and log.QuestsTab and log.MapLegendTab and log.ValidateTabs) then return false end
	hooked = true
	hooksecurefunc(log, "ValidateTabs", ShowTabs)
	ShowTabs()
	TeachLegend(log.MapLegend)
	HearPointedAt()
	return true
end

-- Whether the world map shows this kind of marker (a SWITCHES kind); any other kind, always.
function MapLegend.Shows(kind)
	local switch = SWITCHES[kind]
	if not switch then return true end
	if switch.cvar then
		local value = GetCVar and GetCVar(switch.cvar)
		return value == nil or value == "1"
	end
	return not (ns.db and ns.db.mapHidden and ns.db.mapHidden[kind])
end

-- A hidden kind's entry is dimmed.
local function PaintSwitches()
	for kind in pairs(SWITCHES) do
		local entry = entries[kind]
		if entry then
			local shown = MapLegend.Shows(kind)
			entry:SetAlpha(shown and 1 or DIMMED_ALPHA)
			local icon = entry.Icon
			if type(icon) == "table" and icon.SetDesaturated then icon:SetDesaturated(not shown) end
		end
	end
end

-- The journal's own markers drawn again; the game redraws its own when its filters change.
local function RedrawJournalMarkers()
	ns.DungeonMap:RefreshEntrances()
	ns.TravelMap:Refresh()
	ns.QuestMap:Refresh()
end

function MapLegend:Toggle(kind)
	local switch = SWITCHES[kind]
	if not switch then return end
	local show = not MapLegend.Shows(kind)
	if switch.cvar then
		if type(SetCVar) == "function" then pcall(SetCVar, switch.cvar, show and "1" or "0") end
	else
		ns.db.mapHidden = ns.db.mapHidden or {}
		ns.db.mapHidden[kind] = (not show) or nil
	end
	ns.PlaySoundKit(show and "IG_MAINMENU_OPTION_CHECKBOX_ON" or "IG_MAINMENU_OPTION_CHECKBOX_OFF")
	PaintSwitches()
	RedrawJournalMarkers()
end

-- Each switch's entry: a click toggles it, and its tooltip says so. Blizzard's entries are only
-- hooked, once each (kept in the journal's own table, nothing written into them).
local switched = setmetatable({}, { __mode = "k" })

function MapLegend:MakeSwitches()
	for kind, switch in pairs(SWITCHES) do
		local entry = entries[kind]
		if entry and not switched[entry] then
			switched[entry] = true
			entry:HookScript("OnClick", function() MapLegend:Toggle(kind) end)
			entry:HookScript("OnEnter", function()
				local tooltip = GameTooltip
				if not (tooltip and tooltip:IsShown()) then return end
				tooltip:AddLine(MapLegend.Shows(kind) and L.LEGEND_CLICK_HIDE or L.LEGEND_CLICK_SHOW, 0.1, 1, 0.1)
				if switch.cvar then tooltip:AddLine(L.LEGEND_GAME_FILTER, 0.6, 0.6, 0.6, true) end
				tooltip:Show()
			end)
		end
	end
	PaintSwitches()
end

-- The game's filters can change from its own filter menu too.
function MapLegend:FiltersChanged()
	PaintSwitches()
	ns.QuestMap:Refresh()
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
ns.RegisterEvents(events, "PLAYER_LOGIN", "CVAR_UPDATE")
events:SetScript("OnEvent", function(self, event, name)
	if event == "CVAR_UPDATE" then
		if name == SWITCHES.quest.cvar or name == SWITCHES.turnin.cvar then MapLegend:FiltersChanged() end
		return
	end
	MapLegend:SetUp()
	ns.UnregisterEvents(self, "PLAYER_LOGIN")
end)
