-- SANTES HUB v3.0 - COMPLETE EDITION
-- Tüm özellikler eklendi, hiçbir şey eksik değil

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
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local ContextActionService = game:GetService("ContextActionService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Mouse = LocalPlayer:GetMouse()

-- #####################################################################
-- #                          ANTI-IDLE                               #
-- #####################################################################

pcall(function()
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

-- #####################################################################
-- #                     ESKI UI TEMIZLEME                            #
-- #####################################################################

local guiNamesToClean = {
    "SantesHubScreenGui", "SantesHubScreenGui_Categorized", "EQRHubScreenGui",
    "VenomHubScreenGui", "VenomHubScreenGui_Categorized", "ShadowWarningHUD",
    "InvisWarningGUI", "InvisWarning", "SantesMinimizeFrame", "SantesMobileControls",
    "SantesHub_Main", "SantesHub_Loader"
}

for _, name in pairs(guiNamesToClean) do
    pcall(function()
        if PlayerGui:FindFirstChild(name) then PlayerGui:FindFirstChild(name):Destroy() end
        if CoreGui:FindFirstChild(name) then CoreGui:FindFirstChild(name):Destroy() end
    end)
end

task.wait(0.5)

-- #####################################################################
-- #                         THEME COLORS                             #
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
-- #                         LOADER UI                                #
-- #####################################################################

local loaderGui = Instance.new("ScreenGui")
loaderGui.Name = "SantesHub_Loader"
loaderGui.ResetOnSpawn = false
loaderGui.IgnoreGuiInset = true
loaderGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
loaderGui.Parent = PlayerGui

local RED = Color3.fromRGB(200, 22, 22)
local RED_DIM = Color3.fromRGB(100, 10, 10)
local RED_FAINT = Color3.fromRGB(30, 4, 4)
local WHITE = Color3.fromRGB(240, 240, 240)
local DARK_BG = Color3.fromRGB(10, 10, 10)
local BORDER_COL = Color3.fromRGB(140, 18, 18)

local CARD_W, CARD_H = 360, 320
local LOAD_MESSAGES = {
    "SISTEM BASLATILIYOR...",
    "MODULLER YUKLENIYOR...",
    "BAGLANTI KURULUYOR...",
    "GUVENLIK AKTIF...",
    "ARAYUZ HAZIRLANIYOR...",
    "SANTES HUB AKTIF.",
}

local card = Instance.new("Frame")
card.Size = UDim2.new(0, CARD_W, 0, CARD_H)
card.Position = UDim2.new(0.5, 0, 0.5, 0)
card.AnchorPoint = Vector2.new(0.5, 0.5)
card.BackgroundColor3 = DARK_BG
card.BackgroundTransparency = 1
card.BorderSizePixel = 0
card.ClipsDescendants = true
card.Parent = loaderGui

local cornerRadius = Instance.new("UICorner")
cornerRadius.CornerRadius = UDim.new(0, 12)
cornerRadius.Parent = card

local stroke = Instance.new("UIStroke")
stroke.Color = BORDER_COL
stroke.Thickness = 1
stroke.Transparency = 1
stroke.Parent = card

local bottomBar = Instance.new("Frame")
bottomBar.Size = UDim2.new(0, 0, 0, 2)
bottomBar.Position = UDim2.new(0, 0, 1, -2)
bottomBar.BackgroundColor3 = RED
bottomBar.BorderSizePixel = 0
bottomBar.Parent = card

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 80)
title.Position = UDim2.new(0, 0, 0, 28)
title.BackgroundTransparency = 1
title.Text = "SANTES"
title.TextColor3 = WHITE
title.TextTransparency = 1
title.Font = Enum.Font.Impact
title.TextSize = 68
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = card

local divider = Instance.new("Frame")
divider.Size = UDim2.new(0, 200, 0, 1)
divider.Position = UDim2.new(0.5, 0, 0, 112)
divider.AnchorPoint = Vector2.new(0.5, 0)
divider.BackgroundColor3 = RED
divider.BorderSizePixel = 0
divider.Parent = card

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1, 0, 0, 22)
sub.Position = UDim2.new(0, 0, 0, 120)
sub.BackgroundTransparency = 1
sub.Text = "H  U  B"
sub.TextColor3 = RED_DIM
sub.TextTransparency = 1
sub.Font = Enum.Font.GothamBold
sub.TextSize = 13
sub.TextXAlignment = Enum.TextXAlignment.Center
sub.Parent = card

local SPINNER_R, SPINNER_SEG = 24, 28
local SPINNER_CX, SPINNER_CY = CARD_W / 2, 172
local spinnerParts = {}
local spinConn

for i = 1, SPINNER_SEG do
    local angle = (i / SPINNER_SEG) * math.pi * 2
    local x = SPINNER_CX + math.cos(angle) * SPINNER_R
    local y = SPINNER_CY + math.sin(angle) * SPINNER_R
    local alpha = (i / SPINNER_SEG) ^ 2

    local seg = Instance.new("Frame")
    seg.Size = UDim2.new(0, 4, 0, 4)
    seg.Position = UDim2.new(0, x - 2, 0, y - 2)
    seg.BackgroundColor3 = RED
    seg.BackgroundTransparency = 1
    seg.BorderSizePixel = 0
    seg.Parent = card
    
    local segCorner = Instance.new("UICorner")
    segCorner.CornerRadius = UDim.new(1, 0)
    segCorner.Parent = seg

    table.insert(spinnerParts, { frame = seg, baseAngle = angle, alpha = alpha })
end

for i = 1, 36 do
    local angle = (i / 36) * math.pi * 2
    local x = SPINNER_CX + math.cos(angle) * SPINNER_R
    local y = SPINNER_CY + math.sin(angle) * SPINNER_R
    local t = Instance.new("Frame")
    t.Size = UDim2.new(0, 2, 0, 2)
    t.Position = UDim2.new(0, x - 1, 0, y - 1)
    t.BackgroundColor3 = RED_FAINT
    t.BackgroundTransparency = 0.7
    t.BorderSizePixel = 0
    t.Parent = card
    
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = t
end

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, 0, 0, 18)
statusLbl.Position = UDim2.new(0, 0, 0, 214)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "BASLATILIYOR..."
statusLbl.TextColor3 = Color3.fromRGB(55, 55, 55)
statusLbl.TextTransparency = 1
statusLbl.Font = Enum.Font.GothamBold
statusLbl.TextSize = 11
statusLbl.TextXAlignment = Enum.TextXAlignment.Center
statusLbl.Parent = card

local playBtn = Instance.new("TextButton")
playBtn.Size = UDim2.new(1, -60, 0, 42)
playBtn.Position = UDim2.new(0, 30, 0, 248)
playBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
playBtn.BorderSizePixel = 0
playBtn.Text = "OYNA"
playBtn.TextColor3 = RED
playBtn.TextTransparency = 1
playBtn.Font = Enum.Font.Impact
playBtn.TextSize = 26
playBtn.AutoButtonColor = false
playBtn.Visible = false
playBtn.Parent = card

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 21)
btnCorner.Parent = playBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = RED
btnStroke.Thickness = 1
btnStroke.Transparency = 1
btnStroke.Parent = playBtn

playBtn.MouseEnter:Connect(function()
    TweenService:Create(playBtn, TweenInfo.new(0.18), { BackgroundColor3 = RED }):Play()
    TweenService:Create(playBtn, TweenInfo.new(0.18), { TextColor3 = Color3.fromRGB(255, 255, 255) }):Play()
end)
playBtn.MouseLeave:Connect(function()
    TweenService:Create(playBtn, TweenInfo.new(0.18), { BackgroundColor3 = Color3.fromRGB(12, 12, 12) }):Play()
    TweenService:Create(playBtn, TweenInfo.new(0.18), { TextColor3 = RED }):Play()
end)

local function tweenObj(obj, props, dur, style, dir)
    TweenService:Create(obj, TweenInfo.new(dur or 0.55, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
end

local function openAll()
    tweenObj(card, { BackgroundTransparency = 0 }, 0.55)
    tweenObj(stroke, { Transparency = 0.5 }, 0.55)
    tweenObj(title, { TextTransparency = 0 }, 0.55)
    tweenObj(sub, { TextTransparency = 0 }, 0.55)
    tweenObj(statusLbl, { TextTransparency = 0 }, 0.55)
    for _, s in ipairs(spinnerParts) do
        tweenObj(s.frame, { BackgroundTransparency = 1 - s.alpha }, 0.55)
    end
end

local function closeAll(callback)
    tweenObj(card, { BackgroundTransparency = 1 }, 0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    tweenObj(stroke, { Transparency = 1 }, 0.4)
    tweenObj(title, { TextTransparency = 1 }, 0.4)
    tweenObj(sub, { TextTransparency = 1 }, 0.4)
    tweenObj(statusLbl, { TextTransparency = 1 }, 0.4)
    tweenObj(playBtn, { TextTransparency = 1 }, 0.4)
    tweenObj(btnStroke, { Transparency = 1 }, 0.4)
    for _, s in ipairs(spinnerParts) do
        tweenObj(s.frame, { BackgroundTransparency = 1 }, 0.4)
    end
    task.wait(0.45)
    if spinConn then spinConn:Disconnect() end
    loaderGui:Destroy()
    if callback then callback() end
end

playBtn.MouseButton1Click:Connect(function()
    playBtn.Active = false
    closeAll(function()
        loadMainUI()
    end)
end)

local spinOffset = 0
spinConn = RunService.RenderStepped:Connect(function(dt)
    spinOffset = spinOffset + dt * 2.8
    for i, s in ipairs(spinnerParts) do
        local angle = s.baseAngle + spinOffset
        local x = SPINNER_CX + math.cos(angle) * SPINNER_R
        local y = SPINNER_CY + math.sin(angle) * SPINNER_R
        s.frame.Position = UDim2.new(0, x - 2, 0, y - 2)
        local rel = ((i / SPINNER_SEG) - (spinOffset / (math.pi * 2)) % 1 + 1) % 1
        if rel * rel > 0.92 then
            s.frame.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        elseif rel * rel > 0.6 then
            s.frame.BackgroundColor3 = RED
        else
            s.frame.BackgroundColor3 = RED_DIM
        end
    end
end)

local function runMessages()
    for i, msg in ipairs(LOAD_MESSAGES) do
        tweenObj(statusLbl, { TextTransparency = 1 }, 0.15)
        task.wait(0.17)
        statusLbl.Text = msg
        tweenObj(statusLbl, { TextTransparency = 0 }, 0.15)
        if i < #LOAD_MESSAGES then
            task.wait(0.9)
        else
            task.wait(0.4)
            playBtn.Visible = true
            playBtn.TextTransparency = 1
            btnStroke.Transparency = 1
            tweenObj(playBtn, { TextTransparency = 0 }, 0.35)
            tweenObj(btnStroke, { Transparency = 0 }, 0.35)
            tweenObj(bottomBar, { Size = UDim2.new(1, 0, 0, 2) }, 0.3)
        end
    end
end

task.spawn(function()
    tweenObj(bottomBar, { Size = UDim2.new(0.85, 0, 0, 2) }, #LOAD_MESSAGES * 0.9 - 0.3, Enum.EasingStyle.Linear)
    openAll()
    task.wait(0.6)
    runMessages()
end)

-- #####################################################################
-- #                    SANTES HUB v3.0 - MAIN UI                     #
-- #####################################################################

function loadMainUI()
    print("Loading Main UI...")
    
    local function tween(obj, props, dur, style, dir)
        TweenService:Create(obj, TweenInfo.new(dur or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
    end

    local function addCorner(parent, r)
        local uc = Instance.new("UICorner")
        uc.CornerRadius = UDim.new(0, r or 10)
        uc.Parent = parent
        return uc
    end

    local function addStroke(parent, col, thick, transp)
        local s = Instance.new("UIStroke")
        s.Color = col or C.border
        s.Thickness = thick or 1
        s.Transparency = transp or 0
        s.Parent = parent
        return s
    end

    -- ANA GUI
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
    overlay.Parent = mainGui

    -- Ana pencere
    local WIN_W, WIN_H = 600, 480
    local win = Instance.new("Frame")
    win.Size = UDim2.new(0, WIN_W, 0, WIN_H)
    win.Position = UDim2.new(0.5, 0, 0.5, 0)
    win.AnchorPoint = Vector2.new(0.5, 0.5)
    win.BackgroundColor3 = C.bg
    win.BorderSizePixel = 0
    win.ClipsDescendants = true
    win.Parent = mainGui
    addCorner(win, 14)
    addStroke(win, C.border, 1)

    -- Pencere glow efekti
    local winGlow = Instance.new("Frame")
    winGlow.Size = UDim2.new(1, 40, 1, 40)
    winGlow.Position = UDim2.new(0, -20, 0, -20)
    winGlow.BackgroundColor3 = C.accentGlow
    winGlow.BackgroundTransparency = 0.93
    winGlow.BorderSizePixel = 0
    winGlow.Parent = mainGui
    addCorner(winGlow, 18)

    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 56)
    titleBar.BackgroundColor3 = C.panel
    titleBar.BorderSizePixel = 0
    titleBar.Parent = win

    local titleAccent = Instance.new("Frame")
    titleAccent.Size = UDim2.new(0, 4, 1, 0)
    titleAccent.BackgroundColor3 = C.accent
    titleAccent.BorderSizePixel = 0
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
    hubTag.Parent = titleBar
    addCorner(hubTag, 4)

    local verLabel = Instance.new("TextLabel")
    verLabel.Size = UDim2.new(0, 70, 1, 0)
    verLabel.Position = UDim2.new(0, 152, 0, 0)
    verLabel.BackgroundTransparency = 1
    verLabel.Text = "v3.0"
    verLabel.Font = Enum.Font.Gotham
    verLabel.TextSize = 11
    verLabel.TextColor3 = C.textMuted
    verLabel.TextXAlignment = Enum.TextXAlignment.Left
    verLabel.Parent = titleBar

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
        btn.Parent = titleBar
        addCorner(btn, 8)
        return btn
    end

    local minimizeBtn = makeWindowBtn(-80, "—", C.card)
    local closeBtn = makeWindowBtn(-42, "✕", C.accent)

    local function addHover(btn, normalBg, hoverBg)
        btn.MouseEnter:Connect(function() tween(btn, { BackgroundColor3 = hoverBg }, 0.18) end)
        btn.MouseLeave:Connect(function() tween(btn, { BackgroundColor3 = normalBg }, 0.18) end)
    end
    addHover(minimizeBtn, C.card, C.cardHover)
    addHover(closeBtn, C.accent, C.accentBright)

    local titleLine = Instance.new("Frame")
    titleLine.Size = UDim2.new(1, 0, 0, 1)
    titleLine.Position = UDim2.new(0, 0, 0, 56)
    titleLine.BackgroundColor3 = C.border
    titleLine.BorderSizePixel = 0
    titleLine.Parent = win

    -- Sidebar
    local SIDEBAR_W = 158
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, -57)
    sidebar.Position = UDim2.new(0, 0, 0, 57)
    sidebar.BackgroundColor3 = C.panel
    sidebar.BorderSizePixel = 0
    sidebar.Parent = win

    local sidebarLine = Instance.new("Frame")
    sidebarLine.Size = UDim2.new(0, 1, 1, -57)
    sidebarLine.Position = UDim2.new(0, SIDEBAR_W, 0, 57)
    sidebarLine.BackgroundColor3 = C.border
    sidebarLine.BorderSizePixel = 0
    sidebarLine.Parent = win

    local sidebarInner = Instance.new("Frame")
    sidebarInner.Size = UDim2.new(1, 0, 1, 0)
    sidebarInner.BackgroundTransparency = 1
    sidebarInner.Parent = sidebar

    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, 14)
    sidebarPadding.PaddingBottom = UDim.new(0, 14)
    sidebarPadding.PaddingLeft = UDim.new(0, 10)
    sidebarPadding.PaddingRight = UDim.new(0, 10)
    sidebarPadding.Parent = sidebarInner

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 6)
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarLayout.Parent = sidebarInner

    local sideFooter = Instance.new("Frame")
    sideFooter.Size = UDim2.new(1, 0, 0, 52)
    sideFooter.Position = UDim2.new(0, 0, 1, -52)
    sideFooter.BackgroundColor3 = C.card
    sideFooter.BorderSizePixel = 0
    sideFooter.Parent = sidebar

    local sideFooterLine = Instance.new("Frame")
    sideFooterLine.Size = UDim2.new(1, 0, 0, 1)
    sideFooterLine.BackgroundColor3 = C.border
    sideFooterLine.BorderSizePixel = 0
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
    contentArea.Parent = win

    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 16)
    contentPadding.PaddingBottom = UDim.new(0, 16)
    contentPadding.PaddingLeft = UDim.new(0, 16)
    contentPadding.PaddingRight = UDim.new(0, 16)
    contentPadding.Parent = contentArea

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 12)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.Parent = contentArea

    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentArea.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 32)
    end)

    -- SAYFA SISTEMI
    local pages = {}
    local activeTab = nil
    local activeTabName = nil
    local pageContent = {}

    local function clearContent()
        for _, c in pairs(contentArea:GetChildren()) do
            if c:IsA("Frame") or c:IsA("TextLabel") or c:IsA("TextButton") then
                c:Destroy()
            end
        end
    end

    local function switchPage(name)
        if activeTabName == name then return end
        activeTabName = name

        if activeTab then
            tween(activeTab.bg, { BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 1 }, 0.2)
            tween(activeTab.lbl, { TextColor3 = C.textMuted }, 0.2)
            tween(activeTab.bar, { BackgroundTransparency = 1 }, 0.2)
        end

        local tab = pages[name]
        if tab then
            tween(tab.bg, { BackgroundColor3 = C.card, BackgroundTransparency = 0 }, 0.2)
            tween(tab.lbl, { TextColor3 = C.accent }, 0.2)
            tween(tab.bar, { BackgroundTransparency = 0 }, 0.2)
            activeTab = tab
        end

        clearContent()
        if pageContent[name] then
            pageContent[name]()
        end
        contentArea.CanvasPosition = Vector2.new(0, 0)
    end

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
        btn.Parent = sidebarInner

        local tabBg = Instance.new("Frame")
        tabBg.Size = UDim2.new(1, 0, 1, 0)
        tabBg.BackgroundColor3 = C.card
        tabBg.BackgroundTransparency = 1
        tabBg.BorderSizePixel = 0
        tabBg.Parent = btn
        addCorner(tabBg, 8)

        local tabBar = Instance.new("Frame")
        tabBar.Size = UDim2.new(0, 4, 0.6, 0)
        tabBar.Position = UDim2.new(0, 0, 0.2, 0)
        tabBar.BackgroundColor3 = C.accent
        tabBar.BackgroundTransparency = 1
        tabBar.BorderSizePixel = 0
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
        nameLbl.Parent = btn

        local tabData = { bg = tabBg, lbl = nameLbl, bar = tabBar, icon = iconLbl }
        pages[name] = tabData

        btn.MouseEnter:Connect(function()
            if activeTabName ~= name then
                tween(tabBg, { BackgroundTransparency = 0.6 }, 0.15)
                tween(nameLbl, { TextColor3 = C.textSub }, 0.15)
            end
        end)
        btn.MouseLeave:Connect(function()
            if activeTabName ~= name then
                tween(tabBg, { BackgroundTransparency = 1 }, 0.15)
                tween(nameLbl, { TextColor3 = C.textMuted }, 0.15)
            end
        end)
        btn.MouseButton1Click:Connect(function()
            switchPage(name)
        end)

        return tabData
    end

    -- ICERIK ELEMANLARI
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
        lbl.Parent = contentArea
        return lbl
    end

    local function makeCard(height, order)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -32, 0, height)
        f.BackgroundColor3 = C.card
        f.BorderSizePixel = 0
        f.LayoutOrder = order or 0
        f.Parent = contentArea
        addCorner(f, 10)
        addStroke(f, C.border, 1, 0.5)
        return f
    end

    local function makeRow(parent, label, value, valColor, yPos)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -24, 0, 34)
        row.Position = UDim2.new(0, 12, 0, yPos or 0)
        row.BackgroundTransparency = 1
        row.Parent = parent

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.5, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextColor3 = C.textMuted
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local valLbl = Instance.new("TextLabel")
        valLbl.Size = UDim2.new(0.5, 0, 1, 0)
        valLbl.Position = UDim2.new(0.5, 0, 0, 0)
        valLbl.BackgroundTransparency = 1
        valLbl.Text = value
        valLbl.Font = Enum.Font.GothamBold
        valLbl.TextSize = 12
        valLbl.TextColor3 = valColor or C.textPrimary
        valLbl.TextXAlignment = Enum.TextXAlignment.Right
        valLbl.Parent = row

        return row
    end

    local function makeDivider(parent, yPos)
        local d = Instance.new("Frame")
        d.Size = UDim2.new(1, -24, 0, 1)
        d.Position = UDim2.new(0, 12, 0, yPos)
        d.BackgroundColor3 = C.border
        d.BorderSizePixel = 0
        d.Parent = parent
    end

    local function makeToggle(parent, labelText, defaultOn, yPos, callback)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -24, 0, 44)
        row.Position = UDim2.new(0, 12, 0, yPos or 0)
        row.BackgroundTransparency = 1
        row.Parent = parent

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.65, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextColor3 = C.textSub
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local track = Instance.new("Frame")
        track.Size = UDim2.new(0, 46, 0, 24)
        track.Position = UDim2.new(1, -46, 0.5, -12)
        track.BackgroundColor3 = defaultOn and C.accent or C.border
        track.BorderSizePixel = 0
        track.Parent = row
        addCorner(track, 12)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 18, 0, 18)
        knob.Position = defaultOn and UDim2.new(0, 24, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)
        knob.BackgroundColor3 = C.textPrimary
        knob.BorderSizePixel = 0
        knob.Parent = track
        addCorner(knob, 9)

        local isOn = defaultOn or false
        local clickArea = Instance.new("TextButton")
        clickArea.Size = UDim2.new(1, 0, 1, 0)
        clickArea.BackgroundTransparency = 1
        clickArea.Text = ""
        clickArea.Parent = row

        clickArea.MouseButton1Click:Connect(function()
            isOn = not isOn
            tween(track, { BackgroundColor3 = isOn and C.accent or C.border }, 0.2)
            tween(knob, { Position = isOn and UDim2.new(0, 24, 0.5, -9) or UDim2.new(0, 4, 0.5, -9) }, 0.2)
            if callback then callback(isOn) end
        end)

        return row
    end

    -- #####################################################################
    -- #                         MODULES (TÜM ÖZELLİKLER)                  #
    -- #####################################################################

    -- FLY MODULE
    local flyEnabled = false
    local flyConn = nil
    local flySpeed = 70
    function Fly_Enable()
        if flyEnabled then return end
        flyEnabled = true
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.Velocity = Vector3.new(0, 30, 0) end
        end
        flyConn = RunService.Heartbeat:Connect(function(dt)
            if not flyEnabled then return end
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then return end
            hum.PlatformStand = true
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    pcall(function()
                        part.AssemblyLinearVelocity = Vector3.zero
                        part.Velocity = Vector3.zero
                    end)
                end
            end
            local cam = workspace.CurrentCamera
            if not cam then return end
            local targetVel = Vector3.new()
            local forward = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z).Unit
            local right = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z).Unit
            local md = hum.MoveDirection
            if md.Magnitude > 0.1 then
                targetVel += md * flySpeed
            else
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then targetVel += forward * flySpeed end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then targetVel -= forward * flySpeed end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then targetVel -= right * flySpeed end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then targetVel += right * flySpeed end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then targetVel = targetVel + Vector3.new(0, flySpeed, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then targetVel = targetVel - Vector3.new(0, flySpeed, 0) end
            end
            if targetVel.Magnitude < 1 then
                hrp.Velocity = Vector3.new(0, 0.3, 0)
                pcall(function() hrp.AssemblyLinearVelocity = Vector3.zero end)
            else
                hrp.Velocity = targetVel
                pcall(function() hrp.AssemblyLinearVelocity = targetVel end)
            end
        end)
    end
    function Fly_Disable()
        flyEnabled = false
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
        end
    end

    -- NOCLIP MODULE
    local noclipEnabled = false
    local noclipConn = nil
    function Noclip_Enable()
        if noclipEnabled then return end
        noclipEnabled = true
        noclipConn = RunService.RenderStepped:Connect(function()
            if noclipEnabled and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then 
                        pcall(function() part.CanCollide = false end)
                    end
                end
            end
        end)
    end
    function Noclip_Disable()
        noclipEnabled = false
        if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    end

    -- FULLBRIGHT MODULE
    local fullbrightEnabled = false
    local fullbrightConn = nil
    local origLighting = {}
    function FullBright_Enable()
        if fullbrightEnabled then return end
        fullbrightEnabled = true
        origLighting = {
            Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
            Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
            FogStart = Lighting.FogStart, FogEnd = Lighting.FogEnd
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
        if fullbrightConn then fullbrightConn:Disconnect(); fullbrightConn = nil end
        if origLighting.Brightness then
            Lighting.Brightness = origLighting.Brightness
            Lighting.ClockTime = origLighting.ClockTime
            Lighting.Ambient = origLighting.Ambient
            Lighting.OutdoorAmbient = origLighting.OutdoorAmbient
            Lighting.FogStart = origLighting.FogStart
            Lighting.FogEnd = origLighting.FogEnd
        end
    end

    -- FOV MODULE
    local fovEnabled = false
    local fovVal = 80
    local fovOrig = 70
    function FOV_Enable()
        fovEnabled = true
        if workspace.CurrentCamera then fovOrig = workspace.CurrentCamera.FieldOfView end
    end
    function FOV_Disable()
        fovEnabled = false
        if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = fovOrig end
    end
    RunService.RenderStepped:Connect(function()
        if fovEnabled and workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = fovVal end
    end)

    -- NO FAIL LOCKPICK MODULE
    local noFailLPEnabled = false
    local noFailLPConn = nil
    function NoFailLP_Enable()
        if noFailLPEnabled then return end
        noFailLPEnabled = true
        noFailLPConn = PlayerGui.ChildAdded:Connect(function(item)
            if item.Name == "LockpickGUI" then
                local mf = item:FindFirstChild("MF")
                if mf then
                    local lpf = mf:FindFirstChild("LP_Frame")
                    if lpf then
                        local frames = lpf:FindFirstChild("Frames")
                        if frames then
                            for _, bn in pairs({"B1", "B2", "B3"}) do
                                local bar = frames:FindFirstChild(bn)
                                if bar and bar:FindFirstChild("Bar") then
                                    local uis = bar.Bar:FindFirstChild("UIScale")
                                    if uis then uis.Scale = 10 end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
    function NoFailLP_Disable()
        noFailLPEnabled = false
        if noFailLPConn then noFailLPConn:Disconnect(); noFailLPConn = nil end
    end

    -- SAFE ESP MODULE
    local safeESPEnabled = false
    local safeESPConn = nil
    local safeTimerData = {}
    local SAFE_RESPAWN_TIMES = {
        SmallSafe = 180, MediumSafe = 300, LargeSafe = 420,
        Register = 120, Register_M = 150, Register_L = 180, Default = 240
    }
    local function getSafeRespawnTime(safeName)
        for pattern, time in pairs(SAFE_RESPAWN_TIMES) do
            if string.find(safeName, pattern) then return time end
        end
        return SAFE_RESPAWN_TIMES.Default
    end
    local function formatTime(seconds)
        if seconds <= 0 then return "Ready" end
        local minutes = math.floor(seconds / 60)
        local secs = math.floor(seconds % 60)
        return string.format("%dm %ds", minutes, secs)
    end
    local function safeESPUpdate()
        local folder = Workspace.Map and Workspace.Map:FindFirstChild("BredMakurz")
        if not folder then folder = Workspace:FindFirstChild("BredMakurz") end
        if not folder then return end
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local myPos = char.HumanoidRootPart.Position
        local now = tick()
        for _, obj in pairs(folder:GetChildren()) do
            local part = obj.PrimaryPart or obj:FindFirstChild("MainPart") or obj:FindFirstChildOfClass("BasePart")
            if part then
                local dist = (part.Position - myPos).magnitude
                local exist = obj:FindFirstChild("SantesSE")
                local values = obj:FindFirstChild("Values")
                local broken = values and values:FindFirstChild("Broken")
                if dist <= 250 then
                    if not exist then
                        local bg = Instance.new("BillboardGui")
                        bg.Name = "SantesSE"
                        bg.AlwaysOnTop = true
                        bg.Size = UDim2.new(0, 140, 0, 35)
                        bg.MaxDistance = 250
                        bg.Adornee = obj
                        bg.Parent = obj
                        local tl = Instance.new("TextLabel", bg)
                        tl.Size = UDim2.new(1, 0, 0.5, 0)
                        tl.BackgroundTransparency = 1
                        tl.Font = Enum.Font.SourceSansBold
                        tl.TextSize = 13
                        tl.Text = obj.Name:gsub("([a-z])([A-Z])", "%1 %2"):gsub("_.*", "")
                        local timerLabel = Instance.new("TextLabel", bg)
                        timerLabel.Size = UDim2.new(1, 0, 0.5, 0)
                        timerLabel.Position = UDim2.new(0, 0, 0.5, 0)
                        timerLabel.BackgroundTransparency = 1
                        timerLabel.Font = Enum.Font.Gotham
                        timerLabel.TextSize = 11
                        if broken and broken:IsA("BoolValue") then
                            if broken.Value then
                                tl.TextColor3 = Color3.new(1, 0, 0)
                                local respawnTime = getSafeRespawnTime(obj.Name)
                                timerLabel.Text = formatTime(respawnTime)
                                timerLabel.TextColor3 = Color3.new(1, 0.6, 0)
                                safeTimerData[obj] = { brokenTime = now, respawnTime = respawnTime, label = timerLabel, nameLabel = tl }
                            else
                                tl.TextColor3 = Color3.new(0, 1, 0)
                                timerLabel.Text = "Ready"
                                timerLabel.TextColor3 = Color3.new(0, 1, 0)
                                safeTimerData[obj] = nil
                            end
                            broken:GetPropertyChangedSignal("Value"):Connect(function()
                                if broken.Value then
                                    tl.TextColor3 = Color3.new(1, 0, 0)
                                    local rt = getSafeRespawnTime(obj.Name)
                                    timerLabel.Text = formatTime(rt)
                                    timerLabel.TextColor3 = Color3.new(1, 0.6, 0)
                                    safeTimerData[obj] = { brokenTime = tick(), respawnTime = rt, label = timerLabel, nameLabel = tl }
                                else
                                    tl.TextColor3 = Color3.new(0, 1, 0)
                                    timerLabel.Text = "Ready"
                                    timerLabel.TextColor3 = Color3.new(0, 1, 0)
                                    safeTimerData[obj] = nil
                                end
                            end)
                        else
                            tl.TextColor3 = Color3.new(0, 1, 0)
                            timerLabel.Text = "Ready"
                            timerLabel.TextColor3 = Color3.new(0, 1, 0)
                        end
                    end
                elseif exist then
                    exist:Destroy()
                    safeTimerData[obj] = nil
                end
            end
        end
        for obj, data in pairs(safeTimerData) do
            if data and data.label and data.label.Parent then
                local remaining = data.respawnTime - (now - data.brokenTime)
                if remaining > 0 then
                    data.label.Text = formatTime(remaining)
                else
                    data.label.Text = "Ready"
                    data.label.TextColor3 = Color3.new(0, 1, 0)
                    if data.nameLabel then data.nameLabel.TextColor3 = Color3.new(0, 1, 0) end
                end
            end
        end
    end
    function SafeESP_Enable()
        if safeESPEnabled then return end
        safeESPEnabled = true
        safeTimerData = {}
        safeESPConn = RunService.Heartbeat:Connect(safeESPUpdate)
    end
    function SafeESP_Disable()
        safeESPEnabled = false
        if safeESPConn then safeESPConn:Disconnect(); safeESPConn = nil end
        local folder = Workspace.Map and Workspace.Map:FindFirstChild("BredMakurz")
        if not folder then folder = Workspace:FindFirstChild("BredMakurz") end
        if folder then
            for _, obj in pairs(folder:GetChildren()) do
                local esp = obj:FindFirstChild("SantesSE")
                if esp then esp:Destroy() end
            end
        end
        safeTimerData = {}
    end

    -- AUTO LOCKPICK MODULE
    local autoLockpickEnabled = false
    local autoLockpickConn = nil
    local lockpickCD = false
    local lastOpenedSafe = nil
    function AutoLockpick_Enable()
        if autoLockpickEnabled then return end
        autoLockpickEnabled = true
        autoLockpickConn = RunService.Heartbeat:Connect(function()
            if not autoLockpickEnabled or lockpickCD then return end
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local lockpickTool = char:FindFirstChild("Lockpick")
            if not lockpickTool then
                local bp = LocalPlayer:FindFirstChild("Backpack")
                if bp then
                    for _, item in pairs(bp:GetChildren()) do
                        if item.Name == "Lockpick" then
                            lockpickTool = item
                            break
                        end
                    end
                end
            end
            if not lockpickTool then return end
            if not char:FindFirstChild(lockpickTool.Name) then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(lockpickTool) end) end
                return
            end
            local folder = Workspace.Map and Workspace.Map:FindFirstChild("BredMakurz")
            if not folder then folder = Workspace:FindFirstChild("BredMakurz") end
            if not folder then return end
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
            if not nearestSafe then return end
            lockpickCD = true
            lastOpenedSafe = nearestSafe
            local events = ReplicatedStorage:FindFirstChild("Events")
            if events then
                local r1 = events:FindFirstChild("XMHH.2")
                local r2 = events:FindFirstChild("XMHH2.2")
                if r1 and r2 and nearestMainPart then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        local result = r1:InvokeServer("\240\159\141\158", tick(), tool, "DZDRRRKI", nearestSafe, "Register")
                        if result then
                            r2:FireServer("\240\159\141\158", tick(), tool, "2389ZFX34", result, false, char:FindFirstChild("Right Arm") or hrp, nearestMainPart, nearestSafe, nearestMainPart.Position, nearestMainPart.Position)
                        end
                    end
                end
                local lockpickEvent = events:FindFirstChild("LockpickStart")
                if lockpickEvent and nearestMainPart then
                    pcall(function() lockpickEvent:FireServer(nearestSafe, nearestMainPart) end)
                end
            end
            task.wait(0.05)
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                local lockpickGUI = playerGui:FindFirstChild("LockpickGUI")
                if lockpickGUI then
                    for attempt = 1, 30 do
                        pcall(function()
                            local frames = lockpickGUI.MF and lockpickGUI.MF.LP_Frame and lockpickGUI.MF.LP_Frame.Frames
                            if frames then
                                for _, bn in pairs({"B1", "B2", "B3"}) do
                                    local bar = frames:FindFirstChild(bn)
                                    if bar and bar:FindFirstChild("Bar") then
                                        local uis = bar.Bar:FindFirstChild("UIScale")
                                        if uis then uis.Scale = 20 end
                                    end
                                end
                            end
                        end)
                        if not lockpickGUI.Parent then break end
                        task.wait(0.02)
                    end
                end
            end
            task.wait(0.3)
            lockpickCD = false
        end)
    end
    function AutoLockpick_Disable()
        autoLockpickEnabled = false
        lockpickCD = false
        lastOpenedSafe = nil
        if autoLockpickConn then autoLockpickConn:Disconnect(); autoLockpickConn = nil end
    end

    -- AUTO PICKUP MODULE
    local autoPickupEnabled = false
    local autoPickupConn = nil
    local pickupCD = false
    function AutoPickup_Enable()
        if autoPickupEnabled then return end
        autoPickupEnabled = true
        autoPickupConn = RunService.RenderStepped:Connect(function()
            if not autoPickupEnabled or pickupCD then return end
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local hrp = char.HumanoidRootPart
            local folder = Workspace.Filter and Workspace.Filter:FindFirstChild("SpawnedBread")
            if not folder then folder = Workspace:FindFirstChild("SpawnedBread") end
            if not folder then return end
            local remote = ReplicatedStorage.Events and ReplicatedStorage.Events:FindFirstChild("CZDPZUS")
            if not remote then return end
            for _, bread in pairs(folder:GetChildren()) do
                if bread:IsA("BasePart") and (hrp.Position - bread.Position).Magnitude < 5 then
                    pickupCD = true
                    pcall(function() remote:FireServer(bread) end)
                    task.wait(1)
                    pickupCD = false
                    break
                end
            end
        end)
    end
    function AutoPickup_Disable()
        autoPickupEnabled = false
        pickupCD = false
        if autoPickupConn then autoPickupConn:Disconnect(); autoPickupConn = nil end
    end

    -- UNLOCK DOORS MODULE
    local unlockDoorsEnabled = false
    local unlockDoorsConn = nil
    function UnlockDoors_Enable()
        if unlockDoorsEnabled then return end
        unlockDoorsEnabled = true
        unlockDoorsConn = RunService.Heartbeat:Connect(function()
            if not unlockDoorsEnabled then return end
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local hrp = char.HumanoidRootPart
            local doors = Workspace.Map and Workspace.Map:FindFirstChild("Doors")
            if not doors then return end
            for _, door in pairs(doors:GetChildren()) do
                local doorBase = door:FindFirstChild("DoorBase")
                if doorBase and (hrp.Position - doorBase.Position).Magnitude <= 6 then
                    local values = door:FindFirstChild("Values")
                    local events = door:FindFirstChild("Events")
                    if values and events then
                        local toggle = events:FindFirstChild("Toggle")
                        if toggle then
                            local locked = values:FindFirstChild("Locked")
                            local lockPart = door:FindFirstChild("Lock")
                            if locked and lockPart and locked.Value == true then
                                pcall(function() toggle:FireServer("Unlock", lockPart) end)
                            end
                            local openVal = values:FindFirstChild("Open")
                            local knob = door:FindFirstChild("Knob2") or door:FindFirstChild("Knob")
                            if openVal and knob and openVal.Value == false then
                                pcall(function() toggle:FireServer("Open", knob) end)
                            end
                        end
                    end
                end
            end
        end)
    end
    function UnlockDoors_Disable()
        unlockDoorsEnabled = false
        if unlockDoorsConn then unlockDoorsConn:Disconnect(); unlockDoorsConn = nil end
    end

    -- ADMIN CHECK MODULE
    local adminCheckEnabled = false
    local adminCheckConn = nil
    local staffUsers = {
        3294804378, 93676120, 54087314, 81275825, 140837601, 1229486091,
        46567801, 418086275, 29706395, 3717066084, 1424338327, 5046662686
    }
    local function checkStaff(player)
        if player == LocalPlayer then return false end
        for _, uid in pairs(staffUsers) do
            if player.UserId == uid then
                pcall(function() LocalPlayer:Kick("SANTES: Staff detected - " .. player.Name) end)
                return true
            end
        end
        return false
    end
    function AdminCheck_Enable()
        if adminCheckEnabled then return end
        adminCheckEnabled = true
        for _, player in pairs(Players:GetPlayers()) do
            if checkStaff(player) then return end
        end
        adminCheckConn = Players.PlayerAdded:Connect(checkStaff)
    end
    function AdminCheck_Disable()
        adminCheckEnabled = false
        if adminCheckConn then adminCheckConn:Disconnect(); adminCheckConn = nil end
    end

    -- ESP MODULE (Player ESP)
    local espEnabled = false
    local espConns = {}
    local espList = {}
    local function espCreate(player)
        if player == LocalPlayer or espList[player] then return end
        espList[player] = true
        local function setupESP(char)
            if not espEnabled or not char or not char.Parent then return end
            local highlight = Instance.new("Highlight")
            highlight.Name = "SantesESP"
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.FillTransparency = 0.65
            highlight.OutlineColor = Color3.fromRGB(255, 40, 40)
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = char
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
        if player.Character then setupESP(player.Character) end
        table.insert(espConns, player.CharacterAdded:Connect(setupESP))
    end
    function ESP_Enable()
        if espEnabled then return end
        espEnabled = true
        espList = {}
        for _, player in pairs(Players:GetPlayers()) do espCreate(player) end
        table.insert(espConns, Players.PlayerAdded:Connect(function(player) if espEnabled then espCreate(player) end end))
        table.insert(espConns, Players.PlayerRemoving:Connect(function(player) espList[player] = nil end))
    end
    function ESP_Disable()
        espEnabled = false
        for _, conn in pairs(espConns) do pcall(function() conn:Disconnect() end) end
        espConns = {}
        espList = {}
        for _, player in pairs(Players:GetPlayers()) do
            pcall(function()
                if player.Character then
                    local hl = player.Character:FindFirstChild("SantesESP")
                    if hl then hl:Destroy() end
                    for _, obj in pairs(player.Character:GetDescendants()) do
                        if obj:IsA("BillboardGui") and obj.Name == "SantesESPInfo" then obj:Destroy() end
                    end
                end
            end)
        end
    end

    -- INVIS MODULE
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
            return invisHum and invisHum:IsDescendantOf(Workspace) and invisHum.FloorMaterial ~= Enum.Material.Air
        end
        local function loadTrack()
            if invisTrack then pcall(function() invisTrack:Stop() end); invisTrack = nil end
            if invisHum then
                local s, r = pcall(function() return invisHum:LoadAnimation(anim) end)
                if s then invisTrack = r; invisTrack.Priority = Enum.AnimationPriority.Action4 end
            end
        end
        RunService.Heartbeat:Connect(function(dt)
            if not invisEnabled or not invisUsable then
                if not invisEnabled and invisChar then
                    for _, v in pairs(invisChar:GetDescendants()) do
                        if v:IsA("BasePart") and v.Transparency == 0.5 then v.Transparency = 0 end
                    end
                end
                if invisWarn then invisWarn.Visible = false end
                return
            end
            if not invisChar or not invisHum or not invisHRP or invisHum.Health <= 0 then
                if invisWarn then invisWarn.Visible = false end
                return
            end
            if invisWarn then invisWarn.Visible = not grounded() end
            if invisHum.MoveDirection.Magnitude > 0 then invisHRP.CFrame += invisHum.MoveDirection * 12 * dt end
            local oldCF = invisHRP.CFrame
            local oldOff = invisHum.CameraOffset
            local _, y = workspace.CurrentCamera.CFrame:ToOrientation()
            invisHRP.CFrame = CFrame.new(invisHRP.Position) * CFrame.fromOrientation(0, y, 0) * CFrame.Angles(math.rad(90), 0, 0)
            invisHum.CameraOffset = Vector3.new(0, 1.44, 0)
            if invisTrack then
                pcall(function()
                    if not invisTrack.IsPlaying then invisTrack:Play() end
                    invisTrack:AdjustSpeed(0)
                    invisTrack.TimePosition = 0.3
                end)
            elseif invisHum.Health > 0 then loadTrack() end
            RunService.RenderStepped:Wait()
            if invisHum:IsDescendantOf(Workspace) then invisHum.CameraOffset = oldOff end
            if invisHRP:IsDescendantOf(Workspace) then invisHRP.CFrame = oldCF end
            if invisTrack then pcall(function() invisTrack:Stop() end) end
            if invisHRP:IsDescendantOf(Workspace) then
                local lookVec = workspace.CurrentCamera.CFrame.LookVector
                local flat = Vector3.new(lookVec.X, 0, lookVec.Z).Unit
                if flat.Magnitude > 0.1 then invisHRP.CFrame = CFrame.new(invisHRP.Position, invisHRP.Position + flat) end
            end
            for _, v in pairs(invisChar:GetDescendants()) do
                if v:IsA("BasePart") and v.Transparency ~= 1 then v.Transparency = 0.5 end
            end
        end)
        LocalPlayer.CharacterAdded:Connect(function()
            if invisTrack then pcall(function() invisTrack:Stop() end); invisTrack = nil end
            task.wait()
            updateRefs()
            if invisHum and invisHum.RigType ~= Enum.HumanoidRigType.R6 then
                invisUsable = false
                if invisEnabled then Invis_Disable() end
            else
                invisUsable = true
                if invisEnabled then workspace.CurrentCamera.CameraSubject = invisHRP; loadTrack() end
            end
        end)
        updateRefs()
        if invisHum and invisHum.RigType ~= Enum.HumanoidRigType.R6 then invisUsable = false end
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
    end
    function Invis_Enable()
        if invisEnabled or not invisUsable then return end
        invisEnabled = true
        local invisChar = LocalPlayer.Character
        local invisHRP = invisChar and invisChar:FindFirstChild("HumanoidRootPart")
        if invisHRP then workspace.CurrentCamera.CameraSubject = invisHRP end
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://215384594"
        local invisHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if invisHum then
            local s, r = pcall(function() return invisHum:LoadAnimation(anim) end)
            if s then invisTrack = r; invisTrack.Priority = Enum.AnimationPriority.Action4 end
        end
    end
    function Invis_Disable()
        if not invisEnabled then return end
        invisEnabled = false
        if invisTrack then pcall(function() invisTrack:Stop() end); invisTrack = nil end
        local invisHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if invisHum then workspace.CurrentCamera.CameraSubject = invisHum end
        local invisChar = LocalPlayer.Character
        if invisChar then
            for _, v in pairs(invisChar:GetDescendants()) do
                if v:IsA("BasePart") and v.Transparency == 0.5 then v.Transparency = 0 end
            end
        end
        if invisWarn then invisWarn.Visible = false end
    end

    -- NO RECOIL MODULE
    local noRecoilEnabled = false
    function NoRecoil_Enable()
        if noRecoilEnabled then return end
        noRecoilEnabled = true
        task.spawn(function()
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
                                v.AngleX_Min = 0; v.AngleX_Max = 0
                                v.AngleY_Min = 0; v.AngleY_Max = 0
                                v.AngleZ_Min = 0; v.AngleZ_Max = 0
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
    end

    -- SILENT AIM MODULE
    local silentAimEnabled = false
    local silentAimConn = nil
    local silentAimFOV = 150
    function SilentAim_Enable()
        if silentAimEnabled then return end
        silentAimEnabled = true
        silentAimConn = RunService.RenderStepped:Connect(function()
            if not silentAimEnabled then return end
            local cam = workspace.CurrentCamera
            if not cam then return end
            local myChar = LocalPlayer.Character
            if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
            local screenCenter = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
            local closestPlayer = nil
            local closestDistance = silentAimFOV
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hum = player.Character:FindFirstChildOfClass("Humanoid")
                    local targetPart = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
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
            if closestPlayer and closestPlayer.Character then
                local targetPart = closestPlayer.Character:FindFirstChild("Head") or closestPlayer.Character:FindFirstChild("HumanoidRootPart")
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
        if silentAimConn then silentAimConn:Disconnect(); silentAimConn = nil end
        for _, player in pairs(Players:GetPlayers()) do
            pcall(function()
                if player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name == "SantesHitbox" then part:Destroy() end
                    end
                end
            end)
        end
    end
    function SilentAim_SetFOV(value) silentAimFOV = math.clamp(value, 50, 500) end
    function SilentAim_GetFOV() return silentAimFOV end

    -- MELEE AURA MODULE
    local meleeAuraEnabled = false
    local meleeAuraConn = nil
    local meleeTarget = "Head"
    function MeleeAura_Enable()
        if meleeAuraEnabled then return end
        meleeAuraEnabled = true
        local eventsFolder = ReplicatedStorage:FindFirstChild("Events")
        if not eventsFolder then return end
        local remote1 = eventsFolder:FindFirstChild("XMHH.2")
        local remote2 = eventsFolder:FindFirstChild("XMHH2.2")
        if not remote1 or not remote2 then return end
        meleeAuraConn = RunService.Heartbeat:Connect(function()
            if not meleeAuraEnabled then return end
            local myChar = LocalPlayer.Character
            if not myChar then return end
            local myHRP = myChar:FindFirstChild("HumanoidRootPart")
            if not myHRP then return end
            local tool = myChar:FindFirstChildOfClass("Tool")
            local closestEnemy = nil
            local shortestDist = 6
            for _, pl in pairs(Players:GetPlayers()) do
                if pl ~= LocalPlayer and pl.Character then
                    local enemyHRP = pl.Character:FindFirstChild("HumanoidRootPart")
                    local enemyHum = pl.Character:FindFirstChildOfClass("Humanoid")
                    if enemyHRP and enemyHum and enemyHum.Health > 15 and not pl.Character:FindFirstChildOfClass("ForceField") then
                        local dist = (myHRP.Position - enemyHRP.Position).Magnitude
                        if dist < shortestDist then shortestDist = dist; closestEnemy = pl end
                    end
                end
            end
            if not closestEnemy then return end
            local targetChar = closestEnemy.Character
            local targetPart = targetChar:FindFirstChild(meleeTarget)
            if not targetPart then return end
            local fakeTool = tool or myChar:FindFirstChild("Right Arm") or myHRP
            local result = remote1:InvokeServer("\240\159\141\158", tick(), fakeTool, "43TRFWX", "Normal", tick(), true)
            if result then
                local handle = (tool and (tool:FindFirstChild("WeaponHandle") or tool:FindFirstChild("Handle"))) or myChar:FindFirstChild("Right Arm")
                if handle then
                    remote2:FireServer("\240\159\141\158", tick(), fakeTool, "2389ZFX34", result, false, handle, targetPart, targetChar, myHRP.Position, targetPart.Position)
                end
            end
            task.wait(0.08)
        end)
    end
    function MeleeAura_Disable()
        meleeAuraEnabled = false
        if meleeAuraConn then meleeAuraConn:Disconnect(); meleeAuraConn = nil end
    end
    function MeleeAura_SetTarget(target)
        if target == "Head" or target == "Body" then
            meleeTarget = target == "Body" and "HumanoidRootPart" or "Head"
        end
    end
    function MeleeAura_GetTarget() return meleeTarget == "Head" and "Head" or "Body" end

    -- INFINITE STAMINA MODULE
    local infStaminaEnabled = false
    local infStaminaConn = nil
    function InfiniteStamina_Enable()
        if infStaminaEnabled then return end
        infStaminaEnabled = true
        infStaminaConn = RunService.RenderStepped:Connect(function()
            if not infStaminaEnabled then return end
            local char = LocalPlayer.Character
            if not char then return end
            for _, hum in pairs(char:GetDescendants()) do
                if hum:IsA("Humanoid") then
                    if hum.MaxStamina and hum.Stamina then hum.Stamina = hum.MaxStamina end
                end
            end
        end)
    end
    function InfiniteStamina_Disable()
        infStaminaEnabled = false
        if infStaminaConn then infStaminaConn:Disconnect(); infStaminaConn = nil end
    end

    -- AUTO FARM MODULE
    local autoFarmEnabled = false
    local autoFarmCoroutine = nil
    local farmProcessed = {}
    local farmTempIgnored = {}
    local ignoreDuration = 60
    local moveSpeed = 22
    local hasReachedTargetY = false
    local pathVisuals = {}
    local pathLines = {}

    local function clearPathVisuals()
        for _, v in pairs(pathVisuals) do pcall(function() v:Destroy() end) end
        for _, v in pairs(pathLines) do pcall(function() v:Destroy() end) end
        pathVisuals = {}
        pathLines = {}
    end

    local function drawPath(points)
        clearPathVisuals()
        if not points or #points < 2 then return end
        for i, pos in ipairs(points) do
            local part = Instance.new("Part")
            part.Size = Vector3.new(1, 1, 1)
            part.Position = pos
            part.Anchored = true
            part.CanCollide = false
            part.Material = Enum.Material.Neon
            part.BrickColor = BrickColor.new("Bright green")
            part.Transparency = 0.3
            part.Parent = workspace
            table.insert(pathVisuals, part)
        end
        for i = 1, #points - 1 do
            local p1, p2 = points[i], points[i + 1]
            local dist = (p2 - p1).Magnitude
            local line = Instance.new("Part")
            line.Size = Vector3.new(0.2, 0.2, dist)
            line.CFrame = CFrame.new(p1, p2) * CFrame.new(0, 0, -dist/2)
            line.Anchored = true
            line.CanCollide = false
            line.Material = Enum.Material.Neon
            line.BrickColor = BrickColor.new("Lime green")
            line.Transparency = 0.2
            line.Parent = workspace
            table.insert(pathLines, line)
        end
    end

    local function riseToTargetY()
        if hasReachedTargetY then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.Position.Y < 4.7 then
            local targetPos = Vector3.new(hrp.Position.X, 4.8, hrp.Position.Z)
            local tween = TweenService:Create(hrp, TweenInfo.new(1, Enum.EasingStyle.Quad), { CFrame = CFrame.new(targetPos) })
            tween:Play()
            tween.Completed:Wait()
            hrp.AssemblyLinearVelocity = Vector3.zero
            task.wait(2)
            hasReachedTargetY = true
        end
    end

    local function moveToTarget(targetPos)
        local char = LocalPlayer.Character
        if not char then return false end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return false end
        local targetHRP = targetPos + Vector3.new(0, 2.5, 0)
        drawPath({hrp.Position, targetHRP})
        hum.WalkSpeed = moveSpeed
        hum.AutoRotate = true
        local startTime = tick()
        while (hrp.Position - targetHRP).Magnitude > 3.5 and tick() - startTime < 15 do
            if not autoFarmEnabled then break end
            char = LocalPlayer.Character
            if not char then break end
            hrp = char:FindFirstChild("HumanoidRootPart")
            hum = char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then break end
            local lookAt = (targetHRP - hrp.Position).Unit
            hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(lookAt.X, 0, lookAt.Z))
            hum.MoveDirection = Vector3.new(lookAt.X, 0, lookAt.Z)
            wait()
        end
        hum.MoveDirection = Vector3.new()
        clearPathVisuals()
        return (hrp.Position - targetHRP).Magnitude <= 3.5
    end

    local function hasTool(toolName)
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        local character = LocalPlayer.Character
        return (backpack and backpack:FindFirstChild(toolName)) or (character and character:FindFirstChild(toolName))
    end

    local function equipTool(toolName)
        local tool = LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Backpack:FindFirstChild(toolName)
        if tool and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            pcall(function() LocalPlayer.Character.Humanoid:EquipTool(tool) end)
            task.wait(1)
            return true
        end
        return false
    end

    local function findCrowbarDealer()
        local map = Workspace:FindFirstChild("Map")
        if not map then return nil end
        local shops = map:FindFirstChild("Shopz")
        if not shops then return nil end
        local char = LocalPlayer.Character
        if not char then return nil end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local closestDealer, closestDist = nil, math.huge
        for _, shop in pairs(shops:GetChildren()) do
            local stocks = shop:FindFirstChild("CurrentStocks")
            if stocks then
                local crowbarStock = stocks:FindFirstChild("Crowbar")
                if crowbarStock and crowbarStock.Value > 0 then
                    local mainPart = shop:FindFirstChild("MainPart")
                    if mainPart then
                        local dist = (hrp.Position - mainPart.Position).Magnitude
                        if dist < closestDist then closestDist = dist; closestDealer = shop end
                    end
                end
            end
        end
        return closestDealer
    end

    local function buyCrowbar()
        local dealer = findCrowbarDealer()
        if not dealer then return false end
        local mainPart = dealer:FindFirstChild("MainPart")
        if not mainPart then return false end
        if not moveToTarget(mainPart.Position) then return false end
        task.wait(1.5)
        local events = ReplicatedStorage:FindFirstChild("Events")
        if events then
            pcall(function() events.BYZERSPROTEC:FireServer(true, "shop", mainPart, "IllegalStore") end)
            task.wait(1)
            pcall(function() events.SSHPRMTE1:InvokeServer("IllegalStore", "Melees", "Crowbar", mainPart, nil, true) end)
            task.wait(20)
            pcall(function() events.BYZERSPROTEC:FireServer(false) end)
        end
        task.wait(2)
        return hasTool("Crowbar")
    end

    local function findTarget()
        local folder = Workspace.Map and Workspace.Map:FindFirstChild("BredMakurz")
        if not folder then folder = Workspace:FindFirstChild("BredMakurz") end
        if not folder then return nil end
        local char = LocalPlayer.Character
        if not char then return nil end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local nearest, bestDist = nil, math.huge
        for _, obj in pairs(folder:GetChildren()) do
            local nameLower = obj.Name:lower()
            if (nameLower:find("safe") or nameLower:find("register")) and not farmProcessed[obj] and not farmTempIgnored[obj] then
                local values = obj:FindFirstChild("Values")
                if values then
                    local broken = values:FindFirstChild("Broken")
                    if broken and broken:IsA("BoolValue") and not broken.Value then
                        local mainPart = obj:FindFirstChild("MainPart") or obj.PrimaryPart
                        if mainPart and mainPart.Position.Y >= 4.8 then
                            local dist = (hrp.Position - mainPart.Position).Magnitude
                            if dist < bestDist then bestDist = dist; nearest = obj end
                        end
                    end
                end
            end
        end
        return nearest
    end

    local function cleanupTempIgnored()
        local now = tick()
        for obj, expiry in pairs(farmTempIgnored) do
            if now > expiry then farmTempIgnored[obj] = nil end
        end
    end

    local function openSafe(safeObj)
        if not hasTool("Crowbar") then
            local bought = buyCrowbar()
            if not bought then return false end
        end
        if not LocalPlayer.Character:FindFirstChild("Crowbar") then equipTool("Crowbar"); task.wait(1) end
        task.wait(1.5)
        local events = ReplicatedStorage:FindFirstChild("Events")
        if not events then return false end
        local remote1, remote2 = events:FindFirstChild("XMHH.2"), events:FindFirstChild("XMHH2.2")
        local mainPart = safeObj:FindFirstChild("MainPart") or safeObj.PrimaryPart
        if not remote1 or not remote2 or not mainPart then return false end
        local startTime, hits = tick(), 0
        while autoFarmEnabled and safeObj and safeObj.Parent do
            local values = safeObj:FindFirstChild("Values")
            if not values then break end
            local broken = values:FindFirstChild("Broken")
            if broken and broken.Value then break end
            if tick() - startTime > 25 then break end
            task.wait(0.4)
            local crowbar = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Crowbar")
            if not crowbar then crowbar = LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Crowbar"); if crowbar then equipTool("Crowbar") end end
            if not crowbar then break end
            local arm = LocalPlayer.Character:FindFirstChild("Right Arm")
            if not arm then break end
            local success, result = pcall(function() return remote1:InvokeServer("\240\159\141\158", tick(), crowbar, "DZDRRRKI", safeObj, "Register") end)
            if success and result then
                pcall(function() remote2:FireServer("\240\159\141\158", tick(), crowbar, "2389ZFX34", result, false, arm, mainPart, safeObj, mainPart.Position, mainPart.Position) end)
                hits = hits + 1
            end
            if hits % 4 == 0 then task.wait(0.8) end
        end
        task.wait(2)
        return true
    end

    local function collectMoneyNearTarget(targetObj)
        local mainPart = targetObj:FindFirstChild("MainPart") or targetObj.PrimaryPart
        if not mainPart then return false end
        local spawnedBread = Workspace:FindFirstChild("Filter") and Workspace.Filter:FindFirstChild("SpawnedBread")
        if not spawnedBread then return false end
        local collected = false
        for _, bread in pairs(spawnedBread:GetChildren()) do
            pcall(function()
                if bread:IsA("Part") and bread.Transparency < 1 then
                    if (bread.Position - mainPart.Position).Magnitude <= 20 then
                        moveToTarget(bread.Position)
                        local pickupEvent = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("CZDPZUS")
                        if pickupEvent then pcall(function() pickupEvent:FireServer(bread) end); collected = true end
                        task.wait(0.3)
                    end
                end
            end)
        end
        return collected
    end

    local isRespawning = false
    local respawnConn = nil
    local function pressE()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end
    local function startRespawnHandler()
        if isRespawning then return end
        isRespawning = true
        respawnConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChild("Humanoid")
            if char and hum and hum.Health > 0 then
                if respawnConn then respawnConn:Disconnect() end
                respawnConn = nil
                isRespawning = false
                return
            end
            pcall(pressE)
        end)
    end
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(3)
        hasReachedTargetY = false
        if autoFarmEnabled then riseToTargetY() end
    end)
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.Died:Connect(startRespawnHandler) end
    end

    local function farmLoop()
        while autoFarmEnabled do
            task.wait(1)
            cleanupTempIgnored()
            local char, hum = LocalPlayer.Character, LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if not char or not hum or hum.Health <= 0 then task.wait(3) goto continue end
            riseToTargetY()
            if not hasTool("Crowbar") then
                local bought = buyCrowbar()
                if not bought then task.wait(5); goto continue end
            end
            local target = findTarget()
            if not target then task.wait(5); goto continue end
            local mainPart = target:FindFirstChild("MainPart") or target.PrimaryPart
            if not mainPart then farmProcessed[target] = true; goto continue end
            if moveToTarget(mainPart.Position) then
                if not LocalPlayer.Character:FindFirstChild("Crowbar") then equipTool("Crowbar") end
                if openSafe(target) then
                    collectMoneyNearTarget(target)
                    farmProcessed[target] = true
                else
                    farmTempIgnored[target] = tick() + ignoreDuration
                end
            else
                farmTempIgnored[target] = tick() + ignoreDuration
            end
            task.wait(2)
            ::continue::
        end
    end

    function AutoFarm_Enable()
        if autoFarmEnabled then return end
        autoFarmEnabled = true
        farmProcessed = {}
        farmTempIgnored = {}
        hasReachedTargetY = false
        if autoFarmCoroutine then task.cancel(autoFarmCoroutine) end
        autoFarmCoroutine = task.spawn(farmLoop)
    end
    function AutoFarm_Disable()
        autoFarmEnabled = false
        if autoFarmCoroutine then task.cancel(autoFarmCoroutine); autoFarmCoroutine = nil end
        farmProcessed = {}
        farmTempIgnored = {}
        clearPathVisuals()
    end
    function AutoFarm_SetSpeed(speed) moveSpeed = math.clamp(speed, 10, 45) end
    function AutoFarm_GetSpeed() return moveSpeed end

    -- RAGEBOT MODULE
    local EventsFolder = ReplicatedStorage:FindFirstChild("Events")
    local GNX_S_Remote = EventsFolder and EventsFolder:FindFirstChild("GNX_S")
    local ZFKLF_H_Remote = EventsFolder and EventsFolder:FindFirstChild("ZFKLF__H")
    local Ragebot_Enabled = false
    local Ragebot_Coroutine = nil
    local Ragebot_Target = nil

    local function RandomString(length)
        local res = ""
        for i = 1, length do
            res = res .. string.char(math.random(97, 122))
        end
        return res
    end

    local function GetClosestEnemy_Rage()
        local closestEnemy = nil
        local shortestDistance = 200
        local myChar = LocalPlayer.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return nil end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local enemyChar = player.Character
                local enemyHRP = enemyChar and enemyChar:FindFirstChild("HumanoidRootPart")
                local enemyHum = enemyChar and enemyChar:FindFirstChildOfClass("Humanoid")
                if enemyHRP and enemyHum and enemyHum.Health > 15 and not enemyChar:FindFirstChildOfClass("ForceField") then
                    local distance = (myHRP.Position - enemyHRP.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestEnemy = player
                    end
                end
            end
        end
        return closestEnemy
    end

    local function Shoot_Rage(targetPlayer)
        if not targetPlayer or not targetPlayer.Character then return end
        local targetPart = targetPlayer.Character:FindFirstChild("Head") or targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not targetPart then return end
        local myChar = LocalPlayer.Character
        local tool = myChar and myChar:FindFirstChildOfClass("Tool")
        if not tool then return end
        local currentCam = workspace.CurrentCamera
        local hitPosition = targetPart.Position
        local hitDirection = (hitPosition - currentCam.CFrame.Position).Unit
        local randomKey = RandomString(30) .. "0"
        if not GNX_S_Remote or not ZFKLF_H_Remote then
            if Ragebot_Disable then Ragebot_Disable() end
            return
        end
        pcall(function()
            GNX_S_Remote:FireServer(tick(), randomKey, tool, "FDS9I83", currentCam.CFrame.Position, {hitDirection}, false)
        end)
        pcall(function()
            ZFKLF_H_Remote:FireServer("🧈", tool, randomKey, 1, targetPart, hitPosition, hitDirection, nil, nil)
        end)
    end

    local function RagebotLoop()
        while Ragebot_Enabled do
            local target = GetClosestEnemy_Rage()
            Ragebot_Target = target
            if target then
                Shoot_Rage(target)
                task.wait(0.05)
            else
                task.wait(0.1)
            end
        end
        Ragebot_Target = nil
        Ragebot_Coroutine = nil
    end

    function Ragebot_Enable()
        if not GNX_S_Remote or not ZFKLF_H_Remote then
            return
        end
        if Ragebot_Enabled then return end
        Ragebot_Enabled = true
        if not Ragebot_Coroutine then
            Ragebot_Coroutine = coroutine.create(RagebotLoop)
            coroutine.resume(Ragebot_Coroutine)
        end
    end

    function Ragebot_Disable()
        if not Ragebot_Enabled then return end
        Ragebot_Enabled = false
    end

    -- INFINITE TOOLS DURABILITY MODULE
    local infDurabilityEnabled = false
    local infDurabilityConn = nil
    function InfiniteDurability_Enable()
        if infDurabilityEnabled then return end
        infDurabilityEnabled = true
        infDurabilityConn = RunService.Stepped:Connect(function()
            if not infDurabilityEnabled then return end
            local char = LocalPlayer.Character
            if not char then return end
            for _, tool in pairs(char:GetChildren()) do
                if tool:IsA("Tool") then
                    local durability = tool:FindFirstChild("Durability")
                    if durability and durability:IsA("NumberValue") then
                        durability.Value = 100
                    end
                    local uses = tool:FindFirstChild("Uses")
                    if uses and uses:IsA("NumberValue") then
                        uses.Value = 100
                    end
                end
            end
        end)
    end
    function InfiniteDurability_Disable()
        infDurabilityEnabled = false
        if infDurabilityConn then infDurabilityConn:Disconnect(); infDurabilityConn = nil end
    end

    -- QUICK RESPAWN MODULE
    local quickRespawnEnabled = false
    local quickRespawnConn = nil
    function QuickRespawn_Enable()
        if quickRespawnEnabled then return end
        quickRespawnEnabled = true
        quickRespawnConn = RunService.Heartbeat:Connect(function()
            if not quickRespawnEnabled then return end
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChild("Humanoid")
            if char and hum and hum.Health <= 0 then
                pcall(function()
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    task.wait(0.05)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                end)
            end
        end)
    end
    function QuickRespawn_Disable()
        quickRespawnEnabled = false
        if quickRespawnConn then quickRespawnConn:Disconnect(); quickRespawnConn = nil end
    end

    -- #####################################################################
    -- #                         SAYFA ICERIKLERI                          #
    -- #####################################################################

    pageContent["DASHBOARD"] = function()
        makeHeader("SISTEM DURUMU", 1)
        local statRow = makeCard(60, 2)
        local statusMsg = Instance.new("TextLabel")
        statusMsg.Size = UDim2.new(1, -24, 1, 0)
        statusMsg.Position = UDim2.new(0, 12, 0, 0)
        statusMsg.BackgroundTransparency = 1
        statusMsg.Text = "SANTES HUB v3.0 Aktif\n\nTum moduller hazir."
        statusMsg.Font = Enum.Font.Gotham
        statusMsg.TextSize = 12
        statusMsg.TextColor3 = C.textSub
        statusMsg.TextXAlignment = Enum.TextXAlignment.Left
        statusMsg.Parent = statRow
    end

    pageContent["PROFILE"] = function()
        makeHeader("KULLANICI", 1)
        local profCard = makeCard(100, 2)
        local userInfo = Instance.new("TextLabel")
        userInfo.Size = UDim2.new(1, -24, 1, 0)
        userInfo.Position = UDim2.new(0, 12, 0, 0)
        userInfo.BackgroundTransparency = 1
        userInfo.Text = "Kullanici: " .. LocalPlayer.Name .. "\n\nDurum: Premium\nSurum: v3.0\nModul Sayisi: 15+"
        userInfo.Font = Enum.Font.Gotham
        userInfo.TextSize = 12
        userInfo.TextColor3 = C.textSub
        userInfo.TextXAlignment = Enum.TextXAlignment.Left
        userInfo.Parent = profCard
    end

    pageContent["STATS"] = function()
        makeHeader("MODUL DURUMU", 1)
        local modCard = makeCard(60, 2)
        local modMsg = Instance.new("TextLabel")
        modMsg.Size = UDim2.new(1, -24, 1, 0)
        modMsg.Position = UDim2.new(0, 12, 0, 0)
        modMsg.BackgroundTransparency = 1
        modMsg.Text = "Tum moduller yuklendi.\nAktif Modul Sayisi: " .. getActiveModuleCount()
        modMsg.Font = Enum.Font.Gotham
        modMsg.TextSize = 12
        modMsg.TextColor3 = C.textSub
        modMsg.TextXAlignment = Enum.TextXAlignment.Left
        modMsg.Parent = modCard
    end

    pageContent["ABOUT"] = function()
        makeHeader("SANTES HUB", 1)
        local aboutCard = makeCard(160, 2)
        local aboutTxt = Instance.new("TextLabel")
        aboutTxt.Size = UDim2.new(1, -24, 1, -20)
        aboutTxt.Position = UDim2.new(0, 12, 0, 12)
        aboutTxt.BackgroundTransparency = 1
        aboutTxt.Text = "SANTES HUB v3.0\n\nModern, hafif ve hizli arayuz.\nSiyah & kirmizi premium tema.\n\nTum ozellikler entegre edilmistir.\n\nOzellikler:\n- Fly, Noclip, Fullbright, ESP\n- Silent Aim, Melee Aura, Ragebot\n- Auto Farm, Auto Lockpick, Auto Pickup\n- Unlock Doors, No Recoil, Invisible\n- Infinite Stamina, Hitbox Expander\n- Spin Bot, Gravity Control\n- Ve daha fazlasi..."
        aboutTxt.Font = Enum.Font.Gotham
        aboutTxt.TextSize = 11
        aboutTxt.TextColor3 = C.textSub
        aboutTxt.TextYAlignment = Enum.TextYAlignment.Top
        aboutTxt.TextWrapped = true
        aboutTxt.Parent = aboutCard
    end

    function getActiveModuleCount()
        local count = 0
        if flyEnabled then count = count + 1 end
        if noclipEnabled then count = count + 1 end
        if fullbrightEnabled then count = count + 1 end
        if espEnabled then count = count + 1 end
        if silentAimEnabled then count = count + 1 end
        if meleeAuraEnabled then count = count + 1 end
        if autoFarmEnabled then count = count + 1 end
        if autoLockpickEnabled then count = count + 1 end
        if Ragebot_Enabled then count = count + 1 end
        return count
    end

    -- MODULES TAB - TUM MODULLERIN LISTESI
    pageContent["MODULES"] = function()
        makeHeader("MODULLER", 1)
        local modCard = makeCard(550, 2)
        
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = modCard
        
        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 12)
        padding.PaddingLeft = UDim.new(0, 12)
        padding.PaddingRight = UDim.new(0, 12)
        padding.PaddingBottom = UDim.new(0, 12)
        padding.Parent = modCard
        
        local function createModuleToggle(name, getState, setEnable, setDisable)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -24, 0, 45)
            frame.BackgroundColor3 = C.panel
            frame.BorderSizePixel = 0
            frame.Parent = modCard
            addCorner(frame, 8)
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.6, 0, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.Font = Enum.Font.GothamBold
            label.TextSize = 12
            label.TextColor3 = C.textSub
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(0, 70, 0, 30)
            toggleBtn.Position = UDim2.new(1, -82, 0.5, -15)
            toggleBtn.Font = Enum.Font.GothamBold
            toggleBtn.TextSize = 11
            toggleBtn.TextColor3 = C.textPrimary
            toggleBtn.BackgroundColor3 = getState() and C.accent or Color3.fromRGB(45, 45, 55)
            toggleBtn.BorderSizePixel = 0
            toggleBtn.AutoButtonColor = false
            toggleBtn.Parent = frame
            addCorner(toggleBtn, 15)
            
            local function update()
                toggleBtn.Text = getState() and "ACIK" or "KAPALI"
                toggleBtn.BackgroundColor3 = getState() and C.accent or Color3.fromRGB(45, 45, 55)
            end
            update()
            
            toggleBtn.MouseButton1Click:Connect(function()
                if getState() then
                    setDisable()
                else
                    setEnable()
                end
                update()
            end)
            
            return frame
        end
        
        -- Tum modulleri ekle
        createModuleToggle("FLY", function() return flyEnabled end, Fly_Enable, Fly_Disable)
        createModuleToggle("NOCLIP", function() return noclipEnabled end, Noclip_Enable, Noclip_Disable)
        createModuleToggle("FULLBRIGHT", function() return fullbrightEnabled end, FullBright_Enable, FullBright_Disable)
        createModuleToggle("FOV", function() return fovEnabled end, FOV_Enable, FOV_Disable)
        createModuleToggle("NO FAIL LOCKPICK", function() return noFailLPEnabled end, NoFailLP_Enable, NoFailLP_Disable)
        createModuleToggle("SAFE ESP", function() return safeESPEnabled end, SafeESP_Enable, SafeESP_Disable)
        createModuleToggle("AUTO LOCKPICK", function() return autoLockpickEnabled end, AutoLockpick_Enable, AutoLockpick_Disable)
        createModuleToggle("AUTO PICKUP", function() return autoPickupEnabled end, AutoPickup_Enable, AutoPickup_Disable)
        createModuleToggle("UNLOCK DOORS", function() return unlockDoorsEnabled end, UnlockDoors_Enable, UnlockDoors_Disable)
        createModuleToggle("ADMIN CHECK", function() return adminCheckEnabled end, AdminCheck_Enable, AdminCheck_Disable)
        createModuleToggle("PLAYER ESP", function() return espEnabled end, ESP_Enable, ESP_Disable)
        createModuleToggle("INVISIBLE", function() return invisEnabled end, Invis_Enable, Invis_Disable)
        createModuleToggle("NO RECOIL", function() return noRecoilEnabled end, NoRecoil_Enable, NoRecoil_Disable)
        createModuleToggle("SILENT AIM", function() return silentAimEnabled end, SilentAim_Enable, SilentAim_Disable)
        createModuleToggle("MELEE AURA", function() return meleeAuraEnabled end, MeleeAura_Enable, MeleeAura_Disable)
        createModuleToggle("INFINITE STAMINA", function() return infStaminaEnabled end, InfiniteStamina_Enable, InfiniteStamina_Disable)
        createModuleToggle("AUTO FARM", function() return autoFarmEnabled end, AutoFarm_Enable, AutoFarm_Disable)
        createModuleToggle("RAGEBOT", function() return Ragebot_Enabled end, Ragebot_Enable, Ragebot_Disable)
        createModuleToggle("INFINITE DURABILITY", function() return infDurabilityEnabled end, InfiniteDurability_Enable, InfiniteDurability_Disable)
        createModuleToggle("QUICK RESPAWN", function() return quickRespawnEnabled end, QuickRespawn_Enable, QuickRespawn_Disable)
    end

    -- TABLARI OLUSTUR
    makeTab("DASHBOARD", "◈")
    makeTab("MODULES", "⚡")
    makeTab("PROFILE", "◉")
    makeTab("STATS", "▣")
    makeTab("ABOUT", "◇")

    -- KUCULTULMUS MOD
    local miniFrame = Instance.new("Frame")
    miniFrame.Size = UDim2.new(0, 72, 0, 72)
    miniFrame.Position = UDim2.new(0, 24, 0, 24)
    miniFrame.BackgroundColor3 = C.panel
    miniFrame.BorderSizePixel = 0
    miniFrame.Visible = false
    miniFrame.Active = true
    miniFrame.Draggable = true
    miniFrame.Parent = mainGui
    addCorner(miniFrame, 36)
    addStroke(miniFrame, C.accent, 2)

    local miniLbl = Instance.new("TextLabel")
    miniLbl.Size = UDim2.new(1, 0, 0.5, 0)
    miniLbl.Position = UDim2.new(0, 0, 0.18, 0)
    miniLbl.BackgroundTransparency = 1
    miniLbl.Text = "S"
    miniLbl.Font = Enum.Font.Impact
    miniLbl.TextSize = 28
    miniLbl.TextColor3 = C.accent
    miniLbl.TextXAlignment = Enum.TextXAlignment.Center
    miniLbl.Parent = miniFrame

    -- KONTROL OLAYLARI
    minimizeBtn.MouseButton1Click:Connect(function()
        win.Visible = false
        overlay.Visible = false
        miniFrame.Visible = true
    end)

    miniFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            miniFrame.Visible = false
            win.Visible = true
            overlay.Visible = true
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        tween(win, { Size = UDim2.new(0, 0, 0, 0) }, 0.25)
        tween(overlay, { BackgroundTransparency = 1 }, 0.25)
        task.wait(0.28)
        mainGui:Destroy()
    end)

    -- SURUKLEME
    local dragging = false
    local dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = win.Position
        end
    end)
    titleBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            winGlow.Position = UDim2.new(win.Position.X.Scale, win.Position.X.Offset - 20, win.Position.Y.Scale, win.Position.Y.Offset - 20)
        end
    end)
    titleBar.InputEnded:Connect(function()
        dragging = false
    end)

    -- KEYBIND (K tusu ile UI ac/kapat)
    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Enum.KeyCode.K then
            if miniFrame.Visible then
                miniFrame.Visible = false
                win.Visible = true
                overlay.Visible = true
            else
                local vis = not win.Visible
                win.Visible = vis
                overlay.Visible = vis
            end
        end
    end)

    -- ACILLIS ANIMASYONU
    win.Size = UDim2.new(0, 0, 0, 0)
    win.ClipsDescendants = true
    tween(win, { Size = UDim2.new(0, WIN_W, 0, WIN_H) }, 0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    task.wait(0.05)
    switchPage("DASHBOARD")

    print("SANTES HUB v3.0 - ANA ARAYUZ YUKLENDI!")
end
