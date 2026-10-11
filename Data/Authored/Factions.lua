local _, ns = ...

--[[
	Each faction's crest and card colour on the Reputation tab.

	Crests are Blizzard's own icons, named by path; the first one this client has is used,
	and a faction whose icons are all missing shows its best reward's icon instead. Colours
	are the card's glow, { r, g, b }. A faction not listed here keeps the defaults.
]]

local ICONS = "Interface\\Icons\\"

local function Faction(factionID, icons, color)
	local key = "Faction" .. factionID
	-- The generated data decides which factions exist; a faction it dropped is skipped.
	if not ns.GetInstance(key) then return end
	local paths = {}
	for index, name in ipairs(icons) do paths[index] = ICONS .. name end
	ns.AmendInstance(key, { icons = paths, color = color })
end

local STEAMWHEEDLE = { "INV_Misc_Bag_10_Green", "Achievement_GoblinHead" }

Faction(529, { "INV_Misc_Token_ArgentDawn" }, { 0.62, 0.66, 0.72 })                -- Argent Dawn
Faction(2586, { "INV_Misc_Coin_01" }, { 0.18, 0.34, 0.72 })                         -- Azeroth Commerce Authority
Faction(21, STEAMWHEEDLE, { 0.42, 0.56, 0.16 })                                     -- Booty Bay
Faction(910, { "INV_Misc_Head_Dragon_Bronze" }, { 0.86, 0.56, 0.08 })               -- Brood of Nozdormu
Faction(609, { "Spell_Nature_ProtectionformNature" }, { 0.12, 0.62, 0.58 })         -- Cenarion Circle
Faction(2798, { "INV_Misc_Head_Troll_01" }, { 0.58, 0.22, 0.10 })                   -- Darkspear Raiders
Faction(2587, { "Achievement_Zone_Durotar", "INV_BannerPVP_01" }, { 0.66, 0.10, 0.08 }) -- Durotar Supply and Logistics
Faction(2787, { "INV_Misc_Tabard_EarthenRing", "Spell_Nature_EarthElemental_Totem" }, { 0.42, 0.40, 0.36 }) -- Earthen Ring
Faction(577, STEAMWHEEDLE, { 0.40, 0.56, 0.30 })                                    -- Everlook
Faction(369, STEAMWHEEDLE, { 0.56, 0.52, 0.14 })                                    -- Gadgetzan
Faction(2765, { "INV_Misc_Tabard_GuardiansOfHyjal" }, { 0.40, 0.54, 0.14 })         -- Guardians of Hyjal
Faction(749, { "Spell_Frost_SummonWaterElemental", "Spell_Frost_SummonWaterElemental_2" }, { 0.10, 0.46, 0.72 }) -- Hydraxian Waterlords
Faction(2740, { "Achievement_Reputation_KirinTor" }, { 0.50, 0.20, 0.68 })          -- Kirin Tor
Faction(2758, { "Ability_Druid_CatForm" }, { 0.26, 0.20, 0.52 })                    -- Nightclaw Druids
Faction(2827, { "INV_Misc_Bomb_05", "INV_Misc_Bomb_04" }, { 0.78, 0.36, 0.06 })     -- Powderfuse
Faction(470, STEAMWHEEDLE, { 0.20, 0.50, 0.42 })                                    -- Ratchet
Faction(510, { "INV_BannerPVP_01" }, { 0.52, 0.08, 0.06 })                          -- The Defilers
Faction(509, { "INV_BannerPVP_02" }, { 0.14, 0.30, 0.62 })                          -- The League of Arathor
Faction(2819, { "INV_Misc_Eye_01" }, { 0.36, 0.30, 0.48 })                          -- The Watchers
Faction(2799, { "Achievement_Zone_DustwallowMarsh", "INV_BannerPVP_02" }, { 0.14, 0.36, 0.52 }) -- Theramore Expeditionary Force
Faction(59, { "INV_Ingot_Thorium" }, { 0.72, 0.32, 0.06 })                          -- Thorium Brotherhood
Faction(576, { "Achievement_Reputation_Timbermaw" }, { 0.48, 0.32, 0.16 })          -- Timbermaw Hold
Faction(270, { "INV_Misc_Coin_08", "Achievement_Boss_Hakkar" }, { 0.10, 0.46, 0.32 }) -- Zandalar Tribe
