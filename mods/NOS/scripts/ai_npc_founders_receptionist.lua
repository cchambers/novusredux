require 'NOS:base_ai_npc'

AI.Settings.MerchantEnabled = false
AI.Settings.EnableTrain = false
AI.Settings.EnableBuy = false
AI.Settings.StationedLeash = true
AI.Settings.SetIntroObjVar = false
AI.Settings.CanConverse = false
AI.Settings.EnableBank = true
AI.Settings.EnableTax = true

fixPrice = 20

NPCTasks = {
}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$974]",
} 

AI.TradeMessages = 
{
	"What you see is what I have.",
	"I got what you see in front of you for sale.",
	"I have a few things for sale.",
	"I have these items for sale.",
}

AI.GreetingMessages = 
{
    "[$975]",
	"Hey I remember you. You have a membership?",
}

AI.HowToPurchaseMessages = {
	"[$976]"
}

AI.NotInterestedMessage = 
{
	"I'm not interested in that, sorry.",
}

AI.NotYoursMessage = {
	"I would buy it, but it's not yours!",
}

AI.CantAffordPurchaseMessages = {
	"Sorry if you can't afford it I can't help you.",
}

AI.AskHelpMessages =
{
	"What do you need help with?",
}

AI.RefuseTrainMessage = {
	"If you don't want to learn, I'm sorry.",
}

AI.WellTrainedMessage = {
	"You already know enough for me.",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"I can teach you these things.",
}

AI.NevermindMessages = 
{
    "Alright then, anything else?",
}

AI.TalkMessages = 
{
	"What can I help you with?",
}

AI.WhoMessages = {
	"[$977]",
}

AI.PersonalQuestion = {
	"...You want to ask me a personal question?",
}

AI.HowMessages = {
	"[$978]",
}

AI.FamilyMessage = {
	"[$979]",
	}

AI.SpareTimeMessages= {
	"Clean the house, or go out. Just usual stuff.",
}

AI.WhatMessages = {
	"...Regarding what? I'm here to help!",
}

AI.StoryMessages = AI.HowMessages

function Dialog.OpenTalkDialog(user)

    text = AI.TalkMessages[math.random(1,#AI.TalkMessages)]

    response = {}

    response[1] = {}
    response[1].text = "What does it take to get in?"
    response[1].handle = "Member" 

    response[2] = {}
    response[2].text = "I have another question."
    response[2].handle = "What"

    response[3] = {}
    response[3].text = "Can you tell me about this place?"
    response[3].handle = "Backstory"

    response[4] = {}
    response[4].text = "Goodbye."
    response[4].handle = "" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end


function Dialog.OpenGreetingDialog(user)
    text = AI.GreetingMessages[math.random(1,#AI.GreetingMessages)]

    response = {}

    response[1] = {}
    response[1].text = "...Yes?"
    response[1].handle = "YesMembership" 

    response[2] = {}
    response[2].text = "Don't think so."
    response[2].handle = "NoMembership"

    response[3] = {}
    response[3].text = "I don't know."
    response[3].handle = "IDontKnowMembership"

    response[4] = {}
    response[4].text = "Goodbye."
    response[4].handle = "" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function IntroDialog(user)
    --DebugMessage(2)
    text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]

    response = {}

    response[1] = {}
    response[1].text = "...Yes?"
    response[1].handle = "YesMembership" 

    response[2] = {}
    response[2].text = "Don't think so."
    response[2].handle = "NoMembership"

    response[3] = {}
    response[3].text = "I don't know."
    response[3].handle = "IDontKnowMembership"

    response[4] = {}
    response[4].text = "Goodbye."
    response[4].handle = "" 

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenWhatDialog(user)
    --DebugMessage("WhatDialog")
    text = AI.WhatMessages[math.random(1,#AI.WhatMessages)]

    response = {}

    response[1] = {}
    response[1].text = "Becoming a member?"
    response[1].handle = "Member" 

    response[2] = {}
    response[2].text = "What's inside?"
    response[2].handle = "Contents" 

    response[3] = {}
    response[3].text = "Where are you all from?"
    response[3].handle = "Backstory"

    response[6] = {}
    response[6].text = "Nevermind."
    response[6].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "How did you start working here?"
    response[1].handle = "Story" 

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
    DialogReturnMessage(this,user,"Sorry I can't do that.","Right.")
end
function Dialog.OpenYesMembershipDialog(user)    
    if (IsCollector(user)) then
        text = "[$983]"
    elseif (IsFounder(user)) then
        text = "[$982]"
    else
        text = "[$981]"
    end
	DialogReturnMessage(this,user,text,"Great, thanks.")
end
function Dialog.OpenNoMembershipDialog(user)
    if (IsCollector(user) ) then
        text = "[$986]"
    elseif (IsFounder(user)) then
        text = "[$985]"
    else
        text = "[$984]"
    end
    DialogReturnMessage(this,user,text,"Great, thanks.")
end
function Dialog.OpenIDontKnowMembershipDialog(user)
    if (IsCollector(user)) then
        text = "[$989]"
    elseif (IsFounder(user)) then
        text = "[$988]"
    else
        text = "[$987]"
    end
    DialogReturnMessage(this,user,"","Great, thanks..")
end
function Dialog.OpenContentsDialog(user)
    DialogReturnMessage(this,user,"[$990]","Interesting.")
end
function Dialog.OpenMemberDialog(user)
    DialogReturnMessage(this,user,"[$991]","Oh.")
end
function Dialog.OpenBackstoryDialog(user)
    DialogReturnMessage(this,user,"[$992]","Interesting.")
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
	DialogReturnMessage(this,user,"[$993]","I plan on it...")
end

OverrideEventHandler("NOS:base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)
