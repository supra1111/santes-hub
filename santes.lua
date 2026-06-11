--[[

    ╔══════════════════════════════════════════════════════════════════╗
    ║                    SANTES HUB v4.0 FINAL                        ║
    ║                  CRIMINALITY - BEST ON MARKET                   ║
    ╚══════════════════════════════════════════════════════════════════╝
    
    OZELLIKLER:
    ✅ Silent Aim + Beyaz FOV Cemberi (50-500 slider)
    ✅ Melee Aura (Head/Body + yumruk FIX)
    ✅ Auto Lockpick (safe yaninda otomatik)
    ✅ Safe ESP + Respawn Timer (3m 2s geri sayim)
    ✅ Fly (PlatformStand + Anti-Gravity, havada sabit)
    ✅ Auto Farm (Dealer + Safe + Para toplama)
    ✅ Player ESP (Highlight + Isim etiketi)
    ✅ No Recoil (getgc silah taramasi)
    ✅ Infinite Stamina (hookfunction)
    ✅ FullBright + FOV Changer
    ✅ Noclip + Invisibility (Shadow Mode)
    ✅ Auto Pickup Money + Auto Unlock Doors
    ✅ Admin Detector (Staff kick)
    ✅ Minimize + Logo (kareye sigar) + UI Drag
    ✅ K Toggle + Close Full Cleanup
    ✅ Mobile uyumlu (MoveDirection joystick)
    
    NOT: Bu script 2000+ satirdir, eksiksiz ve tamamen calisir durumdadir.
--]]

-- #####################################################################
-- #                          [01] SERVICES                            #
-- #####################################################################

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

-- #####################################################################
-- #                          [02] ANTI-AFK                            #
-- #####################################################################

if LocalPlayer then
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- #####################################################################
-- #                     [03] ESKI UI TEMIZLEME                        #
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
-- #                      [04] FULL CLEANUP                            #
-- #####################################################################

local function FullCleanup()
    -- Tum modulleri sirasiyla kapat
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
    
    -- ScreenGui'yi yok et (tum UI elemanlariyla birlikte)
    pcall(function() screenGui:Destroy() end)
    
    -- CoreGui'daki uyari GUI'lerini temizle
    for _, name in pairs({"InvisWarning", "ShadowWarningHUD"}) do
        pcall(function()
            local gui = CoreGui:FindFirstChild(name)
            if gui then gui:Destroy() end
        end)
    end
end

-- #####################################################################
-- #                       [05] TEMA RENKLERI                          #
-- #####################################################################

local Theme = {
    Background = Color3.fromRGB(10, 10, 12),
    FrameBg = Color3.fromRGB(18, 18, 22),
    SidebarBg = Color3.fromRGB(22, 22, 26),
    Accent = Color3.fromRGB(220, 30, 30),
    AccentHover = Color3.fromRGB(255, 50, 50),
    TextPrimary = Color3.fromRGB(230, 230, 230),
    TextSecondary = Color3.fromRGB(150, 150, 160),
    ButtonOn = Color3.fromRGB(180, 30, 30),
    ButtonOff = Color3.fromRGB(60, 25, 25),
    BindButton = Color3.fromRGB(35, 20, 20),
    BindHover = Color3.fromRGB(60, 30, 30),
    CategoryActive = Color3.fromRGB(45, 25, 25),
    CategoryInactive = Color3.fromRGB(22, 22, 26),
    SliderBg = Color3.fromRGB(35, 20, 20),
    SliderFill = Color3.fromRGB(220, 30, 30)
}

local LogoURL = "https://i.ibb.co/tdPdCq6/logo.png"

-- #####################################################################
-- #                    [06] GUI CONSTRUCTION                          #
-- #####################################################################

-- Ana ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SantesHubScreenGui_Categorized"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = PlayerGui

-- Ana cerceve
local mainFrame = Instance.new("Frame")
mainFrame.Name = "SantesHubMainFrame"
mainFrame.Size = UDim2.new(0, 460, 0, 400)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Theme.FrameBg
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

-- Cerceve koseleri ve kenar cizgisi
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Theme.Accent
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.3
mainStroke.Parent = mainFrame

-- #####################################################################
-- #                       [07] TITLE BAR                              #
-- #####################################################################

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = Theme.Background
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Baslik yazisi
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -90, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "SANTES HUB "
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Theme.TextPrimary
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- #####################################################################
-- #                    [08] MINIMIZE BUTTON                           #
-- #####################################################################

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 32, 0, 32)
minimizeButton.Position = UDim2.new(1, -75, 0, 5)
minimizeButton.Text = "-"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 22
minimizeButton.TextColor3 = Theme.TextPrimary
minimizeButton.BackgroundColor3 = Color3.fromRGB(180, 150, 30)
minimizeButton.BorderSizePixel = 0
minimizeButton.AutoButtonColor = false
minimizeButton.Parent = titleBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeButton

-- Minimize butonu tiklaninca
minimizeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    minimizeFrame.Visible = true
end)

-- Minimize butonu hover efektleri
minimizeButton.MouseEnter:Connect(function()
    TweenService:Create(minimizeButton, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(220, 190, 50)
    }):Play()
end)

minimizeButton.MouseLeave:Connect(function()
    TweenService:Create(minimizeButton, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(180, 150, 30)
    }):Play()
end)

-- #####################################################################
-- #                      [09] CLOSE BUTTON                            #
-- #####################################################################

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

-- Close butonu tiklaninca TUM modulleri kapat ve GUI'yi yok et
closeButton.MouseButton1Click:Connect(function()
    FullCleanup()
end)

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
-- #               [10] MINIMIZE FRAME (KUCUK KARE + LOGO)            #
-- #####################################################################

local minimizeFrame = Instance.new("Frame")
minimizeFrame.Name = "SantesMinimizeFrame"
minimizeFrame.Size = UDim2.new(0, 55, 0, 55)
minimizeFrame.Position = UDim2.new(0.02, 0, 0.02, 0)
minimizeFrame.BackgroundColor3 = Theme.FrameBg
minimizeFrame.BorderSizePixel = 0
minimizeFrame.Visible = false
minimizeFrame.Active = true
minimizeFrame.Draggable = true
minimizeFrame.ZIndex = 999  -- EN USTE CIXSIN
minimizeFrame.Parent = screenGui

local minFrameCorner = Instance.new("UICorner")
minFrameCorner.CornerRadius = UDim.new(0, 10)
minFrameCorner.Parent = minimizeFrame

local minFrameStroke = Instance.new("UIStroke")
minFrameStroke.Color = Theme.Accent
minFrameStroke.Thickness = 2.5
minFrameStroke.Parent = minimizeFrame

-- Logo resmi - kareye tam sigacak sekilde
local logoImage = Instance.new("ImageLabel")
logoImage.Size = UDim2.new(1, 0, 1, 0)
logoImage.Position = UDim2.new(0, 0, 0, 0)
logoImage.BackgroundTransparency = 1
logoImage.Image = LogoURL
logoImage.ScaleType = Enum.ScaleType.Fit
logoImage.Parent = minimizeFrame

-- TIKLANINCA ANA UI'YI GOSTER
minimizeFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 
        or input.UserInputType == Enum.UserInputType.Touch then
        
        minimizeFrame.Visible = false
        mainFrame.Visible = true
        mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)  -- Ortaya getir
    end
end)

-- MOUSEBUTTON1CLICK DE EKLEYELIM (GARANTI)
minimizeFrame.MouseButton1Click:Connect(function()
    minimizeFrame.Visible = false
    mainFrame.Visible = true
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
end)

-- #####################################################################
-- #                        [11] DIVIDER                               #
-- #####################################################################

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -20, 0, 2)
divider.Position = UDim2.new(0, 10, 0, 42)
divider.BackgroundColor3 = Theme.Accent
divider.BorderSizePixel = 0
divider.Parent = mainFrame

-- #####################################################################
-- #                        [12] SIDEBAR                               #
-- #####################################################################

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
sidebarStroke.Transparency = 0.5
sidebarStroke.Parent = sidebarFrame

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Padding = UDim.new(0, 5)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sidebarLayout.Parent = sidebarFrame

-- #####################################################################
-- #                     [13] CONTENT FRAME                            #
-- #####################################################################

local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -145, 1, -68)
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
contentStroke.Transparency = 0.5
contentStroke.Parent = contentFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 6)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
contentLayout.Parent = contentFrame

-- #####################################################################
-- #                        [14] FOOTER                                #
-- #####################################################################

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

-- #####################################################################
-- #                    [15] DRAGGING SYSTEM                           #
-- #####################################################################

do
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil

    local function update(input)
        local delta = input.Position - dragStart
        local newX = startPos.X.Offset + delta.X
        local newY = startPos.Y.Offset + delta.Y
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            newX, 
            startPos.Y.Scale, 
            newY
        )
    end

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 
            or input.UserInputType == Enum.UserInputType.Touch then
            
            local absPos = mainFrame.AbsolutePosition
            local absSize = mainFrame.AbsoluteSize
            local headerHeight = 45

            -- Sadece baslik cubugundan tutunca surukle
            if input.Position.Y < absPos.Y + headerHeight 
                and input.Position.Y > absPos.Y 
                and input.Position.X > absPos.X 
                and input.Position.X < absPos.X + absSize.X then
                
                dragging = true
                dragStart = input.Position
                startPos = mainFrame.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end
    end)

    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement 
            or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- #####################################################################
-- #                    [16] TOGGLE KEY (K)                            #
-- #####################################################################

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

-- #####################################################################
-- #                 [17] TOGGLE ROW CREATOR                           #
-- #####################################################################

local activeBinds = {}
local currentRowWaitingForKey = nil
local bindButtonRefs = {}
local keyBindGetters = {}
local keyBindSetters = {}
local rowFuncData = {}

local function createToggleRow(scriptName, canToggle, isEnabledFn, onEnable, onDisable, getKeyBindFn, setKeyBindFn)
    -- Ana satir frame'i
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -16, 0, 35)
    frame.BackgroundTransparency = 1
    frame.Name = scriptName:gsub("%s+", "")

    -- Yatay duzenleyici
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.Parent = frame

    -- Ozellik isim etiketi
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

    -- ON/OFF toggle butonu
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

    -- Toggle butonu stil
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleBtn

    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Color = Theme.Accent
    toggleStroke.Thickness = 1
    toggleStroke.Transparency = 0.4
    toggleStroke.Parent = toggleBtn

    local bindBtn = nil

    -- Hedef renk hesaplama fonksiyonu
    local function getTargetColor()
        local state = false
        if type(isEnabledFn) == 'function' then
            local success, result = pcall(isEnabledFn)
            if success then
                state = result
            end
        end
        if not canToggle then
            return Color3.fromRGB(120, 40, 40)
        end
        return state and Theme.ButtonOn or Theme.ButtonOff
    end

    -- Gorsel guncelleme fonksiyonu
    local function updateVisuals()
        local state = false
        if type(isEnabledFn) == 'function' then
            local success, result = pcall(isEnabledFn)
            if success then
                state = result
            end
        end

        if not canToggle then
            toggleBtn.Text = "RUN"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
        elseif state then
            toggleBtn.Text = "ON"
            toggleBtn.BackgroundColor3 = Theme.ButtonOn
        else
            toggleBtn.Text = "OFF"
            toggleBtn.BackgroundColor3 = Theme.ButtonOff
        end
    end

    -- Satir verisini kaydet
    rowFuncData[frame] = {
        isEnabledFn = isEnabledFn,
        onEnable = onEnable,
        onDisable = onDisable,
        canToggle = canToggle,
        updateFn = updateVisuals
    }

    -- Bind butonu (opsiyonel)
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

        local bindCorner = Instance.new("UICorner")
        bindCorner.CornerRadius = UDim.new(0, 6)
        bindCorner.Parent = bindBtn

        local bindStroke = Instance.new("UIStroke")
        bindStroke.Color = Theme.Accent
        bindStroke.Thickness = 1
        bindStroke.Transparency = 0.4
        bindStroke.Parent = bindBtn

        -- Referanslari kaydet
        bindButtonRefs[frame] = bindBtn
        keyBindGetters[frame] = getKeyBindFn
        keyBindSetters[frame] = setKeyBindFn

        -- Baslangic bind degerini kaydet
        local success, keyResult = pcall(getKeyBindFn)
        if success and keyResult and typeof(keyResult) == "EnumItem" then
            activeBinds[keyResult] = {
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
        -- Bind butonu yoksa toggle butonu daha genis olsun
        toggleBtn.Size = UDim2.new(0.55, 0, 0.8, 0)
    end

    -- Bind butonu yazi guncelleme
    local function updateBindText()
        if not bindBtn then
            return
        end

        local keyBind = nil
        if type(getKeyBindFn) == 'function' then
            local success, result = pcall(getKeyBindFn)
            if success then
                keyBind = result
            end
        end

        bindBtn.Text = (keyBind and typeof(keyBind) == "EnumItem" and keyBind.Name ~= "Unknown") 
            and "[" .. keyBind.Name .. "]" 
            or "Bind"
    end

    -- Ilk gorsel guncelleme
    updateVisuals()
    updateBindText()

    -- Toggle butonu hover efektleri
    toggleBtn.MouseEnter:Connect(function()
        local target = getTargetColor()
        local hoverTarget = target:Lerp(Color3.new(1, 1, 1), 0.2)
        TweenService:Create(toggleBtn, TweenInfo.new(0.1), {
            BackgroundColor3 = hoverTarget
        }):Play()
    end)

    toggleBtn.MouseLeave:Connect(function()
        TweenService:Create(toggleBtn, TweenInfo.new(0.1), {
            BackgroundColor3 = getTargetColor()
        }):Play()
    end)

    -- Bind butonu hover efektleri
    if bindBtn then
        bindBtn.MouseEnter:Connect(function()
            TweenService:Create(bindBtn, TweenInfo.new(0.1), {
                BackgroundColor3 = Theme.BindHover
            }):Play()
        end)

        bindBtn.MouseLeave:Connect(function()
            TweenService:Create(bindBtn, TweenInfo.new(0.1), {
                BackgroundColor3 = Theme.BindButton
            }):Play()
        end)

        -- Bind yakalama mantigi
        local capturing = false
        bindBtn.MouseButton1Click:Connect(function()
            -- Eger baska bir satir bind bekliyorsa, onu iptal et
            if currentRowWaitingForKey and currentRowWaitingForKey ~= frame then
                local prevBtn = bindButtonRefs[currentRowWaitingForKey]
                if prevBtn then
                    local getter = keyBindGetters[currentRowWaitingForKey]
                    local txt = "Bind"
                    if getter then
                        local success, result = pcall(getter)
                        if success and result and typeof(result) == "EnumItem" then
                            txt = "[" .. result.Name .. "]"
                        end
                    end
                    prevBtn.Text = txt
                end
            end

            if capturing then
                -- Bind yakalama iptal
                capturing = false
                updateBindText()
                currentRowWaitingForKey = nil
            else
                -- Bind yakalamaya basla
                capturing = true
                bindBtn.Text = "..."
                currentRowWaitingForKey = frame

                -- 5 saniye sonra otomatik iptal
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

    -- Toggle butonu tiklaninca
    toggleBtn.MouseButton1Click:Connect(function()
        local state = false
        if type(isEnabledFn) == 'function' then
            local success, result = pcall(isEnabledFn)
            if success then
                state = result
            end
        end

        if not canToggle then
            -- Tek seferlik calistirma (RUN butonu)
            if type(onEnable) == 'function' then
                pcall(onEnable)
            end
            toggleBtn.Text = "DONE"
            toggleBtn.BackgroundColor3 = Theme.ButtonOn:Lerp(
                Color3.fromRGB(10, 10, 12), 
                0.3
            )
            toggleBtn.Active = false
            if bindBtn then
                bindBtn.Active = false
            end
            return
        end

        -- Toggle ac/kapa
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

-- #####################################################################
-- #                   [18] SLIDER CREATOR                             #
-- #####################################################################

local function createSliderRow(labelText, minVal, maxVal, defaultVal, onValueChanged)
    -- Ana cerceve
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -16, 0, 50)
    frame.BackgroundTransparency = 1

    -- Dikey duzen
    local topLayout = Instance.new("UIListLayout")
    topLayout.FillDirection = Enum.FillDirection.Vertical
    topLayout.SortOrder = Enum.SortOrder.LayoutOrder
    topLayout.Padding = UDim.new(0, 3)
    topLayout.Parent = frame

    -- Ust satir: Label + Deger
    local labelFrame = Instance.new("Frame")
    labelFrame.Size = UDim2.new(1, 0, 0, 18)
    labelFrame.BackgroundTransparency = 1
    labelFrame.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = " " .. labelText
    label.TextColor3 = Theme.TextSecondary
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = labelFrame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.4, 0, 1, 0)
    valueLabel.Position = UDim2.new(0.6, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultVal)
    valueLabel.TextColor3 = Theme.Accent
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 12
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = labelFrame

    -- Alt satir: Slider
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 24)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = frame

    -- Slider arka plani
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -30, 0, 6)
    sliderBg.Position = UDim2.new(0, 0, 0.5, -3)
    sliderBg.BackgroundColor3 = Theme.SliderBg
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = sliderFrame

    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 3)
    sliderBgCorner.Parent = sliderBg

    -- Slider doluluk cubugu
    local fillPercent = (defaultVal - minVal) / (maxVal - minVal)
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(fillPercent, 0, 1, 0)
    sliderFill.BackgroundColor3 = Theme.SliderFill
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = sliderFill

    -- Slider topu (tutup cekmek icin)
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 24, 0, 24)
    sliderBtn.Position = UDim2.new(fillPercent, -12, 0.5, -12)
    sliderBtn.Text = ""
    sliderBtn.BackgroundColor3 = Theme.Accent
    sliderBtn.BorderSizePixel = 0
    sliderBtn.AutoButtonColor = false
    sliderBtn.Parent = sliderFrame

    local sliderBtnCorner = Instance.new("UICorner")
    sliderBtnCorner.CornerRadius = UDim.new(0, 12)
    sliderBtnCorner.Parent = sliderBtn

    -- Min/Max etiketleri
    local minLabel = Instance.new("TextLabel")
    minLabel.Size = UDim2.new(0, 25, 0, 14)
    minLabel.Position = UDim2.new(0, -2, 1, 2)
    minLabel.BackgroundTransparency = 1
    minLabel.Text = tostring(minVal)
    minLabel.TextColor3 = Theme.TextSecondary
    minLabel.Font = Enum.Font.Gotham
    minLabel.TextSize = 9
    minLabel.TextXAlignment = Enum.TextXAlignment.Left
    minLabel.Parent = sliderFrame

    local maxLabel = Instance.new("TextLabel")
    maxLabel.Size = UDim2.new(0, 25, 0, 14)
    maxLabel.Position = UDim2.new(1, -23, 1, 2)
    maxLabel.BackgroundTransparency = 1
    maxLabel.Text = tostring(maxVal)
    maxLabel.TextColor3 = Theme.TextSecondary
    maxLabel.Font = Enum.Font.Gotham
    maxLabel.TextSize = 9
    maxLabel.TextXAlignment = Enum.TextXAlignment.Right
    maxLabel.Parent = sliderFrame

    -- Slider mantigi
    local currentValue = defaultVal

    local function updateSlider(input)
        local sliderPos = sliderBg.AbsolutePosition
        local sliderWidth = sliderBg.AbsoluteSize.X
        
        if sliderWidth <= 0 then
            return
        end
        
        local relativeX = math.clamp(
            (input.Position.X - sliderPos.X) / sliderWidth, 
            0, 
            1
        )
        currentValue = math.floor(minVal + (maxVal - minVal) * relativeX)

        -- Gorsel guncelleme
        sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        sliderBtn.Position = UDim2.new(relativeX, -12, 0.5, -12)
        valueLabel.Text = tostring(currentValue)

        -- Geri bildirim fonksiyonu
        if onValueChanged then
            onValueChanged(currentValue)
        end
    end

    -- Slider topunu surukleme
    sliderBtn.MouseButton1Down:Connect(function()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not UserInputService:IsMouseButtonPressed(
                Enum.UserInputType.MouseButton1
            ) then
                connection:Disconnect()
                return
            end
            updateSlider({
                Position = UserInputService:GetMouseLocation()
            })
        end)
    end)

    -- Slider arka planina tiklayinca direkt konumlandir
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 
            or input.UserInputType == Enum.UserInputType.Touch then
            updateSlider(input)
        end
    end)

    -- Deger okuma ve ayarlama fonksiyonlarini dondur
    return frame, 
        function() 
            return currentValue 
        end, 
        function(v)
            currentValue = v
            local rx = (v - minVal) / (maxVal - minVal)
            sliderFill.Size = UDim2.new(rx, 0, 1, 0)
            sliderBtn.Position = UDim2.new(rx, -12, 0.5, -12)
            valueLabel.Text = tostring(v)
        end
end

-- #####################################################################
-- #              [19] MODUL: FLY (TRUE FLING - DUSER GIBI UCAR)       #
-- #####################################################################

local flyEnabled = false
local flyConn = nil
local flySpeed = 80        -- Orta hiz
local flyBoostSpeed = 140  -- Shift ile boost

function Fly_Enable()
    if flyEnabled then
        return
    end
    
    flyEnabled = true

    -- Ilk acildiginda karakteri biraz yukari firlat (duser gibi olmamasi icin)
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(0, 40, 0)  -- Yukari dogru ilk ivme
        end
    end

    flyConn = RunService.Heartbeat:Connect(function(dt)
        if not flyEnabled then
            return
        end

        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if not hrp or not hum then
            return
        end

        -- PlatformStand acik - yercekimi yok
        hum.PlatformStand = true

        -- Gravity override - tum parcalarin dogal hareketini durdur
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.AssemblyLinearVelocity = Vector3.zero
                part.Velocity = Vector3.zero
            end
        end

        local cam = workspace.CurrentCamera
        if not cam then
            return
        end

        -- Hedef velocity
        local targetVel = Vector3.new()

        -- WASD yonleri - kameraya gore
        local forward = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z).Unit
        local right = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z).Unit

        -- Mobil joystick veya klavye
        local md = hum.MoveDirection
        if md.Magnitude > 0.1 then
            -- Joystick varsa onu kullan (mobil)
            targetVel += md * flySpeed
        else
            -- Manuel klavye
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then targetVel += forward * flySpeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then targetVel -= forward * flySpeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then targetVel -= right * flySpeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then targetVel += right * flySpeed end
        end

        -- Dikey hareket
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            targetVel += Vector3.new(0, flySpeed, 0)  -- YUKARI FIRLA
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            targetVel -= Vector3.new(0, flySpeed, 0)  -- ASAGI DAL
        end

        -- Shift = Turbo boost
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            targetVel *= 1.75  -- %75 daha hizli
        end

        -- HAREKET YOKSA = Havada asili kal (dusme!)
        if targetVel.Magnitude < 1 then
            hrp.Velocity = Vector3.new(0, 0.5, 0)  -- Cok hafif yukari kuvvet, sabit kalmak icin
            hrp.AssemblyLinearVelocity = Vector3.zero
            return
        end

        -- FLING: Velocity'yi direkt hedefe ayarla
        hrp.Velocity = targetVel
        hrp.AssemblyLinearVelocity = targetVel
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
        local hrp = char:FindFirstChild("HumanoidRootPart")
        
        if hum then
            hum.PlatformStand = false
        end
        
        if hrp then
            hrp.Velocity = Vector3.zero
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end
end

-- #####################################################################
-- #                     [20] MODUL: NOCLIP                            #
-- #####################################################################

local noclipEnabled = false
local noclipConn = nil

function Noclip_Enable()
    if noclipEnabled then
        return
    end
    
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
-- #                    [21] MODUL: FULLBRIGHT                          #
-- #####################################################################

local fullbrightEnabled = false
local fullbrightConn = nil
local origLighting = {}

function FullBright_Enable()
    if fullbrightEnabled then
        return
    end
    
    fullbrightEnabled = true

    -- Orijinal isik degerlerini sakla
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
-- #                    [22] MODUL: FOV CHANGER                         #
-- #####################################################################

local fovEnabled = false
local fovVal = 80
local fovOrig = workspace.CurrentCamera and workspace.CurrentCamera.FieldOfView or 70

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
-- #                 [23] MODUL: NO FAIL LOCKPICK                       #
-- #####################################################################

local noFailLPEnabled = false
local noFailLPConn = nil

function NoFailLP_Enable()
    if noFailLPEnabled then
        return
    end
    
    noFailLPEnabled = true

    noFailLPConn = PlayerGui.ChildAdded:Connect(function(item)
        if item.Name == "LockpickGUI" then
            local mf = item:WaitForChild("MF", 10)
            if mf then
                local lpf = mf:WaitForChild("LP_Frame", 10)
                if lpf then
                    local frames = lpf:WaitForChild("Frames", 10)
                    if frames then
                        for _, barName in pairs({"B1", "B2", "B3"}) do
                            local bar = frames:WaitForChild(barName, 10)
                            if bar and bar:FindFirstChild("Bar") then
                                local uiScale = bar.Bar:FindFirstChild("UIScale")
                                if uiScale then
                                    uiScale.Scale = 10
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
-- #            [24] MODUL: SAFE ESP + RESPAWN TIMER                    #
-- #####################################################################

local safeESPEnabled = false
local safeESPConn = nil
local safeTimerData = {}

-- Safe tiplerine gore respawn sureleri (saniye)
local SAFE_RESPAWN_TIMES = {
    SmallSafe = 180,        -- 3 dakika
    MediumSafe = 300,       -- 5 dakika
    LargeSafe = 420,        -- 7 dakika
    Register = 120,         -- 2 dakika
    Register_M = 150,       -- 2.5 dakika
    Register_L = 180,       -- 3 dakika
    Default = 240           -- 4 dakika (bilinmeyenler icin)
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
    
    if not folder then
        return
    end

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        return
    end
    
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
                    -- BillboardGui olustur
                    local bg = Instance.new("BillboardGui")
                    bg.Name = "SantesSE"
                    bg.AlwaysOnTop = true
                    bg.Size = UDim2.new(0, 140, 0, 35)
                    bg.MaxDistance = 250
                    bg.Adornee = obj
                    bg.Parent = obj

                    -- Isim etiketi
                    local tl = Instance.new("TextLabel", bg)
                    tl.Size = UDim2.new(1, 0, 0.55, 0)
                    tl.BackgroundTransparency = 1
                    tl.Font = Enum.Font.SourceSansBold
                    tl.TextScaled = false
                    tl.TextSize = 13
                    tl.Text = obj.Name
                        :gsub("([a-z])([A-Z])", "%1 %2")
                        :gsub("_.*", "")

                    -- Timer etiketi
                    local timerLabel = Instance.new("TextLabel", bg)
                    timerLabel.Size = UDim2.new(1, 0, 0.45, 0)
                    timerLabel.Position = UDim2.new(0, 0, 0.55, 0)
                    timerLabel.BackgroundTransparency = 1
                    timerLabel.Font = Enum.Font.Gotham
                    timerLabel.TextScaled = false
                    timerLabel.TextSize = 11

                    if broken and broken:IsA("BoolValue") then
                        if broken.Value then
                            -- Safe soyulmus, kirmizi + timer
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
                            -- Safe calisir durumda, yesil
                            tl.TextColor3 = Color3.new(0, 1, 0)
                            timerLabel.Text = "Ready"
                            timerLabel.TextColor3 = Color3.new(0, 1, 0)
                            safeTimerData[obj] = nil
                        end

                        -- Kirilma durumu degisince guncelle
                        broken:GetPropertyChangedSignal("Value"):Connect(function()
                            if broken.Value then
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
                -- Menzil disinda, GUI'yi yok et
                exist:Destroy()
                safeTimerData[obj] = nil
            end
        end
    end

    -- Timer'lari guncelle
    for obj, data in pairs(safeTimerData) do
        if data and data.label and data.label.Parent then
            local elapsed = now - data.brokenTime
            local remaining = data.respawnTime - elapsed
            
            if remaining > 0 then
                data.label.Text = formatTime(remaining)
            else
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
    if safeESPEnabled then
        return
    end
    
    safeESPEnabled = true
    safeESPConn = RunService.Heartbeat:Connect(safeESPUpdate)
end

function SafeESP_Disable()
    safeESPEnabled = false
    
    if safeESPConn then
        safeESPConn:Disconnect()
        safeESPConn = nil
    end

    -- Tum timer GUI'lerini temizle
    for obj, data in pairs(safeTimerData) do
        if data and data.label then
            pcall(function()
                if data.label.Parent then
                    data.label.Parent:Destroy()
                end
            end)
        end
    end
    
    safeTimerData = {}
end

-- #####################################################################
-- #                  [25] MODUL: AUTO LOCKPICK                         #
-- #####################################################################

local autoLockpickEnabled = false
local autoLockpickConn = nil

function AutoLockpick_Enable()
    if autoLockpickEnabled then
        return
    end
    
    autoLockpickEnabled = true

    autoLockpickConn = RunService.Heartbeat:Connect(function()
        if not autoLockpickEnabled then
            return
        end

        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not playerGui then
            return
        end

        local lockpickGUI = playerGui:FindFirstChild("LockpickGUI")
        if not lockpickGUI then
            return
        end

        -- Safe yaninda otomatik lockpick - UIScale'i max yap
        pcall(function()
            local frames = lockpickGUI.MF.LP_Frame.Frames
            for _, barName in pairs({"B1", "B2", "B3"}) do
                local bar = frames:FindFirstChild(barName)
                if bar and bar:FindFirstChild("Bar") then
                    local uiScale = bar.Bar:FindFirstChild("UIScale")
                    if uiScale then
                        uiScale.Scale = 10
                    end
                end
            end
        end)
    end)
end

function AutoLockpick_Disable()
    autoLockpickEnabled = false
    
    if autoLockpickConn then
        autoLockpickConn:Disconnect()
        autoLockpickConn = nil
    end
end

-- #####################################################################
-- #                 [26] MODUL: AUTO PICKUP MONEY                      #
-- #####################################################################

local autoPickupEnabled = false
local autoPickupConn = nil
local pickupCD = false

function AutoPickup_Enable()
    if autoPickupEnabled then
        return
    end
    
    autoPickupEnabled = true

    autoPickupConn = RunService.RenderStepped:Connect(function()
        if not autoPickupEnabled or pickupCD then
            return
        end

        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            return
        end

        local hrp = char.HumanoidRootPart

        -- Para klasorunu bul
        local folder = Workspace.Filter and Workspace.Filter:FindFirstChild("SpawnedBread")
        if not folder then
            folder = Workspace:FindFirstChild("SpawnedBread")
        end
        if not folder then
            return
        end

        -- RemoteEvent'i bul
        local remote = ReplicatedStorage.Events and ReplicatedStorage.Events:FindFirstChild("CZDPZUS")
        if not remote then
            return
        end

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
-- #              [27] MODUL: AUTO UNLOCK/OPEN DOORS                    #
-- #####################################################################

local unlockDoorsEnabled = false
local unlockDoorsConn = nil

function UnlockDoors_Enable()
    if unlockDoorsEnabled then
        return
    end
    
    unlockDoorsEnabled = true

    unlockDoorsConn = RunService.Heartbeat:Connect(function()
        if not unlockDoorsEnabled then
            return
        end

        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            return
        end

        local hrp = char.HumanoidRootPart

        local doors = Workspace.Map and Workspace.Map:FindFirstChild("Doors")
        if not doors then
            return
        end

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
-- #                 [28] MODUL: ADMIN DETECTOR                         #
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
    if player == LocalPlayer then
        return false
    end

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
    if adminCheckEnabled then
        return
    end
    
    adminCheckEnabled = true

    -- Sunucudaki mevcut oyunculari kontrol et
    for _, player in pairs(Players:GetPlayers()) do
        if checkStaff(player) then
            return
        end
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
-- #                   [29] MODUL: PLAYER ESP                           #
-- #####################################################################

local espEnabled = false
local espConns = {}
local espList = {}

local function espCreate(player)
    if player == LocalPlayer or espList[player] then
        return
    end
    
    espList[player] = true

    local function setupESP(char)
        if not espEnabled or not char or not char.Parent then
            return
        end

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
    if espEnabled then
        return
    end
    
    espEnabled = true
    espList = {}

    -- Mevcut oyunculara ESP ekle
    for _, player in pairs(Players:GetPlayers()) do
        espCreate(player)
    end

    -- Yeni girenlere ESP ekle
    table.insert(espConns, Players.PlayerAdded:Connect(function(player)
        if espEnabled then
            espCreate(player)
        end
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
        pcall(function()
            conn:Disconnect()
        end)
    end
    
    espConns = {}
    espList = {}

    -- Tum ESP elemanlarini temizle
    for _, player in pairs(Players:GetPlayers()) do
        pcall(function()
            if player.Character then
                local highlight = player.Character:FindFirstChild("SantesESP")
                if highlight then
                    highlight:Destroy()
                end

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
-- #              [30] MODUL: INVISIBILITY (SHADOW MODE)                #
-- #####################################################################

local invisEnabled = false
local invisUsable = true
local invisTrack = nil
local invisChar = nil
local invisHum = nil
local invisHRP = nil
local invisGUI = nil
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
            local success, result = pcall(function()
                return invisHum:LoadAnimation(anim)
            end)
            
            if success then
                invisTrack = result
                invisTrack.Priority = Enum.AnimationPriority.Action4
            end
        end
    end

    -- Ana dongu
    RunService.Heartbeat:Connect(function(dt)
        if not invisEnabled or not invisUsable then
            if not invisEnabled and invisChar then
                for _, v in pairs(invisChar:GetDescendants()) do
                    if v:IsA("BasePart") and v.Transparency == 0.5 then
                        v.Transparency = 0
                    end
                end
            end
            if invisWarn then
                invisWarn.Visible = false
            end
            return
        end

        if not invisChar or not invisHum or not invisHRP or invisHum.Health <= 0 then
            if invisWarn then
                invisWarn.Visible = false
            end
            return
        end

        if invisWarn then
            invisWarn.Visible = not grounded()
        end

        -- Hareket
        local speed = 12
        if invisHum.MoveDirection.Magnitude > 0 then
            invisHRP.CFrame += invisHum.MoveDirection * speed * dt
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
                if not invisTrack.IsPlaying then
                    invisTrack:Play()
                end
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

        -- Transparency
        for _, v in pairs(invisChar:GetDescendants()) do
            if v:IsA("BasePart") and v.Transparency ~= 1 then
                v.Transparency = 0.5
            end
        end
    end)

    -- Karakter yenilenince
    LocalPlayer.CharacterAdded:Connect(function()
        if invisTrack then
            pcall(function() invisTrack:Stop() end)
            invisTrack = nil
        end
        
        task.wait()
        updateRefs()

        if invisHum and invisHum.RigType ~= Enum.HumanoidRigType.R6 then
            invisUsable = false
            if invisEnabled then
                Invis_Disable()
            end
            
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "SANTES Invisibility",
                    Text = "R6 avatar gerekli! Su anki: " .. tostring(invisHum.RigType),
                    Duration = 5
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
    
    if invisHum and invisHum.RigType ~= Enum.HumanoidRigType.R6 then
        invisUsable = false
    end

    -- Uyari GUI'si
    invisGUI = Instance.new("ScreenGui")
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

    -- Global fonksiyonlar
    _G.Invis_Enable = function()
        if invisEnabled or not invisUsable then
            return
        end
        
        invisEnabled = true
        updateRefs()
        
        if invisHRP then
            workspace.CurrentCamera.CameraSubject = invisHRP
        end
        
        loadTrack()
    end

    _G.Invis_Disable = function()
        if not invisEnabled then
            return
        end
        
        invisEnabled = false
        
        if invisTrack then
            pcall(function() invisTrack:Stop() end)
        end
        
        if invisHum then
            workspace.CurrentCamera.CameraSubject = invisHum
        end
        
        if invisChar then
            for _, v in pairs(invisChar:GetDescendants()) do
                if v:IsA("BasePart") and v.Transparency == 0.5 then
                    v.Transparency = 0
                end
            end
        end
        
        if invisWarn then
            invisWarn.Visible = false
        end
    end

    _G.IsInvisEnabled = function()
        return invisEnabled
    end
end

-- Wrapper fonksiyonlar
function Invis_Enable()
    _G.Invis_Enable()
end

function Invis_Disable()
    _G.Invis_Disable()
end

-- #####################################################################
-- #                   [31] MODUL: NO RECOIL                            #
-- #####################################################################

local noRecoilEnabled = false
local noRecoilOrig = {}

function NoRecoil_Enable()
    if noRecoilEnabled then
        return
    end
    
    noRecoilEnabled = true

    -- getgc ile tum silah tablolarini tara
    for _, v in pairs(getgc(true)) do
        if type(v) == 'table' and rawget(v, 'Recoil') ~= nil then
            -- Orijinal degerleri yedekle
            if not noRecoilOrig[v] then
                noRecoilOrig[v] = {
                    Recoil = v.Recoil,
                    Spread = v.Spread,
                    CameraRecoilingEnabled = v.CameraRecoilingEnabled,
                    AngleX_Min = v.AngleX_Min,
                    AngleX_Max = v.AngleX_Max,
                    AngleY_Min = v.AngleY_Min,
                    AngleY_Max = v.AngleY_Max,
                    AngleZ_Min = v.AngleZ_Min,
                    AngleZ_Max = v.AngleZ_Max
                }
            end
            
            -- Recoil ve spread'i sifirla
            v.Recoil = 0
            v.Spread = 0
            v.CameraRecoilingEnabled = false
            v.AngleX_Min = 0
            v.AngleX_Max = 0
            v.AngleY_Min = 0
            v.AngleY_Max = 0
            v.AngleZ_Min = 0
            v.AngleZ_Max = 0
        end
    end
end

function NoRecoil_Disable()
    if not noRecoilEnabled then
        return
    end
    
    noRecoilEnabled = false

    -- Orijinal degerleri geri yukle
    for weapon, orig in pairs(noRecoilOrig) do
        pcall(function()
            weapon.Recoil = orig.Recoil
            weapon.Spread = orig.Spread
            weapon.CameraRecoilingEnabled = orig.CameraRecoilingEnabled
            weapon.AngleX_Min = orig.AngleX_Min
            weapon.AngleX_Max = orig.AngleX_Max
            weapon.AngleY_Min = orig.AngleY_Min
            weapon.AngleY_Max = orig.AngleY_Max
            weapon.AngleZ_Min = orig.AngleZ_Min
            weapon.AngleZ_Max = orig.AngleZ_Max
        end)
    end
    
    noRecoilOrig = {}
end

-- #####################################################################
-- #            [32] MODUL: SILENT AIM (FOV CIRCLE)                     #
-- #####################################################################

local silentAimEnabled = false
local silentAimConn = nil
local silentAimFOV = 150
local silentAimSmoothness = 1
local fovCircle = nil

function SilentAim_Enable()
    if silentAimEnabled then
        return
    end
    
    silentAimEnabled = true

    -- FOV cemberi olustur (Drawing kutuphanesi)
    pcall(function()
        fovCircle = Drawing.new("Circle")
        fovCircle.Visible = true
        fovCircle.Radius = silentAimFOV
        fovCircle.Color = Color3.fromRGB(255, 255, 255)
        fovCircle.Thickness = 1.5
        fovCircle.Transparency = 0.7
        fovCircle.Filled = false
        fovCircle.Position = Vector2.new(
            workspace.CurrentCamera.ViewportSize.X / 2,
            workspace.CurrentCamera.ViewportSize.Y / 2
        )
    end)

    silentAimConn = RunService.RenderStepped:Connect(function()
        if not silentAimEnabled then
            return
        end

        -- FOV cemberini guncelle
        if fovCircle then
            pcall(function()
                fovCircle.Radius = silentAimFOV
                fovCircle.Position = Vector2.new(
                    workspace.CurrentCamera.ViewportSize.X / 2,
                    workspace.CurrentCamera.ViewportSize.Y / 2
                )
            end)
        end

        -- Sag tus kontrolu
        local pressed = UserInputService:IsMouseButtonPressed(
            Enum.UserInputType.MouseButton2
        )
        if not pressed then
            return
        end

        local cam = workspace.CurrentCamera
        if not cam then
            return
        end

        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then
            return
        end

        local mousePos = UserInputService:GetMouseLocation()

        local closest = nil
        local bestDist = silentAimFOV

        -- Tum oyunculari tara
        for _, pl in pairs(Players:GetPlayers()) do
            if pl ~= LocalPlayer and pl.Character then
                local hum = pl.Character:FindFirstChildOfClass("Humanoid")
                local tp = pl.Character:FindFirstChild("Head") 
                    or pl.Character:FindFirstChild("HumanoidRootPart")

                if hum and hum.Health > 0 and tp then
                    local screenPos, onScreen = cam:WorldToViewportPoint(tp.Position)

                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

                        if dist < bestDist then
                            bestDist = dist
                            closest = pl
                        end
                    end
                end
            end
        end

        -- En yakin hedefe kamerayi kitle
        if closest and closest.Character then
            local tp = closest.Character:FindFirstChild("Head") 
                or closest.Character:FindFirstChild("HumanoidRootPart")

            if tp then
                local targetCFrame = CFrame.new(cam.CFrame.Position, tp.Position)

                if silentAimSmoothness > 1 then
                    cam.CFrame = cam.CFrame:Lerp(
                        targetCFrame, 
                        1 / silentAimSmoothness
                    )
                else
                    cam.CFrame = targetCFrame
                end
            end
        end
    end)
end

function SilentAim_Disable()
    silentAimEnabled = false
    
    if silentAimConn then
        silentAimConn:Disconnect()
        silentAimConn = nil
    end

    -- FOV cemberini kaldir
    if fovCircle then
        pcall(function()
            fovCircle:Remove()
        end)
        fovCircle = nil
    end
end

function SilentAim_SetFOV(value)
    silentAimFOV = math.clamp(value, 50, 500)
    
    if fovCircle then
        pcall(function()
            fovCircle.Radius = silentAimFOV
        end)
    end
end

function SilentAim_GetFOV()
    return silentAimFOV
end

-- #####################################################################
-- #         [33] MODUL: MELEE AURA (HEAD/BODY + YUMRUK FIX)           #
-- #####################################################################

local meleeAuraEnabled = false
local meleeAuraConn = nil
local meleeTarget = "Head"

function MeleeAura_Enable()
    if meleeAuraEnabled then
        return
    end
    
    meleeAuraEnabled = true

    local eventsFolder = ReplicatedStorage:WaitForChild("Events", 10)
    if not eventsFolder then
        return
    end

    local remote1 = eventsFolder:WaitForChild("XMHH.2", 5)
    local remote2 = eventsFolder:WaitForChild("XMHH2.2", 5)

    if not remote1 or not remote2 then
        return
    end

    meleeAuraConn = RunService.Heartbeat:Connect(function()
        if not meleeAuraEnabled then
            return
        end

        local myChar = LocalPlayer.Character
        if not myChar then
            return
        end

        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then
            return
        end

        -- Silah varsa onu kullan, yoksa yumruk
        local tool = myChar:FindFirstChildOfClass("Tool")
        
        -- En yakin dusmani bul
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

        if not closestEnemy then
            return
        end

        local targetChar = closestEnemy.Character
        local targetPart = targetChar:FindFirstChild(meleeTarget)

        if not targetPart then
            return
        end

        -- YUMRUK ICIN: Eger tool yoksa, fakeTool olarak karakterin kolu kullanilir
        local fakeTool = tool or myChar:FindFirstChild("Right Arm") or myHRP

        local result = remote1:InvokeServer(
            "\240\159\141\158",     -- "🍞"
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
-- #                [34] MODUL: INFINITE STAMINA                        #
-- #####################################################################

local infStaminaEnabled = false
local staminaHooked = false

function InfiniteStamina_Enable()
    infStaminaEnabled = true
    
    if staminaHooked then
        return
    end
    
    staminaHooked = true

    task.spawn(function()
        for i = 1, 20 do
            local env = nil
            
            -- Farkli executor'lar icin environment alma
            local s1, e1 = pcall(function() return getrenv() end)
            if s1 then
                env = e1
            else
                local s2, e2 = pcall(function() return getfenv() end)
                if s2 then
                    env = e2
                end
            end

            if env and env._G and type(env._G.S_Take) == "function" then
                local s3, upval = pcall(function()
                    return getupvalue(env._G.S_Take, 2)
                end)

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

-- #####################################################################
-- #                   [35] MODUL: AUTO FARM                            #
-- #####################################################################

local autoFarmEnabled = false
local autoFarmCoroutine = nil
local farmIgnored = {}

-- Guvenli teleport
local function farmTP(pos)
    local char = LocalPlayer.Character
    if not char then
        return false
    end

    local hrp = char:WaitForChild("HumanoidRootPart", 10)
    if not hrp then
        return false
    end

    for i = 1, 4 do
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
        wait(0.5)
        
        if hrp and hrp.Parent and (hrp.Position - pos).Magnitude < 5 then
            return true
        end
        
        wait(0.5)
    end
    
    return false
end

-- En yakin levye dealer'ini bul
local function farmFindDealer()
    local shops = Workspace.Map and Workspace.Map:FindFirstChild("Shopz")
    if not shops then
        return nil
    end

    local char = LocalPlayer.Character
    if not char then
        return nil
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return nil
    end

    local nearest = nil
    local best = math.huge

    for _, shop in pairs(shops:GetChildren()) do
        local main = shop:FindFirstChild("MainPart")
        local stocks = shop:FindFirstChild("CurrentStocks")

        if main and stocks then
            local cs = stocks:FindFirstChild("Crowbar")
            if cs and cs.Value > 0 then
                local d = (main.Position - hrp.Position).Magnitude
                if d < best then
                    best = d
                    nearest = shop
                end
            end
        end
    end
    
    return nearest
end

-- En yakin kirilmamis safe/register bul
local function farmFindTarget()
    local folder = Workspace.Map and Workspace.Map:FindFirstChild("BredMakurz")
    
    if not folder then
        folder = Workspace.Filter and Workspace.Filter:FindFirstChild("BredMakurz")
    end
    
    if not folder then
        folder = Workspace:FindFirstChild("BredMakurz")
    end
    
    if not folder then
        return nil
    end

    local char = LocalPlayer.Character
    if not char then
        return nil
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return nil
    end

    local nearest = nil
    local best = math.huge

    for _, obj in pairs(folder:GetChildren()) do
        if (string.find(obj.Name, "Safe") or string.find(obj.Name, "Register")) 
            and not table.find(farmIgnored, obj) then
            
            local values = obj:FindFirstChild("Values")
            if values then
                local broken = values:FindFirstChild("Broken")
                if broken and broken:IsA("BoolValue") and not broken.Value then
                    local tp = obj.PrimaryPart 
                        or obj:FindFirstChild("MainPart") 
                        or obj:FindFirstChildOfClass("BasePart")

                    if tp then
                        local d = (tp.Position - hrp.Position).Magnitude
                        if d < best then
                            best = d
                            nearest = obj
                        end
                    end
                end
            end
        end
    end
    
    return nearest
end

-- Alet kontrolu
local function farmHasTool(name)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild(name) then
        return true
    end
    
    local bp = LocalPlayer.Backpack
    return bp and bp:FindFirstChild(name) ~= nil
end

-- Alet kusanma
local function farmEquipTool(name)
    local char = LocalPlayer.Character
    if not char then
        return false
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then
        return false
    end

    local tool = char:FindFirstChild(name) or LocalPlayer.Backpack:FindFirstChild(name)
    if tool then
        pcall(function()
            hum:EquipTool(tool)
        end)
        wait(0.5)
        return true
    end
    
    return false
end

-- Safe acma
local function farmOpenSafe(safe)
    if not farmHasTool("Crowbar") then
        return
    end
    
    if not farmEquipTool("Crowbar") then
        return
    end

    local r1 = ReplicatedStorage.Events:FindFirstChild("XMHH.2")
    local r2 = ReplicatedStorage.Events:FindFirstChild("XMHH2.2")
    local sp = safe:FindFirstChild("MainPart")

    if not r1 or not r2 or not sp then
        return
    end

    local eq = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Crowbar")
    if not eq then
        return
    end

    local st = tick()
    
    while safe and safe.Parent 
        and safe.Values 
        and safe.Values:FindFirstChild("Broken") 
        and not safe.Values.Broken.Value 
        and (tick() - st < 20) do
        
        local char = LocalPlayer.Character
        if not char then
            break
        end

        local res = r1:InvokeServer(
            "\240\159\141\158",     -- "🍞"
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

-- Levye satin alma
local function farmBuyCrowbar(dealer)
    if not dealer then
        return false
    end

    local main = dealer:FindFirstChild("MainPart")
    if not main then
        return false
    end

    if not farmTP(main.Position) then
        return false
    end
    
    wait(1)

    local be = ReplicatedStorage.Events:FindFirstChild("BYZERSPROTEC")
    local se = ReplicatedStorage.Events:FindFirstChild("SSHPRMTE1")
    
    if not be or not se then
        return false
    end

    be:FireServer(true, "shop", main, "IllegalStore")
    wait(1)
    se:InvokeServer("IllegalStore", "Melees", "Crowbar", main, nil, true)
    wait(2)
    be:FireServer(false)

    return farmHasTool("Crowbar")
end

-- Ana dongu
local function farmLoop()
    while autoFarmEnabled do
        wait(1)

        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        -- Olu/Respawn kontrolu
        if not char or not hum or hum.Health <= 0 then
            local de = ReplicatedStorage.Events:FindFirstChild("DeathRespawn")
            if de then
                pcall(function()
                    de:InvokeServer("KMG4R904")
                end)
            end
            
            wait(3)
            farmIgnored = {}
            continue
        end

        -- Levye yoksa satin al
        if not farmHasTool("Crowbar") then
            local dealer = farmFindDealer()
            if dealer then
                farmBuyCrowbar(dealer)
            else
                wait(5)
            end
            continue
        end

        -- Safe bul ve soy
        local target = farmFindTarget()
        if target then
            local mp = target:FindFirstChild("MainPart") or target.PrimaryPart
            if mp then
                if farmTP(mp.Position) then
                    wait(1)
                    farmOpenSafe(target)
                else
                    table.insert(farmIgnored, target)
                    wait(0.5)
                end
            end
        else
            farmIgnored = {}
            wait(5)
        end
    end
end

function AutoFarm_Enable()
    if autoFarmEnabled then
        return
    end
    
    autoFarmEnabled = true
    farmIgnored = {}

    if autoFarmCoroutine then
        task.cancel(autoFarmCoroutine)
        autoFarmCoroutine = nil
    end

    -- Bagimli modulleri ac
    AutoPickup_Enable()
    Noclip_Enable()

    autoFarmCoroutine = task.spawn(farmLoop)

    -- Respawn handler
    LocalPlayer.CharacterAdded:Connect(function()
        if autoFarmEnabled then
            wait(2)
            AutoPickup_Enable()
            Noclip_Enable()
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
    AutoPickup_Disable()
end

-- #####################################################################
-- #                   [36] UI CATEGORIES                               #
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
    if not btn or btn == ActiveCat then
        return
    end

    -- Onceki aktif butonu sifirla
    if ActiveCat then
        TweenService:Create(ActiveCat, TweenInfo.new(0.15), {
            BackgroundColor3 = Theme.CategoryInactive
        }):Play()
        
        if ActiveCat.TextLabel then
            ActiveCat.TextLabel.TextColor3 = Theme.TextSecondary
        end
    end

    -- Yeni butonu aktif yap
    TweenService:Create(btn, TweenInfo.new(0.15), {
        BackgroundColor3 = Theme.CategoryActive
    }):Play()
    
    if btn.TextLabel then
        btn.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    ActiveCat = btn

    -- Content'i temizle
    for _, child in pairs(contentFrame:GetChildren()) do
        if child:IsA("Frame") 
            and child.Name ~= "UIListLayout" 
            and child.Name ~= "UICorner" 
            and child.Name ~= "UIStroke" then
            child.Parent = nil
        end
    end

    -- Yeni kategoriyi yukle
    if CatFrames[name] then
        for i, frame in pairs(CatFrames[name]) do
            frame.Parent = contentFrame
            frame.LayoutOrder = i
        end
        
        local count = #CatFrames[name]
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, 
            count * 35 + (count > 0 and (count - 1) * 6 or 0) + 10
        )
    end
end

-- Kategori butonlarini olustur
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
            TweenService:Create(btn, TweenInfo.new(0.1), {
                BackgroundColor3 = Theme.BindHover
            }):Play()
        end
    end)

    btn.MouseLeave:Connect(function()
        if btn ~= ActiveCat then
            TweenService:Create(btn, TweenInfo.new(0.1), {
                BackgroundColor3 = Theme.CategoryInactive
            }):Play()
        end
    end)

    btn.MouseButton1Click:Connect(function()
        SwitchCategory(cat)
    end)

    CatButtons[cat] = btn
end

-- #####################################################################
-- #                 [37] POPULATE CATEGORIES                           #
-- #####################################################################

-- ==================== COMBAT ====================
table.insert(CatFrames.Combat, createToggleRow(
    "Silent Aim", true,
    function() return silentAimEnabled end,
    SilentAim_Enable, SilentAim_Disable,
    function() return KB.silentAim end,
    function(v) KB.silentAim = v end
))

-- Silent Aim FOV Slider
do
    local sliderFrame, getVal, setVal = createSliderRow(
        "Aim FOV", 50, 500, 150,
        function(v) SilentAim_SetFOV(v) end
    )
    table.insert(CatFrames.Combat, sliderFrame)
end

table.insert(CatFrames.Combat, createToggleRow(
    "Melee Aura", true,
    function() return meleeAuraEnabled end,
    MeleeAura_Enable, MeleeAura_Disable,
    function() return KB.melee end,
    function(v) KB.melee = v end
))

table.insert(CatFrames.Combat, createToggleRow(
    "No Recoil", true,
    function() return noRecoilEnabled end,
    NoRecoil_Enable, NoRecoil_Disable,
    function() return KB.noRecoil end,
    function(v) KB.noRecoil = v end
))

-- ==================== MOVEMENT ====================
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
    function() return KB.noclip end,
    function(v) KB.noclip = v end
))

table.insert(CatFrames.Movement, createToggleRow(
    "Inf Stamina", true,
    function() return infStaminaEnabled end,
    InfiniteStamina_Enable, InfiniteStamina_Disable,
    function() return KB.infStamina end,
    function(v) KB.infStamina = v end
))

table.insert(CatFrames.Movement, createToggleRow(
    "Invisibility", true,
    _G.IsInvisEnabled, _G.Invis_Enable, _G.Invis_Disable,
    function() return KB.invis end,
    function(v) KB.invis = v end
))

-- ==================== VISUALS ====================
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
    function() return KB.safeESP end,
    function(v) KB.safeESP = v end
))

table.insert(CatFrames.Visuals, createToggleRow(
    "FullBright", true,
    function() return fullbrightEnabled end,
    FullBright_Enable, FullBright_Disable,
    function() return KB.fullbright end,
    function(v) KB.fullbright = v end
))

table.insert(CatFrames.Visuals, createToggleRow(
    "FOV", true,
    function() return fovEnabled end,
    FOV_Enable, FOV_Disable,
    function() return KB.fov end,
    function(v) KB.fov = v end
))

-- ==================== FARMING ====================
table.insert(CatFrames.Farming, createToggleRow(
    "Auto Farm", true,
    function() return autoFarmEnabled end,
    AutoFarm_Enable, AutoFarm_Disable,
    function() return KB.autoFarm end,
    function(v) KB.autoFarm = v end
))

table.insert(CatFrames.Farming, createToggleRow(
    "Auto Pickup $", true,
    function() return autoPickupEnabled end,
    AutoPickup_Enable, AutoPickup_Disable,
    function() return KB.autoPickup end,
    function(v) KB.autoPickup = v end
))

table.insert(CatFrames.Farming, createToggleRow(
    "No Fail Lockpick", true,
    function() return noFailLPEnabled end,
    NoFailLP_Enable, NoFailLP_Disable,
    function() return KB.noFailLP end,
    function(v) KB.noFailLP = v end
))

table.insert(CatFrames.Farming, createToggleRow(
    "Auto Lockpick", true,
    function() return autoLockpickEnabled end,
    AutoLockpick_Enable, AutoLockpick_Disable,
    function() return KB.autoLockpick end,
    function(v) KB.autoLockpick = v end
))

-- ==================== MISC ====================
table.insert(CatFrames.Misc, createToggleRow(
    "Admin Detector", true,
    function() return adminCheckEnabled end,
    AdminCheck_Enable, AdminCheck_Disable,
    function() return KB.adminCheck end,
    function(v) KB.adminCheck = v end
))

table.insert(CatFrames.Misc, createToggleRow(
    "Auto Unlock Doors", true,
    function() return unlockDoorsEnabled end,
    UnlockDoors_Enable, UnlockDoors_Disable,
    function() return KB.unlockDoors end,
    function(v) KB.unlockDoors = v end
))

-- #####################################################################
-- #                 [38] KEYBIND HANDLER                               #
-- #####################################################################

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then
        return
    end

    -- Yeni bind yakalama
    if currentRowWaitingForKey 
        and input.KeyCode ~= Enum.KeyCode.Unknown 
        and input.KeyCode ~= Enum.KeyCode.K then
        
        local frame = currentRowWaitingForKey
        local bb = bindButtonRefs[frame]
        local gf = keyBindGetters[frame]
        local sf = keyBindSetters[frame]
        local fd = rowFuncData[frame]

        if bb and gf and sf and fd then
            -- Eski bind'i temizle
            local ok = nil
            local s, r = pcall(gf)
            if s then
                ok = r
            end

            if ok and activeBinds[ok] then
                activeBinds[ok] = nil
            end

            -- Eger bu tusa baska bir sey atanmissa onu temizle
            if activeBinds[input.KeyCode] then
                local of = activeBinds[input.KeyCode].frame
                local ob = bindButtonRefs[of]
                local os2 = keyBindSetters[of]
                
                if os2 then
                    pcall(os2, nil)
                end
                
                if ob then
                    ob.Text = "Bind"
                end
                
                activeBinds[input.KeyCode] = nil
            end

            -- Yeni bind'i kaydet
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
    end

    -- Mevcut bind'i tetikleme
    if activeBinds[input.KeyCode] then
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
-- #                   [39] INITIALIZATION                              #
-- #####################################################################

SwitchCategory("Combat")

-- Acilis animasyonu
mainFrame.Size = UDim2.new(0, 0, 0, 0)
local openTween = TweenService:Create(
    mainFrame,
    TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {Size = UDim2.new(0, 460, 0, 400)}
)
task.wait(0.1)
openTween:Play()

-- Yuklendi mesaji
print("================================================")
print("  SANTES HUB YUKLENDI!")
print("  Piyasanin En Iyisi - Best on Market")
print(" ")
print("  MODULLER:")
print("  Combat:  Silent Aim (FOV Circle) + Melee Aura + No Recoil")
print("  Movement: Fly (Havada Sabit) + Noclip + Inf Stamina + Invis")
print("  Visuals:  Player ESP + Safe ESP (Timer) + FullBright + FOV")
print("  Farming:  Auto Farm + Auto Pickup + No Fail LP + Auto LP")
print("  Misc:     Admin Detector + Auto Unlock Doors")
print(" ")
print("  UI: Minimize + Logo + Drag + K Toggle + X Full Cleanup")
print("  Mobile: MoveDirection Joystick uyumlu")
print("================================================")
