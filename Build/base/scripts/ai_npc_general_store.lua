require 'base_ai_npc'

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = true
AI.Settings.EnableBuy = true
AI.Settings.StationedLeash = true
fixPrice = 20

--[[NPCTasks = {
    BuriedTreasureTask = {
        TaskName = "BuriedTreasureTask",
        TaskDisplayName = "Searching for Buried Treasure",
        Description = "Find a treasure map.",
        FinishDescription = "Bring it back to Guy the Trader.",
        RewardType = "coins",
        RewardAmount = 300,
        Repeatable = true, --if you can redo the task
        Importance = 1, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$994]",
        TaskAcceptSpeech = "[$995]",
        TaskCurrentSpeech = "[$996]",
        TaskContinueSpeech = "[$997]",
        TaskCancelSpeech = "[$998]",
        TaskHelpSpeech = "[$999]",
        TaskPreCompleteSpeech = "[$1000]",
        TaskFinishedMessage = "[$1001]",
        TaskIncompleteMessage = "[$1002]",
        TaskAssists = {
                      {Template = "cel_village_beatrix",Text = "[$1003]"},
                      {Template = "cel_merchant_bartender",Text = "[$1004]"},
                      {Template = "cel_merchant_blacksmith",Text = "[$1005]"},
                      {Template = "cel_quarry_head_miner",Text = "[$1006]"},
                      },
        CompletionCallback = "Items",
        CheckCompletionCallback = "Items",
        TaskItemList = {
            {"treasure_map",1},
        },
        Faction = "Villagers",
    },
    MagicalArtsTask = {
        TaskName = "MagicalArtsTask",
        TaskDisplayName = "Guy the Mage",
        RewardType = "lockbox",
        Description = "Find a Fireball Scroll.",
        FinishDescription = "Bring it back to Guy the Trader.",
        RewardAmount = 1,
        Repeatable = false, --if you can redo the task
        Importance = 1, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$1007]",
        TaskAcceptSpeech = "[$1008]",
        TaskCurrentSpeech = "Have you found the fireball scroll yet?",
        TaskContinueSpeech = "[$1009]",
        TaskCancelSpeech = "Hey wait! How can you give up on me? Shame on you!",
        TaskHelpSpeech = "[$1010]",
        TaskPreCompleteSpeech = "[$1011]",
        TaskFinishedMessage = "[$1012]",
        TaskIncompleteMessage = "[$1013]",
        TaskAssists = {
            {Template = "cel_rothchilde",Text = "[$1014]"},
            {Template = "cel_village_beatrix",Text = "[$1015]"},
        },
        CompletionCallback = "Items",
        CheckCompletionCallback = "Items",
        TaskItemList = {
            {"lscroll_fireball",1},
        },
        Faction = "Villagers",
        TaskType = "item", --valid keys are item, character, mobile, etc.
        },
}--]]

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$1016]",
} 

AI.TradeMessages = 
{
	"Well certainly! I'm always down to talk turkey!",
	"[$1017]",
	"Sure, what can I assist you with today, sir?",
	"Anything for a valued customer, sir.",
}

AI.GreetingMessages = 
{
	"Well hello there, can I help you with something?",
	"What can I assist you with today, sir?",
	"Salutations my friend. Care to look at my wares?",
}

AI.HowToPurchaseMessages = {
	"[$1018]"
}

AI.NotInterestedMessage = 
{
	"I'm not interested in that.",
	"That's worthless. I don't want that.",
    "I'm definitely not interested in that.",
	"I don't want that at all, thank you sir.",
}

AI.NotYoursMessage = {
	"I wouldn't take it, considering it's not yours!",
	"[$1019]",
	"[$1020]",
}

AI.CantAffordPurchaseMessages = {
	"[$1021]",
	"I'm sorry sir, but what you have isn't enough...",
	"[$1022]",
}

AI.AskHelpMessages =
{
	"[$1023]",
	"Well, uh, sure... What can I help you with?",
	"Um, certainly sir. What seems to be the issue?",
}

AI.RefuseTrainMessage = {
	"[$1024]",
	"[$1025]",
}

AI.WellTrainedMessage = {
	"[$1026]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"[$1027]",
	"[$1028]",
	"[$1029]",
}

AI.NevermindMessages = 
{
    "Anything else I can do for you, sir?",
    "[$1030]",
    "Anything else, my dear customer?",
}

AI.TalkMessages = 
{
	"By all means, go ahead! What's the question?",
	"Certainly! Ask away!",
}

AI.WhoMessages = {
	"[$1031]",
}

AI.PersonalQuestion = {
	"[$1032]",
}

AI.HowMessages = {
	"[$1033]",
}

AI.FamilyMessage = {
	"[$1034]",
	}

AI.SpareTimeMessages= {
	"[$1035]",
}

AI.WhatMessages = {
	"...About...?",
	"...What about, sir?",
	"...Regarding...?",
}

AI.StoryMessages = {
	"[$1036]"
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
    --DebugMessage("WhatDialog")
    text = AI.WhatMessages[math.random(1,#AI.WhatMessages)]

    response = {}

    response[1] = {}
    response[1].text = "...What happened to the city?"
    response[1].handle = "Imprisoning" 

    response[2] = {}
    response[2].text = "...Where do people sleep?"
    response[2].handle = "Sleep" 

    response[3] = {}
    response[3].text = "...The gods?"
    response[3].handle = "Gods"

    response[4] = {}
    response[4].text = "...Where you get your supplies?"
    response[4].handle = "Supplier" 

    response[5] = {}
    response[5].text = "...The lack of competition?"
    response[5].handle = "Competition" 

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
    response[2].text = "Why are you a trader?"
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
    DialogReturnMessage(this,user,"[$1037]","Right.")
end
function Dialog.OpenCeladorDialog(user)
	DialogReturnMessage(this,user,"[$1038]","Right.")
end
function Dialog.OpenImprisoningDialog(user)
	DialogReturnMessage(this,user,"[$1039]","Right.")
end
function Dialog.OpenSleepDialog(user)
	DialogReturnMessage(this,user,"[$1040]","Eww.")
end
function Dialog.OpenGodsDialog(user)
	DialogReturnMessage(this,user,"[$1041]","Interesting.")
end
function Dialog.OpenSupplierDialog(user)
    DialogReturnMessage(this,user,"[$1042]","Oh.")
end
function Dialog.OpenCompetitionDialog(user)
    DialogReturnMessage(this,user,"[$1043]","Don't worry.")
end
function Dialog.OpenFoodDialog(user)
    fullLevel = user:GetObjVar("fullLevel")
    if (fullLevel == nil or fullLevel >= 0) then
        DialogReturnMessage(this,user,"[$1044]","Oh.")
    elseif user:HasObjVar("AlreadyBegged") then
        DialogReturnMessage(this,user,"[$1045]","Gee thanks...")
    else
        local backpackObj = user:GetEquippedObject("Backpack")  
        local dropPos = GetRandomDropPosition(backpackObj)
        CreateObjInContainer("item_bread", backpackObj, dropPos, nil)
        dropPos = GetRandomDropPosition(backpackObj)
        CreateObjInContainer("item_apple", backpackObj, dropPos, nil)
        user:SystemMessage("You have received a loaf of bread and an apple!","info")
        user:SetObjVar("AlreadyBegged",true)
        backpackObj:SendOpenContainer(user)
        DialogReturnMessage(this,user,"[$1046]","Thank you.")
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
    user:SetObjVar("GuyFawker",true)
	DialogReturnMessage(this,user,"[$1047]","...Uh-huh. Very nice apples...")
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
