--[[
    ╔══════════════════════════════════════════════╗
    ║          S A N T E S   H U B                ║
    ║         Premium BOOSTER v3.0                ║
    ╚══════════════════════════════════════════════╝
    
    ✦ Premium Loader animasyonu (spinner + progress)
    ✦ Profil Kartı — Avatar + İsim + HOŞGELDİN mesajı
    ✦ Username ESP (Highlight + BillboardGui)
    ✦ Recoil Control (Slider ile recoil ayarı)
    ✦ Glow pulse animasyonu
    ✦ Minimize butonu (mini kart olarak)
    ✦ Sürüklenebilir panel
]]

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser      = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- Eski instance varsa sil
for _, old in ipairs(PlayerGui:GetChildren()) do
    if old.Name == "SantesHub" then old:Destroy() end
end

----------------------------------------------------------------
-- ANTI AFK (Otomatik)
----------------------------------------------------------------
if LocalPlayer then
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

----------------------------------------------------------------
-- RECOIL CONTROL MODÜLÜ
----------------------------------------------------------------
local RecoilControlEnabled = false
local RecoilControlValue = 0  -- 0 = no recoil, 100 = full recoil
local Recoil_Connections = {}
local Recoil_WeaponCache = {}
local Recoil_GlobalOriginal = {}
local Recoil_Player = LocalPlayer

local function Recoil_CacheWeapons()
    Recoil_WeaponCache = {}
    for _, v in pairs(getgc(true)) do
        if type(v) == 'table' and rawget(v, 'EquipTime') then
            table.insert(Recoil_WeaponCache, v)
            if not Recoil_GlobalOriginal[v] then
                Recoil_GlobalOriginal[v] = {
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

local function Recoil_Apply(value)
    local ratio = value / 100  -- 0 = no recoil, 1 = full recoil
    
    for _, weapon in pairs(Recoil_WeaponCache) do
        local orig = Recoil_GlobalOriginal[weapon]
        if orig then
            weapon.Recoil = orig.Recoil * ratio
            weapon.AngleX_Min = orig.AngleX_Min * ratio
            weapon.AngleX_Max = orig.AngleX_Max * ratio
            weapon.AngleY_Min = orig.AngleY_Min * ratio
            weapon.AngleY_Max = orig.AngleY_Max * ratio
            weapon.AngleZ_Min = orig.AngleZ_Min * ratio
            weapon.AngleZ_Max = orig.AngleZ_Max * ratio
            weapon.CameraRecoilingEnabled = true
        end
    end
end

local function Recoil_Reset()
    for weapon, values in pairs(Recoil_GlobalOriginal) do
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

local function Recoil_HandleWeapon(weapon)
    if RecoilControlEnabled then
        task.wait(0.1)
        Recoil_CacheWeapons()
        Recoil_Apply(RecoilControlValue)
    end
end

local function Recoil_OnCharacterAdded(character)
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") then Recoil_HandleWeapon(child) end
    end
    table.insert(Recoil_Connections, character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then Recoil_HandleWeapon(child) end
    end))
    local humanoid = character:WaitForChild("Humanoid", 2)
    if humanoid then
        table.insert(Recoil_Connections, humanoid.Died:Connect(function()
            if RecoilControlEnabled then
                task.wait(1.5)
                Recoil_CacheWeapons()
                Recoil_Apply(RecoilControlValue)
            end
        end))
    end
end

function Recoil_Enable()
    if RecoilControlEnabled then return end
    RecoilControlEnabled = true
    Recoil_CacheWeapons()
    Recoil_Apply(RecoilControlValue)
    table.insert(Recoil_Connections, Recoil_Player.CharacterAdded:Connect(Recoil_OnCharacterAdded))
    if Recoil_Player.Character then Recoil_OnCharacterAdded(Recoil_Player.Character) end
end

function Recoil_Disable()
    if not RecoilControlEnabled then return end
    RecoilControlEnabled = false
    Recoil_Reset()
    for _, conn in ipairs(Recoil_Connections) do
        pcall(function() conn:Disconnect() end)
    end
    Recoil_Connections = {}
end

function Recoil_SetValue(value)
    RecoilControlValue = math.clamp(value, 0, 100)
    if RecoilControlEnabled then
        Recoil_CacheWeapons()
        Recoil_Apply(RecoilControlValue)
    end
end

----------------------------------------------------------------
-- RENK PALETİ
----------------------------------------------------------------
local C = {
    Bg        = Color3.fromRGB(8, 8, 11),
    BgLight   = Color3.fromRGB(13, 13, 17),
    TopBar    = Color3.fromRGB(6, 6, 8),
    Card      = Color3.fromRGB(14, 14, 18),
    Red       = Color3.fromRGB(255, 38, 52),
    RedMid    = Color3.fromRGB(200, 20, 35),
    RedDark   = Color3.fromRGB(35, 7, 9),
    RedGlow   = Color3.fromRGB(255, 60, 75),
    Gray      = Color3.fromRGB(42, 42, 48),
    GrayMid   = Color3.fromRGB(60, 60, 68),
    GrayLight = Color3.fromRGB(90, 90, 100),
    White     = Color3.fromRGB(255, 255, 255),
    OffWhite  = Color3.fromRGB(220, 220, 228),
    KnobOff   = Color3.fromRGB(200, 200, 210),
    Gold      = Color3.fromRGB(255, 200, 60),
    AvatarBg  = Color3.fromRGB(20, 20, 26),
}

----------------------------------------------------------------
-- SCREENGUI
----------------------------------------------------------------
local SG = Instance.new("ScreenGui")
SG.Name             = "SantesHub"
SG.ResetOnSpawn     = false
SG.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
SG.IgnoreGuiInset   = true
SG.Parent           = PlayerGui

----------------------------------------------------------------
-- YARDIMCI FONKSİYONLAR
----------------------------------------------------------------
local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = radius or UDim.new(0, 10)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color        = color or C.Red
    s.Thickness    = thickness or 1.4
    s.Transparency = transparency or 0.2
    s.Parent = parent
    return s
end

local function tween(obj, props, t, style, dir)
    local info = TweenInfo.new(t or 0.25, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
    TweenService:Create(obj, info, props):Play()
end

local function makeSeparator(parent, yPos)
    local sep = Instance.new("Frame")
    sep.Size             = UDim2.new(1, -32, 0, 1)
    sep.Position         = UDim2.new(0, 16, 0, yPos)
    sep.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    sep.BorderSizePixel  = 0
    sep.Parent = parent
    return sep
end

local function makeDot(parent, xOff, yOff, size)
    local d = Instance.new("Frame")
    d.Size             = UDim2.new(0, size or 7, 0, size or 7)
    d.Position         = UDim2.new(0, xOff, 0.5, yOff or -3)
    d.BackgroundColor3 = C.Red
    d.BorderSizePixel  = 0
    d.Parent = parent
    corner(d, UDim.new(1, 0))
    return d
end

local function makeGlow(parent, color, size, transparency)
    local g = Instance.new("ImageLabel")
    g.BackgroundTransparency = 1
    g.Image             = "rbxassetid://5028857084"
    g.ImageColor3       = color or Color3.fromRGB(255, 20, 35)
    g.ImageTransparency = transparency or 0.38
    g.Size              = size or UDim2.new(1, 110, 1, 110)
    g.Position          = UDim2.new(0.5, 0, 0.5, 0)
    g.AnchorPoint       = Vector2.new(0.5, 0.5)
    g.ZIndex            = 0
    g.ScaleType         = Enum.ScaleType.Slice
    g.SliceCenter       = Rect.new(100, 100, 100, 100)
    g.Parent = parent
    return g
end

----------------------------------------------------------------
-- ═══════════  L O A D E R  ═══════════
----------------------------------------------------------------
local LoaderFrame = Instance.new("Frame")
LoaderFrame.Size             = UDim2.new(0, 270, 0, 300)
LoaderFrame.Position         = UDim2.new(0.5, -135, 0.5, -150)
LoaderFrame.BackgroundColor3 = C.Bg
LoaderFrame.BorderSizePixel  = 0
LoaderFrame.ClipsDescendants = false
LoaderFrame.Parent = SG
corner(LoaderFrame, UDim.new(0, 22))
stroke(LoaderFrame, C.Red, 1.5, 0.08)

local LGlow = makeGlow(LoaderFrame)

local LogoRow = Instance.new("Frame")
LogoRow.BackgroundTransparency = 1
LogoRow.Size     = UDim2.new(1, 0, 0, 32)
LogoRow.Position = UDim2.new(0, 0, 0, 30)
LogoRow.Parent   = LoaderFrame

makeDot(LogoRow, 24)
makeDot(LogoRow, 220)

local LogoLabel = Instance.new("TextLabel")
LogoLabel.BackgroundTransparency = 1
LogoLabel.Size      = UDim2.new(1, 0, 1, 0)
LogoLabel.Font      = Enum.Font.GothamBold
LogoLabel.Text      = "SANTES HUB"
LogoLabel.TextColor3 = C.White
LogoLabel.TextSize  = 18
LogoLabel.TextXAlignment = Enum.TextXAlignment.Center
LogoLabel.Parent = LogoRow

local SubLabel = Instance.new("TextLabel")
SubLabel.BackgroundTransparency = 1
SubLabel.Size      = UDim2.new(1, 0, 0, 14)
SubLabel.Position  = UDim2.new(0, 0, 0, 65)
SubLabel.Font      = Enum.Font.Gotham
SubLabel.Text      = "✦  P R E M I U M  B O O S T E R  ✦"
SubLabel.TextColor3 = Color3.fromRGB(70, 70, 80)
SubLabel.TextSize  = 9
SubLabel.TextXAlignment = Enum.TextXAlignment.Center
SubLabel.Parent = LoaderFrame

local LogoLine = Instance.new("Frame")
LogoLine.Size             = UDim2.new(0, 0, 0, 1)
LogoLine.Position         = UDim2.new(0.5, 0, 0, 82)
LogoLine.AnchorPoint      = Vector2.new(0.5, 0)
LogoLine.BackgroundColor3 = C.Red
LogoLine.BorderSizePixel  = 0
LogoLine.Parent = LoaderFrame
corner(LogoLine, UDim.new(1, 0))

local SpinnerFrame = Instance.new("Frame")
SpinnerFrame.BackgroundTransparency = 1
SpinnerFrame.Size     = UDim2.new(0, 80, 0, 80)
SpinnerFrame.Position = UDim2.new(0.5, -40, 0, 98)
SpinnerFrame.Parent   = LoaderFrame

local SpinTrack = Instance.new("ImageLabel")
SpinTrack.BackgroundTransparency = 1
SpinTrack.Image      = "rbxassetid://4965945816"
SpinTrack.ImageColor3 = Color3.fromRGB(22, 22, 28)
SpinTrack.Size       = UDim2.new(1, 0, 1, 0)
SpinTrack.Parent     = SpinnerFrame

local SpinArc = Instance.new("ImageLabel")
SpinArc.BackgroundTransparency = 1
SpinArc.Image         = "rbxassetid://4965945816"
SpinArc.ImageColor3   = C.Red
SpinArc.ImageTransparency = 0
SpinArc.Size          = UDim2.new(1, 0, 1, 0)
SpinArc.Parent        = SpinnerFrame

local SpinArc2 = Instance.new("ImageLabel")
SpinArc2.BackgroundTransparency = 1
SpinArc2.Image         = "rbxassetid://4965945816"
SpinArc2.ImageColor3   = Color3.fromRGB(255, 80, 100)
SpinArc2.ImageTransparency = 0.7
SpinArc2.Size          = UDim2.new(1, 0, 1, 0)
SpinArc2.Parent        = SpinnerFrame

local SpinCenter = Instance.new("Frame")
SpinCenter.Size             = UDim2.new(0, 14, 0, 14)
SpinCenter.Position         = UDim2.new(0.5, -7, 0.5, -7)
SpinCenter.BackgroundColor3 = C.Red
SpinCenter.BorderSizePixel  = 0
SpinCenter.Parent = SpinnerFrame
corner(SpinCenter, UDim.new(1, 0))

local PctLabel = Instance.new("TextLabel")
PctLabel.BackgroundTransparency = 1
PctLabel.Size      = UDim2.new(0, 80, 0, 80)
PctLabel.Position  = UDim2.new(0.5, -40, 0, 98)
PctLabel.Font      = Enum.Font.GothamBold
PctLabel.Text      = "0%"
PctLabel.TextColor3 = C.Red
PctLabel.TextSize  = 14
PctLabel.ZIndex    = 5
PctLabel.TextXAlignment = Enum.TextXAlignment.Center
PctLabel.TextYAlignment = Enum.TextYAlignment.Center
PctLabel.Parent = LoaderFrame

local LoadMsg = Instance.new("TextLabel")
LoadMsg.BackgroundTransparency = 1
LoadMsg.Size      = UDim2.new(1, -40, 0, 20)
LoadMsg.Position  = UDim2.new(0, 20, 0, 192)
LoadMsg.Font      = Enum.Font.Gotham
LoadMsg.Text      = "HAZIRLANIYOR..."
LoadMsg.TextColor3 = Color3.fromRGB(90, 90, 100)
LoadMsg.TextSize  = 10
LoadMsg.TextXAlignment = Enum.TextXAlignment.Center
LoadMsg.Parent = LoaderFrame

local ProgBg = Instance.new("Frame")
ProgBg.Size             = UDim2.new(1, -48, 0, 4)
ProgBg.Position         = UDim2.new(0, 24, 0, 220)
ProgBg.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
ProgBg.BorderSizePixel  = 0
ProgBg.Parent = LoaderFrame
corner(ProgBg, UDim.new(1, 0))

local ProgFill = Instance.new("Frame")
ProgFill.Size             = UDim2.new(0, 0, 1, 0)
ProgFill.BackgroundColor3 = C.Red
ProgFill.BorderSizePixel  = 0
ProgFill.Parent = ProgBg
corner(ProgFill, UDim.new(1, 0))

local ProgDot = Instance.new("Frame")
ProgDot.Size             = UDim2.new(0, 8, 0, 8)
ProgDot.Position         = UDim2.new(0, -4, 0.5, -4)
ProgDot.BackgroundColor3 = Color3.fromRGB(255, 100, 120)
ProgDot.BorderSizePixel  = 0
ProgDot.Parent = ProgFill
corner(ProgDot, UDim.new(1, 0))

local VerRow = Instance.new("Frame")
VerRow.BackgroundTransparency = 1
VerRow.Size     = UDim2.new(1, -40, 0, 16)
VerRow.Position = UDim2.new(0, 20, 0, 268)
VerRow.Parent   = LoaderFrame

local VerLeft = Instance.new("TextLabel")
VerLeft.BackgroundTransparency = 1
VerLeft.Size      = UDim2.new(0.5, 0, 1, 0)
VerLeft.Font      = Enum.Font.GothamBold
VerLeft.Text      = "SANTES"
VerLeft.TextColor3 = Color3.fromRGB(255, 30, 45)
VerLeft.TextSize  = 8
VerLeft.TextXAlignment = Enum.TextXAlignment.Left
VerLeft.Parent = VerRow

local VerRight = Instance.new("TextLabel")
VerRight.BackgroundTransparency = 1
VerRight.Size     = UDim2.new(0.5, 0, 1, 0)
VerRight.Position = UDim2.new(0.5, 0, 0, 0)
VerRight.Font     = Enum.Font.Gotham
VerRight.Text     = "v3.0 PREMIUM"
VerRight.TextColor3 = Color3.fromRGB(45, 45, 55)
VerRight.TextSize = 8
VerRight.TextXAlignment = Enum.TextXAlignment.Right
VerRight.Parent = VerRow

----------------------------------------------------------------
-- LOADER ANİMASYON
----------------------------------------------------------------
local MESSAGES = {
    "MODÜLLER YÜKLENİYOR...",
    "OYUNCULAR ALINIYOR...",
    "GUI HAZIRLANIYOR...",
    "BYPASS EDİLİYOR...",
    "SANTESHUB KURULUYOR...",
    "SANTES HUB HAZIR  ✓",
}

local spinAngle  = 0
local spinAngle2 = 0
local spinConn = RunService.RenderStepped:Connect(function(dt)
    spinAngle  = (spinAngle  + dt * 230) % 360
    spinAngle2 = (spinAngle2 - dt * 110) % 360
    SpinArc.Rotation  = spinAngle
    SpinArc2.Rotation = spinAngle2
end)

tween(LogoLine, { Size = UDim2.new(0, 160, 0, 1) }, 0.7, Enum.EasingStyle.Quad)

local function runLoader(onDone)
    local step    = #MESSAGES
    local perStep = 0.5

    for i, msg in ipairs(MESSAGES) do
        task.delay((i - 1) * perStep, function()
            LoadMsg.Text = msg
            local pct = math.floor((i / step) * 100)
            PctLabel.Text = pct .. "%"
            tween(ProgFill, { Size = UDim2.new(i / step, 0, 1, 0) }, perStep - 0.05, Enum.EasingStyle.Quad)
        end)
    end

    task.delay(step * perStep + 0.25, function()
        spinConn:Disconnect()
        tween(LoaderFrame, { BackgroundTransparency = 1 }, 0.45)
        tween(LGlow, { ImageTransparency = 1 }, 0.45)

        for _, d in ipairs(LoaderFrame:GetDescendants()) do
            pcall(function()
                if d:IsA("TextLabel") then
                    tween(d, { TextTransparency = 1 }, 0.35)
                elseif d:IsA("Frame") then
                    tween(d, { BackgroundTransparency = 1 }, 0.35)
                elseif d:IsA("ImageLabel") then
                    tween(d, { ImageTransparency = 1 }, 0.35)
                end
            end)
        end

        task.delay(0.55, function()
            LoaderFrame:Destroy()
            onDone()
        end)
    end)
end

----------------------------------------------------------------
-- ═══════════  A N A   P A N E L  ═══════════
----------------------------------------------------------------
local function buildMainGui()

    -- Ana Frame (yükseklik 320 yaptım slider için)
    local Main = Instance.new("Frame")
    Main.Name             = "Main"
    Main.Size             = UDim2.new(0, 320, 0, 1)
    Main.Position         = UDim2.new(0.5, -160, 0.5, -160)
    Main.BackgroundColor3 = C.Bg
    Main.BorderSizePixel  = 0
    Main.ClipsDescendants = false
    Main.Visible          = true
    Main.Parent           = SG
    corner(Main, UDim.new(0, 18))
    stroke(Main, C.Red, 1.5, 0.1)

    local MainGlow = makeGlow(Main, Color3.fromRGB(255, 20, 35), UDim2.new(1, 100, 1, 100), 0.42)

    task.delay(0.05, function()
        tween(Main, { Size = UDim2.new(0, 320, 0, 320) }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)

    ------------------------------------------------------------------
    -- TOP BAR
    ------------------------------------------------------------------
    local TopBar = Instance.new("Frame")
    TopBar.Name             = "TopBar"
    TopBar.Size             = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = C.TopBar
    TopBar.BorderSizePixel  = 0
    TopBar.Parent = Main
    corner(TopBar, UDim.new(0, 18))

    local TBFix = Instance.new("Frame")
    TBFix.Size             = UDim2.new(1, 0, 0, 18)
    TBFix.Position         = UDim2.new(0, 0, 1, -18)
    TBFix.BackgroundColor3 = C.TopBar
    TBFix.BorderSizePixel  = 0
    TBFix.ZIndex = 0
    TBFix.Parent = TopBar

    for _, xp in ipairs({12, 22}) do
        makeDot(TopBar, xp, -3, 6)
    end

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Position  = UDim2.new(0, 38, 0, 0)
    TitleLbl.Size      = UDim2.new(1, -115, 1, 0)
    TitleLbl.Font      = Enum.Font.GothamBold
    TitleLbl.Text      = "SANTES HUB"
    TitleLbl.TextColor3 = C.Red
    TitleLbl.TextSize  = 13
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Parent = TopBar

    local function makeTopBtn(text, xOff)
        local btn = Instance.new("TextButton")
        btn.Size             = UDim2.new(0, 26, 0, 26)
        btn.Position         = UDim2.new(1, xOff, 0.5, -13)
        btn.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
        btn.Text             = text
        btn.Font             = Enum.Font.GothamBold
        btn.TextSize         = 11
        btn.TextColor3       = Color3.fromRGB(255, 65, 75)
        btn.AutoButtonColor  = false
        btn.Parent = TopBar
        corner(btn, UDim.new(1, 0))
        stroke(btn, C.Red, 1, 0.45)
        btn.MouseEnter:Connect(function() tween(btn, { BackgroundColor3 = C.RedDark }, 0.15) end)
        btn.MouseLeave:Connect(function() tween(btn, { BackgroundColor3 = Color3.fromRGB(16, 16, 20) }, 0.15) end)
        return btn
    end

    local CloseBtn = makeTopBtn("✕", -33)
    local MinBtn   = makeTopBtn("─", -63)

    ------------------------------------------------------------------
    -- İçerik alanı
    ------------------------------------------------------------------
    local Content = Instance.new("Frame")
    Content.BackgroundTransparency = 1
    Content.Size     = UDim2.new(1, 0, 1, -40)
    Content.Position = UDim2.new(0, 0, 0, 40)
    Content.Parent = Main

    ------------------------------------------------------------------
    -- PROFİL KARTI
    ------------------------------------------------------------------
    local ProfileCard = Instance.new("Frame")
    ProfileCard.Size             = UDim2.new(1, -24, 0, 62)
    ProfileCard.Position         = UDim2.new(0, 12, 0, 10)
    ProfileCard.BackgroundColor3 = C.Card
    ProfileCard.BorderSizePixel  = 0
    ProfileCard.ClipsDescendants = false
    ProfileCard.Parent = Content
    corner(ProfileCard, UDim.new(0, 12))
    stroke(ProfileCard, Color3.fromRGB(30, 30, 38), 1, 0.2)

    local ProfileAccent = Instance.new("Frame")
    ProfileAccent.Size             = UDim2.new(0, 2, 0.7, 0)
    ProfileAccent.Position         = UDim2.new(0, 0, 0.15, 0)
    ProfileAccent.BackgroundColor3 = C.Red
    ProfileAccent.BorderSizePixel  = 0
    ProfileAccent.Parent = ProfileCard
    corner(ProfileAccent, UDim.new(1, 0))

    local AvatarRing = Instance.new("Frame")
    AvatarRing.Size             = UDim2.new(0, 46, 0, 46)
    AvatarRing.Position         = UDim2.new(0, 10, 0.5, -23)
    AvatarRing.BackgroundColor3 = C.AvatarBg
    AvatarRing.BorderSizePixel  = 0
    AvatarRing.Parent = ProfileCard
    corner(AvatarRing, UDim.new(1, 0))
    stroke(AvatarRing, C.Red, 1.5, 0.1)

    local AvatarImg = Instance.new("ImageLabel")
    AvatarImg.Size             = UDim2.new(1, -4, 1, -4)
    AvatarImg.Position         = UDim2.new(0, 2, 0, 2)
    AvatarImg.BackgroundTransparency = 1
    AvatarImg.Image            = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=48&h=48"
    AvatarImg.ImageColor3      = C.White
    AvatarImg.Parent = AvatarRing
    corner(AvatarImg, UDim.new(1, 0))

    local OnlineDot = Instance.new("Frame")
    OnlineDot.Size             = UDim2.new(0, 10, 0, 10)
    OnlineDot.Position         = UDim2.new(1, -10, 1, -10)
    OnlineDot.BackgroundColor3 = Color3.fromRGB(50, 220, 100)
    OnlineDot.BorderSizePixel  = 0
    OnlineDot.ZIndex = 5
    OnlineDot.Parent = AvatarRing
    corner(OnlineDot, UDim.new(1, 0))
    stroke(OnlineDot, C.Card, 1.5, 0)

    local ProfileText = Instance.new("Frame")
    ProfileText.BackgroundTransparency = 1
    ProfileText.Size     = UDim2.new(1, -68, 0, 50)
    ProfileText.Position = UDim2.new(0, 62, 0.5, -25)
    ProfileText.Parent = ProfileCard

    local ProfileName = Instance.new("TextLabel")
    ProfileName.BackgroundTransparency = 1
    ProfileName.Size      = UDim2.new(1, 0, 0, 24)
    ProfileName.Position  = UDim2.new(0, 0, 0, 4)
    ProfileName.Font      = Enum.Font.GothamBold
    ProfileName.Text      = LocalPlayer.Name
    ProfileName.TextColor3 = C.White
    ProfileName.TextSize  = 14
    ProfileName.TextXAlignment = Enum.TextXAlignment.Left
    ProfileName.TextTruncate   = Enum.TextTruncate.AtEnd
    ProfileName.Parent = ProfileText

    local WelcomeLabel = Instance.new("TextLabel")
    WelcomeLabel.BackgroundTransparency = 1
    WelcomeLabel.Size     = UDim2.new(1, 0, 0, 18)
    WelcomeLabel.Position = UDim2.new(0, 0, 0, 27)
    WelcomeLabel.Font     = Enum.Font.Gotham
    WelcomeLabel.Text     = "✦  SANTES HUB'A HOŞGELDİN!"
    WelcomeLabel.TextColor3 = C.Red
    WelcomeLabel.TextSize = 10
    WelcomeLabel.TextXAlignment = Enum.TextXAlignment.Left
    WelcomeLabel.Parent = ProfileText

    local BadgeFrame = Instance.new("Frame")
    BadgeFrame.Size             = UDim2.new(0, 64, 0, 18)
    BadgeFrame.Position         = UDim2.new(1, -68, 0, 8)
    BadgeFrame.BackgroundColor3 = Color3.fromRGB(255, 200, 60)
    BadgeFrame.BorderSizePixel  = 0
    BadgeFrame.Parent = ProfileCard
    corner(BadgeFrame, UDim.new(0, 5))

    local BadgeLabel = Instance.new("TextLabel")
    BadgeLabel.BackgroundTransparency = 1
    BadgeLabel.Size      = UDim2.new(1, 0, 1, 0)
    BadgeLabel.Font      = Enum.Font.GothamBold
    BadgeLabel.Text      = "PREMIUM"
    BadgeLabel.TextColor3 = Color3.fromRGB(120, 80, 0)
    BadgeLabel.TextSize  = 8
    BadgeLabel.TextXAlignment = Enum.TextXAlignment.Center
    BadgeLabel.Parent = BadgeFrame

    ------------------------------------------------------------------
    -- GÖRSEL BÖLÜM BAŞLIĞI
    ------------------------------------------------------------------
    local SecLabel = Instance.new("TextLabel")
    SecLabel.BackgroundTransparency = 1
    SecLabel.Size      = UDim2.new(1, -32, 0, 14)
    SecLabel.Position  = UDim2.new(0, 16, 0, 83)
    SecLabel.Font      = Enum.Font.GothamBold
    SecLabel.Text      = "GÖRSEL"
    SecLabel.TextColor3 = Color3.fromRGB(50, 50, 62)
    SecLabel.TextSize  = 9
    SecLabel.TextXAlignment = Enum.TextXAlignment.Left
    SecLabel.Parent = Content

    makeSeparator(Content, 99)

    ------------------------------------------------------------------
    -- ESP TOGGLE
    ------------------------------------------------------------------
    local Row = Instance.new("Frame")
    Row.BackgroundTransparency = 1
    Row.Size     = UDim2.new(1, -32, 0, 48)
    Row.Position = UDim2.new(0, 16, 0, 104)
    Row.Parent = Content

    local SwitchOuter = Instance.new("TextButton")
    SwitchOuter.Size             = UDim2.new(0, 76, 0, 36)
    SwitchOuter.Position         = UDim2.new(1, -76, 0.5, -18)
    SwitchOuter.BackgroundColor3 = C.Gray
    SwitchOuter.Text             = ""
    SwitchOuter.AutoButtonColor  = false
    SwitchOuter.Parent = Row
    corner(SwitchOuter, UDim.new(1, 0))

    local SwitchStroke = stroke(SwitchOuter, Color3.fromRGB(75, 75, 85), 1.2, 0.3)

    local Knob = Instance.new("Frame")
    Knob.Size             = UDim2.new(0, 28, 0, 28)
    Knob.Position         = UDim2.new(0, 4, 0.5, -14)
    Knob.BackgroundColor3 = C.KnobOff
    Knob.BorderSizePixel  = 0
    Knob.Parent = SwitchOuter
    corner(Knob, UDim.new(1, 0))

    local RowText = Instance.new("Frame")
    RowText.BackgroundTransparency = 1
    RowText.Size     = UDim2.new(1, -90, 1, 0)
    RowText.Parent = Row

    local FeatureLabel = Instance.new("TextLabel")
    FeatureLabel.BackgroundTransparency = 1
    FeatureLabel.Size      = UDim2.new(1, 0, 0, 22)
    FeatureLabel.Font      = Enum.Font.GothamBold
    FeatureLabel.Text      = "USERNAME ESP"
    FeatureLabel.TextColor3 = C.OffWhite
    FeatureLabel.TextSize  = 12
    FeatureLabel.TextXAlignment = Enum.TextXAlignment.Left
    FeatureLabel.Parent = RowText

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Size      = UDim2.new(1, 0, 0, 16)
    StatusLabel.Position  = UDim2.new(0, 0, 0, 22)
    StatusLabel.Font      = Enum.Font.Gotham
    StatusLabel.Text      = "● KAPALI"
    StatusLabel.TextColor3 = Color3.fromRGB(72, 72, 84)
    StatusLabel.TextSize  = 10
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.Parent = RowText

    ------------------------------------------------------------------
    -- RECOIL CONTROL (Slider) - GÖRSEL bölümü altında
    ------------------------------------------------------------------
    local RecoilLabel = Instance.new("TextLabel")
    RecoilLabel.BackgroundTransparency = 1
    RecoilLabel.Size      = UDim2.new(1, -32, 0, 14)
    RecoilLabel.Position  = UDim2.new(0, 16, 0, 160)
    RecoilLabel.Font      = Enum.Font.GothamBold
    RecoilLabel.Text      = "RECOIL CONTROL"
    RecoilLabel.TextColor3 = Color3.fromRGB(50, 50, 62)
    RecoilLabel.TextSize  = 9
    RecoilLabel.TextXAlignment = Enum.TextXAlignment.Left
    RecoilLabel.Parent = Content

    makeSeparator(Content, 176)

    -- Recoil Row
    local RecoilRow = Instance.new("Frame")
    RecoilRow.BackgroundTransparency = 1
    RecoilRow.Size     = UDim2.new(1, -32, 0, 50)
    RecoilRow.Position = UDim2.new(0, 16, 0, 182)
    RecoilRow.Parent = Content

    -- Recoil yazısı
    local RecoilText = Instance.new("TextLabel")
    RecoilText.BackgroundTransparency = 1
    RecoilText.Size      = UDim2.new(0.4, 0, 0, 20)
    RecoilText.Position  = UDim2.new(0, 0, 0, 0)
    RecoilText.Font      = Enum.Font.Gotham
    RecoilText.Text      = "Recoil"
    RecoilText.TextColor3 = C.OffWhite
    RecoilText.TextSize  = 12
    RecoilText.TextXAlignment = Enum.TextXAlignment.Left
    RecoilText.Parent = RecoilRow

    -- Recoil değeri (sağda)
    local RecoilValueLabel = Instance.new("TextLabel")
    RecoilValueLabel.BackgroundTransparency = 1
    RecoilValueLabel.Size      = UDim2.new(0.2, 0, 0, 20)
    RecoilValueLabel.Position  = UDim2.new(0.8, 0, 0, 0)
    RecoilValueLabel.Font      = Enum.Font.GothamBold
    RecoilValueLabel.Text      = "0%"
    RecoilValueLabel.TextColor3 = C.Red
    RecoilValueLabel.TextSize  = 12
    RecoilValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    RecoilValueLabel.Parent = RecoilRow

    -- Slider arkaplan
    local SliderBg = Instance.new("Frame")
    SliderBg.Size             = UDim2.new(1, 0, 0, 6)
    SliderBg.Position         = UDim2.new(0, 0, 0, 28)
    SliderBg.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    SliderBg.BorderSizePixel  = 0
    SliderBg.Parent = RecoilRow
    corner(SliderBg, UDim.new(1, 0))

    -- Slider dolu kısım
    local SliderFill = Instance.new("Frame")
    SliderFill.Size             = UDim2.new(0, 0, 1, 0)
    SliderFill.BackgroundColor3 = C.Red
    SliderFill.BorderSizePixel  = 0
    SliderFill.Parent = SliderBg
    corner(SliderFill, UDim.new(1, 0))

    -- Slider knob (yuvarlak tutamak)
    local SliderKnob = Instance.new("TextButton")
    SliderKnob.Size             = UDim2.new(0, 20, 0, 20)
    SliderKnob.Position         = UDim2.new(0, -10, 0.5, -10)
    SliderKnob.BackgroundColor3 = C.Red
    SliderKnob.Text             = ""
    SliderKnob.BorderSizePixel  = 0
    SliderKnob.AutoButtonColor  = false
    SliderKnob.Parent = SliderBg
    corner(SliderKnob, UDim.new(1, 0))

    -- Knob glow
    local KnobGlow = Instance.new("ImageLabel")
    KnobGlow.BackgroundTransparency = 1
    KnobGlow.Image             = "rbxassetid://5028857084"
    KnobGlow.ImageColor3       = Color3.fromRGB(255, 50, 70)
    KnobGlow.ImageTransparency = 0.5
    KnobGlow.Size              = UDim2.new(1, 20, 1, 20)
    KnobGlow.Position          = UDim2.new(0.5, 0, 0.5, 0)
    KnobGlow.AnchorPoint      = Vector2.new(0.5, 0.5)
    KnobGlow.ZIndex            = 0
    KnobGlow.Parent = SliderKnob

    local isDragging = false
    local currentValue = 0

    local function updateSlider(value)
        value = math.clamp(value, 0, 100)
        currentValue = value
        local percent = value / 100
        
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        SliderKnob.Position = UDim2.new(percent, -10, 0.5, -10)
        RecoilValueLabel.Text = math.floor(value) .. "%"
        
        -- Recoil değerini uygula
        Recoil_SetValue(value)
    end

    local function getSliderPosition(input)
        local absPos = SliderBg.AbsolutePosition
        local absSize = SliderBg.AbsoluteSize
        local mouseX = input.Position.X
        local relativeX = math.clamp((mouseX - absPos.X) / absSize.X, 0, 1)
        return relativeX * 100
    end

    SliderKnob.MouseButton1Down:Connect(function(input)
        isDragging = true
        local val = getSliderPosition(input)
        updateSlider(val)
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local val = getSliderPosition(input)
            updateSlider(val)
        end
    end)

    -- Slider'a tıklayınca
    SliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local val = getSliderPosition(input)
            updateSlider(val)
        end
    end)

    -- Başlangıç değeri 0 (no recoil)
    updateSlider(0)

    -- Recoil Control toggle (AÇIK/KAPALI) butonu
    local RecoilToggleOuter = Instance.new("TextButton")
    RecoilToggleOuter.Size             = UDim2.new(0, 50, 0, 24)
    RecoilToggleOuter.Position         = UDim2.new(0.6, 0, 0, 0)
    RecoilToggleOuter.BackgroundColor3 = C.Gray
    RecoilToggleOuter.Text             = ""
    RecoilToggleOuter.AutoButtonColor  = false
    RecoilToggleOuter.Parent = RecoilRow
    corner(RecoilToggleOuter, UDim.new(1, 0))
    stroke(RecoilToggleOuter, Color3.fromRGB(75, 75, 85), 1.2, 0.3)

    local RecoilToggleKnob = Instance.new("Frame")
    RecoilToggleKnob.Size             = UDim2.new(0, 18, 0, 18)
    RecoilToggleKnob.Position         = UDim2.new(0, 3, 0.5, -9)
    RecoilToggleKnob.BackgroundColor3 = C.KnobOff
    RecoilToggleKnob.BorderSizePixel  = 0
    RecoilToggleKnob.Parent = RecoilToggleOuter
    corner(RecoilToggleKnob, UDim.new(1, 0))

    local RecoilToggleText = Instance.new("TextLabel")
    RecoilToggleText.BackgroundTransparency = 1
    RecoilToggleText.Size      = UDim2.new(1, 0, 1, 0)
    RecoilToggleText.Font      = Enum.Font.GothamBold
    RecoilToggleText.Text      = "OFF"
    RecoilToggleText.TextColor3 = Color3.fromRGB(40, 40, 40)
    RecoilToggleText.TextSize  = 9
    RecoilToggleText.Parent = RecoilToggleKnob

    local recoilToggled = false

    local function setRecoilToggle(state)
        recoilToggled = state
        if recoilToggled then
            tween(RecoilToggleOuter, { BackgroundColor3 = C.RedDark })
            tween(RecoilToggleKnob, { Position = UDim2.new(1, -21, 0.5, -9), BackgroundColor3 = C.Red })
            RecoilToggleText.Text = "ON"
            RecoilToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
            Recoil_Enable()
            -- Slider değerini uygula
            updateSlider(currentValue)
        else
            tween(RecoilToggleOuter, { BackgroundColor3 = C.Gray })
            tween(RecoilToggleKnob, { Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = C.KnobOff })
            RecoilToggleText.Text = "OFF"
            RecoilToggleText.TextColor3 = Color3.fromRGB(40, 40, 40)
            Recoil_Disable()
        end
    end

    RecoilToggleOuter.MouseButton1Click:Connect(function()
        setRecoilToggle(not recoilToggled)
    end)

    ------------------------------------------------------------------
    -- BİLGİ NOTU
    ------------------------------------------------------------------
    local InfoRow = Instance.new("Frame")
    InfoRow.BackgroundTransparency = 0
    InfoRow.Size     = UDim2.new(1, -24, 0, 22)
    InfoRow.Position = UDim2.new(0, 12, 0, 248)
    InfoRow.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
    InfoRow.BorderSizePixel  = 0
    InfoRow.Parent = Content
    corner(InfoRow, UDim.new(0, 6))

    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Size      = UDim2.new(1, -10, 1, 0)
    InfoLabel.Position  = UDim2.new(0, 5, 0, 0)
    InfoLabel.Font      = Enum.Font.Gotham
    InfoLabel.Text      = "Esp Harita Sınırıdında Yok Olur!"
    InfoLabel.TextColor3 = Color3.fromRGB(50, 50, 60)
    InfoLabel.TextSize  = 9
    InfoLabel.TextXAlignment = Enum.TextXAlignment.Center
    InfoLabel.Parent = InfoRow

    ------------------------------------------------------------------
    -- ALT FOOTER
    ------------------------------------------------------------------
    makeSeparator(Content, 280)

    local FootRow = Instance.new("Frame")
    FootRow.BackgroundTransparency = 1
    FootRow.Size     = UDim2.new(1, -32, 0, 14)
    FootRow.Position = UDim2.new(0, 16, 0, 286)
    FootRow.Parent = Content

    local FootLeft = Instance.new("TextLabel")
    FootLeft.BackgroundTransparency = 1
    FootLeft.Size     = UDim2.new(0.5, 0, 1, 0)
    FootLeft.Font     = Enum.Font.GothamBold
    FootLeft.Text     = "SANTES"
    FootLeft.TextColor3 = Color3.fromRGB(255, 30, 45)
    FootLeft.TextSize = 8
    FootLeft.TextXAlignment = Enum.TextXAlignment.Left
    FootLeft.Parent = FootRow

    local FootRight = Instance.new("TextLabel")
    FootRight.BackgroundTransparency = 1
    FootRight.Size     = UDim2.new(0.5, 0, 1, 0)
    FootRight.Position = UDim2.new(0.5, 0, 0, 0)
    FootRight.Font     = Enum.Font.Gotham
    FootRight.Text     = "v3.0 PREMIUM"
    FootRight.TextColor3 = Color3.fromRGB(35, 35, 44)
    FootRight.TextSize = 8
    FootRight.TextXAlignment = Enum.TextXAlignment.Right
    FootRight.Parent = FootRow

    ------------------------------------------------------------------
    -- MİNİ KARE
    ------------------------------------------------------------------
    local MiniFrame = Instance.new("Frame")
    MiniFrame.Name             = "MiniFrame"
    MiniFrame.Size             = UDim2.new(0, 48, 0, 48)
    MiniFrame.Position         = Main.Position
    MiniFrame.BackgroundColor3 = C.Bg
    MiniFrame.BorderSizePixel  = 0
    MiniFrame.Visible          = false
    MiniFrame.Parent = SG
    corner(MiniFrame, UDim.new(0, 13))
    stroke(MiniFrame, C.Red, 1.5, 0.08)

    makeGlow(MiniFrame, Color3.fromRGB(255, 20, 35), UDim2.new(1, 60, 1, 60), 0.38)

    local MiniAvatar = Instance.new("ImageLabel")
    MiniAvatar.Size             = UDim2.new(0, 32, 0, 32)
    MiniAvatar.Position         = UDim2.new(0.5, -16, 0.5, -16)
    MiniAvatar.BackgroundTransparency = 1
    MiniAvatar.Image            = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=48&h=48"
    MiniAvatar.Parent = MiniFrame
    corner(MiniAvatar, UDim.new(1, 0))

    local MiniBtn = Instance.new("TextButton")
    MiniBtn.Size             = UDim2.new(1, 0, 1, 0)
    MiniBtn.BackgroundTransparency = 1
    MiniBtn.Text             = ""
    MiniBtn.AutoButtonColor  = false
    MiniBtn.Parent = MiniFrame

    ------------------------------------------------------------------
    -- SÜRÜKLEME
    ------------------------------------------------------------------
    local function makeDraggable(frame, handle)
        local dragging, dragStart, startPos = false, nil, nil

        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
               or input.UserInputType == Enum.UserInputType.Touch then
                dragging  = true
                dragStart = input.Position
                startPos  = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        handle.InputChanged:Connect(function(input)
            if dragging and (
                input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch
            ) then
                local d = input.Position - dragStart
                frame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + d.X,
                    startPos.Y.Scale, startPos.Y.Offset + d.Y
                )
            end
        end)
    end

    makeDraggable(Main, TopBar)
    makeDraggable(MiniFrame, MiniBtn)

    ------------------------------------------------------------------
    -- MİNİMİZE / RESTORE
    ------------------------------------------------------------------
    MinBtn.MouseButton1Click:Connect(function()
        MiniFrame.Position = Main.Position
        MiniFrame.Visible  = true
        Main.Visible       = false
    end)

    MiniBtn.MouseButton1Click:Connect(function()
        Main.Position     = MiniFrame.Position
        MiniFrame.Visible = false
        Main.Visible      = true
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        tween(Main, { Size = UDim2.new(0, 320, 0, 1) }, 0.25, Enum.EasingStyle.Quad)
        task.delay(0.3, function() SG:Destroy() end)
    end)

    ------------------------------------------------------------------
    -- ESP
    ------------------------------------------------------------------
    local ESPHolder = Instance.new("Folder")
    ESPHolder.Name   = "SantesESP"
    ESPHolder.Parent = game:GetService("CoreGui")

    local function makeTagTemplate()
        local bb = Instance.new("BillboardGui")
        bb.AlwaysOnTop      = false
        bb.Size             = UDim2.new(0, 170, 0, 44)
        bb.StudsOffset      = Vector3.new(0, 2.8, 0)
        bb.MaxDistance      = 999
        bb.ClipsDescendants = false

        local bg = Instance.new("Frame")
        bg.BackgroundColor3    = Color3.fromRGB(0, 0, 0)
        bg.BackgroundTransparency = 0.5
        bg.Size                = UDim2.new(1, 0, 1, 0)
        bg.BorderSizePixel     = 0
        bg.Parent = bb
        corner(bg, UDim.new(0, 6))

        local bgStroke = Instance.new("UIStroke")
        bgStroke.Color        = C.Red
        bgStroke.Transparency = 0.7
        bgStroke.Thickness    = 0.8
        bgStroke.Parent = bg

        local nameTag = Instance.new("TextLabel")
        nameTag.Name               = "NameTag"
        nameTag.BackgroundTransparency = 1
        nameTag.Size               = UDim2.new(1, -8, 0, 22)
        nameTag.Position           = UDim2.new(0, 4, 0, 2)
        nameTag.Font               = Enum.Font.GothamBold
        nameTag.TextSize           = 12
        nameTag.TextColor3         = Color3.fromRGB(255, 255, 255)
        nameTag.TextTransparency   = 0.05
        nameTag.TextStrokeColor3   = Color3.fromRGB(0, 0, 0)
        nameTag.TextStrokeTransparency = 0.25
        nameTag.Text               = ""
        nameTag.TextXAlignment     = Enum.TextXAlignment.Center
        nameTag.TextScaled         = false
        nameTag.Parent = bb

        local dispTag = Instance.new("TextLabel")
        dispTag.Name               = "DispTag"
        dispTag.BackgroundTransparency = 1
        dispTag.Size               = UDim2.new(1, -8, 0, 16)
        dispTag.Position           = UDim2.new(0, 4, 0, 24)
        dispTag.Font               = Enum.Font.Gotham
        dispTag.TextSize           = 10
        dispTag.TextColor3         = Color3.fromRGB(255, 100, 110)
        dispTag.TextTransparency   = 0.1
        dispTag.TextStrokeColor3   = Color3.fromRGB(0, 0, 0)
        dispTag.TextStrokeTransparency = 0.25
        dispTag.Text               = ""
        dispTag.TextXAlignment     = Enum.TextXAlignment.Center
        dispTag.TextScaled         = false
        dispTag.Parent = bb

        return bb
    end

    local function loadESP(plr)
        if plr == LocalPlayer then return end

        local char = plr.Character
        if not char then return end

        local root = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        if not root or not head then return end

        local old = ESPHolder:FindFirstChild(plr.Name)
        if old then old:Destroy() end

        local pFolder = Instance.new("Folder")
        pFolder.Name   = plr.Name
        pFolder.Parent = ESPHolder

        local hl = Instance.new("Highlight")
        hl.Name                = "ESPHighlight"
        hl.Adornee             = char
        hl.FillColor           = Color3.fromRGB(255, 255, 255)
        hl.OutlineColor        = C.Red
        hl.FillTransparency    = 0.7
        hl.OutlineTransparency = 0.05
        hl.DepthMode           = Enum.HighlightDepthMode.Occluded
        hl.Parent = pFolder

        local tag = makeTagTemplate()
        tag.Adornee = head

        local uname    = plr.Name
        local dname    = plr.DisplayName
        local dispText = (dname ~= uname) and ("(" .. dname .. ")") or ""

        tag.NameTag.Text = uname
        tag.DispTag.Text = dispText
        tag.Parent = pFolder

        return pFolder
    end

    local function unloadESP(plr)
        local f = ESPHolder:FindFirstChild(plr.Name)
        if f then f:Destroy() end
    end

    local function clearAllESP()
        ESPHolder:ClearAllChildren()
    end

    local function loadAllESP()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then pcall(loadESP, plr) end
        end
    end

    local charConns = {}

    local function watchPlayer(plr)
        if plr == LocalPlayer then return end
        local addC = plr.CharacterAdded:Connect(function()
            task.wait(0.5)
            if toggled then pcall(loadESP, plr) end
        end)
        local remC = plr.CharacterRemoving:Connect(function()
            unloadESP(plr)
        end)
        charConns[plr] = { addC, remC }
    end

    local function unwatchPlayer(plr)
        if charConns[plr] then
            for _, c in ipairs(charConns[plr]) do c:Disconnect() end
            charConns[plr] = nil
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do watchPlayer(plr) end

    Players.PlayerAdded:Connect(function(plr)
        watchPlayer(plr)
        if toggled then task.delay(1, function() pcall(loadESP, plr) end) end
    end)

    Players.PlayerRemoving:Connect(function(plr)
        unwatchPlayer(plr)
        unloadESP(plr)
    end)

    ------------------------------------------------------------------
    -- ESP TOGGLE LOGIC
    ------------------------------------------------------------------
    toggled = false

    local function setToggle(state)
        toggled = state

        if toggled then
            tween(SwitchOuter, { BackgroundColor3 = C.RedDark })
            tween(SwitchStroke, { Color = C.Red, Transparency = 0 })
            tween(Knob, { Position = UDim2.new(1, -32, 0.5, -14), BackgroundColor3 = C.Red })
            StatusLabel.Text      = "● AÇIK"
            StatusLabel.TextColor3 = C.Red
            loadAllESP()
        else
            tween(SwitchOuter, { BackgroundColor3 = C.Gray })
            tween(SwitchStroke, { Color = Color3.fromRGB(75, 75, 85), Transparency = 0.3 })
            tween(Knob, { Position = UDim2.new(0, 4, 0.5, -14), BackgroundColor3 = C.KnobOff })
            StatusLabel.Text      = "● KAPALI"
            StatusLabel.TextColor3 = Color3.fromRGB(72, 72, 84)
            clearAllESP()
        end
    end

    SwitchOuter.MouseButton1Click:Connect(function()
        setToggle(not toggled)
    end)

    ------------------------------------------------------------------
    -- TEMİZLEME
    ------------------------------------------------------------------
    SG.Destroying:Connect(function()
        clearAllESP()
        for plr in pairs(charConns) do unwatchPlayer(plr) end
        Recoil_Disable()
    end)

end -- buildMainGui sonu

----------------------------------------------------------------
-- LOADER'ı çalıştır → ana panel
----------------------------------------------------------------
toggled = false
runLoader(function()
    buildMainGui()
end)
