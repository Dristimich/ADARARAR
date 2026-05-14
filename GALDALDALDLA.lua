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
setupFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
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
setupTitle.Font = Enum.Font.GothamBold
setupTitle.BackgroundTransparency = 1
setupTitle.Parent = setupFrame

local balanceInput = Instance.new("TextBox")
balanceInput.Size = UDim2.new(1, -40, 0, 40)
balanceInput.Position = UDim2.new(0, 20, 0, 60)
balanceInput.PlaceholderText = "Enter fake balance (e.g. 10000)"
balanceInput.Text = "62"
balanceInput.BackgroundColor3 = Color3.fromRGB(40, 43, 53)
balanceInput.TextColor3 = Color3.fromRGB(255, 255, 255)
balanceInput.Font = Enum.Font.Gotham
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
applyBtn.Font = Enum.Font.GothamBold
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
-- 2. ГЛАВНОЕ ФЕЙК-МЕНЮ (КАК НА 1 СКРИНШОТЕ)
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
modal.Position = UDim2.new(0.5, -240, 0.5, -130)
modal.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
modal.Visible = false
modal.Parent = gui

local modalCorner = Instance.new("UICorner")
modalCorner.CornerRadius = UDim.new(0, 14)
modalCorner.Parent = modal

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 200, 0, 30)
title.Position = UDim2.new(0, 20, 0, 20)
title.Text = "Buy item"
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
balanceText.Size = UDim2.new(0, 60, 0, 30)
balanceText.Position = UDim2.new(1, -115, 0, 20)
balanceText.Text = "62"
balanceText.TextColor3 = Color3.fromRGB(255, 255, 255)
balanceText.TextSize = 18
balanceText.Font = Enum.Font.GothamMedium
balanceText.TextXAlignment = Enum.TextXAlignment.Right
balanceText.BackgroundTransparency = 1
balanceText.Parent = modal

local balanceIcon = Instance.new("ImageLabel")
balanceIcon.Size = UDim2.new(0, 20, 0, 20)
balanceIcon.Position = UDim2.new(1, -145, 0, 25)
balanceIcon.BackgroundTransparency = 1
balanceIcon.Image = "rbxassetid://13087340654"
balanceIcon.Parent = modal

local itemName = Instance.new("TextLabel")
itemName.Size = UDim2.new(0, 300, 0, 25)
itemName.Position = UDim2.new(0, 105, 0, 95)
itemName.Text = "Loading..."
itemName.TextColor3 = Color3.fromRGB(255, 255, 255)
itemName.TextSize = 18
itemName.Font = Enum.Font.GothamBold
itemName.TextXAlignment = Enum.TextXAlignment.Left
itemName.BackgroundTransparency = 1
itemName.Parent = modal

local priceIcon = Instance.new("ImageLabel")
priceIcon.Size = UDim2.new(0, 18, 0, 18)
priceIcon.Position = UDim2.new(0, 105, 0, 126)
priceIcon.BackgroundTransparency = 1
priceIcon.Image = "rbxassetid://13087340654"
priceIcon.Parent = modal

local itemPrice = Instance.new("TextLabel")
itemPrice.Size = UDim2.new(0, 100, 0, 25)
itemPrice.Position = UDim2.new(0, 130, 0, 122)
itemPrice.Text = "..."
itemPrice.TextColor3 = Color3.fromRGB(255, 255, 255)
itemPrice.TextSize = 18
itemPrice.Font = Enum.Font.GothamBold
itemPrice.TextXAlignment = Enum.TextXAlignment.Left
itemPrice.BackgroundTransparency = 1
itemPrice.Parent = modal

--------------------------------------------------
-- 3. КНОПКА С АНИМАЦИЕЙ ЗАЛИВКИ
--------------------------------------------------
local buyBtnBase = Instance.new("TextButton")
buyBtnBase.Size = UDim2.new(1, -40, 0, 48)
buyBtnBase.Position = UDim2.new(0, 20, 1, -68)
buyBtnBase.Text = "" 
buyBtnBase.BackgroundColor3 = Color3.fromRGB(59, 99, 246)
buyBtnBase.AutoButtonColor = false
buyBtnBase.Parent = modal

local baseCorner = Instance.new("UICorner")
baseCorner.CornerRadius = UDim.new(0, 10)
baseCorner.Parent = buyBtnBase

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.Position = UDim2.new(0, 0, 0, 0)
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
buyTextLabel.Font = Enum.Font.GothamBold
buyTextLabel.TextSize = 18
buyTextLabel.BackgroundTransparency = 1
buyTextLabel.ZIndex = 2
buyTextLabel.Parent = buyBtnBase

--------------------------------------------------
-- 4. ЛОГИКА И АНИМАЦИЯ (3 СЕКУНДЫ)
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
    
    buyBtnBase.BackgroundColor3 = Color3.fromRGB(59, 99, 246)
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
    
    buyBtnBase.BackgroundColor3 = Color3.fromRGB(36, 59, 146)
    progressFill.BackgroundColor3 = Color3.fromRGB(59, 99, 246)
    progressFill.Visible = true
    
    -- Анимация теперь ровно 3 секунды
    local tween = TweenService:Create(progressFill, TweenInfo.new(3.0, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
    tween:Play()
    tween.Completed:Wait()
    
    buyTextLabel.Text = "Purchased!"
    progressFill.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
    
    task.wait(1)
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
-- 5. ПЕРЕХВАТ ОРИГИНАЛЬНОГО МЕНЮ (HOOKMETAMETHOD)
--------------------------------------------------
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if self == MarketplaceService and not setupFrame.Visible then
        if method == "PromptGamePassPurchase" then
            local id = args[2]
            fetchAndShow(id, Enum.InfoType.GamePass)
            return -- ВОТ ЭТО БЛОКИРУЕТ ОРИГИНАЛЬНОЕ МЕНЮ
        elseif method == "PromptProductPurchase" then
            local id = args[2]
            fetchAndShow(id, Enum.InfoType.Product)
            return -- ВОТ ЭТО БЛОКИРУЕТ ОРИГИНАЛЬНОЕ МЕНЮ
        end
    end
    
    return oldNamecall(self, ...)
end)
