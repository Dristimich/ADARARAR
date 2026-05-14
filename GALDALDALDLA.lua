local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Создаем ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "RobloxPurchaseMenu_Pro"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local customBalance = "62"

--------------------------------------------------
-- 1. СТАРТОВОЕ МЕНЮ (ПЕРЕТАСКИВАЕМОЕ)
--------------------------------------------------
local setupFrame = Instance.new("Frame")
setupFrame.Size = UDim2.new(0, 300, 0, 180)
setupFrame.AnchorPoint = Vector2.new(0.5, 0.5)
setupFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
setupFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
setupFrame.BorderSizePixel = 0
setupFrame.Active = true
setupFrame.Parent = gui

local setupCorner = Instance.new("UICorner")
setupCorner.CornerRadius = UDim.new(0, 12)
setupCorner.Parent = setupFrame

local setupTitle = Instance.new("TextLabel")
setupTitle.Size = UDim2.new(1, 0, 0, 40)
setupTitle.Text = "Settings (Drag me)"
setupTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
setupTitle.TextSize = 20
setupTitle.Font = Enum.Font.BuilderSansExtraBold
setupTitle.BackgroundTransparency = 1
setupTitle.Parent = setupFrame

local balanceInput = Instance.new("TextBox")
balanceInput.Size = UDim2.new(1, -40, 0, 40)
balanceInput.Position = UDim2.new(0, 20, 0, 60)
balanceInput.PlaceholderText = "Enter fake balance (e.g. 10000)"
balanceInput.Text = "62"
balanceInput.BackgroundColor3 = Color3.fromRGB(40, 43, 53)
balanceInput.TextColor3 = Color3.fromRGB(255, 255, 255)
balanceInput.Font = Enum.Font.BuilderSans
balanceInput.TextSize = 16
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
applyBtn.Font = Enum.Font.BuilderSansBold
applyBtn.TextSize = 16
applyBtn.Parent = setupFrame

local applyCorner = Instance.new("UICorner")
applyCorner.CornerRadius = UDim.new(0, 8)
applyCorner.Parent = applyBtn

-- Перетаскивание
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

--------------------------------------------------
-- 2. ГЛАВНОЕ ФЕЙК-МЕНЮ (ИДЕАЛЬНОЕ ВЫРАВНИВАНИЕ)
--------------------------------------------------
local overlay = Instance.new("TextButton")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.5
overlay.Text = ""
overlay.AutoButtonColor = false
overlay.Visible = false
overlay.Parent = gui

local modal = Instance.new("Frame")
modal.Size = UDim2.new(0, 480, 0, 260)
modal.AnchorPoint = Vector2.new(0.5, 0.5)
modal.Position = UDim2.new(0.5, 0, 0.5, 0)
modal.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
modal.Visible = false
modal.Parent = gui

local modalCorner = Instance.new("UICorner")
modalCorner.CornerRadius = UDim.new(0, 14)
modalCorner.Parent = modal

-- Заголовок "Buy item"
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 200, 0, 30)
title.Position = UDim2.new(0, 20, 0, 20)
title.Text = "Buy item"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 22
title.Font = Enum.Font.BuilderSansBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.Parent = modal

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 20)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
closeBtn.TextSize = 22
closeBtn.Font = Enum.Font.Gotham
closeBtn.BackgroundTransparency = 1
closeBtn.Parent = modal

-- Баланс сверху справа
local balanceContainer = Instance.new("Frame")
balanceContainer.Size = UDim2.new(0, 150, 0, 30)
balanceContainer.Position = UDim2.new(1, -195, 0, 20)
balanceContainer.BackgroundTransparency = 1
balanceContainer.Parent = modal

local balanceLayout = Instance.new("UIListLayout", balanceContainer)
balanceLayout.FillDirection = Enum.FillDirection.Horizontal
balanceLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
balanceLayout.VerticalAlignment = Enum.VerticalAlignment.Center
balanceLayout.Padding = UDim.new(0, 5)

local balanceIcon = Instance.new("ImageLabel", balanceContainer)
balanceIcon.Size = UDim2.new(0, 20, 0, 20)
balanceIcon.BackgroundTransparency = 1
balanceIcon.Image = "rbxassetid://13087340654"

local balanceText = Instance.new("TextLabel", balanceContainer)
balanceText.AutomaticSize = Enum.AutomaticSize.X
balanceText.Size = UDim2.new(0, 0, 1, 0)
balanceText.Text = "62"
balanceText.TextColor3 = Color3.fromRGB(255, 255, 255)
balanceText.TextSize = 18
balanceText.Font = Enum.Font.BuilderSansMedium
balanceText.BackgroundTransparency = 1

-- ЦЕНТР: Название товара и цена (Идеально выровненные)
local itemInfoContainer = Instance.new("Frame")
itemInfoContainer.Size = UDim2.new(0, 300, 0, 60)
itemInfoContainer.AnchorPoint = Vector2.new(0.5, 0.5)
itemInfoContainer.Position = UDim2.new(0.5, 0, 0.45, 0)
itemInfoContainer.BackgroundTransparency = 1
itemInfoContainer.Parent = modal

local itemInfoLayout = Instance.new("UIListLayout", itemInfoContainer)
itemInfoLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
itemInfoLayout.SortOrder = Enum.SortOrder.LayoutOrder
itemInfoLayout.Padding = UDim.new(0, 5)

local itemName = Instance.new("TextLabel", itemInfoContainer)
itemName.Size = UDim2.new(1, 0, 0, 25)
itemName.Text = "Loading..."
itemName.TextColor3 = Color3.fromRGB(255, 255, 255)
itemName.TextSize = 18
itemName.Font = Enum.Font.BuilderSansBold
itemName.TextXAlignment = Enum.TextXAlignment.Center
itemName.BackgroundTransparency = 1
itemName.LayoutOrder = 1

local priceContainer = Instance.new("Frame", itemInfoContainer)
priceContainer.Size = UDim2.new(1, 0, 0, 25)
priceContainer.BackgroundTransparency = 1
priceContainer.LayoutOrder = 2

local priceLayout = Instance.new("UIListLayout", priceContainer)
priceLayout.FillDirection = Enum.FillDirection.Horizontal
priceLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
priceLayout.VerticalAlignment = Enum.VerticalAlignment.Center
priceLayout.Padding = UDim.new(0, 5)

local priceIcon = Instance.new("ImageLabel", priceContainer)
priceIcon.Size = UDim2.new(0, 18, 0, 18)
priceIcon.BackgroundTransparency = 1
priceIcon.Image = "rbxassetid://13087340654"

local itemPrice = Instance.new("TextLabel", priceContainer)
itemPrice.AutomaticSize = Enum.AutomaticSize.X
itemPrice.Size = UDim2.new(0, 0, 1, 0)
itemPrice.Text = "..."
itemPrice.TextColor3 = Color3.fromRGB(255, 255, 255)
itemPrice.TextSize = 18
itemPrice.Font = Enum.Font.BuilderSansBold
itemPrice.BackgroundTransparency = 1

--------------------------------------------------
-- 3. КНОПКА ПОКУПКИ И АНИМАЦИЯ (1.5 сек)
--------------------------------------------------
local buyBtnBase = Instance.new("TextButton")
buyBtnBase.Size = UDim2.new(1, -40, 0, 48)
buyBtnBase.Position = UDim2.new(0, 20, 1, -85)
buyBtnBase.Text = "" 
-- ТЕМНО СИНИЙ по умолчанию (до нажатия)
buyBtnBase.BackgroundColor3 = Color3.fromRGB(36, 59, 146)
buyBtnBase.AutoButtonColor = false
buyBtnBase.ClipsDescendants = true
buyBtnBase.Parent = modal

local baseCorner = Instance.new("UICorner")
baseCorner.CornerRadius = UDim.new(0, 10)
baseCorner.Parent = buyBtnBase

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.Position = UDim2.new(0, 0, 0, 0)
-- СВЕТЛО СИНИЙ для ползунка
progressFill.BackgroundColor3 = Color3.fromRGB(59, 99, 246)
progressFill.BorderSizePixel = 0
progressFill.Visible = false
progressFill.Parent = buyBtnBase

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 10)
fillCorner.Parent = progressFill

local buyTextLabel = Instance.new("TextLabel")
buyTextLabel.Size = UDim2.new(1, 0, 1, 0)
buyTextLabel.Text = "Buy"
buyTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
buyTextLabel.Font = Enum.Font.BuilderSansBold
buyTextLabel.TextSize = 18
buyTextLabel.BackgroundTransparency = 1
buyTextLabel.ZIndex = 2
buyTextLabel.Parent = buyBtnBase

local testInfoText = Instance.new("TextLabel")
testInfoText.Size = UDim2.new(1, 0, 0, 20)
testInfoText.Position = UDim2.new(0, 0, 1, -30)
testInfoText.Text = "This is a test purchase. Your account will not be charged."
testInfoText.TextColor3 = Color3.fromRGB(120, 120, 120)
testInfoText.TextSize = 12
testInfoText.Font = Enum.Font.BuilderSans
testInfoText.BackgroundTransparency = 1
testInfoText.Parent = modal

--------------------------------------------------
-- 4. ЛОГИКА ОТОБРАЖЕНИЯ И КНОПОК
--------------------------------------------------
applyBtn.MouseButton1Click:Connect(function()
    customBalance = balanceInput.Text
    if customBalance == "" then customBalance = "62" end
    balanceText.Text = customBalance
    setupFrame.Visible = false
end)

local function ShowModal(name, price)
    itemName.Text = name or "Loading..."
    itemPrice.Text = price and tostring(price) or "..."
    
    -- Сброс состояния кнопки
    buyBtnBase.BackgroundColor3 = Color3.fromRGB(36, 59, 146)
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.Visible = false
    buyTextLabel.Text = "Buy"
    
    overlay.Visible = true
    modal.Visible = true
end

local function HideModal()
    modal.Visible = false
    overlay.Visible = false
end

overlay.MouseButton1Click:Connect(HideModal)
closeBtn.MouseButton1Click:Connect(HideModal)

local isProcessing = false

buyBtnBase.MouseButton1Click:Connect(function()
    if isProcessing then return end
    isProcessing = true
    
    progressFill.Visible = true
    
    -- Анимация заполнения ровно 1.5 секунды
    local tween = TweenService:Create(progressFill, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
    tween:Play()
    tween.Completed:Wait() -- Ждем 1.5 сек
    
    -- После заполнения делаем саму кнопку полностью светло-синей и меняем текст
    buyBtnBase.BackgroundColor3 = Color3.fromRGB(59, 99, 246)
    progressFill.Visible = false -- Убираем ползунок, так как кнопка уже закрасилась
    buyTextLabel.Text = "Purchased!"
    
    task.wait(1.5) -- Ждем еще секунду, чтобы игрок увидел успех
    HideModal()
    isProcessing = false
end)

local function fetchAndShow(id, infoType)
    ShowModal("Loading...", "...") 
    task.spawn(function()
        local success, info = pcall(function()
            return MarketplaceService:GetProductInfo(id, infoType)
        end)
        if success and info then
            itemName.Text = info.Name
            itemPrice.Text = tostring(info.PriceInRobux or 0)
        else
            itemName.Text = "Unknown Item"
            itemPrice.Text = "???"
        end
    end)
end

--------------------------------------------------
-- 5. ТОЧНЫЙ ПЕРЕХВАТ ОРИГИНАЛЬНОГО МЕНЮ
--------------------------------------------------
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if self == MarketplaceService and not setupFrame.Visible then
        -- Точно определяем тип, чтобы избежать "Unknown Item"
        if method == "PromptGamePassPurchase" then
            fetchAndShow(args[2], Enum.InfoType.GamePass)
            return
        elseif method == "PromptProductPurchase" then
            fetchAndShow(args[2], Enum.InfoType.Product)
            return
        elseif method == "PromptPurchase" then
            fetchAndShow(args[2], Enum.InfoType.Asset)
            return
        elseif method == "PromptBundlePurchase" then
            fetchAndShow(args[2], Enum.InfoType.Bundle)
            return
        end
    end
    
    return oldNamecall(self, ...)
end)
