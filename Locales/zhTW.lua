local _, ns = ...

--[[
	The journal's interface in Traditional Chinese, for a client set to Traditional Chinese (zhTW).
	Drafted by Claude for review by a native speaker. It is laid over the English table
	(Locales/enUS.lua), so every file that already holds ns.L sees these strings, and anything not
	translated here stays English. Every other client skips it.
]]
if GetLocale() ~= "zhTW" then return end

local L = ns.L

L.JOURNAL_TITLE = "副本導覽"
L.HOME = HOME or "首頁"
L.TAB_DUNGEONS = DUNGEONS or "地城"
L.TAB_RAIDS = RAIDS or "團隊副本"
L.TAB_REPUTATION = REPUTATION or "聲望"

L.BINDING_TOGGLE = "開啟/關閉副本導覽"
L.KEY_CLAIMED = "現在按 Shift+J 會開啟副本導覽。"
L.KEY_TAKEN = "Shift+J 已綁定到%s。請在「按鍵設定 > 插件 > 開啟/關閉副本導覽」中選擇一個按鍵。"
L.POSITION_RESET = "視窗位置已重置。"
L.SLASH_HELP = "/aegis（或 /ij）開啟日誌。/aegis record 開始或停止錄製。/aegis reset 將視窗移回預設位置。/aegis perf 測量日誌的記憶體用量與速度。/aegis where 和 /aegis taxi 回報你所在的位置以及你地圖上的飛行點。/aegis travel 為世界地圖儲存船隻、飛艇、地鐵或傳送門。/aegis items 找出伺服器完全不認得的已列出物品。/aegis gear 開啟裝備搜尋器，/aegis weights 開啟其屬性權重；/aegis gearscan 儲存它從你的裝備讀取到的資料，以便檢查其評分。/aegis options 開啟日誌的選項。"
L.AREAS_START = "正在查詢日誌中 %d 個區域名稱在客戶端中的 ID……"
L.AREAS_DONE = "已找到 %d 個區域名稱的 ID（共 %d 個）。輸入 /reload 以儲存。"
L.AREAS_MISSING = "找不到：%s。"
L.AREAS_SCANNING = "仍在查詢區域名稱。"
L.AREAS_ENGLISH = "請在英文客戶端上執行 /aegis areas：它搜尋的名稱是英文。"
L.ITEMS_START = "正在向伺服器查詢導覽所列的%d件物品。約%d秒後會有結果，你可以照常遊戲。"
L.ITEMS_SCANNING = "仍在向伺服器查詢，結果馬上就到。"
L.ITEMS_DONE = "在%d件物品中，伺服器完全不認得其中%d件：它們很可能尚未加入 Forever。導覽會先隱藏這些物品，直到伺服器或記錄的進度證實它們存在。完整清單會在你下次 /reload 或登出時寫入存檔。"
L.ITEMS_LINE = "  物品%d：%s"
L.ITEMS_MORE = "  ……還有%d件。"
L.PERF_HEADER = "效能（記憶體單位為KB，時間單位為毫秒；越低越好）："
L.PERF_MEMORY = "  %s：%.0f KB"
L.PERF_TIME = "  %s：%.2f 毫秒"
L.PERF_BUILD = "首次開啟（建立視窗）"
L.PERF_BOOK = "首次開啟地城（建立書頁）"
L.PERF_OPEN = "開啟並關閉導覽"
L.PERF_DUNGEON = "開啟地城頁面"
L.PERF_TAB = "切換到「%s」分頁"
L.PERF_FACTION = "開啟陣營頁面"
L.PERF_LOOT = "重繪戰利品頁面"
L.PERF_COMBAT = "測量將等到你脫離戰鬥後進行。"
L.WHERE = "地圖 %s（%s）  x %.4f  y %.4f  區域「%s」  小地圖「%s」  高度 %s"
L.TAXI = "地圖 %s  自行顯示飛行點：%s  其上的飛行點：%d（已發現%d）  %s"
L.TAXI_ATLASES = "旅行圖示：%s"
L.YES = YES or "是"
L.NO = NO or "否"

L.EMPTY_DUNGEONS = "目前還沒有任何地城的導覽條目。"
L.EMPTY_RAIDS = "目前還沒有任何團隊副本的導覽條目。"
L.EMPTY_REPUTATION = "目前還不知道任何陣營獎勵。"
L.EMPTY_BRACKET = "這個等級範圍內沒有任何內容。"

L.TAB_RECORD = "記錄"
L.TAB_GEAR = "裝備搜尋"

-- The Gear Finder (Core/GearFinder.lua, UI/GearPanel.lua, UI/CharacterTab.lua).
L.GEAR_TITLE = "裝備搜尋"
L.GEAR_PREVIEW = "預覽"
L.GEAR_NO_UPGRADE = "未找到提升"
L.GEAR_LOOKING = "正在%d個地城中搜尋。"
L.GEAR_LOOKING_ONE = "正在1個地城中搜尋。"
L.GEAR_LOADING = "還有%d件物品正在載入。"
L.GEAR_LOADING_ONE = "還有1件物品正在載入。"
L.GEAR_SCORING = "評分依據"
L.GEAR_AUTO = "自動：%s"
L.GEAR_WHY_TALENTS = "%s（天賦）"
L.GEAR_WHY_LEVELLING = "%s（升級期間）"
L.GEAR_SUGGESTED = "推薦地城"
L.GEAR_UPGRADES_HERE = "此處有%d件提升"
L.GEAR_UPGRADE_HERE = "此處有1件提升"
L.GEAR_MORE_SLOTS = "以及另外%d個"
L.GEAR_DUNGEON_OF = "%d / %d"
L.GEAR_NONE = "你等級附近的地城中沒有提升。"
L.GEAR_TIP_CLICK = "點擊查看其戰利品；Shift-點擊以連結。"
L.GEAR_TIP_CELL_CLICK = "點擊查看最佳提升；右鍵點擊查看其戰利品。"
L.GEAR_TIP_PICK_CLICK = "點擊以在此處顯示；右鍵點擊查看其戰利品。"
L.GEAR_TIP_PICKED = "你為此欄位選定的物品。"
L.GEAR_PICK_TOP = "前%d件（共%d件提升）"
L.GEAR_PICK_ALL = "%d件提升"
L.GEAR_PICK_ONE = "唯一的提升"
L.GEAR_PICK_BIGGEST = "最大提升"
L.GEAR_PICK_YOURS = "你的選擇"
L.GEAR_PICK_KEPT = "選擇會為此角色保存。"
L.GEAR_PICK_CLEAR = "清除我的選擇"
L.GEAR_TIP_NONE = "你等級附近的地城中沒有此欄位的提升。"
L.GEAR_CHAR_BUTTON = "裝備搜尋"
L.GEAR_CHAR_BUTTON_TIP = "你的屬性權重，以及導覽各地城中等著你的最佳提升。"
L.GEAR_SCAN_DONE = "裝備掃描已儲存：%d件已穿戴的物品與%d件地城掉落。登出或輸入 /reload 即可寫入存檔。"
L.GEAR_SCAN_ERRORS = "有%d件物品無法讀取；錯誤原因已與掃描一併儲存。"
L.GEAR_SCAN_LOADING = "部分掉落仍在載入：請等待幾秒，再輸入一次 /aegis gearscan 以取得更多。"
L.GEAR_SLOT_FINGER1 = "手指 1"
L.GEAR_SLOT_FINGER2 = "手指 2"
L.GEAR_SLOT_TRINKET1 = "飾品 1"
L.GEAR_SLOT_TRINKET2 = "飾品 2"

-- Stat weights (Core/ItemScore.lua, UI/WeightsEditor.lua).
L.WEIGHTS_TITLE = "屬性權重"
L.WEIGHTS_EDIT = "編輯屬性權重..."
L.WEIGHTS_SOURCE_DEFAULT = "導覽的權重"
L.WEIGHTS_SOURCE_LEVELLING = "導覽的權重（升級期間）"
L.WEIGHTS_SOURCE_CUSTOM = "你自訂的權重"
L.WEIGHTS_SOURCE_PAWN = "你的權重，來自 Pawn：%s"
L.WEIGHTS_TIP = "每一點屬性對此專精的價值。點擊一項權重即可修改；你自訂的權重會以綠色顯示，並為此角色保存。"
L.WEIGHTS_RESET = "重置"
L.WEIGHTS_RESET_TIP = "恢復為導覽針對此專精的權重。"
L.WEIGHTS_PAWN = "Pawn..."
L.WEIGHTS_PAWN_TIP = "從 Pawn 匯入一套權重方案。"
L.WEIGHTS_PAWN_HELP = "在 Pawn 中選擇權重方案，點選「匯出」，複製文字，然後貼到這裡。"
L.WEIGHTS_IMPORT = "匯入"
L.WEIGHTS_CANCEL = "取消"
L.WEIGHTS_BACK = "返回"
L.WEIGHTS_OPEN_FINDER = "開啟裝備搜尋"
L.WEIGHTS_IMPORTED = "已匯入%d項權重，來自%s。"
L.WEIGHTS_UNUSED = "未使用：%s。"
L.WEIGHTS_NOT_PAWN = "這不是 Pawn 的權重方案。請在 Pawn 中點選「匯出」，並複製其中的全部文字。"
L.WEIGHTS_OTHER_CLASS = "這套權重方案是給%s用的，不是此角色的職業。"
L.WEIGHTS_FOR = "適用"
-- The journal's page in the game's options (Options > AddOns).
L.OPTIONS_TITLE = "Aegis 副本導覽"
L.OPTIONS_BOSS_LEVELS = "在首領列表中顯示首領等級"
L.OPTIONS_BOSS_LEVELS_TIP = "在每個首領的頭像上標示其等級，並依首領對你的難度著色：灰色、綠色、黃色、橘色或紅色。"
L.OPTIONS_ARROWS = "以綠色箭頭標示提升"
L.OPTIONS_ARROWS_TIP = "依裝備搜尋的計算，在對你的專精而言是提升的物品上顯示綠色箭頭：包括你的背包、拾取視窗與擲骰拾取。"
L.WEIGHTS_SHOW_GAINS = "在浮動提示中顯示屬性權重"
L.WEIGHTS_SHOW_GAINS_TIP = "在每件物品下方，為你的每個專精顯示一行：依權重計算的物品價值；若是提升，另以綠色箭頭顯示它能為你的裝備增加多少。適用於你的所有角色。"
L.GEAR_WHY_CUSTOM = "%s（你的權重）"
L.GEAR_SPEC_NAMES = {
	Arms = "武器", Fury = "狂怒", Protection = "防護", Holy = "神聖", Retribution = "懲戒",
	BeastMastery = "野獸控制", Marksmanship = "射擊", Survival = "生存",
	Assassination = "刺殺", Combat = "戰鬥", Subtlety = "敏銳", Discipline = "戒律", Shadow = "暗影",
	Elemental = "元素", Enhancement = "增強", EnhancementTank = "增強（坦克）",
	Restoration = "恢復", Arcane = "秘法", Fire = "火焰", Frost = "冰霜", Affliction = "痛苦",
	Demonology = "惡魔學識", Destruction = "毀滅", Balance = "平衡", FeralBear = "野性戰鬥（熊）",
	FeralCat = "野性戰鬥（貓）",
}
L.GEAR_UNITS = {
	["attack power"] = "攻擊強度", ["ranged attack power"] = "遠程攻擊強度",
	["spell damage"] = "法術傷害", healing = "治療", Stamina = "耐力",
}
L.WEIGHT_GROUPS = {
	PRIMARY = "主要屬性", WEAPONS = "武器", SPELLS = "法術", DEFENSE = "防禦",
	RESISTANCE = "抗性",
}
L.STAT_NAMES = {
	STRENGTH = "力量", AGILITY = "敏捷", STAMINA = "耐力", INTELLECT = "智力", SPIRIT = "精神",
	DPS = "武器每秒傷害", ["RANGED DPS"] = "遠程武器每秒傷害", ["ATTACK POWER"] = "攻擊強度",
	["RANGED ATTACK POWER"] = "遠程攻擊強度", ["FERAL ATTACK POWER"] = "野性攻擊強度", HIT = "命中",
	CRIT = "致命一擊", ["RANGED CRIT"] = "遠程致命一擊", HASTE = "攻擊速度", ["RANGED HASTE"] = "遠程攻擊速度",
	["SPELL POWER"] = "傷害與治療", ["SPELL DAMAGE"] = "法術傷害", HEALING = "治療", ["SPELL HIT"] = "法術命中",
	["SPELL CRIT"] = "法術致命一擊", ["HOLY CRIT"] = "神聖法術致命一擊", ["HOLY DAMAGE"] = "神聖傷害",
	["FIRE DAMAGE"] = "火焰傷害", ["FROST DAMAGE"] = "冰霜傷害", ["NATURE DAMAGE"] = "自然傷害",
	["SHADOW DAMAGE"] = "暗影傷害", ["ARCANE DAMAGE"] = "秘法傷害", ["SPELL PENETRATION"] = "法術穿透",
	MANA = "法力", ["MANA PER 5"] = "每5秒法力", ["CASTING REGEN"] = "施法時回復",
	ARMOR = "護甲", HEALTH = "生命力", ["HEALTH PER 5"] = "每5秒生命力", DEFENSE = "防禦", DODGE = "閃躲",
	PARRY = "招架", BLOCK = "格擋", ["BLOCK VALUE"] = "格擋值",
	["HOLY RESISTANCE"] = "神聖抗性", ["FIRE RESISTANCE"] = "火焰抗性",
	["NATURE RESISTANCE"] = "自然抗性", ["FROST RESISTANCE"] = "冰霜抗性",
	["SHADOW RESISTANCE"] = "暗影抗性", ["ARCANE RESISTANCE"] = "秘法抗性",
}
L.RECORD_START = "開始記錄"
L.RECORD_STOP = "停止記錄"
L.RECORD_CLEAR = "清除"
L.RECORD_CLEAR_CONFIRM = "要丟棄目前記錄的所有內容嗎？此操作無法復原。"
L.RECORD_STATUS_ON = "自%s起記錄中"
L.RECORD_STATUS_OFF = "未在記錄"
L.RECORD_COMBATLOG = "在地城中寫入戰鬥記錄"
L.RECORD_COMBATLOG_TIP = "首領技能來自遊戲的戰鬥記錄。導覽會在地城內開啟戰鬥記錄，並在離開時關閉；你自己開啟的記錄則不會被更動。若要傳送，請在 Log Reader 頁面上把記錄檔加入你的記錄（點擊「複製」會顯示連結）。"
L.RECORD_RECENT = "最近"
L.RECORD_NOTHING_YET = "目前尚未記錄到任何內容。開著記錄進入地城，然後像平常一樣擊殺、拾取和解任務。"
L.RECORD_STARTED = "已開始記錄。輸入 /aegis record 即可停止。"
L.RECORD_STOPPED = "已停止記錄。"
L.RECORD_LOG_STARTED = "已開始記錄。"
L.RECORD_LOG_STOPPED = "已停止記錄。"
L.RECORD_LOG_CLEARED = "記錄已清除。"
L.RECORD_LOG_ENTERED = "已進入%s。"
L.RECORD_LOG_LEFT = "已離開地城。"
L.RECORD_LOG_AREA = "新區域：%s。"
L.RECORD_LOG_PULL = "已開怪：%s。"
L.RECORD_LOG_KILL = "已擊殺：%s。"
L.RECORD_LOG_WIPE = "在%s滅團。"
L.RECORD_LOG_LOOT = "戰利品：%d件新物品。"
L.RECORD_LOG_QUEST_OFFERED = "可接任務：%s。"
L.RECORD_LOG_QUEST_DONE = "已交付任務：%s。"
L.RECORD_LOG_ENTRANCE = "已記錄%s的入口。"
L.RECORD_LOG_NO_ENTRANCE = "未記錄%s的入口：%s。"
L.RECORD_NO_MAP = "載入畫面開始時，遊戲沒有提供地圖"
L.RECORD_NO_POSITION = "載入畫面開始時，遊戲沒有提供位置"
L.RECORD_IN_DUNGEON_MAP = "載入畫面開始時位於地城的地圖上"
L.RECORD_LOG_COMBATLOG_ON = "戰鬥記錄已開啟：Logs\\%s。"
L.RECORD_LOG_COMBATLOG_OFF = "戰鬥記錄已關閉。"

L.LEVEL_RANGE = "等級%d-%d"
L.LEVEL_ALL = "所有等級"
L.LEVEL_BRACKET = "等級%d至%d"
L.TRASH_DROPS = "小怪掉落"
L.UNTESTED = "尚未測試"
L.UNTESTED_NOTE = "尚未測試：這裡的內容來自暴雪的公告，可能不完整。開啟「記錄」分頁並打完這個副本，即可補齊它的首領、戰利品與入口。"
L.COMING_SOON = "即將推出"
L.COMING_SOON_TEXT = "尚未在 WoW: Forever 開放。它的首領、戰利品與地圖會在玩家記錄進度後陸續加入。記錄過嗎？請貼到我們的 Discord，你的名字就會列入導覽的貢獻者名單。"
L.COMING_SOON_PARTLY = "尚未在 WoW: Forever 開放：這裡的內容來自暴雪的公告。記錄過一次進度嗎？請貼到我們的 Discord，你的名字就會列入導覽的貢獻者名單。"
L.DISCORD_COPY_HINT = "點擊後按 Ctrl+C"
L.FOREVER_MARK = "WoW: Forever 新增"
L.RECORD_LOG_VENDOR = "%s：保留了%d件商品，其中%d件是導覽沒有的。"
L.RECORD_CAUGHT = "已記錄%d項，自上次複製後新增%d項"
L.RECORD_COPY = "複製"
L.RECORD_AUTO = "在地城中自動記錄"
L.RECORD_AUTO_TIP = "進入地城或團隊副本時會自動開始記錄，離開時停止。你自己開始的記錄絕不會被自動停止。"
L.RECORD_RECORDER = "記錄器"
L.RECORD_SEND = "傳送給我們"
L.RECORD_HELP_TEXT = "按下「複製」，然後把文字貼到我們的 Discord："
L.RECORD_CREDIT = "署名為："
L.RECORD_CREDIT_TIP = "你的記錄在導覽貢獻者名單中使用的名字。留空則使用你的角色名稱。"
L.RECORD_CONTRIBUTORS = "貢獻者"
L.RECORD_CONTRIBUTORS_NONE = "還沒有人：成為第一位吧。"
L.RECORD_CONTRIBUTORS_FOOT = "傳送你的記錄：你的名字就會出現在這裡。"
L.RECORD_COPY_TITLE = "你的記錄（文字）"
L.RECORD_COPY_HINT = "已全部選取：按 Ctrl+C，然後貼到我們的 Discord。"
L.RECORD_COPY_HINT_LOG = "按 Ctrl+C，然後連同你的戰鬥記錄（%s，位於遊戲的 Logs 資料夾）一起貼到 Log Reader。再把它給出的結果貼到我們的 Discord。"
L.RECORD_MORE_LOGS = "%s 及另外%d個較舊的記錄"
L.RECORD_BACK = "返回"
L.RECORD_CAUGHT_TITLE = "你記錄到的內容"
L.RECORD_ITEM = "物品%s"
L.RECORD_ONE_VISIT = "1次造訪"
L.RECORD_VISITS = "%d次造訪"
L.RECORD_ENTRANCE_YES = "已記錄入口"
L.RECORD_ENTRANCE_NO = "尚未記錄入口"
L.RECORD_AREAS = "%d個區域"
L.RECORD_KILLED = "已擊殺：%s"
L.RECORD_KILLED_TIMES = "%s（%d）"
L.RECORD_DROPS = "掉落：%s件新物品，%s件已在導覽中"
L.RECORD_OFF = "來自%s"
L.RECORD_OFF_TRASH = "來自小怪"
L.RECORD_OFF_GROUP = "由你的隊伍拾取"
L.RECORD_QUESTS = "任務"
L.RECORD_QUEST_DONE = "已交付"
L.RECORD_NEW = "新"
L.RECORD_QUARTERMASTERS = "軍需官"
L.RECORD_WARES = "%s：%d件商品，%s件新增"
L.RECORD_TRAVEL = "旅行標記：%d"
L.FOREVER_LINE = "WoW: Forever 新增。"
L.LOCATION_LINE = "位置：%s"

L.TAB_OVERVIEW = OVERVIEW or "概述"
L.TAB_LOOT = LOOT_NOUN or "戰利品"
L.TAB_ABILITIES = ABILITIES or "技能"
L.TAB_MODEL = MODEL or "模型"
L.TAB_QUESTS = QUESTS_LABEL or "任務"
L.ALL_CLASSES = ALL_CLASSES or "所有職業"
L.ALL_ARMOR = "所有護甲"
L.ALL_TYPES = "所有類型"
-- The loot pages' Type menu: the kinds of item, "All ..." atop the two with a submenu, and one of each.
L.LOOT_KIND = {
	EQUIPMENT = "裝備", RECIPE = "配方", CONSUMABLE = "消耗品", MOUNT = "坐騎", PET = "寵物",
	TOY = "玩具", BAG = "背包", TRADE = "商品", QUEST = "任務物品", OTHER = "其他",
}
L.LOOT_KIND_ALL = { EQUIPMENT = "所有裝備", RECIPE = "所有配方" }
L.LOOT_KIND_ONE = { MOUNT = "坐騎", PET = "寵物", TOY = "玩具" }
L.LOOT_RECIPE = "配方"
L.LOOT_FAVORITES = "最愛"
L.LOOT_FAVORITES_ONLY = "只顯示最愛"
L.LOOT_FAVORITE = "加入最愛"
L.LOOT_UNFAVORITE = "從最愛中移除"
L.LOOT_PINNED = "已釘選"
L.LOOT_ALL = "戰利品"
L.LOOT_TRASH = "地城小怪"
L.LOOT_BOSS_LINE = BOSS_INFO_STRING or "首領：%s"
L.LOOT_FILTER_BAR = "過濾：%s"
L.LOOT_RETRIEVING = RETRIEVING_ITEM_INFO or "正在取得物品資訊"
L.LOOT_NO_DATA = "物品%d"
L.LOOT_NO_DATA_TOOLTIP = "伺服器尚未傳送此物品的詳細資料。它可能還沒加入遊戲。"
L.LOOT_UNIDENTIFIED_TOOLTIP = "尚未確認：來源提到了它的名稱，但沒有物品ID。在記錄時拾取它即可加入。"
L.LOOT_TOOLTIP_PIN = "右鍵點擊將此物品釘選到列表頂端。"
L.LOOT_TOOLTIP_UNPIN = "右鍵點擊取消釘選。"
L.LOOT_NONE = "目前尚不知道這裡的戰利品。"
L.LOOT_NO_MATCH = "沒有符合過濾條件的項目。點擊上方的X即可清除。"
L.ABILITY_LOADING = RETRIEVING_DATA or "正在取得資料..."
L.ABILITIES_NONE = "目前尚不知道此首領戰的任何技能。從「記錄」分頁記錄一次進度即可擷取。"
L.STATS_HIT = "每次命中%s"
L.STATS_TICK = "每跳%s"
L.STATS_FIRST = "第%d秒首次施放"
L.STATS_EVERY = "之後每%s秒一次"
L.QUEST_NONE = "目前不知道此地城有任何適合你陣營的任務。"
L.QUEST_STATUS_READY = "已完成：可以交付"
L.QUEST_STATUS_NEEDS = "需要：%s"
L.QUEST_STATUS_LEVEL = "需要等級%d"
L.QUEST_DESCRIPTION = QUEST_DESCRIPTION or "描述"
L.QUEST_START_ITEM = "起始於："
L.QUEST_PARTS = "%s（共%d部分）"
L.QUEST_PARTS_DONE = "此任務鏈已完成%d/%d部分。"
L.QUEST_SHOW_START = "顯示起點"
L.QUEST_SHOW_END = "顯示終點"
L.QUEST_PLACE_UNKNOWN = "地點尚不明。開著「記錄」分頁接取或交付此任務即可加入。"
L.QUESTMAP_DUNGEON_QUEST = "地城任務：%s"
L.QUESTMAP_RAID_QUEST = "團隊副本任務：%s"
L.QUESTMAP_LEFT_CLICK = "左鍵點擊以在導覽中開啟"
L.QUESTMAP_WAYPOINT_SET = "已為%s設定路徑點。"
L.QUESTMAP_ONE_OF = "並非總在同一處：是%d個地點之一。"
L.MAP_ONE_OF = "並非總在同一處：是%d個地點之一。"
L.QUEST_REWARDS = REWARDS or "獎勵"
L.QUEST_YOU_RECEIVE = YOU_RECEIVE or "你將得到："
L.QUEST_XP = "%s點經驗值"
L.QUEST_REPUTATION = "%d點%s聲望"
L.QUEST_CHOOSE = REWARD_CHOICES or "你可以從這些獎勵中選擇一個："
L.QUEST_ALSO = REWARD_ITEMS or "你還會得到："
L.REP_REWARDS = "%d項獎勵"
L.REP_REWARD_ONE = "1項獎勵"
L.REP_ALL_REWARDS = "獎勵"
L.REP_UNKNOWN = "未接觸"
L.REP_CARD_CLICK = "點擊查看其獎勵。"
L.REP_YOUR_STANDING = "你的聲望：%s"
L.REP_NOT_MET = "你尚未接觸這個陣營。"
L.REP_PROGRESS = "%s / %s"
L.REP_QUARTERMASTER = "軍需官：%s"
L.REP_CAPTURE = "擷取商人"
L.REP_CAPTURE_TIP = "走到聲望軍需官面前並打開他的商店，然後按下此按鈕。他販售的一切都會被保存：每件商品的價格、其他花費，以及所需的聲望等級。這些商品會立即加入該陣營的獎勵，並在你按下「記錄」分頁的「複製」時一併帶上。"
L.REP_CAPTURE_READY = "商店已開啟：請按「擷取商人」。"
L.REP_CAPTURE_HINT = "打開軍需官的商店以擷取他的商品。"
L.REP_CAPTURED = "%s：%d件商品屬於%s，其中%d件為新增。"
L.REP_CAPTURED_NONE = "%s：保留了%d件商品；沒有任何一件需要聲望等級。"
L.REP_CAPTURED_UNKNOWN = "%s：%d件商品需要某個遊戲未指明之陣營的聲望；會先保留，直到有商品指出該陣營。"
L.REP_NOT_CAPTURED = "尚未擷取"
L.REP_NOT_CAPTURED_TIP = "還沒有人擷取過這個陣營的軍需官。"
L.REP_NOT_CAPTURED_TEXT = "還沒有人擷取過這個陣營的軍需官。找到一位，打開他的商店並在「聲望」分頁按下「擷取商人」，然後把你的記錄貼到我們的 Discord。你的名字就會列入導覽的貢獻者名單。"
L.REP_LISTED_TIP = "它的獎勵來自遊戲的物品資料，尚未在軍需官處確認。"
L.REP_LISTED_TEXT = "這些獎勵來自遊戲的物品資料，而非軍需官，因此沒有價格，少數可能根本不販售。找到這個陣營的一位軍需官，打開他的商店並在「聲望」分頁按下「擷取商人」，然後把你的記錄貼到我們的 Discord。你的名字就會列入導覽的貢獻者名單。"
L.REP_COMING_SOON_TEXT = "WoW: Forever 新增，尚未擷取。等它加入遊戲後，找到它的軍需官，打開商店並在「聲望」分頁按下「擷取商人」，然後把你的記錄貼到我們的 Discord。"
L.MAP_SHOW = ENCOUNTER_JOURNAL_SHOW_MAP or "顯示地圖"
L.MAP_SHOW_UNEXPLORED = "顯示未探索區域"
L.MAP_PIN_OPEN = "點擊以在導覽中開啟。"
L.MAP_DEFEATED = DUNGEON_ENCOUNTER_DEFEATED or "已擊敗"
L.MAP_LEVEL = "等級%d"
L.MAP_FLOOR = "第%d層"
L.MAP_GO_TO = "前往%s"
L.MAP_YOU_ARE_HERE = "你在這裡"
L.ENTRANCE_DUNGEON = LFG_TYPE_DUNGEON or "地城"
L.ENTRANCE_RAID = LFG_TYPE_RAID or "團隊副本"
L.ENTRANCE_DUNGEONS = DUNGEONS or "地城"
L.ENTRANCE_RAIDS = RAIDS or "團隊副本"
L.ENTRANCE_LEFT_CLICK = "左鍵點擊以開啟副本導覽"
L.ENTRANCE_CHOOSE_LEFT_CLICK = "左鍵點擊以選擇要在副本導覽中開啟的項目"
L.ENTRANCE_RIGHT_CLICK = "右鍵點擊以設定路徑點"
L.ENTRANCE_WAYPOINT_SET = "已將路徑點設在%s的入口。"
L.ENTRANCE_VIA = "它的傳送門在下方的%s：請從洞穴入口往下走。"
L.ENTRANCE_WAYPOINT_VIA = "已將路徑點設在往下通往%s的路口，前往%s。"
L.CAVE_LABEL = "洞穴入口"
L.CAVE_LEADS_TO = "通往%s的路"
L.CAVE_LEFT_CLICK = "左鍵點擊查看%s的地圖"
L.CAVE_WAYPOINT_SET = "已將路徑點設在往下通往%s的路口。"
L.FLIGHT_POINT = MAP_LEGEND_FLIGHTPOINT or "飛行點"
L.CLICK_FOR_WAYPOINT = "點擊以設定路徑點"
L.FLIGHT_WAYPOINT_SET = "已將路徑點設在%s的飛行管理員。"
L.TRAVEL_KINDS = { boat = "船", zeppelin = "飛艇", airship = "飛船", tram = "地鐵", portal = "傳送門" }
L.TRAVEL_FACTIONS = { Alliance = FACTION_ALLIANCE or "聯盟", Horde = FACTION_HORDE or "部落" }
L.TRAVEL_ROUTE = "%s前往%s"
L.TRAVEL_AND = "%s和%s"
L.TRAVEL_ROUTE_NOTE = "%s：%s"
L.TRAVEL_HELP = "站在碼頭、飛艇塔、地鐵或傳送門旁，輸入 /aegis travel boat（或 zeppelin、airship、tram、portal），後面接上目的地，例如 /aegis travel boat Auberdine。在結尾加上 alliance、horde 或 neutral 表示它服務的對象，並可在括號中註明誰能搭乘，例如 /aegis travel portal Dalaran (Skyborne only)。/aegis travel list 顯示已儲存的項目；/aegis travel undo 撤銷最後一筆。"
L.TRAVEL_NO_POSITION = "遊戲在這裡不提供位置，因此沒有儲存任何內容。"
L.TRAVEL_SAVED = "已儲存%s，位於%s。/aegis travel undo 可撤銷。"
L.TRAVEL_UNDONE = "已撤銷%s（位於%s）。"
L.TRAVEL_NOTHING = "沒有可撤銷的項目。"
L.TRAVEL_LIST_EMPTY = "尚未儲存任何旅行地點。輸入 /aegis travel 查看方法。"
L.TRAVEL_LIST_LINE = "%d. %s，位於%s（地圖 %d，%.4f，%.4f）"
L.TRAVEL_WAYPOINT_SET = "已將路徑點設在%s。"
L.LEGEND_TRANSPORT = "交通工具"
L.LEGEND_TRANSPORT_TOOLTIP = "船、飛艇、地鐵與傳送門。藍色服務聯盟，紅色服務部落，金色服務所有人。"
L.LEGEND_CAVE_TOOLTIP = "進入洞穴，或往下通往區域下層的路。在地圖上點擊它即可查看通往何處。"
L.SEARCH_SHOW_ALL = SEARCH_RESULTS_SHOW_COUNT or "顯示全部%d個結果"
L.SEARCH_RESULTS = ENCOUNTER_JOURNAL_SEARCH_RESULTS or "「%s」的搜尋結果（%d）"
L.SEARCH_TYPE_BOSS = "首領戰"
L.SEARCH_TYPE_ABILITY = "技能"
L.SEARCH_TYPE_ITEM = "物品"
L.SEARCH_TYPE_QUEST = "任務"
L.SEARCH_TYPE_FACTION = FACTION or "陣營"
L.MAP_PIN_CLEAR = "點擊以移除此標記。"
L.MAP_PIN_COMBAT = "戰鬥中無法開啟地圖。"

L.RARE_SUFFIX = "（稀有）"
L.AND_MORE = "以及另外%d個"
L.BULLET_AREA = "位於%s。"
L.BULLET_RARE = "稀有怪：並非每次都會遇到。"
L.BULLET_LEVEL = "等級%d的首領戰。"
L.BULLET_ABILITIES = "曾見施放：%s。"
L.BULLET_LOOT = "掉落%d件物品，包括%s。"
L.BULLET_ADDS = "%s會加入戰鬥。"
L.ADD_DESCRIPTION = "與%s並肩作戰。"
L.BULLET_NOTHING_YET = "目前對此首領戰一無所知。"

-- The Traditional Chinese client's classic "Equip:" wordings (drafted; check against items in game).
L.EQUIP_PATTERNS = {
	{ "神聖.-致命一擊.-提高%s*{n}", "HOLY CRIT" },
	{ "法術.-致命一擊.-提高%s*{n}", "SPELL CRIT" },
	{ "遠程.-致命一擊.-提高%s*{n}", "RANGED CRIT" },
	{ "致命一擊.-提高%s*{n}", "CRIT" },
	{ "法術.-擊中目標.-提高%s*{n}", "SPELL HIT" },
	{ "法術.-命中.-提高%s*{n}", "SPELL HIT" },
	{ "擊中目標.-提高%s*{n}", "HIT" },
	{ "命中.-提高%s*{n}", "HIT" },
	{ "不死.-傷害", false },
	{ "惡魔.-傷害", false },
	{ "傷害.-治療.-{n}", { "SPELL POWER", "HEALING" } },
	{ "治療.-傷害.-{n}", { "SPELL POWER", "HEALING" } },
	{ "治療.-最多%s*{n}", "HEALING" },
	{ "治療.-提高%s*{n}", "HEALING" },
	{ "神聖.-傷害.-{n}", "HOLY DAMAGE" },
	{ "火焰.-傷害.-{n}", "FIRE DAMAGE" },
	{ "冰霜.-傷害.-{n}", "FROST DAMAGE" },
	{ "自然.-傷害.-{n}", "NATURE DAMAGE" },
	{ "暗影.-傷害.-{n}", "SHADOW DAMAGE" },
	{ "秘法.-傷害.-{n}", "ARCANE DAMAGE" },
	{ "法術.-傷害.-{n}", "SPELL DAMAGE" },
	{ "魔法.-傷害.-{n}", "SPELL DAMAGE" },
	{ "施法.-{n}%%.-法力", "CASTING REGEN" },
	{ "{n}%%.-法力.-施法", "CASTING REGEN" },
	{ "抗性.-降低%s*{n}", "SPELL PENETRATION" },
	{ "降低.-抗性.-{n}", "SPELL PENETRATION" },
	{ "不死.-攻擊強度", false },
	{ "惡魔.-攻擊強度", false },
	{ "野獸.-攻擊強度", false },
	{ "龍類.-攻擊強度", false },
	{ "作戰時.-攻擊強度", false },
	{ "攻擊強度.-作戰時", false },
	{ "戰鬥時.-攻擊強度", false },
	{ "攻擊強度.-戰鬥時", false },
	{ "%+%s*{n}%s*遠程攻擊強度", "RANGED ATTACK POWER" },
	{ "遠程攻擊強度.-{n}", "RANGED ATTACK POWER" },
	{ "豹.-攻擊強度.-{n}", "FERAL ATTACK POWER" },
	{ "攻擊強度.-{n}.-豹", "FERAL ATTACK POWER" },
	{ "{n}.-攻擊強度.-豹", "FERAL ATTACK POWER" },
	{ "攻擊強度.-提高%s*{n}", "ATTACK POWER" },
	{ "%+%s*{n}%s*攻擊強度", "ATTACK POWER" },
	{ "攻擊強度%s*%+%s*{n}", "ATTACK POWER" },
	{ "每%s*5%s*秒.-{n}.-法力", "MANA PER 5" },
	{ "{n}%s*點法力.-5%s*秒", "MANA PER 5" },
	{ "每%s*5%s*秒.-{n}.-生命", "HEALTH PER 5" },
	{ "恢復%s*{n}%s*點生命", "HEALTH PER 5" },
	{ "防禦.-提高%s*{n}", "DEFENSE" },
	{ "防禦.-%+%s*{n}", "DEFENSE" },
	{ "閃躲.-提高%s*{n}", "DODGE" },
	{ "躲閃.-提高%s*{n}", "DODGE" },
	{ "招架.-提高%s*{n}", "PARRY" },
	{ "格擋值.-提高%s*{n}", "BLOCK VALUE" },
	{ "格擋.-機率.-提高%s*{n}", "BLOCK" },
	{ "攻擊速度.-提高%s*{n}", "HASTE" },
}

-- The rooms inside dungeons, as the client names them where the player stands: "You are
-- here" and a wing's areas match these (Core/Areas.lua). Unconfirmed ones are listed in
-- the translation's to-check list.
L.AREA_NAMES = {
	["Aku'mai's Lair"] = "阿庫麥爾的巢穴",
	["Anvilmar's Rest"] = "安威瑪安息之所",
	["Athenaeum"] = "藏書室",
	["Blackrock Stadium"] = "黑石競技場",
	["Capital Gardens"] = "中央花園",
	["Cavern of Mists"] = "迷霧洞穴",
	["Chamber of Atonement"] = "贖罪之廳",
	["Chamber of Battle"] = "戰鬥之廳",
	["Chapel Gardens"] = "禮拜堂花園",
	["Court of the Highborne"] = "上層精靈庭院",
	["Crag of the Everliving"] = "永生者峭壁",
	["Crusader's Armory"] = "十字軍軍械庫",
	["Crusader's Chapel"] = "十字軍禮拜堂",
	["Crusaders' Square"] = "十字軍廣場",
	["Dark Iron Ingress"] = "黑鐵入口",
	["Defias Hideout"] = "迪菲亞藏身處",
	["Dragonspire Hall"] = "龍塔大廳",
	["Dreamer's Rock"] = "夢者之岩",
	["Elders' Square"] = "長者廣場",
	["Engineering Labs"] = "工程實驗室",
	["Festival Lane"] = "節日小徑",
	["Footman's Armory"] = "步兵軍械庫",
	["Forlorn Cloister"] = "荒涼迴廊",
	["Gallery of Treasures"] = "珍寶陳列室",
	["Goblin Foundry"] = "地精鑄造廠",
	["Gordok Commons"] = "戈多克議會",
	["Hall of Champions"] = "勇士大廳",
	["Halycon's Lair"] = "哈雷肯的巢穴",
	["Honor's Tomb"] = "榮譽之墓",
	["Hordemar City"] = "霍德瑪爾城",
	["Huntsman's Cloister"] = "獵手迴廊",
	["King's Square"] = "國王廣場",
	["Launch Bay"] = "發射台",
	["Market Row"] = "市場街",
	["Mast Room"] = "桅杆室",
	["Mok'Doom"] = "莫克杜姆",
	["Moonshrine Ruins"] = "月神殿廢墟",
	["Moonshrine Sanctum"] = "月神殿聖所",
	["Pit of Fangs"] = "尖牙之坑",
	["Prison of Immol'thar"] = "伊莫塔爾的監獄",
	["Reliquary of Kings"] = "諸王聖物室",
	["Screaming Gully"] = "尖嘯深谷",
	["Skitterweb Tunnels"] = "疾網隧道",
	["Slaughter Square"] = "屠殺廣場",
	["Tazz'Alaor"] = "塔薩拉爾",
	["Tazz'Alor"] = "塔薩拉爾",
	["The Clockwerk Run"] = "發條小徑",
	["The Dormitory"] = "宿舍",
	["The Drowned Sacellum"] = "沉沒聖堂",
	["The Forgotten Pool"] = "遺忘之池",
	["The Gauntlet"] = "試煉之路",
	["The Hall of Gears"] = "齒輪大廳",
	["The Hall of Lights"] = "光明大廳",
	["The High Seat"] = "王座",
	["The Hoard"] = "寶藏庫",
	["The Pool of Ask'ar"] = "阿斯卡之池",
	["The Rookery"] = "雛龍巢穴",
	["The Scarlet Bastion"] = "血色堡壘",
	["The Shrine of Eldretharr"] = "埃德雷斯神殿",
	["The Slaughter House"] = "屠宰場",
	["The Storehouse"] = "倉庫",
	["Tinkers' Court"] = "工匠議會",
	["Training Grounds"] = "訓練場",
	["Warpwood Quarter"] = "扭木廣場",
}
