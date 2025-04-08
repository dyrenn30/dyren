-- Loadstring ready version
-- Save as: esp_v2.lua (biar konsisten sama script lo sebelumnya)
-- Fiturnya: Auto Fish, ESP, Teleport ke spot, Auto Sell

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name = "Fish Hub 🐟", HidePremium = false, SaveConfig = true, ConfigFolder = "FishHub"})

local Player = game.Players.LocalPlayer
local char = Player.Character or Player.CharacterAdded:Wait()

-- ESP
function AddESP(target)
    local box = Instance.new("BoxHandleAdornment", target)
    box.Size = target.Size
    box.Adornee = target
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Color3 = Color3.fromRGB(0, 255, 255)
    box.Transparency = 0.5
end

for _,v in pairs(workspace:GetDescendants()) do
    if v:IsA("MeshPart") and v.Name == "Fish" then
        AddESP(v)
    end
end

-- Tabs
local MainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local AutoTab = Window:MakeTab({Name = "Auto", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local TeleportTab = Window:MakeTab({Name = "Teleport", Icon = "rbxassetid://4483345998", PremiumOnly = false})

-- Auto Fish
getgenv().autoFish = false
function doAutoFish()
    while getgenv().autoFish do
        -- Simulasi klik tombol fishing (customize sesuai game)
        fireclickdetector(workspace.FishingSpot.ClickDetector)
        wait(2)
    end
end

AutoTab:AddToggle({
    Name = "Auto Fish",
    Default = false,
    Callback = function(state)
        getgenv().autoFish = state
        if state then
            doAutoFish()
        end
    end
})

-- Auto Sell
getgenv().autoSell = false
function doAutoSell()
    while getgenv().autoSell do
        firetouchinterest(char.HumanoidRootPart, workspace.SellSpot, 0)
        wait(3)
    end
end

AutoTab:AddToggle({
    Name = "Auto Sell",
    Default = false,
    Callback = function(state)
        getgenv().autoSell = state
        if state then
            doAutoSell()
        end
    end
})

-- Teleport
TeleportTab:AddButton({
    Name = "Teleport ke Spot Fishing",
    Callback = function()
        char:MoveTo(workspace.FishingSpot.Position)
    end
})

TeleportTab:AddButton({
    Name = "Teleport ke Sell Spot",
    Callback = function()
        char:MoveTo(workspace.SellSpot.Position)
    end
})

-- Init
OrionLib:Init()
