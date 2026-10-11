local _, ns = ...

--[[
	Forever's announced dungeons that no source covers yet: placeholders with what Blizzard has
	said about them (level range, place, setting), marked untested. Their bosses, loot, map and
	entrance arrive as runs are recorded with the Record tab, or as the sources catch up.

	Facts from the dungeon announcements as summarised by classicwow.gg ("World of Warcraft:
	Forever Dungeons") and Warcraft Tavern ("Dungeons - WoW Forever"), in our own words.

	Each ends with a "coming soon" box and our Discord link, for anyone who records a run.
]]

local function Placeholder(instance)
	instance.kind = "dungeon"
	instance.untested = true
	instance.forever = true
	ns.AddInstance(instance)
end

Placeholder({
	key = "TheDrownedCity",
	name = "The Drowned City",
	levelMin = 35, levelMax = 40,
	location = "Coast of Stranglethorn Vale",
	description = "A troll city that sank into the ocean long ago has risen again, and naga, pirates and stranger "
		.. "things from the deep have claimed its streets.",
	bosses = {
		{ name = "Zul'Alai", order = 1 },
		{ name = "Zin'aka", order = 2 },
		{ name = "Deathless Marrow", order = 3 },
		{ name = "Min'loth the Serpent", order = 4 },
	},
})

Placeholder({
	key = "KroldokStronghold",
	name = "Krol'dok Stronghold",
	levelMin = 40, levelMax = 45,
	location = "Riverglades",
	description = "An ogre stronghold packed with warriors, where the Twilight's Hammer has found willing allies.",
})

Placeholder({
	key = "AlcazPrison",
	name = "Alcaz Prison",
	levelMin = 48, levelMax = 53,
	location = "Alcaz Island, Dustwallow Marsh",
	description = "The prison on Alcaz Island still holds Defias Brotherhood inmates, but naga have taken the island "
		.. "and made the prison their own.",
})

Placeholder({
	key = "BlackmawHold",
	name = "Blackmaw Hold",
	levelMin = 55, levelMax = 60,
	location = "Northern Azshara",
	description = "Behind the furbolg gates in the far north of Azshara lies one of the largest furbolg dens, and "
		.. "something is corrupting it from the depths.",
})

Placeholder({
	key = "ShapersTerrace",
	name = "Shaper's Terrace",
	levelMin = 58, levelMax = 60,
	location = "Un'Goro Crater",
	description = "A titan site hidden in Un'Goro Crater, guarding secrets of the makers among the crater's dinosaurs.",
})
