local _, ns = ...

--[[
	The journal's interface in German, for a client set to German. Drafted by Claude for review by a
	native speaker. It is laid over the English table (Locales/enUS.lua), so every file that already
	holds ns.L sees these strings, and anything not translated here stays English. Every other
	client skips it.
]]
if not ns.Speaks("deDE") then return end

local L = ns.L

L.JOURNAL_TITLE = "Dungeonkompendium"
L.HOME = HOME or "Startseite"
L.TAB_DUNGEONS = DUNGEONS or "Dungeons"
L.TAB_RAIDS = RAIDS or "Schlachtzüge"
L.TAB_REPUTATION = REPUTATION or "Ruf"

L.BINDING_TOGGLE = "Dungeonkompendium ein-/ausblenden"
L.KEY_CLAIMED = "Umschalt+J öffnet jetzt das Dungeonkompendium."
L.KEY_TAKEN = "Umschalt+J ist bereits mit %s belegt. Wählt eine Taste unter Tastenbelegungen > AddOns > Dungeonkompendium ein-/ausblenden."
L.POSITION_RESET = "Fensterposition zurückgesetzt."
L.SLASH_HELP = "/aegis (oder /ij) öffnet das Kompendium. /aegis record startet oder beendet die Aufzeichnung. /aegis reset setzt das Fenster an seinen Standardplatz zurück. /aegis perf misst Speicherbedarf und Geschwindigkeit des Kompendiums. /aegis where und /aegis taxi melden, wo Ihr steht und welche Flugpunkte auf Eurer Karte liegen. /aegis travel speichert ein Schiff, einen Zeppelin, eine Bahn oder ein Portal für die Weltkarte. /aegis items sucht die aufgeführten Gegenstände, die der Server nicht kennt. /aegis gear öffnet die Ausrüstungssuche, /aegis weights ihre Wertgewichtung; /aegis gearscan speichert, was sie aus Eurer Ausrüstung ausliest, um ihre Bewertung zu prüfen. /aegis options öffnet die Optionen des Kompendiums. /aegis lang zeigt das Kompendium zur Probe in einer seiner anderen Sprachen."
-- /aegis lang (Core/Init.lua)
L.LANG_USAGE = "/aegis lang de, fr, ru, cn, tw, es, mx, pt oder ko zeigt das Kompendium ab Eurem nächsten /reload auf Deutsch, Französisch, Russisch, Chinesisch (vereinfacht oder traditionell), Spanisch (Spanien oder Lateinamerika), brasilianischem Portugiesisch oder Koreanisch, um eine Übersetzung zu prüfen; /aegis lang off kehrt zur Sprache Eures Clients zurück. Aktuell: %s."
L.LANG_SET = "Ab Eurem nächsten /reload erscheint das Kompendium in der Sprache %s: nur seine eigenen Texte, denn die Namen aus dem Spiel bleiben in der Sprache Eures Clients. Gebt jetzt /reload ein; /aegis lang off macht es rückgängig."
L.LANG_OFF = "Ab Eurem nächsten /reload erscheint das Kompendium wieder in der Sprache Eures Clients. Gebt jetzt /reload ein."
L.LANG_FONTS = "Chinesisch braucht die Schriftarten eines chinesischen Clients: Auf Eurem werden manche Zeichen womöglich nicht angezeigt."
L.LANG_FONTS_KO = "Koreanisch braucht die Schriftarten eines koreanischen Clients: Auf Eurem werden manche Zeichen womöglich nicht angezeigt."
L.LANG_ON = "Vorschau des Kompendiums in der Sprache %s. /aegis lang off beendet sie."
L.LANG_UNAVAILABLE = "Dieser Client hat das Kompendium vor seinen gespeicherten Einstellungen geladen, daher konnte die Sprachvorschau nicht starten."
L.AREAS_START = "Die IDs der %d Gebietsnamen des Kompendiums werden im Client gesucht..."
L.AREAS_DONE = "IDs für %d der %d Gebietsnamen gefunden. Gebt /reload ein, um sie zu speichern."
L.AREAS_MISSING = "Nicht gefunden: %s."
L.AREAS_SCANNING = "Die Gebietsnamen werden noch gesucht."
L.AREAS_ENGLISH = "Führt /aegis areas auf einem englischen Client aus: Die gesuchten Namen sind englisch."
L.ITEMS_START = "Der Server wird nach den %d Gegenständen gefragt, die das Kompendium aufführt. Die Antwort kommt in etwa %d Sekunden; spielt ruhig weiter."
L.ITEMS_SCANNING = "Der Server wird noch gefragt; die Antwort kommt gleich."
L.ITEMS_DONE = "Von %d Gegenständen kennt der Server %d nicht: Wahrscheinlich gibt es sie in Forever noch nicht. Das Kompendium blendet sie aus, bis der Server oder ein aufgezeichneter Durchlauf sie bestätigt. Die vollständige Liste kommt beim nächsten /reload oder Ausloggen in die gespeicherte Datei."
L.ITEMS_LINE = "  Gegenstand %d: %s"
L.ITEMS_MORE = "  ...und %d weitere."
L.PERF_HEADER = "Leistung (Speicher in KB, Zeiten in Millisekunden; weniger ist besser):"
L.PERF_MEMORY = "  %s: %.0f KB"
L.PERF_TIME = "  %s: %.2f ms"
L.PERF_BUILD = "Erstes Öffnen (Aufbau des Fensters)"
L.PERF_BOOK = "Erster geöffneter Dungeon (Aufbau des Buchs)"
L.PERF_OPEN = "Kompendium öffnen und schließen"
L.PERF_DUNGEON = "Seite eines Dungeons öffnen"
L.PERF_TAB = "Zum Reiter %s wechseln"
L.PERF_FACTION = "Seite einer Fraktion öffnen"
L.PERF_LOOT = "Beuteseite neu zeichnen"
L.PERF_COMBAT = "Die Messung wartet, bis Ihr nicht mehr im Kampf seid."
L.WHERE = "Karte %s (%s)  x %.4f  y %.4f  Gebiet \"%s\"  Minikarte \"%s\"  Höhe %s"
L.TAXI = "Karte %s  zeigt selbst Flugpunkte: %s  Flugpunkte darauf: %d (%d entdeckt)  %s"
L.TAXI_ATLASES = "Reisesymbole: %s"
L.YES = YES or "Ja"
L.NO = NO or "Nein"

L.EMPTY_DUNGEONS = "Für Dungeons gibt es noch keine Einträge im Kompendium."
L.EMPTY_RAIDS = "Für Schlachtzüge gibt es noch keine Einträge im Kompendium."
L.EMPTY_REPUTATION = "Es sind noch keine Rufbelohnungen bekannt."
L.EMPTY_BRACKET = "In diesem Stufenbereich gibt es nichts."

L.TAB_RECORD = "Aufzeichnen"
L.TAB_GEAR = "Ausrüstungssuche"

-- The Gear Finder (Core/GearFinder.lua, UI/GearPanel.lua, UI/CharacterTab.lua).
L.GEAR_TITLE = "Ausrüstungssuche"
L.GEAR_PREVIEW = "Vorschau"
L.GEAR_NO_UPGRADE = "Keine Verbesserung gefunden"
L.GEAR_LOOKING = "Suche in %d Dungeons."
L.GEAR_LOOKING_ONE = "Suche in 1 Dungeon."
L.GEAR_LOADING = "%d Gegenstände werden noch geladen."
L.GEAR_LOADING_ONE = "1 Gegenstand wird noch geladen."
L.GEAR_SCORING = "Bewertung für"
L.GEAR_AUTO = "Automatisch: %s"
L.GEAR_WHY_TALENTS = "%s (Talente)"
L.GEAR_WHY_LEVELLING = "%s (Stufenaufstieg)"
L.GEAR_SUGGESTED = "Empfohlener Dungeon"
L.GEAR_UPGRADES_HERE = "%d Verbesserungen hier"
L.GEAR_UPGRADE_HERE = "1 Verbesserung hier"
L.GEAR_MORE_SLOTS = "und %d weitere"
L.GEAR_DUNGEON_OF = "%d von %d"
L.GEAR_NONE = "Keine Verbesserungen in den Dungeons Eurer Stufe."
L.GEAR_TIP_CLICK = "Klickt, um die Beute zu sehen; Umschalt+Klick, um den Gegenstand zu verlinken."
L.GEAR_TIP_CELL_CLICK = "Klickt für die besten Verbesserungen; Rechtsklick, um die Beute zu sehen."
L.GEAR_TIP_PICK_CLICK = "Klickt, um ihn hier anzuzeigen; Rechtsklick, um die Beute zu sehen."
L.GEAR_TIP_PICKED = "Eure Wahl für diesen Platz."
L.GEAR_PICK_TOP = "Die besten %d von %d Verbesserungen"
L.GEAR_PICK_ALL = "%d Verbesserungen"
L.GEAR_PICK_ONE = "Die einzige Verbesserung"
L.GEAR_PICK_BIGGEST = "Größte"
L.GEAR_PICK_YOURS = "Eure Wahl"
L.GEAR_PICK_KEPT = "Eure Wahl wird für diesen Charakter gespeichert."
L.GEAR_PICK_CLEAR = "Meine Wahl aufheben"
L.GEAR_TIP_NONE = "Keine Verbesserung für diesen Platz in den Dungeons Eurer Stufe."
L.GEAR_CHAR_BUTTON = "Ausrüstungssuche"
L.GEAR_CHAR_BUTTON_TIP = "Eure Wertgewichtung und die besten Verbesserungen, die in den Dungeons des Kompendiums auf Euch warten."
L.GEAR_SCAN_DONE = "Ausrüstungsscan gespeichert: %d getragene Gegenstände und %d Gegenstände aus Dungeons. Loggt Euch aus oder gebt /reload ein, um ihn in die gespeicherte Datei zu schreiben."
L.GEAR_SCAN_ERRORS = "%d Gegenstände konnten nicht gelesen werden; was schiefging, ist mit dem Scan gespeichert."
L.GEAR_SCAN_LOADING = "Manche Beute wird noch geladen: Wartet ein paar Sekunden und gebt erneut /aegis gearscan ein, um mehr zu erhalten."
L.GEAR_SLOT_FINGER1 = "Finger 1"
L.GEAR_SLOT_FINGER2 = "Finger 2"
L.GEAR_SLOT_TRINKET1 = "Schmuck 1"
L.GEAR_SLOT_TRINKET2 = "Schmuck 2"

-- Stat weights (Core/ItemScore.lua, UI/WeightsEditor.lua).
L.WEIGHTS_TITLE = "Wertgewichtung"
L.WEIGHTS_EDIT = "Wertgewichtung bearbeiten..."
L.WEIGHTS_SOURCE_DEFAULT = "Gewichtung des Kompendiums"
L.WEIGHTS_SOURCE_LEVELLING = "Gewichtung des Kompendiums, beim Stufenaufstieg"
L.WEIGHTS_SOURCE_CUSTOM = "Eure eigene Gewichtung"
L.WEIGHTS_SOURCE_PAWN = "Eure Gewichtung aus Pawn: %s"
L.WEIGHTS_TIP = "Wie viel ein Punkt jedes Werts dieser Spezialisierung wert ist. Klickt auf eine Gewichtung, um sie zu ändern; Eure eigenen Gewichtungen erscheinen grün und werden für diesen Charakter gespeichert."
L.WEIGHTS_RESET = "Zurücksetzen"
L.WEIGHTS_RESET_TIP = "Zurück zur Gewichtung des Kompendiums für diese Spezialisierung."
L.WEIGHTS_PAWN = "Pawn..."
L.WEIGHTS_PAWN_TIP = "Eine Skala aus Pawn übernehmen."
L.WEIGHTS_PAWN_HELP = "Wählt in Pawn die Skala, dann Exportieren, kopiert den Text und fügt ihn hier ein."
L.WEIGHTS_IMPORT = "Importieren"
L.WEIGHTS_CANCEL = "Abbrechen"
L.WEIGHTS_BACK = "Zurück"
L.WEIGHTS_OPEN_FINDER = "Ausrüstungssuche öffnen"
L.WEIGHTS_IMPORTED = "%d Gewichtungen aus %s importiert."
L.WEIGHTS_UNUSED = "Nicht verwendet: %s."
L.WEIGHTS_NOT_PAWN = "Das ist keine Pawn-Skala. Wählt in Pawn Exportieren und kopiert den gesamten Text."
L.WEIGHTS_OTHER_CLASS = "Diese Skala ist für die Klasse %s, nicht für die Klasse dieses Charakters."
L.WEIGHTS_FOR = "Für"
-- The journal's page in the game's options (Options > AddOns).
L.OPTIONS_TITLE = "Aegis Instance Journal"
L.OPTIONS_BOSS_LEVELS = "Bossstufen in der Bossliste anzeigen"
L.OPTIONS_BOSS_LEVELS_TIP = "Ein Abzeichen auf dem Porträt jedes Bosses zeigt seine Stufe, gefärbt danach, wie schwer der Boss für Euch ist: grau, grün, gelb, orange oder rot."
L.OPTIONS_ARROWS = "Verbesserungen mit einem grünen Pfeil markieren"
L.OPTIONS_MINIMAP = "Schaltfläche an der Minikarte anzeigen"
L.OPTIONS_PAWN_WEIGHTS = "Wertgewichtung von Pawn in der Ausrüstungssuche verwenden"
L.OPTIONS_PAWN_WEIGHTS_TIP = "Ist Pawn installiert, werden seine Gegenstands-Tooltips und Verbesserungspfeile angezeigt. Angehakt: Die Ausrüstungssuche bewertet Gegenstände mit Eurer Pawn-Skala für Eure Spezialisierung. Nicht angehakt: Pawn zeigt stattdessen die Gewichtung des Kompendiums für Eure Spezialisierung, als Skala des Kompendiums, und seine eigenen Skalen bleiben auf diesem Charakter ausgeblendet, bis Ihr dies anhakt."
L.PAWN_ASK = "Pawn ist ebenfalls installiert. Seine Gegenstands-Tooltips und Verbesserungspfeile werden angezeigt.\n\nWessen Wertgewichtung sollen Pawn und die Ausrüstungssuche beide verwenden?\n\nDie des Kompendiums: Pawn zeigt sie für Eure Spezialisierung an und blendet auf diesem Charakter seine eigenen Skalen aus.\nDie von Pawn: Die Ausrüstungssuche verwendet Eure Pawn-Skalen."
L.PAWN_USE_PAWN = "Die von Pawn"
L.PAWN_USE_JOURNAL = "Die des Kompendiums"
L.PAWN_SCALE = "Kompendium: %s"
L.PAWN_RELOAD = "Pawns Verbesserungspfeile in Euren Baganator-Taschen ändern sich erst nach einem Neuladen: Baganator behält Pawns Antworten, bis sich Eure Ausrüstung ändert.\n\nJetzt neu laden?"
L.PAWN_RELOAD_NOW = "Neu laden"
L.PAWN_RELOAD_LATER = "Später"
L.WEIGHTS_SOURCE_PAWN_LIVE = "Pawn-Skala %s. Ändert sie in Pawn oder wählt in den Optionen die Gewichtung des Kompendiums."
L.OPTIONS_MINIMAP_TIP = "Die Schaltfläche des Kompendiums am Rand der Minikarte: Klickt darauf, um das Kompendium zu öffnen; ein Rechtsklick öffnet diese Optionen; zieht sie, um sie zu verschieben."
L.MINIMAP_LEFT_CLICK = "Klickt, um das Kompendium zu öffnen oder zu schließen."
L.MINIMAP_RIGHT_CLICK = "Rechtsklick für die Optionen."
L.MINIMAP_DRAG = "Zieht die Schaltfläche, um sie am Rand der Minikarte zu verschieben."
L.OPTIONS_ARROWS_TIP = "Ein grüner Pfeil auf Gegenständen, die für Eure Spezialisierung Verbesserungen sind, so wie die Ausrüstungssuche sie zählt: in Euren Taschen, im Beutefenster und beim Würfeln um Beute."
L.WEIGHTS_SHOW_GAINS = "Wertgewichtung in Tooltips anzeigen"
L.WEIGHTS_SHOW_GAINS_TIP = "Unter jedem Gegenstand eine Zeile für jede Eurer Spezialisierungen: was der Gegenstand nach ihrer Gewichtung wert ist, und ein grüner Pfeil mit dem, was er Eurer Ausrüstung hinzufügt, wenn er eine Verbesserung ist. Für alle Eure Charaktere. Ist Pawn installiert, blendet dies stattdessen die Skala des Kompendiums in Pawn ein oder aus, und mit ihr Pawns Verbesserungspfeile für die Gewichtung des Kompendiums: Pawn markiert Verbesserungen nur für die Skalen, die es anzeigt."
L.GEAR_WHY_CUSTOM = "%s (Eure Gewichtung)"
-- The specs' names and the units their weights count in, by spec key and by the English unit.
L.GEAR_SPEC_NAMES = {
	Arms = "Waffen", Fury = "Furor", Protection = "Schutz", Holy = "Heilig", Retribution = "Vergeltung",
	BeastMastery = "Tierherrschaft", Marksmanship = "Treffsicherheit", Survival = "Überleben",
	Assassination = "Meucheln", Combat = "Kampf", Subtlety = "Täuschung", Discipline = "Disziplin", Shadow = "Schattenmagie",
	Elemental = "Elementarkampf", Enhancement = "Verstärkung", EnhancementTank = "Verstärkung (Tank)",
	Restoration = "Wiederherstellung", Arcane = "Arkan", Fire = "Feuer", Frost = "Frost", Affliction = "Gebrechen",
	Demonology = "Dämonologie", Destruction = "Zerstörung", Balance = "Gleichgewicht", FeralBear = "Wilder Kampf (Bär)",
	FeralCat = "Wilder Kampf (Katze)",
}
L.GEAR_UNITS = {
	["attack power"] = "Angriffskraft", ["ranged attack power"] = "Distanzangriffskraft",
	["spell damage"] = "Zauberschaden", healing = "Heilung", Stamina = "Ausdauer",
}
L.WEIGHT_GROUPS = {
	PRIMARY = "Primäre Attribute", WEAPONS = "Waffen", SPELLS = "Zauber", DEFENSE = "Verteidigung",
	RESISTANCE = "Widerstände",
}
L.STAT_NAMES = {
	STRENGTH = "Stärke", AGILITY = "Beweglichkeit", STAMINA = "Ausdauer", INTELLECT = "Intelligenz", SPIRIT = "Willenskraft",
	DPS = "Waffenschaden pro Sek.", ["RANGED DPS"] = "Distanzwaffenschaden pro Sek.", ["ATTACK POWER"] = "Angriffskraft",
	["RANGED ATTACK POWER"] = "Distanzangriffskraft", ["FERAL ATTACK POWER"] = "Angriffskraft in Tiergestalt", HIT = "Trefferchance",
	CRIT = "Kritischer Treffer", ["RANGED CRIT"] = "Kritischer Distanztreffer", HASTE = "Angriffstempo", ["RANGED HASTE"] = "Distanztempo",
	["SPELL POWER"] = "Schaden und Heilung", ["SPELL DAMAGE"] = "Zauberschaden", HEALING = "Heilung", ["SPELL HIT"] = "Zaubertrefferchance",
	["SPELL CRIT"] = "Kritischer Zaubertreffer", ["HOLY CRIT"] = "Kritischer Heiligtreffer", ["HOLY DAMAGE"] = "Heiligschaden",
	["FIRE DAMAGE"] = "Feuerschaden", ["FROST DAMAGE"] = "Frostschaden", ["NATURE DAMAGE"] = "Naturschaden",
	["SHADOW DAMAGE"] = "Schattenschaden", ["ARCANE DAMAGE"] = "Arkanschaden", ["SPELL PENETRATION"] = "Zauberdurchschlagskraft",
	MANA = "Mana", ["MANA PER 5"] = "Mana alle 5 Sek.", ["CASTING REGEN"] = "Regeneration beim Zaubern",
	ARMOR = "Rüstung", HEALTH = "Gesundheit", ["HEALTH PER 5"] = "Gesundheit alle 5 Sek.", DEFENSE = "Verteidigung", DODGE = "Ausweichen",
	PARRY = "Parieren", BLOCK = "Blocken", ["BLOCK VALUE"] = "Blockwert",
	["HOLY RESISTANCE"] = "Heiligwiderstand", ["FIRE RESISTANCE"] = "Feuerwiderstand",
	["NATURE RESISTANCE"] = "Naturwiderstand", ["FROST RESISTANCE"] = "Frostwiderstand",
	["SHADOW RESISTANCE"] = "Schattenwiderstand", ["ARCANE RESISTANCE"] = "Arkanwiderstand",
}
L.RECORD_START = "Aufzeichnung starten"
L.RECORD_STOP = "Aufzeichnung beenden"
L.RECORD_CLEAR = "Leeren"
L.RECORD_CLEAR_CONFIRM = "Alles bisher Aufgezeichnete verwerfen? Dies kann nicht rückgängig gemacht werden."
L.RECORD_STATUS_ON = "Aufzeichnung seit %s"
L.RECORD_STATUS_OFF = "Keine Aufzeichnung"
L.RECORD_COMBATLOG = "Kampflog in Dungeons schreiben"
L.RECORD_COMBATLOG_TIP = "Die Fähigkeiten der Bosse stammen aus dem Kampflog des Spiels. Das Kompendium schaltet es in Dungeons ein und beim Verlassen wieder aus; ein Log, das Ihr selbst gestartet habt, bleibt unberührt. Um es einzusenden, fügt die Logdatei auf der Seite des Log Readers Eurer Aufzeichnung hinzu (Kopieren zeigt den Link)."
L.RECORD_RECENT = "Zuletzt"
L.RECORD_NOTHING_YET = "Noch nichts erfasst. Betretet mit eingeschalteter Aufzeichnung einen Dungeon und kämpft, plündert und erledigt Quests wie immer."
L.RECORD_STARTED = "Aufzeichnung gestartet. /aegis record beendet sie."
L.RECORD_STOPPED = "Aufzeichnung beendet."
L.RECORD_LOG_STARTED = "Aufzeichnung gestartet."
L.RECORD_LOG_STOPPED = "Aufzeichnung beendet."
L.RECORD_LOG_CLEARED = "Aufzeichnungen gelöscht."
L.RECORD_LOG_ENTERED = "%s betreten."
L.RECORD_LOG_LEFT = "Dungeon verlassen."
L.RECORD_LOG_AREA = "Neues Gebiet: %s."
L.RECORD_LOG_PULL = "Kampf mit %s begonnen."
L.RECORD_LOG_KILL = "%s getötet."
L.RECORD_LOG_WIPE = "Bei %s gescheitert."
L.RECORD_LOG_LOOT = "Neue Gegenstände erbeutet: %d."
L.RECORD_LOG_QUEST_OFFERED = "Quest angeboten: %s."
L.RECORD_LOG_QUEST_DONE = "Quest abgegeben: %s."
L.RECORD_LOG_ENTRANCE = "Eingang zu %s aufgezeichnet."
L.RECORD_LOG_NO_ENTRANCE = "Eingang zu %s nicht aufgezeichnet: %s."
L.RECORD_NO_MAP = "das Spiel lieferte zu Beginn des Ladebildschirms keine Karte"
L.RECORD_NO_POSITION = "das Spiel lieferte zu Beginn des Ladebildschirms keine Position"
L.RECORD_IN_DUNGEON_MAP = "der Ladebildschirm begann auf der Karte eines Dungeons"
L.RECORD_LOG_COMBATLOG_ON = "Kampflog an: Logs\\%s."
L.RECORD_LOG_COMBATLOG_OFF = "Kampflog aus."

L.LEVEL_RANGE = "Stufe %d-%d"
L.LEVEL_ALL = "Alle Stufen"
L.LEVEL_BRACKET = "Stufe %d bis %d"
L.TRASH_DROPS = "Trash-Beute"
L.UNTESTED = "Noch nicht getestet"
L.UNTESTED_NOTE = "Noch nicht getestet: Was hier steht, stammt aus der Ankündigung von Blizzard und ist womöglich unvollständig. Durchlauft den Dungeon mit eingeschalteter Aufzeichnung (Reiter Aufzeichnen), um Bosse, Beute und Eingang zu ergänzen."
L.COMING_SOON = "Demnächst"
L.COMING_SOON_TEXT = "In WoW: Forever noch nicht geöffnet. Bosse, Beute und Karte kommen hinzu, sobald Spieler ihre Durchläufe aufzeichnen. Habt Ihr einen aufgezeichnet? Postet ihn auf unserem Discord, und Euer Name kommt zu den Mitwirkenden des Kompendiums."
L.COMING_SOON_PARTLY = "In WoW: Forever noch nicht geöffnet: Was hier steht, stammt aus der Ankündigung von Blizzard. Habt Ihr einen Durchlauf aufgezeichnet? Postet ihn auf unserem Discord, und Euer Name kommt zu den Mitwirkenden des Kompendiums."
L.DISCORD_COPY_HINT = "Klicken, dann Strg+C"
L.FOREVER_MARK = "Neu in WoW: Forever"
L.RECORD_LOG_VENDOR = "%s: %d Waren gespeichert, %d davon neu im Kompendium."
L.RECORD_CAUGHT = "%d erfasst, %d neu seit Eurer letzten Kopie"
L.RECORD_COPY = "Kopieren"
L.RECORD_AUTO = "In Dungeons automatisch aufzeichnen"
L.RECORD_AUTO_TIP = "Die Aufzeichnung startet von selbst, wenn Ihr einen Dungeon oder Schlachtzug betretet, und endet, wenn Ihr ihn verlasst. Eine Aufzeichnung, die Ihr selbst gestartet habt, wird nie für Euch beendet."
L.RECORD_RECORDER = "Aufzeichner"
L.RECORD_SEND = "Schickt sie uns"
L.RECORD_HELP_TEXT = "Klickt auf Kopieren und fügt den Text dann in unseren Discord ein:"
L.RECORD_CREDIT = "Mich nennen als:"
L.RECORD_CREDIT_TIP = "Der Name, unter dem Eure Aufzeichnungen bei den Mitwirkenden des Kompendiums genannt werden. Bleibt das Feld leer, ist es der Name Eures Charakters."
L.RECORD_CONTRIBUTORS = "Mitwirkende"
L.RECORD_CONTRIBUTORS_NONE = "Noch niemand: Seid der Erste."
L.RECORD_CONTRIBUTORS_FOOT = "Schickt uns Eure Aufzeichnung: Euer Name erscheint hier."
L.RECORD_COPY_TITLE = "Eure Aufzeichnung als Text"
L.RECORD_COPY_HINT = "Alles ist markiert: Drückt Strg+C und fügt es dann in unseren Discord ein."
L.RECORD_COPY_HINT_LOG = "Drückt Strg+C und fügt es dann zusammen mit Eurem Kampflog (%s, im Ordner Logs des Spiels) im Log Reader ein. Postet das Ergebnis auf unserem Discord."
L.RECORD_MORE_LOGS = "%s und %d ältere"
L.RECORD_BACK = "Zurück"
L.RECORD_CAUGHT_TITLE = "Was Ihr erfasst habt"
L.RECORD_ITEM = "Gegenstand %s"
L.RECORD_ONE_VISIT = "1 Besuch"
L.RECORD_VISITS = "%d Besuche"
L.RECORD_ENTRANCE_YES = "Eingang aufgezeichnet"
L.RECORD_ENTRANCE_NO = "Eingang noch nicht aufgezeichnet"
L.RECORD_AREAS = "%d Gebiete"
L.RECORD_KILLED = "Getötet: %s"
L.RECORD_KILLED_TIMES = "%s (%d)"
L.RECORD_DROPS = "Beute: %s neu, %s bereits im Kompendium"
L.RECORD_OFF = "Von %s"
L.RECORD_OFF_TRASH = "Von Trash-Gegnern"
L.RECORD_OFF_GROUP = "Von Eurer Gruppe geplündert"
L.RECORD_QUESTS = "Quests"
L.RECORD_QUEST_DONE = "abgegeben"
L.RECORD_NEW = "neu"
L.RECORD_QUARTERMASTERS = "Rüstmeister"
L.RECORD_WARES = "%s: %d Waren, %s neu"
L.RECORD_TRAVEL = "Reisepunkte: %d"
L.FOREVER_LINE = "Neu in WoW: Forever."
L.LOCATION_LINE = "Ort: %s"

L.TAB_OVERVIEW = OVERVIEW or "Übersicht"
L.TAB_LOOT = LOOT_NOUN or "Beute"
L.TAB_ABILITIES = ABILITIES or "Fähigkeiten"
L.TAB_MODEL = MODEL or "Modell"
L.TAB_QUESTS = QUESTS_LABEL or "Quests"
L.ALL_CLASSES = ALL_CLASSES or "Alle Klassen"
L.ALL_ARMOR = "Alle Rüstungsarten"
L.ALL_TYPES = "Alle Arten"
-- The loot pages' Type menu: the kinds of item, "All ..." atop the two with a submenu, and one of each.
L.LOOT_KIND = {
	EQUIPMENT = "Ausrüstung", RECIPE = "Rezepte", CONSUMABLE = "Verbrauchsgüter", MOUNT = "Reittiere", PET = "Haustiere",
	TOY = "Spielzeuge", BAG = "Taschen", TRADE = "Handwerkswaren", QUEST = "Questgegenstände", OTHER = "Sonstiges",
}
L.LOOT_KIND_ALL = { EQUIPMENT = "Gesamte Ausrüstung", RECIPE = "Alle Rezepte" }
L.LOOT_KIND_ONE = { MOUNT = "Reittier", PET = "Haustier", TOY = "Spielzeug" }
L.LOOT_RECIPE = "Rezept"
L.LOOT_FAVORITES = "Favoriten"
L.LOOT_FAVORITES_ONLY = "Nur Favoriten"
L.LOOT_FAVORITE = "Zu Favoriten hinzufügen"
L.LOOT_UNFAVORITE = "Aus Favoriten entfernen"
L.LOOT_PINNED = "Angeheftet"
L.LOOT_ALL = "Beute"
L.LOOT_TRASH = "Dungeon-Trash"
L.LEGEND_CLICK_HIDE = "Klickt, um diese auf der Karte auszublenden."
L.LEGEND_CLICK_SHOW = "Ausgeblendet. Klickt, um diese wieder auf der Karte anzuzeigen."
L.LEGEND_GAME_FILTER = "Der eigene Kartenfilter des Spiels, wie im Filtermenü der Karte: Laufende und abgabebereite Quests teilen sich einen."
L.PREPARE_TITLE = "Vor dem Aufbruch"
L.PREPARE_PROGRESS = "Ihr habt %d seiner %d Quests erledigt."
L.PREPARE_HAVE = "Bereits in Eurem Besitz."
L.PREPARE_QUEST_HINT = "Klickt, um sie im Reiter Quests zu sehen."
L.QUESTS_DUNGEON = "Dungeonquests"
L.TRASH = "Trash"
L.TRASH_DESCRIPTION = "Was die übrigen Kreaturen des Dungeons fallen lassen und wissenswert ist: seltene und epische Ausrüstung, Rezepte und Questgegenstände."
L.LOOT_BOSS_LINE = BOSS_INFO_STRING or "Boss: %s"
L.LOOT_FILTER_BAR = "Filter: %s"
L.LOOT_RETRIEVING = RETRIEVING_ITEM_INFO or "Gegenstandsinformationen werden abgerufen"
L.LOOT_NO_DATA = "Gegenstand %d"
L.LOOT_NO_DATA_TOOLTIP = "Der Server hat die Details dieses Gegenstands nicht gesendet. Vielleicht gibt es ihn noch nicht im Spiel."
L.LOOT_UNIDENTIFIED_TOOLTIP = "Noch nicht identifiziert: Seine Quelle nennt ihn, aber nicht seine Gegenstands-ID. Plündert ihn während einer Aufzeichnung, um ihn hinzuzufügen."
L.LOOT_TOOLTIP_PIN = "Rechtsklick, um diesen Gegenstand oben in dieser Liste anzuheften."
L.LOOT_TOOLTIP_UNPIN = "Rechtsklick zum Lösen."
L.LOOT_NONE = "Hierfür ist noch keine Beute bekannt."
L.LOOT_NO_MATCH = "Nichts hier passt zu den Filtern. Setzt sie mit dem X oben zurück."
L.ABILITY_LOADING = RETRIEVING_DATA or "Daten werden abgerufen..."
L.ABILITIES_NONE = "Für diese Begegnung sind noch keine Fähigkeiten bekannt. Zeichnet über den Reiter Aufzeichnen einen Durchlauf auf, um sie zu erfassen."
L.STATS_HIT = "Trifft %s"
L.STATS_TICK = "tickt %s"
L.STATS_FIRST = "erstmals nach %d Sek."
L.STATS_EVERY = "dann alle %s Sek."
L.QUEST_NONE = "Für Eure Fraktion sind in diesem Dungeon keine Quests bekannt."
L.QUEST_STATUS_READY = "Abgeschlossen: bereit zur Abgabe"
L.QUEST_STATUS_NEEDS = "Benötigt: %s"
L.QUEST_STATUS_LEVEL = "Benötigt Stufe %d"
L.QUEST_DESCRIPTION = QUEST_DESCRIPTION or "Beschreibung"
L.QUEST_START_ITEM = "Beginnt mit:"
L.QUEST_PARTS = "%s (%d Teile)"
L.QUEST_PARTS_DONE = "%d von %d Teilen dieser Questreihe erledigt."
L.QUEST_SHOW_START = "Anfang zeigen"
L.QUEST_SHOW_END = "Ende zeigen"
L.QUEST_PLACE_UNKNOWN = "Ort noch nicht bekannt. Nehmt diese Quest an oder gebt sie ab, während die Aufzeichnung läuft, um ihn hinzuzufügen."
L.QUEST_OFFERED_BY = "Quest vergeben von %s"
L.QUEST_HAND_IN_TO = "Abgeben bei %s"
L.QUESTMAP_DUNGEON_QUEST = "Dungeonquest: %s"
L.QUESTMAP_RAID_QUEST = "Schlachtzugsquest: %s"
L.QUESTMAP_LEFT_CLICK = "Linksklick, um sie im Kompendium zu öffnen"
L.QUESTMAP_WAYPOINT_SET = "Wegpunkt für %s gesetzt."
L.QUESTMAP_ONE_OF = "Nicht immer am selben Ort: an einer von %d Stellen."
L.MAP_ONE_OF = "Nicht immer am selben Ort: an einer von %d Stellen."
L.QUEST_REWARDS = REWARDS or "Belohnungen"
L.QUEST_YOU_RECEIVE = YOU_RECEIVE or "Ihr erhaltet:"
L.QUEST_XP = "%s Erfahrung"
L.QUEST_REPUTATION = "%d Ruf bei %s"
L.QUEST_CHOOSE = REWARD_CHOICES or "Ihr könnt eine dieser Belohnungen auswählen:"
L.QUEST_ALSO = REWARD_ITEMS or "Außerdem erhaltet Ihr:"
L.REP_REWARDS = "%d Belohnungen"
L.REP_REWARD_ONE = "1 Belohnung"
L.REP_ALL_REWARDS = "Belohnungen"
L.REP_UNKNOWN = "Noch nicht begegnet"
L.REP_CARD_CLICK = "Klickt, um die Belohnungen zu sehen."
L.REP_YOUR_STANDING = "Euer Ruf: %s"
L.REP_NOT_MET = "Ihr seid dieser Fraktion noch nicht begegnet."
L.REP_PROGRESS = "%s / %s"
L.REP_QUARTERMASTER = "Rüstmeister: %s"
L.REP_CAPTURE = "Händler erfassen"
L.REP_CAPTURE_TIP = "Geht zum Rüstmeister einer Fraktion, öffnet seinen Laden und klickt dann hierauf. Alles, was er verkauft, wird gespeichert: der Preis jeder Ware, alle weiteren Kosten und der benötigte Ruf. Die Waren kommen sofort zu den Belohnungen ihrer Fraktion und werden mitgeschickt, wenn Ihr im Reiter Aufzeichnen auf Kopieren klickt."
L.REP_CAPTURE_READY = "Laden geöffnet: Klickt auf Händler erfassen."
L.REP_CAPTURE_HINT = "Öffnet den Laden eines Rüstmeisters, um seine Waren zu erfassen."
L.REP_CAPTURED = "%s: %d Waren für %s, %d neu."
L.REP_CAPTURED_NONE = "%s: %d Waren gespeichert; keine erfordert Ruf."
L.REP_CAPTURED_UNKNOWN = "%s: %d Waren erfordern Ruf bei einer Fraktion, die das Spiel nicht nennt; gespeichert, bis eine Ware sie nennt."
L.REP_NOT_CAPTURED = "Noch nicht erfasst"
L.REP_NOT_CAPTURED_TIP = "Den Rüstmeister dieser Fraktion hat noch niemand erfasst."
L.REP_NOT_CAPTURED_TEXT = "Den Rüstmeister dieser Fraktion hat noch niemand erfasst. Sucht einen auf, öffnet seinen Laden und klickt im Reiter Ruf auf Händler erfassen. Postet dann Eure Aufzeichnung auf unserem Discord. Euer Name kommt zu den Mitwirkenden des Kompendiums."
L.REP_LISTED_TIP = "Die Belohnungen stammen aus den Gegenstandsdaten des Spiels und wurden noch nicht bei einem Rüstmeister bestätigt."
L.REP_LISTED_TEXT = "Diese Belohnungen stammen aus den Gegenstandsdaten des Spiels, noch nicht von einem Rüstmeister. Daher haben sie keine Preise, und einige werden womöglich gar nicht verkauft. Sucht einen Rüstmeister dieser Fraktion auf, öffnet seinen Laden und klickt im Reiter Ruf auf Händler erfassen. Postet dann Eure Aufzeichnung auf unserem Discord. Euer Name kommt zu den Mitwirkenden des Kompendiums."
L.REP_COMING_SOON_TEXT = "Neu in WoW: Forever und noch nicht erfasst. Sobald die Fraktion im Spiel ist, sucht ihren Rüstmeister auf, öffnet seinen Laden und klickt im Reiter Ruf auf Händler erfassen. Postet dann Eure Aufzeichnung auf unserem Discord."
L.MAP_SHOW = ENCOUNTER_JOURNAL_SHOW_MAP or "Karte anzeigen"
L.MAP_SHOW_UNEXPLORED = "Unerforschte Gebiete anzeigen"
L.MAP_FILTER_QUESTS = "Verfügbare Quests"
L.MAP_FILTER_DUNGEONS = "Dungeoneingänge"
L.MAP_FILTER_RAIDS = "Schlachtzugseingänge"
L.MAP_FILTER_FLIGHT = "Flugpunkte"
L.MAP_FILTER_CAVES = "Höhleneingänge"
L.MAP_FILTER_TRANSPORT = "Schiffe, Zeppeline, Tiefenbahn und Portale"
L.MAP_PIN_OPEN = "Klickt, um es im Kompendium zu öffnen."
L.MAP_DEFEATED = DUNGEON_ENCOUNTER_DEFEATED or "Besiegt"
L.MAP_LEVEL = "Stufe %d"
L.MAP_FLOOR = "Ebene %d"
L.MAP_GO_TO = "Nach %s"
L.MAP_YOU_ARE_HERE = "Ihr seid hier"
L.ENTRANCE_DUNGEON = LFG_TYPE_DUNGEON or "Dungeon"
L.ENTRANCE_RAID = LFG_TYPE_RAID or "Schlachtzug"
L.ENTRANCE_DUNGEONS = DUNGEONS or "Dungeons"
L.ENTRANCE_RAIDS = RAIDS or "Schlachtzüge"
L.ENTRANCE_LEFT_CLICK = "Linksklick, um das Dungeonkompendium zu öffnen"
L.ENTRANCE_CHOOSE_LEFT_CLICK = "Linksklick, um auszuwählen, was im Dungeonkompendium geöffnet werden soll"
L.ENTRANCE_RIGHT_CLICK = "Rechtsklick, um einen Wegpunkt zu setzen"
L.ENTRANCE_WAYPOINT_SET = "Wegpunkt zum Eingang von %s gesetzt."
L.ENTRANCE_VIA = "Das Portal liegt weiter unten, in %s: Steigt am Höhleneingang hinab."
L.ENTRANCE_WAYPOINT_VIA = "Wegpunkt zum Abstieg nach %s gesetzt, für %s."
L.CAVE_LABEL = "Höhleneingang"
L.CAVE_LEADS_TO = "Der Weg nach %s"
L.CAVE_LEFT_CLICK = "Linksklick, um die Karte von %s zu sehen"
L.CAVE_WAYPOINT_SET = "Wegpunkt zum Abstieg nach %s gesetzt."
L.FLIGHT_POINT = MAP_LEGEND_FLIGHTPOINT or "Flugpunkt"
L.CLICK_FOR_WAYPOINT = "Klickt, um einen Wegpunkt zu setzen"
L.FLIGHT_WAYPOINT_SET = "Wegpunkt zum Flugmeister in %s gesetzt."
L.TRAVEL_KINDS = { boat = "Schiff", zeppelin = "Zeppelin", airship = "Luftschiff", tram = "Tiefenbahn", portal = "Portal" }
L.TRAVEL_FACTIONS = { Alliance = FACTION_ALLIANCE or "Allianz", Horde = FACTION_HORDE or "Horde" }
L.TRAVEL_ROUTE = "%s nach %s"
L.TRAVEL_AND = "%s und %s"
L.TRAVEL_ROUTE_NOTE = "%s: %s"
L.TRAVEL_HELP = "Stellt Euch an einen Anleger, einen Zeppelinturm, eine Bahn oder ein Portal und gebt /aegis travel boat (oder zeppelin, airship, tram, portal) ein, gefolgt vom Ziel, z. B. /aegis travel boat Auberdine. Fügt am Ende alliance, horde oder neutral hinzu, um anzugeben, wem es dient, und in Klammern eine Notiz, wer es benutzen darf, z. B. /aegis travel portal Dalaran (nur Himmelsgeborene). /aegis travel list zeigt, was gespeichert ist; /aegis travel undo nimmt den letzten Eintrag zurück."
L.TRAVEL_NO_POSITION = "Das Spiel liefert hier keine Position, daher wurde nichts gespeichert."
L.TRAVEL_SAVED = "%s bei %s gespeichert. /aegis travel undo nimmt es zurück."
L.TRAVEL_UNDONE = "%s bei %s zurückgenommen."
L.TRAVEL_NOTHING = "Nichts zum Zurücknehmen."
L.TRAVEL_LIST_EMPTY = "Noch keine Reisepunkte gespeichert. Gebt /aegis travel ein, um zu erfahren, wie es geht."
L.TRAVEL_LIST_LINE = "%d. %s bei %s (Karte %d, %.4f, %.4f)"
L.TRAVEL_WAYPOINT_SET = "Wegpunkt zu %s gesetzt."
L.LEGEND_TRANSPORT = "Transportmittel"
L.LEGEND_TRANSPORT_TOOLTIP = "Schiffe, Zeppeline, die Tiefenbahn und Portale. Blau dient der Allianz, Rot der Horde, Gold allen."
L.LEGEND_CAVE_TOOLTIP = "Der Weg in eine Höhle oder hinab auf eine Ebene unterhalb des Gebiets. Klickt auf der Karte darauf, um zu sehen, wohin er führt."
L.SEARCH_SHOW_ALL = SEARCH_RESULTS_SHOW_COUNT or "Alle %d Ergebnisse anzeigen"
L.SEARCH_RESULTS = ENCOUNTER_JOURNAL_SEARCH_RESULTS or "Suchergebnisse für „%s“ (%d)"
L.SEARCH_TYPE_BOSS = "Begegnung"
L.SEARCH_TYPE_ABILITY = "Fähigkeit"
L.SEARCH_TYPE_ITEM = "Gegenstand"
L.SEARCH_TYPE_QUEST = "Quest"
L.SEARCH_TYPE_FACTION = FACTION or "Fraktion"
L.MAP_PIN_CLEAR = "Klickt, um diese Markierung zu entfernen."
L.MAP_PIN_COMBAT = "Die Karte kann im Kampf nicht geöffnet werden."

L.RARE_SUFFIX = " (Selten)"
L.AND_MORE = "und %d weitere"
L.BULLET_AREA = "Anzutreffen in %s."
L.BULLET_RARE = "Ein seltener Gegner: Nicht jeder Durchlauf trifft auf ihn."
L.BULLET_SUMMONED = "Ein versteckter Boss, den Ihr selbst beschwört: Die Notiz oben erklärt, wie."
L.BULLET_LEVEL = "Eine Begegnung der Stufe %d."
L.BULLET_ABILITIES = "Beim Wirken beobachtet: %s."
L.BULLET_LOOT = "Beute: %d Gegenstände, darunter %s."
L.BULLET_ADDS = "Begleitet von %s."
L.ADD_DESCRIPTION = "Kämpft an der Seite von %s."
L.BULLET_NOTHING_YET = "Über diese Begegnung ist noch nichts bekannt."

-- The German client's classic "Equip:" wordings (drafted; check against items in game).
L.EQUIP_PATTERNS = {
	-- Bonuses against undead only, and effects on being struck or on a hit: worth nothing.
	{ "untot", false },
	{ "kritisch.-heilig.-um {n}", "HOLY CRIT" },
	{ "heilig.-kritisch.-um {n}", "HOLY CRIT" },
	{ "kritisch.-zauber.-um {n}", "SPELL CRIT" },
	{ "zauber.-kritisch.-um {n}", "SPELL CRIT" },
	{ "kritisch.-distanz.-um {n}", "RANGED CRIT" },
	{ "distanz.-kritisch.-um {n}", "RANGED CRIT" },
	{ "kritisch.-fernkampf.-um {n}", "RANGED CRIT" },
	{ "fernkampf.-kritisch.-um {n}", "RANGED CRIT" },
	{ "kritisch.-treffer.-um {n}", "CRIT" },
	{ "zauber.-treffen.-um {n}", "SPELL HIT" },
	{ "trefferchance.-zauber.-um {n}", "SPELL HIT" },
	{ "zaubertreffer.-um {n}", "SPELL HIT" },
	{ "trefferchance.-um {n}", "HIT" },
	{ "chance.-zu treffen.-um {n}", "HIT" },
	{ "untot.-um bis zu", false },
	{ "schaden und.-heilung.-um bis zu {n}", { "SPELL POWER", "HEALING" } },
	{ "heilung und.-schaden.-um bis zu {n}", { "SPELL POWER", "HEALING" } },
	{ "heilung.-um bis zu {n}", "HEALING" },
	{ "heiligzauber.-um bis zu {n}", "HOLY DAMAGE" },
	{ "feuerzauber.-um bis zu {n}", "FIRE DAMAGE" },
	{ "frostzauber.-um bis zu {n}", "FROST DAMAGE" },
	{ "naturzauber.-um bis zu {n}", "NATURE DAMAGE" },
	{ "schattenzauber.-um bis zu {n}", "SHADOW DAMAGE" },
	{ "arkanzauber.-um bis zu {n}", "ARCANE DAMAGE" },
	{ "magische.-schaden.-um bis zu {n}", "SPELL DAMAGE" },
	{ "zauber.-schaden.-um bis zu {n}", "SPELL DAMAGE" },
	{ "{n}%%.-mana%-?regeneration", "CASTING REGEN" },
	{ "magiewiderst.-um {n}", "SPELL PENETRATION" },
	{ "zauberdurchschlag.-um {n}", "SPELL PENETRATION" },
	{ "angriffskraft im kampf gegen", false },
	{ "angriffskraft.-gegen", false },
	{ "^%+{n} distanz%-?angriffskraft", "RANGED ATTACK POWER" },
	{ "^%+{n} fernkampf%-?angriffskraft", "RANGED ATTACK POWER" },
	{ "distanz%-?angriffskraft.-um {n}", "RANGED ATTACK POWER" },
	{ "fernkampf%-?angriffskraft.-um {n}", "RANGED ATTACK POWER" },
	{ "^%+{n} angriffskraft.-katze", "FERAL ATTACK POWER" },
	{ "angriffskraft.-katze.-um {n}", "FERAL ATTACK POWER" },
	{ "angriffskraft um {n}.-katze", "FERAL ATTACK POWER" },
	{ "angriffskraft.-um {n}", "ATTACK POWER" },
	{ "%+{n} angriffskraft", "ATTACK POWER" },
	{ "alle 5 sek.-{n}%D-mana", "MANA PER 5" },
	{ "{n} mana.-5 sek", "MANA PER 5" },
	{ "alle 5 sek.-{n}%D-gesundheit", "HEALTH PER 5" },
	{ "stellt.-{n}%D-gesundheit", "HEALTH PER 5" },
	{ "verteidigung %+{n}", "DEFENSE" },
	{ "verteidigung.-um {n}", "DEFENSE" },
	{ "aus%a*weich.-um {n}", "DODGE" },
	{ "parier.-um {n}", "PARRY" },
	{ "blocken.-um {n}", "BLOCK" },
	{ "blockchance.-um {n}", "BLOCK" },
	{ "blockwert[^u].-um {n}", "BLOCK VALUE" },
	{ "angriffstempo.-um {n}", "HASTE" },
	{ "angriffsgeschwindigkeit.-um {n}", "HASTE" },
}

-- The rooms inside dungeons, as the client names them where the player stands: "You are
-- here" and a wing's areas match these (Core/Areas.lua). Unconfirmed ones are listed in
-- the translation's to-check list.
L.AREA_NAMES = {
	["Aku'mai's Lair"] = "Aku'mais Hort",
	["Anvilmar's Rest"] = "Ambossars Ruhestätte",
	["Athenaeum"] = "Athenaeum",
	["Blackrock Stadium"] = "Schwarzfelsstadion",
	["Capital Gardens"] = "Hauptstadtgärten",
	["Cavern of Mists"] = "Nebelhöhle",
	["Chamber of Atonement"] = "Kammer der Buße",
	["Chamber of Battle"] = "Kammer der Schlacht",
	["Chapel Gardens"] = "Kapellengärten",
	["Court of the Highborne"] = "Hof der Hochgeborenen",
	["Crag of the Everliving"] = "Klippe des Ewiglebenden",
	["Crusader's Armory"] = "Waffenkammer der Kreuzfahrer",
	["Crusader's Chapel"] = "Kapelle der Kreuzfahrer",
	["Crusaders' Square"] = "Platz der Kreuzfahrer",
	["Dark Iron Ingress"] = "Zugang der Dunkeleisen",
	["Defias Hideout"] = "Versteck der Defias",
	["Dragonspire Hall"] = "Halle der Drachenspitze",
	["Dreamer's Rock"] = "Fels des Träumers",
	["Elders' Square"] = "Platz der Ältesten",
	["Engineering Labs"] = "Ingenieurslabore",
	["Festival Lane"] = "Festgasse",
	["Footman's Armory"] = "Waffenkammer der Fußsoldaten",
	["Forlorn Cloister"] = "Verlassener Kreuzgang",
	["Gallery of Treasures"] = "Galerie der Schätze",
	["Goblin Foundry"] = "Goblingießerei",
	["Gordok Commons"] = "Gordokplatz",
	["Hall of Champions"] = "Halle der Champions",
	["Halycon's Lair"] = "Halycons Hort",
	["Honor's Tomb"] = "Grab der Ehre",
	["Hordemar City"] = "Stadt Hordemar",
	["Huntsman's Cloister"] = "Kreuzgang des Jägers",
	["King's Square"] = "Königsplatz",
	["Launch Bay"] = "Startbucht",
	["Market Row"] = "Marktgasse",
	["Mast Room"] = "Mastraum",
	["Mok'Doom"] = "Mok'Doom",
	["Moonshrine Ruins"] = "Ruinen des Mondschreins",
	["Moonshrine Sanctum"] = "Sanktum des Mondschreins",
	["Pit of Fangs"] = "Grube der Fänge",
	["Prison of Immol'thar"] = "Gefängnis von Immol'thar",
	["Reliquary of Kings"] = "Reliquiar der Könige",
	["Screaming Gully"] = "Schreiende Schlucht",
	["Skitterweb Tunnels"] = "Huschnetztunnel",
	["Slaughter Square"] = "Schlachthofplatz",
	["Tazz'Alaor"] = "Tazz'Alaor",
	["Tazz'Alor"] = "Tazz'Alor",
	["The Clockwerk Run"] = "Der Uhrwerkgang",
	["The Dormitory"] = "Der Schlafsaal",
	["The Drowned Sacellum"] = "Das Versunkene Sacellum",
	["The Forgotten Pool"] = "Der Vergessene Teich",
	["The Gauntlet"] = "Der Spießrutenlauf",
	["The Hall of Gears"] = "Die Halle der Zahnräder",
	["The Hall of Lights"] = "Die Halle der Lichter",
	["The High Seat"] = "Der Hohe Sitz",
	["The Hoard"] = "Der Hort",
	["The Pool of Ask'ar"] = "Der Teich von Ask'ar",
	["The Rookery"] = "Die Brutstätte",
	["The Scarlet Bastion"] = "Die Scharlachrote Bastion",
	["The Shrine of Eldretharr"] = "Der Schrein von Eldretharr",
	["The Slaughter House"] = "Das Schlachthaus",
	["The Storehouse"] = "Das Lagerhaus",
	["Tinkers' Court"] = "Tüftlerhof",
	["Training Grounds"] = "Übungsplatz",
	["Warpwood Quarter"] = "Wucherborkenviertel",
}
