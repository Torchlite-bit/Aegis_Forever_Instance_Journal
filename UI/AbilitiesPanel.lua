local _, ns = ...
local L = ns.L

--[[
	The Abilities tab's right page: retail's detailsScroll, a tree of collapsible paper
	headers (EncounterInfoTemplate) with the spell's icon, its role alerts on the right, and
	its description beneath on the parchment text panel.

	Where the tree comes from, best first:
	  boss.stages          hand-written phases, each listing the spells used in it
	  boss.abilities       the boss's spells ({ spellID, name, flags, text }: Data/Authored/
	                       Abilities.lua), with what players' recorded runs measured (generated)
	  boss.extraAbilities  abilities with no spell id ({ title, icon, description, flags })
	  boss.adds            the creatures that fight beside it, with their spells (recorded runs)
	Names and icons of spells come from the client, descriptions from the ability's text where
	written, then boss.spellText (for the spells of the boss's adds, which only recorded runs
	list), else the client. Role alerts come from the ability's flags, then boss.spellFlags where
	written by hand, and otherwise from the spell itself. boss.fightNote, above the tree,
	says how the fight begins where that is unusual.
]]

local AbilitiesPanel = {}
ns.AbilitiesPanel = AbilitiesPanel

local HEADER_HEIGHT, HEADER_INDENT, CONTENT_WIDTH = 24, 15, 320
local MAX_FLAGS = 4

-- Retail's flag order (Enum.JournalEncounterIconFlags), its icons and tooltip strings.
local FLAGS = { "Tank", "Damage", "Healer", "Heroic", "Deadly", "Important", "Interruptible",
	"Magic", "Curse", "Poison", "Disease", "Enrage", "Mythic", "Bleed" }
local FLAG_INDEX = {}
for index, name in ipairs(FLAGS) do FLAG_INDEX[name] = index - 1 end
local FLAG_ATLASES = {
	[0] = "icons_16x16_tank", [1] = "icons_16x16_damage", [2] = "icons_16x16_heal", [3] = "icons_16x16_heroic",
	[4] = "icons_16x16_deadly", [5] = "icons_16x16_important", [6] = "icons_16x16_interrupt", [7] = "icons_16x16_magic",
	[8] = "icons_16x16_curse", [9] = "icons_16x16_poison", [10] = "icons_16x16_disease", [11] = "icons_16x16_enrage",
	[12] = "icons_16x16_mythic", [13] = "icons_16x16_bleed",
}
local FLAG_FALLBACK_NAMES = { [0] = "Tank Alert", [1] = "Damage Dealer Alert", [2] = "Healer Alert", [3] = "Heroic Difficulty",
	[4] = "Deadly", [5] = "Important", [6] = "Interruptible", [7] = "Magic Effect", [8] = "Curse Effect",
	[9] = "Poison Effect", [10] = "Disease Effect", [11] = "Enrage", [12] = "Mythic Difficulty", [13] = "Bleed" }
local LEGACY_ICONS = "Interface\\EncounterJournal\\UI-EJ-Icons"

local SCHOOL_PHYSICAL = 1

local function Color(globalName, r, g, b)
	local color = _G[globalName]
	if type(color) == "table" and color.GetRGB then return { color:GetRGB() } end
	return { r, g, b }
end
local EXPANDED_COLOR = Color("PAPER_FRAME_EXPANDED_COLOR", 0.929, 0.788, 0.620)
local COLLAPSED_COLOR = Color("PAPER_FRAME_COLLAPSED_COLOR", 0.776, 0.635, 0.471)
local STATS_COLOR = "|cff6b4a2a"

------------------------------------------------------------------------------------------
-- Role alerts
------------------------------------------------------------------------------------------

-- Retail's EncounterJournal_SetFlagIcon: the 16px atlas where the client has it, the old icon sheet otherwise.
function ns.SetFlagIcon(texture, index)
	local atlas = FLAG_ATLASES[index]
	if atlas and ns.AtlasExists(atlas) then
		texture:SetAtlas(atlas, true)
		texture:SetTexCoord(0, 1, 0, 1)
		return
	end
	local columns, rows = 8, 2
	local left = (index % columns) / columns
	local top = math.floor(index / columns) / rows
	texture:SetTexture(LEGACY_ICONS)
	texture:SetTexCoord(left, left + 1 / columns, top, top + 1 / rows)
	texture:SetSize(20, 20)
end

function ns.FlagTooltip(index)
	local title = _G["ENCOUNTER_JOURNAL_SECTION_FLAG" .. index] or FLAG_FALLBACK_NAMES[index]
	local text = _G["ENCOUNTER_JOURNAL_SECTION_FLAG_DESCRIPTION" .. index]
	return title, text
end

-- Role alerts read from the spell when nobody has written them down.
local function AutoFlags(row, castTime, description)
	local flags, text = {}, string.lower((row.name or "") .. " " .. (description or ""))
	local function add(name)
		if #flags < MAX_FLAGS then flags[#flags + 1] = name end
	end
	if row.onSelf then add("Important") end
	if castTime and castTime > 0 then add("Interruptible") end
	if row.school == SCHOOL_PHYSICAL and not row.onSelf then add("Tank") end
	if row.tick then add("Healer") end
	if text:find("poison", 1, true) then add("Poison") end
	if text:find("curse", 1, true) then add("Curse") end
	if text:find("disease", 1, true) or text:find("plague", 1, true) then add("Disease") end
	if text:find("bleed", 1, true) then add("Bleed") end
	if text:find("enrage", 1, true) or text:find("frenzy", 1, true) then add("Enrage") end
	if text:find("summon", 1, true) or text:find("allies", 1, true) then add("Damage") end
	return flags
end

------------------------------------------------------------------------------------------
-- The tree
------------------------------------------------------------------------------------------

-- A recorded range, "25-30", or one number where it never varied.
local function Range(pair)
	if pair[1] == pair[2] then return tostring(pair[1]) end
	return pair[1] .. "-" .. pair[2]
end

local function StatsLine(row)
	local parts = {}
	if row.hit then parts[#parts + 1] = string.format(L.STATS_HIT, Range(row.hit)) end
	if row.tick then parts[#parts + 1] = string.format(L.STATS_TICK, Range(row.tick)) end
	if row.firstCast then parts[#parts + 1] = string.format(L.STATS_FIRST, row.firstCast) end
	if row.every then parts[#parts + 1] = string.format(L.STATS_EVERY, Range(row.every)) end
	if #parts == 0 then return nil end
	return STATS_COLOR .. table.concat(parts, ", ") .. "|r"
end

local function SpellSection(boss, row)
	local spellID = row.spellID
	local name, icon, castTime = row.name, nil, nil
	if C_Spell and C_Spell.GetSpellInfo then
		local ok, info = pcall(C_Spell.GetSpellInfo, spellID)
		if ok and info then name, icon, castTime = info.name or name, info.iconID, info.castTime end
	end
	local description
	if C_Spell and C_Spell.GetSpellDescription then
		local ok, text = pcall(C_Spell.GetSpellDescription, spellID)
		if ok and text and text ~= "" then
			-- Spell names inside descriptions come in white, which clashes with the parchment.
			description = text:gsub("|cffffffff(.-)|r", "%1")
		end
	end
	if not description and C_Spell and C_Spell.RequestLoadSpellData then pcall(C_Spell.RequestLoadSpellData, spellID) end

	-- Role alerts given with the ability, else written for the boss, else read from the spell.
	local written = row.flags or boss.spellFlags and boss.spellFlags[spellID]
	local stats = StatsLine(row)
	-- What the ability does in the fight, where written down, over the spell's own tooltip text.
	local body = row.text or (boss.spellText and boss.spellText[spellID]) or description or L.ABILITY_LOADING
	return {
		key = "spell:" .. spellID,
		spellID = spellID,
		title = name or ("#" .. spellID),
		icon = icon,
		description = stats and (body .. "\n\n" .. stats) or body,
		flags = written or AutoFlags(row, castTime, description),
	}
end

local function WrittenSection(entry, index)
	return {
		key = "written:" .. (entry.title or index),
		title = entry.title,
		icon = entry.icon,
		description = entry.description,
		flags = entry.flags or {},
	}
end

-- Builds the boss's tree: { title, icon, description, flags, children, key }.
function AbilitiesPanel:BuildSections(boss)
	local bySpell, placed, sections = {}, {}, {}
	for _, row in ipairs(boss.abilities or {}) do
		if row.spellID then bySpell[row.spellID] = row end
	end

	for index, stage in ipairs(boss.stages or {}) do
		local section = { key = "stage:" .. index, title = stage.title, description = stage.description,
			flags = stage.flags or {}, children = {}, startsOpen = true }
		for _, spellID in ipairs(stage.spells or {}) do
			local row = bySpell[spellID] or { spellID = spellID }
			section.children[#section.children + 1] = SpellSection(boss, row)
			placed[spellID] = true
		end
		sections[#sections + 1] = section
	end
	for _, row in ipairs(boss.abilities or {}) do
		if row.spellID and not placed[row.spellID] then sections[#sections + 1] = SpellSection(boss, row) end
	end
	for index, entry in ipairs(boss.extraAbilities or {}) do
		sections[#sections + 1] = WrittenSection(entry, index)
	end
	-- The creatures that fight beside the boss, each under its own header with its spells, as
	-- retail's journal lists an encounter's adds.
	for _, add in ipairs(boss.adds or {}) do
		local section = { key = "add:" .. (add.npcID or add.name), title = add.name,
			description = string.format(L.ADD_DESCRIPTION, boss.name), flags = {}, children = {}, startsOpen = true }
		for _, row in ipairs(add.abilities or {}) do
			section.children[#section.children + 1] = SpellSection(boss, row)
		end
		sections[#sections + 1] = section
	end

	-- Stages open with their spells closed; a fight without stages opens each ability.
	if not boss.stages then
		for _, section in ipairs(sections) do section.startsOpen = true end
	end
	return sections
end

------------------------------------------------------------------------------------------
-- Section headers (EncounterInfoTemplate)
------------------------------------------------------------------------------------------

local function StripTextures(button, prefix, layer, subLevel)
	local left = button:CreateTexture(nil, layer, nil, subLevel)
	ns.Art(left, prefix .. "-Left")
	left:SetPoint("LEFT", -1, -1)
	local right = button:CreateTexture(nil, layer, nil, subLevel)
	ns.Art(right, prefix .. "-Right")
	right:SetPoint("RIGHT", 3, -1)
	local mid = button:CreateTexture(nil, layer, nil, (subLevel or 0) - 2)
	ns.Art(mid, prefix .. "-Mid")
	mid:ClearAllPoints()
	mid:SetPoint("LEFT", left, "RIGHT", -32, 0)
	mid:SetPoint("RIGHT", right, "LEFT", 32, 0)
	return { left, mid, right }
end

local function ShowStrip(strip, shown)
	for _, texture in ipairs(strip) do texture:SetShown(shown) end
end

local function CreateHeader(parent)
	local header = CreateFrame("Frame", nil, parent)
	header:SetHeight(HEADER_HEIGHT)

	local button = CreateFrame("Button", nil, header)
	button:SetHeight(HEADER_HEIGHT)
	button:SetPoint("TOPLEFT")
	button:SetPoint("RIGHT")
	header.Button = button

	button.strips = {
		collapsed = { up = StripTextures(button, "PaperHeader-UnSelectUp", "BACKGROUND", 0),
			down = StripTextures(button, "PaperHeader-UnSelectDown", "BACKGROUND", 0) },
		expanded = { up = StripTextures(button, "PaperHeader-SelectUp", "BACKGROUND", 0),
			down = StripTextures(button, "PaperHeader-SelectDown", "BACKGROUND", 0) },
	}
	StripTextures(button, "PaperHeader-Highlight", "HIGHLIGHT", 0)

	button.ExpandedIcon = button:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	button.ExpandedIcon:SetSize(12, 12)
	button.ExpandedIcon:SetPoint("LEFT", 5, 0)
	button.AbilityIcon = button:CreateTexture(nil, "OVERLAY")
	button.AbilityIcon:SetSize(18, 18)
	button.AbilityIcon:SetPoint("LEFT", button.ExpandedIcon, "RIGHT", 5, 0)
	button.Title = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	button.Title:SetHeight(10)
	button.Title:SetJustifyH("LEFT")
	button.Title:SetWordWrap(false)

	button.Flags = {}
	for index = 1, MAX_FLAGS do
		local flag = CreateFrame("Frame", nil, button)
		flag:SetSize(32, 32)
		if index == 1 then
			flag:SetPoint("RIGHT", 5, 0)
		else
			flag:SetPoint("RIGHT", button.Flags[index - 1], "LEFT", 10, 0)
		end
		flag.Icon = flag:CreateTexture(nil, "OVERLAY")
		flag.Icon:SetSize(16, 16)
		flag.Icon:SetPoint("CENTER")
		flag:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipTitle or "", 1, 1, 1)
			if self.tooltipText then GameTooltip:AddLine(self.tooltipText, nil, nil, nil, true) end
			GameTooltip:Show()
		end)
		flag:SetScript("OnLeave", function() GameTooltip:Hide() end)
		button.Flags[index] = flag
	end

	header.Description = header:CreateFontString(nil, "ARTWORK", "GameFontBlack")
	header.Description:SetPoint("TOP", button, "BOTTOM", 0, -9)
	header.Description:SetJustifyH("LEFT")
	local color = ns.PARCHMENT_TEXT_COLOR
	header.Description:SetTextColor(color[1], color[2], color[3])
	header.DescriptionBG = header:CreateTexture(nil, "BACKGROUND")
	ns.Art(header.DescriptionBG, "AbilityTextBG")
	header.DescriptionBG:ClearAllPoints()
	header.DescriptionBG:SetPoint("TOPLEFT", header.Description, -9, 12)
	header.DescriptionBG:SetPoint("BOTTOMRIGHT", header.Description, 9, -11)
	header.DescriptionBottom = header:CreateTexture(nil, "BACKGROUND")
	ns.Art(header.DescriptionBottom, "AbilityTextBottomBorder")
	header.DescriptionBottom:ClearAllPoints()
	header.DescriptionBottom:SetPoint("LEFT", header.DescriptionBG, "BOTTOMLEFT")
	header.DescriptionBottom:SetPoint("RIGHT", header.DescriptionBG, "BOTTOMRIGHT")

	button:SetScript("OnMouseDown", function(self)
		ShowStrip(self.strip.up, false)
		ShowStrip(self.strip.down, true)
	end)
	button:SetScript("OnMouseUp", function(self)
		ShowStrip(self.strip.down, false)
		ShowStrip(self.strip.up, true)
	end)
	button:SetScript("OnClick", function()
		ns.PlaySoundKit("IG_MAINMENU_OPTION_CHECKBOX_ON")
		AbilitiesPanel:Toggle(header.section)
	end)
	button:SetScript("OnEnter", function(self)
		if self.Title.IsTruncated and self.Title:IsTruncated() then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.Title:GetText(), nil, nil, nil, nil, true)
		end
	end)
	button:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return header
end

local function SetHeader(header, section, depth, expanded)
	header.section = section
	local button = header.Button
	button.ExpandedIcon:SetText(expanded and "-" or "+")

	-- Top-level sections use the larger font, as on retail.
	button.Title:SetFontObject(depth == 0 and ns.Font("GameFontNormalMed3", "GameFontNormal") or "GameFontNormal")
	button.Title:SetText(section.title or "")
	button.Title:ClearAllPoints()
	if section.icon then
		button.AbilityIcon:SetTexture(section.icon)
		button.AbilityIcon:Show()
		button.Title:SetPoint("LEFT", button.AbilityIcon, "RIGHT", 5, -1)
	else
		button.AbilityIcon:Hide()
		button.Title:SetPoint("LEFT", button.ExpandedIcon, "RIGHT", 5, -1)
	end

	local lastFlag
	for index, flag in ipairs(button.Flags) do
		local name = section.flags and section.flags[index]
		local flagIndex = name and FLAG_INDEX[name]
		flag:SetShown(flagIndex ~= nil)
		if flagIndex then
			ns.SetFlagIcon(flag.Icon, flagIndex)
			flag.tooltipTitle, flag.tooltipText = ns.FlagTooltip(flagIndex)
			lastFlag = flag
		end
	end
	button.Title:SetPoint("RIGHT", lastFlag or button, lastFlag and "LEFT" or "RIGHT", -5, 0)

	local textColor = expanded and EXPANDED_COLOR or COLLAPSED_COLOR
	button.Title:SetTextColor(textColor[1], textColor[2], textColor[3])
	button.ExpandedIcon:SetTextColor(textColor[1], textColor[2], textColor[3])
	button.strip = expanded and button.strips.expanded or button.strips.collapsed
	for _, state in pairs(button.strips) do
		ShowStrip(state.up, false)
		ShowStrip(state.down, false)
	end
	ShowStrip(button.strip.up, true)

	local hasText = expanded and section.description and section.description ~= ""
	header.Description:SetShown(hasText)
	header.DescriptionBG:SetShown(hasText)
	header.DescriptionBottom:SetShown(hasText)
	if hasText then
		header.Description:SetWidth(header:GetWidth() - 20)
		header.Description:SetText(section.description)
	end
	return hasText and (HEADER_HEIGHT + 9 + header.Description:GetStringHeight() + 20) or HEADER_HEIGHT
end

------------------------------------------------------------------------------------------
-- The page
------------------------------------------------------------------------------------------

function AbilitiesPanel:Create(page, info)
	local scroll = ns.CreateScrollFrame(info, -15, -6, 6)
	scroll:SetSize(350, 383)
	scroll:SetPoint("BOTTOMRIGHT", -5, 1)
	scroll:SetFrameLevel(info:GetFrameLevel() + 5)
	scroll:Hide()
	scroll.Child:SetWidth(CONTENT_WIDTH)
	scroll.page = page
	scroll.Headers = {}
	scroll.expanded = {}

	local child = scroll.Child
	child.Description = child:CreateFontString(nil, "ARTWORK", "GameFontBlack")
	child.Description:SetPoint("TOPLEFT", 2, -8)
	child.Description:SetWidth(CONTENT_WIDTH - 5)
	child.Description:SetJustifyH("LEFT")
	local color = ns.PARCHMENT_TEXT_COLOR
	child.Description:SetTextColor(color[1], color[2], color[3])

	child.Empty = child:CreateFontString(nil, "ARTWORK", "GameFontBlack")
	child.Empty:SetPoint("TOPLEFT", child.Description, "BOTTOMLEFT", 0, -12)
	child.Empty:SetWidth(CONTENT_WIDTH - 5)
	child.Empty:SetJustifyH("LEFT")
	child.Empty:SetTextColor(color[1], color[2], color[3])
	child.Empty:SetText(L.ABILITIES_NONE)

	scroll:SetScript("OnShow", function(self) AbilitiesPanel:Refresh(self) end)
	-- Spell descriptions can arrive a moment after they are first asked for.
	scroll:RegisterEvent("SPELL_DATA_LOAD_RESULT")
	scroll:SetScript("OnEvent", function(self)
		if self:IsVisible() and not self.refreshQueued then
			self.refreshQueued = true
			C_Timer.After(0.1, function()
				self.refreshQueued = nil
				if self:IsVisible() then AbilitiesPanel:Refresh(self) end
			end)
		end
	end)

	self.scroll = scroll
	return scroll
end

-- Whether a section is open: as built (startsOpen) until the player clicks it, after
-- which their choice holds while the boss stays shown.
local function IsExpanded(scroll, section)
	local state = scroll.expanded[section.key]
	if state ~= nil then return state end
	return section.startsOpen == true
end

function AbilitiesPanel:Toggle(section)
	local scroll = self.scroll
	scroll.expanded[section.key] = not IsExpanded(scroll, section)
	self:Refresh(scroll)
end

function AbilitiesPanel:Refresh(scroll)
	local page = scroll.page
	local boss = page.boss
	if not boss then return end
	if scroll.bossShown ~= boss then
		scroll.bossShown = boss
		scroll.expanded = {}
		scroll.sections = self:BuildSections(boss)
		scroll:SetVerticalScroll(0)
	else
		-- Rebuilt each time so spell text that has since loaded is used.
		scroll.sections = self:BuildSections(boss)
	end

	local child = scroll.Child
	-- The boss's description, then how the fight begins, where it is unusual (boss.fightNote).
	local intro = {}
	if boss.description and boss.description ~= "" then intro[#intro + 1] = boss.description end
	if boss.fightNote then intro[#intro + 1] = boss.fightNote end
	child.Description:SetText(table.concat(intro, "\n\n"))
	local y = 8 + (#intro > 0 and child.Description:GetStringHeight() + 12 or 0)

	local used = 0
	local function place(section, depth)
		used = used + 1
		local header = scroll.Headers[used]
		if not header then
			header = CreateHeader(child)
			scroll.Headers[used] = header
		end
		header:ClearAllPoints()
		header:SetPoint("TOPLEFT", depth * HEADER_INDENT, -y)
		header:SetWidth(CONTENT_WIDTH - depth * HEADER_INDENT)
		local expanded = IsExpanded(scroll, section)
		local height = SetHeader(header, section, depth, expanded)
		header:Show()
		y = y + height + 9
		if expanded and section.children then
			for _, childSection in ipairs(section.children) do place(childSection, depth + 1) end
		end
	end
	for _, section in ipairs(scroll.sections) do place(section, 0) end
	for index = used + 1, #scroll.Headers do scroll.Headers[index]:Hide() end

	child.Empty:SetShown(#scroll.sections == 0)

	child:SetHeight(math.max(1, y + 10))
end
