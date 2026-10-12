-- Ruins of Lordaeron: the journal's own data for this dungeon. Edit it by hand.
-- Hand-written notes, fights, maps and corrections are laid over it by the files in Data/Authored;
-- foreverchanges.pro is the source to check it against. The bosses' abilities are added by
-- Data/Generated/Abilities.lua (Tools/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "RuinsOfLordaeron",
	instanceID = 2999,
	kind = "dungeon",
	forever = true,
	name = "Ruins of Lordaeron",
	levelMin = 15,
	levelMax = 22,
	location = "The ruined city of Lordaeron",
	description = "The Scourge still holds the ruins of the old capital, where a necromancer is building his strength.",
	buttonArt = 7963782,
	map = {
		entrance = {
			x = 0.612,
			y = 0.214,
			floor = 1,
		},
		floors = {
			{
				art = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Maps\\RuinsOfLordaeron",
				artBottom = 0.667,
			},
		},
	},
	zoneEntrance = {
		mapID = 1420,
		x = 0.634,
		y = 0.674,
	},
	bosses = {
		{
			name = "The Baron",
			npcID = 250660,
			aliases = { "The Baron", "The Butcher" },
			level = 17,
			displayID = 144188,
			loot = {
				{
					itemID = 271204,
					name = "Meathook Slicer",
					slot = "One-Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 271205,
					name = "Abomination Bones",
					slot = "Chest, Mail",
					quality = 3,
				},
				{
					itemID = 271206,
					name = "Leftover Abomination Skin",
					slot = "Chest, Cloth",
					quality = 3,
				},
				{
					itemID = 280438,
				},
			},
			mapPin = {
				x = 0.615,
				y = 0.65,
				floor = 1,
			},
			order = 1,
		},
		{
			name = "Witherfang",
			npcID = 250483,
			level = 17,
			displayID = 144189,
			loot = {
				{
					itemID = 271201,
					name = "Atrophic Girdle",
					slot = "Waist, Mail",
					quality = 3,
				},
				{
					itemID = 271202,
					name = "Witherbite Bracers",
					slot = "Wrist, Leather",
					quality = 3,
				},
				{
					itemID = 271203,
					name = "Segmented Spider Leg",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
				{
					itemID = 275443,
				},
			},
			mapPin = {
				x = 0.668,
				y = 0.36,
				floor = 1,
			},
			order = 2,
		},
		{
			name = "The Abandoned",
			npcID = 250631,
			level = 18,
			displayID = 138667,
			loot = {
				{
					itemID = 271207,
					name = "Rotmender's Leggings",
					slot = "Legs, Cloth",
					quality = 3,
				},
				{
					itemID = 271208,
					name = "Grip of Fear",
					slot = "Hands, Mail",
					quality = 3,
				},
				{
					itemID = 271216,
					name = "Scepter of the Abandoned",
					slot = "Main Hand, Mace",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.395,
				y = 0.665,
				floor = 1,
			},
			order = 3,
		},
		{
			name = "Bjork",
			npcID = 256097,
			level = 19,
			displayID = 144170,
			loot = {
				{
					itemID = 271209,
					name = "Bonerust Leggings",
					slot = "Legs, Mail",
					quality = 3,
				},
				{
					itemID = 271210,
					name = "Tuskwrap Belt",
					slot = "Waist, Cloth",
					quality = 3,
				},
				{
					itemID = 271217,
					name = "Corpse Chopper",
					slot = "Two-Hand, Axe",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.345,
				y = 0.22,
				floor = 1,
			},
			order = 4,
		},
		{
			name = "Rath'mael",
			npcID = 250657,
			aliases = { "Rath'mael", "Rath’mael" },
			level = 20,
			displayID = 144175,
			loot = {
				{
					itemID = 271213,
					name = "Mirror of Rath'mael",
					slot = "Off Hand, Shield",
					quality = 3,
				},
				{
					itemID = 271214,
					name = "Rotmender's Treads",
					slot = "Feet, Cloth",
					quality = 3,
				},
				{
					itemID = 271215,
					name = "Coldspire Staff",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
				{
					itemID = 273085,
					name = "Blueprint: Fermenter",
					slot = "Blueprint",
					quality = 2,
				},
				{
					itemID = 273103,
					name = "Blueprint: Arcane Salvager",
					slot = "Blueprint",
					quality = 2,
				},
			},
			mapPin = {
				x = 0.52,
				y = 0.6,
				floor = 1,
			},
			order = 5,
		},
		{
			name = "Viktor the Vile",
			npcID = 256035,
			level = 19,
			displayID = 139455,
			loot = {
				{
					itemID = 271211,
					name = "Vilewalkers",
					slot = "Feet, Mail",
					quality = 3,
				},
				{
					itemID = 271212,
					name = "Bloodied Chestwraps",
					slot = "Chest, Leather",
					quality = 3,
				},
				{
					itemID = 271218,
					name = "Vileblood Scimitar",
					slot = "One-Hand, Sword",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.6,
				y = 0.73,
				floor = 1,
			},
			order = 6,
		},
		{
			name = "Lordaeron Captain",
			level = 19,
			rare = true,
			loot = {
				{
					itemID = 6641,
					name = "Haunting Blade",
					slot = "Two-Hand, Sword",
					quality = 3,
				},
				{
					itemID = 6642,
					name = "Phantom Armor",
					slot = "Chest, Mail",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.5,
				y = 0.3,
				floor = 1,
			},
			order = 7,
		},
		{
			name = "Trash Drops",
			trash = true,
			loot = {
				{
					itemID = 286981,
					name = "Death Bindings",
					slot = "Wrist, Mail",
					quality = 3,
					droppedBy = "Skeleton / Skeletal Soldier / Skeletal Mage / Fallen Necromancer",
				},
				{
					itemID = 286977,
					name = "Sword of the Fallen",
					slot = "Two-Hand, Sword",
					quality = 3,
					droppedBy = "Tattered Ghoul",
				},
				{
					itemID = 286978,
					name = "Rotmender's Garb",
					slot = "Chest, Cloth",
					quality = 3,
					droppedBy = "Flesh Golem",
				},
				{
					itemID = 286979,
					name = "Rotmender's Gloves",
					slot = "Hands, Cloth",
					quality = 3,
					droppedBy = "Stone Watcher",
				},
				{
					itemID = 286980,
					name = "Rotmender's Sash",
					slot = "Waist, Cloth",
					quality = 3,
					droppedBy = "Shrieking Banshee",
				},
			},
		},
	},
	quests = {
		{
			questID = 95250,
			name = "Abominable Creatures",
			level = 21,
			requiredLevel = 16,
			faction = "Alliance",
			objective = "Collect the Head of the Baron in Ruins of Lordaeron.",
			pickup = "Captain Truman, just inside Ruins of Lordaeron (left of the entrance)",
			turnin = "Captain Truman, just inside Ruins of Lordaeron",
			rewards = {
				xp = 1650,
				items = {
					{
						itemID = 279864,
						name = "Monstrous Cleaver",
						quality = 3,
					},
					{
						itemID = 279865,
						name = "Grave Shroud",
						quality = 3,
					},
					{
						itemID = 279867,
						name = "Slain Baron's Signet",
						quality = 3,
					},
				},
				choice = true,
				text = "Choose: Monstrous Cleaver, Grave Shroud or Slain Baron's Signet\n6,188 XP",
			},
		},
		{
			questID = 97288,
			name = "Unending Torment",
			level = 21,
			requiredLevel = 16,
			faction = "Horde",
			objective = "Deliver the Abominable Head to the Undercity.",
			pickup = "Item start: Abominable Head, inside Ruins of Lordaeron",
			turnin = "Master Apothecary Faranell, Undercity",
			rewards = {
				xp = 1650,
				items = {
					{
						itemID = 279864,
						name = "Monstrous Cleaver",
						quality = 3,
					},
					{
						itemID = 279865,
						name = "Grave Shroud",
						quality = 3,
					},
					{
						itemID = 279867,
						name = "Slain Baron's Signet",
						quality = 3,
					},
				},
				choice = true,
				header = "Chain reward — follow-up",
				text = "5,300 XP",
			},
			startItem = {
				itemID = 280438,
				name = "Abominable Head",
				note = "Dropped by: The Baron",
			},
		},
		{
			questID = 92401,
			name = "A Frightened Request",
			level = 22,
			requiredLevel = 15,
			faction = "Horde",
			startMap = {
				mapID = 1421,
				x = 0.445,
				y = 0.43,
				label = "Tabitha Heartweaver — The Sepulcher",
			},
			objective = "Investigate the disappearance of Edward Heartweaver in Ruins of Lordaeron.",
			pickup = "Tabitha Heartweaver, Silverpine Forest / The Sepulcher",
			turnin = "Tabitha Heartweaver, The Sepulcher, Silverpine Forest",
			rewards = {
				xp = 2200,
				reputation = {
					{
						faction = "Undercity",
						amount = 150,
					},
				},
				items = {
					{
						itemID = 251485,
						name = "Edward's Knife",
						quality = 3,
					},
					{
						itemID = 251486,
						name = "Tabitha's Cuffs",
						quality = 3,
					},
				},
				choice = true,
				text = "Choose: Edwards' Knife or Tabitha's Cuffs\n7,040 XP • Undercity +150",
			},
		},
		{
			questID = 95195,
			name = "Bloodied Insignia",
			level = 22,
			requiredLevel = 16,
			faction = "Alliance",
			objective = "Collect 10 Bloodied Insignias.",
			pickup = "Item start: Bloodied Insignia, inside Ruins of Lordaeron",
			turnin = "General Marcus Jonathan, Stormwind City",
			rewards = {
				xp = 2600,
				money = 4500,
				items = {
					{
						itemID = 279868,
						name = "Duty Bound Leggings",
						quality = 3,
					},
					{
						itemID = 279869,
						name = "Remembrance Armor",
						quality = 3,
					},
				},
				choice = true,
				text = "Choose: Duty Bound Leggings or Remembrance Armor\n9,750 XP • 45s",
			},
			startItem = {
				itemID = 268535,
				name = "Bloodied Insignia",
				note = "Dropped by: undead enemies inside Ruins of Lordaeron",
			},
		},
		{
			questID = 95189,
			name = "Crest of Lordaeron",
			level = 22,
			requiredLevel = 16,
			faction = "Alliance",
			objective = "Return the Crest of Lordaeron to Stormwind.",
			pickup = "Item start: Crest of Lordaeron, inside Ruins of Lordaeron",
			turnin = "Lady Dena Kennedy, Stormwind City",
			rewards = {
				xp = 2600,
				items = {
					{
						itemID = 280567,
						name = "Small Sack of Gems",
						quality = 1,
					},
				},
				text = "Small Sack of Gems\n9,750 XP",
			},
			startItem = {
				itemID = 268579,
				name = "Crest of Lordaeron",
				note = "Reported random spawn inside Ruins of Lordaeron; check towers, side rooms and the Bjork area",
			},
		},
		{
			questID = 95204,
			name = "Crest of Lordaeron",
			level = 22,
			requiredLevel = 16,
			faction = "Horde",
			objective = "Bring the Crest of Lordaeron to the Undercity.",
			pickup = "Item start: Crest of Lordaeron, inside Ruins of Lordaeron",
			turnin = "Oran Snakewrithe, Undercity",
			rewards = {
				xp = 2600,
				items = {
					{
						itemID = 280567,
						name = "Small Sack of Gems",
						quality = 1,
					},
				},
				text = "Small Sack of Gems\n8,320 XP",
			},
			startItem = {
				itemID = 268579,
				name = "Crest of Lordaeron",
				note = "Reported random spawn inside Ruins of Lordaeron; check towers, side rooms and the Bjork area",
			},
		},
		{
			questID = 92421,
			name = "Light's Justice",
			level = 22,
			requiredLevel = 15,
			faction = "Horde",
			startMap = {
				mapID = 1458,
				x = 0.579,
				y = 0.895,
				label = "Morbin Lightbane — Royal Quarter",
			},
			objective = "Collect 25 Intact Limbs within Ruins of Lordaeron.",
			pickup = "Morbin Lightbane, Undercity",
			turnin = "Morbin Lightbane, Undercity",
			rewards = {
				xp = 2200,
				money = 4500,
				reputation = {
					{
						faction = "Undercity",
						amount = 150,
					},
				},
				items = {
					{
						itemID = 279874,
						name = "The Stitcher",
						quality = 3,
					},
					{
						itemID = 279875,
						name = "Spare Part Bindings",
						quality = 3,
					},
				},
				choice = true,
				text = "Choose: The Stitcher or Spare Part Bindings\n7,040 XP • 45s • Undercity +150",
			},
		},
		{
			questID = 92415,
			name = "Remember That I Love You",
			level = 22,
			requiredLevel = 15,
			faction = "Alliance",
			objective = "Bring the Blood-Stained Letter to Orphan Matron Nightingale.",
			pickup = "Item start: Blood-Stained Letter, graveyard inside Ruins of Lordaeron",
			turnin = "Orphan Matron Nightingale, Stormwind City",
			note = "Starts from the Blood-Stained Letter.",
			rewards = {
				xp = 2600,
				items = {
					{
						itemID = 279870,
						name = "Tarnished Locket",
						quality = 3,
					},
				},
				text = "Tarnished Locket\n9,750 XP",
			},
			startItem = {
				itemID = 251522,
				name = "Blood-Stained Letter",
				note = "Found in the graveyard inside Ruins of Lordaeron",
			},
		},
		{
			questID = 95216,
			name = "The New Plague",
			level = 22,
			requiredLevel = 16,
			faction = "Horde",
			startMap = {
				mapID = 1458,
				x = 0.465,
				y = 0.716,
				label = "Theodore Griffs — Apothecarium",
			},
			objective = "Collect the Highly Toxic Strain from Witherfang.",
			pickup = "Theodore Griffs, Undercity",
			turnin = "Theodore Griffs, Undercity",
			rewards = {
				xp = 2600,
				items = {
					{
						itemID = 279876,
						name = "Plaguefang",
						quality = 3,
					},
					{
						itemID = 279877,
						name = "Blight Gloves",
						quality = 3,
					},
				},
				choice = true,
				text = "Choose: Plaguefang or Blight Gloves\n8,320 XP",
			},
		},
		{
			questID = 92422,
			name = "The Wrath of Rath'mael",
			level = 22,
			requiredLevel = 15,
			faction = "Horde",
			startMap = {
				mapID = 1420,
				x = 0.652,
				y = 0.602,
				label = "Deathguard Kristof — southeast of Brill",
			},
			objective = "Kill Rath'mael in Ruins of Lordaeron.",
			pickup = "Deathguard Kristof, Brill, Tirisfal Glades",
			turnin = "Deathguard Kristof, Brill",
			rewards = {
				xp = 0,
				reputation = {
					{
						faction = "Undercity",
						amount = 150,
					},
				},
				items = {
					{
						itemID = 251533,
						name = "Forsaken Greataxe",
						quality = 3,
					},
					{
						itemID = 251534,
						name = "Gnarled Necromancer's Staff",
						quality = 3,
					},
				},
				choice = true,
				text = "Choose: Forsaken Greataxe or Gnarled Necromancer's Staff\n0 XP • Undercity +150",
			},
		},
	},
})
