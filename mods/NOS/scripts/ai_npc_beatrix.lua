require 'NOS:base_ai_npc'
require 'NOS:incl_celador_locations'

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = false
AI.Settings.SetIntroObjVar = false
AI.Settings.SpeechTable = "Guard"
fixPrice = 20

--AI.QuestList = {"WarriorIntroQuest"}
AI.Settings.KnowName = false --she doesn't give a fuck about your name, greenhorn
--AI.Settings.HasQuest = true
--AI.QuestMessages = {"Oh look. Another greenhorn.","Preferable if that one knew how to fight.","What's with these newcomers?"}

NPCTasks = {
    --[[CaptureCultistsTask = {
        TaskName = "CaptureCultistsTask",
        TaskDisplayName = "Captured Cultist",
        Description = "Capture a cultist",
        FinishDescription = "Bring the prisoner back to Beatrix",
        RewardType = "coins",
        RewardAmount = 650,
        Repeatable = true, --if you can redo the task
        Importance = 2, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$292]",
        TaskAcceptSpeech = "[$293]",
        TaskCurrentSpeech = "Have you captured a prisoner, outsider?",
        TaskContinueSpeech = "[$294]",
        TaskCancelSpeech = "[$295]",
        TaskHelpSpeech = "[$296]",
        TaskPreCompleteSpeech = "[$297]",
        TaskFinishedMessage = "[$298]",
        TaskIncompleteMessage = "[$299]",
        TaskAssists = {
                      {Template = "cel_guard_rufus",Text = "[$300]"},
                      {Template = "cel_mayor",Text = "[$301]"},
                      {Template = "cel_blacksmith",Text = "[$302]"},
                      {Template = "cel_rothchilde",Text = "[$303]"},
                    },
        CheckCompletionCallback = function (user,task)
            local prisoner = FindObject(SearchMulti({
                SearchMobileInRange(10),
                SearchObjVar("MobileTeamType","Cultists"),
                SearchObjVar("controller",user)
                }))
            if (prisoner ~= nil) then
                return true
            end
            return false
        end,
        CompletionCallback = function (user,task)
            local prisoner = FindObject(SearchMulti({
                SearchMobileInRange(10),
                SearchObjVar("MobileTeamType","Cultists")
                }))
            if (prisoner ~= nil) then
                prisoner:SendMessage("ChangeOwnerMessage",this)
                prisoner:AddModule("decay")
                prisoner:SetObjVar("DecayTime",30)
                prisoner:SetObjVar("CannotBeCaptured",true)
            else
                QuickDialogMessage(this,user,task.TaskIncompleteMessage)
            end
            DoTaskFinish(user,task)
        end,
        Faction = "Villagers",
        FactionOnFinish = 3,
        FactionOnAccept = 1,
    },
    SacrificalKnifeTask = {
        TaskName = "SacrificalKnifeTask",
        TaskDisplayName = "Sacrifical Knife",
        Description = "Find a sacrifical dagger",
        FinishDescription = "Bring the knife back to Beatrix",
        RewardType = "weapon_staff_arcane",
        TaskMinimumFaction = 10,
        RewardAmount = 1,
        Repeatable = false, --if you can redo the task
        Importance = 4, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$304]",
        TaskAcceptSpeech = "[$305]",
        TaskCurrentSpeech = "[$306]",
        TaskContinueSpeech = "[$307]",
        TaskCancelSpeech = "[$308]",
        TaskHelpSpeech = "[$309]",
        TaskPreCompleteSpeech = "[$310]",
        TaskFinishedMessage = "[$311]",
        TaskIncompleteMessage = "[$312]",
        TaskAssists = {
                      {Template = "cel_guard_rufus",Text = "[$313]"},
                      {Template = "cel_mayor",Text = "[$314]"},
                      {Template = "cel_blacksmith",Text = "[$315]"},
                      {Template = "cel_rothchilde",Text = "[$316]"},
                    },
        CompletionCallback = "Items",
        CheckCompletionCallback = "Items",
        TaskItemList = {
        {"weapon_dagger_sacrificial",1}
        },
        Faction = "Villagers",
        FactionOnFinish = 3,
        FactionOnAccept = 1,
    },
    TraitorousMercenaryTask = {
        TaskName = "TraitorousMercenaryTask",
        TaskDisplayName = "The Traitor Mercenary",
        TaskMinimumFaction = 15,
        RewardType = "coins",
        Description = "Capture or kill the rebel guard.",
        FinishDescription = "Bring him or his head back to Beatrix",
        RewardAmount = 1200,
        Repeatable = true, --if you can redo the task
        Importance = 2, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$317]",
        TaskAcceptSpeech = "[$318]",
        TaskCurrentSpeech = "[$319]",
        TaskContinueSpeech = "[$320]",
        TaskCancelSpeech = "[$321]",
        TaskHelpSpeech = "[$322]",
        TaskPreCompleteSpeech = "[$323]",
        TaskFinishedMessage = "[$324]",
        TaskIncompleteMessage = "[$325]",
       TaskAssists = {
                      {Template = "cel_guard_rufus",Text = "[$326]"},
                      {Template = "cel_mayor",Text = "[$327]"},
                      {Template = "cel_merchant_bartender",Text = "[$328]"},
                      {Template = "cel_rothchilde",Text = "[$329]"},
                      },
        CheckCompletionCallback = function (user,task)
            local prisoner = FindObject(SearchMulti({
                SearchMobileInRange(10),
                SearchObjVar("MobileTeamType","Rebels"),
                }))
            if (prisoner ~= nil) then
                prisoner:SendMessage("ChangeOwnerMessage",this)
                prisoner:AddModule("decay")
            else
                local backpackObj = user:GetEquippedObject("Backpack")
                local traitorHead = FindItemInContainerRecursive(backpackObj,function(item)
                    if (item:GetObjVar("DeceasedMobileTeamType") == "Rebels") then
                        return true
                    end
                end)
                if (traitorHead ~= nil) then
                    return true
                end
            end
            return false
        end,
        CompletionCallback = function (user,task)
            local prisoner = FindObject(SearchMulti({
                SearchMobileInRange(10),
                SearchObjVar("MobileTeamType","Rebels"),
                }))
            if (prisoner ~= nil) then
                prisoner:SetObjVar("controller",this)
                prisoner:AddModule("decay")
            else
                local backpackObj = user:GetEquippedObject("Backpack")
                local traitorHead = FindItemInContainerRecursive(backpackObj,function(item)
                    if (item:GetObjVar("DeceasedMobileTeamType") == "Rebels") then
                        return true
                    end
                end)
                if (traitorHead ~= nil) then
                    traitorHead:Destroy()
                end
            end
            DoTaskFinish(user,task)
        end,
        Faction = "Villagers",
        FactionOnFinish = 4,
        FactionOnAccept = 2,
    },]]
}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$330]",
} 

AI.TradeMessages = 
{
    "Trade? Trade what?"
}

AI.GreetingMessages = 
{
	"What do you want?",
	"I'm busy. What do you want.",
	"Make it quick, what do you want.",
}

AI.NotInterestedMessage = 
{
	"Get out of here, I'm not buying that.",
	"I'm sure as hell not buying that.",
    "No. That's completely worthless. Go away.",
	"[$331]",
}

AI.NotYoursMessage = {
	"What, you think I'm stupid? That's not even yours.",
	"[$332]",
	"[$333]",
}

AI.CantAffordPurchaseMessages = {
	"[$334]",
	"[$335]",
	"[$336]",
}

AI.AskHelpMessages =
{
	"Help? What do you want, and why should I help you?",
	"[$337]",
	"Alright, I'll bite. What is the problem?",
}

AI.RefuseTrainMessage = {
	"That's fine with me, more time for myself.",
	"Not interested? Figures.",
}

AI.WellTrainedMessage = {
	"[$338]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
    "[$339]",
    "[$340]",
    "Let me show you how it's done then.",
    "[$341]",
}

AI.NevermindMessages = 
{
    "Anything else you want to waste my time with?",
    "Is that all?",
    "Anything else?",
    "Is that all?",
    "Anything else?",
}

AI.TalkMessages = 
{
	"A question? Sure. Ask it.",
    "[$342]",
    "I got an answer.",
	"[$343]",
}

AI.WhoMessages = {
	"[$344]",
}

AI.PersonalQuestion = {
	"[$345]",
    "[$346]",
    "Define this ... 'personal question'.",
}

AI.HowMessages = {
	"[$347]",
}

AI.FamilyMessage = {
	"[$348]",
	}

AI.SpareTimeMessages= {
	"[$349]",
}

AI.WhatMessages = {
	"...Well...?",
	"...Regarding what?",
	"...Regarding...?",
}

AI.StoryMessages = {
	"[$350]" ,
}

--[[function IntroDialog(user)

    if (user:HasObjVar("OpenedDialog|Beatrix Bell the Mercenary")) then
        text = "[$351]"
    else
        text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
    end
    user:SetObjVar("OpenedDialog|Beatrix Bell the Mercenary",true)

    response = {}

    response[1] = {}
    response[1].text = "I do want to fight."
    response[1].handle = "StartFightQuest" 

    response[2] = {}
    response[2].text = "No, thank you."
    response[2].handle = "Nevermind"

    response[3] = {}
    response[3].text = "Goodbye."
    response[3].handle = "ResetIntro" 

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenStartingQuestProfessionQuestDialog(user)
    IntroDialog(user)
end

function Dialog.OpenStartFightQuestDialog(user) 
    QuickDialogMessage(this,user,"[$352]")
    user:SendMessage("StartQuest","WarriorIntroQuest")
    user:SetObjVar("Intro|Beatrix Bell the Mercenary",true)
end]]

function Dialog.OpenHelpDialog(user)	

	text = AI.AskHelpMessages[math.random(1,#AI.AskHelpMessages)]
	
	response = {}

	response[1] = {}
	response[1].text = "Can you teach me a few things?"
	response[1].handle = "Train" 

	response[2] = {}
	response[2].text = "I need assistance with..."
	response[2].handle = "Assistance" 

	response[3] = {}
	response[3].text = "What can I do to help the guards?"
	response[3].handle = "HelpGuards" 

	response[4] = {}
	response[4].text = "Nevermind."
	response[4].handle = "Nevermind" 

	NPCInteraction(text,this,user,"Responses",response)

end

function Dialog.OpenTalkDialog(user)

    text = AI.TalkMessages[math.random(1,#AI.TalkMessages)]

    response = {}

    response[1] = {}
    response[1].text = "What do you know about..."
    response[1].handle = "What" 

    response[2] = {}
    response[2].text = "Who are you anyway?"
    response[2].handle = "Who" 

    response[3] = {}
    response[3].text = "What is this place?"
    response[3].handle = "Where"

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenWhatDialog(user)
    --DebugMessage("WhatDialog")
    text = AI.WhatMessages[math.random(1,#AI.WhatMessages)]

    response = {}

    response[1] = {}
    response[1].text = "...What's happening in Celador?"
    response[1].handle = "Happening" 

    response[2] = {}
    response[2].text = "...the Guards?"
    response[2].handle = "Guards" 

    response[3] = {}
    response[3].text = "...Your husband?"
    response[3].handle = "Nicodemus" 

    response[4] = {}
    response[4].text = "...Your sister?"
    response[4].handle = "Clara" 

    response[5] = {}
    response[5].text = "...How to survive?"
    response[5].handle = "Strength" 

    response[6] = {}
    response[6].text = "Nevermind."
    response[6].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "What's your story?"
    response[1].handle = "Story" 

    response[2] = {}
    response[2].text = "How are you a guard?"
    response[2].handle = "How" 

    response[3] = {}
    response[3].text = "I have a personal question..."
    response[3].handle = "PersonalQuestion"

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)

end

function Dialog.OpenPersonalQuestionDialog(user)

    text = AI.PersonalQuestion[math.random(1,#AI.PersonalQuestion)]

    response = {}

    response[1] = {}
    response[1].text = "Do you have a family?"
    response[1].handle = "Family" 

    response[2] = {}
    response[2].text = "What's your last name?"
    response[2].handle = "LastName" 

    response[3] = {}
    response[3].text = "What do you do in your spare time?"
    response[3].handle = "SpareTime"

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)

end

function Dialog.OpenCantDialog(user)
    --DFB TODO: Make this dialog disappear and implement it based on a per-task basis!
    DialogEndMessage(this,user,"I'm not going to help you. Not right now.","Whatever. Thanks.")
end
function Dialog.OpenCeladorDialog(user)
	DialogReturnMessage(this,user,"[$353]","Right.")
end
Dialog.OpenWhereDialog = Dialog.OpenCeladorDialog

function Dialog.OpenHappeningDialog(user)
	DialogReturnMessage(this,user,"[$354]","Oh.")
end
function Dialog.OpenGuardsDialog(user)
	DialogReturnMessage(this,user,"[$355]","Wow, really?")
end
function Dialog.OpenStrengthDialog(user)
	DialogReturnMessage(this,user,"[$356]","True.")
end
function Dialog.OpenNicodemusDialog(user)
    DialogReturnMessage(this,user,"[$357]","Right.")
end
function Dialog.OpenClaraDialog(user)
    DialogReturnMessage(this,user,"[$358]","Heh.")
end
function Dialog.OpenFamilyDialog(user)
	DialogEndMessage(this,user,AI.FamilyMessage[math.random(1,#AI.FamilyMessage)],"Oh...")
end
function Dialog.OpenSpareTimeDialog(user)
    this:PlayAnimation("fidget")
	DialogReturnMessage(this,user,AI.SpareTimeMessages[math.random(1,#AI.SpareTimeMessages)],"Umm, right.")
end
function Dialog.OpenHowDialog(user)
	DialogReturnMessage(this,user,AI.HowMessages[math.random(1,#AI.HowMessages)],"Oh.")
end
function Dialog.OpenStoryDialog(user)
	DialogReturnMessage(this,user,AI.StoryMessages[math.random(1,#AI.StoryMessages)],"Oh.")
end
function Dialog.OpenLastNameDialog(user)
	DialogReturnMessage(this,user,"[$359]","Oh. Thanks.")
end

AI.StateMachine.AllStates.Idle = { 
        GetPulseFrequencyMS = function() return math.random(3000,4000) end,
        AiPulse = function() 
            --aiRoll = math.random(4)
            --if(aiRoll == 1) then
            --    AI.StateMachine.ChangeState("GoLocation")            
            --else
            --    AI.StateMachine.ChangeState("Wander")
            --end         
            --LuaDebugCallStack("Idle")
            DecideIdleState()
        end,        
    }

AI.StateMachine.AllStates.Wander = {
        GetPulseFrequencyMS = function() return math.random(1700,2400) end,
        
        OnEnterState = function()
            local wanderRegion = this:GetObjVar("WanderRegion")
            if wanderRegion ~= nil then
                WanderInRegion(wanderRegion,"Wander")
            end
        end,

        OnArrived = function (success)
            if (AI.StateMachine.CurState ~= "Wander") then
                return 
            end
            --if( math.random(2) == 1) then
            --    this:PlayAnimation("fidget")
            --end         
            AI.StateMachine.ChangeState("Idle")   
        end,

        AiPulse = function()  
            DecideIdleState()
        end,
    }



AI.StateMachine.AllStates.GoLocation = {
        OnEnterState = function()        
            destination = CeladorLocations[math.random(#CeladorLocations)]
            -- if the destination we chose is too far away just wander
            if(this:GetLoc():Distance(destination.Loc) > MAX_PATHTO_DIST) then
                AI.StateMachine.ChangeState("Wander")
            else
                this:PathTo(destination.Loc,1.0,"GoLocation")
            end
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
                    if (destination.Type == "Merchant") then
                        nearestMerchant = FindObject(SearchMulti({
                            SearchHasObjVar("IsMerchant"),
                            SearchObjectInRange(10)}))
                        if (nearestMerchant ~= nil) then
                            nearestMerchant:SendMessage("NPCAskPrice")
                            AI.IdleTarget = nearestMerchant
                            this:NpcSpeech(GetSpeechTable("MerchantBuyerSpeech")[math.random(1,#GetSpeechTable("MerchantBuyerSpeech"))])
                            AI.StateMachine.ChangeState("Converse")
                        end
                    end
                end
            end
            --DebugMessage("Go Location")
            DecideIdleState()
        end,
    }
-- external inputs

RegisterEventHandler(EventType.Arrived, "GoLocation",AI.StateMachine.AllStates.GoLocation.OnArrived)
table.insert(AI.IdleStateTable,{StateName = "Wander",Type = "nothing"})
--table.insert(AI.IdleStateTable,{StateName = "ReturnToPath",Type = "pleasure"})
--table.insert(AI.IdleStateTable, {StateName = "GoLocation",Type = "pleasure"})
OverrideEventHandler("NOS:base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)
