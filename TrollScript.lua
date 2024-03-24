local plr = game.Players.LocalPlayer
local char = plr.Character
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local ts = game:GetService("TweenService")
local balls = game.Workspace:WaitForChild("Balls"):GetChildren()
local aliveplrs = game.Workspace:WaitForChild("Alive")
local vim = game:GetService("VirtualInputManager")
local hit = game.ReplicatedStorage.Remotes.ParryAttempt
local dist = 7.5
local ballspeed = 12.5
local plrballdist = 0
local randball
local BallGui
local rot = 0
local rad = math.rad
local clamp = math.clamp
local tweentime = game:GetService("RunService").Heartbeat:Wait()
local Info = TweenInfo.new(tweentime/4.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local NEVERLOSE = loadstring(game:HttpGet("https://raw.githubusercontent.com/3345-c-a-t-s-u-s/NEVERLOSE-UI-Nightly/main/source.lua"))()
local Codes = loadstring(game:HttpGet("https://raw.githubusercontent.com/nqxlOfc/Other-Stuff/main/Code.lua"))

NEVERLOSE:Theme("Dark") 

local whitelisted = {
	133840022, --XxMattvdbraakXx
	1309041911, --Cel3stiallll
	78604822, --kayd7
	4863463328, --Dino_irak
	3939974770, --Dino Alt
}

local Notification = NEVERLOSE:Notification()

local data = {
	Combat = {
		AutoParryEnabled = false,
		VisualiserEnabled = false,
		AutoSpamEnabled=false,
		ParryTime=0.7
	},
	Trolls = {
		TrollEnabled = false,
		TrollDistanceFactor = 0.2,
		Gravity=196.2,
		FollowPlayer = false,
		PlayerToFollow = nil,
		BallFrozen=false,
		LookAtBall=false
	},
	Player = {
		WalkSpeed = 36,
		JumpPower = 50
	},
	TargetPlr = {
		Target = nil,
		TargetPlrEnabled=false
	}
}

local succ, err = pcall(function()
	function StartScript()
		local window = NEVERLOSE:AddWindow("ZBOY HUB", "BLADE BALL - NEXT GENERATION")

		local Main = window:AddTab("Main","earth")
		local Creds = window:AddTab("Credits", "list")

		local Combat = Main:AddSection("COMBAT", "left")
		local Trolls = Main:AddSection("TROLLS", "right")
		local Player = Main:AddSection("PLAYER", "left")
		local FpsBoost = Main:AddSection("FPS", "right")
		local Lighting = Main:AddSection("TIME", "right")
		local TargetPlr = Main:AddSection("TARGET PLAYER", "left")
		local Esp = Main:AddSection("ESP", "right")

		local PlayerList = Trolls:AddDropdown("Players", game.Players:GetPlayers(),game.Players.LocalPlayer, function(v)
			data.Trolls.PlayerToFollow=v.Name
		end)
		local PlayerList2 = TargetPlr:AddDropdown("Players", game.Players:GetPlayers(),game.Players.LocalPlayer, function(v)
			data.Trolls.PlayerToFollow=v.Name
		end)

		Combat:AddToggle("Auto Parry",true,function(val)
			data.Combat.AutoParryEnabled=val
		end)
		Combat:AddToggle("Visualiser",false,function(val)
			data.Combat.VisualiserEnabled=val
		end)
		Combat:AddSlider("Parry Time",0,100,60,function(val)
			data.Combat.ParryTime=val/100
		end)
		Combat:AddToggle("Auto Spam",false,function(val)
			data.Combat.AutoSpamEnabled=val
		end)

		Trolls:AddToggle("Troll Enabled",false,function(val)
			data.TrollEnabled=val
		end)

		Trolls:AddToggle("Follow Player",false,function(a)
			data.Trolls.FollowPlayer=a
		end)

		Trolls:AddToggle("Freeze Ball",false,function(a)
			data.Trolls.BallFrozen=a
		end)

		Trolls:AddToggle("Look at ball",false,function(a)
			data.LookAtBall=a
		end)

		Trolls:AddButton("Update Players",function(a)
			PlayerList:Refresh()
		end)

		Trolls:AddSlider("Gravity",0,300,196.2,function(a)
			if hum then
				hum.UseJumpPower=true
			end
			data.Trolls.Gravity=a
		end)

		Trolls:AddSlider("Troll Distance Factor",0,100,20,function(distance)
			data.TrollDistanceFactor=distance/100
		end)

		Player:AddSlider("Speed",36,250,36,function(a)
			if hum then
				data.Player.WalkSpeed=a
			end
		end)
		Player:AddSlider("JumpPower",50,250,50,function(a)
			if hum then
				hum.UseJumpPower=true
				data.Player.JumpPower=a
			end
		end)
		FpsBoost:AddButton("Increase FPS", function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/nqxlOfc/Other-Stuff/main/FpsBoost.lua"))
		end)
		Lighting:AddSlider("Time",0,240,120,function(a)
			game.Lighting.TimeOfDay=a/10
		end)
		TargetPlr:AddToggle("Target Plr Enabled",false,function(a)
			data.TargetPlr.TargetPlrEnabled=a
		end)

		Esp:AddToggle("Ball Gui", false, function(a)
			if a then
				BallGui = Instance.new("BillboardGui")
				local TextLabel = Instance.new("TextLabel")
				BallGui.Parent=randball
				BallGui.LightInfluence=0
				BallGui.AlwaysOnTop=true
				TextLabel.Parent=BallGui
				TextLabel.BackgroundTransparency=1
				TextLabel.TextColor3=Color3.fromRGB(255,255,255)
				TextLabel.RichText=true
				TextLabel.Size=UDim2.fromScale(1,1)

				while task.wait() do
					TextLabel.Text="<b>BALL • "..ballspeed.."</b>"
				end
				if not a and BallGui then
					BallGui:Destroy()
				end
			end
		end)

		local catsus = Creds:AddSection("3345-c-a-t-s-u-s")
		catsus:AddLabel("CREDITS TO")
		catsus:AddLabel("3345-c-a-t-s-u-s")
		catsus:AddLabel("FOR THE IDEA AND THE UI")
		local nqxl = Creds:AddSection("nqxlOfc")
		nqxl:AddLabel("CREDITS TO")
		nqxl:AddLabel("nqxlOfc")
		nqxl:AddLabel("FOR THE CODES AND THE ANTI-LAG")

		game.Players.PlayerAdded:Connect(function()
			PlayerList:Refresh()
			PlayerList2:Refresh()
		end)
	end

	if table.find(whitelisted, plr.UserId) then
		StartScript()
	else
		local KeySystem = NEVERLOSE:KeySystem("Key System","!QAZ1qaz@WSX2wsx", function(Key)
			if Key=="!QAZ1qaz@WSX2wsx" then
				return true
			else
				return false
			end
		end)
		KeySystem:Callback(function()
			StartScript()
		end)
	end

	local indicatorPart = Instance.new("Part")
	indicatorPart.Size = Vector3.new(ballspeed, ballspeed, ballspeed)
	indicatorPart.Anchored = true
	indicatorPart.CanCollide = false
	indicatorPart.Transparency = 1
	indicatorPart.Color = Color3.fromRGB(255,255,255)
	indicatorPart.Material = Enum.Material.ForceField
	indicatorPart.Shape=Enum.PartType.Ball
	indicatorPart.Parent = workspace

	game.Workspace:WaitForChild("Balls").ChildAdded:Connect(function()
	    start()
	end)

	local function getclosestplr()
	    local bot_position = hrp.Position
	
	    local distance = math.huge
	    local closest_player_character = nil
	
		for i, player in pairs(game.Players:GetPlayers()) do
			if player.Character:FindFirstChild("Humanoid") then

			    local player_position = player.Character.HumanoidRootPart.Position
			    local distance_from_bot = (bot_position - player_position).magnitude
			
				if distance_from_bot < distance then
				    distance = distance_from_bot
				    closest_player_character = player.Character
				end
			end
		end

		return closest_player_character
	end

	function GetPoint()
		if workspace:FindFirstChild("CurrentCamera") then
			if data.TargetPlr.TargetPlrEnabled and data.TargetPlr.Target then
				return workspace:FindFirstChild("CurrentCamera"):WorldToScreenPoint(workspace:FindFirstChild(data.TargetPlr.Target):FindFirstChild("HumanoidRootPart").Position)
			else
				return workspace:FindFirstChild("CurrentCamera"):WorldToScreenPoint(hrp.Position)
			end
		end
	end

	function IsRealBall()
		return randball:GetAttribute("realBall")
	end

	function GetSpeed()
		return (ballspeed*data.Combat.ParryTime)/2
	end

	function GetDistance()
		return plrballdist*(1+plr:GetNetworkPing())
	end

	function GetSpamDistance()
		return (hrp.Position-getclosestplr():FindFirstChild("HumanoidRootPart").Position).Magnitude
	end

	function CanParry()
		if GetDistance()<=GetSpeed()/1.5 then
			return true
		else
			return false
		end
	end

	function Parry()
		hit:FireServer(0.65, CFrame.new(),{},{GetPoint().X,GetPoint().Y})
	end

	function TryParry()
		if IsRealBall() then
			if GetSpamDistance()<=10 and GetDistance()<=10 and data.Combat.AutoSpamEnabled then
				Parry()
			elseif CanParry() and randball:GetAttribute("target")==plr.Name and data.Combat.AutoParryEnabled then
	       		Parry()
	     	end
		end
	end

	function GetLocalSize()
		return Vector3.new(GetSpeed()*2,GetSpeed()*2,GetSpeed()*2)*(1+plr:GetNetworkPing())
	end

	function UpdateIndicator()
	    if randball:GetAttribute("target")==plr.Name and IsRealBall() then
	        indicatorPart.Color=Color3.fromRGB(255,125,125)
	    elseif CanParry() and randball:GetAttribute("target")==plr.Name and IsRealBall() then
	        indicatorPart.Color=Color3.fromRGB(125,255,125)
	    else
	        indicatorPart.Color=Color3.fromRGB(255,255,255)
	    end
	    if hrp then
	        indicatorPart.CFrame=CFrame.new(hrp.Position)
	    end
		if data.Combat.VisualiserEnabled then
			indicatorPart.Transparency=0
		else
			indicatorPart.Transparency=1
		end

	    indicatorPart.Size=GetLocalSize()/1.5
	end

	function LaunchItems()
		TryParry()
		UpdateIndicator()
		workspace.Gravity=data.Trolls.Gravity
		if hum then
			hum.WalkSpeed=data.Player.WalkSpeed
			hum.JumpPower=data.Player.JumpPower
			hum.UseJumpPower=true
		end
		if data.Trolls.BallFrozen then
			game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Freeze"):FireServer()
		end
		if data.Trolls.LookAtBall then
			hrp.CFrame = CFrame.lookAt(hrp.Position, randball.Position, Vector3.new(0,1,0))
		end
	end

	randball:GetAttributeChangedSignal("target"):Connect(TryParry)
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

					if data.Trolls.BallFrozen then
						game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Freeze"):FireServer()
					end
				
            	    plrballdist = (randball.Position-hrp.Position).Magnitude
            	    ballspeed = clamp(randball.Velocity.Magnitude,6,math.huge)
            	    rot=math.random(-180,180)
				
	                if data.Trolls.TrollEnabled then
	                    hrp.AssemblyLinearVelocity=Vector3.zero
	                    ts:Create(hrp, Info, {CFrame = newcframe}):Play()
					elseif data.Trolls.FollowPlayer and data.Trolls.PlayerToFollow then
						hrp.AssemblyLinearVelocity=Vector3.zero
						ts:Create(hrp, Info, {CFrame = workspace:FindFirstChild(data.PlayerToFollow):FindFirstChild("HumanoidRootPart").CFrame*CFrame.Angles(0,r,0)*CFrame.new(0,0,10)}):Play()
            	    end
        	    end
    	    end
 	   end
		start()
	end
end)

if succ then
	Notification:Notify("success", "SUCCESS!", "Successfully loaded script.", 4)
elseif not succ then
	Notification:Notify("error", "ERROR!", err, 4)
end