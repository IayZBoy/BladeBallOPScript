local char = game.Players.LocalPlayer.Character
local hrp = char:WaitForChild("HumanoidRootPart")
local ts = game:GetService("TweenService")
local balls = game.Workspace:WaitForChild("Balls"):GetChildren()
local randball
local rot = 0
local rad = math.rad
local tweentime = 1/45

function start()
    while task.wait(tweentime) do
        balls = game.Workspace:WaitForChild("Balls"):GetChildren()
        if #balls > 0 then
            randball = balls[math.random(1,#balls)]
            if randball then
                local rad = math.rad
                local r = rad(rot)
                local newcframe = randball.CFrame*CFrame.Angles(0,r,0)*CFrame.new(0,0,-15)
                rot+=90

                hrp.AssemblyLinearVelocity=Vector3.new(0,0,0)
                ts:Create(hrp, TweenInfo.new(tweentime/2), {CFrame = newcframe}):Play()
            end
        end
    end
end
start()
game.Workspace:WaitForChild("Balls").ChildAdded:Connect(function()
    start()
end)
