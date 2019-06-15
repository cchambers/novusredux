require 'base_ai_npc'

--[[NPCTasks = {
    GettingWoodTask = {
        TaskName = "GettingWoodTask",
        TaskDisplayName = "The Art of Lumberjacking",
        RewardType = "treasure_map",
        Description = "Find 10 Blightwood.",
        FinishDescription = "Bring the wood back to the lumberjack.",
        RewardAmount = 1,
        Repeatable = true, --if you can redo the task
        Importance = 1, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$824]",
        TaskAcceptSpeech = "[$825]",
        TaskCurrentSpeech = "Do you have the timber I requested?",
        TaskContinueSpeech = "[$826]",
        TaskCancelSpeech = "Whatever. I'll light my fireplace myself.",
        TaskHelpSpeech = "[$827]",
        TaskPreCompleteSpeech = "[$828]",
        TaskFinishedMessage = "[$829]",
        TaskIncompleteMessage = "[$830]",
        TaskAssists = {
                      {Template = "cel_guard_rufus",Text = "[$831]"},
                      },
        CheckCompletionCallback = "Items",
        CompletionCallback = "Items",
        TaskItemList = {
            {"resource_blightwood",10},
        },
    },
    AnimalMeatTask = {
        TaskName = "AnimalMeatTask",
        TaskDisplayName = "Surviving in the Wild",
        RewardType = "skill_lumberjack",
        Description = "Find 5 Leather Hides.",
        FinishDescription = "Bring the hide back to Ron the Lumberjack.",
        RewardAmount = 1,
        Repeatable = true, --if you can redo the task
        Importance = 1, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$832]",
        TaskAcceptSpeech = "[$833]",
        TaskCurrentSpeech = "How goes the hunt, get any leather hides yet?",
        TaskContinueSpeech = "Deer and rabbit make for some pretty good hides.",
        TaskCancelSpeech = "[$834]",
        TaskHelpSpeech = "[$835]",
        TaskPreCompleteSpeech = "[$836]",
        TaskFinishedMessage = "[$837]",
        TaskIncompleteMessage = "[$838]",
        TaskAssists = {
                      {Template = "cel_forest_witch",Text = "[$839]"},
                      {Template = "cel_merchant_general_store",Text = "[$840]"},
                      },
        CheckCompletionCallback = "Items",
        CompletionCallback = "Items",
        TaskItemList = {
            {"animalparts_leather_hide",5},
        },
    },
}--]]

function HasExplorationQuestNote(user)
    local backpack = user:GetEquippedObject("Backpack")
    if (backpack == nil) then return false end
    local NoteObject = FindItemInContainerRecursive(backpack,function (item)
        return item:HasObjVar("RonContactNote")
    end)
    if (NoteObject ~= nil) then return true end
end

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = false
AI.Settings.EnableBuy = true
AI.Settings.StationedLeash = true
fixPrice = 20

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$841]"

} 

AI.TradeMessages = 
{
	"Well, what would you like to trade for?",
}

AI.GreetingMessages = 
{
	"[$842]",
	"[$843]",
	"[$844]",
}

AI.NotInterestedMessage = 
{
	"I'm not interested in that.",
	"That's worthless. I don't want that.",
	"I'm not interested in that, to be honest.",
	"Eh, I don't want that.",
}

AI.NotYoursMessage = {
	"[$845]",
	"[$846]",
	"[$847]",
}

AI.CantAffordPurchaseMessages = {
	"You don't have enough money to buy that.",
}

AI.AskHelpMessages =
{
	"[$848]",
	"It depends on what you need. I'm willing to help.",
	"I think I can help you out. What do you need?",
	"Well sure, what can I assist you with?",
}

AI.RefuseTrainMessage = {
	"Alright, suit yourself.",
	"That's quite alright, I'm not going anywhere soon.",
}

AI.WellTrainedMessage = {
	"[$849]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"[$850]",
	"[$851]",
	"[$852]",
}

AI.NevermindMessages = 
{
    "Anything else I can do for you?",
    "Anything else?",
    "Is there anything else I can do for ya?",
}

AI.TalkMessages = 
{
	"Well sure, I don't get too many vistors.",
	"I'll tell you a few things, sure!",
	"Well go right ahead and ask, I'm all ears!.",
	"Well, feel free to ask, I'm all ears!",
}

AI.WhoMessages = {
	"[$853]",
	"[$854]",
}

AI.PersonalQuestion = {
	"Well... yes... what is it you like to know?",
    "Eh, I suppose, what would you want to know?",
    "[$855]"
}

AI.HowMessages = {
	"[$856]",
}

AI.FamilyMessage = {
	"[$857]",
}

AI.SpareTimeMessages= {
	"[$858]",
}

AI.WhatMessages = {
	"...Well yes, what about...?",
	"...About...?",
	"...What about?",
	"...Regarding...?",
}

AI.StoryMessages = {
	"[$859]"
}

function Dialog.OpenForestIntroQuestTalkToRonDialog(user)

    text = "[$860]"
    
    response = {}

    response[2] = {}
    response[2].text = "Worship the trees?"
    response[2].handle = "Trees" 

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)

end

function Dialog.OpenTreesDialog(user)
    --user:SendMessage("StartQuest","ForestQuest")

    text = "[$861]"
    
    response[1] = {}
    response[1].text = "I have a letter for you."
    response[1].handle = "Letter" 

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenHelpDialog(user)	

	text = AI.AskHelpMessages[math.random(1,#AI.AskHelpMessages)]
	
	response = {}

	response[1] = {}
	response[1].text = "I want to learn lumberjacking."
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
    response[2].text = "...The subject of magic?"
    response[2].handle = "Magic" 

    response[3] = {}
    response[3].text = "...Being a lumberjack?"
    response[3].handle = "Lumberjack"

    response[4] = {}
    response[4].text = "...The Imprisoning?"
    response[4].handle = "Imprisoning"

    response[5] = {}
    response[5].text = "...The Great Wall?"
    response[5].handle = "GreatWall"

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
    response[2].text = "Why are you a Lumberjack?"
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

function Dialog.OpenLetterDialog(user)
    local backpackObj = user:GetEquippedObject("Backpack")  
    QuickDialogMessage(this,user,"[$862]")
    noteContents = "[$863]"
    local NoteObject = FindItemInContainerRecursive(backpackObj,function (item)
        return item:HasObjVar("RonContactNote")
    end)
    if (NoteObject ~= nil) then NoteObject:Destroy() end
    CreateObjInBackpack(user,"scroll_readable","ContactNote","RonNote",noteContents) 
    user:SetObjVar("RonFinished",true)
end

function Dialog.OpenCantDialog(user)
    --DFB TODO: Make this dialog disappear and implement it based on a per-task basis!
    DialogReturnMessage(this,user,"[$864]","Right.")
end
function Dialog.OpenCeladorDialog(user)
	DialogReturnMessage(this,user,"[$865]","Right.")
end
Dialog.OpenWhereDialog = Dialog.OpenCeladorDialog
function Dialog.OpenForestDialog(user)
	DialogReturnMessage(this,user,"[$866]","Right.")
end
function Dialog.OpenMagicDialog(user)
	DialogReturnMessage(this,user,"[$867]","OK.")
end
function Dialog.OpenLumberjackDialog(user)
	DialogReturnMessage(this,user,"[$868]","Oh.")
end
function Dialog.OpenImprisoningDialog(user)
    DialogReturnMessage(this,user,"[$869]","Oh.")
end
function Dialog.OpenGreatWallDialog(user)
    DialogReturnMessage(this,user,"[$870]","Oh.")
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
	DialogReturnMessage(this,user,"[$871]","Oh.")
end
