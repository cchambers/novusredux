require 'NOS:base_ai_npc'

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
AI.Settings.KnowName = false 
AI.Settings.HasQuest = false
AI.QuestMessages = {}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$546]"
} 

AI.GreetingMessages = 
{
	"Greetings and good tidings, how are you?",
    "[$547]",
    "If it isn't you again. How can I be of service?"
}

AI.CantAffordPurchaseMessages = {
	"[$548]",
    "[$549]",
    "I'm sorry, you need more money...",
}

AI.AskHelpMessages =
{
	"Certainly, what can I assist you with?",
    "What do you need help with, good sir?"
}

AI.RefuseTrainMessage = {
	"[$550]",
}

AI.WellTrainedMessage = {
	"[$551]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"I know a few things I've gathered in my travels.",
}

AI.NevermindMessages = 
{
    "...Anything else I can assist you with?",
}

AI.TalkMessages = 
{
	"Certainly, what would you like to know?",
}

AI.WhoMessages = {
	"[$552]" ,
}

AI.PersonalQuestion = {
	"Well sure, go ahead and ask.",
}

AI.HowMessages = {
        "[$553]"
	}

AI.FamilyMessage = {
    "[$554]"
}

AI.SpareTimeMessages= {
	"[$555]",
}

AI.WhatMessages = {
	"Well, what would you like to know?",
}

AI.StoryMessages = {
	"[$556]",
}  

function CanBuyItem(buyer,item)
    --[[
    if (not HasFinishedQuest(buyer,"CatacombsStartQuest")) then
        this:NpcSpeech("...")
        return false
    else]]--
        return true
    --end
end
function IntroDialog(user)
--[[
     if (not HasFinishedQuest(user,"CatacombsStartQuest") or user:HasObjVar("SkipQuest")) then
        this:NpcSpeech("...")
        user:SendMessage("AdvanceQuest","CatacombsStartQuest","TalkToSomeone","Investigate")
        return
    else]]--
        text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
    --end3
    user:SetObjVar("Intro|Lordan the Merchant",true)

    response = {}

    response[1] = {}
    response[1].text = "What is this place?"
    response[1].handle = "Where"

    response[2] = {}
    response[2].text = "Nice to meet you."
    response[2].handle = "Nevermind" 


    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
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

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhatDialog(user)
    --DebugMessage("WhatDialog")
    text = AI.WhatMessages[math.random(1,#AI.WhatMessages)]

    response = {}

    response[1] = {}
    response[1].text = "...Celador?"
    response[1].handle = "Celador" 

    response[2] = {}
    response[2].text = "...Why you are here?"
    response[2].handle = "Story" 

    response[3] = {}
    response[3].text = "...The Wayward?"
    response[3].handle = "Wayward"

    response[4] = {}
    response[4].text = "...The artifact?"
    response[4].handle = "Artifact" 

    response[5] = {}
    response[5].text = "...The monsters beneath?"
    response[5].handle = "Monsters"

    response[6] = {}
    response[6].text = "Nevermind."
    response[6].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "How did you get here?"
    response[1].handle = "Story" 

    response[2] = {}
    response[2].text = "How did you end up a merchant?"
    response[2].handle = "How" 

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

function Dialog.OpenCeladorDialog(user)
	DialogReturnMessage(this,user,"[$557]","Yeah right.")
end
function Dialog.OpenWaywardDialog(user)
    DialogReturnMessage(this,user,"[$558]","Interesting.")
end
function Dialog.OpenArtifactDialog(user)
    DialogReturnMessage(this,user,"[$559]","Right.")
end
function Dialog.OpenMonstersDialog(user)
    DialogReturnMessage(this,user,"[$560]","Oh.")
end
function Dialog.OpenWhereDialog(user)
    DialogReturnMessage(this,user,"[$561]","Right.")
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
    DialogReturnMessage(this,user,"[$562]","Oh, alright.")
end

OverrideEventHandler("NOS:base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)

