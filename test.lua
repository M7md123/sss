local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "MohaESP_UI"

local Label = Instance.new("TextLabel")
Label.Parent = ScreenGui
Label.Text = "Time"
Label.Size = UDim2.new(0, 300, 0, 50)
Label.Position = UDim2.new(0, 100, 1, -100)
Label.BackgroundTransparency = 1
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.TextStrokeTransparency = 0 -- يعطي Outline
Label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
Label.Font = Enum.Font.Garamond
Label.TextSize = 24
Label.TextXAlignment = Enum.TextXAlignment.Center
Label.TextYAlignment = Enum.TextYAlignment.Center