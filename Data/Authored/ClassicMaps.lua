local addonName, ns = ...

--[[
	The classic dungeons' maps, from foreverchanges.pro (2026-10-09): its picture of each floor
	(the client's own map, 1002 x 668, with the painted boss skulls taken off), the floors it
	shows and their names, and where it places each boss.

	Each picture keeps the client's map frame in the top-left of a 1024 square, unscaled, so the
	player's position on the client's map (uiMapID) and the site's spots fit it as they are. One
	file per floor, in Media/Maps/Dungeons, named as the site names them.

	floors   each floor the site shows, in its order: the client's map, the picture, the name
	spots    { boss, floor, x, y }: a boss with several is not always in the same place, and gets
	         a pin on each. Bosses the site does not place keep the spot they had (listed in
	         kept below), on the floor of the same client map.
	The ways between floors are the journal's own (Data/Instances), moved to the new floors by their
	client maps.
]]

local FOLDER = "Interface\\AddOns\\" .. addonName .. "\\Media\\Maps\\Dungeons\\"
local ART_RIGHT, ART_BOTTOM = 1002 / 1024, 668 / 1024

local function UseMaps(key, spec)
	local instance = ns.GetInstance(key)
	if not (instance and instance.map) then return end
	local map = instance.map

	-- The new floors; a floor the journal had keeps its table (tiles and all).
	local old, oldMapOf, newIndexOf = map.floors or {}, {}, {}
	for index, floor in ipairs(old) do oldMapOf[index] = floor.uiMapID end
	local floors, names = {}, {}
	for index, entry in ipairs(spec.floors) do
		local floor
		for _, candidate in ipairs(old) do
			if candidate.uiMapID == entry[1] then floor = candidate end
		end
		floor = floor or { uiMapID = entry[1] }
		floor.art, floor.artRight, floor.artBottom = FOLDER .. entry[2], ART_RIGHT, ART_BOTTOM
		floors[index], names[index] = floor, entry[3]
		newIndexOf[entry[1]] = index
	end
	local function Moved(point)
		if not point then return nil end
		local index = newIndexOf[oldMapOf[point.floor or 1]]
		if not index then return nil end
		point.floor = index
		return point
	end
	map.floors = floors
	instance.floorNames = #floors > 1 and names or nil

	-- Spots kept where the site places nobody, moved to the new floors; dropped if their floor is gone.
	local byName = {}
	for _, boss in ipairs(instance.bosses) do
		byName[boss.name] = boss
		boss.mapPin = Moved(boss.mapPin)
		boss.mapPins = nil
	end
	map.entrance = Moved(map.entrance)
	local transitions = {}
	for _, link in ipairs(map.transitions or {}) do
		local from, to = newIndexOf[oldMapOf[link.floor]], newIndexOf[oldMapOf[link.to]]
		if from and to then transitions[#transitions + 1] = { floor = from, to = to, x = link.x, y = link.y } end
	end
	map.transitions = #transitions > 0 and transitions or nil

	-- The site's spots.
	local spots = {}
	for _, spot in ipairs(spec.spots) do
		local name, floor, x, y = spot[1], spot[2], spot[3], spot[4]
		assert(byName[name], "ClassicMaps: " .. key .. " has no boss named " .. name)
		spots[name] = spots[name] or {}
		table.insert(spots[name], { x = x, y = y, floor = floor })
	end
	for name, list in pairs(spots) do
		local boss = byName[name]
		boss.mapPin = list[1]
		boss.mapPins = #list > 1 and list or nil
	end
	for name, spot in pairs(spec.kept or {}) do
		assert(byName[name], "ClassicMaps: " .. key .. " has no boss named " .. name)
		byName[name].mapPin = spot
	end
end

UseMaps("RagefireChasm", {
	floors = { { 213, "ragefire-chasm" } },
	spots = {
		{ "Oggleflint", 1, 0.561, 0.380 }, { "Taragaman the Hungerer", 1, 0.410, 0.577 },
		{ "Jergosh the Invoker", 1, 0.330, 0.845 }, { "Bazzalan", 1, 0.415, 0.862 },
	},
})

UseMaps("WailingCaverns", {
	floors = { { 279, "wailing-caverns" } },
	spots = {
		{ "Lord Cobrahn", 1, 0.156, 0.585 },
		{ "Lady Anacondra", 1, 0.305, 0.432 }, { "Lady Anacondra", 1, 0.281, 0.318 },
		{ "Lady Anacondra", 1, 0.470, 0.456 }, { "Lady Anacondra", 1, 0.403, 0.274 },
		{ "Kresh", 1, 0.258, 0.446 }, { "Lord Serpentis", 1, 0.625, 0.533 },
		{ "Verdan the Everliving", 1, 0.564, 0.474 }, { "Mutanus the Devourer", 1, 0.342, 0.158 },
	},
	-- Not placed by the site: where the earlier maps' sources agreed (Lord Pythas, the Deviate
	-- Faerie Dragon) and the journal's earlier one (Skum, the same).
	kept = {
		["Lord Pythas"] = { x = 0.191, y = 0.401, floor = 1 },
		["Deviate Faerie Dragon"] = { x = 0.129, y = 0.333, floor = 1 },
	},
})

UseMaps("TheDeadmines", {
	floors = { { 291, "the-deadmines-1", "The Deadmines" }, { 292, "the-deadmines-2", "Ironclad Cove" } },
	spots = {
		{ "Rhahk'Zor", 1, 0.386, 0.609 }, { "Miner Johnson", 1, 0.527, 0.505 },
		{ "Sneed", 1, 0.450, 0.889 }, { "Sneed's Shredder", 1, 0.485, 0.924 },
		{ "Gilnid", 2, 0.119, 0.731 }, { "Mr. Smite", 2, 0.561, 0.265 }, { "Captain Greenskin", 2, 0.617, 0.359 },
		{ "Edwin VanCleef", 2, 0.606, 0.459 }, { "Cookie", 2, 0.697, 0.420 },
	},
})

UseMaps("ShadowfangKeep", {
	floors = {
		{ 310, "shadowfang-keep-1", "The Courtyard" }, { 311, "shadowfang-keep-2", "Dining Hall" },
		{ 316, "shadowfang-keep-7", "The Wall Walk" }, { 315, "shadowfang-keep-6", "Arugal's Chamber" },
	},
	spots = {
		{ "Rethilgore", 1, 0.661, 0.711 }, { "Fel Steed / Shadow Charger", 1, 0.331, 0.626 },
		{ "Commander Springvale", 1, 0.255, 0.556 },
		{ "Razorclaw the Butcher", 2, 0.480, 0.290 }, { "Baron Silverlaine", 2, 0.295, 0.803 },
		{ "Odo the Blindwatcher", 3, 0.551, 0.771 }, { "Deathsworn Captain", 3, 0.630, 0.525 },
		{ "Fenrus the Devourer", 4, 0.557, 0.645 }, { "Wolf Master Nandos", 4, 0.590, 0.533 },
		{ "Archmage Arugal", 4, 0.639, 0.200 },
	},
})

UseMaps("BlackfathomDeeps", {
	floors = {
		{ 221, "blackfathom-deeps-1", "The Pool of Ask'Ar" }, { 222, "blackfathom-deeps-2", "Moonshrine Sanctum" },
		{ 223, "blackfathom-deeps-3", "The Forgotten Pool" },
	},
	spots = {
		{ "Ghamoo-ra", 1, 0.329, 0.602 }, { "Lady Sarevess", 1, 0.101, 0.360 }, { "Gelihast", 1, 0.523, 0.551 },
		{ "Lorgus Jett", 2, 0.388, 0.200 }, { "Lorgus Jett", 2, 0.441, 0.234 },
		{ "Lorgus Jett", 2, 0.354, 0.483 }, { "Lorgus Jett", 2, 0.338, 0.723 },
		{ "Baron Aquanis", 2, 0.415, 0.754 }, { "Twilight Lord Kelris", 2, 0.519, 0.816 }, { "Aku'mai", 2, 0.856, 0.866 },
		{ "Old Serra'kis", 3, 0.606, 0.312 },
	},
})

UseMaps("TheStockade", {
	floors = { { 225, "the-stockade" } },
	spots = {
		{ "Targorr the Dread", 1, 0.499, 0.242 }, { "Targorr the Dread", 1, 0.424, 0.464 },
		{ "Targorr the Dread", 1, 0.578, 0.552 }, { "Targorr the Dread", 1, 0.333, 0.375 },
		{ "Kam Deepfury", 1, 0.692, 0.309 }, { "Hamhock", 1, 0.782, 0.457 },
		{ "Dextren Ward", 1, 0.146, 0.214 }, { "Dextren Ward", 1, 0.250, 0.165 }, { "Dextren Ward", 1, 0.175, 0.417 },
		{ "Bazil Thredd", 1, 0.857, 0.510 },
		{ "Bruegal Ironknuckle", 1, 0.381, 0.240 }, { "Bruegal Ironknuckle", 1, 0.295, 0.447 },
		{ "Bruegal Ironknuckle", 1, 0.616, 0.483 }, { "Bruegal Ironknuckle", 1, 0.615, 0.251 },
	},
})

UseMaps("Gnomeregan", {
	floors = {
		{ 226, "gnomeregan-1", "The Hall of Gears" }, { 227, "gnomeregan-2", "The Dormitory" },
		{ 228, "gnomeregan-3", "Launch Bay" }, { 229, "gnomeregan-4", "Tinkers' Court" },
	},
	spots = {
		{ "Grubbis", 1, 0.819, 0.651 }, { "Viscous Fallout", 1, 0.576, 0.566 },
		{ "Electrocutioner 6000", 2, 0.248, 0.679 }, { "Crowd Pummeler 9-60", 3, 0.438, 0.865 },
		{ "Dark Iron Ambassador", 4, 0.295, 0.540 }, { "Mekgineer Thermaplugg", 4, 0.313, 0.300 },
	},
})

UseMaps("RazorfenKraul", {
	floors = { { 301, "razorfen-kraul" } },
	spots = {
		{ "Aggem Thorncurse", 1, 0.808, 0.545 }, { "Death Speaker Jargba", 1, 0.879, 0.414 }, { "Roogug", 1, 0.648, 0.421 },
		{ "Overlord Ramtusk", 1, 0.569, 0.298 }, { "Razorfen Spearhide", 1, 0.534, 0.355 },
		{ "Agathelos the Raging", 1, 0.112, 0.724 }, { "Blind Hunter", 1, 0.110, 0.303 },
		{ "Charlga Razorflank", 1, 0.264, 0.324 }, { "Earthcaller Halmgar", 1, 0.494, 0.471 },
	},
})

-- The graveyard's three rares share six places: one of them, at one of the six, about one run in three.
local GRAVEYARD_RARE_SPOTS = {
	{ 0.416, 0.679 }, { 0.409, 0.466 }, { 0.367, 0.439 }, { 0.355, 0.664 }, { 0.262, 0.691 }, { 0.217, 0.572 },
}
local graveyardSpots = { { "Interrogator Vishas", 1, 0.715, 0.589 }, { "Bloodmage Thalnos", 1, 0.244, 0.508 } }
for _, rare in ipairs({ "Azshir the Sleepless", "Fallen Champion", "Ironspine" }) do
	for _, spot in ipairs(GRAVEYARD_RARE_SPOTS) do graveyardSpots[#graveyardSpots + 1] = { rare, 1, spot[1], spot[2] } end
end
UseMaps("ScarletMonasteryGraveyard", { floors = { { 302, "scarlet-monastery-graveyard" } }, spots = graveyardSpots })

UseMaps("ScarletMonasteryLibrary", {
	floors = { { 303, "scarlet-monastery-library" } },
	spots = { { "Houndmaster Loksey", 1, 0.308, 0.878 }, { "Arcanist Doan", 1, 0.832, 0.745 } },
})

UseMaps("ScarletMonasteryArmory", {
	floors = { { 304, "scarlet-monastery-armory" } },
	spots = { { "Herod", 1, 0.786, 0.108 } },
})

UseMaps("ScarletMonasteryCathedral", {
	floors = { { 305, "scarlet-monastery-cathedral" } },
	spots = {
		{ "High Inquisitor Fairbanks", 1, 0.554, 0.261 }, { "Scarlet Commander Mograine", 1, 0.491, 0.272 },
		{ "High Inquisitor Whitemane", 1, 0.490, 0.169 },
	},
})
