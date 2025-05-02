-- Load Rayfield
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Window = Rayfield:CreateWindow({
   Name = "DinoSim Hub",
   LoadingTitle = "DinoSim Loader",
   LoadingSubtitle = "by dyrenn30",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

-- TABs
local MainTab = Window:CreateTab("Main", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- ESP FUNCTION
local function enableESP()
   for _, dino in pairs(game:GetService("Workspace"):GetDescendants()) do
       if dino:IsA("Model") and dino:FindFirstChild("HumanoidRootPart") and not dino:FindFirstChild("ESPBox") then
           local box = Instance.new("BoxHandleAdornment", dino)
           box.Name = "ESPBox"
           box.Adornee = dino
           box.Size = Vector3.new(5,5,5)
           box.Color3 = Color3.fromRGB(255,0,0)
           box.AlwaysOnTop = true
           box.ZIndex = 5
           box.Transparency = 0.5
       end
   end
end

-- FLY FUNCTION
local flying = false
local function toggleFly(state)
   local char = game.Players.LocalPlayer.Character
   if not char then return end
   local root = char:FindFirstChild("HumanoidRootPart")
   if not root then return end

   flying = state
   if flying then
       local bv = Instance.new("BodyVelocity")
       bv.Name = "FlyForce"
       bv.Velocity = Vector3.new(0, 50, 0)
       bv.MaxForce = Vector3.new(0, math.huge, 0)
       bv.Parent = root
   else
       if root:FindFirstChild("FlyForce") then
           root.FlyForce:Destroy()
       end
   end
end

-- SPEED FUNCTION
local function setSpeed(val)
   local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
   if hum then
       hum.WalkSpeed = val
   end
end

-- GUI BUTTONS
MainTab:CreateButton({
   Name = "Enable ESP",
   Callback = enableESP
})

PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 150},
   Increment = 1,
   Default = 16,
   Callback = setSpeed
})

PlayerTab:CreateToggle({
   Name = "Fly Mode",
   CurrentValue = false,
   Callback = toggleFly
})

MiscTab:CreateButton({
   Name = "Destroy UI",
   Callback = function()
       Rayfield:Destroy()
   end
})
