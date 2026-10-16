local _, ns = ...

--[[
	The classic dungeons, checked against foreverchanges.pro (2026-10-09): its pages for Ragefire
	Chasm, Wailing Caverns, the Deadmines, Shadowfang Keep, Blackfathom Deeps, the Stockade,
	Gnomeregan, Razorfen Kraul and the Scarlet Monastery's Graveyard and Library, and their
	quest pages, read page by page in the browser: facts only, in our own words.

	From it, laid over the generated and hand-written data (this file loads after them):
	  levels      the level ranges Blizzard gives, where ours differed
	  notes       how each fight goes, added after the notes the boss already has
	              (replaceNotes where the site corrects one)
	  loot        drops players have seen that our sources lacked, added to the boss (or to
	              the dungeon's trash); their names are in ItemNames.lua
	  quests      where quests are handed in, the quests our data lacked, and one chain fixed

	Its maps, floors and boss spots are set in Data/Authored/ClassicMaps.lua. Where the site and
	ours disagree on a quest giver's place, ours is kept: the site puts the ones inside Ironforge
	on the Dun Morogh map.
]]

local function Update(key, spec)
	local instance = ns.GetInstance(key)
	if not instance then return end
	if spec.levelMin then instance.levelMin = spec.levelMin end
	if spec.levelMax then instance.levelMax = spec.levelMax end

	local byName, trash = {}, nil
	for _, boss in ipairs(instance.bosses) do
		if boss.trash then trash = trash or boss else byName[boss.name] = boss end
	end
	local function AddLoot(boss, items)
		local have = {}
		for _, row in ipairs(boss.loot) do have[row.itemID] = true end
		for _, itemID in ipairs(items or {}) do
			if not have[itemID] then
				boss.loot[#boss.loot + 1] = { itemID = itemID }
				have[itemID] = true
			end
		end
	end
	for name, patch in pairs(spec.bosses or {}) do
		local boss = byName[name]
		assert(boss, "FromForeverChanges: " .. key .. " has no boss named " .. name)
		if patch.replaceNotes or not boss.notes then boss.notes = {} end
		for _, note in ipairs(patch.notes or {}) do boss.notes[#boss.notes + 1] = note end
		if patch.level then boss.level = patch.level end
		if patch.displayID then boss.displayID = patch.displayID end
		AddLoot(boss, patch.loot)
	end
	if spec.trash then
		if not trash then
			trash = { name = "Trash Drops", trash = true, loot = {} }
			instance.bosses[#instance.bosses + 1] = trash
		end
		AddLoot(trash, spec.trash)
	end
	if spec.questPatches or spec.addQuests then
		ns.AmendInstance(key, { questPatches = spec.questPatches, addQuests = spec.addQuests })
	end
end

Update("RagefireChasm", {
	bosses = {
		["Oggleflint"] = { notes = { "His Cleave also hits the player nearest his target: stand apart from the tank." } },
		["Taragaman the Hungerer"] = { notes = { "Fire Nova burns everyone near him several times a fight: healers, keep the melee topped up." } },
		["Jergosh the Invoker"] = {
			notes = { "Interrupt his Immolate or dispel the burn. A mage or a druid can remove his Curse of Weakness." },
		},
		["Bazzalan"] = { notes = { "His blows poison: cure it if you can. Sinister Strike adds damage on the tank." } },
	},
	questPatches = {
		[5724] = { endMap = { mapID = 1456, x = 0.701, y = 0.295 } },
	},
	addQuests = {
		{
			questID = 5730, name = "Hidden Enemies", level = 16, requiredLevel = 9, faction = "Horde",
			pickup = "Neeru Fireblade, Cleft of Shadow, Orgrimmar", turnin = "Thrall, Grommash Hold, Orgrimmar",
			startMap = { mapID = 1454, x = 0.495, y = 0.506 }, endMap = { mapID = 1454, x = 0.317, y = 0.378 },
			objective = "Tell Thrall in Orgrimmar what you have learned.",
			note = "The last step of the Hidden Enemies chain.",
			prerequisites = { { questID = 5728, name = "Hidden Enemies" }, { questID = 5729, name = "Hidden Enemies" } },
		},
	},
})

Update("WailingCaverns", {
	levelMin = 17,
	bosses = {
		["Lord Cobrahn"] = {
			notes = { "Interrupt his Lightning Bolt and Healing Touch. Below 30% health his serpent form hits harder and puts players to sleep." },
			loot = { 253908, 252778 },
		},
		["Lady Anacondra"] = {
			notes = { "She appears at one of four places. Interrupt her Healing Touch; damage or a magic dispel wakes a sleeping player, and her Thorns Aura hurts melee." },
		},
		["Kresh"] = { notes = { "Shell Shield: for 12 seconds he takes much less damage, and hits slower but harder." } },
		["Lord Pythas"] = { notes = { "Interrupt his Healing Touch. Thunderclap slows everyone near him." }, loot = { 253938 } },
		["Skum"] = { notes = { "Interrupt his Chained Bolt, which jumps to a second player." }, loot = { 253944 } },
		["Lord Serpentis"] = { notes = { "Interrupt his slow Healing Touch and his Lightning Bolt." } },
		["Verdan the Everliving"] = {
			notes = { "When his target is close he knocks down and roots everyone near him: ranged players, keep your distance." },
			loot = { 253938 },
		},
		["Mutanus the Devourer"] = { notes = { "Thundercrack stuns everyone near him; he also puts players to sleep and fears them." } },
	},
	questPatches = {
		[6981] = { endMap = { mapID = 1413, x = 0.482, y = 0.328 } },
	},
	addQuests = {
		{
			questID = 3369, name = "In Nightmares", level = 25, requiredLevel = 10, faction = "Horde",
			pickup = "Falla Sagewind, The Barrens", turnin = "Arch Druid Hamuul Runetotem, Elder Rise, Thunder Bluff",
			startMap = { mapID = 1413, x = 0.482, y = 0.328 }, endMap = { mapID = 1456, x = 0.786, y = 0.286 },
			objective = "Take the Nightmare Shard to Hamuul Runetotem on the Elder Rise.",
			prerequisites = { { questID = 6981, name = "The Glowing Shard" } },
		},
		{
			questID = 3370, name = "In Nightmares", level = 25, requiredLevel = 10, faction = "Alliance",
			pickup = "Falla Sagewind, The Barrens", turnin = "Mathrengyl Bearwalker, Darnassus",
			startMap = { mapID = 1413, x = 0.482, y = 0.328 }, endMap = { mapID = 1457, x = 0.354, y = 0.084 },
			objective = "Take the Nightmare Shard to Mathrengyl Bearwalker in Darnassus.",
			prerequisites = { { questID = 6981, name = "The Glowing Shard" } },
		},
	},
})

Update("TheDeadmines", {
	bosses = {
		["Rhahk'Zor"] = { notes = { "His Slam stuns the tank for 3 seconds." }, loot = { 251363 } },
		["Miner Johnson"] = {
			notes = { "A rare. He cuts the tank's armour by three quarters, and at 15% health runs for help: finish him first." },
		},
		["Sneed"] = { notes = { "He disarms the tank." } },
		["Sneed's Shredder"] = { notes = { "It fears a player and slows another's casting." } },
		["Gilnid"] = { notes = { "Interrupt his Molten Metal, which burns and slows." } },
		["Mr. Smite"] = {
			replaceNotes = true,
			notes = {
				"At 66% and again at 33% health he stomps, stunning everyone around him, then walks to his chest to change weapons.",
				"With two axes he strikes the tank extra times; with the hammer, below 33%, he stuns the tank.",
			},
		},
		["Captain Greenskin"] = { notes = { "Cure the poison of his harpoon; his Cleave hits beside the tank." } },
		["Edwin VanCleef"] = { loot = { 253940 } },
		["Cookie"] = {
			notes = { "Acid Splash hurts everyone near him over time. Interrupt his heal below half health; at 15% he runs for help." },
		},
	},
	trash = { 1943, 1930, 1944, 1945, 1925 },
	questPatches = {
		[92753] = {
			startMap = { mapID = 1436, x = 0.524, y = 0.530 },
			endMap = { mapID = 1436, x = 0.386, y = 0.836 },
			-- Its follow-up and itself were listed among the steps before it, which kept it locked.
			prerequisites = {
				{ questID = 92742, name = "Testing the Wells" },
				{ questID = 92744, name = "Murloc Gills" },
				{ questID = 92745, name = "The State of the Mines" },
				{ questID = 92747, name = "Moonbrook Espionage" },
				{ questID = 92748, name = "Explosive Consultation" },
				{ questID = 92749, name = "A Dynamite Plan" },
				{ questID = 92750, name = "Detonation at a Distance" },
				{ questID = 92751, name = "Detonation at a Distance" },
				{ questID = 92752, name = "Explosive Consultation" },
			},
			note = "Alba Fairmoon gives it at Sentinel Hill at the end of her chain, after a trip to Stormwind for ten Coarse "
				.. "Dynamite for Sprite Jumpsprocket. The forge is in the foundry, where Gilnid is fought; she then waits at the "
				.. "dungeon's exit with the detonator.",
		},
	},
	addQuests = {
		{
			questID = 92819, name = "Destruction in Deadmines", level = 18, requiredLevel = 9, faction = "Alliance",
			pickup = "Alba Fairmoon, at the Deadmines' exit", turnin = "Alba Fairmoon, at the Deadmines' exit",
			startMap = { mapID = 1436, x = 0.386, y = 0.836 },
			objective = "Use the detonator.",
			prerequisites = { { questID = 92753, name = "Destruction in Deadmines" } },
		},
	},
})

Update("ShadowfangKeep", {
	levelMin = 22,
	bosses = {
		["Rethilgore"] = { notes = { "Interrupt or dispel his Soul Drain, which roots a player and drains their health." } },
		["Fel Steed / Shadow Charger"] = { notes = { "Only the Fel Steed stomps: a 3-second stun, and more physical damage taken." } },
		["Razorclaw the Butcher"] = { notes = { "He drains mana from his target: a tank who uses mana feels it." }, loot = { 273096 } },
		["Baron Silverlaine"] = { notes = { "Remove his Veil of Shadow, above all from the tank: healing on them is much weaker." } },
		["Commander Springvale"] = { notes = { "Interrupt his Holy Light. Divine Shield makes him immune for 10 seconds, and he stuns with Hammer of Justice." } },
		["Odo the Blindwatcher"] = {
			notes = { "When pulled he calls everything within 30 yards: clear around him first. He hits harder at 60%, 40% and 20% health." },
		},
		["Deathsworn Captain"] = { notes = { "He cleaves, and slows his target." } },
		["Arugal's Voidwalker"] = {
			replaceNotes = true,
			notes = { "Four come once Fenrus the Devourer dies, called by Arugal. They heal each other: bring them down one at a time." },
		},
		["Fenrus the Devourer"] = { notes = { "Cure his poison, which also drains mana." } },
		["Wolf Master Nandos"] = { notes = { "The longer the fight, the more worgs join him: kill him quickly." } },
		["Archmage Arugal"] = {
			level = 26,
			notes = { "Interrupt his Void Bolt. He teleports between his ledges, and stuns everyone around him when the tank reaches him." },
		},
	},
})

Update("BlackfathomDeeps", {
	bosses = {
		["Ghamoo-ra"] = { notes = { "He tramples everyone standing close." } },
		["Lady Sarevess"] = { notes = { "Stay out of her Forked Lightning cone. Frost Nova freezes everyone near her, and she slows a player." } },
		["Gelihast"] = { notes = { "He nets a player in place." }, loot = { 252512, 252515, 252456, 252513, 252514 } },
		["Lorgus Jett"] = {
			notes = { "He can be at one of four places. A priest or a shaman can remove his Lightning Shield; interrupt his Lightning Bolt." },
			loot = { 252455, 252513, 252820, 252512 },
		},
		["Baron Aquanis"] = {
			notes = { "Click the Fathom Stone in the water and he rises from it. He casts Frostbolt from range, and Frost Nova roots those near him." },
			loot = { 252822 },
		},
		["Twilight Lord Kelris"] = {
			notes = { "He puts everyone near him to sleep (damage wakes a sleeper), and casts Mind Blast." },
			loot = { 252456, 252513, 252455, 252515 },
		},
		["Old Serra'kis"] = {
			notes = { "He waits in an underwater cave below Twilight Lord Kelris's temple: swim under the temple to find him." },
			loot = { 252455, 252820, 252456 },
		},
		["Aku'mai"] = {
			notes = {
				"Once Kelris is dead, light the four Fires of Aku'mai one after another; each brings a wave, and the door opens when all are dead.",
				"Poison Cloud hurts everyone nearby, and below 30% health he attacks much faster.",
			},
			loot = { 252455, 252512, 252515, 252820, 252456, 252514 },
		},
	},
	questPatches = {
		[1200] = { endMap = { mapID = 1457, x = 0.562, y = 0.244 } },
		[6564] = { endMap = { mapID = 1440, x = 0.116, y = 0.343 } },
	},
})

Update("TheStockade", {
	bosses = {
		["Targorr the Dread"] = {
			notes = { "Below 30% health he attacks faster for the rest of the fight." },
		},
		["Kam Deepfury"] = {
			notes = { "Shield Slam stuns the tank; at 15% health he runs for help." },
			loot = { 252515, 252455, 252512, 252513 },
		},
		["Hamhock"] = {
			notes = { "Interrupt his Chain Lightning. A priest or a shaman can remove his Bloodlust." },
			loot = { 252513, 252822 },
		},
		["Dextren Ward"] = {
			loot = { 252514, 252515, 252512, 252456 },
		},
		["Bazil Thredd"] = {
			notes = { "His Smoke Bomb stuns everyone near him; at 15% health he runs for help." },
			loot = { 252822, 252455, 252456, 252515 },
		},
		["Bruegal Ironknuckle"] = {
			replaceNotes = true,
			notes = { "A rare spawn: not every run meets him. At 15% health he runs for help." },
		},
	},
})

Update("Gnomeregan", {
	bosses = {
		["Techbot"] = { notes = { "It roots everyone near it, slows and stuns, and calls Dupe Bugs that its Patch turns into healing." } },
		["Grubbis"] = {
			notes = { "Speak to Blastmaster Emi Shortfuse and protect her while she seals the two cave mouths: troggs come in waves, then Grubbis with Chomper." },
		},
		["Electrocutioner 6000"] = {
			notes = { "Megavolt hits a cone in front of it: only the tank should stand there. Interrupt its Chain Bolt." },
			loot = { 252822 },
		},
		["Crowd Pummeler 9-60"] = {
			notes = { "Crowd Pummel hits and interrupts everyone near it: casters and healers, keep away. It also smashes in a cone and tramples." },
		},
		["Dark Iron Ambassador"] = {
			notes = { "A rare. He calls two Burning Servants; interrupt his Fireball, and a priest or a shaman can remove his fire shield." },
			loot = { 252820 },
		},
		["Mekgineer Thermaplugg"] = {
			notes = {
				"He switches on the gnome faces around the room one by one, each sending out Walking Bombs: press the button beside a face to switch it off.",
				"Below half health the faces come faster, and his Knock Away hits everyone around him.",
			},
		},
	},
	questPatches = {
		[2945] = { startItem = { itemID = 9326, name = "Grime-Encrusted Ring" } },
		[2904] = { endMap = { mapID = 1434, x = 0.276, y = 0.775 } },
		[2947] = { endMap = { mapID = 1455, x = 0.357, y = 0.040 } },
		[2949] = { endMap = { mapID = 1454, x = 0.760, y = 0.254 } },
	},
})

Update("RazorfenKraul", {
	bosses = {
		["Aggem Thorncurse"] = {
			notes = { "He summons a Boar Spirit every 30 to 45 seconds: kill each before the next comes. Below 75% health, interrupt his Chain Heal." },
			loot = { 252512, 252455, 252822 },
		},
		["Death Speaker Jargba"] = {
			notes = { "Interrupt or dispel his Dominate Mind, which takes over a player; interrupt his Shadow Bolt." },
			loot = { 252822, 252512, 252515 },
		},
		["Roogug"] = { notes = { "A Stone Rumbler fights at his side; interrupt his Lightning Bolt." }, loot = { 252512 } },
		["Overlord Ramtusk"] = {
			notes = { "He calls everything within 15 yards, his two Razorfen Spearhides among them: crowd-control one. Thunderclap every 8 to 14 seconds slows those near him." },
			loot = { 252512, 252822, 252513, 252515 },
		},
		["Razorfen Spearhide"] = {
			notes = { "It whirls at everyone close, and its thorns hurt whoever strikes it or an ally nearby, Ramtusk included." },
		},
		["Agathelos the Raging"] = {
			notes = {
				"A ward seals his cave: kill the two Death's Head Ward Keepers in front of it to bring it down.",
				"He leaves a player for dead (moving ends it), stuns everyone near him, and enrages at 60% and again at 40% health.",
			},
			loot = { 252455, 252820, 252512, 252513 },
		},
		["Blind Hunter"] = { notes = { "A rare bat in a small recess of the bat cave near Charlga Razorflank: not every run meets it." } },
		["Charlga Razorflank"] = {
			notes = { "Interrupt her Chain Bolt. Every so often she is immune for 2 seconds, and a priest or a shaman can remove her Renew." },
			loot = { 252515, 252455, 252456, 252512 },
		},
		["Earthcaller Halmgar"] = {
			notes = { "A rare. A Stone Rumbler fights with him; interrupt his Lightning Bolt, and finish him before he runs for help at 15% health." },
			loot = { 252455, 252514 },
		},
	},
	trash = { 3569 },
	questPatches = {
		[1142] = { endMap = { mapID = 1457, x = 0.695, y = 0.678 } },
	},
})

local GRAVEYARD_RARES = "About one run in three, one of the graveyard's three rares stands at one of six places: Azshir the "
	.. "Sleepless, the Fallen Champion or Ironspine."

Update("ScarletMonasteryGraveyard", {
	bosses = {
		["Interrogator Vishas"] = { notes = { "A magic dispel removes his Shadow Word: Pain." }, loot = { 252822, 252455 } },
		["Azshir the Sleepless"] = {
			notes = { GRAVEYARD_RARES, "A mage or a druid can remove his Call of the Grave before it goes off. He fears, and drains two players below half health." },
			loot = { 252512 },
		},
		["Fallen Champion"] = {
			notes = { GRAVEYARD_RARES, "He cleaves, and strikes hard at a target below 20% health: keep the tank above it." },
			loot = { 252820 },
		},
		["Ironspine"] = {
			notes = { GRAVEYARD_RARES, "His Curse of Weakness reaches everyone within 30 yards (a mage or a druid can remove it), and he leaves a poison cloud." },
			loot = { 252820 },
		},
		["Bloodmage Thalnos"] = {
			notes = { "Step out of his Flame Spike. A magic dispel removes Flame Shock; interrupt his Shadow Bolt. Fire Nova burns those close to him." },
			loot = { 252455, 252513 },
		},
	},
	trash = { 1992, 5756, 7736, 7755, 7757, 7758, 7759, 7760, 8225 },
	questPatches = {
		[1051] = { endMap = { mapID = 1424, x = 0.627, y = 0.189 } },
	},
})

Update("ScarletMonasteryLibrary", {
	bosses = {
		["Houndmaster Loksey"] = { notes = { "A priest or a shaman can remove his Bloodlust." }, loot = { 274292 } },
		["Arcanist Doan"] = {
			notes = { "Interrupt or dispel his Polymorph. His Silence reaches 15 yards: healers, stand back." },
			loot = { 274294 },
		},
	},
	trash = { 10328, 10329, 10330, 10331, 10333 },
	questPatches = {
		[1394] = { startMap = { mapID = 1458, x = 0.578, y = 0.654 }, endMap = { mapID = 1441, x = 0.539, y = 0.415 } },
	},
})

-- City of Dalaran's own page, checked again: two trash drops the journal lacked.
Update("CityOfDalaran", { trash = { 276160, 276158 } })

------------------------------------------------------------------------------------------
-- Checked again against foreverchanges.pro on 2026-10-11, every dungeon page and the quest
-- pages of the quests below: the levels quests can be taken from, two creatures' models,
-- one quest's giver, and the quests our data lacked. Inside a dungeon, a giver has no place
-- on the world map; the quest says who it is.
------------------------------------------------------------------------------------------

local function From(level) return { requiredLevel = level } end

Update("WailingCaverns", { questPatches = { [914] = From(12) } })
Update("TheDeadmines", {
	questPatches = {
		[92753] = {
			pickup = "Alba Fairmoon, Sentinel Hill, Westfall",
			turnin = "Alba Fairmoon, at the Deadmines' exit, Westfall",
			startMap = { mapID = 1436, x = 0.524, y = 0.530, label = "Alba Fairmoon" },
			endMap = { mapID = 1436, x = 0.386, y = 0.836, label = "Alba Fairmoon" },
		},
	},
})
Update("ShadowfangKeep", { bosses = { ["Fel Steed / Shadow Charger"] = { displayID = 1952 } } })
Update("Gnomeregan", {
	bosses = { ["Grubbis"] = { displayID = 6533 } },
	questPatches = {
		[2843] = From(25),
		[2945] = { level = 34 },
		[2947] = { level = 34, requiredLevel = 28 },
		[2949] = { level = 34, requiredLevel = 28 },
	},
	addQuests = {
		{
			questID = 2952, name = "The Sparklematic 5200!", level = 30, requiredLevel = 25, faction = "Both",
			pickup = "The Sparklematic 5200, inside Gnomeregan", turnin = "The Sparklematic 5200, inside Gnomeregan",
			objective = "Put a Grime-Encrusted Item into the Sparklematic 5200 to have it cleaned.",
			rewards = { xp = 2450, items = { { itemID = 9363, name = "Sparklematic-Wrapped Box", quality = 1 } } },
		},
	},
})
Update("ScarletMonasteryLibrary", { questPatches = { [1160] = From(25) } })
Update("ScarletMonasteryArmory", {
	addQuests = {
		{
			questID = 1113, name = "Hearts of Zeal", level = 33, requiredLevel = 30, faction = "Horde",
			pickup = "Master Apothecary Faranell, the Apothecarium, Undercity",
			turnin = "Master Apothecary Faranell, the Apothecarium, Undercity",
			startMap = { mapID = 1458, x = 0.488, y = 0.693, label = "Master Apothecary Faranell" },
			endMap = { mapID = 1458, x = 0.488, y = 0.693, label = "Master Apothecary Faranell" },
			objective = "Bring 20 Hearts of Zeal to Master Apothecary Faranell in the Undercity.",
			note = "Follows Going, Going, Guano! The Scarlet Crusaders of every wing carry the hearts, and so do their leaders.",
			rewards = { xp = 3300 },
		},
	},
})
Update("Uldaman", {
	questPatches = { [17] = From(36), [2201] = From(40), [2341] = From(40), [2204] = From(40), [2361] = From(40) },
	addQuests = {
		{
			questID = 2202, name = "Uldaman Reagent Run", level = 42, requiredLevel = 36, faction = "Horde",
			pickup = "Jarkal Mossmeld, Kargath, Badlands", turnin = "Jarkal Mossmeld, Kargath, Badlands",
			startMap = { mapID = 1418, x = 0.024, y = 0.461, label = "Jarkal Mossmeld" },
			endMap = { mapID = 1418, x = 0.024, y = 0.461, label = "Jarkal Mossmeld" },
			objective = "Bring 12 Magenta Fungus Caps from inside Uldaman to Jarkal Mossmeld in Kargath.",
			note = "Follows Badlands Reagent Run.",
			rewards = { xp = 3450, money = 5500, items = { { itemID = 9030, name = "Restorative Potion", quality = 1, count = 5 } } },
		},
	},
})
Update("Maraudon", {
	questPatches = { [7070] = From(38), [7066] = From(45) },
	addQuests = {
		{
			questID = 7068, name = "Shadowshard Fragments", level = 42, requiredLevel = 38, faction = "Horde",
			pickup = "Uthel'nay, the Cleft of Shadow, Orgrimmar", turnin = "Uthel'nay, the Cleft of Shadow, Orgrimmar",
			startMap = { mapID = 1454, x = 0.392, y = 0.863, label = "Uthel'nay" },
			endMap = { mapID = 1454, x = 0.392, y = 0.863, label = "Uthel'nay" },
			objective = "Collect 10 Shadowshard Fragments from the Shadowshard Rumblers and Smashers of Maraudon.",
			rewards = {
				xp = 3450, choice = true,
				items = {
					{ itemID = 17772, name = "Zealous Shadowshard Pendant", quality = 2 },
					{ itemID = 17773, name = "Prodigious Shadowshard Pendant", quality = 2 },
				},
			},
		},
		{
			questID = 7029, name = "Vyletongue Corruption", level = 47, requiredLevel = 41, faction = "Horde",
			pickup = "Vark Battlescar, Shadowprey Village, Desolace", turnin = "Vark Battlescar, Shadowprey Village, Desolace",
			startMap = { mapID = 1443, x = 0.232, y = 0.703, label = "Vark Battlescar" },
			endMap = { mapID = 1443, x = 0.232, y = 0.703, label = "Vark Battlescar" },
			objective = "Fill the Coated Cerulean Vial at the orange crystal pool, pour it on the Vylestem Vines and kill the 8 Noxxious Scions that come out.",
			rewards = {
				xp = 5250, choice = true,
				items = {
					{ itemID = 17768, name = "Woodseed Hoop", quality = 2 },
					{ itemID = 17778, name = "Sagebrush Girdle", quality = 2 },
					{ itemID = 17770, name = "Branchclaw Gauntlets", quality = 2 },
				},
			},
		},
		{
			questID = 7064, name = "Corruption of Earth and Seed", level = 51, requiredLevel = 45, faction = "Horde",
			pickup = "Selendra, near Shadowprey Village, Desolace", turnin = "Selendra, near Shadowprey Village, Desolace",
			startMap = { mapID = 1443, x = 0.269, y = 0.777, label = "Selendra" },
			endMap = { mapID = 1443, x = 0.269, y = 0.777, label = "Selendra" },
			objective = "Kill Princess Theradras.",
			rewards = {
				xp = 6100, choice = true,
				items = {
					{ itemID = 17705, name = "Thrash Blade", quality = 3 },
					{ itemID = 17743, name = "Resurgence Rod", quality = 3 },
					{ itemID = 17753, name = "Verdant Keeper's Aim", quality = 3 },
				},
			},
		},
	},
})
Update("TempleOfAtalHakkar", { questPatches = { [1475] = From(41) } })

-- A copy for each dungeon that lists it.
local function Bijou() return {
	questID = 4982, name = "Bijou's Belongings", level = 59, requiredLevel = 55, faction = "Horde",
	pickup = "Bijou, inside Lower Blackrock Spire", turnin = "Bijou, inside Lower Blackrock Spire",
	objective = "Find the belongings Bijou stashed on the bottom floor of the city, and bring them back to her.",
	note = "Follows Operative Bijou.",
	rewards = { xp = 6400 },
} end
Update("LowerBlackrockSpire", { questPatches = { [5047] = From(55) }, addQuests = { Bijou() } })
Update("UpperBlackrockSpire", { questPatches = { [5047] = From(55) }, addQuests = { Bijou() } })

local function Shendralar() return {
	questID = 7877, name = "The Treasure of the Shen'dralar", level = 60, requiredLevel = 56, faction = "Horde",
	pickup = "Shen'dralar Ancient, inside Dire Maul", turnin = "The Treasure of the Shen'dralar, in the Athenaeum, Dire Maul",
	objective = "Go back to the Athenaeum, find the Treasure of the Shen'dralar and claim your reward.",
	note = "Follows The Madness Within.",
	rewards = {
		xp = 675, money = 27000, choice = true,
		items = {
			{ itemID = 18420, name = "Bonecrusher", quality = 3 },
			{ itemID = 18421, name = "Backwood Helm", quality = 3 },
			{ itemID = 18424, name = "Sedge Boots", quality = 3 },
		},
	},
} end
Update("DireMaulEast", {
	questPatches = { [5528] = From(57) },
	addQuests = {
		{
			questID = 7489, name = "Lethtendris's Web", level = 57, requiredLevel = 54, faction = "Horde",
			pickup = "Talo Thornhoof, Camp Mojache, Feralas", turnin = "Talo Thornhoof, Camp Mojache, Feralas",
			startMap = { mapID = 1444, x = 0.762, y = 0.438, label = "Talo Thornhoof" },
			endMap = { mapID = 1444, x = 0.762, y = 0.438, label = "Talo Thornhoof" },
			objective = "Bring Lethtendris's Web to Talo Thornhoof at Camp Mojache.",
			rewards = { xp = 7550, money = 17000, items = { { itemID = 18491, name = "Lorespinner", quality = 3 } } },
		},
		Shendralar(),
	},
})
Update("DireMaulNorth", { questPatches = { [5528] = From(57), [5525] = From(57) }, addQuests = { Shendralar() } })
Update("DireMaulWest", { questPatches = { [5528] = From(57) }, addQuests = { Shendralar() } })

Update("ExcavationSiteWetlands", {
	addQuests = {
		{
			questID = 95663, name = "Dragonmaw Rumors", level = 31, requiredLevel = 24, faction = "Horde",
			pickup = "Zaruk, Hammerfall, Arathi Highlands", turnin = "Deathstalker Agent, above the Dragonmaw camp, Wetlands",
			startMap = { mapID = 1417, x = 0.744, y = 0.356, label = "Zaruk" },
			endMap = { mapID = 1437, x = 0.514, y = 0.592, label = "Deathstalker Agent" },
			objective = "Meet the Deathstalker Agent in the hills above the Dragonmaw camp in the Wetlands.",
			rewards = { xp = 550 },
		},
		{
			questID = 95737, name = "Seeking Caitlin", level = 31, requiredLevel = 24, faction = "Alliance",
			pickup = "Llana, Astranaar, Ashenvale", turnin = "Caitlin Grassman, Menethil Harbor, Wetlands",
			startMap = { mapID = 1440, x = 0.350, y = 0.484, label = "Llana" },
			endMap = { mapID = 1437, x = 0.118, y = 0.586, label = "Caitlin Grassman" },
			objective = "Speak with Caitlin Grassman in Menethil Harbor.",
			rewards = { xp = 1250 },
		},
	},
})
Update("CityOfDalaran", { questPatches = { [96984] = From(24), [92458] = From(24) } })
Update("TheDrownedCity", {
	addQuests = {
		{
			questID = 96774, name = "Ancient Gurubashi Idol", level = 40, requiredLevel = 30, faction = "Horde",
			pickup = "Mazu'kon, Mulgore", startMap = { mapID = 1412, x = 0.324, y = 0.206, label = "Mazu'kon" },
			objective = "Recover an Ancient Gurubashi Idol from the Drowned City.",
			rewards = { xp = 8800 },
		},
	},
})

--[[
	2026-10-16: every dungeon's quest list on the site (/quests/<dungeon>), set against ours, and
	each quest we lacked read on its own page, one at a time: facts only, in our own words. Where the site's details come from Wowhead's database (quests
	new in Forever), only its plain facts are kept: name, level, side.

	  questPatches  the required level Forever changed (the site has it from the game), three
	                more where the site's differs from ours, and Important Heirlooms being the
	                Alliance's only
	  addQuests     the quests on the site's list for the dungeon that ours lacked: chain steps
	                given far from it, Forever's new ones, and the quests started inside it

	A quest of more than one wing (Dire Maul's librams and Elven Legends, Stratholme's Medallion
	of Faith) is listed in each wing it touches, as the others are.
]]

Update("WailingCaverns", {
	questPatches = {
		[914] = { requiredLevel = 10 }, -- Leaders of the Fang
	},
	addQuests = {
		{
			questID = 999, name = "When Dreams Turn to Nightmares", level = 25, requiredLevel = 10, faction = "Both",
			note = "New in Forever. Where it starts isn't known yet.",
		},
		{
			questID = 1489, name = "Hamuul Runetotem", level = 16, requiredLevel = 10, faction = "Horde",
			pickup = "Tonga Runetotem, The Barrens",
			turnin = "Arch Druid Hamuul Runetotem, Thunder Bluff",
			startMap = { mapID = 1413, x = 0.523, y = 0.319 }, endMap = { mapID = 1456, x = 0.786, y = 0.286 },
			objective = "Go to Thunder Bluff and talk to Arch Druid Hamuul Runetotem.",
			prerequisites = { { questID = 880, name = "Altered Beings" } },
		},
		{
			questID = 1490, name = "Nara Wildmane", level = 16, requiredLevel = 10, faction = "Horde",
			pickup = "Arch Druid Hamuul Runetotem, Thunder Bluff",
			turnin = "Nara Wildmane, Thunder Bluff",
			startMap = { mapID = 1456, x = 0.786, y = 0.286 }, endMap = { mapID = 1456, x = 0.756, y = 0.316 },
			objective = "Talk to Nara Wildmane nearby in Thunder Bluff.",
			prerequisites = { { questID = 1489, name = "Hamuul Runetotem" } },
		},
		{
			questID = 1500, name = "Waking Naralex", level = 25, requiredLevel = 10, faction = "Both",
			note = "New in Forever. Where it starts isn't known yet.",
		},
		{
			questID = 3366, name = "The Glowing Shard", level = 25, requiredLevel = 15, faction = "Both",
			note = "New in Forever. Where it starts isn't known yet.",
		},
	},
})

Update("TheStockade", {
	questPatches = {
		[378] = { requiredLevel = 22 }, -- The Fury Runs Deep
	},
})

Update("Gnomeregan", {
	questPatches = {
		[2843] = { requiredLevel = 20 }, -- Gnomer-gooooone!
		[2904] = { requiredLevel = 20 }, -- A Fine Mess
	},
	addQuests = {
		{
			questID = 2923, name = "Tinkmaster Overspark", level = 26, requiredLevel = 20, faction = "Alliance",
			pickup = "Brother Sarno, Stormwind City",
			turnin = "Tinkmaster Overspark, Ironforge",
			startMap = { mapID = 1453, x = 0.511, y = 0.484 }, endMap = { mapID = 1455, x = 0.690, y = 0.500 },
			objective = "Report to Tinkmaster Overspark in Ironforge.",
		},
		{
			questID = 2925, name = "Klockmort's Essentials", level = 30, requiredLevel = 24, faction = "Alliance",
			pickup = "Mathiel, Darnassus",
			turnin = "Klockmort Spannerspan, Ironforge",
			startMap = { mapID = 1457, x = 0.595, y = 0.454 }, endMap = { mapID = 1455, x = 0.670, y = 0.460 },
			objective = "Talk to Klockmort Spannerspan in Ironforge.",
		},
		{
			questID = 2927, name = "The Day After", level = 27, requiredLevel = 20, faction = "Alliance",
			pickup = "Gnoarn, Ironforge",
			turnin = "Ozzie Togglevolt, Dun Morogh",
			startMap = { mapID = 1455, x = 0.690, y = 0.500 }, endMap = { mapID = 1426, x = 0.459, y = 0.494 },
			objective = "Talk to Ozzie Togglevolt in Kharanos.",
		},
		{
			questID = 2931, name = "Castpipe's Task", level = 28, requiredLevel = 25, faction = "Alliance",
			pickup = "Gaxim Rustfizzle, Stonetalon Mountains",
			turnin = "Master Mechanic Castpipe, Ironforge",
			startMap = { mapID = 1442, x = 0.595, y = 0.671 }, endMap = { mapID = 1455, x = 0.690, y = 0.480 },
			objective = "Talk to Master Mechanic Castpipe in Ironforge.",
		},
		{
			questID = 2953, name = "More Sparklematic Action", level = 30, requiredLevel = 25, faction = "Both",
			pickup = "The Sparklematic 5200, inside Gnomeregan",
			turnin = "The Sparklematic 5200, inside Gnomeregan",
			objective = "Give the Sparklematic 5200 another Grime-Encrusted Object to get a Sparklematic-Wrapped Box.",
			note = "Repeatable. Each go costs 3 silver.",
			prerequisites = { { questID = 2952, name = "The Sparklematic 5200!" } },
		},
		{
			questID = 4601, name = "The Sparklematic 5200!", level = 30, requiredLevel = 25, faction = "Both",
			pickup = "The Sparklematic 5200, inside Gnomeregan",
			turnin = "The Sparklematic 5200, inside Gnomeregan",
			objective = "Put a Grime-Encrusted Object in the Sparklematic 5200; you need 3 silver to run it.",
			note = "Each go costs 3 silver.",
		},
		{
			questID = 4602, name = "The Sparklematic 5200!", level = 30, requiredLevel = 25, faction = "Both",
			pickup = "The Sparklematic 5200, inside Gnomeregan",
			turnin = "The Sparklematic 5200, inside Gnomeregan",
			objective = "Put a Grime-Encrusted Object in the Sparklematic 5200; you need 3 silver to run it.",
			note = "Each go costs 3 silver.",
		},
		{
			questID = 4603, name = "More Sparklematic Action", level = 30, requiredLevel = 25, faction = "Both",
			pickup = "The Sparklematic 5200, inside Gnomeregan",
			turnin = "The Sparklematic 5200, inside Gnomeregan",
			objective = "Give the Sparklematic 5200 another Grime-Encrusted Object to get a Sparklematic-Wrapped Box.",
			note = "Repeatable. Each go costs 3 silver.",
			prerequisites = { { questID = 4605, name = "The Sparklematic 5200!" } },
		},
		{
			questID = 4604, name = "More Sparklematic Action", level = 30, requiredLevel = 25, faction = "Both",
			pickup = "The Sparklematic 5200, inside Gnomeregan",
			turnin = "The Sparklematic 5200, inside Gnomeregan",
			objective = "Give the Sparklematic 5200 another Grime-Encrusted Object to get a Sparklematic-Wrapped Box.",
			note = "Repeatable. Each go costs 3 silver.",
			prerequisites = { { questID = 4606, name = "The Sparklematic 5200!" } },
		},
		{
			questID = 4605, name = "The Sparklematic 5200!", level = 30, requiredLevel = 25, faction = "Both",
			pickup = "The Sparklematic 5200, inside Gnomeregan",
			turnin = "The Sparklematic 5200, inside Gnomeregan",
			objective = "Hand the Sparklematic 5200 a Grime-Encrusted Object for a Sparklematic-Wrapped Box.",
			prerequisites = { { questID = 4601, name = "The Sparklematic 5200!" } },
		},
		{
			questID = 4606, name = "The Sparklematic 5200!", level = 30, requiredLevel = 25, faction = "Both",
			pickup = "The Sparklematic 5200, inside Gnomeregan",
			turnin = "The Sparklematic 5200, inside Gnomeregan",
			objective = "Hand the Sparklematic 5200 a Grime-Encrusted Object for a Sparklematic-Wrapped Box.",
			prerequisites = { { questID = 4602, name = "The Sparklematic 5200!" } },
		},
	},
})

Update("RazorfenKraul", {
	questPatches = {
		[1144] = { requiredLevel = 22 }, -- Willix the Importer
	},
})

Update("Uldaman", {
	questPatches = {
		[17] = { requiredLevel = 38 }, -- Uldaman Reagent Run
		[2201] = { requiredLevel = 37 }, -- Find the Gems
		[2204] = { requiredLevel = 37 }, -- Restoring the Necklace
		[2341] = { requiredLevel = 37 }, -- Necklace Recovery, Take 3
		[2361] = { requiredLevel = 37 }, -- Restoring the Necklace
	},
	addQuests = {
		{
			questID = 721, name = "A Sign of Hope", level = 35, requiredLevel = 35, faction = "Alliance",
			pickup = "Prospector Ryedol, Badlands",
			turnin = "Hammertoe Grez, Loch Modan",
			startMap = { mapID = 1418, x = 0.534, y = 0.434 }, endMap = { mapID = 1432, x = 0.373, y = 0.858 },
			objective = "Find Hammertoe Grez in the caves before Uldaman.",
			prerequisites = { { questID = 720, name = "A Sign of Hope" } },
		},
		{
			questID = 2200, name = "Back to Uldaman", level = 42, requiredLevel = 37, faction = "Alliance",
			pickup = "Talvash del Kissel, Ironforge",
			turnin = "Remains of a Paladin, inside Uldaman",
			startMap = { mapID = 1455, x = 0.357, y = 0.040 },
			objective = "Look in Uldaman for the dead paladin who last had Talvash's necklace.",
			prerequisites = { { questID = 2199, name = "Lore for a Price" } },
		},
		{
			questID = 2278, name = "The Platinum Discs", level = 47, requiredLevel = 40, faction = "Both",
			pickup = "The Discs of Norgannon, inside Uldaman",
			turnin = "The Discs of Norgannon, inside Uldaman",
			objective = "Talk to the stone watcher, then use the Discs of Norgannon.",
		},
		{
			questID = 2284, name = "Necklace Recovery, Take 2", level = 41, requiredLevel = 37, faction = "Horde",
			pickup = "Dran Droffers, Orgrimmar",
			turnin = "Remains of a Paladin, inside Uldaman",
			startMap = { mapID = 1454, x = 0.596, y = 0.365 },
			objective = "Search deep in Uldaman for a clue to where the necklace's gems went.",
			prerequisites = { { questID = 2283, name = "Necklace Recovery" } },
		},
		{
			questID = 2318, name = "Translating the Journal", level = 42, requiredLevel = 37, faction = "Horde",
			pickup = "Remains of a Paladin, inside Uldaman",
			turnin = "Jarkal Mossmeld, Badlands",
			endMap = { mapID = 1418, x = 0.024, y = 0.461 },
			objective = "Find someone in Kargath (Badlands) who can translate the paladin's journal.",
			prerequisites = { { questID = 2284, name = "Necklace Recovery, Take 2" } },
		},
		{
			questID = 2398, name = "The Lost Dwarves", level = 40, requiredLevel = 35, faction = "Alliance",
			pickup = "Prospector Stormpike, Ironforge",
			turnin = "Baelog, inside Uldaman",
			startMap = { mapID = 1455, x = 0.747, y = 0.103 },
			objective = "Find Baelog inside Uldaman.",
		},
		{
			questID = 3375, name = "Replacement Phial", level = 42, requiredLevel = 37, faction = "Alliance",
			pickup = "Talvash del Kissel, Ironforge",
			turnin = "Talvash del Kissel, Ironforge",
			startMap = { mapID = 1455, x = 0.357, y = 0.040 }, endMap = { mapID = 1455, x = 0.357, y = 0.040 },
			objective = "Bring Talvash a Mana Potion, Coal and Sweet Nectar to get a new Phial of Scrying.",
			note = "Repeatable: for when the phial is lost.",
		},
	},
})

Update("ZulFarrak", {
	addQuests = {
		{
			questID = 2861, name = "Tabetha's Task", level = 46, requiredLevel = 40, faction = "Both",
			pickup = "A mage trainer in a capital",
			turnin = "Tabetha, Dustwallow Marsh",
			endMap = { mapID = 1445, x = 0.461, y = 0.571 },
			objective = "Talk to Tabetha in Dustwallow Marsh.",
			note = "Given by Jennea Cannon (Stormwind), Bink (Ironforge), Deino (Orgrimmar), Ursyn Ghull (Thunder Bluff) and Anastasia Hartwell (Undercity).",
		},
		{
			questID = 2864, name = "Tran'rek", level = 45, requiredLevel = 40, faction = "Both",
			pickup = "Krazek, Stranglethorn Vale",
			turnin = "Tran'rek, Tanaris",
			startMap = { mapID = 1434, x = 0.269, y = 0.772 }, endMap = { mapID = 1446, x = 0.516, y = 0.268 },
			objective = "Talk to Tran'rek in Gadgetzan.",
		},
		{
			questID = 2936, name = "The Spider God", level = 45, requiredLevel = 40, faction = "Horde",
			pickup = "Master Gadrin, Durotar",
			turnin = "Master Gadrin, Durotar",
			startMap = { mapID = 1411, x = 0.559, y = 0.747 }, endMap = { mapID = 1411, x = 0.559, y = 0.747 },
			objective = "Read the Tablet of Theka in Zul'Farrak to learn the spider god's name, then go back to Master Gadrin.",
			prerequisites = { { questID = 2935, name = "Consult Master Gadrin" } },
		},
	},
})

Update("Maraudon", {
	questPatches = {
		[7066] = { requiredLevel = 39 }, -- Seed of Life
		[7068] = { requiredLevel = 39 }, -- Shadowshard Fragments
		[7070] = { requiredLevel = 39 }, -- Shadowshard Fragments
	},
})

Update("TempleOfAtalHakkar", {
	questPatches = {
		[1475] = { requiredLevel = 38 }, -- Into The Temple of Atal'Hakkar
	},
	addQuests = {
		{
			questID = 3380, name = "The Sunken Temple", level = 51, requiredLevel = 46, faction = "Horde",
			pickup = "Witch Doctor Uzer'i, Feralas",
			turnin = "Marvon Rivetseeker, Tanaris",
			startMap = { mapID = 1444, x = 0.744, y = 0.434 }, endMap = { mapID = 1446, x = 0.527, y = 0.459 },
			objective = "Find Marvon Rivetseeker in Tanaris.",
		},
		{
			questID = 8733, name = "Eranikus, Tyrant of the Dream", level = 60, requiredLevel = 60, faction = "Both",
			pickup = "Malfurion Stormrage, inside the Sunken Temple",
			turnin = "Forest Wisp, Teldrassil",
			endMap = { mapID = 1438, x = 0.376, y = 0.479 },
			objective = "Go to Teldrassil and find Malfurion's agent outside Darnassus.",
		},
	},
})

Update("BlackrockDepths", {
	addQuests = {
		{
			questID = 3801, name = "Dark Iron Legacy", level = 52, requiredLevel = 48, faction = "Both",
			pickup = "Franclorn Forgewright, Burning Steppes",
			turnin = "Franclorn Forgewright, Burning Steppes",
			startMap = { mapID = 1428, x = 0.290, y = 0.289 }, endMap = { mapID = 1428, x = 0.290, y = 0.289 },
			objective = "Talk to Franclorn Forgewright about getting a key to the city.",
		},
		{
			questID = 3911, name = "The Last Element", level = 54, requiredLevel = 48, faction = "Both",
			note = "New in Forever. Where it starts isn't known yet.",
		},
		{
			questID = 3981, name = "Commander Gor'shak", level = 52, requiredLevel = 48, faction = "Horde",
			pickup = "Galamav the Marksman, Badlands",
			turnin = "Commander Gor'shak, inside Blackrock Depths",
			startMap = { mapID = 1418, x = 0.060, y = 0.477 },
			objective = "Find Commander Gor'shak in a prison cell in Blackrock Depths.",
			prerequisites = { { questID = 3906, name = "Disharmony of Flame" } },
		},
		{
			questID = 3982, name = "What Is Going On?", level = 54, requiredLevel = 48, faction = "Horde",
			pickup = "Commander Gor'shak, inside Blackrock Depths",
			turnin = "Commander Gor'shak, inside Blackrock Depths",
			objective = "Defend Commander Gor'shak.",
			prerequisites = { { questID = 3981, name = "Commander Gor'shak" } },
		},
		{
			questID = 4001, name = "What Is Going On?", level = 54, requiredLevel = 48, faction = "Horde",
			pickup = "Commander Gor'shak, inside Blackrock Depths",
			turnin = "Thrall, Orgrimmar",
			endMap = { mapID = 1454, x = 0.317, y = 0.378 },
			objective = "Hear from Kharan Mighthammer about Princess Moira's kidnapping, then report to Thrall.",
			prerequisites = { { questID = 3982, name = "What Is Going On?" } },
		},
		{
			questID = 4002, name = "The Eastern Kingdoms", level = 54, requiredLevel = 48, faction = "Horde",
			pickup = "Thrall, Orgrimmar",
			turnin = "Thrall, Orgrimmar",
			startMap = { mapID = 1454, x = 0.317, y = 0.378 }, endMap = { mapID = 1454, x = 0.317, y = 0.378 },
			objective = "Talk to Thrall to take on his mission.",
			prerequisites = { { questID = 4001, name = "What Is Going On?" } },
		},
		{
			questID = 4122, name = "Grark Lorkrub", level = 58, requiredLevel = 52, faction = "Horde",
			pickup = "Lexlort, Badlands",
			turnin = "Grark Lorkrub, Burning Steppes",
			startMap = { mapID = 1418, x = 0.059, y = 0.476 }, endMap = { mapID = 1428, x = 0.402, y = 0.342 },
			objective = "Shackle Grark Lorkrub in the Blackrock fortress and lead him through Blackrock Mountain to Searing Gorge.",
			note = "An escort: Grark is held at the Blackrock fortress in the Burning Steppes.",
		},
		{
			questID = 4128, name = "Ragnar Thunderbrew", level = 55, requiredLevel = 50, faction = "Alliance",
			pickup = "Enohar Thunderbrew, Blasted Lands",
			turnin = "Ragnar Thunderbrew, Dun Morogh",
			startMap = { mapID = 1419, x = 0.636, y = 0.206 }, endMap = { mapID = 1426, x = 0.468, y = 0.524 },
			objective = "Talk to Ragnar Thunderbrew in Kharanos.",
		},
		{
			questID = 4133, name = "Vivian Lagrave", level = 55, requiredLevel = 50, faction = "Horde",
			pickup = "Apothecary Zinge, Undercity",
			turnin = "Shadowmage Vivian Lagrave, Badlands",
			startMap = { mapID = 1458, x = 0.501, y = 0.680 }, endMap = { mapID = 1418, x = 0.029, y = 0.478 },
			objective = "Talk to Shadowmage Vivian Lagrave in Kargath.",
		},
		{
			questID = 4241, name = "Marshal Windsor", level = 54, requiredLevel = 48, faction = "Alliance",
			pickup = "Marshal Maxwell, Burning Steppes",
			turnin = "Marshal Windsor, inside Blackrock Depths",
			startMap = { mapID = 1428, x = 0.847, y = 0.690 },
			objective = "Go into Blackrock Depths and find out what happened to Marshal Windsor.",
			prerequisites = { { questID = 4224, name = "The True Masters" } },
		},
		{
			questID = 4295, name = "Rocknot's Ale", level = 1, requiredLevel = 1, faction = "Both",
			pickup = "Private Rocknot, inside Blackrock Depths",
			turnin = "Private Rocknot, inside Blackrock Depths",
			objective = "Bring Private Rocknot 2 Dark Iron Ale Mugs.",
			note = "Repeatable.",
		},
		{
			questID = 4324, name = "Yuka Screwspigot", level = 53, requiredLevel = 48, faction = "Both",
			pickup = "Yorba Screwspigot, Tanaris",
			turnin = "Yuka Screwspigot, Burning Steppes",
			startMap = { mapID = 1446, x = 0.670, y = 0.240 }, endMap = { mapID = 1428, x = 0.661, y = 0.220 },
			objective = "Talk to Yuka Screwspigot in the Burning Steppes.",
		},
		{
			questID = 4341, name = "Kharan Mighthammer", level = 59, requiredLevel = 50, faction = "Alliance",
			pickup = "King Magni Bronzebeard, Ironforge",
			turnin = "Kharan Mighthammer, inside Blackrock Depths",
			startMap = { mapID = 1455, x = 0.394, y = 0.558 },
			objective = "Find Kharan Mighthammer in the Blackrock Depths prison.",
			prerequisites = { { questID = 3701, name = "The Smoldering Ruins of Thaurissan" } },
		},
		{
			questID = 4342, name = "Kharan's Tale", level = 59, requiredLevel = 50, faction = "Alliance",
			pickup = "Kharan Mighthammer, inside Blackrock Depths",
			turnin = "Kharan Mighthammer, inside Blackrock Depths",
			objective = "Listen to Kharan Mighthammer tell his story.",
		},
		{
			questID = 4361, name = "The Bearer of Bad News", level = 59, requiredLevel = 50, faction = "Alliance",
			pickup = "Kharan Mighthammer, inside Blackrock Depths",
			turnin = "King Magni Bronzebeard, Ironforge",
			endMap = { mapID = 1455, x = 0.394, y = 0.558 },
			objective = "Take the bad news back to King Magni Bronzebeard in Ironforge.",
			prerequisites = { { questID = 4341, name = "Kharan Mighthammer" }, { questID = 4342, name = "Kharan's Tale" } },
		},
	},
})

Update("LowerBlackrockSpire", {
	questPatches = {
		[5047] = { requiredLevel = 57 }, -- Finkle Einhorn, At Your Service!
	},
	addQuests = {
		{
			questID = 4981, name = "Operative Bijou", level = 59, requiredLevel = 55, faction = "Horde",
			pickup = "Lexlort, Badlands",
			turnin = "Bijou, inside Lower Blackrock Spire",
			startMap = { mapID = 1418, x = 0.059, y = 0.476 },
			objective = "Go into Blackrock Spire and find out what happened to Bijou.",
		},
		{
			questID = 7761, name = "Blackhand's Command", level = 60, requiredLevel = 55, faction = "Both",
			turnin = "Drakkisath's Brand, inside Upper Blackrock Spire",
			objective = "Find Drakkisath's Brand, guarded by General Drakkisath, to get the Mark of Drakkisath.",
			note = "Starts from Blackhand's Command, a letter dropped in Lower Blackrock Spire.",
		},
	},
})

Update("UpperBlackrockSpire", {
	questPatches = {
		[5047] = { requiredLevel = 57 }, -- Finkle Einhorn, At Your Service!
	},
	addQuests = {
		{
			questID = 4766, name = "Mayara Brightwing", level = 60, requiredLevel = 57, faction = "Alliance",
			pickup = "Count Remington Ridgewell, Stormwind City",
			turnin = "Mayara Brightwing, Burning Steppes",
			startMap = { mapID = 1453, x = 0.769, y = 0.478 }, endMap = { mapID = 1428, x = 0.848, y = 0.691 },
			objective = "Talk to Mayara Brightwing in the Burning Steppes.",
		},
		{
			questID = 4769, name = "Vivian Lagrave and the Darkstone Tablet", level = 60, requiredLevel = 57, faction = "Horde",
			pickup = "Apothecary Zinge, Undercity",
			turnin = "Shadowmage Vivian Lagrave, Badlands",
			startMap = { mapID = 1458, x = 0.501, y = 0.680 }, endMap = { mapID = 1418, x = 0.029, y = 0.478 },
			objective = "Talk to Shadowmage Vivian Lagrave in Kargath.",
		},
		{
			questID = 4907, name = "Tinkee Steamboil", level = 60, requiredLevel = 57, faction = "Both",
			pickup = "Felnok Steelspring, Winterspring",
			turnin = "Tinkee Steamboil, Burning Steppes",
			startMap = { mapID = 1452, x = 0.616, y = 0.386 }, endMap = { mapID = 1428, x = 0.652, y = 0.240 },
			objective = "Talk to Tinkee Steamboil in the Burning Steppes.",
			prerequisites = { { questID = 4810, name = "Return to Tinkee" } },
		},
		{
			questID = 4981, name = "Operative Bijou", level = 59, requiredLevel = 55, faction = "Horde",
			pickup = "Lexlort, Badlands",
			turnin = "Bijou, inside Lower Blackrock Spire",
			startMap = { mapID = 1418, x = 0.059, y = 0.476 },
			objective = "Go into Blackrock Spire and find out what happened to Bijou.",
		},
		{
			questID = 7761, name = "Blackhand's Command", level = 60, requiredLevel = 55, faction = "Both",
			turnin = "Drakkisath's Brand, inside Upper Blackrock Spire",
			objective = "Find Drakkisath's Brand, guarded by General Drakkisath, to get the Mark of Drakkisath.",
			note = "Starts from Blackhand's Command, a letter dropped in Lower Blackrock Spire.",
		},
	},
})

Update("DireMaulEast", {
	questPatches = {
		[5528] = { requiredLevel = 56 }, -- The Gordok Taste Test
	},
	addQuests = {
		{
			questID = 7481, name = "Elven Legends", level = 60, requiredLevel = 54, faction = "Horde",
			pickup = "Sage Korolusk, Feralas",
			turnin = "Sage Korolusk, Feralas",
			startMap = { mapID = 1444, x = 0.752, y = 0.438 }, endMap = { mapID = 1444, x = 0.752, y = 0.438 },
			objective = "Look in Dire Maul for Kariel Winthalus and report back to Sage Korolusk.",
		},
		{
			questID = 7482, name = "Elven Legends", level = 60, requiredLevel = 54, faction = "Alliance",
			pickup = "Scholar Runethorn, Feralas",
			turnin = "Scholar Runethorn, Feralas",
			startMap = { mapID = 1444, x = 0.312, y = 0.439 }, endMap = { mapID = 1444, x = 0.312, y = 0.439 },
			objective = "Look in Dire Maul for Kariel Winthalus and report back to Scholar Runethorn.",
		},
		{
			questID = 7483, name = "Libram of Rapidity", level = 60, requiredLevel = 54, faction = "Both",
			pickup = "Lorekeeper Lydros, inside Dire Maul",
			turnin = "Lorekeeper Lydros, inside Dire Maul",
			objective = "Bring the Libram of Rapidity, a Pristine Black Diamond, 2 Large Brilliant Shards and 2 Blood of Heroes to Lorekeeper Lydros for an Arcanum of Rapidity.",
			note = "Repeatable.",
		},
		{
			questID = 7484, name = "Libram of Focus", level = 60, requiredLevel = 54, faction = "Both",
			pickup = "Lorekeeper Lydros, inside Dire Maul",
			turnin = "Lorekeeper Lydros, inside Dire Maul",
			objective = "Bring the Libram of Focus, a Pristine Black Diamond, 4 Large Brilliant Shards and 2 Skin of Shadow to Lorekeeper Lydros for an Arcanum of Focus.",
			note = "Repeatable.",
		},
		{
			questID = 7485, name = "Libram of Protection", level = 60, requiredLevel = 54, faction = "Both",
			pickup = "Lorekeeper Lydros, inside Dire Maul",
			turnin = "Lorekeeper Lydros, inside Dire Maul",
			objective = "Bring the Libram of Protection, a Pristine Black Diamond, 2 Large Brilliant Shards and a Frayed Abomination Stitching to Lorekeeper Lydros for an Arcanum of Protection.",
			note = "Repeatable.",
		},
		{
			questID = 7492, name = "Camp Mojache", level = 57, requiredLevel = 54, faction = "Horde",
			pickup = "Warcaller Gorlach, Orgrimmar",
			turnin = "Talo Thornhoof, Feralas",
			startMap = { mapID = 1454, x = 0.482, y = 0.661 }, endMap = { mapID = 1444, x = 0.762, y = 0.438 },
			objective = "Talk to Talo Thornhoof at Camp Mojache in Feralas.",
		},
		{
			questID = 7494, name = "Feathermoon Stronghold", level = 57, requiredLevel = 54, faction = "Alliance",
			pickup = "Crier Goodman, Stormwind City",
			turnin = "Latronicus Moonspear, Feralas",
			startMap = { mapID = 1453, x = 0.564, y = 0.741 }, endMap = { mapID = 1444, x = 0.304, y = 0.462 },
			objective = "Talk to Latronicus Moonspear at Feathermoon Stronghold in Feralas.",
			note = "Also from Courier Hammerfall in Ironforge and Herald Moonstalker in Darnassus.",
		},
	},
})

Update("DireMaulNorth", {
	questPatches = {
		[5518] = { prerequisites = {} }, -- The Gordok Ogre Suit: its second part was given as its prerequisite
		[5525] = { requiredLevel = 56, prerequisites = {} }, -- Free Knot!, the same
		[5528] = { requiredLevel = 56 }, -- The Gordok Taste Test
	},
	addQuests = {
		{
			questID = 1193, name = "A Broken Trap", level = 60, requiredLevel = 56, faction = "Both",
			pickup = "Broken Trap, inside Dire Maul",
			turnin = "Broken Trap, inside Dire Maul",
			objective = "Fix the broken trap with a Thorium Widget and Frost Oil.",
		},
		{
			questID = 5519, name = "The Gordok Ogre Suit", level = 60, requiredLevel = 56, faction = "Both",
			pickup = "Knot Thimblejack, inside Dire Maul",
			turnin = "Knot Thimblejack, inside Dire Maul",
			objective = "Bring Knot 4 Bolts of Runecloth, 8 Rugged Leather, 2 Rune Thread and Ogre Tannin to get a Gordok Ogre Suit.",
			note = "Repeatable.",
			prerequisites = { { questID = 5518, name = "The Gordok Ogre Suit" } },
		},
		{
			questID = 7429, name = "Free Knot!", level = 60, requiredLevel = 56, faction = "Both",
			pickup = "Knot Thimblejack, inside Dire Maul",
			turnin = "Knot Thimblejack, inside Dire Maul",
			objective = "Bring Knot Thimblejack a Gordok Shackle Key to free him.",
			note = "Repeatable.",
			prerequisites = { { questID = 5525, name = "Free Knot!" } },
		},
		{
			questID = 7481, name = "Elven Legends", level = 60, requiredLevel = 54, faction = "Horde",
			pickup = "Sage Korolusk, Feralas",
			turnin = "Sage Korolusk, Feralas",
			startMap = { mapID = 1444, x = 0.752, y = 0.438 }, endMap = { mapID = 1444, x = 0.752, y = 0.438 },
			objective = "Look in Dire Maul for Kariel Winthalus and report back to Sage Korolusk.",
		},
		{
			questID = 7482, name = "Elven Legends", level = 60, requiredLevel = 54, faction = "Alliance",
			pickup = "Scholar Runethorn, Feralas",
			turnin = "Scholar Runethorn, Feralas",
			startMap = { mapID = 1444, x = 0.312, y = 0.439 }, endMap = { mapID = 1444, x = 0.312, y = 0.439 },
			objective = "Look in Dire Maul for Kariel Winthalus and report back to Scholar Runethorn.",
		},
		{
			questID = 7483, name = "Libram of Rapidity", level = 60, requiredLevel = 54, faction = "Both",
			pickup = "Lorekeeper Lydros, inside Dire Maul",
			turnin = "Lorekeeper Lydros, inside Dire Maul",
			objective = "Bring the Libram of Rapidity, a Pristine Black Diamond, 2 Large Brilliant Shards and 2 Blood of Heroes to Lorekeeper Lydros for an Arcanum of Rapidity.",
			note = "Repeatable.",
		},
		{
			questID = 7484, name = "Libram of Focus", level = 60, requiredLevel = 54, faction = "Both",
			pickup = "Lorekeeper Lydros, inside Dire Maul",
			turnin = "Lorekeeper Lydros, inside Dire Maul",
			objective = "Bring the Libram of Focus, a Pristine Black Diamond, 4 Large Brilliant Shards and 2 Skin of Shadow to Lorekeeper Lydros for an Arcanum of Focus.",
			note = "Repeatable.",
		},
		{
			questID = 7485, name = "Libram of Protection", level = 60, requiredLevel = 54, faction = "Both",
			pickup = "Lorekeeper Lydros, inside Dire Maul",
			turnin = "Lorekeeper Lydros, inside Dire Maul",
			objective = "Bring the Libram of Protection, a Pristine Black Diamond, 2 Large Brilliant Shards and a Frayed Abomination Stitching to Lorekeeper Lydros for an Arcanum of Protection.",
			note = "Repeatable.",
		},
	},
})

Update("DireMaulWest", {
	questPatches = {
		[5528] = { requiredLevel = 56 }, -- The Gordok Taste Test
	},
	addQuests = {
		{
			questID = 7481, name = "Elven Legends", level = 60, requiredLevel = 54, faction = "Horde",
			pickup = "Sage Korolusk, Feralas",
			turnin = "Sage Korolusk, Feralas",
			startMap = { mapID = 1444, x = 0.752, y = 0.438 }, endMap = { mapID = 1444, x = 0.752, y = 0.438 },
			objective = "Look in Dire Maul for Kariel Winthalus and report back to Sage Korolusk.",
		},
		{
			questID = 7482, name = "Elven Legends", level = 60, requiredLevel = 54, faction = "Alliance",
			pickup = "Scholar Runethorn, Feralas",
			turnin = "Scholar Runethorn, Feralas",
			startMap = { mapID = 1444, x = 0.312, y = 0.439 }, endMap = { mapID = 1444, x = 0.312, y = 0.439 },
			objective = "Look in Dire Maul for Kariel Winthalus and report back to Scholar Runethorn.",
		},
		{
			questID = 7483, name = "Libram of Rapidity", level = 60, requiredLevel = 54, faction = "Both",
			pickup = "Lorekeeper Lydros, inside Dire Maul",
			turnin = "Lorekeeper Lydros, inside Dire Maul",
			objective = "Bring the Libram of Rapidity, a Pristine Black Diamond, 2 Large Brilliant Shards and 2 Blood of Heroes to Lorekeeper Lydros for an Arcanum of Rapidity.",
			note = "Repeatable.",
		},
		{
			questID = 7484, name = "Libram of Focus", level = 60, requiredLevel = 54, faction = "Both",
			pickup = "Lorekeeper Lydros, inside Dire Maul",
			turnin = "Lorekeeper Lydros, inside Dire Maul",
			objective = "Bring the Libram of Focus, a Pristine Black Diamond, 4 Large Brilliant Shards and 2 Skin of Shadow to Lorekeeper Lydros for an Arcanum of Focus.",
			note = "Repeatable.",
		},
		{
			questID = 7485, name = "Libram of Protection", level = 60, requiredLevel = 54, faction = "Both",
			pickup = "Lorekeeper Lydros, inside Dire Maul",
			turnin = "Lorekeeper Lydros, inside Dire Maul",
			objective = "Bring the Libram of Protection, a Pristine Black Diamond, 2 Large Brilliant Shards and a Frayed Abomination Stitching to Lorekeeper Lydros for an Arcanum of Protection.",
			note = "Repeatable.",
		},
	},
})

Update("Scholomance", {
	addQuests = {
		{
			questID = 5582, name = "Healthy Dragon Scale", level = 58, requiredLevel = 55, faction = "Both",
			turnin = "Betina Bigglezink, Eastern Plaguelands",
			endMap = { mapID = 1423, x = 0.717, y = 0.499 },
			objective = "Take the Healthy Dragon Scale to Betina Bigglezink at Light's Hope Chapel.",
			note = "Starts from the Healthy Dragon Scale, dropped in Scholomance. Repeatable.",
			prerequisites = { { questID = 5529, name = "Plagued Hatchlings" } },
		},
	},
})

Update("StratholmeMainGate", {
	addQuests = {
		{
			questID = 5122, name = "The Medallion of Faith", level = 60, requiredLevel = 55, faction = "Both",
			pickup = "Aurius, inside Stratholme",
			turnin = "Aurius, inside Stratholme",
			objective = "Get the Medallion of Faith from Malor's Strongbox and bring it to Aurius.",
			note = "Malor's Strongbox is on the Scarlet side of Stratholme.",
		},
	},
})

Update("StratholmeServiceGate", {
	addQuests = {
		{
			questID = 5122, name = "The Medallion of Faith", level = 60, requiredLevel = 55, faction = "Both",
			pickup = "Aurius, inside Stratholme",
			turnin = "Aurius, inside Stratholme",
			objective = "Get the Medallion of Faith from Malor's Strongbox and bring it to Aurius.",
			note = "Malor's Strongbox is on the Scarlet side of Stratholme.",
		},
	},
})

Update("HallOfThanes", {
	questPatches = {
		[96403] = { faction = "Alliance" }, -- Important Heirlooms
	},
})

Update("RuinsOfLordaeron", {
	addQuests = {
		{
			questID = 97289, name = "Unending Torment", level = 21, requiredLevel = 16, faction = "Horde",
			note = "New in Forever: part 2, given in the Undercity once the Abominable Head is with Master Apothecary Faranell.",
			prerequisites = { { questID = 97288, name = "Unending Torment" } },
		},
		{
			questID = 97291, name = "Unending Torment", level = 21, requiredLevel = 16, faction = "Horde",
			note = "New in Forever: part 4, in the Undercity.",
			prerequisites = { { questID = 97288, name = "Unending Torment" }, { questID = 97289, name = "Unending Torment" }, { questID = 97290, name = "Unending Torment" } },
		},
		{
			questID = 97292, name = "Unending Torment", level = 21, requiredLevel = 16, faction = "Horde",
			note = "New in Forever: the last part, back to Master Apothecary Faranell in the Undercity.",
			prerequisites = { { questID = 97288, name = "Unending Torment" }, { questID = 97289, name = "Unending Torment" }, { questID = 97290, name = "Unending Torment" }, { questID = 97291, name = "Unending Torment" } },
		},
	},
})

--[[
	Quests the site files under a class, a profession or a zone rather than the dungeon, read on
	their own pages: done in the dungeon, so listed with it.
]]
Update("CityOfDalaran", {
	questPatches = { [92458] = { prerequisites = { { questID = 92432, name = "An Alarming Request" } } } },
})
Update("DireMaulEast", {
	addQuests = {
		{
			questID = 5526, name = "Shards of the Felvine", level = 60, requiredLevel = 56, faction = "Both",
			pickup = "Rabine Saturna, Nighthaven, Moonglade", turnin = "Rabine Saturna, Nighthaven, Moonglade",
			startMap = { mapID = 1450, x = 0.517, y = 0.451 }, endMap = { mapID = 1450, x = 0.517, y = 0.451 },
			objective = "Take a shard of the Felvine once Alzzin the Wildshaper falls, seal it in the Reliquary of Purity and bring it to Rabine Saturna.",
			prerequisites = { { questID = 5527, name = "A Reliquary of Purity" } },
		},
	},
})
Update("LowerBlackrockSpire", {
	addQuests = {
		{
			questID = 5306, name = "Snakestone of the Shadow Huntress", level = 60, requiredLevel = 50, faction = "Both",
			pickup = "Kilram, Everlook, Winterspring", turnin = "Kilram, Everlook, Winterspring",
			startMap = { mapID = 1452, x = 0.613, y = 0.371 }, endMap = { mapID = 1452, x = 0.613, y = 0.371 },
			objective = "Kill Shadow Hunter Vosh'gajin and bring her Snakestone to Kilram.",
			note = "For blacksmiths with a skill of 250.",
		},
	},
})
Update("TempleOfAtalHakkar", {
	addQuests = {
		{
			questID = 8232, name = "The Green Drake", level = 52, requiredLevel = 50, faction = "Both", classOnly = "HUNTER",
			pickup = "Ogtinc, Azshara", turnin = "Ogtinc, Azshara",
			startMap = { mapID = 1447, x = 0.424, y = 0.426 }, endMap = { mapID = 1447, x = 0.424, y = 0.426 },
			objective = "Kill the green drake Morphaz and bring his tooth to Ogtinc.",
		},
		{
			questID = 8236, name = "The Azure Key", level = 52, requiredLevel = 50, faction = "Both", classOnly = "ROGUE",
			pickup = "Archmage Xylem, Azshara", turnin = "Lord Jorach Ravenholdt, Ravenholdt Manor, Alterac Mountains",
			startMap = { mapID = 1447, x = 0.292, y = 0.402 }, endMap = { mapID = 1416, x = 0.860, y = 0.789 },
			objective = "Take the Azure Key, which Morphaz carries, to Lord Jorach Ravenholdt.",
		},
		{
			questID = 8253, name = "Destroy Morphaz", level = 52, requiredLevel = 50, faction = "Both", classOnly = "MAGE",
			pickup = "Archmage Xylem, Azshara", turnin = "Archmage Xylem, Azshara",
			startMap = { mapID = 1447, x = 0.292, y = 0.402 }, endMap = { mapID = 1447, x = 0.292, y = 0.402 },
			objective = "Take the Arcane Shard from Morphaz and bring it back to Archmage Xylem.",
		},
		{
			questID = 8257, name = "Blood of Morphaz", level = 52, requiredLevel = 50, faction = "Both", classOnly = "PRIEST",
			pickup = "Ogtinc, Azshara", turnin = "Greta Mosshoof, Felwood",
			startMap = { mapID = 1447, x = 0.424, y = 0.426 }, endMap = { mapID = 1448, x = 0.512, y = 0.821 },
			objective = "Kill Morphaz and take his blood to Greta Mosshoof in Felwood.",
		},
		{
			questID = 8413, name = "Da Voodoo", level = 52, requiredLevel = 50, faction = "Horde", classOnly = "SHAMAN",
			pickup = "Bath'rah the Windwatcher, Alterac Mountains", turnin = "Bath'rah the Windwatcher, Alterac Mountains",
			startMap = { mapID = 1416, x = 0.805, y = 0.669 }, endMap = { mapID = 1416, x = 0.805, y = 0.669 },
			objective = "Bring Bath'rah voodoo feathers from the temple's troll leaders.",
		},
		{
			questID = 8418, name = "Forging the Mightstone", level = 52, requiredLevel = 50, faction = "Alliance", classOnly = "PALADIN",
			pickup = "Commander Ashlam Valorfist, Chillwind Camp, Western Plaguelands",
			turnin = "Commander Ashlam Valorfist, Chillwind Camp, Western Plaguelands",
			startMap = { mapID = 1422, x = 0.427, y = 0.840 }, endMap = { mapID = 1422, x = 0.427, y = 0.840 },
			objective = "Bring Ashlam Valorfist voodoo feathers from the temple's troll leaders.",
		},
		{
			questID = 8422, name = "Trolls of a Feather", level = 52, requiredLevel = 50, faction = "Both", classOnly = "WARLOCK",
			pickup = "Impsy, Felwood", turnin = "Impsy, Felwood",
			startMap = { mapID = 1448, x = 0.415, y = 0.450 }, endMap = { mapID = 1448, x = 0.415, y = 0.450 },
			objective = "Bring Impsy six voodoo feathers from the temple's troll leaders.",
		},
		{
			questID = 8425, name = "Voodoo Feathers", level = 52, requiredLevel = 50, faction = "Both", classOnly = "WARRIOR",
			pickup = "Fallen Hero of the Horde, Swamp of Sorrows", turnin = "Fallen Hero of the Horde, Swamp of Sorrows",
			startMap = { mapID = 1435, x = 0.343, y = 0.661 }, endMap = { mapID = 1435, x = 0.343, y = 0.661 },
			objective = "Bring the Fallen Hero of the Horde voodoo feathers from the temple's troll leaders.",
		},
	},
})
