local plr = game.Players.LocalPlayer
local char = plr.Character
local hrp = char:WaitForChild("HumanoidRootPart")
local ts = game:GetService("TweenService")
local balls = game.Workspace:WaitForChild("Balls"):GetChildren()
local aliveplrs = game.Workspace:WaitForChild("Alive"):GetChildren()
local randball
local rot = 0
local rad = math.rad
local tweentime = 1/45
local Info = TweenInfo.new(tweentime/4.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

game.Workspace:WaitForChild("Balls").ChildAdded:Connect(function()
    start()
end)

function start()
    while task.wait(tweentime) do
        char = game.Players.LocalPlayer.Character
        hrp = char:WaitForChild("HumanoidRootPart")
        balls = game.Workspace:WaitForChild("Balls"):GetChildren()
        aliveplrs = game.Workspace:WaitForChild("Alive"):GetChildren()
        if #balls > 0 and aliveplrs:FindFirstChild(plr.Name) then
            randball = balls[math.random(1,#balls)]
            if randball and hrp then
                local r = rad(rot)
                local newcframe = randball.CFrame*CFrame.Angles(0,r,0)*CFrame.new(0,0,15)
                rot=math.random(-180,180)

                hrp.AssemblyLinearVelocity=Vector3.zero
                ts:Create(hrp, Info, {CFrame = newcframe}):Play()
            end
        end
    end
end
start()
