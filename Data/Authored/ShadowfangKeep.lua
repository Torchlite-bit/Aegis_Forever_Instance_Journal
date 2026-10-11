local _, ns = ...

--[[
	Shadowfang Keep, written by hand over the generated data.
	Facts from warcraft.wiki.gg, "Shadowfang Keep (Classic)" (CC BY-SA 4.0), in our own words.
	Abilities come from the generated combat-log data; this file adds stages and role alerts.
]]

ns.AmendInstance("ShadowfangKeep", {
	-- The three map levels the journal shows (the client's maps 310, 316 and 315).
	floorNames = { "The Courtyard", "The Wall Walk", "Arugal's Chamber" },
	description = "Baron Silverlaine's keep above Pyrewood fell to Archmage Arugal, who summoned the worgen to "
		.. "fight the Scourge and lost control of them. Now the keep belongs to Arugal and his pack.",

	bosses = {
		["Archmage Arugal"] = {
			notes = {
				"Waits at the top of the keep and calls a Voidwalker to his side.",
				"Arugal's Curse turns a player into a worgen who attacks their own group.",
			},
			spellFlags = {
				[7588] = { "Interruptible", "Tank" },
				[7803] = { "Healer" },
				[7621] = { "Curse", "Important" },
			},
		},
		["Arugal's Voidwalker"] = {
			notes = { "Summoned by Archmage Arugal during his fight." },
		},
		["Commander Springvale"] = {
			notes = { "A fallen paladin who heals himself and shields himself from harm." },
			spellFlags = {
				[1026] = { "Interruptible", "Important" },
				[642] = { "Important" },
				[5588] = { "Magic" },
			},
		},
		["Baron Silverlaine"] = {
			spellFlags = { [7068] = { "Magic" } },
		},
		["Fenrus the Devourer"] = {
			spellFlags = { [7125] = { "Poison" } },
		},
		["Deathsworn Captain"] = {
			notes = { "A rare spawn: not every run meets him." },
		},
	},
})
