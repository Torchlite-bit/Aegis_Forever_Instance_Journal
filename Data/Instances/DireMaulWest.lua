-- Dire Maul: Capital Gardens: the journal's own data for this dungeon. Edit it by hand.
-- Bosses, levels, models, loot and quests as foreverchanges.pro lists them (2026-10-10), facts
-- only; its maps (Media/Maps/Classic), floor names and boss spots are the classic dungeon maps
-- that Advanced Dungeon Guide keeps. The bosses' abilities are added by
-- Data/Generated/Abilities.lua (Dev/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "DireMaulWest",
	instanceID = 429,
	kind = "dungeon",
	name = "Dire Maul: Capital Gardens",
	levelMin = 56,
	levelMax = 60,
	location = "Feralas",
	description = "The western wing, where the last Highborne of Eldre'Thalas keep the demon Immol'thar imprisoned to feed their magic.",
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
		["Capital Gardens"] = true,
		["Court of the Highborne"] = true,
		["Prison of Immol'thar"] = true,
	},
	map = {
		entrance = {
			x = 0.935,
			y = 0.511,
			floor = 1,
		},
		floors = {
			{
				art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\Classic\\DireMaulWest",
				artRight = 0.9785,
				artBottom = 0.6523,
				uiMapID = 236,
			},
			{
				art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\Classic\\DireMaulWest1",
				artRight = 0.9785,
				artBottom = 0.6523,
				uiMapID = 237,
			},
			{
				art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\Classic\\DireMaulWest2",
				artRight = 0.9785,
				artBottom = 0.6523,
				uiMapID = 238,
			},
		},
		transitions = {
			{
				floor = 1,
				to = 3,
				x = 0.293,
				y = 0.428,
			},
			{
				floor = 1,
				to = 2,
				x = 0.393,
				y = 0.337,
			},
			{
				floor = 2,
				to = 1,
				x = 0.564,
				y = 0.251,
			},
			{
				floor = 2,
				to = 1,
				x = 0.4,
				y = 0.122,
			},
			{
				floor = 3,
				to = 1,
				x = 0.757,
				y = 0.398,
			},
			{
				floor = 3,
				to = 1,
				x = 0.864,
				y = 0.134,
			},
		},
	},
	floorNames = { "Capital Gardens", "Court of the Highborne", "Prison of Immol'Thar" },
	bosses = {
		{
			name = "Tendris Warpwood",
			displayID = 14383,
			level = 60,
			order = 1,
			loot = {
				{
					itemID = 18393,
					name = "Warpwood Binding",
					slot = "Waist, Mail",
					quality = 3,
				},
				{
					itemID = 18390,
					name = "Tanglemoss Leggings",
					slot = "Legs, Leather",
					quality = 3,
				},
				{
					itemID = 18352,
					name = "Petrified Bark Shield",
					slot = "Off Hand, Shield",
					quality = 2,
				},
				{
					itemID = 18353,
					name = "Stoneflower Staff",
					slot = "Two-Hand, Staff",
					quality = 2,
				},
			},
			mapPin = {
				x = 0.331,
				y = 0.533,
				floor = 1,
			},
		},
		{
			name = "Magister Kalendris",
			displayID = 14384,
			level = 60,
			order = 2,
			loot = {
				{
					itemID = 18374,
					name = "Flamescarred Shoulders",
					slot = "Shoulder, Leather",
					quality = 3,
				},
				{
					itemID = 18397,
					name = "Elder Magus Pendant",
					slot = "Neck",
					quality = 3,
				},
				{
					itemID = 18371,
					name = "Mindtap Talisman",
					slot = "Trinket",
					quality = 3,
				},
				{
					itemID = 18350,
					name = "Amplifying Cloak",
					slot = "Back, Cloth",
					quality = 2,
				},
				{
					itemID = 18351,
					name = "Magically Sealed Bracers",
					slot = "Wrist, Plate",
					quality = 2,
				},
				{
					itemID = 22309,
					name = "Pattern: Big Bag of Enchantment",
					slot = "Tailoring",
					quality = 2,
				},
			},
			mapPin = {
				x = 0.339,
				y = 0.448,
				floor = 2,
			},
		},
		{
			name = "Prince Tortheldrin",
			displayID = 11256,
			level = 61,
			order = 3,
			loot = {
				{
					itemID = 18382,
					name = "Fluctuating Cloak",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 18373,
					name = "Chestplate of Tranquility",
					slot = "Chest, Leather",
					quality = 3,
				},
				{
					itemID = 18375,
					name = "Bracers of the Eclipse",
					slot = "Wrist, Leather",
					quality = 3,
				},
				{
					itemID = 18378,
					name = "Silvermoon Leggings",
					slot = "Legs, Mail",
					quality = 3,
				},
				{
					itemID = 18380,
					name = "Eldritch Reinforced Legplates",
					slot = "Legs, Plate",
					quality = 3,
				},
				{
					itemID = 18395,
					name = "Emerald Flame Ring",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 18388,
					name = "Stoneshatter",
					slot = "Ranged, Crossbow",
					quality = 3,
				},
				{
					itemID = 18396,
					name = "Mind Carver",
					slot = "Main Hand, Sword",
					quality = 3,
				},
				{
					itemID = 18376,
					name = "Timeworn Mace",
					slot = "One-Hand, Mace",
					quality = 3,
				},
				{
					itemID = 18392,
					name = "Distracting Dagger",
					slot = "Off Hand, Dagger",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.62,
				y = 0.235,
				floor = 3,
			},
		},
		{
			name = "Illyanna Ravenoak",
			displayID = 11270,
			level = 60,
			order = 4,
			loot = {
				{
					itemID = 18383,
					name = "Force Imbued Gauntlets",
					slot = "Hands, Plate",
					quality = 3,
				},
				{
					itemID = 18386,
					name = "Padre's Trousers",
					slot = "Legs, Cloth",
					quality = 3,
				},
				{
					itemID = 18349,
					name = "Gauntlets of Accuracy",
					slot = "Hands, Mail",
					quality = 2,
				},
				{
					itemID = 18347,
					name = "Well Balanced Axe",
					slot = "One-Hand, Axe",
					quality = 2,
				},
			},
			mapPin = {
				x = 0.209,
				y = 0.785,
				floor = 1,
			},
		},
		{
			name = "Tsu'zee",
			displayID = 11250,
			level = 59,
			rare = true,
			order = 5,
			loot = {
				{
					itemID = 18387,
					name = "Brightspark Gloves",
					slot = "Hands, Cloth",
					quality = 3,
				},
				{
					itemID = 18346,
					name = "Threadbare Trousers",
					slot = "Legs, Cloth",
					quality = 2,
				},
				{
					itemID = 18345,
					name = "Murmuring Ring",
					slot = "Finger",
					quality = 2,
				},
			},
			mapPin = {
				x = 0.35,
				y = 0.13,
				floor = 2,
			},
		},
		{
			name = "Immol'thar",
			displayID = 14173,
			level = 61,
			order = 6,
			loot = {
				{
					itemID = 18381,
					name = "Evil Eye Pendant",
					slot = "Neck",
					quality = 3,
				},
				{
					itemID = 18384,
					name = "Bile-etched Spaulders",
					slot = "Shoulder, Plate",
					quality = 3,
				},
				{
					itemID = 18389,
					name = "Cloak of the Cosmos",
					slot = "Back, Cloth",
					quality = 3,
				},
				{
					itemID = 18385,
					name = "Robe of Everlasting Night",
					slot = "Chest, Cloth",
					quality = 3,
				},
				{
					itemID = 18394,
					name = "Demon Howl Wristguards",
					slot = "Wrist, Mail",
					quality = 3,
				},
				{
					itemID = 18377,
					name = "Quickdraw Gloves",
					slot = "Hands, Leather",
					quality = 3,
				},
				{
					itemID = 18391,
					name = "Eyestalk Cord",
					slot = "Waist, Leather",
					quality = 3,
				},
				{
					itemID = 18379,
					name = "Odious Greaves",
					slot = "Feet, Mail",
					quality = 3,
				},
				{
					itemID = 18370,
					name = "Vigilance Charm",
					slot = "Trinket",
					quality = 3,
				},
				{
					itemID = 18372,
					name = "Blade of the New Moon",
					slot = "Main Hand, Dagger",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.351,
				y = 0.575,
				floor = 3,
			},
		},
		{
			name = "Trash Drops",
			trash = true,
			loot = {
				{
					itemID = 18340,
					name = "Eidolon Talisman",
					slot = "Neck",
					quality = 3,
				},
				{
					itemID = 18344,
					name = "Stonebark Gauntlets",
					slot = "Hands, Leather",
					quality = 3,
				},
				{
					itemID = 18338,
					name = "Wand of Arcane Potency",
					slot = "Ranged, Wand",
					quality = 3,
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
					itemID = 18339,
					name = "Eidolon Cloak",
					slot = "Back, Cloth",
					quality = 2,
				},
				{
					itemID = 18343,
					name = "Petrified Band",
					slot = "Finger",
					quality = 2,
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
			questID = 7461,
			name = "The Madness Within",
			level = 60,
			requiredLevel = 56,
			faction = "Both",
			objective = "You must destroy the guardians surrounding the 5 Pylons that power the Prison of Immol'thar. Once the Pylons have powered down, the force field surrounding Immol'thar will have dissipated.",
			turnin = "Shen'dralar Ancient, inside the dungeon",
			rewards = {
				xp = 9950,
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
