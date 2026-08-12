-- ⚡ Ayush Full CoreGui Admin Panel (Password + Features) ⚡
-- Paste this as adminpanel.lua and load from:
-- https://raw.githubusercontent.com/ayushpo0/AdminPanel/main/adminpanel.lua

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
if not player then return end

-- ====== CONFIG ======
local PASSWORD = "ayush bolte" -- required password (case-insensitive)
local HEADSIT_ANIM_ID = "rbxassetid://591872667" -- replace with your headsit anim id
-- ====================

-- Admin check (optional)
local Admins = {
    [4077953077] = true -- Ayush
}
if not Admins[player.UserId] then return end

-- Utility
local function safeFindCharacter(plr)
    if not plr then return nil end
    return plr.Character or plr.CharacterAdded:Wait()
end

local function getHumanoid(plr)
    local char = safeFindCharacter(plr)
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

-- ====== GUI ======
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AyushAdminPanel"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

-- Password frame (shown first)
local passFrame = Instance.new("Frame", screenGui)
passFrame.Size = UDim2.new(0,340,0,160)
passFrame.Position = UDim2.new(0.35,0,0.3,0)
passFrame.BackgroundColor3 = Color3.fromRGB(10,10,10)
passFrame.BorderColor3 = Color3.fromRGB(0,200,0)

local passTitle = Instance.new("TextLabel", passFrame)
passTitle.Size = UDim2.new(1,0,0,40)
passTitle.Position = UDim2.new(0,0,0,0)
passTitle.BackgroundColor3 = Color3.fromRGB(20,20,20)
passTitle.TextColor3 = Color3.fromRGB(0,255,0)
passTitle.TextScaled = true
passTitle.Text = "Enter Password"

local passBox = Instance.new("TextBox", passFrame)
passBox.Size = UDim2.new(1,-20,0,40)
passBox.Position = UDim2.new(0,10,0,50)
passBox.PlaceholderText = "Password..."
passBox.Text = ""
passBox.TextColor3 = Color3.fromRGB(0,255,0)
passBox.BackgroundColor3 = Color3.fromRGB(15,15,15)
passBox.ClearTextOnFocus = false

local submitBtn = Instance.new("TextButton", passFrame)
submitBtn.Size = UDim2.new(0.5,0,0,36)
submitBtn.Position = UDim2.new(0.25,0,0,100)
submitBtn.Text = "Unlock"
submitBtn.TextColor3 = Color3.fromRGB(0,255,0)
submitBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)

-- Main panel (hidden until unlocked)
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0,640,0,520)
frame.Position = UDim2.new(0.05,0,0.08,0)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BorderColor3 = Color3.fromRGB(0,255,0)
frame.Visible = false

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,50)
title.Position = UDim2.new(0,0,0,0)
title.Text = "⚡ AYUSH PANEL ⚡"
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(0,255,0)
title.BackgroundColor3 = Color3.fromRGB(20,20,20)
title.BorderColor3 = Color3.fromRGB(0,255,0)

-- Minimize / Restore
local minimizeBtn = Instance.new("TextButton", frame)
minimizeBtn.Size = UDim2.new(0,90,0,30)
minimizeBtn.Position = UDim2.new(1,-100,0,10)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(0,255,0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    if minimized then
        frame.Size = UDim2.new(0,640,0,520)
        minimized = false
        minimizeBtn.Text = "-"
    else
        frame.Size = UDim2.new(0,640,0,50)
        minimized = true
        minimizeBtn.Text = "+"
    end
end)

-- Status label
local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1,-20,0,24)
statusLabel.Position = UDim2.new(0,10,0,52)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(0,255,0)
statusLabel.Text = "Status: Locked"
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.TextScaled = false
statusLabel.Font = Enum.Font.SourceSans

-- Left column (controls)
local leftCol = Instance.new("Frame", frame)
leftCol.Size = UDim2.new(0,220,1,-80)
leftCol.Position = UDim2.new(0,10,0,80)
leftCol.BackgroundTransparency = 1

-- Target input
local targetLabel = Instance.new("TextLabel", leftCol)
targetLabel.Size = UDim2.new(1,0,0,20)
targetLabel.Position = UDim2.new(0,0,0,0)
targetLabel.BackgroundTransparency = 1
targetLabel.Text = "Target Username"
targetLabel.TextColor3 = Color3.fromRGB(0,255,0)
targetLabel.TextXAlignment = Enum.TextXAlignment.Left

local targetBox = Instance.new("TextBox", leftCol)
targetBox.Size = UDim2.new(1,0,0,30)
targetBox.Position = UDim2.new(0,0,0,24)
targetBox.PlaceholderText = "Type exact username"
targetBox.TextColor3 = Color3.fromRGB(0,255,0)
targetBox.BackgroundColor3 = Color3.fromRGB(15,15,15)

-- Buttons area
local function makeButton(parent, y, text)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1,0,0,34)
    b.Position = UDim2.new(0,0,0,y)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(0,255,0)
    b.BackgroundColor3 = Color3.fromRGB(20,20,20)
    return b
end

local espToggleBtn = makeButton(leftCol, 70, "Toggle ESP (All)")
local teleportBtn = makeButton(leftCol, 110, "Teleport To Target")
local freezeBtn = makeButton(leftCol, 150, "Freeze Target")
local unfreezeBtn = makeButton(leftCol, 190, "Unfreeze Target")
local headsitPlayBtn = makeButton(leftCol, 230, "Play Headsit")
local headsitStopBtn = makeButton(leftCol, 270, "Stop Headsit")
local antiFlingToggleBtn = makeButton(leftCol, 310, "Toggle Anti-Fling")
local antiVoidToggleBtn = makeButton(leftCol, 350, "Toggle Anti-Void")
local broadcastBtn = makeButton(leftCol, 390, "Broadcast Chat")

-- Right column (info / small log)
local rightCol = Instance.new("Frame", frame)
rightCol.Size = UDim2.new(1,-260,1,-80)
rightCol.Position = UDim2.new(0,240,0,80)
rightCol.BackgroundTransparency = 1

local infoLabel = Instance.new("TextLabel", rightCol)
infoLabel.Size = UDim2.new(1,0,0,20)
infoLabel.Position = UDim2.new(0,0,0,0)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Info / Log"
infoLabel.TextColor3 = Color3.fromRGB(0,255,0)
infoLabel.TextXAlignment = Enum.TextXAlignment.Left

local logBox = Instance.new("TextLabel", rightCol)
logBox.Size = UDim2.new(1,0,1,-30)
logBox.Position = UDim2.new(0,0,0,24)
logBox.BackgroundColor3 = Color3.fromRGB(10,10,10)
logBox.TextColor3 = Color3.fromRGB(0,255,0)
logBox.TextWrapped = true
logBox.TextYAlignment = Enum.TextYAlignment.Top
logBox.Text = "Ready."
logBox.TextXAlignment = Enum.TextXAlignment.Left
logBox.Font = Enum.Font.Code

-- Helper log function
local function log(msg)
    logBox.Text = os.date("%H:%M:%S") .. " — " .. tostring(msg) .. "\n" .. logBox.Text
    statusLabel.Text = "Status: " .. tostring(msg)
end

-- ====== Feature state ======
local espEnabled = false
local espAdornments = {} -- [player] = {adorn1, adorn2, ...}
local antiFlingEnabled = false
local antiVoidEnabled = false
local headsitTrack = nil

-- ====== Password unlock ======
submitBtn.MouseButton1Click:Connect(function()
    local entered = tostring(passBox.Text or "")
    if string.lower(entered) == string.lower(PASSWORD) then
        frame.Visible = true
        passFrame:Destroy()
        log("Panel unlocked")
    else
        passBox.Text = ""
        passBox.PlaceholderText = "Wrong Password!"
        log("Wrong password attempt")
    end
end)

-- ====== ESP functions ======
local function clearESPForPlayer(plr)
    if not espAdornments[plr] then return end
    for _, a in ipairs(espAdornments[plr]) do
        if a and a.Parent then
            a:Destroy()
        end
    end
    espAdornments[plr] = nil
end

local function createESPForPlayer(plr)
    clearESPForPlayer(plr)
    if not plr.Character then return end
    espAdornments[plr] = {}
    for _, part in ipairs(plr.Character:GetChildren()) do
        if part:IsA("BasePart") then
            local box = Instance.new("BoxHandleAdornment")
            box.Adornee = part
            box.Size = part.Size
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Color3 = Color3.fromRGB(0,255,0)
            box.Transparency = 0.5
            box.Parent = part -- safe parent
            table.insert(espAdornments[plr], box)
        end
    end
end

local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                createESPForPlayer(plr)
            end
        end
        log("ESP enabled")
    else
        for _, plr in ipairs(Players:GetPlayers()) do
            clearESPForPlayer(plr)
        end
        log("ESP disabled")
    end
end

espToggleBtn.MouseButton1Click:Connect(toggleESP)

-- Keep ESP updated for players joining/leaving/character respawn
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        if espEnabled and plr ~= player then
            createESPForPlayer(plr)
        end
    end)
end)
Players.PlayerRemoving:Connect(function(plr)
    clearESPForPlayer(plr)
end)

-- ====== Target helpers ======
local function findPlayerByName(name)
    if not name or name == "" then return nil end
    for _, plr in ipairs(Players:GetPlayers()) do
        if string.lower(plr.Name) == string.lower(name) then
            return plr
        end
    end
    return nil
end

-- ====== Teleport to target ======
teleportBtn.MouseButton1Click:Connect(function()
    local name = targetBox.Text
    local target = findPlayerByName(name)
    if not target then
        log("Teleport failed: target not found")
        return
    end
    local targetChar = target.Character
    local myChar = player.Character
    if not targetChar or not myChar then
        log("Teleport failed: missing character")
        return
    end
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if targetRoot and myRoot then
        myRoot.CFrame = targetRoot.CFrame + Vector3.new(0,5,0)
        log("Teleported to " .. target.Name)
    else
        log("Teleport failed: missing HumanoidRootPart")
    end
end)

-- ====== Freeze / Unfreeze target ======
local frozenParts = {}

freezeBtn.MouseButton1Click:Connect(function()
    local name = targetBox.Text
    local target = findPlayerByName(name)
    if not target or not target.Character then
        log("Freeze failed: target not found")
        return
    end
    local root = target.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.Anchored = true
        frozenParts[target] = root
        log("Frozen " .. target.Name)
    else
        log("Freeze failed: no root")
    end
end)

unfreezeBtn.MouseButton1Click:Connect(function()
    local name = targetBox.Text
    local target = findPlayerByName(name)
    if not target then
        log("Unfreeze failed: target not found")
        return
    end
    local root = frozenParts[target]
    if root and root.Parent then
        root.Anchored = false
        frozenParts[target] = nil
        log("Unfrozen " .. target.Name)
    else
        log("Unfreeze: nothing to unfreeze")
    end
end)

-- ====== Headsit animation ======
local function ensureHeadsitTrack()
    local hum = getHumanoid(player)
    if not hum then return nil end
    if headsitTrack and headsitTrack.Parent == hum then return headsitTrack end
    -- load new
    local anim = Instance.new("Animation")
    anim.Name = "AyushHeadsitAnim"
    anim.AnimationId = HEADSIT_ANIM_ID
    local track = hum:LoadAnimation(anim)
    headsitTrack = track
    return headsitTrack
end

headsitPlayBtn.MouseButton1Click:Connect(function()
    local track = ensureHeadsitTrack()
    if track then
        if track.IsPlaying then track:Stop() end
        track:Play()
        log("Headsit playing")
    else
        log("Headsit failed: humanoid missing")
    end
end)

headsitStopBtn.MouseButton1Click:Connect(function()
    if headsitTrack and headsitTrack.IsPlaying then
        headsitTrack:Stop()
        log("Headsit stopped")
    else
        log("Headsit not playing")
    end
end)

-- Recreate headsit track on character respawn
player.CharacterAdded:Connect(function()
    headsitTrack = nil
    -- small delay to allow humanoid
    wait(0.5)
    ensureHeadsitTrack()
end)

-- ====== Anti-Fling ======
antiFlingToggleBtn.MouseButton1Click:Connect(function()
    antiFlingEnabled = not antiFlingEnabled
    local char = player.Character
    if antiFlingEnabled and char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root.CustomPhysicalProperties = PhysicalProperties.new(1000,0,0,0,0)
            log("Anti-Fling enabled")
        else
            log("Anti-Fling: no root")
        end
    else
        -- reset to default by setting nil physical props (can't set nil, so set light)
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0.7,0.3,0.5,1,1)
        end
        log("Anti-Fling disabled")
    end
end)

-- ====== Anti-Void ======
local voidConnection = nil
antiVoidToggleBtn.MouseButton1Click:Connect(function()
    antiVoidEnabled = not antiVoidEnabled
    if antiVoidEnabled then
        voidConnection = player.CharacterAdded:Connect(function(char)
            local root = char:WaitForChild("HumanoidRootPart")
            root:GetPropertyChangedSignal("Position"):Connect(function()
                if root.Position.Y < -50 then
                    root.CFrame = CFrame.new(0,10,0)
                    log("Anti-Void teleported you up")
                end
            end)
        end)
        -- also attach to current character
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            root:GetPropertyChangedSignal("Position"):Connect(function()
                if root.Position.Y < -50 then
                    root.CFrame = CFrame.new(0,10,0)
                    log("Anti-Void teleported you up")
                end
            end)
        end
        log("Anti-Void enabled")
    else
        if voidConnection then
            voidConnection:Disconnect()
            voidConnection = nil
        end
        log("Anti-Void disabled")
    end
end)

-- ====== Broadcast Chat ======
broadcastBtn.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        local msgEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if msgEvent and msgEvent:FindFirstChild("SayMessageRequest") then
            msgEvent.SayMessageRequest:FireServer("⚡ Ayush Panel Active ⚡", "All")
            log("Broadcast sent")
        else
            -- fallback: try global path (some games differ)
            ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("⚡ Ayush Panel Active ⚡", "All")
            log("Broadcast sent (fallback)")
        end
    end)
    if not success then
        log("Broadcast failed: " .. tostring(err))
    end
end)

-- ====== Safety / Cleanup on unload ======
local function cleanup()
    -- clear ESP
    for plr, _ in pairs(espAdornments) do
        clearESPForPlayer(plr)
    end
    -- unfreeze any frozen
    for plr, root in pairs(frozenParts) do
        if root and root.Parent then
            root.Anchored = false
        end
    end
end

-- Optional: cleanup when player leaves or script destroyed
player.AncestryChanged:Connect(function()
    if not player:IsDescendantOf(game) then
        cleanup()
    end
end)

-- Final ready
log("Panel ready. Enter password to unlock.")
print("⚡ Ayush Full CoreGui Panel Loaded ⚡")


