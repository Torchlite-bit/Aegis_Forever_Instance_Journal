local _, ns = ...

--[[
	The journal's interface in Simplified Chinese, drafted by Claude for review by a native
	speaker, for a client set to Simplified Chinese (zhCN). It is laid over the English table
	(Locales/enUS.lua), so every file that already holds ns.L sees these strings, and anything not
	translated here stays English. Every other client skips it.
]]
-- The journal's words where it speaks this language; the tables matched against the client's own
-- text where the client does, previewed or not (ns.LocaleTargets, Locales/enUS.lua).
local L, client = ns.LocaleTargets("zhCN")
if not L then return end

L.JOURNAL_TITLE = "地下城手册"
L.HOME = HOME or "主页"
L.TAB_DUNGEONS = DUNGEONS or "地下城"
L.TAB_RAIDS = RAIDS or "团队副本"
L.TAB_REPUTATION = REPUTATION or "声望"

L.BINDING_TOGGLE = "打开/关闭地下城手册"
L.KEY_CLAIMED = "现在按Shift+J即可打开地下城手册。"
L.KEY_TAKEN = "Shift+J已绑定到%s。请在“按键设置 > 插件 > 打开/关闭地下城手册”中另选一个按键。"
L.POSITION_RESET = "窗口位置已重置。"
L.DOCK_ON = "窗口现在会在左上角打开，位于游戏自带窗口旁边。拖动它可以移动，直到关闭为止。"
L.DOCK_OFF = "窗口已恢复自由：它会在你上次拖动到的位置打开。"
L.DOCK_AFTER_COMBAT = "此项将在战斗结束后生效。"
L.SLASH_HELP = "/aegis（或 /ij）打开手册。/aegis record 开始或停止记录。/aegis reset 将窗口移回默认位置。/aegis perf 测量手册的内存占用和速度。/aegis where 和 /aegis taxi 报告你所在的位置和地图上的飞行点。/aegis travel 为世界地图保存一处船、飞艇、地铁或传送门。/aegis items 找出手册所列物品中服务器一无所知的那些。/aegis gear 打开装备查找器，/aegis weights 打开其属性权重；/aegis gearscan 保存它从你的装备中读取的内容，用于检查其评分。/aegis options 打开手册的选项。/aegis lang 以手册的另一种语言预览手册。"
L.LANG_USAGE = "/aegis lang de、fr、ru、cn、tw、es、mx、pt 或 ko 可在你下次 /reload 后以德语、法语、俄语、中文（简体或繁体）、西班牙语（西班牙或拉丁美洲）、巴西葡萄牙语或韩语显示手册，用于检查翻译；/aegis lang off 恢复为你客户端的语言。当前：%s。"
L.LANG_SET = "从你下次 /reload 起，手册将使用%s：只有手册自己的文字会改变，游戏本身的名称仍是你客户端的语言。现在输入 /reload；/aegis lang off 可恢复。"
L.LANG_OFF = "从你下次 /reload 起，手册将恢复使用你客户端的语言。现在输入 /reload。"
L.LANG_FONTS = "中文需要中文客户端的字体：在你的客户端上，部分文字可能无法显示。"
L.LANG_FONTS_KO = "韩语需要韩语客户端的字体：在你的客户端上，部分文字可能无法显示。"
L.LANG_ON = "正在以%s预览手册。/aegis lang off 可结束预览。"
L.LANG_UNAVAILABLE = "此客户端在读取已保存的设置之前就载入了手册，因此无法开始语言预览。"
L.AREAS_START = "正在为手册中的%d个区域名称查找其在客户端中的ID……"
L.AREAS_DONE = "已找到%d个区域名称的ID（共%d个）。输入/reload即可保存。"
L.AREAS_MISSING = "未找到：%s。"
L.AREAS_SCANNING = "仍在查找区域名称。"
L.AREAS_ENGLISH = "请在英文客户端上运行 /aegis areas：它查找的名称是英文的。"
L.ITEMS_START = "正在向服务器查询手册所列的%d件物品。大约%d秒后会有结果，你可以继续游戏。"
L.ITEMS_SCANNING = "仍在查询服务器，结果马上就到。"
L.ITEMS_DONE = "在%d件物品中，服务器对其中%d件一无所知：它们很可能尚未加入Forever。在服务器或一次记录下的通关确认之前，手册会隐藏它们。完整列表将在你下次/reload或登出时写入保存文件。"
L.ITEMS_LINE = "  物品%d：%s"
L.ITEMS_MORE = "  ……以及另外%d件。"
L.PERF_HEADER = "性能（内存单位为KB，时间单位为毫秒；越低越好）："
L.PERF_MEMORY = "  %s：%.0f KB"
L.PERF_TIME = "  %s：%.2f 毫秒"
L.PERF_BUILD = "首次打开（创建窗口）"
L.PERF_BOOK = "首次打开地下城（创建书页）"
L.PERF_OPEN = "打开并关闭手册"
L.PERF_DUNGEON = "打开地下城页面"
L.PERF_TAB = "切换到“%s”标签页"
L.PERF_FACTION = "打开阵营页面"
L.PERF_LOOT = "重绘战利品页面"
L.PERF_COMBAT = "测量将在你脱离战斗后进行。"
L.WHERE = "地图 %s（%s）  x %.4f  y %.4f  区域“%s”  小地图“%s”  高度 %s"
L.TAXI = "地图 %s  自带飞行点显示：%s  其上飞行点：%d（已发现%d）  %s"
L.TAXI_ATLASES = "交通图标：%s"
L.YES = YES or "是"
L.NO = NO or "否"

L.EMPTY_DUNGEONS = "还没有任何地下城的手册条目。"
L.EMPTY_RAIDS = "还没有任何团队副本的手册条目。"
L.EMPTY_REPUTATION = "尚无已知的阵营奖励。"
L.EMPTY_BRACKET = "此等级范围内没有内容。"

L.TAB_RECORD = "记录"
L.TAB_GEAR = "装备查找器"

-- The Gear Finder (Core/GearFinder.lua, UI/GearPanel.lua, UI/CharacterTab.lua).
L.GEAR_TITLE = "装备查找器"
L.GEAR_PREVIEW = "预览"
L.GEAR_NO_UPGRADE = "未找到提升"
L.GEAR_LOOKING = "正在%d个地下城中查找。"
L.GEAR_LOOKING_ONE = "正在1个地下城中查找。"
L.GEAR_LOADING = "还有%d件物品正在载入。"
L.GEAR_LOADING_ONE = "还有1件物品正在载入。"
L.GEAR_SCORING = "评分专精"
L.GEAR_AUTO = "自动：%s"
L.GEAR_WHY_TALENTS = "%s（天赋）"
L.GEAR_WHY_LEVELLING = "%s（练级）"
L.GEAR_SUGGESTED = "推荐地下城"
L.GEAR_UPGRADES_HERE = "此处有%d件提升"
L.GEAR_UPGRADE_HERE = "此处有1件提升"
L.GEAR_MORE_SLOTS = "另有%d个"
L.GEAR_DUNGEON_OF = "%d/%d"
L.GEAR_NONE = "你等级附近的地下城中没有提升。"
L.GEAR_TIP_CLICK = "点击查看其战利品；Shift+点击发送链接。"
L.GEAR_TIP_CELL_CLICK = "点击查看最佳提升；右键点击查看其战利品。"
L.GEAR_TIP_PICK_CLICK = "点击在此处显示它；右键点击查看其战利品。"
L.GEAR_TIP_PICKED = "你为此部位选定的装备。"
L.GEAR_PICK_TOP = "前%d件提升（共%d件）"
L.GEAR_PICK_ALL = "%d件提升"
L.GEAR_PICK_ONE = "唯一的提升"
L.GEAR_PICK_BIGGEST = "最大提升"
L.GEAR_PICK_YOURS = "你的选择"
L.GEAR_PICK_KEPT = "选择会为此角色保存。"
L.GEAR_PICK_CLEAR = "清除我的选择"
L.GEAR_TIP_NONE = "你等级附近的地下城中没有此部位的提升。"
L.GEAR_CHAR_BUTTON = "装备查找器"
L.GEAR_CHAR_BUTTON_TIP = "你的属性权重，以及手册所列地下城中等着你的最佳提升。"
L.GEAR_SCAN_DONE = "装备扫描已保存：%d件已穿戴物品和%d件地下城掉落。登出或输入/reload即可将其写入保存文件。"
L.GEAR_SCAN_ERRORS = "有%d件物品无法读取；出错信息已随扫描一同保存。"
L.GEAR_SCAN_LOADING = "部分掉落仍在载入：请等待几秒钟，然后再次输入/aegis gearscan以获取更多。"
L.GEAR_SLOT_FINGER1 = "手指1"
L.GEAR_SLOT_FINGER2 = "手指2"
L.GEAR_SLOT_TRINKET1 = "饰品1"
L.GEAR_SLOT_TRINKET2 = "饰品2"

-- Stat weights (Core/ItemScore.lua, UI/WeightsEditor.lua).
L.WEIGHTS_TITLE = "属性权重"
L.WEIGHTS_EDIT = "编辑属性权重…"
L.WEIGHTS_SOURCE_DEFAULT = "手册的权重"
L.WEIGHTS_SOURCE_LEVELLING = "手册的权重（练级时）"
L.WEIGHTS_SOURCE_CUSTOM = "你自己的权重"
L.WEIGHTS_SOURCE_PAWN = "你的权重，来自Pawn：%s"
L.WEIGHTS_TIP = "每一点属性对此专精的价值。点击一个权重即可修改；你自己的权重显示为绿色，并会为此角色保存。"
L.WEIGHTS_RESET = "重置"
L.WEIGHTS_RESET_TIP = "恢复为手册对此专精的权重。"
L.WEIGHTS_PAWN = "Pawn…"
L.WEIGHTS_PAWN_TIP = "从Pawn导入一个权重方案。"
L.WEIGHTS_PAWN_HELP = "在Pawn中选择权重方案，点击“导出”，复制文本，然后粘贴到这里。"
L.WEIGHTS_IMPORT = "导入"
L.WEIGHTS_CANCEL = "取消"
L.WEIGHTS_BACK = "返回"
L.WEIGHTS_OPEN_FINDER = "打开装备查找器"
L.WEIGHTS_IMPORTED = "已导入%d个权重，来自%s。"
L.WEIGHTS_UNUSED = "未使用：%s。"
L.WEIGHTS_NOT_PAWN = "这不是Pawn的权重方案。请在Pawn中点击“导出”并复制全部文本。"
L.WEIGHTS_OTHER_CLASS = "该权重方案适用于%s，而不是此角色的职业。"
L.WEIGHTS_FOR = "适用于"
-- The journal's page in the game's options (Options > AddOns).
L.OPTIONS_TITLE = "Aegis 地下城手册"
L.OPTIONS_BOSS_LEVELS = "在首领列表上显示首领等级"
L.OPTIONS_BOSS_LEVELS_TIP = "在每个首领的头像上显示其等级标记，颜色表示该首领对你的难度：灰色、绿色、黄色、橙色或红色。"
L.OPTIONS_ARROWS = "用绿色箭头标记提升"
L.OPTIONS_MINIMAP = "显示小地图按钮"
L.OPTIONS_PAWN_WEIGHTS = "在装备查找器中使用Pawn的属性权重"
L.OPTIONS_PAWN_WEIGHTS_TIP = "安装了Pawn时，显示的是它的物品鼠标提示和提升箭头。勾选：装备查找器用你专精的Pawn权重方案为物品评分。不勾选：Pawn改为显示手册对你专精的权重（作为手册的一个权重方案），并且在你勾选此项之前，Pawn自己的权重方案在此角色上会被隐藏。"
L.PAWN_ASK = "Pawn也已安装。将显示它的物品鼠标提示和提升箭头。\n\nPawn和装备查找器应共同使用谁的属性权重？\n\n手册的：Pawn为你的专精显示手册的权重，并在此角色上隐藏它自己的权重方案。\nPawn的：装备查找器使用你的Pawn权重方案。"
L.PAWN_USE_PAWN = "Pawn的"
L.PAWN_USE_JOURNAL = "手册的"
L.PAWN_SCALE = "手册：%s"
L.PAWN_RELOAD = "你的Baganator背包中Pawn的提升箭头只有在重载界面后才会改变：在你的装备改变之前，Baganator会一直沿用Pawn先前的结果。\n\n现在重载界面吗？"
L.PAWN_RELOAD_NOW = "重载界面"
L.PAWN_RELOAD_LATER = "稍后"
L.WEIGHTS_SOURCE_PAWN_LIVE = "Pawn的%s权重方案。可在Pawn中更改，或在手册的选项中改用手册的权重。"
L.OPTIONS_MINIMAP_TIP = "小地图边缘上的手册按钮：点击打开手册，右键点击打开这些选项，拖动可移动它。"
L.OPTIONS_DOCK = "将窗口停靠在左上角"
L.OPTIONS_DOCK_TIP = "勾选：手册会在屏幕左上角打开，也就是游戏打开自身窗口的位置；当那里打开游戏的某个窗口时，它会像游戏窗口之间那样让到一旁；如果放不下两个窗口，游戏会关闭较早打开的那个。拖动它可以移到任意位置：下次打开时会重新停靠。不勾选：它会在你上次拖动到的位置打开。"
L.MINIMAP_LEFT_CLICK = "点击打开或关闭手册。"
L.MINIMAP_RIGHT_CLICK = "右键点击打开其选项。"
L.MINIMAP_DRAG = "拖动可将它沿小地图边缘移动。"
L.OPTIONS_ARROWS_TIP = "按照装备查找器的计算，在对你的专精有提升的物品上显示绿色箭头：包括背包中、拾取窗口中和拾取掷骰时的物品。"
L.WEIGHTS_SHOW_GAINS = "在鼠标提示中显示属性权重"
L.WEIGHTS_SHOW_GAINS_TIP = "在每件物品下方，为你的每个专精显示一行：该物品按其权重计算的价值；如果它是提升，还会显示绿色箭头及其为你的装备增加的数值。对你的所有角色生效。安装了Pawn时，此项改为在Pawn中显示或隐藏手册的权重方案，并随之显示或隐藏Pawn按手册权重给出的提升箭头：Pawn只为它显示的权重方案标记提升。"
L.OPTIONS_SOURCES = "在鼠标提示中显示物品的掉落来源"
L.OPTIONS_SOURCES_TIP = "在手册中的地下城和团队副本掉落的每件物品下方，显示一行掉落它的首领和地下城：包括背包中、角色身上、聊天链接、商人处，以及游戏显示该物品的其他任何地方。对你的所有角色生效。"
L.GEAR_WHY_CUSTOM = "%s（你的权重）"
L.GEAR_SPEC_NAMES = {
	Arms = "武器", Fury = "狂怒", Protection = "防护", Holy = "神圣", Retribution = "惩戒",
	BeastMastery = "野兽控制", Marksmanship = "射击", Survival = "生存",
	Assassination = "刺杀", Combat = "战斗", Subtlety = "敏锐", Discipline = "戒律", Shadow = "暗影",
	Elemental = "元素", Enhancement = "增强", EnhancementTank = "增强（坦克）",
	Restoration = "恢复", Arcane = "奥术", Fire = "火焰", Frost = "冰霜", Affliction = "痛苦",
	Demonology = "恶魔学识", Destruction = "毁灭", Balance = "平衡", FeralBear = "野性战斗（熊）",
	FeralCat = "野性战斗（猫）",
}
L.GEAR_UNITS = {
	["attack power"] = "攻击强度", ["ranged attack power"] = "远程攻击强度",
	["spell damage"] = "法术伤害", healing = "治疗", Stamina = "耐力",
}
L.WEIGHT_GROUPS = {
	PRIMARY = "主要属性", WEAPONS = "武器", SPELLS = "法术", DEFENSE = "防御",
	RESISTANCE = "抗性",
}
L.STAT_NAMES = {
	STRENGTH = "力量", AGILITY = "敏捷", STAMINA = "耐力", INTELLECT = "智力", SPIRIT = "精神",
	DPS = "武器每秒伤害", ["RANGED DPS"] = "远程武器每秒伤害", ["ATTACK POWER"] = "攻击强度",
	["RANGED ATTACK POWER"] = "远程攻击强度", ["FERAL ATTACK POWER"] = "野性攻击强度", HIT = "命中",
	CRIT = "致命一击", ["RANGED CRIT"] = "远程致命一击", HASTE = "攻击速度", ["RANGED HASTE"] = "远程攻击速度",
	["SPELL POWER"] = "伤害和治疗", ["SPELL DAMAGE"] = "法术伤害", HEALING = "治疗", ["SPELL HIT"] = "法术命中",
	["SPELL CRIT"] = "法术致命一击", ["HOLY CRIT"] = "神圣法术致命一击", ["HOLY DAMAGE"] = "神圣伤害",
	["FIRE DAMAGE"] = "火焰伤害", ["FROST DAMAGE"] = "冰霜伤害", ["NATURE DAMAGE"] = "自然伤害",
	["SHADOW DAMAGE"] = "暗影伤害", ["ARCANE DAMAGE"] = "奥术伤害", ["SPELL PENETRATION"] = "法术穿透",
	MANA = "法力值", ["MANA PER 5"] = "每5秒法力值", ["CASTING REGEN"] = "施法时法力恢复",
	ARMOR = "护甲", HEALTH = "生命值", ["HEALTH PER 5"] = "每5秒生命值", DEFENSE = "防御", DODGE = "躲闪",
	PARRY = "招架", BLOCK = "格挡", ["BLOCK VALUE"] = "格挡值",
	["HOLY RESISTANCE"] = "神圣抗性", ["FIRE RESISTANCE"] = "火焰抗性",
	["NATURE RESISTANCE"] = "自然抗性", ["FROST RESISTANCE"] = "冰霜抗性",
	["SHADOW RESISTANCE"] = "暗影抗性", ["ARCANE RESISTANCE"] = "奥术抗性",
}
L.RECORD_START = "开始记录"
L.RECORD_STOP = "停止记录"
L.RECORD_CLEAR = "清除"
L.RECORD_CLEAR_CONFIRM = "丢弃目前记录的所有内容？此操作无法撤销。"
L.RECORD_STATUS_ON = "自%s起正在记录"
L.RECORD_STATUS_OFF = "未在记录"
L.RECORD_COMBATLOG = "在地下城中写入战斗记录"
L.RECORD_COMBATLOG_TIP = "首领技能来自游戏的战斗记录。手册会在地下城内开启它，并在离开时再次关闭；你自己开启的战斗记录不会受影响。要发送它，请在日志阅读器（Log Reader）页面上把日志文件添加到你的记录中（“复制”会显示链接）。"
L.RECORD_RECENT = "最近"
L.RECORD_NOTHING_YET = "尚未记录到任何内容。开启记录后进入地下城，然后像往常一样击杀、拾取和做任务。"
L.RECORD_STARTED = "记录已开始。/aegis record 可停止记录。"
L.RECORD_STOPPED = "记录已停止。"
L.RECORD_LOG_STARTED = "记录已开始。"
L.RECORD_LOG_STOPPED = "记录已停止。"
L.RECORD_LOG_CLEARED = "记录已清除。"
L.RECORD_LOG_ENTERED = "进入了%s。"
L.RECORD_LOG_LEFT = "离开了地下城。"
L.RECORD_LOG_AREA = "新区域：%s。"
L.RECORD_LOG_PULL = "开怪：%s。"
L.RECORD_LOG_KILL = "击杀了%s。"
L.RECORD_LOG_WIPE = "在%s处团灭。"
L.RECORD_LOG_LOOT = "战利品：%d件新物品。"
L.RECORD_LOG_QUEST_OFFERED = "可接任务：%s。"
L.RECORD_LOG_QUEST_DONE = "交付任务：%s。"
L.RECORD_LOG_ENTRANCE = "已记录%s的入口。"
L.RECORD_LOG_NO_ENTRANCE = "未记录%s的入口：%s。"
L.RECORD_NO_MAP = "载入画面开始时游戏未提供地图"
L.RECORD_NO_POSITION = "载入画面开始时游戏未提供位置"
L.RECORD_IN_DUNGEON_MAP = "载入画面开始时位于地下城的地图上"
L.RECORD_LOG_COMBATLOG_ON = "战斗记录已开启：Logs\\%s。"
L.RECORD_LOG_COMBATLOG_OFF = "战斗记录已关闭。"

L.LEVEL_RANGE = "等级%d-%d"
L.LEVEL_ALL = "所有等级"
L.LEVEL_BRACKET = "等级%d至%d"
L.TRASH_DROPS = "小怪掉落"
L.UNTESTED = "尚未测试"
L.UNTESTED_NOTE = "尚未测试：此处内容来自暴雪的公告，可能并不完整。在“记录”标签页开启记录后通关一次，即可补全其首领、战利品和入口。"
L.COMING_SOON = "即将开放"
L.COMING_SOON_TEXT = "尚未在WoW: Forever中开放。随着玩家记录他们的通关，其首领、战利品和地图会陆续加入。记录过一次？请发到我们的Discord，你的名字将列入手册的贡献者名单。"
L.COMING_SOON_PARTLY = "尚未在WoW: Forever中开放：此处内容来自暴雪的公告。记录过一次通关？请发到我们的Discord，你的名字将列入手册的贡献者名单。"
L.DISCORD_COPY_HINT = "点击，然后按Ctrl+C"
L.FOREVER_MARK = "WoW: Forever新增"
L.RECORD_LOG_VENDOR = "%s：保存了%d件商品，其中%d件是手册中没有的。"
L.RECORD_CAUGHT = "已记录%d项，自上次复制后新增%d项"
L.RECORD_COPY = "复制"
L.RECORD_AUTO = "在地下城中自动记录"
L.RECORD_AUTO_TIP = "进入地下城或团队副本时自动开始记录，离开时停止。你自己开始的记录永远不会被自动停止。"
L.RECORD_RECORDER = "记录器"
L.RECORD_SEND = "发送给我们"
L.RECORD_HELP_TEXT = "点击“复制”，然后将文本粘贴到我们的Discord："
L.RECORD_CREDIT = "署名："
L.RECORD_CREDIT_TIP = "你的记录在手册贡献者名单中使用的署名。留空则使用你的角色名。"
L.RECORD_CONTRIBUTORS = "贡献者"
L.RECORD_CONTRIBUTORS_NONE = "还没有人：来做第一个吧。"
L.RECORD_CONTRIBUTORS_FOOT = "发送你的记录：你的名字就会出现在这里。"
L.RECORD_COPY_TITLE = "你的记录（文本）"
L.RECORD_COPY_HINT = "已全部选中：按Ctrl+C，然后粘贴到我们的Discord。"
L.RECORD_COPY_HINT_LOG = "按Ctrl+C，然后将其与你的战斗记录（%s，位于游戏的Logs文件夹中）一起粘贴到日志阅读器。把得到的结果发到我们的Discord。"
L.RECORD_MORE_LOGS = "%s及另外%d个更早的"
L.RECORD_BACK = "返回"
L.RECORD_CAUGHT_TITLE = "你记录到的内容"
L.RECORD_ITEM = "物品%s"
L.RECORD_ONE_VISIT = "1次造访"
L.RECORD_VISITS = "%d次造访"
L.RECORD_ENTRANCE_YES = "入口已记录"
L.RECORD_ENTRANCE_NO = "入口尚未记录"
L.RECORD_AREAS = "%d个区域"
L.RECORD_KILLED = "击杀：%s"
L.RECORD_KILLED_TIMES = "%s（%d）"
L.RECORD_DROPS = "掉落：%s件新物品，%s件已在手册中"
L.RECORD_OFF = "来自%s"
L.RECORD_OFF_TRASH = "来自小怪"
L.RECORD_OFF_GROUP = "由你的队伍拾取"
L.RECORD_QUESTS = "任务"
L.RECORD_QUEST_DONE = "已交付"
L.RECORD_NEW = "新"
L.RECORD_QUARTERMASTERS = "军需官"
L.RECORD_WARES = "%s：%d件商品，%s件为新"
L.RECORD_TRAVEL = "交通标记：%d"
L.FOREVER_LINE = "WoW: Forever新增。"
L.LOCATION_LINE = "位置：%s"

L.TAB_OVERVIEW = OVERVIEW or "概述"
L.TAB_LOOT = LOOT_NOUN or "战利品"
L.TAB_ABILITIES = ABILITIES or "技能"
L.TAB_MODEL = MODEL or "模型"
L.TAB_QUESTS = QUESTS_LABEL or "任务"
L.ALL_CLASSES = ALL_CLASSES or "所有职业"
L.ALL_ARMOR = "所有护甲"
L.ALL_TYPES = "所有类型"
-- The loot pages' Type menu: the kinds of item, "All ..." atop the two with a submenu, and one of each.
L.LOOT_KIND = {
	EQUIPMENT = "装备", RECIPE = "配方", CONSUMABLE = "消耗品", MOUNT = "坐骑", PET = "宠物",
	TOY = "玩具", BAG = "容器", TRADE = "商品", QUEST = "任务物品", OTHER = "其它",
}
L.LOOT_KIND_ALL = { EQUIPMENT = "所有装备", RECIPE = "所有配方" }
L.LOOT_KIND_ONE = { MOUNT = "坐骑", PET = "宠物", TOY = "玩具" }
L.LOOT_RECIPE = "配方"
L.LOOT_FAVORITES = "收藏"
L.LOOT_FAVORITES_ONLY = "仅显示收藏"
L.LOOT_FAVORITE = "添加到收藏"
L.LOOT_UNFAVORITE = "从收藏中移除"
L.LOOT_PINNED = "已置顶"
L.LOOT_ALL = "战利品"
L.LOOT_TRASH = "地下城小怪"
L.DROPS_FROM_BOSS = "掉落自：%s（%s）"
L.DROPS_FROM_TRASH = "掉落自：小怪（%s）"
L.DROPS_FROM_BOSSES = "掉落自：%d个首领（%s）"
L.DROPS_IN = "掉落于：%s"
L.DROPS_ALSO_IN = "也掉落于：%s"
L.LEGEND_CLICK_HIDE = "点击在地图上隐藏这些标记。"
L.LEGEND_CLICK_SHOW = "已隐藏。点击在地图上重新显示这些标记。"
L.LEGEND_GAME_FILTER = "游戏自带的地图过滤器，与地图过滤菜单中的相同：进行中的任务和可交付的任务共用一个开关。"
L.PREPARE_TITLE = "出发之前"
L.PREPARE_PROGRESS = "你已完成%d个任务（共%d个）。"
L.PREPARE_HAVE = "你已拥有。"
L.PREPARE_QUEST_HINT = "点击在“任务”标签页中查看。"
L.QUESTS_DUNGEON = "地下城任务"
L.TRASH = "小怪"
L.TRASH_DESCRIPTION = "地下城中其他生物掉落的值得关注的物品：稀有和史诗装备、配方以及任务物品。"
L.LOOT_BOSS_LINE = BOSS_INFO_STRING or "首领：%s"
L.LOOT_FILTER_BAR = "过滤：%s"
L.LOOT_RETRIEVING = RETRIEVING_ITEM_INFO or "正在获取物品信息"
L.LOOT_NO_DATA = "物品%d"
L.LOOT_NO_DATA_TOOLTIP = "服务器尚未发送此物品的详细信息。它可能还没有加入游戏。"
L.LOOT_UNIDENTIFIED_TOOLTIP = "尚未确认：其来源给出了名称，但没有物品ID。在记录时拾取它即可添加。"
L.LOOT_TOOLTIP_PIN = "右键点击将此物品置顶到列表顶部。"
L.LOOT_TOOLTIP_UNPIN = "右键点击取消置顶。"
L.LOOT_NONE = "尚无已知的战利品。"
L.LOOT_NO_MATCH = "没有符合过滤条件的内容。点击上方的X清除过滤条件。"
L.ABILITY_LOADING = RETRIEVING_DATA or "正在获取数据……"
L.ABILITIES_NONE = "尚无此首领战的已知技能。在“记录”标签页中记录一次通关即可获取。"
L.STATS_HIT = "命中%s"
L.STATS_TICK = "每跳%s"
L.STATS_FIRST = "%d秒时首次施放"
L.STATS_EVERY = "之后每%s秒一次"
L.QUEST_NONE = "此地下城没有已知的你所在阵营的任务。"
L.QUEST_STATUS_READY = "已完成：可以交付"
L.QUEST_STATUS_NEEDS = "需要：%s"
L.QUEST_STATUS_LEVEL = "需要等级%d"
L.QUEST_DESCRIPTION = QUEST_DESCRIPTION or "描述"
L.QUEST_START_ITEM = "起始于："
L.QUEST_PARTS = "%s（共%d部分）"
L.QUEST_PARTS_DONE = "此任务链已完成%d/%d部分。"
L.QUEST_SHOW_START = "显示起点"
L.QUEST_SHOW_END = "显示终点"
L.QUEST_PLACE_UNKNOWN = "位置尚不明确。在“记录”标签页开启记录后接取或交付此任务，即可添加。"
L.QUEST_OFFERED_BY = "任务发布者：%s"
L.QUEST_HAND_IN_TO = "交还给：%s"
L.QUESTMAP_DUNGEON_QUEST = "地下城任务：%s"
L.QUESTMAP_RAID_QUEST = "团队副本任务：%s"
L.QUESTMAP_LEFT_CLICK = "左键点击在手册中打开"
L.QUESTMAP_WAYPOINT_SET = "已为%s设置路径点。"
L.QUESTMAP_ONE_OF = "位置并不固定：%d个地点之一。"
L.MAP_ONE_OF = "位置并不固定：%d个地点之一。"
L.QUEST_REWARDS = REWARDS or "奖励"
L.QUEST_YOU_RECEIVE = YOU_RECEIVE or "你将得到："
L.QUEST_XP = "%s点经验值"
L.QUEST_REPUTATION = "%d点%s声望"
L.QUEST_CHOOSE = REWARD_CHOICES or "你可以从这些奖励中选择一个："
L.QUEST_ALSO = REWARD_ITEMS or "你还将得到："
L.REP_REWARDS = "%d项奖励"
L.REP_REWARD_ONE = "1项奖励"
L.REP_ALL_REWARDS = "奖励"
L.REP_UNKNOWN = "尚未结识"
L.REP_CARD_CLICK = "点击查看其奖励。"
L.REP_YOUR_STANDING = "你的声望：%s"
L.REP_NOT_MET = "你还没有结识这个阵营。"
L.REP_PROGRESS = "%s / %s"
L.REP_QUARTERMASTER = "军需官：%s"
L.REP_CAPTURE = "记录商人"
L.REP_CAPTURE_TIP = "走到一位声望军需官面前并打开其商店，然后点击此按钮。其出售的所有商品都会被保存：每件商品的价格、任何其他花费以及所需的声望等级。这些商品会立即加入其阵营的奖励，并在你点击“记录”标签页上的“复制”时一并带上。"
L.REP_CAPTURE_READY = "商店已打开：点击“记录商人”。"
L.REP_CAPTURE_HINT = "打开军需官的商店以记录其商品。"
L.REP_CAPTURED = "%s：%d件商品，属于%s，新增%d件。"
L.REP_CAPTURED_NONE = "%s：保存了%d件商品；均不需要声望等级。"
L.REP_CAPTURED_UNKNOWN = "%s：%d件商品需要某个游戏未给出名称的阵营的声望；在有商品给出该阵营名称之前会暂时保存。"
L.REP_NOT_CAPTURED = "尚未记录"
L.REP_NOT_CAPTURED_TIP = "还没有人记录过这个阵营的军需官。"
L.REP_NOT_CAPTURED_TEXT = "还没有人记录过这个阵营的军需官。找到一位，打开其商店，在“声望”标签页上点击“记录商人”，然后把你的记录发到我们的Discord。你的名字将列入手册的贡献者名单。"
L.REP_LISTED_TIP = "其奖励来自游戏的物品数据，尚未在军需官处得到确认。"
L.REP_LISTED_TEXT = "这些奖励来自游戏的物品数据，而非军需官，因此没有价格，其中少数可能根本不出售。找到这个阵营的一位军需官，打开其商店，在“声望”标签页上点击“记录商人”，然后把你的记录发到我们的Discord。你的名字将列入手册的贡献者名单。"
L.REP_COMING_SOON_TEXT = "WoW: Forever新增，尚未记录。一旦它加入游戏，请找到其军需官，打开其商店，在“声望”标签页上点击“记录商人”，然后把你的记录发到我们的Discord。"
L.MAP_SHOW = ENCOUNTER_JOURNAL_SHOW_MAP or "显示地图"
L.MAP_SHOW_UNEXPLORED = "显示未探索区域"
L.MAP_FILTER_QUESTS = "可接任务"
L.MAP_FILTER_DUNGEONS = "地下城入口"
L.MAP_FILTER_RAIDS = "团队副本入口"
L.MAP_FILTER_FLIGHT = "飞行点"
L.MAP_FILTER_CAVES = "洞穴入口"
L.MAP_FILTER_TRANSPORT = "船、飞艇、地铁和传送门"
L.MAP_PIN_OPEN = "点击在手册中打开。"
L.MAP_DEFEATED = DUNGEON_ENCOUNTER_DEFEATED or "已击败"
L.MAP_LEVEL = "等级%d"
L.MAP_FLOOR = "第%d层"
L.MAP_GO_TO = "前往%s"
L.MAP_YOU_ARE_HERE = "你在这里"
L.ENTRANCE_DUNGEON = LFG_TYPE_DUNGEON or "地下城"
L.ENTRANCE_RAID = LFG_TYPE_RAID or "团队副本"
L.ENTRANCE_DUNGEONS = DUNGEONS or "地下城"
L.ENTRANCE_RAIDS = RAIDS or "团队副本"
L.ENTRANCE_LEFT_CLICK = "左键点击打开地下城手册"
L.ENTRANCE_CHOOSE_LEFT_CLICK = "左键点击选择一个在地下城手册中打开"
L.ENTRANCE_RIGHT_CLICK = "右键点击设置路径点"
L.ENTRANCE_WAYPOINT_SET = "已在%s的入口设置路径点。"
L.ENTRANCE_VIA = "它的传送门在下方的%s中：从洞穴入口下去。"
L.ENTRANCE_WAYPOINT_VIA = "已在进入%s的下行通道处设置路径点，用于前往%s。"
L.CAVE_LABEL = "洞穴入口"
L.BUILDING_LABEL = "入口"
L.ENTRANCE_VIA_BUILDING = "它的传送门在%s内部：从入口进入。"
L.CAVE_LEADS_TO = "通往%s的路"
L.CAVE_LEFT_CLICK = "左键点击查看%s的地图"
L.CAVE_WAYPOINT_SET = "已在进入%s的下行通道处设置路径点。"
L.FLIGHT_POINT = MAP_LEGEND_FLIGHTPOINT or "飞行点"
L.CLICK_FOR_WAYPOINT = "点击设置路径点"
L.FLIGHT_WAYPOINT_SET = "已在%s的飞行管理员处设置路径点。"
L.TRAVEL_KINDS = { boat = "船", zeppelin = "飞艇", airship = "飞空艇", tram = "地铁", portal = "传送门" }
L.TRAVEL_FACTIONS = { Alliance = FACTION_ALLIANCE or "联盟", Horde = FACTION_HORDE or "部落" }
L.TRAVEL_ROUTE = "%s前往%s"
L.TRAVEL_AND = "%s和%s"
L.TRAVEL_ROUTE_NOTE = "%s：%s"
L.TRAVEL_HELP = "站在码头、飞艇塔、地铁或传送门旁，输入 /aegis travel boat（或 zeppelin、airship、tram、portal），后面加上它的目的地，例如 /aegis travel boat Auberdine。在末尾加上 alliance、horde 或 neutral 来说明它为谁服务，并可在括号中注明谁可以乘坐，例如 /aegis travel portal Dalaran (Skyborne only)。/aegis travel list 显示已保存的内容；/aegis travel undo 撤销最后一个。"
L.TRAVEL_NO_POSITION = "游戏在这里没有提供位置，因此未保存任何内容。"
L.TRAVEL_SAVED = "已保存%s，位于%s。/aegis travel undo 可撤销。"
L.TRAVEL_UNDONE = "已撤销%s，位于%s。"
L.TRAVEL_NOTHING = "没有可撤销的内容。"
L.TRAVEL_LIST_EMPTY = "尚未保存任何交通地点。输入 /aegis travel 查看方法。"
L.TRAVEL_LIST_LINE = "%d. %s，位于%s（地图%d，%.4f，%.4f）"
L.TRAVEL_WAYPOINT_SET = "已在%s设置路径点。"
L.LEGEND_TRANSPORT = "交通"
L.LEGEND_TRANSPORT_TOOLTIP = "船、飞艇、地铁和传送门。蓝色为联盟服务，红色为部落服务，金色为所有人服务。"
L.LEGEND_CAVE_TOOLTIP = "进入洞穴的道路。在地图上点击它即可查看内部。"
L.LEGEND_BUILDING_TOOLTIP = "通往建筑、山中大厅或区域下层的道路，地下城的入口就在那里。在地图上点击它即可查看内部。"
L.SEARCH_SHOW_ALL = SEARCH_RESULTS_SHOW_COUNT or "显示全部%d个结果"
L.SEARCH_RESULTS = ENCOUNTER_JOURNAL_SEARCH_RESULTS or "“%s”的搜索结果（%d）"
L.SEARCH_TYPE_BOSS = "首领"
L.SEARCH_TYPE_ABILITY = "技能"
L.SEARCH_TYPE_ITEM = "物品"
L.SEARCH_TYPE_QUEST = "任务"
L.SEARCH_TYPE_FACTION = FACTION or "阵营"
L.MAP_PIN_CLEAR = "点击移除此标记。"
L.MAP_PIN_COMBAT = "战斗中无法打开地图。"

L.RARE_SUFFIX = "（稀有）"
L.AND_MORE = "以及另外%d个"
L.BULLET_AREA = "位于%s。"
L.BULLET_RARE = "稀有刷新：并非每次通关都能遇到。"
L.BULLET_SUMMONED = "需要你自己召唤的隐藏首领：召唤方法见上方说明。"
L.BULLET_LEVEL = "%d级首领战。"
L.BULLET_ABILITIES = "曾施放：%s。"
L.BULLET_LOOT = "掉落%d件物品，包括%s。"
L.BULLET_ADDS = "%s会加入战斗。"
L.ADD_DESCRIPTION = "在%s身旁作战。"
L.BULLET_NOTHING_YET = "尚无关于此首领战的任何已知信息。"

-- The Simplified Chinese client's classic "Equip:" wordings (drafted; check against items in game).
L.EQUIP_PATTERNS = {
	-- Bonuses against undead only, and effects on being struck or on a hit: worth nothing.
	{ "亡灵", false },
	{ "击中时", false },
	{ "神圣.-致命一击.-提高%s*{n}", "HOLY CRIT" },
	{ "法术.-致命一击.-提高%s*{n}", "SPELL CRIT" },
	{ "远程.-致命一击.-提高%s*{n}", "RANGED CRIT" },
	{ "致命一击.-提高%s*{n}", "CRIT" },
	{ "法术.-击中.-提高%s*{n}", "SPELL HIT" },
	{ "击中.-提高%s*{n}", "HIT" },
	{ "亡灵.-伤害", false },
	{ "恶魔.-伤害", false },
	{ "伤害和治疗.-最多%s*{n}", { "SPELL POWER", "HEALING" } },
	{ "治疗.-最多%s*{n}", "HEALING" },
	{ "神圣.-伤害.-最多%s*{n}", "HOLY DAMAGE" },
	{ "火焰.-伤害.-最多%s*{n}", "FIRE DAMAGE" },
	{ "冰霜.-伤害.-最多%s*{n}", "FROST DAMAGE" },
	{ "自然.-伤害.-最多%s*{n}", "NATURE DAMAGE" },
	{ "暗影.-伤害.-最多%s*{n}", "SHADOW DAMAGE" },
	{ "奥术.-伤害.-最多%s*{n}", "ARCANE DAMAGE" },
	{ "法术.-伤害.-最多%s*{n}", "SPELL DAMAGE" },
	{ "施法.-{n}%%.-法力", "CASTING REGEN" },
	{ "施放.-{n}%%.-法力", "CASTING REGEN" },
	{ "{n}%%.-法力.-施", "CASTING REGEN" },
	{ "抗性.-降低%s*{n}", "SPELL PENETRATION" },
	{ "降低.-抗性%s*{n}", "SPELL PENETRATION" },
	{ "作战时.-攻击强度", false },
	{ "攻击强度.-作战时", false },
	{ "战斗时.-攻击强度", false },
	{ "亡灵.-攻击强度", false },
	{ "恶魔.-攻击强度", false },
	{ "%+%s*{n}%s*远程攻击强度", "RANGED ATTACK POWER" },
	{ "远程攻击强度.-提高%s*{n}", "RANGED ATTACK POWER" },
	{ "猎豹.-攻击强度.-{n}", "FERAL ATTACK POWER" },
	{ "{n}.-攻击强度.-猎豹", "FERAL ATTACK POWER" },
	{ "攻击强度.-{n}.-猎豹", "FERAL ATTACK POWER" },
	{ "攻击强度.-提高%s*{n}", "ATTACK POWER" },
	{ "%+%s*{n}%s*攻击强度", "ATTACK POWER" },
	{ "每%s*5%s*秒.-{n}.-法力", "MANA PER 5" },
	{ "{n}%s*点法力.-5%s*秒", "MANA PER 5" },
	{ "每%s*5%s*秒.-{n}.-生命", "HEALTH PER 5" },
	{ "恢复%s*{n}%s*点生命", "HEALTH PER 5" },
	{ "防御.-提高%s*{n}", "DEFENSE" },
	{ "防御.-%+%s*{n}", "DEFENSE" },
	{ "躲闪.-提高%s*{n}", "DODGE" },
	{ "招架.-提高%s*{n}", "PARRY" },
	{ "格挡.-几率.-提高%s*{n}", "BLOCK" },
	{ "格挡值.-提高%s*{n}", "BLOCK VALUE" },
	{ "攻击速度.-提高%s*{n}", "HASTE" },
}

-- The rooms inside dungeons, as the client names them where the player stands: "You are
-- here" and a wing's areas match these (Core/Areas.lua). Unconfirmed ones are listed in
-- the translation's to-check list.
L.AREA_NAMES = {
	["Aku'mai's Lair"] = "阿库麦尔的巢穴",
	["Anvilmar's Rest"] = "安威玛尔安息之地",
	["Athenaeum"] = "藏书馆",
	["Blackrock Stadium"] = "黑石竞技场",
	["Capital Gardens"] = "中心花园",
	["Cavern of Mists"] = "迷雾洞穴",
	["Chamber of Atonement"] = "赎罪大厅",
	["Chamber of Battle"] = "战斗大厅",
	["Chapel Gardens"] = "礼拜堂花园",
	["Court of the Highborne"] = "上层精灵庭院",
	["Crag of the Everliving"] = "永生者峭壁",
	["Crusader's Armory"] = "十字军军械库",
	["Crusader's Chapel"] = "十字军礼拜堂",
	["Crusaders' Square"] = "十字军广场",
	["Dark Iron Ingress"] = "黑铁入口",
	["Defias Hideout"] = "迪菲亚藏身处",
	["Dragonspire Hall"] = "龙塔大厅",
	["Dreamer's Rock"] = "沉睡者之岩",
	["Elders' Square"] = "长者广场",
	["Engineering Labs"] = "工程实验室",
	["Festival Lane"] = "节日小道",
	["Footman's Armory"] = "步兵军械库",
	["Forlorn Cloister"] = "荒凉回廊",
	["Gallery of Treasures"] = "珍宝陈列馆",
	["Goblin Foundry"] = "地精铸造厂",
	["Gordok Commons"] = "戈多克议会",
	["Hall of Champions"] = "勇士大厅",
	["Halycon's Lair"] = "哈雷肯的巢穴",
	["Honor's Tomb"] = "荣誉之墓",
	["Hordemar City"] = "霍德玛尔城",
	["Huntsman's Cloister"] = "猎手回廊",
	["Ironforge"] = "铁炉堡",
	["King's Square"] = "国王广场",
	["Launch Bay"] = "发射台",
	["Market Row"] = "市场街",
	["Mast Room"] = "桅杆室",
	["Mok'Doom"] = "莫克杜姆",
	["Moonshrine Ruins"] = "月神殿废墟",
	["Moonshrine Sanctum"] = "月神圣殿",
	["Pit of Fangs"] = "尖牙之坑",
	["Prison of Immol'thar"] = "伊莫塔尔的监牢",
	["Reliquary of Kings"] = "诸王圣物堂",
	["Screaming Gully"] = "尖啸沟壑",
	["Skitterweb Tunnels"] = "蛛网隧道",
	["Slaughter Square"] = "屠杀广场",
	["Tazz'Alaor"] = "塔萨洛尔",
	["Tazz'Alor"] = "塔萨洛尔",
	["The Clockwerk Run"] = "发条小径",
	["The Dormitory"] = "宿舍",
	["The Drowned Sacellum"] = "沉没圣祠",
	["The Forgotten Pool"] = "被遗忘的池塘",
	["The Gauntlet"] = "试炼之路",
	["The Hall of Gears"] = "齿轮大厅",
	["The Hall of Lights"] = "圣光大厅",
	["The High Seat"] = "王座大厅",
	["The Hoard"] = "宝库",
	["The Pool of Ask'ar"] = "阿斯卡之池",
	["The Rookery"] = "孵化室",
	["The Scarlet Bastion"] = "血色堡垒",
	["The Shrine of Eldretharr"] = "埃德雷萨之祠",
	["The Slaughter House"] = "屠宰场",
	["The Storehouse"] = "仓库",
	["Tinkers' Court"] = "工匠议会",
	["Training Grounds"] = "训练场",
	["Warpwood Quarter"] = "扭木广场",
}

-- Matched against the client's own text: the client's language's only, previewed or not.
if client then client.EQUIP_PATTERNS, client.AREA_NAMES = L.EQUIP_PATTERNS, L.AREA_NAMES end
L.EQUIP_PATTERNS, L.AREA_NAMES = nil, nil
