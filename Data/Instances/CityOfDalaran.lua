-- City of Dalaran: the journal's own data for this dungeon. Edit it by hand.
-- Hand-written notes, fights, maps and corrections are laid over it by the files in Data/Authored;
-- foreverchanges.pro is the source to check it against. The bosses' abilities are added by
-- Data/Generated/Abilities.lua (Tools/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "CityOfDalaran",
	instanceID = 2959,
	kind = "dungeon",
	forever = true,
	name = "City of Dalaran",
	levelMin = 28,
	levelMax = 33,
	location = "Alterac Mountains",
	buttonArt = 7963775,
	map = {
		entrance = {
			x = 0.19,
			y = 0.838,
			floor = 1,
		},
		transitions = {
			{
				floor = 1,
				to = 2,
				x = 0.778,
				y = 0.564,
			},
		},
	},
	zoneEntrance = {
		mapID = 1416,
		x = 0.085,
		y = 0.593,
	},
	bosses = {
		{
			name = "Atrexis the Grave Knight",
			npcID = 247126,
			level = 29,
			description = "At the ritual circle in the Underbelly, among Kirin Tor Necromancers and rising skeletons. He disarms his target.",
			displayID = 145787,
			loot = {
				{
					itemID = 273032,
					name = "Bonebinder's Signet",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 273036,
					name = "Graveweave Bindings",
					slot = "Wrist, Cloth",
					quality = 3,
				},
				{
					itemID = 273033,
					name = "Gravespike Repeater",
					slot = "Ranged, Crossbow",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.535,
				y = 0.505,
				floor = 1,
			},
			order = 1,
		},
		{
			name = "Arcane Anomaly",
			npcID = 245999,
			level = 30,
			description = "On a round terrace in the city streets, just out of the sewers. It casts Arcane Bolt and Focal Blast.",
			displayID = 129891,
			loot = {
				{
					itemID = 273034,
					name = "Ephemeral Grips",
					slot = "Hands, Cloth",
					quality = 3,
				},
				{
					itemID = 273031,
					name = "Runemender's Seal",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 273035,
					name = "Mana-Warped Chain Shirt",
					slot = "Chest, Mail",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.527,
				y = 0.843,
				floor = 2,
			},
			order = 2,
		},
		{
			name = "Fel Ancient",
			npcID = 246003,
			level = 32,
			description = "A treant twisted by fel magic, among the Suffused Treants in the streets.",
			displayID = 129894,
			loot = {
				{
					itemID = 273037,
					name = "Felbough Arm",
					slot = "Two-Hand, Polearm",
					quality = 3,
				},
				{
					itemID = 273039,
					name = "Blightleaf Rope",
					slot = "Waist, Cloth",
					quality = 3,
				},
				{
					itemID = 273038,
					name = "Garb of Fallen Felbark",
					slot = "Chest, Leather",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.513,
				y = 0.549,
				floor = 2,
			},
			order = 3,
		},
		{
			name = "Unstable Sentinel",
			npcID = 246017,
			level = 31,
			description = "An arcane golem by the Magus Commerce Exchange, guarded by Angry Tomes. Its Malfunction hits everyone within 25 yards.",
			displayID = 129954,
			loot = {
				{
					itemID = 273046,
					name = "Guardian's Dualblade",
					slot = "Weapon",
					quality = 3,
				},
				{
					itemID = 273047,
					name = "Unstable Crystalline Shoulderpads",
					slot = "Shoulder",
					quality = 3,
				},
				{
					itemID = 273048,
					name = "Refractory Scaleguards",
					slot = "Legs, Mail",
					quality = 3,
				},
				{
					itemID = 273099,
					name = "Blueprint: Spinning Wheel",
					slot = "Blueprint",
					quality = 2,
				},
			},
			mapPin = {
				x = 0.614,
				y = 0.413,
				floor = 2,
			},
			order = 4,
		},
		{
			name = "Mana Devourer",
			npcID = 246008,
			level = 31,
			displayID = 129895,
			loot = {
				{
					itemID = 273041,
					name = "Slitherwrap Girdle",
					slot = "Waist, Leather",
					quality = 3,
				},
				{
					itemID = 273040,
					name = "Spine of the Devourer",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
				{
					itemID = 273042,
					name = "Manascale Treads",
					slot = "Feet, Mail",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.416,
				y = 0.73,
				floor = 2,
			},
			order = 5,
		},
		{
			name = "Arcanic Enigma",
			npcID = 246016,
			aliases = { "Arcanic Enigma", "Mana Elemental" },
			level = 30,
			displayID = 129900,
			loot = {
				{
					itemID = 273045,
					name = "Drape of Shifting Energy",
					slot = "Back",
					quality = 3,
				},
				{
					itemID = 273044,
					name = "Violet Sorcerer's Robes",
					slot = "Chest, Cloth",
					quality = 3,
				},
				{
					itemID = 273043,
					name = "Wand of Mana Concentration",
					slot = "Ranged, Wand",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.669,
				y = 0.503,
				floor = 2,
			},
			order = 6,
		},
		{
			name = "Lyn the Ignored",
			npcID = 247032,
			description = "A hidden elite you summon yourself.",
			rare = true,
			displayID = 130235,
			loot = {
				{
					itemID = 273055,
					name = "Bonepile Gaze",
					slot = "Off Hand, Shield",
					quality = 3,
				},
				{
					itemID = 273054,
					name = "Cartilage Shapers",
					slot = "Hands, Leather",
					quality = 3,
				},
				{
					itemID = 273053,
					name = "Tendonscraper Dagger",
					slot = "Main Hand, Dagger",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.68,
				y = 0.177,
				floor = 1,
			},
			order = 7,
		},
		{
			name = "Shade of the Archmage",
			npcID = 246020,
			level = 33,
			description = "The last boss, in the Purple Parlor of the Violet Citadel.",
			displayID = 130061,
			loot = {
				{
					itemID = 273052,
					name = "Ponderous Orb",
					slot = "Held In Off-hand",
					quality = 3,
				},
				{
					itemID = 273049,
					name = "Archmagister's Faceted Pendant",
					slot = "Neck",
					quality = 3,
				},
				{
					itemID = 273051,
					name = "Violet Sorcerer's Mantle",
					slot = "Shoulder, Cloth",
					quality = 3,
				},
				{
					itemID = 273103,
				},
			},
			mapPin = {
				x = 0.52,
				y = 0.24,
				floor = 2,
			},
			order = 8,
		},
	},
	quests = {
		{
			questID = 92456,
			name = "A Green Sample",
			level = 33,
			requiredLevel = 24,
			faction = "Alliance",
			startMap = {
				mapID = 1453,
				x = 0.314,
				y = 0.628,
				label = "Shylamiir — Stormwind City",
			},
			objective = "Retrieve a Fel Infused Blossom from Dalaran's central garden.",
			pickup = "Shylamiir, Stormwind City",
			turnin = "Shylamiir, Stormwind City",
			rewards = {
				xp = 3950,
				items = {
					{
						itemID = 279835,
						name = "Vine Pruner's Cloak",
						quality = 3,
					},
					{
						itemID = 279836,
						name = "Thorn Protecting Girdle",
						quality = 3,
					},
				},
				choice = true,
			},
		},
		{
			questID = 92489,
			name = "Power Overwhelming",
			level = 33,
			requiredLevel = 24,
			faction = "Alliance",
			startMap = {
				mapID = 1453,
				x = 0.488,
				y = 0.876,
				label = "High Sorcerer Andromath — Stormwind City",
			},
			objective = "Slay Arcanic Enigma, the Mana Elemental in the City of Dalaran, and return to High Sorcerer Andromath in Stormwind City.",
			pickup = "High Sorcerer Andromath, Stormwind City",
			turnin = "High Sorcerer Andromath, Stormwind City",
			rewards = {
				xp = 3950,
				money = 10000,
				items = {
					{
						itemID = 251962,
						name = "Violet Sash",
						quality = 3,
					},
					{
						itemID = 279849,
						name = "Runebound Gloves",
						quality = 3,
					},
				},
				choice = true,
			},
		},
		{
			questID = 92457,
			name = "Starving Arcane",
			level = 33,
			requiredLevel = 24,
			faction = "Alliance",
			startMap = {
				mapID = 1416,
				x = 0.092,
				y = 0.6,
				label = "Image of Archmage Modera — Lordamere Lake near Dalaran",
			},
			objective = "Defeat 8 Seeking Remnants, 8 Saturated Remnants, and 8 Mana Echoes inside the City of Dalaran for Archmage Modera outside of Dalaran.",
			pickup = "Image of Archmage Modera, Lordamere Lake near Dalaran",
			turnin = "Image of Archmage Modera, Lordamere Lake near Dalaran",
			note = "One run may not have enough of these creatures to finish it.",
			rewards = {
				xp = 9400,
				reputation = {
					{
						faction = "Kirin Tor",
						amount = 100,
					},
				},
				items = {
					{
						itemID = 279837,
						name = "Fallen Guard's Pendant",
						quality = 3,
					},
					{
						itemID = 279838,
						name = "Arcane Infused Rod",
						quality = 3,
					},
				},
				choice = true,
			},
		},
		{
			questID = 92458,
			name = "Heart of Disruption",
			level = 33,
			requiredLevel = 30,
			faction = "Alliance",
			startMap = {
				mapID = 1416,
				x = 0.092,
				y = 0.6,
				label = "Image of Archmage Modera — Lordamere Lake",
			},
			objective = "Collect the Arcane Mote for the Image of Archmage Modera near the City of Dalaran.",
			pickup = "Image of Archmage Modera, Lordamere Lake near Dalaran",
			turnin = "Image of Archmage Modera, Lordamere Lake near Dalaran",
			rewards = {
				xp = 9400,
				reputation = {
					{
						faction = "Kirin Tor",
						amount = 100,
					},
				},
				items = {
					{
						itemID = 279839,
						name = "Spellguard Pauldrons",
						quality = 3,
					},
					{
						itemID = 279840,
						name = "Renewing Footpads",
						quality = 3,
					},
					{
						itemID = 279841,
						name = "Defender of Dalaran",
						quality = 3,
					},
				},
				choice = true,
			},
		},
		{
			questID = 96984,
			name = "Heart of Disruption",
			level = 33,
			requiredLevel = 30,
			faction = "Horde",
			startMap = {
				mapID = 1416,
				x = 0.092,
				y = 0.6,
				label = "Image of Archmage Modera — Lordamere Lake near Dalaran",
			},
			objective = "Collect the Arcane Mote in the City of Dalaran for Magus Wordeen Voidglare in Tarren Mill.",
			pickup = "Image of Archmage Modera, Lordamere Lake near Dalaran",
			turnin = "Magus Wordeen Voidglare, Tarren Mill, Hillsbrad Foothills",
			rewards = {
				xp = 9400,
				items = {
					{
						itemID = 279842,
						name = "Battle Spaulders",
						quality = 3,
					},
					{
						itemID = 279843,
						name = "Enchanted Sandals",
						quality = 3,
					},
					{
						itemID = 279844,
						name = "Striking Staff",
						quality = 3,
					},
				},
				choice = true,
			},
		},
		{
			questID = 96987,
			name = "Opportunistic Education",
			level = 33,
			requiredLevel = 24,
			faction = "Horde",
			objective = "Recover The Founding of Dalaran and deliver it to Rexxie Copperclutch.",
			pickup = "Rexxie Copperclutch, inside the dungeon, near the sewer entrance",
			turnin = "Rexxie Copperclutch, inside the dungeon, near the sewer entrance",
			rewards = {
				xp = 3950,
				items = {
					{
						itemID = 279845,
						name = "Item 279845",
						quality = 3,
					},
					{
						itemID = 279846,
						name = "Item 279846",
						quality = 3,
					},
				},
				choice = true,
			},
		},
		{
			questID = 96988,
			name = "Source of Power",
			level = 33,
			requiredLevel = 24,
			faction = "Horde",
			startMap = {
				mapID = 1458,
				x = 0.466,
				y = 0.741,
				label = "Doctor Martin Felben — Undercity",
			},
			objective = "Collect 6 Cracked Sentry Cores from the constructs in Dalaran.",
			pickup = "Doctor Martin Felben, Undercity",
			turnin = "Doctor Martin Felben, Undercity",
			rewards = {
				xp = 3950,
				items = {
					{
						itemID = 279847,
						name = "Unstable Power Core",
						quality = 3,
					},
					{
						itemID = 279848,
						name = "Construct Cloak",
						quality = 3,
					},
				},
				choice = true,
			},
		},
		{
			questID = 96986,
			name = "The Grave Knight",
			level = 33,
			requiredLevel = 24,
			faction = "Horde",
			startMap = {
				mapID = 1424,
				x = 0.626,
				y = 0.206,
				label = "Melisara — Tarren Mill",
			},
			objective = "Defeat Atrexis the Grave Knight in the Dalaran Underbelly.",
			pickup = "Melisara, Tarren Mill, Hillsbrad Foothills",
			turnin = "Melisara, Tarren Mill, Hillsbrad Foothills",
			rewards = {
				xp = 3950,
				money = 10000,
				items = {
					{
						itemID = 251963,
						name = "Gravewalker Boots",
						quality = 3,
					},
					{
						itemID = 251965,
						name = "Undead Knight's Bracers",
						quality = 3,
					},
				},
				choice = true,
			},
		},
	},
})
