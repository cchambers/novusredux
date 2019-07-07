require 'base_ai_npc'

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = true
AI.Settings.SetIntroObjVar = false
AI.Settings.EnableBuy = true
AI.Settings.StationedLeash = true
AI.Settings.EnableRepair = false

fixPrice = 20

--AI.QuestList = {"WoodsmithIntroQuest_V2"}
AI.Settings.KnowName = false 
--AI.Settings.HasQuest = true
--AI.QuestMessages = {"Newcomer! Come here!","You there, come talk to me!"}

NPCTasks = {
--[[
    CarpenterBoardTask = {
        TaskName = "CarpenterBoardTask",
        TaskDisplayName = "Wood Boards",
        Description = "Collect 16 wooden boards",
        FinishDescription = "Go back and talk to Issac the Carpenter",
        RewardType = "recipe",
        RecipeMaxSkill = 61,
        RecipeSkill = "WoodsmithSkill",
        Repeatable = true, --if you can redo the task
        Importance = 1, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$433]",
        TaskAcceptSpeech = "[$434]",
        TaskCurrentSpeech = "Any luck so far on aquiring wood boards?",
        TaskContinueSpeech = "[$435]",
        TaskCancelSpeech = "[$436]",
        TaskHelpSpeech = "[$437]",
        TaskPreCompleteSpeech = "[$438]",
        TaskFinishedMessage = "[$439]",
        TaskIncompleteMessage = "[$440]",
        TaskAssists = {
                      {Template = "cel_rothchilde",Text = "[$441]"},
                      {Template = "cel_village_beatrix",Text = "[$442]"},
                     },
        CheckCompletionCallback = "Items",
        CompletionCallback = "Items",
        TaskItemList = {{"resource_boards",16}},
        Faction = "Villagers",
        FactionOnFinish = 1,
    },
    BuildWellTask = {
        TaskName = "BuildWellTask",
        TaskDisplayName = "Construct a Well",
        RewardType = "recipe",
        Description = "Contstruct a well",
        FinishDescription = "Go back and talk to Issac the Carpenter",
        TaskMinimumFaction = 10,
        RewardType = "recipe",
        RecipeMinSkill = 62,
        RecipeMaxSkill = 100,        
        RecipeSkill = "WoodsmithSkill",
        Repeatable = true, --if you can redo the task
        Importance = 1, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$443]",
        TaskAcceptSpeech = "[$444]",
        TaskCurrentSpeech = "How is that well coming along?",
        TaskContinueSpeech = "[$445]",
        TaskCancelSpeech = "[$446]",
        TaskHelpSpeech = "[$447]",
        TaskPreCompleteSpeech = "[$448]",
        TaskFinishedMessage = "[$449]",
        TaskIncompleteMessage = "[$450]",
        TaskAssists = {
                      {Template = "cel_village_beatrix",Text = "[$451]"},
                      },
        CheckCompletionCallback = function (user,task)            
            local backpackObj = user:GetEquippedObject("Backpack")
            local wellItem = FindItemInContainerRecursive(backpackObj,
                    function(item)            
                        return item:GetObjVar("UnpackedTemplate") == "well"
                    end)

            return wellItem ~= nil
        end,
        CompletionCallback = function (user,task)
            local backpackObj = user:GetEquippedObject("Backpack")
            local wellItem = FindItemInContainerRecursive(backpackObj,
                    function(item)            
                        return item:GetObjVar("UnpackedTemplate") == "well"
                    end)

            if(wellItem ~= nil) then
                wellItem:Destroy()
                DoTaskFinish(user,task)
                return true
            end
            return false
        end,
        Faction = "Villagers",
        FactionOnFinish = 1,
    },   
    --]]
}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$452]"
} 

AI.GreetingMessages = 
{
	"Hello there, son. What can I do for you?",
    "[$453]"
}

AI.CantAffordPurchaseMessages = {
	"I'm sorry, but I have to afford a living myself.",
}

AI.AskHelpMessages =
{
	"[$454]",
    "Everything is well, I hope?",
}

AI.RefuseTrainMessage = {
	"That is quite alright, son. Anything else?",
}

AI.WellTrainedMessage = {
	"[$455]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.CantAffordTrainPurchaseMessages = {
    "[$1724]"
}

AI.TrainScopeMessages = {
	"[$456]",
}

AI.NevermindMessages = 
{
    "Anything else I can help you with?",
}

AI.TalkMessages = 
{
	"Well of course. Ask me anything.",
}

AI.WhoMessages = {
	"[$457]",
}

AI.PersonalQuestion = {
	"Why... What is the question?",
}

AI.HowMessages = {
	"[$458]",
}

AI.FamilyMessage = AI.HowMessages

AI.SpareTimeMessages= {
	"[$459]",
}

AI.WhatMessages = {
	"...Regarding what my son...?",
}

AI.StoryMessages = {
	"[$460]"
}  

--[[function IntroDialog(user)

    if (user:HasObjVar("OpenedDialog|John the Carpenter")) then
        text = "[$461]"
    else
        text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
    end
    user:SetObjVar("OpenedDialog|John the Carpenter",true)

    response = {}

    response[1] = {}
    response[1].text = "Yes, teach me carpentry."
    response[1].handle = "StartIntroQuest" 

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

function Dialog.OpenWoodsmithIntroQuest_V2LearnRecipeDialog(user)
    --DFB TODO: Change this to $462
    QuickDialogMessage(this,user,"Good. Good. Now for your first lesson. First, you will want to learn how to use a saw, but you're a natural at that aren't you?\n\nJust go ahead and use that table over there.")
end

function Dialog.OpenWoodsmithIntroQuest_V2CraftWoodBoardsDialog(user)
    --DFB TODO: Change this to $463
    QuickDialogMessage(this,user,"[$463]")
end

function Dialog.OpenWoodsmithIntroQuest_V2TalkToJohnTwiceDialog(user)
    --DFB TODO: Change this to $464
    QuickDialogMessage(this,user,"[$464]")
    user:SetObjVar("JohnFinished",true)
end

function Dialog.OpenWoodsmithIntroQuest_V2CraftChairDialog(user)
    --DFB TODO: Change this to $465
    QuickDialogMessage(this,user,"[$465]")
end

function Dialog.OpenWoodsmithIntroQuest_V2TalkToJohnAgainDialog(user)
    --DFB TODO: Change this to $466
    QuickDialogMessage(this,user,"Well, look what you have here. Quite the accomplishment, I must say. \n\nYou're one of the few people who can make things out of nothing but simple wood, so if anything I'd say you're on the way to becoming quite the carpenter.\n\nHere, take this book, it should tell you a few things about woodsmithing.")
    user:SetObjVar("JohnFinished",true)
    local ProfessionQuestsComplete = user:GetObjVar("ProfessionQuestsComplete") or 0
    user:SetObjVar("ProfessionQuestsComplete",ProfessionQuestsComplete + 1)
end

function Dialog.OpenStartIntroQuestDialog(user)
    --DFB TODO: Change this to $467
    QuickDialogMessage(this,user,"Good. Good. Now for your first lesson. First, you will want to learn how to use a saw, but you're a natural at that aren't you?\n\nJust go ahead and use that table over there.")
    user:SendMessage("StartQuest","WoodsmithIntroQuest_V2")
    user:SetObjVar("Intro|John the Carpenter",true)
    user:SetObjVar("Intro|Issac the Carpenter",true)
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
    response[1].text = "...About the Gods?"
    response[1].handle = "Gods" 

    response[2] = {}
    response[2].text = "...Regarding woodworking?"
    response[2].handle = "Woodworking" 

    response[3] = {}
    response[3].text = "...The Imprisoning?"
    response[3].handle = "Imprisoning"

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "What's your story?"
    response[1].handle = "Story" 

    response[2] = {}
    response[2].text = "How did you become a carpenter?"
    response[2].handle = "How" 

    response[3] = {}
    response[3].text = "...Can I ask you a personal question?"
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
    response[2].text = "What is your last name?"
    response[2].handle = "LastName" 

    response[3] = {}
    response[3].text = "What do you do with your spare time?"
    response[3].handle = "SpareTime"

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)

end

function Dialog.OpenCeladorDialog(user)
	DialogReturnMessage(this,user,"[$468]","Right.")
end
Dialog.OpenWhereDialog = Dialog.OpenCeladorDialog
function Dialog.OpenGodsDialog(user)
	DialogReturnMessage(this,user,"[$469]","Oh, ok.")
end
function Dialog.OpenWoodworkingDialog(user)
    DialogReturnMessage(this,user,"[$470]","Right.")
end
function Dialog.OpenImprisoningDialog(user)
	DialogReturnMessage(this,user,"[$471]","Right.")
end
function Dialog.OpenFamilyDialog(user)
	DialogReturnMessage(this,user,AI.StoryMessages[math.random(1,#AI.StoryMessages)],"Oh..")
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
    DialogReturnMessage(this,user,"","Oh.")
end

OverrideEventHandler("base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)

