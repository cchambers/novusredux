require 'base_ai_npc'

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = false
AI.Settings.SetIntroObjVar = false
AI.Settings.EnableBuy = true
AI.Settings.StationedLeash = true
AI.Settings.CanConverse = false

fixPrice = 20

NPCTasks = {
}

AI.QuestList = {}
AI.Settings.KnowName = true 
AI.Settings.HasQuest = false
AI.QuestMessages = {", come here."}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"You should never see this text"
} 

AI.GreetingMessages = 
{
	"Hello citizen, what can I assist you with today?",
}

AI.CantAffordPurchaseMessages = {
	"If you do not have enough, then that is sad.",
}

AI.AskHelpMessages =
{
	"What can I help you with, citizen?",
}

AI.RefuseTrainMessage = {
	"[$1203]",
}

AI.WellTrainedMessage = {
	"[$1204]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"What would you like to learn?",
}

AI.NevermindMessages = 
{
    "Anything else, citizen?",
}

AI.TalkMessages = 
{
	"[$1205]",
}

AI.WhoMessages = {
	"[$1206]" ,
}

AI.PersonalQuestion = {
	"...You want to ask me a personal question?",
}

AI.HowMessages = {
        "[$1207]"
	}

AI.FamilyMessage = {
    "[$1208]"
}

AI.SpareTimeMessages= {
	"[$1209]",
}

AI.WhatMessages = {
	"What do you need, citizen?",
}

AI.StoryMessages = AI.HowMessages


function IntroDialog(user)
    user:SendMessage("StartQuest","SlayDragonQuest")
    text = "[$1210]"
    CreateObjInBackpack(user,"outlands_map_scroll","spawn_map")
    response = {}

--[[
    response[1] = {}
    response[1].text = "What do you need me to do?"
    response[1].handle = "SlayDragon"
    --]]
    response[2] = {}
    response[2].text = "I'm not interested."
    response[2].handle = ""

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)

end
--
function Dialog.OpenSlayDragonDialog(user)
    text = "[$1211]"

    response = {}

    response[1] = {}
    response[1].text = "I'll kill it."
    response[1].handle = "SlayDragonAccept"

    response[2] = {}
    response[2].text = "I'm not interested."
    response[2].handle = ""

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenSlayDragonAcceptDialog(user)
    --user:SendMessage("AdvanceQuest","SlayDragonQuest","SlayDragon")
    user:SetObjVar("Intro|Caladus the Guard Captain",true)
    QuickDialogMessage(this,user,"[$1212]")
end

function Dialog.OpenSlayBeauregardDialog(user)
    text = "[$1213]"

    response = {}

    response[1] = {}
    response[1].text = "I'll do it quick."
    response[1].handle = "SlayHim"

    response[2] = {}
    response[2].text = "I'm not interested."
    response[2].handle = ""

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenSlayHimDialog(user)
    user:SendMessage("AdvanceQuest","KillRebelQuest","SlayBeauregard","Investigate")
    DialogReturnMessage(this,user,"[$1214]","Yes sir!")
end

function Dialog.OpenKillRebelQuestReturnForRewardDialog(user)
    DialogReturnMessage(this,user,"[$1215]","Great!")
end

function Dialog.OpenSlayDragonQuestInvestigateDialog(user)
    DialogReturnMessage(this,user,"[$1216]")
end

function Dialog.OpenSlayDragonQuestReturnForRewardDialog(user)
    DialogReturnMessage(this,user,"[$1217]")
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
    response[3].text = "Do you have a map?"
    response[3].handle = "CreateMap"

    response[4] = {}
    if (user:HasObjVar("MetRebels")) then
        response[4].text = "What's with the rebels?"
    else
        response[4].text = "Who lives out here?"
    end
    response[4].handle = "Rebels"

    response[5] = {}
    response[5].text = "Nevermind."
    response[5].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhatDialog(user)
    --DebugMessage("WhatDialog")
    text = AI.WhatMessages[math.random(1,#AI.WhatMessages)]

    response = {}

    response[1] = {}
    response[1].text = "...The rebels?"
    response[1].handle = "Rebels" 

    response[2] = {}
    response[2].text = "...The Dragon?"
    response[2].handle = "Dragon" 

    response[3] = {}
    response[3].text = "...The Cultists?"
    response[3].handle = "Cultists"

    response[4] = {}
    response[4].text = "...The Wall?"
    response[4].handle = "Wall" 

    response[5] = {}
    response[5].text = "...The Outlands?"
    response[5].handle = "Outlands"

    response[6] = {}
    response[6].text = "...Nevermind"
    response[6].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "How did you become a guard?"
    response[1].handle = "Story" 

    response[2] = {}
    response[2].text = "Why are you stationed here?"
    response[2].handle = "Rebellion" 

    response[3] = {}
    response[3].text = "Might I ask you a personal question?"
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
    response[2].text = "What is your last name?"
    response[2].handle = "LastName" 

    response[3] = {}
    response[3].text = "What do you do in your spare time?"
    response[3].handle = "SpareTime"

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)

end

function Dialog.OpenRebelsDialog(user)
    --if (GetPlayerQuestState(user,"KillRebelQuest") == "" or GetPlayerQuestState(user,"KillRebelQuest") == nil) then
        
        user:SendMessage("StartQuest","KillRebelQuest")
        
        text = "[$1218]"
    
        response = {}

        response[1] = {}
        response[1].text = "What do you need me to do?"
        response[1].handle = "SlayBeauregard"

        response[2] = {}
        response[2].text = "I'm not interested."
        response[2].handle = ""

        NPCInteraction(text,this,user,"Responses",response)

        GetAttention(user)
    --else
	   --DialogReturnMessage(this,user,"[$1219]","Uh...")
    --end
end
function Dialog.OpenDragonDialog(user)
    DialogReturnMessage(this,user,"[$1220]","...Right.")
end
function Dialog.OpenCultistsDialog(user)
    DialogReturnMessage(this,user,"[$1221]","Right.")
end
function Dialog.OpenWallDialog(user)
    DialogReturnMessage(this,user,"[$1222]","Interesting.")
end
function Dialog.OpenOutlandsDialog(user)
    DialogReturnMessage(this,user,"[$1223]","Interesting.")
end
function Dialog.OpenFamilyDialog(user)
    DialogReturnMessage(this,user,AI.FamilyMessage[math.random(1,#AI.FamilyMessage)])
end
function Dialog.OpenSpareTimeDialog(user)
	DialogReturnMessage(this,user,AI.SpareTimeMessages[math.random(1,#AI.SpareTimeMessages)],"Interesting.")
end
function Dialog.OpenHowDialog(user)
	DialogReturnMessage(this,user,AI.HowMessages[math.random(1,#AI.HowMessages)],"Oh.")
end
function Dialog.OpenStoryDialog(user)
	DialogReturnMessage(this,user,AI.StoryMessages[math.random(1,#AI.StoryMessages)],"Oh.")
end
function Dialog.OpenLastNameDialog(user)
    DialogReturnMessage(this,user,"[$1224]","...Right.")
end
function Dialog.OpenCreateMapDialog(user)
    if (not user:HasObjVar("GivenOutlandsMap")) then
        user:SetObjVar("GivenOutlandsMap",true)
        DialogReturnMessage(this,user,"[$1225]")
        CreateObjInBackpack(user,"outlands_map_scroll","spawn_map")
    else
        DialogReturnMessage(this,"[$1226]")
    end
end

OverrideEventHandler("base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)

