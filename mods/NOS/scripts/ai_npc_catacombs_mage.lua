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

Merchant.CurrencyInfo =
    {
        CurrencyType = "resource",
        ObjVarName = nil,
        CurrencyDisplayStr = "tokens",
        Resource = "KhoToken",
    }


AI.QuestList = {}
AI.Settings.KnowName = false 
AI.Settings.HasQuest = false
AI.QuestMessages = {}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$643]"
} 

AI.GreetingMessages = 
{
	"[$644]",
    "[$645]",
    "What can this Wayward assist you with?"
}

AI.AskHelpMessages =
{
	"What kind of work do you need? What sort of help?",
    "What can I help you with?"
}

AI.RefuseTrainMessage = {
	"[$646]",
}

AI.WellTrainedMessage = {
	"[$647]",
}

AI.CantAffordPurchaseMessages = {
    "[$648]"
}

AI.TrainScopeMessages = {
	"[$649]",
}

AI.NevermindMessages = 
{
    "Anything else?",
}

AI.TalkMessages = 
{
	"[$650]",
}

AI.WhoMessages = {
	"[$651]" ,
}

AI.PersonalQuestion = {
	"...Ask if you must.",
}

AI.HowMessages = {
    "[$652]"
}

AI.FamilyMessage = {
    "[$653]"
}

AI.SpareTimeMessages= {
	"[$654]",
}

AI.WhatMessages = {
	"What exactly do you wish to know?",
}

AI.StoryMessages = {
	"[$655]",
}  

function CanBuyItem(buyer,item)
    --[[
    if (not HasFinishedQuest(buyer,"CatacombsStartQuest")) then
        this:NpcSpeech("...")
        return false
    else--]]
        return true
    --end
end
function IntroDialog(user)

     --[[if (not HasFinishedQuest(user,"CatacombsStartQuest") or user:HasObjVar("SkipQuest")) then
        this:NpcSpeech("...")
        return
    else--]]
        text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
    --end
    user:SendMessage("AdvanceQuest","CatacombsStartQuest","TalkToSomeone","Investigate")
    user:SetObjVar("Intro|Thor-Nus the Mage",true)

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
    response[1].text = "...Magic?"
    response[1].handle = "Magic" 

    response[2] = {}
    response[2].text = "...The Wayward?"
    response[2].handle = "Wayward" 

    response[3] = {}
    response[3].text = "...The creatures beneath?"
    response[3].handle = "Creatures"

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

function Dialog.OpenMagicDialog(user)
	DialogReturnMessage(this,user,"[$656]","Interesting.")
end
function Dialog.OpenWaywardDialog(user)
    DialogReturnMessage(this,user,"[$657]","Interesting.")
end
function Dialog.OpenCreaturesDialog(user)
    DialogReturnMessage(this,user,"[$658]","Right on.")
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
    DialogReturnMessage(this,user,"[$659]","Oh, alright.")
end

OverrideEventHandler("NOS:base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)

