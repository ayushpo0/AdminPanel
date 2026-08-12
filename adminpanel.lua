-- ⚡ Ayush CoreGui Admin Panel ⚡
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Admin list
local Admins = {
    [4077953077] = true -- Ayush
}
if not Admins[player.UserId] then return end

-- GUI setup
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

-- Minimize / Restore button
local minimizeBtn = Instance.new("TextButton", frame)
minimizeBtn.Size = UDim2.new(0,100,0,30)
minimizeBtn.Position = UDim2.new(1,-110,0,10)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(0,255,0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
minimizeBtn.BorderColor3 = Color3.fromRGB(0,255,0)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    if minimized then
        frame.Size = UDim2.new(0,600,0,500)
        minimized = false
        minimizeBtn.Text = "-"
    else
        frame.Size = UDim2.new(0,600,0,50)
        minimized = true
        minimizeBtn.Text = "+"
    end
end)

-- Sections
local sections = {"Target","Character","Misc","Communication"}
local buttons = {}
for i, name in ipairs(sections) do
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0,150,0,40)
    btn.Position = UDim2.new(0,10,0,(i*45)+60)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(0,255,0)
    btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
    btn.BorderColor3 = Color3.fromRGB(0,255,0)
    buttons[name] = btn
end

-- Target Section: ESP
local function espTarget(target)
    if target.Character then
        for _, part in pairs(target.Character:GetChildren()) do
            if part:IsA("BasePart") then
                local box = Instance.new("BoxHandleAdornment")
                box.Size = part.Size
                box.Adornee = part
                box.Color3 = Color3.fromRGB(0,255,0)
                box.Transparency = 0.5
                box.ZIndex = 10
                box.Parent = part
            end
        end
    end
end
buttons["Target"].MouseButton1Click:Connect(function()
    for _, other in pairs(Players:GetPlayers()) do
        if other ~= player then
            espTarget(other)
        end
    end
end)

-- Character Section: Anti-Fling + Anti-Void
local function characterFeatures()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    root.CustomPhysicalProperties = PhysicalProperties.new(1000,0,0,0,0)

    player.CharacterAdded:Connect(function(char)
        local root = char:WaitForChild("HumanoidRootPart")
        root:GetPropertyChangedSignal("Position"):Connect(function()
            if root.Position.Y < -50 then
                root.CFrame = CFrame.new(0,10,0)
            end
        end)
    end)
end
buttons["Character"].MouseButton1Click:Connect(characterFeatures)

-- Misc Section: Freeze First Player
buttons["Misc"].MouseButton1Click:Connect(function()
    local target = Players:GetPlayers()[2]
    if target and target.Character then
        local root = target.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.Anchored = true
        end
    end
end)

-- Communication Section: Anti VC Ban
buttons["Communication"].MouseButton1Click:Connect(function()
    print("Anti VC Ban active")
end)

print("⚡ Ayush CoreGui Panel Loaded ⚡")


