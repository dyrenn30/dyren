# Rewriting esp_v2.lua by adding auto farm + auto sell + auto equip + auto cut tree
esp_v2_updated = """
--===[ LT2 ESP v2 EXTENDED | AUTO FARM + AUTO SELL ]===--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 400)
frame.Position = UDim2.new(0, 10, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", frame)

local function makeButton(text, yPos, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.MouseButton1Click:Connect(callback)
end

-- ESP Players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        local esp = Drawing.new("Text")
        esp.Visible = false
        esp.Center = true
        esp.Outline = true
        esp.Font = 2
        esp.Size = 13
        esp.Color = Color3.fromRGB(0, 255, 0)
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

-- === AUTO FARM SYSTEM ===
local autofarm = false
local axeName = "BasicHatchet" -- bisa lo ganti kalo axe-nya beda
local function getAxe()
    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        if tool.Name:find("Axe") or tool.Name:find("Hatchet") then
            return tool
        end
    end
    return nil
end

local function equipAxe()
    local axe = getAxe()
    if axe then
        axe.Parent = LocalPlayer.Character
    end
end

local function hitTree(section)
    local args = {
        [1] = section,
        [2] = section.Position,
        [3] = 1,
        [4] = getAxe()
    }
    game.ReplicatedStorage.Interaction.RemoteProxy:FireServer(unpack(args))
end

local function startFarm()
    autofarm = not autofarm
    while autofarm do
        equipAxe()
        for _, tree in pairs(workspace:GetChildren()) do
            if tree.Name:lower():find("tree") and tree:FindFirstChild("WoodSection") then
                local sec = tree:FindFirstChild("WoodSection")
                if sec then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = sec.CFrame + Vector3.new(0,3,0)
                    for i=1,10 do
                        hitTree(sec)
                        wait(0.2)
                    end
                end
            end
        end
        wait(1)
    end
end

makeButton("AutoFarm Tree (Full AFK)", 40, startFarm)

-- === AUTO SELL SYSTEM ===
local autosell = false
local function sellWood()
    autosell = not autosell
    while autosell do
        for _, wood in pairs(workspace:GetChildren()) do
            if wood.Name == "WoodSection" and wood:IsA("Part") then
                wood.CFrame = CFrame.new(-126, 3, 113) -- drop-off pos
                wait(0.1)
            end
        end
        wait(1)
    end
end

makeButton("AutoSell Wood", 80, sellWood)

-- === DUPLICATE ITEM ===
local function dupe()
    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
        item.Parent = LocalPlayer.Character
        wait(0.05)
        item.Parent = LocalPlayer.Backpack
    end
end

makeButton("Dupe Items (Backpack)", 120, dupe)

-- === WALK SPEED ===
local wsToggled = false
local function toggleSpeed()
    wsToggled = not wsToggled
    if wsToggled then
        LocalPlayer.Character.Humanoid.WalkSpeed = 75
    else
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end

makeButton("Toggle Speed (75)", 160, toggleSpeed)

-- === FLY ===
local flying = false
local function fly()
    flying = not flying
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0,0,0)
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    bv.Parent = root

    RunService.RenderStepped:Connect(function()
        if flying then
            bv.Velocity = Vector3.new(0, 50, 0)
        else
            bv:Destroy()
        end
    end)
end

makeButton("Toggle Fly", 200, fly)
"""

# Save the updated script
file_path_espv2 = "/mnt/data/esp_v2.lua"
with open(file_path_espv2, "w") as f:
    f.write(esp_v2_updated)

file_path_espv2
