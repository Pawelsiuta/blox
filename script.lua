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
Title.Text = "🎯 ARSENAL HUB"
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

-- Content Frame
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -70)
ContentFrame.Position = UDim2.new(0, 10, 0, 60)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 6
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
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
    button.BackgroundColor3 = color or Color3.fromRGB(60, 60, 80)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.BorderSizePixel = 0
    button.Parent = buttonFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    local buttonGradient = Instance.new("UIGradient")
    buttonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color or Color3.fromRGB(60, 60, 80)),
        ColorSequenceKeypoint.new(1, color and Color3.new(color.R * 0.8, color.G * 0.8, color.B * 0.8) or Color3.fromRGB(45, 45, 65))
    }
    buttonGradient.Rotation = 90
    buttonGradient.Parent = button
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = color and Color3.new(color.R * 1.2, color.G * 1.2, color.B * 1.2) or Color3.fromRGB(80, 80, 100)
        })
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = color or Color3.fromRGB(60, 60, 80)
        })
        tween:Play()
    end)
    
    return button
end

-- Status display
local StatusFrame = Instance.new("Frame")
StatusFrame.Name = "StatusFrame"
StatusFrame.Size = UDim2.new(1, -20, 0, 30)
StatusFrame.Position = UDim2.new(0, 10, 1, -40)
StatusFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
StatusFrame.BorderSizePixel = 0
StatusFrame.Parent = MainFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 6)
StatusCorner.Parent = StatusFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Text = "Ready"
StatusLabel.Size = UDim2.new(1, -10, 1, 0)
StatusLabel.Position = UDim2.new(0, 5, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusFrame

-- Tworzenie przycisków
local btnFastFire = createButton("🔥 Fast Fire: OFF", 1, Color3.fromRGB(255, 100, 100))
local btnInfAmmo = createButton("∞ Infinite Ammo: OFF", 2, Color3.fromRGB(100, 200, 255))
local btnEnemyFollow = createButton("🎯 Enemy Follow: OFF", 3, Color3.fromRGB(255, 200, 100))
local btnESP = createButton("👁️ ESP: OFF", 4, Color3.fromRGB(150, 255, 150))
local btnNoRecoil = createButton("🎯 No Recoil: OFF", 5, Color3.fromRGB(200, 150, 255))

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
    
    MinimizeButton.Text = isMinimized and "+" or "−"
end)

-- Funkcje statusu
local function updateStatus(message, color)
    StatusLabel.Text = message
    StatusLabel.TextColor3 = color or Color3.fromRGB(150, 255, 150)
end

-- Zmienne stanu
local fastFireEnabled = false
local infAmmoEnabled = false
local enemyFollowEnabled = false
local espEnabled = false
local noRecoilEnabled = false

-- Fast Fire System
local fastFireConnection
btnFastFire.MouseButton1Click:Connect(function()
    fastFireEnabled = not fastFireEnabled
    btnFastFire.Text = "🔥 Fast Fire: " .. (fastFireEnabled and "ON" or "OFF")
    
    if fastFireEnabled then
        updateStatus("Fast Fire activated", Color3.fromRGB(255, 150, 150))
        fastFireConnection = spawn(function()
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
    else
        updateStatus("Fast Fire deactivated", Color3.fromRGB(255, 100, 100))
    end
end)

-- Infinite Ammo System
local infAmmoConnection
btnInfAmmo.MouseButton1Click:Connect(function()
    infAmmoEnabled = not infAmmoEnabled
    btnInfAmmo.Text = "∞ Infinite Ammo: " .. (infAmmoEnabled and "ON" or "OFF")
    
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
    btnEnemyFollow.Text = "🎯 Enemy Follow: " .. (enemyFollowEnabled and "ON" or "OFF")
    
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
    btnESP.Text = "👁️ ESP: " .. (espEnabled and "ON" or "OFF")

    if espEnabled then
        updateStatus("ESP activated", Color3.fromRGB(150, 255, 150))
        espConnection = RunService:BindToRenderStep("ESP", Enum.RenderPriority.Camera.Value, function()
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
            RunService:UnbindFromRenderStep("ESP")
            espConnection = nil
        end
        for _, drawings in pairs(espCache) do
            drawings.box.Visible = false
            drawings.boxoutline.Visible = false
        end
    end
end)

-- No Recoil System
local noRecoilConnection
btnNoRecoil.MouseButton1Click:Connect(function()
    noRecoilEnabled = not noRecoilEnabled
    btnNoRecoil.Text = "🎯 No Recoil: " .. (noRecoilEnabled and "ON" or "OFF")
    
    if noRecoilEnabled then
        updateStatus("No Recoil activated", Color3.fromRGB(200, 150, 255))
        noRecoilConnection = spawn(function()
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
    else
        updateStatus("No Recoil deactivated", Color3.fromRGB(150, 100, 200))
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
