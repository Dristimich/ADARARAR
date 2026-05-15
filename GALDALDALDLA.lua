-- =============================================== --
--                 СЕРВИСЫ И ПЕРЕМЕННЫЕ              --
-- =============================================== --
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")

local player = Players.LocalPlayer

-- Удаляем старую версию GUI, если она есть
for _,v in pairs(player.PlayerGui:GetChildren()) do
    if v.Name == "RobloxPurchaseMenu_Pro" then
        v:Destroy()
    end
end

-- =============================================== --
--                     СОЗДАНИЕ GUI                  --
-- =============================================== --

local gui = Instance.new("ScreenGui")
gui.Name = "RobloxPurchaseMenu_Pro"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player.PlayerGui

local customBalance = "76"
local amountValue = "20000" -- Значение по умолчанию для добавления/установки
local isSetValueMode = false -- [НОВОЕ] Переменная для режима: false = добавлять, true = устанавливать

-- Окно настроек
local setupFrame = Instance.new("Frame")
setupFrame.Size = UDim2.fromOffset(300, 280) -- [ИЗМЕНЕНО] Увеличили высоту для нового элемента
setupFrame.Position = UDim2.new(0.5, -150, 0.5, -140)
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
setupTitle.BackgroundTransparency = 1
setupTitle.Text = "Settings (Drag me)"
setupTitle.Font = Enum.Font.GothamBold
setupTitle.TextSize = 20
setupTitle.TextColor3 = Color3.new(1, 1, 1)
setupTitle.Parent = setupFrame

-- Поле для фейкового баланса Robux
local balanceInput = Instance.new("TextBox")
balanceInput.Size = UDim2.new(1, -40, 0, 40)
balanceInput.Position = UDim2.new(0, 20, 0, 50)
balanceInput.BackgroundColor3 = Color3.fromRGB(40, 43, 53)
balanceInput.Text = customBalance
balanceInput.PlaceholderText = "Enter fake Robux balance"
balanceInput.Font = Enum.Font.Gotham
balanceInput.TextSize = 16
balanceInput.TextColor3 = Color3.new(1, 1, 1)
balanceInput.Parent = setupFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = balanceInput

-- Поле для суммы монет
local addAmountInput = Instance.new("TextBox")
addAmountInput.Size = UDim2.new(1, -40, 0, 40)
addAmountInput.Position = UDim2.new(0, 20, 0, 110)
addAmountInput.BackgroundColor3 = Color3.fromRGB(40, 43, 53)
addAmountInput.Text = amountValue
addAmountInput.PlaceholderText = "Enter amount"
addAmountInput.Font = Enum.Font.Gotham
addAmountInput.TextSize = 16
addAmountInput.TextColor3 = Color3.new(1, 1, 1)
addAmountInput.Parent = setupFrame

local addAmountCorner = Instance.new("UICorner")
addAmountCorner.CornerRadius = UDim.new(0, 8)
addAmountCorner.Parent = addAmountInput

-- [НОВОЕ] Переключатель режима "Установить/Добавить"
local setOrAddToggle = Instance.new("TextButton")
setOrAddToggle.Size = UDim2.new(1, -40, 0, 30)
setOrAddToggle.Position = UDim2.new(0, 20, 0, 170)
setOrAddToggle.BackgroundColor3 = Color3.fromRGB(40, 43, 53)
setOrAddToggle.Text = ""
setOrAddToggle.AutoButtonColor = false
setOrAddToggle.Parent = setupFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = setOrAddToggle

local toggleCheck = Instance.new("TextLabel")
toggleCheck.Size = UDim2.fromOffset(18, 18)
toggleCheck.Position = UDim2.new(0, 8, 0.5, -9)
toggleCheck.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
toggleCheck.BorderSizePixel = 0
toggleCheck.Text = "✓"
toggleCheck.Font = Enum.Font.GothamBold
toggleCheck.TextSize = 16
toggleCheck.TextColor3 = Color3.fromRGB(59, 99, 246)
toggleCheck.Visible = false -- Скрыт по умолчанию
toggleCheck.Parent = setOrAddToggle

local toggleCheckCorner = Instance.new("UICorner")
toggleCheckCorner.CornerRadius = UDim.new(0, 4)
toggleCheckCorner.Parent = toggleCheck

local toggleLabel = Instance.new("TextLabel")
toggleLabel.Size = UDim2.new(1, -40, 1, 0)
toggleLabel.Position = UDim2.new(0, 40, 0, 0)
toggleLabel.BackgroundTransparency = 1
toggleLabel.Text = "Set value (instead of add)"
toggleLabel.Font = Enum.Font.Gotham
toggleLabel.TextSize = 14
toggleLabel.TextColor3 = Color3.new(1, 1, 1)
toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
toggleLabel.Parent = setOrAddToggle

setOrAddToggle.MouseButton1Click:Connect(function()
	isSetValueMode = not isSetValueMode
	toggleCheck.Visible = isSetValueMode
	if isSetValueMode then
		addAmountInput.PlaceholderText = "Enter value to set"
	else
		addAmountInput.PlaceholderText = "Enter amount to add"
	end
end)


-- Кнопка "Сохранить и запустить"
local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(1, -40, 0, 40)
applyBtn.Position = UDim2.new(0, 20, 0, 220) -- [ИЗМЕНЕНО] Сдвинули вниз
applyBtn.BackgroundColor3 = Color3.fromRGB(59, 99, 246)
applyBtn.Text = "Save & Start"
applyBtn.Font = Enum.Font.GothamBold
applyBtn.TextSize = 16
applyBtn.TextColor3 = Color3.new(1, 1, 1)
applyBtn.Parent = setupFrame

local applyCorner = Instance.new("UICorner")
applyCorner.CornerRadius = UDim.new(0, 8)
applyCorner.Parent = applyBtn

-- Логика перетаскивания (без изменений)
local dragging, dragInput, dragStart, startPos
setupFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = setupFrame.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
setupFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart; setupFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

-- Остальные элементы GUI (окно покупки, оверлей и т.д.) - без изменений
-- ... (весь ваш код создания GUI, который был здесь раньше)
local overlay=Instance.new("TextButton")
local modal=Instance.new("Frame")
local constraint=Instance.new("UISizeConstraint")
local modalCorner=Instance.new("UICorner")
local title=Instance.new("TextLabel")
local closeBtn=Instance.new("ImageButton")
local balanceFrame=Instance.new("Frame")
local balanceLayout=Instance.new("UIListLayout")
local balanceIcon=Instance.new("ImageLabel")
local balanceText=Instance.new("TextLabel")
local promptContainer=Instance.new("Frame")
local itemIcon=Instance.new("ImageLabel")
local itemName=Instance.new("TextLabel")
local priceFrame=Instance.new("Frame")
local priceLayout=Instance.new("UIListLayout")
local priceIcon=Instance.new("ImageLabel")
local itemPrice=Instance.new("TextLabel")
local buyBtn=Instance.new("TextButton")
local buyCorner=Instance.new("UICorner")
local progressFill=Instance.new("Frame")
local fillCorner=Instance.new("UICorner")
local buyText=Instance.new("TextLabel")
local successContainer=Instance.new("Frame")
local checkIcon=Instance.new("ImageLabel")
local successMsg=Instance.new("TextLabel")
local okBtn=Instance.new("TextButton")
local okCorner=Instance.new("UICorner")
overlay.Size=UDim2.new(1,0,1,0)
overlay.BackgroundColor3=Color3.new(0,0,0)
overlay.BackgroundTransparency=1
overlay.Text=""
overlay.AutoButtonColor=false
overlay.Visible=false
overlay.ZIndex=1
overlay.Parent=gui
modal.Size=UDim2.fromOffset(435,185)
modal.Position=UDim2.new(0.5,-217,0.5,-92)
modal.BackgroundColor3=Color3.fromRGB(17,19,28)
modal.BorderSizePixel=0
modal.Visible=false
modal.ClipsDescendants=true
modal.ZIndex=2
modal.Parent=gui
constraint.MaxSize=Vector2.new(435,185)
constraint.MinSize=Vector2.new(435,185)
constraint.Parent=modal
modalCorner.CornerRadius=UDim.new(0,18)
modalCorner.Parent=modal
title.Size=UDim2.new(0,220,0,34)
title.Position=UDim2.new(0,16,0,14)
title.BackgroundTransparency=1
title.Font=Enum.Font.GothamBold
title.Text="Buy item"
title.TextSize=24
title.TextColor3=Color3.new(1,1,1)
title.TextXAlignment=Enum.TextXAlignment.Left
title.ZIndex=3
title.Parent=modal
closeBtn.Size=UDim2.fromOffset(24,24)
closeBtn.Position=UDim2.new(1,-32,0,16)
closeBtn.BackgroundTransparency=1
closeBtn.Image="rbxthumb://type=Asset&id=78940278565096&w=420&h=420"
closeBtn.ScaleType=Enum.ScaleType.Fit
closeBtn.ZIndex=4
closeBtn.Parent=modal
balanceFrame.AutomaticSize=Enum.AutomaticSize.X
balanceFrame.Size=UDim2.new(0,0,0,24)
balanceFrame.AnchorPoint=Vector2.new(1,0)
balanceFrame.Position=UDim2.new(1,-62,0,18)
balanceFrame.BackgroundTransparency=1
balanceFrame.ZIndex=3
balanceFrame.Parent=modal
balanceLayout.FillDirection=Enum.FillDirection.Horizontal
balanceLayout.HorizontalAlignment=Enum.HorizontalAlignment.Left
balanceLayout.VerticalAlignment=Enum.VerticalAlignment.Center
balanceLayout.Padding=UDim.new(0,5)
balanceLayout.Parent=balanceFrame
balanceIcon.Size=UDim2.fromOffset(20,20)
balanceIcon.BackgroundTransparency=1
balanceIcon.Image="rbxthumb://type=Asset&id=70493384532723&w=420&h=420"
balanceIcon.ScaleType=Enum.ScaleType.Fit
balanceIcon.ZIndex=4
balanceIcon.Parent=balanceFrame
balanceText.AutomaticSize=Enum.AutomaticSize.X
balanceText.Size=UDim2.new(0,0,1,0)
balanceText.BackgroundTransparency=1
balanceText.Font=Enum.Font.GothamMedium
balanceText.TextSize=16
balanceText.TextColor3=Color3.new(1,1,1)
balanceText.Text=customBalance
balanceText.ZIndex=4
balanceText.Parent=balanceFrame
promptContainer.Size=UDim2.new(1,0,1,0)
promptContainer.BackgroundTransparency=1
promptContainer.ZIndex=3
promptContainer.Parent=modal
itemIcon.Size=UDim2.fromOffset(64,64)
itemIcon.Position=UDim2.new(0,14,0,52)
itemIcon.BackgroundTransparency=1
itemIcon.Image=""
itemIcon.ScaleType=Enum.ScaleType.Fit
itemIcon.ZIndex=3
itemIcon.Parent=promptContainer
itemName.Size=UDim2.new(0,280,0,28)
itemName.Position=UDim2.new(0,88,0,55)
itemName.BackgroundTransparency=1
itemName.Font=Enum.Font.GothamBold
itemName.TextSize=17
itemName.TextColor3=Color3.new(1,1,1)
itemName.TextXAlignment=Enum.TextXAlignment.Left
itemName.Text="Loading..."
itemName.ZIndex=3
itemName.Parent=promptContainer
priceFrame.AutomaticSize=Enum.AutomaticSize.X
priceFrame.Size=UDim2.new(0,0,0,22)
priceFrame.Position=UDim2.new(0,88,0,83)
priceFrame.BackgroundTransparency=1
priceFrame.ZIndex=3
priceFrame.Parent=promptContainer
priceLayout.FillDirection=Enum.FillDirection.Horizontal
priceLayout.HorizontalAlignment=Enum.HorizontalAlignment.Left
priceLayout.VerticalAlignment=Enum.VerticalAlignment.Center
priceLayout.Padding=UDim.new(0,5)
priceLayout.Parent=priceFrame
priceIcon.Size=UDim2.fromOffset(20,20)
priceIcon.BackgroundTransparency=1
priceIcon.Image="rbxthumb://type=Asset&id=70493384532723&w=420&h=420"
priceIcon.ScaleType=Enum.ScaleType.Fit
priceIcon.ZIndex=4
priceIcon.Parent=priceFrame
itemPrice.AutomaticSize=Enum.AutomaticSize.X
itemPrice.Size=UDim2.new(0,0,1,0)
itemPrice.BackgroundTransparency=1
itemPrice.Font=Enum.Font.GothamMedium
itemPrice.TextSize=16
itemPrice.TextColor3=Color3.new(1,1,1)
itemPrice.Text="5"
itemPrice.ZIndex=4
itemPrice.Parent=priceFrame
buyBtn.Size=UDim2.new(1,-28,0,44)
buyBtn.Position=UDim2.new(0,14,1,-56)
buyBtn.BackgroundColor3=Color3.fromRGB(58,86,217)
buyBtn.Text=""
buyBtn.AutoButtonColor=false
buyBtn.ClipsDescendants=true
buyBtn.ZIndex=3
buyBtn.Parent=promptContainer
buyCorner.CornerRadius=UDim.new(0,10)
buyCorner.Parent=buyBtn
progressFill.Size=UDim2.new(0,0,1,0)
progressFill.BackgroundColor3=Color3.fromRGB(43,63,165)
progressFill.BorderSizePixel=0
progressFill.ZIndex=4
progressFill.Parent=buyBtn
fillCorner.CornerRadius=UDim.new(0,9)
fillCorner.Parent=progressFill
buyText.Size=UDim2.new(1,0,1,0)
buyText.BackgroundTransparency=1
buyText.Font=Enum.Font.GothamMedium
buyText.TextSize=16
buyText.Text="Buy"
buyText.TextColor3=Color3.new(1,1,1)
buyText.ZIndex=5
buyText.Parent=buyBtn
successContainer.Size=UDim2.new(1,0,1,0)
successContainer.BackgroundTransparency=1
successContainer.Visible=false
successContainer.ZIndex=3
successContainer.Parent=modal
checkIcon.Size=UDim2.fromOffset(52,52)
checkIcon.Position=UDim2.new(0.5,-26,0,24)
checkIcon.BackgroundTransparency=1
checkIcon.Image="rbxthumb://type=Asset&id=110759125205910&w=420&h=420"
checkIcon.ScaleType=Enum.ScaleType.Fit
checkIcon.ZIndex=4
checkIcon.Parent=successContainer
successMsg.Size=UDim2.new(1,-40,0,18)
successMsg.Position=UDim2.new(0,20,0,80)
successMsg.BackgroundTransparency=1
successMsg.Font=Enum.Font.Gotham
successMsg.TextSize=12
successMsg.TextColor3=Color3.fromRGB(200,200,200)
successMsg.TextXAlignment=Enum.TextXAlignment.Center
successMsg.Text=""
successMsg.ZIndex=3
successMsg.Parent=successContainer
okBtn.Size=UDim2.new(1,-28,0,44)
okBtn.Position=UDim2.new(0,14,1,-56)
okBtn.BackgroundColor3=Color3.fromRGB(58,86,217)
okBtn.Font=Enum.Font.GothamMedium
okBtn.Text="OK"
okBtn.TextSize=16
okBtn.TextColor3=Color3.new(1,1,1)
okBtn.ZIndex=3
okBtn.Parent=successContainer
okCorner.CornerRadius=UDim.new(0,10)
okCorner.Parent=okBtn

ContentProvider:PreloadAsync({closeBtn, balanceIcon, priceIcon, checkIcon})

-- =============================================== --
--                     ФУНКЦИИ                     --
-- =============================================== --

local function ShowModal() overlay.Visible = true; modal.Visible = true; overlay.BackgroundTransparency = 1; modal.BackgroundTransparency = 1; modal.Size = UDim2.fromOffset(420,175); modal.Position = UDim2.new(0.5,-210,0.5,-87); TweenService:Create(overlay, TweenInfo.new(0.12, Enum.EasingStyle.Linear), {BackgroundTransparency = 0.4}):Play(); TweenService:Create(modal, TweenInfo.new(0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0, Size = UDim2.fromOffset(435,185), Position = UDim2.new(0.5,-217,0.5,-92)}):Play() end
local function HideModal() modal.Visible = false; overlay.Visible = false end

-- [ИЗМЕНЕНО] Полностью переписанная функция уведомления
local function showGameNotification()
    -- Ищем шаблон уведомления. pcall для безопасности
    local success, result = pcall(function()
        local notificationsFrame = player.PlayerGui:WaitForChild("MainFrames", 2):WaitForChild("Notifications", 2)
        if not notificationsFrame then
            warn("[PurchasePro] Не удалось найти 'Notifications' Frame.")
            return nil
        end
        
        local handler = notificationsFrame:WaitForChild("NotificationHandler", 2)
        if not handler then
            warn("[PurchasePro] Не удалось найти 'NotificationHandler' Script.")
            return nil, notificationsFrame
        end

        local template = handler:WaitForChild("SuccessNotification", 2)
        if not template then
            warn("[PurchasePro] Не удалось найти шаблон 'SuccessNotification'.")
            return nil, notificationsFrame
        end

        return template, notificationsFrame
    end)

    if not success or not result then
        warn("[PurchasePro] Показ уведомления невозможен, не найдены необходимые элементы.", result)
        return
    end

    local template, notificationsFrame = result, select(2, result)
    if not template or not notificationsFrame then
        warn("[PurchasePro] Показ уведомления невозможен, не найдены шаблон или контейнер.")
        return
    end

    -- Клонируем, настраиваем и показываем
    local newNotif = template:Clone()
    local textLabel = newNotif:FindFirstChild("TextLabel") -- Находим TextLabel внутри
    if textLabel then
        textLabel.Text = "Thank you for your support!"
        -- Обводка уже должна быть в шаблоне, так что менять не нужно
    end
    
    newNotif.Parent = notificationsFrame -- Помещаем в контейнер, игра должна сама расположить его
    newNotif.Visible = true

    -- Удаляем уведомление через 5 секунд
    task.delay(5, function()
        -- Безопасно удаляем, если оно еще существует
        if newNotif and newNotif.Parent then
            newNotif:Destroy()
        end
    end)
end

closeBtn.MouseButton1Click:Connect(HideModal)
okBtn.MouseButton1Click:Connect(HideModal)

applyBtn.MouseButton1Click:Connect(function()
    customBalance = balanceInput.Text
    if customBalance == "" then customBalance = "76" end
    
    amountValue = addAmountInput.Text
    if amountValue == "" or not tonumber(amountValue) then amountValue = "0" end
    
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
    
    -- [ИЗМЕНЕНА ЛОГИКА] Добавление или установка монет
    local success, err = pcall(function()
        local coinLabel = player.PlayerGui:WaitForChild("Lobby", 5):WaitForChild("CurrenciesFrame", 5):WaitForChild("CoinAmount", 5):WaitForChild("AmountLabel", 5)
        
        if coinLabel then
            local amountToProcess = tonumber(amountValue) or 0
            
            if isSetValueMode then
                -- Режим УСТАНОВКИ
                coinLabel.Text = tostring(amountToProcess)
            else
                -- Режим ДОБАВЛЕНИЯ
                local currentAmountText = coinLabel.Text:gsub(",", "") -- Убираем запятые
                local currentAmount = tonumber(currentAmountText) or 0
                local newAmount = currentAmount + amountToProcess
                coinLabel.Text = tostring(newAmount)
            end
        else
            warn("[PurchasePro] Не удалось найти AmountLabel для обновления монет!")
        end
    end)
    if not success then warn("[PurchasePro] Ошибка при обновлении монет:", err) end
    
    showGameNotification()
    
end)

local function getThumbType(infoType) if infoType == Enum.InfoType.GamePass then return "GamePass" elseif infoType == Enum.InfoType.Bundle then return "BundleThumbnail" else return "Asset" end end
local function fetchAndShow(id, infoType) title.Text = "Buy item"; title.TextSize = 24; successContainer.Visible = false; promptContainer.Visible = true; if not balanceFrame.Parent then balanceFrame.Parent = modal end; itemName.Text = "Loading..."; itemPrice.Text = "..."; local thumbType = getThumbType(infoType); itemIcon.Image = "rbxthumb://type=" .. thumbType .. "&id=" .. id .. "&w=150&h=150"; buyBtn.BackgroundColor3 = Color3.fromRGB(58,86,217); progressFill.BackgroundColor3 = Color3.fromRGB(43,63,165); buyText.TextTransparency = 0; progressFill.Visible = true; progressFill.Size = UDim2.new(0,0,1,0); ShowModal(); task.spawn(function() local ok2, result = pcall(function() return MarketplaceService:GetProductInfo(id, infoType) end); if ok2 and result then itemName.Text = result.Name or "Unknown Item"; itemPrice.Text = tostring(result.PriceInRobux or 0) end end); if currentTween then currentTween:Cancel() end; currentTween = TweenService:Create(progressFill, TweenInfo.new(3, Enum.EasingStyle.Linear), {Size = UDim2.new(1,0,1,0)}); currentTween:Play(); task.spawn(function() currentTween.Completed:Wait(); if promptContainer.Visible then progressFill.Visible = false; canBuy = true end end) end

-- =============================================== --
--                      ХУК (HOOK)                   --
-- =============================================== --
local oldNamecall; local hasHook = typeof(hookmetamethod) == "function"; local hasGetMethod = typeof(getnamecallmethod) == "function"
if hasHook and hasGetMethod then oldNamecall = hookmetamethod(game, "__namecall", function(self, ...) local ok3, method = pcall(getnamecallmethod); if not ok3 then return oldNamecall(self, ...) end; local args = {...}; if self == MarketplaceService and not setupFrame.Visible then local id = tonumber(args[2]); if id then if method == "PromptGamePassPurchase" then fetchAndShow(id, Enum.InfoType.GamePass); return elseif method == "PromptProductPurchase" then fetchAndShow(id, Enum.InfoType.Product); return elseif method == "PromptPurchase" then fetchAndShow(id, Enum.InfoType.Asset); return elseif method == "PromptBundlePurchase" then fetchAndShow(id, Enum.InfoType.Bundle); return end end end; return oldNamecall(self, ...) end) else warn("hookmetamethod/getnamecallmethod недоступны на этом executor") end
