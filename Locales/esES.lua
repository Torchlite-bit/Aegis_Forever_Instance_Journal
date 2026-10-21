local _, ns = ...

--[[
	The journal's interface in Spanish (Spain), for a client set to esES. Drafted by Claude for review
	by a native speaker. It is laid over the English table (Locales/enUS.lua), so every file that
	already holds ns.L sees these strings, and anything not translated here stays English. Every
	other client skips it, the Latin American one (esMX) too: it has its own file and its own words.
	It follows the esES client's terms (mazmorra, banda, misión, botín, intendente, punto de ruta)
	and addresses the player as the client does, with "tú". The Skyborne are "cielonatos", as the
	client names the race (Cielonato de la Orden Eminente, Cielonato Formavientos). The rooms of
	Forever's new dungeons have no official Spanish form yet: they are drafted in the game's style.
]]
-- The journal's words where it speaks this language; the tables matched against the client's own
-- text where the client does, previewed or not (ns.LocaleTargets, Locales/enUS.lua).
local L, client = ns.LocaleTargets("esES")
if not L then return end

L.JOURNAL_TITLE = "Guía de mazmorras"
L.HOME = HOME or "Inicio"
L.TAB_DUNGEONS = DUNGEONS or "Mazmorras"
L.TAB_RAIDS = RAIDS or "Bandas"
L.TAB_REPUTATION = REPUTATION or "Reputación"

L.BINDING_TOGGLE = "Mostrar/ocultar la Guía de mazmorras"
L.KEY_CLAIMED = "Ahora Mayús+J abre la Guía de mazmorras."
L.KEY_TAKEN = "Mayús+J ya está asignada a %s. Elige una tecla en Asignación de teclas > Accesorios > Mostrar/ocultar la Guía de mazmorras."
L.POSITION_RESET = "Se ha restablecido la posición de la ventana."
L.SLASH_HELP = "/aegis (o /ij) abre la guía. /aegis record empieza o detiene la grabación. /aegis reset devuelve la ventana a su sitio original. /aegis perf mide la memoria y la velocidad de la guía. /aegis where y /aegis taxi indican dónde estás y los puntos de vuelo de tu mapa. /aegis travel guarda un barco, zepelín, tranvía o portal para el mapa del mundo. /aegis items busca los objetos de la lista que el servidor no conoce. /aegis gear abre el Buscador de equipo, y /aegis weights, sus pesos de estadísticas; /aegis gearscan guarda lo que lee de tu equipo, para revisar su puntuación. /aegis options abre las opciones de la guía. /aegis lang muestra la guía en otro de sus idiomas, como vista previa."
-- /aegis lang (Core/Init.lua)
L.LANG_USAGE = "/aegis lang de, fr, ru, cn, tw, es, mx, pt o ko muestra la guía en alemán, francés, ruso, chino (simplificado o tradicional), español (España o Latinoamérica), portugués de Brasil o coreano a partir de tu próximo /reload, para revisar una traducción; /aegis lang off vuelve al idioma de tu cliente. Ahora: %s."
L.LANG_SET = "A partir de tu próximo /reload, la guía usará otro idioma (%s), pero solo en sus propios textos: los nombres del juego siguen en el idioma de tu cliente. Escribe /reload ahora; /aegis lang off lo deshace."
L.LANG_OFF = "A partir de tu próximo /reload, la guía vuelve a usar el idioma de tu cliente. Escribe /reload ahora."
L.LANG_FONTS = "El chino necesita las fuentes de un cliente chino: en el tuyo puede que algunos de sus caracteres no se vean."
L.LANG_FONTS_KO = "El coreano necesita las fuentes de un cliente coreano: en el tuyo puede que algunos de sus caracteres no se vean."
L.LANG_ON = "Vista previa de la guía en otro idioma (%s). /aegis lang off la termina."
L.LANG_UNAVAILABLE = "Este cliente cargó la guía antes que su configuración guardada, así que no se ha podido iniciar la vista previa del idioma."
L.ITEMS_START = "Consultando al servidor por los %d objetos que muestra la guía. La respuesta llegará en unos %d segundos; sigue jugando con normalidad."
L.ITEMS_SCANNING = "Aún se está consultando al servidor; la respuesta llegará en un momento."
L.ITEMS_DONE = "De %d objetos, el servidor no sabe nada de %d: lo más probable es que aún no estén en Forever. La guía los oculta hasta que el servidor o un recorrido grabado los confirme. La lista completa se escribirá en el archivo guardado en tu próximo /reload o al cerrar sesión."
L.ITEMS_LINE = "  Objeto %d: %s"
L.ITEMS_MORE = "  ...y %d más."
L.PERF_HEADER = "Rendimiento (memoria en KB, tiempos en milisegundos; cuanto menos, mejor):"
L.PERF_MEMORY = "  %s: %.0f KB"
L.PERF_TIME = "  %s: %.2f ms"
L.PERF_BUILD = "Primera apertura (creación de la ventana)"
L.PERF_BOOK = "Primera mazmorra abierta (creación del libro)"
L.PERF_OPEN = "Abrir y cerrar la guía"
L.PERF_DUNGEON = "Abrir la página de una mazmorra"
L.PERF_TAB = "Cambiar a la pestaña %s"
L.PERF_FACTION = "Abrir la página de una facción"
L.PERF_LOOT = "Volver a dibujar una página de botín"
L.PERF_COMBAT = "La medición espera a que salgas de combate."
L.WHERE = "Mapa %s (%s)  x %.4f  y %.4f  área \"%s\"  minimapa \"%s\"  altura %s"
L.TAXI = "Mapa %s  muestra los puntos de vuelo por sí mismo: %s  puntos de vuelo en él: %d (%d descubiertos)  %s"
L.TAXI_ATLASES = "Iconos de viaje: %s"
L.YES = YES or "Sí"
L.NO = NO or "No"

L.EMPTY_DUNGEONS = "Aún no hay mazmorras con entradas en la guía."
L.EMPTY_RAIDS = "Aún no hay bandas con entradas en la guía."
L.EMPTY_REPUTATION = "Aún no se conoce ninguna recompensa de facción."
L.EMPTY_BRACKET = "No hay nada en este rango de niveles."

L.TAB_RECORD = "Grabar"
L.TAB_GEAR = "Buscador de equipo"

-- The Gear Finder (Core/GearFinder.lua, UI/GearPanel.lua, UI/CharacterTab.lua).
L.GEAR_TITLE = "Buscador de equipo"
L.GEAR_PREVIEW = "Vista previa"
L.GEAR_NO_UPGRADE = "No se ha encontrado ninguna mejora"
L.GEAR_LOOKING = "Buscando en %d mazmorras."
L.GEAR_LOOKING_ONE = "Buscando en 1 mazmorra."
L.GEAR_LOADING = "Aún se están cargando %d objetos."
L.GEAR_LOADING_ONE = "Aún se está cargando 1 objeto."
L.GEAR_SCORING = "Puntuación para"
L.GEAR_AUTO = "Automático: %s"
L.GEAR_WHY_TALENTS = "%s (talentos)"
L.GEAR_WHY_LEVELLING = "%s (subida de nivel)"
L.GEAR_SUGGESTED = "Mazmorra recomendada"
L.GEAR_UPGRADES_HERE = "%d mejoras aquí"
L.GEAR_UPGRADE_HERE = "1 mejora aquí"
L.GEAR_MORE_SLOTS = "y %d más"
L.GEAR_DUNGEON_OF = "%d de %d"
L.GEAR_NONE = "No hay mejoras en las mazmorras cercanas a tu nivel."
L.GEAR_TIP_CLICK = "Haz clic para ver su botín; Mayús+clic para enlazar el objeto."
L.GEAR_TIP_CELL_CLICK = "Haz clic para ver las mayores mejoras; clic derecho para ver su botín."
L.GEAR_TIP_PICK_CLICK = "Haz clic para mostrarlo aquí; clic derecho para ver su botín."
L.GEAR_TIP_PICKED = "Tu elección para esta ranura."
L.GEAR_PICK_TOP = "Las %d mayores de %d mejoras"
L.GEAR_PICK_ALL = "%d mejoras"
L.GEAR_PICK_ONE = "La única mejora"
L.GEAR_PICK_BIGGEST = "Mayor"
L.GEAR_PICK_YOURS = "Tu elección"
L.GEAR_PICK_KEPT = "Las elecciones se guardan para este personaje."
L.GEAR_PICK_CLEAR = "Borrar mi elección"
L.GEAR_TIP_NONE = "No hay ninguna mejora para esta ranura en las mazmorras cercanas a tu nivel."
L.GEAR_CHAR_BUTTON = "Buscador de equipo"
L.GEAR_CHAR_BUTTON_TIP = "Tus pesos de estadísticas y las mayores mejoras que te esperan en las mazmorras de la guía."
L.GEAR_SCAN_DONE = "Análisis de equipo guardado: %d objetos equipados y %d objetos de mazmorras. Cierra sesión o escribe /reload para guardarlo en el archivo."
L.GEAR_SCAN_ERRORS = "No se han podido leer %d objetos; el motivo se guarda con el análisis."
L.GEAR_SCAN_LOADING = "Aún se está cargando parte del botín: espera unos segundos y vuelve a escribir /aegis gearscan para obtener más."
L.GEAR_SLOT_FINGER1 = "Dedo 1"
L.GEAR_SLOT_FINGER2 = "Dedo 2"
L.GEAR_SLOT_TRINKET1 = "Abalorio 1"
L.GEAR_SLOT_TRINKET2 = "Abalorio 2"

-- Stat weights (Core/ItemScore.lua, UI/WeightsEditor.lua).
L.WEIGHTS_TITLE = "Pesos de estadísticas"
L.WEIGHTS_EDIT = "Editar pesos de estadísticas..."
L.WEIGHTS_SOURCE_DEFAULT = "Los pesos de la guía"
L.WEIGHTS_SOURCE_LEVELLING = "Los pesos de la guía, durante la subida de nivel"
L.WEIGHTS_SOURCE_CUSTOM = "Tus propios pesos"
L.WEIGHTS_SOURCE_PAWN = "Tus pesos, de Pawn: %s"
L.WEIGHTS_TIP = "Cuánto vale un punto de cada estadística para esta especialización. Haz clic en un peso para cambiarlo; tus propios pesos se muestran en verde y se guardan para este personaje."
L.WEIGHTS_RESET = "Restablecer"
L.WEIGHTS_RESET_TIP = "Vuelve a los pesos de la guía para esta especialización."
L.WEIGHTS_PAWN = "Pawn..."
L.WEIGHTS_PAWN_TIP = "Importa una escala de Pawn."
L.WEIGHTS_PAWN_HELP = "En Pawn, elige la escala, pulsa Exportar, copia el texto y pégalo aquí."
L.WEIGHTS_IMPORT = "Importar"
L.WEIGHTS_CANCEL = "Cancelar"
L.WEIGHTS_BACK = "Volver"
L.WEIGHTS_OPEN_FINDER = "Abrir el Buscador de equipo"
L.WEIGHTS_IMPORTED = "Se han importado %d pesos de %s."
L.WEIGHTS_UNUSED = "Sin usar: %s."
L.WEIGHTS_NOT_PAWN = "Eso no es una escala de Pawn. En Pawn, pulsa Exportar y copia todo su texto."
L.WEIGHTS_OTHER_CLASS = "Esa escala es para la clase %s, no para la clase de este personaje."
L.WEIGHTS_FOR = "Para"
-- /aegis areas: the client's id for each of the journal's area names (Core/Areas.lua).
L.AREAS_START = "Buscando los identificadores del cliente para los %d nombres de zona de la guía..."
L.AREAS_DONE = "Se han encontrado los identificadores de %d de los %d nombres de zona. Escribe /reload para guardarlos."
L.AREAS_MISSING = "No encontrados: %s."
L.AREAS_SCANNING = "Aún se están buscando los nombres de zona."
L.AREAS_ENGLISH = "Usa /aegis areas en un cliente en inglés: los nombres que busca están en inglés."
-- The journal's page in the game's options (Options > AddOns).
L.OPTIONS_TITLE = "Aegis Instance Journal"
L.OPTIONS_BOSS_LEVELS = "Mostrar el nivel de cada jefe en la lista de jefes"
L.OPTIONS_BOSS_LEVELS_TIP = "Una insignia en el retrato de cada jefe con su nivel, coloreada según lo difícil que es el jefe para ti: gris, verde, amarillo, naranja o rojo."
L.OPTIONS_ARROWS = "Marcar las mejoras con una flecha verde"
L.OPTIONS_MINIMAP = "Mostrar el botón del minimapa"
L.OPTIONS_PAWN_WEIGHTS = "Usar los pesos de estadísticas de Pawn en el Buscador de equipo"
L.OPTIONS_PAWN_WEIGHTS_TIP = "Con Pawn instalado, se muestran sus descripciones emergentes de objetos y sus flechas de mejora. Marcado: el Buscador de equipo puntúa los objetos con tu escala de Pawn para tu especialización. Sin marcar: Pawn muestra en su lugar los pesos de la guía para tu especialización, como una escala de la guía, y sus propias escalas se ocultan en este personaje hasta que marques esta opción."
-- Asked once, when Pawn is installed too (Core/PawnLink.lua).
L.PAWN_ASK = "Pawn también está instalado. Se mostrarán sus descripciones emergentes de objetos y sus flechas de mejora.\n\n¿Qué pesos de estadísticas deben usar Pawn y el Buscador de equipo?\n\nLos de la guía: Pawn los muestra para tu especialización y oculta sus propias escalas en este personaje.\nLos de Pawn: el Buscador de equipo usa tus escalas de Pawn."
L.PAWN_USE_PAWN = "Los de Pawn"
L.PAWN_USE_JOURNAL = "Los de la guía"
-- The journal's scale for a spec, as Pawn lists it.
L.PAWN_SCALE = "Guía: %s"
-- After the journal's scales in Pawn change, where Baganator draws Pawn's arrows.
L.PAWN_RELOAD = "Las flechas de mejora de Pawn en tus bolsas de Baganator solo cambian tras recargar la interfaz: Baganator conserva las respuestas de Pawn hasta que cambia tu equipo.\n\n¿Recargar ahora?"
L.PAWN_RELOAD_NOW = "Recargar"
L.PAWN_RELOAD_LATER = "Más tarde"
L.WEIGHTS_SOURCE_PAWN_LIVE = "Escala %s de Pawn. Cámbiala en Pawn o elige la de la guía en sus opciones."
L.OPTIONS_MINIMAP_TIP = "El botón de la guía en el borde del minimapa: haz clic para abrir la guía, clic derecho para ver estas opciones y arrástralo para moverlo."
-- The minimap button's tooltip.
L.MINIMAP_LEFT_CLICK = "Haz clic para abrir o cerrar la guía."
L.MINIMAP_RIGHT_CLICK = "Clic derecho para ver sus opciones."
L.MINIMAP_DRAG = "Arrástralo para moverlo por el borde del minimapa."
L.OPTIONS_ARROWS_TIP = "Una flecha verde en los objetos que son mejoras para tu especialización, tal como las cuenta el Buscador de equipo: en tus bolsas, en la ventana de botín y en las tiradas de botín."
L.WEIGHTS_SHOW_GAINS = "Mostrar los pesos de estadísticas en las descripciones emergentes"
L.WEIGHTS_SHOW_GAINS_TIP = "Debajo de cada objeto, una línea por cada una de tus especializaciones: lo que vale el objeto según sus pesos y, si es una mejora, una flecha verde con lo que aporta a tu equipo. Para todos tus personajes. Con Pawn instalado, esto muestra u oculta en su lugar la escala de la guía en Pawn y, con ella, las flechas de mejora de Pawn para los pesos de la guía: Pawn solo marca mejoras para las escalas que muestra."
L.OPTIONS_SOURCES = "Mostrar de dónde sale cada objeto en las descripciones emergentes"
L.OPTIONS_SOURCES_TIP = "Debajo de cada objeto que se consigue en las mazmorras y bandas de la guía, una línea con el jefe y la mazmorra: en tus bolsas, en tu personaje, en los enlaces del chat, en los vendedores y en cualquier otro lugar donde el juego muestre el objeto. Para todos tus personajes."
L.GEAR_WHY_CUSTOM = "%s (tus pesos)"
-- The specs' names (the esES client's talent trees) and the units their weights count in, by spec
-- key and by the English unit.
L.GEAR_SPEC_NAMES = {
	Arms = "Armas", Fury = "Furia", Protection = "Protección", Holy = "Sagrado", Retribution = "Reprensión",
	BeastMastery = "Dominio de bestias", Marksmanship = "Puntería", Survival = "Supervivencia",
	Assassination = "Asesinato", Combat = "Combate", Subtlety = "Sutileza", Discipline = "Disciplina", Shadow = "Sombra",
	Elemental = "Elemental", Enhancement = "Mejora", EnhancementTank = "Mejora (tanque)",
	Restoration = "Restauración", Arcane = "Arcano", Fire = "Fuego", Frost = "Escarcha", Affliction = "Aflicción",
	Demonology = "Demonología", Destruction = "Destrucción", Balance = "Equilibrio", FeralBear = "Combate feral (oso)",
	FeralCat = "Combate feral (felino)",
}
L.GEAR_UNITS = {
	["attack power"] = "poder de ataque", ["ranged attack power"] = "poder de ataque a distancia",
	["spell damage"] = "daño con hechizos", healing = "curación", Stamina = "Aguante",
}
L.WEIGHT_GROUPS = {
	PRIMARY = "Atributos principales", WEAPONS = "Armas", SPELLS = "Hechizos", DEFENSE = "Defensa",
	RESISTANCE = "Resistencias",
}
L.STAT_NAMES = {
	STRENGTH = "Fuerza", AGILITY = "Agilidad", STAMINA = "Aguante", INTELLECT = "Intelecto", SPIRIT = "Espíritu",
	DPS = "DPS del arma", ["RANGED DPS"] = "DPS del arma a distancia", ["ATTACK POWER"] = "Poder de ataque",
	["RANGED ATTACK POWER"] = "Poder de ataque a distancia", ["FERAL ATTACK POWER"] = "Poder de ataque feral", HIT = "Golpe",
	CRIT = "Golpe crítico", ["RANGED CRIT"] = "Crítico a distancia", HASTE = "Velocidad de ataque", ["RANGED HASTE"] = "Velocidad a distancia",
	["SPELL POWER"] = "Daño y curación", ["SPELL DAMAGE"] = "Daño con hechizos", HEALING = "Curación", ["SPELL HIT"] = "Golpe con hechizos",
	["SPELL CRIT"] = "Crítico con hechizos", ["HOLY CRIT"] = "Crítico Sagrado", ["HOLY DAMAGE"] = "Daño Sagrado",
	["FIRE DAMAGE"] = "Daño de Fuego", ["FROST DAMAGE"] = "Daño de Escarcha", ["NATURE DAMAGE"] = "Daño de Naturaleza",
	["SHADOW DAMAGE"] = "Daño de Sombras", ["ARCANE DAMAGE"] = "Daño Arcano", ["SPELL PENETRATION"] = "Penetración de hechizos",
	MANA = "Maná", ["MANA PER 5"] = "Maná cada 5 s", ["CASTING REGEN"] = "Regen. al lanzar hechizos",
	ARMOR = "Armadura", HEALTH = "Salud", ["HEALTH PER 5"] = "Salud cada 5 s", DEFENSE = "Defensa", DODGE = "Esquivar",
	PARRY = "Parar", BLOCK = "Bloquear", ["BLOCK VALUE"] = "Valor de bloqueo",
	["HOLY RESISTANCE"] = "Resistencia a lo Sagrado", ["FIRE RESISTANCE"] = "Resistencia al Fuego",
	["NATURE RESISTANCE"] = "Resistencia a la Naturaleza", ["FROST RESISTANCE"] = "Resistencia a la Escarcha",
	["SHADOW RESISTANCE"] = "Resistencia a las Sombras", ["ARCANE RESISTANCE"] = "Resistencia a lo Arcano",
}
L.RECORD_START = "Empezar a grabar"
L.RECORD_STOP = "Dejar de grabar"
L.RECORD_CLEAR = "Borrar"
L.RECORD_CLEAR_CONFIRM = "¿Descartar todo lo grabado hasta ahora? No se puede deshacer."
L.RECORD_STATUS_ON = "Grabando desde %s"
L.RECORD_STATUS_OFF = "Sin grabar"
L.RECORD_COMBATLOG = "Escribir el registro de combate en las mazmorras"
L.RECORD_COMBATLOG_TIP = "Las habilidades de los jefes salen del registro de combate del juego. La guía lo activa dentro de las mazmorras y lo vuelve a desactivar al salir; si lo has activado tú, no lo toca. Para enviarlo, añade el archivo del registro a tu grabación en la página del Log Reader (Copiar muestra el enlace)."
L.RECORD_RECENT = "Reciente"
L.RECORD_NOTHING_YET = "Aún no se ha registrado nada. Entra en una mazmorra con la grabación activada y mata, despoja y haz misiones como siempre."
L.RECORD_STARTED = "Grabación iniciada. /aegis record la detiene."
L.RECORD_STOPPED = "Grabación detenida."
L.RECORD_LOG_STARTED = "Grabación iniciada."
L.RECORD_LOG_STOPPED = "Grabación detenida."
L.RECORD_LOG_CLEARED = "Grabaciones borradas."
L.RECORD_LOG_ENTERED = "Has entrado en %s."
L.RECORD_LOG_LEFT = "Has salido de la mazmorra."
L.RECORD_LOG_AREA = "Nueva zona: %s."
L.RECORD_LOG_PULL = "Combate iniciado con %s."
L.RECORD_LOG_KILL = "Has matado a %s."
L.RECORD_LOG_WIPE = "Derrota ante %s."
L.RECORD_LOG_LOOT = "Botín: %d objetos nuevos."
L.RECORD_LOG_QUEST_OFFERED = "Misión ofrecida: %s."
L.RECORD_LOG_QUEST_DONE = "Misión entregada: %s."
L.RECORD_LOG_ENTRANCE = "Entrada de %s grabada."
L.RECORD_LOG_NO_ENTRANCE = "Entrada de %s sin grabar: %s."
L.RECORD_NO_MAP = "el juego no dio ningún mapa al empezar la pantalla de carga"
L.RECORD_NO_POSITION = "el juego no dio ninguna posición al empezar la pantalla de carga"
L.RECORD_IN_DUNGEON_MAP = "la pantalla de carga empezó en el mapa de una mazmorra"
L.RECORD_LOG_COMBATLOG_ON = "Registro de combate activado: Logs\\%s."
L.RECORD_LOG_COMBATLOG_OFF = "Registro de combate desactivado."

L.LEVEL_RANGE = "Nivel %d-%d"
L.LEVEL_ALL = "Todos los niveles"
L.LEVEL_BRACKET = "Niveles %d a %d"
L.TRASH_DROPS = "Botín de enemigos menores"
L.UNTESTED = "Aún sin probar"
L.UNTESTED_NOTE = "Aún sin probar: lo que aparece aquí procede del anuncio de Blizzard y puede estar incompleto. Recórrela con la pestaña Grabar activada para completar sus jefes, su botín y su entrada."
L.COMING_SOON = "Próximamente"
L.COMING_SOON_TEXT = "Aún no está abierta en WoW: Forever. Sus jefes, su botín y su mapa se irán añadiendo a medida que los jugadores graben sus recorridos. ¿Has grabado uno? Publícalo en nuestro Discord y tu nombre aparecerá entre los colaboradores de la guía."
L.COMING_SOON_PARTLY = "Aún no está abierta en WoW: Forever: lo que aparece aquí procede del anuncio de Blizzard. ¿Has grabado un recorrido? Publícalo en nuestro Discord y tu nombre aparecerá entre los colaboradores de la guía."
L.DISCORD_COPY_HINT = "Haz clic y luego Ctrl+C"
L.FOREVER_MARK = "Novedad de WoW: Forever"
L.RECORD_LOG_VENDOR = "%s: %d artículos guardados, %d nuevos para la guía."
L.RECORD_CAUGHT = "%d registrados, %d nuevos desde tu última copia"
L.RECORD_COPY = "Copiar"
L.RECORD_AUTO = "Grabar automáticamente en las mazmorras"
L.RECORD_AUTO_TIP = "La grabación empieza sola al entrar en una mazmorra o una banda, y se detiene al salir. Una grabación que hayas iniciado tú nunca se detiene sola."
L.RECORD_RECORDER = "Grabadora"
L.RECORD_SEND = "Envíanosla"
L.RECORD_HELP_TEXT = "Pulsa Copiar y pega el texto en nuestro Discord:"
L.RECORD_CREDIT = "Mencionarme como:"
L.RECORD_CREDIT_TIP = "El nombre con el que aparecen tus grabaciones entre los colaboradores de la guía. Si lo dejas vacío, será el nombre de tu personaje."
L.RECORD_CONTRIBUTORS = "Colaboradores"
L.RECORD_CONTRIBUTORS_NONE = "Todavía nadie: sé el primero."
L.RECORD_CONTRIBUTORS_FOOT = "Envía la tuya: tu nombre aparecerá aquí."
L.RECORD_COPY_TITLE = "Tu grabación, en texto"
L.RECORD_COPY_HINT = "Ya está todo seleccionado: pulsa Ctrl+C y pégalo en nuestro Discord."
L.RECORD_COPY_HINT_LOG = "Pulsa Ctrl+C y pégalo en el Log Reader junto con tu registro de combate (%s, en la carpeta Logs del juego). Publica lo que te devuelva en nuestro Discord."
L.RECORD_MORE_LOGS = "%s y %d más antiguos"
L.RECORD_BACK = "Volver"
L.RECORD_CAUGHT_TITLE = "Lo que has registrado"
L.RECORD_ITEM = "Objeto %s"
L.RECORD_ONE_VISIT = "1 visita"
L.RECORD_VISITS = "%d visitas"
L.RECORD_ENTRANCE_YES = "entrada grabada"
L.RECORD_ENTRANCE_NO = "entrada aún sin grabar"
L.RECORD_AREAS = "%d zonas"
L.RECORD_KILLED = "Abatidos: %s"
L.RECORD_KILLED_TIMES = "%s (%d)"
L.RECORD_DROPS = "Botín: %s nuevos, %s ya en la guía"
L.RECORD_OFF = "De %s"
L.RECORD_OFF_TRASH = "De enemigos menores"
L.RECORD_OFF_GROUP = "Despojado por tu grupo"
L.RECORD_QUESTS = "Misiones"
L.RECORD_QUEST_DONE = "entregada"
L.RECORD_NEW = "nuevo"
L.RECORD_QUARTERMASTERS = "Intendentes"
L.RECORD_WARES = "%s: %d artículos, %s nuevos"
L.RECORD_TRAVEL = "Puntos de viaje: %d"
L.FOREVER_LINE = "Novedad de WoW: Forever."
L.LOCATION_LINE = "Ubicación: %s"

L.TAB_OVERVIEW = OVERVIEW or "Información general"
L.TAB_LOOT = LOOT_NOUN or "Botín"
L.TAB_ABILITIES = ABILITIES or "Habilidades"
L.TAB_MODEL = MODEL or "Modelo"
L.TAB_QUESTS = QUESTS_LABEL or "Misiones"
L.ALL_CLASSES = ALL_CLASSES or "Todas las clases"
L.ALL_ARMOR = "Todas las armaduras"
L.ALL_TYPES = "Todos los tipos"
-- The loot pages' Type menu: the kinds of item, "All ..." atop the two with a submenu, and one of each.
L.LOOT_KIND = {
	EQUIPMENT = "Equipo", RECIPE = "Recetas", CONSUMABLE = "Consumibles", MOUNT = "Monturas", PET = "Mascotas",
	TOY = "Juguetes", BAG = "Bolsas", TRADE = "Objetos comerciables", QUEST = "Objetos de misión", OTHER = "Otros",
}
L.LOOT_KIND_ALL = { EQUIPMENT = "Todo el equipo", RECIPE = "Todas las recetas" }
L.LOOT_KIND_ONE = { MOUNT = "Montura", PET = "Mascota", TOY = "Juguete" }
L.LOOT_RECIPE = "Receta"
L.LOOT_FAVORITES = "Favoritos"
L.LOOT_FAVORITES_ONLY = "Solo favoritos"
L.LOOT_FAVORITE = "Añadir a favoritos"
L.LOOT_UNFAVORITE = "Quitar de favoritos"
L.LOOT_PINNED = "Fijados"
L.LOOT_ALL = "Botín"
L.LOOT_TRASH = "Enemigos menores de la mazmorra"
L.DROPS_FROM_BOSS = "Botín de %s (%s)"
L.DROPS_FROM_TRASH = "Botín de enemigos menores (%s)"
L.DROPS_FROM_BOSSES = "Botín de %d jefes (%s)"
L.DROPS_IN = "Botín en: %s"
L.DROPS_ALSO_IN = "También botín en: %s"
-- The world map legend's entries, each a switch (UI/MapLegend.lua).
L.LEGEND_CLICK_HIDE = "Haz clic para ocultarlos en el mapa."
L.LEGEND_CLICK_SHOW = "Ocultos. Haz clic para volver a mostrarlos en el mapa."
L.LEGEND_GAME_FILTER = "El filtro de mapa del propio juego, como en el menú de filtros del mapa: las misiones en curso y las listas para entregar comparten uno."
-- Before you go, on a dungeon's overview: its key and the quests to it, a hidden boss to prepare for.
L.PREPARE_TITLE = "Antes de ir"
L.PREPARE_PROGRESS = "Has completado %d de sus %d misiones."
L.PREPARE_HAVE = "Ya está en tu poder."
L.PREPARE_QUEST_HINT = "Haz clic para verla en la pestaña Misiones."
-- The Quests tab's dropdown of the dungeon's own quests (after its key, if it has one).
L.QUESTS_DUNGEON = "Misiones de la mazmorra"
-- The trash's entry in a dungeon's boss list, and its page.
L.TRASH = "Enemigos menores"
L.TRASH_DESCRIPTION = "Lo que sueltan las demás criaturas de la mazmorra y merece la pena conocer: equipo raro y épico, recetas y objetos de misión."
L.LOOT_BOSS_LINE = BOSS_INFO_STRING or "Jefe: %s"
L.LOOT_FILTER_BAR = "Filtro: %s"
L.LOOT_RETRIEVING = RETRIEVING_ITEM_INFO or "Recuperando información del objeto"
L.LOOT_NO_DATA = "Objeto %d"
L.LOOT_NO_DATA_TOOLTIP = "El servidor no ha enviado los detalles de este objeto. Puede que aún no esté en el juego."
L.LOOT_UNIDENTIFIED_TOOLTIP = "Aún sin identificar: su fuente lo nombra, pero no da su ID de objeto. Despójalo mientras grabas para añadirlo."
L.LOOT_TOOLTIP_PIN = "Clic derecho para fijar este objeto arriba del todo en esta lista."
L.LOOT_TOOLTIP_UNPIN = "Clic derecho para dejar de fijarlo."
L.LOOT_NONE = "Aún no se conoce ningún botín para esto."
L.LOOT_NO_MATCH = "Nada coincide con los filtros. Bórralos con la X de arriba."
L.ABILITY_LOADING = RETRIEVING_DATA or "Recuperando datos..."
L.ABILITIES_NONE = "Aún no se conocen habilidades de este encuentro. Graba un recorrido desde la pestaña Grabar para registrarlas."
L.STATS_HIT = "Inflige %s"
L.STATS_TICK = "%s por pulso"
L.STATS_FIRST = "primer lanzamiento a los %d s"
L.STATS_EVERY = "luego cada %s s"
L.QUEST_NONE = "No se conocen misiones de tu facción para esta mazmorra."
L.QUEST_STATUS_READY = "Completada: lista para entregar"
L.QUEST_STATUS_NEEDS = "Requiere: %s"
L.QUEST_STATUS_LEVEL = "Requiere nivel %d"
L.QUEST_DESCRIPTION = QUEST_DESCRIPTION or "Descripción"
L.QUEST_START_ITEM = "Empieza con:"
L.QUEST_PARTS = "%s (%d partes)"
L.QUEST_PARTS_DONE = "%d de %d partes de esta cadena completadas."
L.QUEST_SHOW_START = "Mostrar inicio"
L.QUEST_SHOW_END = "Mostrar final"
L.QUEST_PLACE_UNKNOWN = "Ubicación aún desconocida. Acepta o entrega esta misión con la pestaña Grabar activada para añadirla."
L.QUEST_OFFERED_BY = "Misión ofrecida por %s"
L.QUEST_HAND_IN_TO = "Entregar a %s"
L.QUESTMAP_DUNGEON_QUEST = "Misión de mazmorra: %s"
L.QUESTMAP_RAID_QUEST = "Misión de banda: %s"
L.QUESTMAP_LEFT_CLICK = "Clic izquierdo para abrirla en la guía"
L.QUESTMAP_WAYPOINT_SET = "Punto de ruta fijado para %s."
L.QUESTMAP_ONE_OF = "No siempre está en el mismo sitio: aparece en uno de %d lugares."
L.MAP_ONE_OF = "No siempre está en el mismo sitio: aparece en uno de %d lugares."
L.QUEST_REWARDS = REWARDS or "Recompensas"
L.QUEST_YOU_RECEIVE = YOU_RECEIVE or "Recibirás:"
L.QUEST_XP = "%s de experiencia"
L.QUEST_REPUTATION = "%d de reputación con %s"
L.QUEST_CHOOSE = REWARD_CHOICES or "Podrás elegir una de estas recompensas:"
L.QUEST_ALSO = REWARD_ITEMS or "También recibirás:"
L.REP_REWARDS = "%d recompensas"
L.REP_REWARD_ONE = "1 recompensa"
L.REP_ALL_REWARDS = "Recompensas"
L.REP_UNKNOWN = "Desconocida"
L.REP_CARD_CLICK = "Haz clic para ver sus recompensas."
L.REP_YOUR_STANDING = "Tu reputación: %s"
L.REP_NOT_MET = "Aún no conoces a esta facción."
L.REP_PROGRESS = "%s / %s"
L.REP_QUARTERMASTER = "Intendente: %s"
L.REP_CAPTURE = "Capturar vendedor"
L.REP_CAPTURE_TIP = "Acércate a un intendente de reputación, abre su tienda y pulsa este botón. Se guarda todo lo que vende: el precio de cada artículo, cualquier otro coste y la reputación que exige. Los artículos se añaden al momento a las recompensas de su facción y se incluyen al pulsar Copiar en la pestaña Grabar."
L.REP_CAPTURE_READY = "Tienda abierta: pulsa Capturar vendedor."
L.REP_CAPTURE_HINT = "Abre la tienda de un intendente para capturar sus artículos."
L.REP_CAPTURED = "%s: %d artículos para %s, %d nuevos."
L.REP_CAPTURED_NONE = "%s: %d artículos guardados; ninguno exige reputación."
L.REP_CAPTURED_UNKNOWN = "%s: %d artículos exigen reputación con una facción que el juego no nombra; se guardan hasta que algún artículo la nombre."
L.REP_NOT_CAPTURED = "Aún sin capturar"
L.REP_NOT_CAPTURED_TIP = "Nadie ha capturado todavía al intendente de esta facción."
L.REP_NOT_CAPTURED_TEXT = "Nadie ha capturado todavía al intendente de esta facción. Busca uno, abre su tienda y pulsa Capturar vendedor en la pestaña Reputación; después publica tu grabación en nuestro Discord. Tu nombre aparecerá entre los colaboradores de la guía."
L.REP_LISTED_TIP = "Sus recompensas proceden de los datos de objetos del juego y aún no se han confirmado con un intendente."
L.REP_LISTED_TEXT = "Estas recompensas proceden de los datos de objetos del juego, aún no de un intendente, así que no tienen precio y puede que algunas ni siquiera estén a la venta. Busca a uno de los intendentes de esta facción, abre su tienda y pulsa Capturar vendedor en la pestaña Reputación; después publica tu grabación en nuestro Discord. Tu nombre aparecerá entre los colaboradores de la guía."
L.REP_COMING_SOON_TEXT = "Novedad de WoW: Forever, aún sin capturar. Cuando esté en el juego, busca a su intendente, abre su tienda y pulsa Capturar vendedor en la pestaña Reputación; después publica tu grabación en nuestro Discord."
L.MAP_SHOW = ENCOUNTER_JOURNAL_SHOW_MAP or "Mostrar mapa"
L.MAP_SHOW_UNEXPLORED = "Mostrar zonas sin explorar"
-- The map legend's switches, in the map's filter menu too (UI/ZoneMap.lua).
L.MAP_FILTER_QUESTS = "Misiones disponibles"
L.MAP_FILTER_DUNGEONS = "Entradas de mazmorra"
L.MAP_FILTER_RAIDS = "Entradas de banda"
L.MAP_FILTER_FLIGHT = "Puntos de vuelo"
L.MAP_FILTER_CAVES = "Entradas de cueva"
L.MAP_FILTER_TRANSPORT = "Barcos, zepelines, tranvía y portales"
L.MAP_PIN_OPEN = "Haz clic para abrirlo en la guía."
L.MAP_DEFEATED = DUNGEON_ENCOUNTER_DEFEATED or "Derrotado"
L.MAP_LEVEL = "Nivel %d"
L.MAP_FLOOR = "Planta %d"
L.MAP_GO_TO = "Hacia %s"
L.MAP_YOU_ARE_HERE = "Estás aquí"
L.ENTRANCE_DUNGEON = LFG_TYPE_DUNGEON or "Mazmorra"
L.ENTRANCE_RAID = LFG_TYPE_RAID or "Banda"
L.ENTRANCE_DUNGEONS = DUNGEONS or "Mazmorras"
L.ENTRANCE_RAIDS = RAIDS or "Bandas"
L.ENTRANCE_LEFT_CLICK = "Clic izquierdo para abrir la Guía de mazmorras"
L.ENTRANCE_CHOOSE_LEFT_CLICK = "Clic izquierdo para elegir cuál abrir en la Guía de mazmorras"
L.ENTRANCE_RIGHT_CLICK = "Clic derecho para fijar un punto de ruta"
L.ENTRANCE_WAYPOINT_SET = "Punto de ruta fijado en la entrada de %s."
L.ENTRANCE_VIA = "Su portal está más abajo, en %s: baja por la entrada de la cueva."
L.ENTRANCE_WAYPOINT_VIA = "Punto de ruta fijado en la bajada a %s, para %s."
L.CAVE_LABEL = "Entrada de cueva"
L.CAVE_LEADS_TO = "El camino a %s"
L.CAVE_LEFT_CLICK = "Clic izquierdo para ver el mapa de %s"
L.CAVE_WAYPOINT_SET = "Punto de ruta fijado en la bajada a %s."
L.FLIGHT_POINT = MAP_LEGEND_FLIGHTPOINT or "Punto de vuelo"
L.CLICK_FOR_WAYPOINT = "Haz clic para fijar un punto de ruta"
L.FLIGHT_WAYPOINT_SET = "Punto de ruta fijado en el maestro de vuelo de %s."
L.TRAVEL_KINDS = { boat = "Barco", zeppelin = "Zepelín", airship = "Aeronave", tram = "Tranvía", portal = "Portal" }
L.TRAVEL_FACTIONS = { Alliance = FACTION_ALLIANCE or "Alianza", Horde = FACTION_HORDE or "Horda" }
L.TRAVEL_ROUTE = "%s a %s"
L.TRAVEL_AND = "%s y %s"
L.TRAVEL_ROUTE_NOTE = "%s: %s"
L.TRAVEL_HELP = "Colócate en un muelle, una torre de zepelines, un tranvía o un portal y escribe /aegis travel boat (o zeppelin, airship, tram, portal) seguido de su destino, p. ej. /aegis travel boat Auberdine. Añade alliance, horde o neutral al final para indicar a quién sirve, y una nota entre paréntesis para indicar quién puede usarlo, p. ej. /aegis travel portal Dalaran (solo cielonatos). /aegis travel list muestra lo guardado; /aegis travel undo deshace lo último."
L.TRAVEL_NO_POSITION = "El juego no da ninguna posición aquí, así que no se ha guardado nada."
L.TRAVEL_SAVED = "Se ha guardado %s en %s. /aegis travel undo lo deshace."
L.TRAVEL_UNDONE = "Se ha deshecho %s en %s."
L.TRAVEL_NOTHING = "No hay nada que deshacer."
L.TRAVEL_LIST_EMPTY = "Aún no hay puntos de viaje guardados. Escribe /aegis travel para ver cómo hacerlo."
L.TRAVEL_LIST_LINE = "%d. %s en %s (mapa %d, %.4f, %.4f)"
L.TRAVEL_WAYPOINT_SET = "Punto de ruta fijado en %s."
L.LEGEND_TRANSPORT = "Transporte"
L.LEGEND_TRANSPORT_TOOLTIP = "Barcos, zepelines, el tranvía y portales. El azul sirve a la Alianza, el rojo a la Horda y el dorado a todos."
L.LEGEND_CAVE_TOOLTIP = "El camino a una cueva o a un nivel inferior de la zona. Haz clic en él en el mapa para ver adónde lleva."
L.SEARCH_SHOW_ALL = SEARCH_RESULTS_SHOW_COUNT or "Mostrar los %d resultados"
L.SEARCH_RESULTS = ENCOUNTER_JOURNAL_SEARCH_RESULTS or "Resultados de búsqueda de \"%s\" (%d)"
L.SEARCH_TYPE_BOSS = "Encuentro"
L.SEARCH_TYPE_ABILITY = "Habilidad"
L.SEARCH_TYPE_ITEM = "Objeto"
L.SEARCH_TYPE_QUEST = "Misión"
L.SEARCH_TYPE_FACTION = FACTION or "Facción"
L.MAP_PIN_CLEAR = "Haz clic para quitar este marcador."
L.MAP_PIN_COMBAT = "No se puede abrir el mapa en combate."

L.RARE_SUFFIX = " (Raro)"
L.AND_MORE = "y %d más"
L.BULLET_AREA = "Se encuentra en %s."
L.BULLET_RARE = "Una criatura rara: no aparece en todos los recorridos."
L.BULLET_SUMMONED = "Un jefe oculto que invocas tú: la nota de arriba explica cómo."
L.BULLET_LEVEL = "Un encuentro de nivel %d."
L.BULLET_ABILITIES = "Se le ha visto lanzar: %s."
L.BULLET_LOOT = "Suelta %d objetos, entre ellos %s."
L.BULLET_ADDS = "Cuenta con la ayuda de %s."
L.ADD_DESCRIPTION = "Lucha junto a %s."
L.BULLET_NOTHING_YET = "Aún no se sabe nada de este encuentro."

--[[
	The esES client's classic "Equip:" wordings ("Equipar:"), as Pawn's Spanish tooltip parsing reads
	them on Classic Era and Forever: "Mejora tu probabilidad de conseguir un golpe crítico en 1%.",
	"Aumenta el daño y la curación de los hechizos mágicos y los efectos hasta en 12 p.", "+40 p. de
	poder de ataque.", "Defensa aumentada +7."... Each wording is matched with the number on either
	side, as the client words some stats both ways. The line is lowered in ASCII only, so accented
	letters are written in lower case. Holy and ranged critical strike and the "magical" spell damage
	line are drafted; check them against items in game.
]]
L.EQUIP_PATTERNS = {
	-- Bonuses against undead only, and effects on being struck or on a hit: worth nothing.
	{ "no.muert", false },
	{ "^cuando ", false },
	{ "^al ", false },
	-- Critical strike and hit with spells and attacks both.
	{ "crítico con todos los hechizos y ataques.-{n}", { "CRIT", "SPELL CRIT" } },
	{ "{n}%%.-crítico con todos los hechizos y ataques", { "CRIT", "SPELL CRIT" } },
	{ "golpear con todos los hechizos y ataques.-{n}", { "HIT", "SPELL HIT" } },
	{ "{n}%%.-golpear con todos los hechizos y ataques", { "HIT", "SPELL HIT" } },
	{ "crítico.-sagrad.-{n}", "HOLY CRIT" },
	{ "crítico.-{n}%%.-sagrad", "HOLY CRIT" },
	{ "{n}%%.-crítico.-sagrad", "HOLY CRIT" },
	{ "crítico.-hechizos.-{n}", "SPELL CRIT" },
	{ "crítico.-{n}%%.-hechizos", "SPELL CRIT" },
	{ "{n}%%.-crítico.-hechizos", "SPELL CRIT" },
	{ "crítico.-distancia.-{n}", "RANGED CRIT" },
	{ "crítico.-{n}%%.-distancia", "RANGED CRIT" },
	{ "{n}%%.-crítico.-distancia", "RANGED CRIT" },
	{ "crítico.-{n}", "CRIT" },
	{ "{n}%%.-golpe crítico", "CRIT" },
	{ "alcanzar el objetivo con.-hechizos.-{n}", "SPELL HIT" },
	{ "{n}%%.-alcanzar el objetivo con.-hechizos", "SPELL HIT" },
	{ "golpear con.-hechizos.-{n}", "SPELL HIT" },
	{ "{n}%%.-golpear con.-hechizos", "SPELL HIT" },
	{ "alcanzar el objetivo.-{n}", "HIT" },
	{ "{n}%%.-alcanzar el objetivo", "HIT" },
	{ "probabilidad de golpear.-{n}", "HIT" },
	{ "{n}%%.-probabilidad de golpear", "HIT" },
	{ "daño y la curación.-{n}", { "SPELL POWER", "HEALING" } },
	{ "daño y la sanación.-{n}", { "SPELL POWER", "HEALING" } },
	{ "{n}.-el daño y la", { "SPELL POWER", "HEALING" } },
	{ "curación.-hechizos.-{n}", "HEALING" },
	{ "sanación.-hechizos.-{n}", "HEALING" },
	{ "{n}.-curación.-hechizos", "HEALING" },
	{ "{n}.-sanación.-hechizos", "HEALING" },
	{ "hechizos.-sagrad.-{n}", "HOLY DAMAGE" },
	{ "{n}.-hechizos.-sagrad", "HOLY DAMAGE" },
	{ "hechizos.-fuego.-{n}", "FIRE DAMAGE" },
	{ "{n}.-hechizos.-fuego", "FIRE DAMAGE" },
	{ "hechizos.-escarcha.-{n}", "FROST DAMAGE" },
	{ "{n}.-hechizos.-escarcha", "FROST DAMAGE" },
	{ "hechizos.-naturaleza.-{n}", "NATURE DAMAGE" },
	{ "{n}.-hechizos.-naturaleza", "NATURE DAMAGE" },
	{ "hechizos.-sombras.-{n}", "SHADOW DAMAGE" },
	{ "{n}.-hechizos.-sombras", "SHADOW DAMAGE" },
	{ "hechizos.-arcan.-{n}", "ARCANE DAMAGE" },
	{ "{n}.-hechizos.-arcan", "ARCANE DAMAGE" },
	{ "daño.-hechizos.-mágicos.-{n}", "SPELL DAMAGE" },
	{ "{n}.-daño.-hechizos.-mágicos", "SPELL DAMAGE" },
	{ "{n}%%.-regeneración de maná", "CASTING REGEN" },
	{ "regeneración de maná.-{n}%%.-lanz", "CASTING REGEN" },
	{ "resistencias mágicas de.-objetivos.-{n}", "SPELL PENETRATION" },
	{ "penetración de.-hechizos.-{n}", "SPELL PENETRATION" },
	{ "poder de ataque.-contra", false },
	{ "poder de ataque.-al luchar", false },
	{ "poder de ataque.-al combatir", false },
	{ "{n}.-poder de ataque a distancia", "RANGED ATTACK POWER" },
	{ "poder de ataque a distancia.-{n}", "RANGED ATTACK POWER" },
	{ "{n}.-poder de ataque.-felin", "FERAL ATTACK POWER" },
	{ "poder de ataque.-felin.-{n}", "FERAL ATTACK POWER" },
	{ "{n}.-poder de ataque", "ATTACK POWER" },
	{ "poder de ataque.-{n}", "ATTACK POWER" },
	{ "{n}.-maná cada 5", "MANA PER 5" },
	{ "{n}.-maná por 5", "MANA PER 5" },
	{ "{n}.-vida cada 5", "HEALTH PER 5" },
	{ "{n}.-salud cada 5", "HEALTH PER 5" },
	{ "restaura {n}.-vida", "HEALTH PER 5" },
	{ "restaura {n}.-salud", "HEALTH PER 5" },
	{ "defensa aumentada.-{n}", "DEFENSE" },
	{ "índice de defensa.-{n}", "DEFENSE" },
	{ "{n}.-índice de defensa", "DEFENSE" },
	{ "tu defensa.-{n}", "DEFENSE" },
	{ "esquivar.-{n}", "DODGE" },
	{ "{n}%%.-esquivar", "DODGE" },
	{ "de parar.-{n}", "PARRY" },
	{ "{n}%%.-de parar", "PARRY" },
	{ "valor de bloqueo.-{n}", "BLOCK VALUE" },
	{ "{n}.-valor de bloqueo", "BLOCK VALUE" },
	{ "bloquear.-{n}", "BLOCK" },
	{ "{n}%%.-bloquear", "BLOCK" },
	{ "velocidad de ataque.-{n}", "HASTE" },
	{ "{n}%%.-velocidad de ataque", "HASTE" },
}

--[[
	The rooms inside dungeons, as the client names them where the player stands: "You are here" and
	a wing's areas match these (Core/Areas.lua). Drafted, as Forever's own rooms have no official
	Spanish name yet: Anvilmar's Rest, Dark Iron Ingress, King's Alley, Lordaeron Graveyard, Lordamere
	Overlook, Lost Dig Site, Lost Marsh, Market Street, Reliquary of Kings, Riverglades, Site of the
	Guardian and Stalker's Thicket.
]]
L.AREA_NAMES = {
	["Aku'mai's Lair"] = "Guarida de Aku'mai",
	["Anvilmar's Rest"] = "Reposo de Yunquemar",
	["Athenaeum"] = "Athenaeum",
	["Blackrock Stadium"] = "Estadio de Roca Negra",
	["Capital Gardens"] = "Jardines de la Capital",
	["Cavern of Mists"] = "Caverna Vaharada",
	["Chamber of Atonement"] = "Cámara Expiatoria",
	["Chamber of Battle"] = "Sala de la Batalla",
	["Chapel Gardens"] = "Jardines de la Capilla",
	["Court of the Highborne"] = "Corte de los Altonato",
	["Crag of the Everliving"] = "Risco de los Eternos",
	["Crusader's Armory"] = "Arsenal de los Cruzados",
	["Crusader's Chapel"] = "Capilla de los Cruzados",
	["Crusaders' Square"] = "Plaza de los Cruzados",
	["Dark Iron Ingress"] = "Acceso Hierro Negro",
	["Deeprun Tram"] = "Tranvía Subterráneo",
	["Defias Hideout"] = "Ladronera de los Defias",
	["Dragonspire Hall"] = "Sala Dracopico",
	["Dreamer's Rock"] = "Roca del Soñador",
	["Elders' Square"] = "Plaza de los Ancestros",
	["Engineering Labs"] = "Laboratorios de Ingeniería",
	["Festival Lane"] = "Calle del Festival",
	["Footman's Armory"] = "Arsenal de los Soldados",
	["Forlorn Cloister"] = "Claustro Inhóspito",
	["Gallery of Treasures"] = "Galería de los Tesoros",
	["Goblin Foundry"] = "Fundición Goblin",
	["Gordok Commons"] = "Ágora de Gordok",
	["Hall of Champions"] = "Sala de los Campeones",
	["Halycon's Lair"] = "Guarida de Halycon",
	["Honor's Tomb"] = "Tumba del Honor",
	["Hordemar City"] = "Ciudad Hordemar",
	["Huntsman's Cloister"] = "Claustro del Cazador",
	["Ironclad Cove"] = "Cala del Acorazado",
	["Ironforge"] = "Forjaz",
	["King's Alley"] = "Callejón del Rey",
	["King's Square"] = "Plaza del Rey",
	["Launch Bay"] = "Aeropuerto",
	["Lordaeron Graveyard"] = "Cementerio de Lordaeron",
	["Lordamere Overlook"] = "Mirador de Lordamere",
	["Lost Dig Site"] = "Excavación Perdida",
	["Lost Marsh"] = "Ciénaga Perdida",
	["Market Row"] = "Fila del Mercado",
	["Market Street"] = "Calle del Mercado",
	["Mast Room"] = "Sala del Mástil",
	["Mok'Doom"] = "Mok'Doom",
	["Moonshrine Ruins"] = "Ruinas del Santuario Lunar",
	["Moonshrine Sanctum"] = "Sagrario Lunar",
	["Mount Hyjal"] = "Monte Hyjal",
	["Pit of Fangs"] = "Foso de los Colmillos",
	["Prison of Immol'thar"] = "Prisión de Immol'thar",
	["Reliquary of Kings"] = "Relicario de los Reyes",
	["Riverglades"] = "Claros del Río",
	["Screaming Gully"] = "Quebrada del Llanto",
	["Shen'dralas"] = "Shen'dralas",
	["Site of the Guardian"] = "Lugar del Guardián",
	["Skitterweb Tunnels"] = "Túneles de Arácnidas",
	["Slaughter Square"] = "Plaza Degolladero",
	["Stalker's Thicket"] = "Matorral del Acechador",
	["Tazz'Alaor"] = "Tazz'Alaor",
	["Tazz'Alor"] = "Tazz'Alaor",
	["The Clockwerk Run"] = "La Rampa del Engranaje",
	["The Deadmines"] = "Las Minas de la Muerte",
	["The Dormitory"] = "Los Dormitorios",
	["The Drowned Sacellum"] = "El Templete Sumergido",
	["The Forgotten Pool"] = "Las Charcas del Olvido",
	["The Gauntlet"] = "El Guantelete",
	["The Hall of Gears"] = "La Sala de Máquinas",
	["The Hall of Lights"] = "La Sala de las Luces",
	["The High Seat"] = "El Trono",
	["The Hoard"] = "El Tesoro Oculto",
	["The Pool of Ask'ar"] = "La Alberca de Ask'ar",
	["The Rookery"] = "El Grajero",
	["The Scarlet Bastion"] = "La Basílica Escarlata",
	["The Shrine of Eldretharr"] = "Santuario de Eldretharr",
	["The Slaughter House"] = "El Degolladero",
	["The Storehouse"] = "Almacén",
	["Tinkers' Court"] = "Cámara Manitas",
	["Training Grounds"] = "Patio de Armas",
	["Warpwood Quarter"] = "Barrio Alabeo",
}

-- Matched against the client's own text: the client's language's only, previewed or not.
if client then client.EQUIP_PATTERNS, client.AREA_NAMES = L.EQUIP_PATTERNS, L.AREA_NAMES end
L.EQUIP_PATTERNS, L.AREA_NAMES = nil, nil
