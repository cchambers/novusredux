-- TODO: Handle when an item is release or removed from a lcoked down container. Must remove all items for sale

require 'ai_follower'
require 'base_transaction'
require 'incl_faction'
require 'merchant_helpers'

AI.Settings.CanWander = false
AI.Settings.NoSpeakOnInteract = true
AI.Settings.StationedLeash = true
AI.Settings.ShouldAggro = false

MERCHANT_HIRE_FEE = 100
MERCHANT_CONSIGNMENT_PERCENT = 10

attackedByOwner = false
attackedByOwnerCount = 0

itemSellPhrases = {
    "[$75]",
    "[$76]",
    "Will do. Anything else?",
    "Your wish is my command. Anything else?",
}

itemBuyPhrases = {
    "Ahh an excellent item you have chosen!",
    "[$77]",
    "Good timing! That item just came in stock.",
}

if (initializer ~= nil) then
    if( initializer.VillagerNames ~= nil ) then    
        local name = initializer.VillagerNames[math.random(#initializer.VillagerNames)]
        local job = initializer.VillagerJobs[math.random(#initializer.VillagerJobs)]
        this:SetName(name.." the "..job)
    end
end

local _plotController
function GetPlot()
	if ( _plotController == nil ) then
		_plotController = this:GetObjVar("PlotController")
	end
	return _plotController
end

function GetShopLoc()
    return this:GetObjVar("ShopLocation")
end

function IsHired()
    return this:HasObjVar("ShopLocation")
end

function IsMerchantOwner(user)
    if ( IsHired() ) then
        local plot = GetPlot()
        return ( plot ~= nil and Plot.IsOwner(user, plot) )
    end
    return false
end

function GetFollowTarget()
    return this:GetObjVar("FollowTarget")
end

function IsFollowTargetInRange()
    local followTarget = GetFollowTarget()
    return followTarget ~= nil and followTarget:IsValid() and (followTarget:DistanceFrom(this) <= 30)
end

function UpdateMerchantTitle()
    -- DAB TODO: Make this more personalized
    this:SetSharedObjectProperty("Title", "[F7F705]Hired Merchant[-]")
end

function DecideIdleState()
    if (IsDead(this)) then AI.StateMachine.ChangeState("Dead") return end
    if not(AI.IsActive()) then return end    

    if (IsInCombat(this)) then
        AI.ClearAggroList()
        this:SendMessage("EndCombatMessage")
    end

    if (attackedByOwner == true) then
        DoDismiss()
    end
    
    -- if we are hired, we stay where we are
    if( IsHired() ) then
        AI.StateMachine.ChangeState("HiredIdle")
    else
        mFollowTarget = GetFollowTarget()
        -- we are supposed to be following someone for a job
        if(mFollowTarget ~= nil) then
            AI.StateMachine.ChangeState("BeingHired")
        else
            -- not follownig someone so just wander until someone hires us
            AI.StateMachine.ChangeState("Wander")
        end
    end
end

RegisterEventHandler(EventType.Message, "DamageInflicted",
    function (damager)
        if AI.IsValidTarget(damager) and (this:GetObjVar("Invulnerable") ~= true) then
            local followTarget = GetFollowTarget()
            if ( followTarget ~= nil and damager == followTarget ) then
                attackedByOwnerCount = attackedByOwnerCount + 1
                attackedByOwner = true
            end
            --If hp is lower than certain amount and attacked by an owner at least once then run away
            if ((GetCurHealth(this)/GetMaxHealth(this) <= 0.8) and attackedByOwner == true) or attackedByOwnerCount >= 4 then
                this:NpcSpeech("That's it. I've had enough of this!")
                DoDismiss()
            end
        end
    end)

AI.StateMachine.AllStates.HiredIdle = {
    OnEnterState = function(self)
        if not(IsHired()) then
            DecideIdleState()
        elseif(GetShopLoc():Distance(this:GetLoc()) > 0.5) then
            self.InitialSubState = "ReturnToShop"
        else
            self.InitialSubState = "Stationed"
        end
    end,

    SubStates = {
        -- DAB TODO: Fix this to use the ReturnHome from base ai
        ReturnToShop = {
            GetPulseFrequencyMS = function() return 300 end,

            OnEnterState = function(self)
                this:PlayEffect("TeleportToEffect")
            end,

            AiPulse = function(self)
                this:PlayEffect("TeleportFromEffect")
                this:SetWorldPosition(GetShopLoc())
                AI.StateMachine.ChangeSubState("Stationed")
            end,
        },

        Stationed = {
            GetPulseFrequencyMS = function() return math.random(3000,5000) end,

            OnEnterState = function(self)
                self:AiPulse()
            end,

            AiPulse = function(self)
                local shopLoc = GetShopLoc()
                local release = ( shopLoc == nil )
                if not( release ) then
                    local plot = GetPlot()
                    release = ( plot == nil )
                    if not( release ) then
                        release = ( Plot.GetAtLoc(shopLoc) ~= plot )
                    end
                end
                if ( release ) then
                    ReleaseHireling(this)
                    this:DelObjVar("ShopLocation")
                    this:DelObjVar("merchantSaleItem")
                    this:SetSharedObjectProperty("Title", "[F7F705]Merchant For Hire[-]")
                    DecideIdleState()
                elseif( shopLoc:Distance(this:GetLoc()) > 0.5 ) then
                    AI.StateMachine.ChangeSubState("ReturnToShop")
                end
            end,
        },
    },
}

AI.StateMachine.AllStates.BeingHired = {
    InitialSubState = "FollowTarget",

    SubStates = {
        FollowTarget = {
            GetPulseFrequencyMS = function() return math.random(2000,3000) end,

            OnEnterState = function(self,parent)
                parent.LastSeenFollowTarget = ServerTimeMs()
                this:NpcSpeech("Ok, lead the way!")
                self:AiPulse(parent)
            end,    

            AiPulse = function(self,parent)
                if(IsFollowTargetInRange()) then
                    parent.LastSeenFollowTarget = ServerTimeMs()
                    if not(this:IsMoving()) then
                        this:PathToTarget(GetFollowTarget(),5.0,ServerSettings.Stats.RunSpeedModifier)
                    end
                else
                    this:ClearPathTarget()
                    AI.StateMachine.ChangeSubState("WaitForFollowTarget")
                end
            end,
        },

        WaitForFollowTarget = {
            GetPulseFrequencyMS = function() return math.random(2000,3000) end,

            AiPulse = function(self,parent)
                this:StopMoving()
                if(IsFollowTargetInRange()) then
                    AI.StateMachine.ChangeSubState("FollowTarget")
                else
                    local timeSinceLastSeen = ServerTimeMs() - parent.LastSeenFollowTarget
                    if(timeSinceLastSeen > parent.WaitForFollowerTime) then
                        this:NpcSpeech("Hmm, not sure where they went. Oh well.")
                        this:DelObjVar("FollowTarget")
                        DoDismiss()
                    end
                end
            end,
        },
    },

    IsFollowTargetInRange = function()
        local followTarget = GetFollowTarget()
        return (followTarget ~= nil and followTarget:IsValid() and followTarget:DistanceFrom(this) <= MAX_PATHTO_DIST)
    end,

    LastSeenFollowTarget = nil,
    -- wait 2 minutes before giving up on our potential boss
    WaitForFollowerTime = 120 * 1000,
}

AI.StateMachine.AllStates.Wander = {
        GetPulseFrequencyMS = function() return math.random(1700,2400) end,
        
        OnEnterState = function()
            local wanderRegion = this:GetObjVar("WanderRegion")
            WanderInRegion(wanderRegion,"Wander")
        end,

        OnArrived = function (success)
            if (AI.StateMachine.CurState ~= "Wander") then
                return 
            end
            --if( math.random(2) == 1) then
            --    this:PlayAnimation("fidget")
            --end         
            AI.StateMachine.ChangeState("ReturnToPath")   
        end,

        AiPulse = function()  
            DecideIdleState()
        end,
    }

AI.StateMachine.AllStates.DoNothing = {}

function CountEarnings()
    local bankObj = this:GetEquippedObject("Bank")
    if(bankObj) then
        return CountResourcesInContainer(bankObj,"coins")
    end

    return 0
end

function ShowOwnerDialog(user,dialogText)
    AI.IdleTarget = user
    -- DAB TODO: Add more variety to welcome messages
    dialogText = dialogText or "Why hello "..StripColorFromString(user:GetName()).."! What can I do for you?"

    response = {
        { text = "I have something for you to sell.", handle = "AddSaleItem" },
        { text = "I wish to collect my money.", handle = "ShowCollectMoney"},
        { text = "I would like you to move.", handle = "ShowMove"},
        { text = "I no longer require your services.", handle = "ShowDismiss" },
        { text = "Goodbye.", handle = "" } }

    NPCInteraction(dialogText,this,user,"Responses",response)
    AI.StateMachine.ChangeState("Converse")
end

function ShowFollowDialog(user)
    AI.IdleTarget = user
    local text = "Aha! So is this where you want me to set up shop?"

    response = {
        { text = "Yes! I'd like you to stand here.", handle = "HireSetLocation" },
        { text = "I no longer require your services.", handle = "CancelHire" ,close = true},
        { text = "Nevermind.", handle = "" } }

    NPCInteraction(text,this,user,"Responses",response)
    AI.StateMachine.ChangeState("Converse")
end

function ShowLookingForWorkDialog(user)

    if (AI.InAggroList(user)) then
        return
    end

    AI.IdleTarget = user
    local text = "[$78]"..ValueToAmountStr(MERCHANT_HIRE_FEE,false,true).." and I will take "..MERCHANT_CONSIGNMENT_PERCENT.."% of all sales as my commission."

    response = {
        { text = "Yes! Follow me!", handle = "BeginHire"},
        { text = "No thanks.", handle = "" } }

    NPCInteraction(text,this,user,"Responses",response)
    AI.StateMachine.ChangeState("Converse")
end

function ShowCollectMoneyDialog(user)
    AI.IdleTarget = user

    local earnings = CountEarnings()

    if(earnings == 0) then
        QuickDialogMessage(this,user,"[$79]")
    else
        -- DAB TODO: Add more variety to welcome messages
        local dialogText = "Great news! We've earned "..ValueToAmountStr(earnings,false,true).." since you've last come to collect."

        response = {
            { text = "I'll take it.", handle = "CollectMoneyConfirm" },            
            { text = "You can hang onto it.", handle = "" } }

        NPCInteraction(dialogText,this,user,"Responses",response)
        AI.StateMachine.ChangeState("Converse")
    end
end

function ShowDismissDialog(user)
    local earnings = CountEarnings()

    if(earnings ~= 0) then
        QuickDialogMessage(this,user,"[$80]")
    elseif ( #(this:GetObjVar("merchantSaleItem") or {}) > 0 ) then
        QuickDialogMessage(this,user,"I'm still selling items for you. You should reclaim your items for sale before you consider sending me off.")
        -- KH TODO: allow a force dismiss option here
    else
        -- DAB TODO: Add more variety to welcome messages
        local dialogText = "[$81]"

        response = {
            { text = "Yes, you can go now.", handle = "DismissConfirm" ,close = true},            
            { text = "Nevermind.", handle = "" } }

        NPCInteraction(dialogText,this,user,"Responses",response)
        AI.StateMachine.ChangeState("Converse")
    end
end

function ShowMoveDialog(user)

    if ( IsMerchantOwner(user) ) then
        if ( this:HasTimer("MerchantMovedRecently") ) then
            this:NpcSpeech("Hold on, I'm really tired.")
            return
        end
        this:NpcSpeech("Where would you like me?")
        RegisterSingleEventHandler(EventType.ClientTargetLocResponse,"SelectMoveLocation",HandleHireMoveLocation)
        user:RequestClientTargetLoc(this, "SelectMoveLocation")
    end
end

function DoCollectMoney(user)
    local bankObj = this:GetEquippedObject("Bank")
    local userBackpack = user:GetEquippedObject("Backpack")            
    if(bankObj and userBackpack) then
        local coinsObj = FindItemInContainerByTemplate(bankObj,"coin_purse")                
        if(coinsObj ~= nil) then
            if(userBackpack:CanHold(coinsObj)) then
                coinsObj:SendMessage("ChangeUp")
                coinsObj:MoveToContainer(userBackpack,GetRandomDropPosition(userBackpack))
                QuickDialogMessage(this,user,"[$82]")
            else
                QuickDialogMessage(this,user,"It seems your backpack can't hold that much money.")
            end
        end
    end
end

function DoDismiss()
    local merchantSaleItem = this:GetObjVar("merchantSaleItem")
    
    if (merchantSaleItem ~= nil) then
        for key,value in pairs(merchantSaleItem) do
            value:SendMessage("RemoveFromSale")
        end
    end

    this:PlayAnimation("cast_heal")
    this:DelObjVar("merchantSaleItem")
    ReleaseHireling(this)
    this:DelObjVar("ShopLocation")

    local loc = this:GetLoc()
    CallFunctionDelayed(TimeSpan.FromSeconds(0.5),function ( ... )
        CreateObj("portal",loc,"dismiss_portal_created")
    end)
    CallFunctionDelayed(TimeSpan.FromSeconds(1.5),function ( ... )
        PlayEffectAtLoc("TeleportToEffect",loc)
        this:Destroy()
    end)
end

RegisterEventHandler(EventType.Message,"DismissMerchant",function ()
    DoDismiss()
end)

RegisterEventHandler(EventType.CreatedObject,"dismiss_portal_created",
    function (success,objRef )
       Decay(objRef, 5)
    end)

function Merchant.DoCantAfford(buyer)
    QuickDialogMessage(this,buyer,"I beg your pardon, but you can't afford that.",-1)
end

function Merchant.DoPurchaseComplete(buyer)
    local myRep = buyer:GetObjVar("merchantReputation") or 0
    myRep = myRep + .1
    buyer:SetObjVar("merchantReputation", myRep)
    QuickDialogMessage(this,buyer,"Thank you for your patronage "..buyer:GetName()..".",-1)
end

function Merchant.DoPurchase(buyer,item,price)
    item:SendMessage("RemoveFromSale",buyer)    

    local itemEarnings = math.floor(price * ((100 - MERCHANT_CONSIGNMENT_PERCENT) / 100))
    if(itemEarnings > 0) then
        -- put the money in the bank so players cant loot it
        local bankObj = this:GetEquippedObject("Bank")
        if( bankObj ~= nil ) then
            local coinsObj = FindItemInContainerByTemplate(bankObj,"coin_purse")
            if(coinsObj ~= nil) then
                RequestAddToStack(coinsObj,itemEarnings)
            else
                CreateObjInContainer("coin_purse", bankObj, Loc(0,0,0), "sale_coins",itemEarnings)    
            end
        end
    end

    Merchant.DoPurchaseComplete(buyer)
end

RegisterEventHandler(EventType.CreatedObject,"sale_coins",
    function(success,objRef,amount)
        if(success and amount > 1) then
            RequestSetStack(objRef,amount)
        end
    end)

function ValidateBuyItem(item)
    if(not(item) or not(item:IsValid())) then
        this:NpcSpeech("That item is not for sale.")
        return false
    end

    local itemPrice = item:GetObjVar("itemPrice") or 0
    if(itemPrice <= 0) then
        this:NpcSpeech("That item is not for sale.")
        return false
    end

    return true
end

function ShowPurchaseItemDialog(user,item)
    ValidateBuyItem(item)

    local itemPrice = item:GetObjVar("itemPrice")
    InitiateTransaction(user,item,itemPrice,1)
end

function ShowTransactionConfirm(transactionId,buyer,buyItem,itemPrice, amount)
    local buyPhrase = itemBuyPhrases[math.random(#itemBuyPhrases)]
    buyPhrase = buyPhrase .. " Are you sure you wish to purchase "..StripColorFromString(buyItem:GetName()).." for "..ValueToAmountStr(itemPrice,false,true).."?"
    response = {
        { text = "Yes.", handle = "BuyItem|"..transactionId },
        { text = "I've changed my mind.", handle = "CancelBuy|"..transactionId } }

    NPCInteraction(buyPhrase,this,buyer,"Responses",response,nil,20)
    AI.StateMachine.ChangeState("Converse")
end

function HandleInteract(user,usedType)
    if(usedType ~= "Interact") then return end
    
    if (IsAsleep(this)) then
        return 
    end

    if not(IsValidInteractTarget(user)) then
        return
    end

    if (GetFaction(user) < -30) then
        InsultTarget(user)
        return
    end    

    if( IsMerchantOwner(user) ) then
        ShowOwnerDialog(user)
        return
    end

    local followTarget = GetFollowTarget()
    if ( followTarget == user ) then
        ShowFollowDialog(user)
    elseif ( not IsHired() and not followTarget ) then
        ShowLookingForWorkDialog(user)
    else
        QuickDialogMessage(this,user,"[$83]")
    end
end

function ValidateSaleItem(target,user)
    if( target == nil or not IsMerchantOwner(user) ) then 
        this:NpcSpeech("I can't sell that.") 
        return false
    end

    if ( IsLockedDown(target) ) then
        this:NpcSpeech("That is locked down, I cannot sell it like that!")
        return false
    end

    if(target:IsMobile() or (target:GetObjVar("HouseObject") ~= nil)) then
        this:NpcSpeech("How do you expect me to sell that!")
        return false
    end        

    local topCont = target:TopmostContainer() or target
    if(topCont:IsMobile()) then
        this:NpcSpeech("[$84]")
        return false
    end

    -- if this is in a container, make sure its locked down
    if(target ~= topCont and not(IsLockedDown(topCont))) then
        this:NpcSpeech("You might want to lock that container down first.")
        return false
    end

    local topmostObj = target:TopmostContainer() or target
    local plot = this:GetObjVar("PlotController")
    if ( plot == nil or Plot.GetAtLoc(topmostObj:GetLoc()) ~= plot ) then 
        this:NpcSpeech("That item is not on your property.")
        return false
    end

    if(target:HasModule("hireling_merchant_sale_item")) then
        this:NpcSpeech("That item is already for sale.")
    end

    if(target:IsContainer()) then
        local saleItemFound = false
        ForEachItemInContainerRecursive(target,
            function (contObj)
                if(contObj:HasModule("hireling_merchant_sale_item")) then
                    saleItemFound = true
                    return false
                end
                return true
            end)

        if(saleItemFound) then
            this:NpcSpeech("[$85]")
            return false
        end
    end

    if(target:HasObjVar("IsHouse") or target:HasObjVar("HouseObject") or target:HasObjVar("IsPlotObject") ) then
        this:NpcSpeech("How do you expect me to sell that!")
        return false
    end

    -- make sure none of the parent ocntainers are for sale
    local inSaleContainer = false
    ForEachParentContainerRecursive(target,false,
        function (parentObj)
            if(parentObj:HasModule("hireling_merchant_sale_item")) then                
                inSaleContainer = true
                return false
            end
            return true
        end)

    if(inSaleContainer) then
        this:NpcSpeech("[$86]")
        return false
    end

    return true
end

function HandleAddSaleItem(target,user)
    if(target == nil) then
        return
    end

    if not(ValidateSaleItem(target,user)) then
        return
    end

    TextFieldDialog.Show{
        TargetUser = user,
        ResponseObj = this,
        Title = "Set Price",
        Description = "Set the price of your item.",
        ResponseFunc = function(user,newValue)
            if(newValue ~= nil and newValue ~= "") then
                local itemPrice = tonumber(newValue)
                if(itemPrice ~= nil and ValidateSaleItem(target,user)) then
                    target:AddModule("hireling_merchant_sale_item",{Price=itemPrice,Merchant=this}) 
                    ShowOwnerDialog(user,itemSellPhrases[math.random(#itemSellPhrases)])     
                end
            end
        end
    }
end

function RemoveFromSpawner()
    if(this:HasTimer("ClearSpawnerTimer")) then
        this:RemoveTimer("ClearSpawnerTimer")
    end

    local spawner = this:GetObjVar("Spawner")
    if (spawner ~= nil) then
        spawner:SendMessage("RemoveSpawnedObject",this)
    end
end

RegisterSingleEventHandler(EventType.Timer,"ClearSpawnerTimer",function ( ... )
        RemoveFromSpawner()
    end)

function HandleHireSelectLocation(success,targetLoc,targetObj,user)
    if ( not success or GetFollowTarget() ~= user ) then return end

    local owner, plot = Plot.IsOwnerForLoc(user,targetLoc)
    if not( owner ) then
        this:NpcSpeech("[$87]")
        return
    end

    local m = nil
    Plot.ForeachMerchant(plot, function(merchant)
        m = merchant
        return true
    end)
    if ( m ) then
        this:NpcSpeech("There is another merchant here already.")
        return
    end
    
    local coinStr = ValueToAmountStr(MERCHANT_HIRE_FEE,false,true)
    if ( ConsumeResourceContainer(user, "coins", MERCHANT_HIRE_FEE) ) then
        user:SystemMessage("You pay the merchant his initial fee of "..coinStr..".")
        CompleteHire(user, targetLoc, plot)
    else
        this:NpcSpeech("Are you trying to play tricks on me? That will be "..coinStr.." please.")
    end
end

function HandleHireMoveLocation(success,targetLoc,targetObj,user)
    if ( not success or not IsMerchantOwner(user) ) then
        return
    end

    -- prevent them from moving plots/verify ownership of land target
    local plot = GetPlot()
    if ( plot == nil or Plot.GetAtLoc(targetLoc) ~= plot ) then
        this:NpcSpeech("[$87]")
        return
    end

    this:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "MerchantMovedRecently")    
    this:SetObjVar("ShopLocation",targetLoc)
    AI.StateMachine.ChangeSubState("ReturnToShop")
end

function CompleteHire(user, loc, plot)
    this:SetObjVar("ShopLocation", loc)
    this:SetObjVar("PlotController", plot)
    this:DelObjVar("FollowTarget")
    this:DelObjVar("controller")
    user:DelObjVar("MerchantFollower")
    UpdateMerchantTitle()
    RemoveFromSpawner()
    this:ClearPathTarget()
    AI.StateMachine.ChangeState("HiredIdle")

    -- DAB TODO: Merchants should be attackable like everyone else!
    -- But until we have hireling guards this would suck for merchants out of guard protection
    this:SetObjVar("Invulnerable",true)

    this:SetObjVar("NoReset",true)
    if(this:HasModule("spawn_decay")) then
        this:DelModule("spawn_decay")
    end
end

RegisterEventHandler(EventType.DynamicWindowResponse, "Responses",
    function (user,buttonId)
        if(buttonId == "AddSaleItem") then
            if ( IsMerchantOwner(user) ) then
                user:RequestClientTargetGameObj(this, "AddSaleItem")
                RegisterSingleEventHandler(EventType.ClientTargetGameObjResponse,"AddSaleItem",HandleAddSaleItem)
            end
        elseif(buttonId=="ShowMove") then
            ShowMoveDialog(user)
        elseif(buttonId=="ShowCollectMoney") then
            ShowCollectMoneyDialog(user)
        elseif(buttonId == "ShowDismiss") then
            ShowDismissDialog(user)
        elseif(buttonId == "CollectMoneyConfirm") then
            DoCollectMoney(user)
        elseif(buttonId == "DismissConfirm") then
            DoDismiss()
        elseif(buttonId == "BeginHire") then
            if (AI.InAggroList(user)) then
                return
            end
            if(IsHired() or GetFollowTarget()) then return end
            local userFollower = user:GetObjVar("MerchantFollower")
            if(userFollower and userFollower:IsValid()) then
                this:NpcSpeech("It appears you already have a merchant following you.")
                return
            end

            if not(CanAddHireling(user,true)) then
                this:NpcSpeech("[$88]")
                return
            end

            this:ScheduleTimerDelay(TimeSpan.FromSeconds(60),"ClearSpawnerTimer")
            this:SetObjVar("InvalidTarget", true)
            this:SetObjVar("FollowTarget",user)
            user:SetObjVar("MerchantFollower",this)
            AddHireling(user, this, true)
            this:SendMessage("ReassignSuperior",user)
            AI.StateMachine.ChangeState("BeingHired")
            user:CloseDynamicWindow("Responses")
        elseif(buttonId == "HireSetLocation") then
            if(GetFollowTarget() == user) then
                user:RequestClientTargetLoc(this, "SelectLocation")
                RegisterSingleEventHandler(EventType.ClientTargetLocResponse,"SelectLocation",HandleHireSelectLocation)
            end
            user:CloseDynamicWindow("Responses")
        elseif(buttonId == "CancelHire") then
            if(GetFollowTarget() == user) then
                this:DelObjVar("FollowTarget")
                user:DelObjVar("MerchantFollower")
            end
            DoDismiss()
        elseif(buttonId:match("BuyItem")) then
            dummy,transactionId = string.match(buttonId, "(%a+)|(.+)")
            --DebugMessage("buttonId",buttonId,tostring(transactionId))
            HandleTransactionConfirm(user,transactionId)
        elseif(buttonId:match("CancelBuy")) then
            dummy,transactionId = string.match(buttonId, "(%a+)|(.+)")
            ClearTransaction(transactionId)
            user:CloseDynamicWindow("Responses")
        elseif(buttonId == "Close") then
            user:CloseDynamicWindow("Responses")
        end

        DecideIdleState()
    end)

RegisterEventHandler(EventType.Message, "UseObject", HandleInteract)

RegisterEventHandler(EventType.Message,"SellItem",
    function (buyer,item)
        ShowPurchaseItemDialog(buyer,item)
    end)

function OnHirelingMerchantLoad()
    local bankObj = this:GetEquippedObject("Bank")
    if( bankObj == nil ) then
        CreateEquippedObj("bank_box", this)
    end

    if ( this:HasObjVar("MerchantOwnerUserId") ) then
        local plot = Plot.GetAtLoc(this:GetLoc())
        if ( plot ) then this:SetObjVar("PlotController", plot) end
        this:DelObjVar("MerchantOwnerUserId")
    end

    UpdateMerchantTitle()
end

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
    function()
        OnHirelingMerchantLoad()
        this:SetSharedObjectProperty("Title", "[F7F705]Merchant For Hire[-]")
    end)
RegisterEventHandler(EventType.LoadedFromBackup,"",OnHirelingMerchantLoad)

