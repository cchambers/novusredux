require 'base_ai_npc'

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = true
AI.Settings.EnableBuy = true
AI.Settings.SetIntroObjVar = false
fixPrice = 20

--AI.QuestList = {"MageIntroQuest"}
--AI.Settings.HasQuest = true
--AI.QuestMessages = {", do you seek knowledge of magic?",", I know things that might be of interest to you."}

NPCTasks = {
    --[[MagicEssenseTask = {
        TaskName = "MagicEssenseTask",
        TaskDisplayName = "The Essense of Magic",
        Description = "Collect 7 bottles of Magic Essence",
        FinishDescription = "Go back and talk to the Alchemist",
        RewardType = "recipe",
        RecipeMaxSkill = 59,
        RecipeSkill = "AlchemySkill",
        Repeatable = true, --if you can redo the task
        Importance = 2, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$91]",
        TaskAcceptSpeech = "[$92]",
        TaskCurrentSpeech = "How goes the search for magic essence?",
        TaskContinueSpeech = "[$93]",
        TaskCancelSpeech = "[$94]",
        TaskHelpSpeech = "[$95]",
        TaskPreCompleteSpeech = "[$96]",
        TaskFinishedMessage = "[$97]",
        TaskIncompleteMessage = "[$98]",
        TaskAssists = {
                      {Template = "cel_village_beatrix",Text = "[$99]"},
                      {Template = "cel_rothchilde",Text = "[$100]"},
                      {Template = "cel_mayor",Text = "[$101]"},
                      },
        CheckCompletionCallback = "Items",
        CompletionCallback = "Items",
        TaskItemList = {
            {"resource_essence",7},
        },
        Faction = "Villagers",
        FactionOnFinish = 3,
    },--]]
    --[[
    LostScrollsTasks = {
        TaskName = "LostScrollsTasks",
        TaskDisplayName = "The Lost Scrolls",
        RewardType = "animalparts_demon_blood",
        TaskMinimumFaction = 10,
        RewardAmount = 1,
        Repeatable = true, --if you can redo the task
        Importance = 1, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$102]",
        TaskAcceptSpeech = "[$103]",
        TaskCurrentSpeech = "Have you found the scrolls that I seek?",
        TaskContinueSpeech = "[$104]",
        TaskCancelSpeech = "[$105]",
        TaskHelpSpeech = "[$106]",
        TaskPreCompleteSpeech = "[$107]",
        TaskFinishedMessage = "[$108]",
        TaskIncompleteMessage = "[$109]",
        TaskAssists = {
                      {Template = "cel_village_beatrix",Text = "[$110]"},
                      {Template = "cel_rothchilde",Text = "[$111]"},
                      {Template = "cel_mayor",Text = "[$112]"},
                      },
        CheckCompletionCallback = "Items",
        CompletionCallback = "Items",
        TaskItemList = {
            {"ingredient_arcane_scroll",3},
        },
        Faction = "Villagers",
        FactionOnFinish = 2,
    },
    --]]
}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$113]",
    "[$114]"
} 

AI.TradeMessages = 
{
	"[$115]",
	"[$116]",
	"[$117]",
	"[$118]",
}

AI.GreetingMessages = 
{
	"[$119]",
	"[$120]",
	"Welcome, welcome. Can I interest you in something?",
}

AI.HowToPurchaseMessages = {
	"[$121]"
}

AI.NotInterestedMessage = 
{
	"I'm not interested in that sort of thing, sorry.",
	"I don't want that, thank you.",
    "I'm definitely not interested in that.",
	"I'm not looking to buy that, sorry.",
}

AI.NotYoursMessage = {
	"I'm not about to buy something that isn't yours.",
	"That's not yours, are you playing games with me?.",
	"Even if that was yours I wouldn't buy it.",
}

AI.CantAffordPurchaseMessages = {
	"That's not enough to cover costs I'm afraid.",
	"[$122]",
	"[$123]",
}

AI.CantAffordTrainPurchaseMessages = {
    "[$1724]"
}

AI.AskHelpMessages =
{
	"I can assist you with that, what would you need?",
	"[$124]",
	"What would you need then?",
}

AI.RefuseTrainMessage = {
	"[$125]",
	"[$126]",
}

AI.WellTrainedMessage = {
	"[$127]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"[$128]",
	"[$129]",
	"[$130]",
}

AI.NevermindMessages = 
{
    "Anything else I can assist you with...?",
    "Anything else this mage can help you with...?",
    "What else would you desire?",
}

AI.TalkMessages = 
{
	"[$131]",
	"Ask, but know that there is always more to know!",
}

AI.WhoMessages = {
	"[$132]",
}

AI.PersonalQuestion = {
	"If you so wish. What is your question?",
    "[$133]",
    "I have much to divulge. Even about myself."
}

AI.HowMessages = {
	"[$134]",
}

AI.FamilyMessage = {
	"[$135]",
	}

AI.SpareTimeMessages= {
	"[$136]",
}

AI.WhatMessages = {
	"...Regarding...?",
	"...Regarding what?",
	"...Regarding...?",
}

AI.StoryMessages = {
	"[$137]"
}

--[[function IntroDialog(user)
    if (user:HasObjVar("Intro|Legas the Sorcerer")) then
        user:SetObjVar("Intro|Nicodemus the Alchemist",true) 
        QuickDialogMessage(this,user,"[$138]")
        return
    end

    if (user:HasObjVar("OpenedDialog|Nicodemus the Alchemist")) then
        text = "[$139]"
    else
        text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
    end
    user:SetObjVar("OpenedDialog|Nicodemus the Alchemist",true)

    response = {}

    response[1] = {}
    response[1].text = "I'm interested."
    response[1].handle = "StartMagicQuest" 

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

function Dialog.OpenStartMagicQuestDialog(user)
    user:SendMessage("StartQuest","MageIntroQuest","FindTheMagicGuy")
    
    QuickDialogMessage(this,user,"[$140]")
    user:SetObjVar("Intro|Nicodemus the Alchemist",true)

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
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

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
    response[2].text = "...The gods?"
    response[2].handle = "TheGods" 

    response[3] = {}
    response[3].text = "...The art of making potions?"
    response[3].handle = "Potions"

    response[4] = {}
    response[4].text = "...Magic?"
    response[4].handle = "Magic" 

    response[5] = {}
    response[5].text = "...Why your wife is so cross?"
    response[5].handle = "Beatrix" 

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
    response[2].text = "Why are you a mage?"
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
    DialogReturnMessage(this,user,"[$141]","Right.")
end
function Dialog.OpenCeladorDialog(user)
	DialogReturnMessage(this,user,"[$142]","Right.")
end
Dialog.OpenWhereDialog = Dialog.OpenCeladorDialog

function Dialog.OpenImprisoningDialog(user)
	DialogReturnMessage(this,user,"[$143]","Interesting. Thank you.")
end
function Dialog.OpenTheGodsDialog(user)
	DialogReturnMessage(this,user,"[$144]","Huh. Interesting.")
end
function Dialog.OpenPotionsDialog(user)
	DialogReturnMessage(this,user,"[$145]","Interesting. Thanks.")
end
function Dialog.OpenMagicDialog(user)
    DialogReturnMessage(this,user,"[$146]","Right.")
end
function Dialog.OpenBeatrixDialog(user)
    DialogReturnMessage(this,user,"[$147]","...Oh. Sorry")
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
	DialogReturnMessage(this,user,"[$148]","...Uh. Right.")
end

OverrideEventHandler("base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)
