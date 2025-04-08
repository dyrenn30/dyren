
--===[ LT2 SUPREME COMBO SCRIPT v3 | AutoFarm + Dupe + Sell ]===--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 360)
frame.Position = UDim2.new(0, 10, 0.5, -180)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", frame)

local function createLabel(txt, y)
    local l = Instance.new("TextLabel", frame)
    l.Size = UDim2.new(1, 0, 0, 30)
    l.Position = UDim2.new(0, 0, 0, y)
    l.Text = txt
    l.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    l.TextColor3 = Color3.new(1,1,1)
    l.Font = Enum.Font.SourceSansBold
    l.TextSize = 16
end

createLabel("LT2 Supreme v3", 0)

-- ESP Player
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        local esp = Drawing.new("Text")
        esp.Visible = false
        esp.Center = true
        esp.Outline = true
        esp.Font = 2
        esp.Size = 13
        esp.Color = Color3.fromRGB(255, 0, 0)
        esp.Text = player.Name
        RunService.RenderStepped:Connect(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                esp.Position = Vector2.new(pos.X, pos.Y)
                esp.Visible = onScreen
            else
                esp.Visible = false
            end
        end)
    end
end

-- Auto Farm Trees
local autofarm = false
local function startAutoFarm()
    autofarm = not autofarm
    while autofarm do
        for _, tree in pairs(workspace:GetChildren()) do
            if tree.Name:lower():find("tree") and tree:FindFirstChild("WoodSection") then
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = tree.WoodSection.CFrame + Vector3.new(0,3,0)
                    wait(0.5)
                end
            end
        end
        wait(1)
    end
end

local farmBtn = Instance.new("TextButton", frame)
farmBtn.Size = UDim2.new(1, 0, 0, 30)
farmBtn.Position = UDim2.new(0, 0, 0, 40)
farmBtn.Text = "AutoFarm Tree (Toggle)"
farmBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
farmBtn.TextColor3 = Color3.new(1,1,1)
farmBtn.Font = Enum.Font.SourceSans
farmBtn.TextSize = 16
farmBtn.MouseButton1Click:Connect(startAutoFarm)

-- Auto Sell Wood
local autosell = false
local function startAutoSell()
    autosell = not autosell
    while autosell do
        for _, wood in pairs(workspace:GetChildren()) do
            if wood.Name == "WoodSection" and wood:IsA("Part") then
                wood.CFrame = CFrame.new(-126, 3, 113) -- default drop-off zone
                wait(0.2)
            end
        end
        wait(1)
    end
end

local sellBtn = Instance.new("TextButton", frame)
sellBtn.Size = UDim2.new(1, 0, 0, 30)
sellBtn.Position = UDim2.new(0, 0, 0, 75)
sellBtn.Text = "AutoSell Wood (Toggle)"
sellBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sellBtn.TextColor3 = Color3.new(1,1,1)
sellBtn.Font = Enum.Font.SourceSans
sellBtn.TextSize = 16
sellBtn.MouseButton1Click:Connect(startAutoSell)

-- Dupe Item (drop fast method)
local function dupeItem()
    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
        item.Parent = LocalPlayer.Character
        wait(0.05)
        item.Parent = LocalPlayer.Backpack
    end
end

local dupeBtn = Instance.new("TextButton", frame)
dupeBtn.Size = UDim2.new(1, 0, 0, 30)
dupeBtn.Position = UDim2.new(0, 0, 0, 110)
dupeBtn.Text = "Dupe Item (Backpack)"
dupeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
dupeBtn.TextColor3 = Color3.new(1,1,1)
dupeBtn.Font = Enum.Font.SourceSans
dupeBtn.TextSize = 16
dupeBtn.MouseButton1Click:Connect(dupeItem)
