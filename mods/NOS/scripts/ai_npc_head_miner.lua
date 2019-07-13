require 'NOS:base_ai_npc'
require 'NOS:incl_mining_locations'

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = false
fixPrice = 20

NPCTasks = {
    --[[BellSurveyTask = {
        TaskName = "BellSurveyTask",
        TaskDisplayName = "Survey for Mining",
        RewardType = "coins",
        Description = "Find two iron ingots.",
        FinishDescription = "Bring them back to Bell.",
        RewardAmount = 100,
        Repeatable = true, --if you can redo the task
        Importance = 1, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$1048]",
        TaskAcceptSpeech = "[$1049]",
        TaskCurrentSpeech = "[$1050]",
        TaskContinueSpeech = "[$1051]",
        TaskCancelSpeech = "[$1052]",
        TaskHelpSpeech = "[$1053]",
        TaskPreCompleteSpeech = "[$1054]",
        TaskFinishedMessage = "[$1055]",
        TaskIncompleteMessage = "[$1056]",
        TaskAssists = {
                      {Template = "cel_blacksmith",Text = "[$1057]"},
                      {Template = "cel_merchant_general_store",Text = "[$1058]"},
                    },
        CompletionCallback = "Items",
        CheckCompletionCallback = "Items",
        TaskItemList = {
            {"resource_iron_ingots",2},
        },
        Faction = "Villagers",
        FactionOnFinish = 1,
    },
    GemStonesTask = {
        TaskName = "GemStonesTask",
        TaskDisplayName = "Seeking Precious Gems",
        Description = "Find a Sapphire, a Ruby and an Emerald.",
        FinishDescription = "Bring them back to Bell.",
        RewardType = "gold_ingot",
        RewardAmount = 1,
        TaskMinimumFaction = 20,
        Repeatable = false, --if you can redo the task
        Importance = 1, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$1059]",
        TaskAcceptSpeech = "[$1060]",
        TaskCurrentSpeech = "[$1061]",
        TaskContinueSpeech = "[$1062]",
        TaskCancelSpeech = "[$1063]",
        TaskHelpSpeech = "[$1064]",
        TaskPreCompleteSpeech = "[$1065]",
        TaskFinishedMessage = "[$1066]",
        TaskIncompleteMessage = "[$1067]",
        TaskAssists = {
            {Template = "cel_guard_rufus",Text = "[$1068]"},
            {Template = "cel_rothchilde",Text = "[$1069]"},
            {Template = "cel_village_beatrix",Text = "[$1070]"},
            {Template = "cel_merchant_general_store",Text = "[$1071]"},
        },
        CompletionCallback = "Items",
        CheckCompletionCallback = "Items",
        TaskItemList = {
            {"gem_sapphire",1},
            {"gem_emerald",1},
            {"gem_ruby",1},
        },
        Faction = "Villagers",
        TaskType = "item", --valid keys are item, character, mobile, etc.
        FactionOnFinish = 1,
        },]]
}
AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$1072]",
} 

AI.TradeMessages = 
{
    "Well what can we do for you today?"
}

AI.GreetingMessages = 
{
	"[$1073]",
	"[$1074]",
	"Greetings babe, anything I can help you with?",
}

AI.NotInterestedMessage = 
{
	"I'm not really into that, sorry.",
	"I don't want that, thank you.",
    "[$1075]",
	"It may be valuble, but I'm not interested.",
}

AI.NotYoursMessage = {
	"[$1076]",
	"[$1077]",
	"[$1078]",
}

AI.CantAffordPurchaseMessages = {
	"[$1079]",
	"[$1080]",
	"[$1081]",
}

AI.AskHelpMessages =
{
	"[$1082]",
	"I've only got a moment, what can I do for you?",
	"I can't do much because I'm busy, is it quick?",
}

AI.RefuseTrainMessage = {
	"[$1083]",
	"[$1084]",
}

AI.WellTrainedMessage = {
	"[$1085]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
    "[$1086]",
    "[$1087]",
    "[$1088]",
    "[$1089]",
}

AI.NevermindMessages = 
{
    "Well, is there anything else I can help you with?",
    "Anything else I can help you with, babe?",
    "Anything else?",
}

AI.TalkMessages = 
{
	"Well sure, babe, what's your question?",
	"Please, feel free to ask!",
}

AI.WhoMessages = {
	"[$1090]",
}

AI.PersonalQuestion = {
	"[$1091]",
    "Uhh, sure... What would you want to know?",
    "Sure, I guess...?"
}

AI.HowMessages = {
	"[$1092]",
}

AI.FamilyMessage = {
	"[$1093]",
	}

AI.SpareTimeMessages= {
	"[$1094]",
}

AI.WhatMessages = {
	"...About...?",
	"...Regarding what babe?",
	"...Regarding...?",
}

AI.StoryMessages = {
	"[$1095]"
}

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
    response[2].text = "...This mining operation?"
    response[2].handle = "BellCompany" 

    response[3] = {}
    response[3].text = "...What are you mining?"
    response[3].handle = "Mine"

    response[4] = {}
    response[4].text = "...The quarry and mine?"
    response[4].handle = "QuarryMine" 

    response[5] = {}
    response[5].text = "...Your sister?"
    response[5].handle = "Beatrix" 

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
    response[2].text = "Why are you a miner?"
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
    DialogReturnMessage(this,user,"[$1096]","Right.")
end
function Dialog.OpenCeladorDialog(user)
	DialogReturnMessage(this,user,"[$1097]","Right.")
end
function Dialog.OpenCeladorDialog(user)
    DialogReturnMessage(this,user,"[$1098]","Right.")
end
Dialog.OpenWhereDialog = Dialog.OpenCeladorDialog

function Dialog.OpenHappeningDialog(user)
	DialogReturnMessage(this,user,"[$1099]","Yikes.")
end
function Dialog.OpenBellCompanyDialog(user)
	DialogReturnMessage(this,user,"[$1100]","Interesting.")
end
function Dialog.OpenMineDialog(user)
	DialogReturnMessage(this,user,"[$1101]","Possibly.")
end
function Dialog.OpenQuarryMineDialog(user)
    DialogReturnMessage(this,user,"[$1102]","Interesting.")
end
function Dialog.OpenBeatrixDialog(user)
    DialogReturnMessage(this,user,"[$1103]","Right.")
end
function Dialog.OpenFamilyDialog(user)
	DialogEndMessage(this,user,AI.FamilyMessage[math.random(1,#AI.FamilyMessage)],"Oh...")
end
function Dialog.OpenSpareTimeDialog(user)
	DialogReturnMessage(this,user,AI.SpareTimeMessages[math.random(1,#AI.SpareTimeMessages)],"Oh.")
end
function Dialog.OpenHowDialog(user)
	DialogReturnMessage(this,user,AI.HowMessages[math.random(1,#AI.HowMessages)],"Oh.")
end
function Dialog.OpenStoryDialog(user)
	DialogReturnMessage(this,user,AI.StoryMessages[math.random(1,#AI.StoryMessages)],"Oh.")
end
function Dialog.OpenLastNameDialog(user)
	DialogReturnMessage(this,user,"[$1104]","That's interesting.")
end

table.insert(AI.IdleStateTable,{StateName = "Mining",Type = "routine",Time = 8,Duration = 10})

AI.StateMachine.AllStates.Mining = {

        InitialSubState = "Begin",

        OnEnterState = function()
            destination = MineLocations[math.random(#MineLocations)]
            if(this:GetLoc():Distance(destination.Loc) > MAX_PATHTO_DIST) then
                AI.StateMachine.ChangeState("Wander")
            else
                this:PathTo(destination.Loc,1.0,"StartMining")
            end 
            AI.SetSetting("CanConverse",false)
            AI.SetSetting("CanWander",false)
            this:ScheduleTimerDelay(TimeSpan.FromSeconds(60*20 + math.random(20,60)),"DecideIdle")
        end,

        SubStates =
        {
        Begin = {
            OnEnterState = function()
                AI.StateMachine.ChangeSubState("Transfer")
            end,
            },
        Mine = {
            OnEnterState = function()
                local animToPlay = this:GetObjVar("PlayAnim")
                if( animToPlay ~= nil ) then
                    this:PlayAnimation(animToPlay)
                end
                AnimationCount = 0
                DebugMessageA(this,"Enter mine")
            end,

            GetPulseFrequencyMS = function() return 2000 end,

            AiPulse = function()
                local animToPlay = this:GetObjVar("PlayAnim")
                if( animToPlay ~= nil ) then
                    this:PlayAnimation(animToPlay)
                end
                AnimationCount = AnimationCount + 1
                DebugMessageA(this,"Pulse Mine")
                if (AnimationCount > MaxCount) then
                    DebugMessageA(this,"Transfer Mine")
                    AI.StateMachine.ChangeSubState("Transfer")
                end
            end,
            },
        Transfer = {
            OnEnterState = function()
                destination = MineLocations[math.random(#MineLocations)]
                if(this:GetLoc():Distance(destination.Loc) > MAX_PATHTO_DIST) then
                    AI.StateMachine.ChangeState("Wander")
                else
                    this:PathTo(destination.Loc,1.0,"StartMining")
                end 
            end,
            },
        },

        OnArrived = function (success)
            DebugMessageA(this,"Arrived, Success is "..tostring(success))
            if(success) then
                if (AI.StateMachine.CurState ~= "Mining") then
                    return 
                end
                if( destination ~= nil ) then 
                    this:SetFacing(destination.Facing)
                end
                AI.StateMachine.ChangeSubState("Mine")
            else 
                AI.StateMachine.ChangeSubState("Transfer")
            end
        end,

        OnExitState = function ()
            AI.SetSetting("CanConverse",true)
            AI.SetSetting("CanWander",true)
        end,
    }

OverrideEventHandler("NOS:base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)
