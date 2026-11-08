--[[
    SANTES HUB  |  Criminality
    red / black  |  crimcorp
    K = show / hide
]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local WS = game:GetService("Workspace")
local RStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local VU = game:GetService("VirtualUser")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")
local Cam = WS.CurrentCamera
local Mouse = LP:GetMouse()

LP.Idled:Connect(function()
    VU:CaptureController()
    VU:ClickButton2(Vector2.new())
end)

local function clean(name)
    pcall(function()
        local a = PG:FindFirstChild(name)
        if a then a:Destroy() end
    end)
    pcall(function()
        local b = CoreGui:FindFirstChild(name)
        if b then b:Destroy() end
    end)
end

for _, n in ipairs({
    "SantesHub", "SantesESP", "SantesNotify", "VenomHubScreenGui",
    "VenomHubScreenGui_Categorized", "KeyVerificationUI", "ShadowWarningHUD", "InvisWarningGUI"
}) do
    clean(n)
end

local T = {
    Bg      = Color3.fromRGB(9, 9, 11),
    Panel   = Color3.fromRGB(18, 13, 15),
    Row     = Color3.fromRGB(24, 17, 19),
    Row2    = Color3.fromRGB(31, 21, 24),
    Accent  = Color3.fromRGB(226, 32, 50),
    Accent2 = Color3.fromRGB(122, 14, 26),
    Stroke  = Color3.fromRGB(92, 22, 32),
    Text    = Color3.fromRGB(238, 231, 231),
    Dim     = Color3.fromRGB(158, 132, 137),
    Off     = Color3.fromRGB(56, 34, 39),
    Good    = Color3.fromRGB(64, 208, 122),
}

local H = {
    Theme = T,
    Flags = {},
    Aim = {
        Fov = 140, Smooth = 0.15, Part = "Head",
        Sticky = true, Wall = true, Team = false,
        Target = nil, Holding = false,
        Bind = Enum.UserInputType.MouseButton2,
    },
    Silent = { Enabled = false, Target = nil, Last = 0, Hooked = false },
    Gun = { NoRecoil = false, NoSpread = false, Cache = {}, Orig = {}, Running = false },
    ESP = { Enabled = false, Gui = nil, Holder = nil, Objs = {}, Conns = {} },
    SafeESP = { Enabled = false },
    Pickup = { Enabled = false },
    Doors = { Open = false, Unlock = false, Running = false },
    Lockpick = { Enabled = false, Conn = nil },
    Fly = { Enabled = false, Speed = 55, Conn = nil },
    Noclip = { Enabled = false, Orig = {}, Conn = nil },
    Stamina = { Enabled = false, Orig = nil },
    Melee = { Enabled = false },
    Rage = { Enabled = false, Range = 200 },
    Invis = { Enabled = false },
    Fullbright = { Enabled = false, Orig = nil },
    FovCircle = { Draw = nil, Enabled = false },
    CamFov = 70,
    Move = { Walk = 16, Jump = 50 },
    Keys = {},
    Binds = {},
    BindCapture = nil,
    NotifyCount = 0,
    F = {},
    Skin = {
        Enabled = false,
        Index = 1,
        Orig = setmetatable({}, { __mode = "k" }),
        List = {
            { Name = "Default", Color = nil, Material = nil, Texture = nil },
            { Name = "Crimson", Color = Color3.fromRGB(138, 0, 12), Material = Enum.Material.Metal },
            { Name = "Gold", Color = Color3.fromRGB(255, 190, 42), Material = Enum.Material.Metal },
            { Name = "Diamond", Color = Color3.fromRGB(138, 228, 255), Material = Enum.Material.Glass },
            { Name = "Neon", Color = Color3.fromRGB(255, 22, 78), Material = Enum.Material.Neon },
            { Name = "Galaxy", Color = Color3.fromRGB(74, 24, 150), Material = Enum.Material.Foil },
            { Name = "Ice", Color = Color3.fromRGB(168, 232, 255), Material = Enum.Material.Ice },
            { Name = "Blood", Color = Color3.fromRGB(92, 0, 4), Material = Enum.Material.Granite },
            { Name = "Obsidian", Color = Color3.fromRGB(14, 14, 18), Material = Enum.Material.Basalt },
            { Name = "Toxic", Color = Color3.fromRGB(96, 255, 46), Material = Enum.Material.Neon },
            { Name = "Rainbow", Color = nil, Material = Enum.Material.Neon, Rainbow = true },
        },
    },
}

--[[ UI SCAFFOLD ]]

local gui = Instance.new("ScreenGui")
gui.Name = "SantesHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
gui.Parent = PG

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 470, 0, 380)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = T.Bg
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Active = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = T.Accent2
mainStroke.Thickness = 1.4
mainStroke.Transparency = 0.15
mainStroke.Parent = main

local topBar = Instance.new("Frame")
topBar.Name = "AccentBar"
topBar.Size = UDim2.new(1, 0, 0, 2)
topBar.BackgroundColor3 = T.Accent
topBar.BorderSizePixel = 0
topBar.Parent = main

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -80, 0, 30)
title.Position = UDim2.new(0, 18, 0, 8)
title.BackgroundTransparency = 1
title.RichText = true
title.Text = '<font color="#E22032">SANTES</font> HUB'
title.Font = Enum.Font.GothamBlack
title.TextSize = 21
title.TextColor3 = T.Text
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -80, 0, 16)
subtitle.Position = UDim2.new(0, 19, 0, 33)
subtitle.BackgroundTransparency = 1
subtitle.Text = "criminality  //  crimcorp"
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 10
subtitle.TextColor3 = T.Dim
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = main

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -36, 0, 11)
closeBtn.BackgroundColor3 = T.Row
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.TextColor3 = T.Text
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.Parent = main

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

local headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1, -36, 0, 1)
headerLine.Position = UDim2.new(0, 18, 0, 54)
headerLine.BackgroundColor3 = T.Stroke
headerLine.BorderSizePixel = 0
headerLine.Parent = main

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 130, 1, -92)
sidebar.Position = UDim2.new(0, 10, 0, 62)
sidebar.BackgroundColor3 = T.Panel
sidebar.BorderSizePixel = 0
sidebar.Parent = main

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 9)
sideCorner.Parent = sidebar

local sidePad = Instance.new("UIPadding")
sidePad.PaddingTop = UDim.new(0, 6)
sidePad.PaddingLeft = UDim.new(0, 5)
sidePad.PaddingRight = UDim.new(0, 5)
sidePad.Parent = sidebar

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 5)
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideLayout.Parent = sidebar

local content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.Size = UDim2.new(1, -154, 1, -92)
content.Position = UDim2.new(0, 144, 0, 62)
content.BackgroundColor3 = T.Panel
content.BorderSizePixel = 0
content.ScrollingDirection = Enum.ScrollingDirection.Y
content.ScrollBarThickness = 4
content.ScrollBarImageColor3 = T.Accent2
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.Parent = main

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 9)
contentCorner.Parent = content

local contentPad = Instance.new("UIPadding")
contentPad.PaddingTop = UDim.new(0, 7)
contentPad.PaddingLeft = UDim.new(0, 7)
contentPad.PaddingRight = UDim.new(0, 3)
contentPad.PaddingBottom = UDim.new(0, 7)
contentPad.Parent = content

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 6)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = content

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -24, 0, 18)
footer.Position = UDim2.new(0, 14, 1, -23)
footer.BackgroundTransparency = 1
footer.Text = "K  toggle   //   crimcorp"
footer.Font = Enum.Font.Gotham
footer.TextSize = 10
footer.TextColor3 = T.Dim
footer.TextXAlignment = Enum.TextXAlignment.Right
footer.Parent = main

--[[ UI HELPERS ]]

local function mk(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props) do
        o[k] = v
    end
    if parent then o.Parent = parent end
    return o
end

local function corner(o, r)
    mk("UICorner", { CornerRadius = UDim.new(0, r or 8) }, o)
end

local function stroke(o, c, th, tr)
    mk("UIStroke", {
        Color = c or T.Stroke,
        Thickness = th or 1,
        Transparency = tr or 0.4,
    }, o)
end

local notifyGui = Instance.new("ScreenGui")
notifyGui.Name = "SantesNotify"
notifyGui.ResetOnSpawn = false
notifyGui.IgnoreGuiInset = true
notifyGui.DisplayOrder = 1000
pcall(function() notifyGui.Parent = CoreGui end)
if not notifyGui.Parent then notifyGui.Parent = PG end

local function notify(titleText, body)
    local idx = H.NotifyCount
    H.NotifyCount = H.NotifyCount + 1

    local f = mk("Frame", {
        Size = UDim2.new(0, 240, 0, 50),
        Position = UDim2.new(0.5, -120, 0, 18 + idx * 56),
        BackgroundColor3 = T.Panel,
        BorderSizePixel = 0,
    }, notifyGui)
    corner(f, 8)
    stroke(f, T.Accent2, 1, 0.1)

    local bar = mk("Frame", {
        Size = UDim2.new(0, 3, 1, -12),
        Position = UDim2.new(0, 8, 0, 6),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
    }, f)
    corner(bar, 2)

    local t = mk("TextLabel", {
        Size = UDim2.new(1, -28, 0, 18),
        Position = UDim2.new(0, 18, 0, 7),
        BackgroundTransparency = 1,
        Text = titleText,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = T.Accent,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, f)

    local b = mk("TextLabel", {
        Size = UDim2.new(1, -28, 0, 18),
        Position = UDim2.new(0, 18, 0, 25),
        BackgroundTransparency = 1,
        Text = body,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextColor3 = T.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, f)

    task.delay(3, function()
        if not f.Parent then return end
        TS:Create(f, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
        TS:Create(t, TweenInfo.new(0.25), { TextTransparency = 1 }):Play()
        TS:Create(b, TweenInfo.new(0.25), { TextTransparency = 1 }):Play()
        task.wait(0.3)
        f:Destroy()
        H.NotifyCount = math.max(0, H.NotifyCount - 1)
    end)
end

local function keyOf(name)
    return function() return H.Keys[name] end,
           function(v) H.Keys[name] = v end
end

local function createToggle(name, canToggle, getState, onEnable, onDisable, getBind, setBind)
    local row = mk("Frame", {
        Name = name:gsub("%s+", ""),
        Size = UDim2.new(1, -14, 0, 38),
        BackgroundColor3 = T.Row,
        BorderSizePixel = 0,
    })
    corner(row, 8)
    stroke(row, T.Stroke, 1, 0.6)

    local label = mk("TextLabel", {
        Size = UDim2.new(1, -158, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = "  " .. name,
        Font = Enum.Font.GothamSemibold,
        TextSize = 13,
        TextColor3 = T.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)

    local toggle = mk("TextButton", {
        Size = UDim2.new(0, 54, 0, 24),
        Position = UDim2.new(1, -62, 0.5, -12),
        BackgroundColor3 = T.Off,
        Text = "OFF",
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextColor3 = T.Text,
        BorderSizePixel = 0,
        AutoButtonColor = false,
    }, row)
    corner(toggle, 6)
    stroke(toggle, T.Stroke, 1, 0.4)

    local bind, bindStroke
    if getBind and setBind then
        bind = mk("TextButton", {
            Size = UDim2.new(0, 50, 0, 24),
            Position = UDim2.new(1, -118, 0.5, -12),
            BackgroundColor3 = T.Row2,
            Text = "BIND",
            Font = Enum.Font.GothamMedium,
            TextSize = 9,
            TextColor3 = T.Dim,
            BorderSizePixel = 0,
            AutoButtonColor = false,
        }, row)
        corner(bind, 6)
        bindStroke = mk("UIStroke", { Color = T.Stroke, Thickness = 1, Transparency = 0.5 }, bind)
    end

    local function update()
        local on = false
        if getState then
            local ok, res = pcall(getState)
            if ok then on = res end
        end
        if not canToggle then
            toggle.Text = "RUN"
            toggle.BackgroundColor3 = T.Accent2
        elseif on then
            toggle.Text = "ON"
            toggle.BackgroundColor3 = T.Accent
        else
            toggle.Text = "OFF"
            toggle.BackgroundColor3 = T.Off
        end
        if bind then
            local k = getBind and getBind()
            bind.Text = k and ("[" .. k.Name .. "]") or "BIND"
            bind.TextColor3 = k and T.Text or T.Dim
        end
    end

    toggle.MouseEnter:Connect(function()
        TS:Create(toggle, TweenInfo.new(0.1), { BackgroundColor3 = (getState and getState()) and T.Accent:Lerp(Color3.new(1, 1, 1), 0.15) or T.Off:Lerp(Color3.new(1, 1, 1), 0.12) }):Play()
    end)
    toggle.MouseLeave:Connect(function()
        update()
    end)

    toggle.MouseButton1Click:Connect(function()
        if not canToggle then
            if onEnable then pcall(onEnable) end
            update()
            return
        end
        local on = false
        if getState then
            local ok, res = pcall(getState)
            if ok then on = res end
        end
        if on then
            if onDisable then pcall(onDisable) end
        else
            if onEnable then pcall(onEnable) end
        end
        update()
    end)

    if bind then
        bind.MouseEnter:Connect(function()
            TS:Create(bind, TweenInfo.new(0.1), { BackgroundColor3 = T.Row2:Lerp(Color3.new(1, 1, 1), 0.08) }):Play()
        end)
        bind.MouseLeave:Connect(function()
            TS:Create(bind, TweenInfo.new(0.1), { BackgroundColor3 = T.Row2 }):Play()
        end)
        bind.MouseButton1Click:Connect(function()
            H.BindCapture = {
                get = getBind, set = setBind,
                on = onEnable, off = onDisable,
                can = canToggle, update = update,
            }
            bind.Text = "..."
        end)
        local old = getBind()
        if old then
            H.Binds[old] = {
                get = getState, on = onEnable, off = onDisable,
                can = canToggle, update = update,
            }
        end
    end

    update()
    return row, update
end

local function createBind(name, getBind, setBind)
    local row = mk("Frame", {
        Name = name:gsub("%s+", ""),
        Size = UDim2.new(1, -14, 0, 38),
        BackgroundColor3 = T.Row,
        BorderSizePixel = 0,
    })
    corner(row, 8)
    stroke(row, T.Stroke, 1, 0.6)

    mk("TextLabel", {
        Size = UDim2.new(1, -140, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = "  " .. name,
        Font = Enum.Font.GothamSemibold,
        TextSize = 13,
        TextColor3 = T.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)

    local btn = mk("TextButton", {
        Size = UDim2.new(0, 110, 0, 24),
        Position = UDim2.new(1, -118, 0.5, -12),
        BackgroundColor3 = T.Row2,
        Text = "BIND",
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextColor3 = T.Dim,
        BorderSizePixel = 0,
        AutoButtonColor = false,
    }, row)
    corner(btn, 6)
    stroke(btn, T.Stroke, 1, 0.45)

    local function update()
        local k = getBind()
        btn.Text = k and ("[" .. k.Name .. "]") or "BIND"
        btn.TextColor3 = k and T.Text or T.Dim
    end

    btn.MouseEnter:Connect(function()
        TS:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = T.Row2:Lerp(Color3.new(1, 1, 1), 0.08) }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TS:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = T.Row2 }):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        H.BindCapture = { kind = "input", get = getBind, set = setBind, update = update }
        btn.Text = "..."
    end)

    update()
    return row, update
end

local function createSlider(name, minv, maxv, default, suffix, onChange)
    local row = mk("Frame", {
        Name = name:gsub("%s+", ""),
        Size = UDim2.new(1, -14, 0, 52),
        BackgroundColor3 = T.Row,
        BorderSizePixel = 0,
    })
    corner(row, 8)
    stroke(row, T.Stroke, 1, 0.6)

    mk("TextLabel", {
        Size = UDim2.new(1, -100, 0, 20),
        Position = UDim2.new(0, 12, 0, 5),
        BackgroundTransparency = 1,
        Text = name,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        TextColor3 = T.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)

    local val = mk("TextLabel", {
        Size = UDim2.new(0, 80, 0, 20),
        Position = UDim2.new(1, -92, 0, 5),
        BackgroundTransparency = 1,
        Text = "",
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = T.Accent,
        TextXAlignment = Enum.TextXAlignment.Right,
    }, row)

    local track = mk("Frame", {
        Size = UDim2.new(1, -24, 0, 5),
        Position = UDim2.new(0, 12, 1, -16),
        BackgroundColor3 = T.Off,
        BorderSizePixel = 0,
    }, row)
    corner(track, 3)

    local fill = mk("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
    }, track)
    corner(fill, 3)

    local knob = mk("Frame", {
        Size = UDim2.new(0, 11, 0, 11),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = T.Text,
        BorderSizePixel = 0,
    }, track)
    corner(knob, 6)

    local dragging = false

    local function setValue(v)
        v = math.clamp(v, minv, maxv)
        local a = (v - minv) / (maxv - minv)
        fill.Size = UDim2.new(a, 0, 1, 0)
        knob.Position = UDim2.new(a, 0, 0.5, 0)
        local shown
        if v % 1 == 0 then
            shown = tostring(math.floor(v))
        else
            shown = string.format("%.2f", v)
        end
        val.Text = shown .. (suffix or "")
        if onChange then pcall(onChange, v) end
    end

    local function fromX(x)
        local a = math.clamp((x - track.AbsolutePosition.X) / math.max(1, track.AbsoluteSize.X), 0, 1)
        setValue(minv + (maxv - minv) * a)
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            fromX(input.Position.X)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            fromX(input.Position.X)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    setValue(default)
    return row
end

local function createCycle(name, options, startIndex, onChange)
    local row = mk("Frame", {
        Name = name:gsub("%s+", ""),
        Size = UDim2.new(1, -14, 0, 38),
        BackgroundColor3 = T.Row,
        BorderSizePixel = 0,
    })
    corner(row, 8)
    stroke(row, T.Stroke, 1, 0.6)

    mk("TextLabel", {
        Size = UDim2.new(1, -150, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        TextColor3 = T.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)

    local idx = startIndex or 1
    local btn = mk("TextButton", {
        Size = UDim2.new(0, 130, 0, 24),
        Position = UDim2.new(1, -138, 0.5, -12),
        BackgroundColor3 = T.Row2,
        Text = options[idx],
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextColor3 = T.Accent,
        BorderSizePixel = 0,
        AutoButtonColor = false,
    }, row)
    corner(btn, 6)
    stroke(btn, T.Stroke, 1, 0.45)

    btn.MouseEnter:Connect(function()
        TS:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = T.Accent2 }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TS:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = T.Row2 }):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        btn.Text = options[idx]
        if onChange then pcall(onChange, idx, options[idx]) end
    end)

    if onChange then pcall(onChange, idx, options[idx]) end
    return row
end

local function createButton(name, text, cb)
    local row = mk("Frame", {
        Name = name:gsub("%s+", ""),
        Size = UDim2.new(1, -14, 0, 38),
        BackgroundColor3 = T.Row,
        BorderSizePixel = 0,
    })
    corner(row, 8)
    stroke(row, T.Stroke, 1, 0.6)

    mk("TextLabel", {
        Size = UDim2.new(1, -150, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        TextColor3 = T.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)

    local btn = mk("TextButton", {
        Size = UDim2.new(0, 120, 0, 24),
        Position = UDim2.new(1, -128, 0.5, -12),
        BackgroundColor3 = T.Accent2,
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextColor3 = T.Text,
        BorderSizePixel = 0,
        AutoButtonColor = false,
    }, row)
    corner(btn, 6)
    stroke(btn, T.Accent, 1, 0.5)

    btn.MouseEnter:Connect(function()
        TS:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = T.Accent }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TS:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = T.Accent2 }):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        if cb then pcall(cb) end
    end)

    return row
end

local function section(text)
    local lbl = mk("TextLabel", {
        Size = UDim2.new(1, -14, 0, 22),
        BackgroundTransparency = 1,
        Text = "  " .. string.upper(text),
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextColor3 = T.Accent,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    return lbl
end

--[[ FEATURES ]]

local AIM_PARTS = {
    Head = { "Head" },
    Body = { "UpperTorso", "Torso", "HumanoidRootPart" },
    HumanoidRootPart = { "HumanoidRootPart" },
    Torso = { "Torso", "UpperTorso", "HumanoidRootPart" },
    Random = { "Head", "UpperTorso", "Torso", "HumanoidRootPart", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg" },
}

H.F.GetAimPart = function(char)
    if not char then return nil end
    local list = AIM_PARTS[H.Aim.Part] or { "Head" }
    if H.Aim.Part == "Random" then
        local start = math.random(1, #list)
        for i = 0, #list - 1 do
            local p = char:FindFirstChild(list[(start + i - 1) % #list + 1])
            if p and p:IsA("BasePart") then return p end
        end
    else
        for _, n in ipairs(list) do
            local p = char:FindFirstChild(n)
            if p and p:IsA("BasePart") then return p end
        end
    end
    return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
end

H.F.ValidPlayer = function(plr)
    if not plr or plr == LP or not plr.Character then return false end
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    if H.Aim.Team and plr.Team == LP.Team then return false end
    return true
end

H.F.Visible = function(pos, char)
    if not H.Aim.Wall then return true end
    local ignore = { Cam }
    if LP.Character then table.insert(ignore, LP.Character) end
    if char then table.insert(ignore, char) end
    local ok, parts = pcall(function()
        return Cam:GetPartsObscuringTarget({ pos }, ignore)
    end)
    if not ok then return true end
    return parts and #parts == 0
end

H.F.GetTarget = function()
    local best, bestD = nil, H.Aim.Fov
    local mousePos = UIS:GetMouseLocation()
    for _, plr in ipairs(Players:GetPlayers()) do
        if H.F.ValidPlayer(plr) then
            local part = H.F.GetAimPart(plr.Character)
            if part then
                local sp, on = Cam:WorldToViewportPoint(part.Position)
                if on then
                    local d = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
                    if d <= bestD and H.F.Visible(part.Position, plr.Character) then
                        bestD = d
                        best = plr
                    end
                end
            end
        end
    end
    return best
end

H.F.GetClosest = function(range)
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local best, bd = nil, range or 200
    for _, plr in ipairs(Players:GetPlayers()) do
        if H.F.ValidPlayer(plr) then
            local phrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if phrp then
                local d = (hrp.Position - phrp.Position).Magnitude
                if d < bd then
                    bd = d
                    best = plr
                end
            end
        end
    end
    return best
end

H.F.AimbotEnable = function()
    H.Flags.Aimbot = true
end

H.F.AimbotDisable = function()
    H.Flags.Aimbot = false
    H.Aim.Target = nil
    H.Aim.Holding = false
end

H.F.IsAimBind = function(input)
    local b = H.Aim.Bind
    if not b or not input then return false end
    return input.KeyCode == b or input.UserInputType == b
end

H.F.AimBindSet = function(v)
    H.Aim.Bind = v
    H.Aim.Holding = false
    H.Aim.Target = nil
end

H.F.InstallSilent = function()
    if H.Silent.Hooked then return end
    if not hookmetamethod then
        H.Silent.Enabled = false
        notify("Silent Aim", "Executor does not support hookmetamethod")
        return
    end
    local ok = pcall(function()
        local old
        old = hookmetamethod(game, "__index", function(self, key)
            if H.Silent.Enabled and self == Mouse and (key == "Hit" or key == "UnitRay" or key == "Target") then
                local t = H.Silent.Target
                if not t or not H.F.ValidPlayer(t) then
                    if tick() - H.Silent.Last > 0.05 then
                        H.Silent.Target = H.F.GetTarget()
                        H.Silent.Last = tick()
                    end
                    t = H.Silent.Target
                end
                if t and t.Character then
                    local part = H.F.GetAimPart(t.Character)
                    if part then
                        if key == "Hit" then
                            return CFrame.new(part.Position)
                        elseif key == "UnitRay" then
                            return Ray.new(Cam.CFrame.Position, (part.Position - Cam.CFrame.Position).Unit * 1000)
                        elseif key == "Target" then
                            return t.Character
                        end
                    end
                end
            end
            return old(self, key)
        end)
    end)
    H.Silent.Hooked = ok
    if not ok then
        H.Silent.Enabled = false
        notify("Silent Aim", "Hook failed")
    end
end

H.F.NoRecoilEnable = function()
    if not getgc then notify("No Recoil", "Executor lacks getgc"); return end
    H.Gun.NoRecoil = true
    H.F.GunEnsure()
end

H.F.NoRecoilDisable = function()
    H.Gun.NoRecoil = false
    H.F.RestoreRecoil()
end

H.F.NoSpreadEnable = function()
    if not getgc then notify("No Spread", "Executor lacks getgc"); return end
    H.Gun.NoSpread = true
    H.F.GunEnsure()
end

H.F.NoSpreadDisable = function()
    H.Gun.NoSpread = false
    H.F.RestoreSpread()
end

H.F.CacheGuns = function()
    if not getgc then return end
    local cache = {}
    local ok = pcall(function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "EquipTime") then
                table.insert(cache, v)
                if not H.Gun.Orig[v] then
                    H.Gun.Orig[v] = {
                        Recoil = v.Recoil,
                        CameraRecoilingEnabled = v.CameraRecoilingEnabled,
                        AngleX_Min = v.AngleX_Min,
                        AngleX_Max = v.AngleX_Max,
                        AngleY_Min = v.AngleY_Min,
                        AngleY_Max = v.AngleY_Max,
                        AngleZ_Min = v.AngleZ_Min,
                        AngleZ_Max = v.AngleZ_Max,
                        Spread = v.Spread,
                    }
                end
            end
        end
    end)
    if ok then H.Gun.Cache = cache end
end

H.F.ApplyGuns = function()
    for _, w in ipairs(H.Gun.Cache) do
        pcall(function()
            if H.Gun.NoRecoil then
                w.Recoil = 0
                w.CameraRecoilingEnabled = false
                w.AngleX_Min = 0
                w.AngleX_Max = 0
                w.AngleY_Min = 0
                w.AngleY_Max = 0
                w.AngleZ_Min = 0
                w.AngleZ_Max = 0
            end
            if H.Gun.NoSpread then
                w.Spread = 0
            end
        end)
    end
end

H.F.RestoreRecoil = function()
    for w, o in pairs(H.Gun.Orig) do
        pcall(function()
            w.Recoil = o.Recoil
            w.CameraRecoilingEnabled = o.CameraRecoilingEnabled
            w.AngleX_Min = o.AngleX_Min
            w.AngleX_Max = o.AngleX_Max
            w.AngleY_Min = o.AngleY_Min
            w.AngleY_Max = o.AngleY_Max
            w.AngleZ_Min = o.AngleZ_Min
            w.AngleZ_Max = o.AngleZ_Max
        end)
    end
end

H.F.RestoreSpread = function()
    for w, o in pairs(H.Gun.Orig) do
        if o.Spread ~= nil then
            pcall(function() w.Spread = o.Spread end)
        end
    end
end

H.F.GunEnsure = function()
    if H.Gun.Running then return end
    if not (H.Gun.NoRecoil or H.Gun.NoSpread) then return end
    H.Gun.Running = true
    task.spawn(function()
        while H.Gun.NoRecoil or H.Gun.NoSpread do
            H.F.CacheGuns()
            H.F.ApplyGuns()
            task.wait(0.5)
        end
        H.F.RestoreRecoil()
        H.F.RestoreSpread()
        H.Gun.Orig = {}
        H.Gun.Cache = {}
        H.Gun.Running = false
    end)
end

H.F.MeleeAttack = function(target)
    local char = LP.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local head = target and target:FindFirstChild("Head")
    if not (tool and hrp and head) then return end
    local events = RStorage:FindFirstChild("Events")
    local rf = events and events:FindFirstChild("XMHH.2")
    local re = events and events:FindFirstChild("XMHH2.2")
    if not (rf and re) then return end
    local ok, result = pcall(function()
        return rf:InvokeServer("🍞", tick(), tool, "43TRFWX", "Normal", tick(), true)
    end)
    if not ok then return end
    task.wait(0.1)
    local handle = tool:FindFirstChild("WeaponHandle") or tool:FindFirstChild("Handle") or char:FindFirstChild("Right Arm")
    if not handle then return end
    pcall(function()
        re:FireServer("🍞", tick(), tool, "2389ZFX34", result, false, handle, head, target, hrp.Position, head.Position)
    end)
end

H.F.MeleeEnable = function()
    if H.Melee.Enabled then return end
    H.Melee.Enabled = true
    task.spawn(function()
        while H.Melee.Enabled do
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character then
                        local h = plr.Character:FindFirstChildOfClass("Humanoid")
                        local phrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        if h and phrp and h.Health > 15 and not plr.Character:FindFirstChildOfClass("ForceField") then
                            if (hrp.Position - phrp.Position).Magnitude < 6 then
                                H.F.MeleeAttack(plr.Character)
                            end
                        end
                    end
                end
            end
            task.wait(0.12)
        end
    end)
end

H.F.MeleeDisable = function()
    H.Melee.Enabled = false
end

H.F.RageShoot = function(target)
    if not target or not target.Character then return end
    local events = RStorage:FindFirstChild("Events")
    if not events then return end
    local gnx = events:FindFirstChild("GNX_S")
    local zfk = events:FindFirstChild("ZFKLF__H")
    if not (gnx and zfk) then return end
    local char = LP.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    local part = H.F.GetAimPart(target.Character)
    if not (tool and part) then return end
    local key = ""
    for _ = 1, 30 do
        key = key .. string.char(math.random(97, 122))
    end
    key = key .. "0"
    local hitPos = part.Position
    local camPos = Cam.CFrame.Position
    local dir = (hitPos - camPos).Unit
    pcall(function()
        gnx:FireServer(tick(), key, tool, "FDS9I83", camPos, { dir }, false)
    end)
    pcall(function()
        zfk:FireServer("🧈", tool, key, 1, part, hitPos, dir, nil, nil)
    end)
end

H.F.RageEnable = function()
    if H.Rage.Enabled then return end
    H.Rage.Enabled = true
    task.spawn(function()
        while H.Rage.Enabled do
            local t = H.F.GetClosest(H.Rage.Range)
            if t then
                H.F.RageShoot(t)
                task.wait(0.06)
            else
                task.wait(0.1)
            end
        end
    end)
end

H.F.RageDisable = function()
    H.Rage.Enabled = false
end

H.F.FlyEnable = function()
    if H.Fly.Enabled then return end
    H.Fly.Enabled = true
    H.Fly.Conn = RS.RenderStepped:Connect(function(dt)
        if not H.Fly.Enabled then return end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
        if dir.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + dir.Unit * H.Fly.Speed * dt
        end
    end)
end

H.F.FlyDisable = function()
    H.Fly.Enabled = false
    if H.Fly.Conn then
        H.Fly.Conn:Disconnect()
        H.Fly.Conn = nil
    end
end

H.F.NoclipEnable = function()
    if H.Noclip.Enabled then return end
    H.Noclip.Enabled = true
    H.Noclip.Conn = RS.Stepped:Connect(function()
        local char = LP.Character
        if not char then return end
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                if H.Noclip.Orig[p] == nil then
                    H.Noclip.Orig[p] = p.CanCollide
                end
                p.CanCollide = false
            end
        end
    end)
end

H.F.NoclipDisable = function()
    H.Noclip.Enabled = false
    if H.Noclip.Conn then
        H.Noclip.Conn:Disconnect()
        H.Noclip.Conn = nil
    end
    for p, v in pairs(H.Noclip.Orig) do
        if p and p.Parent then
            pcall(function() p.CanCollide = v end)
        end
    end
    H.Noclip.Orig = {}
end

H.F.StaminaEnable = function()
    if not H.Stamina.Orig then
        local ok = pcall(function()
            local env = getrenv and getrenv() or getfenv()
            local fn = env and env._G and env._G.S_Take
            if not fn then return end
            local up = getupvalue(fn, 2)
            if type(up) ~= "function" then return end
            local orig
            orig = hookfunction(up, function(v, ...)
                if H.Stamina.Enabled then
                    return orig(0, ...)
                end
                return orig(v, ...)
            end)
            H.Stamina.Orig = orig
        end)
        if not ok or not H.Stamina.Orig then
            notify("Stamina", "S_Take hook failed")
            return
        end
    end
    H.Stamina.Enabled = true
end

H.F.StaminaDisable = function()
    H.Stamina.Enabled = false
end

H.F.ESPBuild = function(plr)
    if plr == LP or not H.ESP.Enabled then return end
    H.F.ESPRemove(plr)
    local char = plr.Character
    if not char then return end

    local hl = Instance.new("Highlight")
    hl.FillColor = T.Accent
    hl.OutlineColor = Color3.fromRGB(255, 96, 108)
    hl.FillTransparency = 0.55
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = char
    hl.Parent = H.ESP.Holder

    local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    local bb = Instance.new("BillboardGui")
    bb.Name = "SantesBB"
    bb.Adornee = head
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 160, 0, 34)
    bb.StudsOffset = Vector3.new(0, 2.6, 0)
    bb.Parent = H.ESP.Gui

    local nm = Instance.new("TextLabel", bb)
    nm.Size = UDim2.new(1, 0, 0, 17)
    nm.BackgroundTransparency = 1
    nm.Font = Enum.Font.GothamBold
    nm.TextSize = 12
    nm.TextColor3 = Color3.fromRGB(255, 235, 235)
    nm.TextStrokeTransparency = 0.5
    nm.Text = plr.Name

    local info = Instance.new("TextLabel", bb)
    info.Size = UDim2.new(1, 0, 0, 16)
    info.Position = UDim2.new(0, 0, 0, 17)
    info.BackgroundTransparency = 1
    info.Font = Enum.Font.Gotham
    info.TextSize = 11
    info.TextColor3 = Color3.fromRGB(255, 120, 130)
    info.TextStrokeTransparency = 0.5
    info.Text = ""

    H.ESP.Objs[plr] = { hl = hl, bb = bb, info = info, name = nm }
end

H.F.ESPRemove = function(plr)
    local o = H.ESP.Objs[plr]
    if not o then return end
    pcall(function() o.hl:Destroy() end)
    pcall(function() o.bb:Destroy() end)
    H.ESP.Objs[plr] = nil
end

H.F.ESPEnable = function()
    if H.ESP.Enabled then return end
    H.ESP.Enabled = true

    local holder = Instance.new("Folder")
    holder.Name = "SantesESP_Holder"
    holder.Parent = WS

    local espGui = Instance.new("ScreenGui")
    espGui.Name = "SantesESP"
    espGui.ResetOnSpawn = false
    espGui.IgnoreGuiInset = true
    pcall(function() espGui.Parent = CoreGui end)
    if not espGui.Parent then espGui.Parent = PG end

    H.ESP.Holder = holder
    H.ESP.Gui = espGui

    for _, p in ipairs(Players:GetPlayers()) do
        H.F.ESPBuild(p)
        if p ~= LP then
            table.insert(H.ESP.Conns, p.CharacterAdded:Connect(function()
                task.wait(0.5)
                if H.ESP.Enabled then H.F.ESPBuild(p) end
            end))
        end
    end

    task.spawn(function()
        while H.ESP.Enabled do
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            for plr, o in pairs(H.ESP.Objs) do
                local c = plr.Character
                local h = c and c:FindFirstChildOfClass("Humanoid")
                local phrp = c and c:FindFirstChild("HumanoidRootPart")
                if o.bb and o.bb.Parent and h and hrp and phrp then
                    o.name.Text = plr.Name
                    o.info.Text = string.format("%d HP  |  %dm", math.floor(h.Health), math.floor((phrp.Position - hrp.Position).Magnitude))
                end
            end
            task.wait(0.35)
        end
    end)
end

H.F.ESPDisable = function()
    H.ESP.Enabled = false
    for _, c in ipairs(H.ESP.Conns) do
        pcall(function() c:Disconnect() end)
    end
    H.ESP.Conns = {}
    for plr, _ in pairs(H.ESP.Objs) do
        H.F.ESPRemove(plr)
    end
    if H.ESP.Holder then
        pcall(function() H.ESP.Holder:Destroy() end)
        H.ESP.Holder = nil
    end
    if H.ESP.Gui then
        pcall(function() H.ESP.Gui:Destroy() end)
        H.ESP.Gui = nil
    end
end

H.F.SafeEnable = function()
    if H.SafeESP.Enabled then return end
    H.SafeESP.Enabled = true
    task.spawn(function()
        while H.SafeESP.Enabled do
            local map = WS:FindFirstChild("Map")
            local folder = map and map:FindFirstChild("BredMakurz")
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if folder and hrp then
                for _, obj in ipairs(folder:GetChildren()) do
                    local part = obj.PrimaryPart or obj:FindFirstChild("MainPart") or obj:FindFirstChildOfClass("BasePart")
                    if part then
                        local dist = (part.Position - hrp.Position).Magnitude
                        local tag = obj:FindFirstChild("SantesTag")
                        if dist <= 250 then
                            if not tag then
                                local bb = Instance.new("BillboardGui")
                                bb.Name = "SantesTag"
                                bb.AlwaysOnTop = true
                                bb.Size = UDim2.new(0, 130, 0, 22)
                                bb.StudsOffset = Vector3.new(0, 1.5, 0)
                                bb.MaxDistance = 250
                                bb.Adornee = part
                                local lbl = Instance.new("TextLabel", bb)
                                lbl.Name = "Label"
                                lbl.Size = UDim2.new(1, 0, 1, 0)
                                lbl.BackgroundTransparency = 1
                                lbl.Font = Enum.Font.GothamBold
                                lbl.TextSize = 12
                                lbl.TextStrokeTransparency = 0.4
                                bb.Parent = obj
                                tag = bb
                            end
                            local lbl = tag:FindFirstChild("Label")
                            local vals = obj:FindFirstChild("Values")
                            local broken = vals and vals:FindFirstChild("Broken")
                            local safe = not (broken and broken.Value)
                            if lbl then
                                lbl.Text = obj.Name:gsub("(%l)(%u)", "%1 %2") .. (safe and "  [SAFE]" or "  [BROKEN]")
                                lbl.TextColor3 = safe and T.Good or T.Accent
                            end
                        elseif tag then
                            tag:Destroy()
                        end
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end

H.F.SafeDisable = function()
    H.SafeESP.Enabled = false
    local map = WS:FindFirstChild("Map")
    local folder = map and map:FindFirstChild("BredMakurz")
    if folder then
        for _, obj in ipairs(folder:GetChildren()) do
            local tag = obj:FindFirstChild("SantesTag")
            if tag then pcall(function() tag:Destroy() end) end
        end
    end
end

H.F.PickupEnable = function()
    if H.Pickup.Enabled then return end
    H.Pickup.Enabled = true
    task.spawn(function()
        while H.Pickup.Enabled do
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local filter = WS:FindFirstChild("Filter")
            local folder = filter and filter:FindFirstChild("SpawnedBread")
            local events = RStorage:FindFirstChild("Events")
            local remote = events and events:FindFirstChild("CZDPZUS")
            if hrp and folder and remote then
                for _, item in ipairs(folder:GetChildren()) do
                    if item:IsA("BasePart") and (item.Position - hrp.Position).Magnitude < 6 then
                        pcall(function() remote:FireServer(item) end)
                        task.wait(1.1)
                        break
                    end
                end
            end
            task.wait(0.15)
        end
    end)
end

H.F.PickupDisable = function()
    H.Pickup.Enabled = false
end

H.F.DoorsEnable = function(open)
    if open then H.Doors.Open = true else H.Doors.Unlock = true end
    if H.Doors.Running then return end
    H.Doors.Running = true
    task.spawn(function()
        while H.Doors.Open or H.Doors.Unlock do
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local map = WS:FindFirstChild("Map")
            local folder = map and map:FindFirstChild("Doors")
            if hrp and folder then
                for _, door in ipairs(folder:GetChildren()) do
                    local base = door:FindFirstChild("DoorBase")
                    local vals = door:FindFirstChild("Values")
                    local evs = door:FindFirstChild("Events")
                    if base and vals and evs and (base.Position - hrp.Position).Magnitude <= 7 then
                        local toggle = evs:FindFirstChild("Toggle")
                        local knob = door:FindFirstChild("Knob2") or door:FindFirstChild("Knob")
                        local locked = vals:FindFirstChild("Locked")
                        local openVal = vals:FindFirstChild("Open")
                        if toggle then
                            if H.Doors.Unlock and locked and locked:IsA("BoolValue") and locked.Value and door:FindFirstChild("Lock") then
                                pcall(function() toggle:FireServer("Unlock", door.Lock) end)
                            end
                            local isLocked = locked and locked.Value
                            if H.Doors.Open and openVal and openVal:IsA("BoolValue") and not openVal.Value and knob and not isLocked then
                                pcall(function() toggle:FireServer("Open", knob) end)
                            end
                        end
                    end
                end
            end
            task.wait(0.25)
        end
        H.Doors.Running = false
    end)
end

H.F.DoorsDisable = function(open)
    if open then
        H.Doors.Open = false
    else
        H.Doors.Unlock = false
    end
end

H.F.StyleLockpick = function(guiObj, scale)
    local mf = guiObj:FindFirstChild("MF")
    local lp = mf and mf:FindFirstChild("LP_Frame")
    local frames = lp and lp:FindFirstChild("Frames")
    if not frames then return end
    for _, n in ipairs({ "B1", "B2", "B3" }) do
        local bar = frames:FindFirstChild(n)
        local b = bar and bar:FindFirstChild("Bar")
        local us = b and b:FindFirstChild("UIScale")
        if us then us.Scale = scale end
    end
end

H.F.LockpickEnable = function()
    if H.Lockpick.Enabled then return end
    H.Lockpick.Enabled = true
    H.Lockpick.Conn = PG.ChildAdded:Connect(function(obj)
        if obj.Name == "LockpickGUI" then
            task.wait(0.2)
            H.F.StyleLockpick(obj, 10)
        end
    end)
    local g = PG:FindFirstChild("LockpickGUI")
    if g then H.F.StyleLockpick(g, 10) end
end

H.F.LockpickDisable = function()
    H.Lockpick.Enabled = false
    if H.Lockpick.Conn then
        H.Lockpick.Conn:Disconnect()
        H.Lockpick.Conn = nil
    end
    local g = PG:FindFirstChild("LockpickGUI")
    if g then H.F.StyleLockpick(g, 1) end
end

H.F.FullEnable = function()
    if H.Flags.Fullbright then return end
    H.Flags.Fullbright = true
    if not H.Fullbright.Orig then
        local o = {}
        for _, k in ipairs({ "Brightness", "ClockTime", "Ambient", "OutdoorAmbient", "ColorShift_Top", "FogStart", "FogEnd" }) do
            o[k] = Lighting[k]
        end
        H.Fullbright.Orig = o
    end
    task.spawn(function()
        while H.Flags.Fullbright do
            pcall(function()
                Lighting.Brightness = 5
                Lighting.ClockTime = 14
                Lighting.Ambient = Color3.new(1, 1, 1)
                Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
                Lighting.ColorShift_Top = Color3.new(0, 0, 0)
                Lighting.FogStart = 100000
                Lighting.FogEnd = 100000
            end)
            task.wait(0.2)
        end
        if H.Fullbright.Orig then
            for k, v in pairs(H.Fullbright.Orig) do
                pcall(function() Lighting[k] = v end)
            end
            H.Fullbright.Orig = nil
        end
    end)
end

H.F.FullDisable = function()
    H.Flags.Fullbright = false
end

H.F.InvisEnable = function()
    if H.Invis.Enabled then return end
    H.Invis.Enabled = true
    task.spawn(function()
        while H.Invis.Enabled do
            local char = LP.Character
            if char then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.LocalTransparencyModifier = 1 end
                end
            end
            task.wait(0.05)
        end
        local char = LP.Character
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.LocalTransparencyModifier = 0 end
            end
        end
    end)
end

H.F.InvisDisable = function()
    H.Invis.Enabled = false
end

H.F.SetSpeed = function(v)
    H.Move.Walk = v
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = v end
end

H.F.SetJump = function(v)
    H.Move.Jump = v
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function()
            if hum.UseJumpPower then
                hum.JumpPower = v
            else
                hum.JumpHeight = math.max(0, v / 2.5)
            end
        end)
    end
end

H.Skin.Apply = function(tool)
    if not H.Skin.Enabled then return end
    local skin = H.Skin.List[H.Skin.Index]
    if not skin then return end
    for _, p in ipairs(tool:GetDescendants()) do
        if p:IsA("BasePart") then
            if not H.Skin.Orig[p] then
                H.Skin.Orig[p] = {
                    Color = p.Color,
                    Material = p.Material,
                    Texture = p:IsA("MeshPart") and p.TextureID or nil,
                }
            end
            if skin.Rainbow then
                p.Color = Color3.fromHSV((tick() * 0.25) % 1, 0.85, 1)
                p.Material = Enum.Material.Neon
            else
                if skin.Color then p.Color = skin.Color end
                if skin.Material then p.Material = skin.Material end
            end
            if skin.Texture then
                if p:IsA("MeshPart") then
                    p.TextureID = skin.Texture
                elseif p:IsA("SpecialMesh") then
                    p.TextureId = skin.Texture
                end
            end
        elseif p:IsA("SpecialMesh") and skin.Texture then
            p.TextureId = skin.Texture
        end
    end
end

H.Skin.ApplyAll = function()
    local char = LP.Character
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") then H.Skin.Apply(t) end
        end
    end
    if LP.Backpack then
        for _, t in ipairs(LP.Backpack:GetChildren()) do
            if t:IsA("Tool") then H.Skin.Apply(t) end
        end
    end
end

H.Skin.Restore = function()
    for p, o in pairs(H.Skin.Orig) do
        if p and p.Parent then
            pcall(function()
                p.Color = o.Color
                p.Material = o.Material
                if o.Texture and p:IsA("MeshPart") then p.TextureID = o.Texture end
            end)
        end
    end
    H.Skin.Orig = setmetatable({}, { __mode = "k" })
end

H.F.SkinEnable = function()
    H.Skin.Enabled = true
    H.Skin.ApplyAll()
end

H.F.SkinDisable = function()
    H.Skin.Enabled = false
    H.Skin.Restore()
end

H.Skin.HookChar = function(char)
    char.ChildAdded:Connect(function(obj)
        if obj:IsA("Tool") and H.Skin.Enabled then
            task.wait(0.1)
            H.Skin.Apply(obj)
        end
    end)
end

H.Unload = function()
    pcall(function() H.F.AimbotDisable() end)
    pcall(function() H.F.ESPDisable() end)
    pcall(function() H.F.SafeDisable() end)
    pcall(function() H.F.FullDisable() end)
    pcall(function() H.F.SkinDisable() end)
    pcall(function() H.F.FlyDisable() end)
    pcall(function() H.F.NoclipDisable() end)
    H.Silent.Enabled = false
    H.Flags.Fullbright = false
    if gui then gui:Destroy() end
    clean("SantesESP")
end

--[[ ROWS ]]

local UI = {
    Cats = { "Combat", "Movement", "Visuals", "Farming", "Skins", "Misc", "Rage" },
    Frames = {},
    Buttons = {},
    Active = nil,
}
for _, c in ipairs(UI.Cats) do UI.Frames[c] = {} end

local function add(cat, row)
    table.insert(UI.Frames[cat], row)
end

-- FOV circle (Drawing executors)
pcall(function()
    if not Drawing then return end
    local c = Drawing.new("Circle")
    c.Thickness = 1.5
    c.Color = T.Accent
    c.Filled = false
    c.Transparency = 0.8
    c.Visible = false
    H.FovCircle.Draw = c
    H.FovCircle.Enabled = true
    RS.RenderStepped:Connect(function()
        local d = H.FovCircle.Draw
        if not d then return end
        d.Visible = H.FovCircle.Enabled and H.Flags.Aimbot
        if d.Visible then
            local m = UIS:GetMouseLocation()
            d.Position = Vector2.new(m.X, m.Y)
            d.Radius = H.Aim.Fov
        end
    end)
end)

-- Combat
add("Combat", section("TARGETING"))
add("Combat", (createToggle("Aimbot", true, function() return H.Flags.Aimbot end, H.F.AimbotEnable, H.F.AimbotDisable, keyOf("aimbot"))))
add("Combat", (createBind("Aim Hold Key", function() return H.Aim.Bind end, function(v) H.F.AimBindSet(v) end)))
add("Combat", (createToggle("Silent Aim", true, function() return H.Silent.Enabled end, function()
    H.Silent.Enabled = true
    H.F.InstallSilent()
end, function()
    H.Silent.Enabled = false
    H.Silent.Target = nil
end, keyOf("silent"))))
add("Combat", (createCycle("Aim Part", { "Head", "Body", "HumanoidRootPart", "Torso", "Random" }, 1, function(_, v)
    H.Aim.Part = v
end)))
add("Combat", (createSlider("Aimbot FOV", 20, 400, 140, "", function(v) H.Aim.Fov = v end)))
add("Combat", (createSlider("Aim Smoothing", 0, 0.9, 0.15, "", function(v) H.Aim.Smooth = v end)))
if H.FovCircle.Draw then
    add("Combat", (createToggle("FOV Circle", true, function() return H.FovCircle.Enabled end, function()
        H.FovCircle.Enabled = true
    end, function()
        H.FovCircle.Enabled = false
    end)))
end
add("Combat", (createToggle("Sticky Aim", true, function() return H.Aim.Sticky end, function() H.Aim.Sticky = true end, function() H.Aim.Sticky = false end)))
add("Combat", (createToggle("Wall Check", true, function() return H.Aim.Wall end, function() H.Aim.Wall = true end, function() H.Aim.Wall = false end)))
add("Combat", (createToggle("Team Check", true, function() return H.Aim.Team end, function() H.Aim.Team = true end, function() H.Aim.Team = false end)))
add("Combat", section("WEAPON"))
add("Combat", (createToggle("No Recoil", true, function() return H.Gun.NoRecoil end, H.F.NoRecoilEnable, H.F.NoRecoilDisable, keyOf("recoil"))))
add("Combat", (createToggle("No Spread", true, function() return H.Gun.NoSpread end, H.F.NoSpreadEnable, H.F.NoSpreadDisable)))
add("Combat", section("MELEE"))
add("Combat", (createToggle("Melee Aura", true, function() return H.Melee.Enabled end, H.F.MeleeEnable, H.F.MeleeDisable)))

-- Movement
add("Movement", section("TRAVEL"))
add("Movement", (createToggle("Fly", true, function() return H.Fly.Enabled end, H.F.FlyEnable, H.F.FlyDisable, keyOf("fly"))))
add("Movement", (createSlider("Fly Speed", 20, 200, 55, "", function(v) H.Fly.Speed = v end)))
add("Movement", (createToggle("Noclip", true, function() return H.Noclip.Enabled end, H.F.NoclipEnable, H.F.NoclipDisable, keyOf("noclip"))))
add("Movement", (createToggle("Infinite Stamina", true, function() return H.Stamina.Enabled end, H.F.StaminaEnable, H.F.StaminaDisable)))
add("Movement", section("PLAYER"))
add("Movement", (createSlider("Walk Speed", 16, 120, 16, "", function(v) H.F.SetSpeed(v) end)))
add("Movement", (createSlider("Jump Power", 50, 200, 50, "", function(v) H.F.SetJump(v) end)))

-- Visuals
add("Visuals", section("PLAYERS"))
add("Visuals", (createToggle("Player ESP", true, function() return H.ESP.Enabled end, H.F.ESPEnable, H.F.ESPDisable, keyOf("esp"))))
add("Visuals", (createToggle("Safe ESP", true, function() return H.SafeESP.Enabled end, H.F.SafeEnable, H.F.SafeDisable)))
add("Visuals", section("WORLD"))
add("Visuals", (createToggle("Fullbright", true, function() return H.Flags.Fullbright end, H.F.FullEnable, H.F.FullDisable, keyOf("bright"))))
add("Visuals", (createSlider("Camera FOV", 70, 120, 70, "", function(v) H.CamFov = v end)))
add("Visuals", (createToggle("Local Invisibility", true, function() return H.Invis.Enabled end, H.F.InvisEnable, H.F.InvisDisable)))

-- Farming
add("Farming", section("CRIMINALITY"))
add("Farming", (createToggle("No Fail Lockpick", true, function() return H.Lockpick.Enabled end, H.F.LockpickEnable, H.F.LockpickDisable)))
add("Farming", (createToggle("Auto Pickup Money", true, function() return H.Pickup.Enabled end, H.F.PickupEnable, H.F.PickupDisable)))
add("Farming", (createToggle("Auto Open Doors", true, function() return H.Doors.Open end, function() H.F.DoorsEnable(true) end, function() H.F.DoorsDisable(true) end)))
add("Farming", (createToggle("Auto Unlock Doors", true, function() return H.Doors.Unlock end, function() H.F.DoorsEnable(false) end, function() H.F.DoorsDisable(false) end)))

-- Skins
local skinNames = {}
for _, s in ipairs(H.Skin.List) do table.insert(skinNames, s.Name) end

add("Skins", section("GUNS"))
add("Skins", (createToggle("Skin Changer", true, function() return H.Skin.Enabled end, H.F.SkinEnable, H.F.SkinDisable, keyOf("skin"))))
add("Skins", (createCycle("Gun Skin", skinNames, 1, function(i)
    H.Skin.Index = i
    if H.Skin.Enabled then
        H.Skin.Restore()
        H.Skin.ApplyAll()
    end
end)))
add("Skins", (createButton("Apply Skin", "APPLY", function()
    H.Skin.ApplyAll()
    notify("Santes", "Skin: " .. H.Skin.List[H.Skin.Index].Name)
end)))
add("Skins", section("INFO"))
add("Skins", (createButton("Rainbow Preview", "REFRESH", function()
    H.Skin.RainbowTick = tick()
    H.Skin.ApplyAll()
end)))

-- Misc
add("Misc", section("SERVER"))
add("Misc", (createButton("Rejoin Server", "REJOIN", function()
    pcall(function() TeleportService:Teleport(game.PlaceId, LP) end)
end)))
add("Misc", (createButton("Reset Character", "RESET", function()
    local c = LP.Character
    local h = c and c:FindFirstChildOfClass("Humanoid")
    if h then h.Health = 0 end
end)))
add("Misc", (createButton("Unload Hub", "UNLOAD", function()
    H.Unload()
end)))
add("Misc", section("INFO"))
add("Misc", (createButton("Toggle UI", "K", function()
    main.Visible = not main.Visible
end)))

-- Rage
add("Rage", section("RAGEBOT"))
add("Rage", (createToggle("Ragebot", true, function() return H.Rage.Enabled end, H.F.RageEnable, H.F.RageDisable, keyOf("rage"))))
add("Rage", (createSlider("Rage Range", 50, 500, 200, "", function(v) H.Rage.Range = v end)))
add("Rage", (createToggle("Rage Wall Check", true, function() return H.Aim.Wall end, function() H.Aim.Wall = true end, function() H.Aim.Wall = false end)))

--[[ CATEGORIES ]]

local function showCategory(name)
    if UI.Active == name then return end
    UI.Active = name

    for cat, btn in pairs(UI.Buttons) do
        local active = cat == name
        TS:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = active and T.Accent2 or T.Panel,
        }):Play()
        local lbl = btn:FindFirstChildOfClass("TextLabel")
        if lbl then
            lbl.TextColor3 = active and T.Text or T.Dim
        end
        local accent = btn:FindFirstChildWhichIsA("Frame")
        if accent then
            accent.Visible = active
        end
    end

    for _, child in ipairs(content:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child.Parent = nil
        end
    end

    local list = UI.Frames[name] or {}
    local total = 0
    for i, row in ipairs(list) do
        row.LayoutOrder = i
        row.Parent = content
        total = total + row.Size.Y.Offset + 6
    end
    content.CanvasSize = UDim2.new(0, 0, 0, total + 6)
end

for i, name in ipairs(UI.Cats) do
    local btn = mk("TextButton", {
        Name = name .. "Tab",
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = T.Panel,
        Text = "",
        BorderSizePixel = 0,
        AutoButtonColor = false,
        LayoutOrder = i,
    }, sidebar)
    corner(btn, 7)

    local lbl = mk("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = name,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        TextColor3 = T.Dim,
    }, btn)

    local accent = mk("Frame", {
        Size = UDim2.new(0, 3, 0, 16),
        Position = UDim2.new(0, 0, 0.5, -8),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
        Visible = false,
    }, btn)
    corner(accent, 2)

    btn.MouseEnter:Connect(function()
        if UI.Active ~= name then
            TS:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = T.Row }):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if UI.Active ~= name then
            TS:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = T.Panel }):Play()
        end
    end)
    btn.MouseButton1Click:Connect(function()
        showCategory(name)
    end)

    UI.Buttons[name] = btn
    btn:SetAttribute("Accent", true)
end

showCategory("Combat")

--[[ WINDOW MOVEMENT / INPUT ]]

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
end)

do
    local dragging = false
    local dragStart, startPos
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local ap = main.AbsolutePosition
            if input.Position.Y >= ap.Y and input.Position.Y <= ap.Y + 52 then
                dragging = true
                dragStart = input.Position
                startPos = main.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end
    end)
    main.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.K and H.Aim.Bind ~= Enum.KeyCode.K then
        main.Visible = not main.Visible
    end
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if H.BindCapture then
        local cap = H.BindCapture
        local value
        if input.KeyCode ~= Enum.KeyCode.Unknown then
            value = input.KeyCode
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then
            value = input.UserInputType
        end
        if value ~= nil then
            if input.KeyCode == Enum.KeyCode.Escape then
                H.BindCapture = nil
                pcall(cap.update)
                return
            end
            if cap.kind == "input" then
                cap.set(value)
                H.BindCapture = nil
                pcall(cap.update)
                return
            end
            local old = cap.get()
            if old then H.Binds[old] = nil end
            cap.set(value)
            H.Binds[value] = {
                get = cap.get,
                on = cap.on,
                off = cap.off,
                can = cap.can,
                update = cap.update,
            }
            H.BindCapture = nil
            pcall(cap.update)
        end
        return
    end
    local b = H.Binds[input.KeyCode]
    if b and b.can then
        local ok, state = pcall(b.get)
        if ok then
            if state then
                pcall(b.off)
            else
                pcall(b.on)
            end
            pcall(b.update)
        end
    end
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if H.F.IsAimBind(input) then
        H.Aim.Holding = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if H.F.IsAimBind(input) then
        H.Aim.Holding = false
    end
end)

--[[ LOOPS / HOOKS ]]

RS.RenderStepped:Connect(function()
    if not H.Flags.Aimbot or not H.Aim.Holding or not Cam then return end
    local t = H.Aim.Target
    if t and not H.F.ValidPlayer(t) then
        t = nil
        H.Aim.Target = nil
    end
    if not t or not H.Aim.Sticky then
        t = H.F.GetTarget()
        H.Aim.Target = t
    end
    if not t then return end
    local part = H.F.GetAimPart(t.Character)
    if not part then return end
    local pos = part.Position
    pcall(function()
        local ping = LP:GetNetworkPing()
        pos = pos + part.AssemblyLinearVelocity * (ping * 0.6)
    end)
    local goal = CFrame.new(Cam.CFrame.Position, pos)
    local alpha = math.clamp(1 - H.Aim.Smooth, 0.03, 1)
    Cam.CFrame = Cam.CFrame:Lerp(goal, alpha)
end)

RS.RenderStepped:Connect(function()
    if Cam and math.abs(Cam.FieldOfView - H.CamFov) > 0.5 then
        Cam.FieldOfView = H.CamFov
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        local skin = H.Skin.List[H.Skin.Index]
        if H.Skin.Enabled and skin and skin.Rainbow then
            H.Skin.ApplyAll()
        end
    end
end)

Players.PlayerAdded:Connect(function(plr)
    if H.ESP.Enabled then
        plr.CharacterAdded:Connect(function()
            task.wait(0.5)
            if H.ESP.Enabled then H.F.ESPBuild(plr) end
        end)
        if plr.Character then H.F.ESPBuild(plr) end
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    H.F.ESPRemove(plr)
end)

LP.CharacterAdded:Connect(function(char)
    H.Noclip.Orig = {}
    Cam = WS.CurrentCamera
    H.Skin.HookChar(char)
    task.wait(0.6)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = H.Move.Walk
        pcall(function() hum.JumpPower = H.Move.Jump end)
    end
    if H.Move.Walk > 16 or H.Move.Jump > 50 then
        notify("Santes", "Character loaded")
    end
end)

task.spawn(function()
    while task.wait(1) do
        if WS.CurrentCamera and WS.CurrentCamera ~= Cam then
            Cam = WS.CurrentCamera
        end
    end
end)

if LP.Character then
    H.Skin.HookChar(LP.Character)
end

task.spawn(function()
    repeat task.wait(0.5) until game:IsLoaded()
    notify("SANTES HUB", "Loaded. K to toggle. " .. (H.Aim.Bind and H.Aim.Bind.Name or "RMB") .. " to aim.")
end)

print("Santes Hub loaded | crimcorp")
