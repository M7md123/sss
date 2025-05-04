local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Moha - Advanced ESP",
   LoadingTitle = "Loading Advanced ESP System...",
   LoadingSubtitle = "by Mohammed",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MohaESP",
      FileName = "DeadRailsConfig"
   }
})

-- Tabs
local MainTab = Window:CreateTab("Main")
local EspTab = Window:CreateTab("ESP Settings")

-- إعدادات ESP المتقدمة
local AdvancedESP = {
    Enabled = false,
    Highlights = {},
    OutlineColor = Color3.fromRGB(255, 255, 255),
    
    -- نظام الفلاتر المتقدم
    Filters = {
        Items = {
            Enabled = true,
            ModelNames = {"Item", "Weapon", "Ammo"}, -- أسماء الموديلات أو الأجزاء
            ParentNames = {"RuntimeItems", "Drops"} -- أسماء الآباء المحتملة
        },
        Enemies = {
            Enabled = true,
            ModelNames = {"Enemy", "Zombie", "Bandit"},
            ParentNames = {"Enemies", "NPCs"}
        },
        DeadBodies = {
            Enabled = false,
            ModelNames = {"Corpse", "DeadBody", "Ragdoll"},
            ParentNames = {"Corpses", "Dead"}
        }
    }
}

-- دالة متقدمة للبحث عن العناصر في أي مكان في اللعبة
local function FindObjectsInGame()
    local foundObjects = {}
    
    -- البحث في كل الخدمات والمجلدات المهمة
    local searchLocations = {
        workspace,
        game:GetService("ReplicatedStorage"),
        game:GetService("ServerStorage"),
        game:GetService("Players")
    }
    
    for _, location in pairs(searchLocations) do
        for _, obj in pairs(location:GetDescendants()) do
            if obj:IsA("Model") then
                table.insert(foundObjects, obj)
            end
        end
    end
    
    return foundObjects
end

-- دالة متقدمة للتحقق من تطابق العنصر مع الفلاتر
local function MatchesFilter(obj)
    for filterName, filter in pairs(AdvancedESP.Filters) do
        if filter.Enabled then
            -- التحقق من أسماء الموديلات
            for _, name in pairs(filter.ModelNames) do
                if string.find(obj.Name:lower(), name:lower()) then
                    return true
                end
            end
            
            -- التحقق من الأباء
            local parent = obj.Parent
            while parent do
                for _, parentName in pairs(filter.ParentNames) do
                    if string.find(parent.Name:lower(), parentName:lower()) then
                        return true
                    end
                end
                parent = parent.Parent
            end
        end
    end
    return false
end

-- نظام ESP المطور
local function AdvancedCreateESP(obj)
    if not AdvancedESP.Enabled or not obj or not obj.Parent then return end
    if not MatchesFilter(obj) then return end
    if ESP.Highlights[obj] then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "AdvancedESP_Highlight"
    highlight.Adornee = obj
    highlight.FillTransparency = 1
    highlight.OutlineColor = AdvancedESP.OutlineColor
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = obj
    
    AdvancedESP.Highlights[obj] = highlight
end

-- بقية الدوال (RemoveESP, ClearAllESP, UpdateAllESP) تبقى كما هي مع تغيير AdvancedESP بدل ESP

-- نظام التحديث الذكي
local function SmartUpdate()
    if not AdvancedESP.Enabled then return end
    
    -- تحديث العناصر الحالية
    for obj, highlight in pairs(AdvancedESP.Highlights) do
        if not obj or not obj.Parent or not MatchesFilter(obj) then
            RemoveESP(obj)
        end
    end
    
    -- البحث عن عناصر جديدة
    local allObjects = FindObjectsInGame()
    for _, obj in pairs(allObjects) do
        if MatchesFilter(obj) then
            AdvancedCreateESP(obj)
        end
    end
end

-- واجهة التحكم المتقدمة
EspTab:CreateToggle({
    Name = "تفعيل النظام المتقدم",
    CurrentValue = AdvancedESP.Enabled,
    Callback = function(Value)
        AdvancedESP.Enabled = Value
        if not Value then
            ClearAllESP()
        else
            SmartUpdate()
        end
    end
})

-- إعداد الفلاتر
EspTab:CreateToggle({
    Name = "ESP للأغراض",
    CurrentValue = AdvancedESP.Filters.Items.Enabled,
    Callback = function(Value)
        AdvancedESP.Filters.Items.Enabled = Value
        if AdvancedESP.Enabled then SmartUpdate() end
    end
})

EspTab:CreateToggle({
    Name = "ESP للأعداء",
    CurrentValue = AdvancedESP.Filters.Enemies.Enabled,
    Callback = function(Value)
        AdvancedESP.Filters.Enemies.Enabled = Value
        if AdvancedESP.Enabled then SmartUpdate() end
    end
})

EspTab:CreateToggle({
    Name = "ESP للجثث",
    CurrentValue = AdvancedESP.Filters.DeadBodies.Enabled,
    Callback = function(Value)
        AdvancedESP.Filters.DeadBodies.Enabled = Value
        if AdvancedESP.Enabled then SmartUpdate() end
    end
})

-- نظام التحديث التلقائي
game:GetService("RunService").Heartbeat:Connect(function()
    if not AdvancedESP.Enabled then return end
    
    -- تحديث ذكي كل 30 إطار (حوالي 0.5 ثانية)
    if tick() % 0.5 < 0.016 then
        SmartUpdate()
    end
end)