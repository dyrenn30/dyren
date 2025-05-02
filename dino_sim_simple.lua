-- Load Linoria UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
local Window = Library:CreateWindow({Title = "DinoSim Hub", Center = true, AutoShow = true})

local Tabs = {
    Main = Window:AddTab("Main"),
    Player = Window:AddTab("Player"),
    Misc = Window:AddTab("Misc")
}

-- ESP
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

-- Auto Heal
local function autoHeal()
    while _G.AutoHeal do
        local player = game.Players.LocalPlayer
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            if char.Humanoid.Health < 80 then
                char.Humanoid.Health = char.Humanoid.Health + 5
            end
        end
        wait(1)
    end
end

-- Fly
local flying = false
local function toggleFly()
    local plr = game.Players.LocalPlayer
    local char = plr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not flying then
        flying = true
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(999999, 999999, 999999)
        while flying do
            bv.Velocity = plr:GetMouse().Hit.lookVector * 100
            wait()
        end
        bv:Destroy()
    else
        flying = false
    end
end

-- GUI Toggles
Tabs.Main:AddButton({Text = "Enable ESP", Callback = enableESP})

Tabs.Main:AddToggle("AutoHeal", {Text = "Auto Heal", Default = false}):OnChanged(function(val)
    _G.AutoHeal = val
    if val then
        autoHeal()
    end
end)

Tabs.Player:AddSlider("WalkSpeed", {
    Text = "Walk Speed",
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 0,
    Compact = false,
}):OnChanged(function(val)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
end)

Tabs.Player:AddButton({Text = "Toggle Fly", Callback = toggleFly})

Tabs.Misc:AddButton({Text = "Destroy GUI", Callback = function()
    Library:Unload()
end})
