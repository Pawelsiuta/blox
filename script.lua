        -- Arsenal Game Script - Improved Version
        local CoreGui = game:GetService("CoreGui")
        local RunService = game:GetService("RunService")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Players = game:GetService("Players")
        local UserInputService = game:GetService("UserInputService")
        local TweenService = game:GetService("TweenService")

        local player = Players.LocalPlayer
        local camera = workspace.CurrentCamera

        -- All old aimbot tab, scroll frame, toggles, sliders, dropdowns, and legacy button/slider logic have been deleted.
        -- All new Solaris GUI creation code is now grouped at the top of the script, organized and clean.
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
        MainFrame.BackgroundColor3 = Color3.fromRGB(24, 26, 34)
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
        HeaderFrame.BackgroundColor3 = Color3.fromRGB(24, 26, 34)
        HeaderFrame.BorderSizePixel = 0
        HeaderFrame.Parent = MainFrame

        -- Tytuł
        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.Text = "Aetheris"
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
        CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseButton.Font = Enum.Font.GothamBold
        CloseButton.TextSize = 16
        CloseButton.BorderSizePixel = 0
        CloseButton.Parent = HeaderFrame

        if CloseButton then
            CloseButton.BackgroundTransparency = 1
            CloseButton.BackgroundColor3 = Color3.new(0,0,0)
            CloseButton.Text = "✕"
            CloseButton.TextSize = 24
            CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
            CloseButton.Size = UDim2.new(0, 40, 0, 40)
            CloseButton.Position = UDim2.new(1, -45, 0, 5)
            CloseButton.BorderSizePixel = 0
            for _, child in ipairs(CloseButton:GetChildren()) do
                if child:IsA("UIPadding") or child:IsA("UICorner") then child:Destroy() end
            end
        end

        -- Przycisk minimalizacji
        local MinimizeButton = Instance.new("TextButton")
        MinimizeButton.Name = "MinimizeButton"
        MinimizeButton.Text = "−"
        MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
        MinimizeButton.Position = UDim2.new(1, -90, 0, 5)
        MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        MinimizeButton.Font = Enum.Font.GothamBold
        MinimizeButton.TextSize = 20
        MinimizeButton.BorderSizePixel = 0
        MinimizeButton.Parent = HeaderFrame

        if MinimizeButton then MinimizeButton.BackgroundTransparency = 1; MinimizeButton.BackgroundColor3 = Color3.new(0,0,0) end

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

        -- === SOLARIS-STYLE GUI FULL REBUILD ===
        -- Sidebar: large, bold, spaced, light blue accent for active
        -- Main: header in rounded blue rectangle, options in dark rounded rectangles, sliders blue on dark, all text white/light gray, Gotham Bold

        -- === WORKING ESP SYSTEM (from dzialajacy esp.lua) ===
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

        -- Initialize ESP for existing players
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

        -- Replace ESP button logic to use working ESP
        do
            local btn = btnESP or Instance.new("TextButton")
            btn.MouseButton1Click:Connect(function()
                espEnabled = not espEnabled
                btn.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
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
        end

        -- === ESP SETTINGS & TAB ===
        local espEnabled = false
        local boxESPEnabled = false
        local nameESPEnabled = false
        local healthbarESPEnabled = false
        local dynamicScalingEnabled = false
        local teamCheckEnabled = false
        local colorByTeamEnabled = false

        -- Drawing Library check
        local drawingAvailable = false
        local drawingTest
        pcall(function()
            drawingTest = Drawing.new("Text")
            drawingTest.Text = "Drawing Test"
            drawingTest.Visible = false
            drawingTest:Remove()
            drawingAvailable = true
        end)
        if not drawingAvailable then
            warn("[Arsenal Hub] Drawing Library is not available! ESP and aimbot visuals will not work.")
            -- Show notification in GUI
            local notif = Instance.new("TextLabel")
            notif.Text = "[Arsenal Hub] Drawing Library is not available! ESP and aimbot visuals will not work."
            notif.Size = UDim2.new(1, 0, 0, 32)
            notif.Position = UDim2.new(0, 0, 0, 0)
            notif.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
            notif.TextColor3 = Color3.fromRGB(255,255,255)
            notif.Font = Enum.Font.GothamBold
            notif.TextSize = 14
            notif.Parent = MainFrame
        end

        -- Debug prints for ESP and aimbot
        print("[Arsenal Hub] Drawing Library available:", drawingAvailable)

        -- ESP Tab Content
        local espTab = Tabs["Visuals"]
        local espScroll = Instance.new("ScrollingFrame")
        espScroll.Name = "ESPScroll"
        espScroll.Size = UDim2.new(1, 0, 1, 0)
        espScroll.Position = UDim2.new(0, 0, 0, 0)
        espScroll.BackgroundTransparency = 1
        espScroll.BorderSizePixel = 0
        espScroll.ScrollBarThickness = 6
        espScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
        espScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        espScroll.Parent = espTab

        local espLayout = Instance.new("UIListLayout")
        espLayout.SortOrder = Enum.SortOrder.LayoutOrder
        espLayout.Padding = UDim.new(0, 10)
        espLayout.Parent = espScroll
        local function updateESPCanvas()
            espScroll.CanvasSize = UDim2.new(0, 0, 0, espLayout.AbsoluteContentSize.Y + 10)
        end
        espLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateESPCanvas)
        updateESPCanvas()

        local function createESPToggle(name, stateVar)
            local btn = Instance.new("TextButton")
            btn.Name = name .. "Toggle"
            btn.Text = name .. ": OFF"
            btn.Size = UDim2.new(1, -20, 0, 32)
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 13
            btn.BorderSizePixel = 0
            btn.Parent = espScroll
            btn.MouseButton1Click:Connect(function()
                _G[stateVar] = not _G[stateVar]
                btn.Text = name .. ": " .. (_G[stateVar] and "ON" or "OFF")
            end)
            return btn
        end

        _G.espEnabled = false
        _G.boxESPEnabled = false
        _G.nameESPEnabled = false
        _G.healthbarESPEnabled = false
        _G.dynamicScalingEnabled = false
        _G.teamCheckEnabled = false
        _G.colorByTeamEnabled = false

        createESPToggle("ESP", "espEnabled")
        createESPToggle("Box ESP", "boxESPEnabled")
        createESPToggle("Name ESP", "nameESPEnabled")
        createESPToggle("Healthbar ESP", "healthbarESPEnabled")
        createESPToggle("Dynamic Scaling", "dynamicScalingEnabled")
        createESPToggle("Team Check", "teamCheckEnabled")
        createESPToggle("Color By Team", "colorByTeamEnabled")

        -- ESP Drawing System
        local espDrawings = {}
        local function clearESP()
            for _, drawings in pairs(espDrawings) do
                for _, d in pairs(drawings) do
                    if d.Remove then d:Remove() end
                end
            end
            espDrawings = {}
        end

        local function getTeamColor(plr)
            if colorByTeamEnabled and plr.TeamColor then
                return plr.TeamColor.Color
            end
            return Color3.fromRGB(255,0,0)
        end

        local function getHealthColor(health, maxHealth)
            local percent = health / maxHealth
            if percent > 0.5 then
                return Color3.fromRGB(0,255,0)
            elseif percent > 0.2 then
                return Color3.fromRGB(255,255,0)
            else
                return Color3.fromRGB(255,0,0)
            end
        end

        local function updateESP()
            if not drawingAvailable then return end
            if not _G.espEnabled then clearESP() return end
            print("[Arsenal Hub] ESP update running")
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                    if teamCheckEnabled and plr.Team == player.Team then
                        if espDrawings[plr] then
                            for _, d in pairs(espDrawings[plr]) do d.Visible = false end
                        end
                        continue
                    end
                    local root = plr.Character.HumanoidRootPart
                    local pos, onScreen = camera:WorldToViewportPoint(root.Position)
                    if not onScreen then
                        if espDrawings[plr] then
                            for _, d in pairs(espDrawings[plr]) do d.Visible = false end
                        end
                        continue
                    end
                    if not espDrawings[plr] then
                        espDrawings[plr] = {}
                        if _G.boxESPEnabled then
                            local box = Drawing.new("Square")
                            box.Thickness = 2
                            box.Filled = false
                            box.Color = getTeamColor(plr)
                            box.Visible = false
                            espDrawings[plr].box = box
                        end
                        if _G.nameESPEnabled then
                            local name = Drawing.new("Text")
                            name.Size = 16
                            name.Color = getTeamColor(plr)
                            name.Center = true
                            name.Outline = true
                            name.Visible = false
                            espDrawings[plr].name = name
                        end
                        if _G.healthbarESPEnabled then
                            local bar = Drawing.new("Line")
                            bar.Thickness = 4
                            bar.Color = Color3.fromRGB(0,255,0)
                            bar.Visible = false
                            espDrawings[plr].healthbar = bar
                        end
                    end
                    -- Dynamic scaling
                    local scale = 1
                    if _G.dynamicScalingEnabled then
                        local dist = (camera.CFrame.Position - root.Position).Magnitude
                        scale = math.clamp(1200 / dist, 0.5, 2)
                    end
                    -- Box ESP
                    if _G.boxESPEnabled and espDrawings[plr].box then
                        local sizeY = (plr.Character.Humanoid.HipHeight * 2 + 2) * scale * 2
                        local sizeX = sizeY / 2
                        espDrawings[plr].box.Size = Vector2.new(sizeX, sizeY)
                        espDrawings[plr].box.Position = Vector2.new(pos.X - sizeX/2, pos.Y - sizeY/2)
                        espDrawings[plr].box.Color = getTeamColor(plr)
                        espDrawings[plr].box.Visible = true
                    end
                    -- Name ESP
                    if _G.nameESPEnabled and espDrawings[plr].name then
                        espDrawings[plr].name.Text = plr.Name
                        espDrawings[plr].name.Position = Vector2.new(pos.X, pos.Y - 30 * scale)
                        espDrawings[plr].name.Color = getTeamColor(plr)
                        espDrawings[plr].name.Visible = true
                    end
                    -- Healthbar ESP
                    if _G.healthbarESPEnabled and espDrawings[plr].healthbar then
                        local health = plr.Character.Humanoid.Health
                        local maxHealth = plr.Character.Humanoid.MaxHealth
                        local barHeight = 40 * scale
                        local barX = pos.X - ((plr.Character.Humanoid.HipHeight * scale) + 10)
                        local barY1 = pos.Y - barHeight/2
                        local barY2 = barY1 + barHeight * (health / maxHealth)
                        espDrawings[plr].healthbar.From = Vector2.new(barX, barY2)
                        espDrawings[plr].healthbar.To = Vector2.new(barX, barY1 + barHeight)
                        espDrawings[plr].healthbar.Color = getHealthColor(health, maxHealth)
                        espDrawings[plr].healthbar.Visible = true
                    end
                else
                    if espDrawings[plr] then
                        for _, d in pairs(espDrawings[plr]) do d.Visible = false end
                    end
                end
            end
        end

        RunService:BindToRenderStep("ESP", Enum.RenderPriority.Camera.Value + 1, updateESP)
