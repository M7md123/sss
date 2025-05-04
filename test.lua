-- إنشاء ScreenGui
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "MohaESP_UI"

-- إنشاء TextLabel
local Label = Instance.new("TextLabel")
Label.Parent = ScreenGui
Label.Size = UDim2.new(0, 150, 0, 50)  -- تصغير الحجم
Label.Position = UDim2.new(0, 0, 0.5, 0)  -- يضع النص مباشرة في اليسار
Label.BackgroundTransparency = 1
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.TextStrokeTransparency = 0 -- يعطي Outline
Label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
Label.Font = Enum.Font.Garamond
Label.TextSize = 20  -- تصغير حجم النص
Label.TextXAlignment = Enum.TextXAlignment.Left  -- لجعل النص يبدأ من اليسار
Label.TextYAlignment = Enum.TextYAlignment.Center
Label.AnchorPoint = Vector2.new(0, 0.5) -- من منتصف اليسار

-- حط المسار الكامل للمتغير اللي فيه الوقت
local timeValue = game:GetService("ReplicatedStorage"):WaitForChild("TimeHour")

-- تعيين النص الأولي مع قيمة الوقت الحالية
Label.Text = "Time: " .. tostring(timeValue.Value)

-- تحديث النص مع الوقت عند تغييره
timeValue:GetPropertyChangedSignal("Value"):Connect(function()
    Label.Text = "Time: " .. tostring(timeValue.Value)
end)

--[[
local espUi = game:GetService("CoreGui"):FindFirstChild("MohaESP_UI")
if espUi then
    espUi:Destroy()
end

]]