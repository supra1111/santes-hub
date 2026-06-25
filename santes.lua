-- ============================================
-- SANTES HUB LOADER + SCRIPT (GLOW & MODERN)
-- ============================================

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- ========== LOADER (GLOW & MODERN) ==========
local loaderGui = Instance.new("ScreenGui")
loaderGui.Name = "SantesHubLoader"
loaderGui.ResetOnSpawn = false
loaderGui.IgnoreGuiInset = true
loaderGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
loaderGui.DisplayOrder = 1000
loaderGui.Parent = game:GetService("CoreGui")

-- Arka plan blur efekti için transparan backdrop
local backdrop = Instance.new("Frame")
backdrop.Name = "Backdrop"
backdrop.Size = UDim2.new(1, 0, 1, 0)
backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backdrop.BackgroundTransparency = 0.4
backdrop.BorderSizePixel = 0
backdrop.Parent = loaderGui

-- Arka plan glow (kırmızı sis efekti)
local bgGlow = Instance.new("ImageLabel)
bgGlow.Name = "BgGlow"
bgGlow.AnchorPoint = Vector2.new(0.5, 0.5)
bgGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
bgGlow.Size = UDim2.new(0, 800, 0, 800)
bgGlow.BackgroundTransparency = 1
bgGlow.Image = "rbxassetid://5028857084"
bgGlow.ImageColor3 = Color3.fromRGB(200, 20, 20)
bgGlow.ImageTransparency = 0.6
bgGlow.Parent = backdrop

local card = Instance.new("Frame")
card.Name = "Card"
card.AnchorPoint = Vector2.new(0.5, 0.5)
card.Position = UDim2.new(0.5, 0, 0.5, 0)
card.Size = UDim2.new(0, 400, 0, 250)
card.BackgroundColor3 = Color3.fromRGB(10, 8, 10)
card.BorderSizePixel = 0
card.ClipsDescendants = true
card.Parent = backdrop

local cardCorner = Instance.new("UICorner", card)
cardCorner.CornerRadius = UDim.new(0, 20)

-- Card glow (dış parlaklık)
local cardGlow = Instance.new("ImageLabel")
cardGlow.Name = "CardGlow"
cardGlow.AnchorPoint = Vector2.new(0.5, 0.5)
cardGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
cardGlow.Size = UDim2.new(1, 40, 1, 40)
cardGlow.BackgroundTransparency = 1
cardGlow.Image = "rbxassetid://5028857084"
cardGlow.ImageColor3 = Color3.fromRGB(200, 30, 30)
cardGlow.ImageTransparency = 0.5
cardGlow.ZIndex = 0
cardGlow.Parent = card

local cardStroke = Instance.new("UIStroke", card)
cardStroke.Color = Color3.fromRGB(200, 30, 30)
cardStroke.Thickness = 1.5
cardStroke.Transparency = 0.3

local cardGradient = Instance.new("UIGradient", card)
cardGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 15, 18)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 6, 8)),
})
cardGradient.Rotation = 135

-- Üst glow çizgisi
local accentBar = Instance.new("Frame")
accentBar.Name = "AccentBar"
accentBar.Size = UDim2.new(1, 0, 0, 3)
accentBar.Position = UDim2.new(0, 0, 0, 0)
accentBar.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
accentBar.BorderSizePixel = 0
accentBar.Parent = card

local accentCorner = Instance.new("UICorner", accentBar)
accentCorner.CornerRadius = UDim.new(1, 0)

local accentGradient = Instance.new("UIGradient", accentBar)
accentGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 10, 10)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 60, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 10, 10)),
})

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 25)
title.BackgroundTransparency = 1
title.Text = "SANTES HUB"
title.TextColor3 = Color3.fromRGB(240, 220, 220)
title.TextSize = 34
title.Font = Enum.Font.GothamBold
title.Parent = card

-- Title glow (altta parlayan metin)
local titleGlow = title:Clone()
titleGlow.Name = "TitleGlow"
titleGlow.TextColor3 = Color3.fromRGB(200, 30, 30)
titleGlow.TextTransparency = 0.6
titleGlow.ZIndex = title.ZIndex - 1
titleGlow.Position = UDim2.new(0, 0, 0, 27)
titleGlow.Parent = card

local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, 80)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Loading Santes Hub..."
subtitle.TextColor3 = Color3.fromRGB(180, 150, 150)
subtitle.TextSize = 14
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = card

-- Loading bar (glow efektiyle)
local barBg = Instance.new("Frame")
barBg.Name = "BarBackground"
barBg.Size = UDim2.new(0.85, 0, 0, 6)
barBg.Position = UDim2.new(0.075, 0, 0, 125)
barBg.BackgroundColor3 = Color3.fromRGB(25, 20, 22)
barBg.BorderSizePixel = 0
barBg.Parent = card

local barBgCorner = Instance.new("UICorner", barBg)
barBgCorner.CornerRadius = UDim.new(1, 0)

local bar = Instance.new("Frame")
bar.Name = "Bar"
bar.Size = UDim2.new(0, 0, 1, 0)
bar.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
bar.BorderSizePixel = 0
bar.Parent = barBg

local barCorner = Instance.new("UICorner", bar)
barCorner.CornerRadius = UDim.new(1, 0)

local barGradient = Instance.new("UIGradient", bar)
barGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 10, 10)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 70, 70)),
})

-- Bar glow (ışık efekti)
local barGlow = Instance.new("Frame")
barGlow.Name = "BarGlow"
barGlow.AnchorPoint = Vector2.new(1, 0.5)
barGlow.Size = UDim2.new(0, 20, 0, 20)
barGlow.Position = UDim2.new(0, 0, 0.5, 0)
barGlow.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
barGlow.BackgroundTransparency = 0.4
barGlow.BorderSizePixel = 0
barGlow.ZIndex = 2
barGlow.Parent = bar

local barGlowCorner = Instance.new("UICorner", barGlow)
barGlowCorner.CornerRadius = UDim.new(1, 0)

-- Status text
local statusText = Instance.new("TextLabel")
statusText.Name = "StatusText"
statusText.Size = UDim2.new(1, 0, 0, 20)
statusText.Position = UDim2.new(0, 0, 0, 145)
statusText.BackgroundTransparency = 1
statusText.Text = "Initializing..."
statusText.TextColor3 = Color3.fromRGB(140, 120, 120)
statusText.TextSize = 12
statusText.Font = Enum.Font.Code
statusText.Parent = card

-- Footer
local footer = Instance.new("TextLabel")
footer.Name = "Footer"
footer.Size = UDim2.new(1, 0, 0, 18)
footer.Position = UDim2.new(0, 0, 1, -25)
footer.BackgroundTransparency = 1
footer.Text = "SANTES HUB v2.0"
footer.TextColor3 = Color3.fromRGB(100, 70, 70)
footer.TextSize = 10
footer.Font = Enum.Font.Gotham
footer.Parent = card

-- Glow pulse animasyonu
local function pulseGlow()
    task.spawn(function()
        while card.Parent do
            local tween1 = TweenService:Create(cardGlow, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                ImageTransparency = 0.3,
                Size = UDim2.new(1, 50, 1, 50)
            })
            local tween2 = TweenService:Create(cardGlow, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                ImageTransparency = 0.6,
                Size = UDim2.new(1, 30, 1, 30)
            })
            local tween3 = TweenService:Create(bgGlow, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                ImageTransparency = 0.5,
            })
            local tween4 = TweenService:Create(bgGlow, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                ImageTransparency = 0.7,
            })
            tween1:Play()
            tween3:Play()
            tween1.Completed:Wait()
            tween2:Play()
            tween4:Play()
            tween2.Completed:Wait()
        end
    end)
end

pulseGlow()

local function StartLoader()
    local steps = {
        { progress = 0.10, text = "Loading Santes Hub..." },
        { progress = 0.25, text = "Loading modules..." },
        { progress = 0.40, text = "Connecting to server..." },
        { progress = 0.55, text = "Finalizing setup..." },
        { progress = 0.70, text = "Preparing UI..." },
        { progress = 0.85, text = "Almost ready..." },
        { progress = 1.0, text = "Ready!" },
    }

    local totalTime = 7
    local stepTime = totalTime / #steps

    for _, step in ipairs(steps) do
        statusText.Text = step.text
        local tween = TweenService:Create(bar, TweenInfo.new(stepTime * 0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(step.progress, 0, 1, 0),
        })
        tween:Play()
        tween.Completed:Wait()
        task.wait(stepTime * 0.4)
    end

    statusText.Text = "✓ Santes Hub Loaded!"
    statusText.TextColor3 = Color3.fromRGB(255, 80, 80)
    task.wait(0.5)

    local fadeOut = TweenService:Create(backdrop, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
    })
    local cardFade = TweenService:Create(card, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
    })
    fadeOut:Play()
    cardFade:Play()
    fadeOut.Completed:Wait()

    loaderGui:Destroy()
    StartSantesHub()
end


-- ============================================================
-- SANTES HUB ANA UI (GLOW & MODERN)
-- ============================================================

function StartSantesHub()

local VirtualUser = game:GetService('VirtualUser')
if game:GetService('Players').LocalPlayer then
    game:GetService('Players').LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local oldGui = PlayerGui:FindFirstChild("SantesHubScreenGui")
if oldGui then oldGui:Destroy() end

-- ============================================================
-- ANA UI (GLOW & MODERN - KIRMIZI/SİYAH)
-- ============================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SantesHubScreenGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 460, 0, 400)
mainFrame.Position = UDim2.new(0.5, -230, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(8, 6, 8)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 16)

-- Ana glow
local mainGlow = Instance.new("ImageLabel")
mainGlow.Name = "MainGlow"
mainGlow.AnchorPoint = Vector2.new(0.5, 0.5)
mainGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
mainGlow.Size = UDim2.new(1, 60, 1, 60)
mainGlow.BackgroundTransparency = 1
mainGlow.Image = "rbxassetid://5028857084"
mainGlow.ImageColor3 = Color3.fromRGB(200, 30, 30)
mainGlow.ImageTransparency = 0.4
mainGlow.ZIndex = 0
mainGlow.Parent = mainFrame

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(200, 30, 30)
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.25

local mainGradient = Instance.new("UIGradient", mainFrame)
mainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 12, 14)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 4, 6)),
})
mainGradient.Rotation = 135

-- Header (glow çizgili)
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 55)
header.BackgroundColor3 = Color3.fromRGB(10, 6, 8)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 16)

-- Header glow accent
local headerAccent = Instance.new("Frame")
headerAccent.Name = "HeaderAccent"
headerAccent.Size = UDim2.new(1, 0, 0, 2)
headerAccent.Position = UDim2.new(0, 0, 1, 0)
headerAccent.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
headerAccent.BorderSizePixel = 0
headerAccent.Parent = header

local accentGrad = Instance.new("UIGradient", headerAccent)
accentGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 10, 10)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 60, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 10, 10)),
})

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 18, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "SANTES HUB"
titleLabel.TextColor3 = Color3.fromRGB(230, 210, 210)
titleLabel.TextSize = 22
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

-- Title glow
local titleGlow2 = titleLabel:Clone()
titleGlow2.Name = "TitleGlow"
titleGlow2.TextColor3 = Color3.fromRGB(200, 30, 30)
titleGlow2.TextTransparency = 0.5
titleGlow2.ZIndex = titleLabel.ZIndex - 1
titleGlow2.Position = UDim2.new(0, 18, 0, 2)
titleGlow2.Parent = header

-- Kapatma Butonu
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -42, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
closeBtn.BackgroundTransparency = 0.6
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 15
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0, 8)
local closeStroke = Instance.new("UIStroke", closeBtn)
closeStroke.Color = Color3.fromRGB(200, 30, 30)
closeStroke.Thickness = 1
closeStroke.Transparency = 0.5

-- Küçültme Butonu
local minBtn = Instance.new("TextButton")
minBtn.Name = "MinBtn"
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -78, 0.5, -15)
minBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
minBtn.BackgroundTransparency = 0.5
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = 18
minBtn.Font = Enum.Font.GothamBold
minBtn.BorderSizePixel = 0
minBtn.AutoButtonColor = false
minBtn.Parent = header

local minCorner = Instance.new("UICorner", minBtn)
minCorner.CornerRadius = UDim.new(0, 8)
local minStroke = Instance.new("UIStroke", minBtn)
minStroke.Color = Color3.fromRGB(200, 30, 30)
minStroke.Thickness = 1
minStroke.Transparency = 0.5

local isMinimized = false
local originalSize = mainFrame.Size

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.1), { BackgroundTransparency = 0.2 }):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.1), { BackgroundTransparency = 0.6 }):Play()
end)
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

minBtn.MouseEnter:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.1), { BackgroundTransparency = 0.2 }):Play()
end)
minBtn.MouseLeave:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.1), { BackgroundTransparency = 0.5 }):Play()
end)
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        mainFrame.Size = UDim2.new(0, 120, 0, 55)
        minBtn.Text = "+"
        contentContainer.Visible = false
    else
        mainFrame.Size = originalSize
        minBtn.Text = "−"
        contentContainer.Visible = true
    end
end)

-- Ana içerik
local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, -24, 1, -65)
contentContainer.Position = UDim2.new(0, 12, 0, 60)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

-- Sol menü
local menuFrame = Instance.new("Frame")
menuFrame.Name = "MenuFrame"
menuFrame.Size = UDim2.new(0, 110, 1, 0)
menuFrame.BackgroundColor3 = Color3.fromRGB(10, 6, 8)
menuFrame.BorderSizePixel = 0
menuFrame.Parent = contentContainer

local menuCorner = Instance.new("UICorner", menuFrame)
menuCorner.CornerRadius = UDim.new(0, 10)

local menuStroke = Instance.new("UIStroke", menuFrame)
menuStroke.Color = Color3.fromRGB(200, 30, 30)
menuStroke.Thickness = 1
menuStroke.Transparency = 0.4

-- Menu glow
local menuGlow = Instance.new("ImageLabel")
menuGlow.Name = "MenuGlow"
menuGlow.AnchorPoint = Vector2.new(0.5, 0.5)
menuGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
menuGlow.Size = UDim2.new(1, 20, 1, 20)
menuGlow.BackgroundTransparency = 1
menuGlow.Image = "rbxassetid://5028857084"
menuGlow.ImageColor3 = Color3.fromRGB(200, 30, 30)
menuGlow.ImageTransparency = 0.3
menuGlow.ZIndex = 0
menuGlow.Parent = menuFrame

local menuLayout = Instance.new("UIListLayout")
menuLayout.Padding = UDim.new(0, 5)
menuLayout.SortOrder = Enum.SortOrder.LayoutOrder
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.Parent = menuFrame

-- Sağ scroll
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, -125, 1, 0)
scrollFrame.Position = UDim2.new(0, 120, 0, 0)
scrollFrame.BackgroundColor3 = Color3.fromRGB(8, 4, 6)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(200, 30, 30)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent = contentContainer

local scrollCorner = Instance.new("UICorner", scrollFrame)
scrollCorner.CornerRadius = UDim.new(0, 10)

local scrollStroke = Instance.new("UIStroke", scrollFrame)
scrollStroke.Color = Color3.fromRGB(200, 30, 30)
scrollStroke.Thickness = 1
scrollStroke.Transparency = 0.4

local scrollGlow = Instance.new("ImageLabel")
scrollGlow.Name = "ScrollGlow"
scrollGlow.AnchorPoint = Vector2.new(0.5, 0.5)
scrollGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
scrollGlow.Size = UDim2.new(1, 20, 1, 20)
scrollGlow.BackgroundTransparency = 1
scrollGlow.Image = "rbxassetid://5028857084"
scrollGlow.ImageColor3 = Color3.fromRGB(200, 30, 30)
scrollGlow.ImageTransparency = 0.3
scrollGlow.ZIndex = 0
scrollGlow.Parent = scrollFrame

local scrollLayout = Instance.new("UIListLayout")
scrollLayout.Padding = UDim.new(0, 6)
scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
scrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
scrollLayout.Parent = scrollFrame


-- ============================================================
-- SÜRÜKLEME
-- ============================================================
do
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil

    local function update(input)
        local delta = input.Position - dragStart
        local newX = startPos.X.Offset + delta.X
        local newY = startPos.Y.Offset + delta.Y
        mainFrame.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
    end

    header.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [K] tuşu
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.K then
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
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not PlayerGui then return end
    lockpickAddedConnection = PlayerGui.ChildAdded:Connect(function(Item)
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
    local bredMakurzFolder = workspace.Map:FindFirstChild("BredMakurz")
    if not bredMakurzFolder then return end
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local playerPosition = character.HumanoidRootPart.Position

    for _, v in pairs(bredMakurzFolder:GetChildren()) do
        local objectPosition
        if v.PrimaryPart and v.PrimaryPart:IsA("BasePart") then
            objectPosition = v.PrimaryPart.Position
        else
            local part = v:FindFirstChildOfClass("BasePart")
            if part then objectPosition = part.Position else continue end
        end
        
        local distance = (objectPosition - playerPosition).magnitude
        local existingGui = v:FindFirstChild("Ahh")

        if distance <= 200 then
            if not existingGui then
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
                local brokenValue = values and values:FindFirstChild("Broken")
                if brokenValue then
                    if brokenValue.Value ~= false then textLabel.TextColor3 = Color3.new(255,0,0)
                    else textLabel.TextColor3 = Color3.new(0,255,0) end
                    brokenValue:GetPropertyChangedSignal("Value"):Connect(function()
                        if brokenValue.Value ~= false then textLabel.TextColor3 = Color3.new(255,0,0)
                        else textLabel.TextColor3 = Color3.new(0,255,0) end
                    end)
                else textLabel.TextColor3 = Color3.new(0,255,0) end
            end
        elseif existingGui then existingGui:Destroy() end
    end
end

function BredMakurz_Enable()
    if BredMakurz_Enabled then return end
    BredMakurz_Enabled = true
    bredMakurzConnection = RunService.Heartbeat:Connect(function() ApplyBredMakurzModification() end)
end

function BredMakurz_Disable()
    if not BredMakurz_Enabled then return end
    BredMakurz_Enabled = false
    if bredMakurzConnection then bredMakurzConnection:Disconnect() bredMakurzConnection = nil end
end

-- Open/Unlock Doors
local OpenNearbyDoors_Enabled = false
local UnlockNearbyDoors_Enabled = false
local NearbyDoorInteraction_Coroutine = nil

local function NearbyDoorInteraction_Loop()
    while (OpenNearbyDoors_Enabled or UnlockNearbyDoors_Enabled) do
        local waitTime = 0.25
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then task.wait(waitTime * 2) continue end

        local doorsFolder = workspace.Map:FindFirstChild("Doors")
        if not doorsFolder then
            if OpenNearbyDoors_Enabled then OpenNearbyDoors_Disable() end
            if UnlockNearbyDoors_Enabled then UnlockNearbyDoors_Disable() end
            break
        end

        local playerPos = hrp.Position
        local checkRadius = 6

        for _, doorInstance in ipairs(doorsFolder:GetChildren()) do
            local doorBase = doorInstance:FindFirstChild("DoorBase")
            local valuesFolder = doorInstance:FindFirstChild("Values")
            local eventsFolder = doorInstance:FindFirstChild("Events")
            if doorBase and valuesFolder and eventsFolder and (playerPos - doorBase.Position).Magnitude <= checkRadius then
                local toggleEvent = eventsFolder:FindFirstChild("Toggle")
                if not toggleEvent then continue end

                if UnlockNearbyDoors_Enabled then
                    local lockedValue = valuesFolder:FindFirstChild("Locked")
                    local lockArgument = doorInstance:FindFirstChild("Lock")
                    if lockedValue and lockArgument and typeof(lockedValue.Value) == "boolean" and lockedValue.Value == true then
                        pcall(function() toggleEvent:FireServer("Unlock", lockArgument) end)
                    end
                end

                if OpenNearbyDoors_Enabled then
                    local openValue = valuesFolder:FindFirstChild("Open")
                    local knobArgument = doorInstance:FindFirstChild("Knob2") or doorInstance:FindFirstChild("Knob")
                    if openValue and knobArgument and typeof(openValue.Value) == "boolean" and openValue.Value == false then
                        local isLocked = valuesFolder:FindFirstChild("Locked")
                        if not isLocked or isLocked.Value == false or not UnlockNearbyDoors_Enabled then
                            pcall(function() toggleEvent:FireServer("Open", knobArgument) end)
                        end
                    end
                end
            end
        end
        task.wait(waitTime)
    end
    NearbyDoorInteraction_Coroutine = nil
end

local function StartStopDoorInteractionLoop()
    local shouldRun = OpenNearbyDoors_Enabled or UnlockNearbyDoors_Enabled
    if shouldRun and not NearbyDoorInteraction_Coroutine then
        NearbyDoorInteraction_Coroutine = task.spawn(NearbyDoorInteraction_Loop)
    end
end

function OpenNearbyDoors_Enable()
    if OpenNearbyDoors_Enabled then return end
    OpenNearbyDoors_Enabled = true
    StartStopDoorInteractionLoop()
end

function OpenNearbyDoors_Disable()
    if not OpenNearbyDoors_Enabled then return end
    OpenNearbyDoors_Enabled = false
    StartStopDoorInteractionLoop()
end

function UnlockNearbyDoors_Enable()
    if UnlockNearbyDoors_Enabled then return end
    UnlockNearbyDoors_Enabled = true
    StartStopDoorInteractionLoop()
end

function UnlockNearbyDoors_Disable()
    if not UnlockNearbyDoors_Enabled then return end
    UnlockNearbyDoors_Enabled = false
    StartStopDoorInteractionLoop()
end

-- Auto Pickup Money
local AutoPickupMoney_Enabled = false
local AutoPickupMoney_Connection = nil
local AutoPickupMoney_Coroutine = nil
local CoolDowns = { AutoPickUps = { MoneyCooldown = false } }
local Settings = { IsDead = false }

local function AutoPickupMoney_Logic()
    local cashFolder = workspace.Filter:FindFirstChild("SpawnedBread")
    local remoteEvent = game:GetService("ReplicatedStorage").Events:FindFirstChild("CZDPZUS")
    if not cashFolder then AutoPickupMoney_Disable() return end
    if not remoteEvent then AutoPickupMoney_Disable() return end

    AutoPickupMoney_Connection = RunService.RenderStepped:Connect(function()
        if not AutoPickupMoney_Enabled or Settings.IsDead then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp or CoolDowns.AutoPickUps.MoneyCooldown then return end

        local rootPosition = hrp.Position
        for _, v in ipairs(cashFolder:GetChildren()) do
            if (rootPosition - v.Position).Magnitude < 5 and not CoolDowns.AutoPickUps.MoneyCooldown then
                CoolDowns.AutoPickUps.MoneyCooldown = true
                pcall(function() remoteEvent:FireServer(v) end)
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
    if AutoPickupMoney_Connection then AutoPickupMoney_Connection:Disconnect() AutoPickupMoney_Connection = nil end
    if AutoPickupMoney_Coroutine then coroutine.close(AutoPickupMoney_Coroutine) AutoPickupMoney_Coroutine = nil end
    AutoPickupMoney_Coroutine = coroutine.create(AutoPickupMoney_Logic)
    coroutine.resume(AutoPickupMoney_Coroutine)
end

function AutoPickupMoney_Disable()
    if not AutoPickupMoney_Enabled then return end
    AutoPickupMoney_Enabled = false
    if AutoPickupMoney_Connection then AutoPickupMoney_Connection:Disconnect() AutoPickupMoney_Connection = nil end
    if AutoPickupMoney_Coroutine then coroutine.close(AutoPickupMoney_Coroutine) AutoPickupMoney_Coroutine = nil end
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
            local moveDir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end
            if moveDir.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (moveDir.Unit * Fly_Speed * dt) end
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
local OriginalValues = {
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
        if Lighting.Brightness ~= 5 then Lighting.Brightness = 5 end
        if Lighting.ClockTime ~= 14 then Lighting.ClockTime = 14 end
        if Lighting.Ambient ~= Color3.new(1,1,1) then Lighting.Ambient = Color3.new(1,1,1) end
        if Lighting.OutdoorAmbient ~= Color3.new(1,1,1) then Lighting.OutdoorAmbient = Color3.new(1,1,1) end
        if Lighting.ColorShift_Top ~= Color3.new(0,0,0) then Lighting.ColorShift_Top = Color3.new(0,0,0) end
        if Lighting.FogStart ~= 100000 then Lighting.FogStart = 100000 end
        if Lighting.FogEnd ~= 100000 then Lighting.FogEnd = 100000 end
    end)
end

function FullBright_Disable()
    if not FullBright_Enabled then return end
    FullBright_Enabled = false
    if FullBright_Connection then FullBright_Connection:Disconnect() FullBright_Connection = nil end
    Lighting.Brightness = OriginalValues.Brightness
    Lighting.ClockTime = OriginalValues.ClockTime
    Lighting.Ambient = OriginalValues.Ambient
    Lighting.OutdoorAmbient = OriginalValues.OutdoorAmbient
    Lighting.ColorShift_Top = OriginalValues.ColorShift_Top
    Lighting.FogStart = OriginalValues.FogStart
    Lighting.FogEnd = OriginalValues.FogEnd
end

-- FOV
local Fov_Enabled = false
local Fov_Value = 80
local Camera = workspace.CurrentCamera
local Original_Fov = Camera.FieldOfView

function Fov_Enable()
    Fov_Enabled = true
end

function Fov_Disable()
    Fov_Enabled = false
    Camera.FieldOfView = Original_Fov
end

RunService.RenderStepped:Connect(function()
    if Fov_Enabled then Camera.FieldOfView = Fov_Value end
end)

-- Noclip
local Noclip_Enabled = false
local Noclip_Connection = nil
local originalCollisions = {}

function Noclip_Enable()
    if Noclip_Enabled then return end
    Noclip_Enabled = true
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                originalCollisions[part] = true
                part.CanCollide = false
            end
        end
    end
    if not Noclip_Connection then
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
end

function Noclip_Disable()
    if not Noclip_Enabled then return end
    Noclip_Enabled = false
    if Noclip_Connection then Noclip_Connection:Disconnect() Noclip_Connection = nil end
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and originalCollisions[part] then
                part.CanCollide = true
            end
        end
    end
    originalCollisions = {}
end

-- Admin Check
local AdminCheck_Enabled = false
local AdminCheck_Connection = nil

local staffPlayers = {
    groups = {
        [4793755] = { -- Criminality
            ["Tester"] = true, ["Contributor"] = true, ["Tester+"] = true,
            ["Developer"] = true, ["Developer+"] = true,
            ["Community Manager"] = true, ["Manager"] = true, ["Owner"] = true
        },
        [4165692] = { ["Tester"] = true, ["Contributor"] = true, ["Tester+"] = true, ["Developer"] = true,
            ["Developer+"] = true, ["Community Manager"] = true, ["Manager"] = true, ["Owner"] = true },
        [32406137] = { ["Junior"] = true, ["Moderator"] = true, ["Senior"] = true, ["Administrator"] = true,
            ["Manager"] = true, ["Holder"] = true },
    },
    users = {
        3294804378, 93676120, 54087314, 81275825, 140837601, 1229486091, 46567801, 418086275, 29706395,
        3717066084, 1424338327, 5046662686, 5046661126, 5046659439, 418199326, 1024216621, 1810535041,
        63238912, 111250044, 63315426, 730176906, 141193516, 194512073, 193945439, 412741116, 195538733,
        102045519, 955294, 957835150, 25689921, 366613818, 281593651, 455275714, 208929505, 96783330,
        156152502, 93281166, 959606619, 142821118, 632886139, 175931803, 122209625, 278097946, 142989311,
        1517131734, 446849296, 87189764, 67180844, 9212846, 47352513, 48058122, 155413858, 10497435,
        513615792, 55893752, 55476024, 151691292, 136584758, 16983447, 3111449, 94693025, 271400893,
        5005262660, 295331237, 64489098, 244844600, 114332275, 25048901, 69262878, 50801509, 92504899,
        42066711, 50585425, 31365111, 166406495, 2457253857, 29761878, 21831137, 948293345, 439942262,
        38578487, 1163048, 7713309208, 3659305297, 15598614, 34616594, 626833004, 198610386, 153835477,
        3923114296, 3937697838, 102146039, 119861460, 371665775, 1206543842, 93428604, 1863173316, 90814576,
        374665997, 423005063, 140172831, 42662179, 9066859, 438805620, 14855669, 727189337, 1871290386,
        608073286
    }
}

local function hasTracker(player)
    if not player or not player:IsA("Player") then return false, nil end
    local children = player:GetChildren()
    for i = 1, #children do
        local child = children[i]
        if typeof(child.Name) == "string" and string.sub(child.Name, -8) == "Tracker$" then
            local trackedPlayerName = string.sub(child.Name, 1, -9)
            if Players:FindFirstChild(trackedPlayerName) then return true, trackedPlayerName end
        end
    end
    return false, nil
end

local function isStaff(player)
    if not player or not player:IsA("Player") then return false end
    if staffPlayers.groups then
        for groupID, roles in pairs(staffPlayers.groups) do
            local successRank, rank = pcall(function() return player:GetRankInGroup(groupID) end)
            if successRank and rank and rank > 0 then
                local successRole, roleName = pcall(function() return player:GetRoleInGroup(groupID) end)
                if successRole and roleName and roles[roleName] then return true, roleName, groupID end
            end
        end
    end
    if staffPlayers.users then
        for i = 1, #staffPlayers.users do
            if player.UserId == staffPlayers.users[i] then return true, "UserID", player.UserId end
        end
    end
    return false
end

local function kickformat(staffInfo)
    if not staffInfo or not staffInfo.Staff then return "Staff detected." end
    local message = "Staff detected:\n"
    for i, staff in ipairs(staffInfo.Staff) do
        local idType = "Role"
        local idValue = staff.Role or "Unknown"
        if staff.Role == "UserID" then idType = "UserID" idValue = staff.GroupId or "Unknown"
        elseif staff.Role == "Tracker User" then idType = "Tracker" idValue = "Active" end
        message = message .. string.format("- %s (%s: %s)%s", staff.Name or "Unknown", idType, idValue, staff.TrackedPlayer and " - Tracking: " .. staff.TrackedPlayer or "")
        if i < #staffInfo.Staff then message = message .. "\n" end
    end
    return message
end

local function kickWithStaffInfo(staffInfo)
    local kickMsg = kickformat(staffInfo)
    if LocalPlayer then LocalPlayer:Kick("Staff joined\n\n" .. kickMsg) end
end

local function checkCurrentStaff()
    local staffFound = {}
    local currentPlayers = Players:GetPlayers()
    for i = 1, #currentPlayers do
        local player = currentPlayers[i]
        if player ~= LocalPlayer then
            local isPlayerStaff, role, groupID = isStaff(player)
            local hasTrackers, trackedPlayer = hasTracker(player)
            if isPlayerStaff or hasTrackers then
                table.insert(staffFound, { Name = player.Name, Role = hasTrackers and "Tracker User" or role, GroupId = groupID, TrackedPlayer = trackedPlayer })
            end
        end
    end
    if #staffFound > 0 then kickWithStaffInfo({Staff = staffFound}) return true end
    return false
end

local function onPlayerJoining(player)
    if not AdminCheck_Enabled then return end
    local isPlayerStaff, role, groupID = isStaff(player)
    local hasTrackers, trackedPlayer = hasTracker(player)
    if isPlayerStaff or hasTrackers then
        local staffInfo = { Staff = {{ Name = player.Name, Role = hasTrackers and "Tracker User" or role, GroupId = groupID, TrackedPlayer = trackedPlayer }}}
        kickWithStaffInfo(staffInfo)
    end
end

function AdminCheck_Enable()
    if AdminCheck_Enabled then return end
    AdminCheck_Enabled = true
    if AdminCheck_Connection then AdminCheck_Connection:Disconnect() end
    AdminCheck_Connection = Players.PlayerAdded:Connect(onPlayerJoining)
    pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Staff Detection", Text = "Monitoring active", Duration = 5 }) end)
    task.spawn(function() checkCurrentStaff() end)
end

function AdminCheck_Disable()
    if not AdminCheck_Enabled then return end
    AdminCheck_Enabled = false
    if AdminCheck_Connection then AdminCheck_Connection:Disconnect() AdminCheck_Connection = nil end
end

-- Anti AFK
local AntiAFK_Enabled_Dummy = true
function AntiAFK_Enable() AntiAFK_Enabled_Dummy = true end
function AntiAFK_Disable() AntiAFK_Enabled_Dummy = false end

-- Melee Aura
local MeleeAura_Enabled = false
local MeleeAura_Connection = nil

local function runAttackLoop()
    local plrs = Players
    local me = LocalPlayer
    local run = RunService
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local eventsFolder = replicatedStorage:WaitForChild("Events")
    local remoteFunctionPath = "XMHH.2"
    local remoteEventPath = "XMHH2.2"
    local remote1 = eventsFolder:WaitForChild(remoteFunctionPath)
    local remote2 = eventsFolder:WaitForChild(remoteEventPath)
    local maxdist = 5

    local function Attack(target)
        if not (target and target:FindFirstChild("Head")) then return end
        local char = me.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not remote1 or not remote1:IsA("RemoteFunction") then MeleeAura_Disable() return end
        if not remote2 or not remote2:IsA("RemoteEvent") then MeleeAura_Disable() return end

        local arg1 = { [1] = "🍞", [2] = tick(), [3] = tool, [4] = "43TRFWX", [5] = "Normal", [6] = tick(), [7] = true }
        local success1, result = pcall(function() return remote1:InvokeServer(unpack(arg1)) end)
        if not success1 then return end
        task.wait(0.1)
        local Handle = tool and (tool:FindFirstChild("WeaponHandle") or tool:FindFirstChild("Handle")) or (char and char:FindFirstChild("Right Arm"))
        local head = target:FindFirstChild("Head")
        if Handle and head and hrp then
            local arg2 = { [1] = "🍞", [2] = tick(), [3] = tool, [4] = "2389ZFX34", [5] = result, [6] = false, [7] = Handle, [8] = head, [9] = target, [10] = hrp.Position, [11] = head.Position }
            pcall(function() remote2:FireServer(unpack(arg2)) end)
        end
    end

    return run.RenderStepped:Connect(function()
        if not MeleeAura_Enabled then return end
        local char = me.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, plr in ipairs(plrs:GetPlayers()) do
                if plr ~= me then
                    local c = plr.Character
                    local hrp2 = c and c:FindFirstChild("HumanoidRootPart")
                    local hum = c and c:FindFirstChildOfClass("Humanoid")
                    if hrp2 and hum then
                        local dist = (hrp.Position - hrp2.Position).Magnitude
                        if dist < maxdist and hum.Health > 15 and not c:FindFirstChildOfClass("ForceField") then
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
    if MeleeAura_Connection and MeleeAura_Connection.Connected then MeleeAura_Connection:Disconnect() end
    MeleeAura_Connection = runAttackLoop()
end

function MeleeAura_Disable()
    if not MeleeAura_Enabled then return end
    MeleeAura_Enabled = false
    if MeleeAura_Connection and MeleeAura_Connection.Connected then
        MeleeAura_Connection:Disconnect()
        MeleeAura_Connection = nil
    end
end

-- Ragebot
local Ragebot_Enabled = false
local Ragebot_Coroutine = nil
local Ragebot_Target = nil
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventsFolder = ReplicatedStorage:WaitForChild("Events", 10)
local GNX_S_Remote = EventsFolder and EventsFolder:WaitForChild("GNX_S", 5)
local ZFKLF_H_Remote = EventsFolder and EventsFolder:WaitForChild("ZFKLF__H", 5)

local function RandomString(length)
    local res = ""
    for i = 1, length do res = res .. string.char(math.random(97, 122)) end
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
        if typeof(Ragebot_Disable) == "function" then Ragebot_Disable() end
        return
    end
    pcall(function() GNX_S_Remote:FireServer(tick(), randomKey, tool, "FDS9I83", currentCam.CFrame.Position, {hitDirection}, false) end)
    pcall(function() ZFKLF_H_Remote:FireServer("🧈", tool, randomKey, 1, targetPart, hitPosition, hitDirection, nil, nil) end)
end

local function RagebotLoop()
    while Ragebot_Enabled do
        local target = GetClosestEnemy_Rage()
        Ragebot_Target = target
        if target then Shoot_Rage(target) task.wait(0.05)
        else task.wait(0.1) end
    end
    Ragebot_Target = nil
    Ragebot_Coroutine = nil
end

function Ragebot_Enable()
    if not GNX_S_Remote or not ZFKLF_H_Remote then
        warn("Ragebot cannot enable: Required remotes missing.")
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

-- Aimbot
local players_aim = Players
local localPlayer_aim = LocalPlayer
local CurrentCamera_aim = workspace.CurrentCamera
local TweenService_aim = TweenService
local UserInputService_aim = UserInputService
local mouseLocation_aim = UserInputService_aim.GetMouseLocation
local RunService_aim = RunService

local AimBotSettings = {
    Enabled = false; TeamCheck = false; WallCheck = true; StickyAim = false;
    UseMouse = true; MouseBind = "MouseButton2"; Keybind = nil;
    ShowFov = false; Fov = 100;
    Smoothing = 0.02; AimPart = "HumanoidRootPart";
    IsAimKeyDown = false; Target = nil; CameraTween = nil;
}

local function IsAlive_aim(Player)
    return Player and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") and Player.Character.Humanoid.Health > 0
end

local function GetTeam_aim(Player)
    if not localPlayer_aim.Neutral and Player and Player.Team and game:GetService("Teams"):FindFirstChild(Player.Team.Name) then
        return game:GetService("Teams")[Player.Team.Name]
    end
    return nil
end

local function isVisible_aim(targetPosition, character)
    if not AimBotSettings.WallCheck then return true end
    local ignoreList = {CurrentCamera_aim}
    if localPlayer_aim.Character then table.insert(ignoreList, localPlayer_aim.Character) end
    if character and character:FindFirstChild("Head") and character.Head.Parent then table.insert(ignoreList, character.Head.Parent) end
    local success, obscured = pcall(function() return CurrentCamera_aim:GetPartsObscuringTarget({targetPosition}, ignoreList) end)
    if not success or obscured == nil then return false end
    return #obscured == 0
end

local function CameraGetClosestToMouse_aim()
    local AimFov = AimBotSettings.Fov
    local targetPlayer = nil
    for i, v in pairs(players_aim:GetPlayers()) do
        if v ~= localPlayer_aim then
            if AimBotSettings.TeamCheck ~= true or GetTeam_aim(v) ~= GetTeam_aim(localPlayer_aim) then
                if IsAlive_aim(v) then
                    local char = v.Character
                    local aimPartInstance = char and char:FindFirstChild(AimBotSettings.AimPart)
                    if aimPartInstance then
                        local aimPartPosition = aimPartInstance.Position
                        local successWTV, screen_pos, on_screen = pcall(function() return CurrentCamera_aim:WorldToViewportPoint(aimPartPosition) end)
                        if successWTV and on_screen then
                            local screen_pos_2D = Vector2.new(screen_pos.X, screen_pos.Y)
                            local successMouseLoc, mousePos = pcall(mouseLocation_aim, UserInputService_aim)
                            if not successMouseLoc then mousePos = Vector2.new() end
                            local new_magnitude = (screen_pos_2D - mousePos).Magnitude
                            if new_magnitude < AimFov and isVisible_aim(aimPartPosition, char) then
                                AimFov = new_magnitude
                                targetPlayer = v
                            end
                        end
                    end
                end
            end
        end
    end
    return targetPlayer
end

UserInputService_aim.InputBegan:Connect(function(input, gameProcessedEvent)
    if not AimBotSettings then return end
    if gameProcessedEvent or not AimBotSettings.Enabled then return end
    if not AimBotSettings.UseMouse and AimBotSettings.Keybind and input.KeyCode == AimBotSettings.Keybind then
        AimBotSettings.Target = CameraGetClosestToMouse_aim()
        AimBotSettings.IsAimKeyDown = true
    elseif AimBotSettings.UseMouse then
        local bind = ""
        if input.UserInputType == Enum.UserInputType.MouseButton1 then bind = "MouseButton1"
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then bind = "MouseButton2" end
        if bind == AimBotSettings.MouseBind then
            AimBotSettings.Target = CameraGetClosestToMouse_aim()
            AimBotSettings.IsAimKeyDown = true
        end
    end
end)

UserInputService_aim.InputEnded:Connect(function(input, gameProcessedEvent)
    if not AimBotSettings then return end
    if gameProcessedEvent or not AimBotSettings.Enabled then return end
    if not AimBotSettings.UseMouse and AimBotSettings.Keybind and input.KeyCode == AimBotSettings.Keybind then
        AimBotSettings.IsAimKeyDown = false; AimBotSettings.Target = nil
        if AimBotSettings.CameraTween then AimBotSettings.CameraTween:Cancel(); AimBotSettings.CameraTween = nil end
    elseif AimBotSettings.UseMouse then
        local bind = ""
        if input.UserInputType == Enum.UserInputType.MouseButton1 then bind = "MouseButton1"
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then bind = "MouseButton2" end
        if bind == AimBotSettings.MouseBind then
            AimBotSettings.IsAimKeyDown = false; AimBotSettings.Target = nil
            if AimBotSettings.CameraTween then AimBotSettings.CameraTween:Cancel(); AimBotSettings.CameraTween = nil end
        end
    end
end)

RunService_aim.Heartbeat:Connect(function(deltaTime)
    if AimBotSettings and AimBotSettings.Enabled then
        if AimBotSettings.IsAimKeyDown then
            local currentTarget = AimBotSettings.Target
            if AimBotSettings.StickyAim then
                if currentTarget ~= nil and IsAlive_aim(currentTarget) then
                    local targetChar = currentTarget.Character
                    local aimPart = targetChar and targetChar:FindFirstChild(AimBotSettings.AimPart)
                    if aimPart then
                        if AimBotSettings.CameraTween then AimBotSettings.CameraTween:Cancel(); AimBotSettings.CameraTween = nil end
                        local networkPing = 0
                        local successPing, resultPing = pcall(function() return localPlayer_aim:GetNetworkPing() end)
                        if successPing then networkPing = resultPing end
                        local predictionOffset = aimPart.Velocity and aimPart.Velocity * (networkPing * 0.1) or Vector3.new()
                        local targetCFrame = CFrame.new(CurrentCamera_aim.CFrame.Position, aimPart.Position + predictionOffset)
                        local successTween, tweenResult = pcall(function()
                            AimBotSettings.CameraTween = TweenService_aim:Create(CurrentCamera_aim, TweenInfo.new(AimBotSettings.Smoothing, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = targetCFrame})
                            AimBotSettings.CameraTween:Play()
                        end)
                    else
                        AimBotSettings.Target = nil
                        if AimBotSettings.CameraTween then AimBotSettings.CameraTween:Cancel(); AimBotSettings.CameraTween = nil end
                    end
                else
                    local newTarget = CameraGetClosestToMouse_aim()
                    AimBotSettings.Target = newTarget
                    currentTarget = newTarget
                    if currentTarget and IsAlive_aim(currentTarget) then
                        local targetChar = currentTarget.Character
                        local aimPart = targetChar and targetChar:FindFirstChild(AimBotSettings.AimPart)
                        if aimPart then
                            if AimBotSettings.CameraTween then AimBotSettings.CameraTween:Cancel(); AimBotSettings.CameraTween = nil end
                            local networkPing = 0; local sP, rP=pcall(function() return localPlayer_aim:GetNetworkPing() end); if sP then networkPing=rP end
                            local predictionOffset = aimPart.Velocity and aimPart.Velocity * (networkPing * 0.1) or Vector3.new()
                            local targetCFrame = CFrame.new(CurrentCamera_aim.CFrame.Position, aimPart.Position + predictionOffset)
                            local sT, tR = pcall(function()
                                AimBotSettings.CameraTween = TweenService_aim:Create(CurrentCamera_aim, TweenInfo.new(AimBotSettings.Smoothing, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = targetCFrame})
                                AimBotSettings.CameraTween:Play()
                            end)
                        end
                    elseif AimBotSettings.CameraTween then
                        AimBotSettings.CameraTween:Cancel(); AimBotSettings.CameraTween = nil
                    end
                end
            else
                local target = CameraGetClosestToMouse_aim()
                if target ~= nil and IsAlive_aim(target) then
                    local targetChar = target.Character
                    local aimPart = targetChar and targetChar:FindFirstChild(AimBotSettings.AimPart)
                    if aimPart then
                        if AimBotSettings.CameraTween then AimBotSettings.CameraTween:Cancel(); AimBotSettings.CameraTween = nil end
                        local networkPing = 0; local sP, rP=pcall(function() return localPlayer_aim:GetNetworkPing() end); if sP then networkPing=rP end
                        local predictionOffset = aimPart.Velocity and aimPart.Velocity * (networkPing * 0.1) or Vector3.new()
                        local targetCFrame = CFrame.new(CurrentCamera_aim.CFrame.Position, aimPart.Position + predictionOffset)
                        local sT, tR = pcall(function()
                            AimBotSettings.CameraTween = TweenService_aim:Create(CurrentCamera_aim, TweenInfo.new(AimBotSettings.Smoothing, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = targetCFrame})
                            AimBotSettings.CameraTween:Play()
                        end)
                    else
                        if AimBotSettings.CameraTween then AimBotSettings.CameraTween:Cancel(); AimBotSettings.CameraTween = nil end
                    end
                elseif AimBotSettings.CameraTween ~= nil then
                    AimBotSettings.CameraTween:Cancel(); AimBotSettings.CameraTween = nil
                end
            end
        end
    end
end)

function Aimbot_Enable()
    if AimBotSettings then AimBotSettings.Enabled=true else warn("Cannot enable Aimbot: AimBotSettings is nil") end
end

function Aimbot_Disable()
    if AimBotSettings then
        AimBotSettings.Enabled=false; AimBotSettings.IsAimKeyDown=false; AimBotSettings.Target=nil
        if AimBotSettings.CameraTween then AimBotSettings.CameraTween:Cancel(); AimBotSettings.CameraTween=nil end
    else warn("Cannot disable Aimbot: AimBotSettings is nil") end
end

-- Infinite Stamina
local isInfiniteStaminaEnabled = false
local oldStaminaFunction = nil
local targetFunction = nil

do
    local success_hook, result_hook = pcall(function()
        local env = nil
        local success_env1, env1 = pcall(getrenv)
        if success_env1 then env = env1 else local success_env2, env2 = pcall(getfenv); if success_env2 then env = env2 end end
        if env and env._G and env._G.S_Take then
            local success_upval, upval = pcall(getupvalue, env._G.S_Take, 2)
            if success_upval and type(upval) == 'function' then targetFunction = upval end
        end
        if targetFunction then
            local hookSuccess, hookResult = pcall(function()
                oldStaminaFunction = hookfunction(targetFunction, function(v1, ...)
                    local args = {...}
                    if isInfiniteStaminaEnabled then return oldStaminaFunction(0, unpack(args))
                    else return oldStaminaFunction(v1, unpack(args)) end
                end)
            end)
            if not hookSuccess then oldStaminaFunction = nil end
        end
    end)
end

function InfiniteStamina_Enable()
    if not oldStaminaFunction then return end
    isInfiniteStaminaEnabled = true
end

function InfiniteStamina_Disable()
    isInfiniteStaminaEnabled = false
end

-- No Recoil
local NoRecoil_Enabled=false
local NoRecoil_Connections={}
local GlobalOriginalValues={}
local WeaponCache={}
local Settings_nr={GunMods={NoRecoil=true,Spread=true,SpreadAmount=0}}
local Player_nr=LocalPlayer

local function cacheWeapons()
    WeaponCache={}
    for _, v in pairs(getgc(true)) do
        if type(v)=='table' and rawget(v,'EquipTime') then
            table.insert(WeaponCache, v)
            if not GlobalOriginalValues[v] then
                GlobalOriginalValues[v]={
                    Recoil=v.Recoil,CameraRecoilingEnabled=v.CameraRecoilingEnabled,
                    AngleX_Min=v.AngleX_Min,AngleX_Max=v.AngleX_Max,
                    AngleY_Min=v.AngleY_Min,AngleY_Max=v.AngleY_Max,
                    AngleZ_Min=v.AngleZ_Min,AngleZ_Max=v.AngleZ_Max,
                    Spread=v.Spread
                }
            end
        end
    end
end

local function applyGunMods()
    for _, weapon in ipairs(WeaponCache) do
        if Settings_nr.GunMods.NoRecoil then
            weapon.Recoil=0; weapon.CameraRecoilingEnabled=false;
            weapon.AngleX_Min=0; weapon.AngleX_Max=0;
            weapon.AngleY_Min=0; weapon.AngleY_Max=0;
            weapon.AngleZ_Min=0; weapon.AngleZ_Max=0;
        end
        if Settings_nr.GunMods.Spread then weapon.Spread=Settings_nr.GunMods.SpreadAmount end
    end
end

local function resetGunMods()
    for weapon, values in pairs(GlobalOriginalValues) do
        weapon.Recoil=values.Recoil; weapon.CameraRecoilingEnabled=values.CameraRecoilingEnabled;
        weapon.AngleX_Min=values.AngleX_Min; weapon.AngleX_Max=values.AngleX_Max;
        weapon.AngleY_Min=values.AngleY_Min; weapon.AngleY_Max=values.AngleY_Max;
        weapon.AngleZ_Min=values.AngleZ_Min; weapon.AngleZ_Max=values.AngleZ_Max;
        weapon.Spread=values.Spread;
    end
end

local function handleWeapon(weapon)
    if NoRecoil_Enabled then
        task.wait(0.1); cacheWeapons(); applyGunMods()
    end
end

local function onCharacterAdded_nr(character)
    for _, child in ipairs(character:GetChildren()) do if child:IsA("Tool") then handleWeapon(child) end end
    table.insert(NoRecoil_Connections, character.ChildAdded:Connect(function(child) if child:IsA("Tool") then handleWeapon(child) end end))
    local humanoid=character:WaitForChild("Humanoid",2)
    if humanoid then
        table.insert(NoRecoil_Connections, humanoid.Died:Connect(function() if NoRecoil_Enabled then task.wait(1.5); cacheWeapons(); applyGunMods() end end))
    end
end

function NoRecoil_Enable()
    if NoRecoil_Enabled then return end
    NoRecoil_Enabled=true
    cacheWeapons(); applyGunMods()
    table.insert(NoRecoil_Connections, Player_nr.CharacterAdded:Connect(onCharacterAdded_nr))
    if Player_nr.Character then onCharacterAdded_nr(Player_nr.Character) end
end

function NoRecoil_Disable()
    if not NoRecoil_Enabled then return end
    NoRecoil_Enabled=false
    resetGunMods()
    for _, conn in ipairs(NoRecoil_Connections) do conn:Disconnect() end
    NoRecoil_Connections={}
end

-- ESP (DÜZELTİLDİ)
local ESP_Enabled=false
local ESP_Loading=false
local LastToggleTime=0
local DEBOUNCE_TIME=0.5
local ESP_Connection = nil
local ESP_Objects = {}

function ESP_Enable()
    if os.clock()-LastToggleTime<DEBOUNCE_TIME then return end
    LastToggleTime=os.clock()
    if ESP_Loading or ESP_Enabled then return end
    ESP_Loading=true
    
    local success, err = pcall(function()
        -- Önce eski ESP'leri temizle
        ESP_Disable()
        
        -- Yeni ESP sistemi
        local function createESP(player)
            if player == LocalPlayer then return end
            if ESP_Objects[player] then return end
            
            local char = player.Character
            if not char then return end
            
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local espGui = Instance.new("BillboardGui")
            espGui.Name = "ESP_Gui"
            espGui.Size = UDim2.new(0, 200, 0, 50)
            espGui.AlwaysOnTop = true
            espGui.Adornee = hrp
            espGui.MaxDistance = 500
            espGui.Parent = hrp
            
            local nameLabel = Instance.new("TextLabel", espGui)
            nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextSize = 14
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextStrokeTransparency = 0.3
            nameLabel.Position = UDim2.new(0, 0, 0, 0)
            
            local distLabel = Instance.new("TextLabel", espGui)
            distLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distLabel.Position = UDim2.new(0, 0, 0.5, 0)
            distLabel.BackgroundTransparency = 1
            distLabel.Text = ""
            distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            distLabel.TextSize = 12
            distLabel.Font = Enum.Font.Gotham
            
            local healthBar = Instance.new("Frame", espGui)
            healthBar.Size = UDim2.new(0.8, 0, 0, 4)
            healthBar.Position = UDim2.new(0.1, 0, 1, -6)
            healthBar.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            healthBar.BorderSizePixel = 0
            
            local healthBg = Instance.new("Frame", espGui)
            healthBg.Size = UDim2.new(0.8, 0, 0, 4)
            healthBg.Position = UDim2.new(0.1, 0, 1, -6)
            healthBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            healthBg.BorderSizePixel = 0
            healthBg.ZIndex = 0
            
            ESP_Objects[player] = {
                Gui = espGui,
                NameLabel = nameLabel,
                DistLabel = distLabel,
                HealthBar = healthBar,
                HealthBg = healthBg
            }
            
            -- Update loop for this player
            task.spawn(function()
                while ESP_Enabled and ESP_Objects[player] do
                    task.wait(0.1)
                    local char2 = player.Character
                    if not char2 then break end
                    local hum = char2:FindFirstChildOfClass("Humanoid")
                    if not hum then break end
                    
                    local hrp2 = char2:FindFirstChild("HumanoidRootPart")
                    if not hrp2 then break end
                    
                    local myChar = LocalPlayer.Character
                    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if myHrp then
                        local dist = (myHrp.Position - hrp2.Position).Magnitude
                        ESP_Objects[player].DistLabel.Text = math.floor(dist) .. " studs"
                    end
                    
                    local health = hum.Health / hum.MaxHealth
                    ESP_Objects[player].HealthBar.Size = UDim2.new(0.8 * health, 0, 0, 4)
                    
                    if health > 0.6 then
                        ESP_Objects[player].HealthBar.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                    elseif health > 0.3 then
                        ESP_Objects[player].HealthBar.BackgroundColor3 = Color3.fromRGB(200, 200, 0)
                    else
                        ESP_Objects[player].HealthBar.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
                    end
                end
            end)
        end
        
        -- PlayerAdded listener
        ESP_Connection = Players.PlayerAdded:Connect(createESP)
        
        -- Mevcut oyuncular için ESP oluştur
        for _, player in ipairs(Players:GetPlayers()) do
            createESP(player)
        end
        
        ESP_Enabled = true
        ESP_Loading = false
    end)
    
    if not success then
        warn("ESP Error: "..tostring(err))
        ESP_Loading = false
        ESP_Enabled = false
    end
end

function ESP_Disable()
    if os.clock()-LastToggleTime<DEBOUNCE_TIME then return end
    LastToggleTime=os.clock()
    
    if ESP_Connection then
        ESP_Connection:Disconnect()
        ESP_Connection = nil
    end
    
    for player, data in pairs(ESP_Objects) do
        pcall(function()
            if data.Gui and data.Gui.Parent then
                data.Gui:Destroy()
            end
        end)
    end
    ESP_Objects = {}
    ESP_Enabled = false
end

-- Invisibility
local Invis_Fixed = true
do
    repeat task.wait() until game:IsLoaded()
    local cloneref = cloneref or function(...) return ... end
    local Service = setmetatable({}, { __index = function(_, k) return cloneref(game:GetService(k)) end })
    local Player_inv = Service.Players.LocalPlayer
    local Character_inv = Player_inv.Character or Player_inv.CharacterAdded:Wait()
    local Humanoid_inv
    local HumanoidRootPart_inv

    local function UpdateCharacterReferences()
        Character_inv = Player_inv.Character
        if Character_inv then
            HumanoidRootPart_inv = Character_inv:FindFirstChild("HumanoidRootPart")
            Humanoid_inv = Character_inv:FindFirstChildOfClass("Humanoid")
        else
            HumanoidRootPart_inv = nil; Humanoid_inv = nil
        end
    end
    UpdateCharacterReferences()

    local InvisEnabled = false
    local Track_inv = nil
    local Animation_inv = Instance.new("Animation")
    Animation_inv.AnimationId = "rbxassetid://215384594"
    local RunService_inv = Service.RunService
    local Heartbeat_inv = RunService_inv.Heartbeat
    local RenderStepped_inv = RunService_inv.RenderStepped
    local UserInputService_inv = Service.UserInputService
    local CoreGui_inv = Service.CoreGui
    local StarterGui_inv = Service.StarterGui

    if Character_inv and not Character_inv:FindFirstChild("Torso") then
        pcall(function() StarterGui_inv:SetCore("SendNotification", { Title = "Invisibility FAILED", Text = "Feature requires R6 Avatar.", Duration = 5 }) end)
        Invis_Fixed = false
    end

    local GUI_inv = Instance.new("ScreenGui")
    GUI_inv.Name = "InvisWarningGUI"
    GUI_inv.Parent = CoreGui_inv
    GUI_inv.ResetOnSpawn = false
    GUI_inv.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local WarnLabel_inv = Instance.new("TextLabel", GUI_inv)
    WarnLabel_inv.Text = "⚠️You are visible⚠️"
    WarnLabel_inv.Visible = false
    WarnLabel_inv.Size = UDim2.new(0, 200, 0, 30)
    WarnLabel_inv.Position = UDim2.new(0.5, -100, 0.85, 0)
    WarnLabel_inv.BackgroundTransparency = 1
    WarnLabel_inv.Font = Enum.Font.GothamSemibold
    WarnLabel_inv.TextSize = 24
    WarnLabel_inv.TextColor3 = Color3.fromRGB(255, 255, 0)
    WarnLabel_inv.TextStrokeTransparency = 0.5
    WarnLabel_inv.ZIndex = 10

    local function Grounded_inv()
        return Humanoid_inv and Humanoid_inv:IsDescendantOf(workspace) and Humanoid_inv.FloorMaterial ~= Enum.Material.Air
    end

    local function LoadAndPrepareTrack_inv()
        if Track_inv then pcall(function() Track_inv:Stop() end); Track_inv = nil end
        if Humanoid_inv then
            local success, result = pcall(function() return Humanoid_inv:LoadAnimation(Animation_inv) end)
            if success then Track_inv = result; Track_inv.Priority = Enum.AnimationPriority.Action4
            else Track_inv = nil end
        else Track_inv = nil end
    end

    function Invis_Disable()
        if not InvisEnabled then return end
        InvisEnabled = false
        if Track_inv then pcall(function() Track_inv:Stop() end) end
        if Humanoid_inv then workspace.CurrentCamera.CameraSubject = Humanoid_inv end
        if Character_inv then
            for _, v in pairs(Character_inv:GetDescendants()) do
                if v:IsA("BasePart") and v.Transparency == 0.5 then v.Transparency = 0 end
            end
        end
        WarnLabel_inv.Visible = false
    end

    function Invis_Enable()
        if InvisEnabled or not Invis_Fixed then return end
        UpdateCharacterReferences()
        if not Character_inv or not Humanoid_inv or not HumanoidRootPart_inv then return end
        if not Character_inv:FindFirstChild("Torso") then
            pcall(function() StarterGui_inv:SetCore("SendNotification", { Title = "Invisibility FAILED", Text = "Feature requires R6 Avatar.", Duration = 5 }) end)
            return
        end
        InvisEnabled = true
        workspace.CurrentCamera.CameraSubject = HumanoidRootPart_inv
        LoadAndPrepareTrack_inv()
    end

    Player_inv.CharacterAdded:Connect(function(NewCharacter)
        if Track_inv then pcall(function() Track_inv:Stop() end); Track_inv = nil end
        task.wait()
        UpdateCharacterReferences()
        if not Humanoid_inv then
            task.wait(0.5); UpdateCharacterReferences()
            if not Humanoid_inv then
                Invis_Fixed = false
                if InvisEnabled then Invis_Disable() end
                pcall(function() StarterGui_inv:SetCore("SendNotification", { Title = "Invisibility Error", Text = "Could not verify character type.", Duration = 5 }) end)
                return
            end
        end
        if Humanoid_inv.RigType ~= Enum.HumanoidRigType.R6 then
            Invis_Fixed = false
            if InvisEnabled then Invis_Disable() end
            pcall(function() StarterGui_inv:SetCore("SendNotification", { Title = "Invisibility Warning", Text = "Non-R6 Avatar detected ("..tostring(Humanoid_inv.RigType).."). Invisibility disabled.", Duration = 5 }) end)
            return
        else Invis_Fixed = true end
        if InvisEnabled then
            if HumanoidRootPart_inv then workspace.CurrentCamera.CameraSubject = HumanoidRootPart_inv end
            LoadAndPrepareTrack_inv()
        end
    end)

    Player_inv.CharacterRemoving:Connect(function(OldCharacter)
        if Track_inv then pcall(function() Track_inv:Stop() end); Track_inv = nil end
        WarnLabel_inv.Visible = false
    end)

    Heartbeat_inv:Connect(function(deltaTime)
        if not InvisEnabled or not Invis_Fixed then
            if not InvisEnabled and Character_inv then
                for _, v in pairs(Character_inv:GetDescendants()) do
                    if v:IsA("BasePart") and v.Transparency == 0.5 then v.Transparency = 0 end
                end
            end
            WarnLabel_inv.Visible = false
            return
        end
        if not Character_inv or not Humanoid_inv or not HumanoidRootPart_inv or not Humanoid_inv:IsDescendantOf(workspace) or Humanoid_inv.Health <= 0 then
            WarnLabel_inv.Visible = false
            return
        end
        WarnLabel_inv.Visible = not Grounded_inv()
        local speed = 12
        if Humanoid_inv.MoveDirection.Magnitude > 0 then
            local offset = Humanoid_inv.MoveDirection * speed * deltaTime
            HumanoidRootPart_inv.CFrame = HumanoidRootPart_inv.CFrame + offset
        end
        local OldCFrame = HumanoidRootPart_inv.CFrame
        local OldCameraOffset = Humanoid_inv.CameraOffset
        local _, y = workspace.CurrentCamera.CFrame:ToOrientation()
        HumanoidRootPart_inv.CFrame = CFrame.new(HumanoidRootPart_inv.CFrame.Position) * CFrame.fromOrientation(0, y, 0)
        HumanoidRootPart_inv.CFrame = HumanoidRootPart_inv.CFrame * CFrame.Angles(math.rad(90), 0, 0)
        Humanoid_inv.CameraOffset = Vector3.new(0, 1.44, 0)
        if Track_inv then
            local successPlay, errPlay = pcall(function()
                if not Track_inv.IsPlaying then Track_inv:Play() end
                Track_inv:AdjustSpeed(0); Track_inv.TimePosition = 0.3
            end)
            if not successPlay then LoadAndPrepareTrack_inv() end
        elseif Humanoid_inv and Humanoid_inv.Health > 0 then LoadAndPrepareTrack_inv() end
        RenderStepped_inv:Wait()
        if Humanoid_inv and Humanoid_inv:IsDescendantOf(workspace) then Humanoid_inv.CameraOffset = OldCameraOffset end
        if HumanoidRootPart_inv and HumanoidRootPart_inv:IsDescendantOf(workspace) then HumanoidRootPart_inv.CFrame = OldCFrame end
        if Track_inv then pcall(function() Track_inv:Stop() end) end
        if HumanoidRootPart_inv and HumanoidRootPart_inv:IsDescendantOf(workspace) then
            local LookVector = workspace.CurrentCamera.CFrame.LookVector
            local Horizontal = Vector3.new(LookVector.X, 0, LookVector.Z).Unit
            if Horizontal.Magnitude > 0.1 then
                local TargetCFrame = CFrame.new(HumanoidRootPart_inv.Position, HumanoidRootPart_inv.Position + Horizontal)
                HumanoidRootPart_inv.CFrame = TargetCFrame
            end
        end
        if Character_inv then
            for _, v in pairs(Character_inv:GetDescendants()) do
                if (v:IsA("BasePart") and v.Transparency ~= 1) then v.Transparency = 0.5 end
            end
        end
    end)

    _G.Invis_Enable = Invis_Enable
    _G.Invis_Disable = Invis_Disable
    _G.IsInvisEnabled = function() return InvisEnabled end
end

-- Autofarm
local autofarmEnabled = false
local autofarmCooldown = false
local ignoredSafes = {}

local function hasTool(toolName)
    local backpackTool = LocalPlayer.Backpack:FindFirstChild(toolName)
    local characterTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(toolName)
    return backpackTool or characterTool
end

local function teleportTo(targetPart)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart", 10)
    if not hrp then return false end
    if not (targetPart and targetPart:IsA("BasePart")) then return false end
    local success = false
    local attempts = 0
    while not success and attempts < 4 do
        local targetCframe = targetPart.CFrame
        local targetPos = (targetCframe + targetCframe.LookVector * 2).Position
        hrp.CFrame = CFrame.new(targetPos) * CFrame.Angles(0, math.pi / 2, 0)
        task.wait(0.5)
        local isStable = true
        for i = 1, 10 do
            task.wait(0.2)
            if not hrp or not hrp.Parent then isStable = false break end
            if (hrp.Position - targetPos).Magnitude > 5 then isStable = false break end
        end
        if isStable then success = true else attempts = attempts + 1 task.wait(1) end
    end
    return success
end

local function findNearestTarget(targetsToIgnore)
    local bredMakurzFolder = workspace.Map:FindFirstChild("BredMakurz") or workspace.Filter:FindFirstChild("BredMakurz")
    local char = LocalPlayer.Character
    if not bredMakurzFolder or not char then return nil end
    local nearestTarget = nil
    local shortestDistance = math.huge
    local playerPosition = char:FindFirstChild("HumanoidRootPart").Position
    for _, v in ipairs(bredMakurzFolder:GetChildren()) do
        if (string.find(v.Name, "Safe") or string.find(v.Name, "Register")) and not table.find(targetsToIgnore, v) then
            local values = v:FindFirstChild("Values")
            if values then
                local broken = values:FindFirstChild("Broken")
                if broken and broken:IsA("BoolValue") and not broken.Value then
                    local targetPart = v.PrimaryPart or v:FindFirstChild("MainPart") or v:FindFirstChild("PosPart")
                    if targetPart then
                        local distance = (targetPart.Position - playerPosition).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            nearestTarget = v
                        end
                    end
                end
            end
        end
    end
    return nearestTarget
end

local function findNearestDealer()
    local shopz = workspace.Map:FindFirstChild("Shopz")
    local char = LocalPlayer.Character
    if not shopz or not char then return nil end
    local nearestDealer = nil
    local shortestDistance = math.huge
    local playerPosition = char:FindFirstChild("HumanoidRootPart").Position
    for _, dealer in ipairs(shopz:GetChildren()) do
        local crowbarStock = dealer:FindFirstChild("CurrentStocks") and dealer.CurrentStocks:FindFirstChild("Crowbar")
        if crowbarStock and crowbarStock.Value > 0 and dealer:FindFirstChild("MainPart") then
            local distance = (dealer.MainPart.Position - playerPosition).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestDealer = dealer
            end
        end
    end
    return nearestDealer
end

local function openSafe(safeModel)
    local equippedCrowbar = hasTool("Crowbar")
    if not equippedCrowbar then return end
    local remoteXMHH = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("XMHH.2")
    local remoteXMHH2 = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("XMHH2.2")
    local safeMainPart = safeModel:WaitForChild("MainPart", 5)
    if not safeMainPart then return end
    local startTime = tick()
    while safeModel and safeModel.Parent and safeModel.Values and safeModel.Values.Broken and not safeModel.Values.Broken.Value and (tick() - startTime < 15) do
        local char = LocalPlayer.Character
        if not char then break end
        local safeOpenValue = remoteXMHH:InvokeServer("🍞", tick(), equippedCrowbar, "DZDRRRKI", safeModel, "Register")
        if safeOpenValue == nil then task.wait(1) continue end
        local currentTime = tick()
        remoteXMHH2:FireServer("🍞", currentTime, equippedCrowbar, "2389ZFX34", safeOpenValue, false, char["Right Arm"], safeMainPart, safeModel, safeMainPart.Position, safeMainPart.Position)
        task.wait(0.2)
    end
    task.wait(8)
end

local ReplicatedStorage_af = game:GetService("ReplicatedStorage")
local deathRespawnEvent = ReplicatedStorage_af:WaitForChild("Events"):WaitForChild("DeathRespawn")

task.spawn(function()
    while true do
        task.wait(1)
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then Settings.IsDead = humanoid.Health <= 0 end
        if not autofarmEnabled or autofarmCooldown or not char or not humanoid or humanoid.Health <= 0 or (LocalPlayer:GetNetworkPing() * 1000 > 100) then continue end
        local crowbar = hasTool("Crowbar")
        if not crowbar then
            local dealer = findNearestDealer()
            if dealer then
                if teleportTo(dealer:WaitForChild("MainPart")) then
                    task.wait(1)
                    ReplicatedStorage_af.Events.BYZERSPROTEC:FireServer(true, "shop", dealer.MainPart, "IllegalStore")
                    task.wait(1)
                    local args = {"IllegalStore", "Melees", "Crowbar", dealer.MainPart, nil, true}
                    ReplicatedStorage_af.Events.SSHPRMTE1:InvokeServer(unpack(args))
                    task.wait(20)
                    ReplicatedStorage_af.Events.BYZERSPROTEC:FireServer(false)
                else task.wait(5) end
            else task.wait(10) end
        else
            local target = findNearestTarget(ignoredSafes)
            if target then
                ignoredSafes = {}
                if teleportTo(target:WaitForChild("MainPart")) then
                    if LocalPlayer.Character:FindFirstChild("Crowbar") == nil then
                        pcall(function() LocalPlayer.Character.Humanoid:EquipTool(crowbar) end)
                    end
                    task.wait(1)
                    openSafe(target)
                else
                    table.insert(ignoredSafes, target)
                    task.wait(0.5)
                end
            else
                ignoredSafes = {}
                task.wait(5)
            end
        end
    end
end)

task.spawn(function()
    while task.wait() do
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health <= 0 and autofarmEnabled then
                deathRespawnEvent:InvokeServer("KMG4R904")
                task.wait(2)
            end
        end
    end
end)

local function Collector_Activate()
    AutoPickupMoney_Enable()
end

local function Collector_Deactivate()
    AutoPickupMoney_Disable()
end

function Autofarm_Enable()
    if autofarmEnabled then return end
    autofarmEnabled = true
    _G.Invis_Enable()
    Collector_Activate()
    Noclip_Enable()
end

function Autofarm_Disable()
    if not autofarmEnabled then return end
    autofarmEnabled = false
    _G.Invis_Disable()
    Collector_Deactivate()
    Noclip_Disable()
end

LocalPlayer.CharacterAdded:Connect(function(character)
    if not autofarmEnabled then return end
    character:WaitForChild("HumanoidRootPart", 5)
    task.wait(1.5)
    autofarmCooldown = false
    ignoredSafes = {}
    Autofarm_Enable()
end)

-- Shadow Mode
local Shadow_Active = false
local Shadow_Usable = true

do
    repeat task.wait() until game:IsLoaded()
    local svc_ref = cloneref or function(...) return ... end
    local GS = setmetatable({}, { __index = function(_, k) return svc_ref(game:GetService(k)) end })
    local P: Player = GS.Players.LocalPlayer
    local Char: Model = P.Character or P.CharacterAdded:Wait()
    local HMND, HRP
    local function RefreshCharRefs()
        Char = P.Character
        if Char then HRP = Char:FindFirstChild("HumanoidRootPart"); HMND = Char:FindFirstChildOfClass("Humanoid")
        else HRP = nil; HMND = nil end
    end
    RefreshCharRefs()
    local AnimTrack_Cache = nil
    local CamoAnim = Instance.new("Animation", nil); CamoAnim.AnimationId = "rbxassetid://215384594"
    local RS: RunService = GS.RunService; local UpdateFrame = RS.Heartbeat; local WaitRender = RS.RenderStepped
    local CoreGS: CoreGui = GS.CoreGui; local StartGS: StarterGui = GS.StarterGui

    local HUD = Instance.new("ScreenGui"); HUD.Name = "ShadowWarningHUD"; HUD.Parent = CoreGS; HUD.ResetOnSpawn = false; HUD.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local WarningText = Instance.new("TextLabel", HUD); WarningText.Text = "⚠️You are visible⚠️"; WarningText.Visible = false; WarningText.Size = UDim2.new(0, 200, 0, 30); WarningText.Position = UDim2.new(0.5, -100, 0.85, 0); WarningText.BackgroundTransparency = 1; WarningText.Font = Enum.Font.GothamSemibold; WarningText.TextSize = 24; WarningText.TextColor3 = Color3.fromRGB(255, 255, 0); WarningText.TextStrokeTransparency = 0.5; WarningText.ZIndex = 10

    if Char and not Char:FindFirstChild("Torso") then
        pcall(function() StartGS:SetCore("SendNotification", { Title = "Shadow Mode FAILED", Text = "Feature requires R6 Avatar.", Duration = 5 }) end)
        Shadow_Usable = false
    end

    local function CheckGrounded() return HMND and HMND:IsDescendantOf(workspace) and HMND.FloorMaterial ~= Enum.Material.Air end
    local function CacheAnimTrack()
        if AnimTrack_Cache then pcall(function() AnimTrack_Cache:Stop() end); AnimTrack_Cache = nil end
        if HMND then
            local success, result = pcall(function() return HMND:LoadAnimation(CamoAnim) end)
            if success then AnimTrack_Cache = result; AnimTrack_Cache.Priority = Enum.AnimationPriority.Action4
            else AnimTrack_Cache = nil end
        else AnimTrack_Cache = nil end
    end

    local function DeactivateShadow()
        if not Shadow_Active then return end; Shadow_Active = false
        if AnimTrack_Cache then pcall(function() AnimTrack_Cache:Stop() end) end
        if HMND then workspace.CurrentCamera.CameraSubject = HMND end
        if Char then for _, v in pairs(Char:GetDescendants()) do if v:IsA("BasePart") and v.Transparency == 0.5 then v.Transparency = 0 end end end
        WarningText.Visible = false
    end

    local function ActivateShadow()
        if Shadow_Active or not Shadow_Usable then return end
        RefreshCharRefs()
        if not Char or not HMND or not HRP then return end
        if not Char:FindFirstChild("Torso") then
            pcall(function() StartGS:SetCore("SendNotification", { Title = "Shadow Mode FAILED", Text = "Feature requires R6 Avatar.", Duration = 5 }) end)
            return
        end
        Shadow_Active = true; workspace.CurrentCamera.CameraSubject = HRP; CacheAnimTrack()
    end

    local function ShadowStep(deltaTime)
        if not Char or not HMND or not HRP or not HMND:IsDescendantOf(workspace) or HMND.Health <= 0 then
            WarningText.Visible = false; return
        end
        WarningText.Visible = not CheckGrounded()
        local walk_speed = 12
        if HMND.MoveDirection.Magnitude > 0 then
            local velocity_offset = HMND.MoveDirection * walk_speed * deltaTime
            HRP.CFrame = HRP.CFrame + velocity_offset
        end
        local InitialCFrame = HRP.CFrame; local InitialCamOffset = HMND.CameraOffset
        local _, yaw_angle = workspace.CurrentCamera.CFrame:ToOrientation()
        HRP.CFrame = CFrame.new(HRP.CFrame.Position) * CFrame.fromOrientation(0, yaw_angle, 0)
        HRP.CFrame = HRP.CFrame * CFrame.Angles(math.rad(90), 0, 0)
        HMND.CameraOffset = Vector3.new(0, 1.44, 0)
        if AnimTrack_Cache then
            local successPlay = pcall(function()
                if not AnimTrack_Cache.IsPlaying then AnimTrack_Cache:Play() end
                AnimTrack_Cache:AdjustSpeed(0); AnimTrack_Cache.TimePosition = 0.3
            end)
            if not successPlay then CacheAnimTrack() end
        elseif HMND and HMND.Health > 0 then CacheAnimTrack() end
        WaitRender:Wait()
        if HMND and HMND:IsDescendantOf(workspace) then HMND.CameraOffset = InitialCamOffset end
        if HRP and HRP:IsDescendantOf(workspace) then HRP.CFrame = InitialCFrame end
        if AnimTrack_Cache then pcall(function() AnimTrack_Cache:Stop() end) end
        if HRP and HRP:IsDescendantOf(workspace) then
            local LookVec = workspace.CurrentCamera.CFrame.LookVector
            local FlatLook = Vector3.new(LookVec.X, 0, LookVec.Z).Unit
            if FlatLook.Magnitude > 0.1 then
                local FinalCFrame = CFrame.new(HRP.Position, HRP.Position + FlatLook)
                HRP.CFrame = FinalCFrame
            end
        end
        if Char then
            for _, v in pairs(Char:GetDescendants()) do
                if (v:IsA("BasePart") and v.Transparency ~= 1) then v.Transparency = 0.5 end
            end
        end
    end

    UpdateFrame:Connect(function(deltaTime)
        if not Shadow_Active or not Shadow_Usable then
            if not Shadow_Active and Char then
                for _, v in pairs(Char:GetDescendants()) do if v:IsA("BasePart") and v.Transparency == 0.5 then v.Transparency = 0 end end
            end
            WarningText.Visible = false; return
        end
        ShadowStep(deltaTime)
    end)

    P.CharacterAdded:Connect(function(NewCharacter)
        if Shadow_Active then DeactivateShadow() end
        if AnimTrack_Cache then pcall(function() AnimTrack_Cache:Stop() end); AnimTrack_Cache = nil end
        task.wait(); RefreshCharRefs()
        if not HMND then task.wait(0.5); RefreshCharRefs()
            if not HMND then Shadow_Usable = false; if Shadow_Active then DeactivateShadow() end
                pcall(function() StartGS:SetCore("SendNotification", { Title = "Shadow Mode Error", Text = "Could not verify character type.", Duration = 5 }) end)
                return
            end
        end
        if HMND.RigType ~= Enum.HumanoidRigType.R6 then
            Shadow_Usable = false; if Shadow_Active then DeactivateShadow() end
            pcall(function() StartGS:SetCore("SendNotification", { Title = "Shadow Mode Warning", Text = "Non-R6 Avatar detected ("..tostring(HMND.RigType).."). Disabled.", Duration = 5 }) end)
            return
        else Shadow_Usable = true end
        if autofarmEnabled and Shadow_Usable then ActivateShadow() end
    end)

    P.CharacterRemoving:Connect(function(OldCharacter)
        if AnimTrack_Cache then pcall(function() AnimTrack_Cache:Stop() end); AnimTrack_Cache = nil end
        WarningText.Visible = false
    end)

    _G.ActivateShadow = ActivateShadow
    _G.DeactivateShadow = DeactivateShadow
    _G.IsShadowActive = function() return Shadow_Active end
end


-- ============================================================
-- UI TOGGLE FONKSİYONU
-- ============================================================

local buttonColor = Color3.fromRGB(15, 10, 12)
local buttonHoverColor = Color3.fromRGB(35, 20, 25)
local buttonOnColor = Color3.fromRGB(200, 30, 30)
local buttonOffColor = Color3.fromRGB(50, 35, 35)
local buttonTextColor = Color3.fromRGB(210, 190, 190)

local activeBinds = {}
local currentRowWaitingForKey = nil
local bindButtonReferences = {}
local keyBindGetters = {}
local keyBindSetters = {}
local rowFunctionData = {}

local function createToggleRow(name, getState, onEnable, onDisable, getBind, setBind)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -16, 0, 32)
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
    label.TextColor3 = buttonTextColor
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.25, 0, 0.8, 0)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 11
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.BackgroundColor3 = buttonOffColor
    toggleBtn.BorderSizePixel = 0
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = frame

    local btnCorner = Instance.new("UICorner", toggleBtn)
    btnCorner.CornerRadius = UDim.new(0, 6)

    local btnStroke = Instance.new("UIStroke", toggleBtn)
    btnStroke.Color = Color3.fromRGB(200, 30, 30)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.3

    local bindBtn = nil
    if getBind and setBind then
        bindBtn = Instance.new("TextButton")
        bindBtn.Size = UDim2.new(0.25, 0, 0.8, 0)
        bindBtn.Font = Enum.Font.Gotham
        bindBtn.TextSize = 10
        bindBtn.TextColor3 = buttonTextColor
        bindBtn.BackgroundColor3 = Color3.fromRGB(25, 18, 20)
        bindBtn.BorderSizePixel = 0
        bindBtn.AutoButtonColor = false
        bindBtn.Parent = frame

        local bindCorner = Instance.new("UICorner", bindBtn)
        bindCorner.CornerRadius = UDim.new(0, 6)
        local bindStroke = Instance.new("UIStroke", bindBtn)
        bindStroke.Color = Color3.fromRGB(200, 30, 30)
        bindStroke.Thickness = 1
        bindStroke.Transparency = 0.3

        bindButtonReferences[frame] = bindBtn
        keyBindGetters[frame] = getBind
        keyBindSetters[frame] = setBind
    end

    local function updateToggle()
        local state = getState()
        if state then
            toggleBtn.Text = "ON"
            toggleBtn.BackgroundColor3 = buttonOnColor
        else
            toggleBtn.Text = "OFF"
            toggleBtn.BackgroundColor3 = buttonOffColor
        end
    end

    local function updateBindText()
        if not bindBtn then return end
        local kb = getBind()
        bindBtn.Text = kb and typeof(kb)=="EnumItem" and kb.Name~="Unknown" and "["..kb.Name.."]" or "Bind"
    end

    rowFunctionData[frame] = {
        getState = getState,
        onEnable = onEnable,
        onDisable = onDisable,
        updateFn = updateToggle,
        bindUpdate = updateBindText,
        bindBtn = bindBtn
    }

    toggleBtn.MouseButton1Click:Connect(function()
        local state = getState()
        if state then
            if onDisable then pcall(onDisable) end
        else
            if onEnable then pcall(onEnable) end
        end
        updateToggle()
    end)

    if bindBtn then
        bindBtn.MouseButton1Click:Connect(function()
            if currentRowWaitingForKey and currentRowWaitingForKey ~= frame then
                local prevData = rowFunctionData[currentRowWaitingForKey]
                if prevData and prevData.bindBtn then
                    prevData.bindUpdate()
                end
            end
            currentRowWaitingForKey = frame
            bindBtn.Text = "..."
            task.delay(5, function()
                if currentRowWaitingForKey == frame then
                    currentRowWaitingForKey = nil
                    updateBindText()
                end
            end)
        end)
    end

    updateToggle()
    updateBindText()
    return frame
end

-- Keybind handler
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    local keyCode = input.KeyCode
    if keyCode == Enum.KeyCode.Unknown then return end

    if currentRowWaitingForKey then
        local frame = currentRowWaitingForKey
        local data = rowFunctionData[frame]
        if data and data.bindBtn then
            local getBind = keyBindGetters[frame]
            local setBind = keyBindSetters[frame]
            
            if getBind and setBind then
                local oldKey = getBind()
                if oldKey and activeBinds[oldKey] then
                    activeBinds[oldKey] = nil
                end
                
                if activeBinds[keyCode] then
                    local oldFrame = activeBinds[keyCode].frame
                    local oldData = rowFunctionData[oldFrame]
                    if oldData and oldData.bindBtn then
                        pcall(keyBindSetters[oldFrame], nil)
                        oldData.bindUpdate()
                    end
                    activeBinds[keyCode] = nil
                end
                
                pcall(setBind, keyCode)
                activeBinds[keyCode] = { frame = frame, data = data }
                data.bindUpdate()
                currentRowWaitingForKey = nil
            end
        end
    elseif activeBinds[keyCode] then
        local bindData = activeBinds[keyCode]
        if bindData and bindData.data then
            local d = bindData.data
            local state = d.getState()
            if state then
                if d.onDisable then pcall(d.onDisable) end
            else
                if d.onEnable then pcall(d.onEnable) end
            end
            d.updateFn()
        end
    end
end)


-- ============================================================
-- KATEGORİLER
-- ============================================================

local Categories = { "Combat", "Movement", "Visuals", "Farming", "Misc", "Rage" }
local CategoryButtons = {}
local CategoryFrames = {}
local ActiveCategoryButton = nil

-- Kategori butonları
for i, cat in ipairs(Categories) do
    CategoryFrames[cat] = {}
    
    local btn = Instance.new("TextButton")
    btn.Name = cat .. "Btn"
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(10, 6, 8)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.LayoutOrder = i
    btn.Parent = menuFrame

    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 6)

    local btnLabel = Instance.new("TextLabel")
    btnLabel.Size = UDim2.new(1, 0, 1, 0)
    btnLabel.BackgroundTransparency = 1
    btnLabel.Text = cat
    btnLabel.TextColor3 = Color3.fromRGB(180, 160, 160)
    btnLabel.Font = Enum.Font.GothamSemibold
    btnLabel.TextSize = 13
    btnLabel.Parent = btn

    btn.MouseEnter:Connect(function()
        if btn ~= ActiveCategoryButton then
            TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(22, 14, 16) }):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if btn ~= ActiveCategoryButton then
            TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(10, 6, 8) }):Play()
        end
    end)

    btn.MouseButton1Click:Connect(function()
        if ActiveCategoryButton then
            TweenService:Create(ActiveCategoryButton, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(10, 6, 8) }):Play()
            ActiveCategoryButton.TextLabel.TextColor3 = Color3.fromRGB(180, 160, 160)
        end
        
        TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(30, 18, 22) }):Play()
        btn.TextLabel.TextColor3 = Color3.fromRGB(220, 200, 200)
        ActiveCategoryButton = btn

        for _, child in ipairs(scrollFrame:GetChildren()) do
            if child:IsA("Frame") and child.Name ~= "UIListLayout" and child.Name ~= "UICorner" then
                child.Parent = nil
            end
        end

        if CategoryFrames[cat] then
            for i, frame in ipairs(CategoryFrames[cat]) do
                frame.Parent = scrollFrame
                frame.LayoutOrder = i
            end
            local numItems = #CategoryFrames[cat]
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, numItems * 38 + 10)
        end
    end)

    CategoryButtons[cat] = btn
end

-- Modülleri kategorilere ekle
local function addToCategory(cat, name, getState, enable, disable, getBind, setBind)
    table.insert(CategoryFrames[cat], createToggleRow(name, getState, enable, disable, getBind, setBind))
end

-- Combat
addToCategory("Combat", "Melee Aura", function() return MeleeAura_Enabled end, MeleeAura_Enable, MeleeAura_Disable)
addToCategory("Combat", "Aimbot", function() return AimBotSettings.Enabled end, Aimbot_Enable, Aimbot_Disable)
addToCategory("Combat", "No Recoil", function() return NoRecoil_Enabled end, NoRecoil_Enable, NoRecoil_Disable)

-- Movement
addToCategory("Movement", "Fly", function() return Fly_Enabled end, Fly_Enable, Fly_Disable)
addToCategory("Movement", "Noclip", function() return Noclip_Enabled end, Noclip_Enable, Noclip_Disable)
addToCategory("Movement", "Infinite Stamina", function() return isInfiniteStaminaEnabled end, InfiniteStamina_Enable, InfiniteStamina_Disable)

-- Visuals
addToCategory("Visuals", "ESP", function() return ESP_Enabled end, ESP_Enable, ESP_Disable)
addToCategory("Visuals", "Invisibility", function() return _G.IsInvisEnabled and _G.IsInvisEnabled() or false end, _G.Invis_Enable, _G.Invis_Disable)
addToCategory("Visuals", "Safe ESP", function() return BredMakurz_Enabled end, BredMakurz_Enable, BredMakurz_Disable)
addToCategory("Visuals", "FullBright", function() return FullBright_Enabled end, FullBright_Enable, FullBright_Disable)
addToCategory("Visuals", "FOV", function() return Fov_Enabled end, Fov_Enable, Fov_Disable)

-- Farming
addToCategory("Farming", "Autofarm", function() return autofarmEnabled end, Autofarm_Enable, Autofarm_Disable)
addToCategory("Farming", "Auto Pickup Money", function() return AutoPickupMoney_Enabled end, AutoPickupMoney_Enable, AutoPickupMoney_Disable)

-- Misc
addToCategory("Misc", "Staff Detector", function() return AdminCheck_Enabled end, AdminCheck_Enable, AdminCheck_Disable)
addToCategory("Misc", "No Fail Lockpick", function() return NoFailLockpick_Enabled end, NoFailLockpick_Enable, NoFailLockpick_Disable)
addToCategory("Misc", "Auto Unlock Doors", function() return UnlockNearbyDoors_Enabled end, UnlockNearbyDoors_Enable, UnlockNearbyDoors_Disable)
addToCategory("Misc", "Auto Open Doors", function() return OpenNearbyDoors_Enabled end, OpenNearbyDoors_Enable, OpenNearbyDoors_Disable)
addToCategory("Misc", "Anti AFK", function() return AntiAFK_Enabled_Dummy end, AntiAFK_Enable, AntiAFK_Disable)

-- Rage
addToCategory("Rage", "Ragebot", function() return Ragebot_Enabled end, Ragebot_Enable, Ragebot_Disable)

-- Varsayılan kategori
local function switchDefault()
    local defaultBtn = CategoryButtons["Combat"]
    if defaultBtn then defaultBtn.MouseButton1Click:Fire() end
end

-- Animasyonlu açılış
mainFrame.Size = UDim2.new(0, 0, 0, 0)
task.wait(0.1)
local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 460, 0, 400)
})
openTween:Play()

task.wait(0.5)
switchDefault()

print("SANTES HUB v2.0 Loaded Successfully!")

end

StartLoader()
