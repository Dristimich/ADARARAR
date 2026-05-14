local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

math.randomseed(os.time())

for _, v in pairs(player.PlayerGui:GetChildren()) do
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

local setupCorner = Instance.new("UICorner")
setupCorner.CornerRadius = UDim.new(0,12)
setupCorner.Parent = setupFrame

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

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0,8)
inputCorner.Parent = balanceInput

local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(1,-40,0,40)
applyBtn.Position = UDim2.new(0,20,0,120)
applyBtn.BackgroundColor3 = Color3.fromRGB(59,99,246)
applyBtn.Text = "Save & Start"
applyBtn.Font = Enum.Font.GothamBold
applyBtn.TextSize = 16
applyBtn.TextColor3 = Color3.new(1,1,1)
applyBtn.Parent = setupFrame

local applyCorner = Instance.new("UICorner")
applyCorner.CornerRadius = UDim.new(0,8)
applyCorner.Parent = applyBtn

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
modal.Size = UDim2.new(0,930,0,510)
modal.Position = UDim2.new(0.5,-465,0.5,-255)
modal.BackgroundColor3 = Color3.fromRGB(17,19,28)
modal.BorderSizePixel = 0
modal.Visible = false
modal.Parent = gui

local modalCorner = Instance.new("UICorner")
modalCorner.CornerRadius = UDim.new(0,28)
modalCorner.Parent = modal

-- TITLE

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0,300,0,40)
title.Position = UDim2.new(0,45,0,40)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "Buy item"
title.TextSize = 34
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = modal

-- CLOSE

local closeBtn = Instance.new("ImageButton")
closeBtn.Size = UDim2.new(0,28,0,28)
closeBtn.Position = UDim2.new(1,-55,0,45)
closeBtn.BackgroundTransparency = 1
closeBtn.Image = "rbxassetid://78940278565096"
closeBtn.Parent = modal

-- BALANCE

local balanceFrame = Instance.new("Frame")
balanceFrame.Size = UDim2.new(0,170,0,40)
balanceFrame.Position = UDim2.new(1,-220,0,42)
balanceFrame.BackgroundTransparency = 1
balanceFrame.Parent = modal

local balanceLayout = Instance.new("UIListLayout")
balanceLayout.FillDirection = Enum.FillDirection.Horizontal
balanceLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
balanceLayout.VerticalAlignment = Enum.VerticalAlignment.Center
balanceLayout.Padding = UDim.new(0,8)
balanceLayout.Parent = balanceFrame

local balanceIcon = Instance.new("ImageLabel")
balanceIcon.Size = UDim2.new(0,26,0,26)
balanceIcon.BackgroundTransparency = 1
balanceIcon.Image = "rbxassetid://70493384532723"
balanceIcon.Parent = balanceFrame

local balanceText = Instance.new("TextLabel")
balanceText.AutomaticSize = Enum.AutomaticSize.X
balanceText.Size = UDim2.new(0,0,1,0)
balanceText.BackgroundTransparency = 1
balanceText.Font = Enum.Font.GothamMedium
balanceText.TextSize = 26
balanceText.TextColor3 = Color3.new(1,1,1)
balanceText.Text = customBalance
balanceText.Parent = balanceFrame

-- PROMPT

local promptContainer = Instance.new("Frame")
promptContainer.Size = UDim2.new(1,0,1,0)
promptContainer.BackgroundTransparency = 1
promptContainer.Parent = modal

-- ITEM NAME

local itemName = Instance.new("TextLabel")
itemName.Size = UDim2.new(0,500,0,40)
itemName.Position = UDim2.new(0,210,0,180)
itemName.BackgroundTransparency = 1
itemName.Font = Enum.Font.GothamBold
itemName.TextSize = 30
itemName.TextColor3 = Color3.new(1,1,1)
itemName.TextXAlignment = Enum.TextXAlignment.Left
itemName.Text = "Loading..."
itemName.Parent = promptContainer

-- PRICE

local priceFrame = Instance.new("Frame")
priceFrame.Size = UDim2.new(0,200,0,40)
priceFrame.Position = UDim2.new(0,210,0,245)
priceFrame.BackgroundTransparency = 1
priceFrame.Parent = promptContainer

local priceLayout = Instance.new("UIListLayout")
priceLayout.FillDirection = Enum.FillDirection.Horizontal
priceLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
priceLayout.VerticalAlignment = Enum.VerticalAlignment.Center
priceLayout.Padding = UDim.new(0,8)
priceLayout.Parent = priceFrame

local priceIcon = Instance.new("ImageLabel")
priceIcon.Size = UDim2.new(0,28,0,28)
priceIcon.BackgroundTransparency = 1
priceIcon.Image = "rbxassetid://70493384532723"
priceIcon.Parent = priceFrame

local itemPrice = Instance.new("TextLabel")
itemPrice.AutomaticSize = Enum.AutomaticSize.X
itemPrice.Size = UDim2.new(0,0,1,0)
itemPrice.BackgroundTransparency = 1
itemPrice.Font = Enum.Font.GothamMedium
itemPrice.TextSize = 28
itemPrice.TextColor3 = Color3.new(1,1,1)
itemPrice.Text = "5"
itemPrice.Parent = priceFrame

-- BUY BUTTON

local buyBtn = Instance.new("TextButton")
buyBtn.Size = UDim2.new(1,-80,0,72)
buyBtn.Position = UDim2.new(0,40,1,-110)
buyBtn.BackgroundColor3 = Color3.fromRGB(58,86,217)
buyBtn.Text = ""
buyBtn.AutoButtonColor = false
buyBtn.ClipsDescendants = true
buyBtn.Parent = promptContainer

local buyCorner = Instance.new("UICorner")
buyCorner.CornerRadius = UDim.new(0,18)
buyCorner.Parent = buyBtn

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0,0,1,0)
progressFill.BackgroundColor3 = Color3.fromRGB(44,66,170)
progressFill.BorderSizePixel = 0
progressFill.Parent = buyBtn

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0,18)
fillCorner.Parent = progressFill

local buyText = Instance.new("TextLabel")
buyText.Size = UDim2.new(1,0,1,0)
buyText.BackgroundTransparency = 1
buyText.Font = Enum.Font.GothamMedium
buyText.TextSize = 30
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
checkIcon.Size = UDim2.new(0,82,0,82)
checkIcon.Position = UDim2.new(0.5,-41,0,90)
checkIcon.BackgroundTransparency = 1
checkIcon.Image = "rbxassetid://110759125205910"
checkIcon.Parent = successContainer

local successMsg = Instance.new("TextLabel")
successMsg.Size = UDim2.new(1,-200,0,40)
successMsg.Position = UDim2.new(0,100,0,230)
successMsg.BackgroundTransparency = 1
successMsg.Font = Enum.Font.Gotham
successMsg.TextSize = 23
successMsg.TextColor3 = Color3.fromRGB(220,220,220)
successMsg.TextXAlignment = Enum.TextXAlignment.Center
successMsg.Text = ""
successMsg.Parent = successContainer

local okBtn = Instance.new("TextButton")
okBtn.Size = UDim2.new(1,-80,0,72)
okBtn.Position = UDim2.new(0,40,1,-110)
okBtn.BackgroundColor3 = Color3.fromRGB(58,86,217)
okBtn.Font = Enum.Font.GothamMedium
okBtn.Text = "OK"
okBtn.TextSize = 30
okBtn.TextColor3 = Color3.new(1,1,1)
okBtn.Parent = successContainer

local okCorner = Instance.new("UICorner")
okCorner.CornerRadius = UDim.new(0,18)
okCorner.Parent = okBtn

-- SHOW

local function ShowModal()
	overlay.Visible = true
	modal.Visible = true

	modal.BackgroundTransparency = 1

	TweenService:Create(
		overlay,
		TweenInfo.new(0.15),
		{
			BackgroundTransparency = 0.4
		}
	):Play()

	TweenService:Create(
		modal,
		TweenInfo.new(0.15),
		{
			BackgroundTransparency = 0
		}
	):Play()
end

local function HideModal()
	local t1 = TweenService:Create(
		overlay,
		TweenInfo.new(0.15),
		{
			BackgroundTransparency = 1
		}
	)

	local t2 = TweenService:Create(
		modal,
		TweenInfo.new(0.15),
		{
			BackgroundTransparency = 1
		}
	)

	t1:Play()
	t2:Play()

	t2.Completed:Wait()

	modal.Visible = false
	overlay.Visible = false
end

closeBtn.MouseButton1Click:Connect(HideModal)
okBtn.MouseButton1Click:Connect(HideModal)

applyBtn.MouseButton1Click:Connect(function()
	customBalance = balanceInput.Text
	if customBalance == "" then
		customBalance = "2,147,483,647"
	end

	balanceText.Text = customBalance
	setupFrame.Visible = false
end)

local canBuy = false
local currentTween

buyBtn.MouseButton1Click:Connect(function()
	if not canBuy then
		return
	end

	canBuy = false

	TweenService:Create(
		buyBtn,
		TweenInfo.new(0.18),
		{
			BackgroundColor3 = Color3.fromRGB(39,52,120)
		}
	):Play()

	TweenService:Create(
		progressFill,
		TweenInfo.new(0.18),
		{
			BackgroundColor3 = Color3.fromRGB(30,40,90)
		}
	):Play()

	TweenService:Create(
		buyText,
		TweenInfo.new(0.18),
		{
			TextTransparency = 0.35
		}
	):Play()

	task.wait(1.1)

	promptContainer.Visible = false

	title.Text = "Purchase completed"

	successMsg.Text =
		"You have successfully bought "..itemName.Text.."."

	successContainer.Visible = true
end)

local function fetchAndShow(id, infoType)
	title.Text = "Buy item"

	successContainer.Visible = false
	promptContainer.Visible = true

	itemName.Text = "Loading..."
	itemPrice.Text = "..."

	buyBtn.BackgroundColor3 = Color3.fromRGB(58,86,217)
	progressFill.BackgroundColor3 = Color3.fromRGB(44,66,170)
	buyText.TextTransparency = 0

	progressFill.Visible = true
	progressFill.Size = UDim2.new(0,0,1,0)

	ShowModal()

	task.spawn(function()
		local success, result = pcall(function()
			return MarketplaceService:GetProductInfo(id, infoType)
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
			3,
			Enum.EasingStyle.Linear,
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

oldNamecall = hookmetamethod(game, "__namecall", function(self,...)
	local method = getnamecallmethod()
	local args = {...}

	if self == MarketplaceService and not setupFrame.Visible then
		local id = tonumber(args[2])

		if id then
			if method == "PromptGamePassPurchase" then
				fetchAndShow(id, Enum.InfoType.GamePass)
				return
			elseif method == "PromptProductPurchase" then
				fetchAndShow(id, Enum.InfoType.Product)
				return
			elseif method == "PromptPurchase" then
				fetchAndShow(id, Enum.InfoType.Asset)
				return
			elseif method == "PromptBundlePurchase" then
				fetchAndShow(id, Enum.InfoType.Bundle)
				return
			end
		end
	end

	return oldNamecall(self,...)
end)
