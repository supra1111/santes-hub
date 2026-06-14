--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║              SANTES HUB v3.1 | CRIMINALITY                     ║
    ║         Execute edilince DIREKT CALISAN versiyon               ║
    ║         Siyah & Kırmızı Premium UI - Loader YOK               ║
    ╚══════════════════════════════════════════════════════════════════╝
    
    TUM EXECUTOR'LAR ILE UYUMLU:
    ✅ Xeno ✅ Solara ✅ Vega X ✅ Wave ✅ Arceus ✅ Delta ✅ Fluxus
--]]

-- #####################################################################
-- #                          SERVICES                                #
-- #####################################################################

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")

-- LocalPlayer ve PlayerGui'yi guvenle bekle
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)

if not PlayerGui then
    warn("SANTES: PlayerGui yuklenemedi!")
    return
end

-- #####################################################################
-- #                          ANTI-IDLE                               #
-- #####################################################################

LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- #####################################################################
-- #                     ESKI UI TEMIZLEME                            #
-- #####################################################################

local guiNamesToClean = {
    "SantesHubScreenGui",
    "SantesHubScreenGui_Categorized",
    "SantesHub_Main",
    "SantesHub_Loader",
    "EQRHubScreenGui",
    "VenomHubScreenGui",
    "VenomHubScreenGui_Categorized",
    "ShadowWarningHUD",
    "InvisWarningGUI",
    "InvisWarning",
    "SantesMinimizeFrame",
    "SantesMobileControls"
}

for _, name in pairs(guiNamesToClean) do
    pcall(function()
        local gui = PlayerGui:FindFirstChild(name)
        if gui then
            gui:Destroy()
        end
    end)
    pcall(function()
        local gui = CoreGui:FindFirstChild(name)
        if gui then
            gui:Destroy()
        end
    end)
end

-- #####################################################################
-- #                       TEMA RENKLERI                              #
-- #####################################################################

local C = {
    bg = Color3.fromRGB(6, 6, 9),
    panel = Color3.fromRGB(11, 11, 16),
    card = Color3.fromRGB(16, 16, 22),
    cardHover = Color3.fromRGB(22, 22, 30),
    accent = Color3.fromRGB(210, 28, 28),
    accentBright = Color3.fromRGB(255, 50, 50),
    accentDim = Color3.fromRGB(120, 15, 15),
    accentGlow = Color3.fromRGB(200, 20, 20),
    border = Color3.fromRGB(35, 35, 48),
    borderAccent = Color3.fromRGB(80, 12, 12),
    textPrimary = Color3.fromRGB(235, 235, 240),
    textSub = Color3.fromRGB(150, 150, 165),
    textMuted = Color3.fromRGB(70, 70, 85),
    green = Color3.fromRGB(40, 200, 80),
    yellow = Color3.fromRGB(230, 180, 30),
}

-- #####################################################################
-- #                    YARDIMCI FONKSIYONLAR                          #
-- #####################################################################

-- Tween animasyonu
local function tween(obj, props, dur, style, dir)
    TweenService:Create(
        obj,
        TweenInfo.new(
            dur or 0.25,
            style or Enum.EasingStyle.Quart,
            dir or Enum.EasingDirection.Out
        ),
        props
    ):Play()
end

-- Kose yuvarlama
local function addCorner(parent, radius)
    local uc = Instance.new("UICorner")
    uc.CornerRadius = UDim.new(0, radius or 10)
    uc.Parent = parent
    return uc
end

-- Kenar cizgisi
local function addStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or C.border
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = parent
    return s
end

-- Padding
local function addPadding(parent, all)
    local p = Instance.new("UIPadding")
    if all then
        p.PaddingTop = UDim.new(0, all)
        p.PaddingBottom = UDim.new(0, all)
        p.PaddingLeft = UDim.new(0, all)
        p.PaddingRight = UDim.new(0, all)
    end
    p.Parent = parent
    return p
end

-- #####################################################################
-- #                       MODULLER                                    #
-- #####################################################################

-- ==================== FLY ====================
local flyEnabled = false
local flyConn = nil
local flySpeed = 70

function Fly_Enable()
    if flyEnabled then
        return
    end
    
    flyEnabled = true

    -- Ilk acilista yukari dogru ivme kazandir
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(0, 30, 0)
        end
    end

    flyConn = RunService.Heartbeat:Connect(function(dt)
        if not flyEnabled then
            return
        end

        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if not hrp or not hum then
            return
        end

        -- PlatformStand: Yercekimini yok et, dusmeyi engelle
        hum.PlatformStand = true

        -- Gravity override: Tum parcalarin dogal hareketini durdur
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.AssemblyLinearVelocity = Vector3.zero
                part.Velocity = Vector3.zero
            end
        end

        local cam = workspace.CurrentCamera
        if not cam then
            return
        end

        local targetVel = Vector3.new()

        -- Kameraya gore yon vektorleri
        local forward = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z).Unit
        local right = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z).Unit

        -- MoveDirection = mobil joystick veya WASD klavye
        local md = hum.MoveDirection
        
        if md.Magnitude > 0.1 then
            -- Joystick yonu varsa onu kullan
            targetVel += md * flySpeed
        else
            -- Manuel klavye kontrolu
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                targetVel += forward * flySpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                targetVel -= forward * flySpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                targetVel -= right * flySpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                targetVel += right * flySpeed
            end
        end

        -- Hareket yoksa havada sabit kal
        if targetVel.Magnitude < 1 then
            hrp.Velocity = Vector3.new(0, 0.3, 0)
            hrp.AssemblyLinearVelocity = Vector3.zero
        else
            hrp.Velocity = targetVel
            hrp.AssemblyLinearVelocity = targetVel
        end
    end)
end

function Fly_Disable()
    flyEnabled = false
    
    if flyConn then
        flyConn:Disconnect()
        flyConn = nil
    end

    -- Karakteri normale dondur
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = false
        end
    end
end

-- ==================== NOCLIP ====================
local noclipEnabled = false
local noclipConn = nil

function Noclip_Enable()
    if noclipEnabled then
        return
    end
    
    noclipEnabled = true

    noclipConn = RunService.Stepped:Connect(function()
        if noclipEnabled and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

function Noclip_Disable()
    noclipEnabled = false
    
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
end

-- ==================== FULLBRIGHT ====================
local fullbrightEnabled = false
local fullbrightConn = nil
local origLighting = {}

function FullBright_Enable()
    if fullbrightEnabled then
        return
    end
    
    fullbrightEnabled = true

    -- Orijinal degerleri sakla
    origLighting = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd
    }

    fullbrightConn = RunService.RenderStepped:Connect(function()
        Lighting.Brightness = 5
        Lighting.ClockTime = 14
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.FogStart = 100000
        Lighting.FogEnd = 100000
    end)
end

function FullBright_Disable()
    fullbrightEnabled = false
    
    if fullbrightConn then
        fullbrightConn:Disconnect()
        fullbrightConn = nil
    end

    -- Orijinal degerlere geri don
    if origLighting.Brightness then
        Lighting.Brightness = origLighting.Brightness
        Lighting.ClockTime = origLighting.ClockTime
        Lighting.Ambient = origLighting.Ambient
        Lighting.OutdoorAmbient = origLighting.OutdoorAmbient
        Lighting.FogStart = origLighting.FogStart
        Lighting.FogEnd = origLighting.FogEnd
    end
end

-- ==================== FOV CHANGER ====================
local fovEnabled = false
local fovVal = 80
local fovOrig = 70

function FOV_Enable()
    fovEnabled = true
    if workspace.CurrentCamera then
        fovOrig = workspace.CurrentCamera.FieldOfView
    end
end

function FOV_Disable()
    fovEnabled = false
    if workspace.CurrentCamera then
        workspace.CurrentCamera.FieldOfView = fovOrig
    end
end

RunService.RenderStepped:Connect(function()
    if fovEnabled and workspace.CurrentCamera then
        workspace.CurrentCamera.FieldOfView = fovVal
    end
end)

-- ==================== NO FAIL LOCKPICK ====================
local noFailLPEnabled = false
local noFailLPConn = nil

function NoFailLP_Enable()
    if noFailLPEnabled then
        return
    end
    
    noFailLPEnabled = true

    noFailLPConn = PlayerGui.ChildAdded:Connect(function(item)
        if item.Name == "LockpickGUI" then
            task.wait(0.1)
            pcall(function()
                local mf = item:FindFirstChild("MF")
                if mf then
                    local lpf = mf:FindFirstChild("LP_Frame")
                    if lpf then
                        local frames = lpf:FindFirstChild("Frames")
                        if frames then
                            for _, barName in pairs({"B1", "B2", "B3"}) do
                                local bar = frames:FindFirstChild(barName)
                                if bar and bar:FindFirstChild("Bar") then
                                    local uiScale = bar.Bar:FindFirstChild("UIScale")
                                    if uiScale then
                                        uiScale.Scale = 10
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
end

function NoFailLP_Disable()
    noFailLPEnabled = false
    
    if noFailLPConn then
        noFailLPConn:Disconnect()
        noFailLPConn = nil
    end
end

-- ==================== SAFE ESP ====================
local safeESPEnabled = false
local safeESPConn = nil

local function safeESPUpdate()
    local folder = Workspace.Map and Workspace.Map:FindFirstChild("BredMakurz")
    if not folder then
        folder = Workspace:FindFirstChild("BredMakurz")
    end
    if not folder then
        return
    end

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local myPos = char.HumanoidRootPart.Position

    for _, obj in pairs(folder:GetChildren()) do
        local primaryPart = obj.PrimaryPart
        local part = (primaryPart and primaryPart:IsA("BasePart")) 
            and primaryPart 
            or obj:FindFirstChildOfClass("BasePart")
        
        if part then
            local dist = (part.Position - myPos).magnitude
            local exist = obj:FindFirstChild("SantesSE")
            local values = obj:FindFirstChild("Values")
            local broken = values and values:FindFirstChild("Broken")

            if dist <= 200 then
                if not exist then
                    -- BillboardGui olustur
                    local bg = Instance.new("BillboardGui")
                    bg.Name = "SantesSE"
                    bg.AlwaysOnTop = true
                    bg.Size = UDim2.new(8, 0, 4, 0)
                    bg.MaxDistance = 200
                    bg.Adornee = obj
                    bg.Parent = obj

                    local textLabel = Instance.new("TextLabel", bg)
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.Font = Enum.Font.SourceSansBold
                    textLabel.TextScaled = false
                    textLabel.TextSize = 15
                    textLabel.Text = obj.Name
                        :gsub("([a-z])([A-Z])", "%1 %2")
                        :gsub("_.*", "")

                    if broken and broken:IsA("BoolValue") then
                        if broken.Value then
                            textLabel.TextColor3 = Color3.new(1, 0, 0)
                        else
                            textLabel.TextColor3 = Color3.new(0, 1, 0)
                        end
                        
                        broken:GetPropertyChangedSignal("Value"):Connect(function()
                            if textLabel and textLabel.Parent then
                                textLabel.TextColor3 = broken.Value 
                                    and Color3.new(1, 0, 0) 
                                    or Color3.new(0, 1, 0)
                            end
                        end)
                    else
                        textLabel.TextColor3 = Color3.new(0, 1, 0)
                    end
                end
            elseif exist then
                -- Menzil disinda -> GUI'yi yok et
                exist:Destroy()
            end
        end
    end
end

function SafeESP_Enable()
    if safeESPEnabled then
        return
    end
    
    safeESPEnabled = true
    safeESPConn = RunService.Heartbeat:Connect(safeESPUpdate)
end

function SafeESP_Disable()
    safeESPEnabled = false
    
    if safeESPConn then
        safeESPConn:Disconnect()
        safeESPConn = nil
    end

    -- TUM BillboardGui'leri temizle
    local folder = Workspace.Map and Workspace.Map:FindFirstChild("BredMakurz")
    if not folder then
        folder = Workspace:FindFirstChild("BredMakurz")
    end
    if folder then
        for _, obj in pairs(folder:GetChildren()) do
            local esp = obj:FindFirstChild("SantesSE")
            if esp then
                esp:Destroy()
            end
        end
    end
end

-- ==================== AUTO LOCKPICK ====================
local autoLockpickEnabled = false
local autoLockpickConn = nil
local lockpickCooldown = false
local lastOpenedSafe = nil

function AutoLockpick_Enable()
    if autoLockpickEnabled then
        return
    end
    
    autoLockpickEnabled = true

    autoLockpickConn = RunService.Heartbeat:Connect(function()
        if not autoLockpickEnabled then
            return
        end
        
        if lockpickCooldown then
            return
        end

        local char = LocalPlayer.Character
        if not char then
            return
        end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            return
        end

        -- Lockpick'i bul ve kusan
        local lockpickTool = char:FindFirstChild("Lockpick")
        if not lockpickTool then
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if backpack then
                for _, item in pairs(backpack:GetChildren()) do
                    if item.Name == "Lockpick" or string.find(string.lower(item.Name), "lockpick") then
                        lockpickTool = item
                        break
                    end
                end
            end
        end

        if not lockpickTool then
            return -- Lockpick yoksa cik
        end

        -- Kusani degilse kusan
        if not char:FindFirstChild(lockpickTool.Name) then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function()
                    hum:EquipTool(lockpickTool)
                end)
            end
            return
        end

        -- Safe/Register klasorunu bul
        local folder = Workspace.Map and Workspace.Map:FindFirstChild("BredMakurz")
        if not folder then
            folder = Workspace:FindFirstChild("BredMakurz")
        end
        if not folder then
            return
        end

        -- En yakin acilmamis safe'i bul (3 stud mesafede)
        local nearestDist = 3
        local nearestSafe = nil
        local nearestMainPart = nil

        for _, obj in pairs(folder:GetChildren()) do
            if obj ~= lastOpenedSafe then
                if string.find(obj.Name, "Safe") or string.find(obj.Name, "Register") then
                    local mainPart = obj:FindFirstChild("MainPart") or obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
                    
                    if mainPart then
                        local dist = (hrp.Position - mainPart.Position).Magnitude
                        if dist < nearestDist then
                            local values = obj:FindFirstChild("Values")
                            if values then
                                local broken = values:FindFirstChild("Broken")
                                if broken and broken:IsA("BoolValue") and not broken.Value then
                                    nearestDist = dist
                                    nearestSafe = obj
                                    nearestMainPart = mainPart
                                end
                            end
                        end
                    end
                end
            end
        end

        if not nearestSafe then
            return
        end

        -- Cooldown baslat
        lockpickCooldown = true
        lastOpenedSafe = nearestSafe

        -- Lockpick event'ini bul ve calistir
        local events = ReplicatedStorage:FindFirstChild("Events")
        if events and nearestMainPart then
            -- Yontem 1: XMHH.2 / XMHH2.2
            local remote1 = events:FindFirstChild("XMHH.2")
            local remote2 = events:FindFirstChild("XMHH2.2")
            
            if remote1 and remote2 then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    local success, result = pcall(function()
                        return remote1:InvokeServer(
                            "\240\159\141\158",
                            tick(),
                            tool,
                            "DZDRRRKI",
                            nearestSafe,
                            "Register"
                        )
                    end)
                    
                    if success and result then
                        pcall(function()
                            remote2:FireServer(
                                "\240\159\141\158",
                                tick(),
                                tool,
                                "2389ZFX34",
                                result,
                                false,
                                char:FindFirstChild("Right Arm") or hrp,
                                nearestMainPart,
                                nearestSafe,
                                nearestMainPart.Position,
                                nearestMainPart.Position
                            )
                        end)
                    end
                end
            end

            -- Yontem 2: LockpickStart eventi
            local lockpickEvent = events:FindFirstChild("LockpickStart")
                or events:FindFirstChild("StartLockpick")
                or events:FindFirstChild("LockpickEvent")
            
            if lockpickEvent then
                pcall(function()
                    lockpickEvent:FireServer(nearestSafe, nearestMainPart)
                end)
            end

            -- Yontem 3: ToolEvent
            local toolEvent = events:FindFirstChild("ToolEvent")
                or events:FindFirstChild("UseTool")
            
            if toolEvent then
                pcall(function()
                    toolEvent:FireServer(nearestSafe, nearestMainPart, "Lockpick")
                end)
            end

            -- Yontem 4: BYZERSPROTEC
            local byzers = events:FindFirstChild("BYZERSPROTEC")
            if byzers then
                pcall(function()
                    byzers:FireServer(true, "safe", nearestMainPart, "Lockpick")
                    task.wait(0.05)
                    byzers:FireServer(false)
                end)
            end
        end

        -- Lockpick GUI'si acildiysa hemen kapat
        task.wait(0.05)
        
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            local lockpickGUI = playerGui:FindFirstChild("LockpickGUI")
            if lockpickGUI then
                local attempts = 0
                while lockpickGUI and lockpickGUI.Parent and attempts < 30 do
                    pcall(function()
                        local mf = lockpickGUI:FindFirstChild("MF")
                        if mf then
                            local lpf = mf:FindFirstChild("LP_Frame")
                            if lpf then
                                local frames = lpf:FindFirstChild("Frames")
                                if frames then
                                    for _, barName in pairs({"B1", "B2", "B3"}) do
                                        local bar = frames:FindFirstChild(barName)
                                        if bar and bar:FindFirstChild("Bar") then
                                            -- UIScale ile yesil alani genislet
                                            local uiScale = bar.Bar:FindFirstChild("UIScale")
                                            if uiScale then
                                                uiScale.Scale = 20
                                            end
                                            
                                            -- Butona tikla
                                            local button = bar.Bar:FindFirstChildOfClass("TextButton")
                                            if button then
                                                local green = bar.Bar:FindFirstChild("Green")
                                                if not green or not green.Visible then
                                                    pcall(function()
                                                        button.MouseButton1Click:Fire()
                                                    end)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    
                    attempts = attempts + 1
                    task.wait(0.02)
                    
                    -- GUI kapandiysa basariyla acilmistir
                    if not lockpickGUI.Parent then
                        break
                    end
                end
            end
        end

        -- Cooldown bitir
        task.wait(0.3)
        lockpickCooldown = false
    end)
end

function AutoLockpick_Disable()
    autoLockpickEnabled = false
    lockpickCooldown = false
    lastOpenedSafe = nil
    
    if autoLockpickConn then
        autoLockpickConn:Disconnect()
        autoLockpickConn = nil
    end
end

-- ==================== AUTO PICKUP MONEY ====================
local autoPickupEnabled = false
local autoPickupConn = nil
local pickupCooldown = false

function AutoPickup_Enable()
    if autoPickupEnabled then
        return
    end
    
    autoPickupEnabled = true

    autoPickupConn = RunService.RenderStepped:Connect(function()
        if not autoPickupEnabled or pickupCooldown then
            return
        end

        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        local hrp = char.HumanoidRootPart

        -- Para klasorunu bul
        local folder = Workspace.Filter and Workspace.Filter:FindFirstChild("SpawnedBread")
        if not folder then
            folder = Workspace:FindFirstChild("SpawnedBread")
        end
        if not folder then
            return
        end

        -- RemoteEvent'i bul
        local remote = ReplicatedStorage.Events and ReplicatedStorage.Events:FindFirstChild("CZDPZUS")
        if not remote then
            return
        end

        -- En yakin parayi bul ve topla
        for _, bread in pairs(folder:GetChildren()) do
            if bread:IsA("BasePart") and (hrp.Position - bread.Position).Magnitude < 5 then
                pickupCooldown = true
                
                pcall(function()
                    remote:FireServer(bread)
                end)
                
                task.wait(1)
                pickupCooldown = false
                break
            end
        end
    end)
end

function AutoPickup_Disable()
    autoPickupEnabled = false
    pickupCooldown = false
    
    if autoPickupConn then
        autoPickupConn:Disconnect()
        autoPickupConn = nil
    end
end

-- ==================== AUTO UNLOCK/OPEN DOORS ====================
local unlockDoorsEnabled = false
local unlockDoorsConn = nil

function UnlockDoors_Enable()
    if unlockDoorsEnabled then
        return
    end
    
    unlockDoorsEnabled = true

    unlockDoorsConn = RunService.Heartbeat:Connect(function()
        if not unlockDoorsEnabled then
            return
        end

        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        local hrp = char.HumanoidRootPart

        local doors = Workspace.Map and Workspace.Map:FindFirstChild("Doors")
        if not doors then
            return
        end

        for _, door in pairs(doors:GetChildren()) do
            local doorBase = door:FindFirstChild("DoorBase")
            if doorBase and (hrp.Position - doorBase.Position).Magnitude <= 6 then
                local values = door:FindFirstChild("Values")
                local events = door:FindFirstChild("Events")

                if values and events then
                    local toggle = events:FindFirstChild("Toggle")
                    
                    if toggle then
                        -- Once kilit ac
                        local locked = values:FindFirstChild("Locked")
                        local lockPart = door:FindFirstChild("Lock")
                        
                        if locked and lockPart and locked.Value == true then
                            pcall(function()
                                toggle:FireServer("Unlock", lockPart)
                            end)
                        end

                        -- Sonra kapiyi ac
                        local openVal = values:FindFirstChild("Open")
                        local knob = door:FindFirstChild("Knob2") or door:FindFirstChild("Knob")
                        
                        if openVal and knob and openVal.Value == false then
                            pcall(function()
                                toggle:FireServer("Open", knob)
                            end)
                        end
                    end
                end
            end
        end
    end)
end

function UnlockDoors_Disable()
    unlockDoorsEnabled = false
    
    if unlockDoorsConn then
        unlockDoorsConn:Disconnect()
        unlockDoorsConn = nil
    end
end

-- ==================== ADMIN DETECTOR ====================
local adminCheckEnabled = false
local adminCheckConn = nil

-- Bilinen staff UserID'leri
local staffUsers = {
    3294804378, 93676120, 54087314, 81275825, 140837601, 1229486091,
    46567801, 418086275, 29706395, 3717066084, 1424338327, 5046662686,
    63238912, 111250044, 63315426, 730176906, 141193516, 194512073,
    193945439, 412741116, 195538733, 102045519, 955294, 957835150,
    25689921, 366613818, 281593651, 455275714, 208929505, 96783330,
    156152502, 93281166, 959606619, 142821118, 632886139, 175931803,
    122209625, 278097946, 142989311, 1517131734, 446849296, 87189764,
    67180844, 9212846, 47352513, 48058122, 155413858, 10497435,
    513615792, 55893752, 55476024, 151691292, 136584758, 16983447,
    3111449, 94693025, 271400893, 5005262660, 295331237, 64489098,
    244844600, 114332275, 25048901, 69262878, 50801509, 92504899,
    42066711, 50585425, 31365111, 166406495, 2457253857, 29761878,
    21831137, 948293345, 439942262, 38578487, 1163048, 7713309208,
    3659305297, 15598614, 34616594, 626833004, 198610386, 153835477,
    3923114296, 3937697838, 102146039, 119861460, 371665775, 1206543842,
    93428604, 1863173316, 90814576, 374665997, 423005063, 140172831,
    42662179, 9066859, 438805620, 14855669, 727189337, 1871290386, 608073286
}

local function checkStaff(player)
    if player == LocalPlayer then
        return false
    end

    for _, uid in pairs(staffUsers) do
        if player.UserId == uid then
            pcall(function()
                LocalPlayer:Kick("SANTES: Staff detected - " .. player.Name)
            end)
            return true
        end
    end
    
    return false
end

function AdminCheck_Enable()
    if adminCheckEnabled then
        return
    end
    
    adminCheckEnabled = true

    -- Sunucudaki mevcut oyunculari kontrol et
    for _, player in pairs(Players:GetPlayers()) do
        if checkStaff(player) then
            return
        end
    end

    -- Yeni girenleri izle
    adminCheckConn = Players.PlayerAdded:Connect(checkStaff)
end

function AdminCheck_Disable()
    adminCheckEnabled = false
    
    if adminCheckConn then
        adminCheckConn:Disconnect()
        adminCheckConn = nil
    end
end

-- ==================== PLAYER ESP ====================
local espEnabled = false
local espConnections = {}
local espPlayerList = {}

local function createESPForPlayer(player)
    if player == LocalPlayer or espPlayerList[player] then
        return
    end
    
    espPlayerList[player] = true

    local function setupESP(char)
        if not espEnabled or not char or not char.Parent then
            return
        end

        -- Highlight (kirmizi)
        local highlight = Instance.new("Highlight")
        highlight.Name = "SantesESP"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.65
        highlight.OutlineColor = Color3.fromRGB(255, 40, 40)
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = char

        -- Isim etiketi
        local head = char:FindFirstChild("Head")
        if head then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "SantesESPInfo"
            billboard.Size = UDim2.new(0, 100, 0, 30)
            billboard.StudsOffset = Vector3.new(0, 2.5, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = head

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.new(1, 1, 1)
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 12
            nameLabel.Parent = billboard
        end
    end

    if player.Character then
        setupESP(player.Character)
    end

    table.insert(espConnections, player.CharacterAdded:Connect(setupESP))
end

function ESP_Enable()
    if espEnabled then
        return
    end
    
    espEnabled = true
    espPlayerList = {}

    -- Mevcut oyunculara ESP ekle
    for _, player in pairs(Players:GetPlayers()) do
        createESPForPlayer(player)
    end

    -- Yeni girenlere ESP ekle
    table.insert(espConnections, Players.PlayerAdded:Connect(function(player)
        if espEnabled then
            createESPForPlayer(player)
        end
    end))

    -- Cikan oyunculari listeden cikar
    table.insert(espConnections, Players.PlayerRemoving:Connect(function(player)
        espPlayerList[player] = nil
    end))
end

function ESP_Disable()
    espEnabled = false

    -- Tum baglantilari kes
    for _, conn in pairs(espConnections) do
        pcall(function()
            conn:Disconnect()
        end)
    end
    
    espConnections = {}
    espPlayerList = {}

    -- Tum ESP elemanlarini temizle
    for _, player in pairs(Players:GetPlayers()) do
        pcall(function()
            if player.Character then
                local highlight = player.Character:FindFirstChild("SantesESP")
                if highlight then
                    highlight:Destroy()
                end

                for _, obj in pairs(player.Character:GetDescendants()) do
                    if obj:IsA("BillboardGui") and obj.Name == "SantesESPInfo" then
                        obj:Destroy()
                    end
                end
            end
        end)
    end
end

-- ==================== INVISIBILITY (SHADOW MODE) ====================
local invisEnabled = false
local invisUsable = true
local invisTrack = nil
local invisChar = nil
local invisHum = nil
local invisHRP = nil
local invisWarn = nil

do
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://215384594"

    local function updateRefs()
        invisChar = LocalPlayer.Character
        invisHum = invisChar and invisChar:FindFirstChildOfClass("Humanoid")
        invisHRP = invisChar and invisChar:FindFirstChild("HumanoidRootPart")
    end

    local function grounded()
        return invisHum 
            and invisHum:IsDescendantOf(Workspace) 
            and invisHum.FloorMaterial ~= Enum.Material.Air
    end

    local function loadTrack()
        if invisTrack then
            pcall(function() invisTrack:Stop() end)
            invisTrack = nil
        end
        
        if invisHum then
            local success, result = pcall(function()
                return invisHum:LoadAnimation(anim)
            end)
            
            if success then
                invisTrack = result
                invisTrack.Priority = Enum.AnimationPriority.Action4
            end
        end
    end

    RunService.Heartbeat:Connect(function(dt)
        if not invisEnabled or not invisUsable then
            if not invisEnabled and invisChar then
                for _, v in pairs(invisChar:GetDescendants()) do
                    if v:IsA("BasePart") and v.Transparency == 0.5 then
                        v.Transparency = 0
                    end
                end
            end
            if invisWarn then
                invisWarn.Visible = false
            end
            return
        end

        if not invisChar or not invisHum or not invisHRP or invisHum.Health <= 0 then
            if invisWarn then
                invisWarn.Visible = false
            end
            return
        end

        if invisWarn then
            invisWarn.Visible = not grounded()
        end

        if invisHum.MoveDirection.Magnitude > 0 then
            invisHRP.CFrame += invisHum.MoveDirection * 12 * dt
        end

        local oldCF = invisHRP.CFrame
        local oldOff = invisHum.CameraOffset

        local _, y = workspace.CurrentCamera.CFrame:ToOrientation()
        invisHRP.CFrame = CFrame.new(invisHRP.Position) 
            * CFrame.fromOrientation(0, y, 0) 
            * CFrame.Angles(math.rad(90), 0, 0)
        invisHum.CameraOffset = Vector3.new(0, 1.44, 0)

        if invisTrack then
            pcall(function()
                if not invisTrack.IsPlaying then
                    invisTrack:Play()
                end
                invisTrack:AdjustSpeed(0)
                invisTrack.TimePosition = 0.3
            end)
        elseif invisHum.Health > 0 then
            loadTrack()
        end

        RunService.RenderStepped:Wait()

        if invisHum:IsDescendantOf(Workspace) then
            invisHum.CameraOffset = oldOff
        end
        
        if invisHRP:IsDescendantOf(Workspace) then
            invisHRP.CFrame = oldCF
        end

        if invisTrack then
            pcall(function() invisTrack:Stop() end)
        end

        if invisHRP:IsDescendantOf(Workspace) then
            local lookVec = workspace.CurrentCamera.CFrame.LookVector
            local flat = Vector3.new(lookVec.X, 0, lookVec.Z).Unit
            if flat.Magnitude > 0.1 then
                invisHRP.CFrame = CFrame.new(invisHRP.Position, invisHRP.Position + flat)
            end
        end

        for _, v in pairs(invisChar:GetDescendants()) do
            if v:IsA("BasePart") and v.Transparency ~= 1 then
                v.Transparency = 0.5
            end
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        if invisTrack then
            pcall(function() invisTrack:Stop() end)
            invisTrack = nil
        end
        
        task.wait()
        updateRefs()

        if invisHum and invisHum.RigType ~= Enum.HumanoidRigType.R6 then
            invisUsable = false
            if invisEnabled then
                Invis_Disable()
            end
            
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "SANTES Invisibility",
                    Text = "R6 avatar gerekli! Su anki: " .. tostring(invisHum.RigType),
                    Duration = 5
                })
            end)
        else
            invisUsable = true
            if invisEnabled then
                workspace.CurrentCamera.CameraSubject = invisHRP
                loadTrack()
            end
        end
    end)

    updateRefs()
    
    if invisHum and invisHum.RigType ~= Enum.HumanoidRigType.R6 then
        invisUsable = false
    end

    -- Uyari GUI'si
    local invisGUI = Instance.new("ScreenGui")
    invisGUI.Name = "InvisWarning"
    invisGUI.Parent = CoreGui
    invisGUI.ResetOnSpawn = false

    invisWarn = Instance.new("TextLabel", invisGUI)
    invisWarn.Text = "VISIBLE!"
    invisWarn.Visible = false
    invisWarn.Size = UDim2.new(0, 200, 0, 30)
    invisWarn.Position = UDim2.new(0.5, -100, 0.85, 0)
    invisWarn.BackgroundTransparency = 1
    invisWarn.Font = Enum.Font.GothamBold
    invisWarn.TextSize = 24
    invisWarn.TextColor3 = Color3.fromRGB(255, 255, 0)
    invisWarn.TextStrokeTransparency = 0.5

    _G.Invis_Enable = function()
        if invisEnabled or not invisUsable then
            return
        end
        
        invisEnabled = true
        updateRefs()
        
        if invisHRP then
            workspace.CurrentCamera.CameraSubject = invisHRP
        end
        
        loadTrack()
    end

    _G.Invis_Disable = function()
        if not invisEnabled then
            return
        end
        
        invisEnabled = false
        
        if invisTrack then
            pcall(function() invisTrack:Stop() end)
        end
        
        if invisHum then
            workspace.CurrentCamera.CameraSubject = invisHum
        end
        
        if invisChar then
            for _, v in pairs(invisChar:GetDescendants()) do
                if v:IsA("BasePart") and v.Transparency == 0.5 then
                    v.Transparency = 0
                end
            end
        end
        
        if invisWarn then
            invisWarn.Visible = false
        end
    end

    _G.IsInvisEnabled = function()
        return invisEnabled
    end
end

function Invis_Enable()
    _G.Invis_Enable()
end

function Invis_Disable()
    _G.Invis_Disable()
end

-- ==================== NO RECOIL ====================
local noRecoilEnabled = false
local noRecoilTask = nil

function NoRecoil_Enable()
    if noRecoilEnabled then
        return
    end
    
    noRecoilEnabled = true

    noRecoilTask = task.spawn(function()
        while noRecoilEnabled do
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == 'table' then
                        if rawget(v, 'Recoil') ~= nil then
                            v.Recoil = 0
                            v.Spread = 0
                            v.CameraRecoilingEnabled = false
                        end
                        
                        if rawget(v, 'AngleX_Min') ~= nil then
                            v.AngleX_Min = 0
                            v.AngleX_Max = 0
                            v.AngleY_Min = 0
                            v.AngleY_Max = 0
                            v.AngleZ_Min = 0
                            v.AngleZ_Max = 0
                        end
                    end
                end
            end)
            
            task.wait(1)
        end
    end)
end

function NoRecoil_Disable()
    noRecoilEnabled = false
    
    if noRecoilTask then
        task.cancel(noRecoilTask)
        noRecoilTask = nil
    end
end

-- ==================== SILENT AIM ====================
local silentAimEnabled = false
local silentAimConn = nil
local silentAimFOV = 150

function SilentAim_Enable()
    if silentAimEnabled then
        return
    end
    
    silentAimEnabled = true

    silentAimConn = RunService.RenderStepped:Connect(function()
        if not silentAimEnabled then
            return
        end

        local cam = workspace.CurrentCamera
        if not cam then
            return
        end

        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then
            return
        end

        local screenCenter = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        
        local closestPlayer = nil
        local closestDistance = silentAimFOV

        -- Tum oyunculari tara
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                local targetPart = player.Character:FindFirstChild("Head") 
                    or player.Character:FindFirstChild("HumanoidRootPart")

                if hum and hum.Health > 0 and targetPart then
                    local screenPos, onScreen = cam:WorldToViewportPoint(targetPart.Position)

                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude

                        if distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = player
                        end
                    end
                end
            end
        end

        -- Hedefe hitbox ekle (kamera oynamaz, mermiler hedefe gider)
        if closestPlayer and closestPlayer.Character then
            local targetPart = closestPlayer.Character:FindFirstChild("Head") 
                or closestPlayer.Character:FindFirstChild("HumanoidRootPart")

            if targetPart then
                local hitbox = targetPart:FindFirstChild("SantesHitbox")
                if not hitbox then
                    local newHitbox = Instance.new("Part")
                    newHitbox.Name = "SantesHitbox"
                    newHitbox.Size = Vector3.new(5, 5, 5)
                    newHitbox.Transparency = 1
                    newHitbox.CanCollide = false
                    newHitbox.Anchored = false
                    newHitbox.Massless = true
                    newHitbox.Parent = targetPart
                    
                    local weld = Instance.new("WeldConstraint")
                    weld.Part0 = newHitbox
                    weld.Part1 = targetPart
                    weld.Parent = newHitbox
                end
            end
        end
    end)
end

function SilentAim_Disable()
    silentAimEnabled = false
    
    if silentAimConn then
        silentAimConn:Disconnect()
        silentAimConn = nil
    end

    -- Tum hitbox'lari temizle
    for _, player in pairs(Players:GetPlayers()) do
        pcall(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name == "SantesHitbox" then
                        part:Destroy()
                    end
                end
            end
        end)
    end
end

function SilentAim_SetFOV(value)
    silentAimFOV = math.clamp(value, 50, 500)
end

function SilentAim_GetFOV()
    return silentAimFOV
end

-- ==================== MELEE AURA ====================
local meleeAuraEnabled = false
local meleeAuraConn = nil
local meleeTarget = "Head"

function MeleeAura_Enable()
    if meleeAuraEnabled then
        return
    end
    
    meleeAuraEnabled = true

    local eventsFolder = ReplicatedStorage:FindFirstChild("Events")
        or ReplicatedStorage:WaitForChild("Events", 10)
    
    if not eventsFolder then
        return
    end

    local remote1 = eventsFolder:FindFirstChild("XMHH.2")
        or eventsFolder:WaitForChild("XMHH.2", 5)
    
    local remote2 = eventsFolder:FindFirstChild("XMHH2.2")
        or eventsFolder:WaitForChild("XMHH2.2", 5)

    if not remote1 or not remote2 then
        return
    end

    meleeAuraConn = RunService.Heartbeat:Connect(function()
        if not meleeAuraEnabled then
            return
        end

        local myChar = LocalPlayer.Character
        if not myChar then
            return
        end

        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then
            return
        end

        -- Eldeki herhangi bir tool (silah, levye, bicak, vs) veya yumruk
        local tool = myChar:FindFirstChildOfClass("Tool")
        
        local closestEnemy = nil
        local shortestDist = 6

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local enemyHRP = player.Character:FindFirstChild("HumanoidRootPart")
                local enemyHum = player.Character:FindFirstChildOfClass("Humanoid")

                if enemyHRP and enemyHum 
                    and enemyHum.Health > 15 
                    and not player.Character:FindFirstChildOfClass("ForceField") then
                    
                    local dist = (myHRP.Position - enemyHRP.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestEnemy = player
                    end
                end
            end
        end

        if not closestEnemy then
            return
        end

        local targetChar = closestEnemy.Character
        local targetPart = targetChar:FindFirstChild(meleeTarget)

        if not targetPart then
            return
        end

        -- Tool yoksa yumruk olarak calis (Right Arm kullan)
        local fakeTool = tool or myChar:FindFirstChild("Right Arm") or myHRP

        local result = remote1:InvokeServer(
            "\240\159\141\158",
            tick(),
            fakeTool,
            "43TRFWX",
            "Normal",
            tick(),
            true
        )

        if result then
            -- Handle: tool varsa onun Handle'i, yoksa Right Arm
            local handle = nil
            if tool then
                handle = tool:FindFirstChild("WeaponHandle") or tool:FindFirstChild("Handle")
            end
            
            if not handle then
                handle = myChar:FindFirstChild("Right Arm")
            end

            if handle then
                remote2:FireServer(
                    "\240\159\141\158",
                    tick(),
                    fakeTool,
                    "2389ZFX34",
                    result,
                    false,
                    handle,
                    targetPart,
                    targetChar,
                    myHRP.Position,
                    targetPart.Position
                )
            end
        end

        task.wait(0.08)
    end)
end

function MeleeAura_Disable()
    meleeAuraEnabled = false
    
    if meleeAuraConn then
        meleeAuraConn:Disconnect()
        meleeAuraConn = nil
    end
end

function MeleeAura_SetTarget(target)
    if target == "Head" or target == "Body" then
        meleeTarget = target == "Body" and "HumanoidRootPart" or "Head"
    end
end

function MeleeAura_GetTarget()
    return meleeTarget == "Head" and "Head" or "Body"
end

-- ==================== INFINITE STAMINA ====================
local infStaminaEnabled = false
local infStaminaConn = nil

function InfiniteStamina_Enable()
    if infStaminaEnabled then
        return
    end
    
    infStaminaEnabled = true

    infStaminaConn = RunService.RenderStepped:Connect(function()
        if not infStaminaEnabled then
            return
        end
        
        local char = LocalPlayer.Character
        if not char then
            return
        end
        
        -- Tum Humanoid'lerin stamina'sini max yap
        for _, hum in pairs(char:GetDescendants()) do
            if hum:IsA("Humanoid") and hum.MaxStamina and hum.Stamina then
                hum.Stamina = hum.MaxStamina
            end
        end
    end)
end

function InfiniteStamina_Disable()
    infStaminaEnabled = false
    
    if infStaminaConn then
        infStaminaConn:Disconnect()
        infStaminaConn = nil
    end
end

-- ==================== AUTO FARM ====================
local autoFarmEnabled = false
local autoFarmCoroutine = nil
local farmIgnored = {}

local function farmTeleport(pos)
    local char = LocalPlayer.Character
    if not char then
        return false
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return false
    end

    for i = 1, 4 do
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
        task.wait(0.5)
        
        if hrp and hrp.Parent and (hrp.Position - pos).Magnitude < 5 then
            return true
        end
        
        task.wait(0.5)
    end
    
    return false
end

local function farmFindDealer()
    local shops = Workspace.Map and Workspace.Map:FindFirstChild("Shopz")
    if not shops then
        return nil
    end

    local char = LocalPlayer.Character
    if not char then
        return nil
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return nil
    end

    local nearest = nil
    local best = math.huge

    for _, shop in pairs(shops:GetChildren()) do
        local main = shop:FindFirstChild("MainPart")
        local stocks = shop:FindFirstChild("CurrentStocks")

        if main and stocks then
            local crowbarStock = stocks:FindFirstChild("Crowbar")
            if crowbarStock and crowbarStock.Value > 0 then
                local d = (main.Position - hrp.Position).Magnitude
                if d < best then
                    best = d
                    nearest = shop
                end
            end
        end
    end
    
    return nearest
end

local function farmFindTarget()
    local folder = Workspace.Map and Workspace.Map:FindFirstChild("BredMakurz")
    if not folder then
        folder = Workspace.Filter and Workspace.Filter:FindFirstChild("BredMakurz")
    end
    if not folder then
        folder = Workspace:FindFirstChild("BredMakurz")
    end
    if not folder then
        return nil
    end

    local char = LocalPlayer.Character
    if not char then
        return nil
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return nil
    end

    local nearest = nil
    local best = math.huge

    for _, obj in pairs(folder:GetChildren()) do
        if (string.find(obj.Name, "Safe") or string.find(obj.Name, "Register")) 
            and not table.find(farmIgnored, obj) then
            
            local values = obj:FindFirstChild("Values")
            if values then
                local broken = values:FindFirstChild("Broken")
                if broken and broken:IsA("BoolValue") and not broken.Value then
                    local tp = obj.PrimaryPart 
                        or obj:FindFirstChild("MainPart") 
                        or obj:FindFirstChildOfClass("BasePart")

                    if tp then
                        local d = (tp.Position - hrp.Position).Magnitude
                        if d < best then
                            best = d
                            nearest = obj
                        end
                    end
                end
            end
        end
    end
    
    return nearest
end

local function farmHasTool(name)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild(name) then
        return true
    end
    
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    return backpack and backpack:FindFirstChild(name) ~= nil
end

local function farmEquipTool(name)
    local char = LocalPlayer.Character
    if not char then
        return false
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then
        return false
    end

    local tool = char:FindFirstChild(name) or LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Backpack:FindFirstChild(name)
    if tool then
        pcall(function()
            hum:EquipTool(tool)
        end)
        task.wait(0.5)
        return true
    end
    
    return false
end

local function farmOpenSafe(safe)
    if not farmHasTool("Crowbar") then
        return
    end
    
    if not farmEquipTool("Crowbar") then
        return
    end

    local remote1 = ReplicatedStorage.Events:FindFirstChild("XMHH.2")
    local remote2 = ReplicatedStorage.Events:FindFirstChild("XMHH2.2")
    local safePart = safe:FindFirstChild("MainPart")

    if not remote1 or not remote2 or not safePart then
        return
    end

    local equipped = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Crowbar")
    if not equipped then
        return
    end

    local startTime = tick()
    
    while safe and safe.Parent 
        and safe:FindFirstChild("Values") 
        and safe.Values:FindFirstChild("Broken") 
        and not safe.Values.Broken.Value 
        and (tick() - startTime < 20) do
        
        local char = LocalPlayer.Character
        if not char then
            break
        end

        local result = remote1:InvokeServer(
            "\240\159\141\158",
            tick(),
            equipped,
            "DZDRRRKI",
            safe,
            "Register"
        )

        if result then
            remote2:FireServer(
                "\240\159\141\158",
                tick(),
                equipped,
                "2389ZFX34",
                result,
                false,
                char["Right Arm"],
                safePart,
                safe,
                safePart.Position,
                safePart.Position
            )
        end
        
        task.wait(0.2)
    end
    
    task.wait(8)
end

local function farmBuyCrowbar(dealer)
    if not dealer then
        return false
    end

    local main = dealer:FindFirstChild("MainPart")
    if not main then
        return false
    end

    if not farmTeleport(main.Position) then
        return false
    end
    
    task.wait(1)

    local byzersEvent = ReplicatedStorage.Events:FindFirstChild("BYZERSPROTEC")
    local shopEvent = ReplicatedStorage.Events:FindFirstChild("SSHPRMTE1")
    
    if not byzersEvent or not shopEvent then
        return false
    end

    byzersEvent:FireServer(true, "shop", main, "IllegalStore")
    task.wait(1)
    shopEvent:InvokeServer("IllegalStore", "Melees", "Crowbar", main, nil, true)
    task.wait(2)
    byzersEvent:FireServer(false)

    return farmHasTool("Crowbar")
end

local function farmLoop()
    while autoFarmEnabled do
        task.wait(1)

        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        -- Olu/Respawn kontrolu
        if not char or not hum or hum.Health <= 0 then
            local deathEvent = ReplicatedStorage.Events:FindFirstChild("DeathRespawn")
            if deathEvent then
                pcall(function()
                    deathEvent:InvokeServer("KMG4R904")
                end)
            end
            
            task.wait(3)
            farmIgnored = {}
            continue
        end

        -- Levye yoksa satin al
        if not farmHasTool("Crowbar") then
            local dealer = farmFindDealer()
            if dealer then
                farmBuyCrowbar(dealer)
            else
                task.wait(5)
            end
            continue
        end

        -- Safe bul ve soy
        local target = farmFindTarget()
        if target then
            local mainPart = target:FindFirstChild("MainPart") or target.PrimaryPart
            if mainPart then
                if farmTeleport(mainPart.Position) then
                    task.wait(1)
                    farmOpenSafe(target)
                else
                    table.insert(farmIgnored, target)
                    task.wait(0.5)
                end
            end
        else
            farmIgnored = {}
            task.wait(5)
        end
    end
end

function AutoFarm_Enable()
    if autoFarmEnabled then
        return
    end
    
    autoFarmEnabled = true
    farmIgnored = {}

    if autoFarmCoroutine then
        task.cancel(autoFarmCoroutine)
        autoFarmCoroutine = nil
    end

    -- Bagimli modulleri ac
    AutoPickup_Enable()
    Noclip_Enable()

    autoFarmCoroutine = task.spawn(farmLoop)

    -- Respawn handler
    LocalPlayer.CharacterAdded:Connect(function()
        if autoFarmEnabled then
            task.wait(2)
            AutoPickup_Enable()
            Noclip_Enable()
        end
    end)
end

function AutoFarm_Disable()
    autoFarmEnabled = false
    
    if autoFarmCoroutine then
        task.cancel(autoFarmCoroutine)
        autoFarmCoroutine = nil
    end
    
    farmIgnored = {}
    AutoPickup_Disable()
end

-- #####################################################################
-- #                         MAIN UI                                  #
-- #####################################################################

local function createMainUI()
    -- Ana ScreenGui
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "SantesHub_Main"
    mainGui.ResetOnSpawn = false
    mainGui.IgnoreGuiInset = true
    mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    mainGui.Parent = PlayerGui

    -- Arkaplan karartma
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.55
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 1
    overlay.Parent = mainGui

    -- Ana pencere
    local WIN_W = 600
    local WIN_H = 480
    
    local win = Instance.new("Frame")
    win.Size = UDim2.new(0, WIN_W, 0, WIN_H)
    win.Position = UDim2.new(0.5, 0, 0.5, 0)
    win.AnchorPoint = Vector2.new(0.5, 0.5)
    win.BackgroundColor3 = C.bg
    win.BorderSizePixel = 0
    win.ClipsDescendants = true
    win.ZIndex = 5
    win.Parent = mainGui
    addCorner(win, 14)
    addStroke(win, C.border, 1)

    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 56)
    titleBar.BackgroundColor3 = C.panel
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 10
    titleBar.Parent = win

    local titleAccent = Instance.new("Frame")
    titleAccent.Size = UDim2.new(0, 4, 1, 0)
    titleAccent.BackgroundColor3 = C.accent
    titleAccent.BorderSizePixel = 0
    titleAccent.ZIndex = 11
    titleAccent.Parent = titleBar

    local logoText = Instance.new("TextLabel")
    logoText.Size = UDim2.new(0, 140, 1, 0)
    logoText.Position = UDim2.new(0, 18, 0, 0)
    logoText.BackgroundTransparency = 1
    logoText.Text = "SANTES"
    logoText.Font = Enum.Font.Impact
    logoText.TextSize = 28
    logoText.TextColor3 = C.textPrimary
    logoText.TextXAlignment = Enum.TextXAlignment.Left
    logoText.ZIndex = 11
    logoText.Parent = titleBar

    local hubTag = Instance.new("TextLabel")
    hubTag.Size = UDim2.new(0, 44, 0, 16)
    hubTag.Position = UDim2.new(0, 100, 0.5, -2)
    hubTag.BackgroundColor3 = C.accentDim
    hubTag.Text = "HUB"
    hubTag.Font = Enum.Font.GothamBold
    hubTag.TextSize = 9
    hubTag.TextColor3 = C.accent
    hubTag.TextXAlignment = Enum.TextXAlignment.Center
    hubTag.ZIndex = 12
    hubTag.Parent = titleBar
    addCorner(hubTag, 4)

    local verLabel = Instance.new("TextLabel")
    verLabel.Size = UDim2.new(0, 70, 1, 0)
    verLabel.Position = UDim2.new(0, 152, 0, 0)
    verLabel.BackgroundTransparency = 1
    verLabel.Text = "v3.1"
    verLabel.Font = Enum.Font.Gotham
    verLabel.TextSize = 11
    verLabel.TextColor3 = C.textMuted
    verLabel.TextXAlignment = Enum.TextXAlignment.Left
    verLabel.ZIndex = 11
    verLabel.Parent = titleBar

    -- Pencere butonlari
    local function makeWindowBtn(offsetX, icon, bgColor)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 32, 0, 32)
        btn.Position = UDim2.new(1, offsetX, 0.5, -16)
        btn.BackgroundColor3 = bgColor
        btn.Text = icon
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        btn.TextColor3 = C.textPrimary
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.ZIndex = 12
        btn.Parent = titleBar
        addCorner(btn, 8)
        return btn
    end

    local minimizeBtn = makeWindowBtn(-80, "—", C.card)
    local closeBtn = makeWindowBtn(-42, "✕", C.accent)

    -- Title alt cizgisi
    local titleLine = Instance.new("Frame")
    titleLine.Size = UDim2.new(1, 0, 0, 1)
    titleLine.Position = UDim2.new(0, 0, 0, 56)
    titleLine.BackgroundColor3 = C.border
    titleLine.BorderSizePixel = 0
    titleLine.ZIndex = 10
    titleLine.Parent = win

    -- Sidebar
    local SIDEBAR_W = 158
    
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, -57)
    sidebar.Position = UDim2.new(0, 0, 0, 57)
    sidebar.BackgroundColor3 = C.panel
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 9
    sidebar.Parent = win

    local sidebarLine = Instance.new("Frame")
    sidebarLine.Size = UDim2.new(0, 1, 1, -57)
    sidebarLine.Position = UDim2.new(0, SIDEBAR_W, 0, 57)
    sidebarLine.BackgroundColor3 = C.border
    sidebarLine.BorderSizePixel = 0
    sidebarLine.ZIndex = 9
    sidebarLine.Parent = win

    local sidebarInner = Instance.new("Frame")
    sidebarInner.Size = UDim2.new(1, 0, 1, 0)
    sidebarInner.BackgroundTransparency = 1
    sidebarInner.Parent = sidebar
    addPadding(sidebarInner, nil, 14, 14, 10, 10)

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 6)
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarLayout.Parent = sidebarInner

    -- Sidebar footer
    local sideFooter = Instance.new("Frame")
    sideFooter.Size = UDim2.new(1, 0, 0, 52)
    sideFooter.Position = UDim2.new(0, 0, 1, -52)
    sideFooter.BackgroundColor3 = C.card
    sideFooter.BorderSizePixel = 0
    sideFooter.ZIndex = 10
    sideFooter.Parent = sidebar

    local sideFooterLine = Instance.new("Frame")
    sideFooterLine.Size = UDim2.new(1, 0, 0, 1)
    sideFooterLine.BackgroundColor3 = C.border
    sideFooterLine.BorderSizePixel = 0
    sideFooterLine.ZIndex = 11
    sideFooterLine.Parent = sideFooter

    local sideUserName = Instance.new("TextLabel")
    sideUserName.Size = UDim2.new(1, -12, 0, 18)
    sideUserName.Position = UDim2.new(0, 10, 0, 8)
    sideUserName.BackgroundTransparency = 1
    sideUserName.Text = LocalPlayer.Name
    sideUserName.Font = Enum.Font.GothamBold
    sideUserName.TextSize = 12
    sideUserName.TextColor3 = C.textPrimary
    sideUserName.TextXAlignment = Enum.TextXAlignment.Left
    sideUserName.ZIndex = 11
    sideUserName.Parent = sideFooter

    local sideStatus = Instance.new("TextLabel")
    sideStatus.Size = UDim2.new(1, -12, 0, 14)
    sideStatus.Position = UDim2.new(0, 10, 0, 28)
    sideStatus.BackgroundTransparency = 1
    sideStatus.Text = "● AKTIF"
    sideStatus.Font = Enum.Font.Gotham
    sideStatus.TextSize = 10
    sideStatus.TextColor3 = C.green
    sideStatus.TextXAlignment = Enum.TextXAlignment.Left
    sideStatus.ZIndex = 11
    sideStatus.Parent = sideFooter

    -- Content Area
    local contentArea = Instance.new("ScrollingFrame")
    contentArea.Size = UDim2.new(1, -(SIDEBAR_W + 1), 1, -57)
    contentArea.Position = UDim2.new(0, SIDEBAR_W + 1, 0, 57)
    contentArea.BackgroundTransparency = 1
    contentArea.BorderSizePixel = 0
    contentArea.ScrollingDirection = Enum.ScrollingDirection.Y
    contentArea.ScrollBarThickness = 4
    contentArea.ScrollBarImageColor3 = C.accentDim
    contentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentArea.ZIndex = 9
    contentArea.Parent = win
    addPadding(contentArea, nil, 16, 16, 16, 16)

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 12)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.Parent = contentArea

    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentArea.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 32)
    end)

    -- TAB SISTEMI
    local pages = {}
    local activeTab = nil
    local tabOrder = 0

    local function makeTab(name, icon)
        tabOrder = tabOrder + 1
        
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.Size = UDim2.new(1, 0, 0, 42)
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.LayoutOrder = tabOrder
        btn.ZIndex = 11
        btn.Parent = sidebarInner

        local tabBg = Instance.new("Frame")
        tabBg.Size = UDim2.new(1, 0, 1, 0)
        tabBg.BackgroundColor3 = C.card
        tabBg.BackgroundTransparency = 1
        tabBg.BorderSizePixel = 0
        tabBg.ZIndex = 11
        tabBg.Parent = btn
        addCorner(tabBg, 8)

        local tabBar = Instance.new("Frame")
        tabBar.Size = UDim2.new(0, 4, 0.6, 0)
        tabBar.Position = UDim2.new(0, 0, 0.2, 0)
        tabBar.BackgroundColor3 = C.accent
        tabBar.BackgroundTransparency = 1
        tabBar.BorderSizePixel = 0
        tabBar.ZIndex = 13
        tabBar.Parent = btn
        addCorner(tabBar, 2)

        local iconLbl = Instance.new("TextLabel")
        iconLbl.Size = UDim2.new(0, 28, 1, 0)
        iconLbl.Position = UDim2.new(0, 12, 0, 0)
        iconLbl.BackgroundTransparency = 1
        iconLbl.Text = icon
        iconLbl.Font = Enum.Font.GothamBold
        iconLbl.TextSize = 16
        iconLbl.TextColor3 = C.textMuted
        iconLbl.ZIndex = 12
        iconLbl.Parent = btn

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, -48, 1, 0)
        nameLbl.Position = UDim2.new(0, 44, 0, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = name
        nameLbl.Font = Enum.Font.GothamSemibold
        nameLbl.TextSize = 12
        nameLbl.TextColor3 = C.textMuted
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.ZIndex = 12
        nameLbl.Parent = btn

        local tabData = { bg = tabBg, lbl = nameLbl, bar = tabBar, icon = iconLbl }
        pages[name] = tabData

        btn.MouseEnter:Connect(function()
            if activeTab ~= tabData then
                tween(tabBg, { BackgroundTransparency = 0.6 }, 0.15)
                tween(nameLbl, { TextColor3 = C.textSub }, 0.15)
            end
        end)
        
        btn.MouseLeave:Connect(function()
            if activeTab ~= tabData then
                tween(tabBg, { BackgroundTransparency = 1 }, 0.15)
                tween(nameLbl, { TextColor3 = C.textMuted }, 0.15)
            end
        end)

        return tabData
    end

    local function switchPage(tabData)
        if activeTab == tabData then
            return
        end
        
        if activeTab then
            tween(activeTab.bg, { BackgroundTransparency = 1 }, 0.2)
            tween(activeTab.lbl, { TextColor3 = C.textMuted }, 0.2)
            tween(activeTab.bar, { BackgroundTransparency = 1 }, 0.2)
        end
        
        tween(tabData.bg, { BackgroundTransparency = 0 }, 0.2)
        tween(tabData.lbl, { TextColor3 = C.accent }, 0.2)
        tween(tabData.bar, { BackgroundTransparency = 0 }, 0.2)
        
        activeTab = tabData
    end

    -- UI yardimcilari
    local function makeHeader(text, order)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -32, 0, 20)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.TextColor3 = C.accent
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.LayoutOrder = order or 0
        lbl.ZIndex = 10
        lbl.Parent = contentArea
        return lbl
    end

    local function makeCard(height, order)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -32, 0, height)
        f.BackgroundColor3 = C.card
        f.BorderSizePixel = 0
        f.LayoutOrder = order or 0
        f.ZIndex = 10
        f.Parent = contentArea
        addCorner(f, 10)
        addStroke(f, C.border, 1, 0.5)
        return f
    end

    local function makeToggleRow(name, canToggle, isEnabledFn, onEnable, onDisable)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -32, 0, 48)
        frame.BackgroundColor3 = C.card
        frame.BorderSizePixel = 0
        frame.LayoutOrder = 1
        addCorner(frame, 10)
        addStroke(frame, C.border, 1, 0.5)

        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        layout.Padding = UDim.new(0, 12)
        layout.Parent = frame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.5, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = C.textSub
        label.Font = Enum.Font.GothamSemibold
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 74, 0, 34)
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.TextSize = 12
        toggleBtn.TextColor3 = C.textPrimary
        toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        toggleBtn.BorderSizePixel = 0
        toggleBtn.AutoButtonColor = false
        toggleBtn.Parent = frame
        addCorner(toggleBtn, 17)

        local function updateVisuals()
            local state = false
            if isEnabledFn then
                local s, r = pcall(isEnabledFn)
                if s then state = r end
            end
            
            if not canToggle then
                toggleBtn.Text = "RUN"
                toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 220)
            elseif state then
                toggleBtn.Text = "ON"
                toggleBtn.BackgroundColor3 = C.accent
            else
                toggleBtn.Text = "OFF"
                toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            end
        end

        updateVisuals()

        toggleBtn.MouseButton1Click:Connect(function()
            local state = false
            if isEnabledFn then
                local s, r = pcall(isEnabledFn)
                if s then state = r end
            end
            
            if not canToggle then
                if onEnable then
                    pcall(onEnable)
                end
                toggleBtn.Text = "✓"
                toggleBtn.BackgroundColor3 = C.green
                toggleBtn.Active = false
                return
            end
            
            if state then
                if onDisable then
                    pcall(onDisable)
                end
            else
                if onEnable then
                    pcall(onEnable)
                end
            end
            
            updateVisuals()
        end)

        return frame
    end

    -- KATEGORI ICERIKLERI
    local tabFunctions = {}

    tabFunctions["COMBAT"] = function()
        makeHeader("COMBAT", 1)
        makeToggleRow("Silent Aim", true, function() return silentAimEnabled end, SilentAim_Enable, SilentAim_Disable).LayoutOrder = 2
        makeToggleRow("Melee Aura", true, function() return meleeAuraEnabled end, MeleeAura_Enable, MeleeAura_Disable).LayoutOrder = 3
        makeToggleRow("No Recoil", true, function() return noRecoilEnabled end, NoRecoil_Enable, NoRecoil_Disable).LayoutOrder = 4
    end

    tabFunctions["MOVEMENT"] = function()
        makeHeader("MOVEMENT", 1)
        makeToggleRow("Fly", true, function() return flyEnabled end, Fly_Enable, Fly_Disable).LayoutOrder = 2
        makeToggleRow("Noclip", true, function() return noclipEnabled end, Noclip_Enable, Noclip_Disable).LayoutOrder = 3
        makeToggleRow("Inf Stamina", true, function() return infStaminaEnabled end, InfiniteStamina_Enable, InfiniteStamina_Disable).LayoutOrder = 4
        makeToggleRow("Invisibility", true, _G.IsInvisEnabled, _G.Invis_Enable, _G.Invis_Disable).LayoutOrder = 5
    end

    tabFunctions["VISUALS"] = function()
        makeHeader("VISUALS", 1)
        makeToggleRow("Player ESP", true, function() return espEnabled end, ESP_Enable, ESP_Disable).LayoutOrder = 2
        makeToggleRow("Safe ESP", true, function() return safeESPEnabled end, SafeESP_Enable, SafeESP_Disable).LayoutOrder = 3
        makeToggleRow("FullBright", true, function() return fullbrightEnabled end, FullBright_Enable, FullBright_Disable).LayoutOrder = 4
        makeToggleRow("FOV", true, function() return fovEnabled end, FOV_Enable, FOV_Disable).LayoutOrder = 5
    end

    tabFunctions["FARMING"] = function()
        makeHeader("FARMING", 1)
        makeToggleRow("Auto Farm", true, function() return autoFarmEnabled end, AutoFarm_Enable, AutoFarm_Disable).LayoutOrder = 2
        makeToggleRow("Auto Pickup $", true, function() return autoPickupEnabled end, AutoPickup_Enable, AutoPickup_Disable).LayoutOrder = 3
        makeToggleRow("No Fail Lockpick", true, function() return noFailLPEnabled end, NoFailLP_Enable, NoFailLP_Disable).LayoutOrder = 4
        makeToggleRow("Auto Lockpick", true, function() return autoLockpickEnabled end, AutoLockpick_Enable, AutoLockpick_Disable).LayoutOrder = 5
    end

    tabFunctions["MISC"] = function()
        makeHeader("MISC", 1)
        makeToggleRow("Admin Detector", true, function() return adminCheckEnabled end, AdminCheck_Enable, AdminCheck_Disable).LayoutOrder = 2
        makeToggleRow("Auto Unlock Doors", true, function() return unlockDoorsEnabled end, UnlockDoors_Enable, UnlockDoors_Disable).LayoutOrder = 3
    end

    local function clearAndLoad(tabName, tabData)
        switchPage(tabData)
        
        -- Content'i temizle
        for _, child in pairs(contentArea:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end
        
        -- Yeni icerigi yukle
        if tabFunctions[tabName] then
            tabFunctions[tabName]()
        end
        
        contentArea.CanvasPosition = Vector2.new(0, 0)
    end

    -- TABLARI OLUSTUR VE BAGLA
    local combatTab = makeTab("COMBAT", "⚔")
    local moveTab = makeTab("MOVEMENT", "🏃")
    local visTab = makeTab("VISUALS", "👁")
    local farmTab = makeTab("FARMING", "💰")
    local miscTab = makeTab("MISC", "🔧")

    -- Her tab'a tiklayinca icerik yukle
    for _, item in pairs(sidebarInner:GetChildren()) do
        if item:IsA("TextButton") then
            item.MouseButton1Click:Connect(function()
                local tabName = item.Name
                local tabData = pages[tabName]
                if tabData then
                    clearAndLoad(tabName, tabData)
                end
            end)
        end
    end

    -- Kucultulmus mod
    local miniFrame = Instance.new("Frame")
    miniFrame.Size = UDim2.new(0, 72, 0, 72)
    miniFrame.Position = UDim2.new(0, 24, 0, 24)
    miniFrame.BackgroundColor3 = C.panel
    miniFrame.BorderSizePixel = 0
    miniFrame.Visible = false
    miniFrame.Active = true
    miniFrame.Draggable = true
    miniFrame.ZIndex = 999
    miniFrame.Parent = mainGui
    addCorner(miniFrame, 36)
    addStroke(miniFrame, C.accent, 2)

    local miniLbl = Instance.new("TextLabel")
    miniLbl.Size = UDim2.new(1, 0, 0.5, 0)
    miniLbl.Position = UDim2.new(0, 0, 0.18, 0)
    miniLbl.BackgroundTransparency = 1
    miniLbl.Text = "SANTES"
    miniLbl.Font = Enum.Font.Impact
    miniLbl.TextSize = 14
    miniLbl.TextColor3 = C.accent
    miniLbl.TextXAlignment = Enum.TextXAlignment.Center
    miniLbl.ZIndex = 1000
    miniLbl.Parent = miniFrame

    local miniSub = Instance.new("TextLabel")
    miniSub.Size = UDim2.new(1, 0, 0.3, 0)
    miniSub.Position = UDim2.new(0, 0, 0.62, 0)
    miniSub.BackgroundTransparency = 1
    miniSub.Text = "HUB"
    miniSub.Font = Enum.Font.GothamBold
    miniSub.TextSize = 10
    miniSub.TextColor3 = C.textMuted
    miniSub.TextXAlignment = Enum.TextXAlignment.Center
    miniSub.ZIndex = 1000
    miniSub.Parent = miniFrame

    -- KONTROLLER
    minimizeBtn.MouseButton1Click:Connect(function()
        win.Visible = false
        overlay.Visible = false
        miniFrame.Visible = true
    end)

    miniFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 
            or input.UserInputType == Enum.UserInputType.Touch then
            miniFrame.Visible = false
            win.Visible = true
            overlay.Visible = true
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        -- Tum modulleri kapat
        pcall(function() if flyEnabled then Fly_Disable() end end)
        pcall(function() if noclipEnabled then Noclip_Disable() end end)
        pcall(function() if fullbrightEnabled then FullBright_Disable() end end)
        pcall(function() if fovEnabled then FOV_Disable() end end)
        pcall(function() if noFailLPEnabled then NoFailLP_Disable() end end)
        pcall(function() if autoLockpickEnabled then AutoLockpick_Disable() end end)
        pcall(function() if safeESPEnabled then SafeESP_Disable() end end)
        pcall(function() if autoPickupEnabled then AutoPickup_Disable() end end)
        pcall(function() if unlockDoorsEnabled then UnlockDoors_Disable() end end)
        pcall(function() if adminCheckEnabled then AdminCheck_Disable() end end)
        pcall(function() if espEnabled then ESP_Disable() end end)
        pcall(function() if invisEnabled then Invis_Disable() end end)
        pcall(function() if silentAimEnabled then SilentAim_Disable() end end)
        pcall(function() if meleeAuraEnabled then MeleeAura_Disable() end end)
        pcall(function() if autoFarmEnabled then AutoFarm_Disable() end end)
        
        -- GUI'yi yok et
        mainGui:Destroy()
    end)

    -- K tusu ile toggle
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
            if miniFrame.Visible then
                miniFrame.Visible = false
                win.Visible = true
                overlay.Visible = true
            else
                local isVisible = not win.Visible
                win.Visible = isVisible
                overlay.Visible = isVisible
            end
        end
    end)

    -- SURUKLEME
    do
        local dragging = false
        local dragStart = nil
        local startPos = nil
        
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = win.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        titleBar.InputChanged:Connect(function(input)
            if dragging and (
                input.UserInputType == Enum.UserInputType.MouseMovement 
                or input.UserInputType == Enum.UserInputType.Touch
            ) then
                local delta = input.Position - dragStart
                win.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    -- AÇILIŞ ANIMASYONU
    win.Size = UDim2.new(0, WIN_W, 0, 0)
    win.ClipsDescendants = true
    
    tween(
        win,
        { Size = UDim2.new(0, WIN_W, 0, WIN_H) },
        0.35,
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    )
    
    task.wait(0.1)
    
    -- Ilk sekmeyi yukle
    clearAndLoad("COMBAT", combatTab)

    print("================================================")
    print("  SANTES HUB v3.1 - ANA ARAYUZ YUKLENDI!")
    print("  Tum moduller hazir!")
    print("================================================")
end

-- #####################################################################
-- #                         START                                     #
-- #####################################################################

task.spawn(function()
    task.wait(0.3)
    createMainUI()
end)

print("SANTES HUB v3.1 yuklendi - Ana UI aciliyor...")
