local _, ns = ...
local L = ns.L

--[[
	The search box at the top right, as retail's journal has it.

	Three letters or more list the first five matches under the box: dungeons and raids,
	factions, bosses, their abilities and loot, faction rewards and quests. Up and Down move
	the selection, Enter opens it, and "Show All Results" lists every match in a window of
	its own. A result opens where it lives: the dungeon or faction page, the boss, the
	Abilities tab, the Loot tab with the item brought into view, or the Quests tab with the
	quest chosen.

	The look is retail's own templates rebuilt from the same art (SearchBoxListTemplate and
	the journal's preview and result buttons), because those templates are made in XML with
	settings a frame made in Lua cannot give them. The index is built on the first search,
	once; the full list draws only the rows in view.
]]

local Search = {}
ns.Search = Search

local MIN_CHARACTERS = 3
local PREVIEW_COUNT = 5
local RESULT_HEIGHT, RESULT_ROWS = 49, 8

local SHEET = "Interface\\EncounterJournal\\UI-EncounterJournalTextures"
local TILE = "Interface\\EncounterJournal\\UI-EncounterJournalTextures_Tile"
local BAR_SMALL = { 0, 1, 0.16601563, 0.21875 }                      -- _SearchBarSm
local BAR_LARGE = { 0, 1, 0.74804688, 0.84375 }                      -- _SearchBarLg
local ICON_FRAME = { 0.8984375, 0.97265625, 0.21386719, 0.25097656 } -- UI-Common-SearchIconFrameLg
local HIGHLIGHT_LARGE = { 0.00195313, 0.50195313, 0.8046875, 0.85058594 } -- UI-Common-SearchBarHighlightLg
local ROCK = "Interface\\FrameGeneral\\UI-Background-Rock"
local NAME_COLOR = { 0.96875, 0.8984375, 0.578125 }
local PATH_COLOR = { 0.66796875, 0.51171875, 0.3359375 }
local NO_PORTRAIT = "Interface\\TargetingFrame\\UI-TargetingFrame-Skull"

-- Results of the same match quality list in this order.
local KIND_ORDER = { instance = 1, faction = 2, boss = 3, quest = 4, ability = 5, item = 6 }

------------------------------------------------------------------------------------------
-- The index
------------------------------------------------------------------------------------------

local index
local results = {}

local function Add(entry)
	index[#index + 1] = entry
end

local function BuildIndex()
	index = {}
	for _, kind in ipairs({ "dungeon", "raid" }) do
		for _, instance in ipairs(ns.GetInstances(kind)) do
			Add({ kind = "instance", name = instance.name, instance = instance })
			for _, boss in ipairs(instance.bosses) do
				if not boss.trash then Add({ kind = "boss", name = boss.name, instance = instance, boss = boss }) end
				for _, ability in ipairs(boss.abilities or {}) do
					Add({ kind = "ability", name = ability.name, spellID = ability.spellID, instance = instance, boss = boss })
				end
				for _, extra in ipairs(boss.extraAbilities or {}) do
					Add({ kind = "ability", name = extra.title, icon = extra.icon, instance = instance, boss = boss })
				end
				for _, add in ipairs(boss.adds or {}) do
					for _, ability in ipairs(add.abilities or {}) do
						Add({ kind = "ability", name = ability.name, spellID = ability.spellID, instance = instance, boss = boss })
					end
				end
				for _, row in ipairs(boss.loot or {}) do
					Add({ kind = "item", itemID = row.itemID, row = row, instance = instance, boss = boss })
				end
			end
			for _, quest in ipairs(instance.quests) do
				Add({ kind = "quest", name = quest.name, quest = quest, instance = instance })
			end
		end
	end
	for _, faction in ipairs(ns.GetFactions()) do
		Add({ kind = "faction", name = faction.name, instance = faction })
		for _, standing in ipairs(faction.bosses) do
			for _, row in ipairs(standing.loot or {}) do
				Add({ kind = "item", itemID = row.itemID, row = row, instance = faction, boss = standing })
			end
		end
	end
end

-- An item is found by the name the client has for it, else the data's. Faction rewards come
-- without names, so theirs are asked for once, a few at a time.
local function NameOf(entry)
	if entry.kind == "item" then
		local info = ns.Items:Peek(entry.itemID)
		return info and info.name or entry.row.name
	end
	return entry.name
end

-- An ability is found by the client's name for its spell too, the one its page shows.
local function SpellName(entry)
	if entry.kind ~= "ability" or not entry.spellID or not (C_Spell and C_Spell.GetSpellInfo) then return nil end
	if entry.spellName == nil then
		local ok, info = pcall(C_Spell.GetSpellInfo, entry.spellID)
		entry.spellName = ok and info and type(info.name) == "string" and info.name ~= "" and info.name or false
	end
	return entry.spellName or nil
end

-- How well a name matches: 0 the whole of it, 1 its start, 2 anywhere; nil not at all.
local function Rank(lower, query)
	local at = lower:find(query, 1, true)
	if not at then return nil end
	return (lower == query and 0) or (at == 1 and 1) or 2
end

local warmed = false
local function WarmUp()
	if warmed then return end
	warmed = true
	local missing = {}
	for _, entry in ipairs(index) do
		if entry.kind == "item" and not NameOf(entry) then missing[#missing + 1] = entry end
	end
	local position = 1
	local function Next()
		for _ = 1, 25 do
			local entry = missing[position]
			if not entry then return end
			ns.Items:Get(entry.itemID, entry.row)
			position = position + 1
		end
		C_Timer.After(0.25, Next)
	end
	Next()
end

local function Available(entry)
	if entry.kind == "quest" then return ns.QuestsPanel:IsForPlayer(entry.quest) end
	-- Nothing hidden until confirmed (Core/Items.lua) is found either.
	if entry.kind == "item" then
		return not ns.Items:IsHidden(entry.itemID) and not ns.Items:Superseded(entry.boss, entry.row)
			and not ns.Items:Unremarkable(entry.boss, entry.row)
	end
	if entry.kind == "boss" then return not ns.Items:HidesBoss(entry.boss) end
	return true
end

local function Compare(a, b)
	if a.rank ~= b.rank then return a.rank < b.rank end
	if a.kind ~= b.kind then return KIND_ORDER[a.kind] < KIND_ORDER[b.kind] end
	return a.shownName < b.shownName
end

-- Every match for the text, best first: the whole name, then names that start with it,
-- then the rest; within each, by kind and then name.
function Search:Find(text)
	if not index then
		BuildIndex()
		WarmUp()
	end
	for key in pairs(results) do results[key] = nil end
	local query = text:lower()
	for _, entry in ipairs(index) do
		local name = NameOf(entry)
		if name then
			if entry.lowerOf ~= name then entry.lower, entry.lowerOf = name:lower(), name end
			local rank, shown = Rank(entry.lower, query), name
			local spell = SpellName(entry)
			if spell and spell ~= name then
				entry.spellLower = entry.spellLower or spell:lower()
				local spellRank = Rank(entry.spellLower, query)
				if spellRank and (not rank or spellRank <= rank) then rank, shown = spellRank, spell end
			end
			if rank and Available(entry) then
				entry.rank = rank
				entry.shownName = shown
				results[#results + 1] = entry
			end
		end
	end
	table.sort(results, Compare)
	return results
end

------------------------------------------------------------------------------------------
-- What a result shows and where it leads
------------------------------------------------------------------------------------------

local TYPE_NAMES = {
	boss = L.SEARCH_TYPE_BOSS, ability = L.SEARCH_TYPE_ABILITY, item = L.SEARCH_TYPE_ITEM,
	quest = L.SEARCH_TYPE_QUEST, faction = L.SEARCH_TYPE_FACTION,
}

local function TypeOf(entry)
	if entry.kind == "instance" then
		return entry.instance.kind == "raid" and L.ENTRANCE_RAID or L.ENTRANCE_DUNGEON
	end
	return TYPE_NAMES[entry.kind]
end

local function PathOf(entry)
	local kind = entry.kind
	if kind == "instance" then return TypeOf(entry) end
	if kind == "faction" then return L.TAB_REPUTATION end
	if kind == "boss" or kind == "quest" then return entry.instance.name end
	local source = entry.boss.trash and L.LOOT_TRASH or entry.boss.name
	return source .. ", " .. entry.instance.name
end

local function InstanceIcon(texture, instance)
	if instance.kind == "faction" then
		texture:SetTexture(ns.Reputation:Crest(instance))
		texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	elseif instance.buttonImage then
		texture:SetTexture(instance.buttonImage)
		texture:SetTexCoord(0.156, 0.527, 0, 0.742)
	elseif instance.buttonArt then
		local coords = instance.iconArtCoords or { 0.32, 0.68, 0.15, 0.85 }
		texture:SetTexture(instance.buttonArt)
		texture:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
	else
		texture:SetTexture("Interface\\EncounterJournal\\UI-EJ-PortraitIcon")
	end
end

local function SetIcon(texture, entry)
	texture:SetTexCoord(0, 1, 0, 1)
	local kind = entry.kind
	if kind == "instance" or kind == "faction" then
		InstanceIcon(texture, entry.instance)
	elseif kind == "boss" then
		local drawn = entry.boss.displayID and type(SetPortraitTextureFromCreatureDisplayID) == "function"
			and pcall(SetPortraitTextureFromCreatureDisplayID, texture, entry.boss.displayID)
		if not drawn then texture:SetTexture(NO_PORTRAIT) end
	elseif kind == "ability" then
		local icon = entry.icon
		if not icon and entry.spellID and C_Spell and C_Spell.GetSpellTexture then
			local ok, spellIcon = pcall(C_Spell.GetSpellTexture, entry.spellID)
			icon = ok and spellIcon or nil
		end
		texture:SetTexture(icon or "Interface\\Icons\\INV_Misc_QuestionMark")
	elseif kind == "item" then
		texture:SetTexture(ns.Items:Icon(entry.itemID) or "Interface\\Icons\\INV_Misc_QuestionMark")
	else
		texture:SetAtlas("QuestNormal")
	end
end

local function ShowEntryTooltip(owner, entry)
	if entry.kind == "item" then
		GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
		if ns.Items:IsIdentified(entry.itemID) then
			GameTooltip:SetItemByID(entry.itemID)
		else
			GameTooltip:SetText(NameOf(entry) or "", 1, 1, 1)
			GameTooltip:AddLine(L.LOOT_UNIDENTIFIED_TOOLTIP, 0.6, 0.6, 0.6, true)
		end
		GameTooltip:Show()
	elseif entry.kind == "ability" and entry.spellID and GameTooltip.SetSpellByID then
		GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
		GameTooltip:SetSpellByID(entry.spellID)
		GameTooltip:Show()
	end
end

-- Opens a result where it lives.
function Search:Open(entry)
	local journal = ns.Journal
	local EncounterPage = ns.EncounterPage
	local kind = entry.kind
	self:Close()
	ns.PlaySoundKit("IG_SPELLBOOK_OPEN")
	if kind == "instance" or kind == "faction" then
		journal:OpenInstance(entry.instance)
	elseif kind == "boss" then
		journal:OpenBoss(entry.instance, entry.boss)
	elseif kind == "ability" then
		journal:OpenBoss(entry.instance, entry.boss)
		EncounterPage:SetTab(journal:Page(), EncounterPage.TAB_ABILITIES)
	elseif kind == "quest" then
		ns.QuestsPanel:Open(entry.instance, entry.quest)
	elseif kind == "item" then
		-- Trash drops are listed on the dungeon's own loot page, not a boss's.
		if entry.boss.trash then
			journal:OpenInstance(entry.instance)
		else
			journal:OpenBoss(entry.instance, entry.boss)
		end
		EncounterPage:SetTab(journal:Page(), EncounterPage.TAB_LOOT)
		ns.LootPanel:Reveal(entry.itemID)
	end
end

------------------------------------------------------------------------------------------
-- The preview under the box
------------------------------------------------------------------------------------------

local box, preview, buttons, showAll, window
local selected = 1

local function SetBar(texture, coords)
	texture:SetTexture(TILE, "REPEAT", "CLAMP")
	if texture.SetHorizTile then texture:SetHorizTile(true) end
	texture:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
end

local function Border(parent, template)
	return ns.CreateTextureFromTemplate(parent, "ARTWORK", template)
end

-- Retail's frame round the preview list: two lower corners, the sides and a top edge.
local function CreatePreviewBorder(container)
	local left, right = Border(container, "UI-Frame-BotCornerLeft"), Border(container, "UI-Frame-BotCornerRight")
	if not (left and right) then return end
	left:ClearAllPoints()
	left:SetPoint("LEFT", -7, 0)
	right:ClearAllPoints()
	right:SetPoint("RIGHT", 4, 0)
	container.BotLeftCorner, container.BotRightCorner = left, right
	local bottom = Border(container, "_UI-Frame-Bot")
	if bottom then
		bottom:ClearAllPoints()
		bottom:SetPoint("BOTTOMLEFT", left, "BOTTOMRIGHT")
		bottom:SetPoint("BOTTOMRIGHT", right, "BOTTOMLEFT")
	end
	local leftSide = Border(container, "!UI-Frame-LeftTile")
	if leftSide then
		leftSide:ClearAllPoints()
		leftSide:SetPoint("TOP", 0, 1)
		leftSide:SetPoint("BOTTOMLEFT", left, "TOPLEFT")
	end
	local rightSide = Border(container, "!UI-Frame-RightTile")
	if rightSide then
		rightSide:ClearAllPoints()
		rightSide:SetPoint("TOP", 0, 1)
		rightSide:SetPoint("BOTTOMRIGHT", right, "TOPRIGHT", 1, 0)
	end
	local top = Border(container, "_UI-Frame-Bot")
	if top then
		top:ClearAllPoints()
		top:SetPoint("TOPLEFT", -2, 3)
		top:SetPoint("BOTTOMRIGHT", container, "TOPRIGHT", 2, -3)
	end
end

-- The preview's lower corners sit under the last row shown.
local function FitBorder(last)
	if not (preview.BotLeftCorner and last) then return end
	preview.BotLeftCorner:SetPoint("BOTTOM", last, "BOTTOM", 0, -8)
	preview.BotRightCorner:SetPoint("BOTTOM", last, "BOTTOM", 0, -8)
end

local function CreatePreviewButton(parent, id)
	local button = CreateFrame("Button", nil, parent)
	button:SetHeight(27)
	button:SetID(id)
	button:SetFrameStrata("DIALOG")
	button.Background = button:CreateTexture(nil, "BACKGROUND")
	button.Background:SetAllPoints()
	SetBar(button.Background, BAR_SMALL)
	button.Selected = button:CreateTexture(nil, "OVERLAY", nil, 3)
	button.Selected:SetAtlas("search-highlight")
	button.Selected:SetAllPoints()
	button.Selected:Hide()
	button.IconFrame = button:CreateTexture(nil, "OVERLAY", nil, 2)
	button.IconFrame:SetTexture(SHEET)
	button.IconFrame:SetTexCoord(ICON_FRAME[1], ICON_FRAME[2], ICON_FRAME[3], ICON_FRAME[4])
	button.IconFrame:SetSize(21, 21)
	button.IconFrame:SetPoint("LEFT", 5, 1)
	button.Icon = button:CreateTexture(nil, "OVERLAY")
	button.Icon:SetPoint("TOPLEFT", button.IconFrame, "TOPLEFT", 1, -2)
	button.Icon:SetPoint("BOTTOMRIGHT", button.IconFrame, "BOTTOMRIGHT", -1, 1)
	button.Name = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	button.Name:SetPoint("LEFT", button.Icon, "RIGHT", 5, 0)
	button.Name:SetPoint("RIGHT", -5, 0)
	button.Name:SetJustifyH("LEFT")
	button.Name:SetWordWrap(false)
	button.Name:SetTextColor(NAME_COLOR[1], NAME_COLOR[2], NAME_COLOR[3])
	button:SetScript("OnEnter", function(self)
		Search:Select(self:GetID())
		if self.entry then ShowEntryTooltip(self, self.entry) end
	end)
	button:SetScript("OnLeave", function() GameTooltip:Hide() end)
	button:SetScript("OnClick", function(self) Search:Open(self.entry) end)
	return button
end

local function CreateShowAll(parent, id)
	local button = CreateFrame("Button", nil, parent)
	button:SetHeight(24)
	button:SetID(id)
	button:SetFrameStrata("DIALOG")
	button.Background = button:CreateTexture(nil, "BACKGROUND")
	button.Background:SetAllPoints()
	SetBar(button.Background, BAR_SMALL)
	button.Selected = button:CreateTexture(nil, "OVERLAY", nil, 2)
	button.Selected:SetAtlas("search-highlight")
	button.Selected:SetAllPoints()
	button.Selected:Hide()
	button.Text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	button.Text:SetPoint("CENTER")
	button:SetScript("OnEnter", function(self) Search:Select(self:GetID()) end)
	button:SetScript("OnClick", function() Search:ShowAll() end)
	return button
end

-- Whether the mouse is over the preview, which keeps the box's focus while it is clicked.
local function MouseOverPreview()
	if not preview:IsShown() then return false end
	for _, button in ipairs(buttons) do
		if button:IsShown() and button:IsMouseOver() then return true end
	end
	return showAll:IsShown() and showAll:IsMouseOver() or false
end

-- How many results the preview shows; "Show All" comes after them when it is there.
local function ShownCount()
	local count = 0
	for _, button in ipairs(buttons) do
		if button:IsShown() then count = count + 1 end
	end
	return count
end

-- Selects a position in the preview: the results 1 to n, then "Show All" as n + 1.
-- Up from the first wraps to the last, down from the last to the first.
function Search:Select(position)
	for _, button in ipairs(buttons) do button.Selected:Hide() end
	showAll.Selected:Hide()
	local count = ShownCount()
	local total = count + (showAll:IsShown() and 1 or 0)
	if total == 0 then
		selected = 1
		return
	end
	if position < 1 then position = total elseif position > total then position = 1 end
	selected = position
	if position > count then showAll.Selected:Show() else buttons[position].Selected:Show() end
end

function Search:HidePreview()
	if preview then preview:Hide() end
end

-- Closes the preview and the full list, and lets go of the keyboard.
function Search:Close()
	self:HidePreview()
	if window then window:Hide() end
	if box then box:ClearFocus() end
end

function Search:Update()
	local text = box:GetText() or ""
	if #text < MIN_CHARACTERS then
		self:HidePreview()
		return
	end
	local found = self:Find(text)
	local last
	for id, button in ipairs(buttons) do
		local entry = found[id]
		button.entry = entry
		if entry then
			SetIcon(button.Icon, entry)
			button.Name:SetText(entry.shownName)
			button:Show()
			last = button
		else
			button:Hide()
		end
	end
	if #found > PREVIEW_COUNT then
		showAll.Text:SetText(string.format(L.SEARCH_SHOW_ALL, #found))
		showAll:Show()
		last = showAll
	else
		showAll:Hide()
	end
	if not last then
		self:HidePreview()
		return
	end
	FitBorder(last)
	preview:Show()
	self:Select(1)
end

function Search:OpenSelected()
	if not (preview and preview:IsShown()) then
		box:ClearFocus()
		return
	end
	if selected > ShownCount() then
		if showAll:IsShown() then self:ShowAll() end
	else
		local button = buttons[selected]
		if button and button.entry then self:Open(button.entry) end
	end
end

------------------------------------------------------------------------------------------
-- Every result: a window over the journal
------------------------------------------------------------------------------------------

local function CreateResultRow(parent)
	local row = CreateFrame("Button", nil, parent)
	row:SetHeight(RESULT_HEIGHT)
	row.Background = row:CreateTexture(nil, "BACKGROUND")
	row.Background:SetAllPoints()
	row.Background:SetTexture(TILE, "REPEAT", "CLAMP")
	if row.Background.SetHorizTile then row.Background:SetHorizTile(true) end
	row.Background:SetTexCoord(BAR_LARGE[1], BAR_LARGE[2], BAR_LARGE[3], BAR_LARGE[4])
	row:SetHighlightTexture(SHEET, "ADD")
	local highlight = row:GetHighlightTexture()
	if highlight then highlight:SetTexCoord(HIGHLIGHT_LARGE[1], HIGHLIGHT_LARGE[2], HIGHLIGHT_LARGE[3], HIGHLIGHT_LARGE[4]) end
	row.IconFrame = row:CreateTexture(nil, "OVERLAY", nil, 2)
	row.IconFrame:SetTexture(SHEET)
	row.IconFrame:SetTexCoord(ICON_FRAME[1], ICON_FRAME[2], ICON_FRAME[3], ICON_FRAME[4])
	row.IconFrame:SetSize(38, 38)
	row.IconFrame:SetPoint("LEFT", 10, 0)
	row.Icon = row:CreateTexture(nil, "OVERLAY")
	row.Icon:SetPoint("TOPLEFT", row.IconFrame, "TOPLEFT", 1, -2)
	row.Icon:SetPoint("BOTTOMRIGHT", row.IconFrame, "BOTTOMRIGHT", -1, 1)
	row.Name = row:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	row.Name:SetSize(400, 12)
	row.Name:SetPoint("TOPLEFT", row.IconFrame, "TOPRIGHT", 10, -2)
	row.Name:SetJustifyH("LEFT")
	row.Name:SetTextColor(NAME_COLOR[1], NAME_COLOR[2], NAME_COLOR[3])
	row.Path = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	row.Path:SetWidth(380)
	row.Path:SetPoint("TOPLEFT", row.Name, "BOTTOMLEFT", 0, -7)
	row.Path:SetJustifyH("LEFT")
	row.Path:SetTextColor(PATH_COLOR[1], PATH_COLOR[2], PATH_COLOR[3])
	row.Type = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	row.Type:SetWidth(140)
	row.Type:SetPoint("RIGHT", -14, 0)
	row.Type:SetJustifyH("RIGHT")
	row.Type:SetTextColor(PATH_COLOR[1], PATH_COLOR[2], PATH_COLOR[3])
	row:SetScript("OnEnter", function(self) if self.entry then ShowEntryTooltip(self, self.entry) end end)
	row:SetScript("OnLeave", function() GameTooltip:Hide() end)
	row:SetScript("OnClick", function(self) Search:Open(self.entry) end)
	return row
end

-- Draws only the rows in view; scrolling moves them down the list.
local function DrawWindowRows()
	local scroll = window.Scroll
	local first = math.floor((scroll:GetVerticalScroll() or 0) / RESULT_HEIGHT) + 1
	for slot, row in ipairs(window.Rows) do
		local position = first + slot - 1
		local entry = results[position]
		row.entry = entry
		if entry then
			row:ClearAllPoints()
			row:SetPoint("TOPLEFT", 0, -(position - 1) * RESULT_HEIGHT)
			row:SetPoint("RIGHT", scroll.Child, "RIGHT")
			SetIcon(row.Icon, entry)
			row.Name:SetText(entry.shownName)
			row.Path:SetText(PathOf(entry))
			row.Type:SetText(TypeOf(entry))
			row:Show()
		else
			row:Hide()
		end
	end
end

-- Retail's frame round its full results window (BottomPopupScrollBoxTemplate): four corners
-- and the edges between them.
local function CreateWindowBorder(frame)
	local function Piece(template, point, x, y)
		local texture = ns.CreateTextureFromTemplate(frame, "BORDER", template)
		if texture then
			texture:ClearAllPoints()
			texture:SetPoint(point, x, y)
		end
		return texture
	end
	local topLeft = Piece("UI-Frame-TopCornerLeft", "TOPLEFT", -7, 4)
	local topRight = Piece("UI-Frame-TopCornerRightSimple", "TOPRIGHT", 4, 4)
	local bottomLeft = Piece("UI-Frame-BotCornerLeft", "BOTTOMLEFT", -7, -5)
	local bottomRight = Piece("UI-Frame-BotCornerRight", "BOTTOMRIGHT", 4, -5)
	if not (topLeft and topRight and bottomLeft and bottomRight) then return end
	local top = ns.CreateTextureFromTemplate(frame, "BORDER", "_UI-Frame-Top")
	if top then
		top:ClearAllPoints()
		top:SetPoint("TOPLEFT", topLeft, "TOPRIGHT")
		top:SetPoint("TOPRIGHT", topRight, "TOPLEFT")
	end
	local bottom = ns.CreateTextureFromTemplate(frame, "BORDER", "_UI-Frame-Bot")
	if bottom then
		bottom:ClearAllPoints()
		bottom:SetPoint("BOTTOMLEFT", bottomLeft, "BOTTOMRIGHT")
		bottom:SetPoint("BOTTOMRIGHT", bottomRight, "BOTTOMLEFT")
	end
	local left = ns.CreateTextureFromTemplate(frame, "BORDER", "!UI-Frame-LeftTile")
	if left then
		left:ClearAllPoints()
		left:SetPoint("TOPLEFT", topLeft, "BOTTOMLEFT")
		left:SetPoint("BOTTOMLEFT", bottomLeft, "TOPLEFT")
	end
	local right = ns.CreateTextureFromTemplate(frame, "BORDER", "!UI-Frame-RightTile")
	if right then
		right:ClearAllPoints()
		right:SetPoint("TOPRIGHT", topRight, "BOTTOMRIGHT", 1, 0)
		right:SetPoint("BOTTOMRIGHT", bottomRight, "TOPRIGHT", 1, 0)
	end
end

local function CreateWindow(journal)
	window = CreateFrame("Frame", nil, journal)
	window:SetFrameStrata("DIALOG")
	window:SetSize(600, 400)
	window:SetPoint("BOTTOM", 0, 7)
	window:EnableMouse(true)
	window.Background = window:CreateTexture(nil, "BACKGROUND")
	window.Background:SetAllPoints()
	window.Background:SetTexture(ROCK, "REPEAT", "REPEAT")
	if window.Background.SetHorizTile then
		window.Background:SetHorizTile(true)
		window.Background:SetVertTile(true)
	end
	window.Background:SetVertexColor(0.9, 0.8, 0.7)
	CreateWindowBorder(window)
	window.Title = window:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	window.Title:SetPoint("TOP", 0, -7)
	local close = ns.CreateFrameWithTemplate("Button", nil, window, "UIPanelCloseButton")
	close:SetSize(24, 24)
	close:SetPoint("TOPRIGHT", 2, 1)
	close:SetScript("OnClick", function() window:Hide() end)

	local scroll = ns.CreateScrollFrame(window, 6, -14, 14)
	scroll:SetPoint("TOPLEFT", 12, -28)
	scroll:SetPoint("BOTTOMRIGHT", -30, 10)
	scroll.Child:SetWidth(555)
	scroll:HookScript("OnVerticalScroll", DrawWindowRows)
	window.Scroll = scroll
	window.Rows = {}
	for slot = 1, RESULT_ROWS do window.Rows[slot] = CreateResultRow(scroll.Child) end
	window:Hide()
end

function Search:ShowAll()
	self:HidePreview()
	if not window then CreateWindow(self.journal) end
	window.Title:SetText(string.format(L.SEARCH_RESULTS, box:GetText() or "", #results))
	window.Scroll.Child:SetHeight(math.max(1, #results * RESULT_HEIGHT))
	window.Scroll:SetVerticalScroll(0)
	DrawWindowRows()
	window:Show()
	box:ClearFocus()
end

-- The preview and the full list's window, for the smoke test.
function Search:Window()
	return window
end

function Search:Preview()
	return preview, buttons, showAll
end

------------------------------------------------------------------------------------------
-- The box
------------------------------------------------------------------------------------------

function Search:Attach(searchBox, journal)
	box, self.journal = searchBox, journal
	preview = CreateFrame("Frame", nil, searchBox)
	preview:SetFrameStrata("DIALOG")
	preview:SetPoint("TOPLEFT", searchBox, "BOTTOMLEFT")
	preview:SetPoint("TOPRIGHT", searchBox, "BOTTOMRIGHT")
	preview:SetHeight(24)
	CreatePreviewBorder(preview)
	buttons = {}
	local previous
	for id = 1, PREVIEW_COUNT do
		local button = CreatePreviewButton(preview, id)
		if previous then
			button:SetPoint("TOPLEFT", previous, "BOTTOMLEFT")
			button:SetPoint("TOPRIGHT", previous, "BOTTOMRIGHT")
		else
			button:SetPoint("TOPLEFT", preview, "TOPLEFT")
			button:SetPoint("TOPRIGHT", preview, "TOPRIGHT")
		end
		buttons[id] = button
		previous = button
	end
	showAll = CreateShowAll(preview, PREVIEW_COUNT + 1)
	showAll:SetPoint("TOPLEFT", previous, "BOTTOMLEFT")
	showAll:SetPoint("TOPRIGHT", previous, "BOTTOMRIGHT")
	preview:Hide()

	searchBox:HookScript("OnTextChanged", function() Search:Update() end)
	searchBox:HookScript("OnEditFocusGained", function()
		-- Typing again starts a new search: the old full list goes, as on retail.
		if window then window:Hide() end
		Search:Update()
	end)
	searchBox:HookScript("OnEditFocusLost", function()
		if not MouseOverPreview() then Search:HidePreview() end
	end)
	searchBox:SetScript("OnEnterPressed", function() Search:OpenSelected() end)
	searchBox:HookScript("OnArrowPressed", function(_, key)
		if key == "UP" then Search:Select(selected - 1) elseif key == "DOWN" then Search:Select(selected + 1) end
	end)
	-- The client asks this before taking focus away on a click: clicking a result keeps it.
	searchBox.HasStickyFocus = MouseOverPreview
	journal:HookScript("OnHide", function() Search:Close() end)
end
