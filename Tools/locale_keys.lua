-- Every English word the content translation looks up (Core/Registry.lua's ns.ApplyLocale), from
-- the data as it loads now, and every area name the journal matches the client's against (Core/
-- Areas.lua). Run by Tools/locale_keys.py; returns JSON.
local ns = ...

local function Encode(value)
	local kind = type(value)
	if kind == "string" then
		return '"' .. value:gsub('[%c"\\]', function(char)
			local named = { ['"'] = '\\"', ["\\"] = "\\\\", ["\n"] = "\\n", ["\r"] = "\\r", ["\t"] = "\\t" }
			return named[char] or string.format("\\u%04x", char:byte())
		end) .. '"'
	elseif kind == "number" then
		return tostring(value)
	elseif kind == "table" then
		if #value > 0 or next(value) == nil then
			local parts = {}
			for _, item in ipairs(value) do parts[#parts + 1] = Encode(item) end
			return "[" .. table.concat(parts, ",") .. "]"
		end
		local keys = {}
		for key in pairs(value) do keys[#keys + 1] = tostring(key) end
		table.sort(keys)
		local parts = {}
		for _, key in ipairs(keys) do
			local item = value[key]
			if item == nil then item = value[tonumber(key)] end
			parts[#parts + 1] = Encode(key) .. ":" .. Encode(item)
		end
		return "{" .. table.concat(parts, ",") .. "}"
	end
	return "null"
end

local seen = { bossNames = {}, abilityNames = {}, strings = {} }
local out = { bossNames = {}, abilityNames = {}, strings = {}, instanceNames = {}, factionNames = {},
	subMapNames = {}, areas = ns.AreaNamesUsed and ns.AreaNamesUsed() or {} }
local function Add(list, text)
	if type(text) == "string" and text ~= "" and not seen[list][text] then
		seen[list][text] = true
		table.insert(out[list], text)
	end
end
local function Str(text) Add("strings", text) end

local function Ability(ability)
	if type(ability) ~= "table" then return end
	Add("abilityNames", ability.name)
	Str(ability.text)
end

for _, kind in ipairs({ "dungeon", "raid", "faction" }) do
	for _, instance in ipairs(ns.GetInstances(kind)) do
		if instance.kind == "faction" then
			out.factionNames[tostring(instance.factionID)] = instance.name
		else
			out.instanceNames[instance.key] = instance.name
			Str(instance.location)
			Str(instance.description)
		end
		for _, boss in ipairs(instance.bosses or {}) do
			if not (boss.trash or boss.name == "Trash Drops") then Add("bossNames", boss.name) end
			Str(boss.description)
			Str(boss.fightNote)
			Str(boss.area)
			for _, note in ipairs(boss.notes or {}) do Str(note) end
			for _, ability in ipairs(boss.abilities or {}) do Ability(ability) end
			for _, extra in ipairs(boss.extraAbilities or {}) do
				Str(extra.title)
				Str(extra.description)
			end
			for _, stage in ipairs(boss.stages or {}) do
				Str(stage.title)
				Str(stage.description)
				for _, ability in ipairs(stage.abilities or {}) do Ability(ability) end
			end
			for _, add in ipairs(boss.adds or {}) do
				if type(add) == "table" then
					Add("bossNames", add.name)
					for _, ability in ipairs(add.abilities or {}) do Ability(ability) end
				end
			end
			for _, row in ipairs(boss.loot or {}) do Str(row.cost) end
		end
		for _, quest in ipairs(instance.quests or {}) do
			Str(quest.name)
			Str(quest.objective)
			Str(quest.note)
			Str(quest.pickup)
			Str(quest.turnin)
			Str(quest.startMap and quest.startMap.label)
			for _, key in ipairs({ "startItem", "startObject" }) do
				local entry = quest[key]
				if entry then
					Str(entry.name)
					Str(entry.note)
				end
			end
			for _, prerequisite in ipairs(quest.prerequisites or {}) do
				Str(prerequisite.name)
				Str(prerequisite.objective)
				Str(prerequisite.pickup)
				Str(prerequisite.turnin)
				Str(prerequisite.note)
				Str(prerequisite.startMap and prerequisite.startMap.label)
				local item = prerequisite.startItem
				if item then
					Str(item.name)
					Str(item.note)
				end
			end
		end
	end
end
for _, subMap in ipairs(ns.GetSubMaps()) do out.subMapNames[subMap.key] = subMap.name end
for _, spot in ipairs(ns.GetTransports()) do
	Str(spot.area)
	for _, destination in ipairs(spot.to or {}) do Str(destination) end
	for destination, note in pairs(spot.notes or {}) do
		Str(destination)
		Str(note)
	end
end

return Encode(out)
