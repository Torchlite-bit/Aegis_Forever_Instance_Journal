local _, ns = ...
local L = ns.L

--[[
	The grid of dungeon (or raid) buttons on a list tab, and the level dropdown above it.
	Button measurements and art are retail's EncounterInstanceButtonTemplate, rebuilt from
	the client's own journal texture sheet because that template does not load on Forever.
]]

local InstanceSelect = {}
ns.InstanceSelect = InstanceSelect

local BUTTON_WIDTH, BUTTON_HEIGHT = 174, 96
local COLUMNS = 4
local SPACING_X, SPACING_Y = 15, 15
local GRID_LEFT, GRID_TOP = 17, 62

-- Loading screens are wide; this keeps the middle at the button's shape.
local DEFAULT_ART_COORDS = { 0.16, 0.84, 0.15, 0.85 }
local FALLBACK_ART = "Interface\\EncounterJournal\\UI-EJ-LOREBG-Default"

local panels = {}

local function SelectedBracket()
	return ns.LEVEL_BRACKETS[ns.charDB.levelBracket or 1] or ns.LEVEL_BRACKETS[1]
end

------------------------------------------------------------------------------------------
-- Buttons
------------------------------------------------------------------------------------------

-- Retail's EncounterInstanceButtonTemplate.
local function CreateInstanceButton(parent)
	local button = CreateFrame("Button", nil, parent)
	button:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)

	button.Art = button:CreateTexture(nil, "BACKGROUND")
	button.Art:SetAllPoints()
	ns.SetButtonArt(button, "DungeonButton-Up", "DungeonButton-Down", "DungeonButton-Highlight")

	button.Name = button:CreateFontString(nil, "OVERLAY", "QuestTitleFontBlackShadow")
	button.Name:SetSize(150, 0)
	button.Name:SetPoint("TOP", 0, -15)
	button.Name:SetJustifyH("CENTER")

	button.Range = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	button.Range:SetSize(100, 12)
	button.Range:SetPoint("BOTTOMLEFT", 7, 7)
	button.Range:SetJustifyH("LEFT")

	-- A dungeon the journal has no tested data for yet.
	button.Untested = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	button.Untested:SetPoint("BOTTOMRIGHT", -7, 7)
	button.Untested:SetJustifyH("RIGHT")
	button.Untested:SetText(L.UNTESTED)
	button.Untested:SetTextColor(0.75, 0.75, 0.75)

	-- What is new in WoW: Forever, called out as retail calls out something new.
	button.Forever = ns.CreateForeverMark(button)
	button.Forever:SetPoint("BOTTOMRIGHT", -9, 8)

	button:SetScript("OnClick", function(self)
		ns.PlaySoundKit("IG_SPELLBOOK_OPEN")
		ns.Journal:OpenInstance(self.instance)
	end)
	return button
end

local function SetButtonInstance(button, instance)
	button.instance = instance
	button.Name:SetText(instance.name)
	button.Untested:SetShown(instance.untested == true)
	button.Forever:SetShown(instance.forever == true)
	-- Both: the note goes above the mark.
	button.Untested:ClearAllPoints()
	button.Untested:SetPoint("BOTTOMRIGHT", -7, instance.forever and 26 or 7)

	if instance.buttonImage then
		-- Blizzard's own button picture, cut as EncounterInstanceButtonTemplate cuts it.
		button.Art:SetTexture(instance.buttonImage)
		button.Art:SetTexCoord(0, 0.68359375, 0, 0.7421875)
	else
		local coords = instance.buttonArtCoords or DEFAULT_ART_COORDS
		button.Art:SetTexture(instance.buttonArt or FALLBACK_ART)
		button.Art:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
	end

	if instance.levelMin and instance.levelMax and instance.levelMin ~= instance.levelMax then
		button.Range:SetText(instance.levelMin .. "-" .. instance.levelMax)
	else
		button.Range:SetText(instance.levelMin or "")
	end
end

------------------------------------------------------------------------------------------
-- Level dropdown
------------------------------------------------------------------------------------------

local function SelectBracket(index)
	ns.charDB.levelBracket = index
	InstanceSelect:RefreshAll()
end

local function CreateBracketDropdown(panel)
	if ns.HasTemplate("WowStyle1DropdownTemplate") then
		local ok, dropdown = pcall(CreateFrame, "DropdownButton", nil, panel, "WowStyle1DropdownTemplate")
		if ok and dropdown and dropdown.SetupMenu then
			dropdown:SetWidth(155)
			dropdown:SetPoint("TOPRIGHT", -25, -16)
			dropdown:SetupMenu(function(_, rootDescription)
				for index, bracket in ipairs(ns.LEVEL_BRACKETS) do
					rootDescription:CreateRadio(bracket.text,
						function() return (ns.charDB.levelBracket or 1) == index end,
						function() SelectBracket(index) end)
				end
			end)
			return dropdown
		end
	end

	-- Older menu system, for a client without the modern dropdown.
	local dropdown = CreateFrame("Frame", nil, panel, "UIDropDownMenuTemplate")
	dropdown:SetPoint("TOPRIGHT", -10, -12)
	UIDropDownMenu_SetWidth(dropdown, 140)
	UIDropDownMenu_Initialize(dropdown, function()
		for index, bracket in ipairs(ns.LEVEL_BRACKETS) do
			local info = UIDropDownMenu_CreateInfo()
			info.text = bracket.text
			info.checked = (ns.charDB.levelBracket or 1) == index
			info.func = function() SelectBracket(index) end
			UIDropDownMenu_AddButton(info)
		end
	end)
	dropdown.legacy = true
	return dropdown
end

------------------------------------------------------------------------------------------
-- Grid
------------------------------------------------------------------------------------------

--[[
	The bar sits in the darker strip the backdrop art leaves down its right side: retail puts
	it 774 from the list's left (ScrollBox at 14, 748 wide, bar 12 beyond). This grid's frame
	ends at 768, so 6 beyond it lands on the same spot.
]]
ns.GRID_SCROLLBAR_X = 6

local function CreateScroll(panel)
	local scroll = ns.CreateScrollFrame(panel, ns.GRID_SCROLLBAR_X, -6, 4)
	scroll:SetPoint("TOPLEFT", GRID_LEFT, -GRID_TOP)
	scroll:SetPoint("BOTTOMRIGHT", -24, 6)
	scroll.Child:SetSize(COLUMNS * BUTTON_WIDTH + (COLUMNS - 1) * SPACING_X, 1)
	return scroll
end

function InstanceSelect:Build(panel, kind)
	panel.kind = kind
	panel.Buttons = {}
	panel.Scroll = CreateScroll(panel)
	panel.Dropdown = CreateBracketDropdown(panel)
	panels[#panels + 1] = panel
	self:Refresh(panel)
end

function InstanceSelect:Refresh(panel)
	local bracket = SelectedBracket()
	local list = ns.GetInstances(panel.kind, bracket)
	local child = panel.Scroll.Child

	for index, instance in ipairs(list) do
		local button = panel.Buttons[index]
		if not button then
			button = CreateInstanceButton(child)
			panel.Buttons[index] = button
		end
		local column = (index - 1) % COLUMNS
		local row = math.floor((index - 1) / COLUMNS)
		button:ClearAllPoints()
		button:SetPoint("TOPLEFT", column * (BUTTON_WIDTH + SPACING_X), -row * (BUTTON_HEIGHT + SPACING_Y))
		SetButtonInstance(button, instance)
		button:Show()
	end
	for index = #list + 1, #panel.Buttons do
		panel.Buttons[index]:Hide()
	end

	local rows = math.ceil(#list / COLUMNS)
	child:SetHeight(math.max(1, rows * (BUTTON_HEIGHT + SPACING_Y) - SPACING_Y))
	panel.Scroll:SetVerticalScroll(0)

	if #list == 0 then
		local anything = #ns.GetInstances(panel.kind, nil) > 0
		panel.Empty:SetText(anything and L.EMPTY_BRACKET or panel.emptyText)
		panel.Empty:Show()
	else
		panel.Empty:Hide()
	end

	if panel.Dropdown.legacy then
		UIDropDownMenu_SetText(panel.Dropdown, bracket.text)
	elseif panel.Dropdown.GenerateMenu then
		panel.Dropdown:GenerateMenu()
	end
end

function InstanceSelect:RefreshAll()
	for _, panel in ipairs(panels) do self:Refresh(panel) end
end
