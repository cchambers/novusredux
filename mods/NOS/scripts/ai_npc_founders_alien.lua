require 'NOS:base_ai_npc'

AI.Settings.MerchantEnabled = false
AI.Settings.EnableTrain = false
AI.Settings.EnableBuy = false
AI.Settings.CanConverse = false
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
	"[$930]",
} 

AI.TradeMessages = 
{
	"",
}

AI.GreetingMessages = 
{
	"Oradu'Lauz my friend. What do you need?",
}

AI.AskHelpMessages =
{
	"I cannot help you, sorry.",
}

AI.NevermindMessages = 
{
    "What else can this one help you with?",
}

AI.TalkMessages = 
{
	"I can tell you a few things, human.",
}

AI.WhoMessages = {
	"[$931]",
}

AI.PersonalQuestion = {
	"A personal question? Feel free to ask.",
}

AI.HowMessages = {
	"",
}

AI.FamilyMessage = {
	"[$932]",
	}

AI.SpareTimeMessages= {
	"[$933]",
}

AI.WhatMessages = {
	"What do you want to know?",
}

AI.StoryMessages = {
	"[$934]"
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
    response[3].text = "What is that out there?"
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
    response[1].text = "What happened to your world?"
    response[1].handle = "YourWorld" 

    response[2] = {}
    response[2].text = "Tell me about your people."
    response[2].handle = "YourPeople" 

    response[3] = {}
    response[3].text = "What is out there, in space?"
    response[3].handle = "Space"

    response[4] = {}
    response[4].text = "How did all this get here?"
    response[4].handle = "Club" 

    response[5] = {}
    response[5].text = "Nevermind"
    response[5].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "Who are you exactly?"
    response[1].handle = "Story" 

    response[2] = {}
    response[2].text = "How are you an alien?"
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
function Dialog.OpenYourWorldDialog(user)
    DialogReturnMessage(this,user,"[$942]","Wow...")
end
function Dialog.OpenYourPeopleDialog(user)
    DialogReturnMessage(this,user,"[$943]","Sorry to hear that...")
end
function Dialog.OpenSpaceDialog(user)
    DialogReturnMessage(this,user,"[$944]","Interesting...")
end
function Dialog.OpenClubDialog(user)
    DialogReturnMessage(this,user,"[$945]","Ah...")
end
function Dialog.OpenCantDialog(user)
    --DFB TODO: Make this dialog disappear and implement it based on a per-task basis!
    DialogReturnMessage(this,user,"I can't do that. Sorry.","Right.")
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
	DialogReturnMessage(this,user,"[$946]","Ah...")
end

OverrideEventHandler("NOS:base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)
