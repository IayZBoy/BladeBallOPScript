local char = game.Players.LocalPlayer.Character
local hrp = char:WaitForChild("HumanoidRootPart")
local ts = game:GetService("TweenService")
local rot = 0
local tweentime = 1/45

function start()
while task.wait(tweentime) do
    pcall(function()
        local balls = game.workspace:WaitForChild("Balls"):GetChildren()
        pcall(function()
            local randball = balls[math.random(1,#balls)]
            if randball then
                local rad = math.rad
                local r = rad(rot)
                local newcframe = randball.CFrame*CFrame.Angles(0,r,0)*CFrame.new(0,0,-10)
                rot+=math.random(15,180)
                hrp.Velocity=Vector3.zero
                ts:Create(hrp, TweenInfo.new(tweentime), {CFrame = newcframe}):Play()
            end
        end)
    end)
end
end
game.Workspace:WaitForChild("Balls").ChildAdded:Connect(start)
