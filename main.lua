local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Moha",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by Mohammed",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "Moha",
      FileName = "DeadRails"
   }
})

-- Tabs
local MainTab = Window:CreateTab("Main")
local EspTab = Window:CreateTab("ESP Settings")

-- إعدادات ESP
local ESP = {
    Enabled = false,
    TargetFolder = workspace:WaitForChild("RuntimeItems"),
    Highlights = {},
    OutlineColor = Color3.fromRGB(255, 255, 255) -- لون ثابت أبيض
}

-- دالة إنشاء ESP
local function CreateESP(obj)
    if not ESP.Enabled or not obj or not obj.Parent then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = obj
    highlight.FillTransparency = 1 -- تعبئة شفافة
    highlight.OutlineColor = ESP.OutlineColor
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = obj
    
    ESP.Highlights[obj] = highlight
end

-- دالة إزالة ESP
local function RemoveESP(obj)
    if ESP.Highlights[obj] then
        ESP.Highlights[obj]:Destroy()
        ESP.Highlights[obj] = nil
    end
end

-- دالة مسح كل الـ ESP
local function ClearAllESP()
    for obj, highlight in pairs(ESP.Highlights) do
        RemoveESP(obj)
    end
end

-- دالة تحديث كل الـ ESP
local function UpdateAllESP()
    if not ESP.Enabled then return end
    
    ClearAllESP()
    
    for _, obj in pairs(ESP.TargetFolder:GetDescendants()) do
        if obj:IsA("Model") then
            CreateESP(obj)
        end
    end
end

-- عنصر التفعيل في الواجهة
EspTab:CreateToggle({
    Name = "تفعيل ESP",
    CurrentValue = ESP.Enabled,
    Callback = function(Value)
        ESP.Enabled = Value
        if not Value then
            ClearAllESP()
        else
            UpdateAllESP()
        end
    end
})

-- متابعة الإضافات الجديدة
ESP.TargetFolder.DescendantAdded:Connect(function(obj)
    if ESP.Enabled and obj:IsA("Model") then
        CreateESP(obj)
    end
end)

-- متابعة الحذف بـ Heartbeat
game:GetService("RunService").Heartbeat:Connect(function()
    if not ESP.Enabled then return end
    
    -- التحقق من العناصر المحذوفة
    for obj, highlight in pairs(ESP.Highlights) do
        if not obj or not obj.Parent or not obj:IsDescendantOf(ESP.TargetFolder) then
            RemoveESP(obj)
        end
    end
    
    -- إضافة العناصر الجديدة
    for _, obj in pairs(ESP.TargetFolder:GetDescendants()) do
        if obj:IsA("Model") and not ESP.Highlights[obj] then
            CreateESP(obj)
        end
    end
end)