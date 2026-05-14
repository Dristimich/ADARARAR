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
setupFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 38)
setupFrame.BorderSizePixel = 0
setupFrame.Active = true
setupFrame.Parent = gui

local setupCorner = Instance.new("UICorner")
setupCorner.CornerRadius = UDim.new(0, 12)
setupCorner.Parent = setupFrame

local setupStroke = Instance.new("UIStroke", setupFrame)
setupStroke.Color = Color3.fromRGB(60, 60, 65)
setupStroke.Thickness = 1

local setupTitle = Instance.new("TextLabel")
setupTitle.Size = UDim2.new(1, 0, 0, 40)
setupTitle.Text = "Settings (Drag me)"
setupTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
setupTitle.TextSize = 18
setupTitle.Font = Enum.Font.BuilderSansExtraBold
setupTitle.BackgroundTransparency = 1
setupTitle.Parent = setupFrame

local balanceInput = Instance.new("TextBox")
balanceInput.Size = UDim2.new(1, -40, 0, 40)
balanceInput.Position = UDim2.new(0, 20, 0, 60)
balanceInput.PlaceholderText = "Enter fake balance (e.g. 10000)"
balanceInput.Text = "62"
balanceInput.BackgroundColor3 = Color3.fromRGB(45, 48, 56)
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

-- Функция перетаскивания (Drag)
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
-- 2. ГЛАВНОЕ ФЕЙК-МЕНЮ
--------------------------------------------------
local overlay = Instance.new("TextButton")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 1 
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

local modalStroke = Instance.new("UIStroke", modal)
modalStroke.Color = Color3.fromRGB(50, 50, 55)
modalStroke.Thickness = 1

local modalScale = Instance.new("UIScale", modal)
modalScale.Scale = 0.8

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 20)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
closeBtn.TextSize = 22
closeBtn.Font = Enum.Font.Gotham
closeBtn.BackgroundTransparency = 1
closeBtn.ZIndex = 10
closeBtn.Parent = modal

local balanceText = Instance.new("TextLabel")
balanceText.Size = UDim2.new(0, 60, 0, 30)
balanceText.Position = UDim2.new(1, -115, 0, 20)
balanceText.Text = "62"
balanceText.TextColor3 = Color3.fromRGB(255, 255, 255)
balanceText.TextSize = 18
balanceText.Font = Enum.Font.BuilderSansMedium
balanceText.TextXAlignment = Enum.TextXAlignment.Right
balanceText.BackgroundTransparency = 1
balanceText.Parent = modal

local balanceIcon = Instance.new("ImageLabel")
balanceIcon.Size = UDim2.new(0, 20, 0, 20)
balanceIcon.Position = UDim2.new(1, -145, 0, 25)
balanceIcon.BackgroundTransparency = 1
balanceIcon.Image = "rbxassetid://13087340654"
balanceIcon.Parent = modal

--------------------------------------------------
-- 3. СОСТОЯНИЯ ОКНА
--------------------------------------------------
-- [СОСТОЯНИЕ 1] Меню покупки (Появляется мгновенно)
local promptContainer = Instance.new("Frame")
promptContainer.Size = UDim2.new(1, 0, 1, 0)
promptContainer.BackgroundTransparency = 1
promptContainer.Visible = false
promptContainer.Parent = modal

local title = Instance.new("TextLabel", promptContainer)
title.Size = UDim2.new(0, 200, 0, 30)
title.Position = UDim2.new(0, 20, 0, 20)
title.Text = "Buy item"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 22
title.Font = Enum.Font.BuilderSansBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1

local itemName = Instance.new("TextLabel", promptContainer)
itemName.Size = UDim2.new(1, -40, 0, 25)
itemName.Position = UDim2.new(0, 20, 0, 85)
itemName.Text = "Loading..."
itemName.TextColor3 = Color3.fromRGB(255, 255, 255)
itemName.TextSize = 18
itemName.Font = Enum.Font.BuilderSansBold
itemName.TextXAlignment = Enum.TextXAlignment.Center
itemName.BackgroundTransparency = 1

local priceContainer = Instance.new("Frame", promptContainer)
priceContainer.Size = UDim2.new(1, 0, 0, 25)
priceContainer.Position = UDim2.new(0, 0, 0, 115)
priceContainer.BackgroundTransparency = 1

local priceLayout = Instance.new("UIListLayout", priceContainer)
priceLayout.FillDirection = Enum.FillDirection.Horizontal
priceLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
priceLayout.VerticalAlignment = Enum.VerticalAlignment.Center
priceLayout.SortOrder = Enum.SortOrder.LayoutOrder
priceLayout.Padding = UDim.new(0, 5)

local priceIcon = Instance.new("ImageLabel", priceContainer)
priceIcon.Size = UDim2.new(0, 20, 0, 20)
priceIcon.BackgroundTransparency = 1
priceIcon.Image = "rbxassetid://13087340654"
priceIcon.LayoutOrder = 1

local itemPrice = Instance.new("TextLabel", priceContainer)
itemPrice.Size = UDim2.new(0, 0, 1, 0)
itemPrice.AutomaticSize = Enum.AutomaticSize.X
itemPrice.Text = "..."
itemPrice.TextColor3 = Color3.fromRGB(255, 255, 255)
itemPrice.TextSize = 18
itemPrice.Font = Enum.Font.BuilderSansBold
itemPrice.BackgroundTransparency = 1
itemPrice.LayoutOrder = 2

--------------------------------------------------
-- КНОПКА ПОКУПКИ С АВТО-ЗАПОЛНЕНИЕМ
--------------------------------------------------
local buyBtn = Instance.new("TextButton", promptContainer)
buyBtn.Size = UDim2.new(1, -40, 0, 45)
buyBtn.Position = UDim2.new(0, 20, 1, -85)
buyBtn.Text = ""
buyBtn.BackgroundColor3 = Color3.fromRGB(35, 40, 50) -- Изначально темная
buyBtn.AutoButtonColor = false
buyBtn.ClipsDescendants = true

local buyCorner = Instance.new("UICorner", buyBtn)
buyCorner.CornerRadius = UDim.new(0, 8)

-- Ползунок, который будет заполняться
local buyFill = Instance.new("Frame", buyBtn)
buyFill.Size = UDim2.new(0, 0, 1, 0)
buyFill.BackgroundColor3 = Color3.fromRGB(59, 99, 246)
buyFill.BorderSizePixel = 0

local buyFillCorner = Instance.new("UICorner", buyFill)
buyFillCorner.CornerRadius = UDim.new(0, 8)

-- Текст кнопки
local buyTextLabel = Instance.new("TextLabel", buyBtn)
buyTextLabel.Size = UDim2.new(1, 0, 1, 0)
buyTextLabel.BackgroundTransparency = 1
buyTextLabel.Text = "Buy"
buyTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
buyTextLabel.Font = Enum.Font.BuilderSansBold
buyTextLabel.TextSize = 18
buyTextLabel.ZIndex = 2

local testInfoText = Instance.new("TextLabel", promptContainer)
testInfoText.Size = UDim2.new(1, 0, 0, 20)
testInfoText.Position = UDim2.new(0, 0, 1, -30)
testInfoText.Text = "This is a test purchase. Your account will not be charged."
testInfoText.TextColor3 = Color3.fromRGB(120, 120, 120)
testInfoText.TextSize = 12
testInfoText.Font = Enum.Font.BuilderSans
testInfoText.BackgroundTransparency = 1

-- [СОСТОЯНИЕ 2] Меню успеха
local successContainer = Instance.new("Frame")
successContainer.Size = UDim2.new(1, 0, 1, 0)
successContainer.BackgroundTransparency = 1
successContainer.Visible = false
successContainer.Parent = modal

local successTitle = Instance.new("TextLabel", successContainer)
successTitle.Size = UDim2.new(0, 200, 0, 30)
successTitle.Position = UDim2.new(0, 20, 0, 20)
successTitle.Text = "Purchase completed"
successTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
successTitle.TextSize = 22
successTitle.Font = Enum.Font.BuilderSansBold
successTitle.TextXAlignment = Enum.TextXAlignment.Left
successTitle.BackgroundTransparency = 1

local checkIcon = Instance.new("ImageLabel", successContainer)
checkIcon.Size = UDim2.new(0, 50, 0, 50)
checkIcon.AnchorPoint = Vector2.new(0.5, 0)
checkIcon.Position = UDim2.new(0.5, 0, 0, 70)
checkIcon.BackgroundTransparency = 1
checkIcon.Image = "rbxassetid://14389141029" 

local successMsg = Instance.new("TextLabel", successContainer)
successMsg.Size = UDim2.new(1, -40, 0, 25)
successMsg.Position = UDim2.new(0, 20, 0, 135)
successMsg.Text = "You have successfully bought ..."
successMsg.TextColor3 = Color3.fromRGB(210, 210, 210)
successMsg.TextSize = 16
successMsg.Font = Enum.Font.BuilderSans
successMsg.TextXAlignment = Enum.TextXAlignment.Center
successMsg.BackgroundTransparency = 1

local okBtn = Instance.new("TextButton", successContainer)
okBtn.Size = UDim2.new(1, -40, 0, 45)
okBtn.Position = UDim2.new(0, 20, 1, -65)
okBtn.Text = "OK"
okBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
okBtn.BackgroundColor3 = Color3.fromRGB(59, 99, 246)
okBtn.Font = Enum.Font.BuilderSansBold
okBtn.TextSize = 18
local okCorner = Instance.new("UICorner", okBtn)
okCorner.CornerRadius = UDim.new(0, 8)

--------------------------------------------------
-- 4. ЛОГИКА ОТОБРАЖЕНИЯ И КНОПОК
--------------------------------------------------
applyBtn.MouseButton1Click:Connect(function()
    customBalance = balanceInput.Text
    if customBalance == "" then customBalance = "62" end
    balanceText.Text = customBalance
    setupFrame.Visible = false
end)

local function ResetStates()
    promptContainer.Visible = false
    successContainer.Visible = false
    balanceText.Visible = true
    balanceIcon.Visible = true
end

local function HideModal()
    modal.Visible = false
    overlay.Visible = false
end

overlay.MouseButton1Click:Connect(HideModal)
closeBtn.MouseButton1Click:Connect(HideModal)
okBtn.MouseButton1Click:Connect(HideModal)

local canBuy = false
local currentTween = nil

-- Клик по кнопке Buy (Сработает только после анимации)
buyBtn.MouseButton1Click:Connect(function()
    if not canBuy then return end -- Блокируем нажатие, пока идет анимация

    promptContainer.Visible = false
    balanceText.Visible = false 
    balanceIcon.Visible = false
    
    local safeName = (itemName.Text ~= "Unknown Item" and itemName.Text ~= "Loading...") and itemName.Text or "Item"
    successMsg.Text = "You have successfully bought " .. safeName .. "."
    successContainer.Visible = true
end)

local function fetchAndShow(id, infoType)
    ResetStates()
    canBuy = false
    itemName.Text = "Loading..."
    itemPrice.Text = "..."
    
    -- АНИМАЦИЯ ПОЯВЛЕНИЯ UI (МГНОВЕННО)
    overlay.BackgroundTransparency = 1
    modalScale.Scale = 0.8
    overlay.Visible = true
    modal.Visible = true
    promptContainer.Visible = true
    
    TweenService:Create(overlay, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5}):Play()
    TweenService:Create(modalScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    
    -- Запрашиваем информацию (Без ожидания, подтянется за доли секунды)
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
    
    -- СБРАСЫВАЕМ И ЗАПУСКАЕМ АНИМАЦИЮ ПОЛОСКИ СРАЗУ ЖЕ (3 сек)
    if currentTween then currentTween:Cancel() end
    buyBtn.BackgroundColor3 = Color3.fromRGB(35, 40, 50) -- Темный фон
    buyFill.Visible = true
    buyFill.Size = UDim2.new(0, 0, 1, 0)
    
    currentTween = TweenService:Create(buyFill, TweenInfo.new(3, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
    currentTween:Play()
    
    -- Когда полоска заполнилась
    task.spawn(function()
        currentTween.Completed:Wait()
        -- ЖДЕМ 1 СЕКУНДУ ПОСЛЕ ЗАПОЛНЕНИЯ
        task.wait(1)
        
        if promptContainer.Visible then
            -- ДЕЛАЕМ КНОПКУ ПОЛНОСТЬЮ СИНЕЙ (КАК НА 2 СКРИНЕ)
            buyFill.Visible = false
            buyBtn.BackgroundColor3 = Color3.fromRGB(59, 99, 246)
            canBuy = true -- Теперь на кнопку можно нажать
        end
    end)
end

--------------------------------------------------
-- 5. ПЕРЕХВАТ ОРИГИНАЛЬНОГО МЕНЮ
--------------------------------------------------
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if self == MarketplaceService and not setupFrame.Visible then
        
        if method == "PromptGamePassPurchase" or 
           method == "PromptProductPurchase" or 
           method == "PromptPurchase" or 
           method == "PromptBundlePurchase" then
            
            local id = tonumber(args[2])
            if id then
                -- ИСПРАВЛЕНИЕ UNKNOWN ITEM: Выбираем правильный тип товара!
                local infoType = Enum.InfoType.Asset
                if method == "PromptGamePassPurchase" then infoType = Enum.InfoType.GamePass
                elseif method == "PromptProductPurchase" then infoType = Enum.InfoType.Product
                elseif method == "PromptBundlePurchase" then infoType = Enum.InfoType.Bundle
                end
                
                fetchAndShow(id, infoType)
                return -- Блокируем вызов оригинального окна
            end
        end
    end
    
    return oldNamecall(self, ...)
end)
