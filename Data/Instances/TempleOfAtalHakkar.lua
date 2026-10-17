-- The Temple of Atal'Hakkar: the journal's own data for this dungeon. Edit it by hand.
-- Bosses, levels, models, loot and quests as foreverchanges.pro lists them (2026-10-10), facts
-- only; its maps (Media/Maps/Classic), floor names and boss spots are the classic dungeon maps
-- that Advanced Dungeon Guide keeps. The bosses' abilities are added by
-- Data/Generated/Abilities.lua (Dev/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "TempleOfAtalHakkar",
	instanceID = 109,
	kind = "dungeon",
	name = "The Temple of Atal'Hakkar",
	levelMin = 50,
	levelMax = 60,
	location = "Swamp of Sorrows",
	description = "The temple the Atal'ai built to call their blood god Hakkar sank into the Swamp of Sorrows; his priests still try to bring him back, watched by the green dragons of Eranikus.",
	buttonArt = {
		"Interface\\Glues\\LoadingScreens\\LoadScreenSunkenTemple",
		"Interface\\Glues\\LoadingScreens\\LoadScreenTempleOfAtalHakkar",
	},
	buttonImage = {
		"Interface\\EncounterJournal\\UI-EJ-DUNGEONBUTTON-SunkenTemple",
		"Interface\\EncounterJournal\\UI-EJ-DUNGEONBUTTON-TempleOfAtalHakkar",
	},
	loreImage = {
		"Interface\\EncounterJournal\\UI-EJ-LOREBG-SunkenTemple",
		"Interface\\EncounterJournal\\UI-EJ-LOREBG-TempleOfAtalHakkar",
	},
	buttonArtCoords = { 0, 1, 0.13, 0.87 },
	iconArtCoords = { 0.2, 0.8, 0.1, 0.9 },
	loreArtCoords = { 0, 1, 0.1, 0.9 },
	zoneEntrance = {
		mapID = 1435,
		x = 0.696,
		y = 0.539,
	},
	map = {
		entrance = {
			x = 0.499,
			y = 0.107,
			floor = 1,
		},
		floors = {
			{
				art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\Classic\\TheTempleofAtalHakkar",
				artRight = 0.9785,
				artBottom = 0.6523,
				uiMapID = 220,
			},
		},
	},
	bosses = {
		{
			name = "Balcony Minibosses",
			displayID = 6701,
			level = 52,
			order = 1,
			description = "Six troll defenders on the balconies around the temple's pit: Gasher, Hukku, Loro, Mijan, Zolo and Zul'Lor. With all six dead, the way to Jammal'an opens. The pins mark where each stands.",
			together = true,
			loot = {
				{
					itemID = 10783,
					name = "Atal'ai Spaulders",
					slot = "Shoulder, Leather",
					quality = 3,
				},
				{
					itemID = 10784,
					name = "Atal'ai Breastplate",
					slot = "Chest, Mail",
					quality = 3,
				},
				{
					itemID = 10787,
					name = "Atal'ai Gloves",
					slot = "Hands, Cloth",
					quality = 3,
				},
				{
					itemID = 10788,
					name = "Atal'ai Girdle",
					slot = "Waist, Plate",
					quality = 2,
				},
				{
					itemID = 10785,
					name = "Atal'ai Leggings",
					slot = "Legs, Leather",
					quality = 2,
				},
				{
					itemID = 10786,
					name = "Atal'ai Boots",
					slot = "Feet, Mail",
					quality = 2,
				},
				{
					itemID = 20606,
					name = "Amber Voodoo Feather",
					slot = "Junk",
					quality = 1,
				},
				{
					itemID = 20607,
					name = "Blue Voodoo Feather",
					slot = "Junk",
					quality = 1,
				},
				{
					itemID = 20608,
					name = "Green Voodoo Feather",
					slot = "Junk",
					quality = 1,
				},
			},
			mapPin = {
				x = 0.55,
				y = 0.322,
				floor = 1,
			},
			mapPins = {
				{
					x = 0.55,
					y = 0.322,
					floor = 1,
				},
				{
					x = 0.604,
					y = 0.457,
					floor = 1,
				},
				{
					x = 0.552,
					y = 0.592,
					floor = 1,
				},
				{
					x = 0.449,
					y = 0.59,
					floor = 1,
				},
				{
					x = 0.396,
					y = 0.455,
					floor = 1,
				},
				{
					x = 0.451,
					y = 0.321,
					floor = 1,
				},
			},
		},
		{
			name = "Jammal'an the Prophet",
			displayID = 6708,
			level = 54,
			order = 2,
			loot = {
				{
					itemID = 10806,
					name = "Vestments of the Atal'ai Prophet",
					slot = "Chest, Cloth",
					quality = 3,
				},
				{
					itemID = 10808,
					name = "Gloves of the Atal'ai Prophet",
					slot = "Hands, Cloth",
					quality = 3,
				},
				{
					itemID = 10807,
					name = "Kilt of the Atal'ai Prophet",
					slot = "Legs, Cloth",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.762,
				y = 0.455,
				floor = 1,
			},
		},
		{
			name = "Ogom the Wretched",
			displayID = 6709,
			level = 53,
			order = 3,
			loot = {
				{
					itemID = 10805,
					name = "Eater of the Dead",
					slot = "Main Hand, Axe",
					quality = 2,
				},
				{
					itemID = 10803,
					name = "Blade of the Wretched",
					slot = "Main Hand, Sword",
					quality = 2,
				},
				{
					itemID = 10804,
					name = "Fist of the Damned",
					slot = "One-Hand, Mace",
					quality = 2,
				},
			},
			mapPin = {
				x = 0.783,
				y = 0.404,
				floor = 1,
			},
		},
		{
			name = "Weaver",
			displayID = 6375,
			level = 51,
			order = 4,
			loot = {
				{
					itemID = 12465,
					name = "Nightfall Drape",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 12466,
					name = "Dawnspire Cord",
					slot = "Waist, Cloth",
					quality = 3,
				},
				{
					itemID = 12464,
					name = "Bloodfire Talons",
					slot = "Hands, Leather",
					quality = 3,
				},
				{
					itemID = 10797,
					name = "Firebreather",
					slot = "One-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 12463,
					name = "Drakefang Butcher",
					slot = "Two-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 12243,
					name = "Smoldering Claw",
					slot = "Two-Hand, Polearm",
					quality = 3,
				},
				{
					itemID = 10795,
					name = "Drakeclaw Band",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 10796,
					name = "Drakestone",
					slot = "Held In Off-hand",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.471,
				y = 0.531,
				floor = 1,
			},
		},
		{
			name = "Morphaz",
			displayID = 7975,
			level = 52,
			order = 5,
			loot = {
				{
					itemID = 12465,
					name = "Nightfall Drape",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 12466,
					name = "Dawnspire Cord",
					slot = "Waist, Cloth",
					quality = 3,
				},
				{
					itemID = 12464,
					name = "Bloodfire Talons",
					slot = "Hands, Leather",
					quality = 3,
				},
				{
					itemID = 10797,
					name = "Firebreather",
					slot = "One-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 12463,
					name = "Drakefang Butcher",
					slot = "Two-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 12243,
					name = "Smoldering Claw",
					slot = "Two-Hand, Polearm",
					quality = 3,
				},
				{
					itemID = 10795,
					name = "Drakeclaw Band",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 10796,
					name = "Drakestone",
					slot = "Held In Off-hand",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.5,
				y = 0.871,
				floor = 1,
			},
		},
		{
			name = "Atal'alarion",
			displayID = 7873,
			level = 50,
			order = 6,
			loot = {
				{
					itemID = 10800,
					name = "Darkwater Bracers",
					slot = "Wrist, Leather",
					quality = 3,
				},
				{
					itemID = 10798,
					name = "Atal'alarion's Tusk Ring",
					slot = "Waist, Plate",
					quality = 3,
				},
				{
					itemID = 10799,
					name = "Headspike",
					slot = "Two-Hand, Polearm",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.5,
				y = 0.458,
				floor = 1,
			},
		},
		{
			name = "Spawn of Hakkar",
			displayID = 4065,
			level = 51,
			order = 7,
			loot = {
				{
					itemID = 10801,
					name = "Slitherscale Boots",
					slot = "Feet, Leather",
					quality = 3,
				},
				{
					itemID = 10802,
					name = "Wingveil Cloak",
					slot = "Back, Cloth",
					quality = 2,
				},
			},
		},
		{
			name = "Avatar of Hakkar",
			displayID = 8053,
			level = 50,
			order = 8,
			loot = {
				{
					itemID = 12462,
					name = "Embrace of the Wind Serpent",
					slot = "Chest, Cloth",
					quality = 4,
				},
				{
					itemID = 10843,
					name = "Featherskin Cape",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 10845,
					name = "Warrior's Embrace",
					slot = "Chest, Plate",
					quality = 3,
				},
				{
					itemID = 10842,
					name = "Windscale Sarong",
					slot = "Legs, Leather",
					quality = 3,
				},
				{
					itemID = 10846,
					name = "Bloodshot Greaves",
					slot = "Feet, Mail",
					quality = 3,
				},
				{
					itemID = 10838,
					name = "Might of Hakkar",
					slot = "Main Hand, Mace",
					quality = 3,
				},
				{
					itemID = 10844,
					name = "Spire of Hakkar",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.24,
				y = 0.455,
				floor = 1,
			},
		},
		{
			name = "Dreamscythe",
			displayID = 7553,
			level = 53,
			order = 9,
			loot = {
				{
					itemID = 12465,
					name = "Nightfall Drape",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 12466,
					name = "Dawnspire Cord",
					slot = "Waist, Cloth",
					quality = 3,
				},
				{
					itemID = 12464,
					name = "Bloodfire Talons",
					slot = "Hands, Leather",
					quality = 3,
				},
				{
					itemID = 10797,
					name = "Firebreather",
					slot = "One-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 12463,
					name = "Drakefang Butcher",
					slot = "Two-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 12243,
					name = "Smoldering Claw",
					slot = "Two-Hand, Polearm",
					quality = 3,
				},
				{
					itemID = 10795,
					name = "Drakeclaw Band",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 10796,
					name = "Drakestone",
					slot = "Held In Off-hand",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.446,
				y = 0.512,
				floor = 1,
			},
		},
		{
			name = "Hazzas",
			displayID = 9584,
			level = 53,
			order = 10,
			loot = {
				{
					itemID = 12465,
					name = "Nightfall Drape",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 12466,
					name = "Dawnspire Cord",
					slot = "Waist, Cloth",
					quality = 3,
				},
				{
					itemID = 12464,
					name = "Bloodfire Talons",
					slot = "Hands, Leather",
					quality = 3,
				},
				{
					itemID = 10797,
					name = "Firebreather",
					slot = "One-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 12463,
					name = "Drakefang Butcher",
					slot = "Two-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 12243,
					name = "Smoldering Claw",
					slot = "Two-Hand, Polearm",
					quality = 3,
				},
				{
					itemID = 10795,
					name = "Drakeclaw Band",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 10796,
					name = "Drakestone",
					slot = "Held In Off-hand",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.506,
				y = 0.744,
				floor = 1,
			},
		},
		{
			name = "Shade of Eranikus",
			displayID = 7806,
			level = 55,
			order = 11,
			loot = {
				{
					itemID = 10847,
					name = "Dragon's Call",
					slot = "One-Hand, Sword",
					quality = 4,
				},
				{
					itemID = 10833,
					name = "Horns of Eranikus",
					slot = "Head, Mail",
					quality = 3,
				},
				{
					itemID = 10829,
					name = "Dragon's Eye",
					slot = "Neck",
					quality = 3,
				},
				{
					itemID = 10836,
					name = "Rod of Corrosion",
					slot = "Ranged, Wand",
					quality = 3,
				},
				{
					itemID = 10835,
					name = "Crest of Supremacy",
					slot = "Off Hand, Shield",
					quality = 3,
				},
				{
					itemID = 10837,
					name = "Tooth of Eranikus",
					slot = "Main Hand, Axe",
					quality = 3,
				},
				{
					itemID = 10828,
					name = "Dire Nail",
					slot = "One-Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 10454,
					name = "Essence of Eranikus",
					slot = "Quest",
					quality = 2,
				},
			},
			mapPin = {
				x = 0.668,
				y = 0.876,
				floor = 1,
			},
		},
		{
			name = "Trash Drops",
			trash = true,
			loot = {
				{
					itemID = 10630,
					name = "Soulcatcher Halo",
					slot = "Head, Cloth",
					quality = 3,
				},
				{
					itemID = 10632,
					name = "Slimescale Bracers",
					slot = "Wrist, Mail",
					quality = 3,
				},
				{
					itemID = 10631,
					name = "Murkwater Gauntlets",
					slot = "Hands, Mail",
					quality = 3,
				},
				{
					itemID = 10633,
					name = "Silvershell Leggings",
					slot = "Legs, Plate",
					quality = 3,
				},
				{
					itemID = 10629,
					name = "Mistwalker Boots",
					slot = "Feet, Cloth",
					quality = 3,
				},
				{
					itemID = 10634,
					name = "Mindseye Circle",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 10624,
					name = "Stinging Bow",
					slot = "Ranged, Bow",
					quality = 3,
				},
				{
					itemID = 10623,
					name = "Winter's Bite",
					slot = "Main Hand, Axe",
					quality = 3,
				},
				{
					itemID = 10625,
					name = "Stealthblade",
					slot = "One-Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 10626,
					name = "Ragehammer",
					slot = "Two-Hand, Mace",
					quality = 3,
				},
				{
					itemID = 10628,
					name = "Deathblow",
					slot = "Two-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 10627,
					name = "Bludgeon of the Grinning Dog",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
				{
					itemID = 10782,
					name = "Hakkari Shroud",
					slot = "Head, Cloth",
					quality = 2,
				},
				{
					itemID = 10781,
					name = "Hakkari Breastplate",
					slot = "Chest, Leather",
					quality = 2,
				},
				{
					itemID = 10780,
					name = "Mark of Hakkar",
					slot = "Finger",
					quality = 2,
				},
				{
					itemID = 16216,
					name = "Formula: Enchant Cloak - Greater Resistance",
					slot = "Enchanting",
					quality = 2,
				},
				{
					itemID = 15733,
					name = "Pattern: Green Dragonscale Leggings",
					slot = "Leatherworking",
					quality = 3,
				},
				{
					itemID = 10783,
					name = "Atal'ai Spaulders",
					slot = "Shoulder, Leather",
					quality = 3,
				},
				{
					itemID = 10784,
					name = "Atal'ai Breastplate",
					slot = "Chest, Mail",
					quality = 3,
				},
				{
					itemID = 10785,
					name = "Atal'ai Leggings",
					slot = "Legs, Leather",
					quality = 2,
				},
				{
					itemID = 10786,
					name = "Atal'ai Boots",
					slot = "Feet, Mail",
					quality = 2,
				},
				{
					itemID = 10787,
					name = "Atal'ai Gloves",
					slot = "Hands, Cloth",
					quality = 3,
				},
				{
					itemID = 10788,
					name = "Atal'ai Girdle",
					slot = "Waist, Plate",
					quality = 2,
				},
				{
					itemID = 10795,
					name = "Drakeclaw Band",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 10796,
					name = "Drakestone",
					slot = "Held In Off-hand",
					quality = 3,
				},
				{
					itemID = 10797,
					name = "Firebreather",
					slot = "One-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 10838,
					name = "Might of Hakkar",
					slot = "Main Hand, Mace",
					quality = 3,
				},
				{
					itemID = 10842,
					name = "Windscale Sarong",
					slot = "Legs, Leather",
					quality = 3,
				},
				{
					itemID = 10843,
					name = "Featherskin Cape",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 10844,
					name = "Spire of Hakkar",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
				{
					itemID = 10845,
					name = "Warrior's Embrace",
					slot = "Chest, Plate",
					quality = 3,
				},
				{
					itemID = 10846,
					name = "Bloodshot Greaves",
					slot = "Feet, Mail",
					quality = 3,
				},
				{
					itemID = 12243,
					name = "Smoldering Claw",
					slot = "Two-Hand, Polearm",
					quality = 3,
				},
				{
					itemID = 12463,
					name = "Drakefang Butcher",
					slot = "Two-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 12464,
					name = "Bloodfire Talons",
					slot = "Hands, Leather",
					quality = 3,
				},
				{
					itemID = 12465,
					name = "Nightfall Drape",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 12466,
					name = "Dawnspire Cord",
					slot = "Waist, Cloth",
					quality = 3,
				},
			},
		},
	},
	quests = {
		{
			questID = 1446,
			name = "Jammal'an the Prophet",
			level = 53,
			requiredLevel = 38,
			faction = "Both",
			startMap = {
				mapID = 1425,
				x = 0.338,
				y = 0.752,
			},
			endMap = {
				mapID = 1425,
				x = 0.338,
				y = 0.752,
			},
			objective = "The Atal'ai Exile in The Hinterlands wants the Head of Jammal'an.",
			pickup = "Atal'ai Exile, The Hinterlands",
			turnin = "Atal'ai Exile, The Hinterlands",
			rewards = {
				xp = 6550,
				items = {
					{
						itemID = 11123,
						name = "Rainstrider Leggings",
					},
					{
						itemID = 11124,
						name = "Helm of Exile",
					},
				},
				choice = true,
			},
		},
		{
			questID = 3528,
			name = "The God Hakkar",
			level = 53,
			requiredLevel = 40,
			faction = "Both",
			startMap = {
				mapID = 1446,
				x = 0.67,
				y = 0.224,
			},
			endMap = {
				mapID = 1446,
				x = 0.67,
				y = 0.224,
			},
			objective = "Bring the Filled Egg of Hakkar to Yeh'kinya in Tanaris.",
			pickup = "Yeh'kinya, Tanaris",
			turnin = "Yeh'kinya, Tanaris",
			rewards = {
				xp = 7900,
				money = 24000,
				items = {
					{
						itemID = 10749,
						name = "Avenguard Helm",
					},
					{
						itemID = 10750,
						name = "Lifeforce Dirk",
					},
					{
						itemID = 10751,
						name = "Gemburst Circlet",
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 4787,
					name = "The Ancient Egg",
				},
			},
		},
		{
			questID = 3446,
			name = "Into the Depths",
			level = 51,
			requiredLevel = 46,
			faction = "Both",
			startMap = {
				mapID = 1446,
				x = 0.527,
				y = 0.459,
			},
			objective = "Find the Altar of Hakkar in the Sunken Temple in Swamp of Sorrows.",
			pickup = "Marvon Rivetseeker, Tanaris",
			turnin = "Altar of Hakkar, inside the dungeon",
			rewards = {
				xp = 4900,
			},
			prerequisites = {
				{
					questID = 3444,
					name = "The Stone Circle",
				},
			},
		},
		{
			questID = 3447,
			name = "Secret of the Circle",
			level = 51,
			requiredLevel = 46,
			faction = "Both",
			startMap = {
				mapID = 1446,
				x = 0.527,
				y = 0.459,
			},
			objective = "Travel into the Sunken Temple and discover the secret hidden in the circle of statues.",
			pickup = "Marvon Rivetseeker, Tanaris",
			turnin = "Idol of Hakkar, inside the dungeon",
			rewards = {
				xp = 6100,
				items = {
					{
						itemID = 10773,
						name = "Hakkari Urn",
					},
				},
			},
			prerequisites = {
				{
					questID = 3444,
					name = "The Stone Circle",
				},
			},
		},
		{
			questID = 3373,
			name = "The Essence of Eranikus",
			level = 55,
			requiredLevel = 48,
			faction = "Both",
			objective = "Place the Essence of Eranikus in the Essence Font located in this lair in the Sunken Temple.",
			turnin = "Essence Font, inside the dungeon",
			rewards = {
				xp = 2800,
				items = {
					{
						itemID = 10455,
						name = "Chained Essence of Eranikus",
					},
				},
			},
			prerequisites = {
				{
					questID = 3374,
					name = "The Essence of Eranikus",
				},
			},
		},
		{
			questID = 1475,
			name = "Into The Temple of Atal'Hakkar",
			level = 50,
			requiredLevel = 38,
			faction = "Alliance",
			startMap = {
				mapID = 1453,
				x = 0.695,
				y = 0.404,
			},
			endMap = {
				mapID = 1453,
				x = 0.695,
				y = 0.404,
			},
			objective = "Gather 10 Atal'ai Tablets for Brohann Caskbelly in Stormwind.",
			pickup = "Brohann Caskbelly, Stormwind City",
			turnin = "Brohann Caskbelly, Stormwind City",
			rewards = {
				xp = 7100,
				items = {
					{
						itemID = 1490,
						name = "Guardian Talisman",
					},
				},
			},
			prerequisites = {
				{
					questID = 1469,
					name = "Rhapsody's Tale",
				},
			},
		},
		{
			questID = 1445,
			name = "The Temple of Atal'Hakkar",
			level = 50,
			requiredLevel = 38,
			faction = "Horde",
			startMap = {
				mapID = 1435,
				x = 0.479,
				y = 0.548,
			},
			endMap = {
				mapID = 1435,
				x = 0.479,
				y = 0.548,
			},
			objective = "Collect 20 Fetishes of Hakkar and bring them to Fel'Zerul in Stonard.",
			pickup = "Fel'zerul, Swamp of Sorrows",
			turnin = "Fel'zerul, Swamp of Sorrows",
			rewards = {
				xp = 5900,
				items = {
					{
						itemID = 1490,
						name = "Guardian Talisman",
					},
				},
			},
			prerequisites = {
				{
					questID = 1444,
					name = "Return to Fel'Zerul",
				},
			},
		},
		{
			questID = 4146,
			name = "Zapper Fuel",
			level = 52,
			requiredLevel = 47,
			faction = "Horde",
			startMap = {
				mapID = 1413,
				x = 0.624,
				y = 0.387,
			},
			endMap = {
				mapID = 1449,
				x = 0.455,
				y = 0.087,
			},
			objective = "Deliver the Unloaded Zapper and 5 samples of Atal'ai Haze to Larion in Marshal's Refuge.",
			pickup = "Liv Rizzlefix, The Barrens",
			turnin = "Larion, Un'Goro Crater",
			rewards = {
				xp = 5100,
			},
			prerequisites = {
				{
					questID = 4147,
					name = "Marvon's Workshop",
				},
			},
		},
		{
			questID = 4148,
			name = "Bloodpetal Zapper",
			level = 53,
			requiredLevel = 47,
			faction = "Horde",
			startMap = {
				mapID = 1449,
				x = 0.455,
				y = 0.087,
			},
			endMap = {
				mapID = 1449,
				x = 0.455,
				y = 0.087,
			},
			pickup = "Larion, Un'Goro Crater",
			turnin = "Larion, Un'Goro Crater",
			rewards = {
				xp = 3950,
				money = 16000,
				items = {
					{
						itemID = 11320,
						name = "Bloodpetal Zapper",
					},
				},
			},
			prerequisites = {
				{
					questID = 4146,
					name = "Zapper Fuel",
				},
			},
		},
	},
})
