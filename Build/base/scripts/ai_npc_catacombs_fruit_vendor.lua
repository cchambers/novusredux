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

Merchant.CurrencyInfo =
    {
        CurrencyType = "resource",
        ObjVarName = nil,
        CurrencyDisplayStr = "tokens",
        Resource = "KhoToken",
    }


AI.QuestList = {"CatacombsFruitQuest"}
AI.Settings.KnowName = false 
AI.Settings.HasQuest = false
AI.QuestMessages = {"The Wayun have sent us more help!?"}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$526]"
} 

AI.GreetingMessages = 
{
	"Ah, I know you. Have you come to buy more fruit?",
    "May the way be shown to you. How are you this day?",
    "You, how can I assist you?"
}

AI.AskHelpMessages =
{
	"Well of course, how can I be of service?",
    "What do you require?"
}

AI.RefuseTrainMessage = {
	"[$527]",
}

AI.WellTrainedMessage = {
	"You know too much. I cannot teach you anymore.",
}

AI.CantAffordPurchaseMessages = {
    "[$528]"
}
AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"I can teach you these things my friend.",
}

AI.NevermindMessages = 
{
    "Anything else?",
}

AI.TalkMessages = 
{
	"I know many things, what would you like to know?",
}

AI.WhoMessages = {
	"[$529]" ,
}

AI.PersonalQuestion = {
	"A personal question you say? I can answer such.",
}

AI.HowMessages = {
        "[$530]"
	}

AI.FamilyMessage = {
    "[$531]"
}

AI.SpareTimeMessages= {
	"[$532]",
}

AI.WhatMessages = {
	"What is it you want then?",
}

AI.StoryMessages = {
	"[$533]",
}  

function CanBuyItem(buyer,item)
    --[[
    if (not HasFinishedQuest(buyer,"CatacombsStartQuest")) then
        this:NpcSpeech("...")
        return false
    else
        --]]
        return true
    --end
end
function IntroDialog(user)
     --[[if (not HasFinishedQuest(user,"CatacombsStartQuest") or user:HasObjVar("SkipQuest")) then
        this:NpcSpeech("...")
        user:SendMessage("AdvanceQuest","CatacombsStartQuest","TalkToSomeone","Investigate")
        return
    else
        text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
    end
    ]]--

    --user:SendMessage("StartQuest","FruitQuest")


    text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
    response = {}
--[[
    response[1] = {}
    response[1].text = "What can I do for you?"
    response[1].handle = "StartFruitQuest"
]]--
    response[2] = {}
    response[2].text = "Who are you?"
    response[2].handle = "Who"

    response[3] = {}
    response[3].text = "Nice to meet you."
    response[3].handle = "Nevermind" 


    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenStartFruitQuestDialog(user)
    text = "[$534]"

    user:SetObjVar("Intro|Lordan the Merchant",true)

    response = {}
--[[
    response[1] = {}
    response[1].text = "Go on..."
    response[1].handle = "StartFruitQuest2"
]]--
    response[2] = {}
    response[2].text = "Goodbye."
    response[2].handle = "Nevermind"

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end


function Dialog.OpenStartFruitQuest2Dialog(user)
    text = "[$535]"

    user:SetObjVar("Intro|Lordan the Merchant",true)

    response = {}
--[[
    response[1] = {}
    response[1].text = "I will find it."
    response[1].handle = "BeginFruitQuest"
--]]
    response[2] = {}
    response[2].text = "No way."
    response[2].handle = "Nevermind"

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenBeginFruitQuestDialog(user)
    user:SendMessage("AdvanceQuest","FruitQuest","FindFruit","TalkToFruitVendor")
    user:SetObjVar("Intro|Tan-Ful the Fruit Vendor",true)
    QuickDialogMessage(this,user,"[$536]")
end

function Dialog.OpenFruitQuestBringFruitBackDialog(user)
    if (CountResourcesInContainer(user,"FruitCatacombs") >= 10) then
        local backpackObj = user:GetEquippedObject("Backpack")
        ConsumeItemsInContainer(backpackObj,{{"fruit_catacombs",10}},true)
        PlayerTitles.EntitleFromTable(user,AllTitles.ActivityTitles.BringerOfFruit)
        user:SendMessage("FinishQuest","FruitQuest",true)
        QuickDialogMessage(this,user,"[$537]")
    else
        QuickDialogMessage(this,user,"[$538]")
    end
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
    response[1].text = "...This fruit???"
    response[1].handle = "Fruit" 

    response[2] = {}
    response[2].text = "...The high price?"
    response[2].handle = "Price" 

    response[3] = {}
    response[3].text = "...Where is the fruit?"
    response[3].handle = "FruitLocation"

    response[4] = {}
    response[4].text = "...The Wayward?"
    response[4].handle = "Wayward" 

    response[5] = {}
    response[5].text = "...The struggle against Kho?"
    response[5].handle = "Struggle"

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

function Dialog.OpenStruggleDialog(user)
	DialogReturnMessage(this,user,"[$539]","I see.")
end
function Dialog.OpenWaywardDialog(user)
    DialogReturnMessage(this,user,"[$540]","Interesting.")
end
function Dialog.OpenFruitLocationDialog(user)
    DialogReturnMessage(this,user,"[$541]","Alright.")
end
function Dialog.OpenFruitDialog(user)
    DialogReturnMessage(this,user,"[$542]","Yeah right.")
end
function Dialog.OpenPriceDialog(user)
    DialogReturnMessage(this,user,"[$543]","Whatever.")
end
function Dialog.OpenWhereDialog(user)
    DialogReturnMessage(this,user,"[$544]","Yeah right.")
end
function Dialog.OpenSpareTimeDialog(user)
	DialogReturnMessage(this,user,AI.SpareTimeMessages[math.random(1,#AI.SpareTimeMessages)],"...I think I'm gonna puke.")
end
function Dialog.OpenHowDialog(user)
	DialogReturnMessage(this,user,AI.HowMessages[math.random(1,#AI.HowMessages)],"Oh.")
end
function Dialog.OpenStoryDialog(user)
	DialogReturnMessage(this,user,AI.StoryMessages[math.random(1,#AI.StoryMessages)],"Oh.")
end
function Dialog.OpenFamilyDialog(user)
    DialogReturnMessage(this,user,AI.FamilyMessage[math.random(1,#AI.FamilyMessage)])
end
function Dialog.OpenLastNameDialog(user)
    DialogReturnMessage(this,user,"[$545]","Oh, alright.")
end

OverrideEventHandler("base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)

