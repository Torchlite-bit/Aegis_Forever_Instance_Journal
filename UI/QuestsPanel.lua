local _, ns = ...
local L = ns.L

--[[
	The Quests tab. Retail's journal has none, so this follows the classic instance journals:
	the quest list takes the left page (instead of the boss list) and the chosen quest fills
	the right page, laid out like the classic quest frame: title, objective, Show Start and
	Show End, then Rewards.

	Status comes from the player's own quest log and history: done, in the log, ready to hand
	in, available, or not yet available. A "+" opens a quest's chain beneath it. Quests
	recorded on the Record tab add their full text, their exact rewards and where they end.

	The list is in dropdowns, under the Abilities tab's paper headers: a dungeon's key first, as
	Before you go has it (the Dalaran Sewer Key: the quests to it, for the player's side), then
	Dungeon Quests, the rest. Each header shows the mark of its first quest still to do and how
	many of its quests are done. A key is open until the player has it; Dungeon Quests, always.
]]

local QuestsPanel = {}
ns.QuestsPanel = QuestsPanel

local ROW_HEIGHT, INDENT, LIST_WIDTH, DETAIL_WIDTH = 26, 18, 320, 315
-- The dropdowns: room above the first, as the boss list has; their quests set in a little.
local TOP_PADDING, HEADER_GAP, ROW_INDENT = 6, 6, 8
-- An open dropdown's quests sit in a box, as an ability's text sits under its header: the room
-- above and below them in it, and how far its top tucks under the header.
local BOX_PADDING, BOX_TUCK, BOX_SIDE = 6, 3, 1
local REWARD_BOX_WIDTH, REWARD_BOX_HEIGHT = 147, 41

local STATUS_DONE, STATUS_READY, STATUS_ACTIVE, STATUS_AVAILABLE, STATUS_LOCKED =
	"done", "ready", "active", "available", "locked"

-- The classic instance journals' colours: black headings, dark brown text on the parchment,
-- yellow quests in the list and green ones once done.
local TITLE_COLOR = { 0, 0, 0 }
local BODY_COLOR = { 0.13, 0.04, 0 }
local REPUTATION_COLOR = { 0.1, 0.5, 0.1 }
local GREEN = "|cff1e7d00"
local ROW_COLOR = { 1, 1, 0 }
local ROW_DONE_COLOR = { 0.1, 1, 0.1 }
local ROW_CHOSEN_COLOR = { 1, 1, 1 }
local DONE_ICON = "Interface\\Buttons\\UI-CheckBox-Check"

-- The classic quest log's row highlight: brightest in the middle, tinted like the row.
local ROW_HIGHLIGHT = "Interface\\QuestFrame\\UI-QuestLogTitleHighlight"
local ROW_HIGHLIGHT_FALLBACK = "Interface\\QuestFrame\\UI-QuestTitleHighlight"
local HIGHLIGHT_ALPHA_CHOSEN, HIGHLIGHT_ALPHA_HOVER = 0.45, 0.25

------------------------------------------------------------------------------------------
-- Status
------------------------------------------------------------------------------------------

local function QuestCall(name, questID)
	local fn = C_QuestLog and C_QuestLog[name]
	if type(fn) ~= "function" or not questID then return nil end
	local ok, value = pcall(fn, questID)
	return ok and value or nil
end

local function IsDone(questID) return QuestCall("IsQuestFlaggedCompleted", questID) == true end

local function InLog(questID)
	local index = QuestCall("GetLogIndexForQuestID", questID)
	return index ~= nil and index ~= 0
end

local function PlayerLevel()
	local ok, level = pcall(UnitLevel, "player")
	return ok and level or 0
end

function QuestsPanel:Status(quest)
	-- A chain of same-named steps, shown as one row.
	if quest.steps then
		local done, started = 0, false
		for _, step in ipairs(quest.steps) do
			if IsDone(step.questID) then done = done + 1 end
			if InLog(step.questID) then started = true end
		end
		if done == #quest.steps then return STATUS_DONE end
		return (started or done > 0) and STATUS_ACTIVE or STATUS_AVAILABLE
	end

	if IsDone(quest.questID) then return STATUS_DONE end
	if InLog(quest.questID) then
		return QuestCall("IsComplete", quest.questID) and STATUS_READY or STATUS_ACTIVE
	end
	for _, prerequisite in ipairs(quest.prerequisites or {}) do
		if not IsDone(prerequisite.questID) then return STATUS_LOCKED end
	end
	if quest.requiredLevel and PlayerLevel() < quest.requiredLevel then return STATUS_LOCKED end
	return STATUS_AVAILABLE
end

-- Why a quest cannot be taken yet: the first step of its chain still to do, else the level it needs.
function QuestsPanel:LockedReason(quest)
	for _, prerequisite in ipairs(quest.prerequisites or {}) do
		if not IsDone(prerequisite.questID) then return string.format(L.QUEST_STATUS_NEEDS, prerequisite.name or "?") end
	end
	return string.format(L.QUEST_STATUS_LEVEL, quest.requiredLevel or 0)
end

local function SetStatusIcon(texture, status)
	texture:SetVertexColor(1, 1, 1)
	texture:SetDesaturated(false)
	texture:SetTexCoord(0, 1, 0, 1)
	if status == STATUS_DONE then
		texture:SetTexture(DONE_ICON)
	elseif status == STATUS_READY or status == STATUS_ACTIVE then
		texture:SetAtlas("QuestTurnin")
		if status == STATUS_ACTIVE then
			texture:SetDesaturated(true)
			texture:SetVertexColor(0.85, 0.85, 0.85)
		end
	else
		texture:SetAtlas("QuestNormal")
		if status == STATUS_LOCKED then
			texture:SetDesaturated(true)
			texture:SetVertexColor(0.85, 0.85, 0.85)
		end
	end
end

-- The quests this character can take: their faction's and class's, and those open to all.
function QuestsPanel:IsForPlayer(quest)
	local _, faction = pcall(UnitFactionGroup, "player")
	local _, _, classFile = pcall(UnitClass, "player")
	local factionOK = not quest.faction or quest.faction == "Both" or not faction or quest.faction == faction
	local classOK = not quest.classOnly or not classFile or quest.classOnly == classFile
	return factionOK and classOK
end

local function QuestsFor(instance)
	local list = {}
	for _, quest in ipairs(instance.quests or {}) do
		if QuestsPanel:IsForPlayer(quest) then list[#list + 1] = quest end
	end
	return list
end

local function Recorded(questID)
	local state = ns.Recorder and ns.Recorder:GetState()
	return state and state.quests and questID and state.quests[questID] or nil
end

------------------------------------------------------------------------------------------
-- Left page: the list
------------------------------------------------------------------------------------------

local highlightFile

local function HighlightFile()
	if not highlightFile then
		highlightFile = ns.FileExists(ROW_HIGHLIGHT) and ROW_HIGHLIGHT or ROW_HIGHLIGHT_FALLBACK
	end
	return highlightFile
end

-- The chosen row and the one under the mouse light up, their text turning white.
local function UpdateRowHighlight(row)
	local lit = row.selected or row.hovered
	row.Highlight:SetShown(lit)
	if lit then row.Highlight:SetAlpha(row.selected and HIGHLIGHT_ALPHA_CHOSEN or HIGHLIGHT_ALPHA_HOVER) end
	local color = lit and ROW_CHOSEN_COLOR or row.color or ROW_COLOR
	row.Text:SetTextColor(color[1], color[2], color[3])
end

-- onClick: what a click on the row does with it (else it is chosen on the Quests tab).
local function CreateRow(parent, onClick)
	local row = CreateFrame("Button", nil, parent)
	row:SetHeight(ROW_HEIGHT)

	row.Highlight = row:CreateTexture(nil, "BACKGROUND")
	row.Highlight:SetTexture(HighlightFile())
	row.Highlight:SetBlendMode("ADD")
	row.Highlight:SetPoint("TOPLEFT", 0, -1)
	row.Highlight:SetPoint("BOTTOMRIGHT", 0, 1)
	row.Highlight:Hide()

	row.Expand = CreateFrame("Button", nil, row)
	row.Expand:SetSize(16, 16)
	row.Expand:SetPoint("LEFT", 0, 0)
	row.Expand:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight", "ADD")
	row.Expand:SetScript("OnClick", function()
		ns.PlaySoundKit("IG_MAINMENU_OPTION_CHECKBOX_ON")
		QuestsPanel:ToggleChain(row.quest)
	end)

	row.Status = row:CreateTexture(nil, "OVERLAY")
	row.Status:SetSize(16, 16)
	row.Status:SetPoint("LEFT", row.Expand, "RIGHT", 4, 0)

	row.Text = row:CreateFontString(nil, "OVERLAY", ns.Font("GameFontNormalMed3", "GameFontNormal"))
	row.Text:SetPoint("LEFT", row.Status, "RIGHT", 4, 0)
	row.Text:SetPoint("RIGHT", -4, 0)
	row.Text:SetJustifyH("LEFT")
	row.Text:SetWordWrap(false)

	row:SetScript("OnEnter", function(self)
		self.hovered = true
		UpdateRowHighlight(self)
	end)
	row:SetScript("OnLeave", function(self)
		self.hovered = false
		UpdateRowHighlight(self)
	end)
	row:SetScript("OnClick", function(self)
		ns.PlaySoundKit("IG_QUEST_LIST_SELECT")
		if onClick then onClick(self) else QuestsPanel:Select(self.quest) end
	end)
	return row
end

local function SetRow(row, quest, depth, hasChain, expanded, selected)
	row.quest = quest
	row:ClearAllPoints()
	row:SetWidth(LIST_WIDTH - depth * INDENT)

	row.Expand:SetShown(hasChain)
	if hasChain then
		row.Expand:SetNormalTexture(expanded and "Interface\\Buttons\\UI-MinusButton-Up" or "Interface\\Buttons\\UI-PlusButton-Up")
	end

	local status = QuestsPanel:Status(quest)
	SetStatusIcon(row.Status, status)
	local level = quest.level and ("[" .. quest.level .. "] ") or ""
	row.Text:SetText(level .. (quest.name or ""))
	row.color = status == STATUS_DONE and ROW_DONE_COLOR or ROW_COLOR
	row.Highlight:SetVertexColor(row.color[1], row.color[2], row.color[3])

	row.selected = selected
	UpdateRowHighlight(row)
end

-- The list's rows and marks, for other pages that list quests the same way (Before you go).
QuestsPanel.CreateRow, QuestsPanel.SetRow, QuestsPanel.SetStatusIcon = CreateRow, SetRow, SetStatusIcon
QuestsPanel.STATUS_DONE, QuestsPanel.STATUS_LOCKED = STATUS_DONE, STATUS_LOCKED

------------------------------------------------------------------------------------------
-- Right page: the quest
------------------------------------------------------------------------------------------

local function Text(parent, font, color)
	local text = parent:CreateFontString(nil, "ARTWORK", font or "GameFontBlack")
	text:SetWidth(DETAIL_WIDTH)
	text:SetJustifyH("LEFT")
	color = color or BODY_COLOR
	text:SetTextColor(color[1], color[2], color[3])
	return text
end

-- Classic QuestItemTemplate: the icon, then the item's name, in its quality's colour, on a
-- dark strip.
local function CreateRewardBox(parent)
	local box = CreateFrame("Button", nil, parent)
	box:SetSize(REWARD_BOX_WIDTH, REWARD_BOX_HEIGHT)
	box.Icon = box:CreateTexture(nil, "BORDER")
	box.Icon:SetSize(39, 39)
	box.Icon:SetPoint("TOPLEFT")
	box.NameFrame = box:CreateTexture(nil, "BACKGROUND")
	box.NameFrame:SetTexture("Interface\\QuestFrame\\UI-QuestItemNameFrame")
	box.NameFrame:SetSize(128, 64)
	box.NameFrame:SetPoint("LEFT", box.Icon, "RIGHT", -10, 0)
	box.Name = box:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	box.Name:SetSize(90, 36)
	box.Name:SetPoint("LEFT", box.NameFrame, "LEFT", 15, 0)
	box.Name:SetJustifyH("LEFT")
	-- How many, as the quest frame shows it on the icon.
	box.Count = box:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
	box.Count:SetPoint("BOTTOMRIGHT", box.Icon, -3, 3)
	box:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		if ns.Items:IsIdentified(self.itemID) then
			GameTooltip:SetItemByID(self.itemID)
		else
			GameTooltip:SetText(self.Name:GetText() or "", 1, 1, 1)
			GameTooltip:AddLine(L.LOOT_UNIDENTIFIED_TOOLTIP, 0.6, 0.6, 0.6, true)
		end
		GameTooltip:Show()
	end)
	box:SetScript("OnLeave", function() GameTooltip:Hide() end)
	box:SetScript("OnClick", function(self)
		local info = ns.Items:Get(self.itemID)
		if info.link and type(HandleModifiedItemClick) == "function" then HandleModifiedItemClick(info.link) end
	end)
	return box
end

local MoneyText = ns.MoneyText

local function Number(value)
	if type(BreakUpLargeNumbers) == "function" then
		local ok, text = pcall(BreakUpLargeNumbers, value)
		if ok and text then return text end
	end
	return tostring(value)
end

-- Said only when it adds something the list's icon does not: what is still needed, or that
-- the quest can be handed in.
local function StatusNote(quest, status)
	if status == STATUS_READY then return GREEN .. L.QUEST_STATUS_READY .. "|r" end
	if status ~= STATUS_LOCKED then return nil end
	for _, prerequisite in ipairs(quest.prerequisites or {}) do
		if not IsDone(prerequisite.questID) then
			return "|cff8a2a1a" .. string.format(L.QUEST_STATUS_NEEDS, prerequisite.name or "?") .. "|r"
		end
	end
	return "|cff8a2a1a" .. string.format(L.QUEST_STATUS_LEVEL, quest.requiredLevel or 0) .. "|r"
end

local function FirstName(text)
	return text and (text:match("^([^,]+)") or text) or nil
end

-- Where the quest starts and ends, best source first.
local function StartPoint(quest)
	local recorded = Recorded(quest.questID)
	local place = recorded and recorded.pickup and recorded.pickup.place
	if place and place.mapID and place.x then
		return { mapID = place.mapID, x = place.x, y = place.y, label = quest.pickup }
	end
	if quest.startMap then
		return { mapID = quest.startMap.mapID, x = quest.startMap.x, y = quest.startMap.y, label = quest.pickup or quest.startMap.label }
	end
	return nil
end

local function EndPoint(quest)
	local recorded = Recorded(quest.questID)
	local place = recorded and recorded.turnin and recorded.turnin.place
	if place and place.mapID and place.x then
		return { mapID = place.mapID, x = place.x, y = place.y, label = quest.turnin }
	end
	if quest.endMap then
		return { mapID = quest.endMap.mapID, x = quest.endMap.x, y = quest.endMap.y, label = quest.turnin or quest.endMap.label }
	end
	-- Handed back to whoever gave it: the same spot.
	if quest.startMap and quest.turnin and FirstName(quest.turnin) == FirstName(quest.pickup) then
		return { mapID = quest.startMap.mapID, x = quest.startMap.x, y = quest.startMap.y, label = quest.turnin }
	end
	return nil
end

-- For the quest marks on the maps (UI/QuestMap.lua).
function QuestsPanel:StartPoint(quest) return StartPoint(quest) end
-- Whether the player has handed a quest in, or has it in their log.
function QuestsPanel:IsDone(questID) return IsDone(questID) end
function QuestsPanel:InLog(questID) return InLog(questID) end
function QuestsPanel:EndPoint(quest) return EndPoint(quest) end

local function SetMapButton(button, point, title, place)
	button.point, button.title, button.place = point, title, place
	button:SetEnabled(point ~= nil)
end

local function CreateMapButton(parent, text)
	local button = ns.CreateFrameWithTemplate("Button", nil, parent, "UIPanelButtonTemplate")
	button:SetSize(112, 22)
	button:SetText(text)
	button:SetMotionScriptsWhileDisabled(true)
	button:SetScript("OnClick", function(self)
		ns.PlaySoundKit("IG_MAINMENU_OPTION")
		ns.MapPin:Mark(self.point, self.title)
	end)
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.place or self:GetText(), 1, 1, 1, 1, true)
		if not self.point then GameTooltip:AddLine(L.QUEST_PLACE_UNKNOWN, 0.6, 0.6, 0.6, true) end
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return button
end

-- The detail page, laid out top to bottom for the chosen quest.
local function FillDetail(detail, quest)
	local child = detail.Child
	local status = QuestsPanel:Status(quest)
	local recorded = Recorded(quest.questID)
	local y = 6

	local function place(region, gap, height)
		region:ClearAllPoints()
		region:SetPoint("TOPLEFT", 2, -(y + (gap or 0)))
		region:Show()
		y = y + (gap or 0) + (height or (region.GetStringHeight and region:GetStringHeight()) or region:GetHeight())
	end

	child.Title:SetText(quest.name or "")
	place(child.Title)

	local note = StatusNote(quest, status)
	child.Status:SetShown(note ~= nil)
	if note then
		child.Status:SetText(note)
		place(child.Status, 2)
	end

	local objective = quest.objective or (recorded and recorded.objective)
	if quest.steps then
		local done = 0
		for _, step in ipairs(quest.steps) do
			if IsDone(step.questID) then done = done + 1 end
		end
		objective = string.format(L.QUEST_PARTS_DONE, done, #quest.steps)
	end
	child.Objective:SetShown(objective ~= nil)
	if objective then
		child.Objective:SetText(objective)
		place(child.Objective, 8)
	end
	local notes = {}
	local starter = (quest.startItem and quest.startItem.name) or (quest.startObject and quest.startObject.name)
	if starter then notes[#notes + 1] = L.QUEST_START_ITEM .. " " .. starter end
	if quest.note then notes[#notes + 1] = quest.note end
	child.Note:SetShown(#notes > 0)
	if #notes > 0 then
		child.Note:SetText(table.concat(notes, "\n"))
		place(child.Note, 6)
	end

	local description = recorded and recorded.description
	child.DescriptionHeader:SetShown(description ~= nil)
	child.Description:SetShown(description ~= nil)
	if description then
		place(child.DescriptionHeader, 12)
		child.Description:SetText(description)
		place(child.Description, 4)
	end

	-- Show Start and Show End, side by side as on the classic journals.
	if quest.steps then
		child.ShowStart:Hide()
		child.ShowEnd:Hide()
	else
		SetMapButton(child.ShowStart, StartPoint(quest), quest.name, quest.pickup)
		SetMapButton(child.ShowEnd, EndPoint(quest), quest.name, quest.turnin)
		place(child.ShowStart, 12, 22)
		child.ShowEnd:ClearAllPoints()
		child.ShowEnd:SetPoint("LEFT", child.ShowStart, "RIGHT", 12, 0)
		child.ShowEnd:Show()
	end

	-- Rewards
	local rewards = quest.rewards or {}
	local turnedIn = recorded and recorded.turnedIn
	local xp = (turnedIn and turnedIn.xp) or rewards.xp
	if not xp and rewards.text then
		local digits = rewards.text:match("([%d,]+) XP")
		xp = digits and tonumber((digits:gsub(",", ""))) or nil
	end
	local money = (turnedIn and turnedIn.money) or rewards.money
	local reputation = {}
	if recorded and recorded.reputation then
		for faction, amount in pairs(recorded.reputation) do reputation[#reputation + 1] = { faction = faction, amount = amount } end
	else
		for _, entry in ipairs(rewards.reputation or {}) do reputation[#reputation + 1] = entry end
	end
	-- rewards.items, one of which is chosen when rewards.choice is set; rewards.also, given with it.
	local items, choice, also = rewards.items or {}, rewards.choice, rewards.also or {}
	-- Rewards seen on the quest frame fill in for a quest the data lists none for.
	local seen = recorded and (recorded.rewards or recorded.offered)
	if #items == 0 and seen then
		local ids = seen.choices or seen.items or {}
		choice = seen.choices ~= nil
		items = {}
		for _, itemID in ipairs(ids) do items[#items + 1] = { itemID = itemID } end
	end

	child.RewardsHeader:Hide()
	child.Receive:Hide()
	child.Money:Hide()
	child.Experience:Hide()
	child.Reputation:Hide()
	child.Choose:Hide()
	child.Also:Hide()
	for _, box in ipairs(child.RewardBoxes) do box:Hide() end

	-- The items in two columns, from the pool's box `first` on; returns the next free box.
	local function PlaceBoxes(list, first)
		y = y + 6
		for index, item in ipairs(list) do
			local slot = first + index - 1
			local box = child.RewardBoxes[slot]
			if not box then
				box = CreateRewardBox(child)
				child.RewardBoxes[slot] = box
			end
			box.itemID = item.itemID
			local info = ns.Items:Get(item.itemID, item)
			box.Icon:SetTexture(info.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
			local r, g, b = ns.Items:QualityColor(info.quality)
			box.Name:SetText(info.name or "")
			box.Name:SetTextColor(r, g, b)
			box.Count:SetText(item.count and item.count > 1 and item.count or "")
			local column = (index - 1) % 2
			box:ClearAllPoints()
			box:SetPoint("TOPLEFT", 2 + column * (REWARD_BOX_WIDTH + 8), -y)
			box:Show()
			if column == 1 or index == #list then y = y + REWARD_BOX_HEIGHT + 4 end
		end
		return first + #list
	end

	local hasRewards = (xp and xp > 0) or (money and money > 0) or #reputation > 0 or #items > 0 or #also > 0
	if hasRewards and not quest.steps then
		place(child.RewardsHeader, 16)
		if money and money > 0 then
			-- As on the quest frame: the coins' numbers in white, after the dark label.
			child.Receive:SetText(L.QUEST_YOU_RECEIVE)
			place(child.Receive, 6)
			child.Money:SetText(MoneyText(money))
			child.Money:ClearAllPoints()
			child.Money:SetPoint("LEFT", child.Receive, "LEFT", child.Receive:GetStringWidth() + 6, 0)
			child.Money:Show()
		end
		if xp and xp > 0 then
			child.Experience:SetText(string.format(L.QUEST_XP, Number(xp)))
			place(child.Experience, 2)
		end
		if #reputation > 0 then
			local lines = {}
			for _, entry in ipairs(reputation) do
				lines[#lines + 1] = string.format(L.QUEST_REPUTATION, entry.amount, entry.faction)
			end
			child.Reputation:SetText(table.concat(lines, "\n"))
			place(child.Reputation, 2)
		end
		local nextBox = 1
		if #items > 0 then
			if choice then
				child.Choose:SetText(L.QUEST_CHOOSE)
				place(child.Choose, 8)
			end
			nextBox = PlaceBoxes(items, nextBox)
		end
		if #also > 0 then
			child.Also:SetText(L.QUEST_ALSO)
			place(child.Also, 8)
			PlaceBoxes(also, nextBox)
		end
	end

	child:SetHeight(y + 12)
end

------------------------------------------------------------------------------------------
-- The panel
------------------------------------------------------------------------------------------

function QuestsPanel:Create(page, info)
	-- Left page: the same place as the boss list.
	local list = ns.CreateScrollFrame(info, 5, -5, 5)
	-- The boss list's height: the dungeon's name above stays clear.
	list:SetSize(338, 364)
	list:SetPoint("BOTTOMLEFT", 25, 1)
	list:SetFrameLevel(info:GetFrameLevel() + 5)
	list.Child:SetWidth(LIST_WIDTH)
	list.Rows, list.Headers, list.Boxes = {}, {}, {}
	list:Hide()

	-- Right page: the chosen quest.
	local detail = ns.CreateScrollFrame(info, -15, -6, 6)
	detail:SetSize(350, 383)
	detail:SetPoint("BOTTOMRIGHT", -5, 1)
	detail:SetFrameLevel(info:GetFrameLevel() + 5)
	detail.Child:SetWidth(DETAIL_WIDTH + 5)
	detail:Hide()

	local headerFont = ns.Font("QuestTitleFont", "GameFontNormalLarge")
	local child = detail.Child
	child.Title = Text(child, headerFont, TITLE_COLOR)
	child.Status = Text(child, "GameFontNormalSmall")
	child.Objective = Text(child)
	child.Note = Text(child)
	child.DescriptionHeader = Text(child, headerFont, TITLE_COLOR)
	child.DescriptionHeader:SetText(L.QUEST_DESCRIPTION)
	child.Description = Text(child)
	child.ShowStart = CreateMapButton(child, L.QUEST_SHOW_START)
	child.ShowEnd = CreateMapButton(child, L.QUEST_SHOW_END)
	child.RewardsHeader = Text(child, headerFont, TITLE_COLOR)
	child.RewardsHeader:SetText(L.QUEST_REWARDS)
	child.Receive = Text(child, nil, TITLE_COLOR)
	child.Money = child:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	child.Money:Hide()
	child.Experience = Text(child)
	child.Reputation = Text(child, ns.Font("GameFontNormalSmall", "GameFontBlack"), REPUTATION_COLOR)
	child.Choose = Text(child)
	child.Also = Text(child)
	child.RewardBoxes = {}

	child.Empty = Text(child)
	child.Empty:SetPoint("TOPLEFT", 2, -8)
	child.Empty:SetText(L.QUEST_NONE)

	-- The player's quest log changes what every row says.
	list:RegisterEvent("QUEST_LOG_UPDATE")
	list:RegisterEvent("QUEST_TURNED_IN")
	list:RegisterEvent("QUEST_ACCEPTED")
	list:RegisterEvent("GET_ITEM_INFO_RECEIVED")
	list:SetScript("OnEvent", function(self)
		if self:IsVisible() and not self.refreshQueued then
			self.refreshQueued = true
			C_Timer.After(0.2, function()
				self.refreshQueued = nil
				if self:IsVisible() then QuestsPanel:Refresh(page) end
			end)
		end
	end)

	self.page = page
	page.QuestList, page.QuestDetail = list, detail
	page.expandedChains = {}
end

function QuestsPanel:Show(page, shown)
	page.QuestList:SetShown(shown)
	page.QuestDetail:SetShown(shown)
	page.Bosses:SetShown(not shown)
	if shown then self:Refresh(page) end
end

function QuestsPanel:Select(quest)
	local page = self.page
	page.selectedQuest = quest
	self:Refresh(page)
end

-- Opens the journal on a dungeon's Quests tab with the quest chosen (search, the map's quest
-- marks, Before you go), the dropdown and the chain that hold it open.
function QuestsPanel:Open(instance, quest)
	local journal = ns.Journal
	journal:Show()
	journal:OpenInstance(instance)
	ns.EncounterPage:SetTab(journal:Page(), ns.EncounterPage.TAB_QUESTS)
	self.page.reveal = quest
	self:Select(quest)
end

local function Holds(quests, quest)
	for _, held in ipairs(quests or {}) do
		if held == quest then return true end
	end
	return false
end

-- The first of these quests still to do (the first, once all are done).
-- The parchment box an open dropdown's quests sit in, as an ability's text does on the Abilities tab.
local function CreateBox(child)
	local box = child:CreateTexture(nil, "BACKGROUND")
	ns.Art(box, "AbilityTextBG")
	box.Bottom = child:CreateTexture(nil, "BACKGROUND")
	ns.Art(box.Bottom, "AbilityTextBottomBorder")
	box.Bottom:ClearAllPoints()
	box.Bottom:SetPoint("LEFT", box, "BOTTOMLEFT")
	box.Bottom:SetPoint("RIGHT", box, "BOTTOMRIGHT")
	return box
end

local function FirstToDo(quests)
	for _, quest in ipairs(quests) do
		if QuestsPanel:Status(quest) ~= STATUS_DONE then return quest end
	end
	return quests[1]
end

-- A dropdown's header: the mark of its first quest still to do, and how many of its quests are done.
local function GroupSection(key, title, quests)
	local done = 0
	for _, quest in ipairs(quests) do
		if QuestsPanel:Status(quest) == STATUS_DONE then done = done + 1 end
	end
	local first = FirstToDo(quests)
	return { key = key, title = title, status = first and QuestsPanel:Status(first) or STATUS_DONE,
		note = string.format("%d/%d", done, #quests), flags = {} }
end

-- A click on a dropdown's header opens or folds it; as it opens, its first quest still to do is
-- chosen, unless one of its quests is chosen already.
function QuestsPanel:Clicked(section)
	local page = self.page
	local opening = not section.expanded
	page.expandedChains[section.key] = opening
	if opening and not section.members[page.selectedQuest] then page.selectedQuest = FirstToDo(section.quests) end
	self:Refresh(page)
end

function QuestsPanel:ToggleChain(quest)
	local page = self.page
	page.expandedChains[quest.questID] = not page.expandedChains[quest.questID]
	self:Refresh(page)
end

local function QuestByID(instance, questID)
	for _, quest in ipairs(instance.quests or {}) do
		if quest.questID == questID then return quest end
	end
	return nil
end

-- A chain's steps as rows. Steps this dungeon does not list itself are kept as one object
-- each, so they can stay chosen; consecutive steps sharing a name become one row.
local stepQuests = {}
local function ChainRows(instance, quest)
	-- Some chains list the quest itself among its steps; it already has its own row.
	local prerequisites = {}
	for _, step in ipairs(quest.prerequisites or {}) do
		if step.questID ~= quest.questID then prerequisites[#prerequisites + 1] = step end
	end
	local rows, index = {}, 1
	while index <= #prerequisites do
		local step = prerequisites[index]
		local last = index
		while prerequisites[last + 1] and prerequisites[last + 1].name == step.name do last = last + 1 end
		local row
		if last > index then
			local key = "steps:" .. step.questID .. ":" .. last - index
			if not stepQuests[key] then
				local steps = {}
				for position = index, last do steps[#steps + 1] = prerequisites[position] end
				stepQuests[key] = { questID = step.questID, name = string.format(L.QUEST_PARTS, step.name or "", #steps), steps = steps }
			end
			row = stepQuests[key]
		else
			row = QuestByID(instance, step.questID)
			if not row then
				stepQuests[step.questID] = stepQuests[step.questID] or { questID = step.questID, name = step.name }
				row = stepQuests[step.questID]
			end
		end
		rows[#rows + 1] = row
		index = last + 1
	end
	return rows
end

-- A quest as the Quests tab lists it: the dungeon's own, else the step of a chain that holds it.
-- Nil when the dungeon lists it nowhere.
function QuestsPanel:Find(instance, questID)
	local quest = QuestByID(instance, questID)
	if quest then return quest end
	for _, parent in ipairs(instance.quests or {}) do
		for _, step in ipairs(ChainRows(instance, parent)) do
			if step.questID == questID then return step end
			for _, part in ipairs(step.steps or {}) do
				if part.questID == questID then return step end
			end
		end
	end
	return nil
end

function QuestsPanel:Refresh(page)
	local instance = page.instance
	local list, child = page.QuestList, page.QuestList.Child
	local reveal = page.reveal
	page.reveal = nil
	-- What is open and chosen holds while the dungeon stays shown, as on the Abilities tab. A
	-- dungeon shown anew starts afresh, at the list's top, nothing open or chosen yet (a step two
	-- dungeons share would stay chosen, folded out of sight). A quest opened there from elsewhere is
	-- chosen after this (QuestsPanel:Open shows the tab first).
	if page.questsShown ~= instance then
		page.questsShown, page.expandedChains, page.selectedQuest = instance, {}, nil
		list:SetVerticalScroll(0)
	end
	local open = page.expandedChains

	-- The dropdowns: the dungeon's keys (their quests, steps of no other), then Dungeon Quests.
	-- Each starts as it should once the dungeon is shown, so a quest taken while the tab is open
	-- doesn't fold one under the player.
	local groups, inKey = {}, {}
	for _, key in ipairs(ns.BeforeYouGo:Keys(instance)) do
		for _, quest in ipairs(key.quests) do inKey[quest] = true end
		if open[key.key] == nil then open[key.key] = not key.have end
		local section = GroupSection(key.key, key.title, key.quests)
		section.status, section.note = key.status, key.note
		groups[#groups + 1] = { section = section, quests = key.quests }
	end
	local others = {}
	for _, quest in ipairs(QuestsFor(instance)) do
		if not inKey[quest] then others[#others + 1] = quest end
	end
	if #others > 0 then
		if open.dungeon == nil then open.dungeon = true end
		groups[#groups + 1] = { section = GroupSection("dungeon", L.QUESTS_DUNGEON, others), quests = others, chains = true }
	end

	-- What each holds, chains included. A quest opened from elsewhere opens its dropdown; a step
	-- with no row of its own, its chain too (a quest that has one is chosen there, and the chains
	-- that name it as a step stay as they are).
	local listed, own = {}, {}
	for _, group in ipairs(groups) do
		for _, quest in ipairs(group.quests) do own[quest] = true end
	end
	for _, group in ipairs(groups) do
		local section = group.section
		section.quests, section.members, group.chainOf = group.quests, {}, {}
		for _, quest in ipairs(group.quests) do
			local chain = group.chains and ChainRows(instance, quest) or {}
			group.chainOf[quest] = chain
			section.members[quest], listed[quest] = true, true
			for _, step in ipairs(chain) do section.members[step], listed[step] = true, true end
			if reveal and (reveal == quest or (not own[reveal] and Holds(chain, reveal))) then
				open[section.key] = true
				if reveal ~= quest then open[quest.questID] = true end
			end
		end
		section.expanded = open[section.key] == true
	end

	-- Keep the choice while the dungeon lists it, shown or folded away; otherwise start on the
	-- first open dropdown's first quest still to do.
	local selected = page.selectedQuest
	if not (selected and listed[selected]) then
		selected = nil
		for _, group in ipairs(groups) do
			if group.section.expanded then
				selected = FirstToDo(group.quests)
				break
			end
		end
		selected = selected or (groups[1] and FirstToDo(groups[1].quests))
		page.selectedQuest = selected
	end

	local y, headers, rows, boxes, chosenY = TOP_PADDING, 0, 0, 0, nil
	local function Place(quest, depth, hasChain, expanded)
		if quest == selected then chosenY = y end
		rows = rows + 1
		local row = list.Rows[rows]
		if not row then
			row = CreateRow(child)
			list.Rows[rows] = row
		end
		SetRow(row, quest, depth, hasChain, expanded, quest == selected)
		row:SetWidth(LIST_WIDTH - ROW_INDENT - depth * INDENT - ROW_INDENT)
		row:SetPoint("TOPLEFT", ROW_INDENT + depth * INDENT, -y)
		row:Show()
		y = y + ROW_HEIGHT
	end
	for _, group in ipairs(groups) do
		headers = headers + 1
		local header = list.Headers[headers]
		if not header then
			header = ns.PaperHeader.Create(child, function(section) QuestsPanel:Clicked(section) end)
			list.Headers[headers] = header
		end
		header:ClearAllPoints()
		header:SetPoint("TOPLEFT", 0, -y)
		header:SetWidth(LIST_WIDTH)
		y = y + ns.PaperHeader.Set(header, group.section, 0, group.section.expanded)
		header:Show()
		if group.section.expanded and #group.quests > 0 then
			local boxTop = y - BOX_TUCK
			y = y + BOX_PADDING
			for _, quest in ipairs(group.quests) do
				local chain = group.chainOf[quest]
				local chainOpen = #chain > 0 and open[quest.questID] == true
				Place(quest, 0, #chain > 0, chainOpen)
				if chainOpen then
					for _, step in ipairs(chain) do Place(step, 1) end
				end
			end
			y = y + BOX_PADDING
			boxes = boxes + 1
			local box = list.Boxes[boxes]
			if not box then
				box = CreateBox(child)
				list.Boxes[boxes] = box
			end
			box:ClearAllPoints()
			box:SetPoint("TOPLEFT", child, "TOPLEFT", BOX_SIDE, -boxTop)
			box:SetPoint("BOTTOMRIGHT", child, "TOPLEFT", LIST_WIDTH - BOX_SIDE, -y)
			box:Show()
			box.Bottom:Show()
		end
		y = y + HEADER_GAP * 2
	end
	for index = headers + 1, #list.Headers do list.Headers[index]:Hide() end
	for index = boxes + 1, #list.Boxes do
		list.Boxes[index]:Hide()
		list.Boxes[index].Bottom:Hide()
	end
	for index = rows + 1, #list.Rows do list.Rows[index]:Hide() end
	child:SetHeight(math.max(1, y + 4))

	-- A quest opened from elsewhere is scrolled into view, once the client knows the list's
	-- scroll range (as the loot list does).
	if reveal and chosenY then
		C_Timer.After(0, function()
			local top, height = list:GetVerticalScroll() or 0, list:GetHeight() or 0
			if chosenY < top or chosenY + ROW_HEIGHT > top + height then
				list:SetVerticalScroll(math.max(0, math.min(list:GetVerticalScrollRange() or 0, chosenY - TOP_PADDING)))
			end
		end)
	end

	local detailChild = page.QuestDetail.Child
	detailChild.Empty:SetShown(selected == nil)
	if selected then
		FillDetail(page.QuestDetail, selected)
	else
		for _, key in ipairs({ "Title", "Status", "Objective", "Note", "DescriptionHeader", "Description", "ShowStart",
			"ShowEnd", "RewardsHeader", "Receive", "Money", "Experience", "Reputation", "Choose", "Also" }) do
			detailChild[key]:Hide()
		end
		for _, box in ipairs(detailChild.RewardBoxes) do box:Hide() end
	end
end
