local plr = game.Players.LocalPlayer
local char = plr.Character
local hrp = char:WaitForChild("HumanoidRootPart")
local ts = game:GetService("TweenService")
local balls = game.Workspace:WaitForChild("Balls"):GetChildren()
local aliveplrs = game.Workspace:WaitForChild("Alive")
local vim = game:GetService("VirtualInputManager")
local dist = 7.5
local ballspeed = 6
local plrballdist = 0
local randball
local rot = 0
local rad = math.rad
local clamp = math.clamp
local tweentime = 1/45
local Info = TweenInfo.new(tweentime/4.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

local indicatorPart = Instance.new("Part")
indicatorPart.Size = Vector3.new(ballspeed, ballspeed, ballspeed)
indicatorPart.Anchored = true
indicatorPart.CanCollide = false
indicatorPart.Transparency = 0
indicatorPart.BrickColor = Color3.FromRGB(255,255,255)
indicatorPart.Material = Enum.Material.ForceField
indicatorPart.Parent = workspace

game.Workspace:WaitForChild("Balls").ChildAdded:Connect(function()
    start()
end)

function start()
    while task.wait(tweentime) do
        char = game.Players.LocalPlayer.Character
        hrp = char:WaitForChild("HumanoidRootPart")
        balls = game.Workspace:WaitForChild("Balls"):GetChildren()
        if #balls > 0 and aliveplrs:FindFirstChild(plr.Name) then
            randball = balls[math.random(1,#balls)]
            if randball and hrp then
                local r = rad(rot)
                local newcframe = randball.CFrame*CFrame.Angles(0,r,0)*CFrame.new(0,0,dist)
                if randball:GetAttribute("target")==plr.Name then
                    dist = clamp(dist*0.95, 6, math.huge)
                else
                    dist = clamp(randball.Velocity.Magnitude*0.2, 6, math.huge)
                end

                if plrballdist<=ballspeed*0.6 and randball:GetAttribute("target")==plr.Name then
                    vim:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
                    vim:SendKeyEvent(false, Enum.KeyCode.F, false, nil)
                end

                if randball:GetAttribute("target")==plr.Name then
                    indicatorPart.Color=Color3.FromRGB(255,125,125)
                elseif plrballdist<=ballspeed*0.6 and randball:GetAttribute("target")==plr.Name then
                    indicatorPart.Color=Color3.FromRGB(125,255,125)
                else
                    indicatorPart.Color=Color3.FromRGB(255,255,255)
                end
                
                plrballdist = (hrp.Position - randball.Position).Magnitude
                ballspeed = clamp(randball.Velocity.Magnitude,6,math.huge)
                rot=math.random(-180,180)

                indicatorPart.CFrame=CFrame.new(hrp.Position)
                indicatorPart.Size=Vector3.new(ballspeed,ballspeed,ballspeed)
                hrp.AssemblyLinearVelocity=Vector3.zero
                ts:Create(hrp, Info, {CFrame = newcframe}):Play()
            end
        end
    end
end
start()
