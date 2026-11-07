local UI_SOURCES = {
	"https://raw.githubusercontent.com/zer000111222000-netizen/Gui/refs/heads/main/GuiIxahub.lua",
	"https://raw.githubusercontent.com/zer000111222000-netizen/Gui/refs/heads/main/GuiIxahub_backup.lua",
	"https://cdn.jsdelivr.net/gh/zer000111222000-netizen/Gui@main/GuiIxahub.lua",
	"https://cdn.jsdelivr.net/gh/zer000111222000-netizen/Gui@main/GuiIxahub_backup.lua",
}
local Airflow = getgenv().__IxaHubLibrary
if type(Airflow) ~= "table" then
	for _, url in ipairs(UI_SOURCES) do
		local ok, lib = pcall(function()
			return loadstring(game:HttpGet(url))()
		end)
		if ok and type(lib) == "table" and type(lib.CreateWindow) == "function"
			and type(lib.ThemePresets) == "table" then
			Airflow = lib
			break
		end
	end
end
if not Airflow then
	error("[Ixa Hub] Could not load the UI library. Check your connection and run again.")
end
getgenv().__IxaHubLibrary = Airflow
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local KEYS = {
	ui = "K",
}
local LocalPlayer = Players.LocalPlayer
local WordGame = ReplicatedStorage:WaitForChild("WordGame", 30)
local Action = WordGame and WordGame:WaitForChild("Action", 15)
local State = WordGame and WordGame:WaitForChild("State", 15)
if not (Action and State) then
	error("[Ixa Hub] This script only works inside the word game.")
end
local Settings
local function charCount(text)
	local ok, count = pcall(utf8.len, text)
	return ok and count or 0
end
local function cleanWord(raw)
	if type(raw) ~= "string" then
		return nil
	end
	local word = string.lower((string.gsub(raw, "%s+", "")))
	if word == "" then
		return nil
	end
	local count = 0
	for _, code in utf8.codes(word) do
		local isRussian = (code >= 0x0430 and code <= 0x044F) or code == 0x0451
		if not isRussian then
			return nil
		end
		count += 1
		if count > 29 then
			return nil
		end
	end
	if count < 3 then
		return nil
	end
	return word
end
local function firstChar(word)
	return string.sub(word, 1, 2)
end
local function lastChar(word)
	return string.sub(word, -2)
end
local function restOfWord(word)
	return string.sub(word, 3)
end
local function httpGet(url)
	for attempt = 1, 2 do
		local ok, body = pcall(function()
			return game:HttpGet(url)
		end)
		if ok and type(body) == "string" and #body > 200 then
			return body
		end
		if attempt == 1 then
			task.wait(0.4)
		end
	end
	local req = (typeof(syn) == "table" and syn.request)
		or (typeof(request) == "function" and request)
		or (typeof(http) == "table" and http.request)
		or (typeof(http_request) == "function" and http_request)
	if req then
		local ok, res = pcall(req, { Url = url, Method = "GET" })
		if ok and type(res) == "table" and type(res.Body) == "string" and #res.Body > 200 then
			return res.Body
		end
	end
	return nil
end
local function readFileSafe(path)
	if type(readfile) ~= "function" then
		return nil
	end
	local ok, data = pcall(readfile, path)
	if ok and type(data) == "string" and #data > 0 then
		return data
	end
	return nil
end
local function writeFileSafe(path, data)
	if not Settings.keepHistory then
		return false
	end
	if type(writefile) ~= "function" or type(data) ~= "string" then
		return false
	end
	pcall(function()
		if type(makefolder) == "function" then
			makefolder("IxaHub")
		end
	end)
	return pcall(writefile, path, data)
end
local function canvas()
	local gui = LocalPlayer:FindFirstChild("PlayerGui")
	local main = gui and gui:FindFirstChild("WordGameUI")
	return main and main:FindFirstChild("Canvas")
end
local function matchFrame()
	local root = canvas()
	return root and root:FindFirstChild("Match")
end
local function lobbyFrame()
	local root = canvas()
	return root and root:FindFirstChild("Lobby")
end
local function typingBox()
	local match = matchFrame()
	local box = match and match:FindFirstChild("TypingCapture")
	if box and box:IsA("TextBox") then
		return box
	end
	local gui = LocalPlayer:FindFirstChild("PlayerGui")
	local main = gui and gui:FindFirstChild("WordGameUI")
	return main and main:FindFirstChildWhichIsA("TextBox", true) or nil
end
Settings = {
	solve = true,
	autoChoose = true,
	autoPractice = false,
	showTyping = true,
	safeEndings = true,
	learn = true,
	keepHistory = false,
	delay = 0.10,
	attempts = 6,
	mode = "legit",
}
local MODES = {
	superlegit = {
		DEADLINE = 4.5,
		THINK_MIN = 0.45,
		THINK_MAX = 1.10,
		LONG_CHANCE = 0.10,
		LONG_EXTRA = 0.55,
		TYPO = 0.12,
		MIDPAUSE = 0.12,
		REVIEW = true,
		RETRY_DELAY = { 0.25, 0.55 },
		RETRY_THINK = { 0.1, 0.35 },
		RESEND_AFTER = 2.5,
		RESEND_MAX = 2,
		CHOOSE = { 0.8, 1.8 },
	},
	legit = {
		DEADLINE = 3.0,
		THINK_MIN = 0.25,
		THINK_MAX = 0.75,
		LONG_CHANCE = 0.06,
		LONG_EXTRA = 0.5,
		TYPO = 0.18,
		MIDPAUSE = 0.08,
		REVIEW = true,
		RETRY_DELAY = { 0.25, 0.5 },
		RETRY_THINK = { 0.1, 0.35 },
		RESEND_AFTER = 2.5,
		RESEND_MAX = 2,
		CHOOSE = { 1.0, 2.5 },
		LATE_ROUND = 50,
	},
	latelegit = {
		DEADLINE = 6.0,
		THINK_MIN = 0.8,
		THINK_MAX = 2.0,
		LONG_CHANCE = 0.15,
		LONG_EXTRA = 1.2,
		TYPO = 0.18,
		MIDPAUSE = 0.12,
		REVIEW = true,
		RETRY_DELAY = { 0.2, 0.45 },
		RETRY_THINK = { 0.1, 0.3 },
		RESEND_AFTER = 2.0,
		RESEND_MAX = 3,
		CHOOSE = { 0.8, 2.0 },
	},
	rage = {
		FAST = true,
		DEADLINE = 2.0,
		THINK_MIN = 0.03,
		THINK_MAX = 0.12,
		LONG_CHANCE = 0,
		LONG_EXTRA = 0,
		TYPO = 0.04,
		MIDPAUSE = 0,
		REVIEW = false,
		RETRY_DELAY = { 0.08, 0.2 },
		RETRY_THINK = { 0.03, 0.12 },
		RESEND_AFTER = 1.5,
		RESEND_MAX = 3,
		CHOOSE = { 0.3, 0.8 },
	},
}
local MODE_LABELS = {
	superlegit = "Super legit",
	legit = "Legit",
	rage = "Rage",
}
local MODE_BY_LABEL = {
	["Super legit"] = "superlegit",
	["Legit"] = "legit",
	["Rage"] = "rage",
}
local Game
local function curT()
	local mode = Settings.mode or "legit"
	if mode == "rage" then
		return MODES.rage
	end
	if mode == "superlegit" then
		return MODES.superlegit
	end
	if Game and Game.round and Game.round >= (MODES.legit.LATE_ROUND or 50) then
		return MODES.latelegit
	end
	return MODES.legit
end
local Window, Log
local UiRefs = {}
local function log(message, color)
	if not Log or not Settings.keepHistory then
		return
	end
	Log:Push(tostring(message), color)
end
local function notify(title, content, kind)
	pcall(function()
		Window:Notify({ Title = title, Content = content, Type = kind or "Info", Duration = 4 })
	end)
end
getgenv().__IxaHubGen = (getgenv().__IxaHubGen or 0) + 1
local SCRIPT_GENERATION = getgenv().__IxaHubGen
local function scriptAlive()
	return getgenv().__IxaHubGen == SCRIPT_GENERATION
end
local BAD_PREFIX = { "хуй","хуя","хуё","хуе","пизд","бляд","блят","поеб","заеб","наеб",
	"уёб","уеб","выеб","ебан","ебат","ёбан","ебал","мудак","мудил","мудня","мудоз",
	"гандон","шлюх","пидор","педик","педрил","гомик","нигге","нигга","чурк" }
local BAD_EXACT = { ["хер"] = true, ["негр"] = true, ["хач"] = true, ["жид"] = true }
local function isBadWord(w)
	if BAD_EXACT[w] then
		return true
	end
	for _, p in ipairs(BAD_PREFIX) do
		if string.sub(w, 1, #p) == p then
			return true
		end
	end
	return false
end
local DICTIONARY_URLS = {
	nouns = "https://raw.githubusercontent.com/Harrix/Russian-Nouns/main/dist/russian_nouns.txt",
	freq = "https://raw.githubusercontent.com/hermitdave/FrequencyWords/master/content/2018/ru/ru_50k.txt",
}
local HUGE_URLS = {
	"https://raw.githubusercontent.com/danakt/russian-words/master/russian.txt",
	"https://cdn.jsdelivr.net/gh/danakt/russian-words@master/russian.txt",
	"https://fastly.jsdelivr.net/gh/danakt/russian-words@master/russian.txt",
}
local DICTIONARY_FILES = {
	nouns = "IxaHub/dictionary-nouns.txt",
	freq = "IxaHub/dictionary-freq.txt",
	learned = "IxaHub/learned.txt",
}
local CP1251 = {}
do
	for b = 0xE0, 0xFF do
		CP1251[b] = utf8.char(0x0410 + (b - 0xC0))
	end
	CP1251[0xB8] = utf8.char(0x0451)
end
local function decodeCp1251Word(line)
	local n = #line
	if n == 0 then
		return nil
	end
	local buf = table.create(n)
	for j = 1, n do
		local c = CP1251[string.byte(line, j)]
		if not c then
			return nil
		end
		buf[j] = c
	end
	return table.concat(buf)
end
local BAD_ENDINGS = {
	["й"] = true,
}
local FALLBACK_WORDS = table.concat({
	"автобус адрес аист актер алмаз ананас ангел аптека арбуз армия артист архив асфальт атлас афиша аэропорт август адвокат академия аквариум акция аллея альбом апельсин аренда",
	"бабушка багаж базар балкон банан банк бант барабан барон бассейн батарея батон бегемот белка берег береза беседа библиотека билет блин блок блокнот бобр богатырь бокал больница бомба борт бочка браслет брат бревно бриз бровь бронза брошка брусника брюки бублик будильник буква букет бумага буран бутерброд бутылка буфет бухта бык",
	"вагон ваза валенки валюта ванна вариант варенье вата вафля ведро веер веник венок веранда верблюд веревка вес весло ветер ветка вечер вешалка взгляд взрыв вилка вино виноград вирус витрина вкус власть вода водитель водопад вождь воздух война вокзал волк волна волос воробей ворона воск восток восторг врач время всадник вход вывод выдра вызов выход вышивка вьюга вязание",
	"газ газета газон гайка галстук гамак гараж гвоздь гвоздика генерал гений герб герой гитара глава глаз глина глубина гнездо гном гобелен голос голубь гора горло горох город горошек гостиница гость государство грабли градус граница график гребень грелка гриб грива грим гроза гром груз груша группа грусть грядка губка гудок гусь",
	"дача дверь движение двор девочка дед дедушка декабрь дело дельфин день деньги деревня дерево держава десерт дети деталь джинсы диван диета дизайн диктор диплом диск дневник дно дождь доктор документ доллар дом дорога доска досуг дочь дракон драма дрель дробь друг дружба дуб дуга дудка дупло душа дым дыня дядя",
	"еда единство ежик езда елка емкость енот ералаш ерунда",
	"ёж ёжик ёлка ёмкость ёрш",
	"жаба жажда жакет жалоба жанр жара жвачка жезл железо жемчуг жених жена жест жетон живот жилет жилье жираф жир журнал журналист журавль жук жюри",
	"забор забота завод завтрак загадка задача заказ закат закон залив замок запад запах запись заря заставка затылок заявка звезда звено зверь звон звук земля земляника зенит зеркало зерно зима змея знак знамя знание зонт зрачок зрение зубр зять",
	"игла игра игрок идея изба избушка избыток известие изгиб издание изюм икра иллюзия имбирь имя индюк инжир интерес ирис искра искусство история исток итог июль июнь",
	"йогурт йод",
	"кабан кабинет каблук кадр кактус калач календарь калитка камень камин камыш канал канат капля карман карта картина картошка касса кастрюля катер каток кафе каша каюта квадрат кедр кекс кепка керамика килька кинжал кино киоск кирпич кисть кит клевер клетка клей клен клещ климат клоун клуб ключ клятва книга кнопка кобра ковер ковш код кожа коза козел койка кокос колбаса колдун колесо колено колодец колос колпак кольцо команда комар комбайн комета комната комод компот конверт конец концерт конь копейка копыто корень корзина корица корм корова король корпус космос костер кость костюм кот котел котлета кошка краб край кран краска кредит крепость крест крик кризис крыло крыша крюк кубик кувшин кукла кукуруза кулак купол курган курица курс куст кухня",
	"лабиринт лаванда лавка лагерь ладонь лаз лайм лак лампа ландыш лапа лапша ларь ласка ластик лайнер лебедь лев легенда лед лезвие лейка лекция лента лепесток лес лестница лето летчик лещ лиса лист литера литр лицо лоб ловушка логика лодка ложка локоть лом лошадь лужа лук луна лупа луч лыжи любовь люк люстра лютик лягушка",
	"магнит мазь майка мак макароны малина мальчик манеж мандарин мантия марка март маршрут маска масло масса массаж мат матч мать машина маяк мебель медаль медведь медь мель мельница мелодия мера метод метро мех меч мешок мечта миг микрофон миска митинг миф мишень мнение мода модель мозг мойка молекула момент монета монитор море морж морковь мороз мост мотив мотор мотоцикл мрамор мусор музей мука муравей музыка мысль мышь мяч мясо мята",
	"набор навес навык награда надежда накидка налет налог намек напев напор народ наряд насос наука нация начало небо невеста неделя недра нейлон нежность нектар немец нефть нива никель нить ниша новость нога ноготь нож ножницы ноль номер нос носок нота ночь ноябрь нужда няня",
	"обед обещание обида обзор облако область обман обмен обои оборона образ обруч обувь обход обычай овца огонь огород огурец одежда одеяло ожидание ожог озеро окно океан окоп округ олень олива омлет опера опора орден орех осень осетр остров отвага ответ отдых отец открытие отряд охота очаг очерк очки ошейник ошибка",
	"павлин пагода палатка палец палка пальма панель папа папка парад парик парк пароль парта парус пасека паспорт паста пастух пауза паук пачка певец пекарня пение песня песок печать пещера пиала пижама пила пилот пирог письмо питон плавание плакат план плата платье плащ плечо плита плотина плот пляж победа повар повод погода подарок подвал подкова подушка поезд пожар поле полет полка полюс поляна порог порт портрет посуда поток потолок поход почта поэма правда праздник приз приказ пример природа проба провод прогноз проезд проект просо протез профессия пруд прыжок птица пудинг пузырь пульт пункт пурга пушка пчела пшеница пятно",
	"работа радар радио радость радуга разбор размер разум рай рак ракета рамка рана ранец рапорт расчет редис режим резец рейс река реклама ремень ремонт репка ресурс рецепт речка решение ринг риск рис рисунок рог родина роза роман ромашка роса рот рубанок рубль рука рукав рулет руль ручей рыба рынок рысь рюкзак",
	"сад садик сажа салат салют самовар самолет сани сапог сарай сахар сбор сварка свет свеча свисток свобода связь сезон секрет селедка село семья сено сердце серебро серия сеть сила сироп сирень система сито скала скарб сквер склад скорость скрипка слава слива слово слух смена смех смола смысл снег собор совет сок сокол сокровище солнце соль сом сон сорока сосна состав сотня спорт спрос спутник среда срок ссора стадо стакан станок старик статуя ствол стекло стена степь стиль стойка стол столица сторож страна струна студия стул сугроб судно судьба сумка суп сурок сустав суть сушка схема сцена счет съезд сыр",
	"табак таблица табун таз тайна такси талант талисман танец танк тапки тара тарелка творог театр тезис текст телега телефон тема темнота тепло тень терем тесто тетрадь тигр титул ткань товар ток толпа томат тон топор торг торт тоска точка трава трактор трамвай трасса трение треск тропа труба труд трюк тряпка туман тундра тупик туча тыква тюбик тюлень тюльпан тяга",
	"уборка убыток увоз уговор угол уголь удача удочка ужин узор указ улитка улица улов умение унисон упадок упор урожай урок усадьба успех устав утка утро ухо учитель ущелье уют",
	"фабрика фазан факел факт фамилия фант фара фартук фасад февраль фейерверк фен фестиваль фиалка фигура физика филе фильм финал финик финиш флаг флакон флейта флот фокус фонарь фонд форма форт фото фраза фрукт футбол футляр",
	"халат халва характер хвост хвоя химия хлеб хлопок хобот ход хозяин холод холст хомяк хор хребет хрип хруст художник хутор",
	"цапля царь цвет цветок целина целлофан цена центр цепь цифра цоколь цунами цыпленок",
	"чадо чай чайник часы часть чашка чемодан чемпион червь череп черешня черта чеснок честь четверг число чтение чувство чулан чулок чучело",
	"шаг шайба шалаш шаль шапка шар шарф шасси шахта шахматы швабра шейка шелест шелк шепот шерсть шершень шест шествие шило шина шиповник шишка шкаф шкатулка шкура шланг шлем шлюпка шляпа шнур шов шок шоколад шорты шоссе шпага шпагат шпион шрам штаб штора штурм штык шуба шум шут шутка",
	"щавель щека щенок щепка щетка щи щит щука щуп",
	"экзамен экран экскаватор экспорт экипаж экскурсия электричество элемент элита эмаль эпоха эскиз эссе этаж этап этика эфир эхо",
	"юбка юг юбилей юмор юность юнга юрист",
	"яблоко яблоня явление ягода яд ядро язык яйцо якорь яма ямка январь ярмарка ярус ясень ясность яхта ячмень ящик",
}, " ")
local Dictionary = {
	learned = {},
	freq = {},
	nouns = {},
	huge = {},
	fallback = {},
	total = 0,
	loaded = false,
	hugeLoaded = false,
	source = "-",
	learnedDirty = false,
}
local function addWord(pool, word)
	if type(word) ~= "string" or word == "" then
		return false
	end
	local bucket = pool[firstChar(word)]
	if not bucket then
		bucket = {}
		pool[firstChar(word)] = bucket
	end
	table.insert(bucket, word)
	return true
end
local function fillPool(pool, text, sortByLength, skipFilter)
	local added = 0
	for line in string.gmatch(text, "[^\r\n]+") do
		local word = cleanWord(line:match("^(%S+)") or line)
		if word and (skipFilter or not isBadWord(word)) and addWord(pool, word) then
			added += 1
		end
	end
	if sortByLength then
		for _, bucket in pairs(pool) do
			table.sort(bucket, function(a, b)
				return #a < #b
			end)
		end
	end
	return added
end
local function countPool(pool)
	local total = 0
	for _, bucket in pairs(pool) do
		total += #bucket
	end
	return total
end
local function loadFallback()
	if countPool(Dictionary.fallback) > 0 then
		return
	end
	for word in string.gmatch(FALLBACK_WORDS, "%S+") do
		local cleaned = cleanWord(word)
		if cleaned then
			addWord(Dictionary.fallback, cleaned)
		end
	end
end
local function rebuildTotal()
	Dictionary.total = countPool(Dictionary.freq) + countPool(Dictionary.nouns)
	if Dictionary.total == 0 then
		Dictionary.total = countPool(Dictionary.fallback)
	end
end
local function saveLearned()
	if not Dictionary.learnedDirty then
		return
	end
	Dictionary.learnedDirty = false
	if not Settings.keepHistory then
		return
	end
	local words = {}
	for _, bucket in pairs(Dictionary.learned) do
		for _, word in ipairs(bucket) do
			table.insert(words, word)
		end
	end
	if #words > 0 then
		writeFileSafe(DICTIONARY_FILES.learned, table.concat(words, "\n"))
	end
end
local function learnWord(raw)
	local word = cleanWord(raw)
	if not word or isBadWord(word) then
		return false
	end
	local bucket = Dictionary.learned[firstChar(word)]
	if bucket then
		for _, existing in ipairs(bucket) do
			if existing == word then
				return false
			end
		end
	end
	addWord(Dictionary.learned, word)
	Dictionary.learnedDirty = true
	return true
end
local function loadLearnedFile()
	if countPool(Dictionary.learned) > 0 then
		return
	end
	local data = readFileSafe(DICTIONARY_FILES.learned)
	if not data then
		return
	end
	for line in string.gmatch(data, "[^\r\n]+") do
		learnWord(line)
	end
end
local function loadPool(name, sortByLength)
	local cached = readFileSafe(DICTIONARY_FILES[name])
	if cached then
		Dictionary[name] = {}
		if fillPool(Dictionary[name], cached, sortByLength) > 0 then
			return countPool(Dictionary[name])
		end
	end
	local body = httpGet(DICTIONARY_URLS[name])
	if not body then
		return 0
	end
	Dictionary[name] = {}
	local added = fillPool(Dictionary[name], body, sortByLength)
	writeFileSafe(DICTIONARY_FILES[name], body)
	return added
end
local function loadHugePool()
	if Dictionary.hugeLoaded then
		return 0
	end
	local known = {}
	for _, poolName in ipairs({ "freq", "nouns", "fallback", "learned" }) do
		for _, bucket in pairs(Dictionary[poolName]) do
			for _, w in ipairs(bucket) do
				known[w] = true
			end
		end
	end
	local data = nil
	for _, url in ipairs(HUGE_URLS) do
		data = httpGet(url)
		if data and #data > 1000000 then
			break
		end
		data = nil
		task.wait(0.5)
	end
	if not data then
		log("<Warning>Huge base download failed — retrying in 20 s</Warning>")
		task.delay(20, function()
			if scriptAlive() and not Dictionary.hugeLoaded then
				task.spawn(loadHugePool)
			end
		end)
		return 0
	end
	local pool = Dictionary.huge
	local added = 0
	local i = 0
	for line in string.gmatch(data .. "\n", "([^\r\n]*)\r?\n") do
		local w = decodeCp1251Word(line)
		if w then
			local L = charCount(w)
			if L >= 3 and L <= 18 and not known[w] and not isBadWord(w) then
				known[w] = true
				addWord(pool, w)
				added += 1
			end
		end
		i += 1
		if i % 60000 == 0 then
			task.wait()
		end
	end
	Dictionary.hugeLoaded = true
	log(string.format("<Success>Huge base ready</Success> — +%d words", added))
	notify("Ixa Hub", "Huge base: +" .. added .. " words (over a million available)", "Success")
	return added
end
local function buildDictionary(force, done)
	if Dictionary.loaded and not force then
		if done then
			done(true)
		end
		return
	end
	loadFallback()
	loadLearnedFile()
	local nounCount = loadPool("nouns", true)
	local freqCount = loadPool("freq", false)
	rebuildTotal()
	Dictionary.loaded = true
	Dictionary.source = string.format("%d frequent + %d nouns", freqCount, nounCount)
	getgenv().__IxaHubPools = {
		freq = Dictionary.freq,
		nouns = Dictionary.nouns,
		learned = Dictionary.learned,
		huge = Dictionary.huge,
		hugeLoaded = Dictionary.hugeLoaded,
		total = Dictionary.total,
		loaded = true,
	}
	if done then
		done(Dictionary.total > 0)
	end
	task.spawn(loadHugePool)
end
local cachedPools = getgenv().__IxaHubPools
if type(cachedPools) == "table" and cachedPools.loaded then
	Dictionary.freq = cachedPools.freq
	Dictionary.nouns = cachedPools.nouns
	Dictionary.learned = cachedPools.learned
	Dictionary.huge = cachedPools.huge or {}
	Dictionary.hugeLoaded = cachedPools.hugeLoaded == true
	Dictionary.total = cachedPools.total
	Dictionary.loaded = true
	Dictionary.source = "from memory"
end
local function reloadDictionaries()
	Dictionary.loaded = false
	buildDictionary(true, function()
		log("<Success>Dictionary ready</Success> — " .. Dictionary.total .. " words")
		notify("Dictionary ready", string.format("%d words: %s", Dictionary.total, Dictionary.source), "Success")
	end)
end
local NEIGHBORS = {}
do
	local KB_ROWS = { "йцукенгшщзхъ", "фывапролджэ", "ячсмитьбю" }
	local pos = {}
	for r, row in ipairs(KB_ROWS) do
		local col = 1
		for _, cp in utf8.codes(row) do
			pos[utf8.char(cp)] = { r = r, c = col }
			col += 1
		end
	end
	local function charAt(row, col)
		local c = 1
		for _, cp in utf8.codes(row) do
			if c == col then return utf8.char(cp) end
			c += 1
		end
		return nil
	end
	for ch, p in pairs(pos) do
		local opts = {}
		for dr = -1, 1 do
			local row = KB_ROWS[p.r + dr]
			if row then
				for dc = -1, 1 do
					if dr ~= 0 or dc ~= 0 then
						local nch = charAt(row, p.c + dc)
						if nch then opts[#opts + 1] = nch end
					end
				end
			end
		end
		NEIGHBORS[ch] = opts
	end
end
local FALLBACK_LETTERS = {}
for _, cp in utf8.codes("абвгдежзиклмнопрстуфхцчшэю") do
	FALLBACK_LETTERS[#FALLBACK_LETTERS + 1] = utf8.char(cp)
end
local function neighborOf(ch)
	local o = NEIGHBORS[ch]
	if o and #o > 0 then
		return o[math.random(1, #o)]
	end
	return FALLBACK_LETTERS[math.random(1, #FALLBACK_LETTERS)]
end
Game = {
	snapshot = nil,
	phase = "lobby",
	letter = "",
	you = nil,
	turn = nil,
	tableId = nil,
	round = 0,
	generation = 0,
	deadline = 0,
	turnDuration = 15,
	turnRemaining = 15,
	bot = false,
	choices = nil,
	chooser = nil,
	notice = "",
	history = {},
	at = 0,
	matches = 0,
	midMatch = false,
}
local Solver = {
	used = {},
	bad = {},
	requestId = 0,
	attempts = 0,
	turnKey = nil,
	chooseKey = nil,
	turnStarted = 0,
	nextTry = 0,
	solved = 0,
	rejected = 0,
	collisions = 0,
	resends = 0,
	resendsTotal = 0,
	pending = nil,
	planning = nil,
	lastWord = "",
	practiceCooldown = 0,
	typing = false,
}
local function randomIn(a, b)
	return a + (b - a) * math.random()
end
local function timeLeft()
	local total = Game.turnRemaining or Game.turnDuration or 0
	return math.max(0, total - (os.clock() - Game.at))
end
local function markUsed(word)
	if type(word) ~= "string" then
		return
	end
	local cleaned = cleanWord(word)
	if cleaned then
		Solver.used[cleaned] = true
	end
end
State.OnClientEvent:Connect(function(payload)
	if not scriptAlive() or type(payload) ~= "table" then
		return
	end
	local kind = payload.kind
	if kind == "match" then
		Game.snapshot = payload
		Game.at = os.clock()
		Game.phase = tostring(payload.phase or "lobby")
		Game.letter = string.lower(tostring(payload.letter or ""))
		Game.you = payload.you
		Game.turn = payload.turn
		Game.tableId = payload.tableId
		Game.round = tonumber(payload.round) or 0
		Game.generation = tonumber(payload.generation) or 0
		Game.deadline = tonumber(payload.deadline) or 0
		Game.turnDuration = tonumber(payload.turnDuration) or 15
		Game.bot = payload.bot == true
		Game.choices = payload.choices
		Game.chooser = payload.chooser
		Game.notice = tostring(payload.notice or "")
		Game.history = payload.history or {}
		local left = Game.turnDuration
		if Game.deadline > 0 then
			left = Game.deadline - os.time()
			if left < 0 or left > Game.turnDuration + 10 then
				left = Game.turnDuration
			end
		end
		Game.turnRemaining = math.max(0, left)
		local matchKey = tostring(Game.tableId) .. ":" .. tostring(Game.generation)
		if Game.matchKey ~= matchKey then
			Game.matchKey = matchKey
			Game.midMatch = Game.round > 1
			Solver.used = {}
			Solver.turnKey = nil
			Solver.chooseKey = nil
			Solver.pending = nil
			Solver.planning = nil
			Solver.resends = 0
			if Game.phase == "countdown" then
				Game.matches += 1
			end
		end
		for _, word in ipairs(Game.history) do
			markUsed(word)
		end
		if payload.lastWord and payload.lastWord ~= "" then
			markUsed(payload.lastWord)
		end
		return
	end
	if kind == "accepted" then
		local word = cleanWord(tostring(payload.word or ""))
		if word then
			if Game.tableId ~= nil and payload.tableId == Game.tableId then
				markUsed(word)
			end
			if Settings.learn then
				learnWord(word)
			end
			if Solver.pending and Solver.pending.word == word
				and payload.tableId == Solver.pending.tableId
				and tonumber(payload.round) == Solver.pending.round then
				Solver.solved += 1
				Solver.pending = nil
				log("<Success>Accepted: " .. word .. "</Success>")
			end
		end
		return
	end
	if kind == "invalid" then
		local mine = Solver.pending
			and payload.tableId == Solver.pending.tableId
			and tonumber(payload.round) == Solver.pending.round
		local reason = tostring(payload.reason or "")
		local text = tostring(payload.text or "")
		if mine then
			local word = Solver.pending and Solver.pending.word
			if reason == "used" then
				Solver.collisions += 1
				if word then
					markUsed(word)
				end
				log("<Muted>Already used in this match, picking another</Muted>")
			else
				Solver.rejected += 1
				if word then
					Solver.bad[word] = true
				end
				log("<Warning>Rejected: " .. (text ~= "" and text or reason) .. "</Warning>")
			end
			Solver.pending = nil
		end
		return
	end
	if kind == "wordRejected" then
		local mine = Solver.pending and payload.requestId == Solver.pending.requestId
		if mine then
			Solver.rejected += 1
			Solver.attempts = Settings.attempts
			Solver.pending = nil
			log("<Warning>Rejected: " .. tostring(payload.text or payload.reason or "turn already gone") .. "</Warning>")
		end
		return
	end
	if kind == "toast" then
		local text = tostring(payload.text or "")
		if string.find(text, "Подожди") then
			Solver.practiceCooldown = os.clock() + 10
		end
		return
	end
	if kind == "result" then
		local resultTable = tonumber(string.match(tostring(payload.rewardId or ""), "^(%d+):"))
		if resultTable and Game.tableId and resultTable ~= Game.tableId then
			return
		end
		Game.phase = "finished"
		Game.turn = nil
		Solver.pending = nil
		Solver.planning = nil
		saveLearned()
		log(payload.won == true and "<Success>Match won</Success>" or "<Warning>Match over</Warning>")
		if payload.won == true then
			notify("Ixa Hub", "Match won", "Success")
		end
		return
	end
end)
local function showTypingText(text)
	if not Settings.showTyping then
		return
	end
	local box = typingBox()
	if box then
		pcall(function()
			box.Text = text
		end)
	end
end
local function sendTyping(text)
	pcall(function()
		Action:FireServer("typing", text, {
			tableId = Game.tableId,
			round = Game.round,
			generation = Game.generation or 0,
		})
	end)
end
local function typeText(text)
	showTypingText(text)
	sendTyping(text)
end
local function humanType(suffix, deadlineAt, fast, T)
	local n = charCount(suffix)
	if n == 0 then
		return true
	end
	if n == 1 then
		typeText(suffix)
		return true
	end
	Solver.typing = true
	local typoChance = fast and (T.TYPO or 0) * 0.25 or (T.TYPO or 0)
	local typos = {}
	local typoCount = 0
	if math.random() < typoChance then
		typos[math.random(2, n)] = true
		typoCount += 1
		if n >= 5 and math.random() < 0.15 then
			local p2 = math.random(2, n)
			if not typos[p2] then
				typos[p2] = true
				typoCount += 1
			end
		end
	end
	local pauseAt = nil
	if (not fast) and n >= 4 and math.random() < (T.MIDPAUSE or 0) then
		pauseAt = math.random(2, n - 1)
	end
	local extra = typoCount * randomIn(0.28, 0.5) + (pauseAt and randomIn(0.15, 0.35) or 0)
	local budget = math.max(0.12, (deadlineAt - 0.25) - os.clock() - extra)
	local perChar = math.clamp(budget / n, 0.03, 0.4)
	local function aborted()
		if not scriptAlive() or Solver.typing == false then
			return true
		end
		return Game.phase ~= "playing" or Game.turn ~= Game.you
	end
	local i = 1
	while i <= n do
		if aborted() then
			Solver.typing = false
			return false
		end
		if os.clock() > deadlineAt - 0.1 then
			break
		end
		if typos[i] then
			local o = utf8.offset(suffix, i)
			local o2 = utf8.offset(suffix, i + 1)
			local prefix = string.sub(suffix, 1, (o and o - 1) or #suffix)
			local cur = string.sub(suffix, o, (o2 or (#suffix + 1)) - 1)
			local wrong = neighborOf(cur)
			if math.random() < 0.25 then
				wrong = cur .. cur
			end
			typeText(prefix .. wrong)
			task.wait(randomIn(0.08, 0.22))
			if aborted() then Solver.typing = false return false end
			typeText(prefix)
			if i > 2 and math.random() < 0.3 then
				task.wait(randomIn(0.05, 0.14))
				if aborted() then Solver.typing = false return false end
				local lastByte = utf8.offset(prefix, charCount(prefix))
				if lastByte and lastByte > 1 then
					typeText(string.sub(prefix, 1, lastByte - 1))
					task.wait(randomIn(0.06, 0.16))
					if aborted() then Solver.typing = false return false end
					typeText(prefix)
				end
			end
			task.wait(randomIn(0.05, 0.14))
			typos[i] = nil
		else
			local o2 = utf8.offset(suffix, i + 1)
			typeText(string.sub(suffix, 1, (o2 and o2 - 1) or #suffix))
			if pauseAt == i then
				task.wait(randomIn(0.15, 0.35))
				pauseAt = nil
			end
			task.wait(perChar * randomIn(0.55, 1.55))
			i += 1
		end
	end
	Solver.typing = false
	return true
end
local function pickWord(letter)
	local key = firstChar(letter)
	local sources
	if Game.midMatch then
		sources = { Dictionary.freq, Dictionary.nouns, Dictionary.learned, Dictionary.huge, Dictionary.fallback }
	else
		sources = { Dictionary.learned, Dictionary.freq, Dictionary.nouns, Dictionary.huge, Dictionary.fallback }
	end
	local fallback = nil
	for _, pool in ipairs(sources) do
		local bucket = pool[key]
		if bucket then
			for _, word in ipairs(bucket) do
				if not Solver.used[word] and not Solver.bad[word] then
					if Settings.safeEndings and BAD_ENDINGS[lastChar(word)] then
						fallback = fallback or word
					else
						return word
					end
				end
			end
		end
	end
	return fallback
end
local function bestChoice(choices)
	local best, bestCount = nil, -1
	for _, letter in ipairs(choices) do
		local lowered = string.lower(tostring(letter))
		local key = firstChar(lowered)
		local count = #(Dictionary.freq[key] or {}) + #(Dictionary.nouns[key] or {})
			+ #(Dictionary.learned[key] or {}) + #(Dictionary.huge[key] or {})
		if count > bestCount then
			best, bestCount = lowered, count
		end
	end
	return best
end
local function submitWord(word)
	local letter = string.lower(tostring(Game.letter or ""))
	local rest = restOfWord(word)
	Solver.requestId += 1
	local payload = {
		requestId = Solver.requestId,
		tableId = Game.tableId,
		round = Game.round,
		generation = Game.generation or 0,
	}
	Solver.pending = {
		word = word,
		tableId = Game.tableId,
		round = Game.round,
		generation = Game.generation or 0,
		requestId = payload.requestId,
		at = os.clock(),
		resent = false,
	}
	if Settings.showTyping then
		local box = typingBox()
		if box then
			pcall(function()
				box.Text = rest
			end)
		end
	end
	Action:FireServer("word", letter .. rest, payload)
	Solver.lastWord = word
	Solver.attempts += 1
	log(string.format("Answer: <Accent>%s</Accent> (%d)", word, charCount(word)))
end
local function answerTurn(key, T)
	local function aborted()
		return not scriptAlive() or Solver.planning ~= key
			or Game.phase ~= "playing" or Game.turn ~= Game.you
	end
	local word = pickWord(Game.letter)
	if not word then
		Solver.attempts = Settings.attempts
		Solver.planning = nil
		log("<Warning>No words for «" .. string.upper(Game.letter) .. "»</Warning>")
		return
	end
	Solver.used[word] = true
	local think = randomIn(T.THINK_MIN, T.THINK_MAX) + (Settings.delay or 0)
	if math.random() < (T.LONG_CHANCE or 0) then
		think += randomIn(0.2, T.LONG_EXTRA or 0.4)
	end
	local startedAt = os.clock()
	local left = timeLeft()
	if Game.deadline > 0 then
		think = math.min(think, math.max(0.05, left - 1.2))
	end
	task.wait(think)
	if aborted() then
		Solver.planning = nil
		return
	end
	local deadlineAt = startedAt + T.DEADLINE
	if Game.deadline > 0 then
		local serverEnd = os.clock() + timeLeft() - 0.9
		deadlineAt = math.min(deadlineAt, serverEnd)
	end
	local suffix = restOfWord(word)
	if T.FAST then
		showTypingText(suffix)
		sendTyping(suffix)
	elseif os.clock() < deadlineAt - 0.4 then
		if not humanType(suffix, deadlineAt, false, T) then
			Solver.planning = nil
			return
		end
	end
	if os.clock() >= deadlineAt - 0.2 then
		submitWord(word)
		Solver.planning = nil
		return
	end
	local remaining = deadlineAt - 0.08 - os.clock()
	if T.REVIEW ~= false and T.FAST ~= true and remaining > 0.15 then
		task.wait(math.min(randomIn(0.1, 0.3), remaining))
	end
	if aborted() then
		Solver.planning = nil
		return
	end
	submitWord(word)
	Solver.nextTry = os.clock() + 0.25
	Solver.planning = nil
end
local function solverTick()
	if not (Settings.solve and scriptAlive()) then
		return
	end
	if (os.clock() - Game.at) > 20 then
		return
	end
	local now = os.clock()
	local T = curT()
	if Game.phase == "choosing" and Game.chooser == Game.you and Game.choices then
		if not Settings.autoChoose then
			return
		end
		local key = table.concat({ Game.tableId, Game.round, Game.generation }, ":")
		if Solver.chooseKey ~= key then
			local letter = bestChoice(Game.choices)
			if letter then
				Solver.chooseKey = key
				Solver.planning = "choose:" .. key
				task.delay(randomIn(T.CHOOSE[1], T.CHOOSE[2]), function()
					if scriptAlive() and Solver.planning == "choose:" .. key
						and Game.phase == "choosing" and Game.chooser == Game.you then
						Action:FireServer("choose", letter)
						log("Letter picked: <Accent>" .. string.upper(letter) .. "</Accent>")
					end
					if Solver.planning == "choose:" .. key then
						Solver.planning = nil
					end
				end)
			end
		end
		return
	end
	if Game.phase ~= "playing" or Game.turn ~= Game.you then
		return
	end
	local frame = matchFrame()
	if frame and not frame.Visible then
		return
	end
	if not Dictionary.loaded then
		return
	end
	if Solver.pending then
		local waited = now - (Solver.pending.at or 0)
		if waited < T.RESEND_AFTER then
			return
		end
		if not Solver.pending.resent and Solver.resends < T.RESEND_MAX then
			Solver.pending.resent = true
			Solver.pending.at = now
			Solver.resends += 1
			Solver.resendsTotal += 1
			log("<Warning>No confirmation for " .. string.format("%.1f", waited) .. " s, resending «" .. Solver.pending.word .. "»</Warning>")
			pcall(function()
				Action:FireServer("sync")
			end)
			Action:FireServer("word", string.lower(tostring(Game.letter or "")) .. restOfWord(Solver.pending.word), {
				requestId = Solver.pending.requestId,
				tableId = Solver.pending.tableId,
				round = Solver.pending.round,
				generation = Solver.pending.generation or 0,
			})
			return
		end
		Solver.pending = nil
		return
	end
	local key = table.concat({ Game.tableId, Game.round, Game.generation }, ":")
	if Solver.turnKey ~= key then
		Solver.turnKey = key
		Solver.attempts = 0
		Solver.resends = 0
		Solver.turnStarted = now
	end
	if Solver.planning then
		return
	end
	if Solver.attempts >= Settings.attempts or now < Solver.nextTry then
		return
	end
	if Game.deadline > 0 and timeLeft() < 0.9 then
		return
	end
	Solver.planning = key
	task.spawn(function()
		local ok, err = pcall(answerTurn, key, T)
		if not ok then
			warn("[Ixa Hub] " .. tostring(err))
		end
		if Solver.planning == key then
			Solver.planning = nil
		end
	end)
end
local function answerOnce()
	if Game.phase ~= "playing" or Game.turn ~= Game.you then
		log("<Warning>Not your turn right now</Warning>")
		return
	end
	if not Dictionary.loaded then
		log("<Warning>Dictionary is still loading</Warning>")
		return
	end
	local word = pickWord(Game.letter)
	if not word then
		log("<Warning>No words for «" .. string.upper(Game.letter) .. "»</Warning>")
		return
	end
	Solver.used[word] = true
	if Settings.showTyping then
		local box = typingBox()
		if box then
			pcall(function()
				box.Text = restOfWord(word)
			end)
		end
	end
	sendTyping(restOfWord(word))
	submitWord(word)
end
local function setSolve(on)
	Settings.solve = on
	if UiRefs.solve then
		UiRefs.solve:Set(on, true)
	end
	log(on and "Solver on" or "Solver off")
end
local function setAutoChoose(on)
	Settings.autoChoose = on
	if UiRefs.autoChoose then
		UiRefs.autoChoose:Set(on, true)
	end
end
local function setSafeEndings(on)
	Settings.safeEndings = on
	if UiRefs.safeEndings then
		UiRefs.safeEndings:Set(on, true)
	end
end
local function setShowTyping(on)
	Settings.showTyping = on
	if UiRefs.showTyping then
		UiRefs.showTyping:Set(on, true)
	end
end
local function setLearn(on)
	Settings.learn = on
	if UiRefs.learn then
		UiRefs.learn:Set(on, true)
	end
	saveLearned()
end
local function setMode(mode)
	if not MODE_LABELS[mode] then
		mode = "legit"
	end
	Settings.mode = mode
	if UiRefs.mode then
		pcall(function()
			UiRefs.mode:Set(MODE_LABELS[mode], true)
		end)
	end
	if mode == "rage" then
		notify("Ixa Hub", "Mode: RAGE - maximum speed", "Warning")
	elseif mode == "superlegit" then
		notify("Ixa Hub", "Mode: SUPER LEGIT - slow and careful", "Success")
	else
		notify("Ixa Hub", "Mode: LEGIT - like a human", "Success")
	end
	log("<Accent>Mode: " .. MODE_LABELS[mode] .. "</Accent>")
end
local function setKeepHistory(on)
	Settings.keepHistory = on
	if UiRefs.keepHistory then
		UiRefs.keepHistory:Set(on, true)
	end
	if Log then
		Log:Clear()
		if on then
			Log:Push("History enabled")
		end
	end
end
local lastLeave, lastPractice = 0, 0
local function setAutoPractice(on)
	Settings.autoPractice = on
	if UiRefs.autoPractice then
		UiRefs.autoPractice:Set(on, true)
	end
	log(on and "Post-match practice on" or "Post-match practice off")
end
local function practiceTick()
	if not Settings.autoPractice then
		return
	end
	local now = os.clock()
	if now < (Solver.practiceCooldown or 0) then
		return
	end
	local playing = Game.phase == "playing"
		or Game.phase == "choosing"
		or Game.phase == "countdown"
	local fresh = (now - Game.at) < 12
	if playing and fresh then
		return
	end
	local match = matchFrame()
	local lobby = lobbyFrame()
	if match and match.Visible then
		if now - lastLeave > 4 then
			lastLeave = now
			Action:FireServer("leave")
		end
		return
	end
	if lobby and lobby.Visible then
		if now - lastPractice > 7 then
			lastPractice = now
			Action:FireServer("practice")
		end
		return
	end
	if now - lastLeave > 6 then
		lastLeave = now
		Action:FireServer("leave")
	end
end
RunService.Heartbeat:Connect(function()
	if not scriptAlive() then
		return
	end
	pcall(solverTick)
end)
task.spawn(function()
	while scriptAlive() do
		pcall(practiceTick)
		task.wait(0.25)
	end
end)
task.spawn(function()
	while scriptAlive() do
		saveLearned()
		task.wait(10)
	end
end)
local THEME = Airflow.ThemePresets.Sakura
if THEME then
	pcall(function()
		Airflow:SetDefaultTheme(THEME)
	end)
end
local previousWindow = getgenv().__IxaHubWindow
if previousWindow then
	pcall(function()
		previousWindow:Destroy()
	end)
end
pcall(function()
	local holders = { LocalPlayer:FindFirstChild("PlayerGui") }
	local ok, hui = pcall(gethui)
	if ok and hui then
		table.insert(holders, hui)
	end
	for _, holder in ipairs(holders) do
		local stale = holder and holder:FindFirstChild("Ixa Hub")
		if stale then
			stale:Destroy()
		end
	end
end)
Window = Airflow:CreateWindow({
	Name = "Ixa Hub",
	LoadingSubtitle = "Word solver",
	ToggleUIKeybind = KEYS.ui,
	OpenButton = false,
	Size = UDim2.fromOffset(780, 540),
	Backdrop = { Weather = "Fireflies", Mode = "Screen", Tint = 0.35, Dim = true },
	Transparent = true,
	Background = "Lavender Pink",
	CornerRadius = 10,
	UIScale = 1,
	AdaptiveSize = false,
	Theme = THEME,
	ConfigurationSaving = { Enabled = true, FolderName = "IxaHub" },
	Home = {
		Name = "Home",
		Title = "Ixa Hub",
		Welcome = "Welcome back,",
		Tier = "v2.0",
		Stats = { "Players", "Session", "FPS", "Ping", "Game", "Executor" },
	},
})
getgenv().__IxaHubWindow = Window
local SolverTab = Window:CreateTab({ Name = "Solver", Icon = "brain" })
local SolveMain = SolverTab:CreateGroupbox({ Name = "Solver", Side = "Left" })
local SolveInfo = SolverTab:CreateGroupbox({ Name = "State", Side = "Right" })
local SolveTune = SolverTab:CreateGroupbox({ Name = "Tuning", Side = "Right" })
UiRefs.solve = SolveMain:CreateToggle({
	Name = "Auto-answer",
	Desc = "Sends a word on each of your turns",
	Flag = "SolveOn",
	CurrentValue = true,
	Callback = function(on)
		setSolve(on)
	end,
})
UiRefs.mode = SolveMain:CreateDropdown({
	Name = "Mode",
	Desc = "Super legit - calm but quick typing with typos. Legit - like a human. Rage - maximum speed",
	Flag = "SolveMode",
	Options = { "Super legit", "Legit", "Rage" },
	Default = "Legit",
	Callback = function(value)
		if type(value) == "table" then
			value = value[1]
		end
		setMode(MODE_BY_LABEL[value] or "legit")
	end,
})
UiRefs.autoChoose = SolveMain:CreateToggle({
	Name = "Pick the first letter",
	Desc = "When the game offers a choice, picks the letter with the most words",
	Flag = "AutoChoose",
	CurrentValue = true,
	Callback = function(on)
		setAutoChoose(on)
	end,
})
UiRefs.autoPractice = SolveMain:CreateToggle({
	Name = "Practice after match",
	Desc = "Lobby only: leaves the result screen and starts a match with the bot",
	Flag = "AutoPractice",
	CurrentValue = false,
	Callback = function(on)
		setAutoPractice(on)
	end,
})
UiRefs.safeEndings = SolveMain:CreateToggle({
	Name = "Safe endings",
	Desc = "Skips words that leave no answer option",
	Flag = "SafeEndings",
	CurrentValue = true,
	Callback = function(on)
		setSafeEndings(on)
	end,
})
UiRefs.showTyping = SolveMain:CreateToggle({
	Name = "Show answer in the game box",
	Desc = "You and opponents watch the script type",
	Flag = "ShowTyping",
	CurrentValue = true,
	Callback = function(on)
		setShowTyping(on)
	end,
})
UiRefs.learn = SolveMain:CreateToggle({
	Name = "Learn accepted words",
	Desc = "Words the game accepted go into the reserve",
	Flag = "LearnWords",
	CurrentValue = true,
	Callback = function(on)
		setLearn(on)
	end,
})
SolveMain:CreateButton({
	Name = "Answer once",
	Desc = "Picks and sends a word right now",
	Icon = "zap",
	Style = "Primary",
	Callback = function()
		answerOnce()
	end,
})
SolveTune:CreateSlider({
	Name = "Extra delay before answer",
	Min = 0,
	Max = 3,
	Increment = 0.05,
	Suffix = " s",
	CurrentValue = 0.10,
	Flag = "AnswerDelay",
	Callback = function(value)
		Settings.delay = value
	end,
})
SolveTune:CreateSlider({
	Name = "Attempts per turn",
	Min = 1,
	Max = 12,
	Increment = 1,
	CurrentValue = 6,
	Flag = "MaxTries",
	Callback = function(value)
		Settings.attempts = math.floor(value)
	end,
})
SolveTune:CreateSlider({
	Name = "Typo chance (LEGIT)",
	Min = 0,
	Max = 50,
	Increment = 1,
	Suffix = "%",
	CurrentValue = 18,
	Flag = "TypoChance",
	Callback = function(value)
		MODES.legit.TYPO = value / 100
		MODES.latelegit.TYPO = value / 100
		MODES.superlegit.TYPO = value / 100
	end,
})
SolveInfo:CreateStatus({
	Name = "Status",
	Style = "Row",
	Pin = true,
	Update = function()
		if not Settings.solve then
			return "<Muted>off</Muted>"
		end
		if (os.clock() - Game.at) > 20 then
			return "<Muted>in lobby</Muted>"
		end
		if Game.phase == "choosing" then
			return Game.chooser == Game.you and "<Warning>choosing letter</Warning>" or "<Muted>waiting for letter</Muted>"
		end
		if Game.phase ~= "playing" then
			return "<Muted>" .. Game.phase .. "</Muted>"
		end
		if Solver.typing then
			return "<Accent>typing…</Accent>"
		end
		return Game.turn == Game.you and "<Success>my turn</Success>" or "<Muted>opponent's turn</Muted>"
	end,
})
SolveInfo:CreateStatus({
	Name = "Mode",
	Style = "Row",
	Update = function()
		local mode = Settings.mode or "legit"
		if mode == "rage" then
			return "<Warning>RAGE</Warning>"
		end
		if mode == "superlegit" then
			return "<Accent>SUPER LEGIT</Accent>"
		end
		if curT() == MODES.latelegit then
			return "<Accent>LEGIT - rounds 50+</Accent>"
		end
		return "<Success>LEGIT</Success>"
	end,
})
SolveInfo:CreateStatus({
	Name = "Letter",
	Style = "Row",
	Update = function()
		if Game.letter == "" then
			return "<Muted>-</Muted>"
		end
		return "<Accent>" .. string.upper(Game.letter) .. "</Accent>"
	end,
})
SolveInfo:CreateStatus({
	Name = "Last answer",
	Style = "Row",
	Update = function()
		return Solver.lastWord ~= "" and Solver.lastWord or "<Muted>-</Muted>"
	end,
})
SolveInfo:CreateStatus({
	Name = "Turn time",
	Style = "Bar",
	Max = 15,
	Update = function()
		return math.min(Game.turnDuration or 15, timeLeft())
	end,
})
SolveInfo:CreateStatus({
	Name = "Solved",
	Style = "Row",
	Update = function()
		return "<Success>" .. Solver.solved .. "</Success>"
	end,
})
SolveInfo:CreateStatus({
	Name = "Rejected",
	Style = "Row",
	Update = function()
		return tostring(Solver.rejected)
	end,
})
SolveInfo:CreateStatus({
	Name = "Round",
	Style = "Row",
	Update = function()
		return tostring(Game.round)
	end,
})
SolveInfo:CreateStatus({
	Name = "Dictionary",
	Style = "Row",
	Update = function()
		if not Dictionary.loaded then
			return "<Muted>loading…</Muted>"
		end
		local base = string.format("%d words", Dictionary.total)
		if Dictionary.hugeLoaded then
			base = base .. string.format(" + %.1fM", countPool(Dictionary.huge) / 1e6)
		end
		return base
	end,
})
local WordsTab = Window:CreateTab({ Name = "Words", Icon = "book-open" })
local DataBox = WordsTab:CreateGroupbox({ Name = "Dictionary", Side = "Left" })
local NotesBox = WordsTab:CreateGroupbox({ Name = "Reserve", Side = "Right" })
DataBox:CreateLabel({
	Text = "Loading…",
	Update = function()
		if not Dictionary.loaded then
			return "Words are still loading…"
		end
		local text = string.format("%d words (%s)", Dictionary.total, Dictionary.source)
		if Dictionary.hugeLoaded then
			text = text .. string.format("\nHuge base: %d word forms", countPool(Dictionary.huge))
		else
			text = text .. "\nHuge base: downloading from GitHub…"
		end
		return text
	end,
})
DataBox:CreateButton({
	Name = "Reload dictionary",
	Icon = "refresh-cw",
	Callback = function()
		task.spawn(reloadDictionaries)
	end,
})
DataBox:CreateInput({
	Name = "Add your own word",
	PlaceholderText = "word",
	Callback = function(text)
		local word = cleanWord(string.lower(tostring(text)))
		if not word then
			log("<Warning>Needs a Russian word, 3–29 letters</Warning>")
			return
		end
		if learnWord(word) then
			log("Added: <Accent>" .. word .. "</Accent>")
		else
			log("<Muted>Already have: " .. word .. "</Muted>")
		end
	end,
})
NotesBox:CreateStatus({
	Name = "Learned",
	Style = "Row",
	Update = function()
		return tostring(countPool(Dictionary.learned))
	end,
})
NotesBox:CreateButton({
	Name = "Save words",
	Icon = "save",
	Callback = function()
		Dictionary.learnedDirty = true
		saveLearned()
		log("Words saved")
	end,
})
local LogTab = Window:CreateTab({ Name = "Log", Icon = "scroll-text" })
local LogBox = LogTab:CreateGroupbox({ Name = "What the script is doing", Side = "Left" })
UiRefs.keepHistory = LogBox:CreateToggle({
	Name = "Keep history",
	Desc = "Log and word saving to disk. Off — nothing piles up",
	Flag = "KeepHistory",
	CurrentValue = false,
	Callback = function(on)
		setKeepHistory(on)
	end,
})
Log = LogBox:CreateLog({
	Name = "Actions",
	MaxEntries = 300,
	MaxRows = 14,
	Timestamps = true,
	EmptyText = "Empty for now",
})
local SettingsTab = Window:CreateTab({ Name = "Settings", Icon = "settings" })
SettingsTab:CreateConfigManager({ Name = "Configs", Side = "Left" })
SettingsTab:CreateThemeManager({ Name = "Theme", Side = "Right" })
local HelpBox = SettingsTab:CreateGroupbox({ Name = "Info", Side = "Right" })
HelpBox:CreateParagraph({
	Title = "Controls",
	Content = "Nothing to press - the script answers on its own from the moment it loads.\n\nK - show or hide this window.\nMode is picked in the Solver tab: Super legit, Legit or Rage.",
})
HelpBox:CreateParagraph({
	Title = "Modes",
	Content = "Super legit - thinks under a second, types calmly, sometimes makes typos and fixes them.\nLegit - quick human typing, ~1-3 s per answer (calmer from round 50).\nRage - maximum speed, minimum realism.",
})
HelpBox:CreateParagraph({
	Title = "LEGIT by rounds",
	Content = "Rounds 1–49: quick answers (~1–3 s).\nFrom round 50: calmer (~1.5–6 s) — the game gives ~8 s, the script always makes it in time and checks the server confirmed the word.",
})
task.spawn(function()
	buildDictionary(false, function(ok)
		if ok then
			log(string.format("<Success>Dictionary ready</Success> — %d words", Dictionary.total))
			notify("Ixa Hub", string.format("Dictionary: %d words; huge base downloading…", Dictionary.total), "Success")
		else
			log("<Warning>Dictionary failed to load, using the built-in list</Warning>")
		end
	end)
end)
task.spawn(function()
	Action:FireServer("sync")
	task.wait(2)
	pcall(function()
		Window:LoadAutoload()
	end)
end)
getgenv().__IxaHub = {
	window = Window,
	log = Log,
	game = Game,
	solver = Solver,
	settings = Settings,
	dictionary = Dictionary,
	reload = reloadDictionaries,
	setMode = setMode,
	setRage = function(on)
		setMode(on and "rage" or "legit")
	end,
}
local DISCORD_INVITE = "https://discord.gg/BpfKcTbap2"
local PROMO_INTERVAL = 30 * 60
local PROMO_VISIBLE_TIME = 25
local PROMO_STRINGS = {
	English = {
		Title = "Subscribe to our Discord",
		Hint = "Updates, scripts and support live there",
		Copy = "Copy",
		Done = "Done",
		Copied = "Link copied",
		Manual = "Copy it manually",
	},
	Russian = {
		Title = "Подпишись на Discord канал",
		Hint = "Там обновления, скрипты и поддержка",
		Copy = "Копировать",
		Done = "Готово",
		Copied = "Ссылка скопирована",
		Manual = "Скопируй вручную",
	},
}
local promoGui = nil
local promoFrame = nil
local promoParts = nil
local promoToken = 0
local promoCopied = false
local promoCopyFailed = false
local promoStopped = false
local function promoStrings()
	local language = "English"
	pcall(function()
		if type(InterfaceLanguage) == "string" then
			language = InterfaceLanguage
		elseif type(getgenv) == "function" and type(getgenv().InterfaceLanguage) == "string" then
			language = getgenv().InterfaceLanguage
		end
	end)
	return PROMO_STRINGS[language] or PROMO_STRINGS.English
end
local function copyPromoLink()
	local copied = false
	pcall(function()
		local fn = setclipboard or toclipboard or (syn and syn.setclipboard)
		if type(fn) == "function" then
			fn(DISCORD_INVITE)
			copied = true
		end
	end)
	return copied
end
local function promoHolderParent()
	local mainWindow = (type(getgenv) == "function" and getgenv().__IxaHubWindow) or Window
	if mainWindow and mainWindow.Gui and typeof(mainWindow.Gui) == "Instance" and mainWindow.Gui.Parent then
		return mainWindow.Gui.Parent, mainWindow.Gui.DisplayOrder
	end
	local ok, hui = pcall(function()
		if typeof(gethui) == "function" then return gethui() end
	end)
	if ok and typeof(hui) == "Instance" then
		return hui, 999
	end
	local coreOk, coreGui = pcall(function() return game:GetService("CoreGui") end)
	if coreOk and coreGui then
		local canParent = pcall(function()
			local probe = Instance.new("Folder")
			probe.Parent = coreGui
			probe:Destroy()
		end)
		if canParent then return coreGui, 999 end
	end
	return nil, 999
end
local function promoHolder()
	if promoGui and promoGui.Parent then return promoGui end
	promoGui = nil
	local parent, order = promoHolderParent()
	local playerGui
	if not parent then
		playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
		if not playerGui then
			local waited = LocalPlayer:WaitForChild("PlayerGui", 10)
			playerGui = waited and waited:IsA("PlayerGui") and waited or LocalPlayer:FindFirstChildOfClass("PlayerGui")
		end
		parent = playerGui
	end
	if not parent then return nil end
	local gui = Instance.new("ScreenGui")
	gui.Name = "IxaHubPromo"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = (order or 999) + 1
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	pcall(function()
		if typeof(syn) == "table" and type(syn.protect_gui) == "function" then
			syn.protect_gui(gui)
		elseif typeof(protectgui) == "function" then
			protectgui(gui)
		end
	end)
	local inserted = pcall(function()
		gui.Parent = parent
	end)
	if not inserted or not gui.Parent then
		if playerGui == nil then
			playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
		end
		if not playerGui then
			gui:Destroy()
			return nil
		end
		gui.Parent = playerGui
	end
	promoGui = gui
	return gui
end
local function refreshPromoToastTexts()
	if not promoParts then return end
	local strings = promoStrings()
	pcall(function()
		promoParts.title.Text = strings.Title
		if promoCopied then
			promoParts.copy.Text = strings.Done
			promoParts.hint.Text = strings.Copied .. ": " .. DISCORD_INVITE
			promoParts.hint.TextColor3 = Color3.fromRGB(170, 226, 178)
		elseif promoCopyFailed then
			promoParts.copy.Text = strings.Copy
			promoParts.hint.Text = strings.Manual .. ": " .. DISCORD_INVITE
			promoParts.hint.TextColor3 = Color3.fromRGB(232, 200, 140)
		else
			promoParts.copy.Text = strings.Copy
			promoParts.hint.Text = strings.Hint
			promoParts.hint.TextColor3 = Color3.fromRGB(170, 162, 175)
		end
	end)
end
local function buildPromoToast(gui)
	local strings = promoStrings()
	local toast = Instance.new("Frame")
	toast.Name = "DiscordPromo"
	toast.AnchorPoint = Vector2.new(0.5, 0)
	toast.Position = UDim2.new(0.5, 0, 0, 14)
	toast.Size = UDim2.fromOffset(382, 0)
	toast.AutomaticSize = Enum.AutomaticSize.Y
	toast.BackgroundColor3 = Color3.fromRGB(27, 21, 30)
	toast.BackgroundTransparency = 0.04
	toast.BorderSizePixel = 0
	toast.ZIndex = 100
	toast.Parent = gui
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = toast
	local popScale = Instance.new("UIScale")
	popScale.Scale = 0.95
	popScale.Parent = toast
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(232, 164, 205)
	stroke.Thickness = 1
	stroke.Transparency = 0.5
	stroke.Parent = toast
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 12)
	padding.PaddingBottom = UDim.new(0, 12)
	padding.PaddingLeft = UDim.new(0, 14)
	padding.PaddingRight = UDim.new(0, 14)
	padding.Parent = toast
	local list = Instance.new("UIListLayout")
	list.FillDirection = Enum.FillDirection.Vertical
	list.HorizontalAlignment = Enum.HorizontalAlignment.Left
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding = UDim.new(0, 8)
	list.Parent = toast
	local header = Instance.new("Frame")
	header.BackgroundTransparency = 1
	header.Size = UDim2.new(1, 0, 0, 22)
	header.LayoutOrder = 1
	header.Parent = toast
	local badge = Instance.new("TextLabel")
	badge.AnchorPoint = Vector2.new(0, 0.5)
	badge.Position = UDim2.new(0, 0, 0.5, 0)
	badge.Size = UDim2.fromOffset(62, 18)
	badge.BackgroundColor3 = Color3.fromRGB(232, 164, 205)
	badge.BackgroundTransparency = 0.82
	badge.Font = Enum.Font.GothamBold
	badge.TextSize = 9
	badge.TextColor3 = Color3.fromRGB(246, 218, 234)
	badge.Text = "DISCORD"
	badge.Parent = header
	local badgeCorner = Instance.new("UICorner")
	badgeCorner.CornerRadius = UDim.new(0, 5)
	badgeCorner.Parent = badge
	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.Position = UDim2.fromOffset(72, 0)
	title.Size = UDim2.new(1, -98, 1, 0)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextYAlignment = Enum.TextYAlignment.Center
	title.TextColor3 = Color3.fromRGB(242, 236, 244)
	title.TextTruncate = Enum.TextTruncate.AtEnd
	title.Text = strings.Title
	title.Parent = header
	local closeButton = Instance.new("TextButton")
	closeButton.AnchorPoint = Vector2.new(1, 0.5)
	closeButton.Position = UDim2.new(1, 0, 0.5, 0)
	closeButton.Size = UDim2.fromOffset(20, 20)
	closeButton.BackgroundTransparency = 1
	closeButton.Font = Enum.Font.GothamBold
	closeButton.TextSize = 17
	closeButton.TextColor3 = Color3.fromRGB(150, 140, 152)
	closeButton.Text = "\u{d7}"
	closeButton.AutoButtonColor = false
	closeButton.ZIndex = 101
	closeButton.Parent = header
	local hint = Instance.new("TextLabel")
	hint.BackgroundTransparency = 1
	hint.Size = UDim2.new(1, 0, 0, 16)
	hint.Font = Enum.Font.Gotham
	hint.TextSize = 12
	hint.TextXAlignment = Enum.TextXAlignment.Left
	hint.TextColor3 = Color3.fromRGB(170, 162, 175)
	hint.Text = strings.Hint
	hint.LayoutOrder = 2
	hint.Parent = toast
	local row = Instance.new("Frame")
	row.BackgroundTransparency = 1
	row.Size = UDim2.new(1, 0, 0, 32)
	row.LayoutOrder = 3
	row.Parent = toast
	local linkButton = Instance.new("TextButton")
	linkButton.Size = UDim2.new(1, -88, 1, 0)
	linkButton.BackgroundColor3 = Color3.fromRGB(43, 33, 45)
	linkButton.BackgroundTransparency = 0.15
	linkButton.AutoButtonColor = false
	linkButton.Font = Enum.Font.GothamMedium
	linkButton.TextSize = 12
	linkButton.TextColor3 = Color3.fromRGB(232, 180, 210)
	linkButton.TextXAlignment = Enum.TextXAlignment.Left
	linkButton.TextYAlignment = Enum.TextYAlignment.Center
	linkButton.Text = DISCORD_INVITE
	linkButton.ClipsDescendants = true
	linkButton.Parent = row
	local linkPadding = Instance.new("UIPadding")
	linkPadding.PaddingLeft = UDim.new(0, 10)
	linkPadding.PaddingRight = UDim.new(0, 10)
	linkPadding.Parent = linkButton
	local linkCorner = Instance.new("UICorner")
	linkCorner.CornerRadius = UDim.new(0, 8)
	linkCorner.Parent = linkButton
	local copyButton = Instance.new("TextButton")
	copyButton.AnchorPoint = Vector2.new(1, 0)
	copyButton.Position = UDim2.new(1, 0, 0, 0)
	copyButton.Size = UDim2.fromOffset(80, 32)
	copyButton.BackgroundColor3 = Color3.fromRGB(232, 164, 205)
	copyButton.AutoButtonColor = false
	copyButton.Font = Enum.Font.GothamBold
	copyButton.TextSize = 12
	copyButton.TextColor3 = Color3.fromRGB(32, 24, 32)
	copyButton.Text = strings.Copy
	copyButton.Parent = row
	local copyCorner = Instance.new("UICorner")
	copyCorner.CornerRadius = UDim.new(0, 8)
	copyCorner.Parent = copyButton
	return toast, {
		scale = popScale,
		title = title,
		hint = hint,
		link = linkButton,
		copy = copyButton,
		close = closeButton,
	}
end
local function showPromoToast()
	if promoStopped then return false end
	local gui = promoHolder()
	if not gui then return false end
	if promoFrame then
		promoParts = nil
		pcall(function() promoFrame:Destroy() end)
		promoFrame = nil
	end
	promoToken = promoToken + 1
	local token = promoToken
	promoCopied = false
	promoCopyFailed = false
	local toast, parts = buildPromoToast(gui)
	promoFrame = toast
	promoParts = parts
	local TweenService = game:GetService("TweenService")
	local function hideToast()
		if promoToken ~= token or not toast.Parent then return end
		promoToken = promoToken + 1
		if promoFrame == toast then
			promoFrame = nil
			promoParts = nil
		end
		pcall(function()
			if parts.scale then
				TweenService:Create(parts.scale, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					Scale = 0.9,
				}):Play()
			end
			TweenService:Create(toast, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0, -6),
			}):Play()
		end)
		task.delay(0.24, function()
			pcall(function()
				if toast.Parent then toast:Destroy() end
			end)
		end)
	end
	local function handleCopy()
		promoCopied = copyPromoLink()
		promoCopyFailed = not promoCopied
		refreshPromoToastTexts()
		local copiedNow = promoCopied
		task.delay(2.5, function()
			if not copiedNow or promoToken ~= token or not toast.Parent then return end
			promoCopied = false
			promoCopyFailed = false
			refreshPromoToastTexts()
		end)
		if not copiedNow then
			task.delay(3, function()
				if promoToken ~= token or not toast.Parent then return end
				promoCopyFailed = false
				refreshPromoToastTexts()
			end)
		end
	end
	parts.copy.MouseButton1Click:Connect(handleCopy)
	parts.link.MouseButton1Click:Connect(handleCopy)
	parts.close.MouseButton1Click:Connect(hideToast)
	parts.copy.MouseEnter:Connect(function()
		pcall(function() parts.copy.BackgroundColor3 = Color3.fromRGB(246, 190, 222) end)
	end)
	parts.copy.MouseLeave:Connect(function()
		pcall(function() parts.copy.BackgroundColor3 = Color3.fromRGB(232, 164, 205) end)
	end)
	parts.link.MouseEnter:Connect(function()
		pcall(function() parts.link.BackgroundTransparency = 0.02 end)
	end)
	parts.link.MouseLeave:Connect(function()
		pcall(function() parts.link.BackgroundTransparency = 0.15 end)
	end)
	pcall(function()
		if parts.scale then
			TweenService:Create(parts.scale, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Scale = 1,
			}):Play()
		end
	end)
	task.delay(PROMO_VISIBLE_TIME, hideToast)
	return true
end
task.spawn(function()
	task.wait(6)
	while not promoStopped do
		local ok, shown = pcall(showPromoToast)
		if not ok then
			warn("[Ixa Hub] Discord toast error: " .. tostring(shown))
		end
		shown = ok and shown
		if not shown then
			task.wait(2)
		else
			local waited = 0
			while waited < PROMO_INTERVAL do
				if promoStopped then return end
				task.wait(1)
				waited += 1
			end
		end
	end
end)
getgenv().__IxaHubStopPromo = function()
	promoStopped = true
	promoToken = promoToken + 1
	pcall(function()
		if promoFrame then promoFrame:Destroy() end
		if promoGui then promoGui:Destroy() end
	end)
	promoFrame, promoGui, promoParts = nil, nil, nil
end
