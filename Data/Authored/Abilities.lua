local _, ns = ...

--[[
	Each boss's abilities, as foreverchanges.pro lists them (2026-10-11), for the 16 dungeons
	whose pages have them: the spells (id, name, role alerts, what each does in the fight), the
	mechanics with no spell, and, where the fight begins in an unusual way, how (fightNote, above
	the Abilities tab). The game supplies the spells' icons; the damage and timings come only from
	recorded runs (Data/Generated/Abilities.lua), joined to these by spell id.

	Loads after the dungeons' own authored files, so a boss's abilities here replace theirs.
]]

local ICONS = "Interface\\Icons\\"

ns.AmendInstance("RagefireChasm", { bosses = {
	["Oggleflint"] = {
		abilities = {
			{ spellID = 5532, name = "Cleave", flags = { "Tank" },
				text = "Hits his target and the player nearest to it." },
		},
	},
	["Taragaman the Hungerer"] = {
		abilities = {
			{ spellID = 11970, name = "Fire Nova", flags = { "Healer" },
				text = "Fire damage to everyone near him, several times a fight. Healers, keep the melee topped up." },
			{ spellID = 18072, name = "Uppercut", flags = { "Tank" },
				text = "A heavy blow that knocks the tank back." },
		},
	},
	["Jergosh the Invoker"] = {
		abilities = {
			{ spellID = 20800, name = "Immolate", flags = { "Interruptible", "Magic" },
				text = "Burns a player, then Fire damage every few seconds for 21 seconds. Interrupt the cast or dispel the burn." },
			{ spellID = 18267, name = "Curse of Weakness", flags = { "Curse" },
				text = "Lowers a player's Physical damage for 30 seconds. A mage or a druid can remove it." },
		},
	},
	["Bazzalan"] = {
		abilities = {
			{ spellID = 744, name = "Poison", flags = { "Poison" },
				text = "His blows poison: Nature damage over time. Cure it if you can." },
			{ spellID = 14873, name = "Sinister Strike", flags = { "Tank" },
				text = "Extra damage on the tank every 5 to 15 seconds." },
		},
	},
} })

ns.AmendInstance("WailingCaverns", { bosses = {
	["Lord Cobrahn"] = {
		abilities = {
			{ spellID = 9532, name = "Lightning Bolt", flags = { "Interruptible" },
				text = "He keeps his distance to cast it. Interrupt it." },
			{ spellID = 5188, name = "Healing Touch", flags = { "Interruptible" },
				text = "Heals himself or an ally (3-second cast). Interrupt it." },
			{ spellID = 7965, name = "Cobrahn Serpent Form", flags = { "Tank", "Important" },
				text = "At 30% health he turns into a serpent: slower but heavier blows, and he starts putting players to sleep." },
		},
	},
	["Lady Anacondra"] = {
		abilities = {
			{ spellID = 5187, name = "Healing Touch", flags = { "Interruptible" },
				text = "Heals herself or an ally. Interrupt it." },
			{ spellID = 700, name = "Sleep", flags = { "Magic" },
				text = "Puts a player to sleep for up to 20 seconds. Damage wakes them, and a Magic dispel removes it." },
			{ spellID = 8148, name = "Thorns Aura", flags = { "Damage" },
				text = "Nature damage to whoever hits her in melee." },
		},
	},
	["Lord Pythas"] = {
		abilities = {
			{ spellID = 8147, name = "Thunderclap", flags = { "Healer", "Magic" },
				text = "Nature damage to everyone near him, then slower attacks and movement for 10 seconds." },
			{ spellID = 5187, name = "Healing Touch", flags = { "Interruptible" },
				text = "Heals himself or an ally. Interrupt it." },
			{ spellID = 700, name = "Sleep", flags = { "Magic" },
				text = "Puts a player to sleep for up to 20 seconds." },
		},
	},
	["Kresh"] = {
		abilities = {
			{ spellID = 26064, name = "Shell Shield", flags = { "Damage" },
				text = "For 12 seconds he takes 60% less damage, and attacks slower but harder." },
		},
	},
	["Skum"] = {
		abilities = {
			{ spellID = 6254, name = "Chained Bolt", flags = { "Interruptible" },
				text = "A lightning bolt that jumps to a second player. Interrupt it." },
		},
	},
	["Lord Serpentis"] = {
		abilities = {
			{ spellID = 6778, name = "Healing Touch", flags = { "Interruptible" },
				text = "A slow heal (3.5 seconds) on himself or an ally. Interrupt it." },
			{ spellID = 700, name = "Sleep", flags = { "Magic" },
				text = "Puts a player to sleep for up to 20 seconds." },
			{ spellID = 9532, name = "Lightning Bolt", flags = { "Interruptible" },
				text = "He keeps his distance to cast it. Interrupt it." },
		},
	},
	["Verdan the Everliving"] = {
		abilities = {
			{ spellID = 8142, name = "Grasping Vines", flags = { "Important" },
				text = "When his target is close, he knocks down and roots everyone near him for 10 seconds. Ranged players, keep your distance." },
		},
	},
	["Mutanus the Devourer"] = {
		abilities = {
			{ spellID = 8150, name = "Thundercrack", flags = { "Healer" },
				text = "Nature damage to everyone near him and a 2.5-second stun." },
			{ spellID = 7967, name = "Naralex's Nightmare", flags = { "Magic", "Interruptible" },
				text = "Puts a player to sleep for up to 15 seconds." },
			{ spellID = 7399, name = "Terrify", flags = { "Magic" },
				text = "Makes a player flee in fear for 4 seconds." },
		},
		fightNote = "Kill Lady Anacondra, Lord Cobrahn, Lord Pythas and Lord Serpentis, then talk to the Disciple of Naralex at the entrance and escort him to Naralex. Protect him during the ritual: Mutanus comes at the end.",
	},
} })

ns.AmendInstance("TheDeadmines", { bosses = {
	["Rhahk'Zor"] = {
		abilities = {
			{ spellID = 6304, name = "Rhahk'Zor Slam", flags = { "Tank" },
				text = "Hits the tank hard and stuns them for 3 seconds." },
		},
	},
	["Miner Johnson"] = {
		abilities = {
			{ spellID = 12097, name = "Pierce Armor", flags = { "Tank" },
				text = "Cuts the tank's armor by 75% for 20 seconds." },
		},
		extraAbilities = {
			{ title = "Runs for help", icon = ICONS .. "ability_rogue_sprint", flags = { "Important" },
				description = "At 15% health he runs off to bring help. Finish him before he gets away." },
		},
	},
	["Sneed's Shredder"] = {
		abilities = {
			{ spellID = 7399, name = "Terrify", flags = { "Magic" },
				text = "Makes a player flee in fear for 4 seconds." },
			{ spellID = 3603, name = "Distracting Pain", flags = { "Healer" },
				text = "Slows a player's casting by 35% for 15 seconds." },
		},
	},
	["Sneed"] = {
		abilities = {
			{ spellID = 6713, name = "Disarm", flags = { "Tank" },
				text = "Disarms the tank for 6 seconds." },
		},
		fightNote = "He pilots Sneed's Shredder and climbs out when it is destroyed.",
	},
	["Gilnid"] = {
		abilities = {
			{ spellID = 5213, name = "Molten Metal", flags = { "Interruptible", "Healer" },
				text = "Fire damage every 3 seconds for 15 seconds, with slower attacks and movement. Interrupt the 2-second cast." },
		},
	},
	["Mr. Smite"] = {
		abilities = {
			{ spellID = 6432, name = "Smite Stomp", flags = { "Important" },
				text = "At 66% and again at 33% health he stuns everyone around him, then walks to his chest to change weapons." },
			{ spellID = 12787, name = "Thrash", flags = { "Tank" },
				text = "With his two axes, from 66% health: extra attacks on the tank." },
			{ spellID = 6435, name = "Smite Slam", flags = { "Tank" },
				text = "With his hammer, below 33% health: a heavy blow that stuns the tank for 3 seconds." },
		},
	},
	["Captain Greenskin"] = {
		abilities = {
			{ spellID = 5208, name = "Poisoned Harpoon", flags = { "Poison", "Interruptible" },
				text = "A 2-second cast: a hit, then Nature damage for a minute. Cure the poison." },
			{ spellID = 5532, name = "Cleave", flags = { "Tank" },
				text = "Hits his target and the player nearest to it." },
		},
	},
	["Edwin VanCleef"] = {
		abilities = {
			{ spellID = 12787, name = "Thrash", flags = { "Tank" },
				text = "Now and then two extra attacks: heavy hits on the tank." },
			{ spellID = 5200, name = "VanCleef's Allies", flags = { "Important" },
				text = "At half health he calls two Defias Blackguards." },
		},
	},
	["Cookie"] = {
		abilities = {
			{ spellID = 6306, name = "Acid Splash", flags = { "Healer" },
				text = "Nature damage every 5 seconds for 30 seconds to everyone near him." },
			{ spellID = 5174, name = "Cookie's Cooking", flags = { "Interruptible" },
				text = "Below half health he heals himself (2-second cast). Interrupt it." },
		},
		extraAbilities = {
			{ title = "Runs for help", icon = ICONS .. "ability_rogue_sprint", flags = { "Important" },
				description = "At 15% health he runs off to bring help. Finish him before he gets away." },
		},
	},
} })

ns.AmendInstance("ShadowfangKeep", { bosses = {
	["Rethilgore"] = {
		abilities = {
			{ spellID = 7295, name = "Soul Drain", flags = { "Magic", "Interruptible" },
				text = "Roots a player for 10 seconds and drains their health into his. Interrupt the 2-second cast or dispel it." },
		},
	},
	["Fel Steed / Shadow Charger"] = {
		abilities = {
			{ spellID = 7139, name = "Fel Stomp", flags = { "Healer" },
				text = "The Fel Steed stuns everyone near it for 3 seconds, and they take more Physical damage. The Shadow Charger has no ability." },
		},
	},
	["Razorclaw the Butcher"] = {
		abilities = {
			{ spellID = 7485, name = "Butcher Drain", flags = { "Tank" },
				text = "Drains 350 mana from his target in melee: a tank with mana feels it." },
		},
	},
	["Baron Silverlaine"] = {
		abilities = {
			{ spellID = 7068, name = "Veil of Shadow", flags = { "Curse", "Healer" },
				text = "Curses a player: healing on them is 75% weaker for 15 seconds. Remove it, above all from the tank." },
		},
	},
	["Commander Springvale"] = {
		abilities = {
			{ spellID = 1026, name = "Holy Light", flags = { "Interruptible" },
				text = "Heals himself or an ally (2.5-second cast). Interrupt it." },
			{ spellID = 642, name = "Divine Shield", flags = { "Important" },
				text = "Makes him immune to all damage and spells for 10 seconds." },
			{ spellID = 5588, name = "Hammer of Justice", flags = { "Magic" },
				text = "Stuns a player for 4 seconds." },
		},
	},
	["Odo the Blindwatcher"] = {
		abilities = {
			{ spellID = 7481, name = "Howling Rage", flags = { "Enrage", "Tank" },
				text = "At 60%, 40% and 20% health his blows grow stronger." },
		},
		extraAbilities = {
			{ title = "Calls for help", icon = ICONS .. "ability_warrior_rallyingcry", flags = { "Important" },
				description = "When pulled, he calls the creatures within 30 yards to join him. Clear around him first." },
		},
	},
	["Deathsworn Captain"] = {
		abilities = {
			{ spellID = 5532, name = "Cleave", flags = { "Tank" },
				text = "Hits his target and the player nearest to it." },
			{ spellID = 9080, name = "Hamstring", flags = { "Tank" },
				text = "Slows his target's movement for 10 seconds." },
		},
	},
	["Arugal's Voidwalker"] = {
		abilities = {
			{ spellID = 7154, name = "Dark Offering", flags = { "Damage" },
				text = "Heals another voidwalker. Bring them down one at a time." },
		},
		fightNote = "Four of them come after Fenrus the Devourer dies: Arugal appears for a moment and calls them.",
	},
	["Fenrus the Devourer"] = {
		abilities = {
			{ spellID = 7125, name = "Toxic Saliva", flags = { "Poison" },
				text = "Nature damage every 6 seconds and drained mana, for 2 minutes. Cure the poison." },
		},
	},
	["Wolf Master Nandos"] = {
		extraAbilities = {
			{ title = "More worgs", icon = ICONS .. "ability_hunter_pet_wolf", flags = { "Damage", "Important" },
				description = "The longer the fight, the more worgs join him: a Bleak Worg after 30 to 45 seconds, then a Slavering Worg, then a Lupine Horror." },
		},
	},
	["Archmage Arugal"] = {
		abilities = {
			{ spellID = 7588, name = "Void Bolt", flags = { "Interruptible" },
				text = "A 3-second Shadow bolt on the tank, over and over. Interrupt it." },
			{ spellID = 7621, name = "Arugal's Curse", flags = { "Curse", "Important" },
				text = "Turns a player other than the tank into a Shadowfang Glutton that fights for him for 10 seconds. Remove the curse." },
			{ spellID = 7587, name = "Shadow Port", flags = { "Important" },
				text = "He teleports between his ledge, the upper ledge and the stairs." },
			{ spellID = 7803, name = "Thundershock", flags = { "Tank" },
				text = "When the tank reaches him: Nature damage and a 5-second stun around him." },
		},
	},
} })

ns.AmendInstance("BlackfathomDeeps", { bosses = {
	["Ghamoo-ra"] = {
		abilities = {
			{ spellID = 5568, name = "Trample", flags = { "Tank" },
				text = "Hits everyone standing close." },
		},
	},
	["Lady Sarevess"] = {
		abilities = {
			{ spellID = 8435, name = "Forked Lightning", flags = { "Interruptible" },
				text = "Nature damage in a cone in front of her (2-second cast). Stay out of the cone." },
			{ spellID = 865, name = "Frost Nova", flags = { "Magic" },
				text = "Freezes everyone near her in place for up to 8 seconds." },
			{ spellID = 246, name = "Slow", flags = { "Magic" },
				text = "Slows a player's movement and attacks for 10 seconds." },
		},
	},
	["Gelihast"] = {
		abilities = {
			{ spellID = 6533, name = "Net",
				text = "Roots a player in place for 10 seconds." },
		},
	},
	["Lorgus Jett"] = {
		abilities = {
			{ spellID = 12550, name = "Lightning Shield", flags = { "Magic" },
				text = "Lightning strikes whoever hits him. A priest or a shaman can remove it." },
			{ spellID = 12167, name = "Lightning Bolt", flags = { "Interruptible" },
				text = "He keeps his distance to cast it. Interrupt it." },
		},
	},
	["Baron Aquanis"] = {
		abilities = {
			{ spellID = 15043, name = "Frostbolt", flags = { "Interruptible", "Magic" },
				text = "He keeps his distance to cast it: Frost damage and a slow." },
			{ spellID = 15531, name = "Frost Nova", flags = { "Magic" },
				text = "Roots everyone near him for up to 8 seconds." },
		},
		fightNote = "Click the Fathom Stone in the water: he rises from it.",
	},
	["Twilight Lord Kelris"] = {
		abilities = {
			{ spellID = 8399, name = "Sleep", flags = { "Magic", "Important" },
				text = "Puts everyone near him to sleep for up to 10 seconds. Damage wakes a sleeper." },
			{ spellID = 15587, name = "Mind Blast", flags = { "Interruptible" },
				text = "Shadow damage on a player (1.5-second cast)." },
		},
	},
	["Old Serra'kis"] = {
		fightNote = "He waits in an underwater cave below Twilight Lord Kelris's temple, where groups often miss him. Swim under the temple to reach him.",
	},
	["Aku'mai"] = {
		abilities = {
			{ spellID = 3815, name = "Poison Cloud", flags = { "Poison", "Healer" },
				text = "Nature damage every 5 seconds for 45 seconds to everyone nearby." },
			{ spellID = 3490, name = "Frenzied Rage", flags = { "Enrage", "Tank" },
				text = "Below 30% health: bursts of attacks 75% faster, over and over." },
		},
		fightNote = "Once Twilight Lord Kelris is dead, light the four Fires of Aku'mai in his room, one after the other. Each one brings a wave of creatures. When all are dead, the door to Aku'mai opens.",
	},
} })

ns.AmendInstance("TheStockade", { bosses = {
	["Kam Deepfury"] = {
		abilities = {
			{ spellID = 8242, name = "Shield Slam", flags = { "Tank" },
				text = "Hits the tank and stuns them for 2 seconds." },
		},
		extraAbilities = {
			{ title = "Runs for help", icon = ICONS .. "ability_rogue_sprint", flags = { "Important" },
				description = "At 15% health he runs off to bring help. Finish him before he gets away." },
		},
	},
	["Bruegal Ironknuckle"] = {
		extraAbilities = {
			{ title = "Runs for help", icon = ICONS .. "ability_rogue_sprint", flags = { "Important" },
				description = "At 15% health he runs off to bring help. Finish him before he gets away." },
		},
	},
	["Targorr the Dread"] = {
		abilities = {
			{ spellID = 8876, name = "Thrash", flags = { "Tank" },
				text = "Now and then two extra attacks: heavy hits on the tank." },
			{ spellID = 8599, name = "Enrage", flags = { "Enrage", "Tank" },
				text = "At 30% health he attacks 30% faster for the rest of the fight." },
		},
	},
	["Hamhock"] = {
		abilities = {
			{ spellID = 421, name = "Chain Lightning", flags = { "Interruptible" },
				text = "Lightning that jumps from player to player (2-second cast). Interrupt it." },
			{ spellID = 6742, name = "Bloodlust", flags = { "Magic" },
				text = "Speeds up his or an ally's attacks by 30% for 30 seconds. A priest or a shaman can remove it." },
		},
	},
	["Bazil Thredd"] = {
		abilities = {
			{ spellID = 7964, name = "Smoke Bomb", flags = { "Important" },
				text = "Stuns everyone near him for 4 seconds." },
			{ spellID = 9128, name = "Battle Shout",
				text = "More attack power for him and his allies for 2 minutes." },
		},
		extraAbilities = {
			{ title = "Runs for help", icon = ICONS .. "ability_rogue_sprint", flags = { "Important" },
				description = "At 15% health he runs off to bring help. Finish him before he gets away." },
		},
	},
} })

ns.AmendInstance("Gnomeregan", { bosses = {
	["Techbot"] = {
		abilities = {
			{ spellID = 10852, name = "Battle Net", flags = { "Important" },
				text = "Roots everyone near it for 10 seconds." },
			{ spellID = 10855, name = "Lag", flags = { "Magic" },
				text = "Slows a player's attacks and movement for 10 seconds, and can stun them." },
			{ spellID = 10858, name = "Summon Dupe Bug", flags = { "Damage" },
				text = "Calls Dupe Bugs to its side. Its Patch kills them and heals it." },
		},
	},
	["Grubbis"] = {
		fightNote = "Talk to Blastmaster Emi Shortfuse and protect her while she blows up the two cave mouths. Troggs pour out in waves, then Grubbis comes with Chomper.",
	},
	["Electrocutioner 6000"] = {
		abilities = {
			{ spellID = 11082, name = "Megavolt", flags = { "Interruptible" },
				text = "Nature damage in a cone in front of it (2-second cast). Only the tank in front." },
			{ spellID = 11085, name = "Chain Bolt", flags = { "Interruptible" },
				text = "Lightning that jumps to nearby players (2.5-second cast). Interrupt it." },
		},
	},
	["Crowd Pummeler 9-60"] = {
		abilities = {
			{ spellID = 10887, name = "Crowd Pummel", flags = { "Important" },
				text = "Hits everyone near it and interrupts their spells. Casters and healers, keep your distance." },
			{ spellID = 8374, name = "Arcing Smash", flags = { "Tank" },
				text = "Hits everyone in a cone in front of it." },
			{ spellID = 5568, name = "Trample",
				text = "Hits everyone standing close." },
		},
	},
	["Dark Iron Ambassador"] = {
		abilities = {
			{ spellID = 10870, name = "Summon Burning Servant", flags = { "Damage" },
				text = "Calls two Burning Servants at the start of the fight." },
			{ spellID = 9053, name = "Fireball", flags = { "Interruptible" },
				text = "He keeps his distance to cast it. Interrupt it." },
			{ spellID = 184, name = "Fire Shield II", flags = { "Magic" },
				text = "Fire damage to everyone near him for a minute. A priest or a shaman can remove it." },
		},
	},
	["Mekgineer Thermaplugg"] = {
		abilities = {
			{ spellID = 10101, name = "Knock Away", flags = { "Tank" },
				text = "Knocks the tank back. Below half health it hits everyone around him." },
		},
		extraAbilities = {
			{ title = "Walking Bombs", icon = ICONS .. "spell_fire_selfdestruct", flags = { "Important", "Deadly" },
				description = "He switches on the gnome faces around the room one by one, and each sends out Walking Bombs that explode when they reach a player. The button next to a face switches it off. Below half health he switches them on faster." },
		},
	},
} })

ns.AmendInstance("RazorfenKraul", { bosses = {
	["Aggem Thorncurse"] = {
		abilities = {
			{ spellID = 8286, name = "Summon Boar Spirit", flags = { "Damage" },
				text = "Calls a Boar Spirit to fight beside him every 30 to 45 seconds (1.5-second cast). Kill each one before the next comes." },
			{ spellID = 14900, name = "Chain Heal", flags = { "Interruptible", "Important" },
				text = "Below 75% health he heals himself, and the heal jumps to two allies near him (2.5-second cast). Interrupt it." },
		},
	},
	["Death Speaker Jargba"] = {
		abilities = {
			{ spellID = 14515, name = "Dominate Mind", flags = { "Important", "Interruptible", "Magic" },
				text = "Takes control of a player other than his target for 15 seconds (2-second cast). Interrupt it, or dispel it from the player." },
			{ spellID = 9613, name = "Shadow Bolt", flags = { "Interruptible" },
				text = "He keeps his distance to cast it. Interrupt it." },
		},
	},
	["Roogug"] = {
		abilities = {
			{ spellID = 8270, name = "Summon Earth Rumbler", flags = { "Damage" },
				text = "A Stone Rumbler stands with him and fights at his side." },
			{ spellID = 9532, name = "Lightning Bolt", flags = { "Interruptible" },
				text = "He keeps his distance to cast it. Interrupt it." },
		},
	},
	["Overlord Ramtusk"] = {
		abilities = {
			{ spellID = 15548, name = "Thunderclap", flags = { "Tank", "Healer", "Magic" },
				text = "Every 8 to 14 seconds: Nature damage to everyone near him, and their attacks and movement are slowed for 10 seconds." },
		},
		extraAbilities = {
			{ title = "Calls for help", icon = ICONS .. "ability_warrior_rallyingcry", flags = { "Important" },
				description = "When pulled, he calls the creatures within 15 yards to join him, the two Razorfen Spearhides at his side among them. Crowd-control one of them." },
		},
	},
	["Razorfen Spearhide"] = {
		abilities = {
			{ spellID = 8259, name = "Whirling Barrage", flags = { "Tank" },
				text = "Hits everyone standing close." },
			{ spellID = 8148, name = "Thorns Aura", flags = { "Tank", "Damage" },
				text = "Whoever strikes him or an ally near him, Overlord Ramtusk included, takes Nature damage." },
		},
	},
	["Agathelos the Raging"] = {
		abilities = {
			{ spellID = 8555, name = "Left for Dead", flags = { "Important" },
				text = "Every 21 to 35 seconds he strikes a player other than his target, who falls as if dead and can neither attack nor cast. Moving ends it." },
			{ spellID = 8285, name = "Rampage", flags = { "Tank", "Healer" },
				text = "Every 25 to 31 seconds: hits everyone near him and stuns them for 2.5 seconds." },
			{ spellID = 8269, name = "Enrage", flags = { "Enrage", "Tank" },
				text = "At 60% health, and again at 40%, he attacks 60% faster and hits harder for 2 minutes." },
		},
		fightNote = "A ward closes his cave. Kill the two Death's Head Ward Keepers standing in front of it: the ward goes down when both are dead.",
	},
	["Blind Hunter"] = {
		fightNote = "A rare bat, not there on every run. When it is, it waits in a small recess in the wall of the bat cave near Charlga Razorflank.",
	},
	["Charlga Razorflank"] = {
		abilities = {
			{ spellID = 8292, name = "Chain Bolt", flags = { "Interruptible" },
				text = "She keeps her distance and casts it again and again: lightning that jumps to up to 3 players (2.5-second cast). Interrupt it." },
			{ spellID = 8361, name = "Purity", flags = { "Important" },
				text = "Every 9 to 15 seconds she is immune to all attacks and spells for 2 seconds." },
			{ spellID = 6077, name = "Renew", flags = { "Magic" },
				text = "Heals a wounded ally, or herself, over 15 seconds. A priest or a shaman can remove it." },
		},
	},
	["Earthcaller Halmgar"] = {
		abilities = {
			{ spellID = 8270, name = "Summon Earth Rumbler", flags = { "Damage" },
				text = "A Stone Rumbler stands with him and fights at his side." },
			{ spellID = 9532, name = "Lightning Bolt", flags = { "Interruptible" },
				text = "He keeps his distance to cast it. Interrupt it." },
		},
		extraAbilities = {
			{ title = "Runs for help", icon = ICONS .. "ability_rogue_sprint", flags = { "Important" },
				description = "At 15% health he runs off to bring help. Finish him before he gets away." },
		},
	},
} })

ns.AmendInstance("ScarletMonasteryGraveyard", { bosses = {
	["Interrogator Vishas"] = {
		abilities = {
			{ spellID = 2767, name = "Shadow Word: Pain", flags = { "Magic" },
				text = "Shadow damage to his target every 3 seconds for 18 seconds. A Magic dispel removes it." },
		},
	},
	["Azshir the Sleepless"] = {
		abilities = {
			{ spellID = 5137, name = "Call of the Grave", flags = { "Curse" },
				text = "After 60 seconds, Shadow damage to the player (2-second cast). A mage or a druid can remove it before then." },
			{ spellID = 7399, name = "Terrify", flags = { "Magic" },
				text = "Makes a player flee in fear for 4 seconds." },
			{ spellID = 9373, name = "Soul Siphon", flags = { "Healer" },
				text = "Below half health he drains a player and the player nearest to them for 12 seconds, and heals himself." },
		},
		fightNote = "About one run in three, one of the graveyard's three rares stands at one of the six places on the map: Azshir the Sleepless, Fallen Champion or Ironspine.",
	},
	["Fallen Champion"] = {
		abilities = {
			{ spellID = 15496, name = "Cleave", flags = { "Tank" },
				text = "Hits his target and the player nearest to it." },
			{ spellID = 7160, name = "Execute", flags = { "Tank", "Healer" },
				text = "Strikes hard at a target down to 20% health or less. Keep the tank above it." },
		},
		fightNote = "About one run in three, one of the graveyard's three rares stands at one of the six places on the map: Azshir the Sleepless, Fallen Champion or Ironspine.",
	},
	["Ironspine"] = {
		abilities = {
			{ spellID = 21007, name = "Curse of Weakness", flags = { "Curse" },
				text = "Lowers the Physical damage of everyone within 30 yards for 2 minutes. A mage or a druid can remove it." },
			{ spellID = 3815, name = "Poison Cloud", flags = { "Poison", "Healer" },
				text = "Nature damage every 5 seconds for 45 seconds to everyone nearby." },
		},
		fightNote = "About one run in three, one of the graveyard's three rares stands at one of the six places on the map: Azshir the Sleepless, Fallen Champion or Ironspine.",
	},
	["Bloodmage Thalnos"] = {
		abilities = {
			{ spellID = 8814, name = "Flame Spike", flags = { "Damage" },
				text = "A pillar of flame where a player stands (3-second cast): Fire damage, then more every 3 seconds for 9 seconds. Step out of it." },
			{ spellID = 12470, name = "Fire Nova", flags = { "Damage" },
				text = "Fire damage to everyone within 10 yards of him." },
			{ spellID = 8053, name = "Flame Shock", flags = { "Magic" },
				text = "Fire damage to a player, then more every 3 seconds for 12 seconds. A Magic dispel removes it." },
			{ spellID = 9613, name = "Shadow Bolt", flags = { "Interruptible" },
				text = "He keeps his distance to cast it. Interrupt it." },
		},
	},
} })

ns.AmendInstance("ScarletMonasteryLibrary", { bosses = {
	["Houndmaster Loksey"] = {
		abilities = {
			{ spellID = 6742, name = "Bloodlust", flags = { "Magic" },
				text = "Speeds up his or an ally's attacks by 30% for 30 seconds. A priest or a shaman can remove it." },
			{ spellID = 6192, name = "Battle Shout",
				text = "More attack power for him and his hounds for 3 minutes." },
		},
		extraAbilities = {
			{ title = "Scarlet Tracking Hounds", icon = ICONS .. "ability_hunter_beastcall", flags = { "Damage" },
				description = "Three hounds stand at his side and attack with him, and he gives them Bloodlust too. Kill them first." },
		},
	},
	["Arcanist Doan"] = {
		abilities = {
			{ spellID = 9435, name = "Detonation", flags = { "Deadly", "Important" },
				text = "At half health he shuts himself in an Arcane Bubble for 8 seconds and casts it (5-second cast): heavy Fire damage to everyone within 30 yards. Get out of range before it goes off, then come back." },
			{ spellID = 13323, name = "Polymorph", flags = { "Interruptible", "Magic" },
				text = "Turns a player other than his target into a sheep for up to 20 seconds (1.5-second cast). Interrupt it, or dispel it from the player." },
			{ spellID = 8988, name = "Silence", flags = { "Healer", "Interruptible" },
				text = "Silences everyone within 15 yards for 10 seconds (1.5-second cast). Healers, stand further back." },
			{ spellID = 9433, name = "Arcane Explosion", flags = { "Damage" },
				text = "Every few seconds, Arcane damage to everyone within 10 yards. Ranged players, keep your distance." },
		},
	},
} })

ns.AmendInstance("ScarletMonasteryArmory", { bosses = {
	["Herod"] = {
		abilities = {
			{ spellID = 8989, name = "Whirlwind", flags = { "Deadly", "Damage" },
				text = "Every 15 to 25 seconds he spins for 10 seconds, hitting everyone near him. Melee, step back until it ends." },
			{ spellID = 22540, name = "Cleave", flags = { "Tank" },
				text = "Hits his target and the player nearest to it." },
			{ spellID = 8269, name = "Enrage", flags = { "Enrage", "Tank" },
				text = "At 30% health he attacks 60% faster and hits harder for 2 minutes." },
		},
		extraAbilities = {
			{ title = "Scarlet Trainees", icon = ICONS .. "inv_sword_04", flags = { "Important" },
				description = "When he dies, 20 Scarlet Trainees run in through the hall's door and attack. Stay together and use area damage." },
		},
	},
} })

ns.AmendInstance("ScarletMonasteryCathedral", { bosses = {
	["High Inquisitor Fairbanks"] = {
		abilities = {
			{ spellID = 12096, name = "Fear", flags = { "Magic", "Interruptible" },
				text = "Makes a player flee in terror for up to 8 seconds (1.5-second cast). Interrupt it." },
			{ spellID = 8399, name = "Sleep", flags = { "Magic", "Important" },
				text = "Puts everyone near him to sleep for up to 10 seconds. Damage wakes a sleeper." },
			{ spellID = 8282, name = "Curse of Blood", flags = { "Curse" },
				text = "A player takes more Physical damage for 10 minutes (2-second cast). A mage or a druid can remove it." },
			{ spellID = 12039, name = "Heal", flags = { "Interruptible" },
				text = "At 30% health he heals himself (3-second cast). Interrupt it." },
		},
		fightNote = "He lies on the floor of the small room beside the altar, as if dead, and gets up when attacked.",
	},
	["Scarlet Commander Mograine"] = {
		abilities = {
			{ spellID = 5589, name = "Hammer of Justice", flags = { "Magic" },
				text = "Stuns a player for 5 seconds." },
			{ spellID = 1020, name = "Divine Shield", flags = { "Important" },
				text = "At half health he becomes immune to all damage and spells for 12 seconds." },
			{ spellID = 8990, name = "Retribution Aura", flags = { "Damage" },
				text = "Holy damage to whoever strikes him in melee." },
		},
		extraAbilities = {
			{ title = "Calls for help", icon = ICONS .. "ability_warrior_rallyingcry", flags = { "Important" },
				description = "When pulled, he calls every Scarlet defender within 80 yards to join him. Clear the cathedral before you pull him." },
		},
	},
	["High Inquisitor Whitemane"] = {
		abilities = {
			{ spellID = 9232, name = "Scarlet Resurrection", flags = { "Deadly", "Important" },
				text = "At half health she puts everyone in the room to sleep for up to 10 seconds, runs to Mograine and raises him. He heals her fully with Lay on Hands, and the two fight you together." },
			{ spellID = 9481, name = "Holy Smite", flags = { "Interruptible" },
				text = "Holy damage to her target (2.5-second cast). Interrupt it." },
			{ spellID = 12039, name = "Heal", flags = { "Interruptible" },
				text = "Heals the most wounded of her allies, Mograine included (3-second cast). Interrupt it." },
			{ spellID = 22187, name = "Power Word: Shield", flags = { "Magic" },
				text = "Shields her against damage for up to 30 seconds. A priest or a shaman can remove it." },
		},
		fightNote = "When Mograine falls he is only playing dead: she runs out of the room behind the altar and attacks.",
	},
} })

ns.AmendInstance("HallOfThanes", { bosses = {
	["Faldrim Anvilmar"] = {
		extraAbilities = {
			{ title = "Curses and diseases", icon = ICONS .. "spell_shadow_curseofsargeras", flags = { "Curse", "Disease" },
				description = "A way to remove a curse or cure a disease comes in handy. Otherwise an easy fight: clear the room before the pull." },
		},
	},
	["Magmatus"] = {
		extraAbilities = {
			{ title = "The summoner", icon = ICONS .. "spell_shadow_summonimp", flags = { "Important", "Damage" },
				description = "Kill the summoner first: he keeps bringing adds. Then turn on the elemental." },
			{ title = "Fire all around", icon = ICONS .. "spell_fire_fire", flags = { "Healer" },
				description = "Area damage on the group, worse when many of you fight in melee." },
		},
	},
	["Plunder"] = {
		extraAbilities = {
			{ title = "Knocked across the room", icon = ICONS .. "ability_warstomp", flags = { "Tank", "Important" },
				description = "He punts people around the room. Clear the packs closest to him and tank him near the tunnel, so nobody lands in another pack." },
		},
	},
	["Durgen Dirgehammer"] = {
		extraAbilities = {
			{ title = "Fear at low health", icon = ICONS .. "spell_shadow_psychicscream", flags = { "Important" },
				description = "When his health gets low he fears the whole group. Bring a way to break it, or clear the room first so nobody runs into more enemies." },
			{ title = "The locked vaults", icon = ICONS .. "inv_misc_key_03",
				description = "After the fight, open the vaults of the room: about 24 Dwarven Heirlooms for Important Heirlooms, and the tablet of The Treaty of Understanding." },
		},
	},
} })

ns.AmendInstance("RuinsOfLordaeron", { bosses = {
	["The Baron"] = {
		extraAbilities = {
			{ title = "Hurled into the air", icon = ICONS .. "ability_smash", flags = { "Tank" },
				description = "Throws the tank into the air and stuns him for 5 seconds. Damage dealers, watch your threat: the tank is on him only about half the fight." },
			{ title = "A patrol", icon = ICONS .. "ability_eyeoftheowl", flags = { "Important" },
				description = "Clear his room before the pull: a patrol walks by. His head is looted for the quests Abominable Creatures and Unending Torment." },
		},
	},
	["Witherfang"] = {
		extraAbilities = {
			{ title = "Spiders of the courtyard", icon = ICONS .. "inv_misc_monsterspidercarapace_01", flags = { "Important" },
				description = "Nothing special on the boss itself. Clear the other spiders of the courtyard first, or they join the fight." },
		},
	},
	["The Abandoned"] = {
		extraAbilities = {
			{ title = "Frost Nova", icon = ICONS .. "spell_frost_frostnova", flags = { "Healer" },
				description = "Frost damage to the whole group. Healers, pace your mana through the waves." },
		},
		fightNote = "Clear the courtyard, click the statue and survive the waves: she comes after them.",
	},
	["Bjork"] = {
		extraAbilities = {
			{ title = "Knockback", icon = ICONS .. "ability_warstomp", flags = { "Tank", "Important" },
				description = "Knocks you back: clear the packs around him first, or you land in one." },
			{ title = "Anti-Magic Shield", icon = ICONS .. "spell_shadow_antimagicshell", flags = { "Magic" },
				description = "Shields himself against spells for a while." },
			{ title = "Heavy blows", icon = ICONS .. "ability_warrior_decisivestrike", flags = { "Tank", "Healer" },
				description = "He hits hard: keep the tank topped up." },
		},
	},
	["Rath'mael"] = {
		extraAbilities = {
			{ title = "Flamestrike", icon = ICONS .. "spell_fire_selfdestruct", flags = { "Deadly", "Interruptible" },
				description = "His main spell. He can be interrupted and stunned: plan your kicks and stuns." },
			{ title = "A large health pool", icon = ICONS .. "spell_holy_sealofmight", flags = { "Damage" },
				description = "The longest fight of the dungeon. Keep the interrupts going and bring him down." },
		},
	},
	["Viktor the Vile"] = {
		extraAbilities = {
			{ title = "Poison", icon = ICONS .. "ability_creature_poison_05", flags = { "Poison", "Healer" },
				description = "Poisons his target. Druids and shamans (Cure Poison) and paladins (Purify or Cleanse) can take it off; otherwise, watch the health bars." },
			{ title = "Heavy blows", icon = ICONS .. "ability_warrior_decisivestrike", flags = { "Tank" },
				description = "He hits hard: keep the tank healthy. Bring mana potions for the waves before him." },
		},
		fightNote = "Clear the house and the statue, click the fireplace and survive the waves. He comes after the last flesh golem.",
	},
} })

-- Saltspine's, Shadetooth's and the Relic Guardian's spells are from a recorded kill of each
-- (2026-10-16). The Highland Spiders that cast in the first two fights were fighting the dig's
-- Dwarf Excavators nearby, not the group. From the same run's log: what the creatures on the way
-- to each boss put on players that the group took off, by what (Purify, Cure Poison, Cure
-- Disease, Remove Curse), and the Highland Horror's roots, which Blessing of Freedom broke.
ns.AmendInstance("ExcavationSiteWetlands", { bosses = {
	["Saltspine"] = {
		abilities = {
			{ spellID = 1316382, name = "Dust Storm", flags = { "Damage" },
				text = "A storm of dust that hits the group for about 160 to 330 nature damage. Healers, be ready for it." },
			{ spellID = 3604, name = "Tendon Rip", flags = { "Tank" },
				text = "He tears at the tank's legs, slowing them." },
		},
		extraAbilities = {
			{ title = "Crocolisks in the marsh", icon = ICONS .. "ability_hunter_pet_crocolisk", flags = { "Damage" },
				description = "He roams the marsh at the start among elite crocolisks, so clear them first or pull him away from them." },
			{ title = "Muculent Rot", icon = ICONS .. "ability_creature_disease_02", flags = { "Healer", "Poison", "Disease" },
				description = "The Marsh Skulkers on the way to him give players Muculent Rot. A paladin's Purify or Cleanse takes it off. "
					.. "It's either a poison or a disease, so a druid's or shaman's Cure Poison, or a priest's or shaman's Cure Disease, may work too." },
		},
		notAdds = { [260803] = true },
	},
	["Shadetooth"] = {
		abilities = {
			{ spellID = 14100, name = "Terrifying Roar", flags = { "Important" },
				text = "About every 20 seconds he roars and fears up to three players near him. A shaman's Tremor Totem helps." },
			{ spellID = 13445, name = "Rend", flags = { "Tank", "Bleed" },
				text = "He makes the tank bleed." },
			{ spellID = 1284435, name = "Enrage", flags = { "Tank", "Important" },
				text = "Late in the fight he enrages and hits harder: keep the tank's health up to the end." },
		},
		extraAbilities = {
			{ title = "Infected Wound", icon = ICONS .. "ability_creature_disease_03", flags = { "Healer", "Disease" },
				description = "The Thicket Hunters, raptors on the way to him and in his fight, give players Infected Wound, a disease. "
					.. "Paladins (Purify or Cleanse), priests and shamans (Cure Disease) can take it off." },
		},
		fightNote = "Kill the raptor matriarch in the tall grass. A wave of raptors comes when she dies, and Shadetooth runs in once they are dead.",
		-- The raptors that cast in his fight are the thicket's, noted above: not listed as his adds.
		notAdds = { [260800] = true, [260801] = true, [260803] = true },
	},
	["Highland Horror"] = {
		abilities = {
			{ spellID = 1316480, name = "Entangling Roots", flags = { "Important" },
				text = "He roots players in place. A paladin's Blessing of Freedom frees them." },
		},
		extraAbilities = {
			{ title = "The Dragonmaw camp", icon = ICONS .. "inv_misc_head_dragon_black",
				description = "He stands in a Dragonmaw camp. Its groups pull apart easily: take them one at a time first. The fight itself is short." },
			{ title = "Curse of Weakness", icon = ICONS .. "spell_shadow_curseofmannoroth", flags = { "Healer", "Curse" },
				description = "The Dragonmaw Thaumaturgists in his camp put Curse of Weakness on players. "
					.. "Druids (Remove Curse) and mages (Remove Lesser Curse) can take it off." },
		},
	},
	["Relic Guardian"] = {
		abilities = {
			{ spellID = 10101, name = "Knock Away", flags = { "Tank", "Important" },
				text = "He knocks the tank back and turns to someone else: he drops his threat. Damage dealers, slow down when the tank loses him. Tank, take him back at once." },
			{ spellID = 8374, name = "Arcing Smash", flags = { "Tank" },
				text = "A heavy swing at everyone in front of him. Only the tank should stand there." },
			{ spellID = 8078, name = "Thunderclap", flags = { "Damage" },
				text = "Hits everyone near him and slows their attacks." },
		},
		extraAbilities = {
			{ title = "Poison on the spider trail", icon = ICONS .. "ability_creature_poison_05", flags = { "Healer", "Poison" },
				description = "The Highland Spiders and Highland Lurkers on the trail to him poison players. "
					.. "Druids and shamans (Cure Poison) and paladins (Purify or Cleanse) can take it off." },
			{ title = "Highland Venom", icon = ICONS .. "ability_creature_poison_03", flags = { "Healer", "Disease" },
				description = "The Highland Lurkers also give players Highland Venom. Despite the name it's a disease: "
					.. "paladins (Purify or Cleanse), priests and shamans (Cure Disease) can take it off." },
		},
		fightNote = "He stands still at the end of the spider trail. Click the small panel next to him to wake him.",
	},
} })

ns.AmendInstance("CityOfDalaran", { bosses = {
	["Atrexis the Grave Knight"] = {
		abilities = {
			{ spellID = 1303264, name = "Unholy Frenzy", flags = { "Tank", "Magic" },
				text = "He speeds up his attacks by 75% for 20 seconds. It is magic: a shaman's Purge or a priest's Dispel Magic takes it off him." },
			{ spellID = 3391, name = "Thrash", flags = { "Tank" },
				text = "Now and then he swings twice more at once, and Strike adds damage to his next hit: the tank takes heavy blows." },
			{ spellID = 1303266, name = "Raise Dead", flags = { "Damage" },
				text = "Skeletons keep rising around the circle during the fight. They are weak: kill them as they come." },
		},
		extraAbilities = {
			{ title = "Disarm", icon = ICONS .. "ability_warrior_disarm", flags = { "Tank" },
				description = "He takes the tank's weapon away for about 6 seconds." },
		},
		fightNote = "He stands at a ritual circle in the sewers, with Kirin Tor Necromancers around him.",
	},
	["Arcane Anomaly"] = {
		abilities = {
			{ spellID = 1241501, name = "Focal Blast", flags = { "Deadly", "Important" },
				text = "After a 3-second cast, a beam comes out in front of it for 6 seconds and hits four times a second. Get out of its path as soon as the cast starts." },
			{ spellID = 1241506, name = "Arcane Bolt", flags = { "Tank" },
				text = "Its attack on the tank between the beams, a 1.5-second cast." },
		},
	},
	["Arcanic Enigma"] = {
		abilities = {
			{ spellID = 1240869, name = "Manamorph", flags = { "Magic", "Important" },
				text = "Turns a player into an animal for 8 seconds. It is magic: dispel it." },
			{ spellID = 1224125, name = "Silence", flags = { "Healer" },
				text = "Silences for 10 seconds. Healers, keep your distance from it." },
		},
		extraAbilities = {
			{ title = "Arcane Manalings", icon = ICONS .. "spell_arcane_arcane01", flags = { "Damage" },
				description = "It keeps calling small Arcane Manalings. Kill them with area damage." },
		},
	},
	["Unstable Sentinel"] = {
		abilities = {
			{ spellID = 1241329, name = "Malfunction", flags = { "Deadly" },
				text = "A 2-second cast, then for 6 seconds arcane energy hits everyone within 25 yards every 2 seconds, for about 140 damage each time. Ranged players, stay beyond 25 yards; melee, step out during the cast." },
		},
		extraAbilities = {
			{ title = "Angry Tomes", icon = ICONS .. "inv_misc_book_06", flags = { "Damage" },
				description = "Angry Tomes come at you on the way to it. Kill them before you pull." },
		},
	},
	["Mana Devourer"] = {
		abilities = {
			{ spellID = 1240750, name = "Debilitate", flags = { "Healer" },
				text = "A 2-second cast: arcane power drains up to 200 mana from everyone within 45 yards of him." },
			{ spellID = 1240738, name = "Drain Vitality", flags = { "Tank", "Magic" },
				text = "A magic debuff on the tank: around 65 Arcane damage every 2 seconds for 10 seconds. Dispel it." },
		},
		extraAbilities = {
			{ title = "His room", icon = ICONS .. "ability_warrior_rallyingcry", flags = { "Important" },
				description = "The creatures still alive in his room join the fight when he is pulled. Clear the room first." },
		},
	},
	["Fel Ancient"] = {
		abilities = {
			{ spellID = 1240692, name = "Fel Timbers", flags = { "Poison", "Important" },
				text = "Vines run to a player and hit everyone within 5 yards of them, then leave poisonous fumes on the ground. Move out of the fumes." },
			{ spellID = 1240687, name = "Trample", flags = { "Tank", "Damage" },
				text = "He tramples the players next to him for about 100 physical damage." },
			{ spellID = 1240688, name = "Entangle", flags = { "Magic" },
				text = "Roots up to two players near him for a few seconds and hurts them over time. It is magic: dispel it." },
		},
		fightNote = "He waits behind a magic barrier in the middle of the city, with Suffused Treants in front of it. Kill the treants, then talk to Magus Fansy Goodbringer, just south of the barrier: he brings it down.",
	},
	["Shade of the Archmage"] = {
		abilities = {
			{ spellID = 1241523, name = "Bounding Mana", flags = { "Important", "Magic" },
				text = "An orb flies to a random player and comes back to him. Anyone it passes through takes Arcane damage and is silenced for 6 seconds: don't stand between him and that player." },
			{ spellID = 1303598, name = "Mass Polymorph", flags = { "Important" },
				text = "When his mana runs out, he turns the whole group into animals for 8 seconds, then channels Evocation for 6 seconds to refill it." },
			{ spellID = 1303350, name = "Slow", flags = { "Important" },
				text = "Slows everyone near him for 3 seconds: attacks and casts 30% slower, movement 70% slower." },
		},
		extraAbilities = {
			{ title = "Stay in the room", icon = ICONS .. "spell_arcane_blink", flags = { "Deadly" },
				description = "If someone leaves the room during the fight, he resets to full health." },
		},
		fightNote = "Archmage Modera opens the Portal to the Violet Chamber for the group: it leads to him.",
	},
	["Lyn the Ignored"] = {
		abilities = {
			{ spellID = 17228, name = "Shadow Bolt Volley", flags = { "Damage", "Healer" },
				text = "Shadow bolts at everyone within 30 yards of her." },
			{ spellID = 1304473, name = "Curse of Thorns", flags = { "Curse" },
				text = "A 1.5-second cast: a 3-minute curse that hurts the player now and then when they attack. Remove it." },
		},
		extraAbilities = {
			{ title = "Skeletons", icon = ICONS .. "spell_shadow_raisedead", flags = { "Damage" },
				description = "Skeletons rise and fight beside her. Kill them." },
		},
		fightNote = "She is not there at first. In the sewers, past Atrexis, clear the north-east room, the one with market stalls and a small pink Summoning Circle (not Atrexis's large one). A player carrying the Tome of Dalaran then clicks the circle, and Lyn comes out of the large round grated door. To get the tome, loot the Black Tome on the table in Archmage Arugal's room in Shadowfang Keep, after his kill, then use it at the Leyline Focus, a blue crystal in a back room at Ambermill, in Silverpine Forest.",
	},
} })
