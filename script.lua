-- Aetheris GUI Mockup for Roblox Arsenal (Lua)
-- Only GUI, no exploit functions yet
-- Draggable, dark blue theme, open/close with Right Shift

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

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

-- Funkcja do aktualizacji zawartości contentFrame w zależności od zakładki
local function createCheckbox(parent, labelText, pos, default)
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

local function updateContent(tabIndex)
    -- Wyczyść contentFrame
    for _, child in ipairs(contentFrame:GetChildren()) do
        child:Destroy()
    end
    if tabIndex == 1 then -- Aim
        -- Nagłówek "Aimbot"
        local header = Instance.new("TextLabel")
        header.Text = "Aimbot"
        header.Font = font
        header.TextSize = 16
        header.TextColor3 = textColor
        header.BackgroundTransparency = 1
        header.Position = UDim2.new(0, 16, 0, 16)
        header.Size = UDim2.new(0, 60, 0, 20)
        header.TextXAlignment = Enum.TextXAlignment.Left
        header.Parent = contentFrame
        -- Linia obok napisu
        local line = Instance.new("Frame")
        line.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        line.BorderSizePixel = 0
        line.Position = UDim2.new(0, 16 + 60 + 8, 0, 26)
        line.Size = UDim2.new(1, -(16 + 60 + 24), 0, 2)
        line.Parent = contentFrame
        -- Checkbox z napisem
        local aimbotCheckbox = createCheckbox(contentFrame, "Aimbot", UDim2.new(0, 16, 0, 52), nil)
        -- Smoothing label + value
        local smoothingRow = Instance.new("Frame")
        smoothingRow.BackgroundTransparency = 1
        smoothingRow.Size = UDim2.new(1, -32, 0, 18)
        smoothingRow.Position = UDim2.new(0, 16, 0, 82)
        smoothingRow.Parent = contentFrame
        -- Napis Smoothing
        local smoothingLabel = Instance.new("TextLabel")
        smoothingLabel.Text = "Smoothing"
        smoothingLabel.Font = font
        smoothingLabel.TextSize = 15
        smoothingLabel.TextColor3 = textColor
        smoothingLabel.BackgroundTransparency = 1
        smoothingLabel.Position = UDim2.new(0, 0, 0, -2)
        smoothingLabel.Size = UDim2.new(0, 100, 1, 0)
        smoothingLabel.TextXAlignment = Enum.TextXAlignment.Left
        smoothingLabel.Parent = smoothingRow
        -- Wartość po prawej
        local smoothingValue = Instance.new("TextLabel")
        smoothingValue.Text = "5/25"
        smoothingValue.Font = font
        smoothingValue.TextSize = 15
        smoothingValue.TextColor3 = textColor
        smoothingValue.BackgroundTransparency = 1
        smoothingValue.Position = UDim2.new(1, -48, 0, 0)
        smoothingValue.Size = UDim2.new(0, 48, 1, 0)
        smoothingValue.TextXAlignment = Enum.TextXAlignment.Right
        smoothingValue.Parent = smoothingRow
        -- Slider
        local sliderFrame = Instance.new("Frame")
        sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        sliderFrame.BorderColor3 = Color3.fromRGB(60, 60, 70)
        sliderFrame.BorderSizePixel = 1
        sliderFrame.Position = UDim2.new(0, 0, 0, 22)
        sliderFrame.Size = UDim2.new(1, 0, 0, 10)
        sliderFrame.Parent = smoothingRow
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
        sliderFill.Size = UDim2.new(0.2, 0, 1, 0) -- domyślnie 5/25
        sliderFill.Parent = sliderFrame
        -- Interaktywność slidera
        local minValue, maxValue = 0, 25
        local value = 5
        local dragging = false
        local function updateSlider(posX)
            local rel = math.clamp((posX - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
            value = math.floor(rel * (maxValue - minValue) + minValue + 0.5)
            sliderFill.Size = UDim2.new((value-minValue)/(maxValue-minValue), 0, 1, 0)
            smoothingValue.Text = tostring(value).."/"..tostring(maxValue)
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
        -- Hit part label
        local hitPartLabel = Instance.new("TextLabel")
        hitPartLabel.Text = "Hit part"
        hitPartLabel.Font = font
        hitPartLabel.TextSize = 15
        hitPartLabel.TextColor3 = textColor
        hitPartLabel.BackgroundTransparency = 1
        hitPartLabel.Position = UDim2.new(0, 16, 0, 118)
        hitPartLabel.Size = UDim2.new(0, 100, 0, 18)
        hitPartLabel.TextXAlignment = Enum.TextXAlignment.Left
        hitPartLabel.Parent = contentFrame
        -- Dropdown select (hover)
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.BackgroundColor3 = sidebarInnerColor
        dropdownFrame.BackgroundTransparency = 0
        dropdownFrame.BorderColor3 = Color3.fromRGB(40, 80, 180)
        dropdownFrame.BorderSizePixel = 2
        dropdownFrame.Position = UDim2.new(0, 16, 0, 140)
        dropdownFrame.Size = UDim2.new(0, 120, 0, 26)
        dropdownFrame.Parent = contentFrame
        -- Przycisk na górze (pusty lub z wybraną opcją)
        local selectedOption = Instance.new("TextButton")
        selectedOption.Text = hitPartCurrentOption or ""
        selectedOption.Font = font
        selectedOption.TextSize = 15
        selectedOption.TextColor3 = textColor
        selectedOption.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        selectedOption.BackgroundTransparency = 0
        selectedOption.Size = UDim2.new(1, 0, 1, 0)
        selectedOption.Position = UDim2.new(0, 0, 0, 0)
        selectedOption.AutoButtonColor = false
        selectedOption.Parent = dropdownFrame
        -- Lista opcji (ukryta domyślnie)
        local optionsFrame = Instance.new("Frame")
        optionsFrame.BackgroundColor3 = sidebarInnerColor
        optionsFrame.BorderColor3 = Color3.fromRGB(40, 80, 180)
        optionsFrame.BorderSizePixel = 2
        optionsFrame.Position = UDim2.new(0, 0, 1, 0)
        optionsFrame.Size = UDim2.new(1, 0, 0, 52)
        optionsFrame.Visible = false
        optionsFrame.Parent = dropdownFrame
        -- Funkcja do aktualizacji opcji
        local function updateDropdownOptions()
            for _, child in ipairs(optionsFrame:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            local options = {"Head", "Torso"}
            for i, opt in ipairs(options) do
                local btn = Instance.new("TextButton")
                btn.Text = opt
                btn.Font = font
                btn.TextSize = 15
                btn.TextColor3 = textColor
                btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                btn.BackgroundTransparency = 0
                btn.Size = UDim2.new(1, 0, 0, 26)
                btn.Position = UDim2.new(0, 0, 0, (i-1)*26)
                btn.AutoButtonColor = true
                btn.Parent = optionsFrame
                btn.MouseButton1Click:Connect(function()
                    hitPartCurrentOption = opt
                    selectedOption.Text = opt
                    optionsFrame.Visible = false
                end)
            end
        end
        updateDropdownOptions()
        -- Pokaz/ukryj opcje po kliknięciu
        selectedOption.MouseButton1Click:Connect(function()
            optionsFrame.Visible = not optionsFrame.Visible
        end)
        -- Nagłówek 'Checks' z linią obok, pod dropdownem
        local checksHeader = Instance.new("TextLabel")
        checksHeader.Text = "Checks"
        checksHeader.Font = font
        checksHeader.TextSize = 16
        checksHeader.TextColor3 = textColor
        checksHeader.BackgroundTransparency = 1
        checksHeader.Position = UDim2.new(0, 16, 0, 176)
        checksHeader.Size = UDim2.new(0, 80, 0, 20)
        checksHeader.TextXAlignment = Enum.TextXAlignment.Left
        checksHeader.Parent = contentFrame
        local checksLine = Instance.new("Frame")
        checksLine.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        checksLine.BorderSizePixel = 0
        checksLine.Position = UDim2.new(0, 16 + 80 + 8, 0, 186)
        checksLine.Size = UDim2.new(1, -(16 + 80 + 24), 0, 2)
        checksLine.Parent = contentFrame
        -- Checkbox 'Team check'
        local teamCheckbox = createCheckbox(contentFrame, "Team check", UDim2.new(0, 16, 0, 200), nil)
        -- Checkbox 'Wall check'
        local wallCheckbox = createCheckbox(contentFrame, "Wall check", UDim2.new(0, 16, 0, 228), nil)
        -- Checkbox 'Show Fov Circle'
        local fovCheckbox = createCheckbox(contentFrame, "Show Fov Circle", UDim2.new(0, 16, 0, 280), nil)
        -- Tekst 'Fov Radius'
        local fovRadiusLabel = Instance.new("TextLabel")
        fovRadiusLabel.Text = "Fov Radius"
        fovRadiusLabel.Font = font
        fovRadiusLabel.TextSize = 15
        fovRadiusLabel.TextColor3 = textColor
        fovRadiusLabel.BackgroundTransparency = 1
        fovRadiusLabel.Position = UDim2.new(0, 16, 0, 312)
        fovRadiusLabel.Size = UDim2.new(0, 120, 0, 18)
        fovRadiusLabel.TextXAlignment = Enum.TextXAlignment.Left
        fovRadiusLabel.Parent = contentFrame
        -- Suwak Fov Radius
        local fovSliderRow = Instance.new("Frame")
        fovSliderRow.BackgroundTransparency = 1
        fovSliderRow.Size = UDim2.new(1, -32, 0, 28)
        fovSliderRow.Position = UDim2.new(0, 16, 0, 330)
        fovSliderRow.Parent = contentFrame
        local fovValue = Instance.new("TextLabel")
        fovValue.Text = "60/400"
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
        fovSliderFill.Size = UDim2.new((60-20)/(400-20), 0, 1, 0) -- domyślnie 60/400
        fovSliderFill.Parent = fovSliderFrame
        -- Interaktywność suwaka
        local fovMin, fovMax = 20, 400
        local fovRadius = 60
        local fovDragging = false
        local function updateFovSlider(posX)
            local rel = math.clamp((posX - fovSliderFrame.AbsolutePosition.X) / fovSliderFrame.AbsoluteSize.X, 0, 1)
            fovRadius = math.floor(rel * (fovMax - fovMin) + fovMin + 0.5)
            fovSliderFill.Size = UDim2.new((fovRadius-fovMin)/(fovMax-fovMin), 0, 1, 0)
            fovValue.Text = tostring(fovRadius).."/"..tostring(fovMax)
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
    else
        -- Placeholder dla innych zakładek
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = textColor
        label.Font = font
        label.TextSize = 16
        label.Text = contentLabels[tabIndex]
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Top
        label.Position = UDim2.new(0, 16, 0, 16)
        label.Parent = contentFrame
    end
    -- Ensure all controls are visible in the scrolling area
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



