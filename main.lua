local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Moha",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by Mohammed",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = Moha, -- Create a custom folder for your hub/game
      FileName = "DeadRails"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})



--  // TABS //  --
local Main = Window:CreateTab("Main", "rewind")
local ESPTab = Window:CreateTab("ESP Settings)


--  // VARIABLES //  --
RunService = game:GetService("RunService")



--  // UI //  --

-- إعدادات ESP الأساسية
local ESP = {
    Enabled = false,
    Color = Color3.fromRGB(255, 0, 0), -- أحمر افتراضي
    OutlineColor = Color3.fromRGB(255, 255, 255), -- أبيض افتراضي
    TargetFolder = workspace:WaitForChild("TargetFolder"), -- غير لاسم المجلد المطلوب
    Objects = {},
    Highlights = {}
}

-- تبويب الإعدادات


-- تفعيل/تعطيل ESP
local Toggle = ESPTab:CreateToggle({
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

-- اختيار لون ESP
ESPTab:CreateColorPicker({
    Name = "لون ESP",
    Color = ESP.Color,
    Callback = function(Value)
        ESP.Color = Value
        UpdateESPColors()
    end
})

-- اختيار لون الحدود
ESPTab:CreateColorPicker({
    Name = "لون حدود ESP",
    Color = ESP.OutlineColor,
    Callback = function(Value)
        ESP.OutlineColor = Value
        UpdateESPColors()
    end
})

-- دالة لإنشاء ESP لعنصر
local function CreateESP(obj)
    if not ESP.Enabled or not obj or not obj.Parent then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = obj
    highlight.FillColor = ESP.Color
    highlight.OutlineColor = ESP.OutlineColor
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = obj
    
    ESP.Highlights[obj] = highlight
end

-- دالة لمسح ESP لعنصر
local function RemoveESP(obj)
    if ESP.Highlights[obj] then
        ESP.Highlights[obj]:Destroy()
        ESP.Highlights[obj] = nil
    end
end

-- دالة لمسح كل ESP
local function ClearAllESP()
    for obj, highlight in pairs(ESP.Highlights) do
        RemoveESP(obj)
    end
end

-- دالة لتحديث ألوان ESP
local function UpdateESPColors()
    for _, highlight in pairs(ESP.Highlights) do
        highlight.FillColor = ESP.Color
        highlight.OutlineColor = ESP.OutlineColor
    end
end

-- دالة لتحديث كل ESP
local function UpdateAllESP()
    if not ESP.Enabled then return end
    
    ClearAllESP()
    
    -- إضافة ESP لكل الموديلات الموجودة
    for _, obj in pairs(ESP.TargetFolder:GetDescendants()) do
        if obj:IsA("Model") then
            CreateESP(obj)
        end
    end
end

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
    
    -- إضافة العناصر الجديدة (حماية إضافية)
    for _, obj in pairs(ESP.TargetFolder:GetDescendants()) do
        if obj:IsA("Model") and not ESP.Highlights[obj] then
            CreateESP(obj)
        end
    end
end)

-- التحميل الأولي
if ESP.Enabled then
    UpdateAllESP()
end