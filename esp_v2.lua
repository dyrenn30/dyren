
--===[ LT2 SUPREME COMBO SCRIPT v3 | By ChatGPT x Dyrenn ]===--
-- Features: ESP Player, Teleport GUI, WalkSpeed Slider, Fly Toggle

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 350)
MainFrame.Position = UDim2.new(0, 10, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "LT2 Supreme Cheat GUI"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

-- ESP
local function createESP(player)
    if player == LocalPlayer then return end
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
for _, player in pairs(Players:GetPlayers()) do createESP(player) end
Players.PlayerAdded:Connect(createESP)

-- Teleport Buttons
local y = 40
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        local btn = Instance.new("TextButton", MainFrame)
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.Position = UDim2.new(0, 0, 0, y)
        btn.Text = "TP to " .. plr.Name
        btn.TextColor3 = Color3.new(1,1,1)
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 16
        btn.MouseButton1Click:Connect(function()
            local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            local myhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and myhrp then
                myhrp.CFrame = hrp.CFrame + Vector3.new(0, 5, 0)
            end
        end)
        y = y + 32
    end
end

-- WalkSpeed Control
local walkspeed = 16
local wsBtn = Instance.new("TextButton", MainFrame)
wsBtn.Size = UDim2.new(1, 0, 0, 30)
wsBtn.Position = UDim2.new(0, 0, 0, y + 10)
wsBtn.Text = "WalkSpeed: 16 (+/-)"
wsBtn.TextColor3 = Color3.new(1,1,1)
wsBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
wsBtn.Font = Enum.Font.SourceSans
wsBtn.TextSize = 16
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = walkspeed
    end
end)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Equals then
        walkspeed = walkspeed + 2
        wsBtn.Text = "WalkSpeed: "..walkspeed.." (+/-)"
    elseif input.KeyCode == Enum.KeyCode.Minus then
        walkspeed = math.max(2, walkspeed - 2)
        wsBtn.Text = "WalkSpeed: "..walkspeed.." (+/-)"
    end
end)

-- Fly Toggle (F key)
local flying = false
local flyVel = nil
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F then
        flying = not flying
        if flying then
            flyVel = Instance.new("BodyVelocity")
            flyVel.Velocity = Vector3.new(0, 0, 0)
            flyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            flyVel.Parent = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        else
            if flyVel then flyVel:Destroy() end
        end
    end
end)
RunService.RenderStepped:Connect(function()
    if flying and flyVel then
        local cam = workspace.CurrentCamera.CFrame
        flyVel.Velocity = cam.LookVector * walkspeed + Vector3.new(0, UserInputService:IsKeyDown(Enum.KeyCode.Space) and walkspeed or 0, 0)
    end
end)
