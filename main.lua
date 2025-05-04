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
    Highlights = {},
    OutlineColor = Color3.fromRGB(255, 255, 255), -- لون ثابت أبيض
    
    -- الفلاتر الجديدة
    Filters = {
        Items = {
            Enabled = true,
            Folders = {"Run", "Weapons"} -- أسماء المجلدات التي تحتوي على الأغراض
        },
        Enemies = {
            Enabled = true,
            Folders = {"Enemies", "Zombies"} -- أسماء المجلدات التي تحتوي على الأعداء
        },
        DeadBodies = {
            Enabled = false,
            Folders = {"Corpses", "DeadBodies"} -- أسماء المجلدات التي تحتوي على الجثث
        }
    }
}

-- دالة للتحقق مما إذا كان العنصر ينتمي لأي من الفلاتر المفعّلة
local function IsInFilter(obj)
    for _, filter in pairs(ESP.Filters) do
        if filter.Enabled then
            for _, folderName in pairs(filter.Folders) do
                local folder = workspace:FindFirstChild(folderName)
                if folder and obj:IsDescendantOf(folder) then
                    return true
                end
            end
        end
    end
    return false
end

-- دالة إنشاء ESP
local function CreateESP(obj)
    if not ESP.Enabled or not obj or not obj.Parent then return end
    if not IsInFilter(obj) then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = obj
    highlight.FillTransparency = 1
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
    
    -- البحث في جميع المجلدات المحددة
    for _, filter in pairs(ESP.Filters) do
        if filter.Enabled then
            for _, folderName in pairs(filter.Folders) do
                local folder = workspace:FindFirstChild(folderName)
                if folder then
                    for _, obj in pairs(folder:GetDescendants()) do
                        if obj:IsA("Model") then
                            CreateESP(obj)
                        end
                    end
                end
            end
        end
    end
end

-- عناصر الواجهة
EspTab:CreateToggle({
    Name = "ESP",
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

-- فلاتر ESP
EspTab:CreateToggle({
    Name = "ESP Items",
    CurrentValue = ESP.Filters.Items.Enabled,
    Callback = function(Value)
        ESP.Filters.Items.Enabled = Value
        if ESP.Enabled then UpdateAllESP() end
    end
})

EspTab:CreateToggle({
    Name = "ESP Enemies",
    CurrentValue = ESP.Filters.Enemies.Enabled,
    Callback = function(Value)
        ESP.Filters.Enemies.Enabled = Value
        if ESP.Enabled then UpdateAllESP() end
    end
})

EspTab:CreateToggle({
    Name = "ESP Dead Bodies",
    CurrentValue = ESP.Filters.DeadBodies.Enabled,
    Callback = function(Value)
        ESP.Filters.DeadBodies.Enabled = Value
        if ESP.Enabled then UpdateAllESP() end
    end
})

-- متابعة التغييرات
local function SetupFolderListener(folderName)
    local folder = workspace:FindFirstChild(folderName)
    if folder then
        folder.DescendantAdded:Connect(function(obj)
            if ESP.Enabled and obj:IsA("Model") then
                CreateESP(obj)
            end
        end)
    end
end

-- إعداد المستمعين لكل المجلدات
for _, filter in pairs(ESP.Filters) do
    for _, folderName in pairs(filter.Folders) do
        SetupFolderListener(folderName)
    end
end

-- متابعة الحذف بـ Heartbeat
game:GetService("RunService").Heartbeat:Connect(function()
    if not ESP.Enabled then return end
    
    for obj, highlight in pairs(ESP.Highlights) do
        if not obj or not obj.Parent or not IsInFilter(obj) then
            RemoveESP(obj)
        end
    end
end)