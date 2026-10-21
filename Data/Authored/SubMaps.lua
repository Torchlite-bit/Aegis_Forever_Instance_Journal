local _, ns = ...

--[[
	Old Ironforge, the level beneath Ironforge where the Hall of Thanes has its portal. It is
	not instanced, and the client has no map of it: it reports a player down there on the
	Ironforge map itself. So the Ironforge map shows a cave entrance where the way down is,
	and the dungeon's own icon above its portal; and when the player is below, the world
	map shows our picture of Old Ironforge instead, with the portal and the player on it.

	way          the cave entrance on the Ironforge map
	calibration  two spots, each as read in game with /aegis where (map) and on the
	             picture (picture): the arrival at the bottom of the way down, and the portal
	areas        what the client calls the area down there; the streets above all have names
	             of their own (The Commons, The Great Forge, ...), so a nameless spot inside
	             the picture's rectangle is below
	sharedAreas  names that spots both above and below have (the arrival reads "The High
	             Seat", like the throne room above): a player seen below stays below in these
	             until they walk into a street the area below does not reach
	instances    where each dungeon's portal is on the picture
]]

ns.AddSubMap({
	key = "OldIronforge",
	name = "Old Ironforge",
	parentMapID = 1455,
	art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\OldIronforge",
	artRight = 1002 / 1024,
	artBottom = 668 / 1024,
	way = { x = 0.435, y = 0.52 },
	calibration = {
		{ map = { 0.4599, 0.5935 }, picture = { 0.765, 0.88 } },
		{ map = { 0.2815, 0.4775 }, picture = { 0.21, 0.52 } },
	},
	areas = { [""] = true, ["Ironforge"] = true },
	sharedAreas = { ["The High Seat"] = true },
	instances = { HallOfThanes = { x = 0.21, y = 0.52 } },
})

-- The Hall of Thanes's icon on the Ironforge map stands over its portal, and says the way
-- in is through Old Ironforge.
if ns.GetInstance("HallOfThanes") then
	ns.AmendInstance("HallOfThanes", {
		zoneEntrance = { mapID = 1455, x = 0.2815, y = 0.4775 },
		via = "OldIronforge",
	})
end

--[[
	The Defias Hideout, the mine beneath Moonbrook that leads to the Deadmines. The client has
	no map of it, nor of the Moonbrook house the way down starts in: it reports a player there
	on the Eastern Kingdoms map itself (1415), while the streets above are on Westfall's (1436).
	So the way down is the house's door, read on Westfall, and the calibration readings are on
	the continent: E at the way in from the house, A at the portal (the picture,
	Media/Maps/DeadminesApproach, is the user's, Blizzard's map art).
]]
ns.AddSubMap({
	key = "DeadminesApproach",
	name = "Defias Hideout",
	parentMapID = 1415,
	art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\DeadminesApproach",
	artRight = 1000 / 1024,
	artBottom = 667 / 1024,
	way = { mapID = 1436, x = 0.4254, y = 0.7176 },
	calibration = {
		{ map = { 0.4069, 0.7958 }, picture = { 0.248, 0.5097 } },
		{ map = { 0.4120, 0.7911 }, picture = { 0.6905, 0.1912 } },
	},
	areas = { ["Defias Hideout"] = true, ["The Deadmines"] = true },
	instances = { TheDeadmines = { x = 0.248, y = 0.5097 } },
})

if ns.GetInstance("TheDeadmines") then
	ns.AmendInstance("TheDeadmines", {
		zoneEntrance = { mapID = 1415, x = 0.4069, y = 0.7958 },
		via = "DeadminesApproach",
	})
end

--[[
	The Deeprun Tram's station room (the picture, Media/Maps/DeeprunTram, is the user's,
	Blizzard's map art). The client gives no map and no position anywhere in the tram:
	/aegis where reads map nil at both its Stormwind and its Ironforge end. So the picture is
	known by the zone's name instead, and shows without the player's arrow; and since the two
	stations are alike and cannot be told apart, it serves both.

	zones      the zone names that mean the player is inside
	enteredBy  the kind of transport whose icons on the city maps lead into it: a left click
	           on any tram icon shows this map
]]
ns.AddSubMap({
	key = "DeeprunTram",
	name = "Deeprun Tram",
	art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\DeeprunTram",
	artRight = 1000 / 1024,
	artBottom = 667 / 1024,
	zones = { ["Deeprun Tram"] = true },
	enteredBy = "tram",
})

--[[
	The Wailing Caverns' cave, below the Barrens, on Blizzard's own drawn map of it: the client's
	tiles (retail's microdungeon map 11, the same files and the same cave in Forever's client), so
	nothing is shipped. Where the picture lies was worked out from the game's data: its corners are
	retail's map region for it, read on the continent and on the Barrens. The cave's area is not
	under the Barrens, so the client is expected to report a player in it on Kalimdor (1414), as it
	reports the Defias Hideout on the Eastern Kingdoms; it is set up on the Barrens (1413) too, in
	case it says that instead. Its rooms read "The Wailing Caverns", the pool's "Cavern of Mists".
	The way in is the cave's mouth in the ravine; the portal, the picture's swirl.
]]
local WAILING_TILES = "Interface\\WorldMap\\MicroDungeon\\Barrens\\WailingCavernsBarrens\\WailingCavernsBarrens20_"
local WAILING_AREAS = { ["The Wailing Caverns"] = true, ["Cavern of Mists"] = true, ["Wailing Caverns"] = true }
local WAILING_PORTAL = { WailingCaverns = { x = 0.548, y = 0.669 } }

ns.AddSubMap({
	key = "WailingCavernsApproach",
	name = "Wailing Caverns",
	parentMapID = 1414,
	tiles = WAILING_TILES,
	way = { mapID = 1413, x = 0.4597, y = 0.3625 },
	calibration = {
		{ map = { 0.515467, 0.541711 }, picture = { 0, 0 } },
		{ map = { 0.530957, 0.557200 }, picture = { 1, 1 } },
	},
	areas = WAILING_AREAS,
	instances = WAILING_PORTAL,
})

-- The same cave, should the client report it on the Barrens; its way in is the one above.
ns.AddSubMap({
	key = "WailingCavernsApproachBarrens",
	name = "Wailing Caverns",
	parentMapID = 1413,
	tiles = WAILING_TILES,
	calibration = {
		{ map = { 0.446587, 0.311193 }, picture = { 0, 0 } },
		{ map = { 0.502837, 0.367438 }, picture = { 1, 1 } },
	},
	areas = WAILING_AREAS,
	instances = WAILING_PORTAL,
})

if ns.GetInstance("WailingCaverns") then
	ns.AmendInstance("WailingCaverns", {
		zoneEntrance = { mapID = 1414, x = 0.5239, y = 0.5525 },
		via = "WailingCavernsApproach",
	})
end
