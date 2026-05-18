local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")

local player = Players.LocalPlayer

for _,v in pairs(player.PlayerGui:GetChildren()) do
    if v.Name == "RobloxPurchaseMenu_Pro" then v:Destroy() end
end

local gui = Instance.new("ScreenGui")
gui.Name = "RobloxPurchaseMenu_Pro"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player.PlayerGui

local customBalance = "76"
local amountToAdd   = "20000"
local amountToSet   = "0"
local doSetEnabled  = false
local currentItemPrice = 0

-- ===============================================
--              ОКНО НАСТРОЕК
-- ===============================================

local setupFrame = Instance.new("Frame")
setupFrame.Size = UDim2.fromOffset(300, 330)
setupFrame.Position = UDim2.new(0.5,-150,0.5,-165)
setupFrame.BackgroundColor3 = Color3.fromRGB(25,27,33)
setupFrame.BorderSizePixel = 0
setupFrame.Active = true
setupFrame.ZIndex = 50
setupFrame.Parent = gui
Instance.new("UICorner",setupFrame).CornerRadius = UDim.new(0,12)

local setupTitle = Instance.new("TextLabel")
setupTitle.Size = UDim2.new(1,0,0,40)
setupTitle.BackgroundTransparency = 1
setupTitle.Text = "Settings (Drag me)"
setupTitle.Font = Enum.Font.GothamBold
setupTitle.TextSize = 20
setupTitle.TextColor3 = Color3.new(1,1,1)
setupTitle.Parent = setupFrame

local function makeLabel(parent, text, posY)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,-40,0,18)
    l.Position = UDim2.new(0,20,0,posY)
    l.BackgroundTransparency = 1
    l.Text = text
    l.Font = Enum.Font.GothamMedium
    l.TextSize = 13
    l.TextColor3 = Color3.fromRGB(160,165,190)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
end

local function makeInput(parent, def, ph, posY)
    local b = Instance.new("TextBox")
    b.Size = UDim2.new(1,-40,0,38)
    b.Position = UDim2.new(0,20,0,posY)
    b.BackgroundColor3 = Color3.fromRGB(40,43,53)
    b.Text = def
    b.PlaceholderText = ph
    b.Font = Enum.Font.Gotham
    b.TextSize = 16
    b.TextColor3 = Color3.new(1,1,1)
    b.ClearTextOnFocus = false
    b.Parent = parent
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)
    return b
end

makeLabel(setupFrame, "Fake Robux balance", 44)
local balanceInput = makeInput(setupFrame, customBalance, "Enter fake Robux balance", 62)

makeLabel(setupFrame, "Add coins after purchase", 112)
local addInput = makeInput(setupFrame, amountToAdd, "Amount to ADD", 130)

local setToggleBtn = Instance.new("TextButton")
setToggleBtn.Size = UDim2.new(1,-40,0,32)
setToggleBtn.Position = UDim2.new(0,20,0,182)
setToggleBtn.BackgroundColor3 = Color3.fromRGB(40,43,53)
setToggleBtn.Text = ""
setToggleBtn.AutoButtonColor = false
setToggleBtn.Parent = setupFrame
Instance.new("UICorner",setToggleBtn).CornerRadius = UDim.new(0,8)

local checkBox = Instance.new("Frame")
checkBox.Size = UDim2.fromOffset(18,18)
checkBox.Position = UDim2.new(0,8,0.5,-9)
checkBox.BackgroundColor3 = Color3.fromRGB(25,27,33)
checkBox.BorderSizePixel = 1
checkBox.BorderColor3 = Color3.fromRGB(100,105,130)
checkBox.Parent = setToggleBtn
Instance.new("UICorner",checkBox).CornerRadius = UDim.new(0,4)

local checkMark = Instance.new("TextLabel")
checkMark.Size = UDim2.new(1,0,1,0)
checkMark.BackgroundTransparency = 1
checkMark.Text = "✓"
checkMark.Font = Enum.Font.GothamBold
checkMark.TextSize = 14
checkMark.TextColor3 = Color3.fromRGB(59,99,246)
checkMark.Visible = false
checkMark.Parent = checkBox

local setToggleLabel = Instance.new("TextLabel")
setToggleLabel.Size = UDim2.new(1,-36,1,0)
setToggleLabel.Position = UDim2.new(0,36,0,0)
setToggleLabel.BackgroundTransparency = 1
setToggleLabel.Text = "Set coins on Save"
setToggleLabel.Font = Enum.Font.Gotham
setToggleLabel.TextSize = 13
setToggleLabel.TextColor3 = Color3.fromRGB(200,200,210)
setToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
setToggleLabel.Parent = setToggleBtn

setToggleBtn.MouseButton1Click:Connect(function()
    doSetEnabled = not doSetEnabled
    checkMark.Visible = doSetEnabled
    checkBox.BackgroundColor3 = doSetEnabled
        and Color3.fromRGB(35,38,58)
        or Color3.fromRGB(25,27,33)
end)

makeLabel(setupFrame, "Set coins to value (по галочке)", 226)
local setInput = makeInput(setupFrame, amountToSet, "Value to SET", 244)

local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(1,-40,0,40)
applyBtn.Position = UDim2.new(0,20,0,292)
applyBtn.BackgroundColor3 = Color3.fromRGB(59,99,246)
applyBtn.Text = "Save & Start"
applyBtn.Font = Enum.Font.GothamBold
applyBtn.TextSize = 16
applyBtn.TextColor3 = Color3.new(1,1,1)
applyBtn.Parent = setupFrame
Instance.new("UICorner",applyBtn).CornerRadius = UDim.new(0,8)

local dragging,dragInput,dragStart,startPos
setupFrame.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging=true; dragStart=inp.Position; startPos=setupFrame.Position
        inp.Changed:Connect(function()
            if inp.UserInputState==Enum.UserInputState.End then dragging=false end
        end)
    end
end)
setupFrame.InputChanged:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseMovement then dragInput=inp end
end)
UserInputService.InputChanged:Connect(function(inp)
    if inp==dragInput and dragging then
        local d=inp.Position-dragStart
        setupFrame.Position=UDim2.new(
            startPos.X.Scale,startPos.X.Offset+d.X,
            startPos.Y.Scale,startPos.Y.Offset+d.Y
        )
    end
end)

-- ===============================================
--          МОДАЛЬНОЕ ОКНО
-- ===============================================

local overlay=Instance.new("TextButton")
overlay.Size=UDim2.new(1,0,1,0); overlay.BackgroundColor3=Color3.new(0,0,0)
overlay.BackgroundTransparency=1; overlay.Text=""; overlay.AutoButtonColor=false
overlay.Visible=false; overlay.ZIndex=1; overlay.Parent=gui

local modal=Instance.new("Frame")
modal.Size=UDim2.fromOffset(435,185); modal.Position=UDim2.new(0.5,-217,0.5,-92)
modal.BackgroundColor3=Color3.fromRGB(17,19,28); modal.BorderSizePixel=0
modal.Visible=false; modal.ClipsDescendants=true; modal.ZIndex=2; modal.Parent=gui

local mc=Instance.new("UISizeConstraint")
mc.MaxSize=Vector2.new(435,185); mc.MinSize=Vector2.new(435,185); mc.Parent=modal
Instance.new("UICorner",modal).CornerRadius=UDim.new(0,18)

local title=Instance.new("TextLabel")
title.Size=UDim2.new(0,220,0,34); title.Position=UDim2.new(0,16,0,14)
title.BackgroundTransparency=1; title.Font=Enum.Font.GothamBold
title.Text="Buy item"; title.TextSize=24; title.TextColor3=Color3.new(1,1,1)
title.TextXAlignment=Enum.TextXAlignment.Left; title.ZIndex=3; title.Parent=modal

local closeBtn=Instance.new("ImageButton")
closeBtn.Size=UDim2.fromOffset(24,24); closeBtn.Position=UDim2.new(1,-32,0,16)
closeBtn.BackgroundTransparency=1
closeBtn.Image="rbxthumb://type=Asset&id=78940278565096&w=420&h=420"
closeBtn.ScaleType=Enum.ScaleType.Fit; closeBtn.ZIndex=4; closeBtn.Parent=modal

local balanceFrame=Instance.new("Frame")
balanceFrame.AutomaticSize=Enum.AutomaticSize.X; balanceFrame.Size=UDim2.new(0,0,0,24)
balanceFrame.AnchorPoint=Vector2.new(1,0); balanceFrame.Position=UDim2.new(1,-62,0,18)
balanceFrame.BackgroundTransparency=1; balanceFrame.ZIndex=3; balanceFrame.Parent=modal

local bfl=Instance.new("UIListLayout")
bfl.FillDirection=Enum.FillDirection.Horizontal
bfl.HorizontalAlignment=Enum.HorizontalAlignment.Left
bfl.VerticalAlignment=Enum.VerticalAlignment.Center
bfl.Padding=UDim.new(0,5); bfl.Parent=balanceFrame

-- [ИСПРАВЛЕНО] Рабочий asset иконки робуксов
local ROBUX_IMG = "rbxthumb://type=Asset&id=70493384532723&w=420&h=420"

local balanceIcon=Instance.new("ImageLabel")
balanceIcon.Size=UDim2.fromOffset(20,20); balanceIcon.BackgroundTransparency=1
balanceIcon.Image=ROBUX_IMG
balanceIcon.ScaleType=Enum.ScaleType.Fit; balanceIcon.ZIndex=4; balanceIcon.Parent=balanceFrame

local balanceText=Instance.new("TextLabel")
balanceText.AutomaticSize=Enum.AutomaticSize.X; balanceText.Size=UDim2.new(0,0,1,0)
balanceText.BackgroundTransparency=1; balanceText.Font=Enum.Font.GothamMedium
balanceText.TextSize=16; balanceText.TextColor3=Color3.new(1,1,1)
balanceText.Text=customBalance; balanceText.ZIndex=4; balanceText.Parent=balanceFrame

local promptContainer=Instance.new("Frame")
promptContainer.Size=UDim2.new(1,0,1,0); promptContainer.BackgroundTransparency=1
promptContainer.ZIndex=3; promptContainer.Parent=modal

local itemIcon=Instance.new("ImageLabel")
itemIcon.Size=UDim2.fromOffset(64,64); itemIcon.Position=UDim2.new(0,14,0,52)
itemIcon.BackgroundTransparency=1; itemIcon.ZIndex=3; itemIcon.Parent=promptContainer

local itemName=Instance.new("TextLabel")
itemName.Size=UDim2.new(0,280,0,28); itemName.Position=UDim2.new(0,88,0,55)
itemName.BackgroundTransparency=1; itemName.Font=Enum.Font.GothamBold
itemName.TextSize=17; itemName.TextColor3=Color3.new(1,1,1)
itemName.TextXAlignment=Enum.TextXAlignment.Left; itemName.Text="Loading..."
itemName.ZIndex=3; itemName.Parent=promptContainer

local priceFrame=Instance.new("Frame")
priceFrame.AutomaticSize=Enum.AutomaticSize.X; priceFrame.Size=UDim2.new(0,0,0,22)
priceFrame.Position=UDim2.new(0,88,0,83); priceFrame.BackgroundTransparency=1
priceFrame.ZIndex=3; priceFrame.Parent=promptContainer

local pfl=Instance.new("UIListLayout")
pfl.FillDirection=Enum.FillDirection.Horizontal
pfl.HorizontalAlignment=Enum.HorizontalAlignment.Left
pfl.VerticalAlignment=Enum.VerticalAlignment.Center
pfl.Padding=UDim.new(0,5); pfl.Parent=priceFrame

local priceIcon=Instance.new("ImageLabel")
priceIcon.Size=UDim2.fromOffset(20,20); priceIcon.BackgroundTransparency=1
priceIcon.Image=ROBUX_IMG
priceIcon.ScaleType=Enum.ScaleType.Fit; priceIcon.ZIndex=4; priceIcon.Parent=priceFrame

local itemPrice=Instance.new("TextLabel")
itemPrice.AutomaticSize=Enum.AutomaticSize.X; itemPrice.Size=UDim2.new(0,0,1,0)
itemPrice.BackgroundTransparency=1; itemPrice.Font=Enum.Font.GothamMedium
itemPrice.TextSize=16; itemPrice.TextColor3=Color3.new(1,1,1)
itemPrice.Text="5"; itemPrice.ZIndex=4; itemPrice.Parent=priceFrame

local buyBtn=Instance.new("TextButton")
buyBtn.Size=UDim2.new(1,-28,0,44); buyBtn.Position=UDim2.new(0,14,1,-56)
buyBtn.BackgroundColor3=Color3.fromRGB(58,86,217); buyBtn.Text=""
buyBtn.AutoButtonColor=false; buyBtn.ClipsDescendants=true
buyBtn.ZIndex=3; buyBtn.Parent=promptContainer
Instance.new("UICorner",buyBtn).CornerRadius=UDim.new(0,10)

local progressFill=Instance.new("Frame")
progressFill.Size=UDim2.new(0,0,1,0); progressFill.BackgroundColor3=Color3.fromRGB(43,63,165)
progressFill.BorderSizePixel=0; progressFill.ZIndex=4; progressFill.Parent=buyBtn
Instance.new("UICorner",progressFill).CornerRadius=UDim.new(0,9)

local buyText=Instance.new("TextLabel")
buyText.Size=UDim2.new(1,0,1,0); buyText.BackgroundTransparency=1
buyText.Font=Enum.Font.GothamMedium; buyText.TextSize=16
buyText.Text="Buy"; buyText.TextColor3=Color3.new(1,1,1)
buyText.ZIndex=5; buyText.Parent=buyBtn

local successContainer=Instance.new("Frame")
successContainer.Size=UDim2.new(1,0,1,0); successContainer.BackgroundTransparency=1
successContainer.Visible=false; successContainer.ZIndex=3; successContainer.Parent=modal

-- [ИСПРАВЛЕНО] Одна галочка, опущена ниже, по центру
local checkIcon=Instance.new("ImageLabel")
checkIcon.Size=UDim2.fromOffset(60,60)
checkIcon.AnchorPoint=Vector2.new(0.5,0)
checkIcon.Position=UDim2.new(0.5,0,0,22)
checkIcon.BackgroundTransparency=1
checkIcon.Image="rbxthumb://type=Asset&id=110759125205910&w=420&h=420"
checkIcon.ScaleType=Enum.ScaleType.Fit
checkIcon.ZIndex=4
checkIcon.Parent=successContainer

-- [ИСПРАВЛЕНО] Текст по центру, без лишней иконки
local successMsg=Instance.new("TextLabel")
successMsg.Size=UDim2.new(1,-40,0,18)
successMsg.Position=UDim2.new(0,20,0,90)
successMsg.BackgroundTransparency=1
successMsg.Font=Enum.Font.Gotham
successMsg.TextSize=12
successMsg.TextColor3=Color3.fromRGB(200,200,200)
successMsg.TextXAlignment=Enum.TextXAlignment.Center
successMsg.ZIndex=3
successMsg.Parent=successContainer

local okBtn=Instance.new("TextButton")
okBtn.Size=UDim2.new(1,-28,0,44); okBtn.Position=UDim2.new(0,14,1,-56)
okBtn.BackgroundColor3=Color3.fromRGB(58,86,217); okBtn.Font=Enum.Font.GothamMedium
okBtn.Text="OK"; okBtn.TextSize=16; okBtn.TextColor3=Color3.new(1,1,1)
okBtn.ZIndex=3; okBtn.Parent=successContainer
Instance.new("UICorner",okBtn).CornerRadius=UDim.new(0,10)

-- ===============================================
--                  ФУНКЦИИ
-- ===============================================

local function ShowModal()
    overlay.Visible=true; modal.Visible=true
    overlay.BackgroundTransparency=1; modal.BackgroundTransparency=1
    modal.Size=UDim2.fromOffset(420,175); modal.Position=UDim2.new(0.5,-210,0.5,-87)
    TweenService:Create(overlay,TweenInfo.new(0.12,Enum.EasingStyle.Linear),{BackgroundTransparency=0.4}):Play()
    TweenService:Create(modal,TweenInfo.new(0.16,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
        BackgroundTransparency=0,
        Size=UDim2.fromOffset(435,185),
        Position=UDim2.new(0.5,-217,0.5,-92)
    }):Play()
end

local function HideModal()
    modal.Visible=false; overlay.Visible=false
end

local function getAmountLabel()
    local ok,res=pcall(function()
        return player.PlayerGui
            :WaitForChild("Lobby",5)
            :WaitForChild("CurrenciesFrame",5)
            :WaitForChild("CoinAmount",5)
            :WaitForChild("AmountLabel",5)
    end)
    if ok and res then return res end
    warn("[PurchasePro] AmountLabel не найден")
    return nil
end

local function setCoins(val)
    local lbl = getAmountLabel()
    if lbl then
        lbl.Text = tostring(val)
        print("[PurchasePro] SET монет:", val)
    end
end

local function addCoins(val)
    val = tonumber(val)
    if not val or val == 0 then
        warn("[PurchasePro] addCoins: некорректное значение", val)
        return
    end
    local lbl = getAmountLabel()
    if not lbl then return end
    local cleanText = string.match(lbl.Text, "-?%d+") or "0"
    local cur = tonumber(cleanText) or 0
    local new = cur + val
    lbl.Text = tostring(new)
    print("[PurchasePro] ADD монет:", val, "| было:", cur, "| стало:", new)
end

local function spendRobux(amount)
    amount = tonumber(amount) or 0
    if amount <= 0 then return end
    local cur = tonumber(customBalance) or 0
    customBalance = tostring(math.max(0, cur - amount))
    balanceText.Text = customBalance
    print("[PurchasePro] Списано:", amount, "| остаток:", customBalance)
end

local function showGameNotification()
    task.spawn(function()
        task.wait(1 + math.random() * 0.4)

        local pgui = player.PlayerGui
        local mainFrames = pgui:FindFirstChild("MainFrames")
        if not mainFrames then warn("[PurchasePro] MainFrames не найден"); return end
        local notifContainer = mainFrames:FindFirstChild("Notifications")
        if not notifContainer then warn("[PurchasePro] Notifications не найден"); return end
        local handler = notifContainer:FindFirstChild("NotificationHandler")
        if not handler then warn("[PurchasePro] NotificationHandler не найден"); return end
        local template = handler:FindFirstChild("SuccessNotification")
        if not template then warn("[PurchasePro] SuccessNotification не найден"); return end

        local notifFrame = template:Clone()

        local setup = notifFrame:FindFirstChild("Setup")
        if setup then setup:Destroy() end

        local lbl = notifFrame:FindFirstChildWhichIsA("TextLabel")
        if lbl then
            lbl.Text = "Thank you for your support!"
            lbl.TextTransparency = 0
            local stroke = lbl:FindFirstChildWhichIsA("UIStroke")
            if stroke then stroke.Transparency = 0 end
        end

        notifFrame.Visible = true
        notifFrame.Parent = notifContainer

        task.wait(5)
        if notifFrame and notifFrame.Parent then
            notifFrame:Destroy()
        end
    end)
end

-- ===============================================
--              СОХРАНЕНИЕ НАСТРОЕК
-- ===============================================
applyBtn.MouseButton1Click:Connect(function()
    customBalance = balanceInput.Text ~= "" and balanceInput.Text or "76"
    amountToAdd = addInput.Text ~= "" and addInput.Text or "0"
    amountToSet = setInput.Text ~= "" and setInput.Text or "0"
    balanceText.Text = customBalance

    if doSetEnabled then
        local sv = tonumber(amountToSet)
        if sv ~= nil then setCoins(sv) end
    end

    setupFrame.Visible = false
    print("[PurchasePro] Сохранено. Balance:", customBalance, "| Add:", amountToAdd, "| Set:", amountToSet)
end)

closeBtn.MouseButton1Click:Connect(HideModal)
okBtn.MouseButton1Click:Connect(HideModal)

-- ===============================================
--                  ЛОГИКА BUY
-- ===============================================

local canBuy = false
local currentTween

buyBtn.MouseButton1Click:Connect(function()
    if not canBuy then return end
    canBuy = false

    TweenService:Create(buyBtn,TweenInfo.new(0.18),{BackgroundColor3=Color3.fromRGB(39,52,120)}):Play()
    TweenService:Create(progressFill,TweenInfo.new(0.18),{BackgroundColor3=Color3.fromRGB(30,40,90)}):Play()
    TweenService:Create(buyText,TweenInfo.new(0.18),{TextTransparency=0.35}):Play()
    task.wait(1.1)

    promptContainer.Visible = false
    successContainer.Visible = true
    balanceFrame.Parent = nil
    title.Text = "Purchase completed"
    title.TextSize = 20
    successMsg.Text = "You have successfully bought " .. itemName.Text .. "."

    spendRobux(currentItemPrice)
    addCoins(amountToAdd)
    showGameNotification()
end)

-- ===============================================
--                      ХУК
-- ===============================================

local function fetchAndShow(id, infoType)
    title.Text="Buy item"; title.TextSize=24
    successContainer.Visible=false; promptContainer.Visible=true
    if not balanceFrame.Parent then balanceFrame.Parent=modal end
    itemName.Text="Loading..."; itemPrice.Text="..."
    itemIcon.Image=""; currentItemPrice=0
    buyBtn.BackgroundColor3=Color3.fromRGB(58,86,217)
    progressFill.BackgroundColor3=Color3.fromRGB(43,63,165)
    buyText.TextTransparency=0; progressFill.Visible=true
    progressFill.Size=UDim2.new(0,0,1,0)
    ShowModal()

    task.spawn(function()
        local ok,info=pcall(function()
            return MarketplaceService:GetProductInfo(id,infoType)
        end)
        if ok and info then
            itemName.Text = info.Name or "Unknown Item"
            local price = info.PriceInRobux or 0
            itemPrice.Text = tostring(price)
            currentItemPrice = price

            if infoType==Enum.InfoType.Product then
                local iconId=info.IconImageAssetId
                itemIcon.Image=(iconId and iconId~=0) and "rbxthumb://type=Asset&id="..tostring(iconId).."&w=150&h=150" or ""
            elseif infoType==Enum.InfoType.GamePass then
                itemIcon.Image="rbxthumb://type=GamePass&id="..tostring(id).."&w=150&h=150"
            elseif infoType==Enum.InfoType.Bundle then
                itemIcon.Image="rbxthumb://type=BundleThumbnail&id="..tostring(id).."&w=150&h=150"
            else
                itemIcon.Image="rbxthumb://type=Asset&id="..tostring(id).."&w=150&h=150"
            end
        end
    end)

    if currentTween then currentTween:Cancel() end
    currentTween=TweenService:Create(
        progressFill,
        TweenInfo.new(3,Enum.EasingStyle.Linear),
        {Size=UDim2.new(1,0,1,0)}
    )
    currentTween:Play()
    task.spawn(function()
        currentTween.Completed:Wait()
        if promptContainer.Visible then
            progressFill.Visible=false
            canBuy=true
        end
    end)
end

local function fetchAndShowDelayed(id,infoType)
    task.spawn(function()
        task.wait(0.8+math.random()*0.4)
        fetchAndShow(id,infoType)
    end)
end

local oldNamecall
local hasHook=typeof(hookmetamethod)=="function"
local hasGetMethod=typeof(getnamecallmethod)=="function"

if hasHook and hasGetMethod then
    oldNamecall=hookmetamethod(game,"__namecall",function(self,...)
        local ok,method=pcall(getnamecallmethod)
        if not ok then return oldNamecall(self,...) end
        local args={...}
        if self==MarketplaceService and not setupFrame.Visible then
            local id=tonumber(args[2])
            if id then
                if method=="PromptGamePassPurchase" then
                    fetchAndShowDelayed(id,Enum.InfoType.GamePass); return
                elseif method=="PromptProductPurchase" then
                    fetchAndShowDelayed(id,Enum.InfoType.Product); return
                elseif method=="PromptPurchase" then
                    fetchAndShowDelayed(id,Enum.InfoType.Asset); return
                elseif method=="PromptBundlePurchase" then
                    fetchAndShowDelayed(id,Enum.InfoType.Bundle); return
                end
            end
        end
        return oldNamecall(self,...)
    end)
else
    warn("hookmetamethod/getnamecallmethod недоступны на этом executor")
end
