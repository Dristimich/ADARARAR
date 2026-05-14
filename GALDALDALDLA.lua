local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")

local player = Players.LocalPlayer

for _,v in pairs(player.PlayerGui:GetChildren()) do
	if v.Name == "RobloxPurchaseMenu_Pro" then
		v:Destroy()
	end
end

local gui = Instance.new("ScreenGui")
gui.Name = "RobloxPurchaseMenu_Pro"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player.PlayerGui

local customBalance = "6767"

-- OVERLAY

local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1,0,1,0)
overlay.BackgroundColor3 = Color3.new(0,0,0)
overlay.BackgroundTransparency = 1
overlay.Visible = false
overlay.ZIndex = 1
overlay.Parent = gui

-- MODAL

local modal = Instance.new("Frame")
modal.Size = UDim2.fromOffset(1100, 580)
modal.Position = UDim2.new(0.5,-550,0.5,-290)
modal.BackgroundColor3 = Color3.fromRGB(8,10,20)
modal.BorderSizePixel = 0
modal.Visible = false
modal.ClipsDescendants = true
modal.ZIndex = 2
modal.Parent = gui

local modalCorner = Instance.new("UICorner")
modalCorner.CornerRadius = UDim.new(0,30)
modalCorner.Parent = modal

-- TITLE

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0,300,0,60)
title.Position = UDim2.new(0,35,0,35)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "Buy item"
title.TextSize = 38
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3
title.Parent = modal

-- CLOSE BUTTON

local closeBtn = Instance.new("ImageButton")
closeBtn.Size = UDim2.fromOffset(44,44)
closeBtn.Position = UDim2.new(1,-72,0,34)
closeBtn.BackgroundTransparency = 1
closeBtn.Image = "rbxthumb://type=Asset&id=78940278565096&w=420&h=420"
closeBtn.ScaleType = Enum.ScaleType.Fit
closeBtn.ZIndex = 4
closeBtn.Parent = modal

-- BALANCE

local balanceFrame = Instance.new("Frame")
balanceFrame.Size = UDim2.new(0,240,0,40)
balanceFrame.Position = UDim2.new(1,-320,0,38)
balanceFrame.BackgroundTransparency = 1
balanceFrame.ZIndex = 3
balanceFrame.Parent = modal

local balanceLayout = Instance.new("UIListLayout")
balanceLayout.FillDirection = Enum.FillDirection.Horizontal
balanceLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
balanceLayout.VerticalAlignment = Enum.VerticalAlignment.Center
balanceLayout.Padding = UDim.new(0,10)
balanceLayout.Parent = balanceFrame

local balanceIcon = Instance.new("ImageLabel")
balanceIcon.Size = UDim2.fromOffset(34,34)
balanceIcon.BackgroundTransparency = 1
balanceIcon.Image = "rbxthumb://type=Asset&id=70493384532723&w=420&h=420"
balanceIcon.ScaleType = Enum.ScaleType.Fit
balanceIcon.ZIndex = 4
balanceIcon.Parent = balanceFrame

local balanceText = Instance.new("TextLabel")
balanceText.AutomaticSize = Enum.AutomaticSize.X
balanceText.Size = UDim2.new(0,0,1,0)
balanceText.BackgroundTransparency = 1
balanceText.Font = Enum.Font.GothamMedium
balanceText.TextSize = 28
balanceText.TextColor3 = Color3.new(1,1,1)
balanceText.Text = customBalance
balanceText.ZIndex = 4
balanceText.Parent = balanceFrame

-- CONTENT

local promptContainer = Instance.new("Frame")
promptContainer.Size = UDim2.new(1,0,1,0)
promptContainer.BackgroundTransparency = 1
promptContainer.ZIndex = 3
promptContainer.Parent = modal

-- ITEM NAME

local itemName = Instance.new("TextLabel")
itemName.Size = UDim2.new(0,600,0,50)
itemName.Position = UDim2.new(0,165,0,220)
itemName.BackgroundTransparency = 1
itemName.Font = Enum.Font.GothamBold
itemName.TextSize = 36
itemName.TextColor3 = Color3.new(1,1,1)
itemName.TextXAlignment = Enum.TextXAlignment.Left
itemName.Text = "Cash 20000"
itemName.ZIndex = 4
itemName.Parent = promptContainer

-- PRICE

local priceFrame = Instance.new("Frame")
priceFrame.Size = UDim2.new(0,220,0,50)
priceFrame.Position = UDim2.new(0,165,0,295)
priceFrame.BackgroundTransparency = 1
priceFrame.ZIndex = 4
priceFrame.Parent = promptContainer

local priceLayout = Instance.new("UIListLayout")
priceLayout.FillDirection = Enum.FillDirection.Horizontal
priceLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
priceLayout.VerticalAlignment = Enum.VerticalAlignment.Center
priceLayout.Padding = UDim.new(0,12)
priceLayout.Parent = priceFrame

local priceIcon = Instance.new("ImageLabel")
priceIcon.Size = UDim2.fromOffset(34,34)
priceIcon.BackgroundTransparency = 1
priceIcon.Image = "rbxthumb://type=Asset&id=70493384532723&w=420&h=420"
priceIcon.ScaleType = Enum.ScaleType.Fit
priceIcon.ZIndex = 4
priceIcon.Parent = priceFrame

local itemPrice = Instance.new("TextLabel")
itemPrice.AutomaticSize = Enum.AutomaticSize.X
itemPrice.Size = UDim2.new(0,0,1,0)
itemPrice.BackgroundTransparency = 1
itemPrice.Font = Enum.Font.GothamMedium
itemPrice.TextSize = 34
itemPrice.TextColor3 = Color3.new(1,1,1)
itemPrice.Text = "199"
itemPrice.ZIndex = 4
itemPrice.Parent = priceFrame

-- BUY BUTTON

local buyBtn = Instance.new("TextButton")
buyBtn.Size = UDim2.new(1,-80,0,80)
buyBtn.Position = UDim2.new(0,40,1,-110)
buyBtn.BackgroundColor3 = Color3.fromRGB(58,86,217)
buyBtn.Text = ""
buyBtn.AutoButtonColor = false
buyBtn.ClipsDescendants = true
buyBtn.ZIndex = 3
buyBtn.Parent = promptContainer

local buyCorner = Instance.new("UICorner")
buyCorner.CornerRadius = UDim.new(0,22)
buyCorner.Parent = buyBtn

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0,0,1,0)
progressFill.BackgroundColor3 = Color3.fromRGB(46,67,170)
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 4
progressFill.Parent = buyBtn

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0,22)
fillCorner.Parent = progressFill

local buyText = Instance.new("TextLabel")
buyText.Size = UDim2.new(1,0,1,0)
buyText.BackgroundTransparency = 1
buyText.Font = Enum.Font.GothamMedium
buyText.TextSize = 34
buyText.Text = "Buy"
buyText.TextColor3 = Color3.new(1,1,1)
buyText.ZIndex = 5
buyText.Parent = buyBtn

-- SUCCESS

local successContainer = Instance.new("Frame")
successContainer.Size = UDim2.new(1,0,1,0)
successContainer.BackgroundTransparency = 1
successContainer.Visible = false
successContainer.ZIndex = 3
successContainer.Parent = modal

local checkIcon = Instance.new("ImageLabel")
checkIcon.Size = UDim2.fromOffset(110,110)
checkIcon.Position = UDim2.new(0.5,-55,0,70)
checkIcon.BackgroundTransparency = 1
checkIcon.Image = "rbxthumb://type=Asset&id=110759125205910&w=420&h=420"
checkIcon.ScaleType = Enum.ScaleType.Fit
checkIcon.ZIndex = 4
checkIcon.Parent = successContainer

local successMsg = Instance.new("TextLabel")
successMsg.Size = UDim2.new(1,-100,0,40)
successMsg.Position = UDim2.new(0,50,0,220)
successMsg.BackgroundTransparency = 1
successMsg.Font = Enum.Font.Gotham
successMsg.TextSize = 24
successMsg.TextColor3 = Color3.fromRGB(220,220,220)
successMsg.TextXAlignment = Enum.TextXAlignment.Center
successMsg.Text = ""
successMsg.ZIndex = 4
successMsg.Parent = successContainer

local okBtn = Instance.new("TextButton")
okBtn.Size = UDim2.new(1,-80,0,80)
okBtn.Position = UDim2.new(0,40,1,-110)
okBtn.BackgroundColor3 = Color3.fromRGB(58,86,217)
okBtn.Font = Enum.Font.GothamMedium
okBtn.Text = "OK"
okBtn.TextSize = 34
okBtn.TextColor3 = Color3.new(1,1,1)
okBtn.ZIndex = 4
okBtn.Parent = successContainer

local okCorner = Instance.new("UICorner")
okCorner.CornerRadius = UDim.new(0,22)
okCorner.Parent = okBtn

ContentProvider:PreloadAsync({
	closeBtn,
	balanceIcon,
	priceIcon,
	checkIcon
})

-- SHOW

local function ShowModal()
	overlay.Visible = true
	modal.Visible = true

	overlay.BackgroundTransparency = 1
	modal.BackgroundTransparency = 1

	modal.Size = UDim2.fromOffset(1040, 540)
	modal.Position = UDim2.new(0.5,-520,0.5,-270)

	TweenService:Create(
		overlay,
		TweenInfo.new(0.12, Enum.EasingStyle.Linear),
		{
			BackgroundTransparency = 0.35
		}
	):Play()

	TweenService:Create(
		modal,
		TweenInfo.new(
			0.16,
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out
		),
		{
			BackgroundTransparency = 0,
			Size = UDim2.fromOffset(1100,580),
			Position = UDim2.new(0.5,-550,0.5,-290)
		}
	):Play()
end

local function HideModal()
	modal.Visible = false
	overlay.Visible = false
end

closeBtn.MouseButton1Click:Connect(HideModal)
okBtn.MouseButton1Click:Connect(HideModal)

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
	successContainer.Visible = true

	title.Text = "Purchase completed"

	successMsg.Text =
		"You have successfully bought "..itemName.Text.."."
end)

local function fetchAndShow(id, infoType)
	title.Text = "Buy item"

	successContainer.Visible = false
	promptContainer.Visible = true

	itemName.Text = "Loading..."
	itemPrice.Text = "..."

	buyBtn.BackgroundColor3 = Color3.fromRGB(58,86,217)
	progressFill.BackgroundColor3 = Color3.fromRGB(46,67,170)

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
			Enum.EasingStyle.Linear
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

	local id = tonumber(args[2])

	if self == MarketplaceService and id then
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

	return oldNamecall(self,...)
end)
