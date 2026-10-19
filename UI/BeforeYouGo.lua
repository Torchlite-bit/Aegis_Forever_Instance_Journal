local _, ns = ...
local L = ns.L

--[[
	Before you go, on a dungeon's overview: what the dungeon asks of the player before its door (a
	key and the quests to it) and what is worth preparing (a hidden boss and how to summon it),
	from its data's `prepare` list ({ title, text, faction, quests }), for the player's own side.

	The notes sit under a "Before you go" bar, each under one of the Abilities tab's paper headers,
	open until there is nothing left to do:
	  a key's header carries the mark of the quest the player is on, as the Quests tab shows it,
	  and how many of its quests are done (a check once they have the key). Beneath its text come
	  the quests themselves, under the same headers as on the Quests tab; a click opens one there.
	  a hidden boss's header carries a skull, and opens on how to summon it.
	The Quests tab heads its list with the same keys (BeforeYouGo:Keys).
]]

local BeforeYouGo = {}
ns.BeforeYouGo = BeforeYouGo

local WIDTH, INDENT, GAP, BAR_HEIGHT = 310, 15, 9, 30
local HIDDEN_BOSS_ICON = "Interface\\TargetingFrame\\UI-TargetingFrame-Skull"
local HAVE_MARK = "|TInterface\\Buttons\\UI-CheckBox-Check:16:16|t"
-- The Quests tab's green, dark enough for the parchment.
local HAVE_COLOR = "|cff1e7d00"

function BeforeYouGo:Entries(instance)
	local list = {}
	local faction = UnitFactionGroup and UnitFactionGroup("player")
	for _, entry in ipairs(instance.prepare or {}) do
		if not entry.faction or entry.faction == faction then list[#list + 1] = entry end
	end
	return list
end

-- How far along a key's quests the player is: how many are done, of how many, and whether they
-- have the key (its last quest taken or done).
function BeforeYouGo:Progress(entry)
	local quests = entry.quests or {}
	local done = 0
	for _, questID in ipairs(quests) do
		if ns.QuestsPanel:IsDone(questID) then done = done + 1 end
	end
	local last = quests[#quests]
	local have = last ~= nil and (ns.QuestsPanel:IsDone(last) or ns.QuestsPanel:InLog(last))
	return done, #quests, have
end

-- A key's quests as the Quests tab lists them; steps it shows as one are listed once.
local function KeyQuests(instance, entry)
	local quests = {}
	for _, questID in ipairs(entry.quests or {}) do
		local quest = ns.QuestsPanel:Find(instance, questID)
		if quest and quests[#quests] ~= quest then quests[#quests + 1] = quest end
	end
	return quests
end

-- The mark of the first quest still to do; a check once the player has the key.
local function KeyStatus(quests, have)
	local done = ns.QuestsPanel.STATUS_DONE
	if have then return done end
	for _, quest in ipairs(quests) do
		local status = ns.QuestsPanel:Status(quest)
		if status ~= done then return status end
	end
	return done
end

--[[
	The keys of a dungeon for the player's side, as headers show them: { key, entry, title, status,
	note, have, done, total, quests }. The overview and the Quests tab both list them.
]]
function BeforeYouGo:Keys(instance)
	local keys = {}
	for index, entry in ipairs(self:Entries(instance)) do
		if entry.quests and #entry.quests > 0 then
			local quests = KeyQuests(instance, entry)
			local done, total, have = self:Progress(entry)
			keys[#keys + 1] = {
				key = "prepare:" .. index, entry = entry, title = entry.title,
				status = KeyStatus(quests, have), note = have and HAVE_MARK or string.format("%d/%d", done, total),
				have = have, done = done, total = total, quests = quests,
			}
		end
	end
	return keys
end

-- An entry as a paper header's section, with the quests beneath it.
local function Section(entry, index, keys)
	local section = { key = "prepare:" .. index, title = entry.title, flags = {}, startsOpen = true }
	for _, key in ipairs(keys) do
		if key.entry == entry then
			section.status, section.note, section.startsOpen = key.status, key.note, not key.have
			local progress = key.have and (HAVE_COLOR .. L.PREPARE_HAVE .. "|r")
				or string.format(L.PREPARE_PROGRESS, key.done, key.total)
			section.description = entry.text .. "\n\n" .. progress
			return section, key.quests
		end
	end
	section.icon = HIDDEN_BOSS_ICON
	section.description = entry.text
	return section, {}
end

-- Whether a note is open: as built (startsOpen) until the player clicks it, after which their
-- choice holds while the dungeon stays shown.
local function IsExpanded(state, section)
	local open = state.expanded[section.key]
	if open ~= nil then return open end
	return section.startsOpen
end

-- A key's quest, under a header as on the Quests tab: a click opens it there.
local function CreateQuestHeader(child, state)
	local header = ns.PaperHeader.Create(child, function(section)
		ns.QuestsPanel:Open(state.instance, section.quest)
	end)
	header.Button:HookScript("OnEnter", function(self)
		local quest = header.section and header.section.quest
		if not quest then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(quest.name or "", 1, 1, 1)
		if ns.QuestsPanel:Status(quest) == ns.QuestsPanel.STATUS_LOCKED then
			GameTooltip:AddLine(ns.QuestsPanel:LockedReason(quest), 1, 0.3, 0.3, true)
		end
		GameTooltip:AddLine(L.PREPARE_QUEST_HINT, 0.1, 1, 0.1, true)
		GameTooltip:Show()
	end)
	header.Button:HookScript("OnLeave", function() GameTooltip:Hide() end)
	return header
end

local function CreateState(lore)
	local child = lore.Child
	local state = { headers = {}, rows = {}, expanded = {} }
	state.bar = child:CreateTexture(nil, "ARTWORK")
	ns.Art(state.bar, "Header-Overview")
	state.bar:SetWidth(WIDTH + 6)
	state.label = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	state.label:SetPoint("BOTTOMLEFT", state.bar, "BOTTOMLEFT", 8, 6)
	state.label:SetText(L.PREPARE_TITLE)
	local color = ns.HEADER_LABEL_COLOR
	state.label:SetTextColor(color[1], color[2], color[3])
	state.toggle = function(section)
		state.expanded[section.key] = not IsExpanded(state, section)
		ns.EncounterPage:LayoutLore(lore)
	end
	lore.beforeYouGo = state
	BeforeYouGo.lore = lore
	return state
end

--[[
	Lays the notes out in the overview's text, from y down, and returns where they end; nil when the
	dungeon has none for the player's side.
]]
function BeforeYouGo:Fill(lore, instance, y)
	local state = lore.beforeYouGo or CreateState(lore)
	if state.instance ~= instance then state.instance, state.expanded = instance, {} end
	local entries = self:Entries(instance)
	local keys = self:Keys(instance)
	local child = lore.Child
	local usedHeaders, usedRows = 0, 0

	state.bar:SetShown(#entries > 0)
	state.label:SetShown(#entries > 0)
	if #entries > 0 then
		state.bar:ClearAllPoints()
		state.bar:SetPoint("TOPLEFT", -4, -y)
		y = y + BAR_HEIGHT + 4
	end
	for index, entry in ipairs(entries) do
		local section, quests = Section(entry, index, keys)
		usedHeaders = usedHeaders + 1
		local header = state.headers[usedHeaders]
		if not header then
			header = ns.PaperHeader.Create(child, state.toggle)
			state.headers[usedHeaders] = header
		end
		header:ClearAllPoints()
		header:SetPoint("TOPLEFT", 0, -y)
		header:SetWidth(WIDTH)
		-- Settled as the dungeon is shown: taking the key's last quest doesn't fold its note.
		if state.expanded[section.key] == nil then state.expanded[section.key] = section.startsOpen end
		local expanded = IsExpanded(state, section)
		y = y + ns.PaperHeader.Set(header, section, 0, expanded) + GAP
		header:Show()
		if expanded then
			for _, quest in ipairs(quests) do
				usedRows = usedRows + 1
				local row = state.rows[usedRows]
				if not row then
					row = CreateQuestHeader(child, state)
					state.rows[usedRows] = row
				end
				row:ClearAllPoints()
				row:SetPoint("TOPLEFT", INDENT, -y)
				row:SetWidth(WIDTH - INDENT)
				y = y + ns.PaperHeader.Set(row, ns.QuestsPanel:QuestSection(quest), 1, false) + GAP
				row:Show()
			end
		end
	end
	for index = usedHeaders + 1, #state.headers do state.headers[index]:Hide() end
	for index = usedRows + 1, #state.rows do state.rows[index]:Hide() end
	return #entries > 0 and y or nil
end

-- A key's quests change as the player takes and hands them in: the shown overview follows.
local events = CreateFrame("Frame")
local queued = false
ns.RegisterEvents(events, "QUEST_LOG_UPDATE", "QUEST_TURNED_IN")
events:SetScript("OnEvent", function()
	local lore = BeforeYouGo.lore
	local state = lore and lore.beforeYouGo
	if queued or not (state and lore:IsVisible() and state.instance and state.instance.prepare) then return end
	queued = true
	C_Timer.After(0.2, function()
		queued = false
		if lore:IsVisible() then ns.EncounterPage:LayoutLore(lore) end
	end)
end)
