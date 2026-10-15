local _, ns = ...
local L = ns.L

--[[
	Two things for the world map's zones.

	Level ranges: hovering a zone on a continent map names it at the map's top, and the client's
	label (Blizzard_SharedMapDataProviders/AreaLabelDataProvider.lua) adds its level range only
	when C_Map.GetMapLevels knows it, which Forever's data mostly doesn't. Ours adds the range
	from Data/Authored/ZoneLevels.lua, coloured for the player's level as the client colours it.

	Unexplored areas: a choice in the map's filter menu. The client draws only the pieces of a
	zone the character has explored (MapExplorationDataProvider.lua); this draws the others from
	Data/Generated/MapOverlays.lua, a little darker, so what is still to explore stands out.
]]
local ZoneMap = {}
ns.ZoneMap = ZoneMap

local FOG_PIN_TEMPLATE = "AegisJournalFogPinTemplate"
local UNEXPLORED_SHADE = 0.75
local TILE_SIZE = 256

------------------------------------------------------------------------------------------
-- Level ranges
------------------------------------------------------------------------------------------

-- A zone's level range, and whether the client knows it (its own label then shows it). Our
-- ranges are by uiMapID, or by the zone's name for Forever's zones not yet known by ID.
function ZoneMap:Levels(mapID, name)
	if C_Map.GetMapLevels then
		local ok, low, high = pcall(C_Map.GetMapLevels, mapID)
		if ok and low and high and low > 0 and high > 0 then return low, high, true end
	end
	local range = ns.ZONE_LEVELS[mapID] or (name and ns.ZONE_LEVELS_BY_NAME[name])
	if range then return range[1], range[2], false end
end

-- " (10-20)" in the colour the client gives that range for the player's level: red to grey,
-- yellow while the player is within it.
function ZoneMap:LevelText(low, high)
	local level = UnitLevel("player") or 1
	local color
	if level < low then
		color = GetQuestDifficultyColor(low)
	elseif level > high then
		-- Two below the top, so a zone wholly below the player isn't yellow (as the client does).
		color = GetQuestDifficultyColor(high - 2)
	else
		color = QuestDifficultyColors and QuestDifficultyColors.difficult or GetQuestDifficultyColor(level)
	end
	local range = low == high and tostring(high) or (low .. "-" .. high)
	local function byte(value) return math.floor(value * 255 + 0.5) end
	return string.format("|cff%02x%02x%02x (%s)|r", byte(color.r), byte(color.g), byte(color.b), range)
end

-- Runs after the client's label has named the zone under the cursor for this frame.
local function OnLabelUpdate(label)
	local provider = label.dataProvider
	local map = provider and provider:GetMap()
	local info = label.labelInfoByType and label.labelInfoByType[MAP_AREA_LABEL_TYPE.AREA_NAME]
	if not (map and info and info.name and map:IsCanvasMouseFocus()) then return end
	local mapID = map:GetMapID()
	local x, y = map:GetNormalizedCursorPosition()
	local zone = mapID and x and C_Map.GetMapInfoAtPosition(mapID, x, y)
	-- Only a zone the client named plainly: with its own range, the name already differs.
	if not zone or zone.mapID == mapID or info.name ~= zone.name then return end
	local low, high, clientShows = ZoneMap:Levels(zone.mapID, zone.name)
	if not low or clientShows then return end
	label:SetLabel(MAP_AREA_LABEL_TYPE.AREA_NAME, zone.name .. ZoneMap:LevelText(low, high), info.description,
		info.nameColor, info.descriptionColor, info.textureInfo)
	label:EvaluateLabels()
end

local function HookAreaLabel()
	for provider in pairs(WorldMapFrame.dataProviders or {}) do
		local label = type(provider) == "table" and provider.Label
		if label and label.labelInfoByType and label.SetLabel and label.HookScript then
			label:HookScript("OnUpdate", OnLabelUpdate)
			return true
		end
	end
	return false
end

------------------------------------------------------------------------------------------
-- Unexplored areas
------------------------------------------------------------------------------------------

local provider

function ZoneMap:ShowsUnexplored()
	return ns.db.showUnexplored == true
end

function ZoneMap:SetShowUnexplored(show)
	ns.db.showUnexplored = show and true or nil
	if provider and WorldMapFrame:IsShown() then provider:RefreshAllData() end
end

-- The pieces of a zone the character hasn't explored, by their first texture: the client
-- lists the explored ones.
function ZoneMap:UnexploredPieces(mapID)
	local pieces = ns.MAP_OVERLAYS[mapID]
	if not pieces then return {} end
	local explored = {}
	local list = C_MapExplorationInfo and C_MapExplorationInfo.GetExploredMapTextures(mapID)
	for _, info in ipairs(list or {}) do
		if info.fileDataIDs and info.fileDataIDs[1] then explored[info.fileDataIDs[1]] = true end
	end
	local unexplored = {}
	for _, piece in ipairs(pieces) do
		if not explored[piece[5]] then unexplored[#unexplored + 1] = piece end
	end
	return unexplored
end

-- One pin the size of the map's art, its textures cut as the client cuts explored pieces.
AegisJournalFogPinMixin = {}
local FogPinMethods = { CheckMouseButtonPassthrough = ns.DungeonMap.CheckMouseButtonPassthrough }

function FogPinMethods:OnLoad()
	if self.SetIgnoreGlobalPinScale then self:SetIgnoreGlobalPinScale(true) end
	self:UseFrameLevelType("PIN_FRAME_LEVEL_MAP_EXPLORATION")
	self:EnableMouse(false)
	self.textures = {}
end

function FogPinMethods:OnCanvasSizeChanged()
	local map = self:GetMap()
	if map.DenormalizeHorizontalSize then
		self:SetSize(map:DenormalizeHorizontalSize(1), map:DenormalizeVerticalSize(1))
	end
end

local function TileSize(map, mapID)
	local layers = C_Map.GetMapArtLayers and C_Map.GetMapArtLayers(mapID)
	local container = map.GetCanvasContainer and map:GetCanvasContainer()
	local index = container and container.GetCurrentLayerIndex and container:GetCurrentLayerIndex() or 1
	local layer = layers and layers[index]
	return layer and layer.tileWidth or TILE_SIZE, layer and layer.tileHeight or TILE_SIZE
end

-- The part of a texture file a tile of the given size uses: files are powers of two from 16.
local function FileSize(pixels, tile)
	if pixels == tile then return tile end
	local size = 16
	while size < pixels do size = size * 2 end
	return size
end

function FogPinMethods:OnAcquired(mapID, pieces)
	local map = self:GetMap()
	self:SetPosition(0.5, 0.5)
	self:OnCanvasSizeChanged()
	for _, texture in ipairs(self.textures) do texture:Hide() end
	local tileWidth, tileHeight = TileSize(map, mapID)
	local used = 0
	for _, piece in ipairs(pieces) do
		local width, height, offsetX, offsetY = piece[1], piece[2], piece[3], piece[4]
		local wide, tall = math.ceil(width / tileWidth), math.ceil(height / tileHeight)
		for row = 1, tall do
			local pixelHeight = row < tall and tileHeight or (height - tileHeight * (tall - 1))
			for column = 1, wide do
				local file = piece[4 + (row - 1) * wide + column]
				if file then
					local pixelWidth = column < wide and tileWidth or (width - tileWidth * (wide - 1))
					used = used + 1
					local texture = self.textures[used]
					if not texture then
						texture = self:CreateTexture(nil, "ARTWORK")
						self.textures[used] = texture
					end
					if map.AddMaskableTexture then map:AddMaskableTexture(texture) end
					texture:ClearAllPoints()
					texture:SetSize(pixelWidth, pixelHeight)
					texture:SetPoint("TOPLEFT", offsetX + tileWidth * (column - 1), -(offsetY + tileHeight * (row - 1)))
					texture:SetTexture(file, nil, nil, "TRILINEAR")
					texture:SetTexCoord(0, pixelWidth / FileSize(pixelWidth, tileWidth), 0, pixelHeight / FileSize(pixelHeight, tileHeight))
					texture:SetVertexColor(UNEXPLORED_SHADE, UNEXPLORED_SHADE, UNEXPLORED_SHADE)
					texture:Show()
				end
			end
		end
	end
	self.shownTextures = used
end

local ProviderMethods = {}

function ProviderMethods:OnShow()
	self:RegisterEvent("MAP_EXPLORATION_UPDATED")
end

function ProviderMethods:OnHide()
	self:UnregisterEvent("MAP_EXPLORATION_UPDATED")
end

function ProviderMethods:OnEvent(event)
	if event == "MAP_EXPLORATION_UPDATED" then self:RefreshAllData() end
end

function ProviderMethods:RemoveAllData()
	self:GetMap():RemoveAllPinsByTemplate(FOG_PIN_TEMPLATE)
end

function ProviderMethods:RefreshAllData()
	self:RemoveAllData()
	if not ZoneMap:ShowsUnexplored() then return end
	local mapID = self:GetMap():GetMapID()
	local pieces = mapID and ZoneMap:UnexploredPieces(mapID)
	if pieces and #pieces > 0 then self:GetMap():AcquirePin(FOG_PIN_TEMPLATE, mapID, pieces) end
end

-- The choice, at the end of the map's filter menu (the client's tag for it).
local function AddMenuChoice()
	if not (Menu and Menu.ModifyMenu) then return false end
	Menu.ModifyMenu("MENU_WORLD_MAP_TRACKING", function(_, root)
		root:CreateDivider()
		root:CreateTitle(L.JOURNAL_TITLE)
		root:CreateCheckbox(L.MAP_SHOW_UNEXPLORED,
			function() return ZoneMap:ShowsUnexplored() end,
			function() ZoneMap:SetShowUnexplored(not ZoneMap:ShowsUnexplored()) end)
	end)
	return true
end

function ZoneMap:SetUp()
	if provider then return true end
	if not (WorldMapFrame and WorldMapFrame.AddDataProvider and MapCanvasDataProviderMixin and MapCanvasPinMixin) then
		return false
	end
	Mixin(AegisJournalFogPinMixin, MapCanvasPinMixin, FogPinMethods)
	provider = CreateFromMixins(MapCanvasDataProviderMixin, ProviderMethods)
	WorldMapFrame:AddDataProvider(provider)
	HookAreaLabel()
	AddMenuChoice()
	return true
end

local events = CreateFrame("Frame")
ns.RegisterEvents(events, "PLAYER_LOGIN")
events:SetScript("OnEvent", function(self)
	ZoneMap:SetUp()
	ns.UnregisterEvents(self, "PLAYER_LOGIN")
end)
