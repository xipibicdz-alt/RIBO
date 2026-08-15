-- ===== main.lua =====
-- سكربت Brookhaven بسيط مع 3 ميزات

-- تحميل مكتبة الواجهة
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xipibicdz-alt/RIBO/refs/heads/main/library.lua"))()

-- متغيرات عامة
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ============================================
-- 1. إنشاء النافذة الرئيسية
-- ============================================
local Window = Library:CreateWindow("🚀 سكربتي الشخصي")

-- ============================================
-- 2. تبويب الميزات الرئيسية
-- ============================================
local MainTab = Window:CreateTab("الميزات")

-- ============================================
-- 3. ميزة الطيران (Fly)
-- ============================================
local flyEnabled = false
local flyConnection = nil
local flySpeed = 50

MainTab:CreateToggle("🕊️ وضع الطيران", false, function(state)
    flyEnabled = state
    
    if flyEnabled then
        -- تفعيل الطيران
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
        
        if not humanoid or not rootPart then return end
        
        -- حفظ الإعدادات الأصلية
        local originalGravity = workspace.Gravity
        workspace.Gravity = 0
        
        -- BodyVelocity للتحكم بالحركة
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart
        
        -- BodyGyro للتحكم بالاتجاه
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bodyGyro.P = 1e5
        bodyGyro.CFrame = rootPart.CFrame
        bodyGyro.Parent = rootPart
        
        -- التحكم بالطيران
        local userInput = game:GetService("UserInputService")
        local moveVector = Vector3.new(0, 0, 0)
        
        flyConnection = RunService.RenderStepped:Connect(function()
            if not flyEnabled or not rootPart.Parent then
                return
            end
            
            -- حساب اتجاه الحركة
            local camera = workspace.CurrentCamera
            local forward = camera.CFrame.LookVector
            local right = camera.CFrame.RightVector
            local up = camera.CFrame.UpVector
            
            -- قراءة مفاتيح WASD والفضاء
            local moveDirection = Vector3.new(0, 0, 0)
            
            if userInput:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + forward end
            if userInput:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - forward end
            if userInput:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - right end
            if userInput:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + right end
            if userInput:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + up end
            if userInput:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - up end
            
            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit * flySpeed
            end
            
            -- تطبيق الحركة
            bodyVelocity.Velocity = moveDirection
            bodyGyro.CFrame = camera.CFrame
        end)
        
        -- عند تدمير الشخصية
        local function onCharacterAdded(newChar)
            if flyEnabled then
                task.wait(0.5)
                local newRoot = newChar:FindFirstChild("HumanoidRootPart") or newChar:FindFirstChild("Torso")
                if newRoot then
                    bodyVelocity.Parent = newRoot
                    bodyGyro.Parent = newRoot
                end
            end
        end
        
        LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
        
        print("✅ تم تفعيل الطيران")
        
    else
        -- إيقاف الطيران
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        -- إعادة الجاذبية
        workspace.Gravity = 196.2
        
        -- حذف الـ BodyVelocity و BodyGyro
        local character = LocalPlayer.Character
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
            if rootPart then
                for _, child in ipairs(rootPart:GetChildren()) do
                    if child:IsA("BodyVelocity") or child:IsA("BodyGyro") then
                        child:Destroy()
                    end
                end
            end
        end
        
        print("❌ تم إيقاف الطيران")
    end
end)

-- ============================================
-- 4. ميزة الانتقال إلى لاعب
-- ============================================
local selectedPlayer = nil
local playerDropdown = nil

-- دالة جلب أسماء اللاعبين
local function GetPlayerNames()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

-- إنشاء القائمة المنسدلة
playerDropdown = MainTab:CreateTextBox("اكتب اسم اللاعب للانتقال...", function(playerName)
    if playerName and playerName ~= "" then
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Name:lower():sub(1, #playerName) == playerName:lower() then
                selectedPlayer = player
                print("✅ تم اختيار: " .. player.Name)
                return
            end
        end
        print("❌ لم يتم العثور على لاعب باسم: " .. playerName)
    end
end)

-- زر الانتقال
MainTab:CreateButton("📍 الانتقال إلى اللاعب", function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = selectedPlayer.Character.HumanoidRootPart.Position
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
            print("✅ تم الانتقال إلى: " .. selectedPlayer.Name)
        else
            print("❌ لا يمكن الانتقال: الشخصية غير موجودة")
        end
    else
        print("❌ اللاعب غير متاح أو غير موجود")
    end
end)

-- ============================================
-- 5. ميزة تغيير الاسم
-- ============================================
MainTab:CreateTextBox("✏️ اكتب الاسم الجديد...", function(newName)
    if newName and newName ~= "" then
        -- محاولة تغيير الاسم عبر Remote
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RE")
        if remote then
            local nameRemote = remote:FindFirstChild("1RPNam1eTex1t")
            if nameRemote then
                local args = {"RolePlayName", newName}
                pcall(function()
                    nameRemote:FireServer(unpack(args))
                    print("✅ تم تغيير الاسم إلى: " .. newName)
                end)
            else
                print("❌ Remote الخاص بالاسم غير موجود (قد يكون تغير في التحديث)")
            end
        else
            print("❌ RemoteStorage غير موجود")
        end
    end
end)

-- ============================================
-- 6. زر إضافي: معلومات
-- ============================================
MainTab:CreateButton("ℹ️ معلومات السكربت", function()
    print("===== معلومات السكربت =====")
    print("📌 المطور: أنت")
    print("📌 الإصدار: 1.0")
    print("📌 الميزات: طيران، انتقال، تغيير اسم")
    print("📌 تاريخ: " .. os.date("%Y-%m-%d %H:%M:%S"))
end)

-- ============================================
-- 7. تحديث قائمة اللاعبين تلقائياً
-- ============================================
Players.PlayerAdded:Connect(function()
    print("🔄 لاعب جديد دخل السيرفر")
end)

Players.PlayerRemoving:Connect(function()
    print("🔄 لاعب خرج من السيرفر")
end)

print("🚀 تم تحميل السكربت بنجاح!")
