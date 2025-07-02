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

    -- === Aimbot Tab Content (sliders and keybind) ===
    local aimbotTab = Tabs["Aimbot"]

    -- Make the tab content scrollable
    local aimbotScroll = Instance.new("ScrollingFrame")
    aimbotScroll.Name = "AimbotScroll"
    aimbotScroll.Size = UDim2.new(1, 0, 1, 0)
    aimbotScroll.Position = UDim2.new(0, 0, 0, 0)
    aimbotScroll.BackgroundTransparency = 1
    aimbotScroll.BorderSizePixel = 0
    aimbotScroll.ScrollBarThickness = 6
    aimbotScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
    aimbotScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    aimbotScroll.Parent = aimbotTab

    local aimbotLayout = Instance.new("UIListLayout")
    aimbotLayout.SortOrder = Enum.SortOrder.LayoutOrder
    aimbotLayout.Padding = UDim.new(0, 10)
    aimbotLayout.Parent = aimbotScroll

    -- Update CanvasSize automatically
    local function updateAimbotCanvas()
        aimbotScroll.CanvasSize = UDim2.new(0, 0, 0, aimbotLayout.AbsoluteContentSize.Y + 10)
    end
    aimbotLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateAimbotCanvas)
    updateAimbotCanvas()

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
    aimbotToggle.Parent = aimbotScroll

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
    targetPartLabel.Parent = aimbotScroll

    local targetPartDropdown = Instance.new("TextButton")
    targetPartDropdown.Name = "TargetPartDropdown"
    targetPartDropdown.Text = aimbotTargetPart
    targetPartDropdown.Size = UDim2.new(1, -20, 0, 28)
    targetPartDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    targetPartDropdown.TextColor3 = Color3.fromRGB(255,255,255)
    targetPartDropdown.Font = Enum.Font.Gotham
    targetPartDropdown.TextSize = 13
    targetPartDropdown.BorderSizePixel = 0
    targetPartDropdown.Parent = aimbotScroll

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
    fovLabel.Parent = aimbotScroll

    local fovSlider = Instance.new("Frame")
    fovSlider.Name = "FOVSlider"
    fovSlider.Size = UDim2.new(1, -20, 0, 28)
    fovSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    fovSlider.Parent = aimbotScroll

    local fovBar = Instance.new("Frame")
    fovBar.Size = UDim2.new(aimbotFOV/360, 0, 1, 0)
    fovBar.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    fovBar.BorderSizePixel = 0
    fovBar.Parent = fovSlider

    local fovDrag = false
    fovSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            fovDrag = true
        end
    end)
    fovSlider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            fovDrag = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if fovDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
            local absPos = fovSlider.AbsolutePosition.X
            local absSize = fovSlider.AbsoluteSize.X
            local mouseX = input.Position.X
            local percent = math.clamp((mouseX - absPos) / absSize, 0, 1)
            aimbotFOV = math.floor(percent * 360)
            if aimbotFOV < 40 then aimbotFOV = 40 end
            fovBar.Size = UDim2.new(aimbotFOV/360, 0, 1, 0)
            fovLabel.Text = "FOV: " .. aimbotFOV
        end
    end)

    -- Smoothness Slider
    local smoothLabel = Instance.new("TextLabel")
    smoothLabel.Text = "Smoothness: " .. aimbotSmoothness
    smoothLabel.Size = UDim2.new(1, -20, 0, 24)
    smoothLabel.BackgroundTransparency = 1
    smoothLabel.TextColor3 = Color3.fromRGB(255,255,255)
    smoothLabel.Font = Enum.Font.Gotham
    smoothLabel.TextSize = 13
    smoothLabel.Parent = aimbotScroll

    local smoothSlider = Instance.new("Frame")
    smoothSlider.Name = "SmoothSlider"
    smoothSlider.Size = UDim2.new(1, -20, 0, 28)
    smoothSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    smoothSlider.Parent = aimbotScroll

    local smoothBar = Instance.new("Frame")
    smoothBar.Size = UDim2.new(aimbotSmoothness, 0, 1, 0)
    smoothBar.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    smoothBar.BorderSizePixel = 0
    smoothBar.Parent = smoothSlider

    local smoothDrag = false
    smoothSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            smoothDrag = true
        end
    end)
    smoothSlider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            smoothDrag = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if smoothDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
            local absPos = smoothSlider.AbsolutePosition.X
            local absSize = smoothSlider.AbsoluteSize.X
            local mouseX = input.Position.X
            local percent = math.clamp((mouseX - absPos) / absSize, 0, 1)
            aimbotSmoothness = math.floor(percent * 100) / 100
            if aimbotSmoothness < 0.05 then aimbotSmoothness = 0.05 end
            smoothBar.Size = UDim2.new(aimbotSmoothness, 0, 1, 0)
            smoothLabel.Text = "Smoothness: " .. string.format("%.2f", aimbotSmoothness)
        end
    end)

    -- Aimbot Keybind Selector
    local keybindLabel = Instance.new("TextLabel")
    keybindLabel.Text = "Aimbot Keybind: RightMouseButton"
    keybindLabel.Size = UDim2.new(1, -20, 0, 24)
    keybindLabel.BackgroundTransparency = 1
    keybindLabel.TextColor3 = Color3.fromRGB(255,255,255)
    keybindLabel.Font = Enum.Font.Gotham
    keybindLabel.TextSize = 13
    keybindLabel.Parent = aimbotScroll

    local keybindButton = Instance.new("TextButton")
    keybindButton.Name = "KeybindButton"
    keybindButton.Text = "Change Keybind"
    keybindButton.Size = UDim2.new(1, -20, 0, 28)
    keybindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    keybindButton.TextColor3 = Color3.fromRGB(255,255,255)
    keybindButton.Font = Enum.Font.Gotham
    keybindButton.TextSize = 13
    keybindButton.BorderSizePixel = 0
    keybindButton.Parent = aimbotScroll

    local aimbotKeybind = Enum.UserInputType.MouseButton2 -- Default: Right Mouse Button
    local waitingForKey = false
    keybindButton.MouseButton1Click:Connect(function()
        waitingForKey = true
        keybindButton.Text = "Press any key..."
    end)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if waitingForKey and not gameProcessed then
            if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                aimbotKeybind = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
                keybindLabel.Text = "Aimbot Keybind: " .. (input.KeyCode and tostring(input.KeyCode) or tostring(input.UserInputType))
                keybindButton.Text = "Change Keybind"
                waitingForKey = false
            end
        end
    end)

    -- Track if aimbot key is held
    local aimbotKeyHeld = false
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed then
            if (aimbotKeybind == input.UserInputType) or (aimbotKeybind == input.KeyCode) then
                aimbotKeyHeld = true
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if not gameProcessed then
            if (aimbotKeybind == input.UserInputType) or (aimbotKeybind == input.KeyCode) then
                aimbotKeyHeld = false
            end
        end
    end)

    -- === AIMBOT LOGIC ===

    local function isOnScreen(pos)
        local viewport = camera.ViewportSize
        return pos.X > 0 and pos.X < viewport.X and pos.Y > 0 and pos.Y < viewport.Y
    end

    local function isVisible(from, to)
        if not aimbotWallCheck then return true end
        local ray = Ray.new(from, (to - from).Unit * (to - from).Magnitude)
        local hit = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character, camera})
        if hit then
            return false
        end
        return true
    end

    local function getTarget()
        local closest = nil
        local closestDist = math.huge
        local lowestHP = math.huge
        local screenCenter = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Team ~= player.Team and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                local part = p.Character:FindFirstChild(aimbotTargetPart)
                if part then
                    local pos, onScreen = camera:WorldToViewportPoint(part.Position)
                    if onScreen and isOnScreen(Vector2.new(pos.X, pos.Y)) then
                        local dist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                        if dist <= aimbotFOV then
                            if aimbotWallCheck and not isVisible(camera.CFrame.Position, part.Position) then
                                continue
                            end
                            if aimbotPriority == "Nearest" then
                                if dist < closestDist then
                                    closest = {player=p, part=part, dist=dist}
                                    closestDist = dist
                                end
                            elseif aimbotPriority == "LowestHP" then
                                if p.Character.Humanoid.Health < lowestHP then
                                    closest = {player=p, part=part, dist=dist}
                                    lowestHP = p.Character.Humanoid.Health
                                end
                            elseif aimbotPriority == "Visible" then
                                if isVisible(camera.CFrame.Position, part.Position) and dist < closestDist then
                                    closest = {player=p, part=part, dist=dist}
                                    closestDist = dist
                                end
                            end
                        end
                    end
                end
            end
        end
        return closest
    end

    local function aimAt(target)
        if not target then return end
        local part = target.part
        local camPos = camera.CFrame.Position
        local dir = (part.Position - camPos).Unit
        local newCF = CFrame.new(camPos, camPos + dir)
        camera.CFrame = camera.CFrame:Lerp(newCF, aimbotSmoothness)
    end

    -- Silent Aim: override mouse hit position
    local oldNamecall
    if aimbotSilent then
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if method == "FindPartOnRayWithIgnoreList" and aimbotEnabled then
                local target = getTarget()
                if target then
                    local args = {...}
                    local from = camera.CFrame.Position
                    local to = target.part.Position
                    args[1] = Ray.new(from, (to - from).Unit * (to - from).Magnitude)
                    return oldNamecall(self, unpack(args))
                end
            end
            return oldNamecall(self, ...)
        end)
    end

    -- Main aimbot loop
    RunService.RenderStepped:Connect(function()
        if not aimbotEnabled then return end
        if not aimbotKeyHeld then return end
        if aimbotSilent then return end -- silent aim handles aiming
        local target = getTarget()
        if target then
            aimAt(target)
        end
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
