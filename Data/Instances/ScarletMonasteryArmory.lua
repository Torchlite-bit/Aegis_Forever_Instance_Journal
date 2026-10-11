-- Scarlet Monastery: Armory: the journal's own data for this wing, from foreverchanges.pro's page for it
-- (2026-10-09), facts only, in our own words. Edit it by hand. The client gives all four wings one
-- instance id (189): the journal tells which wing the player is in by the area's name (wingAreas).
-- Its map and boss spots are set in Data/Authored/ClassicMaps.lua; the bosses' abilities are
-- added by Data/Generated/Abilities.lua (Tools/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "ScarletMonasteryArmory",
	instanceID = 189,
	kind = "dungeon",
	name = "Scarlet Monastery: Armory",
	levelMin = 36,
	levelMax = 44,
	location = "Tirisfal Glades",
	description = "The Scarlet Crusade's armory and training halls, where Herod, the Scarlet Champion, drills the Crusade's soldiers.",
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
		["Crusader's Armory"] = true,
		["Footman's Armory"] = true,
		["Hall of Champions"] = true,
		["Training Grounds"] = true,
	},
	map = {
		floors = {},
	},
	bosses = {
		{
			name = "Herod",
			npcID = 3975,
			displayID = 2041,
			level = 40,
			order = 1,
			notes = {
				"Every 15 to 25 seconds he whirls for 10 seconds, hitting everyone near him: melee, step back until it ends.",
				"He cleaves, and at 30% health enrages for 2 minutes: much faster and harder blows.",
				"When he dies, twenty Scarlet Trainees rush in through the hall's door: stay together and use area damage.",
			},
			loot = {
				{
					itemID = 7719,
				},
				{
					itemID = 7718,
				},
				{
					itemID = 10330,
				},
				{
					itemID = 7717,
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
					itemID = 7757,
				},
				{
					itemID = 10333,
				},
				{
					itemID = 10329,
				},
				{
					itemID = 23192,
				},
				{
					itemID = 7758,
				},
				{
					itemID = 7760,
				},
				{
					itemID = 10328,
				},
				{
					itemID = 10330,
				},
				{
					itemID = 10331,
				},
			},
		},
	},
	quests = {},
})
