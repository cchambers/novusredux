require 'NOS:base_ai_npc'

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = false
AI.Settings.EnableBuy = true
AI.Settings.StationedLeash = true
fixPrice = 20

NPCTasks = {

}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$255]",
} 

AI.TradeMessages = 
{
	"[$256]",
	"[$257]",
}

AI.GreetingMessages = 
{
	"Hello again, my dear. What can I assist you with?",
	"Welcome again, can I help you with something?",
	"[$258]",
}

AI.HowToPurchaseMessages = {
	"[$259]"
}

AI.NotInterestedMessage = 
{
	"I don't think we'll be needing that, sorry.",
	"I don't want that, thank you.",
    "I'm not interested in that honestly.",
	"I'm not looking to buy that, my dear. I'm sorry.",
}

AI.NotYoursMessage = {
	"[$260]",
	"That's not yours, and that's not funny.",
	"[$261]",
}

AI.CantAffordPurchaseMessages = {
	"[$262]",
	"[$263]",
	"[$264]",
}

AI.AskHelpMessages =
{
	"Well, what can I help you with today?",
	"Well, what do you need, m'dear?",
	"Anything for a good patron. What do you need?",
}

AI.RefuseTrainMessage = {
	"[$265]",
	"[$266]",
}

AI.WellTrainedMessage = {
	"[$267]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"[$268]",
	"[$269]",
	"[$270]",
}

AI.NevermindMessages = 
{
    "Anything else there, m'dear?",
    "Anything else I can do for you?",
    "Anything else?",
}

AI.TalkMessages = 
{
	"Certainly, I always am open to talk.",
	"Certainly! Ask away!",
}

AI.WhoMessages = {
	"[$271]",
}

AI.PersonalQuestion = {
	"Why, I guess so. What would you like to know?",
    "[$272]",
    "[$273]"
}

AI.HowMessages = {
	"[$274]",
}

AI.FamilyMessage = {
	"[$275]",
    "[$276]",
    "[$277]",
    "[$278]"
	}

AI.SpareTimeMessages= {
	"[$279]",
}

AI.WhatMessages = {
	"...About...?",
	"...Regarding what m'dear?",
	"...Regarding...?",
}

AI.StoryMessages = {
	"[$280]"
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
    response[4].text = "I'm starving, do you have food?"
    response[4].handle = "Food" 

    response[5] = {}
    response[5].text = "Nevermind."
    response[5].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhatDialog(user)
    text = AI.WhatMessages[math.random(1,#AI.WhatMessages)]

    response = {}

    response[1] = {}
    response[1].text = "...What happened to the city?"
    response[1].handle = "Imprisoning" 

    response[2] = {}
    response[2].text = "...This inn?"
    response[2].handle = "Inn" 

    response[3] = {}
    response[3].text = "...The recipe for stew?"
    response[3].handle = "Soup"

    response[4] = {}
    response[4].text = "...Your husband?"
    response[4].handle = "Husband" 

    response[5] = {}
    response[5].text = "...All the pets???"
    response[5].handle = "Pets" 

    response[6] = {}
    response[6].text = "Nevermind."
    response[6].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "What's your story?"
    response[1].handle = "Story" 

    response[2] = {}
    response[2].text = "Why are you a bartender?"
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
    response[1].text = "Do you have a family?"
    response[1].handle = "Family" 

    response[2] = {}
    response[2].text = "What's your last name?"
    response[2].handle = "LastName" 

    response[3] = {}
    response[3].text = "What do you do in your spare time?"
    response[3].handle = "SpareTime"

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)

end

function Dialog.OpenCantDialog(user)
    --DFB TODO: Make this dialog disappear and implement it based on a per-task basis!
    DialogReturnMessage(this,user,"[$281]","Right.")
end
function Dialog.OpenCeladorDialog(user)
	DialogReturnMessage(this,user,"[$282]","Right.")
end
Dialog.OpenWhereDialog = Dialog.OpenCeladorDialog
function Dialog.OpenImprisoningDialog(user)
	DialogReturnMessage(this,user,"[$283]","Right.")
end
function Dialog.OpenInnDialog(user)
	DialogReturnMessage(this,user,"[$284]","Right.")
end
function Dialog.OpenSoupDialog(user)
	DialogReturnMessage(this,user,"[$285]","Well then.")
end
function Dialog.OpenHusbandDialog(user)
    DialogReturnMessage(this,user,"[$286]","Oh... sorry.")
end
function Dialog.OpenPetsDialog(user)
    DialogReturnMessage(this,user,"[$287]","Heh...")
end
function Dialog.OpenFoodDialog(user)
    fullLevel = user:GetObjVar("fullLevel")
    if (fullLevel == nil or fullLevel >= 0) then
        DialogReturnMessage(this,user,"[$288]","Oh.")
    elseif user:HasObjVar("AlreadyBeggedInn") then
        DialogReturnMessage(this,user,"[$289]","Gee thanks...")
    else
        local backpackObj = user:GetEquippedObject("Backpack")  
        local dropPos = GetRandomDropPosition(backpackObj)
        CreateObjInContainer("item_bread", backpackObj, dropPos, nil)
        dropPos = GetRandomDropPosition(backpackObj)
        CreateObjInContainer("item_ale", backpackObj, dropPos, nil)
        user:SystemMessage("You have received a loaf of bread and a beer!","info")
        user:SetObjVar("AlreadyBeggedInn",true)
        DialogReturnMessage(this,user,"[$290]","Thank you.")
    end
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
	DialogReturnMessage(this,user,"[$291]","Ah.")
end

OverrideEventHandler("NOS:base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)
