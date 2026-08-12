-- AYUSH_SCRIPT.lua
-- Wrapper: one-time session password "AYUSHDAD" (case-insensitive)
-- Paste the full original Nameless Admin script below the marker.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
if not player then return end

-- One-time unlock flag stored on the Player for this session
local unlockFlag = player:FindFirstChild("AyushScriptUnlocked")
if not unlockFlag then
    unlockFlag = Instance.new("BoolValue")
    unlockFlag.Name = "AyushScriptUnlocked"
    unlockFlag.Value = false
    unlockFlag.Parent = player
end

-- If already unlocked this session, skip password UI and run script immediately
local function run_original_script()
    -- ======= ORIGINAL SCRIPT START =======
    -- PASTE ORIGINAL SCRIPT HERE (entire Nameless Admin code)
    -- ======= ORIGINAL SCRIPT END =======
end

-- If unlocked already, run and return
if unlockFlag.Value then
    run_original_script()
    return
end

-- Create a simple CoreGui password prompt (blocks original script until correct)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AyushScriptPasswordUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0,360,0,160)
frame.Position = UDim2.new(0.5,-180,0.4,-80)
frame.BackgroundColor3 = Color3.fromRGB(12,12,12)
frame.BorderColor3 = Color3.fromRGB(0,200,0)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundColor3 = Color3.fromRGB(18,18,18)
title.TextColor3 = Color3.fromRGB(0,255,0)
title.TextScaled = true
title.Text = "AYUSH SCRIPT - Enter Password"

local passBox = Instance.new("TextBox", frame)
passBox.Size = UDim2.new(1,-20,0,40)
passBox.Position = UDim2.new(0,10,0,50)
passBox.PlaceholderText = "Password..."
passBox.Text = ""
passBox.TextColor3 = Color3.fromRGB(0,255,0)
passBox.BackgroundColor3 = Color3.fromRGB(10,10,10)
passBox.ClearTextOnFocus = false

local submitBtn = Instance.new("TextButton", frame)
submitBtn.Size = UDim2.new(0.5,0,0,36)
submitBtn.Position = UDim2.new(0.25,0,0,105)
submitBtn.Text = "Unlock"
submitBtn.TextColor3 = Color3.fromRGB(0,255,0)
submitBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)

local function cleanUI()
    if screenGui and screenGui.Parent then
        screenGui:Destroy()
    end
end

submitBtn.MouseButton1Click:Connect(function()
    local entered = tostring(passBox.Text or "")
    if string.lower(entered) == "ayushdad" then
        unlockFlag.Value = true
        cleanUI()
        -- run the original script now that password is correct
        pcall(run_original_script)
    else
        passBox.Text = ""
        passBox.PlaceholderText = "Wrong Password!"
    end
end)

-- Optional: allow pressing Enter to submit
passBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        submitBtn:CaptureFocus()
        submitBtn.MouseButton1Click:Wait()
    end
end)
