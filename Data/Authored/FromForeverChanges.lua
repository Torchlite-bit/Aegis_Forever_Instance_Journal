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