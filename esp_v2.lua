-- esp_v2.lua - Ultimate LT2 Script
-- by dyren

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Window = OrionLib:MakeWindow({
    Name = "LT2 Hack Menu",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "lt2hub"
})

-- ESP Section
local ESPTab = Window:MakeTab({Name = "ESP", Icon = "👁️", PremiumOnly = false})
local ESPEnabled = false

local function createESP(player)
    if player == LocalPlayer then return end
    local espBox = Drawing.new("Text")
    espBox.Visible = false
    espBox.Center = true
    espBox.Outline = true
    espBox.Font = 2
    espBox.Size = 13
    espBox.Color = Color3.fromRGB(255, 0, 0)
    espBox.Text = player.Name

    RunService.RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen and ESPEnabled then
                espBox.Position = Vector2.new(pos.X, pos.Y)
                espBox.Visible = true
            else
                espBox.Visible = false
            end
        else
            espBox.Visible = false
        end
    end)
end

for _, p in ipairs(Players:GetPlayers()) do
    createESP(p)
end
Players.PlayerAdded:Connect(createESP)

ESPTab:AddToggle({
    Name = "Enable ESP",
    Default = false,
    Callback = function(Value)
        ESPEnabled = Value
    end
})

-- Movement Section
local MoveTab = Window:MakeTab({Name = "Movement", Icon = "🏃", PremiumOnly = false})

local FlyEnabled = false
local FlySpeed = 2
MoveTab:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(Value)
        FlyEnabled = Value
        local hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "FlyVelocity"
        bv.Velocity = Vector3.zero
        bv.MaxForce = Vector3.new(100000, 100000, 100000)

        RunService.RenderStepped:Connect(function()
            if FlyEnabled then
                local moveVec = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + workspace.CurrentCamera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - workspace.CurrentCamera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec = moveVec + Vector3.new(0, 1, 0) end
                bv.Velocity = moveVec * FlySpeed * 10
            else
                bv.Velocity = Vector3.zero
            end
        end)
    end
})

MoveTab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Color = Color3.fromRGB(255, 125, 0),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

-- Dupe Section
local DupeTab = Window:MakeTab({Name = "Dupe", Icon = "♻️", PremiumOnly = false})
DupeTab:AddButton({
    Name = "Dupe Selected Slot",
    Callback = function()
        game:GetService("ReplicatedStorage").LoadSaveRequests.RequestSave:InvokeServer("Slot1", false)
        wait(0.5)
        game:GetService("ReplicatedStorage").LoadSaveRequests.RequestLoad:InvokeServer("Slot1")
    end
})

-- AutoFarm Section
local FarmTab = Window:MakeTab({Name = "AutoFarm", Icon = "🌲", PremiumOnly = false})
FarmTab:AddButton({
    Name = "Auto Chop Nearest Tree",
    Callback = function()
        for _, tree in pairs(workspace:GetDescendants()) do
            if tree.Name == "TreeRegion" and tree:FindFirstChild("TreeClass") then
                LocalPlayer.Character:MoveTo(tree.Position)
                wait(0.5)
                game:GetService("ReplicatedStorage").Chop:InvokeServer(tree)
                break
            end
        end
    end
})

FarmTab:AddButton({
    Name = "Auto Sell All Trees",
    Callback = function()
        for _, item in pairs(workspace:GetDescendants()) do
            if item:IsA("Tool") or item.Name:lower():find("wood") then
                item.CFrame = CFrame.new(-15, 3, -142) -- Drop-off location
            end
        end
    end
})

OrionLib:Init()
