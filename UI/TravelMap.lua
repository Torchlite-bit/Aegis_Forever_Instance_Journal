local _, ns = ...
local L = ns.L

--[[
	Ways to travel on the world map, as retail shows them.

	Flight points, on zone maps: Forever knows every flight master's place
	(C_TaxiMap.GetTaxiNodesForMap) but its maps do not show them (C_TaxiMap.ShouldMapShowTaxiNodes
	says no), so the journal draws them itself, with the map legend's Flightpoint icon. Only the
	player's faction's and neutral ones show, as on retail.

	Transports (boats, zeppelins, the tram, portals), on zone and continent maps: the client has
	no list of them, and Forever moved several (Stormwind's harbor), so the player saves each
	spot where it stands with /aegis travel; they show at once, with retail's teleport icon in
	the faction's colour: blue for the Alliance, red for the Horde, gold for everyone.

	A click on either sets a waypoint.
]]

local TravelMap = {}
ns.TravelMap = TravelMap

local FLIGHT_PIN_TEMPLATE = "AegisJournalFlightPinTemplate"
local TRANSPORT_PIN_TEMPLATE = "AegisJournalTransportPinTemplate"
local FLIGHT_ATLAS = "FlightPath"
-- The size retail's legend gives the flight icon (MapLegendFrameData's FlightMaster).
local FLIGHT_SIZE = 24
local TRANSPORT_SIZE = 24
local TRANSPORT_ATLASES = {
	Alliance = "TaxiNode_Continent_Alliance",
	Horde = "TaxiNode_Continent_Horde",
	Neutral = "TaxiNode_Continent_Neutral",
}
local MAP_TYPE_CONTINENT = Enum and Enum.UIMapType and Enum.UIMapType.Continent or 2
local MAP_TYPE_ZONE = Enum and Enum.UIMapType and Enum.UIMapType.Zone or 3
local FLIGHT_FACTION = Enum and Enum.FlightPathFaction or { Neutral = 0, Horde = 1, Alliance = 2 }

-- What /aegis travel takes: the kind of transport, and the faction it serves.
local KINDS = {
	boat = "boat", ship = "boat", zeppelin = "zeppelin", zep = "zeppelin", airship = "airship",
	tram = "tram", portal = "portal",
}
local FACTIONS = { alliance = "Alliance", horde = "Horde", neutral = "Neutral" }
-- Spots saved this close together on the same map, for the same kind, are one dock.
local SAME_SPOT = 0.01
-- A route's note ("Skyborne only") under it in the tooltip: the orange retail uses for requirements.
local NOTE_COLOR = { 1, 0.5, 0.25 }

------------------------------------------------------------------------------------------
-- Flight points
------------------------------------------------------------------------------------------

-- Which faction a flight master serves; from its icon where the client leaves the field out.
local function NodeFaction(node)
	if node.faction ~= nil then return node.faction end
	local atlas = node.atlasName or ""
	if atlas:find("Alliance", 1, true) then return FLIGHT_FACTION.Alliance end
	if atlas:find("Horde", 1, true) then return FLIGHT_FACTION.Horde end
	return FLIGHT_FACTION.Neutral
end

-- The flight points on a map, worked out once: the client's list holds every flight master of
-- the continent, placed on the map asked for, so only those on it are kept.
local nodesByMap = {}
local function Nodes(mapID)
	local nodes = nodesByMap[mapID]
	if nodes then return nodes end
	nodes = {}
	if not (C_TaxiMap and C_TaxiMap.GetTaxiNodesForMap) then return nodes end
	local ok, list = pcall(C_TaxiMap.GetTaxiNodesForMap, mapID)
	for _, node in ipairs(ok and type(list) == "table" and list or {}) do
		local x, y
		if node.position then x, y = node.position:GetXY() end
		if x and x >= 0 and x <= 1 and y >= 0 and y <= 1 and node.name then
			nodes[#nodes + 1] = { name = node.name, x = x, y = y, faction = NodeFaction(node) }
		end
	end
	nodesByMap[mapID] = nodes
	return nodes
end

local function ServesPlayer(node, playerFaction)
	if node.faction == FLIGHT_FACTION.Horde then return playerFaction == "Horde" end
	if node.faction == FLIGHT_FACTION.Alliance then return playerFaction == "Alliance" end
	return true
end

-- Where the client draws its own flight points, the journal leaves them to it.
local function ClientShows(mapID)
	if not (C_TaxiMap and C_TaxiMap.ShouldMapShowTaxiNodes) then return false end
	local ok, shows = pcall(C_TaxiMap.ShouldMapShowTaxiNodes, mapID)
	return ok and ns.Readable(shows) == true
end

------------------------------------------------------------------------------------------
-- Transports the player saved
------------------------------------------------------------------------------------------

local function Transports()
	ns.db.travel = ns.db.travel or {}
	return ns.db.travel
end

local function KindName(kind)
	return L.TRAVEL_KINDS[kind] or kind
end

-- "Boat to Auberdine", or "Boat" where nothing says where it goes.
local function RouteText(kind, destination)
	if destination then return string.format(L.TRAVEL_ROUTE, KindName(kind), destination) end
	return KindName(kind)
end

-- Who may take a route ("Skyborne only"), where the player noted it.
local function RouteNote(spot, destination)
	return spot.notes and spot.notes[destination or ""] or nil
end

local function SpotName(spot)
	if spot.area and spot.area ~= "" then return spot.area end
	local info = ns.DungeonMap:MapInfo(spot.mapID)
	return info and info.name or KindName(spot.kind)
end

local function Contains(list, value)
	for _, item in ipairs(list) do
		if item == value then return true end
	end
	return false
end

local function SameSpot(spot, kind, mapID, x, y)
	return spot.kind == kind and spot.mapID == mapID and math.abs(spot.x - x) < SAME_SPOT
		and math.abs(spot.y - y) < SAME_SPOT
end

-- A dock already saved where the player stands, for this kind of transport.
local function SpotHere(kind, mapID, x, y)
	for _, spot in ipairs(Transports()) do
		if SameSpot(spot, kind, mapID, x, y) then return spot end
	end
	return nil
end

-- What the map shows: the journal's own transports (Data/Authored/Transports.lua) and the
-- player's saved ones, a saved route from one of the journal's docks joining that dock; then
-- the ones nobody has stood on yet (Data/Travel/KnownTransports.lua, unvisited = true), each unless
-- one of those stood-on spots of its kind is near it. Worked out again only after a save or an undo.
local shown, shownFrom, savesChanged = nil, nil, true
local NEAR = 0.03

local function Near(spot, other)
	return spot.kind == other.kind and spot.mapID == other.mapID and math.abs(spot.x - other.x) < NEAR
		and math.abs(spot.y - other.y) < NEAR
end

-- The journal's name for a route a saved spot names in English or in the client's language, where
-- the journal shows another (Core/Registry.lua keeps both).
local function JournalName(base, destination)
	for _, names in ipairs({ base.enTo or {}, base.clientTo or {} }) do
		for index, name in ipairs(names) do
			if name == destination and base.to[index] then return base.to[index] end
		end
	end
	return destination
end

local function Joined(base, saved)
	local spot = { to = {}, notes = {} }
	for key, value in pairs(base) do
		if key ~= "to" and key ~= "notes" then spot[key] = value end
	end
	for _, from in ipairs({ base, saved }) do
		for _, destination in ipairs(from.to) do
			if from == saved then destination = JournalName(base, destination) end
			if not Contains(spot.to, destination) then spot.to[#spot.to + 1] = destination end
		end
		for destination, note in pairs(from.notes or {}) do
			spot.notes[from == saved and JournalName(base, destination) or destination] = note
		end
	end
	return spot
end

-- A saved spot without the routes Forever took out (Data/Authored/Transports.lua), or nil when it
-- has no route left. The saved spot itself is left as it was.
local function StillRuns(spot)
	local to = {}
	for _, destination in ipairs(spot.to or {}) do
		local gone = false
		for _, route in ipairs(ns.GetGoneTransports()) do
			if SameSpot(spot, route.kind, route.mapID, route.x, route.y) and Contains(route.to, destination) then gone = true end
		end
		if not gone then to[#to + 1] = destination end
	end
	if #to == #(spot.to or {}) then return spot end
	if #to == 0 then return nil end
	local copy = {}
	for key, value in pairs(spot) do copy[key] = value end
	copy.to = to
	return copy
end

local function ShownTransports()
	local saved = Transports()
	if shown and not savesChanged and shownFrom == saved then return shown end
	shown, shownFrom, savesChanged = {}, saved, false
	local unvisited = {}
	for _, spot in ipairs(ns.GetTransports()) do
		if spot.unvisited then unvisited[#unvisited + 1] = spot else shown[#shown + 1] = spot end
	end
	local authored = #shown
	local running = {}
	for _, spot in ipairs(saved) do
		local still = StillRuns(spot)
		if still then running[#running + 1] = still end
	end
	for _, spot in ipairs(running) do
		local joined = false
		for index = 1, authored do
			if SameSpot(shown[index], spot.kind, spot.mapID, spot.x, spot.y) then
				shown[index] = Joined(shown[index], spot)
				joined = true
				break
			end
		end
		if not joined then shown[#shown + 1] = spot end
	end
	local stoodOn = #shown
	for _, spot in ipairs(unvisited) do
		local covered = false
		for index = 1, stoodOn do
			if Near(spot, shown[index]) then
				covered = true
				break
			end
		end
		if not covered then shown[#shown + 1] = spot end
	end
	return shown
end

local provider
local lastCapture -- what /aegis travel undo takes back, for this session

local function RefreshMap()
	savesChanged = true
	if provider and WorldMapFrame:IsShown() then provider:RefreshAllData() end
end

local function Undo()
	if not lastCapture then
		ns.Print(L.TRAVEL_NOTHING)
		return
	end
	local spot, destination = lastCapture.spot, lastCapture.destination
	local list = Transports()
	if lastCapture.created then
		for index = #list, 1, -1 do
			if list[index] == spot then table.remove(list, index) end
		end
	elseif destination then
		for index = #spot.to, 1, -1 do
			if spot.to[index] == destination then table.remove(spot.to, index) end
		end
		if spot.notes then spot.notes[destination] = nil end
	end
	ns.Print(string.format(L.TRAVEL_UNDONE, RouteText(spot.kind, destination), SpotName(spot)))
	lastCapture = nil
	RefreshMap()
end

local function List()
	local list = Transports()
	if #list == 0 then
		ns.Print(L.TRAVEL_LIST_EMPTY)
		return
	end
	for index, spot in ipairs(list) do
		local routes = {}
		for _, destination in ipairs(spot.to) do
			local note = RouteNote(spot, destination)
			routes[#routes + 1] = RouteText(spot.kind, destination) .. (note and " (" .. note .. ")" or "")
		end
		if #routes == 0 then routes[1] = KindName(spot.kind) end
		ns.Print(string.format(L.TRAVEL_LIST_LINE, index, table.concat(routes, ", "), SpotName(spot), spot.mapID, spot.x, spot.y))
	end
end

-- The words after the kind: where it goes, then, in either order at the end, a faction word
-- and a note in parentheses for who may use it ("(Skyborne only)").
local function ParseRoute(rest)
	local faction, note
	for _ = 1, 2 do
		local head, last = rest:match("^(.-)%s*(%S+)$")
		if not faction and last and FACTIONS[last:lower()] then
			faction, rest = FACTIONS[last:lower()], head
		else
			local before, inside = rest:match("^(.-)%s*%(([^()]*)%)$")
			if not note and inside then
				note, rest = strtrim(inside), before
			end
		end
	end
	return rest ~= "" and rest or nil, faction, note ~= "" and note or nil
end

--[[
	/aegis travel <boat|zeppelin|airship|tram|portal> [where it goes] [(note)] [alliance|horde|neutral]
	Saves the spot the player stands on. Saving the same dock again with another destination
	adds the route to it. Without a faction, zeppelins are the Horde's and the rest the
	player's own faction's. A note in parentheses shows under its route in the tooltip, for
	routes only some may take.
]]
function TravelMap:Capture(text)
	local word, rest = (text or ""):match("^(%S*)%s*(.-)%s*$")
	word = word:lower()
	if word == "undo" then return Undo() end
	if word == "list" then return List() end
	local kind = KINDS[word]
	if not kind then
		ns.Print(L.TRAVEL_HELP)
		return
	end
	local mapID, x, y = ns.PlayerMapPosition()
	if not x then
		ns.Print(L.TRAVEL_NO_POSITION)
		return
	end
	local destination, faction, note = ParseRoute(rest)

	local spot, created = SpotHere(kind, mapID, x, y), false
	if not spot then
		local ok, area = pcall(GetSubZoneText)
		local player = UnitFactionGroup("player")
		spot = { kind = kind, mapID = mapID, x = x, y = y, area = ok and ns.Readable(area) or "", to = {},
			faction = kind == "zeppelin" and "Horde" or (player == "Horde" and "Horde" or "Alliance"),
			at = date("%Y-%m-%d %H:%M:%S") }
		table.insert(Transports(), spot)
		created = true
	end
	if faction then spot.faction = faction end
	local added = destination and not Contains(spot.to, destination)
	if added then table.insert(spot.to, destination) end
	if note then
		-- Kept by route, or for the spot itself when it was saved without a destination.
		spot.notes = spot.notes or {}
		spot.notes[destination or ""] = note
	end
	lastCapture = { spot = spot, destination = added and destination or nil, created = created }
	ns.Print(string.format(L.TRAVEL_SAVED, RouteText(kind, destination) .. (note and " (" .. note .. ")" or ""), SpotName(spot)))
	RefreshMap()
end

------------------------------------------------------------------------------------------
-- Pins
------------------------------------------------------------------------------------------

local SharedPinMethods = {
	ShowMapLegendGlow = ns.DungeonMap.ShowMapLegendGlow,
	HideMapLegendGlow = ns.DungeonMap.HideMapLegendGlow,
	-- Safe to hand out in combat (UI/DungeonMap.lua).
	CheckMouseButtonPassthrough = ns.DungeonMap.CheckMouseButtonPassthrough,
}

local function PinTextures(pin, atlas, size)
	pin:SetSize(size, size)
	pin.Texture = pin:CreateTexture(nil, "ARTWORK")
	pin.Texture:SetAllPoints()
	pin.HighlightTexture = pin:CreateTexture(nil, "HIGHLIGHT")
	pin.HighlightTexture:SetAllPoints()
	pin.HighlightTexture:SetBlendMode("ADD")
	pin.HighlightTexture:SetAlpha(0.4)
	if atlas then
		pin.Texture:SetAtlas(atlas)
		pin.HighlightTexture:SetAtlas(atlas)
	end
	pin:SetScalingLimits(1, 1.0, 1.2)
end

-- Both buttons belong to the pin, as on the journal's other pins: a right click sets the
-- waypoint instead of zooming the map out.
function SharedPinMethods:ShouldMouseButtonBePassthrough() return false end

-- The tooltip's last lines say what a click does: by default, any click sets a waypoint.
local function ShowTooltip(pin, title, label, lines, legendKind, clickLines)
	ns.DungeonMap:SetAreaLabel(pin, title, label)
	GameTooltip:SetOwner(pin, "ANCHOR_RIGHT")
	GameTooltip:SetText(title, 1, 1, 1)
	for _, line in ipairs(lines) do GameTooltip:AddLine(line[1], line[2], line[3], line[4]) end
	for _, line in ipairs(clickLines or { L.CLICK_FOR_WAYPOINT }) do GameTooltip:AddLine(line, 0.1, 1, 0.1) end
	GameTooltip:Show()
	ns.MapLegend:PinEnter(legendKind)
end

local function HideTooltip(pin, legendKind)
	ns.DungeonMap:ClearAreaLabel(pin)
	GameTooltip:Hide()
	ns.MapLegend:PinLeave(legendKind)
end

local function WithSharedMethods()
	local methods = {}
	for key, method in pairs(SharedPinMethods) do methods[key] = method end
	return methods
end

AegisJournalFlightPinMixin = {}
local FlightPinMethods = WithSharedMethods()

function FlightPinMethods:OnLoad()
	PinTextures(self, FLIGHT_ATLAS, FLIGHT_SIZE)
	self:UseFrameLevelType("PIN_FRAME_LEVEL_FLIGHT_POINT")
end

function FlightPinMethods:OnAcquired(node)
	self.node = node
	self:HideMapLegendGlow()
	self:SetPosition(node.x, node.y)
end

function FlightPinMethods:OnMouseEnter()
	ShowTooltip(self, self.node.name, L.FLIGHT_POINT, { { L.FLIGHT_POINT, 1, 0.82, 0 } }, "flight")
end

function FlightPinMethods:OnMouseLeave() HideTooltip(self, "flight") end

function FlightPinMethods:OnMouseClickAction()
	local node = self.node
	ns.DungeonMap:SetWaypointAt(self:GetMap():GetMapID(), node.x, node.y, node.name)
	ns.Print(string.format(L.FLIGHT_WAYPOINT_SET, node.name))
end

AegisJournalTransportPinMixin = {}
local TransportPinMethods = WithSharedMethods()

-- The map of the place a transport leads into, where the journal has one: the area entered by
-- that kind of transport (enteredBy; the Deeprun Tram's, by every tram).
local function InsideMap(spot)
	for _, subMap in ipairs(ns.GetSubMaps()) do
		if subMap.enteredBy == spot.kind then return subMap end
	end
	return nil
end

function TransportPinMethods:OnLoad()
	PinTextures(self, nil, TRANSPORT_SIZE)
	self:UseFrameLevelType("PIN_FRAME_LEVEL_AREA_POI")
end

function TransportPinMethods:OnAcquired(spot, x, y)
	self.spot = spot
	self:HideMapLegendGlow()
	local atlas = TRANSPORT_ATLASES[spot.faction] or TRANSPORT_ATLASES.Neutral
	self.Texture:SetAtlas(atlas)
	self.HighlightTexture:SetAtlas(atlas)
	self:SetPosition(x, y)
end

-- "Auberdine", "Auberdine and Southshore", "Auberdine, Southshore and Theramore Isle".
local function JoinNames(names)
	if #names <= 1 then return names[1] end
	return string.format(L.TRAVEL_AND, table.concat(names, ", ", 1, #names - 1), names[#names])
end

-- What a transport is called on the map: where it goes ("Portal to Dalaran"), as retail names
-- its own; the place it leaves from is the smaller line.
local function SpotTitle(spot)
	if #spot.to == 0 then return KindName(spot.kind) end
	return RouteText(spot.kind, JoinNames(spot.to))
end

function TransportPinMethods:OnMouseEnter()
	local spot = self.spot
	local place = SpotName(spot)
	local lines = { { place, 0.8, 0.8, 0.8 } }
	-- Who may take a route: under the place for a single route, named for each of several.
	for _, destination in ipairs(#spot.to > 0 and spot.to or { "" }) do
		local note = RouteNote(spot, destination ~= "" and destination or nil)
		if note then
			local text = #spot.to > 1 and string.format(L.TRAVEL_ROUTE_NOTE, destination, note) or note
			lines[#lines + 1] = { "  " .. text, NOTE_COLOR[1], NOTE_COLOR[2], NOTE_COLOR[3] }
		end
	end
	local color = spot.faction == "Alliance" and { 0.4, 0.6, 1 } or spot.faction == "Horde" and { 1, 0.3, 0.3 } or nil
	if color then lines[#lines + 1] = { L.TRAVEL_FACTIONS[spot.faction], color[1], color[2], color[3] } end
	local inside = InsideMap(spot)
	local clickLines = inside and { string.format(L.CAVE_LEFT_CLICK, inside.name), L.ENTRANCE_RIGHT_CLICK }
	ShowTooltip(self, SpotTitle(spot), place, lines, "transport", clickLines)
end

function TransportPinMethods:OnMouseLeave() HideTooltip(self, "transport") end

-- A left click on a transport with a map of its own inside (the Deeprun Tram's) shows that map;
-- other clicks set a waypoint to it.
function TransportPinMethods:OnMouseClickAction(button)
	local spot = self.spot
	local inside = InsideMap(spot)
	if inside and button ~= "RightButton" then
		ns.DungeonMap:ShowSubMap(inside)
		return
	end
	ns.DungeonMap:SetWaypointAt(spot.mapID, spot.x, spot.y, SpotName(spot))
	ns.Print(string.format(L.TRAVEL_WAYPOINT_SET, SpotName(spot)))
end

------------------------------------------------------------------------------------------
-- The data provider
------------------------------------------------------------------------------------------

local ProviderMethods = {}

function ProviderMethods:RemoveAllData()
	self:GetMap():RemoveAllPinsByTemplate(FLIGHT_PIN_TEMPLATE)
	self:GetMap():RemoveAllPinsByTemplate(TRANSPORT_PIN_TEMPLATE)
end

function ProviderMethods:RefreshAllData()
	self:RemoveAllData()
	local map = self:GetMap()
	local mapID = map:GetMapID()
	local info = mapID and ns.DungeonMap:MapInfo(mapID)
	if not info or (info.mapType ~= MAP_TYPE_ZONE and info.mapType ~= MAP_TYPE_CONTINENT) then return end
	if info.mapType == MAP_TYPE_ZONE and not ClientShows(mapID) and ns.MapLegend.Shows("flight") then
		local playerFaction = UnitFactionGroup("player")
		for _, node in ipairs(Nodes(mapID)) do
			if ServesPlayer(node, playerFaction) then map:AcquirePin(FLIGHT_PIN_TEMPLATE, node) end
		end
	end
	for _, spot in ipairs(ns.MapLegend.Shows("transport") and ShownTransports() or {}) do
		local x, y = ns.DungeonMap:PositionOn(spot, mapID)
		if x then map:AcquirePin(TRANSPORT_PIN_TEMPLATE, spot, x, y) end
	end
end

-- Drawn again (a legend switch).
function TravelMap:Refresh()
	if provider and WorldMapFrame:IsShown() then provider:RefreshAllData() end
end

function TravelMap:SetUp()
	if provider then return true end
	if not (WorldMapFrame and WorldMapFrame.AddDataProvider and MapCanvasDataProviderMixin and MapCanvasPinMixin) then
		return false
	end
	Mixin(AegisJournalFlightPinMixin, MapCanvasPinMixin, FlightPinMethods)
	Mixin(AegisJournalTransportPinMixin, MapCanvasPinMixin, TransportPinMethods)
	provider = CreateFromMixins(MapCanvasDataProviderMixin, ProviderMethods)
	WorldMapFrame:AddDataProvider(provider)
	return true
end

local events = CreateFrame("Frame")
ns.RegisterEvents(events, "PLAYER_LOGIN")
events:SetScript("OnEvent", function(self)
	TravelMap:SetUp()
	ns.UnregisterEvents(self, "PLAYER_LOGIN")
end)
