local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ESPFolder = Instance.new("Folder", game.CoreGui)
ESPFolder.Name = "ESPFolder"

function createESP(player)
    if player == Players.LocalPlayer then return end
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
            if onScreen then
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

for _, player in pairs(Players:GetPlayers()) do
    createESP(player)
end

Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)
