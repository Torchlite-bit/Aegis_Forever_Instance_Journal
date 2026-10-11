local _, ns = ...
local L = ns.L

--[[
	The Record tab, laid out as an open page of the journal's book.

	Left page, the recorder: whether it is on and how much it has caught; Start or Stop, Copy and
	Clear; recording by itself in dungeons, and the combat-log choice; where to send a recording
	(our Discord) and the name to credit it to; and the contributors whose recordings went into
	the journal.

	Right page, what has been caught, by dungeon (the latest first): the bosses killed and the
	drops the journal does not list there yet (off a boss, off trash, looted by the group), the ones it lists
	only counted; then quests, quartermasters, travel marks and the latest entries. Copy turns
	this page into the recording as text, picked out for Ctrl+C (the game cannot write to the
	clipboard itself); Back, or Escape, turns it back. When the recording wrote a combat log, the
	hint names the file and links the Log Reader, which adds the log's boss spells to the text.
]]

local RecordPanel = {}
ns.RecordPanel = RecordPanel

local CLEAR_POPUP = "AEGISJOURNAL_CLEAR_RECORDING"
local RECORDING_LIGHT = "Interface\\COMMON\\Indicator-Red"
local BOOK = "Interface\\EncounterJournal\\UI-EJ-JournalBG"
local BOOK_COORDS = { 0, 0.766601562, 0, 0.830078125 }
local CIRCLE_MASK = "Interface\\CharacterFrame\\TempPortraitAlphaMask"
local RECORDER_ICON = "Interface\\Icons\\INV_Misc_Note_01"
-- Start and Stop are one button: after a start it stays shut a moment, so a second click
-- meant for Start does not end the recording it just began.
local STOP_LOCK_SECONDS = 5
local RECENT_LINES = 8
local LEFT_X, LEFT_WIDTH = 28, 322
local LIST_WIDTH = 316
-- The recording's text under its hint; shorter when the Log Reader's link sits between them.
local COPY_HEIGHT, COPY_HEIGHT_WITH_LINK = 340, 284

-- Everything on the page is the journal's body size or larger, in full ink: on this parchment,
-- small or lighter text does not read.
local BODY = "GameFontBlack"
local MEDIUM = ns.Font("GameFontBlackMedium", "GameFontBlack")

-- Inks that read on the parchment.
local INK = ns.PARCHMENT_TEXT_COLOR
local PROBLEM_INK = { 0.55, 0.06, 0.06 }
local GREEN, RED = "|cff0f4f0f", "|cff8c1010"
-- Item qualities, darkened from the game's colours to read on parchment.
local QUALITY_INK = { [0] = "|cff3c3c3c", "|cff3d2a12", "|cff0b4a0b", "|cff083e7c", "|cff52186e", "|cff7a3200" }

-- A log line saying something was missed ("Entrance of X not recorded: ...").
local PROBLEM_MARK = L.RECORD_LOG_NO_ENTRANCE:match("%%s(.-)%%s")

StaticPopupDialogs[CLEAR_POPUP] = {
	text = L.RECORD_CLEAR_CONFIRM,
	button1 = YES,
	button2 = NO,
	OnAccept = function() ns.Recorder:Clear() end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	showAlert = true,
}

------------------------------------------------------------------------------------------
-- Pieces
------------------------------------------------------------------------------------------

local function Ink(text, color)
	color = color or INK
	text:SetTextColor(color[1], color[2], color[3])
	return text
end

local function Text(parent, font, color)
	local text = parent:CreateFontString(nil, "OVERLAY", font or BODY)
	text:SetJustifyH("LEFT")
	return Ink(text, color)
end

local function ShowTip(owner, title, text)
	GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
	GameTooltip:SetText(title, 1, 1, 1)
	GameTooltip:AddLine(text, 0.9, 0.9, 0.9, true)
	GameTooltip:Show()
end

local function HideTip() GameTooltip:Hide() end

local function CreateButton(parent, width, text, onClick)
	local button = ns.CreateFrameWithTemplate("Button", nil, parent, "UIPanelButtonTemplate")
	button:SetSize(width, 26)
	button:SetText(text)
	button:SetScript("OnClick", onClick)
	return button
end

local function CreateCheck(parent, label, tip, onClick)
	local check = ns.CreateFrameWithTemplate("CheckButton", nil, parent, "UICheckButtonTemplate")
	check:SetSize(26, 26)
	check:SetScript("OnClick", function(self)
		ns.PlaySoundKit(self:GetChecked() and "IG_MAINMENU_OPTION_CHECKBOX_ON" or "IG_MAINMENU_OPTION_CHECKBOX_OFF")
		onClick(self)
	end)
	check:SetScript("OnEnter", function(self) ShowTip(self, label, tip) end)
	check:SetScript("OnLeave", HideTip)
	check.Label = Text(parent)
	check.Label:SetPoint("LEFT", check, "RIGHT", 2, 1)
	check.Label:SetText(label)
	return check
end

-- A section of the page under the bar a boss page's "Overview" sits on.
local function SectionBar(parent, label)
	local bar = parent:CreateTexture(nil, "ARTWORK")
	ns.Art(bar, "Header-Overview")
	bar.Label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	bar.Label:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 8, 6)
	bar.Label:SetText(label)
	Ink(bar.Label, ns.HEADER_LABEL_COLOR)
	return bar
end

-- The name a recording is credited to: the one the player gave, else their character's.
local function CreditName()
	if ns.db.creditName then return ns.db.creditName end
	local ok, name = pcall(UnitName, "player")
	return ok and ns.Readable(name) or nil
end


------------------------------------------------------------------------------------------
-- The book
------------------------------------------------------------------------------------------

local function CreateBook(panel)
	local book = CreateFrame("Frame", nil, panel)
	book:SetSize(785, 425)
	book:SetPoint("BOTTOMRIGHT", -4, 2)
	book.Art = book:CreateTexture(nil, "BACKGROUND")
	book.Art:SetAllPoints()
	book.Art:SetTexture(BOOK)
	book.Art:SetTexCoord(BOOK_COORDS[1], BOOK_COORDS[2], BOOK_COORDS[3], BOOK_COORDS[4])
	book.LeftShadow = book:CreateTexture(nil, "BACKGROUND", nil, 3)
	ns.Art(book.LeftShadow, "LeftPageHeader")
	book.LeftShadow:SetPoint("TOPLEFT", 0, -11)
	book.RightShadow = book:CreateTexture(nil, "BACKGROUND", nil, 3)
	ns.Art(book.RightShadow, "RightPageHeader")
	book.RightShadow:SetPoint("TOPRIGHT", 0, -11)
	return book
end

-- The left page's emblem, where a dungeon's page has its picture: a note in the creature
-- ring, with a red light on it while recording.
local function CreateEmblem(panel, book)
	local ring = CreateFrame("Frame", nil, book)
	ring:SetSize(64, 61)
	ring:SetPoint("TOPLEFT", 0, -3)
	ring.Icon = ring:CreateTexture(nil, "BACKGROUND", nil, 6)
	ring.Icon:SetSize(40, 40)
	ring.Icon:SetPoint("CENTER")
	ring.Icon:SetTexture(RECORDER_ICON)
	if ring.CreateMaskTexture and ring.Icon.AddMaskTexture then
		local mask = ring:CreateMaskTexture()
		mask:SetTexture(CIRCLE_MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
		mask:SetAllPoints(ring.Icon)
		ring.Icon:AddMaskTexture(mask)
	end
	ring.Border = ring:CreateTexture(nil, "ARTWORK")
	ns.Art(ring.Border, "BossModelButton")
	ring.Border:SetPoint("CENTER")
	ring.Light = ring:CreateTexture(nil, "OVERLAY")
	ring.Light:SetTexture(RECORDING_LIGHT)
	ring.Light:SetSize(18, 18)
	ring.Light:SetPoint("BOTTOMRIGHT", -7, 7)
	ring.Light:Hide()
	panel.Emblem = ring

	panel.PageTitle = book:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	panel.PageTitle:SetPoint("TOPLEFT", 65, -20)
	panel.PageTitle:SetText(L.RECORD_RECORDER)
	Ink(panel.PageTitle, ns.PAGE_TITLE_COLOR)
end

local function CreateControls(panel, book)
	-- Beside the emblem, under the page's title.
	panel.Status = Text(book, MEDIUM)
	panel.Status:SetPoint("TOPLEFT", 70, -54)
	panel.Status:SetWidth(LEFT_WIDTH - 44)
	panel.Counts = Text(book)
	panel.Counts:SetPoint("TOPLEFT", panel.Status, "BOTTOMLEFT", 0, -4)
	panel.Counts:SetWidth(LEFT_WIDTH - 44)

	panel.Toggle = CreateButton(book, 144, L.RECORD_START, function() RecordPanel:ToggleRecording(panel) end)
	panel.Toggle:SetPoint("TOPLEFT", LEFT_X - 2, -94)
	panel.Copy = CreateButton(book, 86, L.RECORD_COPY, function()
		ns.PlaySoundKit("IG_MAINMENU_OPTION")
		RecordPanel:SetCopyShown(panel, not panel.copying)
	end)
	panel.Copy:SetPoint("LEFT", panel.Toggle, "RIGHT", 4, 0)
	panel.Clear = CreateButton(book, 86, L.RECORD_CLEAR, function() StaticPopup_Show(CLEAR_POPUP) end)
	panel.Clear:SetPoint("LEFT", panel.Copy, "RIGHT", 4, 0)

	panel.AutoRecord = CreateCheck(book, L.RECORD_AUTO, L.RECORD_AUTO_TIP, function(self)
		ns.Recorder:SetAutoRecord(self:GetChecked())
	end)
	panel.AutoRecord:SetPoint("TOPLEFT", LEFT_X - 4, -126)
	panel.CombatLog = CreateCheck(book, L.RECORD_COMBATLOG, L.RECORD_COMBATLOG_TIP, function(self)
		ns.Recorder:SetCombatLog(self:GetChecked())
	end)
	panel.CombatLog:SetPoint("TOPLEFT", panel.AutoRecord, "BOTTOMLEFT", 0, 2)
end

local function CreateSendSection(panel, book)
	panel.SendBar = SectionBar(book, L.RECORD_SEND)
	panel.SendBar:SetPoint("TOPLEFT", LEFT_X - 6, -182)
	panel.SendText = Text(book)
	panel.SendText:SetPoint("TOPLEFT", LEFT_X, -218)
	panel.SendText:SetWidth(LEFT_WIDTH)
	panel.SendText:SetText(L.RECORD_HELP_TEXT)
	panel.Link = ns.CreateDiscordLink(book, 196, true)
	panel.Link:SetPoint("TOPLEFT", LEFT_X + 6, -236)

	panel.CreditLabel = Text(book)
	panel.CreditLabel:SetPoint("TOPLEFT", LEFT_X, -268)
	panel.CreditLabel:SetText(L.RECORD_CREDIT)
	local credit = ns.DarkenInputBox(ns.CreateFrameWithTemplate("EditBox", nil, book, "InputBoxTemplate"))
	credit:SetSize(170, 20)
	credit:SetPoint("LEFT", panel.CreditLabel, "RIGHT", 12, 0)
	credit:SetAutoFocus(false)
	credit:SetMaxLetters(40)
	credit:SetScript("OnTextChanged", function(self)
		local name = self:GetText() or ""
		ns.db.creditName = name ~= "" and name or nil
	end)
	credit:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
	credit:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
	credit:SetScript("OnEnter", function(self) ShowTip(self, L.RECORD_CREDIT, L.RECORD_CREDIT_TIP) end)
	credit:SetScript("OnLeave", HideTip)
	panel.Credit = credit
end

local function CreateContributors(panel, book)
	panel.ContributorsBar = SectionBar(book, L.RECORD_CONTRIBUTORS)
	panel.ContributorsBar:SetPoint("TOPLEFT", LEFT_X - 6, -292)
	-- The call first, under the bar; the names beneath it, clear of the page's shaded foot.
	panel.ContributorsFoot = Text(book)
	panel.ContributorsFoot:SetPoint("TOPLEFT", LEFT_X, -328)
	panel.ContributorsFoot:SetText(L.RECORD_CONTRIBUTORS_FOOT)
	local names = ns.CreateScrollFrame(book, 2, -2, 2)
	names:SetSize(LEFT_WIDTH - 18, 44)
	names:SetPoint("TOPLEFT", LEFT_X, -348)
	names.Child:SetWidth(LEFT_WIDTH - 24)
	panel.Names = Text(names.Child, MEDIUM)
	panel.Names:SetPoint("TOPLEFT")
	panel.Names:SetWidth(LEFT_WIDTH - 24)
	local all = ns.CONTRIBUTORS or {}
	panel.Names:SetText(#all > 0 and table.concat(all, "\n") or L.RECORD_CONTRIBUTORS_NONE)
	names.Child:SetHeight(panel.Names:GetStringHeight() + 4)
	panel.NamesScroll = names
end

-- The right page: the list of what was caught, and the recording as text in its place.
local function CreateRightPage(panel, book)
	panel.ListTitle = book:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	panel.ListTitle:SetSize(300, 12)
	panel.ListTitle:SetPoint("BOTTOMLEFT", book, "TOPRIGHT", -350, -36)
	panel.ListTitle:SetJustifyH("LEFT")
	Ink(panel.ListTitle, ns.PAGE_TITLE_COLOR)

	local list = ns.CreateScrollFrame(book, -15, -6, 6)
	list:SetSize(350, 383)
	list:SetPoint("BOTTOMRIGHT", -5, 1)
	list.Child:SetWidth(LIST_WIDTH + 4)
	list.Rows = {}
	panel.List = list

	panel.CopyHint = Text(book, BODY)
	panel.CopyHint:SetPoint("TOPLEFT", book, "TOPRIGHT", -348, -48)
	panel.CopyHint:SetWidth(LIST_WIDTH)
	panel.CopyHint:SetText(L.RECORD_COPY_HINT)
	-- Under the hint when the recording wrote a combat log: the page that adds its boss spells.
	panel.LogLink = ns.CreateLinkBox(book, ns.LOG_READER_URL, 210, true)
	panel.LogLink:SetPoint("TOPLEFT", panel.CopyHint, "BOTTOMLEFT", 6, -4)
	panel.LogLink:Hide()
	local copy = ns.CreateScrollFrame(book, -15, -6, 6)
	copy:SetSize(350, COPY_HEIGHT)
	copy:SetPoint("BOTTOMRIGHT", -5, 1)
	local box = CreateFrame("EditBox", nil, copy)
	box:SetMultiLine(true)
	box:SetAutoFocus(false)
	box:SetMaxLetters(0)
	box:SetFontObject(BODY)
	Ink(box)
	box:SetWidth(LIST_WIDTH)
	box:SetScript("OnEscapePressed", function() RecordPanel:SetCopyShown(panel, false) end)
	-- Typing in it puts the recording back as it was.
	box:SetScript("OnTextChanged", function(self, userInput)
		if userInput and panel.export then
			self:SetText(panel.export)
			self:HighlightText()
		end
	end)
	copy:SetScrollChild(box)
	copy.Child = box
	panel.CopyScroll, panel.CopyBox = copy, box
end

------------------------------------------------------------------------------------------
-- What was caught
------------------------------------------------------------------------------------------

local function ItemText(item)
	return (QUALITY_INK[item.quality] or QUALITY_INK[1]) .. (item.name or string.format(L.RECORD_ITEM, item.itemID)) .. "|r"
end

-- The lines of the list: { text, font, indent, gap above, ink }.
local function CatchLines(catch, log)
	local lines = {}
	local function Add(text, font, indent, gap, color)
		lines[#lines + 1] = { text = text, font = font or BODY, indent = indent or 0, gap = gap or 2, color = color }
	end

	for _, place in ipairs(catch.places) do
		Add(place.name, MEDIUM, 0, 12)
		local facts = {}
		if place.visits > 0 then
			facts[#facts + 1] = place.visits == 1 and L.RECORD_ONE_VISIT or string.format(L.RECORD_VISITS, place.visits)
		end
		facts[#facts + 1] = place.entrance and L.RECORD_ENTRANCE_YES or (RED .. L.RECORD_ENTRANCE_NO .. "|r")
		if place.areas > 0 then facts[#facts + 1] = string.format(L.RECORD_AREAS, place.areas) end
		Add(table.concat(facts, ", "), BODY, 0, 2)

		local killed = {}
		for _, fight in ipairs(place.kills) do
			if fight.kills > 1 then
				killed[#killed + 1] = string.format(L.RECORD_KILLED_TIMES, fight.name, fight.kills)
			elseif fight.kills == 1 then
				killed[#killed + 1] = fight.name
			end
		end
		if #killed > 0 then Add(string.format(L.RECORD_KILLED, table.concat(killed, ", ")), BODY, 0, 5) end

		if place.new + place.listed > 0 then
			Add(string.format(L.RECORD_DROPS, GREEN .. place.new .. "|r", place.listed), BODY, 0, 5)
		end
		for _, boss in ipairs(place.bosses) do
			Add(string.format(L.RECORD_OFF, boss.name), BODY, 10, 4)
			for _, item in ipairs(boss.items) do Add(ItemText(item), BODY, 22, 1) end
		end
		if #place.trash > 0 then
			Add(L.RECORD_OFF_TRASH, BODY, 10, 4)
			for _, item in ipairs(place.trash) do Add(ItemText(item), BODY, 22, 1) end
		end
		if #place.group > 0 then
			Add(L.RECORD_OFF_GROUP, BODY, 10, 4)
			for _, item in ipairs(place.group) do Add(ItemText(item), BODY, 22, 1) end
		end
	end

	if #catch.quests > 0 then
		Add(L.RECORD_QUESTS, MEDIUM, 0, 14)
		for _, quest in ipairs(catch.quests) do
			local text = quest.title
			if quest.done then text = text .. "  (" .. L.RECORD_QUEST_DONE .. ")" end
			if quest.new then text = text .. GREEN .. "  " .. L.RECORD_NEW .. "|r" end
			Add(text, BODY, 10, 2)
		end
	end
	if #catch.vendors > 0 then
		Add(L.RECORD_QUARTERMASTERS, MEDIUM, 0, 14)
		for _, vendor in ipairs(catch.vendors) do
			Add(string.format(L.RECORD_WARES, vendor.name, vendor.wares, GREEN .. vendor.new .. "|r"), BODY, 10, 2)
		end
	end
	if catch.travel > 0 then Add(string.format(L.RECORD_TRAVEL, catch.travel), MEDIUM, 0, 14) end

	if #lines == 0 then Add(L.RECORD_NOTHING_YET, BODY, 0, 0) end

	if #log > 0 then
		Add(L.RECORD_RECENT, MEDIUM, 0, 16)
		for index = #log, math.max(1, #log - RECENT_LINES + 1), -1 do
			local line = log[index]
			Add(line, BODY, 10, 1, PROBLEM_MARK and line:find(PROBLEM_MARK, 1, true) and PROBLEM_INK or nil)
		end
	end
	return lines
end

local function FillList(panel, catch, log)
	local list = panel.List
	local lines = CatchLines(catch, log)
	local y = 6
	for index, line in ipairs(lines) do
		local row = list.Rows[index]
		if not row then
			row = list.Child:CreateFontString(nil, "OVERLAY", BODY)
			row:SetJustifyH("LEFT")
			list.Rows[index] = row
		end
		row:SetFontObject(line.font)
		Ink(row, line.color)
		row:SetWidth(LIST_WIDTH - line.indent)
		if index > 1 then y = y + line.gap end
		row:ClearAllPoints()
		row:SetPoint("TOPLEFT", line.indent + 2, -y)
		row:SetText(line.text)
		row:Show()
		y = y + row:GetStringHeight()
	end
	for index = #lines + 1, #list.Rows do list.Rows[index]:Hide() end
	list.Child:SetHeight(y + 10)
end

------------------------------------------------------------------------------------------
-- The panel
------------------------------------------------------------------------------------------

function RecordPanel:Build(panel, tab)
	panel.Empty:Hide()
	-- The book's two page titles take the place of the panel's.
	panel.Title:Hide()

	if tab then
		panel.RecordingLight = tab:CreateTexture(nil, "OVERLAY")
		panel.RecordingLight:SetTexture(RECORDING_LIGHT)
		panel.RecordingLight:SetSize(12, 12)
		local label = tab.GetFontString and tab:GetFontString()
		if label then
			panel.RecordingLight:SetPoint("RIGHT", label, "LEFT", -3, 0)
		else
			panel.RecordingLight:SetPoint("LEFT", 8, 0)
		end
		panel.RecordingLight:Hide()
	end

	local book = CreateBook(panel)
	panel.Book = book
	CreateEmblem(panel, book)
	CreateControls(panel, book)
	CreateSendSection(panel, book)
	CreateContributors(panel, book)
	CreateRightPage(panel, book)

	-- The page opens on the list.
	panel:HookScript("OnShow", function() RecordPanel:SetCopyShown(panel, false) end)
	panel:HookScript("OnHide", function() panel.CopyBox:ClearFocus() end)
	ns.Recorder:OnChange(function() RecordPanel:Refresh(panel) end)
	self:SetCopyShown(panel, false)
end

function RecordPanel:ToggleRecording(panel)
	ns.PlaySoundKit("IG_MAINMENU_OPTION")
	ns.Recorder:Toggle()
	if not ns.Recorder:IsRecording() then return end
	panel.stopLocked = true
	self:Refresh(panel)
	C_Timer.After(STOP_LOCK_SECONDS, function()
		panel.stopLocked = nil
		RecordPanel:Refresh(panel)
	end)
end

-- The right page as the recording's text (shown) or as the list. Showing the text counts as a copy.
function RecordPanel:SetCopyShown(panel, shown)
	panel.copying = shown
	panel.List:SetShown(not shown)
	panel.CopyHint:SetShown(shown)
	panel.CopyScroll:SetShown(shown)
	panel.ListTitle:SetText(shown and L.RECORD_COPY_TITLE or L.RECORD_CAUGHT_TITLE)
	panel.Copy:SetText(shown and L.RECORD_BACK or L.RECORD_COPY)
	-- A recording that wrote a combat log goes by the Log Reader, which adds the log's boss spells.
	local logs = ns.Recorder:CombatLogs()
	local withLog = shown and #logs > 0
	if withLog then
		-- The newest log by name (the hint has room for one), and how many came before it.
		local files = logs[#logs].file
		if #logs > 1 then files = string.format(L.RECORD_MORE_LOGS, files, #logs - 1) end
		panel.CopyHint:SetText(string.format(L.RECORD_COPY_HINT_LOG, files))
	else
		panel.CopyHint:SetText(L.RECORD_COPY_HINT)
	end
	panel.LogLink:SetShown(withLog)
	panel.CopyScroll:SetHeight(withLog and COPY_HEIGHT_WITH_LINK or COPY_HEIGHT)
	if shown then
		panel.export = ns.Recorder:Export(CreditName())
		panel.CopyBox:SetText(panel.export)
		panel.CopyScroll:SetVerticalScroll(0)
		panel.CopyBox:SetFocus()
		panel.CopyBox:HighlightText()
		ns.Recorder:MarkCopied()
	else
		panel.CopyBox:ClearFocus()
		self:Refresh(panel)
	end
end

function RecordPanel:Refresh(panel)
	local recorder = ns.Recorder
	local state = recorder:GetState()
	if not state then return end
	local recording = recorder:IsRecording()

	-- The tab carries a red light while recording, so it shows from any page.
	if panel.RecordingLight then panel.RecordingLight:SetShown(recording) end

	if not panel:IsVisible() then return end

	local counts = recorder:Counts()
	panel.Status:SetText(recording and (GREEN .. string.format(L.RECORD_STATUS_ON, state.startedAt or "") .. "|r")
		or (RED .. L.RECORD_STATUS_OFF .. "|r"))
	panel.Counts:SetText(string.format(L.RECORD_CAUGHT, counts.caught, counts.new))
	panel.Emblem.Light:SetShown(recording)
	panel.Toggle:SetText(recording and L.RECORD_STOP or L.RECORD_START)
	panel.Toggle:SetEnabled(not panel.stopLocked)
	panel.Clear:SetEnabled(counts.caught > 0)
	panel.CombatLog:SetChecked(state.combatLog)
	panel.AutoRecord:SetChecked(state.autoRecord)
	if not panel.Credit:HasFocus() then panel.Credit:SetText(ns.db.creditName or "") end
	if not panel.copying then FillList(panel, recorder:Catch(), state.log) end
end
