local _, ns = ...

--[[
	The journal's interface in Brazilian Portuguese, for a client set to Brazilian Portuguese.
	Drafted by Claude for review by a native speaker. It is laid over the English table
	(Locales/enUS.lua), so every file that already holds ns.L sees these strings, and anything not
	translated here stays English. Every other client skips it.
]]
-- The journal's words where it speaks this language; the tables matched against the client's own
-- text where the client does, previewed or not (ns.LocaleTargets, Locales/enUS.lua).
local L, client = ns.LocaleTargets("ptBR")
if not L then return end

L.JOURNAL_TITLE = "Diário de Masmorras"
L.HOME = HOME or "Início"
L.TAB_DUNGEONS = DUNGEONS or "Masmorras"
L.TAB_RAIDS = RAIDS or "Raides"
L.TAB_REPUTATION = REPUTATION or "Reputação"

L.BINDING_TOGGLE = "Abrir/fechar o Diário de Masmorras"
L.KEY_CLAIMED = "Shift+J agora abre o Diário de Masmorras."
L.KEY_TAKEN = "Shift+J já está atribuído a %s. Escolha uma tecla em Teclas de Atalho > AddOns > Abrir/fechar o Diário de Masmorras."
L.POSITION_RESET = "Posição da janela redefinida."
L.SLASH_HELP = "/aegis (ou /ij) abre o diário. /aegis record inicia ou para a gravação. /aegis reset devolve a janela ao lugar padrão. /aegis perf mede a memória e a velocidade do diário. /aegis where e /aegis taxi informam onde você está e os pontos de voo do seu mapa. /aegis travel salva um barco, zepelim, metrô ou portal para o mapa-múndi. /aegis items procura os itens listados que o servidor não conhece. /aegis gear abre o Localizador de Equipamento, /aegis weights os pesos de atributos dele; /aegis gearscan salva o que ele lê do seu equipamento, para conferir a pontuação. /aegis options abre as opções do diário. /aegis lang mostra o diário em outro dos idiomas dele."
-- /aegis lang (Core/Init.lua)
L.LANG_USAGE = "/aegis lang de, fr, ru, cn, tw, es, mx, pt ou ko mostra o diário em alemão, francês, russo, chinês (simplificado ou tradicional), espanhol (Espanha ou América Latina), português do Brasil ou coreano a partir do seu próximo /reload, para conferir uma tradução; /aegis lang off volta ao idioma do seu cliente. Agora: %s."
L.LANG_SET = "A partir do seu próximo /reload, o diário aparece neste idioma: %s. Só os textos dele mudam: os nomes do jogo continuam os do seu cliente. Digite /reload agora; /aegis lang off desfaz a mudança."
L.LANG_OFF = "A partir do seu próximo /reload, o diário volta ao idioma do seu cliente. Digite /reload agora."
L.LANG_FONTS = "O chinês precisa das fontes de um cliente chinês: no seu, alguns caracteres podem não aparecer."
L.LANG_FONTS_KO = "O coreano precisa das fontes de um cliente coreano: no seu, alguns caracteres podem não aparecer."
L.LANG_ON = "Prévia do diário em outro idioma: %s. /aegis lang off encerra a prévia."
L.LANG_UNAVAILABLE = "Este cliente carregou o diário antes das configurações salvas, então a prévia de idioma não pôde começar."
L.AREAS_START = "Procurando no cliente os IDs dos %d nomes de área do diário..."
L.AREAS_DONE = "IDs encontrados para %d dos %d nomes de área. Digite /reload para salvá-los."
L.AREAS_MISSING = "Não encontrados: %s."
L.AREAS_SCANNING = "Ainda procurando os nomes de área."
L.AREAS_ENGLISH = "Use /aegis areas em um cliente em inglês: os nomes que ele procura estão em inglês."
L.ITEMS_START = "Consultando o servidor sobre os %d itens listados no diário. A resposta chega em cerca de %d segundos; continue jogando à vontade."
L.ITEMS_SCANNING = "Ainda consultando o servidor; a resposta chega em instantes."
L.ITEMS_DONE = "De %d itens, o servidor não conhece %d: provavelmente ainda não estão no Forever. O diário os oculta até que o servidor ou uma gravação os confirme. A lista completa vai para o arquivo salvo no seu próximo /reload ou quando você sair do jogo."
L.ITEMS_LINE = "  Item %d: %s"
L.ITEMS_MORE = "  ...e mais %d."
L.PERF_HEADER = "Desempenho (memória em KB, tempos em milissegundos; menor é melhor):"
L.PERF_MEMORY = "  %s: %.0f KB"
L.PERF_TIME = "  %s: %.2f ms"
L.PERF_BUILD = "Primeira abertura (montando a janela)"
L.PERF_BOOK = "Primeira masmorra aberta (montando o livro)"
L.PERF_OPEN = "Abrir e fechar o diário"
L.PERF_DUNGEON = "Abrir a página de uma masmorra"
L.PERF_TAB = "Mudar para a aba %s"
L.PERF_FACTION = "Abrir a página de uma facção"
L.PERF_LOOT = "Redesenhar uma página de saque"
L.PERF_COMBAT = "A medição espera até você sair de combate."
L.WHERE = "Mapa %s (%s)  x %.4f  y %.4f  área \"%s\"  minimapa \"%s\"  altura %s"
L.TAXI = "Mapa %s  mostra pontos de voo por conta própria: %s  pontos de voo nele: %d (%d descobertos)  %s"
L.TAXI_ATLASES = "Ícones de viagem: %s"
L.YES = YES or "Sim"
L.NO = NO or "Não"

L.EMPTY_DUNGEONS = "Ainda não há masmorras com entradas no diário."
L.EMPTY_RAIDS = "Ainda não há raides com entradas no diário."
L.EMPTY_REPUTATION = "Nenhuma recompensa de facção conhecida ainda."
L.EMPTY_BRACKET = "Nada nesta faixa de nível."

L.TAB_RECORD = "Gravar"
L.TAB_GEAR = "Localizador de Equipamento"

-- The Gear Finder (Core/GearFinder.lua, UI/GearPanel.lua, UI/CharacterTab.lua).
L.GEAR_TITLE = "Localizador de Equipamento"
L.GEAR_PREVIEW = "Prévia"
L.GEAR_NO_UPGRADE = "Nenhuma melhoria encontrada"
L.GEAR_LOOKING = "Procurando em %d masmorras."
L.GEAR_LOOKING_ONE = "Procurando em 1 masmorra."
L.GEAR_LOADING = "%d itens ainda carregando."
L.GEAR_LOADING_ONE = "1 item ainda carregando."
L.GEAR_SCORING = "Pontuação para"
L.GEAR_AUTO = "Automático: %s"
L.GEAR_WHY_TALENTS = "%s (talentos)"
L.GEAR_WHY_LEVELLING = "%s (subindo de nível)"
L.GEAR_SUGGESTED = "Masmorra sugerida"
L.GEAR_UPGRADES_HERE = "%d melhorias aqui"
L.GEAR_UPGRADE_HERE = "1 melhoria aqui"
L.GEAR_MORE_SLOTS = "e mais %d"
L.GEAR_DUNGEON_OF = "%d de %d"
L.GEAR_NONE = "Nenhuma melhoria nas masmorras perto do seu nível."
L.GEAR_TIP_CLICK = "Clique para ver o saque; Shift+clique para criar um link no bate-papo."
L.GEAR_TIP_CELL_CLICK = "Clique para ver as maiores melhorias; clique com o botão direito para ver o saque."
L.GEAR_TIP_PICK_CLICK = "Clique para mostrá-lo aqui; clique com o botão direito para ver o saque."
L.GEAR_TIP_PICKED = "Sua escolha para este espaço."
L.GEAR_PICK_TOP = "As %d maiores de %d melhorias"
L.GEAR_PICK_ALL = "%d melhorias"
L.GEAR_PICK_ONE = "A única melhoria"
L.GEAR_PICK_BIGGEST = "Maior"
L.GEAR_PICK_YOURS = "Sua escolha"
L.GEAR_PICK_KEPT = "As escolhas ficam salvas para este personagem."
L.GEAR_PICK_CLEAR = "Limpar minha escolha"
L.GEAR_TIP_NONE = "Nenhuma melhoria para este espaço nas masmorras perto do seu nível."
L.GEAR_CHAR_BUTTON = "Localizador de Equipamento"
L.GEAR_CHAR_BUTTON_TIP = "Seus pesos de atributos e as maiores melhorias à sua espera nas masmorras do diário."
L.GEAR_SCAN_DONE = "Leitura do equipamento salva: %d itens equipados e %d itens de masmorras. Saia do jogo ou use /reload para gravá-la no arquivo salvo."
L.GEAR_SCAN_ERRORS = "%d itens não puderam ser lidos; o que deu errado fica salvo com a leitura."
L.GEAR_SCAN_LOADING = "Alguns itens ainda estão carregando: espere alguns segundos e digite /aegis gearscan de novo para obter mais."
L.GEAR_SLOT_FINGER1 = "Dedo 1"
L.GEAR_SLOT_FINGER2 = "Dedo 2"
L.GEAR_SLOT_TRINKET1 = "Berloque 1"
L.GEAR_SLOT_TRINKET2 = "Berloque 2"

-- Stat weights (Core/ItemScore.lua, UI/WeightsEditor.lua).
L.WEIGHTS_TITLE = "Pesos de Atributos"
L.WEIGHTS_EDIT = "Editar pesos de atributos..."
L.WEIGHTS_SOURCE_DEFAULT = "Os pesos do diário"
L.WEIGHTS_SOURCE_LEVELLING = "Os pesos do diário, para subir de nível"
L.WEIGHTS_SOURCE_CUSTOM = "Seus próprios pesos"
L.WEIGHTS_SOURCE_PAWN = "Seus pesos, do Pawn: %s"
L.WEIGHTS_TIP = "Quanto vale um ponto de cada atributo para esta especialização. Clique em um peso para alterá-lo; seus próprios pesos aparecem em verde e ficam salvos para este personagem."
L.WEIGHTS_RESET = "Redefinir"
L.WEIGHTS_RESET_TIP = "Volta aos pesos do diário para esta especialização."
L.WEIGHTS_PAWN = "Pawn..."
L.WEIGHTS_PAWN_TIP = "Importar uma escala do Pawn."
L.WEIGHTS_PAWN_HELP = "No Pawn, escolha a escala, clique em Exportar, copie o texto e cole aqui."
L.WEIGHTS_IMPORT = "Importar"
L.WEIGHTS_CANCEL = "Cancelar"
L.WEIGHTS_BACK = "Voltar"
L.WEIGHTS_OPEN_FINDER = "Abrir o Localizador de Equipamento"
L.WEIGHTS_IMPORTED = "%d pesos importados de %s."
L.WEIGHTS_UNUSED = "Não usados: %s."
L.WEIGHTS_NOT_PAWN = "Isso não é uma escala do Pawn. No Pawn, escolha Exportar e copie o texto inteiro."
L.WEIGHTS_OTHER_CLASS = "Essa escala é da classe %s, não da classe deste personagem."
L.WEIGHTS_FOR = "Para"
-- The journal's page in the game's options (Options > AddOns).
L.OPTIONS_TITLE = "Aegis Instance Journal"
L.OPTIONS_BOSS_LEVELS = "Mostrar o nível dos chefes na lista de chefes"
L.OPTIONS_BOSS_LEVELS_TIP = "Um selo no retrato de cada chefe com o nível dele, colorido conforme a dificuldade do chefe para você: cinza, verde, amarelo, laranja ou vermelho."
L.OPTIONS_ARROWS = "Marcar melhorias com uma seta verde"
L.OPTIONS_MINIMAP = "Mostrar o botão do minimapa"
L.OPTIONS_PAWN_WEIGHTS = "Usar os pesos de atributos do Pawn no Localizador de Equipamento"
L.OPTIONS_PAWN_WEIGHTS_TIP = "Com o Pawn instalado, as dicas de item e as setas de melhoria dele são as exibidas. Marcado: o Localizador de Equipamento pontua os itens com a sua escala do Pawn para a sua especialização. Desmarcado: o Pawn mostra os pesos do diário para a sua especialização, como uma escala do diário, e as escalas próprias dele ficam ocultas neste personagem até você marcar esta opção."
L.PAWN_ASK = "O Pawn também está instalado. As dicas de item e as setas de melhoria dele serão exibidas.\n\nQuais pesos de atributos o Pawn e o Localizador de Equipamento devem usar?\n\nOs do diário: o Pawn os mostra para a sua especialização e oculta as escalas próprias dele neste personagem.\nOs do Pawn: o Localizador de Equipamento usa as suas escalas do Pawn."
L.PAWN_USE_PAWN = "Os do Pawn"
L.PAWN_USE_JOURNAL = "Os do diário"
L.PAWN_SCALE = "Diário: %s"
L.PAWN_RELOAD = "As setas de melhoria do Pawn nas suas bolsas do Baganator só mudam depois de recarregar a interface: o Baganator guarda as respostas do Pawn até o seu equipamento mudar.\n\nRecarregar agora?"
L.PAWN_RELOAD_NOW = "Recarregar"
L.PAWN_RELOAD_LATER = "Depois"
L.WEIGHTS_SOURCE_PAWN_LIVE = "Escala %s do Pawn. Altere-a no Pawn ou escolha os pesos do diário nas opções do diário."
L.OPTIONS_MINIMAP_TIP = "O botão do diário na borda do minimapa: clique nele para abrir o diário, clique com o botão direito para abrir estas opções e arraste-o para movê-lo."
L.MINIMAP_LEFT_CLICK = "Clique para abrir ou fechar o diário."
L.MINIMAP_RIGHT_CLICK = "Clique com o botão direito para ver as opções."
L.MINIMAP_DRAG = "Arraste para movê-lo pela borda do minimapa."
L.OPTIONS_ARROWS_TIP = "Uma seta verde nos itens que são melhorias para a sua especialização, segundo o Localizador de Equipamento: nas suas bolsas, na janela de saque e nas rolagens de saque."
L.WEIGHTS_SHOW_GAINS = "Mostrar pesos de atributos nas dicas"
L.WEIGHTS_SHOW_GAINS_TIP = "Abaixo de cada item, uma linha para cada uma das suas especializações: quanto o item vale segundo os pesos dela e, quando ele é uma melhoria, uma seta verde com o que ele acrescenta ao seu equipamento. Para todos os seus personagens. Com o Pawn instalado, isto mostra ou oculta, em vez disso, a escala do diário no Pawn e, com ela, as setas de melhoria do Pawn para os pesos do diário: o Pawn só marca melhorias para as escalas que exibe."
L.OPTIONS_SOURCES = "Mostrar nas dicas onde cada item é obtido"
L.OPTIONS_SOURCES_TIP = "Abaixo de cada item obtido nas masmorras e raides do diário, uma linha com o chefe e a masmorra: nas suas bolsas, no seu personagem, nos links do bate-papo, nos vendedores e em qualquer outro lugar onde o jogo mostre o item. Para todos os seus personagens."
L.GEAR_WHY_CUSTOM = "%s (seus pesos)"
-- The specs' names (the classic talent trees) and the units their weights count in, by spec key
-- and by the English unit.
L.GEAR_SPEC_NAMES = {
	Arms = "Armas", Fury = "Fúria", Protection = "Proteção", Holy = "Sagrado", Retribution = "Retribuição",
	BeastMastery = "Domínio das Feras", Marksmanship = "Precisão", Survival = "Sobrevivência",
	Assassination = "Assassinato", Combat = "Combate", Subtlety = "Subterfúgio", Discipline = "Disciplina", Shadow = "Sombra",
	Elemental = "Elemental", Enhancement = "Aperfeiçoamento", EnhancementTank = "Aperfeiçoamento (tanque)",
	Restoration = "Restauração", Arcane = "Arcano", Fire = "Fogo", Frost = "Gélido", Affliction = "Suplício",
	Demonology = "Demonologia", Destruction = "Destruição", Balance = "Equilíbrio", FeralBear = "Combate Feral (urso)",
	FeralCat = "Combate Feral (felino)",
}
L.GEAR_UNITS = {
	["attack power"] = "poder de ataque", ["ranged attack power"] = "poder de ataque de longo alcance",
	["spell damage"] = "dano mágico", healing = "cura", Stamina = "Vigor",
}
L.WEIGHT_GROUPS = {
	PRIMARY = "Atributos Primários", WEAPONS = "Armas", SPELLS = "Feitiços", DEFENSE = "Defesa",
	RESISTANCE = "Resistências",
}
L.STAT_NAMES = {
	STRENGTH = "Força", AGILITY = "Agilidade", STAMINA = "Vigor", INTELLECT = "Intelecto", SPIRIT = "Espírito",
	DPS = "DPS da Arma", ["RANGED DPS"] = "DPS da Arma de Longo Alcance", ["ATTACK POWER"] = "Poder de Ataque",
	["RANGED ATTACK POWER"] = "Poder de Ataque de Longo Alcance", ["FERAL ATTACK POWER"] = "Poder de Ataque Feral", HIT = "Acerto",
	CRIT = "Acerto Crítico", ["RANGED CRIT"] = "Crítico de Longo Alcance", HASTE = "Velocidade de Ataque", ["RANGED HASTE"] = "Velocidade de Longo Alcance",
	["SPELL POWER"] = "Dano e Cura", ["SPELL DAMAGE"] = "Dano Mágico", HEALING = "Cura", ["SPELL HIT"] = "Acerto de Feitiço",
	["SPELL CRIT"] = "Crítico de Feitiço", ["HOLY CRIT"] = "Crítico Sagrado", ["HOLY DAMAGE"] = "Dano Sagrado",
	["FIRE DAMAGE"] = "Dano de Fogo", ["FROST DAMAGE"] = "Dano de Gelo", ["NATURE DAMAGE"] = "Dano de Natureza",
	["SHADOW DAMAGE"] = "Dano de Sombra", ["ARCANE DAMAGE"] = "Dano Arcano", ["SPELL PENETRATION"] = "Penetração de Feitiço",
	MANA = "Mana", ["MANA PER 5"] = "Mana a cada 5 s", ["CASTING REGEN"] = "Regeneração ao Lançar Feitiços",
	ARMOR = "Armadura", HEALTH = "Vida", ["HEALTH PER 5"] = "Vida a cada 5 s", DEFENSE = "Defesa", DODGE = "Esquiva",
	PARRY = "Aparo", BLOCK = "Bloqueio", ["BLOCK VALUE"] = "Valor de Bloqueio",
	["HOLY RESISTANCE"] = "Resistência a Sagrado", ["FIRE RESISTANCE"] = "Resistência a Fogo",
	["NATURE RESISTANCE"] = "Resistência a Natureza", ["FROST RESISTANCE"] = "Resistência a Gelo",
	["SHADOW RESISTANCE"] = "Resistência a Sombra", ["ARCANE RESISTANCE"] = "Resistência a Arcano",
}
L.RECORD_START = "Iniciar gravação"
L.RECORD_STOP = "Parar gravação"
L.RECORD_CLEAR = "Limpar"
L.RECORD_CLEAR_CONFIRM = "Descartar tudo o que foi gravado até agora? Não é possível desfazer."
L.RECORD_STATUS_ON = "Gravando desde %s"
L.RECORD_STATUS_OFF = "Sem gravação"
L.RECORD_COMBATLOG = "Gravar o registro de combate nas masmorras"
L.RECORD_COMBATLOG_TIP = "As habilidades dos chefes vêm do registro de combate do jogo. O diário o liga dentro das masmorras e o desliga de novo na saída; um registro que você mesmo iniciou não é alterado. Para enviá-lo, adicione o arquivo de registro à sua gravação na página do Log Reader (Copiar mostra o link)."
L.RECORD_RECENT = "Recentes"
L.RECORD_NOTHING_YET = "Nada capturado ainda. Entre em uma masmorra com a gravação ligada e mate, saqueie e faça missões como sempre."
L.RECORD_STARTED = "Gravação iniciada. /aegis record a interrompe."
L.RECORD_STOPPED = "Gravação interrompida."
L.RECORD_LOG_STARTED = "Gravação iniciada."
L.RECORD_LOG_STOPPED = "Gravação interrompida."
L.RECORD_LOG_CLEARED = "Gravações apagadas."
L.RECORD_LOG_ENTERED = "Você entrou em %s."
L.RECORD_LOG_LEFT = "Você saiu da masmorra."
L.RECORD_LOG_AREA = "Nova área: %s."
L.RECORD_LOG_PULL = "Combate iniciado contra %s."
L.RECORD_LOG_KILL = "Você derrotou %s."
L.RECORD_LOG_WIPE = "Grupo derrotado por %s."
L.RECORD_LOG_LOOT = "Saque: %d item(ns) novo(s)."
L.RECORD_LOG_QUEST_OFFERED = "Missão oferecida: %s."
L.RECORD_LOG_QUEST_DONE = "Missão entregue: %s."
L.RECORD_LOG_ENTRANCE = "Entrada de %s gravada."
L.RECORD_LOG_NO_ENTRANCE = "Entrada de %s não gravada: %s."
L.RECORD_NO_MAP = "o jogo não informou nenhum mapa quando a tela de carregamento começou"
L.RECORD_NO_POSITION = "o jogo não informou nenhuma posição quando a tela de carregamento começou"
L.RECORD_IN_DUNGEON_MAP = "a tela de carregamento começou no mapa de uma masmorra"
L.RECORD_LOG_COMBATLOG_ON = "Registro de combate ligado: Logs\\%s."
L.RECORD_LOG_COMBATLOG_OFF = "Registro de combate desligado."

L.LEVEL_RANGE = "Nível %d-%d"
L.LEVEL_ALL = "Todos os Níveis"
L.LEVEL_BRACKET = "Nível %d a %d"
L.TRASH_DROPS = "Saque de inimigos comuns"
L.UNTESTED = "Ainda não testado"
L.UNTESTED_NOTE = "Ainda não testada: o que está aqui vem do anúncio da Blizzard e pode estar incompleto. Percorra-a com a gravação ligada (aba Gravar) para completar os chefes, o saque e a entrada."
L.COMING_SOON = "Em breve"
L.COMING_SOON_TEXT = "Ainda não está aberta no WoW: Forever. Os chefes, o saque e o mapa chegam conforme os jogadores gravam suas incursões. Gravou uma? Publique no nosso Discord, e o seu nome entra para os colaboradores do diário."
L.COMING_SOON_PARTLY = "Ainda não está aberta no WoW: Forever: o que está aqui vem do anúncio da Blizzard. Gravou uma incursão? Publique no nosso Discord, e o seu nome entra para os colaboradores do diário."
L.DISCORD_COPY_HINT = "Clique e depois Ctrl+C"
L.FOREVER_MARK = "Novo no WoW: Forever"
L.RECORD_LOG_VENDOR = "%s: %d itens à venda salvos, %d novos no diário."
L.RECORD_CAUGHT = "%d capturados, %d novos desde a sua última cópia"
L.RECORD_COPY = "Copiar"
L.RECORD_AUTO = "Gravar automaticamente nas masmorras"
L.RECORD_AUTO_TIP = "A gravação começa sozinha quando você entra em uma masmorra ou raide e para quando você sai. Uma gravação que você mesmo iniciou nunca é interrompida automaticamente."
L.RECORD_RECORDER = "Gravador"
L.RECORD_SEND = "Envie para nós"
L.RECORD_HELP_TEXT = "Clique em Copiar e cole o texto no nosso Discord:"
L.RECORD_CREDIT = "Meu nome nos créditos:"
L.RECORD_CREDIT_TIP = "O nome com que as suas gravações aparecem entre os colaboradores do diário. Se ficar vazio, será o nome do seu personagem."
L.RECORD_CONTRIBUTORS = "Colaboradores"
L.RECORD_CONTRIBUTORS_NONE = "Ninguém ainda: seja o primeiro."
L.RECORD_CONTRIBUTORS_FOOT = "Envie a sua gravação: o seu nome aparece aqui."
L.RECORD_COPY_TITLE = "Sua gravação, em texto"
L.RECORD_COPY_HINT = "Já está tudo selecionado: pressione Ctrl+C e cole no nosso Discord."
L.RECORD_COPY_HINT_LOG = "Pressione Ctrl+C e cole no Log Reader junto com o seu registro de combate (%s, na pasta Logs do jogo). Publique o resultado no nosso Discord."
L.RECORD_MORE_LOGS = "%s e %d mais antigos"
L.RECORD_BACK = "Voltar"
L.RECORD_CAUGHT_TITLE = "O que você capturou"
L.RECORD_ITEM = "Item %s"
L.RECORD_ONE_VISIT = "1 visita"
L.RECORD_VISITS = "%d visitas"
L.RECORD_ENTRANCE_YES = "entrada gravada"
L.RECORD_ENTRANCE_NO = "entrada ainda não gravada"
L.RECORD_AREAS = "%d áreas"
L.RECORD_KILLED = "Derrotados: %s"
L.RECORD_KILLED_TIMES = "%s (%d)"
L.RECORD_DROPS = "Saque: %s novos, %s já no diário"
L.RECORD_OFF = "De %s"
L.RECORD_OFF_TRASH = "De inimigos comuns"
L.RECORD_OFF_GROUP = "Saqueado pelo seu grupo"
L.RECORD_QUESTS = "Missões"
L.RECORD_QUEST_DONE = "entregue"
L.RECORD_NEW = "nova"
L.RECORD_QUARTERMASTERS = "Intendentes"
L.RECORD_WARES = "%s: %d itens à venda, %s novos"
L.RECORD_TRAVEL = "Pontos de viagem: %d"
L.FOREVER_LINE = "Novo no WoW: Forever."
L.LOCATION_LINE = "Localização: %s"

L.TAB_OVERVIEW = OVERVIEW or "Visão Geral"
L.TAB_LOOT = LOOT_NOUN or "Saque"
L.TAB_ABILITIES = ABILITIES or "Habilidades"
L.TAB_MODEL = MODEL or "Modelo"
L.TAB_QUESTS = QUESTS_LABEL or "Missões"
L.ALL_CLASSES = ALL_CLASSES or "Todas as Classes"
L.ALL_ARMOR = "Todas as Armaduras"
L.ALL_TYPES = "Todos os Tipos"
-- The loot pages' Type menu: the kinds of item, "All ..." atop the two with a submenu, and one of each.
L.LOOT_KIND = {
	EQUIPMENT = "Equipamento", RECIPE = "Receitas", CONSUMABLE = "Consumíveis", MOUNT = "Montarias", PET = "Mascotes",
	TOY = "Brinquedos", BAG = "Bolsas", TRADE = "Mercadorias", QUEST = "Itens de Missão", OTHER = "Outros",
}
L.LOOT_KIND_ALL = { EQUIPMENT = "Todo o Equipamento", RECIPE = "Todas as Receitas" }
L.LOOT_KIND_ONE = { MOUNT = "Montaria", PET = "Mascote", TOY = "Brinquedo" }
L.LOOT_RECIPE = "Receita"
L.LOOT_FAVORITES = "Favoritos"
L.LOOT_FAVORITES_ONLY = "Só favoritos"
L.LOOT_FAVORITE = "Adicionar aos favoritos"
L.LOOT_UNFAVORITE = "Remover dos favoritos"
L.LOOT_PINNED = "Fixado"
L.LOOT_ALL = "Saque"
L.LOOT_TRASH = "Inimigos comuns da masmorra"
L.DROPS_FROM_BOSS = "Saque: %s (%s)"
L.DROPS_FROM_TRASH = "Saque: inimigos comuns (%s)"
L.DROPS_FROM_BOSSES = "Saque: %d chefes (%s)"
L.DROPS_IN = "Saque em: %s"
L.DROPS_ALSO_IN = "Saque também em: %s"
L.LEGEND_CLICK_HIDE = "Clique para ocultá-los no mapa."
L.LEGEND_CLICK_SHOW = "Ocultos. Clique para mostrá-los no mapa de novo."
L.LEGEND_GAME_FILTER = "O filtro do próprio jogo, como no menu de filtros do mapa: missões em andamento e prontas para entregar compartilham o mesmo."
L.PREPARE_TITLE = "Antes de ir"
L.PREPARE_PROGRESS = "Você concluiu %d de %d missões."
L.PREPARE_HAVE = "Você já tem."
L.PREPARE_QUEST_HINT = "Clique para ver na aba Missões."
L.QUESTS_DUNGEON = "Missões da Masmorra"
L.TRASH = "Inimigos comuns"
L.TRASH_DESCRIPTION = "O que as outras criaturas da masmorra deixam cair que vale a pena conhecer: equipamentos raros e épicos, receitas e itens de missão."
L.LOOT_BOSS_LINE = BOSS_INFO_STRING or "Chefe: %s"
L.LOOT_FILTER_BAR = "Filtro: %s"
L.LOOT_RETRIEVING = RETRIEVING_ITEM_INFO or "Obtendo informações do item"
L.LOOT_NO_DATA = "Item %d"
L.LOOT_NO_DATA_TOOLTIP = "O servidor não enviou os detalhes deste item. Talvez ele ainda não esteja no jogo."
L.LOOT_UNIDENTIFIED_TOOLTIP = "Ainda não identificado: a fonte o cita, mas não informa o ID do item. Saqueie-o durante uma gravação para adicioná-lo."
L.LOOT_TOOLTIP_PIN = "Clique com o botão direito para fixar este item no topo da lista."
L.LOOT_TOOLTIP_UNPIN = "Clique com o botão direito para desafixar."
L.LOOT_NONE = "Nenhum saque conhecido para isto ainda."
L.LOOT_NO_MATCH = "Nada aqui corresponde aos filtros. Limpe-os com o X acima."
L.ABILITY_LOADING = RETRIEVING_DATA or "Obtendo dados..."
L.ABILITIES_NONE = "Nenhuma habilidade conhecida para este encontro ainda. Grave uma incursão pela aba Gravar para capturá-las."
L.STATS_HIT = "Causa %s"
L.STATS_TICK = "pulsos de %s"
L.STATS_FIRST = "primeiro lançamento aos %d s"
L.STATS_EVERY = "depois a cada %s s"
L.QUEST_NONE = "Nenhuma missão conhecida para a sua facção nesta masmorra."
L.QUEST_STATUS_READY = "Concluída: pronta para entregar"
L.QUEST_STATUS_NEEDS = "Requer: %s"
L.QUEST_STATUS_LEVEL = "Requer nível %d"
L.QUEST_DESCRIPTION = QUEST_DESCRIPTION or "Descrição"
L.QUEST_START_ITEM = "Começa com:"
L.QUEST_PARTS = "%s (%d partes)"
L.QUEST_PARTS_DONE = "%d de %d partes desta sequência concluídas."
L.QUEST_SHOW_START = "Mostrar início"
L.QUEST_SHOW_END = "Mostrar fim"
L.QUEST_PLACE_UNKNOWN = "Local ainda desconhecido. Aceite ou entregue esta missão com a aba Gravar ativa para adicioná-lo."
L.QUEST_OFFERED_BY = "Missão oferecida por %s"
L.QUEST_HAND_IN_TO = "Entregar a %s"
L.QUESTMAP_DUNGEON_QUEST = "Missão de masmorra: %s"
L.QUESTMAP_RAID_QUEST = "Missão de raide: %s"
L.QUESTMAP_LEFT_CLICK = "Clique com o botão esquerdo para abri-la no diário"
L.QUESTMAP_WAYPOINT_SET = "Marcador no mapa definido para %s."
L.QUESTMAP_ONE_OF = "Nem sempre no mesmo lugar: um entre %d locais."
L.MAP_ONE_OF = "Nem sempre no mesmo lugar: um entre %d locais."
L.QUEST_REWARDS = REWARDS or "Recompensas"
L.QUEST_YOU_RECEIVE = YOU_RECEIVE or "Você receberá:"
L.QUEST_XP = "%s de experiência"
L.QUEST_REPUTATION = "%d de reputação com %s"
L.QUEST_CHOOSE = REWARD_CHOICES or "Você poderá escolher uma destas recompensas:"
L.QUEST_ALSO = REWARD_ITEMS or "Você também receberá:"
L.REP_REWARDS = "%d recompensas"
L.REP_REWARD_ONE = "1 recompensa"
L.REP_ALL_REWARDS = "Recompensas"
L.REP_UNKNOWN = "Desconhecida"
L.REP_CARD_CLICK = "Clique para ver as recompensas."
L.REP_YOUR_STANDING = "Sua reputação: %s"
L.REP_NOT_MET = "Você ainda não conheceu esta facção."
L.REP_PROGRESS = "%s / %s"
L.REP_QUARTERMASTER = "Intendente: %s"
L.REP_CAPTURE = "Capturar vendedor"
L.REP_CAPTURE_TIP = "Vá até um intendente de reputação, abra a loja dele e clique aqui. Tudo o que ele vende fica salvo: o preço de cada item, qualquer outro custo e a reputação exigida. Os itens entram nas recompensas da facção na hora e são incluídos quando você clica em Copiar na aba Gravar."
L.REP_CAPTURE_READY = "Loja aberta: clique em Capturar vendedor."
L.REP_CAPTURE_HINT = "Abra a loja de um intendente para capturar os itens à venda."
L.REP_CAPTURED = "%s: %d itens à venda para %s, %d novos."
L.REP_CAPTURED_NONE = "%s: %d itens salvos; nenhum exige reputação."
L.REP_CAPTURED_UNKNOWN = "%s: %d itens exigem reputação com uma facção que o jogo não nomeia; ficam salvos até que um item a nomeie."
L.REP_NOT_CAPTURED = "Ainda não capturada"
L.REP_NOT_CAPTURED_TIP = "Ninguém capturou o intendente desta facção ainda."
L.REP_NOT_CAPTURED_TEXT = "Ninguém capturou o intendente desta facção ainda. Encontre um, abra a loja dele e clique em Capturar vendedor na aba Reputação; depois publique a sua gravação no nosso Discord. O seu nome entra para os colaboradores do diário."
L.REP_LISTED_TIP = "As recompensas vêm dos dados de itens do jogo e ainda não foram confirmadas com um intendente."
L.REP_LISTED_TEXT = "Estas recompensas vêm dos dados de itens do jogo, ainda não de um intendente, então não têm preço e algumas talvez nem sejam vendidas. Encontre um dos intendentes desta facção, abra a loja dele e clique em Capturar vendedor na aba Reputação; depois publique a sua gravação no nosso Discord. O seu nome entra para os colaboradores do diário."
L.REP_COMING_SOON_TEXT = "Nova no WoW: Forever e ainda não capturada. Quando ela estiver no jogo, encontre o intendente dela, abra a loja dele e clique em Capturar vendedor na aba Reputação; depois publique a sua gravação no nosso Discord."
L.MAP_SHOW = ENCOUNTER_JOURNAL_SHOW_MAP or "Mostrar mapa"
L.MAP_SHOW_UNEXPLORED = "Mostrar áreas inexploradas"
L.MAP_FILTER_QUESTS = "Missões disponíveis"
L.MAP_FILTER_DUNGEONS = "Entradas de masmorras"
L.MAP_FILTER_RAIDS = "Entradas de raides"
L.MAP_FILTER_FLIGHT = "Pontos de voo"
L.MAP_FILTER_CAVES = "Entradas de cavernas"
L.MAP_FILTER_TRANSPORT = "Barcos, zepelins, metrô e portais"
L.MAP_PIN_OPEN = "Clique para abrir no diário."
L.MAP_DEFEATED = DUNGEON_ENCOUNTER_DEFEATED or "Derrotado"
L.MAP_LEVEL = "Nível %d"
L.MAP_FLOOR = "Andar %d"
L.MAP_GO_TO = "Para %s"
L.MAP_YOU_ARE_HERE = "Você está aqui"
L.ENTRANCE_DUNGEON = LFG_TYPE_DUNGEON or "Masmorra"
L.ENTRANCE_RAID = LFG_TYPE_RAID or "Raide"
L.ENTRANCE_DUNGEONS = DUNGEONS or "Masmorras"
L.ENTRANCE_RAIDS = RAIDS or "Raides"
L.ENTRANCE_LEFT_CLICK = "Clique com o botão esquerdo para abrir o Diário de Masmorras"
L.ENTRANCE_CHOOSE_LEFT_CLICK = "Clique com o botão esquerdo para escolher qual abrir no Diário de Masmorras"
L.ENTRANCE_RIGHT_CLICK = "Clique com o botão direito para definir um marcador no mapa"
L.ENTRANCE_WAYPOINT_SET = "Marcador no mapa definido na entrada de %s."
L.ENTRANCE_VIA = "O portal fica mais abaixo, em %s: desça pela entrada da caverna."
L.ENTRANCE_WAYPOINT_VIA = "Marcador no mapa definido na descida para %s, a caminho de %s."
L.CAVE_LABEL = "Entrada de Caverna"
L.CAVE_LEADS_TO = "O caminho para %s"
L.CAVE_LEFT_CLICK = "Clique com o botão esquerdo para ver o mapa de %s"
L.CAVE_WAYPOINT_SET = "Marcador no mapa definido na descida para %s."
L.FLIGHT_POINT = MAP_LEGEND_FLIGHTPOINT or "Ponto de Voo"
L.CLICK_FOR_WAYPOINT = "Clique para definir um marcador no mapa"
L.FLIGHT_WAYPOINT_SET = "Marcador no mapa definido no mestre de voo de %s."
L.TRAVEL_KINDS = { boat = "Barco", zeppelin = "Zepelim", airship = "Aeronave", tram = "Metrô", portal = "Portal" }
L.TRAVEL_FACTIONS = { Alliance = FACTION_ALLIANCE or "Aliança", Horde = FACTION_HORDE or "Horda" }
L.TRAVEL_ROUTE = "%s para %s"
L.TRAVEL_AND = "%s e %s"
L.TRAVEL_ROUTE_NOTE = "%s: %s"
L.TRAVEL_HELP = "Fique em um cais, torre de zepelim, metrô ou portal e digite /aegis travel boat (ou zeppelin, airship, tram, portal) seguido do destino, por exemplo /aegis travel boat Auberdine. Acrescente alliance, horde ou neutral no final para dizer a quem ele serve, e uma nota entre parênteses para dizer quem pode usá-lo, por exemplo /aegis travel portal Dalaran (somente Celonatos). /aegis travel list mostra o que está salvo; /aegis travel undo desfaz o último."
L.TRAVEL_NO_POSITION = "O jogo não informa nenhuma posição aqui, então nada foi salvo."
L.TRAVEL_SAVED = "%s salvo em %s. /aegis travel undo desfaz."
L.TRAVEL_UNDONE = "Desfeito: %s em %s."
L.TRAVEL_NOTHING = "Nada para desfazer."
L.TRAVEL_LIST_EMPTY = "Nenhum ponto de viagem salvo ainda. Digite /aegis travel para ver como."
L.TRAVEL_LIST_LINE = "%d. %s em %s (mapa %d, %.4f, %.4f)"
L.TRAVEL_WAYPOINT_SET = "Marcador no mapa definido para %s."
L.LEGEND_TRANSPORT = "Transporte"
L.LEGEND_TRANSPORT_TOOLTIP = "Barcos, zepelins, o metrô e portais. Azul atende a Aliança; vermelho, a Horda; dourado, todos."
L.LEGEND_CAVE_TOOLTIP = "O caminho para dentro de uma caverna ou para um nível abaixo da zona. Clique nele no mapa para ver aonde leva."
L.SEARCH_SHOW_ALL = SEARCH_RESULTS_SHOW_COUNT or "Mostrar todos os %d resultados"
L.SEARCH_RESULTS = ENCOUNTER_JOURNAL_SEARCH_RESULTS or "Resultados da busca por “%s” (%d)"
L.SEARCH_TYPE_BOSS = "Encontro"
L.SEARCH_TYPE_ABILITY = "Habilidade"
L.SEARCH_TYPE_ITEM = "Item"
L.SEARCH_TYPE_QUEST = "Missão"
L.SEARCH_TYPE_FACTION = FACTION or "Facção"
L.MAP_PIN_CLEAR = "Clique para remover este marcador."
L.MAP_PIN_COMBAT = "Não é possível abrir o mapa em combate."

L.RARE_SUFFIX = " (Raro)"
L.AND_MORE = "e mais %d"
L.BULLET_AREA = "Encontra-se em %s."
L.BULLET_RARE = "Uma criatura rara: nem toda incursão a encontra."
L.BULLET_SUMMONED = "Um chefe oculto que você mesmo invoca: a nota acima explica como."
L.BULLET_LEVEL = "Um encontro de nível %d."
L.BULLET_ABILITIES = "Visto lançando: %s."
L.BULLET_LOOT = "Deixa cair %d itens, incluindo %s."
L.BULLET_ADDS = "Conta com a ajuda de %s."
L.ADD_DESCRIPTION = "Luta ao lado de %s."
L.BULLET_NOTHING_YET = "Ainda não se sabe nada sobre este encontro."

-- The Brazilian Portuguese client's classic "Equip:" wordings ("Equipado:"), on the line in lower
-- case (drafted; check against items in game). Specific before general, as in Core/ItemScore.lua.
L.EQUIP_PATTERNS = {
	-- Bonuses against undead only, and attack power against one kind of creature: worth nothing.
	{ "mortos%-vivos", false },
	-- Critical strikes: "Aumenta em 1% a chance de realizar acertos críticos (com feitiços)."
	{ "em {n}%%.-crític.-sagrad", "HOLY CRIT" },
	{ "em {n}%%.-crític.-feitiços e ataques", { "SPELL CRIT", "CRIT" } },
	{ "em {n}%%.-crític.-feitiço", "SPELL CRIT" },
	{ "em {n}%%.-crític.-longo alcance", "RANGED CRIT" },
	{ "em {n}%%.-crític.-distância", "RANGED CRIT" },
	{ "em {n}%%.-crític", "CRIT" },
	-- Hit: "Aumenta em 1% a chance de acerto." / "Aumenta em 1% sua chance de acertar com feitiços."
	{ "em {n}%%.-acert.-feitiços e ataques", { "SPELL HIT", "HIT" } },
	{ "em {n}%%.-acert.-feitiço", "SPELL HIT" },
	{ "em {n}%%.-acert", "HIT" },
	-- "Aumenta em até 23 o dano causado e a cura realizada por feitiços e efeitos mágicos."
	{ "até {n}.-dano.-e a cura", { "SPELL POWER", "HEALING" } },
	{ "até {n}.-cura.-e o dano", { "SPELL POWER", "HEALING" } },
	-- "Aumenta em até 44 a cura realizada por feitiços e efeitos mágicos."
	{ "até {n}.-cura", "HEALING" },
	-- "Aumenta em até 20 o dano causado por feitiços e efeitos de Fogo." (Sagrados, Arcanos...)
	{ "até {n}.-dano.-sagrad", "HOLY DAMAGE" },
	{ "até {n}.-dano.-fogo", "FIRE DAMAGE" },
	{ "até {n}.-dano.-gelo", "FROST DAMAGE" },
	{ "até {n}.-dano.-natureza", "NATURE DAMAGE" },
	{ "até {n}.-dano.-sombra", "SHADOW DAMAGE" },
	{ "até {n}.-dano.-arcan", "ARCANE DAMAGE" },
	{ "até {n}.-dano.-mágic", "SPELL DAMAGE" },
	{ "até {n}.-dano.-feitiço", "SPELL DAMAGE" },
	-- "Permite que 15% da sua regeneração de mana continue durante o lançamento de feitiços."
	{ "{n}%%.-regenera.-mana", "CASTING REGEN" },
	{ "{n}%%.-mana.-continu", "CASTING REGEN" },
	-- "Reduz em 10 as resistências mágicas dos alvos dos seus feitiços."
	{ "em {n}.-resist.-mágicas", "SPELL PENETRATION" },
	{ "resist.-mágicas.-em {n}", "SPELL PENETRATION" },
	{ "em {n}.-penetração de feitiço", "SPELL PENETRATION" },
	-- "+45 de poder de ataque ao lutar contra demônios."
	{ "poder de ataque ao lutar", false },
	{ "poder de ataque contra", false },
	-- "+24 de poder de ataque de longo alcance." / "Aumenta o poder de ataque de longo alcance em 24."
	{ "^%+{n}.-poder de ataque de longo alcance", "RANGED ATTACK POWER" },
	{ "^%+{n}.-poder de ataque à distância", "RANGED ATTACK POWER" },
	{ "poder de ataque de longo alcance.-em {n}", "RANGED ATTACK POWER" },
	{ "em {n}.-poder de ataque de longo alcance", "RANGED ATTACK POWER" },
	-- "+120 de poder de ataque sob forma de Felino, Urso e Urso Hediondo."
	{ "^%+{n}.-poder de ataque.-felino", "FERAL ATTACK POWER" },
	{ "em {n}.-poder de ataque.-felino", "FERAL ATTACK POWER" },
	{ "^%+{n}.-poder de ataque", "ATTACK POWER" },
	{ "em {n}.-poder de ataque", "ATTACK POWER" },
	{ "poder de ataque em {n}", "ATTACK POWER" },
	-- "Restaura 4 de mana a cada 5 s." / "Recupera 4 pontos de vida a cada 5 s."
	{ "{n}.-mana a cada 5", "MANA PER 5" },
	{ "{n}.-vida a cada 5", "HEALTH PER 5" },
	{ "restaura {n}.-vida", "HEALTH PER 5" },
	{ "recupera {n}.-vida", "HEALTH PER 5" },
	-- "Defesa aumentada em 7."
	{ "defesa aumentada em {n}", "DEFENSE" },
	{ "defesa %+{n}", "DEFENSE" },
	{ "em {n}.-defesa", "DEFENSE" },
	-- "Aumenta em 1% a chance de esquivar-se de ataques." / "... de aparar ataques." / "... de bloquear
	-- ataques com o escudo." (not "serem esquivados ou aparados", which is no dodge nor parry)
	{ "em {n}%%.-de esquivar", "DODGE" },
	{ "em {n}%%.-se esquivar", "DODGE" },
	{ "em {n}%%.-de aparar", "PARRY" },
	{ "em {n}%%.-de bloquear", "BLOCK" },
	-- "Aumenta em 15 o valor de bloqueio do seu escudo."
	{ "em {n}.-valor de bloqueio", "BLOCK VALUE" },
	{ "valor de bloqueio.-em {n}", "BLOCK VALUE" },
	-- "Aumenta em 1% a sua velocidade de ataque."
	{ "em {n}%%.-velocidade de ataque", "HASTE" },
	{ "velocidade de ataque.-em {n}", "HASTE" },
}

-- The rooms inside dungeons, as the client names them where the player stands: "You are
-- here" and a wing's areas match these (Core/Areas.lua). Unconfirmed ones are listed in
-- the translation's to-check list.
L.AREA_NAMES = {
	["Aku'mai's Lair"] = "Covil de Aku'mai",
	["Anvilmar's Rest"] = "Repouso de Sidermar",
	["Athenaeum"] = "Ateneu",
	["Blackrock Stadium"] = "Estádio Rocha Negra",
	["Capital Gardens"] = "Jardins Capitais",
	["Cavern of Mists"] = "Caverna das Brumas",
	["Chamber of Atonement"] = "Câmara da Redenção",
	["Chamber of Battle"] = "Câmara de Batalha",
	["Chapel Gardens"] = "Jardins da Capela",
	["Court of the Highborne"] = "A Corte dos Altaneiros",
	["Crag of the Everliving"] = "Rochedo do Sempre-vivo",
	["Crusader's Armory"] = "Armaria do Cruzado",
	["Crusader's Chapel"] = "Capela do Cruzado",
	["Crusaders' Square"] = "Praça dos Cruzados",
	["Dark Iron Ingress"] = "Passagem Ferro Negro",
	["Deeprun Tram"] = "Metrô Correfundo",
	["Defias Hideout"] = "Esconderijo Défias",
	["Dragonspire Hall"] = "Salão do Espinodrago",
	["Dreamer's Rock"] = "Rocha do Sonhador",
	["Elders' Square"] = "Praça dos Anciãos",
	["Engineering Labs"] = "Laboratório de Engenharia",
	["Festival Lane"] = "Alameda do Festival",
	["Footman's Armory"] = "Armaria do Soldado",
	["Forlorn Cloister"] = "Claustro Esquecido",
	["Gallery of Treasures"] = "Galeria dos Tesouros",
	["Goblin Foundry"] = "Fundição dos Goblins",
	["Gordok Commons"] = "Pátio Gordok",
	["Hall of Champions"] = "Salão dos Campeões",
	["Halycon's Lair"] = "Covil de Halycon",
	["Honor's Tomb"] = "Tumba de Honra",
	["Hordemar City"] = "Hordamar",
	["Huntsman's Cloister"] = "Claustro do Guarda-caça",
	["Ironclad Cove"] = "Covil Encouraçado",
	["Ironforge"] = "Altaforja",
	["King's Alley"] = "Beco do Rei",
	["King's Square"] = "Praça Real",
	["Launch Bay"] = "Baia de Lançamento",
	["Lordaeron Graveyard"] = "Cemitério de Lordaeron",
	["Lordamere Overlook"] = "Mirante de Lordaeron",
	["Lost Dig Site"] = "Sítio de Escavação Perdido",
	["Lost Marsh"] = "Charco Perdido",
	["Market Row"] = "Travessa do Comércio",
	["Market Street"] = "Rua do Mercado",
	["Mast Room"] = "Sala do Mastro",
	["Mok'Doom"] = "Mok'Doom",
	["Moonshrine Ruins"] = "Ruínas do Sacrário Lunar",
	["Moonshrine Sanctum"] = "Sacrário Lunar",
	["Mount Hyjal"] = "Monte Hyjal",
	["Pit of Fangs"] = "Fosso das Presas",
	["Prison of Immol'thar"] = "Prisão de Immol'thar",
	["Reliquary of Kings"] = "Relicário dos Reis",
	["Riverglades"] = "Sendas do Rio",
	["Screaming Gully"] = "Barranca Estridente",
	["Shen'dralas"] = "Shen'dralas",
	["Site of the Guardian"] = "Sítio do Guardião",
	["Skitterweb Tunnels"] = "Túneis Tremeteia",
	["Slaughter Square"] = "Praça do Massacre",
	["Stalker's Thicket"] = "Matagal do Espreitador",
	["Tazz'Alaor"] = "Tazz'Alaor",
	["Tazz'Alor"] = "Tazz'Alor",
	["The Clockwerk Run"] = "Corredor dos Mecanismos",
	["The Deadmines"] = "Minas Mortas",
	["The Dormitory"] = "Alojamentos",
	["The Drowned Sacellum"] = "O Sacelo Inundado",
	["The Forgotten Pool"] = "Charcos Esquecidos",
	["The Gauntlet"] = "Forquilha",
	["The Hall of Gears"] = "Salão das Engrenagens",
	["The Hall of Lights"] = "O Salão das Luzes",
	["The High Seat"] = "A Sala do Trono",
	["The Hoard"] = "O Cofre",
	["The Pool of Ask'ar"] = "O Poço de Ask'Ar",
	["The Rookery"] = "O Viveiro",
	["The Scarlet Bastion"] = "O Bastião Escarlate",
	["The Shrine of Eldretharr"] = "Altar de Eldretharr",
	["The Slaughter House"] = "O Matadouro",
	["The Storehouse"] = "O Armazém",
	["Tinkers' Court"] = "Paço dos Faz-tudo",
	["Training Grounds"] = "Campo de Treinamento",
	["Warpwood Quarter"] = "Distrito Lenhatorta",
}

-- Matched against the client's own text: the client's language's only, previewed or not.
if client then client.EQUIP_PATTERNS, client.AREA_NAMES = L.EQUIP_PATTERNS, L.AREA_NAMES end
L.EQUIP_PATTERNS, L.AREA_NAMES = nil, nil
