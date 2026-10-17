-- The raids, before they open in WoW: Forever: the journal's own data. Edit it by hand.
-- Placeholders (comingSoon): what is known now, and our Discord for anyone who records a run.
-- Their pictures are Media/Raids (made by Dev/make_raid_art.py from Art/Raids).

local _, ns = ...

local ART = "Interface\\AddOns\\Aegis_Forever_Instance_Journal\\Media\\Raids\\"

-- The pictures are 2:1: cut to the grid button's shape, a square for the icon, and the
-- overview's frame.
local function Raid(instance)
	instance.kind = "raid"
	instance.comingSoon = true
	instance.buttonArt = ART .. instance.picture
	instance.picture = nil
	instance.buttonArtCoords = { 0.047, 0.953, 0, 1 }
	instance.iconArtCoords = instance.iconArtCoords or { 0.25, 0.75, 0, 1 }
	instance.loreArtCoords = { 0.083, 0.917, 0, 1 }
	ns.AddInstance(instance)
end

Raid({
	key = "BarrowDeeps",
	name = "Barrow Deeps",
	picture = "BarrowDeeps",
	forever = true,
	description = "A raid new in WoW: Forever. Its bosses and loot are not known yet.",
})

Raid({
	key = "HyjalSummit",
	name = "Hyjal Summit",
	picture = "HyjalSummit",
	forever = true,
	location = "Mount Hyjal",
	description = "A raid new in WoW: Forever, on Mount Hyjal. Its bosses and loot are not known yet.",
})

Raid({
	key = "OnyxiasLair",
	name = "Onyxia's Lair",
	picture = "OnyxiasLair",
	-- Her head is on the left of the picture.
	iconArtCoords = { 0.05, 0.55, 0, 1 },
	instanceID = 249,
	levelMin = 60, levelMax = 60,
	location = "Dustwallow Marsh",
	-- Its door, as the game's own data places it (foreverchanges.pro's world map).
	zoneEntrance = { mapID = 1445, world = { 1, -4698.1, -3720.6 } },
	description = "The broodmother of the black dragonflight waits in her lair beneath the Wyrmbog. "
		.. "Forever's version is not known yet.",
	bosses = {
		{ name = "Onyxia", npcID = 10184, displayID = 8570, level = 63, order = 1 },
	},
})
