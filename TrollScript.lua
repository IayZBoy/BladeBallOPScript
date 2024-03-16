local char = game.Players.LocalPlayer.Character
local hrp = char:WaitForChild("HumanoidRootPart")
local ts = game:GetService("TweenService")
local randball2
local rot = 0
local tweentime = 1/30

while task.wait(tweentime) do
    local balls = game.workspace:WaitForChild("Balls"):GetChildren()
    pcall(function()
        local randball = balls[math.random(1,#balls)]
        if randball then
            local rad = math.rad
            local r = rad(rot)
 	    	local newcframe = randball.CFrame*CFrame.Angles(0,r,0)*CFrame.new(0,0,-15)
            rot+=math.random(15,180)
            hrp.AssemblyLinearVelocity=Vector3.zero
            ts:Create(hrp, TweenInfo.new(tweentime), {CFrame = newcframe}):Play()
        end
    end)
end
