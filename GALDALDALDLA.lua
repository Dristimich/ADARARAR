local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

math.randomseed(os.time())

for _,v in pairs(player:WaitForChild("PlayerGui"):GetChildren()) do
	if v.Name == "RobloxPurchaseMenu_Pro" then
		v:Destroy()
	end
end

local gui = Instance.new("ScreenGui")
gui.Name = "RobloxPurchaseMenu_Pro"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player.PlayerGui

local customBalance = "2,147,483,647"

-- SETTINGS

local setupFrame = Instance.new("Frame")
setupFrame.Size = UDim2.new(0,300,0,180)
setupFrame.Position = UDim2.new(0.5,-150,0.5,-90)
setupFrame.BackgroundColor3 = Color3.fromRGB(25,27,33)
setupFrame.BorderSizePixel = 0
setupFrame.Active = true
setupFrame.Parent = gui
setupFrame.ZIndex = 50

Instance.new("UICorner", setupFrame).CornerRadius = UDim.new(0,12)

local setupTitle = Instance.new("TextLabel")
setupTitle.Size = UDim2.new(1,0,0,40)
setupTitle.BackgroundTransparency = 1
setupTitle.Text = "Settings (Drag me)"
setupTitle.Font = Enum.Font.GothamBold
setupTitle.TextSize = 20
setupTitle.TextColor3 = Color3.new(1,1,1)
setupTitle.Parent = setupFrame

local balanceInput = Instance.new("TextBox")
balanceInput.Size = UDim2.new(1,-40,0,40)
balanceInput.Position = UDim2.new(0,20,0,60)
balanceInput.BackgroundColor3 = Color3.fromRGB(40,43,53)
balanceInput.Text = customBalance
balanceInput.PlaceholderText = "Enter fake balance"
balanceInput.Font = Enum.Font.Gotham
balanceInput.TextSize = 16
balanceInput.TextColor3 = Color3.new(1,1,1)
balanceInput.Parent = setupFrame

Instance.new("UICorner", balanceInput).CornerRadius = UDim.new(0,8)

local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(1,-40,0,40)
applyBtn.Position = UDim2.new(0,20,0,120)
applyBtn.BackgroundColor3 = Color3.fromRGB(59,99,246)
applyBtn.Text = "Save & Start"
applyBtn.Font = Enum.Font.GothamBold
applyBtn.TextSize = 16
applyBtn.TextColor3 = Color3.new(1,1,1)
applyBtn.Parent = setupFrame

Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0,8)

-- DRAG

local dragging
local dragInput
local dragStart
local startPos

setupFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = setupFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

setupFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart

		setupFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- OVERLAY

local overlay = Instance.new("TextButton")
overlay.Size = UDim2.new(1,0,1,0)
overlay.BackgroundColor3 = Color3.new(0,0,0)
overlay.BackgroundTransparency = 1
overlay.Text = ""
overlay.AutoButtonColor = false
overlay.Visible = false
overlay.Parent = gui

-- MODAL

local modal = Instance.new("Frame")
modal.Size = UDim2.new(0,480,0,250)
modal.Position = UDim2.new(0.5,-240,0.5,-125)
modal.BackgroundColor3 = Color3.fromRGB(24,25,34)
modal.BorderSizePixel = 0
modal.Visible = false
modal.Parent = gui

Instance.new("UICorner", modal).CornerRadius = UDim.new(0,16)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0,200,0,30)
title.Position = UDim2.new(0,28,0,22)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "Buy item"
title.TextSize = 20
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = modal

local closeBtn = Instance.new("ImageButton")
closeBtn.Size = UDim2.new(0,20,0,20)
closeBtn.Position = UDim2.new(1,-38,0,25)
closeBtn.BackgroundTransparency = 1
closeBtn.Image = "rbxassetid://11293981586"
closeBtn.Parent = modal

-- BALANCE

local balanceFrame = Instance.new("Frame")
balanceFrame.Size = UDim2.new(0,200,0,25)
balanceFrame.Position = UDim2.new(1,-245,0,24)
balanceFrame.BackgroundTransparency = 1
balanceFrame.Parent = modal

local balanceLayout = Instance.new("UIListLayout")
balanceLayout.FillDirection = Enum.FillDirection.Horizontal
balanceLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
balanceLayout.VerticalAlignment = Enum.VerticalAlignment.Center
balanceLayout.Padding = UDim.new(0,6)
balanceLayout.Parent = balanceFrame

local balanceIcon = Instance.new("ImageLabel")
balanceIcon.Size = UDim2.new(0,18,0,18)
balanceIcon.BackgroundTransparency = 1
balanceIcon.Image = "rbxassetid://6031091002"
balanceIcon.Parent = balanceFrame

local balanceText = Instance.new("TextLabel")
balanceText.AutomaticSize = Enum.AutomaticSize.X
balanceText.Size = UDim2.new(0,0,1,0)
balanceText.BackgroundTransparency = 1
balanceText.Font = Enum.Font.GothamMedium
balanceText.TextSize = 16
balanceText.TextColor3 = Color3.new(1,1,1)
balanceText.Text = customBalance
balanceText.Parent = balanceFrame

-- CONTENT

local promptContainer = Instance.new("Frame")
promptContainer.Size = UDim2.new(1,0,1,0)
promptContainer.BackgroundTransparency = 1
promptContainer.Parent = modal

local itemName = Instance.new("TextLabel")
itemName.Size = UDim2.new(1,-110,0,30)
itemName.Position = UDim2.new(0,55,0,85)
itemName.BackgroundTransparency = 1
itemName.Font = Enum.Font.GothamBold
itemName.TextSize = 17
itemName.TextColor3 = Color3.new(1,1,1)
itemName.TextXAlignment = Enum.TextXAlignment.Left
itemName.Text = "Loading..."
itemName.Parent = promptContainer

local priceFrame = Instance.new("Frame")
priceFrame.Size = UDim2.new(0,120,0,24)
priceFrame.Position = UDim2.new(0,55,0,118)
priceFrame.BackgroundTransparency = 1
priceFrame.Parent = promptContainer

local priceLayout = Instance.new("UIListLayout")
priceLayout.FillDirection = Enum.FillDirection.Horizontal
priceLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
priceLayout.VerticalAlignment = Enum.VerticalAlignment.Center
priceLayout.Padding = UDim.new(0,6)
priceLayout.Parent = priceFrame

local priceIcon = Instance.new("ImageLabel")
priceIcon.Size = UDim2.new(0,18,0,18)
priceIcon.BackgroundTransparency = 1
priceIcon.Image = "rbxassetid://6031091002"
priceIcon.Parent = priceFrame

local itemPrice = Instance.new("TextLabel")
itemPrice.AutomaticSize = Enum.AutomaticSize.X
itemPrice.Size = UDim2.new(0,0,1,0)
itemPrice.BackgroundTransparency = 1
itemPrice.Font = Enum.Font.GothamMedium
itemPrice.TextSize = 17
itemPrice.TextColor3 = Color3.new(1,1,1)
itemPrice.Text = "5"
itemPrice.Parent = priceFrame

-- BUY BUTTON

local buyBtn = Instance.new("TextButton")
buyBtn.Size = UDim2.new(1,-50,0,40)
buyBtn.Position = UDim2.new(0,25,1,-55)
buyBtn.BackgroundColor3 = Color3.fromRGB(58,86,217)
buyBtn.Text = ""
buyBtn.AutoButtonColor = false
buyBtn.ClipsDescendants = true
buyBtn.Parent = promptContainer

Instance.new("UICorner", buyBtn).CornerRadius = UDim.new(0,10)

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0,0,1,0)
progressFill.BackgroundColor3 = Color3.fromRGB(45,66,170)
progressFill.BorderSizePixel = 0
progressFill.Parent = buyBtn

Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0,10)

local buyText = Instance.new("TextLabel")
buyText.Size = UDim2.new(1,0,1,0)
buyText.BackgroundTransparency = 1
buyText.Font = Enum.Font.GothamMedium
buyText.TextSize = 18
buyText.Text = "Buy"
buyText.TextColor3 = Color3.new(1,1,1)
buyText.Parent = buyBtn

-- SUCCESS

local successContainer = Instance.new("Frame")
successContainer.Size = UDim2.new(1,0,1,0)
successContainer.BackgroundTransparency = 1
successContainer.Visible = false
successContainer.Parent = modal

local checkIcon = Instance.new("ImageLabel")
checkIcon.Size = UDim2.new(0,64,0,64)
checkIcon.Position = UDim2.new(0.5,-32,0,55)
checkIcon.BackgroundTransparency = 1
checkIcon.Image = "rbxassetid://6023426926"
checkIcon.Parent = successContainer

local successRobux = Instance.new("ImageLabel")
successRobux.Size = UDim2.new(0,20,0,20)
successRobux.Position = UDim2.new(0,30,0,145)
successRobux.BackgroundTransparency = 1
successRobux.Image = "rbxassetid://6031091002"
successRobux.Parent = successContainer

local successMsg = Instance.new("TextLabel")
successMsg.Size = UDim2.new(1,-120,0,25)
successMsg.Position = UDim2.new(0,70,0,143)
successMsg.BackgroundTransparency = 1
successMsg.Font = Enum.Font.Gotham
successMsg.TextSize = 16
successMsg.TextColor3 = Color3.fromRGB(220,220,220)
successMsg.TextXAlignment = Enum.TextXAlignment.Left
successMsg.Text = "Success"
successMsg.Parent = successContainer

local okBtn = Instance.new("TextButton")
okBtn.Size = UDim2.new(1,-50,0,40)
okBtn.Position = UDim2.new(0,25,1,-55)
okBtn.BackgroundColor3 = Color3.fromRGB(58,86,217)
okBtn.Font = Enum.Font.GothamMedium
okBtn.Text = "OK"
okBtn.TextSize = 18
okBtn.TextColor3 = Color3.new(1,1,1)
okBtn.Parent = successContainer

Instance.new("UICorner", okBtn).CornerRadius = UDim.new(0,10)

-- ANIMS

local function hover(btn)
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn,TweenInfo.new(0.15),{
			BackgroundColor3 = Color3.fromRGB(70,100,255)
		}):Play()
	end)

	btn.MouseLeave:Connect(function()
		TweenService:Create(btn,TweenInfo.new(0.15),{
			BackgroundColor3 = Color3.fromRGB(58,86,217)
		}):Play()
	end)
end

hover(buyBtn)
hover(okBtn)

-- OPEN/CLOSE

local function ShowModal()
	overlay.Visible = true
	modal.Visible = true

	modal.BackgroundTransparency = 1
	modal.Position = UDim2.new(0.5,-240,0.5,-120)

	TweenService:Create(
		overlay,
		TweenInfo.new(0.25,Enum.EasingStyle.Quad),
		{BackgroundTransparency = 0.45}
	):Play()

	TweenService:Create(
		modal,
		TweenInfo.new(0.25,Enum.EasingStyle.Quint),
		{
			BackgroundTransparency = 0,
			Position = UDim2.new(0.5,-240,0.5,-125)
		}
	):Play()
end

local function HideModal()
	local t = TweenService:Create(
		overlay,
		TweenInfo.new(0.2),
		{BackgroundTransparency = 1}
	)

	local t2 = TweenService:Create(
		modal,
		TweenInfo.new(0.2),
		{
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5,-240,0.5,-120)
		}
	)

	t:Play()
	t2:Play()

	t2.Completed:Wait()

	modal.Visible = false
	overlay.Visible = false
end

closeBtn.MouseButton1Click:Connect(HideModal)
okBtn.MouseButton1Click:Connect(HideModal)

applyBtn.MouseButton1Click:Connect(function()
	customBalance = balanceInput.Text
	balanceText.Text = customBalance
	setupFrame.Visible = false
end)

-- PURCHASE

local canBuy = false

buyBtn.MouseButton1Click:Connect(function()
	if not canBuy then
		return
	end

	canBuy = false

	TweenService:Create(
		buyBtn,
		TweenInfo.new(0.2),
		{
			BackgroundColor3 = Color3.fromRGB(35,35,35)
		}
	):Play()

	TweenService:Create(
		buyText,
		TweenInfo.new(0.2),
		{
			TextTransparency = 0.4
		}
	):Play()

	task.wait(1.2)

	promptContainer.Visible = false
	title.Text = "Purchase completed"

	successMsg.Text = "You have successfully bought "..itemName.Text.."."

	successContainer.Visible = true
end)

local currentTween

local function fetchAndShow(id,infoType)
	title.Text = "Buy item"

	successContainer.Visible = false
	promptContainer.Visible = true

	itemName.Text = "Loading..."
	itemPrice.Text = "..."

	buyBtn.BackgroundColor3 = Color3.fromRGB(58,86,217)
	buyText.TextTransparency = 0

	progressFill.Visible = true
	progressFill.Size = UDim2.new(0,0,1,0)

	ShowModal()

	task.spawn(function()
		local success,result = pcall(function()
			return MarketplaceService:GetProductInfo(id,infoType)
		end)

		if success and result then
			itemName.Text = result.Name or "Unknown Item"
			itemPrice.Text = tostring(result.PriceInRobux or 0)
		end
	end)

	if currentTween then
		currentTween:Cancel()
	end

	currentTween = TweenService:Create(
		progressFill,
		TweenInfo.new(
			3.2,
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out
		),
		{
			Size = UDim2.new(1,0,1,0)
		}
	)

	currentTween:Play()

	task.spawn(function()
		currentTween.Completed:Wait()

		if promptContainer.Visible then
			progressFill.Visible = false
			canBuy = true
		end
	end)
end

-- HOOK

local oldNamecall

oldNamecall = hookmetamethod(game,"__namecall",function(self,...)
	local method = getnamecallmethod()
	local args = {...}

	if self == MarketplaceService and not setupFrame.Visible then
		local id = tonumber(args[2])

		if id then
			if method == "PromptGamePassPurchase" then
				fetchAndShow(id,Enum.InfoType.GamePass)
				return
			elseif method == "PromptProductPurchase" then
				fetchAndShow(id,Enum.InfoType.Product)
				return
			elseif method == "PromptPurchase" then
				fetchAndShow(id,Enum.InfoType.Asset)
				return
			elseif method == "PromptBundlePurchase" then
				fetchAndShow(id,Enum.InfoType.Bundle)
				return
			end
		end
	end

	return oldNamecall(self,...)
end)
