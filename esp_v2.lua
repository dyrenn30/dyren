-- // LT2 Ultimate Hub - esp_v2.lua Rework //
-- Full GUI: ESP, Fly, WalkSpeed, Dupe, AutoChop

-- Dependencies
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
local Window = Library:CreateWindow({
    Title = "LT2 Ultimate Hub",
    Center = true,
    AutoShow = true,
})

-- Tabs
local MainTab = Window:AddTab("Main")
local ESPTab = Window:AddTab("ESP")
local MiscTab = Window:AddTab("Misc")
local SettingsTab = Window:AddTab("Settings")

-- // Fly Feature
local flying = false
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local flySpeed = 50

MainTab:AddButton("Toggle Fly (F)", function()
    flying = not flying
end)

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        flying = not flying
    end
end)

RunService.RenderStepped:Connect(function()
    if flying and hrp then
        hrp.Velocity = Vector3.new(0, flySpeed, 0)
    end
end)

-- // ESP Feature
shared.espEnabled = true

function createESP(player)
    if player == plr then return end
    local esp = Drawing.new("Text")
    esp.Size = 16
    esp.Center = true
    esp.Outline = true
    esp.Color = Color3.fromRGB(0, 255, 0)
    esp.Visible = false

    RunService.RenderStepped:Connect(function()
        if shared.espEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onscreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onscreen then
                esp.Position = Vector2.new(pos.X, pos.Y)
                esp.Text = player.Name
                esp.Visible = true
            else
                esp.Visible = false
            end
        else
            esp.Visible = false
        end
    end)
end

for _, p in pairs(game.Players:GetPlayers()) do
    createESP(p)
end

game.Players.PlayerAdded:Connect(createESP)

ESPTab:AddToggle("Enable Player ESP", {Default = true}, function(val)
    shared.espEnabled = val
end)

-- // Misc: WalkSpeed & AutoChop
MiscTab:AddSlider("WalkSpeed", {Min = 16, Max = 100, Default = 16}, function(val)
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.WalkSpeed = val
    end
end)

MiscTab:AddButton("Auto Chop Nearest Tree", function()
    local function getNearestTree()
        local closest, dist = nil, math.huge
        for _, v in pairs(workspace:GetChildren()) do
            if v:FindFirstChild("TreeClass") and v:FindFirstChild("WoodSection") then
                local d = (v.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = v
                end
            end
        end
        return closest
    end

    local tree = getNearestTree()
    if tree then
        for i = 1, 10 do
            game.ReplicatedStorage.Interaction:FireServer("Chop", tree.WoodSection)
            task.wait(0.2)
        end
    end
end)

-- // Settings: Dupe
SettingsTab:AddButton("Dupe Slot 1", function()
    game.ReplicatedStorage.LoadSaveRequests.RequestLoad:InvokeServer("Slot1")
    task.wait(1.5)
    game.ReplicatedStorage.LoadSaveRequests.RemoveSave:InvokeServer("Slot1")
end)

Library:Notify("Loaded LT2 Ultimate Hub v2!", 5)
