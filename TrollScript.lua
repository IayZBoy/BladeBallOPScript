local plr = game.Players.LocalPlayer
local char = plr.Character
local hrp = char:WaitForChild("HumanoidRootPart")
local ts = game:GetService("TweenService")
local balls = game.Workspace:WaitForChild("Balls"):GetChildren()
local aliveplrs = game.Workspace:WaitForChild("Alive")
local vim = game:GetService("VirtualInputManager")
local hit = game.ReplicatedStorage.Remotes.ParryAttempt
local dist = 7.5
local ballspeed = 6
local plrballdist = 0
local randball
local rot = 0
local rad = math.rad
local clamp = math.clamp
local tweentime = game:GetService("RunService").Heartbeat:Wait()
local Info = TweenInfo.new(tweentime/4.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local ui = BedolUIV4

local data = {
    AutoParryEnabled = true
    TrollEnabled = false
    TrollDistanceFactor = 0.2
}

local window = ui:AddWindow()

local Main = window:AddTab("earth")

local Combat = Main:AddSection("Combat", "Main")
local Trolls = Main:AddSection("Trolls", "Main")

Combat:AddToggle("Auto Parry",true,function(val)
    data.AutoParryEnabled=val
end)

Trolls:AddToggle("Troll Enabled",true,function(val)
    data.TrollEnabled=val
end)

Trolls:AddSlider("Troll Distance Factor",0,1,0.2,"X",function(distance)
    data.TrollDistanceFactor=distance
end)

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
    local totalsize = Vector3.new(ballspeed,ballspeed,ballspeed)*(1+plr:GetNetworkPing())
    indicatorPart.Size=totalsize
end

function TryParry()
     if plrballdist<=ballspeed*0.6 and randball:GetAttribute("target")==plr.Name and data.AutoParryEnabled then
         local point = Camera:WorldToScreenPoint(Local.Character.HumanoidRootPart.Position)
         hit:FireServer(0.6, CFrame.new(),{},{point.X,point.Y})
     end
end

function LaunchItems()
	TryParry()
	UpdateIndicator()
end

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
                    dist = clamp(randball.Velocity.Magnitude*data.TrollDistanceFactor, 6, math.huge)
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

game:GetService("RunService").RenderStepped:Connect(LaunchItems)
game:GetService("RunService").Heartbeat:Connect(LaunchItems)
randball.Changed:Connect(LaunchItems)

local BedolUIV4 = {}
local LocalPlayer = game:GetService('Players').LocalPlayer;
local Mouse = LocalPlayer:GetMouse();
local InputService = game:GetService('UserInputService');
local TextService = game:GetService('TextService');
local TweenService = game:GetService('TweenService');
local CoreGui = game:FindFirstChild('CoreGui') or LocalPlayer.PlayerGui;

local ProtectGui = protectgui or (syn and syn.protect_gui) or (function() end);

local function cretate_button(asd)
	local button=Instance.new('TextButton')
	button.Size=UDim2.new(1,0,1,0)
	button.BackgroundTransparency=1
	button.TextTransparency=1
	button.Text=""
	button.Parent=asd
	button.ZIndex=9999999
	return button
end


local function ConnectButtonEffect(UIFrame:Frame&TextButton&ImageLabel,UIStroke:UIStroke,int)
	if not UIStroke then
		return
	end

	int = int or 0.2
	local OldColor = UIStroke.Color
	local R,G,B = OldColor.R,OldColor.G,OldColor.B
	local MainColor = Color3.fromHSV(R,G,B + int)

	UIFrame.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseMovement then
			TweenService:Create(UIStroke,TweenInfo.new(0.2),{Color = MainColor}):Play()
		end
	end)

	UIFrame.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseMovement then
			TweenService:Create(UIStroke,TweenInfo.new(0.2),{Color = OldColor}):Play()
		end
	end)
end


local function GetImageData(name:string,image:ImageLabel)
	name = name or "ADS"
	name = name:lower()
	local NigImage = "rbxassetid://3926305904"
	if name == "ads" then
		image.Image = NigImage
		image.ImageRectOffset = Vector2.new(205,565)
		image.ImageRectSize = Vector2.new(35,35)
	end
	
	if name == "list" then
		image.Image = NigImage
		image.ImageRectOffset = Vector2.new(485,205)
		image.ImageRectSize = Vector2.new(35,35)
	end
	
	if name == "folder" then
		image.Image = NigImage
		image.ImageRectOffset = Vector2.new(805,45)
		image.ImageRectSize = Vector2.new(35,35)
	end
	
	if name == "earth" then
		image.Image = NigImage
		image.ImageRectOffset = Vector2.new(604,324)
		image.ImageRectSize = Vector2.new(35,35)
	end
	
	if name == "mouse" then
		image.Image = "rbxassetid://3515393063"
	end
	
	if name == "user" then
		image.Image = "rbxassetid://10494577250"
	end
end

function BedolUIV4:AddWindow(LogoImageMain)
	LogoImageMain = LogoImageMain or "rbxassetid://14953079325"
	local WindowsAssets = {}
	local Tabs = {}
	local BedolUIV4 = Instance.new("ScreenGui")
	local Frame = Instance.new("Frame")
	local DropShadow = Instance.new("ImageLabel")
	local UICorner = Instance.new("UICorner")
	local LogoImage = Instance.new("ImageLabel")
	local Outline = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local TabButtons = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local Movement = Instance.new("Frame")
	local UICorner_3 = Instance.new("UICorner")
	
	UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		TabButtons.CanvasSize = UDim2.new(0,UIListLayout.AbsoluteContentSize.X,0,0)
	end)
	
	BedolUIV4.Name = "BedolUIV4"
	BedolUIV4.Parent = CoreGui
	BedolUIV4.ResetOnSpawn = false
	BedolUIV4.ZIndexBehavior = Enum.ZIndexBehavior.Global
	BedolUIV4.IgnoreGuiInset = true
	
	Frame.Parent = BedolUIV4
	Frame.Active = true
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BorderSizePixel = 0
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame.Size = UDim2.new(0.200000003, 200, 0.200000003, 150)
	Frame.ZIndex = 2

	DropShadow.Name = "DropShadow"
	DropShadow.Parent = Frame
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = -2
	DropShadow.Image = "rbxassetid://6015897843"
	DropShadow.ImageColor3 = Color3.fromRGB(104, 0, 2)
	DropShadow.ImageTransparency = 0.500
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

	UICorner.CornerRadius = UDim.new(0, 4)
	UICorner.Parent = Frame

	LogoImage.Name = "LogoImage"
	LogoImage.Parent = Frame
	LogoImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LogoImage.BackgroundTransparency = 1.000
	LogoImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogoImage.BorderSizePixel = 0
	LogoImage.Position = UDim2.new(0.00999999978, 0, 0.00999999978, 0)
	LogoImage.Size = UDim2.new(0.125, 0, 0.125, 0)
	LogoImage.SizeConstraint = Enum.SizeConstraint.RelativeYY
	LogoImage.ZIndex = 4
	LogoImage.Image = LogoImageMain or "rbxassetid://14953079325"

	Outline.Name = "Outline"
	Outline.Parent = Frame
	Outline.AnchorPoint = Vector2.new(0.5, 0)
	Outline.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
	Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Outline.BorderSizePixel = 0
	Outline.Position = UDim2.new(0.5, 0, 0.134000003, 0)
	Outline.Size = UDim2.new(1, 0, 0, 1)
	Outline.ZIndex = 4

	UICorner_2.CornerRadius = UDim.new(0.5, 0)
	UICorner_2.Parent = Outline

	TabButtons.Name = "TabButtons"
	TabButtons.Parent = Frame
	TabButtons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabButtons.BackgroundTransparency = 1.000
	TabButtons.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabButtons.BorderSizePixel = 0
	TabButtons.Position = UDim2.new(0.0989999995, 0, 0.0199999996, 0)
	TabButtons.Size = UDim2.new(0.884000003, 0, 0.100000001, 0)
	TabButtons.ZIndex = 5
	TabButtons.CanvasSize = UDim2.new(2, 0, 0, 0)
	TabButtons.ScrollBarThickness = 0

	UIListLayout.Parent = TabButtons
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Padding = UDim.new(0, 5)

	Movement.Name = "Movement"
	Movement.Parent = Frame
	Movement.AnchorPoint = Vector2.new(0.5, 0)
	Movement.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
	Movement.BackgroundTransparency = 1.000
	Movement.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Movement.BorderSizePixel = 0
	Movement.Position = UDim2.new(0.5, 0, 0.00702060433, 0)
	Movement.Size = UDim2.new(1, 0, 0.123244695, 1)
	Movement.ZIndex = 4

	UICorner_3.CornerRadius = UDim.new(0.5, 0)
	UICorner_3.Parent = Movement
	
	function WindowsAssets:AddTab(ImageType)
		
		local TabAssets = {}
		local Frame = Instance.new("Frame")
		local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
		local UICorner = Instance.new("UICorner")
		local Main = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local ImageLabel = Instance.new("ImageLabel")

		Frame.Parent = TabButtons
		Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame.BackgroundTransparency = 1.000
		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Size = UDim2.new(0.5, 0, 0.875, 0)
		Frame.ZIndex = 4

		UIAspectRatioConstraint.Parent = Frame
		UIAspectRatioConstraint.AspectRatio = 1.750
		UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize
		UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Frame

		Main.Name = "Main"
		Main.Parent = Frame
		Main.AnchorPoint = Vector2.new(0.5, 0.5)
		Main.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
		Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Main.BorderSizePixel = 0
		Main.Position = UDim2.new(0.5, 0, 0.5, 0)
		Main.Size = UDim2.new(0.949999988, 0, 0.949999988, 0)
		Main.ZIndex = 5

		UICorner_2.CornerRadius = UDim.new(0, 4)
		UICorner_2.Parent = Main

		UIStroke.Color = Color3.fromRGB(104, 104, 104)
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke.Parent = Main

		ImageLabel.Parent = Main
		ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.BackgroundTransparency = 1.000
		ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		ImageLabel.Size = UDim2.new(1, 0, 1, 0)
		ImageLabel.ZIndex = 6
		GetImageData(tostring(ImageType),ImageLabel)
		ImageLabel.ScaleType = Enum.ScaleType.Fit
		
		
		local Tab = Instance.new("Frame")
		local left = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local right = Instance.new("ScrollingFrame")
		local UIListLayout_2 = Instance.new("UIListLayout")
		
		UIListLayout_2:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			right.CanvasSize = UDim2.new(0,0,0,UIListLayout_2.AbsoluteContentSize.Y)
		end)
		
		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			left.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y)
		end)
		
		Tab.Name = "Tab"
		Tab.Parent = TabButtons.Parent
		Tab.AnchorPoint = Vector2.new(0.5, 0.5)
		Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Tab.BackgroundTransparency = 1.000
		Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Tab.BorderSizePixel = 0
		Tab.ClipsDescendants = true
		Tab.Position = UDim2.new(0.5, 0, 0.574693739, 0)
		Tab.Size = UDim2.new(0.970000029, 0, 0.802999973, 0)
		Tab.ZIndex = 5

		left.Name = "left"
		left.Parent = Tab
		left.Active = true
		left.AnchorPoint = Vector2.new(0, 0.5)
		left.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		left.BackgroundTransparency = 1.000
		left.BorderColor3 = Color3.fromRGB(0, 0, 0)
		left.BorderSizePixel = 0
		left.ClipsDescendants = false
		left.Position = UDim2.new(0, 0, 0.5, 0)
		left.Size = UDim2.new(0.495000005, 0, 0.99000001, 0)
		left.ZIndex = 5
		left.ScrollBarThickness = 0
		left.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left

		UIListLayout.Parent = left
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 5)

		right.Name = "right"
		right.Parent = Tab
		right.Active = true
		right.AnchorPoint = Vector2.new(1, 0.5)
		right.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		right.BackgroundTransparency = 1.000
		right.BorderColor3 = Color3.fromRGB(0, 0, 0)
		right.BorderSizePixel = 0
		right.ClipsDescendants = false
		right.Position = UDim2.new(1, 0, 0.5, 0)
		right.Size = UDim2.new(0.495000005, 0, 0.99000001, 0)
		right.ZIndex = 5
		right.ScrollBarThickness = 0

		UIListLayout_2.Parent = right
		UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_2.Padding = UDim.new(0, 5)
		
		local function TabCallback (val)
			if val then
				Tab.Visible = true
				TweenService:Create(Main,TweenInfo.new(0.4),{BackgroundColor3 = Color3.fromRGB(90, 0, 1)}):Play()
			else
				Tab.Visible = false
				TweenService:Create(Main,TweenInfo.new(0.4),{BackgroundColor3 = Color3.fromRGB(24, 24, 24)}):Play()
			end
		end
		
		if #Tabs==0 then
			TabCallback(true)
		else
			TabCallback(false)
		end
		
		table.insert(Tabs,{Tab,TabCallback})
		
		cretate_button(Main).MouseButton1Click:Connect(function()
			for i,v in ipairs(Tabs) do
				if v[1] == Tab then
					v[2](true)
				else
					v[2](false)
				end
			end
				
		end)
		
		function TabAssets:AddSection(Section_Name,parentname)
			local SectionAssets = {}
			parentname = parentname or ""
			local parentget = (parentname:lower() == "left" and left) or (parentname:lower() == "right") or left
			local Section = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local UIStroke = Instance.new("UIStroke")
			local Section_Head = Instance.new("Frame")
			local SectionTitle = Instance.new("TextLabel")
			local UICorner_2 = Instance.new("UICorner")
			local UIListLayout = Instance.new("UIListLayout")

			Section.Name = "Section"
			Section.Parent = parentget
			Section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Section.BackgroundTransparency = 1.000
			Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Section.BorderSizePixel = 0
			Section.Size = UDim2.new(0.949999988, 0, 0, 17)
			Section.ZIndex = 5

			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = Section

			UIStroke.Color = Color3.fromRGB(104, 104, 104)
			UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke.Parent = Section

			Section_Head.Name = "Section_Head"
			Section_Head.Parent = Section
			Section_Head.AnchorPoint = Vector2.new(0.5, 0)
			Section_Head.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
			Section_Head.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Section_Head.BorderSizePixel = 0
			Section_Head.Position = UDim2.new(0.5, 0, 0, 0)
			Section_Head.Size = UDim2.new(1, 0, 0, 15)
			Section_Head.ZIndex = 5

			SectionTitle.Name = "SectionTitle"
			SectionTitle.Parent = Section_Head
			SectionTitle.AnchorPoint = Vector2.new(0.5, 0.5)
			SectionTitle.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
			SectionTitle.BackgroundTransparency = 1.000
			SectionTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionTitle.BorderSizePixel = 0
			SectionTitle.Position = UDim2.new(0.5, 0, 0.5, 0)
			SectionTitle.Size = UDim2.new(0.959999979, 0, 0.800000012, 0)
			SectionTitle.ZIndex = 6
			SectionTitle.Font = Enum.Font.SourceSansBold
			SectionTitle.Text = Section_Name or "Section"
			SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			SectionTitle.TextScaled = true
			SectionTitle.TextSize = 14.000
			SectionTitle.TextWrapped = true
			SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

			UICorner_2.CornerRadius = UDim.new(0, 4)
			UICorner_2.Parent = Section_Head

			UIListLayout.Parent = Section
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 5)
			
			local function updateSize()
				local a=0
				for i,v:Frame in ipairs(Section:GetChildren()) do
					if v:isA('Frame') then
						if v.Visible then
							a=a+v.Size.Y.Offset + 3
						end
					end
				end
				
				TweenService:Create(Section,TweenInfo.new(0.1),{Size = UDim2.new(0.949999988, 0, 0, a+20)}):Play()
				
			end
			
			
			updateSize()
			function SectionAssets:AddButton(BUTTON_NAM,CALLBACK)
				CALLBACK = CALLBACK or function ()
					
				end
				
				local Button = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local TextLabel = Instance.new("TextLabel")
				local UICorner_2 = Instance.new("UICorner")
				local UIStroke = Instance.new("UIStroke")

				Button.Name = "Button"
				Button.Parent = Section
				Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Button.BackgroundTransparency = 1.000
				Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Button.BorderSizePixel = 0
				Button.Size = UDim2.new(0.980000019, 0, 0, 15)
				Button.ZIndex = 6

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = Button

				TextLabel.Parent = Button
				TextLabel.AnchorPoint = Vector2.new(0.5, 0)
				TextLabel.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
				TextLabel.BackgroundTransparency = 0.550
				TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
				TextLabel.BorderSizePixel = 0
				TextLabel.Position = UDim2.new(0.5, 0, 0, 0)
				TextLabel.Size = UDim2.new(0.949999988, 0, 1, 0)
				TextLabel.ZIndex = 5
				TextLabel.Font = Enum.Font.RobotoMono
				TextLabel.Text = BUTTON_NAM or "Button"
				TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel.TextScaled = true
				TextLabel.TextSize = 14.000
				TextLabel.TextStrokeColor3 = Color3.fromRGB(141, 141, 141)
				TextLabel.TextStrokeTransparency = 0.860
				TextLabel.TextWrapped = true

				UICorner_2.CornerRadius = UDim.new(0, 2)
				UICorner_2.Parent = TextLabel

				UIStroke.Transparency = 0.540
				UIStroke.Color = Color3.fromRGB(104, 104, 104)
				UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				UIStroke.Parent = TextLabel
				
				updateSize()
				
				cretate_button(Button).MouseButton1Click:Connect(function()
					updateSize()
					CALLBACK()
				end)
				
				ConnectButtonEffect(Button,UIStroke)
				
				local ButtonAssets = {}
				
				function ButtonAssets:Text(a)
					TextLabel.Text = tostring(a)
				end
				
				function ButtonAssets:Fire(...)
					CALLBACK(...)
				end
				
				return ButtonAssets
			end
			
			function SectionAssets:AddLabel(Label_Name)
				local Label = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local TextLabel = Instance.new("TextLabel")

				Label.Name = "Label"
				Label.Parent = Section
				Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Label.BackgroundTransparency = 1.000
				Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Label.BorderSizePixel = 0
				Label.Size = UDim2.new(0.980000019, 0, 0, 15)
				Label.ZIndex = 6

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = Label

				TextLabel.Parent = Label
				TextLabel.AnchorPoint = Vector2.new(0.5, 0)
				TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel.BackgroundTransparency = 1.000
				TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
				TextLabel.BorderSizePixel = 0
				TextLabel.Position = UDim2.new(0.5, 0, 0, 0)
				TextLabel.Size = UDim2.new(0.949999988, 0, 1, 0)
				TextLabel.ZIndex = 5
				TextLabel.Font = Enum.Font.RobotoMono
				TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel.TextScaled = true
				TextLabel.TextSize = 14.000
				TextLabel.TextStrokeColor3 = Color3.fromRGB(141, 141, 141)
				TextLabel.TextStrokeTransparency = 0.880
				TextLabel.TextTransparency = 0.610
				TextLabel.TextWrapped = true
				TextLabel.TextXAlignment = Enum.TextXAlignment.Left
				TextLabel.Text = Label_Name or "asd"
				
				updateSize()
				
				local Assets = {}
				
				function Assets:Text(a)
					TextLabel.Text = tostring(a)
					
				end
				
				return Assets
			end
			
			function SectionAssets:AddToggle(Toggle_Name,default,callback)
				callback = callback or function ()
					
				end
				
				local Toggle = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local TextLabel = Instance.new("TextLabel")
				local IconToggle = Instance.new("Frame")
				local UICorner_2 = Instance.new("UICorner")
				local Cir = Instance.new("Frame")
				local UIStroke = Instance.new("UIStroke")
				local UICorner_3 = Instance.new("UICorner")

				Toggle.Name = "Toggle"
				Toggle.Parent = Section
				Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Toggle.BackgroundTransparency = 1.000
				Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Toggle.BorderSizePixel = 0
				Toggle.Size = UDim2.new(0.980000019, 0, 0, 15)
				Toggle.ZIndex = 6

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = Toggle

				TextLabel.Parent = Toggle
				TextLabel.AnchorPoint = Vector2.new(0.5, 0)
				TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel.BackgroundTransparency = 1.000
				TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
				TextLabel.BorderSizePixel = 0
				TextLabel.Position = UDim2.new(0.569999993, 0, 0, 0)
				TextLabel.Size = UDim2.new(0.750534177, 0, 1, 0)
				TextLabel.ZIndex = 5
				TextLabel.Font = Enum.Font.RobotoMono
				TextLabel.Text = Toggle_Name or "Toggle"
				TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel.TextScaled = true
				TextLabel.TextSize = 14.000
				TextLabel.TextStrokeColor3 = Color3.fromRGB(141, 141, 141)
				TextLabel.TextStrokeTransparency = 0.860
				TextLabel.TextWrapped = true
				TextLabel.TextXAlignment = Enum.TextXAlignment.Left

				IconToggle.Name = "IconToggle"
				IconToggle.Parent = Toggle
				IconToggle.AnchorPoint = Vector2.new(0, 0.5)
				IconToggle.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
				IconToggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				IconToggle.BorderSizePixel = 0
				IconToggle.Position = UDim2.new(0.0299999993, 0, 0.5, 0)
				IconToggle.Size = UDim2.new(0.140000001, 0, 0.699999988, 0)
				IconToggle.ZIndex = 5

				UICorner_2.CornerRadius = UDim.new(0, 4)
				UICorner_2.Parent = IconToggle

				Cir.Name = "Cir"
				Cir.Parent = IconToggle
				Cir.AnchorPoint = Vector2.new(0.5, 0.5)
				Cir.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
				Cir.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Cir.BorderSizePixel = 0
				Cir.Position = UDim2.new(0.25, 0, 0.5, 0)
				Cir.Size = UDim2.new(1.10000002, 0, 1.10000002, 0)
				Cir.SizeConstraint = Enum.SizeConstraint.RelativeYY
				Cir.ZIndex = 6

				UIStroke.Thickness = 1.600
				UIStroke.Color = Color3.fromRGB(24, 24, 24)
				UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				UIStroke.Parent = Cir

				UICorner_3.CornerRadius = UDim.new(0.5, 0)
				UICorner_3.Parent = Cir
				
				local function Tog(val)
					if val then
						TweenService:Create(Cir,TweenInfo.new(0.3),{
							Position = UDim2.new(0.75,0,0.5,0),
							
						}):Play()
						TweenService:Create(IconToggle,TweenInfo.new(0.3),{BackgroundColor3 = Color3.fromRGB(94, 94, 94)}):Play()
						TweenService:Create(UIStroke,TweenInfo.new(0.3),{Color = Color3.fromRGB(94, 94, 94)}):Play()

						TweenService:Create(TextLabel,TweenInfo.new(0.4),{TextTransparency = 0}):Play()
					else
						TweenService:Create(TextLabel,TweenInfo.new(0.4),{TextTransparency = 0.3}):Play()
						TweenService:Create(Cir,TweenInfo.new(0.3),{
							Position = UDim2.new(0.25,0,0.5,0),

						}):Play()
						
						TweenService:Create(IconToggle,TweenInfo.new(0.3),{BackgroundColor3 = Color3.fromRGB(24, 24, 24)}):Play()
						TweenService:Create(UIStroke,TweenInfo.new(0.3),{Color = Color3.fromRGB(24, 24, 24)}):Play()

					end
				end
				
				Tog(default)
				
				cretate_button(Toggle).MouseButton1Click:Connect(function()
					default = not default
					Tog(default)
					callback(default)
				end)
				
				updateSize()
				
				local Assets = {}

				function Assets:Text(a)
					TextLabel.Text = tostring(a)

				end
				
				function Assets:Value(G)
					default = G
					Tog(G)
					callback(G)
				end
				return Assets
				
			end
			
			function SectionAssets:AddSlider(Slider_Name,Min,Max,Default,ValueText,callback)
				Min = Min or 1
				Max = Max or 100
				Default = Default or Min
				ValueText = ValueText or ""
				callback = callback or function()
					
				end
				
				local Slider = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local TextLabel = Instance.new("TextLabel")
				local Stick = Instance.new("Frame")
				local UICorner_2 = Instance.new("UICorner")
				local M_A_I_B = Instance.new("Frame")
				local Frame = Instance.new("Frame")
				local UICorner_3 = Instance.new("UICorner")
				local Value = Instance.new("TextLabel")
				local TouchPad = Instance.new("Frame")

				Slider.Name = "Slider"
				Slider.Parent = Section
				Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Slider.BackgroundTransparency = 1.000
				Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Slider.BorderSizePixel = 0
				Slider.Size = UDim2.new(0.980000019, 0, 0, 30)
				Slider.ZIndex = 6

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = Slider

				TextLabel.Parent = Slider
				TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
				TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel.BackgroundTransparency = 1.000
				TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
				TextLabel.BorderSizePixel = 0
				TextLabel.Position = UDim2.new(0.755408108, 0, 0.5, 0)
				TextLabel.Size = UDim2.new(0.437999994, 0, 0.5, 0)
				TextLabel.ZIndex = 7
				TextLabel.Font = Enum.Font.RobotoMono
				TextLabel.Text = Slider_Name or "Slider"
				TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel.TextScaled = true
				TextLabel.TextSize = 14.000
				TextLabel.TextStrokeColor3 = Color3.fromRGB(141, 141, 141)
				TextLabel.TextStrokeTransparency = 0.880
				TextLabel.TextWrapped = true
				TextLabel.TextXAlignment = Enum.TextXAlignment.Left

				Stick.Name = "Stick"
				Stick.Parent = Slider
				Stick.AnchorPoint = Vector2.new(0, 0.5)
				Stick.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
				Stick.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Stick.BorderSizePixel = 0
				Stick.ClipsDescendants = true
				Stick.Position = UDim2.new(0.0102039976, 0, 0.5, 0)
				Stick.Size = UDim2.new(0.49000001, 0, 0.075000003, 0)
				Stick.ZIndex = 6

				UICorner_2.CornerRadius = UDim.new(0.5, 0)
				UICorner_2.Parent = Stick

				M_A_I_B.Name = "M_A_I_B"
				M_A_I_B.Parent = Stick
				M_A_I_B.BackgroundColor3 = Color3.fromRGB(136, 0, 2)
				M_A_I_B.BorderColor3 = Color3.fromRGB(0, 0, 0)
				M_A_I_B.BorderSizePixel = 0
				M_A_I_B.Size = UDim2.new((Default / Max), 0, 1.10000002, 0)
				M_A_I_B.ZIndex = 6

				Frame.Parent = M_A_I_B
				Frame.AnchorPoint = Vector2.new(1, 0.5)
				Frame.BackgroundColor3 = Color3.fromRGB(136, 0, 2)
				Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Frame.BorderSizePixel = 0
				Frame.Position = UDim2.new(1, 0, 0.5, 0)
				Frame.Rotation = 1.000
				Frame.Size = UDim2.new(2.5, 0, 2.5, 0)
				Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY
				Frame.ZIndex = 7

				UICorner_3.CornerRadius = UDim.new(0.5, 0)
				UICorner_3.Parent = Frame

				Value.Name = "Value"
				Value.Parent = Slider
				Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Value.BackgroundTransparency = 1.000
				Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Value.BorderSizePixel = 0
				Value.Position = UDim2.new(0.0193206072, 0, 0.13333334, 0)
				Value.Size = UDim2.new(0.50000006, 0, 0.267291248, 0)
				Value.ZIndex = 5
				Value.Font = Enum.Font.RobotoMono
				Value.Text = tostring(
					Default
				)..tostring(ValueText)
				
				Value.TextColor3 = Color3.fromRGB(255, 255, 255)
				Value.TextScaled = true
				Value.TextSize = 14.000
				Value.TextWrapped = true

				TouchPad.Name = "TouchPad"
				TouchPad.Parent = Slider
				TouchPad.Active = true
				TouchPad.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TouchPad.BackgroundTransparency = 1.000
				TouchPad.BorderColor3 = Color3.fromRGB(0, 0, 0)
				TouchPad.BorderSizePixel = 0
				TouchPad.Position = UDim2.new(0, 0, 0.233333334, 0)
				TouchPad.Size = UDim2.new(0.5, 0, 0.5, 0)
				TouchPad.ZIndex = 1000
				
				TweenService:Create(TextLabel,TweenInfo.new(0.2),{TextTransparency = 0.3}):Play()
				
				local IsTouched = false
				
				local function UpdateSlider(input)
					if IsTouched then
						local SizeScale = math.clamp(((input.Position.X - Stick.AbsolutePosition.X) / Stick.AbsoluteSize.X) + 0.05, 0, 1)
						local Valuea = math.floor(((Max - Min) * SizeScale) + Min)
						local Size = UDim2.fromScale(math.clamp(SizeScale,0.05,1), 1)
						Value.Text = tostring(Valuea)..tostring(ValueText)
						TweenService:Create(M_A_I_B,TweenInfo.new(0.02),{Size = Size}):Play()
						callback(Valuea)
					end
				end
				
				TouchPad.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						IsTouched = true
						TweenService:Create(TextLabel,TweenInfo.new(0.2),{TextTransparency = 0}):Play()
						task.wait()
						updateSize(Input)
					end
				end)

				TouchPad.InputEnded:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						IsTouched = false
						TweenService:Create(TextLabel,TweenInfo.new(0.2),{TextTransparency = 0.3}):Play()
						task.wait()
						updateSize(Input)
					end
				end)
				
				InputService.InputChanged:Connect(function(input)
					if IsTouched and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						UpdateSlider(input)
					end
				end)
				
				updateSize()
				
				local Assets = {}

				function Assets:Text(a)
					TextLabel.Text = tostring(a)

				end

				function Assets:Value(G)
					Value.Text = tostring(
						G
					)..tostring(ValueText)
					local Size = UDim2.new((G / Max), 0, 1.10000002, 0)
					TweenService:Create(M_A_I_B,TweenInfo.new(0.02),{Size = Size}):Play()
callback(G)
				end
				return Assets
				
			end
			
			function SectionAssets:AddDropdown(DropdownName,Info,Defualt,callback)
				Info = Info or {}
				Defualt = Defualt or Info[1]
				callback = callback or function(
					
				)
					
				end
				
				local Dropdown = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local TextLabel = Instance.new("TextLabel")
				local Top = Instance.new("Frame")
				local UICorner_2 = Instance.new("UICorner")
				local Value = Instance.new("TextLabel")
				local ImgeRoa = Instance.new("ImageLabel")
				local Down = Instance.new("Frame")
				local UICorner_3 = Instance.new("UICorner")
				local DropdownList = Instance.new("ScrollingFrame")
				local UIListLayout = Instance.new("UIListLayout")
				
				UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
					DropdownList.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y)
				end)
				
				Dropdown.Name = "Dropdown"
				Dropdown.Parent = Section
				Dropdown.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
				Dropdown.BackgroundTransparency = 1.000
				Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Dropdown.BorderSizePixel = 0
				Dropdown.Size = UDim2.new(0.980000019, 0, 0, 15)
				Dropdown.ZIndex = 6

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = Dropdown

				TextLabel.Parent = Dropdown
				TextLabel.AnchorPoint = Vector2.new(0.5, 0)
				TextLabel.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
				TextLabel.BackgroundTransparency = 1.000
				TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
				TextLabel.BorderSizePixel = 0
				TextLabel.Position = UDim2.new(0.755704165, 0, 0, 0)
				TextLabel.Size = UDim2.new(0.438591719, 0, 1, 0)
				TextLabel.ZIndex = 5
				TextLabel.Font = Enum.Font.RobotoMono
				TextLabel.Text = DropdownName or "Dropdown"
				TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel.TextScaled = true
				TextLabel.TextSize = 14.000
				TextLabel.TextStrokeColor3 = Color3.fromRGB(141, 141, 141)
				TextLabel.TextStrokeTransparency = 0.860
				TextLabel.TextWrapped = true
				TextLabel.TextXAlignment = Enum.TextXAlignment.Left

				Top.Name = "Top"
				Top.Parent = Dropdown
				Top.AnchorPoint = Vector2.new(0, 0.5)
				Top.BackgroundColor3 = Color3.fromRGB(75, 0, 1)
				Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Top.BorderSizePixel = 0
				Top.Position = UDim2.new(0.0299999267, 0, 0.612500012, 0)
				Top.Size = UDim2.new(0.470000088, 0, 0.774999976, 0)
				Top.ZIndex = 6

				UICorner_2.CornerRadius = UDim.new(0, 2)
				UICorner_2.Parent = Top

				Value.Name = "Value"
				Value.Parent = Top
				Value.AnchorPoint = Vector2.new(0, 0.5)
				Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Value.BackgroundTransparency = 1.000
				Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Value.BorderSizePixel = 0
				Value.Position = UDim2.new(0.061999999, 0, 0.5, 0)
				Value.Size = UDim2.new(0.838, 0, 0.980000019, 0)
				Value.ZIndex = 6
				Value.Font = Enum.Font.RobotoMono
				Value.Text = tostring(Defualt or "None")
				Value.TextColor3 = Color3.fromRGB(255, 255, 255)
				Value.TextScaled = true
				Value.TextSize = 14.000
				Value.TextWrapped = true
				Value.TextXAlignment = Enum.TextXAlignment.Left

				ImgeRoa.Name = "ImgeRoa"
				ImgeRoa.Parent = Top
				ImgeRoa.AnchorPoint = Vector2.new(1, 0.5)
				ImgeRoa.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ImgeRoa.BackgroundTransparency = 1.000
				ImgeRoa.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ImgeRoa.BorderSizePixel = 0
				ImgeRoa.Position = UDim2.new(1, 0, 0.5, 0)
				ImgeRoa.Size = UDim2.new(0.949999988, 0, 0.949999988, 0)
				ImgeRoa.SizeConstraint = Enum.SizeConstraint.RelativeYY
				ImgeRoa.ZIndex = 6
				ImgeRoa.Image = "rbxassetid://4430382116"

				Down.Name = "Down"
				Down.Parent = Dropdown
				Down.BackgroundColor3 = Color3.fromRGB(75, 0, 1)
				Down.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Down.BorderSizePixel = 0
				Down.Position = UDim2.new(0.0299999993, 0, 1.125, 0)
				Down.Size = UDim2.new(0.469999999, 0, 0, 0)
				Down.Visible = false
				Down.ZIndex = 6

				UICorner_3.CornerRadius = UDim.new(0, 4)
				UICorner_3.Parent = Down

				DropdownList.Name = "DropdownList"
				DropdownList.Parent = Down
				DropdownList.Active = true
				DropdownList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownList.BackgroundTransparency = 1.000
				DropdownList.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownList.BorderSizePixel = 0
				DropdownList.Size = UDim2.new(1, 0, 1, 0)
				DropdownList.ZIndex = 7
				DropdownList.ScrollBarThickness = 1
				DropdownList.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 4)
				UIListLayout.Parent = DropdownList
				UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.Padding = UDim.new(0, 5)
				local function __GetDropdownSze()
					local a = 0
					
					for i,v:TextButton in ipairs(DropdownList:GetChildren()) do
						if v:isA('TextButton') then
				
							a=a+15
						end
					end
					
					return a
				end
				
				Down:GetPropertyChangedSignal('Size'):Connect(function()
					if Down.Size.Y.Offset < 5 then
						Down.Visible = false
					else
						Down.Visible = true
					end 
				end)
				
				local toglle = false
				
				local function gettggl(val)
					if val then
						TweenService:Create(TextLabel,TweenInfo.new(0.1),{TextTransparency = 0}):Play()
						TweenService:Create(ImgeRoa,TweenInfo.new(0.1),{Rotation = 180}):Play()
						TweenService:Create(Down,TweenInfo.new(0.1),{Size = UDim2.new(0.47,0,0,__GetDropdownSze())}):Play()
					else
						TweenService:Create(TextLabel,TweenInfo.new(0.1),{TextTransparency = 0.3}):Play()
						TweenService:Create(ImgeRoa,TweenInfo.new(0.1),{Rotation = 0}):Play()
						TweenService:Create(Down,TweenInfo.new(0.1),{Size = UDim2.new(0.47,0,0,0)}):Play()
					end
				end
				
				cretate_button(Top).MouseButton1Click:Connect(function()
					toglle=not toglle
					gettggl(toglle)
				end)
				
				gettggl(false)
				
				updateSize()
				
				local function reset()
					for i,v:TextButton in ipairs(DropdownList:GetChildren()) do
						if v:isA('TextButton') then

							v:Destroy()
						end
					end
					
					for i,v in ipairs(Info) do
						local TextButton = Instance.new("TextButton")
						local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

						TextButton.Parent = DropdownList
						TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						TextButton.BackgroundTransparency = 1.000
						TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
						TextButton.BorderSizePixel = 0
						TextButton.Size = UDim2.new(0.850000024, 0, 0.5, 0)
						TextButton.ZIndex = 8
						TextButton.Font = Enum.Font.RobotoMono
						TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
						TextButton.TextScaled = true
						TextButton.TextSize = 14.000
						TextButton.TextWrapped = true
						TextButton.Text = tostring(v)
						TextButton.TextTransparency = 0.3
						
						UIAspectRatioConstraint.Parent = TextButton
						UIAspectRatioConstraint.AspectRatio = 6.000
						UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize
						
						TextButton.MouseEnter:Connect(function()
							TweenService:Create(TextButton,TweenInfo.new(0.2),{TextTransparency = 0}):Play()
						end)
						
						TextButton.MouseLeave:Connect(function()
							TweenService:Create(TextButton,TweenInfo.new(0.2),{TextTransparency = 0.3}):Play()
						end)
						
						TextButton.MouseButton1Click:Connect(function()
							Value.Text = tostring(v)
							callback(v)
						end)
					end
				end
				
				reset()
				
				local Assets = {}

				function Assets:Text(a)
					TextLabel.Text = tostring(a)

				end

				function Assets:Value(G)
					Value.Text = tostring(G)
					callback(G)
				end
				
				function Assets:Refresh(da)
					Info = da or Info
					reset()
				end
				
				return Assets
			end
			
			return SectionAssets
		end
		
		return TabAssets
	end
	
	function WindowsAssets:Delete()
		BedolUIV4:Destroy()
	end
	
	local dragToggle = nil
	local dragSpeed = 0.05
	local dragStart = nil
	local startPos = nil

	local function updateInput(input)
		local delta = input.Position - dragStart
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		game:GetService('TweenService'):Create(Frame,TweenInfo.new(dragSpeed), {Position = position}):Play()
	end

	Movement.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
			dragToggle = true
			dragStart = input.Position
			startPos = Frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)
	
	InputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragToggle then
				updateInput(input)
			end
		end
	end)
	
	return WindowsAssets
end

return BedolUIV4

