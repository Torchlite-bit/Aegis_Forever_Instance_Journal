-- Maraudon: the journal's own data for this dungeon. Edit it by hand.
-- Bosses, levels, models, loot and quests as foreverchanges.pro lists them (2026-10-10), facts
-- only; its maps (Media/Maps/Classic), floor names and boss spots are the classic dungeon maps
-- that Advanced Dungeon Guide keeps. The bosses' abilities are added by
-- Data/Generated/Abilities.lua (Tools/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "Maraudon",
	instanceID = 349,
	kind = "dungeon",
	name = "Maraudon",
	levelMin = 46,
	levelMax = 55,
	location = "Desolace",
	description = "A vast cavern under Desolace, sacred to the centaur, where Princess Theradras, daughter of Therazane, has fouled the waters and the resting place of Zaetar.",
	buttonArt = { "Interface\\Glues\\LoadingScreens\\LoadScreenMaraudon" },
	buttonImage = { "Interface\\EncounterJournal\\UI-EJ-DUNGEONBUTTON-Maraudon" },
	loreImage = { "Interface\\EncounterJournal\\UI-EJ-LOREBG-Maraudon" },
	buttonArtCoords = { 0, 1, 0.13, 0.87 },
	iconArtCoords = { 0.2, 0.8, 0.1, 0.9 },
	loreArtCoords = { 0, 1, 0.1, 0.9 },
	zoneEntrance = {
		mapID = 1443,
		world = { 1, -1422.6, 2918.4 },
	},
	map = {
		entrance = {
			x = 0.769,
			y = 0.66,
			floor = 1,
		},
		floors = {
			{
				art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\Classic\\Maraudon",
				artRight = 0.9785,
				artBottom = 0.6523,
				uiMapID = 280,
			},
			{
				art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\Classic\\Maraudon1",
				artRight = 0.9785,
				artBottom = 0.6523,
				uiMapID = 281,
			},
		},
	},
	floorNames = { "Caverns of Maraudon", "Zaetar's Grave" },
	bosses = {
		{
			name = "Veng",
			displayID = 9418,
			level = 47,
			order = 1,
			loot = {
				{
					itemID = 17765,
					name = "Gem of the Fifth Khan",
					slot = "Quest",
					quality = 1,
				},
			},
		},
		{
			name = "Razorlash",
			displayID = 12389,
			level = 48,
			order = 2,
			loot = {
				{
					itemID = 17749,
					name = "Phytoskin Spaulders",
					slot = "Shoulder, Leather",
					quality = 3,
				},
				{
					itemID = 17748,
					name = "Vinerot Sandals",
					slot = "Feet, Cloth",
					quality = 3,
				},
				{
					itemID = 17750,
					name = "Chloromesh Girdle",
					slot = "Waist, Cloth",
					quality = 2,
				},
				{
					itemID = 17751,
					name = "Brusslehide Leggings",
					slot = "Legs, Leather",
					quality = 2,
				},
			},
			mapPin = {
				x = 0.163,
				y = 0.338,
				floor = 1,
			},
		},
		{
			name = "Meshlok the Harvester",
			displayID = 9014,
			level = 48,
			rare = true,
			order = 3,
			loot = {
				{
					itemID = 17767,
					name = "Bloomsprout Headpiece",
					slot = "Head, Mail",
					quality = 3,
				},
				{
					itemID = 17741,
					name = "Nature's Embrace",
					slot = "Chest, Cloth",
					quality = 3,
				},
				{
					itemID = 17742,
					name = "Fungus Shroud Armor",
					slot = "Chest, Leather",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.535,
				y = 0.776,
				floor = 1,
			},
		},
		{
			name = "Landslide",
			displayID = 12293,
			level = 50,
			order = 4,
			loot = {
				{
					itemID = 17734,
					name = "Helm of the Mountain",
					slot = "Head, Plate",
					quality = 3,
				},
				{
					itemID = 17736,
					name = "Rockgrip Gauntlets",
					slot = "Hands, Mail",
					quality = 3,
				},
				{
					itemID = 17737,
					name = "Cloud Stone",
					slot = "Held In Off-hand",
					quality = 3,
				},
				{
					itemID = 17943,
					name = "Fist of Stone",
					slot = "Main Hand, Mace",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.412,
				y = 0.492,
				floor = 2,
			},
		},
		{
			name = "Rotgrip",
			displayID = 13589,
			level = 50,
			order = 5,
			loot = {
				{
					itemID = 17732,
					name = "Rotgrip Mantle",
					slot = "Shoulder, Cloth",
					quality = 3,
				},
				{
					itemID = 17728,
					name = "Albino Crocscale Boots",
					slot = "Feet, Leather",
					quality = 3,
				},
				{
					itemID = 17730,
					name = "Gatorbite Axe",
					slot = "Two-Hand, Axe",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.415,
				y = 0.812,
				floor = 2,
			},
		},
		{
			name = "Noxxion",
			displayID = 11172,
			level = 48,
			order = 6,
			loot = {
				{
					itemID = 17746,
					name = "Noxxion's Shackles",
					slot = "Wrist, Plate",
					quality = 3,
				},
				{
					itemID = 17744,
					name = "Heart of Noxxion",
					slot = "Trinket",
					quality = 3,
				},
				{
					itemID = 17745,
					name = "Noxious Shooter",
					slot = "Ranged, Wand",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.357,
				y = 0.1,
				floor = 1,
			},
		},
		{
			name = "Maraudos",
			displayID = 9441,
			level = 46,
			order = 7,
			loot = {
				{
					itemID = 17764,
					name = "Gem of the Fourth Khan",
					slot = "Quest",
					quality = 1,
				},
			},
		},
		{
			name = "Lord Vyletongue",
			displayID = 12334,
			level = 47,
			order = 8,
			loot = {
				{
					itemID = 17755,
					name = "Satyrmane Sash",
					slot = "Waist, Cloth",
					quality = 3,
				},
				{
					itemID = 17754,
					name = "Infernal Trickster Leggings",
					slot = "Legs, Mail",
					quality = 3,
				},
				{
					itemID = 17752,
					name = "Satyr's Lash",
					slot = "One-Hand, Dagger",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.378,
				y = 0.707,
				floor = 1,
			},
		},
		{
			name = "Celebras the Cursed",
			displayID = 12350,
			level = 49,
			order = 9,
			loot = {
				{
					itemID = 17740,
					name = "Soothsayer's Headdress",
					slot = "Head, Leather",
					quality = 3,
				},
				{
					itemID = 17739,
					name = "Grovekeeper's Drape",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 17738,
					name = "Claw of Celebras",
					slot = "Off Hand, Fist Weapon",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.243,
				y = 0.14,
				floor = 2,
			},
		},
		{
			name = "Tinkerer Gizlock",
			displayID = 7125,
			level = 50,
			order = 10,
			loot = {
				{
					itemID = 17718,
					name = "Gizlock's Hypertech Buckler",
					slot = "Off Hand, Shield",
					quality = 3,
				},
				{
					itemID = 17717,
					name = "Megashot Rifle",
					slot = "Ranged, Gun",
					quality = 3,
				},
				{
					itemID = 17719,
					name = "Inventor's Focal Sword",
					slot = "One-Hand, Sword",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.506,
				y = 0.523,
				floor = 1,
			},
		},
		{
			name = "Princess Theradras",
			displayID = 12292,
			level = 51,
			order = 11,
			loot = {
				{
					itemID = 17780,
					name = "Blade of Eternal Darkness",
					slot = "Main Hand, Dagger",
					quality = 4,
				},
				{
					itemID = 17715,
					name = "Eye of Theradras",
					slot = "Head, Cloth",
					quality = 3,
				},
				{
					itemID = 17707,
					name = "Gemshard Heart",
					slot = "Neck",
					quality = 3,
				},
				{
					itemID = 17714,
					name = "Bracers of the Stone Princess",
					slot = "Wrist, Mail",
					quality = 3,
				},
				{
					itemID = 17711,
					name = "Elemental Rockridge Leggings",
					slot = "Legs, Plate",
					quality = 3,
				},
				{
					itemID = 17713,
					name = "Blackstone Ring",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 17710,
					name = "Charstone Dirk",
					slot = "Main Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 17766,
					name = "Princess Theradras' Scepter",
					slot = "Two-Hand, Mace",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.261,
				y = 0.783,
				floor = 2,
			},
		},
	},
	quests = {
		{
			questID = 7070,
			name = "Shadowshard Fragments",
			level = 42,
			requiredLevel = 39,
			faction = "Alliance",
			startMap = {
				mapID = 1445,
				x = 0.664,
				y = 0.493,
			},
			endMap = {
				mapID = 1445,
				x = 0.664,
				y = 0.493,
			},
			objective = "Collect 10 Shadowshard Fragments from Maraudon and return them to Archmage Tervosh in Theramore on the coast of Dustwallow Marsh.",
			pickup = "Archmage Tervosh, Dustwallow Marsh",
			turnin = "Archmage Tervosh, Dustwallow Marsh",
			rewards = {
				xp = 3450,
				items = {
					{
						itemID = 17772,
						name = "Zealous Shadowshard Pendant",
					},
					{
						itemID = 17773,
						name = "Prodigious Shadowshard Pendant",
					},
				},
				choice = true,
			},
		},
		{
			questID = 7067,
			name = "The Pariah's Instructions",
			level = 48,
			requiredLevel = 39,
			faction = "Both",
			startMap = {
				mapID = 1443,
				x = 0.504,
				y = 0.867,
			},
			endMap = {
				mapID = 1443,
				x = 0.504,
				y = 0.867,
			},
			objective = "Read the Pariah's Instructions. Afterwards, obtain the Amulet of Union from Maraudon and return it to the Centaur Pariah in southern Desolace.",
			pickup = "Centaur Pariah, Desolace",
			turnin = "Centaur Pariah, Desolace",
			rewards = {
				xp = 5450,
				money = 14000,
				items = {
					{
						itemID = 17774,
						name = "Mark of the Chosen",
					},
				},
			},
		},
		{
			questID = 7028,
			name = "Twisted Evils",
			level = 47,
			requiredLevel = 41,
			faction = "Both",
			startMap = {
				mapID = 1443,
				x = 0.622,
				y = 0.396,
			},
			endMap = {
				mapID = 1443,
				x = 0.622,
				y = 0.396,
			},
			objective = "Collect 15 Theradric Crystal Carvings for Willow in Desolace.",
			pickup = "Willow, Desolace",
			turnin = "Willow, Desolace",
			rewards = {
				xp = 5250,
				items = {
					{
						itemID = 17775,
						name = "Acumen Robes",
					},
					{
						itemID = 17776,
						name = "Sprightring Helm",
					},
					{
						itemID = 17777,
						name = "Relentless Chain",
					},
					{
						itemID = 17779,
						name = "Hulkstone Pauldrons",
					},
				},
				choice = true,
			},
		},
		{
			questID = 7041,
			name = "Vyletongue Corruption",
			level = 47,
			requiredLevel = 41,
			faction = "Alliance",
			startMap = {
				mapID = 1443,
				x = 0.685,
				y = 0.089,
			},
			endMap = {
				mapID = 1443,
				x = 0.685,
				y = 0.089,
			},
			objective = "Fill the Coated Cerulean Vial at the orange crystal pool in Maraudon.",
			pickup = "Talendria, Desolace",
			turnin = "Talendria, Desolace",
			rewards = {
				xp = 5250,
				items = {
					{
						itemID = 17768,
						name = "Woodseed Hoop",
					},
					{
						itemID = 17778,
						name = "Sagebrush Girdle",
					},
					{
						itemID = 17770,
						name = "Branchclaw Gauntlets",
					},
				},
				choice = true,
			},
		},
		{
			questID = 7044,
			name = "Legends of Maraudon",
			level = 49,
			requiredLevel = 41,
			faction = "Both",
			startMap = {
				mapID = 1443,
				x = 0.321,
				y = 0.64,
			},
			objective = "Recover the two parts of the Scepter of Celebras: the Celebrian Rod and the Celebrian Diamond.",
			pickup = "Cavindra, Desolace",
			turnin = "Celebras the Redeemed, inside the dungeon",
			rewards = {
				xp = 3400,
			},
		},
		{
			questID = 7046,
			name = "The Scepter of Celebras",
			level = 49,
			requiredLevel = 41,
			faction = "Both",
			objective = "Assist Celebras the Redeemed while he creates the Scepter of Celebras.",
			turnin = "Celebras the Redeemed, inside the dungeon",
			rewards = {
				xp = 5700,
				items = {
					{
						itemID = 17191,
						name = "Scepter of Celebras",
					},
				},
			},
			prerequisites = {
				{
					questID = 7044,
					name = "Legends of Maraudon",
				},
			},
		},
		{
			questID = 7065,
			name = "Corruption of Earth and Seed",
			level = 51,
			requiredLevel = 45,
			faction = "Alliance",
			startMap = {
				mapID = 1443,
				x = 0.638,
				y = 0.107,
			},
			endMap = {
				mapID = 1443,
				x = 0.638,
				y = 0.107,
			},
			objective = "Slay Princess Theradras and return to Keeper Marandis at Nijel's Point in Desolace.",
			pickup = "Keeper Marandis, Desolace",
			turnin = "Keeper Marandis, Desolace",
			rewards = {
				xp = 6100,
				items = {
					{
						itemID = 17705,
						name = "Thrash Blade",
					},
					{
						itemID = 17743,
						name = "Resurgence Rod",
					},
					{
						itemID = 17753,
						name = "Verdant Keeper's Aim",
					},
				},
				choice = true,
			},
		},
		{
			questID = 7066,
			name = "Seed of Life",
			level = 51,
			requiredLevel = 39,
			faction = "Both",
			endMap = {
				mapID = 1450,
				x = 0.362,
				y = 0.418,
			},
			objective = "Seek out Remulos in Moonglade and give him the Seed of Life.",
			turnin = "Keeper Remulos, Moonglade",
			rewards = {
				xp = 6100,
				money = 15000,
			},
		},
	},
})
