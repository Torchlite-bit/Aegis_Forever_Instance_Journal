local _, ns = ...
local L = ns.L

--[[
	Dungeon maps on Blizzard's world map (M).

	Classic dungeons have maps of their own in the client (uiMapIDs such as the Deadmines'
	291 and 292). Where the world map can show one, it does, with the player's arrow and its
	own floor menu, and the journal's boss pins are added on top as a map data provider, the
	way retail's journal does it.

	Forever's own dungeons have no map in the client, and the client will not say where the
	player is inside them. Their map (Media/Maps) is laid over the world map's canvas instead,
	with the same pins and the area the player is in lit up, whenever the player is inside
	one or the journal's Show Map asks for it. A classic dungeon whose map this client cannot
	show gets the same overlay, drawn from the client's own map tiles. Right-click the overlay
	to see the world map beneath.

	Boss pins: the creature's portrait in the journal's round frame, dimmed and crossed out
	once killed on this run; a click opens the boss in the journal.
]]

local DungeonMap = {}
ns.DungeonMap = DungeonMap

local BOSS_PIN_TEMPLATE = "AegisJournalBossPinTemplate"
local SHEET = "Interface\\EncounterJournal\\UI-EncounterJournalTextures"
-- Retail's EncounterJournalPinTemplate cuts of the journal sheet.
local PIN_NORMAL = { 0.84960938, 0.97070313, 0.42871094, 0.48828125 }
local PIN_PUSHED = { 0.77734375, 0.89843750, 0.26953125, 0.32910156 }
local PIN_HIGHLIGHT = { 0.68945313, 0.81054688, 0.33300781, 0.39257813 }
local PIN_WIDTH, PIN_HEIGHT, PORTRAIT_SIZE = 50, 49, 36
local NO_PORTRAIT_SKULL = "Interface\\TargetingFrame\\UI-TargetingFrame-Skull"
local CIRCLE_MASK = "Interface\\CharacterFrame\\TempPortraitAlphaMask"
local DEFEATED_ATLAS = "Map-MarkedDefeated"
local TRANSITION_HIGHLIGHT = "Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight"

-- A classic map's tiles: 4 x 3 squares of 256, of which the top-left 1002 x 668 is the map.
local TILE_COLUMNS, TILE_ROWS, TILE_SIZE = 4, 3, 256
local TILE_MAP_WIDTH, TILE_MAP_HEIGHT = 1002, 668
-- Above other addons' dungeon overlays on the same canvas (MapUtils draws at 3000).
local OVERLAY_LEVEL = 5000
local DUNGEON_ATLAS, RAID_ATLAS = "Dungeon", "Raid"
-- What answers the mouse on a door or cave pin: the icon itself. The client's atlases draw it with
-- room around it, and a pin the atlas's size caught the cursor well off the swirl (a player's
-- report, 2026-10-20): the pin is this size, its art keeps its own, centred over it.
local PIN_HIT_SIZE = 22
-- The player's arrow on a sub-map's picture, and how often it follows the player.
local PLAYER_ARROW_ATLAS, PLAYER_ARROW_FILE = "WorldMapArrow", "Interface\\WorldMap\\WorldMapArrow"
local PLAYER_ARROW_SIZE, PLAYER_ARROW_SECONDS = 24, 0.1

local provider, overlay
local forced, dismissed, homeMapID
local chosenFloor = {}

------------------------------------------------------------------------------------------
-- Which dungeon, which floor
------------------------------------------------------------------------------------------

local function Floors(instance)
	return instance and instance.map and instance.map.floors or nil
end

-- The instance the player is inside, if the journal has it.
local function CurrentInstance()
	local ok, _, _, _, _, _, _, _, instanceID = pcall(GetInstanceInfo)
	instanceID = ok and ns.Readable(instanceID) or nil
	return instanceID and ns.GetInstanceByInstanceID(instanceID) or nil
end

local floorsByMapID
local function FloorByMapID(mapID)
	if not floorsByMapID then
		floorsByMapID = {}
		for _, kind in ipairs({ "dungeon", "raid" }) do
			for _, instance in ipairs(ns.GetInstances(kind)) do
				for index, floor in ipairs(Floors(instance) or {}) do
					if floor.uiMapID then floorsByMapID[floor.uiMapID] = { instance = instance, index = index } end
				end
			end
		end
	end
	return mapID and floorsByMapID[mapID] or nil
end

-- Whether Blizzard's world map can show this floor itself. A floor the journal has a picture of
-- is drawn from that picture all the same: the client's maps of the dungeons rebuilt in
-- Cataclysm mark the new bosses' rooms (Data/Authored/ClassicMaps.lua).
local native = {}
function DungeonMap:IsNative(floor)
	if not (floor and floor.uiMapID and C_Map) or floor.art then return false end
	if native[floor.uiMapID] == nil then
		local okInfo, info = pcall(C_Map.GetMapInfo, floor.uiMapID)
		local okLayers, layers = pcall(C_Map.GetMapArtLayers, floor.uiMapID)
		native[floor.uiMapID] = okInfo and info ~= nil and okLayers and type(layers) == "table" and #layers > 0
	end
	return native[floor.uiMapID]
end

function DungeonMap:HasMap(instance)
	local floors = Floors(instance)
	return floors ~= nil and #floors > 0
end

-- A dungeon the world map cannot show by itself.
local function NeedsOverlay(instance)
	local floors = Floors(instance)
	return floors ~= nil and #floors > 0 and not DungeonMap:IsNative(floors[1])
end

-- "Dungeon  Level 13-20", as the entrance pins and their area label say it.
local function EntranceDescription(instance)
	local kind = instance.kind == "raid" and L.ENTRANCE_RAID or L.ENTRANCE_DUNGEON
	if not instance.levelMin then return kind end
	return kind .. "  " .. string.format(L.LEVEL_RANGE, instance.levelMin, instance.levelMax or instance.levelMin)
end

local function FloorName(instance, index)
	local floor = Floors(instance)[index]
	local authored = instance.floorNames and instance.floorNames[index]
	if authored then return authored end
	if floor.uiMapID and C_Map and C_Map.GetMapInfo then
		local ok, info = pcall(C_Map.GetMapInfo, floor.uiMapID)
		if ok and info and info.name and info.name ~= "" and info.name ~= instance.name then return info.name end
	end
	return string.format(L.MAP_FLOOR, index)
end

------------------------------------------------------------------------------------------
-- Bosses killed on this run
------------------------------------------------------------------------------------------

local defeated = {}

local function BossNamed(instance, name)
	if not (instance and name) then return nil end
	for _, boss in ipairs(instance.bosses) do
		if boss.name == name or boss.enName == name then return boss end
		for _, alias in ipairs(boss.aliases or {}) do
			if alias == name then return boss end
		end
	end
	return nil
end

-- The boss an encounter ended for: by the encounter's id where the journal knows it (the
-- client's name for a fight is not always the boss's, Magmatus's is "Infurnus"), else by name.
local function BossForEncounter(instance, encounterID, name)
	if instance and encounterID then
		for _, boss in ipairs(instance.bosses) do
			if boss.encounterID == encounterID then return boss end
		end
	end
	return BossNamed(instance, name)
end

function DungeonMap:IsDefeated(instance, boss)
	return defeated[instance.key] ~= nil and defeated[instance.key][boss.name] == true
end

function DungeonMap:MarkDefeated(instance, boss)
	defeated[instance.key] = defeated[instance.key] or {}
	defeated[instance.key][boss.name] = true
	self:Refresh()
end

--[[
	A boss the game holds no encounter for (the Excavation Site's Highland Horror, a rare) ends no
	fight, so ENCOUNTER_END never names it. Forever keeps the combat log from addons: registering
	COMBAT_LOG_EVENT_UNFILTERED, or even unregistering it, is a forbidden action, which pcall does
	not catch. So the boss is marked when the player sees him lying dead: as their target, focus or
	mouseover (as its health or flags change, as the target or mouseover changes, and once combat
	ends, should the client have kept it back during the fight), or as his corpse is looted. Known
	by his creature id where the journal knows it, else by his name. Watched only inside a dungeon
	that has such a boss.
]]
local deaths = CreateFrame("Frame")
local DEATH_EVENTS = { "UNIT_HEALTH", "UNIT_FLAGS", "PLAYER_TARGET_CHANGED", "UPDATE_MOUSEOVER_UNIT",
	"PLAYER_REGEN_ENABLED", "LOOT_OPENED" }
local LOOKED_AT = { "target", "focus", "mouseover" }
local watched, watchedInstance

local function CreatureID(guid)
	local kind, _, _, _, _, id = strsplit("-", guid or "")
	if kind == "Creature" or kind == "Vehicle" then return tonumber(id) end
	return nil
end

local function WatchDeaths(instance)
	watched, watchedInstance = nil, instance
	for _, boss in ipairs(instance and instance.bosses or {}) do
		if not boss.encounterID and not boss.trash then
			watched = watched or {}
			if boss.npcID then watched[boss.npcID] = boss end
			watched[boss.name] = boss
			if boss.enName then watched[boss.enName] = boss end
		end
	end
	if watched then
		ns.RegisterEvents(deaths, unpack(DEATH_EVENTS))
	else
		ns.UnregisterEvents(deaths, unpack(DEATH_EVENTS))
	end
end

local function Fallen(boss)
	if boss and not DungeonMap:IsDefeated(watchedInstance, boss) then DungeonMap:MarkDefeated(watchedInstance, boss) end
end

-- A unit the player has at hand, if it is a watched boss lying dead. What the client keeps back
-- counts as not known.
local function LooksDead(unit)
	local ok, dead = pcall(UnitIsDead, unit)
	if not ok or ns.Readable(dead) ~= true then return end
	Fallen(watched[CreatureID(ns.Readable(UnitGUID(unit))) or 0] or watched[ns.Readable(UnitName(unit)) or ""])
end

deaths:SetScript("OnEvent", function(_, event, unit)
	if not (watched and watchedInstance) then return end
	if event == "LOOT_OPENED" then
		-- Each slot names the corpses it comes from: guid, count, guid, count, ...
		for slot = 1, GetNumLootItems() do
			local sources = { pcall(GetLootSourceInfo, slot) }
			for index = 2, sources[1] and #sources or 0, 2 do
				Fallen(watched[CreatureID(ns.Readable(sources[index])) or 0])
			end
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		for _, looked in ipairs(LOOKED_AT) do LooksDead(looked) end
	elseif event == "PLAYER_TARGET_CHANGED" then
		LooksDead("target")
	elseif event == "UPDATE_MOUSEOVER_UNIT" then
		LooksDead("mouseover")
	elseif type(unit) == "string" then
		LooksDead(unit)
	end
end)

------------------------------------------------------------------------------------------
-- Boss pins
------------------------------------------------------------------------------------------

local function Masked(owner, texture)
	if owner.CreateMaskTexture and texture.AddMaskTexture then
		local mask = owner:CreateMaskTexture()
		mask:SetTexture(CIRCLE_MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
		mask:SetAllPoints(texture)
		texture:AddMaskTexture(mask)
	end
	return texture
end

local function SetSheetTexture(texture, coords)
	texture:SetTexture(SHEET)
	texture:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
end

-- Retail's EncounterJournalPinTemplate, built on any button.
local function BuildBossPin(pin)
	pin:SetSize(PIN_WIDTH, PIN_HEIGHT)
	pin.Portrait = Masked(pin, pin:CreateTexture(nil, "BACKGROUND"))
	pin.Portrait:SetSize(PORTRAIT_SIZE, PORTRAIT_SIZE)
	pin.Portrait:SetPoint("CENTER")
	-- For a boss the client has no portrait of: the target skull on a dark disc.
	pin.Skull = pin:CreateTexture(nil, "ARTWORK")
	pin.Skull:SetTexture(NO_PORTRAIT_SKULL)
	pin.Skull:SetSize(20, 20)
	pin.Skull:SetPoint("CENTER")
	pin.Skull:Hide()
	pin.Shade = Masked(pin, pin:CreateTexture(nil, "OVERLAY"))
	pin.Shade:SetPoint("TOPLEFT", pin.Portrait, "TOPLEFT", -1, 1)
	pin.Shade:SetPoint("BOTTOMRIGHT", pin.Portrait, "BOTTOMRIGHT", 1, -1)
	pin.Shade:SetColorTexture(0, 0, 0, 0.4)
	pin.Cross = pin:CreateTexture(nil, "OVERLAY", nil, 2)
	pin.Cross:SetAtlas(DEFEATED_ATLAS, true)
	pin.Cross:SetPoint("BOTTOMRIGHT", 4, -4)

	pin:SetNormalTexture(SHEET)
	SetSheetTexture(pin:GetNormalTexture(), PIN_NORMAL)
	pin:SetPushedTexture(SHEET)
	SetSheetTexture(pin:GetPushedTexture(), PIN_PUSHED)
	pin:SetHighlightTexture(SHEET, "ADD")
	SetSheetTexture(pin:GetHighlightTexture(), PIN_HIGHLIGHT)
end

local function SetBossPin(pin, instance, boss)
	pin.instance, pin.boss = instance, boss
	local hasPortrait = false
	if boss.displayID and type(SetPortraitTextureFromCreatureDisplayID) == "function" then
		hasPortrait = pcall(SetPortraitTextureFromCreatureDisplayID, pin.Portrait, boss.displayID)
	end
	if not hasPortrait then pin.Portrait:SetColorTexture(0.1, 0.07, 0.04, 1) end
	pin.Skull:SetShown(not hasPortrait)
	local dead = DungeonMap:IsDefeated(instance, boss)
	pin.Shade:SetShown(dead)
	pin.Cross:SetShown(dead)
	pin.Portrait:SetDesaturated(dead)
	pin.Skull:SetDesaturated(dead)
end

--[[
	Where a boss may be on the map: most have one spot (mapPin); one that is not always in the
	same place (a Fanglord, a prisoner in one of several cells) gives all of them (mapPins), and
	has a pin on each.
]]
local function BossSpots(boss)
	if boss.mapPins then return boss.mapPins end
	return boss.mapPin and { boss.mapPin } or {}
end
DungeonMap.BossSpots = BossSpots

--[[
	Those spots are maybes: each gets a smaller, faded pin, so the bosses that always stand in
	one place read first. Pointing at one lights up every spot of that boss at full size, and
	fades the other bosses' maybes further; the bosses with one spot stay as they are.
]]
local MAYBE_SCALE, MAYBE_ALPHA, MAYBE_DIMMED_ALPHA = 0.65, 0.6, 0.3

-- An entry that is several creatures at once (together = true: the Sunken Temple's six balcony
-- trolls) has a pin on each of their spots, every one sure. A boss that is one of several that
-- may come to one place (maybe = true: Blackrock Depths' arena challengers) is a maybe too.
local function IsMaybe(boss)
	return boss.maybe == true or (not boss.together and #BossSpots(boss) > 1)
end

-- How faded a pin is, given the boss whose spots are lit (if any).
local function MaybeAlpha(pin, litBoss)
	if not pin.maybe or pin.boss == litBoss then return 1 end
	return litBoss and MAYBE_DIMMED_ALPHA or MAYBE_ALPHA
end

local function ShowBossTooltip(pin)
	local boss = pin.boss
	GameTooltip:SetOwner(pin, "ANCHOR_LEFT")
	GameTooltip:SetText(boss.name, 1, 0.82, 0)
	if boss.level then GameTooltip:AddLine(string.format(L.MAP_LEVEL, boss.level), 1, 1, 1) end
	local spots = #BossSpots(boss)
	if spots > 1 and not boss.together then GameTooltip:AddLine(string.format(L.MAP_ONE_OF, spots), 0.8, 0.8, 0.8, true) end
	if DungeonMap:IsDefeated(pin.instance, boss) then GameTooltip:AddLine(L.MAP_DEFEATED, 1, 0.13, 0.13) end
	if boss.description and boss.description ~= "" then GameTooltip:AddLine(boss.description, 1, 1, 1, true) end
	GameTooltip:AddLine(L.MAP_PIN_OPEN, 0.5, 0.8, 1)
	GameTooltip:Show()
end

-- Opens the boss in the journal, putting the world map away first (out of combat only).
function DungeonMap:OpenBoss(instance, boss)
	ns.PlaySoundKit("IG_SPELLBOOK_OPEN")
	if WorldMapFrame and WorldMapFrame:IsShown() and not InCombatLockdown() and type(HideUIPanel) == "function" then
		pcall(HideUIPanel, WorldMapFrame)
	end
	ns.Journal:Show()
	ns.Journal:OpenBoss(instance, boss)
end

-- The template's mixin, which the map canvas pin mixin joins once the world map exists.
AegisJournalBossPinMixin = {}
--[[
	The map canvas sets each pin's mouse pass-through as it hands the pin out, and in combat
	the client allows SetPassThroughButtons only from its own code: from an addon's data
	provider it is blocked (ADDON_ACTION_BLOCKED). The journal's pins pass nothing through, or
	only a right click, so in combat they keep what they have and the rest waits for its end.
	Shared by every pin the journal puts on the map.
]]
function DungeonMap.CheckMouseButtonPassthrough(pin, ...)
	if InCombatLockdown() then return end
	if MapCanvasPinMixin and MapCanvasPinMixin.CheckMouseButtonPassthrough then
		MapCanvasPinMixin.CheckMouseButtonPassthrough(pin, ...)
	end
end

local BossPinMethods = { CheckMouseButtonPassthrough = DungeonMap.CheckMouseButtonPassthrough }

function BossPinMethods:OnLoad()
	BuildBossPin(self)
	self:SetScalingLimits(1, 0.7, 1.3)
	self:UseFrameLevelType("PIN_FRAME_LEVEL_ENCOUNTER")
end

function BossPinMethods:OnAcquired(instance, boss)
	SetBossPin(self, instance, boss)
	self.maybe = IsMaybe(boss)
	self:SetScalingLimits(self.maybe and MAYBE_SCALE or 1, 0.7, 1.3)
	self:SetAlpha(MaybeAlpha(self, nil))
end

-- On the client's own map the lit spots only lose their fading; their size stays.
local function LightNativePins(map, litBoss)
	for pin in map:EnumeratePinsByTemplate(BOSS_PIN_TEMPLATE) do pin:SetAlpha(MaybeAlpha(pin, litBoss)) end
end

function BossPinMethods:OnMouseEnter()
	if self.maybe then LightNativePins(self:GetMap(), self.boss) end
	ShowBossTooltip(self)
end

function BossPinMethods:OnMouseLeave()
	GameTooltip:Hide()
	if self.maybe then LightNativePins(self:GetMap(), nil) end
end

function BossPinMethods:OnMouseClickAction(button)
	if button == "LeftButton" then DungeonMap:OpenBoss(self.instance, self.boss) end
end

------------------------------------------------------------------------------------------
-- The overlay, for dungeons the world map cannot show
------------------------------------------------------------------------------------------

local function Canvas()
	if not WorldMapFrame then return nil end
	if WorldMapFrame.GetCanvas then
		local ok, canvas = pcall(WorldMapFrame.GetCanvas, WorldMapFrame)
		if ok and canvas then return canvas end
	end
	return WorldMapFrame.ScrollContainer and WorldMapFrame.ScrollContainer.Child or nil
end

local function Container()
	return WorldMapFrame and WorldMapFrame.ScrollContainer or WorldMapFrame
end

local function Dismiss()
	dismissed, forced = true, nil
	DungeonMap:Refresh()
end

local function CreateFloorDropdown()
	local ok, dropdown = pcall(CreateFrame, "DropdownButton", nil, Container(), "WowStyle1DropdownTemplate")
	if not (ok and dropdown and dropdown.SetupMenu) then return nil end
	dropdown:SetWidth(200)
	-- Forever keeps the map pin button in the canvas's top-left corner; the menu sits beside it.
	local pinButton = rawget(WorldMapFrame, "WorldMapTrackingPinButton")
	if pinButton then
		dropdown:SetPoint("LEFT", pinButton, "RIGHT", 6, 0)
	else
		dropdown:SetPoint("TOPLEFT", Container(), "TOPLEFT", 6, -6)
	end
	dropdown:SetFrameLevel(overlay:GetFrameLevel() + 100)
	dropdown:SetupMenu(function(_, root)
		local instance = overlay.instance
		if not instance then return end
		for index in ipairs(Floors(instance)) do
			root:CreateRadio(FloorName(instance, index),
				function() return overlay.floor == index end,
				function()
					chosenFloor[instance.key] = index
					DungeonMap:Refresh()
				end)
		end
	end)
	dropdown:Hide()
	return dropdown
end

--[[
	Other addons' map pins drawn in a higher strata than the map's own (RareScanner's are HIGH
	and DIALOG) would show through the dungeon map, since a higher strata always draws on top.
	While it is up they are moved into its strata, beneath it, and given their own back when it
	closes. Pools reuse their pins and their owners raise them again as they show, so each moved
	pin is moved again whenever it shows while the map is up. Only the canvas's own pins are
	touched, never the map's buttons.
]]
local STRATA_RANK = {
	BACKGROUND = 1, LOW = 2, MEDIUM = 3, HIGH = 4, DIALOG = 5, FULLSCREEN = 6, FULLSCREEN_DIALOG = 7, TOOLTIP = 8,
}
local tucked = {}                                    -- frame -> { strata, level } it had
local tuckWatched = setmetatable({}, { __mode = "k" })

local function TuckUnder(frame)
	if not (overlay and overlay:IsShown()) or frame == overlay then return end
	local strata, own = frame:GetFrameStrata(), overlay:GetFrameStrata()
	if (STRATA_RANK[strata] or 0) <= (STRATA_RANK[own] or 0) then return end
	-- Its owner raised the strata again; the level is still the one this moved it to.
	local was = tucked[frame]
	tucked[frame] = { strata, was and was[2] or frame:GetFrameLevel() }
	frame:SetFrameStrata(own)
	if frame:GetFrameLevel() >= overlay:GetFrameLevel() then frame:SetFrameLevel(overlay:GetFrameLevel() - 1) end
	if not tuckWatched[frame] then
		tuckWatched[frame] = true
		frame:HookScript("OnShow", TuckUnder)
	end
end

-- The canvas's pins, and the pins of layers other addons put on it.
local function TuckForeignPins()
	local canvas = Canvas()
	if not (canvas and overlay and overlay:IsShown()) then return end
	for _, child in ipairs({ canvas:GetChildren() }) do
		if child ~= overlay then
			TuckUnder(child)
			for _, pin in ipairs({ child:GetChildren() }) do TuckUnder(pin) end
		end
	end
end

--[[
	The map's own buttons over the canvas (the quest log's toggle in its corner, the filter and pin
	buttons, the floor menu) stay above the dungeon map, so they can still be pointed at and clicked
	while it shows: one the overlay would sit over is lifted just above it, and put back as it was
	when the overlay goes. Only their strata and level change.
]]
local lifted = {}                                    -- frame -> { strata, level } it had
local MAX_FRAME_LEVEL = 10000

local function LiftMapButtons()
	if not (overlay and overlay:IsShown() and WorldMapFrame) then return end
	local buttons = {}
	for _, frame in ipairs(WorldMapFrame.overlayFrames or {}) do buttons[#buttons + 1] = frame end
	if WorldMapFrame.SidePanelToggle then buttons[#buttons + 1] = WorldMapFrame.SidePanelToggle end
	local strata, level = overlay:GetFrameStrata(), overlay:GetFrameLevel()
	local own = STRATA_RANK[strata] or 0
	for _, frame in ipairs(buttons) do
		local rank = STRATA_RANK[frame:GetFrameStrata()] or 0
		if rank < own or (rank == own and frame:GetFrameLevel() <= level) then
			lifted[frame] = lifted[frame] or { frame:GetFrameStrata(), frame:GetFrameLevel() }
			if rank < own then frame:SetFrameStrata(strata) end
			frame:SetFrameLevel(math.min(level + 20, MAX_FRAME_LEVEL))
		end
	end
end

local function DropMapButtons()
	for frame, was in pairs(lifted) do
		frame:SetFrameStrata(was[1])
		frame:SetFrameLevel(was[2])
		lifted[frame] = nil
	end
end

local function UntuckForeignPins()
	DropMapButtons()
	for frame, was in pairs(tucked) do
		frame:SetFrameStrata(was[1])
		frame:SetFrameLevel(was[2])
		tucked[frame] = nil
	end
end

-- After drawing: and once more on the next frame, for providers that refresh after this one.
local function TuckAfterDraw()
	TuckForeignPins()
	LiftMapButtons()
	if C_Timer and C_Timer.After then C_Timer.After(0, TuckForeignPins) end
end

local function CreateOverlay()
	local canvas = Canvas()
	if not canvas then return nil end
	overlay = CreateFrame("Frame", nil, canvas)
	overlay:SetAllPoints(canvas)
	overlay:SetFrameLevel(canvas:GetFrameLevel() + OVERLAY_LEVEL)
	overlay:EnableMouse(true)
	overlay:SetScript("OnHide", UntuckForeignPins)
	overlay:SetScript("OnMouseUp", function(_, button)
		if button == "RightButton" then Dismiss() end
	end)
	overlay.Background = overlay:CreateTexture(nil, "BACKGROUND")
	overlay.Background:SetAllPoints()
	overlay.Background:SetColorTexture(0, 0, 0, 1)

	-- The picture, cut to the map's own shape so tiles past its edge do not show.
	local art = CreateFrame("Frame", nil, overlay)
	art:SetPoint("CENTER")
	if art.SetClipsChildren then art:SetClipsChildren(true) end
	art.Picture = art:CreateTexture(nil, "ARTWORK")
	art.Picture:SetAllPoints()
	art.Tiles = {}
	overlay.Art = art

	-- Where the player is, by area name: the client gives no position in these dungeons.
	local here = CreateFrame("Frame", nil, overlay)
	here:SetFrameLevel(overlay:GetFrameLevel() + 5)
	here.Glow = Masked(here, here:CreateTexture(nil, "ARTWORK"))
	here.Glow:SetAllPoints()
	here.Glow:SetColorTexture(1, 0.82, 0.2, 0.35)
	here.Ring = here:CreateTexture(nil, "OVERLAY")
	here.Ring:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
	here.Ring:SetBlendMode("ADD")
	here.Ring:SetAllPoints()
	here.Label = here:CreateFontString(nil, "OVERLAY", ns.Font("GameFontNormalOutline", "GameFontNormal"))
	here.Label:SetPoint("BOTTOM", here, "TOP", 0, 2)
	here.Label:SetText(L.MAP_YOU_ARE_HERE)
	local pulse = here.CreateAnimationGroup and here:CreateAnimationGroup()
	local fade = pulse and pulse:CreateAnimation("Alpha")
	if fade then
		pulse:SetLooping("BOUNCE")
		fade:SetFromAlpha(1)
		fade:SetToAlpha(0.35)
		fade:SetDuration(0.9)
		here.pulse = pulse
	end
	here:Hide()
	overlay.Here = here

	overlay.Pins, overlay.Transitions, overlay.Doors, overlay.QuestSpots = {}, {}, {}, {}

	-- The player's own arrow, for the areas below a zone where the client gives a position.
	local player = CreateFrame("Frame", nil, overlay)
	player:SetSize(PLAYER_ARROW_SIZE, PLAYER_ARROW_SIZE)
	player:SetFrameLevel(overlay:GetFrameLevel() + 20)
	player.Arrow = player:CreateTexture(nil, "OVERLAY")
	player.Arrow:SetAllPoints()
	if not ns.SetAtlasOrFile(player.Arrow, PLAYER_ARROW_ATLAS, PLAYER_ARROW_FILE) then
		player.Arrow:SetTexture(PLAYER_ARROW_FILE)
	end
	player:Hide()
	overlay.PlayerPin = player

	overlay.FloorDropdown = CreateFloorDropdown()
	overlay:Hide()
	return overlay
end

local RestyleBossPins -- below, once pins can be placed

local function OverlayPin(index)
	local pin = overlay.Pins[index]
	if not pin then
		pin = CreateFrame("Button", nil, overlay)
		BuildBossPin(pin)
		pin:SetFrameLevel(overlay:GetFrameLevel() + 10)
		pin:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		pin:SetScript("OnEnter", function(self)
			if self.maybe then
				overlay.litBoss = self.boss
				RestyleBossPins()
			end
			ShowBossTooltip(self)
		end)
		pin:SetScript("OnLeave", function()
			GameTooltip:Hide()
			if overlay.litBoss then
				overlay.litBoss = nil
				RestyleBossPins()
			end
		end)
		pin:SetScript("OnClick", function(self, button)
			if button == "RightButton" then Dismiss() else DungeonMap:OpenBoss(self.instance, self.boss) end
		end)
		overlay.Pins[index] = pin
	end
	return pin
end

-- A spot where the dungeon carries on to another floor (the art prints the arrow).
local function TransitionPin(index)
	local spot = overlay.Transitions[index]
	if not spot then
		spot = CreateFrame("Button", nil, overlay)
		spot:SetSize(30, 30)
		spot:SetFrameLevel(overlay:GetFrameLevel() + 8)
		spot:SetHighlightTexture(TRANSITION_HIGHLIGHT, "ADD")
		spot:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(string.format(L.MAP_GO_TO, FloorName(self.instance, self.to)), 1, 1, 1)
			GameTooltip:Show()
		end)
		spot:SetScript("OnLeave", function() GameTooltip:Hide() end)
		spot:SetScript("OnClick", function(self)
			ns.PlaySoundKit("IG_MAINMENU_OPTION")
			chosenFloor[self.instance.key] = self.to
			DungeonMap:Refresh()
		end)
		overlay.Transitions[index] = spot
	end
	return spot
end

-- Where a quest starts (or is handed in) inside the dungeon, as on the world map (UI/QuestMap.lua):
-- a click opens it in the journal, a right click puts the map away.
local function QuestSpot(index)
	local spot = overlay.QuestSpots[index]
	if not spot then
		spot = CreateFrame("Button", nil, overlay)
		spot:SetSize(24, 24)
		spot:SetFrameLevel(overlay:GetFrameLevel() + 12)
		spot.Texture = spot:CreateTexture(nil, "ARTWORK")
		spot.Texture:SetAllPoints()
		spot:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		spot:SetScript("OnEnter", function(self)
			ns.QuestMap:ShowTooltip(self, self.instance, self.quest, self.mark, { L.QUESTMAP_LEFT_CLICK })
			ns.QuestMap:LegendEnter(self.mark)
		end)
		spot:SetScript("OnLeave", function()
			GameTooltip:Hide()
			ns.QuestMap:LegendLeave()
		end)
		spot:SetScript("OnClick", function(self, button)
			if button == "RightButton" then Dismiss() else ns.QuestMap:Open(self.instance, self.quest) end
		end)
		overlay.QuestSpots[index] = spot
	end
	return spot
end

-- Lays the floor's picture into the canvas, as large as fits.
local function LayoutArt(floor)
	local canvas = overlay:GetParent()
	local width, height = canvas:GetWidth(), canvas:GetHeight()
	if not width or width <= 0 or not height or height <= 0 then return false end
	-- Width over height: a square picture cut at artRight and artBottom, or the tiles' visible map.
	local ratio = floor.art and (floor.artRight or 1) / (floor.artBottom or 1) or TILE_MAP_WIDTH / TILE_MAP_HEIGHT
	local artWidth, artHeight = width, width / ratio
	if artHeight > height then artHeight, artWidth = height, height * ratio end
	overlay.Art:SetSize(artWidth, artHeight)
	overlay.artWidth, overlay.artHeight = artWidth, artHeight
	return true
end

-- Draws the floor's picture; skipped when the same floor is already drawn at the same size.
local function DrawArt(floor)
	local art = overlay.Art
	if art.floor == floor and art.width == overlay.artWidth and art.height == overlay.artHeight then return end
	art.floor, art.width, art.height = floor, overlay.artWidth, overlay.artHeight
	for _, tile in ipairs(art.Tiles) do tile:Hide() end
	if floor.art then
		art.Picture:SetTexture(floor.art)
		art.Picture:SetTexCoord(0, floor.artRight or 1, 0, floor.artBottom or 1)
		art.Picture:Show()
		return
	end
	art.Picture:Hide()
	-- The client's own tiles, numbered 1-12 left to right, top to bottom.
	local tileWidth = overlay.artWidth * TILE_SIZE / TILE_MAP_WIDTH
	local tileHeight = overlay.artHeight * TILE_SIZE / TILE_MAP_HEIGHT
	for index = 1, TILE_COLUMNS * TILE_ROWS do
		local tile = art.Tiles[index]
		if not tile then
			tile = art:CreateTexture(nil, "ARTWORK")
			art.Tiles[index] = tile
		end
		local column, row = (index - 1) % TILE_COLUMNS, math.floor((index - 1) / TILE_COLUMNS)
		tile:SetTexture(floor.tiles .. index)
		tile:SetSize(tileWidth, tileHeight)
		tile:ClearAllPoints()
		tile:SetPoint("TOPLEFT", art, "TOPLEFT", column * tileWidth, -row * tileHeight)
		tile:Show()
	end
end

-- Pins keep their size on screen as the map zooms.
local function PinScale()
	local scale = overlay:GetParent():GetScale()
	if not scale or scale <= 0 then return 1 end
	return 1 / scale
end

local function Place(frame, x, y, scale, shift)
	frame:SetScale(scale)
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", overlay.Art, "TOPLEFT", x * overlay.artWidth / scale + (shift or 0), -y * overlay.artHeight / scale)
end

-- Pins of bosses sharing a spot (the Graveyard's rares, one of which may stand there) sit side by side.
local SHARED_SPOT_SPACING = 30

-- A boss pin's size, fading and place, from its spot and the boss whose spots are lit.
local function StyleBossPin(pin)
	local lit = pin.boss == overlay.litBoss
	pin:SetAlpha(MaybeAlpha(pin, overlay.litBoss))
	pin:SetFrameLevel(overlay:GetFrameLevel() + (lit and 11 or 10))
	local size = pin.maybe and not lit and MAYBE_SCALE or 1
	Place(pin, pin.point.x, pin.point.y, overlay.pinScale * size, pin.shift)
end

function RestyleBossPins()
	for _, pin in ipairs(overlay.Pins) do
		if pin:IsShown() then StyleBossPin(pin) end
	end
end

local function DrawPins(instance, index)
	local scale = PinScale()
	local spots, together, litHere = {}, {}, false
	for _, boss in ipairs(instance.bosses) do
		if not boss.trash and not ns.Items:HidesBoss(boss) then
			for _, point in ipairs(BossSpots(boss)) do
				if (point.floor or 1) == index then
					local key = string.format("%.3f:%.3f", point.x, point.y)
					together[key] = (together[key] or 0) + 1
					spots[#spots + 1] = { boss = boss, point = point, key = key, place = together[key] }
					litHere = litHere or boss == overlay.litBoss
				end
			end
		end
	end
	-- Lit spots belong to the floor they were lit on.
	if not litHere then overlay.litBoss = nil end
	overlay.pinScale = scale
	for count, spot in ipairs(spots) do
		local pin = OverlayPin(count)
		SetBossPin(pin, instance, spot.boss)
		pin.maybe, pin.point = IsMaybe(spot.boss), spot.point
		pin.shift = (spot.place - (together[spot.key] + 1) / 2) * SHARED_SPOT_SPACING
		StyleBossPin(pin)
		pin:Show()
	end
	local count = #spots
	for extra = count + 1, #overlay.Pins do overlay.Pins[extra]:Hide() end

	local spots = 0
	for _, transition in ipairs(instance.map.transitions or {}) do
		if transition.floor == index and Floors(instance)[transition.to] then
			spots = spots + 1
			local spot = TransitionPin(spots)
			spot.instance, spot.to = instance, transition.to
			Place(spot, transition.x, transition.y, scale)
			spot:Show()
		end
	end
	for extra = spots + 1, #overlay.Transitions do overlay.Transitions[extra]:Hide() end

	local marks = ns.QuestMap and ns.QuestMap:InsideMarks(instance, index) or {}
	for count, entry in ipairs(marks) do
		local spot = QuestSpot(count)
		spot.instance, spot.quest, spot.mark = instance, entry.quest, entry.mark
		ns.QuestMap:SetMarkTexture(spot.Texture, entry.mark)
		Place(spot, entry.x, entry.y, scale)
		spot:Show()
	end
	for extra = #marks + 1, #overlay.QuestSpots do overlay.QuestSpots[extra]:Hide() end
end

-- The area the player stands in, where the journal knows where that area is on the map.
local function DrawHere(instance, index)
	local here = overlay.Here
	local area
	if instance == CurrentInstance() then
		local ok, subzone = pcall(GetSubZoneText)
		subzone = ok and ns.Readable(subzone) or nil
		area = subzone and ns.AreaIn(instance.mapAreas, subzone)
	end
	if not area or (area.floor or 1) ~= index then
		here:Hide()
		if here.pulse then here.pulse:Stop() end
		return
	end
	local size = (area.radius or 0.05) * 2 * overlay.artWidth
	here:SetSize(size, size)
	here:ClearAllPoints()
	here:SetPoint("CENTER", overlay.Art, "TOPLEFT", area.x * overlay.artWidth, -area.y * overlay.artHeight)
	here:Show()
	if here.pulse and not here.pulse:IsPlaying() then here.pulse:Play() end
end

------------------------------------------------------------------------------------------
-- Areas below a zone (Old Ironforge): their picture, the dungeons in them, the player
------------------------------------------------------------------------------------------

-- The picture's place for a position on the zone's own map, or nil when it is off the picture
-- (or the picture is of a place the client gives no position in).
local function OnSubMap(subMap, x, y)
	local bounds = subMap.bounds
	if not bounds then return nil end
	local px, py = (x - bounds.left) / bounds.width, (y - bounds.top) / bounds.height
	if px < 0 or px > 1 or py < 0 or py > 1 then return nil end
	return px, py
end

-- The area below a zone the player was last seen in.
local playerBelow

-- The zone's name, as the minimap shows it, else the zone's own.
local function ZoneName()
	for _, fn in ipairs({ GetMinimapZoneText, GetRealZoneText }) do
		local ok, name = pcall(fn)
		name = ok and ns.Readable(name) or nil
		if type(name) == "string" and name ~= "" then return name end
	end
	return nil
end

-- The area below `mapID` the player is in: inside its picture, in a spot the streets above
-- do not name. Some spots below share a name with a street above (sharedAreas): once the
-- player has been seen below, those keep them there. Where the client gives no map at all
-- (the Deeprun Tram), the zone's name tells the place (zones), over any map.
local function PlayerSubMap(mapID)
	local playerMap, x, y = ns.PlayerMapPosition()
	local below
	if x then
		local ok, area = pcall(GetSubZoneText)
		area = ok and ns.Readable(area) or nil
		for _, subMap in ipairs(ns.GetSubMaps()) do
			if area and subMap.areas and subMap.parentMapID == playerMap and OnSubMap(subMap, x, y) and (ns.AreaIn(subMap.areas, area)
				or (subMap == playerBelow and ns.AreaIn(subMap.sharedAreas, area))) then
				below = subMap
				break
			end
		end
	elseif not playerMap then
		local zone = ZoneName()
		for _, subMap in ipairs(ns.GetSubMaps()) do
			if zone and ns.AreaIn(subMap.zones, zone) then
				below = subMap
				break
			end
		end
	end
	playerBelow = below
	if below and (below.parentMapID == mapID or not below.parentMapID) then return below end
	return nil
end

-- A dungeon's door on a sub-map's picture: retail's dungeon icon; a click opens the journal.
local function SubMapDoor(index)
	local door = overlay.Doors[index]
	if not door then
		door = CreateFrame("Button", nil, overlay)
		door:SetSize(32, 32)
		door:SetFrameLevel(overlay:GetFrameLevel() + 10)
		door.Texture = door:CreateTexture(nil, "ARTWORK")
		door.Texture:SetAllPoints()
		door.Texture:SetAtlas(DUNGEON_ATLAS)
		door:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
		door:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		door:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.instance.name, 1, 1, 1)
			GameTooltip:AddLine(EntranceDescription(self.instance), 1, 0.82, 0)
			GameTooltip:AddLine(L.ENTRANCE_LEFT_CLICK, 0.1, 1, 0.1)
			GameTooltip:Show()
		end)
		door:SetScript("OnLeave", function() GameTooltip:Hide() end)
		door:SetScript("OnClick", function(self, button)
			if button == "RightButton" then Dismiss() else DungeonMap:OpenInstance(self.instance) end
		end)
		overlay.Doors[index] = door
	end
	return door
end

local function StopPlayerArrow()
	if overlay and overlay.playerTicker then
		overlay.playerTicker:Cancel()
		overlay.playerTicker = nil
	end
	if overlay then overlay.PlayerPin:Hide() end
end

-- The player's arrow on a sub-map: the client reports the position on the zone's map, and
-- the calibration places it on the picture. It moves only while the picture shows.
local function UpdatePlayerArrow()
	local subMap = overlay and overlay:IsShown() and overlay.subMap
	if not subMap then return StopPlayerArrow() end
	local pin = overlay.PlayerPin
	local mapID, x, y = ns.PlayerMapPosition()
	local px, py
	if subMap.parentMapID and mapID == subMap.parentMapID and x then px, py = OnSubMap(subMap, x, y) end
	if not px then
		pin:Hide()
		return
	end
	Place(pin, px, py, PinScale())
	local ok, facing = pcall(GetPlayerFacing)
	facing = ok and ns.Readable(facing) or nil
	if facing then pin.Arrow:SetRotation(facing) end
	pin:Show()
end

local function DrawSubMap(subMap)
	overlay.instance, overlay.subMap = nil, subMap
	if not LayoutArt(subMap) then return false end
	DrawArt(subMap)
	for _, pin in ipairs(overlay.Pins) do pin:Hide() end
	for _, spot in ipairs(overlay.Transitions) do spot:Hide() end
	overlay.Here:Hide()
	if overlay.FloorDropdown then overlay.FloorDropdown:Hide() end
	local scale, count = PinScale(), 0
	for key, point in pairs(subMap.instances) do
		local instance = ns.GetInstance(key)
		if instance then
			count = count + 1
			local door = SubMapDoor(count)
			door.instance = instance
			Place(door, point.x, point.y, scale)
			door:Show()
		end
	end
	for extra = count + 1, #overlay.Doors do overlay.Doors[extra]:Hide() end
	overlay:Show()
	UpdatePlayerArrow()
	if not overlay.playerTicker and C_Timer.NewTicker then
		overlay.playerTicker = C_Timer.NewTicker(PLAYER_ARROW_SECONDS, UpdatePlayerArrow)
	end
	return true
end

-- What the overlay should show now: a dungeon, a sub-map, or neither.
local function OverlayTarget(mapID)
	if forced then
		if forced.mapID == mapID then return forced.instance, forced.subMap end
		forced = nil
	end
	if dismissed then return nil end
	-- Over the map the world map opened on, not while the player browses elsewhere.
	homeMapID = homeMapID or mapID
	if mapID ~= homeMapID then return nil end
	local instance = CurrentInstance()
	if instance then
		if NeedsOverlay(instance) then return instance end
		return nil
	end
	return nil, PlayerSubMap(mapID)
end

local function UpdateOverlay()
	local mapID = WorldMapFrame and WorldMapFrame.GetMapID and WorldMapFrame:GetMapID()
	local instance, subMap = OverlayTarget(mapID)
	if not (instance or subMap) then
		if overlay then
			overlay:Hide()
			overlay.instance, overlay.subMap = nil, nil
			if overlay.FloorDropdown then overlay.FloorDropdown:Hide() end
			StopPlayerArrow()
		end
		return
	end
	if not (overlay or CreateOverlay()) then return end
	if subMap then
		if DrawSubMap(subMap) then TuckAfterDraw() end
		return
	end
	StopPlayerArrow()
	overlay.subMap = nil
	for _, door in ipairs(overlay.Doors) do door:Hide() end

	local floors = Floors(instance)
	local index = chosenFloor[instance.key] or (forced and forced.floor) or 1
	if not floors[index] then index = 1 end
	local floor = floors[index]
	overlay.instance, overlay.floor = instance, index
	if not LayoutArt(floor) then return end
	DrawArt(floor)
	DrawPins(instance, index)
	DrawHere(instance, index)
	overlay:Show()
	TuckAfterDraw()

	local dropdown = overlay.FloorDropdown
	if dropdown then
		dropdown:SetShown(#floors > 1)
		if #floors > 1 and dropdown.GenerateMenu then dropdown:GenerateMenu() end
		if #floors > 1 and dropdown.SetText then dropdown:SetText(FloorName(instance, index)) end
	end
end

------------------------------------------------------------------------------------------
-- The data provider
------------------------------------------------------------------------------------------

local ProviderMethods = {}

-- The area the player stands in matters only while the map is open: listen only then.
local ZONE_EVENTS = { "ZONE_CHANGED", "ZONE_CHANGED_INDOORS", "ZONE_CHANGED_NEW_AREA" }
local zoneWatch = CreateFrame("Frame")
-- Walking down into an area below the zone, or back up, changes what the map shows.
zoneWatch:SetScript("OnEvent", function() UpdateOverlay() end)

function ProviderMethods:OnShow()
	dismissed, homeMapID = false, nil
	ns.RegisterEvents(zoneWatch, unpack(ZONE_EVENTS))
end

function ProviderMethods:OnHide()
	ns.UnregisterEvents(zoneWatch, unpack(ZONE_EVENTS))
	forced, homeMapID = nil, nil
	if overlay then overlay:Hide() end
	if overlay and overlay.FloorDropdown then overlay.FloorDropdown:Hide() end
	StopPlayerArrow()
end

function ProviderMethods:RemoveAllData()
	self:GetMap():RemoveAllPinsByTemplate(BOSS_PIN_TEMPLATE)
end

function ProviderMethods:RefreshAllData()
	self:RemoveAllData()
	local map = self:GetMap()
	local found = FloorByMapID(map:GetMapID())
	if found and DungeonMap:IsNative(Floors(found.instance)[found.index]) then
		for _, boss in ipairs(found.instance.bosses) do
			if not boss.trash then
				for _, point in ipairs(BossSpots(boss)) do
					if (point.floor or 1) == found.index then
						local pin = map:AcquirePin(BOSS_PIN_TEMPLATE, found.instance, boss)
						pin:SetPosition(point.x, point.y)
					end
				end
			end
		end
	end
	UpdateOverlay()
end

function ProviderMethods:OnCanvasScaleChanged()
	if overlay and overlay:IsShown() then UpdateOverlay() end
end

function ProviderMethods:OnCanvasSizeChanged()
	if overlay and overlay:IsShown() then UpdateOverlay() end
end

------------------------------------------------------------------------------------------
-- Dungeon and raid entrances on zone and continent maps, as retail draws them
------------------------------------------------------------------------------------------

--[[
	Retail's own entrance provider is on Forever's world map too, but the client has no
	entrances to give it. These pins are retail's: the "Dungeon" and "Raid" icons at their
	own size, the same highlight and area label, at the same frame level. A left click opens
	the instance in the journal, a right click sets a waypoint to the door.

	The entrance is the one the Record tab captured on the way in, if there is one, else the
	data's. It shows on its own zone's map and on the maps above it (the continent), placed
	there through the client's world coordinates. Blizzard's "Dungeon Entrances" map
	tracking option (the showDungeonEntrancesOnMap setting) turns them off and on.
]]
local ENTRANCE_PIN_TEMPLATE = "AegisJournalEntrancePinTemplate"
local ENTRANCE_CVAR = "showDungeonEntrancesOnMap"
local MAP_TYPE_CONTINENT, MAP_TYPE_ZONE = 2, 3
-- Retail's cave entrance (its map legend's "Cave"), for the way down to an area below a zone.
local CAVE_PIN_TEMPLATE = "AegisJournalCavePinTemplate"
local CAVE_ATLASES = { "CaveUnderground-Up", "CaveUnderground-Down" }
local LEGEND_GLOW_ATLAS = "UI-QuestPoi-OuterGlow"

--[[
	A door may be given by its place in the world (world = { continent, x, y }, as the game's
	own data gives it) instead of on its zone's map: the client puts it on the zone's map once.
	The axis order is the one that lands on that map; a door that lands on neither is not shown.
]]
local function OnZoneMap(entrance)
	if not entrance or entrance.x or not entrance.world then return entrance end
	if entrance.unplaced or not (C_Map and C_Map.GetMapPosFromWorldPos and CreateVector2D) then return nil end
	local continent, a, b = entrance.world[1], entrance.world[2], entrance.world[3]
	for _, order in ipairs({ { a, b }, { b, a } }) do
		local ok, _, position = pcall(C_Map.GetMapPosFromWorldPos, continent, CreateVector2D(order[1], order[2]), entrance.mapID)
		if ok and position then
			local x, y = position:GetXY()
			if x and x >= 0 and x <= 1 and y >= 0 and y <= 1 then
				entrance.x, entrance.y = x, y
				return entrance
			end
		end
	end
	entrance.unplaced = true
	return nil
end

-- Where the instance's door stands outside: { mapID, x, y }.
function DungeonMap:Entrance(instance)
	-- Wings that share one instance id share one recording too, which could be either's door.
	if instance.sharesInstanceID then return OnZoneMap(instance.zoneEntrance) end
	local recorded = ns.Recorder and ns.Recorder:GetState()
	recorded = recorded and recorded.entrances and instance.instanceID and recorded.entrances[instance.instanceID]
	if recorded and recorded.mapID and recorded.x then return recorded end
	return OnZoneMap(instance.zoneEntrance)
end

local mapInfoCache = {}
local function MapInfo(mapID)
	if mapInfoCache[mapID] == nil then
		local ok, info = pcall(C_Map.GetMapInfo, mapID)
		mapInfoCache[mapID] = ok and info or false
	end
	return mapInfoCache[mapID] or nil
end

-- Whether `ancestor` contains `mapID`, walking up the map tree.
local function IsAncestor(ancestor, mapID)
	local info = MapInfo(mapID)
	for _ = 1, 8 do
		if not info or not info.parentMapID or info.parentMapID == 0 then return false end
		if info.parentMapID == ancestor then return true end
		info = MapInfo(info.parentMapID)
	end
	return false
end

-- The entrance's place on another map, up the map tree (a zone's door on its continent) or
-- down it (a spot the client reports on the continent, as in Moonbrook's mine, on its zone):
-- through world coordinates, kept once worked out.
local positionCache = setmetatable({}, { __mode = "k" })
local function EntranceOn(entrance, mapID)
	if entrance.mapID == mapID then return entrance.x, entrance.y end
	local cache = positionCache[entrance]
	if not cache then
		cache = {}
		positionCache[entrance] = cache
	end
	local cached = cache[mapID]
	if cached == nil then
		cached = false
		if (IsAncestor(mapID, entrance.mapID) or IsAncestor(entrance.mapID, mapID)) and C_Map.GetWorldPosFromMapPos
			and C_Map.GetMapPosFromWorldPos and CreateVector2D then
			local ok, continentID, world = pcall(C_Map.GetWorldPosFromMapPos, entrance.mapID, CreateVector2D(entrance.x, entrance.y))
			if ok and continentID and world then
				local found, _, position = pcall(C_Map.GetMapPosFromWorldPos, continentID, world, mapID)
				if found and position then
					local x, y = position:GetXY()
					if x and x >= 0 and x <= 1 and y >= 0 and y <= 1 then cached = { x, y } end
				end
			end
		end
		cache[mapID] = cached
	end
	if cached then return cached[1], cached[2] end
	return nil
end

--[[
	Where an area below a zone's way down shows, and its place there: way = { x, y } on the
	map the client reports the area on (parentMapID), or on way.mapID; shown on way.showOn,
	else that same map. Moonbrook's mine is reported on the continent, but its way down shows
	on Westfall. A place entered some other way (the Deeprun Tram, by its tram icons) has none.
]]
local function WayPoint(subMap)
	local way = subMap.way
	if not way then return nil end
	if not way.point then way.point = { mapID = way.mapID or subMap.parentMapID, x = way.x, y = way.y } end
	local showOn = way.showOn or way.point.mapID
	local x, y = EntranceOn(way.point, showOn)
	return showOn, x, y
end

local function EntrancesShown()
	local value = GetCVar and GetCVar(ENTRANCE_CVAR)
	return value == nil or value == "1"
end

local function SetAreaLabel(pin, name, description)
	local map = pin:GetMap()
	if map and map.TriggerEvent and MAP_AREA_LABEL_TYPE then
		pcall(map.TriggerEvent, map, "SetAreaLabel", MAP_AREA_LABEL_TYPE.POI, name, description)
	end
end

local function ClearAreaLabel(pin)
	local map = pin:GetMap()
	if map and map.TriggerEvent and MAP_AREA_LABEL_TYPE then
		pcall(map.TriggerEvent, map, "ClearAreaLabel", MAP_AREA_LABEL_TYPE.POI)
	end
end

--[[
	Doors that close on the map shown are one icon: the Scarlet Monastery's four wings share one
	door, and the dungeons inside Blackrock Mountain another. Its tooltip lists them all, and a
	left click offers them to choose from.
]]
local SHARED_DOOR = 0.01

-- What a shared door is called: the building its wings are named after ("Scarlet Monastery:
-- Library"), else the place they all are (Blackrock Mountain).
local function Building(name)
	return name:match("^(.-)%s*\239\188\154") or name:match("^(.-)%s*:")
end

local function SharedDoorName(instances)
	local building, location = Building(instances[1].name), instances[1].location
	for _, instance in ipairs(instances) do
		if Building(instance.name) ~= building then building = nil end
		if instance.location ~= location then location = nil end
	end
	return building or location or instances[1].name
end
DungeonMap.SharedDoorName = SharedDoorName

-- "Dungeons  Level 30-45": the range they span together.
local function SharedDoorDescription(instances)
	local low, high
	for _, instance in ipairs(instances) do
		if instance.levelMin then
			low = math.min(low or instance.levelMin, instance.levelMin)
			high = math.max(high or 0, instance.levelMax or instance.levelMin)
		end
	end
	local kind = instances[1].kind == "raid" and L.ENTRANCE_RAIDS or L.ENTRANCE_DUNGEONS
	if not low then return kind end
	return kind .. "  " .. string.format(L.LEVEL_RANGE, low, high)
end

local function ShowSharedDoorTooltip(pin)
	local instances = pin.instances
	local name, description = SharedDoorName(instances), SharedDoorDescription(instances)
	SetAreaLabel(pin, name, description)
	GameTooltip:SetOwner(pin, "ANCHOR_RIGHT")
	GameTooltip:SetText(name, 1, 1, 1)
	GameTooltip:AddLine(description, 1, 0.82, 0)
	for _, instance in ipairs(instances) do
		local range = instance.levelMin and string.format(L.LEVEL_RANGE, instance.levelMin, instance.levelMax or instance.levelMin) or ""
		GameTooltip:AddDoubleLine(instance.name, range, 1, 1, 1, 1, 0.82, 0)
	end
	GameTooltip:AddLine(L.ENTRANCE_CHOOSE_LEFT_CLICK, 0.1, 1, 0.1)
	GameTooltip:AddLine(L.ENTRANCE_RIGHT_CLICK, 0.1, 1, 0.1)
	GameTooltip:Show()
end

local function ShowEntranceTooltip(pin)
	if #pin.instances > 1 then return ShowSharedDoorTooltip(pin) end
	local instance = pin.instance
	local description = EntranceDescription(instance)
	SetAreaLabel(pin, instance.name, description)
	GameTooltip:SetOwner(pin, "ANCHOR_RIGHT")
	GameTooltip:SetText(instance.name, 1, 1, 1)
	GameTooltip:AddLine(description, 1, 0.82, 0)
	-- A dungeon reached through an area below the zone says where the way down is.
	local via = instance.via and ns.GetSubMap(instance.via)
	if via then GameTooltip:AddLine(string.format(L.ENTRANCE_VIA, via.name), 1, 1, 1, true) end
	GameTooltip:AddLine(L.ENTRANCE_LEFT_CLICK, 0.1, 1, 0.1)
	GameTooltip:AddLine(L.ENTRANCE_RIGHT_CLICK, 0.1, 1, 0.1)
	GameTooltip:Show()
end

-- Opens the instance in the journal, putting the world map away first (out of combat only).
function DungeonMap:OpenInstance(instance)
	ns.PlaySoundKit("IG_SPELLBOOK_OPEN")
	if WorldMapFrame and WorldMapFrame:IsShown() and not InCombatLockdown() and type(HideUIPanel) == "function" then
		pcall(HideUIPanel, WorldMapFrame)
	end
	ns.Journal:Show()
	ns.Journal:OpenInstance(instance)
end

-- A waypoint: the client's own, where its waypoints work, else ours.
local function SetWaypointAt(mapID, x, y, title)
	local canSet = C_Map and C_Map.CanSetUserWaypointOnMap and C_Map.SetUserWaypoint and UiMapPoint
	if canSet then
		local ok, allowed = pcall(C_Map.CanSetUserWaypointOnMap, mapID)
		canSet = ok and allowed
	end
	if canSet then
		C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(mapID, x, y))
		if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then pcall(C_SuperTrack.SetSuperTrackedUserWaypoint, true) end
		ns.PlaySoundKit("UI_MAP_WAYPOINT_CONTROL_CLICK")
	else
		ns.MapPin:Show({ mapID = mapID, x = x, y = y }, title)
	end
end

-- For the journal's other map pins (UI/TravelMap.lua).
function DungeonMap:MapInfo(mapID) return MapInfo(mapID) end
-- A point { mapID, x, y } on another map, or nil when it is not on it.
function DungeonMap:PositionOn(point, mapID) return EntranceOn(point, mapID) end
function DungeonMap:SetWaypointAt(mapID, x, y, title) SetWaypointAt(mapID, x, y, title) end
function DungeonMap:SetAreaLabel(pin, name, description) SetAreaLabel(pin, name, description) end
function DungeonMap:ClearAreaLabel(pin) ClearAreaLabel(pin) end

-- A waypoint to the instance's door; for one reached through an area below the zone, to the
-- way down, since the door itself cannot be walked to from the streets. `title` names a door
-- several share (the Scarlet Monastery's).
function DungeonMap:SetWaypoint(instance, title)
	local via = instance.via and ns.GetSubMap(instance.via)
	if via then
		local wayMapID, x, y = WayPoint(via)
		if not x then return false end
		SetWaypointAt(wayMapID, x, y, via.name)
		ns.Print(string.format(L.ENTRANCE_WAYPOINT_VIA, via.name, instance.name))
		return true
	end
	local entrance = self:Entrance(instance)
	if not entrance then return false end
	SetWaypointAt(entrance.mapID, entrance.x, entrance.y, title or instance.name)
	ns.Print(string.format(L.ENTRANCE_WAYPOINT_SET, title or instance.name))
	return true
end

-- Shows an area below a zone over the world map, as retail's cave links do.
function DungeonMap:ShowSubMap(subMap)
	if not (provider and WorldMapFrame:IsShown()) then return false end
	forced = { subMap = subMap, mapID = WorldMapFrame:GetMapID() }
	dismissed = false
	ns.PlaySoundKit("IG_QUEST_LOG_OPEN")
	provider:RefreshAllData()
	return true
end

-- The art at the atlas's size (32 when the client gives none), the pin no bigger than the icon in it.
local function SizeToIcon(pin)
	local width, height = pin.Texture:GetSize()
	if not width or width <= 0 then width, height = 32, 32 end
	pin.Texture:SetSize(width, height)
	pin:SetSize(math.min(width, PIN_HIT_SIZE), math.min(height, PIN_HIT_SIZE))
end

AegisJournalEntrancePinMixin = {}
local EntrancePinMethods = { CheckMouseButtonPassthrough = DungeonMap.CheckMouseButtonPassthrough }

function EntrancePinMethods:OnLoad()
	self.Texture = self:CreateTexture(nil, "ARTWORK")
	self.Texture:SetPoint("CENTER")
	self.HighlightTexture = self:CreateTexture(nil, "HIGHLIGHT")
	self.HighlightTexture:SetBlendMode("ADD")
	self.HighlightTexture:SetAlpha(0.4)
	self.HighlightTexture:SetAllPoints(self.Texture)
	self:SetScalingLimits(1, 1.0, 1.2)
	self:UseFrameLevelType("PIN_FRAME_LEVEL_DUNGEON_ENTRANCE")
end

-- Retail's glow for a pin its map legend points at (shared with the journal's other pins).
function EntrancePinMethods:ShowMapLegendGlow()
	if not self.legendGlow then
		self.legendGlow = self:CreateTexture(nil, "BACKGROUND")
		self.legendGlow:SetPoint("TOPLEFT", self, "TOPLEFT", -18, 18)
		self.legendGlow:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 18, -18)
		self.legendGlow:SetAtlas(LEGEND_GLOW_ATLAS)
	end
	self.legendGlow:Show()
end

function EntrancePinMethods:HideMapLegendGlow()
	if self.legendGlow then self.legendGlow:Hide() end
end

DungeonMap.ShowMapLegendGlow = EntrancePinMethods.ShowMapLegendGlow
DungeonMap.HideMapLegendGlow = EntrancePinMethods.HideMapLegendGlow

function EntrancePinMethods:LegendKind()
	return self.isRaid and "raid" or "dungeon"
end

-- `together`: every instance behind this door, when several share it (in the journal's order).
function EntrancePinMethods:OnAcquired(instance, x, y, together)
	self.instance, self.instances = instance, together or { instance }
	self.isRaid = instance.kind == "raid"
	self:HideMapLegendGlow()
	local atlas = self.isRaid and RAID_ATLAS or DUNGEON_ATLAS
	self.Texture:SetAtlas(atlas, true)
	self.HighlightTexture:SetAtlas(atlas, true)
	SizeToIcon(self)
	self:SetPosition(x, y)
end

-- Both buttons belong to the pin: right-click sets the waypoint instead of zooming out.
function EntrancePinMethods:ShouldMouseButtonBePassthrough() return false end

function EntrancePinMethods:OnMouseEnter()
	ShowEntranceTooltip(self)
	ns.MapLegend:PinEnter(self:LegendKind())
end

function EntrancePinMethods:OnMouseLeave()
	ClearAreaLabel(self)
	GameTooltip:Hide()
	ns.MapLegend:PinLeave(self:LegendKind())
end

function EntrancePinMethods:OnMouseClickAction(button)
	local instances = self.instances
	if button == "RightButton" then
		DungeonMap:SetWaypoint(self.instance, #instances > 1 and SharedDoorName(instances) or nil)
	elseif #instances > 1 and MenuUtil and MenuUtil.CreateContextMenu then
		GameTooltip:Hide()
		MenuUtil.CreateContextMenu(self, function(_, root)
			root:CreateTitle(SharedDoorName(instances))
			for _, instance in ipairs(instances) do
				root:CreateButton(instance.name, function() DungeonMap:OpenInstance(instance) end)
			end
		end)
	else
		DungeonMap:OpenInstance(self.instance)
	end
end

-- The way down to an area below a zone: retail's cave entrance. A left click shows the area's
-- map, a right click sets a waypoint to the way down.
AegisJournalCavePinMixin = {}
local CavePinMethods = {}

CavePinMethods.OnLoad = EntrancePinMethods.OnLoad
CavePinMethods.ShowMapLegendGlow = EntrancePinMethods.ShowMapLegendGlow
CavePinMethods.HideMapLegendGlow = EntrancePinMethods.HideMapLegendGlow
function CavePinMethods:LegendKind() return "cave" end

function CavePinMethods:OnAcquired(subMap, x, y)
	self.subMap, self.wayX, self.wayY = subMap, x, y
	self:HideMapLegendGlow()
	for _, atlas in ipairs(CAVE_ATLASES) do
		if ns.AtlasExists(atlas) then
			self.Texture:SetAtlas(atlas, true)
			self.HighlightTexture:SetAtlas(atlas, true)
			break
		end
	end
	SizeToIcon(self)
	self:SetPosition(x, y)
end

CavePinMethods.ShouldMouseButtonBePassthrough = EntrancePinMethods.ShouldMouseButtonBePassthrough
CavePinMethods.CheckMouseButtonPassthrough = DungeonMap.CheckMouseButtonPassthrough

function CavePinMethods:OnMouseEnter()
	local subMap = self.subMap
	SetAreaLabel(self, subMap.name, L.CAVE_LABEL)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(subMap.name, 1, 1, 1)
	for key in pairs(subMap.instances) do
		local instance = ns.GetInstance(key)
		if instance then GameTooltip:AddLine(string.format(L.CAVE_LEADS_TO, instance.name), 1, 0.82, 0) end
	end
	GameTooltip:AddLine(string.format(L.CAVE_LEFT_CLICK, subMap.name), 0.1, 1, 0.1)
	GameTooltip:AddLine(L.ENTRANCE_RIGHT_CLICK, 0.1, 1, 0.1)
	GameTooltip:Show()
	ns.MapLegend:PinEnter("cave")
end

CavePinMethods.OnMouseLeave = EntrancePinMethods.OnMouseLeave

function CavePinMethods:OnMouseClickAction(button)
	local subMap = self.subMap
	if button == "RightButton" then
		SetWaypointAt(self:GetMap():GetMapID(), self.wayX, self.wayY, subMap.name)
		ns.Print(string.format(L.CAVE_WAYPOINT_SET, subMap.name))
	else
		DungeonMap:ShowSubMap(subMap)
	end
end

local EntranceProviderMethods = {}

function EntranceProviderMethods:OnShow() self:RegisterEvent("CVAR_UPDATE") end
function EntranceProviderMethods:OnHide() self:UnregisterEvent("CVAR_UPDATE") end

function EntranceProviderMethods:OnEvent(event, name)
	if event == "CVAR_UPDATE" and name == ENTRANCE_CVAR then self:RefreshAllData() end
end

function EntranceProviderMethods:RemoveAllData()
	self:GetMap():RemoveAllPinsByTemplate(ENTRANCE_PIN_TEMPLATE)
	self:GetMap():RemoveAllPinsByTemplate(CAVE_PIN_TEMPLATE)
end

function EntranceProviderMethods:RefreshAllData()
	self:RemoveAllData()
	if not EntrancesShown() then return end
	local map = self:GetMap()
	local mapID = map:GetMapID()
	local info = mapID and MapInfo(mapID)
	if not info or (info.mapType ~= MAP_TYPE_CONTINENT and info.mapType ~= MAP_TYPE_ZONE) then return end
	for _, kind in ipairs({ "dungeon", "raid" }) do
		local doors = {}
		-- Hidden from the map legend: none of this kind.
		for _, instance in ipairs(ns.MapLegend.Shows(kind) and ns.GetInstances(kind) or {}) do
			local entrance = DungeonMap:Entrance(instance)
			local x, y
			if entrance then x, y = EntranceOn(entrance, mapID) end
			if x then
				local shared
				for _, door in ipairs(doors) do
					if math.abs(door.x - x) < SHARED_DOOR and math.abs(door.y - y) < SHARED_DOOR then
						shared = door
						break
					end
				end
				if shared then
					shared.instances[#shared.instances + 1] = instance
				else
					doors[#doors + 1] = { x = x, y = y, instances = { instance } }
				end
			end
		end
		for _, door in ipairs(doors) do
			map:AcquirePin(ENTRANCE_PIN_TEMPLATE, door.instances[1], door.x, door.y, door.instances)
		end
	end
	-- Caves show on their own zone's map only, as on retail.
	for _, subMap in ipairs(ns.MapLegend.Shows("cave") and ns.GetSubMaps() or {}) do
		local wayMapID, x, y = WayPoint(subMap)
		if wayMapID == mapID and x then map:AcquirePin(CAVE_PIN_TEMPLATE, subMap, x, y) end
	end
end

local entranceProvider

-- Joins the world map once it exists.
local function SetUp()
	if provider then return true end
	if not (WorldMapFrame and WorldMapFrame.AddDataProvider and MapCanvasDataProviderMixin and MapCanvasPinMixin) then
		return false
	end
	Mixin(AegisJournalBossPinMixin, MapCanvasPinMixin, BossPinMethods)
	Mixin(AegisJournalEntrancePinMixin, MapCanvasPinMixin, EntrancePinMethods)
	Mixin(AegisJournalCavePinMixin, MapCanvasPinMixin, CavePinMethods)
	provider = CreateFromMixins(MapCanvasDataProviderMixin, ProviderMethods)
	entranceProvider = CreateFromMixins(MapCanvasDataProviderMixin, EntranceProviderMethods)
	WorldMapFrame:AddDataProvider(provider)
	WorldMapFrame:AddDataProvider(entranceProvider)
	return true
end

function DungeonMap:Refresh()
	if provider and WorldMapFrame:IsShown() then provider:RefreshAllData() end
end

-- The dungeon and raid doors and the caves drawn again (a legend switch).
function DungeonMap:RefreshEntrances()
	if entranceProvider and WorldMapFrame:IsShown() then entranceProvider:RefreshAllData() end
end

------------------------------------------------------------------------------------------
-- From the journal
------------------------------------------------------------------------------------------

local function OpenWorld(mapID)
	if mapID and C_Map and C_Map.OpenWorldMap and pcall(C_Map.OpenWorldMap, mapID) then return true end
	if type(OpenWorldMap) == "function" then return pcall(OpenWorldMap, mapID) end
	return false
end

-- Opens the world map on the dungeon: its own map where the client has one, else ours.
function DungeonMap:Show(instance, floorIndex)
	local floors = Floors(instance)
	if not floors or #floors == 0 then return false end
	if InCombatLockdown() then
		ns.Print(L.MAP_PIN_COMBAT)
		return false
	end
	if not SetUp() then return false end
	local floor = floors[floorIndex or 1] or floors[1]
	if self:IsNative(floor) then return OpenWorld(floor.uiMapID) end

	if not WorldMapFrame:IsShown() and not OpenWorld(nil) then return false end
	chosenFloor[instance.key] = floorIndex or chosenFloor[instance.key]
	forced = { instance = instance, mapID = WorldMapFrame:GetMapID(), floor = floorIndex or 1 }
	dismissed = false
	provider:RefreshAllData()
	return true
end

-- The overlay's state, for the smoke test.
function DungeonMap:Overlay()
	return overlay
end

------------------------------------------------------------------------------------------
-- Events
------------------------------------------------------------------------------------------

-- Being below a zone depends on the streets the player walked through, so inside a zone with
-- an area below, its streets are followed even while the map is closed.
local BELOW_EVENTS = { "ZONE_CHANGED", "ZONE_CHANGED_INDOORS" }
local belowWatch = CreateFrame("Frame")
belowWatch:SetScript("OnEvent", function() PlayerSubMap() end)

local function WatchBelow()
	local mapID = ns.PlayerMapPosition()
	for _, subMap in ipairs(ns.GetSubMaps()) do
		if mapID and subMap.parentMapID == mapID then
			ns.RegisterEvents(belowWatch, unpack(BELOW_EVENTS))
			PlayerSubMap()
			return
		end
	end
	ns.UnregisterEvents(belowWatch, unpack(BELOW_EVENTS))
	playerBelow = nil
end

local events = CreateFrame("Frame")
local wasInside = false
ns.RegisterEvents(events, "PLAYER_LOGIN", "PLAYER_ENTERING_WORLD", "ZONE_CHANGED_NEW_AREA", "ENCOUNTER_END")
events:SetScript("OnEvent", function(_, event, ...)
	if event == "PLAYER_LOGIN" then
		SetUp()
	elseif event == "ZONE_CHANGED_NEW_AREA" then
		WatchBelow()
	elseif event == "PLAYER_ENTERING_WORLD" then
		SetUp()
		WatchBelow()
		-- A new run starts on coming in from outside; a corpse run back in keeps its kills.
		local instance = CurrentInstance()
		local ghost = UnitIsDeadOrGhost and UnitIsDeadOrGhost("player")
		if instance and not wasInside and not ghost then defeated[instance.key] = nil end
		wasInside = instance ~= nil
		WatchDeaths(instance)
		DungeonMap:Refresh()
	elseif event == "ENCOUNTER_END" then
		local encounterID, name, _, _, success = ...
		if ns.Readable(success) == 1 then
			local instance = CurrentInstance()
			local boss = BossForEncounter(instance, ns.Readable(encounterID), ns.Readable(name))
			if boss then DungeonMap:MarkDefeated(instance, boss) end
		end
	end
end)
