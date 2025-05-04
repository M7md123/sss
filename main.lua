local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Dead Rails Ass Hub",
   Icon = 0,
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by Moha",
   Theme = "Default",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "Moha",
      FileName = "Config"
   }
})



--  // FLAGS //  --
_G.Flags = {
    ShowTime = false
}



--  // TABS //  --
local MainTab = Window:CreateTab("Main", 4483362458)
local EspTab = Window:CreateTab("Esp", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)


--  // UI ELEMENTS //  --
local Toggle = MiscTab:CreateToggle({
   Name = "Show Time",
   CurrentValue = false,
   Flag = "ShowTimeToggle",
   Callback = function(Value)
     _G.Flags.ShowTime == true
     if
   end,
})



--  // SHOW TIME //  --
-- إنشاء ScreenGui
local function ShowTime()
  if _G.Flags.ShowTime = true then
    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    ScreenGui.Name = "GameHourText"

-- إنشاء TextLabel
    local GameHour = Instance.new("TextLabel")
    GameHour.Parent = ScreenGui
    GameHour.Size = UDim2.new(0, 150, 0, 50)  -- تصغير الحجم
    GameHour.Position = UDim2.new(0, 0, 0.5, 0)  -- يضع النص مباشرة في اليسار
    GameHour.BackgroundTransparency = 1
    GameHour.TextColor3 = Color3.fromRGB(255, 255, 255)
    GameHour.TextStrokeTransparency = 0 -- يعطي Outline
    GameHour.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    GameHour.Font = Enum.Font.Garamond
    GameHour.TextSize = 20  -- تصغير حجم النص
    GameHour.TextXAlignment = Enum.TextXAlignment.Left  -- لجعل النص يبدأ من اليسار
    GameHour.TextYAlignment = Enum.TextYAlignment.Center
    GameHour.AnchorPoint = Vector2.new(0, 0.5) -- من منتصف اليسار

-- حط المسار الكامل للمتغير اللي فيه الوقت
    local timeValue = game:GetService("ReplicatedStorage"):WaitForChild("TimeHour")

-- تعيين النص الأولي مع قيمة الوقت الحالية
    GameHour.Text = "Time: " .. tostring(timeValue.Value)

-- تحديث النص مع الوقت عند تغييره
    timeValue:GetPropertyChangedSignal("Value"):Connect(function()
        GameHour.Text = "Time: " .. tostring(timeValue.Value)
    end)
  else
    local espUi = game:GetService("CoreGui"):FindFirstChild("MohaESP_UI")
    if espUi then
    espUi:Destroy()
    end
  end
end
