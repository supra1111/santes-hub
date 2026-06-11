--[[
    SANTES HUB v1.2 | CRIMINALITY
    Tum moduller fixlendi:
    ESP, Fly, No Recoil, Infinite Stamina, Silent Aim, Auto Farm (ping limitsiz)
    Tema: Kirmizi/Siyah
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
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ==================== ANTI-AFK ====================
if LocalPlayer then
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- ==================== DESTROY OLD UI ====================
for _, name in pairs({"SantesHubScreenGui", "SantesHubScreenGui_Categorized", "EQRHubScreenGui", "VenomHubScreenGui", "ShadowWarningHUD", "InvisWarningGUI"}) do
    local gui = PlayerGui:FindFirstChild(name)
    if gui then gui:Destroy() end
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
    BindHover = Color3.fromRGB(60, 30, 30)
}

-- ==================== GUI CONSTRUCTION ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SantesHubScreenGui_Categorized"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "SantesHubMainFrame"
mainFrame.Size = UDim2.new(0, 480, 0, 380)
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
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Theme.Accent
stroke.Thickness = 1.5
stroke.Transparency = 0.3
stroke.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = Theme.Background
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "SANTES HUB v1.2"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Theme.TextPrimary
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Close Button
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

-- Divider
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -20, 0, 2)
divider.Position = UDim2.new(0, 10, 0, 42)
divider.BackgroundColor3 = Theme.Accent
divider.BorderSizePixel = 0
divider.Parent = mainFrame

-- Sidebar
local sidebarFrame = Instance.new("Frame")
sidebarFrame.Size = UDim2.new(0, 130, 1, -68)
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

-- Content Frame
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -155, 1, -68)
contentFrame.Position = UDim2.new(0, 148, 0, 50)
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

-- Footer
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

-- ==================== DRAGGING ====================
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

-- Toggle Key
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.K then
        mainFrame.Visible = not mainFrame.Visible
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
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -16, 0, 36)
    frame.BackgroundTransparency = 1
    frame.Name = scriptName:gsub("%s+", "")

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.40, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = " " .. scriptName
    label.TextColor3 = Theme.TextSecondary
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.LayoutOrder = 1
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.26, 0, 0.75, 0)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 11
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.BackgroundColor3 = Theme.ButtonOff
    toggleBtn.BorderSizePixel = 0
    toggleBtn.AutoButtonColor = false
    toggleBtn.LayoutOrder = 2
    toggleBtn.Parent = frame

    local tCorner = Instance.new("UICorner"); tCorner.CornerRadius = UDim.new(0, 5); tCorner.Parent = toggleBtn
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
        bindBtn.Size = UDim2.new(0.26, 0, 0.75, 0)
        bindBtn.Font = Enum.Font.GothamMedium
        bindBtn.TextSize = 11
        bindBtn.TextColor3 = Theme.TextSecondary
        bindBtn.BackgroundColor3 = Theme.BindButton
        bindBtn.BorderSizePixel = 0
        bindBtn.AutoButtonColor = false
        bindBtn.LayoutOrder = 3
        bindBtn.Parent = frame

        local bCorner = Instance.new("UICorner"); bCorner.CornerRadius = UDim.new(0, 5); bCorner.Parent = bindBtn
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
        toggleBtn.Size = UDim2.new(0.55, 0, 0.75, 0)
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
        local hoverTarget = target:Lerp(Color3.new(1, 1, 1), 0.15)
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

-- ==================== ALL MODULES ====================

-- ==================== 1. FLY (FIXED) ====================
local Fly_Enabled = false
local Fly_Connection = nil
local Fly_Speed = 50

function Fly_Enable()
    if Fly_Enabled then return end
    Fly_Enabled = true
    
    Fly_Connection = RunService.Heartbeat:Connect(function(dt)
        if not Fly_Enabled then return end
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
            hrp.CFrame += moveDir.Unit * Fly_Speed * dt
        end
    end)
end

function Fly_Disable()
    Fly_Enabled = false
    if Fly_Connection then Fly_Connection:Disconnect(); Fly_Connection = nil end
end

-- ==================== 2. ESP (FIXED) ====================
local ESP_Enabled = false
local ESP_Connections = {}
local ESP_Players = {}

local function ESP_CreateForPlayer(player)
    if player == LocalPlayer or ESP_Players[player] then return end
    ESP_Players[player] = true
    
    local function setupESP(char)
        if not ESP_Enabled then return end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "Santes_ESP"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.65
        highlight.OutlineColor = Color3.fromRGB(255, 40, 40)
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = char
        
        local head = char:WaitForChild("Head", 10)
        if not head then return end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "Santes_ESPInfo"
        billboard.Size = UDim2.new(0, 100, 0, 45)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.45, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.TextStrokeTransparency = 0.4
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 11
        nameLabel.Parent = billboard
        
        local hpLabel = Instance.new("TextLabel")
        hpLabel.Size = UDim2.new(1, 0, 0.3, 0)
        hpLabel.Position = UDim2.new(0, 0, 0.45, 0)
        hpLabel.BackgroundTransparency = 1
        hpLabel.Text = "100 HP"
        hpLabel.TextColor3 = Color3.new(0, 1, 0)
        hpLabel.TextStrokeTransparency = 0.4
        hpLabel.Font = Enum.Font.Gotham
        hpLabel.TextSize = 10
        hpLabel.Parent = billboard
        
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, 0, 0.25, 0)
        distLabel.Position = UDim2.new(0, 0, 0.75, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = "0m"
        distLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        distLabel.TextStrokeTransparency = 0.4
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextSize = 9
        distLabel.Parent = billboard
        
        task.spawn(function()
            while ESP_Enabled and char and char.Parent and head.Parent do
                local myChar = LocalPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    local dist = (head.Position - myChar.HumanoidRootPart.Position).Magnitude
                    distLabel.Text = string.format("%.0fm", dist)
                    
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        local hp = math.floor(hum.Health)
                        hpLabel.Text = hp .. " HP"
                        if hp > 60 then hpLabel.TextColor3 = Color3.new(0, 1, 0)
                        elseif hp > 30 then hpLabel.TextColor3 = Color3.new(1, 1, 0)
                        else hpLabel.TextColor3 = Color3.new(1, 0, 0) end
                    end
                end
                task.wait(0.2)
            end
        end)
    end
    
    if player.Character then
        setupESP(player.Character)
    end
    table.insert(ESP_Connections, player.CharacterAdded:Connect(setupESP))
end

function ESP_Enable()
    if ESP_Enabled then return end
    ESP_Enabled = true
    ESP_Players = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        ESP_CreateForPlayer(player)
    end
    table.insert(ESP_Connections, Players.PlayerAdded:Connect(ESP_CreateForPlayer))
    
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
                local hl = player.Character:FindFirstChild("Santes_ESP")
                if hl then hl:Destroy() end
                for _, v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BillboardGui") and v.Name == "Santes_ESPInfo" then
                        v:Destroy()
                    end
                end
            end
        end)
    end
end

-- ==================== 3. NO RECOIL (FIXED) ====================
local NoRecoil_Enabled = false
local NoRecoil_Original = {}

function NoRecoil_Enable()
    if NoRecoil_Enabled then return end
    NoRecoil_Enabled = true
    
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

-- ==================== 4. INFINITE STAMINA (FIXED) ====================
local InfStamina_Enabled = false
local OldStaminaFunc = nil

do
    task.spawn(function()
        repeat task.wait() until pcall(function() return getrenv()._G.S_Take end)
        local env = getrenv()
        if env and env._G and env._G.S_Take then
            local upval = getupvalue(env._G.S_Take, 2)
            if type(upval) == 'function' then
                OldStaminaFunc = hookfunction(upval, function(v1, ...)
                    if InfStamina_Enabled then
                        return OldStaminaFunc(0, ...)
                    end
                    return OldStaminaFunc(v1, ...)
                end)
            end
        end
    end)
end

function InfiniteStamina_Enable()
    InfStamina_Enabled = true
end

function InfiniteStamina_Disable()
    InfStamina_Enabled = false
end

-- ==================== 5. SILENT AIM (FIXED) ====================
local SilentAim_Enabled = false
local SilentAim_Connection = nil
local SilentAim_FOV = 200
local SilentAim_Smoothness = 1

local function SilentAim_GetClosest()
    local closest = nil
    local shortest = SilentAim_FOV
    local cam = workspace.CurrentCamera
    local mousePos = UserInputService:GetMouseLocation()
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            local targetPart = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and targetPart then
                local screenPos, onScreen = cam:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = player
                    end
                end
            end
        end
    end
    return closest
end

function SilentAim_Enable()
    if SilentAim_Enabled then return end
    SilentAim_Enabled = true
    
    SilentAim_Connection = RunService.RenderStepped:Connect(function()
        if not SilentAim_Enabled then return end
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
        
        local target = SilentAim_GetClosest()
        if target and target.Character then
            local targetPart = target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local cam = workspace.CurrentCamera
                local targetCFrame = CFrame.new(cam.CFrame.Position, targetPart.Position)
                if SilentAim_Smoothness > 1 then
                    cam.CFrame = cam.CFrame:Lerp(targetCFrame, 1 / SilentAim_Smoothness)
                else
                    cam.CFrame = targetCFrame
                end
            end
        end
    end)
end

function SilentAim_Disable()
    SilentAim_Enabled = false
    if SilentAim_Connection then SilentAim_Connection:Disconnect(); SilentAim_Connection = nil end
end

-- ==================== 6. NOCLIP ====================
local Noclip_Enabled = false
local Noclip_Conn = nil

function Noclip_Enable()
    if Noclip_Enabled then return end
    Noclip_Enabled = true
    Noclip_Conn = RunService.Stepped:Connect(function()
        if Noclip_Enabled and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end

function Noclip_Disable()
    Noclip_Enabled = false
    if Noclip_Conn then Noclip_Conn:Disconnect(); Noclip_Conn = nil end
end

-- ==================== 7. FULLBRIGHT ====================
local FullBright_Enabled = false
local FullBright_Conn = nil
local OrigLighting = {}

function FullBright_Enable()
    if FullBright_Enabled then return end
    FullBright_Enabled = true
    OrigLighting = {
        Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
        Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
        FogStart = Lighting.FogStart, FogEnd = Lighting.FogEnd
    }
    FullBright_Conn = RunService.RenderStepped:Connect(function()
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.FogStart = 100000
        Lighting.FogEnd = 100000
    end)
end

function FullBright_Disable()
    FullBright_Enabled = false
    if FullBright_Conn then FullBright_Conn:Disconnect(); FullBright_Conn = nil end
    if OrigLighting.Brightness then
        Lighting.Brightness = OrigLighting.Brightness
        Lighting.ClockTime = OrigLighting.ClockTime
        Lighting.Ambient = OrigLighting.Ambient
        Lighting.OutdoorAmbient = OrigLighting.OutdoorAmbient
        Lighting.FogStart = OrigLighting.FogStart
        Lighting.FogEnd = OrigLighting.FogEnd
    end
end

-- ==================== 8. ADMIN DETECTOR ====================
local AdminCheck_Enabled = false
local AdminCheck_Conn = nil
local StaffUsers = {3294804378, 93676120, 54087314, 81275825, 140837601, 1229486091, 46567801, 418086275,
    29706395, 3717066084, 1424338327, 5046662686, 63238912, 111250044, 63315426, 730176906, 141193516,
    194512073, 193945439, 412741116, 195538733, 102045519, 955294, 957835150, 25689921, 366613818,
    281593651, 455275714, 208929505, 96783330, 156152502, 93281166, 959606619, 142821118, 632886139,
    175931803, 122209625, 278097946, 142989311, 1517131734, 446849296, 87189764, 67180844, 9212846,
    47352513, 48058122, 155413858, 10497435, 513615792, 55893752, 55476024, 151691292, 136584758,
    16983447, 3111449, 94693025, 271400893, 5005262660, 295331237, 64489098, 244844600, 114332275,
    25048901, 69262878, 50801509, 92504899, 42066711, 50585425, 31365111, 166406495, 2457253857,
    29761878, 21831137, 948293345, 439942262, 38578487, 1163048, 7713309208, 3659305297, 15598614,
    34616594, 626833004, 198610386, 153835477, 3923114296, 3937697838, 102146039, 119861460, 371665775,
    1206543842, 93428604, 1863173316, 90814576, 374665997, 423005063, 140172831, 42662179, 9066859,
    438805620, 14855669, 727189337, 1871290386, 608073286}
local StaffGroups = {4165692, 32406137, 8024440, 14927228}

local function AdminCheck_CheckPlayer(player)
    if player == LocalPlayer then return end
    for _, uid in pairs(StaffUsers) do
        if player.UserId == uid then
            LocalPlayer:Kick("SANTES: Staff detected - " .. player.Name)
            return true
        end
    end
    for _, gid in pairs(StaffGroups) do
        local s, rank = pcall(function() return player:GetRankInGroup(gid) end)
        if s and rank and rank >= 5 then
            LocalPlayer:Kick("SANTES: Staff detected - " .. player.Name)
            return true
        end
    end
    return false
end

function AdminCheck_Enable()
    if AdminCheck_Enabled then return end
    AdminCheck_Enabled = true
    
    for _, player in pairs(Players:GetPlayers()) do
        if AdminCheck_CheckPlayer(player) then return end
    end
    AdminCheck_Conn = Players.PlayerAdded:Connect(AdminCheck_CheckPlayer)
end

function AdminCheck_Disable()
    AdminCheck_Enabled = false
    if AdminCheck_Conn then AdminCheck_Conn:Disconnect(); AdminCheck_Conn = nil end
end

-- ==================== 9. AUTO PICKUP MONEY ====================
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
        local folder = Workspace.Filter:FindFirstChild("SpawnedBread") or Workspace:FindFirstChild("SpawnedBread")
        if not folder then return end
        
        local remote = ReplicatedStorage.Events:FindFirstChild("CZDPZUS")
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
    if AutoPickup_Conn then AutoPickup_Conn:Disconnect(); AutoPickup_Conn = nil end
end

-- ==================== 10. AUTO FARM (FIXED - NO PING LIMIT) ====================
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
    local shops = Workspace.Map:FindFirstChild("Shopz")
    if not shops then return nil end
    
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local nearest = nil
    local bestDist = math.huge
    local myPos = hrp.Position
    
    for _, shop in pairs(shops:GetChildren()) do
        local mainPart = shop:FindFirstChild("MainPart")
        local stocks = shop:FindFirstChild("CurrentStocks")
        if mainPart and stocks then
            local crowbarStock = stocks:FindFirstChild("Crowbar")
            if crowbarStock and crowbarStock.Value > 0 then
                local dist = (mainPart.Position - myPos).Magnitude
                if dist < bestDist then
                    bestDist = dist
                    nearest = shop
                end
            end
        end
    end
    return nearest
end

local function AF_FindTarget()
    local bredFolder = Workspace.Map:FindFirstChild("BredMakurz")
    if not bredFolder then bredFolder = Workspace.Filter:FindFirstChild("BredMakurz") end
    if not bredFolder then return nil end
    
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local nearest = nil
    local bestDist = math.huge
    local myPos = hrp.Position
    
    for _, obj in pairs(bredFolder:GetChildren()) do
        if (string.find(obj.Name, "Safe") or string.find(obj.Name, "Register")) and not table.find(AF_IgnoredSafes, obj) then
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
    return nearest
end

local function AF_HasTool(toolName)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild(toolName) then return true end
    local bp = LocalPlayer.Backpack
    if bp and bp:FindFirstChild(toolName) then return true end
    return false
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
    local crowbar = AF_HasTool("Crowbar")
    if not crowbar then return end
    
    if not AF_EquipTool("Crowbar") then return end
    
    local remote1 = ReplicatedStorage.Events:FindFirstChild("XMHH.2")
    local remote2 = ReplicatedStorage.Events:FindFirstChild("XMHH2.2")
    local safePart = safeModel:FindFirstChild("MainPart")
    if not remote1 or not remote2 or not safePart then return end
    
    local equippedTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Crowbar")
    if not equippedTool then return end
    
    local startTime = tick()
    while safeModel and safeModel.Parent and safeModel.Values and safeModel.Values:FindFirstChild("Broken") and not safeModel.Values.Broken.Value and (tick() - startTime < 20) do
        local char = LocalPlayer.Character
        if not char then break end
        
        local result = remote1:InvokeServer("\240\159\141\158", tick(), equippedTool, "DZDRRRKI", safeModel, "Register")
        if result then
            remote2:FireServer("\240\159\141\158", tick(), equippedTool, "2389ZFX34", result, false, char["Right Arm"], safePart, safeModel, safePart.Position, safePart.Position)
        end
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
    
    local byzersEvent = ReplicatedStorage.Events:FindFirstChild("BYZERSPROTEC")
    local shopEvent = ReplicatedStorage.Events:FindFirstChild("SSHPRMTE1")
    if not byzersEvent or not shopEvent then return false end
    
    byzersEvent:FireServer(true, "shop", mainPart, "IllegalStore")
    task.wait(0.5)
    shopEvent:InvokeServer("IllegalStore", "Melees", "Crowbar", mainPart, nil, true)
    task.wait(2)
    byzersEvent:FireServer(false)
    
    return AF_HasTool("Crowbar")
end

local function AF_MainLoop()
    while AF_Enabled do
        task.wait(0.5)
        
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if not char or not hum or hum.Health <= 0 then
            -- Respawn
            local deathEvent = ReplicatedStorage.Events:FindFirstChild("DeathRespawn")
            if deathEvent then
                pcall(function() deathEvent:InvokeServer("KMG4R904") end)
            end
            task.wait(3)
            AF_IgnoredSafes = {}
            continue
        end
        
        if not AF_HasTool("Crowbar") then
            local dealer = AF_FindDealer()
            if dealer then
                AF_BuyCrowbar(dealer)
            else
                task.wait(5)
            end
            continue
        end
        
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
    
    -- Auto-start dependent features
    pcall(AutoPickup_Enable)
    pcall(Noclip_Enable)
    
    AF_Coroutine = task.spawn(AF_MainLoop)
    
    -- Respawn handler
    LocalPlayer.CharacterAdded:Connect(function(char)
        if AF_Enabled then
            task.wait(2)
            pcall(AutoPickup_Enable)
            pcall(Noclip_Enable)
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
    pcall(AutoPickup_Disable)
end

-- ==================== 11. INVISIBILITY (SHADOW MODE) ====================
local Invis_Enabled = false
local Invis_Usable = true
local Invis_Track = nil
local Invis_CharRefs = {Char = nil, Hum = nil, HRP = nil}
local Invis_GUI = nil

do
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://215384594"
    
    local function updateRefs()
        local char = LocalPlayer.Character
        Invis_CharRefs.Char = char
        Invis_CharRefs.Hum = char and char:FindFirstChildOfClass("Humanoid")
        Invis_CharRefs.HRP = char and char:FindFirstChild("HumanoidRootPart")
    end
    
    local function grounded()
        local hum = Invis_CharRefs.Hum
        return hum and hum:IsDescendantOf(Workspace) and hum.FloorMaterial ~= Enum.Material.Air
    end
    
    local function loadTrack()
        if Invis_Track then pcall(function() Invis_Track:Stop() end); Invis_Track = nil end
        local hum = Invis_CharRefs.Hum
        if hum then
            local s, r = pcall(function() return hum:LoadAnimation(anim) end)
            if s then Invis_Track = r; Invis_Track.Priority = Enum.AnimationPriority.Action4 end
        end
    end
    
    RunService.Heartbeat:Connect(function(dt)
        if not Invis_Enabled or not Invis_Usable then
            if not Invis_Enabled and Invis_CharRefs.Char then
                for _, v in pairs(Invis_CharRefs.Char:GetDescendants()) do
                    if v:IsA("BasePart") and v.Transparency == 0.5 then v.Transparency = 0 end
                end
            end
            return
        end
        
        local char = Invis_CharRefs.Char
        local hum = Invis_CharRefs.Hum
        local hrp = Invis_CharRefs.HRP
        
        if not char or not hum or not hrp or hum.Health <= 0 then
            if Invis_GUI then Invis_GUI.Visible = false end
            return
        end
        
        if Invis_GUI then Invis_GUI.Visible = not grounded() end
        
        local speed = 12
        if hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame += hum.MoveDirection * speed * dt
        end
        
        local oldCF = hrp.CFrame
        local oldOffset = hum.CameraOffset
        
        local _, y = workspace.CurrentCamera.CFrame:ToOrientation()
        hrp.CFrame = CFrame.new(hrp.Position) * CFrame.fromOrientation(0, y, 0) * CFrame.Angles(math.rad(90), 0, 0)
        hum.CameraOffset = Vector3.new(0, 1.44, 0)
        
        if Invis_Track then
            pcall(function()
                if not Invis_Track.IsPlaying then Invis_Track:Play() end
                Invis_Track:AdjustSpeed(0)
                Invis_Track.TimePosition = 0.3
            end)
        elseif hum.Health > 0 then
            loadTrack()
        end
        
        RunService.RenderStepped:Wait()
        
        if hum:IsDescendantOf(Workspace) then hum.CameraOffset = oldOffset end
        if hrp:IsDescendantOf(Workspace) then hrp.CFrame = oldCF end
        
        if Invis_Track then pcall(function() Invis_Track:Stop() end) end
        
        if hrp:IsDescendantOf(Workspace) then
            local lookVec = workspace.CurrentCamera.CFrame.LookVector
            local flat = Vector3.new(lookVec.X, 0, lookVec.Z).Unit
            if flat.Magnitude > 0.1 then
                hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + flat)
            end
        end
        
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.Transparency ~= 1 then v.Transparency = 0.5 end
        end
    end)
    
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        if Invis_Track then pcall(function() Invis_Track:Stop() end); Invis_Track = nil end
        task.wait()
        updateRefs()
        if Invis_CharRefs.Hum and Invis_CharRefs.Hum.RigType ~= Enum.HumanoidRigType.R6 then
            Invis_Usable = false
            if Invis_Enabled then Invis_Disable() end
        else
            Invis_Usable = true
            if Invis_Enabled then
                workspace.CurrentCamera.CameraSubject = Invis_CharRefs.HRP
                loadTrack()
            end
        end
    end)
    
    updateRefs()
    if Invis_CharRefs.Hum and Invis_CharRefs.Hum.RigType ~= Enum.HumanoidRigType.R6 then
        Invis_Usable = false
    end
    
    -- Create warning GUI
    local coreGui = game:GetService("CoreGui")
    Invis_GUI = Instance.new("ScreenGui")
    Invis_GUI.Name = "InvisWarning"
    Invis_GUI.Parent = coreGui
    Invis_GUI.ResetOnSpawn = false
    
    local warnLabel = Instance.new("TextLabel", Invis_GUI)
    warnLabel.Text = "VISIBLE!"
    warnLabel.Visible = false
    warnLabel.Size = UDim2.new(0, 200, 0, 30)
    warnLabel.Position = UDim2.new(0.5, -100, 0.85, 0)
    warnLabel.BackgroundTransparency = 1
    warnLabel.Font = Enum.Font.GothamBold
    warnLabel.TextSize = 24
    warnLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    warnLabel.TextStrokeTransparency = 0.5
    
    function Invis_Enable()
        if Invis_Enabled or not Invis_Usable then return end
        Invis_Enabled = true
        updateRefs()
        if Invis_CharRefs.HRP then
            workspace.CurrentCamera.CameraSubject = Invis_CharRefs.HRP
        end
        loadTrack()
    end
    
    function Invis_Disable()
        if not Invis_Enabled then return end
        Invis_Enabled = false
        if Invis_Track then pcall(function() Invis_Track:Stop() end) end
        if Invis_CharRefs.Hum then
            workspace.CurrentCamera.CameraSubject = Invis_CharRefs.Hum
        end
        if Invis_CharRefs.Char then
            for _, v in pairs(Invis_CharRefs.Char:GetDescendants()) do
                if v:IsA("BasePart") and v.Transparency == 0.5 then v.Transparency = 0 end
            end
        end
        if Invis_GUI then Invis_GUI.Visible = false end
    end
    
    _G.Invis_Enable = Invis_Enable
    _G.Invis_Disable = Invis_Disable
    _G.IsInvisEnabled = function() return Invis_Enabled end
end

-- ==================== 12. NO FAIL LOCKPICK ====================
local NoFailLP_Enabled = false
local NoFailLP_Conn = nil

function NoFailLP_Enable()
    if NoFailLP_Enabled then return end
    NoFailLP_Enabled = true
    
    NoFailLP_Conn = PlayerGui.ChildAdded:Connect(function(item)
        if item.Name == "LockpickGUI" then
            task.wait(0.1)
            local mf = item:FindFirstChild("MF")
            if mf then
                local lpFrame = mf:FindFirstChild("LP_Frame")
                if lpFrame then
                    local frames = lpFrame:FindFirstChild("Frames")
                    if frames then
                        for _, bar in pairs({"B1", "B2", "B3"}) do
                            local b = frames:FindFirstChild(bar)
                            if b and b:FindFirstChild("Bar") then
                                local uiScale = b.Bar:FindFirstChild("UIScale")
                                if uiScale then uiScale.Scale = 10 end
                            end
                        end
                    end
                end
            end
        end
    end)
end

function NoFailLP_Disable()
    NoFailLP_Enabled = false
    if NoFailLP_Conn then NoFailLP_Conn:Disconnect(); NoFailLP_Conn = nil end
end

-- ==================== 13. SAFE ESP ====================
local SafeESP_Enabled = false
local SafeESP_Conn = nil

local function SafeESP_Update()
    local folder = Workspace.Map:FindFirstChild("BredMakurz")
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
                    bg.Size = UDim2.new(0, 100, 0, 20)
                    bg.AlwaysOnTop = true
                    bg.MaxDistance = 200
                    bg.Parent = obj
                    bg.Adornee = obj
                    
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
                            if val then tl.TextColor3 = Color3.fromRGB(255, 0, 0)
                            else tl.TextColor3 = Color3.fromRGB(0, 255, 0) end
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
    if SafeESP_Conn then SafeESP_Conn:Disconnect(); SafeESP_Conn = nil end
    
    local folder = Workspace.Map:FindFirstChild("BredMakurz")
    if folder then
        for _, obj in pairs(folder:GetChildren()) do
            local esp = obj:FindFirstChild("Santes_SafeESP")
            if esp then esp:Destroy() end
        end
    end
end

-- ==================== 14. AUTO UNLOCK/OPEN DOORS ====================
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
        
        local doors = Workspace.Map:FindFirstChild("Doors")
        if not doors then return end
        
        for _, door in pairs(doors:GetChildren()) do
            local doorBase = door:FindFirstChild("DoorBase")
            if doorBase and (hrp.Position - doorBase.Position).Magnitude <= 8 then
                local events = door:FindFirstChild("Events")
                local values = door:FindFirstChild("Values")
                if events and values then
                    local toggle = events:FindFirstChild("Toggle")
                    local locked = values:FindFirstChild("Locked")
                    local lockPart = door:FindFirstChild("Lock")
                    
                    if toggle and locked and lockPart and locked.Value == true then
                        pcall(function() toggle:FireServer("Unlock", lockPart) end)
                    end
                    
                    local openVal = values:FindFirstChild("Open")
                    local knob = door:FindFirstChild("Knob2") or door:FindFirstChild("Knob")
                    if toggle and openVal and knob and openVal.Value == false then
                        pcall(function() toggle:FireServer("Open", knob) end)
                    end
                end
            end
        end
    end)
end

function UnlockDoors_Disable()
    UnlockDoors_Enabled = false
    if UnlockDoors_Conn then UnlockDoors_Conn:Disconnect(); UnlockDoors_Conn = nil end
end

-- ==================== KEYBINDS TABLE ====================
local KB = {}

-- ==================== UI CATEGORIES ====================
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
        TweenService:Create(ActiveCat, TweenInfo.new(0.15), {BackgroundColor3 = Theme.SidebarBg}):Play()
        ActiveCat.TextLabel.TextColor3 = Theme.TextSecondary
    end
    
    TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Accent}):Play()
    btn.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
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
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, count * 36 + (count > 0 and (count - 1) * 6 or 0) + 10)
    end
end

-- Create category buttons
for i, cat in pairs(Categories) do
    local btn = Instance.new("TextButton")
    btn.Name = cat
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.BackgroundColor3 = Theme.SidebarBg
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.LayoutOrder = i
    btn.Parent = sidebarFrame
    
    local btnCorner = Instance.new("UICorner"); btnCorner.CornerRadius = UDim.new(0, 6); btnCorner.Parent = btn
    local btnStroke = Instance.new("UIStroke"); btnStroke.Color = Theme.Accent; btnStroke.Thickness = 1; btnStroke.Transparency = 0.6; btnStroke.Parent = btn
    
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
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.SidebarBg}):Play()
        end
    end)
    btn.MouseButton1Click:Connect(function() SwitchCategory(cat) end)
    
    CatButtons[cat] = btn
end

-- Populate categories
table.insert(CatFrames.Combat, createToggleRow("Silent Aim", true, function() return SilentAim_Enabled end, SilentAim_Enable, SilentAim_Disable, function() return KB.silentAim end, function(v) KB.silentAim = v end))
table.insert(CatFrames.Combat, createToggleRow("No Recoil", true, function() return NoRecoil_Enabled end, NoRecoil_Enable, NoRecoil_Disable, function() return KB.noRecoil end, function(v) KB.noRecoil = v end))

table.insert(CatFrames.Movement, createToggleRow("Fly", true, function() return Fly_Enabled end, Fly_Enable, Fly_Disable, function() return KB.fly end, function(v) KB.fly = v end))
table.insert(CatFrames.Movement, createToggleRow("Noclip", true, function() return Noclip_Enabled end, Noclip_Enable, Noclip_Disable, function() return KB.noclip end, function(v) KB.noclip = v end))
table.insert(CatFrames.Movement, createToggleRow("Inf Stamina", true, function() return InfStamina_Enabled end, InfiniteStamina_Enable, InfiniteStamina_Disable, function() return KB.infStamina end, function(v) KB.infStamina = v end))
table.insert(CatFrames.Movement, createToggleRow("Invisibility", true, _G.IsInvisEnabled, _G.Invis_Enable, _G.Invis_Disable, function() return KB.invis end, function(v) KB.invis = v end))

table.insert(CatFrames.Visuals, createToggleRow("ESP", true, function() return ESP_Enabled end, ESP_Enable, ESP_Disable, function() return KB.esp end, function(v) KB.esp = v end))
table.insert(CatFrames.Visuals, createToggleRow("Safe ESP", true, function() return SafeESP_Enabled end, SafeESP_Enable, SafeESP_Disable, function() return KB.safeESP end, function(v) KB.safeESP = v end))
table.insert(CatFrames.Visuals, createToggleRow("FullBright", true, function() return FullBright_Enabled end, FullBright_Enable, FullBright_Disable, function() return KB.fullbright end, function(v) KB.fullbright = v end))

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
        local bindInfo = activeBinds[input.KeyCode]
        if bindInfo.canToggle and bindInfo.onEnable and bindInfo.onDisable and bindInfo.isEnabledFn and bindInfo.updateFn then
            local s, state = pcall(bindInfo.isEnabledFn)
            if s then
                if state then pcall(bindInfo.onDisable) else pcall(bindInfo.onEnable) end
                task.wait()
                pcall(bindInfo.updateFn)
            end
        end
    end
end)

-- ==================== INITIALIZATION ====================
SwitchCategory("Combat")

mainFrame.Size = UDim2.new(0, 0, 0, 0)
local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 480, 0, 380)})
task.wait(0.1)
openTween:Play()

print("SANTES HUB v1.2 Yuklendi - Tum Moduller Fixli")
print("ESP | Fly | No Recoil | Inf Stamina | Silent Aim | Auto Farm | Invis | Safe ESP | Admin Check | Door Unlock")
