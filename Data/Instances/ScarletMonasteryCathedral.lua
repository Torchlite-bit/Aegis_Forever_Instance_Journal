-- Scarlet Monastery: Cathedral: the journal's own data for this wing, from foreverchanges.pro's page for it
-- (2026-10-09), facts only, in our own words. Edit it by hand. The client gives all four wings one
-- instance id (189): the journal tells which wing the player is in by the area's name (wingAreas).
-- Its map and boss spots are set in Data/Authored/ClassicMaps.lua; the bosses' abilities are
-- added by Data/Generated/Abilities.lua (Dev/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "ScarletMonasteryCathedral",
	instanceID = 189,
	kind = "dungeon",
	name = "Scarlet Monastery: Cathedral",
	levelMin = 38,
	levelMax = 46,
	location = "Tirisfal Glades",
	description = "The monastery's cathedral and the heart of the Scarlet Crusade, held by Scarlet Commander Mograine and High Inquisitor Whitemane.",
	buttonArt = { "Interface\\Glues\\LoadingScreens\\LoadScreenScarletMonastery" },
	buttonImage = { "Interface\\EncounterJournal\\UI-EJ-DUNGEONBUTTON-ScarletMonastery" },
	loreImage = { "Interface\\EncounterJournal\\UI-EJ-LOREBG-ScarletMonastery" },
	buttonArtCoords = { 0, 1, 0.13, 0.87 },
	iconArtCoords = { 0.2, 0.8, 0.1, 0.9 },
	loreArtCoords = { 0, 1, 0.1, 0.9 },
	zoneEntrance = {
		mapID = 1420,
		x = 0.826,
		y = 0.338,
	},
	wingAreas = {
		["Chapel Gardens"] = true,
		["Crusader's Chapel"] = true,
	},
	map = {
		floors = {},
	},
	bosses = {
		{
			name = "High Inquisitor Fairbanks",
			npcID = 4542,
			displayID = 2605,
			level = 40,
			order = 1,
			notes = {
				"He lies on the floor of the small room beside the altar, as if dead, and rises when attacked.",
				"Interrupt his Fear and, at 30% health, his heal. He puts everyone near him to sleep (damage wakes a sleeper), and a mage or a druid can remove his Curse of Blood.",
			},
			loot = {
				{
					itemID = 19507,
				},
				{
					itemID = 19508,
				},
				{
					itemID = 19509,
				},
			},
		},
		{
			name = "Scarlet Commander Mograine",
			npcID = 3976,
			displayID = 2042,
			level = 42,
			order = 2,
			notes = {
				"When pulled he calls every Scarlet defender within 80 yards: clear the cathedral first.",
				"At half health Divine Shield makes him immune for 12 seconds. He stuns with Hammer of Justice, and his aura hurts whoever strikes him in melee.",
			},
			loot = {
				{
					itemID = 7724,
				},
				{
					itemID = 10330,
				},
				{
					itemID = 7726,
				},
				{
					itemID = 7723,
				},
			},
		},
		{
			name = "High Inquisitor Whitemane",
			npcID = 3977,
			displayID = 2043,
			level = 42,
			order = 3,
			notes = {
				"When Mograine falls he is only playing dead: she runs out of the room behind the altar.",
				"At half health she puts the room to sleep and raises Mograine, who heals her fully: the two fight together.",
				"Interrupt her Holy Smite and her heals; a priest or a shaman can remove her shield.",
			},
			loot = {
				{
					itemID = 7720,
				},
				{
					itemID = 7722,
				},
				{
					itemID = 7721,
				},
			},
		},
		{
			name = "Trash Drops",
			trash = true,
			loot = {
				{
					itemID = 5819,
				},
				{
					itemID = 7755,
				},
				{
					itemID = 7727,
				},
				{
					itemID = 7728,
				},
				{
					itemID = 7759,
				},
				{
					itemID = 7760,
				},
				{
					itemID = 7754,
				},
				{
					itemID = 10332,
				},
				{
					itemID = 1992,
				},
				{
					itemID = 2262,
				},
				{
					itemID = 7787,
				},
				{
					itemID = 7729,
				},
				{
					itemID = 7761,
				},
				{
					itemID = 7752,
				},
				{
					itemID = 8226,
				},
				{
					itemID = 7786,
				},
				{
					itemID = 5756,
				},
				{
					itemID = 7736,
				},
				{
					itemID = 8225,
				},
				{
					itemID = 7753,
				},
				{
					itemID = 7730,
				},
				{
					itemID = 7758,
				},
				{
					itemID = 7757,
				},
				{
					itemID = 10328,
				},
				{
					itemID = 10331,
				},
				{
					itemID = 10329,
				},
				{
					itemID = 10330,
				},
				{
					itemID = 10333,
				},
			},
		},
	},
	quests = {
		{
			questID = 1053,
			name = "In the Name of the Light",
			level = 40,
			requiredLevel = 34,
			faction = "Alliance",
			pickup = "Raleigh the Devout, Southshore, Hillsbrad Foothills",
			turnin = "Raleigh the Devout, Southshore, Hillsbrad Foothills",
			startMap = {
				mapID = 1424,
				x = 0.515,
				y = 0.584,
			},
			objective = "Kill High Inquisitor Whitemane, Scarlet Commander Mograine, Herod and Houndmaster Loksey, then report to Raleigh the Devout in Southshore.",
			prerequisites = {
				{
					questID = 6141,
					name = "Brother Anton",
				},
				{
					questID = 261,
					name = "Down the Scarlet Path",
				},
				{
					questID = 1052,
					name = "Down the Scarlet Path",
				},
			},
			rewards = {
				items = {
					{
						itemID = 6829,
					},
					{
						itemID = 6830,
					},
					{
						itemID = 6831,
					},
					{
						itemID = 11262,
					},
				},
				choice = true,
			},
		},
		{
			questID = 1048,
			name = "Into The Scarlet Monastery",
			level = 42,
			requiredLevel = 33,
			faction = "Horde",
			pickup = "Varimathras, Royal Quarter, Undercity",
			turnin = "Varimathras, Royal Quarter, Undercity",
			startMap = {
				mapID = 1458,
				x = 0.563,
				y = 0.922,
			},
			objective = "Kill High Inquisitor Whitemane, Scarlet Commander Mograine, Herod and Houndmaster Loksey, then report to Varimathras in the Undercity.",
			rewards = {
				items = {
					{
						itemID = 6802,
					},
					{
						itemID = 6803,
					},
					{
						itemID = 10711,
					},
				},
				choice = true,
			},
		},
	},
})
