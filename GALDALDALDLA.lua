local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

-- Безопасное создание GUI (Защита от обнаружения игрой и удалений)
local gui = Instance.new("ScreenGui")
gui.Name = "RobloxPurchaseFake_V3"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local success, err = pcall(function()
    gui.Parent = CoreGui
end)
if not success then
    gui.Parent = player:WaitForChild("PlayerGui")
end

-- Очистка старых версий (если скрипт запускается повторно)
for _, v in pairs(gui.Parent:GetChildren()) do
    if v.Name == gui.Name and v ~= gui then
        v:Destroy()
    end
end

local customBalance = "2,147,483,647"
local currentItemName = "Item"

--------------------------------------------------
-- 1. СТАРТОВОЕ МЕНЮ (НАСТРОЙКИ)
--------------------------------------------------
local setupFrame = Instance.new("Frame", gui)
setupFrame.Size = UDim2.new(0, 300, 0, 220)
setupFrame.Position = UDim2.new(0.5, -150, 0.5, -110)
setupFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
setupFrame.BorderSizePixel = 0
setupFrame.Active = true

Instance.new("UICorner", setupFrame).CornerRadius = UDim.new(0, 12)

local setupTitle = Instance.new("TextLabel", setupFrame)
setupTitle.Size = UDim2.new(1, 0, 0, 40)
setupTitle.Text = "Settings (Drag me)"
setupTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
setupTitle.TextSize = 20
setupTitle.Font = Enum.Font.GothamBold
setupTitle.BackgroundTransparency = 1

local balanceInput = Instance.new("TextBox", setupFrame)
balanceInput.Size = UDim2.new(1, -40, 0, 40)
balanceInput.Position = UDim2.new(0, 20, 0, 50)
balanceInput.Text = "2,147,483,647"
balanceInput.BackgroundColor3 = Color3.fromRGB(40, 43, 53)
balanceInput.TextColor3 = Color3.fromRGB(255, 255, 255)
balanceInput.Font = Enum.Font.Gotham
balanceInput.TextSize = 16
Instance.new("UICorner", balanceInput).CornerRadius = UDim.new(0, 8)

local applyBtn = Instance.new("TextButton", setupFrame)
applyBtn.Size = UDim2.new(1, -40, 0, 40)
applyBtn.Position = UDim2.new(0, 20, 0, 105)
applyBtn.Text = "Save & Start Hook"
applyBtn.BackgroundColor3 = Color3.fromRGB(59, 99, 246)
applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applyBtn.Font = Enum.Font.GothamBold
applyBtn.TextSize = 16
Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 8)

-- КНОПКА ТЕСТА (Чтобы ты мог проверить дизайн без покупок)
local testBtn = Instance.new("TextButton", setupFrame)
testBtn.Size = UDim2.new(1, -40, 0, 40)
testBtn.Position = UDim2.new(0, 20, 0, 160)
testBtn.Text = "Test Prompt UI"
testBtn.BackgroundColor3 = Color3.fromRGB(147, 51, 234)
testBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
testBtn.Font = Enum.Font.GothamBold
testBtn.TextSize = 16
Instance.new("UICorner", testBtn).CornerRadius = UDim.new(0, 8)

-- Перетаскивание меню
local dragging, dragStart, startPos
setupFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = setupFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        setupFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

--------------------------------------------------
-- 2. ГЛАВНОЕ ОКНО ПОКУПКИ (ФЕЙК)
--------------------------------------------------
local overlay = Instance.new("TextButton", gui)
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.5
overlay.Text = ""
overlay.Visible = false

local modal = Instance.new("Frame", gui)
modal.Size = UDim2.new(0, 480, 0, 260)
modal.Position = UDim2.new(0.5, -240, 0.5, -130)
modal.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
modal.Visible = false
Instance.new("UICorner", modal).CornerRadius = UDim.new(0, 14)

local closeBtn = Instance.new("TextButton", modal)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 20)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
closeBtn.TextSize = 22
closeBtn.Font = Enum.Font.Gotham
closeBtn.BackgroundTransparency = 1
closeBtn.ZIndex = 10

-- Контейнер баланса
local balanceContainer = Instance.new("Frame", modal)
balanceContainer.Size = UDim2.new(0, 150, 0, 30)
balanceContainer.Position = UDim2.new(1, -170, 0, 20)
balanceContainer.BackgroundTransparency = 1

local balanceIcon = Instance.new("ImageLabel", balanceContainer)
balanceIcon.Size = UDim2.new(0, 20, 0, 20)
balanceIcon.Position = UDim2.new(0, 0, 0, 5)
balanceIcon.BackgroundTransparency = 1
balanceIcon.Image = "rbxassetid://13087340654"

local balanceText = Instance.new("TextLabel", balanceContainer)
balanceText.Size = UDim2.new(1, -25, 1, 0)
balanceText.Position = UDim2.new(0, 25, 0, 0)
balanceText.Text = "2,147,483,647"
balanceText.TextColor3 = Color3.fromRGB(255, 255, 255)
balanceText.TextSize = 18
balanceText.Font = Enum.Font.GothamMedium
balanceText.TextXAlignment = Enum.TextXAlignment.Right
balanceText.BackgroundTransparency = 1

--------------------------------------------------
-- 3. СОСТОЯНИЕ 1: ЭКРАН ПОКУПКИ (С АНИМАЦИЕЙ КНОПКИ)
--------------------------------------------------
local promptView = Instance.new("Frame", modal)
promptView.Size = UDim2.new(1, 0, 1, 0)
promptView.BackgroundTransparency = 1
promptView.Visible = false

local title = Instance.new("TextLabel", promptView)
title.Size = UDim2.new(0, 200, 0, 30)
title.Position = UDim2.new(0, 20, 0, 20)
title.Text = "Buy item"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1

local itemNameLabel = Instance.new("TextLabel", promptView)
itemNameLabel.Size = UDim2.new(1, -40, 0, 25)
itemNameLabel.Position = UDim2.new(0, 20, 0, 85)
itemNameLabel.Text = "Деньги 200"
itemNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
itemNameLabel.TextSize = 18
itemNameLabel.Font = Enum.Font.GothamBold
itemNameLabel.TextXAlignment = Enum.TextXAlignment.Center
itemNameLabel.BackgroundTransparency = 1

local priceFrame = Instance.new("Frame", promptView)
priceFrame.Size = UDim2.new(1, 0, 0, 20)
priceFrame.Position = UDim2.new(0, 0, 0, 115)
priceFrame.BackgroundTransparency = 1

local priceLayout = Instance.new("UIListLayout", priceFrame)
priceLayout.FillDirection = Enum.FillDirection.Horizontal
priceLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
priceLayout.SortOrder = Enum.SortOrder.LayoutOrder
priceLayout.Padding = UDim.new(0, 5)

local priceIcon = Instance.new("ImageLabel", priceFrame)
priceIcon.Size = UDim2.new(0, 20, 0, 20)
priceIcon.BackgroundTransparency = 1
priceIcon.Image = "rbxassetid://13087340654"
priceIcon.LayoutOrder = 1

local itemPriceLabel = Instance.new("TextLabel", priceFrame)
itemPriceLabel.Size = UDim2.new(0, 0, 1, 0)
itemPriceLabel.AutomaticSize = Enum.AutomaticSize.X
itemPriceLabel.Text = "5"
itemPriceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
itemPriceLabel.TextSize = 18
itemPriceLabel.Font = Enum.Font.GothamBold
itemPriceLabel.BackgroundTransparency = 1
itemPriceLabel.LayoutOrder = 2

local buyBtn = Instance.new("TextButton", promptView)
buyBtn.Size = UDim2.new(1, -40, 0, 44)
buyBtn.Position = UDim2.new(0, 20, 1, -75)
buyBtn.Text = "Buy"
buyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
buyBtn.BackgroundColor3 = Color3.fromRGB(59, 99, 246)
buyBtn.Font = Enum.Font.GothamBold
buyBtn.TextSize = 18
buyBtn.AutoButtonColor = false
Instance.new("UICorner", buyBtn).CornerRadius = UDim.new(0, 8)

local testInfoText = Instance.new("TextLabel", promptView)
testInfoText.Size = UDim2.new(1, 0, 0, 20)
testInfoText.Position = UDim2.new(0, 0, 1, -25)
testInfoText.Text = "This is a test purchase. Your account will not be charged."
testInfoText.TextColor3 = Color3.fromRGB(150, 150, 150)
testInfoText.TextSize = 12
testInfoText.Font = Enum.Font.Gotham
testInfoText.BackgroundTransparency = 1

-- Анимация для кнопки Buy (в цикле)
local pulseTweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local pulseAnim = TweenService:Create(buyBtn, pulseTweenInfo, {BackgroundColor3 = Color3.fromRGB(80, 120, 255)})

--------------------------------------------------
-- 4. СОСТОЯНИЕ 2: ЭКРАН УСПЕХА
--------------------------------------------------
local successView = Instance.new("Frame", modal)
successView.Size = UDim2.new(1, 0, 1, 0)
successView.BackgroundTransparency = 1
successView.Visible = false

local sTitle = Instance.new("TextLabel", successView)
sTitle.Size = UDim2.new(0, 200, 0, 30)
sTitle.Position = UDim2.new(0, 20, 0, 20)
sTitle.Text = "Purchase completed"
sTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
sTitle.TextSize = 22
sTitle.Font = Enum.Font.GothamBold
sTitle.TextXAlignment = Enum.TextXAlignment.Left
sTitle.BackgroundTransparency = 1

local checkIcon = Instance.new("ImageLabel", successView)
checkIcon.Size = UDim2.new(0, 56, 0, 56)
checkIcon.Position = UDim2.new(0.5, -28, 0, 60)
checkIcon.BackgroundTransparency = 1
checkIcon.Image = "rbxassetid://14389141029"

local successMsg = Instance.new("TextLabel", successView)
successMsg.Size = UDim2.new(1, -40, 0, 25)
successMsg.Position = UDim2.new(0, 20, 0, 130)
successMsg.Text = "You have successfully bought ..."
successMsg.TextColor3 = Color3.fromRGB(210, 210, 210)
successMsg.TextSize = 16
successMsg.Font = Enum.Font.Gotham
successMsg.TextXAlignment = Enum.TextXAlignment.Center
successMsg.BackgroundTransparency = 1

local okBtn = Instance.new("TextButton", successView)
okBtn.Size = UDim2.new(1, -40, 0, 44)
okBtn.Position = UDim2.new(0, 20, 1, -65)
okBtn.Text = "OK"
okBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
okBtn.BackgroundColor3 = Color3.fromRGB(59, 99, 246)
okBtn.Font = Enum.Font.GothamBold
okBtn.TextSize = 18
Instance.new("UICorner", okBtn).CornerRadius = UDim.new(0, 8)

--------------------------------------------------
-- 5. ЛОГИКА
--------------------------------------------------
local function HideModal()
    modal.Visible = false
    overlay.Visible = false
    pulseAnim:Cancel()
end

overlay.MouseButton1Click:Connect(HideModal)
closeBtn.MouseButton1Click:Connect(HideModal)
okBtn.MouseButton1Click:Connect(HideModal)

applyBtn.MouseButton1Click:Connect(function()
    customBalance = balanceInput.Text
    balanceText.Text = customBalance
    setupFrame.Visible = false
end)

local function ShowPrompt(name, price)
    currentItemName = name or "Unknown Item"
    itemNameLabel.Text = currentItemName
    itemPriceLabel.Text = price and tostring(price) or "???"
    
    balanceText.Text = customBalance
    
    successView.Visible = false
    balanceContainer.Visible = true
    promptView.Visible = true
    
    buyBtn.BackgroundColor3 = Color3.fromRGB(59, 99, 246)
    pulseAnim:Play() -- ЗАПУСКАЕМ АНИМАЦИЮ В ЦИКЛЕ при появлении UI
    
    overlay.Visible = true
    modal.Visible = true
end

-- Кнопка для теста интерфейса без реальной покупки
testBtn.MouseButton1Click:Connect(function()
    setupFrame.Visible = false
    ShowPrompt("Деньги 200", "5")
end)

local isProcessing = false

buyBtn.MouseButton1Click:Connect(function()
    if isProcessing then return end
    isProcessing = true
    
    -- Останавливаем анимацию, кнопка становится немного темнее как при клике
    pulseAnim:Cancel()
    buyBtn.BackgroundColor3 = Color3.fromRGB(40, 70, 190)
    
    -- Ждем ровно 1 секунду
    task.wait(1)
    
    -- Переключаем окна напрямую (без зеленых кнопок)
    promptView.Visible = false
    balanceContainer.Visible = false -- скрываем баланс, как на 3 скрине
    
    successMsg.Text = "You have successfully bought " .. currentItemName .. "."
    successView.Visible = true
    
    isProcessing = false
end)

--------------------------------------------------
-- 6. ХУК ИГРЫ (ОТЛОВ ПОКУПОК)
--------------------------------------------------
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    -- Если меню настроек закрыто, начинаем перехватывать
    if not checkcaller() and self == MarketplaceService and not setupFrame.Visible then
        if method == "PromptGamePassPurchase" or method == "PromptProductPurchase" then
            local id = args[2]
            local infoType = (method == "PromptGamePassPurchase") and Enum.InfoType.GamePass or Enum.InfoType.Product
            
            task.spawn(function()
                local s, info = pcall(function() return MarketplaceService:GetProductInfo(id, infoType) end)
                if s and info then
                    ShowPrompt(info.Name, info.PriceInRobux)
                else
                    ShowPrompt("Unknown Item", "0")
                end
            end)
            
            return -- Блокируем оригинальное окно роблокса
        end
    end
    
    return oldNamecall(self, ...)
end)
