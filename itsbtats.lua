--! ============================================
-- !🥔 سكربت بطاطس للطيران واختراق الجدران V2
-- !============================================
--*  @son233       
-----------------------------------------------*-*---------------------
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- !إعدادات الطيران واختراق الجدران
local flying = false
local noclip = false
local flySpeed = 50
local minSpeed = 10
local maxSpeed = 500
local speedStep = 10

local bodyVel, bodyGyro, renderConnection, noclipConnection

--  ! اختيار المجلد المناسب للـ GUI (بيدعم كل المشغلات)
local guiParent
if gethui then
    guiParent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    guiParent = game:GetService("CoreGui")
else
    guiParent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")
end

-- !حذف أي نسخة قديمة من السكربت
if guiParent:FindFirstChild("PotatoFlyGui") then
    guiParent.PotatoFlyGui:Destroy()
end

-- !اظهار الواجهة (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PotatoFlyGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = guiParent

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 235)
MainFrame.Position = UDim2.new(0.5, -120, 0.4, -117)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 12)
FrameCorner.Parent = MainFrame

--! شريط العنوان
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(211, 134, 11) -- لون بطاطسي ذهبي
Title.Text = "  V2 🥔 سكربت بطاطس للطيران"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- !زر التشغيل والإيقاف للطيران
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0.85, 0, 0, 36)
ToggleBtn.Position = UDim2.new(0.075, 0, 0, 48)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
ToggleBtn.Text = "🚀 تشغيل الطيران"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 15
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleBtn

-- !زر اختراق الجدران (Noclip)
local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Name = "NoclipBtn"
NoclipBtn.Size = UDim2.new(0.85, 0, 0, 36)
NoclipBtn.Position = UDim2.new(0.075, 0, 0, 90)
NoclipBtn.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
NoclipBtn.Text = "🧱 اختراق الجدران: متوقف"
NoclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipBtn.TextSize = 15
NoclipBtn.Font = Enum.Font.SourceSansBold
NoclipBtn.Parent = MainFrame

local NoclipCorner = Instance.new("UICorner")
NoclipCorner.CornerRadius = UDim.new(0, 8)
NoclipCorner.Parent = NoclipBtn

-- !نص عرض السرعة
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Size = UDim2.new(1, 0, 0, 25)
SpeedLabel.Position = UDim2.new(0, 0, 0, 132)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "السرعة: " .. tostring(flySpeed)
SpeedLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
SpeedLabel.TextSize = 15
SpeedLabel.Font = Enum.Font.SourceSansBold
SpeedLabel.Parent = MainFrame

--! زرار زيادة السرعة ▲
local UpBtn = Instance.new("TextButton")
UpBtn.Name = "UpBtn"
UpBtn.Size = UDim2.new(0.38, 0, 0, 35)
UpBtn.Position = UDim2.new(0.075, 0, 0, 162)
UpBtn.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
UpBtn.Text = "▲ زيادة"
UpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UpBtn.TextSize = 15
UpBtn.Font = Enum.Font.SourceSansBold
UpBtn.Parent = MainFrame

local UpCorner = Instance.new("UICorner")
UpCorner.CornerRadius = UDim.new(0, 8)
UpCorner.Parent = UpBtn

--* زرار تقليل السرعة ▼
local DownBtn = Instance.new("TextButton")
DownBtn.Name = "DownBtn"
DownBtn.Size = UDim2.new(0.38, 0, 0, 35)
DownBtn.Position = UDim2.new(0.545, 0, 0, 162)
DownBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
DownBtn.Text = "▼ تقليل"
DownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DownBtn.TextSize = 15
DownBtn.Font = Enum.Font.SourceSansBold
DownBtn.Parent = MainFrame

local DownCorner = Instance.new("UICorner")
DownCorner.CornerRadius = UDim.new(0, 8)
DownCorner.Parent = DownBtn

-- * نص حقوق السكربت السفلي
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Position = UDim2.new(0, 0, 0, 205)
Footer.BackgroundTransparency = 1
Footer.Text = "🥔 Potato Fly v2.0"
Footer.TextColor3 = Color3.fromRGB(150, 150, 150)
Footer.TextSize = 11
Footer.Font = Enum.Font.SourceSansItalic
Footer.Parent = MainFrame

-- ============================================
--! منطق ووظائف الطيران واختراق الجدران
-- ============================================

local function updateSpeedUI()
    SpeedLabel.Text = "السرعة: " .. tostring(flySpeed)
end

local function stopFly()
    flying = false
    ToggleBtn.Text = "🚀 تشغيل الطيران"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)

    if renderConnection then renderConnection:Disconnect() end
    if bodyVel then bodyVel:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end

    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end

local function startFly()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:WaitForChild("Humanoid")

    flying = true
    ToggleBtn.Text = "🛑  طفي الطيران"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)

    bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bodyVel.Velocity = Vector3.zero
    bodyVel.Parent = hrp

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    bodyGyro.P = 9000
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp

    humanoid.PlatformStand = true

    renderConnection = RunService.RenderStepped:Connect(function()
        if not flying or not hrp or not hrp.Parent then
            stopFly()
            return
        end

        local camera = workspace.CurrentCamera
        local moveDir = Vector3.zero

        -- * / WASD
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + camera.CFrame.RightVector
        end
        -- * شيفت وسبيس
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit
        end

        bodyVel.Velocity = moveDir * flySpeed
        bodyGyro.CFrame = camera.CFrame
    end)
end

-- * منطق تشغيل/إيقاف اختراق الجدران (Noclip)
local function stopNoclip()
    noclip = false
    NoclipBtn.Text = "🧱 اختراق الجدران: متوقف"
    NoclipBtn.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
end

local function startNoclip()
    noclip = true
    NoclipBtn.Text = "🟢 اختراق الجدران: مفعل"
    NoclipBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)

    noclipConnection = RunService.Stepped:Connect(function()
        if not noclip then
            stopNoclip()
            return
        end
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

-- ============================================
--* ربط الأحداث والأزرار
-- ============================================

--* زر الطيران
ToggleBtn.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
    else
        startFly()
    end
end)

--* زر اختراق الجدران
NoclipBtn.MouseButton1Click:Connect(function()
    if noclip then
        stopNoclip()
    else
        startNoclip()
    end
end)

--* أسهم تغيير السرعة من الواجهة
UpBtn.MouseButton1Click:Connect(function()
    if flySpeed + speedStep <= maxSpeed then
        flySpeed = flySpeed + speedStep
        updateSpeedUI()
    end
end)

DownBtn.MouseButton1Click:Connect(function()
    if flySpeed - speedStep >= minSpeed then
        flySpeed = flySpeed - speedStep
        updateSpeedUI()
    end
end)

--* تغيير السرعة بأسهم الكيبورد (Up / Down Arrows)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Up then
        if flySpeed + speedStep <= maxSpeed then
            flySpeed = flySpeed + speedStep
            updateSpeedUI()
        end
    elseif input.KeyCode == Enum.KeyCode.Down then
        if flySpeed - speedStep >= minSpeed then
            flySpeed = flySpeed - speedStep
            updateSpeedUI()
        end
    end
end)

-- * إلغاء التفعيل عند الموت/إعادة الرسبون
LocalPlayer.CharacterAdded:Connect(function()
    if flying then
        stopFly()
    end
    if noclip then
        stopNoclip()
    end
end)
