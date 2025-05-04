local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Moha - Safe ESP",
   LoadingTitle = "Loading Safe ESP System...",
   LoadingSubtitle = "by Mohammed",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MohaESPSafe",
      FileName = "DeadRailsSafeConfig"
   }
})

-- Tabs
local MainTab = Window:CreateTab("Main")
local EspTab = Window:CreateTab("ESP Settings")

-- إعدادات آمنة
local SafeESP = {
    Enabled = false,
    Active = false, -- حالة التنفيذ الفعلية
    Highlights = {},
    
    -- إعدادات المظهر
    VisualSettings = {
        FillTransparency = 1,
        OutlineColor = Color3.fromRGB(255, 255, 255),
        OutlineTransparency = 0,
        DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    },

    -- نظام الفلاتر الآمن
    Filters = {
        Items = {
            Enabled = false,
            ModelNames = {}, -- يمكن تركها فارغة لتعمل على كل الموديلات في المجلد
            ParentNames = {"RuntimeItems", ""RailSeg} -- سيأخذ كل شيء في هذا المجلد
        },
        Enemies = {
            Enabled = false,
            ModelNames = {},
            ParentNames = {"Enemies"}
        },
        DeadBodies = {
            Enabled = false,
            ModelNames = {},
            ParentNames = {"DeadBodies"}
        }
    }
}

-- دالة آمنة للبحث
local function SafeFindObjects()
    local foundObjects = {}
    
    for filterName, filter in pairs(SafeESP.Filters) do
        if filter.Enabled then
            for _, parentName in pairs(filter.ParentNames) do
                local parent = workspace:FindFirstChild(parentName)
                if parent then
                    for _, obj in pairs(parent:GetDescendants()) do
                        if obj:IsA("Model") then
                            -- إذا كانت ModelNames فارغة أو الاسم متطابق
                            if #filter.ModelNames == 0 or checkNameMatch(obj.Name, filter.ModelNames) then
                                table.insert(foundObjects, obj)
                            end
                        end
                    end
                end
            end
        end
    end
    
    return foundObjects
end

-- دالة مساعدة للتحقق من الأسماء
local function checkNameMatch(objName, nameList)
    objName = objName:lower()
    for _, name in pairs(nameList) do
        if string.find(objName, name:lower()) then
            return true
        end
    end
    return false
end

-- دالة إنشاء ESP آمنة
local function SafeCreateESP(obj)
    if not SafeESP.Active or not obj or not obj.Parent then return end
    if SafeESP.Highlights[obj] then return end
    
    -- حماية ضد الأخطاء
    local success, highlight = pcall(function()
        local h = Instance.new("Highlight")
        h.Name = "SafeESP_" .. obj.Name
        h.Adornee = obj
        h.FillTransparency = SafeESP.VisualSettings.FillTransparency
        h.OutlineColor = SafeESP.VisualSettings.OutlineColor
        h.OutlineTransparency = SafeESP.VisualSettings.OutlineTransparency
        h.DepthMode = SafeESP.VisualSettings.DepthMode
        h.Parent = obj
        return h
    end)
    
    if success and highlight then
        SafeESP.Highlights[obj] = highlight
    end
end

-- دالة الإزالة الآمنة
local function SafeRemoveESP(obj)
    if SafeESP.Highlights[obj] then
        pcall(function()
            SafeESP.Highlights[obj]:Destroy()
        end)
        SafeESP.Highlights[obj] = nil
    end
end

-- دالة المسح الآمن
local function SafeClearAllESP()
    for obj, highlight in pairs(SafeESP.Highlights) do
        SafeRemoveESP(obj)
    end
end

-- دالة التحديث الآمن
local function SafeUpdate()
    if not SafeESP.Enabled then return end
    
    -- تحديث العناصر الحالية
    for obj, highlight in pairs(SafeESP.Highlights) do
        if not obj or not obj.Parent then
            SafeRemoveESP(obj)
        end
    end
    
    -- البحث عن عناصر جديدة
    local allObjects = SafeFindObjects()
    for _, obj in pairs(allObjects) do
        SafeCreateESP(obj)
    end
end

-- واجهة التحكم الآمنة
local MainToggle = EspTab:CreateToggle({
    Name = "تفعيل ESP الرئيسي (آمن)",
    CurrentValue = SafeESP.Enabled,
    Callback = function(Value)
        SafeESP.Enabled = Value
        SafeESP.Active = Value
        
        -- حماية ضد التفعيل التلقائي
        if Value then
            task.spawn(function()
                SafeUpdate()
            end)
        else
            task.spawn(function()
                SafeClearAllESP()
            end)
        end
    end
})

-- إعداد الفلاتر
EspTab:CreateToggle({
    Name = "ESP للأغراض",
    CurrentValue = SafeESP.Filters.Items.Enabled,
    Callback = function(Value)
        SafeESP.Filters.Items.Enabled = Value
        if SafeESP.Enabled then
            task.spawn(SafeUpdate)
        end
    end
})

EspTab:CreateToggle({
    Name = "ESP للأعداء",
    CurrentValue = SafeESP.Filters.Enemies.Enabled,
    Callback = function(Value)
        SafeESP.Filters.Enemies.Enabled = Value
        if SafeESP.Enabled then
            task.spawn(SafeUpdate)
        end
    end
})

EspTab:CreateToggle({
    Name = "ESP للجثث",
    CurrentValue = SafeESP.Filters.DeadBodies.Enabled,
    Callback = function(Value)
        SafeESP.Filters.DeadBodies.Enabled = Value
        if SafeESP.Enabled then
            task.spawn(SafeUpdate)
        end
    end
})

-- نظام التحديث الآمن
local updateConn
updateConn = game:GetService("RunService").Heartbeat:Connect(function()
    if not SafeESP.Active then return end
    
    -- تحديث ذكي كل ثانية (للحماية من الباند)
    if tick() % 1 < 0.016 then
        pcall(SafeUpdate)
    end
end)

-- تنظيف عند الإغلاق
game:GetService("Players").LocalPlayer.CharacterRemoving:Connect(function()
    pcall(function()
        updateConn:Disconnect()
        SafeClearAllESP()
    end)
end)