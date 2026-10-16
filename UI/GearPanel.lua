local _, ns = ...
local L = ns.L

--[[
	The journal's Gear Finder tab (Core/GearFinder.lua), dressed as Forever's character panel
	(Blizzard_UIPanels_Game/Camelot/CharacterFrame.xml and PaperDollFrame.xml): its two pane
	backgrounds and the divider between them, its slot frames, header bar and striped rows.

	Left, the slots in the character sheet's two columns, each with the best upgrade waiting for
	it, marked with the equipment flyout's green arrow, or what is worn when there is none.
	Right, the sheet's own pane: the dungeon holding the most upgrades, which they are, the
	arrows through the other dungeons, and the ranged slot.

	The character panel's own tab for this is UI/CharacterTab.lua.
]]

local GearPanel = {}
ns.GearPanel = GearPanel

-- The two panes inside the panel's edge. The right one is the character sheet's own width; the
-- left one takes the rest, wider than the sheet's for the slots' names. The panel fills the
-- journal's inset, 792x431 (UI/Journal.lua).
local EDGE = 3
local RIGHT_WIDTH, PANE_HEIGHT = 233, 425

-- Slots as the sheet sets them: 37 square and 6 apart, 24 in from the left and 20 from the
-- right; the first row under the title and status line. The right pane's content sits 16 in,
-- as its side panes' does.
local SLOT_SIZE, ROW_STEP, FIRST_ROW = 37, 43, 59
local LEFT_X, RIGHT_X, SIDE_X = 24, 20, 16
local TEXT_GAP, TEXT_WIDTH = 8, 200
local SIDE_TEXT_WIDTH = RIGHT_WIDTH - 2 * SIDE_X - SLOT_SIZE - TEXT_GAP

-- Where each slot goes: { column, row }. Columns 1 and 2 are the left pane's, 3 the right pane.
local PLACES = {
	head = { 1, 1 }, neck = { 1, 2 }, shoulder = { 1, 3 }, back = { 1, 4 }, chest = { 1, 5 }, wrist = { 1, 6 },
	mainhand = { 1, 7 }, offhand = { 1, 8 },
	hands = { 2, 1 }, waist = { 2, 2 }, legs = { 2, 3 }, feet = { 2, 4 },
	finger1 = { 2, 5 }, finger2 = { 2, 6 }, trinket1 = { 2, 7 }, trinket2 = { 2, 8 },
	ranged = { 3, 8 },
}

-- The suggested dungeon's upgrades, as the sheet lists its stats: this many rows at most.
local SIDE_ROWS, ROW_WIDTH, ROW_HEIGHT = 5, 187, 23

local GAIN_COLOR = { 0.25, 1, 0.25 }
local DIM_COLOR = { 0.5, 0.5, 0.5 }
-- The level an item waits for, in the red the game gives what a player cannot use yet.
local LATER_COLOR = { 1, 0.1, 0.1 }

local SLOT_LABELS = {
	head = INVTYPE_HEAD or "Head", neck = INVTYPE_NECK or "Neck", shoulder = INVTYPE_SHOULDER or "Shoulder",
	back = INVTYPE_CLOAK or "Back", chest = INVTYPE_CHEST or "Chest", wrist = INVTYPE_WRIST or "Wrist",
	hands = INVTYPE_HAND or "Hands", waist = INVTYPE_WAIST or "Waist", legs = INVTYPE_LEGS or "Legs",
	feet = INVTYPE_FEET or "Feet", mainhand = INVTYPE_WEAPONMAINHAND or "Main Hand",
	offhand = INVTYPE_WEAPONOFFHAND or "Off Hand", ranged = INVTYPE_RANGED or "Ranged",
	finger1 = L.GEAR_SLOT_FINGER1, finger2 = L.GEAR_SLOT_FINGER2,
	trinket1 = L.GEAR_SLOT_TRINKET1, trinket2 = L.GEAR_SLOT_TRINKET2,
}

------------------------------------------------------------------------------------------
-- Art
------------------------------------------------------------------------------------------

-- Draws an atlas, at its own size when asked; false when this client lacks it.
local function Atlas(texture, atlas, ownSize)
	if not ns.AtlasExists(atlas) then return false end
	texture:SetAtlas(atlas, ownSize == true)
	return true
end

-- An atlas at its own size, cut off where it would run past width x height: art made for the
-- character sheet's taller panes, kept to ours.
local function AtlasCut(texture, atlas, width, height)
	if not Atlas(texture, atlas, true) then return false end
	local info = C_Texture.GetAtlasInfo(atlas)
	local fullWidth, fullHeight = info.width or width, info.height or height
	local shownWidth, shownHeight = math.min(fullWidth, width), math.min(fullHeight, height)
	texture:SetSize(shownWidth, shownHeight)
	if (shownWidth < fullWidth or shownHeight < fullHeight) and info.leftTexCoord then
		local left, right, top, bottom = info.leftTexCoord, info.rightTexCoord, info.topTexCoord, info.bottomTexCoord
		texture:SetTexCoord(left, left + (right - left) * shownWidth / fullWidth,
			top, top + (bottom - top) * shownHeight / fullHeight)
	end
	return true
end

-- The empty picture of an inventory slot, as the character sheet shows it.
local function EmptySlotTexture(inv)
	local getInfo = (C_PaperDollInfo and C_PaperDollInfo.GetInventorySlotInfo) or GetInventorySlotInfo
	if getInfo then
		local ok, _, texture = pcall(getInfo, inv)
		if ok and texture then return texture end
	end
	return "Interface\\PaperDoll\\UI-Backpack-EmptySlot"
end

------------------------------------------------------------------------------------------
-- Words
------------------------------------------------------------------------------------------

-- A gain in the spec's own unit: "31", or "0.8" when it is that small.
local function Points(value)
	if value >= 10 then return tostring(math.floor(value + 0.5)) end
	return string.format("%.1f", value)
end

--[[
	"+4.2%", "+12%": what an upgrade adds to everything worn. While nothing worn is worth
	anything to the spec (a fresh character), the plain gain: "+31", "+0.4".
]]
local function GainText(compare)
	local share = compare.share
	if not share then return "+" .. Points(compare.delta or 0) end
	if share < 9.95 then return string.format("+%.1f%%", share) end
	return string.format("+%d%%", math.floor(share + 0.5))
end
GearPanel.GainText = GainText

-- Who drops it: the boss, or the dungeon's trash.
local function SourceName(entry)
	return entry.boss.trash and L.LOOT_TRASH or entry.boss.name
end

-- The name of what is worn in a slot, from its link.
local function WornName(slotID)
	local link = GetInventoryItemLink("player", slotID)
	return link and link:match("%[(.-)%]") or nil
end

local function QualityRGB(quality)
	local r, g, b = ns.Items:QualityColor(quality)
	return r, g, b
end

------------------------------------------------------------------------------------------
-- Tooltips and clicks
------------------------------------------------------------------------------------------

-- What the upgrade is worth: against everything worn, and in the spec's unit against the item
-- it replaces.
local function AddGainLines(compare)
	local IS = ns.ItemScore
	local spec = IS:Spec()
	local data = ns.GEAR_WEIGHTS[IS:Class()]
	-- The journal's weights count in one stat (attack power, healing...); a player's own in points.
	local unit = (not IS:CustomWeights(spec) and data and data[spec] and data[spec].unit) or L.GEAR_UNIT_POINTS
	GameTooltip:AddLine(string.format(L.GEAR_TIP_GAIN, IS:SpecLabel(spec), GainText(compare)),
		GAIN_COLOR[1], GAIN_COLOR[2], GAIN_COLOR[3])
	-- What it replaces: a two-hander takes the off hand's place too.
	local names = {}
	for _, slot in ipairs({ compare.slot, compare.alsoSlot }) do
		local name = WornName(slot)
		if name then names[#names + 1] = name end
	end
	if #names == 0 then
		GameTooltip:AddLine(string.format(L.GEAR_TIP_EMPTY, Points(compare.delta), unit), 1, 1, 1, true)
	elseif #names == 1 then
		GameTooltip:AddLine(string.format(L.GEAR_TIP_OVER, Points(compare.delta), unit, names[1]), 1, 1, 1, true)
	else
		GameTooltip:AddLine(string.format(L.GEAR_TIP_OVER_BOTH, Points(compare.delta), unit, names[1], names[2]),
			1, 1, 1, true)
	end
end

local function ShowCompare()
	if type(GameTooltip_ShowCompareItem) == "function" and IsModifiedClick and IsModifiedClick("COMPAREITEMS") then
		pcall(GameTooltip_ShowCompareItem)
	end
end

local function ShowEntryTooltip(owner, entry, anchor, others)
	GameTooltip:SetOwner(owner, anchor or "ANCHOR_RIGHT")
	GameTooltip:SetHyperlink(entry.link)
	GameTooltip:AddLine(" ")
	AddGainLines(entry.compare)
	GameTooltip:AddLine(entry.instance.name .. " \194\183 " .. SourceName(entry), 1, 0.82, 0)
	if entry.compare.later then GameTooltip:AddLine(string.format(L.GEAR_TIP_LATER, entry.compare.minLevel), 1, 0.2, 0.2) end
	-- The next best for the slot, so a pick isn't the only thing it says.
	local listed = 0
	for _, other in ipairs(others or {}) do
		if other.itemID ~= entry.itemID and listed < 3 then
			if listed == 0 then GameTooltip:AddLine(L.GEAR_TIP_MORE, 0.75, 0.75, 0.75) end
			GameTooltip:AddDoubleLine((other.info.name or other.link) .. " (" .. other.instance.name .. ")",
				GainText(other.compare), 1, 1, 1, GAIN_COLOR[1], GAIN_COLOR[2], GAIN_COLOR[3])
			listed = listed + 1
		end
	end
	GameTooltip:AddLine(L.GEAR_TIP_CLICK, 0.5, 0.8, 1)
	GameTooltip:Show()
	ShowCompare()
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

-- A click on an upgrade: shift and ctrl do what they do on any item (link it, try it on); a
-- plain one opens it.
local function ClickEntry(entry)
	if not entry then return end
	if entry.link and type(HandleModifiedItemClick) == "function" and HandleModifiedItemClick(entry.link) then return end
	OpenEntry(entry)
end

-- A cell's click: its upgrade's, or for what is worn there, only shift's and ctrl's.
local function ClickCell(cell)
	if cell.entry then
		ClickEntry(cell.entry)
		return
	end
	local link = GetInventoryItemLink("player", cell.def.slot)
	if link and type(HandleModifiedItemClick) == "function" then HandleModifiedItemClick(link) end
end

------------------------------------------------------------------------------------------
-- Slot cells
------------------------------------------------------------------------------------------

local function ShowCellTooltip(cell)
	local entry = cell.entry
	local anchor = cell.mirrored and "ANCHOR_LEFT" or "ANCHOR_RIGHT"
	if entry then
		ShowEntryTooltip(cell, entry, anchor, cell.others)
		return
	end
	-- No upgrade: what is worn, as the sheet's own slot shows it.
	GameTooltip:SetOwner(cell, anchor)
	local slotID = cell.def.slot
	if GetInventoryItemLink("player", slotID) then
		GameTooltip:SetInventoryItem("player", slotID)
	else
		GameTooltip:SetText(SLOT_LABELS[cell.def.key] or cell.def.key, 1, 1, 1)
	end
	GameTooltip:AddLine(L.GEAR_TIP_NONE, DIM_COLOR[1], DIM_COLOR[2], DIM_COLOR[3], true)
	GameTooltip:Show()
end

--[[
	A slot as the character sheet draws one (PaperDollItemSlotButtonTemplate's look: the slot
	frame, the quick-slot edge, the quality border), with the item's name and where it drops
	beside it. Built rather than inherited: the sheet's template equips and picks up items.
	Cells in the right-hand column face the other way, their text towards the middle.
]]
local function CreateCell(panel, def)
	local column, row = PLACES[def.key][1], PLACES[def.key][2]
	local mirrored = column == 2
	local textWidth = column == 3 and SIDE_TEXT_WIDTH or TEXT_WIDTH
	local cell = CreateFrame("Button", nil, panel)
	cell:SetSize(SLOT_SIZE + TEXT_GAP + textWidth, SLOT_SIZE)
	local y = -(EDGE + FIRST_ROW + (row - 1) * ROW_STEP)
	if column == 1 then
		cell:SetPoint("TOPLEFT", EDGE + LEFT_X, y)
	elseif column == 2 then
		cell:SetPoint("TOPRIGHT", -(EDGE + RIGHT_WIDTH + RIGHT_X), y)
	else
		cell:SetPoint("TOPLEFT", panel, "TOPRIGHT", -(EDGE + RIGHT_WIDTH) + SIDE_X, y)
	end
	cell.def, cell.mirrored = def, mirrored
	cell.emptyTexture = EmptySlotTexture(def.inv)

	cell.Icon = cell:CreateTexture(nil, "BORDER")
	cell.Icon:SetSize(SLOT_SIZE, SLOT_SIZE)
	cell.Icon:SetPoint(mirrored and "RIGHT" or "LEFT")

	cell.SlotFrame = cell:CreateTexture(nil, "BACKGROUND")
	cell.SlotFrame:SetPoint("CENTER", cell.Icon)
	cell.SlotFrame:SetShown(Atlas(cell.SlotFrame, "UI-Character-Info-GearSlot", true))

	cell.Edge = cell:CreateTexture(nil, "ARTWORK")
	cell.Edge:SetTexture("Interface\\Buttons\\UI-Quickslot2")
	cell.Edge:SetSize(64, 64)
	cell.Edge:SetPoint("CENTER", cell.Icon, 0, -1)

	cell.IconBorder = cell:CreateTexture(nil, "OVERLAY")
	cell.IconBorder:SetTexture("Interface\\Common\\WhiteIconFrame")
	cell.IconBorder:SetAllPoints(cell.Icon)

	-- The equipment flyout's mark for an upgrade.
	cell.Arrow = cell:CreateTexture(nil, "OVERLAY", nil, 2)
	if not Atlas(cell.Arrow, "bags-greenarrow", true) then
		cell.Arrow:SetSize(14, 14)
		cell.Arrow:SetTexture("Interface\\Buttons\\UI-MicroStream-Green")
	end
	cell.Arrow:SetPoint("TOPLEFT", cell.Icon, -2, 2)

	-- The level an item waits for, where the sheet puts a count.
	cell.Level = cell:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
	cell.Level:SetPoint("BOTTOMRIGHT", cell.Icon, -3, 2)

	cell.IconHighlight = cell:CreateTexture(nil, "HIGHLIGHT")
	cell.IconHighlight:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
	cell.IconHighlight:SetBlendMode("ADD")
	cell.IconHighlight:SetAllPoints(cell.Icon)

	-- The character panel's row light, behind the text.
	cell.Hover = cell:CreateTexture(nil, "HIGHLIGHT")
	if Atlas(cell.Hover, "charactercreate-customize-dropdown-linemouseover-middle") then
		cell.Hover:SetAlpha(0.1)
	else
		cell.Hover:SetColorTexture(1, 1, 1, 0.06)
	end
	cell.Hover:SetPoint("TOP", 0, 2)
	cell.Hover:SetPoint("BOTTOM", 0, -2)
	if mirrored then
		cell.Hover:SetPoint("LEFT", -4, 0)
		cell.Hover:SetPoint("RIGHT", cell.Icon, "LEFT", -2, 0)
	else
		cell.Hover:SetPoint("LEFT", cell.Icon, "RIGHT", 2, 0)
		cell.Hover:SetPoint("RIGHT", 4, 0)
	end

	local side = mirrored and "RIGHT" or "LEFT"
	local out = mirrored and -TEXT_GAP or TEXT_GAP
	cell.Name = cell:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	cell.Name:SetPoint("TOP" .. side, cell.Icon, "TOP" .. (mirrored and "LEFT" or "RIGHT"), out, -3)
	cell.Name:SetWidth(textWidth)
	cell.Name:SetJustifyH(side)
	cell.Name:SetWordWrap(false)

	-- Second line: where it drops, and the gain just after it, so each cell's gain stays by its
	-- own words (the two columns' would otherwise meet in the middle).
	cell.Gain = cell:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	cell.Gain:SetTextColor(GAIN_COLOR[1], GAIN_COLOR[2], GAIN_COLOR[3])
	cell.Source = cell:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	cell.Source:SetWordWrap(false)
	cell.Source:SetJustifyH(side)
	cell.Source:SetPoint("BOTTOM" .. side, cell.Icon, "BOTTOM" .. (mirrored and "LEFT" or "RIGHT"), out, 4)
	cell.Gain:SetPoint("BOTTOM" .. side, cell.Source, "BOTTOM" .. (mirrored and "LEFT" or "RIGHT"), mirrored and -6 or 6, 0)
	cell.textWidth = textWidth

	cell:SetScript("OnEnter", ShowCellTooltip)
	cell:SetScript("OnLeave", function() GameTooltip:Hide() end)
	cell:SetScript("OnClick", ClickCell)
	-- The tooltip rebuilds itself when the client sends more of the item, or shift is pressed.
	cell.UpdateTooltip = ShowCellTooltip
	return cell
end

-- The second line's words, as wide as they need and no wider than the gain leaves them.
local function SetSource(cell, text, gain)
	cell.Gain:SetText(gain or "")
	cell.Source:SetText(text)
	local room = cell.textWidth - ((gain and gain ~= "") and ((cell.Gain:GetStringWidth() or 0) + 6) or 0)
	cell.Source:SetWidth(math.max(1, math.min(cell.Source:GetStringWidth() or room, room)))
end

local function SetIcon(cell, texture, quality)
	cell.Icon:SetTexture(texture or cell.emptyTexture)
	if quality and quality >= 2 then
		cell.IconBorder:SetVertexColor(QualityRGB(quality))
		cell.IconBorder:Show()
	else
		cell.IconBorder:Hide()
	end
end

-- The upgrade a cell shows, or what is worn in its slot when there is none.
local function SetCell(cell, shown, entries)
	cell.entry, cell.others = shown, entries
	if shown then
		local compare = shown.compare
		SetIcon(cell, ns.Items:Icon(shown.itemID), shown.info.quality)
		cell.Arrow:Show()
		cell.Level:SetText(compare.later and compare.minLevel or "")
		cell.Level:SetTextColor(LATER_COLOR[1], LATER_COLOR[2], LATER_COLOR[3])
		cell.Name:SetText(shown.info.name or "")
		cell.Name:SetTextColor(QualityRGB(shown.info.quality))
		SetSource(cell, shown.instance.name, GainText(compare))
		cell.Source:SetTextColor(1, 1, 1)
		return
	end
	local slotID = cell.def.slot
	local link = GetInventoryItemLink("player", slotID)
	cell.Arrow:Hide()
	cell.Level:SetText("")
	if link then
		local quality = GetInventoryItemQuality("player", slotID)
		SetIcon(cell, GetInventoryItemTexture("player", slotID), quality)
		cell.Name:SetText(link:match("%[(.-)%]") or "")
		cell.Name:SetTextColor(QualityRGB(quality))
	else
		SetIcon(cell, nil, nil)
		cell.Name:SetText(SLOT_LABELS[cell.def.key] or cell.def.key)
		cell.Name:SetTextColor(DIM_COLOR[1], DIM_COLOR[2], DIM_COLOR[3])
	end
	SetSource(cell, L.GEAR_NO_UPGRADE)
	cell.Source:SetTextColor(DIM_COLOR[1], DIM_COLOR[2], DIM_COLOR[3])
end

------------------------------------------------------------------------------------------
-- The right pane: the suggested dungeon
------------------------------------------------------------------------------------------

-- A row's tooltip: its upgrade's, or for the last row of a long list, the slots it stands for.
local function ShowRowTooltip(row)
	if row.entry then
		ShowEntryTooltip(row, row.entry, "ANCHOR_LEFT")
	elseif row.more then
		GameTooltip:SetOwner(row, "ANCHOR_LEFT")
		for index, entry in ipairs(row.more.entries) do
			GameTooltip:AddDoubleLine(SLOT_LABELS[row.more.slots[index]] or row.more.slots[index], GainText(entry.compare),
				1, 0.82, 0, GAIN_COLOR[1], GAIN_COLOR[2], GAIN_COLOR[3])
		end
		GameTooltip:Show()
	end
end

-- A row as the sheet lists a stat: gold label, white value, a stripe behind every other one.
local function CreateRow(parent, index)
	local row = CreateFrame("Button", nil, parent)
	row:SetSize(ROW_WIDTH, ROW_HEIGHT)
	row.Stripe = row:CreateTexture(nil, "BACKGROUND")
	row.Stripe:SetPoint("CENTER")
	row.Stripe:SetShown(index % 2 == 1 and Atlas(row.Stripe, "UI-Character-Info-Line-Bounce2", true))
	row.Label = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	row.Label:SetPoint("LEFT", 11, 0)
	row.Label:SetJustifyH("LEFT")
	row.Value = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	row.Value:SetPoint("RIGHT", -8, 0)
	row.Value:SetTextColor(GAIN_COLOR[1], GAIN_COLOR[2], GAIN_COLOR[3])
	row.Hover = row:CreateTexture(nil, "HIGHLIGHT")
	row.Hover:SetAllPoints()
	if Atlas(row.Hover, "charactercreate-customize-dropdown-linemouseover-middle") then
		row.Hover:SetAlpha(0.1)
	else
		row.Hover:SetColorTexture(1, 1, 1, 0.06)
	end
	row:SetScript("OnEnter", ShowRowTooltip)
	row:SetScript("OnLeave", function() GameTooltip:Hide() end)
	row:SetScript("OnClick", function(self) ClickEntry(self.entry) end)
	row.UpdateTooltip = ShowRowTooltip
	return row
end

-- The spellbook's page arrows, which the character panel uses for its own.
local function CreatePageButton(parent, direction)
	local button = CreateFrame("Button", nil, parent)
	button:SetSize(28, 28)
	local name = direction < 0 and "Prev" or "Next"
	button:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-" .. name .. "Page-Up")
	button:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-" .. name .. "Page-Down")
	button:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-" .. name .. "Page-Disabled")
	button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	return button
end

local function CreateSide(panel)
	local side = CreateFrame("Frame", nil, panel)
	side:SetPoint("TOPRIGHT", -EDGE, -EDGE)
	side:SetPoint("BOTTOMRIGHT", -EDGE, EDGE)
	side:SetWidth(RIGHT_WIDTH)

	side.Background = side:CreateTexture(nil, "BACKGROUND", nil, -8)
	side.Background:SetAllPoints()
	if not Atlas(side.Background, "UI-Character-Info-Stat-BG") then side.Background:SetColorTexture(0.05, 0.05, 0.05, 1) end
	-- The class's own tint, as behind the sheet's stats.
	side.ClassBackground = side:CreateTexture(nil, "BACKGROUND", nil, -7)
	side.ClassBackground:SetPoint("TOPLEFT")
	side.ClassBackground:SetShown(AtlasCut(side.ClassBackground,
		string.format("UI-Character-Info-%s-BG", ns.ItemScore:Class() or ""), RIGHT_WIDTH, PANE_HEIGHT))
	-- The line between the panes.
	side.Divider = side:CreateTexture(nil, "OVERLAY")
	if Atlas(side.Divider, "common-framedivider", true) then
		side.Divider:SetPoint("TOPLEFT", -6, -1)
		side.Divider:SetPoint("BOTTOMLEFT", -6, 0)
	else
		side.Divider:Hide()
	end

	-- What the pane shows: the suggested dungeon, or the stat weights (GearPanel:ShowWeights).
	local content = CreateFrame("Frame", nil, side)
	content:SetAllPoints()
	side.Suggestion = content

	-- "Suggested dungeon", on the sheet's category bar.
	side.Header = CreateFrame("Frame", nil, content)
	side.Header:SetSize(197, 40)
	side.Header:SetPoint("TOP", 0, -8)
	side.Header.Background = side.Header:CreateTexture(nil, "BACKGROUND")
	side.Header.Background:SetAllPoints()
	side.Header.Background:SetShown(Atlas(side.Header.Background, "UI-Character-Info-Title"))
	side.Header.Title = side.Header:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	side.Header.Title:SetPoint("CENTER", 0, 1)
	side.Header.Title:SetText(L.GEAR_SUGGESTED)

	-- The dungeon, as its button on the Dungeons tab: a click opens it.
	side.Dungeon = ns.CreateInstanceButton(content)
	side.Dungeon:SetPoint("TOP", side.Header, "BOTTOM", 0, -4)

	-- "5 upgrades here", in the sheet's item-level box.
	side.Count = CreateFrame("Frame", nil, content)
	side.Count:SetSize(ROW_WIDTH, 29)
	side.Count:SetPoint("TOP", side.Dungeon, "BOTTOM", 0, -4)
	side.Count.Background = side.Count:CreateTexture(nil, "BORDER")
	side.Count.Background:SetAllPoints()
	side.Count.Background:SetShown(Atlas(side.Count.Background, "UI-Character-Info-ItemLevel-Bounce"))
	side.Count.Text = side.Count:CreateFontString(nil, "OVERLAY", ns.Font("Game15Font_o1", "GameFontNormalLarge"))
	side.Count.Text:SetPoint("CENTER", 0, -1)
	side.Count.Text:SetTextColor(GAIN_COLOR[1], GAIN_COLOR[2], GAIN_COLOR[3])

	side.Rows = {}
	for index = 1, SIDE_ROWS do
		local row = CreateRow(content, index)
		row:SetPoint("TOP", index == 1 and side.Count or side.Rows[index - 1], "BOTTOM", 0, index == 1 and -2 or 0)
		side.Rows[index] = row
	end

	-- The other dungeons with upgrades.
	side.Previous = CreatePageButton(content, -1)
	side.Next = CreatePageButton(content, 1)
	side.Of = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	side.Of:SetPoint("TOP", side.Rows[SIDE_ROWS], "BOTTOM", 0, -12)
	side.Previous:SetPoint("RIGHT", side.Of, "LEFT", -6, 0)
	side.Next:SetPoint("LEFT", side.Of, "RIGHT", 6, 0)
	for _, button in ipairs({ side.Previous, side.Next }) do
		local direction = button == side.Previous and -1 or 1
		button:SetScript("OnClick", function()
			ns.PlaySoundKit("IG_ABILITY_PAGE_TURN")
			panel.suggestIndex = (panel.suggestIndex or 1) + direction
			GearPanel:Redraw(panel)
		end)
	end

	side.None = content:CreateFontString(nil, "OVERLAY", "GameFontDisable")
	side.None:SetPoint("TOP", side.Header, "BOTTOM", 0, -40)
	side.None:SetWidth(RIGHT_WIDTH - 2 * SIDE_X)
	side.None:SetText(L.GEAR_NONE)
	return side
end

local function SetSide(side, suggestions, index)
	local dungeon = suggestions[index]
	for _, region in ipairs({ side.Dungeon, side.Count }) do region:SetShown(dungeon ~= nil) end
	local paged = dungeon ~= nil and #suggestions > 1
	side.Previous:SetShown(paged)
	side.Next:SetShown(paged)
	side.Of:SetShown(paged)
	side.None:SetShown(dungeon == nil)
	for _, row in ipairs(side.Rows) do
		row.entry, row.more = nil, nil
		row:Hide()
	end
	if not dungeon then return end

	ns.SetInstanceButton(side.Dungeon, dungeon.instance)
	side.Count.Text:SetText(dungeon.count == 1 and L.GEAR_UPGRADE_HERE or string.format(L.GEAR_UPGRADES_HERE, dungeon.count))
	-- One row a slot; past the last row, how many more.
	local count = #dungeon.slots
	local rows = count > SIDE_ROWS and SIDE_ROWS - 1 or count
	for rowIndex = 1, rows do
		local row = side.Rows[rowIndex]
		local entry = dungeon.entries[rowIndex]
		row.entry = entry
		row.Label:SetText(SLOT_LABELS[dungeon.slots[rowIndex]] or dungeon.slots[rowIndex])
		row.Value:SetText(GainText(entry.compare))
		row:Show()
	end
	if count > rows then
		local row = side.Rows[SIDE_ROWS]
		row.more = { slots = {}, entries = {} }
		for index = rows + 1, count do
			row.more.slots[#row.more.slots + 1] = dungeon.slots[index]
			row.more.entries[#row.more.entries + 1] = dungeon.entries[index]
		end
		row.Label:SetText(string.format(L.GEAR_MORE_SLOTS, count - rows))
		row.Value:SetText("")
		row:Show()
	end
	side.Of:SetText(string.format(L.GEAR_DUNGEON_OF, index, #suggestions))
end

------------------------------------------------------------------------------------------
-- The spec menu
------------------------------------------------------------------------------------------

local function SpecText()
	local IS = ns.ItemScore
	local spec, why = IS:Spec()
	if not spec then return "" end
	local label = IS:SpecLabel(spec)
	if IS:CustomWeights(spec) then return string.format(L.GEAR_WHY_CUSTOM, label) end
	if why == "talents" then return string.format(L.GEAR_WHY_TALENTS, label) end
	if why == "levelling" then return string.format(L.GEAR_WHY_LEVELLING, label) end
	return label
end

local function AutomaticText()
	local IS = ns.ItemScore
	return string.format(L.GEAR_AUTO, IS:SpecLabel(IS:AutoSpec()))
end

--[[
	The spec menu: automatic, then the class's specs; with `onEdit`, a last entry that opens the
	stat weights. Built for the Gear Finder tab and the weights editors alike.
]]
function GearPanel.CreateSpecMenu(parent, width, onEdit)
	local IS = ns.ItemScore
	if ns.HasTemplate("WowStyle1DropdownTemplate") then
		local ok, dropdown = pcall(CreateFrame, "DropdownButton", nil, parent, "WowStyle1DropdownTemplate")
		if ok and dropdown and dropdown.SetupMenu then
			dropdown:SetWidth(width)
			dropdown:SetupMenu(function(_, rootDescription)
				rootDescription:CreateRadio(AutomaticText(),
					function() return IS:PickedSpec() == nil end, function() IS:SetSpec(nil) end)
				for _, spec in ipairs(IS:Specs()) do
					rootDescription:CreateRadio(spec.label,
						function() return IS:PickedSpec() == spec.key end, function() IS:SetSpec(spec.key) end)
				end
				if onEdit then
					rootDescription:CreateDivider()
					rootDescription:CreateButton(L.WEIGHTS_EDIT, onEdit)
				end
			end)
			-- The closed menu says why: "Retribution, while levelling".
			if dropdown.SetSelectionText then dropdown:SetSelectionText(function() return SpecText() end) end
			return dropdown
		end
	end
	-- Older menu system, for a client without the modern dropdown.
	local dropdown = CreateFrame("Frame", nil, parent, "UIDropDownMenuTemplate")
	UIDropDownMenu_SetWidth(dropdown, width - 20)
	UIDropDownMenu_Initialize(dropdown, function()
		local info = UIDropDownMenu_CreateInfo()
		info.text = AutomaticText()
		info.checked = IS:PickedSpec() == nil
		info.func = function() IS:SetSpec(nil) end
		UIDropDownMenu_AddButton(info)
		for _, spec in ipairs(IS:Specs()) do
			info = UIDropDownMenu_CreateInfo()
			info.text = spec.label
			info.checked = IS:PickedSpec() == spec.key
			info.func = function() IS:SetSpec(spec.key) end
			UIDropDownMenu_AddButton(info)
		end
		if onEdit then
			info = UIDropDownMenu_CreateInfo()
			info.text = L.WEIGHTS_EDIT
			info.notCheckable = true
			info.func = onEdit
			UIDropDownMenu_AddButton(info)
		end
	end)
	dropdown.legacy = true
	return dropdown
end

-- After a change: the closed menu's words, and its ticks.
function GearPanel.UpdateSpecMenu(dropdown)
	if dropdown.GenerateMenu then pcall(dropdown.GenerateMenu, dropdown) end
	if dropdown.legacy then UIDropDownMenu_SetText(dropdown, SpecText()) end
end

-- In the left pane's top right corner, where the character panel's reputation page has its filter.
local function CreateSpecMenu(panel)
	local right = -(EDGE + RIGHT_WIDTH + 14)
	panel.ScoringLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	local dropdown = GearPanel.CreateSpecMenu(panel, 190, function() GearPanel:ShowWeights(panel, true) end)
	if dropdown.legacy then
		dropdown:SetPoint("TOPRIGHT", right + 15, -12)
		panel.ScoringLabel:SetPoint("RIGHT", dropdown, "LEFT", 8, 2)
	else
		dropdown:SetPoint("TOPRIGHT", right, -16)
		panel.ScoringLabel:SetPoint("RIGHT", dropdown, "LEFT", -8, 0)
	end
	panel.ScoringLabel:SetText(L.GEAR_SCORING)
	return dropdown
end

------------------------------------------------------------------------------------------
-- The panel
------------------------------------------------------------------------------------------

function GearPanel:Build(panel)
	-- The character sheet's backgrounds in place of the journal's backdrop.
	panel.Background:Hide()
	panel.LeftBackground = panel:CreateTexture(nil, "BACKGROUND", nil, -8)
	panel.LeftBackground:SetPoint("TOPLEFT", EDGE, -EDGE)
	panel.LeftBackground:SetPoint("BOTTOMRIGHT", -(EDGE + RIGHT_WIDTH), EDGE)
	if not Atlas(panel.LeftBackground, "UI-Character-Info-General-BG") then
		panel.LeftBackground:SetColorTexture(0.06, 0.05, 0.04, 1)
	end

	panel.Title:SetText(L.GEAR_TITLE)
	panel.Preview = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	panel.Preview:SetPoint("LEFT", panel.Title, "RIGHT", 8, -1)
	panel.Preview:SetText(L.GEAR_PREVIEW)

	panel.Status = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	panel.Status:SetPoint("TOPLEFT", 22, -44)
	panel.Status:SetJustifyH("LEFT")

	panel.Spec = CreateSpecMenu(panel)
	panel.Side = CreateSide(panel)
	panel.Cells = {}
	for _, def in ipairs(ns.GearFinder.CELLS) do
		panel.Cells[#panel.Cells + 1] = CreateCell(panel, def)
	end
	panel.suggestIndex = 1

	ns.GearFinder.IsShowing = function() return panel:IsVisible() end
	ns.GearFinder:OnUpdate(function()
		if panel:IsVisible() then GearPanel:Redraw(panel) end
	end)
	-- Searched on the next frame: a journal opened straight onto another page hides this at once.
	-- Shown again and again in one frame (a journal toggled quickly), it still searches once.
	panel:HookScript("OnShow", function()
		panel.suggestIndex = 1
		-- Opened anew, the tab shows its upgrades; /aegis weights turns it to the weights after.
		if rawget(panel.Side, "EditorHolder") then GearPanel:ShowWeights(panel, false) end
		if panel.searchPending then return end
		panel.searchPending = true
		C_Timer.After(0, function()
			panel.searchPending = nil
			if panel:IsVisible() then ns.GearFinder:Refresh() end
		end)
	end)
	self.panel = panel
end

--[[
	The right pane's other face: the stat weights (UI/WeightsEditor.lua), built when first shown,
	above the ranged slot; Back returns to the suggested dungeon.
]]
function GearPanel:ShowWeights(panel, shown)
	local side = panel.Side
	if shown and not rawget(side, "Editor") then
		local holder = CreateFrame("Frame", nil, side)
		holder:SetPoint("TOPLEFT")
		holder:SetPoint("BOTTOMRIGHT", 0, PANE_HEIGHT - (FIRST_ROW + 7 * ROW_STEP) + 8)
		side.Editor = ns.WeightsEditor:Create(holder, {
			extra = { text = L.WEIGHTS_BACK, onClick = function() GearPanel:ShowWeights(panel, false) end },
		})
		side.EditorHolder = holder
	end
	if rawget(side, "EditorHolder") then side.EditorHolder:SetShown(shown) end
	side.Suggestion:SetShown(not shown)
	if shown then side.Editor:Refresh() end
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
	SetSide(panel.Side, suggestions, panel.suggestIndex)

	local _, missing, looked = finder:Results()
	local status = looked == 1 and L.GEAR_LOOKING_ONE or string.format(L.GEAR_LOOKING, looked)
	if missing > 0 then
		status = status .. " " .. (missing == 1 and L.GEAR_LOADING_ONE or string.format(L.GEAR_LOADING, missing))
	end
	panel.Status:SetText(status)
	if panel.Spec then GearPanel.UpdateSpecMenu(panel.Spec) end
end
