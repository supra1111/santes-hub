-- ============================================
-- SANTES HUB - COMPLETE PACKAGE
-- ============================================

local TweenService = game:GetService("TweenService")

-- ========== LOADER ==========
local loaderGui = Instance.new("ScreenGui")
loaderGui.Name = "SantesLoader"
loaderGui.ResetOnSpawn = false
loaderGui.IgnoreGuiInset = true
loaderGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
loaderGui.DisplayOrder = 1000
loaderGui.Parent = game:GetService("CoreGui")

local backdrop = Instance.new("Frame")
backdrop.Size = UDim2.new(1, 0, 1, 0)
backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backdrop.BackgroundTransparency = 0.3
backdrop.BorderSizePixel = 0
backdrop.Parent = loaderGui

local card = Instance.new("Frame")
card.AnchorPoint = Vector2.new(0.5, 0.5)
card.Position = UDim2.new(0.5, 0, 0.5, 0)
card.Size = UDim2.new(0, 380, 0, 220)
card.BackgroundColor3 = Color3.fromRGB(10, 8, 10)
card.BorderSizePixel = 0
card.Parent = backdrop

local cardCorner = Instance.new("UICorner", card)
cardCorner.CornerRadius = UDim.new(0, 16)

local cardStroke = Instance.new("UIStroke", card)
cardStroke.Color = Color3.fromRGB(200, 30, 30)
cardStroke.Thickness = 1.5
cardStroke.Transparency = 0.4

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 44)
title.Position = UDim2.new(0, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "SANTES HUB"
title.TextColor3 = Color3.fromRGB(235, 220, 220)
title.TextSize = 30
title.Font = Enum.Font.GothamBold
title.Parent = card

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 18)
subtitle.Position = UDim2.new(0, 0, 0, 78)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Loading..."
subtitle.TextColor3 = Color3.fromRGB(160, 140, 140)
subtitle.TextSize = 13
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = card

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0.8, 0, 0, 6)
barBg.Position = UDim2.new(0.1, 0, 0, 120)
barBg.BackgroundColor3 = Color3.fromRGB(30, 25, 25)
barBg.BorderSizePixel = 0
barBg.Parent = card

local barBgCorner = Instance.new("UICorner", barBg)
barBgCorner.CornerRadius = UDim.new(1, 0)

local bar = Instance.new("Frame")
bar.Size = UDim2.new(0, 0, 1, 0)
bar.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
bar.BorderSizePixel = 0
bar.Parent = barBg

local barCorner = Instance.new("UICorner", bar)
barCorner.CornerRadius = UDim.new(1, 0)

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, 0, 0, 18)
statusText.Position = UDim2.new(0, 0, 0, 140)
statusText.BackgroundTransparency = 1
statusText.Text = "Initializing..."
statusText.TextColor3 = Color3.fromRGB(130, 110, 110)
statusText.TextSize = 12
statusText.Font = Enum.Font.Code
statusText.Parent = card

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 18)
footer.Position = UDim2.new(0, 0, 1, -25)
footer.BackgroundTransparency = 1
footer.Text = "SANTES HUB v2.0"
footer.TextColor3 = Color3.fromRGB(100, 70, 70)
footer.TextSize = 10
footer.Font = Enum.Font.Gotham
footer.Parent = card

-- LOADER ANIMASYONU
local function RunLoader()
    local steps = {
        { p = 0.15, t = "Loading Santes Hub..." },
        { p = 0.30, t = "Loading modules..." },
        { p = 0.50, t = "Connecting to server..." },
        { p = 0.70, t = "Finalizing setup..." },
        { p = 0.85, t = "Preparing UI..." },
        { p = 1.0, t = "Ready!" },
    }
    
    for _, step in ipairs(steps) do
        statusText.Text = step.t
        local tw = TweenService:Create(bar, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(step.p, 0, 1, 0)
        })
        tw:Play()
        tw.Completed:Wait()
        task.wait(0.3)
    end
    
    statusText.Text = "✓ Loaded!"
    statusText.TextColor3 = Color3.fromRGB(255, 80, 80)
    task.wait(0.5)
    
    local fade = TweenService:Create(backdrop, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    })
    fade:Play()
    fade.Completed:Wait()
    
    loaderGui:Destroy()
    StartSantesHub()
end

task.spawn(RunLoader)


-- ============================================================
-- SANTES HUB ANA SCRIPT
-- ============================================================

function StartSantesHub()

-- Anti-Idle
local VirtualUser = game:GetService('VirtualUser')
if game:GetService('Players').LocalPlayer then
    game:GetService('Players').LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Eski UI temizle
local oldGui = PlayerGui:FindFirstChild("SantesHubGui")
if oldGui then oldGui:Destroy() end


-- ============================================================
-- ANA UI (MODERN - KIRMIZI/SİYAH)
-- ============================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SantesHubGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 440, 0, 380)
mainFrame.Position = UDim2.new(0.5, -220, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(8, 6, 8)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(200, 30, 30)
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.3

-- HEADER
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(10, 6, 8)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 14)

local accentLine = Instance.new("Frame")
accentLine.Size = UDim2.new(1, 0, 0, 2)
accentLine.Position = UDim2.new(0, 0, 1, 0)
accentLine.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
accentLine.BorderSizePixel = 0
accentLine.Parent = header

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "SANTES HUB"
titleLabel.TextColor3 = Color3.fromRGB(230, 210, 210)
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

-- Kapatma
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -38, 0.5, -14)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
closeBtn.BackgroundTransparency = 0.6
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0, 6)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Küçültme
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Position = UDim2.new(1, -72, 0.5, -14)
minBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
minBtn.BackgroundTransparency = 0.5
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = 16
minBtn.Font = Enum.Font.GothamBold
minBtn.BorderSizePixel = 0
minBtn.AutoButtonColor = false
minBtn.Parent = header

local minCorner = Instance.new("UICorner", minBtn)
minCorner.CornerRadius = UDim.new(0, 6)

local minimized = false
local origSize = mainFrame.Size

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame.Size = UDim2.new(0, 100, 0, 50)
        minBtn.Text = "+"
        contentContainer.Visible = false
    else
        mainFrame.Size = origSize
        minBtn.Text = "−"
        contentContainer.Visible = true
    end
end)

-- İçerik
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -20, 1, -60)
contentContainer.Position = UDim2.new(0, 10, 0, 55)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

-- Sol Menü
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 100, 1, 0)
menuFrame.BackgroundColor3 = Color3.fromRGB(10, 6, 8)
menuFrame.BorderSizePixel = 0
menuFrame.Parent = contentContainer

local menuCorner = Instance.new("UICorner", menuFrame)
menuCorner.CornerRadius = UDim.new(0, 8)

local menuStroke = Instance.new("UIStroke", menuFrame)
menuStroke.Color = Color3.fromRGB(200, 30, 30)
menuStroke.Thickness = 1
menuStroke.Transparency = 0.4

local menuLayout = Instance.new("UIListLayout")
menuLayout.Padding = UDim.new(0, 4)
menuLayout.SortOrder = Enum.SortOrder.LayoutOrder
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.Parent = menuFrame

-- Scroll
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -115, 1, 0)
scrollFrame.Position = UDim2.new(0, 110, 0, 0)
scrollFrame.BackgroundColor3 = Color3.fromRGB(8, 4, 6)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(200, 30, 30)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent = contentContainer

local scrollCorner = Instance.new("UICorner", scrollFrame)
scrollCorner.CornerRadius = UDim.new(0, 8)

local scrollStroke = Instance.new("UIStroke", scrollFrame)
scrollStroke.Color = Color3.fromRGB(200, 30, 30)
scrollStroke.Thickness = 1
scrollStroke.Transparency = 0.4

local scrollLayout = Instance.new("UIListLayout")
scrollLayout.Padding = UDim.new(0, 5)
scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
scrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
scrollLayout.Parent = scrollFrame


-- ============================================================
-- SÜRÜKLEME
-- ============================================================
do
    local dragging = false
    local dragStart = nil
    local startPos = nil

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- K tuşu
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.K then
        mainFrame.Visible = not mainFrame.Visible
    end
end)


-- ============================================================
-- TÜM MODÜLLER
-- ============================================================

-- No Fail Lockpick
local NoFailLockpick_Enabled = false
local lockpickAddedConnection = nil

function NoFailLockpick_Enable()
    if NoFailLockpick_Enabled then return end
    NoFailLockpick_Enabled = true
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not pGui then return end
    lockpickAddedConnection = pGui.ChildAdded:Connect(function(Item)
        if Item.Name == "LockpickGUI" then
            local mf = Item:WaitForChild("MF", 10)
            if not mf then return end
            local lpFrame = mf:WaitForChild("LP_Frame", 10)
            if not lpFrame then return end
            local frames = lpFrame:WaitForChild("Frames", 10)
            if not frames then return end
            local b1 = frames:WaitForChild("B1", 10)
            local b2 = frames:WaitForChild("B2", 10)
            local b3 = frames:WaitForChild("B3", 10)
            if b1 and b1.Bar and b1.Bar:FindFirstChild("UIScale") then b1.Bar.UIScale.Scale = 10 end
            if b2 and b2.Bar and b2.Bar:FindFirstChild("UIScale") then b2.Bar.UIScale.Scale = 10 end
            if b3 and b3.Bar and b3.Bar:FindFirstChild("UIScale") then b3.Bar.UIScale.Scale = 10 end
        end
    end)
end

function NoFailLockpick_Disable()
    if not NoFailLockpick_Enabled then return end
    NoFailLockpick_Enabled = false
    if lockpickAddedConnection then
        lockpickAddedConnection:Disconnect()
        lockpickAddedConnection = nil
    end
end

-- Safe ESP
local BredMakurz_Enabled = false
local bredMakurzConnection = nil

local function formatName(name)
    name = string.gsub(name, "([a-z])([A-Z])", "%1 %2")
    local underscoreIndex = string.find(name, "_")
    if underscoreIndex then name = string.sub(name, 1, underscoreIndex - 1) end
    return name
end

local function ApplyBredMakurzModification()
    local folder = workspace.Map:FindFirstChild("BredMakurz")
    if not folder then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local pos = char.HumanoidRootPart.Position

    for _, v in pairs(folder:GetChildren()) do
        local objPos
        if v.PrimaryPart and v.PrimaryPart:IsA("BasePart") then
            objPos = v.PrimaryPart.Position
        else
            local part = v:FindFirstChildOfClass("BasePart")
            if part then objPos = part.Position else continue end
        end
        
        local dist = (objPos - pos).magnitude
        local existing = v:FindFirstChild("Ahh")

        if dist <= 200 then
            if not existing then
                local x = Instance.new('BillboardGui', v)
                x.Name = "Ahh"
                x.AlwaysOnTop = true
                x.Size = UDim2.new(8,0,4,0)
                x.MaxDistance = 200
                local textLabel = Instance.new('TextLabel', x)
                textLabel.Size = UDim2.new(1,0,1,0)
                textLabel.BackgroundTransparency = 1
                textLabel.Font = Enum.Font.SourceSansBold
                textLabel.TextScaled = false
                textLabel.TextSize = 15
                textLabel.Text = formatName(v.Name)
                x.Adornee = v
                local values = v:FindFirstChild("Values")
                local broken = values and values:FindFirstChild("Broken")
                if broken then
                    if broken.Value ~= false then textLabel.TextColor3 = Color3.new(255,0,0)
                    else textLabel.TextColor3 = Color3.new(0,255,0) end
                    broken:GetPropertyChangedSignal("Value"):Connect(function()
                        if broken.Value ~= false then textLabel.TextColor3 = Color3.new(255,0,0)
                        else textLabel.TextColor3 = Color3.new(0,255,0) end
                    end)
                else textLabel.TextColor3 = Color3.new(0,255,0) end
            end
        elseif existing then existing:Destroy() end
    end
end

function BredMakurz_Enable()
    if BredMakurz_Enabled then return end
    BredMakurz_Enabled = true
    bredMakurzConnection = RunService.Heartbeat:Connect(ApplyBredMakurzModification)
end

function BredMakurz_Disable()
    if not BredMakurz_Enabled then return end
    BredMakurz_Enabled = false
    if bredMakurzConnection then bredMakurzConnection:Disconnect() bredMakurzConnection = nil end
end

-- Doors
local OpenNearbyDoors_Enabled = false
local UnlockNearbyDoors_Enabled = false
local DoorCoroutine = nil

local function DoorLoop()
    while (OpenNearbyDoors_Enabled or UnlockNearbyDoors_Enabled) do
        task.wait(0.25)
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then continue end

        local doors = workspace.Map:FindFirstChild("Doors")
        if not doors then
            if OpenNearbyDoors_Enabled then OpenNearbyDoors_Disable() end
            if UnlockNearbyDoors_Enabled then UnlockNearbyDoors_Disable() end
            break
        end

        local pos = hrp.Position
        for _, door in ipairs(doors:GetChildren()) do
            local doorBase = door:FindFirstChild("DoorBase")
            local values = door:FindFirstChild("Values")
            local events = door:FindFirstChild("Events")
            if doorBase and values and events and (pos - doorBase.Position).Magnitude <= 6 then
                local toggle = events:FindFirstChild("Toggle")
                if not toggle then continue end

                if UnlockNearbyDoors_Enabled then
                    local locked = values:FindFirstChild("Locked")
                    local lockArg = door:FindFirstChild("Lock")
                    if locked and lockArg and locked.Value == true then
                        pcall(function() toggle:FireServer("Unlock", lockArg) end)
                    end
                end

                if OpenNearbyDoors_Enabled then
                    local open = values:FindFirstChild("Open")
                    local knob = door:FindFirstChild("Knob2") or door:FindFirstChild("Knob")
                    if open and knob and open.Value == false then
                        local locked = values:FindFirstChild("Locked")
                        if not locked or locked.Value == false or not UnlockNearbyDoors_Enabled then
                            pcall(function() toggle:FireServer("Open", knob) end)
                        end
                    end
                end
            end
        end
    end
    DoorCoroutine = nil
end

function OpenNearbyDoors_Enable()
    if OpenNearbyDoors_Enabled then return end
    OpenNearbyDoors_Enabled = true
    if not DoorCoroutine then DoorCoroutine = task.spawn(DoorLoop) end
end

function OpenNearbyDoors_Disable()
    if not OpenNearbyDoors_Enabled then return end
    OpenNearbyDoors_Enabled = false
end

function UnlockNearbyDoors_Enable()
    if UnlockNearbyDoors_Enabled then return end
    UnlockNearbyDoors_Enabled = true
    if not DoorCoroutine then DoorCoroutine = task.spawn(DoorLoop) end
end

function UnlockNearbyDoors_Disable()
    if not UnlockNearbyDoors_Enabled then return end
    UnlockNearbyDoors_Enabled = false
end

-- Auto Pickup Money
local AutoPickupMoney_Enabled = false
local AutoPickupMoney_Connection = nil
local CoolDowns = { AutoPickUps = { MoneyCooldown = false } }
local Settings = { IsDead = false }

local function AutoPickupMoney_Logic()
    local cash = workspace.Filter:FindFirstChild("SpawnedBread")
    local remote = game:GetService("ReplicatedStorage").Events:FindFirstChild("CZDPZUS")
    if not cash or not remote then AutoPickupMoney_Disable() return end

    AutoPickupMoney_Connection = RunService.RenderStepped:Connect(function()
        if not AutoPickupMoney_Enabled or Settings.IsDead then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp or CoolDowns.AutoPickUps.MoneyCooldown then return end

        local pos = hrp.Position
        for _, v in ipairs(cash:GetChildren()) do
            if (pos - v.Position).Magnitude < 5 and not CoolDowns.AutoPickUps.MoneyCooldown then
                CoolDowns.AutoPickUps.MoneyCooldown = true
                pcall(function() remote:FireServer(v) end)
                task.wait(1)
                CoolDowns.AutoPickUps.MoneyCooldown = false
                break
            end
        end
    end)
end

function AutoPickupMoney_Enable()
    if AutoPickupMoney_Enabled then return end
    AutoPickupMoney_Enabled = true
    if AutoPickupMoney_Connection then AutoPickupMoney_Connection:Disconnect() end
    AutoPickupMoney_Connection = task.spawn(AutoPickupMoney_Logic)
end

function AutoPickupMoney_Disable()
    if not AutoPickupMoney_Enabled then return end
    AutoPickupMoney_Enabled = false
    if AutoPickupMoney_Connection then coroutine.close(AutoPickupMoney_Connection) AutoPickupMoney_Connection = nil end
    CoolDowns.AutoPickUps.MoneyCooldown = false
end

-- Fly
local Fly_Enabled = false
local Fly_Connection = nil
local Fly_Speed = 50

function Fly_Enable()
    if Fly_Enabled then return end
    Fly_Enabled = true
    Fly_Connection = RunService.RenderStepped:Connect(function(dt)
        if not Fly_Enabled then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local cam = workspace.CurrentCamera
            local dir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
            if dir.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (dir.Unit * Fly_Speed * dt) end
        end
    end)
end

function Fly_Disable()
    if not Fly_Enabled then return end
    Fly_Enabled = false
    if Fly_Connection then Fly_Connection:Disconnect() Fly_Connection = nil end
end

-- FullBright
local FullBright_Enabled = false
local Lighting = game:GetService("Lighting")
local FullBright_Connection = nil
local OrigVals = {
    ClockTime = Lighting.ClockTime, Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
    ColorShift_Top = Lighting.ColorShift_Top, FogStart = Lighting.FogStart, FogEnd = Lighting.FogEnd,
}

function FullBright_Enable()
    if FullBright_Enabled then return end
    FullBright_Enabled = true
    Lighting.Brightness = 5
    Lighting.ClockTime = 14
    Lighting.Ambient = Color3.new(1,1,1)
    Lighting.OutdoorAmbient = Color3.new(1,1,1)
    Lighting.ColorShift_Top = Color3.new(0,0,0)
    Lighting.FogStart = 100000
    Lighting.FogEnd = 100000
    FullBright_Connection = RunService.RenderStepped:Connect(function()
        if not FullBright_Enabled then FullBright_Connection:Disconnect() return end
        Lighting.Brightness = 5
        Lighting.ClockTime = 14
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
        Lighting.ColorShift_Top = Color3.new(0,0,0)
        Lighting.FogStart = 100000
        Lighting.FogEnd = 100000
    end)
end

function FullBright_Disable()
    if not FullBright_Enabled then return end
    FullBright_Enabled = false
    if FullBright_Connection then FullBright_Connection:Disconnect() FullBright_Connection = nil end
    Lighting.Brightness = OrigVals.Brightness
    Lighting.ClockTime = OrigVals.ClockTime
    Lighting.Ambient = OrigVals.Ambient
    Lighting.OutdoorAmbient = OrigVals.OutdoorAmbient
    Lighting.ColorShift_Top = OrigVals.ColorShift_Top
    Lighting.FogStart = OrigVals.FogStart
    Lighting.FogEnd = OrigVals.FogEnd
end

-- FOV
local Fov_Enabled = false
local Fov_Value = 80
local Camera = workspace.CurrentCamera
local OrigFov = Camera.FieldOfView

function Fov_Enable()
    Fov_Enabled = true
end

function Fov_Disable()
    Fov_Enabled = false
    Camera.FieldOfView = OrigFov
end

RunService.RenderStepped:Connect(function()
    if Fov_Enabled then Camera.FieldOfView = Fov_Value end
end)

-- Noclip
local Noclip_Enabled = false
local Noclip_Connection = nil
local origCollisions = {}

function Noclip_Enable()
    if Noclip_Enabled then return end
    Noclip_Enabled = true
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                origCollisions[part] = true
                part.CanCollide = false
            end
        end
    end
    Noclip_Connection = RunService.RenderStepped:Connect(function()
        if not Noclip_Enabled then return end
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end

function Noclip_Disable()
    if not Noclip_Enabled then return end
    Noclip_Enabled = false
    if Noclip_Connection then Noclip_Connection:Disconnect() Noclip_Connection = nil end
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and origCollisions[part] then part.CanCollide = true end
        end
    end
    origCollisions = {}
end

-- Admin Check
local AdminCheck_Enabled = false
local AdminCheck_Connection = nil

local staffPlayers = {
    groups = {
        [4793755] = {
            ["Tester"] = true, ["Contributor"] = true, ["Tester+"] = true,
            ["Developer"] = true, ["Developer+"] = true,
            ["Community Manager"] = true, ["Manager"] = true, ["Owner"] = true
        },
        [4165692] = {
            ["Tester"] = true, ["Contributor"] = true, ["Tester+"] = true,
            ["Developer"] = true, ["Developer+"] = true,
            ["Community Manager"] = true, ["Manager"] = true, ["Owner"] = true
        },
    },
    users = {
        3294804378, 93676120, 54087314, 81275825, 140837601, 1229486091,
        46567801, 418086275, 29706395, 3717066084, 1424338327,
        111250044, 140172831, 42662179, 9066859, 438805620, 14855669, 727189337
    }
}

local function hasTracker(p)
    if not p then return false, nil end
    for _, child in pairs(p:GetChildren()) do
        if typeof(child.Name) == "string" and string.sub(child.Name, -8) == "Tracker$" then
            local name = string.sub(child.Name, 1, -9)
            if Players:FindFirstChild(name) then return true, name end
        end
    end
    return false, nil
end

local function isStaff(p)
    if not p then return false end
    for id, roles in pairs(staffPlayers.groups) do
        local rank = pcall(function() return p:GetRankInGroup(id) end)
        if rank and rank > 0 then
            local role = pcall(function() return p:GetRoleInGroup(id) end)
            if role and roles[role] then return true, role, id end
        end
    end
    for _, id in pairs(staffPlayers.users) do
        if p.UserId == id then return true, "UserID", id end
    end
    return false
end

local function kickMsg(info)
    if not info then return "Staff detected." end
    local msg = "Staff detected:\n"
    for i, s in pairs(info) do
        msg = msg .. "- " .. s.Name .. " (" .. (s.Role or "Unknown") .. ")"
        if s.TrackedPlayer then msg = msg .. " - Tracking: " .. s.TrackedPlayer end
        if i < #info then msg = msg .. "\n" end
    end
    return msg
end

local function checkStaff()
    local found = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local isS, role, id = isStaff(p)
            local hasT, tracked = hasTracker(p)
            if isS or hasT then
                table.insert(found, {
                    Name = p.Name,
                    Role = hasT and "Tracker User" or role,
                    GroupId = id,
                    TrackedPlayer = tracked
                })
            end
        end
    end
    if #found > 0 then
        LocalPlayer:Kick("Staff joined\n\n" .. kickMsg(found))
        return true
    end
    return false
end

function AdminCheck_Enable()
    if AdminCheck_Enabled then return end
    AdminCheck_Enabled = true
    if AdminCheck_Connection then AdminCheck_Connection:Disconnect() end
    AdminCheck_Connection = Players.PlayerAdded:Connect(function(p)
        if not AdminCheck_Enabled then return end
        local isS, role, id = isStaff(p)
        local hasT, tracked = hasTracker(p)
        if isS or hasT then
            LocalPlayer:Kick("Staff joined\n\n" .. kickMsg({{Name = p.Name, Role = hasT and "Tracker User" or role, GroupId = id, TrackedPlayer = tracked}}))
        end
    end)
    task.spawn(checkStaff)
end

function AdminCheck_Disable()
    if not AdminCheck_Enabled then return end
    AdminCheck_Enabled = false
    if AdminCheck_Connection then AdminCheck_Connection:Disconnect() AdminCheck_Connection = nil end
end

-- Anti AFK
local AntiAFK_Enabled = true
function AntiAFK_Enable() AntiAFK_Enabled = true end
function AntiAFK_Disable() AntiAFK_Enabled = false end

-- Melee Aura
local MeleeAura_Enabled = false
local MeleeAura_Connection = nil

local function MeleeLoop()
    local plrs = Players
    local me = LocalPlayer
    local run = RunService
    local rep = game:GetService("ReplicatedStorage")
    local events = rep:WaitForChild("Events")
    local r1 = events:WaitForChild("XMHH.2")
    local r2 = events:WaitForChild("XMHH2.2")
    local maxd = 5

    local function Attack(target)
        if not (target and target:FindFirstChild("Head")) then return end
        local char = me.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not r1 or not r2 then return end

        local a1 = { "🍞", tick(), tool, "43TRFWX", "Normal", tick(), true }
        local ok, res = pcall(function() return r1:InvokeServer(unpack(a1)) end)
        if not ok then return end
        task.wait(0.1)
        local handle = tool and (tool:FindFirstChild("WeaponHandle") or tool:FindFirstChild("Handle")) or (char and char:FindFirstChild("Right Arm"))
        local head = target:FindFirstChild("Head")
        if handle and head and hrp then
            local a2 = { "🍞", tick(), tool, "2389ZFX34", res, false, handle, head, target, hrp.Position, head.Position }
            pcall(function() r2:FireServer(unpack(a2)) end)
        end
    end

    return run.RenderStepped:Connect(function()
        if not MeleeAura_Enabled then return end
        local char = me.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, p in pairs(plrs:GetPlayers()) do
                if p ~= me then
                    local c = p.Character
                    local h2 = c and c:FindFirstChild("HumanoidRootPart")
                    local hum = c and c:FindFirstChildOfClass("Humanoid")
                    if h2 and hum then
                        local d = (hrp.Position - h2.Position).Magnitude
                        if d < maxd and hum.Health > 15 and not c:FindFirstChildOfClass("ForceField") then
                            Attack(c)
                        end
                    end
                end
            end
        end
    end)
end

function MeleeAura_Enable()
    if MeleeAura_Enabled then return end
    MeleeAura_Enabled = true
    if MeleeAura_Connection then MeleeAura_Connection:Disconnect() end
    MeleeAura_Connection = MeleeLoop()
end

function MeleeAura_Disable()
    if not MeleeAura_Enabled then return end
    MeleeAura_Enabled = false
    if MeleeAura_Connection then MeleeAura_Connection:Disconnect() MeleeAura_Connection = nil end
end

-- Ragebot
local Ragebot_Enabled = false
local Ragebot_Coroutine = nil

local rep = game:GetService("ReplicatedStorage")
local ev = rep:WaitForChild("Events", 10)
local gns = ev and ev:WaitForChild("GNX_S", 5)
local zfklf = ev and ev:WaitForChild("ZFKLF__H", 5)

local function RandomString(len)
    local res = ""
    for i = 1, len do res = res .. string.char(math.random(97, 122)) end
    return res
end

local function GetClosestRage()
    local closest = nil
    local shortest = 200
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local c = p.Character
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            local hum = c and c:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 15 and not c:FindFirstChildOfClass("ForceField") then
                local d = (myHRP.Position - hrp.Position).Magnitude
                if d < shortest then
                    shortest = d
                    closest = p
                end
            end
        end
    end
    return closest
end

local function ShootRage(target)
    if not target or not target.Character then return end
    local part = target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart")
    if not part then return end
    local myChar = LocalPlayer.Character
    local tool = myChar and myChar:FindFirstChildOfClass("Tool")
    if not tool then return end
    local cam = workspace.CurrentCamera
    local hitPos = part.Position
    local hitDir = (hitPos - cam.CFrame.Position).Unit
    local key = RandomString(30) .. "0"
    if not gns or not zfklf then return end
    pcall(function() gns:FireServer(tick(), key, tool, "FDS9I83", cam.CFrame.Position, {hitDir}, false) end)
    pcall(function() zfklf:FireServer("🧈", tool, key, 1, part, hitPos, hitDir, nil, nil) end)
end

local function RageLoop()
    while Ragebot_Enabled do
        local target = GetClosestRage()
        if target then ShootRage(target) task.wait(0.05)
        else task.wait(0.1) end
    end
    Ragebot_Coroutine = nil
end

function Ragebot_Enable()
    if Ragebot_Enabled then return end
    Ragebot_Enabled = true
    if not Ragebot_Coroutine then Ragebot_Coroutine = task.spawn(RageLoop) end
end

function Ragebot_Disable()
    if not Ragebot_Enabled then return end
    Ragebot_Enabled = false
end

-- Aimbot
local AimBotSettings = {
    Enabled = false, TeamCheck = false, WallCheck = true, StickyAim = false,
    UseMouse = true, MouseBind = "MouseButton2", Keybind = nil,
    ShowFov = false, Fov = 100, Smoothing = 0.02,
    AimPart = "HumanoidRootPart", IsAimKeyDown = false, Target = nil, CameraTween = nil
}

local function IsAliveAim(p)
    return p and p.Character and p.Character:FindFirstChildOfClass("Humanoid") and p.Character.Humanoid.Health > 0
end

local function IsVisibleAim(pos, char)
    if not AimBotSettings.WallCheck then return true end
    local ignore = {workspace.CurrentCamera}
    if LocalPlayer.Character then table.insert(ignore, LocalPlayer.Character) end
    if char and char:FindFirstChild("Head") then table.insert(ignore, char.Head.Parent) end
    local ok, obs = pcall(function() return workspace.CurrentCamera:GetPartsObscuringTarget({pos}, ignore) end)
    if not ok or obs == nil then return false end
    return #obs == 0
end

local function GetClosestAim()
    local fov = AimBotSettings.Fov
    local target = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if not AimBotSettings.TeamCheck or true then
                if IsAliveAim(p) then
                    local char = p.Character
                    local part = char and char:FindFirstChild(AimBotSettings.AimPart)
                    if part then
                        local pos = part.Position
                        local ok, sp = pcall(function() return workspace.CurrentCamera:WorldToViewportPoint(pos) end)
                        if ok then
                            local mousePos = UserInputService:GetMouseLocation()
                            local dist = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
                            if dist < fov and IsVisibleAim(pos, char) then
                                fov = dist
                                target = p
                            end
                        end
                    end
                end
            end
        end
    end
    return target
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe or not AimBotSettings.Enabled then return end
    if not AimBotSettings.UseMouse and AimBotSettings.Keybind and input.KeyCode == AimBotSettings.Keybind then
        AimBotSettings.Target = GetClosestAim()
        AimBotSettings.IsAimKeyDown = true
    elseif AimBotSettings.UseMouse then
        local bind = ""
        if input.UserInputType == Enum.UserInputType.MouseButton1 then bind = "MouseButton1"
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then bind = "MouseButton2" end
        if bind == AimBotSettings.MouseBind then
            AimBotSettings.Target = GetClosestAim()
            AimBotSettings.IsAimKeyDown = true
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    if gpe or not AimBotSettings.Enabled then return end
    if not AimBotSettings.UseMouse and AimBotSettings.Keybind and input.KeyCode == AimBotSettings.Keybind then
        AimBotSettings.IsAimKeyDown = false
        AimBotSettings.Target = nil
        if AimBotSettings.CameraTween then AimBotSettings.CameraTween:Cancel() end
    elseif AimBotSettings.UseMouse then
        local bind = ""
        if input.UserInputType == Enum.UserInputType.MouseButton1 then bind = "MouseButton1"
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then bind = "MouseButton2" end
        if bind == AimBotSettings.MouseBind then
            AimBotSettings.IsAimKeyDown = false
            AimBotSettings.Target = nil
            if AimBotSettings.CameraTween then AimBotSettings.CameraTween:Cancel() end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if AimBotSettings and AimBotSettings.Enabled and AimBotSettings.IsAimKeyDown then
        local target = AimBotSettings.Target
        if target and IsAliveAim(target) then
            local char = target.Character
            local part = char and char:FindFirstChild(AimBotSettings.AimPart)
            if part then
                if AimBotSettings.CameraTween then AimBotSettings.CameraTween:Cancel() end
                local ping = pcall(function() return LocalPlayer:GetNetworkPing() end) or 0
                local offset = part.Velocity and part.Velocity * (ping * 0.1) or Vector3.new()
                local cf = CFrame.new(workspace.CurrentCamera.CFrame.Position, part.Position + offset)
                local tw = TweenService:Create(workspace.CurrentCamera, TweenInfo.new(AimBotSettings.Smoothing, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = cf})
                AimBotSettings.CameraTween = tw
                tw:Play()
            end
        else
            local newTarget = GetClosestAim()
            AimBotSettings.Target = newTarget
            if newTarget and IsAliveAim(newTarget) then
                local char = newTarget.Character
                local part = char and char:FindFirstChild(AimBotSettings.AimPart)
                if part then
                    if AimBotSettings.CameraTween then AimBotSettings.CameraTween:Cancel() end
                    local ping = pcall(function() return LocalPlayer:GetNetworkPing() end) or 0
                    local offset = part.Velocity and part.Velocity * (ping * 0.1) or Vector3.new()
                    local cf = CFrame.new(workspace.CurrentCamera.CFrame.Position, part.Position + offset)
                    local tw = TweenService:Create(workspace.CurrentCamera, TweenInfo.new(AimBotSettings.Smoothing, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = cf})
                    AimBotSettings.CameraTween = tw
                    tw:Play()
                end
            end
        end
    end
end)

function Aimbot_Enable()
    AimBotSettings.Enabled = true
end

function Aimbot_Disable()
    AimBotSettings.Enabled = false
    AimBotSettings.IsAimKeyDown = false
    AimBotSettings.Target = nil
    if AimBotSettings.CameraTween then AimBotSettings.CameraTween:Cancel() end
end

-- Infinite Stamina
local isInfiniteStaminaEnabled = false
local oldStamina = nil

do
    local ok, env = pcall(getrenv)
    if ok and env and env._G and env._G.S_Take then
        local up = pcall(getupvalue, env._G.S_Take, 2)
        if up and type(up) == 'function' then
            oldStamina = hookfunction(up, function(v, ...)
                if isInfiniteStaminaEnabled then return oldStamina(0, ...)
                else return oldStamina(v, ...) end
            end)
        end
    end
end

function InfiniteStamina_Enable()
    if not oldStamina then return end
    isInfiniteStaminaEnabled = true
end

function InfiniteStamina_Disable()
    isInfiniteStaminaEnabled = false
end

-- No Recoil
local NoRecoil_Enabled = false
local NoRecoil_Connections = {}
local NoRecoil_WeaponCache = {}

local function CacheNoRecoil()
    NoRecoil_WeaponCache = {}
    for _, v in pairs(getgc(true)) do
        if type(v) == 'table' and rawget(v, 'EquipTime') then
            table.insert(NoRecoil_WeaponCache, v)
        end
    end
end

local function ApplyNoRecoil()
    for _, w in pairs(NoRecoil_WeaponCache) do
        w.Recoil = 0
        w.CameraRecoilingEnabled = false
        w.AngleX_Min = 0
        w.AngleX_Max = 0
        w.AngleY_Min = 0
        w.AngleY_Max = 0
        w.AngleZ_Min = 0
        w.AngleZ_Max = 0
    end
end

function NoRecoil_Enable()
    if NoRecoil_Enabled then return end
    NoRecoil_Enabled = true
    CacheNoRecoil()
    ApplyNoRecoil()
end

function NoRecoil_Disable()
    if not NoRecoil_Enabled then return end
    NoRecoil_Enabled = false
end

-- ESP (DÜZELTİLDİ - ÇALIŞIYOR)
local ESP_Enabled = false
local ESP_Objects = {}
local ESP_Connection = nil

function ESP_Enable()
    if ESP_Enabled then return end
    
    -- Temizlik
    for _, data in pairs(ESP_Objects) do
        pcall(function() data.Gui:Destroy() end)
    end
    ESP_Objects = {}
    if ESP_Connection then ESP_Connection:Disconnect() end
    
    local function createESP(p)
        if p == LocalPlayer then return end
        if ESP_Objects[p] then return end
        
        local char = p.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local gui = Instance.new("BillboardGui")
        gui.Size = UDim2.new(0, 200, 0, 60)
        gui.AlwaysOnTop = true
        gui.Adornee = hrp
        gui.MaxDistance = 500
        gui.Parent = hrp
        
        local nameL = Instance.new("TextLabel", gui)
        nameL.Size = UDim2.new(1, 0, 0.4, 0)
        nameL.BackgroundTransparency = 1
        nameL.Text = p.Name
        nameL.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameL.TextSize = 14
        nameL.Font = Enum.Font.GothamBold
        nameL.TextStrokeTransparency = 0.3
        
        local distL = Instance.new("TextLabel", gui)
        distL.Size = UDim2.new(1, 0, 0.4, 0)
        distL.Position = UDim2.new(0, 0, 0.4, 0)
        distL.BackgroundTransparency = 1
        distL.Text = ""
        distL.TextColor3 = Color3.fromRGB(200, 200, 200)
        distL.TextSize = 12
        distL.Font = Enum.Font.Gotham
        
        local healthBg = Instance.new("Frame", gui)
        healthBg.Size = UDim2.new(0.8, 0, 0, 4)
        healthBg.Position = UDim2.new(0.1, 0, 1, -6)
        healthBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        healthBg.BorderSizePixel = 0
        
        local healthBar = Instance.new("Frame", gui)
        healthBar.Size = UDim2.new(0.8, 0, 0, 4)
        healthBar.Position = UDim2.new(0.1, 0, 1, -6)
        healthBar.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        healthBar.BorderSizePixel = 0
        
        ESP_Objects[p] = { Gui = gui, Name = nameL, Dist = distL, Health = healthBar }
        
        -- Update loop
        task.spawn(function()
            while ESP_Enabled and ESP_Objects[p] do
                task.wait(0.15)
                local c = p.Character
                if not c then break end
                local hum = c:FindFirstChildOfClass("Humanoid")
                if not hum then break end
                local h = c:FindFirstChild("HumanoidRootPart")
                if not h then break end
                
                local myChar = LocalPlayer.Character
                local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if myHrp then
                    local d = (myHrp.Position - h.Position).Magnitude
                    ESP_Objects[p].Dist.Text = math.floor(d) .. "s"
                end
                
                local hp = hum.Health / hum.MaxHealth
                ESP_Objects[p].Health.Size = UDim2.new(0.8 * hp, 0, 0, 4)
                if hp > 0.6 then ESP_Objects[p].Health.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                elseif hp > 0.3 then ESP_Objects[p].Health.BackgroundColor3 = Color3.fromRGB(200, 200, 0)
                else ESP_Objects[p].Health.BackgroundColor3 = Color3.fromRGB(200, 0, 0) end
            end
        end)
    end
    
    ESP_Connection = Players.PlayerAdded:Connect(createESP)
    for _, p in pairs(Players:GetPlayers()) do createESP(p) end
    ESP_Enabled = true
end

function ESP_Disable()
    if not ESP_Enabled then return end
    for _, data in pairs(ESP_Objects) do
        pcall(function() data.Gui:Destroy() end)
    end
    ESP_Objects = {}
    if ESP_Connection then ESP_Connection:Disconnect() ESP_Connection = nil end
    ESP_Enabled = false
end

-- Invisibility
local InvisEnabled = false
local InvisTrack = nil
local InvisAnim = Instance.new("Animation")
InvisAnim.AnimationId = "rbxassetid://215384594"

local function Invis_Enable()
    if InvisEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if not char:FindFirstChild("Torso") then
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Invis FAILED", Text = "R6 required", Duration = 3})
        return
    end
    InvisEnabled = true
    workspace.CurrentCamera.CameraSubject = char:FindFirstChild("HumanoidRootPart")
    local ok, track = pcall(function() return hum:LoadAnimation(InvisAnim) end)
    if ok and track then
        InvisTrack = track
        InvisTrack.Priority = Enum.AnimationPriority.Action4
        InvisTrack:Play()
        InvisTrack:AdjustSpeed(0)
        InvisTrack.TimePosition = 0.3
    end
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") and v.Transparency ~= 1 then v.Transparency = 0.5 end
    end
end

local function Invis_Disable()
    if not InvisEnabled then return end
    InvisEnabled = false
    if InvisTrack then pcall(function() InvisTrack:Stop() end) InvisTrack = nil end
    local char = LocalPlayer.Character
    if char then
        workspace.CurrentCamera.CameraSubject = char:FindFirstChildOfClass("Humanoid")
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.Transparency == 0.5 then v.Transparency = 0 end
        end
    end
end

_G.Invis_Enable = Invis_Enable
_G.Invis_Disable = Invis_Disable
_G.IsInvisEnabled = function() return InvisEnabled end

-- Autofarm
local autofarmEnabled = false
local ignoredSafes = {}

local function hasTool(name)
    return LocalPlayer.Backpack:FindFirstChild(name) or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(name))
end

local function teleportTo(part)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart", 10)
    if not hrp then return false end
    if not part then return false end
    local pos = part.Position
    for i = 1, 3 do
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 1, 0))
        task.wait(0.3)
        if (hrp.Position - pos).Magnitude < 3 then return true end
        task.wait(0.5)
    end
    return false
end

local function findTarget()
    local folder = workspace.Map:FindFirstChild("BredMakurz") or workspace.Filter:FindFirstChild("BredMakurz")
    if not folder then return nil end
    local char = LocalPlayer.Character
    if not char then return nil end
    local pos = char:FindFirstChild("HumanoidRootPart").Position
    local best = nil
    local bestDist = math.huge
    for _, v in pairs(folder:GetChildren()) do
        if (string.find(v.Name, "Safe") or string.find(v.Name, "Register")) and not table.find(ignoredSafes, v) then
            local values = v:FindFirstChild("Values")
            if values then
                local broken = values:FindFirstChild("Broken")
                if broken and not broken.Value then
                    local targetPart = v.PrimaryPart or v:FindFirstChild("MainPart") or v:FindFirstChild("PosPart")
                    if targetPart then
                        local d = (targetPart.Position - pos).Magnitude
                        if d < bestDist then
                            bestDist = d
                            best = v
                        end
                    end
                end
            end
        end
    end
    return best
end

local function findDealer()
    local shopz = workspace.Map:FindFirstChild("Shopz")
    if not shopz then return nil end
    local char = LocalPlayer.Character
    if not char then return nil end
    local pos = char:FindFirstChild("HumanoidRootPart").Position
    local best = nil
    local bestDist = math.huge
    for _, v in pairs(shopz:GetChildren()) do
        local stock = v:FindFirstChild("CurrentStocks") and v.CurrentStocks:FindFirstChild("Crowbar")
        if stock and stock.Value > 0 and v:FindFirstChild("MainPart") then
            local d = (v.MainPart.Position - pos).Magnitude
            if d < bestDist then
                bestDist = d
                best = v
            end
        end
    end
    return best
end

local function openSafe(safe)
    local crowbar = hasTool("Crowbar")
    if not crowbar then return end
    local rep = game:GetService("ReplicatedStorage")
    local r1 = rep.Events:WaitForChild("XMHH.2")
    local r2 = rep.Events:WaitForChild("XMHH2.2")
    local mainPart = safe:WaitForChild("MainPart", 5)
    if not mainPart then return end
    local start = tick()
    while safe and safe.Parent and safe.Values and safe.Values.Broken and not safe.Values.Broken.Value and (tick() - start < 15) do
        local char = LocalPlayer.Character
        if not char then break end
        local val = r1:InvokeServer("🍞", tick(), crowbar, "DZDRRRKI", safe, "Register")
        if val == nil then task.wait(0.5) continue end
        r2:FireServer("🍞", tick(), crowbar, "2389ZFX34", val, false, char["Right Arm"], mainPart, safe, mainPart.Position, mainPart.Position)
        task.wait(0.2)
    end
    task.wait(5)
end

local repAf = game:GetService("ReplicatedStorage")
local respawnEvent = repAf.Events:WaitForChild("DeathRespawn")

task.spawn(function()
    while true do
        task.wait(1)
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then Settings.IsDead = hum.Health <= 0 end
        if not autofarmEnabled or not char or not hum or hum.Health <= 0 then continue end
        
        local crowbar = hasTool("Crowbar")
        if not crowbar then
            local dealer = findDealer()
            if dealer then
                if teleportTo(dealer:FindFirstChild("MainPart")) then
                    task.wait(1)
                    repAf.Events.BYZERSPROTEC:FireServer(true, "shop", dealer.MainPart, "IllegalStore")
                    task.wait(1)
                    repAf.Events.SSHPRMTE1:InvokeServer("IllegalStore", "Melees", "Crowbar", dealer.MainPart, nil, true)
                    task.wait(15)
                    repAf.Events.BYZERSPROTEC:FireServer(false)
                end
            end
        else
            local target = findTarget()
            if target then
                ignoredSafes = {}
                if teleportTo(target:FindFirstChild("MainPart")) then
                    if not LocalPlayer.Character:FindFirstChild("Crowbar") then
                        pcall(function() LocalPlayer.Character.Humanoid:EquipTool(crowbar) end)
                    end
                    task.wait(1)
                    openSafe(target)
                else
                    table.insert(ignoredSafes, target)
                end
            else
                ignoredSafes = {}
                task.wait(3)
            end
        end
    end
end)

task.spawn(function()
    while task.wait() do
        local char = LocalPlayer.Character
        if char and autofarmEnabled then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health <= 0 then
                respawnEvent:InvokeServer("KMG4R904")
                task.wait(2)
            end
        end
    end
end)

function Autofarm_Enable()
    if autofarmEnabled then return end
    autofarmEnabled = true
    Invis_Enable()
    AutoPickupMoney_Enable()
    Noclip_Enable()
end

function Autofarm_Disable()
    if not autofarmEnabled then return end
    autofarmEnabled = false
    Invis_Disable()
    AutoPickupMoney_Disable()
    Noclip_Disable()
end

LocalPlayer.CharacterAdded:Connect(function(char)
    if not autofarmEnabled then return end
    char:WaitForChild("HumanoidRootPart", 5)
    task.wait(1)
    ignoredSafes = {}
    Autofarm_Enable()
end)

-- Shadow Mode
local Shadow_Active = false
local Shadow_Usable = true
local Shadow_Track = nil
local Shadow_Anim = Instance.new("Animation")
Shadow_Anim.AnimationId = "rbxassetid://215384594"

function Shadow_Enable()
    if Shadow_Active or not Shadow_Usable then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if not char:FindFirstChild("Torso") then
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Shadow FAILED", Text = "R6 required", Duration = 3})
        return
    end
    Shadow_Active = true
    workspace.CurrentCamera.CameraSubject = char:FindFirstChild("HumanoidRootPart")
    local ok, track = pcall(function() return hum:LoadAnimation(Shadow_Anim) end)
    if ok and track then
        Shadow_Track = track
        Shadow_Track.Priority = Enum.AnimationPriority.Action4
    end
end

function Shadow_Disable()
    if not Shadow_Active then return end
    Shadow_Active = false
    if Shadow_Track then pcall(function() Shadow_Track:Stop() end) Shadow_Track = nil end
    local char = LocalPlayer.Character
    if char then
        workspace.CurrentCamera.CameraSubject = char:FindFirstChildOfClass("Humanoid")
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.Transparency == 0.5 then v.Transparency = 0 end
        end
    end
end

_G.ActivateShadow = Shadow_Enable
_G.DeactivateShadow = Shadow_Disable


-- ============================================================
-- UI TOGGLE OLUŞTURUCU
-- ============================================================

local activeBinds = {}
local waitingForKey = nil
local bindRefs = {}
local getBinds = {}
local setBinds = {}
local rowData = {}

local function createToggle(name, getState, onEnable, onDisable, getBind, setBind)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -12, 0, 32)
    frame.BackgroundTransparency = 1
    frame.Parent = scrollFrame

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.Padding = UDim.new(0, 4)
    layout.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.45, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(210, 190, 190)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, 0, 0.8, 0)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(50, 35, 35)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = frame

    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 6)

    local bindBtn = nil
    if getBind and setBind then
        bindBtn = Instance.new("TextButton")
        bindBtn.Size = UDim2.new(0.25, 0, 0.8, 0)
        bindBtn.Font = Enum.Font.Gotham
        bindBtn.TextSize = 10
        bindBtn.TextColor3 = Color3.fromRGB(210, 190, 190)
        bindBtn.BackgroundColor3 = Color3.fromRGB(25, 18, 20)
        bindBtn.BorderSizePixel = 0
        bindBtn.AutoButtonColor = false
        bindBtn.Parent = frame
        
        local bCorner = Instance.new("UICorner", bindBtn)
        bCorner.CornerRadius = UDim.new(0, 6)
        
        bindRefs[frame] = bindBtn
        getBinds[frame] = getBind
        setBinds[frame] = setBind
    end

    local function update()
        local state = getState()
        if state then
            btn.Text = "ON"
            btn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
        else
            btn.Text = "OFF"
            btn.BackgroundColor3 = Color3.fromRGB(50, 35, 35)
        end
    end
    
    local function updateBind()
        if not bindBtn then return end
        local kb = getBind()
        bindBtn.Text = kb and typeof(kb) == "EnumItem" and kb.Name ~= "Unknown" and "[" .. kb.Name .. "]" or "Bind"
    end

    rowData[frame] = {
        get = getState,
        enable = onEnable,
        disable = onDisable,
        update = update,
        bindUpdate = updateBind,
        bindBtn = bindBtn
    }

    btn.MouseButton1Click:Connect(function()
        local state = getState()
        if state then
            if onDisable then pcall(onDisable) end
        else
            if onEnable then pcall(onEnable) end
        end
        update()
    end)

    if bindBtn then
        bindBtn.MouseButton1Click:Connect(function()
            if waitingForKey and waitingForKey ~= frame then
                local old = rowData[waitingForKey]
                if old and old.bindBtn then old.bindUpdate() end
            end
            waitingForKey = frame
            bindBtn.Text = "..."
            task.delay(5, function()
                if waitingForKey == frame then
                    waitingForKey = nil
                    updateBind()
                end
            end)
        end)
    end

    update()
    updateBind()
    return frame
end

-- Keybind handler
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local key = input.KeyCode
    if key == Enum.KeyCode.Unknown then return end

    if waitingForKey then
        local frame = waitingForKey
        local data = rowData[frame]
        if data and data.bindBtn then
            local getB = getBinds[frame]
            local setB = setBinds[frame]
            if getB and setB then
                local old = getB()
                if old and activeBinds[old] then activeBinds[old] = nil end
                if activeBinds[key] then
                    local oldFrame = activeBinds[key].frame
                    local oldData = rowData[oldFrame]
                    if oldData and oldData.bindBtn then
                        pcall(setBinds[oldFrame], nil)
                        oldData.bindUpdate()
                    end
                    activeBinds[key] = nil
                end
                pcall(setB, key)
                activeBinds[key] = { frame = frame, data = data }
                data.bindUpdate()
                waitingForKey = nil
            end
        end
    elseif activeBinds[key] then
        local d = activeBinds[key].data
        if d then
            local state = d.get()
            if state then
                if d.disable then pcall(d.disable) end
            else
                if d.enable then pcall(d.enable) end
            end
            d.update()
        end
    end
end)


-- ============================================================
-- KATEGORİLER
-- ============================================================

local categories = { "Combat", "Movement", "Visuals", "Farming", "Misc", "Rage" }
local catButtons = {}
local catFrames = {}
local activeCat = nil

for i, cat in ipairs(categories) do
    catFrames[cat] = {}
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(10, 6, 8)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.LayoutOrder = i
    btn.Parent = menuFrame

    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = cat
    lbl.TextColor3 = Color3.fromRGB(180, 160, 160)
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13
    lbl.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if activeCat then
            TweenService:Create(activeCat, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(10, 6, 8) }):Play()
            activeCat.TextLabel.TextColor3 = Color3.fromRGB(180, 160, 160)
        end
        TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(30, 18, 22) }):Play()
        btn.TextLabel.TextColor3 = Color3.fromRGB(220, 200, 200)
        activeCat = btn

        for _, child in pairs(scrollFrame:GetChildren()) do
            if child:IsA("Frame") and child.Name ~= "UIListLayout" and child.Name ~= "UICorner" then
                child.Parent = nil
            end
        end

        for _, f in pairs(catFrames[cat]) do
            f.Parent = scrollFrame
        end
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #catFrames[cat] * 38 + 10)
    end)

    catButtons[cat] = btn
end

local function addToCat(cat, name, get, enable, disable, getB, setB)
    table.insert(catFrames[cat], createToggle(name, get, enable, disable, getB, setB))
end

-- Combat
addToCat("Combat", "Melee Aura", function() return MeleeAura_Enabled end, MeleeAura_Enable, MeleeAura_Disable)
addToCat("Combat", "Aimbot", function() return AimBotSettings.Enabled end, Aimbot_Enable, Aimbot_Disable)
addToCat("Combat", "No Recoil", function() return NoRecoil_Enabled end, NoRecoil_Enable, NoRecoil_Disable)

-- Movement
addToCat("Movement", "Fly", function() return Fly_Enabled end, Fly_Enable, Fly_Disable)
addToCat("Movement", "Noclip", function() return Noclip_Enabled end, Noclip_Enable, Noclip_Disable)
addToCat("Movement", "Infinite Stamina", function() return isInfiniteStaminaEnabled end, InfiniteStamina_Enable, InfiniteStamina_Disable)

-- Visuals
addToCat("Visuals", "ESP", function() return ESP_Enabled end, ESP_Enable, ESP_Disable)
addToCat("Visuals", "Invisibility", function() return InvisEnabled end, Invis_Enable, Invis_Disable)
addToCat("Visuals", "Safe ESP", function() return BredMakurz_Enabled end, BredMakurz_Enable, BredMakurz_Disable)
addToCat("Visuals", "FullBright", function() return FullBright_Enabled end, FullBright_Enable, FullBright_Disable)
addToCat("Visuals", "FOV", function() return Fov_Enabled end, Fov_Enable, Fov_Disable)

-- Farming
addToCat("Farming", "Autofarm", function() return autofarmEnabled end, Autofarm_Enable, Autofarm_Disable)
addToCat("Farming", "Auto Pickup Money", function() return AutoPickupMoney_Enabled end, AutoPickupMoney_Enable, AutoPickupMoney_Disable)

-- Misc
addToCat("Misc", "Staff Detector", function() return AdminCheck_Enabled end, AdminCheck_Enable, AdminCheck_Disable)
addToCat("Misc", "No Fail Lockpick", function() return NoFailLockpick_Enabled end, NoFailLockpick_Enable, NoFailLockpick_Disable)
addToCat("Misc", "Auto Unlock Doors", function() return UnlockNearbyDoors_Enabled end, UnlockNearbyDoors_Enable, UnlockNearbyDoors_Disable)
addToCat("Misc", "Auto Open Doors", function() return OpenNearbyDoors_Enabled end, OpenNearbyDoors_Enable, OpenNearbyDoors_Disable)
addToCat("Misc", "Anti AFK", function() return AntiAFK_Enabled end, AntiAFK_Enable, AntiAFK_Disable)

-- Rage
addToCat("Rage", "Ragebot", function() return Ragebot_Enabled end, Ragebot_Enable, Ragebot_Disable)

-- Açılış
local function openDefault()
    local default = catButtons["Combat"]
    if default then default.MouseButton1Click:Fire() end
end

mainFrame.Size = UDim2.new(0, 0, 0, 0)
task.wait(0.1)
TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 440, 0, 380)
}):Play()

task.wait(0.5)
openDefault()

print("SANTES HUB v2.0 Loaded!")

end -- StartSantesHub end
