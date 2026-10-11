local _, ns = ...
local L = ns.L

--[[
	One pin on Blizzard's world map, for "Show Start" and "Show End".

	Opens the map on the right zone and marks the spot with the client's own waypoint pin,
	with the place named in its tooltip. The pin sits on the map's canvas, so it moves and
	zooms with the map, and it shows only while that zone is on screen.
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

-- Shows a point { mapID, x, y, label } on the world map, titled `title`.
function MapPin:Show(point, title)
	if not point or not point.mapID then return false end
	if InCombatLockdown() then
		ns.Print(L.MAP_PIN_COMBAT)
		return false
	end
	target = { mapID = point.mapID, x = point.x or 0.5, y = point.y or 0.5, label = point.label, title = title }

	local opened = false
	if C_Map and C_Map.OpenWorldMap then opened = pcall(C_Map.OpenWorldMap, point.mapID) end
	if not opened and type(OpenWorldMap) == "function" then opened = pcall(OpenWorldMap, point.mapID) end
	if not opened then return false end

	if EnsurePin() then self:Update() end
	return true
end

function MapPin:Clear()
	target = nil
	if pin then pin:Hide() end
end

function MapPin:Target()
	return target
end
