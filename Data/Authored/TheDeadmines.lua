local _, ns = ...

--[[
	The Deadmines, written by hand over the generated data.

	Facts from warcraft.wiki.gg, "Deadmines (Classic)" (CC BY-SA 4.0), put in our own words:
	run order, where each boss stands, and the mechanics worth knowing. Loot, quests and
	levels stay as generated from Forever's own data, since Forever changed some of them.
]]

ns.AmendInstance("TheDeadmines", {
	-- The map's two levels, by the names Blizzard's maps give them.
	floorNames = { "The Deadmines", "Ironclad Cove" },
	description = "Beneath Moonbrook lie the gold mines Stormwind abandoned during the First War. "
		.. "Edwin VanCleef's Defias Brotherhood has made them its stronghold, and deep inside, in a hidden "
		.. "sea cave, his crew is finishing a warship meant for Stormwind.",

	-- Inside the instance, in the order a run meets them.
	areas = { "Defias Hideout", "Mast Room", "Goblin Foundry", "Ironclad Cove" },

	bossOrder = {
		"Rhahk'Zor", "Miner Johnson", "Sneed's Shredder", "Sneed", "Gilnid",
		"Mr. Smite", "Cookie", "Captain Greenskin", "Edwin VanCleef",
	},

	bosses = {
		["Rhahk'Zor"] = {
			area = "Defias Hideout",
			notes = { "An ogre foreman with heavy armour who hits hard; the first boss inside." },
		},
		["Miner Johnson"] = {
			area = "Defias Hideout",
		},
		["Sneed's Shredder"] = {
			area = "Mast Room",
			notes = {
				"Sneed fights from inside the shredder, and climbs out when it is destroyed.",
				"The shredder ignores burning, bleeding and stun-style concussion effects.",
			},
			spellFlags = { [7399] = { "Important" }, [5141] = { "Damage" } },
		},
		["Sneed"] = {
			area = "Mast Room",
			notes = { "Steps out of his shredder once it breaks." },
		},
		["Gilnid"] = {
			area = "Goblin Foundry",
			notes = {
				"Arrives with three goblin helpers.",
				"Defeating him opens the door onward.",
			},
		},
		["Mr. Smite"] = {
			area = "Ironclad Cove",
			notes = {
				"Stomps at 75% and again at 50% health, stunning the whole party. It cannot be interrupted.",
				"Changes weapons partway through the fight.",
			},
			stages = {
				{ title = "Stage One", description = "Mr. Smite opens the fight with his first set of weapons.",
					spells = { 3391 } },
				{ title = "Stage Two: 75% Health", description = "He stomps, stunning everyone nearby, and changes weapons.",
					spells = { 6432, 6435 } },
				{ title = "Stage Three: 50% Health", description = "He stomps again and changes weapons once more." },
			},
			spellFlags = { [6432] = { "Important", "Healer" }, [6435] = { "Tank" }, [3391] = { "Tank" } },
		},
		["Cookie"] = {
			area = "Ironclad Cove",
			notes = { "The ship's cook, found aboard the juggernaut." },
		},
		["Captain Greenskin"] = {
			area = "Ironclad Cove",
			notes = { "Holds the top of the ship with two of his crew." },
		},
		["Edwin VanCleef"] = {
			area = "Ironclad Cove",
			notes = {
				"Waits in the captain's cabin at the top of the ship.",
				"Stuns, and calls his guards in when his health runs low.",
			},
			spellFlags = { [5200] = { "Damage", "Important" }, [3391] = { "Tank" } },
		},
	},
})
