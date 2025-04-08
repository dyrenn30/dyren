-- Fisch Hub - One File Script
-- Made for Fisch Roblox Game
-- Features: Auto Fish, Auto Sell, Teleport, ESP, GUI

-- Load GUI Library (Speed Hub style)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SpeedSterKawaii/UI-Libraries/main/Speed%20Hub/Library.lua"))()
local Window = Library:CreateWindow("Fisch Hub")

-- Tabs
local FarmingTab = Window:CreateTab("Farming")
local TeleportTab = Window:CreateTab("Teleport")
local VisualTab = Window:CreateTab("ESP")

-- Variables
local autofish = false
local autosell = false

-- Auto Fish Toggle
FarmingTab:CreateToggle("Auto Fish", false, function(state)
    autofish = state
end)

-- Auto Sell Toggle
FarmingTab:CreateToggle("Auto Sell", false, function(state)
    autosell = state
end)

-- Main Loop
spawn(function()
    while task.wait(1) do
        if autofish then
            local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Fish") then
                fireclickdetector(tool.Fish.ClickDetector)
            end
        end

        if autosell then
            local sellPart = workspace:FindFirstChild("SellZone") or workspace:FindFirstChild("Sell")
            if sellPart then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = sellPart.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end
end)

-- Teleport Buttons (example spots)
TeleportTab:CreateButton("To Fishing Spot", function()
    local spot = workspace:FindFirstChild("FishingSpot")
    if spot then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = spot.CFrame + Vector3.new(0, 3, 0)
    end
end)

TeleportTab:CreateButton("To Sell Area", function()
    local sell = workspace:FindFirstChild("SellZone")
    if sell then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = sell.CFrame + Vector3.new(0, 3, 0)
    end
end)

-- Simple ESP (shows players)
VisualTab:CreateButton("Enable ESP", function()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local highlight = Instance.new("Highlight")
            highlight.Adornee = player.Character
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.Parent = player.Character
        end
    end
end)

-- GUI Init Message
print("[Fisch Hub] Loaded!")
