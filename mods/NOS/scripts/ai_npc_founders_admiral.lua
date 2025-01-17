require 'base_ai_npc'

AI.Settings.MerchantEnabled = false
AI.Settings.EnableTrain = false
AI.Settings.EnableBuy = false
AI.Settings.StationedLeash = true
AI.Settings.CanConverse = false
fixPrice = 20

CanBuyItem = function (buyer,item)
    return IsFounder(buyer)
end
CanUseNPC = CanBuyItem

NPCTasks = {
}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$918]",
} 

AI.TradeMessages = 
{
	"",
}

AI.GreetingMessages = 
{
	"Ah you again. What can I help you with.",
}

AI.AskHelpMessages =
{
	"",
	"",
	"",
}

AI.NevermindMessages = 
{
    "Anything else then?",
    "What else?",
    "Anything else.",
}

AI.TalkMessages = 
{
	"What are you looking to know?",
	"[$919]",
}

AI.WhoMessages = {
	"[$920]",
}

AI.PersonalQuestion = {
	"A personal question?",
}

AI.HowMessages = {
	"[$921]",
}

AI.FamilyMessage = {
	"[$922]",
	}

AI.SpareTimeMessages= {
	"[$923]",
}

AI.WhatMessages = {
	"What is it, exactly?",
}

AI.StoryMessages = {
	"[$924]"
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
    response[1].text = "How are you an 'Admiral'"
    response[1].handle = "How" 

    response[2] = {}
    response[2].text = "What happened to that planet?"
    response[2].handle = "Planet" 

    response[3] = {}
    response[3].text = "Have you seen the Elder Gods?"
    response[3].handle = "Seen" 

    response[4] = {}
    response[4].text = "What have you seen in the stars?"
    response[4].handle = "Stars"

    response[5] = {}
    response[5].text = "How did all this get here?"
    response[5].handle = "Club" 

    response[6] = {}
    response[6].text = "Nevermind"
    response[6].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "Who are you exactly?"
    response[1].handle = "Story" 

    response[2] = {}
    response[2].text = "How are you an 'Admiral'?"
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
function Dialog.OpenPlanetDialog(user)
    DialogReturnMessage(this,user,"[$925]","Wow...")
end
function Dialog.OpenSeenDialog(user)
    DialogReturnMessage(this,user,"[$926]","Ah...")
end
function Dialog.OpenStarsDialog(user)
    DialogReturnMessage(this,user,"[$927]","Wow...")
end
function Dialog.OpenClubDialog(user)
    DialogReturnMessage(this,user,"[$928]","Ah...")
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
	DialogReturnMessage(this,user,"[$929]","Ah...")
end

OverrideEventHandler("base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)
