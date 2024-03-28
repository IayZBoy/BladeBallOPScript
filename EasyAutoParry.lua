local balls = workspace:WaitForChild("Balls")
local randball
local plr = game.Players.LocalPlayer
local char = plr.Character
local hrp = char:WaitForChild("HumanoidRootPart")
local plrballdist
local hit = game:GetService("ReplicatedStorage"):WaitForChild("Remotes").ParryButtonPress

function GetSpeed()
    return (ballspeed*0.65)/2
end

function GetDistance()
    return plrballdist*(1+plr:GetNetworkPing())
end

function CanParry()
    if GetDistance()<=GetSpeed()/2 then
        return true
    else
        return false
    end
end

function Parry()
    hit:Fire()
end

function IsRealBall()
    return randball:GetAttribute("realBall")
end

function Start()
    if balls then
        randball = balls:GetChildren()[math.random(1,#balls:GetChildren())]
        if randball then
            plrballdist = (randball.Position-hrp.Position).Magnitude
            ballspeed = clamp(randball.Velocity.Magnitude,6,math.huge)
            if GetDistance()<=GetSpeed() and IsRealBall() and ball:GetAttribute("target")==plr.Name then
                Parry()
            end
        end
    end
end

game:GetService("RunService").RenderStepped:Connect(Start)
game:GetService("RunService").Heartbeat:Connect(Start)
