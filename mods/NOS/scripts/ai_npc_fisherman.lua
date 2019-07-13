require 'NOS:base_ai_npc'

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = true
AI.Settings.EnableBuy = true
AI.Settings.SetIntroObjVar = false
AI.Settings.StationedLeash = true
AI.Settings.EnableRepair = false

fixPrice = 20

AI.IntroMessages =
{
	"Aye friend, come 'ave a look at me humble stock. If yer interested in fishing, perhaps I teach ye a thing or two for some coin?"
} 
--[[

AI.TradeMessages = 
{
	"[$396]",
	"[$397]",
	"[$398]",
	"[$399]",
}

AI.GreetingMessages = 
{
	"[$400]",
	"[$401]",
	"[$402]",
}

AI.HowToPurchaseMessages = {
	"[$403]"
}

--]]

AI.NotInterestedMessage = 
{
	"Tryin' to peddle garbage? I'm not interested. Take that to someone that buys garbage."
}

--[[
AI.NotYoursMessage = {
	"That is not yours to sell!",
	"Sure, I'd buy it, if it were yours.",
	"I don't think you own that, right?",
}

AI.CantAffordPurchaseMessages = {
	"[$405]",
	"I don't think you have enough for that.",
	"You don't have enough money to buy that.",
}

AI.AskHelpMessages =
{
	"[$406]",
	"It depends on what you need.",
	"[$407]",
	"[$408]",
}

AI.FixMessage = {
	"[$409]"..fixPrice.." Coins[-], but it won't last as long the next time. You sure?",
}

AI.RefuseTrainMessage = {
	"Whatever. I got better things to do with my time.",
	"I got better things to do anway.",
}

AI.WellTrainedMessage = {
	"[$410]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"[$411]",
	"[$412]",
	"[$413]",
}

AI.NevermindMessages = 
{
    "Anything else you want?",
    "Anything else?",
    "What else do you need?",
}

AI.TalkMessages = 
{
	"What's your question. Speak up I can't hear you!",
	"[$414]",
	"[$415]",
	"What do you want to know.",
}

]]--

AI.WhoMessages = {
	"I just be an old fisherman trying to make a living. I could tell you some of me old fishin' stories, but ye'd be bored to tears. Yar har harr!"
}

--[[
AI.PersonalQuestion = {
	"Sure. What is it.",
}

AI.HowMessages = {
	"[$418]",
}

AI.FamilyMessage = {
	"I dont want to talk about it.",
	"That's none of your business.",
	"It's none of your damn business.",
	"I'm not discussing that with you.",
	"[$419]",
}

AI.SpareTimeMessages= {
	"[$420]",
}

AI.WhatMessages = {
	"...About what? Speak up, I can't hear you!",
	"...About...?",
	"...What about?",
	"...Regarding...?",
}

AI.StoryMessages = {
	"[$421]"
}
]]--