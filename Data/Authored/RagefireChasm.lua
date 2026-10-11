local _, ns = ...

--[[
	Ragefire Chasm, written by hand over the generated data.
	Facts from warcraft.wiki.gg, "Ragefire Chasm (Classic)" (CC BY-SA 4.0), in our own words.
]]

ns.AmendInstance("RagefireChasm", {
	description = "Beneath Orgrimmar's Cleft of Shadow runs a chasm of lava and stone where troggs, fire "
		.. "elementals and the Searing Blade, a cult of demon-worshippers, have taken root under the Horde's capital.",

	bosses = {
		["Oggleflint"] = {
			notes = { "A trogg brute on the main path; a straightforward fight if no other packs join in." },
		},
		["Taragaman the Hungerer"] = {
			notes = {
				"A felguard standing in the middle of the lava lake, and the hardest-hitting boss here.",
				"His Uppercut can throw a player back into lava or into nearby enemies.",
			},
			spellFlags = { [18072] = { "Tank", "Important" }, [11970] = { "Healer" } },
		},
		["Jergosh the Invoker"] = {
			notes = { "A Searing Blade warlock; clear the cultists around him first." },
			spellFlags = { [20800] = { "Healer", "Magic" } },
		},
		["Bazzalan"] = {
			notes = { "A satyr on the walkway above Jergosh's chamber." },
		},
	},
})
