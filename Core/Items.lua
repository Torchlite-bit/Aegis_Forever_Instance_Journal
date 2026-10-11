local _, ns = ...

--[[
	What the journal needs to know about an item, and who can use it.

	The client answers type, slot and icon at once (GetItemInfoInstant); the name, link and
	quality may need a round trip to the server, so the loot page asks for them and redraws
	when GET_ITEM_INFO_RECEIVED says they have arrived. The data files' own name and quality
	stand in until then.

	Retail's class filter reads the encounter journal's loot data, which Forever does not
	ship, so usability here follows the Classic proficiency rules instead.
]]

local Items = {}
ns.Items = Items

local WEAPON, ARMOR = 2, 4

-- Enum.ItemArmorSubclass
local ARMOR_GENERIC, ARMOR_CLOTH, ARMOR_LEATHER, ARMOR_MAIL, ARMOR_PLATE = 0, 1, 2, 3, 4
local ARMOR_SHIELD, ARMOR_LIBRAM, ARMOR_IDOL, ARMOR_TOTEM = 6, 7, 8, 9

-- Enum.ItemWeaponSubclass
local AXE1H, AXE2H, BOW, GUN, MACE1H, MACE2H, POLEARM, SWORD1H, SWORD2H = 0, 1, 2, 3, 4, 5, 6, 7, 8
local STAFF, FIST, MISC_WEAPON, DAGGER, THROWN, CROSSBOW, WAND, FISHING = 10, 13, 14, 15, 16, 18, 19, 20

local function Set(...)
	local set = {}
	for index = 1, select("#", ...) do set[select(index, ...)] = true end
	return set
end

-- Armour each class can wear by level 60, and its weapons, as in Classic.
local CLASS_ARMOR = {
	WARRIOR = Set(ARMOR_CLOTH, ARMOR_LEATHER, ARMOR_MAIL, ARMOR_PLATE, ARMOR_SHIELD),
	PALADIN = Set(ARMOR_CLOTH, ARMOR_LEATHER, ARMOR_MAIL, ARMOR_PLATE, ARMOR_SHIELD, ARMOR_LIBRAM),
	HUNTER = Set(ARMOR_CLOTH, ARMOR_LEATHER, ARMOR_MAIL),
	SHAMAN = Set(ARMOR_CLOTH, ARMOR_LEATHER, ARMOR_MAIL, ARMOR_SHIELD, ARMOR_TOTEM),
	ROGUE = Set(ARMOR_CLOTH, ARMOR_LEATHER),
	DRUID = Set(ARMOR_CLOTH, ARMOR_LEATHER, ARMOR_IDOL),
	PRIEST = Set(ARMOR_CLOTH),
	MAGE = Set(ARMOR_CLOTH),
	WARLOCK = Set(ARMOR_CLOTH),
}

local CLASS_WEAPONS = {
	WARRIOR = Set(AXE1H, AXE2H, BOW, GUN, MACE1H, MACE2H, POLEARM, SWORD1H, SWORD2H, STAFF, FIST, DAGGER, THROWN, CROSSBOW),
	PALADIN = Set(AXE1H, AXE2H, MACE1H, MACE2H, POLEARM, SWORD1H, SWORD2H),
	HUNTER = Set(AXE1H, AXE2H, BOW, GUN, POLEARM, SWORD1H, SWORD2H, STAFF, FIST, DAGGER, THROWN, CROSSBOW),
	SHAMAN = Set(AXE1H, AXE2H, MACE1H, MACE2H, STAFF, FIST, DAGGER),
	ROGUE = Set(BOW, GUN, MACE1H, SWORD1H, FIST, DAGGER, THROWN, CROSSBOW),
	DRUID = Set(MACE1H, MACE2H, POLEARM, STAFF, FIST, DAGGER),
	PRIEST = Set(MACE1H, STAFF, DAGGER, WAND),
	MAGE = Set(SWORD1H, STAFF, DAGGER, WAND),
	WARLOCK = Set(SWORD1H, STAFF, DAGGER, WAND),
}

-- Retail's slot filter groups, by inventory type.
local SLOT_BY_EQUIP_LOC = {
	INVTYPE_HEAD = "HEAD", INVTYPE_NECK = "NECK", INVTYPE_SHOULDER = "SHOULDER", INVTYPE_CLOAK = "BACK",
	INVTYPE_CHEST = "CHEST", INVTYPE_ROBE = "CHEST", INVTYPE_WRIST = "WRIST", INVTYPE_HAND = "HANDS",
	INVTYPE_WAIST = "WAIST", INVTYPE_LEGS = "LEGS", INVTYPE_FEET = "FEET", INVTYPE_FINGER = "FINGER",
	INVTYPE_TRINKET = "TRINKET",
	INVTYPE_WEAPON = "MAINHAND", INVTYPE_WEAPONMAINHAND = "MAINHAND", INVTYPE_2HWEAPON = "MAINHAND",
	INVTYPE_RANGED = "MAINHAND", INVTYPE_RANGEDRIGHT = "MAINHAND", INVTYPE_THROWN = "MAINHAND",
	INVTYPE_WEAPONOFFHAND = "OFFHAND", INVTYPE_SHIELD = "OFFHAND", INVTYPE_HOLDABLE = "OFFHAND",
	INVTYPE_RELIC = "OFFHAND",
}

-- The sources' own slot words ("Wrist, Cloth"), for an item known only by its name.
local SLOT_BY_NAME = {
	Head = "HEAD", Neck = "NECK", Shoulder = "SHOULDER", Back = "BACK", Chest = "CHEST", Wrist = "WRIST",
	Hands = "HANDS", Waist = "WAIST", Legs = "LEGS", Feet = "FEET", Finger = "FINGER", Trinket = "TRINKET",
	["One-Hand"] = "MAINHAND", ["Two-Hand"] = "MAINHAND", ["Main Hand"] = "MAINHAND", Ranged = "MAINHAND",
	Thrown = "MAINHAND", ["Off Hand"] = "OFFHAND", ["Held In Off-hand"] = "OFFHAND", Shield = "OFFHAND",
	Relic = "OFFHAND",
}
local ARMOR_BY_NAME = { Cloth = ARMOR_CLOTH, Leather = ARMOR_LEATHER, Mail = ARMOR_MAIL, Plate = ARMOR_PLATE }

Items.SLOT_ORDER = { "HEAD", "NECK", "SHOULDER", "BACK", "CHEST", "WRIST", "HANDS", "WAIST", "LEGS", "FEET",
	"MAINHAND", "OFFHAND", "FINGER", "TRINKET", "OTHER" }
Items.SLOT_NAMES = {
	HEAD = INVTYPE_HEAD or "Head", NECK = INVTYPE_NECK or "Neck", SHOULDER = INVTYPE_SHOULDER or "Shoulder",
	BACK = INVTYPE_CLOAK or "Back", CHEST = INVTYPE_CHEST or "Chest", WRIST = INVTYPE_WRIST or "Wrist",
	HANDS = INVTYPE_HAND or "Hands", WAIST = INVTYPE_WAIST or "Waist", LEGS = INVTYPE_LEGS or "Legs",
	FEET = INVTYPE_FEET or "Feet", MAINHAND = INVTYPE_WEAPONMAINHAND or "Main Hand",
	OFFHAND = INVTYPE_WEAPONOFFHAND or "Off Hand", FINGER = INVTYPE_FINGER or "Finger",
	TRINKET = INVTYPE_TRINKET or "Trinket", OTHER = OTHER or "Other",
}

Items.ARMOR_ORDER = { ARMOR_CLOTH, ARMOR_LEATHER, ARMOR_MAIL, ARMOR_PLATE }

local instantCache = {}

-- Whether the item has an id; one the sources name without an id yet is keyed "?Name"
-- (Core/Registry.lua), and the client knows nothing of it.
function Items:IsIdentified(itemID)
	return type(itemID) == "number"
end

local function Instant(itemID)
	if not Items:IsIdentified(itemID) then return nil end
	local cached = instantCache[itemID]
	if cached then return cached end
	local getInstant = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
	local ok, _, itemType, itemSubType, equipLoc, icon, classID, subclassID = pcall(getInstant, itemID)
	if not ok or not classID then return nil end
	cached = {
		itemType = itemType, subType = itemSubType, equipLoc = equipLoc ~= "" and equipLoc or nil,
		icon = icon, classID = classID, subclassID = subclassID,
	}
	instantCache[itemID] = cached
	return cached
end

-- The item's icon, known at once without asking the server.
function Items:Icon(itemID)
	local instant = Instant(itemID)
	return instant and instant.icon or nil
end

--[[
	Each item's info is built once and kept; the pages read it, never change it. An item the
	server has not described yet is asked for once, checked again on later reads, and after
	GIVE_UP_SECONDS marked unavailable: on Forever the server never answers for some items,
	and a row should not say "Retrieving" for ever.
]]
local GIVE_UP_SECONDS = 15
local infoCache = {}

local function Describe(info)
	local getInfo = (C_Item and C_Item.GetItemInfo) or GetItemInfo
	local ok, name, link, quality = pcall(getInfo, info.itemID)
	if not (ok and name) then return false end
	info.name, info.link, info.quality = name, link, quality
	info.pending, info.unavailable, info.askedAt = nil, nil, nil
	return true
end

-- The item's info if it was built already, without asking the server for anything.
function Items:Peek(itemID)
	return infoCache[itemID]
end

-- Everything a loot row shows. `fallback` is the data file's row ({ name, quality, slot }).
function Items:Get(itemID, fallback)
	local info = infoCache[itemID]
	if info then
		if info.pending and not Describe(info) then
			if not info.unavailable then info.unavailable = GetTime() - info.askedAt > GIVE_UP_SECONDS end
			if fallback then
				info.name = info.name or fallback.name
				info.quality = info.quality or fallback.quality
			end
		end
		return info
	end

	if not self:IsIdentified(itemID) then
		-- Only the data's own words: its name, quality and slot ("Wrist, Cloth").
		local where, what = ((fallback and fallback.slot) or ""):match("^%s*([^,]*),?%s*(.-)%s*$")
		info = {
			itemID = itemID, name = fallback and fallback.name, quality = fallback and fallback.quality,
			slot = SLOT_BY_NAME[where] or "OTHER", unidentified = true,
		}
		if info.slot ~= "BACK" then info.armor = ARMOR_BY_NAME[what] end
		infoCache[itemID] = info
		return info
	end

	info = { itemID = itemID }
	local instant = Instant(itemID)
	if instant then
		for key, value in pairs(instant) do info[key] = value end
	end
	info.slot = SLOT_BY_EQUIP_LOC[info.equipLoc or ""] or "OTHER"
	if info.classID == ARMOR and info.subclassID and info.subclassID >= ARMOR_CLOTH and info.subclassID <= ARMOR_PLATE
		and info.slot ~= "BACK" then
		info.armor = info.subclassID
	end

	if not Describe(info) then
		info.name = fallback and fallback.name
		info.quality = fallback and fallback.quality
		info.pending, info.askedAt = true, GetTime()
		if C_Item and C_Item.RequestLoadItemDataByID then pcall(C_Item.RequestLoadItemDataByID, itemID) end
	end
	infoCache[itemID] = info
	return info
end

--[[
	Items the server knows nothing of are hidden from the journal's lists until confirmed: an
	/aegis items scan finds them (the player's own, kept in the saved file, and one built in from
	a scan, Data/Generated/Unconfirmed.lua). One shows again as soon as the server describes it, or
	a recorded run sees it drop. A creature listed only for such loot is hidden with it.
]]
local unconfirmed = {}
local RECHECK_PER_STEP, RECHECK_SECONDS = 25, 0.25

-- Adds items to hide until confirmed: { [itemID] = anything }.
function Items:AddUnconfirmed(items)
	for itemID in pairs(items or {}) do
		if type(itemID) == "number" then unconfirmed[itemID] = true end
	end
end

function Items:IsHidden(itemID)
	if not unconfirmed[itemID] then return false end
	local info = infoCache[itemID]
	if info and info.pending then Describe(info) end
	if info and info.link then return false end
	return not (ns.Recorder and ns.Recorder:SawItem(itemID))
end

-- A name-only item (keyed "?Name") whose real one has turned up on the same boss: an item there
-- with an id that the server has described under the same name. The name-only row gives way
-- to it (one source names an item, another gives its id).
function Items:Superseded(boss, row)
	if self:IsIdentified(row.itemID) or not row.name then return false end
	for _, other in ipairs(boss.loot or {}) do
		if self:IsIdentified(other.itemID) then
			local info = infoCache[other.itemID]
			if info and info.link and info.name == row.name then return true end
		end
	end
	return false
end

-- A creature the journal has nothing on but loot (no description, abilities, notes on the fight
-- or recorded fight), all of it hidden: most likely not in the game yet either. A boss written up
-- by hand is in the game even while Blizzard keeps all its drops hidden.
function Items:HidesBoss(boss)
	if boss.trash or boss.description or (boss.abilities and #boss.abilities > 0) or (boss.notes and #boss.notes > 0)
		or boss.encounterID then
		return false
	end
	local loot = boss.loot or {}
	if #loot == 0 then return false end
	for _, row in ipairs(loot) do
		if not self:IsHidden(row.itemID) then return false end
	end
	return true
end

-- Asks the server about the hidden items again, a few at a time: once a session, since Forever
-- adds items as it goes. Those it describes show again.
function Items:RecheckUnconfirmed()
	local list = {}
	for itemID in pairs(unconfirmed) do list[#list + 1] = itemID end
	local position = 1
	local function Next()
		for _ = 1, RECHECK_PER_STEP do
			local itemID = list[position]
			if not itemID then return end
			self:Get(itemID)
			position = position + 1
		end
		C_Timer.After(RECHECK_SECONDS, Next)
	end
	Next()
end

-- Whether a class (its file name, as UnitClass's second return) can equip the item.
-- Jewellery, cloaks, held off-hands and anything not equippable count as usable by all.
function Items:ClassCanUse(classFile, info)
	if not classFile or not info.classID or not info.equipLoc then return true end
	if info.classID == WEAPON then
		local weapons = CLASS_WEAPONS[classFile]
		if not weapons or info.subclassID == MISC_WEAPON or info.subclassID == FISHING then return true end
		return weapons[info.subclassID] == true
	end
	if info.classID == ARMOR then
		local armor = CLASS_ARMOR[classFile]
		if not armor or info.slot == "BACK" or info.subclassID == ARMOR_GENERIC then return true end
		return armor[info.subclassID] == true
	end
	return true
end

function Items:ArmorName(subclassID)
	local getSubClass = C_Item and C_Item.GetItemSubClassInfo or GetItemSubClassInfo
	local ok, name = pcall(getSubClass, ARMOR, subclassID)
	if ok and name then return name end
	return ({ [ARMOR_CLOTH] = "Cloth", [ARMOR_LEATHER] = "Leather", [ARMOR_MAIL] = "Mail", [ARMOR_PLATE] = "Plate" })[subclassID]
end

function Items:QualityColor(quality)
	if quality and C_Item and C_Item.GetItemQualityColor then
		local ok, r, g, b, hex = pcall(C_Item.GetItemQualityColor, quality)
		if ok and r then return r, g, b, hex end
	end
	if quality and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[quality] then
		local color = ITEM_QUALITY_COLORS[quality]
		return color.r, color.g, color.b, color.hex
	end
	return 1, 1, 1
end

-- The classes this client has, in its own order: { classFile, name, classID }.
function Items:Classes()
	local classes = {}
	local count = type(GetNumClasses) == "function" and GetNumClasses() or 0
	for classID = 1, count do
		local ok, name, classFile = pcall(GetClassInfo, classID)
		if ok and classFile and CLASS_ARMOR[classFile] then
			classes[#classes + 1] = { classFile = classFile, name = name, classID = classID }
		end
	end
	return classes
end
