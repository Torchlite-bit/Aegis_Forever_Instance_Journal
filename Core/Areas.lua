local _, ns = ...
local L = ns.L

--[[
	Area names in the client's language. The client names the area the player stands in
	(GetSubZoneText, GetMinimapZoneText) in its own language, while the journal's data names
	areas in English: a dungeon's "You are here" areas (mapAreas), a wing's (wingAreas), an area
	below a zone (a sub-map's areas, sharedAreas and zones), a boss's area.

	The client also names any area by its id (C_Map.GetAreaInfo), in its own language. ns.AREA_IDS
	(Data/Generated/AreaIDs.lua) gives each English name its ids, found once by /aegis areas on an
	English client: from them every client knows its own names for the journal's areas, Forever's
	new ones too, without a translation. A name without an id is taken from the translation
	(L.AREA_NAMES, English -> the client's language), else left as it is.
]]

local Areas = {}
ns.Areas = Areas

-- The ids looked through by /aegis areas, a step at a time.
local SCAN_LAST, SCAN_STEP = 40000, 2000

local function AreaInfo(areaID)
	if not (C_Map and C_Map.GetAreaInfo) then return nil end
	local ok, name = pcall(C_Map.GetAreaInfo, areaID)
	name = ok and ns.Readable(name) or nil
	if type(name) ~= "string" or name == "" then return nil end
	return name
end

-- Every English area name the journal's data uses, sorted.
function ns.AreaNamesUsed()
	local names, seen = {}, {}
	local function Add(name)
		if type(name) == "string" and name ~= "" and not seen[name] then
			seen[name] = true
			names[#names + 1] = name
		end
	end
	local function Keys(map)
		for name in pairs(map or {}) do Add(name) end
	end
	for _, kind in ipairs({ "dungeon", "raid" }) do
		for _, instance in ipairs(ns.GetInstances(kind)) do
			Keys(instance.mapAreas)
			Keys(instance.wingAreas)
			for _, name in ipairs(instance.areas or {}) do Add(name) end
			for _, boss in ipairs(instance.bosses or {}) do Add(boss.enArea or boss.area) end
		end
	end
	for _, subMap in ipairs(ns.GetSubMaps()) do
		Keys(subMap.areas)
		Keys(subMap.sharedAreas)
		Keys(subMap.zones)
	end
	-- Forever's zones the world map gives a level range by name (Data/Authored/ZoneLevels.lua).
	Keys(ns.ZONE_LEVELS_BY_NAME)
	table.sort(names)
	return names
end

-- The client's name for an English area name: by its ids, else the translation, else as it is.
function ns.AreaName(english)
	if type(english) ~= "string" then return english end
	for _, areaID in ipairs(ns.AREA_IDS and ns.AREA_IDS[english] or {}) do
		local name = AreaInfo(areaID)
		if name then return name end
	end
	return L.AREA_NAMES and L.AREA_NAMES[english] or english
end

-- For each name the client may give an area, the journal's English names it stands for: one
-- room spelt two ways in the data (Tazz'Alaor, Tazz'Alor), or two rooms a translation names alike.
local reverse
local function Reverse()
	if reverse then return reverse end
	reverse = {}
	local function Add(name, english)
		local list = reverse[name]
		if not list then
			reverse[name] = { english }
		elseif list[#list] ~= english then
			list[#list + 1] = english
		end
	end
	local names = ns.AreaNamesUsed()
	-- Each English name stands first for itself.
	for _, english in ipairs(names) do Add(english, english) end
	for _, english in ipairs(names) do
		for _, areaID in ipairs(ns.AREA_IDS and ns.AREA_IDS[english] or {}) do
			local localized = AreaInfo(areaID)
			if localized then Add(localized, english) end
		end
		local translated = L.AREA_NAMES and L.AREA_NAMES[english]
		if translated then Add(translated, english) end
	end
	return reverse
end

-- The journal's English name for an area the client names: what the data is keyed by.
function ns.AreaKey(name)
	if type(name) ~= "string" or name == "" then return name end
	local list = Reverse()[name]
	return list and list[1] or name
end

-- A table keyed by English area names, read with a name the client gives: the entry under any
-- English name it stands for, and that name.
function ns.AreaIn(map, name)
	if type(map) ~= "table" or type(name) ~= "string" or name == "" then return nil end
	if map[name] ~= nil then return map[name], name end
	for _, english in ipairs(Reverse()[name] or {}) do
		if map[english] ~= nil then return map[english], english end
	end
	return nil
end

-- Built again from all the data, once it has all loaded.
function Areas:Forget()
	reverse = nil
end

--[[
	/aegis areas: the client's id for each English area name the journal uses, on an English
	client, saved under "areaIDs" for Tools/bake_area_ids.py. A few thousand ids a frame.
]]
local scanning = false
function Areas:Scan()
	if scanning then
		ns.Print(L.AREAS_SCANNING)
		return
	end
	local locale = GetLocale and GetLocale() or "enUS"
	if locale ~= "enUS" and locale ~= "enGB" then
		ns.Print(L.AREAS_ENGLISH)
		return
	end
	scanning = true
	local names = ns.AreaNamesUsed()
	local wanted, found = {}, {}
	for _, name in ipairs(names) do wanted[name] = true end
	ns.Print(string.format(L.AREAS_START, #names))
	local nextID = 1
	local function Finish()
		local missing = {}
		for _, name in ipairs(names) do
			if not found[name] then missing[#missing + 1] = name end
		end
		ns.db.areaIDs = { at = date("%Y-%m-%d %H:%M:%S"), locale = locale, found = found, missing = missing }
		ns.Print(string.format(L.AREAS_DONE, #names - #missing, #names))
		if #missing > 0 then ns.Print(string.format(L.AREAS_MISSING, table.concat(missing, ", "))) end
		scanning = false
	end
	local function Step()
		local last = math.min(nextID + SCAN_STEP - 1, SCAN_LAST)
		for areaID = nextID, last do
			local name = AreaInfo(areaID)
			if name and wanted[name] then
				found[name] = found[name] or {}
				table.insert(found[name], areaID)
			end
		end
		nextID = last + 1
		if nextID <= SCAN_LAST then C_Timer.After(0, Step) else Finish() end
	end
	Step()
end

local events = CreateFrame("Frame")
ns.RegisterEvents(events, "PLAYER_LOGIN")
events:SetScript("OnEvent", function() Areas:Forget() end)
