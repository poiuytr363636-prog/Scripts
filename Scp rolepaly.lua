-- Hey bro, if you see an open script, then why? Yeah, I just don't like Roblox anymore. You can take the script, but please, can you mention me somewhere @Poiuytr, my main Discord account @poiytr12345678. Good luck bro!
pcall(function()
	if getgenv and getgenv().UnloadBuloHub then
		getgenv().UnloadBuloHub()
	end
	if getgenv and getgenv().UnloadIxaHub then
		getgenv().UnloadIxaHub()
	end
end)
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
local KEYS = {
	toggle = "RightControl",
	minimize = "K",
}
local UnloadBuloHub, BuloClearParticleAura, MobileAimButtonRef, BuloExtra
local Window
local Lighting = game:GetService("Lighting")
local Players     = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS         = game:GetService("UserInputService")
local VIM         = game:GetService("VirtualInputManager")
local RS          = game:GetService("RunService")
local Player      = Players.LocalPlayer
local Camera      = workspace.CurrentCamera
local Mouse       = Player:GetMouse()
local BuloHubUnloaded = false
local BuloDirectConnections = {}
local BuloSilentAimController = nil
local BuloSilentAimOriginal = nil
local BuloSilentAimHook = nil
local BuloNamecallHook = nil
local BuloIndexHook = nil
local BuloOriginalNamecall = nil
local BuloOriginalIndex = nil
local BuloWallbangRaycastOriginal = nil
local BuloWallbangRaycastHook = nil
local BuloWallbangShotUntil = 0
local BuloWallbangInputHeld = false
local WallbangFeatureAvailable = false
local BuloOriginalCameraFOV = Camera and Camera.FieldOfView or 70
local function BuloTrackConnection(connection)
    if connection then table.insert(BuloDirectConnections, connection) end
    return connection
end
local BuloTreeSnapshots = setmetatable({}, {__mode = "k"})
local function BuloCachedDescendants(root, kind)
    local cache = BuloTreeSnapshots[root]
    if not cache then
        cache = {dirty = true}
        BuloTreeSnapshots[root] = cache
        local weakCache = setmetatable({cache}, {__mode = "v"})
        local function invalidate()
            local current = weakCache[1]
            if current then
                current.dirty = true
                current.items, current.textItems, current.valueItems = nil, nil, nil
            end
        end
        BuloTrackConnection(root.DescendantAdded:Connect(invalidate))
        BuloTrackConnection(root.DescendantRemoving:Connect(invalidate))
    end
    if cache.dirty then
        cache.items = root:GetDescendants()
        cache.textItems, cache.valueItems = {}, {}
        for _, item in ipairs(cache.items) do
            if item:IsA("TextLabel") or item:IsA("TextButton") then
                cache.textItems[#cache.textItems + 1] = item
            elseif item:IsA("IntValue") or item:IsA("NumberValue") or item:IsA("StringValue") then
                cache.valueItems[#cache.valueItems + 1] = item
            end
        end
        cache.dirty = false
    end
    if kind == "text" then return cache.textItems end
    if kind == "value" then return cache.valueItems end
    return cache.items
end
local function BuloWalkDescendants(root)
    local stack = {{items = root:GetChildren(), index = 0}}
    local count = 0
    return function()
        while #stack > 0 do
            if BuloHubUnloaded then return nil end
            local frame = stack[#stack]
            frame.index += 1
            local item = frame.items[frame.index]
            if not item then
                stack[#stack] = nil
            elseif item.Parent and item:IsDescendantOf(root) then
                count += 1
                if count % 300 == 0 then
                    task.wait()
                    if BuloHubUnloaded then return nil end
                end
                local children = item:GetChildren()
                if #children > 0 then stack[#stack + 1] = {items = children, index = 0} end
                return count, item
            end
        end
    end
end
local UIReady = false
local hiddenFolder = Instance.new("Folder")
hiddenFolder.Name = "HiddenNameTags"
pcall(function()
    hiddenFolder.Parent = game:GetService("RobloxReplicatedStorage")
end)
if not hiddenFolder.Parent then
    hiddenFolder.Parent = game:GetService("CoreGui")
end
local antiNameTagEnabled = false
local nameTagConnections = {}
local nameTagHeadConnection, nameTagGeneration = nil, 0
local function handleNameTag(child)
    if not antiNameTagEnabled then return end
    if child:IsA("BillboardGui") then
        child.Parent  = hiddenFolder
        child.Enabled = false
        for _, subChild in ipairs(child:GetDescendants()) do
            if subChild:IsA("TextLabel") then
                subChild.Text = ""
            end
        end
    end
end
local function setupAntiNameTag(character, generation)
    local head = character:WaitForChild("Head", 5)
    if not head or BuloHubUnloaded or not antiNameTagEnabled or generation ~= nameTagGeneration
        or Player.Character ~= character then return end
    if nameTagHeadConnection then nameTagHeadConnection:Disconnect() end
    for _, child in ipairs(head:GetChildren()) do handleNameTag(child) end
    nameTagHeadConnection = head.ChildAdded:Connect(handleNameTag)
end
local function enableAntiNameTag()
    if antiNameTagEnabled then return end
    antiNameTagEnabled = true
    nameTagGeneration += 1
    local current = nameTagGeneration
    if Player.Character then task.spawn(setupAntiNameTag, Player.Character, current) end
    local conn = Player.CharacterAdded:Connect(function(char)
        if antiNameTagEnabled then setupAntiNameTag(char, current) end
    end)
    table.insert(nameTagConnections, conn)
end
local function disableAntiNameTag()
    antiNameTagEnabled = false
    nameTagGeneration += 1
    if nameTagHeadConnection then nameTagHeadConnection:Disconnect(); nameTagHeadConnection = nil end
    for _, conn in ipairs(nameTagConnections) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(nameTagConnections)
    for _, child in ipairs(hiddenFolder:GetChildren()) do
        pcall(function()
            if Player.Character and Player.Character:FindFirstChild("Head") then
                child.Parent  = Player.Character.Head
                child.Enabled = true
            end
        end)
    end
end
local fallReducerEnabled = false
local fallChar = nil
local fallRoot = nil
local fallParams = RaycastParams.new()
fallParams.FilterType = Enum.RaycastFilterType.Exclude
local FALL_TRIGGER_SPEED = 12
local FALL_REACTION_TIME = 0.12
local FALL_PROBE_MIN = 4
local FALL_PROBE_MAX = 70
local FALL_LANDING_SPEED = 2
local FALL_BRAKE_HOLD = 0.35
local FALL_DESCENT_FACTOR = 0.5
local fallBrakeUntil = 0
local function updateFallCharRefs(char)
    fallChar = char
    fallRoot = char and char:FindFirstChild("HumanoidRootPart") or nil
    fallBrakeUntil = 0
    pcall(function()
        fallParams.FilterDescendantsInstances = char and {char} or {}
    end)
    if char and not fallRoot then
        task.spawn(function()
            local root = char:WaitForChild("HumanoidRootPart", 10)
            if not BuloHubUnloaded and fallChar == char then fallRoot = root end
        end)
    end
end
updateFallCharRefs(Player.Character)
BuloTrackConnection(Player.CharacterAdded:Connect(function(char)
    updateFallCharRefs(char)
end))
BuloTrackConnection(RS.Heartbeat:Connect(function(deltaTime)
    if not fallReducerEnabled then return end
    if not fallRoot or not fallRoot.Parent then return end
    local velocity = fallRoot.AssemblyLinearVelocity
    local fallSpeed = -velocity.Y
    local now = tick()
    if fallSpeed < FALL_TRIGGER_SPEED and now > fallBrakeUntil then return end
    local reactionTime = math.max(FALL_REACTION_TIME, deltaTime * 2)
    local probeLength = math.clamp(fallSpeed * reactionTime, FALL_PROBE_MIN, FALL_PROBE_MAX)
    local groundHit = workspace:Raycast(fallRoot.Position, Vector3.new(0, -probeLength, 0), fallParams)
    if not groundHit then return end
    local descentCap = FALL_LANDING_SPEED + groundHit.Distance * FALL_DESCENT_FACTOR
    local targetY = math.max(velocity.Y, -descentCap)
    if targetY ~= velocity.Y then
        fallRoot.AssemblyLinearVelocity = Vector3.new(velocity.X, targetY, velocity.Z)
    end
    fallBrakeUntil = now + FALL_BRAKE_HOLD
end))
pcall(function()
    local gmt = getrawmetatable(game)
    setreadonly(gmt, false)
    local oldIndex    = gmt.__index
    local oldNamecall = gmt.__namecall
    BuloOriginalIndex = oldIndex
    BuloOriginalNamecall = oldNamecall
    local bannedClasses = {
        ["BodyVelocity"]        = true,
        ["BodyGyro"]            = true,
        ["BodyThrust"]          = true,
        ["BodyAngularVelocity"] = true,
        ["BoxHandleAdornment"]  = true,
        ["PlayerHighlight"]     = true,
        ["Highlight"]           = true,
    }
    local bannedNames = {
        ["based puller"] = true,
        ["TP Click"]     = true,
    }
    local bannedRemotes = {
        ["LoadstringRemote"] = true,
        ["ReportRemote"]     = true,
    }
    local buloNamecallHook = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method ~= "FireServer" and method ~= "InvokeServer" and method ~= "IsA"
            and method ~= "FindFirstChildWhichIsA" and method ~= "FindFirstChildOfClass"
            and method ~= "FindFirstChild" and method ~= "GetDescendants" and method ~= "GetChildren" then
            return oldNamecall(self, ...)
        end
        if not checkcaller() then
            local firstArg = ...
            if method == "FireServer" or method == "InvokeServer" then
                local isBanned = false
                pcall(function()
                    if typeof(self) == "Instance" and self.Name then
                        if bannedRemotes[self.Name]
                        or string.find(string.lower(self.Name), "kick")
                        or string.find(string.lower(self.Name), "report") then
                            isBanned = true
                        end
                    end
                end)
                if isBanned then return end
            end
            if method == "IsA" then
                local shouldBlock = false
                pcall(function()
                    if typeof(firstArg) == "string" and typeof(self) == "Instance" then
                        if bannedClasses[firstArg] and bannedClasses[self.ClassName] then
                            shouldBlock = true
                        end
                    end
                end)
                if shouldBlock then return false end
            end
            if method == "FindFirstChildWhichIsA" or method == "FindFirstChildOfClass" then
                local shouldBlock = false
                pcall(function()
                    if typeof(firstArg) == "string" and bannedClasses[firstArg] then
                        shouldBlock = true
                    end
                end)
                if shouldBlock then return nil end
            end
            if method == "FindFirstChild" then
                local shouldBlock = false
                pcall(function()
                    if typeof(firstArg) == "string" and bannedNames[firstArg] then
                        shouldBlock = true
                    end
                end)
                if shouldBlock then return nil end
            end
            if method == "GetDescendants" or method == "GetChildren" then
                local isInstance = false
                pcall(function()
                    if typeof(self) == "Instance" then
                        isInstance = true
                    end
                end)
                if isInstance then
                    local realResults = oldNamecall(self, ...)
                    if typeof(realResults) == "table" then
                        local count, originalCount = 0, #realResults
                        pcall(function()
                            for _, instance in ipairs(realResults) do
                                if typeof(instance) == "Instance"
                                and not bannedClasses[instance.ClassName]
                                and not bannedNames[instance.Name] then
                                    count += 1
                                    realResults[count] = instance
                                end
                            end
                        end)
                        for index = count + 1, originalCount do realResults[index] = nil end
                        return realResults
                    end
                end
            end
        end
        return oldNamecall(self, ...)
    end)
    gmt.__namecall = buloNamecallHook
    BuloNamecallHook = buloNamecallHook
    local buloIndexHook = newcclosure(function(self, key)
        if key ~= "WalkSpeed" and key ~= "JumpPower" and key ~= "Size" then
            return oldIndex(self, key)
        end
        if not checkcaller() then
            local isInstance = false
            pcall(function()
                if typeof(self) == "Instance" then
                    isInstance = true
                end
            end)
            if isInstance then
                if key == "WalkSpeed" and self:IsA("Humanoid") then return 16 end
                if key == "JumpPower" and self:IsA("Humanoid") then return 50 end
                if key == "Size" and (self.Name == "Head" or self.Name == "HumanoidRootPart") then
                    if self:IsA("Part") or self:IsA("MeshPart") then
                        return Vector3.new(2, 1, 1)
                    end
                end
            end
        end
        return oldIndex(self, key)
    end)
    gmt.__index = buloIndexHook
    BuloIndexHook = buloIndexHook
    setreadonly(gmt, true)
end)
local InterfaceLanguage = "English"
local InterfaceTranslations = {
    ["Language"] = "Язык", ["English"] = "Английский", ["Russian"] = "Русский", ["Unload Script"] = "Выгрузить скрипт",
    ["Aim"] = "Аим", ["Combat"] = "Бой", ["Visuals"] = "Визуалы", ["Misc"] = "Разное", ["Keybinds"] = "Бинды",
    ["Silent Aim (Advanced)"] = "Silent Aim (Расширенный)", ["Silent Aim"] = "Silent Aim",
    ["Target Part"] = "Часть тела", ["Auto"] = "Авто", ["Nearest Hitbox"] = "Ближайший хитбокс",
    ["Head"] = "Голова", ["Torso"] = "Торс", ["HumanoidRootPart"] = "Корень персонажа",
    ["Target SCPs"] = "Целиться в SCP", ["Wall Check"] = "Проверка стен", ["Shoot Through Walls"] = "Стрельба через стены",
    ["Silent Aim FOV"] = "FOV Silent Aim", ["Hit Chance"] = "Шанс попадания",
    ["Auto Head Chance"] = "Шанс головы (авто)", ["Auto Torso Chance"] = "Шанс торса (авто)",
    ["Auto Root Chance"] = "Шанс корня (авто)", ["Auto Reload"] = "Авто-перезарядка",
    ["Fling"] = "Флинг", ["Enable Fling"] = "Включить флинг", ["Fling V2.0"] = "Флинг V2.0",
    ["Enable Fling V2.0"] = "Включить флинг V2.0", ["Walk Speed"] = "Скорость ходьбы", ["Fling Power"] = "Сила флинга",
    ["Speed"] = "Скорость", ["Speedhack"] = "Спидхак", ["Speed Multiplier"] = "Множитель скорости",
    ["Anti-Slowdown"] = "Анти-замедление", ["NoClip"] = "Ноклип", ["Jump"] = "Прыжок",
    ["Infinity Jump"] = "Бесконечный прыжок", ["Jump Force"] = "Сила прыжка", ["Fly"] = "Полёт",
    ["Enable Fly"] = "Включить полёт", ["Fly Speed"] = "Скорость полёта",
    ["Player ESP"] = "ESP игроков", ["Enable ESP"] = "Включить ESP", ["Show Boxes"] = "Показывать боксы",
    ["Show Names"] = "Показывать имена", ["Show Health Bar"] = "Полоса здоровья", ["Team Colors"] = "Цвета команд",
    ["SCP ESP"] = "SCP ESP", ["SCP ESP (Blue)"] = "SCP ESP", ["Show SCP Names"] = "Показывать имена SCP",
    ["SCP ESP Color"] = "Цвет SCP ESP", ["SCP Name Color"] = "Цвет имени SCP",
    ["Rainbow Speed"] = "Скорость радуги",
    ["Weapon Skins"] = "Скины оружия", ["Enable Skin Changer"] = "Включить смену скина",
    ["Rainbow Chroma"] = "Радужный эффект", ["Weapon Rainbow Speed"] = "Скорость радуги оружия",
    ["Custom Weapon Tint"] = "Свой оттенок оружия", ["Weapon Tint Color"] = "Цвет оружия",
    ["Gun Skin"] = "Скин оружия", ["Weapon Material"] = "Материал оружия",
    ["SCP-096 Bag Skin"] = "Скин мешка SCP-096", ["SCP-173 Cage Skin"] = "Скин клетки SCP-173",
    ["World"] = "Мир", ["Full Bright"] = "Полная яркость", ["Camera FOV"] = "FOV камеры",
    ["Particle Aura"] = "Аура частиц", ["Particle"] = "Частицы", ["Aura Color"] = "Цвет ауры",
    ["Auto Buy"] = "Авто-покупка", ["Enable Auto Buy"] = "Включить авто-покупку", ["Buy Interval"] = "Интервал покупки", ["Buy Items"] = "Предметы покупки",
    ["Auto Escape"] = "Авто-побег", ["Auto Escape (Only Class D)"] = "Авто-побег (только Class D)",
    ["Auto Hatches"] = "Авто-люки", ["Auto Open Hatches"] = "Авто-открытие люков", ["Hatch Radius"] = "Радиус люков", ["Hatch Delay"] = "Задержка люков",
    ["Anti Name Tag"] = "Скрытие имени", ["Hide Own Name Tag"] = "Скрыть своё имя",
    ["Fall Damage Reducer"] = "Уменьшение урона от падения", ["Keybind List"] = "Список биндов",
    ["Show Keybind List"] = "Показать список биндов", ["Menu"] = "Меню", ["UI Bind"] = "Бинд меню",
    ["Configs"] = "Конфиги", ["Config name"] = "Имя конфига", ["Create"] = "Создать", ["Delete"] = "Удалить",
    ["Load"] = "Загрузить", ["Save"] = "Сохранить", ["Refresh"] = "Обновить",
    ["Movement"] = "Передвижение", ["Teleport (Locations)"] = "Телепорт (локации)", ["Class D Cell"] = "Камера класса D",
    ["Sector 1"] = "Сектор 1", ["Sector 2"] = "Сектор 2", ["Sector 3"] = "Сектор 3",
    ["Biohazard Sector"] = "Биологический сектор", ["Bunker"] = "Бункер", ["Helipad"] = "Вертолётная площадка",
    ["MTF Spawn"] = "Спавн MTF", ["CI Spawn"] = "Спавн CI", ["Outside MTF Base"] = "Снаружи базы MTF",
    ["Transformers"] = "Трансформаторы", ["Administration"] = "Администрация",
    ["Medical Center"] = "Медицинский центр", ["Control Room"] = "Комната управления",
    ["Teleport (SCP Chambers)"] = "Телепорт (камеры SCP)",
    ["Search in this tab.."] = "Поиск в этой вкладке..", ["Settings"] = "Настройки", ["Theme"] = "Тема",
    ["Other"] = "Другое", ["Unload"] = "Выгрузить", ["Style"] = "Стиль", ["None"] = "Нет",
    ["Default"] = "По умолчанию", ["Custom"] = "Свой", ["Void Flames"] = "Пламя пустоты", ["Blood Sparks"] = "Кровавые искры",
    ["Golden Stars"] = "Золотые звёзды", ["Electric Sparks"] = "Электрические искры",
    ["Ghost Smoke"] = "Призрачный дым", ["Knife"] = "Нож", ["Pistol"] = "Пистолет",
    ["Kv-45"] = "Kv-45", ["Spas - 12"] = "Spas - 12",
    ["Obsidian"] = "Обсидиан", ["Gold"] = "Золото", ["Diamond"] = "Алмаз", ["Emerald"] = "Изумруд",
    ["Ruby"] = "Рубин", ["Platinum"] = "Платина", ["Dimension"] = "Измерение", ["Gem"] = "Самоцвет",
    ["Waves"] = "Волны", ["Hazard"] = "Опасность", ["Cheese"] = "Сыр", ["SCP"] = "SCP",
    ["Anniversary 2025"] = "Юбилей 2025", ["Halloween 2024"] = "Хэллоуин 2024",
    ["Winter 2024"] = "Зима 2024", ["Halloween 2023"] = "Хэллоуин 2023", ["Winter 2023"] = "Зима 2023",
    ["Gold Wrap"] = "Золотая обмотка", ["Reptile"] = "Рептилия", ["Protector"] = "Защитник",
    ["Liberator"] = "Освободитель", ["Plasma"] = "Плазма", ["Fire"] = "Огонь", ["Energy"] = "Энергия",
    ["Warp"] = "Искажение", ["Moon"] = "Луна", ["Metal"] = "Металл", ["Rust"] = "Ржавчина",
    ["Crystal"] = "Кристалл", ["Ice"] = "Лёд", ["Hexagon"] = "Шестиугольник", ["Snow"] = "Снег",
    ["Tiger"] = "Тигр", ["Zebra"] = "Зебра", ["Glass"] = "Стекло", ["Paint"] = "Краска",
    ["Ghost"] = "Призрак", ["Sky"] = "Небо", ["Night"] = "Ночь", ["Flecktarn"] = "Флектарн",
    ["Woodland"] = "Лесной", ["Splinter"] = "Осколок", ["Digital"] = "Цифровой",
    ["Navy"] = "Морской", ["Urban"] = "Городской", ["ForceField (Glow)"] = "Силовое поле (свечение)",
    ["Foil (Chrome)"] = "Фольга (хром)", ["SmoothPlastic"] = "Гладкий пластик", ["Biohazard"] = "Биологическая опасность",
    ["Chaotic"] = "Хаотичный", ["Practice"] = "Тренировочный", ["Arctic Camo"] = "Арктический камуфляж",
    ["Ashen"] = "Пепельный", ["Oceanic"] = "Океанический", ["Hacked"] = "Взломанный",
    ["Steampunk"] = "Стимпанк", ["Pumpkin"] = "Тыква", ["Golden Cage"] = "Золотая клетка",
    ["Task Force"] = "Оперативная группа", ["Under Construction"] = "На реконструкции",
    ["Frozen"] = "Замёрзшая", ["Space Age"] = "Космическая эра", ["Binary Matrix"] = "Двоичная матрица",
    ["Reinforced"] = "Усиленная", ["starlight"] = "звёздный свет", ["heavenly"] = "небесная",
    ["ribbon"] = "лента", ["sakura"] = "сакура", ["angel"] = "ангел", ["wind"] = "ветер",
    ["flow"] = "поток", ["star"] = "звезда", ["Background"] = "Фон", ["Inline"] = "Внутренний фон",
    ["Accent"] = "Акцент", ["Outline"] = "Контур", ["Text"] = "Текст", ["Dark Text"] = "Тёмный текст",
    ["Element"] = "Элемент", ["Toggle"] = "Переключатель", ["Hovered Element"] = "Элемент при наведении",
}
local InterfaceReverseTranslations = {}
InterfaceTranslations["Auto Interact"] = "Авто-взаимодействие"
InterfaceTranslations["Auto Hack"] = "Авто-взлом"
InterfaceTranslations["Auto Prompt"] = "Авто-промпт"
InterfaceTranslations["Auto Prompt activates nearby interactions"] = "Авто-промпт активирует взаимодействия рядом"
InterfaceTranslations["SCP Object Cosmetics"] = "Скины объектов SCP"
InterfaceTranslations["SCP-173 Cage (Extra)"] = "Клетка SCP-173 (доп.)"
InterfaceTranslations["SCP Crate"] = "Ящик SCP"
InterfaceTranslations["SCP-096 Bag (Extra)"] = "Мешок SCP-096 (доп.)"
InterfaceTranslations["Back Accessories"] = "Предметы на спине"
InterfaceTranslations["Back Items"] = "Предметы на спине"
InterfaceTranslations["Hide Hair"] = "Скрыть волосы"
InterfaceTranslations["Hide Clothing"] = "Скрыть одежду"
InterfaceTranslations["Rotate Last Back Item"] = "Повернуть последний предмет"
InterfaceTranslations["Clear Back Items"] = "Снять предметы"
InterfaceTranslations["Custom Asset ID"] = "ID своего предмета"
InterfaceTranslations["Wear Custom Asset"] = "Надеть предмет по ID"
InterfaceTranslations["Play Custom Animation"] = "Включить анимацию по ID"
InterfaceTranslations["Kill & C4 Effects"] = "Эффекты смерти и C4"
InterfaceTranslations["Kill Effect"] = "Эффект смерти"
InterfaceTranslations["Enable Kill Effects"] = "Включить эффекты смерти"
InterfaceTranslations["Kill Effects on Self"] = "Эффект смерти на себе"
InterfaceTranslations["Kill Effects on Others"] = "Эффект смерти на других"
InterfaceTranslations["C4 Effect"] = "Эффект C4"
InterfaceTranslations["C4 Effect on Own Death"] = "Эффект C4 при своей смерти"
InterfaceTranslations["Test Kill Effect"] = "Проверить эффект смерти"
InterfaceTranslations["Test C4 Effect"] = "Проверить эффект C4"
InterfaceTranslations["Configurations"] = "Конфигурации"
InterfaceTranslations["Bind any function"] = "Бинд любой функции"
InterfaceTranslations["Select an action, press Set Bind, then press a key"] = "Выберите действие, нажмите Назначить бинд и клавишу"
InterfaceTranslations["Function"] = "Функция"
InterfaceTranslations["Set Bind"] = "Назначить бинд"
InterfaceTranslations["Clear Bind"] = "Удалить бинд"
InterfaceTranslations["Escape cancels binding. Mouse 2 and Mouse 3 are supported."] = "Escape отменяет назначение. Поддерживаются Mouse 2 и Mouse 3."
InterfaceTranslations["Saved Config"] = "Сохранённый конфиг"
InterfaceTranslations["Save Config"] = "Сохранить конфиг"
InterfaceTranslations["Load Config"] = "Загрузить конфиг"
InterfaceTranslations["Delete Config"] = "Удалить конфиг"
InterfaceTranslations["Refresh Configs"] = "Обновить список"
InterfaceTranslations["Set Autoload"] = "Включить автозагрузку"
InterfaceTranslations["Clear Autoload"] = "Отключить автозагрузку"
InterfaceTranslations["Reset Settings"] = "Сбросить настройки"
InterfaceTranslations["Configs require executor file support and save settings, colors and binds."] = "Для конфигов нужна поддержка файлов. Сохраняются настройки, цвета и бинды."
for english, russian in pairs(InterfaceTranslations) do
    InterfaceReverseTranslations[russian] = english
end
local InterfaceLocalizationGeneration = 0
local InterfaceTextCaches = setmetatable({}, {__mode = "k"})
local function localizeInterfaceText(text, language)
    if language == "Russian" then
        return InterfaceTranslations[text] or text
    end
    return InterfaceReverseTranslations[text] or text
end
local function getInterfaceTexts(root)
    local cache = InterfaceTextCaches[root]
    if not cache then
        cache = {items = {}, lookup = {}, textConnections = {}}
        InterfaceTextCaches[root] = cache
        local function add(item)
            if cache.lookup[item] then return end
            local property
            if item:IsA("TextLabel") or item:IsA("TextButton") then
                property = "Text"
            elseif item:IsA("TextBox") then
                property = "PlaceholderText"
            end
            if property then
                local index = #cache.items + 1
                cache.items[index] = {item, property}
                cache.lookup[item] = index
                local function translate()
                    if BuloHubUnloaded or InterfaceLanguage ~= "Russian" then return end
                    local text = item[property]
                    local translated = localizeInterfaceText(text, "Russian")
                    if translated ~= text then item[property] = translated end
                end
                cache.textConnections[item] = BuloTrackConnection(item:GetPropertyChangedSignal(property):Connect(translate))
                translate()
            end
        end
        local function remove(item)
            local index = cache.lookup[item]
            if not index then return end
            local lastIndex = #cache.items
            local last = cache.items[lastIndex]
            cache.items[lastIndex] = nil
            if index < lastIndex then
                cache.items[index] = last
                cache.lookup[last[1]] = index
            end
            cache.lookup[item] = nil
            local connection = cache.textConnections[item]
            if connection then connection:Disconnect(); cache.textConnections[item] = nil end
        end
        BuloTrackConnection(root.DescendantAdded:Connect(add))
        BuloTrackConnection(root.DescendantRemoving:Connect(remove))
        add(root)
        for _, item in ipairs(root:GetDescendants()) do add(item) end
    end
    return cache.items
end
local refreshPromoToastTexts
local function applyInterfaceLanguage(language, visibleOnly)
    InterfaceLanguage = language
    local holders = {}
    if Window and Window.Gui then table.insert(holders, Window.Gui) end
    for _, root in ipairs(holders) do
        for _, entry in ipairs(getInterfaceTexts(root)) do
            local item, property = entry[1], entry[2]
            local current = item[property]
            local translated = localizeInterfaceText(current, language)
            if translated ~= current then item[property] = translated end
        end
    end
    if MobileAimButtonRef then
        local text = language == "Russian" and "АИМ" or "AIM"
        if MobileAimButtonRef.Text ~= text then MobileAimButtonRef.Text = text end
    end
    if refreshPromoToastTexts then refreshPromoToastTexts() end
end
local function setInterfaceLanguage(language)
    InterfaceLocalizationGeneration += 1
    applyInterfaceLanguage(language)
end
local DrawingAvailable = false
pcall(function()
    local t = Drawing.new("Square"); t:Remove(); DrawingAvailable = true
end)
local FakeDrawingMeta = {
    __index    = function(t, k) return rawget(t, k) end,
    __newindex = function(t, k, v) rawset(t, k, v) end,
}
local function MakeDrawingStub()
    local obj = setmetatable({
        Visible=false, Color=Color3.new(1,1,1), Transparency=1,
        Thickness=1, Text="", Size=14, Position=Vector2.new(0,0),
        Radius=100, NumSides=64, Filled=false, Center=false, Outline=false,
    }, FakeDrawingMeta)
    obj.Remove = function() end
    return obj
end
local function SafeDrawing(drawType)
    if DrawingAvailable then
        local ok, obj = pcall(function() return Drawing.new(drawType) end)
        if ok then return obj end
    end
    return MakeDrawingStub()
end
local Cfg = {
    FOVEnabled = true, CheckWalls = true,
    IgnoreTeam = true,
    WorldFOV = 70,
    InfJumpEnabled = false, InfJumpForce = 50, SpeedhackEnabled = false,
    SpeedMultiplier = 15, AntiSlowdown = false, NoclipEnabled = false,
    FlySpeed = 35,
}
local LocalPlayer = Players.LocalPlayer
local ZonePoints = {
    Vector2.new(230.597,-205.779), Vector2.new(243.226,-213.159),
    Vector2.new(248.416,-223.719), Vector2.new(248.218,-298.761),
    Vector2.new(242.990,-310.065), Vector2.new(230.577,-316.980),
    Vector2.new(189.619,-316.127), Vector2.new(192.184,-426.891),
    Vector2.new(640.635,-391.501), Vector2.new(633.426,-104.750),
    Vector2.new(331.498,-18.667),  Vector2.new(195.072,-30.311),
    Vector2.new(196.518,-97.241),  Vector2.new(194.822,-113.296),
    Vector2.new(187.437,-176.586), Vector2.new(185.689,-206.413),
    Vector2.new(230.177,-205.787),
}
local function isInsideZone(position)
    local p = Vector2.new(position.X, position.Z)
    local isInside = false
    local j = #ZonePoints
    for i = 1, #ZonePoints do
        local pi = ZonePoints[i]; local pj = ZonePoints[j]
        if ((pi.Y > p.Y) ~= (pj.Y > p.Y)) and
           (p.X < (pj.X-pi.X)*(p.Y-pi.Y)/(pj.Y-pi.Y)+pi.X) then
            isInside = not isInside
        end
        j = i
    end
    return isInside
end
local function hasGunCheck(character)
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Laser") then return true end
    end
    return false
end
local function hasSCP096TagCheck(player)
    local character = player.Character
    if character and character:FindFirstChild("Head") then
        if character.Head:FindFirstChild("SCP096Tag") then return true end
    end
    return false
end
local function isEnemyAdvanced(player)
    if not player or player == LocalPlayer or not player.Character then return false end
    local targetChar = player.Character
    if hasSCP096TagCheck(player) then return true end
    local pInfection = player:GetAttribute("Infection") or 0
    local cInfection = targetChar:GetAttribute("Infection") or 0
    if pInfection > 100 or cInfection > 100 then return true end
    local isMeInfected = LocalPlayer:GetAttribute("Infected001") or
                         (LocalPlayer.Character and LocalPlayer.Character:GetAttribute("Infected001"))
    local isTargetInfected = player:GetAttribute("Infected001") or targetChar:GetAttribute("Infected001")
    if isMeInfected then return not isTargetInfected
    elseif isTargetInfected then return true end
    local localTeam  = LocalPlayer.Team
    local targetTeam = player.Team
    if not localTeam or not targetTeam then return true end
    if player:FindFirstChild("Authorized") or targetChar:FindFirstChild("Authorized") then return false end
    local isMeCDorChaos     = (localTeam.Name=="Class - D" or localTeam.Name=="Chaos Insurgency")
    local isTargetCDorChaos = (targetTeam.Name=="Class - D" or targetTeam.Name=="Chaos Insurgency")
    if isMeCDorChaos then
        return not isTargetCDorChaos
    else
        if targetTeam.Name == "Chaos Insurgency" then return true end
        if targetTeam.Name == "Class - D" then
            local hrp = targetChar:FindFirstChild("HumanoidRootPart")
            if not hrp then return false end
            return (not isInsideZone(hrp.Position)) or hasGunCheck(targetChar)
        end
    end
    return false
end
local silentAimEnabled = false
local silentAimFOV = 100
local silentAimHitChance = 100
local silentAimTargetPart = "Auto"
local silentAimWallCheck = true
local silentAimWallbang = false
local silentAimAllowWallbang = true
local silentAimTargetSCPs = false
local silentAimHeadChance = 100
local silentAimTorsoChance = 100
local silentAimRootChance = 100
local silentAimMaxDist = 300
local silentAimTarget = nil
local autoReloadEnabled = false
local autoReloadLastPress = 0
local Cam              = workspace.CurrentCamera
local function applyWorldFOV()
    local currentCamera = workspace.CurrentCamera
    if not currentCamera then return end
    Camera = currentCamera
    Cam = currentCamera
    pcall(function() currentCamera.FieldOfView = Cfg.WorldFOV end)
end
BuloTrackConnection(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(applyWorldFOV))
RS:BindToRenderStep("BuloWorldFOVLock", Enum.RenderPriority.Camera.Value + 1, function()
    local currentCamera = workspace.CurrentCamera
    if not currentCamera then return end
    if Camera ~= currentCamera then
        Camera = currentCamera
        Cam = currentCamera
    end
    if math.abs(currentCamera.FieldOfView - Cfg.WorldFOV) > 0.01 then
        pcall(function() currentCamera.FieldOfView = Cfg.WorldFOV end)
    end
end)
local silentFOVring = SafeDrawing("Circle")
silentFOVring.Visible   = false
silentFOVring.Thickness = 1
silentFOVring.Color     = Color3.fromRGB(255, 255, 255)
silentFOVring.Filled    = false
silentFOVring.NumSides  = 64
silentFOVring.Radius    = silentAimFOV
local SA_HITBOXES = {
    "Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso",
    "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand",
    "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot",
}
local saRayParams = RaycastParams.new()
saRayParams.FilterType = Enum.RaycastFilterType.Blacklist
saRayParams.IgnoreWater = true
local saRaycastCharacter = nil
local function getCharacterPartSA(character, partName)
    if partName == "Torso" then
        return character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    end
    return character:FindFirstChild(partName)
end
local function getVisibleHitPointSA(part, targetCharacter)
    local localCharacter = LocalPlayer.Character
    if not localCharacter or not part or not targetCharacter then return nil end
    if saRaycastCharacter ~= localCharacter then
        saRaycastCharacter = localCharacter
        saRayParams.FilterDescendantsInstances = {localCharacter}
    end
    local origin = Cam.CFrame.Position
    local half = part.Size * 0.5
    local localCamera = part.CFrame:PointToObjectSpace(origin)
    local nearestSurface = Vector3.new(
        math.clamp(localCamera.X, -half.X + 0.02, half.X - 0.02),
        math.clamp(localCamera.Y, -half.Y + 0.02, half.Y - 0.02),
        math.clamp(localCamera.Z, -half.Z + 0.02, half.Z - 0.02)
    )
    local sampleCount = part.Size.Y > 1 and 3 or 2
    for sampleIndex = 1, sampleCount do
        local point
        if sampleIndex == 1 then
            point = part.CFrame:PointToWorldSpace(nearestSurface)
        elseif sampleIndex == 2 then
            point = part.Position
        else
            point = part.CFrame:PointToWorldSpace(Vector3.new(
                nearestSurface.X, nearestSurface.Y * 0.5, nearestSurface.Z
            ))
        end
        local direction = point - origin
        if direction.Magnitude <= 0.01 then return point end
        local result = workspace:Raycast(origin, direction, saRayParams)
        if not result then return point end
        if result.Instance and result.Instance:IsDescendantOf(targetCharacter) then
            return result.Position
        end
    end
    return nil
end
local function getTargetPartScoreSA(part, targetCharacter, center, camPos, fovSq, maxDistSq)
    if not part or not part:IsA("BasePart") then return nil, nil end
    local diff = camPos - part.Position
    if diff:Dot(diff) > maxDistSq then return nil, nil end
    local useWallCheck = silentAimWallCheck and not silentAimWallbang
    local hitPoint = useWallCheck and getVisibleHitPointSA(part, targetCharacter) or part.Position
    if not hitPoint then return nil, nil end
    local screenPoint, onScreen = Cam:WorldToViewportPoint(hitPoint)
    if not onScreen or screenPoint.Z <= 0 then return nil, nil end
    local dx = screenPoint.X - center.X
    local dy = screenPoint.Y - center.Y
    local screenDistSq = dx * dx + dy * dy
    if screenDistSq >= fovSq then return nil, nil end
    return screenDistSq, hitPoint
end
local function getNearestHitboxSA(character, center, camPos, fovSq, maxDistSq)
    local bestPart, bestScore, bestPoint = nil, math.huge, nil
    local seen = {}
    for _, name in ipairs(SA_HITBOXES) do
        local part = getCharacterPartSA(character, name)
        if part and not seen[part] then
            seen[part] = true
            local preview, onScreen = Cam:WorldToViewportPoint(part.Position)
            if onScreen and preview.Z > 0 then
                local dx = preview.X - center.X
                local dy = preview.Y - center.Y
                local previewScore = dx * dx + dy * dy
                if previewScore < bestScore and previewScore < fovSq then
                    local score, point = getTargetPartScoreSA(part, character, center, camPos, fovSq, maxDistSq)
                    if score and score < bestScore then
                        bestPart, bestScore, bestPoint = part, score, point
                    end
                end
            end
        end
    end
    return bestPart, bestScore, bestPoint
end
local function getAutoTargetPartSA(character, center, camPos, fovSq, maxDistSq)
    for candidateIndex = 1, 3 do
        local name, chance
        if candidateIndex == 1 then
            name, chance = "Head", silentAimHeadChance
        elseif candidateIndex == 2 then
            name, chance = "Torso", silentAimTorsoChance
        else
            name, chance = "HumanoidRootPart", silentAimRootChance
        end
        if chance > 0 then
            local part = getCharacterPartSA(character, name)
            local score, point = getTargetPartScoreSA(part, character, center, camPos, fovSq, maxDistSq)
            if score and math.random(1, 100) <= chance then
                return part, score, point
            end
        end
    end
    return nil, nil, nil
end
local function chooseTargetPartSA(character, center, camPos, fovSq, maxDistSq)
    if silentAimTargetPart == "Auto" then
        return getAutoTargetPartSA(character, center, camPos, fovSq, maxDistSq)
    elseif silentAimTargetPart == "Nearest Hitbox" then
        return getNearestHitboxSA(character, center, camPos, fovSq, maxDistSq)
    end
    local part = getCharacterPartSA(character, silentAimTargetPart)
    local score, point = getTargetPartScoreSA(part, character, center, camPos, fovSq, maxDistSq)
    return part, score, point
end
local saLastUpdate = 0
local SA_RATE = 0.04
local function getClosestSA()
    if not silentAimEnabled then return nil end
    local nearestTarget, nearestScore = nil, math.huge
    local center = Vector2.new(Cam.ViewportSize.X * 0.5, Cam.ViewportSize.Y * 0.5)
    local camPos = Cam.CFrame.Position
    local fovSq = silentAimFOV * silentAimFOV
    local maxDistSq = silentAimMaxDist * silentAimMaxDist
    local function evaluate(character)
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then return end
        local part, score, point = chooseTargetPartSA(character, center, camPos, fovSq, maxDistSq)
        if part and score and point and score < nearestScore then
            nearestScore = score
            nearestTarget = {Part = part, Position = point, Character = character}
        end
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if isEnemyAdvanced(player) then evaluate(player.Character) end
    end
    if silentAimTargetSCPs then
        local scpFolder = workspace:FindFirstChild("SCPs")
        if scpFolder then
            for _, model in ipairs(scpFolder:GetChildren()) do
                if model:IsA("Model") then evaluate(model) end
            end
        end
    end
    return nearestTarget
end
RS:BindToRenderStep("SilentAimUpdate", Enum.RenderPriority.Camera.Value + 1, function()
    if not silentAimEnabled then return end
    if DrawingAvailable then
        pcall(function()
            silentFOVring.Visible  = true
            silentFOVring.Position = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)
            silentFOVring.Radius   = silentAimFOV
        end)
    end
    local now = tick()
    if now - saLastUpdate >= SA_RATE then
        saLastUpdate    = now
        silentAimTarget = getClosestSA()
    end
end)
pcall(function()
    local newcclosure2 = newcclosure or function(f) return f end
    local constantsWanted = {Bullet = true, EasterEggThing = true, ["SCP-066"] = true}
    local function hasControllerConstants(functionObject)
        if not getconstants then return false end
        local ok, constants = pcall(getconstants, functionObject)
        if not ok or type(constants) ~= "table" then return false end
        local found = 0
        for _, constant in ipairs(constants) do
            if constantsWanted[constant] then found += 1 end
        end
        return found >= 2
    end
    local function findSilentAimControllerFunctionSA()
        local controllerScript = LocalPlayer.PlayerScripts:FindFirstChild("Controller", true)
        local source = controllerScript and "=" .. controllerScript:GetFullName()
        if filtergc then
            local ok, result = pcall(filtergc, "function", {
                Constants = {"Bullet", "EasterEggThing", "SCP-066"},
                IgnoreExecutor = true
            })
            if ok then
                if type(result) == "function" then result = {result} end
                for _, functionObject in next, result or {} do
                    local info = debug.getinfo(functionObject)
                    if not source or (info and rawget(info, "source") == source) then
                        return functionObject
                    end
                end
            end
        end
        if getgc and source then
            for _, object in next, getgc(false) do
                if type(object) == "function" then
                    local ok, info = pcall(debug.getinfo, object)
                    if ok and info and rawget(info, "source") == source and hasControllerConstants(object) then
                        return object
                    end
                end
            end
        end
        return nil
    end
    local function installSilentAimHookSA()
        if BuloHubUnloaded or BuloSilentAimController then return BuloSilentAimController ~= nil end
        if not hookfunction then return false end
        local controllerFunction = findSilentAimControllerFunctionSA()
        if not controllerFunction then return false end
        local oldController
        local buloControllerHook = newcclosure2(function(_, hitResult, ...)
            if silentAimEnabled and silentAimTarget and silentAimTarget.Part
                and silentAimTarget.Part.Parent and math.random(1, 100) <= silentAimHitChance then
                local hitPosition = silentAimTarget.Position
                if not silentAimAllowWallbang then
                    hitPosition = getVisibleHitPointSA(silentAimTarget.Part, silentAimTarget.Character)
                end
                if hitPosition then
                    hitResult = {
                        ["Instance"] = silentAimTarget.Part,
                        ["Position"] = hitPosition,
                        ["Normal"] = Vector3.new(0, 1, 0),
                        ["Material"] = silentAimTarget.Part.Material
                    }
                end
            end
            return oldController(_, hitResult, ...)
        end)
        local ok, previous = pcall(hookfunction, controllerFunction, buloControllerHook)
        if not ok or type(previous) ~= "function" then return false end
        oldController = previous
        BuloSilentAimController = controllerFunction
        BuloSilentAimOriginal = previous
        BuloSilentAimHook = buloControllerHook
        return true
    end
    local trying = false
    function BuloStartSilentAimHook()
        if trying or BuloHubUnloaded or not silentAimEnabled or BuloSilentAimController
            or type(hookfunction) ~= "function" then return end
        trying = true
        task.spawn(function()
            for _ = 1, 50 do
                if BuloHubUnloaded or not silentAimEnabled or installSilentAimHookSA() then break end
                task.wait(0.5)
            end
            trying = false
        end)
    end
end)
pcall(function()
    if not WallbangFeatureAvailable or not hookfunction then return end
    local newcclosure2 = newcclosure or function(f) return f end
    local oldRaycast
    local buloWallbangHook = newcclosure2(function(self, origin, direction, rayParams, ...)
        local colonCall = typeof(self) ~= "Vector3"
        local realOrigin = colonCall and origin or self
        local realDirection = colonCall and direction or origin
        local trailing = {...}
        if not BuloHubUnloaded and silentAimEnabled and silentAimWallbang
            and (BuloWallbangInputHeld or tick() <= BuloWallbangShotUntil)
            and silentAimTarget and silentAimTarget.Part
            and typeof(realOrigin) == "Vector3" and typeof(realDirection) == "Vector3"
            and realDirection.Magnitude > 0.05 then
            local localCharacter = LocalPlayer.Character
            local root = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
            local camera = workspace.CurrentCamera
            local nearLocalCharacter = root and (realOrigin - root.Position).Magnitude <= 120
            local nearCamera = camera and (realOrigin - camera.CFrame.Position).Magnitude <= 120
            local targetPart = silentAimTarget.Part
            local targetModel = targetPart:FindFirstAncestorOfClass("Model")
            local targetPosition = silentAimTarget.Position or targetPart.Position
            local toTarget = targetPosition - realOrigin
            local isAimedAtTarget = toTarget.Magnitude > 0.05
                and realDirection.Unit:Dot(toTarget.Unit) >= 0.70
            if (nearLocalCharacter or nearCamera) and isAimedAtTarget and targetPart.Parent then
                local targetParams = RaycastParams.new()
                targetParams.FilterType = Enum.RaycastFilterType.Include
                targetParams.FilterDescendantsInstances = {targetModel or targetPart}
                targetParams.IgnoreWater = true
                pcall(function()
                    if rayParams and rayParams.CollisionGroup then
                        targetParams.CollisionGroup = rayParams.CollisionGroup
                    end
                end)
                local rayLength = math.max(realDirection.Magnitude, toTarget.Magnitude + 2)
                if colonCall then
                    return oldRaycast(self, realOrigin, toTarget.Unit * rayLength, targetParams, table.unpack(trailing))
                end
                return oldRaycast(realOrigin, toTarget.Unit * rayLength, targetParams, table.unpack(trailing))
            end
        end
        if colonCall then
            return oldRaycast(self, origin, direction, rayParams, table.unpack(trailing))
        end
        return oldRaycast(self, origin, direction, table.unpack(trailing))
    end)
    local ok, previous = pcall(hookfunction, workspace.Raycast, buloWallbangHook)
    if ok and type(previous) == "function" then
        oldRaycast = previous
        BuloWallbangRaycastOriginal = previous
        BuloWallbangRaycastHook = buloWallbangHook
    end
end)
BuloTrackConnection(UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not silentAimEnabled or not silentAimWallbang then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
        or input.KeyCode == Enum.KeyCode.ButtonR2 then
        BuloWallbangInputHeld = true
        BuloWallbangShotUntil = tick() + 0.50
    end
end))
BuloTrackConnection(UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
        or input.KeyCode == Enum.KeyCode.ButtonR2 then
        BuloWallbangInputHeld = false
    end
end))
local getAmmoValueSA, clearAmmoCache
do
    local cachedTool, scanAt = nil, 0
    local values = {}
    clearAmmoCache = function()
        cachedTool, scanAt = nil, 0
        table.clear(values)
    end
    getAmmoValueSA = function(tool)
        if not tool then return nil end
        local bestValue, bestScore = nil, -math.huge
        local function consider(name, value)
            if type(value) ~= "number" then return end
            local lower = tostring(name):lower()
            if lower:find("max", 1, true) or lower:find("reserve", 1, true)
                or lower:find("total", 1, true) or lower:find("capacity", 1, true)
                or lower:find("stored", 1, true) then return end
            local score = 0
            if lower == "currentammo" or lower == "ammo" then score = 150 end
            if lower == "clip" or lower == "magazine" then score = math.max(score, 135) end
            if lower:find("current", 1, true) then score += 50 end
            if lower:find("ammo", 1, true) then score += 35 end
            if lower:find("clip", 1, true) or lower:find("mag", 1, true) then score += 30 end
            if lower:find("bullet", 1, true) or lower:find("round", 1, true) then score += 20 end
            if score > bestScore then bestScore, bestValue = score, value end
        end
        for name, value in pairs(tool:GetAttributes()) do
            consider(name, value)
        end
        local now = tick()
        if cachedTool ~= tool or now >= scanAt then
            cachedTool, scanAt = tool, now + 0.5
            table.clear(values)
            for _, item in ipairs(BuloCachedDescendants(tool, "value")) do
                if item:IsA("IntValue") or item:IsA("NumberValue") or item:IsA("StringValue") then
                    table.insert(values, item)
                end
            end
        end
        for _, item in ipairs(values) do
            if item.Parent and item:IsDescendantOf(tool) then
                if item:IsA("StringValue") then consider(item.Name, tonumber(item.Value))
                else consider(item.Name, item.Value) end
            end
        end
        return bestValue
    end
end
local getGuiAmmoValueSA, clearGuiAmmoCache
do
    local cachedGui, scanAt = nil, 0
    local candidates = {}
    clearGuiAmmoCache = function()
        cachedGui, scanAt = nil, 0
        table.clear(candidates)
    end
    getGuiAmmoValueSA = function()
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not playerGui then return nil end
        local now = tick()
        if cachedGui ~= playerGui or now >= scanAt then
            cachedGui, scanAt = playerGui, now + 1
            table.clear(candidates)
            for _, item in ipairs(BuloCachedDescendants(playerGui, "text")) do
                if item:IsA("TextLabel") or item:IsA("TextButton") then
                    local name = item.Name:lower()
                    local text = tostring(item.Text or "")
                    if name:find("ammo", 1, true) or name:find("clip", 1, true)
                        or name:find("mag", 1, true) or text:match("^%s*%d+%s*/%s*%d+%s*$") then
                        table.insert(candidates, item)
                    end
                end
            end
        end
        local bestValue, bestScore = nil, -math.huge
        for _, item in ipairs(candidates) do
            if item.Parent and item:IsDescendantOf(playerGui) then
                local name = item.Name:lower()
                local text = tostring(item.Text or "")
                local current, maximum = text:match("^%s*(%d+)%s*/%s*(%d+)%s*$")
                if current and maximum then
                    local score = 10
                    if name:find("ammo", 1, true) then score += 60 end
                    if name:find("clip", 1, true) or name:find("mag", 1, true) then score += 50 end
                    if score > bestScore then bestScore, bestValue = score, tonumber(current) end
                end
            end
        end
        return bestValue
    end
end
local function fireReloadRemotesSA(tool)
    local visited = {}
    local function tryRemote(remote)
        if not remote or visited[remote] then return end
        visited[remote] = true
        local name = remote.Name:lower()
        if not (name == "reload" or name:find("reload", 1, true) or name == "rld") then return end
        pcall(function()
            if remote:IsA("RemoteEvent") or remote:IsA("UnreliableRemoteEvent") then
                remote:FireServer()
            elseif remote:IsA("RemoteFunction") then
                task.spawn(function() pcall(function() remote:InvokeServer() end) end)
            end
        end)
    end
    local roots = {
        tool,
        LocalPlayer.Character,
        ReplicatedStorage
    }
    for _, root in ipairs(roots) do
        if root then
            if root:IsA("RemoteEvent") or root:IsA("UnreliableRemoteEvent") or root:IsA("RemoteFunction") then
                tryRemote(root)
            end
            for _, item in ipairs(root:GetDescendants()) do
                if item:IsA("RemoteEvent") or item:IsA("UnreliableRemoteEvent") or item:IsA("RemoteFunction") then
                    tryRemote(item)
                end
            end
        end
    end
end
local function triggerReloadSA(tool)
    fireReloadRemotesSA(tool)
    pcall(function()
        VIM:SendKeyEvent(true, Enum.KeyCode.R, false, game)
        task.wait(0.06)
        VIM:SendKeyEvent(false, Enum.KeyCode.R, false, game)
    end)
end
do
    local generation = 0
    function BuloSetAutoReload(on)
        autoReloadEnabled = on and true or false
        generation += 1
        if not autoReloadEnabled or BuloHubUnloaded then
            clearAmmoCache()
            clearGuiAmmoCache()
            return
        end
        local current = generation
        task.spawn(function()
            while not BuloHubUnloaded and autoReloadEnabled and generation == current do
                pcall(function()
                    local character = LocalPlayer.Character
                    local tool = character and character:FindFirstChildOfClass("Tool")
                    if not tool then return end
                    local ammo = getAmmoValueSA(tool)
                    if ammo == nil then ammo = getGuiAmmoValueSA() end
                    if ammo ~= nil and ammo <= 0 and tick() - autoReloadLastPress >= 0.40 then
                        autoReloadLastPress = tick()
                        triggerReloadSA(tool)
                    end
                end)
                task.wait(0.08)
            end
        end)
    end
end
local scpEspEnabled = false
local scpEspShowNames = true
local scpEspColor = Color3.fromRGB(0, 120, 255)
local scpEspNameColor = Color3.fromRGB(255, 255, 255)
local excludedSCPs = {["SCP-409"] = true, ["SCP-087"] = true, ["SCP-002"] = true}
local function getSCPLabelPart(obj)
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") and obj.PrimaryPart then return obj.PrimaryPart end
    return obj:FindFirstChild("HumanoidRootPart", true)
        or obj:FindFirstChildWhichIsA("BasePart", true)
end
local function clearSCPHighlights()
    local scpFolder = workspace:FindFirstChild("SCPs")
    if scpFolder then
        for _, scp in ipairs(scpFolder:GetChildren()) do
            local highlight = scp:FindFirstChild("SCPEsp")
            local label = scp:FindFirstChild("SCPEspName")
            if highlight then highlight:Destroy() end
            if label then label:Destroy() end
        end
    end
end
local function createSCPHighlight(obj)
    if not obj:FindFirstChild("SCPEsp") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "SCPEsp"
        highlight.Adornee = obj
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = scpEspColor
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 0
        highlight.OutlineColor = scpEspColor
        highlight.Parent = obj
    end
    local label = obj:FindFirstChild("SCPEspName")
    if not label then
        local adornee = getSCPLabelPart(obj)
        if not adornee then return end
        label = Instance.new("BillboardGui")
        label.Name = "SCPEspName"
        label.Adornee = adornee
        label.AlwaysOnTop = true
        label.Size = UDim2.fromOffset(180, 28)
        label.StudsOffsetWorldSpace = Vector3.new(0, 3.5, 0)
        label.Parent = obj
        local text = Instance.new("TextLabel")
        text.Name = "Name"
        text.Size = UDim2.fromScale(1, 1)
        text.BackgroundTransparency = 1
        text.Font = Enum.Font.GothamBold
        text.TextSize = 11
        text.TextStrokeTransparency = 0
        text.TextColor3 = scpEspNameColor
        text.Text = obj.Name
        text.Parent = label
    end
    label.Enabled = scpEspShowNames
    local text = label:FindFirstChild("Name")
    if text and text:IsA("TextLabel") then
        text.Text = obj.Name
        text.TextColor3 = scpEspNameColor
    end
end
local function applySCPESPColors()
    local scpFolder = workspace:FindFirstChild("SCPs")
    if not scpFolder then return end
    for _, scp in ipairs(scpFolder:GetChildren()) do
        local highlight = scp:FindFirstChild("SCPEsp")
        if highlight and highlight:IsA("Highlight") then
            highlight.FillColor = scpEspColor
            highlight.OutlineColor = scpEspColor
        end
        local label = scp:FindFirstChild("SCPEspName")
        local text = label and label:FindFirstChild("Name")
        if text and text:IsA("TextLabel") then text.TextColor3 = scpEspNameColor end
    end
end
local function setSCPNameLabelsVisible(visible)
    scpEspShowNames = visible
    local scpFolder = workspace:FindFirstChild("SCPs")
    if not scpFolder then return end
    for _, scp in ipairs(scpFolder:GetChildren()) do
        local label = scp:FindFirstChild("SCPEspName")
        if label and label:IsA("BillboardGui") then
            label.Enabled = visible and scpEspEnabled
        end
    end
end
do
    local generation = 0
    function BuloSetSCPESP(on)
        scpEspEnabled = on and true or false
        generation += 1
        if not scpEspEnabled then clearSCPHighlights(); return end
        if BuloHubUnloaded then return end
        local current = generation
        task.spawn(function()
            while not BuloHubUnloaded and scpEspEnabled and generation == current do
                local scpFolder = workspace:FindFirstChild("SCPs")
                if scpFolder then
                    for _, scp in ipairs(scpFolder:GetChildren()) do
                        if not excludedSCPs[scp.Name] then createSCPHighlight(scp) end
                    end
                end
                task.wait(1)
            end
        end)
    end
end
local currentTeleportId = 0
local function advancedTeleport(targetX, targetY, targetZ)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local hrp  = char:WaitForChild("HumanoidRootPart")
    currentTeleportId = currentTeleportId + 1
    local myId = currentTeleportId
    local y1 = -80
    local s=4.5; local d=0.1; local bs=4; local life=5
    local folder = workspace:FindFirstChild("GeneratedPath") or Instance.new("Folder", workspace)
    folder.Name = "GeneratedPath"
    local function block(pos)
        local b = Instance.new("Part")
        b.Size=Vector3.new(bs,1,bs); b.Position=pos-Vector3.new(0,2,0)
        b.Anchored=true; b.CanCollide=true
        b.Material=Enum.Material.Metal; b.Transparency=1
        b.Parent=folder
        task.delay(life, function() if b then b:Destroy() end end)
    end
    local function moveY(destY)
        local pos = hrp.Position
        local dir = (destY > pos.Y) and 1 or -1
        while (dir==1 and pos.Y < destY) or (dir==-1 and pos.Y > destY) do
            if currentTeleportId ~= myId then return false end
            local y = pos.Y + dir*s
            if math.abs(y-destY) < s then y=destY end
            pos = Vector3.new(pos.X,y,pos.Z)
            hrp.CFrame = CFrame.new(pos); block(pos); task.wait(d)
        end
        return true
    end
    local function moveXZ(destX, destZ)
        local pos  = hrp.Position
        local to   = Vector3.new(destX,y1,destZ)
        local dir  = (to-pos).Unit
        local dist = (to-pos).Magnitude
        if dist < 1 then return true end
        for i = 1, math.ceil(dist/s) do
            if currentTeleportId ~= myId then return false end
            local newPos = pos + dir*math.min(i*s,dist)
            hrp.CFrame = CFrame.new(newPos); block(newPos); task.wait(d)
        end
        hrp.CFrame = CFrame.new(destX,y1,destZ)
        return true
    end
    task.spawn(function()
        if not moveY(y1)               then return end
        if not moveXZ(targetX,targetZ) then return end
        moveY(targetY)
    end)
end
local ESPConfig = {
    Enabled=false, ShowBoxes=true, ShowNames=true,
    ShowHealthBar=true, ShowTeamColor=true, TextSize=14,
    BoxThickness=2, BoxTransparency=0.5, MaxDistance=5000,
    HeightOffset=Vector3.new(0,3,0), EnemyColor=Color3.fromRGB(255,70,70), AllyColor=Color3.fromRGB(70,255,70),
}
local connections = {}
autoBuyEnabled = false
autoBuyItems = {"M9"}
autoBuyInterval = 3
autoBuyLastCheck = 0
autoBuyItemOptions = {"Knife", "M9", "BR-762", "Pistol", "Kv-45", "Spas - 12"}
function normalizeBuyName(name)
    return name:lower():gsub("%s*-%s*", "-"):gsub("[%s_%-]", "")
end
buyAliases = {
    ["Kv-45"] = {"Kv-45", "KV-45", "KV 45", "Kv45"},
}
function getBuyNames(itemName)
    local names = buyAliases[itemName] or {itemName}
    local seen, result = {}, {}
    for _, name in ipairs(names) do
        local key = normalizeBuyName(name)
        if not seen[key] then
            seen[key] = true
            table.insert(result, name)
        end
    end
    return result
end
function containerHasBuyName(container, itemName)
    if not container then return false end
    local accepted = {}
    for _, name in ipairs(getBuyNames(itemName)) do accepted[normalizeBuyName(name)] = true end
    for _, child in ipairs(container:GetChildren()) do
        if accepted[normalizeBuyName(child.Name)] then return true end
    end
    return false
end
function hasBoughtItem(itemName)
    return containerHasBuyName(Player.Character, itemName)
        or containerHasBuyName(Player:FindFirstChild("Backpack"), itemName)
end
function guiFrameMatchesItem(frame, itemName)
    local accepted = {}
    for _, name in ipairs(getBuyNames(itemName)) do accepted[normalizeBuyName(name)] = true end
    if accepted[normalizeBuyName(frame.Name)] then return true end
    for _, descendant in ipairs(frame:GetDescendants()) do
        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
            if accepted[normalizeBuyName(descendant.Text or "")] then return true end
        end
    end
    return false
end
function buyItem(itemName)
    if type(itemName) ~= "string" or itemName == "" then return end
    local names = getBuyNames(itemName)
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            for _, remoteName in ipairs({"AlexShop", "JerryShop", "Shop", "BuyItem", "Buy", "Purchase"}) do
                local remote = remotes:FindFirstChild(remoteName)
                if remote and (remote:IsA("RemoteEvent") or remote:IsA("UnreliableRemoteEvent")) then
                    for _, name in ipairs(names) do remote:FireServer(name) end
                end
            end
            local update = remotes:FindFirstChild("Update")
            if update and (update:IsA("RemoteEvent") or update:IsA("UnreliableRemoteEvent")) then
                for _, name in ipairs(names) do update:FireServer(name) end
            end
        end
    end)
    pcall(function()
        local utility = Player:FindFirstChild("PlayerGui") and Player.PlayerGui:FindFirstChild("Utility")
        if not utility then return end
        for _, shopName in ipairs({"Jerry", "Alex"}) do
            local shop = utility:FindFirstChild(shopName)
            local content = shop and shop:FindFirstChild("Content")
            if content then
                for _, frame in ipairs(content:GetChildren()) do
                    if frame:IsA("GuiObject") and guiFrameMatchesItem(frame, itemName) then
                        local purchase = frame:FindFirstChild("Purchase")
                            or frame:FindFirstChildWhichIsA("TextButton")
                            or frame:FindFirstChildWhichIsA("ImageButton")
                        if purchase and firesignal then firesignal(purchase.MouseButton1Click) end
                    end
                end
            end
        end
    end)
end
do
    local generation = 0
    function BuloSetAutoBuy(on)
        autoBuyEnabled = on and true or false
        generation += 1
        if not autoBuyEnabled or BuloHubUnloaded then return end
        autoBuyLastCheck = tick() - autoBuyInterval
        local current = generation
        task.spawn(function()
            while not BuloHubUnloaded and autoBuyEnabled and generation == current do
                if tick() - autoBuyLastCheck >= autoBuyInterval then
                    autoBuyLastCheck = tick()
                    for _, itemName in ipairs(autoBuyItems) do
                        if not hasBoughtItem(itemName) then buyItem(itemName) end
                    end
                end
                task.wait(0.15)
            end
        end)
    end
end
BuloTrackConnection(Player.CharacterAdded:Connect(function()
    task.delay(1.5, function()
        if BuloHubUnloaded or not autoBuyEnabled then return end
        for _, itemName in ipairs(autoBuyItems) do
            if not hasBoughtItem(itemName) then buyItem(itemName) end
        end
    end)
end))
autoHatchesEnabled = false
autoHatchRadius = 30
autoHatchDelay = 0.05
autoHatchLastRun = 0
cachedHatches = {}
cachedHatchLookup = setmetatable({}, {__mode = "k"})
function isHatchRelated(obj)
    if not obj then return false end
    local name = obj.Name:lower()
    if name:find("vent") or name:find("hatch") or name:find("grate") or name:find("grille")
        or name:find("duct") or name:find("panel") or name:find("screw") or name:find("cover") then
        return true
    end
    if obj:IsA("ProximityPrompt") then
        local action = (obj.ActionText or ""):lower()
        local object = (obj.ObjectText or ""):lower()
        return action:find("vent") or action:find("hatch") or action:find("unscrew")
            or action:find("break") or action:find("open") or action:find("grate")
            or action:find("grille") or action:find("cover") or action:find("crawl")
            or object:find("vent") or object:find("hatch") or object:find("grate")
            or object:find("grille") or object:find("cover")
    end
    return false
end
function cacheHatchInteractable(descendant)
    if cachedHatchLookup[descendant] then return end
    if not (descendant:IsA("ProximityPrompt") or descendant:IsA("ClickDetector")) then return end
    local parent = descendant.Parent
    local matches = isHatchRelated(descendant)
        or isHatchRelated(parent)
        or (parent and isHatchRelated(parent.Parent))
        or (parent and parent.Parent and isHatchRelated(parent.Parent.Parent))
    if matches then
        table.insert(cachedHatches, descendant)
        cachedHatchLookup[descendant] = #cachedHatches
    end
end
function getHatchPosition(interactable)
    local current = interactable and interactable.Parent
    for _ = 1, 4 do
        if not current then break end
        if current:IsA("BasePart") then return current.Position end
        local part = current:FindFirstChildWhichIsA("BasePart")
        if part then return part.Position end
        current = current.Parent
    end
    return nil
end
function removeCachedHatch(descendant)
    local index = cachedHatchLookup[descendant]
    if not index then return end
    local lastIndex = #cachedHatches
    local last = cachedHatches[lastIndex]
    cachedHatches[lastIndex] = nil
    if index < lastIndex then
        cachedHatches[index] = last
        cachedHatchLookup[last] = index
    end
    cachedHatchLookup[descendant] = nil
end
do
    local generation = 0
    local addedConnection, removingConnection
    function BuloSetAutoHatches(on)
        autoHatchesEnabled = on and true or false
        generation += 1
        if addedConnection then addedConnection:Disconnect(); addedConnection = nil end
        if removingConnection then removingConnection:Disconnect(); removingConnection = nil end
        table.clear(cachedHatches)
        table.clear(cachedHatchLookup)
        if not autoHatchesEnabled or BuloHubUnloaded then return end
        local current = generation
        addedConnection = workspace.DescendantAdded:Connect(function(descendant)
            if not (descendant:IsA("ProximityPrompt") or descendant:IsA("ClickDetector")) then return end
            task.defer(function()
                if not BuloHubUnloaded and autoHatchesEnabled and generation == current
                    and descendant.Parent and descendant:IsDescendantOf(workspace) then
                    cacheHatchInteractable(descendant)
                end
            end)
        end)
        removingConnection = workspace.DescendantRemoving:Connect(removeCachedHatch)
        task.spawn(function()
            local character = Player.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local ok, parts = pcall(function()
                return workspace:GetPartBoundsInRadius(root.Position, autoHatchRadius)
            end)
            if not ok or type(parts) ~= "table" then return end
            local parents = {}
            local function cacheChildren(container)
                for _, child in ipairs(container:GetChildren()) do
                    cacheHatchInteractable(child)
                    if child:IsA("Attachment") then
                        for _, item in ipairs(child:GetChildren()) do cacheHatchInteractable(item) end
                    end
                end
            end
            for index, part in ipairs(parts) do
                if index > 128 or BuloHubUnloaded or not autoHatchesEnabled or generation ~= current then return end
                cacheChildren(part)
                local parent = part.Parent
                if parent and parent ~= workspace and not parents[parent] then
                    parents[parent] = true
                    cacheChildren(parent)
                end
                if index % 64 == 0 then task.wait() end
            end
        end)
        task.spawn(function()
            for index, descendant in BuloWalkDescendants(workspace) do
                if BuloHubUnloaded or not autoHatchesEnabled or generation ~= current then return end
                if descendant.Parent and descendant:IsDescendantOf(workspace) then
                    cacheHatchInteractable(descendant)
                end
                if index % 600 == 0 then task.wait() end
            end
        end)
    end
end
table.insert(connections, RS.Heartbeat:Connect(function()
    if not autoHatchesEnabled or tick() - autoHatchLastRun < autoHatchDelay then return end
    autoHatchLastRun = tick()
    local character = Player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for index = #cachedHatches, 1, -1 do
        local interactable = cachedHatches[index]
        if not interactable or not interactable.Parent or not interactable:IsDescendantOf(workspace) then
            if interactable then removeCachedHatch(interactable) end
        else
            local position = getHatchPosition(interactable)
            if position and (position - root.Position).Magnitude <= autoHatchRadius then
                if interactable:IsA("ProximityPrompt") and interactable.Enabled then
                    pcall(function()
                        interactable.HoldDuration = 0
                        if fireproximityprompt then fireproximityprompt(interactable, 0) end
                        interactable:InputHoldBegin()
                        interactable:InputHoldEnd()
                    end)
                elseif interactable:IsA("ClickDetector") then
                    pcall(function()
                        if fireclickdetector then fireclickdetector(interactable) end
                    end)
                end
            end
        end
    end
end))
weaponSkinEnabled = false
weaponSkinName = "Obsidian"
weaponSkinMaterial = "Default"
weaponSkinRainbow = false
weaponSkinRainbowSpeed = 1
weaponSkinUseTint = false
weaponSkinTint = Color3.fromRGB(255, 255, 255)
bag096Skin = "Default"
cage173Skin = "Default"
weaponSkinLastApply = 0
weaponSkinTextures = {
    ["Obsidian"] = "rbxassetid://6822193586", ["Gold"] = "rbxassetid://6822161361",
    ["Diamond"] = "rbxassetid://6822175471", ["Emerald"] = "rbxassetid://6822194233",
    ["Ruby"] = "rbxassetid://6822175708", ["Platinum"] = "rbxassetid://6822176021",
    ["Dimension"] = "rbxassetid://6825110287", ["Gem"] = "rbxassetid://6825691769",
    ["Waves"] = "rbxassetid://6825692245", ["Hazard"] = "rbxassetid://84265611295576",
    ["Cheese"] = "rbxassetid://4460955897", ["SCP"] = "rbxassetid://6825693009",
    ["Anniversary 2025"] = "rbxassetid://105651594599281", ["Halloween 2024"] = "rbxassetid://85602806295964",
    ["Winter 2024"] = "rbxassetid://97068753364693", ["Halloween 2023"] = "rbxassetid://15167620490",
    ["Winter 2023"] = "rbxassetid://15693907042", ["Gold Wrap"] = "rbxassetid://11313213423",
    ["Reptile"] = "rbxassetid://6971038959", ["Protector"] = "rbxassetid://12489440495",
    ["Liberator"] = "rbxassetid://12489647199", ["Plasma"] = "rbxassetid://6824491950",
    ["Fire"] = "rbxassetid://6824464030", ["Energy"] = "rbxassetid://6824491600",
    ["Warp"] = "rbxassetid://6824491156", ["Moon"] = "rbxassetid://6824492848",
    ["Metal"] = "rbxassetid://6824463630", ["Rust"] = "rbxassetid://6824457460",
    ["Crystal"] = "rbxassetid://5366466412", ["Ice"] = "rbxassetid://171424974",
    ["Hexagon"] = "rbxassetid://6824305439", ["Snow"] = "rbxassetid://6824352844",
    ["Tiger"] = "rbxassetid://546728018", ["Zebra"] = "rbxassetid://70082511",
    ["Glass"] = "rbxassetid://6825109128", ["Paint"] = "rbxassetid://6825109474",
    ["Ghost"] = "rbxassetid://6825107579", ["Sky"] = "rbxassetid://6825108360",
    ["Night"] = "rbxassetid://6825106836", ["Flecktarn"] = "rbxassetid://4455786061",
    ["Woodland"] = "rbxassetid://147004494", ["Splinter"] = "rbxassetid://5465362420",
    ["Digital"] = "rbxassetid://4641726146", ["Navy"] = "rbxassetid://1372730185",
    ["Urban"] = "rbxassetid://127663741",
}
bag096Textures = {
    ["Biohazard"] = "rbxassetid://15019773957", ["Chaotic"] = "rbxassetid://15020004607",
    ["Practice"] = "rbxassetid://15020128431", ["Arctic Camo"] = "rbxassetid://122316904478031",
    ["Ashen"] = "rbxassetid://89955405427725", ["Oceanic"] = "rbxassetid://84551201138385",
    ["Hacked"] = "rbxassetid://102535070823547", ["Steampunk"] = "rbxassetid://107492507608178",
    ["GOC"] = "rbxassetid://84136970949240", ["Pumpkin"] = "rbxassetid://103756103004885",
    ["Ice"] = "rbxassetid://78589425536209",
}
cage173Textures = {
    ["Golden Cage"] = "rbxassetid://15020641805", ["Task Force"] = "rbxassetid://15021109017",
    ["Under Construction"] = "rbxassetid://15020634801", ["Frozen"] = "rbxassetid://98142512393630",
    ["Space Age"] = "rbxassetid://110162634933520", ["Ashen"] = "rbxassetid://117534611667724",
    ["Binary Matrix"] = "rbxassetid://91523767251031", ["Reinforced"] = "rbxassetid://104669866210235",
    ["Steampunk"] = "rbxassetid://97106561464823",
}
weaponSkinOriginals = setmetatable({}, {__mode = "k"})
function cacheWeaponAppearance(part)
    if not part or weaponSkinOriginals[part] then return end
    local original = {}
    if part:IsA("MeshPart") then original.TextureID = part.TextureID end
    if part:IsA("SpecialMesh") then original.TextureId = part.TextureId end
    if part:IsA("BasePart") then
        original.Color = part.Color
        original.Material = part.Material
    end
    weaponSkinOriginals[part] = original
end
function restoreWeaponAppearances()
    for part, original in pairs(weaponSkinOriginals) do
        pcall(function()
            if part and part.Parent then
                if original.TextureID ~= nil then part.TextureID = original.TextureID end
                if original.TextureId ~= nil then part.TextureId = original.TextureId end
                if original.Color ~= nil then part.Color = original.Color end
                if original.Material ~= nil then part.Material = original.Material end
            end
        end)
        weaponSkinOriginals[part] = nil
    end
    if BuloExtra and BuloExtra.Objects then pcall(BuloExtra.Objects.Refresh) end
end
function BuloIsExtraManaged(inst)
    local part = inst and inst:IsA("SpecialMesh") and inst.Parent or inst
    return part and part:GetAttribute("BuloExtraSCPManaged") == true
end
function textureSpecialItem(container, texture)
    if not texture then return end
    for _, item in ipairs(BuloCachedDescendants(container)) do
        local meshPart = item:IsA("MeshPart")
        local specialMesh = item:IsA("SpecialMesh")
        if (meshPart or specialMesh) and not BuloIsExtraManaged(item) then
            cacheWeaponAppearance(item)
            if meshPart and item.TextureID ~= texture then item.TextureID = texture end
            if specialMesh and item.TextureId ~= texture then item.TextureId = texture end
        end
    end
end
do
    local materialMap = {
        ["ForceField (Glow)"] = Enum.Material.ForceField,
        ["Neon"] = Enum.Material.Neon,
        ["Glass"] = Enum.Material.Glass,
        ["Foil (Chrome)"] = Enum.Material.Foil,
        ["SmoothPlastic"] = Enum.Material.SmoothPlastic,
    }
    function applyWeaponSkinChanger(force)
        if not weaponSkinEnabled then return end
        local now = tick()
        if not force and now - weaponSkinLastApply < 0.20 then return end
        weaponSkinLastApply = now
        local texture = weaponSkinTextures[weaponSkinName]
        local rainbowColor = weaponSkinRainbow and Color3.fromHSV((now * weaponSkinRainbowSpeed * 0.4) % 1, 0.9, 1) or nil
        local material = materialMap[weaponSkinMaterial]
        local function modify(part)
            local specialMesh = part:IsA("SpecialMesh")
            if not specialMesh and not part:IsA("BasePart") then return end
            if BuloIsExtraManaged(part) then return end
            cacheWeaponAppearance(part)
            if specialMesh then
                if texture and part.TextureId ~= texture then part.TextureId = texture end
                return
            end
            if part:IsA("MeshPart") and texture and part.TextureID ~= texture then part.TextureID = texture end
            if material and part.Material ~= material then part.Material = material end
            local color = rainbowColor or (weaponSkinUseTint and weaponSkinTint) or nil
            if color and part.Color ~= color then part.Color = color end
        end
        local character = Player.Character
        if character then
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("Tool") or child:IsA("Model") then
                    local name = child.Name:lower()
                    if name:find("scythe") or child:GetAttribute("BuloExtraBackItem") then
                    elseif (name:find("bag") or name:find("096")) and bag096Skin ~= "Default" then
                        textureSpecialItem(child, bag096Textures[bag096Skin])
                    elseif (name:find("cage") or name:find("173")) and cage173Skin ~= "Default" then
                        textureSpecialItem(child, cage173Textures[cage173Skin])
                    else
                        for _, part in ipairs(BuloCachedDescendants(child)) do modify(part) end
                    end
                end
            end
        end
        local camera = workspace.CurrentCamera
        if camera then
            for _, child in ipairs(camera:GetChildren()) do
                local name = child.Name:lower()
                if child:IsA("Model") or name:find("viewmodel") or name:find("gun") or name:find("arm") then
                    for _, part in ipairs(BuloCachedDescendants(child)) do modify(part) end
                end
            end
        end
    end
end
table.insert(connections, RS.RenderStepped:Connect(function()
    if weaponSkinEnabled then applyWeaponSkinChanger(false) end
end))
fbOriginals = nil
espColor = Color3.fromRGB(255,255,255)
ESPObjects = {}
isFlying = false
flyTarget = nil
MobileAimActive = false
flyActive = false
flyCurrentVel = Vector3.zero
flyHeartbeatConn = nil
local flyCharacter, flyRootPart, flyHumanoid = nil, nil, nil
flyInputState = {forward=false,backward=false,left=false,right=false,up=false,down=false}
Clip = true
BuloNoclipCollisionStates = setmetatable({}, {__mode = "k"})
FlingOriginalPartStates = setmetatable({}, {__mode = "k"})
do
    local character, parts = nil, {}
    local added, removing
    function BuloClearCollisionParts()
        if added then added:Disconnect(); added = nil end
        if removing then removing:Disconnect(); removing = nil end
        character = nil
        table.clear(parts)
    end
    function BuloGetCollisionParts()
        local current = Player.Character
        if current ~= character then
            BuloClearCollisionParts()
            character = current
            if current then
                for _, part in ipairs(current:GetDescendants()) do
                    if part:IsA("BasePart") then parts[part] = true end
                end
                added = current.DescendantAdded:Connect(function(part)
                    if part:IsA("BasePart") then parts[part] = true end
                end)
                removing = current.DescendantRemoving:Connect(function(part) parts[part] = nil end)
            end
        end
        return parts
    end
end
function BuloCollisionWanted()
    return Cfg.NoclipEnabled or isFlying or not Clip or (FlingV2 and FlingV2.Active) or false
end
function BuloDisableCollision(part)
    if BuloNoclipCollisionStates[part] == nil then
        BuloNoclipCollisionStates[part] = part.CanCollide
    end
    if part.CanCollide then part.CanCollide = false end
end
function BuloRestoreCollision()
    for part, canCollide in pairs(BuloNoclipCollisionStates) do
        pcall(function()
            if part and part.Parent then part.CanCollide = canCollide end
        end)
        BuloNoclipCollisionStates[part] = nil
    end
end
flinging = false
flingDied = nil
FLYING = false
QEfly = true
iyflyspeed = 0.7
local flyKeyDown, flyKeyUp
local function isAlly(p)
    if p==Player then return true end
    if not Cfg.IgnoreTeam then return false end
    if not Player.Team or not p.Team then return false end
    return Player.Team==p.Team
end
local function isEnemy(p) return not isAlly(p) end
local function setFullbright(state)
    if state then
        if not fbOriginals then
            fbOriginals = {
                ClockTime=Lighting.ClockTime, FogEnd=Lighting.FogEnd,
                FogStart=Lighting.FogStart,   Ambient=Lighting.Ambient,
                OutdoorAmbient=Lighting.OutdoorAmbient, Brightness=Lighting.Brightness,
            }
        end
        Lighting.Ambient=Color3.fromRGB(255,255,255)
        Lighting.OutdoorAmbient=Color3.fromRGB(255,255,255)
        Lighting.Brightness=2; Lighting.FogEnd=1e10
        Lighting.FogStart=0;   Lighting.ClockTime=14
    else
        if fbOriginals then
            Lighting.ClockTime=fbOriginals.ClockTime; Lighting.FogEnd=fbOriginals.FogEnd
            Lighting.FogStart=fbOriginals.FogStart;   Lighting.Ambient=fbOriginals.Ambient
            Lighting.OutdoorAmbient=fbOriginals.OutdoorAmbient
            Lighting.Brightness=fbOriginals.Brightness
            fbOriginals=nil
        end
    end
end
local function stopFly()
    if not isFlying then return end
    isFlying=false; flyTarget=nil
    local char=Player.Character
    if char then
        local root=char:FindFirstChild("HumanoidRootPart")
        if root then
            pcall(function() root.Velocity=Vector3.new(0,0,0) end)
            pcall(function() root.AssemblyLinearVelocity=Vector3.new(0,0,0) end)
        end
        if not BuloCollisionWanted() then BuloRestoreCollision() end
    end
end
local function fetchFlyCharParts(char)
    flyCharacter=char
    flyRootPart=char and char:FindFirstChild("HumanoidRootPart") or nil
    flyHumanoid=char and char:FindFirstChildOfClass("Humanoid") or nil
end
local function enableFly()
    if BuloExtra then BuloExtra.Fly.Set(true) end
end
local function disableFly()
    if BuloExtra then BuloExtra.Fly.Set(false) end
end
local function createFlyMobileControls()
    if not UIS.TouchEnabled then return end
    local existing = Player:FindFirstChild("PlayerGui") and Player.PlayerGui:FindFirstChild("FlyMobileControls")
    if existing then existing:Destroy() end
    local gui2=Instance.new("ScreenGui")
    gui2.Name="FlyMobileControls"; gui2.ResetOnSpawn=false
    gui2.Parent=Player:WaitForChild("PlayerGui")
    local sz=UDim2.new(0,90,0,90)
    local function makeBtn(name,text,pos)
        local btn=Instance.new("TextButton")
        btn.Name=name; btn.Text=text
        btn.Font=Enum.Font.GothamBold; btn.TextSize=22
        btn.TextColor3=Color3.new(1,1,1)
        btn.BackgroundColor3=Color3.fromRGB(40,40,40)
        btn.BackgroundTransparency=0.3; btn.BorderSizePixel=0
        btn.Position=pos; btn.Size=sz; btn.AutoButtonColor=false
        btn.Parent=gui2; return btn
    end
    local fwd=makeBtn("Forward","^", UDim2.new(0.14,-45,0.82,-105))
    local bwd=makeBtn("Backward","v",UDim2.new(0.14,-45,0.82,15))
    local lft=makeBtn("Left","<",   UDim2.new(0.06,-45,0.82,-45))
    local rgt=makeBtn("Right",">",  UDim2.new(0.22,-45,0.82,-45))
    local function conn(btn,key)
        btn.MouseButton1Down:Connect(function() flyInputState[key]=true  end)
        btn.MouseButton1Up:Connect(function()   flyInputState[key]=false end)
        btn.MouseLeave:Connect(function()       flyInputState[key]=false end)
    end
    conn(fwd,"forward"); conn(bwd,"backward"); conn(lft,"left"); conn(rgt,"right")
    local up=makeBtn("Up", "+", UDim2.new(0.90,-45,0.74,-95))
    local down=makeBtn("Down", "-", UDim2.new(0.90,-45,0.74,10))
    conn(up,"up"); conn(down,"down")
end
BuloTrackConnection(UIS.InputBegan:Connect(function(input,gp)
    if BuloHubUnloaded or gp then return end
    local k=input.KeyCode
    if     k==Enum.KeyCode.W then flyInputState.forward =true
    elseif k==Enum.KeyCode.S then flyInputState.backward=true
    elseif k==Enum.KeyCode.A then flyInputState.left    =true
    elseif k==Enum.KeyCode.D then flyInputState.right   =true
    end
end))
BuloTrackConnection(UIS.InputEnded:Connect(function(input)
    if BuloHubUnloaded then return end
    local k=input.KeyCode
    if     k==Enum.KeyCode.W then flyInputState.forward =false
    elseif k==Enum.KeyCode.S then flyInputState.backward=false
    elseif k==Enum.KeyCode.A then flyInputState.left    =false
    elseif k==Enum.KeyCode.D then flyInputState.right   =false
    end
end))
local function CreateESPForPlayer(plr)
    if plr==Player or ESPObjects[plr] then return end
    local obj={
        Box=SafeDrawing("Square"), Text=SafeDrawing("Text"),
        HealthBG=SafeDrawing("Square"), HealthBar=SafeDrawing("Square"),
    }
    obj.Box.Visible=false; obj.Box.Thickness=ESPConfig.BoxThickness
    obj.Box.Transparency=ESPConfig.BoxTransparency; obj.Box.Filled=false
    obj.Text.Visible=false; obj.Text.Size=ESPConfig.TextSize
    obj.Text.Center=true; obj.Text.Outline=true; obj.Text.Transparency=1
    obj.HealthBG.Visible=false; obj.HealthBG.Filled=true
    obj.HealthBG.Color=Color3.fromRGB(35,35,35); obj.HealthBG.Transparency=0.5
    obj.HealthBar.Visible=false; obj.HealthBar.Filled=true; obj.HealthBar.Transparency=1
    ESPObjects[plr]=obj
end
local function HideESP(obj)
    obj.Box.Visible=false; obj.Text.Visible=false
    obj.HealthBG.Visible=false; obj.HealthBar.Visible=false
end
local function GetHpColor(pct)
    return Color3.new(math.clamp(2*(1-pct),0,1),math.clamp(2*pct,0,1),0)
end
local function RenderESP()
    if not DrawingAvailable then return end
    if not ESPConfig.Enabled then
        for _, obj in pairs(ESPObjects) do HideESP(obj) end
        return
    end
    local camPos=Camera.CFrame.Position
    for plr, obj in pairs(ESPObjects) do
        if not plr or not plr.Parent or not plr.Character then HideESP(obj); continue end
        local char=plr.Character
        local hrp=char:FindFirstChild("HumanoidRootPart")
        local hum=char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health<=0 then HideESP(obj); continue end
        local dist=(hrp.Position-camPos).Magnitude
        if dist<0.5 or dist>ESPConfig.MaxDistance then HideESP(obj); continue end
        if Cfg.IgnoreTeam and isAlly(plr) then HideESP(obj); continue end
        local headTop=hrp.Position+ESPConfig.HeightOffset
        local feetBot=hrp.Position-ESPConfig.HeightOffset
        local topSP=Camera:WorldToViewportPoint(headTop)
        local botSP,onScreen=Camera:WorldToViewportPoint(feetBot)
        if not onScreen or topSP.Z<=0 then HideESP(obj); continue end
        local h=math.abs(topSP.Y-botSP.Y); local w=h*0.55
        if h<4 then HideESP(obj); continue end
        local bPos=Vector2.new(topSP.X-w*0.5,topSP.Y)
        local enemy2=isEnemy(plr)
        local teamC=plr.Team and plr.TeamColor.Color or espColor
        local boxCol=ESPConfig.ShowTeamColor and teamC or (enemy2 and ESPConfig.EnemyColor or ESPConfig.AllyColor)
        if ESPConfig.ShowBoxes then
            obj.Box.Position=bPos; obj.Box.Size=Vector2.new(w,h)
            obj.Box.Color=boxCol; obj.Box.Visible=true
        else
            obj.Box.Visible=false
        end
        if ESPConfig.ShowNames then
            obj.Text.Text=plr.Name; obj.Text.Color=boxCol
            obj.Text.Size=ESPConfig.TextSize
            obj.Text.Position=Vector2.new(topSP.X,topSP.Y-17)
            obj.Text.Visible=true
        else
            obj.Text.Visible=false
        end
        if ESPConfig.ShowHealthBar then
            local hpPct=math.clamp(hum.Health/math.max(1,hum.MaxHealth),0,1)
            local bw=3; local bx=bPos.X-bw-2
            obj.HealthBG.Position=Vector2.new(bx,topSP.Y); obj.HealthBG.Size=Vector2.new(bw,h); obj.HealthBG.Visible=true
            obj.HealthBar.Position=Vector2.new(bx,topSP.Y+h*(1-hpPct))
            obj.HealthBar.Size=Vector2.new(bw,h*hpPct)
            obj.HealthBar.Color=GetHpColor(hpPct); obj.HealthBar.Visible=true
        else
            obj.HealthBG.Visible=false; obj.HealthBar.Visible=false
        end
    end
end
local function randomString()
    local length=math.random(10,20); local array={}
    for i=1,length do array[i]=string.char(math.random(32,126)) end
    return table.concat(array)
end
local function getRoot(char)
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.RootPart or nil
end
local function enableNoclip()
    Clip = false
end
local function disableNoclip()
    Clip = true
    if not BuloCollisionWanted() then
        BuloRestoreCollision()
        BuloClearCollisionParts()
    end
end
local function NOFLY()
    FLYING=false
    if flyKeyDown then flyKeyDown:Disconnect() end
    if flyKeyUp   then flyKeyUp:Disconnect()   end
    local char=Player.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").PlatformStand=false
    end
    pcall(function() workspace.CurrentCamera.CameraType=Enum.CameraType.Custom end)
end
local function sFLY(vfly)
    local char=Player.Character or Player.CharacterAdded:Wait()
    local humanoid=char:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        repeat task.wait() until char:FindFirstChildOfClass("Humanoid")
        humanoid=char:FindFirstChildOfClass("Humanoid")
    end
    if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect(); flyKeyUp:Disconnect() end
    local T=getRoot(char)
    local CONTROL={F=0,B=0,L=0,R=0,Q=0,E=0}
    local lCONTROL={F=0,B=0,L=0,R=0,Q=0,E=0}
    local SPEED=0
    local function FLY()
        FLYING=true
        local BG=Instance.new("BodyGyro"); local BV=Instance.new("BodyVelocity")
        BG.P=9e4; BG.Parent=T; BV.Parent=T
        BG.MaxTorque=Vector3.new(9e9,9e9,9e9); BG.CFrame=T.CFrame
        BV.Velocity=Vector3.new(0,0,0); BV.MaxForce=Vector3.new(9e9,9e9,9e9)
        task.spawn(function()
            repeat task.wait()
                local camera=workspace.CurrentCamera
                if not vfly and humanoid then humanoid.PlatformStand=true end
                if CONTROL.L+CONTROL.R~=0 or CONTROL.F+CONTROL.B~=0 or CONTROL.Q+CONTROL.E~=0 then
                    SPEED=50
                elseif SPEED~=0 then SPEED=0 end
                if (CONTROL.L+CONTROL.R)~=0 or (CONTROL.F+CONTROL.B)~=0 or (CONTROL.Q+CONTROL.E)~=0 then
                    BV.Velocity=((camera.CFrame.LookVector*(CONTROL.F+CONTROL.B))+((camera.CFrame*CFrame.new(CONTROL.L+CONTROL.R,(CONTROL.F+CONTROL.B+CONTROL.Q+CONTROL.E)*0.2,0).p)-camera.CFrame.p))*SPEED
                    lCONTROL={F=CONTROL.F,B=CONTROL.B,L=CONTROL.L,R=CONTROL.R}
                elseif (CONTROL.L+CONTROL.R)==0 and (CONTROL.F+CONTROL.B)==0 and (CONTROL.Q+CONTROL.E)==0 and SPEED~=0 then
                    BV.Velocity=((camera.CFrame.LookVector*(lCONTROL.F+lCONTROL.B))+((camera.CFrame*CFrame.new(lCONTROL.L+lCONTROL.R,(lCONTROL.F+lCONTROL.B+CONTROL.Q+CONTROL.E)*0.2,0).p)-camera.CFrame.p))*SPEED
                else BV.Velocity=Vector3.new(0,0,0) end
                BG.CFrame=camera.CFrame
            until not FLYING
            CONTROL={F=0,B=0,L=0,R=0,Q=0,E=0}; lCONTROL={F=0,B=0,L=0,R=0,Q=0,E=0}; SPEED=0
            BG:Destroy(); BV:Destroy()
            if humanoid then humanoid.PlatformStand=false end
        end)
    end
    flyKeyDown=UIS.InputBegan:Connect(function(input,processed)
        if processed then return end
        local spd=iyflyspeed
        if     input.KeyCode==Enum.KeyCode.W then CONTROL.F=spd
        elseif input.KeyCode==Enum.KeyCode.S then CONTROL.B=-spd
        elseif input.KeyCode==Enum.KeyCode.A then CONTROL.L=-spd
        elseif input.KeyCode==Enum.KeyCode.D then CONTROL.R=spd
        elseif input.KeyCode==Enum.KeyCode.E and QEfly then CONTROL.Q=spd*2
        elseif input.KeyCode==Enum.KeyCode.Q and QEfly then CONTROL.E=-spd*2 end
        pcall(function() workspace.CurrentCamera.CameraType=Enum.CameraType.Track end)
    end)
    flyKeyUp=UIS.InputEnded:Connect(function(input,processed)
        if processed then return end
        if     input.KeyCode==Enum.KeyCode.W then CONTROL.F=0
        elseif input.KeyCode==Enum.KeyCode.S then CONTROL.B=0
        elseif input.KeyCode==Enum.KeyCode.A then CONTROL.L=0
        elseif input.KeyCode==Enum.KeyCode.D then CONTROL.R=0
        elseif input.KeyCode==Enum.KeyCode.E then CONTROL.Q=0
        elseif input.KeyCode==Enum.KeyCode.Q then CONTROL.E=0 end
    end)
    FLY()
end
local function unfling()
    disableNoclip(); NOFLY()
    if flingDied then flingDied:Disconnect() end
    flinging=false
    local char=Player.Character
    local root = char and getRoot(char)
    if root then
        for _, v in pairs(root:GetChildren()) do
            if v:IsA("AngularVelocity") or v:IsA("BodyAngularVelocity") or v.Name=="FlingAttachment" then
                v:Destroy()
            end
        end
    end
    for part, original in pairs(FlingOriginalPartStates) do
        pcall(function()
            if part and part.Parent then
                part.Massless = original.Massless
                part.CustomPhysicalProperties = original.CustomPhysicalProperties
            end
        end)
        FlingOriginalPartStates[part] = nil
    end
end
local function fling()
    unfling()
    local char=Player.Character; if not char then return end
    local root=getRoot(char);    if not root then return end
    flinging=true
    for _, child in pairs(char:GetDescendants()) do
        if child:IsA("BasePart") then
            if FlingOriginalPartStates[child] == nil then
                FlingOriginalPartStates[child] = {
                    Massless = child.Massless,
                    CustomPhysicalProperties = child.CustomPhysicalProperties,
                }
            end
            child.CustomPhysicalProperties=PhysicalProperties.new(100,0.3,0.5)
            BuloDisableCollision(child); child.Massless=true; child.Velocity=Vector3.new(0,0,0)
        end
    end
    enableNoclip(); task.wait(0.1)
    local bambam=Instance.new("BodyAngularVelocity")
    bambam.Name=randomString(); bambam.Parent=root
    bambam.AngularVelocity=Vector3.new(0,99999,0)
    bambam.MaxTorque=Vector3.new(0,math.huge,0); bambam.P=math.huge
    local humanoid=char:FindFirstChildOfClass("Humanoid")
    if humanoid then flingDied=humanoid.Died:Connect(unfling) end
    task.spawn(sFLY)
    task.spawn(function()
        while flinging and char and root and bambam do
            bambam.AngularVelocity=Vector3.new(0,99999,0); task.wait(0.2)
            if not flinging then break end
            bambam.AngularVelocity=Vector3.new(0,0,0); task.wait(0.1)
        end
    end)
end
FlingV2 = {
    Active = false,
    FlingRadius = 7,
    WalkSpeed = 16,
    FlingPower = 300,
}
FlingV2Flip = 1
function fixFlingV2Joints(character)
    if not character then return end
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    if humanoid then
        pcall(function()
            humanoid.RequiresNeck = false
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end)
    end
end
function restoreFlingV2State()
    if not BuloCollisionWanted() then BuloRestoreCollision() end
    local character = Player.Character
    local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
    if humanoid then
        pcall(function()
            humanoid.RequiresNeck = true
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        end)
    end
end
function setFlingV2Enabled(enabled)
    FlingV2.Active = enabled
    local character = Player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if enabled then
        fixFlingV2Joints(character)
    else
        if root then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
        restoreFlingV2State()
    end
end
do
    local nextFix = 0
    table.insert(connections, RS.Stepped:Connect(function()
        if not FlingV2.Active then nextFix = 0; return end
        if tick() < nextFix then return end
        nextFix = tick() + 0.5
        fixFlingV2Joints(Player.Character)
    end))
end
table.insert(connections, RS.Heartbeat:Connect(function()
    if not FlingV2.Active then return end
    local character = Player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
    if not (root and humanoid) then return end
    local isNearTarget = false
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= Player and otherPlayer.Character then
            local targetRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = otherPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health > 0
                and (root.Position - targetRoot.Position).Magnitude <= FlingV2.FlingRadius then
                isNearTarget = true
                break
            end
        end
    end
    if isNearTarget then
        FlingV2Flip = -FlingV2Flip
        local power = FlingV2.FlingPower * FlingV2Flip
        root.AssemblyLinearVelocity = Vector3.new(power * 0.5, 0, power * 0.5)
        root.AssemblyAngularVelocity = Vector3.new(0, FlingV2.FlingPower * 5, 0)
    end
end))
table.insert(connections, RS.RenderStepped:Connect(function()
    if not FlingV2.Active then return end
    local character = Player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
    if root and humanoid then
        local moveDirection = humanoid.MoveDirection
        if moveDirection.Magnitude > 0 then
            root.AssemblyLinearVelocity = Vector3.new(
                moveDirection.X * FlingV2.WalkSpeed,
                0,
                moveDirection.Z * FlingV2.WalkSpeed
            )
        else
            root.AssemblyLinearVelocity = Vector3.zero
        end
        root.AssemblyAngularVelocity = Vector3.zero
    end
end))
BuloTrackConnection(Player.CharacterAdded:Connect(function(character)
    task.wait(0.2)
    if not BuloHubUnloaded and FlingV2.Active then fixFlingV2Joints(character) end
end))
local function createAutoEscapeRawPathA()
    return {
    {t=0.012, x=320.178, y=3.923, z=-184.434, lx=-1.000, ly=-0.000, lz=-0.004, fly=true},
    {t=0.677, x=320.178, y=3.392, z=-184.434, lx=-1.000, ly=-0.000, lz=-0.004, fly=true},
    {t=0.788, x=320.178, y=2.886, z=-184.434, lx=-1.000, ly=-0.000, lz=-0.004, fly=true},
    {t=1.101, x=320.191, y=2.721, z=-185.022, lx=-0.993, ly=-0.000, lz=-0.116, fly=true},
    {t=1.155, x=320.238, y=2.774, z=-187.112, lx=-0.935, ly=-0.000, lz=-0.355, fly=true},
    {t=1.205, x=320.286, y=2.720, z=-189.247, lx=-0.819, ly=-0.000, lz=-0.573, fly=true},
    {t=1.260, x=320.319, y=2.721, z=-190.717, lx=-0.629, ly=-0.000, lz=-0.778, fly=true},
    {t=1.316, x=320.390, y=2.721, z=-193.868, lx=-0.494, ly=-0.000, lz=-0.869, fly=true},
    {t=1.470, x=320.406, y=2.721, z=-194.570, lx=-0.448, ly=-0.000, lz=-0.894, fly=true},
    {t=1.667, x=320.421, y=2.476, z=-195.257, lx=-0.406, ly=-0.000, lz=-0.914, fly=true},
    {t=1.724, x=320.462, y=2.401, z=-197.088, lx=-0.333, ly=-0.000, lz=-0.943, fly=true},
    {t=1.910, x=320.464, y=1.851, z=-197.146, lx=-0.333, ly=-0.000, lz=-0.943, fly=true},
    {t=1.963, x=320.464, y=0.401, z=-197.146, lx=-0.333, ly=-0.000, lz=-0.943, fly=true},
    {t=2.019, x=320.464, y=-0.345, z=-197.146, lx=-0.333, ly=-0.000, lz=-0.943, fly=true},
    {t=2.080, x=320.464, y=-2.435, z=-197.146, lx=-0.333, ly=-0.000, lz=-0.943, fly=true},
    {t=2.136, x=320.464, y=-4.335, z=-197.146, lx=-0.333, ly=-0.000, lz=-0.943, fly=true},
    {t=2.196, x=320.315, y=-5.804, z=-197.115, lx=-0.367, ly=-0.000, lz=-0.930, fly=true},
    {t=2.250, x=318.996, y=-6.917, z=-196.559, lx=-0.590, ly=-0.000, lz=-0.807, fly=true},
    {t=2.305, x=317.892, y=-7.960, z=-195.678, lx=-0.758, ly=-0.000, lz=-0.652, fly=true},
    {t=2.358, x=316.898, y=-8.991, z=-194.692, lx=-0.886, ly=-0.000, lz=-0.463, fly=true},
    {t=2.411, x=316.062, y=-9.981, z=-193.643, lx=-0.968, ly=-0.000, lz=-0.250, fly=true},
    {t=2.461, x=315.416, y=-10.796, z=-192.514, lx=-0.999, ly=-0.000, lz=-0.032, fly=true},
    {t=2.517, x=314.649, y=-10.899, z=-190.719, lx=-0.978, ly=-0.000, lz=0.208, fly=true},
    {t=2.575, x=313.928, y=-10.970, z=-188.701, lx=-0.904, ly=-0.000, lz=0.427, fly=true},
    {t=2.626, x=313.354, y=-11.032, z=-186.933, lx=-0.824, ly=-0.000, lz=0.566, fly=true},
    {t=2.684, x=312.730, y=-11.100, z=-184.992, lx=-0.734, ly=-0.000, lz=0.679, fly=true},
    {t=2.734, x=312.145, y=-11.164, z=-183.173, lx=-0.660, ly=-0.000, lz=0.751, fly=true},
    {t=2.785, x=311.615, y=-11.222, z=-181.539, lx=-0.600, ly=-0.000, lz=0.800, fly=true},
    {t=2.837, x=311.007, y=-11.290, z=-179.694, lx=-0.544, ly=-0.000, lz=0.839, fly=true},
    {t=2.893, x=310.468, y=-11.348, z=-178.073, lx=-0.504, ly=-0.000, lz=0.864, fly=true},
    {t=2.945, x=309.804, y=-11.440, z=-176.088, lx=-0.459, ly=-0.000, lz=0.888, fly=true},
    {t=2.999, x=309.211, y=-11.512, z=-174.300, lx=-0.428, ly=-0.000, lz=0.904, fly=true},
    {t=3.056, x=308.586, y=-11.583, z=-172.248, lx=-0.397, ly=-0.000, lz=0.918, fly=true},
    {t=3.111, x=308.087, y=-11.658, z=-170.394, lx=-0.367, ly=-0.000, lz=0.930, fly=true},
    {t=3.167, x=307.581, y=-11.730, z=-168.395, lx=-0.339, ly=-0.000, lz=0.941, fly=true},
    {t=3.224, x=307.104, y=-11.798, z=-166.483, lx=-0.319, ly=-0.000, lz=0.948, fly=true},
    {t=3.278, x=306.620, y=-11.863, z=-164.510, lx=-0.302, ly=-0.000, lz=0.953, fly=true},
    {t=3.329, x=306.188, y=-11.931, z=-162.718, lx=-0.288, ly=-0.000, lz=0.958, fly=true},
    {t=3.382, x=305.769, y=-11.992, z=-160.962, lx=-0.277, ly=-0.000, lz=0.961, fly=true},
    {t=3.459, x=305.314, y=-12.190, z=-159.020, lx=-0.258, ly=-0.000, lz=0.966, fly=true},
    {t=3.516, x=304.641, y=-12.353, z=-156.119, lx=-0.248, ly=-0.000, lz=0.969, fly=true},
    {t=3.569, x=304.240, y=-12.415, z=-154.376, lx=-0.243, ly=-0.000, lz=0.970, fly=true},
    {t=3.623, x=303.778, y=-12.510, z=-152.348, lx=-0.238, ly=-0.000, lz=0.971, fly=true},
    {t=3.680, x=303.330, y=-12.581, z=-150.382, lx=-0.234, ly=-0.000, lz=0.972, fly=true},
    {t=3.737, x=302.843, y=-12.687, z=-148.234, lx=-0.231, ly=-0.000, lz=0.973, fly=true},
    {t=3.792, x=302.445, y=-12.759, z=-146.434, lx=-0.227, ly=-0.000, lz=0.974, fly=true},
    {t=3.844, x=302.049, y=-12.823, z=-144.549, lx=-0.223, ly=-0.000, lz=0.975, fly=true},
    {t=3.895, x=301.720, y=-12.895, z=-142.929, lx=-0.217, ly=-0.000, lz=0.976, fly=true},
    {t=3.952, x=301.331, y=-12.994, z=-140.947, lx=-0.211, ly=-0.000, lz=0.978, fly=true},
    {t=4.003, x=300.942, y=-13.103, z=-138.886, lx=-0.204, ly=-0.000, lz=0.979, fly=true},
    {t=4.056, x=300.610, y=-13.178, z=-137.063, lx=-0.198, ly=-0.000, lz=0.980, fly=true},
    {t=4.113, x=300.249, y=-13.259, z=-135.058, lx=-0.193, ly=-0.000, lz=0.981, fly=true},
    {t=4.169, x=299.892, y=-13.341, z=-133.078, lx=-0.189, ly=-0.000, lz=0.982, fly=true},
    {t=4.221, x=299.548, y=-13.423, z=-131.222, lx=-0.188, ly=-0.000, lz=0.982, fly=true},
    {t=4.279, x=299.106, y=-13.494, z=-129.170, lx=-0.194, ly=-0.000, lz=0.981, fly=true},
    {t=4.336, x=298.592, y=-13.569, z=-127.082, lx=-0.204, ly=-0.000, lz=0.979, fly=true},
    {t=4.392, x=298.115, y=-13.634, z=-125.191, lx=-0.213, ly=-0.000, lz=0.977, fly=true},
    {t=4.446, x=297.645, y=-13.716, z=-123.332, lx=-0.221, ly=-0.000, lz=0.975, fly=true},
    {t=4.518, x=297.043, y=-13.842, z=-120.955, lx=-0.228, ly=-0.000, lz=0.974, fly=true},
    {t=4.570, x=296.541, y=-13.937, z=-118.967, lx=-0.232, ly=-0.000, lz=0.973, fly=true},
    {t=4.631, x=296.045, y=-14.009, z=-117.008, lx=-0.235, ly=-0.000, lz=0.972, fly=true},
    {t=4.687, x=295.493, y=-14.097, z=-114.825, lx=-0.238, ly=-0.000, lz=0.971, fly=true},
    {t=4.738, x=295.056, y=-14.193, z=-113.098, lx=-0.240, ly=-0.000, lz=0.971, fly=true},
    {t=4.792, x=294.573, y=-14.295, z=-111.186, lx=-0.241, ly=-0.000, lz=0.971, fly=true},
    {t=4.852, x=294.110, y=-14.050, z=-109.357, lx=-0.242, ly=-0.000, lz=0.970, fly=true},
    {t=4.909, x=293.718, y=-13.041, z=-107.805, lx=-0.243, ly=-0.000, lz=0.970, fly=true},
    {t=4.969, x=293.410, y=-12.231, z=-106.587, lx=-0.243, ly=-0.000, lz=0.970, fly=true},
    {t=5.029, x=292.965, y=-11.224, z=-104.827, lx=-0.244, ly=-0.000, lz=0.970, fly=true},
    {t=5.081, x=292.801, y=-11.062, z=-104.178, lx=-0.244, ly=-0.000, lz=0.970, fly=true},
    {t=5.132, x=292.100, y=-10.841, z=-101.409, lx=-0.245, ly=-0.000, lz=0.970, fly=true},
    {t=5.185, x=291.647, y=-10.899, z=-99.616, lx=-0.245, ly=-0.000, lz=0.970, fly=true},
    {t=5.238, x=291.177, y=-10.960, z=-97.756, lx=-0.245, ly=-0.000, lz=0.970, fly=true},
    {t=5.295, x=290.681, y=-11.028, z=-95.802, lx=-0.245, ly=-0.000, lz=0.970, fly=true},
    {t=5.353, x=290.143, y=-11.100, z=-93.748, lx=-0.247, ly=-0.000, lz=0.969, fly=true},
    {t=5.405, x=289.639, y=-11.158, z=-91.945, lx=-0.252, ly=-0.000, lz=0.968, fly=true},
    {t=5.457, x=289.106, y=-11.219, z=-90.098, lx=-0.257, ly=-0.000, lz=0.966, fly=true},
    {t=5.529, x=288.419, y=-11.400, z=-87.722, lx=-0.264, ly=-0.000, lz=0.964, fly=true},
    {t=5.581, x=287.877, y=-11.458, z=-85.844, lx=-0.267, ly=-0.000, lz=0.964, fly=true},
    {t=5.633, x=287.380, y=-11.522, z=-84.051, lx=-0.266, ly=-0.000, lz=0.964, fly=true},
    {t=5.688, x=286.872, y=-11.590, z=-82.069, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=5.738, x=286.508, y=-11.170, z=-80.588, lx=-0.258, ly=-0.000, lz=0.966, fly=true},
    {t=5.832, x=286.141, y=-10.487, z=-79.086, lx=-0.249, ly=-0.000, lz=0.969, fly=true},
    {t=5.887, x=285.579, y=-8.947, z=-76.781, lx=-0.246, ly=-0.000, lz=0.969, fly=true},
    {t=5.939, x=285.216, y=-8.394, z=-75.285, lx=-0.244, ly=-0.000, lz=0.970, fly=true},
    {t=5.990, x=284.790, y=-8.446, z=-73.535, lx=-0.242, ly=-0.000, lz=0.970, fly=true},
    {t=6.045, x=284.323, y=-8.531, z=-71.615, lx=-0.241, ly=-0.000, lz=0.971, fly=true},
    {t=6.096, x=283.865, y=-8.599, z=-69.729, lx=-0.240, ly=-0.000, lz=0.971, fly=true},
    {t=6.149, x=283.421, y=-8.653, z=-67.903, lx=-0.239, ly=-0.000, lz=0.971, fly=true},
    {t=6.202, x=282.988, y=-8.715, z=-66.122, lx=-0.239, ly=-0.000, lz=0.971, fly=true},
    {t=6.252, x=282.576, y=-8.773, z=-64.425, lx=-0.238, ly=-0.000, lz=0.971, fly=true},
    {t=6.302, x=282.139, y=-8.830, z=-62.629, lx=-0.238, ly=-0.000, lz=0.971, fly=true},
    {t=6.354, x=281.698, y=-8.895, z=-60.815, lx=-0.237, ly=-0.000, lz=0.971, fly=true},
    {t=6.404, x=281.272, y=-8.953, z=-59.063, lx=-0.237, ly=-0.000, lz=0.971, fly=true},
    {t=6.458, x=280.844, y=-9.025, z=-57.302, lx=-0.237, ly=-0.000, lz=0.971, fly=true},
    {t=6.530, x=280.221, y=-9.157, z=-54.740, lx=-0.237, ly=-0.000, lz=0.972, fly=true},
    {t=6.585, x=279.757, y=-9.229, z=-52.828, lx=-0.237, ly=-0.000, lz=0.972, fly=true},
    {t=6.648, x=279.268, y=-9.324, z=-50.817, lx=-0.237, ly=-0.000, lz=0.972, fly=true},
    {t=6.701, x=278.746, y=-9.393, z=-48.671, lx=-0.237, ly=-0.000, lz=0.972, fly=true},
    {t=6.753, x=278.306, y=-9.454, z=-46.861, lx=-0.237, ly=-0.000, lz=0.972, fly=true},
    {t=6.806, x=277.858, y=-9.508, z=-45.017, lx=-0.237, ly=-0.000, lz=0.972, fly=true},
    {t=6.856, x=277.426, y=-9.563, z=-43.240, lx=-0.237, ly=-0.000, lz=0.972, fly=true},
    {t=6.907, x=276.996, y=-9.624, z=-41.471, lx=-0.237, ly=-0.000, lz=0.972, fly=true},
    {t=6.963, x=276.531, y=-9.682, z=-39.560, lx=-0.237, ly=-0.000, lz=0.972, fly=true},
    {t=7.016, x=276.084, y=-9.743, z=-37.718, lx=-0.237, ly=-0.000, lz=0.972, fly=true},
    {t=7.100, x=275.660, y=-9.818, z=-35.975, lx=-0.237, ly=-0.000, lz=0.972, fly=true},
    {t=7.152, x=274.897, y=-10.053, z=-32.835, lx=-0.236, ly=-0.000, lz=0.972, fly=true},
    {t=7.203, x=274.464, y=-10.118, z=-31.055, lx=-0.236, ly=-0.000, lz=0.972, fly=true},
    {t=7.258, x=273.996, y=-10.176, z=-29.131, lx=-0.236, ly=-0.000, lz=0.972, fly=true},
    {t=7.309, x=273.584, y=-10.230, z=-27.434, lx=-0.236, ly=-0.000, lz=0.972, fly=true},
    {t=7.360, x=273.129, y=-10.292, z=-25.565, lx=-0.236, ly=-0.000, lz=0.972, fly=true},
    {t=7.413, x=272.672, y=-10.343, z=-23.685, lx=-0.236, ly=-0.000, lz=0.972, fly=true},
    {t=7.469, x=272.213, y=-10.408, z=-21.793, lx=-0.236, ly=-0.000, lz=0.972, fly=true},
    {t=7.529, x=271.843, y=-9.539, z=-20.270, lx=-0.236, ly=-0.000, lz=0.972, fly=true},
    {t=7.585, x=271.492, y=-8.579, z=-18.830, lx=-0.236, ly=-0.000, lz=0.972, fly=true},
    {t=7.640, x=271.159, y=-7.660, z=-17.459, lx=-0.236, ly=-0.000, lz=0.972, fly=true},
    {t=7.698, x=270.797, y=-7.106, z=-15.970, lx=-0.236, ly=-0.000, lz=0.972, fly=true},
    {t=7.751, x=270.326, y=-7.170, z=-14.030, lx=-0.236, ly=-0.000, lz=0.972, fly=true},
    {t=7.809, x=269.839, y=-7.235, z=-12.029, lx=-0.236, ly=-0.000, lz=0.972, fly=true},
    {t=7.861, x=269.419, y=-7.303, z=-10.294, lx=-0.236, ly=-0.000, lz=0.972, fly=true},
    {t=7.917, x=268.916, y=-7.361, z=-8.214, lx=-0.236, ly=-0.000, lz=0.972, fly=true},
    {t=7.969, x=268.477, y=-7.419, z=-6.397, lx=-0.236, ly=-0.000, lz=0.972, fly=true},
    {t=8.024, x=268.018, y=-7.477, z=-4.498, lx=-0.236, ly=-0.000, lz=0.972, fly=true},
    {t=8.163, x=267.748, y=-7.957, z=-3.381, lx=-0.235, ly=-0.000, lz=0.972, fly=true},
    {t=8.329, x=267.122, y=-8.182, z=-0.792, lx=-0.235, ly=-0.000, lz=0.972, fly=true},
    {t=8.476, x=266.455, y=-8.645, z=1.966, lx=-0.235, ly=-0.000, lz=0.972, fly=true},
    {t=8.551, x=265.621, y=-8.171, z=5.378, lx=-0.238, ly=-0.000, lz=0.971, fly=true},
    {t=8.607, x=264.858, y=-7.958, z=8.483, lx=-0.238, ly=-0.000, lz=0.971, fly=true},
    {t=8.666, x=264.355, y=-8.035, z=10.529, lx=-0.238, ly=-0.000, lz=0.971, fly=true},
    {t=8.740, x=263.796, y=-8.158, z=12.802, lx=-0.238, ly=-0.000, lz=0.971, fly=true},
    {t=8.808, x=263.209, y=-8.440, z=15.189, lx=-0.239, ly=-0.000, lz=0.971, fly=true},
    {t=8.863, x=262.633, y=-8.556, z=17.532, lx=-0.239, ly=-0.000, lz=0.971, fly=true},
    {t=8.918, x=262.166, y=-8.651, z=19.443, lx=-0.238, ly=-0.000, lz=0.971, fly=true},
    {t=8.976, x=261.678, y=-8.743, z=21.538, lx=-0.235, ly=-0.000, lz=0.972, fly=true},
    {t=9.040, x=261.199, y=-8.846, z=23.727, lx=-0.228, ly=-0.000, lz=0.974, fly=true},
    {t=9.092, x=260.792, y=-8.927, z=25.708, lx=-0.222, ly=-0.000, lz=0.975, fly=true},
    {t=9.155, x=260.369, y=-9.033, z=27.843, lx=-0.214, ly=-0.000, lz=0.977, fly=true},
    {t=9.213, x=259.956, y=-9.128, z=30.000, lx=-0.207, ly=-0.000, lz=0.978, fly=true},
    {t=9.272, x=259.636, y=-8.811, z=31.756, lx=-0.199, ly=-0.000, lz=0.980, fly=true},
    {t=9.336, x=259.352, y=-7.818, z=33.370, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=9.390, x=259.083, y=-6.823, z=34.914, lx=-0.187, ly=-0.000, lz=0.982, fly=true},
    {t=9.442, x=258.862, y=-6.003, z=36.189, lx=-0.183, ly=-0.000, lz=0.983, fly=true},
    {t=9.527, x=258.707, y=-5.414, z=37.086, lx=-0.182, ly=-0.000, lz=0.983, fly=true},
    {t=9.620, x=258.259, y=-4.392, z=39.668, lx=-0.175, ly=-0.000, lz=0.984, fly=true},
    {t=9.686, x=257.587, y=-4.501, z=43.452, lx=-0.178, ly=-0.000, lz=0.984, fly=true},
    {t=9.745, x=257.100, y=-4.563, z=45.917, lx=-0.182, ly=-0.000, lz=0.983, fly=true},
    {t=9.795, x=256.737, y=-4.648, z=47.710, lx=-0.186, ly=-0.000, lz=0.983, fly=true},
    {t=9.848, x=256.355, y=-4.709, z=49.593, lx=-0.189, ly=-0.000, lz=0.982, fly=true},
    {t=9.904, x=255.957, y=-4.791, z=51.554, lx=-0.191, ly=-0.000, lz=0.982, fly=true},
    {t=9.960, x=255.553, y=-4.862, z=53.541, lx=-0.193, ly=-0.000, lz=0.981, fly=true},
    {t=10.017, x=255.147, y=-4.944, z=55.514, lx=-0.195, ly=-0.000, lz=0.981, fly=true},
    {t=10.074, x=254.759, y=-5.026, z=57.402, lx=-0.196, ly=-0.000, lz=0.981, fly=true},
    {t=10.126, x=254.346, y=-5.101, z=59.412, lx=-0.198, ly=-0.000, lz=0.980, fly=true},
    {t=10.179, x=253.981, y=-5.162, z=61.188, lx=-0.198, ly=-0.000, lz=0.980, fly=true},
    {t=10.233, x=253.578, y=-5.224, z=63.146, lx=-0.199, ly=-0.000, lz=0.980, fly=true},
    {t=10.284, x=253.210, y=-5.281, z=64.936, lx=-0.199, ly=-0.000, lz=0.980, fly=true},
    {t=10.338, x=252.814, y=-5.343, z=66.863, lx=-0.200, ly=-0.000, lz=0.980, fly=true},
    {t=10.393, x=252.419, y=-5.401, z=68.783, lx=-0.200, ly=-0.000, lz=0.980, fly=true},
    {t=10.448, x=252.021, y=-5.459, z=70.719, lx=-0.200, ly=-0.000, lz=0.980, fly=true},
    {t=10.500, x=251.641, y=-5.516, z=72.565, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=10.556, x=251.246, y=-5.588, z=74.487, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=10.617, x=250.848, y=-5.745, z=76.421, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=10.671, x=250.472, y=-5.833, z=78.252, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=10.727, x=250.002, y=-5.922, z=80.537, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=10.780, x=249.620, y=-5.987, z=82.396, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=10.832, x=249.229, y=-6.041, z=84.297, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=10.882, x=248.875, y=-6.102, z=86.017, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=10.947, x=248.701, y=-6.422, z=86.864, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=10.997, x=248.022, y=-6.494, z=90.166, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=11.049, x=247.633, y=-6.549, z=92.055, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=11.103, x=247.227, y=-6.617, z=94.032, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=11.157, x=246.851, y=-6.668, z=95.859, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=11.211, x=246.471, y=-6.729, z=97.708, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=11.267, x=246.058, y=-6.794, z=99.718, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=11.318, x=245.698, y=-6.848, z=101.469, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=11.371, x=245.302, y=-6.906, z=103.393, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=11.425, x=244.914, y=-6.964, z=105.283, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=11.479, x=244.535, y=-7.015, z=107.122, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=11.529, x=244.172, y=-7.080, z=108.889, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=11.583, x=243.780, y=-7.141, z=110.796, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=11.634, x=243.404, y=-7.308, z=112.624, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=11.693, x=243.015, y=-7.369, z=114.517, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=11.766, x=242.911, y=-7.403, z=115.024, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=11.816, x=242.041, y=-7.925, z=119.253, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=11.869, x=241.649, y=-7.989, z=121.160, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=11.938, x=241.408, y=-8.241, z=122.329, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=11.990, x=240.739, y=-8.303, z=125.584, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=12.043, x=240.357, y=-8.354, z=127.444, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=12.104, x=239.933, y=-8.419, z=129.507, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=12.154, x=239.556, y=-8.476, z=131.336, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=12.207, x=239.183, y=-8.528, z=133.152, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=12.258, x=238.827, y=-8.589, z=134.883, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=12.310, x=238.438, y=-8.643, z=136.776, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=12.363, x=238.050, y=-8.711, z=138.660, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=12.420, x=237.626, y=-8.895, z=140.722, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=12.472, x=237.246, y=-8.947, z=142.574, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=12.526, x=236.855, y=-9.004, z=144.472, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=12.577, x=236.487, y=-9.056, z=146.263, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=12.632, x=236.099, y=-9.120, z=148.152, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=12.682, x=235.768, y=-9.175, z=149.760, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=12.733, x=235.370, y=-9.233, z=151.693, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=12.821, x=235.061, y=-9.284, z=153.199, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=12.882, x=234.300, y=-9.679, z=156.899, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=12.939, x=233.852, y=-9.788, z=159.078, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=12.992, x=233.449, y=-9.846, z=161.037, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=13.043, x=233.088, y=-9.897, z=162.792, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=13.094, x=232.714, y=-9.955, z=164.615, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=13.150, x=232.320, y=-10.037, z=166.526, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=13.204, x=231.926, y=-10.094, z=168.443, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=13.260, x=231.520, y=-10.152, z=170.419, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=13.315, x=231.131, y=-10.210, z=172.312, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=13.368, x=230.739, y=-10.272, z=174.219, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=13.423, x=230.341, y=-10.330, z=176.152, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=13.478, x=229.950, y=-10.387, z=178.054, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=13.534, x=229.554, y=-10.452, z=179.978, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=13.585, x=229.162, y=-10.513, z=181.888, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=13.636, x=228.799, y=-10.612, z=183.653, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=13.691, x=228.414, y=-10.674, z=185.523, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=13.747, x=228.014, y=-10.731, z=187.470, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=13.802, x=227.605, y=-10.789, z=189.457, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=13.857, x=227.265, y=-10.851, z=191.113, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=13.917, x=227.160, y=-10.871, z=191.623, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=13.971, x=226.438, y=-11.355, z=195.134, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=14.027, x=225.933, y=-11.457, z=197.591, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=14.078, x=225.555, y=-11.511, z=199.427, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=14.130, x=225.180, y=-11.569, z=201.250, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=14.187, x=224.933, y=-11.232, z=202.451, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=14.241, x=224.581, y=-10.067, z=204.167, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=14.293, x=224.299, y=-9.158, z=205.534, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=14.348, x=224.020, y=-8.256, z=206.893, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=14.400, x=223.665, y=-8.153, z=208.619, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=14.450, x=223.290, y=-8.207, z=210.445, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=14.506, x=222.893, y=-8.309, z=212.374, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=14.561, x=222.498, y=-8.364, z=214.294, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=14.631, x=221.996, y=-8.483, z=216.737, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=14.686, x=221.584, y=-8.538, z=218.739, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=14.739, x=221.209, y=-8.595, z=220.564, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=14.790, x=220.845, y=-8.647, z=222.336, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=14.840, x=220.477, y=-8.704, z=224.121, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=14.896, x=220.087, y=-8.762, z=226.022, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=14.948, x=219.760, y=-8.827, z=227.611, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=15.000, x=219.331, y=-8.895, z=229.694, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=15.053, x=218.937, y=-8.950, z=231.613, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=15.106, x=218.654, y=-8.225, z=232.991, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=15.159, x=218.381, y=-7.347, z=234.316, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=15.212, x=218.113, y=-6.554, z=235.621, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=15.263, x=217.734, y=-6.589, z=237.465, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=15.315, x=217.360, y=-6.640, z=239.282, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=15.368, x=216.977, y=-6.702, z=241.142, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=15.420, x=216.585, y=-6.760, z=243.050, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=15.474, x=216.215, y=-6.814, z=244.850, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=15.526, x=215.838, y=-6.862, z=246.685, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=15.578, x=215.459, y=-6.909, z=248.526, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=15.646, x=214.966, y=-7.097, z=250.923, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=15.697, x=214.591, y=-7.158, z=252.746, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=15.752, x=214.189, y=-7.213, z=254.703, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=15.809, x=213.786, y=-7.274, z=256.662, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=15.864, x=213.383, y=-7.335, z=258.623, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=15.917, x=213.014, y=-7.393, z=260.417, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=15.978, x=212.616, y=-7.458, z=262.354, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=16.033, x=212.170, y=-7.533, z=264.520, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=16.085, x=211.793, y=-7.580, z=266.354, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=16.138, x=211.411, y=-7.638, z=268.212, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=16.193, x=211.007, y=-7.693, z=270.178, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=16.246, x=210.628, y=-7.751, z=272.018, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=16.301, x=210.244, y=-7.809, z=273.887, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=16.357, x=209.836, y=-7.867, z=275.870, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=16.414, x=209.430, y=-7.931, z=277.843, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=16.468, x=209.037, y=-7.996, z=279.755, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=16.520, x=208.661, y=-8.051, z=281.586, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=16.575, x=208.270, y=-8.112, z=283.486, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=16.646, x=207.758, y=-8.235, z=285.978, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=16.696, x=207.378, y=-8.299, z=287.826, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=16.750, x=206.987, y=-8.361, z=289.727, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=16.803, x=206.601, y=-8.418, z=291.604, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=16.859, x=206.273, y=-7.924, z=293.197, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=16.914, x=205.992, y=-7.013, z=294.567, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=16.969, x=205.706, y=-6.095, z=295.954, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=17.023, x=205.420, y=-5.203, z=297.348, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=17.079, x=205.130, y=-4.275, z=298.755, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=17.132, x=204.826, y=-3.958, z=300.233, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=17.188, x=204.404, y=-4.021, z=302.286, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=17.242, x=204.013, y=-4.072, z=304.189, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=17.295, x=203.631, y=-4.137, z=306.048, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=17.345, x=203.271, y=-4.185, z=307.797, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=17.400, x=202.865, y=-4.256, z=309.774, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=17.454, x=202.494, y=-4.314, z=311.579, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=17.508, x=202.101, y=-4.379, z=313.486, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=17.558, x=201.735, y=-4.444, z=315.266, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=17.615, x=201.330, y=-4.508, z=317.236, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=17.666, x=200.952, y=-4.580, z=319.074, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=17.720, x=200.562, y=-4.641, z=320.973, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=17.775, x=200.167, y=-4.723, z=322.894, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=17.826, x=199.861, y=-4.265, z=324.384, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=17.883, x=199.567, y=-3.319, z=325.811, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=17.936, x=199.283, y=-2.503, z=327.193, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=17.986, x=199.028, y=-1.685, z=328.434, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=18.050, x=198.640, y=-1.691, z=330.319, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=18.105, x=198.159, y=-1.796, z=332.660, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=18.155, x=197.793, y=-1.857, z=334.436, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=18.292, x=197.505, y=-2.348, z=335.839, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=18.368, x=196.619, y=-2.590, z=340.150, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=18.420, x=196.102, y=-2.661, z=342.661, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=18.471, x=195.739, y=-2.712, z=344.429, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=18.525, x=195.341, y=-2.770, z=346.359, lx=-0.201, ly=-0.000, lz=0.979, fly=true},
    {t=18.576, x=194.959, y=-2.825, z=348.153, lx=-0.203, ly=-0.000, lz=0.979, fly=true},
    {t=18.632, x=194.510, y=-2.890, z=350.081, lx=-0.208, ly=-0.000, lz=0.978, fly=true},
    {t=18.688, x=194.017, y=-2.978, z=352.039, lx=-0.217, ly=-0.000, lz=0.976, fly=true},
    {t=18.741, x=193.526, y=-3.029, z=353.890, lx=-0.224, ly=-0.000, lz=0.975, fly=true},
    {t=18.794, x=193.020, y=-3.094, z=355.757, lx=-0.232, ly=-0.000, lz=0.973, fly=true},
    {t=18.848, x=192.505, y=-3.145, z=357.633, lx=-0.238, ly=-0.000, lz=0.971, fly=true},
    {t=18.902, x=191.995, y=-3.200, z=359.488, lx=-0.243, ly=-0.000, lz=0.970, fly=true},
    {t=18.953, x=191.520, y=-3.257, z=361.213, lx=-0.247, ly=-0.000, lz=0.969, fly=true},
    {t=19.008, x=191.005, y=-3.309, z=363.091, lx=-0.250, ly=-0.000, lz=0.968, fly=true},
    {t=19.067, x=190.509, y=-3.380, z=364.944, lx=-0.252, ly=-0.000, lz=0.968, fly=true},
    {t=19.121, x=189.961, y=-3.458, z=367.033, lx=-0.252, ly=-0.000, lz=0.968, fly=true},
    {t=19.173, x=189.490, y=-3.506, z=368.843, lx=-0.252, ly=-0.000, lz=0.968, fly=true},
    {t=19.225, x=189.025, y=-3.557, z=370.633, lx=-0.252, ly=-0.000, lz=0.968, fly=true},
    {t=19.278, x=188.548, y=-3.612, z=372.471, lx=-0.252, ly=-0.000, lz=0.968, fly=true},
    {t=19.331, x=188.059, y=-3.670, z=374.354, lx=-0.252, ly=-0.000, lz=0.968, fly=true},
    {t=19.384, x=187.588, y=-3.717, z=376.166, lx=-0.252, ly=-0.000, lz=0.968, fly=true},
    {t=19.436, x=187.250, y=-3.785, z=377.468, lx=-0.252, ly=-0.000, lz=0.968, fly=true},
    {t=19.519, x=186.935, y=-4.259, z=378.683, lx=-0.252, ly=-0.000, lz=0.968, fly=true},
    {t=19.599, x=185.790, y=-4.664, z=383.084, lx=-0.252, ly=-0.000, lz=0.968, fly=true},
    {t=19.674, x=184.896, y=-4.882, z=386.480, lx=-0.253, ly=-0.000, lz=0.967, fly=true},
    {t=19.725, x=184.518, y=-4.967, z=387.901, lx=-0.254, ly=-0.000, lz=0.967, fly=true},
    {t=19.782, x=183.872, y=-5.039, z=390.310, lx=-0.255, ly=-0.000, lz=0.967, fly=true},
    {t=19.834, x=183.391, y=-5.100, z=392.098, lx=-0.256, ly=-0.000, lz=0.967, fly=true},
    {t=19.885, x=182.911, y=-5.151, z=393.861, lx=-0.257, ly=-0.000, lz=0.966, fly=true},
    {t=19.939, x=182.388, y=-5.209, z=395.765, lx=-0.259, ly=-0.000, lz=0.966, fly=true},
    {t=19.990, x=181.896, y=-5.260, z=397.532, lx=-0.261, ly=-0.000, lz=0.965, fly=true},
    {t=20.044, x=181.368, y=-5.325, z=399.405, lx=-0.263, ly=-0.000, lz=0.965, fly=true},
    {t=20.131, x=180.987, y=-5.362, z=400.740, lx=-0.264, ly=-0.000, lz=0.964, fly=true},
    {t=20.184, x=179.942, y=-5.754, z=404.329, lx=-0.273, ly=-0.000, lz=0.962, fly=true},
    {t=20.237, x=179.386, y=-5.809, z=406.170, lx=-0.276, ly=-0.000, lz=0.961, fly=true},
    {t=20.290, x=178.809, y=-5.863, z=408.062, lx=-0.279, ly=-0.000, lz=0.960, fly=true},
    {t=20.341, x=178.283, y=-5.911, z=409.782, lx=-0.281, ly=-0.000, lz=0.960, fly=true},
    {t=20.395, x=177.730, y=-5.965, z=411.591, lx=-0.283, ly=-0.000, lz=0.959, fly=true},
    {t=20.451, x=177.147, y=-6.020, z=413.498, lx=-0.285, ly=-0.000, lz=0.959, fly=true},
    {t=20.502, x=176.729, y=-5.460, z=414.856, lx=-0.287, ly=-0.000, lz=0.958, fly=true},
    {t=20.555, x=176.315, y=-4.549, z=416.192, lx=-0.288, ly=-0.000, lz=0.957, fly=true},
    {t=20.609, x=175.908, y=-3.650, z=417.505, lx=-0.290, ly=-0.000, lz=0.957, fly=true},
    {t=20.680, x=175.229, y=-3.388, z=419.698, lx=-0.292, ly=-0.000, lz=0.956, fly=true},
    {t=20.731, x=174.669, y=-3.431, z=421.501, lx=-0.293, ly=-0.000, lz=0.956, fly=true},
    {t=20.785, x=174.077, y=-3.537, z=423.393, lx=-0.294, ly=-0.000, lz=0.956, fly=true},
    {t=20.839, x=173.493, y=-3.591, z=425.224, lx=-0.296, ly=-0.000, lz=0.955, fly=true},
    {t=20.893, x=172.906, y=-3.646, z=427.041, lx=-0.298, ly=-0.000, lz=0.954, fly=true},
    {t=20.943, x=172.341, y=-3.693, z=428.772, lx=-0.300, ly=-0.000, lz=0.954, fly=true},
    {t=20.994, x=171.763, y=-3.751, z=430.531, lx=-0.303, ly=-0.000, lz=0.953, fly=true},
    {t=21.049, x=171.160, y=-3.833, z=432.358, lx=-0.305, ly=-0.000, lz=0.952, fly=true},
    {t=21.103, x=170.550, y=-3.881, z=434.198, lx=-0.307, ly=-0.000, lz=0.952, fly=true},
    {t=21.155, x=169.945, y=-3.942, z=436.021, lx=-0.308, ly=-0.000, lz=0.951, fly=true},
    {t=21.246, x=168.928, y=-4.412, z=439.089, lx=-0.312, ly=-0.000, lz=0.950, fly=true},
    {t=21.297, x=168.260, y=-4.494, z=441.069, lx=-0.313, ly=-0.000, lz=0.950, fly=true},
    {t=21.351, x=167.651, y=-4.555, z=442.856, lx=-0.315, ly=-0.000, lz=0.949, fly=true},
    {t=21.403, x=167.030, y=-4.606, z=444.636, lx=-0.318, ly=-0.000, lz=0.948, fly=true},
    {t=21.455, x=166.398, y=-4.664, z=446.401, lx=-0.322, ly=-0.000, lz=0.947, fly=true},
    {t=21.508, x=165.757, y=-4.712, z=448.167, lx=-0.325, ly=-0.000, lz=0.946, fly=true},
    {t=21.567, x=165.060, y=-4.780, z=450.054, lx=-0.330, ly=-0.000, lz=0.944, fly=true},
    {t=21.617, x=164.409, y=-4.838, z=451.793, lx=-0.334, ly=-0.000, lz=0.943, fly=true},
    {t=21.683, x=163.562, y=-4.957, z=454.048, lx=-0.339, ly=-0.000, lz=0.941, fly=true},
    {t=21.737, x=162.862, y=-5.022, z=455.910, lx=-0.342, ly=-0.000, lz=0.940, fly=true},
    {t=21.789, x=162.208, y=-5.080, z=457.651, lx=-0.344, ly=-0.000, lz=0.939, fly=true},
    {t=21.840, x=161.676, y=-4.724, z=459.067, lx=-0.345, ly=-0.000, lz=0.939, fly=true},
    {t=21.891, x=161.205, y=-3.858, z=460.320, lx=-0.346, ly=-0.000, lz=0.938, fly=true},
    {t=21.943, x=160.747, y=-3.006, z=461.538, lx=-0.347, ly=-0.000, lz=0.938, fly=true},
    {t=21.997, x=160.259, y=-2.098, z=462.836, lx=-0.348, ly=-0.000, lz=0.937, fly=true},
    {t=22.048, x=159.741, y=-1.555, z=464.215, lx=-0.349, ly=-0.000, lz=0.937, fly=true},
    {t=22.103, x=159.039, y=-1.607, z=466.085, lx=-0.349, ly=-0.000, lz=0.937, fly=true},
    {t=22.154, x=158.401, y=-1.655, z=467.782, lx=-0.350, ly=-0.000, lz=0.937, fly=true},
    {t=22.208, x=157.729, y=-1.706, z=469.570, lx=-0.350, ly=-0.000, lz=0.937, fly=true},
    {t=22.266, x=157.046, y=-1.757, z=471.388, lx=-0.350, ly=-0.000, lz=0.937, fly=true},
    {t=22.318, x=156.319, y=-1.832, z=473.323, lx=-0.351, ly=-0.000, lz=0.936, fly=true},
    {t=22.373, x=155.647, y=-1.883, z=475.112, lx=-0.351, ly=-0.000, lz=0.936, fly=true},
    {t=22.430, x=154.935, y=-2.033, z=477.002, lx=-0.351, ly=-0.000, lz=0.936, fly=true},
    {t=22.481, x=154.261, y=-2.122, z=478.784, lx=-0.352, ly=-0.000, lz=0.936, fly=true},
    {t=22.535, x=153.577, y=-2.176, z=480.589, lx=-0.352, ly=-0.000, lz=0.936, fly=true},
    {t=22.593, x=153.210, y=-2.319, z=481.557, lx=-0.353, ly=-0.000, lz=0.936, fly=true},
    {t=22.648, x=152.107, y=-2.387, z=484.468, lx=-0.353, ly=-0.000, lz=0.936, fly=true},
    {t=22.699, x=151.452, y=-2.439, z=486.196, lx=-0.353, ly=-0.000, lz=0.935, fly=true},
    {t=22.751, x=150.815, y=-2.490, z=487.870, lx=-0.354, ly=-0.000, lz=0.935, fly=true},
    {t=22.812, x=150.114, y=-2.582, z=489.680, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=22.866, x=149.294, y=-2.657, z=491.758, lx=-0.359, ly=-0.000, lz=0.933, fly=true},
    {t=22.918, x=148.594, y=-2.711, z=493.472, lx=-0.362, ly=-0.000, lz=0.932, fly=true},
    {t=22.973, x=147.826, y=-2.776, z=495.294, lx=-0.368, ly=-0.000, lz=0.930, fly=true},
    {t=23.023, x=147.098, y=-2.823, z=496.998, lx=-0.372, ly=-0.000, lz=0.928, fly=true},
    {t=23.074, x=146.427, y=-2.881, z=498.569, lx=-0.376, ly=-0.000, lz=0.927, fly=true},
    {t=23.125, x=145.746, y=-2.728, z=500.162, lx=-0.379, ly=-0.000, lz=0.925, fly=true},
    {t=23.181, x=145.213, y=-1.857, z=501.408, lx=-0.382, ly=-0.000, lz=0.924, fly=true},
    {t=23.236, x=144.636, y=-0.896, z=502.767, lx=-0.384, ly=-0.000, lz=0.923, fly=true},
    {t=23.294, x=143.994, y=-0.463, z=504.308, lx=-0.384, ly=-0.000, lz=0.923, fly=true},
    {t=23.349, x=143.687, y=-0.493, z=505.047, lx=-0.384, ly=-0.000, lz=0.923, fly=true},
    {t=23.418, x=142.955, y=-0.956, z=506.809, lx=-0.384, ly=-0.000, lz=0.923, fly=true},
    {t=23.470, x=141.473, y=-1.085, z=510.421, lx=-0.382, ly=-0.000, lz=0.924, fly=true},
    {t=23.523, x=140.745, y=-1.140, z=512.209, lx=-0.381, ly=-0.000, lz=0.925, fly=true},
    {t=23.577, x=140.039, y=-1.208, z=513.944, lx=-0.380, ly=-0.000, lz=0.925, fly=true},
    {t=23.629, x=139.353, y=-1.273, z=515.630, lx=-0.380, ly=-0.000, lz=0.925, fly=true},
    {t=23.708, x=138.246, y=-1.470, z=518.348, lx=-0.379, ly=-0.000, lz=0.926, fly=true},
    {t=23.762, x=137.516, y=-1.528, z=520.141, lx=-0.378, ly=-0.000, lz=0.926, fly=true},
    {t=23.812, x=136.832, y=-1.579, z=521.822, lx=-0.378, ly=-0.000, lz=0.926, fly=true},
    {t=23.868, x=136.080, y=-1.641, z=523.668, lx=-0.378, ly=-0.000, lz=0.926, fly=true},
    {t=23.923, x=135.337, y=-1.695, z=525.495, lx=-0.378, ly=-0.000, lz=0.926, fly=true},
    {t=23.978, x=134.584, y=-1.753, z=527.344, lx=-0.378, ly=-0.000, lz=0.926, fly=true},
    {t=24.044, x=134.026, y=-1.910, z=528.715, lx=-0.377, ly=-0.000, lz=0.926, fly=true},
    {t=24.098, x=132.963, y=-1.968, z=531.326, lx=-0.377, ly=-0.000, lz=0.926, fly=true},
    {t=24.166, x=132.692, y=-2.380, z=531.992, lx=-0.377, ly=-0.000, lz=0.926, fly=true},
    {t=24.222, x=131.175, y=-2.489, z=535.729, lx=-0.377, ly=-0.000, lz=0.926, fly=true},
    {t=24.276, x=130.448, y=-2.547, z=537.551, lx=-0.375, ly=-0.000, lz=0.927, fly=true},
    {t=24.327, x=129.815, y=-2.342, z=539.141, lx=-0.374, ly=-0.000, lz=0.927, fly=true},
    {t=24.378, x=129.396, y=-1.635, z=540.194, lx=-0.373, ly=-0.000, lz=0.928, fly=true},
    {t=24.431, x=128.849, y=-0.679, z=541.573, lx=-0.373, ly=-0.000, lz=0.928, fly=true},
    {t=24.481, x=128.370, y=0.173, z=542.783, lx=-0.372, ly=-0.000, lz=0.928, fly=true},
    {t=24.536, x=127.721, y=0.458, z=544.427, lx=-0.371, ly=-0.000, lz=0.929, fly=true},
    {t=24.588, x=127.043, y=0.414, z=546.144, lx=-0.370, ly=-0.000, lz=0.929, fly=true},
    {t=24.641, x=126.378, y=0.360, z=547.827, lx=-0.370, ly=-0.000, lz=0.929, fly=true},
    {t=24.706, x=125.501, y=0.244, z=550.047, lx=-0.369, ly=-0.000, lz=0.929, fly=true},
    {t=24.757, x=124.797, y=0.200, z=551.831, lx=-0.369, ly=-0.000, lz=0.930, fly=true},
    {t=24.811, x=124.114, y=0.148, z=553.562, lx=-0.369, ly=-0.000, lz=0.930, fly=true},
    {t=24.863, x=123.438, y=0.091, z=555.295, lx=-0.367, ly=-0.000, lz=0.930, fly=true},
    {t=24.915, x=122.766, y=0.043, z=557.063, lx=-0.365, ly=-0.000, lz=0.931, fly=true},
    {t=24.966, x=122.241, y=-0.035, z=558.470, lx=-0.362, ly=-0.000, lz=0.932, fly=true},
    {t=25.018, x=121.483, y=-0.087, z=560.529, lx=-0.359, ly=-0.000, lz=0.933, fly=true},
    {t=25.070, x=120.841, y=-0.138, z=562.279, lx=-0.356, ly=-0.000, lz=0.934, fly=true},
    {t=25.120, x=120.212, y=-0.182, z=563.996, lx=-0.354, ly=-0.000, lz=0.935, fly=true},
    {t=25.173, x=119.573, y=-0.233, z=565.738, lx=-0.352, ly=-0.000, lz=0.936, fly=true},
    {t=25.226, x=118.913, y=-0.284, z=567.539, lx=-0.351, ly=-0.000, lz=0.936, fly=true},
    {t=25.279, x=118.306, y=-0.362, z=569.196, lx=-0.349, ly=-0.000, lz=0.937, fly=true},
    {t=25.329, x=117.658, y=-0.414, z=570.964, lx=-0.348, ly=-0.000, lz=0.937, fly=true},
    {t=25.385, x=117.017, y=-0.465, z=572.715, lx=-0.348, ly=-0.000, lz=0.938, fly=true},
    {t=25.435, x=116.321, y=-0.529, z=574.612, lx=-0.347, ly=-0.000, lz=0.938, fly=true},
    {t=25.492, x=115.647, y=-0.587, z=576.452, lx=-0.346, ly=-0.000, lz=0.938, fly=true},
    {t=25.544, x=115.076, y=-0.652, z=578.011, lx=-0.346, ly=-0.000, lz=0.938, fly=true},
    {t=25.597, x=114.360, y=-0.727, z=579.963, lx=-0.345, ly=-0.000, lz=0.938, fly=true},
    {t=25.652, x=113.690, y=-0.778, z=581.792, lx=-0.345, ly=-0.000, lz=0.939, fly=true},
    {t=25.710, x=112.962, y=-0.884, z=583.779, lx=-0.345, ly=-0.000, lz=0.939, fly=true},
    {t=25.762, x=112.318, y=-0.931, z=585.535, lx=-0.345, ly=-0.000, lz=0.939, fly=true},
    {t=25.813, x=111.694, y=-0.979, z=587.238, lx=-0.345, ly=-0.000, lz=0.939, fly=true},
    {t=25.867, x=111.021, y=-1.037, z=589.082, lx=-0.344, ly=-0.000, lz=0.939, fly=true},
    {t=25.921, x=110.378, y=-1.091, z=590.913, lx=-0.342, ly=-0.000, lz=0.940, fly=true},
    {t=25.971, x=109.789, y=-1.136, z=592.621, lx=-0.339, ly=-0.000, lz=0.941, fly=true},
    {t=26.023, x=109.186, y=-1.180, z=594.373, lx=-0.337, ly=-0.000, lz=0.942, fly=true},
    {t=26.115, x=108.624, y=-1.524, z=596.006, lx=-0.331, ly=-0.000, lz=0.944, fly=true},
    {t=26.165, x=107.484, y=-1.602, z=599.352, lx=-0.329, ly=-0.000, lz=0.944, fly=true},
    {t=26.220, x=106.868, y=-1.657, z=601.186, lx=-0.327, ly=-0.000, lz=0.945, fly=true},
    {t=26.270, x=106.287, y=-1.708, z=602.920, lx=-0.325, ly=-0.000, lz=0.946, fly=true},
    {t=26.323, x=105.696, y=-1.752, z=604.682, lx=-0.324, ly=-0.000, lz=0.946, fly=true},
    {t=26.374, x=105.108, y=-1.800, z=606.432, lx=-0.323, ly=0.000, lz=0.946, fly=true},
    {t=26.466, x=104.657, y=-1.841, z=607.776, lx=-0.322, ly=-0.000, lz=0.947, fly=true},
    {t=26.519, x=103.391, y=-2.263, z=611.551, lx=-0.320, ly=-0.000, lz=0.947, fly=true},
    {t=26.573, x=102.779, y=-2.318, z=613.376, lx=-0.320, ly=-0.000, lz=0.947, fly=true},
    {t=26.625, x=102.188, y=-2.365, z=615.135, lx=-0.319, ly=-0.000, lz=0.948, fly=true},
    {t=26.679, x=101.588, y=-2.416, z=616.924, lx=-0.319, ly=-0.000, lz=0.948, fly=true},
    {t=26.729, x=101.002, y=-2.498, z=618.672, lx=-0.319, ly=-0.000, lz=0.948, fly=true},
    {t=26.782, x=100.444, y=-2.495, z=620.332, lx=-0.319, ly=-0.000, lz=0.948, fly=true},
    {t=26.835, x=99.961, y=-1.521, z=621.774, lx=-0.319, ly=0.000, lz=0.948, fly=true},
    {t=26.885, x=99.583, y=-0.741, z=622.900, lx=-0.319, ly=-0.000, lz=0.948, fly=true},
    {t=26.937, x=99.159, y=0.149, z=624.164, lx=-0.319, ly=-0.000, lz=0.948, fly=true},
    {t=26.992, x=98.618, y=0.518, z=625.777, lx=-0.319, ly=-0.000, lz=0.948, fly=true},
    {t=27.044, x=98.040, y=0.474, z=627.499, lx=-0.319, ly=-0.000, lz=0.948, fly=true},
    {t=27.148, x=97.335, y=0.119, z=629.600, lx=-0.318, ly=-0.000, lz=0.948, fly=true},
    {t=27.202, x=96.164, y=0.044, z=633.091, lx=-0.318, ly=-0.000, lz=0.948, fly=true},
    {t=27.256, x=95.547, y=-0.010, z=634.927, lx=-0.318, ly=-0.000, lz=0.948, fly=true},
    {t=27.309, x=94.940, y=-0.061, z=636.736, lx=-0.318, ly=-0.000, lz=0.948, fly=true},
    {t=27.363, x=94.336, y=-0.112, z=638.538, lx=-0.318, ly=-0.000, lz=0.948, fly=true},
    {t=27.415, x=93.748, y=-0.157, z=640.290, lx=-0.318, ly=-0.000, lz=0.948, fly=true},
    {t=27.470, x=93.134, y=-0.214, z=642.120, lx=-0.318, ly=-0.000, lz=0.948, fly=true},
    {t=27.526, x=92.485, y=-0.330, z=644.055, lx=-0.318, ly=-0.000, lz=0.948, fly=true},
    {t=27.577, x=91.903, y=-0.381, z=645.790, lx=-0.318, ly=-0.000, lz=0.948, fly=true},
    {t=27.629, x=91.313, y=-0.426, z=647.547, lx=-0.318, ly=-0.000, lz=0.948, fly=true},
    {t=27.682, x=90.700, y=-0.477, z=649.374, lx=-0.318, ly=-0.000, lz=0.948, fly=true},
    {t=27.766, x=90.236, y=-0.845, z=650.757, lx=-0.318, ly=-0.000, lz=0.948, fly=true},
    {t=27.837, x=89.371, y=-1.264, z=653.335, lx=-0.318, ly=-0.000, lz=0.948, fly=true},
    {t=27.891, x=88.178, y=-1.369, z=656.886, lx=-0.318, ly=-0.000, lz=0.948, fly=true},
    {t=27.945, x=87.552, y=-1.420, z=658.743, lx=-0.318, ly=-0.000, lz=0.948, fly=true},
    {t=27.998, x=86.939, y=-1.471, z=660.564, lx=-0.319, ly=-0.000, lz=0.948, fly=true},
    {t=28.052, x=86.336, y=-1.519, z=662.352, lx=-0.319, ly=-0.000, lz=0.948, fly=true},
    {t=28.103, x=85.739, y=-1.563, z=664.121, lx=-0.319, ly=-0.000, lz=0.948, fly=true},
    {t=28.156, x=85.139, y=-1.614, z=665.888, lx=-0.319, ly=-0.000, lz=0.948, fly=true},
    {t=28.207, x=84.564, y=-1.662, z=667.571, lx=-0.320, ly=-0.000, lz=0.947, fly=true},
    {t=28.269, x=83.921, y=-1.751, z=669.438, lx=-0.321, ly=-0.000, lz=0.947, fly=true},
    {t=28.321, x=83.200, y=-1.815, z=671.506, lx=-0.323, ly=-0.000, lz=0.946, fly=true},
    {t=28.374, x=82.578, y=-1.863, z=673.281, lx=-0.324, ly=-0.000, lz=0.946, fly=true},
    {t=28.424, x=81.990, y=-1.904, z=674.961, lx=-0.325, ly=-0.000, lz=0.946, fly=true},
    {t=28.477, x=81.381, y=-1.958, z=676.700, lx=-0.326, ly=-0.000, lz=0.945, fly=true},
    {t=28.528, x=80.818, y=-1.999, z=678.308, lx=-0.327, ly=-0.000, lz=0.945, fly=true},
    {t=28.579, x=80.146, y=-2.129, z=680.223, lx=-0.328, ly=-0.000, lz=0.945, fly=true},
    {t=28.629, x=79.557, y=-2.183, z=681.876, lx=-0.329, ly=-0.000, lz=0.944, fly=true},
    {t=28.681, x=78.913, y=-2.228, z=683.655, lx=-0.331, ly=-0.000, lz=0.944, fly=true},
    {t=28.733, x=78.258, y=-2.326, z=685.432, lx=-0.335, ly=-0.000, lz=0.942, fly=true},
    {t=28.787, x=77.599, y=-2.371, z=687.200, lx=-0.337, ly=-0.000, lz=0.941, fly=true},
    {t=28.840, x=76.954, y=-2.425, z=688.930, lx=-0.340, ly=-0.000, lz=0.941, fly=true},
    {t=28.908, x=76.626, y=-2.708, z=689.804, lx=-0.344, ly=-0.000, lz=0.939, fly=true},
    {t=28.960, x=75.361, y=-2.790, z=693.164, lx=-0.346, ly=-0.000, lz=0.938, fly=true},
    {t=29.012, x=74.720, y=-2.834, z=694.862, lx=-0.347, ly=-0.000, lz=0.938, fly=true},
    {t=29.065, x=74.031, y=-2.882, z=696.688, lx=-0.348, ly=-0.000, lz=0.937, fly=true},
    {t=29.144, x=73.573, y=-3.212, z=697.902, lx=-0.350, ly=-0.000, lz=0.937, fly=true},
    {t=29.194, x=72.348, y=-3.280, z=701.151, lx=-0.351, ly=-0.000, lz=0.936, fly=true},
    {t=29.248, x=71.748, y=-3.420, z=702.742, lx=-0.351, ly=-0.000, lz=0.936, fly=true},
    {t=29.303, x=70.948, y=-3.495, z=704.861, lx=-0.352, ly=-0.000, lz=0.936, fly=true},
    {t=29.353, x=70.293, y=-3.546, z=706.587, lx=-0.352, ly=-0.000, lz=0.936, fly=true},
    {t=29.407, x=69.607, y=-3.600, z=708.351, lx=-0.354, ly=-0.000, lz=0.935, fly=true},
    {t=29.461, x=68.872, y=-3.651, z=710.195, lx=-0.357, ly=-0.000, lz=0.934, fly=true},
    {t=29.516, x=68.136, y=-3.709, z=711.993, lx=-0.362, ly=-0.000, lz=0.932, fly=true},
    {t=29.571, x=67.438, y=-3.757, z=713.667, lx=-0.366, ly=-0.000, lz=0.931, fly=true},
    {t=29.622, x=66.678, y=-3.815, z=715.484, lx=-0.370, ly=-0.000, lz=0.929, fly=true},
    {t=29.674, x=65.964, y=-3.866, z=717.194, lx=-0.373, ly=-0.000, lz=0.928, fly=true},
    {t=29.730, x=65.184, y=-3.951, z=719.059, lx=-0.376, ly=-0.000, lz=0.927, fly=true},
    {t=29.783, x=64.458, y=-3.992, z=720.794, lx=-0.377, ly=-0.000, lz=0.926, fly=true},
    {t=29.836, x=63.729, y=-4.043, z=722.538, lx=-0.379, ly=-0.000, lz=0.925, fly=true},
    {t=29.890, x=62.984, y=-4.087, z=724.319, lx=-0.380, ly=-0.000, lz=0.925, fly=true},
    {t=29.948, x=62.255, y=-4.230, z=726.063, lx=-0.382, ly=-0.000, lz=0.924, fly=true},
    {t=30.000, x=61.443, y=-4.299, z=728.004, lx=-0.382, ly=-0.000, lz=0.924, fly=true},
    {t=30.054, x=60.695, y=-4.353, z=729.795, lx=-0.383, ly=-0.000, lz=0.924, fly=true},
    {t=30.117, x=60.414, y=-4.626, z=730.467, lx=-0.384, ly=-0.000, lz=0.923, fly=true},
    {t=30.173, x=59.196, y=-4.060, z=733.374, lx=-0.385, ly=-0.000, lz=0.923, fly=true},
    {t=30.226, x=58.647, y=-3.153, z=734.654, lx=-0.387, ly=-0.000, lz=0.922, fly=true},
    {t=30.280, x=58.072, y=-2.232, z=735.951, lx=-0.391, ly=-0.000, lz=0.920, fly=true},
    {t=30.338, x=57.466, y=-1.366, z=737.286, lx=-0.395, ly=-0.000, lz=0.919, fly=true},
    {t=30.391, x=56.648, y=-1.395, z=739.058, lx=-0.400, ly=-0.000, lz=0.917, fly=true},
    {t=30.441, x=55.879, y=-1.443, z=740.708, lx=-0.403, ly=-0.000, lz=0.915, fly=true},
    {t=30.492, x=55.095, y=-1.494, z=742.364, lx=-0.408, ly=-0.000, lz=0.913, fly=true},
    {t=30.546, x=54.280, y=-1.538, z=744.071, lx=-0.412, ly=-0.000, lz=0.911, fly=true},
    {t=30.600, x=53.469, y=-1.593, z=745.759, lx=-0.416, ly=-0.000, lz=0.910, fly=true},
    {t=30.723, x=52.935, y=-2.080, z=746.871, lx=-0.425, ly=-0.000, lz=0.905, fly=true},
    {t=30.828, x=51.247, y=-2.768, z=750.377, lx=-0.431, ly=-0.000, lz=0.903, fly=true},
    {t=30.881, x=49.568, y=-2.873, z=753.859, lx=-0.432, ly=-0.000, lz=0.902, fly=true},
    {t=30.931, x=48.805, y=-2.914, z=755.419, lx=-0.433, ly=-0.000, lz=0.901, fly=true},
    {t=30.985, x=47.925, y=-2.972, z=757.192, lx=-0.435, ly=-0.000, lz=0.900, fly=true},
    {t=31.039, x=47.058, y=-3.016, z=758.907, lx=-0.438, ly=-0.000, lz=0.899, fly=true},
    {t=31.092, x=46.210, y=-3.068, z=760.554, lx=-0.442, ly=-0.000, lz=0.897, fly=true},
    {t=31.145, x=45.280, y=-3.119, z=762.334, lx=-0.446, ly=-0.000, lz=0.895, fly=true},
    {t=31.271, x=44.262, y=-3.626, z=764.262, lx=-0.458, ly=-0.000, lz=0.889, fly=true},
    {t=31.339, x=42.756, y=-3.987, z=767.110, lx=-0.463, ly=-0.000, lz=0.886, fly=true},
    {t=31.392, x=41.144, y=-4.062, z=770.142, lx=-0.464, ly=-0.000, lz=0.886, fly=true},
    {t=31.447, x=40.151, y=-4.127, z=772.003, lx=-0.466, ly=-0.000, lz=0.885, fly=true},
    {t=31.502, x=39.225, y=-4.181, z=773.737, lx=-0.467, ly=-0.000, lz=0.884, fly=true},
    {t=31.554, x=38.389, y=-4.226, z=775.302, lx=-0.467, ly=-0.000, lz=0.884, fly=true},
    {t=31.604, x=37.546, y=-4.280, z=776.875, lx=-0.468, ly=-0.000, lz=0.883, fly=true},
    {t=31.658, x=36.664, y=-4.282, z=778.454, lx=-0.473, ly=-0.000, lz=0.881, fly=true},
    {t=31.709, x=35.929, y=-3.409, z=779.640, lx=-0.485, ly=-0.000, lz=0.875, fly=true},
    {t=31.762, x=35.166, y=-2.533, z=780.728, lx=-0.501, ly=-0.000, lz=0.865, fly=true},
    {t=31.813, x=34.348, y=-1.776, z=781.810, lx=-0.530, ly=-0.000, lz=0.848, fly=true},
    {t=31.866, x=33.492, y=-0.887, z=782.867, lx=-0.550, ly=-0.000, lz=0.835, fly=true},
    {t=31.923, x=32.353, y=-0.610, z=784.135, lx=-0.576, ly=-0.000, lz=0.817, fly=true},
    {t=31.974, x=30.962, y=-0.676, z=785.531, lx=-0.606, ly=-0.000, lz=0.796, fly=true},
    {t=32.025, x=29.608, y=-0.734, z=786.829, lx=-0.629, ly=-0.000, lz=0.777, fly=true},
    {t=32.078, x=28.257, y=-0.782, z=788.122, lx=-0.646, ly=-0.000, lz=0.763, fly=true},
    {t=32.133, x=26.848, y=-0.836, z=789.469, lx=-0.661, ly=-0.000, lz=0.750, fly=true},
    {t=32.184, x=25.503, y=-0.891, z=790.756, lx=-0.673, ly=-0.000, lz=0.740, fly=true},
    {t=32.237, x=24.113, y=-0.942, z=792.069, lx=-0.683, ly=-0.000, lz=0.731, fly=true},
    {t=32.289, x=22.697, y=-1.000, z=793.201, lx=-0.704, ly=-0.000, lz=0.710, fly=true},
    {t=32.340, x=21.141, y=-1.054, z=794.139, lx=-0.737, ly=-0.000, lz=0.676, fly=true},
    {t=32.416, x=20.121, y=-1.388, z=794.616, lx=-0.826, ly=-0.000, lz=0.564, fly=true},
    {t=32.470, x=17.464, y=-0.069, z=795.680, lx=-0.860, ly=-0.000, lz=0.510, fly=true},
    {t=32.521, x=16.197, y=0.793, z=796.041, lx=-0.883, ly=-0.000, lz=0.470, fly=true},
    {t=32.575, x=14.834, y=1.708, z=796.410, lx=-0.904, ly=-0.000, lz=0.428, fly=true},
    {t=32.629, x=13.508, y=2.514, z=796.766, lx=-0.917, ly=-0.000, lz=0.400, fly=true},
    {t=32.681, x=11.702, y=2.482, z=797.246, lx=-0.928, ly=-0.000, lz=0.373, fly=true},
    {t=32.731, x=10.014, y=2.421, z=797.700, lx=-0.937, ly=-0.000, lz=0.351, fly=true},
    {t=32.807, x=7.309, y=2.295, z=798.455, lx=-0.945, ly=-0.000, lz=0.326, fly=true},
    {t=32.860, x=5.496, y=2.244, z=798.969, lx=-0.949, ly=-0.000, lz=0.317, fly=true},
    {t=32.910, x=3.849, y=2.182, z=799.436, lx=-0.951, ly=-0.000, lz=0.308, fly=true},
    {t=32.965, x=1.830, y=2.124, z=799.997, lx=-0.954, ly=-0.000, lz=0.300, fly=true},
    {t=33.016, x=0.055, y=2.073, z=800.487, lx=-0.956, ly=-0.000, lz=0.294, fly=true},
    {t=33.068, x=-1.711, y=2.015, z=800.972, lx=-0.958, ly=-0.000, lz=0.288, fly=true},
    {t=33.125, x=-3.638, y=1.958, z=801.503, lx=-0.959, ly=-0.000, lz=0.284, fly=true},
    {t=33.181, x=-4.975, y=1.943, z=801.887, lx=-0.959, ly=-0.000, lz=0.283, fly=true},
    {t=33.235, x=-6.735, y=3.055, z=802.458, lx=-0.957, ly=-0.000, lz=0.291, fly=true},
    {t=33.286, x=-7.947, y=3.900, z=802.927, lx=-0.952, ly=-0.000, lz=0.305, fly=true},
    {t=33.340, x=-9.225, y=4.813, z=803.502, lx=-0.945, ly=-0.000, lz=0.327, fly=true},
    {t=33.472, x=-10.093, y=4.768, z=803.941, lx=-0.918, ly=-0.000, lz=0.396, fly=true},
    {t=33.547, x=-13.686, y=5.030, z=805.836, lx=-0.903, ly=-0.000, lz=0.430, fly=true},
    {t=33.610, x=-16.041, y=4.812, z=807.142, lx=-0.891, ly=-0.000, lz=0.454, fly=true},
    {t=33.666, x=-18.207, y=4.746, z=808.343, lx=-0.888, ly=-0.000, lz=0.460, fly=true},
    {t=33.783, x=-20.108, y=4.218, z=809.321, lx=-0.892, ly=-0.000, lz=0.452, fly=true},
    {t=33.845, x=-23.486, y=3.942, z=810.948, lx=-0.898, ly=-0.000, lz=0.440, fly=true},
    {t=33.900, x=-26.089, y=3.864, z=812.094, lx=-0.903, ly=-0.000, lz=0.431, fly=true},
    {t=33.952, x=-27.791, y=3.803, z=812.783, lx=-0.908, ly=-0.000, lz=0.419, fly=true},
    {t=34.006, x=-29.621, y=3.745, z=813.492, lx=-0.913, ly=-0.000, lz=0.408, fly=true},
    {t=34.059, x=-31.422, y=3.687, z=814.155, lx=-0.918, ly=-0.000, lz=0.396, fly=true},
    {t=34.112, x=-33.173, y=3.636, z=814.760, lx=-0.924, ly=-0.000, lz=0.383, fly=true},
    {t=34.167, x=-34.936, y=3.647, z=815.358, lx=-0.928, ly=-0.000, lz=0.371, fly=true},
    {t=34.219, x=-36.278, y=4.537, z=815.814, lx=-0.932, ly=-0.000, lz=0.362, fly=true},
    {t=34.272, x=-37.590, y=5.443, z=816.255, lx=-0.935, ly=-0.000, lz=0.354, fly=true},
    {t=34.328, x=-38.899, y=6.346, z=816.693, lx=-0.938, ly=-0.000, lz=0.347, fly=true},
    {t=34.482, x=-40.702, y=6.295, z=817.289, lx=-0.945, ly=-0.000, lz=0.328, fly=true},
    {t=34.536, x=-44.672, y=6.185, z=818.590, lx=-0.946, ly=-0.000, lz=0.323, fly=true},
    {t=34.587, x=-46.478, y=6.127, z=819.168, lx=-0.948, ly=-0.000, lz=0.319, fly=true},
    {t=34.641, x=-48.291, y=6.069, z=819.738, lx=-0.949, ly=-0.000, lz=0.316, fly=true},
    {t=34.694, x=-49.862, y=6.022, z=820.224, lx=-0.950, ly=-0.000, lz=0.312, fly=true},
    {t=34.789, x=-51.245, y=5.528, z=820.648, lx=-0.953, ly=-0.000, lz=0.302, fly=true},
    {t=34.844, x=-55.288, y=5.415, z=821.883, lx=-0.954, ly=-0.000, lz=0.299, fly=true},
    {t=34.895, x=-57.090, y=5.679, z=822.431, lx=-0.955, ly=-0.000, lz=0.297, fly=true},
    {t=34.948, x=-58.913, y=5.702, z=822.986, lx=-0.955, ly=-0.000, lz=0.296, fly=true},
    {t=34.999, x=-60.669, y=5.641, z=823.518, lx=-0.955, ly=-0.000, lz=0.295, fly=true},
    {t=35.049, x=-62.384, y=5.590, z=824.035, lx=-0.956, ly=-0.000, lz=0.294, fly=true},
    {t=35.102, x=-64.179, y=5.532, z=824.575, lx=-0.956, ly=-0.000, lz=0.293, fly=true},
    {t=35.159, x=-66.024, y=5.471, z=825.131, lx=-0.956, ly=-0.000, lz=0.292, fly=true},
    {t=35.215, x=-68.003, y=5.406, z=825.733, lx=-0.956, ly=-0.000, lz=0.292, fly=true},
    {t=35.267, x=-69.792, y=5.345, z=826.329, lx=-0.955, ly=-0.000, lz=0.297, fly=true},
    {t=35.318, x=-71.535, y=5.287, z=827.000, lx=-0.951, ly=-0.000, lz=0.310, fly=true},
    {t=35.377, x=-72.945, y=5.212, z=827.639, lx=-0.942, ly=-0.000, lz=0.336, fly=false},
    {t=35.497, x=-73.878, y=3.648, z=828.193, lx=-0.887, ly=-0.000, lz=0.462, fly=false},
    {t=35.646, x=-73.966, y=2.623, z=828.248, lx=-0.883, ly=0.000, lz=0.469, fly=false},
    {t=35.705, x=-74.554, y=2.676, z=828.891, lx=-0.798, ly=-0.000, lz=0.603, fly=false},
    {t=35.757, x=-74.917, y=2.680, z=829.638, lx=-0.671, ly=-0.000, lz=0.742, fly=false},
    {t=35.808, x=-75.119, y=2.681, z=830.323, lx=-0.548, ly=-0.000, lz=0.836, fly=false},
    {t=35.858, x=-75.264, y=2.681, z=831.022, lx=-0.432, ly=-0.000, lz=0.902, fly=false},
    {t=35.935, x=-75.411, y=2.681, z=831.962, lx=-0.287, ly=-0.000, lz=0.958, fly=false},
    {t=35.990, x=-75.536, y=2.681, z=832.906, lx=-0.217, ly=-0.000, lz=0.976, fly=false},
    {t=36.044, x=-75.623, y=2.681, z=833.615, lx=-0.184, ly=-0.000, lz=0.983, fly=false},
    {t=36.099, x=-75.725, y=2.681, z=834.441, lx=-0.160, ly=-0.000, lz=0.987, fly=false},
    {t=36.229, x=-75.868, y=2.681, z=835.658, lx=-0.130, ly=-0.000, lz=0.992, fly=false},
    {t=36.282, x=-75.923, y=2.681, z=836.280, lx=-0.112, ly=-0.000, lz=0.994, fly=false},
    {t=36.334, x=-75.959, y=2.681, z=836.904, lx=-0.091, ly=-0.000, lz=0.996, fly=false},
    {t=36.386, x=-75.989, y=2.681, z=837.438, lx=-0.079, ly=-0.000, lz=0.997, fly=false},
    {t=36.441, x=-76.018, y=2.681, z=837.973, lx=-0.071, ly=-0.000, lz=0.997, fly=false},
    {t=36.495, x=-76.054, y=2.674, z=838.597, lx=-0.065, ly=0.000, lz=0.998, fly=false},
    {t=36.548, x=-76.084, y=2.679, z=839.131, lx=-0.062, ly=0.000, lz=0.998, fly=false},
    {t=36.601, x=-76.119, y=2.681, z=839.755, lx=-0.060, ly=-0.000, lz=0.998, fly=false},
    {t=36.652, x=-76.149, y=2.681, z=840.290, lx=-0.059, ly=-0.000, lz=0.998, fly=false},
    {t=36.702, x=-76.180, y=2.681, z=840.825, lx=-0.058, ly=-0.000, lz=0.998, fly=false},
    {t=36.781, x=-76.225, y=2.681, z=841.627, lx=-0.057, ly=0.000, lz=0.998, fly=false},
    {t=36.836, x=-76.260, y=2.681, z=842.250, lx=-0.057, ly=-0.000, lz=0.998, fly=false},
    {t=36.888, x=-76.291, y=2.681, z=842.785, lx=-0.057, ly=-0.000, lz=0.998, fly=false},
    {t=36.940, x=-76.324, y=2.681, z=843.374, lx=-0.057, ly=0.000, lz=0.998, fly=false},
    {t=36.991, x=-76.364, y=2.681, z=844.087, lx=-0.057, ly=0.000, lz=0.998, fly=false},
    {t=37.046, x=-76.411, y=2.681, z=844.919, lx=-0.057, ly=0.000, lz=0.998, fly=false},
    {t=37.142, x=-76.485, y=2.681, z=846.226, lx=-0.057, ly=-0.000, lz=0.998, fly=false},
    {t=37.198, x=-76.533, y=2.681, z=847.058, lx=-0.057, ly=0.000, lz=0.998, fly=false},
    {t=37.261, x=-76.586, y=2.681, z=848.009, lx=-0.057, ly=0.000, lz=0.998, fly=false},
    {t=37.312, x=-76.627, y=2.681, z=848.722, lx=-0.057, ly=-0.000, lz=0.998, fly=false},
    {t=37.369, x=-76.673, y=2.681, z=849.554, lx=-0.056, ly=-0.000, lz=0.998, fly=false},
    {t=37.420, x=-76.709, y=2.681, z=850.267, lx=-0.054, ly=0.000, lz=0.999, fly=false},
    {t=37.587, x=-76.769, y=2.681, z=851.574, lx=-0.049, ly=-0.000, lz=0.999, fly=false},
    {t=37.640, x=-76.806, y=2.681, z=852.407, lx=-0.047, ly=-0.000, lz=0.999, fly=false},
    {t=37.834, x=-76.843, y=2.681, z=853.358, lx=-0.042, ly=0.000, lz=0.999, fly=false},
    {t=37.899, x=-76.875, y=2.681, z=854.428, lx=-0.035, ly=0.000, lz=0.999, fly=false},
    {t=37.951, x=-76.899, y=2.681, z=855.261, lx=-0.033, ly=0.000, lz=0.999, fly=false},
    {t=38.002, x=-76.921, y=2.681, z=855.975, lx=-0.032, ly=0.000, lz=0.999, fly=false},
    {t=38.055, x=-76.946, y=2.681, z=856.808, lx=-0.031, ly=0.000, lz=1.000, fly=false},
    }
end
local function createAutoEscapeRawPathB()
    return {
    {t=0.011, x=318.980, y=2.721, z=-336.437, lx=-1.000, ly=-0.000, lz=-0.026, fly=true},
    {t=0.405, x=318.668, y=2.721, z=-335.760, lx=-0.996, ly=-0.000, lz=0.086, fly=true},
    {t=0.455, x=317.750, y=2.721, z=-333.746, lx=-0.948, ly=-0.000, lz=0.317, fly=true},
    {t=0.507, x=316.892, y=2.721, z=-331.750, lx=-0.883, ly=-0.000, lz=0.470, fly=true},
    {t=0.563, x=316.003, y=2.721, z=-329.524, lx=-0.784, ly=-0.000, lz=0.621, fly=true},
    {t=0.616, x=315.270, y=2.721, z=-327.471, lx=-0.700, ly=-0.000, lz=0.714, fly=true},
    {t=0.822, x=315.111, y=2.459, z=-326.784, lx=-0.659, ly=-0.000, lz=0.752, fly=true},
    {t=0.875, x=314.824, y=1.714, z=-325.334, lx=-0.571, ly=-0.000, lz=0.821, fly=true},
    {t=0.930, x=314.553, y=0.666, z=-323.932, lx=-0.498, ly=-0.000, lz=0.867, fly=true},
    {t=0.981, x=314.303, y=-0.315, z=-322.626, lx=-0.437, ly=-0.000, lz=0.900, fly=true},
    {t=1.036, x=314.037, y=-1.378, z=-321.209, lx=-0.385, ly=-0.000, lz=0.923, fly=true},
    {t=1.096, x=313.814, y=-2.458, z=-319.954, lx=-0.345, ly=-0.000, lz=0.939, fly=true},
    {t=1.149, x=313.806, y=-3.961, z=-319.906, lx=-0.345, ly=-0.000, lz=0.939, fly=true},
    {t=1.202, x=313.806, y=-5.318, z=-319.906, lx=-0.345, ly=-0.000, lz=0.939, fly=true},
    {t=1.253, x=313.806, y=-6.528, z=-319.906, lx=-0.345, ly=-0.000, lz=0.939, fly=true},
    {t=1.309, x=313.806, y=-8.022, z=-319.906, lx=-0.345, ly=-0.000, lz=0.939, fly=true},
    {t=1.363, x=313.806, y=-9.558, z=-319.906, lx=-0.345, ly=-0.000, lz=0.939, fly=true},
    {t=1.416, x=313.664, y=-10.607, z=-318.669, lx=-0.295, ly=-0.000, lz=0.955, fly=true},
    {t=1.469, x=313.519, y=-11.614, z=-317.311, lx=-0.257, ly=-0.000, lz=0.967, fly=true},
    {t=1.519, x=313.339, y=-12.014, z=-315.699, lx=-0.228, ly=-0.000, lz=0.974, fly=true},
    {t=1.578, x=313.095, y=-12.087, z=-313.702, lx=-0.204, ly=-0.000, lz=0.979, fly=true},
    {t=1.632, x=312.845, y=-12.158, z=-311.739, lx=-0.187, ly=-0.000, lz=0.982, fly=true},
    {t=1.685, x=312.597, y=-12.226, z=-309.816, lx=-0.175, ly=-0.000, lz=0.985, fly=true},
    {t=1.735, x=312.358, y=-12.284, z=-308.004, lx=-0.167, ly=-0.000, lz=0.986, fly=true},
    {t=1.786, x=312.125, y=-12.342, z=-306.250, lx=-0.160, ly=-0.000, lz=0.987, fly=true},
    {t=1.842, x=311.862, y=-12.404, z=-304.274, lx=-0.154, ly=-0.000, lz=0.988, fly=true},
    {t=1.896, x=311.604, y=-12.475, z=-302.321, lx=-0.149, ly=-0.000, lz=0.989, fly=true},
    {t=1.953, x=311.365, y=-12.540, z=-300.427, lx=-0.144, ly=-0.000, lz=0.990, fly=true},
    {t=2.011, x=311.108, y=-12.632, z=-298.271, lx=-0.137, ly=-0.000, lz=0.991, fly=true},
    {t=2.066, x=310.895, y=-12.707, z=-296.346, lx=-0.131, ly=-0.000, lz=0.991, fly=true},
    {t=2.130, x=310.677, y=-12.802, z=-294.154, lx=-0.122, ly=-0.000, lz=0.993, fly=true},
    {t=2.182, x=310.498, y=-12.897, z=-292.137, lx=-0.113, ly=-0.000, lz=0.994, fly=true},
    {t=2.232, x=310.350, y=-12.969, z=-290.375, lx=-0.107, ly=-0.000, lz=0.994, fly=true},
    {t=2.285, x=310.240, y=-13.020, z=-289.046, lx=-0.103, ly=-0.000, lz=0.995, fly=true},
    {t=2.337, x=310.031, y=-13.170, z=-286.527, lx=-0.096, ly=-0.000, lz=0.995, fly=true},
    {t=2.391, x=309.866, y=-13.252, z=-284.529, lx=-0.093, ly=-0.000, lz=0.996, fly=true},
    {t=2.448, x=309.700, y=-13.316, z=-282.524, lx=-0.091, ly=-0.000, lz=0.996, fly=true},
    {t=2.498, x=309.548, y=-13.374, z=-280.693, lx=-0.089, ly=-0.000, lz=0.996, fly=true},
    {t=2.554, x=309.386, y=-13.436, z=-278.738, lx=-0.088, ly=-0.000, lz=0.996, fly=true},
    {t=2.608, x=309.223, y=-13.497, z=-276.769, lx=-0.087, ly=-0.000, lz=0.996, fly=true},
    {t=2.663, x=309.059, y=-13.572, z=-274.785, lx=-0.086, ly=-0.000, lz=0.996, fly=true},
    {t=2.718, x=308.901, y=-13.640, z=-272.881, lx=-0.085, ly=-0.000, lz=0.996, fly=true},
    {t=2.770, x=308.736, y=-13.705, z=-271.025, lx=-0.086, ly=-0.000, lz=0.996, fly=true},
    {t=2.826, x=308.516, y=-13.787, z=-268.961, lx=-0.091, ly=-0.000, lz=0.996, fly=true},
    {t=2.882, x=308.273, y=-13.861, z=-267.055, lx=-0.099, ly=-0.000, lz=0.995, fly=true},
    {t=2.933, x=308.034, y=-13.933, z=-265.302, lx=-0.107, ly=-0.000, lz=0.994, fly=true},
    {t=2.991, x=307.733, y=-14.005, z=-263.162, lx=-0.115, ly=-0.000, lz=0.993, fly=true},
    {t=3.046, x=307.452, y=-14.069, z=-261.169, lx=-0.120, ly=-0.000, lz=0.993, fly=true},
    {t=3.096, x=307.193, y=-14.144, z=-259.333, lx=-0.124, ly=-0.000, lz=0.992, fly=true},
    {t=3.149, x=306.930, y=-14.209, z=-257.476, lx=-0.127, ly=-0.000, lz=0.992, fly=true},
    {t=3.206, x=306.642, y=-14.284, z=-255.436, lx=-0.130, ly=-0.000, lz=0.991, fly=true},
    {t=3.264, x=306.390, y=-14.369, z=-253.646, lx=-0.133, ly=-0.000, lz=0.991, fly=true},
    {t=3.318, x=306.070, y=-14.454, z=-251.380, lx=-0.134, ly=-0.000, lz=0.991, fly=true},
    {t=3.368, x=305.824, y=-14.539, z=-249.615, lx=-0.135, ly=-0.000, lz=0.991, fly=true},
    {t=3.421, x=305.584, y=-14.614, z=-247.739, lx=-0.133, ly=-0.000, lz=0.991, fly=true},
    {t=3.478, x=305.361, y=-14.682, z=-245.767, lx=-0.128, ly=-0.000, lz=0.992, fly=true},
    {t=3.530, x=305.162, y=-14.740, z=-243.859, lx=-0.123, ly=-0.000, lz=0.992, fly=true},
    {t=3.580, x=304.979, y=-14.805, z=-242.054, lx=-0.119, ly=-0.000, lz=0.993, fly=true},
    {t=3.635, x=304.782, y=-14.870, z=-240.108, lx=-0.115, ly=-0.000, lz=0.993, fly=true},
    {t=3.692, x=304.579, y=-14.934, z=-238.101, lx=-0.112, ly=-0.000, lz=0.994, fly=true},
    {t=3.747, x=304.379, y=-14.996, z=-236.125, lx=-0.110, ly=-0.000, lz=0.994, fly=true},
    {t=3.798, x=304.193, y=-15.061, z=-234.289, lx=-0.108, ly=-0.000, lz=0.994, fly=true},
    {t=3.855, x=303.983, y=-15.129, z=-232.209, lx=-0.106, ly=-0.000, lz=0.994, fly=true},
    {t=3.910, x=303.788, y=-15.193, z=-230.292, lx=-0.105, ly=-0.000, lz=0.994, fly=true},
    {t=3.970, x=303.582, y=-15.268, z=-228.250, lx=-0.104, ly=-0.000, lz=0.995, fly=true},
    {t=4.025, x=303.377, y=-15.333, z=-226.226, lx=-0.103, ly=-0.000, lz=0.995, fly=true},
    {t=4.083, x=303.166, y=-15.408, z=-224.145, lx=-0.103, ly=-0.000, lz=0.995, fly=true},
    {t=4.173, x=302.838, y=-15.687, z=-220.908, lx=-0.102, ly=-0.000, lz=0.995, fly=true},
    {t=4.227, x=302.637, y=-15.752, z=-218.925, lx=-0.102, ly=-0.000, lz=0.995, fly=true},
    {t=4.280, x=302.435, y=-15.827, z=-216.932, lx=-0.102, ly=-0.000, lz=0.995, fly=true},
    {t=4.331, x=302.254, y=-15.892, z=-215.141, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=4.382, x=302.091, y=-15.960, z=-213.536, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=4.436, x=301.874, y=-16.042, z=-211.392, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=4.493, x=301.674, y=-16.110, z=-209.411, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=4.546, x=301.478, y=-16.174, z=-207.478, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=4.597, x=301.289, y=-16.239, z=-205.612, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=4.652, x=301.086, y=-16.304, z=-203.608, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=4.705, x=300.899, y=-16.369, z=-201.757, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=4.758, x=300.707, y=-16.426, z=-199.867, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=4.814, x=300.509, y=-16.501, z=-197.907, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=4.866, x=300.321, y=-16.566, z=-196.052, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=4.919, x=300.125, y=-16.627, z=-194.114, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=4.975, x=299.919, y=-16.689, z=-192.086, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=5.031, x=299.717, y=-16.757, z=-190.085, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=5.086, x=299.518, y=-16.815, z=-188.129, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=5.140, x=299.323, y=-16.876, z=-186.204, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=5.194, x=299.155, y=-17.002, z=-184.542, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=5.244, x=298.944, y=-17.067, z=-182.456, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=5.304, x=298.753, y=-17.135, z=-180.575, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=5.362, x=298.519, y=-17.227, z=-178.261, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=5.414, x=298.341, y=-17.285, z=-176.503, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=5.466, x=298.138, y=-17.360, z=-174.498, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=5.519, x=297.951, y=-17.425, z=-172.651, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=5.571, x=297.770, y=-17.486, z=-170.869, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=5.629, x=297.553, y=-17.602, z=-168.719, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=5.686, x=297.359, y=-17.663, z=-166.807, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=5.739, x=297.148, y=-17.755, z=-164.726, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=5.795, x=296.945, y=-17.823, z=-162.720, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=5.847, x=296.764, y=-17.881, z=-160.936, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=5.901, x=296.561, y=-17.949, z=-158.931, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=5.959, x=296.359, y=-18.011, z=-156.934, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=6.012, x=296.163, y=-18.072, z=-154.999, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=6.067, x=295.969, y=-18.133, z=-153.082, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=6.118, x=295.779, y=-18.201, z=-151.205, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=6.174, x=295.570, y=-18.324, z=-149.145, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=6.227, x=295.379, y=-18.385, z=-147.255, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=6.281, x=295.192, y=-18.447, z=-145.406, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=6.337, x=294.983, y=-18.508, z=-143.346, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=6.389, x=294.797, y=-18.576, z=-141.509, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=6.446, x=294.602, y=-18.641, z=-139.579, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=6.513, x=294.349, y=-18.971, z=-137.089, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=6.570, x=294.126, y=-19.043, z=-134.882, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=6.621, x=293.938, y=-19.104, z=-133.030, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=6.675, x=293.746, y=-19.158, z=-131.132, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=6.726, x=293.554, y=-19.220, z=-129.238, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=6.777, x=293.375, y=-19.274, z=-127.465, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=6.833, x=293.173, y=-19.332, z=-125.475, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=6.889, x=292.972, y=-19.407, z=-123.490, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=6.945, x=292.771, y=-19.468, z=-121.506, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=7.001, x=292.566, y=-19.537, z=-119.478, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=7.054, x=292.374, y=-19.595, z=-117.584, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=7.109, x=292.183, y=-19.663, z=-115.704, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=7.179, x=291.931, y=-19.799, z=-113.210, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=7.230, x=291.737, y=-19.853, z=-111.295, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=7.282, x=291.542, y=-19.915, z=-109.371, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=7.334, x=291.360, y=-19.983, z=-107.568, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=7.388, x=291.166, y=-20.037, z=-105.659, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=7.439, x=290.975, y=-20.099, z=-103.767, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=7.500, x=290.788, y=-20.160, z=-101.921, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=7.551, x=290.583, y=-20.235, z=-99.901, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=7.606, x=290.380, y=-20.303, z=-97.889, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=7.663, x=290.169, y=-20.368, z=-95.814, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=7.719, x=289.967, y=-20.426, z=-93.820, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=7.773, x=289.781, y=-20.487, z=-91.982, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=7.825, x=289.591, y=-20.545, z=-90.101, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=7.878, x=289.397, y=-20.613, z=-88.188, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=7.929, x=289.212, y=-20.671, z=-86.364, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=7.985, x=289.013, y=-20.739, z=-84.397, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=8.038, x=288.830, y=-20.800, z=-82.588, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=8.095, x=288.619, y=-20.869, z=-80.504, lx=-0.101, ly=-0.000, lz=0.995, fly=true},
    {t=8.163, x=288.517, y=-21.010, z=-79.551, lx=-0.104, ly=-0.000, lz=0.995, fly=true},
    {t=8.214, x=288.165, y=-19.671, z=-76.974, lx=-0.119, ly=-0.000, lz=0.993, fly=true},
    {t=8.270, x=287.718, y=-18.728, z=-75.577, lx=-0.163, ly=-0.000, lz=0.987, fly=true},
    {t=8.320, x=287.231, y=-17.939, z=-74.434, lx=-0.211, ly=-0.000, lz=0.978, fly=true},
    {t=8.373, x=286.642, y=-17.030, z=-73.160, lx=-0.254, ly=-0.000, lz=0.967, fly=true},
    {t=8.429, x=285.919, y=-16.643, z=-71.613, lx=-0.291, ly=-0.000, lz=0.957, fly=true},
    {t=8.485, x=285.067, y=-16.711, z=-69.773, lx=-0.320, ly=-0.000, lz=0.947, fly=true},
    {t=8.546, x=284.482, y=-16.755, z=-68.498, lx=-0.334, ly=-0.000, lz=0.942, fly=true},
    {t=8.623, x=283.810, y=-16.898, z=-67.030, lx=-0.357, ly=-0.000, lz=0.934, fly=true},
    {t=8.676, x=282.217, y=-17.371, z=-63.230, lx=-0.372, ly=-0.000, lz=0.928, fly=true},
    {t=8.726, x=281.656, y=-17.436, z=-61.502, lx=-0.359, ly=-0.000, lz=0.933, fly=true},
    {t=8.785, x=281.065, y=-17.417, z=-59.618, lx=-0.347, ly=-0.000, lz=0.938, fly=true},
    {t=8.840, x=280.618, y=-16.484, z=-58.188, lx=-0.337, ly=-0.000, lz=0.942, fly=true},
    {t=8.891, x=280.222, y=-15.621, z=-56.924, lx=-0.330, ly=-0.000, lz=0.944, fly=true},
    {t=8.941, x=279.831, y=-14.767, z=-55.673, lx=-0.324, ly=-0.000, lz=0.946, fly=true},
    {t=8.993, x=279.446, y=-13.944, z=-54.442, lx=-0.319, ly=-0.000, lz=0.948, fly=true},
    {t=9.047, x=279.035, y=-13.053, z=-53.127, lx=-0.315, ly=-0.000, lz=0.949, fly=true},
    {t=9.099, x=278.639, y=-12.193, z=-51.852, lx=-0.311, ly=-0.000, lz=0.950, fly=true},
    {t=9.149, x=278.268, y=-11.364, z=-50.631, lx=-0.307, ly=-0.000, lz=0.952, fly=true},
    {t=9.203, x=277.851, y=-10.524, z=-49.255, lx=-0.303, ly=-0.000, lz=0.953, fly=true},
    {t=9.268, x=277.557, y=-10.052, z=-48.283, lx=-0.298, ly=-0.000, lz=0.954, fly=true},
    {t=9.322, x=276.838, y=-9.368, z=-45.907, lx=-0.297, ly=-0.000, lz=0.955, fly=true},
    {t=9.375, x=276.278, y=-9.426, z=-44.058, lx=-0.295, ly=-0.000, lz=0.955, fly=true},
    {t=9.431, x=275.699, y=-9.484, z=-42.146, lx=-0.294, ly=-0.000, lz=0.956, fly=true},
    {t=9.484, x=275.141, y=-9.542, z=-40.305, lx=-0.293, ly=-0.000, lz=0.956, fly=true},
    {t=9.538, x=274.579, y=-9.599, z=-38.447, lx=-0.293, ly=-0.000, lz=0.956, fly=true},
    {t=9.594, x=274.010, y=-9.657, z=-36.569, lx=-0.292, ly=-0.000, lz=0.956, fly=true},
    {t=9.654, x=273.457, y=-9.729, z=-34.740, lx=-0.292, ly=-0.000, lz=0.957, fly=true},
    {t=9.726, x=272.898, y=-9.889, z=-32.897, lx=-0.291, ly=-0.000, lz=0.957, fly=true},
    {t=9.777, x=272.088, y=-9.964, z=-30.219, lx=-0.291, ly=-0.000, lz=0.957, fly=true},
    {t=9.830, x=271.536, y=-10.022, z=-28.398, lx=-0.291, ly=-0.000, lz=0.957, fly=true},
    {t=9.884, x=271.106, y=-9.296, z=-26.978, lx=-0.290, ly=-0.000, lz=0.957, fly=true},
    {t=9.940, x=270.702, y=-8.387, z=-25.642, lx=-0.290, ly=-0.000, lz=0.957, fly=true},
    {t=9.993, x=270.307, y=-7.502, z=-24.339, lx=-0.290, ly=-0.000, lz=0.957, fly=true},
    {t=10.044, x=269.930, y=-6.656, z=-23.093, lx=-0.290, ly=-0.000, lz=0.957, fly=true},
    {t=10.099, x=269.437, y=-6.217, z=-21.463, lx=-0.290, ly=-0.000, lz=0.957, fly=true},
    {t=10.154, x=268.863, y=-6.281, z=-19.567, lx=-0.290, ly=-0.000, lz=0.957, fly=true},
    {t=10.205, x=268.350, y=-6.373, z=-17.875, lx=-0.290, ly=-0.000, lz=0.957, fly=true},
    {t=10.256, x=267.799, y=-6.438, z=-16.054, lx=-0.290, ly=-0.000, lz=0.957, fly=true},
    {t=10.312, x=267.230, y=-6.496, z=-14.175, lx=-0.290, ly=-0.000, lz=0.957, fly=true},
    {t=10.365, x=266.695, y=-6.554, z=-12.407, lx=-0.290, ly=-0.000, lz=0.957, fly=true},
    {t=10.418, x=266.123, y=-6.615, z=-10.520, lx=-0.290, ly=-0.000, lz=0.957, fly=true},
    {t=10.470, x=265.569, y=-6.669, z=-8.691, lx=-0.290, ly=-0.000, lz=0.957, fly=true},
    {t=10.524, x=265.022, y=-6.727, z=-6.883, lx=-0.290, ly=-0.000, lz=0.957, fly=true},
    {t=10.579, x=264.458, y=-6.785, z=-5.019, lx=-0.290, ly=-0.000, lz=0.957, fly=true},
    {t=10.630, x=263.952, y=-6.840, z=-3.350, lx=-0.290, ly=-0.000, lz=0.957, fly=true},
    {t=10.748, x=263.538, y=-6.894, z=-1.981, lx=-0.290, ly=-0.000, lz=0.957, fly=true},
    {t=10.956, x=262.716, y=-7.358, z=0.735, lx=-0.290, ly=-0.000, lz=0.957, fly=true},
    {t=11.010, x=261.742, y=-7.676, z=4.017, lx=-0.282, ly=-0.000, lz=0.959, fly=true},
    {t=11.060, x=261.483, y=-7.204, z=5.050, lx=-0.270, ly=-0.000, lz=0.963, fly=true},
    {t=11.116, x=261.006, y=-6.216, z=6.992, lx=-0.257, ly=-0.000, lz=0.966, fly=true},
    {t=11.170, x=260.666, y=-5.324, z=8.381, lx=-0.253, ly=-0.000, lz=0.968, fly=true},
    {t=11.229, x=260.248, y=-4.658, z=10.089, lx=-0.248, ly=-0.000, lz=0.969, fly=true},
    {t=11.295, x=259.734, y=-4.746, z=12.191, lx=-0.245, ly=-0.000, lz=0.969, fly=true},
    {t=11.350, x=259.206, y=-4.841, z=14.381, lx=-0.242, ly=-0.000, lz=0.970, fly=true},
    {t=11.415, x=258.666, y=-5.015, z=16.714, lx=-0.236, ly=-0.000, lz=0.972, fly=true},
    {t=11.468, x=258.262, y=-5.110, z=18.551, lx=-0.230, ly=-0.000, lz=0.973, fly=true},
    {t=11.528, x=257.824, y=-5.192, z=20.594, lx=-0.225, ly=-0.000, lz=0.974, fly=true},
    {t=11.587, x=257.374, y=-5.297, z=22.696, lx=-0.221, ly=-0.000, lz=0.975, fly=true},
    {t=11.639, x=256.978, y=-5.369, z=24.551, lx=-0.218, ly=-0.000, lz=0.976, fly=true},
    {t=11.690, x=256.572, y=-5.451, z=26.454, lx=-0.216, ly=-0.000, lz=0.976, fly=true},
    {t=11.740, x=256.210, y=-5.509, z=28.145, lx=-0.215, ly=-0.000, lz=0.977, fly=true},
    {t=11.794, x=255.808, y=-5.580, z=30.029, lx=-0.213, ly=-0.000, lz=0.977, fly=true},
    {t=11.849, x=255.396, y=-5.652, z=31.960, lx=-0.212, ly=-0.000, lz=0.977, fly=true},
    {t=11.901, x=254.988, y=-5.733, z=33.867, lx=-0.212, ly=-0.000, lz=0.977, fly=true},
    {t=11.961, x=254.588, y=-5.819, z=35.741, lx=-0.211, ly=-0.000, lz=0.977, fly=true},
    {t=12.023, x=254.071, y=-5.999, z=38.163, lx=-0.210, ly=-0.000, lz=0.978, fly=true},
    {t=12.081, x=253.646, y=-6.091, z=40.151, lx=-0.210, ly=-0.000, lz=0.978, fly=true},
    {t=12.134, x=253.223, y=-6.173, z=42.130, lx=-0.210, ly=-0.000, lz=0.978, fly=true},
    {t=12.190, x=252.821, y=-6.255, z=44.013, lx=-0.209, ly=-0.000, lz=0.978, fly=true},
    {t=12.244, x=252.438, y=-6.241, z=45.806, lx=-0.209, ly=-0.000, lz=0.978, fly=true},
    {t=12.308, x=252.071, y=-5.203, z=47.526, lx=-0.209, ly=-0.000, lz=0.978, fly=true},
    {t=12.367, x=251.754, y=-4.284, z=49.010, lx=-0.209, ly=-0.000, lz=0.978, fly=true},
    {t=12.447, x=251.372, y=-3.366, z=50.799, lx=-0.209, ly=-0.000, lz=0.978, fly=true},
    {t=12.501, x=250.923, y=-2.939, z=52.989, lx=-0.206, ly=-0.000, lz=0.978, fly=true},
    {t=12.552, x=250.590, y=-3.007, z=54.684, lx=-0.204, ly=-0.000, lz=0.979, fly=true},
    {t=12.607, x=250.183, y=-3.065, z=56.760, lx=-0.201, ly=-0.000, lz=0.980, fly=true},
    {t=12.663, x=249.788, y=-3.129, z=58.780, lx=-0.199, ly=-0.000, lz=0.980, fly=true},
    {t=12.714, x=249.457, y=-3.180, z=60.470, lx=-0.198, ly=-0.000, lz=0.980, fly=true},
    {t=12.765, x=249.095, y=-3.242, z=62.321, lx=-0.197, ly=-0.000, lz=0.980, fly=true},
    {t=12.818, x=248.717, y=-3.300, z=64.249, lx=-0.196, ly=-0.000, lz=0.981, fly=true},
    {t=12.869, x=248.363, y=-3.358, z=66.057, lx=-0.195, ly=-0.000, lz=0.981, fly=true},
    {t=12.919, x=248.031, y=-3.412, z=67.754, lx=-0.195, ly=-0.000, lz=0.981, fly=true},
    {t=12.987, x=247.656, y=-3.470, z=69.668, lx=-0.194, ly=-0.000, lz=0.981, fly=true},
    {t=13.050, x=247.162, y=-3.627, z=72.190, lx=-0.194, ly=-0.000, lz=0.981, fly=true},
    {t=13.102, x=246.765, y=-3.698, z=74.220, lx=-0.193, ly=-0.000, lz=0.981, fly=true},
    {t=13.155, x=246.394, y=-3.756, z=76.112, lx=-0.193, ly=-0.000, lz=0.981, fly=true},
    {t=13.206, x=246.046, y=-3.807, z=77.892, lx=-0.193, ly=-0.000, lz=0.981, fly=true},
    {t=13.260, x=245.690, y=-3.858, z=79.709, lx=-0.193, ly=-0.000, lz=0.981, fly=true},
    {t=13.317, x=245.302, y=-3.926, z=81.689, lx=-0.193, ly=-0.000, lz=0.981, fly=true},
    {t=13.373, x=244.904, y=-3.994, z=83.722, lx=-0.193, ly=-0.000, lz=0.981, fly=true},
    {t=13.429, x=244.510, y=-4.056, z=85.738, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=13.484, x=244.139, y=-4.117, z=87.630, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=13.538, x=243.776, y=-4.182, z=89.484, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=13.591, x=243.404, y=-4.243, z=91.386, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=13.645, x=243.023, y=-4.304, z=93.329, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=13.698, x=242.660, y=-4.366, z=95.185, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=13.751, x=242.294, y=-4.427, z=97.051, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=13.803, x=241.931, y=-4.482, z=98.907, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=13.856, x=241.580, y=-4.543, z=100.702, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=13.910, x=241.214, y=-4.597, z=102.569, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=13.962, x=240.851, y=-4.659, z=104.422, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=14.016, x=240.483, y=-4.720, z=106.301, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=14.067, x=240.160, y=-4.778, z=107.955, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=14.119, x=239.761, y=-4.866, z=109.991, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=14.174, x=239.379, y=-4.928, z=111.942, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=14.230, x=238.995, y=-4.986, z=113.905, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=14.281, x=238.640, y=-5.044, z=115.716, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=14.334, x=238.272, y=-5.091, z=117.596, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=14.388, x=237.905, y=-5.149, z=119.473, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=14.441, x=237.532, y=-5.262, z=121.375, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=14.494, x=237.164, y=-5.316, z=123.257, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=14.547, x=236.804, y=-5.371, z=125.093, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=14.624, x=236.692, y=-5.834, z=125.666, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=14.678, x=236.070, y=-6.038, z=128.845, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=14.733, x=235.532, y=-6.164, z=131.590, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=14.787, x=235.118, y=-6.239, z=133.703, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=14.839, x=234.751, y=-6.287, z=135.579, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=14.892, x=234.414, y=-6.355, z=137.302, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=14.944, x=234.042, y=-6.409, z=139.200, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=14.996, x=233.668, y=-6.471, z=141.113, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=15.050, x=233.314, y=-6.535, z=142.919, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=15.145, x=232.979, y=-6.600, z=144.629, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=15.241, x=232.543, y=-6.958, z=146.855, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=15.297, x=231.661, y=-7.510, z=151.363, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=15.352, x=231.263, y=-7.571, z=153.392, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=15.407, x=230.886, y=-7.625, z=155.320, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=15.463, x=230.500, y=-7.728, z=157.291, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=15.517, x=230.125, y=-7.782, z=159.207, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=15.572, x=229.751, y=-7.847, z=161.116, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=15.624, x=229.387, y=-7.898, z=162.978, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=15.675, x=229.043, y=-7.949, z=164.736, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=15.726, x=228.695, y=-8.000, z=166.512, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=15.779, x=228.329, y=-8.058, z=168.383, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=15.834, x=227.951, y=-8.119, z=170.314, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=15.889, x=227.566, y=-8.174, z=172.280, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=15.942, x=227.198, y=-8.232, z=174.158, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=15.996, x=226.839, y=-8.280, z=175.992, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=16.103, x=226.431, y=-8.739, z=178.073, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=16.154, x=225.704, y=-8.811, z=181.787, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=16.210, x=225.308, y=-8.879, z=183.809, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=16.260, x=225.012, y=-8.923, z=185.321, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=16.313, x=224.601, y=-9.005, z=187.421, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=16.367, x=224.232, y=-9.053, z=189.305, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=16.417, x=223.894, y=-9.104, z=191.035, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=16.470, x=223.522, y=-9.278, z=192.933, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=16.523, x=223.146, y=-9.339, z=194.852, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=16.576, x=222.777, y=-9.393, z=196.739, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=16.630, x=222.399, y=-9.451, z=198.671, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=16.681, x=222.059, y=-9.502, z=200.407, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=16.734, x=221.696, y=-9.557, z=202.259, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=16.788, x=221.320, y=-9.611, z=204.182, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=16.839, x=221.162, y=-9.775, z=204.989, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=16.891, x=220.614, y=-9.846, z=207.790, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=16.945, x=220.220, y=-9.911, z=209.798, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=17.001, x=219.841, y=-9.969, z=211.734, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=17.055, x=219.472, y=-10.027, z=213.621, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=17.109, x=219.098, y=-10.085, z=215.530, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=17.163, x=218.726, y=-10.150, z=217.431, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=17.215, x=218.379, y=-10.201, z=219.202, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=17.270, x=217.988, y=-10.255, z=221.199, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=17.320, x=217.647, y=-10.333, z=222.940, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=17.371, x=217.294, y=-10.385, z=224.744, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=17.425, x=216.925, y=-10.439, z=226.629, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=17.476, x=216.562, y=-10.562, z=228.484, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=17.527, x=216.211, y=-10.613, z=230.276, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=17.578, x=215.866, y=-10.664, z=232.040, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=17.628, x=215.524, y=-10.715, z=233.784, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=17.678, x=215.174, y=-10.766, z=235.575, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=17.734, x=214.786, y=-10.827, z=237.556, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=17.787, x=214.438, y=-10.875, z=239.331, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=17.844, x=214.062, y=-10.940, z=241.253, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=17.894, x=213.694, y=-10.991, z=243.133, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=17.948, x=213.323, y=-11.045, z=245.028, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=18.001, x=212.953, y=-11.100, z=246.918, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=18.053, x=212.603, y=-11.151, z=248.706, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=18.104, x=212.246, y=-11.209, z=250.528, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=18.158, x=211.881, y=-11.260, z=252.396, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=18.210, x=211.517, y=-11.318, z=254.253, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=18.264, x=211.155, y=-11.372, z=256.104, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=18.324, x=210.776, y=-11.437, z=258.040, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=18.376, x=210.374, y=-11.522, z=260.089, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=18.431, x=209.997, y=-11.577, z=262.018, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=18.481, x=209.646, y=-11.624, z=263.811, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=18.533, x=209.288, y=-11.679, z=265.639, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=18.593, x=208.936, y=-11.733, z=267.436, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=18.649, x=208.505, y=-11.802, z=269.636, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=18.702, x=208.136, y=-11.860, z=271.521, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=18.753, x=207.776, y=-11.914, z=273.363, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=18.807, x=207.414, y=-11.962, z=275.209, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=18.864, x=207.051, y=-12.016, z=277.063, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=18.920, x=206.648, y=-12.095, z=279.125, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=18.973, x=206.276, y=-12.156, z=281.024, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=19.027, x=205.902, y=-12.210, z=282.935, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=19.079, x=205.541, y=-12.261, z=284.776, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=19.133, x=205.174, y=-12.316, z=286.653, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=19.186, x=204.816, y=-12.374, z=288.481, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=19.241, x=204.439, y=-12.435, z=290.408, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=19.293, x=204.065, y=-12.493, z=292.314, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=19.349, x=203.715, y=-12.544, z=294.103, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=19.401, x=203.326, y=-12.629, z=296.091, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=19.472, x=202.844, y=-12.742, z=298.551, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=19.526, x=202.468, y=-12.803, z=300.472, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=19.577, x=202.116, y=-12.851, z=302.272, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=19.628, x=201.766, y=-12.898, z=304.059, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=19.681, x=201.406, y=-12.953, z=305.895, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=19.735, x=201.041, y=-13.011, z=307.763, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=19.787, x=200.674, y=-13.062, z=309.637, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=19.839, x=200.318, y=-13.116, z=311.457, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=19.893, x=199.938, y=-13.171, z=313.395, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=19.945, x=199.588, y=-13.222, z=315.185, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=19.998, x=199.221, y=-13.280, z=317.057, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=20.053, x=198.843, y=-13.334, z=318.990, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=20.104, x=198.498, y=-13.386, z=320.752, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=20.157, x=198.161, y=-13.450, z=322.475, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=20.213, x=197.751, y=-13.522, z=324.565, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=20.267, x=197.364, y=-13.576, z=326.542, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=20.320, x=197.024, y=-13.624, z=328.280, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=20.383, x=196.631, y=-13.685, z=330.287, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=20.434, x=196.216, y=-13.770, z=332.408, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=20.499, x=195.794, y=-13.985, z=334.561, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=20.549, x=195.409, y=-14.043, z=336.528, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=20.600, x=195.057, y=-14.087, z=338.326, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=20.653, x=194.692, y=-14.142, z=340.193, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=20.704, x=194.351, y=-14.193, z=341.932, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=20.756, x=193.993, y=-14.254, z=343.760, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=20.811, x=193.612, y=-14.309, z=345.709, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=20.863, x=193.269, y=-14.367, z=347.462, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=20.917, x=192.883, y=-14.418, z=349.434, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=20.969, x=192.531, y=-14.476, z=351.228, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=21.024, x=192.152, y=-14.530, z=353.164, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=21.075, x=191.801, y=-14.581, z=354.961, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=21.130, x=191.430, y=-14.653, z=356.856, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=21.184, x=191.072, y=-14.711, z=358.685, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=21.237, x=190.683, y=-14.772, z=360.664, lx=-0.192, ly=-0.000, lz=0.981, fly=true},
    {t=21.290, x=190.311, y=-14.833, z=362.465, lx=-0.195, ly=-0.000, lz=0.981, fly=true},
    {t=21.349, x=189.890, y=-14.905, z=364.356, lx=-0.200, ly=-0.000, lz=0.980, fly=true},
    {t=21.405, x=189.466, y=-14.252, z=366.141, lx=-0.208, ly=-0.000, lz=0.978, fly=true},
    {t=21.467, x=189.292, y=-13.803, z=366.851, lx=-0.213, ly=-0.000, lz=0.977, fly=true},
    {t=21.520, x=188.728, y=-12.602, z=369.138, lx=-0.225, ly=-0.000, lz=0.974, fly=true},
    {t=21.577, x=188.377, y=-11.670, z=370.560, lx=-0.228, ly=-0.000, lz=0.974, fly=true},
    {t=21.632, x=188.033, y=-10.732, z=371.955, lx=-0.230, ly=-0.000, lz=0.973, fly=true},
    {t=21.685, x=187.707, y=-9.840, z=373.279, lx=-0.232, ly=-0.000, lz=0.973, fly=true},
    {t=21.736, x=187.339, y=-9.462, z=374.771, lx=-0.233, ly=-0.000, lz=0.972, fly=true},
    {t=21.788, x=186.894, y=-9.520, z=376.572, lx=-0.235, ly=-0.000, lz=0.972, fly=true},
    {t=21.841, x=186.439, y=-9.571, z=378.405, lx=-0.236, ly=-0.000, lz=0.972, fly=true},
    {t=21.893, x=185.956, y=-9.629, z=380.249, lx=-0.239, ly=-0.000, lz=0.971, fly=true},
    {t=21.947, x=185.451, y=-9.683, z=382.113, lx=-0.244, ly=-0.000, lz=0.970, fly=true},
    {t=21.997, x=184.988, y=-9.741, z=383.815, lx=-0.247, ly=-0.000, lz=0.969, fly=true},
    {t=22.066, x=184.511, y=-9.877, z=385.570, lx=-0.252, ly=-0.000, lz=0.968, fly=true},
    {t=22.122, x=183.979, y=-8.818, z=387.529, lx=-0.254, ly=-0.000, lz=0.967, fly=true},
    {t=22.178, x=183.662, y=-8.058, z=388.695, lx=-0.256, ly=-0.000, lz=0.967, fly=true},
    {t=22.235, x=183.222, y=-6.976, z=390.312, lx=-0.257, ly=-0.000, lz=0.966, fly=true},
    {t=22.285, x=182.874, y=-6.111, z=391.592, lx=-0.258, ly=-0.000, lz=0.966, fly=true},
    {t=22.340, x=182.513, y=-5.214, z=392.923, lx=-0.259, ly=-0.000, lz=0.966, fly=true},
    {t=22.393, x=182.157, y=-4.333, z=394.233, lx=-0.260, ly=-0.000, lz=0.966, fly=true},
    {t=22.444, x=181.701, y=-4.115, z=395.910, lx=-0.260, ly=-0.000, lz=0.966, fly=true},
    {t=22.516, x=181.084, y=-4.251, z=398.180, lx=-0.261, ly=-0.000, lz=0.965, fly=true},
    {t=22.568, x=180.540, y=-4.319, z=400.180, lx=-0.261, ly=-0.000, lz=0.965, fly=true},
    {t=22.620, x=180.044, y=-4.367, z=402.006, lx=-0.261, ly=-0.000, lz=0.965, fly=true},
    {t=22.672, x=179.567, y=-4.421, z=403.761, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=22.723, x=179.077, y=-4.469, z=405.563, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=22.779, x=178.584, y=-4.524, z=407.378, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=22.830, x=178.078, y=-4.578, z=409.240, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=22.884, x=177.563, y=-4.629, z=411.132, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=22.942, x=177.321, y=-4.495, z=412.023, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=22.996, x=176.764, y=-3.118, z=414.073, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=23.047, x=176.430, y=-2.281, z=415.302, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=23.098, x=176.086, y=-1.417, z=416.567, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=23.150, x=175.609, y=-1.413, z=418.324, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=23.205, x=175.099, y=-1.470, z=420.200, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=23.273, x=174.929, y=-1.883, z=420.825, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=23.327, x=173.898, y=-1.954, z=424.618, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=23.418, x=173.535, y=-2.349, z=425.953, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=23.471, x=172.744, y=-0.898, z=428.864, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=23.523, x=172.416, y=-0.083, z=430.069, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=23.578, x=172.023, y=0.874, z=431.517, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=23.628, x=171.629, y=1.295, z=432.967, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=23.679, x=171.140, y=1.248, z=434.766, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=23.729, x=170.657, y=1.193, z=436.542, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=23.784, x=170.162, y=1.149, z=438.364, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=23.835, x=169.684, y=1.091, z=440.121, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=23.889, x=169.180, y=1.040, z=441.975, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=23.941, x=168.714, y=0.992, z=443.692, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=23.994, x=168.232, y=1.116, z=445.462, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=24.045, x=167.878, y=1.997, z=446.766, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=24.100, x=167.518, y=2.898, z=448.089, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=24.162, x=167.065, y=3.195, z=449.756, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=24.216, x=166.466, y=3.130, z=451.960, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=24.268, x=165.984, y=3.073, z=453.733, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=24.320, x=165.508, y=3.021, z=455.485, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=24.371, x=165.017, y=2.967, z=457.292, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=24.425, x=164.525, y=2.923, z=459.104, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=24.476, x=164.124, y=2.834, z=460.577, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=24.544, x=163.439, y=2.606, z=463.099, lx=-0.262, ly=-0.000, lz=0.965, fly=true},
    {t=24.628, x=163.085, y=2.555, z=464.345, lx=-0.264, ly=-0.000, lz=0.964, fly=true},
    {t=24.679, x=161.912, y=2.102, z=468.219, lx=-0.278, ly=-0.000, lz=0.961, fly=true},
    {t=24.734, x=161.291, y=2.037, z=470.095, lx=-0.286, ly=-0.000, lz=0.958, fly=true},
    {t=24.785, x=160.696, y=1.986, z=471.831, lx=-0.293, ly=-0.000, lz=0.956, fly=true},
    {t=24.841, x=160.040, y=1.925, z=473.680, lx=-0.301, ly=-0.000, lz=0.954, fly=true},
    {t=24.891, x=159.428, y=1.870, z=475.365, lx=-0.309, ly=-0.000, lz=0.951, fly=true},
    {t=24.947, x=158.720, y=1.812, z=477.272, lx=-0.316, ly=-0.000, lz=0.949, fly=true},
    {t=24.999, x=158.045, y=1.754, z=479.080, lx=-0.323, ly=-0.000, lz=0.946, fly=true},
    {t=25.051, x=157.399, y=1.690, z=480.807, lx=-0.329, ly=-0.000, lz=0.944, fly=true},
    {t=25.119, x=156.621, y=1.523, z=482.890, lx=-0.336, ly=-0.000, lz=0.942, fly=true},
    {t=25.172, x=155.877, y=1.461, z=484.881, lx=-0.339, ly=-0.000, lz=0.941, fly=true},
    {t=25.225, x=155.685, y=1.233, z=485.395, lx=-0.342, ly=-0.000, lz=0.940, fly=true},
    {t=25.280, x=154.484, y=1.165, z=488.608, lx=-0.344, ly=-0.000, lz=0.939, fly=true},
    {t=25.333, x=153.816, y=1.104, z=490.395, lx=-0.345, ly=-0.000, lz=0.938, fly=true},
    {t=25.385, x=153.161, y=1.042, z=492.149, lx=-0.346, ly=-0.000, lz=0.938, fly=true},
    {t=25.438, x=152.506, y=0.984, z=493.900, lx=-0.347, ly=-0.000, lz=0.938, fly=true},
    {t=25.489, x=151.868, y=0.930, z=495.608, lx=-0.348, ly=-0.000, lz=0.938, fly=true},
    {t=25.548, x=151.359, y=0.698, z=496.971, lx=-0.348, ly=-0.000, lz=0.937, fly=true},
    {t=25.601, x=150.414, y=0.627, z=499.501, lx=-0.349, ly=-0.000, lz=0.937, fly=true},
    {t=25.660, x=149.777, y=0.559, z=501.226, lx=-0.348, ly=-0.000, lz=0.937, fly=true},
    {t=25.714, x=149.027, y=0.480, z=503.304, lx=-0.346, ly=-0.000, lz=0.938, fly=true},
    {t=25.769, x=148.371, y=0.419, z=505.171, lx=-0.343, ly=-0.000, lz=0.939, fly=true},
    {t=25.824, x=147.734, y=0.361, z=507.024, lx=-0.339, ly=-0.000, lz=0.941, fly=true},
    {t=25.875, x=147.129, y=0.303, z=508.802, lx=-0.336, ly=-0.000, lz=0.942, fly=true},
    {t=25.930, x=146.509, y=0.256, z=510.628, lx=-0.334, ly=-0.000, lz=0.943, fly=true},
    {t=25.982, x=145.894, y=0.201, z=512.438, lx=-0.331, ly=-0.000, lz=0.944, fly=true},
    {t=26.048, x=145.248, y=0.126, z=514.340, lx=-0.329, ly=-0.000, lz=0.944, fly=true},
    {t=26.100, x=144.523, y=0.061, z=516.475, lx=-0.328, ly=-0.000, lz=0.945, fly=true},
    {t=26.152, x=143.944, y=0.010, z=518.177, lx=-0.326, ly=-0.000, lz=0.945, fly=true},
    {t=26.205, x=143.328, y=-0.041, z=519.991, lx=-0.326, ly=-0.000, lz=0.946, fly=true},
    {t=26.258, x=142.735, y=-0.089, z=521.737, lx=-0.325, ly=-0.000, lz=0.946, fly=true},
    {t=26.311, x=142.113, y=-0.143, z=523.569, lx=-0.324, ly=-0.000, lz=0.946, fly=true},
    {t=26.362, x=141.523, y=-0.201, z=525.306, lx=-0.324, ly=-0.000, lz=0.946, fly=true},
    {t=26.415, x=140.931, y=-0.249, z=527.049, lx=-0.323, ly=-0.000, lz=0.946, fly=true},
    {t=26.466, x=140.350, y=-0.293, z=528.759, lx=-0.323, ly=-0.000, lz=0.946, fly=true},
    {t=26.534, x=139.559, y=-0.405, z=531.088, lx=-0.323, ly=-0.000, lz=0.946, fly=true},
    {t=26.587, x=138.941, y=-0.467, z=532.908, lx=-0.323, ly=-0.000, lz=0.947, fly=true},
    {t=26.643, x=138.293, y=-0.525, z=534.816, lx=-0.322, ly=-0.000, lz=0.947, fly=true},
    {t=26.695, x=137.679, y=-0.582, z=536.625, lx=-0.322, ly=-0.000, lz=0.947, fly=true},
    {t=26.746, x=137.093, y=-0.637, z=538.350, lx=-0.322, ly=-0.000, lz=0.947, fly=true},
    {t=26.801, x=136.477, y=-0.695, z=540.162, lx=-0.322, ly=-0.000, lz=0.947, fly=true},
    {t=26.852, x=135.902, y=-0.743, z=541.856, lx=-0.322, ly=-0.000, lz=0.947, fly=true},
    {t=26.905, x=135.283, y=-0.800, z=543.678, lx=-0.322, ly=-0.000, lz=0.947, fly=true},
    {t=26.960, x=134.651, y=-0.858, z=545.540, lx=-0.322, ly=-0.000, lz=0.947, fly=true},
    {t=27.011, x=134.075, y=-0.909, z=547.234, lx=-0.322, ly=-0.000, lz=0.947, fly=true},
    {t=27.064, x=133.469, y=-0.967, z=549.018, lx=-0.322, ly=-0.000, lz=0.947, fly=true},
    {t=27.115, x=132.867, y=-1.015, z=550.791, lx=-0.322, ly=-0.000, lz=0.947, fly=true},
    {t=27.167, x=132.271, y=-1.063, z=552.546, lx=-0.322, ly=-0.000, lz=0.947, fly=true},
    {t=27.221, x=131.634, y=-1.121, z=554.422, lx=-0.322, ly=-0.000, lz=0.947, fly=true},
    {t=27.275, x=131.023, y=-1.165, z=556.221, lx=-0.322, ly=-0.000, lz=0.947, fly=true},
    {t=27.328, x=130.415, y=-1.219, z=558.011, lx=-0.322, ly=-0.000, lz=0.947, fly=true},
    {t=27.384, x=129.788, y=-1.274, z=559.858, lx=-0.322, ly=-0.000, lz=0.947, fly=true},
    {t=27.434, x=129.204, y=-1.328, z=561.578, lx=-0.322, ly=-0.000, lz=0.947, fly=true},
    {t=27.486, x=128.597, y=-1.379, z=563.365, lx=-0.322, ly=-0.000, lz=0.947, fly=true},
    {t=27.541, x=127.951, y=-1.478, z=565.265, lx=-0.322, ly=-0.000, lz=0.947, fly=true},
    {t=27.595, x=127.344, y=-1.533, z=567.053, lx=-0.322, ly=-0.000, lz=0.947, fly=true},
    {t=27.648, x=126.736, y=-1.587, z=568.834, lx=-0.322, ly=-0.000, lz=0.947, fly=true},
    {t=27.753, x=126.107, y=-1.645, z=570.676, lx=-0.322, ly=-0.000, lz=0.947, fly=true},
    {t=27.807, x=124.808, y=-2.057, z=574.434, lx=-0.325, ly=-0.000, lz=0.946, fly=true},
    {t=27.859, x=124.194, y=-2.105, z=576.174, lx=-0.326, ly=-0.000, lz=0.945, fly=true},
    {t=27.911, x=123.543, y=-2.166, z=578.012, lx=-0.328, ly=-0.000, lz=0.945, fly=true},
    {t=27.962, x=123.148, y=-2.292, z=579.128, lx=-0.329, ly=-0.000, lz=0.944, fly=true},
    {t=28.015, x=122.298, y=-2.350, z=581.531, lx=-0.330, ly=-0.000, lz=0.944, fly=true},
    {t=28.069, x=121.661, y=-2.422, z=583.330, lx=-0.331, ly=-0.000, lz=0.944, fly=true},
    {t=28.122, x=121.084, y=-2.483, z=584.953, lx=-0.332, ly=-0.000, lz=0.943, fly=true},
    {t=28.175, x=120.378, y=-2.548, z=586.899, lx=-0.334, ly=-0.000, lz=0.943, fly=true},
    {t=28.225, x=119.733, y=-2.596, z=588.648, lx=-0.336, ly=-0.000, lz=0.942, fly=true},
    {t=28.278, x=119.125, y=-2.647, z=590.289, lx=-0.338, ly=-0.000, lz=0.941, fly=true},
    {t=28.329, x=118.459, y=-2.705, z=592.069, lx=-0.340, ly=-0.000, lz=0.940, fly=true},
    {t=28.386, x=117.755, y=-2.762, z=593.941, lx=-0.343, ly=-0.000, lz=0.939, fly=true},
    {t=28.444, x=117.060, y=-2.770, z=595.789, lx=-0.345, ly=-0.000, lz=0.939, fly=true},
    {t=28.494, x=116.580, y=-1.904, z=597.066, lx=-0.346, ly=-0.000, lz=0.938, fly=true},
    {t=28.545, x=116.122, y=-1.121, z=598.282, lx=-0.347, ly=-0.000, lz=0.938, fly=true},
    {t=28.595, x=115.648, y=-0.232, z=599.542, lx=-0.348, ly=-0.000, lz=0.937, fly=true},
    {t=28.646, x=115.152, y=0.444, z=600.860, lx=-0.349, ly=-0.000, lz=0.937, fly=true},
    {t=28.698, x=114.526, y=0.402, z=602.525, lx=-0.349, ly=-0.000, lz=0.937, fly=true},
    {t=28.753, x=113.851, y=0.351, z=604.319, lx=-0.350, ly=-0.000, lz=0.937, fly=true},
    {t=28.812, x=113.209, y=0.181, z=606.027, lx=-0.351, ly=-0.000, lz=0.937, fly=true},
    {t=28.864, x=112.382, y=0.109, z=608.223, lx=-0.351, ly=-0.000, lz=0.936, fly=true},
    {t=28.914, x=111.777, y=0.065, z=609.833, lx=-0.351, ly=-0.000, lz=0.936, fly=true},
    {t=28.969, x=111.068, y=0.004, z=611.717, lx=-0.351, ly=-0.000, lz=0.936, fly=true},
    {t=29.022, x=110.402, y=-0.047, z=613.487, lx=-0.351, ly=-0.000, lz=0.936, fly=true},
    {t=29.072, x=109.769, y=-0.102, z=615.163, lx=-0.352, ly=-0.000, lz=0.936, fly=true},
    {t=29.122, x=109.135, y=-0.150, z=616.832, lx=-0.352, ly=-0.000, lz=0.936, fly=true},
    {t=29.177, x=108.438, y=-0.201, z=618.661, lx=-0.353, ly=-0.000, lz=0.936, fly=true},
    {t=29.229, x=107.760, y=-0.252, z=620.444, lx=-0.354, ly=-0.000, lz=0.935, fly=true},
    {t=29.281, x=107.112, y=-0.296, z=622.145, lx=-0.354, ly=-0.000, lz=0.935, fly=true},
    {t=29.334, x=106.455, y=-0.344, z=623.871, lx=-0.354, ly=-0.000, lz=0.935, fly=true},
    {t=29.385, x=105.814, y=-0.398, z=625.555, lx=-0.354, ly=-0.000, lz=0.935, fly=true},
    {t=29.438, x=105.139, y=-0.453, z=627.327, lx=-0.355, ly=-0.000, lz=0.935, fly=true},
    {t=29.491, x=104.442, y=-0.497, z=629.157, lx=-0.355, ly=-0.000, lz=0.935, fly=true},
    {t=29.550, x=103.706, y=-0.599, z=631.093, lx=-0.355, ly=-0.000, lz=0.935, fly=true},
    {t=29.601, x=103.047, y=-0.657, z=632.824, lx=-0.355, ly=-0.000, lz=0.935, fly=true},
    {t=29.655, x=102.350, y=-0.708, z=634.655, lx=-0.355, ly=-0.000, lz=0.935, fly=true},
    {t=29.709, x=101.676, y=-0.759, z=636.425, lx=-0.355, ly=-0.000, lz=0.935, fly=true},
    {t=29.762, x=101.005, y=-0.804, z=638.187, lx=-0.355, ly=-0.000, lz=0.935, fly=true},
    {t=29.813, x=100.358, y=-0.858, z=639.886, lx=-0.355, ly=-0.000, lz=0.935, fly=true},
    {t=29.863, x=99.718, y=-0.930, z=641.568, lx=-0.355, ly=-0.000, lz=0.935, fly=true},
    {t=29.926, x=98.988, y=-1.008, z=643.485, lx=-0.355, ly=-0.000, lz=0.935, fly=true},
    {t=29.978, x=98.243, y=-1.110, z=645.441, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=30.030, x=97.591, y=-1.154, z=647.156, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=30.083, x=96.882, y=-1.212, z=649.017, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=30.135, x=96.242, y=-1.257, z=650.699, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=30.188, x=95.553, y=-1.308, z=652.509, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=30.240, x=94.894, y=-1.352, z=654.239, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=30.294, x=94.230, y=-1.403, z=655.985, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=30.344, x=93.586, y=-1.451, z=657.676, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=30.399, x=92.905, y=-1.502, z=659.465, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=30.450, x=92.257, y=-1.550, z=661.168, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=30.502, x=91.581, y=-1.604, z=662.942, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=30.555, x=90.892, y=-1.665, z=664.753, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=30.608, x=90.214, y=-1.716, z=666.533, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=30.660, x=89.570, y=-1.761, z=668.226, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=30.710, x=88.925, y=-1.805, z=669.919, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=30.764, x=88.238, y=-1.853, z=671.725, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=30.814, x=87.604, y=-1.897, z=673.391, lx=-0.355, ly=-0.000, lz=0.935, fly=true},
    {t=30.871, x=86.956, y=-1.941, z=675.093, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=30.924, x=86.232, y=-2.006, z=676.997, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=30.980, x=85.530, y=-2.064, z=678.839, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=31.034, x=84.800, y=-2.122, z=680.756, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=31.087, x=84.158, y=-2.163, z=682.444, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=31.156, x=83.801, y=-2.490, z=683.381, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=31.233, x=82.832, y=-2.963, z=685.926, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=31.288, x=81.429, y=-3.065, z=689.612, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=31.373, x=80.946, y=-3.447, z=690.882, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=31.426, x=79.583, y=-3.535, z=694.461, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=31.476, x=78.958, y=-3.576, z=696.104, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=31.532, x=78.529, y=-3.702, z=697.231, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=31.584, x=77.546, y=-3.798, z=699.812, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=31.658, x=77.364, y=-4.261, z=700.291, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=31.710, x=75.888, y=-4.363, z=704.169, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=31.764, x=75.190, y=-4.418, z=706.003, lx=-0.356, ly=0.000, lz=0.935, fly=true},
    {t=31.817, x=74.510, y=-4.489, z=707.789, lx=-0.356, ly=0.000, lz=0.935, fly=true},
    {t=31.869, x=73.844, y=-4.540, z=709.536, lx=-0.356, ly=0.000, lz=0.935, fly=true},
    {t=31.925, x=73.150, y=-4.598, z=711.362, lx=-0.356, ly=0.000, lz=0.935, fly=true},
    {t=31.976, x=72.512, y=-4.646, z=713.038, lx=-0.356, ly=0.000, lz=0.935, fly=true},
    {t=32.027, x=71.843, y=-4.697, z=714.795, lx=-0.356, ly=0.000, lz=0.935, fly=true},
    {t=32.079, x=71.178, y=-4.758, z=716.540, lx=-0.356, ly=0.000, lz=0.935, fly=true},
    {t=32.132, x=70.488, y=-4.813, z=718.355, lx=-0.356, ly=0.000, lz=0.935, fly=true},
    {t=32.225, x=69.878, y=-5.157, z=719.956, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=32.280, x=68.564, y=-5.232, z=723.408, lx=-0.356, ly=0.000, lz=0.935, fly=true},
    {t=32.335, x=67.866, y=-5.283, z=725.241, lx=-0.356, ly=0.000, lz=0.935, fly=true},
    {t=32.409, x=67.354, y=-5.535, z=726.587, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=32.463, x=66.152, y=-5.617, z=729.744, lx=-0.356, ly=0.000, lz=0.935, fly=true},
    {t=32.517, x=65.501, y=-5.668, z=731.453, lx=-0.356, ly=0.000, lz=0.935, fly=true},
    {t=32.568, x=64.828, y=-5.766, z=733.222, lx=-0.356, ly=-0.000, lz=0.935, fly=true},
    {t=32.618, x=64.186, y=-5.814, z=734.885, lx=-0.357, ly=-0.000, lz=0.934, fly=true},
    {t=32.669, x=63.545, y=-5.858, z=736.535, lx=-0.357, ly=-0.000, lz=0.934, fly=true},
    {t=32.722, x=62.840, y=-5.913, z=738.349, lx=-0.358, ly=-0.000, lz=0.934, fly=true},
    {t=32.775, x=62.154, y=-5.964, z=740.097, lx=-0.360, ly=-0.000, lz=0.933, fly=true},
    {t=32.826, x=61.470, y=-6.012, z=741.818, lx=-0.361, ly=-0.000, lz=0.932, fly=true},
    {t=32.879, x=60.750, y=-6.066, z=743.575, lx=-0.365, ly=-0.000, lz=0.931, fly=true},
    {t=32.931, x=60.126, y=-6.121, z=745.065, lx=-0.369, ly=-0.000, lz=0.930, fly=true},
    {t=32.983, x=59.309, y=-6.189, z=746.963, lx=-0.375, ly=-0.000, lz=0.927, fly=true},
    {t=33.059, x=58.688, y=-6.410, z=748.352, lx=-0.389, ly=-0.000, lz=0.921, fly=true},
    {t=33.114, x=57.288, y=-6.492, z=751.358, lx=-0.398, ly=-0.000, lz=0.918, fly=true},
    {t=33.169, x=56.589, y=-5.851, z=752.728, lx=-0.409, ly=-0.000, lz=0.912, fly=true},
    {t=33.219, x=55.998, y=-5.033, z=753.842, lx=-0.421, ly=-0.000, lz=0.907, fly=true},
    {t=33.273, x=55.328, y=-4.113, z=755.060, lx=-0.431, ly=-0.000, lz=0.902, fly=true},
    {t=33.326, x=54.611, y=-3.383, z=756.303, lx=-0.444, ly=-0.000, lz=0.896, fly=true},
    {t=33.417, x=53.717, y=-3.724, z=757.808, lx=-0.478, ly=-0.000, lz=0.879, fly=true},
    {t=33.469, x=51.857, y=-3.802, z=760.826, lx=-0.490, ly=-0.000, lz=0.872, fly=true},
    {t=33.522, x=50.841, y=-3.857, z=762.344, lx=-0.503, ly=-0.000, lz=0.864, fly=true},
    {t=33.582, x=49.558, y=-3.966, z=764.214, lx=-0.520, ly=-0.000, lz=0.854, fly=true},
    {t=33.637, x=48.418, y=-4.027, z=765.873, lx=-0.529, ly=-0.000, lz=0.848, fly=true},
    {t=33.688, x=47.412, y=-4.075, z=767.333, lx=-0.536, ly=-0.000, lz=0.844, fly=true},
    {t=33.740, x=46.374, y=-4.132, z=768.836, lx=-0.542, ly=-0.000, lz=0.840, fly=true},
    {t=33.791, x=45.287, y=-4.190, z=770.408, lx=-0.547, ly=-0.000, lz=0.837, fly=true},
    {t=33.841, x=44.269, y=-4.241, z=771.882, lx=-0.551, ly=-0.000, lz=0.834, fly=true},
    {t=33.896, x=43.461, y=-3.424, z=773.049, lx=-0.555, ly=-0.000, lz=0.832, fly=true},
    {t=33.955, x=42.643, y=-2.513, z=774.192, lx=-0.561, ly=-0.000, lz=0.828, fly=true},
    {t=34.011, x=41.713, y=-1.526, z=775.412, lx=-0.572, ly=-0.000, lz=0.820, fly=true},
    {t=34.061, x=40.890, y=-0.694, z=776.385, lx=-0.586, ly=-0.000, lz=0.810, fly=true},
    {t=34.114, x=39.813, y=-0.270, z=777.533, lx=-0.604, ly=-0.000, lz=0.797, fly=true},
    {t=34.168, x=38.421, y=-0.324, z=778.913, lx=-0.625, ly=-0.000, lz=0.780, fly=true},
    {t=34.221, x=37.022, y=-0.375, z=780.276, lx=-0.642, ly=-0.000, lz=0.766, fly=true},
    {t=34.272, x=35.719, y=-0.429, z=781.545, lx=-0.657, ly=-0.000, lz=0.754, fly=true},
    {t=34.326, x=34.344, y=-0.470, z=782.885, lx=-0.666, ly=-0.000, lz=0.746, fly=true},
    {t=34.379, x=33.114, y=-0.535, z=784.082, lx=-0.677, ly=-0.000, lz=0.736, fly=true},
    {t=34.433, x=31.698, y=-0.603, z=785.398, lx=-0.691, ly=-0.000, lz=0.723, fly=true},
    {t=34.490, x=30.195, y=-0.397, z=786.547, lx=-0.717, ly=-0.000, lz=0.697, fly=true},
    {t=34.545, x=28.905, y=0.547, z=787.299, lx=-0.755, ly=-0.000, lz=0.656, fly=true},
    {t=34.648, x=26.632, y=1.609, z=788.445, lx=-0.839, ly=-0.000, lz=0.544, fly=true},
    {t=34.702, x=24.772, y=1.939, z=789.337, lx=-0.857, ly=-0.000, lz=0.515, fly=true},
    {t=34.759, x=22.979, y=1.872, z=790.164, lx=-0.870, ly=-0.000, lz=0.494, fly=true},
    {t=34.816, x=21.129, y=1.801, z=790.961, lx=-0.882, ly=-0.000, lz=0.472, fly=true},
    {t=34.869, x=19.319, y=1.729, z=791.666, lx=-0.894, ly=-0.000, lz=0.447, fly=true},
    {t=34.927, x=17.370, y=1.647, z=792.343, lx=-0.908, ly=-0.000, lz=0.418, fly=true},
    {t=34.986, x=15.486, y=1.566, z=792.915, lx=-0.922, ly=-0.000, lz=0.388, fly=true},
    {t=35.037, x=13.614, y=1.484, z=793.434, lx=-0.933, ly=-0.000, lz=0.359, fly=true},
    {t=35.089, x=12.065, y=1.399, z=793.855, lx=-0.941, ly=-0.000, lz=0.337, fly=true},
    {t=35.142, x=9.948, y=1.317, z=794.423, lx=-0.948, ly=-0.000, lz=0.319, fly=true},
    {t=35.200, x=7.959, y=1.225, z=794.943, lx=-0.953, ly=-0.000, lz=0.302, fly=true},
    {t=35.256, x=6.286, y=1.638, z=795.376, lx=-0.957, ly=-0.000, lz=0.290, fly=true},
    {t=35.312, x=4.850, y=2.551, z=795.748, lx=-0.960, ly=-0.000, lz=0.280, fly=true},
    {t=35.367, x=3.465, y=3.449, z=796.106, lx=-0.962, ly=-0.000, lz=0.273, fly=true},
    {t=35.424, x=2.115, y=4.305, z=796.456, lx=-0.964, ly=-0.000, lz=0.267, fly=true},
    {t=35.482, x=0.081, y=4.336, z=796.982, lx=-0.965, ly=-0.000, lz=0.263, fly=true},
    {t=35.535, x=-1.831, y=4.265, z=797.477, lx=-0.966, ly=-0.000, lz=0.260, fly=true},
    {t=35.587, x=-3.608, y=4.183, z=797.936, lx=-0.966, ly=-0.000, lz=0.258, fly=true},
    {t=35.645, x=-5.555, y=4.081, z=798.443, lx=-0.967, ly=-0.000, lz=0.257, fly=true},
    {t=35.695, x=-7.406, y=3.999, z=798.980, lx=-0.965, ly=-0.000, lz=0.264, fly=true},
    {t=35.799, x=-8.833, y=3.505, z=799.484, lx=-0.951, ly=-0.000, lz=0.308, fly=true},
    {t=35.858, x=-12.777, y=3.341, z=801.102, lx=-0.940, ly=-0.000, lz=0.342, fly=true},
    {t=35.909, x=-14.427, y=3.270, z=801.979, lx=-0.929, ly=-0.000, lz=0.371, fly=true},
    {t=35.961, x=-16.073, y=3.198, z=802.914, lx=-0.917, ly=-0.000, lz=0.398, fly=true},
    {t=36.036, x=-17.003, y=3.147, z=803.472, lx=-0.909, ly=-0.000, lz=0.417, fly=true},
    {t=36.088, x=-20.149, y=2.725, z=805.443, lx=-0.878, ly=-0.000, lz=0.479, fly=true},
    {t=36.143, x=-21.824, y=2.613, z=806.559, lx=-0.866, ly=-0.000, lz=0.499, fly=true},
    {t=36.193, x=-23.275, y=2.541, z=807.521, lx=-0.860, ly=-0.000, lz=0.511, fly=true},
    {t=36.243, x=-24.784, y=2.469, z=808.492, lx=-0.856, ly=-0.000, lz=0.517, fly=true},
    {t=36.293, x=-26.328, y=2.398, z=809.462, lx=-0.854, ly=-0.000, lz=0.520, fly=true},
    {t=36.353, x=-28.176, y=2.306, z=810.603, lx=-0.854, ly=-0.000, lz=0.521, fly=true},
    {t=36.407, x=-29.833, y=2.221, z=811.575, lx=-0.856, ly=-0.000, lz=0.517, fly=true},
    {t=36.459, x=-31.476, y=2.149, z=812.480, lx=-0.861, ly=-0.000, lz=0.509, fly=true},
    {t=36.510, x=-33.082, y=2.078, z=813.312, lx=-0.867, ly=-0.000, lz=0.498, fly=true},
    {t=36.561, x=-34.776, y=1.996, z=814.138, lx=-0.875, ly=-0.000, lz=0.483, fly=true},
    {t=36.615, x=-36.502, y=1.914, z=814.932, lx=-0.884, ly=-0.000, lz=0.468, fly=true},
    {t=36.674, x=-38.477, y=1.778, z=815.812, lx=-0.893, ly=-0.000, lz=0.450, fly=true},
    {t=36.725, x=-40.205, y=1.706, z=816.571, lx=-0.898, ly=-0.000, lz=0.440, fly=true},
    {t=36.777, x=-41.909, y=1.635, z=817.317, lx=-0.902, ly=-0.000, lz=0.431, fly=true},
    {t=36.829, x=-43.638, y=1.553, z=818.073, lx=-0.906, ly=-0.000, lz=0.424, fly=true},
    {t=36.934, x=-45.681, y=1.083, z=818.967, lx=-0.912, ly=-0.000, lz=0.411, fly=true},
    {t=36.990, x=-48.406, y=2.442, z=820.146, lx=-0.913, ly=-0.000, lz=0.407, fly=true},
    {t=37.045, x=-49.683, y=3.305, z=820.681, lx=-0.916, ly=-0.000, lz=0.402, fly=true},
    {t=37.104, x=-51.100, y=4.258, z=821.261, lx=-0.918, ly=-0.000, lz=0.396, fly=true},
    {t=37.157, x=-52.423, y=5.153, z=821.793, lx=-0.921, ly=-0.000, lz=0.390, fly=true},
    {t=37.211, x=-53.947, y=5.524, z=822.397, lx=-0.923, ly=-0.000, lz=0.385, fly=true},
    {t=37.262, x=-55.725, y=5.446, z=823.098, lx=-0.925, ly=-0.000, lz=0.381, fly=true},
    {t=37.314, x=-57.490, y=5.825, z=823.794, lx=-0.926, ly=-0.000, lz=0.379, fly=true},
    {t=37.366, x=-59.244, y=5.744, z=824.486, lx=-0.927, ly=-0.000, lz=0.376, fly=true},
    {t=37.420, x=-61.013, y=5.672, z=825.191, lx=-0.927, ly=-0.000, lz=0.375, fly=true},
    {t=37.474, x=-62.813, y=5.590, z=825.914, lx=-0.927, ly=-0.000, lz=0.374, fly=true},
    {t=37.527, x=-64.661, y=5.509, z=826.662, lx=-0.927, ly=-0.000, lz=0.375, fly=true},
    {t=37.580, x=-66.402, y=5.427, z=827.375, lx=-0.927, ly=-0.000, lz=0.376, fly=true},
    {t=37.633, x=-68.118, y=5.355, z=828.091, lx=-0.926, ly=-0.000, lz=0.378, fly=true},
    {t=37.690, x=-70.072, y=5.219, z=828.940, lx=-0.923, ly=-0.000, lz=0.385, fly=true},
    {t=37.741, x=-71.752, y=5.137, z=829.726, lx=-0.919, ly=-0.000, lz=0.395, fly=true},
    {t=37.795, x=-73.065, y=5.066, z=830.380, lx=-0.913, ly=-0.000, lz=0.407, fly=false},
    {t=37.855, x=-73.426, y=4.504, z=830.575, lx=-0.899, ly=-0.000, lz=0.437, fly=false},
    {t=37.906, x=-73.706, y=3.502, z=830.731, lx=-0.898, ly=-0.000, lz=0.440, fly=false},
    {t=37.960, x=-73.707, y=2.525, z=830.731, lx=-0.898, ly=0.000, lz=0.440, fly=false},
    {t=38.019, x=-73.992, y=2.663, z=831.130, lx=-0.835, ly=-0.000, lz=0.551, fly=false},
    {t=38.097, x=-74.458, y=2.680, z=832.094, lx=-0.641, ly=-0.000, lz=0.767, fly=false},
    {t=38.154, x=-74.717, y=2.681, z=832.822, lx=-0.519, ly=-0.000, lz=0.855, fly=false},
    {t=38.205, x=-74.853, y=2.681, z=833.583, lx=-0.395, ly=-0.000, lz=0.919, fly=false},
    {t=38.257, x=-74.937, y=2.681, z=834.411, lx=-0.284, ly=-0.000, lz=0.959, fly=false},
    {t=38.308, x=-74.996, y=2.681, z=835.123, lx=-0.216, ly=-0.000, lz=0.976, fly=false},
    {t=38.360, x=-75.049, y=2.681, z=835.835, lx=-0.167, ly=-0.000, lz=0.986, fly=false},
    {t=38.414, x=-75.094, y=2.681, z=836.547, lx=-0.131, ly=-0.000, lz=0.991, fly=false},
    {t=38.470, x=-75.139, y=2.681, z=837.379, lx=-0.102, ly=-0.000, lz=0.995, fly=false},
    {t=38.524, x=-75.181, y=2.681, z=838.211, lx=-0.082, ly=-0.000, lz=0.997, fly=false},
    {t=38.657, x=-75.253, y=2.680, z=839.757, lx=-0.058, ly=-0.000, lz=0.998, fly=false},
    {t=38.718, x=-75.299, y=2.681, z=840.708, lx=-0.053, ly=-0.000, lz=0.999, fly=false},
    {t=38.772, x=-75.349, y=2.681, z=841.539, lx=-0.056, ly=0.000, lz=0.998, fly=false},
    {t=38.827, x=-75.394, y=2.681, z=842.252, lx=-0.058, ly=0.000, lz=0.998, fly=false},
    {t=38.881, x=-75.446, y=2.681, z=843.083, lx=-0.060, ly=0.000, lz=0.998, fly=false},
    {t=38.935, x=-75.499, y=2.681, z=843.915, lx=-0.061, ly=0.000, lz=0.998, fly=false},
    {t=38.985, x=-75.536, y=2.681, z=844.509, lx=-0.062, ly=-0.000, lz=0.998, fly=false},
    {t=39.039, x=-75.588, y=2.681, z=845.340, lx=-0.062, ly=-0.000, lz=0.998, fly=false},
    {t=39.094, x=-75.641, y=2.681, z=846.171, lx=-0.062, ly=0.000, lz=0.998, fly=false},
    {t=39.145, x=-75.686, y=2.681, z=846.884, lx=-0.063, ly=0.000, lz=0.998, fly=false},
    {t=39.198, x=-75.732, y=2.681, z=847.597, lx=-0.063, ly=0.000, lz=0.998, fly=false},
    {t=39.284, x=-75.811, y=2.681, z=848.784, lx=-0.065, ly=-0.000, lz=0.998, fly=false},
    {t=39.334, x=-75.858, y=2.681, z=849.496, lx=-0.066, ly=-0.000, lz=0.998, fly=false},
    {t=39.385, x=-75.906, y=2.681, z=850.209, lx=-0.066, ly=-0.000, lz=0.998, fly=false},
    {t=39.440, x=-75.962, y=2.681, z=851.040, lx=-0.066, ly=0.000, lz=0.998, fly=false},
    {t=39.491, x=-76.009, y=2.681, z=851.752, lx=-0.067, ly=0.000, lz=0.998, fly=false},
    {t=39.593, x=-76.108, y=2.681, z=853.176, lx=-0.068, ly=-0.000, lz=0.998, fly=false},
    {t=39.650, x=-76.167, y=2.681, z=854.007, lx=-0.069, ly=0.000, lz=0.998, fly=false},
    {t=39.711, x=-76.234, y=2.681, z=854.957, lx=-0.070, ly=0.000, lz=0.998, fly=false},
    }
end
local function prepareAutoEscapePoint(point)
    if not point.pos then
        point.pos = Vector3.new(point.x, point.y, point.z)
        point.look = Vector3.new(point.lx, point.ly, point.lz)
        point.time = point.t
    end
    return point
end
local AutoEscapeRoutes = {
    {name = "Path A", pos = Vector3.new(320.072, 2.721, -184.436), radius = 5, createRaw = createAutoEscapeRawPathA},
    {name = "Path B", pos = Vector3.new(318.868, 2.721, -337.072), radius = 5, createRaw = createAutoEscapeRawPathB}
}
local AutoEscape = {
    Enabled = false,
    Blocked = true,
    Replaying = false,
    Path = {},
    Route = AutoEscapeRoutes[1],
    ReplaySpeed = 1,
    Task = nil,
    LastRouteName = nil
}
local function isAutoEscapeClassD()
    return Player.Team and Player.Team.Name == "Class - D"
end
local function stopAutoEscapeReplay()
    if AutoEscape.Task then
        pcall(task.cancel, AutoEscape.Task)
        AutoEscape.Task = nil
    end
    AutoEscape.Replaying = false
end
local function startAutoEscapeReplay()
    local path = AutoEscape.Path
    if #path == 0 or AutoEscape.Replaying then return end
    stopAutoEscapeReplay()
    AutoEscape.Replaying = true
    local replayCharacter = Player.Character
    if not replayCharacter then
        AutoEscape.Replaying = false
        return
    end
    local speed = AutoEscape.ReplaySpeed or 1
    AutoEscape.Task = task.spawn(function()
        local character = Player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local first = path[1]
        if not root or not first or not AutoEscape.Replaying or BuloHubUnloaded
            or Player.Character ~= replayCharacter then
            AutoEscape.Replaying = false
            AutoEscape.Task = nil
            return
        end
        first = prepareAutoEscapePoint(first)
        pcall(function()
            root.CFrame = CFrame.lookAt(first.pos, first.pos + first.look)
            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end)
        RS.RenderStepped:Wait()
        for index = 2, #path do
            if not AutoEscape.Replaying then break end
            if Player.Character ~= replayCharacter then
                AutoEscape.Replaying = false
                return
            end
            local previous = prepareAutoEscapePoint(path[index - 1])
            local point = prepareAutoEscapePoint(path[index])
            local segmentDuration = (point.time - previous.time) / speed
            if segmentDuration <= 0 then continue end
            local started = tick()
            if point.fly == false then
                local distance = (point.pos - previous.pos).Magnitude
                local walkSpeed = math.clamp(distance / segmentDuration, 16, 100)
                while tick() - started < segmentDuration do
                    if not AutoEscape.Replaying then break end
                    if Player.Character ~= replayCharacter then
                        AutoEscape.Replaying = false
                        return
                    end
                    local currentCharacter = Player.Character
                    local humanoid = currentCharacter and currentCharacter:FindFirstChildOfClass("Humanoid")
                    if not humanoid then break end
                    if humanoid.Health <= 0 then
                        AutoEscape.Replaying = false
                        return
                    end
                    pcall(function()
                        humanoid.WalkSpeed = walkSpeed
                        humanoid.PlatformStand = false
                        humanoid.AutoRotate = true
                        humanoid:MoveTo(point.pos)
                        if humanoid.Health < humanoid.MaxHealth then humanoid.Health = humanoid.MaxHealth end
                    end)
                    RS.RenderStepped:Wait()
                end
            else
                while true do
                    local elapsed = tick() - started
                    if elapsed >= segmentDuration then break end
                    if not AutoEscape.Replaying then break end
                    if Player.Character ~= replayCharacter then
                        AutoEscape.Replaying = false
                        return
                    end
                    local currentCharacter = Player.Character
                    local currentRoot = currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart")
                    local humanoid = currentCharacter and currentCharacter:FindFirstChildOfClass("Humanoid")
                    if not currentRoot then break end
                    if humanoid and humanoid.Health <= 0 then
                        AutoEscape.Replaying = false
                        return
                    end
                    local alpha = math.clamp(elapsed / segmentDuration, 0, 1)
                    local position = previous.pos:Lerp(point.pos, alpha)
                    local look = previous.look:Lerp(point.look, alpha)
                    if look.Magnitude > 0 then look = look.Unit end
                    pcall(function()
                        currentRoot.CFrame = CFrame.lookAt(position, position + look)
                        currentRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        currentRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        if humanoid and humanoid.Health < humanoid.MaxHealth then humanoid.Health = humanoid.MaxHealth end
                    end)
                    RS.RenderStepped:Wait()
                end
            end
        end
        AutoEscape.Replaying = false
        AutoEscape.Task = nil
        if AutoEscape.Enabled then
            task.wait(0.3)
            local currentCharacter = Player.Character
            local humanoid = currentCharacter and currentCharacter:FindFirstChildOfClass("Humanoid")
            if humanoid then
                pcall(function() humanoid.Health = 0 end)
            end
        end
    end)
end
local function startAutoEscape(route)
    AutoEscape.Blocked = false
    AutoEscape.Enabled = true
    local selected = route or AutoEscape.Route or AutoEscapeRoutes[1]
    if not selected.path then selected.path = selected.createRaw() end
    AutoEscape.Path = selected.path
    AutoEscape.Route = selected
    if route then AutoEscape.LastRouteName = route.name end
    if #AutoEscape.Path == 0 then
        AutoEscape.Enabled = false
        return
    end
    startAutoEscapeReplay()
end
local function stopAutoEscape()
    AutoEscape.Enabled = false
    AutoEscape.Blocked = true
    AutoEscape.LastRouteName = nil
    stopAutoEscapeReplay()
end
local function toggleAutoEscape()
    if AutoEscape.Enabled or AutoEscape.Replaying then
        stopAutoEscape()
    elseif isAutoEscapeClassD() then
        startAutoEscape(nil)
    end
end
local function findNearbyAutoEscapeRoute()
    local character = Player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    for _, route in ipairs(AutoEscapeRoutes) do
        if (root.Position - route.pos).Magnitude <= route.radius then
            return route
        end
    end
    return nil
end
BuloTrackConnection(RS.Heartbeat:Connect(function()
    if BuloHubUnloaded or AutoEscape.Replaying or AutoEscape.Blocked then return end
    local route = findNearbyAutoEscapeRoute()
    if route then
        if AutoEscape.LastRouteName ~= route.name and not AutoEscape.Enabled then
            AutoEscape.LastRouteName = route.name
            startAutoEscape(route)
        end
    else
        AutoEscape.LastRouteName = nil
    end
end))
BuloTrackConnection(Player.CharacterAdded:Connect(function()
    stopAutoEscapeReplay()
    task.spawn(function()
        task.wait(1)
        if not BuloHubUnloaded and AutoEscape.Enabled and #AutoEscape.Path > 0 then
            startAutoEscapeReplay()
        end
    end)
end))
do
    local rotations = setmetatable({}, {__mode="k"})
    local function BuloAcquireRotation(hum, owner)
        if not hum then return end
        local entry = rotations[hum]
        if not entry then
            entry = {original=hum.AutoRotate, owners={}}
            rotations[hum] = entry
        end
        entry.owners[owner] = true
    end
    local function BuloReleaseRotation(hum, owner)
        local entry = hum and rotations[hum]
        if not entry then return end
        entry.owners[owner] = nil
        if not next(entry.owners) then
            pcall(function() hum.AutoRotate = entry.original end)
            rotations[hum] = nil
        elseif entry.owners.fly then
            pcall(function() hum.AutoRotate = false end)
        else
            local anti = BuloExtra and BuloExtra.Anti
            local controlled = anti and anti.antiState and anti.antiState.controlling
            pcall(function() hum.AutoRotate = not controlled end)
        end
    end
local function SetupNewFly()
    local api = {}
    local state, generation, errors = nil, 0, 0
    local function detach(old)
        if not old then return end
        for _, name in ipairs({"render", "heartbeat"}) do
            pcall(function() if old[name] then old[name]:Disconnect() end end)
        end
        pcall(function() if old.idleTrack then old.idleTrack:Stop(0.1) end end)
        for _, name in ipairs({"velocity", "orientation", "attachment"}) do
            pcall(function() if old[name] then old[name]:Destroy() end end)
        end
        pcall(function()
            if old.animate and old.animate.Parent then old.animate.Disabled = old.animateDisabled end
        end)
        pcall(function()
            if old.hum and old.rotationAcquired then
                BuloReleaseRotation(old.hum, "fly")
                old.rotationAcquired = false
            end
            if old.hum and old.hum.Parent then
                old.hum.PlatformStand = old.platformStand
                old.hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
        pcall(function()
            if old.root and old.root.Parent then
                old.root.AssemblyLinearVelocity = Vector3.zero
                old.root.AssemblyAngularVelocity = Vector3.zero
            end
        end)
    end
    local function attach(char)
        if not flyActive or BuloHubUnloaded or not char then return nil end
        local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
            or char:FindFirstChild("Torso") or char:FindFirstChild("LowerTorso")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return nil end
        local st = {char=char, root=root, hum=hum, platformStand=hum.PlatformStand}
        BuloAcquireRotation(hum, "fly")
        st.rotationAcquired = true
        local ok, err = pcall(function()
            st.attachment = Instance.new("Attachment")
            st.attachment.Name = "BuloFlyAttachment"
            st.attachment.Parent = root
            st.velocity = Instance.new("LinearVelocity")
            st.velocity.Name = "BuloFlyVelocity"
            st.velocity.Attachment0 = st.attachment
            st.velocity.MaxForce = math.huge
            st.velocity.VectorVelocity = Vector3.zero
            pcall(function() st.velocity.RelativeTo = Enum.ActuatorRelativeTo.World end)
            st.velocity.Parent = root
            st.orientation = Instance.new("AlignOrientation")
            st.orientation.Name = "BuloFlyOrientation"
            st.orientation.Attachment0 = st.attachment
            pcall(function() st.orientation.Mode = Enum.OrientationAlignmentMode.OneAttachment end)
            st.orientation.Responsiveness = 150
            st.orientation.MaxTorque = math.huge
            st.orientation.CFrame = root.CFrame
            st.orientation.Parent = root
            st.animate = char:FindFirstChild("Animate")
            if st.animate then
                st.animateDisabled = st.animate.Disabled
                st.animate.Disabled = true
            end
            hum.AutoRotate = false
        end)
        if not ok then
            detach(st)
            warn("[Ixa hub] Fly setup: " .. tostring(err))
            return nil
        end
        local function muteMovementAnimations()
            local animator = hum:FindFirstChildOfClass("Animator")
            if not animator then return end
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                local name = string.lower(track.Name or "")
                if track.Priority == Enum.AnimationPriority.Movement or name:find("run")
                    or name:find("walk") or name:find("sprint") or name:find("jog")
                    or name:find("fall") or name:find("jump") then
                    pcall(function() track:Stop(0) end)
                end
            end
        end
        pcall(muteMovementAnimations)
        pcall(function()
            local animator = hum:FindFirstChildOfClass("Animator")
            local idle = st.animate and st.animate:FindFirstChild("idle")
            local animation = idle and idle:FindFirstChildOfClass("Animation")
            if animator and animation then
                st.idleTrack = animator:LoadAnimation(animation)
                st.idleTrack.Priority = Enum.AnimationPriority.Idle
                st.idleTrack.Looped = true
                st.idleTrack:Play(0.1)
            end
        end)
        local lastMute = 0
        st.heartbeat = RS.Heartbeat:Connect(function()
            if flyActive and not BuloHubUnloaded and char.Parent and tick() - lastMute >= 0.1 then
                lastMute = tick()
                pcall(muteMovementAnimations)
            end
        end)
        st.render = RS.RenderStepped:Connect(function()
            if BuloHubUnloaded or not flyActive then return end
            local okStep, errStep = pcall(function()
                if Player.Character ~= char or not root.Parent or not hum.Parent or hum.Health <= 0 then
                    api.Rebind()
                    return
                end
                local anti = BuloExtra and BuloExtra.Anti
                local controlled = anti and anti.antiOn and anti.antiState and anti.antiState.controlling
                if st.orientation.Enabled ~= not controlled then st.orientation.Enabled = not controlled end
                local camera = workspace.CurrentCamera or Camera
                local cf = camera and camera.CFrame or root.CFrame
                local flat = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z)
                if flat.Magnitude > 0.05 then
                    st.orientation.CFrame = CFrame.lookAt(root.Position, root.Position + flat.Unit)
                end
                local movement = Vector3.zero
                local md = hum.MoveDirection
                local fwd = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z)
                local right = Vector3.new(cf.RightVector.X, 0, cf.RightVector.Z)
                if md and md.Magnitude > 0.05 and fwd.Magnitude > 0.01 and right.Magnitude > 0.01 then
                    movement = cf.LookVector * md:Dot(fwd.Unit) + cf.RightVector * md:Dot(right.Unit)
                elseif flyInputState.forward or flyInputState.backward or flyInputState.left or flyInputState.right then
                    if flyInputState.forward then movement += cf.LookVector end
                    if flyInputState.backward then movement -= cf.LookVector end
                    if flyInputState.right then movement += cf.RightVector end
                    if flyInputState.left then movement -= cf.RightVector end
                end
                if UIS:IsKeyDown(Enum.KeyCode.Space) or flyInputState.up then movement += Vector3.new(0, 1, 0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.LeftShift) or flyInputState.down then
                    movement -= Vector3.new(0, 1, 0)
                end
                st.velocity.VectorVelocity = movement.Magnitude > 0.05 and movement.Unit * Cfg.FlySpeed or Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end)
            if not okStep then
                errors += 1
                if errors <= 3 then warn("[Ixa hub] Fly: " .. tostring(errStep)) end
                if errors > 60 then
                    pcall(function() api.Set(false) end)
                end
            end
        end)
        return st
    end
    function api.Rebind()
        if not flyActive or BuloHubUnloaded then return end
        generation += 1
        local myGeneration = generation
        detach(state)
        state = nil
        task.spawn(function()
            task.wait(0.25)
            while flyActive and not BuloHubUnloaded and generation == myGeneration do
                local char = Player.Character
                if char then
                    local newState = attach(char)
                    if newState then
                        if generation ~= myGeneration or not flyActive or BuloHubUnloaded then
                            detach(newState)
                        else
                            state = newState
                        end
                        return
                    end
                end
                task.wait(0.5)
            end
        end)
    end
    function api.Set(on)
        if not on then
            generation += 1
            flyActive = false
            detach(state)
            state = nil
            for k in pairs(flyInputState) do flyInputState[k] = false end
            return
        end
        if flyActive then return end
        flyActive = true
        errors = 0
        state = attach(Player.Character)
        if not state then api.Rebind() end
    end
    function api.Cleanup() api.Set(false) end
    return api
end
local function SetupAutoInteractions()
    local api = {hack = false, prompt = false}
    local generation = 0
    local busy = setmetatable({}, {__mode = "k"})
    local deny = {"team", "spawn", "shop", "buy", "sell", "store", "rank", "morph", "class", "job", "role", "become", "switchteam", "changeteam"}
    local hackTerms = {"c4", "transformer", "router", "generator", "gas"}
    local overlap = OverlapParams.new()
    local overlapCharacter
    overlap.FilterType = Enum.RaycastFilterType.Exclude
    local function activate(object)
        if not object or not object.Parent then return end
        if object:IsA("ProximityPrompt") then
            if not object.Enabled then return end
            if fireproximityprompt then
                pcall(fireproximityprompt, object)
            elseif not busy[object] then
                busy[object] = true
                task.spawn(function()
                    pcall(function()
                        object:InputHoldBegin()
                        task.wait((object.HoldDuration or 0) + 0.05)
                        object:InputHoldEnd()
                    end)
                    busy[object] = nil
                end)
            end
        elseif object:IsA("ClickDetector") and fireclickdetector then
            pcall(fireclickdetector, object)
        end
    end
    local function check(object, part)
        if not object:IsA("ProximityPrompt") and not object:IsA("ClickDetector") then return end
        local objectName = object.Name:lower()
        local partName = part.Name:lower()
        local parent = part.Parent
        local modelName = parent and parent:IsA("Model") and parent.Name:lower() or ""
        local names = objectName .. "|" .. partName .. "|" .. modelName
        if api.hack then
            for _, term in ipairs(hackTerms) do
                if names:find(term, 1, true) then
                    activate(object)
                    return
                end
            end
        end
        if api.prompt then
            local labels = names
            if object:IsA("ProximityPrompt") then
                labels ..= "|" .. (object.ActionText or ""):lower() .. "|" .. (object.ObjectText or ""):lower()
            end
            for _, bad in ipairs(deny) do
                if labels:find(bad, 1, true) then return end
            end
            activate(object)
        end
    end
    local function restart()
        generation += 1
        if not (api.hack or api.prompt) or BuloHubUnloaded then
            if overlapCharacter then
                overlapCharacter = nil
                overlap.FilterDescendantsInstances = {}
            end
            return
        end
        local myGeneration = generation
        task.spawn(function()
            while not BuloHubUnloaded and generation == myGeneration and (api.hack or api.prompt) do
                pcall(function()
                    local char = Player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if not root then return end
                    if overlapCharacter ~= char then
                        overlap.FilterDescendantsInstances = {char}
                        overlapCharacter = char
                    end
                    local parts = workspace:GetPartBoundsInRadius(root.Position, 16, overlap)
                    local visitedItems, visitedModels = {}, {}
                    for _, part in ipairs(parts) do
                        for _, child in ipairs(part:GetChildren()) do
                            if (child:IsA("ProximityPrompt") or child:IsA("ClickDetector")) and not visitedItems[child] then
                                visitedItems[child] = true
                                check(child, part)
                            end
                        end
                        local model = part.Parent
                        if model and model:IsA("Model") and not visitedModels[model] then
                            visitedModels[model] = true
                            for _, child in ipairs(model:GetChildren()) do
                                if (child:IsA("ProximityPrompt") or child:IsA("ClickDetector")) and not visitedItems[child] then
                                    visitedItems[child] = true
                                    check(child, part)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.2)
            end
        end)
    end
    function api.SetHack(on) api.hack = on and true or false; restart() end
    function api.SetPrompt(on) api.prompt = on and true or false; restart() end
    function api.Cleanup() api.hack = false; api.prompt = false; restart() end
    return api
end
local function SetupAntiSCP()
    local anti = {}
anti.antiOn = false
anti.antiState = nil
anti.antiConfig = {
    DIST_173 = 95, DIST_096 = 85, MIN_TOUCH_173 = 3.8, DANGER_FOV_096 = 38,
    JUKE_SPEED = 55, JUKE_CD = 1.4, JUKE_TRIGGER = 35,
    PUSH_049 = 95, BUFFER_049 = Vector3.new(20, 12, 20),
    HUB_EXIT = Vector3.new(-12907.3, 21.9, -3256.1)
}
anti.startAnti = function()
    local HUB = anti
    if HUB.antiState then return HUB.antiState end
    local CFG = HUB.antiConfig
    local st = {
        cache173 = nil, part173 = nil, cache096 = nil, cache049 = nil, part049 = nil,
        zone = nil, markers = {}, joint = nil, jointC0 = nil, lastChar = nil,
        last173Pos = nil, lastJuke = 0, lastPD = 0, conn = nil
    }
    local function nowSec()
        local okT, t = pcall(function() return workspace.DistributedGameTime end)
        if okT and type(t) == "number" and t > 0 then return t end
        local ok2, t2 = pcall(function() return tick() end)
        if ok2 and type(t2) == "number" then return t2 end
        return 0
    end
    local function lookCF(from, to)
        local okA, cf = pcall(function() return CFrame.lookAt(from, to) end)
        if okA and cf then return cf end
        local okB, cf2 = pcall(function() return CFrame.new(from, to) end)
        if okB and cf2 then return cf2 end
        return from and CFrame.new(from) or CFrame.new(0, 0, 0)
    end
    local function angCF(x, y, z)
        local okA, cf = pcall(function() return CFrame.Angles(x, y, z) end)
        if okA and cf then return cf end
        local okB, cf2 = pcall(function() return CFrame.fromEulerAnglesXYZ(x, y, z) end)
        if okB and cf2 then return cf2 end
        return CFrame.new(0, 0, 0)
    end
    local rayParams
    pcall(function()
        rayParams = RaycastParams.new()
        local okE, e = pcall(function() return Enum.RaycastFilterType.Exclude end)
        if not okE then
            local okE2, e2 = pcall(function() return Enum.RaycastFilterType.Blacklist end)
            e = okE2 and e2 or nil
        end
        if e then rayParams.FilterType = e end
        rayParams.IgnoreWater = true
    end)
    local function rayHit(from, dir, ignore)
        if not rayParams then return nil end
        local okR, res = pcall(function()
            rayParams.FilterDescendantsInstances = ignore or {}
            return workspace:Raycast(from, dir, rayParams)
        end)
        if okR and res then return res end
        return nil
    end
    local function hasLOS(from, to, ignore)
        local dir = to - from
        local remain = dir.Magnitude
        if remain < 0.1 then return true end
        local curDir = dir.Unit
        local curFrom = from
        local ign = {}
        for _, v in ipairs(ignore or {}) do ign[#ign + 1] = v end
        for _ = 1, 4 do
            local res = rayHit(curFrom, curDir * remain, ign)
            if not res then return true end
            local hitPart = res.Instance or res.Part
            local trans, collide = 0, true
            pcall(function() trans = hitPart.Transparency end)
            pcall(function() collide = hitPart.CanCollide end)
            if trans > 0.5 or collide == false then
                ign[#ign + 1] = hitPart
                remain = remain - (res.Position - curFrom).Magnitude
                curFrom = res.Position + curDir * 0.05
                if remain <= 0.2 then return true end
            else
                return false
            end
        end
        return true
    end
    local function findSCP(names)
        local folder = workspace:FindFirstChild("SCPs")
        for _, nm in ipairs(names) do
            local found = (folder and folder:FindFirstChild(nm)) or workspace:FindFirstChild(nm)
            if found then return found end
        end
        return nil
    end
    local function get173()
        if st.cache173 and st.cache173.Parent then return st.cache173, st.part173 end
        local scp = findSCP({ "SCP-173", "173" })
        st.cache173 = scp
        st.part173 = scp and (scp.PrimaryPart or scp:FindFirstChild("Head")
            or scp:FindFirstChildWhichIsA("BasePart")) or nil
        return st.cache173, st.part173
    end
    local function get096()
        if st.cache096 and st.cache096.Parent then return st.cache096 end
        st.cache096 = findSCP({ "SCP-096", "096" })
        return st.cache096
    end
    local function get049()
        if st.cache049 and st.cache049.Parent then return st.cache049, st.part049 end
        st.cache049 = findSCP({ "SCP-049", "049" })
        st.part049 = st.cache049 and (st.cache049.PrimaryPart or st.cache049:FindFirstChild("HumanoidRootPart")
            or st.cache049:FindFirstChild("Torso") or st.cache049:FindFirstChildWhichIsA("BasePart")) or nil
        return st.cache049, st.part049
    end
    local function is096Calm(scp)
        local bag = scp:FindFirstChild("Bag")
        if not bag then return false end
        local part = bag
        if not bag:IsA("BasePart") then
            part = bag:FindFirstChild("Handle") or bag:FindFirstChildWhichIsA("BasePart")
        end
        if not part then return false end
        local okT, tr = pcall(function() return part.Transparency end)
        return (not okT) or tr >= 0.8
    end
    local function getRootJoint(char)
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        return root:FindFirstChild("RootJoint") or root:FindFirstChild("Root")
            or (char:FindFirstChild("LowerTorso") and char.LowerTorso:FindFirstChild("Root"))
    end
    local function zone049(part049)
        if not st.zone or not st.zone.Parent then
            local p = Instance.new("Part")
            p.Name = "SCP049_BoxHitbox"
            p.Shape = Enum.PartType.Block
            p.Anchored = true
            p.CanCollide = false
            p.CanQuery = false
            p.CanTouch = false
            p.Transparency = 0.6
            p.Material = Enum.Material.ForceField
            p.Color = Color3.fromRGB(0, 255, 180)
            p.Parent = workspace
            st.zone = p
        end
        st.zone.Size = CFG.BUFFER_049
        st.zone.CFrame = part049.CFrame
        return st.zone
    end
    local function process049(root, rootPos)
        local scp, part = get049()
        if not scp or not part then
            if st.zone then
                pcall(function() st.zone:Destroy() end)
                st.zone = nil
            end
            return
        end
        local zone = zone049(part)
        local okRel, rel = pcall(function() return part.CFrame:PointToObjectSpace(rootPos) end)
        local inside = false
        if okRel and rel then
            inside = math.abs(rel.X) <= CFG.BUFFER_049.X * 0.5
                and math.abs(rel.Y) <= CFG.BUFFER_049.Y * 0.5
                and math.abs(rel.Z) <= CFG.BUFFER_049.Z * 0.5
        end
        if inside then
            local diff = Vector3.new(rootPos.X - part.Position.X, 0, rootPos.Z - part.Position.Z)
            local pushDir = (diff.Magnitude > 0.05) and diff.Unit or -part.CFrame.LookVector
            pcall(function()
                root.AssemblyLinearVelocity = pushDir * CFG.PUSH_049 + Vector3.new(0, 12, 0)
            end)
            pcall(function() zone.Color = Color3.fromRGB(255, 30, 30) end)
        else
            pcall(function() zone.Color = Color3.fromRGB(0, 255, 180) end)
        end
    end
    local function processJuke(root, rootPos, pos173, char)
        if not st.last173Pos then return end
        local moved = (pos173 - st.last173Pos).Magnitude
        local dist = (rootPos - pos173).Magnitude
        if moved < 11 or dist > CFG.JUKE_TRIGGER then return end
        if nowSec() - st.lastJuke < CFG.JUKE_CD then return end
        local atk = Vector3.new(rootPos.X - pos173.X, 0, rootPos.Z - pos173.Z)
        if atk.Magnitude < 0.1 then return end
        atk = atk.Unit
        local right = Vector3.new(-atk.Z, 0, atk.X)
        local left = -right
        local hitR = rayHit(rootPos, right * 12, { char })
        local hitL = rayHit(rootPos, left * 12, { char })
        local chosen = right
        if hitR and not hitL then
            chosen = left
        elseif hitR and hitL then
            chosen = atk
        end
        pcall(function()
            root.AssemblyLinearVelocity = chosen * CFG.JUKE_SPEED + Vector3.new(0, 12, 0)
        end)
        st.lastJuke = nowSec()
    end
    local function markPD(cf, size, safe, adornee)
        local m = Instance.new("Part")
        m.Name = "PD_ActiveMarker"
        m.Shape = Enum.PartType.Block
        m.Size = size
        m.CFrame = cf
        m.Anchored = true
        m.CanCollide = false
        m.CanQuery = false
        m.CanTouch = false
        m.Material = Enum.Material.Neon
        m.Transparency = 0.65
        m.Color = safe and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 40, 40)
        m.Parent = adornee or workspace
        st.markers[#st.markers + 1] = m
    end
    local function cleanPD()
        for _, m in ipairs(st.markers) do pcall(function() m:Destroy() end) end
        st.markers = {}
    end
    local function solvePD(char, rootPos)
        local now = nowSec()
        if now - st.lastPD < 0.6 then return end
        st.lastPD = now
        local dim = st.pdDimension
        if dim and (not dim.Parent or not dim:IsDescendantOf(workspace)) then
            dim = nil
            st.pdDimension = nil
        end
        if not dim and (not st.lastPDSearch or now - st.lastPDSearch >= 2) then
            st.lastPDSearch = now
            for _, nm in ipairs({ "106 Dimension", "106Dimension", "Pocket Dimension", "PocketDimension" }) do
                dim = workspace:FindFirstChild(nm, true)
                if dim then break end
            end
            st.pdDimension = dim
        end
        local nearHub = (rootPos - CFG.HUB_EXIT).Magnitude < 1200
        local targets = {}
        if dim then
            for _, obj in ipairs(dim:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name ~= "PD_ActiveMarker" then
                    local nm = obj.Name:lower()
                    if nm:find("exit") or nm:find("door") or nm:find("hall") or nm:find("portal") then
                        local safe = (nm:find("exit") ~= nil) and not (nm:find("fake") or nm:find("trap"))
                        if not safe then
                            pcall(function()
                                safe = obj:GetAttribute("Correct") == true or obj:GetAttribute("Safe") == true
                                    or obj:GetAttribute("Exit") == true
                            end)
                        end
                        table.insert(targets, {owner=obj, cf=obj.CFrame, size=obj.Size, safe=safe})
                        if #targets >= 6 then break end
                    end
                end
            end
        end
        if #targets == 0 and nearHub then
            table.insert(targets, {owner=workspace, cf=lookCF(CFG.HUB_EXIT, CFG.HUB_EXIT + Vector3.new(0, 1, 0)),
                size=Vector3.new(21, 42, 10), safe=true})
        end
        local rebuild = #st.markers ~= #targets
        if not rebuild then
            for i, target in ipairs(targets) do
                if not st.markers[i] or st.markers[i].Parent ~= target.owner then rebuild = true; break end
            end
        end
        if rebuild then
            cleanPD()
            for _, target in ipairs(targets) do markPD(target.cf, target.size, target.safe, target.owner) end
        else
            for i, target in ipairs(targets) do
                local marker = st.markers[i]
                pcall(function()
                    if marker.CFrame ~= target.cf then marker.CFrame = target.cf end
                    if marker.Size ~= target.size then marker.Size = target.size end
                    local color = target.safe and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 40, 40)
                    if marker.Color ~= color then marker.Color = color end
                end)
            end
        end
    end
    local function antiStep()
        if BuloHubUnloaded then return end
        if not HUB.antiOn then return end
        local char = Player.Character
        if not char then
            st.controlling = false
            if st.rotationHum then BuloReleaseRotation(st.rotationHum, "anti"); st.rotationHum = nil end
            return
        end
        local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
        local hum = char:FindFirstChildOfClass("Humanoid")
        local head = char:FindFirstChild("Head")
        if not root or not hum then st.controlling = false; return end
        if st.rotationHum ~= hum then
            if st.rotationHum then BuloReleaseRotation(st.rotationHum, "anti") end
            st.rotationHum = hum
            BuloAcquireRotation(hum, "anti")
        end
        local okH, hp = pcall(function() return hum.Health end)
        if okH and (not hp or hp <= 0) then return end
        local rootPos = root.Position
        local myHead = head and head.Position or (rootPos + Vector3.new(0, 1.5, 0))
        if st.lastChar ~= char then
            st.lastChar = char
            st.joint = getRootJoint(char)
            local okJ, c0 = pcall(function() return st.joint and st.joint.C0 end)
            st.jointC0 = (okJ and c0) or nil
        end
        solvePD(char, rootPos)
        process049(root, rootPos)
        local dist173, scp173, part173 = 0, get173()
        local active173 = false
        if part173 then
            dist173 = (part173.Position - myHead).Magnitude
            if dist173 <= CFG.DIST_173 and hasLOS(myHead, part173.Position, { char, scp173 }) then
                active173 = true
            end
            processJuke(root, rootPos, part173.Position, char)
            st.last173Pos = part173.Position
        else
            st.last173Pos = nil
        end
        local active096, torso096, head096Pos = false, nil, nil
        local scp096 = get096()
        if scp096 and not is096Calm(scp096) then
            local h96 = scp096:FindFirstChild("Head") or scp096:FindFirstChildWhichIsA("BasePart")
            torso096 = scp096:FindFirstChild("UpperTorso") or scp096:FindFirstChild("Torso")
                or scp096.PrimaryPart or h96
            if h96 and torso096 and (torso096.Position - rootPos).Magnitude <= CFG.DIST_096 then
                head096Pos = h96.Position + Vector3.new(0, 0.4, 0)
                if hasLOS(myHead, head096Pos, { char, scp096 })
                    or hasLOS(myHead, torso096.Position, { char, scp096 }) then
                    active096 = true
                end
            end
        end
        local function lookAtPoint(pt, pitchBias)
            local flat = Vector3.new(pt.X - rootPos.X, 0, pt.Z - rootPos.Z)
            local rootCF = (flat.Magnitude > 0.05) and lookCF(rootPos, Vector3.new(pt.X, rootPos.Y, pt.Z)) or root.CFrame
            pcall(function() root.CFrame = rootCF end)
            if st.joint and st.jointC0 then
                local fullCF = lookCF(myHead, pt)
                local okRel, rel = pcall(function() return rootCF:ToObjectSpace(fullCF) end)
                if okRel and rel then
                    local okO, pitch, yaw = pcall(function()
                        local a, b, c = rel:ToOrientation()
                        return a, b
                    end)
                    if okO and pitch then
                        pcall(function()
                            st.joint.C0 = st.jointC0 * angCF(pitch + (pitchBias or 0), yaw or 0, 0)
                        end)
                    end
                end
            end
        end
        st.controlling = active173 or active096
        if active173 and active096 then
            pcall(function() hum.AutoRotate = false end)
            pcall(function() root.AssemblyAngularVelocity = Vector3.new(0, 0, 0) end)
            if dist173 < CFG.MIN_TOUCH_173 then
                local push = Vector3.new(rootPos.X - part173.Position.X, 0, rootPos.Z - part173.Position.Z)
                if push.Magnitude > 0.05 then
                    pcall(function() root.AssemblyLinearVelocity = push.Unit * 9 end)
                end
            end
            local dirTo096 = (head096Pos - myHead).Unit
            local pts = {
                part173.Position - Vector3.new(0, part173.Size.Y * 0.48, 0),
                part173.Position - Vector3.new(0, part173.Size.Y * 0.25, 0),
                part173.Position,
                part173.Position - Vector3.new(0, part173.Size.Y * 0.6, 0)
            }
            local best, bestAngle = pts[1], -1
            for _, pt in ipairs(pts) do
                local okA, ang = pcall(function()
                    local d = (pt - myHead).Unit
                    local dot = math.max(-1, math.min(1, d:Dot(dirTo096)))
                    return math.deg(math.acos(dot))
                end)
                if okA and ang and ang > bestAngle and hasLOS(myHead, pt, { char, scp173 }) then
                    bestAngle, best = ang, pt
                end
            end
            if bestAngle < CFG.DANGER_FOV_096 then
                best = part173.Position - Vector3.new(0, part173.Size.Y * 0.6, 0)
            end
            lookAtPoint(best, 0)
            return
        elseif active173 then
            pcall(function() hum.AutoRotate = false end)
            pcall(function() root.AssemblyAngularVelocity = Vector3.new(0, 0, 0) end)
            if dist173 < CFG.MIN_TOUCH_173 then
                local push = Vector3.new(rootPos.X - part173.Position.X, 0, rootPos.Z - part173.Position.Z)
                if push.Magnitude > 0.05 then
                    pcall(function() root.AssemblyLinearVelocity = push.Unit * 8 end)
                end
            end
            lookAtPoint(part173.Position, 0)
            return
        elseif active096 then
            pcall(function() hum.AutoRotate = false end)
            pcall(function() root.AssemblyAngularVelocity = Vector3.new(0, 0, 0) end)
            local away = Vector3.new(rootPos.X - torso096.Position.X, 0, rootPos.Z - torso096.Position.Z)
            local awayDir = (away.Magnitude > 0.1) and away.Unit or Vector3.new(0, 0, 1)
            local rootCF = lookCF(rootPos, rootPos + awayDir * 10)
            pcall(function() root.CFrame = rootCF end)
            local dY = torso096.Position.Y - rootPos.Y
            local pitch = (dY > 0.6) and -math.rad(65) or ((dY < -0.6) and math.rad(65) or -math.rad(50))
            if st.joint and st.jointC0 then
                pcall(function() st.joint.C0 = st.jointC0 * angCF(pitch, 0, 0) end)
            end
            return
        end
        pcall(function() hum.AutoRotate = not flyActive end)
        if st.joint and st.jointC0 then
            pcall(function() st.joint.C0 = st.jointC0 end)
        end
    end
    st.conn = RS.RenderStepped:Connect(function()
        local okA, errA = pcall(antiStep)
        if not okA then
            HUB.antiErrors = (HUB.antiErrors or 0) + 1
            if HUB.antiErrors <= 3 then warn("[SCP-RP] Anti-SCP:", tostring(errA)) end
            if HUB.antiErrors > 60 then
                if HUB.onFailure then HUB.onFailure() else HUB.SetAnti(false) end
            end
        end
    end)
    HUB.antiState = st
    return st
end
anti.stopAnti = function()
    local HUB = anti
    local st = HUB.antiState
    if not st then return end
    pcall(function() if st.conn then st.conn:Disconnect() end end)
    if st.rotationHum then BuloReleaseRotation(st.rotationHum, "anti"); st.rotationHum = nil end
    local char = Player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        pcall(function()
            if st.joint and st.jointC0 then st.joint.C0 = st.jointC0 end
        end)
    end
    pcall(function() if st.zone then st.zone:Destroy() end end)
    for _, m in ipairs(st.markers) do pcall(function() m:Destroy() end) end
    HUB.antiState = nil
end
anti.SetAnti = function(on)
    local HUB = anti
    HUB.antiOn = on and true or false
    if HUB.antiOn then
        HUB.startAnti()
    else
        HUB.stopAnti()
    end
    return HUB.antiOn
end
    function anti.Cleanup() anti.SetAnti(false) end
    return anti
end
local function SetupSCPObjectCosmetics()
    local CAGE173_KIT_MESH   = "15020613385"
    local CAGE173_BAR_MESH   = "4869664533"
    local SCPCRATE_BOX_MESH  = "134603845534131"
    local BAG096_MESH        = "15020249615"
    local function IsCage173Target(obj)
        if not obj then return false end
        if obj:IsA("MeshPart") then
            local mId = tostring(obj.MeshId):gsub("%D", "")
            if mId == CAGE173_KIT_MESH or mId == CAGE173_BAR_MESH then return true end
        end
        local sm = obj:FindFirstChildOfClass("SpecialMesh")
        if sm then
            local mId = tostring(sm.MeshId):gsub("%D", "")
            if mId == CAGE173_KIT_MESH or mId == CAGE173_BAR_MESH then return true end
        end
        local name = obj.Name:lower():gsub("%s+", ""):gsub("%-", "")
        if name == "cage173" or name == "cage" or (name:find("cage") and not name:find("c4") and not name:find("crate")) then
            return true
        end
        local cur = obj.Parent
        while cur and cur ~= workspace and cur ~= game do
            local pName = cur.Name:lower():gsub("%s+", ""):gsub("%-", "")
            if pName == "cage173" or pName == "cage" or (pName:find("cage") and not pName:find("c4") and not pName:find("crate")) then
                return true
            end
            if cur.Name == "MorphAssets" and (name == "cage173" or name == "cage") then return true end
            cur = cur.Parent
        end
        return false
    end
    local function IsSCPCrateTarget(obj)
        if not obj then return false end
        if obj:IsA("MeshPart") then
            local mId = tostring(obj.MeshId):gsub("%D", "")
            if mId == SCPCRATE_BOX_MESH or mId:find(SCPCRATE_BOX_MESH) then return true end
        end
        local sm = obj:FindFirstChildOfClass("SpecialMesh")
        if sm then
            local mId = tostring(sm.MeshId):gsub("%D", "")
            if mId == SCPCRATE_BOX_MESH or mId:find(SCPCRATE_BOX_MESH) then return true end
        end
        local name = obj.Name:lower():gsub("%s+", ""):gsub("%-", "")
        if name == "scpcrate" then return true end
        local cur = obj.Parent
        while cur and cur ~= workspace and cur ~= game do
            local pName = cur.Name:lower():gsub("%s+", ""):gsub("%-", "")
            if pName == "scpcrate" then return true end
            cur = cur.Parent
        end
        return false
    end
    local function IsBagTarget(name)
        if not name then return false end
        local n = name:lower()
        return n:find("bag") or n:find("sack") or n:find("hood") or (n:find("096") and (n:find("head") or n:find("cont")))
    end
    local function MatchesBagTarget(obj)
        if not obj then return false end
        if obj:IsA("MeshPart") then
            local mId = tostring(obj.MeshId):gsub("%D", "")
            if mId == BAG096_MESH then return true end
        end
        if IsBagTarget(obj.Name) then return true end
        if obj.Parent and IsBagTarget(obj.Parent.Name) then return true end
        local anc = obj:FindFirstAncestorWhichIsA("Model")
        if anc and IsBagTarget(anc.Name) then return true end
        return false
    end
    local SCP_CAGE_SKINS = {
        ["Golden Cage"]         = "15021226330",
        ["Task Force"]          = "15021290242",
        ["Under Construction"]  = "15021290905",
        ["Frozen Cage"]         = "137045628511268",
        ["Gilded Cage"]         = "70574023826254",
        ["Space Age Cage"]      = "70689659342214",
        ["Ashen Cage"]          = "76423598477432",
        ["Oceanic Cage"]        = "73352064414380",
        ["Binary Matrix"]       = "76944762163174",
        ["Reinforced Cage"]     = "122677880820818",
        ["Checkered Cage"]      = "97994116554447",
        ["Steampunk Cage"]      = "96072708183955",
        ["Oriental Cage"]       = "140680588859814",
        ["Jungle Camo Cage"]    = "124016415466044",
        ["Boxing Cage"]         = "72309739962283",
        ["Daybreak Cage"]       = "107144271296173",
        ["Festive Cage"]        = "116225690566896",
        ["GOC Cage"]            = "110101104348933",
        ["GRU-P Cage"]          = "116431013976270",
        ["TSH Cage"]            = "116972796496999",
        ["Ice Cage"]            = "133525472375527",
        ["Black Ice Cage"]      = "137383827069069"
    }
    local SCP_CRATE_SKINS = {
        ["Insurgency Crate"]    = "138806304440979",
        ["Beach Crate"]         = "89777642347941",
        ["Maple Leaf Crate"]    = "139754590463246",
        ["Beehive Crate"]       = "114061476543532",
        ["Valentine's Crate"]   = "96207218871542",
        ["Golden Luxury Crate"] = "6822161361",
        ["Toxic Biohazard Crate"]= "121290404504761",
        ["Cyberpunk Neon Crate"]= "76944762163174",
        ["Void Singularity Crate"]= "120733349948660",
        ["Molten Lava Crate"]   = "6824464030",
        ["Glacial Frost Crate"] = "171424974",
        ["Military Camo Crate"] = "4641726146",
        ["Blood Moon Crate"]    = "82292655867692",
        ["Emerald Crystal Crate"]= "6822194233",
        ["Matrix Digital Crate"]= "91428889211539",
        ["Steampunk Brass Crate"]= "96072708183955",
        ["Dragon Emperor Crate"]= "6824492213",
        ["Deep Space Crate"]    = "98124211294159",
        ["Royal Damascus Crate"]= "6824463630",
        ["Radioactive SCP Crate"]= "122663422109985"
    }
    local SCP_BAG_SKINS = {
        ["Biohazard"]           = "15021175203",
        ["Chaotic"]             = "15021177960",
        ["Practice"]            = "15021176670",
        ["Arctic Camo Bag"]     = "129556083422043",
        ["Arabesque Bag"]       = "138531720288542",
        ["Lunar Bag"]           = "129513981049398",
        ["Ashen Bag"]           = "128588667067813",
        ["Oceanic Bag"]         = "114948815372122",
        ["Hacked Bag"]          = "116714093842094",
        ["Caution Bag"]         = "122663422109985",
        ["Grocery Bag"]         = "99721306508096",
        ["Gear Bag"]            = "94169109388125",
        ["Oriental Bag"]        = "101728466285798",
        ["Jungle Camo Bag"]     = "126248296457193",
        ["Target Bag"]          = "85381543222936",
        ["Pumpkin Bag"]         = "139574075211195",
        ["Festive Bag"]         = "84689512973247",
        ["GOC Bag"]             = "132527349253459",
        ["GRU-P Bag"]           = "100434901439285",
        ["TSH Bag"]             = "97060685371925",
        ["Ice Bag"]             = "115906964237189",
        ["Beach Bag"]           = "82874604075534",
        ["Maple Leaf Bag"]      = "134448020077250"
    }
    local SelectedCageSkin, SelectedCrateSkin, SelectedBagSkin = nil, nil, nil
    local function FormatAssetUrl(id)
        return "rbxassetid://" .. tostring(id):gsub("%D", "")
    end
    local VanillaCache = setmetatable({}, { __mode = "k" })
    local function VanillaIsOurs(inst)
        local nm = inst.Name or ""
        return nm == "CustomSkinTex" or nm == "CustomCageTex" or nm == "CustomSCPTex"
            or nm == "GunAuraEmitter" or nm == "CustomKillFX"
    end
    local function VanillaSnapshotChild(ch)
        local snap = { class = ch.ClassName, name = ch.Name }
        local function grab(k) pcall(function() snap[k] = ch[k] end) end
        if ch:IsA("SurfaceAppearance") then
            grab("ColorMap"); grab("MetalnessMap"); grab("NormalMap"); grab("RoughnessMap")
        elseif ch:IsA("Texture") then
            grab("Texture"); grab("Face"); grab("StudsPerTileU"); grab("StudsPerTileV"); grab("Transparency")
        elseif ch:IsA("Decal") then
            grab("Texture"); grab("Face"); grab("Transparency")
        elseif ch:IsA("SpecialMesh") then
            grab("MeshId"); grab("TextureId"); grab("MeshType"); grab("Scale"); grab("Offset"); grab("VertexColor")
        else
            return nil
        end
        return snap
    end
    local function VanillaSnapshot(part, kind)
        if not part then return end
        if VanillaCache[part] then
            pcall(function()
                if part:GetAttribute("BuloExtraSCPManaged") ~= true then
                    part:SetAttribute("BuloExtraSCPManaged", true)
                end
            end)
            return
        end
        local snap = { kind = kind or "obj", children = {} }
        pcall(function() snap.Color = part.Color end)
        pcall(function() snap.Material = part.Material end)
        pcall(function() snap.Transparency = part.Transparency end)
        pcall(function() if part:IsA("MeshPart") then snap.TextureID = part.TextureID end end)
        for _, ch in ipairs(part:GetChildren()) do
            if not VanillaIsOurs(ch) then
                local cs = VanillaSnapshotChild(ch)
                if cs then table.insert(snap.children, cs) end
            end
        end
        VanillaCache[part] = snap
        pcall(function() part:SetAttribute("BuloExtraSCPManaged", true) end)
    end
    local function VanillaRestore(part)
        local snap = VanillaCache[part]
        if not snap or not part or not part.Parent then return end
        pcall(function() part:SetAttribute("BuloExtraSCPManaged", nil) end)
        for _, ch in ipairs(part:GetChildren()) do
            if VanillaIsOurs(ch) then pcall(function() ch:Destroy() end) end
        end
        pcall(function() if snap.Color then part.Color = snap.Color end end)
        pcall(function() if snap.Material then part.Material = snap.Material end end)
        pcall(function() if snap.Transparency then part.Transparency = snap.Transparency end end)
        pcall(function()
            if snap.TextureID ~= nil and part:IsA("MeshPart") then part.TextureID = snap.TextureID end
        end)
        for _, cs in ipairs(snap.children) do
            pcall(function()
                local inst
                for _, ch in ipairs(part:GetChildren()) do
                    if ch.ClassName == cs.class and ch.Name == cs.name then inst = ch break end
                end
                if not inst then
                    inst = Instance.new(cs.class)
                    inst.Name = cs.name
                    inst.Parent = part
                end
                for k, v in pairs(cs) do
                    if k ~= "class" and k ~= "name" and v ~= nil then
                        pcall(function() inst[k] = v end)
                    end
                end
            end)
        end
    end
    local function StripObjectSkins()
        for part, snap in pairs(VanillaCache) do
            if snap.kind == "obj" and part and part.Parent then
                VanillaRestore(part)
            end
        end
    end
    local function ApplyCage173Skin(target, textureId)
        if not target or not textureId then return end
        local assetUrl = FormatAssetUrl(textureId)
        local function modify(part)
            if not (part:IsA("BasePart") or part:IsA("MeshPart")) then return end
            if part.Transparency > 0.8 then return end
            local pName = part.Name:lower()
            if pName:find("shadow") or pName:find("hitbox") or pName:find("root") or pName:find("collision") then return end
            VanillaSnapshot(part, "obj")
            for _, ch in ipairs(part:GetChildren()) do
                if ch:IsA("SurfaceAppearance") or ch.Name == "CustomCageTex" or ch:IsA("Texture") or ch:IsA("Decal") then
                    ch:Destroy()
                end
            end
            if part:IsA("MeshPart") then
                pcall(function() part.TextureID = assetUrl end)
                part.Color = Color3.fromRGB(255, 255, 255)
            end
            local sm = part:FindFirstChildOfClass("SpecialMesh")
            if sm then
                pcall(function() sm.TextureId = assetUrl end)
                part.Color = Color3.fromRGB(255, 255, 255)
            end
        end
        if target:IsA("BasePart") then modify(target) end
        for _, desc in ipairs(target:GetDescendants()) do
            if desc:IsA("BasePart") then modify(desc) end
        end
    end
    local function ApplySCPCrateSkin(target, textureId)
        if not target or not textureId then return end
        local assetUrl = FormatAssetUrl(textureId)
        local function modify(part)
            if not (part:IsA("BasePart") or part:IsA("MeshPart")) then return end
            if part.Transparency > 0.8 then return end
            VanillaSnapshot(part, "obj")
            for _, ch in ipairs(part:GetChildren()) do
                if ch:IsA("SurfaceAppearance") or ch:IsA("Texture") or ch:IsA("Decal") then ch:Destroy() end
            end
            if part:IsA("MeshPart") then
                pcall(function() part.TextureID = assetUrl end)
                part.Color = Color3.fromRGB(255, 255, 255)
            end
            local sm = part:FindFirstChildOfClass("SpecialMesh")
            if sm then
                pcall(function() sm.TextureId = assetUrl end)
                part.Color = Color3.fromRGB(255, 255, 255)
            end
        end
        if target:IsA("BasePart") then modify(target) end
        for _, desc in ipairs(target:GetDescendants()) do
            if desc:IsA("BasePart") then modify(desc) end
        end
    end
    local function ApplyBagSkin(target, textureId)
        if not target or not textureId then return end
        local assetUrl = FormatAssetUrl(textureId)
        local function modify(part)
            if not part:IsA("BasePart") or part.Transparency > 0.8 then return end
            VanillaSnapshot(part, "obj")
            local isMesh = part:IsA("MeshPart")
            local mesh = not isMesh and part:FindFirstChildOfClass("SpecialMesh") or nil
            local needsDecals = not isMesh and not mesh
            local faces = {}
            for _, ch in ipairs(part:GetChildren()) do
                if ch:IsA("SurfaceAppearance") then
                    ch:Destroy()
                elseif ch.Name == "CustomSCPTex" then
                    if needsDecals and ch:IsA("Decal") and ch.Texture == assetUrl and not faces[ch.Face] then
                        faces[ch.Face] = true
                    else
                        ch:Destroy()
                    end
                end
            end
            if isMesh then
                pcall(function() if part.TextureID ~= assetUrl then part.TextureID = assetUrl end end)
                if part.Color ~= Color3.fromRGB(255, 255, 255) then part.Color = Color3.fromRGB(255, 255, 255) end
            elseif mesh then
                pcall(function() if mesh.TextureId ~= assetUrl then mesh.TextureId = assetUrl end end)
            else
                if part.Color ~= Color3.fromRGB(255, 255, 255) then part.Color = Color3.fromRGB(255, 255, 255) end
                for _, face in ipairs(Enum.NormalId:GetEnumItems()) do
                    if not faces[face] then
                        local decal = Instance.new("Decal")
                        decal.Name = "CustomSCPTex"
                        decal.Texture = assetUrl
                        decal.Face = face
                        decal.Parent = part
                    end
                end
            end
        end
        if target:IsA("BasePart") then modify(target) end
        for _, desc in ipairs(target:GetDescendants()) do
            if desc:IsA("BasePart") then modify(desc) end
        end
    end
    local function ApplyAllSCPSkins(canContinue)
        if not canContinue() then return end
        for _, root in ipairs({workspace, ReplicatedStorage}) do
            local ma = root:FindFirstChild("MorphAssets") or root:FindFirstChild("LoadAsset")
            if ma then
                if SelectedCageSkin then
                    for _, ch in ipairs(ma:GetChildren()) do
                        if IsCage173Target(ch) then ApplyCage173Skin(ch, SelectedCageSkin) end
                    end
                end
                if SelectedCrateSkin then
                    for _, ch in ipairs(ma:GetChildren()) do
                        if IsSCPCrateTarget(ch) then ApplySCPCrateSkin(ch, SelectedCrateSkin) end
                    end
                end
                if SelectedBagSkin then
                    for _, ch in ipairs(ma:GetChildren()) do
                        if MatchesBagTarget(ch) then ApplyBagSkin(ch, SelectedBagSkin) end
                    end
                end
            end
        end
        local function processObject(obj)
            if not obj then return end
            if SelectedCageSkin and IsCage173Target(obj) then
                ApplyCage173Skin(obj, SelectedCageSkin)
            elseif SelectedCrateSkin and IsSCPCrateTarget(obj) then
                ApplySCPCrateSkin(obj, SelectedCrateSkin)
            elseif SelectedBagSkin and MatchesBagTarget(obj) then
                ApplyBagSkin(obj, SelectedBagSkin)
            end
        end
        if Player.Character then
            for _, t in ipairs(Player.Character:GetChildren()) do processObject(t) end
        end
        local bp = Player:FindFirstChild("Backpack")
        if bp then
            for _, t in ipairs(bp:GetChildren()) do processObject(t) end
        end
        for _, vm in ipairs(Camera:GetChildren()) do
            if vm:IsA("Model") and not vm:FindFirstChild("Humanoid") then processObject(vm) end
        end
        for index, item in BuloWalkDescendants(workspace) do
            if not canContinue() then return end
            if item:IsA("Model") or item:IsA("Tool") or item:IsA("MeshPart") then processObject(item) end
            if index % 500 == 0 then task.wait() end
        end
    end
    local api = {Cage = SCP_CAGE_SKINS, Crate = SCP_CRATE_SKINS, Bag = SCP_BAG_SKINS}
    local running = true
    local ownedConnections = {}
    local lastScan = 0
    local scanVersion, scanRunning, scanRequested = 0, false, false
    local function requestScan()
        scanVersion += 1
        scanRequested = true
        lastScan = tick()
        if scanRunning then return end
        scanRunning = true
        task.spawn(function()
            while running and not BuloHubUnloaded and scanRequested do
                scanRequested = false
                local current = scanVersion
                local function canContinue()
                    return current == scanVersion and running and not BuloHubUnloaded
                        and (SelectedCageSkin or SelectedCrateSkin or SelectedBagSkin)
                end
                if canContinue() then pcall(ApplyAllSCPSkins, canContinue) end
            end
            scanRunning = false
        end)
    end
    local function connect(signal, fn)
        local connection = signal:Connect(fn)
        table.insert(ownedConnections, connection)
    end
    function api.Names(db)
        local names = {"Default"}
        local extra = {}
        for name in pairs(db) do table.insert(extra, name) end
        table.sort(extra)
        for _, name in ipairs(extra) do table.insert(names, name) end
        return names
    end
    function api.Set(which, name)
        if name == "Default" then name = nil end
        if which == "Cage" then SelectedCageSkin = name and SCP_CAGE_SKINS[name] or nil end
        if which == "Crate" then SelectedCrateSkin = name and SCP_CRATE_SKINS[name] or nil end
        if which == "Bag" then SelectedBagSkin = name and SCP_BAG_SKINS[name] or nil end
        scanVersion += 1
        scanRequested = false
        StripObjectSkins()
        if SelectedCageSkin or SelectedCrateSkin or SelectedBagSkin then requestScan() end
    end
    function api.Refresh()
        if running and not BuloHubUnloaded and (SelectedCageSkin or SelectedCrateSkin or SelectedBagSkin) then
            requestScan()
        end
    end
    local function onAdded(desc)
        if not running or BuloHubUnloaded then return end
        if not (SelectedCageSkin or SelectedCrateSkin or SelectedBagSkin) then return end
        if not (desc:IsA("Model") or desc:IsA("Tool") or desc:IsA("MeshPart")) then return end
        task.defer(function()
            if not running or BuloHubUnloaded or not desc.Parent then return end
            pcall(function()
                if SelectedCageSkin and IsCage173Target(desc) then
                    ApplyCage173Skin(desc, SelectedCageSkin)
                elseif SelectedCrateSkin and IsSCPCrateTarget(desc) then
                    ApplySCPCrateSkin(desc, SelectedCrateSkin)
                elseif SelectedBagSkin and MatchesBagTarget(desc) then
                    ApplyBagSkin(desc, SelectedBagSkin)
                end
            end)
        end)
    end
    connect(workspace.DescendantAdded, onAdded)
    connect(ReplicatedStorage.DescendantAdded, onAdded)
    connect(RS.Heartbeat, function()
        if not running or BuloHubUnloaded or not (SelectedCageSkin or SelectedCrateSkin or SelectedBagSkin) then return end
        if not scanRunning and tick() - lastScan >= 4.5 then requestScan() end
    end)
    function api.Cleanup()
        running = false
        scanVersion += 1
        scanRequested = false
        for _, connection in ipairs(ownedConnections) do pcall(function() connection:Disconnect() end) end
        table.clear(ownedConnections)
        SelectedCageSkin, SelectedCrateSkin, SelectedBagSkin = nil, nil, nil
        StripObjectSkins()
        table.clear(VanillaCache)
    end
    return api
end
local function SetupBackCosmetics()
    local api = {}
    local catalog = {
        ["Item / Preset (1789386962)"] = {id="1789386962", animation=false, hideHair=false},
        ["Lacrimosa Hair (NTE)"] = {id="134193328700842", animation=false, hideHair=true},
        ["Dragon Tail (NTE)"] = {id="131087542452408", animation=false, hideHair=false},
        ["NTE Special Accessory"] = {id="119178155105241", animation=false, hideHair=false},
        ["Blue Demon Vampire Wing"] = {id="128889253780740", animation=false, hideHair=false},
        ["Cartoony Yellow Mystery"] = {id="17400537598", animation=false, hideHair=false},
        ["Lacrimosa Back"] = {id="77201754506817", animation=false, hideHair=false},
        ["Lacrimosa Waist (NTE)"] = {id="97181948671628", animation=false, hideHair=false},
        ["Nekomiya Mana Ears (ZZZ)"] = {id="18406393048", animation=false, hideHair=false},
        ["Yuzuha's Umbrella (ZZZ)"] = {id="120640438856252", animation=false, hideHair=false},
        ["Sunken Assassin Cape"] = {id="131865919209196", animation=false, hideHair=false},
        ["Lunar Companion"] = {id="114062766927484", animation=false, hideHair=false},
        ["Toji Cursed Worm (JJK)"] = {id="14132986182", animation=false, hideHair=false},
        ["Mahoraga Wheel (JJK)"] = {id="15522039131", animation=false, hideHair=false},
        ["Kaneki Kagune (Tokyo Ghoul)"] = {id="82156090456108", animation=false, hideHair=false},
        ["Elysia Sakura Branches (HI3)"] = {id="109566353058562", animation=false, hideHair=false},
        ["Korblox Dragon Wings"] = {id="126017157237300", animation=false, hideHair=false},
        ["Seraph Wings with Halo"] = {id="74150555118285", animation=false, hideHair=false},
        ["Snow-White Angel Wings"] = {id="11444198006", animation=false, hideHair=false},
        ["EDM Cyber Wings (Neon Electric)"] = {id="87479516405266", animation=false, hideHair=false},
        ["[ANIM] Floating in Air"] = {id="139058906415119", animation=true, hideHair=false},
        ["[ANIM] Domain Expansion: Gojo"] = {id="90085716100071", animation=true, hideHair=false},
        ["[ANIM] Domain Expansion: Sukuna"] = {id="114385859946294", animation=true, hideHair=false},
        ["[ANIM] Sukuna: Fuga Fire Arrow"] = {id="81237973952591", animation=true, hideHair=false},
        ["[ANIM] Hollow Purple"] = {id="77776550462160", animation=true, hideHair=false},
        ["[ANIM] Gojo Awakening: Honored One"] = {id="74061719450611", animation=true, hideHair=false},
        ["[ANIM] Kamehameha! (Goku)"] = {id="117705792863511", animation=true, hideHair=false},
        ["[ANIM] Rasengan Ninjutsu (Naruto)"] = {id="127788702951354", animation=true, hideHair=false},
        ["[ANIM] Toji Brutal Walk"] = {id="108020345823731", animation=true, hideHair=false},
        ["[ANIM] Gojo Confident Walk"] = {id="102873028723834", animation=true, hideHair=false},
        ["[ANIMATED] Living Angel Wings"] = {id="84302157387623", animation=false, hideHair=false},
        ["[ANIMATED] Glitch TV Wings"] = {id="132663272067734", animation=false, hideHair=false},
        ["[ANIMATED] Anime Skateboard"] = {id="116153461539803", animation=false, hideHair=false},
        ["Akaza Battle Stance (Destructive Death)"] = {id="134913804057160", animation=true, hideHair=false},
        ["Sung Jinwoo Shadow Cloak (Solo Leveling)"] = {id="80480817855096", animation=false, hideHair=false},
        ["Sukuna Haori & Cape"] = {id="105537800867737", animation=false, hideHair=false},
        ["Dracula Bat Wings"] = {id="12635341175", animation=false, hideHair=false},
        ["Sparkling Golden Angel Wings"] = {id="192557913", animation=false, hideHair=false},
        ["Nero Fallen Angel Dark Wings"] = {id="11446130297", animation=false, hideHair=false},
        ["Pactbreaker Wings"] = {id="78992415684477", animation=false, hideHair=false},
        ["Golden Seraph Wings (White Gold)"] = {id="2222538922", animation=false, hideHair=false},
        ["Neon Sunset Cyber Wings"] = {id="4690557601", animation=false, hideHair=false},
        ["Flying Animated Wings"] = {id="100463281314793", animation=false, hideHair=false},
    }
    local order = {
        "Item / Preset (1789386962)",
        "Lacrimosa Hair (NTE)",
        "Dragon Tail (NTE)",
        "NTE Special Accessory",
        "Blue Demon Vampire Wing",
        "Cartoony Yellow Mystery",
        "Lacrimosa Back",
        "Lacrimosa Waist (NTE)",
        "Nekomiya Mana Ears (ZZZ)",
        "Yuzuha's Umbrella (ZZZ)",
        "Sunken Assassin Cape",
        "Lunar Companion",
        "Toji Cursed Worm (JJK)",
        "Mahoraga Wheel (JJK)",
        "Kaneki Kagune (Tokyo Ghoul)",
        "Elysia Sakura Branches (HI3)",
        "Korblox Dragon Wings",
        "Seraph Wings with Halo",
        "Snow-White Angel Wings",
        "EDM Cyber Wings (Neon Electric)",
        "[ANIM] Floating in Air",
        "[ANIM] Domain Expansion: Gojo",
        "[ANIM] Domain Expansion: Sukuna",
        "[ANIM] Sukuna: Fuga Fire Arrow",
        "[ANIM] Hollow Purple",
        "[ANIM] Gojo Awakening: Honored One",
        "[ANIM] Kamehameha! (Goku)",
        "[ANIM] Rasengan Ninjutsu (Naruto)",
        "[ANIM] Toji Brutal Walk",
        "[ANIM] Gojo Confident Walk",
        "[ANIMATED] Living Angel Wings",
        "[ANIMATED] Glitch TV Wings",
        "[ANIMATED] Anime Skateboard",
        "Akaza Battle Stance (Destructive Death)",
        "Sung Jinwoo Shadow Cloak (Solo Leveling)",
        "Sukuna Haori & Cape",
        "Dracula Bat Wings",
        "Sparkling Golden Angel Wings",
        "Nero Fallen Angel Dark Wings",
        "Pactbreaker Wings",
        "Golden Seraph Wings (White Gold)",
        "Neon Sunset Cyber Wings",
        "Flying Animated Wings",
    }
    local selected, worn, custom = {}, {}, {}
    local hairOriginals, clothesOriginals = {}, {}
    local hideHair, hideClothes, lastWeld = false, false, nil
    local generation, running = 0, true
    local connections = {}
    function api.Names() return order end
    local function safeSet(inst, property, value)
        pcall(function() inst[property] = value end)
    end
    local function restoreSaved(saved)
        for inst, props in pairs(saved) do
            if inst and inst.Parent then
                for property, value in pairs(props) do safeSet(inst, property, value) end
            end
            saved[inst] = nil
        end
    end
    local function saveProperty(saved, inst, property)
        if not saved[inst] then saved[inst] = {} end
        if saved[inst][property] == nil then
            local ok, value = pcall(function() return inst[property] end)
            if ok then saved[inst][property] = value end
        end
    end
    local function ourItem(inst)
        for _, item in pairs(worn) do
            if item.model and (item.model == inst or inst:IsDescendantOf(item.model)) then return true end
        end
        for _, item in ipairs(custom) do
            if item.model and (item.model == inst or inst:IsDescendantOf(item.model)) then return true end
        end
        return false
    end
    local function hidePart(inst, saved)
        if inst:IsA("BasePart") then
            for _, p in ipairs({"LocalTransparencyModifier", "Transparency", "CastShadow"}) do saveProperty(saved, inst, p) end
            safeSet(inst, "LocalTransparencyModifier", 1)
            safeSet(inst, "Transparency", 1)
            safeSet(inst, "CastShadow", false)
        elseif inst:IsA("Decal") or inst:IsA("Texture") then
            saveProperty(saved, inst, "Transparency")
            safeSet(inst, "Transparency", 1)
        elseif inst:IsA("SpecialMesh") then
            saveProperty(saved, inst, "Scale")
            safeSet(inst, "Scale", Vector3.zero)
        end
    end
    local function applyHair()
        restoreSaved(hairOriginals)
        local char = Player.Character
        if not char then return end
        local mustHide = hideHair
        for name in pairs(selected) do
            if catalog[name] and catalog[name].hideHair then mustHide = true; break end
        end
        if not mustHide then return end
        for _, obj in ipairs(char:GetChildren()) do
            if not ourItem(obj) then
                local name = obj.Name:lower()
                local isHair = obj:IsA("Accessory") and (obj.AccessoryType == Enum.AccessoryType.Hair
                    or name:find("hair", 1, true) ~= nil)
                if not isHair and obj:IsA("Accessory") then
                    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                    isHair = handle and handle:FindFirstChild("HairAttachment") ~= nil
                end
                if isHair then
                    hidePart(obj, hairOriginals)
                    for _, desc in ipairs(obj:GetDescendants()) do hidePart(desc, hairOriginals) end
                end
            end
        end
        local morphFolder = workspace:FindFirstChild("MorphAssets")
        if morphFolder then
            for _, obj in ipairs(morphFolder:GetChildren()) do
                local tag = obj:FindFirstChild("Character")
                local own = tag and (tag.Value == Player or tag.Value == char or tostring(tag.Value):lower() == Player.Name:lower())
                if own and not ourItem(obj) then
                    local nm = obj.Name:lower()
                    if not (nm:find("leg") or nm:find("arm") or nm:find("torso") or nm:find("foot")) then
                        hidePart(obj, hairOriginals)
                        for _, desc in ipairs(obj:GetDescendants()) do hidePart(desc, hairOriginals) end
                    end
                end
            end
        end
    end
    local function applyClothes()
        restoreSaved(clothesOriginals)
        local char = Player.Character
        if not hideClothes or not char then return end
        for _, obj in ipairs(char:GetChildren()) do
            local prop = obj:IsA("Shirt") and "ShirtTemplate" or obj:IsA("Pants") and "PantsTemplate"
                or obj:IsA("ShirtGraphic") and "Graphic" or nil
            if prop then
                saveProperty(clothesOriginals, obj, prop)
                safeSet(obj, prop, "")
            elseif obj:IsA("Accessory") and not ourItem(obj) then
                local layered = obj:FindFirstChildWhichIsA("WrapLayer", true)
                    or obj.AccessoryType == Enum.AccessoryType.Jacket
                    or obj.AccessoryType == Enum.AccessoryType.Sweater
                    or obj.AccessoryType == Enum.AccessoryType.Pants
                    or obj.AccessoryType == Enum.AccessoryType.Shorts
                    or obj.AccessoryType == Enum.AccessoryType.Shirt
                    or obj.AccessoryType == Enum.AccessoryType.DressSkirt
                if layered then
                    for _, desc in ipairs(obj:GetDescendants()) do hidePart(desc, clothesOriginals) end
                end
            end
        end
    end
    local assetTemplates, assetOrder = {}, {}
    local function touchAsset(id)
        for i = #assetOrder, 1, -1 do
            if assetOrder[i] == id then table.remove(assetOrder, i) end
        end
        table.insert(assetOrder, id)
    end
    local function rememberAsset(id, obj)
        if not running or BuloHubUnloaded then return end
        local ok, copy = pcall(function()
            if obj.Archivable == false then return nil end
            for _, child in ipairs(obj:GetDescendants()) do
                if child.Archivable == false then return nil end
            end
            return obj:Clone()
        end)
        if not ok or not copy then return end
        local old = assetTemplates[id]
        assetTemplates[id] = copy
        touchAsset(id)
        if old then pcall(function() old:Destroy() end) end
        while #assetOrder > 8 do
            local expired = table.remove(assetOrder, 1)
            local item = assetTemplates[expired]
            assetTemplates[expired] = nil
            if item then pcall(function() item:Destroy() end) end
        end
    end
    local function loadAsset(id)
        id = tostring(id or ""):match("%d+")
        if not id then return nil end
        local cached = assetTemplates[id]
        if cached then
            local ok, copy = pcall(function() return cached:Clone() end)
            if ok and copy then touchAsset(id); return copy end
            assetTemplates[id] = nil
            pcall(function() cached:Destroy() end)
            for i = #assetOrder, 1, -1 do
                if assetOrder[i] == id then table.remove(assetOrder, i) end
            end
        end
        for _, url in ipairs({"rbxassetid://" .. id, "http://www.roblox.com/asset/?id=" .. id,
            "https://assetdelivery.roblox.com/v1/asset/?id=" .. id,
            "https://assetdelivery.roblox.com/v2/assetId/" .. id}) do
            local ok, objects = pcall(function() return game:GetObjects(url) end)
            if ok and objects and objects[1] and typeof(objects[1]) == "Instance" then
                rememberAsset(id, objects[1])
                return objects[1]
            end
        end
        local ok, obj = pcall(function() return game:GetService("InsertService"):LoadLocalAsset("rbxassetid://" .. id) end)
        if ok and obj and typeof(obj) == "Instance" then
            rememberAsset(id, obj)
            return obj
        end
        local part = Instance.new("Part")
        part.Name = "Handle"
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://" .. id
        mesh.Parent = part
        return part
    end
    local function playAnimation(char, id, existing)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local animator = hum and (hum:FindFirstChildOfClass("Animator") or hum:WaitForChild("Animator", 3))
        if not animator then return nil end
        local anim = existing
        if not anim then
            anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://" .. tostring(id):match("%d+")
        end
        local ok, track = pcall(function() return animator:LoadAnimation(anim) end)
        if not ok or not track then return nil end
        track.Priority = Enum.AnimationPriority.Action4
        track.Looped = true
        track:Play()
        return track
    end
    local function attach(char, model)
        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        if not torso then return nil end
        local handle = model:IsA("BasePart") and model or model:FindFirstChild("Handle") or model:FindFirstChildWhichIsA("BasePart")
        if not handle then
            for _, desc in ipairs(model:GetDescendants()) do if desc:IsA("BasePart") then handle=desc; break end end
        end
        if not handle then return nil end
        for _, desc in ipairs(model:GetDescendants()) do
            if desc:IsA("BaseScript") then desc:Destroy()
            elseif desc:IsA("BasePart") then desc.CanCollide=false; desc.Massless=true end
        end
        if model:IsA("BasePart") then model.CanCollide=false; model.Massless=true end
        pcall(function() model:SetAttribute("BuloExtraBackItem", true) end)
        model.Parent = char
        local weld = Instance.new("Weld")
        weld.Name = "BuloAccessoryWeld"
        weld.Part0 = handle
        local handleAtt = handle:FindFirstChildWhichIsA("Attachment") or model:FindFirstChildWhichIsA("Attachment", true)
        local charAtt = handleAtt and char:FindFirstChild(handleAtt.Name, true)
        if handleAtt and charAtt and charAtt:IsA("Attachment") then
            weld.Part1 = charAtt.Parent
            weld.C0 = handleAtt.CFrame
            weld.C1 = charAtt.CFrame
        else
            weld.Part1 = torso
            weld.C0 = CFrame.new(0, 0, 0.9)
        end
        weld.Parent = handle
        lastWeld = weld
        return model
    end
    local function remove(item)
        if not item then return end
        pcall(function() if item.track then item.track:Stop() end end)
        pcall(function() if item.model then item.model:Destroy() end end)
    end
    local function equip(name, data, customEntry)
        local char = Player.Character
        if not char then return end
        local g = generation
        task.spawn(function()
            local obj
            if not data.animation then obj = loadAsset(data.id) end
            if not running or BuloHubUnloaded or g ~= generation or Player.Character ~= char
                or (not customEntry and not selected[name]) then
                if obj then pcall(function() obj:Destroy() end) end
                return
            end
            local animation = obj and (obj:IsA("Animation") and obj or obj:FindFirstChildWhichIsA("Animation", true))
            local entry = {}
            if data.animation or animation then
                entry.track = playAnimation(char, data.id, animation)
                if obj then pcall(function() obj:Destroy() end) end
            elseif obj then
                entry.model = attach(char, obj)
                if not entry.model then pcall(function() obj:Destroy() end) end
            end
            if customEntry then
                table.insert(custom, entry)
            else
                remove(worn[name])
                worn[name] = entry
            end
            applyHair()
            applyClothes()
        end)
    end
    function api.Select(names)
        local new = {}
        for _, name in ipairs(names or {}) do if catalog[name] then new[name] = true end end
        local old = selected
        selected = new
        for name in pairs(old) do
            if not new[name] then remove(worn[name]); worn[name] = nil end
        end
        for name in pairs(new) do
            if not old[name] then equip(name, catalog[name], false) end
        end
        applyHair()
    end
    function api.WearCustom(id, animation)
        local clean = tostring(id or ""):match("%d+")
        if clean then equip(nil, {id=clean, animation=animation and true or false}, true) end
    end
    function api.SetHair(on) hideHair = on and true or false; applyHair() end
    function api.SetClothes(on) hideClothes = on and true or false; applyClothes() end
    function api.Rotate()
        if lastWeld and lastWeld.Parent then lastWeld.C0 *= CFrame.Angles(0, math.rad(180), 0) end
    end
    function api.Clear()
        generation += 1
        for name, item in pairs(worn) do remove(item); worn[name] = nil end
        for _, item in ipairs(custom) do remove(item) end
        table.clear(custom)
        table.clear(selected)
        lastWeld = nil
        hideHair, hideClothes = false, false
        restoreSaved(hairOriginals)
        restoreSaved(clothesOriginals)
    end
    table.insert(connections, Player.CharacterAdded:Connect(function(char)
        generation += 1
        for name, item in pairs(worn) do remove(item); worn[name] = nil end
        for _, item in ipairs(custom) do remove(item) end
        table.clear(custom)
        restoreSaved(hairOriginals)
        restoreSaved(clothesOriginals)
        local g = generation
        task.spawn(function()
            task.wait(0.7)
            if not running or BuloHubUnloaded or generation ~= g or Player.Character ~= char then return end
            for name in pairs(selected) do if catalog[name] then equip(name, catalog[name], false) end end
            applyHair(); applyClothes()
        end)
    end))
    function api.Cleanup()
        running = false
        for _, con in ipairs(connections) do pcall(function() con:Disconnect() end) end
        api.Clear()
        for _, template in pairs(assetTemplates) do pcall(function() template:Destroy() end) end
        table.clear(assetTemplates)
        table.clear(assetOrder)
    end
    return api
end
local function SetupExtraFx()
    local running = true
    local ownedFx = setmetatable({}, {__mode="k"})
    local Debris = game:GetService("Debris")
    local TweenService = game:GetService("TweenService")
    local KillEffectsModule, killModuleLoading
    local function loadKillEffectsModule()
        if KillEffectsModule or killModuleLoading or not running then return end
        killModuleLoading = true
        task.spawn(function()
            local ok, result = pcall(function() return require(ReplicatedStorage.ClientHandlers.KillEffects) end)
            if running and ok then KillEffectsModule = result end
            killModuleLoading = false
        end)
    end
    local SelectedKillEffect, SelectedC4Effect = nil, nil
    local PlayEffectOnDeath, FxForSelf, FxForOthers = false, false, false
    local ALL_KILL_EFFECTS = {
        "Blackhole", "Ice Cube", "Atomic Rebinding", "Collect Soul", "Cupid's Arrow",
        "Bonfire", "Hydrosphere", "Snow Storm", "Desertification", "Defragmentation",
        "Reconstruction", "Gourmet Meal", "Evaporation", "Black Flame", "Monkey Horde",
        "Knockout", "Disintegration", "Gift Box", "Rainbow Bridge", "Rest In Peace",
        "Northern Lights", "Foundation Seal", "Starception", "Council of 8", "Void Crystal",
        "Thanksgiving2025", "BeeStripe", "Hallowen 2023 Casket", "CandyCane", "GreenCandyCane", "Presents",
        "Coalition Stars", "Yellow Stars", "Serpents Venom",
        "Black Hole Singularity", "Atomic Annihilation", "Sakura Petal Dissolve",
        "Blood Nova Explosion", "Glitch Disintegration", "Golden Halo Ascension",
        "Lightning Smite", "Hellfire Cremation", "Ice Shatter Freeze",
        "Cursed Domain Purge", "Supernova Blast", "Matrix Code Melt",
        "Void Rift Consumption", "Demon Slashes Decapitation", "Soul Reaper Extraction",
        "Cyber Overload Vaporize", "Quantum Teleport Decay", "Holy Light Judgment",
        "Abyssal Tentacles Drag", "Vampiric Bat Scatter",
        "Domain Expansion Void", "Hollow Purple Obliteration", "Sukuna Cleave & Dismantle",
        "Supernova Core Collapse", "Nuclear Detonation Shockwave", "Black Hole Singularity Drain",
        "Soul Reaper Soul Steal", "Pixel Glitch Reality Tear", "Sakura Petal Dispersal",
        "Blood Moon Guillotine", "Lightning Strike Judgment", "Absolute Zero Shatter",
        "Hellfire Cremation Ash", "Golden Ascension to Heaven", "Matrix System Shutdown",
        "Cyberpunk EMP Blast", "Abyssal Kraken Tentacles", "Vampire Bat Swarm Disperse",
        "Dragon Fire Incineration", "Quantum Teleport Vanish", "Chrono Time Freeze Decay",
        "Sonic Wave Pulverize", "Toxic Biohazard Dissolve", "Celestial Comet Impact",
        "Stardust Disintegration", "Mirror Reality Crack"
    }
    local C4_DATA = {
        ["Supernova"]           = {id = "120733349948660", color = Color3.fromRGB(140, 60, 255)},
        ["SCP-3008 (IKEA)"]     = {id = "15420991905",     color = Color3.fromRGB(255, 210, 0)},
        ["Insurgency"]          = {id = "15021615529",     color = Color3.fromRGB(200, 30, 30)},
        ["Freedom"]             = {id = "15420992187",     color = Color3.fromRGB(0, 160, 255)},
        ["'Re: Your Brains'"]   = {id = "15420992046",     color = Color3.fromRGB(50, 220, 90)},
        ["Fiery Explosion"]     = {id = "139473336282527", color = Color3.fromRGB(255, 90, 0)},
        ["Snow Explosion"]      = {id = "129507052510465", color = Color3.fromRGB(180, 240, 255)},
        ["Sand Explosion"]      = {id = "98607824077241",  color = Color3.fromRGB(215, 180, 130)},
        ["Waterspout"]          = {id = "113975548307908", color = Color3.fromRGB(0, 170, 255)},
        ["Integer Overflow"]    = {id = "102467996925868", color = Color3.fromRGB(0, 255, 80)},
        ["Construction Zone"]   = {id = "80922253876944",  color = Color3.fromRGB(255, 200, 0)},
        ["Let Me Cook"]         = {id = "100639704217952", color = Color3.fromRGB(255, 140, 50)},
        ["Gear Explosion"]      = {id = "76571131991726",  color = Color3.fromRGB(200, 150, 90)},
        ["Cherry Blossoms"]     = {id = "78525344606616",  color = Color3.fromRGB(255, 150, 200)},
        ["Monke"]               = {id = "89204551583237",  color = Color3.fromRGB(255, 255, 255)},
        ["Pow Explosion"]       = {id = "93403389873426",  color = Color3.fromRGB(255, 50, 50)},
        ["Ominous Explosion"]   = {id = "94505672182126",  color = Color3.fromRGB(150, 0, 255)},
        ["Black Hole Singularity"] = {id = "120733349948660", color = Color3.fromRGB(40, 0, 90)},
        ["Hollow Purple"]= {id = "120733349948660", color = Color3.fromRGB(160, 20, 255)},
        ["Domain Collapse"]= {id = "139473336282527", color = Color3.fromRGB(220, 20, 40)},
        ["Nuclear Mushroom"]= {id = "139473336282527", color = Color3.fromRGB(255, 180, 0)},
        ["Sakura Petal Burst"]     = {id = "78525344606616",  color = Color3.fromRGB(255, 160, 210)},
        ["Absolute Ice Blast"]   = {id = "129507052510465", color = Color3.fromRGB(170, 240, 255)},
        ["Zeus Divine Bolt"]   = {id = "120733349948660", color = Color3.fromRGB(255, 235, 70)},
        ["Bloody Solar Eclipse"]= {id = "139473336282527", color = Color3.fromRGB(255, 10, 30)},
        ["Cyber-Glitch Reality Break"]= {id = "102467996925868", color = Color3.fromRGB(0, 255, 100)},
        ["Supernova Flash (Nova)"]   = {id = "120733349948660", color = Color3.fromRGB(255, 255, 255)},
        ["Plasma Detonation"]       = {id = "120733349948660", color = Color3.fromRGB(255, 70, 220)},
        ["Infernal Hellfire"]      = {id = "139473336282527", color = Color3.fromRGB(255, 80, 0)},
        ["Holiday Spirit"]      = {id = "105889460718459", color = Color3.fromRGB(255, 40, 40)},
        ["Coalition Entry"]     = {id = "87611331088941",  color = Color3.fromRGB(0, 110, 255)},
        ["Yellow Entry"]        = {id = "120503712839935", color = Color3.fromRGB(255, 220, 0)},
        ["Serpent Entry"]       = {id = "110882336673427", color = Color3.fromRGB(0, 255, 100)},
        ["Maple Leaf Explosion"]= {id = "138928599975445", color = Color3.fromRGB(220, 70, 0)},
        ["Clover"]              = {id = "98233188002298",  color = Color3.fromRGB(40, 220, 40)}
    }
    local DEATH_EXP_TIME = 2.0
    local DEATH_EXP_DIST = 22
    local DeathFxGuard = {
        kill     = setmetatable({}, { __mode = "k" }),
        hooked   = setmetatable({}, { __mode = "k" }),
        marks    = {},
        deathT   = 0,
        deathPos = Vector3.new(0, -99999, 0)
    }
    local C4OnMyDeath = false
    local function MarkDeathPoint(pos, isSelf)
        if not pos then return end
        local now = tick()
        table.insert(DeathFxGuard.marks, { t = now, pos = pos, self = isSelf and true or false })
        for i = #DeathFxGuard.marks, 1, -1 do
            if now - DeathFxGuard.marks[i].t > (DEATH_EXP_TIME * 3) then
                table.remove(DeathFxGuard.marks, i)
            end
        end
        if isSelf then
            DeathFxGuard.deathT = now
            DeathFxGuard.deathPos = pos
        end
    end
    local function IsDeathExplosionNear(pos, selfOnly)
        if not pos then return false end
        local now = tick()
        for i = #DeathFxGuard.marks, 1, -1 do
            local m = DeathFxGuard.marks[i]
            if now - m.t > DEATH_EXP_TIME then
                table.remove(DeathFxGuard.marks, i)
            elseif (not selfOnly or m.self) and (pos - m.pos).Magnitude <= DEATH_EXP_DIST then
                return true
            end
        end
        return false
    end
    local function PlayKillEffectSafe(targetChar, isDeath)
        if not targetChar then return end
        if not SelectedKillEffect then return end
        if not PlayEffectOnDeath then return end
        if isDeath then
            if DeathFxGuard.kill[targetChar] then return end
            DeathFxGuard.kill[targetChar] = true
        end
        local hrp = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChildWhichIsA("BasePart")
        if not hrp then return end
        local playedByGame = false
        if KillEffectsModule and SelectedKillEffect then
            pcall(function()
                if KillEffectsModule[SelectedKillEffect] then
                    KillEffectsModule[SelectedKillEffect](targetChar, hrp)
                    playedByGame = true
                elseif KillEffectsModule.Bundles and KillEffectsModule.Bundles[SelectedKillEffect] then
                    KillEffectsModule.Bundles[SelectedKillEffect](targetChar)
                    playedByGame = true
                elseif KillEffectsModule.LegacyKillEffects and KillEffectsModule.LegacyKillEffects[SelectedKillEffect] then
                    KillEffectsModule.LegacyKillEffects[SelectedKillEffect](targetChar)
                    playedByGame = true
                end
            end)
        end
        task.spawn(function()
            if not running or BuloHubUnloaded then return end
            local pos = hrp.Position
            local fxFolder = Instance.new("Folder")
            fxFolder.Name = "BuloExtraKillFX"
            fxFolder.Parent = workspace
            local effectSphere = Instance.new("Part")
            effectSphere.Shape = Enum.PartType.Ball
            effectSphere.Size = Vector3.new(2, 2, 2)
            effectSphere.CFrame = CFrame.new(pos)
            effectSphere.Anchored = true
            effectSphere.CanCollide = false
            effectSphere.Material = Enum.Material.Neon
            effectSphere.Transparency = 0.2
            local sel = tostring(SelectedKillEffect or ""):lower()
            local fxColor = Color3.fromRGB(255, 60, 60)
            local tex = "11365689070"
            if sel:find("black") or sel:find("void") or sel:find("abyss") then
                fxColor = Color3.fromRGB(15, 0, 30)
                tex = "120733349948660"
            elseif sel:find("ice") or sel:find("frost") then
                fxColor = Color3.fromRGB(120, 240, 255)
                tex = "82867666729617"
            elseif sel:find("gold") or sel:find("holy") or sel:find("halo") then
                fxColor = Color3.fromRGB(255, 225, 60)
                tex = "5366671365"
            elseif sel:find("sakura") or sel:find("blossom") then
                fxColor = Color3.fromRGB(255, 140, 200)
                tex = "78525344606616"
            elseif sel:find("matrix") or sel:find("glitch") then
                fxColor = Color3.fromRGB(30, 255, 80)
                tex = "91428889211539"
            elseif sel:find("lightning") or sel:find("thunder") then
                fxColor = Color3.fromRGB(0, 220, 255)
                tex = "11365689070"
            elseif sel:find("fire") or sel:find("hell") or sel:find("nova") then
                fxColor = Color3.fromRGB(255, 90, 0)
                tex = "112819328805705"
            end
            effectSphere.Color = fxColor
            effectSphere.Parent = fxFolder
            local emitter = Instance.new("ParticleEmitter")
            emitter.Texture = "rbxassetid://" .. tex
            emitter.Color = ColorSequence.new(fxColor, Color3.fromRGB(255, 255, 255))
            emitter.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 1.5), NumberSequenceKeypoint.new(0.5, 3.5), NumberSequenceKeypoint.new(1, 0)})
            emitter.LightEmission = 1
            emitter.LightInfluence = 0
            emitter.Speed = NumberRange.new(5, 15)
            emitter.SpreadAngle = Vector2.new(180, 180)
            emitter.Lifetime = NumberRange.new(0.8, 1.4)
            emitter.Rate = 0
            emitter.Parent = effectSphere
            emitter:Emit(45)
            local shockwave = Instance.new("Part")
            shockwave.Shape = Enum.PartType.Cylinder
            shockwave.Size = Vector3.new(0.4, 2, 2)
            shockwave.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
            shockwave.Anchored = true
            shockwave.CanCollide = false
            shockwave.Material = Enum.Material.Neon
            shockwave.Color = fxColor
            shockwave.Transparency = 0.3
            shockwave.Parent = fxFolder
            local s = Instance.new("Sound")
            s.SoundId = "rbxassetid://138186576"
            s.Volume = 1
            s.Parent = effectSphere
            pcall(function() s:Play() end)
            local tweenService = game:GetService("TweenService")
            pcall(function()
                tweenService:Create(effectSphere, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = Vector3.new(18, 18, 18),
                    Transparency = 1
                }):Play()
                tweenService:Create(shockwave, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = Vector3.new(0.2, 26, 26),
                    Transparency = 1
                }):Play()
            end)
            task.delay(1.5, function()
                pcall(function() fxFolder:Destroy() end)
            end)
        end)
    end
    local function SpawnCustomC4(pos, c4Name)
        local eff = c4Name or SelectedC4Effect
        if not eff then return end
        local data = C4_DATA[eff]
        if not data then return end
        local sound = Instance.new("Sound")
        sound.Name = "BuloExtraC4Sound"
        ownedFx[sound] = true
        sound.SoundId = "rbxassetid://9114223180"
        sound.Volume = 2.0
        sound.Parent = workspace
        sound:Play()
        Debris:AddItem(sound, 4)
        local att = Instance.new("Attachment")
        att.Name = "BuloExtraC4Attachment"
        ownedFx[att] = true
        att.WorldPosition = pos
        att.Parent = workspace.Terrain
        local emitter = Instance.new("ParticleEmitter")
        emitter.Texture = "rbxassetid://" .. data.id
        emitter.Color = ColorSequence.new(data.color)
        emitter.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 2.5), NumberSequenceKeypoint.new(0.4, 8), NumberSequenceKeypoint.new(1, 0)})
        emitter.Transparency = NumberSequence.new(0)
        emitter.LightInfluence = 0
        emitter.LightEmission = 1
        emitter.Lifetime = NumberRange.new(1.2, 2.0)
        emitter.Speed = NumberRange.new(12, 25)
        emitter.SpreadAngle = Vector2.new(360, 360)
        emitter.ZOffset = 0.6
        emitter.Parent = att
        local shockwave = Instance.new("Part")
        shockwave.Name = "BuloExtraC4Ring"
        ownedFx[shockwave] = true
        shockwave.Anchored = true
        shockwave.CanCollide = false
        shockwave.Shape = Enum.PartType.Ball
        shockwave.Size = Vector3.new(1, 1, 1)
        shockwave.Material = Enum.Material.Neon
        shockwave.Color = data.color
        shockwave.Transparency = 0
        shockwave.CFrame = CFrame.new(pos)
        shockwave.Parent = workspace
        TweenService:Create(shockwave, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = Vector3.new(30, 30, 30),
            Transparency = 1
        }):Play()
        emitter:Emit(80)
        Debris:AddItem(shockwave, 0.55)
        Debris:AddItem(att, 3.5)
    end
    local api = {}
    local connections, watchedCharacters, watchedC4, watchedRemotes = {}, setmetatable({}, {__mode="k"}), setmetatable({}, {__mode="k"}), setmetatable({}, {__mode="k"})
    local function connect(signal, callback)
        local c = signal:Connect(callback)
        connections[c] = true
        return c
    end
    local lastExplosionAt, lastExplosionPos = 0, Vector3.new(0, -99999, 0)
    local recentCharges, c4Connections = {}, {}
    local c4Generation = 0
    local function connectC4(signal, callback)
        local connection = connect(signal, callback)
        c4Connections[connection] = true
        return connection
    end
    local function stopC4Observers()
        c4Generation += 1
        for connection in pairs(c4Connections) do
            pcall(function() connection:Disconnect() end)
            connections[connection] = nil
        end
        table.clear(c4Connections)
        table.clear(watchedC4)
        table.clear(watchedRemotes)
        table.clear(recentCharges)
    end
    local function rememberCharge(pos)
        if not pos then return end
        table.insert(recentCharges, {pos=pos, time=tick()})
        while #recentCharges > 32 do table.remove(recentCharges, 1) end
    end
    local function nearCharge(pos)
        if not pos then return false end
        for i = #recentCharges, 1, -1 do
            local entry = recentCharges[i]
            if tick() - entry.time > 2 then table.remove(recentCharges, i)
            elseif (pos - entry.pos).Magnitude <= 20 then return true end
        end
        for obj, known in pairs(watchedC4) do
            local current = known
            pcall(function()
                if obj.Parent then current = obj:IsA("BasePart") and obj.Position or obj:GetPivot().Position end
            end)
            if typeof(current) == "Vector3" and (pos - current).Magnitude <= 20 then return true end
        end
        return false
    end
    local function triggerExplosion(pos, allowDeath)
        if not running or BuloHubUnloaded or not SelectedC4Effect or typeof(pos) ~= "Vector3" then return end
        if not allowDeath and IsDeathExplosionNear(pos) then return end
        if tick() - lastExplosionAt < 0.75 and (pos - lastExplosionPos).Magnitude < 10 then return end
        lastExplosionAt, lastExplosionPos = tick(), pos
        pcall(SpawnCustomC4, pos, SelectedC4Effect)
    end
    local function watchCharacter(char, isSelf)
        if not char or watchedCharacters[char] then return end
        watchedCharacters[char] = true
        task.spawn(function()
            local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 10)
            if not running or BuloHubUnloaded or not hum then return end
            local deathConnection
            deathConnection = connect(hum.Died, function()
                if deathConnection then deathConnection:Disconnect(); connections[deathConnection] = nil end
                if not running or BuloHubUnloaded then return end
                local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
                local pos = root and root.Position
                MarkDeathPoint(pos, isSelf)
                if PlayEffectOnDeath and ((isSelf and FxForSelf) or (not isSelf and FxForOthers)) then
                    PlayKillEffectSafe(char, true)
                end
                if isSelf and C4OnMyDeath and SelectedC4Effect then triggerExplosion(pos, true) end
            end)
        end)
    end
    local function watchPlayer(player)
        if player.Character then watchCharacter(player.Character, player == Player) end
        connect(player.CharacterAdded, function(char) watchCharacter(char, player == Player) end)
    end
    for _, player in ipairs(Players:GetPlayers()) do watchPlayer(player) end
    connect(Players.PlayerAdded, watchPlayer)
    local function watchCharge(obj)
        if not SelectedC4Effect or watchedC4[obj] or ownedFx[obj] then return end
        if not obj:IsA("BasePart") and not obj:IsA("Model") and not obj:IsA("Tool") then return end
        local name = obj.Name:lower()
        if not (name:find("c4", 1, true) or name:find("charge", 1, true)
            or name:find("bomb", 1, true) or name:find("explosive", 1, true)) then return end
        local lastPos
        pcall(function() lastPos = obj:IsA("BasePart") and obj.Position or obj:GetPivot().Position end)
        if typeof(lastPos) ~= "Vector3" then return end
        watchedC4[obj] = lastPos
        local chargeConnection
        local current = c4Generation
        chargeConnection = connectC4(obj.AncestryChanged, function(_, parent)
            if parent == nil then
                if chargeConnection then
                    chargeConnection:Disconnect()
                    connections[chargeConnection] = nil
                    c4Connections[chargeConnection] = nil
                end
                if current ~= c4Generation or not running or BuloHubUnloaded or not SelectedC4Effect then watchedC4[obj] = nil; return end
                local pos = watchedC4[obj] or lastPos
                pcall(function() pos = obj:IsA("BasePart") and obj.Position or obj:GetPivot().Position end)
                watchedC4[obj] = nil
                rememberCharge(pos)
                task.delay(0.05, function() triggerExplosion(pos) end)
            end
        end)
    end
    local function watchRemote(remote)
        if watchedRemotes[remote] or not remote:IsA("RemoteEvent") then return end
        local name = remote.Name:lower()
        if not (name:find("expl", 1, true) or name:find("c4", 1, true)
            or name:find("bomb", 1, true) or name:find("detonat", 1, true)) then return end
        watchedRemotes[remote] = true
        local explicit = name:find("c4", 1, true) or name:find("bomb", 1, true) or name:find("detonat", 1, true)
        local current = c4Generation
        connectC4(remote.OnClientEvent, function(...)
            if current ~= c4Generation or not running or BuloHubUnloaded or not SelectedC4Effect then return end
            for _, arg in ipairs({...}) do
                local pos = typeof(arg) == "Vector3" and arg or typeof(arg) == "CFrame" and arg.Position or nil
                if pos and (explicit or nearCharge(pos)) then
                    if explicit then rememberCharge(pos) end
                    triggerExplosion(pos)
                    break
                end
            end
        end)
    end
    local function onC4WorkspaceAdded(obj)
        if not running or BuloHubUnloaded or not SelectedC4Effect or ownedFx[obj] then return end
        if not obj:IsA("Explosion") and not obj:IsA("Sound") and not obj:IsA("BasePart")
            and not obj:IsA("Model") and not obj:IsA("Tool") then return end
        local current = c4Generation
        task.defer(function()
            if current ~= c4Generation or not running or BuloHubUnloaded or not SelectedC4Effect
                or ownedFx[obj] or not obj.Parent then return end
            if obj:IsA("Explosion") then
                local pos = obj.Position
                if not IsDeathExplosionNear(pos) and nearCharge(pos) then
                    pcall(function() obj.Visible = false end)
                    triggerExplosion(pos)
                end
            elseif obj:IsA("Sound") then
                local name = obj.Name:lower()
                if name:find("expl", 1, true) or name:find("boom", 1, true)
                    or name:find("detonat", 1, true) or name:find("c4", 1, true) then
                    local pos
                    local parent = obj.Parent
                    pcall(function()
                        if parent:IsA("BasePart") then pos = parent.Position
                        elseif parent:IsA("Attachment") then pos = parent.WorldPosition
                        elseif parent:IsA("Model") then pos = parent:GetPivot().Position end
                    end)
                    local explicit = name:find("c4", 1, true) or name:find("bomb", 1, true)
                    if pos and not IsDeathExplosionNear(pos) and (explicit or nearCharge(pos)) then
                        if explicit then rememberCharge(pos) end
                        triggerExplosion(pos)
                    end
                end
            else
                watchCharge(obj)
            end
        end)
    end
    local function startC4Observers()
        c4Generation += 1
        local current = c4Generation
        connectC4(workspace.DescendantAdded, onC4WorkspaceAdded)
        connectC4(ReplicatedStorage.DescendantAdded, function(obj)
            if not obj:IsA("RemoteEvent") then return end
            task.defer(function()
                if current == c4Generation and running and not BuloHubUnloaded and SelectedC4Effect and obj.Parent then
                    watchRemote(obj)
                end
            end)
        end)
        task.spawn(function()
            for index, obj in BuloWalkDescendants(workspace) do
                if current ~= c4Generation or not running or BuloHubUnloaded or not SelectedC4Effect then return end
                if obj.Parent and obj:IsDescendantOf(workspace) then watchCharge(obj) end
                if index % 500 == 0 then task.wait() end
            end
        end)
        task.spawn(function()
            for index, obj in BuloWalkDescendants(ReplicatedStorage) do
                if current ~= c4Generation or not running or BuloHubUnloaded or not SelectedC4Effect then return end
                if obj.Parent and obj:IsDescendantOf(ReplicatedStorage) then watchRemote(obj) end
                if index % 500 == 0 then task.wait() end
            end
        end)
    end
    function api.Names(source)
        local out = {"None"}
        if source == "Kill" then
            for _, name in ipairs(ALL_KILL_EFFECTS) do table.insert(out, name) end
        else
            local names = {}
            for name in pairs(C4_DATA) do table.insert(names, name) end
            table.sort(names)
            for _, name in ipairs(names) do table.insert(out, name) end
        end
        return out
    end
    function api.SetKill(name)
        SelectedKillEffect = name ~= "None" and name or nil
        PlayEffectOnDeath = SelectedKillEffect ~= nil
        if SelectedKillEffect then loadKillEffectsModule() end
    end
    function api.SetC4(name)
        local wasActive = SelectedC4Effect ~= nil
        SelectedC4Effect = name ~= "None" and name or nil
        if SelectedC4Effect and not wasActive then
            startC4Observers()
        elseif not SelectedC4Effect and wasActive then
            stopC4Observers()
        end
    end
    function api.SetMaster(on) PlayEffectOnDeath = on and true or false end
    function api.SetSelf(on) FxForSelf = on and true or false end
    function api.SetOthers(on) FxForOthers = on and true or false end
    function api.SetC4OnDeath(on) C4OnMyDeath = on and true or false end
    function api.TestKill()
        if SelectedKillEffect and Player.Character then PlayKillEffectSafe(Player.Character, false) end
    end
    function api.TestC4()
        local char = Player.Character
        local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart"))
        if root and SelectedC4Effect then pcall(SpawnCustomC4, root.Position + root.CFrame.LookVector * 6, SelectedC4Effect) end
    end
    function api.Cleanup()
        running = false
        SelectedKillEffect, SelectedC4Effect = nil, nil
        PlayEffectOnDeath, FxForSelf, FxForOthers, C4OnMyDeath = false, false, false, false
        stopC4Observers()
        for c in pairs(connections) do pcall(function() c:Disconnect() end) end
        table.clear(connections)
        for obj in pairs(ownedFx) do pcall(function() obj:Destroy() end) end
        table.clear(ownedFx)
        for _, child in ipairs(workspace:GetChildren()) do
            if child.Name == "BuloExtraKillFX" then pcall(function() child:Destroy() end) end
        end
    end
    return api
end
    BuloExtra = {
        Fly = SetupNewFly(),
        Interact = SetupAutoInteractions(),
        Anti = SetupAntiSCP(),
        Objects = SetupSCPObjectCosmetics(),
        Back = SetupBackCosmetics(),
        Fx = SetupExtraFx(),
    }
    function BuloExtra.Cleanup()
        for _, name in ipairs({"Fly", "Interact", "Anti", "Objects", "Back", "Fx"}) do
            local item = BuloExtra[name]
            if item and item.Cleanup then pcall(item.Cleanup) end
        end
    end
end
local THEME = Airflow.ThemePresets.Sakura
if THEME then
	pcall(function()
		Airflow:SetDefaultTheme(THEME)
	end)
end
local previousWindow = getgenv().__IxaHubSCPWindow
if previousWindow then
	pcall(function()
		previousWindow:Destroy()
	end)
end
pcall(function()
	local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
	local ok, hui = pcall(gethui)
	for _, holder in ipairs({ pg, ok and hui or nil }) do
		local stale = holder and holder:FindFirstChild("Ixa Hub")
		if stale then
			stale:Destroy()
		end
	end
end)
Window = Airflow:CreateWindow({
	Name = "Ixa Hub",
	LoadingSubtitle = "SCP Roleplay",
	ToggleUIKeybind = KEYS.toggle,
	OpenButton = false,
	Size = UDim2.fromOffset(780, 560),
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
		Tier = "v2",
		Stats = { "Players", "Session", "FPS", "Ping", "Game", "Executor" },
	},
})
getgenv().__IxaHubSCPWindow = Window
getgenv().__IxaHubWindow = Window
do
	local miniKey = Enum.KeyCode[KEYS.minimize or "K"]
	if miniKey then
		BuloTrackConnection(UIS.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then return end
			if input.KeyCode ~= miniKey then return end
			if not Window or Window._destroyed then return end
			if Window.Minimized then
				pcall(function() Window:Restore() end)
			elseif Window.Open == false then
				pcall(function() Window:Toggle(true) end)
			else
				pcall(function() Window:Minimize() end)
			end
		end))
	end
end
local DISCORD_INVITE = "https://discord.gg/BpfKcTbap2"
local PROMO_INTERVAL = 30 * 60
local PROMO_RETRY_DELAY = 2
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
local function promoStrings()
	return PROMO_STRINGS[InterfaceLanguage] or PROMO_STRINGS.English
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
	-- приоритет 1: тот же контейнер, где лежит основное окно хаба
	local mainWindow = (type(getgenv) == "function" and (getgenv().__IxaHubSCPWindow or getgenv().__IxaHubWindow)) or Window
	if mainWindow and mainWindow.Gui and typeof(mainWindow.Gui) == "Instance" and mainWindow.Gui.Parent then
		return mainWindow.Gui.Parent, mainWindow.Gui.DisplayOrder
	end
	-- приоритет 2: gethui() (защищённый контейнер, как использует сама библиотека UI)
	local ok, hui = pcall(function()
		if typeof(gethui) == "function" then return gethui() end
	end)
	if ok and typeof(hui) == "Instance" then
		return hui, 999
	end
	-- приоритет 3: CoreGui
	local coreOk, coreGui = pcall(function() return game:GetService("CoreGui") end)
	if coreOk and coreGui then
		local canParent = pcall(function()
			local probe = Instance.new("Folder")
			probe.Parent = coreGui
			probe:Destroy()
		end)
		if canParent then return coreGui, 999 end
	end
	-- приоритет 4: PlayerGui (как было раньше)
	return nil, 999
end
local function promoHolder()
	if promoGui and promoGui.Parent then return promoGui end
	promoGui = nil
	local parent, order = promoHolderParent()
	local playerGui
	if not parent then
		playerGui = Player:FindFirstChildOfClass("PlayerGui")
		if not playerGui then
			local waited = Player:WaitForChild("PlayerGui", 10)
			playerGui = waited and waited:IsA("PlayerGui") and waited or Player:FindFirstChildOfClass("PlayerGui")
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
	-- если защищённый контейнер не принял GUI — падаем обратно в PlayerGui
	if not inserted or not gui.Parent then
		if playerGui == nil then
			playerGui = Player:FindFirstChildOfClass("PlayerGui") or Player:WaitForChild("PlayerGui", 10)
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
function refreshPromoToastTexts()
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
	if BuloHubUnloaded then return false end
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
	while not BuloHubUnloaded do
		local ok, shown = pcall(showPromoToast)
		if not ok then
			warn("[Ixa Hub] Discord toast error: " .. tostring(shown))
		end
		shown = ok and shown
		if not shown then
			task.wait(PROMO_RETRY_DELAY)
		else
			local waited = 0
			while waited < PROMO_INTERVAL do
				if BuloHubUnloaded then return end
				task.wait(1)
				waited += 1
			end
		end
	end
end)
local AliasesDone = false
local function ensureAliases(container)
	if AliasesDone then
		return
	end
	local mt = getmetatable(container)
	local cls = (type(mt) == "table") and rawget(mt, "__index") or nil
	if type(cls) ~= "table" then
		return
	end
	for _, n in ipairs({ "Toggle", "Slider", "Dropdown", "ColorPicker", "Keybind", "Input", "Button", "Label", "Paragraph", "Log", "Status" }) do
		if cls[n] == nil then
			cls[n] = cls["Create" .. n]
		end
		if cls["Create" .. n] == nil then
			cls["Create" .. n] = cls[n]
		end
	end
	AliasesDone = true
end
AimPage = Window:CreateTab({ Name = "Aim", Icon = "crosshair" })
CombatPage = Window:CreateTab({ Name = "Combat", Icon = "swords" })
VisualsPage = Window:CreateTab({ Name = "Visuals", Icon = "eye" })
MiscPage = Window:CreateTab({ Name = "Misc", Icon = "settings" })
SilentAimSection = AimPage:CreateGroupbox({ Name = "Silent Aim (Advanced)", Side = "Left" })
ensureAliases(SilentAimSection)
SilentAimToggle = SilentAimSection:Toggle({
    Name = "Silent Aim",
    Flag = "SilentAimAdv",
    Default = false,
    Callback = function(v)
        if not UIReady then return end
        silentAimEnabled = v
        if v and BuloStartSilentAimHook then BuloStartSilentAimHook() end
        if not v then silentAimTarget = nil end
        if DrawingAvailable then pcall(function() silentFOVring.Visible = v end) end
    end
})
SilentAimSection:Dropdown({
    Name = "Target Part",
    Flag = "SilentAimTargetPart",
    Default = "Auto",
    Options = {"Auto", "Nearest Hitbox", "Head", "Torso", "HumanoidRootPart"},
    Callback = function(value)
        if not UIReady then return end
        if type(value) == "table" then value = value[1] end
        if value == "Auto" or value == "Nearest Hitbox" or value == "Head"
            or value == "Torso" or value == "HumanoidRootPart" then
            silentAimTargetPart = value
        end
    end
})
SilentAimSection:Toggle({
    Name = "Target SCPs",
    Flag = "SilentAimTargetSCPs",
    Default = false,
    Callback = function(v)
        if not UIReady then return end
        silentAimTargetSCPs = v
    end
})
SilentAimSection:Toggle({
    Name = "Wall Check",
    Flag = "SilentAimWallCheck",
    Default = true,
    Callback = function(v)
        if not UIReady then return end
        silentAimWallCheck = v
    end
})
SilentAimSection:Toggle({
    Name = "Shoot Through Walls",
    Flag = "SilentAimAllowWallbang",
    Default = true,
    Callback = function(v)
        if not UIReady then return end
        silentAimAllowWallbang = v
    end
})
SilentAimSection:Slider({
    Name = "Silent Aim FOV",
    Flag = "SilentAimFOV",
    Min = 30,
    Max = 400,
    Default = 100,
    Suffix = "px",
    Increment = 0.1,
    Callback = function(v)
        if not UIReady then return end
        silentAimFOV = v
        if DrawingAvailable then pcall(function() silentFOVring.Radius = v end) end
    end
})
SilentAimSection:Slider({
    Name = "Hit Chance",
    Flag = "SilentAimHitChance",
    Min = 0,
    Max = 100,
    Default = 100,
    Suffix = "%",
    Increment = 0.1,
    Callback = function(v)
        if not UIReady then return end
        silentAimHitChance = v
    end
})
SilentAimSection:Slider({
    Name = "Auto Head Chance",
    Flag = "SilentAimHeadChance",
    Min = 0,
    Max = 100,
    Default = 100,
    Suffix = "%",
    Increment = 0.1,
    Callback = function(v)
        if not UIReady then return end
        silentAimHeadChance = v
    end
})
SilentAimSection:Slider({
    Name = "Auto Torso Chance",
    Flag = "SilentAimTorsoChance",
    Min = 0,
    Max = 100,
    Default = 100,
    Suffix = "%",
    Increment = 0.1,
    Callback = function(v)
        if not UIReady then return end
        silentAimTorsoChance = v
    end
})
SilentAimSection:Slider({
    Name = "Auto Root Chance",
    Flag = "SilentAimRootChance",
    Min = 0,
    Max = 100,
    Default = 100,
    Suffix = "%",
    Increment = 0.1,
    Callback = function(v)
        if not UIReady then return end
        silentAimRootChance = v
    end
})
SilentAimSection:Toggle({
    Name = "Auto Reload",
    Flag = "AutoReload",
    Default = false,
    Callback = function(v)
        if not UIReady then return end
        BuloSetAutoReload(v)
    end
})
FlingSection = CombatPage:CreateGroupbox({ Name = "Fling", Side = "Left" })
FlingToggle = FlingSection:Toggle({
    Name = "Enable Fling",
    Flag = "FlingToggle",
    Default = false,
    Callback = function(v)
        if not UIReady then return end
        if v then fling() else unfling() end
    end
})
FlingV2Section = CombatPage:CreateGroupbox({ Name = "Fling V2.0", Side = "Right" })
FlingV2Toggle = FlingV2Section:Toggle({
    Name = "Enable Fling V2.0",
    Flag = "FlingV2Enabled",
    Default = false,
    Callback = function(v)
        if not UIReady then return end
        setFlingV2Enabled(v)
    end
})
FlingV2Section:Slider({
    Name = "Walk Speed",
    Flag = "FlingV2WalkSpeed",
    Min = 0,
    Max = 30,
    Default = 16,
    Increment = 0.1,
    Callback = function(v)
        if not UIReady then return end
        FlingV2.WalkSpeed = v
    end
})
FlingV2Section:Slider({
    Name = "Fling Power",
    Flag = "FlingV2Power",
    Min = 100,
    Max = 600,
    Default = 300,
    Step = 10,
    Increment = 1,
    Callback = function(v)
        if not UIReady then return end
        FlingV2.FlingPower = v
    end
})
SpeedSection = CombatPage:CreateGroupbox({ Name = "Speed", Side = "Right" })
SpeedhackToggle = SpeedSection:Toggle({
    Name = "Speedhack",
    Flag = "Speedhack",
    Default = false,
    Callback = function(v)
        if not UIReady then return end
        Cfg.SpeedhackEnabled = v
    end
})
SpeedSection:Slider({
    Name = "Speed Multiplier",
    Flag = "SpeedMult",
    Min = 10,
    Max = 20,
    Default = 15,
    Suffix = "x0.1",
    Increment = 0.1,
    Callback = function(v)
        if not UIReady then return end
        Cfg.SpeedMultiplier = v
    end
})
SpeedSection:Toggle({
    Name = "Anti-Slowdown",
    Flag = "AntiSlow",
    Default = false,
    Callback = function(v)
        if not UIReady then return end
        Cfg.AntiSlowdown = v
    end
})
NoclipToggle = SpeedSection:Toggle({
    Name = "NoClip",
    Flag = "Noclip",
    Default = false,
    Callback = function(v)
        if not UIReady then return end
        Cfg.NoclipEnabled = v
        if not BuloCollisionWanted() then BuloRestoreCollision() end
    end
})
JumpSection = CombatPage:CreateGroupbox({ Name = "Jump", Side = "Right" })
InfJumpToggle = JumpSection:Toggle({
    Name = "Infinity Jump",
    Flag = "InfJump",
    Default = false,
    Callback = function(v)
        if not UIReady then return end
        Cfg.InfJumpEnabled = v
    end
})
JumpSection:Slider({
    Name = "Jump Force",
    Flag = "JumpForce",
    Min = 20,
    Max = 150,
    Default = 50,
    Increment = 0.1,
    Callback = function(v)
        if not UIReady then return end
        Cfg.InfJumpForce = v
    end
})
FlySection = CombatPage:CreateGroupbox({ Name = "Fly", Side = "Right" })
FlyToggle = FlySection:Toggle({
    Name = "Enable Fly",
    Flag = "FlyToggle",
    Default = false,
    Callback = function(v)
        if not UIReady then return end
        if v then
            enableFly()
            if UIS.TouchEnabled then createFlyMobileControls() end
        else
            disableFly()
            pcall(function()
                local g = Player.PlayerGui:FindFirstChild("FlyMobileControls")
                if g then g:Destroy() end
            end)
        end
    end
})
FlySection:Slider({
    Name = "Fly Speed",
    Flag = "FlySpeedSlider",
    Min = 5,
    Max = 100,
    Default = 35,
    Increment = 0.1,
    Callback = function(v)
        if not UIReady then return end
        Cfg.FlySpeed = v
    end
})
TeleportLocSection = CombatPage:CreateGroupbox({ Name = "Teleport (Locations)", Side = "Right" })
TeleportLocSection:Button({Name = "Class D Cell", Callback = function() advancedTeleport(218, 2, -58) end})
TeleportLocSection:Button({Name = "Sector 1", Callback = function() advancedTeleport(-71, 2, 96) end})
TeleportLocSection:Button({Name = "Sector 2", Callback = function() advancedTeleport(-113, 2, -531) end})
TeleportLocSection:Button({Name = "Sector 3", Callback = function() advancedTeleport(-42, 2, -973) end})
TeleportLocSection:Button({Name = "Biohazard Sector", Callback = function() advancedTeleport(113, 2, -966) end})
TeleportLocSection:Button({Name = "Bunker", Callback = function() advancedTeleport(-496, -10, -262) end})
TeleportLocSection:Button({Name = "Helipad", Callback = function() advancedTeleport(-80, -9, 963) end})
TeleportLocSection:Button({Name = "MTF Spawn", Callback = function() advancedTeleport(-66, 2, -866) end})
TeleportLocSection:Button({Name = "CI Spawn", Callback = function() advancedTeleport(-136, 116, -192) end})
TeleportLocSection:Button({Name = "Outside MTF Base", Callback = function() advancedTeleport(-477, 0, 708) end})
TeleportLocSection:Button({Name = "Transformers", Callback = function() advancedTeleport(-255, -10, -141) end})
TeleportLocSection:Button({Name = "Administration", Callback = function() advancedTeleport(-144, 24, 498) end})
TeleportLocSection:Button({Name = "Medical Center", Callback = function() advancedTeleport(24, 2, 16) end})
TeleportLocSection:Button({Name = "Control Room", Callback = function() advancedTeleport(-75, 24, 449) end})
TeleportSCPSection = CombatPage:CreateGroupbox({ Name = "Teleport (SCP Chambers)", Side = "Right" })
TeleportSCPSection:Button({Name = "SCP-008", Callback = function() advancedTeleport(208, 2, -1083) end})
TeleportSCPSection:Button({Name = "SCP-002", Callback = function() advancedTeleport(-164, 2, -1140) end})
TeleportSCPSection:Button({Name = "SCP-016", Callback = function() advancedTeleport(411, 2, -1038) end})
TeleportSCPSection:Button({Name = "SCP-023", Callback = function() advancedTeleport(-288, 2, -684) end})
TeleportSCPSection:Button({Name = "SCP-049", Callback = function() advancedTeleport(44, 2, -587) end})
TeleportSCPSection:Button({Name = "SCP-066", Callback = function() advancedTeleport(-204, 2, -498) end})
TeleportSCPSection:Button({Name = "SCP-076", Callback = function() advancedTeleport(-26, 2, -1331) end})
TeleportSCPSection:Button({Name = "SCP-087", Callback = function() advancedTeleport(-58, 2, -726) end})
TeleportSCPSection:Button({Name = "SCP-093", Callback = function() advancedTeleport(92, 2, -372) end})
TeleportSCPSection:Button({Name = "SCP-106", Callback = function() advancedTeleport(-303, 2, -1057) end})
TeleportSCPSection:Button({Name = "SCP-131", Callback = function() advancedTeleport(40, 2, -384) end})
TeleportSCPSection:Button({Name = "SCP-173", Callback = function() advancedTeleport(23, 16, -535) end})
TeleportSCPSection:Button({Name = "SCP-299", Callback = function() advancedTeleport(335, -40, -1097) end})
TeleportSCPSection:Button({Name = "SCP-316", Callback = function() advancedTeleport(-146, 2, -201) end})
TeleportSCPSection:Button({Name = "SCP-409", Callback = function() advancedTeleport(258, 2, -938) end})
TeleportSCPSection:Button({Name = "SCP-457", Callback = function() advancedTeleport(-353, 2, -870) end})
TeleportSCPSection:Button({Name = "SCP-682", Callback = function() advancedTeleport(-618, -70, 898) end})
TeleportSCPSection:Button({Name = "SCP-939", Callback = function() advancedTeleport(-154, -81, -963) end})
TeleportSCPSection:Button({Name = "SCP-966", Callback = function() advancedTeleport(11, 2, -933) end})
TeleportSCPSection:Button({Name = "SCP-999", Callback = function() advancedTeleport(103, 2, -98) end})
TeleportSCPSection:Button({Name = "SCP-1025", Callback = function() advancedTeleport(-137, 2, -387) end})
TeleportSCPSection:Button({Name = "SCP-1299", Callback = function() advancedTeleport(-163, 2, -117) end})
TeleportSCPSection:Button({Name = "SCP-2950", Callback = function() advancedTeleport(-160, 2, -29) end})
TeleportSCPSection:Button({Name = "SCP-079", Callback = function() advancedTeleport(176, 2, -674) end})
TeleportSCPSection:Button({Name = "SCP-096", Callback = function() advancedTeleport(324, 2, -848) end})
PlayerESPSection = VisualsPage:CreateGroupbox({ Name = "Player ESP", Side = "Left" })
EspToggle = PlayerESPSection:Toggle({
    Name = "Enable ESP",
    Flag = "EspToggle",
    Default = false,
    Callback = function(v)
        if not UIReady then return end
        ESPConfig.Enabled = v
        if v then
            for _, player in ipairs(Players:GetPlayers()) do
                pcall(CreateESPForPlayer, player)
            end
        end
    end
})
PlayerESPSection:Toggle({
    Name = "Show Boxes",
    Flag = "ShowBoxes",
    Default = true,
    Callback = function(v)
        if not UIReady then return end
        ESPConfig.ShowBoxes = v
    end
})
PlayerESPSection:Toggle({
    Name = "Show Names",
    Flag = "ShowNames",
    Default = true,
    Callback = function(v)
        if not UIReady then return end
        ESPConfig.ShowNames = v
    end
})
PlayerESPSection:Toggle({
    Name = "Show Health Bar",
    Flag = "ShowHp",
    Default = true,
    Callback = function(v)
        if not UIReady then return end
        ESPConfig.ShowHealthBar = v
    end
})
PlayerESPSection:Toggle({
    Name = "Team Colors",
    Flag = "TeamColor",
    Default = true,
    Callback = function(v)
        if not UIReady then return end
        ESPConfig.ShowTeamColor = v
    end
})
SCPEspSection = VisualsPage:CreateGroupbox({ Name = "SCP ESP", Side = "Right" })
ScpEspToggle = SCPEspSection:Toggle({
    Name = "SCP ESP (Blue)",
    Flag = "ScpEspToggle",
    Default = false,
    Callback = function(v)
        if not UIReady then return end
        BuloSetSCPESP(v)
    end
})
SCPEspSection:Toggle({
    Name = "Show SCP Names",
    Flag = "ScpEspNames",
    Default = true,
    Callback = function(v)
        if not UIReady then return end
        setSCPNameLabelsVisible(v)
    end
})
SCPEspSection:ColorPicker({Name = "SCP ESP Color", Alpha = false,
    Flag = "ScpEspColor",
    Default = Color3.fromRGB(0, 120, 255),
    Callback = function(value)
        if not UIReady then return end
        scpEspColor = value
        applySCPESPColors()
    end
})
SCPEspSection:ColorPicker({Name = "SCP Name Color", Alpha = false,
    Flag = "ScpEspNameColor",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(value)
        if not UIReady then return end
        scpEspNameColor = value
        applySCPESPColors()
    end
})
WeaponSkinSection = VisualsPage:CreateGroupbox({ Name = "Weapon Skins", Side = "Left" })
WeaponSkinSection:Toggle({
    Name = "Enable Skin Changer",
    Flag = "WeaponSkinEnabled",
    Default = false,
    Callback = function(v)
        if not UIReady then return end
        weaponSkinEnabled = v
        if v then applyWeaponSkinChanger(true) end
    end
})
WeaponSkinSection:Toggle({
    Name = "Rainbow Chroma",
    Flag = "WeaponSkinRainbow",
    Default = false,
    Callback = function(v)
        if not UIReady then return end
        weaponSkinRainbow = v
    end
})
WeaponSkinSection:Slider({
    Name = "Weapon Rainbow Speed",
    Flag = "WeaponSkinRainbowSpeed",
    Min = 1,
    Max = 10,
    Default = 1,
    Increment = 0.1,
    Callback = function(v)
        if not UIReady then return end
        weaponSkinRainbowSpeed = v
    end
})
WeaponSkinSection:Toggle({
    Name = "Custom Weapon Tint",
    Flag = "WeaponSkinUseTint",
    Default = false,
    Callback = function(v)
        if not UIReady then return end
        weaponSkinUseTint = v
        if weaponSkinEnabled then applyWeaponSkinChanger(true) end
    end
})
WeaponSkinSection:ColorPicker({Name = "Weapon Tint Color", Alpha = false,
    Flag = "WeaponSkinTint",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(value)
        if not UIReady then return end
        weaponSkinTint = value
        if weaponSkinEnabled then applyWeaponSkinChanger(true) end
    end
})
WeaponSkinSection:Dropdown({
    Name = "Gun Skin",
    Flag = "WeaponSkinName",
    Default = "Obsidian",
    Options = {"Obsidian", "Gold", "Diamond", "Emerald", "Ruby", "Platinum", "Dimension", "Gem", "Waves", "Hazard", "Cheese", "SCP", "Anniversary 2025", "Halloween 2024", "Winter 2024", "Halloween 2023", "Winter 2023", "Gold Wrap", "Reptile", "Protector", "Liberator", "Plasma", "Fire", "Energy", "Warp", "Moon", "Metal", "Rust", "Crystal", "Ice", "Hexagon", "Snow", "Tiger", "Zebra", "Glass", "Paint", "Ghost", "Sky", "Night", "Flecktarn", "Woodland", "Splinter", "Digital", "Navy", "Urban"},
    Callback = function(value)
        if not UIReady then return end
        if type(value) == "table" then value = value[1] end
        weaponSkinName = value
        if weaponSkinEnabled then applyWeaponSkinChanger(true) end
    end
})
WeaponSkinSection:Dropdown({
    Name = "Weapon Material",
    Flag = "WeaponSkinMaterial",
    Default = "Default",
    Options = {"Default", "ForceField (Glow)", "Neon", "Glass", "Foil (Chrome)", "SmoothPlastic"},
    Callback = function(value)
        if not UIReady then return end
        if type(value) == "table" then value = value[1] end
        weaponSkinMaterial = value
        if weaponSkinEnabled then applyWeaponSkinChanger(true) end
    end
})
WeaponSkinSection:Dropdown({
    Name = "SCP-096 Bag Skin",
    Flag = "Bag096Skin",
    Default = "Default",
    Options = {"Default", "Biohazard", "Chaotic", "Practice", "Arctic Camo", "Ashen", "Oceanic", "Hacked", "Steampunk", "GOC", "Pumpkin", "Ice"},
    Callback = function(value)
        if not UIReady then return end
        if type(value) == "table" then value = value[1] end
        bag096Skin = value
        if weaponSkinEnabled then applyWeaponSkinChanger(true) end
    end
})
WeaponSkinSection:Dropdown({
    Name = "SCP-173 Cage Skin",
    Flag = "Cage173Skin",
    Default = "Default",
    Options = {"Default", "Golden Cage", "Task Force", "Under Construction", "Frozen", "Space Age", "Ashen", "Binary Matrix", "Reinforced", "Steampunk"},
    Callback = function(value)
        if not UIReady then return end
        if type(value) == "table" then value = value[1] end
        cage173Skin = value
        if weaponSkinEnabled then applyWeaponSkinChanger(true) end
    end
})
WorldVisualsSection = VisualsPage:CreateGroupbox({ Name = "World", Side = "Right" })
FullBrightToggle = WorldVisualsSection:Toggle({
    Name = "Full Bright",
    Flag = "FullBright",
    Default = false,
    Callback = function(v)
        if not UIReady then return end
        setFullbright(v)
    end
})
WorldVisualsSection:Slider({
    Name = "Camera FOV",
    Flag = "WorldFovSlider",
    Min = 70,
    Max = 120,
    Default = 70,
    Suffix = "deg",
    Increment = 0.1,
    Callback = function(v)
        if not UIReady then return end
        Cfg.WorldFOV = v
        applyWorldFOV()
    end
})
local function SetupParticleAura()
local ParticleAuraSection = VisualsPage:CreateGroupbox({ Name = "Particle Aura", Side = "Right" })
local particleAuraEnabled = false
local particleAuraColor   = Color3.fromRGB(255, 255, 255)
local particle_aura       = nil
local particles           = {}
local particle_aura_connection = nil
local particle_auras = {}
local particle_aura_loading = {}
local particle_aura_selected = "angel"
local particle_aura_ids = {
    ["starlight"] = "134645216613107",
    ["heavenly"]  = "139300897520961",
    ["ribbon"]    = "132069507632161",
    ["sakura"]    = "81755778619404",
    ["angel"]     = "97658130917593",
    ["wind"]      = "80694081850877",
    ["flow"]      = "119913533725648",
    ["star"]      = "73754563740680",
}
local PART_NAMES = {"Head","UpperTorso","LowerTorso","LeftUpperArm","LeftLowerArm","LeftHand","RightUpperArm","RightLowerArm","RightHand","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot","HumanoidRootPart"}
local function get_character_parts()
    local char = Player.Character
    if not char then return nil end
    local parts = {}
    for _, name in ipairs(PART_NAMES) do
        parts[name] = char:FindFirstChild(name)
    end
    return parts
end
local function clear_particle_aura()
    for i = 1, #particles do
        pcall(function() particles[i]:Destroy() end)
        particles[i] = nil
    end
end
local function do_particle_aura()
    if not particleAuraEnabled then return end
    clear_particle_aura()
    local parts = get_character_parts()
    if not parts or not parts.HumanoidRootPart then return end
    if not particle_aura then return end
    local cloned = particle_aura:Clone()
    local children = cloned:GetChildren()
    for i = 1, #children do
        local part = children[i]
        local local_part = parts[part.Name]
        if local_part then
            local sub_children = part:GetChildren()
            for j = 1, #sub_children do
                local child = sub_children[j]
                pcall(function()
                    child.Name = "\0\0"
                    child.Parent = local_part
                end)
                particles[#particles+1] = child
            end
        else
            pcall(function() part:Destroy() end)
        end
    end
    pcall(function() cloned:Destroy() end)
end
local function apply_particle_color(color_value)
    local color = ColorSequence.new(color_value)
    for _, folder in pairs(particle_auras) do
        if folder and type(folder) ~= "string" then
            pcall(function()
                local descendants = folder:GetDescendants()
                for i = 1, #descendants do
                    local d = descendants[i]
                    local cls = d.ClassName
                    if cls == "PointLight" then
                        d.Color = color_value
                    elseif cls == "ParticleEmitter" or cls == "Beam" or cls == "Trail" then
                        d.Color = color
                    end
                end
            end)
        end
    end
    for i = 1, #particles do
        pcall(function()
            local part = particles[i]
            local cls = part.ClassName
            if cls == "PointLight" then
                part.Color = color_value
            elseif cls == "ParticleEmitter" or cls == "Beam" or cls == "Trail" then
                part.Color = color
            end
            local descendants = part:GetDescendants()
            for j = 1, #descendants do
                local d = descendants[j]
                local cls2 = d.ClassName
                if cls2 == "PointLight" then
                    d.Color = color_value
                elseif cls2 == "ParticleEmitter" or cls2 == "Beam" or cls2 == "Trail" then
                    d.Color = color
                end
            end
        end)
    end
end
local function on_particle_char_changed()
    if particleAuraEnabled then task.spawn(do_particle_aura) end
end
local function request_particle_aura(name)
    if not particleAuraEnabled or BuloHubUnloaded then return end
    local cached = particle_auras[name]
    if cached then
        particle_aura = cached
        apply_particle_color(particleAuraColor)
        pcall(do_particle_aura)
        return
    end
    if particle_aura_loading[name] then return end
    particle_aura_loading[name] = true
    task.spawn(function()
        local ok, asset = pcall(function()
            local id = particle_aura_ids[name]
            if id then return game:GetObjects("rbxassetid://" .. id)[1] end
            local path = "juju recode/custom/" .. name
            if not (isfile and isfile(path) and getcustomasset) then return nil end
            local obj = game:GetObjects(getcustomasset(path))[1]
            if not obj then return nil end
            for _, child in ipairs(obj:GetChildren()) do
                local valid = child:IsA("BasePart")
                if valid then
                    valid = false
                    for _, partName in ipairs(PART_NAMES) do
                        if partName == child.Name then valid = true; break end
                    end
                end
                if not valid then obj:Destroy(); return nil end
            end
            return obj
        end)
        particle_aura_loading[name] = nil
        if not ok or not asset then return end
        if BuloHubUnloaded then pcall(function() asset:Destroy() end); return end
        particle_auras[name] = asset
        if particleAuraEnabled and particle_aura_selected == name then
            particle_aura = asset
            apply_particle_color(particleAuraColor)
            pcall(do_particle_aura)
        end
    end)
end
ParticleAuraToggle = ParticleAuraSection:Toggle({
    Name = "Particle Aura",
    Flag = "ParticleAura",
    Default = false,
    Callback = function(v)
        if not UIReady then return end
        particleAuraEnabled = v and true or false
        clear_particle_aura()
        if particle_aura_connection then
            particle_aura_connection:Disconnect()
            particle_aura_connection = nil
        end
        if particleAuraEnabled then
            particle_aura_connection = Player.CharacterAdded:Connect(on_particle_char_changed)
            request_particle_aura(particle_aura_selected)
        end
    end
})
ParticleAuraSection:Dropdown({
    Name = "Particle",
    Flag = "ParticleAuraParticle",
    Default = "angel",
    Options = {"starlight","heavenly","ribbon","sakura","angel","wind","flow","star"},
    Callback = function(value)
        if not UIReady then return end
        local name = type(value) == "table" and value[1] or value
        if type(name) ~= "string" or name == "" then return end
        particle_aura_selected = name
        particle_aura = particle_auras[name]
        if particleAuraEnabled then
            clear_particle_aura()
            request_particle_aura(name)
        end
    end
})
ParticleAuraSection:ColorPicker({Name = "Aura Color", Alpha = false,
    Flag = "ParticleAuraColor",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(value)
        if not UIReady then return end
        particleAuraColor = value
        apply_particle_color(value)
    end
})
BuloClearParticleAura = function()
    particleAuraEnabled = false
    clear_particle_aura()
    if particle_aura_connection then
        particle_aura_connection:Disconnect()
        particle_aura_connection = nil
    end
    for name, asset in pairs(particle_auras) do
        pcall(function() asset:Destroy() end)
        particle_auras[name] = nil
    end
    particle_aura = nil
end
end
SetupParticleAura()
AutoEscapeSection = MiscPage:CreateGroupbox({ Name = "Auto Escape", Side = "Left" })
AutoEscapeSection:Toggle({
    Name = "Auto Escape (Only Class D)",
    Flag = "AutoEscapeClassD",
    Default = false,
    Callback = function(v)
        if not UIReady then return end
        if v then
            toggleAutoEscape()
        else
            stopAutoEscape()
        end
    end
})
AutoBuySection = MiscPage:CreateGroupbox({ Name = "Auto Buy", Side = "Left" })
AutoBuySection:Toggle({
    Name = "Enable Auto Buy",
    Flag = "AutoBuyEnabled",
    Default = false,
    Callback = function(v)
        if not UIReady then return end
        BuloSetAutoBuy(v)
    end
})
AutoBuySection:Slider({
    Name = "Buy Interval",
    Flag = "AutoBuyInterval",
    Min = 1,
    Max = 15,
    Default = 3,
    Suffix = "s",
    Increment = 0.1,
    Callback = function(v)
        if not UIReady then return end
        autoBuyInterval = v
    end
})
AutoBuySection:Dropdown({
    Name = "Buy Items",
    Flag = "AutoBuyItems",
    Default = {"M9"},
    Options = autoBuyItemOptions,
    Multi = true,
    Callback = function(value)
        if not UIReady then return end
        if type(value) == "table" then
            autoBuyItems = value
        elseif type(value) == "string" then
            autoBuyItems = {value}
        end
    end
})
AutoHatchSection = MiscPage:CreateGroupbox({ Name = "Auto Hatches", Side = "Left" })
AutoHatchSection:Toggle({
    Name = "Auto Open Hatches",
    Flag = "AutoHatches",
    Default = false,
    Callback = function(v)
        if not UIReady then return end
        BuloSetAutoHatches(v)
    end
})
AutoHatchSection:Slider({
    Name = "Hatch Radius",
    Flag = "AutoHatchRadius",
    Min = 5,
    Max = 100,
    Default = 30,
    Suffix = " studs",
    Increment = 0.1,
    Callback = function(v)
        if not UIReady then return end
        autoHatchRadius = v
    end
})
AutoHatchSection:Slider({
    Name = "Hatch Delay",
    Flag = "AutoHatchDelay",
    Min = 10,
    Max = 1000,
    Default = 50,
    Suffix = " ms",
    Step = 10,
    Increment = 1,
    Callback = function(v)
        if not UIReady then return end
        autoHatchDelay = v / 1000
    end
})
AntiNameTagSection = MiscPage:CreateGroupbox({ Name = "Anti Name Tag", Side = "Right" })
AntiNameTagToggle = AntiNameTagSection:Toggle({
    Name = "Hide Own Name Tag",
    Flag = "AntiNameTag",
    Default = false,
    Callback = function(v)
        if not UIReady then return end
        if v then enableAntiNameTag() else disableAntiNameTag() end
    end
})
FallReducerSection = MiscPage:CreateGroupbox({ Name = "Fall Damage Reducer", Side = "Right" })
FallReducerToggle = FallReducerSection:Toggle({
    Name = "Fall Damage Reducer",
    Flag = "FallReducer",
    Default = false,
    Callback = function(v)
        if not UIReady then return end
        fallReducerEnabled = v
    end
})
LanguageSection = MiscPage:CreateGroupbox({ Name = "Language", Side = "Right" })
LanguageSection:Dropdown({
    Name = "Language",
    Flag = "InterfaceLanguage",
    Default = "English",
    Options = {"English", "Russian"},
    Callback = function(value)
        if not UIReady then return end
        if type(value) == "table" then value = value[1] end
        if value == "English" or value == "Russian" then
            setInterfaceLanguage(value)
        end
    end
})
UnloadSection = MiscPage:CreateGroupbox({ Name = "Unload Script", Side = "Right" })
UnloadSection:Button({
    Name = "Unload Script",
    Callback = function()
        if UnloadBuloHub then UnloadBuloHub() end
    end
})
do
    local defense = CombatPage:CreateGroupbox({ Name = "Anti-SCP", Side = "Left" })
    local antiToggle = defense:Toggle({
        Name = "Anti-SCP", Flag = "ExtraAntiSCP", Default = false,
        Callback = function(value) if UIReady then BuloExtra.Anti.SetAnti(value) end end,
    })
    BuloExtra.Anti.onFailure = function()
        pcall(function() antiToggle:Set(false) end)
    end
    local interact = MiscPage:CreateGroupbox({ Name = "Auto Interact", Side = "Left" })
    interact:Toggle({
        Name = "Auto Hack", Flag = "ExtraAutoHack", Default = false,
        Callback = function(value) if UIReady then BuloExtra.Interact.SetHack(value) end end,
    })
    interact:Toggle({
        Name = "Auto Prompt", Flag = "ExtraAutoPrompt", Default = false,
        Callback = function(value) if UIReady then BuloExtra.Interact.SetPrompt(value) end end,
    })
    interact:Label({ Text = "Auto Prompt activates nearby interactions" })
    local objects = VisualsPage:CreateGroupbox({ Name = "SCP Object Cosmetics", Side = "Right" })
    objects:Dropdown({
        Name = "SCP-173 Cage (Extra)", Flag = "ExtraCageSkin", Default = "Default",
        Options = BuloExtra.Objects.Names(BuloExtra.Objects.Cage),
        Callback = function(value) if UIReady then BuloExtra.Objects.Set("Cage", value) end end,
    })
    objects:Dropdown({
        Name = "SCP Crate", Flag = "ExtraCrateSkin", Default = "Default",
        Options = BuloExtra.Objects.Names(BuloExtra.Objects.Crate),
        Callback = function(value) if UIReady then BuloExtra.Objects.Set("Crate", value) end end,
    })
    objects:Dropdown({
        Name = "SCP-096 Bag (Extra)", Flag = "ExtraBagSkin", Default = "Default",
        Options = BuloExtra.Objects.Names(BuloExtra.Objects.Bag),
        Callback = function(value) if UIReady then BuloExtra.Objects.Set("Bag", value) end end,
    })
    local back = VisualsPage:CreateGroupbox({ Name = "Back Accessories", Side = "Left" })
    local selection = back:Dropdown({
        Name = "Back Items", Flag = "ExtraBackItems", Default = {}, Multi = true,
        Options = BuloExtra.Back.Names(),
        Callback = function(value) if UIReady then BuloExtra.Back.Select(value) end end,
    })
    local hair = back:Toggle({
        Name = "Hide Hair", Flag = "ExtraHideHair", Default = false,
        Callback = function(value) if UIReady then BuloExtra.Back.SetHair(value) end end,
    })
    local clothes = back:Toggle({
        Name = "Hide Clothing", Flag = "ExtraHideClothing", Default = false,
        Callback = function(value) if UIReady then BuloExtra.Back.SetClothes(value) end end,
    })
    back:Button({Name = "Rotate Last Back Item", Callback = function() BuloExtra.Back.Rotate() end})
    back:Button({Name = "Clear Back Items", Callback = function()
        BuloExtra.Back.Clear()
        selection:Set({})
        hair:Set(false)
        clothes:Set(false)
    end})
    local customId = ""
    back:Input({
        Name = "Custom Asset ID", Flag = "ExtraCustomAsset", PlaceholderText = "Roblox asset ID",
        Default = "", Callback = function(value) customId = value end,
    })
    back:Button({Name = "Wear Custom Asset", Callback = function() BuloExtra.Back.WearCustom(customId, false) end})
    back:Button({Name = "Play Custom Animation", Callback = function() BuloExtra.Back.WearCustom(customId, true) end})
    local fx = VisualsPage:CreateGroupbox({ Name = "Kill & C4 Effects", Side = "Right" })
    local master
    fx:Dropdown({
        Name = "Kill Effect", Flag = "ExtraKillEffect", Default = "None", Options = BuloExtra.Fx.Names("Kill"),
        Callback = function(value)
            if not UIReady then return end
            BuloExtra.Fx.SetKill(value)
            if master then master:Set(value ~= "None") end
        end,
    })
    master = fx:Toggle({
        Name = "Enable Kill Effects", Flag = "ExtraKillEffectsEnabled", Default = false,
        Callback = function(value) if UIReady then BuloExtra.Fx.SetMaster(value) end end,
    })
    fx:Toggle({
        Name = "Kill Effects on Self", Flag = "ExtraKillFxSelf", Default = false,
        Callback = function(value) if UIReady then BuloExtra.Fx.SetSelf(value) end end,
    })
    fx:Toggle({
        Name = "Kill Effects on Others", Flag = "ExtraKillFxOthers", Default = false,
        Callback = function(value) if UIReady then BuloExtra.Fx.SetOthers(value) end end,
    })
    fx:Dropdown({
        Name = "C4 Effect", Flag = "ExtraC4Effect", Default = "None", Options = BuloExtra.Fx.Names("C4"),
        Callback = function(value) if UIReady then BuloExtra.Fx.SetC4(value) end end,
    })
    fx:Toggle({
        Name = "C4 Effect on Own Death", Flag = "ExtraC4Death", Default = false,
        Callback = function(value) if UIReady then BuloExtra.Fx.SetC4OnDeath(value) end end,
    })
    fx:Button({Name = "Test Kill Effect", Callback = function() BuloExtra.Fx.TestKill() end})
    fx:Button({Name = "Test C4 Effect", Callback = function() BuloExtra.Fx.TestC4() end})
end
UnloadBuloHub = function()
    if BuloHubUnloaded then return end
    BuloHubUnloaded = true
    UIReady = false
    if BuloExtra then pcall(BuloExtra.Cleanup) end
    silentAimEnabled = false
    silentAimTarget = nil
    BuloSetAutoReload(false)
    pcall(stopAutoEscape)
    autoBuyEnabled = false
    BuloSetAutoHatches(false)
    scpEspEnabled = false
    weaponSkinEnabled = false
    particleAuraEnabled = false
    fallReducerEnabled = false
    ESPConfig.Enabled = false
    Cfg.FOVEnabled = false
    Cfg.InfJumpEnabled = false
    Cfg.SpeedhackEnabled = false
    Cfg.AntiSlowdown = false
    Cfg.NoclipEnabled = false
    FlingV2.Active = false
    pcall(function() RS:UnbindFromRenderStep("BuloWorldFOVLock") end)
    pcall(function() RS:UnbindFromRenderStep("SilentAimUpdate") end)
    pcall(function() setFlingV2Enabled(false) end)
    pcall(unfling)
    pcall(disableNoclip)
    pcall(BuloRestoreCollision)
    pcall(BuloClearCollisionParts)
    pcall(stopFly)
    pcall(disableFly)
    pcall(NOFLY)
    pcall(disableAntiNameTag)
    pcall(clearSCPHighlights)
    pcall(restoreWeaponAppearances)
    pcall(function() setFullbright(false) end)
    pcall(function()
        if BuloClearParticleAura then BuloClearParticleAura() end
    end)
    if DrawingAvailable then
        pcall(function() silentFOVring:Remove() end)
    end
    for _, objects in pairs(ESPObjects) do
        for _, drawing in pairs(objects) do
            pcall(function() drawing:Remove() end)
        end
    end
    table.clear(ESPObjects)
    for _, connection in ipairs(connections) do
        pcall(function() connection:Disconnect() end)
    end
    table.clear(connections)
    for _, connection in ipairs(BuloDirectConnections) do
        pcall(function() connection:Disconnect() end)
    end
    table.clear(BuloDirectConnections)
    if flyHeartbeatConn then pcall(function() flyHeartbeatConn:Disconnect() end) end
    if flyKeyDown then pcall(function() flyKeyDown:Disconnect() end) end
    if flyKeyUp then pcall(function() flyKeyUp:Disconnect() end) end
    if flingDied then pcall(function() flingDied:Disconnect() end) end
    pcall(function()
        local playerGui = Player:FindFirstChild("PlayerGui")
        if playerGui then
            local mobileAim = playerGui:FindFirstChild("MobileAimButton")
            local flyControls = playerGui:FindFirstChild("FlyMobileControls")
            if mobileAim then mobileAim:Destroy() end
            if flyControls then flyControls:Destroy() end
        end
    end)
    pcall(function() hiddenFolder:Destroy() end)
    pcall(function()
        local currentCamera = workspace.CurrentCamera
        if currentCamera then currentCamera.FieldOfView = BuloOriginalCameraFOV end
    end)
    pcall(function()
        if hookfunction and BuloSilentAimController and BuloSilentAimOriginal then
            hookfunction(BuloSilentAimController, BuloSilentAimOriginal)
        end
    end)
    BuloSilentAimController = nil
    BuloSilentAimOriginal = nil
    BuloSilentAimHook = nil
    pcall(function()
        if hookfunction and BuloWallbangRaycastOriginal then
            hookfunction(workspace.Raycast, BuloWallbangRaycastOriginal)
        end
    end)
    BuloWallbangRaycastOriginal = nil
    BuloWallbangRaycastHook = nil
    BuloWallbangShotUntil = 0
    BuloWallbangInputHeld = false
    pcall(function()
        local gmt = getrawmetatable(game)
        setreadonly(gmt, false)
        if BuloNamecallHook and BuloOriginalNamecall and gmt.__namecall == BuloNamecallHook then
            gmt.__namecall = BuloOriginalNamecall
        end
        if BuloIndexHook and BuloOriginalIndex and gmt.__index == BuloIndexHook then
            gmt.__index = BuloOriginalIndex
        end
        setreadonly(gmt, true)
    end)
    pcall(function()
        if Window and Window.Destroy then Window:Destroy() end
    end)
    pcall(function()
        promoGui = nil
        promoFrame = nil
        local playerGui = Player:FindFirstChildOfClass("PlayerGui")
        local stale = playerGui and playerGui:FindFirstChild("IxaHubPromo")
        if stale then stale:Destroy() end
    end)
end
pcall(function()
    if getgenv then
        getgenv().UnloadBuloHub = UnloadBuloHub
        getgenv().UnloadIxaHub = UnloadBuloHub
    end
end)
if UIS.TouchEnabled then
    task.spawn(function()
        pcall(function()
            local playerGui = Player:FindFirstChild("PlayerGui") or Player:WaitForChild("PlayerGui", 10)
            if BuloHubUnloaded or not playerGui then return end
            local mobileGui=Instance.new("ScreenGui")
            mobileGui.Name="MobileAimButton"; mobileGui.ResetOnSpawn=false
            mobileGui.Parent=playerGui
            local aimButton=Instance.new("TextButton")
            aimButton.Size=UDim2.new(0,80,0,80)
            aimButton.Position=UDim2.new(0.8,-40,0.7,-40)
            aimButton.BackgroundColor3=Color3.fromRGB(0,160,255)
            aimButton.Text=InterfaceLanguage == "Russian" and "АИМ" or "AIM"
            aimButton.TextColor3=Color3.new(1,1,1)
            aimButton.Font=Enum.Font.GothamBold; aimButton.TextSize=16
            aimButton.Parent=mobileGui
            MobileAimButtonRef = aimButton
            Instance.new("UICorner",aimButton).CornerRadius=UDim.new(1,0)
            aimButton.Active=true
            aimButton.InputBegan:Connect(function(inp)
                if inp.UserInputType==Enum.UserInputType.Touch then MobileAimActive=true end
            end)
            aimButton.InputEnded:Connect(function(inp)
                if inp.UserInputType==Enum.UserInputType.Touch then MobileAimActive=false end
            end)
        end)
    end)
end
UIReady = true
applyWorldFOV()
do
    local wasEnabled, elapsed = false, 1 / 60
    table.insert(connections, RS.RenderStepped:Connect(function(dt)
        if BuloHubUnloaded or not DrawingAvailable then return end
        if not ESPConfig.Enabled then
            if wasEnabled then
                wasEnabled = false
                pcall(RenderESP)
            end
            elapsed = 1 / 60
            return
        end
        wasEnabled = true
        elapsed += type(dt) == "number" and math.clamp(dt, 0, 0.5) or 1 / 60
        if elapsed < 1 / 60 then return end
        elapsed %= 1 / 60
        pcall(RenderESP)
    end))
end
table.insert(connections, RS.Heartbeat:Connect(function(dt)
    if Cfg.AntiSlowdown or (Cfg.SpeedhackEnabled and not isFlying and not flyActive) then
        pcall(function()
            if Player.Character then
                local root=Player.Character:FindFirstChild("HumanoidRootPart")
                local hum=Player.Character:FindFirstChildOfClass("Humanoid")
                if hum and Cfg.AntiSlowdown then
                    if hum.WalkSpeed<16 then hum.WalkSpeed=16 end
                end
                if not isFlying and not flyActive and Cfg.SpeedhackEnabled and root and hum and hum.MoveDirection.Magnitude>0 then
                    local baseSpeed=hum.WalkSpeed
                    if Cfg.AntiSlowdown and baseSpeed<16 then baseSpeed=16 end
                    root.CFrame=root.CFrame+(hum.MoveDirection.Unit*baseSpeed*((Cfg.SpeedMultiplier/10)-1)*dt)
                end
            end
        end)
    end
    if isFlying and flyTarget then
        pcall(function()
            local char=Player.Character; if not char then stopFly(); return end
            local root=char:FindFirstChild("HumanoidRootPart"); if not root then stopFly(); return end
            local dir=flyTarget-root.Position; local dist=dir.Magnitude
            if dist<=5 then
                root.CFrame=CFrame.new(flyTarget)
                pcall(function() root.Velocity=Vector3.new(0,0,0) end)
                stopFly(); return
            end
            local step=dir.Unit*math.min(Cfg.FlySpeed,dist)*dt
            pcall(function() root.Velocity=Vector3.new(0,0,0) end)
            pcall(function() root.AssemblyLinearVelocity=Vector3.new(0,0,0) end)
            local ld=Vector3.new(dir.X,0,dir.Z)
            if ld.Magnitude>0.1 then
                root.CFrame=CFrame.lookAt(root.Position+step,root.Position+step+ld.Unit)
            else
                root.CFrame=root.CFrame+step
            end
        end)
    end
end))
table.insert(connections, RS.Stepped:Connect(function()
    if BuloCollisionWanted() then
        pcall(function()
            for part in pairs(BuloGetCollisionParts()) do
                if part.Parent then BuloDisableCollision(part) end
            end
        end)
    else
        if next(BuloNoclipCollisionStates) then BuloRestoreCollision() end
        BuloClearCollisionParts()
    end
end))
table.insert(connections, UIS.JumpRequest:Connect(function()
    if not Cfg.InfJumpEnabled then return end
    pcall(function()
        local char=Player.Character; if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart")
        local hum=char:FindFirstChildOfClass("Humanoid")
        if root and hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            root.Velocity=Vector3.new(root.Velocity.X,Cfg.InfJumpForce,root.Velocity.Z)
        end
    end)
end))
BuloTrackConnection(Player.CharacterAdded:Connect(function(newChar)
    if BuloHubUnloaded then return end
    task.wait(0.3)
    if isFlying then stopFly() end
    if flyActive and BuloExtra then BuloExtra.Fly.Rebind() end
    fetchFlyCharParts(newChar)
    applyWorldFOV()
end))
pcall(function()
    local VirtualUser=game:GetService("VirtualUser")
    BuloTrackConnection(Players.LocalPlayer.Idled:Connect(function()
        if BuloHubUnloaded then return end
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end))
end)
BuloTrackConnection(Players.PlayerAdded:Connect(function(p)
    if not BuloHubUnloaded and ESPConfig.Enabled then pcall(CreateESPForPlayer, p) end
end))
BuloTrackConnection(Players.PlayerRemoving:Connect(function(p)
    pcall(function()
        if ESPObjects[p] then
            for _, d in pairs(ESPObjects[p]) do pcall(function() d:Remove() end) end
            ESPObjects[p]=nil
        end
    end)
end))
if Player.Character then fetchFlyCharParts(Player.Character) end
local SettingsTab = Window:CreateTab({ Name = "Settings", Icon = "settings" })
SettingsTab:CreateConfigManager({ Name = "Configs", Side = "Left" })
SettingsTab:CreateThemeManager({ Name = "Theme", Side = "Right" })
local KeysInfo = SettingsTab:CreateGroupbox({ Name = "Hotkeys", Side = "Right" })
KeysInfo:CreateParagraph({
	Title = "Menu key",
	Content = "K collapses the menu into the mini bar and brings it back.\nRightControl hides the window completely.\nThe script keeps running either way.\nChange it in the KEYS table at the top of the script.",
})
if Window.LoadAutoload then
	task.defer(function()
		while not UIReady do
			task.wait(0.1)
		end
		pcall(function()
			Window:LoadAutoload()
		end)
	end)
end
