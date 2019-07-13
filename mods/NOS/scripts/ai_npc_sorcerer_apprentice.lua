require 'base_ai_npc'

AI.Settings.MerchantEnabled = false
AI.Settings.EnableTrain = false
AI.Settings.StationedLeash = true
fixPrice = 20

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$1431]"
} 

AI.GreetingMessages = 
{
	"Hey there, anything new going on?",
	"[$1432]",
	"What can I assist you with?",
}

AI.AskHelpMessages =
{
	"Well certainly, what can I help you with today?",
	"[$1433]",
	"Well sure, what do you need help with?",
	"[$1434]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.NevermindMessages = 
{
    "Anything else that concerns me?",
    "Anything else?",
    "What else is going on?",
}

AI.TalkMessages = 
{
	"Well sure, golly, I'm open to talking to people.",
	"Of course, what would you like to talk about?",
	"Any question is alright with me.",
	"I've got an answer.",
}

AI.WhoMessages = {
	"[$1435]",
	"[$1436]",
}

AI.PersonalQuestion = {
	"Sure, go ahead and ask.",
    "I don't got much to share, but sure, ask me.",
}

AI.HowMessages = {
	"[$1437]",
}

AI.FamilyMessage = AI.HowMessages

AI.SpareTimeMessages= {
	"[$1438]",
}

AI.WhatMessages = {
	"...About what?",
	"...About...?",
	"...What about?",
	"...Regarding...?",
}

AI.StoryMessages = {
	"[$1439]"
}


function Dialog.OpenHelpDialog(user)	

	text = AI.AskHelpMessages[math.random(1,#AI.AskHelpMessages)]
	
	response = {}

	response[1] = {}
	response[1].text = "I need assistance with..."
	response[1].handle = "Assistance" 

    response[2] = {}
    response[2].text = "Want a job...?"
    response[2].handle = "Job" 

    ---If rogue skill is high enough and you have reputation, you can have Greg steal stuff for you
    local rogueSkill = GetSkillLevel(this,"RogueSkill")
    if (rogueSkill > 30) then
        response[3] = {}
        response[3].text = "Can you get me some..."
        response[3].handle = "StealForYou"
    else
        response[3] = {}
        response[3].text = "I need help with magic"
        response[3].handle = "MagicHelp"
    end
	response[3] = {}
	response[3].text = "Nevermind."
	response[3].handle = "Nevermind" 

	NPCInteraction(text,this,user,"Responses",response)

end

function IntroDialog(user)

    text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]

    response = {}

    response[1] = {}
    response[1].text = "I have a question..."
    response[1].handle = "Talk" 

    response[2] = {}
    response[2].text = "I need something..."
    response[2].handle = "Help" 

    response[3] = {}
    response[3].text = "Who are you?"
    response[3].handle = "Who"

    response[4] = {}
    response[4].text = "Goodbye."
    response[4].handle = "" 

    NPCInteraction(text,this,user,"Responses",response)

	GetAttention(user)
end

function Dialog.OpenTalkDialog(user)

    text = AI.TalkMessages[math.random(1,#AI.TalkMessages)]

    response = {}

    response[1] = {}
    response[1].text = "Who are you anyway?"
    response[1].handle = "Who" 

    response[2] = {}
    response[2].text = "How do you know Nicodemus?"
    response[2].handle = "Nicodemus" 

    response[3] = {}
    response[3].text = "What do you do?"
    response[3].handle = "Who" 

    response[4] = {}
    response[4].text = "I need something..."
    response[4].handle = "Help" 

    response[5] = {}
    response[5].text = "Nevermind."
    response[5].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end


function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "What's your story?"
    response[1].handle = "Story" 

    response[2] = {}
    response[2].text = "You're an apprentice?"
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

    NPCInteraction(text,this,user,"Responses",response)

end

function Dialog.OpenCeladorDialog(user)
	DialogReturnMessage(this,user,"[$1440]","Right.")
end
Dialog.OpenWhereDialog = Dialog.OpenCeladorDialog
function Dialog.OpenJobDialog(user)
    DialogReturnMessage(this,user,"[$1441]","Right.")
end
function Dialog.OpenPetraDialog(user)
	DialogReturnMessage(this,user,"[$1442]","Sorry to hear that...")
end
function Dialog.OpenFamilyDialog(user)
	DialogReturnMessage(this,user,AI.FamilyMessage[math.random(1,#AI.FamilyMessage)],"Oh..")
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
    DialogReturnMessage(this,user,"[$1443]","That's crazy.")
end

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "blacksmith_fix", 
	function (target,buyer)
		amount = fixPrice
		if( CountCoins(buyer) < amount ) then
			Merchant.DoCantAfford(buyer)
			activeTransactions[transactionId] = nil
			return
		else
			-- everything checks out lets take the coins
			transactionData.State = "TakeCoins"			
			buyer:SetObjVar("ItemToFix",target)
			RequestConsumeResource(buyer,"coins",amount,"fix_item",this)
		end
	end)

function HandleConsumeResourceResponse(success,transactionId,buyer)	

	if( not(ValidateTransaction("TakeCoins",transactionId))) then
		activeTransactions[transactionId] = nil
		return
	end

	-- something went wrong taking the coins
	if( not(success) ) then
		Merchant.DoCantAfford(buyer)		
	-- we have taken the coins complete the transaction
	else
		FixItem(buyer:GetObjVar("ItemToFix"),buyer)		
		buyer:DelObjVar("ItemToFix")
	end

	activeTransactions[transactionId] = nil
end

OverrideEventHandler("base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)
