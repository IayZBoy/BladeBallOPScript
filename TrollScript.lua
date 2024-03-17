local char = game.Players.LocalPlayer.Character
local hrp = char:WaitForChild("HumanoidRootPart")
local ts = game:GetService("TweenService")
local balls = game.Workspace:WaitForChild("Balls"):GetChildren()
local randball
local rot = 0
local rad = math.rad
local r = rad(rot)
local tweentime = 1/45

function start()
    while task.wait(tweentime) do
        balls = game.Workspace:WaitForChild("Balls"):GetChildren()
        if #balls > 0 then
            randball = balls[math.random(1,#balls)]
            if randball then
                local newcframe = randball.CFrame*CFrame.Angles(0,r,0)*CFrame.new(0,0,-7.5)
                rot = rot + math.random(90,180)
                r = rad(rot)
                hrp.Velocity = Vector3.new() 
                ts:Create(hrp, TweenInfo.new(tweentime), {CFrame = newcframe}):Play()
            end
        end
    end
end
start()
game.Workspace:WaitForChild("Balls").ChildAdded:Connect(function()
    start()
end)
