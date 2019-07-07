
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

AI.QuestList = {}
AI.Settings.KnowName = false 
AI.Settings.HasQuest = false
AI.QuestMessages = {}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"You. You disgust me. Begone from my sight!"
} 

AI.GreetingMessages = 
{
	"You again! Didn't I tell you to get lost!",
    "I don't want your words. Be gone!",
    "[$472]"
}

AI.AskHelpMessages =
{
	"[$473]",
    "[$474]"
}

AI.RefuseTrainMessage = {
	"Great! Get lost!",
}

AI.WellTrainedMessage = {
	"Learn enough! Now get lost!",
}

AI.CannotAffordMessages = {
    "[$475]"
}

AI.TrainScopeMessages = {
	"Learn these things then.",
}

AI.NevermindMessages = 
{
    "Anything else you want to pester me with?",
    "Since you insist on talking to me, anything else?"
}

AI.TalkMessages = 
{
	"[$476]",
    "No! Go away!"
}

AI.WhoMessages = {
	"[$477]" ,
}

AI.PersonalQuestion = {
	"...Well ask it then!",
}

AI.HowMessages = {
        "[$478]"
	}

AI.FamilyMessage = {
    "Just get lost already!"
}

AI.SpareTimeMessages= {
	"[$479]",
}

AI.WhatMessages = {
	"[$480]",
}

AI.StoryMessages = {
	"[$481]",
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

     --[[if (not HasFinishedQuest(user,"CatacombsStartQuest") or user:HasObjVar("SkipQuest")) then
        this:NpcSpeech("...")
        user:SendMessage("AdvanceQuest","CatacombsStartQuest","TalkToSomeone","Investigate")
        return
    else]]--
        text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
    --end
    user:SetObjVar("Intro|Duredan the Bedkeeper",true)

    response = {}

    response[1] = {}
    response[1].text = "What is this place?"
    response[1].handle = "Where"

    response[2] = {}
    response[2].text = "Who are you?"
    response[2].handle = "Who"

    response[3] = {}
    response[3].text = "Nice to meet you."
    response[3].handle = "Nevermind" 


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
    response[1].text = "...Why are you so rude?"
    response[1].handle = "Rude"

    response[2] = {}
    response[2].text = "...Why are you a bedkeeper?"
    response[2].handle = "Story" 

    response[3] = {}
    response[3].text = "...What do you actually owe?"
    response[3].handle = "Owe" 

    response[4] = {}
    response[4].text = "...Your thoughts on Kho?"
    response[4].handle = "Kho"

    response[5] = {}
    response[5].text = "Nevermind."
    response[5].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "...Why are you so rude?"
    response[1].handle = "Rude"

    response[2] = {}
    response[2].text = "How did you get here?"
    response[2].handle = "Story" 

    response[3] = {}
    response[3].text = "How did you end up a bedkeeper?"
    response[3].handle = "How" 

    response[4] = {}
    response[4].text = "Might I ask you a personal question?"
    response[4].handle = "PersonalQuestion"

    response[5] = {}
    response[5].text = "Nevermind."
    response[5].handle = "Nevermind" 

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

function Dialog.OpenOweDialog(user)
	DialogReturnMessage(this,user,"[$482]","Yep.")
end
function Dialog.OpenStoryDialog(user)
    DialogReturnMessage(this,user,"[$483]","Oh.")
end
function Dialog.OpenRudeDialog(user)
    DialogReturnMessage(this,user,"[$484]","Oh... I'm so sorry...")
end
function Dialog.OpenKhoDialog(user)
    DialogReturnMessage(this,user,"Kho is none of your concern.","Ok then.")
end
function Dialog.OpenWhereDialog(user)
    DialogReturnMessage(this,user,"[$485]","Yeah right.")
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
    DialogReturnMessage(this,user,"My last name is none of your business, freak!","Oh, alright.")
end

function Dialog.OpenInvestigateMurderQuestConfrontDurdainDialog(user)
    text = "You. What do you want?"

    response = {}

    response[1] = {}
    response[1].text = "You murdered Tai-Naius."
    response[1].handle = "Murdered"

    response[2] = {}
    response[2].text = "Goodbye."
    response[2].handle = ""

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenMurderedDialog(user)
    text = "[$486]"

    response = {}

    response[1] = {}
    response[1].text = "You traitor."
    response[1].handle = "Traitor"

    response[2] = {}
    response[2].text = "...Right."
    response[2].handle = ""

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)

    user:SendMessage("AdvanceQuest","InvestigateMurderQuest","SlayPaul","ConfrontDurdain")
end

function Dialog.OpenTraitorDialog(user)
    text = "[$487]"

    response = {}

    response[1] = {}
    response[1].text = "Watch me..."
    response[1].handle = "Attack"

    response[2] = {}
    response[2].text = "...Right."
    response[2].handle = ""

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenAttackDialog(user)
    this:NpcSpeech("Not by my watch. KHO'S WILL BE DONE!!!")
    this:SendMessage("AttackEnemy",user,true)
end
OverrideEventHandler("base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)

