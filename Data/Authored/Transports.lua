local _, ns = ...

--[[
	Boats, zeppelins, airships, trams and portals, for the world map (UI/TravelMap.lua).
	Forever moved several from where Classic had them, so each one here was stood on in game
	and saved with /aegis travel; its place is what the client reported there. The few that
	Forever left where Classic had them may come from Classic's guides instead, and say so.

	kind      boat, zeppelin, airship, tram or portal
	mapID     the map the spot was saved on; x, y its place on that map
	area      the area's name there, the tooltip's title
	faction   who it serves: Alliance (blue), Horde (red) or Neutral (gold)
	to        where it goes; notes, by destination, who may take it
]]

ns.AddTransports({
	-- The Skyborne's portal from Dalaran to Stormwind. Its way there, the direct, unlimited portal
	-- from Stormwind's mage tower (Wizard's Sanctum), was taken out of Forever (2026-10).
	{
		kind = "portal", mapID = 1416, x = 0.1204, y = 0.563, area = "The Sky Enclave", faction = "Alliance",
		to = { "Stormwind" }, notes = { ["Stormwind"] = "Skyborne only" },
	},

	-- The Alliance Skyborne's airship between Dalaran and Zephras Isle (map 2521, Forever's own).
	{
		kind = "airship", mapID = 1416, x = 0.1268, y = 0.5202, area = "Dalaran", faction = "Alliance",
		to = { "Zephras Isle" }, notes = { ["Zephras Isle"] = "Skyborne only" },
	},
	{
		kind = "airship", mapID = 2521, x = 0.6581, y = 0.834, area = "Valanaar", faction = "Alliance",
		to = { "Dalaran" }, notes = { ["Dalaran"] = "Skyborne only" },
	},

	-- The Deeprun Tram. Its Ironforge end, in Tinker Town, is unchanged from Classic, per the
	-- player, so its place is Classic's (Wowhead's Ironforge guide, 76.28, 51.31); its Stormwind
	-- end, on Forever's new Stormwind map, was saved there. A left click on either shows the
	-- station room (Data/Authored/SubMaps.lua, DeeprunTram).
	{
		kind = "tram", mapID = 1455, x = 0.7628, y = 0.5131, area = "Tinker Town", faction = "Alliance",
		to = { "Stormwind City" },
	},
	{
		kind = "tram", mapID = 1453, x = 0.6707, y = 0.3329, area = "Dwarven District", faction = "Alliance",
		to = { "Ironforge" },
	},
})
