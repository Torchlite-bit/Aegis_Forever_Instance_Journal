local addonName, ns = ...
local L = ns.L

--[[
	The journal's Gear tab: the Gear Finder (Core/GearFinder.lua), laid out as Aegis: Pathfinder
	lays out its own. Two columns of slots, like the character sheet, each with the best upgrade
	waiting for it, how much better it is and where it drops; beside them the dungeon holding the
	most of them, the ‹ › arrows going through the others; the ranged slot under that.

	A button beside the character sheet's weapons opens this tab.
]]

local GearPanel = {}
ns.GearPanel = GearPanel

local CELL_WIDTH, CELL_HEIGHT, CELL_GAP = 238, 42, 4
local LEFT, TOP = 17, 64
local COLUMN_X = { LEFT, LEFT + CELL_WIDTH + 8, LEFT + 2 * (CELL_WIDTH + 8) + 4 }
local CARD_WIDTH = 255
local ICON_SIZE = 34
local LOGO = "Interface\\AddOns\\" .. addonName .. "\\Media\\Logo"

local GAIN_COLOR = { 0.25, 1, 0.25 }
local LATER_COLOR = "|cffffd100"
local DIM_COLOR = { 0.5, 0.5, 0.5 }

local SLOT_LABELS = {
	head = INVTYPE_HEAD or "Head", neck = INVTYPE_NECK or "Neck", shoulder = INVTYPE_SHOULDER or "Shoulder",
	back = INVTYPE_CLOAK or "Back", chest = INVTYPE_CHEST or "Chest", wrist = INVTYPE_WRIST or "Wrist",
	hands = INVTYPE_HAND or "Hands", waist = INVTYPE_WAIST or "Waist", legs = INVTYPE_LEGS or "Legs",
	feet = INVTYPE_FEET or "Feet", mainhand = INVTYPE_WEAPONMAINHAND or "Main Hand",
	offhand = INVTYPE_WEAPONOFFHAND or "Off Hand", ranged = INVTYPE_RANGED or "Ranged",
	finger1 = L.GEAR_SLOT_FINGER1, finger2 = L.GEAR_SLOT_FINGER2,
	trinket1 = L.GEAR_SLOT_TRINKET1, trinket2 = L.GEAR_SLOT_TRINKET2,
}
GearPanel.SLOT_LABELS = SLOT_LABELS

-- The empty picture of an inventory slot, as the character sheet shows it.
local function EmptySlotTexture(inv)
	local getInfo = (C_PaperDollInfo and C_PaperDollInfo.GetInventorySlotInfo) or GetInventorySlotInfo
	if getInfo then
		local ok, _, texture = pcall(getInfo, inv)
		if ok and texture then return texture end
	end
	return "Interface\\PaperDoll\\UI-Backpack-EmptySlot"
end

-- "+54%"; for a slot with nothing worn, that; against an item worth nothing, the score it adds.
local function GainText(compare)
	if compare.emptySlot then return L.GEAR_EMPTY_SLOT end
	if compare.pct then return string.format("+%d%%", math.floor(compare.pct + 0.5)) end
	return string.format("+%.1f", compare.delta or 0)
end

-- Who drops it: the boss, or the dungeon's trash.
local function SourceName(entry)
	return entry.boss.trash and L.LOOT_TRASH or entry.boss.name
end

-- "The Deadmines · Captain Greenskin", and when the item waits for a level, that too.
local function WhereText(entry)
	local text = entry.instance.name .. " \194\183 " .. SourceName(entry)
	if entry.compare.later then text = text .. " " .. LATER_COLOR .. string.format(L.GEAR_AT_LEVEL, entry.compare.minLevel) .. "|r" end
	return text
end

------------------------------------------------------------------------------------------
-- Cells
------------------------------------------------------------------------------------------

local function ShowCellTooltip(cell)
	local entry = cell.entry
	if not entry then return end
	GameTooltip:SetOwner(cell, "ANCHOR_RIGHT")
	GameTooltip:SetHyperlink(entry.link)
	local spec = ns.ItemScore:SpecLabel((ns.ItemScore:Spec()))
	GameTooltip:AddLine(" ")
	if entry.compare.emptySlot then
		GameTooltip:AddLine(string.format(L.GEAR_TIP_EMPTY, spec), GAIN_COLOR[1], GAIN_COLOR[2], GAIN_COLOR[3])
	else
		GameTooltip:AddLine(string.format(L.GEAR_TIP_GAIN, spec, GainText(entry.compare)), GAIN_COLOR[1], GAIN_COLOR[2], GAIN_COLOR[3])
	end
	GameTooltip:AddLine(entry.instance.name .. " \194\183 " .. SourceName(entry), 1, 1, 1)
	if entry.compare.later then GameTooltip:AddLine(string.format(L.GEAR_TIP_LATER, entry.compare.minLevel), 1, 0.82, 0) end
	-- The next best for the slot, so a pick isn't the only thing it says.
	local others = 0
	for _, other in ipairs(cell.others or {}) do
		if other.itemID ~= entry.itemID and others < 3 then
			if others == 0 then GameTooltip:AddLine(L.GEAR_TIP_MORE, 0.75, 0.75, 0.75) end
			GameTooltip:AddDoubleLine(other.info.name or other.link, GainText(other.compare), 1, 1, 1,
				GAIN_COLOR[1], GAIN_COLOR[2], GAIN_COLOR[3])
			others = others + 1
		end
	end
	GameTooltip:AddLine(L.GEAR_TIP_CLICK, 0.5, 0.8, 1)
	GameTooltip:Show()
end

-- Opens the item where the journal lists it, as a search result opens: trash drops on the
-- dungeon's own loot page, past any loot filter that would hide it.
local function OpenEntry(entry)
	ns.PlaySoundKit("IG_ABILITY_PAGE_TURN")
	if entry.boss.trash then
		ns.Journal:OpenInstance(entry.instance)
	else
		ns.Journal:OpenBoss(entry.instance, entry.boss)
	end
	ns.EncounterPage:SetTab(ns.Journal:Page(), ns.EncounterPage.TAB_LOOT)
	ns.LootPanel:Reveal(entry.itemID)
end

local function CreateCell(panel, def, width)
	local cell = CreateFrame("Button", nil, panel)
	cell:SetSize(width or CELL_WIDTH, CELL_HEIGHT)
	cell:SetPoint("TOPLEFT", COLUMN_X[def.col], -(TOP + (def.row - 1) * (CELL_HEIGHT + CELL_GAP)))
	cell.def = def

	cell.Background = cell:CreateTexture(nil, "BACKGROUND")
	cell.Background:SetAllPoints()
	cell.Background:SetColorTexture(0, 0, 0, 0.35)
	cell.Highlight = cell:CreateTexture(nil, "HIGHLIGHT")
	cell.Highlight:SetAllPoints()
	cell.Highlight:SetColorTexture(1, 1, 1, 0.06)

	cell.Icon = cell:CreateTexture(nil, "ARTWORK")
	cell.Icon:SetSize(ICON_SIZE, ICON_SIZE)
	cell.Icon:SetPoint("LEFT", 4, 0)

	cell.Gain = cell:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	cell.Gain:SetPoint("TOPRIGHT", -6, -5)
	cell.Gain:SetJustifyH("RIGHT")
	cell.Gain:SetTextColor(GAIN_COLOR[1], GAIN_COLOR[2], GAIN_COLOR[3])

	cell.Name = cell:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	cell.Name:SetPoint("TOPLEFT", cell.Icon, "TOPRIGHT", 6, -1)
	cell.Name:SetPoint("RIGHT", cell.Gain, "LEFT", -4, 0)
	cell.Name:SetJustifyH("LEFT")
	cell.Name:SetWordWrap(false)

	cell.Where = cell:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	cell.Where:SetPoint("BOTTOMLEFT", cell.Icon, "BOTTOMRIGHT", 6, 1)
	cell.Where:SetPoint("RIGHT", -6, 0)
	cell.Where:SetJustifyH("LEFT")
	cell.Where:SetWordWrap(false)

	cell:SetScript("OnEnter", ShowCellTooltip)
	cell:SetScript("OnLeave", function() GameTooltip:Hide() end)
	cell:SetScript("OnClick", function(self)
		if self.entry then OpenEntry(self.entry) end
	end)
	return cell
end

local function SetCell(cell, shown, entries)
	cell.entry, cell.others = shown, entries
	if shown then
		cell.Icon:SetTexture(ns.Items:Icon(shown.itemID) or EmptySlotTexture(cell.def.inv))
		cell.Icon:SetDesaturated(false)
		cell.Icon:SetAlpha(1)
		cell.Name:SetText(shown.info.name or "")
		local r, g, b = ns.Items:QualityColor(shown.info.quality)
		cell.Name:SetTextColor(r, g, b)
		cell.Gain:SetText(GainText(shown.compare))
		cell.Where:SetText(WhereText(shown))
		cell.Where:SetTextColor(1, 1, 1)
	else
		cell.Icon:SetTexture(EmptySlotTexture(cell.def.inv))
		cell.Icon:SetDesaturated(true)
		cell.Icon:SetAlpha(0.5)
		cell.Name:SetText(L.GEAR_NO_UPGRADE)
		cell.Name:SetTextColor(DIM_COLOR[1], DIM_COLOR[2], DIM_COLOR[3])
		cell.Gain:SetText("")
		cell.Where:SetText(SLOT_LABELS[cell.def.key] or cell.def.key)
		cell.Where:SetTextColor(DIM_COLOR[1], DIM_COLOR[2], DIM_COLOR[3])
	end
end

------------------------------------------------------------------------------------------
-- The suggested dungeon
------------------------------------------------------------------------------------------

local function CreateCard(panel)
	local card = CreateFrame("Frame", nil, panel)
	card:SetSize(CARD_WIDTH, 7 * (CELL_HEIGHT + CELL_GAP) - CELL_GAP)
	card:SetPoint("TOPLEFT", COLUMN_X[3], -TOP)
	card.Background = card:CreateTexture(nil, "BACKGROUND")
	card.Background:SetAllPoints()
	card.Background:SetColorTexture(0, 0, 0, 0.35)

	card.Art = card:CreateTexture(nil, "ARTWORK")
	card.Art:SetPoint("TOPLEFT", 6, -6)
	card.Art:SetPoint("TOPRIGHT", -6, -6)
	card.Art:SetHeight(120)

	card.Heading = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	card.Heading:SetPoint("TOP", card.Art, "BOTTOM", 0, -8)
	card.Heading:SetText(L.GEAR_SUGGESTED)

	card.Name = card:CreateFontString(nil, "OVERLAY", ns.Font("GameFontNormalLarge", "GameFontNormal"))
	card.Name:SetPoint("TOP", card.Heading, "BOTTOM", 0, -6)
	card.Name:SetWidth(CARD_WIDTH - 50)
	card.Name:SetWordWrap(false)

	card.Range = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	card.Range:SetPoint("TOP", card.Name, "BOTTOM", 0, -3)

	card.Count = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	card.Count:SetPoint("TOP", card.Range, "BOTTOM", 0, -10)
	card.Count:SetTextColor(GAIN_COLOR[1], GAIN_COLOR[2], GAIN_COLOR[3])

	card.Slots = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	card.Slots:SetPoint("TOP", card.Count, "BOTTOM", 0, -4)
	card.Slots:SetWidth(CARD_WIDTH - 20)

	card.Of = card:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	card.Of:SetPoint("BOTTOM", 0, 36)

	card.Open = ns.CreateFrameWithTemplate("Button", nil, card, "UIPanelButtonTemplate")
	card.Open:SetSize(170, 22)
	card.Open:SetPoint("BOTTOM", 0, 8)
	card.Open:SetText(L.GEAR_OPEN)
	card.Open:SetScript("OnClick", function()
		if card.instance then
			ns.PlaySoundKit("IG_SPELLBOOK_OPEN")
			ns.Journal:OpenInstance(card.instance)
		end
	end)

	local function Arrow(direction, point, x)
		local button = CreateFrame("Button", nil, card)
		button:SetSize(24, 24)
		button:SetPoint(point, card.Name, direction < 0 and "LEFT" or "RIGHT", x, 0)
		button.Text = button:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		button.Text:SetPoint("CENTER")
		button.Text:SetText(direction < 0 and "\226\128\185" or "\226\128\186")
		button:SetScript("OnClick", function()
			ns.PlaySoundKit("IG_ABILITY_PAGE_TURN")
			panel.suggestIndex = (panel.suggestIndex or 1) + direction
			GearPanel:Redraw(panel)
		end)
		return button
	end
	card.Previous = Arrow(-1, "RIGHT", -4)
	card.Next = Arrow(1, "LEFT", 4)

	card.None = card:CreateFontString(nil, "OVERLAY", "GameFontDisable")
	card.None:SetPoint("CENTER", 0, -30)
	card.None:SetWidth(CARD_WIDTH - 30)
	card.None:SetText(L.GEAR_NONE)
	return card
end

local function SetCard(card, suggestions, index)
	local item = suggestions[index]
	card.instance = item and item.instance
	for _, region in ipairs({ card.Art, card.Heading, card.Name, card.Range, card.Count, card.Slots, card.Of, card.Open }) do
		region:SetShown(item ~= nil)
	end
	card.Previous:SetShown(item ~= nil and #suggestions > 1)
	card.Next:SetShown(item ~= nil and #suggestions > 1)
	card.None:SetShown(item == nil)
	if not item then return end
	local instance = item.instance
	ns.SetInstanceArt(card.Art, instance)
	card.Name:SetText(instance.name)
	-- The level range as the dungeon buttons show it.
	local low, high = instance.levelMin, instance.levelMax
	card.Range:SetText((low and high and low ~= high and (low .. "-" .. high)) or (low and string.format(L.MAP_LEVEL, low)) or "")
	card.Count:SetText(item.count == 1 and L.GEAR_UPGRADE_HERE or string.format(L.GEAR_UPGRADES_HERE, item.count))
	local names = {}
	for index2, key in ipairs(item.slots) do names[index2] = SLOT_LABELS[key] or key end
	card.Slots:SetText(table.concat(names, ", "))
	card.Of:SetText(string.format(L.GEAR_DUNGEON_OF, index, #suggestions))
end

------------------------------------------------------------------------------------------
-- The spec menu
------------------------------------------------------------------------------------------

local function SpecText()
	local IS = ns.ItemScore
	local spec, why = IS:Spec()
	if not spec then return "" end
	local label = IS:SpecLabel(spec)
	if why == "talents" then return string.format(L.GEAR_WHY_TALENTS, label) end
	if why == "levelling" then return string.format(L.GEAR_WHY_LEVELLING, label) end
	return label
end

local function PickSpec(spec)
	ns.ItemScore:SetSpec(spec)
end

-- The spec picked from the menu, nil for automatic; read each time, never kept.
local function PickedSpec()
	return (ns.charDB.gearFinder or {}).spec
end

-- What automatic would score: the talents' spec, else the levelling one.
local function AutomaticLabel()
	local IS = ns.ItemScore
	return IS:SpecLabel(IS:TalentSpec(IS:Class()) or (ns.GEAR_WEIGHTS[IS:Class()] or {}).levelling or "")
end

local function CreateSpecMenu(panel)
	panel.ScoringLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	if ns.HasTemplate("WowStyle1DropdownTemplate") then
		local ok, dropdown = pcall(CreateFrame, "DropdownButton", nil, panel, "WowStyle1DropdownTemplate")
		if ok and dropdown and dropdown.SetupMenu then
			dropdown:SetWidth(190)
			dropdown:SetPoint("TOPRIGHT", -25, -16)
			dropdown:SetupMenu(function(_, rootDescription)
				local IS = ns.ItemScore
				rootDescription:CreateRadio(string.format(L.GEAR_AUTO, AutomaticLabel()),
					function() return PickedSpec() == nil end, function() PickSpec(nil) end)
				for _, spec in ipairs(IS:Specs()) do
					rootDescription:CreateRadio(spec.label,
						function() return PickedSpec() == spec.key end, function() PickSpec(spec.key) end)
				end
			end)
			if dropdown.SetDefaultText then dropdown:SetDefaultText(SpecText()) end
			panel.ScoringLabel:SetPoint("RIGHT", dropdown, "LEFT", -8, 0)
			panel.ScoringLabel:SetText(L.GEAR_SCORING)
			return dropdown
		end
	end
	-- Older menu system, for a client without the modern dropdown.
	local dropdown = CreateFrame("Frame", nil, panel, "UIDropDownMenuTemplate")
	dropdown:SetPoint("TOPRIGHT", -10, -12)
	UIDropDownMenu_SetWidth(dropdown, 170)
	UIDropDownMenu_Initialize(dropdown, function()
		local IS = ns.ItemScore
		local info = UIDropDownMenu_CreateInfo()
		info.text = string.format(L.GEAR_AUTO, AutomaticLabel())
		info.checked = PickedSpec() == nil
		info.func = function() PickSpec(nil) end
		UIDropDownMenu_AddButton(info)
		for _, spec in ipairs(IS:Specs()) do
			info = UIDropDownMenu_CreateInfo()
			info.text = spec.label
			info.checked = PickedSpec() == spec.key
			info.func = function() PickSpec(spec.key) end
			UIDropDownMenu_AddButton(info)
		end
	end)
	dropdown.legacy = true
	panel.ScoringLabel:SetPoint("RIGHT", dropdown, "LEFT", 8, 2)
	panel.ScoringLabel:SetText(L.GEAR_SCORING)
	return dropdown
end

------------------------------------------------------------------------------------------
-- The panel
------------------------------------------------------------------------------------------

function GearPanel:Build(panel)
	panel.Title:SetText(L.GEAR_TITLE)
	panel.Preview = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	panel.Preview:SetPoint("LEFT", panel.Title, "RIGHT", 8, -1)
	panel.Preview:SetText(L.GEAR_PREVIEW)
	panel.Empty:SetText("")

	panel.Status = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	panel.Status:SetPoint("TOPLEFT", 22, -44)
	panel.Status:SetJustifyH("LEFT")

	panel.Spec = CreateSpecMenu(panel)
	panel.Cells = {}
	for _, def in ipairs(ns.GearFinder.CELLS) do
		panel.Cells[#panel.Cells + 1] = CreateCell(panel, def, def.col == 3 and CARD_WIDTH or nil)
	end
	panel.Card = CreateCard(panel)
	panel.suggestIndex = 1

	ns.GearFinder.IsShowing = function() return panel:IsVisible() end
	ns.GearFinder:OnUpdate(function()
		if panel:IsVisible() then GearPanel:Redraw(panel) end
	end)
	-- Searched on the next frame: a journal opened straight onto another page hides this at once.
	panel:HookScript("OnShow", function()
		panel.suggestIndex = 1
		C_Timer.After(0, function()
			if panel:IsVisible() then ns.GearFinder:Refresh() end
		end)
	end)
	self.panel = panel
end

function GearPanel:Redraw(panel)
	local finder = ns.GearFinder
	local cells = finder:Cells()
	for index, cell in ipairs(cells) do SetCell(panel.Cells[index], cell.shown, cell.entries) end
	local suggestions = finder:Suggest(cells)
	local count = #suggestions
	if count > 0 then
		panel.suggestIndex = ((panel.suggestIndex or 1) - 1) % count + 1
	else
		panel.suggestIndex = 1
	end
	SetCard(panel.Card, suggestions, panel.suggestIndex)

	local _, missing, looked = finder:Results()
	local status = looked == 1 and L.GEAR_LOOKING_ONE or string.format(L.GEAR_LOOKING, looked)
	if missing > 0 then
		status = status .. " " .. (missing == 1 and L.GEAR_LOADING_ONE or string.format(L.GEAR_LOADING, missing))
	end
	panel.Status:SetText(status)
	if panel.Spec and panel.Spec.SetDefaultText then panel.Spec:SetDefaultText(SpecText()) end
	if panel.Spec and panel.Spec.GenerateMenu then pcall(panel.Spec.GenerateMenu, panel.Spec) end
	if panel.Spec and panel.Spec.legacy then UIDropDownMenu_SetText(panel.Spec, SpecText()) end
end

------------------------------------------------------------------------------------------
-- The character sheet's button
------------------------------------------------------------------------------------------

--[[
	A round button left of the main-hand slot on the character sheet, which opens the Gear tab.
	Our own frame on the paper doll's items frame: nothing of Blizzard's is changed, so the
	character window's own tabs and code are left alone.
]]
function GearPanel:AttachCharacterButton()
	if self.characterButton then return true end
	local items, mainHand = _G.PaperDollItemsFrame, _G.CharacterMainHandSlot
	if not (items and mainHand) then return false end
	local button = CreateFrame("Button", "AegisJournalGearButton", items)
	button:SetSize(30, 30)
	button:SetPoint("RIGHT", mainHand, "LEFT", -14, 0)
	button.Icon = button:CreateTexture(nil, "ARTWORK")
	button.Icon:SetAllPoints()
	button.Icon:SetTexture(LOGO)
	button.Highlight = button:CreateTexture(nil, "HIGHLIGHT")
	button.Highlight:SetAllPoints()
	button.Highlight:SetTexture(LOGO)
	button.Highlight:SetBlendMode("ADD")
	button.Highlight:SetAlpha(0.4)
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(L.GEAR_CHAR_BUTTON)
		GameTooltip:AddLine(L.GEAR_CHAR_BUTTON_TIP, 1, 1, 1, true)
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function() GameTooltip:Hide() end)
	button:SetScript("OnClick", function()
		ns.PlaySoundKit("IG_SPELLBOOK_OPEN")
		ns.Journal:ShowGear()
	end)
	self.characterButton = button
	return true
end

local events = CreateFrame("Frame")
ns.RegisterEvents(events, "PLAYER_LOGIN")
events:SetScript("OnEvent", function(self)
	GearPanel:AttachCharacterButton()
	ns.UnregisterEvents(self, "PLAYER_LOGIN")
end)
