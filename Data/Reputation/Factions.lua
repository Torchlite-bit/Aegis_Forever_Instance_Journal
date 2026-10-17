-- The factions on the Reputation tab: the journal's own list. Edit it by hand.
-- None has rewards here: they come only from quartermasters captured in game, by the
-- Reputation tab's Capture button or a recording (Data/Reputation/Captured.lua, written by
-- Dev/build_data.py, and the player's own captures). A faction with none yet shows a
-- placeholder asking for its quartermaster.

local _, ns = ...

ns.AddFactions({
	{ factionID = 529, name = "Argent Dawn" },
	{ factionID = 2586, name = "Azeroth Commerce Authority" },
	{ factionID = 21, name = "Booty Bay" },
	{ factionID = 910, name = "Brood of Nozdormu" },
	{ factionID = 609, name = "Cenarion Circle" },
	{ factionID = 2798, name = "Darkspear Raiders" },
	{ factionID = 2587, name = "Durotar Supply and Logistics" },
	{ factionID = 2787, name = "Earthen Ring" },
	{ factionID = 577, name = "Everlook" },
	{ factionID = 369, name = "Gadgetzan" },
	{ factionID = 2765, name = "Guardians of Hyjal" },
	{ factionID = 749, name = "Hydraxian Waterlords" },
	{ factionID = 2740, name = "Kirin Tor" },
	{ factionID = 2758, name = "Nightclaw Druids" },
	{ factionID = 2827, name = "Powderfuse" },
	{ factionID = 470, name = "Ratchet" },
	{ factionID = 510, name = "The Defilers" },
	{ factionID = 509, name = "The League of Arathor" },
	{ factionID = 2819, name = "The Watchers" },
	{ factionID = 2799, name = "Theramore Expeditionary Force" },
	{ factionID = 59, name = "Thorium Brotherhood" },
	{ factionID = 576, name = "Timbermaw Hold" },
	{ factionID = 270, name = "Zandalar Tribe" },
})
