-- SANTES HUB v3.0 - FULLY WORKING
-- GUI fix: Tüm UI elementleri doğru parent ve görünürlük ayarlarıyla eklendi

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
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

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
-- #                     CLEAN OLD GUIS                               #
-- #####################################################################

for _, name in pairs({"SantesHubScreenGui","SantesHub_Main","SantesHub_Loader","VenomHubScreenGui","EQRHubScreenGui"}) do
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

local loaderFrame = Instance.new("Frame")
loaderFrame.Size = UDim2.new(0, 400, 0, 350)
loaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
loaderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loaderFrame.BackgroundColor3 = C.bg
loaderFrame.BackgroundTransparency = 0
loaderFrame.BorderSizePixel = 0
loaderFrame.ClipsDescendants = true
loaderFrame.Parent = loaderGui

local loaderCorner = Instance.new("UICorner")
loaderCorner.CornerRadius = UDim.new(0, 16)
loaderCorner.Parent = loaderFrame

local loaderStroke = Instance.new("UIStroke")
loaderStroke.Color = RED
loaderStroke.Thickness = 1
loaderStroke.Transparency = 0.3
loaderStroke.Parent = loaderFrame

local loaderTitle = Instance.new("TextLabel")
loaderTitle.Size = UDim2.new(1, 0, 0, 80)
loaderTitle.Position = UDim2.new(0, 0, 0, 40)
loaderTitle.BackgroundTransparency = 1
loaderTitle.Text = "SANTES HUB"
loaderTitle.TextColor3 = C.textPrimary
loaderTitle.Font = Enum.Font.Impact
loaderTitle.TextSize = 48
loaderTitle.TextXAlignment = Enum.TextXAlignment.Center
loaderTitle.Parent = loaderFrame

local loaderSub = Instance.new("TextLabel")
loaderSub.Size = UDim2.new(1, 0, 0, 30)
loaderSub.Position = UDim2.new(0, 0, 0, 110)
loaderSub.BackgroundTransparency = 1
loaderSub.Text = "PREMIUM v3.0"
loaderSub.TextColor3 = RED
loaderSub.Font = Enum.Font.GothamBold
loaderSub.TextSize = 14
loaderSub.TextXAlignment = Enum.TextXAlignment.Center
loaderSub.Parent = loaderFrame

local loadingBarBg = Instance.new("Frame")
loadingBarBg.Size = UDim2.new(0.7, 0, 0, 4)
loadingBarBg.Position = UDim2.new(0.15, 0, 0, 170)
loadingBarBg.BackgroundColor3 = C.card
loadingBarBg.BorderSizePixel = 0
loadingBarBg.Parent = loaderFrame

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 2)
barCorner.Parent = loadingBarBg

local loadingBar = Instance.new("Frame")
loadingBar.Size = UDim2.new(0, 0, 1, 0)
loadingBar.BackgroundColor3 = RED
loadingBar.BorderSizePixel = 0
loadingBar.Parent = loadingBarBg

local loadingBarFillCorner = Instance.new("UICorner")
loadingBarFillCorner.CornerRadius = UDim.new(0, 2)
loadingBarFillCorner.Parent = loadingBar

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 0, 30)
loadingText.Position = UDim2.new(0, 0, 0, 190)
loadingText.BackgroundTransparency = 1
loadingText.Text = "YUKLENIYOR..."
loadingText.TextColor3 = C.textSub
loadingText.Font = Enum.Font.Gotham
loadingText.TextSize = 11
loadingText.TextXAlignment = Enum.TextXAlignment.Center
loadingText.Parent = loaderFrame

local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0.5, 0, 0, 45)
startBtn.Position = UDim2.new(0.25, 0, 0, 250)
startBtn.BackgroundColor3 = RED
startBtn.Text = "BASLAT"
startBtn.TextColor3 = C.textPrimary
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 16
startBtn.Visible = false
startBtn.Parent = loaderFrame

local startBtnCorner = Instance.new("UICorner")
startBtnCorner.CornerRadius = UDim.new(0, 25)
startBtnCorner.Parent = startBtn

startBtn.MouseEnter:Connect(function()
    TweenService:Create(startBtn, TweenInfo.new(0.2), { BackgroundColor3 = C.accentBright }):Play()
end)
startBtn.MouseLeave:Connect(function()
    TweenService:Create(startBtn, TweenInfo.new(0.2), { BackgroundColor3 = RED }):Play()
end)

local messages = {
    "SISTEM BASLATILIYOR...",
    "MODULLER YUKLENIYOR...",
    "BAGLANTI KURULUYOR...",
    "GUVENLIK AKTIF...",
    "ARAYUZ HAZIRLANIYOR...",
    "SANTES HUB AKTIF."
}

task.spawn(function()
    for i, msg in ipairs(messages) do
        loadingText.Text = msg
        local progress = i / #messages
        TweenService:Create(loadingBar, TweenInfo.new(0.3), { Size = UDim2.new(progress, 0, 1, 0) }):Play()
        task.wait(0.5)
    end
    task.wait(0.3)
    startBtn.Visible = true
    TweenService:Create(startBtn, TweenInfo.new(0.3), { BackgroundTransparency = 0 }):Play()
end)

startBtn.MouseButton1Click:Connect(function()
    TweenService:Create(loaderFrame, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
    task.wait(0.3)
    loaderGui:Destroy()
    CreateMainUI()
end)

-- #####################################################################
-- #                         MAIN UI                                  #
-- #####################################################################

function CreateMainUI()
    print("Creating Main UI...")
    
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "SantesHub_Main"
    mainGui.ResetOnSpawn = false
    mainGui.IgnoreGuiInset = true
    mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    mainGui.Parent = PlayerGui
    
    -- Overlay
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.BorderSizePixel = 0
    overlay.Parent = mainGui
    
    -- Ana Pencere
    local win = Instance.new("Frame")
    win.Size = UDim2.new(0, 700, 0, 500)
    win.Position = UDim2.new(0.5, 0, 0.5, 0)
    win.AnchorPoint = Vector2.new(0.5, 0.5)
    win.BackgroundColor3 = C.bg
    win.BackgroundTransparency = 0
    win.BorderSizePixel = 0
    win.ClipsDescendants = true
    win.Parent = mainGui
    
    local winCorner = Instance.new("UICorner")
    winCorner.CornerRadius = UDim.new(0, 12)
    winCorner.Parent = win
    
    local winStroke = Instance.new("UIStroke")
    winStroke.Color = C.accent
    winStroke.Thickness = 1
    winStroke.Transparency = 0.3
    winStroke.Parent = win
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = C.panel
    titleBar.BorderSizePixel = 0
    titleBar.Parent = win
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(0, 150, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "SANTES HUB"
    titleText.TextColor3 = C.textPrimary
    titleText.Font = Enum.Font.Impact
    titleText.TextSize = 24
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    local versionTag = Instance.new("TextLabel")
    versionTag.Size = UDim2.new(0, 50, 0, 18)
    versionTag.Position = UDim2.new(0, 125, 0.5, -9)
    versionTag.BackgroundColor3 = C.accent
    versionTag.Text = "v3.0"
    versionTag.TextColor3 = C.textPrimary
    versionTag.Font = Enum.Font.GothamBold
    versionTag.TextSize = 10
    versionTag.TextXAlignment = Enum.TextXAlignment.Center
    versionTag.Parent = titleBar
    
    local tagCorner = Instance.new("UICorner")
    tagCorner.CornerRadius = UDim.new(0, 5)
    tagCorner.Parent = versionTag
    
    -- Minimize Button
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 32, 0, 32)
    minBtn.Position = UDim2.new(1, -80, 0.5, -16)
    minBtn.BackgroundColor3 = C.card
    minBtn.Text = "─"
    minBtn.TextColor3 = C.textPrimary
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 16
    minBtn.AutoButtonColor = false
    minBtn.Parent = titleBar
    
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 8)
    minCorner.Parent = minBtn
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -42, 0.5, -16)
    closeBtn.BackgroundColor3 = C.accent
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = C.textPrimary
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    
    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 160, 1, -50)
    sidebar.Position = UDim2.new(0, 0, 0, 50)
    sidebar.BackgroundColor3 = C.panel
    sidebar.BorderSizePixel = 0
    sidebar.Parent = win
    
    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, 15)
    sidebarPadding.PaddingLeft = UDim.new(0, 10)
    sidebarPadding.PaddingRight = UDim.new(0, 10)
    sidebarPadding.Parent = sidebar
    
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 8)
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarLayout.Parent = sidebar
    
    -- Content Area
    local contentArea = Instance.new("ScrollingFrame")
    contentArea.Size = UDim2.new(1, -170, 1, -60)
    contentArea.Position = UDim2.new(0, 170, 0, 60)
    contentArea.BackgroundColor3 = C.bg
    contentArea.BackgroundTransparency = 0
    contentArea.BorderSizePixel = 0
    contentArea.ScrollingDirection = Enum.ScrollingDirection.Y
    contentArea.ScrollBarThickness = 4
    contentArea.ScrollBarImageColor3 = C.accent
    contentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentArea.Parent = win
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 0)
    contentCorner.Parent = contentArea
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 15)
    contentPadding.PaddingLeft = UDim.new(0, 15)
    contentPadding.PaddingRight = UDim.new(0, 15)
    contentPadding.PaddingBottom = UDim.new(0, 15)
    contentPadding.Parent = contentArea
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 15)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.Parent = contentArea
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentArea.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 30)
    end)
    
    -- Module States
    local moduleStates = {
        fly = false, noclip = false, fullbright = false, esp = false,
        silentaim = false, meleeaura = false, autofarm = false, autolockpick = false,
        ragebot = false, norecoil = false, invis = false, stamina = false
    }
    
    -- Fly Module
    local flyConn = nil
    function ToggleFly()
        moduleStates.fly = not moduleStates.fly
        if moduleStates.fly then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.Velocity = Vector3.new(0, 30, 0)
            end
            flyConn = RunService.Heartbeat:Connect(function()
                if not moduleStates.fly then return end
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if not hrp or not hum then return end
                hum.PlatformStand = true
                local cam = workspace.CurrentCamera
                if not cam then return end
                local vel = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vel = vel - Vector3.new(0, 1, 0) end
                hrp.Velocity = vel.Unit * 70
            end)
        else
            if flyConn then flyConn:Disconnect(); flyConn = nil end
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.PlatformStand = false end
            end
        end
    end
    
    -- Noclip Module
    local noclipConn = nil
    function ToggleNoclip()
        moduleStates.noclip = not moduleStates.noclip
        if moduleStates.noclip then
            noclipConn = RunService.Stepped:Connect(function()
                if moduleStates.noclip and LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        else
            if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
        end
    end
    
    -- Fullbright Module
    local oldBrightness = Lighting.Brightness
    function ToggleFullbright()
        moduleStates.fullbright = not moduleStates.fullbright
        if moduleStates.fullbright then
            Lighting.Brightness = 5
            Lighting.ClockTime = 14
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.FogStart = 100000
        else
            Lighting.Brightness = oldBrightness
            Lighting.ClockTime = 12
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.FogStart = 0
        end
    end
    
    -- ESP Module
    local espHighlights = {}
    function ToggleESP()
        moduleStates.esp = not moduleStates.esp
        if moduleStates.esp then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hl = Instance.new("Highlight")
                    hl.FillColor = C.accent
                    hl.FillTransparency = 0.6
                    hl.OutlineColor = C.accentBright
                    hl.Parent = player.Character
                    espHighlights[player] = hl
                end
            end
            Players.PlayerAdded:Connect(function(player)
                if moduleStates.esp and player.Character then
                    local hl = Instance.new("Highlight")
                    hl.FillColor = C.accent
                    hl.FillTransparency = 0.6
                    hl.OutlineColor = C.accentBright
                    hl.Parent = player.Character
                    espHighlights[player] = hl
                end
            end)
        else
            for _, hl in pairs(espHighlights) do
                pcall(function() hl:Destroy() end)
            end
            espHighlights = {}
        end
    end
    
    -- Helper function to create module button
    function CreateModuleButton(parent, name, stateVar, toggleFunc)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 45)
        btn.BackgroundColor3 = C.card
        btn.Text = name .. ": " .. (stateVar and "ACIK" or "KAPALI")
        btn.TextColor3 = stateVar and C.accent or C.textSub
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.AutoButtonColor = false
        btn.Parent = parent
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = C.cardHover }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = C.card }):Play()
        end)
        
        btn.MouseButton1Click:Connect(function()
            toggleFunc()
            btn.Text = name .. ": " .. (stateVar and "ACIK" or "KAPALI")
            btn.TextColor3 = stateVar and C.accent or C.textSub
        end)
        
        return btn
    end
    
    -- Create Sidebar Tabs
    local function CreateSidebarTab(name, icon, contentFunc)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 45)
        btn.BackgroundColor3 = C.card
        btn.BackgroundTransparency = 1
        btn.Text = icon .. "  " .. name
        btn.TextColor3 = C.textSub
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.Parent = sidebar
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = C.card, BackgroundTransparency = 0.7 }):Play()
            TweenService:Create(btn, TweenInfo.new(0.15), { TextColor3 = C.textPrimary }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = C.panel, BackgroundTransparency = 1 }):Play()
            TweenService:Create(btn, TweenInfo.new(0.15), { TextColor3 = C.textSub }):Play()
        end)
        
        btn.MouseButton1Click:Connect(function()
            for _, child in pairs(contentArea:GetChildren()) do
                if child:IsA("Frame") or child:IsA("TextLabel") then
                    child:Destroy()
                end
            end
            contentFunc()
        end)
        
        return btn
    end
    
    -- Tab Contents
    function HomeTab()
        local header = Instance.new("TextLabel")
        header.Size = UDim2.new(1, -30, 0, 40)
        header.BackgroundTransparency = 1
        header.Text = "SANTES HUB v3.0"
        header.TextColor3 = C.accent
        header.Font = Enum.Font.Impact
        header.TextSize = 28
        header.TextXAlignment = Enum.TextXAlignment.Center
        header.Parent = contentArea
        
        local welcome = Instance.new("TextLabel")
        welcome.Size = UDim2.new(1, -30, 0, 60)
        welcome.Position = UDim2.new(0, 15, 0, 50)
        welcome.BackgroundTransparency = 1
        welcome.Text = "Hos geldin, " .. LocalPlayer.Name .. "!\n\nSantes Hub Premium v3.0 basariyla yuklendi.\nModul sekmesinden istedigin ozellikleri aktiflestirebilirsin."
        welcome.TextColor3 = C.textSub
        welcome.Font = Enum.Font.Gotham
        welcome.TextSize = 13
        welcome.TextXAlignment = Enum.TextXAlignment.Center
        welcome.TextYAlignment = Enum.TextYAlignment.Top
        welcome.Parent = contentArea
        
        local infoCard = Instance.new("Frame")
        infoCard.Size = UDim2.new(1, -30, 0, 100)
        infoCard.Position = UDim2.new(0, 15, 0, 130)
        infoCard.BackgroundColor3 = C.card
        infoCard.BorderSizePixel = 0
        infoCard.Parent = contentArea
        
        local infoCorner = Instance.new("UICorner")
        infoCorner.CornerRadius = UDim.new(0, 10)
        infoCorner.Parent = infoCard
        
        local infoText = Instance.new("TextLabel")
        infoText.Size = UDim2.new(1, -20, 1, 0)
        infoText.Position = UDim2.new(0, 10, 0, 0)
        infoText.BackgroundTransparency = 1
        infoText.Text = "💡 Ipucu: Modulleri aktiflestirmek icin MODULES sekmesine git.\n\n📌 Kisa yollar: UI ac/kapat = K tusu, Moduller kendi butonlari ile calisir."
        infoText.TextColor3 = C.textSub
        infoText.Font = Enum.Font.Gotham
        infoText.TextSize = 12
        infoText.TextXAlignment = Enum.TextXAlignment.Left
        infoText.TextWrapped = true
        infoText.Parent = infoCard
    end
    
    function ModulesTab()
        local header = Instance.new("TextLabel")
        header.Size = UDim2.new(1, -30, 0, 30)
        header.BackgroundTransparency = 1
        header.Text = "AKTIF MODULLER"
        header.TextColor3 = C.accent
        header.Font = Enum.Font.GothamBold
        header.TextSize = 14
        header.TextXAlignment = Enum.TextXAlignment.Left
        header.Parent = contentArea
        
        local modulesFrame = Instance.new("Frame")
        modulesFrame.Size = UDim2.new(1, -30, 0, 400)
        modulesFrame.BackgroundTransparency = 1
        modulesFrame.Parent = contentArea
        
        local modulesLayout = Instance.new("UIListLayout")
        modulesLayout.Padding = UDim.new(0, 10)
        modulesLayout.SortOrder = Enum.SortOrder.LayoutOrder
        modulesLayout.Parent = modulesFrame
        
        CreateModuleButton(modulesFrame, "FLY", moduleStates.fly, ToggleFly)
        CreateModuleButton(modulesFrame, "NOCLIP", moduleStates.noclip, ToggleNoclip)
        CreateModuleButton(modulesFrame, "FULLBRIGHT", moduleStates.fullbright, ToggleFullbright)
        CreateModuleButton(modulesFrame, "PLAYER ESP", moduleStates.esp, ToggleESP)
    end
    
    function InfoTab()
        local header = Instance.new("TextLabel")
        header.Size = UDim2.new(1, -30, 0, 30)
        header.BackgroundTransparency = 1
        header.Text = "BILGI"
        header.TextColor3 = C.accent
        header.Font = Enum.Font.GothamBold
        header.TextSize = 14
        header.TextXAlignment = Enum.TextXAlignment.Left
        header.Parent = contentArea
        
        local infoCard = Instance.new("Frame")
        infoCard.Size = UDim2.new(1, -30, 0, 200)
        infoCard.BackgroundColor3 = C.card
        infoCard.BorderSizePixel = 0
        infoCard.Parent = contentArea
        
        local infoCorner = Instance.new("UICorner")
        infoCorner.CornerRadius = UDim.new(0, 10)
        infoCorner.Parent = infoCard
        
        local infoText = Instance.new("TextLabel")
        infoText.Size = UDim2.new(1, -20, 1, -20)
        infoText.Position = UDim2.new(0, 10, 0, 10)
        infoText.BackgroundTransparency = 1
        infoText.Text = "Santes Hub v3.0 Premium\n\nGelistirici: Santes Team\nSurum: 3.0.0\n\nOzellikler:\n• Fly - Ucma ozelligi\n• Noclip - Duvarlardan gecme\n• Fullbright - Aydinlatma\n• Player ESP - Oyuncu isaretleme\n\nDaha fazla ozellik yakinda!"
        infoText.TextColor3 = C.textSub
        infoText.Font = Enum.Font.Gotham
        infoText.TextSize = 12
        infoText.TextXAlignment = Enum.TextXAlignment.Left
        infoText.TextYAlignment = Enum.TextYAlignment.Top
        infoText.Parent = infoCard
    end
    
    -- Create Sidebar Tabs
    CreateSidebarTab("ANA SAYFA", "🏠", HomeTab)
    CreateSidebarTab("MODULLER", "⚡", ModulesTab)
    CreateSidebarTab("BILGI", "ℹ️", InfoTab)
    
    -- Load default tab
    HomeTab()
    
    -- Mini Mode
    local miniFrame = Instance.new("Frame")
    miniFrame.Size = UDim2.new(0, 70, 0, 70)
    miniFrame.Position = UDim2.new(0, 20, 0, 100)
    miniFrame.BackgroundColor3 = C.panel
    miniFrame.BackgroundTransparency = 0
    miniFrame.BorderSizePixel = 0
    miniFrame.Visible = false
    miniFrame.Active = true
    miniFrame.Draggable = true
    miniFrame.Parent = mainGui
    
    local miniCorner = Instance.new("UICorner")
    miniCorner.CornerRadius = UDim.new(0, 35)
    miniCorner.Parent = miniFrame
    
    local miniStroke = Instance.new("UIStroke")
    miniStroke.Color = C.accent
    miniStroke.Thickness = 2
    miniStroke.Parent = miniFrame
    
    local miniText = Instance.new("TextLabel")
    miniText.Size = UDim2.new(1, 0, 1, 0)
    miniText.BackgroundTransparency = 1
    miniText.Text = "S"
    miniText.TextColor3 = C.accent
    miniText.Font = Enum.Font.Impact
    miniText.TextSize = 32
    miniText.TextXAlignment = Enum.TextXAlignment.Center
    miniText.TextYAlignment = Enum.TextYAlignment.Center
    miniText.Parent = miniFrame
    
    -- Window Controls
    local isMinimized = false
    
    minBtn.MouseButton1Click:Connect(function()
        if not isMinimized then
            isMinimized = true
            win.Visible = false
            overlay.Visible = false
            miniFrame.Visible = true
        end
    end)
    
    miniFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            miniFrame.Visible = false
            win.Visible = true
            overlay.Visible = true
            isMinimized = false
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        mainGui:Destroy()
    end)
    
    -- Dragging
    local dragStart, startPos, dragging = nil, nil, false
    
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
        end
    end)
    
    titleBar.InputEnded:Connect(function()
        dragging = false
    end)
    
    -- Keybind K
    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Enum.KeyCode.K then
            if isMinimized then
                miniFrame.Visible = false
                win.Visible = true
                overlay.Visible = true
                isMinimized = false
            else
                isMinimized = true
                win.Visible = false
                overlay.Visible = false
                miniFrame.Visible = true
            end
        end
    end)
    
    -- Animation
    win.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(win, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(0, 700, 0, 500) }):Play()
    
    print("SANTES HUB v3.0 - MAIN UI LOADED!")
end
