-- Arsenal Game Script - Improved Version
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Główne GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArsenalHubGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Główny frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 320)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true

-- Gradient dla tła
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 50))
}
MainGradient.Rotation = 45
MainGradient.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Stroke (ramka)
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 60, 80)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Header
local HeaderFrame = Instance.new("Frame")
HeaderFrame.Name = "Header"
HeaderFrame.Size = UDim2.new(1, 0, 0, 50)
HeaderFrame.Position = UDim2.new(0, 0, 0, 0)
HeaderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
HeaderFrame.BorderSizePixel = 0
HeaderFrame.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = HeaderFrame

-- Tytuł
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "ARSENAL HUB"
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = HeaderFrame

-- Przycisk zamknięcia
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Text = "✕"
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -45, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 16
CloseButton.BorderSizePixel = 0
CloseButton.Parent = HeaderFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Przycisk minimalizacji
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Text = "−"
MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
MinimizeButton.Position = UDim2.new(1, -90, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 20
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Parent = HeaderFrame

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 8)
MinimizeCorner.Parent = MinimizeButton

-- Drag functionality
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

HeaderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

HeaderFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Close button functionality
CloseButton.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    tween:Play()
    tween.Completed:Connect(function()
        ScreenGui:Destroy()
    end)
end)

-- Minimize functionality
local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetSize = isMinimized and UDim2.new(0, 450, 0, 50) or UDim2.new(0, 450, 0, 320)
    
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = targetSize
    })
    tween:Play()
    
    MinimizeButton.Text = isMinimized and "+" or "−"
end)

-- === AIMBOT TAB & SETTINGS ===

-- Ustawienia aimbota (domyślne wartości)
local aimbotEnabled = false
local aimbotTargetPart = "Head" -- Head lub Torso
local aimbotFOV = 120
local aimbotSmoothness = 0.2
local aimbotPriority = "Nearest" -- Nearest, LowestHP, Visible
local aimbotWallCheck = true
local aimbotSilent = false

-- FOV Circle Drawing
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Color = Color3.fromRGB(255, 255, 0)
fovCircle.Thickness = 2
fovCircle.Filled = false
fovCircle.Transparency = 0.6
fovCircle.Radius = aimbotFOV

-- Funkcja aktualizująca FOV circle
local function updateFOVCircle()
    fovCircle.Visible = aimbotEnabled
    fovCircle.Radius = aimbotFOV
    local viewportSize = camera.ViewportSize
    fovCircle.Position = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
end

RunService.RenderStepped:Connect(updateFOVCircle)

-- === GUI: Dodanie zakładek ===

-- Tab system
local Tabs = {}
local TabButtons = {}
local CurrentTab = nil

-- Tab Frame
local TabFrame = Instance.new("Frame")
TabFrame.Name = "TabFrame"
TabFrame.Size = UDim2.new(0, 120, 1, -60)
TabFrame.Position = UDim2.new(0, 0, 0, 50)
TabFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TabFrame.BorderSizePixel = 0
TabFrame.Parent = MainFrame

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 10)
TabCorner.Parent = TabFrame

-- Tabs list
local tabNames = {"Aimbot", "ESP", "Gun Mods"}
for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Name = name .. "TabButton"
    btn.Text = name
    btn.Size = UDim2.new(1, -20, 0, 36)
    btn.Position = UDim2.new(0, 10, 0, 10 + (i-1)*42)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.Parent = TabFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    TabButtons[name] = btn
end

-- Tab content frames
for _, name in ipairs(tabNames) do
    local frame = Instance.new("Frame")
    frame.Name = name .. "TabContent"
    frame.Size = UDim2.new(1, -140, 1, -70)
    frame.Position = UDim2.new(0, 130, 0, 60)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = MainFrame
    Tabs[name] = frame
end

-- Tab switching logic
local function switchTab(tabName)
    for name, frame in pairs(Tabs) do
        frame.Visible = (name == tabName)
    end
    CurrentTab = tabName
end
for name, btn in pairs(TabButtons) do
    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end
switchTab("Aimbot")

-- === Aimbot Tab Content ===
local aimbotTab = Tabs["Aimbot"]

-- Layout
local aimbotLayout = Instance.new("UIListLayout")
aimbotLayout.SortOrder = Enum.SortOrder.LayoutOrder
aimbotLayout.Padding = UDim.new(0, 10)
aimbotLayout.Parent = aimbotTab

-- Enable Aimbot Toggle
local aimbotToggle = Instance.new("TextButton")
aimbotToggle.Name = "AimbotToggle"
aimbotToggle.Text = "Aimbot: OFF"
aimbotToggle.Size = UDim2.new(1, -20, 0, 36)
aimbotToggle.Position = UDim2.new(0, 10, 0, 10)
aimbotToggle.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
aimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
aimbotToggle.Font = Enum.Font.GothamBold
aimbotToggle.TextSize = 14
aimbotToggle.BorderSizePixel = 0
aimbotToggle.Parent = aimbotTab

local aimbotToggleCorner = Instance.new("UICorner")
aimbotToggleCorner.CornerRadius = UDim.new(0, 8)
aimbotToggleCorner.Parent = aimbotToggle

aimbotToggle.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    aimbotToggle.Text = "Aimbot: " .. (aimbotEnabled and "ON" or "OFF")
end)

-- Target Part Dropdown
local targetPartLabel = Instance.new("TextLabel")
targetPartLabel.Text = "Target Part: "
targetPartLabel.Size = UDim2.new(1, -20, 0, 24)
targetPartLabel.BackgroundTransparency = 1
targetPartLabel.TextColor3 = Color3.fromRGB(255,255,255)
targetPartLabel.Font = Enum.Font.Gotham
targetPartLabel.TextSize = 13
targetPartLabel.Parent = aimbotTab

local targetPartDropdown = Instance.new("TextButton")
targetPartDropdown.Name = "TargetPartDropdown"
targetPartDropdown.Text = aimbotTargetPart
    targetPartDropdown.Size = UDim2.new(1, -20, 0, 28)
targetPartDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
targetPartDropdown.TextColor3 = Color3.fromRGB(255,255,255)
targetPartDropdown.Font = Enum.Font.Gotham
targetPartDropdown.TextSize = 13
targetPartDropdown.BorderSizePixel = 0
targetPartDropdown.Parent = aimbotTab

local targetParts = {"Head", "Torso"}
targetPartDropdown.MouseButton1Click:Connect(function()
    local idx = table.find(targetParts, aimbotTargetPart) or 1
    idx = idx % #targetParts + 1
    aimbotTargetPart = targetParts[idx]
    targetPartDropdown.Text = aimbotTargetPart
end)

-- FOV Slider
local fovLabel = Instance.new("TextLabel")
fovLabel.Text = "FOV: " .. aimbotFOV
fovLabel.Size = UDim2.new(1, -20, 0, 24)
fovLabel.BackgroundTransparency = 1
fovLabel.TextColor3 = Color3.fromRGB(255,255,255)
fovLabel.Font = Enum.Font.Gotham
fovLabel.TextSize = 13
fovLabel.Parent = aimbotTab

local fovSlider = Instance.new("TextButton")
fovSlider.Name = "FOVSlider"
fovSlider.Text = "Zmień FOV"
fovSlider.Size = UDim2.new(1, -20, 0, 28)
fovSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
fovSlider.TextColor3 = Color3.fromRGB(255,255,255)
fovSlider.Font = Enum.Font.Gotham
fovSlider.TextSize = 13
fovSlider.BorderSizePixel = 0
fovSlider.Parent = aimbotTab

fovSlider.MouseButton1Click:Connect(function()
    aimbotFOV = (aimbotFOV + 20) % 360
    if aimbotFOV < 40 then aimbotFOV = 40 end
    fovLabel.Text = "FOV: " .. aimbotFOV
end)

-- Smoothness Slider
local smoothLabel = Instance.new("TextLabel")
smoothLabel.Text = "Smoothness: " .. aimbotSmoothness
smoothLabel.Size = UDim2.new(1, -20, 0, 24)
smoothLabel.BackgroundTransparency = 1
smoothLabel.TextColor3 = Color3.fromRGB(255,255,255)
smoothLabel.Font = Enum.Font.Gotham
smoothLabel.TextSize = 13
smoothLabel.Parent = aimbotTab

local smoothSlider = Instance.new("TextButton")
smoothSlider.Name = "SmoothSlider"
smoothSlider.Text = "Zmień Smoothness"
smoothSlider.Size = UDim2.new(1, -20, 0, 28)
smoothSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
smoothSlider.TextColor3 = Color3.fromRGB(255,255,255)
smoothSlider.Font = Enum.Font.Gotham
smoothSlider.TextSize = 13
smoothSlider.BorderSizePixel = 0
smoothSlider.Parent = aimbotTab

smoothSlider.MouseButton1Click:Connect(function()
    aimbotSmoothness = aimbotSmoothness + 0.1
    if aimbotSmoothness > 1 then aimbotSmoothness = 0.1 end
    smoothLabel.Text = "Smoothness: " .. string.format("%.1f", aimbotSmoothness)
end)

-- Target Priority Dropdown
local priorityLabel = Instance.new("TextLabel")
priorityLabel.Text = "Target Priority: " .. aimbotPriority
priorityLabel.Size = UDim2.new(1, -20, 0, 24)
priorityLabel.BackgroundTransparency = 1
priorityLabel.TextColor3 = Color3.fromRGB(255,255,255)
priorityLabel.Font = Enum.Font.Gotham
priorityLabel.TextSize = 13
priorityLabel.Parent = aimbotTab

local priorityDropdown = Instance.new("TextButton")
priorityDropdown.Name = "PriorityDropdown"
priorityDropdown.Text = aimbotPriority
priorityDropdown.Size = UDim2.new(1, -20, 0, 28)
priorityDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
priorityDropdown.TextColor3 = Color3.fromRGB(255,255,255)
priorityDropdown.Font = Enum.Font.Gotham
priorityDropdown.TextSize = 13
priorityDropdown.BorderSizePixel = 0
priorityDropdown.Parent = aimbotTab

local priorities = {"Nearest", "LowestHP", "Visible"}
priorityDropdown.MouseButton1Click:Connect(function()
    local idx = table.find(priorities, aimbotPriority) or 1
    idx = idx % #priorities + 1
    aimbotPriority = priorities[idx]
    priorityDropdown.Text = aimbotPriority
    priorityLabel.Text = "Target Priority: " .. aimbotPriority
end)

-- Wall Check Toggle
local wallCheckToggle = Instance.new("TextButton")
wallCheckToggle.Name = "WallCheckToggle"
wallCheckToggle.Text = "Wall Check: " .. (aimbotWallCheck and "ON" or "OFF")
wallCheckToggle.Size = UDim2.new(1, -20, 0, 28)
wallCheckToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
wallCheckToggle.TextColor3 = Color3.fromRGB(255,255,255)
wallCheckToggle.Font = Enum.Font.Gotham
wallCheckToggle.TextSize = 13
wallCheckToggle.BorderSizePixel = 0
wallCheckToggle.Parent = aimbotTab

wallCheckToggle.MouseButton1Click:Connect(function()
    aimbotWallCheck = not aimbotWallCheck
    wallCheckToggle.Text = "Wall Check: " .. (aimbotWallCheck and "ON" or "OFF")
end)

-- Silent Aim Toggle
local silentAimToggle = Instance.new("TextButton")
silentAimToggle.Name = "SilentAimToggle"
silentAimToggle.Text = "Silent Aim: " .. (aimbotSilent and "ON" or "OFF")
silentAimToggle.Size = UDim2.new(1, -20, 0, 28)
silentAimToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
silentAimToggle.TextColor3 = Color3.fromRGB(255,255,255)
silentAimToggle.Font = Enum.Font.Gotham
silentAimToggle.TextSize = 13
silentAimToggle.BorderSizePixel = 0
silentAimToggle.Parent = aimbotTab

silentAimToggle.MouseButton1Click:Connect(function()
    aimbotSilent = not aimbotSilent
    silentAimToggle.Text = "Silent Aim: " .. (aimbotSilent and "ON" or "OFF")
end)

-- Startup animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

local startupTween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 450, 0, 320),
    Position = UDim2.new(0.5, -225, 0.5, -160)
})
startupTween:Play()

print("Arsenal Hub loaded! Press F1 to toggle visibility.")
