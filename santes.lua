--[[
    SANTES HUB v2.1 - ALL BUGS FIXED
    UI aynı kaldı (zaten sağlamdı)
    Modül hataları giderildi
]]

-- ========================= ANTI-IDLE & SERVICES =========================
local VirtualUser = game:GetService('VirtualUser')
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ========================= ANTI-AFK =========================
if LocalPlayer then
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- ====================== ESKI UI TEMIZLEME ======================
for _, name in pairs({"SantesHubScreenGui", "VenomHubScreenGui", "EQRHubScreenGui", "ShadowWarningHUD", "InvisWarningGUI", "SantesHubScreenGui_Categorized", "InvisWarning"}) do
    local gui = PlayerGui:FindFirstChild(name)
    if gui then gui:Destroy() end
end
-- CoreGui'dakileri de temizle
for _, name in pairs({"InvisWarning"}) do
    local gui = CoreGui:FindFirstChild(name)
    if gui then gui:Destroy() end
end

-- ========================= SANTES HUB TEMA =========================
local Theme = {
    Background = Color3.fromRGB(10, 10, 12),
    FrameBg = Color3.fromRGB(18, 18, 22),
    SidebarBg = Color3.fromRGB(22, 22, 26),
    Accent = Color3.fromRGB(220, 30, 30),
    AccentHover = Color3.fromRGB(255, 50, 50),
    TextPrimary = Color3.fromRGB(230, 230, 230),
    TextSecondary = Color3.fromRGB(150, 150, 160),
    StrokeColor = Color3.fromRGB(50, 50, 55),
    ButtonOn = Color3.fromRGB(180, 30, 30),
    ButtonOff = Color3.fromRGB(60, 25, 25),
    ButtonHover = Color3.fromRGB(80, 35, 35),
    BindButton = Color3.fromRGB(35, 20, 20),
    BindHover = Color3.fromRGB(60, 30, 30),
    CategoryActive = Color3.fromRGB(45, 25, 25),
    CategoryInactive = Color3.fromRGB(22, 22, 26)
}

-- ========================= UI OLUSTURMA =========================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SantesHubScreenGui_Categorized"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "SantesHubMainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 350)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Theme.FrameBg
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = false
mainFrame.Visible = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Theme.Accent
stroke.Thickness = 1.5
stroke.Transparency = 0.3
stroke.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = Theme.Background
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "SANTES HUB v2.1"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Theme.TextPrimary
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 32, 0, 32)
closeButton.Position = UDim2.new(1, -38, 0, 5)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16
closeButton.TextColor3 = Theme.TextPrimary
closeButton.BackgroundColor3 = Theme.Accent
closeButton.BorderSizePixel = 0
closeButton.AutoButtonColor = false
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function() screenGui:Destroy() end)
closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.15), {BackgroundColor3 = Theme.AccentHover}):Play()
end)
closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Accent}):Play()
end)

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -20, 0, 2)
divider.Position = UDim2.new(0, 10, 0, 42)
divider.BackgroundColor3 = Theme.Accent
divider.BorderSizePixel = 0
divider.Parent = mainFrame

local sidebarFrame = Instance.new("Frame")
sidebarFrame.Size = UDim2.new(0, 120, 1, -68)
sidebarFrame.Position = UDim2.new(0, 10, 0, 50)
sidebarFrame.BackgroundColor3 = Theme.SidebarBg
sidebarFrame.BorderSizePixel = 0
sidebarFrame.Parent = mainFrame

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 8)
sidebarCorner.Parent = sidebarFrame

local sidebarStroke = Instance.new("UIStroke")
sidebarStroke.Color = Theme.Accent
sidebarStroke.Thickness = 1
sidebarStroke.Transparency = 0.4
sidebarStroke.Parent = sidebarFrame

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Padding = UDim.new(0, 5)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sidebarLayout.Parent = sidebarFrame

local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -150, 1, -68)
contentFrame.Position = UDim2.new(0, 140, 0, 50)
contentFrame.BackgroundColor3 = Theme.SidebarBg
contentFrame.BorderSizePixel = 0
contentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
contentFrame.ScrollBarThickness = 4
contentFrame.ScrollBarImageColor3 = Theme.Accent
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = contentFrame

local contentStroke = Instance.new("UIStroke")
contentStroke.Color = Theme.Accent
contentStroke.Thickness = 1
contentStroke.Transparency = 0.4
contentStroke.Parent = contentFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 6)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
contentLayout.Parent = contentFrame

local footerLabel = Instance.new("TextLabel")
footerLabel.Size = UDim2.new(1, -20, 0, 18)
footerLabel.Position = UDim2.new(0, 10, 1, -22)
footerLabel.BackgroundTransparency = 1
footerLabel.Text = "SANTES HUB | Press K to Toggle"
footerLabel.Font = Enum.Font.Gotham
footerLabel.TextSize = 10
footerLabel.TextColor3 = Theme.TextSecondary
footerLabel.TextXAlignment = Enum.TextXAlignment.Right
footerLabel.Parent = mainFrame

-- ========================= SURUKLEME =========================
do
    local dragging, dragStart, startPos, dragInput = false, nil, nil, nil
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.K then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- ========================= TOGGLE ROW OLUSTURUCU =========================
local activeBinds = {}
local currentRowWaitingForKey = nil
local bindButtonRefs = {}
local keyBindGetters = {}
local keyBindSetters = {}
local toggleTweens = {}
local rowFuncData = {}

local function createToggleRow(scriptName, canToggle, isEnabledFn, onEnable, onDisable, getKeyBindFn, setKeyBindFn)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -16, 0, 35)
    frame.BackgroundTransparency = 1
    frame.Name = scriptName:gsub("%s+", "")

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.45, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = " " .. scriptName
    label.TextColor3 = Theme.TextSecondary
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.LayoutOrder = 1
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.25, 0, 0.8, 0)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 12
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.BackgroundColor3 = Theme.ButtonOff
    toggleBtn.BorderSizePixel = 0
    toggleBtn.AutoButtonColor = false
    toggleBtn.LayoutOrder = 2
    toggleBtn.Parent = frame

    local tCorner = Instance.new("UICorner"); tCorner.CornerRadius = UDim.new(0, 6); tCorner.Parent = toggleBtn
    local tStroke = Instance.new("UIStroke"); tStroke.Color = Theme.Accent; tStroke.Thickness = 1; tStroke.Transparency = 0.4; tStroke.Parent = toggleBtn

    local bindBtn = nil

    local function getTargetColor()
        local state = false
        if type(isEnabledFn) == 'function' then
            local s, r = pcall(isEnabledFn)
            if s then state = r end
        end
        if not canToggle then return Color3.fromRGB(120, 40, 40) end
        return state and Theme.ButtonOn or Theme.ButtonOff
    end

    local function updateVisuals()
        local state = false
        if type(isEnabledFn) == 'function' then
            local s, r = pcall(isEnabledFn)
            if s then state = r end
        end
        local targetColor
        if not canToggle then
            toggleBtn.Text = "RUN"
            targetColor = Color3.fromRGB(120, 40, 40)
        elseif state then
            toggleBtn.Text = "ON"
            targetColor = Theme.ButtonOn
        else
            toggleBtn.Text = "OFF"
            targetColor = Theme.ButtonOff
        end
        if toggleTweens[toggleBtn] then toggleTweens[toggleBtn]:Cancel(); toggleTweens[toggleBtn] = nil end
        toggleBtn.BackgroundColor3 = targetColor
    end

    rowFuncData[frame] = {
        isEnabledFn = isEnabledFn, onEnable = onEnable, onDisable = onDisable,
        canToggle = canToggle, updateFn = updateVisuals
    }

    if getKeyBindFn and setKeyBindFn then
        bindBtn = Instance.new("TextButton")
        bindBtn.Size = UDim2.new(0.25, 0, 0.8, 0)
        bindBtn.Font = Enum.Font.GothamMedium
        bindBtn.TextSize = 11
        bindBtn.TextColor3 = Theme.TextSecondary
        bindBtn.BackgroundColor3 = Theme.BindButton
        bindBtn.BorderSizePixel = 0
        bindBtn.AutoButtonColor = false
        bindBtn.LayoutOrder = 3
        bindBtn.Parent = frame

        local bCorner = Instance.new("UICorner"); bCorner.CornerRadius = UDim.new(0, 6); bCorner.Parent = bindBtn
        local bStroke = Instance.new("UIStroke"); bStroke.Color = Theme.Accent; bStroke.Thickness = 1; bStroke.Transparency = 0.4; bStroke.Parent = bindBtn

        bindButtonRefs[frame] = bindBtn
        keyBindGetters[frame] = getKeyBindFn
        keyBindSetters[frame] = setKeyBindFn

        local initKey = nil
        local s, r = pcall(getKeyBindFn)
        if s and r and typeof(r) == "EnumItem" then
            initKey = r
            if rowFuncData[frame] then
                activeBinds[initKey] = {
                    frame = frame, toggleButton = toggleBtn,
                    isEnabledFn = rowFuncData[frame].isEnabledFn,
                    onEnable = rowFuncData[frame].onEnable,
                    onDisable = rowFuncData[frame].onDisable,
                    canToggle = rowFuncData[frame].canToggle,
                    updateFn = rowFuncData[frame].updateFn
                }
            end
        end
    else
        toggleBtn.Size = UDim2.new(0.5, 0, 0.8, 0)
    end

    local function updateBindText()
        if not bindBtn then return end
        local kb = nil
        if type(getKeyBindFn) == 'function' then
            local s, r = pcall(getKeyBindFn)
            if s then kb = r end
        end
        bindBtn.Text = (kb and typeof(kb) == "EnumItem" and kb.Name ~= "Unknown") and "["..kb.Name.."]" or "Bind"
    end

    updateVisuals()
    updateBindText()

    toggleBtn.MouseEnter:Connect(function()
        if toggleTweens[toggleBtn] then toggleTweens[toggleBtn]:Cancel() end
        local target = getTargetColor()
        local hoverTarget = target:Lerp(Color3.new(1, 1, 1), 0.2)
        local tween = TweenService:Create(toggleBtn, TweenInfo.new(0.1), {BackgroundColor3 = hoverTarget})
        toggleTweens[toggleBtn] = tween
        tween:Play()
    end)
    toggleBtn.MouseLeave:Connect(function()
        if toggleTweens[toggleBtn] then toggleTweens[toggleBtn]:Cancel() end
        local tween = TweenService:Create(toggleBtn, TweenInfo.new(0.1), {BackgroundColor3 = getTargetColor()})
        toggleTweens[toggleBtn] = tween
        tween:Play()
    end)

    if bindBtn then
        bindBtn.MouseEnter:Connect(function()
            TweenService:Create(bindBtn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.BindHover}):Play()
        end)
        bindBtn.MouseLeave:Connect(function()
            TweenService:Create(bindBtn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.BindButton}):Play()
        end)
        local capturing = false
        bindBtn.MouseButton1Click:Connect(function()
            if currentRowWaitingForKey and currentRowWaitingForKey ~= frame then
                local prevBtn = bindButtonRefs[currentRowWaitingForKey]
                if prevBtn then
                    local getter = keyBindGetters[currentRowWaitingForKey]
                    local txt = "Bind"
                    if getter then
                        local s, r = pcall(getter)
                        if s and r and typeof(r) == "EnumItem" then txt = "["..r.Name.."]" end
                    end
                    prevBtn.Text = txt
                end
            end
            if capturing then
                capturing = false; updateBindText(); currentRowWaitingForKey = nil
            else
                capturing = true; bindBtn.Text = "..."; currentRowWaitingForKey = frame
                task.delay(5, function()
                    if capturing and currentRowWaitingForKey == frame then
                        capturing = false; updateBindText(); currentRowWaitingForKey = nil
                    end
                end)
            end
        end)
    end

    toggleBtn.MouseButton1Click:Connect(function()
        local state = false
        if type(isEnabledFn) == 'function' then
            local s, r = pcall(isEnabledFn)
            if s then state = r end
        end
        if not canToggle then
            if type(onEnable) == 'function' then pcall(onEnable) end
            toggleBtn.Text = "DONE"
            toggleBtn.BackgroundColor3 = Theme.ButtonOn:Lerp(Color3.fromRGB(10,10,12), 0.3)
            toggleBtn.Active = false
            if bindBtn then bindBtn.Active = false end
            return
        end
        if state then
            if type(onDisable) == 'function' then pcall(onDisable) end
        else
            if type(onEnable) == 'function' then pcall(onEnable) end
        end
        updateVisuals()
    end)

    return frame
end

-- ========================= TUM MODULLER (FIXLENMIS) =========================

-- 1. FLY
local flyEnabled = false
local flyConn = nil
local flySpeed = 50

function Fly_Enable()
    if flyEnabled then return end
    flyEnabled = true
    flyConn = RunService.Heartbeat:Connect(function(dt)
        if not flyEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.AssemblyLinearVelocity = Vector3.zero
            end
        end
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.yAxis end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.yAxis end
        if moveDir.Magnitude > 0 then
            hrp.CFrame += moveDir.Unit * flySpeed * dt
        end
    end)
end

function Fly_Disable()
    flyEnabled = false
    if flyConn then flyConn:Disconnect(); flyConn = nil end
end

-- 2. NOCLIP
local noclipEnabled = false
local noclipConn = nil

function Noclip_Enable()
    if noclipEnabled then return end
    noclipEnabled = true
    noclipConn = RunService.Stepped:Connect(function()
        if noclipEnabled and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end

function Noclip_Disable()
    noclipEnabled = false
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
end

-- 3. INFINITE STAMINA (FIXED - getrenv kontrolü düzeltildi)
local infStaminaEnabled = false
local staminaHooked = false

function InfiniteStamina_Enable()
    infStaminaEnabled = true
    if staminaHooked then return end
    staminaHooked = true
    
    task.spawn(function()
        for i = 1, 20 do
            local env = nil
            local s1, e1 = pcall(function() return getrenv() end)
            if s1 then env = e1
            else
                local s2, e2 = pcall(function() return getfenv() end)
                if s2 then env = e2 end
            end
            
            if env and env._G and type(env._G.S_Take) == "function" then
                local s3, upval = pcall(function() return getupvalue(env._G.S_Take, 2) end)
                if s3 and type(upval) == "function" then
                    local original = upval
                    hookfunction(upval, function(v1, ...)
                        if infStaminaEnabled then
                            return original(0, ...)
                        end
                        return original(v1, ...)
                    end)
                    return
                end
            end
            task.wait(0.5)
        end
    end)
end

function InfiniteStamina_Disable()
    infStaminaEnabled = false
end

-- 4. FULLBRIGHT
local fullbrightEnabled = false
local fullbrightConn = nil
local savedLighting = {}

function FullBright_Enable()
    if fullbrightEnabled then return end
    fullbrightEnabled = true
    savedLighting = {
        Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
        Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
        FogStart = Lighting.FogStart, FogEnd = Lighting.FogEnd
    }
    fullbrightConn = RunService.RenderStepped:Connect(function()
        if fullbrightEnabled then
            Lighting.Brightness = 3
            Lighting.ClockTime = 14
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            Lighting.FogStart = 100000
            Lighting.FogEnd = 100000
        end
    end)
end

function FullBright_Disable()
    fullbrightEnabled = false
    if fullbrightConn then fullbrightConn:Disconnect(); fullbrightConn = nil end
    if savedLighting.Brightness then
        pcall(function()
            Lighting.Brightness = savedLighting.Brightness
            Lighting.ClockTime = savedLighting.ClockTime
            Lighting.Ambient = savedLighting.Ambient
            Lighting.OutdoorAmbient = savedLighting.OutdoorAmbient
            Lighting.FogStart = savedLighting.FogStart
            Lighting.FogEnd = savedLighting.FogEnd
        end)
    end
end

-- 5. NO FAIL LOCKPICK
local noFailLPEnabled = false
local noFailLPConn = nil

function NoFailLockpick_Enable()
    if noFailLPEnabled then return end
    noFailLPEnabled = true
    noFailLPConn = PlayerGui.ChildAdded:Connect(function(item)
        if item.Name == "LockpickGUI" then
            task.wait(0.1)
            pcall(function()
                local frames = item.MF and item.MF.LP_Frame and item.MF.LP_Frame.Frames
                if frames then
                    for _, barName in pairs({"B1", "B2", "B3"}) do
                        local bar = frames:FindFirstChild(barName)
                        if bar and bar:FindFirstChild("Bar") then
                            local uiScale = bar.Bar:FindFirstChild("UIScale")
                            if uiScale then uiScale.Scale = 10 end
                        end
                    end
                end
            end)
        end
    end)
end

function NoFailLockpick_Disable()
    noFailLPEnabled = false
    if noFailLPConn then noFailLPConn:Disconnect(); noFailLPConn = nil end
end

-- 6. SAFE ESP (FIXED - memory leak önlendi)
local safeESPEnabled = false
local safeESPConn = nil
local espLabels = {}

local function updateSafeESP()
    local folder = Workspace.Map and Workspace.Map:FindFirstChild("BredMakurz")
    if not folder then folder = Workspace:FindFirstChild("BredMakurz") end
    if not folder then return end
    
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local myPos = char.HumanoidRootPart.Position
    
    for _, obj in pairs(folder:GetChildren()) do
        local part = obj:FindFirstChild("MainPart") or obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
        if part then
            local dist = (part.Position - myPos).Magnitude
            local existing = obj:FindFirstChild("Santes_SafeESP")
            if dist <= 200 then
                if not existing then
                    local bg = Instance.new("BillboardGui")
                    bg.Name = "Santes_SafeESP"
                    bg.Size = UDim2.new(0, 120, 0, 25)
                    bg.AlwaysOnTop = true
                    bg.MaxDistance = 200
                    bg.Adornee = obj
                    bg.Parent = obj
                    
                    local tl = Instance.new("TextLabel")
                    tl.Size = UDim2.new(1, 0, 1, 0)
                    tl.BackgroundTransparency = 1
                    tl.Text = obj.Name
                    tl.TextScaled = false
                    tl.TextSize = 12
                    tl.Font = Enum.Font.GothamBold
                    tl.Parent = bg
                    
                    local values = obj:FindFirstChild("Values")
                    local broken = values and values:FindFirstChild("Broken")
                    if broken and broken:IsA("BoolValue") then
                        if broken.Value then
                            tl.TextColor3 = Color3.fromRGB(255, 0, 0)
                        else
                            tl.TextColor3 = Color3.fromRGB(0, 255, 0)
                        end
                        broken.Changed:Connect(function(val)
                            pcall(function()
                                if tl and tl.Parent then
                                    tl.TextColor3 = val and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
                                end
                            end)
                        end)
                    else
                        tl.TextColor3 = Color3.fromRGB(0, 255, 0)
                    end
                    espLabels[obj] = bg
                end
            elseif existing then
                pcall(function() existing:Destroy() end)
                espLabels[obj] = nil
            end
        end
    end
end

function SafeESP_Enable()
    if safeESPEnabled then return end
    safeESPEnabled = true
    safeESPConn = RunService.Heartbeat:Connect(updateSafeESP)
end

function SafeESP_Disable()
    safeESPEnabled = false
    if safeESPConn then safeESPConn:Disconnect(); safeESPConn = nil end
    for _, esp in pairs(espLabels) do pcall(function() esp:Destroy() end) end
    espLabels = {}
end

-- 7. AUTO PICKUP MONEY
local autoPickupEnabled = false
local autoPickupConn = nil
local pickupCooldown = false

function AutoPickup_Enable()
    if autoPickupEnabled then return end
    autoPickupEnabled = true
    autoPickupConn = RunService.RenderStepped:Connect(function()
        if not autoPickupEnabled or pickupCooldown then return end
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
                pickupCooldown = true
                pcall(function() remote:FireServer(bread) end)
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
    if autoPickupConn then autoPickupConn:Disconnect(); autoPickupConn = nil end
end

-- 8. AUTO UNLOCK DOORS
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
            if doorBase and (hrp.Position - doorBase.Position).Magnitude <= 8 then
                local events = door:FindFirstChild("Events")
                local values = door:FindFirstChild("Values")
                if events and values then
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

-- 9. ADMIN DETECTOR
local adminCheckEnabled = false
local adminCheckConn = nil
local staffUsers = {3294804378,93676120,54087314,81275825,140837601,1229486091,46567801,418086275,
    29706395,3717066084,1424338327,5046662686,5046661126,5046659439,418199326,1024216621,1810535041,
    63238912,111250044,63315426,730176906,141193516,194512073,193945439,412741116,195538733,102045519,
    955294,957835150,25689921,366613818,281593651,455275714,208929505,96783330,156152502,93281166,
    959606619,142821118,632886139,175931803,122209625,278097946,142989311,1517131734,446849296,87189764,
    67180844,9212846,47352513,48058122,155413858,10497435,513615792,55893752,55476024,151691292,136584758,
    16983447,3111449,94693025,271400893,5005262660,295331237,64489098,244844600,114332275,25048901,
    69262878,50801509,92504899,42066711,50585425,31365111,166406495,2457253857,29761878,21831137,
    948293345,439942262,38578487,1163048,7713309208,3659305297,15598614,34616594,626833004,198610386,
    153835477,3923114296,3937697838,102146039,119861460,371665775,1206543842,93428604,1863173316,90814576,
    374665997,423005063,140172831,42662179,9066859,438805620,14855669,727189337,1871290386,608073286}

function AdminCheck_Enable()
    if adminCheckEnabled then return end
    adminCheckEnabled = true
    local function checkPlayer(player)
        if player == LocalPlayer then return false end
        for _, uid in pairs(staffUsers) do
            if player.UserId == uid then
                pcall(function() LocalPlayer:Kick("SANTES: Staff detected - " .. player.Name) end)
                return true
            end
        end
        return false
    end
    for _, player in pairs(Players:GetPlayers()) do
        if checkPlayer(player) then return end
    end
    adminCheckConn = Players.PlayerAdded:Connect(checkPlayer)
end

function AdminCheck_Disable()
    adminCheckEnabled = false
    if adminCheckConn then adminCheckConn:Disconnect(); adminCheckConn = nil end
end

-- 10. PLAYER ESP (FIXED - nil parent ve memory leak)
local playerESPEnabled = false
local playerESPConnections = {}
local espPlayerList = {}

local function createESPForPlayer(player)
    if player == LocalPlayer then return end
    if espPlayerList[player] then return end
    espPlayerList[player] = true
    
    local function setupChar(char)
        if not playerESPEnabled then return end
        if not char or not char.Parent then return end
        
        local existingHL = char:FindFirstChild("Santes_PlayerESP")
        if existingHL then existingHL:Destroy() end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "Santes_PlayerESP"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.65
        highlight.OutlineColor = Color3.fromRGB(255, 40, 40)
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = char
        
        local head = char:FindFirstChild("Head")
        if head then
            local existingBG = head:FindFirstChild("Santes_PlayerName")
            if existingBG then existingBG:Destroy() end
            
            local bill = Instance.new("BillboardGui")
            bill.Name = "Santes_PlayerName"
            bill.Size = UDim2.new(0, 100, 0, 30)
            bill.StudsOffset = Vector3.new(0, 2.5, 0)
            bill.AlwaysOnTop = true
            bill.Parent = head
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.new(1, 1, 1)
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 12
            nameLabel.Parent = bill
        end
    end
    
    if player.Character then
        setupChar(player.Character)
    end
    
    local charConn = player.CharacterAdded:Connect(setupChar)
    table.insert(playerESPConnections, charConn)
end

function PlayerESP_Enable()
    if playerESPEnabled then return end
    playerESPEnabled = true
    espPlayerList = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        createESPForPlayer(player)
    end
    
    local playerAddedConn = Players.PlayerAdded:Connect(function(player)
        if playerESPEnabled then
            createESPForPlayer(player)
        end
    end)
    table.insert(playerESPConnections, playerAddedConn)
    
    local playerRemovingConn = Players.PlayerRemoving:Connect(function(player)
        espPlayerList[player] = nil
    end)
    table.insert(playerESPConnections, playerRemovingConn)
end

function PlayerESP_Disable()
    playerESPEnabled = false
    for _, conn in pairs(playerESPConnections) do
        pcall(function() conn:Disconnect() end)
    end
    playerESPConnections = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        pcall(function()
            if player.Character then
                local hl = player.Character:FindFirstChild("Santes_PlayerESP")
                if hl then hl:Destroy() end
                for _, v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BillboardGui") and v.Name == "Santes_PlayerName" then
                        v:Destroy()
                    end
                end
            end
        end)
    end
    espPlayerList = {}
end

-- 11. INVISIBILITY (FIXED - updateRefs scope sorunu çözüldü)
local invisEnabled = false
local invisUsable = true
local invisTrack = nil
local invisChar = nil
local invisHum = nil
local invisHRP = nil
local invisGUI = nil
local invisWarnLabel = nil

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
            if invisWarnLabel then invisWarnLabel.Visible = false end
            return
        end
        
        if not invisChar or not invisHum or not invisHRP or invisHum.Health <= 0 then
            if invisWarnLabel then invisWarnLabel.Visible = false end
            return
        end
        
        if invisWarnLabel then invisWarnLabel.Visible = not grounded() end
        
        local speed = 12
        if invisHum.MoveDirection.Magnitude > 0 then
            invisHRP.CFrame += invisHum.MoveDirection * speed * dt
        end
        
        local oldCF = invisHRP.CFrame
        local oldOffset = invisHum.CameraOffset
        local _, y = workspace.CurrentCamera.CFrame:ToOrientation()
        invisHRP.CFrame = CFrame.new(invisHRP.Position) * CFrame.fromOrientation(0, y, 0) * CFrame.Angles(math.rad(90), 0, 0)
        invisHum.CameraOffset = Vector3.new(0, 1.44, 0)
        
        if invisTrack then
            pcall(function()
                if not invisTrack.IsPlaying then invisTrack:Play() end
                invisTrack:AdjustSpeed(0)
                invisTrack.TimePosition = 0.3
            end)
        elseif invisHum.Health > 0 then
            loadTrack()
        end
        
        RunService.RenderStepped:Wait()
        
        if invisHum:IsDescendantOf(Workspace) then invisHum.CameraOffset = oldOffset end
        if invisHRP:IsDescendantOf(Workspace) then invisHRP.CFrame = oldCF end
        
        if invisTrack then pcall(function() invisTrack:Stop() end) end
        
        if invisHRP:IsDescendantOf(Workspace) then
            local lookVec = workspace.CurrentCamera.CFrame.LookVector
            local flat = Vector3.new(lookVec.X, 0, lookVec.Z).Unit
            if flat.Magnitude > 0.1 then
                invisHRP.CFrame = CFrame.new(invisHRP.Position, invisHRP.Position + flat)
            end
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
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "SANTES Invis", Text = "R6 avatar gerekli!", Duration = 3
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
    if invisHum and invisHum.RigType ~= Enum.HumanoidRigType.R6 then invisUsable = false end
    
    invisGUI = Instance.new("ScreenGui")
    invisGUI.Name = "InvisWarning"
    invisGUI.Parent = CoreGui
    invisGUI.ResetOnSpawn = false
    
    invisWarnLabel = Instance.new("TextLabel", invisGUI)
    invisWarnLabel.Text = "VISIBLE!"
    invisWarnLabel.Visible = false
    invisWarnLabel.Size = UDim2.new(0, 200, 0, 30)
    invisWarnLabel.Position = UDim2.new(0.5, -100, 0.85, 0)
    invisWarnLabel.BackgroundTransparency = 1
    invisWarnLabel.Font = Enum.Font.GothamBold
    invisWarnLabel.TextSize = 24
    invisWarnLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    invisWarnLabel.TextStrokeTransparency = 0.5
    
    _G.Invis_Enable = function()
        if invisEnabled or not invisUsable then return end
        invisEnabled = true
        updateRefs()
        if invisHRP then workspace.CurrentCamera.CameraSubject = invisHRP end
        loadTrack()
    end
    
    _G.Invis_Disable = function()
        if not invisEnabled then return end
        invisEnabled = false
        if invisTrack then pcall(function() invisTrack:Stop() end) end
        if invisHum then workspace.CurrentCamera.CameraSubject = invisHum end
        if invisChar then
            for _, v in pairs(invisChar:GetDescendants()) do
                if v:IsA("BasePart") and v.Transparency == 0.5 then v.Transparency = 0 end
            end
        end
        if invisWarnLabel then invisWarnLabel.Visible = false end
    end
    
    _G.IsInvisEnabled = function() return invisEnabled end
end

function Invis_Enable() _G.Invis_Enable() end
function Invis_Disable() _G.Invis_Disable() end

-- 12. NO RECOIL
local noRecoilEnabled = false
local noRecoilOriginal = {}

function NoRecoil_Enable()
    if noRecoilEnabled then return end
    noRecoilEnabled = true
    pcall(function()
        for _, v in pairs(getgc(true)) do
            if type(v) == 'table' and rawget(v, 'Recoil') ~= nil then
                if not noRecoilOriginal[v] then
                    noRecoilOriginal[v] = {
                        Recoil = v.Recoil, Spread = v.Spread,
                        CameraRecoilingEnabled = v.CameraRecoilingEnabled,
                        AngleX_Min = v.AngleX_Min, AngleX_Max = v.AngleX_Max,
                        AngleY_Min = v.AngleY_Min, AngleY_Max = v.AngleY_Max,
                        AngleZ_Min = v.AngleZ_Min, AngleZ_Max = v.AngleZ_Max
                    }
                end
                v.Recoil = 0; v.Spread = 0; v.CameraRecoilingEnabled = false
                v.AngleX_Min, v.AngleX_Max = 0, 0
                v.AngleY_Min, v.AngleY_Max = 0, 0
                v.AngleZ_Min, v.AngleZ_Max = 0, 0
            end
        end
    end)
end

function NoRecoil_Disable()
    if not noRecoilEnabled then return end
    noRecoilEnabled = false
    for weapon, orig in pairs(noRecoilOriginal) do
        pcall(function()
            weapon.Recoil = orig.Recoil; weapon.Spread = orig.Spread
            weapon.CameraRecoilingEnabled = orig.CameraRecoilingEnabled
            weapon.AngleX_Min, weapon.AngleX_Max = orig.AngleX_Min, orig.AngleX_Max
            weapon.AngleY_Min, weapon.AngleY_Max = orig.AngleY_Min, orig.AngleY_Max
            weapon.AngleZ_Min, weapon.AngleZ_Max = orig.AngleZ_Min, orig.AngleZ_Max
        end)
    end
    noRecoilOriginal = {}
end

-- 13. SILENT AIM (FIXED - pcall korumasi eklendi)
local silentAimEnabled = false
local silentAimConn = nil
local silentAimFOV = 200

function SilentAim_Enable()
    if silentAimEnabled then return end
    silentAimEnabled = true
    silentAimConn = RunService.RenderStepped:Connect(function()
        if not silentAimEnabled then return end
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
        
        local closest, bestDist = nil, silentAimFOV
        local cam = workspace.CurrentCamera
        if not cam then return end
        
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
        
        local sMouse, mousePos = pcall(function() return UserInputService:GetMouseLocation() end)
        if not sMouse then return end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                local target = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and target then
                    local sScreen, screenPos, onScreen = pcall(function() return cam:WorldToViewportPoint(target.Position) end)
                    if sScreen and onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist < bestDist then
                            bestDist = dist; closest = player
                        end
                    end
                end
            end
        end
        
        if closest and closest.Character then
            local targetPart = closest.Character:FindFirstChild("Head") or closest.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                cam.CFrame = CFrame.new(cam.CFrame.Position, targetPart.Position)
            end
        end
    end)
end

function SilentAim_Disable()
    silentAimEnabled = false
    if silentAimConn then silentAimConn:Disconnect(); silentAimConn = nil end
end

-- 14. AUTO FARM (FIXED - goto kaldirildi, while loop duzeltildi)
local autoFarmEnabled = false
local autoFarmCoroutine = nil
local farmIgnoredSafes = {}

local function teleportTo(pos)
    local char = LocalPlayer.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    for i = 1, 5 do
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
        task.wait(0.3)
        if hrp and hrp.Parent and (hrp.Position - pos).Magnitude < 10 then return true end
        task.wait(0.3)
    end
    return false
end

local function findDealer()
    local shops = Workspace.Map and Workspace.Map:FindFirstChild("Shopz")
    if not shops then return nil end
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local nearest, bestDist = nil, math.huge
    for _, shop in pairs(shops:GetChildren()) do
        local main = shop:FindFirstChild("MainPart")
        local stocks = shop:FindFirstChild("CurrentStocks")
        if main and stocks then
            local crowbarStock = stocks:FindFirstChild("Crowbar")
            if crowbarStock and crowbarStock:IsA("IntValue") and crowbarStock.Value > 0 then
                local dist = (main.Position - hrp.Position).Magnitude
                if dist < bestDist then bestDist = dist; nearest = shop end
            end
        end
    end
    return nearest
end

local function findTargetSafe()
    local folder = Workspace.Map and Workspace.Map:FindFirstChild("BredMakurz")
    if not folder then folder = Workspace:FindFirstChild("BredMakurz") end
    if not folder then return nil end
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local nearest, bestDist = nil, math.huge
    for _, obj in pairs(folder:GetChildren()) do
        if not table.find(farmIgnoredSafes, obj) and (string.find(obj.Name, "Safe") or string.find(obj.Name, "Register")) then
            local values = obj:FindFirstChild("Values")
            if values then
                local broken = values:FindFirstChild("Broken")
                if broken and broken:IsA("BoolValue") and not broken.Value then
                    local part = obj:FindFirstChild("MainPart") or obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
                    if part then
                        local dist = (part.Position - hrp.Position).Magnitude
                        if dist < bestDist then bestDist = dist; nearest = obj end
                    end
                end
            end
        end
    end
    return nearest
end

local function hasTool(name)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild(name) then return true end
    local bp = LocalPlayer.Backpack
    return bp and bp:FindFirstChild(name) ~= nil
end

local function equipTool(name)
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local tool = char:FindFirstChild(name) or LocalPlayer.Backpack:FindFirstChild(name)
    if tool then pcall(function() hum:EquipTool(tool) end); task.wait(0.5); return true end
    return false
end

local function openSafe(safeModel)
    if not hasTool("Crowbar") then return end
    if not equipTool("Crowbar") then return end
    local remote1 = ReplicatedStorage.Events and ReplicatedStorage.Events:FindFirstChild("XMHH.2")
    local remote2 = ReplicatedStorage.Events and ReplicatedStorage.Events:FindFirstChild("XMHH2.2")
    local safePart = safeModel:FindFirstChild("MainPart")
    if not remote1 or not remote2 or not safePart then return end
    local equipped = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Crowbar")
    if not equipped then return end
    local startTime = tick()
    while safeModel and safeModel.Parent and safeModel:FindFirstChild("Values") do
        local broken = safeModel.Values:FindFirstChild("Broken")
        if not broken or broken.Value == true then break end
        if tick() - startTime > 20 then break end
        local char = LocalPlayer.Character
        if not char then break end
        pcall(function()
            local result = remote1:InvokeServer("🍞", tick(), equipped, "DZDRRRKI", safeModel, "Register")
            if result then
                remote2:FireServer("🍞", tick(), equipped, "2389ZFX34", result, false, char["Right Arm"], safePart, safeModel, safePart.Position, safePart.Position)
            end
        end)
        task.wait(0.15)
    end
    task.wait(6)
end

local function buyCrowbar(dealer)
    if not dealer then return false end
    local main = dealer:FindFirstChild("MainPart")
    if not main then return false end
    if not teleportTo(main.Position) then return false end
    task.wait(1)
    local byzers = ReplicatedStorage.Events and ReplicatedStorage.Events:FindFirstChild("BYZERSPROTEC")
    local shopEvent = ReplicatedStorage.Events and ReplicatedStorage.Events:FindFirstChild("SSHPRMTE1")
    if not byzers or not shopEvent then return false end
    pcall(function() byzers:FireServer(true, "shop", main, "IllegalStore") end)
    task.wait(0.5)
    pcall(function() shopEvent:InvokeServer("IllegalStore", "Melees", "Crowbar", main, nil, true) end)
    task.wait(2)
    pcall(function() byzers:FireServer(false) end)
    return hasTool("Crowbar")
end

local function autoFarmLoop()
    while autoFarmEnabled do
        task.wait(0.5)
        
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        -- Olu/Respawn kontrolu
        if not char or not hum or hum.Health <= 0 then
            local deathEvent = ReplicatedStorage.Events and ReplicatedStorage.Events:FindFirstChild("DeathRespawn")
            if deathEvent then pcall(function() deathEvent:InvokeServer("KMG4R904") end) end
            task.wait(3)
            farmIgnoredSafes = {}
            continue
        end
        
        -- Levye kontrolu
        if not hasTool("Crowbar") then
            local dealer = findDealer()
            if dealer then buyCrowbar(dealer) else task.wait(5) end
            continue
        end
        
        -- Safe bul ve soy
        local target = findTargetSafe()
        if target then
            local mainPart = target:FindFirstChild("MainPart") or target.PrimaryPart
            if mainPart then
                if teleportTo(mainPart.Position) then
                    task.wait(0.5)
                    openSafe(target)
                else
                    table.insert(farmIgnoredSafes, target)
                    task.wait(1)
                end
            end
        else
            farmIgnoredSafes = {}
            task.wait(3)
        end
    end
end

function AutoFarm_Enable()
    if autoFarmEnabled then return end
    autoFarmEnabled = true
    farmIgnoredSafes = {}
    if autoFarmCoroutine then task.cancel(autoFarmCoroutine); autoFarmCoroutine = nil end
    AutoPickup_Enable()
    Noclip_Enable()
    autoFarmCoroutine = task.spawn(autoFarmLoop)
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
    if autoFarmCoroutine then task.cancel(autoFarmCoroutine); autoFarmCoroutine = nil end
    farmIgnoredSafes = {}
    AutoPickup_Disable()
end

-- ========================= KATEGORILER VE BUTONLAR =========================
local Categories = {"Combat", "Movement", "Visuals", "Farming", "Misc"}
local CatFrames = {}
local CatButtons = {}
local ActiveCat = nil

for _, cat in pairs(Categories) do CatFrames[cat] = {} end

local function SwitchCategory(name)
    local btn = CatButtons[name]
    if not btn or btn == ActiveCat then return end
    if ActiveCat then
        TweenService:Create(ActiveCat, TweenInfo.new(0.15), {BackgroundColor3 = Theme.CategoryInactive}):Play()
        if ActiveCat.TextLabel then ActiveCat.TextLabel.TextColor3 = Theme.TextSecondary end
    end
    TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.CategoryActive}):Play()
    if btn.TextLabel then btn.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255) end
    ActiveCat = btn
    for _, child in pairs(contentFrame:GetChildren()) do
        if child:IsA("Frame") and child.Name ~= "UIListLayout" and child.Name ~= "UICorner" and child.Name ~= "UIStroke" then
            child.Parent = nil
        end
    end
    if CatFrames[name] then
        for i, frame in pairs(CatFrames[name]) do
            frame.Parent = contentFrame
            frame.LayoutOrder = i
        end
        local count = #CatFrames[name]
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, count * 35 + (count > 0 and (count - 1) * 6 or 0) + 10)
    end
end

for i, cat in pairs(Categories) do
    local btn = Instance.new("TextButton")
    btn.Name = cat
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.BackgroundColor3 = Theme.CategoryInactive
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.LayoutOrder = i
    btn.Parent = sidebarFrame
    local btnCorner = Instance.new("UICorner"); btnCorner.CornerRadius = UDim.new(0, 6); btnCorner.Parent = btn
    local btnStroke = Instance.new("UIStroke"); btnStroke.Color = Theme.Accent; btnStroke.Thickness = 1; btnStroke.Transparency = 0.5; btnStroke.Parent = btn
    local btnLabel = Instance.new("TextLabel")
    btnLabel.Name = "TextLabel"
    btnLabel.Size = UDim2.new(1, 0, 1, 0)
    btnLabel.BackgroundTransparency = 1
    btnLabel.Text = cat
    btnLabel.Font = Enum.Font.GothamSemibold
    btnLabel.TextSize = 13
    btnLabel.TextColor3 = Theme.TextSecondary
    btnLabel.Parent = btn
    btn.MouseEnter:Connect(function()
        if btn ~= ActiveCat then TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.BindHover}):Play() end
    end)
    btn.MouseLeave:Connect(function()
        if btn ~= ActiveCat then TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.CategoryInactive}):Play() end
    end)
    btn.MouseButton1Click:Connect(function() SwitchCategory(cat) end)
    CatButtons[cat] = btn
end

local KB = {}

-- Combat
table.insert(CatFrames.Combat, createToggleRow("Silent Aim", true, function() return silentAimEnabled end, SilentAim_Enable, SilentAim_Disable, function() return KB.silentAim end, function(v) KB.silentAim = v end))
table.insert(CatFrames.Combat, createToggleRow("No Recoil", true, function() return noRecoilEnabled end, NoRecoil_Enable, NoRecoil_Disable, function() return KB.noRecoil end, function(v) KB.noRecoil = v end))

-- Movement
table.insert(CatFrames.Movement, createToggleRow("Fly", true, function() return flyEnabled end, Fly_Enable, Fly_Disable, function() return KB.fly end, function(v) KB.fly = v end))
table.insert(CatFrames.Movement, createToggleRow("Noclip", true, function() return noclipEnabled end, Noclip_Enable, Noclip_Disable, function() return KB.noclip end, function(v) KB.noclip = v end))
table.insert(CatFrames.Movement, createToggleRow("Inf Stamina", true, function() return infStaminaEnabled end, InfiniteStamina_Enable, InfiniteStamina_Disable, function() return KB.infStamina end, function(v) KB.infStamina = v end))
table.insert(CatFrames.Movement, createToggleRow("Invisibility", true, _G.IsInvisEnabled, _G.Invis_Enable, _G.Invis_Disable, function() return KB.invis end, function(v) KB.invis = v end))

-- Visuals
table.insert(CatFrames.Visuals, createToggleRow("Player ESP", true, function() return playerESPEnabled end, PlayerESP_Enable, PlayerESP_Disable, function() return KB.esp end, function(v) KB.esp = v end))
table.insert(CatFrames.Visuals, createToggleRow("Safe ESP", true, function() return safeESPEnabled end, SafeESP_Enable, SafeESP_Disable, function() return KB.safeESP end, function(v) KB.safeESP = v end))
table.insert(CatFrames.Visuals, createToggleRow("FullBright", true, function() return fullbrightEnabled end, FullBright_Enable, FullBright_Disable, function() return KB.fullbright end, function(v) KB.fullbright = v end))

-- Farming
table.insert(CatFrames.Farming, createToggleRow("Auto Farm", true, function() return autoFarmEnabled end, AutoFarm_Enable, AutoFarm_Disable, function() return KB.autoFarm end, function(v) KB.autoFarm = v end))
table.insert(CatFrames.Farming, createToggleRow("Auto Pickup $", true, function() return autoPickupEnabled end, AutoPickup_Enable, AutoPickup_Disable, function() return KB.autoPickup end, function(v) KB.autoPickup = v end))
table.insert(CatFrames.Farming, createToggleRow("No Fail Lockpick", true, function() return noFailLPEnabled end, NoFailLockpick_Enable, NoFailLockpick_Disable, function() return KB.noFailLP end, function(v) KB.noFailLP = v end))

-- Misc
table.insert(CatFrames.Misc, createToggleRow("Admin Detector", true, function() return adminCheckEnabled end, AdminCheck_Enable, AdminCheck_Disable, function() return KB.adminCheck end, function(v) KB.adminCheck = v end))
table.insert(CatFrames.Misc, createToggleRow("Auto Unlock Doors", true, function() return unlockDoorsEnabled end, UnlockDoors_Enable, UnlockDoors_Disable, function() return KB.unlockDoors end, function(v) KB.unlockDoors = v end))

-- ========================= KEYBIND DINLEYICI =========================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if currentRowWaitingForKey and input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode ~= Enum.KeyCode.K then
        local frame = currentRowWaitingForKey
        local bindBtn = bindButtonRefs[frame]
        local getFn = keyBindGetters[frame]
        local setFn = keyBindSetters[frame]
        local fData = rowFuncData[frame]
        if bindBtn and getFn and setFn and fData then
            local oldKey = nil
            local s, r = pcall(getFn); if s then oldKey = r end
            if oldKey and activeBinds[oldKey] then activeBinds[oldKey] = nil end
            if activeBinds[input.KeyCode] then
                local otherFrame = activeBinds[input.KeyCode].frame
                local otherBtn = bindButtonRefs[otherFrame]
                local otherSet = keyBindSetters[otherFrame]
                if otherSet then pcall(otherSet, nil) end
                if otherBtn then otherBtn.Text = "Bind" end
                activeBinds[input.KeyCode] = nil
            end
            pcall(setFn, input.KeyCode)
            bindBtn.Text = "[" .. input.KeyCode.Name .. "]"
            local toggleBtn = nil
            for _, child in pairs(frame:GetChildren()) do
                if child:IsA("TextButton") and child ~= bindBtn then toggleBtn = child; break end
            end
            if toggleBtn then
                activeBinds[input.KeyCode] = {
                    frame = frame, toggleButton = toggleBtn,
                    isEnabledFn = fData.isEnabledFn, onEnable = fData.onEnable,
                    onDisable = fData.onDisable, canToggle = fData.canToggle, updateFn = fData.updateFn
                }
            end
            currentRowWaitingForKey = nil
        end
    elseif activeBinds[input.KeyCode] then
        local info = activeBinds[input.KeyCode]
        if info.canToggle and info.onEnable and info.onDisable and info.isEnabledFn and info.updateFn then
            local s, state = pcall(info.isEnabledFn)
            if s then
                if state then pcall(info.onDisable) else pcall(info.onEnable) end
                task.wait()
                pcall(info.updateFn)
            end
        end
    end
end)

-- ========================= BASLANGIC =========================
SwitchCategory("Combat")
mainFrame.Size = UDim2.new(0, 0, 0, 0)
local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 450, 0, 350)})
task.wait(0.1)
openTween:Play()

print("SANTES HUB YUKLENDI - IYI KEYIFLER :)")
