pcall(function()
	if getgenv and getgenv().__NULL_HUB_WINDOW then
		local old = getgenv().__NULL_HUB_WINDOW
		if old.Destroy then
			pcall(function()
				old:Destroy()
			end)
		end
	end
end)
local UI_SOURCES = {
	"https://raw.githubusercontent.com/zer000111222000-netizen/Gui/refs/heads/main/GuiIxahub.lua",
	"https://raw.githubusercontent.com/zer000111222000-netizen/Gui/refs/heads/main/GuiIxahub_backup.lua",
	"https://cdn.jsdelivr.net/gh/zer000111222000-netizen/Gui@main/GuiIxahub.lua",
	"https://cdn.jsdelivr.net/gh/zer000111222000-netizen/Gui@main/GuiIxahub_backup.lua",
}
local Airflow = getgenv().__IxaHubLibraryV2
local function patchGameNameLookup(source)
	if type(source) ~= "string" then return source end
	local startTag = "local aX=nil local function aY()"
	local endTag = "local a_={US="
	local startAt = string.find(source, startTag, 1, true)
	local endAt = startAt and string.find(source, endTag, startAt + #startTag, true)
	if not startAt or not endAt then return source end
	local replacement = [[local aX=nil local function aY()
if aX==nil then
 local ok,info=pcall(function()
  local response=game:HttpGet("https://games.roblox.com/v1/games?universeIds="..tostring(game.GameId))
  local decoded=e:JSONDecode(response)
  local item=type(decoded)=="table" and type(decoded.data)=="table" and decoded.data[1]
  if type(item)=="table" and type(item.name)=="string" and item.name~="" then
   local creator=type(item.creator)=="table" and item.creator or nil
   return {Name=item.name,Creator={Name=creator and creator.name or nil}}
  end
  return h:GetProductInfo(game.PlaceId)
 end)
 if not ok then ok,info=pcall(function() return h:GetProductInfo(game.PlaceId) end) end
 aX=ok and type(info)=="table" and info or false
end
return aX or nil
end
local function aZ()
local info=aY()
if info and info.Name then return info.Name end
return d:IsStudio() and "Studio" or ("Place "..tostring(game.PlaceId))
end
]]
	return string.sub(source, 1, startAt - 1) .. replacement .. string.sub(source, endAt)
end
if type(Airflow) ~= "table" then
	for _, url in ipairs(UI_SOURCES) do
		local ok, lib = pcall(function()
			local source = game:HttpGet(url)
			source = patchGameNameLookup(source)
			return loadstring(source)()
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
getgenv().__IxaHubLibraryV2 = Airflow
local KEYS = {
	ui = "F9",
}
local Window
local THEME = Airflow.ThemePresets.Sakura
if THEME then
	pcall(function()
		Airflow:SetDefaultTheme(THEME)
	end)
end
local previousWindow = getgenv().__NULL_HUB_WINDOW
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
	LoadingSubtitle = "Nullscape",
	ToggleUIKeybind = KEYS.ui,
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
getgenv().__NULL_HUB_WINDOW = Window
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


local FarmPage = Window:CreateTab({Name = "Farm", Icon = "gift"})
local AltarsPage = Window:CreateTab({Name = "Altars", Icon = "landmark"})
local SurvivalPage = Window:CreateTab({Name = "Survival", Icon = "shield"})
local EnemiesPage = Window:CreateTab({Name = "Enemies", Icon = "skull"})
local VisualsPage = Window:CreateTab({Name = "Visuals", Icon = "eye"})
local AutoGamePage
pcall(function()
    AutoGamePage = Window:CreateTab({Name = "Auto Game", Icon = "bot"})
end)
if not AutoGamePage then
    AutoGamePage = Window:CreateTab({Name = "Auto Game"})
end
local SettingsPage = Window:CreateTab({Name = "Settings", Icon = "settings"})

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
    return
end

local environment = _G
if type(getgenv) == "function" then
    local ok, result = pcall(getgenv)
    if ok and type(result) == "table" then
        environment = result
    end
end

local previousSession = environment.__NULL_HUB_SESSION
if type(previousSession) == "table" and type(previousSession.Unload) == "function" then
    pcall(previousSession.Unload, previousSession)
end

local session = {
    Active = true,
    Settings = {
        RageFarm = false,
        FastFlyFarm = false,
        AutoMedal = false,
        AutoStarMart = false,
        RazorbloomBypass = true,
        AutoPortal = true,
        GiftReach = false,
        ReachDistance = 45,
        GoldenFirst = true,
        AutoPurgatory = true,
        AutoAltars = true,
        AvoidEnemies = false,
        AntiVoid = false,
        AntiVoidMode = 1,
        AntiVoidPower = 500,
        AntiMobDamage = true,
        GodMode = false,
        GuardianProtection = false,
        ShadowGuardianProtection = false,
        NukeEnemies = false,
        RemoveClientEnemies = false,
        FreezeEnemies = false,
        DisableSeaMines = false,
        DisableVoidImplosions = false,
        DisableFakeBeacons = false,
        DisableOblivion = false,
        BulletSpheres = false,
        RemoveAllEnemies = false,
        StrongEnemyRemoval = true,
        GiftESP = false,
        TripmineESP = false,
        EnemyESP = false,
        Fullbright = false,
        FullAutoGame = false,
        AutoRestart = false,
        AutoShop = false,
        ShopPolicy = 1,
        ShopMaxPrice = 0,
        ShopReserve = 0,
        AutoReroll = false,
        ShopMaxRerolls = 2
    },
    Connections = {},
    GiftHandler = nil,
    CurseHandler = nil,
    InventoryHandler = nil,
    ShopIndex = nil,
    FullAutoSaved = nil,
    Markers = {},
    Attempts = setmetatable({}, {__mode = "k"}),
    Rage = {
        Phase = "Idle",
        Target = nil,
        Destination = nil,
        ReadyAt = 0,
        ReleaseAt = 0,
        QueueDeadline = 0,
        NextQueueWait = 0,
        NextQueueWarning = 0,
        NextMove = 0,
        NextAltar = 0,
        Failures = 0,
        NextWarning = 0,
        RejectCount = 0,
        LastReject = 0,
        NextRejectWarning = 0,
        NextRecovery = 0,
        ExtraSettle = 0,
        NextSpeedDecay = 0,
        StuckSince = setmetatable({}, {__mode = "k"}),
        GiftSkip = setmetatable({}, {__mode = "k"})
    },
    EnemyRemoval = {
        Selected = {},
        Hidden = {},
        Names = {}
    },
    Portal = {
        Level = nil,
        OpenSince = nil,
        EmptySince = nil,
        Gated = nil,
        NextAttempt = 0,
        Attempts = 0,
        NextWarning = 0,
        NextChase = 0,
        NextTouch = 0
    },
    Protection = {
        OwnedIFrame = nil,
        Cache = nil,
        CacheRemoved = false,
        Loading = false,
        Token = 0,
        TouchParts = setmetatable({}, {__mode = "k"})
    },
    Altars = {
        Goal = nil,
        Close = false,
        Holding = nil,
        Goals = setmetatable({}, {__mode = "k"}),
        Shown = setmetatable({}, {__mode = "k"}),
        PromptAttempts = setmetatable({}, {__mode = "k"}),
        Skip = setmetatable({}, {__mode = "k"}),
        VoteActive = false,
        VoteSent = false,
        VoteRemote = nil,
        VoteConnection = nil,
        NextScan = 0
    },
    Shop = {
        Busy = false,
        Skipped = false,
        SkipReason = "",
        Holding = nil,
        LastPick = "",
        Picks = 0,
        VoteRemote = nil
    }
}

environment.__NULL_HUB_SESSION = session

local function connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(session.Connections, connection)
    return connection
end

local function findPath(root, names)
    local current = root
    for _, name in ipairs(names) do
        current = current and current:FindFirstChild(name)
        if not current then
            return nil
        end
    end
    return current
end

local function isImpCurseActive()
    local known = false
    if session.CurseHandler and type(session.CurseHandler.IsCurseEnabled) == "function" then
        for _, name in ipairs({"BeaconImp", "BeaconMart"}) do
            local ok, enabled = pcall(session.CurseHandler.IsCurseEnabled, name)
            if ok and type(enabled) == "boolean" then
                known = true
                if enabled then return true, true end
            end
        end
    end
    local curses = findPath(ReplicatedStorage, {"CurseFolder", "Curses"})
    if curses and (curses:FindFirstChild("BeaconImp") or curses:FindFirstChild("BeaconMart")) then
        return true, true
    end
    return false, known
end

local function characterState()
    local inRound = ReplicatedStorage:FindFirstChild("InRound")
    local dead = LocalPlayer:FindFirstChild("Dead")
    local beacon = LocalPlayer:FindFirstChild("Beacon")
    if not inRound or not inRound.Value or not dead or dead.Value or not beacon or beacon.Value then
        return nil
    end
    local character = LocalPlayer.Character
    if not character or not character.Parent then
        return nil
    end
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not root or not root:IsA("BasePart") or not humanoid or humanoid.Health <= 0 then
        return nil
    end
    return character, root, humanoid
end

local function validPosition(position)
    return typeof(position) == "Vector3"
        and position.X == position.X
        and position.Y == position.Y
        and position.Z == position.Z
        and math.abs(position.X) < 10000000
        and math.abs(position.Y) < 10000000
        and math.abs(position.Z) < 10000000
end

local function isMine(gift)
    return type(gift) == "table" and (gift.Tripmine == true or gift.Type == "Tripmine")
end

local function isGift(gift)
    return type(gift) == "table"
        and not gift.Destroyed
        and not gift.Collected
        and not isMine(gift)
        and (gift.Type == "Gift" or gift.Type == "GoldenGift" or gift.Type == "PassageGift" or gift.Golden == true)
        and validPosition(gift.Position)
end

local function giftRange(handler)
    local range = handler and handler.CurrentGiftCollectionRange
    if type(range) ~= "number" and handler and type(handler.GetCollectionRange) == "function" then
        local ok, result = pcall(handler.GetCollectionRange)
        if ok then
            range = result
        end
    end
    if type(range) ~= "number" or range ~= range or range <= 0 then
        return 3
    end
    return math.clamp(range, 0, 32)
end

local enemyCauses = {
    Baby = true,
    Bell = true,
    Cadence = true,
    Catalyst = true,
    Celestial = true,
    Flesh = true,
    Guardian = true,
    ICBM = true,
    Kolona = true,
    Mart = true,
    Oblivion = true,
    Operator = true,
    Ouroboros = true,
    Ponderer = true,
    Quartz = true,
    RedMart = true,
    Razorbloom = true,
    Scrapmaw = true,
    ShadowBaby = true,
    ShadowBabyConcept = true,
    ShadowGuardian = true,
    Sigil = true,
    Skinwalker = true,
    Slicer = true,
    Springer = true,
    Telefragger = true,
    VoidboundICBM = true,
    Voidbreaker = true,
    nilEnemy = true, nilMirage = true, RealityBreak = true
}

function session.ShouldBlock(remote, method, reason)
    if (method ~= "FireServer" and method ~= "InvokeServer") or type(reason) ~= "string" or typeof(remote) ~= "Instance" then
        return nil
    end
    local name = remote.Name
    if (name == "Died" and method == "FireServer") or (name == "DiedFunc" and method == "InvokeServer") then
        if reason == "Void" or reason == "VoidImplosion" or reason == "The press of a button" then
            return nil
        end
        local events = ReplicatedStorage:FindFirstChild("Events")
        if events and remote == events:FindFirstChild(name) then
            local enemy = enemyCauses[reason]
            if not enemy then
                local index = findPath(ReplicatedStorage, {"SharedModules", "Core", "Index", "EnemyIndex"})
                enemy = index and index:FindFirstChild(reason) ~= nil
            end
            if enemy then
                return method == "FireServer" and "event" or "function"
            end
        end
    end
    if method == "FireServer" and name == "ApplyStatus" and reason == "Insanity" then
        local events = ReplicatedStorage:FindFirstChild("Events")
        local enemies = workspace:FindFirstChild("Enemies")
        if events and remote == events:FindFirstChild("ApplyStatus") and enemies and enemies:FindFirstChild("Voidbreaker") then
            return "event"
        end
    end
    local enemyReport = method == "FireServer" and ((name == "ClientEvent" and (reason == "Kill" or reason == "Combust" or reason == "Debuff")) or (name == "ShockwaveEvent" and reason == "Debuff"))
    if enemyReport then
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies and remote:IsA("RemoteEvent") and remote:IsDescendantOf(enemies) then
            return "event"
        end
    end
    return nil
end

local function attachProtection()
    local record = environment.__NULL_HUB_HOOK
    if type(record) == "table" and record.Game == game and record.Version == 3 and type(record.Original) == "function" then
        record.Owner = session
        session.HookRecord = record
        return true
    end
    if type(getnamecallmethod) ~= "function" then
        return false
    end
    local previousRecord = record
    record = {Game = game, Version = 3}
    local function interception(remote, ...)
        local owner = record.Owner
        if owner and owner.Active and (owner.Settings.AntiMobDamage or owner.Settings.GodMode or owner.Settings.GuardianProtection or owner.Settings.ShadowGuardianProtection) then
            local method = getnamecallmethod()
            if owner.Settings.GodMode and method == "TakeDamage" and remote == owner.GodHumanoid then
                return nil
            end
            if method == "FireServer" and remote == owner.GodDiedEvent and remote ~= nil then
                local cause = select(1, ...)
                if owner.Settings.GodMode or (cause == "Guardian" and owner.Settings.GuardianProtection)
                    or (cause == "ShadowGuardian" and owner.Settings.ShadowGuardianProtection) then return nil end
            end
            if owner.Settings.AntiMobDamage and (method == "FireServer" or method == "InvokeServer") then
                local ok, action = pcall(owner.ShouldBlock, remote, method, ...)
                if ok and action == "event" then
                    return nil
                end
                if ok and action == "function" then
                    return false
                end
            end
        end
        return record.Original(remote, ...)
    end
    local closure = interception
    if type(newcclosure) == "function" then
        local ok, wrapped = pcall(newcclosure, interception)
        if ok and type(wrapped) == "function" then
            closure = wrapped
        end
    end
    local original
    if type(hookmetamethod) == "function" then
        local ok, result = pcall(hookmetamethod, game, "__namecall", closure)
        if ok and type(result) == "function" then original = result end
    end
    if not original and type(getrawmetatable) == "function" and type(setreadonly) == "function" then
        local ok, result = pcall(function()
            local mt = getrawmetatable(game)
            local old = mt.__namecall
            if type(old) ~= "function" or old == closure then error("Missing namecall") end
            local readonly = true
            if type(isreadonly) == "function" then
                local read, saved = pcall(isreadonly, mt)
                if read and type(saved) == "boolean" then readonly = saved end
            end
            setreadonly(mt, false)
            local installed, message = pcall(function() mt.__namecall = closure end)
            pcall(setreadonly, mt, readonly)
            if not installed then error(message) end
            return old
        end)
        if ok and type(result) == "function" then original = result end
    end
    if not original then return false end
    record.Original = original
    if type(previousRecord) == "table" and previousRecord.Game == game then previousRecord.Owner = nil end
    record.Owner = session
    environment.__NULL_HUB_HOOK = record
    session.HookRecord = record
    return true
end

local function isBeaconEnemy(enemy, impActive, impKnown)
    if not enemy then
        return false
    end
    if enemy.Name == "StarMart" then return true end
    local arrow = enemy:GetAttribute("ArrowType")
    local beaconFlag = enemy:GetAttribute("Beacon")
    if arrow == "FakeBeaconImp" or beaconFlag == false then return false end
    return arrow == "BeaconImp" or beaconFlag == true
end

local function restoreMobTouches()
    local protection = session.Protection
    for part, record in pairs(protection.TouchParts) do
        pcall(function()
            if part.CanTouch == false then
                part.CanTouch = record.Saved
            end
        end)
        protection.TouchParts[part] = nil
    end
    protection.NextTouchScan = 0
end

local function updateMobTouches()
    local protection = session.Protection
    local now = time()
    if now < (protection.NextTouchScan or 0) then
        return
    end
    protection.NextTouchScan = now + 0.25
    local enemies = workspace:FindFirstChild("Enemies")
    local impActive, impKnown = isImpCurseActive()
    if not session.Active or not session.Settings.AntiMobDamage or not characterState() then
        return
    end
    for part, record in pairs(protection.TouchParts) do
        if not enemies or record.Enemy.Parent ~= enemies or isBeaconEnemy(record.Enemy, impActive, impKnown) then
            pcall(function()
                if part.CanTouch == false then
                    part.CanTouch = record.Saved
                end
            end)
            protection.TouchParts[part] = nil
        end
    end
    if not enemies then
        return
    end
    local function suppress(part, enemy)
        if not part:IsA("BasePart") then
            return
        end
        local record = protection.TouchParts[part]
        local ok, canTouch = pcall(function()
            return part.CanTouch
        end)
        if ok and canTouch == true then
            local changed = pcall(function()
                part.CanTouch = false
            end)
            if changed and not record then
                protection.TouchParts[part] = {Enemy = enemy, Saved = true}
            end
        end
    end
    for _, enemy in ipairs(enemies:GetChildren()) do
        if not isBeaconEnemy(enemy, impActive, impKnown) then
            suppress(enemy, enemy)
            for _, part in ipairs(enemy:GetDescendants()) do
                if part:IsA("BasePart") then
                    local name = string.lower(part.Name)
                    if string.find(name, "hitbox", 1, true) or string.find(name, "hurtbox", 1, true) or string.find(name, "killbox", 1, true) then
                        suppress(part, enemy)
                    end
                end
            end
        end
    end
end

local function restoreHiddenEnemy(enemy, record)
    if record.Connection then
        record.Connection:Disconnect()
        record.Connection = nil
    end
    pcall(function()
        if enemy.Parent == nil and record.Parent and record.Parent.Parent then
            enemy.Parent = record.Parent
        end
    end)
end

local function restoreAllEnemies()
    local state = session.EnemyRemoval
    for enemy, record in pairs(state.Hidden) do
        restoreHiddenEnemy(enemy, record)
        state.Hidden[enemy] = nil
    end
end

local function disconnectEnemyFolder()
    local state = session.EnemyRemoval
    state.FolderToken = (state.FolderToken or 0) + 1
    state.PendingToken = nil
    if state.AddedConnection then
        pcall(function()
            state.AddedConnection:Disconnect()
        end)
        state.AddedConnection = nil
    end
    state.Folder = nil
end

local function ensureEnemyFolder(enemies)
    local state = session.EnemyRemoval
    if state.Folder == enemies then
        return
    end
    disconnectEnemyFolder()
    state.Folder = enemies
    if not enemies or not session.Active then
        return
    end
    local token = state.FolderToken
    state.AddedConnection = enemies.ChildAdded:Connect(function()
        if not session.Active or state.Folder ~= enemies or state.PendingToken == token then
            return
        end
        state.PendingToken = token
        task.delay(0.1, function()
            if state.PendingToken == token then
                state.PendingToken = nil
            end
            if session.Active and state.Folder == enemies and state.FolderToken == token then
                pcall(session.UpdateEnemyRemoval)
            end
        end)
    end)
end

local function enemySelected(enemy)
    return session.Settings.RemoveAllEnemies or session.EnemyRemoval.Selected[enemy.Name] == true
end

local function keepRestorable(enemy)
    return session.Settings.AutoPortal and string.lower(enemy.Name) == "mart"
end

local function hideEnemy(enemy, enemies)
    local state = session.EnemyRemoval
    local record = {Parent = enemies}
    local ok, destroying = pcall(function()
        return enemy.Destroying
    end)
    if ok and destroying then
        record.Connection = destroying:Connect(function()
            if state.Hidden[enemy] == record then
                state.Hidden[enemy] = nil
            end
            if record.Connection then
                record.Connection:Disconnect()
                record.Connection = nil
            end
        end)
    end
    state.Hidden[enemy] = record
    local hidden = pcall(function()
        enemy.Parent = nil
    end)
    if not hidden or enemy.Parent ~= nil then
        state.Hidden[enemy] = nil
        if record.Connection then
            record.Connection:Disconnect()
        end
    end
end

function session.UpdateEnemyRemoval()
    if not session.Active then
        return
    end
    local state = session.EnemyRemoval
    local enemies = workspace:FindFirstChild("Enemies")
    ensureEnemyFolder(enemies)
    local inRound = ReplicatedStorage:FindFirstChild("InRound")
    local impActive, impKnown = isImpCurseActive()
    for enemy, record in pairs(state.Hidden) do
        local selected = enemySelected(enemy)
        if not session.Active or not inRound or not inRound.Value or not enemies or record.Parent ~= enemies
            or not selected or isBeaconEnemy(enemy, impActive, impKnown) or enemy.Parent ~= nil then
            restoreHiddenEnemy(enemy, record)
            state.Hidden[enemy] = nil
        elseif session.Settings.StrongEnemyRemoval and not keepRestorable(enemy) then
            local removed = pcall(function()
                enemy:Destroy()
            end)
            if removed then
                if record.Connection then
                    record.Connection:Disconnect()
                    record.Connection = nil
                end
                state.Hidden[enemy] = nil
            end
        end
    end
    if not session.Active or not inRound or not inRound.Value or not enemies then
        return
    end
    for _, enemy in ipairs(enemies:GetChildren()) do
        if enemy:IsA("BasePart") or enemy:IsA("Model") or enemy:IsA("Folder") then
            if session.AddEnemyOption then
                session.AddEnemyOption(enemy.Name)
            end
            if enemySelected(enemy) and not isBeaconEnemy(enemy, impActive, impKnown) and not state.Hidden[enemy] then
                local removed = false
                if session.Settings.StrongEnemyRemoval and not keepRestorable(enemy) then
                    removed = pcall(function()
                        enemy:Destroy()
                    end)
                    removed = removed and enemy.Parent ~= enemies
                end
                if not removed and enemy.Parent == enemies then
                    hideEnemy(enemy, enemies)
                end
            end
        end
    end
end

local function restoreLocalProtection()
    restoreMobTouches()
    local protection = session.Protection
    protection.Token = protection.Token + 1
    protection.Loading = false
    local owned = protection.OwnedIFrame
    protection.OwnedIFrame = nil
    if owned then
        pcall(function()
            owned:Destroy()
        end)
    end
    local cache = protection.Cache
    protection.Cache = nil
    if protection.CacheRemoved and cache and type(cache.Hitboxes) == "table" then
        pcall(function()
            local character = LocalPlayer.Character
            local hitbox = character and character:FindFirstChild("Hitbox")
            if hitbox and cache.Hitboxes[LocalPlayer] == nil then
                cache.Hitboxes[LocalPlayer] = hitbox
            end
        end)
    end
    protection.CacheRemoved = false
end

local function updateLocalProtection()
    local protection = session.Protection
    if not session.Active or not session.Settings.AntiMobDamage or not characterState() then
        if protection.OwnedIFrame or protection.Cache or protection.Loading or next(protection.TouchParts) then
            restoreLocalProtection()
        end
        return
    end
    updateMobTouches()
    if not session.Active or not session.Settings.AntiMobDamage or not characterState() then
        return
    end
    if protection.OwnedIFrame and protection.OwnedIFrame.Parent ~= LocalPlayer then
        protection.OwnedIFrame = nil
    end
    if not LocalPlayer:FindFirstChild("IFRAMES") then
        pcall(function()
            local marker = Instance.new("BoolValue")
            marker.Name = "IFRAMES"
            marker.Value = true
            marker.Parent = LocalPlayer
            protection.OwnedIFrame = marker
        end)
    end
    local cache = protection.Cache
    if cache and type(cache.Hitboxes) == "table" then
        local ok, removed = pcall(function()
            if cache.Hitboxes[LocalPlayer] ~= nil then
                cache.Hitboxes[LocalPlayer] = nil
                return cache.Hitboxes[LocalPlayer] == nil
            end
            return false
        end)
        if ok and removed then
            protection.CacheRemoved = true
        end
        return
    end
    if protection.Loading then
        return
    end
    local module = findPath(ReplicatedFirst, {"ClientModules", "ProjectileClient", "ProjectileClientHandler", "PlayerHitboxCache"})
    if not module then
        return
    end
    protection.Loading = true
    protection.Token = protection.Token + 1
    local token = protection.Token
    task.spawn(function()
        local ok, result = pcall(require, module)
        if protection.Token ~= token then
            return
        end
        protection.Loading = false
        if session.Active and session.Settings.AntiMobDamage and characterState() and ok and type(result) == "table" and type(result.Hitboxes) == "table" then
            protection.Cache = result
            updateLocalProtection()
        end
    end)
end

local function beaconTouchPart()
    local beacon = workspace:FindFirstChild("Beacon")
    if not beacon then return nil end
    if beacon:IsA("BasePart") then return beacon end
    for _, obj in ipairs(beacon:GetDescendants()) do
        if (obj:IsA("TouchTransmitter") or obj.Name == "TouchInterest") and obj.Parent and obj.Parent:IsA("BasePart") then
            return obj.Parent
        end
    end
    if beacon:IsA("Model") and beacon.PrimaryPart then return beacon.PrimaryPart end
    return beacon:FindFirstChildWhichIsA("BasePart", true)
end

local function releasePortalGate()
    local portal = session.Portal
    local gated = portal.Gated
    portal.Gated = nil
    if not gated then return end
    for part, saved in pairs(gated) do
        pcall(function()
            if part.Parent and part.CanTouch == false then part.CanTouch = saved end
        end)
    end
end

local function resetPortal()
    releasePortalGate()
    local portal = session.Portal
    portal.Level = nil
    portal.OpenSince = nil
    portal.EmptySince = nil
    portal.NoVisibleSince = nil
    portal.MartWaitSince = nil
    portal.Status = "Waiting for gift data"
    portal.HadGifts = false
    portal.Ready = false
    portal.NextAttempt = 0
    portal.Attempts = 0
    portal.NextWarning = 0
    portal.NextChase = 0
    portal.NextTouch = 0
    portal.LastTouchTarget = nil
    portal.TouchResult = nil
    portal.ImpWaitStarted = nil
end

local function updatePortalGate(allowEntry)
    local portal = session.Portal
    local farming = session.Settings.RageFarm or session.Settings.FastFlyFarm
    if not session.Active or not farming or allowEntry then
        releasePortalGate()
        return
    end
    local roots = {}
    local beacon = workspace:FindFirstChild("Beacon")
    if beacon then table.insert(roots, beacon) end
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        for _, enemy in ipairs(enemies:GetChildren()) do
            local arrow, beaconFlag = enemy:GetAttribute("ArrowType"), enemy:GetAttribute("Beacon")
            if beaconFlag ~= false and (arrow == "BeaconImp"
                or (enemy.Name == "Mart" and beaconFlag == true and arrow ~= "FakeBeaconImp")) then
                table.insert(roots, enemy)
            end
        end
    end
    local gated = portal.Gated or {}
    for part, saved in pairs(gated) do
        local belongs = false
        for _, root in ipairs(roots) do
            if part == root or part:IsDescendantOf(root) then belongs = true; break end
        end
        if not part.Parent or not belongs then
            pcall(function() if part.Parent and part.CanTouch == false then part.CanTouch = saved end end)
            gated[part] = nil
        end
    end
    local function block(part)
        if part:IsA("BasePart") then
            pcall(function()
                if part.CanTouch then
                    if gated[part] == nil then gated[part] = true end
                    part.CanTouch = false
                end
            end)
        end
    end
    for _, root in ipairs(roots) do
        block(root)
        for _, obj in ipairs(root:GetDescendants()) do block(obj) end
    end
    portal.Gated = next(gated) and gated or nil
end

local function resetRage()
    resetPortal()
    local state = session.Rage
    state.Phase = "Idle"
    state.Target = nil
    state.Destination = nil
    state.ReadyAt = 0
    state.ReleaseAt = 0
    state.QueueDeadline = 0
    state.NextQueueWait = 0
    state.NextMove = 0
end

local function networkDelay()
    local ok, ping = pcall(function()
        return LocalPlayer:GetNetworkPing()
    end)
    if not ok or type(ping) ~= "number" or ping ~= ping or ping < 0 then
        ping = 0.1
    end
    return math.clamp(ping, 0, 0.6)
end

local function giftSize(gift)
    if type(gift.Size) == "number" and gift.Size == gift.Size then
        return math.clamp(gift.Size, 0, 8)
    end
    return 1
end

local function nativeGiftLimit(handler, gift)
    return math.clamp(giftRange(handler) * giftSize(gift), 0, 32)
end

local function giftIsGolden(gift)
    return gift.Golden == true or gift.Type == "GoldenGift" or gift.Type == "PassageGift"
end

local function validGiftId(gift)
    local id = gift.Id
    return type(id) == "number" and id == id and id >= 0 and id <= 65535 and id % 1 == 0
end

local function canSendGift(handler, gift)
    local replication = handler and handler.ReplicationClient
    if replication and type(replication.SendCollect) == "function" and validGiftId(gift) then
        return true
    end
    return gift.OctreeNode ~= nil and type(gift.Collect) == "function"
end

local function giftAttemptReady(gift, now)
    local attempt = session.Attempts[gift]
    return not attempt or now >= (attempt.Next or 0)
end

local function sendGift(handler, gift, now, distance, nativeLimit)
    if not isGift(gift) or not giftAttemptReady(gift, now) then
        return false
    end
    local attempt = session.Attempts[gift] or {}
    session.Attempts[gift] = attempt
    attempt.Last = now
    attempt.Next = now + math.clamp(0.75 + networkDelay() * 1.2, 0.75, 1.6)
    attempt.Speculative = distance > nativeLimit * 0.9
    local replication = handler.ReplicationClient
    if replication and type(replication.SendCollect) == "function" and validGiftId(gift) then
        local ok = pcall(replication.SendCollect, gift.Id)
        if ok then
            attempt.Mode = "Remote"
            return true
        end
    end
    if gift.OctreeNode and type(gift.Collect) == "function" then
        local ok = pcall(gift.Collect, gift, false, true, 1)
        if ok then
            attempt.Mode = "Client"
            return true
        end
    end
    attempt.Next = now + 0.8
    attempt.Mode = "Error"
    return false
end

local function collectionQueuePending(handler)
    local replication = handler and handler.ReplicationClient
    local queue = replication and replication.CollectQueue
    return type(queue) == "table" and type(queue.Offset) == "number" and queue.Offset > 0
end

local function updateCollectionConnection()
    local state = session.Rage
    local remote = findPath(ReplicatedStorage, {"GiftShared", "Remotes", "Collection"})
    if remote == state.CollectionRemote and state.CollectionConnection then
        return
    end
    if state.CollectionConnection then
        state.CollectionConnection:Disconnect()
        state.CollectionConnection = nil
    end
    state.CollectionRemote = nil
    if not remote or not remote:IsA("RemoteEvent") then
        return
    end
    state.CollectionRemote = remote
    state.CollectionConnection = connect(remote.OnClientEvent, function(payload)
        local handler = session.GiftHandler
        if not session.Active or not handler or type(handler.Gifts) ~= "table" or typeof(payload) ~= "buffer" then
            return
        end
        local ok, length = pcall(buffer.len, payload)
        if not ok or type(length) ~= "number" then
            return
        end
        local seen = {}
        local now = time()
        local rejected = 0
        local fastRejected = 0
        for offset = 0, math.min(length - 2, 131070), 2 do
            local read, id = pcall(buffer.readu16, payload, offset)
            if read and not seen[id] then
                seen[id] = true
                local gift = handler.Gifts[id]
                if type(gift) == "table" and not isMine(gift) then
                    rejected = rejected + 1
                    local attempt = session.Attempts[gift] or {}
                    if attempt.Mode == "Remote" and not attempt.Speculative then
                        fastRejected = fastRejected + 1
                    end
                    session.Attempts[gift] = attempt
                    attempt.Failures = math.min((attempt.Failures or 0) + 1, 8)
                    attempt.RejectedAt = now
                    attempt.Next = now + math.min(0.5 * 1.5 ^ (attempt.Failures - 1), 5)
                end
            end
        end
        if session.Settings.RageFarm and fastRejected > 0 then
            state.ExtraSettle = math.min(state.ExtraSettle + math.min(fastRejected, 4) * 0.06, 0.7)
            state.NextSpeedDecay = now + 3
        end
        if rejected > 0 and (session.Settings.RageFarm or session.Settings.FastFlyFarm or session.Settings.GiftReach) then
            if now - state.LastReject > 6 then
                state.RejectCount = 0
            end
            state.LastReject = now
            state.RejectCount = state.RejectCount + rejected
            if state.RejectCount >= 6 and now >= state.NextRejectWarning and session.Notify then
                state.NextRejectWarning = now + 15
                state.RejectCount = 0
                session.Notify("Server is rejecting gift collection")
            end
        end
    end)
end


do
    local state = {Token = 0, Attempts = setmetatable({}, {__mode = "k"})}
    function session.ResetReach()
        state.Token += 1
        state.Attempts = setmetatable({}, {__mode = "k"})
    end
    local function allowedRadius()
        if session.Settings.FastFlyFarm then return 45 end
        if session.Settings.GiftReach then return math.clamp(session.Settings.ReachDistance, 4, 45) end
        return 0
    end
    function session.TryReachGift(handler, gift, character, distance, now)
        local radius = allowedRadius()
        if not session.Active or radius <= 0 or not isGift(gift) or distance > radius then return false end
        local record = state.Attempts[gift]
        if record and ((record.InFlight and now - record.Started < 5) or now - record.Started < 0.12) then return false end
        record = {Started = now, InFlight = true}
        state.Attempts[gift] = record
        if type(gift.Collect) ~= "function" then
            record.InFlight = false
            return sendGift(handler, gift, now, distance, nativeGiftLimit(handler, gift))
        end
        local attempt = session.Attempts[gift] or {}
        session.Attempts[gift] = attempt
        attempt.Last = now
        attempt.Next = now + 0.12
        attempt.Mode = "ReachClient"
        attempt.Speculative = distance > nativeGiftLimit(handler, gift) * 0.9
        local token = state.Token
        task.spawn(function()
            local successes = 0
            for _ = 1, 3 do
                if not session.Active or state.Token ~= token or session.GiftHandler ~= handler
                    or LocalPlayer.Character ~= character or gift.Destroyed or isMine(gift) then break end
                local _, root = characterState()
                local activeRadius = allowedRadius()
                if not root or activeRadius <= 0 or not validPosition(gift.Position)
                    or (gift.Position - root.Position).Magnitude > activeRadius then break end
                local ok = pcall(gift.Collect, gift, false, true, 1)
                if ok then successes += 1 end
            end
            record.InFlight = false
            if successes == 0 and state.Token == token and session.Active and isGift(gift) then
                attempt.Next = time()
                local _, root = characterState()
                if root and allowedRadius() > 0 and (gift.Position - root.Position).Magnitude <= allowedRadius() then
                    sendGift(handler, gift, time(), (gift.Position - root.Position).Magnitude, nativeGiftLimit(handler, gift))
                end
            end
        end)
        return true
    end
end

function session.TryCollectNearby()
    if not session.Active or not (session.Settings.RageFarm or session.Settings.GiftReach) then return 0 end
    local character, root = characterState()
    local handler = session.GiftHandler
    if not root or not handler or type(handler.Gifts) ~= "table" then return 0 end
    local now = time()
    local candidates = {}
    for _, gift in pairs(handler.Gifts) do
        local eligible = isGift(gift) and (session.Settings.GiftReach
            and (type(gift.Collect) == "function" or canSendGift(handler, gift))
            or (not session.Settings.GiftReach and canSendGift(handler, gift) and giftAttemptReady(gift, now)))
        if eligible then
            local distance = (gift.Position - root.Position).Magnitude
            local limit = session.Settings.GiftReach and session.Settings.ReachDistance or nativeGiftLimit(handler, gift) * 0.9
            if limit > 0 and distance <= limit then
                table.insert(candidates, {Gift=gift, Distance=distance, Golden=giftIsGolden(gift)})
            end
        end
    end
    table.sort(candidates, function(a, b)
        if session.Settings.GoldenFirst and a.Golden ~= b.Golden then return a.Golden end
        return a.Distance < b.Distance
    end)
    local sent = 0
    for index = 1, math.min(#candidates, 32) do
        if not session.Active or not (session.Settings.RageFarm or session.Settings.GiftReach) then break end
        local candidate = candidates[index]
        local ok
        if session.Settings.GiftReach then
            ok = session.TryReachGift(handler, candidate.Gift, character, candidate.Distance, now)
        else
            ok = sendGift(handler, candidate.Gift, now, candidate.Distance, nativeGiftLimit(handler, candidate.Gift))
        end
        if ok then sent += 1 end
    end
    return sent
end

function session.RecoverStalledGifts()
    local handler = session.GiftHandler
    local state = session.Rage
    if not session.Active or not (session.Settings.RageFarm or session.Settings.FastFlyFarm or session.Settings.GiftReach) or not handler or type(handler.Gifts) ~= "table" then
        return
    end
    local now = time()
    if now < state.NextRecovery then
        return
    end
    state.NextRecovery = now + 0.5
    local character, root = characterState()
    if not root then
        return
    end
    for _, gift in pairs(handler.Gifts) do
        local broken = type(gift) == "table" and gift.Collected == true and not gift.Destroyed and gift.OctreeNode ~= nil
            and not isMine(gift) and (gift.Type == "Gift" or gift.Type == "GoldenGift" or gift.Type == "PassageGift" or gift.Golden == true)
            and validPosition(gift.Position) and type(gift.Uncollect) == "function"
        if broken then
            local since = state.StuckSince[gift]
            if not since then
                state.StuckSince[gift] = now
            elseif now - since >= 1.2 and (state.Phase ~= "GiftSettle" and state.Phase ~= "AltarSettle" or now >= state.ReadyAt) then
                local oldNode = gift.OctreeNode
                pcall(gift.Uncollect, gift)
                if not session.Active or not (session.Settings.RageFarm or session.Settings.FastFlyFarm or session.Settings.GiftReach) or session.GiftHandler ~= handler or LocalPlayer.Character ~= character then
                    return
                end
                if not gift.Collected then
                    if oldNode and gift.OctreeNode ~= oldNode then
                        local ok, destroy = pcall(function()
                            return oldNode.Destroy
                        end)
                        if ok and type(destroy) == "function" then
                            pcall(destroy, oldNode)
                        end
                    end
                    state.GiftSkip[gift] = nil
                    session.Attempts[gift] = nil
                    local limit = nativeGiftLimit(handler, gift)
                    local settled = state.Phase ~= "GiftSettle" and state.Phase ~= "AltarSettle" or now >= state.ReadyAt
                    if session.Settings.RageFarm and root and settled and handler.Gifts[gift.Id] == gift and limit > 0 and (root.Position - gift.Position).Magnitude <= limit * 0.9 and canSendGift(handler, gift) then
                        sendGift(handler, gift, now, (root.Position - gift.Position).Magnitude, limit)
                    end
                end
                state.StuckSince[gift] = now + 2
            end
        else
            state.StuckSince[gift] = nil
        end
    end
end

local function instancePosition(instance)
    if not instance then
        return nil
    end
    if instance:IsA("BasePart") then
        return instance.Position
    end
    local part
    if instance:IsA("Model") then
        part = instance.PrimaryPart
    end
    if not part then
        part = instance:FindFirstChildWhichIsA("BasePart", true)
    end
    return part and part.Position or nil
end

local altarNames = {"Purgatory", "Chance", "Chaos", "Echo", "Passage", "Protection", "Purification", "Wishes", "Delusion", "Reroll", "Perfection", "Curses", "Duality", "Revival"}
local altarNamesByLower = {}
for _, name in ipairs(altarNames) do
    altarNamesByLower[string.lower(name)] = name
    if name ~= "Purgatory" then session.Settings["Altar_" .. name] = false end
end
altarNamesByLower.revive = "Revival"

local function altarName(value, tagged)
    if type(value) ~= "string" then
        return nil
    end
    local text = string.lower(value):gsub("<.->", ""):match("^%s*(.-)%s*$")
    local fromAction = text:match("^altar%s+of%s+([%w_]+)")
    if fromAction then
        text = fromAction
    elseif not tagged then
        return nil
    end
    local known = altarNamesByLower[text]
    if known then
        return known
    end
    if fromAction then
        return fromAction
    end
    if tagged and text ~= "altar" and text ~= "" and text:match("^[%w_]+$") then
        return value
    end
    return nil
end

local function altarNameFromInstance(instance)
    if not instance then
        return nil
    end
    local name = altarName(instance:GetAttribute("Name"), true)
    if name then
        return name
    end
    local realName = instance:FindFirstChild("RealName")
    if realName and realName:IsA("StringValue") then
        name = altarName(realName.Value, true)
        if name then
            return name
        end
    end
    local instanceName = type(instance.Name) == "string" and string.lower(instance.Name) or ""
    return altarNamesByLower[instanceName] or altarName(instance.Name, false)
end

local function altarNameFromPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then
        return nil
    end
    return altarName(prompt.ActionText, false)
end

local function altarEnabled(name)
    if not name then
        return false
    end
    local canonical = altarNamesByLower[string.lower(name)]
    if canonical == "Purgatory" then return session.Settings.AutoPurgatory end
    return canonical ~= nil and session.Settings.AutoAltars and session.Settings["Altar_" .. canonical] == true
end

local function altarNameFromTagged(altar)
    local name = altarNameFromInstance(altar)
    if name then
        return name
    end
    local candidates = {altar}
    for _, child in ipairs(altar:GetDescendants()) do
        table.insert(candidates, child)
    end
    if altar.Parent and altar.Parent:FindFirstChild("Altar") == altar then
        local hitbox = altar.Parent:FindFirstChild("HitBox") or altar.Parent:FindFirstChild("Hitbox")
        if hitbox then
            table.insert(candidates, hitbox)
            for _, child in ipairs(hitbox:GetDescendants()) do
                table.insert(candidates, child)
            end
        end
    end
    local found
    for _, candidate in ipairs(candidates) do
        if candidate:IsA("ProximityPrompt") then
            local candidateName = altarNameFromPrompt(candidate)
            if candidateName then
                if found and string.lower(found) ~= string.lower(candidateName) then
                    return nil
                end
                found = candidateName
            end
        end
    end
    return found
end

local function releasePromptHold()
    local prompt = session.Altars.Holding
    session.Altars.Holding = nil
    if prompt then
        pcall(function()
            prompt:InputHoldEnd()
        end)
    end
end

local function isPromptAvailable(prompt)
    if not (prompt and prompt:IsA("ProximityPrompt") and prompt.Parent and prompt.Enabled and prompt:GetAttribute("Active") ~= false) then
        return false
    end
    local cost = prompt:GetAttribute("Cost")
    local currencyType = prompt:GetAttribute("CurrencyType") or "GoldenGifts"
    local currencyName = type(currencyType) == "string" and string.lower(currencyType) or ""
    local objectText = type(prompt.ObjectText) == "string" and string.lower(prompt.ObjectText) or ""
    if currencyName == "r$" or string.find(currencyName, "robux", 1, true) or string.find(objectText, "robux", 1, true) or string.find(objectText, "r$", 1, true) then
        return false
    end
    if type(cost) == "number" and cost > 0 and currencyType == "GoldenGifts" then
        local currency = ReplicatedStorage:FindFirstChild("GoldenGifts")
        if currency and type(currency.Value) == "number" and currency.Value < cost then
            return false
        end
    end
    return true
end

local function findAltarPrompt(altar, expectedName)
    local scope = altar
    local function findPrompt(parent)
        local fallback
        local ambiguous = false
        local candidates = parent:GetDescendants()
        table.insert(candidates, 1, parent)
        for _, candidate in ipairs(candidates) do
            if isPromptAvailable(candidate) then
                local promptName = altarNameFromPrompt(candidate)
                if promptName and string.lower(promptName) == string.lower(expectedName) then
                    return candidate
                end
                local action = type(candidate.ActionText) == "string" and string.lower(candidate.ActionText) or ""
                if not promptName and (action == "" or action == "activate" or action == "use" or action == "activate altar") then
                    if fallback then
                        ambiguous = true
                    else
                        fallback = candidate
                    end
                end
            end
        end
        return not ambiguous and fallback or nil
    end
    local prompt = findPrompt(scope)
    if not prompt and altar.Parent and altar.Parent:FindFirstChild("Altar") == altar then
        local hitbox = altar.Parent:FindFirstChild("HitBox") or altar.Parent:FindFirstChild("Hitbox")
        if hitbox then
            prompt = findPrompt(hitbox)
            if prompt then
                scope = altar.Parent
            end
        end
    end
    return prompt, scope
end

local function promptPosition(prompt, altar, scope)
    local parent = prompt and prompt.Parent
    if parent and parent:IsA("Attachment") then
        return parent.WorldPosition
    end
    if parent and parent:IsA("BasePart") then
        return parent.Position
    end
    local hitbox = altar:FindFirstChild("Hitbox") or altar:FindFirstChild("HitBox")
    if not hitbox and scope ~= altar then
        hitbox = scope:FindFirstChild("Hitbox") or scope:FindFirstChild("HitBox")
    end
    return instancePosition(hitbox or altar)
end

local function altarIsUsed(altar, scope)
    local parent = altar and altar.Parent
    return not altar or altar:GetAttribute("Activated") or altar:GetAttribute("AltarUsed")
        or (scope and (scope:GetAttribute("Activated") or scope:GetAttribute("AltarUsed")))
        or (parent and parent:GetAttribute("AltarUsed"))
end

local function taggedAltarAncestor(prompt)
    local current = prompt.Parent
    while current and current ~= workspace do
        if CollectionService:HasTag(current, "Altar") then
            return current
        end
        if (current.Name == "HitBox" or current.Name == "Hitbox") and current.Parent and current.Parent ~= workspace then
            local sibling = current.Parent:FindFirstChild("Altar")
            if sibling and (CollectionService:HasTag(sibling, "Altar") or altarNameFromTagged(sibling)) then
                return sibling
            end
        end
        current = current.Parent
    end
    return nil
end

local function findAltarGoal(root)
    local state = session.Altars
    local best, bestScore
    local seen = {}
    local now = time()
    for identity, goal in pairs(state.Goals) do
        if not identity.Parent or not identity:IsDescendantOf(workspace) or not goal.Prompt.Parent then
            state.Goals[identity] = nil
        end
    end
    local function consider(identity, altar, scope, prompt, name)
        if seen[identity] or not altarEnabled(name) or not isPromptAvailable(prompt) or altarIsUsed(altar, scope) then
            return
        end
        seen[identity] = true
        local position = promptPosition(prompt, altar, scope)
        if not validPosition(position) then
            return
        end
        local goal = state.Goals[identity]
        if not goal or goal.Prompt ~= prompt or (goal.LastSeen and now - goal.LastSeen > 1) then
            goal = {IsAltar = true, Altar = altar, Scope = scope, Prompt = prompt, Name = name, Position = position, StartedAt = now}
            state.Goals[identity] = goal
        else
            goal.Altar = altar
            goal.Scope = scope
            goal.Name = name
            goal.Position = position
        end
        goal.LastSeen = now
        if state.Skip[identity] and state.Skip[identity] > now then
            return
        end
        local distance = (position - root.Position).Magnitude
        local score = distance + (string.lower(name) == "purgatory" and -100000 or 0)
        if goal == state.Goal then
            score = score - 2
        end
        if not best or score < bestScore then
            best, bestScore = goal, score
        end
    end
    for _, altar in ipairs(CollectionService:GetTagged("Altar")) do
        if altar:IsDescendantOf(workspace) and not altarIsUsed(altar) then
            local name = altarNameFromTagged(altar)
            if name and altarEnabled(name) then
                local prompt, scope = findAltarPrompt(altar, name)
                if prompt then
                    consider(altar, altar, scope, prompt, name)
                end
            end
        end
    end
    local function considerPrompt(prompt)
        if not prompt:IsA("ProximityPrompt") or not prompt:IsDescendantOf(workspace) then
            return
        end
        local name = altarNameFromPrompt(prompt)
        if not name or not altarEnabled(name) then
            return
        end
        local altar = taggedAltarAncestor(prompt)
        if altar then
            local taggedName = altarNameFromTagged(altar)
            if not taggedName or string.lower(taggedName) ~= string.lower(name) then
                return
            end
            local scope = prompt:IsDescendantOf(altar) and altar or altar.Parent
            consider(altar, altar, scope, prompt, name)
        else
            consider(prompt, prompt, prompt.Parent, prompt, name)
        end
    end
    for _, prompt in ipairs(CollectionService:GetTagged("Prompt")) do
        considerPrompt(prompt)
    end
    for prompt in pairs(state.Shown) do
        considerPrompt(prompt)
    end
    local rooms = workspace:FindFirstChild("CurrentRooms")
    if state.RoomRoot ~= rooms or now >= (state.NextRoomScan or 0) then
        state.RoomRoot = rooms
        state.NextRoomScan = now + 2
        state.RoomModels = {}
        if rooms then
            for _, obj in ipairs(rooms:GetDescendants()) do
                if (obj:IsA("Model") or obj:IsA("Folder") or obj:IsA("BasePart"))
                    and string.find(string.lower(obj.Name), "altar", 1, true) then
                    table.insert(state.RoomModels, obj)
                end
            end
        end
    end
    local function sourceName(altar, prompt)
        local found
        local function add(value)
            if found == false or type(value) ~= "string" then return end
            local text = string.lower(value):gsub("<.->", "")
            local exact = altarNamesByLower[text:match("^%s*(.-)%s*$")]
            if exact then
                if found and found ~= exact then found = false else found = exact end
                return
            end
            for lower, canonical in pairs(altarNamesByLower) do
                local word = lower:gsub("([^%w])", "%%%1")
                if text:find("%f[%w]" .. word .. "%f[%W]") then
                    if found and found ~= canonical then found = false; return end
                    found = canonical
                end
            end
        end
        local candidates = {altar}
        for _, child in ipairs(altar:GetChildren()) do table.insert(candidates, child) end
        for _, obj in ipairs(candidates) do
            add(obj.Name)
            for key, value in pairs(obj:GetAttributes()) do
                if value ~= false and altarNamesByLower[string.lower(tostring(key))] then add(tostring(key)) end
                if type(value) == "string" and altarNamesByLower[string.lower(value)] then add(value) end
            end
            if obj:IsA("StringValue") and obj.Name == "RealName" then add(obj.Value) end
            if found == false then return nil end
        end
        if prompt then add(prompt.ActionText); add(prompt.ObjectText) end
        return found or nil
    end
    for _, altar in ipairs(state.RoomModels or {}) do
        if altar.Parent and rooms and altar:IsDescendantOf(rooms) and not altarIsUsed(altar) then
            local prompt = altar:FindFirstChildWhichIsA("ProximityPrompt", true)
            local name = sourceName(altar, prompt)
            if name and altarEnabled(name) then
                local chosen, scope = findAltarPrompt(altar, name)
                if not chosen and prompt and isPromptAvailable(prompt) then
                    local count = 0
                    for _, obj in ipairs(altar:GetDescendants()) do
                        if isPromptAvailable(obj) then count += 1 end
                    end
                    if count == 1 then chosen, scope = prompt, altar end
                end
                if chosen then consider(altar, altar, scope or altar, chosen, name) end
            end
        end
    end
    return best
end

local function uniqueVotingAltar()
    local found
    for _, altar in ipairs(CollectionService:GetTagged("Voting")) do
        if altar:IsDescendantOf(workspace) then
            local name = altarNameFromTagged(altar)
            if not name or (found and string.lower(found) ~= string.lower(name)) then
                return nil
            end
            found = name
        end
    end
    return found
end

local function voteAltarName(title)
    if type(title) ~= "string" then
        return nil
    end
    local lower = string.lower(title)
    local isAltarVote = string.find(lower, "altar", 1, true) ~= nil
    local isActivation = string.find(lower, "activat", 1, true) ~= nil or string.find(" " .. lower .. " ", " use ", 1, true) ~= nil or string.find(lower, "trigger", 1, true) ~= nil
    local negative = string.find(lower, "cancel", 1, true) ~= nil or string.find(lower, "disable", 1, true) ~= nil or string.find(lower, "deactivat", 1, true) ~= nil or string.find(lower, "prevent", 1, true) ~= nil or string.find(lower, "skip", 1, true) ~= nil or string.find(lower, "avoid", 1, true) ~= nil or string.find(lower, "without", 1, true) ~= nil or string.find(lower, "don't", 1, true) ~= nil or lower:match("%f[%a]not%f[%A]") ~= nil or lower:match("%f[%a]never%f[%A]") ~= nil
    if not isAltarVote or not isActivation or negative or string.find(lower, "robux", 1, true) or string.find(lower, "r$", 1, true) then
        return nil
    end
    local candidates = table.clone(altarNames)
    table.insert(candidates, "Revive")
    local goal = session.Altars.Goal
    if goal and not altarNamesByLower[string.lower(goal.Name)] then
        table.insert(candidates, goal.Name)
    end
    local tagged = uniqueVotingAltar()
    if tagged and not altarNamesByLower[string.lower(tagged)] then
        table.insert(candidates, tagged)
    end
    local found
    for _, name in ipairs(candidates) do
        local word = string.lower(name):gsub("([^%w])", "%%%1")
        if string.find(lower, "%f[%w]" .. word .. "%f[%W]") then
            local canonical = altarNamesByLower[string.lower(name)] or name
            if found and string.lower(found) ~= string.lower(canonical) then return nil end
            found = canonical
        end
    end
    local explicit = lower:match("altar%s+of%s+([%w_]+)")
    if explicit then
        local actual = altarNamesByLower[explicit]
        if not actual and goal and string.lower(goal.Name) == explicit then
            actual = goal.Name
        end
        if not actual and tagged and string.lower(tagged) == explicit then
            actual = tagged
        end
        if not actual or (found and string.lower(found) ~= string.lower(actual)) then
            return nil
        end
        return actual
    end
    return found or tagged
end

local function maybeVoteAltar()
    local state = session.Altars
    local remote = state.VoteRemote
    if not session.Active or not state.VoteOpen or not remote then
        return
    end
    local name = voteAltarName(state.VoteTitle)
    local matched = name ~= nil and altarEnabled(name)
    state.VoteActive = matched
    if matched and state.VoteCan and not state.VoteSent and characterState() then
        local ok = pcall(function()
            remote:FireServer(true)
        end)
        if ok then
            state.VoteSent = true
        end
    end
end

local function updateVoteConnection()
    local state = session.Altars
    local events = ReplicatedStorage:FindFirstChild("Events")
    local remote = events and events:FindFirstChild("Vote")
    if remote == state.VoteRemote and state.VoteConnection then
        return
    end
    if state.VoteConnection then
        state.VoteConnection:Disconnect()
        state.VoteConnection = nil
    end
    state.VoteRemote = nil
    state.VoteOpen = false
    state.VoteActive = false
    state.VoteSent = false
    if not remote or not remote:IsA("RemoteEvent") then
        return
    end
    state.VoteRemote = remote
    state.VoteConnection = connect(remote.OnClientEvent, function(event, first, second)
        if not session.Active then
            return
        end
        if event == "New" then
            state.VoteOpen = true
            state.VoteTitle = first
            state.VoteCan = second == true
            state.VoteSent = false
            state.VoteActive = false
            maybeVoteAltar()
        elseif event == "CanVote" and state.VoteOpen then
            state.VoteCan = first == true
            maybeVoteAltar()
        elseif event == "End" then
            state.VoteOpen = false
            state.VoteCan = false
            state.VoteActive = false
            state.VoteSent = false
            state.VoteTitle = nil
        end
    end)
end

local function tryAltarPrompt(goal, root)
    local state = session.Altars
    local prompt = goal.Prompt
    if not isPromptAvailable(prompt) or state.Holding or (state.VoteOpen and state.VoteActive) then
        return
    end
    local now = time()
    if now < (state.PromptAttempts[prompt] or 0) then
        return
    end
    local maxDistance = type(prompt.MaxActivationDistance) == "number" and math.max(prompt.MaxActivationDistance, 0) or 10
    local close = (goal.Position - root.Position).Magnitude <= maxDistance
    if type(fireproximityprompt) == "function" then
        state.PromptAttempts[prompt] = now + 2
        local ok = pcall(fireproximityprompt, prompt)
        if ok then
            return
        end
    elseif not close then
        return
    end
    if not close then
        return
    end
    state.PromptAttempts[prompt] = now + 2
    local ok = pcall(function()
        prompt:InputHoldBegin()
    end)
    if not ok then
        return
    end
    state.Holding = prompt
    local duration = type(prompt.HoldDuration) == "number" and math.max(prompt.HoldDuration, 0) or 0
    task.delay(duration + 0.1, function()
        if state.Holding == prompt then
            releasePromptHold()
        end
    end)
end

function session.UpdateAltars()
    local state = session.Altars
    updateVoteConnection()
    if not session.Active or not (session.Settings.AutoPurgatory or session.Settings.AutoAltars) then
        state.Goal = nil
        state.Close = false
        releasePromptHold()
        return
    end
    local _, root = characterState()
    if not root then
        state.Goal = nil
        state.Close = false
        releasePromptHold()
        return
    end
    if state.Holding then
        maybeVoteAltar()
        return
    end
    local now = time()
    if now >= state.NextScan then
        state.NextScan = now + 0.25
        state.Goal = findAltarGoal(root)
    end
    local goal = state.Goal
    if goal and goal.Altar.Parent and altarEnabled(goal.Name) and isPromptAvailable(goal.Prompt) and not altarIsUsed(goal.Altar, goal.Scope) then
        local deadline = goal.StartedAt + 5
        if now >= deadline and not state.Holding and not (state.VoteOpen and state.VoteActive) then
            state.Skip[goal.Altar] = now + 8
            state.Goal = nil
            state.Close = false
            state.NextScan = 0
            maybeVoteAltar()
            return
        end
        local maxDistance = type(goal.Prompt.MaxActivationDistance) == "number" and math.max(goal.Prompt.MaxActivationDistance, 0) or 10
        state.Close = (goal.Position - root.Position).Magnitude <= maxDistance * 0.9
        tryAltarPrompt(goal, root)
    else
        state.Goal = nil
        state.Close = false
        releasePromptHold()
    end
    maybeVoteAltar()
end

local function floorBelow(position, character)
    local origin = position + Vector3.new(0, 8, 0)
    local direction = Vector3.new(0, -48, 0)
    local function cast(filterType, instances)
        local parameters = RaycastParams.new()
        parameters.RespectCanCollide = true
        parameters.FilterType = filterType
        parameters.FilterDescendantsInstances = instances
        return workspace:Raycast(origin, direction, parameters)
    end
    local rooms = workspace:FindFirstChild("CurrentRooms")
    if rooms then
        local ok, result = pcall(cast, Enum.RaycastFilterType.Include, {rooms})
        if ok and result and validPosition(result.Position) then
            return result.Position
        end
    end
    local ignored = {character}
    if session.MarkerFolder then
        table.insert(ignored, session.MarkerFolder)
    end
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        table.insert(ignored, enemies)
    end
    local ok, result = pcall(cast, Enum.RaycastFilterType.Exclude, ignored)
    if ok and result and validPosition(result.Position) then
        return result.Position
    end
    return nil
end

local function landingPosition(position, range, character, root, humanoid)
    local floor = floorBelow(position, character)
    if floor then
        local height = type(humanoid.HipHeight) == "number" and humanoid.HipHeight or 2
        local rootHeight = root.Size and root.Size.Y or 2
        local clearance = math.clamp(math.max(2.5, height + rootHeight / 2 + 0.15), 2.5, 7)
        local onFloor = Vector3.new(position.X, floor.Y + clearance, position.Z)
        if validPosition(onFloor) and (onFloor - position).Magnitude <= range * 0.7 then
            return onFloor
        end
    end
    local offset = math.clamp(range * 0.15, 0, 0.4)
    return position + Vector3.new(0, offset, 0)
end

local function nearbyEnemyPositions()
    local positions = {}
    if session.Settings.AvoidEnemies then
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            for _, enemy in ipairs(enemies:GetChildren()) do
                local ok, position = pcall(instancePosition, enemy)
                if enemy.Name ~= "StarMart" and ok and validPosition(position) then
                    table.insert(positions, position)
                end
            end
        end
    end
    return positions
end

local function nearEnemy(position, enemies)
    for _, enemyPosition in ipairs(enemies) do
        if math.abs(position.Y - enemyPosition.Y) < 9 and (position - enemyPosition).Magnitude < 18 then
            return true
        end
    end
    return false
end

local function nearestMine(handler, position)
    if not handler or type(handler.Gifts) ~= "table" or not validPosition(position) then
        return nil, 0, 0
    end
    local nearest, nearestRadius, nearestGap
    for _, mine in pairs(handler.Gifts) do
        if isMine(mine) and not mine.Destroyed and not mine.Collected and validPosition(mine.Position) then
            local radius = math.clamp(2.25 * giftSize(mine), 0, 18) + 2
            local distance = (position - mine.Position).Magnitude
            local gap = distance - radius
            if gap <= 6 and (not nearestGap or gap < nearestGap) then
                nearest, nearestRadius, nearestGap = mine, radius, gap
            end
        end
    end
    if not nearest then
        return nil, 0, 0
    end
    return nearest, nearestRadius, nearestRadius + nearestGap
end

local function avoidMines(handler, position, margin)
    if not handler or type(handler.Gifts) ~= "table" or not validPosition(position) then
        return position
    end
    local adjusted = position
    for _ = 1, 4 do
        local worst, worstRadius, worstPenetration
        for _, mine in pairs(handler.Gifts) do
            if isMine(mine) and not mine.Destroyed and not mine.Collected and validPosition(mine.Position) then
                local radius = math.clamp(2.25 * giftSize(mine), 0, 18) + (margin or 2)
                local delta = adjusted - mine.Position
                local flat = math.sqrt(delta.X * delta.X + delta.Z * delta.Z)
                local penetration = radius - flat
                if math.abs(delta.Y) < 10 and penetration > 0 and (not worstPenetration or penetration > worstPenetration) then
                    worst, worstRadius, worstPenetration = mine, radius, penetration
                end
            end
        end
        if not worst then
            break
        end
        local delta = adjusted - worst.Position
        local flat = math.sqrt(delta.X * delta.X + delta.Z * delta.Z)
        local dirX, dirZ = 1, 0
        if flat > 0.01 then
            dirX, dirZ = delta.X / flat, delta.Z / flat
        end
        adjusted = Vector3.new(worst.Position.X + dirX * (worstRadius + 0.5), adjusted.Y, worst.Position.Z + dirZ * (worstRadius + 0.5))
    end
    return adjusted
end

local function giftLanding(gift, handler, character, root, humanoid, enemies)
    local limit = nativeGiftLimit(handler, gift)
    local base = landingPosition(gift.Position, limit, character, root, humanoid)
    local nearest, nearestDistance
    for _, mine in pairs(handler.Gifts) do
        if isMine(mine) and not mine.Destroyed and not mine.Collected and validPosition(mine.Position) then
            local difference = gift.Position - mine.Position
            local distance = math.sqrt(difference.X * difference.X + difference.Z * difference.Z)
            local radius = math.clamp(2.25 * giftSize(mine), 0, 18)
            if math.abs(difference.Y) < 9 and distance <= radius + limit * 0.55 and (not nearestDistance or distance < nearestDistance) then
                nearest = mine
                nearestDistance = distance
            end
        end
    end
    if not nearest or limit <= 0 then
        return avoidMines(handler, base, 2)
    end
    local dx = gift.Position.X - nearest.Position.X
    local dz = gift.Position.Z - nearest.Position.Z
    local magnitude = math.sqrt(dx * dx + dz * dz)
    if magnitude < 0.01 then
        dx, dz, magnitude = 1, 0, 1
    end
    local offset = math.min(limit * 0.55, 2.5)
    local shifted = gift.Position + Vector3.new(dx / magnitude * offset, 0, dz / magnitude * offset)
    local candidate = landingPosition(shifted, limit, character, root, humanoid)
    if validPosition(candidate) and (candidate - gift.Position).Magnitude <= limit * 0.9
        and (candidate - nearest.Position).Magnitude > (base - nearest.Position).Magnitude
        and not nearEnemy(candidate, enemies) then
        return avoidMines(handler, candidate, 2)
    end
    return avoidMines(handler, base, 2)
end

local function chooseRageGift(handler, root, enemies)
    local state = session.Rage
    local now = time()
    local best, bestScore
    for _, gift in pairs(handler.Gifts) do
        if isGift(gift) and canSendGift(handler, gift) and giftSize(gift) > 0
            and giftAttemptReady(gift, now) and (not state.GiftSkip[gift] or state.GiftSkip[gift] <= now)
            and not nearEnemy(gift.Position, enemies) then
            local mine, mineRadius, mineDistance = nearestMine(handler, gift.Position)
            if mine and mineDistance < mineRadius + nativeGiftLimit(handler, gift) * 0.5 then
                state.GiftSkip[gift] = now + 6
            else
                local score = (gift.Position - root.Position).Magnitude
                if session.Settings.GoldenFirst and not giftIsGolden(gift) then
                    score = score + 100000
                end
                local attempt = session.Attempts[gift]
                if attempt then
                    score = score + math.min(attempt.Failures or 0, 8) * 15
                end
                if not best or score < bestScore then
                    best, bestScore = gift, score
                end
            end
        end
    end
    return best
end

local function warpTo(root, position)
    if not validPosition(position) then
        return false
    end
    local ok = pcall(function()
        root.CFrame = root.CFrame + (position - root.Position)
    end)
    if ok then
        pcall(function()
            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end)
    end
    return ok
end

local function startFlush(now)
    local state = session.Rage
    state.Phase = "Flush"
    state.Target = nil
    state.Destination = nil
    state.ReleaseAt = now + 0.025 + networkDelay() * 0.25
    state.QueueDeadline = now + 1.5 + networkDelay()
end

local function noteWarpFailure(target, now)
    local state = session.Rage
    if target and not target.IsAltar then
        state.GiftSkip[target] = now + 2
        state.ExtraSettle = math.min(state.ExtraSettle + 0.08, 0.7)
        state.NextSpeedDecay = now + 3
    end
    state.Failures = state.Failures + 1
    state.Phase = "Idle"
    state.Target = nil
    state.Destination = nil
    state.NextMove = now + (state.Failures >= 3 and 1.2 or 0.15)
    if state.Failures >= 3 and now >= state.NextWarning and session.Notify then
        state.NextWarning = now + 15
        session.Notify("Teleport may be blocked")
    end
end

local function openPortal()
    local enemies = workspace:FindFirstChild("Enemies")
    local awaitingMart = false
    if enemies then
        for _, enemy in ipairs(enemies:GetChildren()) do
            if enemy:IsA("BasePart") and enemy.Parent == enemies and not enemy:GetAttribute("Despawned")
                and validPosition(enemy.Position) then
                local arrow, beaconFlag = enemy:GetAttribute("ArrowType"), enemy:GetAttribute("Beacon")
                if arrow == "BeaconImp" and beaconFlag ~= false then
                    session.Portal.MartWaitSince = nil
                    return enemy, "Imp"
                end
                if enemy.Name == "Mart" and beaconFlag == true and arrow ~= "FakeBeaconImp" then
                    awaitingMart = true
                end
            end
        end
    end
    local portal = session.Portal
    if awaitingMart then
        portal.MartWaitSince = portal.MartWaitSince or time()
        if time() - portal.MartWaitSince < 3 then return nil end
    else
        portal.MartWaitSince = nil
    end
    local beacon = beaconTouchPart()
    if beacon and beacon.Parent and validPosition(beacon.Position) then
        return beacon, "Beacon"
    end
    return nil
end

local function portalCounter(counters, name)
    local counter = counters and counters:FindFirstChild(name)
    if not counter then
        return nil
    end
    local ok, value, maximum = pcall(function()
        return counter.Value, counter:GetAttribute("MaxGifts")
    end)
    if ok and type(value) == "number" and value == value and math.abs(value) < 1000000000 then
        return value, maximum
    end
    return nil
end

local function portalGiftsClear(handler, now)
    local portal = session.Portal
    if not handler or type(handler.Gifts) ~= "table" then
        portal.NoVisibleSince = nil
        return false, false
    end
    for _, gift in pairs(handler.Gifts) do
        if isGift(gift) then
            portal.NoVisibleSince = nil
            return false, true
        end
    end
    portal.NoVisibleSince = portal.NoVisibleSince or now
    local pending = collectionQueuePending(handler)
    local replication = handler.ReplicationClient
    pending = pending or (replication and type(replication.Queue) == "table" and #replication.Queue > 0)
    if pending then
        if now - portal.NoVisibleSince < 3 then return false, true end
        local counters = ReplicatedStorage:FindFirstChild("GiftCounters")
        local normal = portalCounter(counters, "Gift")
        local golden = portalCounter(counters, "GoldenGift")
        if (normal and normal > 0) or (golden and golden > 0) then return false, true end
    end
    return true, true
end

local function observePortal(handler, now)
    local portal = session.Portal
    local levelObject = ReplicatedStorage:FindFirstChild("Level")
    local level = levelObject and levelObject.Value or nil
    if portal.Level ~= level then
        resetRage()
        portal.Level = level
    end
    if not session.Active or not (session.Settings.RageFarm or session.Settings.FastFlyFarm)
        or not session.Settings.AutoPortal or not characterState() then
        portal.Ready = false
        portal.EmptySince = nil
        updatePortalGate(false)
        return nil, nil, false, false
    end
    local clear, valid = portalGiftsClear(handler, now)
    if valid and not clear and handler and type(handler.Gifts) == "table" then
        for _, gift in pairs(handler.Gifts) do
            if isGift(gift) then portal.HadGifts = true; break end
        end
    end
    if valid and not portal.HadGifts then
        for _, gift in pairs(handler.Gifts) do
            if type(gift) == "table" and not isMine(gift) and not gift.Destroyed and gift.Collected == true
                and (gift.Type == "Gift" or gift.Type == "GoldenGift" or gift.Type == "PassageGift" or gift.Golden == true) then
                portal.HadGifts = true
                break
            end
        end
    end
    if valid and not portal.HadGifts then
        local counters = ReplicatedStorage:FindFirstChild("GiftCounters")
        local normal = portalCounter(counters, "Gift")
        local golden, maximum = portalCounter(counters, "GoldenGift")
        if normal == 0 and golden == 0 and type(maximum) == "number" and maximum > 0 then
            portal.HadGifts = true
        end
    end
    portal.EmptySince = valid and portal.HadGifts and portal.NoVisibleSince or nil
    local part, kind = openPortal()
    local ready = part ~= nil and clear and portal.HadGifts and portal.EmptySince ~= nil
        and now - portal.EmptySince >= 3
    portal.Ready = ready == true
    if not valid then portal.Status = "Waiting for gift data"
    elseif not portal.HadGifts then portal.Status = "Waiting to see gifts"
    elseif not portal.NoVisibleSince then portal.Status = "Collecting gifts"
    elseif now - portal.NoVisibleSince < 3 then portal.Status = "Waiting for golden gifts"
    elseif not part then portal.Status = "Waiting for beacon / Mart"
    elseif not clear then portal.Status = "Waiting for collection queue"
    elseif type(firetouchinterest) ~= "function" then portal.Status = "firetouchinterest unavailable"
    elseif portal.LastTouchTarget == part and portal.TouchResult then portal.Status = portal.TouchResult
    else portal.Status = kind == "Imp" and "Touching Beacon Mart" or "Touching beacon" end
    updatePortalGate(portal.Ready)
    return part, kind, portal.Ready, clear
end

do
    local nextCheck = 0
    connect(RunService.Heartbeat, function()
        if time() < nextCheck then return end
        nextCheck = time() + 0.08
        local farming = session.Settings.RageFarm or session.Settings.FastFlyFarm
        if not session.Active or not farming then
            releasePortalGate()
            return
        end
        local portal = session.Portal
        local handler = session.GiftHandler
        if handler and type(handler.Gifts) == "table" then
            for _, gift in pairs(handler.Gifts) do
                if isGift(gift) then portal.HadGifts = true; break end
            end
        end
        local allow = session.Settings.AutoPortal and portal.Ready == true
        if allow then
            local clear = portalGiftsClear(session.GiftHandler, time())
            if not clear then portal.Ready = false; allow = false end
        end
        updatePortalGate(allow)
    end)
    connect(workspace.DescendantAdded, function(obj)
        local beacon = workspace:FindFirstChild("Beacon")
        if beacon and obj:IsA("BasePart") and (obj == beacon or obj:IsDescendantOf(beacon)) then
            local allow = session.Settings.AutoPortal and session.Portal.Ready == true
            updatePortalGate(allow)
        end
    end)
end

local function touchPortal(character, root, portalPart, portalKind, now)
    local portal = session.Portal
    if not session.Active or not session.Settings.AutoPortal or not portal.Ready
        or not (session.Settings.RageFarm or session.Settings.FastFlyFarm)
        or LocalPlayer.Character ~= character or not characterState() then return false end
    local clear = portalGiftsClear(session.GiftHandler, now)
    if not clear then
        portal.Ready = false
        updatePortalGate(false)
        return false
    end
    if portal.LastTouchTarget ~= portalPart then
        portal.LastTouchTarget = portalPart
        portal.NextTouch, portal.Attempts, portal.NextWarning = 0, 0, 0
        portal.TouchResult = nil
        portal.ImpWaitStarted = nil
    end
    if now < (portal.NextTouch or 0) then return false end
    portal.NextTouch = now + 0.7
    if type(firetouchinterest) ~= "function" then
        if now >= (portal.NextWarning or 0) then
            portal.NextWarning = now + 15
            portal.Status = "firetouchinterest unavailable"
            if session.Notify then session.Notify("Auto Portal: firetouchinterest unavailable") end
        end
        return false
    end
    local part
    if portalKind == "Imp" then
        if not portalPart or not portalPart:IsA("BasePart") or not portalPart.Parent
            or portalPart:GetAttribute("ArrowType") ~= "BeaconImp"
            or portalPart:GetAttribute("Beacon") == false or portalPart:GetAttribute("Despawned")
            or not validPosition(portalPart.Position) then return false end
        part = portalPart
        if not part.CanTouch then
            portal.ImpWaitStarted = portal.ImpWaitStarted or now
            if now - portal.ImpWaitStarted >= 4 and now >= (portal.NextWarning or 0) then
                portal.NextWarning = now + 15
                if session.Notify then session.Notify("Beacon Mart is not touchable yet") end
            end
            return false
        end
        portal.ImpWaitStarted = nil
    else
        local beacon = workspace:FindFirstChild("Beacon")
        local touch = beacon and beacon:FindFirstChild("TouchInterest", true)
        if touch and touch.Parent and touch.Parent:IsA("BasePart") then
            part = touch.Parent
        elseif portalPart and portalPart:IsA("BasePart") then
            part = portalPart
        end
    end
    if not part or not part.Parent then return false end
    if portalKind == "Beacon" and not part.CanTouch then
        local ok = pcall(function() part.CanTouch = true end)
        if not ok or not part.CanTouch then
            portal.Status = "Beacon CanTouch unavailable"
            return false
        end
    end
    local parts = {root}
    local body = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    if body and body:IsA("BasePart") and body ~= root then table.insert(parts, body) end
    local invoked, lastError = false, nil
    for _, bodyPart in ipairs(parts) do
        local fromPart = bodyPart
        local okBegin, err = pcall(firetouchinterest, fromPart, part, 0)
        if not okBegin then lastError = err end
        invoked = invoked or okBegin
        task.delay(0.05, function()
            pcall(firetouchinterest, fromPart, part, 1)
        end)
    end
    portal.Attempts = (portal.Attempts or 0) + 1
    portal.TouchResult = invoked and "Touch sent; waiting for server" or "firetouchinterest call failed"
    portal.Status = portal.TouchResult
    if (not invoked or portal.Attempts >= 4) and now >= (portal.NextWarning or 0) then
        portal.NextWarning = now + 15
        if not invoked then
            warn("[NULL Auto Portal] firetouchinterest failed: " .. tostring(lastError))
            if session.Notify then session.Notify("Auto Portal: firetouchinterest call failed") end
        elseif session.Notify then
            session.Notify("Portal touch not confirmed; server may reject it")
        end
    end
    return invoked
end

function session.RageStep()
    local state = session.Rage
    if not session.Active or not session.Settings.RageFarm then
        if state.Phase ~= "Idle" or session.Portal.Gated then
            resetRage()
        end
        return
    end
    local character, root, humanoid = characterState()
    if not character or not root or root.Anchored then
        resetRage()
        return
    end
    if session.Shop.Busy then
        return
    end
    local now = time()
    local handler = session.GiftHandler
    local mine, mineRadius, mineDistance = nearestMine(handler, root.Position)
    if mine and mineDistance < mineRadius and now >= (state.NextMineEscape or 0) then
        state.NextMineEscape = now + 0.35
        local escaped = avoidMines(handler, root.Position, 3)
        if validPosition(escaped) and (escaped - root.Position).Magnitude > 0.1 then
            warpTo(root, escaped)
            state.Target = nil
            state.Destination = nil
        end
    end
    if state.ExtraSettle > 0 and now - state.LastReject >= 3 and now >= state.NextSpeedDecay then
        state.ExtraSettle = math.max(0, state.ExtraSettle - 0.03)
        state.NextSpeedDecay = now + 1
    end
    local portalPart, portalKind, portalReady, giftsClear
    if session.Settings.AutoPortal then
        portalPart, portalKind, portalReady, giftsClear = observePortal(handler, now)
        if not session.Active or not session.Settings.RageFarm or LocalPlayer.Character ~= character then
            return
        end
        if not session.Settings.AutoPortal then
            portalPart, portalKind, portalReady, giftsClear = nil, nil, false, false
            releasePortalGate()
        end
    else
        updatePortalGate(false)
    end
    if portalReady and portalPart then
        state.Phase, state.Target, state.Destination = "Idle", nil, nil
        touchPortal(character, root, portalPart, portalKind, now)
        return
    end
    if state.Phase == "Flush" then
        local pending = collectionQueuePending(handler)
        if now >= state.ReleaseAt and (not pending or now >= state.QueueDeadline) then
            if pending then
                state.NextQueueWait = now + 1.5
                if now >= state.NextQueueWarning and session.Notify then
                    state.NextQueueWarning = now + 15
                    session.Notify("Gift queue is not sending")
                end
            end
            state.Phase = "Idle"
            state.NextMove = now
        elseif now >= state.QueueDeadline + 6 then
            state.Phase = "Idle"
            state.Target = nil
            state.Destination = nil
            state.NextMove = now + 0.25
        end
        return
    end
    if state.Phase == "GiftSettle" then
        if now < state.ReadyAt then
            return
        end
        local target, destination = state.Target, state.Destination
        if not validPosition(destination) or (root.Position - destination).Magnitude > 6 then
            noteWarpFailure(target, now)
            return
        end
        if target and isGift(target) and handler and (root.Position - target.Position).Magnitude > math.max(nativeGiftLimit(handler, target) * 0.9, 1.5) then
            noteWarpFailure(target, now)
            return
        end
        state.Failures = 0
        session.TryCollectNearby()
        if session.Active and session.Settings.RageFarm and LocalPlayer.Character == character then
            startFlush(time())
        end
        return
    end
    if state.Phase == "AltarSettle" then
        if now < state.ReadyAt then
            return
        end
        local goal, destination = state.Target, state.Destination
        if not validPosition(destination) or (root.Position - destination).Magnitude > 6 then
            if goal then
                session.Altars.Skip[goal.Altar] = now + 8
                session.Altars.NextScan = 0
            end
            noteWarpFailure(goal, now)
            return
        end
        state.Failures = 0
        if goal and goal.Altar.Parent and altarEnabled(goal.Name) and isPromptAvailable(goal.Prompt) and not altarIsUsed(goal.Altar, goal.Scope) then
            session.Altars.PromptAttempts[goal.Prompt] = 0
            tryAltarPrompt(goal, root)
            if not session.Active or not session.Settings.RageFarm or LocalPlayer.Character ~= character then
                return
            end
            session.Altars.Skip[goal.Altar] = time() + 8
            session.Altars.NextScan = 0
        end
        state.Phase = "AltarHold"
        state.ReleaseAt = now + 0.3
        state.QueueDeadline = now + 4
        return
    end
    if state.Phase == "AltarHold" then
        if session.Altars.Holding and now < state.QueueDeadline then
            return
        end
        if session.Altars.Holding then
            releasePromptHold()
        end
        if now >= state.ReleaseAt then
            state.Phase = "Idle"
            state.Target = nil
            state.Destination = nil
            state.NextMove = now
        end
        return
    end
    if now < state.NextMove then
        return
    end
    local queuePending = collectionQueuePending(handler)
    if queuePending and now >= state.NextQueueWait then
        startFlush(now)
        return
    end
    local goal = session.Altars.Goal
    local altarState = session.Altars
    if goal and now >= state.NextAltar and not (altarState.VoteOpen and altarState.VoteActive)
        and not altarState.Holding and goal.Altar.Parent and altarEnabled(goal.Name) and isPromptAvailable(goal.Prompt)
        and not altarIsUsed(goal.Altar, goal.Scope) and (not altarState.Skip[goal.Altar] or altarState.Skip[goal.Altar] <= now) then
        local maxDistance = type(goal.Prompt.MaxActivationDistance) == "number" and math.max(goal.Prompt.MaxActivationDistance, 0) or 10
        if (goal.Position - root.Position).Magnitude > maxDistance * 0.8 then
            local destination = landingPosition(goal.Position, maxDistance, character, root, humanoid)
            altarState.Skip[goal.Altar] = now + 8
            state.NextAltar = now + 3.5
            if warpTo(root, destination) then
                state.Phase = "AltarSettle"
                state.Target = goal
                state.Destination = destination
                state.ReadyAt = now + 0.24 + networkDelay()
                return
            end
            noteWarpFailure(goal, now)
            return
        end
    end
    local sent = not queuePending and session.TryCollectNearby() or 0
    if not session.Active or not session.Settings.RageFarm or LocalPlayer.Character ~= character then
        return
    end
    if sent > 0 then
        startFlush(time())
        return
    end
    if not handler or type(handler.Gifts) ~= "table" then
        state.NextMove = now + 0.25
        return
    end
    local enemyPositions = nearbyEnemyPositions()
    local target = chooseRageGift(handler, root, enemyPositions)
    if not target then
        state.NextMove = now + 0.15
        return
    end
    local limit = nativeGiftLimit(handler, target)
    local distance = (target.Position - root.Position).Magnitude
    if distance <= limit * 0.75 then
        state.GiftSkip[target] = now + 0.4
        state.NextMove = now + 0.06
        return
    end
    local destination = giftLanding(target, handler, character, root, humanoid, enemyPositions)
    if not warpTo(root, destination) then
        state.GiftSkip[target] = now + 2
        noteWarpFailure(target, now)
        return
    end
    state.Phase = "GiftSettle"
    state.Target = target
    state.Destination = destination
    state.ReadyAt = now + math.clamp(0.08 + networkDelay() * 0.6 + state.ExtraSettle, 0.08, 0.8)
end

do
    local state = {LastAction = 0, LastSafe = nil, NextSafeScan = 0}
    function session.ResetAntiVoid()
        state.LastAction, state.LastSafe, state.NextSafeScan = 0, nil, 0
        session.AntiVoidHoldUntil = 0
    end
    local function safeSpawn(threshold)
        local part = workspace:FindFirstChild("Spawn") or workspace:FindFirstChild("SpawnLocation")
        if part and part:IsA("BasePart") and validPosition(part.Position) and part.Position.Y > threshold + 5 then
            return part.CFrame + Vector3.new(0, 5, 0)
        end
        if state.LastSafe and state.LastSafe.Position.Y > threshold + 5 then return state.LastSafe end
        return nil
    end
    local function nearestGift(root, threshold)
        local handler = session.GiftHandler
        local best, distance = nil, math.huge
        if handler and type(handler.Gifts) == "table" then
            for _, gift in pairs(handler.Gifts) do
                if isGift(gift) and gift.Position.Y > threshold + 5 then
                    local d = (gift.Position - root.Position).Magnitude
                    if d < distance then best, distance = gift.Position, d end
                end
            end
        else
            local pools = workspace:FindFirstChild("Item_Pools")
            local normal = pools and pools:FindFirstChild("Gift") or workspace:FindFirstChild("Gifts") or workspace:FindFirstChild("SpawnedGifts")
            local golden = pools and pools:FindFirstChild("GoldenGift")
            local folders = {}
            if normal then table.insert(folders, normal) end
            if golden and golden ~= normal then table.insert(folders, golden) end
            for _, folder in ipairs(folders) do
                for _, obj in ipairs(folder:GetChildren()) do
                    local pos = instancePosition(obj)
                    if validPosition(pos) and pos.Y > threshold + 5 then
                        local d = (pos - root.Position).Magnitude
                        if d < distance then best, distance = pos, d end
                    end
                end
            end
        end
        return best and CFrame.new(best + Vector3.new(0, 5, 0)) or nil
    end
    connect(RunService.Heartbeat, function()
        if not session.Active or not session.Settings.AntiVoid then return end
        if session.Shop.Busy then return end
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not root:IsA("BasePart") or not humanoid or humanoid.Health <= 0 then return end
        local killVoid = workspace:FindFirstChild("KillVoid")
        local voidPos = killVoid and instancePosition(killVoid)
        local threshold = validPosition(voidPos) and voidPos.Y + 5 or -100
        local now = time()
        if root.Position.Y > threshold + 20 and now >= state.NextSafeScan then
            state.NextSafeScan = now + 0.5
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            local ignored = {char}
            local enemies = workspace:FindFirstChild("Enemies")
            if enemies then table.insert(ignored, enemies) end
            local beacon = workspace:FindFirstChild("Beacon")
            if beacon then table.insert(ignored, beacon) end
            params.FilterDescendantsInstances = ignored
            params.RespectCanCollide = true
            local ok, hit = pcall(function() return workspace:Raycast(root.Position, Vector3.new(0, -12, 0), params) end)
            if ok and hit and hit.Position.Y > threshold + 5 then state.LastSafe = root.CFrame end
        end
        if root.Position.Y > threshold or now - state.LastAction < 1 then return end
        state.LastAction = now
        session.AntiVoidHoldUntil = now + 1.25
        if session.Settings.RageFarm then
            local portal = session.Portal
            local level, hadGifts, emptySince = portal.Level, portal.HadGifts, portal.EmptySince
            resetRage()
            portal.Level, portal.HadGifts, portal.EmptySince = level, hadGifts, emptySince
            updatePortalGate(false)
        end
        local mode = session.Settings.AntiVoidMode
        local destination
        if mode == 1 then destination = safeSpawn(threshold)
        elseif mode == 3 then destination = nearestGift(root, threshold) or safeSpawn(threshold) end
        if destination then
            pcall(function()
                root.CFrame = destination
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end)
        else
            pcall(function()
                local velocity = root.AssemblyLinearVelocity
                root.AssemblyLinearVelocity = Vector3.new(velocity.X, session.Settings.AntiVoidPower, velocity.Z)
            end)
        end
    end)
end

do
    local SPEED, RADIUS = 200, 45
    local state = {Parts = setmetatable({}, {__mode = "k"}), Attempts = setmetatable({}, {__mode = "k"}), Target = nil, JumpSerial = 0}

    local function releaseFastJump(serial)
        if serial and serial ~= state.JumpSerial then return end
        local core, humanoid = state.JumpCore, state.JumpHumanoid
        state.JumpCore, state.JumpHumanoid = nil, nil
        if core and type(core.JumpButton) == "function" then
            pcall(core.JumpButton, core, Enum.UserInputState.End)
        end
        if humanoid and humanoid.Parent then
            pcall(function() humanoid.Jump = false end)
        end
    end

    function session.ResetFastFly()
        releaseFastJump()
        state.JumpSerial += 1
        local h = state.Humanoid
        if h and h.Parent and h.PlatformStand == true then
            pcall(function() h.PlatformStand = state.PlatformStand end)
        end
        for part, old in pairs(state.Parts) do
            pcall(function() if part.Parent and part.CanCollide == false then part.CanCollide = old end end)
            state.Parts[part] = nil
        end
        state.Humanoid = nil
        state.Target = nil
        state.LastJump = 0
        state.HadGifts = false
        state.EmptySince = nil
        state.Attempts = setmetatable({}, {__mode = "k"})
        releasePortalGate()
    end
    connect(RunService.Stepped, function()
        if not session.Active or not session.Settings.FastFlyFarm then return end
        if session.Shop.Busy then return end
        local character, root = characterState()
        local handler = session.GiftHandler
        if not character or root.Anchored or not handler or type(handler.Gifts) ~= "table" then return end
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                if state.Parts[part] == nil then state.Parts[part] = true end
                part.CanCollide = false
            end
        end
    end)
    connect(RunService.Heartbeat, function(dt)
        if not session.Active or not session.Settings.FastFlyFarm then
            if state.Humanoid or state.JumpHumanoid or state.JumpCore or next(state.Parts) then
                session.ResetFastFly()
            end
            return
        end
        if session.Shop.Busy then return end
        if time() < (session.AntiVoidHoldUntil or 0) then return end
        local character, root, humanoid = characterState()
        local handler = session.GiftHandler
        if not character or root.Anchored or not handler or type(handler.Gifts) ~= "table" then
            if state.Humanoid or state.JumpHumanoid or state.JumpCore or next(state.Parts) then session.ResetFastFly() end
            return
        end
        if state.Humanoid ~= humanoid then
            if state.Humanoid then session.ResetFastFly() end
            state.Humanoid = humanoid
            state.PlatformStand = humanoid.PlatformStand
        end
        humanoid.PlatformStand = true
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        local now = time()
        local levelObject = ReplicatedStorage:FindFirstChild("Level")
        local level = levelObject and levelObject.Value or nil
        if state.Level ~= level then
            state.Level = level
            state.HadGifts, state.EmptySince, state.Target = false, nil, nil
            state.Attempts = setmetatable({}, {__mode = "k"})
        end
        if now >= (state.LastJump or 0) then
            state.LastJump = now + 0.2
            releaseFastJump()
            state.JumpSerial += 1
            local serial = state.JumpSerial
            local globals = _G
            if type(getrenv) == "function" then
                local ok, env = pcall(getrenv)
                if ok and type(env) == "table" and type(env._G) == "table" then globals = env._G end
            end
            if type(globals.GetMovementCore) == "function" then
                local ok, core = pcall(globals.GetMovementCore)
                if ok and type(core) == "table" and type(core.JumpButton) == "function"
                    and (core.Character == nil or core.Character == character) then
                    state.JumpCore = core
                    local started = pcall(core.JumpButton, core, Enum.UserInputState.Begin)
                    if not started then releaseFastJump(serial) end
                end
            end
            state.JumpHumanoid = humanoid
            humanoid.Jump = true
            task.delay(0.08, function() releaseFastJump(serial) end)
        end
        local best, bestScore, remaining = nil, math.huge, 0
        for _, gift in pairs(handler.Gifts) do
            if isGift(gift) then
                remaining += 1
                local distance = (gift.Position - root.Position).Magnitude
                if distance <= RADIUS then
                    session.TryReachGift(handler, gift, character, distance, now)
                end
                local skip = state.Attempts[gift]
                if not skip or now >= skip then
                    local score = distance
                    if session.Settings.GoldenFirst and not giftIsGolden(gift) then score += 100000 end
                    if score < bestScore then best, bestScore = gift, score end
                end
            end
        end
        local portalPart, portalKind, portalReady
        if remaining > 0 then state.HadGifts = true; state.EmptySince = nil
        elseif state.HadGifts then state.EmptySince = state.EmptySince or now end
        if session.Settings.AutoPortal then portalPart, portalKind, portalReady = observePortal(handler, now) end
        if portalReady and portalPart then
            state.Target = nil
            touchPortal(character, root, portalPart, portalKind, now)
            return
        end
        local targetPos
        local altar = session.Altars.Goal
        if altar and altarEnabled(altar.Name) and altar.Altar.Parent and isPromptAvailable(altar.Prompt)
            and not altarIsUsed(altar.Altar, altar.Scope) then
            targetPos = altar.Position
            state.Target = nil
        elseif best then
            local distance = (best.Position - root.Position).Magnitude
            if state.Target ~= best then
                state.Target = best
                state.BestDistance, state.LastProgress = distance, now
            elseif distance < (state.BestDistance or math.huge) - 1 then
                state.BestDistance, state.LastProgress = distance, now
            elseif now - (state.LastProgress or now) > 5 then
                state.Attempts[best] = now + 2
                state.Target = nil
                return
            end
            targetPos = best.Position
        else
            state.Target = nil
            return
        end
        if not validPosition(targetPos) then return end
        local delta = targetPos - root.Position
        local dist = delta.Magnitude
        if dist > 0.1 then
            local step = math.min(dist, SPEED * math.min(dt, 0.1))
            local moved = avoidMines(handler, root.Position + delta.Unit * step, 2)
            if not validPosition(moved) then moved = root.Position + delta.Unit * step end
            root.CFrame = CFrame.new(moved, targetPos + delta.Unit)
        end
    end)
end


do
    local attempts = setmetatable({}, {__mode = "k"})
    local nextWarning, queued = 0, false
    function session.ResetMedal()
        attempts = setmetatable({}, {__mode = "k"})
        nextWarning = 0
    end
    function session.UpdateMedals()
        if not session.Active or not session.Settings.AutoMedal then return end
        local beacons = workspace:FindFirstChild("Beacons")
        if not beacons then return end
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not root:IsA("BasePart") or not root.Parent or not humanoid or humanoid.Health <= 0 then return end
        local now = time()
        for _, medal in ipairs(beacons:GetChildren()) do
            if medal.Name == "Medal" then
                local touch = medal:FindFirstChild("TouchInterest", true)
                local part = touch and touch.Parent
                if touch and part and part:IsA("BasePart") and part:IsDescendantOf(beacons) then
                    local previous = attempts[touch]
                    if not previous or now - previous >= 0.8 then
                        attempts[touch] = now
                        if type(firetouchinterest) ~= "function" then
                            if now >= nextWarning then
                                nextWarning = now + 15
                                if session.Notify then session.Notify("Auto Medal: firetouchinterest unavailable") end
                            end
                        else
                            local fromPart, toPart = root, part
                            pcall(firetouchinterest, fromPart, toPart, 0)
                            task.delay(0.05, function() pcall(firetouchinterest, fromPart, toPart, 1) end)
                        end
                    end
                end
            end
        end
    end
    local function scheduleScan()
        if queued then return end
        queued = true
        task.defer(function()
            queued = false
            if session.Active and session.Settings.AutoMedal then
                local ok, err = pcall(session.UpdateMedals)
                if not ok then warn("[NULL Auto Medal] " .. tostring(err)) end
            end
        end)
    end
    connect(workspace.DescendantAdded, function(obj)
        if not session.Active or not session.Settings.AutoMedal then return end
        if obj.Name ~= "Beacons" and obj.Name ~= "Medal" and obj.Name ~= "TouchInterest" then return end
        local beacons = workspace:FindFirstChild("Beacons")
        if beacons and (obj == beacons or obj:IsDescendantOf(beacons)) then scheduleScan() end
    end)
    connect(workspace.DescendantRemoving, function(obj)
        if obj.Name == "TouchInterest" then
            attempts[obj] = nil
        elseif obj.Name == "Medal" then
            for _, descendant in ipairs(obj:GetDescendants()) do
                if descendant.Name == "TouchInterest" then attempts[descendant] = nil end
            end
        end
    end)
    task.spawn(function()
        while session.Active do
            if session.Settings.AutoMedal then scheduleScan() end
            task.wait(0.1)
        end
    end)
end


do
    local attempts = setmetatable({}, {__mode = "k"})
    local nextWarning, queued = 0, false
    function session.ResetStarMart()
        attempts = setmetatable({}, {__mode = "k"})
        nextWarning = 0
    end
    function session.UpdateStarMart()
        if not session.Active or not session.Settings.AutoStarMart then return end
        local enemies = workspace:FindFirstChild("Enemies")
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if not enemies or not root or not root:IsA("BasePart") or not root.Parent or not humanoid or humanoid.Health <= 0 then return end
        local now = time()
        for _, item in ipairs(enemies:GetChildren()) do
            if item.Name == "StarMart" then
                local touch = item:FindFirstChild("TouchInterest", true)
                local part = touch and touch.Parent
                if touch and part and part:IsA("BasePart") and part:IsDescendantOf(enemies) then
                    local previous = attempts[touch]
                    if not previous or now - previous >= 0.8 then
                        attempts[touch] = now
                        if type(firetouchinterest) ~= "function" then
                            if now >= nextWarning then
                                nextWarning = now + 15
                                if session.Notify then session.Notify("Auto StarMart: firetouchinterest unavailable") end
                            end
                        else
                            local fromPart, toPart = root, part
                            pcall(firetouchinterest, fromPart, toPart, 0)
                            task.delay(0.05, function() pcall(firetouchinterest, fromPart, toPart, 1) end)
                        end
                    end
                end
            end
        end
    end
    local function scheduleScan()
        if queued then return end
        queued = true
        task.defer(function()
            queued = false
            if session.Active and session.Settings.AutoStarMart then
                local ok, err = pcall(session.UpdateStarMart)
                if not ok then warn("[NULL Auto StarMart] " .. tostring(err)) end
            end
        end)
    end
    connect(workspace.DescendantAdded, function(obj)
        if not session.Active or not session.Settings.AutoStarMart then return end
        if obj.Name ~= "Enemies" and obj.Name ~= "StarMart" and obj.Name ~= "TouchInterest" then return end
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies and (obj == enemies or obj:IsDescendantOf(enemies)) then scheduleScan() end
    end)
    connect(workspace.DescendantRemoving, function(obj)
        if obj.Name == "TouchInterest" then
            attempts[obj] = nil
        elseif obj.Name == "StarMart" then
            for _, descendant in ipairs(obj:GetDescendants()) do
                if descendant.Name == "TouchInterest" then attempts[descendant] = nil end
            end
        end
    end)
    task.spawn(function()
        while session.Active do
            if session.Settings.AutoStarMart then scheduleScan() end
            task.wait(0.1)
        end
    end)
end

do
    local state = {Token = 0, Saved = setmetatable({}, {__mode = "k"})}
    local function disconnect(connection)
        if connection then pcall(function() connection:Disconnect() end) end
    end
    function session.ResetRazorbloom()
        state.Token += 1
        disconnect(state.CharacterConnection)
        disconnect(state.EnemyConnection)
        disconnect(state.EventConnection)
        state.CharacterConnection, state.EnemyConnection, state.EventConnection = nil, nil, nil
        state.Character, state.Enemy, state.Event = nil, nil, nil
        for obj, record in pairs(state.Saved) do
            pcall(function()
                if obj.Parent and obj[record.Property] == record.Applied then obj[record.Property] = record.Old end
            end)
            state.Saved[obj] = nil
        end
        state.LastID, state.LastStart = nil, nil
    end
    local function apply(obj, property, value)
        local ok, current = pcall(function() return obj[property] end)
        if not ok or current == value then return end
        if not state.Saved[obj] then state.Saved[obj] = {Property=property, Old=current, Applied=value} end
        pcall(function() obj[property] = value end)
    end
    local function removeWings(character, token)
        if not session.Active or not session.Settings.RazorbloomBypass or state.Token ~= token
            or LocalPlayer.Character ~= character then return end
        local root = character:FindFirstChild("HumanoidRootPart")
        local wings = root and root:FindFirstChild("StrongWings")
        if wings then pcall(function() wings:Destroy() end) end
    end
    local function onStart(character, enemy, remote, token, action, id)
        if action ~= "Start" or not session.Active or not session.Settings.RazorbloomBypass
            or state.Token ~= token or state.Enemy ~= enemy or LocalPlayer.Character ~= character then return end
        local now = time()
        if state.LastID ~= id or not state.LastStart or now - state.LastStart >= 0.5 then
            state.LastID, state.LastStart = id, now
            pcall(function() remote:FireServer("Survived") end)
        end
        local root = enemy:FindFirstChild("RootPart", true)
        if root then
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("Sound") then pcall(function() obj:Stop() end) end
            end
        end
        removeWings(character, token)
        for _, delaySeconds in ipairs({0.05, 0.15, 0.3}) do
            task.delay(delaySeconds, function() removeWings(character, token) end)
        end
    end
    function session.UpdateRazorbloom()
        if not session.Active or not session.Settings.RazorbloomBypass then
            if state.Character or state.Enemy then session.ResetRazorbloom() end
            return
        end
        local character = LocalPlayer.Character
        if not character or not character.Parent then
            if state.Character or state.Enemy then session.ResetRazorbloom() end
            return
        end
        if state.Character ~= character then
            session.ResetRazorbloom()
            state.Character = character
            state.CharacterConnection = character.ChildAdded:Connect(function(child)
                if child.Name == "Razorbloom" then task.defer(session.UpdateRazorbloom) end
            end)
        end
        local enemy = character:FindFirstChild("Razorbloom")
        if state.Enemy ~= enemy then
            disconnect(state.EnemyConnection)
            disconnect(state.EventConnection)
            state.EnemyConnection, state.EventConnection, state.Event = nil, nil, nil
            for obj, record in pairs(state.Saved) do
                pcall(function() if obj.Parent and obj[record.Property] == record.Applied then obj[record.Property] = record.Old end end)
                state.Saved[obj] = nil
            end
            state.Token += 1
            state.LastID, state.LastStart = nil, nil
            state.Enemy = enemy
            if enemy then
                state.EnemyConnection = enemy.DescendantAdded:Connect(function()
                    if session.Active and session.Settings.RazorbloomBypass then task.defer(session.UpdateRazorbloom) end
                end)
            end
        end
        if not enemy then return end
        local clientAI = enemy:FindFirstChild("Razorbloom_ClientAI", true)
        if clientAI and (clientAI:IsA("LocalScript") or clientAI:IsA("Script")) then apply(clientAI, "Disabled", true) end
        if enemy:IsA("BasePart") then apply(enemy, "Transparency", 1) end
        for _, obj in ipairs(enemy:GetDescendants()) do
            if obj:IsA("BasePart") then apply(obj, "Transparency", 1) end
        end
        local event = enemy:FindFirstChild("ClientEvent", true)
        if event ~= state.Event then
            disconnect(state.EventConnection)
            state.EventConnection, state.Event = nil, nil
            if event and event:IsA("RemoteEvent") then
                state.Event = event
                local token = state.Token
                state.EventConnection = event.OnClientEvent:Connect(function(action, id)
                    onStart(character, enemy, event, token, action, id)
                end)
            end
        end
    end
    connect(LocalPlayer.CharacterAdded, function()
        task.defer(function() if session.Active and session.Settings.RazorbloomBypass then session.UpdateRazorbloom() end end)
    end)
    task.spawn(function()
        while session.Active do
            local ok, err = pcall(session.UpdateRazorbloom)
            if not ok then warn("[NULL Razorbloom] " .. tostring(err)) end
            task.wait(0.2)
        end
    end)
end

do
    local state = {Frozen = {}, Hidden = {}, ClientHidden = {}, Spheres = {}}
    local function restoreFrozen()
        for obj, props in pairs(state.Frozen) do
            for property, item in pairs(props) do
                pcall(function() if obj.Parent and obj[property] == item.Applied then obj[property] = item.Old end end)
            end
            state.Frozen[obj] = nil
        end
    end
    local function change(obj, prop, value)
        local ok, old = pcall(function() return obj[prop] end)
        if not ok or old == value then return end
        local record = state.Frozen[obj] or {}
        state.Frozen[obj] = record
        if not record[prop] then record[prop] = {Old = old, Applied = value} end
        pcall(function() obj[prop] = value end)
    end
    function session.RestoreExtraEnemies()
        restoreFrozen()
        for obj, original in pairs(state.Hidden) do
            pcall(function() if obj.Parent == nil and original.Parent then obj.Parent = original end end)
            state.Hidden[obj] = nil
        end
        for obj, parent in pairs(state.ClientHidden) do
            pcall(function() if obj.Parent == nil and parent.Parent then obj.Parent = parent end end)
            state.ClientHidden[obj] = nil
        end
        for bullet, sphere in pairs(state.Spheres) do
            pcall(function() sphere:Destroy() end)
            state.Spheres[bullet] = nil
        end
    end
    function session.UpdateExtraEnemies()
        local enemies = workspace:FindFirstChild("Enemies")
        local imp, known = isImpCurseActive()
        if enemies then
            for obj, props in pairs(state.Frozen) do
                local top = obj
                while top and top.Parent and top.Parent ~= enemies do top = top.Parent end
                if top and top.Parent == enemies and isBeaconEnemy(top, imp, known) then
                    for property, record in pairs(props) do
                        pcall(function() if obj.Parent and obj[property] == record.Applied then obj[property] = record.Old end end)
                    end
                    state.Frozen[obj] = nil
                end
            end
        end
        if session.Settings.FreezeEnemies and enemies then
            for _, enemy in ipairs(enemies:GetChildren()) do
                if not isBeaconEnemy(enemy, imp, known) then
                    local humanoid = enemy:FindFirstChildOfClass("Humanoid")
                    if humanoid then change(humanoid, "WalkSpeed", 0); change(humanoid, "PlatformStand", true) end
                    local parts = enemy:GetChildren()
                    if enemy:IsA("BasePart") then table.insert(parts, enemy) end
                    for _, obj in ipairs(parts) do
                        if obj:IsA("BasePart") then change(obj, "Anchored", true); change(obj, "CanCollide", false)
                        elseif obj:IsA("LocalScript") or obj:IsA("Script") then change(obj, "Disabled", true) end
                    end
                end
            end
        else restoreFrozen() end
        for obj, parent in pairs(state.ClientHidden) do
            if not session.Settings.RemoveClientEnemies or not parent.Parent then
                pcall(function() if obj.Parent == nil and parent.Parent then obj.Parent = parent end end)
                state.ClientHidden[obj] = nil
            end
        end
        if session.Settings.RemoveClientEnemies then
            local containers = {}
            if workspace.CurrentCamera then table.insert(containers, workspace.CurrentCamera) end
            local enemyFolder = ReplicatedStorage:FindFirstChild("EnemyFolder")
            if enemyFolder then table.insert(containers, enemyFolder) end
            local names = {nilenemy=true, nilmirage=true, kolona=true, operator=true, scrapmaw=true, skinwalker=true, sigil=true, quartz=true, voidboundicbm=true}
            for _, container in ipairs(containers) do
                for _, obj in ipairs(container:GetChildren()) do
                    if names[string.lower(obj.Name)] and not state.ClientHidden[obj] then
                        local parent = obj.Parent
                        if pcall(function() obj.Parent = nil end) and obj.Parent == nil then state.ClientHidden[obj] = parent end
                    end
                end
            end
        end
        if session.Settings.NukeEnemies then
            local containers = {workspace}
            if enemies then table.insert(containers, enemies) end
            if workspace.CurrentCamera then table.insert(containers, workspace.CurrentCamera) end
            for _, container in ipairs(containers) do
                for _, obj in ipairs(container:GetChildren()) do
                    if enemyCauses[obj.Name] and obj ~= LocalPlayer.Character and not isBeaconEnemy(obj, imp, known) and not keepRestorable(obj) then
                        local playerCharacter = false
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player.Character == obj then playerCharacter = true; break end
                        end
                        if not playerCharacter then pcall(function() obj:Destroy() end) end
                    end
                end
            end
        end
        local function hazard(obj)
            local name = string.lower(obj.Name)
            return (session.Settings.DisableSeaMines and not name:find("trip", 1, true) and (name:find("seamine", 1, true) or name:find("sea_mine", 1, true)))
                or (session.Settings.DisableVoidImplosions and (name:find("voidimplosion", 1, true) or name:find("void_implosion", 1, true)))
                or (session.Settings.DisableFakeBeacons and (name:find("fakebeacon", 1, true) or name:find("fake_beacon", 1, true)))
                or (session.Settings.DisableOblivion and name:find("oblivion", 1, true))
        end
        for obj, parent in pairs(state.Hidden) do
            if not hazard(obj) or not parent.Parent then
                pcall(function() if obj.Parent == nil and parent.Parent then obj.Parent = parent end end)
                state.Hidden[obj] = nil
            end
        end
        if session.Settings.DisableSeaMines or session.Settings.DisableVoidImplosions or session.Settings.DisableFakeBeacons or session.Settings.DisableOblivion then
            local containers = {workspace}
            for _, name in ipairs({"Item_Pools", "Enemies", "Beacons"}) do
                local folder = workspace:FindFirstChild(name)
                if folder then table.insert(containers, folder) end
            end
            for _, container in ipairs(containers) do
                for _, obj in ipairs(container:GetChildren()) do
                    if obj ~= LocalPlayer.Character and hazard(obj) and not state.Hidden[obj] and not isBeaconEnemy(obj, imp, known) then
                        local parent = obj.Parent
                        if pcall(function() obj.Parent = nil end) and obj.Parent == nil then state.Hidden[obj] = parent end
                    end
                end
            end
        end
        local pools = workspace:FindFirstChild("Item_Pools")
        local bullets = pools and pools:FindFirstChild("Bullet")
        for bullet, sphere in pairs(state.Spheres) do
            if not session.Settings.BulletSpheres or not bullets or bullet.Parent ~= bullets or not sphere.Parent then
                pcall(function() sphere:Destroy() end); state.Spheres[bullet] = nil
            else
                pcall(function() sphere.CFrame = bullet:IsA("BasePart") and bullet.CFrame or bullet:GetPivot() end)
            end
        end
        if session.Settings.BulletSpheres and bullets then
            for _, bullet in ipairs(bullets:GetChildren()) do
                if not state.Spheres[bullet] and (bullet:IsA("BasePart") or bullet:IsA("Model")) and not (bullet:IsA("BasePart") and bullet.Transparency == 1) then
                    local size = bullet:IsA("BasePart") and bullet.Size.X or 4
                    local sphere = Instance.new("Part")
                    sphere.Name = "NULL_BulletSphere"
                    sphere.Shape = Enum.PartType.Ball
                    sphere.Size = Vector3.new(size + 6, size + 6, size + 6)
                    sphere.Anchored = true; sphere.CanCollide = true; sphere.CanTouch = false
                    sphere.Color = Color3.fromRGB(255, 50, 50); sphere.Transparency = 0.5
                    local ok = pcall(function() sphere.CFrame = bullet:IsA("BasePart") and bullet.CFrame or bullet:GetPivot(); sphere.Parent = workspace end)
                    if ok then state.Spheres[bullet] = sphere else sphere:Destroy() end
                end
            end
        end
    end
end

do
    local saved
    function session.RestoreGod()
        local current = saved
        saved = nil
        session.GodHumanoid = nil
        session.GodDiedEvent = nil
        if not current then return end
        for _, conn in ipairs(current.Connections) do conn:Disconnect() end
        local h = current.Humanoid
        pcall(function()
            if h.Parent then
                if h.MaxHealth == 1000000 then h.MaxHealth = current.MaxHealth end
                if h.Health > h.MaxHealth then h.Health = h.MaxHealth end
                if h.BreakJointsOnDeath == false then h.BreakJointsOnDeath = current.BreakJoints end
                for stateType, enabled in pairs(current.States) do h:SetStateEnabled(stateType, enabled) end
            end
        end)
    end
    function session.UpdateGod()
        if not session.Active then session.RestoreGod(); return end
        if not session.Settings.GodMode then
            if saved then session.RestoreGod() end
            local events = ReplicatedStorage:FindFirstChild("Events")
            session.GodDiedEvent = events and events:FindFirstChild("Died")
            return
        end
        local character = LocalPlayer.Character
        local h = character and character:FindFirstChildOfClass("Humanoid")
        local events = ReplicatedStorage:FindFirstChild("Events")
        session.GodDiedEvent = events and events:FindFirstChild("Died")
        if not h or h.Health <= 0 then return end
        if saved and saved.Humanoid == h then return end
        session.RestoreGod()
        session.GodDiedEvent = events and events:FindFirstChild("Died")
        local record = {Humanoid = h, MaxHealth = h.MaxHealth, BreakJoints = h.BreakJointsOnDeath, States = {}, Connections = {}}
        for _, st in ipairs({Enum.HumanoidStateType.Dead, Enum.HumanoidStateType.Ragdoll, Enum.HumanoidStateType.FallingDown}) do
            local ok, enabled = pcall(function() return h:GetStateEnabled(st) end)
            if ok then record.States[st] = enabled; pcall(function() h:SetStateEnabled(st, false) end) end
        end
        saved = record
        session.GodHumanoid = h
        pcall(function() h.MaxHealth = 1000000; h.Health = h.MaxHealth; h.BreakJointsOnDeath = false end)
        table.insert(record.Connections, h.HealthChanged:Connect(function(hp)
            if session.Active and session.Settings.GodMode and hp > 0 and hp < h.MaxHealth then
                pcall(function() h.Health = h.MaxHealth end)
            end
        end))
    end
end

local brightValues = {
    Brightness = 3,
    Ambient = Color3.fromRGB(170, 170, 170),
    OutdoorAmbient = Color3.fromRGB(170, 170, 170),
    FogEnd = 100000,
    GlobalShadows = false
}

local brightnessState = {Saved = {}, Connections = {}, Changing = {}}

local function setFullbright(enabled)
    if not enabled then
        for _, connection in ipairs(brightnessState.Connections) do
            connection:Disconnect()
        end
        table.clear(brightnessState.Connections)
        for property, saved in pairs(brightnessState.Saved) do
            pcall(function()
                if Lighting[property] == brightValues[property] then
                    Lighting[property] = saved
                end
            end)
        end
        table.clear(brightnessState.Saved)
        table.clear(brightnessState.Changing)
        return
    end
    if #brightnessState.Connections > 0 then
        return
    end
    for property, value in pairs(brightValues) do
        local key = property
        local forced = value
        local ok, current = pcall(function()
            return Lighting[key]
        end)
        if ok then
            brightnessState.Saved[key] = current
            local connection = Lighting:GetPropertyChangedSignal(key):Connect(function()
                if not session.Active or not session.Settings.Fullbright or brightnessState.Changing[key] then
                    return
                end
                local success, nextValue = pcall(function()
                    return Lighting[key]
                end)
                if success and nextValue ~= forced then
                    brightnessState.Saved[key] = nextValue
                    brightnessState.Changing[key] = true
                    pcall(function()
                        Lighting[key] = forced
                    end)
                    brightnessState.Changing[key] = nil
                end
            end)
            table.insert(brightnessState.Connections, connection)
            brightnessState.Changing[key] = true
            pcall(function()
                Lighting[key] = forced
            end)
            brightnessState.Changing[key] = nil
        end
    end
end

local function clearMarkers()
    for key, marker in pairs(session.Markers) do
        if marker.Part then
            marker.Part:Destroy()
        end
        session.Markers[key] = nil
    end
    if session.MarkerFolder then
        session.MarkerFolder:Destroy()
        session.MarkerFolder = nil
    end
end

local function makeMarker()
    if not session.MarkerFolder then
        local folder = Instance.new("Folder")
        folder.Name = "NULL_HubMarkers"
        folder.Parent = workspace
        session.MarkerFolder = folder
    end
    local part = Instance.new("Part")
    part.Name = "Marker"
    part.Size = Vector3.new(0.1, 0.1, 0.1)
    part.Transparency = 1
    part.Anchored = true
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.CastShadow = false
    part.Parent = session.MarkerFolder
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "Label"
    billboard.Adornee = part
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.fromOffset(180, 30)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.MaxDistance = 750
    billboard.Parent = part
    local text = Instance.new("TextLabel")
    text.BackgroundTransparency = 1
    text.Size = UDim2.fromScale(1, 1)
    text.Font = Enum.Font.GothamBold
    text.TextSize = 13
    text.TextStrokeTransparency = 0.15
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.Parent = billboard
    return {Part = part, Text = text}
end

local giftColors = {
    Gift = Color3.fromRGB(164, 218, 255),
    GoldenGift = Color3.fromRGB(255, 214, 102),
    PassageGift = Color3.fromRGB(255, 172, 92),
    Tripmine = Color3.fromRGB(255, 93, 108)
}

local giftLabels = {
    Gift = "GIFT",
    GoldenGift = "GOLDEN GIFT",
    PassageGift = "PASSAGE GIFT",
    Tripmine = "TRIPMINE"
}

function session.UpdateMarkers()
    local settings = session.Settings
    if not (settings.GiftESP or settings.TripmineESP or settings.EnemyESP) then
        if next(session.Markers) or session.MarkerFolder then
            clearMarkers()
        end
        return
    end
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root or not validPosition(root.Position) then
        clearMarkers()
        return
    end
    local entries = {}
    local handler = session.GiftHandler
    if handler and type(handler.Gifts) == "table" and (settings.GiftESP or settings.TripmineESP) then
        for _, gift in pairs(handler.Gifts) do
            local mine = isMine(gift)
            if not gift.Destroyed and not gift.Collected and validPosition(gift.Position)
                and ((mine and settings.TripmineESP) or (not mine and settings.GiftESP and isGift(gift))) then
                local distance = (gift.Position - root.Position).Magnitude
                if distance <= 700 then
                    local giftType = mine and "Tripmine" or gift.Type
                    table.insert(entries, {
                        Key = gift,
                        Position = gift.Position,
                        Distance = distance,
                        Label = giftLabels[giftType] or "GIFT",
                        Color = giftColors[giftType] or giftColors.Gift
                    })
                end
            end
        end
    end
    if settings.EnemyESP then
        local folder = workspace:FindFirstChild("Enemies")
        if folder then
            for _, enemy in ipairs(folder:GetChildren()) do
                local ok, position = pcall(instancePosition, enemy)
                if ok and validPosition(position) then
                    local distance = (position - root.Position).Magnitude
                    if distance <= 700 then
                        table.insert(entries, {
                            Key = enemy,
                            Position = position,
                            Distance = distance,
                            Label = string.upper(enemy.Name),
                            Color = Color3.fromRGB(255, 126, 146)
                        })
                    end
                end
            end
        end
    end
    table.sort(entries, function(a, b)
        return a.Distance < b.Distance
    end)
    local used = {}
    for index = 1, math.min(#entries, 120) do
        local entry = entries[index]
        used[entry.Key] = true
        local marker = session.Markers[entry.Key]
        if not marker or not marker.Part.Parent then
            marker = makeMarker()
            session.Markers[entry.Key] = marker
        end
        marker.Part.Position = entry.Position
        marker.Text.Text = string.format("%s  [%d]", entry.Label, math.floor(entry.Distance + 0.5))
        marker.Text.TextColor3 = entry.Color
    end
    for key, marker in pairs(session.Markers) do
        if not used[key] then
            marker.Part:Destroy()
            session.Markers[key] = nil
        end
    end
end


local function shopPolicyAllows(choiceType)
    local policy = session.Settings.ShopPolicy or 1
    if policy == 4 then
        return true
    end
    if choiceType == "UPGRADES" or choiceType == "WINGS" then
        return true
    end
    if policy == 2 then
        return choiceType == "DELUSIONS"
    end
    if policy == 3 then
        return choiceType ~= "CURSES" and choiceType ~= "GREATER CURSES" and choiceType ~= "ENEMIES"
    end
    return false
end

local function shopBalance()
    local handler = session.InventoryHandler
    if not handler or type(handler.GetTripcoins) ~= "function" then
        return nil
    end
    local ok, value = pcall(handler.GetTripcoins)
    if ok and type(value) == "number" then
        return value
    end
    return nil
end

local function releaseShopHold()
    local prompt = session.Shop.Holding
    session.Shop.Holding = nil
    if prompt then
        pcall(function()
            prompt:InputHoldEnd()
        end)
    end
end

local function shopPromptOf(orb)
    local candidates = orb:GetDescendants()
    table.insert(candidates, 1, orb)
    local parent = orb.Parent
    if parent and parent ~= workspace then
        for _, candidate in ipairs(parent:GetDescendants()) do
            if candidate:IsA("ProximityPrompt") and not candidate:IsDescendantOf(orb) then
                table.insert(candidates, candidate)
            end
        end
    end
    for _, candidate in ipairs(candidates) do
        if candidate:IsA("ProximityPrompt") and isPromptAvailable(candidate) then
            return candidate
        end
    end
    return nil
end

local function shopWallet(currency)
    local name = type(currency) == "string" and string.lower(currency) or "goldengifts"
    if name == "tripcoins" then
        local handler = session.InventoryHandler
        if not handler or type(handler.GetTripcoins) ~= "function" then
            return nil
        end
        local ok, value = pcall(handler.GetTripcoins)
        if ok and type(value) == "number" and value == value then
            return value
        end
        return nil
    end
    if string.find(name, "golden", 1, true) then
        local object = ReplicatedStorage:FindFirstChild("GoldenGifts")
        local value = object and object.Value
        if type(value) == "number" and value == value then
            return value
        end
    end
    return nil
end

local function shopCostAllowed(prompt)
    local cost = prompt:GetAttribute("Cost")
    if type(cost) ~= "number" or cost ~= cost or cost < 0 then
        cost = 0
    end
    local currency = prompt:GetAttribute("CurrencyType")
    local coins = type(currency) == "string" and string.lower(currency) == "tripcoins"
    local wallet = shopWallet(currency)
    if wallet and cost > wallet then
        return nil
    end
    local maxPrice = session.Settings.ShopMaxPrice or 0
    if coins and maxPrice > 0 and cost > maxPrice then
        return nil
    end
    local reserve = session.Settings.ShopReserve or 0
    if coins and wallet and reserve > 0 and wallet - cost < reserve then
        return nil
    end
    return cost
end

local function shopVoteRemote()
    local cached = session.Shop.VoteRemote
    if cached ~= nil then
        return cached or nil
    end
    local events = ReplicatedStorage:FindFirstChild("Events")
    local remote = events and (events:FindFirstChild("Vote") or events:FindFirstChild("SelectVote"))
    if remote and remote:IsA("RemoteEvent") then
        session.Shop.VoteRemote = remote
        return remote
    end
    session.Shop.VoteRemote = false
    return nil
end

local function shopBoardSignature()
    local folder = workspace:FindFirstChild("Select")
    if not folder then
        return "", 0
    end
    local names, offered = {}, 0
    for _, slot in ipairs({"1", "2", "3"}) do
        local part = folder:FindFirstChild(slot)
        local name = part and tostring(part:GetAttribute("ChoiceName") or "") or ""
        if name ~= "" then
            offered += 1
        end
        names[#names + 1] = name
    end
    return table.concat(names, "|"), offered
end

local shopSelect = {
    Failed = {},
    Rerolls = 0,
    Picks = 0,
    Processing = false,
    StartedAt = 0,
    Signature = "",
    Offered = 0,
    PendingChange = false,
    PendingReroll = false,
    PendingUntil = 0
}

local function shopResetVisit()
    shopSelect.Failed = {}
    shopSelect.Rerolls = 0
    shopSelect.Picks = 0
    shopSelect.PendingChange = false
    shopSelect.PendingReroll = false
    shopSelect.PendingUntil = 0
    session.Shop.Skipped = false
    session.Shop.SkipReason = ""
end

function session.ResetShopSelect()
    shopResetVisit()
    shopSelect.Signature = ""
    shopSelect.Offered = 0
end

local function shopPartAffordable(part)
    local prompt = shopPromptOf(part)
    if not prompt then
        return true
    end
    return shopCostAllowed(prompt) ~= nil
end

local function shopOfferOf(part)
    local choiceType = part:GetAttribute("ChoiceType")
    local choiceName = part:GetAttribute("ChoiceName")
    if type(choiceType) ~= "string" or type(choiceName) ~= "string" or choiceName == "" then
        return nil
    end
    return choiceType, choiceName
end

local function shopNormalizeText(value)
    if type(value) ~= "string" then
        return ""
    end
    return string.gsub(string.lower(value), "[%s%p]", "")
end

local function shopIsMedalCurse(choiceName)
    return string.find(shopNormalizeText(choiceName), "medalcurse", 1, true) ~= nil
end

local function shopPartWanted(part)
    local choiceType = shopOfferOf(part)
    if not choiceType then
        return false
    end
    if not shopPolicyAllows(choiceType) then
        return false
    end
    return shopPartAffordable(part)
end

local function shopAnyAffordable(folder)
    for _, slot in ipairs({"1", "2", "3"}) do
        local part = folder:FindFirstChild(slot)
        if part and shopOfferOf(part) and shopPartAffordable(part) then
            return true
        end
    end
    return false
end

local function interactWithShopPart(part)
    if not part or not part:IsA("BasePart") then
        return
    end
    local character = LocalPlayer.Character
    local root = character and (character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart)
    if not root then
        local _, stateRoot = characterState()
        root = stateRoot
    end
    if root then
        local destination = part.CFrame + Vector3.new(0, 3, 0)
        for _ = 1, 8 do
            pcall(function()
                root.CFrame = destination
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end)
            task.wait(0.05)
            local okDistance, distance = pcall(function()
                return (root.Position - part.Position).Magnitude
            end)
            if okDistance and type(distance) == "number" and distance <= 12 then
                break
            end
        end
    end
    pcall(function()
        local input = game:GetService("VirtualInputManager")
        input:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.05)
        input:SendKeyEvent(false, Enum.KeyCode.F, false, game)
    end)
    local closest, shortest = nil, 10
    local scope = part.Parent or workspace
    for _, prompt in ipairs(scope:GetChildren()) do
        if prompt:IsA("ProximityPrompt") and prompt.Parent and prompt.Parent:IsA("BasePart") then
            local distance = (prompt.Parent.Position - part.Position).Magnitude
            if distance < shortest then
                closest, shortest = prompt, distance
            end
        end
    end
    if closest then
        pcall(function()
            if type(fireproximityprompt) == "function" then
                fireproximityprompt(closest)
            else
                closest:InputHoldBegin()
                task.wait(closest.HoldDuration)
                closest:InputHoldEnd()
            end
        end)
    end
    local remote = shopVoteRemote()
    if remote then
        pcall(function()
            remote:FireServer(part.Name)
        end)
    end
end

local function shopMarkPending(reroll)
    shopSelect.PendingChange = true
    shopSelect.PendingReroll = reroll == true
    shopSelect.PendingUntil = time() + 8
end

function session.UpdateShop()
    if not session.Active or not session.Settings.AutoShop then
        if session.Shop.Holding then
            releaseShopHold()
        end
        shopSelect.Processing = false
        session.Shop.Busy = false
        return
    end
    if shopSelect.Processing and time() - (shopSelect.StartedAt or 0) > 45 then
        shopSelect.Processing = false
        session.Shop.Busy = false
    end
    if shopSelect.Processing then
        return
    end
    local signature, offered = shopBoardSignature()
    if offered == 0 then
        session.ResetShopSelect()
        return
    end
    local now = time()
    if shopSelect.PendingChange and now >= shopSelect.PendingUntil then
        shopSelect.PendingChange = false
        shopSelect.PendingReroll = false
    end
    if signature ~= shopSelect.Signature then
        if shopSelect.PendingChange then
            local rerolled = shopSelect.PendingReroll
            shopSelect.PendingChange = false
            shopSelect.PendingReroll = false
            shopSelect.Failed = {}
            if rerolled then
                session.Shop.Skipped = false
            end
        else
            shopResetVisit()
        end
        shopSelect.Signature = signature
    end
    if offered > shopSelect.Offered and not shopSelect.PendingChange then
        shopResetVisit()
    end
    shopSelect.Offered = offered
    shopSelect.Processing = true
    shopSelect.StartedAt = time()
    session.Shop.Busy = true
    task.spawn(function()
        local okRun, runError = pcall(function()
        local maxIterations = 25
        local iteration = 0
        local acted = false
        local mandatorySeen = false
        local function boardState()
            local folder = workspace:FindFirstChild("Select")
            if not folder then
                return ""
            end
            local first = folder:FindFirstChild("1")
            local second = folder:FindFirstChild("2")
            return (first and tostring(first:GetAttribute("ChoiceName")) or "") .. "|" .. (second and tostring(second:GetAttribute("ChoiceName")) or "")
        end
        local function attemptBuy(partName)
            local attempts = 0
            local initial = boardState()
            while attempts < 4 and session.Active and session.Settings.AutoShop do
                local folder = workspace:FindFirstChild("Select")
                if not folder then
                    return true
                end
                local part = folder:FindFirstChild(partName)
                if not part then
                    return true
                end
                interactWithShopPart(part)
                attempts += 1
                if attempts < 4 then
                    task.wait(1.5)
                end
                local current = boardState()
                if partName == "Reroll" then
                    if current ~= initial then
                        return true
                    end
                elseif not folder:FindFirstChild(partName) or current ~= initial then
                    return true
                end
            end
            shopSelect.Failed[partName] = true
            return false
        end
        local function recordPick(slot, name)
            acted = true
            session.Shop.Skipped = false
            shopMarkPending(false)
            session.Shop.Picks += 1
            if name ~= "" then
                session.Shop.LastPick = name
            end
        end
        while session.Active and session.Settings.AutoShop and iteration < maxIterations do
            iteration += 1
            local folder = workspace:FindFirstChild("Select")
            if not folder then
                break
            end
            local _, offeredNow = shopBoardSignature()
            if offeredNow == 0 then
                break
            end

            local rerollPart = folder:FindFirstChild("Reroll")
            local part3 = folder:FindFirstChild("3")
            local restrictive = (session.Settings.ShopPolicy or 1) ~= 4
            local mandatory = false
            for _, name in ipairs({"1", "2"}) do
                local part = folder:FindFirstChild(name)
                local upper = part and string.upper(tostring(part:GetAttribute("ChoiceType") or "")) or ""
                if string.find(upper, "CURSE", 1, true) or string.find(upper, "ENEM", 1, true) then
                    mandatory = true
                    break
                end
            end
            mandatorySeen = mandatorySeen or mandatory
            local target = nil
            for _, name in ipairs({"1", "2"}) do
                if not shopSelect.Failed[name] then
                    local part = folder:FindFirstChild(name)
                    if part and shopPartAffordable(part) and shopIsMedalCurse(tostring(part:GetAttribute("ChoiceName") or "")) then
                        target = name
                        break
                    end
                end
            end
            if not target then
                for _, name in ipairs({"1", "2"}) do
                    if not shopSelect.Failed[name] then
                        local part = folder:FindFirstChild(name)
                        if part and shopPartWanted(part) then
                            target = name
                            break
                        end
                    end
                end
            end
            if not target and not restrictive then
                local valid = {}
                for _, name in ipairs({"1", "2"}) do
                    if not shopSelect.Failed[name] and folder:FindFirstChild(name) then
                        table.insert(valid, name)
                    end
                end
                if #valid > 0 then
                    target = valid[math.random(1, #valid)]
                end
            end
            if target then
                local slot = target
                local targetPart = folder:FindFirstChild(slot)
                local targetName = targetPart and tostring(targetPart:GetAttribute("ChoiceName") or "") or ""
                if attemptBuy(slot) then
                    recordPick(slot, targetName)
                end
            else
                if rerollPart and restrictive and not mandatory and shopSelect.Rerolls < (session.Settings.ShopMaxRerolls or 0)
                    and not shopSelect.Failed["Reroll"] and shopPartAffordable(rerollPart) then
                    if attemptBuy("Reroll") then
                        acted = true
                        session.Shop.Skipped = false
                        shopSelect.Rerolls += 1
                        shopSelect.Failed["1"], shopSelect.Failed["2"] = nil, nil
                        shopMarkPending(true)
                        shopSelect.Signature = shopBoardSignature()
                        continue
                    end
                end
                if mandatory then
                    if part3 and not shopSelect.Failed["3"] and shopPartAffordable(part3) then
                        local thirdName = tostring(part3:GetAttribute("ChoiceName") or "")
                        if attemptBuy("3") then
                            recordPick("3", thirdName)
                            shopSelect.Signature = shopBoardSignature()
                            continue
                        end
                    end
                    local valid = {}
                    for _, name in ipairs({"1", "2"}) do
                        local candidate = folder:FindFirstChild(name)
                        if not shopSelect.Failed[name] and candidate and shopPartAffordable(candidate) then
                            table.insert(valid, name)
                        end
                    end
                    if #valid > 0 then
                        local slot = valid[math.random(1, #valid)]
                        local slotPart = folder:FindFirstChild(slot)
                        local pickedName = slotPart and tostring(slotPart:GetAttribute("ChoiceName") or "") or ""
                        if attemptBuy(slot) then
                            recordPick(slot, pickedName)
                            shopSelect.Signature = shopBoardSignature()
                            continue
                        end
                    end
                end
                if part3 and not shopSelect.Failed["3"] and shopPartAffordable(part3) then
                    local thirdName = tostring(part3:GetAttribute("ChoiceName") or "")
                    if attemptBuy("3") then
                        recordPick("3", thirdName)
                    end
                end
                break
            end
            shopSelect.Signature = shopBoardSignature()
        end
        if acted then
            session.Shop.Skipped = false
            session.Shop.SkipReason = ""
        else
            local folder = workspace:FindFirstChild("Select")
            if folder then
                session.Shop.SkipReason = mandatorySeen and "all picks rejected" or (shopAnyAffordable(folder) and "nothing wanted" or "no coins")
                session.Shop.Skipped = true
            end
        end
        end)
        if not okRun then
            warn("[Ixa Hub] shop pass error: " .. tostring(runError))
        end
        shopSelect.Processing = false
        session.Shop.Busy = false
    end)
end


local function applyFullAuto(value)
    local bundle = {"AutoPortal", "AutoPurgatory", "AutoAltars", "AntiMobDamage", "AutoMedal", "AutoStarMart", "RazorbloomBypass", "AutoShop", "AutoReroll", "AutoRestart", "GodMode", "GuardianProtection", "ShadowGuardianProtection", "AntiVoid", "RemoveAllEnemies", "FreezeEnemies", "DisableSeaMines", "DisableVoidImplosions", "DisableFakeBeacons", "DisableOblivion", "BulletSpheres"}
    if value then
        if not session.FullAutoSaved then
            local saved = {}
            for _, key in ipairs(bundle) do
                saved[key] = session.Settings[key] == true
            end
            saved.Farm = session.Settings.RageFarm or session.Settings.FastFlyFarm or session.Settings.GiftReach
            session.FullAutoSaved = saved
        end
        for _, key in ipairs(bundle) do
            session.SetOption(key, true)
        end
        if not session.FullAutoSaved.Farm then
            session.SetOption("FastFlyFarm", true)
        end
    else
        local saved = session.FullAutoSaved
        session.FullAutoSaved = nil
        if saved then
            for _, key in ipairs(bundle) do
                session.SetOption(key, saved[key] == true)
            end
            if not saved.Farm and session.Settings.FastFlyFarm then
                session.SetOption("FastFlyFarm", false)
            end
        end
    end
end

function session.SetOption(name, value)
    if not session.Active or type(session.Settings[name]) ~= "boolean" then
        return false
    end
    value = value == true
    if (name == "AntiMobDamage" or name == "GodMode" or name == "GuardianProtection" or name == "ShadowGuardianProtection") and value and not attachProtection() then
        session.Notify("Remote protection unavailable")
    end
    local changed = session.Settings[name] ~= value
    session.Settings[name] = value
    if changed and (name == "RageFarm" or name == "FastFlyFarm") then
        if value then
            for _, other in ipairs({"RageFarm", "FastFlyFarm"}) do
                if other ~= name and session.Settings[other] then
                    session.Settings[other] = false
                end
            end
        end
        session.ResetFastFly()
        session.ResetReach()
        resetRage()
        if session.Settings.RageFarm or session.Settings.FastFlyFarm then
            updatePortalGate(false)
        else
            releasePortalGate()
        end
        session.Rage.GiftSkip = setmetatable({}, {__mode = "k"})
        session.Rage.Failures = 0
        session.Rage.NextAltar = 0
        session.Rage.RejectCount = 0
        session.Rage.LastReject = 0
        session.Rage.NextRecovery = 0
        session.Rage.ExtraSettle = 0
        session.Rage.NextSpeedDecay = 0
        session.Rage.StuckSince = setmetatable({}, {__mode = "k"})
        session.Attempts = setmetatable({}, {__mode = "k"})
        releasePromptHold()
        session.Altars.Goal = nil
        session.Altars.Goals = setmetatable({}, {__mode = "k"})
        session.Altars.NextScan = 0
    elseif changed and name == "AutoPortal" then
        local hadGifts, currentLevel = session.Portal.HadGifts, session.Portal.Level
        resetRage()
        session.Portal.HadGifts = hadGifts
        session.Portal.Level = currentLevel
        updatePortalGate(false)
    elseif changed and (name == "AutoPurgatory" or name == "AutoAltars" or string.sub(name, 1, 6) == "Altar_") then
        local state = session.Altars
        if state.Goal and not altarEnabled(state.Goal.Name) then
            local goal = state.Goal
            state.Goal = nil
            state.Close = false
            releasePromptHold()
            if session.Rage.Target == goal then
                resetRage()
            end
        end
        state.NextScan = 0
        maybeVoteAltar()
    elseif changed and (name == "RemoveAllEnemies" or name == "StrongEnemyRemoval" or string.sub(name, 1, 12) == "RemoveEnemy_") then
        if string.sub(name, 1, 12) == "RemoveEnemy_" then
            session.EnemyRemoval.Selected[string.sub(name, 13)] = value or nil
        end
        session.UpdateEnemyRemoval()
    elseif changed and name == "GiftReach" then
        session.ResetReach()
    elseif changed and name == "AutoMedal" then
        session.ResetMedal()
        if value then session.UpdateMedals() end
    elseif changed and name == "AutoStarMart" then
        session.ResetStarMart()
        if value then session.UpdateStarMart() end
    elseif changed and name == "RazorbloomBypass" then
        if value then session.UpdateRazorbloom() else session.ResetRazorbloom() end
    elseif changed and name == "AntiVoid" then
        if not value then session.ResetAntiVoid() end
    elseif changed and name == "AntiMobDamage" then
        if value then
            updateLocalProtection()
        else
            restoreLocalProtection()
        end
    elseif changed and name == "GodMode" then
        if value then session.UpdateGod() else session.RestoreGod() end
    elseif changed and (name == "NukeEnemies" or name == "RemoveClientEnemies" or name == "FreezeEnemies" or name == "DisableSeaMines" or name == "DisableVoidImplosions" or name == "DisableFakeBeacons" or name == "DisableOblivion" or name == "BulletSpheres") then
        session.UpdateExtraEnemies()
    elseif changed and name == "Fullbright" then
        setFullbright(value)
    elseif changed and name == "FullAutoGame" then
        applyFullAuto(value)
    elseif changed and name == "AutoShop" then
        if not value then
            releaseShopHold()
            session.Shop.Busy = false
        end
    end
    if changed and (name == "GiftESP" or name == "TripmineESP" or name == "EnemyESP") then
        pcall(session.UpdateMarkers)
    end
    return value
end

function session.Notify(message)
    warn("[Ixa Hub] " .. tostring(message))
end

local function makeSection(page, name, side)
    local section = page:CreateGroupbox({Name = name, Side = side or "Left"})
    ensureAliases(section)
    return section
end
local FarmMain = makeSection(FarmPage, "Gift Farming", "Left")
local FarmOptions = makeSection(FarmPage, "Collection Options", "Right")
local AltarOptions = makeSection(AltarsPage, "Altar Automation", "Left")
local SurvivalMain = makeSection(SurvivalPage, "Protection", "Left")
local SurvivalExtra = makeSection(SurvivalPage, "Movement & Bypass", "Right")
local EnemyMain = makeSection(EnemiesPage, "Enemy Controls", "Left")
local EnemyRemoval = makeSection(EnemiesPage, "Selective Removal", "Right")
local VisualsMain = makeSection(VisualsPage, "Markers & Lighting", "Left")
local SettingsMain = makeSection(SettingsPage, "Session", "Left")
local AutoMain = makeSection(AutoGamePage, "Full Auto", "Left")
local AutoShopSection = makeSection(AutoGamePage, "Shop Automation", "Right")

local function addToggle(section, title, key, callbackOverride)
    return section:Toggle({
        Name = title,
        Flag = "NULL_" .. key,
        Default = session.Settings[key] == true,
        Callback = callbackOverride or function(value)
            session.SetOption(key, value)
        end,
    })
end
local function addSlider(section, title, key, minimum, maximum, defaultValue, suffix, increment, callback)
    return section:Slider({
        Name = title,
        Flag = "NULL_" .. key,
        Min = minimum,
        Max = maximum,
        Default = defaultValue,
        Suffix = suffix,
        Increment = increment or 1,
        Callback = callback or function(value)
            if type(value) == "number" then session.Settings[key] = value end
        end,
    })
end

addToggle(FarmMain, "Rage Auto Farm", "RageFarm")
addToggle(FarmMain, "Fast Fly Farm", "FastFlyFarm")
addToggle(FarmMain, "Auto Medal", "AutoMedal")
addToggle(FarmMain, "Auto StarMart", "AutoStarMart")
addToggle(FarmMain, "Auto Portal", "AutoPortal")
addToggle(FarmOptions, "Golden Gifts First", "GoldenFirst")
addToggle(FarmOptions, "Gift Reach", "GiftReach")
addSlider(FarmOptions, "Reach Distance", "ReachDistance", 4, 45, session.Settings.ReachDistance, " studs", 1,
    function(value) session.Settings.ReachDistance = math.clamp(math.floor((tonumber(value) or 45) + 0.5), 4, 45); session.ResetReach() end)

addToggle(AltarOptions, "Use Purgatory", "AutoPurgatory")
addToggle(AltarOptions, "Auto Selected Altars", "AutoAltars")
for _, altarName in ipairs(altarNames) do
    if altarName ~= "Purgatory" then
        local title = altarName == "Revival" and "Revive / Revival" or altarName
        addToggle(AltarOptions, "Use " .. title, "Altar_" .. altarName)
    end
end

addToggle(SurvivalMain, "Anti Mob Damage", "AntiMobDamage")
addToggle(SurvivalMain, "God Mode (experimental)", "GodMode")
addToggle(SurvivalMain, "Guardian Immunity", "GuardianProtection")
addToggle(SurvivalMain, "Shadow Guardian Immunity", "ShadowGuardianProtection")
addToggle(SurvivalMain, "Bullet Protection Spheres", "BulletSpheres")
addToggle(SurvivalExtra, "Avoid Enemies", "AvoidEnemies")
addToggle(SurvivalExtra, "Anti Void", "AntiVoid")
SurvivalExtra:Dropdown({
    Name = "Anti Void Mode", Flag = "NULL_AntiVoidMode",
    Default = ({"Spawn", "Launch Up", "Closest Gift"})[session.Settings.AntiVoidMode] or "Spawn",
    Options = {"Spawn", "Launch Up", "Closest Gift"},
    Callback = function(value)
        local modes = {Spawn = 1, ["Launch Up"] = 2, ["Closest Gift"] = 3}
        if modes[value] then session.Settings.AntiVoidMode = modes[value] end
    end,
})
addSlider(SurvivalExtra, "Anti Void Launch Power", "AntiVoidPower", 10, 1000, session.Settings.AntiVoidPower, "", 1,
    function(value) session.Settings.AntiVoidPower = math.clamp(math.floor((tonumber(value) or 500) + 0.5), 10, 1000) end)
addToggle(SurvivalExtra, "Razorbloom Bypass", "RazorbloomBypass")

addToggle(EnemyMain, "Remove All Enemies", "RemoveAllEnemies")
addToggle(EnemyMain, "Strong Selected Removal", "StrongEnemyRemoval")
addToggle(EnemyMain, "Hide Client Enemies", "RemoveClientEnemies")
addToggle(EnemyMain, "Freeze Enemy AI (local)", "FreezeEnemies")
addToggle(EnemyMain, "NUKE Known Enemies (local)", "NukeEnemies")
addToggle(EnemyMain, "Hide Sea Mines", "DisableSeaMines")
addToggle(EnemyMain, "Hide Void Implosions", "DisableVoidImplosions")
addToggle(EnemyMain, "Hide Fake Beacons", "DisableFakeBeacons")
addToggle(EnemyMain, "Hide Oblivion", "DisableOblivion")
addToggle(VisualsMain, "Gift ESP", "GiftESP")
addToggle(VisualsMain, "Tripmine ESP", "TripmineESP")
addToggle(VisualsMain, "Enemy ESP", "EnemyESP")
addToggle(VisualsMain, "Fullbright", "Fullbright")

addToggle(AutoMain, "Full Auto Game", "FullAutoGame")
addToggle(AutoMain, "Auto Shop Items", "AutoShop")
addToggle(AutoMain, "Auto Reroll Bad Offers", "AutoReroll")
addToggle(AutoMain, "Auto Continue After Death", "AutoRestart")
local shopStatus = AutoMain:Label({Name = "Tripcoins: unknown · Picks: 0"})
AutoShopSection:Dropdown({
    Name = "Shop Policy",
    Flag = "NULL_ShopPolicy",
    Default = ({"Upgrades Only", "Upgrades + Delusions", "No Curses", "Everything"})[session.Settings.ShopPolicy] or "Upgrades Only",
    Options = {"Upgrades Only", "Upgrades + Delusions", "No Curses", "Everything"},
    Callback = function(value)
        local modes = {["Upgrades Only"] = 1, ["Upgrades + Delusions"] = 2, ["No Curses"] = 3, ["Everything"] = 4}
        if modes[value] then
            session.Settings.ShopPolicy = modes[value]
            session.ResetShopSelect()
        end
    end,
})
addSlider(AutoShopSection, "Max Item Price", "ShopMaxPrice", 0, 30000, session.Settings.ShopMaxPrice, " coins", 50,
    function(value) session.Settings.ShopMaxPrice = math.clamp(math.floor((tonumber(value) or 0) + 0.5), 0, 30000); session.ResetShopSelect() end)
addSlider(AutoShopSection, "Keep Reserve", "ShopReserve", 0, 5000, session.Settings.ShopReserve, " coins", 50,
    function(value) session.Settings.ShopReserve = math.clamp(math.floor((tonumber(value) or 0) + 0.5), 0, 5000); session.ResetShopSelect() end)
addSlider(AutoShopSection, "Max Rerolls Per Shop", "ShopMaxRerolls", 0, 5, session.Settings.ShopMaxRerolls, "", 1,
    function(value) session.Settings.ShopMaxRerolls = math.clamp(math.floor((tonumber(value) or 0) + 0.5), 0, 5) end)
task.spawn(function()
    while session.Active do
        if shopStatus then
            local balance = shopBalance()
            local parts = {"Tripcoins: " .. (balance and tostring(math.floor(balance)) or "unknown"), "Picks: " .. tostring(session.Shop.Picks)}
            if session.Shop.LastPick ~= "" then
                table.insert(parts, "Last: " .. session.Shop.LastPick)
            end
            if session.Shop.Skipped then
                local reason = session.Shop.SkipReason ~= "" and session.Shop.SkipReason or "nothing wanted"
                table.insert(parts, "Skipped: " .. reason)
            end
            local text = table.concat(parts, " · ")
            pcall(function() shopStatus:SetText(text) end)
        end
        task.wait(1)
    end
end)

function session.AddEnemyOption(name)
    if type(name) ~= "string" or name == "" or #name > 80 or session.EnemyRemoval.Names[name] then return end
    local state = session.EnemyRemoval
    local key = "RemoveEnemy_" .. name
    state.Names[name] = key
    state.Count = (state.Count or 0) + 1
    local enabled = name == "Mart"
    session.Settings[key] = enabled
    if enabled then state.Selected[name] = true end
    addToggle(EnemyRemoval, "Remove " .. name, key)
end

local enemyNames = {}
for name in pairs(enemyCauses) do enemyNames[name] = true end
local enemyIndex = findPath(ReplicatedStorage, {"SharedModules", "Core", "Index", "EnemyIndex"})
if enemyIndex then
    for _, child in ipairs(enemyIndex:GetChildren()) do enemyNames[child.Name] = true end
end
local sortedEnemies = {}
for name in pairs(enemyNames) do table.insert(sortedEnemies, name) end
table.sort(sortedEnemies, function(a, b) return string.lower(a) < string.lower(b) end)
for _, name in ipairs(sortedEnemies) do session.AddEnemyOption(name) end

SettingsMain:Button({Name = "Unload Ixa Hub", Callback = function() session:Unload() end})
SettingsPage:CreateConfigManager({Name = "Configs", Side = "Left"})
SettingsPage:CreateThemeManager({Name = "Theme", Side = "Right"})
if Window.LoadAutoload then
    task.defer(function() pcall(function() Window:LoadAutoload() end) end)
end

connect(ProximityPromptService.PromptShown, function(prompt)
    if session.Active and altarNameFromPrompt(prompt) then
        session.Altars.Shown[prompt] = true
        session.Altars.NextScan = 0
    end
end)
connect(ProximityPromptService.PromptHidden, function(prompt)
    session.Altars.Shown[prompt] = nil
    session.Altars.NextScan = 0
end)

local function onCharacterChanged()
    session.ResetReach()
    session.ResetStarMart()
    session.ResetRazorbloom()
    session.ResetMedal()
    session.ResetAntiVoid()
    session.ResetFastFly()
    session.RestoreGod()
    resetRage()
    session.Rage.GiftSkip = setmetatable({}, {__mode = "k"})
    session.Rage.Failures = 0
    session.Rage.NextAltar = 0
    session.Rage.RejectCount = 0
    session.Rage.LastReject = 0
    session.Rage.NextRecovery = 0
    session.Rage.ExtraSettle = 0
    session.Rage.NextSpeedDecay = 0
    session.Rage.StuckSince = setmetatable({}, {__mode = "k"})
    restoreLocalProtection()
    releasePromptHold()
    releaseShopHold()
    session.ResetShopSelect()
    shopSelect.Processing = false
    session.Shop.Busy = false
    session.Altars.Goal = nil
    session.Altars.Close = false
    session.Altars.NextScan = 0
    session.Altars.Goals = setmetatable({}, {__mode = "k"})
    session.Altars.PromptAttempts = setmetatable({}, {__mode = "k"})
    session.Altars.Skip = setmetatable({}, {__mode = "k"})
    session.Attempts = setmetatable({}, {__mode = "k"})
    clearMarkers()
end
connect(LocalPlayer.CharacterAdded, onCharacterChanged)
connect(LocalPlayer.CharacterRemoving, onCharacterChanged)

session.CharacterState = characterState
session.IsGift = isGift
session.IsMine = isMine
session.UpdateLocalProtection = updateLocalProtection
session.SetOption("AntiMobDamage", true)


function session:Unload()
    if not self.Active then return end
    self.Active = false
    for _, key in ipairs({"RageFarm", "FastFlyFarm", "AutoMedal", "AutoStarMart", "RazorbloomBypass", "GodMode", "GiftReach", "AutoPurgatory", "AutoAltars", "AntiMobDamage", "AntiVoid", "AutoRestart"}) do
        self.Settings[key] = false
    end
    session.ResetReach()
    session.ResetMedal()
    session.ResetStarMart()
    session.ResetRazorbloom()
    session.ResetAntiVoid()
    releasePromptHold()
    releaseShopHold()
    session.ResetShopSelect()
    session.ResetFastFly()
    session.RestoreGod()
    session.RestoreExtraEnemies()
    resetRage()
    disconnectEnemyFolder()
    restoreAllEnemies()
    restoreLocalProtection()
    setFullbright(false)
    clearMarkers()
    if self.HookRecord and self.HookRecord.Owner == self then self.HookRecord.Owner = nil end
    for _, connection in ipairs(self.Connections) do pcall(function() connection:Disconnect() end) end
    table.clear(self.Connections)
    pcall(function() if Window then Window:Destroy() end end)
    if environment.__NULL_HUB_SESSION == self then environment.__NULL_HUB_SESSION = nil end
    environment.__NULL_HUB_WINDOW = nil
end

task.spawn(function()
    while session.Active do
        if not session.GiftHandler then
            local module = findPath(ReplicatedFirst, {"ClientModules", "GiftClient", "GiftClientHandler"})
            if module then
                local ok, handler = pcall(require, module)
                if session.Active and ok and type(handler) == "table" and type(handler.Gifts) == "table" then
                    session.GiftHandler = handler
                end
            end
        end
        task.wait(session.GiftHandler and 5 or 1)
    end
end)

task.spawn(function()
    while session.Active and not session.CurseHandler do
        local module = findPath(ReplicatedFirst, {"ClientModules", "CurseHandler"})
        if module then
            local ok, handler = pcall(require, module)
            if session.Active and ok and type(handler) == "table" and type(handler.IsCurseEnabled) == "function" then
                session.CurseHandler = handler
                break
            end
        end
        task.wait(1)
    end
end)

task.spawn(function()
    local events = ReplicatedStorage:WaitForChild("Events", 20)
    local remote = events and events:WaitForChild("EndScreen", 20)
    if not remote or not session.Active then
        return
    end
    connect(remote.OnClientEvent, function(token)
        if not session.Active or not session.Settings.AutoRestart then
            return
        end
        task.delay(0.75, function()
            if not session.Active or not session.Settings.AutoRestart then
                return
            end
            pcall(function()
                remote:FireServer(token)
            end)
            pcall(function()
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                local screen = playerGui and playerGui:FindFirstChild("EndScreen")
                if screen then
                    screen.Enabled = false
                end
                local gui = playerGui and playerGui:FindFirstChild("GUI")
                if gui then
                    gui.Enabled = true
                end
            end)
        end)
    end)
end)

task.spawn(function()
    while session.Active and not session.InventoryHandler do
        local module = findPath(ReplicatedFirst, {"ClientModules", "Core", "PlayerData", "InventoryHandler"})
        if module then
            local ok, handler = pcall(require, module)
            if session.Active and ok and type(handler) == "table" and type(handler.GetTripcoins) == "function" then
                session.InventoryHandler = handler
            end
        end
        task.wait(1)
    end
end)

task.spawn(function()
    local nextAltarError = 0
    local nextProtectionError = 0
    local nextEnemyError = 0
    local nextShopError = 0
    while session.Active do
        local okAltar, altarError = pcall(session.UpdateAltars)
        if not okAltar and time() >= nextAltarError then
            nextAltarError = time() + 8
            warn("[Ixa Hub] " .. tostring(altarError))
        end
        local okProtection, protectionError = pcall(updateLocalProtection)
        if not okProtection and time() >= nextProtectionError then
            nextProtectionError = time() + 8
            warn("[Ixa Hub] " .. tostring(protectionError))
        end
        local okExtra, extraError = pcall(function() session.UpdateExtraEnemies(); session.UpdateGod() end)
        if not okExtra and time() >= nextEnemyError then
            nextEnemyError = time() + 8
            warn("[Ixa Hub extra] " .. tostring(extraError))
        end
        local okShop, shopError = pcall(session.UpdateShop)
        if not okShop and time() >= nextShopError then
            nextShopError = time() + 8
            warn("[Ixa Hub] " .. tostring(shopError))
        end
        local okEnemy, enemyError = pcall(session.UpdateEnemyRemoval)
        if not okEnemy and time() >= nextEnemyError then
            nextEnemyError = time() + 8
            warn("[Ixa Hub] " .. tostring(enemyError))
        end
        task.wait(0.12)
    end
end)

task.spawn(function()
    local nextConnection = 0
    local nextGiftWarning = 0
    local nextError = 0
    while session.Active do
        local ok, message = pcall(function()
            local now = time()
            if now >= nextConnection then
                nextConnection = now + 1
                updateCollectionConnection()
            end
            if (session.Settings.RageFarm or session.Settings.FastFlyFarm or session.Settings.GiftReach or session.Settings.GiftESP or session.Settings.TripmineESP)
                and not session.GiftHandler and characterState() and now >= nextGiftWarning then
                nextGiftWarning = now + 12
                session.Notify("Waiting for gift data")
            end
            if (session.Settings.RageFarm or session.Settings.FastFlyFarm or session.Settings.GiftReach)
                and now >= (session.AntiVoidHoldUntil or 0) then
                session.RecoverStalledGifts()
            end
            if session.Settings.RageFarm and now >= (session.AntiVoidHoldUntil or 0) then
                session.RageStep()
            elseif session.Settings.GiftReach and not session.Settings.FastFlyFarm then
                session.TryCollectNearby()
            end
        end)
        if not ok and time() >= nextError then
            nextError = time() + 8
            warn("[Ixa Hub] " .. tostring(message))
        end
        task.wait(session.Settings.RageFarm and 0.03 or 0.15)
    end
end)

task.spawn(function()
    local nextError = 0
    while session.Active do
        local ok, message = pcall(session.UpdateMarkers)
        if not ok and time() >= nextError then
            nextError = time() + 8
            warn("[Ixa Hub] " .. tostring(message))
        end
        task.wait(0.35)
    end
end)
