Смотрю оба скриншота внимательно и выравниваю 1 в 1:
lualocal Players = game:GetService("Players")
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

local customBalance = "76"

-- SETTINGS
local setupFrame = Instance.new("Frame")
setupFrame.Size = UDim2.fromOffset(300,180)
setupFrame.Position = UDim2.new(0.5,-150,0.5,-90)
setupFrame.BackgroundColor3 = Color3.fromRGB(25,27,33)
setupFrame.BorderSizePixel = 0
setupFrame.Active = true
setupFrame.ZIndex = 50
setupFrame.Parent = gui

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
local dragging, dragInput, dragStart, startPos

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
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
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
overlay.ZIndex = 1
overlay.Parent = gui

-- MODAL — точный размер как в оригинале
local modal = Instance.new("Frame")
modal.Size = UDim2.fromOffset(435,185)
modal.Position = UDim2.new(0.5,-217,0.5,-92)
modal.BackgroundColor3 = Color3.fromRGB(17,19,28)
modal.BorderSizePixel = 0
modal.Visible = false
modal.ClipsDescendants = true
modal.ZIndex = 2
modal.Parent = gui

local constraint = Instance.new("UISizeConstraint")
constraint.MaxSize = Vector2.new(435,185)
constraint.MinSize = Vector2.new(435,185)
constraint.Parent = modal

local modalCorner = Instance.new("UICorner")
modalCorner.CornerRadius = UDim.new(0,18)
modalCorner.Parent = modal

-- TITLE — крупный жирный, левый верхний
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0,220,0,34)
title.Position = UDim2.new(0,16,0,14)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "Buy item"
title.TextSize = 24
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3
title.Parent = modal

-- CLOSE BUTTON — X в правом верхнем углу
local closeBtn = Instance.new("ImageButton")
closeBtn.Size = UDim2.fromOffset(24,24)
closeBtn.Position = UDim2.new(1,-32,0,16)
closeBtn.BackgroundTransparency = 1
closeBtn.Image = "rbxthumb://type=Asset&id=78940278565096&w=420&h=420"
closeBtn.ScaleType = Enum.ScaleType.Fit
closeBtn.ZIndex = 4
closeBtn.Parent = modal

-- BALANCE — слева от X
local balanceFrame = Instance.new("Frame")
balanceFrame.AutomaticSize = Enum.AutomaticSize.X
balanceFrame.Size = UDim2.new(0,0,0,24)
balanceFrame.AnchorPoint = Vector2.new(1,0)
balanceFrame.Position = UDim2.new(1,-62,0,18)
balanceFrame.BackgroundTransparency = 1
balanceFrame.ZIndex = 3
balanceFrame.Parent = modal

local balanceLayout = Instance.new("UIListLayout")
balanceLayout.FillDirection = Enum.FillDirection.Horizontal
balanceLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
balanceLayout.VerticalAlignment = Enum.VerticalAlignment.Center
balanceLayout.Padding = UDim.new(0,5)
balanceLayout.Parent = balanceFrame

local balanceIcon = Instance.new("ImageLabel")
balanceIcon.Size = UDim2.fromOffset(20,20)
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
balanceText.TextSize = 16
balanceText.TextColor3 = Color3.new(1,1,1)
balanceText.Text = customBalance
balanceText.ZIndex = 4
balanceText.Parent = balanceFrame

-- PROMPT CONTAINER
local promptContainer = Instance.new("Frame")
promptContainer.Size = UDim2.new(1,0,1,0)
promptContainer.BackgroundTransparency = 1
promptContainer.ZIndex = 3
promptContainer.Parent = modal

-- ITEM ICON — большой квадрат слева, как в оригинале
local itemIcon = Instance.new("ImageLabel")
itemIcon.Size = UDim2.fromOffset(64,64)
itemIcon.Position = UDim2.new(0,14,0,52)
itemIcon.BackgroundTransparency = 1
itemIcon.Image = ""
itemIcon.ScaleType = Enum.ScaleType.Fit
itemIcon.ZIndex = 3
itemIcon.Parent = promptContainer

-- ITEM NAME — справа от иконки, выровнено по верху иконки
local itemName = Instance.new("TextLabel")
itemName.Size = UDim2.new(0,280,0,28)
itemName.Position = UDim2.new(0,88,0,55)
itemName.BackgroundTransparency = 1
itemName.Font = Enum.Font.GothamBold
itemName.TextSize = 17
itemName.TextColor3 = Color3.new(1,1,1)
itemName.TextXAlignment = Enum.TextXAlignment.Left
itemName.Text = "Loading..."
itemName.ZIndex = 3
itemName.Parent = promptContainer

-- PRICE — под названием, левее
local priceFrame = Instance.new("Frame")
priceFrame.AutomaticSize = Enum.AutomaticSize.X
priceFrame.Size = UDim2.new(0,0,0,22)
priceFrame.Position = UDim2.new(0,88,0,83)
priceFrame.BackgroundTransparency = 1
priceFrame.ZIndex = 3
priceFrame.Parent = promptContainer

local priceLayout = Instance.new("UIListLayout")
priceLayout.FillDirection = Enum.FillDirection.Horizontal
priceLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
priceLayout.VerticalAlignment = Enum.VerticalAlignment.Center
priceLayout.Padding = UDim.new(0,5)
priceLayout.Parent = priceFrame

local priceIcon = Instance.new("ImageLabel")
priceIcon.Size = UDim2.fromOffset(20,20)
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
itemPrice.TextSize = 16
itemPrice.TextColor3 = Color3.new(1,1,1)
itemPrice.Text = "5"
itemPrice.ZIndex = 4
itemPrice.Parent = priceFrame

-- BUY BUTTON — полная ширина с отступом 14px с каждой стороны
local buyBtn = Instance.new("TextButton")
buyBtn.Size = UDim2.new(1,-28,0,44)
buyBtn.Position = UDim2.new(0,14,1,-56)
buyBtn.BackgroundColor3 = Color3.fromRGB(58,86,217)
buyBtn.Text = ""
buyBtn.AutoButtonColor = false
buyBtn.ClipsDescendants = true
buyBtn.ZIndex = 3
buyBtn.Parent = promptContainer

local buyCorner = Instance.new("UICorner")
buyCorner.CornerRadius = UDim.new(0,10)
buyCorner.Parent = buyBtn

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0,0,1,0)
progressFill.BackgroundColor3 = Color3.fromRGB(43,63,165)
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 4
progressFill.Parent = buyBtn

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0,9)
fillCorner.Parent = progressFill

local buyText = Instance.new("TextLabel")
buyText.Size = UDim2.new(1,0,1,0)
buyText.BackgroundTransparency = 1
buyText.Font = Enum.Font.GothamMedium
buyText.TextSize = 16
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
checkIcon.Size = UDim2.fromOffset(52,52)
checkIcon.Position = UDim2.new(0.5,-26,0,24)
checkIcon.BackgroundTransparency = 1
checkIcon.Image = "rbxthumb://type=Asset&id=110759125205910&w=420&h=420"
checkIcon.ScaleType = Enum.ScaleType.Fit
checkIcon.ZIndex = 4
checkIcon.Parent = successContainer

local successMsg = Instance.new("TextLabel")
successMsg.Size = UDim2.new(1,-40,0,18)
successMsg.Position = UDim2.new(0,20,0,80)
successMsg.BackgroundTransparency = 1
successMsg.Font = Enum.Font.Gotham
successMsg.TextSize = 12
successMsg.TextColor3 = Color3.fromRGB(200,200,200)
successMsg.TextXAlignment = Enum.TextXAlignment.Center
successMsg.Text = ""
successMsg.ZIndex = 3
successMsg.Parent = successContainer

local okBtn = Instance.new("TextButton")
okBtn.Size = UDim2.new(1,-28,0,44)
okBtn.Position = UDim2.new(0,14,1,-56)
okBtn.BackgroundColor3 = Color3.fromRGB(58,86,217)
okBtn.Font = Enum.Font.GothamMedium
okBtn.Text = "OK"
okBtn.TextSize = 16
okBtn.TextColor3 = Color3.new(1,1,1)
okBtn.ZIndex = 3
okBtn.Parent = successContainer

local okCorner = Instance.new("UICorner")
okCorner.CornerRadius = UDim.new(0,10)
okCorner.Parent = okBtn

ContentProvider:PreloadAsync({closeBtn, balanceIcon, priceIcon, checkIcon})

-- SHOW / HIDE
local function ShowModal()
	overlay.Visible = true
	modal.Visible = true
	overlay.BackgroundTransparency = 1
	modal.BackgroundTransparency = 1
	modal.Size = UDim2.fromOffset(420,175)
	modal.Position = UDim2.new(0.5,-210,0.5,-87)
	TweenService:Create(overlay, TweenInfo.new(0.12, Enum.EasingStyle.Linear), {
		BackgroundTransparency = 0.4
	}):Play()
	TweenService:Create(modal, TweenInfo.new(0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0,
		Size = UDim2.fromOffset(435,185),
		Position = UDim2.new(0.5,-217,0.5,-92)
	}):Play()
end

local function HideModal()
	modal.Visible = false
	overlay.Visible = false
end

closeBtn.MouseButton1Click:Connect(HideModal)
okBtn.MouseButton1Click:Connect(HideModal)

applyBtn.MouseButton1Click:Connect(function()
	customBalance = balanceInput.Text
	if customBalance == "" then customBalance = "76" end
	balanceText.Text = customBalance
	setupFrame.Visible = false
end)

local canBuy = false
local currentTween

buyBtn.MouseButton1Click:Connect(function()
	if not canBuy then return end
	canBuy = false
	TweenService:Create(buyBtn, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(39,52,120)}):Play()
	TweenService:Create(progressFill, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(30,40,90)}):Play()
	TweenService:Create(buyText, TweenInfo.new(0.18), {TextTransparency = 0.35}):Play()
	task.wait(1.1)
	promptContainer.Visible = false
	successContainer.Visible = true
	balanceFrame.Parent = nil
	title.Text = "Purchase completed"
	title.TextSize = 20
	successMsg.Text = "You have successfully bought " .. itemName.Text .. "."
end)

local function getThumbType(infoType)
	if infoType == Enum.InfoType.GamePass then
		return "GamePass"
	elseif infoType == Enum.InfoType.Bundle then
		return "BundleThumbnail"
	else
		return "Asset"
	end
end

local function fetchAndShow(id, infoType)
	title.Text = "Buy item"
	title.TextSize = 24
	successContainer.Visible = false
	promptContainer.Visible = true
	if not balanceFrame.Parent then
		balanceFrame.Parent = modal
	end
	itemName.Text = "Loading..."
	itemPrice.Text = "..."
	local thumbType = getThumbType(infoType)
	itemIcon.Image = "rbxthumb://type=" .. thumbType .. "&id=" .. id .. "&w=150&h=150"
	buyBtn.BackgroundColor3 = Color3.fromRGB(58,86,217)
	progressFill.BackgroundColor3 = Color3.fromRGB(43,63,165)
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
	if currentTween then currentTween:Cancel() end
	currentTween = TweenService:Create(progressFill, TweenInfo.new(3, Enum.EasingStyle.Linear), {
		Size = UDim2.new(1,0,1,0)
	})
	currentTween:Play()
	task.spawn(function()
		currentTween.Completed:Wait()
		if promptContainer.Visible then
			progressFill.Visible = false
			canBuy = true
		end
	end)
end

local oldNamecall

local ok = pcall(function()
	oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
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
		return oldNamecall(self, ...)
	end)
end)

if not ok then
	-- Fallback если executor не поддерживает hookmetamethod
	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function() end)
	
	local oldPromptGamePass = MarketplaceService.PromptGamePassPurchase
	local oldPromptProduct = MarketplaceService.PromptProductPurchase
	local oldPromptPurchase = MarketplaceService.PromptPurchase
	
	-- Тест кнопка для проверки
	local testBtn = Instance.new("TextButton")
	testBtn.Size = UDim2.fromOffset(120,40)
	testBtn.Position = UDim2.new(0,10,0,10)
	testBtn.BackgroundColor3 = Color3.fromRGB(59,99,246)
	testBtn.Text = "Test GUI"
	testBtn.Font = Enum.Font.GothamBold
	testBtn.TextSize = 14
	testBtn.TextColor3 = Color3.new(1,1,1)
	testBtn.ZIndex = 100
	testBtn.Parent = gui
	
	local tc = Instance.new("UICorner")
	tc.CornerRadius = UDim.new(0,8)
	tc.Parent = testBtn
	
	testBtn.MouseButton1Click:Connect(function()
		fetchAndShow(480738082, Enum.InfoType.Asset)
	end)
end
