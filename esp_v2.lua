--===[ ESP Player Script ]===--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESPFolder = Instance.new("Folder", game.CoreGui)
ESPFolder.Name = "ESPFolder"

function createESP(player)
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

Players.PlayerAdded:Connect(createESP)

--===[ Teleport GUI Script ]===--
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
local title = Instance.new("TextLabel", frame)

frame.Size = UDim2.new(0, 200, 0, 300)
frame.Position = UDim2.new(0, 10, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Teleport to Player"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local function updatePlayerList()
    for _, child in pairs(frame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local y = 35
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local btn = Instance.new("TextButton", frame)
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Position = UDim2.new(0, 0, 0, y)
            btn.Text = plr.Name
            btn.TextColor3 = Color3.new(1,1,1)
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.BorderSizePixel = 0
            btn.Font = Enum.Font.SourceSans
            btn.TextSize = 16

            btn.MouseButton1Click:Connect(function()
                local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                local myChar = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp and myChar then
                    myChar.CFrame = hrp.CFrame + Vector3.new(0, 5, 0)
                end
            end)

            y = y + 35
        end
    end
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()
