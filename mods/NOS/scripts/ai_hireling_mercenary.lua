-- TODO: Handle when an item is release or removed from a lcoked down container. Must remove all items for sale

require 'NOS:ai_follower'
require 'NOS:incl_faction'

AI.Settings.CanWander = false
AI.Settings.ChaseSpeed = 3.5
AI.Settings.CanConverse = true
AI.Settings.CanWander = false

MERCHANT_HIRE_FEE = 500

attackedByOwner = false
attackedByOwnerCount = 0

if (initializer ~= nil) then
    if( initializer.VillagerNames ~= nil ) then    
        local name = initializer.VillagerNames[math.random(#initializer.VillagerNames)]
        local job = initializer.VillagerJobs[math.random(#initializer.VillagerJobs)]
        this:SetName(name.." the "..job)
    end
end

function DecideIdleState()
    if (IsDead(this)) then AI.StateMachine.ChangeState("Dead") return end 
    if not(AI.IsActive()) then return end   
    if (AI.StateMachine.CurState == "Stay") then return end

    if (attackedByOwner == true) then
        DoDismiss()
    end

    if (IsInCombat(this)) then
        AI.ClearAggroList()
        this:SendMessage("EndCombatMessage")
    end

    -- if we are hired, we stay where we are
    if( IsHired() ) then
        AI.StateMachine.ChangeState("Follow")
    else
        mFollowTarget = this:GetObjVar("controller")
        -- we are supposed to be following someone for a job
        if(mFollowTarget ~= nil) then
            AI.StateMachine.ChangeState("Follow")
        else
            -- not follownig someone so just wander until someone hires us
            AI.StateMachine.ChangeState("Wander")
        end
    end
end

RegisterEventHandler(EventType.Message, "DamageInflicted",
    function (damager)
        if AI.IsValidTarget(damager) then
            if (IsHired() == true and damager == GetHirelingOwner(this)) then
                attackedByOwnerCount = attackedByOwnerCount + 1
                attackedByOwner = true
            end
            --If hp is lower than certain amount and attacked by an owner at least once then run away
            if ((GetCurHealth(this)/GetMaxHealth(this) <= 0.5) and attackedByOwner == true) or attackedByOwnerCount >= 10 then
                this:NpcSpeech("That's it. I've had enough of this!")
                DoDismiss()
            end
        end
    end)

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

function ShowOwnerDialog(user,dialogText)
    AI.IdleTarget = user
    -- DAB TODO: Add more variety to welcome messages
    dialogText = dialogText or "Yes "..StripColorFromString(user:GetName()).."? What do you need?"

    response = {
        { text = "I need you to...", handle = "MoreOptions" },
        { text = "I need to examine you.", handle = "Examine"},
        { text = "Wait here.", handle = "Wait" },
        { text = "Follow me.", handle = "Follow" },
        --{ text = "I need you to be my guard.", handle = "Guard" },
        { text = "I no longer require your services.", handle = "ShowDismiss" },
        { text = "Goodbye.", handle = "" } }

    NPCInteraction(dialogText,this,user,"Responses",response)
    AI.StateMachine.ChangeState("Converse")
end

function ShowLookingForWorkDialog(user)
    if (AI.InAggroList(user)) then
        return
    end

    AI.IdleTarget = user
    local text = "[$72]"..MERCHANT_HIRE_FEE.." coins and I will follow you wherever you go."

    response = {
        { text = "Yes! Follow me!", handle = "BeginHire" ,close = true},
        { text = "No thanks.", handle = "" } }

    NPCInteraction(text,this,user,"Responses",response)
    AI.StateMachine.ChangeState("Converse")
end

function ShowDismissDialog(user)

    -- DAB TODO: Add more variety to welcome messages
    local dialogText = AI.FireHirelingMessages or "[$73]"

    response = {
        { text = "Yes, you can go now.", handle = "DismissConfirm" ,close = true},            
        { text = "Nevermind.", handle = "" } }

    NPCInteraction(dialogText,this,user,"Responses",response)
    AI.StateMachine.ChangeState("Converse")
end

function ShowMoreOptionsDialog(user)

    -- DAB TODO: Add more variety to welcome messages
    local dialogText = AI.MoreOptionsMessage or "...Well what do you need me to do?"

    response = {
        { text = "Put your weapon away for a bit.", handle = "NoAggro" },            
        { text = "Kill anything in your way.", handle = "Aggro" },            
        { text = "Nevermind.", handle = "" } }

    NPCInteraction(dialogText,this,user,"Responses",response)
    AI.StateMachine.ChangeState("Converse")
end
function DoDismiss(user)    
    this:PlayAnimation("cast_heal")
    CallFunctionDelayed(TimeSpan.FromSeconds(0.5),function ( ... )
        CreateObj("portal",this:GetLoc(),"dismiss_portal_created")
    end)
    CallFunctionDelayed(TimeSpan.FromSeconds(1.5),function ( ... )
        PlayEffectAtLoc("TeleportToEffect",this:GetLoc())
        this:Destroy()
    end)
end

RegisterEventHandler(EventType.CreatedObject,"dismiss_portal_created",
    function (success,objRef )
        Decay(objRef, 5)
    end)



--RegisterEventHandler(EventType.Message,"OwnerLoggedIn",
--    function (owner)
--        local offlineEarnings = this:GetObjVar("OfflineEarnings") or 0
--        if(offlineEarnings > 0) then        
--            owner:SendMessageGlobal("PrivateMessage",this:GetName(),"I earned "..offlineEarnings.." for you while you were away.")
--            this:DelObjVar("OfflineEarnings")
--        end
--    end)
function IsHired()
    return this:GetObjVar("controller") ~= nil
end

function HandleInteract(user,usedType)
    if(usedType ~= "Interact") then return end
    if (IsAsleep(this)) then
        return 
    end
    if (user == nil) then return end
    if (not user:IsValid()) then return end
    if (not user:HasObjVar("Invulnerable")) then
        if not(AI.IsValidTarget(user)) then
            return
        end
    end
    --DebugMessage(((GetFaction(user) or 0) < -30), this:GetObjVar("MobileTeamType") ~= nil,"Result: ",(((GetFaction(user) or 0) < -30) and this:GetObjVar("MobileTeamType") ~= nil))
    if (((GetFaction(user) or 0) < -30) and this:GetObjVar("MobileTeamType") ~= nil) then
        InsultTarget(user)
        return
    end    

    local owner = GetHirelingOwner(this)
    if(owner == user) then
        ShowOwnerDialog(user)
    elseif not(IsHired()) then
        ShowLookingForWorkDialog(user)
    end
end



function TryHire(user)
    if not(CanAddHireling(user)) then
        this:NpcSpeech(AI.TooManyHirelingsMessages or "It looks like you've got your hands full here. ")
        return
    end

    if (CountCoins(user) < MERCHANT_HIRE_FEE) then
        this:NpcSpeech("I hate to say this but I'll need you to pay me "..MERCHANT_HIRE_FEE.." gold for me to fight for you.")
        return
    end

    RequestConsumeResource(user,"coins",MERCHANT_HIRE_FEE,"CompleteHire",this)
end

function CompleteHire(user,targetLoc)
    if not(AddHireling(user,this)) then
        this:NpcSpeech(AI.TooManyHirelingsMessages or "[$74]")
        return
    end
    AI.SetSetting("Leash",false)
    AI.SetSetting("StationedLeash",false)
    this:SetSharedObjectProperty("Title", "[F7F705]"..StripColorFromString(user:GetName()).."'s Mercenary[-]")
    this:SendMessage("ReassignSuperior",user)
    this:ClearPathTarget()
    this:NpcSpeech(AI.HiredMessages or "Alright. Let's go.")
    AI.StateMachine.ChangeState("Follow")
end


RegisterEventHandler(EventType.Message, "ConsumeResourceResponse", 
    function (success,transactionId,user)
        if (transactionId == "CompleteHire") then
            if not(success) then
                this:NpcSpeech("Are you trying to play tricks on me?")
            else
                user:SystemMessage("You pay the mercenary his initial fee of "..MERCHANT_HIRE_FEE.." gold.","info")
                CompleteHire(user,completeHireLoc)
            end
        end
    end)

RegisterEventHandler(EventType.DynamicWindowResponse, "Responses",
    function (user,buttonId)
        if(buttonId == "ShowDismiss") then
            ShowDismissDialog(user)
        elseif(buttonId == "DismissConfirm") then
            DoDismiss(user)
        elseif(buttonId == "Wait") then
            AI.StateMachine.ChangeState("Stay")
            this:NpcSpeech("Okay. I'll wait here.")
        elseif(buttonId == "Follow") then
            this:NpcSpeech("Okay. Following you.")
            AI.StateMachine.ChangeState("Follow")
        elseif(buttonId == "NoAggro") then
            this:NpcSpeech("Okay. I won't attack anything.")
            this:SetObjVar("NoAggro",true)
        elseif(buttonId == "MoreOptions") then
            ShowMoreOptionsDialog(user)
        elseif(buttonId == "Aggro") then
            this:NpcSpeech("I'll kill anything that moves.")
            this:DelObjVar("NoAggro")
            AI.StateMachine.ChangeState("Follow")
        elseif(buttonId == "BeginHire") then
            if (AI.InAggroList(user)) then
                return
            end
            TryHire(user)
        elseif(buttonId == "Examine") then
            this:NpcSpeech("...Okay. Sure.")
            user:SendMessage("ShowMobWindowMessage",this)
        end

        DecideIdleState()
    end)

OverrideEventHandler("NOS:base_ai_conversation",EventType.Message, "UseObject", HandleInteract)


function OnHirelingMerchantLoad()
    local bankObj = this:GetEquippedObject("Bank")
    if( bankObj == nil ) then
        CreateEquippedObj("bank_box", this)
    end
end

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
    function()
        OnHirelingMerchantLoad()
        this:SetSharedObjectProperty("Faction","None")
        this:SetSharedObjectProperty("Title", "[F7F705]Mercenary For Hire[-]")
    end)
RegisterEventHandler(EventType.LoadedFromBackup,"",OnHirelingMerchantLoad)

