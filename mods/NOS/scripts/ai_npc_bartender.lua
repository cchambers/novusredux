require 'NOS:base_ai_npc'

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = true
AI.Settings.EnableBuy = true
AI.Settings.SetIntroObjVar = false
AI.Settings.StationedLeash = true

fixPrice = 20

--AI.QuestList = {"AnimalTamingQuest"}
AI.Settings.KnowName = false 
--AI.Settings.HasQuest = true
--AI.QuestMessages = {"Welcome to the Inn of the Golden Lion."}

NPCTasks = {
--[[ 
    WineStockTask = {
        TaskName = "WineStockTask",
        TaskDisplayName = "Diminishing Wine Stock",
        RewardType = "animalparts_leather_hide",
        Description = "Collect 7 bottles of Wine",
        FinishDescription = "Go back and talk to Dr. Paws",
        RewardAmount = 3,
        Repeatable = false, --if you can redo the task
        Importance = 2, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$173]",
        TaskAcceptSpeech = "[$174]",
        TaskCurrentSpeech = "Any luck so far on acquiring some wine?",
        TaskContinueSpeech = "Good luck then, you'll find some eventually.",
        TaskCancelSpeech = "[$175]",
        TaskHelpSpeech = "[$176]",
        TaskPreCompleteSpeech = "[$177]",
        TaskFinishedMessage = "[$178]",
        TaskIncompleteMessage = "[$179]",
        TaskAssists = {
                      {Template = "cel_blacksmith",Text = "[$180]"},
                      {Template = "cel_merchant_bartenders_wife",Text = "[$181]"},
                      {Template = "cel_mayor",Text = "[$182]"},
                      {Template = "cel_merchant_general_store",Text = "[$183]"},
                      },
        CheckCompletionCallback = "Items",
        CompletionCallback = "Items",
        TaskItemList = {
            {"ingredient_wine",7},
        },
        Faction = "Villagers",
        FactionOnFinish = 1,
    },
    
    AleIngredientsTask = {
        TaskName = "AleIngredientsTask",
        TaskDisplayName = "Ale Ingredients",
        RewardType = "item_ale",
        Description = "Collect 8 Ginseng roots",
        FinishDescription = "Go back and talk to Dr. Paws",
        RewardAmount = 2,
        Repeatable = true, --if you can redo the task
        Importance = 1, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$184]",
        TaskAcceptSpeech = "[$185]",
        TaskCurrentSpeech = "[$186]",
        TaskContinueSpeech = "[$187]",
        TaskCancelSpeech = "[$188]",
        TaskHelpSpeech = "[$189]",
        TaskPreCompleteSpeech = "[$190]",
        TaskFinishedMessage = "[$191]",
        TaskIncompleteMessage = "[$192]",
        TaskAssists = {
                      {Template = "cel_merchant_general_store",Text = "[$193]"},
                      },
        CheckCompletionCallback = "Items",
        CompletionCallback = "Items",
        TaskItemList = {
            {"ingredient_ginsengroot",8},
        },
        Faction = "Villagers",
        FactionOnFinish = 2,
    },--]]
}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$194]"..
    "[$195]",
} 

AI.TradeMessages = 
{
	"[$196]",
	"Come on, have a drink before we talk turkey.",
	"Sure, what can I assist you with today, sir.",
	"Anything for a valued customer, sir.",
}

AI.GreetingMessages = 
{
	"Well hello there, can I help you with something?",
	"What can I assist you with today, sir?",
	"Salutations my friend. Care to have an ale?",
}

AI.HowToPurchaseMessages = {
	"[$197]"
}

AI.NotInterestedMessage = 
{
	"I'm not interested that sort of thing, sorry.",
	"I don't want that, thank you.",
    "I'm definitely not interested in that.",
	"I'm not looking to buy that, sorry.",
}

AI.NotYoursMessage = {
	"I'm not about to buy something that isn't yours.",
	"[$198]",
	"Even if that was yours, I wouldn't want it.",
}

AI.CantAffordPurchaseMessages = {
	"[$199]",
	"[$200]",
	"[$201]",
}

AI.CantAffordTrainPurchaseMessages = {
    "[$1724]"
}

AI.AskHelpMessages =
{
	"Well, what can I do for you today?",
	"What can I assist you with today?",
	"Anything for a patron. What do you need?",
}

AI.RefuseTrainMessage = {
	"[$202]",
	"[$203]",
}

AI.WellTrainedMessage = {
	"[$204]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"[$205]",
	"[$206]",
	"[$207]",
}

AI.NevermindMessages = 
{
    "Anything else there?",
    "Can I serve you another drink?",
    "Anything else?",
}

AI.TalkMessages = 
{
	"Certainly, I always have an open ear.",
	"Certainly! Ask away!",
}

AI.WhoMessages = {
	"[$208]",
}

AI.PersonalQuestion = {
	"[$209]",
    "I'm an open book, feel free to ask anything.",
    "[$210]"
}

AI.HowMessages = {
	"[$211]",
}

AI.FamilyMessage = {
	"[$212]",
	}

AI.SpareTimeMessages= {
	"[$213]",
}

AI.WhatMessages = {
	"...About...?",
	"...Regarding what topic?",
	"...Regarding...?",
}

AI.StoryMessages = {
	"[$214]"
}


--[[function IntroDialog(user)

    if (user:HasObjVar("OpenedDialog|Dr. Paws the Innkeeper")) then
        text = "[$215]"
    else
        text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
    end
    user:SetObjVar("OpenedDialog|Dr. Paws the Innkeeper",true)

    response = {}

    response[1] = {}
    response[1].text = "Yes, I want to be an animal tamer..."
    response[1].handle = "StartAnimalTamingQuest" 

    response[2] = {}
    response[2].text = "No, thank you."
    response[2].handle = "Nevermind"

    response[3] = {}
    response[3].text = "Goodbye."
    response[3].handle = "ResetIntro" 

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenStartingQuestProfessionQuestDialog(user)
    IntroDialog(user)    
end

function Dialog.OpenAnimalTamingQuestIdentify3Animals(user)
    QuickDialogMessage(this,user,"[$216]")
end

function Dialog.OpenStartAnimalTamingQuestDialog(user)
    QuickDialogMessage(this,user,"[$217]")
    user:SendMessage("StartQuest","AnimalTamingQuest")
    user:SetObjVar("Intro|Dr. Paws the Innkeeper",true)
end

function Dialog.OpenAnimalTamingQuestCaptureAnAnimalDialog(user)
    QuickDialogMessage(this,user,"[$218]")
end

function Dialog.OpenAnimalTamingQuestTalkToDrPawsAgainDialog(user)
    QuickDialogMessage(this,user,"[$219]")
    user:SetObjVar("PawsFinished",true)
end

function Dialog.OpenAnimalTamingQuestGoToPawsDialog(user)
    QuickDialogMessage(this,user,"[$220]")
    user:SetObjVar("PawsFinished",true)
    local ProfessionQuestsComplete = user:GetObjVar("ProfessionQuestsComplete") or 0
    user:SetObjVar("ProfessionQuestsComplete",ProfessionQuestsComplete + 1)
end]]


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
    response[4].text = "I'm starving, do you have any food?"
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
    response[1].text = "...The City of Petra?"
    response[1].handle = "Imprisoning" 

    response[2] = {}
    response[2].text = "...This inn?"
    response[2].handle = "Inn" 

    response[3] = {}
    response[3].text = "...The beer you brew?"
    response[3].handle = "Beer"

    response[4] = {}
    response[4].text = "...Water magic?"
    response[4].handle = "WaterMagic" 

    response[5] = {}
    response[5].text = "...outside of Celador?"
    response[5].handle = "Outlands" 

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
    DialogReturnMessage(this,user,"[$221]","Right.")
end
function Dialog.OpenCeladorDialog(user)
	DialogReturnMessage(this,user,"[$222]","Right.")
end
Dialog.OpenWhereDialog = Dialog.OpenCeladorDialog

function Dialog.OpenImprisoningDialog(user)
	DialogReturnMessage(this,user,"[$223]","Right.")
end
function Dialog.OpenInnDialog(user)
	DialogReturnMessage(this,user,"[$224]","Huh. Interesting.")
end
function Dialog.OpenBeerDialog(user)
	DialogReturnMessage(this,user,"[$225]","Right, magic beer. That's awesome.")
end
function Dialog.OpenWaterMagicDialog(user)
    DialogReturnMessage(this,user,"[$226]","Oh.")
end
function Dialog.OpenOutlandsDialog(user)
    DialogReturnMessage(this,user,"[$227]","I don't know...")
end
function Dialog.OpenFoodDialog(user)
    fullLevel = user:GetObjVar("fullLevel")
    if (fullLevel == nil or fullLevel >= 0) then
        DialogReturnMessage(this,user,"[$228]","Oh.")
    elseif user:HasObjVar("AlreadyBeggedInn") then
        DialogReturnMessage(this,user,"[$229]","Gee thanks...")
    else
        local backpackObj = user:GetEquippedObject("Backpack")  
        local dropPos = GetRandomDropPosition(backpackObj)
        CreateObjInContainer("item_bread", backpackObj, dropPos, nil)
        dropPos = GetRandomDropPosition(backpackObj)
        CreateObjInContainer("item_beer", backpackObj, dropPos, nil)
        user:SystemMessage("You have received a loaf of bread and a beer!","info")
        user:SetObjVar("AlreadyBeggedInn",true)
        DialogReturnMessage(this,user,"[$230]","Thank you.")
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
	DialogReturnMessage(this,user,"[$231]","That's interesting.")
end

OverrideEventHandler("NOS:base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)
