-- testing

local fonts = {
    [0] = "UI",
    [1] = "System",
    [2] = "Plex",
    [3] = "Monospace"
}

local startY = 100
for fontId, fontName in pairs(fonts) do
    local text = Drawing.new("Text")
    text.Text = "Font " .. fontId .. ": " .. fontName
    text.Size = 22
    text.Position = Vector2.new(100, startY)
    text.Color = Color3.new(1, 1, 1)
    text.Center = false
    text.Outline = true
    text.Visible = true

    pcall(function()
        text.Font = fontId
    end)

    startY = startY + 30
end