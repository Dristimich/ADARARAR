local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Точный рандомизатор
math.randomseed(os.time())

-- УБИВАЕМ СТАРУЮ ВЕРСИЮ
for _, v in pairs(player:WaitForChild("PlayerGui"):GetChildren()) do
	if v.Name == "RobloxPurchaseMenu_Pro" then
		v:Destroy()
	end
end

-- Создаем ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "RobloxPurchaseMenu_Pro"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local customBalance = "623"

-- 1. СТАРТОВОЕ МЕНЮ (НАСТРОЙКИ)
local setupFrame = Instance.new("Frame")
setupFrame.Size = UDim2.new(0, 300, 0, 180)
setupFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
setupFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
setupFrame.BorderSizePixel = 0
setupFrame.Active = true
setupFrame.ZIndex = 50
setupFrame.Parent = gui

local setupCorner = Instance.new("UICorner")
setupCorner.CornerRadius = UDim.new(0, 12)
setupCorner.Parent = setupFrame

local setupTitle = Instance.new("TextLabel")
setupTitle.Size = UDim2.new(1, 0, 0, 40)
setupTitle.Text = "Settings (Drag me)"
setupTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
setupTitle.TextSize = 20
setupTitle.Font = Enum.Font.GothamBold
setupTitle.BackgroundTransparency = 1
setupTitle.ZIndex = 51
setupTitle.Parent = setupFrame

local balanceInput = Instance.new("TextBox")
balanceInput.Size = UDim2.new(1, -40, 0, 40)
balanceInput.Position = UDim2.new(0, 20, 0, 60)
balanceInput.PlaceholderText = "Enter fake balance"
balanceInput.Text = "2,147,483,647"
balanceInput.BackgroundColor3 = Color3.fromRGB(40, 43, 53)
balanceInput.TextColor3 = Color3.fromRGB(255, 255, 255)
balanceInput.Font = Enum.Font.Gotham
balanceInput.TextSize = 16
balanceInput.ZIndex = 51
balanceInput.Parent = setupFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = balanceInput

local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(1, -40, 0, 40)
applyBtn.Position = UDim2.new(0, 20, 0, 120)
applyBtn.Text = "Save & Start"
applyBtn.BackgroundColor3 = Color3.fromRGB(59, 99, 246)
applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applyBtn.Font = Enum.Font.GothamBold
applyBtn.TextSize = 16
applyBtn.ZIndex = 51
applyBtn.Parent = setupFrame

local applyCorner = Instance.new("UICorner")
applyCorner.CornerRadius = UDim.new(0, 8)
applyCorner.Parent = applyBtn

-- Перетаскивание меню настроек
local dragging, dragInput, dragStart, startPos
setupFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = setupFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
setupFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		setupFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- 2. ГЛАВНОЕ МЕНЮ ПОКУПКИ
local overlay = Instance.new("TextButton")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.5
overlay.Text = ""
overlay.AutoButtonColor = false
overlay.Active = true -- Блокирует клики по игре
overlay.Visible = false
overlay.ZIndex = 1
overlay.Parent = gui

local modal = Instance.new("Frame")
modal.Size = UDim2.new(0, 480, 0, 230)
modal.Position = UDim2.new(0.5, -240, 0.5, -115)
modal.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
modal.Visible = false
modal.ZIndex = 2
modal.Parent = gui

local modalCorner = Instance.new("UICorner")
modalCorner.CornerRadius = UDim.new(0, 14)
modalCorner.Parent = modal

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 300, 0, 30)
title.Position = UDim2.new(0, 25, 0, 20)
title.Text = "Buy item"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.ZIndex = 3
title.Parent = modal

-- КРЕСТИК (Отдельно привязан к modal с ZIndex = 10)
local closeBtn = Instance.new("ImageButton")
closeBtn.Size = UDim2.new(0, 16, 0, 16)
closeBtn.Position = UDim2.new(1, -35, 0, 27)
closeBtn.BackgroundTransparency = 1
closeBtn.Image = "rbxassetid://78940278565096"
closeBtn.ZIndex = 10
closeBtn.Parent = modal

-- БАЛАНС РОБУКСОВ (ТЕКСТ)
local balanceText = Instance.new("TextLabel")
balanceText.AnchorPoint = Vector2.new(1, 0)
balanceText.Size = UDim2.new(0, 100, 0, 30)
balanceText.Position = UDim2.new(1, -45, 0, 20)
balanceText.Text = "623"
balanceText.TextColor3 = Color3.fromRGB(255, 255, 255)
balanceText.TextSize = 18
balanceText.Font = Enum.Font.GothamMedium
balanceText.TextXAlignment = Enum.TextXAlignment.Right
balanceText.BackgroundTransparency = 1
balanceText.ZIndex = 5
balanceText.Parent = modal

-- РОБУКСЫ БАЛАНС (ИКОНКА)
local balanceIcon = Instance.new("ImageLabel")
balanceIcon.Size = UDim2.new(0, 20, 0, 20)
balanceIcon.BackgroundTransparency = 1
balanceIcon.Image = "rbxassetid://70493384532723"
balanceIcon.ZIndex = 10
balanceIcon.Parent = modal

-- КОНТЕЙНЕР ПОКУПКИ
local promptContainer = Instance.new("Frame")
promptContainer.Size = UDim2.new(1, 0, 1, 0)
promptContainer.BackgroundTransparency = 1
promptContainer.Visible = false
promptContainer.ZIndex = 3
promptContainer.Parent = modal

local itemName = Instance.new("TextLabel", promptContainer)
itemName.Size = UDim2.new(0, 300, 0, 25)
itemName.Position = UDim2.new(0, 105, 0, 80)
itemName.Text = "Loading..."
itemName.TextColor3 = Color3.fromRGB(255, 255, 255)
itemName.TextSize = 18
itemName.Font = Enum.Font.GothamBold
itemName.TextXAlignment = Enum.TextXAlignment.Left
itemName.BackgroundTransparency = 1
itemName.ZIndex = 5

-- РОБУКСЫ ЦЕНА (ИКОНКА)
local priceIcon = Instance.new("ImageLabel", promptContainer)
priceIcon.Size = UDim2.new(0, 18, 0, 18)
priceIcon.Position = UDim2.new(0, 105, 0, 111)
priceIcon.BackgroundTransparency = 1
priceIcon.Image = "rbxassetid://70493384532723"
priceIcon.ZIndex = 10

local itemPrice = Instance.new("TextLabel", promptContainer)
itemPrice.Size = UDim2.new(0, 100, 0, 25)
itemPrice.Position = UDim2.new(0, 130, 0, 107)
itemPrice.Text = "..."
itemPrice.TextColor3 = Color3.fromRGB(255, 255, 255)
itemPrice.TextSize = 18
itemPrice.Font = Enum.Font.GothamMedium
itemPrice.TextXAlignment = Enum.TextXAlignment.Left
itemPrice.BackgroundTransparency = 1
itemPrice.ZIndex = 5

-- КНОПКА ПОКУПКИ (СМЕЩЕНА ЧУТЬ ВНИЗ ТАК КАК ТЕКСТА БОЛЬШЕ НЕТ)
local buyBtnBase = Instance.new("TextButton", promptContainer)
buyBtnBase.Size = UDim2.new(1, -40, 0, 48)
buyBtnBase.Position = UDim2.new(0, 20, 1, -68) 
buyBtnBase.Text = ""
buyBtnBase.BackgroundColor3 = Color3.fromRGB(36, 59, 146) 
buyBtnBase.AutoButtonColor = false
buyBtnBase.ClipsDescendants = true
buyBtnBase.ZIndex = 4

local baseCorner = Instance.new("UICorner", buyBtnBase)
baseCorner.CornerRadius = UDim.new(0, 10)

-- Полоска загрузки
local progressFill = Instance.new("Frame", buyBtnBase)
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.Position = UDim2.new(0, 0, 0, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(59, 99, 246)
progressFill.BorderSizePixel = 0
progressFill.Visible = false
progressFill.ZIndex = 5

local fillCorner = Instance.new("UICorner", progressFill)
fillCorner.CornerRadius = UDim.new(0, 10)

local buyTextLabel = Instance.new("TextLabel", buyBtnBase)
buyTextLabel.Size = UDim2.new(1, 0, 1, 0)
buyTextLabel.Text = "Buy"
buyTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
buyTextLabel.Font = Enum.Font.GothamMedium
buyTextLabel.TextSize = 18
buyTextLabel.BackgroundTransparency = 1
buyTextLabel.ZIndex = 6

-- КОНТЕЙНЕР УСПЕХА (Галочка)
local successContainer = Instance.new("Frame")
successContainer.Size = UDim2.new(1, 0, 1, 0)
successContainer.BackgroundTransparency = 1
successContainer.Visible = false
successContainer.ZIndex = 3
successContainer.Parent = modal

-- ГАЛОЧКА (ZIndex = 10)
local checkIcon = Instance.new("ImageLabel", successContainer)
checkIcon.Size = UDim2.new(0, 50, 0, 50)
checkIcon.AnchorPoint = Vector2.new(0.5, 0)
checkIcon.Position = UDim2.new(0.5, 0, 0, 60)
checkIcon.BackgroundTransparency = 1
checkIcon.Image = "rbxassetid://110759125205910"
checkIcon.ZIndex = 10

local successMsg = Instance.new("TextLabel", successContainer)
successMsg.Size = UDim2.new(1, -40, 0, 25)
successMsg.Position = UDim2.new(0, 20, 0, 120)
successMsg.Text = "You have successfully bought ..."
successMsg.TextColor3 = Color3.fromRGB(210, 210, 210)
successMsg.TextSize = 16
successMsg.Font = Enum.Font.Gotham
successMsg.TextXAlignment = Enum.TextXAlignment.Center
successMsg.BackgroundTransparency = 1
successMsg.ZIndex = 5

local okBtn = Instance.new("TextButton", successContainer)
okBtn.Size = UDim2.new(1, -40, 0, 48)
okBtn.Position = UDim2.new(0, 20, 1, -68)
okBtn.Text = "OK"
okBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
okBtn.BackgroundColor3 = Color3.fromRGB(59, 99, 246)
okBtn.Font = Enum.Font.GothamMedium
okBtn.TextSize = 18
okBtn.ZIndex = 5

local okCorner = Instance.new("UICorner", okBtn)
okCorner.CornerRadius = UDim.new(0, 10)

-- 4. ЛОГИКА
applyBtn.MouseButton1Click:Connect(function()
	customBalance = balanceInput.Text
	if customBalance == "" then customBalance = "623" end
	balanceText.Text = customBalance
	
	-- Идеальное выравнивание иконки робуксов левее баланса
	local textWidth = balanceText.TextBounds.X
	balanceIcon.Position = UDim2.new(1, -textWidth - 70, 0, 25)
	
	setupFrame.Visible = false
end)

local function HideModal()
	modal.Visible = false
	overlay.Visible = false
end

-- ВНИМАНИЕ: УДАЛЕН КЛИК ПО OVERLAY! ТЕПЕРЬ МЕНЮ НЕ ЗАКРЫВАЕТСЯ ПРИ КЛИКЕ НА ФОН!
closeBtn.MouseButton1Click:Connect(HideModal)
okBtn.MouseButton1Click:Connect(HideModal)

local canBuy = false
local isProcessing = false
local currentTween = nil

-- КЛИК ПО КНОПКЕ BUY
buyBtnBase.MouseButton1Click:Connect(function()
	if not canBuy or isProcessing then return end
	isProcessing = true

	-- Эффект нажатия
	buyBtnBase.BackgroundColor3 = Color3.fromRGB(36, 59, 146)
	buyTextLabel.TextColor3 = Color3.fromRGB(180, 180, 180)

	-- ЗАДЕРЖКА СТРОГО ОТ 1.25 ДО 1.75 СЕК
	local randomWaitTime = math.random(125, 175) / 100 
	task.wait(randomWaitTime)

	-- Меняем интерфейс
	promptContainer.Visible = false
	balanceText.Visible = false
	balanceIcon.Visible = false
	
	title.Text = "Purchase completed"

	local safeName = (itemName.Text ~= "Unknown Item" and itemName.Text ~= "Loading...") and itemName.Text or "Item"
	successMsg.Text = "You have successfully bought " .. safeName .. "."
	successContainer.Visible = true
end)

local function fetchAndShow(id, infoType)
	title.Text = "Buy item"
	
	promptContainer.Visible = false
	successContainer.Visible = false
	balanceText.Visible = true
	balanceIcon.Visible = true
	canBuy = false
	isProcessing = false
	itemName.Text = "Loading..."
	itemPrice.Text = "..."

	-- Сброс кнопки
	buyTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	buyBtnBase.BackgroundColor3 = Color3.fromRGB(36, 59, 146)
	progressFill.Size = UDim2.new(0, 0, 1, 0)
	progressFill.Visible = true

	overlay.Visible = true
	modal.Visible = true
	promptContainer.Visible = true

	-- Получение данных товара
	task.spawn(function()
		local success, result = pcall(function()
			return MarketplaceService:GetProductInfo(id, infoType)
		end)
		if success and result and result.Name then
			itemName.Text = result.Name
			itemPrice.Text = tostring(result.PriceInRobux or 0)
		else
			itemName.Text = "Unknown Item"
			itemPrice.Text = "???"
		end
	end)

	-- Полоска (3 секунды)
	if currentTween then currentTween:Cancel() end
	currentTween = TweenService:Create(progressFill, TweenInfo.new(3.0, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
	currentTween:Play()

	task.spawn(function()
		currentTween.Completed:Wait()
		if promptContainer.Visible then
			progressFill.Visible = false
			buyBtnBase.BackgroundColor3 = Color3.fromRGB(59, 99, 246)
			canBuy = true
		end
	end)
end

-- ПЕРЕХВАТ ОРИГИНАЛЬНОГО МЕНЮ
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
	local method = getnamecallmethod()
	local args = {...}

	if self == MarketplaceService and not setupFrame.Visible then
		local id = tonumber(args[2])
		if not id then return oldNamecall(self, ...) end

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

	return oldNamecall(self, ...)
end)
