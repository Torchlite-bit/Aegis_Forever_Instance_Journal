-- Scarlet Monastery: Graveyard: the journal's own data for this dungeon. Edit it by hand.
-- Hand-written notes, fights, maps and corrections are laid over it by the files in Data/Authored;
-- foreverchanges.pro is the source to check it against. The bosses' abilities are added by
-- Data/Generated/Abilities.lua (Tools/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "ScarletMonasteryGraveyard",
	instanceID = 189,
	kind = "dungeon",
	name = "Scarlet Monastery: Graveyard",
	levelMin = 30,
	levelMax = 38,
	location = "Tirisfal Glades",
	buttonArt = { "Interface\\Glues\\LoadingScreens\\LoadScreenScarletMonastery" },
	buttonImage = { "Interface\\EncounterJournal\\UI-EJ-DUNGEONBUTTON-ScarletMonastery" },
	loreImage = { "Interface\\EncounterJournal\\UI-EJ-LOREBG-ScarletMonastery" },
	buttonArtCoords = { 0, 1, 0.13, 0.87 },
	iconArtCoords = { 0.2, 0.8, 0.1, 0.9 },
	loreArtCoords = { 0, 1, 0.1, 0.9 },
	map = {
		entrance = {
			x = 0.841,
			y = 0.831,
			floor = 1,
		},
		floors = {
			{
				uiMapID = 302,
				tiles = "Interface\\WorldMap\\ScarletMonastery\\ScarletMonastery1_",
			},
		},
	},
	zoneEntrance = {
		mapID = 1420,
		x = 0.826,
		y = 0.338,
	},
	bosses = {
		{
			name = "Interrogator Vishas",
			npcID = 3983,
			level = 32,
			description = "In the Chamber of Atonement. He drops Vorrel's Wedding Ring, for Vorrel's Revenge.",
			displayID = 2044,
			loot = {
				{
					itemID = 7682,
					name = "Torturing Poker",
					slot = "One-Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 7683,
					name = "Bloody Brass Knuckles",
					slot = "One-Hand, Fist Weapon",
					quality = 3,
				},
				{
					itemID = 274290,
					name = "Painwalker Buckler",
					slot = "Off Hand, Shield",
					quality = 3,
				},
				{
					itemID = 252513,
					name = "Trapper's Leather Helm",
					slot = "Head, Leather",
					quality = 3,
				},
				{
					itemID = 253976,
				},
				{
					itemID = 252515,
				},
				{
					itemID = 252821,
				},
			},
			mapPin = {
				x = 0.724,
				y = 0.6,
				floor = 1,
			},
			order = 1,
		},
		{
			name = "Azshir the Sleepless",
			npcID = 6490,
			level = 33,
			rare = true,
			displayID = 5534,
			loot = {
				{
					itemID = 7709,
					name = "Blighted Leggings",
					slot = "Legs, Cloth",
					quality = 3,
				},
				{
					itemID = 7708,
					name = "Necrotic Wand",
					slot = "Ranged, Wand",
					quality = 3,
				},
				{
					itemID = 7731,
					name = "Ghostshard Talisman",
					slot = "Neck",
					quality = 3,
				},
			},
			order = 2,
		},
		{
			name = "Fallen Champion",
			npcID = 6488,
			level = 33,
			rare = true,
			displayID = 5230,
			loot = {
				{
					itemID = 7691,
					name = "Embalmed Shroud",
					slot = "Head, Cloth",
					quality = 3,
				},
				{
					itemID = 7690,
					name = "Ebon Vise",
					slot = "Hands, Leather",
					quality = 3,
				},
				{
					itemID = 7689,
					name = "Morbid Dawn",
					slot = "Two-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 252513,
					name = "Trapper's Leather Helm",
					slot = "Head, Leather",
					quality = 3,
				},
			},
			order = 3,
		},
		{
			name = "Ironspine",
			npcID = 6489,
			level = 33,
			rare = true,
			displayID = 5231,
			loot = {
				{
					itemID = 7688,
					name = "Ironspine's Ribcage",
					slot = "Chest, Mail",
					quality = 3,
				},
				{
					itemID = 7687,
					name = "Ironspine's Fist",
					slot = "One-Hand, Mace",
					quality = 3,
				},
				{
					itemID = 7686,
					name = "Ironspine's Eye",
					slot = "Finger",
					quality = 3,
				},
			},
			order = 4,
		},
		{
			name = "Bloodmage Thalnos",
			npcID = 4543,
			level = 34,
			description = "The last boss, in Honor's Tomb.",
			displayID = 11396,
			loot = {
				{
					itemID = 7685,
					name = "Orb of the Forgotten Seer",
					slot = "Held In Off-hand",
					quality = 3,
				},
				{
					itemID = 7684,
					name = "Bloodmage Mantle",
					slot = "Shoulder, Cloth",
					quality = 3,
				},
				{
					itemID = 274291,
					name = "Polished Skullcap",
					slot = "Head, Mail",
					quality = 3,
				},
				{
					itemID = 252822,
					name = "Pattern: Defender's Leather Kilt",
					slot = "Recipe, Leatherworking",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.246,
				y = 0.566,
				floor = 1,
			},
			order = 5,
		},
		{
			name = "Scorn",
			npcID = 14693,
			displayID = 16197,
			loot = {
				{
					itemID = 23169,
				},
				{
					itemID = 23170,
				},
				{
					itemID = 23168,
				},
			},
			order = 6,
		},
		{
			name = "Trash Drops",
			trash = true,
			loot = {
				{
					itemID = 10328,
					name = "Scarlet Chestpiece",
					slot = "Chest, Mail",
					quality = 3,
					droppedBy = "Scarlet Monastery trash (Chain of the Scarlet Crusade)",
				},
				{
					itemID = 10329,
					name = "Scarlet Belt",
					slot = "Waist, Mail",
					quality = 3,
					droppedBy = "Scarlet Monastery trash (Chain of the Scarlet Crusade)",
				},
				{
					itemID = 10330,
					name = "Scarlet Leggings",
					slot = "Legs, Mail",
					quality = 3,
					droppedBy = "Scarlet Monastery trash (Chain of the Scarlet Crusade)",
				},
				{
					itemID = 10331,
					name = "Scarlet Gauntlets",
					slot = "Hands, Mail",
					quality = 3,
					droppedBy = "Scarlet Monastery trash (Chain of the Scarlet Crusade)",
				},
				{
					itemID = 10333,
					name = "Scarlet Wristguards",
					slot = "Wrist, Mail",
					quality = 3,
					droppedBy = "Scarlet Monastery trash (Chain of the Scarlet Crusade)",
				},
				{
					itemID = 10332,
					name = "Scarlet Boots",
					slot = "Feet, Mail",
					quality = 3,
					droppedBy = "Scarlet Monastery trash (Chain of the Scarlet Crusade)",
				},
				{
					itemID = 5819,
					name = "Sunblaze Coif",
					slot = "Head, Mail",
					quality = 3,
					droppedBy = "Scarlet Monastery trash (very rare)",
				},
				{
					itemID = 7730,
					name = "Cobalt Crusher",
					slot = "Two-Hand, Mace",
					quality = 3,
					droppedBy = "Scarlet Monastery trash (very rare)",
				},
				{
					itemID = 7761,
					name = "Steelclaw Reaver",
					slot = "Main Hand, Axe",
					quality = 3,
					droppedBy = "Scarlet Monastery trash (very rare)",
				},
				{
					itemID = 7787,
					name = "Resplendent Guardian",
					slot = "Off Hand, Shield",
					quality = 3,
					droppedBy = "Scarlet Monastery trash (very rare)",
				},
				{
					itemID = 7727,
				},
				{
					itemID = 7728,
				},
				{
					itemID = 7754,
				},
				{
					itemID = 2262,
				},
				{
					itemID = 7729,
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
					itemID = 7753,
				},
			},
		},
	},
	quests = {
		{
			questID = 1051,
			name = "Vorrel's Revenge",
			level = 33,
			requiredLevel = 25,
			faction = "Horde",
			objective = "Return Vorrel Sengutz's wedding ring (from Nancy Vishas) to Monika Sengutz in Tarren Mill.",
			pickup = "Vorrel Sengutz, inside the Graveyard",
			turnin = "Monika Sengutz, Tarren Mill, Hillsbrad Foothills",
			rewards = {
				xp = 3300,
				items = {
					{
						itemID = 7750,
						name = "Mantle of Woe",
						quality = 2,
					},
					{
						itemID = 4643,
						name = "Grimsteel Cape",
						quality = 2,
					},
				},
				choice = true,
			},
		},
		{
			questID = 1113,
			name = "Hearts of Zeal",
			level = 33,
			requiredLevel = 30,
			faction = "Horde",
			startMap = {
				mapID = 1458,
				x = 0.48,
				y = 0.69,
				label = "Master Apothecary Faranell — Apothecarium",
			},
			objective = "Bring 20 Hearts of Zeal from the Scarlet Monastery to Master Apothecary Faranell.",
			pickup = "Master Apothecary Faranell, Undercity",
			turnin = "Master Apothecary Faranell, Undercity",
			rewards = {
				xp = 3300,
			},
			prerequisites = {
				{
					questID = 1109,
					name = "Going, Going, Guano!",
				},
			},
		},
	},
})
