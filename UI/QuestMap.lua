local _, ns = ...
local L = ns.L

--[[
	The journal's quests on the maps, as the client marks its own: a "!" where a dungeon or
	raid quest starts, while it can be taken (greyed while it cannot yet: a step of its chain
	or the level still to come); a "?" where it is handed in, once it is ready to; nothing while
	it is under way, or once it is done.

	On Blizzard's world map the marks stand where each quest's giver does (the quest's start,
	as the Quests tab's Show Start has it); quests that start inside a dungeon have their mark
	on the journal's map of it (startInside: x, y and floor on its picture). Their state is the
	Quests tab's, from the player's own quest log and history, and follows it as it changes.

	A left click opens the quest in the journal; a right click sets a waypoint (on the world
	map) or puts the dungeon's map away (on it), as the journal's other marks do. Where the
	client already marks a quest itself, it is left to the client's mark.
]]

local QuestMap = {}
ns.QuestMap = QuestMap

local QUEST_PIN_TEMPLATE = "AegisJournalQuestPinTemplate"
-- The client's own marks for the quests on offer (QuestOfferDataProvider), which carry their quest's id.
local CLIENT_OFFER_TEMPLATE = "QuestOfferPinTemplate"
local START_ATLAS, TURN_IN_ATLAS = "QuestNormal", "QuestTurnin"
local LOCKED_ALPHA = 0.8
local RED, GREEN = { 1, 0.3, 0.3 }, { 0.1, 1, 0.1 }
local REFRESH_DELAY = 0.2

local provider

------------------------------------------------------------------------------------------
-- What each quest shows
------------------------------------------------------------------------------------------

--[[
	A quest's mark now, or nil: { kind = "start" or "turnin", point = its place on the world
	map (or nil), inside = its spot on the dungeon's map (or nil), locked = why it cannot be
	taken yet (or nil) }.
]]
function QuestMap:Mark(quest)
	local panel = ns.QuestsPanel
	local status = panel:Status(quest)
	if status == "done" or status == "active" then return nil end
	if status == "ready" then
		return { kind = "turnin", point = panel:EndPoint(quest), inside = quest.endInside }
	end
	local mark = { kind = "start", point = panel:StartPoint(quest), inside = quest.startInside }
	if status == "locked" then mark.locked = panel:LockedReason(quest) end
	return mark
end

--[[
	Which quests may have a mark on a map, so that a map looks at its own few rather than every
	quest of every dungeon: by the maps their start and end are on, rebuilt when the data changes
	(the registry then hands out new lists). Places the Record tab saw are looked up as the map is
	drawn: there are few.
]]
local index = {}

local function AddOn(byMap, mapID, entry)
	local list = byMap[mapID]
	if not list then
		list = {}
		byMap[mapID] = list
	end
	if list[#list] ~= entry then list[#list + 1] = entry end
end

local function Index()
	local dungeons, raids = ns.GetInstances("dungeon"), ns.GetInstances("raid")
	if index.byMap and index.dungeons == dungeons and index.raids == raids then return index end
	local byMap, byQuestID = {}, {}
	for _, list in ipairs({ dungeons, raids }) do
		for _, instance in ipairs(list) do
			for _, quest in ipairs(instance.quests or {}) do
				-- A quest several dungeons list (the paladin's Tome of Valor parts, a monastery quest
				-- in each wing it sends you to) has one mark, opening the first of them.
				if not byQuestID[quest.questID] then
					local entry = { instance = instance, quest = quest }
					byQuestID[quest.questID] = entry
					if quest.startMap and quest.startMap.mapID then AddOn(byMap, quest.startMap.mapID, entry) end
					if quest.endMap and quest.endMap.mapID then AddOn(byMap, quest.endMap.mapID, entry) end
				end
			end
		end
	end
	index.dungeons, index.raids, index.byMap, index.byQuestID = dungeons, raids, byMap, byQuestID
	return index
end

-- The dungeon and raid quests this character can take with a mark on this map: { instance, quest, mark, x, y }.
function QuestMap:MarksOn(mapID)
	local known = Index()
	local candidates, seen = {}, {}
	for _, entry in ipairs(known.byMap[mapID] or {}) do
		candidates[#candidates + 1], seen[entry] = entry, true
	end
	local state = ns.Recorder and ns.Recorder:GetState()
	for questID, recorded in pairs(state and state.quests or {}) do
		local entry = known.byQuestID[questID]
		if entry and not seen[entry] then
			for _, step in ipairs({ recorded.pickup or false, recorded.turnin or false }) do
				if step and step.place and step.place.mapID == mapID and not seen[entry] then
					candidates[#candidates + 1], seen[entry] = entry, true
				end
			end
		end
	end
	local list = {}
	for _, entry in ipairs(candidates) do
		if ns.QuestsPanel:IsForPlayer(entry.quest) then
			local mark = self:Mark(entry.quest)
			local point = mark and mark.point
			if point and point.mapID == mapID and point.x then
				list[#list + 1] = { instance = entry.instance, quest = entry.quest, mark = mark, x = point.x, y = point.y }
			end
		end
	end
	return list
end

--[[
	The marks inside one dungeon, on one floor of its map: { quest, mark, x, y }. A quest whose
	start lies in one of several places (an item that is not always in the same spot) gives
	startInside as a list of spots, and has a mark on each, its tooltip saying how many.
]]
function QuestMap:InsideMarks(instance, floorIndex)
	local list = {}
	for _, quest in ipairs(instance.quests or {}) do
		if ns.QuestsPanel:IsForPlayer(quest) then
			local mark = self:Mark(quest)
			local inside = mark and mark.inside
			local spots = inside and (inside.x and { inside } or inside) or {}
			if #spots > 1 then mark.places = #spots end
			for _, spot in ipairs(spots) do
				if (spot.floor or 1) == floorIndex then
					list[#list + 1] = { quest = quest, mark = mark, x = spot.x, y = spot.y }
				end
			end
		end
	end
	return list
end

function QuestMap:SetMarkTexture(texture, mark)
	texture:SetAtlas(mark.kind == "turnin" and TURN_IN_ATLAS or START_ATLAS)
	texture:SetDesaturated(mark.locked ~= nil)
	texture:SetAlpha(mark.locked and LOCKED_ALPHA or 1)
end

function QuestMap:ShowTooltip(owner, instance, quest, mark, clickLines)
	GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
	GameTooltip:SetText(quest.name, 1, 0.82, 0)
	local kind = instance.kind == "raid" and L.QUESTMAP_RAID_QUEST or L.QUESTMAP_DUNGEON_QUEST
	GameTooltip:AddLine(string.format(kind, instance.name), 1, 1, 1)
	local place = mark.point and mark.point.label
	if place then GameTooltip:AddLine(place, 0.8, 0.8, 0.8, true) end
	if mark.places then GameTooltip:AddLine(string.format(L.QUESTMAP_ONE_OF, mark.places), 0.8, 0.8, 0.8, true) end
	if mark.kind == "turnin" then
		GameTooltip:AddLine(L.QUEST_STATUS_READY, GREEN[1], GREEN[2], GREEN[3])
	elseif mark.locked then
		GameTooltip:AddLine(mark.locked, RED[1], RED[2], RED[3])
	end
	for _, line in ipairs(clickLines) do GameTooltip:AddLine(line, 0.1, 1, 0.1) end
	GameTooltip:Show()
end

-- Opens the quest in the journal, putting the world map away first (out of combat only).
function QuestMap:Open(instance, quest)
	ns.PlaySoundKit("IG_SPELLBOOK_OPEN")
	if WorldMapFrame and WorldMapFrame:IsShown() and not InCombatLockdown() and type(HideUIPanel) == "function" then
		pcall(HideUIPanel, WorldMapFrame)
	end
	ns.QuestsPanel:Open(instance, quest)
end

------------------------------------------------------------------------------------------
-- The marks on Blizzard's world map
------------------------------------------------------------------------------------------

AegisJournalQuestPinMixin = {}
local PinMethods = {
	ShowMapLegendGlow = ns.DungeonMap.ShowMapLegendGlow,
	HideMapLegendGlow = ns.DungeonMap.HideMapLegendGlow,
	-- Safe to hand out in combat (UI/DungeonMap.lua).
	CheckMouseButtonPassthrough = ns.DungeonMap.CheckMouseButtonPassthrough,
}

-- Both buttons belong to the mark: a right click sets the waypoint instead of zooming out.
function PinMethods:ShouldMouseButtonBePassthrough() return false end

function PinMethods:OnLoad()
	self.Texture = self:CreateTexture(nil, "ARTWORK")
	self.Texture:SetAllPoints()
	self.HighlightTexture = self:CreateTexture(nil, "HIGHLIGHT")
	self.HighlightTexture:SetAllPoints()
	self.HighlightTexture:SetBlendMode("ADD")
	self.HighlightTexture:SetAlpha(0.4)
	self:SetScalingLimits(1, 1.0, 1.2)
	self:UseFrameLevelType("PIN_FRAME_LEVEL_QUEST_OFFER")
end

function PinMethods:OnAcquired(instance, quest, mark, x, y)
	self.instance, self.quest, self.mark = instance, quest, mark
	self:HideMapLegendGlow()
	QuestMap:SetMarkTexture(self.Texture, mark)
	QuestMap:SetMarkTexture(self.HighlightTexture, mark)
	self:SetPosition(x, y)
end

function PinMethods:OnMouseEnter()
	ns.DungeonMap:SetAreaLabel(self, self.quest.name, self.instance.name)
	QuestMap:ShowTooltip(self, self.instance, self.quest, self.mark, { L.QUESTMAP_LEFT_CLICK, L.ENTRANCE_RIGHT_CLICK })
end

function PinMethods:OnMouseLeave()
	ns.DungeonMap:ClearAreaLabel(self)
	GameTooltip:Hide()
end

function PinMethods:OnMouseClickAction(button)
	if button == "RightButton" then
		local point = self.mark.point
		local title = point.label or self.quest.name
		ns.DungeonMap:SetWaypointAt(point.mapID, point.x, point.y, title)
		ns.Print(string.format(L.QUESTMAP_WAYPOINT_SET, self.quest.name))
		return
	end
	QuestMap:Open(self.instance, self.quest)
end

local ProviderMethods = {}

function ProviderMethods:RemoveAllData()
	self:GetMap():RemoveAllPinsByTemplate(QUEST_PIN_TEMPLATE)
end

function ProviderMethods:RefreshAllData()
	self:RemoveAllData()
	local map = self:GetMap()
	local mapID = map:GetMapID()
	if not mapID then return end
	local offered = {}
	if map.EnumeratePinsByTemplate then
		for pin in map:EnumeratePinsByTemplate(CLIENT_OFFER_TEMPLATE) do
			if pin.questID then offered[pin.questID] = true end
		end
	end
	for _, entry in ipairs(QuestMap:MarksOn(mapID)) do
		if not offered[entry.quest.questID] then
			map:AcquirePin(QUEST_PIN_TEMPLATE, entry.instance, entry.quest, entry.mark, entry.x, entry.y)
		end
	end
end

function QuestMap:SetUp()
	if provider then return true end
	if not (WorldMapFrame and WorldMapFrame.AddDataProvider and MapCanvasDataProviderMixin and MapCanvasPinMixin) then
		return false
	end
	Mixin(AegisJournalQuestPinMixin, MapCanvasPinMixin, PinMethods)
	provider = CreateFromMixins(MapCanvasDataProviderMixin, ProviderMethods)
	WorldMapFrame:AddDataProvider(provider)
	return true
end

-- The marks follow the quest log: redrawn once a moment after it changes, if a map is open.
local queued = false
local function Redraw()
	queued = false
	if provider and WorldMapFrame and WorldMapFrame:IsShown() then
		provider:RefreshAllData()
		ns.DungeonMap:Refresh()
	end
end

local events = CreateFrame("Frame")
ns.RegisterEvents(events, "PLAYER_LOGIN", "QUEST_LOG_UPDATE", "QUEST_ACCEPTED", "QUEST_TURNED_IN", "QUEST_REMOVED",
	"PLAYER_LEVEL_UP")
events:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_LOGIN" then
		QuestMap:SetUp()
	elseif not queued then
		queued = true
		C_Timer.After(REFRESH_DELAY, Redraw)
	end
end)
