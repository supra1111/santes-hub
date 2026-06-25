--[[
    SantesHub UI
    No Recoil toggle + Minimize + Close
    Kırmızı/Siyah tema, glow efektli
--]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Eski UI varsa kaldır
if LocalPlayer.PlayerGui:FindFirstChild("SantesHub_UI") then
    LocalPlayer.PlayerGui.SantesHub_UI:Destroy()
end

-- Renkler
local COLOR_BG       = Color3.fromRGB(15, 15, 15)
local COLOR_ACCENT   = Color3.fromRGB(255, 25, 35)
local COLOR_ACCENT_D = Color3.fromRGB(120, 10, 15)
local COLOR_TEXT     = Color3.fromRGB(240, 240, 240)
local COLOR_OFF      = Color3.fromRGB(40, 40, 40)

-- State
local NoRecoilEnabled = false

-- ============================================================
-- NO RECOIL MODÜLÜ
-- ============================================================
local NoRecoil_Enabled = false
local NoRecoil_Connections = {}
local NoRecoil_WeaponCache = {}
local NoRecoil_GlobalOriginal = {}
local NoRecoil_Player = LocalPlayer

local function NoRecoil_CacheWeapons()
    NoRecoil_WeaponCache = {}
    for _, v in pairs(getgc(true)) do
        if type(v) == 'table' and rawget(v, 'EquipTime') then
            table.insert(NoRecoil_WeaponCache, v)
            if not NoRecoil_GlobalOriginal[v] then
                NoRecoil_GlobalOriginal[v] = {
                    Recoil = v.Recoil,
                    CameraRecoilingEnabled = v.CameraRecoilingEnabled,
                    AngleX_Min = v.AngleX_Min,
                    AngleX_Max = v.AngleX_Max,
                    AngleY_Min = v.AngleY_Min,
                    AngleY_Max = v.AngleY_Max,
                    AngleZ_Min = v.AngleZ_Min,
                    AngleZ_Max = v.AngleZ_Max,
                    Spread = v.Spread
                }
            end
        end
    end
end

local function NoRecoil_Apply()
    for _, weapon in pairs(NoRecoil_WeaponCache) do
        weapon.Recoil = 0
        weapon.CameraRecoilingEnabled = false
        weapon.AngleX_Min = 0
        weapon.AngleX_Max = 0
        weapon.AngleY_Min = 0
        weapon.AngleY_Max = 0
        weapon.AngleZ_Min = 0
        weapon.AngleZ_Max = 0
    end
end

local function NoRecoil_Reset()
    for weapon, values in pairs(NoRecoil_GlobalOriginal) do
        weapon.Recoil = values.Recoil
        weapon.CameraRecoilingEnabled = values.CameraRecoilingEnabled
        weapon.AngleX_Min = values.AngleX_Min
        weapon.AngleX_Max = values.AngleX_Max
        weapon.AngleY_Min = values.AngleY_Min
        weapon.AngleY_Max = values.AngleY_Max
        weapon.AngleZ_Min = values.AngleZ_Min
        weapon.AngleZ_Max = values.AngleZ_Max
        weapon.Spread = values.Spread
    end
end

local function NoRecoil_HandleWeapon(weapon)
    if NoRecoil_Enabled then
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
            if NoRecoil_Enabled then
                task.wait(1.5)
                NoRecoil_CacheWeapons()
                NoRecoil_Apply()
            end
        end))
    end
end

function NoRecoil_Enable()
    if NoRecoil_Enabled then return end
    NoRecoil_Enabled = true
    NoRecoil_CacheWeapons()
    NoRecoil_Apply()
    table.insert(NoRecoil_Connections, NoRecoil_Player.CharacterAdded:Connect(NoRecoil_OnCharacterAdded))
    if NoRecoil_Player.Character then NoRecoil_OnCharacterAdded(NoRecoil_Player.Character) end
end

function NoRecoil_Disable()
    if not NoRecoil_Enabled then return end
    NoRecoil_Enabled = false
    NoRecoil_Reset()
    for _, conn in ipairs(NoRecoil_Connections) do
        pcall(function() conn:Disconnect() end)
    end
    NoRecoil_Connections = {}
end

-- ============================================================
-- UI
-- ============================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SantesHub_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 240, 0, 140)
Main.Position = UDim2.new(0.5, -120, 0.5, -70)
Main.BackgroundColor3 = COLOR_BG
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = COLOR_ACCENT
MainStroke.Thickness = 1.5
MainStroke.Parent = Main

-- Glow (dış parlama efekti)
local Glow = Instance.new("ImageLabel")
Glow.Name = "Glow"
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://5028857084"
Glow.ImageColor3 = COLOR_ACCENT
Glow.ImageTransparency = 0.55
Glow.Size = UDim2.new(1, 60, 1, 60)
Glow.Position = UDim2.new(0.5, 0, 0.5, 0)
Glow.AnchorPoint = Vector2.new(0.5, 0.5)
Glow.ZIndex = 0
Glow.Parent = Main

-- Title Bar (sürükleme alanı)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = Main

-- Başlık
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "SantesHub"
Title.TextColor3 = COLOR_ACCENT
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Kapatma Butonu
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -13)
CloseBtn.BackgroundColor3 = COLOR_ACCENT
CloseBtn.BackgroundTransparency = 0.75
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.1), { BackgroundTransparency = 0.3 }):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.1), { BackgroundTransparency = 0.75 }):Play()
end)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Küçültme Butonu
local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinBtn"
MinBtn.Size = UDim2.new(0, 26, 0, 26)
MinBtn.Position = UDim2.new(1, -62, 0.5, -13)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinBtn.BackgroundTransparency = 0.6
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 16
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BorderSizePixel = 0
MinBtn.AutoButtonColor = false
MinBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

local isMinimized = false
local originalSize = Main.Size

MinBtn.MouseEnter:Connect(function()
    TweenService:Create(MinBtn, TweenInfo.new(0.1), { BackgroundTransparency = 0.2 }):Play()
end)
MinBtn.MouseLeave:Connect(function()
    TweenService:Create(MinBtn, TweenInfo.new(0.1), { BackgroundTransparency = 0.6 }):Play()
end)
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        Main.Size = UDim2.new(0, 120, 0, 40)
        MinBtn.Text = "+"
        Content.Visible = false
    else
        Main.Size = originalSize
        MinBtn.Text = "−"
        Content.Visible = true
    end
end)

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(0.9, 0, 0, 1)
Divider.Position = UDim2.new(0.05, 0, 0, 40)
Divider.BackgroundColor3 = COLOR_ACCENT_D
Divider.BorderSizePixel = 0
Divider.Parent = Main

-- İçerik
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, 0, 1, -48)
Content.Position = UDim2.new(0, 0, 0, 44)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- No Recoil Label
local NRLabel = Instance.new("TextLabel")
NRLabel.BackgroundTransparency = 1
NRLabel.Size = UDim2.new(0.6, 0, 0, 40)
NRLabel.Position = UDim2.new(0.06, 0, 0, 8)
NRLabel.Font = Enum.Font.Gotham
NRLabel.Text = "No Recoil"
NRLabel.TextColor3 = COLOR_TEXT
NRLabel.TextSize = 15
NRLabel.TextXAlignment = Enum.TextXAlignment.Left
NRLabel.Parent = Content

-- Toggle Switch
local ToggleBG = Instance.new("Frame")
ToggleBG.Name = "ToggleBG"
ToggleBG.Size = UDim2.new(0, 46, 0, 22)
ToggleBG.Position = UDim2.new(1, -58, 0, 16)
ToggleBG.BackgroundColor3 = COLOR_OFF
ToggleBG.BorderSizePixel = 0
ToggleBG.Parent = Content

local ToggleBGCorner = Instance.new("UICorner")
ToggleBGCorner.CornerRadius = UDim.new(1, 0)
ToggleBGCorner.Parent = ToggleBG

local ToggleBGStroke = Instance.new("UIStroke")
ToggleBGStroke.Color = COLOR_ACCENT_D
ToggleBGStroke.Thickness = 1
ToggleBGStroke.Parent = ToggleBG

local ToggleKnob = Instance.new("Frame")
ToggleKnob.Name = "Knob"
ToggleKnob.Size = UDim2.new(0, 18, 0, 18)
ToggleKnob.Position = UDim2.new(0, 2, 0.5, -9)
ToggleKnob.BackgroundColor3 = COLOR_TEXT
ToggleKnob.BorderSizePixel = 0
ToggleKnob.Parent = ToggleBG

local KnobCorner = Instance.new("UICorner")
KnobCorner.CornerRadius = UDim.new(1, 0)
KnobCorner.Parent = ToggleKnob

local ToggleButton = Instance.new("TextButton")
ToggleButton.BackgroundTransparency = 1
ToggleButton.Size = UDim2.new(1, 0, 1, 0)
ToggleButton.Text = ""
ToggleButton.Parent = ToggleBG

-- Toggle fonksiyonu
local function SetToggle(state)
    NoRecoilEnabled = state
    local bgColor = state and COLOR_ACCENT or COLOR_OFF
    local knobPos = state and UDim2.new(0, 26, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)

    TweenService:Create(ToggleBG, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = bgColor}):Play()
    TweenService:Create(ToggleKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = knobPos}):Play()

    if state then
        NoRecoil_Enable()
    else
        NoRecoil_Disable()
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    SetToggle(not NoRecoilEnabled)
end)

-- Hover glow animasyonu
Main.MouseEnter:Connect(function()
    TweenService:Create(MainStroke, TweenInfo.new(0.25), {Thickness = 2.2}):Play()
end)
Main.MouseLeave:Connect(function()
    TweenService:Create(MainStroke, TweenInfo.new(0.25), {Thickness = 1.5}):Play()
end)

-- Sürükleme
do
    local dragging, dragInput, startPos, dragStart
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

print("SantesHub No Recoil Loaded!")
