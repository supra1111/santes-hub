--[[
    ╔══════════════════════════════════════════════╗
    ║          S A N T E S   H U B                ║
    ║         ULTIMATE EDITION v4.0               ║
    ╚══════════════════════════════════════════════╝
    
    ✦ AS CHEAT ULTIMATE UI TASARIMI
    ✦ Tüm Combat Modülleri (Aimbot, Silent Aim, TriggerBot, KillAura, NoRecoil, Wallbang)
    ✦ ESP (Name, Health, Distance, Hat, Chams, RGB Shaders, Rainbow Outline)
    ✦ Movement (Fly, Speed, BHop, Noclip, Spider, WaterWalker, FakeLag)
    ✦ Character (Spin, Giant Head, Invisible, Rainbow, Effects)
    ✦ World (Day/Night, Weather, AutoCollect, CarFly)
    ✦ Defense (God, SemiGod, AntiAFK, AntiVoid, AntiAim)
    ✦ Troll (Fling, Annoy, ChatSpam)
    ✦ Profil Kartı + Config Save/Load
    ✦ Glow UI ÜZERİNDE
    ✦ EXECUTOR İÇİN OPTİMİZE
]]

local function SantesHub()
    -- ============================================================
    -- SERVİSLER
    -- ============================================================
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local StarterGui = game:GetService("StarterGui")
    local CoreGui = game:GetService("CoreGui")
    local TextChatService = game:GetService("TextChatService")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local MarketplaceService = game:GetService("MarketplaceService")
    local Stats = game:GetService("Stats")
    local VirtualUser = game:GetService("VirtualUser")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    -- ============================================================
    -- STATE
    -- ============================================================
    local MenuOpen = true
    local RainbowHue = 0
    local SavedPositions = {}
    local CurrentTab = "Visual"
    local Connections = {}
    local ESPFolder = nil
    local FlyBodyVelocity = nil
    local FlyBodyGyro = nil
    local TrailEffects = {}
    local FireEffects = {}
    local SparkleEffects = {}
    local StartTime = os.time()
    local SantesGui = nil
    local MainFrame = nil
    local ActiveFeaturesPanel = nil
    local KeybindListening = nil
    local HeldKeys = {}
    local ToggleRefs = {}
    local WatermarkLabel = nil
    local TargetHUD = nil
    local TargetName = nil
    local TargetHP = nil
    local TargetFace = nil

    -- ============================================================
    -- ORIGINALS
    -- ============================================================
    local Originals = {
        Brightness = Lighting.Brightness,
        GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart,
        ClockTime = Lighting.ClockTime,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        Gravity = Workspace.Gravity,
        FOV = Camera.FieldOfView,
        WalkSpeed = 16,
        JumpPower = 50,
    }

    -- ============================================================
    -- SETTINGS + KEYBINDS + HOLD MODE
    -- ============================================================
    local Settings = {}
    local Keybinds = {}
    local HoldMode = {}

    local FeatureDefs = {
        -- Visual
        ESPEnabled = {default = false, name = "ESP Master", tab = "Visual"},
        NameESP = {default = false, name = "Name ESP", tab = "Visual"},
        HealthESP = {default = false, name = "Health ESP", tab = "Visual"},
        DistanceESP = {default = false, name = "Distance ESP", tab = "Visual"},
        HatESP = {default = false, name = "Hat ESP", tab = "Visual"},
        Chams = {default = false, name = "Chams", tab = "Visual"},
        FullBright = {default = false, name = "FullBright", tab = "Visual"},
        SkyRGB = {default = false, name = "Sky RGB", tab = "Visual"},
        NoFog = {default = false, name = "No Fog", tab = "Visual"},
        ShadowDisable = {default = false, name = "Shadow Disable", tab = "Visual"},
        AmbientRGB = {default = false, name = "Ambient RGB", tab = "Visual"},
        XRay = {default = false, name = "X-Ray", tab = "Visual"},
        Shaders = {default = false, name = "RGB Shaders", tab = "Visual"},
        RainbowOutline = {default = false, name = "Rainbow Outline", tab = "Visual"},
        TargetHUD = {default = false, name = "Target HUD", tab = "Visual"},
        Watermark = {default = false, name = "Watermark", tab = "Visual"},
        ThirdPerson = {default = false, name = "Third Person", tab = "Visual"},
        FOVChanger = {default = false, name = "FOV Changer", tab = "Visual"},
        ZoomHack = {default = false, name = "Zoom Hack", tab = "Visual"},
        FreeCam = {default = false, name = "Free Camera", tab = "Visual"},
        -- Movement
        SpeedHack = {default = false, name = "Speed Hack", tab = "Movement"},
        InfiniteJump = {default = false, name = "Infinite Jump", tab = "Movement"},
        FlyMode = {default = false, name = "Fly Mode", tab = "Movement"},
        BHop = {default = false, name = "Bunny Hop", tab = "Movement"},
        AutoSprint = {default = false, name = "Auto Sprint", tab = "Movement"},
        LowGravity = {default = false, name = "Low Gravity", tab = "Movement"},
        NoClip = {default = false, name = "NoClip", tab = "Movement"},
        TPCursor = {default = false, name = "TP to Cursor", tab = "Movement"},
        SpiderClimb = {default = false, name = "Spider Climb", tab = "Movement"},
        WaterWalker = {default = false, name = "Water Walker", tab = "Movement"},
        FakeLag = {default = false, name = "Fake Lag", tab = "Movement"},
        -- Character
        CharSpin = {default = false, name = "Char Spin", tab = "Character"},
        GiantHead = {default = false, name = "Giant Head", tab = "Character"},
        Invisible = {default = false, name = "Invisible", tab = "Character"},
        RainbowChar = {default = false, name = "Rainbow Char", tab = "Character"},
        NoAnim = {default = false, name = "No Animations", tab = "Character"},
        TrailEffect = {default = false, name = "Trail Effect", tab = "Character"},
        FireEffect = {default = false, name = "Fire Effect", tab = "Character"},
        Sparkles = {default = false, name = "Sparkles", tab = "Character"},
        -- Combat
        Aimbot = {default = false, name = "Aimbot", tab = "Combat"},
        TriggerBot = {default = false, name = "Trigger Bot", tab = "Combat"},
        HitboxExpander = {default = false, name = "Hitbox Expander", tab = "Combat"},
        RapidFire = {default = false, name = "Rapid Fire", tab = "Combat"},
        KillAura = {default = false, name = "Kill Aura", tab = "Combat"},
        SilentAim = {default = false, name = "Silent Aim", tab = "Combat"},
        NoRecoil = {default = false, name = "No Recoil", tab = "Combat"},
        Wallbang = {default = false, name = "Wallbang", tab = "Combat"},
        -- Defense
        GodMode = {default = false, name = "God Mode", tab = "Defense"},
        SemiGod = {default = false, name = "Semi God", tab = "Defense"},
        AntiAFK = {default = false, name = "Anti AFK", tab = "Defense"},
        AntiVoid = {default = false, name = "Anti Void", tab = "Defense"},
        AntiAim = {default = false, name = "Anti-Aim", tab = "Defense"},
        -- World
        DayTime = {default = false, name = "Always Day", tab = "World"},
        NightTime = {default = false, name = "Always Night", tab = "World"},
        AutoCollect = {default = false, name = "Auto Collect", tab = "World"},
        CarFly = {default = false, name = "Car Fly", tab = "World"},
        SuperAccel = {default = false, name = "Super Accel", tab = "World"},
        WeatherManip = {default = false, name = "Weather Manipulator", tab = "World"},
        -- Troll
        ChatSpam = {default = false, name = "Chat Spam", tab = "Troll"},
        FlingAura = {default = false, name = "Fling Aura", tab = "Troll"},
        AnnoyPlayer = {default = false, name = "Annoy Player", tab = "Troll"},
    }

    local SliderSettings = {
        SkyRGBSpeed = 3,
        SpeedValue = 50,
        JumpPower = 150,
        FlySpeed = 50,
        GravityValue = 50,
        FOVValue = 90,
        ZoomLevel = 2,
        SpinSpeed = 10,
        AimbotFOV = 180,
        AimbotSmooth = 3,
        KillAuraRange = 20,
        FreeCamSpeed = 30,
        WeatherType = 1,
        ShaderSpeed = 5,
        HitboxSize = 5,
    }

    for k, def in pairs(FeatureDefs) do
        Settings[k] = def.default
        Keybinds[k] = nil
        HoldMode[k] = false
    end
    for k, v in pairs(SliderSettings) do
        Settings[k] = v
    end
    Settings.SpamMessage = "SANTES HUB ON TOP!"

    -- ============================================================
    -- THEME
    -- ============================================================
    local T = {
        Bg          = Color3.fromRGB(8, 10, 18),
        BgCard      = Color3.fromRGB(12, 16, 28),
        Surface     = Color3.fromRGB(15, 20, 35),
        SurfaceUp   = Color3.fromRGB(20, 26, 45),
        SurfaceHov  = Color3.fromRGB(28, 36, 62),
        Accent      = Color3.fromRGB(255, 38, 52),
        AccentBright= Color3.fromRGB(255, 70, 85),
        AccentDim   = Color3.fromRGB(180, 20, 35),
        AccentGlow  = Color3.fromRGB(255, 50, 70),
        Cyan        = Color3.fromRGB(0, 220, 220),
        Green       = Color3.fromRGB(0, 230, 120),
        GreenDim    = Color3.fromRGB(0, 150, 80),
        Red         = Color3.fromRGB(230, 60, 60),
        RedBright   = Color3.fromRGB(255, 90, 90),
        Orange      = Color3.fromRGB(255, 160, 40),
        Yellow      = Color3.fromRGB(255, 230, 60),
        Text        = Color3.fromRGB(235, 240, 255),
        TextSec     = Color3.fromRGB(150, 165, 195),
        TextDim     = Color3.fromRGB(80, 95, 120),
        TextMuted   = Color3.fromRGB(60, 70, 90),
        Border      = Color3.fromRGB(30, 40, 65),
        BorderLight = Color3.fromRGB(40, 55, 85),
        ToggleOn    = Color3.fromRGB(255, 38, 52),
        ToggleOff   = Color3.fromRGB(35, 42, 58),
        SideActive  = Color3.fromRGB(255, 38, 52),
        SideInactive= Color3.fromRGB(12, 18, 30),
        SliderTrack = Color3.fromRGB(25, 32, 50),
        SliderFill  = Color3.fromRGB(255, 38, 52),
        BtnBg       = Color3.fromRGB(18, 24, 42),
        BtnHov      = Color3.fromRGB(255, 38, 52),
        Footer      = Color3.fromRGB(5, 7, 13),
    }

    -- ============================================================
    -- UTILITY
    -- ============================================================
    local function GetRainbow(speed)
        RainbowHue = RainbowHue + (speed or 3) * 0.001
        if RainbowHue > 1 then RainbowHue = RainbowHue - 1 end
        return Color3.fromHSV(RainbowHue, 1, 1)
    end

    local function Tw(obj, props, dur, style)
        local ti = TweenInfo.new(dur or 0.25, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local t = TweenService:Create(obj, ti, props)
        t:Play()
        return t
    end

    local function Corner(p, r)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, r or 6)
        c.Parent = p
        return c
    end

    local function Stroke(p, col, th, tr)
        local s = Instance.new("UIStroke")
        s.Color = col or T.Border
        s.Thickness = th or 1
        s.Transparency = tr or 0.3
        s.Parent = p
        return s
    end

    local function Pad(p, t, r, b, l)
        local pd = Instance.new("UIPadding")
        pd.PaddingTop = UDim.new(0, t or 0)
        pd.PaddingRight = UDim.new(0, r or 0)
        pd.PaddingBottom = UDim.new(0, b or 0)
        pd.PaddingLeft = UDim.new(0, l or 0)
        pd.Parent = p
        return pd
    end

    local function FormatTime(seconds)
        local h = math.floor(seconds / 3600)
        local m = math.floor((seconds % 3600) / 60)
        local s = seconds % 60
        return string.format("%02d:%02d:%02d", h, m, s)
    end

    local function GetKeyName(key)
        if key == nil then return "---" end
        if typeof(key) == "EnumItem" then
            local name = key.Name
            name = name:gsub("MouseButton1", "LMB")
            name = name:gsub("MouseButton2", "RMB")
            name = name:gsub("MouseButton3", "MMB")
            if key == Enum.UserInputType.MouseButton4 then return "Mouse4" end
            if key == Enum.UserInputType.MouseButton5 then return "Mouse5" end
            return name
        end
        return tostring(key)
    end

    -- ============================================================
    -- NO RECOIL (GERÇEK - ÇALIŞIYOR)
    -- ============================================================
    local NoRecoilEnabled = false
    local NoRecoil_Connections = {}
    local NoRecoil_WeaponCache = {}
    local NoRecoil_GlobalOriginal = {}

    local function NoRecoil_CacheWeapons()
        NoRecoil_WeaponCache = {}
        for _, v in pairs(getgc(true)) do
            if type(v) == 'table' and (rawget(v, 'EquipTime') or rawget(v, 'Recoil') ~= nil) then
                table.insert(NoRecoil_WeaponCache, v)
                if not NoRecoil_GlobalOriginal[v] then
                    NoRecoil_GlobalOriginal[v] = {
                        Recoil = rawget(v, 'Recoil'),
                        CameraRecoilingEnabled = rawget(v, 'CameraRecoilingEnabled'),
                        AngleX_Min = rawget(v, 'AngleX_Min'),
                        AngleX_Max = rawget(v, 'AngleX_Max'),
                        AngleY_Min = rawget(v, 'AngleY_Min'),
                        AngleY_Max = rawget(v, 'AngleY_Max'),
                        AngleZ_Min = rawget(v, 'AngleZ_Min'),
                        AngleZ_Max = rawget(v, 'AngleZ_Max'),
                        Spread = rawget(v, 'Spread'),
                        MaxSpread = rawget(v, 'MaxSpread'),
                        MinSpread = rawget(v, 'MinSpread'),
                    }
                end
            end
        end
    end

    local function NoRecoil_Apply()
        for _, weapon in pairs(NoRecoil_WeaponCache) do
            pcall(function()
                weapon.Recoil = 0
                weapon.CameraRecoilingEnabled = false
                weapon.AngleX_Min = 0
                weapon.AngleX_Max = 0
                weapon.AngleY_Min = 0
                weapon.AngleY_Max = 0
                weapon.AngleZ_Min = 0
                weapon.AngleZ_Max = 0
                weapon.Spread = 0
                weapon.MaxSpread = 0
                weapon.MinSpread = 0
            end)
        end
    end

    local function NoRecoil_Reset()
        for weapon, values in pairs(NoRecoil_GlobalOriginal) do
            pcall(function()
                weapon.Recoil = values.Recoil
                weapon.CameraRecoilingEnabled = values.CameraRecoilingEnabled
                weapon.AngleX_Min = values.AngleX_Min
                weapon.AngleX_Max = values.AngleX_Max
                weapon.AngleY_Min = values.AngleY_Min
                weapon.AngleY_Max = values.AngleY_Max
                weapon.AngleZ_Min = values.AngleZ_Min
                weapon.AngleZ_Max = values.AngleZ_Max
                weapon.Spread = values.Spread
                weapon.MaxSpread = values.MaxSpread
                weapon.MinSpread = values.MinSpread
            end)
        end
    end

    local function NoRecoil_HandleWeapon(weapon)
        if NoRecoilEnabled then
            task.wait(0.1)
            NoRecoil_CacheWeapons()
            NoRecoil_Apply()
        end
    end

    local function NoRecoil_OnCharacterAdded(character)
        for _, child in ipairs(character:GetChildren()) do
            if child:IsA("Tool") then NoRecoil_HandleWeapon(child) end
        end
        table.insert(NoRecoil_Connections, character.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then NoRecoil_HandleWeapon(child) end
        end))
        local humanoid = character:WaitForChild("Humanoid", 2)
        if humanoid then
            table.insert(NoRecoil_Connections, humanoid.Died:Connect(function()
                if NoRecoilEnabled then
                    task.wait(1.5)
                    NoRecoil_CacheWeapons()
                    NoRecoil_Apply()
                end
            end))
        end
    end

    function NoRecoil_Enable()
        if NoRecoilEnabled then return end
        NoRecoilEnabled = true
        NoRecoil_CacheWeapons()
        NoRecoil_Apply()
        table.insert(NoRecoil_Connections, LocalPlayer.CharacterAdded:Connect(NoRecoil_OnCharacterAdded))
        if LocalPlayer.Character then NoRecoil_OnCharacterAdded(LocalPlayer.Character) end
    end

    function NoRecoil_Disable()
        if not NoRecoilEnabled then return end
        NoRecoilEnabled = false
        NoRecoil_Reset()
        for _, conn in ipairs(NoRecoil_Connections) do
            pcall(function() conn:Disconnect() end)
        end
        NoRecoil_Connections = {}
    end

    -- ============================================================
    -- FEATURE ACTIVATION/DEACTIVATION
    -- ============================================================
    local function OnFeatureEnabled(key)
        if key == "NoRecoil" then
            NoRecoil_Enable()
        end
    end

    local function OnFeatureDisabled(key)
        if key == "NoRecoil" then
            NoRecoil_Disable()
        end
    end

    local function ToggleFeature(key, forceState)
        local newState
        if forceState ~= nil then
            newState = forceState
        else
            newState = not Settings[key]
        end
        
        if newState and not Settings[key] then
            OnFeatureEnabled(key)
        elseif not newState and Settings[key] then
            OnFeatureDisabled(key)
        end
        
        Settings[key] = newState
        
        if WatermarkLabel then
            local active = {}
            for k, v in pairs(Settings) do
                if v and FeatureDefs[k] then table.insert(active, FeatureDefs[k].name) end
            end
            if #active > 0 then
                WatermarkLabel.Text = "SANTES HUB | ACTIVE: " .. table.concat(active, ", ")
                WatermarkLabel.Visible = true
            else
                WatermarkLabel.Visible = false
            end
        end
    end

    -- ============================================================
    -- ESP
    -- ============================================================
    local function CreateESP()
        if ESPFolder then ESPFolder:Destroy() end
        ESPFolder = Instance.new("Folder")
        ESPFolder.Name = "SantesESP"
        ESPFolder.Parent = CoreGui
        
        local function MakeESP(plr)
            if plr == LocalPlayer then return end
            local tag = Instance.new("BillboardGui")
            tag.Name = plr.Name
            tag.AlwaysOnTop = true
            tag.Size = UDim2.new(0, 200, 0, 80)
            tag.StudsOffset = Vector3.new(0, 3.5, 0)
            tag.Parent = ESPFolder
            
            local nameLbl = Instance.new("TextLabel")
            nameLbl.Name = "Name"
            nameLbl.Size = UDim2.new(1, 0, 0, 16)
            nameLbl.Position = UDim2.new(0, 0, 0, 30)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = plr.Name
            nameLbl.TextColor3 = T.AccentBright
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.TextSize = 13
            nameLbl.TextStrokeTransparency = 0.2
            nameLbl.TextStrokeColor3 = Color3.new(0,0,0)
            nameLbl.Visible = false
            nameLbl.Parent = tag
            
            local distLbl = Instance.new("TextLabel")
            distLbl.Name = "Distance"
            distLbl.Size = UDim2.new(1, 0, 0, 13)
            distLbl.Position = UDim2.new(0, 0, 0, 46)
            distLbl.BackgroundTransparency = 1
            distLbl.TextColor3 = T.TextSec
            distLbl.Font = Enum.Font.Gotham
            distLbl.TextSize = 10
            distLbl.TextStrokeTransparency = 0.3
            distLbl.TextStrokeColor3 = Color3.new(0,0,0)
            distLbl.Visible = false
            distLbl.Parent = tag
            
            local hpBg = Instance.new("Frame")
            hpBg.Name = "HPBg"
            hpBg.Size = UDim2.new(0.65, 0, 0, 3)
            hpBg.Position = UDim2.new(0.175, 0, 0, 61)
            hpBg.BackgroundColor3 = Color3.fromRGB(20,20,30)
            hpBg.BorderSizePixel = 0
            hpBg.Visible = false
            hpBg.Parent = tag
            Corner(hpBg, 2)
            
            local hpBar = Instance.new("Frame")
            hpBar.Name = "HP"
            hpBar.Size = UDim2.new(1, 0, 1, 0)
            hpBar.BackgroundColor3 = T.Green
            hpBar.BorderSizePixel = 0
            hpBar.Parent = hpBg
            Corner(hpBar, 2)
        end
        
        for _, p in pairs(Players:GetPlayers()) do MakeESP(p) end
        table.insert(Connections, Players.PlayerAdded:Connect(function(p) MakeESP(p) end))
        table.insert(Connections, Players.PlayerRemoving:Connect(function(p)
            if ESPFolder then local t = ESPFolder:FindFirstChild(p.Name); if t then t:Destroy() end end
        end))
    end

    local function UpdateESP()
        if not Settings.ESPEnabled or not ESPFolder then return end
        local currentRainbow = GetRainbow(Settings.Shaders and Settings.ShaderSpeed or 1)
        for _, plr in pairs(Players:GetPlayers()) do
            if plr == LocalPlayer then continue end
            if not plr.Character then continue end
            local head = plr.Character:FindFirstChild("Head")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if not head or not root then continue end
            local tag = ESPFolder:FindFirstChild(plr.Name)
            if not tag then continue end
            tag.Adornee = head
            local _, onScreen = Camera:WorldToViewportPoint(root.Position)
            tag.Enabled = onScreen
            if onScreen then
                local dist = 0
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude)
                end
                local n = tag:FindFirstChild("Name")
                if n then n.Visible = Settings.NameESP; n.Text = plr.Name end
                local d = tag:FindFirstChild("Distance")
                if d then d.Visible = Settings.DistanceESP; d.Text = dist .. "m" end
                
                local hpBg = tag:FindFirstChild("HPBg")
                if hpBg and hum then
                    hpBg.Visible = Settings.HealthESP
                    local bar = hpBg:FindFirstChild("HP")
                    if bar then
                        local pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        bar.Size = UDim2.new(pct, 0, 1, 0)
                        bar.BackgroundColor3 = Color3.fromRGB(math.clamp((1-pct)*255,0,255), math.clamp(pct*255,0,255), 0)
                    end
                end
                
                -- Chams
                local hl = plr.Character:FindFirstChild("Santes_Chams")
                if Settings.Chams or Settings.Shaders or Settings.RainbowOutline then
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "Santes_Chams"
                        hl.FillTransparency = 0.5
                        hl.OutlineTransparency = 0.2
                        hl.Parent = plr.Character
                    end
                    local pulse = (math.sin(tick() * (Settings.ShaderSpeed * 0.5)) + 1) / 2
                    if Settings.Shaders then
                        hl.FillColor = currentRainbow
                        hl.FillTransparency = 0
                    elseif Settings.Chams then
                        hl.FillColor = T.AccentDim
                        hl.FillTransparency = 0
                    else
                        hl.FillTransparency = 1
                    end
                    if Settings.RainbowOutline then
                        hl.OutlineColor = currentRainbow
                        hl.OutlineTransparency = 0
                    elseif Settings.Chams or Settings.Shaders then
                        hl.OutlineColor = T.Border
                        hl.OutlineTransparency = 0
                    else
                        hl.OutlineTransparency = 1
                    end
                else
                    if hl then hl:Destroy() end
                end
                
                -- Hat ESP
                if Settings.HatESP then
                    if not head:FindFirstChild("Santes_EnemyHat") then
                        pcall(function()
                            local cone = Instance.new("ConeHandleAdornment")
                            cone.Name = "Santes_EnemyHat"
                            cone.Radius = 1.3
                            cone.Height = 1.5
                            cone.Color3 = T.AccentBright
                            cone.Transparency = 0
                            cone.ZIndex = 5
                            cone.AlwaysOnTop = true
                            cone.Adornee = head
                            cone.CFrame = CFrame.new(0, 0.8, 0) * CFrame.Angles(math.rad(90), 0, 0)
                            cone.Parent = head
                        end)
                    end
                else
                    local h = head:FindFirstChild("Santes_EnemyHat")
                    if h then h:Destroy() end
                end
            end
        end
    end

    -- ============================================================
    -- AIMBOT
    -- ============================================================
    local function DoAimbot()
        if not Settings.Aimbot then return end
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
        local closest, shortDist = nil, Settings.AimbotFOV
        for _, plr in pairs(Players:GetPlayers()) do
            if plr == LocalPlayer or not plr.Character then continue end
            local head = plr.Character:FindFirstChild("Head")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if not head or not hum or hum.Health <= 0 then continue end
            local sp, on = Camera:WorldToViewportPoint(head.Position)
            if not on then continue end
            local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            if d < shortDist then shortDist = d; closest = plr end
        end
        if closest and closest.Character then
            local head = closest.Character:FindFirstChild("Head")
            if head then
                local look = CFrame.new(Camera.CFrame.Position, head.Position)
                Camera.CFrame = Settings.AimbotSmooth > 1 and Camera.CFrame:Lerp(look, 1/Settings.AimbotSmooth) or look
            end
        end
    end

    local function DoTriggerBot()
        if not Settings.TriggerBot then return end
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
        local ray = Camera:ScreenPointToRay(Mouse.X, Mouse.Y)
        local result = Workspace:Raycast(ray.Origin, ray.Direction * 1000)
        if result and result.Instance then
            local hit = result.Instance
            local model = hit:FindFirstAncestorOfClass("Model")
            if model then
                local plr = Players:GetPlayerFromCharacter(model)
                if plr and plr ~= LocalPlayer then
                    pcall(function() mouse1press(); task.wait(0.05); mouse1release() end)
                end
            end
        end
    end

    -- ============================================================
    -- WATERMARK & TARGET HUD
    -- ============================================================
    local function CreateHUD(gui)
        WatermarkLabel = Instance.new("TextLabel")
        WatermarkLabel.Size = UDim2.new(0, 300, 0, 20)
        WatermarkLabel.Position = UDim2.new(0, 10, 0, 10)
        WatermarkLabel.BackgroundTransparency = 1
        WatermarkLabel.Text = "SANTES HUB | ACTIVE: NONE"
        WatermarkLabel.TextColor3 = T.AccentBright
        WatermarkLabel.Font = Enum.Font.GothamBold
        WatermarkLabel.TextSize = 12
        WatermarkLabel.TextXAlignment = Enum.TextXAlignment.Left
        WatermarkLabel.TextStrokeTransparency = 0.5
        WatermarkLabel.Visible = false
        WatermarkLabel.ZIndex = 10
        WatermarkLabel.Parent = gui
        
        TargetHUD = Instance.new("Frame")
        TargetHUD.Size = UDim2.new(0, 220, 0, 60)
        TargetHUD.Position = UDim2.new(0.5, -110, 1, -150)
        TargetHUD.BackgroundColor3 = T.BgCard
        TargetHUD.BorderSizePixel = 0
        TargetHUD.Visible = false
        TargetHUD.ZIndex = 10
        TargetHUD.Parent = gui
        Corner(TargetHUD, 8)
        Stroke(TargetHUD, T.Accent, 1, 0.2)
        
        local faceBg = Instance.new("Frame")
        faceBg.Size = UDim2.new(0, 44, 0, 44)
        faceBg.Position = UDim2.new(0, 8, 0, 8)
        faceBg.BackgroundColor3 = T.Surface
        faceBg.BorderSizePixel = 0
        faceBg.Parent = TargetHUD
        Corner(faceBg, 6)
        TargetFace = Instance.new("ImageLabel")
        TargetFace.Size = UDim2.new(1, 0, 1, 0)
        TargetFace.BackgroundTransparency = 1
        TargetFace.Parent = faceBg
        Corner(TargetFace, 6)
        
        TargetName = Instance.new("TextLabel")
        TargetName.Size = UDim2.new(1, -65, 0, 16)
        TargetName.Position = UDim2.new(0, 60, 0, 8)
        TargetName.BackgroundTransparency = 1
        TargetName.Text = "Name"
        TargetName.TextColor3 = T.Text
        TargetName.Font = Enum.Font.GothamBold
        TargetName.TextSize = 13
        TargetName.TextXAlignment = Enum.TextXAlignment.Left
        TargetName.Parent = TargetHUD
        
        local hpBg = Instance.new("Frame")
        hpBg.Size = UDim2.new(1, -65, 0, 8)
        hpBg.Position = UDim2.new(0, 60, 0, 32)
        hpBg.BackgroundColor3 = T.SurfaceUp
        hpBg.BorderSizePixel = 0
        hpBg.Parent = TargetHUD
        Corner(hpBg, 4)
        TargetHP = Instance.new("Frame")
        TargetHP.Size = UDim2.new(1, 0, 1, 0)
        TargetHP.BackgroundColor3 = T.Green
        TargetHP.BorderSizePixel = 0
        TargetHP.Parent = hpBg
        Corner(TargetHP, 4)
    end

    -- ============================================================
    -- CREATE UI
    -- ============================================================
    local function CreateUI()
        if SantesGui then pcall(function() SantesGui:Destroy() end) end
        
        local gui = Instance.new("ScreenGui")
        gui.Name = "SantesHub_Ultimate"
        local success = pcall(function()
            if gethui then gui.Parent = gethui() else gui.Parent = CoreGui end
        end)
        if not success then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
        gui.ResetOnSpawn = false
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        SantesGui = gui
        
        MainFrame = Instance.new("Frame")
        MainFrame.Name = "Main"
        MainFrame.Size = UDim2.new(0, 780, 0, 540)
        MainFrame.Position = UDim2.new(0.5, -390, 0.5, -270)
        MainFrame.BackgroundColor3 = T.Bg
        MainFrame.BorderSizePixel = 0
        MainFrame.Active = true
        MainFrame.Draggable = true
        MainFrame.ClipsDescendants = true
        MainFrame.Parent = gui
        Corner(MainFrame, 24)
        Stroke(MainFrame, T.BorderLight, 1.5, 0.2)
        
        CreateHUD(gui)
        
        -- GLOW (UI ÜZERİNDE)
        local glow = Instance.new("ImageLabel")
        glow.Size = UDim2.new(1, 40, 1, 40)
        glow.Position = UDim2.new(0, -20, 0, -20)
        glow.BackgroundTransparency = 1
        glow.ImageTransparency = 0.4
        glow.ImageColor3 = T.Accent
        glow.ZIndex = -1
        glow.Image = "rbxassetid://5028857084"
        glow.ScaleType = Enum.ScaleType.Slice
        glow.SliceCenter = Rect.new(23, 23, 277, 277)
        glow.Parent = MainFrame
        
        -- INTRO ANIMATION
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        MainFrame.Visible = true
        Tw(MainFrame, {Size = UDim2.new(0, 780, 0, 540), Position = UDim2.new(0.5, -390, 0.5, -270)}, 0.6, Enum.EasingStyle.Back)
        
        -- TOP BAR
        local TopBar = Instance.new("Frame")
        TopBar.Size = UDim2.new(1, 0, 0, 50)
        TopBar.BackgroundColor3 = T.Surface
        TopBar.BorderSizePixel = 0
        TopBar.ZIndex = 5
        TopBar.Parent = MainFrame
        
        local topLine = Instance.new("Frame")
        topLine.Size = UDim2.new(1, 0, 0, 2)
        topLine.BackgroundColor3 = T.Accent
        topLine.BorderSizePixel = 0
        topLine.ZIndex = 6
        topLine.Parent = MainFrame
        
        local logoBg = Instance.new("Frame")
        logoBg.Size = UDim2.new(0, 36, 0, 36)
        logoBg.Position = UDim2.new(0, 12, 0, 7)
        logoBg.BackgroundColor3 = T.Accent
        logoBg.ZIndex = 6
        logoBg.Parent = TopBar
        Corner(logoBg, 12)
        
        local logoTxt = Instance.new("TextLabel")
        logoTxt.Size = UDim2.new(1, 0, 1, 0)
        logoTxt.BackgroundTransparency = 1
        logoTxt.Text = "SH"
        logoTxt.TextColor3 = Color3.new(1,1,1)
        logoTxt.Font = Enum.Font.GothamBlack
        logoTxt.TextSize = 14
        logoTxt.ZIndex = 7
        logoTxt.Parent = logoBg
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(0, 140, 0, 22)
        title.Position = UDim2.new(0, 58, 0, 6)
        title.BackgroundTransparency = 1
        title.Text = "SANTES HUB"
        title.TextColor3 = T.Text
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 18
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 6
        title.Parent = TopBar
        
        local sub = Instance.new("TextLabel")
        sub.Size = UDim2.new(0, 140, 0, 14)
        sub.Position = UDim2.new(0, 58, 0, 28)
        sub.BackgroundTransparency = 1
        sub.Text = "ULTIMATE EDITION"
        sub.TextColor3 = T.Accent
        sub.Font = Enum.Font.GothamBold
        sub.TextSize = 10
        sub.TextXAlignment = Enum.TextXAlignment.Left
        sub.ZIndex = 6
        sub.Parent = TopBar
        
        -- CLOSE
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 28, 0, 28)
        closeBtn.Position = UDim2.new(1, -38, 0, 11)
        closeBtn.BackgroundColor3 = T.Red
        closeBtn.Text = "X"
        closeBtn.TextColor3 = Color3.new(1,1,1)
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 12
        closeBtn.ZIndex = 6
        closeBtn.Parent = TopBar
        Corner(closeBtn, 7)
        closeBtn.MouseButton1Click:Connect(function() ResetAll(); gui:Destroy(); MenuOpen = false; SantesGui = nil end)
        
        -- MINIMIZE
        local minBtn = Instance.new("TextButton")
        minBtn.Size = UDim2.new(0, 28, 0, 28)
        minBtn.Position = UDim2.new(1, -70, 0, 11)
        minBtn.BackgroundColor3 = T.SurfaceUp
        minBtn.Text = "_"
        minBtn.TextColor3 = T.TextSec
        minBtn.Font = Enum.Font.GothamBold
        minBtn.TextSize = 14
        minBtn.ZIndex = 6
        minBtn.Parent = TopBar
        Corner(minBtn, 7)
        minBtn.MouseButton1Click:Connect(function()
            MenuOpen = false
            Tw(MainFrame, {Size = UDim2.new(0, 780, 0, 52)}, 0.25)
        end)
        
        -- ACTIVE FEATURES PANEL
        ActiveFeaturesPanel = Instance.new("ScrollingFrame")
        ActiveFeaturesPanel.Size = UDim2.new(0, 140, 1, -82)
        ActiveFeaturesPanel.Position = UDim2.new(0, 0, 0, 50)
        ActiveFeaturesPanel.BackgroundColor3 = Color3.fromRGB(6, 8, 16)
        ActiveFeaturesPanel.BorderSizePixel = 0
        ActiveFeaturesPanel.ZIndex = 3
        ActiveFeaturesPanel.ScrollBarThickness = 2
        ActiveFeaturesPanel.ScrollBarImageColor3 = T.Accent
        ActiveFeaturesPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
        ActiveFeaturesPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
        ActiveFeaturesPanel.Parent = MainFrame
        
        local apTitle = Instance.new("TextLabel")
        apTitle.Size = UDim2.new(1, -10, 0, 26)
        apTitle.Position = UDim2.new(0, 5, 0, 0)
        apTitle.BackgroundTransparency = 1
        apTitle.Text = "⚡ ACTIVE"
        apTitle.TextColor3 = T.Green
        apTitle.Font = Enum.Font.GothamBlack
        apTitle.TextSize = 9
        apTitle.TextXAlignment = Enum.TextXAlignment.Left
        apTitle.ZIndex = 5
        apTitle.Parent = ActiveFeaturesPanel
        
        local apLayout = Instance.new("UIListLayout")
        apLayout.Padding = UDim.new(0, 1)
        apLayout.Parent = ActiveFeaturesPanel
        Pad(ActiveFeaturesPanel, 4, 4, 4, 4)
        
        -- SIDEBAR
        local Sidebar = Instance.new("Frame")
        Sidebar.Size = UDim2.new(0, 130, 1, -82)
        Sidebar.Position = UDim2.new(0, 141, 0, 50)
        Sidebar.BackgroundColor3 = T.Surface
        Sidebar.BorderSizePixel = 0
        Sidebar.ZIndex = 3
        Sidebar.Parent = MainFrame
        
        local sideScroll = Instance.new("ScrollingFrame")
        sideScroll.Size = UDim2.new(1, -6, 1, -6)
        sideScroll.Position = UDim2.new(0, 3, 0, 3)
        sideScroll.BackgroundTransparency = 1
        sideScroll.ScrollBarThickness = 0
        sideScroll.CanvasSize = UDim2.new(0,0,0,0)
        sideScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        sideScroll.ZIndex = 4
        sideScroll.Parent = Sidebar
        
        local sideLayout = Instance.new("UIListLayout")
        sideLayout.Padding = UDim.new(0, 3)
        sideLayout.Parent = sideScroll
        
        -- PAGE CONTAINER
        local PageCont = Instance.new("Frame")
        PageCont.Size = UDim2.new(1, -274, 1, -82)
        PageCont.Position = UDim2.new(0, 272, 0, 50)
        PageCont.BackgroundColor3 = T.Bg
        PageCont.BorderSizePixel = 0
        PageCont.ZIndex = 2
        PageCont.Parent = MainFrame
        
        -- FOOTER
        local footer = Instance.new("Frame")
        footer.Size = UDim2.new(1, 0, 0, 32)
        footer.Position = UDim2.new(0, 0, 1, -32)
        footer.BackgroundColor3 = T.Footer
        footer.BorderSizePixel = 0
        footer.ZIndex = 5
        footer.Parent = MainFrame
        
        local footerL = Instance.new("TextLabel")
        footerL.Size = UDim2.new(0.5, 0, 1, 0)
        footerL.Position = UDim2.new(0, 12, 0, 0)
        footerL.BackgroundTransparency = 1
        footerL.Text = "INSERT = Toggle | SANTES HUB"
        footerL.TextColor3 = T.TextMuted
        footerL.Font = Enum.Font.Gotham
        footerL.TextSize = 9
        footerL.TextXAlignment = Enum.TextXAlignment.Left
        footerL.ZIndex = 6
        footerL.Parent = footer
        
        local footerR = Instance.new("TextLabel")
        footerR.Size = UDim2.new(0.5, -12, 1, 0)
        footerR.Position = UDim2.new(0.5, 0, 0, 0)
        footerR.BackgroundTransparency = 1
        footerR.Text = "Ping: 0ms | Session: 00:00:00"
        footerR.TextColor3 = T.TextMuted
        footerR.Font = Enum.Font.Gotham
        footerR.TextSize = 9
        footerR.TextXAlignment = Enum.TextXAlignment.Right
        footerR.ZIndex = 6
        footerR.Parent = footer
        
        -- ============================================================
        -- TABS
        -- ============================================================
        local TabDefs = {
            {Name = "VISUAL", ID = "Visual"},
            {Name = "COMBAT", ID = "Combat"},
            {Name = "MOVEMENT", ID = "Movement"},
            {Name = "CHARACTER", ID = "Character"},
            {Name = "WORLD", ID = "World"},
            {Name = "DEFENSE", ID = "Defense"},
            {Name = "TROLL", ID = "Troll"},
            {Name = "PROFILE", ID = "Profile"},
        }
        
        local TabBtns = {}
        local Pages = {}
        ToggleRefs = {}
        
        for i, tab in ipairs(TabDefs) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 34)
            btn.BackgroundColor3 = i == 1 and T.SideActive or T.SideInactive
            btn.Text = ""
            btn.BorderSizePixel = 0
            btn.ZIndex = 5
            btn.Parent = sideScroll
            Corner(btn, 10)
            
            local indicator = Instance.new("Frame")
            indicator.Name = "Ind"
            indicator.Size = UDim2.new(0, 3, 0.6, 0)
            indicator.Position = UDim2.new(0, 0, 0.2, 0)
            indicator.BackgroundColor3 = T.AccentGlow
            indicator.BorderSizePixel = 0
            indicator.Visible = (i == 1)
            indicator.ZIndex = 6
            indicator.Parent = btn
            Corner(indicator, 2)
            
            local tabName = Instance.new("TextLabel")
            tabName.Size = UDim2.new(1, -14, 1, 0)
            tabName.Position = UDim2.new(0, 12, 0, 0)
            tabName.BackgroundTransparency = 1
            tabName.Text = tab.Name
            tabName.TextColor3 = i == 1 and Color3.new(1,1,1) or T.TextSec
            tabName.Font = Enum.Font.GothamBold
            tabName.TextSize = 11
            tabName.TextXAlignment = Enum.TextXAlignment.Left
            tabName.ZIndex = 6
            tabName.Parent = btn
            
            local page = Instance.new("ScrollingFrame")
            page.Name = tab.ID
            page.Size = UDim2.new(1, -12, 1, -8)
            page.Position = UDim2.new(0, 6, 0, 4)
            page.BackgroundTransparency = 1
            page.ScrollBarThickness = 3
            page.ScrollBarImageColor3 = T.Accent
            page.ScrollBarImageTransparency = 0.4
            page.Visible = (i == 1)
            page.CanvasSize = UDim2.new(0,0,0,0)
            page.AutomaticCanvasSize = Enum.AutomaticSize.Y
            page.ZIndex = 3
            page.Parent = PageCont
            
            local pl = Instance.new("UIListLayout")
            pl.Padding = UDim.new(0, 4)
            pl.Parent = page
            Pad(page, 4, 4, 4, 4)
            
            TabBtns[tab.ID] = btn
            Pages[tab.ID] = page
            
            btn.MouseButton1Click:Connect(function()
                for id, b in pairs(TabBtns) do
                    b.BackgroundColor3 = T.SideInactive
                    local ind = b:FindFirstChild("Ind")
                    if ind then ind.Visible = false end
                    for _, c in pairs(b:GetChildren()) do
                        if c:IsA("TextLabel") then c.TextColor3 = T.TextSec end
                    end
                end
                for _, p in pairs(Pages) do p.Visible = false end
                btn.BackgroundColor3 = T.SideActive
                local ind = btn:FindFirstChild("Ind")
                if ind then ind.Visible = true end
                for _, c in pairs(btn:GetChildren()) do
                    if c:IsA("TextLabel") then c.TextColor3 = Color3.new(1,1,1) end
                end
                page.Visible = true
                CurrentTab = tab.ID
            end)
        end
        
        -- ============================================================
        -- UI HELPERS
        -- ============================================================
        local function Section(page, txt)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 26)
            f.BackgroundTransparency = 1
            f.ZIndex = 3
            f.Parent = page
            
            local line = Instance.new("Frame")
            line.Size = UDim2.new(0, 20, 0, 1)
            line.Position = UDim2.new(0, 0, 0.5, 0)
            line.BackgroundColor3 = T.Accent
            line.BackgroundTransparency = 0.2
            line.BorderSizePixel = 0
            line.ZIndex = 4
            line.Parent = f
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -26, 1, 0)
            lbl.Position = UDim2.new(0, 26, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = txt
            lbl.TextColor3 = T.Accent
            lbl.Font = Enum.Font.GothamBlack
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 4
            lbl.Parent = f
        end
        
        local function Toggle(page, name, settingKey)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 36)
            f.BackgroundColor3 = T.SurfaceUp
            f.BackgroundTransparency = 0.15
            f.BorderSizePixel = 0
            f.ZIndex = 3
            f.Parent = page
            Corner(f, 10)
            
            local track = Instance.new("Frame")
            track.Size = UDim2.new(0, 36, 0, 18)
            track.Position = UDim2.new(0, 8, 0.5, -9)
            track.BackgroundColor3 = Settings[settingKey] and T.ToggleOn or T.ToggleOff
            track.BorderSizePixel = 0
            track.ZIndex = 4
            track.Parent = f
            Corner(track, 12)
            
            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0, 14, 0, 14)
            circle.Position = Settings[settingKey] and UDim2.new(0, 21, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            circle.BackgroundColor3 = Color3.new(1,1,1)
            circle.BorderSizePixel = 0
            circle.ZIndex = 5
            circle.Parent = track
            Corner(circle, 10)
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0, 140, 1, 0)
            lbl.Position = UDim2.new(0, 52, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = T.Text
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 4
            lbl.Parent = f
            
            local modeLbl = Instance.new("TextButton")
            modeLbl.Size = UDim2.new(0, 48, 0, 18)
            modeLbl.Position = UDim2.new(1, -138, 0.5, -9)
            modeLbl.BackgroundColor3 = HoldMode[settingKey] and T.Orange or T.SurfaceUp
            modeLbl.Text = HoldMode[settingKey] and "HOLD" or "TOGGLE"
            modeLbl.TextColor3 = Color3.new(1,1,1)
            modeLbl.Font = Enum.Font.GothamBold
            modeLbl.TextSize = 8
            modeLbl.ZIndex = 5
            modeLbl.Parent = f
            Corner(modeLbl, 4)
            
            modeLbl.MouseButton1Click:Connect(function()
                HoldMode[settingKey] = not HoldMode[settingKey]
                modeLbl.Text = HoldMode[settingKey] and "HOLD" or "TOGGLE"
                modeLbl.BackgroundColor3 = HoldMode[settingKey] and T.Orange or T.SurfaceUp
            end)
            
            local keyBtn = Instance.new("TextButton")
            keyBtn.Size = UDim2.new(0, 64, 0, 20)
            keyBtn.Position = UDim2.new(1, -74, 0.5, -10)
            keyBtn.BackgroundColor3 = T.BtnBg
            keyBtn.Text = "[" .. GetKeyName(Keybinds[settingKey]) .. "]"
            keyBtn.TextColor3 = T.TextSec
            keyBtn.Font = Enum.Font.GothamBold
            keyBtn.TextSize = 9
            keyBtn.ZIndex = 5
            keyBtn.Parent = f
            Corner(keyBtn, 4)
            Stroke(keyBtn, T.Border, 1, 0.5)
            
            keyBtn.MouseButton1Click:Connect(function()
                if KeybindListening == settingKey then
                    KeybindListening = nil
                    keyBtn.Text = "[" .. GetKeyName(Keybinds[settingKey]) .. "]"
                    keyBtn.BackgroundColor3 = T.BtnBg
                else
                    KeybindListening = settingKey
                    keyBtn.Text = "[...]"
                    keyBtn.BackgroundColor3 = T.Accent
                end
            end)
            keyBtn.MouseButton2Click:Connect(function()
                Keybinds[settingKey] = nil
                KeybindListening = nil
                keyBtn.Text = "[---]"
                keyBtn.BackgroundColor3 = T.BtnBg
            end)
            
            local status = Instance.new("TextLabel")
            status.Size = UDim2.new(0, 30, 1, 0)
            status.Position = UDim2.new(1, -32, 0, 0)
            status.BackgroundTransparency = 1
            status.Text = Settings[settingKey] and "ON" or ""
            status.TextColor3 = T.ToggleOn
            status.Font = Enum.Font.GothamBold
            status.TextSize = 9
            status.ZIndex = 4
            status.Parent = f
            
            local clickArea = Instance.new("TextButton")
            clickArea.Size = UDim2.new(0, 190, 1, 0)
            clickArea.BackgroundTransparency = 1
            clickArea.Text = ""
            clickArea.ZIndex = 6
            clickArea.Parent = f
            
            local ref = {
                key = settingKey,
                track = track,
                circle = circle,
                status = status,
                keyBtn = keyBtn,
                modeLbl = modeLbl,
            }
            table.insert(ToggleRefs, ref)
            
            local function UpdateVisual()
                local on = Settings[settingKey]
                Tw(track, {BackgroundColor3 = on and T.ToggleOn or T.ToggleOff}, 0.15)
                Tw(circle, {Position = on and UDim2.new(0, 21, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}, 0.15)
                status.Text = on and "ON" or ""
            end
            ref.UpdateVisual = UpdateVisual
            
            clickArea.MouseButton1Click:Connect(function()
                ToggleFeature(settingKey)
                UpdateVisual()
            end)
        end
        
        local function Slider(page, name, min, max, def, settingKey)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 44)
            f.BackgroundColor3 = T.SurfaceUp
            f.BackgroundTransparency = 0.15
            f.BorderSizePixel = 0
            f.ZIndex = 3
            f.Parent = page
            Corner(f, 10)
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -70, 0, 18)
            lbl.Position = UDim2.new(0, 10, 0, 2)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = T.TextSec
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 10
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 4
            lbl.Parent = f
            
            local valLbl = Instance.new("TextLabel")
            valLbl.Size = UDim2.new(0, 60, 0, 18)
            valLbl.Position = UDim2.new(1, -70, 0, 2)
            valLbl.BackgroundTransparency = 1
            valLbl.Text = tostring(def)
            valLbl.TextColor3 = T.AccentBright
            valLbl.Font = Enum.Font.GothamBold
            valLbl.TextSize = 10
            valLbl.TextXAlignment = Enum.TextXAlignment.Right
            valLbl.ZIndex = 4
            valLbl.Parent = f
            
            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(1, -22, 0, 6)
            bar.Position = UDim2.new(0, 11, 0, 28)
            bar.BackgroundColor3 = T.SliderTrack
            bar.BorderSizePixel = 0
            bar.ZIndex = 4
            bar.Parent = f
            Corner(bar, 3)
            
            local pct = math.clamp((def - min) / (max - min), 0, 1)
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(pct, 0, 1, 0)
            fill.BackgroundColor3 = T.SliderFill
            fill.BorderSizePixel = 0
            fill.ZIndex = 5
            fill.Parent = bar
            Corner(fill, 3)
            
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 12, 0, 12)
            knob.Position = UDim2.new(pct, -6, 0.5, -6)
            knob.BackgroundColor3 = Color3.new(1,1,1)
            knob.BorderSizePixel = 0
            knob.ZIndex = 6
            knob.Parent = bar
            Corner(knob, 6)
            
            local dragging = false
            local ca = Instance.new("TextButton")
            ca.Size = UDim2.new(1, 10, 0, 20)
            ca.Position = UDim2.new(0, -5, 0, -7)
            ca.BackgroundTransparency = 1
            ca.Text = ""
            ca.ZIndex = 7
            ca.Parent = bar
            
            ca.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)
            table.insert(Connections, UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end))
            table.insert(Connections, UserInputService.InputChanged:Connect(function(inp)
                if not dragging then return end
                if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                    local mx = UserInputService:GetMouseLocation().X
                    local bx = bar.AbsolutePosition.X
                    local bw = bar.AbsoluteSize.X
                    local p = math.clamp((mx - bx) / bw, 0, 1)
                    local val = math.floor(min + (max - min) * p)
                    Settings[settingKey] = val
                    fill.Size = UDim2.new(p, 0, 1, 0)
                    knob.Position = UDim2.new(p, -6, 0.5, -6)
                    valLbl.Text = tostring(val)
                end
            end))
        end
        
        local function Button(page, name, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 32)
            btn.BackgroundColor3 = T.BtnBg
            btn.Text = name
            btn.TextColor3 = T.Text
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 11
            btn.ZIndex = 4
            btn.Parent = page
            Corner(btn, 10)
            Stroke(btn, T.Border, 1, 0.5)
            btn.MouseButton1Click:Connect(callback)
            btn.MouseEnter:Connect(function() Tw(btn, {BackgroundColor3 = T.BtnHov}, 0.12) end)
            btn.MouseLeave:Connect(function() Tw(btn, {BackgroundColor3 = T.BtnBg}, 0.12) end)
        end
        
        local function TextInput(page, labelText, defaultText, settingKey)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 36)
            f.BackgroundColor3 = T.SurfaceUp
            f.BackgroundTransparency = 0.15
            f.BorderSizePixel = 0
            f.ZIndex = 3
            f.Parent = page
            Corner(f, 10)
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0, 140, 1, 0)
            lbl.Position = UDim2.new(0, 12, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = labelText
            lbl.TextColor3 = T.TextSec
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 4
            lbl.Parent = f
            
            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, -160, 0, 24)
            box.Position = UDim2.new(0, 150, 0.5, -12)
            box.BackgroundColor3 = T.Bg
            box.Text = defaultText
            box.TextColor3 = T.Text
            box.Font = Enum.Font.Gotham
            box.TextSize = 10
            box.ZIndex = 5
            box.Parent = f
            Corner(box, 6)
            Stroke(box, T.Border, 1, 0.5)
            box.FocusLost:Connect(function()
                if settingKey == "SpamMessage" then Settings.SpamMessage = box.Text
                elseif settingKey == "AnnoyPlayerName" then Settings.AnnoyPlayerName = box.Text end
            end)
        end
        
        -- ============================================================
        -- BUILD TABS
        -- ============================================================
        
        -- VISUAL
        Section(Pages["Visual"], "ESP (PLAYERS)")
        Toggle(Pages["Visual"], "ESP Master", "ESPEnabled")
        Toggle(Pages["Visual"], "Name ESP", "NameESP")
        Toggle(Pages["Visual"], "Health ESP", "HealthESP")
        Toggle(Pages["Visual"], "Distance ESP", "DistanceESP")
        Toggle(Pages["Visual"], "Hat ESP", "HatESP")
        
        Section(Pages["Visual"], "HUD & OVERLAY")
        Toggle(Pages["Visual"], "Target HUD", "TargetHUD")
        Toggle(Pages["Visual"], "Watermark", "Watermark")
        
        Section(Pages["Visual"], "WORLD VISUALS")
        Toggle(Pages["Visual"], "Chams", "Chams")
        Toggle(Pages["Visual"], "RGB Shaders", "Shaders")
        Toggle(Pages["Visual"], "Rainbow Outline", "RainbowOutline")
        Slider(Pages["Visual"], "Shader Speed", 1, 15, 5, "ShaderSpeed")
        
        Section(Pages["Visual"], "LIGHTING")
        Toggle(Pages["Visual"], "FullBright", "FullBright")
        Toggle(Pages["Visual"], "Sky RGB", "SkyRGB")
        Slider(Pages["Visual"], "RGB Speed", 1, 15, 3, "SkyRGBSpeed")
        Toggle(Pages["Visual"], "No Fog", "NoFog")
        Toggle(Pages["Visual"], "Shadow Disable", "ShadowDisable")
        Toggle(Pages["Visual"], "Ambient RGB", "AmbientRGB")
        Toggle(Pages["Visual"], "X-Ray", "XRay")
        
        Section(Pages["Visual"], "CAMERA")
        Toggle(Pages["Visual"], "Third Person", "ThirdPerson")
        Toggle(Pages["Visual"], "FOV Changer", "FOVChanger")
        Slider(Pages["Visual"], "FOV Value", 30, 150, 90, "FOVValue")
        Toggle(Pages["Visual"], "Zoom Hack", "ZoomHack")
        Slider(Pages["Visual"], "Zoom Level", 1, 10, 2, "ZoomLevel")
        Toggle(Pages["Visual"], "Free Camera", "FreeCam")
        Slider(Pages["Visual"], "FreeCam Speed", 10, 100, 30, "FreeCamSpeed")
        
        -- COMBAT
        Section(Pages["Combat"], "AIMBOT")
        Toggle(Pages["Combat"], "Aimbot (Hold RMB)", "Aimbot")
        Slider(Pages["Combat"], "Aimbot FOV", 30, 360, 180, "AimbotFOV")
        Slider(Pages["Combat"], "Smoothness", 1, 20, 3, "AimbotSmooth")
        Toggle(Pages["Combat"], "Silent Aim", "SilentAim")
        
        Section(Pages["Combat"], "TRIGGER")
        Toggle(Pages["Combat"], "Trigger Bot (Hold RMB)", "TriggerBot")
        Toggle(Pages["Combat"], "Rapid Fire", "RapidFire")
        
        Section(Pages["Combat"], "GUN MODS")
        Toggle(Pages["Combat"], "No Recoil", "NoRecoil")
        Toggle(Pages["Combat"], "Wallbang", "Wallbang")
        
        Section(Pages["Combat"], "AURAS")
        Toggle(Pages["Combat"], "Kill Aura", "KillAura")
        Slider(Pages["Combat"], "Kill Aura Range", 5, 50, 20, "KillAuraRange")
        
        Section(Pages["Combat"], "HITBOX")
        Toggle(Pages["Combat"], "Hitbox Expander", "HitboxExpander")
        Slider(Pages["Combat"], "Hitbox Size", 2, 20, 5, "HitboxSize")
        
        -- MOVEMENT
        Section(Pages["Movement"], "SPEED")
        Toggle(Pages["Movement"], "Speed Hack", "SpeedHack")
        Slider(Pages["Movement"], "Speed Value", 20, 500, 50, "SpeedValue")
        Toggle(Pages["Movement"], "Infinite Jump", "InfiniteJump")
        Slider(Pages["Movement"], "Jump Power", 50, 500, 150, "JumpPower")
        
        Section(Pages["Movement"], "MODES")
        Toggle(Pages["Movement"], "Fly Mode (E/Q)", "FlyMode")
        Slider(Pages["Movement"], "Fly Speed", 20, 200, 50, "FlySpeed")
        Toggle(Pages["Movement"], "Bunny Hop", "BHop")
        Toggle(Pages["Movement"], "Auto Sprint", "AutoSprint")
        Toggle(Pages["Movement"], "Spider Climb", "SpiderClimb")
        Toggle(Pages["Movement"], "Water Walker", "WaterWalker")
        Toggle(Pages["Movement"], "Fake Lag", "FakeLag")
        
        Section(Pages["Movement"], "PHYSICS")
        Toggle(Pages["Movement"], "Low Gravity", "LowGravity")
        Slider(Pages["Movement"], "Gravity Value", 0, 196, 50, "GravityValue")
        Toggle(Pages["Movement"], "NoClip", "NoClip")
        
        Section(Pages["Movement"], "TELEPORT")
        Toggle(Pages["Movement"], "TP to Cursor", "TPCursor")
        Button(Pages["Movement"], "TP to Cursor (Mouse)", function()
            local hit = Mouse.Hit
            if hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(hit.Position + Vector3.new(0, 3, 0))
            end
        end)
        Button(Pages["Movement"], "Save Position", function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(SavedPositions, LocalPlayer.Character.HumanoidRootPart.CFrame)
            end
        end)
        Button(Pages["Movement"], "TP to Last Saved", function()
            if #SavedPositions > 0 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = SavedPositions[#SavedPositions]
            end
        end)
        Button(Pages["Movement"], "Clear Saved", function() SavedPositions = {} end)
        
        -- CHARACTER
        Section(Pages["Character"], "SPIN & SIZE")
        Toggle(Pages["Character"], "Character Spin", "CharSpin")
        Slider(Pages["Character"], "Spin Speed", 1, 50, 10, "SpinSpeed")
        Toggle(Pages["Character"], "Giant Head", "GiantHead")
        
        Section(Pages["Character"], "APPEARANCE")
        Toggle(Pages["Character"], "Invisible", "Invisible")
        Toggle(Pages["Character"], "Rainbow Character", "RainbowChar")
        Toggle(Pages["Character"], "No Animations", "NoAnim")
        Toggle(Pages["Character"], "Trail Effect", "TrailEffect")
        Toggle(Pages["Character"], "Fire Effect", "FireEffect")
        Toggle(Pages["Character"], "Sparkles", "Sparkles")
        
        -- WORLD
        Section(Pages["World"], "ENVIRONMENT")
        Toggle(Pages["World"], "Always Day", "DayTime")
        Toggle(Pages["World"], "Always Night", "NightTime")
        Toggle(Pages["World"], "Weather Manipulator", "WeatherManip")
        Slider(Pages["World"], "Weather (1=N 2=R 3=S)", 1, 3, 1, "WeatherType")
        Toggle(Pages["World"], "Auto Collect", "AutoCollect")
        
        Section(Pages["World"], "VEHICLE")
        Toggle(Pages["World"], "Car Fly", "CarFly")
        Toggle(Pages["World"], "Super Acceleration", "SuperAccel")
        
        Section(Pages["World"], "SERVER")
        Button(Pages["World"], "Server Hop", function()
            pcall(function()
                local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"
                local data = HttpService:JSONDecode(game:HttpGet(url))
                if data.data and #data.data > 0 then
                    local srv = data.data[math.random(1, #data.data)]
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, LocalPlayer)
                end
            end)
        end)
        Button(Pages["World"], "Rejoin Server", function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)
        
        -- DEFENSE
        Section(Pages["Defense"], "PROTECTION")
        Toggle(Pages["Defense"], "God Mode", "GodMode")
        Toggle(Pages["Defense"], "Semi God", "SemiGod")
        Toggle(Pages["Defense"], "Anti AFK", "AntiAFK")
        Toggle(Pages["Defense"], "Anti Void", "AntiVoid")
        
        Section(Pages["Defense"], "HVH")
        Toggle(Pages["Defense"], "Anti-Aim", "AntiAim")
        
        -- TROLL
        Section(Pages["Troll"], "CHAT")
        Toggle(Pages["Troll"], "Chat Spam", "ChatSpam")
        TextInput(Pages["Troll"], "Spam Message", Settings.SpamMessage, "SpamMessage")
        Button(Pages["Troll"], "Spam 10x", function()
            for i = 1, 10 do
                pcall(function()
                    local ch = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")
                    ch:SendAsync(Settings.SpamMessage .. " [" .. i .. "]")
                end)
                task.wait(0.2)
            end
        end)
        
        Section(Pages["Troll"], "AURAS")
        Toggle(Pages["Troll"], "Fling Aura", "FlingAura")
        Toggle(Pages["Troll"], "Annoy Player", "AnnoyPlayer")
        TextInput(Pages["Troll"], "Target Name", Settings.AnnoyPlayerName, "AnnoyPlayerName")
        
        Section(Pages["Troll"], "SERVER")
        Button(Pages["Troll"], "Fling All Players", function()
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local r = p.Character:FindFirstChild("HumanoidRootPart")
                    if r then r.Velocity = Vector3.new(math.random(-8000,8000), math.random(2000,8000), math.random(-8000,8000)) end
                end
            end
        end)
        Button(Pages["Troll"], "Bring All to Me", function()
            if LocalPlayer.Character then
                local mr = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if mr then
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character then
                            local pr = p.Character:FindFirstChild("HumanoidRootPart")
                            if pr then pr.CFrame = mr.CFrame * CFrame.new(math.random(-5,5),0,math.random(-5,5)) end
                        end
                    end
                end
            end
        end)
        
        -- PROFILE
        Section(Pages["Profile"], "USER PROFILE")
        
        local profileCard = Instance.new("Frame")
        profileCard.Size = UDim2.new(1, 0, 0, 110)
        profileCard.BackgroundColor3 = T.Surface
        profileCard.BorderSizePixel = 0
        profileCard.ZIndex = 4
        profileCard.Parent = Pages["Profile"]
        Corner(profileCard, 10)
        Stroke(profileCard, T.AccentDim, 1.5, 0.4)
        
        local avatarBg = Instance.new("Frame")
        avatarBg.Size = UDim2.new(0, 64, 0, 64)
        avatarBg.Position = UDim2.new(0, 18, 0, 23)
        avatarBg.BackgroundColor3 = T.SurfaceUp
        avatarBg.ZIndex = 5
        avatarBg.Parent = profileCard
        Corner(avatarBg, 32)
        Stroke(avatarBg, T.Accent, 2, 0.3)
        
        local avatarTxt = Instance.new("TextLabel")
        avatarTxt.Size = UDim2.new(1, 0, 1, 0)
        avatarTxt.BackgroundTransparency = 1
        avatarTxt.Text = string.sub(LocalPlayer.Name, 1, 2):upper()
        avatarTxt.TextColor3 = T.Accent
        avatarTxt.Font = Enum.Font.GothamBlack
        avatarTxt.TextSize = 22
        avatarTxt.ZIndex = 6
        avatarTxt.Parent = avatarBg
        
        pcall(function()
            local avatarImg = Instance.new("ImageLabel")
            avatarImg.Size = UDim2.new(1, 0, 1, 0)
            avatarImg.BackgroundTransparency = 1
            avatarImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png"
            avatarImg.ZIndex = 6
            avatarImg.Parent = avatarBg
            Corner(avatarImg, 32)
        end)
        
        local pUsername = Instance.new("TextLabel")
        pUsername.Size = UDim2.new(1, -105, 0, 22)
        pUsername.Position = UDim2.new(0, 98, 0, 20)
        pUsername.BackgroundTransparency = 1
        pUsername.Text = LocalPlayer.DisplayName
        pUsername.TextColor3 = T.Text
        pUsername.Font = Enum.Font.GothamBlack
        pUsername.TextSize = 18
        pUsername.TextXAlignment = Enum.TextXAlignment.Left
        pUsername.ZIndex = 5
        pUsername.Parent = profileCard
        
        local pHandle = Instance.new("TextLabel")
        pHandle.Size = UDim2.new(1, -105, 0, 16)
        pHandle.Position = UDim2.new(0, 98, 0, 44)
        pHandle.BackgroundTransparency = 1
        pHandle.Text = "@" .. LocalPlayer.Name
        pHandle.TextColor3 = T.TextDim
        pHandle.Font = Enum.Font.Gotham
        pHandle.TextSize = 12
        pHandle.TextXAlignment = Enum.TextXAlignment.Left
        pHandle.ZIndex = 5
        pHandle.Parent = profileCard
        
        local pId = Instance.new("TextLabel")
        pId.Size = UDim2.new(1, -105, 0, 14)
        pId.Position = UDim2.new(0, 98, 0, 62)
        pId.BackgroundTransparency = 1
        pId.Text = "ID: " .. LocalPlayer.UserId .. "  |  Age: " .. LocalPlayer.AccountAge .. " days"
        pId.TextColor3 = T.TextMuted
        pId.Font = Enum.Font.Gotham
        pId.TextSize = 10
        pId.TextXAlignment = Enum.TextXAlignment.Left
        pId.ZIndex = 5
        pId.Parent = profileCard
        
        local pPlaytime = Instance.new("TextLabel")
        pPlaytime.Size = UDim2.new(1, -105, 0, 14)
        pPlaytime.Position = UDim2.new(0, 98, 0, 78)
        pPlaytime.BackgroundTransparency = 1
        pPlaytime.Text = "Session: 00:00:00"
        pPlaytime.TextColor3 = T.Cyan
        pPlaytime.Font = Enum.Font.GothamBold
        pPlaytime.TextSize = 11
        pPlaytime.TextXAlignment = Enum.TextXAlignment.Left
        pPlaytime.ZIndex = 5
        pPlaytime.Parent = profileCard
        
        Section(Pages["Profile"], "GAME INFO")
        
        local gameName = "Unknown"
        pcall(function() gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name end)
        
        local gameCard = Instance.new("Frame")
        gameCard.Size = UDim2.new(1, 0, 0, 84)
        gameCard.BackgroundColor3 = T.Surface
        gameCard.BorderSizePixel = 0
        gameCard.ZIndex = 4
        gameCard.Parent = Pages["Profile"]
        Corner(gameCard, 10)
        Stroke(gameCard, T.Border, 1.5, 0.4)
        
        local gIcon = Instance.new("Frame")
        gIcon.Size = UDim2.new(0, 44, 0, 44)
        gIcon.Position = UDim2.new(0, 14, 0, 13)
        gIcon.BackgroundColor3 = T.SurfaceUp
        gIcon.ZIndex = 5
        gIcon.Parent = gameCard
        Corner(gIcon, 10)
        pcall(function()
            local gImg = Instance.new("ImageLabel")
            gImg.Size = UDim2.new(1, 0, 1, 0)
            gImg.BackgroundTransparency = 1
            gImg.Image = "rbxthumb://type=Asset&id=" .. game.PlaceId .. "&w=150&h=150"
            gImg.ZIndex = 6
            gImg.Parent = gIcon
            Corner(gImg, 10)
        end)
        
        local gName = Instance.new("TextLabel")
        gName.Size = UDim2.new(1, -75, 0, 20)
        gName.Position = UDim2.new(0, 70, 0, 12)
        gName.BackgroundTransparency = 1
        gName.Text = gameName
        gName.TextColor3 = T.Text
        gName.Font = Enum.Font.GothamBold
        gName.TextSize = 13
        gName.TextXAlignment = Enum.TextXAlignment.Left
        gName.ZIndex = 5
        gName.Parent = gameCard
        gName.TextTruncate = Enum.TextTruncate.AtEnd
        
        local gDetails = Instance.new("TextLabel")
        gDetails.Size = UDim2.new(1, -75, 0, 14)
        gDetails.Position = UDim2.new(0, 70, 0, 34)
        gDetails.BackgroundTransparency = 1
        gDetails.Text = "Place ID: " .. game.PlaceId .. "  |  Players: " .. #Players:GetPlayers() .. "/" .. (Players.MaxPlayers or "?")
        gDetails.TextColor3 = T.TextMuted
        gDetails.Font = Enum.Font.Gotham
        gDetails.TextSize = 10
        gDetails.TextXAlignment = Enum.TextXAlignment.Left
        gDetails.ZIndex = 5
        gDetails.Parent = gameCard
        
        local gServerIP = Instance.new("TextLabel")
        gServerIP.Size = UDim2.new(1, -75, 0, 14)
        gServerIP.Position = UDim2.new(0, 70, 0, 48)
        gServerIP.BackgroundTransparency = 1
        gServerIP.Text = "JobId: " .. string.sub(game.JobId, 1, 8) .. "..."
        gServerIP.TextColor3 = T.TextMuted
        gServerIP.Font = Enum.Font.Gotham
        gServerIP.TextSize = 10
        gServerIP.TextXAlignment = Enum.TextXAlignment.Left
        gServerIP.ZIndex = 5
        gServerIP.Parent = gameCard
        
        local gPing = Instance.new("TextLabel")
        gPing.Size = UDim2.new(1, -75, 0, 14)
        gPing.Position = UDim2.new(0, 70, 0, 62)
        gPing.BackgroundTransparency = 1
        gPing.Text = "Ping: 0ms"
        gPing.TextColor3 = T.Cyan
        gPing.Font = Enum.Font.GothamBold
        gPing.TextSize = 10
        gPing.TextXAlignment = Enum.TextXAlignment.Left
        gPing.ZIndex = 5
        gPing.Parent = gameCard
        
        Section(Pages["Profile"], "CONFIGURATION")
        local ConfigName = "Santes_Config.json"
        
        local function SaveConfig()
            local save = {Settings = {}, Keybinds = {}, HoldMode = {}}
            for k, v in pairs(Settings) do save.Settings[k] = v end
            for k, v in pairs(Keybinds) do if v then save.Keybinds[k] = v.Name end end
            for k, v in pairs(HoldMode) do save.HoldMode[k] = v end
            if writefile then
                pcall(function() writefile(ConfigName, HttpService:JSONEncode(save)) end)
                StarterGui:SetCore("SendNotification", {Title = "SANTES HUB", Text = "Config Saved!", Duration = 3})
            end
        end
        
        local function LoadConfig()
            if readfile and isfile and isfile(ConfigName) then
                local s, data = pcall(function() return HttpService:JSONDecode(readfile(ConfigName)) end)
                if s and data then
                    if data.Settings then
                        for k, v in pairs(data.Settings) do Settings[k] = v end
                    end
                    if data.Keybinds then
                        for k, v in pairs(data.Keybinds) do
                            pcall(function() Keybinds[k] = Enum.KeyCode[v] end)
                            pcall(function() if not Keybinds[k] then Keybinds[k] = Enum.UserInputType[v] end end)
                        end
                    end
                    if data.HoldMode then
                        for k, v in pairs(data.HoldMode) do HoldMode[k] = v end
                    end
                    for _, ref in pairs(ToggleRefs) do
                        if ref.UpdateVisual then ref.UpdateVisual() end
                    end
                    UpdateActivePanel()
                    StarterGui:SetCore("SendNotification", {Title = "SANTES HUB", Text = "Config Loaded!", Duration = 3})
                end
            end
        end
        
        Button(Pages["Profile"], "Save Config", SaveConfig)
        Button(Pages["Profile"], "Load Config", LoadConfig)
        
        Section(Pages["Profile"], "SYSTEM")
        Button(Pages["Profile"], "Reset All", function()
            ResetAll()
            CreateESP()
            UpdateActivePanel()
            for _, ref in pairs(ToggleRefs) do if ref.UpdateVisual then ref.UpdateVisual() end end
        end)
        Button(Pages["Profile"], "Destroy GUI", function()
            ResetAll()
            gui:Destroy()
            MenuOpen = false
            SantesGui = nil
        end)
        
        -- ============================================================
        -- ACTIVE HUD
        -- ============================================================
        local activeHud = Instance.new("Frame")
        activeHud.Name = "ActiveHUD"
        activeHud.Size = UDim2.new(0, 200, 0, 300)
        activeHud.Position = UDim2.new(1, -210, 0, 10)
        activeHud.BackgroundTransparency = 1
        activeHud.ZIndex = 10
        activeHud.Parent = gui
        
        local hudList = Instance.new("UIListLayout")
        hudList.Padding = UDim.new(0, 2)
        hudList.Parent = activeHud
        
        local function UpdateActiveHUD()
            for _, child in pairs(activeHud:GetChildren()) do
                if child:IsA("TextLabel") then child:Destroy() end
            end
            for k, def in pairs(FeatureDefs) do
                if Settings[k] then
                    local lbl = Instance.new("TextLabel")
                    lbl.Size = UDim2.new(1, 0, 0, 18)
                    lbl.BackgroundColor3 = Color3.fromRGB(0,0,0)
                    lbl.BackgroundTransparency = 0.5
                    lbl.Text = "  ✔ " .. def.name
                    lbl.TextColor3 = T.Green
                    lbl.Font = Enum.Font.GothamBold
                    lbl.TextSize = 10
                    lbl.TextXAlignment = Enum.TextXAlignment.Left
                    lbl.ZIndex = 11
                    lbl.Parent = activeHud
                    Corner(lbl, 4)
                end
            end
        end
        table.insert(Connections, RunService.RenderStepped:Connect(UpdateActiveHUD))
        
        return gui, MainFrame, footerR, ToggleRefs, pPlaytime, gPing
    end

    -- ============================================================
    -- RESET ALL
    -- ============================================================
    local function ResetAll()
        for k, def in pairs(FeatureDefs) do
            if Settings[k] then
                if k == "NoRecoil" then NoRecoil_Disable() end
            end
            Settings[k] = def.default
        end
        pcall(function()
            Lighting.Brightness = Originals.Brightness
            Lighting.GlobalShadows = Originals.GlobalShadows
            Lighting.FogEnd = Originals.FogEnd
            Lighting.FogStart = Originals.FogStart
            Lighting.ClockTime = Originals.ClockTime
            Lighting.Ambient = Originals.Ambient
            Lighting.OutdoorAmbient = Originals.OutdoorAmbient
            Workspace.Gravity = Originals.Gravity
            Camera.FieldOfView = Originals.FOV
        end)
        if FlyBodyVelocity then FlyBodyVelocity:Destroy(); FlyBodyVelocity = nil end
        if FlyBodyGyro then FlyBodyGyro:Destroy(); FlyBodyGyro = nil end
        for _, t in pairs(TrailEffects) do pcall(function() t:Destroy() end) end; TrailEffects = {}
        for _, f in pairs(FireEffects) do pcall(function() f:Destroy() end) end; FireEffects = {}
        for _, s in pairs(SparkleEffects) do pcall(function() s:Destroy() end) end; SparkleEffects = {}
        if ESPFolder then ESPFolder:Destroy(); ESPFolder = nil end
    end

    -- ============================================================
    -- UPDATE ACTIVE PANEL
    -- ============================================================
    local function UpdateActivePanel()
        if not ActiveFeaturesPanel then return end
        for _, child in pairs(ActiveFeaturesPanel:GetChildren()) do
            if child:IsA("TextLabel") and child.Name == "ActiveItem" then
                child:Destroy()
            end
        end
        
        local count = 0
        for k, def in pairs(FeatureDefs) do
            if Settings[k] then
                count = count + 1
                local lbl = Instance.new("TextLabel")
                lbl.Name = "ActiveItem"
                lbl.Size = UDim2.new(1, 0, 0, 18)
                lbl.BackgroundColor3 = T.SurfaceUp
                lbl.BackgroundTransparency = 0.3
                lbl.Text = "  • " .. def.name
                lbl.TextColor3 = T.Green
                lbl.Font = Enum.Font.GothamBold
                lbl.TextSize = 8
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.ZIndex = 5
                lbl.Parent = ActiveFeaturesPanel
                Corner(lbl, 3)
            end
        end
        
        if count == 0 then
            local lbl = Instance.new("TextLabel")
            lbl.Name = "ActiveItem"
            lbl.Size = UDim2.new(1, 0, 0, 18)
            lbl.BackgroundTransparency = 1
            lbl.Text = "  No active features"
            lbl.TextColor3 = T.TextMuted
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 8
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 5
            lbl.Parent = ActiveFeaturesPanel
        end
    end

    -- ============================================================
    -- INIT
    -- ============================================================
    local GUI, MainF, FooterR, TogRefs, PlaytimeLbl, PingLbl = CreateUI()
    CreateESP()
    ToggleRefs = TogRefs or {}

    -- ============================================================
    -- KEYBIND INPUT
    -- ============================================================
    local keyInputConn = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe and input.UserInputType == Enum.UserInputType.Keyboard then return end
        
        if Settings.TPCursor and input.UserInputType == Enum.UserInputType.MouseButton1 and not gpe then
            local hit = Mouse.Hit
            if hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(hit.Position + Vector3.new(0, 3, 0))
            end
        end
        
        local inputKey = nil
        
        if input.UserInputType == Enum.UserInputType.Keyboard then
            inputKey = input.KeyCode
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            inputKey = Enum.UserInputType.MouseButton1
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            inputKey = Enum.UserInputType.MouseButton2
        elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
            inputKey = Enum.UserInputType.MouseButton3
        end
        pcall(function()
            if input.UserInputType == Enum.UserInputType.MouseButton4 then inputKey = Enum.UserInputType.MouseButton4 end
            if input.UserInputType == Enum.UserInputType.MouseButton5 then inputKey = Enum.UserInputType.MouseButton5 end
        end)
        
        if inputKey == nil then return end
        
        if KeybindListening then
            if inputKey == Enum.KeyCode.Insert or inputKey == Enum.KeyCode.RightShift or inputKey == Enum.KeyCode.RightControl then return end
            if inputKey == Enum.KeyCode.Escape then
                Keybinds[KeybindListening] = nil
                for _, ref in pairs(ToggleRefs) do
                    if ref.key == KeybindListening then
                        ref.keyBtn.Text = "[---]"
                        ref.keyBtn.BackgroundColor3 = T.BtnBg
                    end
                end
                KeybindListening = nil
                return
            end
            
            Keybinds[KeybindListening] = inputKey
            for _, ref in pairs(ToggleRefs) do
                if ref.key == KeybindListening then
                    ref.keyBtn.Text = "[" .. GetKeyName(inputKey) .. "]"
                    ref.keyBtn.BackgroundColor3 = T.BtnBg
                end
            end
            KeybindListening = nil
            return
        end
        
        if inputKey == Enum.KeyCode.Insert or inputKey == Enum.KeyCode.RightShift or inputKey == Enum.KeyCode.RightControl then
            MenuOpen = not MenuOpen
            if MenuOpen then
                MainFrame.Visible = true
                MainFrame.Size = UDim2.new(0, 0, 0, 0)
                MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
                Tw(MainFrame, {Size = UDim2.new(0, 780, 0, 540), Position = UDim2.new(0.5, -390, 0.5, -270)}, 0.3, Enum.EasingStyle.Back)
            else
                Tw(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.2)
                task.delay(0.2, function() if not MenuOpen then MainFrame.Visible = false end end)
            end
            return
        end
        
        for settingKey, boundKey in pairs(Keybinds) do
            if boundKey and inputKey == boundKey and FeatureDefs[settingKey] then
                if settingKey == "TPCursor" then
                    local hit = Mouse.Hit
                    if hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(hit.Position + Vector3.new(0, 3, 0))
                    end
                elseif HoldMode[settingKey] then
                    if not Settings[settingKey] then
                        ToggleFeature(settingKey, true)
                        HeldKeys[settingKey] = true
                        for _, ref in pairs(ToggleRefs) do
                            if ref.key == settingKey and ref.UpdateVisual then ref.UpdateVisual() end
                        end
                    end
                else
                    ToggleFeature(settingKey)
                    for _, ref in pairs(ToggleRefs) do
                        if ref.key == settingKey and ref.UpdateVisual then ref.UpdateVisual() end
                    end
                end
            end
        end
    end)
    table.insert(Connections, keyInputConn)

    local keyReleaseConn = UserInputService.InputEnded:Connect(function(input)
        local inputKey = nil
        if input.UserInputType == Enum.UserInputType.Keyboard then
            inputKey = input.KeyCode
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            inputKey = Enum.UserInputType.MouseButton1
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            inputKey = Enum.UserInputType.MouseButton2
        elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
            inputKey = Enum.UserInputType.MouseButton3
        end
        pcall(function()
            if input.UserInputType == Enum.UserInputType.MouseButton4 then inputKey = Enum.UserInputType.MouseButton4 end
            if input.UserInputType == Enum.UserInputType.MouseButton5 then inputKey = Enum.UserInputType.MouseButton5 end
        end)
        
        if inputKey == nil then return end
        
        for settingKey, boundKey in pairs(Keybinds) do
            if boundKey and inputKey == boundKey and HoldMode[settingKey] and HeldKeys[settingKey] then
                ToggleFeature(settingKey, false)
                HeldKeys[settingKey] = false
                for _, ref in pairs(ToggleRefs) do
                    if ref.key == settingKey and ref.UpdateVisual then ref.UpdateVisual() end
                end
            end
        end
    end)
    table.insert(Connections, keyReleaseConn)

    -- ============================================================
    -- MAIN LOOP
    -- ============================================================
    local lastPanelUpdate = 0
    local mainConn = RunService.RenderStepped:Connect(function()
        -- Visual
        if Settings.FullBright then
            Lighting.Brightness = 3
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100000
            Lighting.FogStart = 100000
        end
        if Settings.SkyRGB then
            Lighting.ClockTime = Lighting.ClockTime + Settings.SkyRGBSpeed * 0.01
            if Settings.AmbientRGB then
                local c = GetRainbow(Settings.SkyRGBSpeed)
                Lighting.Ambient = c
                Lighting.OutdoorAmbient = c
            end
        end
        if Settings.NoFog then
            Lighting.FogEnd = 100000
            Lighting.FogStart = 100000
        end
        if Settings.ShadowDisable then Lighting.GlobalShadows = false end
        if Settings.DayTime then Lighting.ClockTime = 14 end
        if Settings.NightTime then Lighting.ClockTime = 0 end
        
        if Settings.WeatherManip then
            if Settings.WeatherType == 1 then
                Lighting.ClockTime = 0
                Lighting.Ambient = Color3.fromRGB(0,0,0)
            elseif Settings.WeatherType == 2 then
                Lighting.Ambient = Color3.fromRGB(255,50,50)
                Lighting.OutdoorAmbient = Color3.fromRGB(255,0,0)
                Lighting.FogColor = Color3.fromRGB(100,0,0)
                Lighting.FogEnd = 500
            end
        end
        
        if Settings.TargetHUD then
            local target = nil
            local short = Settings.AimbotFOV
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChildOfClass("Humanoid") then
                    local sp, on = Camera:WorldToViewportPoint(plr.Character.Head.Position)
                    if on then
                        local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                        if d < short then short = d; target = plr end
                    end
                end
            end
            if target and target.Character then
                TargetHUD.Visible = true
                TargetName.Text = target.Name
                local thum = target.Character:FindFirstChildOfClass("Humanoid")
                if thum then
                    local pct = math.clamp(thum.Health / thum.MaxHealth, 0, 1)
                    TargetHP.Size = UDim2.new(pct, 0, 1, 0)
                    TargetHP.BackgroundColor3 = Color3.fromRGB((1-pct)*255, pct*255, 0)
                end
                pcall(function()
                    TargetFace.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. target.UserId .. "&width=150&height=150&format=png"
                end)
            else
                TargetHUD.Visible = false
            end
        else
            if TargetHUD then TargetHUD.Visible = false end
        end
        
        if Settings.XRay then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Transparency < 0.5 then
                    local isPl = false
                    for _, p in pairs(Players:GetPlayers()) do
                        if p.Character and v:IsDescendantOf(p.Character) then isPl = true; break end
                    end
                    if not isPl then v.LocalTransparencyModifier = 0.7 end
                end
            end
        end
        
        if not LocalPlayer.Character then return end
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        
        -- Movement
        if Settings.SpeedHack then
            if hum.MoveDirection.Magnitude > 0 then
                root.CFrame = root.CFrame + (hum.MoveDirection * (Settings.SpeedValue * 0.01))
            end
        end
        if Settings.AutoSprint and hum.MoveDirection.Magnitude > 0 and not Settings.SpeedHack then
            hum.WalkSpeed = 32
        end
        if Settings.LowGravity then Workspace.Gravity = Settings.GravityValue end
        if Settings.NoClip then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
        if Settings.SpiderClimb then
            local ray = Ray.new(root.Position, root.CFrame.LookVector * 3)
            local part, pos, norm = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
            if part then
                FlyBodyVelocity = FlyBodyVelocity or Instance.new("BodyVelocity", root)
                FlyBodyVelocity.MaxForce = Vector3.new(1,1,1) * math.huge
                FlyBodyVelocity.Velocity = Vector3.new(0, 50, 0)
            elseif FlyBodyVelocity and not Settings.FlyMode then
                FlyBodyVelocity:Destroy()
                FlyBodyVelocity = nil
            end
        end
        if Settings.WaterWalker then
            local state = hum:GetState()
            if state == Enum.HumanoidStateType.Swimming then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z)
            end
        end
        if Settings.FakeLag then
            pcall(function()
                if root.Anchored == false then
                    root.Anchored = true
                    task.wait(0.1)
                    root.Anchored = false
                end
            end)
        end
        
        -- Fly
        if Settings.FlyMode then
            if not FlyBodyVelocity or not FlyBodyVelocity.Parent then
                FlyBodyVelocity = Instance.new("BodyVelocity")
                FlyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                FlyBodyVelocity.Velocity = Vector3.zero
                FlyBodyVelocity.Parent = root
                FlyBodyGyro = Instance.new("BodyGyro")
                FlyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                FlyBodyGyro.D = 200
                FlyBodyGyro.P = 40000
                FlyBodyGyro.Parent = root
            end
            hum.PlatformStand = true
            local dir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then dir = dir + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then dir = dir + Vector3.new(0,-1,0) end
            FlyBodyVelocity.Velocity = dir.Magnitude > 0 and dir.Unit * Settings.FlySpeed or Vector3.zero
            FlyBodyGyro.CFrame = Camera.CFrame
        else
            if FlyBodyVelocity and FlyBodyVelocity.Parent then FlyBodyVelocity:Destroy(); FlyBodyVelocity = nil end
            if FlyBodyGyro and FlyBodyGyro.Parent then FlyBodyGyro:Destroy(); FlyBodyGyro = nil end
        end
        
        -- Camera
        if Settings.FreeCam then
            Camera.CameraType = Enum.CameraType.Scriptable
            local speed = Settings.FreeCamSpeed * 0.5
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then Camera.CFrame = Camera.CFrame + Camera.CFrame.LookVector * speed end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then Camera.CFrame = Camera.CFrame - Camera.CFrame.LookVector * speed end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then Camera.CFrame = Camera.CFrame - Camera.CFrame.RightVector * speed end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then Camera.CFrame = Camera.CFrame + Camera.CFrame.RightVector * speed end
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then Camera.CFrame = Camera.CFrame + Vector3.new(0, speed, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then Camera.CFrame = Camera.CFrame - Vector3.new(0, speed, 0) end
        end
        
        -- Character
        if Settings.CharSpin then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0) end
        if Settings.GiantHead then
            local head = LocalPlayer.Character:FindFirstChild("Head")
            if head then head.Size = Vector3.new(4, 2, 2) end
        end
        if Settings.Invisible then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.LocalTransparencyModifier = 0.9 end
            end
        end
        if Settings.RainbowChar then
            local c = GetRainbow(5)
            local hl = LocalPlayer.Character:FindFirstChild("RainbowHL")
            if not hl then
                hl = Instance.new("Highlight")
                hl.Name = "RainbowHL"
                hl.FillTransparency = 0.5
                hl.OutlineTransparency = 0
                hl.Parent = LocalPlayer.Character
            end
            hl.FillColor = c
            hl.OutlineColor = c
        else
            local hl = LocalPlayer.Character:FindFirstChild("RainbowHL")
            if hl then hl:Destroy() end
        end
        if Settings.NoAnim then
            local anim = hum:FindFirstChildOfClass("Animator")
            if anim then for _, t in pairs(anim:GetPlayingAnimationTracks()) do t:Stop(0) end end
        end
        
        -- Effects
        if Settings.TrailEffect then
            if #TrailEffects == 0 then
                local torso = LocalPlayer.Character:FindFirstChild("UpperTorso") or LocalPlayer.Character:FindFirstChild("Torso")
                if torso then
                    local a0 = Instance.new("Attachment")
                    a0.Position = Vector3.new(0,1,0)
                    a0.Parent = torso
                    local a1 = Instance.new("Attachment")
                    a1.Position = Vector3.new(0,-1,0)
                    a1.Parent = torso
                    local tr = Instance.new("Trail")
                    tr.Attachment0 = a0
                    tr.Attachment1 = a1
                    tr.Lifetime = 0.5
                    tr.MinLength = 0.1
                    tr.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, T.AccentGlow), ColorSequenceKeypoint.new(1, T.AccentDim)})
                    tr.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)})
                    tr.Parent = torso
                    table.insert(TrailEffects, a0)
                    table.insert(TrailEffects, a1)
                    table.insert(TrailEffects, tr)
                end
            end
        else
            if #TrailEffects > 0 then for _,t in pairs(TrailEffects) do pcall(function() t:Destroy() end) end; TrailEffects = {} end
        end
        if Settings.FireEffect then
            if #FireEffects == 0 then
                local torso = LocalPlayer.Character:FindFirstChild("UpperTorso") or LocalPlayer.Character:FindFirstChild("Torso")
                if torso then
                    local f = Instance.new("Fire")
                    f.Size = 5
                    f.Heat = 10
                    f.Color = T.AccentGlow
                    f.SecondaryColor = T.AccentDim
                    f.Parent = torso
                    table.insert(FireEffects, f)
                end
            end
        else
            if #FireEffects > 0 then for _,f in pairs(FireEffects) do pcall(function() f:Destroy() end) end; FireEffects = {} end
        end
        if Settings.Sparkles then
            if #SparkleEffects == 0 then
                local torso = LocalPlayer.Character:FindFirstChild("UpperTorso") or LocalPlayer.Character:FindFirstChild("Torso")
                if torso then
                    local sp = Instance.new("Sparkles")
                    sp.SparkleColor = T.AccentGlow
                    sp.Parent = torso
                    table.insert(SparkleEffects, sp)
                end
            end
        else
            if #SparkleEffects > 0 then for _,s in pairs(SparkleEffects) do pcall(function() s:Destroy() end) end; SparkleEffects = {} end
        end
        
        -- Defense
        if Settings.GodMode then hum.MaxHealth = math.huge; hum.Health = math.huge end
        if Settings.SemiGod and hum.Health < hum.MaxHealth * 0.99 then hum.Health = hum.MaxHealth end
        if Settings.AntiVoid and root.Position.Y < -200 then root.CFrame = CFrame.new(0,100,0); root.Velocity = Vector3.zero end
        
        if Settings.AntiAim then
            if hum.MoveDirection.Magnitude == 0 then
                root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(45), 0)
                local head = LocalPlayer.Character:FindFirstChild("Head")
                if head then head.Velocity = Vector3.new(0, -500, 0) end
            end
        end
        
        -- Vehicle
        local seat = hum.SeatPart
        if seat and seat:IsA("VehicleSeat") then
            if Settings.SuperAccel then
                if seat.Throttle > 0 then
                    seat.AssemblyLinearVelocity = seat.CFrame.LookVector * 500
                end
            end
            if Settings.CarFly then
                local vel = seat:FindFirstChild("Santes_CarFly")
                if not vel then
                    vel = Instance.new("BodyVelocity")
                    vel.Name = "Santes_CarFly"
                    vel.MaxForce = Vector3.new(1,1,1)*math.huge
                    vel.Parent = seat
                end
                local dir = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.E) then dir = dir + Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.Q) then dir = dir - Vector3.new(0,1,0) end
                vel.Velocity = dir.Magnitude > 0 and dir.Unit * 150 or Vector3.zero
            else
                local vel = seat:FindFirstChild("Santes_CarFly")
                if vel then vel:Destroy() end
            end
        end
        
        -- Combat
        if Settings.Aimbot then DoAimbot() end
        if Settings.TriggerBot then DoTriggerBot() end
        
        if Settings.KillAura then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local pr = p.Character.HumanoidRootPart
                    local dist = (root.Position - pr.Position).Magnitude
                    if dist <= Settings.KillAuraRange then
                        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool and tool:FindFirstChild("Handle") then
                            firetouchinterest(tool.Handle, pr, 0)
                            firetouchinterest(tool.Handle, pr, 1)
                        end
                    end
                end
            end
        end
        
        -- Troll
        if Settings.FlingAura then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local pr = p.Character.HumanoidRootPart
                    local dist = (root.Position - pr.Position).Magnitude
                    if dist <= 15 then
                        pr.Velocity = Vector3.new(math.random(-500,500), 1000, math.random(-500,500))
                        pr.RotVelocity = Vector3.new(1000,1000,1000)
                    end
                end
            end
        end
        
        if Settings.AnnoyPlayer and Settings.AnnoyPlayerName ~= "" then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Name:lower():match(Settings.AnnoyPlayerName:lower()) then
                    if p.Character and p.Character:FindFirstChild("Head") then
                        root.CFrame = p.Character.Head.CFrame * CFrame.new(0, 3, 0)
                    end
                end
            end
        end
        
        -- Hitbox Expander
        if Settings.HitboxExpander then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local r = p.Character:FindFirstChild("HumanoidRootPart")
                    if r then
                        r.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                        r.Transparency = 0.7
                        r.CanCollide = false
                    end
                end
            end
        end
        
        -- ESP
        UpdateESP()
        
        -- Active features panel
        local now = tick()
        if now - lastPanelUpdate > 0.5 then
            lastPanelUpdate = now
            UpdateActivePanel()
        end
        
        -- Footer
        pcall(function()
            if FooterR then
                local ping = 0
                pcall(function() ping = math.floor(Stats.PerformanceStats.Ping:GetValue() * 1000) end)
                local pt = FormatTime(os.time() - StartTime)
                FooterR.Text = "Ping: " .. ping .. "ms | Session: " .. pt
            end
            if PlaytimeLbl then
                PlaytimeLbl.Text = "Session: " .. FormatTime(os.time() - StartTime)
            end
            if PingLbl then
                local ping = 0
                pcall(function() ping = math.floor(Stats.PerformanceStats.Ping:GetValue() * 1000) end)
                PingLbl.Text = "Ping: " .. ping .. "ms"
            end
        end)
    end)
    table.insert(Connections, mainConn)

    -- ============================================================
    -- BACKGROUND TASKS
    -- ============================================================
    task.spawn(function()
        while task.wait(30) do
            if Settings.AntiAFK then
                pcall(function()
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                end)
            end
        end
    end)

    task.spawn(function()
        while task.wait(4) do
            if Settings.ChatSpam then
                pcall(function()
                    local ch = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")
                    ch:SendAsync(Settings.SpamMessage)
                end)
            end
        end
    end)

    task.spawn(function()
        while task.wait(0.05) do
            if Settings.RapidFire and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                pcall(function() mouse1click() end)
            end
        end
    end)

    -- ============================================================
    -- BUNNY HOP & INFINITE JUMP
    -- ============================================================
    local bhopConn = RunService.Heartbeat:Connect(function()
        if Settings.BHop and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                local state = hum:GetState()
                if state == Enum.HumanoidStateType.Running
                    or state == Enum.HumanoidStateType.RunningNoPhysics
                    or state == Enum.HumanoidStateType.Landed then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
    end)
    table.insert(Connections, bhopConn)

    local infJumpConn = UserInputService.JumpRequest:Connect(function()
        if Settings.InfiniteJump then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)
    table.insert(Connections, infJumpConn)

    -- ============================================================
    -- NOTIFICATION
    -- ============================================================
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "SANTES HUB ULTIMATE",
            Text = "Loaded! INSERT to toggle menu.",
            Duration = 4
        })
    end)

    print("==================================")
    print("   SANTES HUB ULTIMATE")
    print("   INSERT = Toggle Menu")
    print("   All Features + Keybinds Ready")
    print("   Mouse 1-5 Supported")
    print("==================================")

end

-- ============================================================
-- RUN
-- ============================================================
SantesHub()
