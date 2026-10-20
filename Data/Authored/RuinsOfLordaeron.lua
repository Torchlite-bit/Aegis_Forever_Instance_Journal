local _, ns = ...

--[[
	Ruins of Lordaeron, written by hand over the generated data.

	From foreverchanges.pro's Ruins of Lordaeron page and quest pages (2026-10-09), read by hand,
	facts only, in our own words: the level range Blizzard gives, how each fight goes, the boss
	spots (on Santiago Reyes's map, the same picture as ours), where Captain Truman stands, the
	Horde's own Crest of Lordaeron, and where five quests are handed in. Its loot and quests
	already matched ours; the journal's earlier boss spots were off.
]]

local TRUMAN = { x = 0.624, y = 0.285, floor = 1 }
local CREST_NOTE = "The crest is not always in the same place: on the floor of a tower near Bjork, or on the wall of the "
	.. "small temple at the far end, past him, among other spots."

ns.AmendInstance("RuinsOfLordaeron", {
	levelMax = 20,

	bosses = {
		["The Baron"] = {
			notes = {
				"He hurls the tank into the air, stunned for 5 seconds: damage dealers, watch your threat, the tank holds him only about half the fight.",
				"Clear his room before the pull: a patrol walks by. His head is looted for Abominable Creatures and Unending Torment.",
			},
			mapPin = { x = 0.588, y = 0.698, floor = 1 },
		},
		["Witherfang"] = {
			notes = {
				"Nothing special on the boss itself: clear the other spiders of the courtyard first, or they join the fight.",
			},
			mapPin = { x = 0.668, y = 0.392, floor = 1 },
		},
		["The Abandoned"] = {
			notes = {
				"Clear the courtyard, click the statue and survive the waves: she comes after them.",
				"Frost Nova hits the whole group: healers, pace your mana through the waves.",
			},
			mapPin = { x = 0.410, y = 0.533, floor = 1 },
		},
		["Bjork"] = {
			notes = {
				"He knocks players back: clear the packs around him first, or you land in one.",
				"Anti-Magic Shield guards him against spells for a while, and he hits hard: keep the tank topped up.",
			},
			mapPin = { x = 0.392, y = 0.425, floor = 1 },
		},
		["Rath'mael"] = {
			notes = {
				"Flamestrike is his main spell, and he can be interrupted and stunned: plan your kicks and stuns.",
				"The longest fight of the dungeon: a large health pool, so keep the interrupts going.",
			},
			mapPin = { x = 0.458, y = 0.627, floor = 1 },
		},
		["Viktor the Vile"] = {
			notes = {
				"Clear the house and the statue, click the fireplace and survive the waves: he comes after the last flesh golem.",
				"He poisons his target and hits hard. Bring mana potions for the waves before him.",
			},
			mapPin = { x = 0.377, y = 0.648, floor = 1 },
		},
		["Lordaeron Captain"] = {
			mapPin = { x = 0.385, y = 0.250, floor = 1 },
		},
	},

	questPatches = {
		[95250] = { startInside = TRUMAN, endInside = TRUMAN, note = "Captain Truman stands just inside the entrance." },
		[95189] = {
			endMap = { mapID = 1453, x = 0.698, y = 0.286 },
			note = CREST_NOTE,
		},
		[95204] = {
			startItem = { itemID = 275521, name = "Crest of Lordaeron", note = "Not always in the same place inside Ruins of Lordaeron." },
			endMap = { mapID = 1458, x = 0.734, y = 0.324 },
			note = CREST_NOTE,
		},
		[97288] = {
			endMap = { mapID = 1458, x = 0.484, y = 0.694 },
			note = "Master Apothecary Faranell takes the head, and a second Unending Torment follows: four more steps inside the Undercity, the last back to him.",
		},
	},
})
