-- Gnomeregan: the journal's own data for this dungeon. Edit it by hand.
-- Hand-written notes, fights, maps and corrections are laid over it by the files in Data/Authored;
-- foreverchanges.pro is the source to check it against. The bosses' abilities are added by
-- Data/Generated/Abilities.lua (Tools/build_data.py).

local _, ns = ...

ns.AddInstance({
	key = "Gnomeregan",
	instanceID = 90,
	kind = "dungeon",
	name = "Gnomeregan",
	levelMin = 29,
	levelMax = 38,
	location = "Dun Morogh",
	buttonArt = { "Interface\\Glues\\LoadingScreens\\LoadScreenGnomeregan" },
	buttonImage = { "Interface\\EncounterJournal\\UI-EJ-DUNGEONBUTTON-Gnomeregan" },
	loreImage = { "Interface\\EncounterJournal\\UI-EJ-LOREBG-Gnomeregan" },
	buttonArtCoords = { 0, 1, 0.13, 0.87 },
	iconArtCoords = { 0.2, 0.8, 0.1, 0.9 },
	loreArtCoords = { 0, 1, 0.1, 0.9 },
	map = {
		entrance = {
			x = 0.642,
			y = 0.278,
			floor = 1,
		},
		floors = {
			{
				uiMapID = 226,
				tiles = "Interface\\WorldMap\\Gnomeregan\\Gnomeregan1_",
			},
			{
				uiMapID = 227,
				tiles = "Interface\\WorldMap\\Gnomeregan\\Gnomeregan2_",
			},
			{
				uiMapID = 228,
				tiles = "Interface\\WorldMap\\Gnomeregan\\Gnomeregan3_",
			},
			{
				uiMapID = 229,
				tiles = "Interface\\WorldMap\\Gnomeregan\\Gnomeregan4_",
			},
		},
		transitions = {
			{
				floor = 1,
				to = 2,
				x = 0.545,
				y = 0.409,
			},
			{
				floor = 1,
				to = 2,
				x = 0.487,
				y = 0.877,
			},
			{
				floor = 2,
				to = 3,
				x = 0.435,
				y = 0.813,
			},
			{
				floor = 3,
				to = 4,
				x = 0.37,
				y = 0.72,
			},
			{
				floor = 4,
				to = 3,
				x = 0.44,
				y = 0.726,
			},
		},
	},
	zoneEntrance = {
		mapID = 1426,
		x = 0.243,
		y = 0.398,
	},
	bosses = {
		{
			name = "Grubbis",
			npcID = 7361,
			level = 32,
			description = "Fights with his pet Chomper in the trogg cave off the outer ring.",
			displayID = 144378,
			loot = {
				{
					itemID = 9445,
					name = "Grubbis Paws",
					slot = "Hands, Mail",
					quality = 3,
				},
				{
					itemID = 274043,
					name = "Irradiated Shield",
					slot = "Off Hand, Shield",
					quality = 3,
				},
				{
					itemID = 274042,
					name = "Skullduggery Belt",
					slot = "Waist, Leather",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.776,
				y = 0.671,
				floor = 1,
			},
			order = 1,
		},
		{
			name = "Viscous Fallout",
			npcID = 7079,
			level = 30,
			description = "An ooze soaked in radiation, in the Hall of Gears.",
			displayID = 5497,
			loot = {
				{
					itemID = 9452,
					name = "Hydrocane",
					slot = "Two-Hand, Staff",
					quality = 3,
				},
				{
					itemID = 9453,
					name = "Toxic Revenger",
					slot = "One-Hand, Dagger",
					quality = 3,
				},
				{
					itemID = 9454,
					name = "Acidic Walkers",
					slot = "Feet, Cloth",
					quality = 3,
				},
			},
			mapPin = {
				x = 0.76,
				y = 0.469,
				floor = 2,
			},
			order = 2,
		},
		{
			name = "Electrocutioner 6000",
			npcID = 6235,
			level = 32,
			description = "In the Engineering Labs. He drops the Workshop Key.",
			displayID = 6915,
			loot = {
				{
					itemID = 9446,
					name = "Electrocutioner Leg",
					slot = "Main Hand, Sword",
					quality = 3,
				},
				{
					itemID = 9447,
					name = "Electrocutioner Lagnut",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 9448,
					name = "Spidertank Oilrag",
					slot = "Wrist, Cloth",
					quality = 3,
				},
				{
					itemID = 6893,
				},
			},
			mapPin = {
				x = 0.245,
				y = 0.684,
				floor = 2,
			},
			order = 3,
		},
		{
			name = "Crowd Pummeler 9-60",
			npcID = 6229,
			level = 32,
			description = "Fights in the arena of the Launch Bay.",
			displayID = 6774,
			loot = {
				{
					itemID = 9449,
					name = "Manual Crowd Pummeler",
					slot = "Two-Hand, Mace",
					quality = 3,
				},
				{
					itemID = 9450,
					name = "Gnomebot Operating Boots",
					slot = "Feet, Leather",
					quality = 3,
				},
				{
					itemID = 274068,
					name = "Thermaplugg Medal of Honor",
					slot = "Neck",
					quality = 3,
				},
				{
					itemID = 274049,
				},
			},
			mapPin = {
				x = 0.434,
				y = 0.883,
				floor = 3,
			},
			order = 4,
		},
		{
			name = "Mekgineer Thermaplugg",
			npcID = 7800,
			level = 34,
			description = "The last boss, in Tinkers' Court. Press the buttons on the bomb faces to stop the walking bombs.",
			displayID = 6980,
			loot = {
				{
					itemID = 9458,
					name = "Thermaplugg's Central Core",
					slot = "Off Hand, Shield",
					quality = 3,
				},
				{
					itemID = 9459,
					name = "Thermaplugg's Left Arm",
					slot = "Two-Hand, Axe",
					quality = 3,
				},
				{
					itemID = 9461,
					name = "Charged Gear",
					slot = "Finger",
					quality = 3,
				},
				{
					itemID = 9492,
					name = "Electromagnetic Gigaflux Reactivator",
					slot = "Head, Cloth",
					quality = 3,
				},
				{
					itemID = 4415,
				},
				{
					itemID = 4413,
				},
				{
					itemID = 4411,
				},
				{
					itemID = 7742,
				},
				{
					itemID = 11828,
				},
				{
					itemID = 252514,
				},
			},
			mapPin = {
				x = 0.315,
				y = 0.299,
				floor = 4,
			},
			order = 5,
		},
		{
			name = "Dark Iron Ambassador",
			npcID = 6228,
			level = 33,
			description = "Sometimes found among the Dark Iron agents.",
			rare = true,
			displayID = 6669,
			loot = {
				{
					itemID = 9455,
					name = "Emissary Cuffs",
					slot = "Wrist, Mail",
					quality = 3,
				},
				{
					itemID = 9456,
					name = "Glass Shooter",
					slot = "Ranged, Gun",
					quality = 3,
				},
				{
					itemID = 9457,
					name = "Royal Diplomatic Scepter",
					slot = "Main Hand, Mace",
					quality = 3,
				},
			},
			order = 6,
		},
		{
			name = "Techbot",
			npcID = 6231,
			level = 26,
			displayID = 7288,
			loot = {
				{
					itemID = 9444,
				},
			},
			order = 7,
		},
		{
			name = "Trash Drops",
			trash = true,
			loot = {
				{
					itemID = 9508,
					name = "Mechbuilder's Overalls",
					slot = "Chest, Cloth",
					quality = 3,
					droppedBy = "Gnomeregan trash (rare)",
				},
				{
					itemID = 9491,
					name = "Hotshot Pilot's Gloves",
					slot = "Hands, Cloth",
					quality = 3,
					droppedBy = "Gnomeregan trash (rare)",
				},
				{
					itemID = 9509,
					name = "Petrolspill Leggings",
					slot = "Legs, Leather",
					quality = 3,
					droppedBy = "Gnomeregan trash (rare)",
				},
				{
					itemID = 9510,
					name = "Caverndeep Trudgers",
					slot = "Feet, Mail",
					quality = 3,
					droppedBy = "Gnomeregan trash (rare)",
				},
				{
					itemID = 9487,
					name = "Hi-tech Supergun",
					slot = "Ranged, Gun",
					quality = 3,
					droppedBy = "Gnomeregan trash (rare)",
				},
				{
					itemID = 9485,
					name = "Vibroblade",
					slot = "One-Hand, Axe",
					quality = 3,
					droppedBy = "Gnomeregan trash (rare)",
				},
				{
					itemID = 9488,
					name = "Oscillating Power Hammer",
					slot = "One-Hand, Mace",
					quality = 3,
					droppedBy = "Gnomeregan trash (rare)",
				},
				{
					itemID = 9486,
					name = "Supercharger Battle Axe",
					slot = "Two-Hand, Axe",
					quality = 3,
					droppedBy = "Gnomeregan trash (rare)",
				},
				{
					itemID = 9490,
					name = "Gizmotron Megachopper",
					slot = "Two-Hand, Sword",
					quality = 3,
					droppedBy = "Gnomeregan trash (rare)",
				},
				{
					itemID = 9489,
					name = "Gyromatic Icemaker",
					slot = "Ranged, Wand",
					quality = 3,
					droppedBy = "Gnomeregan trash (rare)",
				},
				{
					itemID = 11827,
				},
				{
					itemID = 9327,
				},
				{
					itemID = 7191,
				},
				{
					itemID = 9308,
				},
				{
					itemID = 9326,
				},
				{
					itemID = 9279,
				},
				{
					itemID = 9280,
				},
				{
					itemID = 9282,
				},
				{
					itemID = 9281,
				},
				{
					itemID = 9316,
				},
			},
		},
	},
	quests = {
		{
			questID = 2922,
			name = "Save Techbot's Brain!",
			level = 26,
			requiredLevel = 20,
			faction = "Alliance",
			startMap = {
				mapID = 1455,
				x = 0.69,
				y = 0.5,
				label = "Tinkmaster Overspark — Tinker Town, Ironforge",
			},
			objective = "Bring Techbot's Memory Core to Tinkmaster Overspark in Ironforge.",
			pickup = "Tinkmaster Overspark, Ironforge",
			turnin = "Tinkmaster Overspark, Ironforge",
			rewards = {
				xp = 2650,
				money = 2000,
			},
		},
		{
			questID = 2926,
			name = "Gnogaine",
			level = 27,
			requiredLevel = 20,
			faction = "Alliance",
			startMap = {
				mapID = 1426,
				x = 0.45,
				y = 0.49,
				label = "Ozzie Togglevolt — Kharanos",
			},
			objective = "Use the Empty Leaden Collection Phial on Irradiated Invaders or Irradiated Pillagers, then take the full phial back to Ozzie Togglevolt.",
			pickup = "Ozzie Togglevolt, Kharanos, Dun Morogh",
			turnin = "Ozzie Togglevolt, Kharanos, Dun Morogh",
			rewards = {
				xp = 2200,
				money = 2200,
			},
		},
		{
			questID = 2962,
			name = "The Only Cure is More Green Glow",
			level = 30,
			requiredLevel = 20,
			faction = "Alliance",
			startMap = {
				mapID = 1426,
				x = 0.45,
				y = 0.49,
				label = "Ozzie Togglevolt — Kharanos",
			},
			objective = "Bring High Potency Radioactive Fallout and the Heavy Leaden Collection Phial back to Ozzie. The fallout collapses quickly.",
			pickup = "Ozzie Togglevolt, Kharanos, Dun Morogh",
			turnin = "Ozzie Togglevolt, Kharanos, Dun Morogh",
			rewards = {
				xp = 2450,
				money = 2500,
			},
			prerequisites = {
				{
					questID = 2926,
					name = "Gnogaine",
				},
			},
		},
		{
			questID = 2928,
			name = "Gyrodrillmatic Excavationators",
			level = 30,
			requiredLevel = 20,
			faction = "Alliance",
			startMap = {
				mapID = 1453,
				x = 0.63,
				y = 0.34,
				label = "Shoni the Shilent — Dwarven District, Stormwind",
			},
			objective = "Bring twenty-four Robo-mechanical Guts to Shoni in Stormwind.",
			pickup = "Shoni the Shilent, Stormwind City",
			turnin = "Shoni the Shilent, Stormwind City",
			rewards = {
				xp = 2450,
				items = {
					{
						itemID = 9608,
						name = "Shoni's Disarming Tool",
						quality = 2,
					},
					{
						itemID = 9609,
						name = "Shilly Mitts",
						quality = 2,
					},
					{
						itemID = 270045,
						name = "Operator's Gloves",
						quality = 2,
					},
				},
				choice = true,
			},
		},
		{
			questID = 2924,
			name = "Essential Artificials",
			level = 30,
			requiredLevel = 24,
			faction = "Alliance",
			startMap = {
				mapID = 1455,
				x = 0.67,
				y = 0.46,
				label = "Klockmort Spannerspan — Tinker Town, Ironforge",
			},
			objective = "Bring 12 Essential Artificials to Klockmort Spannerspan in Ironforge.",
			pickup = "Klockmort Spannerspan, Ironforge",
			turnin = "Klockmort Spannerspan, Ironforge",
			rewards = {
				xp = 3050,
				money = 5500,
			},
		},
		{
			questID = 2930,
			name = "Data Rescue",
			level = 30,
			requiredLevel = 25,
			faction = "Alliance",
			startMap = {
				mapID = 1455,
				x = 0.69,
				y = 0.48,
				label = "Master Mechanic Castpipe — Tinker Town, Ironforge",
			},
			objective = "Bring a Prismatic Punch Card to Master Mechanic Castpipe in Ironforge.",
			pickup = "Master Mechanic Castpipe, Ironforge",
			turnin = "Master Mechanic Castpipe, Ironforge",
			rewards = {
				xp = 3650,
				money = 2500,
				items = {
					{
						itemID = 9605,
						name = "Repairman's Cape",
						quality = 2,
					},
					{
						itemID = 9604,
						name = "Mechanic's Pipehammer",
						quality = 2,
					},
				},
				choice = true,
			},
			prerequisites = {
				{
					questID = 2930001,
					name = "White Punch Card",
				},
				{
					questID = 2930002,
					name = "Yellow Punch Card (Punchograph 3005-A)",
				},
				{
					questID = 2930003,
					name = "Blue Punch Card (Punchograph 3005-B)",
				},
				{
					questID = 2930004,
					name = "Red Punch Card (Punchograph 3005-C)",
				},
				{
					questID = 2930005,
					name = "Prismatic Punch Card (Punchograph 3005-D)",
				},
			},
		},
		{
			questID = 2929,
			name = "The Grand Betrayal",
			level = 35,
			requiredLevel = 25,
			faction = "Alliance",
			startMap = {
				mapID = 1455,
				x = 0.68,
				y = 0.49,
				label = "High Tinker Mekkatorque — Tinker Town, Ironforge",
			},
			objective = "Kill Mekgineer Thermaplugg and return to High Tinker Mekkatorque.",
			pickup = "High Tinker Mekkatorque, Ironforge",
			turnin = "High Tinker Mekkatorque, Ironforge",
			rewards = {
				xp = 2750,
				money = 3500,
				items = {
					{
						itemID = 9623,
						name = "Civinad Robes",
						quality = 2,
					},
					{
						itemID = 9624,
						name = "Triprunner Dungarees",
						quality = 2,
					},
					{
						itemID = 9625,
						name = "Dual Reinforced Leggings",
						quality = 2,
					},
				},
				choice = true,
			},
		},
		{
			questID = 2843,
			name = "Gnomer-gooooone!",
			level = 35,
			requiredLevel = 20,
			faction = "Horde",
			startMap = {
				mapID = 1434,
				x = 0.28,
				y = 0.77,
				label = "Scooty — Booty Bay",
			},
			objective = "Wait for Scooty to calibrate the Goblin Transponder.",
			pickup = "Scooty, Booty Bay, Stranglethorn Vale",
			turnin = "Scooty, Booty Bay, Stranglethorn Vale",
			rewards = {
				items = {
					{
						itemID = 9173,
						name = "Goblin Transponder",
						quality = 1,
					},
				},
			},
			prerequisites = {
				{
					questID = 2841,
					name = "Rig Wars",
				},
				{
					questID = 2842,
					name = "Chief Engineer Scooty",
				},
			},
		},
		{
			questID = 2841,
			name = "Rig Wars",
			level = 35,
			requiredLevel = 25,
			faction = "Horde",
			startMap = {
				mapID = 1454,
				x = 0.76,
				y = 0.25,
				label = "Nogg — Valley of Honor, Orgrimmar",
			},
			objective = "Retrieve the Rig Blueprints and Thermaplugg's Safe Combination and bring them to Nogg in Orgrimmar.",
			pickup = "Nogg, Orgrimmar",
			turnin = "Nogg, Orgrimmar",
			rewards = {
				xp = 2750,
				items = {
					{
						itemID = 9623,
						name = "Civinad Robes",
						quality = 2,
					},
					{
						itemID = 9624,
						name = "Triprunner Dungarees",
						quality = 2,
					},
					{
						itemID = 9625,
						name = "Dual Reinforced Leggings",
						quality = 2,
					},
				},
				choice = true,
			},
		},
		{
			questID = 2904,
			name = "A Fine Mess",
			level = 30,
			requiredLevel = 24,
			faction = "Both",
			objective = "Escort Kernobee to the Clockwerk Run exit, then report to Scooty in Booty Bay.",
			pickup = "Kernobee, inside Gnomeregan",
			turnin = "Scooty, Booty Bay, Stranglethorn Vale",
			rewards = {
				xp = 2450,
				items = {
					{
						itemID = 9535,
						name = "Fire-welded Bracers",
						quality = 2,
					},
					{
						itemID = 9536,
						name = "Fairywing Mantle",
						quality = 2,
					},
					{
						itemID = 270042,
						name = "Technician's Bracers",
						quality = 2,
					},
				},
				choice = true,
			},
		},
		{
			questID = 2951,
			name = "The Sparklematic 5200!",
			level = 30,
			requiredLevel = 25,
			faction = "Both",
			objective = "Insert a Grime-Encrusted Object into the Sparklematic 5200, with three silver coins to start the machine.",
			pickup = "The Sparklematic 5200, inside Gnomeregan",
			turnin = "The Sparklematic 5200, inside Gnomeregan",
			rewards = {
				items = {
					{
						itemID = 9363,
						name = "Sparklematic-Wrapped Box",
						quality = 1,
					},
				},
			},
		},
		{
			questID = 2948,
			name = "Gnome Improvement",
			level = 35,
			requiredLevel = 28,
			faction = "Alliance",
			startMap = {
				mapID = 1455,
				x = 0.357,
				y = 0.04,
				label = "Talvash del Kissel — Mystic Ward, Ironforge",
			},
			objective = "Bring the Brilliant Gold Ring, a Silver Bar, a Moss Agate, and 30 silver coins to Talvash del Kissel in Ironforge.",
			pickup = "Talvash del Kissel, Mystic Ward, Ironforge",
			turnin = "Talvash del Kissel, Mystic Ward, Ironforge",
			rewards = {
				xp = 2750,
				items = {
					{
						itemID = 9538,
						name = "Talvash's Gold Ring",
						quality = 3,
					},
				},
			},
			prerequisites = {
				{
					questID = 2945,
					name = "Grime-Encrusted Ring",
				},
				{
					questID = 2947,
					name = "Return of the Ring",
				},
			},
		},
		{
			questID = 2950,
			name = "Nogg's Ring Redo",
			level = 35,
			requiredLevel = 28,
			faction = "Horde",
			startMap = {
				mapID = 1454,
				x = 0.76,
				y = 0.25,
				label = "Nogg — Valley of Honor, Orgrimmar",
			},
			objective = "Bring the Brilliant Gold Ring, a Silver Bar, a Moss Agate, and 30 silver coins to Nogg in Orgrimmar.",
			pickup = "Nogg, Valley of Honor, Orgrimmar",
			turnin = "Nogg, Valley of Honor, Orgrimmar",
			rewards = {
				xp = 2750,
				items = {
					{
						itemID = 9588,
						name = "Nogg's Gold Ring",
						quality = 3,
					},
				},
			},
			prerequisites = {
				{
					questID = 2945,
					name = "Grime-Encrusted Ring",
				},
				{
					questID = 2949,
					name = "Return of the Ring",
				},
			},
		},
	},
})
