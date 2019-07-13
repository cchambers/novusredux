require 'NOS:base_ai_npc'

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = false
AI.Settings.EnableBuy = true
AI.Settings.StationedLeash = true
fixPrice = 20

CanBuyItem = function (buyer,item)
    return IsFounder(buyer)
end
CanUseNPC = CanBuyItem

NPCTasks = {
}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$947]",
} 

AI.TradeMessages = 
{
	"I take gold here bud. Everyone takes gold, right?",
}

AI.GreetingMessages = 
{
	"Hey there, you lookin' for a good time?",
}

AI.HowToPurchaseMessages = {
	"Choose what I got sittin' out. Be descreet."
}

AI.NotInterestedMessage = 
{
	"I don't want that.",
    "Get out of here, I'm not interested in that."
}

AI.NotYoursMessage = {
	"That ain't yours to sell!",
}

AI.CantAffordPurchaseMessages = {
	"Hey, you don't have enough. Get lost.",
}

AI.AskHelpMessages =
{
	"What do you need my help with?",
}

AI.RefuseTrainMessage = {
	"I can show you a thing or two.",
}

AI.WellTrainedMessage = {
	"You already know enough beyond my means, pal.",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"I can show you a thing or two, whatcha wanna know.",
}

AI.NevermindMessages = 
{
    "Mmm. Anything else you lookin' to do?",
}

AI.TalkMessages = 
{
	"What do you want to talk about...",
}

AI.WhoMessages = {
	"[$948]",
}

AI.PersonalQuestion = {
	"Naw'. No personal questions.",
}

AI.HowMessages = {
	"[$949]",
}

AI.FamilyMessage = {
	"My fam' is none of your business, pal.",
	}

AI.SpareTimeMessages= {
	"My time? My time is wasted on talking to you!",
}

AI.WhatMessages = {
	"What is it exactly, buddy.",
}

AI.StoryMessages = {
	"[$950]"
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

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhatDialog(user)
    --DebugMessage("WhatDialog")
    QuickDialogMessage(this,user,"[$951]")
end

function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "What's your story?"
    response[1].handle = "Story" 

    response[2] = {}
    response[2].text = "How did you get here?"
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
    response[1].text = "Nevermind."
    response[1].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)

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
	DialogReturnMessage(this,user,"","...")
end

OverrideEventHandler("NOS:base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)
