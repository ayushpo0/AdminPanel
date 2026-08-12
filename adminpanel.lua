-- ⚡ Ayush CoreGui Admin Panel ⚡
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Admin list
local Admins = {
    [4077953077] = true -- Ayush
}

if not Admins[player.UserId] then return end

-- GUI setup (CoreGui me attach)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AyushAdminPanel"
screenGui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0,600,0,500)
frame.Position = UDim2.new(0.05,0,0.1,0)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BorderColor3 = Color3.fromRGB(0,255,0)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,50)
title.Text = "⚡ AYUSH PANEL ⚡"
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(0,255,0)
title.BackgroundColor3 = Color3.fromRGB(20,20,20)
title.BorderColor3 = Color3.fromRGB(0,255,0)

-- Left menu sections
local sections = {"Credits","All Players","Target","Custom Anims","Character","Misc","Settings","Communication"}
local buttons = {}
for i, name in ipairs(sections) do
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0,150,0,40)
    btn.Position = UDim2.new(0,10,0,(i*45)+10)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(0,255,0)
    btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
    btn.BorderColor3 = Color3.fromRGB(0,255,0)
    buttons[name] = btn
end

-- Example Feature: Freeze First Player
local freezeBtn = Instance.new("TextButton", frame)
freezeBtn.Size = UDim2.new(0,200,0,40)
freezeBtn.Position = UDim2.new(0,170,0,70)
freezeBtn.Text = "Freeze First Player"
freezeBtn.TextColor3 = Color3.fromRGB(0,255,0)
freezeBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
freezeBtn.BorderColor3 = Color3.fromRGB(0,255,0)

freezeBtn.MouseButton1Click:Connect(function()
    local target = Players:GetPlayers()[2]
    if target and target.Character then
        local root = target.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.Anchored = true
        end
    end
end)

print("⚡ Ayush CoreGui Panel Loaded ⚡")

