-- ===== library.lua =====
-- مكتبة بسيطة لإنشاء واجهة GUI

local Library = {}

-- إنشاء نافذة رئيسية
function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    MainFrame.BorderSizePixel = 0
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    
    -- عنوان النافذة
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = MainFrame
    TitleLabel.Size = UDim2.new(1, 0, 0, 40)
    TitleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextScaled = true
    Instance.new("UICorner", TitleLabel).CornerRadius = UDim.new(0, 8)
    
    -- حاوية التبويبات
    local TabContainer = Instance.new("Frame")
    TabContainer.Parent = MainFrame
    TabContainer.Size = UDim2.new(1, -10, 0, 30)
    TabContainer.Position = UDim2.new(0, 5, 0, 45)
    TabContainer.BackgroundTransparency = 1
    
    -- حاوية المحتوى
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Parent = MainFrame
    ContentContainer.Size = UDim2.new(1, -20, 1, -90)
    ContentContainer.Position = UDim2.new(0, 10, 0, 80)
    ContentContainer.BackgroundTransparency = 1
    
    local tabs = {}
    local currentTab = nil
    
    -- دالة إنشاء تبويب
    local function CreateTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabContainer
        TabButton.Size = UDim2.new(0, 80, 1, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextSize = 12
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 4)
        
        local TabContent = Instance.new("Frame")
        TabContent.Parent = ContentContainer
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        
        -- ترتيب الأزرار داخل التبويب
        local buttonY = 0
        
        -- دالة إنشاء زر
        local function CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Parent = TabContent
            Button.Size = UDim2.new(1, -10, 0, 35)
            Button.Position = UDim2.new(0, 5, 0, buttonY)
            Button.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.Font = Enum.Font.GothamBold
            Button.TextSize = 14
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)
            
            Button.MouseButton1Click:Connect(callback)
            
            buttonY = buttonY + 40
            return Button
        end
        
        -- دالة إنشاء Toggle
        local function CreateToggle(text, default, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Parent = TabContent
            ToggleFrame.Size = UDim2.new(1, -10, 0, 35)
            ToggleFrame.Position = UDim2.new(0, 5, 0, buttonY)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 4)
            
            local Label = Instance.new("TextLabel")
            Label.Parent = ToggleFrame
            Label.Size = UDim2.new(0.7, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Position = UDim2.new(0, 10, 0, 0)
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Parent = ToggleFrame
            ToggleButton.Size = UDim2.new(0, 50, 0, 25)
            ToggleButton.Position = UDim2.new(0.8, 0, 0.5, -12.5)
            ToggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
            ToggleButton.Text = default and "ON" or "OFF"
            ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleButton.Font = Enum.Font.GothamBold
            ToggleButton.TextSize = 12
            Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 4)
            
            local state = default
            
            ToggleButton.MouseButton1Click:Connect(function()
                state = not state
                ToggleButton.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
                ToggleButton.Text = state and "ON" or "OFF"
                callback(state)
            end)
            
            buttonY = buttonY + 40
            return ToggleButton
        end
        
        -- دالة إنشاء TextBox
        local function CreateTextBox(placeholder, callback)
            local Box = Instance.new("TextBox")
            Box.Parent = TabContent
            Box.Size = UDim2.new(1, -10, 0, 35)
            Box.Position = UDim2.new(0, 5, 0, buttonY)
            Box.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
            Box.Text = ""
            Box.PlaceholderText = placeholder
            Box.TextColor3 = Color3.fromRGB(255, 255, 255)
            Box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
            Box.Font = Enum.Font.GothamBold
            Box.TextSize = 14
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
            
            Box.FocusLost:Connect(function(enterPressed)
                if enterPressed and Box.Text ~= "" then
                    callback(Box.Text)
                end
            end)
            
            buttonY = buttonY + 40
            return Box
        end
        
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(tabs) do
                tab.Content.Visible = false
            end
            TabContent.Visible = true
        end)
        
        table.insert(tabs, {Button = TabButton, Content = TabContent})
        
        -- إذا كان أول تبويب، اجعله ظاهراً
        if #tabs == 1 then
            TabContent.Visible = true
        end
        
        return {
            CreateButton = CreateButton,
            CreateToggle = CreateToggle,
            CreateTextBox = CreateTextBox
        }
    end
    
    -- سحب النافذة
    local dragging = false
    local dragStart, startPos
    
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    MainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    return {
        CreateTab = CreateTab
    }
end

return Library