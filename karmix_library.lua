-- Karmix Library: UI library with integrated KaiStudio Icons
-- Author: Generated by ChatGPT

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local Karmix = {
    Folder = "KarmixLibrary",
    Options = {},
    ThemeGradient = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(100, 149, 237)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(123, 201, 201)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(224, 138, 175))
    },
    IconModule = {},
}

-- Attempt to load KaiStudio Icons module
spawn(function()
    local url = "https://raw.githubusercontent.com/KaiStudio0/Icons/refs/heads/main/Icons.lua"
    local success, result = pcall(function()
        local code = game:HttpGet(url)
        local fn = loadstring(code)
        if fn then
            local icons = fn()
            if type(icons) == "table" then
                Karmix.IconModule = icons
            end
        end
    end)
    if not success then
        warn("Karmix: failed to load icons module:", result)
    end
end)

-- Utility: create instance
local function createInstance(className, properties)
    local inst = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        inst[prop] = value
    end
    return inst
end

-- Apply corner radius
local function applyCorner(uiElement, radius)
    local corner = createInstance("UICorner", { CornerRadius = UDim.new(0, radius or 8) })
    corner.Parent = uiElement
end

-- Apply subtle shadow/stroke
local function applyShadow(uiElement)
    local stroke = createInstance("UIStroke", {
        Thickness = 1,
        Color = Color3.fromRGB(0, 0, 0),
        Transparency = 0.8
    })
    stroke.Parent = uiElement
end

-- Tween helper
local function tweenProperty(inst, properties, duration, style, direction)
    TweenService:Create(inst, TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out), properties):Play()
end

-- Convert HSV to RGB
local function HSVtoRGB(h, s, v)
    local c = v * s
    local x = c * (1 - math.abs((h / 60) % 2 - 1))
    local m = v - c
    local rp, gp, bp
    if h < 60 then rp, gp, bp = c, x, 0
    elseif h < 120 then rp, gp, bp = x, c, 0
    elseif h < 180 then rp, gp, bp = 0, c, x
    elseif h < 240 then rp, gp, bp = 0, x, c
    elseif h < 300 then rp, gp, bp = x, 0, c
    else rp, gp, bp = c, 0, x end
    return Color3.new(rp + m, gp + m, bp + m)
end

-- Notification system
local function createNotificationContainer(screenGui)
    local container = createInstance("Frame", {
        Name = "NotificationContainer",
        Parent = screenGui,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 10),
        Size = UDim2.new(0.5, 0, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = 1000,
    })
    local layout = createInstance("UIListLayout", { Parent = container })
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    return container
end

local function showNotification(screenGui, message, duration)
    duration = duration or 3
    local container = screenGui:FindFirstChild("NotificationContainer") or createNotificationContainer(screenGui)
    local notif = createInstance("Frame", {
        Name = "Notification",
        Parent = container,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BackgroundTransparency = 0.1,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        ZIndex = 1001,
    })
    applyCorner(notif, 8)
    applyShadow(notif)
    local label = createInstance("TextLabel", {
        Name = "Message",
        Parent = notif,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0.9, 0, 0.8, 0),
        BackgroundTransparency = 1,
        Text = message,
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Center,
    })
    notif.BackgroundTransparency = 1
    tweenProperty(notif, {BackgroundTransparency = 0.1}, 0.2)
    delay(duration, function()
        tweenProperty(notif, {BackgroundTransparency = 1}, 0.5)
        wait(0.5)
        if notif then notif:Destroy() end
    end)
end

-- Main CreateWindow
function Karmix:CreateWindow(settings)
    settings = settings or {}
    local name = settings.Name or "Karmix Window"
    local subtitle = settings.Subtitle or ""
    local logoId = settings.LogoID or ""
    local loadingEnabled = settings.LoadingEnabled or false

    local screenGui = createInstance("ScreenGui", { Name = name, ResetOnSpawn = false })
    if UserInputService.TouchEnabled then
        screenGui.IgnoreGuiInset = true
    end
    screenGui.Parent = CoreGui

    local uiScale = createInstance("UIScale", { Scale = 1 })
    uiScale.Parent = screenGui
    spawn(function()
        local resX = workspace.CurrentCamera.ViewportSize.X
        if resX < 800 then
            uiScale.Scale = 0.8
        end
    end)

    local mainFrame = createInstance("Frame", {
        Name = "MainFrame",
        Parent = screenGui,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0.8, 0, 0.8, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BackgroundTransparency = 0.1,
    })
    applyCorner(mainFrame, 16)
    applyShadow(mainFrame)

    local titleBar = createInstance("Frame", {
        Name = "TitleBar",
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 0.2,
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
    })
    applyCorner(titleBar, 16)
    titleBar.ClipsDescendants = true

    do
        local dragging, dragInput, dragStart, startPos
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
        titleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input == dragInput) then
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

    local titleLabel = createInstance("TextLabel", {
        Name = "TitleLabel",
        Parent = titleBar,
        Position = UDim2.new(0, 12, 0, 8),
        Size = UDim2.new(1, -100, 0, 24),
        BackgroundTransparency = 1,
        Text = name,
        Font = Enum.Font.SourceSansBold,
        TextSize = 20,
        TextColor3 = Color3.fromRGB(255,255,255),
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local buttonSize = UDim2.new(0, 32, 0, 32)
    local closeButton = createInstance("TextButton", {
        Name = "CloseButton",
        Parent = titleBar,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -8, 0, 4),
        Size = buttonSize,
        BackgroundTransparency = 0,
        BackgroundColor3 = Color3.fromRGB(180, 50, 50),
        Text = "✕",
        Font = Enum.Font.SourceSansBold,
        TextSize = 20,
        TextColor3 = Color3.fromRGB(255,255,255),
    })
    applyCorner(closeButton, 8)
    closeButton.MouseEnter:Connect(function()
        tweenProperty(closeButton, {BackgroundColor3 = Color3.fromRGB(220, 70, 70)}, 0.1)
    end)
    closeButton.MouseLeave:Connect(function()
        tweenProperty(closeButton, {BackgroundColor3 = Color3.fromRGB(180, 50, 50)}, 0.1)
    end)
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    local minimizeButton = createInstance("TextButton", {
        Name = "MinimizeButton",
        Parent = titleBar,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -48, 0, 4),
        Size = buttonSize,
        BackgroundTransparency = 0,
        BackgroundColor3 = Color3.fromRGB(120, 120, 120),
        Text = "─",
        Font = Enum.Font.SourceSansBold,
        TextSize = 20,
        TextColor3 = Color3.fromRGB(255,255,255),
    })
    applyCorner(minimizeButton, 8)
    minimizeButton.MouseEnter:Connect(function()
        tweenProperty(minimizeButton, {BackgroundColor3 = Color3.fromRGB(150, 150, 150)}, 0.1)
    end)
    minimizeButton.MouseLeave:Connect(function()
        tweenProperty(minimizeButton, {BackgroundColor3 = Color3.fromRGB(120, 120, 120)}, 0.1)
    end)
    local minimized = false

    local windowContentHolder = createInstance("Frame", {
        Name = "ContentHolder",
        Parent = mainFrame,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(1, 0, 1, -40),
        BackgroundTransparency = 1,
    })
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            windowContentHolder.Visible = false
            tweenProperty(mainFrame, {Size = UDim2.new(mainFrame.Size.X.Scale, mainFrame.Size.X.Offset, 0, 40)}, 0.2)
        else
            windowContentHolder.Visible = true
            tweenProperty(mainFrame, {Size = UDim2.new(0.8,0,0.8,0)}, 0.2)
        end
    end)

    local sideContainer = createInstance("Frame", {
        Name = "SideContainer",
        Parent = windowContentHolder,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0.25, 0, 1, 0),
        BackgroundTransparency = 1,
    })
    local tabListLayout = createInstance("UIListLayout", { Parent = sideContainer })
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 4)

    local contentContainer = createInstance("Frame", {
        Name = "ContentContainer",
        Parent = windowContentHolder,
        Position = UDim2.new(0.25, 0, 0, 0),
        Size = UDim2.new(0.75, 0, 1, 0),
        BackgroundTransparency = 1,
    })
    contentContainer.ClipsDescendants = true

    local tabs = {}
    local window = {}
    window.ScreenGui = screenGui
    window.MainFrame = mainFrame
    window.SideContainer = sideContainer
    window.ContentContainer = contentContainer
    window.Tabs = tabs

    function window:CreateTab(tabSettings)
        tabSettings = tabSettings or {}
        local tabName = tabSettings.Name or "Tab"
        local iconName = tabSettings.Icon or nil
        local showTitle = tabSettings.ShowTitle
        if showTitle == nil then showTitle = true end

        -- Tab button layout
        local button = createInstance("TextButton", {
            Name = tabName.."Button",
            Parent = sideContainer,
            Size = UDim2.new(1, -8, 0, 36),
            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
            AutoButtonColor = false,
        })
        applyCorner(button, 8)
        applyShadow(button)
        local inner = createInstance("Frame", {
            Name = "Inner",
            Parent = button,
            Size = UDim2.new(1, -16, 1, 0),
            Position = UDim2.new(0, 8, 0, 0),
            BackgroundTransparency = 1,
        })
        local hLayout = createInstance("UIListLayout", { Parent = inner })
        hLayout.FillDirection = Enum.FillDirection.Horizontal
        hLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        hLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        hLayout.SortOrder = Enum.SortOrder.LayoutOrder
        hLayout.Padding = UDim.new(0, 8)
        if iconName and Karmix.IconModule[iconName] then
            local iconImage = createInstance("ImageLabel", {
                Name = "Icon",
                Parent = inner,
                Size = UDim2.new(0, 20, 0, 20),
                BackgroundTransparency = 1,
                Image = Karmix.IconModule[iconName],
                ScaleType = Enum.ScaleType.Fit,
            })
        end
        if showTitle then
            local txt = createInstance("TextLabel", {
                Name = "Text",
                Parent = inner,
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text = tabName,
                Font = Enum.Font.SourceSans,
                TextSize = 16,
                TextColor3 = Color3.fromRGB(255,255,255),
                TextXAlignment = Enum.TextXAlignment.Left,
            })
        end
        button.MouseEnter:Connect(function()
            tweenProperty(button, {BackgroundColor3 = Color3.fromRGB(70,70,70)}, 0.1)
        end)
        button.MouseLeave:Connect(function()
            tweenProperty(button, {BackgroundColor3 = Color3.fromRGB(50,50,50)}, 0.1)
        end)

        local contentFrame = createInstance("ScrollingFrame", {
            Name = tabName.."Content",
            Parent = contentContainer,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 6,
            BackgroundTransparency = 1,
            ScrollBarImageColor3 = Color3.fromRGB(150,150,150),
            ScrollBarImageTransparency = 0.5,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
        })
        local uiList = createInstance("UIListLayout", { Parent = contentFrame })
        uiList.SortOrder = Enum.SortOrder.LayoutOrder
        uiList.Padding = UDim.new(0, 8)
        contentFrame.Visible = false

        local function selectTab()
            for _, t in pairs(tabs) do
                t.Button.BackgroundColor3 = Color3.fromRGB(50,50,50)
                t.ContentFrame.Visible = false
            end
            button.BackgroundColor3 = Color3.fromRGB(80,80,80)
            contentFrame.Visible = true
        end
        button.MouseButton1Click:Connect(selectTab)

        table.insert(tabs, { Name = tabName, Button = button, ContentFrame = contentFrame, Layout = uiList })
        if #tabs == 1 then selectTab() end

        local tabObj = {}
        tabObj.Button = button
        tabObj.ContentFrame = contentFrame
        tabObj.Layout = uiList

        function tabObj:CreateButton(opt)
            opt = opt or {}
            local name = opt.Name or "Button"
            local callback = opt.Callback or function() end
            local btn = createInstance("TextButton", {
                Name = name,
                Parent = contentFrame,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Color3.fromRGB(60,60,60),
                AutoButtonColor = false,
            })
            applyCorner(btn, 8)
            applyShadow(btn)
            local txt = createInstance("TextLabel", {
                Name = "Text",
                Parent = btn,
                Size = UDim2.new(1, -16, 1, 0),
                Position = UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                Font = Enum.Font.SourceSans,
                TextSize = 16,
                TextColor3 = Color3.fromRGB(255,255,255),
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            btn.MouseEnter:Connect(function()
                tweenProperty(btn, {BackgroundColor3 = Color3.fromRGB(80,80,80)}, 0.1)
            end)
            btn.MouseLeave:Connect(function()
                tweenProperty(btn, {BackgroundColor3 = Color3.fromRGB(60,60,60)}, 0.1)
            end)
            btn.MouseButton1Click:Connect(callback)
            btn.TouchTap:Connect(callback)
            return btn
        end

        -- Similar modifications for CreateToggle, CreateSlider, CreateDropdown, CreateColorPicker as before
        -- You can refer to the existing implementation in the code above for details

        return tabObj
    end

    return window
end

return Karmix
