require 'NOS:base_ai_npc'

AI.Settings.MerchantEnabled = false
AI.Settings.EnableTrain = false
AI.Settings.EnableBuy = false
AI.Settings.SetIntroObjVar = false
AI.Settings.CanConverse = false
AI.Settings.StationedLeash = true

fixPrice = 20

CanBuyItem = function (buyer,item)
    return IsFounder(buyer)
end

NPCTasks = {
}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$952]",
} 

AI.GreetingMessages = 
{
	"[$953]",
	"[$954]",
}


AI.NotInterestedMessage = 
{
	"No, no, I am not interested in that.",
}

AI.AskHelpMessages =
{
	"You require our assistance? What do you need then?",
	"",
	"",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.NevermindMessages = 
{
    "Ah, what else do you have to speak of, mortal!",
    "...Nevermind then indeed. What else?",
    "Ah but that is not all then, is it?",
}

AI.TalkMessages = 
{
	"What do you wish to know, mortal?",
}

AI.WhoMessages = {
	"[$955]",
}

AI.PersonalQuestion = {
	"[$956]",
}

AI.HowMessages = {
	"[$957]",
}

AI.FamilyMessage = {
	"[$958]",
	}

AI.SpareTimeMessages= {
	"[$959]",
}

AI.WhatMessages = {
	"What do you wish to know, mortal?",
}

AI.StoryMessages = {
	"[$960]"
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
    response[3].text = "Nevermind."
    response[3].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhatDialog(user)
    --DebugMessage("WhatDialog")
    text = AI.WhatMessages[math.random(1,#AI.WhatMessages)]

    response = {}

    response[1] = {}
    response[1].text = "...What are you?"
    response[1].handle = "Pedesii" 

    response[2] = {}
    response[2].text = "...The gods?"
    response[2].handle = "Gods" 

    response[3] = {}
    response[3].text = "...This club?"
    response[3].handle = "Club"

    response[4] = {}
    response[4].text = "...Where you came from?"
    response[4].handle = "Origin" 

    response[5] = {}
    response[5].text = "...Appeasing you?"
    response[5].handle = "Appeasing" 

    response[6] = {}
    response[6].text = "Nevermind."
    response[6].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "Why was this club built?"
    response[1].handle = "Story" 

    response[2] = {}
    response[2].text = "How did you become gods?"
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
    DialogReturnMessage(this,user,"","Right.")
end
function Dialog.OpenPedesiiDialog(user)
	DialogReturnMessage(this,user,"[$966]","Right.")
end
function Dialog.OpenGodsDialog(user)
	DialogReturnMessage(this,user,"[$967]","Right.")
end
function Dialog.OpenClubDialog(user)
	DialogReturnMessage(this,user,"[$968]","Hmm.")
end
function Dialog.OpenOriginDialog(user)
	DialogReturnMessage(this,user,"[$969]","Interesting.")
end
function Dialog.OpenAppeasingDialog(user)
    DialogReturnMessage(this,user,"[$970]","Okay.")
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
	DialogReturnMessage(this,user,"We are Pedesii. We have no last name.","Oh, okay...")
end

OverrideEventHandler("NOS:base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)
