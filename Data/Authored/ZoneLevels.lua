local _, ns = ...

-- Each zone's level range, shown after its name on the world map (UI/ZoneMap.lua) when the
-- client's own map data gives none. The classic ranges, by uiMapID; a range the client knows
-- (C_Map.GetMapLevels) always wins over these.
ns.ZONE_LEVELS = {
	-- Kalimdor
	[1411] = { 1, 10 }, -- Durotar
	[1412] = { 1, 10 }, -- Mulgore
	[1413] = { 10, 25 }, -- The Barrens
	[1438] = { 1, 10 }, -- Teldrassil
	[1439] = { 10, 20 }, -- Darkshore
	[1440] = { 18, 30 }, -- Ashenvale
	[1441] = { 25, 35 }, -- Thousand Needles
	[1442] = { 15, 27 }, -- Stonetalon Mountains
	[1443] = { 30, 40 }, -- Desolace
	[1444] = { 40, 50 }, -- Feralas
	[1445] = { 35, 45 }, -- Dustwallow Marsh
	[1446] = { 40, 50 }, -- Tanaris
	[1447] = { 45, 55 }, -- Azshara
	[1448] = { 48, 55 }, -- Felwood
	[1449] = { 48, 55 }, -- Un'Goro Crater
	[1451] = { 55, 60 }, -- Silithus
	[1452] = { 55, 60 }, -- Winterspring
	-- Eastern Kingdoms
	[1416] = { 30, 40 }, -- Alterac Mountains
	[1417] = { 30, 40 }, -- Arathi Highlands
	[1418] = { 35, 45 }, -- Badlands
	[1419] = { 45, 55 }, -- Blasted Lands
	[1420] = { 1, 10 }, -- Tirisfal Glades
	[1421] = { 10, 20 }, -- Silverpine Forest
	[1422] = { 51, 58 }, -- Western Plaguelands
	[1423] = { 53, 60 }, -- Eastern Plaguelands
	[1424] = { 20, 30 }, -- Hillsbrad Foothills
	[1425] = { 40, 50 }, -- The Hinterlands
	[1426] = { 1, 10 }, -- Dun Morogh
	[1427] = { 43, 50 }, -- Searing Gorge
	[1428] = { 50, 58 }, -- Burning Steppes
	[1429] = { 1, 10 }, -- Elwynn Forest
	[1430] = { 55, 60 }, -- Deadwind Pass
	[1431] = { 18, 30 }, -- Duskwood
	[1432] = { 10, 20 }, -- Loch Modan
	[1433] = { 15, 25 }, -- Redridge Mountains
	[1434] = { 30, 45 }, -- Stranglethorn Vale
	[1435] = { 35, 45 }, -- Swamp of Sorrows
	[1436] = { 10, 20 }, -- Westfall
	[1437] = { 20, 30 }, -- Wetlands
	-- Forever's own
	[2548] = { 36, 44 }, -- Riverglades
}

-- Forever's zones whose uiMapID we don't know yet, by the name the map gives them; ranges from
-- the game, as Torchlite read them (2026-10-14).
ns.ZONE_LEVELS_BY_NAME = {
	["Riverglades"] = { 36, 44 },
	["Mount Hyjal"] = { 60, 60 },
	["Shen'dralas"] = { 35, 45 },
}
