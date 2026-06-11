--[[
    SANTES HUB v3.0 FINAL | CRIMINALITY
    - Fling Fly (Roblox joystick uyumlu - MoveDirection)
    - Silent Aim FIXED (pcall korumali)
    - Auto Farm FIXED (dealer + safe logic)
    - UI Drag FIXED
    - Minimize button with logo
    - Close button FULL cleanup (tum moduller + tum GUI'ler)
    - Mobile uyumlu (joystick otomatik algilanir, ekstra buton yok)
    - Theme: Kirmizi/Siyah
    - Tum moduller: ESP, Safe ESP, No Recoil, Inf Stamina, FullBright, FOV,
      Noclip, Invisibility, No Fail Lockpick, Auto Pickup, Auto Unlock Doors,
      Admin Detector, Silent Aim, Fly (Fling), Auto Farm
--]]

-- ==================== SERVICES ====================
local VirtualUser = game:GetService('VirtualUser')
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ==================== ANTI-AFK ====================
if LocalPlayer then
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- ==================== FULL CLEANUP FUNCTION ====================
local function FullCleanup()
    -- Disable all modules
    pcall(function() if Fly_Enabled then Fly_Disable() end end)
    pcall(function() if ESP_Enabled then ESP_Disable() end end)
    pcall(function() if NoRecoil_Enabled then NoRecoil_Disable() end end)
    pcall(function() if InfStamina_Enabled then InfiniteStamina_Disable() end end)
    pcall(function() if SilentAim_Enabled then SilentAim_Disable() end end)
    pcall(function() if Noclip_Enabled then Noclip_Disable() end end)
    pcall(function() if FullBright_Enabled then FullBright_Disable() end end)
    pcall(function() if FOV_Enabled then FOV_Disable() end end)
    pcall(function() if AdminCheck_Enabled then AdminCheck_Disable() end end)
    pcall(function() if AutoPickup_Enabled then AutoPickup_Disable() end end)
    pcall(function() if AF_Enabled then AutoFarm_Disable() end end)
    pcall(function() if Invis_Enabled then Invis_Disable() end end)
    pcall(function() if NoFailLP_Enabled then NoFailLP_Disable() end end)
    pcall(function() if SafeESP_Enabled then SafeESP_Disable() end end)
    pcall(function() if UnlockDoors_Enabled then UnlockDoors_Disable() end end)
    
    -- Destroy all GUIs
    local guiNames = {
        "SantesHubScreenGui", "SantesHubScreenGui_Categorized", 
        "EQRHubScreenGui", "VenomHubScreenGui", 
        "ShadowWarningHUD", "InvisWarningGUI", "InvisWarning", 
        "SantesMinimizeFrame", "SantesMobileControls"
    }
    for _, name in pairs(guiNames) do
        pcall(function() 
            local gui = PlayerGui:FindFirstChild(name)
            if gui then gui:Destroy() end 
        end)
        pcall(function() 
            local gui = CoreGui:FindFirstChild(name)
            if gui then gui:Destroy() end 
        end)
    end
end

-- ==================== INITIAL CLEANUP ====================
do
    local guiNames = {
        "SantesHubScreenGui", "SantesHubScreenGui_Categorized", 
        "EQRHubScreenGui", "VenomHubScreenGui", 
        "ShadowWarningHUD", "InvisWarningGUI", "InvisWarning", 
        "SantesMinimizeFrame", "SantesMobileControls"
    }
    for _, name in pairs(guiNames) do
        local gui = PlayerGui:FindFirstChild(name)
        if gui then gui:Destroy() end
        local gui2 = CoreGui:FindFirstChild(name)
        if gui2 then gui2:Destroy() end
    end
end

-- ==================== THEME: KIRMIZI/SIYAH ====================
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

local LogoURL = "https://i.ibb.co/tdPdCq6/logo.png"

-- ==================== GUI CONSTRUCTION ====================
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

-- Main frame corner
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Main frame stroke
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Theme.Accent
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.3
mainStroke.Parent = mainFrame

-- ==================== TITLE BAR ====================
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = Theme.Background
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Title text
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -90, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "SANTES HUB v3.0"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Theme.TextPrimary
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- ==================== MINIMIZE BUTTON ====================
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 32, 0, 32)
minimizeButton.Position = UDim2.new(1, -75, 0, 5)
minimizeButton.Text = "-"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 20
minimizeButton.TextColor3 = Theme.TextPrimary
minimizeButton.BackgroundColor3 = Color3.fromRGB(180, 150, 30)
minimizeButton.BorderSizePixel = 0
minimizeButton.AutoButtonColor = false
minimizeButton.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeButton

-- ==================== CLOSE BUTTON ====================
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

-- Close button events
closeButton.MouseButton1Click:Connect(function()
    FullCleanup()
end)
closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.15), {BackgroundColor3 = Theme.AccentHover}):Play()
end)
closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Accent}):Play()
end)

-- ==================== MINIMIZE FRAME ====================
local minimizeFrame = Instance.new("Frame")
minimizeFrame.Name = "SantesMinimizeFrame"
minimizeFrame.Size = UDim2.new(0, 50, 0, 50)
minimizeFrame.Position = UDim2.new(0.01, 0, 0.01, 0)
minimizeFrame.BackgroundColor3 = Theme.FrameBg
minimizeFrame.BorderSizePixel = 0
minimizeFrame.Visible = false
minimizeFrame.Active = true
minimizeFrame.Draggable = true
minimizeFrame.Parent = screenGui

local minFrameCorner = Instance.new("UICorner")
minFrameCorner.CornerRadius = UDim.new(0, 8)
minFrameCorner.Parent = minimizeFrame

local minFrameStroke = Instance.new("UIStroke")
minFrameStroke.Color = Theme.Accent
minFrameStroke.Thickness = 2
minFrameStroke.Parent = minimizeFrame

-- Logo inside minimize frame
local logoImage = Instance.new("ImageLabel")
logoImage.Size = UDim2.new(1, -10, 1, -10)
logoImage.Position = UDim2.new(0, 5, 0, 5)
logoImage.BackgroundTransparency = 1
logoImage.Image = LogoURL
logoImage.ScaleType = Enum.ScaleType.Fit
logoImage.Parent = minimizeFrame

-- Minimize frame click to restore
minimizeFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        minimizeFrame.Visible = false
        mainFrame.Visible = true
    end
end)

-- Minimize button events
minimizeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    minimizeFrame.Visible = true
end)
minimizeButton.MouseEnter:Connect(function()
    TweenService:Create(minimizeButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(220, 190, 50)}):Play()
end)
minimizeButton.MouseLeave:Connect(function()
    TweenService:Create(minimizeButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(180, 150, 30)}):Play()
end)

-- ==================== DIVIDER ====================
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -20, 0, 2)
divider.Position = UDim2.new(0, 10, 0, 42)
divider.BackgroundColor3 = Theme.Accent
divider.BorderSizePixel = 0
divider.Parent = mainFrame

-- ==================== SIDEBAR ====================
local sidebarFrame = Instance.new("Frame")
sidebarFrame.Size = UDim2.new(0, 120, 1, -68)
sidebarFrame.Position = UDim2.new(0, 8, 0, 50)
sidebarFrame.BackgroundColor3 = Theme.SidebarBg
sidebarFrame.BorderSizePixel = 0
sidebarFrame.Parent = mainFrame

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 8)
sidebarCorner.Parent = sidebarFrame

local sidebarStroke = Instance.new("UIStroke")
sidebarStroke.Color = Theme.Accent
sidebarStroke.Thickness = 1
sidebarStroke.Transparency = 0.5
sidebarStroke.Parent = sidebarFrame

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Padding = UDim.new(0, 4)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sidebarLayout.Parent = sidebarFrame

-- ==================== CONTENT FRAME ====================
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -145, 1, -68)
contentFrame.Position = UDim2.new(0, 138, 0, 50)
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
contentStroke.Transparency = 0.5
contentStroke.Parent = contentFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 6)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
contentLayout.Parent = contentFrame

-- ==================== FOOTER ====================
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

-- ==================== DRAGGING SYSTEM ====================
do
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local dragInput = nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
        
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ==================== TOGGLE KEY ====================
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.K then
        if minimizeFrame.Visible then
            minimizeFrame.Visible = false
            mainFrame.Visible = true
        else
            mainFrame.Visible = not mainFrame.Visible
        end
    end
end)

-- ==================== TOGGLE ROW CREATOR ====================
local activeBinds = {}
local currentRowWaitingForKey = nil
local bindButtonRefs = {}
local keyBindGetters = {}
local keyBindSetters = {}
local toggleTweens = {}
local rowFuncData = {}

local function createToggleRow(scriptName, canToggle, isEnabledFn, onEnable, onDisable, getKeyBindFn, setKeyBindFn)
    -- Create frame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -16, 0, 35)
    frame.BackgroundTransparency = 1
    frame.Name = scriptName:gsub("%s+", "")

    -- Layout
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.Parent = frame

    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.43, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = " " .. scriptName
    label.TextColor3 = Theme.TextSecondary
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.LayoutOrder = 1
    label.Parent = frame

    -- Toggle button
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

    -- Toggle button styling
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(0, 6)
    tCorner.Parent = toggleBtn
    
    local tStroke = Instance.new("UIStroke")
    tStroke.Color = Theme.Accent
    tStroke.Thickness = 1
    tStroke.Transparency = 0.4
    tStroke.Parent = toggleBtn

    local bindBtn = nil

    -- Get target color for toggle
    local function getTargetColor()
        local state = false
        if type(isEnabledFn) == 'function' then
            local s, r = pcall(isEnabledFn)
            if s then state = r end
        end
        if not canToggle then 
            return Color3.fromRGB(120, 40, 40) 
        end
        return state and Theme.ButtonOn or Theme.ButtonOff
    end

    -- Update visuals function
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
        
        if toggleTweens[toggleBtn] then 
            toggleTweens[toggleBtn]:Cancel()
            toggleTweens[toggleBtn] = nil 
        end
        toggleBtn.BackgroundColor3 = targetColor
    end

    -- Store row function data
    rowFuncData[frame] = {
        isEnabledFn = isEnabledFn, 
        onEnable = onEnable, 
        onDisable = onDisable,
        canToggle = canToggle, 
        updateFn = updateVisuals
    }

    -- Bind button creation
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

        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0, 6)
        bCorner.Parent = bindBtn
        
        local bStroke = Instance.new("UIStroke")
        bStroke.Color = Theme.Accent
        bStroke.Thickness = 1
        bStroke.Transparency = 0.4
        bStroke.Parent = bindBtn

        bindButtonRefs[frame] = bindBtn
        keyBindGetters[frame] = getKeyBindFn
        keyBindSetters[frame] = setKeyBindFn

        -- Initialize keybind
        local initKey = nil
        local s, r = pcall(getKeyBindFn)
        if s and r and typeof(r) == "EnumItem" then
            initKey = r
            if rowFuncData[frame] then
                activeBinds[initKey] = {
                    frame = frame,
                    toggleButton = toggleBtn,
                    isEnabledFn = rowFuncData[frame].isEnabledFn,
                    onEnable = rowFuncData[frame].onEnable,
                    onDisable = rowFuncData[frame].onDisable,
                    canToggle = rowFuncData[frame].canToggle,
                    updateFn = rowFuncData[frame].updateFn
                }
            end
        end
    else
        toggleBtn.Size = UDim2.new(0.55, 0, 0.8, 0)
    end

    -- Update bind button text
    local function updateBindText()
        if not bindBtn then return end
        local kb = nil
        if type(getKeyBindFn) == 'function' then
            local s, r = pcall(getKeyBindFn)
            if s then kb = r end
        end
        bindBtn.Text = (kb and typeof(kb) == "EnumItem" and kb.Name ~= "Unknown") and "["..kb.Name.."]" or "Bind"
    end

    -- Initialize
    updateVisuals()
    updateBindText()

    -- Toggle button hover effects
    toggleBtn.MouseEnter:Connect(function()
        if toggleTweens[toggleBtn] then 
            toggleTweens[toggleBtn]:Cancel()
            toggleTweens[toggleBtn] = nil 
        end
        local target = getTargetColor()
        local hoverTarget = target:Lerp(Color3.new(1, 1, 1), 0.2)
        local tween = TweenService:Create(toggleBtn, TweenInfo.new(0.1), {BackgroundColor3 = hoverTarget})
        toggleTweens[toggleBtn] = tween
        tween:Play()
    end)
    
    toggleBtn.MouseLeave:Connect(function()
        if toggleTweens[toggleBtn] then 
            toggleTweens[toggleBtn]:Cancel()
            toggleTweens[toggleBtn] = nil 
        end
        local tween = TweenService:Create(toggleBtn, TweenInfo.new(0.1), {BackgroundColor3 = getTargetColor()})
        toggleTweens[toggleBtn] = tween
        tween:Play()
    end)

    -- Bind button hover effects
    if bindBtn then
        bindBtn.MouseEnter:Connect(function()
            TweenService:Create(bindBtn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.BindHover}):Play()
        end)
        bindBtn.MouseLeave:Connect(function()
            TweenService:Create(bindBtn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.BindButton}):Play()
        end)
        
        -- Bind button click handler
        local capturing = false
        bindBtn.MouseButton1Click:Connect(function()
            if currentRowWaitingForKey and currentRowWaitingForKey ~= frame then
                local prevBtn = bindButtonRefs[currentRowWaitingForKey]
                if prevBtn then
                    local getter = keyBindGetters[currentRowWaitingForKey]
                    local txt = "Bind"
                    if getter then
                        local s, r = pcall(getter)
                        if s and r and typeof(r) == "EnumItem" then 
                            txt = "["..r.Name.."]" 
                        end
                    end
                    prevBtn.Text = txt
                end
            end
            
            if capturing then
                capturing = false
                updateBindText()
                currentRowWaitingForKey = nil
            else
                capturing = true
                bindBtn.Text = "..."
                currentRowWaitingForKey = frame
                task.delay(5, function()
                    if capturing and currentRowWaitingForKey == frame then
                        capturing = false
                        updateBindText()
                        currentRowWaitingForKey = nil
                    end
                end)
            end
        end)
    end

    -- Toggle button click handler
    toggleBtn.MouseButton1Click:Connect(function()
        local state = false
        if type(isEnabledFn) == 'function' then
            local s, r = pcall(isEnabledFn)
            if s then state = r end
        end
        
        if not canToggle then
            if type(onEnable) == 'function' then 
                pcall(onEnable) 
            end
            toggleBtn.Text = "DONE"
            toggleBtn.BackgroundColor3 = Theme.ButtonOn:Lerp(Color3.fromRGB(10, 10, 12), 0.3)
            toggleBtn.Active = false
            if bindBtn then 
                bindBtn.Active = false 
            end
            return
        end
        
        if state then
            if type(onDisable) == 'function' then 
                pcall(onDisable) 
            end
        else
            if type(onEnable) == 'function' then 
                pcall(onEnable) 
            end
        end
        updateVisuals()
    end)

    return frame
end

-- ==================== MODULES ====================

-- ==================== 1. FLY (FLING STYLE - Mobile Joystick Uyumlu) ====================
local Fly_Enabled = false
local Fly_Connection = nil
local Fly_BaseSpeed = 60
local Fly_BoostSpeed = 120

function Fly_Enable()
    if Fly_Enabled then return end
    Fly_Enabled = true
    
    Fly_Connection = RunService.Heartbeat:Connect(function(dt)
        if not Fly_Enabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        
        -- PlatformStand zorunlu (dusmeyi engeller)
        hum.PlatformStand = true
        
        local cam = workspace.CurrentCamera
        if not cam then return end
        
        -- MoveDirection: Roblox'un kendi kontrol cubugu (hem klavye WASD hem mobil joystick)
        local moveDir = Vector3.zero
        local humMoveDir = hum.MoveDirection
        
        -- Eger MoveDirection'da hareket varsa, kameraya gore yonlendir
        if humMoveDir.Magnitude > 0 then
            moveDir += humMoveDir
        end
        
        -- Space = yukari fling
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir += Vector3.new(0, 1, 0)
        end
        
        -- LeftControl = asagi fling
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDir -= Vector3.new(0, 1, 0)
        end
        
        -- Hicbir yone basilmiyorsa surtunme uygula
        if moveDir.Magnitude < 0.1 then
            hrp.Velocity = hrp.Velocity * 0.95
            return
        end
        
        -- LeftShift = turbo boost
        local speed = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and Fly_BoostSpeed or Fly_BaseSpeed
        
        -- Velocity'yi direkt hedef yone ayarla
        hrp.Velocity = moveDir.Unit * speed
    end)
end

function Fly_Disable()
    Fly_Enabled = false
    if Fly_Connection then 
        Fly_Connection:Disconnect()
        Fly_Connection = nil 
    end
    
    -- Karakteri normale dondur
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hum then 
            hum.PlatformStand = false 
        end
        if hrp then 
            hrp.Velocity = Vector3.zero 
        end
    end
end

-- ==================== 2. NOCLIP ====================
local Noclip_Enabled = false
local Noclip_Conn = nil

function Noclip_Enable()
    if Noclip_Enabled then return end
    Noclip_Enabled = true
    
    Noclip_Conn = RunService.Stepped:Connect(function()
        if Noclip_Enabled and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then 
                    part.CanCollide = false 
                end
            end
        end
    end)
end

function Noclip_Disable()
    Noclip_Enabled = false
    if Noclip_Conn then 
        Noclip_Conn:Disconnect()
        Noclip_Conn = nil 
    end
end

-- ==================== 3. INFINITE STAMINA ====================
local InfStamina_Enabled = false
local staminaHooked = false

function InfiniteStamina_Enable()
    InfStamina_Enabled = true
    if staminaHooked then return end
    staminaHooked = true
    
    task.spawn(function()
        for i = 1, 20 do
            local env = nil
            local s1, e1 = pcall(function() return getrenv() end)
            if s1 then 
                env = e1 
            else 
                local s2, e2 = pcall(function() return getfenv() end)
                if s2 then env = e2 end 
            end
            
            if env and env._G and type(env._G.S_Take) == "function" then
                local s3, upval = pcall(function() return getupvalue(env._G.S_Take, 2) end)
                if s3 and type(upval) == "function" then
                    local original = upval
                    hookfunction(upval, function(v1, ...)
                        if InfStamina_Enabled then 
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
    InfStamina_Enabled = false
end

-- ==================== 4. FULLBRIGHT ====================
local FullBright_Enabled = false
local FullBright_Conn = nil
local OrigLighting = {}

function FullBright_Enable()
    if FullBright_Enabled then return end
    FullBright_Enabled = true
    
    OrigLighting = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd
    }
    
    FullBright_Conn = RunService.RenderStepped:Connect(function()
        if FullBright_Enabled then
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
    FullBright_Enabled = false
    if FullBright_Conn then 
        FullBright_Conn:Disconnect()
        FullBright_Conn = nil 
    end
    
    if OrigLighting.Brightness then
        Lighting.Brightness = OrigLighting.Brightness
        Lighting.ClockTime = OrigLighting.ClockTime
        Lighting.Ambient = OrigLighting.Ambient
        Lighting.OutdoorAmbient = OrigLighting.OutdoorAmbient
        Lighting.FogStart = OrigLighting.FogStart
        Lighting.FogEnd = OrigLighting.FogEnd
    end
end

-- ==================== 5. FOV CHANGER ====================
local FOV_Enabled = false
local FOV_Value = 100
local FOV_Original = workspace.CurrentCamera and workspace.CurrentCamera.FieldOfView or 70
local FOV_Conn = nil

function FOV_Enable()
    if FOV_Enabled then return end
    FOV_Enabled = true
    if workspace.CurrentCamera then 
        FOV_Original = workspace.CurrentCamera.FieldOfView 
    end
    
    FOV_Conn = RunService.RenderStepped:Connect(function()
        if FOV_Enabled and workspace.CurrentCamera then
            workspace.CurrentCamera.FieldOfView = FOV_Value
        end
    end)
end

function FOV_Disable()
    FOV_Enabled = false
    if FOV_Conn then 
        FOV_Conn:Disconnect()
        FOV_Conn = nil 
    end
    if workspace.CurrentCamera then 
        workspace.CurrentCamera.FieldOfView = FOV_Original 
    end
end

-- ==================== 6. NO FAIL LOCKPICK ====================
local NoFailLP_Enabled = false
local NoFailLP_Conn = nil

function NoFailLP_Enable()
    if NoFailLP_Enabled then return end
    NoFailLP_Enabled = true
    
    NoFailLP_Conn = PlayerGui.ChildAdded:Connect(function(item)
        if item.Name == "LockpickGUI" then
            task.wait(0.1)
            pcall(function()
                local frames = item.MF and item.MF.LP_Frame and item.MF.LP_Frame.Frames
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
            end)
        end
    end)
end

function NoFailLP_Disable()
    NoFailLP_Enabled = false
    if NoFailLP_Conn then 
        NoFailLP_Conn:Disconnect()
        NoFailLP_Conn = nil 
    end
end

-- ==================== 7. SAFE ESP ====================
local SafeESP_Enabled = false
local SafeESP_Conn = nil

local function SafeESP_Update()
    local folder = Workspace.Map and Workspace.Map:FindFirstChild("BredMakurz")
    if not folder then 
        folder = Workspace:FindFirstChild("BredMakurz") 
    end
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
                            if tl and tl.Parent then
                                tl.TextColor3 = val and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
                            end
                        end)
                    else
                        tl.TextColor3 = Color3.fromRGB(0, 255, 0)
                    end
                end
            elseif existing then
                existing:Destroy()
            end
        end
    end
end

function SafeESP_Enable()
    if SafeESP_Enabled then return end
    SafeESP_Enabled = true
    SafeESP_Conn = RunService.Heartbeat:Connect(SafeESP_Update)
end

function SafeESP_Disable()
    SafeESP_Enabled = false
    if SafeESP_Conn then 
        SafeESP_Conn:Disconnect()
        SafeESP_Conn = nil 
    end
end

-- ==================== 8. AUTO PICKUP MONEY ====================
local AutoPickup_Enabled = false
local AutoPickup_Conn = nil
local PickupCooldown = false

function AutoPickup_Enable()
    if AutoPickup_Enabled then return end
    AutoPickup_Enabled = true
    
    AutoPickup_Conn = RunService.RenderStepped:Connect(function()
        if not AutoPickup_Enabled or PickupCooldown then return end
        
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart
        
        local folder = Workspace.Filter and Workspace.Filter:FindFirstChild("SpawnedBread")
        if not folder then 
            folder = Workspace:FindFirstChild("SpawnedBread") 
        end
        if not folder then return end
        
        local remote = ReplicatedStorage.Events and ReplicatedStorage.Events:FindFirstChild("CZDPZUS")
        if not remote then return end
        
        for _, bread in pairs(folder:GetChildren()) do
            if bread:IsA("BasePart") and (hrp.Position - bread.Position).Magnitude < 5 then
                PickupCooldown = true
                pcall(function() remote:FireServer(bread) end)
                task.wait(1)
                PickupCooldown = false
                break
            end
        end
    end)
end

function AutoPickup_Disable()
    AutoPickup_Enabled = false
    PickupCooldown = false
    if AutoPickup_Conn then 
        AutoPickup_Conn:Disconnect()
        AutoPickup_Conn = nil 
    end
end

-- ==================== 9. AUTO UNLOCK DOORS ====================
local UnlockDoors_Enabled = false
local UnlockDoors_Conn = nil

function UnlockDoors_Enable()
    if UnlockDoors_Enabled then return end
    UnlockDoors_Enabled = true
    
    UnlockDoors_Conn = RunService.Heartbeat:Connect(function()
        if not UnlockDoors_Enabled then return end
        
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
                        -- Unlock door
                        local locked = values:FindFirstChild("Locked")
                        local lockPart = door:FindFirstChild("Lock")
                        if locked and lockPart and locked.Value == true then
                            pcall(function() toggle:FireServer("Unlock", lockPart) end)
                        end
                        
                        -- Open door
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
    UnlockDoors_Enabled = false
    if UnlockDoors_Conn then 
        UnlockDoors_Conn:Disconnect()
        UnlockDoors_Conn = nil 
    end
end

-- ==================== 10. ADMIN DETECTOR ====================
local AdminCheck_Enabled = false
local AdminCheck_Conn = nil

local StaffUsers = {
    3294804378, 93676120, 54087314, 81275825, 140837601, 1229486091, 46567801, 418086275,
    29706395, 3717066084, 1424338327, 5046662686, 5046661126, 5046659439, 418199326, 1024216621,
    1810535041, 63238912, 111250044, 63315426, 730176906, 141193516, 194512073, 193945439,
    412741116, 195538733, 102045519, 955294, 957835150, 25689921, 366613818, 281593651,
    455275714, 208929505, 96783330, 156152502, 93281166, 959606619, 142821118, 632886139,
    175931803, 122209625, 278097946, 142989311, 1517131734, 446849296, 87189764, 67180844,
    9212846, 47352513, 48058122, 155413858, 10497435, 513615792, 55893752, 55476024, 151691292,
    136584758, 16983447, 3111449, 94693025, 271400893, 5005262660, 295331237, 64489098,
    244844600, 114332275, 25048901, 69262878, 50801509, 92504899, 42066711, 50585425, 31365111,
    166406495, 2457253857, 29761878, 21831137, 948293345, 439942262, 38578487, 1163048,
    7713309208, 3659305297, 15598614, 34616594, 626833004, 198610386, 153835477, 3923114296,
    3937697838, 102146039, 119861460, 371665775, 1206543842, 93428604, 1863173316, 90814576,
    374665997, 423005063, 140172831, 42662179, 9066859, 438805620, 14855669, 727189337,
    1871290386, 608073286
}

function AdminCheck_Enable()
    if AdminCheck_Enabled then return end
    AdminCheck_Enabled = true
    
    local function checkPlayer(player)
        if player == LocalPlayer then return false end
        
        for _, uid in pairs(StaffUsers) do
            if player.UserId == uid then
                pcall(function() 
                    LocalPlayer:Kick("SANTES: Staff detected - " .. player.Name) 
                end)
                return true
            end
        end
        return false
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if checkPlayer(player) then return end
    end
    
    AdminCheck_Conn = Players.PlayerAdded:Connect(checkPlayer)
end

function AdminCheck_Disable()
    AdminCheck_Enabled = false
    if AdminCheck_Conn then 
        AdminCheck_Conn:Disconnect()
        AdminCheck_Conn = nil 
    end
end

-- ==================== 11. PLAYER ESP ====================
local ESP_Enabled = false
local ESP_Connections = {}
local ESP_Players = {}

local function ESP_CreateForPlayer(player)
    if player == LocalPlayer or ESP_Players[player] then return end
    ESP_Players[player] = true
    
    local function setupESP(char)
        if not ESP_Enabled or not char or not char.Parent then return end
        
        -- Remove existing
        local existingHL = char:FindFirstChild("Santes_PlayerESP")
        if existingHL then existingHL:Destroy() end
        
        -- Create highlight
        local highlight = Instance.new("Highlight")
        highlight.Name = "Santes_PlayerESP"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.65
        highlight.OutlineColor = Color3.fromRGB(255, 40, 40)
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = char
        
        -- Name tag
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
        setupESP(player.Character)
    end
    
    local charConn = player.CharacterAdded:Connect(setupESP)
    table.insert(ESP_Connections, charConn)
end

function ESP_Enable()
    if ESP_Enabled then return end
    ESP_Enabled = true
    ESP_Players = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        ESP_CreateForPlayer(player)
    end
    
    table.insert(ESP_Connections, Players.PlayerAdded:Connect(function(player)
        if ESP_Enabled then
            ESP_CreateForPlayer(player)
        end
    end))
    
    table.insert(ESP_Connections, Players.PlayerRemoving:Connect(function(player)
        ESP_Players[player] = nil
    end))
end

function ESP_Disable()
    ESP_Enabled = false
    
    for _, conn in pairs(ESP_Connections) do
        pcall(function() conn:Disconnect() end)
    end
    ESP_Connections = {}
    ESP_Players = {}
    
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
end

-- ==================== 12. INVISIBILITY (SHADOW MODE) ====================
local Invis_Enabled = false
local Invis_Usable = true
local Invis_Track = nil
local Invis_Char = nil
local Invis_Hum = nil
local Invis_HRP = nil
local Invis_GUI = nil
local Invis_WarnLabel = nil

do
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://215384594"
    
    local function updateRefs()
        Invis_Char = LocalPlayer.Character
        Invis_Hum = Invis_Char and Invis_Char:FindFirstChildOfClass("Humanoid")
        Invis_HRP = Invis_Char and Invis_Char:FindFirstChild("HumanoidRootPart")
    end
    
    local function grounded()
        return Invis_Hum and Invis_Hum:IsDescendantOf(Workspace) and Invis_Hum.FloorMaterial ~= Enum.Material.Air
    end
    
    local function loadTrack()
        if Invis_Track then 
            pcall(function() Invis_Track:Stop() end)
            Invis_Track = nil 
        end
        
        if Invis_Hum then
            local s, r = pcall(function() return Invis_Hum:LoadAnimation(anim) end)
            if s then 
                Invis_Track = r
                Invis_Track.Priority = Enum.AnimationPriority.Action4 
            end
        end
    end
    
    RunService.Heartbeat:Connect(function(dt)
        if not Invis_Enabled or not Invis_Usable then
            if not Invis_Enabled and Invis_Char then
                for _, v in pairs(Invis_Char:GetDescendants()) do
                    if v:IsA("BasePart") and v.Transparency == 0.5 then 
                        v.Transparency = 0 
                    end
                end
            end
            if Invis_WarnLabel then 
                Invis_WarnLabel.Visible = false 
            end
            return
        end
        
        if not Invis_Char or not Invis_Hum or not Invis_HRP or Invis_Hum.Health <= 0 then
            if Invis_WarnLabel then 
                Invis_WarnLabel.Visible = false 
            end
            return
        end
        
        if Invis_WarnLabel then 
            Invis_WarnLabel.Visible = not grounded() 
        end
        
        local speed = 12
        if Invis_Hum.MoveDirection.Magnitude > 0 then
            Invis_HRP.CFrame += Invis_Hum.MoveDirection * speed * dt
        end
        
        local oldCF = Invis_HRP.CFrame
        local oldOffset = Invis_Hum.CameraOffset
        
        local _, y = workspace.CurrentCamera.CFrame:ToOrientation()
        Invis_HRP.CFrame = CFrame.new(Invis_HRP.Position) * CFrame.fromOrientation(0, y, 0) * CFrame.Angles(math.rad(90), 0, 0)
        Invis_Hum.CameraOffset = Vector3.new(0, 1.44, 0)
        
        if Invis_Track then
            pcall(function()
                if not Invis_Track.IsPlaying then Invis_Track:Play() end
                Invis_Track:AdjustSpeed(0)
                Invis_Track.TimePosition = 0.3
            end)
        elseif Invis_Hum.Health > 0 then
            loadTrack()
        end
        
        RunService.RenderStepped:Wait()
        
        if Invis_Hum:IsDescendantOf(Workspace) then 
            Invis_Hum.CameraOffset = oldOffset 
        end
        if Invis_HRP:IsDescendantOf(Workspace) then 
            Invis_HRP.CFrame = oldCF 
        end
        
        if Invis_Track then 
            pcall(function() Invis_Track:Stop() end) 
        end
        
        if Invis_HRP:IsDescendantOf(Workspace) then
            local lookVec = workspace.CurrentCamera.CFrame.LookVector
            local flat = Vector3.new(lookVec.X, 0, lookVec.Z).Unit
            if flat.Magnitude > 0.1 then
                Invis_HRP.CFrame = CFrame.new(Invis_HRP.Position, Invis_HRP.Position + flat)
            end
        end
        
        for _, v in pairs(Invis_Char:GetDescendants()) do
            if v:IsA("BasePart") and v.Transparency ~= 1 then 
                v.Transparency = 0.5 
            end
        end
    end)
    
    LocalPlayer.CharacterAdded:Connect(function()
        if Invis_Track then 
            pcall(function() Invis_Track:Stop() end)
            Invis_Track = nil 
        end
        
        task.wait()
        updateRefs()
        
        if Invis_Hum and Invis_Hum.RigType ~= Enum.HumanoidRigType.R6 then
            Invis_Usable = false
            if Invis_Enabled then Invis_Disable() end
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "SANTES Invisibility",
                    Text = "R6 avatar gerekli!",
                    Duration = 3
                })
            end)
        else
            Invis_Usable = true
            if Invis_Enabled then
                workspace.CurrentCamera.CameraSubject = Invis_HRP
                loadTrack()
            end
        end
    end)
    
    updateRefs()
    if Invis_Hum and Invis_Hum.RigType ~= Enum.HumanoidRigType.R6 then
        Invis_Usable = false
    end
    
    -- Warning GUI
    Invis_GUI = Instance.new("ScreenGui")
    Invis_GUI.Name = "InvisWarning"
    Invis_GUI.Parent = CoreGui
    Invis_GUI.ResetOnSpawn = false
    
    Invis_WarnLabel = Instance.new("TextLabel", Invis_GUI)
    Invis_WarnLabel.Text = "VISIBLE!"
    Invis_WarnLabel.Visible = false
    Invis_WarnLabel.Size = UDim2.new(0, 200, 0, 30)
    Invis_WarnLabel.Position = UDim2.new(0.5, -100, 0.85, 0)
    Invis_WarnLabel.BackgroundTransparency = 1
    Invis_WarnLabel.Font = Enum.Font.GothamBold
    Invis_WarnLabel.TextSize = 24
    Invis_WarnLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    Invis_WarnLabel.TextStrokeTransparency = 0.5
    
    -- Export functions
    _G.Invis_Enable = function()
        if Invis_Enabled or not Invis_Usable then return end
        Invis_Enabled = true
        updateRefs()
        if Invis_HRP then 
            workspace.CurrentCamera.CameraSubject = Invis_HRP 
        end
        loadTrack()
    end
    
    _G.Invis_Disable = function()
        if not Invis_Enabled then return end
        Invis_Enabled = false
        
        if Invis_Track then 
            pcall(function() Invis_Track:Stop() end) 
        end
        if Invis_Hum then 
            workspace.CurrentCamera.CameraSubject = Invis_Hum 
        end
        if Invis_Char then
            for _, v in pairs(Invis_Char:GetDescendants()) do
                if v:IsA("BasePart") and v.Transparency == 0.5 then 
                    v.Transparency = 0 
                end
            end
        end
        if Invis_WarnLabel then 
            Invis_WarnLabel.Visible = false 
        end
    end
    
    _G.IsInvisEnabled = function() return Invis_Enabled end
end

function Invis_Enable() _G.Invis_Enable() end
function Invis_Disable() _G.Invis_Disable() end

-- ==================== 13. NO RECOIL ====================
local NoRecoil_Enabled = false
local NoRecoil_Original = {}

function NoRecoil_Enable()
    if NoRecoil_Enabled then return end
    NoRecoil_Enabled = true
    
    pcall(function()
        for _, v in pairs(getgc(true)) do
            if type(v) == 'table' and rawget(v, 'Recoil') ~= nil then
                if not NoRecoil_Original[v] then
                    NoRecoil_Original[v] = {
                        Recoil = v.Recoil,
                        Spread = v.Spread,
                        CameraRecoilingEnabled = v.CameraRecoilingEnabled,
                        AngleX_Min = v.AngleX_Min, AngleX_Max = v.AngleX_Max,
                        AngleY_Min = v.AngleY_Min, AngleY_Max = v.AngleY_Max,
                        AngleZ_Min = v.AngleZ_Min, AngleZ_Max = v.AngleZ_Max
                    }
                end
                v.Recoil = 0
                v.Spread = 0
                v.CameraRecoilingEnabled = false
                v.AngleX_Min = 0; v.AngleX_Max = 0
                v.AngleY_Min = 0; v.AngleY_Max = 0
                v.AngleZ_Min = 0; v.AngleZ_Max = 0
            end
        end
    end)
end

function NoRecoil_Disable()
    if not NoRecoil_Enabled then return end
    NoRecoil_Enabled = false
    
    for weapon, orig in pairs(NoRecoil_Original) do
        pcall(function()
            weapon.Recoil = orig.Recoil
            weapon.Spread = orig.Spread
            weapon.CameraRecoilingEnabled = orig.CameraRecoilingEnabled
            weapon.AngleX_Min = orig.AngleX_Min; weapon.AngleX_Max = orig.AngleX_Max
            weapon.AngleY_Min = orig.AngleY_Min; weapon.AngleY_Max = orig.AngleY_Max
            weapon.AngleZ_Min = orig.AngleZ_Min; weapon.AngleZ_Max = orig.AngleZ_Max
        end)
    end
    NoRecoil_Original = {}
end

-- ==================== 14. SILENT AIM (FIXED) ====================
local SilentAim_Enabled = false
local SilentAim_Conn = nil
local SilentAim_FOV = 200

function SilentAim_Enable()
    if SilentAim_Enabled then return end
    SilentAim_Enabled = true
    
    SilentAim_Conn = RunService.RenderStepped:Connect(function()
        if not SilentAim_Enabled then return end
        
        -- Sag fare tusu kontrolu (pcall korumali)
        local sPressed, pressed = pcall(function()
            return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        end)
        if not sPressed or not pressed then return end
        
        local cam = workspace.CurrentCamera
        if not cam then return end
        
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
        
        local sMouse, mousePos = pcall(function() return UserInputService:GetMouseLocation() end)
        if not sMouse then return end
        
        local closest, bestDist = nil, SilentAim_FOV
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                local target = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
                
                if hum and hum.Health > 0 and target then
                    local sScreen, screenPos, onScreen = pcall(function()
                        return cam:WorldToViewportPoint(target.Position)
                    end)
                    
                    if sScreen and onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist < bestDist then
                            bestDist = dist
                            closest = player
                        end
                    end
                end
            end
        end
        
        if closest and closest.Character then
            local targetPart = closest.Character:FindFirstChild("Head") or closest.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                pcall(function()
                    cam.CFrame = CFrame.new(cam.CFrame.Position, targetPart.Position)
                end)
            end
        end
    end)
end

function SilentAim_Disable()
    SilentAim_Enabled = false
    if SilentAim_Conn then 
        SilentAim_Conn:Disconnect()
        SilentAim_Conn = nil 
    end
end

-- ==================== 15. AUTO FARM (FIXED) ====================
local AF_Enabled = false
local AF_Coroutine = nil
local AF_IgnoredSafes = {}

local function AF_Teleport(targetPos)
    local char = LocalPlayer.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    for i = 1, 5 do
        hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
        task.wait(0.3)
        if hrp and hrp.Parent and (hrp.Position - targetPos).Magnitude < 10 then
            return true
        end
        task.wait(0.3)
    end
    return false
end

local function AF_FindDealer()
    local shops = Workspace.Map and Workspace.Map:FindFirstChild("Shopz")
    if not shops then return nil end
    
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local nearest = nil
    local bestDist = math.huge
    local myPos = hrp.Position
    
    for _, shop in pairs(shops:GetChildren()) do
        if shop:IsA("Model") then
            local mainPart = shop:FindFirstChild("MainPart")
            local stocks = shop:FindFirstChild("CurrentStocks")
            
            if mainPart and stocks then
                local crowbarStock = stocks:FindFirstChild("Crowbar")
                if crowbarStock and crowbarStock:IsA("IntValue") and crowbarStock.Value > 0 then
                    local dist = (mainPart.Position - myPos).Magnitude
                    if dist < bestDist then
                        bestDist = dist
                        nearest = shop
                    end
                end
            end
        end
    end
    
    return nearest
end

local function AF_FindTarget()
    local bredFolder = Workspace.Map and Workspace.Map:FindFirstChild("BredMakurz")
    if not bredFolder then
        bredFolder = Workspace:FindFirstChild("BredMakurz")
    end
    if not bredFolder then return nil end
    
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local nearest = nil
    local bestDist = math.huge
    local myPos = hrp.Position
    
    for _, obj in pairs(bredFolder:GetChildren()) do
        if obj:IsA("Model") and (string.find(obj.Name, "Safe") or string.find(obj.Name, "Register")) then
            -- Check if ignored
            local alreadyIgnored = false
            for _, ignored in pairs(AF_IgnoredSafes) do
                if ignored == obj then
                    alreadyIgnored = true
                    break
                end
            end
            
            if not alreadyIgnored then
                local values = obj:FindFirstChild("Values")
                if values then
                    local broken = values:FindFirstChild("Broken")
                    if broken and broken:IsA("BoolValue") and not broken.Value then
                        local targetPart = obj:FindFirstChild("MainPart") or obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
                        if targetPart then
                            local dist = (targetPart.Position - myPos).Magnitude
                            if dist < bestDist then
                                bestDist = dist
                                nearest = obj
                            end
                        end
                    end
                end
            end
        end
    end
    
    return nearest
end

local function AF_HasTool(toolName)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild(toolName) then return true end
    local bp = LocalPlayer.Backpack
    return bp and bp:FindFirstChild(toolName) ~= nil
end

local function AF_EquipTool(toolName)
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    
    local tool = char:FindFirstChild(toolName) or LocalPlayer.Backpack:FindFirstChild(toolName)
    if tool then
        pcall(function() hum:EquipTool(tool) end)
        task.wait(0.5)
        return true
    end
    return false
end

local function AF_OpenSafe(safeModel)
    if not AF_HasTool("Crowbar") then return end
    if not AF_EquipTool("Crowbar") then return end
    
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
        if tick() - startTime > 25 then break end
        
        local char = LocalPlayer.Character
        if not char then break end
        
        pcall(function()
            local result = remote1:InvokeServer("\240\159\141\158", tick(), equipped, "DZDRRRKI", safeModel, "Register")
            if result then
                remote2:FireServer("\240\159\141\158", tick(), equipped, "2389ZFX34", result, false, char["Right Arm"], safePart, safeModel, safePart.Position, safePart.Position)
            end
        end)
        
        task.wait(0.15)
    end
    
    task.wait(6)
end

local function AF_BuyCrowbar(dealer)
    if not dealer then return false end
    local mainPart = dealer:FindFirstChild("MainPart")
    if not mainPart then return false end
    
    if not AF_Teleport(mainPart.Position) then return false end
    
    task.wait(1)
    
    local byzersEvent = ReplicatedStorage.Events and ReplicatedStorage.Events:FindFirstChild("BYZERSPROTEC")
    local shopEvent = ReplicatedStorage.Events and ReplicatedStorage.Events:FindFirstChild("SSHPRMTE1")
    
    if not byzersEvent or not shopEvent then return false end
    
    pcall(function() byzersEvent:FireServer(true, "shop", mainPart, "IllegalStore") end)
    task.wait(0.5)
    pcall(function() shopEvent:InvokeServer("IllegalStore", "Melees", "Crowbar", mainPart, nil, true) end)
    task.wait(2)
    pcall(function() byzersEvent:FireServer(false) end)
    
    return AF_HasTool("Crowbar")
end

local function AF_MainLoop()
    while AF_Enabled do
        task.wait(0.5)
        
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        -- Olu/Respawn kontrolu
        if not char or not hum or hum.Health <= 0 then
            local deathEvent = ReplicatedStorage.Events and ReplicatedStorage.Events:FindFirstChild("DeathRespawn")
            if deathEvent then
                pcall(function() deathEvent:InvokeServer("KMG4R904") end)
            end
            task.wait(3)
            AF_IgnoredSafes = {}
            continue
        end
        
        -- Levye kontrolu
        if not AF_HasTool("Crowbar") then
            local dealer = AF_FindDealer()
            if dealer then
                AF_BuyCrowbar(dealer)
            else
                task.wait(5)
            end
            continue
        end
        
        -- Safe bul ve soy
        local target = AF_FindTarget()
        if target then
            local mainPart = target:FindFirstChild("MainPart") or target.PrimaryPart
            if mainPart then
                if AF_Teleport(mainPart.Position) then
                    task.wait(0.5)
                    AF_OpenSafe(target)
                else
                    table.insert(AF_IgnoredSafes, target)
                    task.wait(1)
                end
            end
        else
            AF_IgnoredSafes = {}
            task.wait(3)
        end
    end
end

function AutoFarm_Enable()
    if AF_Enabled then return end
    AF_Enabled = true
    AF_IgnoredSafes = {}
    
    if AF_Coroutine then
        task.cancel(AF_Coroutine)
        AF_Coroutine = nil
    end
    
    AutoPickup_Enable()
    Noclip_Enable()
    
    AF_Coroutine = task.spawn(AF_MainLoop)
    
    LocalPlayer.CharacterAdded:Connect(function()
        if AF_Enabled then
            task.wait(2)
            AutoPickup_Enable()
            Noclip_Enable()
        end
    end)
end

function AutoFarm_Disable()
    AF_Enabled = false
    if AF_Coroutine then
        task.cancel(AF_Coroutine)
        AF_Coroutine = nil
    end
    AF_IgnoredSafes = {}
    AutoPickup_Disable()
end

-- ==================== UI CATEGORIES ====================
local KB = {}
local Categories = {"Combat", "Movement", "Visuals", "Farming", "Misc"}
local CatFrames = {}
local CatButtons = {}
local ActiveCat = nil

for _, cat in pairs(Categories) do
    CatFrames[cat] = {}
end

local function SwitchCategory(name)
    local btn = CatButtons[name]
    if not btn or btn == ActiveCat then return end
    
    if ActiveCat then
        TweenService:Create(ActiveCat, TweenInfo.new(0.15), {BackgroundColor3 = Theme.CategoryInactive}):Play()
        if ActiveCat.TextLabel then
            ActiveCat.TextLabel.TextColor3 = Theme.TextSecondary
        end
    end
    
    TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.CategoryActive}):Play()
    if btn.TextLabel then
        btn.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
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

-- Create category buttons
for i, cat in pairs(Categories) do
    local btn = Instance.new("TextButton")
    btn.Name = cat
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.BackgroundColor3 = Theme.CategoryInactive
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.LayoutOrder = i
    btn.Parent = sidebarFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Theme.Accent
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.5
    btnStroke.Parent = btn
    
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
        if btn ~= ActiveCat then
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.BindHover}):Play()
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if btn ~= ActiveCat then
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.CategoryInactive}):Play()
        end
    end)
    
    btn.MouseButton1Click:Connect(function() SwitchCategory(cat) end)
    
    CatButtons[cat] = btn
end

-- Populate categories with toggle rows
table.insert(CatFrames.Combat, createToggleRow("Silent Aim", true, function() return SilentAim_Enabled end, SilentAim_Enable, SilentAim_Disable, function() return KB.silentAim end, function(v) KB.silentAim = v end))
table.insert(CatFrames.Combat, createToggleRow("No Recoil", true, function() return NoRecoil_Enabled end, NoRecoil_Enable, NoRecoil_Disable, function() return KB.noRecoil end, function(v) KB.noRecoil = v end))

table.insert(CatFrames.Movement, createToggleRow("Fly (Fling)", true, function() return Fly_Enabled end, Fly_Enable, Fly_Disable, function() return KB.fly end, function(v) KB.fly = v end))
table.insert(CatFrames.Movement, createToggleRow("Noclip", true, function() return Noclip_Enabled end, Noclip_Enable, Noclip_Disable, function() return KB.noclip end, function(v) KB.noclip = v end))
table.insert(CatFrames.Movement, createToggleRow("Inf Stamina", true, function() return InfStamina_Enabled end, InfiniteStamina_Enable, InfiniteStamina_Disable, function() return KB.infStamina end, function(v) KB.infStamina = v end))
table.insert(CatFrames.Movement, createToggleRow("Invisibility", true, _G.IsInvisEnabled, _G.Invis_Enable, _G.Invis_Disable, function() return KB.invis end, function(v) KB.invis = v end))

table.insert(CatFrames.Visuals, createToggleRow("Player ESP", true, function() return ESP_Enabled end, ESP_Enable, ESP_Disable, function() return KB.esp end, function(v) KB.esp = v end))
table.insert(CatFrames.Visuals, createToggleRow("Safe ESP", true, function() return SafeESP_Enabled end, SafeESP_Enable, SafeESP_Disable, function() return KB.safeESP end, function(v) KB.safeESP = v end))
table.insert(CatFrames.Visuals, createToggleRow("FullBright", true, function() return FullBright_Enabled end, FullBright_Enable, FullBright_Disable, function() return KB.fullbright end, function(v) KB.fullbright = v end))
table.insert(CatFrames.Visuals, createToggleRow("FOV Changer", true, function() return FOV_Enabled end, FOV_Enable, FOV_Disable, function() return KB.fov end, function(v) KB.fov = v end))

table.insert(CatFrames.Farming, createToggleRow("Auto Farm", true, function() return AF_Enabled end, AutoFarm_Enable, AutoFarm_Disable, function() return KB.autoFarm end, function(v) KB.autoFarm = v end))
table.insert(CatFrames.Farming, createToggleRow("Auto Pickup $", true, function() return AutoPickup_Enabled end, AutoPickup_Enable, AutoPickup_Disable, function() return KB.autoPickup end, function(v) KB.autoPickup = v end))
table.insert(CatFrames.Farming, createToggleRow("No Fail Lockpick", true, function() return NoFailLP_Enabled end, NoFailLP_Enable, NoFailLP_Disable, function() return KB.noFailLP end, function(v) KB.noFailLP = v end))

table.insert(CatFrames.Misc, createToggleRow("Admin Detector", true, function() return AdminCheck_Enabled end, AdminCheck_Enable, AdminCheck_Disable, function() return KB.adminCheck end, function(v) KB.adminCheck = v end))
table.insert(CatFrames.Misc, createToggleRow("Auto Unlock Doors", true, function() return UnlockDoors_Enabled end, UnlockDoors_Enable, UnlockDoors_Disable, function() return KB.unlockDoors end, function(v) KB.unlockDoors = v end))

-- ==================== KEYBIND HANDLER ====================
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
            local s, r = pcall(getFn)
            if s then oldKey = r end
            
            if oldKey and activeBinds[oldKey] then
                activeBinds[oldKey] = nil
            end
            
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
                if child:IsA("TextButton") and child ~= bindBtn then
                    toggleBtn = child
                    break
                end
            end
            
            if toggleBtn then
                activeBinds[input.KeyCode] = {
                    frame = frame,
                    toggleButton = toggleBtn,
                    isEnabledFn = fData.isEnabledFn,
                    onEnable = fData.onEnable,
                    onDisable = fData.onDisable,
                    canToggle = fData.canToggle,
                    updateFn = fData.updateFn
                }
            end
            
            currentRowWaitingForKey = nil
        end
    elseif activeBinds[input.KeyCode] then
        local info = activeBinds[input.KeyCode]
        if info.canToggle and info.onEnable and info.onDisable and info.isEnabledFn and info.updateFn then
            local s, state = pcall(info.isEnabledFn)
            if s then
                if state then
                    pcall(info.onDisable)
                else
                    pcall(info.onEnable)
                end
                task.wait()
                pcall(info.updateFn)
            end
        end
    end
end)

-- ==================== INITIALIZATION ====================
SwitchCategory("Combat")

mainFrame.Size = UDim2.new(0, 0, 0, 0)
local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 450, 0, 350)})
task.wait(0.1)
openTween:Play()

print("================================================")
print("SANTES HUB v3.0 FINAL Yuklendi")
print("Fly (Fling) | Silent Aim | Auto Farm | ESP")
print("No Recoil | Inf Stamina | FullBright | FOV")
print("Noclip | Invisibility | Safe ESP | Lockpick")
print("Auto Pickup | Auto Doors | Admin Detector")
print("Mobile: Roblox joystick otomatik algilanir")
print("================================================")
