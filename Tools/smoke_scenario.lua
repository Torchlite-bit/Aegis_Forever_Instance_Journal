-- Clicks through the journal against the mock client and checks what it shows.
local ns = ...
local Mock = WOWMOCK
local checks = 0

local function check(condition, message)
	checks = checks + 1
	if not condition then error("check failed: " .. message, 2) end
end

local function visibleButtons(panel)
	local names = {}
	for _, button in ipairs(panel.Buttons) do
		if button:IsShown() then names[#names + 1] = button.Name:GetText() end
	end
	return names
end

local function buttonNamed(panel, name)
	for _, button in ipairs(panel.Buttons) do
		if button:IsShown() and button.Name:GetText() == name then return button end
	end
	error("no visible button named " .. name, 2)
end

local function choiceNamed(choices, text)
	for _, choice in ipairs(choices) do
		if choice.text == text then return choice end
	end
	error("no choice named " .. text, 2)
end

local function chatContains(text)
	for _, line in ipairs(Mock.chat) do
		if line:find(text, 1, true) then return true end
	end
	return false
end

-- Login
Mock.Fire("ADDON_LOADED", "Aegis_Forever_Instance_Journal")
Mock.Fire("PLAYER_LOGIN")
check(ns.db and ns.charDB, "saved variables initialised")
-- Recording by itself in dungeons is on for players; the scenario turns it on where it tests it.
ns.Recorder:SetAutoRecord(false)
check(Mock.bindings["SHIFT-J"] == "AEGISJOURNAL_TOGGLE", "Shift+J bound on first login")
check(Mock.bindingsSaved == 1, "binding saved to the set in use")
check(chatContains("Shift+J now opens"), "player told about Shift+J")
-- The character's own bindings, where Shift+J still holds this journal's binding from before
-- its rename: offered there too, once
Mock.bindingSet, Mock.bindings = 2, { ["SHIFT-J"] = "AEGISIJ_TOGGLE" }
Mock.Fire("UPDATE_BINDINGS")
check(Mock.bindings["SHIFT-J"] == "AEGISJOURNAL_TOGGLE" and Mock.bindingsSaved == 2, "the old binding's Shift+J taken back in the character's set")
Mock.bindings["SHIFT-J"] = nil
Mock.Fire("UPDATE_BINDINGS")
check(Mock.bindings["SHIFT-J"] == nil, "once offered, the player's own choice stands")
Mock.bindingSet, Mock.bindings = nil, { ["SHIFT-J"] = "AEGISJOURNAL_TOGGLE" }

-- Data
check(#ns.GetInstances("dungeon") == 35, "thirty-five dungeons listed, got " .. #ns.GetInstances("dungeon"))
check(ns.GetInstance("TheDrownedCity") and not ns.GetInstance("TheDrownedCity").hidden,
	"Forever's unreleased dungeons are listed again, as placeholders")
check(#ns.GetInstances("raid") == 3 and ns.GetInstance("OnyxiasLair").comingSoon and ns.GetInstance("BarrowDeeps").forever,
	"three raids waiting to open, Forever's own marked")
-- The returning classic dungeons: the site's bosses, loot and quests on ADG's maps
do
	local depths = ns.GetInstance("BlackrockDepths")
	local floors, arena = depths.map.floors, {}
	for _, boss in ipairs(depths.bosses) do
		if boss.name:find("^Ring of Law") then arena[#arena + 1] = boss end
	end
	check(#floors == 2 and floors[1].uiMapID == 242 and floors[1].art:find("Media\\Maps\\Classic\\BlackrockDepths", 1, true)
		and depths.floorNames[2] == "Shadowforge City", "Blackrock Depths on its two floors, named")
	check(#arena == 6 and arena[1].maybe and arena[1].mapPin.x == arena[6].mapPin.x,
		"the Ring of Law's six challengers share the arena, each a maybe")
	local temple = ns.GetInstance("TempleOfAtalHakkar")
	local balcony
	for _, boss in ipairs(temple.bosses) do if boss.name == "Balcony Minibosses" then balcony = boss end end
	check(balcony and balcony.together and #balcony.mapPins == 6, "the balcony's six trolls, a sure pin each")
end
-- Wings by area, where several share the client's instance id
Mock.subzone = "Dragonspire Hall"
check(ns.GetInstanceByInstanceID(229).key == "UpperBlackrockSpire", "in Dragonspire Hall: Upper Blackrock Spire")
Mock.subzone = "Skitterweb Tunnels"
check(ns.GetInstanceByInstanceID(229).key == "LowerBlackrockSpire", "in the Skitterweb Tunnels: Lower Blackrock Spire")
Mock.subzone = "Gordok Commons"
check(ns.GetInstanceByInstanceID(429).key == "DireMaulNorth", "in Gordok Commons: Dire Maul's north wing")
Mock.subzone = "The Gauntlet"
check(ns.GetInstanceByInstanceID(329).key == "StratholmeServiceGate", "in the Gauntlet: Stratholme's service gate")
Mock.subzone = ""
check(#ns.GetFactions() > 0, "factions registered")
check(ns.GetInstanceByInstanceID(3065).key == "HallOfThanes", "Hall of Thanes found by instance id")

-- The Scarlet Monastery's wings share the client's instance id: told apart by the area
local graveyard, library = ns.GetInstance("ScarletMonasteryGraveyard"), ns.GetInstance("ScarletMonasteryLibrary")
check(graveyard.sharesInstanceID and library.sharesInstanceID and not ns.GetInstance("HallOfThanes").sharesInstanceID,
	"the wings know they share an instance id")
Mock.subzone = "Athenaeum"
check(ns.GetInstanceByInstanceID(189) == library, "in the Athenaeum: the Library")
Mock.subzone = "Forlorn Cloister"
check(ns.GetInstanceByInstanceID(189) == graveyard, "in the Forlorn Cloister: the Graveyard")
Mock.subzone = ""
check(ns.GetInstanceByInstanceID(189) == graveyard, "in a nameless spot, the wing last seen")
Mock.subzone = "Huntsman's Cloister"
ns.GetInstanceByInstanceID(189)
Mock.subzone = ""
check(ns.GetInstanceByInstanceID(189) == library, "even when that was the other one")
Mock.subzone = "Hall of Champions"
check(ns.GetInstanceByInstanceID(189).key == "ScarletMonasteryArmory", "in the Hall of Champions: the Armory")
Mock.subzone = "Chapel Gardens"
check(ns.GetInstanceByInstanceID(189).key == "ScarletMonasteryCathedral", "in the Chapel Gardens: the Cathedral")
Mock.subzone = "Huntsman's Cloister"
ns.GetInstanceByInstanceID(189)
Mock.subzone = ""
check(ns.DungeonMap:Entrance(library) == library.zoneEntrance, "wings keep their own doors, not a shared recording")

-- Art given as candidates: the first file the client has
check(ns.GetInstance("BlackfathomDeeps").buttonImage == "Interface\\EncounterJournal\\UI-EJ-DUNGEONBUTTON-BlackfathomDeeps"
	and ns.GetInstance("BlackfathomDeeps").loreImage == "Interface\\EncounterJournal\\UI-EJ-LOREBG-BlackfathomDeeps",
	"Blizzard's journal art by name for the newer classic dungeons")
check(ns.GetInstance("ScarletMonasteryLibrary").buttonImage == "Interface\\EncounterJournal\\UI-EJ-DUNGEONBUTTON-ScarletHalls",
	"the Library takes the Scarlet Halls picture first")

-- Map tiles given as candidates: the first folder the client has; a floor with none leaves the dungeon without a map
Mock.missingFiles["Interface\\WorldMap\\Sunken\\Sunken1_1"] = true
Mock.missingFiles["Interface\\WorldMap\\Gone\\Gone1_1"] = true
ns.AddInstance({ key = "TileCandidates", kind = "test", map = { floors = {
	{ uiMapID = 1, tiles = { "Interface\\WorldMap\\Sunken\\Sunken1_", "Interface\\WorldMap\\Temple\\Temple1_" } } } } })
ns.AddInstance({ key = "TileMissing", kind = "test", map = { floors = {
	{ uiMapID = 1, tiles = { "Interface\\WorldMap\\Temple\\Temple1_" } }, { uiMapID = 2, tiles = { "Interface\\WorldMap\\Gone\\Gone1_" } } } } })
check(ns.GetInstance("TileCandidates").map.floors[1].tiles == "Interface\\WorldMap\\Temple\\Temple1_",
	"the first tile folder the client has")
check(ns.GetInstance("TileMissing").map.floors == nil and not ns.DungeonMap:HasMap(ns.GetInstance("TileMissing")),
	"no map rather than one with a blank floor")

-- Placeholders for Forever's announced dungeons
local drowned = ns.GetInstance("TheDrownedCity")
check(drowned and drowned.untested and drowned.levelMin == 35 and #drowned.bosses == 4 and not drowned.instanceID,
	"The Drowned City waits as a placeholder with its announced bosses")
check(ns.GetInstance("ShapersTerrace").untested and ns.GetInstance("CityOfDalaran").untested
	and not ns.GetInstance("TheDeadmines").untested, "untested dungeons are marked, tested ones are not")

-- Open with the key binding's function, as a character who last had Record open when it was the
-- fourth tab: it reopens on Record, now the fifth
ns.charDB.lastTab = 4
AegisJournal_Toggle()
local f = AegisJournalFrame
check(f and f:IsShown(), "journal opens")
check(f._title == "Instance Journal", "title set")
check(f.selectedTab == 5 and f.Panels[5]:IsShown() and ns.charDB.lastTab == "record",
	"a tab saved by its place reopens as the same tab, saved by its name from then on")
f.Tabs[1]:Click()
check(f.selectedTab == 1, "Dungeons tab selected")

local dungeons, raids, reputation = f.Panels[1], f.Panels[2], f.Panels[3]
check(dungeons:IsShown() and not raids:IsShown() and not reputation:IsShown(), "only the Dungeons panel shows")

local names = visibleButtons(dungeons)
check(#names == 35, "thirty-five dungeon buttons, got " .. #names)
-- Sorted by the level they start at, then by name
local function sortedByLevel(list)
	local previous
	for _, name in ipairs(list) do
		local instance
		for _, candidate in ipairs(ns.GetInstances("dungeon")) do
			if candidate.name == name then instance = candidate end
		end
		local key = { instance.levelMin or 0, name }
		if previous and (key[1] < previous[1] or (key[1] == previous[1] and key[2] < previous[2])) then return false end
		previous = key
	end
	return true
end
check(names[1] == "Ragefire Chasm" and sortedByLevel(names) and buttonNamed(dungeons, "Stratholme: Service Gate")
	and buttonNamed(dungeons, "The Drowned City"), "dungeons sorted by level, then name, from Ragefire Chasm to the last")
check(buttonNamed(dungeons, "City of Dalaran").Untested:IsShown() and buttonNamed(dungeons, "City of Dalaran").Untested:GetText() == "Not yet tested"
	and not buttonNamed(dungeons, "The Deadmines").Untested:IsShown(), "untested dungeons say so on their button")
-- Which dungeons WoW: Forever added is kept in the data, for a later way to show it
local foreverDungeons = {}
for _, instance in ipairs(ns.GetInstances("dungeon")) do
	if instance.forever then foreverDungeons[#foreverDungeons + 1] = instance.key end
end
check(#foreverDungeons == 9, "the nine Forever dungeons are known, got " .. #foreverDungeons)
do
	local mark = buttonNamed(dungeons, "The Hall of Thanes").Forever
	check(mark:IsShown() and not buttonNamed(dungeons, "The Deadmines").Forever:IsShown()
		and mark.Icon:GetTexture():find("Media\\ForeverIcon", 1, true), "what is new in Forever carries its emblem")
	mark:_RunScript("OnEnter")
	check(GameTooltip._text == "New in WoW: Forever", "and hovering it says what it means")
	mark:_RunScript("OnLeave")
	check(buttonNamed(dungeons, "The Drowned City").Untested._points[1][2] == -31,
		"a placeholder's untested note sits beside the emblem")
end

-- Excavation Site: Santiago Reyes's newer map, its four bosses on it, the last one the site added
do
	local site = ns.GetInstance("ExcavationSiteWetlands")
	local order, horror, relics = {}, nil, {}
	for _, boss in ipairs(site.bosses) do
		if not boss.trash then order[#order + 1] = boss.name end
		if boss.name == "Highland Horror" then horror = boss end
		if boss.name == "Relic Guardian" then
			for _, row in ipairs(boss.loot) do
				if row.name == "Titan Relic" then relics[#relics + 1] = row.itemID end
			end
		end
	end
	check(table.concat(order, ", ") == "Saltspine, Shadetooth, Highland Horror, Relic Guardian",
		"four bosses, in the order they are met: " .. table.concat(order, ", "))
	check(horror.displayID == 9010 and horror.mapPin.x == 0.082 and horror.loot[1].itemID == 270180,
		"the Highland Horror, with his model, his spot and the quest's root core")
	check(#relics == 2, "each side's Titan Relic from the Relic Guardian")
	check(site.map.entrance.x == 0.887 and site.levelMax == 31 and site.mapAreas["Lost Marsh"],
		"the entrance on the newer map's swirl, Blizzard's level range, and the map's areas")
	local count = #site.bosses
	ns.AmendInstance("ExcavationSiteWetlands", { addBosses = { { name = "Highland Horror" } } })
	check(#site.bosses == count, "a boss the data already has is not added twice")
end
check(buttonNamed(dungeons, "The Hall of Thanes").Range:GetText() == "13-18", "level range shown on the button, as Blizzard recommends it")
check(buttonNamed(dungeons, "Excavation Site: Wetlands").Art:GetTexture() == 7963777, "loading screen art on the Excavation Site button")
local deadminesButton = buttonNamed(dungeons, "The Deadmines")
check(deadminesButton.Art:GetTexture() == 522352 and deadminesButton.Art._texCoord[2] == 0.68359375,
	"Deadmines uses Blizzard's own journal button picture, cut as retail cuts it")
check(buttonNamed(dungeons, "The Stockade").Art:GetTexture() == 608223, "so does the Stockade")
check(not dungeons.Empty:IsShown(), "no empty message while dungeons show")

-- Level dropdown
local menu = dungeons.Dropdown._menu
check(menu and #menu.radios == 5, "five level brackets in the dropdown")
check(menu.radios[1].isSelected(), "All Levels selected by default")
check(menu.radios[1].text == "All Levels" and menu.radios[3].text == "Level 30 to 45" and menu.radios[5].text == "Level 60",
	"the level brackets in English words")
menu.radios[3].setSelected() -- Level 30 to 45
names = visibleButtons(dungeons)
local listed = table.concat(names, ", ")
check(listed:find("Shadowfang Keep", 1, true) and listed:find("Razorfen Downs", 1, true) and listed:find("The Drowned City", 1, true)
	and not listed:find("Ragefire Chasm", 1, true) and not listed:find("Blackrock Depths", 1, true) and sortedByLevel(names),
	"30-45 shows the dungeons reaching into it, got " .. listed)
check(ns.charDB.levelBracket == 3, "bracket remembered per character")
check(dungeons.Dropdown._menu.radios[3].isSelected(), "dropdown shows the chosen bracket")
menu = dungeons.Dropdown._menu
menu.radios[4].setSelected() -- Level 45 to 60
names = visibleButtons(dungeons)
listed = table.concat(names, ", ")
check(listed:find("Scarlet Monastery: Cathedral", 1, true) and listed:find("Blackrock Depths", 1, true)
	and listed:find("Uldaman", 1, true) and not listed:find("Shadowfang Keep", 1, true),
	"45-60 shows the dungeons reaching into it: " .. listed)
check(not dungeons.Empty:IsShown(), "and no empty message")
dungeons.Dropdown._menu.radios[5].setSelected() -- Level 60
listed = table.concat(visibleButtons(dungeons), ", ")
check(listed:find("Upper Blackrock Spire", 1, true) and listed:find("Scholomance", 1, true) and not listed:find("Uldaman", 1, true),
	"level 60: the dungeons for the level cap, got " .. listed)
dungeons.Dropdown._menu.radios[1].setSelected()
check(#visibleButtons(dungeons) == 35, "All Levels shows all thirty-five again")

-- Opening a dungeon: the book, its boss list and the instance overview
check(rawget(f, "EncounterPage") == nil, "the book is not built with the window")
check(#reputation.Buttons == 0, "nor are the faction cards")
local page = ns.Journal:Page()
local Page = ns.EncounterPage
buttonNamed(dungeons, "Ruins of Lordaeron"):Click()
check(page:IsShown() and not dungeons:IsShown(), "dungeon page replaces the list")
check(page.info.InstanceTitle:GetText() == "Ruins of Lordaeron", "left page header names the dungeon")
local dungeonIcon = page.info.InstanceButton.Icon
check(dungeonIcon:GetTexture() == 7963782 and dungeonIcon._texCoord and dungeonIcon._maskTextures
	and dungeonIcon._maskTextures[1] == dungeonIcon.CircleMask, "round, cropped dungeon icon from its art")
check(page.Bosses.Buttons[1].Portrait._maskTextures, "boss portraits rounded with a mask object")
check(page.InstanceOverview:IsShown() and page.InstanceOverview.Title:GetText() == "Ruins of Lordaeron", "instance overview on the right page")
check(page.InstanceOverview.Lore.Text:GetText():find("The ruined city of Lordaeron", 1, true), "lore text shows location")
check(not page.info.RightShadow:IsShown() and not page.BossOverview:IsShown(), "no boss header on the instance overview")
check(#f.NavBar._nav == 2 and f.NavBar._nav[2].name == "Ruins of Lordaeron", "breadcrumb added")

local function visibleBosses()
	local names = {}
	for _, button in ipairs(page.Bosses.Buttons) do
		if button:IsShown() then names[#names + 1] = button.Name:GetText() end
	end
	return names
end
local bossNames = visibleBosses()
check(#bossNames == 7, "seven bosses, trash left out, got " .. #bossNames)
check(bossNames[1] == "The Baron" and bossNames[7] == "Lordaeron Captain (Rare)", "boss order and rare label: " .. table.concat(bossNames, ", "))
do
	-- The portrait is a full circle starting the button, ringed in gold then a dark edge, and
	-- the plate starts behind it without its own cap
	local button = page.Bosses.Buttons[1]
	local point = button.Portrait._points[1]
	check(button.Portrait._portrait == 144188 and button.Portrait:IsShown() and rawget(button, "PortraitClip") == nil
		and button.Portrait:GetWidth() == 54 and point[3] == "LEFT" and point[4] == 33.5 and point[5] == 0,
		"creature portrait in a full circle on the plate's middle")
	check(button.Rim:IsShown() and button.Rim:GetWidth() == 62 and button.Edge:GetWidth() == 56
		and button.Rim._points[1][4] == 33.5 and button.Edge._points[1][4] == 33.5,
		"a gold band and a dark edge round it, on the same centre")
	check(33.5 - button.Rim:GetWidth() / 2 > 0, "the circle starts inside the button")
	local plates = { button:GetNormalTexture(), button:GetPushedTexture(), button:GetHighlightTexture() }
	local cropped = true
	for _, texture in ipairs(plates) do
		local _, _, _, x = texture:GetPoint(1)
		local left = texture._texCoord[1]
		cropped = cropped and x == 45 and left > 0.13 and left < 0.15 and #(texture._maskTextures or {}) == 0
	end
	check(cropped, "plate, pushed plate and highlight start under the circle without the plate's cap")
	-- The plate's cut end lies wholly under the circle, the art's whole height
	local radius = button.Rim:GetWidth() / 2
	check(math.sqrt(radius ^ 2 - (45 - 33.5) ^ 2) >= button:GetHeight() / 2, "the circle hides the plate's cut end")
end
check(page.Bosses.Buttons[7].Portrait._portrait == 139050 and not page.Bosses.Buttons[7].DefaultArt:IsShown(),
	"the rare's portrait, from its model on Wowhead")

-- Side tabs on the instance overview
local tabs = page.Tabs
check(#tabs == 5, "five side tabs: retail's four and the quests")
check(tabs[4].unselected._texture == "Interface\\EncounterJournal\\UI-EncounterJournalTextures", "the Model tab with retail's icon")
check(tabs[1].selected:IsShown() and not tabs[1].unselected:IsShown(), "Overview tab selected")
check(not tabs[3]:IsEnabled() and tabs[3].unselected._desaturated, "Abilities waits for a boss, greyed")
check(tabs[2]:IsEnabled() and tabs[5]:IsEnabled(), "Loot and Quests available for the dungeon")
check(not tabs[4]:IsEnabled(), "the Model tab waits for a boss, as on retail")
tabs[2]:Click()
check(page.Loot:IsShown() and not page.InstanceOverview:IsShown(), "Loot tab shows its page")
check(page.info.EncounterTitle:GetText() == "Ruins of Lordaeron" and page.info.RightShadow:IsShown(), "right page header names the dungeon")
tabs[3]:Click()
check(page.tab == Page.TAB_OVERVIEW, "a disabled tab falls back to Overview")
tabs[1]:Click()

-- Choosing a boss
page.Bosses.Buttons[2]:Click()
check(page.boss and page.boss.name == "Witherfang", "boss chosen")
check(page.Bosses.Buttons[2]._highlightLocked and not page.Bosses.Buttons[1]._highlightLocked, "chosen boss stays highlighted")
check(page.BossOverview:IsShown() and not page.InstanceOverview:IsShown(), "boss overview replaces the instance overview")
check(page.info.EncounterTitle:GetText() == "Witherfang" and page.info.EncounterTitle:IsShown(), "boss name on the right page")
check(tabs[3]:IsEnabled() and not tabs[3].unselected._desaturated, "Abilities available once a boss is chosen")
local bullets = page.BossOverview.Child.Bullets
check(bullets[1]:IsShown() and bullets[1].Text:GetText():find("spiders of the courtyard", 1, true)
	and bullets[2]:IsShown() and bullets[2].Text:GetText():find("level", 1, true), "the written note first, then the level")
check(page.boss.extraAbilities and page.boss.extraAbilities[1].title == "Spiders of the courtyard"
	and page.boss.extraAbilities[1].icon:find("inv_misc_monsterspidercarapace_01", 1, true),
	"what matters in the fight, written down where it has no spell: the courtyard's spiders")
check(#f.NavBar._nav == 3 and f.NavBar._nav[3].name == "Witherfang", "Home > dungeon > boss breadcrumbs")

-- Breadcrumb dropdowns
local bossChoices = f.NavBar._nav[3].listFunc()
check(#bossChoices == 7 and bossChoices[3].text == "The Abandoned", "boss breadcrumb lists the bosses")
bossChoices[3].func()
check(page.boss.name == "The Abandoned" and #f.NavBar._nav == 3, "picking from the boss list switches boss")
tabs[3]:Click()
check(page.tab == Page.TAB_ABILITIES and page.Abilities:IsShown(), "Abilities tab opens for a boss")

-- The Model tab: the boss's own creature, as retail's shows it
do
	bossChoices[1].func()
	check(page.boss.displayID and tabs[4]:IsEnabled(), "the Model tab opens for a boss the client can draw")
	tabs[4]:Click()
	local modelPanel, model = page.Model, page.Model.Model
	check(page.tab == Page.TAB_MODEL and modelPanel:IsShown() and not page.Abilities:IsShown()
		and not page.info.EncounterTitle:IsShown() and not page.info.RightShadow:IsShown(),
		"the model fills the right page, without the header band")
	check(not rawget(modelPanel, "Background") and not rawget(modelPanel, "Paper"), "the creature stands on the page itself, no framed backdrop")
	check(model._displayInfo == page.boss.displayID and modelPanel.Title:GetText() == page.boss.name,
		"the boss's model, its name along the bottom")
	check(modelPanel.Buttons[1]:IsShown() and not modelPanel.Buttons[1]:IsEnabled() and modelPanel.Buttons[1]:GetWidth() == 64
		and not modelPanel.Buttons[2], "a round button for its creature, larger while shown")
	local facing = model._facing
	Mock.cursorX = 100
	model:_RunScript("OnMouseDown", "LeftButton")
	Mock.cursorX = 150
	model:_RunScript("OnUpdate", 0.01)
	check(math.abs(model._facing - (facing + 1.0)) < 1e-9, "dragging turns the creature")
	model:_RunScript("OnMouseUp", "LeftButton")
	check(model:GetScript("OnUpdate") == nil, "and it stops following the mouse once let go")
	model:_RunScript("OnMouseWheel", 1)
	check(math.abs(model._camScale - 0.9) < 1e-9, "the wheel zooms in")
	model:_RunScript("OnMouseWheel", -1)
	bossChoices[2].func()
	check(page.tab == Page.TAB_MODEL and model._displayInfo == page.boss.displayID and model._camScale == 1,
		"another boss shows its own creature on the same tab, the camera put back")
	-- A boss the client has no model for: no Model tab, back to the overview
	local drowned = ns.GetInstance("TheDrownedCity")
	ns.Journal:OpenBoss(drowned, drowned.bosses[1])
	check(not drowned.bosses[1].displayID and not tabs[4]:IsEnabled() and page.tab == Page.TAB_OVERVIEW,
		"a boss without a model: no Model tab")
	-- The creatures of a fight: the boss, then any add the client can draw
	local creatures = ns.ModelPanel:Creatures({ name = "Boss", displayID = 1, adds = { { name = "Add", displayID = 2 }, { name = "Unknown" } } })
	check(#creatures == 2 and creatures[2].name == "Add", "the boss and the adds that have a model")
end
tabs[1]:Click()
local instanceChoices = f.NavBar._nav[2].listFunc()
check(#instanceChoices == 35 and instanceChoices[1].text == "Ragefire Chasm", "dungeon breadcrumb lists the dungeons")
choiceNamed(instanceChoices, "The Hall of Thanes").func()
check(page.instance.key == "HallOfThanes" and page.boss == nil, "picking from the dungeon list opens it")
bossNames = visibleBosses()
check(#bossNames == 4 and not page.Bosses.Buttons[5]:IsShown(), "boss list redrawn for the new dungeon")
check(page.Bosses.Buttons[2].Portrait._portrait == 1070 and not page.Bosses.Buttons[2].DefaultArt:IsShown(),
	"Magmatus's model, from foreverchanges.pro")
page.Bosses.Buttons[1]:Click()
f.NavBar._nav[2].OnClick()
check(page.boss == nil and page.InstanceOverview:IsShown(), "dungeon breadcrumb goes back to the dungeon overview")
page.Bosses.Buttons[3]:Click()
page.info.InstanceButton:Click()
check(page.boss == nil and #f.NavBar._nav == 2, "the round dungeon icon goes back to the overview")

-- The Deadmines: the dungeon's own data with the hand-written notes laid over it
local deadmines = ns.GetInstance("TheDeadmines")
check(deadmines.instanceID == 36 and deadmines.map.floors[2].uiMapID == 292, "Deadmines keeps Blizzard's two map floors")
check(#deadmines.areas == 4 and deadmines.areas[4] == "Ironclad Cove", "Deadmines areas from the wiki")
check(deadmines.description:find("First War", 1, true), "hand-written description replaces the dungeon file's")
choiceNamed(instanceChoices, "The Deadmines").func()
check(page.instance == deadmines, "Deadmines opens from the dungeon list")
bossNames = visibleBosses()
check(#bossNames == 9 and bossNames[1] == "Rhahk'Zor" and bossNames[7] == "Cookie" and bossNames[9] == "Edwin VanCleef",
	"Deadmines bosses in run order: " .. table.concat(bossNames, ", "))
check(page.info.InstanceButton.Icon:GetTexture() == 522352 and page.info.InstanceButton.Icon._texCoord[1] == 0.156,
	"Deadmines' round icon comes from its journal picture")
check(page.InstanceOverview.Picture:GetTexture() == 526404 and not page.InstanceOverview.PictureBorder:IsShown()
	and page.InstanceOverview.Picture:GetWidth() == 390, "Deadmines' overview uses Blizzard's lore picture in retail's layout")
page.Bosses.Buttons[6]:Click()
check(page.boss.name == "Mr. Smite", "Mr. Smite chosen")
local smiteBullets = {}
for _, bullet in ipairs(page.BossOverview.Child.Bullets) do
	if bullet:IsShown() then smiteBullets[#smiteBullets + 1] = bullet.Text:GetText() end
end
check(smiteBullets[1]:find("66%", 1, true) and smiteBullets[3] == "Found in Ironclad Cove.",
	"hand-written notes and area come first: " .. table.concat(smiteBullets, " | "))

------------------------------------------------------------------------------------------
-- Loot tab
------------------------------------------------------------------------------------------

local loot = page.Loot
local function lootRows()
	local list = {}
	for _, row in ipairs(loot.Rows) do
		if row:IsShown() then list[#list + 1] = row end
	end
	return list
end

ns.Journal:OpenInstance(ns.GetInstance("HallOfThanes"))
tabs[2]:Click()
check(loot:IsShown() and not page.Placeholder:IsShown(), "Loot tab shows the loot page")
check(not page.info.EncounterTitle:IsShown(), "the header gives way to the filters")
check(ns.charDB.lootFilters.class == "MAGE", "class filter starts on the player's class, as on retail")
check(loot.FilterBar:IsShown() and loot.FilterBar.Text:GetText() == "Filter: Mage", "filter bar names the class")
local rows = lootRows()
check(#rows == 11, "dungeon-wide list without the mail and leather a mage cannot wear, got " .. #rows)
check(rows[1].BossFrame:IsShown() and rows[1].Boss:GetText() == "Boss: Faldrim Anvilmar", "dungeon-wide rows name their boss")
check(rows[1].Name:GetText() == "Ephemeral Choker" and Mock.itemsRequested[270227], "data name shown while the client fetches the item")
check(rows[2].Slot:GetText() == "Wrist" and rows[2].ArmorType:GetText() == "Cloth", "slot and armour type from the client")

-- Item names arriving from the server redraw the page
Mock.itemsCached[270227] = true
Mock.Fire("GET_ITEM_INFO_RECEIVED", 270227, true)
check(lootRows()[1].Name:GetText() == "Cached 270227" and lootRows()[1].link, "names and links update when the client has them")

-- A boss's own loot
page.Bosses.Buttons[2]:Click()
check(page.boss.name == "Magmatus" and loot:IsShown(), "the loot tab stays open across bosses")
rows = lootRows()
check(#rows == 1 and rows[1].Name:GetText() == "Fang of Magmatus" and not rows[1].BossFrame:IsShown(),
	"a mage sees only Magmatus's dagger, in boss-page rows")
loot.FilterBar.Clear:Click()
check(not loot.FilterBar:IsShown() and #lootRows() == 3, "clearing the filter shows all three")

-- Armour filter lists only what is there
local armorMenu = loot.ArmorFilter._menu
check(#armorMenu.radios == 3 and armorMenu.radios[2].text == "Leather" and armorMenu.radios[3].text == "Mail",
	"armour menu offers only the types present")
armorMenu.radios[3].setSelected()
rows = lootRows()
check(#rows == 1 and rows[1].Name:GetText() == "Kindlegem Girdle", "Mail shows the girdle")
check(loot.FilterBar.Text:GetText() == "Filter: Mail", "filter bar names the armour type")
loot.FilterBar.Clear:Click()
local typeMenu = loot.TypeFilter._menu
check(typeMenu.radios[1].text == "All Types" and #typeMenu.buttons == 1 and typeMenu.buttons[1].text == "Equipment"
	and #typeMenu.buttons[1].radios == 4, "type menu: equipment, its submenu all slots plus the three present")

-- Favourites sort to the top
rows = lootRows()
check(rows[3].Name:GetText() == "Fang of Magmatus", "the dagger starts last")
rows[3].Star:Click()
check(ns.charDB.favorites[271095] and lootRows()[1].Name:GetText() == "Fang of Magmatus", "a favourite moves to the top")
check(lootRows()[1].Star:IsShown(), "favourites keep their star")
loot.ClassFilter._menu.checkboxes[1].setSelected()
check(#lootRows() == 1 and loot.FilterBar.Text:GetText() == "Filter: Favorites", "favourites only")
loot.FilterBar.Clear:Click()

-- Pins stay at the top of every page in the dungeon, past any filter
local girdle
for _, row in ipairs(lootRows()) do if row.itemID == 270230 then girdle = row end end
girdle:Click("RightButton")
check(ns.charDB.pins[270230] and ns.charDB.pins[270230].boss == "Magmatus", "right-click pins, remembering the boss")
page.Bosses.Buttons[1]:Click()
check(loot.Dividers[1]:IsShown() and loot.Dividers[1].Name:GetText() == "Pinned", "pinned section on another boss's page")
rows = lootRows()
check(rows[1].itemID == 270230 and rows[1].Pin:IsShown() and rows[1].Boss:GetText() == "Boss: Magmatus",
	"the pinned girdle leads, naming its boss")
check(loot.Dividers[2]:IsShown() and loot.Dividers[2].Name:GetText() == "Faldrim Anvilmar", "then the boss's own loot under its name")
loot.ClassFilter._menu.radios[1 + 1].setSelected() -- Warrior
loot.ArmorFilter._menu.radios[2].setSelected() -- the first armour type present here: Cloth
check(lootRows()[1].itemID == 270230, "a pin ignores the filters")
loot.FilterBar.Clear:Click()
lootRows()[1]:Click("RightButton")
check(ns.charDB.pins[270230] == nil and not loot.Dividers[1]:IsShown(), "right-click again unpins")

-- Items a source names without an item id list by name, each on its own row. City of Dalaran's all have ids
-- now (Wowhead's guide), so a stand-in: two of Atrexis's drops named only, as an earlier source had them
local cityOfDalaran = ns.GetInstance("CityOfDalaran")
check(cityOfDalaran.bosses[1].name == "Atrexis the Grave Knight" and cityOfDalaran.bosses[2].name == "Lyn the Ignored"
	and cityOfDalaran.bosses[7].name == "Fel Ancient" and cityOfDalaran.buttonArt == 7963775,
	"City of Dalaran in the order it is walked, Lyn in the sewers past Atrexis, with its loading screen")
check(cityOfDalaran.levelMax == 33 and cityOfDalaran.bosses[1].mapPin.x == 0.609 and cityOfDalaran.bosses[8].mapPin.floor == 2,
	"Blizzard's level range, and its bosses' spots on the sewers and the city")
for _, quest in ipairs(cityOfDalaran.quests) do
	if quest.questID == 92458 then
		check(quest.prerequisites[1].questID == 92432 and quest.note:find("Friend of the Kirin Tor", 1, true),
			"the Alliance's key quest: where it starts and what follows")
	end
end
local cityItems = 0
for _, boss in ipairs(cityOfDalaran.bosses) do
	for _, row in ipairs(boss.loot) do
		if not ns.Items:IsIdentified(row.itemID) then cityItems = cityItems + 1 end
	end
end
check(cityItems == 0, "every City of Dalaran drop has its item id")
ns.AmendInstance("CityOfDalaran", { bosses = { ["Atrexis the Grave Knight"] = { loot = {
	{ itemID = 273032, name = "Bonebinder's Signet", slot = "Finger", quality = 3 },
	{ name = "Graveweave Bindings", slot = "Wrist, Cloth", quality = 3 },
	{ name = "Kirin Tor Chain Vest", slot = "Chest, Mail", quality = 3 },
	{ itemID = 273036 },
} } } })
ns.Journal:OpenInstance(cityOfDalaran)
page.Bosses.Buttons[1]:Click()
rows = lootRows()
local graveweave
for _, row in ipairs(rows) do if row.Name:GetText() == "Graveweave Bindings" then graveweave = row end end
check(page.boss.name == "Atrexis the Grave Knight" and #rows == 4 and graveweave and graveweave.itemID == "?Graveweave Bindings"
	and graveweave.Slot:GetText() == "Wrist, Cloth" and graveweave.Icon:GetTexture() == "Interface\\Icons\\INV_Misc_QuestionMark",
	"an item known only by name lists under its name and slot, with a question mark")
check(not Mock.itemsRequested["?Graveweave Bindings"], "and the server is not asked for it")
graveweave:_RunScript("OnEnter")
check(GameTooltip._text == "Graveweave Bindings" and GameTooltip:HasLine("Wrist, Cloth")
	and GameTooltip:HasLine("Not identified yet: its source names it, but not its item ID. Loot it while recording to add it."),
	"its tooltip says it is not identified yet")
graveweave:_RunScript("OnLeave")
graveweave.Star:Click()
check(ns.charDB.favorites["?Graveweave Bindings"] and lootRows()[1].Name:GetText() == "Graveweave Bindings", "it can be a favourite")
lootRows()[1].Star:Click()
check(not ns.charDB.favorites["?Graveweave Bindings"], "and stop being one")
local mailRadio
for _, radio in ipairs(loot.ArmorFilter._menu.radios) do
	if radio.text == "Mail" then mailRadio = radio end
end
mailRadio.setSelected()
rows = lootRows()
check(#rows == 1 and rows[1].Name:GetText() == "Kirin Tor Chain Vest", "the armour filter reads its armour from the source's words")
loot.FilterBar.Clear:Click()
-- Another source gives the item's id: once the server names that item the same, the name-only row gives way
Mock.itemsCached[273036], Mock.itemNames[273036] = true, "Graveweave Bindings"
Mock.Fire("GET_ITEM_INFO_RECEIVED", 273036, true)
rows = lootRows()
local namedGraveweave, nameOnlyLeft = 0, false
for _, row in ipairs(rows) do
	if row.Name:GetText() == "Graveweave Bindings" then namedGraveweave = namedGraveweave + 1 end
	if row.itemID == "?Graveweave Bindings" then nameOnlyLeft = true end
end
check(#rows == 3 and namedGraveweave == 1 and not nameOnlyLeft, "once its real one comes in, the name-only row gives way to it")
-- What the guide added: Lyn's abilities and how to summon him, notes, alerts, the Horde's key quests
local lyn
for _, boss in ipairs(cityOfDalaran.bosses) do if boss.name == "Lyn the Ignored" then lyn = boss end end
check(#lyn.abilities == 2 and lyn.abilities[2].spellID == 1304473 and lyn.abilities[2].flags[1] == "Curse"
	and lyn.extraAbilities[1].title == "Skeletons" and lyn.fightNote:find("Tome of Dalaran", 1, true)
	and lyn.notes[1]:find("Tome of Dalaran", 1, true), "Lyn the Ignored's abilities, and how to summon her")
local heartOfDisruption
for _, quest in ipairs(cityOfDalaran.quests) do if quest.questID == 96984 then heartOfDisruption = quest end end
check(#heartOfDisruption.prerequisites == 4 and heartOfDisruption.prerequisites[4].name == "Blood in the Streets",
	"the Horde's Heart of Disruption follows the key chain from Tarren Mill")
check(cityOfDalaran.description:find("Dalaran Sewer Key", 1, true) and cityOfDalaran.description:find("Emissary Jacques", 1, true)
	and cityOfDalaran.description:find("Magus Wordeen Voidglare", 1, true), "the way in, for both sides")
tabs[1]:Click()

------------------------------------------------------------------------------------------
-- Abilities tab
------------------------------------------------------------------------------------------

local abilities = page.Abilities
local function shownHeaders()
	local list = {}
	for _, header in ipairs(abilities.Headers) do
		if header:IsShown() then list[#list + 1] = header end
	end
	return list
end
local function flagNames(header)
	local names = {}
	for _, flag in ipairs(header.Button.Flags) do
		if flag:IsShown() then names[#names + 1] = flag.tooltipTitle end
	end
	return table.concat(names, ",")
end

-- A boss the site describes only in words: the recorded run's spells, with the client's names and
-- descriptions and the run's numbers, then what the site wrote
ns.Journal:OpenBoss(ns.GetInstance("HallOfThanes"), ns.GetInstance("HallOfThanes").bosses[1])
tabs[3]:Click()
check(abilities:IsShown() and not page.Placeholder:IsShown() and page.info.EncounterTitle:IsShown(), "Abilities tab shows the boss's abilities")
local headers = shownHeaders()
check(#headers == 3 and headers[1].Button.Title:GetText() == "Mind Blast" and headers[3].Button.Title:GetText() == "Curses and diseases",
	"Faldrim's two recorded spells, by client name, then the site's note")
check(headers[1].Button.AbilityIcon:GetTexture() == 136224, "spell icon from the client")
check(headers[1].Description:IsShown() and headers[1].Description:GetText():find("Blasts the target for 54 Shadow damage.", 1, true),
	"open by default, white colour codes stripped: " .. tostring(headers[1].Description:GetText()))
check(headers[1].Description:GetText():find("Hits 71-73, first cast at 7s", 1, true),
	"the player's own combat-log numbers under the description: " .. tostring(headers[1].Description:GetText()))
check(flagNames(headers[1]):find("Interruptible", 1, true), "a cast with a cast time is marked interruptible: " .. flagNames(headers[1]))
check(flagNames(headers[2]):find("Curse", 1, true), "a curse is marked as one: " .. flagNames(headers[2]))
check(headers[3].Button.AbilityIcon:GetTexture():find("spell_shadow_curseofsargeras", 1, true)
	and flagNames(headers[3]):find("Disease", 1, true), "the written note with its icon and alerts")
-- A boss the site lists spells for: its words over the client's, its alerts, and no numbers until a recording
local rhahk
for _, boss in ipairs(ns.GetInstance("TheDeadmines").bosses) do if boss.name == "Rhahk'Zor" then rhahk = boss end end
check(rhahk.abilities and #rhahk.abilities > 0 and rhahk.abilities[1].hit == nil and rhahk.abilities[1].firstCast == nil
	and rhahk.abilities[1].every == nil, "spells from the sources carry no damage or timings")
ns.Journal:OpenBoss(ns.GetInstance("TheDeadmines"), rhahk)
headers = shownHeaders()
check(#headers == 1 and headers[1].Description:GetText():find("Hits the tank hard and stuns them for 3 seconds.", 1, true)
	and flagNames(headers[1]) == "Tank Alert", "what the spell does in the fight, and who it is for")
headers[1].Button:Click()
check(not shownHeaders()[1].Description:IsShown() and shownHeaders()[1].Button.ExpandedIcon:GetText() == "+", "clicking a header closes it")
headers[1].Button:Click()

-- Stages from the authored data, with their spells nested beneath
local smite
for _, boss in ipairs(ns.GetInstance("TheDeadmines").bosses) do if boss.name == "Mr. Smite" then smite = boss end end
ns.Journal:OpenBoss(ns.GetInstance("TheDeadmines"), smite)
check(page.tab == Page.TAB_ABILITIES, "the abilities tab stays open across bosses")
headers = shownHeaders()
local titles = {}
for _, header in ipairs(headers) do titles[#titles + 1] = header.Button.Title:GetText() end
check(#headers == 6 and titles[1] == "Stage One" and titles[2] == "Stage Two: 66% Health" and titles[5] == "Stage Three: 33% Health",
	"three stages with their spells: " .. table.concat(titles, " | "))
check(headers[3].Button.Title:GetText() == "Spell 6432" and headers[3].Description:IsShown() == false, "stage spells start closed")
check(flagNames(headers[3]) == "Important", "the ability's own alerts: " .. flagNames(headers[3]))
local stageIndent = select(4, headers[3]:GetPoint(1))
check(stageIndent == 15, "spells indent under their stage")

-- The Fanglords: the site's spells, each once, with its alerts
local anacondra, cobrahn
for _, boss in ipairs(ns.GetInstance("WailingCaverns").bosses) do
	if boss.name == "Lady Anacondra" then anacondra = boss end
	if boss.name == "Lord Cobrahn" then cobrahn = boss end
end
ns.Journal:OpenBoss(ns.GetInstance("WailingCaverns"), cobrahn)
headers = shownHeaders()
check(#headers == 3 and headers[1].Button.Title:GetText() == "Spell 9532" and flagNames(headers[1]):find("Interruptible", 1, true)
	and headers[3].Description:GetText():find("At 30% health he turns into a serpent", 1, true), "Cobrahn's three spells")
ns.Journal:OpenBoss(ns.GetInstance("WailingCaverns"), anacondra)
headers = shownHeaders()
local healingTouches = 0
for _, header in ipairs(headers) do
	if header.Button.Title:GetText() == "Healing Touch" or header.Button.Title:GetText() == "Spell 5187" then
		healingTouches = healingTouches + 1
	end
end
check(#headers == 3 and healingTouches == 1, "Anacondra's Healing Touch is listed once")
check(flagNames(headers[2]):find("Magic", 1, true), "her Sleep carries its magic alert")
-- How the fight begins, above the abilities, where it is unusual
local sneed
for _, boss in ipairs(ns.GetInstance("TheDeadmines").bosses) do if boss.name == "Sneed" then sneed = boss end end
ns.Journal:OpenBoss(ns.GetInstance("TheDeadmines"), sneed)
check(abilities.Child.Description:GetText():find("He pilots Sneed's Shredder", 1, true), "Sneed: how the fight begins")
-- Adds from recorded runs: their own header, their spells beneath
local thanes = ns.GetInstance("HallOfThanes")
local magmatus
for _, boss in ipairs(thanes.bosses) do if boss.name == "Magmatus" then magmatus = boss end end
check(magmatus.encounterID == 3495 and magmatus.adds and magmatus.adds[1].name == "Dark Iron Summoner", "the recorded run's add and encounter id")
do
	-- A pasted recording (Blackfathom Deeps): its fights' ids, by the client's misspelt name too.
	local deeps = {}
	for _, boss in ipairs(ns.GetInstance("BlackfathomDeeps").bosses) do deeps[boss.name] = boss end
	check(deeps["Gelihast"].encounterID == 2914 and deeps["Aku'mai"].encounterID == 2910, "a pasted recording's encounter ids")
	check(deeps["Ghamoo-ra"].area == "The Pool of Ask'ar", "the client's own name for the first pool")
	local head
	for _, row in ipairs(deeps["Twilight Lord Kelris"].loot) do if row.itemID == 5881 then head = row end end
	check(head and head.name == "Head of Kelris", "Kelris drops his head for the quest")
	-- Its combat log, through the Log Reader: numbers on the written abilities, no adds from a
	-- fight the game never ended or from a self-buffing caster, and a spell the log saw that the
	-- player who ran it says is nothing to watch for (Old Serra'kis only melees)
	local bolt
	for _, row in ipairs(deeps["Lorgus Jett"].abilities or {}) do if row.spellID == 12167 then bolt = row end end
	check(bolt and bolt.text and bolt.hit and bolt.hit[2] == 191, "the log's numbers join a written ability")
	check(not deeps["Lorgus Jett"].adds and not deeps["Ghamoo-ra"].adds, "no trash taken for adds")
	check(not deeps["Old Serra'kis"].abilities, "a spell marked as nothing to watch for stays out")
	-- A zone drop the site's dungeon page leaves out, kept on the trash
	local sword
	for _, boss in ipairs(ns.GetInstance("RuinsOfLordaeron").bosses) do
		for _, row in ipairs(boss.trash and boss.loot or {}) do if row.itemID == 286977 then sword = row end end
	end
	check(sword and sword.name == "Sword of the Fallen" and sword.droppedBy == "Tattered Ghoul", "the Ruins' Sword of the Fallen")
	-- The Stockade's recorded run: encounter ids, the ringleaders' heads, where it opens, and
	-- where The Color of Blood is handed in
	local stockade = ns.GetInstance("TheStockade")
	local byName, heads = {}, {}
	for _, boss in ipairs(stockade.bosses) do
		byName[boss.name] = boss
		for _, row in ipairs(boss.loot or {}) do heads[row.itemID] = boss.trash and "Trash" or boss.name end
	end
	check(byName["Targorr the Dread"].encounterID == 2756 and byName["Bazil Thredd"].encounterID == 2760,
		"the Stockade's encounter ids")
	check(heads[3630] == "Targorr the Dread" and heads[3640] == "Kam Deepfury" and heads[3628] == "Dextren Ward"
		and heads[2926] == "Bazil Thredd" and heads[2909] == "Trash", "the quests' heads, hand and bandanas")
	local color
	for _, quest in ipairs(stockade.quests) do if quest.questID == 388 then color = quest end end
	check(color.startMap.x == 0.733 and color.startMap.y == 0.554 and stockade.zoneEntrance.x == 0.5037,
		"Nikova Raskol where she stands, and the door where the run walked in")
	-- A boss's buff on itself that the written abilities do not name is left out (Kam Deepfury's
	-- Defensive Stance), and a timing that never varied reads as one number
	local kam = byName["Kam Deepfury"]
	local stance, slam
	for _, row in ipairs(kam.abilities or {}) do
		if row.spellID == 7164 then stance = row end
		if row.spellID == 8242 then slam = row end
	end
	check(not stance and slam and slam.hit[1] == 25 and slam.every[1] == 12, "Kam's Shield Slam with its numbers, not his stance")
	ns.Journal:OpenBoss(stockade, kam)
	tabs[3]:Click()
	local slamText, titles = nil, {}
	for _, header in ipairs(shownHeaders()) do
		local text = header.Description:GetText() or ""
		titles[#titles + 1] = header.Button.Title:GetText()
		if text:find("Hits 25", 1, true) then slamText = text end
	end
	check(not table.concat(titles, ","):find("Defensive Stance", 1, true), "no stance on the page: " .. table.concat(titles, ", "))
	check(slamText and slamText:find("Hits 25-30, first cast at 4s, then every 12s", 1, true),
		"recorded numbers read plainly: " .. tostring(slamText))
end
-- The quests checked against the site's dungeon lists: Forever's new ones, a quest of several wings in
-- each, class quests marked for their class, and the required levels Forever changed
do
	local function Quest(key, questID)
		for _, quest in ipairs(ns.GetInstance(key).quests) do
			if quest.questID == questID then return quest end
		end
	end
	check(Quest("WailingCaverns", 1500) and Quest("WailingCaverns", 914).requiredLevel == 10
		and Quest("DireMaulEast", 7483) and Quest("DireMaulNorth", 7483) and Quest("DireMaulWest", 7483)
		and Quest("DireMaulEast", 5526) and Quest("TempleOfAtalHakkar", 8232).classOnly == "HUNTER"
		and Quest("HallOfThanes", 96403).faction == "Alliance" and Quest("BlackrockDepths", 4341).prerequisites[1].questID == 3701,
		"the quests the site lists for each dungeon, Forever's changes to them, and the class quests done inside")
end
-- A recorded run of Excavation Site: each boss's encounter id and spells, the Relic Guardian's though
-- the game calls him neutral, and the spiders that were fighting the dig nearby left out of the adds
do
	local dig = ns.GetInstance("ExcavationSiteWetlands")
	local bosses = {}
	for _, boss in ipairs(dig.bosses) do bosses[boss.name] = boss end
	local function Spell(boss, spellID)
		for _, row in ipairs(boss.abilities or {}) do
			if row.spellID == spellID then return row end
		end
	end
	local function AddIDs(boss)
		local ids = {}
		for _, add in ipairs(boss.adds or {}) do ids[#ids + 1] = add.npcID end
		table.sort(ids)
		return table.concat(ids, ",")
	end
	local guardian = bosses["Relic Guardian"]
	check(bosses["Saltspine"].encounterID == 3480 and guardian.encounterID == 3482 and Spell(guardian, 10101)
		and Spell(guardian, 8374) and Spell(guardian, 8374).every[1] == 9 and Spell(guardian, 8374).text,
		"Excavation Site's encounter ids, and the Relic Guardian's spells with their written text and recorded numbers")
	check(AddIDs(bosses["Saltspine"]) == "" and AddIDs(bosses["Shadetooth"]) == "260800,260801",
		"the spiders fighting the dig nearby are not taken for adds: " .. AddIDs(bosses["Shadetooth"]))
end
ns.Journal:OpenBoss(thanes, magmatus)
local magmatusHeaders = shownHeaders()
local addHeader
for index, header in ipairs(magmatusHeaders) do
	if header.Button.Title:GetText() == "Dark Iron Summoner" then addHeader = index end
end
check(addHeader and magmatusHeaders[addHeader + 1].Button.Title:GetText() == "Spell 20793"
	and select(4, magmatusHeaders[addHeader + 1]:GetPoint(1)) == 15, "the add under its own header, its spells indented beneath")
check(#ns.Search:Find("Summon Fiery Assistant") > 0, "search finds the add's spells")

-- Nothing known yet
local uldaman = ns.GetInstance("Uldaman")
ns.Journal:OpenBoss(uldaman, uldaman.bosses[1])
check(#shownHeaders() == 0 and abilities.Child.Empty:IsShown(), "a boss with no abilities says so")
tabs[1]:Click()

-- Placeholders and the newer dungeons open like the rest
local terrace = ns.GetInstance("ShapersTerrace")
ns.Journal:OpenInstance(terrace)
local terraceLore = page.InstanceOverview.Lore.Text:GetText()
check(page.instance == terrace and #visibleBosses() == 0 and terraceLore:find("Not yet tested:", 1, true)
	and terraceLore:find("Un'Goro Crater", 1, true) and terraceLore:find("Level 58-60", 1, true),
	"a placeholder opens on its announcement, marked not yet tested")
check(not page.InstanceOverview.MapButton:IsShown(), "and offers no map")
for tab = 1, 4 do ns.EncounterPage:SetTab(page, tab) end
ns.EncounterPage:SetTab(page, Page.TAB_OVERVIEW)
check(page.instance == terrace, "every side tab copes with a dungeon that has nothing yet")
local drownedCity = ns.GetInstance("TheDrownedCity")
ns.Journal:OpenInstance(drownedCity)
check(table.concat(visibleBosses(), ", ") == "Zul'Alai, Zin'aka, Deathless Marrow, Min'loth the Serpent", "announced bosses listed")
check(page.Bosses.Buttons[1].DefaultArt:IsShown() and not page.Bosses.Buttons[1].Portrait:IsShown(),
	"a boss without a known model gets Blizzard's default picture")
do
	local button = page.Bosses.Buttons[1]
	local masks = button.DefaultArt._maskTextures or {}
	local _, _, _, x, y = button.DefaultArt:GetPoint(1)
	check(button.Rim:IsShown() and button.Edge:IsShown() and #masks == 1 and masks[1]._points[1][2] == button.Portrait
		and x + 37.5 == 33.5 and y == -27, "in the same ringed circle, cut to the portrait's round")
end
ns.Journal:OpenBoss(drownedCity, drownedCity.bosses[1])
check(page.BossOverview:IsShown(), "an announced boss opens")
-- Alex Atlas Loot's tables add the loot and the creatures the other sources lack, and nothing that is no creature's
local gnomeregan = ns.GetInstance("Gnomeregan")
local techbot
for _, boss in ipairs(gnomeregan.bosses) do if boss.name == "Techbot" then techbot = boss end end
check(techbot and techbot.npcID == 6231 and #techbot.loot > 0 and type(techbot.loot[1].itemID) == "number" and not techbot.trash,
	"Techbot, a creature only Alex's tables have, with its loot")
check(gnomeregan.bosses[#gnomeregan.bosses].trash, "trash stays last")
local strayLists = 0
for _, instance in ipairs(ns.GetInstances("dungeon")) do
	for _, boss in ipairs(instance.bosses) do
		if boss.name == "Keys" or boss.name == "Coming Soon" or boss.name == "Defias Gunpowder" then strayLists = strayLists + 1 end
	end
end
check(strayLists == 0, "his lists of keys and quest objects are not bosses")
local deeps = ns.GetInstance("BlackfathomDeeps")
check(ns.DungeonMap:HasMap(deeps) and #deeps.map.floors == 3, "Blackfathom Deeps has its three map levels")
do
	local city = ns.GetInstance("CityOfDalaran")
	check(ns.DungeonMap:HasMap(city) and #city.map.floors == 2 and city.map.floors[1].art:find("Media\\Maps\\CityOfDalaranSewers", 1, true)
		and city.floorNames[2] == "The City" and city.map.transitions[1].to == 2,
		"City of Dalaran on Santiago Reyes's map: the sewers, then the city")
end
ns.Journal:OpenInstance(deeps)
check(page.InstanceOverview.Lore.Text:GetText():find("Once a temple to Elune", 1, true)
	and not page.InstanceOverview.Lore.Text:GetText():find("Not yet tested", 1, true), "Blackfathom Deeps' own overview")
check(#ns.Search:Find("Aku'mai") > 0 and #ns.Search:Find("Herod") > 0 and #ns.Search:Find("Whitemane") > 0,
	"search knows the dungeons, the Armory and Cathedral included")
check(#ns.Search:Find("Drowned City") > 0 and #ns.Search:Find("Gahz'rilla") > 0 and #ns.Search:Find("Onyxia") > 0,
	"and the placeholders, the returning dungeons and the raids")
tabs[1]:Click()

------------------------------------------------------------------------------------------
-- Quests tab
------------------------------------------------------------------------------------------

local function questRows()
	local list = {}
	for _, row in ipairs(page.QuestList.Rows) do
		if row:IsShown() then list[#list + 1] = row end
	end
	return list
end
local function rowFor(questID)
	for _, row in ipairs(questRows()) do if row.quest.questID == questID then return row end end
end
local detail = page.QuestDetail.Child

ns.Journal:OpenInstance(ns.GetInstance("HallOfThanes"))
tabs[5]:Click()
check(page.QuestList:IsShown() and page.QuestDetail:IsShown() and not page.Bosses:IsShown(), "quests take both pages")
check(not page.info.EncounterTitle:IsShown(), "a quest page carries its own title")
local qrows = questRows()
check(#qrows == 5, "all five Hall of Thanes quests for an Alliance character, got " .. #qrows)
check(qrows[1].Text:GetText() == "[15] An Ancient Grudge" and qrows[1].quest == page.selectedQuest, "first quest chosen to start")
check(detail.Title:GetText() == "An Ancient Grudge" and not detail.Status:IsShown(), "its page: the title, no status line when available")
check(qrows[1].Status._atlas == "QuestNormal" and not qrows[1].Status._desaturated, "a yellow ! for an available quest")
check(qrows[1].Highlight:IsShown() and not qrows[2].Highlight:IsShown(), "the chosen row is lit, the others not")
check(qrows[1].Highlight._texture:find("QuestLog", 1, true) or qrows[1].Highlight._texture:find("QuestTitle", 1, true),
	"the classic quest-log highlight")
qrows[2]:_RunScript("OnEnter")
check(qrows[2].Highlight:IsShown() and qrows[2].Text._textColor[3] == 1, "hovering lights a row and whitens its text")
qrows[2]:_RunScript("OnLeave")
check(not qrows[2].Highlight:IsShown(), "and leaving puts it out")
local c = qrows[2].Text._textColor
check(c[1] == 1 and c[2] == 1 and c[3] == 0, "quests not done are yellow")
c = qrows[1].Text._textColor
check(c[1] == 1 and c[2] == 1 and c[3] == 1, "the chosen quest is white")
check(detail.ShowStart:IsShown() and detail.ShowEnd:IsShown(), "Show Start and Show End on every quest")

-- A quest with a prerequisite
local incursion = rowFor(96393)
check(incursion.Status._desaturated and incursion.Expand:IsShown(), "locked behind its prerequisite: grey !, with a chain to open")
check(rawget(incursion, "Faction") == nil, "no faction badges")
incursion:Click()
check(detail.Title:GetText() == "Old Ironforge Incursion" and detail.Status:GetText():find("Requires: Underground Map", 1, true),
	"says what it needs: " .. tostring(detail.Status:GetText()))
check(rawget(detail, "ChainHeader") == nil and rawget(detail, "Facts") == nil, "the chain lives in the list, not on the page")
check(detail.RewardsHeader:IsShown() and detail.Receive:GetText() == "You will receive:" and detail.Money:IsShown()
	and detail.Money:GetText():find("^8|T") and detail.Money:GetText():find("UI-SilverIcon", 1, true),
	"money after the label, with coin icons: " .. tostring(detail.Money:GetText()))
local getCoins = C_CurrencyInfo.GetCoinTextureString
C_CurrencyInfo.GetCoinTextureString = nil
rowFor(96395):Click()
rowFor(96393):Click()
check(detail.Money:GetText():find("^8|TInterface\\MoneyFrame\\UI%-SilverIcon"), "coin icons even without the client's formatter")
C_CurrencyInfo.GetCoinTextureString = getCoins
check(not page.info.RightShadow:IsShown(), "no dark header band over the quest page")
check(detail.Title._textColor[1] == 0 and detail.RewardsHeader._textColor[1] == 0, "black headings, as on the reference")
check(detail.Experience:GetText() == "1,450 Experience", "experience: " .. tostring(detail.Experience:GetText()))
check(detail.Reputation:GetText() == "100 Ironforge Reputation\n100 Gnomeregan Exiles Reputation",
	"a line per faction: " .. tostring(detail.Reputation:GetText()))
local boxes = 0
for _, box in ipairs(detail.RewardBoxes) do if box:IsShown() then boxes = boxes + 1 end end
check(boxes == 3 and detail.Choose:GetText():find("choose", 1, true), "three reward choices")
check(detail.RewardBoxes[1].NameFrame._texture == "Interface\\QuestFrame\\UI-QuestItemNameFrame", "classic quest item boxes")
check(detail.ShowStart:IsEnabled() and detail.ShowStart.point.mapID == 1426 and detail.ShowEnd.point.mapID == 1455
	and detail.ShowEnd.point.x == 0.394, "where it starts in Dun Morogh, and Magni's hall where it ends")
rowFor(96395):Click()
check(not detail.ShowStart:IsEnabled() and not detail.ShowEnd:IsEnabled(), "a quest begun inside: no place on the world map, the buttons greyed")
rowFor(96393):Click()
rowFor(96393).Expand:Click()
check(#questRows() == 6 and questRows()[5].quest.name == "Underground Map", "opening the chain lists the prerequisite beneath")
questRows()[5]:Click()
check(page.selectedQuest.questID == 96391 and detail.Title:GetText() == "Underground Map", "a prerequisite can be chosen too")
rowFor(96393):Click()

-- The quest log moves things along
Mock.questsDone[96391] = true
Mock.Fire("QUEST_TURNED_IN", 96391, 1050, 0)
check(not rowFor(96393).Status._desaturated and not detail.Status:IsShown(), "prerequisite done: now available")
Mock.questLog[96393] = 3
Mock.Fire("QUEST_ACCEPTED", 96393)
check(rowFor(96393).Status._atlas == "QuestTurnin" and rowFor(96393).Status._desaturated, "in the log: a grey ?")
Mock.questsComplete[96393] = true
Mock.Fire("QUEST_LOG_UPDATE")
check(not rowFor(96393).Status._desaturated and detail.Status:GetText():find("ready to hand in", 1, true), "objectives done: a yellow ?")
Mock.questLog[96393], Mock.questsDone[96393] = nil, true
Mock.Fire("QUEST_TURNED_IN", 96393, 1450, 800)
check(rowFor(96393).Status._texture == "Interface\\Buttons\\UI-CheckBox-Check" and not detail.Status:IsShown(), "handed in: a gold check mark")
rowFor(96395):Click()
c = rowFor(96393).Text._textColor
check(c[1] == 0.1 and c[2] == 1 and c[3] == 0.1, "and green text once done")

-- What the Record tab saw: the quest's text and where it was handed in
ns.Recorder:GetState().quests[96395] = { description = "The dead do not rest easy beneath Ironforge.",
	turnin = { npc = { name = "Thane" }, place = { mapID = 1455, x = 0.3, y = 0.4 } } }
rowFor(96395):Click()
check(detail.DescriptionHeader:IsShown() and detail.Description:GetText():find("do not rest easy", 1, true), "recorded quest text shown")
check(detail.ShowEnd:IsEnabled() and not detail.ShowStart:IsEnabled(), "a recorded hand-in place enables Show End")
detail.ShowEnd:Click()
local pinned = ns.MapPin:Target()
check(WorldMapFrame:IsShown() and Mock.worldMapID == 1455 and pinned and pinned.x == 0.3 and pinned.y == 0.4, "Show End opens the map there")
ns.MapPin:Clear()
ns.Recorder:GetState().quests[96395] = nil

-- A Horde character sees only the quests open to them
Mock.faction = "Horde"
Mock.Fire("QUEST_LOG_UPDATE")
check(#questRows() == 1 and questRows()[1].quest.questID == 96395,
	"Horde sees only the quest open to both factions (Important Heirlooms is the Alliance's), got " .. #questRows())
Mock.faction = "Alliance"
tabs[1]:Click()
check(page.Bosses:IsShown() and not page.QuestList:IsShown(), "leaving the quests brings the boss list back")

-- The Deadmines: class quests, quest givers on the map, long chains
ns.Journal:OpenInstance(ns.GetInstance("TheDeadmines"))
tabs[5]:Click()
local names = {}
for _, row in ipairs(questRows()) do
	names[row.quest.name] = true
	check(row.quest.questID ~= nil and not row.Text:GetText():find("#nil", 1, true), "every row is a real quest")
end
check(not names["The Test of Righteousness"] and names["Red Silk Bandanas"], "a mage does not see the paladin quest")
Mock.playerClass = "PALADIN"
Mock.Fire("QUEST_LOG_UPDATE")
check(rowFor(1806) ~= nil, "a paladin does")
Mock.playerClass = "MAGE"
Mock.Fire("QUEST_LOG_UPDATE")

rowFor(214):Click()
check(detail.ShowStart:IsEnabled() and detail.ShowEnd:IsEnabled(), "Scout Riell gives and takes the bandanas: both places known")
Mock.inCombat = true
local chatBefore = #Mock.chat
detail.ShowStart:Click()
check(#Mock.chat == chatBefore + 1 and Mock.chat[#Mock.chat]:find("combat", 1, true), "no map in combat")
Mock.inCombat = false
detail.ShowStart:Click()
pinned = ns.MapPin:Target()
check(Mock.worldMapID == 1436 and pinned.x == 0.5667 and pinned.title == "Red Silk Bandanas", "Show Start pins the quest giver")
check(detail.Reputation:GetText() == "100 Stormwind Reputation" and detail.Receive:IsShown() == false, "reputation, and no money line without money")

rowFor(214).Expand:Click()
local parts = questRows()[2]
check(parts.quest.steps and parts.Text:GetText() == "The Defias Brotherhood (6 parts)", "six same-named steps make one row: " .. parts.Text:GetText())
parts:Click()
check(detail.Title:GetText() == "The Defias Brotherhood (6 parts)" and detail.Objective:GetText():find("0 of 6", 1, true)
	and not detail.ShowStart:IsShown(), "the chain's page counts its parts")
Mock.questsDone[65], Mock.questsDone[132] = true, true
Mock.Fire("QUEST_LOG_UPDATE")
check(detail.Objective:GetText():find("2 of 6", 1, true) and rowFor(65).Status._atlas == "QuestTurnin", "parts done so far, and the chain is under way")
Mock.questsDone[65], Mock.questsDone[132] = nil, nil
rowFor(214).Expand:Click()

rowFor(92753).Expand:Click()
local selfListed = 0
for _, row in ipairs(questRows()) do if row.quest == rowFor(92753).quest then selfListed = selfListed + 1 end end
check(selfListed == 1, "a chain that names its own quest does not list it twice")
rowFor(92753).Expand:Click()

-- Quests added from the guides (Data/Authored/FromGuides.lua) list and open like the rest
ns.Journal:OpenInstance(ns.GetInstance("Gnomeregan"))
tabs[5]:Click()
check(rowFor(2947) and not rowFor(2949) and not rowFor(2842), "an Alliance character sees the Alliance Return of the Ring, not the Horde's")
rowFor(2947):Click()
check(detail.Title:GetText() == "Return of the Ring" and detail.Objective:GetText():find("engraved inside its band", 1, true)
	and rowFor(2947).Expand:IsShown(), "its page, and its chain from the Grime-Encrusted Ring")
ns.Journal:OpenInstance(ns.GetInstance("ExcavationSiteWetlands"))
tabs[5]:Click()
check(rowFor(95810) and rowFor(95647) and not rowFor(95664), "the Excavation Site's added quests, by faction")
rowFor(95810):Click()
check(detail.Title:GetText() == "Lost Relic Carry", "a quest that begins with an item opens")
ns.Journal:OpenInstance(ns.GetInstance("ScarletMonasteryLibrary"))
tabs[5]:Click()
check(rowFor(1951) and not rowFor(1160), "a Mage sees Rituals of Power; the Horde's Test of Lore is not for this character")
local playerClass = Mock.playerClass
Mock.playerClass = "PALADIN"
tabs[1]:Click()
ns.Journal:OpenInstance(ns.GetInstance("ScarletMonasteryGraveyard"))
ns.Journal:OpenInstance(ns.GetInstance("ScarletMonasteryLibrary"))
tabs[5]:Click()
check(not rowFor(1951), "and another class does not")
Mock.playerClass = playerClass
tabs[1]:Click()

------------------------------------------------------------------------------------------
-- Dungeon maps
------------------------------------------------------------------------------------------

local DungeonMap = ns.DungeonMap
local HALL = { name = "The Hall of Thanes", id = 3065 }
local function shown(list)
	local result = {}
	for _, frame in ipairs(list) do if frame:IsShown() then result[#result + 1] = frame end end
	return result
end
WorldMapFrame:Hide()
check(#WorldMapFrame._providers >= 1, "the journal's provider joins the world map at login")

-- Show Map on a Forever dungeon: our own map over the world map
local hallBosses = ns.GetInstance("HallOfThanes").bosses
-- Stand-in for a boss whose model the journal doesn't know: Magmatus, for this map only.
local magmatusModel = hallBosses[2].displayID
hallBosses[2].displayID = nil
ns.Journal:OpenInstance(ns.GetInstance("HallOfThanes"))
tabs[1]:Click()
local mapButton = page.InstanceOverview.MapButton
check(mapButton:IsShown() and mapButton.Text:GetText() == "Show Map" and mapButton.Shadow._texCoord[1] == 0.00195313,
	"retail's Show Map on the dungeon page")
mapButton:Click()
local overlay = DungeonMap:Overlay()
check(WorldMapFrame:IsShown() and overlay and overlay:IsShown() and overlay.instance.key == "HallOfThanes", "the Hall of Thanes over the world map")
check(overlay.Art.Picture:GetTexture():find("Media\\Maps\\HallOfThanes", 1, true) and overlay.Art.Picture._texCoord[4] == 0.667,
	"our picture of it, cut to the map")
local artW, artH = overlay.Art._width, overlay.Art._height
check(math.abs(artW / artH - 1 / 0.667) < 0.001 and artW <= 1002 and artH <= 668 and (artW > 1001 or artH == 668),
	"as large as fits, in its own shape: " .. artW .. " x " .. artH)
local mapPins = shown(overlay.Pins)
check(#mapPins == 4, "a pin per boss, got " .. #mapPins)
check(mapPins[1]:GetNormalTexture()._texCoord[1] == 0.84960938 and mapPins[1].Portrait._maskTextures, "in the journal's round pin frame")
local faldrimPin
for _, pin in ipairs(mapPins) do if pin.boss.name == "Faldrim Anvilmar" then faldrimPin = pin end end
check(faldrimPin.Portrait._portrait == ns.GetInstance("HallOfThanes").bosses[1].displayID and not faldrimPin.Skull:IsShown(),
	"with the creature's portrait")
local faceless
for _, pin in ipairs(mapPins) do if not pin.boss.displayID then faceless = pin end end
check(faceless and faceless.Skull:IsShown() and faceless.Portrait._color, "a boss without a portrait gets the skull, not a question mark")
hallBosses[2].displayID = magmatusModel
do
	local spots, all = {}, {}
	for _, boss in ipairs(ns.GetInstance("TheStockade").bosses) do
		spots[boss.name], all[boss.name] = boss.mapPin, ns.DungeonMap.BossSpots(boss)
	end
	check(spots["Bazil Thredd"].x == 0.857 and spots["Kam Deepfury"].x == 0.692 and spots["Hamhock"].x == 0.782,
		"the Stockade's spots, as the site places them")
	check(#all["Targorr the Dread"] == 4 and #all["Dextren Ward"] == 3 and #all["Bruegal Ironknuckle"] == 4 and #all["Hamhock"] == 1,
		"the prisoners found in one of several cells have a spot for each")
end
local point = faldrimPin._points[1]
check(point[3] == "TOPLEFT" and math.abs(point[4] - 0.509 * artW) < 0.01, "placed where the boss stands")
check(not overlay.Here:IsShown(), "no you-are-here from outside the dungeon")
faldrimPin:_RunScript("OnEnter")
check(GameTooltip._text == "Faldrim Anvilmar", "a pin names its boss")
faldrimPin:Click("LeftButton")
check(not WorldMapFrame:IsShown() and f:IsShown() and page.boss and page.boss.name == "Faldrim Anvilmar",
	"a pin opens the boss in the journal and puts the map away")

-- Inside the dungeon: M shows it by itself, where the player stands, and what is dead
Mock.instance, Mock.subzone = HALL, "Anvilmar's Rest"
Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
OpenWorldMap()
check(overlay:IsShown() and overlay.instance.key == "HallOfThanes", "M inside the dungeon shows its map")
check(overlay.Here:IsShown() and math.abs(overlay.Here._width - 0.18 * artW) < 0.01, "the area the player stands in lights up")
Mock.subzone = "Somewhere unmapped"
Mock.Fire("ZONE_CHANGED")
check(not overlay.Here:IsShown(), "and goes out in an area the map does not know")
Mock.Fire("ENCOUNTER_END", 3493, "Faldrim Anvilmar", 1, 5, 1)
check(DungeonMap:IsDefeated(ns.GetInstance("HallOfThanes"), faldrimPin.boss) and faldrimPin.Cross:IsShown()
	and faldrimPin.Portrait._desaturated, "a kill greys and crosses out its boss")
local magmatusBoss
for _, boss in ipairs(ns.GetInstance("HallOfThanes").bosses) do if boss.name == "Magmatus" then magmatusBoss = boss end end
Mock.Fire("ENCOUNTER_END", 3495, "A name the journal does not use", 1, 5, 1)
check(DungeonMap:IsDefeated(ns.GetInstance("HallOfThanes"), magmatusBoss), "an encounter's id finds its boss whatever the fight is called")
overlay:_RunScript("OnMouseUp", "RightButton")
check(not overlay:IsShown() and WorldMapFrame:IsShown(), "right-click shows the world map beneath")
WorldMapFrame:Hide()
OpenWorldMap()
check(overlay:IsShown(), "M brings it back next time")
WorldMapFrame:SetMapID(1415)
check(not overlay:IsShown(), "browsing to another map puts it away")
WorldMapFrame:Hide()

-- Kills last the run: a corpse run keeps them, coming in fresh clears them
Mock.instance = nil
Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
Mock.instance, Mock.ghost = HALL, true
Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
check(DungeonMap:IsDefeated(ns.GetInstance("HallOfThanes"), faldrimPin.boss), "a corpse run keeps the kills")
Mock.instance, Mock.ghost = nil, false
Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
Mock.instance = HALL
Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
check(not DungeonMap:IsDefeated(ns.GetInstance("HallOfThanes"), faldrimPin.boss), "a new run starts clean")
Mock.instance = nil
Mock.Fire("PLAYER_ENTERING_WORLD", false, false)

-- A classic dungeon the client has maps of: its own map, with our pins on it. The Deadmines stand in
-- for one the journal has no picture of: with one, the journal's picture is drawn all the same.
Mock.nativeMaps[291], Mock.nativeMaps[292] = true, true
local deadminesFloors = ns.GetInstance("TheDeadmines").map.floors
check(not DungeonMap:IsNative(deadminesFloors[1]), "a floor with the journal's own picture is drawn from it, even where the client could")
local deadminesArt = { deadminesFloors[1].art, deadminesFloors[2].art }
deadminesFloors[1].art, deadminesFloors[2].art = nil, nil
ns.Journal:OpenInstance(ns.GetInstance("TheDeadmines"))
tabs[1]:Click()
page.InstanceOverview.MapButton:Click()
check(WorldMapFrame:IsShown() and Mock.worldMapID == 291 and not overlay:IsShown(), "the Deadmines open on the client's own map")
local nativePins = WorldMapFrame:ActivePins("AegisJournalBossPinTemplate")
check(#nativePins == 4 and nativePins[1].boss.name == "Rhahk'Zor" and nativePins[1]._position[1] == 0.386,
	"its first floor's four bosses pinned, got " .. #nativePins)
check(nativePins[1]._frameLevelType == "PIN_FRAME_LEVEL_ENCOUNTER" and nativePins[1]._scalingLimits[1] == 1
	and nativePins[1]:GetNormalTexture()._texCoord[1] == 0.84960938, "as retail's journal pins")
WorldMapFrame:SetMapID(292)
nativePins = WorldMapFrame:ActivePins("AegisJournalBossPinTemplate")
check(#nativePins == 5 and nativePins[1].boss.name == "Gilnid", "the next floor's five on the next map")
nativePins[1]:_RunScript("OnEnter")
check(GameTooltip._text == "Gilnid", "native pins have tooltips too")
nativePins[1]:Click("LeftButton")
check(not WorldMapFrame:IsShown() and page.boss.name == "Gilnid", "and open their boss")
deadminesFloors[1].art, deadminesFloors[2].art = deadminesArt[1], deadminesArt[2]
Mock.nativeMaps[291], Mock.nativeMaps[292] = nil, nil

-- A classic dungeon the client cannot show: drawn from foreverchanges.pro's picture of its map
do
	local ragefire = ns.GetInstance("RagefireChasm")
	ns.Journal:OpenInstance(ragefire)
	tabs[1]:Click()
	page.InstanceOverview.MapButton:Click()
	check(overlay:IsShown() and overlay.instance.key == "RagefireChasm", "Ragefire Chasm drawn over the world map")
	check(overlay.Art.Picture:IsShown() and overlay.Art.Picture:GetTexture():find("Media\\Maps\\Dungeons\\ragefire-chasm", 1, true)
		and math.abs(overlay.Art.Picture._texCoord[2] - 1002 / 1024) < 1e-9 and math.abs(overlay.Art.Picture._texCoord[4] - 668 / 1024) < 1e-9
		and #shown(overlay.Art.Tiles) == 0, "from the site's picture, cut to the client's map frame")
	check(ragefire.map.floors[1].uiMapID == 213, "still the client's map, for the player's position")
	local bazzalan
	for _, boss in ipairs(ragefire.bosses) do if boss.name == "Bazzalan" then bazzalan = boss end end
	check(bazzalan.mapPin.y == 0.862 and not bazzalan.mapPins, "bosses where the site places them")
	check(not overlay.FloorDropdown:IsShown(), "no floor menu for a one-level dungeon")
	WorldMapFrame:Hide()
	-- A floor with no picture of its own: the client's twelve tiles
	local ragefireArt = ragefire.map.floors[1].art
	ragefire.map.floors[1].art = nil
	overlay.Art.floor = nil -- the overlay keeps a floor it has drawn; this one changed under it
	page.InstanceOverview.MapButton:Click()
	local tiles = shown(overlay.Art.Tiles)
	check(#tiles == 12 and tiles[1]:GetTexture() == "Interface\\WorldMap\\Ragefire\\Ragefire1_1" and not overlay.Art.Picture:IsShown(),
		"from the client's twelve map tiles")
	check(math.abs(tiles[2]._points[1][4] - 1002 * 256 / 1002) < 0.01, "laid out four across")
	WorldMapFrame:Hide()
	ragefire.map.floors[1].art = ragefireArt
	overlay.Art.floor = nil
end

-- Several floors: a floor menu, and the stairs between them
do
	ns.Journal:OpenInstance(ns.GetInstance("ShadowfangKeep"))
	tabs[1]:Click()
	page.InstanceOverview.MapButton:Click()
	local floorMenu = overlay.FloorDropdown
	check(floorMenu:IsShown() and #floorMenu._menu.radios == 4 and floorMenu._menu.radios[1].isSelected(), "a menu of the four levels the site shows")
	check(floorMenu._points[1][2] == WorldMapFrame.WorldMapTrackingPinButton and floorMenu._points[1][3] == "RIGHT",
		"beside the map pin button, not under it")
	local levelNames = {}
	for _, radio in ipairs(floorMenu._menu.radios) do levelNames[#levelNames + 1] = radio.text end
	check(table.concat(levelNames, ", ") == "The Courtyard, Dining Hall, The Wall Walk, Arugal's Chamber",
		"levels by the site's names, in the order they are climbed: " .. table.concat(levelNames, ", "))
	local keepMaps = {}
	for _, floor in ipairs(ns.GetInstance("ShadowfangKeep").map.floors) do
		keepMaps[#keepMaps + 1] = floor.uiMapID .. "=" .. floor.art:match("([%w_%-]+)$")
	end
	check(table.concat(keepMaps, " ") == "310=shadowfang-keep-1 311=shadowfang-keep-2 316=shadowfang-keep-7 315=shadowfang-keep-6",
		"each level its client map and the site's picture: " .. table.concat(keepMaps, " "))
	local courtyardWays = {}
	for _, spot in ipairs(shown(overlay.Transitions)) do courtyardWays[#courtyardWays + 1] = spot.to end
	check(table.concat(courtyardWays, ",") == "3", "the courtyard's way up to the wall walk, moved to the new floors: " .. table.concat(courtyardWays, ","))
	shown(overlay.Transitions)[1]:Click()
	check(overlay.floor == 3 and floorMenu._menu.radios[3].isSelected(), "the stairs go up a level")
	local wallWalkWays = {}
	for _, spot in ipairs(shown(overlay.Transitions)) do wallWalkWays[#wallWalkWays + 1] = spot.to end
	check(table.concat(wallWalkWays, ",") == "4", "and on up to Arugal: " .. table.concat(wallWalkWays, ","))
	floorMenu._menu.radios[2].setSelected()
	local diningBosses = {}
	for _, pin in ipairs(shown(overlay.Pins)) do diningBosses[#diningBosses + 1] = pin.boss.name end
	table.sort(diningBosses)
	check(table.concat(diningBosses, ", ") == "Baron Silverlaine, Razorclaw the Butcher", "the dining hall's own bosses: " .. table.concat(diningBosses, ", "))
	floorMenu._menu.radios[4].setSelected()
	local topBosses = {}
	for _, pin in ipairs(shown(overlay.Pins)) do topBosses[#topBosses + 1] = pin.boss.name end
	table.sort(topBosses)
	check(overlay.floor == 4 and table.concat(topBosses, ", ") == "Archmage Arugal, Arugal's Voidwalker, Fenrus the Devourer, Wolf Master Nandos",
		"the top level's bosses: " .. table.concat(topBosses, ", "))
	WorldMapFrame:Hide()
	check(not floorMenu:IsShown(), "the floor menu goes with the map")
end

-- The journal's quests on the maps: a "!" where each starts, greyed while it cannot be taken
-- yet, a "?" where it is handed in once ready, nothing while under way or once done
do
	local QUEST_PIN = "AegisJournalQuestPinTemplate"
	local function marksOn(mapID)
		OpenWorldMap(mapID)
		local marks = {}
		for _, pin in ipairs(WorldMapFrame:ActivePins(QUEST_PIN)) do marks[pin.quest.questID] = pin end
		return marks
	end
	-- Old Ironforge Incursion (96393) and its first step were done earlier
	local ironforge = marksOn(1455)
	local heirlooms = ironforge[96403]
	check(heirlooms and heirlooms._position[1] == 0.324 and heirlooms.Texture._atlas == "QuestNormal"
		and not heirlooms.Texture._desaturated and heirlooms._frameLevelType == "PIN_FRAME_LEVEL_QUEST_OFFER",
		"Thom Filch's quest marked where he stands in Ironforge, as the client marks a quest on offer")
	check(ironforge[96394] and not ironforge[96393], "Afadra Dunwall's too; a quest already done has none")
	heirlooms:_RunScript("OnEnter")
	check(GameTooltip._text == "Important Heirlooms" and GameTooltip._lines[1]:find("The Hall of Thanes", 1, true),
		"its tooltip names the quest and its dungeon")
	heirlooms:_RunScript("OnLeave")
	heirlooms:_RunScript("OnClick", "RightButton")
	check(Mock.userWaypoint and Mock.userWaypoint.uiMapID == 1455 and Mock.userWaypoint.position.x == 0.324
		and chatContains("Waypoint set for Important Heirlooms."), "a right click sets a waypoint to it, and says so")

	-- Not yet: a greyed mark, saying what comes first
	Mock.questsDone[96391], Mock.questsDone[96393] = nil, nil
	local farsen = marksOn(1426)[96393]
	check(farsen and farsen.Texture._desaturated and farsen.mark.locked:find("Underground Map", 1, true),
		"Earthseer Farsen's quest greyed in Dun Morogh until Underground Map is done")
	-- Under way: no mark; ready: a "?" where it is handed in
	Mock.questsDone[96391], Mock.questLog[96393], Mock.questsComplete[96393] = true, 4, nil
	Mock.Fire("QUEST_ACCEPTED", 96393)
	check(not marksOn(1426)[96393] and not marksOn(1455)[96393], "taken: no mark while it is under way")
	Mock.questsComplete[96393] = true
	Mock.Fire("QUEST_LOG_UPDATE")
	local magni = marksOn(1455)[96393]
	check(magni and magni.Texture._atlas == "QuestTurnin" and magni._position[1] == 0.394, "ready: a ? at Magni's throne")
	-- Where the client marks the quest in the log itself, its "?" is left to it
	WorldMapFrame._pools.QuestPinTemplate = { pins = { { _active = true, questID = 96393 } } }
	check(not marksOn(1455)[96393], "the client's own mark for a quest in the log stands alone")
	WorldMapFrame._pools.QuestPinTemplate = nil
	Mock.questLog[96393], Mock.questsDone[96393], Mock.questsComplete[96393] = nil, true, nil
	Mock.Fire("QUEST_TURNED_IN", 96393, 1450, 800)
	check(not marksOn(1455)[96393], "handed in: gone")
	-- A Horde character sees only the marks of the quests open to them
	Mock.faction = "Horde"
	ironforge = marksOn(1455)
	check(not ironforge[96403] and not ironforge[96394], "the Horde see neither of the Alliance's quests in Ironforge")
	Mock.faction = "Alliance"
	check(marksOn(1455)[96403], "and the Alliance see Important Heirlooms there")
	-- A quest two wings list (the Cathedral's Herod quests, in the Armory too) has one mark
	local raleigh = 0
	for _, entry in ipairs(ns.QuestMap:MarksOn(1424)) do
		if entry.quest.questID == 1053 then raleigh = raleigh + 1 end
	end
	check(raleigh == 1 and #ns.GetInstance("ScarletMonasteryArmory").quests == 3,
		"the Armory lists the Cathedral's Herod quests too (and its Hearts of Zeal), and the map marks each once, got " .. raleigh)
	WorldMapFrame:Hide()

	-- Inside: the quests that start in the dungeon, on its own map
	ns.Journal:OpenInstance(ns.GetInstance("HallOfThanes"))
	tabs[1]:Click()
	page.InstanceOverview.MapButton:Click()
	local inside = {}
	for _, spot in ipairs(shown(overlay.QuestSpots)) do inside[spot.quest.questID] = spot end
	local grudge = inside[96395]
	check(grudge and inside[98423] and math.abs(grudge._points[1][4] - 0.400 * overlay.artWidth) < 0.01,
		"the Ghostly Attendant's quest and the stone tablet's, marked inside")
	grudge:_RunScript("OnClick", "LeftButton")
	check(not WorldMapFrame:IsShown() and page.selectedQuest == grudge.quest, "a click opens the quest in the journal")
	Mock.questsDone[96395] = true
	page.InstanceOverview.MapButton:Click()
	inside = {}
	for _, spot in ipairs(shown(overlay.QuestSpots)) do inside[spot.quest.questID] = spot end
	check(not inside[96395] and inside[98423], "done: its mark is gone, the other stays")
	Mock.questsDone[96395] = nil
	WorldMapFrame:Hide()

	-- A start that is not always in the same place: a mark on each of its spots. The Crest of
	-- Lordaeron's spots were MapUtils', and foreverchanges.pro places none, so it has no mark
	-- now; two stand-in spots try the feature.
	local ruins = ns.GetInstance("RuinsOfLordaeron")
	ns.Journal:OpenInstance(ruins)
	tabs[1]:Click()
	page.InstanceOverview.MapButton:Click()
	local function ruinsMarks()
		local crests, truman = {}, nil
		for _, spot in ipairs(shown(overlay.QuestSpots)) do
			if spot.quest.questID == 95189 then crests[#crests + 1] = spot end
			if spot.quest.questID == 95250 then truman = spot end
		end
		return crests, truman
	end
	local crests, truman = ruinsMarks()
	check(#crests == 0 and truman, "Captain Truman marked inside; the crest, with no spots, is not")
	WorldMapFrame:Hide()
	local crestQuest
	for _, quest in ipairs(ruins.quests) do if quest.questID == 95189 then crestQuest = quest end end
	crestQuest.startInside = { { x = 0.30, y = 0.40, floor = 1 }, { x = 0.60, y = 0.20, floor = 1 } }
	page.InstanceOverview.MapButton:Click()
	crests = ruinsMarks()
	check(#crests == 2, "a quest with two possible starts, a mark on each, got " .. #crests)
	crests[1]:_RunScript("OnEnter")
	check(GameTooltip:HasLine(string.format(ns.L.QUESTMAP_ONE_OF, 2)), "its tooltip says it is one of two spots")
	crests[1]:_RunScript("OnLeave")
	crestQuest.startInside = nil
	WorldMapFrame:Hide()

	-- A boss found in one of several places: a pin on each
	ns.Journal:OpenInstance(ns.GetInstance("TheStockade"))
	tabs[1]:Click()
	page.InstanceOverview.MapButton:Click()
	local targorr = {}
	for _, pin in ipairs(shown(overlay.Pins)) do
		if pin.boss.name == "Targorr the Dread" then targorr[#targorr + 1] = pin end
	end
	check(#targorr == 4, "Targorr the Dread's four cells, a pin on each")
	-- Maybes: smaller and faded; pointing at one lights up all of that boss's spots
	local kam, bruegal
	for _, pin in ipairs(shown(overlay.Pins)) do
		if pin.boss.name == "Kam Deepfury" then kam = pin end
		if pin.boss.name == "Bruegal Ironknuckle" then bruegal = pin end
	end
	local function allOf(pins, alpha, small)
		for _, pin in ipairs(pins) do
			if math.abs(pin:GetAlpha() - alpha) > 1e-9 or (pin:GetScale() < kam:GetScale() * 0.99) ~= small then return false end
		end
		return true
	end
	local function onScreenX(pin) return pin._points[1][4] * pin:GetScale() end
	local cellX = onScreenX(targorr[2])
	check(kam:GetAlpha() == 1 and allOf(targorr, 0.6, true) and allOf({ bruegal }, 0.6, true),
		"a boss always in one place has a full pin; one of several places, smaller faded ones")
	targorr[1]:_RunScript("OnEnter")
	check(allOf(targorr, 1, false) and allOf({ bruegal }, 0.3, true) and kam:GetAlpha() == 1
		and targorr[2]:GetFrameLevel() > kam:GetFrameLevel() and math.abs(onScreenX(targorr[2]) - cellX) < 1e-6,
		"pointing at one lights up all four in place, full size and on top, and fades the other maybes further")
	check(GameTooltip:HasLine(string.format(ns.L.MAP_ONE_OF, 4)), "its tooltip says he is in one of four")
	targorr[1]:_RunScript("OnLeave")
	check(allOf(targorr, 0.6, true) and allOf({ bruegal }, 0.6, true), "and they go back when the pointer leaves")
	kam:_RunScript("OnEnter")
	check(allOf(targorr, 0.6, true) and kam:GetAlpha() == 1, "pointing at a boss in one place changes nothing else")
	kam:_RunScript("OnLeave")
	WorldMapFrame:Hide()

	-- Bosses that share a spot: side by side, not one over the other
	ns.Journal:OpenInstance(ns.GetInstance("ScarletMonasteryGraveyard"))
	tabs[1]:Click()
	page.InstanceOverview.MapButton:Click()
	local rares = {}
	for _, pin in ipairs(shown(overlay.Pins)) do
		if pin.boss.name ~= "Interrogator Vishas" and pin.boss.name ~= "Bloodmage Thalnos" then rares[#rares + 1] = pin end
	end
	check(#rares == 18, "the graveyard's three rares, a pin at each of their six places, got " .. #rares)
	local together = {}
	for _, pin in ipairs(rares) do
		if math.abs(pin._points[1][5] - rares[1]._points[1][5]) < 1e-6 then together[#together + 1] = pin._points[1][4] end
	end
	table.sort(together)
	check(#together == 3 and math.abs(together[2] - together[1] - 30) < 0.01 and math.abs(together[3] - together[2] - 30) < 0.01,
		"the three at one place, spread side by side")
	WorldMapFrame:Hide()

	-- The Armory and the Cathedral, the last wings in the beta: the site's pictures, and their bosses
	for key, expected in pairs({ ScarletMonasteryArmory = "Herod", ScarletMonasteryCathedral =
		"High Inquisitor Fairbanks, High Inquisitor Whitemane, Scarlet Commander Mograine" }) do
		ns.Journal:OpenInstance(ns.GetInstance(key))
		tabs[1]:Click()
		page.InstanceOverview.MapButton:Click()
		local file = key == "ScarletMonasteryArmory" and "scarlet-monastery-armory" or "scarlet-monastery-cathedral"
		check(overlay:IsShown() and overlay.Art.Picture:GetTexture():find("Media\\Maps\\Dungeons\\" .. file, 1, true),
			key .. " drawn from the site's picture")
		local names = {}
		for _, pin in ipairs(shown(overlay.Pins)) do names[#names + 1] = pin.boss.name end
		table.sort(names)
		check(table.concat(names, ", ") == expected, key .. "'s bosses pinned: " .. table.concat(names, ", "))
		WorldMapFrame:Hide()
	end
	-- Every drop and reward has a name to show while the server has not described the item
	-- (Atrexis's 273036 is the stand-in an earlier test gave him, named only by the server).
	local nameless = {}
	local function Named(instance, row)
		if not row.name and not (instance.key == "CityOfDalaran" and row.itemID == 273036) then
			nameless[#nameless + 1] = instance.key .. " " .. tostring(row.itemID)
		end
	end
	for _, kind in ipairs({ "dungeon", "raid" }) do
		for _, instance in ipairs(ns.GetInstances(kind)) do
			for _, boss in ipairs(instance.bosses) do
				for _, row in ipairs(boss.loot or {}) do Named(instance, row) end
			end
			for _, quest in ipairs(instance.quests or {}) do
				for _, row in ipairs(quest.rewards and quest.rewards.items or {}) do Named(instance, row) end
			end
		end
	end
	check(#nameless == 0, "every drop and reward in the journal has a name to show until the server answers: " .. table.concat(nameless, ", "))
	local might
	for _, boss in ipairs(ns.GetInstance("ScarletMonasteryCathedral").bosses) do
		for _, row in ipairs(boss.loot or {}) do if row.itemID == 7723 then might = row end end
	end
	check(might and might.name == "Mograine's Might" and might.quality == 3 and might.slot == "Two-Hand, Mace"
		and not Mock.itemsCached[7723] and ns.Items:Get(7723, might).name == "Mograine's Might",
		"the Cathedral's drops named as the site lists them, before the server describes them")

	-- Loot as the site lists it: other sources' extras gone, quest items kept, Scorn and Sever gone
	local function lootOf(key, name)
		local found = {}
		for _, boss in ipairs(ns.GetInstance(key).bosses) do
			if boss.name == name or (name == "Trash" and boss.trash) then
				for _, row in ipairs(boss.loot) do found[row.itemID] = true end
				return found
			end
		end
	end
	local mutanus, cobrahn, keepTrash = lootOf("WailingCaverns", "Mutanus the Devourer"), lootOf("WailingCaverns", "Lord Cobrahn"),
		lootOf("ShadowfangKeep", "Trash")
	check(mutanus[10441] and not mutanus[1468] and not mutanus[6564], "Mutanus drops what the site lists, not the world drops another source saw")
	check(cobrahn[6460] and cobrahn[9738] and not cobrahn[1789], "Lord Cobrahn keeps his gem for the Fanglords quest")
	check(keepTrash[5943] and keepTrash[6341], "the keep's trash lists what the site lists for it")
	check(not lootOf("ScarletMonasteryGraveyard", "Scorn") and not lootOf("ShadowfangKeep", "Sever"),
		"Scorn and Sever, on no page of the site, are gone")
end

-- Dungeon entrances on zone and continent maps, as retail draws them
OpenWorldMap(1436)
local doors = WorldMapFrame:ActivePins("AegisJournalEntrancePinTemplate")
-- Its portal is in the mine below Moonbrook, read on the continent: placed on Westfall through world coordinates
check(#doors == 1 and doors[1].instance.key == "TheDeadmines" and math.abs(doors[1]._position[1] - (406.9 - 340) / 100) < 1e-9
	and math.abs(doors[1]._position[2] - (0.7958 * 1500 - 1130) / 120) < 1e-9, "the Deadmines door on the Westfall map, over its portal")
check(doors[1].Texture._atlas == "Dungeon" and doors[1].HighlightTexture._atlas == "Dungeon"
	and doors[1]._frameLevelType == "PIN_FRAME_LEVEL_DUNGEON_ENTRANCE" and doors[1]._scalingLimits[2] == 1.0,
	"with retail's dungeon icon, highlight, level and scaling")
doors[1]:_RunScript("OnEnter")
check(GameTooltip._text == "The Deadmines", "its tooltip names the dungeon")
doors[1]:_RunScript("OnLeave")
WorldMapFrame:SetMapID(1415)
doors = WorldMapFrame:ActivePins("AegisJournalEntrancePinTemplate")
local doorNames, deadminesDoor = {}, nil
for _, pin in ipairs(doors) do
	doorNames[#doorNames + 1] = pin.instance.key
	if pin.instance.key == "TheDeadmines" then deadminesDoor = pin end
end
table.sort(doorNames)
check(table.concat(doorNames, ",") == "BlackrockDepths,CityOfDalaran,HallOfThanes,RuinsOfLordaeron,ScarletMonasteryGraveyard,TheDeadmines,"
	.. "TheStockade",
	"the continent shows the doors of its zones: " .. table.concat(doorNames, ","))
check(deadminesDoor._position[1] == 0.4069 and deadminesDoor._position[2] == 0.7958, "on the continent where it was read")
WorldMapFrame:SetMapID(1414)
check(#WorldMapFrame:ActivePins("AegisJournalEntrancePinTemplate") == 0, "none on a continent whose zones it does not know")
-- A door given in the world's coordinates (as the game's data has Maraudon's): put on its zone's
-- map by the client, the axis order being the one that lands on it
do
	local maraudon = ns.GetInstance("Maraudon")
	local door = ns.DungeonMap:Entrance(maraudon)
	check(door and door.mapID == 1443 and math.abs(door.x - (2918.4 - 2800) / 300) < 1e-6
		and math.abs(door.y - (-1422.6 + 1600) / 400) < 1e-6, "Maraudon's door, from the world's coordinates onto Desolace")
	WorldMapFrame:SetMapID(1443)
	local onDesolace = WorldMapFrame:ActivePins("AegisJournalEntrancePinTemplate")
	check(#onDesolace == 1 and onDesolace[1].instance.key == "Maraudon", "and shown there")
	check(ns.DungeonMap:Entrance(ns.GetInstance("ZulFarrak")) == nil, "a door on a map the client does not have stays off it")
end
WorldMapFrame:SetMapID(947)
check(#WorldMapFrame:ActivePins("AegisJournalEntrancePinTemplate") == 0, "and none on the world map itself, as on retail")

WorldMapFrame:SetMapID(1436)
doors = WorldMapFrame:ActivePins("AegisJournalEntrancePinTemplate")
doors[1]:Click("RightButton")
check(Mock.userWaypoint and Mock.userWaypoint.uiMapID == 1436 and Mock.userWaypoint.position.x == 0.4254
	and Mock.superTracked, "right-click: the client's own waypoint, to the way down in Moonbrook")
check(chatContains("Waypoint set to the way down into Defias Hideout, for The Deadmines."), "and says so")
local stockade = ns.GetInstance("TheStockade")
check(ns.DungeonMap:SetWaypoint(stockade) and chatContains("Waypoint set to the entrance of The Stockade"),
	"a door with no way down gets its waypoint at the door")
Mock.cvars.showDungeonEntrancesOnMap = "0"
Mock.Fire("CVAR_UPDATE", "showDungeonEntrancesOnMap")
check(#WorldMapFrame:ActivePins("AegisJournalEntrancePinTemplate") == 0, "the map's Dungeon Entrances option hides them")
Mock.cvars.showDungeonEntrancesOnMap = "1"
Mock.Fire("CVAR_UPDATE", "showDungeonEntrancesOnMap")
doors = WorldMapFrame:ActivePins("AegisJournalEntrancePinTemplate")
check(#doors == 1, "and brings them back")
doors[1]:Click("LeftButton")
check(not WorldMapFrame:IsShown() and page:IsShown() and page.instance.key == "TheDeadmines" and f.selectedTab == 1,
	"left-click opens the dungeon in the journal")

-- The Defias Hideout below Moonbrook: the client reports it on the continent, its way down shows on Westfall
OpenWorldMap(1436)
local moonbrookCave = WorldMapFrame:ActivePins("AegisJournalCavePinTemplate")[1]
check(moonbrookCave and moonbrookCave.subMap.key == "DeadminesApproach" and moonbrookCave._position[1] == 0.4254
	and moonbrookCave._position[2] == 0.7176 and moonbrookCave.Texture._atlas == "CaveUnderground-Up",
	"the cave entrance at the Moonbrook house's door, on Westfall's map")
moonbrookCave:_RunScript("OnEnter")
check(GameTooltip._text == "Defias Hideout" and GameTooltip:HasLine("The way to The Deadmines"), "its tooltip")
moonbrookCave:_RunScript("OnLeave")
local westfallDoor = WorldMapFrame:ActivePins("AegisJournalEntrancePinTemplate")[1]
westfallDoor:_RunScript("OnEnter")
check(GameTooltip:HasLine("Its portal is below, in Defias Hideout: go down at the cave entrance."), "the Deadmines door points to it")
westfallDoor:_RunScript("OnLeave")
WorldMapFrame:SetMapID(1415)
check(#WorldMapFrame:ActivePins("AegisJournalCavePinTemplate") == 0, "the cave shows on its zone, not the continent")
WorldMapFrame:Hide()
-- Down in the mine, M opens on the continent: the hideout's own map shows
Mock.playerMapID, Mock.playerX, Mock.playerY, Mock.subzone = 1415, 0.4069, 0.7958, "The Deadmines"
OpenWorldMap()
local mine = DungeonMap:Overlay()
check(mine:IsShown() and mine.subMap and mine.subMap.key == "DeadminesApproach"
	and mine.Art.Picture:GetTexture():find("Media\\Maps\\DeadminesApproach", 1, true), "in the mine, the world map shows the hideout's map")
check(mine.Doors[1]:IsShown() and mine.Doors[1].instance.key == "TheDeadmines", "with the Deadmines portal on it")
local mineArrow = mine.PlayerPin
check(mineArrow:IsShown() and math.abs(mineArrow._points[1][4] - 0.248 * mine.Art._width) < 1e-3, "and the player at the portal")
WorldMapFrame:Hide()
Mock.playerMapID, Mock.playerX, Mock.playerY, Mock.subzone = nil, nil, nil, ""

-- In combat the map still hands out the journal's pins: none of them asks the blocked call
Mock.inCombat = true
OpenWorldMap(1436)
check(#WorldMapFrame:ActivePins("AegisJournalEntrancePinTemplate") == 1 and #WorldMapFrame:ActivePins("AegisJournalCavePinTemplate") == 1,
	"pins placed in combat without SetPassThroughButtons")
WorldMapFrame:Hide()
Mock.inCombat = false

-- Old Ironforge: the way down on the Ironforge map, and its own map below
OpenWorldMap(1455)
local hallDoor, cave
for _, pin in ipairs(WorldMapFrame:ActivePins("AegisJournalEntrancePinTemplate")) do
	if pin.instance.key == "HallOfThanes" then hallDoor = pin end
end
cave = WorldMapFrame:ActivePins("AegisJournalCavePinTemplate")[1]
check(hallDoor and hallDoor._position[1] == 0.2815 and hallDoor._position[2] == 0.4775,
	"the Hall of Thanes over its portal on the Ironforge map")
check(cave and cave.subMap.key == "OldIronforge" and cave.Texture._atlas == "CaveUnderground-Up"
	and cave._position[1] == 0.435 and cave._position[2] == 0.52, "retail's cave entrance where the way down is")
check(#WorldMapFrame:ActivePins("AegisJournalCavePinTemplate") == 1, "one cave")
hallDoor:_RunScript("OnEnter")
check(GameTooltip:HasLine("Its portal is below, in Old Ironforge: go down at the cave entrance."), "the dungeon's tooltip points to the cave")
cave:_RunScript("OnEnter")
check(GameTooltip._text == "Old Ironforge" and GameTooltip:HasLine("The way to The Hall of Thanes")
	and GameTooltip:HasLine("Left-click to see the map of Old Ironforge"), "the cave says where it leads")
check(Mock.areaLabel and Mock.areaLabel.name == "Old Ironforge" and Mock.areaLabel.description == "Cave Entrance",
	"and the map's area label calls it a cave entrance")
cave:_RunScript("OnLeave")
check(Mock.areaLabel == nil, "the label goes with the mouse")
hallDoor:Click("RightButton")
check(Mock.userWaypoint.uiMapID == 1455 and Mock.userWaypoint.position.x == 0.435 and Mock.userWaypoint.position.y == 0.52
	and chatContains("Waypoint set to the way down into Old Ironforge, for The Hall of Thanes."),
	"the dungeon's waypoint leads to the way down, which is walkable")
cave:Click("RightButton")
check(chatContains("Waypoint set to the way down into Old Ironforge."), "so does the cave's")

-- Left-click on the cave: Old Ironforge over the world map
cave:Click("LeftButton")
local below = DungeonMap:Overlay()
check(below:IsShown() and below.subMap and below.subMap.key == "OldIronforge"
	and below.Art.Picture:GetTexture():find("Media\\Maps\\OldIronforge", 1, true)
	and math.abs(below.Art.Picture._texCoord[2] - 1002 / 1024) < 1e-9, "left-click shows the Old Ironforge map")
local belowW, belowH = below.Art._width, below.Art._height
check(math.abs(belowW / belowH - 1002 / 668) < 1e-6, "in its own shape")
local portalDoor = below.Doors[1]
check(portalDoor:IsShown() and portalDoor.instance.key == "HallOfThanes" and portalDoor.Texture._atlas == "Dungeon"
	and math.abs(portalDoor._points[1][4] - 0.21 * belowW) < 1e-6, "the Hall of Thanes marked at its portal")
check(#shown(below.Pins) == 0 and not below.Here:IsShown(), "and nothing of a dungeon map")
Mock.playerX, Mock.playerY = 0.4599, 0.5935
DungeonMap:Refresh()
local arrow = below.PlayerPin
check(arrow:IsShown() and math.abs(arrow._points[1][4] - 0.765 * belowW) < 1e-3 and math.abs(arrow._points[1][5] + 0.88 * belowH) < 1e-3,
	"the player's arrow where the two readings put it")
below:_RunScript("OnMouseUp", "RightButton")
check(not below:IsShown(), "right-click goes back to Ironforge")
WorldMapFrame:Hide()

-- Walking down: the map shows Old Ironforge by itself, and Ironforge again on the way up
Mock.playerMapID = 1455
Mock.playerX, Mock.playerY, Mock.subzone = 0.2815, 0.4775, "Ironforge"
OpenWorldMap()
check(below:IsShown() and below.subMap.key == "OldIronforge", "down below, M shows Old Ironforge")
Mock.subzone = "The Commons"
Mock.Fire("ZONE_CHANGED")
check(not below:IsShown(), "in a named street above, it is Ironforge again")
Mock.subzone = "Ironforge"
Mock.Fire("ZONE_CHANGED_INDOORS")
check(below:IsShown(), "and back below, Old Ironforge")
WorldMapFrame:Hide()
check(not arrow:IsShown(), "the arrow stops with the map")
Mock.playerX, Mock.playerY = 0.80, 0.20
OpenWorldMap()
check(not below:IsShown(), "a nameless spot outside its picture is not Old Ironforge")
WorldMapFrame:Hide()

-- The arrival below reads "The High Seat", like the throne room above: followed with the map closed
Mock.playerX, Mock.playerY, Mock.subzone = 0.4599, 0.5935, "The High Seat"
Mock.Fire("ZONE_CHANGED_NEW_AREA")
OpenWorldMap()
check(not below:IsShown(), "in The High Seat, not seen below yet: Ironforge")
WorldMapFrame:Hide()
Mock.playerX, Mock.playerY, Mock.subzone = 0.2815, 0.4775, "Ironforge"
Mock.Fire("ZONE_CHANGED")
Mock.playerX, Mock.playerY, Mock.subzone = 0.4599, 0.5935, "The High Seat"
Mock.Fire("ZONE_CHANGED")
OpenWorldMap()
check(below:IsShown() and below.subMap.key == "OldIronforge", "walked below with the map closed: The High Seat's spot below stays Old Ironforge")
WorldMapFrame:Hide()
Mock.playerX, Mock.playerY, Mock.subzone = 0.50, 0.45, "The Great Forge"
Mock.Fire("ZONE_CHANGED")
Mock.playerX, Mock.playerY, Mock.subzone = 0.4599, 0.5935, "The High Seat"
Mock.Fire("ZONE_CHANGED")
OpenWorldMap()
check(not below:IsShown(), "after a street above, The High Seat is the throne room again")
WorldMapFrame:Hide()
Mock.playerX, Mock.playerY, Mock.subzone = 0.2815, 0.4775, "Ironforge"
Mock.Fire("ZONE_CHANGED")
Mock.playerMapID = 1453
Mock.Fire("ZONE_CHANGED_NEW_AREA")
Mock.playerMapID, Mock.subzone = 1455, "The High Seat"
Mock.playerX, Mock.playerY = 0.4599, 0.5935
Mock.Fire("ZONE_CHANGED_NEW_AREA")
OpenWorldMap()
check(not below:IsShown(), "leaving the zone forgets being below")
WorldMapFrame:Hide()
Mock.playerX, Mock.playerY, Mock.playerMapID, Mock.subzone = nil, nil, nil, ""

-- Other addons' pins in a higher strata (RareScanner's) stay under the dungeon map while it is up
local rsLayer = CreateFrame("Frame", nil, WorldMapFrame:GetCanvas())
local rsPin = CreateFrame("Frame", nil, rsLayer)
rsPin:SetFrameStrata("DIALOG")
rsPin:SetFrameLevel(9000)
local mapButton = CreateFrame("Button", nil, WorldMapFrame)
mapButton:SetFrameStrata("HIGH")
DungeonMap:Show(ns.GetInstance("HallOfThanes"))
local dungeonOverlay = DungeonMap:Overlay()
check(dungeonOverlay:IsShown() and rsPin:GetFrameStrata() == dungeonOverlay:GetFrameStrata()
	and rsPin:GetFrameLevel() < dungeonOverlay:GetFrameLevel(), "a higher-strata pin on the canvas goes under the dungeon map")
check(mapButton:GetFrameStrata() == "HIGH", "the map's own buttons are left alone")
rsPin:Hide()
rsPin:SetFrameStrata("HIGH")
rsPin:Show()
check(rsPin:GetFrameStrata() == dungeonOverlay:GetFrameStrata(), "and again when its owner shows it once more")
WorldMapFrame:Hide()
check(rsPin:GetFrameStrata() == "HIGH" and rsPin:GetFrameLevel() == 9000, "it gets its own strata back when the map closes")
rsLayer:Hide()

-- The map's side tabs: Forever's own Quests and Map Legend tabs, which Camelot hides
local log = QuestMapFrame
local function legendTabAnchored()
	local point = log.MapLegendTab._points[1]
	return #log.MapLegendTab._points == 1 and point[1] == "TOP" and point[2] == log.QuestsTab
		and point[3] == "BOTTOM" and point[4] == 0 and point[5] == -3
end
check(log.QuestsTab:IsShown() and log.MapLegendTab:IsShown(), "the Quests and Map Legend tabs show")
check(legendTabAnchored(), "the legend's tab right under the quests tab, as retail has it without events")
local questsPoint = log.QuestsTab._points[1]
check(#log.QuestsTab._points == 1 and questsPoint[1] == "TOPLEFT" and questsPoint[2] == log and questsPoint[3] == "TOPRIGHT"
	and questsPoint[4] == -1 and questsPoint[5] == -28, "the tabs pulled in against Camelot's border")
log:Refresh()
check(log.QuestsTab:IsShown() and log.MapLegendTab:IsShown() and not log.EventsTab:IsShown() and legendTabAnchored(),
	"and stay after the quest log hides them again")

-- The legend knows the journal's icons
local legend = ns.MapLegend
local dungeonEntry, raidEntry, caveEntry = legend:Entry("dungeon"), legend:Entry("raid"), legend:Entry("cave")
check(dungeonEntry and dungeonEntry.nameText == "Dungeon" and raidEntry and raidEntry.nameText == "Raid",
	"the legend's own Dungeon and Raid entries found")
check(caveEntry and caveEntry.atlas == "CaveUnderground-Up" and caveEntry.nameText == "Cave Entrance"
	and caveEntry.templates[1] == "AegisJournalCavePinTemplate", "a Cave Entrance entry with retail's icon")
check(legend:Entry("delve") == nil, "and no Delve entry: the ways down are all caves")
local movement = caveEntry:GetParent()
local flight = select(1, movement:GetChildren())
check(flight.nameText == "Flightpoint" and caveEntry.layoutIndex == 2 and caveEntry.gridRow == 1 and caveEntry.gridColumn == 2
	and flight.gridColumn == 1 and movement.laidOut == 1 and log.MapLegend.ScrollFrame.ScrollChild.laidOut == 1,
	"under Movement, beside Flightpoint, on the legend's two-column grid")

OpenWorldMap(1455)
local ironforgeDoor
for _, pin in ipairs(WorldMapFrame:ActivePins("AegisJournalEntrancePinTemplate")) do
	if pin.instance.key == "HallOfThanes" then ironforgeDoor = pin end
end
local caveDoor = WorldMapFrame:ActivePins("AegisJournalCavePinTemplate")[1]
check(ironforgeDoor.isRaid == false, "entrances say whether they are raids, as the legend asks")
dungeonEntry:_RunScript("OnEnter")
check(ironforgeDoor.legendGlow and ironforgeDoor.legendGlow:IsShown() and ironforgeDoor.legendGlow._atlas == "UI-QuestPoi-OuterGlow",
	"hovering Dungeon in the legend lights up the dungeons, with retail's glow")
check(not caveDoor.legendGlow, "and not the cave")
dungeonEntry:_RunScript("OnLeave")
check(not ironforgeDoor.legendGlow:IsShown(), "until the mouse leaves")
raidEntry:_RunScript("OnEnter")
check(not ironforgeDoor.legendGlow:IsShown(), "Raid does not light up a dungeon")
raidEntry:_RunScript("OnLeave")
caveEntry:_RunScript("OnEnter")
check(caveDoor.legendGlow and caveDoor.legendGlow:IsShown(), "Cave Entrance lights up the cave")
caveEntry:_RunScript("OnLeave")
check(not caveDoor.legendGlow:IsShown(), "and lets it go")
ironforgeDoor:_RunScript("OnEnter")
check(dungeonEntry.highlightLocked == true and not raidEntry.highlightLocked, "hovering a dungeon lights its legend entry")
ironforgeDoor:_RunScript("OnLeave")
check(dungeonEntry.highlightLocked == false, "until the mouse leaves")
caveDoor:_RunScript("OnEnter")
check(caveEntry.highlightLocked == true, "the cave lights its entry too")
caveDoor:_RunScript("OnLeave")
check(caveEntry.highlightLocked == false, "and lets it go")
dungeonEntry:_RunScript("OnEnter")
WorldMapFrame:SetMapID(1415)
local glowing = 0
for _, pin in ipairs(WorldMapFrame:ActivePins("AegisJournalEntrancePinTemplate")) do
	if pin.legendGlow and pin.legendGlow:IsShown() then glowing = glowing + 1 end
end
check(#WorldMapFrame:ActivePins("AegisJournalEntrancePinTemplate") > 0 and glowing == 0,
	"pins taken again from the pool start without the glow")
dungeonEntry:_RunScript("OnLeave")
WorldMapFrame:Hide()

-- Doors several dungeons share are one icon: the Scarlet Monastery's wings
do
	OpenWorldMap(1420)
	local monastery
	for _, pin in ipairs(WorldMapFrame:ActivePins("AegisJournalEntrancePinTemplate")) do
		if #pin.instances > 1 then monastery = pin end
	end
	local others = {}
	for _, pin in ipairs(WorldMapFrame:ActivePins("AegisJournalEntrancePinTemplate")) do
		if pin ~= monastery then others[#others + 1] = pin.instance.key end
	end
	check(monastery and #monastery.instances == 4 and monastery.instance.key == "ScarletMonasteryGraveyard"
		and table.concat(others, ",") == "RuinsOfLordaeron", "the monastery's wings share one door icon, beside the Ruins' own")
	monastery:_RunScript("OnEnter")
	check(GameTooltip._text == "Scarlet Monastery" and GameTooltip:HasLine("Dungeons  Level 30-46")
		and GameTooltip:HasLine("Scarlet Monastery: Library\tLevel 33-41")
		and GameTooltip:HasLine("Scarlet Monastery: Armory\tLevel 36-44")
		and GameTooltip:HasLine("Scarlet Monastery: Cathedral\tLevel 38-46")
		and GameTooltip:HasLine("Left-click to choose one to open in the Instance Journal")
		and Mock.areaLabel.name == "Scarlet Monastery", "its tooltip names the building and lists every wing")
	monastery:_RunScript("OnLeave")
	monastery:Click("RightButton")
	check(chatContains("Waypoint set to the entrance of Scarlet Monastery."), "a right click sets a waypoint to the door")
	monastery:Click("LeftButton")
	local menu = Mock.contextMenu
	check(menu and menu.owner == monastery and menu.title == "Scarlet Monastery" and #menu.buttons == 4
		and menu.buttons[1].text == "Scarlet Monastery: Graveyard" and menu.buttons[2].text == "Scarlet Monastery: Library"
		and menu.buttons[3].text == "Scarlet Monastery: Armory" and menu.buttons[4].text == "Scarlet Monastery: Cathedral",
		"a left click offers the wings, in the journal's order")
	menu.buttons[2].onClick()
	check(page.instance.key == "ScarletMonasteryLibrary" and not WorldMapFrame:IsShown(), "and opens the one chosen")
end

-- Flight points on zone maps: the client knows them but does not draw them
local flightEntry = legend:Entry("flight")
check(flightEntry and flightEntry.nameText == "Flightpoint", "the legend's Flightpoint entry found")
Mock.taxiCalls = 0
OpenWorldMap(1455)
local function flightPins()
	local byName = {}
	for _, pin in ipairs(WorldMapFrame:ActivePins("AegisJournalFlightPinTemplate")) do byName[pin.node.name] = pin end
	return byName
end
local flights = flightPins()
local ironforgeFlight = flights["Ironforge, Dun Morogh"]
check(ironforgeFlight and flights["Light's Hope Chapel"] and not flights["Kargath, Badlands"] and not flights["Thelsamar, Loch Modan"],
	"the Alliance's and neutral flight masters on the map show; the Horde's and those off the map do not")
check(ironforgeFlight._position[1] == 0.556 and ironforgeFlight._position[2] == 0.477 and ironforgeFlight.Texture._atlas == "FlightPath"
	and ironforgeFlight._width == 24 and ironforgeFlight._frameLevelType == "PIN_FRAME_LEVEL_FLIGHT_POINT",
	"where the client places them, with the legend's icon at its size")
ironforgeFlight:_RunScript("OnEnter")
check(GameTooltip._text == "Ironforge, Dun Morogh" and GameTooltip:HasLine("Flight Point") and GameTooltip:HasLine("Click to set a waypoint")
	and flightEntry.highlightLocked == true, "its tooltip, and the legend's Flightpoint lights up")
ironforgeFlight:_RunScript("OnLeave")
check(flightEntry.highlightLocked == false, "until the mouse leaves")
ironforgeFlight:Click("LeftButton")
check(Mock.userWaypoint.uiMapID == 1455 and Mock.userWaypoint.position.x == 0.556
	and chatContains("Waypoint set to the flight master at Ironforge, Dun Morogh."), "a click sets a waypoint to it")
flightEntry:_RunScript("OnEnter")
check(ironforgeFlight.legendGlow and ironforgeFlight.legendGlow:IsShown(), "hovering Flightpoint in the legend lights up the flight points")
flightEntry:_RunScript("OnLeave")
check(not ironforgeFlight.legendGlow:IsShown(), "and lets them go")
local callsSoFar = Mock.taxiCalls
check(callsSoFar <= 1, "the client is asked at most once for a map")
WorldMapFrame:SetMapID(1415)
check(#WorldMapFrame:ActivePins("AegisJournalFlightPinTemplate") == 0, "zone maps only, not the continent")
WorldMapFrame:SetMapID(1455)
check(Mock.taxiCalls == callsSoFar, "and not again on coming back to it")
WorldMapFrame:Hide()
Mock.faction = "Horde"
OpenWorldMap(1455)
flights = flightPins()
check(flights["Kargath, Badlands"] and flights["Light's Hope Chapel"] and not flights["Ironforge, Dun Morogh"], "a Horde player sees the Horde's")
WorldMapFrame:Hide()
Mock.faction, Mock.clientShowsTaxi = "Alliance", true
OpenWorldMap(1455)
check(#WorldMapFrame:ActivePins("AegisJournalFlightPinTemplate") == 0, "where the client draws its own, the journal leaves them to it")
WorldMapFrame:Hide()
Mock.clientShowsTaxi = false

-- Transports: saved by the player where they stand with /aegis travel
SlashCmdList.AEGISJOURNAL("travel")
check(chatContains("Stand at a dock, zeppelin tower, tram or portal and type /aegis travel boat"), "/aegis travel alone explains itself")
SlashCmdList.AEGISJOURNAL("travel list")
check(chatContains("No travel spots saved yet."), "nothing saved yet")
Mock.playerMapID, Mock.playerX, Mock.playerY, Mock.subzone = 1453, 0.22, 0.56, "Stormwind Harbor"
SlashCmdList.AEGISJOURNAL("travel boat Auberdine")
local harbor = ns.db.travel[1]
check(harbor and harbor.kind == "boat" and harbor.mapID == 1453 and harbor.x == 0.22 and harbor.area == "Stormwind Harbor"
	and harbor.to[1] == "Auberdine" and harbor.faction == "Alliance", "a boat saved where the player stands, with its place name kept as typed")
check(chatContains("Saved Boat to Auberdine at Stormwind Harbor."), "and says so")
Mock.playerX = 0.223
SlashCmdList.AEGISJOURNAL("travel boat Valiance Keep")
check(#ns.db.travel == 1 and harbor.to[2] == "Valiance Keep", "a second route from the same dock joins it")
SlashCmdList.AEGISJOURNAL("travel undo")
check(#ns.db.travel == 1 and #harbor.to == 1 and chatContains("Took back Boat to Valiance Keep at Stormwind Harbor."),
	"undo takes back just that route")
SlashCmdList.AEGISJOURNAL("travel undo")
check(chatContains("Nothing to take back."), "and only once")
SlashCmdList.AEGISJOURNAL("travel boat Valiance Keep")
Mock.playerMapID, Mock.playerX, Mock.playerY, Mock.subzone = 1455, 0.765, 0.51, "Tinker Town"
SlashCmdList.AEGISJOURNAL("travel tram Stormwind City")
Mock.playerMapID, Mock.playerX, Mock.playerY, Mock.subzone = 1436, 0.30, 0.40, ""
SlashCmdList.AEGISJOURNAL("travel zeppelin Orgrimmar")
check(#ns.db.travel == 3 and ns.db.travel[3].faction == "Horde", "zeppelins are the Horde's unless told otherwise")
SlashCmdList.AEGISJOURNAL("travel undo")
check(#ns.db.travel == 2, "undo takes back a dock saved by itself")
SlashCmdList.AEGISJOURNAL("TRAVEL Boat Ratchet NEUTRAL")
local neutralDock = ns.db.travel[3]
check(neutralDock and neutralDock.faction == "Neutral" and neutralDock.to[1] == "Ratchet" and #neutralDock.to == 1,
	"a faction word at the end says who it serves, and is not part of the place")
SlashCmdList.AEGISJOURNAL("travel list")
check(chatContains("1. Boat to Auberdine, Boat to Valiance Keep at Stormwind Harbor (map 1453, 0.2200, 0.5600)")
	and chatContains("2. Tram to Stormwind City at Tinker Town"), "list shows every dock and its routes")
Mock.playerMapID, Mock.playerX, Mock.playerY, Mock.subzone = nil, nil, nil, ""

local function transportPins()
	local byArea = {}
	for _, pin in ipairs(WorldMapFrame:ActivePins("AegisJournalTransportPinTemplate")) do byArea[pin.spot.area] = pin end
	return byArea
end
OpenWorldMap(1453)
local harborPin = transportPins()["Stormwind Harbor"]
check(#WorldMapFrame:ActivePins("AegisJournalTransportPinTemplate") == 3 and harborPin.spot == harbor
	and harborPin._position[1] == 0.22 and harborPin.Texture._atlas == "TaxiNode_Continent_Alliance",
	"the dock on its city's map, with retail's teleport icon in Alliance blue, beside the journal's own portal and tram")
local sanctum = transportPins()["Wizard's Sanctum"]
check(sanctum and sanctum._position[1] == 0.4997 and sanctum._position[2] == 0.8686, "the journal's Skyborne portal in the mage tower")
sanctum:_RunScript("OnEnter")
check(GameTooltip._text == "Portal to Dalaran" and GameTooltip:HasLine("Wizard's Sanctum") and GameTooltip:HasLine("  Skyborne only")
	and GameTooltip:HasLine("Alliance"), "its tooltip is named for where it goes, then where it is, and that only the Skyborne may take it")
check(Mock.areaLabel.name == "Portal to Dalaran" and Mock.areaLabel.description == "Wizard's Sanctum",
	"and so is the map's label")
sanctum:_RunScript("OnLeave")
WorldMapFrame:SetMapID(1416)
local enclave = transportPins()["The Sky Enclave"]
check(enclave and enclave._position[1] == 0.1204 and enclave.spot.to[1] == "Stormwind" and enclave.spot.notes.Stormwind == "Skyborne only",
	"and its way back from Dalaran")
local dalaranDock = transportPins()["Dalaran"]
check(dalaranDock and dalaranDock.spot.kind == "airship" and dalaranDock._position[2] == 0.5202
	and dalaranDock.Texture._atlas == "TaxiNode_Continent_Alliance", "the Skyborne airship's dock in Dalaran, beside the portal")
dalaranDock:_RunScript("OnEnter")
check(GameTooltip._text == "Airship to Zephras Isle" and GameTooltip:HasLine("  Skyborne only"), "its tooltip")
dalaranDock:_RunScript("OnLeave")
WorldMapFrame:SetMapID(1453)
harborPin:_RunScript("OnEnter")
check(GameTooltip._text == "Boat to Auberdine and Valiance Keep" and GameTooltip:HasLine("Stormwind Harbor")
	and GameTooltip:HasLine("Alliance") and GameTooltip:HasLine("Click to set a waypoint"), "its tooltip names every place it goes")
check(legend:Entry("transport").highlightLocked == true, "and lights up the legend's Transport entry")
harborPin:_RunScript("OnLeave")
harborPin:Click("LeftButton")
check(Mock.userWaypoint.uiMapID == 1453 and Mock.userWaypoint.position.x == 0.22 and chatContains("Waypoint set to Stormwind Harbor."),
	"a click sets a waypoint to it")
WorldMapFrame:SetMapID(1415)
local onContinent = {}
for _, pin in ipairs(WorldMapFrame:ActivePins("AegisJournalTransportPinTemplate")) do onContinent[pin.spot] = pin end
check(onContinent[harbor] and math.abs(onContinent[harbor]._position[1] - (420 + 0.22 * 60) / 1000) < 1e-9
	and math.abs(onContinent[harbor]._position[2] - (1000 + 0.56 * 50) / 1500) < 1e-9 and onContinent[neutralDock]
	and onContinent[neutralDock].Texture._atlas == "TaxiNode_Continent_Neutral", "docks show on the continent too, the neutral one in gold")
local transportEntry = legend:Entry("transport")
check(transportEntry.nameText == "Transport" and transportEntry.atlas == "TaxiNode_Continent_Neutral" and transportEntry.layoutIndex == 3
	and transportEntry.gridRow == 2 and transportEntry.gridColumn == 1, "a Transport entry under Movement, after Cave Entrance")
transportEntry:_RunScript("OnEnter")
check(onContinent[harbor].legendGlow:IsShown() and onContinent[neutralDock].legendGlow:IsShown(), "hovering it lights up the transports")
transportEntry:_RunScript("OnLeave")
WorldMapFrame:Hide()

-- Routes only some may take: a note in brackets, shown under the route
Mock.playerMapID, Mock.playerX, Mock.playerY, Mock.subzone = 1453, 0.49, 0.87, "The Mage Quarter"
SlashCmdList.AEGISJOURNAL("travel portal Dalaran (Skyborne only)")
local skyPortal = ns.db.travel[#ns.db.travel]
check(skyPortal.kind == "portal" and skyPortal.to[1] == "Dalaran" and skyPortal.notes.Dalaran == "Skyborne only"
	and chatContains("Saved Portal to Dalaran (Skyborne only) at The Mage Quarter."), "a portal saved with who may take it")
Mock.playerX = 0.30
SlashCmdList.AEGISJOURNAL("travel portal Stormwind City (Skyborne only) neutral")
local otherWay = ns.db.travel[#ns.db.travel]
check(otherWay ~= skyPortal and otherWay.to[1] == "Stormwind City" and otherWay.notes["Stormwind City"] == "Skyborne only"
	and otherWay.faction == "Neutral", "the note and the faction word in either order")
SlashCmdList.AEGISJOURNAL("travel undo")
Mock.playerX = 0.49
SlashCmdList.AEGISJOURNAL("travel portal Darnassus neutral (Skyborne only)")
check(skyPortal.to[2] == "Darnassus" and skyPortal.notes.Darnassus == "Skyborne only" and skyPortal.faction == "Neutral",
	"the other order works too")
-- Saved on the journal's own portal: one icon, with the saved route joining it
OpenWorldMap(1453)
local portals = {}
for _, pin in ipairs(WorldMapFrame:ActivePins("AegisJournalTransportPinTemplate")) do
	if pin.spot.kind == "portal" then portals[#portals + 1] = pin end
end
check(#portals == 1 and table.concat(portals[1].spot.to, ", ") == "Dalaran, Darnassus" and portals[1].spot.area == "Wizard's Sanctum",
	"a portal saved on the journal's own joins it, its routes listed once")
check(#ns.GetTransports()[1].to == 1, "without changing the journal's own")
portals[1]:_RunScript("OnEnter")
check(GameTooltip._text == "Portal to Dalaran and Darnassus" and GameTooltip:HasLine("  Dalaran: Skyborne only")
	and GameTooltip:HasLine("  Darnassus: Skyborne only"), "with several routes, each note names its route")
portals[1]:_RunScript("OnLeave")
WorldMapFrame:Hide()
SlashCmdList.AEGISJOURNAL("travel undo")
check(#skyPortal.to == 1 and skyPortal.notes.Darnassus == nil, "undo takes the note back with its route")
OpenWorldMap(1453)
local skyPin = transportPins()["Wizard's Sanctum"]
check(table.concat(skyPin.spot.to, ", ") == "Dalaran", "and the map shows it gone")
skyPin:_RunScript("OnEnter")
check(GameTooltip._text == "Portal to Dalaran" and GameTooltip:HasLine("  Skyborne only"), "the tooltip says who may take it")
skyPin:_RunScript("OnLeave")
WorldMapFrame:Hide()
SlashCmdList.AEGISJOURNAL("travel list")
check(chatContains("Portal to Dalaran (Skyborne only) at The Mage Quarter"), "and so does the list")
Mock.playerX, Mock.playerY = 0.70, 0.20
SlashCmdList.AEGISJOURNAL("travel airship Zephras Isle (Skyborne only) alliance")
local airship = ns.db.travel[#ns.db.travel]
check(airship.kind == "airship" and airship.to[1] == "Zephras Isle" and airship.faction == "Alliance"
	and airship.notes["Zephras Isle"] == "Skyborne only" and chatContains("Saved Airship to Zephras Isle (Skyborne only)"),
	"airships are a kind of their own")
Mock.playerMapID, Mock.playerX, Mock.playerY, Mock.subzone = nil, nil, nil, ""
ns.db.travel = nil

-- The Deeprun Tram's Ironforge end, unchanged from Classic, is the journal's own
OpenWorldMap(1455)
local tram = transportPins()["Tinker Town"]
check(tram and tram.spot.kind == "tram" and tram._position[1] == 0.7628 and tram._position[2] == 0.5131
	and tram.Texture._atlas == "TaxiNode_Continent_Alliance", "the tram's Ironforge end in Tinker Town, in Alliance blue")
tram:_RunScript("OnEnter")
check(GameTooltip._text == "Tram to Stormwind City" and GameTooltip:HasLine("Tinker Town"), "its tooltip says where it goes")
check(GameTooltip:HasLine("Left-click to see the map of Deeprun Tram") and GameTooltip:HasLine("Right-click to set a waypoint")
	and not GameTooltip:HasLine("Click to set a waypoint"), "and that a left click shows the tram's own map")
tram:_RunScript("OnLeave")
tram:Click("LeftButton")
local tramRoom = DungeonMap:Overlay()
check(tramRoom:IsShown() and tramRoom.subMap and tramRoom.subMap.key == "DeeprunTram"
	and tramRoom.Art.Picture:GetTexture():find("Media\\Maps\\DeeprunTram", 1, true)
	and math.abs(tramRoom.Art._width / tramRoom.Art._height - 1000 / 667) < 1e-6, "left-click shows the station room, in its own shape")
check(not tramRoom.PlayerPin:IsShown() and #shown(tramRoom.Doors) == 0, "with no arrow and no dungeon on it")
tramRoom:_RunScript("OnMouseUp", "RightButton")
check(not tramRoom:IsShown(), "right-click goes back to Ironforge")
tram = transportPins()["Tinker Town"]
tram:Click("RightButton")
check(Mock.userWaypoint.uiMapID == 1455 and Mock.userWaypoint.position.x == 0.7628 and chatContains("Waypoint set to Tinker Town."),
	"right-click on the tram sets a waypoint to it")
WorldMapFrame:Hide()
-- Its Stormwind end, saved by the player on Forever's Stormwind map, leads in too
OpenWorldMap(1453)
local stormwindTram = transportPins()["Dwarven District"]
check(stormwindTram and stormwindTram.spot.kind == "tram" and stormwindTram._position[1] == 0.6707
	and stormwindTram._position[2] == 0.3329 and stormwindTram.spot.to[1] == "Ironforge", "the tram's Stormwind end in the Dwarven District")
stormwindTram:Click("LeftButton")
check(DungeonMap:Overlay():IsShown() and DungeonMap:Overlay().subMap.key == "DeeprunTram", "and it shows the station room too")
WorldMapFrame:Hide()
-- So does any tram the player saves
Mock.playerMapID, Mock.playerX, Mock.playerY, Mock.subzone = 1453, 0.30, 0.30, "Somewhere Else"
SlashCmdList.AEGISJOURNAL("travel tram Ironforge")
Mock.playerMapID, Mock.playerX, Mock.playerY, Mock.subzone = nil, nil, nil, ""
OpenWorldMap(1453)
transportPins()["Somewhere Else"]:Click("LeftButton")
check(DungeonMap:Overlay():IsShown() and DungeonMap:Overlay().subMap.key == "DeeprunTram", "a saved tram shows the station room")
WorldMapFrame:Hide()
ns.db.travel = nil

-- The known spots nobody has stood on yet (Data/Travel) fill in the rest, giving way to the spots stood on
OpenWorldMap(1453)
local harborBoat, trams = transportPins()["Stormwind Harbor"], 0
for _, pin in ipairs(WorldMapFrame:ActivePins("AegisJournalTransportPinTemplate")) do
	if pin.spot.kind == "tram" then trams = trams + 1 end
end
check(harborBoat and harborBoat.spot.unvisited and harborBoat.spot.to[1] == "Auberdine" and harborBoat.spot.faction == "Alliance"
	and harborBoat.Texture._atlas == "TaxiNode_Continent_Alliance", "the known Stormwind boat to Auberdine, Alliance as the player told")
check(trams == 1 and transportPins()["Dwarven District"].spot.x == 0.6707, "its tram spot gives way to the one the player stood on")
WorldMapFrame:Hide()
Mock.playerMapID, Mock.playerX, Mock.playerY, Mock.subzone = 1453, 0.235, 0.57, "The Harbor"
SlashCmdList.AEGISJOURNAL("travel boat Auberdine")
Mock.playerMapID, Mock.playerX, Mock.playerY, Mock.subzone = nil, nil, nil, ""
OpenWorldMap(1453)
check(transportPins()["Stormwind Harbor"] == nil and transportPins()["The Harbor"], "and so does its boat, once the player saves one nearby")
WorldMapFrame:Hide()
ns.db.travel = nil
local zeppelins = 0
for _, spot in ipairs(ns.GetTransports()) do
	if spot.unvisited and spot.kind == "zeppelin" then
		zeppelins = zeppelins + 1
		check(spot.faction == "Horde", "the known zeppelins are the Horde's")
	end
end
check(zeppelins == 6, "all six zeppelin towers' sides known, got " .. zeppelins)

-- Inside the tram the client gives no map or position: the zone's name brings up the station room
Mock.instance = { name = "Deeprun Tram", id = 369 }
OpenWorldMap()
check(tramRoom:IsShown() and tramRoom.subMap and tramRoom.subMap.key == "DeeprunTram" and not tramRoom.PlayerPin:IsShown(),
	"M in the tram shows the station room, without an arrow")
WorldMapFrame:Hide()
Mock.instance = { name = "Some Other Place", id = 4242 }
OpenWorldMap()
check(not (tramRoom:IsShown() and tramRoom.subMap), "elsewhere with no map, nothing of the tram")
WorldMapFrame:Hide()
Mock.instance = nil
OpenWorldMap(1455)
check(not tramRoom:IsShown(), "and out on the streets, the city's own map")
WorldMapFrame:Hide()

-- /aegis taxi: the flight points the client knows on the player's map, and its travel icons
SlashCmdList.AEGISJOURNAL("taxi")
check(chatContains("Map 1455  shows flight points itself: false  flight points on it: 4 (3 discovered)  Ironforge, Dun Morogh [TaxiNode_Alliance]"),
	"/aegis taxi reports the map's flight points")
check(chatContains("Travel icons: FlightPath Yes, TaxiNode_Continent_Neutral Yes"), "and which travel icons the client has")
check(ns.db.taxi[#ns.db.taxi].count == 4, "and keeps the reading")

-- Home
f.NavBar._nav[1].OnClick()
check(not page:IsShown() and dungeons:IsShown(), "Home goes back to the list")
check(#f.NavBar._nav == 1, "breadcrumbs cleared on Home")

-- Tabs
f.Tabs[2]:Click()
check(raids:IsShown() and not dungeons:IsShown(), "Raids tab shows its panel")
do
	local raidNames = visibleButtons(raids)
	check(#raidNames == 3 and not raids.Empty:IsShown(), "three raids, waiting to open: " .. table.concat(raidNames, ", "))
	local barrow = buttonNamed(raids, "Barrow Deeps")
	check(barrow.Forever:IsShown() and barrow.Art:GetTexture():find("Media\\Raids\\BarrowDeeps", 1, true)
		and not buttonNamed(raids, "Onyxia's Lair").Forever:IsShown(), "Forever's new raids marked, with their pictures")
	barrow:Click()
	local soon = page.ComingSoon
	check(page:IsShown() and soon:IsShown() and soon.Link:GetText() == "https://discord.gg/Hr66t25vE7"
		and soon.Text:GetText() == ns.L.COMING_SOON_TEXT and soon._points[1][3] == -6,
		"a raid with nothing known yet: coming soon, and our Discord, at the top of the page")
	soon.Link:SetText("typed over")
	soon.Link:_RunScript("OnTextChanged", true)
	check(soon.Link:GetText() == ns.DISCORD_URL, "typing in the link's box puts the link back")
	ns.Journal:OpenInstance(ns.GetInstance("OnyxiasLair"))
	check(page.Bosses.Buttons[1]:IsShown() and page.Bosses.Buttons[1].Name:GetText() == "Onyxia" and soon:IsShown()
		and soon._points[1][3] == -76 and soon.Text:GetText() == ns.L.COMING_SOON_PARTLY,
		"Onyxia's Lair: its boss, then the box beneath her")
	check(page.InstanceOverview.Picture:GetTexture():find("Media\\Raids\\OnyxiasLair", 1, true)
		and page.info.InstanceButton.Icon._texCoord[1] == 0.05, "its overview from her painting, the round icon cut around her head")
	-- A dungeon with no picture of its own gets the journal's placeholder, cut like a raid's
	local blackmaw = ns.GetInstance("BlackmawHold")
	check(blackmaw.placeholderArt and blackmaw.buttonArt:find("Media\\DungeonPlaceholder", 1, true)
		and not ns.GetInstance("HallOfThanes").placeholderArt, "a dungeon without a picture gets the placeholder")
	ns.Journal:OpenInstance(blackmaw)
	local picture = page.InstanceOverview.Picture
	check(picture:GetTexture() == blackmaw.buttonArt and picture._texCoord[1] == 0.083 and picture._texCoord[2] == 0.917,
		"on its overview, framed")
	check(page.InstanceOverview.Lore.Text:GetText():find("|cff123a6eNew in WoW: Forever.|r", 1, true),
		"its Forever line in a blue that reads on the parchment")
	ns.Journal:OpenInstance(ns.GetInstance("TheDeadmines"))
	check(not soon:IsShown(), "no box on a dungeon that is open")
	ns.Journal:OpenInstance(ns.GetInstance("HallOfThanes"))
	check(page.InstanceOverview.Lore.Text:GetText():find("New in WoW: Forever", 1, true), "a Forever dungeon's overview says so")
end
f.Tabs[3]:Click()
check(reputation:IsShown(), "Reputation tab shows its panel")
check(ns.charDB.lastTab == "reputation", "last tab remembered, by its name")
check(ns.Journal:SavedTabIndex(4) == 5 and ns.Journal:SavedTabIndex(5) == 4 and ns.Journal:SavedTabIndex("record") == 5
	and ns.Journal:SavedTabIndex(nil) == 1 and ns.Journal:SavedTabIndex(9) == 1 and ns.Journal:SavedTabIndex("gone") == 1,
	"a tab saved by its place before Gear Finder came in reopens as the same tab")
dungeons.Buttons[1]:Click()
check(f.selectedTab == 1 and f.Tabs and page:IsShown(), "opening a dungeon from another tab brings Dungeons forward")
local dungeonTab = page.tab
f.Tabs[3]:Click()
check(not page:IsShown() and reputation:IsShown(), "switching tabs closes an open dungeon page")

------------------------------------------------------------------------------------------
-- Reputation tab
------------------------------------------------------------------------------------------

-- Confirmed rewards come only from captured quartermasters: the Azeroth Commerce Authority's and
-- Durotar Supply and Logistics' so far (Data/Reputation/Captured.lua). Every other faction lists the
-- rewards the game's item data gives (Data/Reputation/Listed.lua), unconfirmed until its
-- quartermaster is captured
do
	local waiting = 0
	for _, faction in ipairs(ns.GetFactions()) do
		if not ns.FactionCaptured(faction) then waiting = waiting + 1 end
	end
	check(waiting == 21, "no faction has confirmed rewards before its quartermaster is captured, got " .. (23 - waiting))
	check(rawget(buttonNamed(reputation, "Booty Bay"), "Count") == nil
		and ns.Reputation:RewardCount(ns.GetInstance("Faction21")) == 6 and not ns.FactionCaptured(ns.GetInstance("Faction21")),
		"cards show no count; Booty Bay lists six unconfirmed rewards")
	check(buttonNamed(reputation, "Durotar Supply and Logistics").Forever:IsShown()
		and buttonNamed(reputation, "Azeroth Commerce Authority").Forever:IsShown()
		and not buttonNamed(reputation, "Booty Bay").Forever:IsShown(),
		"Forever's own factions wear its emblem, as its dungeons do")
	check(not reputation.Capture:IsEnabled() and reputation.CaptureStatus:GetText() == "Open a quartermaster's shop to capture their wares.",
		"Capture waits for a shop to be open")
end
-- A captured quartermaster, as a build's capture (Data/Reputation/Captured.lua) brings one in
ns.AddCapturedVendors({ { npcID = 10857, name = "Argent Quartermaster Lightspark", mapID = 1422, x = 0.426, y = 0.836, wares = {
	{ itemID = 13724, faction = "Argent Dawn", reaction = 5, price = 6000 },
	{ itemID = 4996, faction = "Argent Dawn", reaction = 6 }, { itemID = 13482, faction = "Argent Dawn", reaction = 6 },
	{ itemID = 19446, faction = "Argent Dawn", reaction = 6 }, { itemID = 19442, faction = "Argent Dawn", reaction = 6 },
	{ itemID = 19216, faction = "Argent Dawn", reaction = 6 }, { itemID = 227896, faction = "Argent Dawn", reaction = 6 },
	{ itemID = 19328, faction = "Argent Dawn", reaction = 6 }, { itemID = 19203, faction = "Argent Dawn", reaction = 6 },
	{ itemID = 1164, faction = "Argent Dawn", reaction = 6 }, { itemID = 22014, faction = "Argent Dawn", reaction = 6 },
	{ itemID = 12698, faction = "Argent Dawn", reaction = 7 }, { itemID = 19447, faction = "Argent Dawn", reaction = 7 },
	{ itemID = 19217, faction = "Argent Dawn", reaction = 7 }, { itemID = 227897, faction = "Argent Dawn", reaction = 7 },
	{ itemID = 19329, faction = "Argent Dawn", reaction = 7 }, { itemID = 227895, faction = "Argent Dawn", reaction = 7 },
	{ itemID = 19205, faction = "Argent Dawn", reaction = 7 }, { itemID = 22704, faction = "Argent Dawn", reaction = 7 },
	{ itemID = 13810, faction = "Argent Dawn", reaction = 7 }, { itemID = 13813, faction = "Argent Dawn", reaction = 7 },
	{ itemID = 22703, faction = "Argent Dawn", reaction = 8, cost = "2 Arcane Crystal" },
} } })
ns.FactionSelect:Refresh(reputation)
do
	local argentDawn, unconfirmed = ns.GetInstance("Faction529"), 0
	for _, standing in ipairs(argentDawn.bosses) do
		for _, row in ipairs(standing.loot) do if row.listed then unconfirmed = unconfirmed + 1 end end
	end
	check(ns.FactionCaptured(argentDawn) and unconfirmed == 0, "the capture confirms every listed reward it finds")
end

-- A card per faction, by name
local cards = visibleButtons(reputation)
check(#cards == 23 and #cards == #ns.GetFactions(), "a card for each of the 23 factions, got " .. #cards)
check(cards[1] == "Argent Dawn" and cards[23] == "Zandalar Tribe", "factions in name order")
check(not reputation.Empty:IsShown(), "no empty message")
local argent = buttonNamed(reputation, "Argent Dawn")
check(argent.Standing:GetText() == "Honored" and argent.Standing._textColor[3] == 0.95, "the player's standing, Honored blue")
check(ns.Reputation:RewardCount(argent.faction) == 22, "Argent Dawn's 22 rewards")
check(argent.Crest:GetTexture() == "Interface\\Icons\\INV_Misc_Token_ArgentDawn" and argent.Crest._maskTextures,
	"the faction's crest, rounded")
check(argent.Rim._maskTextures and argent.Edge._maskTextures and argent.Rim._width == argent.Crest._width + 6,
	"in a true circle: a round gold rim around it")
local function centre(texture) local p = texture._points[1]; return p[1] .. p[3] .. p[4] .. p[5] end
check(centre(argent.Rim) == centre(argent.Crest) and centre(argent.Edge) == centre(argent.Crest), "rim, edge and crest share a centre")
check(reputation.Scroll.scrollBarX == 6, "the grid's scroll bar in the backdrop's gutter, where retail puts it")
check(buttonNamed(reputation, "Booty Bay").Standing:GetText() == "Not met", "a faction the player has not met")
check(ns.FactionCaptured(ns.GetInstance("Faction2587")) and ns.FactionCaptured(ns.GetInstance("Faction2586")),
	"both Merchant's Favor factions captured")
argent:_RunScript("OnEnter")
check(GameTooltip._text == "Argent Dawn", "card tooltip names the faction")
do
	local namesQuartermaster = false
	for _, line in ipairs(GameTooltip._lines) do
		if line == "Quartermaster: Argent Quartermaster Lightspark" then namesQuartermaster = true end
	end
	check(namesQuartermaster, "and its quartermaster")
end
argent:_RunScript("OnLeave")

-- The factions WoW: Forever brought are known (numbered from 2500 up), for a later way to show it
local foreverFactions = 0
for _, faction in ipairs(ns.GetFactions()) do
	if faction.forever then foreverFactions = foreverFactions + 1 end
end
check(foreverFactions == 10 and ns.GetInstance("Faction2740").forever and not ns.GetInstance("Faction529").forever,
	"the ten new factions are known, got " .. foreverFactions)
check(not argent.Forever:IsShown() and buttonNamed(reputation, "Kirin Tor").Forever:IsShown(),
	"the emblem only on the factions Forever added")

-- A crest the client lacks gives way to the faction's best reward
Mock.missingFiles["Interface\\Icons\\NoSuchCrest"] = true
local crest = ns.Reputation:Crest({ icons = { "Interface\\Icons\\NoSuchCrest" },
	bosses = { { loot = { { itemID = 13724 } } }, { loot = { { itemID = 22703 } } } } })
check(crest == 134400 + 22703 % 7, "the highest standing's reward stands in for a missing crest")

-- Opening a faction: its standings on the left page, its rewards on the right
argent:Click()
check(page:IsShown() and not reputation:IsShown() and f.selectedTab == 3, "a faction opens in the book, under Reputation")
check(page.info.InstanceTitle:GetText() == "Argent Dawn"
	and page.info.InstanceButton.Icon:GetTexture() == "Interface\\Icons\\INV_Misc_Token_ArgentDawn", "header: crest and name")
local tabsHidden = true
for _, tab in ipairs(tabs) do if tab:IsShown() then tabsHidden = false end end
check(tabsHidden, "no side tabs on a faction")
check(page.Loot:IsShown() and not page.InstanceOverview:IsShown() and not page.QuestList:IsShown(), "rewards fill the right page")
check(table.concat(visibleBosses(), ", ") == "Friendly, Honored, Revered, Exalted", "standings in order")
local standingButtons = page.Bosses.Buttons
check(standingButtons[1].Portrait:GetTexture() == "Interface\\Icons\\Achievement_Reputation_06"
	and standingButtons[4].Portrait:GetTexture() == "Interface\\Icons\\Achievement_Reputation_07"
	and standingButtons[1].Portrait:IsShown() and not standingButtons[1].DefaultArt:IsShown(), "a coloured handshake per standing")
check(standingButtons[1].Detail:GetText() == "1 reward" and standingButtons[2].Detail:GetText() == "10 rewards", "rewards per standing")
check(standingButtons[1].Reached:IsShown() and standingButtons[2].Reached:IsShown() and not standingButtons[3].Reached:IsShown(),
	"standings reached are ticked")
local standingBox = page.FactionStanding
check(standingBox:IsShown() and standingBox.Label:GetText() == "Your standing: Honored"
	and standingBox.Bar.Text:GetText() == "3,000 / 12,000", "the player's standing beneath: " .. tostring(standingBox.Bar.Text:GetText()))
check(standingBox.Bar._template == "ColoredProgressBarTemplate" and standingBox.Bar._fillPercent == 0.25
	and standingBox.Bar._fillColorType == 4, "in Forever's own reputation bar, a quarter full")
check(standingBox.Plate._texture and standingBox.Badge:GetTexture() == "Interface\\Icons\\Achievement_Reputation_05",
	"on a standing plate, with the Honored handshake")
local standingTop = select(5, standingBox:GetPoint(1))
check(standingTop == -(6 + 4 * 70 + 15), "placed one gap below the last standing: " .. tostring(standingTop))
rows = lootRows()
check(#rows == 22, "every reward listed, got " .. #rows)
check(rows[1].BossFrame:IsShown() and rows[1].Boss:GetText() == "Friendly" and rows[1].Boss._textColor[2] == 0.42,
	"each reward names its standing, green once reached")
check(rows[22].Boss:GetText() == "Exalted" and rows[22].Boss._textColor[2] == ns.PARCHMENT_TEXT_COLOR[2], "not yet reached: plain")
check(rows[22].ArmorType:GetText() == "2 Arcane Crystal" and rows[1].ArmorType:GetText():find("60", 1, true),
	"each reward says what its quartermaster asks: " .. tostring(rows[1].ArmorType:GetText()))
check(not page.ComingSoon:IsShown(), "no placeholder on a captured faction")
check(#f.NavBar._nav == 2 and f.NavBar._nav[2].name == "Argent Dawn", "breadcrumb names the faction")
check(#f.NavBar._nav[2].listFunc() == 23, "its arrow lists every faction")

-- Clicking a standing shows only its rewards; clicking it again shows them all
standingButtons[3]:Click()
check(page.boss and page.boss.name == "Revered" and #lootRows() == 10 and not lootRows()[1].BossFrame:IsShown(),
	"Revered's ten rewards alone")
check(#f.NavBar._nav == 3 and f.NavBar._nav[3].name == "Revered", "breadcrumb for the standing")
check(standingButtons[3]._highlightLocked, "the chosen standing stays lit")
standingButtons[3]:Click()
check(page.boss == nil and #lootRows() == 22 and #f.NavBar._nav == 2, "clicked again: all rewards")

-- The loot page's filters and pins work on rewards too
lootRows()[5]:Click("RightButton")
check(ns.charDB.pins[lootRows()[1].itemID] and loot.Dividers[1].Name:GetText() == "Pinned"
	and loot.Dividers[2].Name:GetText() == "Rewards", "a pinned reward leads, then the rest under Rewards")
lootRows()[1]:Click("RightButton")
loot.TypeFilter._menu.radios[1].setSelected()
check(loot.TypeFilter._menu.radios[1].text == "All Types", "type filter offered")

-- The Type menu sorts rewards by what they are: equipment by slot, recipes by profession, and
-- consumables, mounts, pets and toys on their own
do
	Mock.itemInstant[290401] = { "INVTYPE_NON_EQUIP_IGNORE", 9, 6, "Alchemy" }
	Mock.itemInstant[290402] = { "INVTYPE_NON_EQUIP_IGNORE", 9, 3, "Engineering" }
	Mock.itemInstant[290403] = { "INVTYPE_NON_EQUIP_IGNORE", 15, 5, "Mount" }
	Mock.itemInstant[290404] = { "INVTYPE_NON_EQUIP_IGNORE", 15, 4, "Other" }
	Mock.itemInstant[290405] = { "INVTYPE_NON_EQUIP_IGNORE", 0, 1, "Potion" }
	Mock.toys[290404] = true
	local wares = {}
	for itemID = 290401, 290405 do
		wares[#wares + 1] = { itemID = itemID, faction = "Azeroth Commerce Authority", reaction = 5, cost = "10 Merchant's Favor" }
	end
	ns.AddCapturedVendors({ { npcID = 990020, name = "Kind Tester", wares = wares } })
	ns.Journal:OpenInstance(ns.GetInstance("Faction2586"))
	loot.FilterBar.Clear:Click()
	local menu = loot.TypeFilter._menu
	local function Named(list, text)
		for _, item in ipairs(list) do if item.text == text then return item end end
	end
	local recipes = Named(menu.buttons, "Recipes")
	check(Named(menu.radios, "Consumables") and Named(menu.radios, "Mounts") and Named(menu.radios, "Toys")
		and Named(menu.buttons, "Equipment") and recipes and recipes.radios[1].text == "All Recipes"
		and recipes.radios[2].text == "Alchemy" and recipes.radios[3].text == "Engineering",
		"the menu offers the kinds the page has, recipes by profession")
	local function Shown()
		local ids = {}
		for _, row in ipairs(lootRows()) do ids[#ids + 1] = row.itemID end
		return ids
	end
	recipes.radios[2].setSelected()
	local shown = Shown()
	check(#shown == 1 and shown[1] == 290401 and lootRows()[1].Slot:GetText() == "Recipe, Alchemy"
		and loot.FilterBar.Text:GetText() == "Filter: Alchemy", "one profession's recipes, named as recipes")
	Named(loot.TypeFilter._menu.radios, "Mounts").setSelected()
	shown = Shown()
	check(#shown == 1 and shown[1] == 290403 and lootRows()[1].Slot:GetText() == "Mount", "mounts")
	Named(loot.TypeFilter._menu.radios, "Toys").setSelected()
	shown = Shown()
	check(#shown == 1 and shown[1] == 290404 and loot.FilterBar.Text:GetText() == "Filter: Toys", "toys, known to the toy box")
	loot.FilterBar.Clear:Click()
	ns.Journal:OpenInstance(ns.GetInstance("Faction529"))
end

-- Earning reputation updates the page
Mock.reputation[529].reaction, Mock.reputation[529].value = 7, 21500
Mock.Fire("UPDATE_FACTION")
check(standingBox.Label:GetText() == "Your standing: Revered" and standingButtons[3].Reached:IsShown(), "standing moves on")
check(lootRows()[12].Boss._textColor[2] == 0.42, "Revered rewards turn green")

-- A faction with nothing captured: its page lists what the game's data gives, and asks for its quartermaster
do
	ns.Journal:OpenInstance(ns.GetInstance("Faction21"))
	local soon = page.ComingSoon
	check(soon:IsShown() and soon.Title:GetText() == "Not captured yet" and soon.Text:GetText() == ns.L.REP_LISTED_TEXT
		and soon._points[1][3] == -(6 + 3 * 70 + 15 + 55 + 15) and #lootRows() == 6
		and not tostring(lootRows()[1].ArmorType:GetText() or ""):find("%d"),
		"Booty Bay: its six unconfirmed rewards, without prices, and how to confirm them, beneath the standing")
	-- One with nothing listed either
	local kirinTor = ns.GetInstance("Faction2740")
	local listed = kirinTor.bosses
	kirinTor.bosses = {}
	ns.Journal:OpenInstance(ns.GetInstance("Faction21"))
	ns.Journal:OpenInstance(kirinTor)
	check(soon:IsShown() and soon.Title:GetText() == "Coming soon" and soon.Text:GetText() == ns.L.REP_COMING_SOON_TEXT,
		"a Forever faction with nothing listed: coming soon")
	kirinTor.bosses = listed
	f.Tabs[3]:Click()
end

-- Capturing a quartermaster from the Reputation tab, recording or not
do
	check(not ns.Recorder:IsRecording(), "(not recording)")
	Mock.units.npc = { name = "Lorekeeper Lydros", guid = "Creature-0-1-2-3-14368-0000" }
	Mock.merchant = {
		{ itemID = 290101, name = "Libram of Rumination", price = 0, lines = { "Requires Booty Bay - Honored" },
			costs = { { 1, "Pristine Black Diamond" }, { 30, "Honor Points", true } } },
		{ itemID = 290102, name = "Plans: Bootybay Blade", price = 45000, lines = { "Requires Booty Bay - Revered" } },
		{ itemID = 159, name = "Refreshing Spring Water", price = 25, lines = {} },
	}
	Mock.Fire("MERCHANT_SHOW")
	check(reputation.Capture:IsEnabled() and reputation.CaptureStatus:GetText() == "Shop open: press Capture vendor.",
		"a shop open: Capture can be pressed")
	reputation.Capture:Click()
	local vendor = ns.Recorder:GetState().vendors[14368]
	check(vendor and vendor.items[159] and vendor.items[290101].cost == "1 Pristine Black Diamond + 30 Honor Points"
		and vendor.items[290102].price == 45000, "everything it sells is kept, with each ware's price and other costs")
	local booty = ns.GetInstance("Faction21")
	check(ns.FactionCaptured(booty) and #booty.bosses == 3 and booty.bosses[2].reaction == 6 and booty.bosses[3].reaction == 7
		and #booty.bosses[2].loot == 3, "the wares that need a standing join the faction at once, beside its listed ones")
	check(reputation.CaptureStatus:GetText() == "Lorekeeper Lydros: 2 wares for Booty Bay, 2 new."
		and ns.Reputation:RewardCount(booty) == 8, "and the tab says what was captured")
	reputation.Capture:Click()
	check(#booty.bosses[2].loot == 3 and reputation.CaptureStatus:GetText():find("0 new", 1, true), "capturing again adds nothing twice")
	Mock.Fire("MERCHANT_CLOSED")
	check(not reputation.Capture:IsEnabled(), "the shop closed: Capture waits again")
	check(ns.Recorder:Export():find("\nVENDOR;14368;Lorekeeper Lydros;", 1, true)
		and ns.Recorder:Export():find(";1 Pristine Black Diamond + 30 Honor Points", 1, true), "and the capture comes along with Copy")
	Mock.merchant, Mock.units.npc = {}, nil
end

-- Wares that say only "Requires Friendly with this faction." (the Azeroth Commerce Authority's
-- craftsmen): their faction is worked out from the wares that name theirs
do
	local commerce = ns.GetInstance("Faction2586")
	local function Shop(npcID, name, x, y, wares)
		Mock.playerX, Mock.playerY = x, y
		Mock.units.npc = { name = name, guid = "Creature-0-1-2-3-" .. npcID .. "-0000" }
		Mock.merchant = wares
		Mock.Fire("MERCHANT_SHOW")
		reputation.Capture:Click()
		local status = reputation.CaptureStatus:GetText()
		Mock.Fire("MERCHANT_CLOSED")
		return status
	end
	local function Costs(amount, currency) return { { amount, currency, true } } end
	-- The build's captures place every ware of both factions paid in Merchant's Favor: by a ware of
	-- the same vendor that names its faction, or by the vendors beside it
	-- (the Authority's count includes the Type menu's five made-up wares above)
	check(ns.FactionCaptured(commerce) and ns.Reputation:RewardCount(commerce) == 183 + 5
		and ns.Reputation:RewardCount(ns.GetInstance("Faction2587")) == 183,
		"the build's captures: the Authority's quartermasters and Durotar Supply and Logistics'")
	-- Merchant's Favor buys for both, so it says nothing: a lone vendor's wares (made-up ones here)
	-- wait for a ware that names their faction
	local status = Shop(990010, "Fizzy Testgear", 0.1045, 0.7435, {
		{ itemID = 290301, name = "Schematic: Test Waistwrap", price = 0,
			lines = { "Requires Engineering (175)", "Requires Friendly with this faction." }, costs = Costs(180, "Merchant's Favor") },
		{ itemID = 290302, name = "Schematic: Test Tabs", price = 0, lines = { "Requires Neutral with this faction." },
			costs = Costs(45, "Merchant's Favor") },
	})
	check(status == "Fizzy Testgear: 2 wares need a standing with a faction the game doesn't name; kept until a ware names it.",
		"a currency two factions are paid in names neither: " .. tostring(status))
	check(ns.Recorder:Export():find("\nVENDOR;990010;Fizzy Testgear;1455;0.1045;0.7435;290301;Schematic: Test Waistwrap;0;;5;180 Merchant's Favor", 1, true),
		"and are copied with the standing they need")
	-- A currency no named ware has shown yet: the wares wait for one that names their faction
	status = Shop(990001, "Captain Testshore", 0.70, 0.20, {
		{ itemID = 290201, name = "Testshore Cutlass", price = 0, lines = { "Requires Honored with this faction." },
			costs = Costs(20, "Pirate Doubloon") },
	})
	check(status == "Captain Testshore: 1 wares need a standing with a faction the game doesn't name; kept until a ware names it.",
		"wares whose faction cannot be told wait: " .. tostring(status))
	local booty = ns.GetInstance("Faction21")
	local before = booty.rewardCount or 0
	status = Shop(990002, "Purser Testshore", 0.72, 0.21, {
		{ itemID = 290202, name = "Testshore Tricorne", price = 0, lines = { "Requires Booty Bay - Friendly" },
			costs = Costs(10, "Pirate Doubloon") },
	})
	local cutlass
	for _, standing in ipairs(booty.bosses) do
		for _, row in ipairs(standing.loot) do if row.itemID == 290201 then cutlass = standing.reaction end end
	end
	check(status == "Purser Testshore: 1 wares for Booty Bay, 1 new." and cutlass == 6,
		"a ware naming its faction in the same currency brings the waiting one in")
	-- Paid in gold, naming no faction: the faction of the vendors standing beside its vendor
	status = Shop(990003, "Cook Testshore", 0.735, 0.205, {
		{ itemID = 290203, name = "Testshore Chowder", price = 500, lines = { "Requires Exalted with this faction." } },
	})
	check(status == "Cook Testshore: 1 wares for Booty Bay, 1 new.", "one paid in gold goes by its neighbours: " .. tostring(status))
	Mock.merchant, Mock.units.npc, Mock.playerX, Mock.playerY = {}, nil, nil, nil
end

-- Back to a dungeon: its side tabs and the tab the reader had
dungeons.Buttons[1]:Click()
check(tabs[1]:IsShown() and page.tab == dungeonTab and f.selectedTab == 1, "a dungeon gets its tabs back, on the tab it was on")
check(not page.FactionStanding:IsShown(), "no standing box on a dungeon")
f.Tabs[3]:Click()
check(buttonNamed(reputation, "Argent Dawn").Standing:GetText() == "Revered", "cards follow the standing")

-- /aegis perf measures, then leaves the journal as it was
local tabBefore = f.selectedTab
local chatBefore = #Mock.chat
SlashCmdList.AEGISJOURNAL("perf")
local perfLines = {}
for index = chatBefore + 1, #Mock.chat do perfLines[#perfLines + 1] = Mock.chat[index] end
local perfText = table.concat(perfLines, "\n")
check(Mock.memoryUpdated and perfText:find("Aegis_Forever_Instance_Journal: %d+ KB") and perfText:find("MapUtils: 4200 KB", 1, true),
	"memory for the journal and the other journal addons loaded")
check(not perfText:find("AlexAtlasLoot", 1, true), "addons not loaded are left out")
check(perfText:find("First open (building the window): ", 1, true) and perfText:find("Open a dungeon's page: ", 1, true)
	and perfText:find("Open a faction's page: ", 1, true) and perfText:find("Redraw a loot page: ", 1, true), "times for the heavy operations")
check(perfText:find("Switch to the Overview tab: ", 1, true) and perfText:find("Switch to the Loot tab: ", 1, true)
	and perfText:find("Switch to the Abilities tab: ", 1, true) and perfText:find("Switch to the Quests tab: ", 1, true),
	"and each side tab on its own")
check(f:IsShown() and f.selectedTab == tabBefore and not page:IsShown(), "and the journal is back the way it was")

------------------------------------------------------------------------------------------
-- Search
------------------------------------------------------------------------------------------

local box = f.SearchBox
local searchPreview, searchButtons, searchAll = ns.Search:Preview()
local function search(text)
	box:SetText(text)
	box:_RunScript("OnTextChanged", true)
end
local function previewNames()
	local names = {}
	for _, button in ipairs(searchButtons) do
		if button:IsShown() then names[#names + 1] = button.Name:GetText() end
	end
	return names
end

search("de")
check(not searchPreview:IsShown(), "two letters are not enough to search")
search("deadmines")
check(searchPreview:IsShown() and previewNames()[1] == "The Deadmines" and searchButtons[1].Icon:GetTexture() == 522352,
	"the dungeon first, with its picture: " .. table.concat(previewNames(), ", "))
check(searchButtons[1].Selected:IsShown(), "the first result is selected")
box:_RunScript("OnEnterPressed")
check(not searchPreview:IsShown() and page:IsShown() and page.instance.key == "TheDeadmines" and not page.boss,
	"Enter opens the dungeon")

search("edwin vancleef")
check(previewNames()[1] == "Edwin VanCleef", "an exact name comes first: " .. table.concat(previewNames(), ", "))
searchButtons[1]:Click()
check(page.boss and page.boss.name == "Edwin VanCleef", "a boss opens on its page")

search("rockslicer")
check(previewNames()[1] == "Rockslicer", "loot is found by name")
searchButtons[1]:Click()
check(page.boss.name == "Rhahk'Zor" and page.Loot:IsShown() and page.Loot.revealedItemID == 872,
	"an item opens its boss's loot, brought into view")

search("graveweave")
check(#ns.Search:Find("graveweave") == 1 and previewNames()[1] == "Graveweave Bindings"
	and searchButtons[1].Icon:GetTexture() ~= "Interface\\Icons\\INV_Misc_QuestionMark",
	"an item whose real one has come in is found once, as the real item")
search("kirin tor chain")
check(previewNames()[1] == "Kirin Tor Chain Vest" and searchButtons[1].Icon:GetTexture() == "Interface\\Icons\\INV_Misc_QuestionMark",
	"an item known only by name is found, with a question mark")
searchButtons[1]:_RunScript("OnEnter")
check(GameTooltip._text == "Kirin Tor Chain Vest"
	and GameTooltip:HasLine("Not identified yet: its source names it, but not its item ID. Loot it while recording to add it."),
	"its tooltip says it is not identified yet")
searchButtons[1]:_RunScript("OnLeave")
searchButtons[1]:Click()
check(page.boss.name == "Atrexis the Grave Knight" and page.Loot:IsShown() and page.Loot.revealedItemID == "?Kirin Tor Chain Vest",
	"and opens its boss's loot")

search("rhahk'zor slam")
searchButtons[1]:Click()
check(page.boss.name == "Rhahk'Zor" and page.Abilities:IsShown(), "an ability opens its boss's Abilities tab")

search("red silk bandanas")
check(previewNames()[1] == "Red Silk Bandanas", "quests are found")
searchButtons[1]:Click()
check(page.QuestList:IsShown() and page.selectedQuest and page.selectedQuest.questID == 214, "a quest opens chosen on the Quests tab")

search("test of righteousness")
check(not searchPreview:IsShown(), "a quest for another class is not offered: " .. table.concat(previewNames(), ", "))

search("timbermaw")
check(previewNames()[1] == "Timbermaw Hold", "factions are found")
searchButtons[1]:Click()
check(page.instance.key == "Faction576" and f.selectedTab == 3, "and open under Reputation")

-- More than five: the first five, then "Show All"
search("the")
local found = ns.Search:Find("the")
check(#found > 5 and #previewNames() == 5 and searchAll:IsShown()
	and searchAll.Text:GetText() == string.format("Show All %d Results", #found), "five shown, and a way to all " .. #found)
box:_RunScript("OnArrowPressed", "DOWN")
check(searchButtons[2].Selected:IsShown() and not searchButtons[1].Selected:IsShown(), "Down moves the selection")
box:_RunScript("OnArrowPressed", "UP")
box:_RunScript("OnArrowPressed", "UP")
check(searchAll.Selected:IsShown(), "Up from the first wraps round to Show All")
box:_RunScript("OnEnterPressed")
local resultsWindow = ns.Search:Window()
check(resultsWindow:IsShown() and not searchPreview:IsShown() and resultsWindow.Title:GetText():find('"the"', 1, true),
	"Show All opens the full list: " .. tostring(resultsWindow.Title:GetText()))
local function shownRows()
	local list = {}
	for _, row in ipairs(resultsWindow.Rows) do if row:IsShown() then list[#list + 1] = row end end
	return list
end
check(#shownRows() == 8 and shownRows()[1].entry == found[1] and shownRows()[1].Type:GetText() ~= nil,
	"only the rows in view are drawn")
check(resultsWindow.Scroll.Child._height == #found * 49, "the list is as long as the results")
resultsWindow.Scroll:SetVerticalScroll(49 * 3)
check(shownRows()[1].entry == found[4], "scrolling moves the rows down the list")
shownRows()[1]:Click()
check(not resultsWindow:IsShown(), "opening a result closes the list")

search("deadmines")
f:Hide()
check(not searchPreview:IsShown(), "closing the journal closes the search")
f:Show()
box:SetText("")

-- /aegis where: a position reading, printed and kept
Mock.subzone = "The Great Forge"
SlashCmdList.AEGISJOURNAL("where")
check(Mock.chat[#Mock.chat]:find('Map 1455 (Ironforge)  x 0.5456  y 0.3779  area "The Great Forge"', 1, true),
	"where prints the map, position and area: " .. Mock.chat[#Mock.chat])
check(ns.db.where[#ns.db.where].mapID == 1455 and ns.db.where[#ns.db.where].area == "The Great Forge", "and keeps the reading")
Mock.subzone = ""

-- Escape, toggle, slash command, position
local escapable = false
for _, name in ipairs(UISpecialFrames) do if name == "AegisJournalFrame" then escapable = true end end
check(escapable, "Escape closes the journal")
f:_RunScript("OnDragStop")
check(ns.db.position and ns.db.position.point == "TOPLEFT", "position saved after a drag")
SlashCmdList.AEGISJOURNAL("reset")
check(ns.db.position == nil, "/aegis reset clears the saved position")
AegisJournal_Toggle()
check(not f:IsShown(), "toggle closes it")

-- A second login must not take Shift+J back after the player changed it
Mock.bindings["SHIFT-J"] = "SOMETHING_ELSE"
Mock.Fire("PLAYER_LOGIN")
check(Mock.bindings["SHIFT-J"] == "SOMETHING_ELSE", "player's own binding is left alone")

------------------------------------------------------------------------------------------
-- Record tab
------------------------------------------------------------------------------------------

AegisJournal_Toggle()
local record = f.Panels[5]
f.Tabs[5]:Click()
check(record:IsShown(), "Record tab shows its panel")
check(not ns.Recorder:IsRecording() and record.Toggle:GetText() == "Start Recording", "starts stopped")
local function listening(event)
	for _, frame in ipairs(Mock.frames) do if frame._events[event] then return true end end
	return false
end
check(not listening("LOOT_OPENED") and not listening("QUEST_DETAIL"), "stopped, the recorder does not listen to the game")
record.Toggle:Click()
check(ns.Recorder:IsRecording(), "recording after Start")
check(listening("LOOT_OPENED") and listening("QUEST_DETAIL") and listening("PLAYER_LEAVING_WORLD"), "recording, it listens")
check(record.RecordingLight:IsShown(), "red light on the tab while recording")
check(record.Toggle:GetText() == "Stop Recording", "button flips to Stop")
check(chatContains("Recording started"), "player told recording started")

-- Into Hall of Thanes, through its door in Ironforge
local state = ns.Recorder:GetState()
Mock.Fire("PLAYER_LEAVING_WORLD")
Mock.instance = { name = "The Hall of Thanes", id = 3065 }
Mock.subzone = ""
Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
local door = state.entrances[3065]
check(door and door.mapID == 1455 and door.x == 0.5456 and door.y == 0.3779, "where the player stood before the loading screen is the entrance")
check(ns.DungeonMap:Entrance(ns.GetInstance("HallOfThanes")) == door, "and the map's entrance pin uses it")
check(state.visits[3065] and state.visits[3065].count == 1, "dungeon visit counted")
check(Mock.combatLogging and state.combatLogOwned, "combat log turned on inside the dungeon")
check(#state.combatLogs == 1 and state.combatLogs[1].file:find("^WoWCombatLog%-%d%d%d%d%d%d_%d%d%d%d%d%d%.txt$")
	and state.combatLogs[1].instanceID == 3065, "the log's file noted by the name the game gives it")
Mock.subzone = "Anvilmar's Rest"
Mock.Fire("ZONE_CHANGED")
Mock.Fire("ZONE_CHANGED")
check(state.areas[3065] and #state.areas[3065] == 1 and state.areas[3065][1] == "Anvilmar's Rest", "area recorded once")

-- A boss kill
Mock.time = 2000
Mock.Fire("ENCOUNTER_START", 3493, "Faldrim Anvilmar", 1, 5)
Mock.time = 2040
Mock.Fire("ENCOUNTER_END", 3493, "Faldrim Anvilmar", 1, 5, 1)
local faldrim = state.encounters[3493]
check(faldrim and faldrim.kills == 1 and faldrim.lastKillSeconds == 40, "kill and fight length recorded")
check(faldrim.area == "Anvilmar's Rest" and faldrim.instanceID == 3065, "where the boss was pulled")

-- Boss loot: source unreadable, so credited to the kill a moment ago; reopening adds nothing
Mock.time = 2060
Mock.lootSlots = {
	{ link = "|cff0070dd|Hitem:270227::::::::|h[Ephemeral Choker]|h|r", name = "Ephemeral Choker", quality = 3 },
	{ link = "|cff0070dd|Hitem:271096::::::::|h[Aetherwisp Bracers]|h|r", name = "Aetherwisp Bracers", quality = 3 },
}
Mock.Fire("LOOT_OPENED")
Mock.Fire("LOOT_OPENED")
local faldrimLoot = state.loot[3065] and state.loot[3065]["Faldrim Anvilmar"]
local lootCount = 0
for _ in pairs(faldrimLoot or {}) do lootCount = lootCount + 1 end
check(lootCount == 2 and faldrimLoot[270227].name == "Ephemeral Choker", "boss loot credited once")

-- Trash loot long after the kill, with a readable creature id
Mock.time = 3000
ns.Items:AddUnconfirmed({ [286981] = "Trash Drops, Ruins of Lordaeron" })
check(ns.Items:IsHidden(286981), "an item a scan found the server knows nothing of is hidden")
Mock.lootSlots = { { link = "|Hitem:286981::|h", name = "Death Bindings", quality = 3, guid = "Creature-0-1-2-3-261400-0000" } }
Mock.Fire("LOOT_OPENED")
check(state.loot[3065]["trash:261400"] and state.loot[3065]["trash:261400"][286981], "trash loot keeps the creature id")
check(not ns.Items:IsHidden(286981), "until a recorded run sees it drop")

-- Trash looted right after a kill stays trash when the client names the creature, noted beside the kill
Mock.time = 4000
Mock.Fire("ENCOUNTER_START", 3494, "Plunder", 1, 5)
Mock.time = 4030
Mock.Fire("ENCOUNTER_END", 3494, "Plunder", 1, 5, 1)
Mock.time = 4090
Mock.lootSlots = { { link = "|Hitem:211785::|h", name = "Scroll: CWAL", quality = 1, guid = "Creature-0-1-2-3-263396-0000" } }
Mock.Fire("LOOT_OPENED")
check(not (state.loot[3065]["Plunder"] and state.loot[3065]["Plunder"][211785])
	and state.loot[3065]["trash:263396"][211785].nearKill == "Plunder", "trash after a kill is not the boss's loot")
-- The boss's own corpse, named by the client, is the boss's even long after
Mock.time = 4500
Mock.lootSlots = { { link = "|Hitem:270228::|h", name = "Golemheart Stave", quality = 3, guid = "Creature-0-1-2-3-261311-0000" } }
Mock.Fire("LOOT_OPENED")
check(state.loot[3065]["Plunder"][270228], "a boss's corpse is credited to the boss")

-- Loot that never passed through the player's window: the group's, from the loot chat
Mock.Fire("LOOT_READY")
check(state.loot[3065]["Plunder"][270228] and not state.loot[3065]["group"], "the loot window read early adds nothing twice")
Mock.Fire("CHAT_MSG_LOOT", "Bob receives loot: |cff1eff00|Hitem:999001::::::::|h[Mysterious Ring]|h|r.")
Mock.Fire("CHAT_MSG_LOOT", "Bob receives loot: |cff0070dd|Hitem:270228::::::::|h[Golemheart Stave]|h|r.")
Mock.Fire("CHAT_MSG_LOOT", "You receive item: |cffffffff|Hitem:999002::::::::|h[Quest Reward]|h|r.")
local group = state.loot[3065]["group"]
check(group and group[999001] and group[999001].name == "Mysterious Ring" and not group[270228] and not group[999002],
	"a group member's loot is recorded once, nothing already caught twice, and a quest reward pushed into the bags not at all")
-- The loot history files a group roll under its boss
Mock.lootEncounters[3496] = { encounterName = "Durgen Dirgehammer" }
Mock.lootHistory["3496:1"] = { itemHyperlink = "|cff0070dd|Hitem:999003::::::::|h[Dirgehammer's Mantle]|h|r" }
Mock.Fire("LOOT_HISTORY_UPDATE_DROP", 3496, 1)
Mock.Fire("LOOT_HISTORY_UPDATE_DROP", 3496, 1)
check(state.loot[3065]["Durgen Dirgehammer"] and state.loot[3065]["Durgen Dirgehammer"][999003].name == "Dirgehammer's Mantle",
	"a roll in the loot history is credited to its boss")
Mock.lootEncounters[9] = { encounterName = "Miscellaneous" }
Mock.lootHistory["9:1"] = { itemHyperlink = "|Hitem:999001::|h[Mysterious Ring]|h" }
Mock.Fire("LOOT_HISTORY_UPDATE_DROP", 9, 1)
check(not state.loot[3065]["Miscellaneous"], "the history's bucket of everything else is not taken for a boss")

-- Leaving turns off the log it started
Mock.instance, Mock.subzone = nil, "The Great Forge"
Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
check(not Mock.combatLogging and not state.combatLogOwned, "combat log turned off on leaving")

-- A log the player started is never claimed or turned off
Mock.combatLogging = true
Mock.instance = { name = "The Hall of Thanes", id = 3065 }
Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
check(not state.combatLogOwned, "player's own log not claimed")
Mock.instance = nil
Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
check(Mock.combatLogging, "player's own log left on")
Mock.combatLogging = false

-- The client already says "inside" as the loading screen begins, while still reporting the
-- street outside: the map decides, and the entrance is the portal's spot
Mock.instance, Mock.mapAsLeaving, Mock.playerX, Mock.playerY = { name = "The Hall of Thanes", id = 3065 }, 1455, 0.2815, 0.4775
Mock.Fire("LOADING_SCREEN_ENABLED")
Mock.Fire("PLAYER_LEAVING_WORLD")
Mock.mapAsLeaving = nil
Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
check(state.entrances[3065].x == 0.2815 and state.entrances[3065].y == 0.4775, "the portal's spot recorded though the client said inside")
Mock.instance = nil
Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
-- No position at all: the log says why
Mock.instance = { name = "The Hall of Thanes", id = 3065 }
Mock.Fire("PLAYER_LEAVING_WORLD")
Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
local saysWhy = false
for index = math.max(1, #state.log - 5), #state.log do
	if state.log[index]:find("Entrance of The Hall of Thanes not recorded: the game gave no map as the loading screen began.", 1, true) then
		saysWhy = true
	end
end
check(saysWhy, "a missed entrance says why")
check(state.entrances[3065].x == 0.2815, "and the one recorded before stays")
Mock.instance, Mock.playerX, Mock.playerY = nil, nil, nil
Mock.Fire("PLAYER_ENTERING_WORLD", false, false)

-- A quest from offer to hand-in
Mock.units.npc = { name = "Thom Filch", guid = "Creature-0-1-2-3-261500-0000" }
Mock.quest = { id = 96403, title = "Important Heirlooms", text = "Thieves took them.", objective = "Collect 8 Dwarven Heirlooms.",
	xp = 1350, money = 700, choices = { 279898, 280096 } }
Mock.Fire("QUEST_DETAIL", 0)
local quest = state.quests[96403]
check(quest and quest.title == "Important Heirlooms" and quest.objective == "Collect 8 Dwarven Heirlooms.", "quest offer recorded")
check(quest.pickup.npc.name == "Thom Filch" and quest.pickup.npc.npcID == 261500, "quest giver recorded")
check(quest.pickup.place.mapID == 1455 and quest.pickup.place.x == 0.5456, "pickup place recorded")
check(quest.pickup.startItemID == nil, "no start item for an NPC quest")
check(quest.offered.choices[2] == 280096 and quest.offered.xp == 1350 and quest.offered.money == 700, "offered rewards recorded")
Mock.Fire("QUEST_ACCEPTED", 96403)
check(quest.accepted, "acceptance recorded")
Mock.quest.rewardText = "You found them!"
Mock.Fire("QUEST_COMPLETE")
check(quest.turnin and quest.completionText == "You found them!" and quest.rewards.choices[1] == 279898, "turn-in recorded")
Mock.time = 4000
Mock.Fire("QUEST_TURNED_IN", 96403, 1350, 700)
Mock.Fire("CHAT_MSG_COMBAT_FACTION_CHANGE", "Reputation with Gadgetzan increased by 100.")
check(quest.turnedIn.xp == 1350 and quest.turnedIn.money == 700, "actual xp and money recorded")
check(quest.reputation and quest.reputation.Gadgetzan == 100, "reputation credited to the quest")
Mock.time = 4010
Mock.Fire("CHAT_MSG_COMBAT_FACTION_CHANGE", "Reputation with Ironforge increased by 25.")
check(quest.reputation.Ironforge == nil, "a later reputation gain is not credited")

-- A reputation quartermaster: the wares that need a standing, and where the vendor stands
do
	local thorium
	for _, faction in ipairs(ns.GetFactions()) do if faction.name == "Thorium Brotherhood" then thorium = faction end end
	local function standingWith(reaction)
		for _, standing in ipairs(thorium.bosses) do if standing.reaction == reaction then return standing end end
	end

	Mock.units.npc = { name = "Lokhtos Darkbargainer", guid = "Creature-0-1-2-3-12944-0000" }
	Mock.merchant = {
		{ itemID = 17051, name = "Plans: Dark Iron Bracers", price = 40000, lines = { "Requires Thorium Brotherhood - Friendly" } },
		{ itemID = 290001, name = "Plans: A Forever Hammer", price = 120000, lines = { "Requires Thorium Brotherhood - Exalted" } },
		{ itemID = 2901, name = "Mining Pick", price = 81, lines = {} },
	}
	Mock.Fire("MERCHANT_SHOW")
	local vendor = state.vendors[12944]
	local wares = 0
	for _ in pairs(vendor and vendor.items or {}) do wares = wares + 1 end
	check(vendor and vendor.name == "Lokhtos Darkbargainer" and wares == 2 and vendor.items[290001].reaction == 8
		and vendor.items[290001].price == 120000 and vendor.place.mapID, "the wares that need a standing, with their price, and the vendor's place")
	local exalted = standingWith(8).loot
	check((function()
		local friendly = standingWith(5).loot
		local count = #friendly
		Mock.Fire("MERCHANT_SHOW")
		for _, row in ipairs(friendly) do
			if row.itemID == 17051 then
				return exalted[#exalted].itemID == 290001 and #friendly == count and not row.listed and row.price == 40000
			end
		end
	end)(), "the wares join the faction's rewards at their standings, a listed one confirmed, and seeing them again adds nothing twice")
	Mock.units.npc = { name = "Tharynn Bouden", guid = "Creature-0-1-2-3-66-0000" }
	Mock.merchant = { { itemID = 2901, name = "Mining Pick", price = 81, lines = {} } }
	Mock.Fire("MERCHANT_SHOW")
	check(state.vendors[66] == nil, "a vendor with nothing for reputation is not kept")
	Mock.merchant, Mock.units.npc = {}, nil
end

-- The page: what was caught, by dungeon, the drops the journal lacks listed and the rest counted
do
local function listText()
	local parts = {}
	for _, row in ipairs(record.List.Rows) do
		if row:IsShown() then parts[#parts + 1] = row:GetText() end
	end
	return table.concat(parts, "\n")
end
do
	local catch = ns.Recorder:Catch()
	local thanes = catch.places[1]
	local trash = {}
	for _, item in ipairs(thanes.trash) do trash[item.itemID] = true end
	check(thanes.name == "The Hall of Thanes" and thanes.entrance and thanes.listed == 3 and thanes.new == 4
		and trash[286981] and trash[211785] and #thanes.group == 1 and thanes.group[1].itemID == 999001
		and #thanes.bosses == 1 and thanes.bosses[1].name == "Durgen Dirgehammer",
		"the drops the journal lists are counted; the ones it lacks are listed off their boss, off trash and looted by the group")
	check(#thanes.kills == 2 and catch.quests[1].title == "Important Heirlooms" and catch.quests[1].done
		and catch.vendors[1].name == "Lokhtos Darkbargainer" and catch.vendors[1].wares == 2 and catch.vendors[1].new == 2,
		"kills, the quest handed in, and the quartermaster's one ware the faction lacked")
	check(not record.Title:IsShown() and record.Book:IsShown(), "the page is the journal's book, with its own titles")
end
record:Hide()
record:Show()
local caught = listText()
check(caught:find("The Hall of Thanes", 1, true) and caught:find("Killed: Faldrim Anvilmar, Plunder", 1, true)
	and caught:find("Death Bindings", 1, true) and caught:find("Important Heirlooms", 1, true)
	and caught:find("Looted by your group", 1, true) and caught:find("Off Durgen Dirgehammer", 1, true)
	and caught:find("Lokhtos Darkbargainer: 2 wares", 1, true), "the list shows the catch: " .. caught:sub(1, 300))
check(caught:find("Quest handed in: Important Heirlooms", 1, true), "and the latest entries")
check(record.Counts:GetText():find(" caught, ", 1, true) and record.Status:GetText():find("Recording since", 1, true),
	"the status and the tally")
record.CombatLog:Click()
record.Toggle:Click()
check(not ns.Recorder:IsRecording() and not record.RecordingLight:IsShown(), "stopped, light off")
check(not listening("LOOT_OPENED") and listening("PLAYER_ENTERING_WORLD"), "and stops listening, all but the way in")
check(record.Clear:IsEnabled(), "Clear can be pressed while something is caught")
record.Clear:Click()
check(Mock.popup == "AEGISJOURNAL_CLEAR_RECORDING", "Clear asks first")
StaticPopupDialogs.AEGISJOURNAL_CLEAR_RECORDING.OnAccept()
check(next(state.quests) == nil and next(state.loot) == nil, "Clear empties the recordings")
check(not record.Clear:IsEnabled() and listText():find("Nothing caught yet", 1, true), "and there is nothing left to clear")
end
Mock.Fire("QUEST_ACCEPTED", 1)
check(state.quests[1] == nil, "nothing recorded while stopped")
SlashCmdList.AEGISJOURNAL("record")
check(ns.Recorder:IsRecording(), "/aegis record starts recording")

-- Copy: the recording as text for our Discord, under the name the player wants credited
do
	check(record.Link:GetText() == "https://discord.gg/Hr66t25vE7" and record.Names:GetText():find("Subtilizer", 1, true)
		and record.Names:GetText():find("Genesys Firstborn", 1, true) and record.Names:GetText():find("^Staree4ok\n"),
		"the Discord link and the contributors, the translator first")
	Mock.Fire("QUEST_ACCEPTED", 96403)
	state.quests[96403].title = "Important Heirlooms"
	record.Credit:SetText("Testy McTester")
	record.Credit:_RunScript("OnTextChanged", true)
	check(ns.db.creditName == "Testy McTester", "the credit name is kept")
	record:Hide()
	record:Show()
	check(record.Counts:GetText():find("1 new since your last copy", 1, true), "the tally counts what is new: " .. record.Counts:GetText())
	record.Copy:Click()
	local text = record.CopyBox:GetText() or ""
	check(record.CopyScroll:IsShown() and not record.List:IsShown() and record.Copy:GetText() == "Back"
		and record.ListTitle:GetText() == "Your recording, as text", "Copy turns the right page into the recording as text")
	check(text:find("^AEGIS RECORDING;1;") and text:find(";Testy McTester\n", 1, true)
		and text:find("\nQUEST;96403;Important Heirlooms;", 1, true), "the text, credited: " .. text:sub(1, 120))
	check(record.CopyHint:GetText():find("paste it in our Discord", 1, true) and not record.LogLink:IsShown()
		and not text:find("COMBATLOG;", 1, true), "no combat log written: straight to Discord")
	record.CopyBox:SetText("typed over")
	record.CopyBox:_RunScript("OnTextChanged", true)
	check(record.CopyBox:GetText() == text, "typing in it puts the recording back")
	record.CopyBox:_RunScript("OnEscapePressed")
	check(record.List:IsShown() and not record.CopyScroll:IsShown() and record.Copy:GetText() == "Copy", "Escape turns it back to the list")
	check(record.Counts:GetText():find("0 new since your last copy", 1, true), "after a copy, nothing is new")
	ns.db.creditName = nil
	Mock.units.player = { name = "Brandy" }
	record.Copy:Click()
	check(record.CopyBox:GetText():find(";Brandy\n", 1, true), "with no name given, the character's own")
	record.Copy:Click()
	check(record.List:IsShown(), "Back turns it back too")
	Mock.units.player = nil
end

-- Recording by itself in dungeons: on the way in, and off again on the way out
do
	ns.Recorder:Stop()
	ns.Recorder:SetAutoRecord(true)
	record:Hide()
	record:Show()
	check(record.AutoRecord:GetChecked(), "the box shows it is on")
	Mock.playerX, Mock.playerY = 0.2815, 0.4775
	Mock.Fire("PLAYER_LEAVING_WORLD")
	Mock.instance = { name = "The Hall of Thanes", id = 3065 }
	Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
	check(ns.Recorder:IsRecording() and state.autoStarted and state.entrances[3065].x == 0.2815,
		"entering a dungeon starts recording, the way in noted")
	Mock.instance = nil
	Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
	check(not ns.Recorder:IsRecording(), "and leaving stops it again")
	-- That run wrote a combat log: Copy names it and points to the Log Reader
	local written = state.combatLogs[#state.combatLogs]
	record.Copy:Click()
	check(written and record.CopyHint:GetText():find(written.file, 1, true) and record.LogLink:IsShown()
		and record.LogLink:GetText() == "https://torchlite-bit.github.io/Aegis_Forever_Instance_Journal/log-reader/",
		"a run that wrote a combat log: the hint names its file and links the Log Reader")
	check(record.CopyBox:GetText():find("\nCOMBATLOG;" .. written.file .. ";3065", 1, true), "and the text says which log it wrote")
	record.Copy:Click()
	ns.Recorder:Start()
	Mock.instance = { name = "The Hall of Thanes", id = 3065 }
	Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
	Mock.instance = nil
	Mock.Fire("PLAYER_ENTERING_WORLD", false, false)
	check(ns.Recorder:IsRecording(), "a recording the player started is not stopped on the way out")
	Mock.playerX, Mock.playerY = nil, nil
	ns.Recorder:SetAutoRecord(false)
end

------------------------------------------------------------------------------------------
-- /aegis items, last: the mock's server knows next to no items, so a scan hides most of them
------------------------------------------------------------------------------------------

do
	Mock.itemsCached[19508] = true -- Fairbanks's bracers: the server knows them; his shawl and boots it does not
	SlashCmdList.AEGISJOURNAL("items")
	local scan = ns.db.missingItems
	check(chatContains("Asking the server about the ") and scan and scan.checked > 400 and scan.at,
		"every item the journal lists is asked about, got " .. tostring(scan and scan.checked))
	check(scan.items[19507] == "High Inquisitor Fairbanks, Scarlet Monastery: Cathedral" and scan.items[19508] == nil,
		"one the server never described is listed with its boss and dungeon; one it knows is not")
	check(chatContains("Item 19507: High Inquisitor Fairbanks, Scarlet Monastery: Cathedral") or chatContains("...and "),
		"and the chat names the first of them")

	-- Hidden until confirmed: the items, and a creature listed only for them
	local cathedral = ns.GetInstance("ScarletMonasteryCathedral")
	local fairbanks, whitemane
	for _, boss in ipairs(cathedral.bosses) do
		if boss.name == "High Inquisitor Fairbanks" then fairbanks = boss end
		if boss.name == "High Inquisitor Whitemane" then whitemane = boss end
	end
	ns.Journal:Show()
	ns.Journal:OpenBoss(cathedral, fairbanks)
	ns.EncounterPage:SetTab(page, Page.TAB_LOOT)
	local rows = lootRows()
	check(#rows == 1 and rows[1].itemID == 19508, "Fairbanks's page shows only the bracers the server knows, got " .. #rows)
	ns.Journal:OpenInstance(cathedral)
	local cathedralBosses = table.concat(visibleBosses(), ", ")
	check(ns.Items:IsHidden(7723) and cathedralBosses:find("Mograine", 1, true) and cathedralBosses:find("Whitemane", 1, true),
		"a boss written up by hand stays even while all its drops are hidden: " .. cathedralBosses)
	-- No boss is known by its loot alone today; Whitemane without her notes and abilities stands in for one
	local notes, spells, written = whitemane.notes, whitemane.abilities, whitemane.extraAbilities
	whitemane.notes, whitemane.abilities, whitemane.extraAbilities = nil, nil, nil
	ns.Journal:OpenInstance(ns.GetInstance("ShadowfangKeep")) -- the book redraws a dungeon's bosses when it is opened anew
	ns.Journal:OpenInstance(cathedral)
	cathedralBosses = table.concat(visibleBosses(), ", ")
	check(not cathedralBosses:find("Whitemane", 1, true) and cathedralBosses:find("Mograine", 1, true),
		"a creature listed only for loot the server does not know is hidden with it; the others stay: " .. cathedralBosses)
	whitemane.notes, whitemane.abilities, whitemane.extraAbilities = notes, spells, written
	Mock.itemsCached[19507] = true
	ns.Journal:OpenBoss(cathedral, fairbanks)
	ns.EncounterPage:SetTab(page, Page.TAB_LOOT)
	check(#lootRows() == 2, "an item the server describes later shows again")
	-- The player's own scan is kept, and hides its items again at the next login
	check(ns.db.missingItems.items[19509], "the scan stays in the saved file")
	check(ns.Recorder:Export():find("\nMISSING;19509;", 1, true), "and comes along when the tester copies their recording")
end

-- The world map's zones: a level range after a zone's name, and its unexplored areas on request
-- (in a function of its own: the scenario's main chunk is at Lua's limit of locals)
;(function()
	local label, zoneMap = WorldMapFrame.areaLabel, ns.ZoneMap
	Mock.level = 20
	Mock.cursorZone = { mapID = 1429, name = "Elwynn Forest" }
	label:_RunScript("OnUpdate")
	check(Mock.zoneLabel and Mock.zoneLabel:find("^Elwynn Forest|cff%x%x%x%x%x%x %(1%-10%)|r$"),
		"a zone's level range after its name: " .. tostring(Mock.zoneLabel))
	check(zoneMap:LevelText(15, 25) == "|cffffd100 (15-25)|r", "yellow while the player is within it")
	Mock.clientZoneLevels[1429] = { 1, 12 }
	label:_RunScript("OnUpdate")
	check(Mock.zoneLabel == "Elwynn Forest (1-12)", "the client's own range, where it knows one, and not ours too: " .. tostring(Mock.zoneLabel))
	Mock.clientZoneLevels[1429] = nil
	Mock.cursorZone = { mapID = 9999, name = "Mount Hyjal" }
	label:_RunScript("OnUpdate")
	check(Mock.zoneLabel and Mock.zoneLabel:find("^Mount Hyjal|cff%x%x%x%x%x%x %(60%)|r$"),
		"a Forever zone known only by its name, with a one-level range: " .. tostring(Mock.zoneLabel))
	Mock.cursorZone = { mapID = 1453, name = "Stormwind City" }
	label:_RunScript("OnUpdate")
	check(Mock.zoneLabel == "Stormwind City", "a city keeps its plain name")
	Mock.cursorZone = nil

	local choice = Mock.TaggedMenu("MENU_WORLD_MAP_TRACKING").checkboxes[1]
	check(choice and choice.text == "Show unexplored areas" and not choice.isSelected(),
		"the map's filter menu offers the unexplored areas, off at first")
	local pieces = ns.MAP_OVERLAYS[1436]
	Mock.explored[1436] = { pieces[1][5] }
	WorldMapFrame:Show()
	WorldMapFrame:SetMapID(1436)
	check(#WorldMapFrame:ActivePins("AegisJournalFogPinTemplate") == 0, "nothing drawn while it is off")
	choice.setSelected()
	local pins = WorldMapFrame:ActivePins("AegisJournalFogPinTemplate")
	local expected = 0
	for index = 2, #pieces do expected = expected + #pieces[index] - 4 end
	check(#pins == 1 and choice.isSelected() and pins[1].shownTextures == expected,
		"Westfall's unexplored pieces drawn, the explored one left to the client: " .. tostring(pins[1] and pins[1].shownTextures))
	local texture, piece = pins[1].textures[1], pieces[2]
	local _, _, _, x, y = texture:GetPoint(1)
	check(texture._texture == piece[5] and x == piece[3] and y == -piece[4] and texture:GetWidth() == math.min(piece[1], 256),
		"each where the client would draw it")
	choice.setSelected()
	check(#WorldMapFrame:ActivePins("AegisJournalFogPinTemplate") == 0 and ns.db.showUnexplored == nil, "and gone again when unticked")
	Mock.explored[1436] = nil
	WorldMapFrame:Hide()
end)()

-- The Gear Finder: the best upgrade per slot from the dungeons near the player's level, a level-15
-- warrior here, in Ragefire Chasm's drops (only the items described below are known to the client).
-- Its timers wait on the mock's clock here, as the client's do (Mock.RunTimers).
;(function()
	local IS, GF = ns.ItemScore, ns.GearFinder
	local level, class, clock = Mock.level, Mock.playerClass, Mock.time
	Mock.level, Mock.playerClass = 15, "WARRIOR"
	Mock.deferTimers = true
	local requests, request = 0, C_Item.RequestLoadItemDataByID
	C_Item.RequestLoadItemDataByID = function(itemID)
		requests = requests + 1
		request(itemID)
	end
	local CAPE, CUFFS, FELBLADE, CROSSBOW, ROBE, SCEPTER, WORN_CAPE = 14149, 14148, 14145, 272999, 14150, 272996, 990301
	Mock.itemInstant[CAPE] = { "INVTYPE_CLOAK", 4, 1, "Cloth" }
	Mock.itemInstant[WORN_CAPE] = { "INVTYPE_CLOAK", 4, 1, "Cloth" }
	Mock.itemInstant[CUFFS] = { "INVTYPE_WRIST", 4, 1, "Cloth" }
	Mock.itemInstant[FELBLADE] = { "INVTYPE_WEAPON", 2, 7, "One-Handed Swords" }
	Mock.itemInstant[CROSSBOW] = { "INVTYPE_RANGED", 2, 18, "Crossbows" }
	Mock.itemInstant[ROBE] = { "INVTYPE_ROBE", 4, 1, "Cloth" }
	Mock.itemInstant[SCEPTER] = { "INVTYPE_WEAPON", 2, 4, "One-Handed Maces" }
	Mock.itemNames[CAPE], Mock.itemNames[FELBLADE], Mock.itemNames[CROSSBOW] = "Subterranean Cape", "Cursed Felblade", "Barbaric Crossbow"
	Mock.itemStats[CAPE] = { ITEM_MOD_AGILITY_SHORT = 3, ITEM_MOD_STAMINA_SHORT = 2, RESISTANCE0_NAME = 15, ITEM_MOD_NEW_THING = 4 }
	Mock.itemStats[WORN_CAPE] = { ITEM_MOD_STAMINA_SHORT = 1, RESISTANCE0_NAME = 10 }
	Mock.itemStats[CUFFS] = { RESISTANCE2_NAME = 5 }
	Mock.itemStats[FELBLADE] = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 8.5, ITEM_MOD_STRENGTH_SHORT = 3 }
	Mock.itemLines[FELBLADE] = { "One-Hand", "+3 Strength", "Equip: Improves your chance to get a critical strike by 1%.",
		"Use: Increases attack power by 200 for 20 sec.", "(1) Set: Improves your chance to hit by 2%." }
	Mock.itemStats[CROSSBOW] = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 5 }
	Mock.itemLines[CROSSBOW] = { { "Requires Level 17", red = true } }
	Mock.itemMinLevels[CROSSBOW], Mock.itemMinLevels[SCEPTER] = 17, 25
	Mock.itemStats[ROBE] = { ITEM_MOD_STAMINA_SHORT = 20 }
	Mock.itemLines[ROBE] = { { "Classes: Priest", red = true } }
	Mock.itemStats[SCEPTER] = { ITEM_MOD_STRENGTH_SHORT = 30 }
	for _, itemID in ipairs({ CAPE, WORN_CAPE, CUFFS, FELBLADE, CROSSBOW, ROBE, SCEPTER }) do Mock.itemsCached[itemID] = true end
	Mock.worn = { [15] = WORN_CAPE }
	IS:Forget()

	-- Reading an item: the client's stats, the Equip: lines it leaves out, never a Use: or set line
	local blade = IS:Read(Mock.ItemLink(FELBLADE))
	check(blade.stats.DPS == 8.5 and blade.stats.STRENGTH == 3 and blade.stats.CRIT == 1 and not blade.stats.HIT
		and not blade.stats["ATTACK POWER"], "the client's stats, plus the crit of an Equip: line; not a Use: or set line")
	check(IS:Read(Mock.ItemLink(CROSSBOW)).stats["RANGED DPS"] == 5, "a ranged weapon's damage counts as ranged")
	check(IS:Read(Mock.ItemLink(CROSSBOW)).usable, "the red level line of an item for later is no reason to leave it out")
	check(IS:Read(Mock.ItemLink(ROBE)).usable == false, "a red line (another class's) makes it unusable")
	check(IS.unknownKeys.ITEM_MOD_NEW_THING or not IS:Read(Mock.ItemLink(CAPE)).stats.ITEM_MOD_NEW_THING,
		"a stat name the journal doesn't know is noted for /aegis gearscan")
	check(IS.unknownKeys.ITEM_MOD_NEW_THING, "and the scan can name it")
	local spec, why = IS:Spec()
	check(spec == "Arms" and why == "levelling" and IS:Weights().STRENGTH == 2.16,
		"a warrior with no talents read is scored as Arms, with the levelling weights")

	-- The classic Equip: wordings
	local WORDS, SPELLS, LATER, LATE = 990780, 990781, 990782, 990783
	for _, itemID in ipairs({ WORDS, SPELLS, LATER, LATE }) do
		Mock.itemInstant[itemID] = { "INVTYPE_NECK", 4, 0, "Miscellaneous" }
		Mock.itemsCached[itemID] = true
	end
	Mock.itemLines[WORDS] = { "Equip: +24 ranged Attack Power.", "Equip: +140 Attack Power in Cat, Bear, and Dire Bear forms only.",
		"Equip: +81 Attack Power when fighting Undead.", "Equip: Increases damage done by magical spells and effects by up to 12.",
		"Equip: Increases damage done by Shadow spells and effects by up to 7.",
		"Equip: Allows 15% of your Mana regeneration to continue while casting.",
		"Equip: Decreases the magical resistances of your spell targets by 10." }
	local words = IS:Read(Mock.ItemLink(WORDS)).stats
	check(words["RANGED ATTACK POWER"] == 24 and words["FERAL ATTACK POWER"] == 140 and not words["ATTACK POWER"]
		and words["SPELL DAMAGE"] == 12 and words["SHADOW DAMAGE"] == 7 and words["CASTING REGEN"] == 15
		and words["SPELL PENETRATION"] == 10, "the classic Equip: lines: ranged and feral attack power, none for fighting "
		.. "undead, magical and shadow spell damage, regeneration while casting, spell penetration")
	-- A stat the client gave is not counted again from its line, under another of its names
	Mock.itemStats[SPELLS] = { ITEM_MOD_SPELL_DAMAGE_DONE_SHORT = 20, ITEM_MOD_SPELL_HEALING_DONE_SHORT = 20 }
	Mock.itemLines[SPELLS] = { "Equip: Increases damage and healing done by magical spells and effects by up to 20." }
	local spells = IS:Read(Mock.ItemLink(SPELLS)).stats
	check(spells["SPELL DAMAGE"] == 20 and spells.HEALING == 20 and not spells["SPELL POWER"],
		"a damage and healing line the client gave already counts once")
	-- The level line in the client's own language
	Mock.itemMinLevels[LATER] = 17
	Mock.itemLines[LATER] = { { "Ben\195\182tigt Stufe 17", red = true } }
	ITEM_MIN_LEVEL = "Ben\195\182tigt Stufe %d"
	check(IS:Read(Mock.ItemLink(LATER)).usable, "the red level line is read in the client's own language")
	ITEM_MIN_LEVEL = nil
	-- An item read before its tooltip came is read again; and when the client says more came
	Mock.itemLines[LATE] = { "Equip: Improves your chance to get a critical strike by 1%." }
	local getHyperlink = C_TooltipInfo.GetHyperlink
	C_TooltipInfo.GetHyperlink = function() return nil end
	local early = IS:Read(Mock.ItemLink(LATE))
	C_TooltipInfo.GetHyperlink = getHyperlink
	Mock.tooltipDataIDs[LATE] = 4242
	check(early and not early.stats.CRIT and IS:Read(Mock.ItemLink(LATE)).stats.CRIT == 1,
		"an item read before the client had its tooltip is read again")
	Mock.itemLines[LATE] = { "Equip: Improves your chance to get a critical strike by 2%." }
	check(IS:Read(Mock.ItemLink(LATE)).stats.CRIT == 1, "once read, it is kept")
	Mock.Fire("TOOLTIP_DATA_UPDATE", 4242)
	check(IS:Read(Mock.ItemLink(LATE)).stats.CRIT == 2, "until the client says more of its tooltip came")

	-- Talents: the tree with the most points, each answer matched to its tree by its id
	local talents, traits = C_ClassTalents, C_Traits
	C_ClassTalents = { GetActiveConfigID = function() return 7 end }
	C_Traits = {
		GetConfigInfo = function() return { treeIDs = { 70 } } end,
		GetGroupDisplayInfoByTreeID = function()
			return { { groupID = 1, displayName = "Arms" }, { groupID = 2, displayName = "Fury" },
				{ groupID = 3, displayName = "Protection" } }
		end,
		GetGroupCurrencyInfo = function()
			return { { traitNodeGroupID = 2, currencyInfos = { { spent = 31 } } },
				{ traitNodeGroupID = 1, currencyInfos = { { spent = 5 } } } }
		end,
	}
	check(IS:TalentSpec("WARRIOR") == "Fury" and select(2, IS:Spec()) == "talents",
		"the spec from the talents: the tree with the most points, matched by id, not by order")
	C_ClassTalents, C_Traits = talents, traits

	-- The Gear Finder tab: searched on the next frame, its unknown drops asked for five at a time
	local taragaman = ns.GetInstance("RagefireChasm").bosses[2]
	for itemID = 990800, 990811 do table.insert(taragaman.loot, { itemID = itemID }) end
	ns.Journal:ShowGear()
	local gear = f.Panels[4]
	check(f.Tabs[4]:GetText() == "Gear Finder" and gear:IsShown() and f.selectedTab == 4 and f.Tabs[5]:GetText() == "Record",
		"the journal's fourth tab, Gear Finder, opens on it; Record comes last")
	check(requests == 0, "and searches on the next frame, not while it opens")
	Mock.RunTimers(0)
	local firstAsks = requests
	Mock.RunTimers(0.1)
	check(firstAsks == 5 and requests == 10, "drops never described are asked for five at a time: "
		.. firstAsks .. ", then " .. requests - firstAsks)
	Mock.RunTimers(40)
	for _ = 990800, 990811 do table.remove(taragaman.loot) end
	local function Cell(key)
		for _, cell in ipairs(gear.Cells) do
			if cell.def.key == key then return cell end
		end
	end
	local back, main, ranged = Cell("back"), Cell("mainhand"), Cell("ranged")
	check(back.entry and back.entry.itemID == CAPE and back.Gain:GetText() == "+268%" and back.Arrow:IsShown(),
		"the cape, marked as an upgrade, adds to all the gear worn (the old cape alone): " .. tostring(back.Gain:GetText()))
	local share = main.entry and main.entry.compare.share
	check(main.entry and main.entry.itemID == FELBLADE and main.entry.compare.emptySlot and share
		and main.Gain:GetText() == string.format("+%d%%", math.floor(share + 0.5)) and main.Source:GetText() == "Ragefire Chasm",
		"an empty slot's upgrade: what it adds to the gear worn, and the dungeon it drops in")
	check(main.Name._textColor and #main.Name._textColor == 3, "its name in its quality's colour")
	local hands = Cell("hands")
	check(select(2, main.Gain:GetPoint(1)) == main.Source and select(1, hands.Gain:GetPoint(1)) == "BOTTOMRIGHT"
		and select(2, hands.Gain:GetPoint(1)) == hands.Source, "each gain right after its own dungeon's name, on either side")
	check(ns.GearPanel.GainText({ share = 4.24, delta = 3 }) == "+4.2%" and ns.GearPanel.GainText({ share = 12.4 }) == "+12%"
		and ns.GearPanel.GainText({ delta = 31.2 }) == "+31", "small gains with a decimal, big ones without, a bare gain with nothing worn")
	check(ranged.entry and ranged.entry.itemID == CROSSBOW and ranged.Level:GetText() == 17,
		"one the player can wear in two levels shows that level on its icon")
	check(not Cell("wrist").entry and Cell("wrist").Name:GetText() == "Wrist" and Cell("wrist").Source:GetText() == "No upgrade found"
		and not Cell("wrist").Arrow:IsShown(), "fire resistance is worth nothing to Arms: no upgrade, the slot's name instead")
	do
		-- A cell's words grow back after shorter ones, up to the room the gain leaves them.
		local cell = Cell("wrist")
		ns.GearPanel.SetSource(cell, "Uldaman", "+4%")
		local short = cell.Source:GetWidth()
		ns.GearPanel.SetSource(cell, "Blackrock Depths", "+4%")
		local long = cell.Source:GetWidth()
		ns.GearPanel.SetSource(cell, string.rep("Scarlet Monastery ", 4), "+4%")
		check(short == 7 * 7 and long == 16 * 7 and cell.Source:GetWidth() == cell.textWidth - (3 * 7 + 6),
			"a longer dungeon name is not cut to the last one's width: " .. tostring(short) .. ", " .. tostring(long))
		ns.GearPanel.SetSource(cell, "No upgrade found")
	end
	check(not Cell("chest").entry, "a robe for another class is left out")
	local scepter
	for _, cell in ipairs(GF:Cells()) do
		for _, entry in ipairs(cell.entries) do if entry.itemID == SCEPTER then scepter = true end end
	end
	check(not scepter, "an item more than three levels above the player is left out")
	local suggestions, side = GF:Suggest(), gear.Side
	check(side.Dungeon.Name:GetText() == "Ragefire Chasm" and side.Count.Text:GetText() == "3 upgrades here"
		and suggestions[1].instance.key == "RagefireChasm", "the suggested dungeon: Ragefire Chasm, three upgrades")
	check(side.Rows[1].Label:GetText() == "Back" and side.Rows[1].Value:GetText() == "+268%" and side.Rows[3]:IsShown()
		and not side.Rows[4]:IsShown() and side.Rows[1].entry.itemID == CAPE, "each listed by its slot, with what it adds")
	local _, waiting, looked = GF:Results()
	check(looked == #GF:Dungeons() and waiting == 0 and gear.Status:GetText() == string.format(ns.L.GEAR_LOOKING, looked),
		"the footer says where it looked, and nothing is left loading once the server has had its time: "
		.. gear.Status:GetText())

	-- A drop the client has never described: asked for, counted as loading, weighed when it comes
	local NEW_RING, NEVER = 990777, 990778
	table.insert(taragaman.loot, { itemID = NEW_RING })
	Mock.itemInstant[NEW_RING] = { "INVTYPE_FINGER", 4, 0, "Miscellaneous" }
	Mock.itemStats[NEW_RING] = { ITEM_MOD_STRENGTH_SHORT = 4 }
	GF:Refresh()
	check(select(2, GF:Results()) == 1 and gear.Status:GetText():find(ns.L.GEAR_LOADING_ONE, 1, true),
		"a drop not described yet counts as loading: " .. gear.Status:GetText())
	Mock.RunTimers(0)
	check(Mock.itemsRequested[NEW_RING], "and is asked for")
	Mock.itemsCached[NEW_RING] = true
	Mock.Fire("GET_ITEM_INFO_RECEIVED", NEW_RING)
	Mock.RunTimers(0.5)
	check(Cell("finger1").entry and Cell("finger1").entry.itemID == NEW_RING and not Cell("finger2").entry,
		"when it arrives it is weighed: a ring for the first finger only, never both")
	table.remove(taragaman.loot)
	-- One the server never describes stops counting once the journal gives up on it
	table.insert(taragaman.loot, { itemID = NEVER })
	GF:Refresh()
	check(select(2, GF:Results()) == 1, "one never answered counts as loading at first")
	Mock.RunTimers(ns.Items.GIVE_UP_SECONDS + 2)
	check(select(2, GF:Results()) == 0 and not gear.Status:GetText():find(ns.L.GEAR_LOADING_ONE, 1, true),
		"and no longer once the journal has given up on it: " .. gear.Status:GetText())
	table.remove(taragaman.loot)

	-- Another spec: a tank's single set of weights
	IS:SetSpec("Protection")
	check(IS:Spec() == "Protection" and select(2, IS:Spec()) == "picked" and IS:Weights() == ns.GEAR_WEIGHTS.WARRIOR.Protection.max,
		"a spec picked from the menu is scored, a tank with its one set")
	IS:SetSpec(nil)
	check(IS:Spec() == "Arms", "back to automatic")
	Mock.RunTimers(1)
	-- The spec menu: automatic, then the class's specs; a pick is ticked at once
	local radios = gear.Spec._menu and gear.Spec._menu.radios or {}
	local protection
	for _, radio in ipairs(radios) do if radio.text == "Protection" then protection = radio end end
	check(#radios == 4 and radios[1].text == "Automatic: Arms" and radios[1].isSelected() and protection
		and not protection.isSelected(), "the spec menu: automatic (Arms), then each of the class's specs")
	protection.setSelected()
	check(protection.isSelected() and not radios[1].isSelected() and IS:Spec() == "Protection", "a pick is ticked at once")
	radios[1].setSelected()
	Mock.RunTimers(1)

	-- Rings: the second cell is what beats the other ring worn, measured against that one
	local RING_A, RING_B, RING_X, RING_Y = 990790, 990791, 990792, 990793
	for _, itemID in ipairs({ RING_A, RING_B, RING_X, RING_Y }) do
		Mock.itemInstant[itemID] = { "INVTYPE_FINGER", 4, 0, "Miscellaneous" }
		Mock.itemsCached[itemID] = true
	end
	Mock.itemStats[RING_A], Mock.itemStats[RING_B] = { ITEM_MOD_STRENGTH_SHORT = 5 }, { ITEM_MOD_STRENGTH_SHORT = 14 }
	Mock.itemStats[RING_X], Mock.itemStats[RING_Y] = { ITEM_MOD_STRENGTH_SHORT = 19 }, { ITEM_MOD_STRENGTH_SHORT = 9 }
	table.insert(taragaman.loot, { itemID = RING_X })
	table.insert(taragaman.loot, { itemID = RING_Y })
	Mock.worn[11], Mock.worn[12] = RING_A, RING_B
	Mock.Fire("PLAYER_EQUIPMENT_CHANGED")
	Mock.RunTimers(1)
	local finger1, finger2 = Cell("finger1"), Cell("finger2")
	check(finger1.entry and finger1.entry.itemID == RING_X and not finger2.entry,
		"two rings worn: the better drop replaces the weaker, and a drop below the other is no upgrade")
	Mock.itemStats[RING_Y] = { ITEM_MOD_STRENGTH_SHORT = 16 }
	IS:Forget()
	Mock.RunTimers(1)
	local second = finger2.entry and finger2.entry.compare
	check(second and finger2.entry.itemID == RING_Y and second.slot == 12
		and math.abs(second.delta - 2 * IS:Weights().STRENGTH) < 1e-9 and math.abs(second.share - second.delta / second.total * 100) < 1e-9
		and finger2.Gain:GetText() == ns.GearPanel.GainText(second),
		"one beating the stronger ring too fills the second cell, measured against that ring: " .. tostring(finger2.Gain:GetText()))
	local listsY = false
	for _, other in ipairs(finger1.others or {}) do if other.itemID == RING_Y then listsY = true end end
	check(not listsY, "and the first cell does not list it among its own")
	-- A ring picked for the first finger: the other finger's cell takes the next, against its own ring
	GF:SetPick("finger1", RING_Y)
	ns.GearPanel:Redraw(gear)
	check(finger1.entry.itemID == RING_Y and finger1.picked and finger2.entry and finger2.entry.itemID == RING_X
		and finger2.entry.compare.slot == 12 and not finger2.picked,
		"a ring picked for the first finger: the second takes the other, measured against the ring it replaces")
	GF:SetPick("finger2", RING_Y)
	ns.GearPanel:Redraw(gear)
	check(finger2.entry.itemID == RING_X and finger1.entry.itemID == RING_Y,
		"a cell never shows the ring the other shows, picked or not")
	GF:SetPick("finger2", nil)
	-- The first finger's ring grows stronger than the pick: the pick now beats only the second
	-- finger's, and shows there, its own cell's pick or not, rather than in neither cell
	Mock.itemStats[RING_A], Mock.itemStats[RING_B] = { ITEM_MOD_STRENGTH_SHORT = 20 }, { ITEM_MOD_STRENGTH_SHORT = 10 }
	Mock.itemStats[RING_X], Mock.itemStats[RING_Y] = { ITEM_MOD_STRENGTH_SHORT = 8 }, { ITEM_MOD_STRENGTH_SHORT = 15 }
	IS:Forget()
	Mock.RunTimers(1)
	check(ns.charDB.gearFinder.picks.finger1 == RING_Y and finger2.entry and finger2.entry.itemID == RING_Y
		and finger2.entry.compare.slot == 12 and not finger1.entry,
		"a ring picked for a finger it no longer beats shows on the other finger, not in neither cell")
	finger2:Click()
	check(gear.Picker:IsShown() and gear.Picker.Rows[1].entry.itemID == RING_Y, "and its picker opens there")
	ns.GearPanel:ClosePicker()
	Mock.itemStats[RING_A], Mock.itemStats[RING_B] = { ITEM_MOD_STRENGTH_SHORT = 5 }, { ITEM_MOD_STRENGTH_SHORT = 14 }
	Mock.itemStats[RING_X], Mock.itemStats[RING_Y] = { ITEM_MOD_STRENGTH_SHORT = 19 }, { ITEM_MOD_STRENGTH_SHORT = 16 }
	GF:SetPick("finger1", nil)
	IS:Forget()
	Mock.RunTimers(1)
	-- One ring worn and a finger free: one cell fills it
	Mock.worn[11], Mock.worn[12] = RING_B, nil
	Mock.itemStats[RING_Y] = { ITEM_MOD_STRENGTH_SHORT = 9 }
	IS:Forget()
	Mock.RunTimers(1)
	check(finger2.entry and finger2.entry.itemID == RING_X and finger2.entry.compare.emptySlot and not finger1.entry
		and finger1.Source:GetText() == "No upgrade found",
		"a finger free: the best ring fills it, in its own cell, and one weaker than the worn ring is no upgrade")
	-- The stronger ring on the first finger: each pick in the cell of the ring it replaces
	Mock.worn[11], Mock.worn[12] = RING_B, RING_A
	Mock.itemStats[RING_Y] = { ITEM_MOD_STRENGTH_SHORT = 16 }
	IS:Forget()
	Mock.RunTimers(1)
	check(finger2.entry and finger2.entry.itemID == RING_X and finger2.entry.compare.slot == 12
		and finger1.entry and finger1.entry.itemID == RING_Y and finger1.entry.compare.slot == 11,
		"the weaker ring on the second finger: its replacement shows there, the next one on the first")
	Mock.itemStats[RING_Y] = { ITEM_MOD_STRENGTH_SHORT = 9 }
	-- A ring worth nothing to the spec is replaced by what the drop adds, not called an empty slot
	Mock.itemStats[RING_A] = { RESISTANCE2_NAME = 10 }
	Mock.worn[11], Mock.worn[12] = RING_A, RING_B
	IS:Forget()
	Mock.RunTimers(1)
	local worthless = finger1.entry and finger1.entry.compare
	check(worthless and finger1.entry.itemID == RING_X and worthless.slot == 11 and not worthless.emptySlot and not worthless.pct
		and worthless.share and finger1.Gain:GetText() == ns.GearPanel.GainText(worthless),
		"a worn ring worth nothing is replaced, not taken for an empty slot, and the gain stays a part of all worn: "
		.. tostring(finger1.Gain:GetText()))
	table.remove(taragaman.loot)
	table.remove(taragaman.loot)
	Mock.worn[11], Mock.worn[12] = nil, nil
	Mock.Fire("PLAYER_EQUIPMENT_CHANGED")
	Mock.RunTimers(1)

	-- Dual wield: an off-hand weapon is only for those who can wield two
	local DAGGER = 990794
	Mock.itemInstant[DAGGER] = { "INVTYPE_WEAPONOFFHAND", 2, 15, "Daggers" }
	Mock.itemsCached[DAGGER], Mock.itemStats[DAGGER] = true, { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 6 }
	check(IS:Compare(Mock.ItemLink(DAGGER)).usable == false, "an off-hand weapon is no upgrade to one who cannot dual wield")
	Mock.knownSpells[674] = true
	IS:Forget()
	check(IS:CanDualWield() and IS:Compare(Mock.ItemLink(DAGGER)).usable, "and is to one who can")
	Mock.knownSpells[674] = nil
	local isPlayerSpell, isSpellKnown, spellBook = IsPlayerSpell, IsSpellKnown, C_SpellBook
	IsPlayerSpell, IsSpellKnown = nil, nil
	C_SpellBook = { IsSpellKnown = function(spellID) return spellID == 674 end }
	IS:Forget()
	check(IS:CanDualWield(), "dual wield known from the spellbook when the client's old spell checks are gone")
	C_SpellBook = nil
	CanDualWield = function() return true end
	IS:Forget()
	check(IS:CanDualWield(), "or from the client's own answer")
	CanDualWield, IsPlayerSpell, IsSpellKnown, C_SpellBook = nil, isPlayerSpell, isSpellKnown, spellBook
	IS:Forget()
	check(not IS:CanDualWield(), "and not when none says so")
	Mock.RunTimers(1)

	-- Wearing an upgrade: it is no longer one
	Mock.worn[15] = CAPE
	Mock.Fire("PLAYER_EQUIPMENT_CHANGED")
	Mock.RunTimers(1)
	check(not back.entry and back.Name:GetText() == "Item" and back.Source:GetText() == "No upgrade found",
		"wearing the cape: no upgrade left for the back, which shows what is worn")
	Mock.worn[15] = WORN_CAPE
	Mock.Fire("PLAYER_EQUIPMENT_CHANGED")
	Mock.RunTimers(1)

	-- More dungeons with upgrades: the arrows go through them, and round
	local other
	for _, instance in ipairs(GF:Dungeons()) do
		for _, boss in ipairs(instance.bosses or {}) do
			if not other and instance.key ~= "RagefireChasm" and not boss.trash and boss.loot then
				other = { instance = instance, boss = boss }
			end
		end
	end
	local BOOTS = 990795
	Mock.itemInstant[BOOTS] = { "INVTYPE_FEET", 4, 3, "Mail" }
	Mock.itemsCached[BOOTS], Mock.itemStats[BOOTS] = true, { ITEM_MOD_STRENGTH_SHORT = 3 }
	table.insert(other.boss.loot, { itemID = BOOTS })
	GF:Refresh()
	check(side.Dungeon.Name:GetText() == "Ragefire Chasm" and side.Next:IsShown() and side.Of:GetText() == "1 of 2",
		"two dungeons with upgrades: arrows")
	side.Next:Click()
	check(side.Dungeon.Name:GetText() == other.instance.name, "the next dungeon: " .. tostring(side.Dungeon.Name:GetText()))
	side.Next:Click()
	check(side.Dungeon.Name:GetText() == "Ragefire Chasm", "and round to the first")
	side.Previous:Click()
	check(side.Dungeon.Name:GetText() == other.instance.name, "and back round to the last")
	table.remove(other.boss.loot)

	-- Clicking a cell: its top three upgrades beside it, to pick one from, as in Pathfinder
	local PICK_A, PICK_B, PICK_C, PICK_D = 990796, 990797, 990798, 990799
	for itemID, value in pairs({ [PICK_A] = 8, [PICK_B] = 6, [PICK_C] = 4, [PICK_D] = 2 }) do
		Mock.itemInstant[itemID] = { "INVTYPE_FEET", 4, 3, "Mail" }
		Mock.itemsCached[itemID], Mock.itemStats[itemID] = true, { ITEM_MOD_STRENGTH_SHORT = value }
	end
	table.insert(taragaman.loot, { itemID = PICK_A })
	table.insert(other.boss.loot, { itemID = PICK_B })
	table.insert(taragaman.loot, { itemID = PICK_C })
	table.insert(taragaman.loot, { itemID = PICK_D })
	GF:Refresh()
	local feet = Cell("feet")
	Cell("wrist"):Click()
	check(not (rawget(gear, "Picker") and gear.Picker:IsShown()), "a slot with no upgrade has nothing to pick from")
	feet:Click()
	local picker = gear.Picker
	check(picker and picker:IsShown() and f.selectedTab == 4 and picker.Title:GetText() == "Feet"
		and picker.Count:GetText() == "The top 3 of 4 upgrades" and picker.Rows[1].entry.itemID == PICK_A
		and picker.Rows[2].entry.itemID == PICK_B and picker.Rows[3].entry.itemID == PICK_C and not picker.Rows[4]:IsShown()
		and picker.Rows[1].Mark:GetText() == "Biggest" and picker.Rows[1].Selected:IsShown() and not picker.Rows[2].Selected:IsShown()
		and not picker.Clear:IsShown(), "a click on a cell: its top three upgrades beside it, biggest first and marked")
	check(select(1, picker:GetPoint(1)) == "TOPRIGHT" and picker.Rows[2].Source:GetText():find(other.instance.name, 1, true)
		and picker.Rows[2].Gain:GetText() == ns.GearPanel.GainText(picker.Rows[2].entry.compare),
		"over the other column, each with where it drops and what it adds")
	picker.Rows[2]:Click()
	local suggested = {}
	for _, dungeon in ipairs(GF:Suggest()) do
		for _, key in ipairs(dungeon.slots) do suggested[key] = dungeon.instance end
	end
	check(not picker:IsShown() and feet.entry.itemID == PICK_B and feet.picked and feet.Picked:IsShown() == feet.hasPickedArt
		and ns.charDB.gearFinder.picks.feet == PICK_B and suggested.feet == other.instance,
		"picking one shows it in the slot, starred, kept for the character; the suggested dungeons follow")
	feet:Click()
	check(picker:IsShown() and picker.Rows[2].Mark:GetText() == "Your pick" and picker.Rows[2].Selected:IsShown()
		and picker.Clear:IsShown(), "opened again, it marks the pick, with Clear")
	feet:Click()
	check(not picker:IsShown(), "a second click on the cell closes it")
	GF:SetPick("feet", PICK_D)
	ns.GearPanel:Redraw(gear)
	feet:Click()
	check(picker.Rows[4]:IsShown() and picker.Rows[4].entry.itemID == PICK_D and picker.Rows[4].Mark:GetText() == "Your pick",
		"a pick further down than the top three is listed after them")
	picker.Clear:Click()
	check(not picker:IsShown() and feet.entry.itemID == PICK_A and not feet.picked and not feet.Picked:IsShown()
		and ns.charDB.gearFinder.picks.feet == nil, "Clear my pick: the biggest again")
	GF:SetPick("feet", PICK_A)
	check(ns.charDB.gearFinder.picks.feet == nil, "picking the biggest is no pick at all")
	-- A pick that stops being an upgrade gives the slot back its biggest; one put on is forgotten
	GF:SetPick("feet", PICK_C)
	Mock.worn[8] = PICK_C
	Mock.Fire("PLAYER_EQUIPMENT_CHANGED")
	Mock.RunTimers(1)
	check(ns.charDB.gearFinder.picks.feet == nil and feet.entry.itemID == PICK_A and not feet.picked,
		"a pick put on is forgotten, and the slot shows what still beats it")
	Mock.worn[8] = nil
	feet:Click()
	ns.Journal:SelectTab(1)
	check(not picker:IsShown(), "the box closes with the tab")
	ns.Journal:ShowGear()
	Mock.RunTimers(1)
	for _ = 1, 3 do table.remove(taragaman.loot) end
	table.remove(other.boss.loot)
	Mock.Fire("PLAYER_EQUIPMENT_CHANGED")
	Mock.RunTimers(1)

	-- Right-clicking an upgrade opens its boss's loot, past a loot filter that would hide it
	ns.charDB.lootFilters.slot = "FEET"
	main:Click("RightButton")
	Mock.RunTimers(2)
	check(page:IsShown() and page.boss and page.boss.name == "Taragaman the Hungerer" and page.tab == Page.TAB_LOOT
		and f.selectedTab == 1, "an upgrade opens its boss on the Loot tab, under Dungeons")
	check(page.Loot.revealedItemID == FELBLADE and ns.charDB.lootFilters.slot == "ALL",
		"its row shown, though the loot filter would have hidden it")
	-- A trash drop opens the dungeon's own loot, as a search result does: one of a nearby dungeon's,
	-- described here with strength enough to beat anything in its slot
	local trashInstance, trashItem
	for _, instance in ipairs(GF:Dungeons()) do
		for _, boss in ipairs(instance.bosses or {}) do
			for _, row in ipairs(boss.trash and boss.loot or {}) do
				local info = not trashItem and type(row.itemID) == "number" and ns.Items:Get(row.itemID, row)
				if info and info.kind == "EQUIPMENT" and ns.Items:ClassCanUse("WARRIOR", info) then
					trashInstance, trashItem = instance, row.itemID
				end
			end
		end
	end
	Mock.itemsCached[trashItem], Mock.itemStats[trashItem] = true, { ITEM_MOD_STRENGTH_SHORT = 40 }
	ns.Journal:ShowGear()
	Mock.RunTimers(1)
	local trashCell
	for _, cell in ipairs(gear.Cells) do
		if cell.entry and cell.entry.itemID == trashItem then trashCell = cell end
	end
	check(trashCell and trashCell.Source:GetText() == trashInstance.name,
		"a trash drop names its dungeon: " .. tostring(trashCell and trashCell.Source:GetText()))
	trashCell:Click("RightButton")
	Mock.RunTimers(2)
	check(page:IsShown() and page.instance == trashInstance and not page.boss and page.tab == Page.TAB_LOOT
		and page.Loot.revealedItemID == trashItem, "and opens the dungeon's own loot page on it")
	Mock.itemsCached[trashItem], Mock.itemStats[trashItem] = nil, nil

	-- The character panel's side tab: the first place under the panel's own, and its stat weights
	;(function()
		check(not ns.CharacterTab:Create() and not ns.CharacterTab.tab, "no character panel with side tabs: no tab")
		local column = CreateFrame("Frame", "CharacterFrameModeTabs", UIParent)
		column.Tabs = { CreateFrame("Frame", "CharacterFrameModeTab1", column), CreateFrame("Frame", "CharacterFrameModeTab2", column) }
		column.Tabs[1].frameName, column.Tabs[2].frameName = "PaperDollFrame", "ReputationFrame"
		column.Tabs[2]:Hide()
		_G.CharacterFrame = CreateFrame("Frame", "CharacterFrame", UIParent)
		CharacterFrame.ModeTabs = column
		CharacterFrame.RightPaneHost = CreateFrame("Frame", nil, CharacterFrame)
		local layouts = 0
		CharacterFrame.UpdateTabLayout = function() layouts = layouts + 1 end
		-- Two of its pages, and what turns it from one to another and marks their tabs, as
		-- Blizzard_UIPanels_Game/Camelot/CharacterFrame.lua does
		_G.PaperDollFrame = CreateFrame("Frame", "PaperDollFrame", CharacterFrame)
		_G.ReputationFrame = CreateFrame("Frame", "ReputationFrame", CharacterFrame)
		CharacterFrame.ShowSubFrame = function(self, name)
			self.activeSubframe = name
			PaperDollFrame:SetShown(name == "PaperDollFrame")
			ReputationFrame:SetShown(name == "ReputationFrame")
		end
		CharacterFrame.RefreshDisplay = function(self)
			for _, own in ipairs(column.Tabs) do
				if own.frameName then own:SetChecked(own.frameName == self.activeSubframe) end
			end
		end
		-- What only Blizzard's own code may call: ToggleCharacter moves the gamepad's cursor, and the
		-- pane's folded state, once written by an addon, stays so
		local blizzardOnly = 0
		_G.ToggleCharacter = function(name)
			blizzardOnly = blizzardOnly + 1
			if not _G[name]:IsShown() then CharacterFrame:ShowSubFrame(name) end
			CharacterFrame:RefreshDisplay()
		end
		CharacterFrame.OnModeTabClicked = function(_, own) ToggleCharacter(own.frameName, true) end
		CharacterFrame.RefreshRightPane = function(self) self.RightPaneHost:SetShown(not self.rightPaneCollapsed) end
		CharacterFrame.IsRightPaneCollapsed = function(self) return self.rightPaneCollapsed == true end
		CharacterFrame.SetRightPaneCollapsed = function(self, collapsed)
			blizzardOnly = blizzardOnly + 1
			self.rightPaneCollapsed = collapsed
			self:RefreshRightPane()
			self:RefreshDisplay()
		end
		CharacterFrame:ShowSubFrame("ReputationFrame")
		CharacterFrame:RefreshDisplay()
		-- Another addon's tab already in that place, put in the panel's own list of tabs, and one more
		-- of its own hung under it
		local theirs = CreateFrame("Frame", "OtherAddonTab", column)
		theirs:SetPoint("TOPLEFT", column.Tabs[1], "BOTTOMLEFT", 0, -2)
		table.insert(column.Tabs, theirs)
		local theirsNext = CreateFrame("Frame", nil, column)
		theirsNext:SetPoint("TOPLEFT", theirs, "BOTTOMLEFT", 0, -2)
		check(ns.CharacterTab:Create(), "a tab on the character panel's side")
		local tab = ns.CharacterTab.tab
		check(tab:GetParent() == column and select(2, tab:GetPoint(1)) == column.Tabs[1] and tab.tooltipText == "Gear Finder"
			and tab.Icon:GetTexture() == "Interface\\Icons\\INV_Helmet_08", "the first place under the panel's own tabs: a helmet")
		check(select(2, theirs:GetPoint(1)) == tab and select(2, theirsNext:GetPoint(1)) == theirs,
			"another addon's tab there moves down under it, with the one hung under that")
		local listed = false
		for _, other in ipairs(column.Tabs) do if other == tab then listed = true end end
		check(not listed and #column.Tabs == 3 and #ns.CharacterTab.BlizzardTabs(column) == 2,
			"kept out of the panel's own list of tabs; another addon's in that list is not taken for Blizzard's")
		column.Tabs[2]:Show()
		CharacterFrame:UpdateTabLayout()
		check(layouts == 1 and select(2, tab:GetPoint(1)) == column.Tabs[2] and select(2, theirs:GetPoint(1)) == tab,
			"placed again when the panel lays out its tabs, the other still under it")
		local described, oursSeen = ns.CharacterTab:Describe(), false
		for _, entry in ipairs(described or {}) do
			if entry.ours and entry.relative == "CharacterFrameModeTab2" then oursSeen = true end
		end
		check(oursSeen, "the column described for /aegis gearscan, with what each tab hangs from")

		-- Its click: the Character page, with the stat weights where its stats are
		CharacterFrame:Show()
		tab.customMouseUpHandler(tab, "RightButton", true)
		tab.customMouseUpHandler(tab, "LeftButton", false)
		check(not (ns.CharacterTab.window and ns.CharacterTab.window:IsShown()) and ReputationFrame:IsShown(),
			"a right click, or a press let go outside it, does nothing")
		local before = blizzardOnly
		tab.customMouseUpHandler(tab, "LeftButton", true)
		local window = ns.CharacterTab.window
		check(window and window:IsShown() and window:GetParent() == CharacterFrame and window:GetFrameStrata() == "HIGH"
			and select(2, window:GetPoint(1)) == CharacterFrame.RightPaneHost,
			"a click shows the stat weights over the panel's stats, above its detail panes")
		check(PaperDollFrame:IsShown() and not ReputationFrame:IsShown() and CharacterFrame.activeSubframe == "PaperDollFrame"
			and blizzardOnly == before, "from another page, the panel turns to the Character page")
		check(tab:GetChecked() and not column.Tabs[1]:GetChecked() and not column.Tabs[2]:GetChecked(),
			"this tab marked, none of the panel's own")
		tab.customMouseUpHandler(tab, "LeftButton", true)
		CharacterFrame:RefreshDisplay()
		check(window:IsShown() and tab:GetChecked() and not column.Tabs[1]:GetChecked(),
			"clicked again, the weights stay; the panel laid out again leaves this tab marked")
		-- The pane folded away by its own button: the window over the panel's edge, below that button
		CharacterFrame:SetRightPaneCollapsed(true)
		local point, relative, _, _, y = window:GetPoint(1)
		check(window:IsShown() and tab:GetChecked() and point == "TOPRIGHT" and relative == CharacterFrame and y == -56,
			"the pane folded away: the weights stay, over the panel's edge")
		CharacterFrame:ShowSubFrame("ReputationFrame")
		before = blizzardOnly
		tab.customMouseUpHandler(tab, "LeftButton", true)
		check(PaperDollFrame:IsShown() and CharacterFrame:IsRightPaneCollapsed() and window:IsShown()
			and select(2, window:GetPoint(1)) == CharacterFrame, "a folded pane is left so, the weights over the edge")
		check(blizzardOnly == before, "the tab turns the page and places the weights without calling ToggleCharacter "
			.. "or folding the pane itself")
		CharacterFrame:SetRightPaneCollapsed(false)
		check(window:IsShown() and select(2, window:GetPoint(1)) == CharacterFrame.RightPaneHost,
			"and goes over the pane once it is unfolded")
		local editor = window.Editor
		local strength = editor.Rows[1]
		check(#editor.Rows == 45 and strength.stat == "STRENGTH" and strength.Label:GetText() == "Strength:"
			and strength.Value:GetText() == "2.16" and editor.Source:GetText() == ns.L.WEIGHTS_SOURCE_LEVELLING,
			"every stat, grouped as the panel groups its own, with the spec's weight: " .. tostring(strength.Value:GetText()))
		-- A weight typed in: the player's own, in green, scored at once
		strength.Value:SetText("3")
		strength.Value:_RunScript("OnEnterPressed")
		check(IS:Weights().STRENGTH == 3 and IS:DefaultWeights().STRENGTH == 2.16 and IS:CustomWeights("Arms")
			and strength.Value._textColor[1] < 0.5 and editor.Source:GetText() == ns.L.WEIGHTS_SOURCE_CUSTOM,
			"a weight changed is the player's own, shown green")
		strength.Value:SetText("lots")
		strength.Value:_RunScript("OnEnterPressed")
		check(strength.Value:GetText() == "3" and IS:Weights().STRENGTH == 3, "what isn't a number is put back")
		strength.Value:SetText("2,16")
		strength.Value:_RunScript("OnEnterPressed")
		check(not IS:CustomWeights("Arms") and IS:Weights() == IS:DefaultWeights(), "changed back, the journal's weights again")
		editor.Rows[2].Value:SetText("5")
		editor.Rows[2].Value:_RunScript("OnEnterPressed")
		check(IS:CustomWeights("Arms") and editor.Reset._disabledState == false, "another change, and Reset to undo it")
		editor.Reset:Click()
		check(not IS:CustomWeights("Arms") and editor.Reset._disabledState == true, "Reset: the journal's weights")
		-- A change made while levelling stays a change: at 60 the journal's level-60 weights apply under it
		editor.Rows[2].Value:SetText("5")
		editor.Rows[2].Value:_RunScript("OnEnterPressed")
		Mock.level = 60
		IS:Forget()
		check(IS:Weights().AGILITY == 5 and IS:Weights().HIT == ns.GEAR_WEIGHTS.WARRIOR.Arms.max.HIT,
			"a weight changed while levelling still applies at 60, over the journal's level-60 weights")
		Mock.level = 15
		IS:Forget()
		editor.Reset:Click()

		-- A Pawn scale tag
		local TAG = '( Pawn: v1: "Arms PvE": Class=Warrior, Spec=1, Strength=1, Agility=0.65, HitRating=1.4, Ap=0.45, '
			.. 'MeleeDps=3.2, Hp5=0, MetaSocketEffect=36, FooBar=2 )'
		local weights, name, unknown = IS:ParsePawn(TAG)
		check(weights and name == "Arms PvE" and weights.STRENGTH == 1 and weights.AGILITY == 0.65 and weights.HIT == 1.4
			and weights["ATTACK POWER"] == 0.45 and weights.DPS == 3.2 and weights["HEALTH PER 5"] == nil
			and #unknown == 1 and unknown[1] == "FooBar", "a Pawn scale tag read: its weights, its name, what it has that isn't known")
		check(IS:ParsePawn("not a scale") == nil, "text that isn't one is no scale")
		local caster = IS:ParsePawn('( Pawn: v1: "Frost": Class=Mage, SpellDamage=1, Intellect=0.4, Dps=2, Spirit=1e999 )')
		check(caster["SPELL POWER"] == 1 and caster["SPELL DAMAGE"] == 1 and caster.DPS == 2 and caster["RANGED DPS"] == 2
			and caster.SPIRIT == nil, "spell damage counts for damage-and-healing gear too, weapon damage for wands, nothing absurd")
		check(not IS:ImportPawn("Arms", '( Pawn: v1: "Frost": Class=Mage, SpellDamage=1 )') and not IS:CustomWeights("Arms"),
			"a scale for another class is not taken")
		editor.Pawn:Click()
		check(editor.Import:IsShown() and not editor.Scroll:IsShown(), "Pawn... asks for the tag")
		editor.Import.Box:SetText("hello")
		editor.Import.Import:Click()
		check(editor.Message:GetText() == ns.L.WEIGHTS_NOT_PAWN and not IS:CustomWeights("Arms"), "and says when the text isn't one")
		editor.Import.Box:SetText(TAG)
		editor.Import.Import:Click()
		check(IS:Weights().STRENGTH == 1 and IS:Weights().HIT == 1.4 and editor.Scroll:IsShown()
			and editor.Source:GetText() == string.format(ns.L.WEIGHTS_SOURCE_PAWN, "Arms PvE")
			and editor.Message:GetText():find("FooBar", 1, true), "a scale brought in, and what of it wasn't used said: "
			.. tostring(editor.Message:GetText()))
		-- A weight with more in it than the box shows is left alone when the box is passed through
		IS:ImportPawn("Arms", '( Pawn: v1: "Fine": Strength=1, Agility=0.68691 )')
		local agility = editor.Rows[2]
		check(agility.Value:GetText() == "0.6869", "four decimals shown: " .. tostring(agility.Value:GetText()))
		agility.Value:_RunScript("OnEditFocusGained")
		agility.Value:_RunScript("OnEditFocusLost")
		check(IS:Weights().AGILITY == 0.68691, "and nothing changed by passing through it")
		editor.Reset:Click()

		-- The window closes when the panel turns to another page; its button opens the Gear Finder
		CharacterFrame:ShowSubFrame("ReputationFrame")
		CharacterFrame:RefreshDisplay()
		check(not window:IsShown() and not tab:GetChecked() and column.Tabs[2]:GetChecked(), "another page of the panel closes it")
		tab.customMouseUpHandler(tab, "LeftButton", true)
		CharacterFrame:OnModeTabClicked(column.Tabs[1])
		check(not window:IsShown() and PaperDollFrame:IsShown() and column.Tabs[1]:GetChecked() and not tab:GetChecked(),
			"as does any of its tabs, the page already shown among them: the Character tab gives the stats back")
		tab.customMouseUpHandler(tab, "LeftButton", true)
		ns.Journal:SelectTab(1)
		f:Hide()
		editor.Extra:Click()
		Mock.RunTimers(1)
		check(f:IsShown() and f.selectedTab == 4 and gear:IsShown() and not CharacterFrame:IsShown(),
			"Open the Gear Finder: the journal in the panel's place")
		Mock.inCombat = true
		CharacterFrame:Show()
		ns.CharacterTab:Open()
		check(CharacterFrame:IsShown() and f:IsShown(), "in combat the panel is left alone, and the journal opens over it")
		Mock.inCombat = nil

		-- The same weights in the Gear Finder tab, from its spec menu or /aegis weights
		local buttons = gear.Spec._menu and gear.Spec._menu.buttons or {}
		check(buttons[1] and buttons[1].text == ns.L.WEIGHTS_EDIT, "the spec menu offers the stat weights")
		SlashCmdList.AEGISJOURNAL("weights")
		local side = gear.Side
		check(f.selectedTab == 4 and side.Editor and side.EditorHolder:IsShown() and not side.Suggestion:IsShown()
			and #side.Editor.Rows == 45, "/aegis weights: the Gear Finder tab with its weights")
		side.Editor.Extra:Click()
		check(side.Suggestion:IsShown() and not side.EditorHolder:IsShown(), "Back: the suggested dungeon again")
		SlashCmdList.AEGISJOURNAL("weights")
		f:Hide()
		ns.Journal:ShowGear()
		check(side.Suggestion:IsShown() and not side.EditorHolder:IsShown(), "opened again, the tab shows its upgrades")
		check(ns.GearPanel.GainText({ delta = 0.4 }) == "+0.4", "a small gain with nothing worn of worth: not '+0'")
		_G.CharacterFrame, _G.CharacterFrameModeTabs = nil, nil
		_G.PaperDollFrame, _G.ReputationFrame, _G.ToggleCharacter = nil, nil, nil
	end)()

	-- /aegis gearscan saves what the client says about the worn gear and nearby drops
	SlashCmdList.AEGISJOURNAL("gearscan")
	local scan = ns.db.gearScan
	check(scan and scan.class == "WARRIOR" and scan.level == 15 and #scan.worn == 1 and scan.worn[1].raw.ITEM_MOD_STAMINA_SHORT == 1
		and #scan.drops > 0 and scan.spec == "Arms", "the scan keeps the worn gear's raw stats and some drops")
	local named = false
	for _, key in ipairs(scan.unknownKeys) do if key == "ITEM_MOD_NEW_THING" then named = true end end
	check(named, "and the stat names the journal doesn't know")
	-- Only what the saved file can keep: strings, numbers, true and false, in plain tables
	local function Saveable(value, depth)
		if type(value) == "table" then
			if getmetatable(value) or depth > 10 then return false end
			for key, inner in pairs(value) do
				if not (Saveable(key, depth + 1) and Saveable(inner, depth + 1)) then return false end
			end
			return true
		end
		return type(value) == "string" or type(value) == "number" or type(value) == "boolean"
	end
	check(Saveable(scan, 0), "the scan holds only what the saved file can keep")
	-- An item the journal cannot read is noted and the rest kept; a secret is saved as one; the
	-- class's own background is the art measured
	local read, getAtlas, SECRET, askedAtlases = IS.Read, C_Texture.GetAtlasInfo, {}, {}
	IS.Read = function(self, link)
		if link == Mock.ItemLink(CAPE) then error("unreadable") end
		return read(self, link)
	end
	C_Texture.GetAtlasInfo = function(name)
		askedAtlases[name] = true
		return getAtlas(name)
	end
	issecretvalue = function(value) return value == SECRET end
	Mock.itemStats[WORN_CAPE] = { ITEM_MOD_STAMINA_SHORT = SECRET }
	SlashCmdList.AEGISJOURNAL("gearscan")
	IS.Read, C_Texture.GetAtlasInfo, issecretvalue = read, getAtlas, nil
	Mock.itemStats[WORN_CAPE] = { ITEM_MOD_STAMINA_SHORT = 1, RESISTANCE0_NAME = 10 }
	scan = ns.db.gearScan
	local told = false
	for _, line in ipairs(Mock.chat) do
		if line:find(string.format(ns.L.GEAR_SCAN_ERRORS, 1), 1, true) then told = true end
	end
	check(#scan.errors == 1 and scan.errors[1]:find("unreadable", 1, true) and #scan.drops > 0 and #scan.worn == 1 and told,
		"an item that cannot be read is noted, said in chat, and the rest kept: " .. tostring(scan.errors[1]))
	check(scan.worn[1].raw.ITEM_MOD_STAMINA_SHORT == "<secret>" and Saveable(scan, 0), "a secret is saved as one, not as itself")
	check(askedAtlases["UI-Character-Info-WARRIOR-BG"] and scan.atlases["UI-Character-Info-CLASS-BG"]
		and scan.atlases["UI-Character-Info-CLASS-BG"].width == 64, "the class's own background is measured")

	ns.Journal:SelectTab(1)
	f:Hide()
	Mock.RunTimers(60)
	Mock.deferTimers, Mock.timers = false, {}
	C_Item.RequestLoadItemDataByID = request
	Mock.level, Mock.playerClass, Mock.worn, Mock.time = level, class, {}, clock
	IS:Forget()
end)()

return string.format("All %d checks passed.", checks)
