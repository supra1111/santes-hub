--[[
    SANTES HUB v3.2 - DIREKT CALISAN VERSIYON
    Loader yok, animasyon yok, sadece calisan UI
--]]

-- Servisler
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)

if not PlayerGui then return end

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    local vu = game:GetService("VirtualUser")
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
end)

-- Eski UI temizle
for _, n in pairs({"SantesHubScreenGui", "SantesHub_Main", "SantesHub_Loader"}) do
    pcall(function() local g = PlayerGui:FindFirstChild(n) if g then g:Destroy() end end)
    pcall(function() local g = CoreGui:FindFirstChild(n) if g then g:Destroy() end end)
end

-- Tema
local C = {
    bg = Color3.fromRGB(12, 12, 16),
    panel = Color3.fromRGB(16, 16, 22),
    card = Color3.fromRGB(20, 20, 28),
    accent = Color3.fromRGB(210, 30, 30),
    border = Color3.fromRGB(40, 40, 52),
    text = Color3.fromRGB(230, 230, 240),
    text2 = Color3.fromRGB(140, 140, 160),
    on = Color3.fromRGB(180, 30, 30),
    off = Color3.fromRGB(50, 50, 62),
}

-- ==================== GUI BASLANGIC ====================

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "SantesHub_Main"
mainGui.ResetOnSpawn = false
mainGui.Parent = PlayerGui

-- Ana cerceve
local win = Instance.new("Frame")
win.Size = UDim2.new(0, 500, 0, 380)
win.Position = UDim2.new(0.5, 0, 0.5, 0)
win.AnchorPoint = Vector2.new(0.5, 0.5)
win.BackgroundColor3 = C.bg
win.BorderSizePixel = 0
win.Active = true
win.Draggable = true
win.Visible = true
win.Parent = mainGui

local wc = Instance.new("UICorner")
wc.CornerRadius = UDim.new(0, 10)
wc.Parent = win

local ws = Instance.new("UIStroke")
ws.Color = C.accent
ws.Thickness = 1
ws.Parent = win

-- Title
local title = Instance.new("Frame")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = C.panel
title.BorderSizePixel = 0
title.Parent = win
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -100, 1, 0)
titleText.Position = UDim2.new(0, 16, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "SANTES HUB v3.2"
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 16
titleText.TextColor3 = C.text
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = title

-- Close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -36, 0, 5)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = C.text
closeBtn.BackgroundColor3 = C.accent
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.Parent = title
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Minimize
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -70, 0, 5)
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.TextColor3 = C.text
minBtn.BackgroundColor3 = Color3.fromRGB(160, 130, 30)
minBtn.BorderSizePixel = 0
minBtn.AutoButtonColor = false
minBtn.Parent = title
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

-- Sidebar
local side = Instance.new("Frame")
side.Size = UDim2.new(0, 130, 1, -40)
side.Position = UDim2.new(0, 0, 0, 40)
side.BackgroundColor3 = C.panel
side.BorderSizePixel = 0
side.Parent = win

local sl = Instance.new("UIListLayout")
sl.Padding = UDim.new(0, 4)
sl.SortOrder = Enum.SortOrder.LayoutOrder
sl.HorizontalAlignment = Enum.HorizontalAlignment.Center
sl.Parent = side

local sp = Instance.new("UIPadding")
sp.PaddingTop = UDim.new(0, 8)
sp.PaddingLeft = UDim.new(0, 6)
sp.PaddingRight = UDim.new(0, 6)
sp.Parent = side

-- Sidebar ayrac
local sideLine = Instance.new("Frame")
sideLine.Size = UDim2.new(0, 1, 1, -40)
sideLine.Position = UDim2.new(0, 130, 0, 40)
sideLine.BackgroundColor3 = C.border
sideLine.BorderSizePixel = 0
sideLine.Parent = win

-- Content
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -131, 1, -40)
content.Position = UDim2.new(0, 131, 0, 40)
content.BackgroundColor3 = C.bg
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.ScrollBarImageColor3 = C.accent
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.Parent = win

local cp = Instance.new("UIPadding")
cp.PaddingTop = UDim.new(0, 12)
cp.PaddingLeft = UDim.new(0, 12)
cp.PaddingRight = UDim.new(0, 12)
cp.PaddingBottom = UDim.new(0, 12)
cp.Parent = content

local cl = Instance.new("UIListLayout")
cl.Padding = UDim.new(0, 8)
cl.SortOrder = Enum.SortOrder.LayoutOrder
cl.HorizontalAlignment = Enum.HorizontalAlignment.Center
cl.Parent = content

cl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    content.CanvasSize = UDim2.new(0, 0, 0, cl.AbsoluteContentSize.Y + 24)
end)

-- Kucuk kare
local mini = Instance.new("Frame")
mini.Size = UDim2.new(0, 50, 0, 50)
mini.Position = UDim2.new(0.02, 0, 0.02, 0)
mini.BackgroundColor3 = C.bg
mini.BorderSizePixel = 0
mini.Visible = false
mini.Active = true
mini.Draggable = true
mini.ZIndex = 999
mini.Parent = mainGui
Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 8)
local ms2 = Instance.new("UIStroke", mini)
ms2.Color = C.accent
ms2.Thickness = 2

local miniLbl = Instance.new("TextLabel")
miniLbl.Size = UDim2.new(1, 0, 0.5, 0)
miniLbl.Position = UDim2.new(0, 0, 0.08, 0)
miniLbl.BackgroundTransparency = 1
miniLbl.Text = "SANTES"
miniLbl.Font = Enum.Font.GothamBold
miniLbl.TextSize = 12
miniLbl.TextColor3 = C.accent
miniLbl.TextXAlignment = Enum.TextXAlignment.Center
miniLbl.Parent = mini

local miniSub = Instance.new("TextLabel")
miniSub.Size = UDim2.new(1, 0, 0.4, 0)
miniSub.Position = UDim2.new(0, 0, 0.52, 0)
miniSub.BackgroundTransparency = 1
miniSub.Text = "HUB"
miniSub.Font = Enum.Font.GothamBold
miniSub.TextSize = 11
miniSub.TextColor3 = C.text
miniSub.TextXAlignment = Enum.TextXAlignment.Center
miniSub.Parent = mini

-- Minimize islemleri
minBtn.MouseButton1Click:Connect(function()
    win.Visible = false
    mini.Visible = true
end)

mini.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        mini.Visible = false
        win.Visible = true
    end
end)

-- Close islemi
closeBtn.MouseButton1Click:Connect(function()
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
    pcall(function() if silentAimEnabled then SilentAim_Disable() end end)
    pcall(function() if meleeAuraEnabled then MeleeAura_Disable() end end)
    pcall(function() if autoFarmEnabled then AutoFarm_Disable() end end)
    mainGui:Destroy()
end)

-- K toggle
UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.K then
        if mini.Visible then
            mini.Visible = false
            win.Visible = true
        else
            win.Visible = not win.Visible
        end
    end
end)

-- ==================== TOGGLE ROW ====================

local function makeToggle(name, canToggle, isOn, onEn, onDis)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 44)
    f.BackgroundColor3 = C.card
    f.BorderSizePixel = 0
    f.Parent = content
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    
    local lay = Instance.new("UIListLayout")
    lay.FillDirection = Enum.FillDirection.Horizontal
    lay.VerticalAlignment = Enum.VerticalAlignment.Center
    lay.Padding = UDim.new(0, 10)
    lay.Parent = f
    
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pad.Parent = f
    
    local lb = Instance.new("TextLabel")
    lb.Size = UDim2.new(0.55, 0, 1, 0)
    lb.BackgroundTransparency = 1
    lb.Text = name
    lb.Font = Enum.Font.GothamSemibold
    lb.TextSize = 13
    lb.TextColor3 = C.text2
    lb.TextXAlignment = Enum.TextXAlignment.Left
    lb.Parent = f
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 66, 0, 30)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = C.off
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = f
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 15)
    
    local function upd()
        local st = false
        if isOn then
            local s, r = pcall(isOn)
            if s then st = r end
        end
        if not canToggle then
            btn.Text = "RUN"
            btn.BackgroundColor3 = Color3.fromRGB(80, 120, 220)
        elseif st then
            btn.Text = "ON"
            btn.BackgroundColor3 = C.on
        else
            btn.Text = "OFF"
            btn.BackgroundColor3 = C.off
        end
    end
    
    upd()
    
    btn.MouseButton1Click:Connect(function()
        local st = false
        if isOn then
            local s, r = pcall(isOn)
            if s then st = r end
        end
        if not canToggle then
            if onEn then pcall(onEn) end
            btn.Text = "OK"
            btn.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
            btn.Active = false
            return
        end
        if st then
            if onDis then pcall(onDis) end
        else
            if onEn then pcall(onEn) end
        end
        upd()
    end)
    
    return f
end

-- ==================== MODULES ====================

-- FLY
local flyEnabled = false
local flyConn = nil

function Fly_Enable()
    if flyEnabled then return end
    flyEnabled = true
    local c = LocalPlayer.Character
    if c then
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Velocity = Vector3.new(0, 30, 0) end
    end
    flyConn = RunService.Heartbeat:Connect(function(dt)
        if not flyEnabled then return end
        local c = LocalPlayer.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        hum.PlatformStand = true
        for _, p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                p.AssemblyLinearVelocity = Vector3.zero
                p.Velocity = Vector3.zero
            end
        end
        local cam = workspace.CurrentCamera
        if not cam then return end
        local tv = Vector3.new()
        local fwd = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z).Unit
        local rgt = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z).Unit
        local md = hum.MoveDirection
        if md.Magnitude > 0.1 then
            tv += md * 70
        else
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then tv += fwd * 70 end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then tv -= fwd * 70 end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then tv -= rgt * 70 end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then tv += rgt * 70 end
        end
        if tv.Magnitude < 1 then
            hrp.Velocity = Vector3.new(0, 0.3, 0)
            hrp.AssemblyLinearVelocity = Vector3.zero
        else
            hrp.Velocity = tv
            hrp.AssemblyLinearVelocity = tv
        end
    end)
end

function Fly_Disable()
    flyEnabled = false
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    local c = LocalPlayer.Character
    if c then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.PlatformStand = false end
    end
end

-- NOCLIP
local noclipEnabled = false
local noclipConn = nil

function Noclip_Enable()
    if noclipEnabled then return end
    noclipEnabled = true
    noclipConn = RunService.Stepped:Connect(function()
        if noclipEnabled and LocalPlayer.Character then
            for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end)
end

function Noclip_Disable()
    noclipEnabled = false
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
end

-- FULLBRIGHT
local fullbrightEnabled = false
local fullbrightConn = nil
local origLight = {}

function FullBright_Enable()
    if fullbrightEnabled then return end
    fullbrightEnabled = true
    origLight = {
        Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
        Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
        FogStart = Lighting.FogStart, FogEnd = Lighting.FogEnd
    }
    fullbrightConn = RunService.RenderStepped:Connect(function()
        Lighting.Brightness = 5; Lighting.ClockTime = 14
        Lighting.Ambient = Color3.new(1, 1, 1); Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.FogStart = 100000; Lighting.FogEnd = 100000
    end)
end

function FullBright_Disable()
    fullbrightEnabled = false
    if fullbrightConn then fullbrightConn:Disconnect(); fullbrightConn = nil end
    if origLight.Brightness then
        Lighting.Brightness = origLight.Brightness; Lighting.ClockTime = origLight.ClockTime
        Lighting.Ambient = origLight.Ambient; Lighting.OutdoorAmbient = origLight.OutdoorAmbient
        Lighting.FogStart = origLight.FogStart; Lighting.FogEnd = origLight.FogEnd
    end
end

-- FOV
local fovEnabled = false
local fovVal = 80
local fovOrig = 70

function FOV_Enable() fovEnabled = true; if workspace.CurrentCamera then fovOrig = workspace.CurrentCamera.FieldOfView end end
function FOV_Disable() fovEnabled = false; if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = fovOrig end end
RunService.RenderStepped:Connect(function() if fovEnabled and workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = fovVal end end)

-- NO FAIL LOCKPICK
local noFailLPEnabled = false
local noFailLPConn = nil

function NoFailLP_Enable()
    if noFailLPEnabled then return end
    noFailLPEnabled = true
    noFailLPConn = PlayerGui.ChildAdded:Connect(function(item)
        if item.Name == "LockpickGUI" then
            task.wait(0.1)
            pcall(function()
                local frames = item.MF.LP_Frame.Frames
                for _, bn in pairs({"B1", "B2", "B3"}) do
                    local bar = frames:FindFirstChild(bn)
                    if bar and bar:FindFirstChild("Bar") then
                        local uis = bar.Bar:FindFirstChild("UIScale")
                        if uis then uis.Scale = 10 end
                    end
                end
            end)
        end
    end)
end

function NoFailLP_Disable() noFailLPEnabled = false; if noFailLPConn then noFailLPConn:Disconnect(); noFailLPConn = nil end end

-- SAFE ESP
local safeESPEnabled = false
local safeESPConn = nil

local function safeESPUpdate()
    local folder = Workspace.Map and Workspace.Map:FindFirstChild("BredMakurz") or Workspace:FindFirstChild("BredMakurz")
    if not folder then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local myPos = char.HumanoidRootPart.Position
    for _, obj in pairs(folder:GetChildren()) do
        local pp = obj.PrimaryPart
        local part = (pp and pp:IsA("BasePart")) and pp or obj:FindFirstChildOfClass("BasePart")
        if part then
            local dist = (part.Position - myPos).magnitude
            local exist = obj:FindFirstChild("SantesSE")
            if dist <= 200 then
                if not exist then
                    local bg = Instance.new("BillboardGui")
                    bg.Name = "SantesSE"; bg.AlwaysOnTop = true
                    bg.Size = UDim2.new(8, 0, 4, 0); bg.MaxDistance = 200
                    bg.Adornee = obj; bg.Parent = obj
                    local tl = Instance.new("TextLabel", bg)
                    tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1
                    tl.Font = Enum.Font.SourceSansBold; tl.TextSize = 15
                    tl.Text = obj.Name:gsub("([a-z])([A-Z])", "%1 %2"):gsub("_.*", "")
                    local values = obj:FindFirstChild("Values")
                    local broken = values and values:FindFirstChild("Broken")
                    if broken and broken:IsA("BoolValue") then
                        tl.TextColor3 = broken.Value and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
                        broken:GetPropertyChangedSignal("Value"):Connect(function()
                            if tl and tl.Parent then
                                tl.TextColor3 = broken.Value and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
                            end
                        end)
                    else tl.TextColor3 = Color3.new(0, 1, 0) end
                end
            elseif exist then exist:Destroy() end
        end
    end
end

function SafeESP_Enable() if safeESPEnabled then return end; safeESPEnabled = true; safeESPConn = RunService.Heartbeat:Connect(safeESPUpdate) end
function SafeESP_Disable()
    safeESPEnabled = false; if safeESPConn then safeESPConn:Disconnect(); safeESPConn = nil end
    local folder = Workspace.Map and Workspace.Map:FindFirstChild("BredMakurz") or Workspace:FindFirstChild("BredMakurz")
    if folder then for _, obj in pairs(folder:GetChildren()) do local esp = obj:FindFirstChild("SantesSE"); if esp then esp:Destroy() end end end
end

-- AUTO LOCKPICK
local autoLockpickEnabled = false
local autoLockpickConn = nil
local lockpickCD = false
local lastSafe = nil

function AutoLockpick_Enable()
    if autoLockpickEnabled then return end
    autoLockpickEnabled = true
    autoLockpickConn = RunService.Heartbeat:Connect(function()
        if not autoLockpickEnabled or lockpickCD then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local lpTool = char:FindFirstChild("Lockpick")
        if not lpTool then
            local bp = LocalPlayer:FindFirstChild("Backpack")
            if bp then
                for _, item in pairs(bp:GetChildren()) do
                    if item.Name == "Lockpick" then lpTool = item; break end
                end
            end
        end
        if not lpTool then return end
        
        if not char:FindFirstChild(lpTool.Name) then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum:EquipTool(lpTool) end) end
            return
        end
        
        local folder = Workspace.Map and Workspace.Map:FindFirstChild("BredMakurz") or Workspace:FindFirstChild("BredMakurz")
        if not folder then return end
        
        local nearestDist = 3
        local nearestSafe = nil
        local nearestPart = nil
        
        for _, obj in pairs(folder:GetChildren()) do
            if obj ~= lastSafe and (string.find(obj.Name, "Safe") or string.find(obj.Name, "Register")) then
                local mp = obj:FindFirstChild("MainPart") or obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
                if mp then
                    local dist = (hrp.Position - mp.Position).Magnitude
                    if dist < nearestDist then
                        local values = obj:FindFirstChild("Values")
                        if values then
                            local broken = values:FindFirstChild("Broken")
                            if broken and broken:IsA("BoolValue") and not broken.Value then
                                nearestDist = dist; nearestSafe = obj; nearestPart = mp
                            end
                        end
                    end
                end
            end
        end
        
        if not nearestSafe then return end
        
        lockpickCD = true; lastSafe = nearestSafe
        
        local events = ReplicatedStorage:FindFirstChild("Events")
        if events and nearestPart then
            local r1 = events:FindFirstChild("XMHH.2")
            local r2 = events:FindFirstChild("XMHH2.2")
            if r1 and r2 then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    local result = r1:InvokeServer("\240\159\141\158", tick(), tool, "DZDRRRKI", nearestSafe, "Register")
                    if result then
                        r2:FireServer("\240\159\141\158", tick(), tool, "2389ZFX34", result, false, char:FindFirstChild("Right Arm") or hrp, nearestPart, nearestSafe, nearestPart.Position, nearestPart.Position)
                    end
                end
            end
            local lpEvent = events:FindFirstChild("LockpickStart") or events:FindFirstChild("StartLockpick")
            if lpEvent then pcall(function() lpEvent:FireServer(nearestSafe, nearestPart) end) end
        end
        
        task.wait(0.05)
        local lpGUI = PlayerGui:FindFirstChild("LockpickGUI")
        if lpGUI then
            for _ = 1, 30 do
                pcall(function()
                    local frames = lpGUI.MF.LP_Frame.Frames
                    for _, bn in pairs({"B1", "B2", "B3"}) do
                        local bar = frames:FindFirstChild(bn)
                        if bar and bar:FindFirstChild("Bar") then
                            local uis = bar.Bar:FindFirstChild("UIScale")
                            if uis then uis.Scale = 20 end
                        end
                    end
                end)
                if not lpGUI.Parent then break end
                task.wait(0.02)
            end
        end
        
        task.wait(0.3)
        lockpickCD = false
    end)
end

function AutoLockpick_Disable()
    autoLockpickEnabled = false; lockpickCD = false; lastSafe = nil
    if autoLockpickConn then autoLockpickConn:Disconnect(); autoLockpickConn = nil end
end

-- AUTO PICKUP
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
        local folder = Workspace.Filter and Workspace.Filter:FindFirstChild("SpawnedBread") or Workspace:FindFirstChild("SpawnedBread")
        if not folder then return end
        local remote = ReplicatedStorage.Events and ReplicatedStorage.Events:FindFirstChild("CZDPZUS")
        if not remote then return end
        for _, bread in pairs(folder:GetChildren()) do
            if bread:IsA("BasePart") and (hrp.Position - bread.Position).Magnitude < 5 then
                pickupCD = true; pcall(function() remote:FireServer(bread) end)
                task.wait(1); pickupCD = false; break
            end
        end
    end)
end

function AutoPickup_Disable()
    autoPickupEnabled = false; pickupCD = false
    if autoPickupConn then autoPickupConn:Disconnect(); autoPickupConn = nil end
end

-- AUTO DOORS
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
            local db = door:FindFirstChild("DoorBase")
            if db and (hrp.Position - db.Position).Magnitude <= 6 then
                local vals = door:FindFirstChild("Values")
                local evs = door:FindFirstChild("Events")
                if vals and evs then
                    local tog = evs:FindFirstChild("Toggle")
                    if tog then
                        local lock = vals:FindFirstChild("Locked"); local lp = door:FindFirstChild("Lock")
                        if lock and lp and lock.Value == true then pcall(function() tog:FireServer("Unlock", lp) end) end
                        local op = vals:FindFirstChild("Open"); local kn = door:FindFirstChild("Knob2") or door:FindFirstChild("Knob")
                        if op and kn and op.Value == false then pcall(function() tog:FireServer("Open", kn) end) end
                    end
                end
            end
        end
    end)
end

function UnlockDoors_Disable() unlockDoorsEnabled = false; if unlockDoorsConn then unlockDoorsConn:Disconnect(); unlockDoorsConn = nil end end

-- ADMIN DETECTOR
local adminCheckEnabled = false
local adminCheckConn = nil
local staffUsers = {
    3294804378, 93676120, 54087314, 81275825, 140837601, 1229486091, 46567801, 418086275,
    29706395, 3717066084, 1424338327, 5046662686, 63238912, 111250044, 63315426, 730176906,
    141193516, 194512073, 193945439, 412741116, 195538733, 102045519, 955294, 957835150,
    25689921, 366613818, 281593651, 455275714, 208929505, 96783330, 156152502, 93281166,
    959606619, 142821118, 632886139, 175931803, 122209625, 278097946, 142989311, 1517131734,
    446849296, 87189764, 67180844, 9212846, 47352513, 48058122, 155413858, 10497435,
    513615792, 55893752, 55476024, 151691292, 136584758, 16983447, 3111449, 94693025,
    271400893, 5005262660, 295331237, 64489098, 244844600, 114332275, 25048901, 69262878,
    50801509, 92504899, 42066711, 50585425, 31365111, 166406495, 2457253857, 29761878,
    21831137, 948293345, 439942262, 38578487, 1163048, 7713309208, 3659305297, 15598614,
    34616594, 626833004, 198610386, 153835477, 3923114296, 3937697838, 102146039, 119861460,
    371665775, 1206543842, 93428604, 1863173316, 90814576, 374665997, 423005063, 140172831,
    42662179, 9066859, 438805620, 14855669, 727189337, 1871290386, 608073286
}

local function checkStaff(p)
    if p == LocalPlayer then return false end
    for _, uid in pairs(staffUsers) do
        if p.UserId == uid then pcall(function() LocalPlayer:Kick("SANTES: Staff - " .. p.Name) end); return true end
    end
    return false
end

function AdminCheck_Enable() if adminCheckEnabled then return end; adminCheckEnabled = true; for _, p in pairs(Players:GetPlayers()) do if checkStaff(p) then return end end; adminCheckConn = Players.PlayerAdded:Connect(checkStaff) end
function AdminCheck_Disable() adminCheckEnabled = false; if adminCheckConn then adminCheckConn:Disconnect(); adminCheckConn = nil end end

-- PLAYER ESP
local espEnabled = false
local espConns = {}
local espList = {}

local function espCreate(p)
    if p == LocalPlayer or espList[p] then return end; espList[p] = true
    local function setup(c)
        if not espEnabled or not c or not c.Parent then return end
        local hl = Instance.new("Highlight")
        hl.Name = "SantesESP"; hl.FillColor = Color3.fromRGB(255, 0, 0)
        hl.FillTransparency = 0.65; hl.OutlineColor = Color3.fromRGB(255, 40, 40)
        hl.OutlineTransparency = 0; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = c
        local hd = c:FindFirstChild("Head")
        if hd then
            local bg = Instance.new("BillboardGui")
            bg.Name = "SantesESPInfo"; bg.Size = UDim2.new(0, 100, 0, 30)
            bg.StudsOffset = Vector3.new(0, 2.5, 0); bg.AlwaysOnTop = true; bg.Parent = hd
            local nl = Instance.new("TextLabel")
            nl.Size = UDim2.new(1, 0, 1, 0); nl.BackgroundTransparency = 1
            nl.Text = p.Name; nl.TextColor3 = Color3.new(1, 1, 1)
            nl.Font = Enum.Font.GothamBold; nl.TextSize = 12; nl.Parent = bg
        end
    end
    if p.Character then setup(p.Character) end
    table.insert(espConns, p.CharacterAdded:Connect(setup))
end

function ESP_Enable() if espEnabled then return end; espEnabled = true; espList = {}; for _, p in pairs(Players:GetPlayers()) do espCreate(p) end; table.insert(espConns, Players.PlayerAdded:Connect(function(p) if espEnabled then espCreate(p) end end)); table.insert(espConns, Players.PlayerRemoving:Connect(function(p) espList[p] = nil end)) end
function ESP_Disable() espEnabled = false; for _, c in pairs(espConns) do pcall(function() c:Disconnect() end) end; espConns = {}; espList = {}; for _, p in pairs(Players:GetPlayers()) do pcall(function() if p.Character then local h = p.Character:FindFirstChild("SantesESP"); if h then h:Destroy() end; for _, v in pairs(p.Character:GetDescendants()) do if v:IsA("BillboardGui") and v.Name == "SantesESPInfo" then v:Destroy() end end end end) end end

-- INVISIBILITY
local invisEnabled = false; local invisUsable = true; local invisTrack = nil
local invisChar = nil; local invisHum = nil; local invisHRP = nil; local invisWarn = nil

do
    local anim = Instance.new("Animation"); anim.AnimationId = "rbxassetid://215384594"
    local function updR() invisChar = LocalPlayer.Character; invisHum = invisChar and invisChar:FindFirstChildOfClass("Humanoid"); invisHRP = invisChar and invisChar:FindFirstChild("HumanoidRootPart") end
    local function grd() return invisHum and invisHum:IsDescendantOf(Workspace) and invisHum.FloorMaterial ~= Enum.Material.Air end
    local function ldT() if invisTrack then pcall(function() invisTrack:Stop() end); invisTrack = nil end; if invisHum then local s, r = pcall(function() return invisHum:LoadAnimation(anim) end); if s then invisTrack = r; invisTrack.Priority = Enum.AnimationPriority.Action4 end end end
    
    RunService.Heartbeat:Connect(function(dt)
        if not invisEnabled or not invisUsable then
            if not invisEnabled and invisChar then for _, v in pairs(invisChar:GetDescendants()) do if v:IsA("BasePart") and v.Transparency == 0.5 then v.Transparency = 0 end end end
            if invisWarn then invisWarn.Visible = false end; return
        end
        if not invisChar or not invisHum or not invisHRP or invisHum.Health <= 0 then if invisWarn then invisWarn.Visible = false end; return end
        if invisWarn then invisWarn.Visible = not grd() end
        if invisHum.MoveDirection.Magnitude > 0 then invisHRP.CFrame += invisHum.MoveDirection * 12 * dt end
        local oldCF = invisHRP.CFrame; local oldOff = invisHum.CameraOffset
        local _, y = workspace.CurrentCamera.CFrame:ToOrientation()
        invisHRP.CFrame = CFrame.new(invisHRP.Position) * CFrame.fromOrientation(0, y, 0) * CFrame.Angles(math.rad(90), 0, 0)
        invisHum.CameraOffset = Vector3.new(0, 1.44, 0)
        if invisTrack then pcall(function() if not invisTrack.IsPlaying then invisTrack:Play() end; invisTrack:AdjustSpeed(0); invisTrack.TimePosition = 0.3 end) elseif invisHum.Health > 0 then ldT() end
        RunService.RenderStepped:Wait()
        if invisHum:IsDescendantOf(Workspace) then invisHum.CameraOffset = oldOff end
        if invisHRP:IsDescendantOf(Workspace) then invisHRP.CFrame = oldCF end
        if invisTrack then pcall(function() invisTrack:Stop() end) end
        if invisHRP:IsDescendantOf(Workspace) then local lv = workspace.CurrentCamera.CFrame.LookVector; local fl = Vector3.new(lv.X, 0, lv.Z).Unit; if fl.Magnitude > 0.1 then invisHRP.CFrame = CFrame.new(invisHRP.Position, invisHRP.Position + fl) end end
        for _, v in pairs(invisChar:GetDescendants()) do if v:IsA("BasePart") and v.Transparency ~= 1 then v.Transparency = 0.5 end end
    end)
    
    LocalPlayer.CharacterAdded:Connect(function()
        if invisTrack then pcall(function() invisTrack:Stop() end); invisTrack = nil end; task.wait(); updR()
        if invisHum and invisHum.RigType ~= Enum.HumanoidRigType.R6 then invisUsable = false; if invisEnabled then Invis_Disable() end
        else invisUsable = true; if invisEnabled then workspace.CurrentCamera.CameraSubject = invisHRP; ldT() end end
    end)
    updR(); if invisHum and invisHum.RigType ~= Enum.HumanoidRigType.R6 then invisUsable = false end
    
    local invisGUI = Instance.new("ScreenGui"); invisGUI.Name = "InvisWarning"; invisGUI.Parent = CoreGui; invisGUI.ResetOnSpawn = false
    invisWarn = Instance.new("TextLabel", invisGUI); invisWarn.Text = "VISIBLE!"; invisWarn.Visible = false
    invisWarn.Size = UDim2.new(0, 200, 0, 30); invisWarn.Position = UDim2.new(0.5, -100, 0.85, 0)
    invisWarn.BackgroundTransparency = 1; invisWarn.Font = Enum.Font.GothamBold; invisWarn.TextSize = 24
    invisWarn.TextColor3 = Color3.fromRGB(255, 255, 0); invisWarn.TextStrokeTransparency = 0.5
    
    _G.Invis_Enable = function() if invisEnabled or not invisUsable then return end; invisEnabled = true; updR(); if invisHRP then workspace.CurrentCamera.CameraSubject = invisHRP end; ldT() end
    _G.Invis_Disable = function() if not invisEnabled then return end; invisEnabled = false; if invisTrack then pcall(function() invisTrack:Stop() end) end; if invisHum then workspace.CurrentCamera.CameraSubject = invisHum end; if invisChar then for _, v in pairs(invisChar:GetDescendants()) do if v:IsA("BasePart") and v.Transparency == 0.5 then v.Transparency = 0 end end end; if invisWarn then invisWarn.Visible = false end end
    _G.IsInvisEnabled = function() return invisEnabled end
end

function Invis_Enable() _G.Invis_Enable() end
function Invis_Disable() _G.Invis_Disable() end

-- NO RECOIL
local noRecoilEnabled = false
local noRecoilTask = nil

function NoRecoil_Enable()
    if noRecoilEnabled then return end
    noRecoilEnabled = true
    noRecoilTask = task.spawn(function()
        while noRecoilEnabled do
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == 'table' then
                        if rawget(v, 'Recoil') ~= nil then v.Recoil = 0; v.Spread = 0; v.CameraRecoilingEnabled = false end
                        if rawget(v, 'AngleX_Min') ~= nil then v.AngleX_Min = 0; v.AngleX_Max = 0; v.AngleY_Min = 0; v.AngleY_Max = 0; v.AngleZ_Min = 0; v.AngleZ_Max = 0 end
                    end
                end
            end)
            task.wait(1)
        end
    end)
end

function NoRecoil_Disable() noRecoilEnabled = false; if noRecoilTask then task.cancel(noRecoilTask); noRecoilTask = nil end end

-- SILENT AIM
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
        local sc = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        local cp = nil
        local cd = silentAimFOV
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                local tp = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and tp then
                    local sp, on = cam:WorldToViewportPoint(tp.Position)
                    if on then
                        local d = (Vector2.new(sp.X, sp.Y) - sc).Magnitude
                        if d < cd then cd = d; cp = player end
                    end
                end
            end
        end
        if cp and cp.Character then
            local tp = cp.Character:FindFirstChild("Head") or cp.Character:FindFirstChild("HumanoidRootPart")
            if tp then
                local hb = tp:FindFirstChild("SantesHitbox")
                if not hb then
                    local nh = Instance.new("Part")
                    nh.Name = "SantesHitbox"; nh.Size = Vector3.new(5, 5, 5)
                    nh.Transparency = 1; nh.CanCollide = false; nh.Anchored = false; nh.Massless = true
                    nh.Parent = tp
                    local w = Instance.new("WeldConstraint"); w.Part0 = nh; w.Part1 = tp; w.Parent = nh
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

function SilentAim_SetFOV(v) silentAimFOV = math.clamp(v, 50, 500) end
function SilentAim_GetFOV() return silentAimFOV end

-- MELEE AURA
local meleeAuraEnabled = false
local meleeAuraConn = nil
local meleeTarget = "Head"

function MeleeAura_Enable()
    if meleeAuraEnabled then return end
    meleeAuraEnabled = true
    local evf = ReplicatedStorage:FindFirstChild("Events") or ReplicatedStorage:WaitForChild("Events", 10)
    if not evf then return end
    local r1 = evf:FindFirstChild("XMHH.2") or evf:WaitForChild("XMHH.2", 5)
    local r2 = evf:FindFirstChild("XMHH2.2") or evf:WaitForChild("XMHH2.2", 5)
    if not r1 or not r2 then return end
    
    meleeAuraConn = RunService.Heartbeat:Connect(function()
        if not meleeAuraEnabled then return end
        local myChar = LocalPlayer.Character
        if not myChar then return end
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        local tool = myChar:FindFirstChildOfClass("Tool")
        local ce = nil; local sd = 6
        for _, pl in pairs(Players:GetPlayers()) do
            if pl ~= LocalPlayer and pl.Character then
                local eHRP = pl.Character:FindFirstChild("HumanoidRootPart")
                local eHum = pl.Character:FindFirstChildOfClass("Humanoid")
                if eHRP and eHum and eHum.Health > 15 and not pl.Character:FindFirstChildOfClass("ForceField") then
                    local d = (myHRP.Position - eHRP.Position).Magnitude
                    if d < sd then sd = d; ce = pl end
                end
            end
        end
        if not ce then return end
        local tc = ce.Character; local tp = tc:FindFirstChild(meleeTarget)
        if not tp then return end
        local ft = tool or myChar:FindFirstChild("Right Arm") or myHRP
        local result = r1:InvokeServer("\240\159\141\158", tick(), ft, "43TRFWX", "Normal", tick(), true)
        if result then
            local h = (tool and (tool:FindFirstChild("WeaponHandle") or tool:FindFirstChild("Handle"))) or myChar:FindFirstChild("Right Arm")
            if h then r2:FireServer("\240\159\141\158", tick(), ft, "2389ZFX34", result, false, h, tp, tc, myHRP.Position, tp.Position) end
        end
        task.wait(0.08)
    end)
end

function MeleeAura_Disable() meleeAuraEnabled = false; if meleeAuraConn then meleeAuraConn:Disconnect(); meleeAuraConn = nil end end

-- INF STAMINA
local infStaminaEnabled = false
local infStaminaConn = nil

function InfiniteStamina_Enable()
    if infStaminaEnabled then return end
    infStaminaEnabled = true
    infStaminaConn = RunService.RenderStepped:Connect(function()
        if not infStaminaEnabled then return end
        local c = LocalPlayer.Character
        if not c then return end
        for _, hum in pairs(c:GetDescendants()) do
            if hum:IsA("Humanoid") and hum.MaxStamina and hum.Stamina then
                hum.Stamina = hum.MaxStamina
            end
        end
    end)
end

function InfiniteStamina_Disable() infStaminaEnabled = false; if infStaminaConn then infStaminaConn:Disconnect(); infStaminaConn = nil end end

-- AUTO FARM
local autoFarmEnabled = false
local autoFarmCoroutine = nil
local farmIgnored = {}

local function farmTP(pos)
    local c = LocalPlayer.Character; if not c then return false end
    local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return false end
    for i = 1, 4 do
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0)); task.wait(0.5)
        if hrp and hrp.Parent and (hrp.Position - pos).Magnitude < 5 then return true end
        task.wait(0.5)
    end
    return false
end

local function farmFindDealer()
    local shops = Workspace.Map and Workspace.Map:FindFirstChild("Shopz"); if not shops then return nil end
    local c = LocalPlayer.Character; if not c then return nil end
    local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return nil end
    local nearest, best = nil, math.huge
    for _, shop in pairs(shops:GetChildren()) do
        local main = shop:FindFirstChild("MainPart"); local stocks = shop:FindFirstChild("CurrentStocks")
        if main and stocks then
            local cs = stocks:FindFirstChild("Crowbar")
            if cs and cs.Value > 0 then
                local d = (main.Position - hrp.Position).Magnitude
                if d < best then best = d; nearest = shop end
            end
        end
    end
    return nearest
end

local function farmFindTarget()
    local folder = Workspace.Map and Workspace.Map:FindFirstChild("BredMakurz") or Workspace.Filter and Workspace.Filter:FindFirstChild("BredMakurz") or Workspace:FindFirstChild("BredMakurz")
    if not folder then return nil end
    local c = LocalPlayer.Character; if not c then return nil end
    local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return nil end
    local nearest, best = nil, math.huge
    for _, obj in pairs(folder:GetChildren()) do
        if (string.find(obj.Name, "Safe") or string.find(obj.Name, "Register")) and not table.find(farmIgnored, obj) then
            local values = obj:FindFirstChild("Values")
            if values then
                local broken = values:FindFirstChild("Broken")
                if broken and broken:IsA("BoolValue") and not broken.Value then
                    local tp = obj.PrimaryPart or obj:FindFirstChild("MainPart") or obj:FindFirstChildOfClass("BasePart")
                    if tp then
                        local d = (tp.Position - hrp.Position).Magnitude
                        if d < best then best = d; nearest = obj end
                    end
                end
            end
        end
    end
    return nearest
end

local function farmHasTool(n) local c = LocalPlayer.Character; if c and c:FindFirstChild(n) then return true end; local bp = LocalPlayer.Backpack; return bp and bp:FindFirstChild(n) ~= nil end

local function farmEquipTool(n)
    local c = LocalPlayer.Character; if not c then return false end
    local hum = c:FindFirstChildOfClass("Humanoid"); if not hum then return false end
    local t = c:FindFirstChild(n) or LocalPlayer.Backpack:FindFirstChild(n)
    if t then pcall(function() hum:EquipTool(t) end); task.wait(0.5); return true end
    return false
end

local function farmOpenSafe(safe)
    if not farmHasTool("Crowbar") then return end
    if not farmEquipTool("Crowbar") then return end
    local r1 = ReplicatedStorage.Events:FindFirstChild("XMHH.2")
    local r2 = ReplicatedStorage.Events:FindFirstChild("XMHH2.2")
    local sp = safe:FindFirstChild("MainPart")
    if not r1 or not r2 or not sp then return end
    local eq = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Crowbar")
    if not eq then return end
    local st = tick()
    while safe and safe.Parent and safe.Values and safe.Values:FindFirstChild("Broken") and not safe.Values.Broken.Value and (tick() - st < 20) do
        local c = LocalPlayer.Character; if not c then break end
        local res = r1:InvokeServer("\240\159\141\158", tick(), eq, "DZDRRRKI", safe, "Register")
        if res then r2:FireServer("\240\159\141\158", tick(), eq, "2389ZFX34", res, false, c["Right Arm"], sp, safe, sp.Position, sp.Position) end
        task.wait(0.2)
    end
    task.wait(8)
end

local function farmBuyCrowbar(dealer)
    if not dealer then return false end
    local main = dealer:FindFirstChild("MainPart"); if not main then return false end
    if not farmTP(main.Position) then return false end
    task.wait(1)
    local be = ReplicatedStorage.Events:FindFirstChild("BYZERSPROTEC")
    local se = ReplicatedStorage.Events:FindFirstChild("SSHPRMTE1")
    if not be or not se then return false end
    be:FireServer(true, "shop", main, "IllegalStore"); task.wait(1)
    se:InvokeServer("IllegalStore", "Melees", "Crowbar", main, nil, true); task.wait(2)
    be:FireServer(false)
    return farmHasTool("Crowbar")
end

local function farmLoop()
    while autoFarmEnabled do
        task.wait(1)
        local c = LocalPlayer.Character; local hum = c and c:FindFirstChildOfClass("Humanoid")
        if not c or not hum or hum.Health <= 0 then
            local de = ReplicatedStorage.Events:FindFirstChild("DeathRespawn")
            if de then pcall(function() de:InvokeServer("KMG4R904") end) end
            task.wait(3); farmIgnored = {}; continue
        end
        if not farmHasTool("Crowbar") then
            local d = farmFindDealer()
            if d then farmBuyCrowbar(d) else task.wait(5) end
            continue
        end
        local t = farmFindTarget()
        if t then
            local mp = t:FindFirstChild("MainPart") or t.PrimaryPart
            if mp then
                if farmTP(mp.Position) then task.wait(1); farmOpenSafe(t)
                else table.insert(farmIgnored, t); task.wait(0.5) end
            end
        else farmIgnored = {}; task.wait(5) end
    end
end

function AutoFarm_Enable()
    if autoFarmEnabled then return end
    autoFarmEnabled = true; farmIgnored = {}
    if autoFarmCoroutine then task.cancel(autoFarmCoroutine); autoFarmCoroutine = nil end
    AutoPickup_Enable(); Noclip_Enable()
    autoFarmCoroutine = task.spawn(farmLoop)
    LocalPlayer.CharacterAdded:Connect(function() if autoFarmEnabled then task.wait(2); AutoPickup_Enable(); Noclip_Enable() end end)
end

function AutoFarm_Disable()
    autoFarmEnabled = false
    if autoFarmCoroutine then task.cancel(autoFarmCoroutine); autoFarmCoroutine = nil end
    farmIgnored = {}; AutoPickup_Disable()
end

-- ==================== KATEGORI BUTONLARI ====================

local activeTab = nil
local tabBtns = {}
local tabContents = {}

local function makeTabBtn(name, icon)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, -12, 0, 36)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = side
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = C.card
    bg.BackgroundTransparency = 1
    bg.BorderSizePixel = 0
    bg.Parent = btn
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)
    
    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 24, 1, 0)
    iconLbl.Position = UDim2.new(0, 8, 0, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.TextSize = 14
    iconLbl.TextColor3 = C.text2
    iconLbl.Parent = btn
    
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -36, 1, 0)
    nameLbl.Position = UDim2.new(0, 34, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.Font = Enum.Font.GothamSemibold
    nameLbl.TextSize = 11
    nameLbl.TextColor3 = C.text2
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = btn
    
    tabBtns[name] = {btn = btn, bg = bg, icon = iconLbl, nameLbl = nameLbl}
    tabContents[name] = {}
    
    btn.MouseButton1Click:Connect(function()
        if activeTab == name then return end
        
        -- Eski aktif butonu sifirla
        if activeTab and tabBtns[activeTab] then
            local old = tabBtns[activeTab]
            TweenService:Create(old.bg, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            TweenService:Create(old.nameLbl, TweenInfo.new(0.2), {TextColor3 = C.text2}):Play()
        end
        
        -- Yeni butonu aktif yap
        TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        TweenService:Create(nameLbl, TweenInfo.new(0.2), {TextColor3 = C.accent}):Play()
        
        activeTab = name
        
        -- Content'i temizle
        for _, child in pairs(content:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        
        -- Icerikleri yukle
        if name == "Combat" then
            makeHeader("COMBAT")
            makeToggle("Silent Aim", true, function() return silentAimEnabled end, SilentAim_Enable, SilentAim_Disable)
            makeToggle("Melee Aura", true, function() return meleeAuraEnabled end, MeleeAura_Enable, MeleeAura_Disable)
            makeToggle("No Recoil", true, function() return noRecoilEnabled end, NoRecoil_Enable, NoRecoil_Disable)
        elseif name == "Movement" then
            makeHeader("MOVEMENT")
            makeToggle("Fly", true, function() return flyEnabled end, Fly_Enable, Fly_Disable)
            makeToggle("Noclip", true, function() return noclipEnabled end, Noclip_Enable, Noclip_Disable)
            makeToggle("Inf Stamina", true, function() return infStaminaEnabled end, InfiniteStamina_Enable, InfiniteStamina_Disable)
            makeToggle("Invisibility", true, _G.IsInvisEnabled, _G.Invis_Enable, _G.Invis_Disable)
        elseif name == "Visuals" then
            makeHeader("VISUALS")
            makeToggle("Player ESP", true, function() return espEnabled end, ESP_Enable, ESP_Disable)
            makeToggle("Safe ESP", true, function() return safeESPEnabled end, SafeESP_Enable, SafeESP_Disable)
            makeToggle("FullBright", true, function() return fullbrightEnabled end, FullBright_Enable, FullBright_Disable)
            makeToggle("FOV", true, function() return fovEnabled end, FOV_Enable, FOV_Disable)
        elseif name == "Farming" then
            makeHeader("FARMING")
            makeToggle("Auto Farm", true, function() return autoFarmEnabled end, AutoFarm_Enable, AutoFarm_Disable)
            makeToggle("Auto Pickup $", true, function() return autoPickupEnabled end, AutoPickup_Enable, AutoPickup_Disable)
            makeToggle("No Fail Lockpick", true, function() return noFailLPEnabled end, NoFailLP_Enable, NoFailLP_Disable)
            makeToggle("Auto Lockpick", true, function() return autoLockpickEnabled end, AutoLockpick_Enable, AutoLockpick_Disable)
        elseif name == "Misc" then
            makeHeader("MISC")
            makeToggle("Admin Detector", true, function() return adminCheckEnabled end, AdminCheck_Enable, AdminCheck_Disable)
            makeToggle("Auto Doors", true, function() return unlockDoorsEnabled end, UnlockDoors_Enable, UnlockDoors_Disable)
        end
        
        content.CanvasPosition = Vector2.new(0, 0)
        cl:GetPropertyChangedSignal("AbsoluteContentSize"):Fire()
    end)
    
    return btn
end

local function makeHeader(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -8, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextColor3 = C.accent
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = content
    return lbl
end

-- Tablari olustur
makeTabBtn("Combat", "⚔")
makeTabBtn("Movement", "🏃")
makeTabBtn("Visuals", "👁")
makeTabBtn("Farming", "💰")
makeTabBtn("Misc", "🔧")

-- Ilk sekmeyi ac
task.wait(0.1)
if tabBtns["Combat"] then
    tabBtns["Combat"].btn.MouseButton1Click:Fire()
end

print("SANTES HUB v3.2 Yuklendi!")
