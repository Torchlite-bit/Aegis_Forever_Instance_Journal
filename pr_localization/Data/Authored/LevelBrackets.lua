local _, ns = ...

-- The level dropdown on the Dungeons and Raids tabs. The first entry shows everything.
local L = ns.L
ns.LEVEL_BRACKETS = {
	{ text = L.LEVEL_ALL },
	{ text = string.format(L.LEVEL_RANGE, 1, 30), min = 1, max = 30 },
	{ text = string.format(L.LEVEL_RANGE, 30, 45), min = 30, max = 45 },
	{ text = string.format(L.LEVEL_RANGE, 45, 60), min = 45, max = 60 },
	{ text = string.format(L.MAP_LEVEL, 60), min = 60, max = 60 },
}
