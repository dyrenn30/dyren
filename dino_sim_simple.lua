-- Load Linoria UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/linoriateam/main/Library.lua"))()
local Window = Library:CreateWindow({Title = "DinoSim Hub", Center = true, AutoShow = true})

local Tabs = {
    Main = Window:AddTab("Main"),
    Player = Window:AddTab("Player"),
    Misc = Window:AddTab("Misc")
}

-- ESP simple
local function enableESP()
    for _, dino in pairs(game:GetService("Workspace"):GetDescendants()) do
        if dino:IsA("Model") and dino:FindFirstChild("HumanoidRootPart") and not dino:FindFirstChild("ESPBox") then
            local box = Instance.new("BoxHandleAdornment", dino)
            box.Name = "ESPBox"
            box.Adornee = dino
            box.Size = Vector3.new(5,5,5)
            box.Color3 = Color3.fromRGB(0,255,0)
            box.AlwaysOnTop = true
            box.ZIndex = 5
            box.Transparency = 0.5
        end
    end
end

-- Walkspeed changer
local function setSpeed(val)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = val
    end
end

-- Fly toggle (super basic)
local flying = false
local function toggleFly()
    flying = not flying
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    if flying then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyForce"
        bv.Velocity = Vector3.new(0, 50, 0)
        bv.MaxForce = Vector3.new(0, math.huge, 0)
        bv.Parent = root
    else
        if root:FindFirstChild("FlyForce") then
            root:FindFirstChild("FlyForce"):Destroy()
        end
    end
end

-- GUI buttons
Tabs.Main:AddButton("Enable ESP", enableESP)
Tabs.Player:AddSlider("WalkSpeed", {
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = setSpeed
})
Tabs.Player:AddToggle("Fly Toggle", {Default = false, Callback = function(val) toggleFly() end})
Tabs.Misc:AddButton("Destroy UI", function() Library:Unload() end)
