local _, ns = ...

--[[
	The Hall of Thanes, written by hand over the generated data.

	From foreverchanges.pro's Hall of Thanes page and quest pages (2026-10-09), read by hand,
	facts only, in our own words: how each fight goes, what the vaults hold, where the quests
	start and end (zone positions, in the client's own map frame: they match ours wherever both
	have one), and where two of them start inside, on Santiago Reyes's map, the same picture as
	ours. Its loot and quests already matched ours.
]]

local MAGNI = { mapID = 1455, x = 0.394, y = 0.558 }
local GHOSTLY_ATTENDANT = { x = 0.400, y = 0.638, floor = 1 }

ns.AmendInstance("HallOfThanes", {
	bosses = {
		["Faldrim Anvilmar"] = {
			notes = {
				"Curses and diseases: bring a way to remove them. Otherwise an easy fight; clear the room before the pull.",
			},
		},
		["Magmatus"] = {
			-- His model, as foreverchanges.pro gives it.
			displayID = 1070,
			notes = {
				"Kill the Dark Iron Summoner first: he keeps bringing adds. Then turn on the elemental.",
				"His fire hits the whole group, and harder the more of you fight in melee.",
			},
		},
		["Plunder"] = {
			notes = {
				"He knocks players across the room: clear the packs nearest him, and tank him by the tunnel so nobody lands in another pack.",
			},
		},
		["Durgen Dirgehammer"] = {
			notes = {
				"At low health he fears the whole group: clear the room first, and bring a way to break fear.",
				"After the fight, open the room's vaults: about 24 Dwarven Heirlooms for Important Heirlooms, and the stone tablet that starts The Treaty of Understanding.",
			},
		},
	},

	questPatches = {
		[96395] = { startInside = GHOSTLY_ATTENDANT, endInside = GHOSTLY_ATTENDANT },
		[96403] = {
			startMap = { mapID = 1455, x = 0.324, y = 0.448 },
			note = "The vaults in Durgen Dirgehammer's room hold about 24 Dwarven Heirlooms: open them after the fight.",
		},
		[96394] = { startMap = { mapID = 1455, x = 0.330, y = 0.480 } },
		[96393] = { startMap = { mapID = 1426, x = 0.648, y = 0.584 }, endMap = MAGNI },
		[98423] = {
			startInside = { x = 0.546, y = 0.169, floor = 1 },
			endMap = MAGNI,
			note = "The stone tablet is behind the vault door in Durgen Dirgehammer's room, easy to walk past on the way to the lever that leads out.",
		},
	},
})
