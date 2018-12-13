require 'incl_celador_locations'
require 'incl_regions'
require 'base_ai_mob'
require 'base_ai_intelligent' 
require 'base_ai_conversation' 
require 'base_merchant'
require 'base_skill_trainer'
require 'incl_faction'
require 'incl_crafting_orders'

Dialog = {}
QuestDialog = {}

AI.Settings.SkipIntroDialog = false
AI.Settings.SetIntroObjVar = true
AI.Settings.KnowName = true
AI.Settings.CanCast = true
AI.Settings.DoNotBoast = true
AI.Settings.EnableRepair = false
AI.Settings.SpeechTable = "Villager"

require 'incl_npc_tasks'

AI.TradeMessages = 
{
"Well I'm here to trade!"
}

AI.GreetingMessages = 
{
"Hello, anything I can help you with?",
}

AI.QuestMessages = 
{
    ", I have something for you!",
    ", come talk to me!",
    ", come over here!",
}

AI.NevermindMessages = 
{
"Anything else?",
}


AI.Settings.AlertRange = 10.0

function IsFriend(target)
    --My only enemy is the enemy
    if (AI.InAggroList(target)) then
        --DebugMessage(1)
        return false
    else
        --DebugMessage(2)
        return true
    end
end

function OpenQuestDialog(user,questName,taskName)
    if (Dialog["Open"..questName..taskName.."Dialog"] ~= nil) then
        Dialog["Open"..questName..taskName.."Dialog"](user)
    else
        DebugMessage("[base_ai_npc|OpenQuestDialog] ERROR: No quest dialog found for "..this:GetName()..", quest is "..tostring(questName)..", taskName is "..tostring(taskName))
    end
end

AI.StateMachine.AllStates.Idle = { 
        GetPulseFrequencyMS = function() return math.random(3000,4000) end,
        AiPulse = function() 
            local homeFacing = this:GetObjVar("SpawnFacing")
            if( homeFacing ~= nil ) then
                --DebugMessage("Setting facing to "..tostring(homeFacing))
                --this:SetFacing(homeFacing)
            end
            --aiRoll = math.random(4)
            --if(aiRoll == 1) then
            --    AI.StateMachine.ChangeState("GoLocation")            
            --else
            --    AI.StateMachine.ChangeState("Wander")
            --end         
            
            if ((this:GetObjVar("ImportantNPC")) and math.random(1,3) == 1) then
                local spawnLoc = this:GetObjVar("SpawnLocation")
                local distance = this:GetLoc():Distance(spawnLoc)        
                if(distance > 2) then
                    AI.StateMachine.ChangeState("GoHome")
                end
            end

            DecideIdleState()
        end,        
    }

AI.StateMachine.AllStates.GoLocation = {
        OnEnterState = function()
            destination = CeladorLocations[math.random(#CeladorLocations)]
            this:PathTo(destination.Loc,1.0,"GoLocation")
        end,

        OnArrived = function (success)
            if(success) then
                if (AI.StateMachine.CurState ~= "GoLocation") then
                    return 
                end
                if( destination ~= nil ) then 
                    this:SetFacing(destination.Facing)
                    if( destination.Name == "VillageWell" ) then
                        this:PlayAnimation("cast")
                    end
                end
            end
            DecideIdleState()
        end,
    }

function CanUseNPC(user)
    if (IsDead(this)) then return false end
    --DebugMessage("AI.MainTarget is "..tostring(AI.MainTarget),"user is "..tostring(user)," and is in combat is "..tostring(IsInCombat(this)))
    if (AI.MainTarget == user and IsInCombat(this)) then 
        if (InsultTarget ~= nil and AI.GetSetting("CanConverse")) then
            --DebugMessage("Yarrgh why are you doing this")
            InsultTarget(user)
        end
        user:CloseDynamicWindow("Responses")
        return false
    end
    return true
end

function HandleInteract(user,usedType)
    if(usedType ~= "Interact") then return end
    if (not CanUseNPC(user)) then return end
    
    --DebugMessage(tostring(user))
    if (not AI.IsValidTarget(user) and not user:HasObjVar("Invulnerable")) then
        return 
    end

    if (IsAsleep(this)) then
        return 
    end
    AI.IdleTarget = user
    --if (AI.GetSetting("CanConverse")) then
        AI.StateMachine.ChangeState("Converse")
    --end
    user:SendMessage("NPCInteraction",this)
    local userQuestTable = user:GetObjVar("QuestTable") or {}
    local activeQuest = user:GetObjVar("LastActiveQuest")
    if (activeQuest ~= nil) then
         for n,k in pairs(userQuestTable) do
            if k.QuestName == activeQuest  then
                --DebugMessage("k.questName is "..tostring(k.QuestName).." k.CurrentTask is "..tostring(k.CurrentTask))
                if (k.CurrentTask ~= nil and (not (k.QuestFinished == true))) then
                     if (Dialog["Open"..k.QuestName..k.CurrentTask.."Dialog"] ~= nil) then
                        OpenQuestDialog(user,k.QuestName,k.CurrentTask)
                        return
                    end
                end
            end
        end
    end
    --go through all the elements again, so that if there's a quest that's not active then choose that dialog
     for n,k in pairs(userQuestTable) do
         if (k.CurrentTask ~= nil and (not (k.QuestFinished == true))) then
            --DebugMessage("CHECKING FOR","Open"..k.QuestName..k.CurrentTask.."Dialog")
            if (Dialog["Open"..k.QuestName..k.CurrentTask.."Dialog"] ~= nil) then
                OpenQuestDialog(user,k.QuestName,k.CurrentTask)
                return
            end
         end
    end
  --DebugMessage(5)
    local strippedName = StripColorFromString(this:GetName())
    if (not(AI.GetSetting("SkipIntroDialog")) and not user:HasObjVar("Intro|"..strippedName) and IntroDialog ~= nil) then
        if (AI.GetSetting("SetIntroObjVar") == true) then
            user:SetObjVar("Intro|"..strippedName,true)
        end
        IntroDialog(user)
        return
    end
   --DebugMessage(6)
    local urgentTask = GetUrgentTask(user)
    if (urgentTask ~= nil) then 
        Dialog.OpenNPCTasksInquiryDialog(user,urgentTask.TaskName)
        return
    end
        
    Dialog.OpenGreetingDialog(user)
end

function Dialog.OpenGreetingDialog(user)
    text = AI.GreetingMessages[math.random(1,#AI.GreetingMessages)]

    response = {}

    response[1] = {}
    response[1].text = "I want to know something..."
    response[1].handle = "Talk" 

    if (AI.GetSetting("MerchantEnabled") ~= nil and AI.GetSetting("MerchantEnabled") == true) then
        response[2] = {}
        response[2].text = "I want to trade..."
        response[2].handle = "Trade" 
    else
        response[2] = {}
        response[2].text = "Who are you?"
        response[2].handle = "Who" 
    end

    if (CountTable(NPCTasks) > 0) then 
        response[3] = {}
        response[3].text = "It's regarding work..."
        response[3].handle = "Work" 
    end

    if (AI.GetSetting("EnableTrain") ~= nil and AI.GetSetting("EnableTrain") == true and CanTrain()) then
        response[5] = {}
        response[5].text = "Train me in a skill..."
        response[5].handle = "Train" 
    end

    response[6] = {}
    response[6].text = "Goodbye."
    response[6].handle = "" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

--dummy function that deletes the intro objvar allowing the intros to show more than once.
function Dialog.OpenResetIntroDialog(user)
    user:DelObjVar("Intro|"..this:GetName())
end

function IntroDialog(user)

    text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]

    response = {}

    response[1] = {}
    response[1].text = "I have a question..."
    response[1].handle = "Talk" 

    response[2] = {}
    response[2].text = "Who are you?"
    response[2].handle = "Who"

    response[3] = {}
    response[3].text = "I need something."
    response[3].handle = "Nevermind"

    if (this:GetObjVar("CraftOrderSkill")~= nil) then
        response[4] = {}
        response[4].text = "About crafting orders..."
        response[4].handle = "Work" 
    end

    response[5] = {}
    response[5].text = "Goodbye."
    response[5].handle = "" 

    

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenWorkDialog(user)
    text = "Folks come to me when they need something made, but I don't always have the time to handle all of these orders. That's why I sometimes look to other craftsmen for help. If you're willing to take a crafting order off of my hands, I'll cut you in on the reward."

    response = {}

    response[1] = {}
    response[1].text = "What orders do you need filled?"
    response[1].handle = "CraftingOrder"

    response[2] = {}
    response[2].text = "I have a completed order."
    response[2].handle = "OrderSubmit"

--[[
    response[1] = {}
    response[1].text = "I need work."
    response[1].handle = "NPCTasks" 

    response[2] = {}
    response[2].text = "I have a task I need to complete..."
    response[2].handle = "NPCCurrentTasksList" 
]]--
    response[3] = {}
    response[3].text = "Nevermind."
    response[3].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)

end

function Dialog.OpenTradeDialog(user)
    text = AI.TradeMessages[math.random(1,#AI.TradeMessages)]

    if (AI.GetSetting("MerchantEnabled") == nil) then
        return
    end

    response = {}

    if (AI.GetSetting("EnableBuy") ~= nil and AI.GetSetting("EnableBuy") == true) then
        response[1] = {}
        response[1].text = "I want to buy something."
        response[1].handle = "Buy" 
        
        response[2] = {}
        response[2].text = "How much would you buy this for?"
        response[2].handle = "Appraise" 

        response[3] = {}
        response[3].text = "I wish to sell something..."
        response[3].handle = "Sell" 
    end

    if (AI.GetSetting("EnableBank") ~= nil and AI.GetSetting("EnableBank") == true) then
        response[4] = {}
        response[4].text = "I want to bank items."
        response[4].handle = "Bank" 
    end
    if (AI.GetSetting("EnableTax") ~= nil and AI.GetSetting("EnableTax") == true) then
        response[5] = {}
        response[5].text = "I want to pay taxes."
        response[5].handle = "Tax" 
    end
    if (AI.GetSetting("EnableRepair"))  then
        response[6] = {}
        response[6].text = "I need to repair something."
        response[6].handle = "RepairItem"
    end

    --To enable crafting orders, add "CraftOrderSkill" objVar to required skill. Ex, Blacksmiths should hand out Metalsmith orders
    if (this:GetObjVar("CraftOrderSkill")~= nil and this:HasModule("base_merchant")) then
        response[7] = {}
        response[7].text = "About crafting orders..."
        response[7].handle = "Work" 
    end

    response[8] = {}
    response[8].text = "Nevermind"
    response[8].handle = "" 

    NPCInteractionLongButton(text,this,user,"Responses",response)

end

--THESE FUNCTIONS SHOULD BE OVERRIDDEN
function Dialog.OpenHelpDialog(user)
    QuickDialogMessage(this,user,"I have no brains to help you!")
end
function Dialog.OpenTalkDialog(user)
    QuickDialogMessage(this,user,"I have nothing to say at all!")
end
function Dialog.OpenWhoDialog(user)
    QuickDialogMessage(this,user,"I don't know who I am!")
end
function Dialog.OpenRepairItemDialog(user) 
    DebugMessage("ERROR: Repair not implemented!")
    --this:AddModule("repair_controller")   
    --this:SendMessage("RESTART_REPAIR_PROCESS", user,this,this:GetObjVar("RepairSkill"))
end

function Dialog.OpenCraftingOrderDialog(user)
    
    local orderInfo = {}
    --If the commission has already been offered, use it. Otherwise, pick a new one.
    if (GetCommission(user) == nil) then
        for i=1,3 do
            table.insert(orderInfo,PickCraftingOrder(user))
        end
        AddCommission(user, orderInfo)
        --orderInfo = PickCraftingOrder(user)
    else
        orderInfo = GetCommission(user)[1]
    end
    
    response = {}

    --If the player doesn't meet minimum skill for any order, shoo them away
    
    if (orderInfo ~= nil) then
        text = "Here's what I have."
        if not (GetCommission(user)[2]) then
            for i, j in pairs(orderInfo) do
                response[i] = {}

                if (orderInfo[i].Material ~= nil) then
                    response[i].text = orderInfo[i].Amount.." "..ResourceData.ResourceInfo[orderInfo[i].Material].CraftedItemPrefix.." "..GetItemNameFromRecipe(orderInfo[i].Recipe)
                else
                    response[i].text = orderInfo[i].Amount.." "..GetItemNameFromRecipe(orderInfo[i].Recipe)
                end

                
                response[i].handle = "CraftOrder|"..i
            end
        else 
            text = "I already gave you a crafting order. Why don't you try completing that first. If you really want more work, come back later and I'll see what I can get for you."
        end
    else
        text = "Sorry pal, but I'm not paying amatuers. Try getting some experience under your belt, and maybe I'll be able to pull up something for you."
    end

    response[#orderInfo+1] = {}
    response[#orderInfo+1].text = "Nevermind."
    response[#orderInfo+1].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenOrderAcceptDialog(user)
    text = ("Here you go then. Don't be thinking you just bring me a pile of scattered items though. Use the crafting order to package them up, and return it to me. Other craftsmen like myself will also accept a completed order. It'll get back to me one way or another.")

    response = {}

    response[1] = {}
    response[1].text = "Thank you."
    response[1].handle = "" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenOrderSubmitDialog(user)
    text = "Alright then, show me what you got!"
    user:RequestClientTargetGameObj(this, "pickOrder")
    response = {}

    response[1] = {}
    response[1].text = "Nevermind"
    response[1].handle = "" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function NevermindDialog(user)
    if (user == nil or not user:IsValid()) then return end
    text = AI.NevermindMessages[math.random(1,#AI.NevermindMessages)]

    response = {}

    response[1] = {}
    response[1].text = "I want to know something..."
    response[1].handle = "Talk" 

    if (AI.GetSetting("MerchantEnabled") ~= nil and AI.GetSetting("MerchantEnabled") == true) then
        response[2] = {}
        response[2].text = "I want to trade..."
        response[2].handle = "Trade" 
    else
        response[2] = {}
        response[2].text = "Who are you?"
        response[2].handle = "Who" 
    end
    if (CountTable(NPCTasks) > 0) then 
        response[3] = {}
        response[3].text = "It's regarding work..."
        response[3].handle = "Work" 
    end

    if (this:GetObjVar("CraftOrderSkill")~= nil) then
        response[4] = {}
        response[4].text = "About crafting orders..."
        response[4].handle = "Work" 
    end

    if (AI.GetSetting("EnableTrain") ~= nil and AI.GetSetting("EnableTrain") == true and CanTrain()) then
        response[5] = {}
        response[5].text = "Train me in a skill..."
        response[5].handle = "Train" 
    end

    response[6] = {}
    response[6].text = "Goodbye."
    response[6].handle = "" 

    NPCInteractionLongButton(text,this,user,"Responses",response)

    this:StopMoving()
    --DebugMessage(tostring(user))
    this:SetFacing(this:GetLoc():YAngleTo(user:GetLoc()))
    AI.StateMachine.ChangeState("Idle")
end
AI.NevermindDialog = NevermindDialog

function GetAttention(user)
    if (IsAsleep(this)) then
        return 
    end
    this:StopMoving()
    this:SetFacing(this:GetLoc():YAngleTo(user:GetLoc()))
    AI.StateMachine.ChangeState("Converse")
end



function ResponsesDialog (user,buttonID)
    if (not CanUseNPC(user)) then return end
    --if (IsInCombat(this)) then return end
    --DebugMessage("ButtonID is "..tostring(buttonID))
    if (not AI.IsValidTarget(user) and not user:HasObjVar("Invulnerable")) then return end
    GetAttention(user)
    --DebugMessage("user is "..tostring(user))
    if (buttonID == "Trade" and AI.GetSetting("MerchantEnabled") ~= nil) then
        Dialog.OpenTradeDialog(user)
    elseif (buttonID == "Nevermind") then
        NevermindDialog(user)
    elseif (buttonID == "Help") then
        Dialog.OpenHelpDialog(user)
    elseif (buttonID == "Bank") then
        OpenBank(user,this)
    elseif (buttonID == "Talk") then
        Dialog.OpenTalkDialog(user)
    elseif (buttonID == "Who") then
        Dialog.OpenWhoDialog(user)
    elseif (buttonID == "Sell") then
        Merchant.DoSell(user)
    elseif (buttonID == "Appraise") then
        Merchant.DoAppraise(user)
    elseif (buttonID == "Train" and AI.GetSetting("EnableTrain") ~= nil and CanTrain()) then
        SkillTrainer.ShowTrainContextMenu(user)
    elseif (buttonID == "Buy") then
        QuickDialogMessage(this,user,AI.HowToPurchaseMessages[math.random(1,#AI.HowToPurchaseMessages)])
    elseif ( Dialog["Open"..buttonID.."Dialog"] ~= nil) then 
        Dialog["Open"..buttonID.."Dialog"](user)
    elseif(buttonID == "Close") then
        user:CloseDynamicWindow("Responses")
    elseif (this:GetObjVar("CraftOrderSkill")) then
        local items = StringSplit(buttonID, "|")
        if (items[1] == "CraftOrder") then
            local commission = GetCommission(user)
            local orderIndex = tonumber(items[2])
            local order =  commission[1][orderIndex]
            if not (commission[2]) then
                CommissionAccepted(user)
                CreateCraftingOrder(user, order)
                Dialog.OpenOrderAcceptDialog(user)
            end
        end
    elseif (buttonID ~= nil and buttonID ~= "" and buttonID ~= "Ok") then
        DebugMessage("[base_ai_npc|ResponsesDialog] ERROR: Invalid NPC dialog received! buttonID is "..tostring(buttonID))
    end
end

RegisterEventHandler(EventType.EnterView,"NearbyPlayer",
    function(player)
        if (player ~= nil and player:IsValid()) then
            if (AI.GetSetting("HasQuest")) then
                if (AI.QuestList ~= nil) then
                    for i,j in pairs(AI.QuestList) do --DFB TODO: Make quest lists open up a dialog on interact.
                        if (not HasFinishedQuest(player,j)) then
                            FaceObject(this,player)
                            if (AI.GetSetting("KnowName") ~= false) then
                                this:NpcSpeech("Hey "..player:GetName()..AI.QuestMessages[math.random(1,#AI.QuestMessages)])
                            else
                                this:NpcSpeech(AI.QuestMessages[math.random(1,#AI.QuestMessages)])
                            end
                            return
                        end
                    end
                end
            end
        end
    end)

AddView("NearbyPlayer", SearchPlayerInRange(10))
RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
    function ()
        --        --DFB TODO: Right now guard protect is specific to villagers. When it's generic remove this check and always add it.
        if (this:GetObjVar("MobileTeamType") == "Villagers") then
            if (not this:HasModule("guard_protect")) then
                this:AddModule("guard_protect")
            end
        end
        
        AddUseCase(this,"Interact",true)
    
    end)

if ( this:GetObjVar("ImportantNPC") ) then
    SetMobileMod(this, "AttackTimes", "ImportantNPC", 3.5)
end

OverrideEventHandler("base_ai_conversation",EventType.Message, "UseObject", HandleInteract)
RegisterEventHandler(EventType.DynamicWindowResponse, "Responses",ResponsesDialog)
RegisterEventHandler(EventType.Message,"DamageInflicted",function (damager,damageAmount)
    if (damager:IsPlayer()) then
        damager:CloseDynamicWindow("Responses")
    end
end)
RegisterEventHandler(EventType.Arrived, "GoLocation",AI.StateMachine.AllStates.GoLocation.OnArrived)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "pickOrder", HandleOrderSubmission)