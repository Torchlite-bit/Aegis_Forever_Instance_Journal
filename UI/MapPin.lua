local _, ns = ...
local L = ns.L

--[[
	"Show Start" and "Show End": the map opened on the right zone, and the client's own waypoint
	set on the spot and tracked, so it shows on the map, the minimap and in the world as a waypoint
	set by hand does (MapPin:Mark).

	Where the client allows no waypoint on that map, one pin of the journal's own on Blizzard's
	world map instead (MapPin:Show), with the place named in its tooltip. That pin sits on the
	map's canvas, so it moves and zooms with the map, and it shows only while that zone is on
	screen.
]]

local MapPin = {}
ns.MapPin = MapPin

local PIN_ATLAS = "Waypoint-MapPin-Tracked"
local PIN_SIZE = 32

local pin, target, hooked

local function Canvas()
	if not WorldMapFrame then return nil end
	if WorldMapFrame.GetCanvas then
		local ok, canvas = pcall(WorldMapFrame.GetCanvas, WorldMapFrame)
		if ok and canvas then return canvas end
	end
	return WorldMapFrame.ScrollContainer and WorldMapFrame.ScrollContainer.Child or nil
end

local function ShownMapID()
	if not (WorldMapFrame and WorldMapFrame.GetMapID) then return nil end
	local ok, mapID = pcall(WorldMapFrame.GetMapID, WorldMapFrame)
	return ok and mapID or nil
end

function MapPin:Update()
	if not pin or not target then return end
	local canvas = pin:GetParent()
	local onMap = ShownMapID() == target.mapID
	pin:SetShown(onMap)
	if onMap then
		pin:ClearAllPoints()
		pin:SetPoint("CENTER", canvas, "TOPLEFT", target.x * canvas:GetWidth(), -target.y * canvas:GetHeight())
	end
end

local function EnsurePin()
	local canvas = Canvas()
	if not canvas then return nil end
	if not pin then
		pin = CreateFrame("Button", nil, canvas)
		pin:SetSize(PIN_SIZE, PIN_SIZE)
		pin.Icon = pin:CreateTexture(nil, "OVERLAY")
		pin.Icon:SetAllPoints()
		pin.Icon:SetAtlas(PIN_ATLAS)
		pin:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(target and target.title or "", 1, 0.82, 0)
			if target and target.label then GameTooltip:AddLine(target.label, 1, 1, 1, true) end
			GameTooltip:AddLine(L.MAP_PIN_CLEAR, 0.5, 0.8, 1)
			GameTooltip:Show()
		end)
		pin:SetScript("OnLeave", function() GameTooltip:Hide() end)
		pin:SetScript("OnClick", function() MapPin:Clear() end)
	end
	pin:SetFrameLevel(canvas:GetFrameLevel() + 2000)

	if not hooked then
		hooked = true
		-- Follow the map as the player browses it.
		if WorldMapFrame.OnMapChanged then
			hooksecurefunc(WorldMapFrame, "OnMapChanged", function() MapPin:Update() end)
		end
		WorldMapFrame:HookScript("OnShow", function() MapPin:Update() end)
	end
	return pin
end

local function OpenMap(mapID)
	local opened = false
	if C_Map and C_Map.OpenWorldMap then opened = pcall(C_Map.OpenWorldMap, mapID) end
	if not opened and type(OpenWorldMap) == "function" then opened = pcall(OpenWorldMap, mapID) end
	return opened
end

-- Whether the client allows its own waypoint on a map.
local function CanWaypoint(mapID)
	if not (C_Map and C_Map.CanSetUserWaypointOnMap and C_Map.SetUserWaypoint and UiMapPoint) then return false end
	local ok, allowed = pcall(C_Map.CanSetUserWaypointOnMap, mapID)
	return ok and allowed == true
end

-- Shows a point { mapID, x, y, label } on the world map with the journal's own pin, titled `title`.
function MapPin:Show(point, title)
	if not point or not point.mapID then return false end
	if InCombatLockdown() then
		ns.Print(L.MAP_PIN_COMBAT)
		return false
	end
	target = { mapID = point.mapID, x = point.x or 0.5, y = point.y or 0.5, label = point.label, title = title }
	if not OpenMap(point.mapID) then return false end
	if EnsurePin() then self:Update() end
	return true
end

-- Opens the map on a point and sets the client's waypoint there, tracked, and says so; the
-- journal's own pin where the map allows no waypoint.
function MapPin:Mark(point, title)
	if not point or not point.mapID then return false end
	if InCombatLockdown() then
		ns.Print(L.MAP_PIN_COMBAT)
		return false
	end
	if not CanWaypoint(point.mapID) then return self:Show(point, title) end
	self:Clear()
	ns.DungeonMap:SetWaypointAt(point.mapID, point.x or 0.5, point.y or 0.5, title)
	OpenMap(point.mapID)
	ns.Print(string.format(L.QUESTMAP_WAYPOINT_SET, title))
	return true
end

function MapPin:Clear()
	target = nil
	if pin then pin:Hide() end
end

function MapPin:Target()
	return target
end
