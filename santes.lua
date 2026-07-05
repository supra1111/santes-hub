--[[
    ╔══════════════════════════════════════════════╗
    ║          S A N T E S   H U B                ║
    ║         ULTIMATE EDITION v7.0               ║
    ╚══════════════════════════════════════════════╝
    
    ✦ Silent Aim (WallCheck ile - duvar arkasına vurmaz)
    ✦ Aimbot (Smooth)
    ✦ ESP (Name, Health, Distance)
    ✦ No Recoil (GERÇEK)
    ✦ Anti AFK (OTOMATİK)
    ✦ Fly, Speed, Infinite Jump, Noclip, FullBright
]]

local function SantesHub()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")
    local CoreGui = game:GetService("CoreGui")
    local VirtualUser = game:GetService("VirtualUser")
    local StarterGui = game:GetService("StarterGui")
    local Stats = game:GetService("Stats")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local Camera = workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    -- Eski UI temizle
    for _, old in ipairs(PlayerGui:GetChildren()) do
        if old.Name == "SantesHub" then old:Destroy() end
    end

    -- ============================================================
    -- ANTI AFK (OTOMATİK - AÇIK KALIR)
    -- ============================================================
    if LocalPlayer then
        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end

    -- ============================================================
    -- STATE
    -- ============================================================
    local MenuOpen = true
    local ESPFolder = nil
    local FlyBodyVelocity = nil
    local FlyBodyGyro = nil
    local StartTime = os.time()
    local SantesGui = nil
    local MainFrame = nil
    local ToggleRefs = {}
    local Connections = {}
    local SilentAimTarget = nil
    local SilentAimActive = false

    -- ============================================================
    -- SETTINGS
    -- ============================================================
    local Settings = {
        ESP = false,
        NameESP = false,
        HealthESP = false,
        DistanceESP = false,
        NoRecoil = false,
        Fly = false,
        Speed = false,
        InfiniteJump = false,
        Noclip = false,
        FullBright = false,
        Aimbot = false,
        SilentAim = false,
        WallCheck = true,
    }

    local SpeedValue = 50
    local FlySpeed = 50
    local AimbotFOV = 180
    local AimbotSmooth = 3

    -- ============================================================
    -- ORIGINALS
    -- ============================================================
    local Originals = {
        Brightness = Lighting.Brightness,
        GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart,
        WalkSpeed = 16,
        JumpPower = 50,
    }

    -- ============================================================
    -- THEME
    -- ============================================================
    local T = {
        Bg          = Color3.fromRGB(8, 10, 18),
        Surface     = Color3.fromRGB(15, 20, 35),
        SurfaceUp   = Color3.fromRGB(20, 26, 45),
        Accent      = Color3.fromRGB(255, 38, 52),
        AccentBright= Color3.fromRGB(255, 70, 85),
        Text        = Color3.fromRGB(235, 240, 255),
        TextSec     = Color3.fromRGB(150, 165, 195),
        TextMuted   = Color3.fromRGB(60, 70, 90),
        Border      = Color3.fromRGB(30, 40, 65),
        ToggleOn    = Color3.fromRGB(255, 38, 52),
        ToggleOff   = Color3.fromRGB(35, 42, 58),
        Green       = Color3.fromRGB(0, 230, 120),
    }

    -- ============================================================
    -- UTILITY
    -- ============================================================
    local function Tw(obj, props, dur)
        local ti = TweenInfo.new(dur or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(obj, ti, props):Play()
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

    local function GetKeyName(key)
        if key == nil then return "---" end
        if typeof(key) == "EnumItem" then
            local name = key.Name
            name = name:gsub("MouseButton1", "LMB")
            name = name:gsub("MouseButton2", "RMB")
            return name
        end
        return tostring(key)
    end

    -- ============================================================
    -- NO RECOIL (GERÇEK)
    -- ============================================================
    local NoRecoilEnabled = false
    local NoRecoil_Connections = {}
    local NoRecoil_WeaponCache = {}
    local NoRecoil_GlobalOriginal = {}

    local function NoRecoil_CacheWeapons()
        NoRecoil_WeaponCache = {}
        for _, v in pairs(getgc(true)) do
            if type(v) == 'table' then
                if rawget(v, 'Recoil') ~= nil or rawget(v, 'EquipTime') ~= nil then
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
                        }
                    end
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
    -- WALLCHECK (Duvar kontrolü)
    -- ============================================================
    local function IsVisible(targetPosition, ignoreList)
        if not Settings.WallCheck then return true end
        
        local ignore = {LocalPlayer.Character, Camera}
        if ignoreList then
            for _, v in pairs(ignoreList) do table.insert(ignore, v) end
        end
        
        local ray = Ray.new(Camera.CFrame.Position, (targetPosition - Camera.CFrame.Position).Unit * 1000)
        local part, pos = Workspace:FindPartOnRayWithIgnoreList(ray, ignore)
        
        if part then
            local distToTarget = (Camera.CFrame.Position - targetPosition).Magnitude
            local distToHit = (Camera.CFrame.Position - pos).Magnitude
            if distToHit < distToTarget then
                return false
            end
        end
        return true
    end

    -- ============================================================
    -- SILENT AIM (GERÇEK - WallCheck ile)
    -- ============================================================
    local function GetClosestTarget()
        local closest = nil
        local shortest = AimbotFOV
        local mousePos = Vector2.new(Mouse.X, Mouse.Y)

        for _, plr in pairs(Players:GetPlayers()) do
            if plr == LocalPlayer then continue end
            if not plr.Character then continue end

            local head = plr.Character:FindFirstChild("Head")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")

            if not head or not hum or hum.Health <= 0 then continue end

            -- WallCheck: duvar arkasındakini görme
            if Settings.WallCheck and not IsVisible(head.Position) then
                continue
            end

            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if not onScreen then continue end

            local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
            if dist < shortest then
                shortest = dist
                closest = plr
            end
        end

        return closest
    end

    -- ============================================================
    -- AIMBOT (Smooth)
    -- ============================================================
    local function DoAimbot()
        if not Settings.Aimbot then return end
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end

        local target = GetClosestTarget()
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            if head then
                local lookAt = CFrame.new(Camera.CFrame.Position, head.Position)
                if AimbotSmooth > 1 then
                    Camera.CFrame = Camera.CFrame:Lerp(lookAt, 1 / AimbotSmooth)
                else
                    Camera.CFrame = lookAt
                end
            end
        end
    end

    -- ============================================================
    -- SILENT AIM (Mouse'u hedefe kaydırır - WallCheck ile)
    -- ============================================================
    local function DoSilentAim()
        if not Settings.SilentAim then return end
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end

        local target = GetClosestTarget()
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            if head then
                SilentAimTarget = head
                SilentAimActive = true

                -- Mouse pozisyonunu hedefe kaydır (ama direkt değil, hafif)
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    -- Yumuşak geçiş için küçük adımlarla kaydır
                    local currentPos = Vector2.new(Mouse.X, Mouse.Y)
                    local targetPos = Vector2.new(pos.X, pos.Y)
                    local diff = (targetPos - currentPos) * 0.3 -- %30 oranında kaydır
                    Mouse.X = currentPos.X + diff.X
                    Mouse.Y = currentPos.Y + diff.Y
                end
            end
        else
            SilentAimActive = false
            SilentAimTarget = nil
        end
    end

    -- Silent Aim için RenderStepped (sürekli güncelle)
    local function OnSilentAimUpdate()
        if not Settings.SilentAim then return end
        if not SilentAimActive or not SilentAimTarget then return end
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            SilentAimActive = false
            SilentAimTarget = nil
            return
        end

        local pos, onScreen = Camera:WorldToViewportPoint(SilentAimTarget.Position)
        if onScreen then
            local currentPos = Vector2.new(Mouse.X, Mouse.Y)
            local targetPos = Vector2.new(pos.X, pos.Y)
            local diff = (targetPos - currentPos) * 0.15 -- %15 oranında kaydır (daha yumuşak)
            Mouse.X = currentPos.X + diff.X
            Mouse.Y = currentPos.Y + diff.Y
        end
    end

    local silentAimConn = nil
    local function SetupSilentAim()
        if silentAimConn then
            silentAimConn:Disconnect()
            silentAimConn = nil
        end

        if Settings.SilentAim then
            silentAimConn = RunService.RenderStepped:Connect(OnSilentAimUpdate)
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
            tag.Size = UDim2.new(0, 200, 0, 60)
            tag.StudsOffset = Vector3.new(0, 3.5, 0)
            tag.Parent = ESPFolder

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Name = "Name"
            nameLbl.Size = UDim2.new(1, 0, 0, 18)
            nameLbl.Position = UDim2.new(0, 0, 0, 20)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = plr.Name
            nameLbl.TextColor3 = Color3.fromRGB(255, 50, 50)
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.TextSize = 14
            nameLbl.TextStrokeTransparency = 0.2
            nameLbl.TextStrokeColor3 = Color3.new(0,0,0)
            nameLbl.Visible = false
            nameLbl.Parent = tag

            local distLbl = Instance.new("TextLabel")
            distLbl.Name = "Distance"
            distLbl.Size = UDim2.new(1, 0, 0, 14)
            distLbl.Position = UDim2.new(0, 0, 0, 38)
            distLbl.BackgroundTransparency = 1
            distLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
            distLbl.Font = Enum.Font.Gotham
            distLbl.TextSize = 10
            distLbl.TextStrokeTransparency = 0.3
            distLbl.TextStrokeColor3 = Color3.new(0,0,0)
            distLbl.Visible = false
            distLbl.Parent = tag

            local hpBg = Instance.new("Frame")
            hpBg.Name = "HPBg"
            hpBg.Size = UDim2.new(0.65, 0, 0, 3)
            hpBg.Position = UDim2.new(0.175, 0, 0, 56)
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
            if ESPFolder then
                local t = ESPFolder:FindFirstChild(p.Name)
                if t then t:Destroy() end
            end
        end))
    end

    local function UpdateESP()
        if not Settings.ESP or not ESPFolder then return end

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
                if n then
                    n.Visible = Settings.NameESP
                    n.Text = plr.Name
                end

                local d = tag:FindFirstChild("Distance")
                if d then
                    d.Visible = Settings.DistanceESP
                    d.Text = dist .. "m"
                end

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
            end
        end
    end

    -- ============================================================
    -- UI
    -- ============================================================
    local function CreateUI()
        if SantesGui then pcall(function() SantesGui:Destroy() end) end

        local gui = Instance.new("ScreenGui")
        gui.Name = "SantesHub"
        local success = pcall(function()
            if gethui then gui.Parent = gethui() else gui.Parent = CoreGui end
        end)
        if not success then gui.Parent = PlayerGui end
        gui.ResetOnSpawn = false
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        SantesGui = gui

        MainFrame = Instance.new("Frame")
        MainFrame.Size = UDim2.new(0, 340, 0, 400)
        MainFrame.Position = UDim2.new(0.5, -170, 0.5, -200)
        MainFrame.BackgroundColor3 = T.Bg
        MainFrame.BorderSizePixel = 0
        MainFrame.Active = true
        MainFrame.Draggable = true
        MainFrame.ClipsDescendants = true
        MainFrame.Parent = gui
        Corner(MainFrame, 14)
        Stroke(MainFrame, T.Accent, 1.5, 0.2)

        -- GLOW
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

        -- TOP BAR
        local TopBar = Instance.new("Frame")
        TopBar.Size = UDim2.new(1, 0, 0, 44)
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

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -80, 1, 0)
        title.Position = UDim2.new(0, 14, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = "SANTES HUB"
        title.TextColor3 = T.Accent
        title.Font = Enum.Font.GothamBold
        title.TextSize = 18
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 6
        title.Parent = TopBar

        -- Close
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 28, 0, 28)
        closeBtn.Position = UDim2.new(1, -36, 0, 8)
        closeBtn.BackgroundColor3 = T.Accent
        closeBtn.BackgroundTransparency = 0.8
        closeBtn.Text = "✕"
        closeBtn.TextColor3 = Color3.new(1,1,1)
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 14
        closeBtn.ZIndex = 6
        closeBtn.Parent = TopBar
        Corner(closeBtn, 7)
        closeBtn.MouseButton1Click:Connect(function()
            ResetAll()
            gui:Destroy()
            MenuOpen = false
            SantesGui = nil
        end)

        -- Minimize
        local minBtn = Instance.new("TextButton")
        minBtn.Size = UDim2.new(0, 28, 0, 28)
        minBtn.Position = UDim2.new(1, -68, 0, 8)
        minBtn.BackgroundColor3 = T.SurfaceUp
        minBtn.Text = "−"
        minBtn.TextColor3 = T.TextSec
        minBtn.Font = Enum.Font.GothamBold
        minBtn.TextSize = 16
        minBtn.ZIndex = 6
        minBtn.Parent = TopBar
        Corner(minBtn, 7)
        minBtn.MouseButton1Click:Connect(function()
            MenuOpen = false
            Tw(MainFrame, {Size = UDim2.new(0, 340, 0, 46)}, 0.25)
        end)

        -- CONTENT
        local Content = Instance.new("ScrollingFrame")
        Content.Size = UDim2.new(1, -16, 1, -52)
        Content.Position = UDim2.new(0, 8, 0, 48)
        Content.BackgroundTransparency = 1
        Content.ScrollBarThickness = 3
        Content.ScrollBarImageColor3 = T.Accent
        Content.CanvasSize = UDim2.new(0, 0, 0, 0)
        Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Content.ZIndex = 3
        Content.Parent = MainFrame

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 4)
        ContentLayout.Parent = Content
        Pad(Content, 4, 4, 4, 4)

        -- ============================================================
        -- UI HELPERS
        -- ============================================================
        local function Section(txt)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 24)
            f.BackgroundTransparency = 1
            f.ZIndex = 3
            f.Parent = Content

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = txt
            lbl.TextColor3 = T.Accent
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 4
            lbl.Parent = f
        end

        local function Toggle(name, settingKey)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 34)
            f.BackgroundColor3 = T.SurfaceUp
            f.BackgroundTransparency = 0.15
            f.BorderSizePixel = 0
            f.ZIndex = 3
            f.Parent = Content
            Corner(f, 8)

            local track = Instance.new("Frame")
            track.Size = UDim2.new(0, 34, 0, 18)
            track.Position = UDim2.new(0, 8, 0.5, -9)
            track.BackgroundColor3 = Settings[settingKey] and T.ToggleOn or T.ToggleOff
            track.BorderSizePixel = 0
            track.ZIndex = 4
            track.Parent = f
            Corner(track, 12)

            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0, 14, 0, 14)
            circle.Position = Settings[settingKey] and UDim2.new(0, 18, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            circle.BackgroundColor3 = Color3.new(1,1,1)
            circle.BorderSizePixel = 0
            circle.ZIndex = 5
            circle.Parent = track
            Corner(circle, 10)

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0, 140, 1, 0)
            lbl.Position = UDim2.new(0, 50, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = T.Text
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 4
            lbl.Parent = f

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
            clickArea.Size = UDim2.new(1, 0, 1, 0)
            clickArea.BackgroundTransparency = 1
            clickArea.Text = ""
            clickArea.ZIndex = 6
            clickArea.Parent = f

            local ref = { key = settingKey, track = track, circle = circle, status = status }
            table.insert(ToggleRefs, ref)

            local function UpdateVisual()
                local on = Settings[settingKey]
                Tw(track, {BackgroundColor3 = on and T.ToggleOn or T.ToggleOff}, 0.15)
                Tw(circle, {Position = on and UDim2.new(0, 18, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}, 0.15)
                status.Text = on and "ON" or ""
            end
            ref.UpdateVisual = UpdateVisual

            clickArea.MouseButton1Click:Connect(function()
                Settings[settingKey] = not Settings[settingKey]
                UpdateVisual()

                if settingKey == "NoRecoil" then
                    if Settings.NoRecoil then NoRecoil_Enable() else NoRecoil_Disable() end
                elseif settingKey == "SilentAim" then
                    SetupSilentAim()
                end
            end)
        end

        local function Slider(name, min, max, def, settingKey)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 44)
            f.BackgroundColor3 = T.SurfaceUp
            f.BackgroundTransparency = 0.15
            f.BorderSizePixel = 0
            f.ZIndex = 3
            f.Parent = Content
            Corner(f, 8)

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
            bar.BackgroundColor3 = ToggleOff
            bar.BorderSizePixel = 0
            bar.ZIndex = 4
            bar.Parent = f
            Corner(bar, 3)

            local pct = math.clamp((def - min) / (max - min), 0, 1)
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(pct, 0, 1, 0)
            fill.BackgroundColor3 = T.Accent
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

            UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(inp)
                if not dragging then return end
                if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                    local mx = UserInputService:GetMouseLocation().X
                    local bx = bar.AbsolutePosition.X
                    local bw = bar.AbsoluteSize.X
                    local p = math.clamp((mx - bx) / bw, 0, 1)
                    local val = math.floor(min + (max - min) * p)
                    if settingKey == "SpeedValue" then SpeedValue = val
                    elseif settingKey == "FlySpeed" then FlySpeed = val
                    elseif settingKey == "AimbotFOV" then AimbotFOV = val
                    elseif settingKey == "AimbotSmooth" then AimbotSmooth = val end
                    fill.Size = UDim2.new(p, 0, 1, 0)
                    knob.Position = UDim2.new(p, -6, 0.5, -6)
                    valLbl.Text = tostring(val)
                end
            end)
        end

        -- ============================================================
        -- BUILD UI
        -- ============================================================
        Section("⚡ COMBAT")
        Toggle("Aimbot (Hold RMB)", "Aimbot")
        Slider("Aimbot FOV", 30, 360, 180, "AimbotFOV")
        Slider("Smoothness", 1, 20, 3, "AimbotSmooth")
        Toggle("Silent Aim (WallCheck)", "SilentAim")
        Toggle("No Recoil", "NoRecoil")

        Section("🌀 MOVEMENT")
        Toggle("Fly Mode (E/Q)", "Fly")
        Slider("Fly Speed", 20, 200, 50, "FlySpeed")
        Toggle("Speed Hack", "Speed")
        Slider("Speed Value", 20, 500, 50, "SpeedValue")
        Toggle("Infinite Jump", "InfiniteJump")
        Toggle("Noclip", "Noclip")

        Section("👁 VISUAL")
        Toggle("ESP Master", "ESP")
        Toggle("Name ESP", "NameESP")
        Toggle("Health ESP", "HealthESP")
        Toggle("Distance ESP", "DistanceESP")
        Toggle("FullBright", "FullBright")

        -- ============================================================
        -- MAIN LOOP
        -- ============================================================
        local function ResetAll()
            Settings.ESP = false
            Settings.NameESP = false
            Settings.HealthESP = false
            Settings.DistanceESP = false
            Settings.NoRecoil = false
            Settings.Fly = false
            Settings.Speed = false
            Settings.InfiniteJump = false
            Settings.Noclip = false
            Settings.FullBright = false
            Settings.Aimbot = false
            Settings.SilentAim = false

            NoRecoil_Disable()
            if FlyBodyVelocity then FlyBodyVelocity:Destroy(); FlyBodyVelocity = nil end
            if FlyBodyGyro then FlyBodyGyro:Destroy(); FlyBodyGyro = nil end
            if ESPFolder then ESPFolder:Destroy(); ESPFolder = nil end

            pcall(function()
                Lighting.Brightness = Originals.Brightness
                Lighting.GlobalShadows = Originals.GlobalShadows
                Lighting.FogEnd = Originals.FogEnd
                Lighting.FogStart = Originals.FogStart
            end)

            if silentAimConn then
                silentAimConn:Disconnect()
                silentAimConn = nil
            end

            for _, ref in pairs(ToggleRefs) do
                if ref.UpdateVisual then ref.UpdateVisual() end
            end
        end

        -- Main Loop
        local mainConn = RunService.RenderStepped:Connect(function()
            -- FullBright
            if Settings.FullBright then
                Lighting.Brightness = 3
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 100000
                Lighting.FogStart = 100000
            else
                Lighting.Brightness = Originals.Brightness
                Lighting.GlobalShadows = Originals.GlobalShadows
                Lighting.FogEnd = Originals.FogEnd
                Lighting.FogStart = Originals.FogStart
            end

            if not LocalPlayer.Character then return end
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hum or not root then return end

            -- Speed
            if Settings.Speed then
                if hum.MoveDirection.Magnitude > 0 then
                    root.CFrame = root.CFrame + (hum.MoveDirection * (SpeedValue * 0.01))
                end
            end

            -- Infinite Jump
            if Settings.InfiniteJump then
                hum.JumpPower = 500
            else
                hum.JumpPower = Originals.JumpPower
            end

            -- Noclip
            if Settings.Noclip then
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end

            -- Fly
            if Settings.Fly then
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
                FlyBodyVelocity.Velocity = dir.Magnitude > 0 and dir.Unit * FlySpeed or Vector3.zero
                FlyBodyGyro.CFrame = Camera.CFrame
            else
                if FlyBodyVelocity and FlyBodyVelocity.Parent then FlyBodyVelocity:Destroy(); FlyBodyVelocity = nil end
                if FlyBodyGyro and FlyBodyGyro.Parent then FlyBodyGyro:Destroy(); FlyBodyGyro = nil end
                hum.PlatformStand = false
            end

            -- Aimbot
            if Settings.Aimbot then
                DoAimbot()
            end

            -- Silent Aim (manuel çalıştır - ekstra)
            if Settings.SilentAim then
                DoSilentAim()
            end

            -- ESP
            if Settings.ESP then
                if not ESPFolder then CreateESP() end
                UpdateESP()
            elseif ESPFolder then
                ESPFolder:Destroy()
                ESPFolder = nil
            end
        end)
        table.insert(Connections, mainConn)

        -- ============================================================
        -- KEYBIND
        -- ============================================================
        UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end

            if input.KeyCode == Enum.KeyCode.Insert then
                MenuOpen = not MenuOpen
                if MenuOpen then
                    MainFrame.Visible = true
                    MainFrame.Size = UDim2.new(0, 0, 0, 0)
                    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Tw(MainFrame, {Size = UDim2.new(0, 340, 0, 400), Position = UDim2.new(0.5, -170, 0.5, -200)}, 0.3)
                else
                    Tw(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.2)
                    task.delay(0.2, function() if not MenuOpen then MainFrame.Visible = false end end)
                end
            end
        end)

        -- ============================================================
        -- CLEANUP
        -- ============================================================
        gui.Destroying:Connect(function()
            ResetAll()
            for _, conn in ipairs(Connections) do
                pcall(function() conn:Disconnect() end)
            end
            if silentAimConn then
                silentAimConn:Disconnect()
                silentAimConn = nil
            end
        end)

        return gui
    end

    -- ============================================================
    -- START
    -- ============================================================
    CreateUI()

    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "SANTES HUB",
            Text = "Loaded! INSERT to toggle menu.",
            Duration = 3
        })
    end)

    print("==================================")
    print("   SANTES HUB ULTIMATE")
    print("   INSERT = Toggle Menu")
    print("   Silent Aim (WallCheck) - FIXED")
    print("   Anti AFK - AUTOMATIC")
    print("==================================")
end

-- ============================================================
-- RUN
-- ============================================================
SantesHub()
