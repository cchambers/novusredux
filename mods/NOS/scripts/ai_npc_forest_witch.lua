require 'NOS:base_ai_npc'

AI.Settings.MerchantEnabled = false
AI.Settings.EnableTrain = false
AI.Settings.EnableBuy = false
AI.Settings.SetIntroObjVar = false
AI.Settings.StationedLeash = true

fixPrice = 20

--[[NPCTasks = {
    SpiderEyesTask = {
        TaskName = "SpiderEyesTask",
        TaskDisplayName = "The Concoction",
        Description = "Find the ingredients to the love potion.",
        FinishDescription = "Bring them back to Vivia.",
        RewardType = "lscroll_resurrect",
        RewardAmount = 1,
        Repeatable = false, --if you can redo the task
        Importance = 2, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$872]",
        TaskAcceptSpeech = "[$873]",
        TaskCurrentSpeech = "Ah, I remember. Have you found what I need?",
        TaskContinueSpeech = "[$874]",
        TaskCancelSpeech = "[$875]",
        TaskHelpSpeech = "[$876]",
        TaskPreCompleteSpeech = "[$877]",
        TaskFinishedMessage = "[$878]",
        TaskIncompleteMessage = "[$879]",
        TaskAssists = {
                      {Template = "cel_lumberjack",Text = "[$880]"},
                      {Template = "cel_guard_rufus",Text = "[$881]"},
                      {Template = "cel_merchant_general_store",Text = "[$882]"},
                      },
        CheckCompletionCallback = "Items",
        CompletionCallback = "Items",
        TaskItemList = {
            {"animalparts_spider_eye",2},
            {"animalparts_wolf_fang",2},
            {"ingredient_mushroom",4},
            {"animalparts_bear_claw",1},
        },
    },
    SnakeSkinsTask = {
        TaskName = "SnakeSkinsTask",
        TaskDisplayName = "Skin of Snakes",
        Description = "Find two snake skins.",
        FinishDescription = "Bring them back to Vivia.",
        RewardType = "resource_essence",
        RewardAmount = 6,
        Repeatable = true, --if you can redo the task
        Importance = 1, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$883]",
        TaskAcceptSpeech = "[$884]",
        TaskCurrentSpeech = "Have you found the snake skins I need?",
        TaskContinueSpeech = "[$885]",
        TaskCancelSpeech = "[$886]",
        TaskHelpSpeech = "[$887]",
        TaskPreCompleteSpeech = "[$888]",
        TaskFinishedMessage = "[$889]",
        TaskIncompleteMessage = "[$890]",
        TaskAssists = {
                      {Template = "cel_merchant_alchemist",Text = "[$891]"},
                      },
        CheckCompletionCallback = "Items",
        CompletionCallback = "Items",
        TaskItemList = {
            {"animalparts_snake_skin",2},
        },
    },
}--]]


AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$892]"

} 

AI.TradeMessages = 
{
	"[$893]",
}

AI.GreetingMessages = 
{
	"[$894]",
	"[$895]",
	"[$896]",
}

AI.NotInterestedMessage = 
{
	"I don't want that.",
	"That's worthless. I certainly won't want that.",
	"Why would you think I'd want that...?",
	"Eh, I don't want that.",
}

AI.NotYoursMessage = {
	"[$897]",
	"I do not believe that you can sell that.",
	"I would buy that of course, if it were yours!",
}

AI.CantAffordPurchaseMessages = {
	"You don't have enough money to buy that.",
}

AI.AskHelpMessages =
{
	"[$898]",
	"[$899]",
	"[$900]",
	"It depends on what you need, my'dear.",
}

AI.RefuseTrainMessage = {
	"Well, I'd never. Fine. Do not bother me again.",
	"[$901]",
}

AI.WellTrainedMessage = {
	"[$902]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"[$903]",
}

AI.NevermindMessages = 
{
    "Anything else you desire...?",
    "Is that all.",
    "What else do you desire...",
}

AI.TalkMessages = 
{
	"[$904]",
	"You inquire about me? You will learn little.",
}

AI.WhoMessages = {
	"[$905]",
}

AI.PersonalQuestion = {
	"[$906]",
}

AI.HowMessages = {
	"[$907]",
}

AI.FamilyMessage = {
	"[$908]",
}

AI.SpareTimeMessages= {
	"[$909]",
}

AI.WhatMessages = {
	"...I maintain my interest, what say you...?",
	"...What do you inquire about...?",
	"...What do you need?",
	"...Regarding...?",
}

AI.StoryMessages = {
	"[$910]"
}

function IntroDialog(user)

    user:SetObjVar("Intro|Vivia The Witch",true)
    text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
    user:SetObjVar("OpenedDialog|Vivia The Witch",true)

    response = {}

    response[1] = {}
    response[1].text = "Who are you exactly?"
    response[1].handle = "Who" 

    response[2] = {}
    response[2].text = "Where am I?"
    response[2].handle = "Celador"

    response[3] = {}
    response[3].text = "Goodbye."
    response[3].handle = "" 

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenHelpDialog(user)	

	text = AI.AskHelpMessages[math.random(1,#AI.AskHelpMessages)]
	
	response = {}

	response[1] = {}
	response[1].text = "I want to learn witchcraft."
	response[1].handle = "Train" 


	response[4] = {}
	response[4].text = "Nevermind."
	response[4].handle = "Nevermind" 

	NPCInteraction(text,this,user,"Responses",response)

end

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
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenWhatDialog(user)
    --DebugMessage("WhatDialog")
    text = AI.WhatMessages[math.random(1,#AI.WhatMessages)]

    response = {}

    response[1] = {}
    response[1].text = "...This forest?"
    response[1].handle = "Forest" 

    response[2] = {}
    response[2].text = "...Magic, the gods, the Imprisoning??"
    response[2].handle = "Magic" 

    response[3] = {}
    response[3].text = "...Being a witch?"
    response[3].handle = "How"

    response[4] = {}
    response[4].text = "...What do you believe?"
    response[4].handle = "Believe"

    response[5] = {}
    response[5].text = "...My own origins?"
    response[5].handle = "Origins"

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
    response[2].text = "Why are you a witch?"
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
    DialogReturnMessage(this,user,"[$911]","Right.")
end
function Dialog.OpenCeladorDialog(user)
	DialogReturnMessage(this,user,"[$912]","Right.")
end
Dialog.OpenWhereDialog = Dialog.OpenCeladorDialog
function Dialog.OpenForestDialog(user)
	DialogReturnMessage(this,user,"[$913]","Uh... right.")
end
function Dialog.OpenMagicDialog(user)
	DialogReturnMessage(this,user,"[$914]","OK.")
end
function Dialog.OpenBelieveDialog(user)
	DialogReturnMessage(this,user,"[$915]","Interesting.")
end
function Dialog.OpenOriginsDialog(user)
    DialogReturnMessage(this,user,"[$916]","Oh.")
end
function Dialog.OpenFamilyDialog(user)
	DialogEndMessage(this,user,AI.FamilyMessage[math.random(1,#AI.FamilyMessage)],"Oh... Sorry.")
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
	DialogReturnMessage(this,user,"[$917]","Oh.")
end
