--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║              SANTES HUB v5.3 | CRIMINALITY                     ║
    ║    Silent Aim FIX - FOV icindeki hedefe kitlenir               ║
    ╚══════════════════════════════════════════════════════════════════╝
    
    OZELLIKLER:
    ✅ Silent Aim (Sag tus basiliyken FOV icindeki en yakin hedefe kitlenir)
    ✅ Melee Aura (Head/Body secimi + Yumruk fix)
    ✅ Fly (Sadece WASD + Joystick, havada sabit kalir)
    ✅ Auto Farm (Dealer + Safe + Para toplama - Tam otomatik)
    ✅ Player ESP (Highlight + Isim etiketi)
    ✅ Safe ESP + Respawn Timer (Soyulmus safe'lerde "3m 2s" geri sayim)
    ✅ No Recoil (getgc ile silah taramasi)
    ✅ Infinite Stamina (hookfunction)
    ✅ FullBright + FOV Changer
    ✅ Noclip + Invisibility (Shadow Mode)
    ✅ Auto Lockpick (Elinde lockpick ile safe yaninda otomatik acar)
    ✅ Auto Pickup Money + Auto Unlock/Open Doors
    ✅ Admin Detector (Staff gelince otomatik kick)
    ✅ Minimize (SANTES HUB yazisi) + K Toggle + X Full Cleanup
    ✅ Mobile uyumlu (MoveDirection joystick otomatik algilanir)
--]]

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

-- LocalPlayer ve PlayerGui'yi guvenle bekle
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)

if not PlayerGui then
    warn("SANTES: PlayerGui yuklenemedi!")
    return
end

-- #####################################################################
-- #                          ANTI-AFK                                #
-- #####################################################################

local VirtualUser = game:GetService('VirtualUser')

LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- #####################################################################
-- #                     ESKI UI TEMIZLEME                            #
-- #####################################################################

local guiNamesToClean = {
    "SantesHubScreenGui",
    "SantesHubScreenGui_Categorized",
    "EQRHubScreenGui",
    "VenomHubScreenGui",
    "VenomHubScreenGui_Categorized",
    "ShadowWarningHUD",
    "InvisWarningGUI",
    "InvisWarning",
    "SantesMinimizeFrame",
    "SantesMobileControls"
}

for _, name in pairs(guiNamesToClean) do
    pcall(function()
        local gui = PlayerGui:FindFirstChild(name)
        if gui then gui:Destroy() end
    end)
    pcall(function()
        local gui = CoreGui:FindFirstChild(name)
        if gui then gui:Destroy() end
    end)
end

-- #####################################################################
-- #                       TEMA RENKLERI                              #
-- #####################################################################

local Theme = {
    Background = Color3.fromRGB(15, 15, 20),
    Sidebar = Color3.fromRGB(20, 20, 26),
    Accent = Color3.fromRGB(200, 30, 30),
    AccentHover = Color3.fromRGB(240, 50, 50),
    TextPrimary = Color3.fromRGB(220, 220, 220),
    TextSecondary = Color3.fromRGB(150, 150, 160),
    ButtonOn = Color3.fromRGB(160, 30, 30),
    ButtonOff = Color3.fromRGB(55, 22, 22),
    BindButton = Color3.fromRGB(30, 18, 18),
    BindHover = Color3.fromRGB(55, 25, 25),
    CategoryOn = Color3.fromRGB(40, 22, 22),
    CategoryOff = Color3.fromRGB(20, 20, 26)
}

-- #####################################################################
-- #                     GUI CONSTRUCTION                             #
-- #####################################################################

-- Ana ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SantesHubScreenGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = PlayerGui

-- Ana cerceve
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 440, 0, 360)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Theme.Background
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

-- Cerceve kose ve kenar
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Theme.Accent
mainStroke.Thickness = 1.2
mainStroke.Transparency = 0.3
mainStroke.Parent = mainFrame

-- #####################################################################
-- #                       TITLE BAR                                  #
-- #####################################################################

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

-- Baslik yazisi
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -70, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "SANTES HUB v5.3"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Theme.TextPrimary
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- #####################################################################
-- #                     MINIMIZE BUTTON                              #
-- #####################################################################

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 28, 0, 28)
minimizeButton.Position = UDim2.new(1, -62, 0, 4)
minimizeButton.Text = "-"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 18
minimizeButton.TextColor3 = Theme.TextPrimary
minimizeButton.BackgroundColor3 = Color3.fromRGB(160, 130, 30)
minimizeButton.BorderSizePixel = 0
minimizeButton.AutoButtonColor = false
minimizeButton.Parent = titleBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 5)
minimizeCorner.Parent = minimizeButton

-- Minimize butonu hover efektleri
minimizeButton.MouseEnter:Connect(function()
    TweenService:Create(minimizeButton, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(200, 170, 50)
    }):Play()
end)

minimizeButton.MouseLeave:Connect(function()
    TweenService:Create(minimizeButton, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(160, 130, 30)
    }):Play()
end)

-- #####################################################################
-- #                      CLOSE BUTTON                                #
-- #####################################################################

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -30, 0, 4)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.TextColor3 = Theme.TextPrimary
closeButton.BackgroundColor3 = Theme.Accent
closeButton.BorderSizePixel = 0
closeButton.AutoButtonColor = false
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

-- Close butonu hover efektleri
closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.15), {
        BackgroundColor3 = Theme.AccentHover
    }):Play()
end)

closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.15), {
        BackgroundColor3 = Theme.Accent
    }):Play()
end)

-- #####################################################################
-- #            MINIMIZE FRAME (SANTES HUB YAZISI)                     #
-- #####################################################################

local minimizeFrame = Instance.new("Frame")
minimizeFrame.Name = "MinimizeFrame"
minimizeFrame.Size = UDim2.new(0, 55, 0, 55)
minimizeFrame.Position = UDim2.new(0.015, 0, 0.015, 0)
minimizeFrame.BackgroundColor3 = Theme.Background
minimizeFrame.BorderSizePixel = 0
minimizeFrame.Visible = false
minimizeFrame.Active = true
minimizeFrame.Draggable = true
minimizeFrame.ZIndex = 999
minimizeFrame.Parent = screenGui

local minFrameCorner = Instance.new("UICorner")
minFrameCorner.CornerRadius = UDim.new(0, 8)
minFrameCorner.Parent = minimizeFrame

local minFrameStroke = Instance.new("UIStroke")
minFrameStroke.Color = Theme.Accent
minFrameStroke.Thickness = 2
minFrameStroke.Parent = minimizeFrame

-- SANTES yazisi (kirmizi)
local santesLabel = Instance.new("TextLabel")
santesLabel.Size = UDim2.new(1, 0, 0.45, 0)
santesLabel.Position = UDim2.new(0, 0, 0.05, 0)
santesLabel.BackgroundTransparency = 1
santesLabel.Text = "SANTES"
santesLabel.Font = Enum.Font.GothamBold
santesLabel.TextSize = 14
santesLabel.TextColor3 = Theme.Accent
santesLabel.TextXAlignment = Enum.TextXAlignment.Center
santesLabel.Parent = minimizeFrame

-- HUB yazisi (beyaz)
local hubLabel = Instance.new("TextLabel")
hubLabel.Size = UDim2.new(1, 0, 0.4, 0)
hubLabel.Position = UDim2.new(0, 0, 0.50, 0)
hubLabel.BackgroundTransparency = 1
hubLabel.Text = "HUB"
hubLabel.Font = Enum.Font.GothamBold
hubLabel.TextSize = 14
hubLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
hubLabel.TextXAlignment = Enum.TextXAlignment.Center
hubLabel.Parent = minimizeFrame

-- #####################################################################
-- #                        DIVIDER                                   #
-- #####################################################################

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -16, 0, 1)
divider.Position = UDim2.new(0, 8, 0, 36)
divider.BackgroundColor3 = Theme.Accent
divider.BorderSizePixel = 0
divider.Parent = mainFrame

-- #####################################################################
-- #                        SIDEBAR                                   #
-- #####################################################################

local sidebarFrame = Instance.new("Frame")
sidebarFrame.Size = UDim2.new(0, 110, 1, -56)
sidebarFrame.Position = UDim2.new(0, 8, 0, 42)
sidebarFrame.BackgroundColor3 = Theme.Sidebar
sidebarFrame.BorderSizePixel = 0
sidebarFrame.Parent = mainFrame

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 6)
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

-- #####################################################################
-- #                     CONTENT FRAME                                #
-- #####################################################################

local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -130, 1, -56)
contentFrame.Position = UDim2.new(0, 126, 0, 42)
contentFrame.BackgroundColor3 = Theme.Sidebar
contentFrame.BorderSizePixel = 0
contentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
contentFrame.ScrollBarThickness = 3
contentFrame.ScrollBarImageColor3 = Theme.Accent
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 6)
contentCorner.Parent = contentFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 6)  -- Satir arasi bosluk
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
contentLayout.Parent = contentFrame

-- #####################################################################
-- #                        FOOTER                                    #
-- #####################################################################

local footerLabel = Instance.new("TextLabel")
footerLabel.Size = UDim2.new(1, -16, 0, 16)
footerLabel.Position = UDim2.new(0, 8, 1, -20)
footerLabel.BackgroundTransparency = 1
footerLabel.Text = "K Toggle"
footerLabel.Font = Enum.Font.Gotham
footerLabel.TextSize = 9
footerLabel.TextColor3 = Theme.TextSecondary
footerLabel.TextXAlignment = Enum.TextXAlignment.Right
footerLabel.Parent = mainFrame

-- #####################################################################
-- #               MINIMIZE / CLOSE / TOGGLE ISLEMLERI                #
-- #####################################################################

-- Eksi butonu -> kucuk kare goster
minimizeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    minimizeFrame.Visible = true
end)

-- Kucuk kareye tiklayinca -> ana UI'yi geri ac
minimizeFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 
        or input.UserInputType == Enum.UserInputType.Touch then
        
        minimizeFrame.Visible = false
        mainFrame.Visible = true
    end
end)

-- X butonu -> FULL CLEANUP (tum moduller + GUI yok edilir)
closeButton.MouseButton1Click:Connect(function()
    -- Tum modulleri kapat
    pcall(function() if flyEnabled then Fly_Disable() end end)
    pcall(function() if noclipEnabled then Noclip_Disable() end end)
    pcall(function() if fullbrightEnabled then FullBright_Disable() end end)
    pcall(function() if fovEnabled then FOV_Disable() end end)
    pcall(function() if noFailLPEnabled then NoFailLP_Disable() end end)
    pcall(function() if autoLockpickEnabled then AutoLockpick_Disable() end end)
    pcall(function() if safeESPEnabled then SafeESP_Disable() end end)
    pcall(function() if autoPickupEnabled then AutoPickup_Disable() end end)
    pcall(function() if unlockDoorsEnabled then UnlockDoors_Disable() end end)
    pcall(function() if adminCheckEnabled then AdminCheck_Disable() end end)
    pcall(function() if espEnabled then ESP_Disable() end end)
    pcall(function() if invisEnabled then Invis_Disable() end end)
    pcall(function() if noRecoilEnabled then NoRecoil_Disable() end end)
    pcall(function() if silentAimEnabled then SilentAim_Disable() end end)
    pcall(function() if meleeAuraEnabled then MeleeAura_Disable() end end)
    pcall(function() if autoFarmEnabled then AutoFarm_Disable() end end)
    pcall(function() if infStaminaEnabled then InfiniteStamina_Disable() end end)
    
    -- GUI'yi tamamen yok et
    screenGui:Destroy()
    
    -- CoreGui uyarilarini temizle
    for _, name in pairs({"InvisWarning", "ShadowWarningHUD"}) do
        pcall(function()
            local gui = CoreGui:FindFirstChild(name)
            if gui then gui:Destroy() end
        end)
    end
end)

-- K tusu ile toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        if minimizeFrame.Visible then
            minimizeFrame.Visible = false
            mainFrame.Visible = true
        else
            mainFrame.Visible = not mainFrame.Visible
        end
    end
end)

-- #####################################################################
-- #                    DRAGGING SYSTEM                               #
-- #####################################################################

do
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil

    local function updateDrag(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 
            or input.UserInputType == Enum.UserInputType.Touch then
            
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

    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement 
            or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)
end

-- #####################################################################
-- #                   TOGGLE ROW CREATOR                             #
-- #####################################################################

local activeBinds = {}
local currentRowWaitingForKey = nil
local bindButtonRefs = {}
local keyBindGetters = {}
local keyBindSetters = {}
local rowFuncData = {}

local function createToggleRow(scriptName, canToggle, isEnabledFn, onEnable, onDisable, getKeyBindFn, setKeyBindFn)
    -- Ana satir
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -12, 0, 34)
    frame.BackgroundTransparency = 1

    -- Yatay duzen
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)
    layout.Parent = frame

    -- Isim etiketi
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.44, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = scriptName
    label.TextColor3 = Theme.TextSecondary
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    -- ON/OFF butonu
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.26, 0, 0.75, 0)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 11
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.BackgroundColor3 = Theme.ButtonOff
    toggleBtn.BorderSizePixel = 0
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = frame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggleBtn

    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Color = Theme.Accent
    toggleStroke.Thickness = 1
    toggleStroke.Transparency = 0.5
    toggleStroke.Parent = toggleBtn

    local bindBtn = nil

    -- Renk hesaplama
    local function getTargetColor()
        local state = false
        if type(isEnabledFn) == 'function' then
            local s, r = pcall(isEnabledFn)
            if s then state = r end
        end
        if not canToggle then
            return Color3.fromRGB(100, 35, 35)
        end
        return state and Theme.ButtonOn or Theme.ButtonOff
    end

    -- Gorsel guncelleme
    local function updateVisuals()
        local state = false
        if type(isEnabledFn) == 'function' then
            local s, r = pcall(isEnabledFn)
            if s then state = r end
        end

        if not canToggle then
            toggleBtn.Text = "RUN"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 35, 35)
        elseif state then
            toggleBtn.Text = "ON"
            toggleBtn.BackgroundColor3 = Theme.ButtonOn
        else
            toggleBtn.Text = "OFF"
            toggleBtn.BackgroundColor3 = Theme.ButtonOff
        end
    end

    -- Satir verisi
    rowFuncData[frame] = {
        isEnabledFn = isEnabledFn,
        onEnable = onEnable,
        onDisable = onDisable,
        canToggle = canToggle,
        updateFn = updateVisuals
    }

    -- Bind butonu
    if getKeyBindFn and setKeyBindFn then
        bindBtn = Instance.new("TextButton")
        bindBtn.Size = UDim2.new(0.26, 0, 0.75, 0)
        bindBtn.Font = Enum.Font.GothamMedium
        bindBtn.TextSize = 10
        bindBtn.TextColor3 = Theme.TextSecondary
        bindBtn.BackgroundColor3 = Theme.BindButton
        bindBtn.BorderSizePixel = 0
        bindBtn.AutoButtonColor = false
        bindBtn.Parent = frame

        local bindCorner = Instance.new("UICorner")
        bindCorner.CornerRadius = UDim.new(0, 4)
        bindCorner.Parent = bindBtn

        local bindStroke = Instance.new("UIStroke")
        bindStroke.Color = Theme.Accent
        bindStroke.Thickness = 1
        bindStroke.Transparency = 0.5
        bindStroke.Parent = bindBtn

        bindButtonRefs[frame] = bindBtn
        keyBindGetters[frame] = getKeyBindFn
        keyBindSetters[frame] = setKeyBindFn

        -- Baslangic bind
        local s, r = pcall(getKeyBindFn)
        if s and r and typeof(r) == "EnumItem" then
            activeBinds[r] = {
                frame = frame,
                toggleButton = toggleBtn,
                isEnabledFn = rowFuncData[frame].isEnabledFn,
                onEnable = rowFuncData[frame].onEnable,
                onDisable = rowFuncData[frame].onDisable,
                canToggle = rowFuncData[frame].canToggle,
                updateFn = rowFuncData[frame].updateFn
            }
        end
    else
        toggleBtn.Size = UDim2.new(0.55, 0, 0.75, 0)
    end

    -- Bind yazisi guncelleme
    local function updateBindText()
        if not bindBtn then return end
        
        local kb = nil
        if type(getKeyBindFn) == 'function' then
            local s, r = pcall(getKeyBindFn)
            if s then kb = r end
        end
        
        bindBtn.Text = (kb and typeof(kb) == "EnumItem" and kb.Name ~= "Unknown") 
            and "[" .. kb.Name .. "]" 
            or "Bind"
    end

    updateVisuals()
    updateBindText()

    -- Toggle tiklamasi
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
            toggleBtn.BackgroundColor3 = Theme.ButtonOn:Lerp(
                Color3.fromRGB(10, 10, 12), 0.3
            )
            toggleBtn.Active = false
            if bindBtn then bindBtn.Active = false end
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

    -- Bind butonu tiklamasi
    if bindBtn then
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
                            txt = "[" .. r.Name .. "]"
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

    return frame
end

-- #####################################################################
-- #                       MODUL: FLY                                 #
-- #####################################################################

local flyEnabled = false
local flyConn = nil
local flySpeed = 70

function Fly_Enable()
    if flyEnabled then return end
    
    flyEnabled = true

    -- Ilk acilista yukari dogru ivme kazandir
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(0, 30, 0)
        end
    end

    flyConn = RunService.Heartbeat:Connect(function(dt)
        if not flyEnabled then return end

        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if not hrp or not hum then return end

        -- PlatformStand: Yercekimini yok et, dusmeyi engelle
        hum.PlatformStand = true

        -- Gravity override: Tum parcalarin dogal hareketini durdur
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.AssemblyLinearVelocity = Vector3.zero
                part.Velocity = Vector3.zero
            end
        end

        local cam = workspace.CurrentCamera
        if not cam then return end

        local targetVel = Vector3.new()

        -- Kameraya gore yon vektorleri
        local forward = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z).Unit
        local right = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z).Unit

        -- MoveDirection = mobil joystick veya WASD klavye
        local md = hum.MoveDirection
        
        if md.Magnitude > 0.1 then
            -- Joystick yonu varsa onu kullan
            targetVel += md * flySpeed
        else
            -- Manuel klavye kontrolu (Space/Shift YOK, sadece WASD)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                targetVel += forward * flySpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                targetVel -= forward * flySpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                targetVel -= right * flySpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                targetVel += right * flySpeed
            end
        end

        -- Hareket yoksa havada sabit kal
        if targetVel.Magnitude < 1 then
            hrp.Velocity = Vector3.new(0, 0.3, 0)
            hrp.AssemblyLinearVelocity = Vector3.zero
        else
            hrp.Velocity = targetVel
            hrp.AssemblyLinearVelocity = targetVel
        end
    end)
end

function Fly_Disable()
    flyEnabled = false
    
    if flyConn then
        flyConn:Disconnect()
        flyConn = nil
    end

    -- Karakteri normale dondur
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = false
        end
    end
end

-- #####################################################################
-- #                      MODUL: NOCLIP                               #
-- #####################################################################

local noclipEnabled = false
local noclipConn = nil

function Noclip_Enable()
    if noclipEnabled then return end
    
    noclipEnabled = true

    noclipConn = RunService.RenderStepped:Connect(function()
        if noclipEnabled and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

function Noclip_Disable()
    noclipEnabled = false
    
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
end

-- #####################################################################
-- #                    MODUL: FULLBRIGHT                              #
-- #####################################################################

local fullbrightEnabled = false
local fullbrightConn = nil
local origLighting = {}

function FullBright_Enable()
    if fullbrightEnabled then return end
    
    fullbrightEnabled = true

    -- Orijinal degerleri sakla
    origLighting = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd
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
    
    if fullbrightConn then
        fullbrightConn:Disconnect()
        fullbrightConn = nil
    end

    -- Orijinal degerlere geri don
    if origLighting.Brightness then
        Lighting.Brightness = origLighting.Brightness
        Lighting.ClockTime = origLighting.ClockTime
        Lighting.Ambient = origLighting.Ambient
        Lighting.OutdoorAmbient = origLighting.OutdoorAmbient
        Lighting.FogStart = origLighting.FogStart
        Lighting.FogEnd = origLighting.FogEnd
    end
end

-- #####################################################################
-- #                    MODUL: FOV CHANGER                             #
-- #####################################################################

local fovEnabled = false
local fovVal = 80
local fovOrig = 70

function FOV_Enable()
    fovEnabled = true
    if workspace.CurrentCamera then
        fovOrig = workspace.CurrentCamera.FieldOfView
    end
end

function FOV_Disable()
    fovEnabled = false
    if workspace.CurrentCamera then
        workspace.CurrentCamera.FieldOfView = fovOrig
    end
end

-- Surekli FOV'u zorla
RunService.RenderStepped:Connect(function()
    if fovEnabled and workspace.CurrentCamera then
        workspace.CurrentCamera.FieldOfView = fovVal
    end
end)

-- #####################################################################
-- #                 MODUL: NO FAIL LOCKPICK                           #
-- #####################################################################

local noFailLPEnabled = false
local noFailLPConn = nil

function NoFailLP_Enable()
    if noFailLPEnabled then return end
    
    noFailLPEnabled = true

    noFailLPConn = PlayerGui.ChildAdded:Connect(function(item)
        if item.Name == "LockpickGUI" then
            local mf = item:WaitForChild("MF", 10)
            if mf then
                local lpf = mf:WaitForChild("LP_Frame", 10)
                if lpf then
                    local frames = lpf:WaitForChild("Frames", 10)
                    if frames then
                        for _, bn in pairs({"B1", "B2", "B3"}) do
                            local bar = frames:WaitForChild(bn, 10)
                            if bar and bar:FindFirstChild("Bar") then
                                local uis = bar.Bar:FindFirstChild("UIScale")
                                if uis then
                                    uis.Scale = 10
                                end
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
    
    if noFailLPConn then
        noFailLPConn:Disconnect()
        noFailLPConn = nil
    end
end

-- #####################################################################
-- #            MODUL: SAFE ESP + RESPAWN TIMER                        #
-- #####################################################################

local safeESPEnabled = false
local safeESPConn = nil
local safeTimerData = {}

-- Safe tiplerine gore respawn sureleri (saniye cinsinden)
local SAFE_RESPAWN_TIMES = {
    SmallSafe = 180,        -- 3 dakika
    MediumSafe = 300,       -- 5 dakika
    LargeSafe = 420,        -- 7 dakika
    Register = 120,         -- 2 dakika
    Register_M = 150,       -- 2.5 dakika
    Register_L = 180,       -- 3 dakika
    Default = 240           -- 4 dakika (bilinmeyen safe'ler icin)
}

-- Safe isminden respawn suresini bul
local function getSafeRespawnTime(safeName)
    for pattern, time in pairs(SAFE_RESPAWN_TIMES) do
        if string.find(safeName, pattern) then
            return time
        end
    end
    return SAFE_RESPAWN_TIMES.Default
end

-- Saniyeyi "Xm Ys" formatina cevir
local function formatTime(seconds)
    if seconds <= 0 then
        return "Ready"
    end
    
    local minutes = math.floor(seconds / 60)
    local secs = math.floor(seconds % 60)
    
    return string.format("%dm %ds", minutes, secs)
end

-- Safe ESP ana guncelleme fonksiyonu
local function safeESPUpdate()
    local folder = Workspace.Map and Workspace.Map:FindFirstChild("BredMakurz")
    if not folder then
        folder = Workspace:FindFirstChild("BredMakurz")
    end
    if not folder then return end

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local myPos = char.HumanoidRootPart.Position
    local now = tick()

    for _, obj in pairs(folder:GetChildren()) do
        local primaryPart = obj.PrimaryPart
        local part = (primaryPart and primaryPart:IsA("BasePart")) 
            and primaryPart 
            or obj:FindFirstChildOfClass("BasePart")
        
        if part then
            local dist = (part.Position - myPos).magnitude
            local exist = obj:FindFirstChild("SantesSE")
            local values = obj:FindFirstChild("Values")
            local broken = values and values:FindFirstChild("Broken")

            if dist <= 250 then
                if not exist then
                    -- BillboardGui olustur (iki satir: isim + timer)
                    local bg = Instance.new("BillboardGui")
                    bg.Name = "SantesSE"
                    bg.AlwaysOnTop = true
                    bg.Size = UDim2.new(0, 140, 0, 35)
                    bg.MaxDistance = 250
                    bg.Adornee = obj
                    bg.Parent = obj

                    -- Ust satir: Safe ismi
                    local tl = Instance.new("TextLabel", bg)
                    tl.Size = UDim2.new(1, 0, 0.5, 0)
                    tl.BackgroundTransparency = 1
                    tl.Font = Enum.Font.SourceSansBold
                    tl.TextScaled = false
                    tl.TextSize = 13
                    tl.Text = obj.Name
                        :gsub("([a-z])([A-Z])", "%1 %2")
                        :gsub("_.*", "")

                    -- Alt satir: Timer / Ready
                    local timerLabel = Instance.new("TextLabel", bg)
                    timerLabel.Size = UDim2.new(1, 0, 0.5, 0)
                    timerLabel.Position = UDim2.new(0, 0, 0.5, 0)
                    timerLabel.BackgroundTransparency = 1
                    timerLabel.Font = Enum.Font.Gotham
                    timerLabel.TextScaled = false
                    timerLabel.TextSize = 11

                    if broken and broken:IsA("BoolValue") then
                        if broken.Value then
                            -- Safe SOYULMUS durumda -> Kirmizi + Timer
                            tl.TextColor3 = Color3.new(1, 0, 0)
                            local respawnTime = getSafeRespawnTime(obj.Name)
                            timerLabel.Text = formatTime(respawnTime)
                            timerLabel.TextColor3 = Color3.new(1, 0.6, 0)
                            
                            safeTimerData[obj] = {
                                brokenTime = now,
                                respawnTime = respawnTime,
                                label = timerLabel,
                                nameLabel = tl
                            }
                        else
                            -- Safe CALISIR durumda -> Yesil
                            tl.TextColor3 = Color3.new(0, 1, 0)
                            timerLabel.Text = "Ready"
                            timerLabel.TextColor3 = Color3.new(0, 1, 0)
                            safeTimerData[obj] = nil
                        end

                        -- Kirilma durumu degisince anlik guncelle
                        broken:GetPropertyChangedSignal("Value"):Connect(function()
                            if broken.Value then
                                -- Yeni kirildi
                                tl.TextColor3 = Color3.new(1, 0, 0)
                                local rt = getSafeRespawnTime(obj.Name)
                                timerLabel.Text = formatTime(rt)
                                timerLabel.TextColor3 = Color3.new(1, 0.6, 0)
                                
                                safeTimerData[obj] = {
                                    brokenTime = tick(),
                                    respawnTime = rt,
                                    label = timerLabel,
                                    nameLabel = tl
                                }
                            else
                                -- Yeniden calisir oldu
                                tl.TextColor3 = Color3.new(0, 1, 0)
                                timerLabel.Text = "Ready"
                                timerLabel.TextColor3 = Color3.new(0, 1, 0)
                                safeTimerData[obj] = nil
                            end
                        end)
                    else
                        -- Broken degeri yoksa varsayilan olarak yesil
                        tl.TextColor3 = Color3.new(0, 1, 0)
                        timerLabel.Text = "Ready"
                        timerLabel.TextColor3 = Color3.new(0, 1, 0)
                    end
                end
            elseif exist then
                -- Menzil disinda kaldiysa GUI'yi yok et
                exist:Destroy()
                safeTimerData[obj] = nil
            end
        end
    end

    -- Timer'lari surekli guncelle (geri sayim)
    for obj, data in pairs(safeTimerData) do
        if data and data.label and data.label.Parent then
            local elapsed = now - data.brokenTime
            local remaining = data.respawnTime - elapsed
            
            if remaining > 0 then
                data.label.Text = formatTime(remaining)
            else
                -- Sure doldu, Ready yap
                data.label.Text = "Ready"
                data.label.TextColor3 = Color3.new(0, 1, 0)
                if data.nameLabel then
                    data.nameLabel.TextColor3 = Color3.new(0, 1, 0)
                end
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
    
    if safeESPConn then
        safeESPConn:Disconnect()
        safeESPConn = nil
    end

    -- TUM BillboardGui'leri temizle (klasordeki tum "SantesSE" objeleri)
    local folder = Workspace.Map and Workspace.Map:FindFirstChild("BredMakurz")
    if not folder then
        folder = Workspace:FindFirstChild("BredMakurz")
    end
    if folder then
        for _, obj in pairs(folder:GetChildren()) do
            local esp = obj:FindFirstChild("SantesSE")
            if esp then
                esp:Destroy()
            end
        end
    end
    
    safeTimerData = {}
end

-- #####################################################################
-- #   MODUL: AUTO LOCKPICK (ANINDA ACMA - YANINA GIDINCE DIREKT)     #
-- #####################################################################
-- #                                                                    #
-- #  NASIL CALISIR:                                                    #
-- #  1. Backpack'te Lockpick varsa otomatik kusanir                   #
-- #  2. Safe/Register'in 3 stud yanina git                            #
-- #  3. ANINDA kasa acilir (1 lockpick harcar)                        #
-- #  4. Lockpick biter, bir sonraki safe icin yeni lockpick lazim     #
-- #                                                                    #
-- #####################################################################

local autoLockpickEnabled = false
local autoLockpickConn = nil
local lockpickCD = false
local lastOpenedSafe = nil  -- Ayni safe'i tekrar acmaya calismasin

function AutoLockpick_Enable()
    if autoLockpickEnabled then return end
    
    autoLockpickEnabled = true

    autoLockpickConn = RunService.Heartbeat:Connect(function()
        if not autoLockpickEnabled then return end
        if lockpickCD then return end

        local char = LocalPlayer.Character
        if not char then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- =============================================
        -- ADIM 1: Lockpick'i bul ve kusan
        -- =============================================
        local lockpickTool = char:FindFirstChild("Lockpick")
        if not lockpickTool then
            local bp = LocalPlayer:FindFirstChild("Backpack")
            if bp then
                for _, item in pairs(bp:GetChildren()) do
                    if item.Name == "Lockpick" or string.find(string.lower(item.Name), "lockpick") then
                        lockpickTool = item
                        break
                    end
                end
            end
        end

        -- Lockpick yoksa cik
        if not lockpickTool then return end

        -- Elde degilse kusan
        if not char:FindFirstChild(lockpickTool.Name) then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function() hum:EquipTool(lockpickTool) end)
                return  -- Bir sonraki dongude devam et
            end
        end

        -- =============================================
        -- ADIM 2: En yakin acilmamis safe'i bul (3 stud)
        -- =============================================
        local folder = Workspace.Map and Workspace.Map:FindFirstChild("BredMakurz")
        if not folder then
            folder = Workspace:FindFirstChild("BredMakurz")
        end
        if not folder then return end

        local nearestDist = 3
        local nearestSafe = nil
        local nearestMainPart = nil

        for _, obj in pairs(folder:GetChildren()) do
            -- Daha once acilmis safe'i atla
            if obj ~= lastOpenedSafe then
                if string.find(obj.Name, "Safe") or string.find(obj.Name, "Register") then
                    local mainPart = obj:FindFirstChild("MainPart") or obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
                    
                    if mainPart then
                        local dist = (hrp.Position - mainPart.Position).Magnitude
                        if dist < nearestDist then
                            -- Kirik degil mi kontrol et
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

        -- Acilacak safe yoksa cik
        if not nearestSafe then return end

        -- =============================================
        -- ADIM 3: ANINDA ACMA
        -- =============================================
        lockpickCD = true
        lastOpenedSafe = nearestSafe

        local events = ReplicatedStorage:FindFirstChild("Events")
        if not events then lockpickCD = false; return end

        -- YONTEM 1: Lockpick remote'lari ile dene
        local r1 = events:FindFirstChild("XMHH.2")
        local r2 = events:FindFirstChild("XMHH2.2")
        
        if r1 and r2 and nearestMainPart then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                local result = r1:InvokeServer(
                    "\240\159\141\158",  -- "🍞"
                    tick(),
                    tool,
                    "DZDRRRKI",
                    nearestSafe,
                    "Register"
                )
                
                if result then
                    r2:FireServer(
                        "\240\159\141\158",
                        tick(),
                        tool,
                        "2389ZFX34",
                        result,
                        false,
                        char:FindFirstChild("Right Arm") or hrp,
                        nearestMainPart,
                        nearestSafe,
                        nearestMainPart.Position,
                        nearestMainPart.Position
                    )
                end
            end
        end

        -- YONTEM 2: LockpickStart eventi
        local lockpickEvent = events:FindFirstChild("LockpickStart")
            or events:FindFirstChild("StartLockpick")
            or events:FindFirstChild("LockpickEvent")
            or events:FindFirstChild("Lockpick")
        
        if lockpickEvent and nearestMainPart then
            pcall(function()
                lockpickEvent:FireServer(nearestSafe, nearestMainPart)
            end)
        end

        -- YONTEM 3: ToolEvent / UseTool
        local toolEvent = events:FindFirstChild("ToolEvent")
            or events:FindFirstChild("UseTool")
            or events:FindFirstChild("ToolRemote")
        
        if toolEvent and nearestMainPart then
            pcall(function()
                toolEvent:FireServer(nearestSafe, nearestMainPart, "Lockpick")
            end)
        end

        -- YONTEM 4: BYZERSPROTEC (bazi sunucularda kullanilir)
        local byzers = events:FindFirstChild("BYZERSPROTEC")
        if byzers and nearestMainPart then
            pcall(function()
                byzers:FireServer(true, "safe", nearestMainPart, "Lockpick")
                task.wait(0.05)
                byzers:FireServer(false)
            end)
        end

        -- Lockpick GUI'si acildiysa hemen kapat (UIScale ile)
        task.wait(0.05)
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            local lockpickGUI = playerGui:FindFirstChild("LockpickGUI")
            if lockpickGUI then
                -- Barlari aninda tamamla
                for attempt = 1, 30 do
                    pcall(function()
                        local frames = lockpickGUI.MF and lockpickGUI.MF.LP_Frame and lockpickGUI.MF.LP_Frame.Frames
                        if frames then
                            for _, bn in pairs({"B1", "B2", "B3"}) do
                                local bar = frames:FindFirstChild(bn)
                                if bar and bar:FindFirstChild("Bar") then
                                    local uis = bar.Bar:FindFirstChild("UIScale")
                                    if uis then uis.Scale = 20 end
                                    
                                    local btn = bar.Bar:FindFirstChildOfClass("TextButton")
                                    if btn then
                                        local green = bar.Bar:FindFirstChild("Green")
                                        if not green or not green.Visible then
                                            pcall(function() btn.MouseButton1Click:Fire() end)
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    
                    if not lockpickGUI.Parent then break end
                    task.wait(0.02)
                end
            end
        end

        -- Cooldown bitir (0.3 saniye sonra yeni safe acilabilir)
        task.wait(0.3)
        lockpickCD = false
    end)
end

function AutoLockpick_Disable()
    autoLockpickEnabled = false
    lockpickCD = false
    lastOpenedSafe = nil
    
    if autoLockpickConn then
        autoLockpickConn:Disconnect()
        autoLockpickConn = nil
    end
end
-- #####################################################################
-- #                 MODUL: AUTO PICKUP MONEY                          #
-- #####################################################################

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

        -- Para klasorunu bul
        local folder = Workspace.Filter and Workspace.Filter:FindFirstChild("SpawnedBread")
        if not folder then
            folder = Workspace:FindFirstChild("SpawnedBread")
        end
        if not folder then return end

        -- RemoteEvent'i bul
        local remote = ReplicatedStorage.Events and ReplicatedStorage.Events:FindFirstChild("CZDPZUS")
        if not remote then return end

        -- En yakin parayi bul ve topla
        for _, bread in pairs(folder:GetChildren()) do
            if bread:IsA("BasePart") and (hrp.Position - bread.Position).Magnitude < 5 then
                pickupCD = true
                pcall(function()
                    remote:FireServer(bread)
                end)
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
    
    if autoPickupConn then
        autoPickupConn:Disconnect()
        autoPickupConn = nil
    end
end

-- #####################################################################
-- #              MODUL: AUTO UNLOCK/OPEN DOORS                        #
-- #####################################################################

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
                        -- Once kilit ac
                        local locked = values:FindFirstChild("Locked")
                        local lockPart = door:FindFirstChild("Lock")
                        
                        if locked and lockPart and locked.Value == true then
                            pcall(function()
                                toggle:FireServer("Unlock", lockPart)
                            end)
                        end

                        -- Sonra kapiyi ac
                        local openVal = values:FindFirstChild("Open")
                        local knob = door:FindFirstChild("Knob2") or door:FindFirstChild("Knob")
                        
                        if openVal and knob and openVal.Value == false then
                            pcall(function()
                                toggle:FireServer("Open", knob)
                            end)
                        end
                    end
                end
            end
        end
    end)
end

function UnlockDoors_Disable()
    unlockDoorsEnabled = false
    
    if unlockDoorsConn then
        unlockDoorsConn:Disconnect()
        unlockDoorsConn = nil
    end
end

-- #####################################################################
-- #                 MODUL: ADMIN DETECTOR                             #
-- #####################################################################

local adminCheckEnabled = false
local adminCheckConn = nil

-- Bilinen staff UserID'leri
local staffUsers = {
    3294804378, 93676120, 54087314, 81275825, 140837601, 1229486091,
    46567801, 418086275, 29706395, 3717066084, 1424338327, 5046662686,
    63238912, 111250044, 63315426, 730176906, 141193516, 194512073,
    193945439, 412741116, 195538733, 102045519, 955294, 957835150,
    25689921, 366613818, 281593651, 455275714, 208929505, 96783330,
    156152502, 93281166, 959606619, 142821118, 632886139, 175931803,
    122209625, 278097946, 142989311, 1517131734, 446849296, 87189764,
    67180844, 9212846, 47352513, 48058122, 155413858, 10497435,
    513615792, 55893752, 55476024, 151691292, 136584758, 16983447,
    3111449, 94693025, 271400893, 5005262660, 295331237, 64489098,
    244844600, 114332275, 25048901, 69262878, 50801509, 92504899,
    42066711, 50585425, 31365111, 166406495, 2457253857, 29761878,
    21831137, 948293345, 439942262, 38578487, 1163048, 7713309208,
    3659305297, 15598614, 34616594, 626833004, 198610386, 153835477,
    3923114296, 3937697838, 102146039, 119861460, 371665775, 1206543842,
    93428604, 1863173316, 90814576, 374665997, 423005063, 140172831,
    42662179, 9066859, 438805620, 14855669, 727189337, 1871290386,
    608073286
}

local function checkStaff(player)
    if player == LocalPlayer then return false end

    for _, uid in pairs(staffUsers) do
        if player.UserId == uid then
            pcall(function()
                LocalPlayer:Kick("SANTES: Staff detected - " .. player.Name)
            end)
            return true
        end
    end
    
    return false
end

function AdminCheck_Enable()
    if adminCheckEnabled then return end
    
    adminCheckEnabled = true

    -- Sunucudaki mevcut oyunculari kontrol et
    for _, player in pairs(Players:GetPlayers()) do
        if checkStaff(player) then return end
    end

    -- Yeni girenleri izle
    adminCheckConn = Players.PlayerAdded:Connect(checkStaff)
end

function AdminCheck_Disable()
    adminCheckEnabled = false
    
    if adminCheckConn then
        adminCheckConn:Disconnect()
        adminCheckConn = nil
    end
end

-- #####################################################################
-- #                   MODUL: PLAYER ESP                               #
-- #####################################################################

local espEnabled = false
local espConns = {}
local espList = {}

local function espCreate(player)
    if player == LocalPlayer or espList[player] then return end
    
    espList[player] = true

    local function setupESP(char)
        if not espEnabled or not char or not char.Parent then return end

        -- Highlight (kirmizi)
        local highlight = Instance.new("Highlight")
        highlight.Name = "SantesESP"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.65
        highlight.OutlineColor = Color3.fromRGB(255, 40, 40)
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = char

        -- Isim etiketi
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

    if player.Character then
        setupESP(player.Character)
    end

    table.insert(espConns, player.CharacterAdded:Connect(setupESP))
end

function ESP_Enable()
    if espEnabled then return end
    
    espEnabled = true
    espList = {}

    -- Mevcut oyunculara ESP ekle
    for _, player in pairs(Players:GetPlayers()) do
        espCreate(player)
    end

    -- Yeni girenlere ESP ekle
    table.insert(espConns, Players.PlayerAdded:Connect(function(player)
        if espEnabled then espCreate(player) end
    end))

    -- Cikan oyunculari listeden cikar
    table.insert(espConns, Players.PlayerRemoving:Connect(function(player)
        espList[player] = nil
    end))
end

function ESP_Disable()
    espEnabled = false

    -- Tum baglantilari kes
    for _, conn in pairs(espConns) do
        pcall(function() conn:Disconnect() end)
    end
    
    espConns = {}
    espList = {}

    -- Tum ESP elemanlarini temizle
    for _, player in pairs(Players:GetPlayers()) do
        pcall(function()
            if player.Character then
                local hl = player.Character:FindFirstChild("SantesESP")
                if hl then hl:Destroy() end

                for _, obj in pairs(player.Character:GetDescendants()) do
                    if obj:IsA("BillboardGui") and obj.Name == "SantesESPInfo" then
                        obj:Destroy()
                    end
                end
            end
        end)
    end
end

-- #####################################################################
-- #              MODUL: INVISIBILITY (SHADOW MODE)                    #
-- #####################################################################

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
        return invisHum 
            and invisHum:IsDescendantOf(Workspace) 
            and invisHum.FloorMaterial ~= Enum.Material.Air
    end

    local function loadTrack()
        if invisTrack then
            pcall(function() invisTrack:Stop() end)
            invisTrack = nil
        end
        
        if invisHum then
            local s, r = pcall(function()
                return invisHum:LoadAnimation(anim)
            end)
            if s then
                invisTrack = r
                invisTrack.Priority = Enum.AnimationPriority.Action4
            end
        end
    end

    RunService.Heartbeat:Connect(function(dt)
        if not invisEnabled or not invisUsable then
            if not invisEnabled and invisChar then
                for _, v in pairs(invisChar:GetDescendants()) do
                    if v:IsA("BasePart") and v.Transparency == 0.5 then
                        v.Transparency = 0
                    end
                end
            end
            if invisWarn then invisWarn.Visible = false end
            return
        end

        if not invisChar or not invisHum or not invisHRP or invisHum.Health <= 0 then
            if invisWarn then invisWarn.Visible = false end
            return
        end

        if invisWarn then
            invisWarn.Visible = not grounded()
        end

        if invisHum.MoveDirection.Magnitude > 0 then
            invisHRP.CFrame += invisHum.MoveDirection * 12 * dt
        end

        local oldCF = invisHRP.CFrame
        local oldOff = invisHum.CameraOffset

        local _, y = workspace.CurrentCamera.CFrame:ToOrientation()
        invisHRP.CFrame = CFrame.new(invisHRP.Position) 
            * CFrame.fromOrientation(0, y, 0) 
            * CFrame.Angles(math.rad(90), 0, 0)
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

        if invisHum:IsDescendantOf(Workspace) then
            invisHum.CameraOffset = oldOff
        end
        
        if invisHRP:IsDescendantOf(Workspace) then
            invisHRP.CFrame = oldCF
        end

        if invisTrack then
            pcall(function() invisTrack:Stop() end)
        end

        if invisHRP:IsDescendantOf(Workspace) then
            local lookVec = workspace.CurrentCamera.CFrame.LookVector
            local flat = Vector3.new(lookVec.X, 0, lookVec.Z).Unit
            if flat.Magnitude > 0.1 then
                invisHRP.CFrame = CFrame.new(invisHRP.Position, invisHRP.Position + flat)
            end
        end

        for _, v in pairs(invisChar:GetDescendants()) do
            if v:IsA("BasePart") and v.Transparency ~= 1 then
                v.Transparency = 0.5
            end
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        if invisTrack then
            pcall(function() invisTrack:Stop() end)
            invisTrack = nil
        end
        
        task.wait()
        updateRefs()

        if invisHum and invisHum.RigType ~= Enum.HumanoidRigType.R6 then
            invisUsable = false
            if invisEnabled then Invis_Disable() end
        else
            invisUsable = true
            if invisEnabled then
                workspace.CurrentCamera.CameraSubject = invisHRP
                loadTrack()
            end
        end
    end)

    updateRefs()
    
    if invisHum and invisHum.RigType ~= Enum.HumanoidRigType.R6 then
        invisUsable = false
    end

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

    _G.Invis_Enable = function()
        if invisEnabled or not invisUsable then return end
        
        invisEnabled = true
        updateRefs()
        
        if invisHRP then
            workspace.CurrentCamera.CameraSubject = invisHRP
        end
        
        loadTrack()
    end

    _G.Invis_Disable = function()
        if not invisEnabled then return end
        
        invisEnabled = false
        
        if invisTrack then pcall(function() invisTrack:Stop() end) end
        if invisHum then workspace.CurrentCamera.CameraSubject = invisHum end
        
        if invisChar then
            for _, v in pairs(invisChar:GetDescendants()) do
                if v:IsA("BasePart") and v.Transparency == 0.5 then
                    v.Transparency = 0
                end
            end
        end
        
        if invisWarn then invisWarn.Visible = false end
    end

    _G.IsInvisEnabled = function()
        return invisEnabled
    end
end

function Invis_Enable() _G.Invis_Enable() end
function Invis_Disable() _G.Invis_Disable() end

-- #####################################################################
-- #             MODUL: NO RECOIL (XENO UYUMLU)                       #
-- #####################################################################

local noRecoilEnabled = false

function NoRecoil_Enable()
    if noRecoilEnabled then return end
    noRecoilEnabled = true

    -- Xeno'da getgc calismayabilir, alternatif yontem
    task.spawn(function()
        while noRecoilEnabled do
            pcall(function()
                -- Calistigin oyunun silah tablolarini bul
                for _, v in pairs(getgc(true)) do
                    if type(v) == 'table' then
                        -- Recoil varsa sifirla
                        if rawget(v, 'Recoil') ~= nil then
                            v.Recoil = 0
                            v.Spread = 0
                            v.CameraRecoilingEnabled = false
                        end
                        -- Angle varsa sifirla
                        if rawget(v, 'AngleX_Min') ~= nil then
                            v.AngleX_Min = 0; v.AngleX_Max = 0
                            v.AngleY_Min = 0; v.AngleY_Max = 0
                            v.AngleZ_Min = 0; v.AngleZ_Max = 0
                        end
                    end
                end
            end)
            task.wait(1) -- Her saniye kontrol et
        end
    end)
end

function NoRecoil_Disable()
    noRecoilEnabled = false
end
-- #####################################################################
-- #       MODUL: SILENT AIM (XENO UYUMLU - DRAWING YOK)              #
-- #####################################################################

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

        local screenCenter = Vector2.new(
            cam.ViewportSize.X / 2,
            cam.ViewportSize.Y / 2
        )

        local closestPlayer = nil
        local closestDistance = silentAimFOV

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                local targetPart = player.Character:FindFirstChild("Head") 
                    or player.Character:FindFirstChild("HumanoidRootPart")

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

        -- HEDEFE HITBOX EKLE (Drawing yerine Part kullan)
        if closestPlayer and closestPlayer.Character then
            local targetPart = closestPlayer.Character:FindFirstChild("Head") 
                or closestPlayer.Character:FindFirstChild("HumanoidRootPart")

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
                    if part:IsA("BasePart") and part.Name == "SantesHitbox" then
                        part:Destroy()
                    end
                end
            end
        end)
    end
end

function SilentAim_SetFOV(value)
    silentAimFOV = math.clamp(value, 50, 500)
end

function SilentAim_GetFOV()
    return silentAimFOV
end
-- #####################################################################
-- #         MODUL: MELEE AURA (HEAD/BODY + YUMRUK FIX)                #
-- #####################################################################

local meleeAuraEnabled = false
local meleeAuraConn = nil
local meleeTarget = "Head"

function MeleeAura_Enable()
    if meleeAuraEnabled then return end
    
    meleeAuraEnabled = true

    local eventsFolder = ReplicatedStorage:WaitForChild("Events", 10)
    if not eventsFolder then return end

    local remote1 = eventsFolder:WaitForChild("XMHH.2", 5)
    local remote2 = eventsFolder:WaitForChild("XMHH2.2", 5)

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

                if enemyHRP and enemyHum 
                    and enemyHum.Health > 15 
                    and not pl.Character:FindFirstChildOfClass("ForceField") then
                    
                    local dist = (myHRP.Position - enemyHRP.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestEnemy = pl
                    end
                end
            end
        end

        if not closestEnemy then return end

        local targetChar = closestEnemy.Character
        local targetPart = targetChar:FindFirstChild(meleeTarget)

        if not targetPart then return end

        local fakeTool = tool or myChar:FindFirstChild("Right Arm") or myHRP

        local result = remote1:InvokeServer(
            "\240\159\141\158",
            tick(),
            fakeTool,
            "43TRFWX",
            "Normal",
            tick(),
            true
        )

        if result then
            local handle = (tool and (
                tool:FindFirstChild("WeaponHandle") 
                or tool:FindFirstChild("Handle")
            )) or myChar:FindFirstChild("Right Arm")

            if handle then
                remote2:FireServer(
                    "\240\159\141\158",
                    tick(),
                    fakeTool,
                    "2389ZFX34",
                    result,
                    false,
                    handle,
                    targetPart,
                    targetChar,
                    myHRP.Position,
                    targetPart.Position
                )
            end
        end

        task.wait(0.08)
    end)
end

function MeleeAura_Disable()
    meleeAuraEnabled = false
    
    if meleeAuraConn then
        meleeAuraConn:Disconnect()
        meleeAuraConn = nil
    end
end

function MeleeAura_SetTarget(target)
    if target == "Head" or target == "Body" then
        meleeTarget = target == "Body" and "HumanoidRootPart" or "Head"
    end
end

function MeleeAura_GetTarget()
    return meleeTarget == "Head" and "Head" or "Body"
end

-- #####################################################################
-- #           MODUL: INFINITE STAMINA (XENO UYUMLU)                  #
-- #####################################################################

local infStaminaEnabled = false
local infStaminaConn = nil

function InfiniteStamina_Enable()
    if infStaminaEnabled then return end
    infStaminaEnabled = true

    -- Xeno'da hookfunction calismaz, direkt stamina degerini sifirla
    infStaminaConn = RunService.RenderStepped:Connect(function()
        if not infStaminaEnabled then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        -- Tum Humanoid'lerin stamina'sini sifirla
        for _, hum in pairs(char:GetDescendants()) do
            if hum:IsA("Humanoid") then
                -- Stamina'yi max'ta tut
                if hum.MaxStamina and hum.Stamina then
                    hum.Stamina = hum.MaxStamina
                end
            end
        end
    end)
end

function InfiniteStamina_Disable()
    infStaminaEnabled = false
    if infStaminaConn then infStaminaConn:Disconnect(); infStaminaConn = nil end
end
-- #####################################################################
-- #                   MODUL: AUTO FARM (CRIMINALITY)                 #
-- #####################################################################

local autoFarmEnabled = false
local autoFarmMode = "Crowbar" -- "Crowbar", "FistLockpick"
local autoFarmCoroutine = nil
local farmIgnored = {}

-- Hareket hızı ayarı (Criminality'de normal yürüme hızı 16, koşma 20-22)
local moveSpeed = 20
local speedSlider = nil
local speedValueLabel = nil

-- Para yatırma limiti (Criminality'de allowance 50k max)
local depositLimit = 5000
local depositSlider = nil
local depositValueLabel = nil

-- Allowance Takibi (Criminality'nin real allowance sistemi için)
local allowanceTrackingEnabled = false
local allowanceCheckConn = nil
local allowanceUI = nil
local currentAllowance = 0
local allowanceLimit = 5000
local lastDepositTime = 0
local lastAllowanceFetch = 0

-- Lockpick sayacı (Criminality'de max 8 lockpick alınabilir)
local lockpickCount = 0
local maxLockpickCount = 8

-- Path çizgi objeleri
local currentPathLines = {}
local pathLineConnection = nil

-- Invisibility kontrolü
local wasInvisibleBeforeFarm = false

-- ATM lokasyonları (Criminality haritasına göre)
local atmLocations = {}

-- Criminality için event referansları
local Events = nil
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Criminality'nin event yapısını bul
local function getEvents()
    if Events then return Events end
    Events = ReplicatedStorage:FindFirstChild("Events")
    if not Events then
        for _, child in pairs(ReplicatedStorage:GetChildren()) do
            if child.Name == "Events" or child:FindFirstChild("XMHH.2") then
                Events = child
                break
            end
        end
    end
    return Events
end

-- =============================================
-- CRIMINALITY ALLOWANCE OKUMA
-- =============================================

local function getCurrentAllowance()
    -- Criminality'de allowance değeri genellikle PlayerGui'de veya leaderstats'te olur
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        local allowance = leaderstats:FindFirstChild("Allowance") or leaderstats:FindFirstChild("Money")
        if allowance then
            return allowance.Value
        end
    end
    
    -- Alternatif: PlayerGui'deki AllowanceFrame
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        for _, gui in pairs(playerGui:GetChildren()) do
            if gui.Name == "AllowanceFrame" or gui.Name == "MoneyFrame" then
                local textLabel = gui:FindFirstChildOfClass("TextLabel")
                if textLabel then
                    local text = textLabel.Text
                    local num = tonumber(text:match("(%d+)"))
                    if num then return num end
                end
            end
        end
    end
    
    return currentAllowance -- fallback
end

local function updateAllowanceUI()
    if not allowanceUI or not allowanceUI.Visible then return end
    
    local textLabel = allowanceUI:FindFirstChild("TextLabel")
    if textLabel then
        local remaining = allowanceLimit - currentAllowance
        if remaining <= 0 then
            textLabel.Text = string.format("ALLOWANCE: $%d / $%d (READY!)", currentAllowance, allowanceLimit)
        else
            textLabel.Text = string.format("ALLOWANCE: $%d / $%d ($%d left)", currentAllowance, allowanceLimit, remaining)
        end
    end
end

-- =============================================
-- PATH ÇİZGİ FONKSİYONLARI (Yeşil çizgi)
-- =============================================

local function clearPathLines()
    for _, line in pairs(currentPathLines) do
        pcall(function() line:Destroy() end)
    end
    currentPathLines = {}
end

local function drawPathLine(points, color)
    clearPathLines()
    
    if #points < 2 then return end
    
    for i = 1, #points - 1 do
        local distance = (points[i] - points[i + 1]).Magnitude
        local line = Instance.new("Part")
        line.Name = "SantesPathLine"
        line.Size = Vector3.new(0.15, 0.15, distance)
        line.CFrame = CFrame.new(points[i], points[i + 1]) * CFrame.new(0, 0, -distance/2)
        line.BrickColor = BrickColor.new(color)
        line.Material = Enum.Material.Neon
        line.Anchored = true
        line.CanCollide = false
        line.Transparency = 0.2
        line.Parent = workspace
        table.insert(currentPathLines, line)
    end
end

local function updatePathDrawing(points)
    drawPathLine(points, "Lime green")
end

-- =============================================
-- INVISIBILITY KONTROL (Criminality Shadow Mode)
-- =============================================

local function ensureInvisible()
    if not autoFarmEnabled then return end
    
    -- Criminality'nin shadow mode/ invisibility fonksiyonu
    if _G.Invis_Enable and not (_G.IsInvisEnabled and _G.IsInvisEnabled()) then
        _G.Invis_Enable()
        task.wait(0.3)
    end
end

local function respawnAndGoInvisible()
    -- Criminality'de ölünce respawn mekanizması
    local events = getEvents()
    if events then
        local deathRespawn = events:FindFirstChild("DeathRespawn")
        if deathRespawn then
            pcall(function() deathRespawn:InvokeServer("KMG4R904") end)
        end
    end
    
    -- Alternatif respawn metodu
    local playerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
    if playerScripts then
        local respawnModule = playerScripts:FindFirstChild("Respawn")
        if respawnModule then
            pcall(function() respawnModule:Fire() end)
        end
    end
    
    wait(2)
    
    -- Yeniden doğduktan sonra invisible ol
    task.wait(0.5)
    ensureInvisible()
end

-- =============================================
-- MESAFEYE GÖRE IŞINLANMA veya YÜRÜME
-- =============================================

local function moveToPosition(targetPos, usePath, pathPoints)
    local char = LocalPlayer.Character
    if not char then return false end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return false end
    
    local distance = (hrp.Position - targetPos).Magnitude
    
    -- 5 metreden uzaksa direkt ışınlan (Criminality'de antix ışınlanma koruması var ama çalışıyor)
    if distance > 5 then
        hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
        wait(0.3)
        
        if usePath then
            clearPathLines()
        end
        return true
    end
    
    -- Path varsa ve kullanılacaksa yeşil çizgi ile yürü
    if usePath and pathPoints and #pathPoints > 0 then
        updatePathDrawing(pathPoints)
        
        -- Önce path'in başlangıç noktasına git (çok uzaksa ışınlan)
        local startDist = (hrp.Position - pathPoints[1]).Magnitude
        if startDist > 5 then
            hrp.CFrame = CFrame.new(pathPoints[1] + Vector3.new(0, 3, 0))
            wait(0.3)
        end
        
        hum.WalkSpeed = moveSpeed
        hum.AutoRotate = true
        
        for i = 1, #pathPoints do
            if not autoFarmEnabled then break end
            
            local point = pathPoints[i]
            local pointDist = (hrp.Position - point).Magnitude
            
            if pointDist > 5 then
                -- Path noktasına ışınlan
                hrp.CFrame = CFrame.new(point + Vector3.new(0, 3, 0))
                wait(0.2)
            else
                -- Yürüyerek git
                local startTime = tick()
                while (hrp.Position - point).Magnitude > 2 and tick() - startTime < 10 do
                    if not autoFarmEnabled then break end
                    
                    char = LocalPlayer.Character
                    if not char then break end
                    
                    hrp = char:FindFirstChild("HumanoidRootPart")
                    hum = char:FindFirstChildOfClass("Humanoid")
                    if not hrp or not hum then break end
                    
                    local lookAt = (point - hrp.Position).Unit
                    hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(lookAt.X, 0, lookAt.Z))
                    hum.MoveDirection = Vector3.new(lookAt.X, 0, lookAt.Z)
                    
                    wait()
                end
            end
        end
        
        hum.MoveDirection = Vector3.new()
        clearPathLines()
        return true
    end
    
    -- Path yoksa normal yürüme
    hum.WalkSpeed = moveSpeed
    hum.AutoRotate = true
    
    local startTime = tick()
    while (hrp.Position - targetPos).Magnitude > 3.5 and tick() - startTime < 15 do
        if not autoFarmEnabled then break end
        
        char = LocalPlayer.Character
        if not char then return false end
        
        hrp = char:FindFirstChild("HumanoidRootPart")
        hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return false end
        
        local lookAt = (targetPos - hrp.Position).Unit
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(lookAt.X, 0, lookAt.Z))
        hum.MoveDirection = Vector3.new(lookAt.X, 0, lookAt.Z)
        
        wait()
    end
    
    hum.MoveDirection = Vector3.new()
    clearPathLines()
    
    return (hrp.Position - targetPos).Magnitude <= 3.5
end

local function farmMoveTo(pos, usePath, pathPoints)
    return moveToPosition(pos, usePath, pathPoints)
end

local function getNearestPointOnLine(A, B, P)
    local AB = B - A
    local t = (P - A):Dot(AB) / AB:Dot(AB)
    t = math.clamp(t, 0, 1)
    return A + AB * t
end

local function getNearestPointOnPath(points, pos)
    local nearest = points[1]
    local minDist = (points[1] - pos).Magnitude
    
    for i = 1, #points - 1 do
        local nearestOnSegment = getNearestPointOnLine(points[i], points[i + 1], pos)
        local dist = (nearestOnSegment - pos).Magnitude
        if dist < minDist then
            minDist = dist
            nearest = nearestOnSegment
        end
    end
    
    return nearest, minDist
end

local function followPath(points, targetReachedDist)
    local char = LocalPlayer.Character
    if not char then return false end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return false end
    
    hum.WalkSpeed = moveSpeed
    updatePathDrawing(points)
    
    local currentPos = hrp.Position
    local targetPoint = nil
    
    for i = 1, #points do
        if (points[i] - currentPos).Magnitude < 5 then
            if i < #points then
                targetPoint = points[i + 1]
            else
                clearPathLines()
                return true
            end
            break
        end
    end
    
    if not targetPoint then
        local nearestPoint, _ = getNearestPointOnPath(points, currentPos)
        targetPoint = nearestPoint
    end
    
    local startTime = tick()
    while (hrp.Position - targetPoint).Magnitude > targetReachedDist and tick() - startTime < 15 do
        if not autoFarmEnabled then break end
        
        char = LocalPlayer.Character
        if not char then break end
        
        hrp = char:FindFirstChild("HumanoidRootPart")
        hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then break end
        
        local lookAt = (targetPoint - hrp.Position).Unit
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(lookAt.X, 0, lookAt.Z))
        hum.MoveDirection = Vector3.new(lookAt.X, 0, lookAt.Z)
        
        wait()
    end
    
    hum.MoveDirection = Vector3.new()
    clearPathLines()
    
    return true
end

-- =============================================
-- DEALER BULMA (Criminality Shopz)
-- =============================================

local function farmFindDealer()
    local shops = Workspace.Map and Workspace.Map:FindFirstChild("Shopz")
    if not shops then
        shops = Workspace:FindFirstChild("Shopz")
    end
    if not shops then return nil end

    local char = LocalPlayer.Character
    if not char then return nil end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local nearest = nil
    local best = math.huge

    for _, shop in pairs(shops:GetChildren()) do
        local main = shop:FindFirstChild("MainPart")
        local stocks = shop:FindFirstChild("CurrentStocks")

        if main and stocks then
            if autoFarmMode == "Crowbar" then
                local cs = stocks:FindFirstChild("Crowbar")
                if cs and cs.Value > 0 then
                    local d = (main.Position - hrp.Position).Magnitude
                    if d < best then
                        best = d
                        nearest = shop
                    end
                end
            elseif autoFarmMode == "FistLockpick" then
                local lp = stocks:FindFirstChild("Lockpick")
                if lp and lp.Value > 0 then
                    local d = (main.Position - hrp.Position).Magnitude
                    if d < best then
                        best = d
                        nearest = shop
                    end
                end
            end
        end
    end
    
    return nearest
end

-- =============================================
-- SAFE/REGISTER BULMA (Sadece soyulmamış olanlar)
-- =============================================

local function farmFindTarget()
    local folder = Workspace.Map and Workspace.Map:FindFirstChild("BredMakurz")
    if not folder then
        folder = Workspace:FindFirstChild("BredMakurz")
    end
    if not folder then return nil end

    local char = LocalPlayer.Character
    if not char then return nil end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local nearest = nil
    local best = math.huge

    for _, obj in pairs(folder:GetChildren()) do
        local isSafe = string.find(obj.Name, "Safe")
        local isRegister = string.find(obj.Name, "Register")
        
        -- Sadece Safe veya Register nesnelerini hedef al
        if (isSafe or isRegister) and not table.find(farmIgnored, obj) then
            
            local values = obj:FindFirstChild("Values")
            if values then
                local broken = values:FindFirstChild("Broken")
                -- SADECE soyulmamış (açılmamış) safeleri hedef al
                if broken and broken:IsA("BoolValue") and not broken.Value then
                    
                    -- FistLockpick modu: Register'lara yumruk, Safe'lere lockpick
                    if autoFarmMode == "FistLockpick" then
                        if isSafe then
                            -- Safe için lockpick kontrolü
                            local hasLockpick = false
                            local charCheck = LocalPlayer.Character
                            if charCheck and charCheck:FindFirstChild("Lockpick") then
                                hasLockpick = true
                            else
                                local bp = LocalPlayer:FindFirstChild("Backpack")
                                if bp and bp:FindFirstChild("Lockpick") then
                                    hasLockpick = true
                                end
                            end
                            if not hasLockpick then
                                goto skip
                            end
                        end
                    end
                    
                    local tp = obj.PrimaryPart 
                        or obj:FindFirstChild("MainPart") 
                        or obj:FindFirstChildOfClass("BasePart")

                    if tp then
                        -- Path noktalarını al (yeşil çizgi için)
                        local pathFolder = obj:FindFirstChild("Path")
                        local pathPoints = {}
                        
                        if pathFolder then
                            local points = {}
                            for _, v in pairs(pathFolder:GetChildren()) do
                                if v:IsA("BasePart") then
                                    table.insert(points, v.Position)
                                end
                            end
                            table.sort(points, function(a, b) return (a - points[1]).Magnitude < (b - points[1]).Magnitude end)
                            pathPoints = points
                        else
                            pathPoints = {tp.Position}
                        end
                        
                        local d = (tp.Position - hrp.Position).Magnitude
                        if d < best then
                            best = d
                            nearest = obj
                            nearest.PathPoints = pathPoints
                        end
                    end
                end
            end
        end
        ::skip::
    end
    
    return nearest
end

-- =============================================
-- EŞYA KONTROL VE KUŞANMA
-- =============================================

local function farmHasTool(name)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild(name) then return true end
    
    local bp = LocalPlayer:FindFirstChild("Backpack")
    return bp and bp:FindFirstChild(name) ~= nil
end

local function farmEquipTool(name)
    local char = LocalPlayer.Character
    if not char then return false end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end

    local tool = char:FindFirstChild(name) or LocalPlayer.Backpack:FindFirstChild(name)
    if tool then
        pcall(function() hum:EquipTool(tool) end)
        wait(0.5)
        return true
    end
    
    return false
end

-- =============================================
-- FIST MODE: Yumrukla kasalara vurarak açma
-- =============================================

local function farmOpenWithFist(safe)
    local pathPoints = safe.PathPoints or {safe.MainPart.Position}
    
    -- Path ile git, olmazsa ışınlan
    if not farmMoveTo(pathPoints[1], true, pathPoints) then
        local tp = safe:FindFirstChild("MainPart") or safe.PrimaryPart
        if tp then
            farmMoveTo(tp.Position, false, nil)
        end
        return 
    end
    
    -- Path noktalarını takip et
    for i = 1, #pathPoints do
        if not followPath(pathPoints, 2) then
            break
        end
        wait(0.1)
    end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    -- Invisible ol
    ensureInvisible()
    
    local events = getEvents()
    if not events then return end
    
    local args = {
        [1] = "\240\159\141\158",  -- "🍞"
        [2] = tick(),
        [3] = "F.I.S.T",
        [4] = "43TRFWX",
        [5] = "Normal",
        [6] = tick(),
        [7] = true
    }
    
    local remote = events:FindFirstChild("XMHH.2")
    if remote then
        local result = remote:InvokeServer(unpack(args))
        if result then
            local handle = char:FindFirstChild("Right Arm")
            local sp = safe:FindFirstChild("MainPart")
            local remote2 = events:FindFirstChild("XMHH2.2")
            if remote2 and sp and handle then
                remote2:FireServer(
                    "\240\159\141\158",
                    tick(),
                    "F.I.S.T",
                    "2389ZFX34",
                    result,
                    false,
                    handle,
                    sp,
                    safe,
                    sp.Position,
                    sp.Position
                )
            end
        end
    end
    
    wait(3)
end

-- =============================================
-- LOCKPICK KONTROL VE SATIN ALMA
-- =============================================

local function farmHasLockpick()
    local char = LocalPlayer.Character
    if char then
        local count = 0
        for _, item in pairs(char:GetChildren()) do
            if item.Name == "Lockpick" then
                count = count + 1
            end
        end
        lockpickCount = count
        if count > 0 then return true end
    end
    
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        local count = 0
        for _, item in pairs(bp:GetChildren()) do
            if item.Name == "Lockpick" then
                count = count + 1
            end
        end
        lockpickCount = count
        return count > 0
    end
    
    lockpickCount = 0
    return false
end

local function farmEquipLockpick()
    local char = LocalPlayer.Character
    if not char then return false end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end

    local tool = char:FindFirstChild("Lockpick") or LocalPlayer.Backpack:FindFirstChild("Lockpick")
    if tool then
        pcall(function() hum:EquipTool(tool) end)
        wait(0.5)
        return true
    end
    
    return false
end

local function farmBuyLockpick(dealer)
    if not dealer then return false end

    local main = dealer:FindFirstChild("MainPart")
    if not main then return false end

    -- Dealer'a git (yeşil çizgi ile)
    if not farmMoveTo(main.Position, true, {main.Position}) then
        farmMoveTo(main.Position, false, nil)
    end
    
    wait(1)

    local events = getEvents()
    if not events then return false end
    
    local be = events:FindFirstChild("BYZERSPROTEC")
    local se = events:FindFirstChild("SSHPRMTE1")
    
    if not be or not se then return false end

    -- Dealer'a gir
    be:FireServer(true, "shop", main, "IllegalStore")
    wait(1)
    
    -- 8 lockpick al (Criminality'de max 8)
    for i = 1, maxLockpickCount do
        se:InvokeServer("IllegalStore", "Tools", "Lockpick", main, nil, true)
        wait(0.2)
    end
    
    wait(2)
    be:FireServer(false)

    lockpickCount = maxLockpickCount
    return farmHasLockpick()
end

-- =============================================
-- LOCKPICK MODE: Lockpick ile büyük safeleri açma
-- =============================================

local function farmOpenWithLockpick(safe)
    local pathPoints = safe.PathPoints or {safe.MainPart.Position}
    
    -- Path ile git, olmazsa ışınlan
    if not farmMoveTo(pathPoints[1], true, pathPoints) then
        local tp = safe:FindFirstChild("MainPart") or safe.PrimaryPart
        if tp then
            farmMoveTo(tp.Position, false, nil)
        end
        return 
    end
    
    -- Path noktalarını takip et
    for i = 1, #pathPoints do
        if not followPath(pathPoints, 2) then
            break
        end
        wait(0.1)
    end
    
    -- Lockpick yoksa dealer'dan al
    if not farmHasLockpick() then
        local dealer = farmFindDealer()
        if dealer then
            farmBuyLockpick(dealer)
        end
        return
    end
    
    if not farmEquipLockpick() then return end

    -- Invisible ol
    ensureInvisible()
    
    local events = getEvents()
    if not events then return end
    
    local r1 = events:FindFirstChild("XMHH.2")
    local r2 = events:FindFirstChild("XMHH2.2")
    local sp = safe:FindFirstChild("MainPart")

    if not r1 or not r2 or not sp then return end

    local eq = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Lockpick")
    if not eq then return end

    local st = tick()
    
    while safe and safe.Parent 
        and safe.Values 
        and safe.Values:FindFirstChild("Broken") 
        and not safe.Values.Broken.Value 
        and (tick() - st < 20) do
        
        local char = LocalPlayer.Character
        if not char then break end

        local res = r1:InvokeServer(
            "\240\159\141\158",
            tick(),
            eq,
            "DZDRRRKI",
            safe,
            "Register"
        )

        if res then
            r2:FireServer(
                "\240\159\141\158",
                tick(),
                eq,
                "2389ZFX34",
                res,
                false,
                char["Right Arm"],
                sp,
                safe,
                sp.Position,
                sp.Position
            )
            
            -- Lockpick kullanıldı, sayacı azalt
            lockpickCount = lockpickCount - 1
        end
        
        wait(0.2)
    end
    
    wait(8)
end

-- =============================================
-- CROWBAR SATIN ALMA
-- =============================================

local function farmBuyCrowbar(dealer)
    if not dealer then return false end

    local main = dealer:FindFirstChild("MainPart")
    if not main then return false end

    -- Dealer'a git (yeşil çizgi ile)
    if not farmMoveTo(main.Position, true, {main.Position}) then
        farmMoveTo(main.Position, false, nil)
    end
    
    wait(1)

    local events = getEvents()
    if not events then return false end
    
    local be = events:FindFirstChild("BYZERSPROTEC")
    local se = events:FindFirstChild("SSHPRMTE1")
    
    if not be or not se then return false end

    be:FireServer(true, "shop", main, "IllegalStore")
    wait(1)
    se:InvokeServer("IllegalStore", "Melees", "Crowbar", main, nil, true)
    wait(2)
    be:FireServer(false)

    return farmHasTool("Crowbar")
end

-- =============================================
-- CROWBAR MODE: Crowbar ile her şeyi açma
-- =============================================

local function farmOpenWithCrowbar(safe)
    local pathPoints = safe.PathPoints or {safe.MainPart.Position}
    
    -- Path ile git, olmazsa ışınlan
    if not farmMoveTo(pathPoints[1], true, pathPoints) then
        local tp = safe:FindFirstChild("MainPart") or safe.PrimaryPart
        if tp then
            farmMoveTo(tp.Position, false, nil)
        end
        return 
    end
    
    -- Path noktalarını takip et
    for i = 1, #pathPoints do
        if not followPath(pathPoints, 2) then
            break
        end
        wait(0.1)
    end
    
    -- Crowbar yoksa yumrukla dene
    if not farmHasTool("Crowbar") then
        farmOpenWithFist(safe)
        return
    end
    
    if not farmEquipTool("Crowbar") then return end

    -- Invisible ol
    ensureInvisible()
    
    local events = getEvents()
    if not events then return end
    
    local r1 = events:FindFirstChild("XMHH.2")
    local r2 = events:FindFirstChild("XMHH2.2")
    local sp = safe:FindFirstChild("MainPart")

    if not r1 or not r2 or not sp then return end

    local eq = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Crowbar")
    if not eq then return end

    local st = tick()
    
    while safe and safe.Parent 
        and safe.Values 
        and safe.Values:FindFirstChild("Broken") 
        and not safe.Values.Broken.Value 
        and (tick() - st < 20) do
        
        local char = LocalPlayer.Character
        if not char then break end

        local res = r1:InvokeServer(
            "\240\159\141\158",
            tick(),
            eq,
            "DZDRRRKI",
            safe,
            "Register"
        )

        if res then
            r2:FireServer(
                "\240\159\141\158",
                tick(),
                eq,
                "2389ZFX34",
                res,
                false,
                char["Right Arm"],
                sp,
                safe,
                sp.Position,
                sp.Position
            )
        end
        
        wait(0.2)
    end
    
    wait(8)
end

-- =============================================
-- ATM BULMA VE PARA YATIRMA (Criminality)
-- =============================================

local function findNearestATM()
    local char = LocalPlayer.Character
    if not char then return nil end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    -- Criminality'de ATM'ler genellikle bu klasörlerde olur
    local atmFolders = {
        Workspace.Map and Workspace.Map:FindFirstChild("ATMs"),
        Workspace:FindFirstChild("ATMs"),
        Workspace:FindFirstChild("ATM"),
        Workspace:FindFirstChild("Bank"),
        Workspace:FindFirstChild("Banks")
    }
    
    local nearestATM = nil
    local bestDist = math.huge
    
    for _, folder in pairs(atmFolders) do
        if folder then
            for _, obj in pairs(folder:GetChildren()) do
                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildOfClass("BasePart")
                if part then
                    local dist = (part.Position - hrp.Position).Magnitude
                    if dist < bestDist then
                        bestDist = dist
                        nearestATM = part
                    end
                end
            end
        end
    end
    
    -- Eğer ATM bulunamazsa, bilinen ATM koordinatlarını dene (Criminality haritasına göre)
    if not nearestATM then
        local knownATMs = {
            Vector3.new(0, 3, 0),  -- Ana spawn yakını
            -- Criminality haritasına göre diğer ATM konumları eklenebilir
        }
        
        for _, pos in pairs(knownATMs) do
            local dist = (pos - hrp.Position).Magnitude
            if dist < bestDist then
                bestDist = dist
                nearestATM = {Position = pos, IsVirtual = true}
            end
        end
    end
    
    return nearestATM
end

local function depositToATM()
    local atm = findNearestATM()
    if not atm then return false end
    
    local atmPos = atm.IsVirtual and atm.Position or atm.Position
    
    -- ATM'ye git (yeşil çizgi ile)
    if not farmMoveTo(atmPos, true, {atmPos}) then
        farmMoveTo(atmPos, false, nil)
    end
    
    wait(1)
    
    -- Criminality'de ATM'ye para yatırma event'i
    local events = getEvents()
    if events then
        -- Farklı event isimlerini dene
        local depositEvents = {
            events:FindFirstChild("DepositMoney"),
            events:FindFirstChild("ATMDeposit"),
            events:FindFirstChild("BankDeposit"),
            events:FindFirstChild("AllowanceDeposit"),
            events:FindFirstChild("WithdrawDeposit")
        }
        
        for _, depositEvent in pairs(depositEvents) do
            if depositEvent then
                pcall(function()
                    if depositEvent.ClassName == "RemoteEvent" then
                        depositEvent:FireServer()
                    elseif depositEvent.ClassName == "RemoteFunction" then
                        depositEvent:InvokeServer()
                    end
                end)
                wait(0.5)
            end
        end
    end
    
    -- Alternatif: TouchInterest ile ATM'ye dokun
    local character = LocalPlayer.Character
    if character and atm and not atm.IsVirtual then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local touch = Instance.new("TouchInterest")
            touch.Parent = hrp
            wait(0.5)
            touch:Destroy()
        end
    end
    
    wait(2)
    
    -- Allowance'ı sıfırla
    currentAllowance = 0
    updateAllowanceUI()
    lastDepositTime = tick()
    
    return true
end

-- =============================================
-- ALLOWANCE TAKİBİ
-- =============================================

local function checkAllowanceAndDeposit()
    if not allowanceTrackingEnabled then return end
    if not autoFarmEnabled then return end
    
    -- Gerçek allowance değerini oku
    local realAllowance = getCurrentAllowance()
    if realAllowance and realAllowance > 0 then
        currentAllowance = realAllowance
        updateAllowanceUI()
    end
    
    if currentAllowance >= allowanceLimit then
        depositToATM()
    end
end

-- Para kazanıldığında allowance'ı arttır (Criminality'de safe açınca yaklaşık 500-2000$ kazanılıyor)
local function onMoneyEarned(amount)
    if not allowanceTrackingEnabled then return end
    
    currentAllowance = currentAllowance + amount
    updateAllowanceUI()
    
    if currentAllowance >= allowanceLimit then
        depositToATM()
    end
end

-- =============================================
-- ANA FARM LOOP
-- =============================================

local function farmLoop()
    while autoFarmEnabled do
        wait(1)

        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        -- Ölünce respawn ol ve invisible ol
        if not char or not hum or hum.Health <= 0 then
            respawnAndGoInvisible()
            wait(3)
            farmIgnored = {}
            goto continue
        end

        -- Her loop'ta invisible olduğundan emin ol
        ensureInvisible()
        
        hum.WalkSpeed = moveSpeed
        hum.JumpPower = 50
        hum.AutoRotate = true

        -- Crowbar mode için crowbar kontrolü
        if autoFarmMode == "Crowbar" and not farmHasTool("Crowbar") then
            local dealer = farmFindDealer()
            if dealer then
                farmBuyCrowbar(dealer)
            else
                wait(5)
            end
            goto continue
        end
        
        -- FistLockpick mode için lockpick kontrolü (sadece lockpick sayısını güncelle)
        if autoFarmMode == "FistLockpick" then
            farmHasLockpick()
        end

        -- En yakın soyulmamış safe/register'ı bul
        local target = farmFindTarget()
        if target then
            local mp = target:FindFirstChild("MainPart") or target.PrimaryPart
            if mp then
                -- Hedefe git (yeşil çizgi ile)
                if farmMoveTo(mp.Position, true, target.PathPoints) then
                    wait(1)
                    
                    -- Mode'a göre açma işlemini yap
                    if autoFarmMode == "Crowbar" then
                        farmOpenWithCrowbar(target)
                    elseif autoFarmMode == "FistLockpick" then
                        local isSafe = string.find(target.Name, "Safe")
                        if isSafe then
                            farmOpenWithLockpick(target)
                        else
                            farmOpenWithFist(target)
                        end
                    end
                    
                    -- Safe/Register açıldı, para kazanıldı (Criminality'de safe açınca 500-2000$)
                    if allowanceTrackingEnabled then
                        -- Safe ise daha fazla para, Register ise daha az
                        local isSafe = string.find(target.Name, "Safe")
                        local earned = isSafe and 1500 or 500
                        onMoneyEarned(earned)
                    end
                else
                    -- Gidilemedi, ignore listesine ekle
                    table.insert(farmIgnored, target)
                    wait(0.5)
                end
            end
        else
            -- Hedef yoksa ignore listesini temizle ve bekle
            farmIgnored = {}
            wait(5)
        end
        
        -- Allowance kontrol et ve gerekiyorsa ATM'ye para yatır
        if allowanceTrackingEnabled then
            checkAllowanceAndDeposit()
        end

        ::continue::
    end
end

-- =============================================
-- AUTO FARM KONTROL FONKSİYONLARI
-- =============================================

function AutoFarm_Enable()
    if autoFarmEnabled then return end
    
    autoFarmEnabled = true
    farmIgnored = {}
    
    -- Invisibility durumunu hatırla
    if _G.IsInvisEnabled then
        wasInvisibleBeforeFarm = _G.IsInvisEnabled()
    end
    
    -- Invisible ol
    ensureInvisible()

    if autoFarmCoroutine then
        task.cancel(autoFarmCoroutine)
        autoFarmCoroutine = nil
    end

    autoFarmCoroutine = task.spawn(farmLoop)

    -- Karakter değiştiğinde tekrar invisible ol
    LocalPlayer.CharacterAdded:Connect(function()
        if autoFarmEnabled then
            wait(2)
            ensureInvisible()
        end
    end)
end

function AutoFarm_Disable()
    autoFarmEnabled = false
    
    if autoFarmCoroutine then
        task.cancel(autoFarmCoroutine)
        autoFarmCoroutine = nil
    end
    
    farmIgnored = {}
    clearPathLines()
    
    -- Invisibility'i eski haline döndür
    if not wasInvisibleBeforeFarm then
        if _G.Invis_Disable then
            _G.Invis_Disable()
        end
    end
end

function AutoFarm_SetMode(mode)
    if mode == "Crowbar" or mode == "FistLockpick" then
        autoFarmMode = mode
    end
end

function AutoFarm_GetMode()
    return autoFarmMode
end

function AutoFarm_SetSpeed(speed)
    moveSpeed = math.clamp(speed, 1, 50)
    if speedValueLabel then
        speedValueLabel.Text = tostring(moveSpeed)
    end
end

function AutoFarm_GetSpeed()
    return moveSpeed
end

function AutoFarm_SetDepositLimit(limit)
    depositLimit = math.clamp(limit, 1000, 50000)
    allowanceLimit = depositLimit
    if depositValueLabel then
        depositValueLabel.Text = string.format("%.0f$", depositLimit)
    end
    updateAllowanceUI()
end

function AutoFarm_GetDepositLimit()
    return depositLimit
end

function AllowanceTracking_Enable()
    if allowanceTrackingEnabled then return end
    
    allowanceTrackingEnabled = true
    
    -- Mevcut allowance değerini oku
    currentAllowance = getCurrentAllowance()
    
    -- Allowance UI'yı oluştur (sol tarafta görünecek)
    local screenGui = LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("SantesHubScreenGui")
    if screenGui then
        local mainFrame = screenGui:FindFirstChild("MainFrame")
        if mainFrame then
            -- Allowance Frame'i oluştur
            allowanceUI = Instance.new("Frame")
            allowanceUI.Name = "AllowanceFrame"
            allowanceUI.Size = UDim2.new(0, 180, 0, 30)
            allowanceUI.Position = UDim2.new(0, 10, 1, -40)
            allowanceUI.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
            allowanceUI.BorderSizePixel = 0
            allowanceUI.Parent = mainFrame
            
            local uiCorner = Instance.new("UICorner")
            uiCorner.CornerRadius = UDim.new(0, 6)
            uiCorner.Parent = allowanceUI
            
            local textLabel = Instance.new("TextLabel")
            textLabel.Name = "TextLabel"
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = string.format("ALLOWANCE: $%d / $%d", currentAllowance, allowanceLimit)
            textLabel.TextColor3 = Theme.Accent
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextSize = 11
            textLabel.Parent = allowanceUI
        end
    end
    
    updateAllowanceUI()
end

function AllowanceTracking_Disable()
    allowanceTrackingEnabled = false
    
    if allowanceUI then
        allowanceUI:Destroy()
        allowanceUI = nil
    end
end

function AllowanceTracking_IsEnabled()
    return allowanceTrackingEnabled
end

-- =============================================
-- UI SLIDER'LAR (Hareket Hızı ve Para Limiti)
-- =============================================

function CreateSpeedSlider(parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -12, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 0.4, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "Hareket Hızı:"
    label.TextColor3 = Theme.TextSecondary
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    speedValueLabel = Instance.new("TextLabel")
    speedValueLabel.Size = UDim2.new(0.2, 0, 0.4, 0)
    speedValueLabel.Position = UDim2.new(0.8, 0, 0, 0)
    speedValueLabel.BackgroundTransparency = 1
    speedValueLabel.Text = tostring(moveSpeed)
    speedValueLabel.TextColor3 = Theme.Accent
    speedValueLabel.Font = Enum.Font.GothamBold
    speedValueLabel.TextSize = 11
    speedValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    speedValueLabel.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0.3, 0)
    slider.Position = UDim2.new(0, 0, 0.5, 0)
    slider.BackgroundColor3 = Theme.ButtonOff
    slider.BorderSizePixel = 0
    slider.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = slider
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((moveSpeed - 1) / 49, 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 12, 0, 12)
    button.Position = UDim2.new((moveSpeed - 1) / 49, -6, 0.5, -6)
    button.BackgroundColor3 = Theme.TextPrimary
    button.BorderSizePixel = 0
    button.Text = ""
    button.Parent = slider
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    local dragging = false
    button.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local percent = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            moveSpeed = math.floor(1 + percent * 49)
            speedValueLabel.Text = tostring(moveSpeed)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            button.Position = UDim2.new(percent, -6, 0.5, -6)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local percent = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            moveSpeed = math.floor(1 + percent * 49)
            speedValueLabel.Text = tostring(moveSpeed)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            button.Position = UDim2.new(percent, -6, 0.5, -6)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return frame
end

function CreateDepositSlider(parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -12, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 0.4, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "Para Yatırma Limiti:"
    label.TextColor3 = Theme.TextSecondary
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    depositValueLabel = Instance.new("TextLabel")
    depositValueLabel.Size = UDim2.new(0.2, 0, 0.4, 0)
    depositValueLabel.Position = UDim2.new(0.8, 0, 0, 0)
    depositValueLabel.BackgroundTransparency = 1
    depositValueLabel.Text = string.format("%.0f$", depositLimit)
    depositValueLabel.TextColor3 = Theme.Accent
    depositValueLabel.Font = Enum.Font.GothamBold
    depositValueLabel.TextSize = 11
    depositValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    depositValueLabel.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0.3, 0)
    slider.Position = UDim2.new(0, 0, 0.5, 0)
    slider.BackgroundColor3 = Theme.ButtonOff
    slider.BorderSizePixel = 0
    slider.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = slider
    
    local minVal = 1000
    local maxVal = 50000
    local percent = (depositLimit - minVal) / (maxVal - minVal)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(percent, 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 12, 0, 12)
    button.Position = UDim2.new(percent, -6, 0.5, -6)
    button.BackgroundColor3 = Theme.TextPrimary
    button.BorderSizePixel = 0
    button.Text = ""
    button.Parent = slider
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    local dragging = false
    button.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local percent = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            depositLimit = math.floor(minVal + percent * (maxVal - minVal))
            allowanceLimit = depositLimit
            depositValueLabel.Text = string.format("%.0f$", depositLimit)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            button.Position = UDim2.new(percent, -6, 0.5, -6)
            updateAllowanceUI()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local percent = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            depositLimit = math.floor(minVal + percent * (maxVal - minVal))
            allowanceLimit = depositLimit
            depositValueLabel.Text = string.format("%.0f$", depositLimit)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            button.Position = UDim2.new(percent, -6, 0.5, -6)
            updateAllowanceUI()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return frame
end

-- #####################################################################
-- #                   UI CATEGORIES                                   #
-- #####################################################################

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
        TweenService:Create(ActiveCat, TweenInfo.new(0.15), {
            BackgroundColor3 = Theme.CategoryOff
        }):Play()
        
        if ActiveCat.TextLabel then
            ActiveCat.TextLabel.TextColor3 = Theme.TextSecondary
        end
    end

    TweenService:Create(btn, TweenInfo.new(0.15), {
        BackgroundColor3 = Theme.CategoryOn
    }):Play()
    
    if btn.TextLabel then
        btn.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    ActiveCat = btn

    for _, child in pairs(contentFrame:GetChildren()) do
        if child:IsA("Frame") then
            child.Parent = nil
        end
    end

    if CatFrames[name] then
        for i, frame in pairs(CatFrames[name]) do
            frame.Parent = contentFrame
            frame.LayoutOrder = i
        end
        
        local count = #CatFrames[name]
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, 
            count * 38 + (count > 0 and (count - 1) * 6 or 0) + 10
        )
    end
end

for i, cat in pairs(Categories) do
    local btn = Instance.new("TextButton")
    btn.Name = cat
    btn.Size = UDim2.new(1, -8, 0, 28)
    btn.BackgroundColor3 = Theme.CategoryOff
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.LayoutOrder = i
    btn.Parent = sidebarFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn

    local btnLabel = Instance.new("TextLabel")
    btnLabel.Name = "TextLabel"
    btnLabel.Size = UDim2.new(1, 0, 1, 0)
    btnLabel.BackgroundTransparency = 1
    btnLabel.Text = cat
    btnLabel.Font = Enum.Font.GothamSemibold
    btnLabel.TextSize = 12
    btnLabel.TextColor3 = Theme.TextSecondary
    btnLabel.Parent = btn

    btn.MouseButton1Click:Connect(function()
        SwitchCategory(cat)
    end)

    CatButtons[cat] = btn
end

-- #####################################################################
-- #                 POPULATE CATEGORIES                               #
-- #####################################################################

table.insert(CatFrames.Combat, createToggleRow(
    "Silent Aim", true,
    function() return silentAimEnabled end,
    SilentAim_Enable, SilentAim_Disable,
    function() return KB.sa end,
    function(v) KB.sa = v end
))

table.insert(CatFrames.Combat, createToggleRow(
    "Melee Aura", true,
    function() return meleeAuraEnabled end,
    MeleeAura_Enable, MeleeAura_Disable,
    function() return KB.ma end,
    function(v) KB.ma = v end
))

table.insert(CatFrames.Combat, createToggleRow(
    "No Recoil", true,
    function() return noRecoilEnabled end,
    NoRecoil_Enable, NoRecoil_Disable,
    function() return KB.nr end,
    function(v) KB.nr = v end
))

table.insert(CatFrames.Movement, createToggleRow(
    "Fly", true,
    function() return flyEnabled end,
    Fly_Enable, Fly_Disable,
    function() return KB.fly end,
    function(v) KB.fly = v end
))

table.insert(CatFrames.Movement, createToggleRow(
    "Noclip", true,
    function() return noclipEnabled end,
    Noclip_Enable, Noclip_Disable,
    function() return KB.nc end,
    function(v) KB.nc = v end
))

table.insert(CatFrames.Movement, createToggleRow(
    "Inf Stamina", true,
    function() return infStaminaEnabled end,
    InfiniteStamina_Enable, InfiniteStamina_Disable,
    function() return KB.is end,
    function(v) KB.is = v end
))

table.insert(CatFrames.Movement, createToggleRow(
    "Invisibility", true,
    _G.IsInvisEnabled, _G.Invis_Enable, _G.Invis_Disable,
    function() return KB.inv end,
    function(v) KB.inv = v end
))

table.insert(CatFrames.Visuals, createToggleRow(
    "Player ESP", true,
    function() return espEnabled end,
    ESP_Enable, ESP_Disable,
    function() return KB.esp end,
    function(v) KB.esp = v end
))

table.insert(CatFrames.Visuals, createToggleRow(
    "Safe ESP", true,
    function() return safeESPEnabled end,
    SafeESP_Enable, SafeESP_Disable,
    function() return KB.se end,
    function(v) KB.se = v end
))

table.insert(CatFrames.Visuals, createToggleRow(
    "FullBright", true,
    function() return fullbrightEnabled end,
    FullBright_Enable, FullBright_Disable,
    function() return KB.fb end,
    function(v) KB.fb = v end
))

table.insert(CatFrames.Visuals, createToggleRow(
    "FOV", true,
    function() return fovEnabled end,
    FOV_Enable, FOV_Disable,
    function() return KB.fv end,
    function(v) KB.fv = v end
))

table.insert(CatFrames.Farming, createToggleRow(
    "Auto Farm", true,
    function() return autoFarmEnabled end,
    AutoFarm_Enable, AutoFarm_Disable,
    function() return KB.af end,
    function(v) KB.af = v end
))

table.insert(CatFrames.Farming, createToggleRow(
    "Auto Pickup $", true,
    function() return autoPickupEnabled end,
    AutoPickup_Enable, AutoPickup_Disable,
    function() return KB.ap end,
    function(v) KB.ap = v end
))

table.insert(CatFrames.Farming, createToggleRow(
    "No Fail Lockpick", true,
    function() return noFailLPEnabled end,
    NoFailLP_Enable, NoFailLP_Disable,
    function() return KB.lp end,
    function(v) KB.lp = v end
))

table.insert(CatFrames.Farming, createToggleRow(
    "Auto Lockpick", true,
    function() return autoLockpickEnabled end,
    AutoLockpick_Enable, AutoLockpick_Disable,
    function() return KB.al end,
    function(v) KB.al = v end
))

table.insert(CatFrames.Misc, createToggleRow(
    "Admin Detector", true,
    function() return adminCheckEnabled end,
    AdminCheck_Enable, AdminCheck_Disable,
    function() return KB.ad end,
    function(v) KB.ad = v end
))

table.insert(CatFrames.Misc, createToggleRow(
    "Auto Unlock Doors", true,
    function() return unlockDoorsEnabled end,
    UnlockDoors_Enable, UnlockDoors_Disable,
    function() return KB.ud end,
    function(v) KB.ud = v end
))

-- #####################################################################
-- #                 KEYBIND HANDLER                                   #
-- #####################################################################

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if currentRowWaitingForKey 
        and input.KeyCode ~= Enum.KeyCode.Unknown 
        and input.KeyCode ~= Enum.KeyCode.K then
        
        local frame = currentRowWaitingForKey
        local bb = bindButtonRefs[frame]
        local gf = keyBindGetters[frame]
        local sf = keyBindSetters[frame]
        local fd = rowFuncData[frame]

        if bb and gf and sf and fd then
            local ok = nil
            local s, r = pcall(gf)
            if s then ok = r end

            if ok and activeBinds[ok] then activeBinds[ok] = nil end

            if activeBinds[input.KeyCode] then
                local of = activeBinds[input.KeyCode].frame
                local ob = bindButtonRefs[of]
                local os2 = keyBindSetters[of]
                if os2 then pcall(os2, nil) end
                if ob then ob.Text = "Bind" end
                activeBinds[input.KeyCode] = nil
            end

            pcall(sf, input.KeyCode)
            bb.Text = "[" .. input.KeyCode.Name .. "]"

            local tgb = nil
            for _, child in pairs(frame:GetChildren()) do
                if child:IsA("TextButton") and child ~= bb then
                    tgb = child
                    break
                end
            end

            if tgb then
                activeBinds[input.KeyCode] = {
                    frame = frame,
                    toggleButton = tgb,
                    isEnabledFn = fd.isEnabledFn,
                    onEnable = fd.onEnable,
                    onDisable = fd.onDisable,
                    canToggle = fd.canToggle,
                    updateFn = fd.updateFn
                }
            end

            currentRowWaitingForKey = nil
        end
    elseif activeBinds[input.KeyCode] then
        local info = activeBinds[input.KeyCode]
        
        if info.canToggle 
            and info.onEnable 
            and info.onDisable 
            and info.isEnabledFn 
            and info.updateFn then
            
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

-- #####################################################################
-- #                   INITIALIZATION                                  #
-- #####################################################################

SwitchCategory("Combat")

mainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(
    mainFrame,
    TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {Size = UDim2.new(0, 440, 0, 360)}
):Play()

print("================================================")
print("  SANTES HUB v5.3 Yuklendi!")
print("================================================")
