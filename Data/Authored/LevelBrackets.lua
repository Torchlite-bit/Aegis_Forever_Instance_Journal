local _, ns = ...

-- The level dropdown on the Dungeons and Raids tabs. The first entry shows everything.
ns.LEVEL_BRACKETS = {
	{ text = "All Levels" },
	{ text = "Level 1 to 30", min = 1, max = 30 },
	{ text = "Level 30 to 45", min = 30, max = 45 },
	{ text = "Level 45 to 60", min = 45, max = 60 },
	{ text = "Level 60", min = 60, max = 60 },
}
