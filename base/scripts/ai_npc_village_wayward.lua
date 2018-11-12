require 'base_ai_npc'

AI.Settings.MerchantEnabled = false
AI.Settings.EnableTrain = false
AI.Settings.SetIntroObjVar = false
AI.Settings.EnableBuy = false
AI.Settings.StationedLeash = true
AI.Settings.CanConverse = false

fixPrice = 20

NPCTasks = {
}

AI.QuestList = {"CatacombsDiscoveryQuest"}
AI.Settings.KnowName = true 
AI.Settings.HasQuest = false
AI.QuestMessages = {", we need your help."}

AI.GreetingMessages = 
{
	"How can I assist you this day, He-Of-The-Wayun?",
    "It is but you. What can I do for you?",
}

AI.AskHelpMessages =
{
	"I can assist you somewhat, for it is the Way.",
}

AI.RefuseTrainMessage = {
	"[$1523]",
}

AI.WellTrainedMessage = {
	"[$1524]",
}

AI.CannotAffordMessages = {
    "[$1525]"
}

AI.TrainScopeMessages = {
	"[$1526]",
}

AI.NevermindMessages = 
{
    "Anything else then?",
    "Anything else, on our behalf?"
}

AI.TalkMessages = 
{
	"Ah yes, what do you want to talk about?",
}

AI.WhoMessages = {
	"[$1527]" ,
}

AI.PersonalQuestion = {
	"[$1528]",
}

AI.HowMessages = {
    "[$1529]"
}

AI.FamilyMessage = {
    "[$1530]"
}

AI.SpareTimeMessages= {
	"[$1531]",
}

AI.WhatMessages = {
	"What exactly do you want to know?",
}

AI.StoryMessages = {
	"[$1532]",
}  

function IntroDialog(user)
    --user:SendMessage("StartQuest","CatacombsReDiscoveryQuest")
    text = "[$1533]"

    response = {}

    response[1] = {}
    response[1].text = "Tell me more."
    response[1].handle = "TellMeMoar"

    response[2] = {}
    response[2].text = "Uh, Bye."
    response[2].handle = "" 

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenTellMeMoarDialog(user)

    user:SetObjVar("Intro|Kul-Daus of the Wayward",true)

    text = "[$1534]"

    response = {}

    response[1] = {}
    response[1].text = "Who are you anyway?"
    response[1].handle = "Who" 

    response[2] = {}
    response[2].text = "Bye."
    response[2].handle = "" 

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


    response[2] = {}
    response[2].text = "...Where are you from?"
    response[2].handle = "WhereFrom" 

    response[3] = {}
    response[3].text = "...What are the Wayun?"
    response[3].handle = "Wayun" 

    response[4] = {}
    response[4].text = "...Why are you here?"
    response[4].handle = "WhyHere"

    response[5] = {}
    response[5].text = "Nevermind."
    response[5].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "How did you get here?"
    response[1].handle = "Story" 

    response[2] = {}
    response[2].text = "Might I ask you a personal question?"
    response[2].handle = "PersonalQuestion"

    response[3] = {}
    response[3].text = "Nevermind."
    response[3].handle = "Nevermind" 

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

function Dialog.OpenWhereFromDialog(user)
	DialogReturnMessage(this,user,"[$1535]","Interesting.")
end
function Dialog.OpenWayunDialog(user)
    DialogReturnMessage(this,user,"[$1536]","Oh.")
end
function Dialog.OpenWhyHereDialog(user)
    DialogReturnMessage(this,user,"[$1537]","Oh...")
end
function Dialog.OpenWhereDialog(user)
    DialogReturnMessage(this,user,"[$1538]","Right.")
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
    DialogReturnMessage(this,user,"[$1539]","Oh, alright.")
end

function Dialog.OpenFamilyDialog(user)
    DialogReturnMessage(this,user,AI.FamilyMessage[math.random(1,#AI.FamilyMessage)],"Oh.")
end

OverrideEventHandler("base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)

