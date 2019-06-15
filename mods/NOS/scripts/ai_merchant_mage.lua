require 'base_ai_npc'

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = false
AI.Settings.EnableBuy = true
AI.Settings.SetIntroObjVar = false
fixPrice = 20

NPCTasks = {
    
}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"Hello I am your local mage, I can train you in the arts for a price."
} 

AI.TradeMessages = 
{
	"[$115]",
	"[$116]",
	"[$117]",
	"[$118]",
}

AI.GreetingMessages = 
{
	"[$119]",
	"[$120]",
	"Welcome, welcome. Can I interest you in something?",
}

AI.HowToPurchaseMessages = {
	"[$121]"
}

AI.NotInterestedMessage = 
{
	"I'm not interested in that sort of thing, sorry.",
	"I don't want that, thank you.",
    "I'm definitely not interested in that.",
	"I'm not looking to buy that, sorry.",
}

AI.NotYoursMessage = {
	"I'm not about to buy something that isn't yours.",
	"That's not yours, are you playing games with me?.",
	"Even if that was yours I wouldn't buy it.",
}

AI.CantAffordPurchaseMessages = {
	"That's not enough to cover costs I'm afraid.",
	"[$122]",
	"[$123]",
}

AI.AskHelpMessages =
{
	"I can assist you with that, what would you need?",
	"[$124]",
	"What would you need then?",
}

AI.RefuseTrainMessage = {
	"[$125]",
	"[$126]",
}

AI.WellTrainedMessage = {
	"[$127]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"Magic is intense, don't mess with it!",
}

AI.NevermindMessages = 
{
    "Anything else I can assist you with...?",
    "Anything else this mage can help you with...?",
    "What else would you desire?",
}

AI.TalkMessages = 
{
	"[$131]",
	"Ask, but know that there is always more to know!",
}

AI.WhoMessages = {
	"[$132]",
}

AI.PersonalQuestion = {
	"If you so wish. What is your question?",
    "[$133]",
    "I have much to divulge. Even about myself."
}

AI.HowMessages = {
	"[$134]",
}

AI.FamilyMessage = {
	"[$135]",
	}

AI.SpareTimeMessages= {
	"[$136]",
}

AI.WhatMessages = {
	"...Regarding...?",
	"...Regarding what?",
	"...Regarding...?",
}

AI.StoryMessages = {
	"[$137]"
}

function Dialog.OpenWhoDialog(user)
    QuickDialogMessage(this,user,"I'm pretty sure I told you I'm your local mage...")
end

function Dialog.OpenTalkDialog(user)
    QuickDialogMessage(this,user,"We all have many questions, perhaps you should bother the Gods with your troubles.")
end

OverrideEventHandler("base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)
