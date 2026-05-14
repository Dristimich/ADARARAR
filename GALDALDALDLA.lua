local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer

-- Создаем ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "RobloxPurchaseModal_Exact"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- Overlay (затемнение заднего фона)
local overlay = Instance.new("TextButton")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.5
overlay.Text = ""
overlay.AutoButtonColor = false
overlay.Visible = false
overlay.Parent = gui

-- Главное модальное окно (Размер и цвет под скриншот 5)
local modal = Instance.new("Frame")
modal.Size = UDim2.new(0, 480, 0, 380) -- Увеличили высоту для блока с паком робуксов
modal.Position = UDim2.new(0.5, -240, 0.5, -190)
modal.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
modal.BorderSizePixel = 0
modal.Visible = false
modal.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = modal

--------------------------------------------------
-- ВЕРХНЯЯ ПАНЕЛЬ
--------------------------------------------------
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 250, 0, 30)
title.Position = UDim2.new(0, 20, 0, 20)
title.Text = "Buy Robux and item"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.Parent = modal

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 20)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
closeBtn.TextSize = 22
closeBtn.Font = Enum.Font.Gotham
closeBtn.BackgroundTransparency = 1
closeBtn.Parent = modal

local balanceText = Instance.new("TextLabel")
balanceText.Size = UDim2.new(0, 40, 0, 30)
balanceText.Position = UDim2.new(1, -95, 0, 20)
balanceText.Text = "62"
balanceText.TextColor3 = Color3.fromRGB(255, 255, 255)
balanceText.TextSize = 18
balanceText.Font = Enum.Font.GothamMedium
balanceText.TextXAlignment = Enum.TextXAlignment.Right
balanceText.BackgroundTransparency = 1
balanceText.Parent = modal

local balanceIcon = Instance.new("ImageLabel")
balanceIcon.Size = UDim2.new(0, 20, 0, 20)
balanceIcon.Position = UDim2.new(1, -125, 0, 25)
balanceIcon.BackgroundTransparency = 1
balanceIcon.Image = "rbxassetid://13087340654"
balanceIcon.Parent = modal

--------------------------------------------------
-- ИНФОРМАЦИЯ О ПРЕДМЕТЕ (Динамическая)
--------------------------------------------------
local itemName = Instance.new("TextLabel")
itemName.Size = UDim2.new(0, 300, 0, 25)
itemName.Position = UDim2.new(0, 105, 0, 85)
itemName.Text = "Loading..."
itemName.TextColor3 = Color3.fromRGB(255, 255, 255)
itemName.TextSize = 18
itemName.Font = Enum.Font.GothamBold
itemName.TextXAlignment = Enum.TextXAlignment.Left
itemName.BackgroundTransparency = 1
itemName.Parent = modal

local priceIcon = Instance.new("ImageLabel")
priceIcon.Size = UDim2.new(0, 18, 0, 18)
priceIcon.Position = UDim2.new(0, 105, 0, 116)
priceIcon.BackgroundTransparency = 1
priceIcon.Image = "rbxassetid://13087340654"
priceIcon.Parent = modal

local itemPrice = Instance.new("TextLabel")
itemPrice.Size = UDim2.new(0, 100, 0, 25)
itemPrice.Position = UDim2.new(0, 130, 0, 112)
itemPrice.Text = "..."
itemPrice.TextColor3 = Color3.fromRGB(255, 255, 255)
itemPrice.TextSize = 18
itemPrice.Font = Enum.Font.GothamBold
itemPrice.TextXAlignment = Enum.TextXAlignment.Left
itemPrice.BackgroundTransparency = 1
itemPrice.Parent = modal

--------------------------------------------------
-- БЛОК ПАКА РОБУКСОВ (Как на 5 скрине)
--------------------------------------------------
local packFrame = Instance.new("Frame")
packFrame.Size = UDim2.new(1, -40, 0, 60)
packFrame.Position = UDim2.new(0, 20, 0, 165)
packFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
packFrame.Parent = modal

local packCorner = Instance.new("UICorner")
packCorner.CornerRadius = UDim.new(0, 10)
packCorner.Parent = packFrame

local packStroke = Instance.new("UIStroke")
packStroke.Color = Color3.fromRGB(255, 255, 255)
packStroke.Thickness = 1.5
packStroke.Parent = packFrame

local packIcon = Instance.new("ImageLabel")
packIcon.Size = UDim2.new(0, 20, 0, 20)
packIcon.Position = UDim2.new(0, 15, 0.5, -10)
packIcon.BackgroundTransparency = 1
packIcon.Image = "rbxassetid://13087340654"
packIcon.Parent = packFrame

local packRobuxText = Instance.new("TextLabel")
packRobuxText.Size = UDim2.new(0, 100, 1, 0)
packRobuxText.Position = UDim2.new(0, 45, 0, 0)
packRobuxText.Text = "240"
packRobuxText.TextColor3 = Color3.fromRGB(255, 255, 255)
packRobuxText.TextSize = 20
packRobuxText.Font = Enum.Font.GothamBold
packRobuxText.TextXAlignment = Enum.TextXAlignment.Left
packRobuxText.BackgroundTransparency = 1
packRobuxText.Parent = packFrame

local packPriceText = Instance.new("TextLabel")
packPriceText.Size = UDim2.new(0, 100, 1, 0)
packPriceText.Position = UDim2.new(1, -115, 0, 0)
packPriceText.Text = "$2.99"
packPriceText.TextColor3 = Color3.fromRGB(255, 255, 255)
packPriceText.TextSize = 20
packPriceText.Font = Enum.Font.GothamBold
packPriceText.TextXAlignment = Enum.TextXAlignment.Right
packPriceText.BackgroundTransparency = 1
packPriceText.Parent = packFrame

--------------------------------------------------
-- КНОПКА BUY И ПОДВАЛ
--------------------------------------------------
local buyBtnContainer = Instance.new("Frame")
buyBtnContainer.Size = UDim2.new(1, -40, 0, 46) -- Чуть уменьшили высоту
buyBtnContainer.Position = UDim2.new(0, 20, 1, -100)
buyBtnContainer.BackgroundTransparency = 1
buyBtnContainer.Parent = modal

local buyBtn = Instance.new("TextButton")
buyBtn.Size = UDim2.new(1, 0, 1, 0)
buyBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
buyBtn.AnchorPoint = Vector2.new(0.5, 0.5)
buyBtn.Text = "Buy"
buyBtn.BackgroundColor3 = Color3.fromRGB(45, 65, 150) -- Более темный синий как на 5 скрине
buyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
buyBtn.Font = Enum.Font.GothamBold
buyBtn.TextSize = 18
buyBtn.AutoButtonColor = false
buyBtn.Parent = buyBtnContainer

local buyCorner = Instance.new("UICorner")
buyCorner.CornerRadius = UDim.new(0, 10)
buyCorner.Parent = buyBtn

local footerText = Instance.new("TextLabel")
footerText.Size = UDim2.new(1, 0, 0, 20)
footerText.Position = UDim2.new(0, 0, 1, -40)
footerText.Text = "Your payment method will be charged. Roblox Terms of Use apply."
footerText.TextColor3 = Color3.fromRGB(180, 180, 180)
footerText.TextSize = 12
footerText.Font = Enum.Font.Gotham
footerText.BackgroundTransparency = 1
footerText.Parent = modal

--------------------------------------------------
-- АНИМАЦИИ И ЛОГИКА
--------------------------------------------------

-- Анимация кнопки (нажатие)
local shrinkTween = TweenService:Create(buyBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.96, 0, 0.9, 0)})
local growTween = TweenService:Create(buyBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})

buyBtn.MouseButton1Down:Connect(function() shrinkTween:Play() end)
buyBtn.MouseButton1Up:Connect(function() growTween:Play() end)
buyBtn.MouseLeave:Connect(function() growTween:Play() end)

-- Функции отображения
local function ShowModal(name, price)
    itemName.Text = name or "Loading..."
    itemPrice.Text = price and tostring(price) or "..."
    overlay.Visible = true
    modal.Visible = true
end

local function HideModal()
    modal.Visible = false
    overlay.Visible = false
end

overlay.MouseButton1Click:Connect(HideModal)
closeBtn.MouseButton1Click:Connect(HideModal)
closeBtn.MouseEnter:Connect(function() closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255) end)
closeBtn.MouseLeave:Connect(function() closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200) end)

buyBtn.MouseButton1Click:Connect(function()
    buyBtn.Text = "Processing..."
    task.wait(0.9)
    buyBtn.Text = "Purchased!"
    buyBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
    task.wait(1.2)
    HideModal()
    buyBtn.Text = "Buy"
    buyBtn.BackgroundColor3 = Color3.fromRGB(45, 65, 150)
end)

--------------------------------------------------
-- ПЕРЕХВАТ РЕАЛЬНЫХ ПОКУПОК
--------------------------------------------------

local function fetchAndShow(id, infoType)
    ShowModal("Loading...", "...") -- Показываем окно сразу
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

-- Срабатывает при вызове покупки Gamepass
MarketplaceService.PromptGamePassPurchaseRequested:Connect(function(plr, gamePassId)
    if plr == player then
        fetchAndShow(gamePassId, Enum.InfoType.GamePass)
    end
end)

-- Срабатывает при вызове покупки Developer Product (Донат в игре)
MarketplaceService.PromptProductPurchaseRequested:Connect(function(plr, productId)
    if plr == player then
        fetchAndShow(productId, Enum.InfoType.Product)
    end
end)

-- Тестовый вызов для проверки дизайна (удали, если не нужно):
-- ShowModal("Деньги 20000", 199)
