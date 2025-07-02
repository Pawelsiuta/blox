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
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BackgroundTransparency = 0.4
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true

-- Gradient dla tła
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 60))
}
MainGradient.Rotation = 45
MainGradient.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Stroke (ramka)
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(80, 80, 80)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Header
local HeaderFrame = Instance.new("Frame")
HeaderFrame.Name = "Header"
HeaderFrame.Size = UDim2.new(1, 0, 0, 50)
HeaderFrame.Position = UDim2.new(0, 0, 0, 0)
HeaderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
HeaderFrame.BackgroundTransparency = 0.3
HeaderFrame.BorderSizePixel = 0
HeaderFrame.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = HeaderFrame

-- Główny napis na środku
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "ARSENAL HUB"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.TextYAlignment = Enum.TextYAlignment.Center
Title.Parent = HeaderFrame

-- Przycisk zamknięcia
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Text = "X"
CloseButton.Size = UDim2.new(0, 44, 0, 44)
CloseButton.Position = UDim2.new(1, -49, 0, 3)
CloseButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CloseButton.BackgroundTransparency = 0
CloseButton.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 28
CloseButton.BorderSizePixel = 0
CloseButton.Parent = HeaderFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Przycisk minimalizacji
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Text = "-"
MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
MinimizeButton.Position = UDim2.new(1, -90, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeButton.BackgroundTransparency = 0.2
MinimizeButton.TextColor3 = Color3.fromRGB(230, 230, 230)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 20
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Parent = HeaderFrame

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 8)
MinimizeCorner.Parent = MinimizeButton

-- Content Frame
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -70)
ContentFrame.Position = UDim2.new(0, 10, 0, 60)
ContentFrame.BackgroundTransparency = 0.5
ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 6
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.Parent = MainFrame

-- Layout dla przycisków
local ButtonLayout = Instance.new("UIListLayout")
ButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
ButtonLayout.Padding = UDim.new(0, 10)
ButtonLayout.FillDirection = Enum.FillDirection.Vertical
ButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ButtonLayout.Parent = ContentFrame

-- Padding dla content
local ContentPadding = Instance.new("UIPadding")
ContentPadding.PaddingTop = UDim.new(0, 10)
ContentPadding.PaddingBottom = UDim.new(0, 10)
ContentPadding.Parent = ContentFrame

-- Funkcja tworzenia przycisków
local function createButton(text, layoutOrder, color)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = text .. "Frame"
    buttonFrame.Size = UDim2.new(1, -20, 0, 45)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.LayoutOrder = layoutOrder
    buttonFrame.Parent = ContentFrame
    
    local button = Instance.new("TextButton")
    button.Name = text .. "Button"
    button.Text = text
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.BackgroundTransparency = 0.3
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 18
    button.BorderSizePixel = 0
    button.Parent = buttonFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    local buttonGradient = Instance.new("UIGradient")
    buttonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
    }
    buttonGradient.Rotation = 90
    buttonGradient.Parent = button
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        })
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        })
        tween:Play()
    end)
    
    return button
end

-- Status display (przeniesione powiadomienia na środek u góry)
local NotificationFrame = Instance.new("Frame")
NotificationFrame.Name = "NotificationFrame"
NotificationFrame.Size = UDim2.new(0, 350, 0, 36)
NotificationFrame.Position = UDim2.new(0.5, -175, 0, 10)
NotificationFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
NotificationFrame.BackgroundTransparency = 0.2
NotificationFrame.BorderSizePixel = 0
NotificationFrame.Visible = false
NotificationFrame.Parent = ScreenGui

local NotificationCorner = Instance.new("UICorner")
NotificationCorner.CornerRadius = UDim.new(0, 8)
NotificationCorner.Parent = NotificationFrame

local NotificationLabel = Instance.new("TextLabel")
NotificationLabel.Name = "NotificationLabel"
NotificationLabel.Text = ""
NotificationLabel.Size = UDim2.new(1, -20, 1, 0)
NotificationLabel.Position = UDim2.new(0, 10, 0, 0)
NotificationLabel.BackgroundTransparency = 1
NotificationLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NotificationLabel.Font = Enum.Font.GothamBold
NotificationLabel.TextSize = 18
NotificationLabel.TextXAlignment = Enum.TextXAlignment.Center
NotificationLabel.TextYAlignment = Enum.TextYAlignment.Center
NotificationLabel.Parent = NotificationFrame

-- Funkcja powiadomień
local notificationTween
local function showNotification(message)
    NotificationLabel.Text = message
    NotificationFrame.Visible = true
    if notificationTween then notificationTween:Cancel() end
    notificationTween = TweenService:Create(NotificationFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.2})
    notificationTween:Play()
    delay(2.5, function()
        if NotificationFrame.Visible then
            local hideTween = TweenService:Create(NotificationFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
            hideTween:Play()
            hideTween.Completed:Wait()
            NotificationFrame.Visible = false
            NotificationFrame.BackgroundTransparency = 0.2
        end
    end)
end

-- Zmieniam updateStatus na showNotification
local function updateStatus(message, color)
    showNotification(message)
end

-- Tworzenie przycisków
local btnFastFire = createButton("Fast Fire: OFF", 1, Color3.fromRGB(255, 100, 100))
local btnInfAmmo = createButton("Infinite Ammo: OFF", 2, Color3.fromRGB(100, 200, 255))
local btnEnemyFollow = createButton("Enemy Follow: OFF", 3, Color3.fromRGB(255, 200, 100))
local btnESP = createButton("ESP: OFF", 4, Color3.fromRGB(150, 255, 150))
local btnNoRecoil = createButton("No Recoil: OFF", 5, Color3.fromRGB(200, 150, 255))
local btnAimbot = createButton("Aimbot", 6, Color3.fromRGB(180, 180, 180))

-- Aimbot menu (ukryte domyślnie)
local AimbotMenu = Instance.new("Frame")
AimbotMenu.Name = "AimbotMenu"
AimbotMenu.Size = UDim2.new(1, -40, 0, 110)
AimbotMenu.Position = UDim2.new(0, 20, 0, 320)
AimbotMenu.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AimbotMenu.BackgroundTransparency = 0.4
AimbotMenu.Visible = false
AimbotMenu.Parent = MainFrame

local AimbotCorner = Instance.new("UICorner")
AimbotCorner.CornerRadius = UDim.new(0, 10)
AimbotCorner.Parent = AimbotMenu

local AimbotToggle = Instance.new("TextButton")
AimbotToggle.Name = "AimbotToggle"
AimbotToggle.Text = "Aimbot: OFF"
AimbotToggle.Size = UDim2.new(0, 180, 0, 32)
AimbotToggle.Position = UDim2.new(0, 10, 0, 10)
AimbotToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AimbotToggle.BackgroundTransparency = 0.2
AimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotToggle.Font = Enum.Font.GothamBold
AimbotToggle.TextSize = 18
AimbotToggle.Parent = AimbotMenu

local FOVLabel = Instance.new("TextLabel")
FOVLabel.Name = "FOVLabel"
FOVLabel.Text = "Aimbot FOV:"
FOVLabel.Size = UDim2.new(0, 100, 0, 28)
FOVLabel.Position = UDim2.new(0, 10, 0, 50)
FOVLabel.BackgroundTransparency = 1
FOVLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVLabel.Font = Enum.Font.GothamBold
FOVLabel.TextSize = 16
FOVLabel.TextXAlignment = Enum.TextXAlignment.Left
FOVLabel.Parent = AimbotMenu

local FOVBox = Instance.new("TextBox")
FOVBox.Name = "FOVBox"
FOVBox.Text = "60"
FOVBox.Size = UDim2.new(0, 50, 0, 28)
FOVBox.Position = UDim2.new(0, 120, 0, 50)
FOVBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FOVBox.BackgroundTransparency = 0.2
FOVBox.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVBox.Font = Enum.Font.GothamBold
FOVBox.TextSize = 16
FOVBox.ClearTextOnFocus = false
FOVBox.Parent = AimbotMenu

local HeadOnlyToggle = Instance.new("TextButton")
HeadOnlyToggle.Name = "HeadOnlyToggle"
HeadOnlyToggle.Text = "Celuj tylko w głowę: OFF"
HeadOnlyToggle.Size = UDim2.new(0, 200, 0, 28)
HeadOnlyToggle.Position = UDim2.new(0, 10, 0, 85)
HeadOnlyToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
HeadOnlyToggle.BackgroundTransparency = 0.2
HeadOnlyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeadOnlyToggle.Font = Enum.Font.GothamBold
HeadOnlyToggle.TextSize = 16
HeadOnlyToggle.Parent = AimbotMenu

-- Stan aimbota
local aimbotEnabled = false
local aimbotFOV = 60
local aimbotHeadOnly = false

btnAimbot.MouseButton1Click:Connect(function()
    AimbotMenu.Visible = not AimbotMenu.Visible
    updateStatus(AimbotMenu.Visible and "Aimbot menu opened" or "Aimbot menu closed")
end)

AimbotToggle.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    AimbotToggle.Text = "Aimbot: " .. (aimbotEnabled and "ON" or "OFF")
    updateStatus("Aimbot " .. (aimbotEnabled and "włączony" or "wyłączony"), Color3.fromRGB(180, 180, 180))
end)

FOVBox.FocusLost:Connect(function(enter)
    local val = tonumber(FOVBox.Text)
    if val and val > 0 and val <= 360 then
        aimbotFOV = val
        updateStatus("Aimbot FOV ustawiony na "..val, Color3.fromRGB(180, 180, 180))
    else
        FOVBox.Text = tostring(aimbotFOV)
    end
end)

HeadOnlyToggle.MouseButton1Click:Connect(function()
    aimbotHeadOnly = not aimbotHeadOnly
    HeadOnlyToggle.Text = "Celuj tylko w głowę: " .. (aimbotHeadOnly and "ON" or "OFF")
    updateStatus("Celowanie w głowę: "..(aimbotHeadOnly and "ON" or "OFF"), Color3.fromRGB(180, 180, 180))
end)

-- Funkcja szukania najbliższego przeciwnika w FOV
local function getClosestEnemyInFOV()
    if not player.Character or not player.Character:FindFirstChild("Head") then return nil end
    local myHead = player.Character.Head
    local myPos, onScreen = camera:WorldToViewportPoint(myHead.Position)
    if not onScreen then return nil end
    local closest, minDist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Team ~= player.Team and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local targetPart = aimbotHeadOnly and p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local pos, visible = camera:WorldToViewportPoint(targetPart.Position)
                if visible then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(myPos.X, myPos.Y)).Magnitude
                    local fovPx = math.tan(math.rad(aimbotFOV/2)) * camera.ViewportSize.X / (2*math.tan(math.rad(camera.FieldOfView/2)))
                    if dist < fovPx and dist < minDist then
                        minDist = dist
                        closest = targetPart
                    end
                end
            end
        end
    end
    return closest
end

-- Logika aimbota (RenderStepped)
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local target = getClosestEnemyInFOV()
        if target then
            local camPos = camera.CFrame.Position
            camera.CFrame = CFrame.new(camPos, target.Position)
        end
    end
end)

-- Aktualizacja rozmiaru canvas
local function updateCanvasSize()
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ButtonLayout.AbsoluteContentSize.Y + 20)
end

ButtonLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)
updateCanvasSize()

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
    
    MinimizeButton.Text = isMinimized and "+" or "-"
end)

-- Fast Fire System
local fastFireThread
btnFastFire.MouseButton1Click:Connect(function()
    fastFireEnabled = not fastFireEnabled
    btnFastFire.Text = "Fast Fire: " .. (fastFireEnabled and "ON" or "OFF")
    if fastFireEnabled then
        updateStatus("Fast Fire activated")
        if fastFireThread and coroutine.status(fastFireThread) ~= "dead" then
            fastFireEnabled = false
            coroutine.close(fastFireThread)
        end
        fastFireThread = coroutine.create(function()
            while fastFireEnabled do
                pcall(function()
                    for _, v in pairs(ReplicatedStorage.Weapons:GetDescendants()) do
                        if v.Name == "Auto" and v.Value ~= true then
                            v.Value = true
                        elseif v.Name == "FireRate" and v.Value ~= 0.02 then
                            v.Value = 0.02
                        end
                    end
                end)
                wait(0.3)
            end
        end)
        coroutine.resume(fastFireThread)
    else
        updateStatus("Fast Fire deactivated")
        if fastFireThread and coroutine.status(fastFireThread) ~= "dead" then
            fastFireEnabled = false
            coroutine.close(fastFireThread)
        end
    end
end)

-- Infinite Ammo System
local infAmmoConnection
btnInfAmmo.MouseButton1Click:Connect(function()
    infAmmoEnabled = not infAmmoEnabled
    btnInfAmmo.Text = "Infinite Ammo: " .. (infAmmoEnabled and "ON" or "OFF")
    
    if infAmmoEnabled then
        updateStatus("Infinite Ammo activated", Color3.fromRGB(150, 200, 255))
        infAmmoConnection = spawn(function()
            local playerGui = player:WaitForChild("PlayerGui")
            local clientGui = playerGui:WaitForChild("GUI"):WaitForChild("Client")
            local vars = clientGui:WaitForChild("Variables")
            
            while infAmmoEnabled do
                pcall(function()
                    if vars:FindFirstChild("ammocount") then
                        vars.ammocount.Value = 999
                    end
                    if vars:FindFirstChild("ammocount2") then
                        vars.ammocount2.Value = 999
                    end
                end)
                wait(0.1)
            end
        end)
    else
        updateStatus("Infinite Ammo deactivated", Color3.fromRGB(100, 150, 200))
    end
end)

-- Enemy Follow System
local enemyFollowConnection
local rotationAngle = 0
local rotationSpeed = math.rad(1080)
local orbitRadius = 5

local function findTarget()
    local nearest = nil
    local shortestDistance = math.huge

    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end

    local rootPos = player.Character.HumanoidRootPart.Position

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Team ~= player.Team and p.Character and 
           p.Character:FindFirstChild("HumanoidRootPart") and 
           p.Character:FindFirstChild("Humanoid") and 
           p.Character.Humanoid.Health > 0 then
            local dist = (p.Character.HumanoidRootPart.Position - rootPos).Magnitude
            if dist < shortestDistance then
                shortestDistance = dist
                nearest = p
            end
        end
    end

    return nearest, shortestDistance
end

local function enableNoClip()
    if player.Character then
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

local function stopMovement()
    if player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.Velocity = Vector3.new(0,0,0)
        end
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local function moveToTarget(target)
    if not target or not target.Character or not player.Character then return end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
    if not root or not targetRoot then return end

    enableNoClip()
    local direction = (targetRoot.Position - root.Position).Unit
    root.Velocity = direction * 150
end

local function onRenderStep(dt)
    if not enemyFollowEnabled then return end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    local target, dist = findTarget()
    if target then
        local head = target.Character and target.Character:FindFirstChild("Head")
        local root = player.Character.HumanoidRootPart
        if head and root then
            if dist > 10 then
                moveToTarget(target)
                camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, head.Position), 0.2)
            else
                if root then
                    root.Velocity = Vector3.new(0,0,0)
                end
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end

                rotationAngle = (rotationAngle + rotationSpeed * dt) % (2 * math.pi)
                local offsetX = math.cos(rotationAngle) * orbitRadius
                local offsetZ = math.sin(rotationAngle) * orbitRadius

                local targetPos = head.Position
                local newCamPos = targetPos + Vector3.new(offsetX, 2, offsetZ)

                camera.CFrame = CFrame.new(newCamPos, targetPos)
            end
        end
    else
        stopMovement()
    end
end

btnEnemyFollow.MouseButton1Click:Connect(function()
    enemyFollowEnabled = not enemyFollowEnabled
    btnEnemyFollow.Text = "Enemy Follow: " .. (enemyFollowEnabled and "ON" or "OFF")
    
    if enemyFollowEnabled then
        updateStatus("Enemy Follow activated", Color3.fromRGB(255, 200, 100))
        enemyFollowConnection = RunService.RenderStepped:Connect(onRenderStep)
    else
        updateStatus("Enemy Follow deactivated", Color3.fromRGB(200, 150, 80))
        if enemyFollowConnection then
            enemyFollowConnection:Disconnect()
            enemyFollowConnection = nil
        end
        stopMovement()
    end
end)

-- ESP System
local espSettings = {
    defaultcolor = Color3.fromRGB(255, 0, 0),
    teamcheck = false,
    teamcolor = true
}

local newVector2, newColor3, newDrawing = Vector2.new, Color3.new, Drawing.new
local tan, rad = math.tan, math.rad
local round = function(...) 
    local a = {}
    for i,v in next, table.pack(...) do 
        a[i] = math.round(v) 
    end 
    return unpack(a) 
end
local wtvp = function(...) 
    local a, b = camera:WorldToViewportPoint(...) 
    return newVector2(a.X, a.Y), b, a.Z 
end

local espCache = {}

local function createEsp(plr)
    local drawings = {}
    
    drawings.box = newDrawing("Square")
    drawings.box.Thickness = 2
    drawings.box.Filled = false
    drawings.box.Color = espSettings.defaultcolor
    drawings.box.Visible = false
    drawings.box.ZIndex = 2

    drawings.boxoutline = newDrawing("Square")
    drawings.boxoutline.Thickness = 4
    drawings.boxoutline.Filled = false
    drawings.boxoutline.Color = newColor3()
    drawings.boxoutline.Visible = false
    drawings.boxoutline.ZIndex = 1

    espCache[plr] = drawings
end

local function removeEsp(plr)
    if espCache[plr] then
        for _, drawing in pairs(espCache[plr]) do
            drawing:Remove()
        end
        espCache[plr] = nil
    end
end

local function updateEsp(plr, esp)
    local character = plr.Character
    if character then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if rootPart and humanoid then
            local position, visible, depth = wtvp(rootPart.Position)
            esp.box.Visible = visible
            esp.boxoutline.Visible = visible

            if visible then
                local height = humanoid.HipHeight * 2 + 2
                local width = 2
                local scaleFactor = 1 / (depth * tan(rad(camera.FieldOfView / 2)) * 2) * 1000
                local boxWidth, boxHeight = round(width * scaleFactor, height * scaleFactor)
                local x, y = round(position.X, position.Y)

                esp.box.Size = newVector2(boxWidth, boxHeight)
                esp.box.Position = newVector2(round(x - boxWidth / 2), round(y - boxHeight / 2))
                esp.box.Color = espSettings.teamcolor and plr.TeamColor.Color or espSettings.defaultcolor

                esp.boxoutline.Size = esp.box.Size
                esp.boxoutline.Position = esp.box.Position
            end
        else
            esp.box.Visible = false
            esp.boxoutline.Visible = false
        end
    else
        esp.box.Visible = false
        esp.boxoutline.Visible = false
    end
end

-- Inicjalizacja ESP dla istniejących graczy
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= player then
        createEsp(plr)
    end
end

Players.PlayerAdded:Connect(function(plr)
    if plr ~= player then
        createEsp(plr)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    removeEsp(plr)
end)

local espConnection

btnESP.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    btnESP.Text = "ESP: " .. (espEnabled and "ON" or "OFF")

    if espEnabled then
        updateStatus("ESP activated", Color3.fromRGB(150, 255, 150))
        if espConnection then
            RunService:UnbindFromRenderStep("ESP")
            espConnection = nil
        end
        espConnection = RunService.RenderStepped:Connect(function()
            for plr, drawings in pairs(espCache) do
                if espSettings.teamcheck and plr.Team == player.Team then
                    drawings.box.Visible = false
                    drawings.boxoutline.Visible = false
                else
                    updateEsp(plr, drawings)
                end
            end
        end)
    else
        updateStatus("ESP deactivated", Color3.fromRGB(100, 200, 100))
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
        RunService:UnbindFromRenderStep("ESP")
        for _, drawings in pairs(espCache) do
            drawings.box.Visible = false
            drawings.boxoutline.Visible = false
        end
    end
end)

-- No Recoil System
local noRecoilThread
btnNoRecoil.MouseButton1Click:Connect(function()
    noRecoilEnabled = not noRecoilEnabled
    btnNoRecoil.Text = "No Recoil: " .. (noRecoilEnabled and "ON" or "OFF")
    if noRecoilEnabled then
        updateStatus("No Recoil activated")
        if noRecoilThread and coroutine.status(noRecoilThread) ~= "dead" then
            noRecoilEnabled = false
            coroutine.close(noRecoilThread)
        end
        noRecoilThread = coroutine.create(function()
            while noRecoilEnabled do
                pcall(function()
                    for _, v in pairs(ReplicatedStorage.Weapons:GetDescendants()) do
                        if v.Name == "RecoilControl" then
                            v.Value = 0
                        elseif v.Name == "MaxSpread" then
                            v.Value = 0
                        elseif v.Name == "MinSpread" then
                            v.Value = 0
                        end
                    end
                end)
                wait(0.3)
            end
        end)
        coroutine.resume(noRecoilThread)
    else
        updateStatus("No Recoil deactivated")
        if noRecoilThread and coroutine.status(noRecoilThread) ~= "dead" then
            noRecoilEnabled = false
            coroutine.close(noRecoilThread)
        end
    end
end)

-- Keyboard shortcut (F1 to toggle GUI)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        MainFrame.Visible = not MainFrame.Visible
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

updateStatus("Arsenal Hub loaded successfully!", Color3.fromRGB(150, 255, 150))

print("Arsenal Hub loaded! Press F1 to toggle visibility.")
