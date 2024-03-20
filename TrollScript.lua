local plr = game.Players.LocalPlayer
local char = plr.Character
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local ts = game:GetService("TweenService")
local balls = game.Workspace:WaitForChild("Balls"):GetChildren()
local aliveplrs = game.Workspace:WaitForChild("Alive")
local vim = game:GetService("VirtualInputManager")
local hit = game.ReplicatedStorage.Remotes.ParryAttempt
local Camera = workspace:WaitForChild("CurrentCamera")
local dist = 7.5
local ballspeed = 12.5
local plrballdist = 0
local randball
local rot = 0
local rad = math.rad
local clamp = math.clamp
local SpamEnabled = false
local tweentime = game:GetService("RunService").Heartbeat:Wait()
local Info = TweenInfo.new(tweentime/4.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local NEVERLOSE = loadstring(game:HttpGet("https://raw.githubusercontent.com/3345-c-a-t-s-u-s/NEVERLOSE-UI-Nightly/main/source.lua"))()
+fgfgfgfgfgfgfgfg
NEVERLOSE:Theme("Dark")

local data = {
	AutoParryEnabled = true,
	VisualiserEnabled = false,
	TrollEnabled = false,
	TrollDistanceFactor = 0.2
}

local window = NEVERLOSE:AddWindow("ZBOY HUB", "BLADE BALL - NEXT GENERATION")

local Main = window:AddTab("Main","earth")
local Creds = window:AddTab("Credits", "list")

local Combat = Main:AddSection("COMBAT", "left")
local Trolls = Main:AddSection("TROLLS", "right")
local Player = Main:AddSection("PLAYER", "left")
--local PlayerList = Trolls:AddDropdown("Players", game.Players:GetPlayers(),game.Players.LocalPlayer)

Combat:AddToggle("Auto Parry",true,function(val)
	data.AutoParryEnabled=val
end)
Combat:AddToggle("Visualiser",false,function(val)
	data.VisualiserEnabled=val
end)

Trolls:AddToggle("Troll Enabled",false,function(val)
	data.TrollEnabled=val
end)

--[[Trolls:AddToggle("Follow Player",false,function(a)
	print(a)
end)]]

--[[Trolls:AddButton("Update Players",function(a)
	PlayerList:Refresh()
	print("Updated Player List")
end)]]

Trolls:AddToggle("Low Gravity",false,function(a)
	if hum then
		hum.UseJumpPower=true
	end
	if a then
		workspace.Gravity=50
	else
		workspace.Gravity=196.2
	end
end)

Trolls:AddSlider("Troll Distance Factor",0,100,20,function(distance)
	data.TrollDistanceFactor=distance/100
end)

Player:AddSlider("Speed",36,250,36,function(a)
	if hum then
		hum.WalkSpeed=a
	end
end)
Player:AddSlider("JumpPower",50,250,50,function(a)
	if hum then
		hum.UseJumpPower=true
		hum.JumpPower=a
	end
end)

local CredsSec = Creds:AddSection("CREDITS")

CredsSec:AddLabel("CREDITS TO")
CredsSec:AddLabel("3345-c-a-t-s-u-s")
CredsSec:AddLabel("FOR THE IDEA")
CredsSec:AddLabel("AND THE UI")

local indicatorPart = Instance.new("Part")
indicatorPart.Size = Vector3.new(ballspeed, ballspeed, ballspeed)
indicatorPart.Anchored = true
indicatorPart.CanCollide = false
indicatorPart.Transparency = 0
indicatorPart.Color = Color3.fromRGB(255,255,255)
indicatorPart.Material = Enum.Material.ForceField
indicatorPart.Shape=Enum.PartType.Ball
indicatorPart.Parent = workspace

game.Workspace:WaitForChild("Balls").ChildAdded:Connect(function()
    start()
end)

function GetLocalSize()
	return Vector3.new(ballspeed*0.6,ballspeed*0.6,ballspeed*0.6)*(1+plr:GetNetworkPing())
end

function GetPoint()
	return Camera:WorldToScreenPoint(hrp.Position)
end

function UpdateIndicator()
    if randball:GetAttribute("target")==plr.Name and randball:GetAttribute("realBall") then
        indicatorPart.Color=Color3.FromRGB(255,125,125)
    elseif plrballdist<=ballspeed*0.6 and randball:GetAttribute("target")==plr.Name then
        indicatorPart.Color=Color3.FromRGB(125,255,125)
    else
        indicatorPart.Color=Color3.FromRGB(255,255,255)
    end
    if hrp then
        indicatorPart.CFrame=CFrame.new(hrp.Position)
    end
	if data.VisualiserEnabled then
		indicatorPart.Transparency=0
	else
		indicatorPart.Transparency=1
	end
    indicatorPart.Size=GetLocalSize()
end

function TryParry()
     if plrballdist*(1+plr:GetNetworkPing())<=ballspeed*0.6 and randball:GetAttribute("target")==plr.Name and data.AutoParryEnabled then
         local point = GetPoint()
         hit:FireServer(0.6, CFrame.new(),{},{point.X,point.Y})
     end
end

function LaunchItems()
	TryParry()
	UpdateIndicator()
	if SpamEnabled then
		TryParry()
	end
end

game:GetService("RunService").RenderStepped:Connect(LaunchItems)
game:GetService("RunService").Heartbeat:Connect(LaunchItems)
randball.Changed:Connect(LaunchItems)

function start()
    while task.wait(tweentime) do
        char = game.Players.LocalPlayer.Character
        hrp = char:WaitForChild("HumanoidRootPart")
		hum = char:WaitForChild("Humanoid")
        balls = game.Workspace:WaitForChild("Balls"):GetChildren()
        if #balls > 0 and aliveplrs:FindFirstChild(plr.Name) then
            randball = balls[math.random(1,#balls)]
            if randball and hrp then
                local r = rad(rot)
                local newcframe = randball.CFrame*CFrame.Angles(0,r,0)*CFrame.new(0,0,dist)
                if randball:GetAttribute("target")==plr.Name then
                    dist = clamp(dist*0.95, 6, math.huge)
                else
                    dist = clamp((randball.Velocity.Magnitude*data.TrollDistanceFactor)/0.95, 6, randball.Velocity.Magnitude*data.TrollDistanceFactor)
                end
                    
                plrballdist = (hrp.Position - randball.Position).Magnitude
                ballspeed = clamp(randball.Velocity.Magnitude,6,math.huge)
                rot=math.random(-180,180)
                
                if data.TrollEnabled then
                    hrp.AssemblyLinearVelocity=Vector3.zero
                    ts:Create(hrp, Info, {CFrame = newcframe}):Play()
                end
            end
        end
    end
end
start()