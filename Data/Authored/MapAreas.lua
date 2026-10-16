local _, ns = ...

--[[
	Where each named area of a Forever dungeon lies on its map, for the world map's "You are
	here": the client hides the player's position inside these dungeons but still names the
	area they stand in (GetSubZoneText). Keys are those names; x, y and radius are fractions of
	the map picture, read off the area labels printed on Media/Maps.

	Names marked "seen" were reported by the client in game; the rest follow the map's labels
	and light up only if the client uses the same name.
]]

local function Areas(key, areas)
	if ns.GetInstance(key) then ns.AmendInstance(key, { mapAreas = areas }) end
end

Areas("HallOfThanes", {
	["Anvilmar's Rest"] = { x = 0.508, y = 0.665, radius = 0.09 },     -- seen
	["Dark Iron Ingress"] = { x = 0.725, y = 0.455, radius = 0.08 },   -- seen
	["Reliquary of Kings"] = { x = 0.508, y = 0.170, radius = 0.06 },
})

Areas("RuinsOfLordaeron", {
	["Market Street"] = { x = 0.330, y = 0.430, radius = 0.08 },
	["King's Alley"] = { x = 0.665, y = 0.380, radius = 0.08 },
	["Lordamere Overlook"] = { x = 0.525, y = 0.620, radius = 0.07 },
	["Lordaeron Graveyard"] = { x = 0.385, y = 0.700, radius = 0.06 },
})

-- Santiago Reyes's newer map labels its areas; the boss spots are in Data/Authored/ExcavationSiteWetlands.lua.
Areas("ExcavationSiteWetlands", {
	["Lost Marsh"] = { x = 0.580, y = 0.390, radius = 0.12 },   -- seen
	["Stalker's Thicket"] = { x = 0.335, y = 0.420, radius = 0.08 },   -- seen
	["Lost Dig Site"] = { x = 0.110, y = 0.450, radius = 0.08 },   -- seen
	["Site of the Guardian"] = { x = 0.370, y = 0.700, radius = 0.08 },   -- seen
})
