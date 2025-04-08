-- File: esp_v2.lua - Full LT2 GUI + Cheats
-- By: dyren

-- GUI Library (Linoria Style)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
    Title = 'LT2 Ultimate Hub',
    Center = true,
    AutoShow = true
})

local Tabs = {
    Main = Window:AddTab('Main'),
    ESP = Window:AddTab('ESP'),
    Misc = Window:AddTab('Misc'),
    Settings = Window:AddTab('Settings')
}

-- Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local ESPEnabled = false

-- ESP Feature
Tabs.ESP:AddToggle('ToggleESP', {
    Text = 'Enable Player ESP',
    Default = false,
    Callback = function(v)
        ESPEnabled = v
    end
})

local function createESP(player)
    if player == LocalPlayer then return end
    local espText = Drawing.new("Text")
    espText.Visible = false
    espText.Center = true
    espText.Outline = true
    espText.Font = 2
    espText.Size = 13
    espText.Color = Color3.fromRGB(255, 0, 0)
    espText.Text = player.Name

    RunService.RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen and ESPEnabled then
                espText.Position = Vector2.new(pos.X, pos.Y)
                espText.Visible = true
            else
                espText.Visible = false
            end
        else
            espText.Visible = false
        end
    end)
end

for _, p in ipairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)

-- Movement: WalkSpeed & Fly
Tabs.Main:AddSlider('WalkSpeedSlider', {
    Text = 'Walk Speed',
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 0,
    Callback = function(v)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    end
})

Tabs.Main:AddToggle('ToggleFly', {
    Text = 'Enable Fly (press F)',
    Default = false,
    Callback = function(v)
        getgenv().fly = v
        if v then loadstring(game:HttpGet("https://pastebin.com/raw/KxvY5Cxa"))() end
    end
})

-- Dupe Item
Tabs.Misc:AddButton('Dupe Item (Slot 1)', function()
    local rs = game:GetService("ReplicatedStorage")
    rs.LoadSaveRequests.RequestSave:InvokeServer("Slot1", false)
    wait(0.5)
    rs.LoadSaveRequests.RequestLoad:InvokeServer("Slot1")
end)

-- AutoFarm & Sell
Tabs.Misc:AddButton('Auto Chop Nearest Tree', function()
    for _, tree in pairs(workspace:GetDescendants()) do
        if tree.Name == "TreeRegion" and tree:FindFirstChild("TreeClass") then
            LocalPlayer.Character:MoveTo(tree.Position)
            wait(0.5)
            game:GetService("ReplicatedStorage").Chop:InvokeServer(tree)
            break
        end
    end
end)

Tabs.Misc:AddButton('Auto Sell All Wood', function()
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("Tool") or item.Name:lower():find("wood") then
            item.CFrame = CFrame.new(-15, 3, -142)
        end
    end
end)

-- Theme & Save
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

Library:Notify("LT2 GUI Loaded. Enjoy!")
