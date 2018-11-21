require 'base_ai_npc'

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = false
AI.Settings.SetIntroObjVar = false
AI.Settings.EnableBuy = true
AI.Settings.StationedLeash = true
AI.Settings.CanConverse = false

NPCTasks = {
}

AI.QuestList = {"SlayLieutenantOfKho"}
AI.Settings.KnowName = false 
AI.Settings.HasQuest = false
AI.QuestMessages = {"You there, come here."}


AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$1575]"
} 

AI.GreetingMessages = 
{
	"Greetings ye, for what do I have the pleasure?",
    "You wish to talk to me? What is it?",
    "[$1576]"
}

AI.CantAffordPurchaseMessages = {
	"",
    "",
    "",
}

AI.AskHelpMessages =
{
	"What do you need my help for?",
    "You need our help? What for?"
}

AI.RefuseTrainMessage = {
	"Since you don't need help of me, then leave me be.",
}

AI.WellTrainedMessage = {
	"[$1577]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"I know a few things.",
}

AI.NevermindMessages = 
{
    "Nevermind? What else then?",
    "Well, what else then?"
}

AI.TalkMessages = 
{
	"[$1578]",
    "[$1579]"
}

AI.WhoMessages = {
	"[$1580]" ,
}

AI.PersonalQuestion = {
	"...What is it you ask?",
}

AI.HowMessages = {
        "[$1581]"
	}

AI.FamilyMessage = {
    "[$1582]"
}

AI.SpareTimeMessages= {
	"[$1583]",
}

AI.WhatMessages = {
	"What exactly?",
}

AI.StoryMessages = {
	"[$1584]",
}  

function IntroDialog(user)
    --DebugMessage((not HasFinishedQuest(user,"CatacombsStartQuest")),user:HasObjVar("SkipQuest"))
    if ((not HasFinishedQuest(user,"CatacombsStartQuest")) and not user:HasObjVar("SkipQuest")) then
        this:NpcSpeech("...How did you get down here?")
        user:SendMessage("AdvanceQuest","CatacombsStartQuest","TalkToSomeone","Investigate")
        return
    else
        text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
    end

    response = {}

    response[1] = {}
    response[1].text = "What do you need from me?"
    response[1].handle = "StartLieutenantQuest"

    response[3] = {}
    response[3].text = "Goodbye."
    response[3].handle = "Nevermind" 


    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end    --user:SetObjVar("Intro|Inaius the Zealot Leader",true)

function Dialog.OpenStartLieutenantQuestDialog(user)
    text = "[$1585]"

    response[1] = {}
    response[1].text = "Go on."
    response[1].handle = "StartLieutenantQuest2"

    response[3] = {}
    response[3].text = "Goodbye."
    response[3].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenStartLieutenantQuest2Dialog(user)

    text = "[$1586]"

    response[1] = {}
    response[1].text = "Definitely, let's do it."
    response[1].handle = "StartLieutenantQuest3"

    response[3] = {}
    response[3].text = "Goodbye."
    response[3].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenStartLieutenantQuest3Dialog(user)
    user:SendMessage("AdvanceQuest","SlayLieutenantOfKho","FindLieutenant","TalkToGuardsBelow")
    DialogReturnMessage(this,user,"[$1587]","Yes sir.")
end

function Dialog.OpenFoundersQuestFindSwordOfAncientsDialog(user)
    QuickDialogMessage(this,user,"[$1588]")
end

function Dialog.OpenFoundersQuestBringSwordToAluTharDialog(user)
    QuickDialogMessage(this,user,"[$1589]")
    CreateObjInBackpack(user,"founders_quest_golden_note")  
end

function Dialog.OpenSlayLieutenantOfKhoTalkToAluTharDialog(user)
    PlayerTitles.EntitleFromTable(user,AllTitles.ActivityTitles.Zealot)
    DialogReturnMessage(this,user,"[$1590]")
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
    response[1].text = "...What you believe?"
    response[1].handle = "Beliefs" 

    response[2] = {}
    response[2].text = "...The Catacombs?"
    response[2].handle = "Catacombs" 

    response[3] = {}
    response[3].text = "...Ina-Ius?"
    response[3].handle = "Inaius"

    response[4] = {}
    response[4].text = "...This place?"
    response[4].handle = "Place" 

    response[5] = {}
    response[5].text = "...The fight against Kho?"
    response[5].handle = "Fight"

    response[6] = {}
    response[6].text = "Nevermind."
    response[6].handle = "Nevermind" 


    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "Why are you a warrior?"
    response[1].handle = "How" 

    response[2] = {}
    response[2].text = "What's your story?"
    response[2].handle = "Story" 

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

function Dialog.OpenBeliefsDialog(user)
	DialogReturnMessage(this,user,"[$1591]","Yeah right.")
end
function Dialog.OpenInaiusDialog(user)
    DialogReturnMessage(this,user,"[$1592]","Huh.")
end
function Dialog.OpenCatacombsDialog(user)
    DialogReturnMessage(this,user,"[$1593]","Damn...")
end
function Dialog.OpenPlaceDialog(user)
    DialogReturnMessage(this,user,"[$1594]","Right.")
end
function Dialog.OpenFightDialog(user)
    DialogReturnMessage(this,user,"[$1595]","Agreed.")
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
    DialogReturnMessage(this,user,"[$1596]","Right")
end

OverrideEventHandler("base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)

