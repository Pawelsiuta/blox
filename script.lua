        -- Aetheris GUI Mockup for Roblox Arsenal (Lua)
        -- Only GUI, no exploit functions yet
        -- Draggable, dark blue theme, open/close with Right Shift

        local UserInputService = game:GetService("UserInputService")
        local TweenService = game:GetService("TweenService")
        local CoreGui = game:GetService("CoreGui")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local Camera = workspace.CurrentCamera

        -- CONFIG
        local mainColor = Color3.fromRGB(18, 19, 24) -- tło i header ten sam kolor
        local accentColor = Color3.fromRGB(18, 19, 24) -- tło i header ten sam kolor
        local sidebarBorderColor = Color3.fromRGB(40, 40, 50)
        local sidebarInnerColor = Color3.fromRGB(14, 15, 20) -- sidebar ciemniejszy od tła
        local textColor = Color3.fromRGB(160, 170, 190)
        local font = Enum.Font.Code
        local selectedTabColor = Color3.fromRGB(40, 80, 180) -- dark blue for selected tab

        -- Dodaję globalną zmienną na górze pliku
        local hitPartCurrentOption = "Head"

        -- Dodaję tablice z labelami do zakładek
        local contentLabels = {"Aim", "Visuals", "Gun Mods"}

        -- Centralna tabela na ustawienia aimbota
        local aimbotSettings = {
            enabled = false,
            smoothing = 0,
            hitPart = "Head",
            teamCheck = false,
            wallCheck = false,
            showFovCircle = false,
            fovRadius = 60
        }

        local visualsSettings = {
            boxEsp = false,
            boxOutline = false,
            boxType = "Full",
            boxColor = Color3.fromRGB(40, 80, 180),
            boxOpacity = 100,
            headDot = false
        }

        local colorWheelAssetId = "rbxassetid://6020299385" -- przykładowy asset koła kolorów (możesz podmienić na swój)

        local function printAimbotSettings()
            print("Aimbot settings:",
                "enabled:", aimbotSettings.enabled,
                "smoothing:", aimbotSettings.smoothing,
                "hitPart:", aimbotSettings.hitPart,
                "teamCheck:", aimbotSettings.teamCheck,
                "wallCheck:", aimbotSettings.wallCheck,
                "showFovCircle:", aimbotSettings.showFovCircle,
                "fovRadius:", aimbotSettings.fovRadius
            )
        end

        -- Remove previous GUI if exists
        if CoreGui:FindFirstChild("AetherisGUI") then
            CoreGui.AetherisGUI:Destroy()
        end

        -- Main ScreenGui
        local gui = Instance.new("ScreenGui")
        gui.Name = "AetherisGUI"
        gui.Parent = CoreGui

        gui.ResetOnSpawn = false

        -- Main Frame
        local mainFrame = Instance.new("Frame")
        mainFrame.Name = "MainFrame"
        mainFrame.Size = UDim2.new(0, 620, 0, 400)
        mainFrame.Position = UDim2.new(0.5, -310, 0.5, -200)
        mainFrame.BackgroundColor3 = mainColor
        mainFrame.BorderSizePixel = 0
        mainFrame.Active = true
        mainFrame.Draggable = true
        mainFrame.Parent = gui

        -- Top Bar (Logo)
        local topBar = Instance.new("Frame")
        topBar.Size = UDim2.new(1, 0, 0, 36)
        topBar.BackgroundColor3 = accentColor
        topBar.BorderSizePixel = 0
        topBar.Parent = mainFrame

        local logo = Instance.new("TextLabel")
        logo.Text = "Aetheris"
        logo.Font = font
        logo.TextSize = 28
        logo.TextColor3 = textColor
        logo.BackgroundTransparency = 1
        logo.Position = UDim2.new(0, 16, 0, 0)
        logo.Size = UDim2.new(0, 200, 1, 0)
        logo.TextXAlignment = Enum.TextXAlignment.Left
        logo.Parent = topBar

        -- Sidebar bez obramówki, bezpośrednio w mainFrame
        local sidebarWidth = 114 -- szerokość mainFrame minus 20px na marginesy boczne
        local sidebar = Instance.new("Frame")
        sidebar.Size = UDim2.new(0, sidebarWidth, 1, -46) -- -36 (header) -10 (dół)
        sidebar.Position = UDim2.new(0, 10, 0, 40) -- 10px od lewej, 36px od góry (pod headerem)
        sidebar.BackgroundColor3 = sidebarInnerColor
        sidebar.BorderSizePixel = 0
        sidebar.Parent = mainFrame
        sidebar.BackgroundTransparency = 0
        local sidebarCorner = Instance.new("UICorner")
        sidebarCorner.CornerRadius = UDim.new(0, 12)
        sidebarCorner.Parent = sidebar

        local tabs = {"Aim", "Visuals", "Gun Mods"}
        local tabButtons = {}
        local selectedTab = 1

        for i, tabName in ipairs(tabs) do
            local btn = Instance.new("TextButton")
            btn.Text = tabName
            btn.Font = font
            btn.TextSize = 16
            btn.TextColor3 = (i == selectedTab) and selectedTabColor or textColor
            btn.BackgroundTransparency = 1
            btn.BorderSizePixel = 0
            btn.AutoButtonColor = false
            btn.Size = UDim2.new(1, 0, 0, 48)
            btn.Position = UDim2.new(0, 0, 0, (i-1)*52)
            btn.Parent = sidebar
            tabButtons[i] = btn
            -- Gradient na zaznaczonym przycisku
            if i == selectedTab then
                local grad = Instance.new("UIGradient")
                grad.Rotation = 45
                grad.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 80, 180)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 180, 255))
                }
                grad.Parent = btn
            end
        end

        -- Main Content Frame
        local contentFrame = Instance.new("ScrollingFrame")
        contentFrame.Size = UDim2.new(1, -150, 1, -36)
        contentFrame.Position = UDim2.new(0, 150, 0, 36)
        contentFrame.BackgroundColor3 = mainColor
        contentFrame.BorderSizePixel = 0
        contentFrame.BackgroundTransparency = 1
        contentFrame.Parent = mainFrame
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        contentFrame.ScrollBarThickness = 4
        contentFrame.ScrollBarImageColor3 = Color3.fromRGB(40, 80, 180)
        contentFrame.ScrollBarImageTransparency = 0
        contentFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
        contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

        -- Dodaję marginesy na górze pliku lub na początku updateContent
        local contentLeftMargin = 17
        local headerLeftMargin = 33
        local headerLineSpacing = 16
        local headerLineLength = 60
        local headerToLineGap = 8
        local lineToNextGap = 12
        local sectionGap = 24
        local rowGap = 24 -- uniwersalny odstęp pionowy między wszystkimi elementami w sekcji

        -- Funkcja do aktualizacji zawartości contentFrame w zależności od zakładki
        local function createCheckbox(parent, labelText, pos, default, onChanged)
            local row = Instance.new("Frame")
            row.BackgroundTransparency = 1
            row.Size = UDim2.new(1, -32, 0, 24)
            row.Position = pos
            row.Parent = parent

            local checkbox = Instance.new("TextButton")
            checkbox.Name = labelText .. "Checkbox"
            checkbox.Size = UDim2.new(0, 18, 0, 18)
            checkbox.Position = UDim2.new(0, 0, 0, 3)
            checkbox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            checkbox.BorderColor3 = Color3.fromRGB(80, 80, 100)
            checkbox.BorderSizePixel = 1
            checkbox.AutoButtonColor = false
            checkbox.Text = ""
            checkbox.Parent = row
            local cbCorner = Instance.new("UICorner")
            cbCorner.CornerRadius = UDim.new(0, 4)
            cbCorner.Parent = checkbox

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(0, 14, 0, 14)
            fill.Position = UDim2.new(0, 2, 0, 2)
            fill.BackgroundColor3 = Color3.fromRGB(40, 80, 180)
            fill.BackgroundTransparency = 0
            fill.Visible = false
            fill.Parent = checkbox
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(0, 3)
            fillCorner.Parent = fill
            local fillGrad = Instance.new("UIGradient")
            fillGrad.Rotation = 90
            fillGrad.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 180, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 80, 180))
            }
            fillGrad.Parent = fill

            local checked = default or false
            if checked then
                fill.Visible = true
                fill.Size = UDim2.new(0, 14, 0, 14)
                fill.Position = UDim2.new(0, 2, 0, 2)
            end

            checkbox.MouseButton1Click:Connect(function()
                checked = not checked
                if checked then
                    fill.Visible = true
                    fill.Size = UDim2.new(0, 0, 0, 0)
                    fill.Position = UDim2.new(0, 9, 0, 9)
                    local tween = TweenService:Create(fill, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(0, 14, 0, 14),
                        Position = UDim2.new(0, 2, 0, 2)
                    })
                    tween:Play()
                else
                    local tween = TweenService:Create(fill, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        Size = UDim2.new(0, 0, 0, 0),
                        Position = UDim2.new(0, 9, 0, 9)
                    })
                    tween:Play()
                    tween.Completed:Connect(function()
                        if not checked then fill.Visible = false end
                    end)
                end
                if onChanged then onChanged(checked) end
            end)

            local label = Instance.new("TextLabel")
            label.Text = labelText
            label.Font = font
            label.TextSize = 15
            label.TextColor3 = textColor
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 28, 0, 0)
            label.Size = UDim2.new(1, -28, 1, 0)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = row

            return checkbox
        end

        local function createColorWheelPicker(onColorPicked)
            -- Overlay
            local overlay = Instance.new("Frame")
            overlay.Size = UDim2.new(1, 0, 1, 0)
            overlay.BackgroundTransparency = 1
            overlay.BackgroundColor3 = Color3.new(0,0,0)
            overlay.ZIndex = 100
            overlay.Parent = CoreGui
            -- Centered color wheel
            local wheel = Instance.new("ImageLabel")
            wheel.Size = UDim2.new(0, 180, 0, 180)
            wheel.Position = UDim2.new(0.5, -90, 0.5, -90)
            wheel.BackgroundTransparency = 1
            wheel.Image = colorWheelAssetId
            wheel.ZIndex = 101
            wheel.Parent = overlay
            -- Zamknięcie po kliknięciu poza kołem
            overlay.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mouse = UserInputService:GetMouseLocation()
                    local abs = wheel.AbsolutePosition
                    local size = wheel.AbsoluteSize
                    if not (mouse.X >= abs.X and mouse.X <= abs.X+size.X and mouse.Y >= abs.Y and mouse.Y <= abs.Y+size.Y) then
                        overlay:Destroy()
                    end
                end
            end)
            -- Wybór koloru po kliknięciu na kole
            wheel.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mouse = UserInputService:GetMouseLocation()
                    local rel = Vector2.new(mouse.X - wheel.AbsolutePosition.X, mouse.Y - wheel.AbsolutePosition.Y)
                    local center = Vector2.new(wheel.AbsoluteSize.X/2, wheel.AbsoluteSize.Y/2)
                    local r = (rel - center).Magnitude
                    if r <= wheel.AbsoluteSize.X/2 then
                        -- Przelicz na HSV
                        local angle = math.atan2(rel.Y - center.Y, rel.X - center.X)
                        local hue = (angle/(2*math.pi))%1
                        local sat = math.clamp(r/(wheel.AbsoluteSize.X/2), 0, 1)
                        local col = Color3.fromHSV(hue, sat, 1)
                        if onColorPicked then onColorPicked(col) end
                        overlay:Destroy()
                    end
                end
            end)
        end

        local function createColorPicker(parent, labelText, pos, defaultColor, onChanged)
            local row = Instance.new("Frame")
            row.BackgroundTransparency = 1
            row.Size = UDim2.new(1, -32, 0, 24)
            row.Position = pos
            row.Parent = parent

            -- Kwadracik po lewej
            local colorBtn = Instance.new("TextButton")
            colorBtn.Name = labelText .. "ColorBtn"
            colorBtn.Size = UDim2.new(0, 18, 0, 18)
            colorBtn.Position = UDim2.new(0, 0, 0, 3)
            colorBtn.BackgroundColor3 = defaultColor
            colorBtn.BorderColor3 = Color3.fromRGB(80, 80, 100)
            colorBtn.BorderSizePixel = 1
            colorBtn.AutoButtonColor = true
            colorBtn.Text = ""
            colorBtn.Parent = row
            local cbCorner = Instance.new("UICorner")
            cbCorner.CornerRadius = UDim.new(0, 4)
            cbCorner.Parent = colorBtn

            -- Etykieta po prawej
            local label = Instance.new("TextLabel")
            label.Text = labelText
            label.Font = font
            label.TextSize = 15
            label.TextColor3 = textColor
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 28, 0, 0)
            label.Size = UDim2.new(1, -28, 1, 0)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = row

            -- Color picker popup (paleta kolorów)
            local pickerFrame = Instance.new("Frame")
            pickerFrame.Size = UDim2.new(0, 180, 0, 120)
            pickerFrame.Position = UDim2.new(0, 0, 1, 0)
            pickerFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            pickerFrame.BorderColor3 = Color3.fromRGB(80, 80, 100)
            pickerFrame.BorderSizePixel = 1
            pickerFrame.Visible = false
            pickerFrame.Parent = colorBtn
            pickerFrame.ZIndex = 20
            -- Paleta kolorów (siatka 6x6)
            local palette = {}
            for i = 0, 5 do
                for j = 0, 5 do
                    local r = math.floor(255 * i / 5)
                    local g = math.floor(255 * j / 5)
                    local b = math.floor(255 * ((i+j)%6) / 5)
                    local col = Color3.fromRGB(r, g, b)
                    local c = Instance.new("TextButton")
                    c.Size = UDim2.new(0, 24, 0, 18)
                    c.Position = UDim2.new(0, 6 + i*28, 0, 6 + j*20)
                    c.BackgroundColor3 = col
                    c.BorderSizePixel = 0
                    c.Text = ""
                    c.Parent = pickerFrame
                    c.ZIndex = 21
                    c.MouseButton1Click:Connect(function()
                        colorBtn.BackgroundColor3 = col
                        pickerFrame.Visible = false
                        if onChanged then onChanged(col) end
                    end)
                end
            end
            colorBtn.MouseButton1Click:Connect(function()
                createColorWheelPicker(function(col)
                    colorBtn.BackgroundColor3 = col
                    if onChanged then onChanged(col) end
                end)
            end)
            return colorBtn
        end

        local function createDropdown(parent, labelText, pos, options, default, onChanged)
            local y = pos.Y.Offset
            -- Etykieta
            local label = Instance.new("TextLabel")
            label.Text = labelText
            label.Font = font
            label.TextSize = 15
            label.TextColor3 = textColor
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, contentLeftMargin, 0, y)
            label.Size = UDim2.new(0, 100, 0, 18)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = parent
            y = y + rowGap
            -- Dropdown pod etykietą
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.BackgroundColor3 = sidebarInnerColor
            dropdownFrame.BackgroundTransparency = 0
            dropdownFrame.BorderColor3 = Color3.fromRGB(40, 80, 180)
            dropdownFrame.BorderSizePixel = 2
            dropdownFrame.Position = UDim2.new(0, contentLeftMargin, 0, y)
            dropdownFrame.Size = UDim2.new(0, 120, 0, 18)
            dropdownFrame.Parent = parent
            local selectedOption = Instance.new("TextButton")
            selectedOption.Text = default or ""
            selectedOption.Font = font
            selectedOption.TextSize = 15
            selectedOption.TextColor3 = textColor
            selectedOption.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            selectedOption.BackgroundTransparency = 0
            selectedOption.Size = UDim2.new(1, 0, 1, 0)
            selectedOption.Position = UDim2.new(0, 0, 0, 0)
            selectedOption.AutoButtonColor = false
            selectedOption.Parent = dropdownFrame
            selectedOption.ZIndex = 9
            local optionsFrame = Instance.new("Frame")
            optionsFrame.BackgroundColor3 = sidebarInnerColor
            optionsFrame.BorderColor3 = Color3.fromRGB(40, 80, 180)
            optionsFrame.BorderSizePixel = 2
            optionsFrame.Position = UDim2.new(0, 0, 1, 0)
            optionsFrame.Size = UDim2.new(1, 0, 0, #options*18)
            optionsFrame.Visible = false
            optionsFrame.Parent = dropdownFrame
            optionsFrame.ZIndex = 10
            for i, opt in ipairs(options) do
                local btn = Instance.new("TextButton")
                btn.Text = opt
                btn.Font = font
                btn.TextSize = 15
                btn.TextColor3 = textColor
                btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                btn.BackgroundTransparency = 0
                btn.Size = UDim2.new(1, 0, 0, 18)
                btn.Position = UDim2.new(0, 0, 0, (i-1)*18)
                btn.AutoButtonColor = true
                btn.Parent = optionsFrame
                btn.ZIndex = 10
                btn.MouseButton1Click:Connect(function()
                    selectedOption.Text = opt
                    optionsFrame.Visible = false
                    if onChanged then onChanged(opt) end
                end)
            end
            selectedOption.MouseButton1Click:Connect(function()
                optionsFrame.Visible = not optionsFrame.Visible
            end)
            return y + 18
        end

        local function updateContent(tabIndex)
            -- Wyczyść contentFrame
            for _, child in ipairs(contentFrame:GetChildren()) do
                child:Destroy()
            end
            if tabIndex == 1 then -- Aim
                local y = 16
                -- Aimbot sekcja
                local header = Instance.new("TextLabel")
                header.Text = "Aimbot"
                header.Font = font
                header.TextSize = 16
                header.TextColor3 = textColor
                header.BackgroundTransparency = 1
                header.Position = UDim2.new(0, headerLeftMargin, 0, y)
                header.Size = UDim2.new(0, 60, 0, 20)
                header.TextXAlignment = Enum.TextXAlignment.Left
                header.Parent = contentFrame
                local line = Instance.new("Frame")
                line.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                line.BorderSizePixel = 0
                line.Position = UDim2.new(0, headerLeftMargin + headerLineLength + headerLineSpacing, 0, y + headerToLineGap)
                line.Size = UDim2.new(1, -(headerLeftMargin + headerLineLength + headerLineSpacing + 16), 0, 2)
                line.Parent = contentFrame
                y = y + headerToLineGap + 2 + rowGap
                local aimbotCheckbox = createCheckbox(contentFrame, "Aimbot", UDim2.new(0, contentLeftMargin, 0, y), aimbotSettings.enabled, function(val)
                    aimbotSettings.enabled = val
                    printAimbotSettings()
                end)
                y = y + rowGap
                local smoothingLabel = Instance.new("TextLabel")
                smoothingLabel.Text = "Smoothness"
                smoothingLabel.Font = font
                smoothingLabel.TextSize = 15
                smoothingLabel.TextColor3 = textColor
                smoothingLabel.BackgroundTransparency = 1
                smoothingLabel.Position = UDim2.new(0, contentLeftMargin, 0, y)
                smoothingLabel.Size = UDim2.new(0, 100, 0, 18)
                smoothingLabel.TextXAlignment = Enum.TextXAlignment.Left
                smoothingLabel.Parent = contentFrame
                local value = (aimbotSettings.smoothing == 0) and 0 or math.floor(aimbotSettings.smoothing * 10 + 0.5)
                local smoothingValue = Instance.new("TextLabel")
                smoothingValue.Text = tostring(value).."/25"
                smoothingValue.Font = font
                smoothingValue.TextSize = 15
                smoothingValue.TextColor3 = textColor
                smoothingValue.BackgroundTransparency = 1
                smoothingValue.Position = UDim2.new(1, -48, 0, y)
                smoothingValue.Size = UDim2.new(0, 48, 0, 18)
                smoothingValue.TextXAlignment = Enum.TextXAlignment.Right
                smoothingValue.Parent = contentFrame
                y = y + 18
                local sliderFrame = Instance.new("Frame")
                sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                sliderFrame.BorderColor3 = Color3.fromRGB(60, 60, 70)
                sliderFrame.BorderSizePixel = 1
                sliderFrame.Position = UDim2.new(0, contentLeftMargin, 0, y)
                sliderFrame.Size = UDim2.new(1, -contentLeftMargin-16, 0, 10)
                sliderFrame.Parent = contentFrame
                local sliderFill = Instance.new("Frame")
                sliderFill.BackgroundColor3 = Color3.fromRGB(40, 80, 180)
                local sliderGrad = Instance.new("UIGradient")
                sliderGrad.Rotation = 90
                sliderGrad.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 180, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 80, 180))
                }
                sliderGrad.Parent = sliderFill
                sliderFill.BorderSizePixel = 0
                sliderFill.Size = UDim2.new((value-0)/25, 0, 1, 0)
                sliderFill.Parent = sliderFrame
                local minValue, maxValue = 0, 25
                local dragging = false
                local function updateSlider(posX)
                    local rel = math.clamp((posX - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
                    value = math.floor(rel * (maxValue - minValue) + minValue + 0.5)
                    sliderFill.Size = UDim2.new((value-minValue)/(maxValue-minValue), 0, 1, 0)
                    smoothingValue.Text = tostring(value).."/25"
                    if value == 0 then
                        aimbotSettings.smoothing = 0
                    else
                        aimbotSettings.smoothing = value/10
                    end
                    printAimbotSettings()
                end
                sliderFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        mainFrame.Draggable = false
                        updateSlider(input.Position.X)
                    end
                end)
                sliderFrame.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                        mainFrame.Draggable = true
                    end
                end)
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input.Position.X)
                    end
                end)
                y = y + rowGap
                -- Dropdown Hit Part
                y = createDropdown(contentFrame, "Hit part", UDim2.new(0, contentLeftMargin, 0, y), {"Head", "Torso"}, hitPartCurrentOption, function(opt)
                    hitPartCurrentOption = opt
                    aimbotSettings.hitPart = opt
                    printAimbotSettings()
                end)
                -- Checks sekcja
                y = y + 26 + sectionGap
                local checksHeader = Instance.new("TextLabel")
                checksHeader.Text = "Checks"
                checksHeader.Font = font
                checksHeader.TextSize = 16
                checksHeader.TextColor3 = textColor
                checksHeader.BackgroundTransparency = 1
                checksHeader.Position = UDim2.new(0, headerLeftMargin, 0, y)
                checksHeader.Size = UDim2.new(0, 80, 0, 20)
                checksHeader.TextXAlignment = Enum.TextXAlignment.Left
                checksHeader.Parent = contentFrame
                local checksLine = Instance.new("Frame")
                checksLine.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                checksLine.BorderSizePixel = 0
                checksLine.Position = UDim2.new(0, headerLeftMargin + headerLineLength + headerLineSpacing, 0, y + headerToLineGap)
                checksLine.Size = UDim2.new(1, -(headerLeftMargin + headerLineLength + headerLineSpacing + 16), 0, 2)
                checksLine.Parent = contentFrame
                y = y + headerToLineGap + 2 + rowGap
                local teamCheckbox = createCheckbox(contentFrame, "Team check", UDim2.new(0, contentLeftMargin, 0, y), aimbotSettings.teamCheck, function(val)
                    aimbotSettings.teamCheck = val
                    printAimbotSettings()
                end)
                y = y + rowGap
                local wallCheckbox = createCheckbox(contentFrame, "Wall check", UDim2.new(0, contentLeftMargin, 0, y), aimbotSettings.wallCheck, function(val)
                    aimbotSettings.wallCheck = val
                    printAimbotSettings()
                end)
                -- Fov sekcja
                y = y + rowGap + sectionGap
                local fovHeader = Instance.new("TextLabel")
                fovHeader.Text = "Fov"
                fovHeader.Font = font
                fovHeader.TextSize = 16
                fovHeader.TextColor3 = textColor
                fovHeader.BackgroundTransparency = 1
                fovHeader.Position = UDim2.new(0, headerLeftMargin, 0, y)
                fovHeader.Size = UDim2.new(0, 60, 0, 20)
                fovHeader.TextXAlignment = Enum.TextXAlignment.Left
                fovHeader.Parent = contentFrame
                local fovLine = Instance.new("Frame")
                fovLine.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                fovLine.BorderSizePixel = 0
                fovLine.Position = UDim2.new(0, headerLeftMargin + headerLineLength + headerLineSpacing, 0, y + headerToLineGap)
                fovLine.Size = UDim2.new(1, -(headerLeftMargin + headerLineLength + headerLineSpacing + 16), 0, 2)
                fovLine.Parent = contentFrame
                y = y + headerToLineGap + 2 + rowGap
                local fovCheckbox = createCheckbox(contentFrame, "Show Fov Circle", UDim2.new(0, contentLeftMargin, 0, y), aimbotSettings.showFovCircle, function(val)
                    aimbotSettings.showFovCircle = val
                    printAimbotSettings()
                end)
                y = y + rowGap
                local fovRadiusLabel = Instance.new("TextLabel")
                fovRadiusLabel.Text = "Fov Radius"
                fovRadiusLabel.Font = font
                fovRadiusLabel.TextSize = 15
                fovRadiusLabel.TextColor3 = textColor
                fovRadiusLabel.BackgroundTransparency = 1
                fovRadiusLabel.Position = UDim2.new(0, contentLeftMargin, 0, y)
                fovRadiusLabel.Size = UDim2.new(0, 120, 0, 18)
                fovRadiusLabel.TextXAlignment = Enum.TextXAlignment.Left
                fovRadiusLabel.Parent = contentFrame
                y = y + rowGap - 6
                local fovSliderRow = Instance.new("Frame")
                fovSliderRow.BackgroundTransparency = 1
                fovSliderRow.Size = UDim2.new(1, -32, 0, 28)
                fovSliderRow.Position = UDim2.new(0, contentLeftMargin, 0, y)
                fovSliderRow.Parent = contentFrame
                local fovValue = Instance.new("TextLabel")
                local fovRadius = aimbotSettings.fovRadius or 60
                fovValue.Text = tostring(fovRadius).."/400"
                fovValue.Font = font
                fovValue.TextSize = 15
                fovValue.TextColor3 = textColor
                fovValue.BackgroundTransparency = 1
                fovValue.Position = UDim2.new(1, -48, 0, 0)
                fovValue.Size = UDim2.new(0, 48, 0, 18)
                fovValue.TextXAlignment = Enum.TextXAlignment.Right
                fovValue.Parent = fovSliderRow
                local fovSliderFrame = Instance.new("Frame")
                fovSliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                fovSliderFrame.BorderColor3 = Color3.fromRGB(60, 60, 70)
                fovSliderFrame.BorderSizePixel = 1
                fovSliderFrame.Position = UDim2.new(0, 0, 0, 18)
                fovSliderFrame.Size = UDim2.new(1, 0, 0, 10)
                fovSliderFrame.Parent = fovSliderRow
                local fovSliderFill = Instance.new("Frame")
                fovSliderFill.BackgroundColor3 = Color3.fromRGB(40, 80, 180)
                local fovSliderGrad = Instance.new("UIGradient")
                fovSliderGrad.Rotation = 90
                fovSliderGrad.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 180, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 80, 180))
                }
                fovSliderGrad.Parent = fovSliderFill
                fovSliderFill.BorderSizePixel = 0
                fovSliderFill.Size = UDim2.new((fovRadius-20)/(400-20), 0, 1, 0)
                fovSliderFill.Parent = fovSliderFrame
                local fovMin, fovMax = 20, 400
                local fovDragging = false
                local function updateFovSlider(posX)
                    local rel = math.clamp((posX - fovSliderFrame.AbsolutePosition.X) / fovSliderFrame.AbsoluteSize.X, 0, 1)
                    fovRadius = math.floor(rel * (fovMax - fovMin) + fovMin + 0.5)
                    fovSliderFill.Size = UDim2.new((fovRadius-fovMin)/(fovMax-fovMin), 0, 1, 0)
                    fovValue.Text = tostring(fovRadius).."/400"
                    aimbotSettings.fovRadius = fovRadius
                    printAimbotSettings()
                end
                fovSliderFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        fovDragging = true
                        mainFrame.Draggable = false
                        updateFovSlider(input.Position.X)
                    end
                end)
                fovSliderFrame.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        fovDragging = false
                        mainFrame.Draggable = true
                    end
                end)
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if fovDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateFovSlider(input.Position.X)
                    end
                end)
            elseif tabIndex == 2 then -- Visuals
                local y = 16
                -- ESP sekcja
                local header = Instance.new("TextLabel")
                header.Text = "ESP"
                header.Font = font
                header.TextSize = 16
                header.TextColor3 = textColor
                header.BackgroundTransparency = 1
                header.Position = UDim2.new(0, headerLeftMargin, 0, y)
                header.Size = UDim2.new(0, 60, 0, 20)
                header.TextXAlignment = Enum.TextXAlignment.Left
                header.Parent = contentFrame
                local line = Instance.new("Frame")
                line.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                line.BorderSizePixel = 0
                line.Position = UDim2.new(0, headerLeftMargin + headerLineLength + headerLineSpacing, 0, y + headerToLineGap)
                line.Size = UDim2.new(1, -(headerLeftMargin + headerLineLength + headerLineSpacing + 16), 0, 2)
                line.Parent = contentFrame
                y = y + headerToLineGap + 2 + rowGap
                local boxEspCheckbox = createCheckbox(contentFrame, "Box ESP", UDim2.new(0, contentLeftMargin, 0, y), visualsSettings.boxEsp, function(val)
                    visualsSettings.boxEsp = val
                end)
                y = y + rowGap
                local boxOutlineCheckbox = createCheckbox(contentFrame, "Box Outline", UDim2.new(0, contentLeftMargin, 0, y), visualsSettings.boxOutline, function(val)
                    visualsSettings.boxOutline = val
                end)
                y = y + rowGap
                -- Box Type label
                local boxTypeLabel = Instance.new("TextLabel")
                boxTypeLabel.Text = "Box Type"
                boxTypeLabel.Font = font
                boxTypeLabel.TextSize = 15
                boxTypeLabel.TextColor3 = textColor
                boxTypeLabel.BackgroundTransparency = 1
                boxTypeLabel.Position = UDim2.new(0, contentLeftMargin, 0, y)
                boxTypeLabel.Size = UDim2.new(0, 100, 0, 18)
                boxTypeLabel.TextXAlignment = Enum.TextXAlignment.Left
                boxTypeLabel.Parent = contentFrame
                y = y + rowGap
                -- Dropdown Box Type pod etykietą
                local boxTypeDropdown = Instance.new("Frame")
                boxTypeDropdown.BackgroundColor3 = sidebarInnerColor
                boxTypeDropdown.BackgroundTransparency = 0
                boxTypeDropdown.BorderColor3 = Color3.fromRGB(40, 80, 180)
                boxTypeDropdown.BorderSizePixel = 2
                boxTypeDropdown.Position = UDim2.new(0, contentLeftMargin, 0, y)
                boxTypeDropdown.Size = UDim2.new(0, 120, 0, 18)
                boxTypeDropdown.Parent = contentFrame
                local selectedBoxType = Instance.new("TextButton")
                selectedBoxType.Text = visualsSettings.boxType
                selectedBoxType.Font = font
                selectedBoxType.TextSize = 15
                selectedBoxType.TextColor3 = textColor
                selectedBoxType.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                selectedBoxType.BackgroundTransparency = 0
                selectedBoxType.Size = UDim2.new(1, 0, 1, 0)
                selectedBoxType.Position = UDim2.new(0, 0, 0, 0)
                selectedBoxType.AutoButtonColor = false
                selectedBoxType.Parent = boxTypeDropdown
                selectedBoxType.ZIndex = 9
                local boxTypeOptionsFrame = Instance.new("Frame")
                boxTypeOptionsFrame.BackgroundColor3 = sidebarInnerColor
                boxTypeOptionsFrame.BorderColor3 = Color3.fromRGB(40, 80, 180)
                boxTypeOptionsFrame.BorderSizePixel = 2
                boxTypeOptionsFrame.Position = UDim2.new(0, 0, 1, 0)
                boxTypeOptionsFrame.Size = UDim2.new(1, 0, 0, 54)
                boxTypeOptionsFrame.Visible = false
                boxTypeOptionsFrame.Parent = boxTypeDropdown
                boxTypeOptionsFrame.ZIndex = 10
                local boxTypes = {"Full", "Corners", "Rounded"}
                for i, opt in ipairs(boxTypes) do
                    local btn = Instance.new("TextButton")
                    btn.Text = opt
                    btn.Font = font
                    btn.TextSize = 15
                    btn.TextColor3 = textColor
                    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                    btn.BackgroundTransparency = 0
                    btn.Size = UDim2.new(1, 0, 0, 18)
                    btn.Position = UDim2.new(0, 0, 0, (i-1)*18)
                    btn.AutoButtonColor = true
                    btn.Parent = boxTypeOptionsFrame
                    btn.ZIndex = 10
                    btn.MouseButton1Click:Connect(function()
                        visualsSettings.boxType = opt
                        selectedBoxType.Text = opt
                        boxTypeOptionsFrame.Visible = false
                    end)
                end
                selectedBoxType.MouseButton1Click:Connect(function()
                    boxTypeOptionsFrame.Visible = not boxTypeOptionsFrame.Visible
                end)
                y = y + rowGap
                -- Box Color z pickerem (kwadracik po lewej)
                local boxColorBtn = createColorPicker(contentFrame, "Box Color", UDim2.new(0, contentLeftMargin, 0, y), visualsSettings.boxColor, function(col)
                    visualsSettings.boxColor = col
                end)
                y = y + rowGap
                -- Box Opacity
                local boxOpacityLabel = Instance.new("TextLabel")
                boxOpacityLabel.Text = "Box Opacity"
                boxOpacityLabel.Font = font
                boxOpacityLabel.TextSize = 15
                boxOpacityLabel.TextColor3 = textColor
                boxOpacityLabel.BackgroundTransparency = 1
                boxOpacityLabel.Position = UDim2.new(0, contentLeftMargin, 0, y)
                boxOpacityLabel.Size = UDim2.new(0, 120, 0, 18)
                boxOpacityLabel.TextXAlignment = Enum.TextXAlignment.Left
                boxOpacityLabel.Parent = contentFrame
                local boxOpacityValue = Instance.new("TextLabel")
                boxOpacityValue.Text = tostring(visualsSettings.boxOpacity).."/100"
                boxOpacityValue.Font = font
                boxOpacityValue.TextSize = 15
                boxOpacityValue.TextColor3 = textColor
                boxOpacityValue.BackgroundTransparency = 1
                boxOpacityValue.Position = UDim2.new(1, -48, 0, y)
                boxOpacityValue.Size = UDim2.new(0, 48, 0, 18)
                boxOpacityValue.TextXAlignment = Enum.TextXAlignment.Right
                boxOpacityValue.Parent = contentFrame
                y = y + 18
                local boxOpacitySlider = Instance.new("Frame")
                boxOpacitySlider.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                boxOpacitySlider.BorderColor3 = Color3.fromRGB(60, 60, 70)
                boxOpacitySlider.BorderSizePixel = 1
                boxOpacitySlider.Position = UDim2.new(0, contentLeftMargin, 0, y)
                boxOpacitySlider.Size = UDim2.new(1, -contentLeftMargin-16, 0, 10)
                boxOpacitySlider.Parent = contentFrame
                local boxOpacityFill = Instance.new("Frame")
                boxOpacityFill.BackgroundColor3 = Color3.fromRGB(40, 80, 180)
                local boxOpacityGrad = Instance.new("UIGradient")
                boxOpacityGrad.Rotation = 90
                boxOpacityGrad.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 180, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 80, 180))
                }
                boxOpacityGrad.Parent = boxOpacityFill
                boxOpacityFill.BorderSizePixel = 0
                boxOpacityFill.Size = UDim2.new(visualsSettings.boxOpacity/100, 0, 1, 0)
                boxOpacityFill.Parent = boxOpacitySlider
                local draggingOpacity = false
                local function updateBoxOpacitySlider(posX)
                    local rel = math.clamp((posX - boxOpacitySlider.AbsolutePosition.X) / boxOpacitySlider.AbsoluteSize.X, 0, 1)
                    local val = math.floor(rel * 100 + 0.5)
                    boxOpacityFill.Size = UDim2.new(val/100, 0, 1, 0)
                    boxOpacityValue.Text = tostring(val).."/100"
                    visualsSettings.boxOpacity = val
                end
                boxOpacitySlider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingOpacity = true
                        mainFrame.Draggable = false
                        updateBoxOpacitySlider(input.Position.X)
                    end
                end)
                boxOpacitySlider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingOpacity = false
                        mainFrame.Draggable = true
                    end
                end)
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if draggingOpacity and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateBoxOpacitySlider(input.Position.X)
                    end
                end)
                y = y + rowGap
                local headDotCheckbox = createCheckbox(contentFrame, "Head Dot", UDim2.new(0, contentLeftMargin, 0, y), visualsSettings.headDot, function(val)
                    visualsSettings.headDot = val
                end)
            else
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = textColor
                label.Font = font
                label.TextSize = 16
                label.Text = contentLabels[tabIndex]
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.TextYAlignment = Enum.TextYAlignment.Top
                label.Position = UDim2.new(0, contentLeftMargin, 0, 16)
                label.Parent = contentFrame
            end
            contentFrame.CanvasPosition = Vector2.new(0, 0)
            contentFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
        end

        -- Wywołaj na starcie
        updateContent(selectedTab)

        -- Zmień obsługę przełączania zakładek, by używać updateContent
        for i, btn in ipairs(tabButtons) do
            btn.MouseButton1Click:Connect(function()
                for j, b in ipairs(tabButtons) do
                    b.TextColor3 = (j == i) and selectedTabColor or textColor
                    for _, child in ipairs(b:GetChildren()) do
                        if child:IsA("UIGradient") then child:Destroy() end
                    end
                end
                selectedTab = i
                updateContent(i)
                local grad = Instance.new("UIGradient")
                grad.Rotation = 45
                grad.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 80, 180)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 180, 255))
                }
                grad.Parent = btn
            end)
        end

        -- Funkcja do ustawiania przezroczystości wszystkich dzieci rekursywnie
        local function setTransparency(obj, value)
            -- Pomijaj contentFrame i wszystkie jego dzieci (nie ustawiaj im przezroczystości)
            if obj:IsDescendantOf(contentFrame) and obj ~= mainFrame then
                return
            end
            if obj == contentFrame or obj == logo then
                return
            end
            for _, btn in ipairs(tabButtons) do
                if obj == btn then return end
            end
            -- Pomijaj wszystkie checkboxy (po nazwie)
            if obj:IsA("TextButton") and obj.Name:sub(-8) == "Checkbox" then return end
            if obj:IsA("Frame") or obj:IsA("TextLabel") or obj:IsA("TextButton") then
                if obj:IsA("Frame") then
                    obj.BackgroundTransparency = value
                else
                    obj.TextTransparency = value
                    obj.BackgroundTransparency = value
                end
            end
            for _, child in ipairs(obj:GetChildren()) do
                setTransparency(child, value)
            end
        end

        -- Funkcja fade in/out
        local function fadeGui(show, duration)
            duration = duration or 0.3
            local start = show and 1 or 0
            local finish = show and 0 or 1
            local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local transparencyValue = Instance.new("NumberValue")
            transparencyValue.Value = start
            local tween = TweenService:Create(transparencyValue, tweenInfo, {Value = finish})
            tween:Play()
            transparencyValue.Changed:Connect(function(val)
                setTransparency(mainFrame, val)
            end)
            tween.Completed:Connect(function()
                if not show then
                    gui.Enabled = false
                end
                -- Przywracanie przezroczystości po animacji
                sidebar.BackgroundTransparency = 1
                contentFrame.BackgroundTransparency = 1
                logo.BackgroundTransparency = 1
                for _, btn in ipairs(tabButtons) do
                    btn.BackgroundTransparency = 1
                end
                transparencyValue:Destroy()
            end)
            if show then
                gui.Enabled = true
            end
        end

        -- Open/Close with Right Shift (z animacją fade)
        local open = true
        gui.Enabled = open
        setTransparency(mainFrame, 0)
        UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == Enum.KeyCode.RightShift then
                open = not open
                if open then
                    fadeGui(true, 0.3)
                else
                    fadeGui(false, 0.3)
                end
            end
        end)

        -- ETAP 2: Logika aimbota
        local function getClosestEnemy()
            local closest, closestDist = nil, aimbotSettings.fovRadius
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    -- Team check
                    if aimbotSettings.teamCheck and player.Team == LocalPlayer.Team then
                        continue
                    end
                    -- Wall check
                    if aimbotSettings.wallCheck then
                        local origin = Camera.CFrame.Position
                        local targetPart = player.Character:FindFirstChild(aimbotSettings.hitPart) or player.Character:FindFirstChild("HumanoidRootPart")
                        if not targetPart then continue end
                        local ray = Ray.new(origin, (targetPart.Position - origin).Unit * 1000)
                        local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
                        if hit and not player.Character:IsAncestorOf(hit) then continue end
                    end
                    -- FOV check
                    local targetPart = player.Character:FindFirstChild(aimbotSettings.hitPart) or player.Character:FindFirstChild("HumanoidRootPart")
                    if not targetPart then continue end
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local mousePos = UserInputService:GetMouseLocation()
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist < closestDist then
                            closest = player
                            closestDist = dist
                        end
                    end
                end
            end
            return closest
        end

        local function aimAt(target)
            if not target or not target.Character then return end
            local part = target.Character:FindFirstChild(aimbotSettings.hitPart) or target.Character:FindFirstChild("HumanoidRootPart")
            if not part then return end
            local screenPos = Camera:WorldToViewportPoint(part.Position)
            local mouse = UserInputService:GetMouseLocation()
            local delta = Vector2.new(screenPos.X, screenPos.Y) - mouse
            local move = delta / math.max(1, aimbotSettings.smoothing)
            mousemoverel(move.X, move.Y)
        end

        local holdingRMB = false
        UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                holdingRMB = true
                while holdingRMB do
                    if aimbotSettings.enabled then
                        local target = getClosestEnemy()
                        aimAt(target)
                    end
                    task.wait(0.01)
                end
            end
        end)
        UserInputService.InputEnded:Connect(function(input, gpe)
            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                holdingRMB = false
            end
        end)

        -- ETAP 3: Rysowanie okręgu FOV
        local fovCircle = Drawing.new("Circle")
        fovCircle.Color = Color3.fromRGB(40, 80, 180)
        fovCircle.Thickness = 1
        fovCircle.Filled = false
        fovCircle.Transparency = 0.7
        fovCircle.Visible = false

        game:GetService("RunService").RenderStepped:Connect(function()
            if aimbotSettings.showFovCircle then
                fovCircle.Position = UserInputService:GetMouseLocation()
                fovCircle.Radius = aimbotSettings.fovRadius
                fovCircle.Visible = true
            else
                fovCircle.Visible = false
            end
        end)



