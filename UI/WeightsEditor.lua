local _, ns = ...
local L = ns.L

--[[
	The Gear Finder's stat weights, to read and to change, laid out as the character panel lists
	its stats (Blizzard_UIPanels_Game/Camelot/CharacterFrame.xml): a bar for each group (Primary
	Attributes, Weapons, Spells, Defense, Resistances) and a striped row for each stat, its weight
	where the panel shows a stat's value. A weight is changed in place, by clicking it; the
	player's own show green, as a raised stat does on the panel. A scale from Pawn can be pasted
	in. The weights are the spec's that the Gear Finder scores (Core/ItemScore.lua), kept per
	character.

	One editor is built for each place it shows: the window on the character panel
	(UI/CharacterTab.lua) and the journal's Gear Finder tab (UI/GearPanel.lua). All of them follow
	the same weights.
]]

local WeightsEditor = {}
ns.WeightsEditor = WeightsEditor

local HEADER_WIDTH, HEADER_HEIGHT = 197, 40  -- the panel's category bar
local ROW_WIDTH, ROW_HEIGHT = 187, 23         -- its stat rows
local VALUE_WIDTH = 64
local PASTE_WIDTH = HEADER_WIDTH - 40
local BUTTON_HEIGHT = 24
local OWN_COLOR = { 0.1, 1, 0.1 }             -- the panel's raised stat

local editors = {}

local function Atlas(texture, atlas, ownSize)
	if not ns.AtlasExists(atlas) then return false end
	texture:SetAtlas(atlas, ownSize == true)
	return true
end

-- A weight as written: up to four decimals, no trailing zeros; a smaller one never shown as 0.
local function WeightText(value)
	if not value or value == 0 then return "0" end
	local text = string.format("%.4f", value):gsub("0+$", ""):gsub("%.$", "")
	if text == "0" or text == "-0" then text = string.format("%.2g", value) end
	return text
end
WeightsEditor.WeightText = WeightText

-- A typed weight: a number, with a comma taken for a point; nil for anything else, or an absurd one.
local function ReadWeight(text)
	text = tostring(text or ""):gsub(",", "."):match("^%s*(.-)%s*$")
	if text == "" then return 0 end
	local value = tonumber(text)
	if not ns.ItemScore.SaneWeight(value) then return nil end
	return value
end

local function CreateButton(parent, text, width)
	local button = ns.CreateFrameWithTemplate("Button", nil, parent, "SharedButtonSmallTemplate", "UIPanelButtonTemplate")
	button:SetSize(width, BUTTON_HEIGHT)
	button:SetText(text)
	return button
end

local function Tooltip(owner, title, text)
	owner:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(title, 1, 1, 1)
		GameTooltip:AddLine(text, nil, nil, nil, true)
		GameTooltip:Show()
	end)
	owner:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

------------------------------------------------------------------------------------------
-- Rows
------------------------------------------------------------------------------------------

local function SpecNow()
	return ns.ItemScore:Spec()
end

--[[
	Takes what was typed: a new weight for the spec it was typed for, or the old one back if it
	isn't a number. A box left as it was shown changes nothing (its weight may hold more than the
	box shows).
]]
local function Commit(row)
	local IS = ns.ItemScore
	local spec = row.editSpec or SpecNow()
	local current = IS:Weights(spec)[row.stat] or 0
	local text = row.Value:GetText()
	if text == row.shownText then return end
	local value = ReadWeight(text)
	if value and math.abs(value - current) > 1e-9 then
		IS:SetWeight(spec, row.stat, value)
	else
		row.Value:SetText(WeightText(current))
		row.shownText = row.Value:GetText()
	end
end

-- The row to go to with Tab (Shift-Tab: the one before), scrolled into view.
local function FocusRow(row)
	if not row then return end
	local scroll = row.editor.Scroll
	local top, height = scroll:GetVerticalScroll() or 0, scroll:GetHeight() or 0
	if row.y < top then
		scroll:SetVerticalScroll(row.y)
	elseif height > 0 and row.y + ROW_HEIGHT > top + height then
		scroll:SetVerticalScroll(math.min(scroll:GetVerticalScrollRange() or 0, row.y + ROW_HEIGHT - height))
	end
	row.Value:SetFocus()
end

local function ShowRowTooltip(row)
	local IS = ns.ItemScore
	local spec = SpecNow()
	GameTooltip:SetOwner(row, "ANCHOR_LEFT")
	GameTooltip:SetText(L.STAT_NAMES[row.stat] or row.stat, 1, 1, 1)
	GameTooltip:AddDoubleLine(L.WEIGHTS_SOURCE_DEFAULT, WeightText(IS:DefaultWeights(spec)[row.stat]), 1, 0.82, 0, 1, 1, 1)
	GameTooltip:AddLine(L.WEIGHTS_TIP, nil, nil, nil, true)
	GameTooltip:Show()
end

-- A stat row as the panel draws one: gold name, the weight in white (green when the player's).
local function CreateRow(parent, stat, striped)
	local row = CreateFrame("Frame", nil, parent)
	row:SetSize(ROW_WIDTH, ROW_HEIGHT)
	row.stat = stat
	row:EnableMouse(true)
	row.Stripe = row:CreateTexture(nil, "BACKGROUND")
	row.Stripe:SetPoint("CENTER")
	row.Stripe:SetShown(striped and Atlas(row.Stripe, "UI-Character-Info-Line-Bounce2", true))
	row.Label = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	row.Label:SetPoint("LEFT", 11, 0)
	row.Label:SetJustifyH("LEFT")
	row.Label:SetText(string.format(STAT_FORMAT or "%s:", L.STAT_NAMES[stat] or stat))

	-- The weight, typed over where the panel writes a value.
	local value = CreateFrame("EditBox", nil, row)
	value:SetSize(VALUE_WIDTH, ROW_HEIGHT - 4)
	value:SetPoint("RIGHT", -8, 0)
	value:SetFontObject("GameFontHighlight")
	value:SetJustifyH("RIGHT")
	value:SetAutoFocus(false)
	value:SetMaxLetters(8)
	value.Focus = value:CreateTexture(nil, "BACKGROUND")
	value.Focus:SetPoint("TOPLEFT", -4, 0)
	value.Focus:SetPoint("BOTTOMRIGHT", 4, 0)
	value.Focus:SetColorTexture(1, 1, 1, 0.08)
	value.Focus:Hide()
	value:SetScript("OnEditFocusGained", function(self)
		row.editSpec = SpecNow()
		self.Focus:Show()
		self:HighlightText()
	end)
	value:SetScript("OnEditFocusLost", function(self)
		self.Focus:Hide()
		self:HighlightText(0, 0)
		Commit(row)
		row.editSpec = nil
	end)
	value:SetScript("OnEnterPressed", function(self)
		Commit(row)
		self:ClearFocus()
	end)
	value:SetScript("OnEscapePressed", function(self)
		self:SetText(row.shownText or "")
		self:ClearFocus()
	end)
	value:SetScript("OnTabPressed", function()
		FocusRow(IsShiftKeyDown and IsShiftKeyDown() and row.previous or row.next)
	end)
	row.Value = value
	row:SetScript("OnEnter", ShowRowTooltip)
	row:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return row
end

-- A group's bar, as the panel heads its stats ("Primary Attributes").
local function CreateHeader(parent, title)
	local header = CreateFrame("Frame", nil, parent)
	header:SetSize(HEADER_WIDTH, HEADER_HEIGHT)
	header.Background = header:CreateTexture(nil, "BACKGROUND")
	header.Background:SetAllPoints()
	if not Atlas(header.Background, "UI-Character-Info-Title") then header.Background:SetColorTexture(0, 0, 0, 0.4) end
	header.Title = header:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	header.Title:SetPoint("CENTER", 0, 1)
	header.Title:SetText(title)
	return header
end

------------------------------------------------------------------------------------------
-- The editor
------------------------------------------------------------------------------------------

local function SourceText(spec)
	local IS = ns.ItemScore
	local custom = IS:CustomWeights(spec)
	if custom and custom.source then return string.format(L.WEIGHTS_SOURCE_PAWN, custom.source) end
	if custom then return L.WEIGHTS_SOURCE_CUSTOM end
	local data = ns.GEAR_WEIGHTS[IS:Class()]
	local entry = data and data[spec]
	if entry and entry.leveling and IS:Level() < 60 then return L.WEIGHTS_SOURCE_LEVELLING end
	return L.WEIGHTS_SOURCE_DEFAULT
end

-- The rows and bars, one under the other in the scroll frame.
local function BuildList(editor)
	local child = editor.Scroll.Child
	child:SetWidth(HEADER_WIDTH)
	editor.Rows = {}
	local y, previous = 0, nil
	for _, group in ipairs(ns.ItemScore.STAT_GROUPS) do
		local header = CreateHeader(child, L.WEIGHT_GROUPS[group.key] or group.key)
		header:SetPoint("TOP", 0, -y)
		y = y + HEADER_HEIGHT
		for index, stat in ipairs(group.stats) do
			local row = CreateRow(child, stat, index % 2 == 1)
			row:SetPoint("TOP", 0, -y)
			row.editor, row.y, row.previous = editor, y, previous
			y = y + ROW_HEIGHT
			if previous then previous.next = row end
			previous = row
			editor.Rows[#editor.Rows + 1] = row
		end
		y = y + 4
	end
	child:SetHeight(y)
end

-- The paste box for a Pawn scale: Blizzard's bordered multi-line input, or a plain one.
local function CreatePasteBox(parent)
	local scroll = ns.CreateFrameWithTemplate("ScrollFrame", nil, parent, "InputScrollFrameTemplate")
	local box = scroll.EditBox
	if type(box) == "table" then
		if type(scroll.CharCount) == "table" then scroll.CharCount:Hide() end
	else
		box = CreateFrame("EditBox", nil, scroll)
		box:SetMultiLine(true)
		box:SetAutoFocus(false)
		box:SetFontObject("GameFontHighlightSmall")
		scroll:SetScrollChild(box)
		scroll.Background = scroll:CreateTexture(nil, "BACKGROUND")
		scroll.Background:SetAllPoints()
		scroll.Background:SetColorTexture(0, 0, 0, 0.5)
	end
	-- The template sizes its text to the frame once, when made, before anything has a size: the
	-- text follows the frame's width from then on.
	box:SetWidth(PASTE_WIDTH)
	scroll:HookScript("OnSizeChanged", function(_, width)
		if width and width > 18 then box:SetWidth(width - 18) end
	end)
	return scroll, box
end

local function BuildImport(editor)
	local import = CreateFrame("Frame", nil, editor)
	import:SetPoint("TOPLEFT", editor.Scroll, "TOPLEFT")
	import:SetPoint("BOTTOMRIGHT", editor.Scroll, "BOTTOMRIGHT")
	import:Hide()
	import.Help = import:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	import.Help:SetPoint("TOPLEFT", 4, -4)
	import.Help:SetPoint("TOPRIGHT", -4, -4)
	import.Help:SetJustifyH("LEFT")
	import.Help:SetText(L.WEIGHTS_PAWN_HELP)
	import.Scroll, import.Box = CreatePasteBox(import)
	import.Scroll:SetPoint("TOPLEFT", import.Help, "BOTTOMLEFT", 6, -12)
	import.Scroll:SetPoint("BOTTOMRIGHT", -10, 40)
	import.Box:SetScript("OnEscapePressed", function() editor:ShowList() end)
	import.Import = CreateButton(import, L.WEIGHTS_IMPORT, 90)
	import.Import:SetPoint("BOTTOMLEFT", 6, 6)
	import.Cancel = CreateButton(import, L.WEIGHTS_CANCEL, 90)
	import.Cancel:SetPoint("BOTTOMRIGHT", -6, 6)
	import.Cancel:SetScript("OnClick", function() editor:ShowList() end)
	import.Import:SetScript("OnClick", function()
		local imported, name, unknown, class = ns.ItemScore:ImportPawn(SpecNow(), import.Box:GetText())
		if not imported then
			editor:SetMessage(class and string.format(L.WEIGHTS_OTHER_CLASS, class) or L.WEIGHTS_NOT_PAWN)
			return
		end
		local count = 0
		for _ in pairs(ns.ItemScore:Weights(SpecNow())) do count = count + 1 end
		local message = string.format(L.WEIGHTS_IMPORTED, count, name ~= "" and name or L.WEIGHTS_PAWN)
		if #unknown > 0 then
			-- All of them in chat; the line under the title has room for two lines.
			local unused = string.format(L.WEIGHTS_UNUSED, table.concat(unknown, ", "))
			ns.Print(message .. " " .. unused)
			message = message .. " " .. unused
		end
		import.Box:SetText("")
		editor:ShowList()
		editor:SetMessage(message)
	end)
	editor.Import = import
end

--[[
	Builds an editor on `parent`, which the caller places. `options`:
	  specMenu  a function(parent) that builds the spec menu shown at the top
	  extra     { text, onClick }: one more button under the others ("Open the Gear Finder")
]]
function WeightsEditor:Create(parent, options)
	options = options or {}
	local editor = CreateFrame("Frame", nil, parent)
	editor:SetAllPoints()

	local top = -6
	if options.specMenu then
		editor.SpecLabel = editor:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		editor.Spec = options.specMenu(editor)
		editor.Spec:SetPoint("TOPRIGHT", -14, top - 2)
		editor.SpecLabel:SetPoint("RIGHT", editor.Spec, "LEFT", -6, 0)
		editor.SpecLabel:SetText(L.WEIGHTS_FOR)
		top = top - 32
	end
	editor.Source = editor:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	editor.Source:SetPoint("TOP", 0, top)
	editor.Source:SetWidth(HEADER_WIDTH)
	editor.Message = editor:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	editor.Message:SetPoint("TOP", editor.Source, "BOTTOM", 0, -2)
	editor.Message:SetWidth(HEADER_WIDTH)
	editor.Message:SetMaxLines(2)
	-- A message is about the spec it was written for.
	function editor:SetMessage(text)
		self.Message:SetText(text)
		self.messageSpec = SpecNow()
	end

	-- Buttons along the bottom: Pawn and Reset, and the caller's own under them.
	local bottom = 8
	if options.extra then
		editor.Extra = CreateButton(editor, options.extra.text, HEADER_WIDTH)
		editor.Extra:SetPoint("BOTTOM", 0, bottom)
		editor.Extra:SetScript("OnClick", options.extra.onClick)
		bottom = bottom + BUTTON_HEIGHT + 4
	end
	editor.Pawn = CreateButton(editor, L.WEIGHTS_PAWN, 96)
	editor.Pawn:SetPoint("BOTTOMLEFT", editor, "BOTTOM", -HEADER_WIDTH / 2, bottom)
	Tooltip(editor.Pawn, L.WEIGHTS_PAWN, L.WEIGHTS_PAWN_TIP)
	editor.Pawn:SetScript("OnClick", function() editor:ShowImport() end)
	editor.Reset = CreateButton(editor, L.WEIGHTS_RESET, 96)
	editor.Reset:SetPoint("BOTTOMRIGHT", editor, "BOTTOM", HEADER_WIDTH / 2, bottom)
	Tooltip(editor.Reset, L.WEIGHTS_RESET, L.WEIGHTS_RESET_TIP)
	editor.Reset:SetScript("OnClick", function()
		ns.ItemScore:ResetWeights(SpecNow())
		editor:SetMessage("")
	end)
	bottom = bottom + BUTTON_HEIGHT + 2

	-- Above them, whether items' tooltips show what they are worth (UI/ItemTooltip.lua).
	editor.ShowGains = ns.CreateFrameWithTemplate("CheckButton", nil, editor, "UICheckButtonTemplate")
	editor.ShowGains:SetSize(24, 24)
	editor.ShowGains:SetPoint("BOTTOMLEFT", editor, "BOTTOM", -HEADER_WIDTH / 2 - 2, bottom)
	editor.ShowGains.Label = editor:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	editor.ShowGains.Label:SetPoint("LEFT", editor.ShowGains, "RIGHT", 2, 1)
	editor.ShowGains.Label:SetText(L.WEIGHTS_SHOW_GAINS)
	Tooltip(editor.ShowGains, L.WEIGHTS_SHOW_GAINS, L.WEIGHTS_SHOW_GAINS_TIP)
	editor.ShowGains:SetScript("OnClick", function(self)
		ns.PlaySoundKit(self:GetChecked() and "IG_MAINMENU_OPTION_CHECKBOX_ON" or "IG_MAINMENU_OPTION_CHECKBOX_OFF")
		ns.GearPanel.SetShowsGains(self:GetChecked())
	end)
	bottom = bottom + 24

	-- The list, between the words at the top and the buttons, with the panel's thin bar.
	editor.Scroll = ns.CreateScrollFrame(editor, 5, -5, 5)
	editor.Scroll:SetPoint("TOP", editor.Message, "BOTTOM", -6, -6)
	editor.Scroll:SetPoint("BOTTOM", editor, "BOTTOM", -6, bottom + 6)
	editor.Scroll:SetWidth(HEADER_WIDTH)
	BuildList(editor)
	BuildImport(editor)

	function editor:ShowImport()
		self.Scroll:Hide()
		self.Pawn:Hide()
		self.Reset:Hide()
		self.ShowGains:Hide()
		self.ShowGains.Label:Hide()
		self:SetMessage("")
		self.Import:Show()
		self.Import.Box:SetFocus()
	end
	function editor:ShowList()
		self.Import:Hide()
		self.Import.Box:ClearFocus()
		self.Scroll:Show()
		self.Pawn:Show()
		self.Reset:Show()
		self.ShowGains:Show()
		self.ShowGains.Label:Show()
		self:Refresh()
	end
	function editor:Refresh()
		WeightsEditor:Refresh(self)
	end
	editor:SetScript("OnShow", function(self) self:Refresh() end)
	editors[#editors + 1] = editor
	return editor
end

-- Shows the weights in use: the player's own in green.
function WeightsEditor:Refresh(editor)
	local IS = ns.ItemScore
	local spec = SpecNow()
	local weights, defaults = IS:Weights(spec), IS:DefaultWeights(spec)
	if editor.messageSpec ~= spec then editor.Message:SetText("") end
	for _, row in ipairs(editor.Rows) do
		local weight = weights[row.stat] or 0
		if not row.Value:HasFocus() then
			row.Value:SetText(WeightText(weight))
			row.shownText = row.Value:GetText()
		end
		local own = math.abs(weight - (defaults[row.stat] or 0)) > 1e-9
		if own then
			row.Value:SetTextColor(OWN_COLOR[1], OWN_COLOR[2], OWN_COLOR[3])
		else
			row.Value:SetTextColor(1, 1, 1)
		end
	end
	editor.Source:SetText(SourceText(spec))
	editor.Reset:SetEnabled(IS:CustomWeights(spec) ~= nil)
	editor.ShowGains:SetChecked(ns.GearPanel.ShowsGains())
	local menu = rawget(editor, "Spec")
	if menu then ns.GearPanel.UpdateSpecMenu(menu) end
end

-- Each editor's box, after the setting changed here or in the journal's options.
function WeightsEditor:SyncShowGains()
	for _, editor in ipairs(editors) do editor.ShowGains:SetChecked(ns.GearPanel.ShowsGains()) end
end

-- Every editor showing follows a change of weights, spec, level or talents.
ns.ItemScore:OnChange(function()
	for _, editor in ipairs(editors) do
		if editor:IsVisible() then editor:Refresh() end
	end
end)
