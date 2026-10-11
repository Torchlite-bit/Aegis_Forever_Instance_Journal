-- Dire Maul: Gordok Commons: the journal's own data for this dungeon. Edit it by hand.
-- Bosses, levels, models, loot and quests as foreverchanges.pro lists them (2026-10-10), facts
-- only; its maps (Media/Maps/Classic), floor names and boss spots are the classic dungeon maps
-- that Advanced Dungeon Guide keeps. The bosses' abilities are added by
-- Data/Generated/Abilities.lua (Tools/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "DireMaulNorth",
	instanceID = 429,
	kind = "dungeon",
	name = "Dire Maul: Gordok Commons",
	levelMin = 56,
	levelMax = 60,
	location = "Feralas",
	description = "The northern wing, where the Gordok ogres hold court around King Gordok.",
	buttonArt = { "Interface\\Glues\\LoadingScreens\\LoadScreenDireMaul" },
	buttonImage = { "Interface\\EncounterJournal\\UI-EJ-DUNGEONBUTTON-DireMaul" },
	loreImage = { "Interface\\EncounterJournal\\UI-EJ-LOREBG-DireMaul" },
	buttonArtCoords = { 0, 1, 0.13, 0.87 },
	iconArtCoords = { 0.2, 0.8, 0.1, 0.9 },
	loreArtCoords = { 0, 1, 0.1, 0.9 },
	zoneEntrance = {
		mapID = 1444,
		world = { 1, -4550, 1416.7 },
	},
	wingAreas = {
		["Gordok Commons"] = true,
	},
	map = {
		entrance = {
			x = 0.718,
			y = 0.927,
			floor = 1,
		},
		floors = {
			{
				art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\Classic\\DireMaulNorth",
				artRight = 0.9785,
				artBottom = 0.6523,
				uiMapID = 235,
			},
		},
		transitions = {
			{
				floor = 1,
				to = 3,
				x = 0.631,
				y = 0.839,
			},
		},
	},
	bosses = {
		{
			name = "Guard Mol'dar",
			displayID = 11561,
			level = 59,
			order = 1,
			loot = {
				{
					itemID = 18494,
					name = "Denwatcher's Shoulders",
					slot = "Shoulder, Mail",
					quality = 3,
				},
				{
					itemID = 18493,
					name = "Bulky Iron Spaulders",
					slot = "Shoulder, Plate",
					quality = 3,
				},
				{
					itemID = 18496,
					name = "Heliotrope Cloak",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 18497,
					name = "Sublime Wristguards",
					slot = "Wrist, Cloth",
					quality = 3,
				},
				{
					itemID = 18498,
					name = "Hedgecutter",
					slot = "One-Hand, Axe",
					quality = 3,
				},
				{
					itemID = 18450,
					name = "Robe of Combustion",
					slot = "Chest, Cloth",
					quality = 2,
				},
				{
					itemID = 18458,
					name = "Modest Armguards",
					slot = "Wrist, Mail",
					quality = 2,
				},
				{
					itemID = 18459,
					name = "Gallant's Wristguards",
					slot = "Wrist, Plate",
					quality = 2,
				},
				{
					itemID = 18451,
					name = "Hyena Hide Belt",
					slot = "Waist, Leather",
					quality = 2,
				},
				{
					itemID = 18462,
					name = "Jagged Bone Fist",
					slot = "Main Hand, Fist Weapon",
					quality = 2,
				},
				{
					itemID = 18463,
					name = "Ogre Pocket Knife",
					slot = "One-Hand, Sword",
					quality = 2,
				},
				{
					itemID = 18464,
					name = "Gordok Nose Ring",
					slot = "Finger",
					quality = 2,
				},
				{
					itemID = 18460,
					name = "Unsophisticated Hand Cannon",
					slot = "Ranged, Gun",
					quality = 2,
				},
				{
					itemID = 18250,
					name = "Gordok Shackle Key",
					slot = "Junk",
					quality = 2,
				},
				{
					itemID = 18268,
					name = "Gordok Inner Door Key",
					slot = "Key",
					quality = 1,
				},
			},
			mapPin = {
				x = 0.694,
				y = 0.761,
				floor = 1,
			},
		},
		{
			name = "Guard Slip'kik",
			displayID = 11561,
			level = 59,
			order = 2,
			loot = {
				{
					itemID = 18494,
					name = "Denwatcher's Shoulders",
					slot = "Shoulder, Mail",
					quality = 3,
				},
				{
					itemID = 18493,
					name = "Bulky Iron Spaulders",
					slot = "Shoulder, Plate",
					quality = 3,
				},
				{
					itemID = 18496,
					name = "Heliotrope Cloak",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 18497,
					name = "Sublime Wristguards",
					slot = "Wrist, Cloth",
					quality = 3,
				},
				{
					itemID = 18498,
					name = "Hedgecutter",
					slot = "One-Hand, Axe",
					quality = 3,
				},
				{
					itemID = 18450,
					name = "Robe of Combustion",
					slot = "Chest, Cloth",
					quality = 2,
				},
				{
					itemID = 18458,
					name = "Modest Armguards",
					slot = "Wrist, Mail",
					quality = 2,
				},
				{
					itemID = 18459,
					name = "Gallant's Wristguards",
					slot = "Wrist, Plate",
					quality = 2,
				},
				{
					itemID = 18451,
					name = "Hyena Hide Belt",
					slot = "Waist, Leather",
					quality = 2,
				},
				{
					itemID = 18462,
					name = "Jagged Bone Fist",
					slot = "Main Hand, Fist Weapon",
					quality = 2,
				},
				{
					itemID = 18463,
					name = "Ogre Pocket Knife",
					slot = "One-Hand, Sword",
					quality = 2,
				},
				{
					itemID = 18464,
					name = "Gordok Nose Ring",
					slot = "Finger",
					quality = 2,
				},
				{
					itemID = 18460,
					name = "Unsophisticated Hand Cannon",
					slot = "Ranged, Gun",
					quality = 2,
				},
				{
					itemID = 18250,
					name = "Gordok Shackle Key",
					slot = "Junk",
					quality = 2,
				},
			},
			mapPin = {
				x = 0.266,
				y = 0.563,
				floor = 1,
			},
		},
		{
			name = "Captain Kromcrush",
			displayID = 11564,
			level = 61,
			order = 3,
			loot = {
				{
					itemID = 18503,
					name = "Kromcrush's Chestplate",
					slot = "Chest, Plate",
					quality = 3,
				},
				{
					itemID = 18505,
					name = "Mugger's Belt",
					slot = "Waist, Leather",
					quality = 3,
				},
				{
					itemID = 18507,
					name = "Boots of the Full Moon",
					slot = "Feet, Cloth",
					quality = 3,
				},
				{
					itemID = 18502,
					name = "Monstrous Glaive",
					slot = "Two-Hand, Polearm",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.321,
				y = 0.502,
				floor = 1,
			},
		},
		{
			name = "King Gordok",
			displayID = 11583,
			level = 62,
			order = 4,
			loot = {
				{
					itemID = 18526,
					name = "Crown of the Ogre King",
					slot = "Head, Cloth",
					quality = 3,
				},
				{
					itemID = 18525,
					name = "Bracers of Prosperity",
					slot = "Wrist, Leather",
					quality = 3,
				},
				{
					itemID = 18527,
					name = "Harmonious Gauntlets",
					slot = "Hands, Mail",
					quality = 3,
				},
				{
					itemID = 18524,
					name = "Leggings of Destruction",
					slot = "Legs, Mail",
					quality = 3,
				},
				{
					itemID = 18521,
					name = "Grimy Metal Boots",
					slot = "Feet, Plate",
					quality = 3,
				},
				{
					itemID = 18522,
					name = "Band of the Ogre King",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 18523,
					name = "Brightly Glowing Stone",
					slot = "Held In Off-hand",
					quality = 3,
				},
				{
					itemID = 18520,
					name = "Barbarous Blade",
					slot = "Two-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 19258,
					name = "Ace of Warlords",
					slot = "Quest",
					quality = 3,
				},
				{
					itemID = 18780,
					name = "Top Half of Advanced Armorsmithing: Volume I",
					slot = "Quest",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.319,
				y = 0.242,
				floor = 1,
			},
		},
		{
			name = "Stomper Kreeg",
			displayID = 11545,
			level = 59,
			order = 5,
			loot = {
				{
					itemID = 18425,
					name = "Kreeg's Mug",
					slot = "Held In Off-hand",
					quality = 2,
				},
				{
					itemID = 18269,
					name = "Gordok Green Grog",
					slot = "Other",
					quality = 2,
				},
				{
					itemID = 18284,
					name = "Kreeg's Stout Beatdown",
					slot = "Other",
					quality = 2,
				},
				{
					itemID = 18287,
					name = "Evermurky",
					slot = "Food & Drink",
					quality = 1,
				},
				{
					itemID = 18288,
					name = "Molasses Firewater",
					slot = "Food & Drink",
					quality = 1,
				},
				{
					itemID = 9260,
					name = "Volatile Rum",
					slot = "Potions",
					quality = 1,
				},
			},
			mapPin = {
				x = 0.609,
				y = 0.687,
				floor = 1,
			},
		},
		{
			name = "Guard Fengus",
			displayID = 11561,
			level = 59,
			order = 6,
			loot = {
				{
					itemID = 18450,
					name = "Robe of Combustion",
					slot = "Chest, Cloth",
					quality = 2,
				},
				{
					itemID = 18458,
					name = "Modest Armguards",
					slot = "Wrist, Mail",
					quality = 2,
				},
				{
					itemID = 18459,
					name = "Gallant's Wristguards",
					slot = "Wrist, Plate",
					quality = 2,
				},
				{
					itemID = 18451,
					name = "Hyena Hide Belt",
					slot = "Waist, Leather",
					quality = 2,
				},
				{
					itemID = 18462,
					name = "Jagged Bone Fist",
					slot = "Main Hand, Fist Weapon",
					quality = 2,
				},
				{
					itemID = 18463,
					name = "Ogre Pocket Knife",
					slot = "One-Hand, Sword",
					quality = 2,
				},
				{
					itemID = 18464,
					name = "Gordok Nose Ring",
					slot = "Finger",
					quality = 2,
				},
				{
					itemID = 18460,
					name = "Unsophisticated Hand Cannon",
					slot = "Ranged, Gun",
					quality = 2,
				},
				{
					itemID = 18250,
					name = "Gordok Shackle Key",
					slot = "Junk",
					quality = 2,
				},
				{
					itemID = 18266,
					name = "Gordok Courtyard Key",
					slot = "Key",
					quality = 1,
				},
			},
			mapPin = {
				x = 0.497,
				y = 0.78,
				floor = 1,
			},
		},
		{
			name = "Cho'Rush the Observer",
			displayID = 11537,
			level = 60,
			order = 7,
			loot = {
				{
					itemID = 18490,
					name = "Insightful Hood",
					slot = "Head, Leather",
					quality = 3,
				},
				{
					itemID = 18483,
					name = "Mana Channeling Wand",
					slot = "Ranged, Wand",
					quality = 3,
				},
				{
					itemID = 18485,
					name = "Observer's Shield",
					slot = "Off Hand, Shield",
					quality = 3,
				},
				{
					itemID = 18484,
					name = "Cho'Rush's Blade",
					slot = "One-Hand, Sword",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.319,
				y = 0.289,
				floor = 1,
			},
		},
		{
			name = "Trash Drops",
			trash = true,
			loot = {
				{
					itemID = 18250,
					name = "Gordok Shackle Key",
					slot = "Junk",
					quality = 2,
				},
				{
					itemID = 18333,
					name = "Libram of Focus",
					slot = "Book",
					quality = 2,
				},
				{
					itemID = 18334,
					name = "Libram of Protection",
					slot = "Book",
					quality = 2,
				},
				{
					itemID = 18332,
					name = "Libram of Rapidity",
					slot = "Book",
					quality = 2,
				},
				{
					itemID = 18640,
					name = "Happy Fun Rock",
					slot = "Other",
					quality = 1,
				},
				{
					itemID = 18289,
					name = "Barbed Thorn Necklace",
					slot = "Neck",
					quality = 3,
				},
				{
					itemID = 18295,
					name = "Phasing Boots",
					slot = "Feet, Cloth",
					quality = 3,
				},
				{
					itemID = 18296,
					name = "Marksman Bands",
					slot = "Wrist, Mail",
					quality = 3,
				},
				{
					itemID = 18298,
					name = "Unbridled Leggings",
					slot = "Legs, Leather",
					quality = 3,
				},
				{
					itemID = 18337,
					name = "Orphic Bracers",
					slot = "Wrist, Cloth",
					quality = 2,
				},
				{
					itemID = 18338,
					name = "Wand of Arcane Potency",
					slot = "Ranged, Wand",
					quality = 3,
				},
				{
					itemID = 18339,
					name = "Eidolon Cloak",
					slot = "Back, Cloth",
					quality = 2,
				},
				{
					itemID = 18340,
					name = "Eidolon Talisman",
					slot = "Neck",
					quality = 3,
				},
				{
					itemID = 18343,
					name = "Petrified Band",
					slot = "Finger",
					quality = 2,
				},
				{
					itemID = 18344,
					name = "Stonebark Gauntlets",
					slot = "Hands, Leather",
					quality = 3,
				},
				{
					itemID = 18354,
					name = "Pimgib's Collar",
					slot = "Trinket",
					quality = 3,
				},
				{
					itemID = 18450,
					name = "Robe of Combustion",
					slot = "Chest, Cloth",
					quality = 2,
				},
				{
					itemID = 18451,
					name = "Hyena Hide Belt",
					slot = "Waist, Leather",
					quality = 2,
				},
				{
					itemID = 18458,
					name = "Modest Armguards",
					slot = "Wrist, Mail",
					quality = 2,
				},
				{
					itemID = 18459,
					name = "Gallant's Wristguards",
					slot = "Wrist, Plate",
					quality = 2,
				},
				{
					itemID = 18460,
					name = "Unsophisticated Hand Cannon",
					slot = "Ranged, Gun",
					quality = 2,
				},
				{
					itemID = 18462,
					name = "Jagged Bone Fist",
					slot = "Main Hand, Fist Weapon",
					quality = 2,
				},
				{
					itemID = 18463,
					name = "Ogre Pocket Knife",
					slot = "One-Hand, Sword",
					quality = 2,
				},
				{
					itemID = 18464,
					name = "Gordok Nose Ring",
					slot = "Finger",
					quality = 2,
				},
				{
					itemID = 18493,
					name = "Bulky Iron Spaulders",
					slot = "Shoulder, Plate",
					quality = 3,
				},
				{
					itemID = 18494,
					name = "Denwatcher's Shoulders",
					slot = "Shoulder, Mail",
					quality = 3,
				},
				{
					itemID = 18496,
					name = "Heliotrope Cloak",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 18497,
					name = "Sublime Wristguards",
					slot = "Wrist, Cloth",
					quality = 3,
				},
				{
					itemID = 18498,
					name = "Hedgecutter",
					slot = "One-Hand, Axe",
					quality = 3,
				},
			},
		},
	},
	quests = {
		{
			questID = 7499,
			name = "Codex of Defense",
			level = 60,
			requiredLevel = 54,
			faction = "Both",
			objective = "Return the book to its rightful owners.",
			turnin = "Lorekeeper Kildrath, inside the dungeon",
			rewards = {
				xp = 6600,
				items = {
					{
						itemID = 18466,
						name = "Royal Seal of Eldre'Thalas",
					},
				},
			},
		},
		{
			questID = 7505,
			name = "Frost Shock and You",
			level = 60,
			requiredLevel = 54,
			faction = "Both",
			objective = "Return the book to its rightful owners.",
			turnin = "Lorekeeper Javon, inside the dungeon",
			rewards = {
				xp = 6600,
				items = {
					{
						itemID = 18471,
						name = "Royal Seal of Eldre'Thalas",
					},
				},
			},
		},
		{
			questID = 7498,
			name = "Garona: A Study on Stealth and Treachery",
			level = 60,
			requiredLevel = 54,
			faction = "Both",
			objective = "Return the book to its rightful owners.",
			turnin = "Lorekeeper Kildrath, inside the dungeon",
			rewards = {
				xp = 6600,
				items = {
					{
						itemID = 18465,
						name = "Royal Seal of Eldre'Thalas",
					},
				},
			},
		},
		{
			questID = 7502,
			name = "Harnessing Shadows",
			level = 60,
			requiredLevel = 54,
			faction = "Both",
			objective = "Return the book to its rightful owners.",
			turnin = "Lorekeeper Mykos, inside the dungeon",
			rewards = {
				xp = 6600,
				items = {
					{
						itemID = 18467,
						name = "Royal Seal of Eldre'Thalas",
					},
				},
			},
		},
		{
			questID = 7504,
			name = "Holy Bologna: What the Light Won't Tell You",
			level = 60,
			requiredLevel = 54,
			faction = "Both",
			objective = "Return the book to its rightful owners.",
			turnin = "Lorekeeper Javon, inside the dungeon",
			rewards = {
				xp = 6600,
				items = {
					{
						itemID = 18469,
						name = "Royal Seal of Eldre'Thalas",
					},
				},
			},
		},
		{
			questID = 7500,
			name = "The Arcanist's Cookbook",
			level = 60,
			requiredLevel = 54,
			faction = "Both",
			objective = "Return the book to its rightful owners.",
			turnin = "Lorekeeper Kildrath, inside the dungeon",
			rewards = {
				xp = 6600,
				items = {
					{
						itemID = 18468,
						name = "Royal Seal of Eldre'Thalas",
					},
				},
			},
		},
		{
			questID = 7506,
			name = "The Emerald Dream...",
			level = 60,
			requiredLevel = 54,
			faction = "Both",
			objective = "Return the book to its rightful owners.",
			turnin = "Lorekeeper Javon, inside the dungeon",
			rewards = {
				xp = 6600,
				items = {
					{
						itemID = 18470,
						name = "Royal Seal of Eldre'Thalas",
					},
				},
			},
		},
		{
			questID = 7503,
			name = "The Greatest Race of Hunters",
			level = 60,
			requiredLevel = 54,
			faction = "Both",
			objective = "Return the book to its rightful owners.",
			turnin = "Lorekeeper Mykos, inside the dungeon",
			rewards = {
				xp = 6600,
				items = {
					{
						itemID = 18473,
						name = "Royal Seal of Eldre'Thalas",
					},
				},
			},
		},
		{
			questID = 7501,
			name = "The Light and How To Swing It",
			level = 60,
			requiredLevel = 54,
			faction = "Both",
			objective = "Return the book to its rightful owners.",
			turnin = "Lorekeeper Mykos, inside the dungeon",
			rewards = {
				xp = 6600,
				items = {
					{
						itemID = 18472,
						name = "Royal Seal of Eldre'Thalas",
					},
				},
			},
		},
		{
			questID = 5518,
			name = "The Gordok Ogre Suit",
			level = 60,
			requiredLevel = 56,
			faction = "Both",
			objective = "Bring 4 Bolts of Runecloth, 8 Rugged Leather, 2 Rune Threads, and Ogre Tannin to Knot Thimblejack. He is currently chained inside the Gordok wing of Dire Maul.",
			turnin = "Knot Thimblejack, inside the dungeon",
			rewards = {
				xp = 6600,
				items = {
					{
						itemID = 18258,
						name = "Gordok Ogre Suit",
					},
				},
			},
			prerequisites = {
				{
					questID = 5519,
					name = "The Gordok Ogre Suit",
				},
			},
		},
		{
			questID = 7462,
			name = "The Treasure of the Shen'dralar",
			level = 60,
			requiredLevel = 56,
			faction = "Alliance",
			objective = "Return to the Athenaeum and find the Treasure of the Shen'dralar. Claim your reward!",
			turnin = "Treasure of the Shen'dralar, inside the dungeon",
			rewards = {
				xp = 650,
				money = 27000,
				items = {
					{
						itemID = 18420,
						name = "Bonecrusher",
					},
					{
						itemID = 18421,
						name = "Backwood Helm",
					},
					{
						itemID = 18424,
						name = "Sedge Boots",
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 7461,
					name = "The Madness Within",
				},
			},
		},
		{
			questID = 1318,
			name = "Unfinished Gordok Business",
			level = 60,
			requiredLevel = 56,
			faction = "Both",
			objective = "Find the Gauntlet of Gordok Might and return it to Captain Kromcrush in Dire Maul.",
			rewards = {
				xp = 8300,
				items = {
					{
						itemID = 18366,
						name = "Gordok's Handguards",
					},
					{
						itemID = 18367,
						name = "Gordok's Gauntlets",
					},
					{
						itemID = 18368,
						name = "Gordok's Gloves",
					},
					{
						itemID = 18369,
						name = "Gordok's Handwraps",
					},
				},
				choice = true,
			},
		},
		{
			questID = 5525,
			name = "Free Knot!",
			level = 60,
			requiredLevel = 56,
			faction = "Both",
			turnin = "Knot Thimblejack, inside the dungeon",
			rewards = {
				xp = 6600,
			},
			prerequisites = {
				{
					questID = 7429,
					name = "Free Knot!",
				},
			},
		},
		{
			questID = 5528,
			name = "The Gordok Taste Test",
			level = 60,
			requiredLevel = 56,
			faction = "Both",
			turnin = "Stomper Kreeg, inside the dungeon",
		},
		{
			questID = 8948,
			name = "Anthion's Old Friend",
			level = 60,
			requiredLevel = 58,
			faction = "Both",
			startMap = {
				mapID = 1423,
				x = 0.261,
				y = 0.113,
			},
			objective = "Take the incomplete Banner of Provocation to Falrin Treeshaper at the library in Dire Maul.",
			pickup = "Anthion Harmon, Eastern Plaguelands",
			turnin = "Falrin Treeshaper, inside the dungeon",
			rewards = {
				xp = 6600,
			},
			prerequisites = {
				{
					questID = 9022,
					name = "Warrior",
				},
			},
		},
		{
			questID = 8949,
			name = "Falrin's Vendetta",
			level = 60,
			requiredLevel = 58,
			faction = "Both",
			objective = "Collect 25 Ogre Warbeads from Ogres inside Dire Maul or Blackrock Spire and return to Falrin Treeshaper inside the Athenaeum in Dire Maul.",
			turnin = "Falrin Treeshaper, inside the dungeon",
			rewards = {
				xp = 6600,
				items = {
					{
						itemID = 22150,
						name = "Beads of Ogre Might",
					},
					{
						itemID = 22149,
						name = "Beads of Ogre Mojo",
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 9022,
					name = "Warrior",
				},
			},
		},
		{
			questID = 8950,
			name = "The Instigator's Enchantment",
			level = 60,
			requiredLevel = 58,
			faction = "Both",
			objective = "Bring the following to Falrin Treeshaper inside Dire Maul: 1 Jeering Spectre's Essence, 4 Dark Runes and 8 Large Brilliant Shards.",
			turnin = "Falrin Treeshaper, inside the dungeon",
			rewards = {
				xp = 6600,
			},
			prerequisites = {
				{
					questID = 8949,
					name = "Falrin's Vendetta",
				},
			},
		},
		{
			questID = 8967,
			name = "The Left Piece of Lord Valthalak's Amulet",
			level = 60,
			requiredLevel = 58,
			faction = "Both",
			startMap = {
				mapID = 1428,
				x = 0.323,
				y = 0.258,
			},
			endMap = {
				mapID = 1428,
				x = 0.323,
				y = 0.258,
			},
			objective = "Use the Brazier of Beckoning to summon forth the spirit of Isalien and slay her. Return to Bodley inside Blackrock Mountain with the Left Piece of Lord Valthalak's Amulet and the Brazier of Beckoning.",
			pickup = "Bodley, Burning Steppes",
			turnin = "Bodley, Burning Steppes",
			rewards = {
				xp = 8300,
			},
			prerequisites = {
				{
					questID = 8963,
					name = "Components of Importance",
				},
			},
		},
		{
			questID = 8990,
			name = "The Right Piece of Lord Valthalak's Amulet",
			level = 60,
			requiredLevel = 58,
			faction = "Both",
			startMap = {
				mapID = 1428,
				x = 0.323,
				y = 0.258,
			},
			endMap = {
				mapID = 1428,
				x = 0.323,
				y = 0.258,
			},
			objective = "Use the Brazier of Beckoning to summon forth the spirit of Isalien and slay her. Return to Bodley inside Blackrock Mountain with the recombined Lord Valthalak's Amulet and the Brazier of Beckoning.",
			pickup = "Bodley, Burning Steppes",
			turnin = "Bodley, Burning Steppes",
			rewards = {
				xp = 8300,
			},
			prerequisites = {
				{
					questID = 8970,
					name = "I See Alcaz Island In Your Future...",
				},
			},
		},
		{
			questID = 7507,
			name = "Foror's Compendium",
			level = 60,
			requiredLevel = 60,
			faction = "Both",
			objective = "Return Foror's Compendium of Dragon Slaying to the Athenaeum.",
			turnin = "Lorekeeper Lydros, inside the dungeon",
			rewards = {
				xp = 9950,
			},
		},
		{
			questID = 7508,
			name = "The Forging of Quel'Serrar",
			level = 60,
			requiredLevel = 60,
			faction = "Both",
			objective = "Give the Dull and Flat Elven Blade to Lorekeeper Lydros.",
			turnin = "Lorekeeper Lydros, inside the dungeon",
			rewards = {
				xp = 7050,
			},
			prerequisites = {
				{
					questID = 7509,
					name = "The Forging of Quel'Serrar",
				},
			},
		},
		{
			questID = 7509,
			name = "The Forging of Quel'Serrar",
			level = 60,
			requiredLevel = 60,
			faction = "Both",
			objective = "You must get Onyxia to breathe fire on the Unfired Ancient Blade. Once this is done, pick up the now Heated Ancient Blade. Be warned, a Heated Ancient Blade will not remain heated forever - time is of the essence.",
			turnin = "Lorekeeper Lydros, inside the dungeon",
			rewards = {
				xp = 9950,
				items = {
					{
						itemID = 18348,
						name = "Quel'Serrar",
					},
				},
			},
			prerequisites = {
				{
					questID = 7508,
					name = "The Forging of Quel'Serrar",
				},
			},
		},
	},
})
