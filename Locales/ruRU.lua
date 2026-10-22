local _, ns = ...

--[[
	The journal's interface in Russian, by Staree4ok, for a client set to Russian. It is laid over
	the English table (Locales/enUS.lua), so every file that already holds ns.L sees these
	strings, and anything not translated here stays English. Every other client skips it.
]]
-- The journal's words where it speaks this language; the tables matched against the client's own
-- text where the client does, previewed or not (ns.LocaleTargets, Locales/enUS.lua).
local L, client = ns.LocaleTargets("ruRU")
if not L then return end

L.JOURNAL_TITLE = "Путеводитель по подземельям"
L.HOME = HOME or "Главная"
L.TAB_DUNGEONS = DUNGEONS or "Подземелья"
L.TAB_RAIDS = RAIDS or "Рейды"
L.TAB_REPUTATION = REPUTATION or "Репутация"

L.BINDING_TOGGLE = "Открыть путеводитель по подземельям"
L.KEY_CLAIMED = "Shift+J теперь открывает путеводитель по подземельям."
L.KEY_TAKEN = "Shift+J уже назначена на %s. Выберите клавишу в Назначение клавиш > Модификации > Открыть путеводитель по подземельям."
L.POSITION_RESET = "Положение окна сброшено."
L.DOCK_ON = "Теперь окно открывается в левом верхнем углу, рядом с окнами игры. Перетащите его, чтобы переместить до закрытия."
L.DOCK_OFF = "Окно снова свободно: оно открывается там, куда вы перетащили его в последний раз."
L.DOCK_AFTER_COMBAT = "Это вступит в силу после окончания боя."
L.SLASH_HELP = "/aegis (или /ij) открывает путеводитель. /aegis record включает или выключает запись. /aegis reset возвращает окно на место по умолчанию. /aegis perf измеряет память и скорость путеводителя. /aegis where и /aegis taxi показывают, где вы стоите и точки полетов на карте. /aegis travel сохраняет корабль, дирижабль, подземку или портал для карты мира. /aegis items находит предметы из списка, о которых сервер ничего не знает. /aegis gear открывает поиск снаряжения, /aegis weights — настройку приоритетов характеристик; /aegis gearscan сохраняет данные экипировки для проверки расчета улучшений."
L.LANG_USAGE = "/aegis lang de, fr, ru, cn, tw, es, mx, pt или ko показывает путеводитель на немецком, французском, русском, китайском (упрощённом или традиционном), испанском (Испания или Латинская Америка), бразильском португальском или корейском после следующего /reload, чтобы проверить перевод; /aegis lang off возвращает язык вашего клиента. Сейчас: %s."
L.LANG_SET = "После следующего /reload путеводитель перейдёт на язык %s — только его собственные тексты: названия из самой игры останутся на языке вашего клиента. Введите /reload сейчас; /aegis lang off вернёт всё как было."
L.LANG_OFF = "После следующего /reload путеводитель снова будет на языке вашего клиента. Введите /reload сейчас."
L.LANG_FONTS = "Для китайского нужны шрифты китайского клиента: в вашем часть символов может не отображаться."
L.LANG_FONTS_KO = "Для корейского нужны шрифты корейского клиента: в вашем часть символов может не отображаться."
L.LANG_ON = "Предпросмотр путеводителя на языке %s. /aegis lang off завершает его."
L.LANG_UNAVAILABLE = "Этот клиент загрузил путеводитель раньше его сохранённых настроек, поэтому предпросмотр языка не удалось запустить."
L.AREAS_START = "Поиск в клиенте идентификаторов для %d названий зон журнала..."
L.AREAS_DONE = "Найдены идентификаторы %d из %d названий зон. Введите /reload, чтобы сохранить их."
L.AREAS_MISSING = "Не найдено: %s."
L.AREAS_SCANNING = "Поиск названий зон еще не завершен."
L.AREAS_ENGLISH = "Запустите /aegis areas в английском клиенте: команда ищет английские названия."
L.OPTIONS_TITLE = "Aegis Instance Journal"
L.OPTIONS_BOSS_LEVELS = "Показывать уровни боссов в списке боссов"
L.OPTIONS_BOSS_LEVELS_TIP = "Значок с уровнем на портрете каждого босса, окрашенный по тому, насколько босс для вас сложен: серый, зелёный, жёлтый, оранжевый или красный."
L.OPTIONS_ARROWS = "Отмечать улучшения зелёной стрелкой"
L.OPTIONS_MINIMAP = "Показывать кнопку у миникарты"
L.OPTIONS_PAWN_WEIGHTS = "Использовать приоритет характеристик из Pawn в поиске снаряжения"
L.OPTIONS_PAWN_WEIGHTS_TIP = "Если установлен Pawn, показываются его подсказки к предметам и стрелки улучшений. Флажок установлен: поиск снаряжения оценивает предметы по вашей шкале Pawn для вашей специализации. Флажок снят: Pawn вместо этого показывает приоритет журнала для вашей специализации в виде шкалы журнала, а его собственные шкалы скрыты на этом персонаже, пока вы не установите флажок."
L.PAWN_ASK = "Также установлен Pawn. Будут показываться его подсказки к предметам и стрелки улучшений.\n\nОткуда Pawn и поиску снаряжения брать приоритет характеристик?\n\nИз журнала: Pawn показывает его для вашей специализации и скрывает свои шкалы на этом персонаже.\nИз Pawn: поиск снаряжения использует ваши шкалы Pawn."
L.PAWN_USE_PAWN = "Из Pawn"
L.PAWN_USE_JOURNAL = "Из журнала"
L.PAWN_SCALE = "Журнал: %s"
L.PAWN_RELOAD = "Стрелки улучшений Pawn в сумках Baganator изменятся только после перезагрузки: Baganator хранит ответы Pawn, пока не сменится ваше снаряжение.\n\nПерезагрузить сейчас?"
L.PAWN_RELOAD_NOW = "Перезагрузить"
L.PAWN_RELOAD_LATER = "Позже"
L.WEIGHTS_SOURCE_PAWN_LIVE = "Шкала Pawn «%s». Измените её в Pawn или выберите в настройках приоритет журнала."
L.OPTIONS_MINIMAP_TIP = "Кнопка путеводителя на краю миникарты: ЛКМ открывает путеводитель, ПКМ — эти настройки, перетаскивание перемещает кнопку."
L.OPTIONS_DOCK = "Закрепить окно в левом верхнем углу"
L.OPTIONS_DOCK_TIP = "Включено: путеводитель открывается в левом верхнем углу экрана, там, где игра открывает свои окна, и сдвигается, когда там открывается одно из них, как они делают друг для друга; если места для обоих нет, игра закрывает более старое. Перетащите его, чтобы переместить куда угодно: при следующем открытии он снова закрепится. Выключено: он открывается там, куда вы перетащили его в последний раз."
L.MINIMAP_LEFT_CLICK = "ЛКМ — открыть или закрыть путеводитель."
L.MINIMAP_RIGHT_CLICK = "ПКМ — настройки."
L.MINIMAP_DRAG = "Перетащите, чтобы передвинуть кнопку вдоль миникарты."
L.OPTIONS_ARROWS_TIP = "Зелёная стрелка на предметах, которые по расчёту поиска снаряжения являются улучшениями для вашей специализации: в сумках, в окне добычи и при розыгрыше добычи."
L.WEIGHTS_SHOW_GAINS = "Показывать приоритет характеристик в подсказках"
L.WEIGHTS_SHOW_GAINS_TIP = "Под каждым предметом — строка для каждой вашей специализации: сколько стоит предмет по её приоритету и, если это улучшение, зелёная стрелка с тем, что он добавит к вашему снаряжению. Для всех ваших персонажей. Если установлен Pawn, этот флажок вместо этого показывает или скрывает шкалу журнала в Pawn, а вместе с ней стрелки улучшений Pawn по приоритету журнала: Pawn отмечает улучшения только для тех шкал, которые показывает."
L.OPTIONS_SOURCES = "Показывать в подсказках, где добывается предмет"
L.OPTIONS_SOURCES_TIP = "Под каждым предметом, который добывается в подземельях и рейдах путеводителя, — строка с боссом и подземельем: в сумках, на персонаже, в ссылках в чате, у торговцев и везде, где игра показывает предмет. Для всех ваших персонажей."
L.ITEMS_START = "Запрос к серверу о %d предметах из списка путеводителя. Ответ придет примерно через %d сек.; можете продолжать игру."
L.ITEMS_SCANNING = "Ожидание ответа от сервера; данные появятся через секунду."
L.ITEMS_DONE = "Из %d предметов сервер ничего не знает о %d: скорее всего, их еще нет на сервере Forever. Путеводитель скрывает их, пока сервер или записанное прохождение не подтвердят их наличие. Полный список будет сохранен в файл при следующем /reload или выходе из игры."
L.ITEMS_LINE = "  Предмет %d: %s"
L.ITEMS_MORE = "  ...и еще %d."
L.PERF_HEADER = "Производительность (память в КБ, время в миллисекундах; чем меньше, тем лучше):"
L.PERF_MEMORY = "  %s: %.0f КБ"
L.PERF_TIME = "  %s: %.2f мс"
L.PERF_BUILD = "Первое открытие (создание окна)"
L.PERF_BOOK = "Первое открытое подземелье (создание книги)"
L.PERF_OPEN = "Открыть и закрыть путеводитель"
L.PERF_DUNGEON = "Открыть страницу подземелья"
L.PERF_TAB = "Переключиться на вкладку %s"
L.PERF_FACTION = "Открыть страницу фракции"
L.PERF_LOOT = "Перерисовать страницу добычи"
L.PERF_COMBAT = "Измерение отложено, пока вы не выйдете из боя."
L.WHERE = "Карта %s (%s)  x %.4f  y %.4f  зона \"%s\"  миникарта \"%s\"  высота %s"
L.TAXI = "Карта %s  сама показывает точки полетов: %s  точек на ней: %d (%d открыто)  %s"
L.TAXI_ATLASES = "Иконки перемещения: %s"
L.YES = YES or "да"
L.NO = NO or "нет"

L.EMPTY_DUNGEONS = "Для подземелий пока нет записей в путеводителе."
L.EMPTY_RAIDS = "Для рейдов пока нет записей в путеводителе."
L.EMPTY_REPUTATION = "Награды за репутацию пока неизвестны."
L.EMPTY_BRACKET = "Ничего нет для этого диапазона уровней."

L.TAB_RECORD = "Запись"
L.TAB_GEAR = "Поиск снаряжения"

-- The Gear Finder (Core/GearFinder.lua, UI/GearPanel.lua, UI/CharacterTab.lua).
L.GEAR_TITLE = "Поиск снаряжения"
L.GEAR_PREVIEW = "Просмотр"
L.GEAR_NO_UPGRADE = "Улучшений не найдено"
L.GEAR_LOOKING = "Поиск в подземельях: %d."
L.GEAR_LOOKING_ONE = "Поиск в 1 подземелье."
L.GEAR_LOADING = "Загружается предметов: %d."
L.GEAR_LOADING_ONE = "Загружается 1 предмет."
L.GEAR_SCORING = "Расчёт для"
L.GEAR_AUTO = "Автоматически: %s"
L.GEAR_WHY_TALENTS = "%s (таланты)"
L.GEAR_WHY_LEVELLING = "%s (прокачка)"
L.GEAR_SUGGESTED = "Рекомендуем"
L.GEAR_UPGRADES_HERE = "Улучшений здесь: %d"
L.GEAR_UPGRADE_HERE = "1 улучшение здесь"
L.GEAR_MORE_SLOTS = "и ещё %d"
L.GEAR_DUNGEON_OF = "%d из %d"
L.GEAR_NONE = "В подземельях вашего уровня улучшений нет."
L.GEAR_TIP_CLICK = "ЛКМ — открыть добычу в журнале; Shift+ЛКМ — вставить ссылку."
L.GEAR_TIP_CELL_CLICK = "ЛКМ — лучшие улучшения; ПКМ — открыть добычу."
L.GEAR_TIP_PICK_CLICK = "ЛКМ — показать здесь; ПКМ — открыть добычу."
L.GEAR_TIP_PICKED = "Ваш выбор для этого слота."
L.GEAR_PICK_TOP = "Лучшие %d из %d улучшений"
L.GEAR_PICK_ALL = "Улучшений: %d"
L.GEAR_PICK_ONE = "Единственное улучшение"
L.GEAR_PICK_BIGGEST = "Наибольшее"
L.GEAR_PICK_YOURS = "Ваш выбор"
L.GEAR_PICK_KEPT = "Выбор сохраняется для этого персонажа."
L.GEAR_PICK_CLEAR = "Сбросить мой выбор"
L.GEAR_TIP_NONE = "Для этого слота нет улучшений в подземельях вашего уровня."
L.GEAR_CHAR_BUTTON = "Поиск снаряжения"
L.GEAR_CHAR_BUTTON_TIP = "Ваш приоритет характеристик и лучшие улучшения в подземельях журнала."
L.GEAR_SCAN_DONE = "Сканирование сохранено: %d надетых предметов и %d предметов из подземелий. Выйдите из игры или введите /reload, чтобы записать файл."
L.GEAR_SCAN_ERRORS = "Не удалось прочитать предметов: %d. Подробности сохранены вместе со сканом."
L.GEAR_SCAN_LOADING = "Часть добычи ещё загружается: подождите несколько секунд и снова введите /aegis gearscan."
L.GEAR_SLOT_FINGER1 = "Кольцо 1"
L.GEAR_SLOT_FINGER2 = "Кольцо 2"
L.GEAR_SLOT_TRINKET1 = "Аксессуар 1"
L.GEAR_SLOT_TRINKET2 = "Аксессуар 2"

-- Stat weights (Core/ItemScore.lua, UI/WeightsEditor.lua).
L.WEIGHTS_TITLE = "Приоритет характеристик"
L.WEIGHTS_EDIT = "Изменить приоритет характеристик..."
L.WEIGHTS_SOURCE_DEFAULT = "Приоритет из журнала"
L.WEIGHTS_SOURCE_LEVELLING = "Приоритет из журнала (при прокачке)"
L.WEIGHTS_SOURCE_CUSTOM = "Ваш собственный приоритет"
L.WEIGHTS_SOURCE_PAWN = "Ваш приоритет из Pawn: %s"
L.WEIGHTS_TIP = "Насколько важна 1 единица каждой характеристики для этой специализации. Нажмите на значение, чтобы изменить его; собственные значения отображаются зелёным и сохраняются для этого персонажа."
L.WEIGHTS_RESET = "Сброс"
L.WEIGHTS_RESET_TIP = "Вернуть приоритет журнала для этой специализации."
L.WEIGHTS_PAWN = "Pawn..."
L.WEIGHTS_PAWN_TIP = "Импортировать приоритет из Pawn."
L.WEIGHTS_PAWN_HELP = "В Pawn откройте вкладку «Весы», выберите шкалу, нажмите «Экспорт», скопируйте текст и вставьте его сюда."
L.WEIGHTS_IMPORT = "Импорт"
L.WEIGHTS_CANCEL = "Отмена"
L.WEIGHTS_BACK = "Назад"
L.WEIGHTS_OPEN_FINDER = "Открыть поиск снаряжения"
L.WEIGHTS_IMPORTED = "Импортировано значений: %d из %s."
L.WEIGHTS_UNUSED = "Не использовано: %s."
L.WEIGHTS_NOT_PAWN = "Это не шкала Pawn. В Pawn выберите «Экспорт» и скопируйте весь текст."
L.WEIGHTS_OTHER_CLASS = "Эта шкала для класса %s, а не для класса этого персонажа."
L.WEIGHTS_FOR = "Для"
L.GEAR_WHY_CUSTOM = "%s (ваш приоритет)"
L.WEIGHT_GROUPS = {
	PRIMARY = "Основные характеристики", WEAPONS = "Оружие", SPELLS = "Заклинания", DEFENSE = "Защита",
	RESISTANCE = "Сопротивления",
}
L.STAT_NAMES = {
	STRENGTH = "Сила", AGILITY = "Ловкость", STAMINA = "Выносливость", INTELLECT = "Интеллект", SPIRIT = "Дух",
	DPS = "Урон оружием в сек.", ["RANGED DPS"] = "Урон дальнего оружия в сек.", ["ATTACK POWER"] = "Сила атаки",
	["RANGED ATTACK POWER"] = "Сила атаки дальнего боя", ["FERAL ATTACK POWER"] = "Сила атаки в облике зверя", HIT = "Меткость",
	CRIT = "Критический удар", ["RANGED CRIT"] = "Критический удар дальнего боя", HASTE = "Скорость атаки", ["RANGED HASTE"] = "Скорость дальнего боя",
	["SPELL POWER"] = "Урон и исцеление", ["SPELL DAMAGE"] = "Урон от заклинаний", HEALING = "Исцеление", ["SPELL HIT"] = "Меткость заклинаний",
	["SPELL CRIT"] = "Критический удар заклинаний", ["HOLY CRIT"] = "Критический удар светлой магии", ["HOLY DAMAGE"] = "Урон от светлой магии",
	["FIRE DAMAGE"] = "Урон от огня", ["FROST DAMAGE"] = "Урон от магии льда", ["NATURE DAMAGE"] = "Урон от сил природы",
	["SHADOW DAMAGE"] = "Урон от тёмной магии", ["ARCANE DAMAGE"] = "Урон от тайной магии", ["SPELL PENETRATION"] = "Проникающая способность заклинаний",
	MANA = "Мана", ["MANA PER 5"] = "Мана за 5 сек.", ["CASTING REGEN"] = "Восстановление при чтении",
	ARMOR = "Броня", HEALTH = "Здоровье", ["HEALTH PER 5"] = "Здоровье за 5 сек.", DEFENSE = "Защита", DODGE = "Уклонение",
	PARRY = "Парирование", BLOCK = "Блок", ["BLOCK VALUE"] = "Показатель блока",
	["HOLY RESISTANCE"] = "Сопротивление светлой магии", ["FIRE RESISTANCE"] = "Сопротивление огню",
	["NATURE RESISTANCE"] = "Сопротивление силам природы", ["FROST RESISTANCE"] = "Сопротивление магии льда",
	["SHADOW RESISTANCE"] = "Сопротивление тёмной магии", ["ARCANE RESISTANCE"] = "Сопротивление тайной магии",
}
L.GEAR_SPEC_NAMES = {
	Arms = "Оружие", Fury = "Неистовство", Protection = "Защита", Holy = "Свет", Retribution = "Возмездие",
	BeastMastery = "Повелитель зверей", Marksmanship = "Стрельба", Survival = "Выживание",
	Assassination = "Убийство", Combat = "Бой", Subtlety = "Скрытность", Discipline = "Послушание", Shadow = "Тьма",
	Elemental = "Стихии", Enhancement = "Совершенствование", EnhancementTank = "Совершенствование (танк)",
	Restoration = "Исцеление", Arcane = "Тайная магия", Fire = "Огонь", Frost = "Лед", Affliction = "Колдовство",
	Demonology = "Демонология", Destruction = "Разрушение", Balance = "Баланс", FeralBear = "Сила зверя (медведь)",
	FeralCat = "Сила зверя (кошка)",
}
L.GEAR_UNITS = {
	["attack power"] = "сила атаки", ["ranged attack power"] = "сила атаки дальнего боя",
	["spell damage"] = "урон от заклинаний", healing = "исцеление", Stamina = "выносливость",
}
L.RECORD_START = "Начать запись"
L.RECORD_STOP = "Остановить запись"
L.RECORD_CLEAR = "Очистить"
L.RECORD_CLEAR_CONFIRM = "Удалить все записанные данные? Это действие нельзя отменить."
L.RECORD_STATUS_ON = "Запись идет с %s"
L.RECORD_STATUS_OFF = "Запись выключена"
L.RECORD_COMBATLOG = "Записывать журнал боя в подземельях"
L.RECORD_COMBATLOG_TIP = "Способности боссов берутся из игрового журнала боя. Путеводитель включает его внутри подземелий и выключает на выходе; журнал, запущенный вами вручную, затронут не будет. Чтобы отправить его, добавьте файл журнала к вашей записи на странице Читателя логов (кнопка «Копировать» покажет ссылку)."
L.RECORD_RECENT = "Недавние"
L.RECORD_NOTHING_YET = "Пока ничего не записано. Зайдите в подземелье с включенной записью, а затем убивайте боссов, собирайте добычу и выполняйте задания как обычно."
L.RECORD_STARTED = "Запись запущена. Команда /aegis record остановит ее."
L.RECORD_STOPPED = "Запись остановлена."
L.RECORD_LOG_STARTED = "Запись запущена."
L.RECORD_LOG_STOPPED = "Запись остановлена."
L.RECORD_LOG_CLEARED = "Записи очищены."
L.RECORD_LOG_ENTERED = "Вы вошли в %s."
L.RECORD_LOG_LEFT = "Вы вышли из подземелья."
L.RECORD_LOG_AREA = "Новая зона: %s."
L.RECORD_LOG_PULL = "Агро: %s."
L.RECORD_LOG_KILL = "Убит: %s."
L.RECORD_LOG_WIPE = "Вайп на боссе: %s."
L.RECORD_LOG_LOOT = "Добыча: %d нов. предмет(ов)."
L.RECORD_LOG_QUEST_OFFERED = "Предложено задание: %s."
L.RECORD_LOG_QUEST_DONE = "Сдано задание: %s."
L.RECORD_LOG_ENTRANCE = "Вход в %s записан."
L.RECORD_LOG_NO_ENTRANCE = "Вход в %s не записан: %s."
L.RECORD_NO_MAP = "игра не выдала карту при начале загрузочного экрана"
L.RECORD_NO_POSITION = "игра не выдала координаты при начале загрузочного экрана"
L.RECORD_IN_DUNGEON_MAP = "загрузочный экран начался на карте подземелья"
L.RECORD_LOG_COMBATLOG_ON = "Журнал боя включен: Logs\\%s."
L.RECORD_LOG_COMBATLOG_OFF = "Журнал боя выключен."

L.LEVEL_RANGE = "Уровень %d-%d"
L.LEVEL_BRACKET = "Уровень %d-%d"
L.LEVEL_ALL = "Все уровни"
L.TRASH_DROPS = "Добыча с существ"
L.UNTESTED = "Еще не протестировано"
L.UNTESTED_NOTE = "Еще не протестировано: информация взята из анонсов Blizzard и может быть неполной. Пройдите это подземелье с включенной вкладкой «Запись», чтобы заполнить данные о боссах, добыче и входе."
L.COMING_SOON = "Скоро откроется"
L.COMING_SOON_TEXT = "Еще не открыто в WoW: Forever. Боссы, добыча и карта появятся, когда игроки запишут свои прохождения. Записали такое? Опубликуйте его в нашем Discord, и ваше имя попадет в список авторов путеводителя."
L.COMING_SOON_PARTLY = "Еще не открыто в WoW: Forever: информация взята из анонса Blizzard. Записали прохождение? Опубликуйте его в нашем Discord, и ваше имя попадет в список авторов путеводителя."
L.DISCORD_COPY_HINT = "Нажмите, затем Ctrl+C"
L.FOREVER_MARK = "Новое в WoW: Forever"
L.RECORD_LOG_VENDOR = "%s: сохранено товаров: %d, из них новых для путеводителя: %d."
L.RECORD_CAUGHT = "Записано: %d, новых с момента последнего копирования: %d"
L.RECORD_COPY = "Копировать"
L.RECORD_AUTO = "Записывать автоматически в подземельях"
L.RECORD_AUTO_TIP = "Запись запускается автоматически при входе в подземелье или рейд и останавливается при выходе. Запись, которую вы запустили вручную, никогда не остановится автоматически."
L.RECORD_RECORDER = "Запись вел"
L.RECORD_SEND = "Отправьте это нам"
L.RECORD_HELP_TEXT = "Нажмите «Копировать», затем вставьте текст в наш Discord:"
L.RECORD_CREDIT = "Указать мое авторство как:"
L.RECORD_CREDIT_TIP = "Имя, под которым ваши записи будут отмечены в списке авторов путеводителя. Если оставить пустым, будет использовано имя вашего персонажа."
L.RECORD_CONTRIBUTORS = "Авторы"
L.RECORD_CONTRIBUTORS_NONE = "Пока никого: станьте первым."
L.RECORD_CONTRIBUTORS_FOOT = "Отправьте свою запись: ваше имя появится здесь."
L.RECORD_COPY_TITLE = "Ваша запись в виде текста"
L.RECORD_COPY_HINT = "Все выделено: нажмите Ctrl+C, затем вставьте в наш Discord."
L.RECORD_COPY_HINT_LOG = "Нажмите Ctrl+C, затем вставьте в Читатель логов вместе с вашим журналом боя (%s, находится в папке Logs в директории игры). Опубликуйте полученный результат в нашем Discord."
L.RECORD_MORE_LOGS = "%s и %d более старых"
L.RECORD_BACK = "Назад"
L.RECORD_CAUGHT_TITLE = "Что вы записали"
L.RECORD_ITEM = "Предмет %s"
L.RECORD_ONE_VISIT = "1 посещение"
L.RECORD_VISITS = "Посещений: %d"
L.RECORD_ENTRANCE_YES = "вход записан"
L.RECORD_ENTRANCE_NO = "вход еще не записан"
L.RECORD_AREAS = "Зоны: %d"
L.RECORD_KILLED = "Убито: %s"
L.RECORD_KILLED_TIMES = "%s (%d)"
L.RECORD_DROPS = "Добыча: %s новых, %s уже есть в путеводителе"
L.RECORD_OFF = "С босса %s"
L.RECORD_OFF_TRASH = "С треша"
L.RECORD_OFF_GROUP = "Добыто вашей группой"
L.RECORD_QUESTS = "Задания"
L.RECORD_QUEST_DONE = "сдано"
L.RECORD_NEW = "новое"
L.RECORD_QUARTERMASTERS = "Интенданты"
L.RECORD_WARES = "%s: товаров: %d, новых: %s"
L.RECORD_TRAVEL = "Точки перемещения: %d"
L.FOREVER_LINE = "Новое в WoW: Forever."
L.LOCATION_LINE = "Расположение: %s"

L.TAB_OVERVIEW = OVERVIEW or "Обзор"
L.TAB_LOOT = LOOT_NOUN or "Добыча"
L.TAB_ABILITIES = ABILITIES or "Способности"
L.TAB_MODEL = MODEL or "Модель"
L.TAB_QUESTS = QUESTS_LABEL or "Задания"
L.ALL_CLASSES = ALL_CLASSES or "Все классы"
L.ALL_ARMOR = "Вся броня"
L.ALL_TYPES = "Все типы"
L.LOOT_KIND = {
	EQUIPMENT = "Экипировка", RECIPE = "Рецепты", CONSUMABLE = "Расходники", MOUNT = "Транспорт", PET = "Питомцы",
	TOY = "Игрушки", BAG = "Сумки", TRADE = "Хозяйственные товары", QUEST = "Предметы заданий", OTHER = "Другое",
}
L.LOOT_KIND_ALL = { EQUIPMENT = "Вся экипировка", RECIPE = "Все рецепты" }
L.LOOT_KIND_ONE = { MOUNT = "Транспорт", PET = "Питомец", TOY = "Игрушка" }
L.LOOT_RECIPE = "Рецепт"
L.LOOT_FAVORITES = "Избранное"
L.LOOT_FAVORITES_ONLY = "Только избранное"
L.LOOT_FAVORITE = "Добавить в избранное"
L.LOOT_UNFAVORITE = "Удалить из избранного"
L.LOOT_PINNED = "Закрепленные"
L.LOOT_ALL = "Добыча"
L.LOOT_TRASH = "Трэш подземелья"
L.DROPS_FROM_BOSS = "Добыча: %s (%s)"
L.DROPS_FROM_TRASH = "Добыча: трэш (%s)"
L.DROPS_FROM_BOSSES = "Добыча с боссов: %d (%s)"
L.DROPS_IN = "Добыча в подземельях: %s"
L.DROPS_ALSO_IN = "Также добыча в подземельях: %s"
L.LEGEND_CLICK_HIDE = "Нажмите, чтобы скрыть их на карте."
L.LEGEND_CLICK_SHOW = "Скрыто. Нажмите, чтобы снова показать их на карте."
L.LEGEND_GAME_FILTER = "Фильтр самой игры, как в меню фильтров карты: у выполняемых заданий и готовых к сдаче он общий."
L.PREPARE_TITLE = "Перед походом"
L.PREPARE_PROGRESS = "Выполнено заданий: %d из %d."
L.PREPARE_HAVE = "Уже есть."
L.PREPARE_QUEST_HINT = "Нажмите, чтобы открыть на вкладке «Задания»."
L.QUESTS_DUNGEON = "Задания подземелья"
L.TRASH = "Трэш"
L.TRASH_DESCRIPTION = "Что стоит знать о добыче с остальных существ подземелья: редкое и эпическое снаряжение, рецепты и предметы для заданий."
L.LOOT_BOSS_LINE = BOSS_INFO_STRING or "Босс: %s"
L.LOOT_FILTER_BAR = "Фильтр: %s"
L.LOOT_RETRIEVING = RETRIEVING_ITEM_INFO or "Получение сведений о предмете"
L.LOOT_NO_DATA = "Предмет %d"
L.LOOT_NO_DATA_TOOLTIP = "Сервер не прислал данные об этом предмете. Возможно, его еще нет в игре."
L.LOOT_UNIDENTIFIED_TOOLTIP = "Еще не идентифицировано: источник указывает имя, но не ID предмета. Соберите этот лут во время записи, чтобы добавить его."
L.LOOT_TOOLTIP_PIN = "Нажмите правой кнопкой мыши, чтобы закрепить предмет вверху списка."
L.LOOT_TOOLTIP_UNPIN = "Нажмите правой кнопкой мыши, чтобы открепить."
L.LOOT_NONE = "Добыча для этого источника пока неизвестна."
L.LOOT_NO_MATCH = "Ничего не найдено по заданным фильтрам. Очистите их, нажав X выше."
L.ABILITY_LOADING = RETRIEVING_DATA or "Получение данных..."
L.ABILITIES_NONE = "Способности для этого босса пока неизвестны. Запишите прохождение во вкладке «Запись», чтобы сохранить их."
L.STATS_HIT = "Попадания %s"
L.STATS_TICK = "тики %s"
L.STATS_FIRST = "первое применение на %d сек."
L.STATS_EVERY = "затем каждые %s сек."
L.QUEST_NONE = "Для вашей фракции нет известных заданий в этом подземелье."
L.QUEST_STATUS_READY = "Готово: можно сдавать"
L.QUEST_STATUS_NEEDS = "Требуется: %s"
L.QUEST_STATUS_LEVEL = "Требуется уровень %d"
L.QUEST_DESCRIPTION = QUEST_DESCRIPTION or "Описание"
L.QUEST_START_ITEM = "Начинается с:"
L.QUEST_PARTS = "%s (%d частей)"
L.QUEST_PARTS_DONE = "Выполнено частей цепочки: %d из %d."
L.QUEST_SHOW_START = "Показать начало"
L.QUEST_SHOW_END = "Показать конец"
L.QUEST_PLACE_UNKNOWN = "Место пока неизвестно. Возьмите или сдайте это задание с включенной вкладкой «Запись», чтобы добавить его."
L.QUEST_OFFERED_BY = "Задание выдаёт: %s"
L.QUEST_HAND_IN_TO = "Сдать: %s"
L.QUESTMAP_DUNGEON_QUEST = "Задание подземелья: %s"
L.QUESTMAP_RAID_QUEST = "Задание рейда: %s"
L.QUESTMAP_LEFT_CLICK = "ЛКМ — открыть в путеводителе"
L.QUESTMAP_WAYPOINT_SET = "Точка маршрута установлена: %s."
L.QUESTMAP_ONE_OF = "Не всегда в одном месте: одна из %d точек."
L.MAP_ONE_OF = "Не всегда в одном месте: одна из %d точек."
L.QUEST_REWARDS = REWARDS or "Награды"
L.QUEST_YOU_RECEIVE = YOU_RECEIVE or "Вы получите:"
L.QUEST_XP = "%s опыта"
L.QUEST_REPUTATION = "%d репутации с фракцией %s"
L.QUEST_CHOOSE = REWARD_CHOICES or "Вы сможете выбрать одну из этих наград:"
L.QUEST_ALSO = REWARD_ITEMS or "Вы также получите:"
L.REP_REWARDS = "Наград: %d"
L.REP_REWARD_ONE = "1 награда"
L.REP_ALL_REWARDS = "Награды"
L.REP_UNKNOWN = "Не встречались"
L.REP_CARD_CLICK = "Нажмите, чтобы посмотреть награды."
L.REP_YOUR_STANDING = "Ваша репутация: %s"
L.REP_NOT_MET = "Вы еще не встречались с этой фракцией."
L.REP_PROGRESS = "%s / %s"
L.REP_QUARTERMASTER = "Интендант: %s"
L.REP_CAPTURE = "Записать торговца"
L.REP_CAPTURE_TIP = "Подойдите к интенданту репутации, откройте его магазин и нажмите эту кнопку. Сохраняется все, что он продает: цена каждого товара, прочие затраты и нужный уровень репутации. Товары сразу попадают в награды фракции и уйдут вместе с записью, когда вы нажмете «Копировать» на вкладке «Запись»."
L.REP_CAPTURE_READY = "Магазин открыт: нажмите «Записать торговца»."
L.REP_CAPTURE_HINT = "Откройте магазин интенданта, чтобы записать его товары."
L.REP_CAPTURED = "%s: товаров: %d (для %s), новых: %d."
L.REP_CAPTURED_NONE = "%s: сохранено товаров: %d; ни один не требует репутации."
L.REP_CAPTURED_UNKNOWN = "%s: %d товаров требуют репутации с фракцией без имени; сохранены, пока товар ее не назовет."
L.REP_NOT_CAPTURED = "Еще не записано"
L.REP_NOT_CAPTURED_TIP = "Интенданта этой фракции еще никто не записал."
L.REP_NOT_CAPTURED_TEXT = "Интенданта этой фракции еще никто не записал. Найдите его, откройте магазин и нажмите «Записать торговца» на вкладке «Репутация», затем опубликуйте запись в нашем Discord. Ваше имя попадет в список авторов путеводителя."
L.REP_COMING_SOON_TEXT = "Новое в WoW: Forever, еще не записано. Когда фракция появится в игре, найдите интенданта, откройте магазин и нажмите «Записать торговца» на вкладке «Репутация», затем опубликуйте запись в нашем Discord."
L.REP_LISTED_TIP = "Ее награды взяты из данных предметов игры и еще не подтверждены у интенданта."
L.REP_LISTED_TEXT = "Эти награды взяты из данных предметов игры, а не от интенданта: цены не показаны, и часть из них может вообще не продаваться. Найдите интенданта этой фракции, откройте его магазин и нажмите «Записать торговца» на вкладке «Репутация», затем опубликуйте запись в нашем Discord. Ваше имя попадет в список авторов путеводителя."
L.MAP_SHOW = ENCOUNTER_JOURNAL_SHOW_MAP or "Показать карту"
L.MAP_SHOW_UNEXPLORED = "Показывать неисследованные области"
L.MAP_FILTER_QUESTS = "Доступные задания"
L.MAP_FILTER_DUNGEONS = "Входы в подземелья"
L.MAP_FILTER_RAIDS = "Входы в рейды"
L.MAP_FILTER_FLIGHT = "Точки полета"
L.MAP_FILTER_CAVES = "Входы в пещеры"
L.MAP_FILTER_TRANSPORT = "Корабли, дирижабли, подземка и порталы"
L.MAP_PIN_OPEN = "Нажмите, чтобы открыть в путеводителе."
L.MAP_DEFEATED = DUNGEON_ENCOUNTER_DEFEATED or "Побежден"
L.MAP_LEVEL = "Уровень %d"
L.MAP_FLOOR = "Уровень %d"
L.MAP_GO_TO = "К %s"
L.MAP_YOU_ARE_HERE = "Вы здесь"
L.ENTRANCE_DUNGEON = LFG_TYPE_DUNGEON or "Подземелье"
L.ENTRANCE_RAID = LFG_TYPE_RAID or "Рейд"
L.ENTRANCE_DUNGEONS = DUNGEONS or "Подземелья"
L.ENTRANCE_RAIDS = RAIDS or "Рейды"
L.ENTRANCE_LEFT_CLICK = "ЛКМ — открыть путеводитель по подземельям"
L.ENTRANCE_CHOOSE_LEFT_CLICK = "ЛКМ — выбрать, что открыть в путеводителе"
L.ENTRANCE_RIGHT_CLICK = "ПКМ — установить точку маршрута"
L.ENTRANCE_WAYPOINT_SET = "Точка маршрута установлена у входа в %s."
L.ENTRANCE_VIA = "Портал находится ниже, в зоне «%s»: спуститесь у входа в пещеру."
L.ENTRANCE_WAYPOINT_VIA = "Точка маршрута установлена у спуска в %s, к %s."
L.CAVE_LABEL = "Вход в пещеру"
L.BUILDING_LABEL = "Вход"
L.ENTRANCE_VIA_BUILDING = "Портал находится внутри: %s. Войдите через вход."
L.CAVE_LEADS_TO = "Путь к %s"
L.CAVE_LEFT_CLICK = "ЛКМ — посмотреть карту: %s"
L.CAVE_WAYPOINT_SET = "Точка маршрута установлена у спуска в %s."
L.FLIGHT_POINT = MAP_LEGEND_FLIGHTPOINT or "Точка полета"
L.CLICK_FOR_WAYPOINT = "Нажмите, чтобы установить точку маршрута"
L.FLIGHT_WAYPOINT_SET = "Точка маршрута установлена у распорядителя полетов: %s."
L.TRAVEL_KINDS = { boat = "Корабль", zeppelin = "Дирижабль", airship = "Воздушный корабль", tram = "Подземка", portal = "Портал" }
L.TRAVEL_FACTIONS = { Alliance = FACTION_ALLIANCE or "Альянс", Horde = FACTION_HORDE or "Орда" }
L.TRAVEL_ROUTE = "%s до %s"
L.TRAVEL_AND = "%s и %s"
L.TRAVEL_ROUTE_NOTE = "%s: %s"
L.TRAVEL_HELP = "Встаньте у причала, башни дирижаблей, подземки или портала и введите /aegis travel boat (или zeppelin, airship, tram, portal) и куда он ведет, например /aegis travel boat Auberdine. В конце можно указать alliance, horde или neutral — кому он служит, и примечание в скобках, кто может им пользоваться, например /aegis travel portal Dalaran (только Небожители). /aegis travel list показывает сохраненное; /aegis travel undo отменяет последнюю точку."
L.TRAVEL_NO_POSITION = "Игра не дает координат здесь, поэтому ничего не сохранено."
L.TRAVEL_SAVED = "Сохранено: %s у %s. /aegis travel undo отменяет это."
L.TRAVEL_UNDONE = "Отменено: %s у %s."
L.TRAVEL_NOTHING = "Нечего отменять."
L.TRAVEL_LIST_EMPTY = "Точек перемещения пока нет. Введите /aegis travel, чтобы узнать, как их сохранить."
L.TRAVEL_LIST_LINE = "%d. %s у %s (карта %d, %.4f, %.4f)"
L.TRAVEL_WAYPOINT_SET = "Точка маршрута установлена: %s."
L.LEGEND_TRANSPORT = "Транспорт"
L.LEGEND_TRANSPORT_TOOLTIP = "Корабли, дирижабли, подземка и порталы. Синий — для Альянса, красный — для Орды, золотой — для всех."
L.LEGEND_CAVE_TOOLTIP = "Путь в пещеру или на уровень ниже зоны. Нажмите на карте, чтобы увидеть, куда он ведет."
L.SEARCH_SHOW_ALL = SEARCH_RESULTS_SHOW_COUNT or "Показать все результаты: %d"
L.SEARCH_RESULTS = ENCOUNTER_JOURNAL_SEARCH_RESULTS or "Результаты поиска «%s» (%d)"
L.SEARCH_TYPE_BOSS = "Босс"
L.SEARCH_TYPE_ABILITY = "Способность"
L.SEARCH_TYPE_ITEM = "Предмет"
L.SEARCH_TYPE_QUEST = "Задание"
L.SEARCH_TYPE_FACTION = FACTION or "Фракция"
L.MAP_PIN_CLEAR = "Нажмите, чтобы убрать эту метку."
L.MAP_PIN_COMBAT = "Карту нельзя открыть в бою."

L.RARE_SUFFIX = " (редкий)"
L.AND_MORE = "и еще %d"
L.BULLET_AREA = "Встречается в зоне: %s."
L.BULLET_RARE = "Редкий противник: появляется не в каждом заходе."
L.BULLET_SUMMONED = "Скрытый босс, которого вы призываете сами: как именно — сказано в заметке выше."
L.BULLET_LEVEL = "Противник %d-го уровня."
L.BULLET_ABILITIES = "Применяет: %s."
L.BULLET_LOOT = "Добыча: %d предметов, в том числе %s."
L.BULLET_ADDS = "Рядом: %s."
L.ADD_DESCRIPTION = "Сражается рядом с %s."
L.BULLET_NOTHING_YET = "Об этом противнике пока ничего не известно."

L.INSTANCE_NAMES = {
	RagefireChasm = "Огненная Пропасть",
	WailingCaverns = "Пещеры Стенаний",
	TheDeadmines = "Мертвые копи",
	ShadowfangKeep = "Крепость Темного Клыка",
	TheStockade = "Тюрьма",
	BlackfathomDeeps = "Непроглядная Пучина",
	Gnomeregan = "Гномреган",
	RazorfenKraul = "Лабиринты Иглошкурых",
	ScarletMonasteryGraveyard = "Монастырь Алого ордена: Кладбище",
	ScarletMonasteryLibrary = "Монастырь Алого ордена: Библиотека",
	ScarletMonasteryArmory = "Монастырь Алого ордена: Оружейная",
	ScarletMonasteryCathedral = "Монастырь Алого ордена: Собор",
	RazorfenDowns = "Курганы Иглошкурых",
	Uldaman = "Ульдаман",
	ZulFarrak = "Зул'Фаррак",
	Maraudon = "Мародон",
	TempleOfAtalHakkar = "Храм Атал'Хаккара",
	BlackrockDepths = "Глубины Черной горы",
	LowerBlackrockSpire = "Нижняя часть пика Черной горы",
	UpperBlackrockSpire = "Верхняя часть пика Черной горы",
	DireMaulEast = "Забытый Город (восток)",
	DireMaulNorth = "Забытый Город (север)",
	DireMaulWest = "Забытый Город (запад)",
	Scholomance = "Некроситет",
	StratholmeMainGate = "Стратхольм (главные врата)",
	StratholmeServiceGate = "Стратхольм (черный ход)",
	CityOfDalaran = "Даларан",
	HallOfThanes = "Зал Танов",
	RuinsOfLordaeron = "Руины Лордерона",
	ExcavationSiteWetlands = "Раскопки: Болотина",
	BarrowDeeps = "Глубины кургана",
	HyjalSummit = "Вершина Хиджала",
	OnyxiasLair = "Логово Ониксии",
	TheDrownedCity = "Затопленный город",
	KroldokStronghold = "Крепость Крол'док",
	AlcazPrison = "Тюрьма Альказа",
	BlackmawHold = "Цитадель Чернопасти",
	ShapersTerrace = "Терраса ваятеля",
}

L.INSTANCE_LOCATIONS = {
	RagefireChasm = "Расселина Теней, Оргриммар",
	WailingCaverns = "Северные Степи",
	TheDeadmines = "Западный Край",
	ShadowfangKeep = "Серебряный бор",
	TheStockade = "Штормград",
	BlackfathomDeeps = "Ясеневый лес",
	Gnomeregan = "Дун Морог",
	RazorfenKraul = "Степи",
	ScarletMonasteryGraveyard = "Тирисфальские леса",
	ScarletMonasteryLibrary = "Тирисфальские леса",
	ScarletMonasteryArmory = "Тирисфальские леса",
	ScarletMonasteryCathedral = "Тирисфальские леса",
	RazorfenDowns = "Степи",
	Uldaman = "Бесплодные земли",
	ZulFarrak = "Танарис",
	Maraudon = "Пустоши",
	TempleOfAtalHakkar = "Болото Печали",
	BlackrockDepths = "Черная гора",
	LowerBlackrockSpire = "Черная гора",
	UpperBlackrockSpire = "Черная гора",
	DireMaulEast = "Фералас",
	DireMaulNorth = "Фералас",
	DireMaulWest = "Фералас",
	Scholomance = "Западные Чумные земли",
	StratholmeMainGate = "Восточные Чумные земли",
	StratholmeServiceGate = "Восточные Чумные земли",
	CityOfDalaran = "Альтеракские горы",
	HallOfThanes = "Под Стальгорном, Дун Морог",
	RuinsOfLordaeron = "Разрушенная столица Лордерона",
	ExcavationSiteWetlands = "Болотина",
	HyjalSummit = "Гора Хиджал",
	OnyxiasLair = "Пылевые топи",
	TheDrownedCity = "Побережье Тернистой долины",
	KroldokStronghold = "Речные низины",
	AlcazPrison = "Остров Алькац, Пылевые топи",
	BlackmawHold = "Северная Азшара",
	ShapersTerrace = "Кратер Ун'Горо",
}

L.INSTANCE_DESCRIPTIONS = {
	HallOfThanes = "Под Стальгорном кто-то вскрыл гробницу дворфийских королей.",
	RuinsOfLordaeron = "Плеть все еще держит руины старой столицы, где некромант копит силы.",
	ExcavationSiteWetlands = "Титанический раскоп над Раскопками Вельгара, вырванный из времени: создания титанов больше никому не подчиняются. Внутри: Затерянное болото, Чащоба Сталкера, Место Стража и Затерянный раскоп.",
	BarrowDeeps = "Рейд, новый в WoW: Forever. Боссы и добыча пока неизвестны.",
	HyjalSummit = "Рейд, новый в WoW: Forever, на горе Хиджал. Боссы и добыча пока неизвестны.",
	OnyxiasLair = "Праматерь черных драконов ждет в логове под Драконьими топями. Версия Forever пока неизвестна.",
	TheDrownedCity = "Тролльский город, давно ушедший на дно, снова поднялся из океана. Его улицы заняли наги, пираты и твари из глубин.",
	KroldokStronghold = "Огрская крепость, битком набитая воинами: Молот Сумерек нашел здесь союзников.",
	AlcazPrison = "В тюрьме на острове Алькац все еще сидят узники Братства Справедливости, но наги захватили остров и сделали тюрьму своей.",
	BlackmawHold = "За вратами фурболгов на дальнем севере Азшары лежит одно из крупнейших логовищ, и из глубин его что-то оскверняет.",
	ShapersTerrace = "Титанический комплекс, скрытый в кратере Ун'Горо: среди динозавров он хранит тайны творцов.",
}

L.SUBMAP_NAMES = {
	OldIronforge = "Старый Стальгорн",
	DeadminesApproach = "Убежище Братства Справедливости",
	WailingCavernsApproach = "Пещеры Стенаний",
	WailingCavernsApproachBarrens = "Пещеры Стенаний",
	UldamanApproach = "Ульдаман",
	MaraudonOrange = "Мародон (оранжевый)",
	MaraudonPurple = "Мародон (фиолетовый)",
	BlackrockMountain = "Черная гора",
	BlackrockDepthsApproach = "Черная гора",
	BlackrockDepthsApproachSteppes = "Черная гора",
	ScarletMonasteryHall = "Монастырь Алого ордена",
	ScarletMonasteryHallContinent = "Монастырь Алого ордена",
	DeeprunTram = "Подземный поезд",
}

L.FACTION_NAMES = {
	[529] = "Серебряный Рассвет",
	[2586] = "Торговая палата Азерота",
	[21] = "Пиратская Бухта",
	[910] = "Род Ноздорму",
	[609] = "Круг Кенария",
	[2798] = "Налетчики Черного Копья",
	[2587] = "Снабжение и логистика Дуротара",
	[2787] = "Служители Земли",
	[577] = "Круговзор",
	[369] = "Прибамбасск",
	[2765] = "Стражи Хиджала",
	[749] = "Гидраксианские Повелители Вод",
	[2740] = "Кирин-Тор",
	[2758] = "Друиды Ночного Когтя",
	[2827] = "Пороховой Фитиль",
	[470] = "Кабестан",
	[510] = "Осквернители",
	[509] = "Лига Аратора",
	[2819] = "Дозорные",
	[2799] = "Экспедиционный корпус Терамора",
	[59] = "Братство Тория",
	[576] = "Древобрюхи",
	[270] = "Племя Зандалар",
}

-- The Russian client's classic "Equip:" wordings (drafted; check against items in game).
L.EQUIP_PATTERNS = {
	-- Bonuses against undead only, and effects on being struck or on a hit: worth nothing.
	{ "нежит", false },
	{ "критическ.-свет.-на {n}%%", "HOLY CRIT" },
	{ "критическ.-Свет.-на {n}%%", "HOLY CRIT" },
	{ "критическ.-свят.-на {n}%%", "HOLY CRIT" },
	{ "критическ.-заклинани.-на {n}%%", "SPELL CRIT" },
	{ "заклинани.-критическ.-на {n}%%", "SPELL CRIT" },
	{ "критическ.-дальн.-на {n}%%", "RANGED CRIT" },
	{ "критическ.-стрелков.-на {n}%%", "RANGED CRIT" },
	{ "критическ.-метательн.-на {n}%%", "RANGED CRIT" },
	{ "критическ.-на {n}%%", "CRIT" },
	{ "попадани.-заклинани.-на {n}%%", "SPELL HIT" },
	{ "меткост.-заклинани.-на {n}%%", "SPELL HIT" },
	{ "вероятност.-попадани.-на {n}%%", "HIT" },
	{ "шанс.-попадани.-на {n}%%", "HIT" },
	{ "меткост.-на {n}%%", "HIT" },
	{ "урон.-исцел.-{n}", { "SPELL POWER", "HEALING" } },
	{ "урон.-целит.-{n}", { "SPELL POWER", "HEALING" } },
	{ "урон.-лечени.-{n}", { "SPELL POWER", "HEALING" } },
	{ "исцел.-урон.-{n}", { "SPELL POWER", "HEALING" } },
	{ "лечени.-урон.-{n}", { "SPELL POWER", "HEALING" } },
	{ "исцел.-заклинани.-{n}", "HEALING" },
	{ "исцел.-эффект.-{n}", "HEALING" },
	{ "заклинани.-исцел.-{n}", "HEALING" },
	{ "целит.-заклинани.-{n}", "HEALING" },
	{ "лечени.-заклинани.-{n}", "HEALING" },
	{ "урон.-свет.-{n}", "HOLY DAMAGE" },
	{ "урон.-Свет.-{n}", "HOLY DAMAGE" },
	{ "урон.-свят.-{n}", "HOLY DAMAGE" },
	{ "урон.-огн.-{n}", "FIRE DAMAGE" },
	{ "урон.-огон.-{n}", "FIRE DAMAGE" },
	{ "урон.-льд.-{n}", "FROST DAMAGE" },
	{ "урон.-Льд.-{n}", "FROST DAMAGE" },
	{ "урон.-ледян.-{n}", "FROST DAMAGE" },
	{ "урон.-холод.-{n}", "FROST DAMAGE" },
	{ "урон.-природ.-{n}", "NATURE DAMAGE" },
	{ "урон.-Природ.-{n}", "NATURE DAMAGE" },
	{ "урон.-тьм.-{n}", "SHADOW DAMAGE" },
	{ "урон.-Тьм.-{n}", "SHADOW DAMAGE" },
	{ "урон.-темн.-{n}", "SHADOW DAMAGE" },
	{ "урон.-тайн.-{n}", "ARCANE DAMAGE" },
	{ "урон.-Тайн.-{n}", "ARCANE DAMAGE" },
	{ "урон.-заклинани.-{n}", "SPELL DAMAGE" },
	{ "урон.-магическ.-{n}", "SPELL DAMAGE" },
	{ "осполн.-маны.-{n}%%", "CASTING REGEN" },
	{ "{n}%%.-осполн.-маны", "CASTING REGEN" },
	{ "егенерац.-маны.-{n}%%", "CASTING REGEN" },
	{ "{n}%%.-егенерац.-маны", "CASTING REGEN" },
	{ "осстановлени.-маны.-{n}%%", "CASTING REGEN" },
	{ "{n}%%.-осстановлени.-маны", "CASTING REGEN" },
	{ "маны.-во время.-{n}%%", "CASTING REGEN" },
	{ "{n}%%.-маны.-во время", "CASTING REGEN" },
	{ "сопротивл.-цел.-{n}", "SPELL PENETRATION" },
	{ "цел.-сопротивл.-{n}", "SPELL PENETRATION" },
	{ " сил.-атак.-в бою", false },
	{ " сил.-атак.-против ", false },
	{ " сил.-атак.-сражени", false },
	{ "{n} к сил.-атак.-дальн", "RANGED ATTACK POWER" },
	{ " сил.-атак.-дальн.-на {n}", "RANGED ATTACK POWER" },
	{ "{n} к сил.-атак.-облик", "FERAL ATTACK POWER" },
	{ "{n} к сил.-атак.-кошк", "FERAL ATTACK POWER" },
	{ " сил.-атак.-на {n}.-облик", "FERAL ATTACK POWER" },
	{ " сил.-атак.-на {n}.-кошк", "FERAL ATTACK POWER" },
	{ "скорост.-атак.-на {n}%%", "HASTE" },
	{ " сил.-атак.-на {n}", "ATTACK POWER" },
	{ "{n} к сил.-атак", "ATTACK POWER" },
	{ "{n}[^%d]-маны.-5 с", "MANA PER 5" },
	{ "{n}[^%d]-здоров.-5 с", "HEALTH PER 5" },
	{ "осполн.-{n}[^%d]-здоров", "HEALTH PER 5" },
	{ "осстан.-{n}[^%d]-здоров", "HEALTH PER 5" },
	{ "ащит.-%+{n}", "DEFENSE" },
	{ "{n} к защит", "DEFENSE" },
	{ "ащит.-на {n}", "DEFENSE" },
	{ "уклон.-на {n}%%", "DODGE" },
	{ "парир.-на {n}%%", "PARRY" },
	{ "блок.-на {n}%%", "BLOCK" },
	{ "блок.-на {n}", "BLOCK VALUE" },
}

-- The rooms inside dungeons, as the client names them where the player stands: "You are
-- here" and a wing's areas match these (Core/Areas.lua). Unconfirmed ones are listed in
-- the translation's to-check list.
L.AREA_NAMES = {
	["Aku'mai's Lair"] = "Логово Аку'Мая",
	["Anvilmar's Rest"] = "Покой Анвилмара",
	["Athenaeum"] = "Читальня",
	["Blackrock Stadium"] = "Стадион Черной горы",
	["Capital Gardens"] = "Столичные сады",
	["Cavern of Mists"] = "Пещера Туманов",
	["Chamber of Atonement"] = "Чертог Искупления",
	["Chamber of Battle"] = "Чертог Битвы",
	["Chapel Gardens"] = "Церковные сады",
	["Court of the Highborne"] = "Двор Высокорожденных",
	["Crag of the Everliving"] = "Утес Вечноживущего",
	["Crusader's Armory"] = "Оружейная Рыцарей",
	["Crusader's Chapel"] = "Часовня Ордена",
	["Crusaders' Square"] = "Площадь рыцарей",
	["Dark Iron Ingress"] = "Проход Темного Железа",
	["Defias Hideout"] = "Убежище Братства Справедливости",
	["Dragonspire Hall"] = "Зал Драконов",
	["Dreamer's Rock"] = "Покои Спящего",
	["Elders' Square"] = "Площадь Старейшин",
	["Engineering Labs"] = "Инженерные лаборатории",
	["Festival Lane"] = "Праздничная улица",
	["Footman's Armory"] = "Оружейная пехоты",
	["Forlorn Cloister"] = "Покинутый двор",
	["Gallery of Treasures"] = "Сокровищница",
	["Goblin Foundry"] = "Гоблинский цех",
	["Gordok Commons"] = "Общий зал Гордока",
	["Hall of Champions"] = "Чертог Защитников",
	["Halycon's Lair"] = "Логово Халикона",
	["Honor's Tomb"] = "Гробница Доблести",
	["Hordemar City"] = "Ордамар",
	["Huntsman's Cloister"] = "Скит Охотника",
	["King's Square"] = "Королевская площадь",
	["Launch Bay"] = "Пусковой отсек",
	["Market Row"] = "Торговый ряд",
	["Mast Room"] = "Мачтовая мастерская",
	["Mok'Doom"] = "Мок'Дум",
	["Moonshrine Ruins"] = "Руины Лунного святилища",
	["Moonshrine Sanctum"] = "Святилище Лунного Света",
	["Pit of Fangs"] = "Змеиная яма",
	["Prison of Immol'thar"] = "Тюрьма Бессмер'тера",
	["Reliquary of Kings"] = "Реликварий королей",
	["Screaming Gully"] = "Овраг Воплей",
	["Skitterweb Tunnels"] = "Паучий лабиринт",
	["Slaughter Square"] = "Площадь Живодерни",
	["Tazz'Alaor"] = "Тазз'Алаор",
	["Tazz'Alor"] = "Тазз'Алор",
	["The Clockwerk Run"] = "Заводной проход",
	["The Dormitory"] = "Общежитие",
	["The Drowned Sacellum"] = "Затопленное святилище",
	["The Forgotten Pool"] = "Забытый пруд",
	["The Gauntlet"] = "Улица Испытаний",
	["The Hall of Gears"] = "Зал Шестеренок",
	["The Hall of Lights"] = "Зал Света",
	["The High Seat"] = "Высокий трон",
	["The Hoard"] = "Арсенал",
	["The Pool of Ask'ar"] = "Пруд Аск'ара",
	["The Rookery"] = "Гнездовье",
	["The Scarlet Bastion"] = "Бастион Алого ордена",
	["The Shrine of Eldretharr"] = "Святилище Элдретарра",
	["The Slaughter House"] = "Живодерня",
	["The Storehouse"] = "Кладовая",
	["Tinkers' Court"] = "Двор Механиков",
	["Training Grounds"] = "Тренировочная площадка",
	["Warpwood Quarter"] = "Квартал Криводревов",
}

-- Matched against the client's own text: the client's language's only, previewed or not.
if client then client.EQUIP_PATTERNS, client.AREA_NAMES = L.EQUIP_PATTERNS, L.AREA_NAMES end
L.EQUIP_PATTERNS, L.AREA_NAMES = nil, nil
