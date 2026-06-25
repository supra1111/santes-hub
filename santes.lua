--[[
    SantesHub UI v3
    No Recoil Toggle + Anti AFK (Otomatik)
    Kırmızı/Siyah tema, yuvarlak kenarlı, S logosu
--]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- Eski UI varsa kaldır
if LocalPlayer.PlayerGui:FindFirstChild("SantesHub_UI") then
    LocalPlayer.PlayerGui.SantesHub_UI:Destroy()
end

-- ============================================================
-- ANTI AFK (Otomatik açık)
-- ============================================================
if LocalPlayer then
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- ============================================================
-- NO RECOIL MODÜLÜ
-- ============================================================
local NoRecoilEnabled = false
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
    table.insert(NoRecoil_Connections, NoRecoil_Player.CharacterAdded:Connect(NoRecoil_OnCharacterAdded))
    if NoRecoil_Player.Character then NoRecoil_OnCharacterAdded(NoRecoil_Player.Character) end
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
-- RENKLER
-- ============================================================
local COLOR_BG       = Color3.fromRGB(10, 8, 10)
local COLOR_ACCENT   = Color3.fromRGB(215, 28, 35)
local COLOR_ACCENT_D = Color3.fromRGB(140, 15, 20)
local COLOR_ACCENT_G = Color3.fromRGB(255, 55, 60)
local COLOR_TEXT     = Color3.fromRGB(235, 230, 230)
local COLOR_TEXT_D   = Color3.fromRGB(170, 160, 165)
local COLOR_OFF      = Color3.fromRGB(45, 40, 42)
local COLOR_ON       = Color3.fromRGB(215, 28, 35)

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
Main.Size = UDim2.new(0, 260, 0, 165)
Main.Position = UDim2.new(0.5, -130, 0.5, -82)
Main.BackgroundColor3 = COLOR_BG
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = COLOR_ACCENT
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.25
MainStroke.Parent = Main

-- Glow efekti
local GlowOuter = Instance.new("ImageLabel")
GlowOuter.Name = "GlowOuter"
GlowOuter.BackgroundTransparency = 1
GlowOuter.Image = "rbxassetid://5028857084"
GlowOuter.ImageColor3 = COLOR_ACCENT
GlowOuter.ImageTransparency = 0.5
GlowOuter.Size = UDim2.new(1, 30, 1, 30)
GlowOuter.Position = UDim2.new(0.5, 0, 0.5, 0)
GlowOuter.AnchorPoint = Vector2.new(0.5, 0.5)
GlowOuter.ZIndex = 0
GlowOuter.Parent = Main

local GlowInner = Instance.new("ImageLabel")
GlowInner.Name = "GlowInner"
GlowInner.BackgroundTransparency = 1
GlowInner.Image = "rbxassetid://5028857084"
GlowInner.ImageColor3 = COLOR_ACCENT_G
GlowInner.ImageTransparency = 0.6
GlowInner.Size = UDim2.new(1, 10, 1, 10)
GlowInner.Position = UDim2.new(0.5, 0, 0.5, 0)
GlowInner.AnchorPoint = Vector2.new(0.5, 0.5)
GlowInner.ZIndex = 0
GlowInner.Parent = Main

-- Title Bar
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
Title.Position = UDim2.new(0, 14, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "SANTES HUB"
Title.TextColor3 = COLOR_ACCENT
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Kapatma
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -14)
CloseBtn.BackgroundColor3 = COLOR_ACCENT
CloseBtn.BackgroundTransparency = 0.8
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.1), { BackgroundTransparency = 0.3 }):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.1), { BackgroundTransparency = 0.8 }):Play()
end)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Küçültme Butonu (yuvarlak, S harfi)
local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinBtn"
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -66, 0.5, -14)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 45, 48)
MinBtn.BackgroundTransparency = 0.5
MinBtn.Text = "S"
MinBtn.TextColor3 = COLOR_ACCENT
MinBtn.TextSize = 16
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BorderSizePixel = 0
MinBtn.AutoButtonColor = false
MinBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinBtn

local isMinimized = false
local originalSize = Main.Size
local minimizedSize = UDim2.new(0, 70, 0, 70)

MinBtn.MouseEnter:Connect(function()
    TweenService:Create(MinBtn, TweenInfo.new(0.1), { BackgroundTransparency = 0.2 }):Play()
end)
MinBtn.MouseLeave:Connect(function()
    TweenService:Create(MinBtn, TweenInfo.new(0.1), { BackgroundTransparency = 0.5 }):Play()
end)
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        -- Küçültülmüş hal (kare, yuvarlak)
        Main.Size = minimizedSize
        MainCorner.CornerRadius = UDim.new(0, 16)
        TitleBar.Visible = false
        Divider.Visible = false
        Content.Visible = false
        
        -- Sadece S logosu göster (küçült butonunun içinde zaten S var)
        -- Küçük haldeyken S harfi büyük gözüksün
        MinBtn.Size = UDim2.new(1, -10, 1, -10)
        MinBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
        MinBtn.AnchorPoint = Vector2.new(0.5, 0.5)
        MinBtn.BackgroundTransparency = 1
        MinBtn.TextSize = 36
        MinBtn.TextColor3 = COLOR_ACCENT
        MinBtn.Size = UDim2.new(1, 0, 1, 0)
        MinBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
        MinBtn.AnchorPoint = Vector2.new(0.5, 0.5)
        MinBtn.Text = "S"
    else
        -- Normal hal
        Main.Size = originalSize
        MainCorner.CornerRadius = UDim.new(0, 16)
        TitleBar.Visible = true
        Divider.Visible = true
        Content.Visible = true
        MinBtn.Size = UDim2.new(0, 28, 0, 28)
        MinBtn.Position = UDim2.new(1, -66, 0.5, -14)
        MinBtn.AnchorPoint = Vector2.new(0, 0)
        MinBtn.BackgroundTransparency = 0.5
        MinBtn.TextSize = 16
        MinBtn.Text = "S"
    end
end)

-- Divider
local Divider = Instance.new("Frame")
Divider.Name = "Divider"
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

-- ============================================================
-- NO RECOIL TOGGLE
-- ============================================================

-- "No Recoil" başlığı
local NRLabel = Instance.new("TextLabel")
NRLabel.BackgroundTransparency = 1
NRLabel.Size = UDim2.new(1, -20, 0, 22)
NRLabel.Position = UDim2.new(0, 14, 0, 6)
NRLabel.Font = Enum.Font.GothamSemibold
NRLabel.Text = "No Recoil"
NRLabel.TextColor3 = COLOR_TEXT
NRLabel.TextSize = 14
NRLabel.TextXAlignment = Enum.TextXAlignment.Left
NRLabel.Parent = Content

-- "No Recoil" alt açıklama
local NRSub = Instance.new("TextLabel")
NRSub.BackgroundTransparency = 1
NRSub.Size = UDim2.new(1, -20, 0, 16)
NRSub.Position = UDim2.new(0, 14, 0, 28)
NRSub.Font = Enum.Font.Gotham
NRSub.Text = "Weapon recoil reduction"
NRSub.TextColor3 = COLOR_TEXT_D
NRSub.TextSize = 11
NRSub.TextXAlignment = Enum.TextXAlignment.Left
NRSub.Parent = Content

-- Toggle BG
local ToggleBG = Instance.new("Frame")
ToggleBG.Name = "ToggleBG"
ToggleBG.Size = UDim2.new(0, 52, 0, 28)
ToggleBG.Position = UDim2.new(1, -64, 0, 12)
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

-- Toggle Knob
local ToggleKnob = Instance.new("Frame")
ToggleKnob.Name = "Knob"
ToggleKnob.Size = UDim2.new(0, 22, 0, 22)
ToggleKnob.Position = UDim2.new(0, 3, 0.5, -11)
ToggleKnob.BackgroundColor3 = COLOR_TEXT
ToggleKnob.BorderSizePixel = 0
ToggleKnob.Parent = ToggleBG

local KnobCorner = Instance.new("UICorner")
KnobCorner.CornerRadius = UDim.new(1, 0)
KnobCorner.Parent = ToggleKnob

-- ON / OFF yazısı
local ToggleText = Instance.new("TextLabel")
ToggleText.BackgroundTransparency = 1
ToggleText.Size = UDim2.new(1, 0, 1, 0)
ToggleText.Font = Enum.Font.GothamBold
ToggleText.Text = "OFF"
ToggleText.TextColor3 = Color3.fromRGB(40, 40, 40)
ToggleText.TextSize = 10
ToggleText.Parent = ToggleKnob

-- Toggle Butonu
local ToggleButton = Instance.new("TextButton")
ToggleButton.BackgroundTransparency = 1
ToggleButton.Size = UDim2.new(1, 0, 1, 0)
ToggleButton.Text = ""
ToggleButton.Parent = ToggleBG

-- Toggle fonksiyonu
local function SetToggle(state)
    NoRecoilEnabled = state
    local bgColor = state and COLOR_ON or COLOR_OFF
    local knobPos = state and UDim2.new(0, 27, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
    local textColor = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40)
    local text = state and "ON" or "OFF"

    TweenService:Create(ToggleBG, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = bgColor}):Play()
    TweenService:Create(ToggleKnob, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = knobPos}):Play()
    TweenService:Create(ToggleText, TweenInfo.new(0.15), {TextColor3 = textColor}):Play()
    ToggleText.Text = text

    if state then
        NoRecoil_Enable()
    else
        NoRecoil_Disable()
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    SetToggle(not NoRecoilEnabled)
end)

-- ============================================================
-- GLOW PULSE ANİMASYONU
-- ============================================================
task.spawn(function()
    while Main.Parent do
        local t1 = TweenService:Create(GlowOuter, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            ImageTransparency = 0.3,
            Size = UDim2.new(1, 40, 1, 40)
        })
        local t2 = TweenService:Create(GlowOuter, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            ImageTransparency = 0.6,
            Size = UDim2.new(1, 15, 1, 15)
        })
        local t3 = TweenService:Create(GlowInner, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            ImageTransparency = 0.4,
        })
        local t4 = TweenService:Create(GlowInner, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            ImageTransparency = 0.7,
        })
        t1:Play()
        t3:Play()
        t1.Completed:Wait()
        t2:Play()
        t4:Play()
        t2.Completed:Wait()
    end
end)

-- ============================================================
-- SÜRÜKLEME
-- ============================================================
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

-- ============================================================
-- HOVER EFEKTİ
-- ============================================================
Main.MouseEnter:Connect(function()
    TweenService:Create(MainStroke, TweenInfo.new(0.25), {Thickness = 2.5, Transparency = 0.1}):Play()
end)
Main.MouseLeave:Connect(function()
    TweenService:Create(MainStroke, TweenInfo.new(0.25), {Thickness = 1.5, Transparency = 0.25}):Play()
end)

-- ============================================================
-- K TUŞU (Göster/Gizle)
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.K then
        Main.Visible = not Main.Visible
    end
end)

print("SantesHub UI v3 Loaded!")
print("Anti AFK: Active (Auto)")
print("No Recoil: Toggle with switch")
print("Press K to toggle UI visibility")
