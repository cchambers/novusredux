require 'base_ai_npc'

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = true
AI.Settings.SetIntroObjVar = false
AI.Settings.EnableBuy = true
AI.Settings.StationedLeash = true
AI.Settings.EnableRepair = true

fixPrice = 20

function GetArmorTaskPouch(user)
    local backpackObj = user:GetEquippedObject("Backpack")
    local pouchItem = FindItemInContainerRecursive(backpackObj,
            function(item)            
                return item:HasObjVar("ArmorPouch")
            end)

    return pouchItem
end

function CreateArmorTaskPouch(user)
    local createId = uuid()
    CreateObjInBackpack(user,"pouch",createId)  
    RegisterSingleEventHandler(EventType.CreatedObject,createId,
            function (success,objRef)
                objRef:SetObjVar("ArmorPouch",true)
                objRef:SetObjVar("Worthless",true)
                objRef:SetName("Robert's Armor Pouch")
            end)

    user:SystemMessage("You have received Robert's Armor Pouch","event")
end

NPCTasks = {
    --[[FabricTailorTask = {
        TaskName = "FabricTailorTask",
        TaskDisplayName = "Fabric for Robert",
        Description = "Collect 4 bolts of silk",
        FinishDescription = "Go back and talk to Robert",
        RewardType = "recipe",
        RecipeMaxSkill = 59,
        RecipeSkill = "FabricationSkill",
        Repeatable = true, --if you can redo the task
        Importance = 1, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$1444]",
        TaskAcceptSpeech = "[$1445]",
        TaskCurrentSpeech = "Any luck so far on aquiring Bolts of Silk?",
        TaskContinueSpeech = "[$1446]",
        TaskCancelSpeech = "[$1447]",
        TaskHelpSpeech = "[$1448]",
        TaskPreCompleteSpeech = "[$1449]",
        TaskFinishedMessage = "[$1450]",
        TaskIncompleteMessage = "[$1451]",
        TaskAssists = {
                      {Template = "cel_village_beatrix",Text = "[$1452]"},
                     },
        CheckCompletionCallback = "Items",
        CompletionCallback = "Items",
        TaskItemList = {{"resource_silk_fabric",4}},
        Faction = "Villagers",
        FactionOnFinish = 1,
    },
    RecoverArmorTask = {
        TaskName = "RecoverArmorTask",
        TaskDisplayName = "Recovering Armor",
        RewardType = "recipe",
        Description = "[$1453]",
        FinishDescription = "Go back and talk to Robert",
        RewardType = "recipe",
        RecipeMinSkill = 60,
        RecipeMaxSkill = 100,        
        RecipeSkill = "FabricationSkill",
        TaskMinimumFaction = 10,
        Repeatable = true, --if you can redo the task
        Importance = 1, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$1454]",
        TaskAcceptSpeech = "[$1455]",
        TaskCurrentSpeech = "[$1456]",
        TaskContinueSpeech = "[$1457]",
        TaskCancelSpeech = "[$1458]",
        TaskHelpSpeech = "[$1459]",
        TaskPreCompleteSpeech = "[$1460]",
        TaskFinishedMessage = "[$1461]",
        TaskIncompleteMessage = "[$1462]",
        TaskAssists = {
                      {Template = "cel_village_beatrix",Text = "[$1463]"},
                      },
        AcceptTaskCallback = function(user,task)
            -- if you already have one, dont give him another one
            if(GetArmorTaskPouch(user)) then return end

            CreateArmorTaskPouch(user)
        end,
        CheckCompletionCallback = function (user,task,openedDialog)            
            local pouchObj = GetArmorTaskPouch(user)
            if not(pouchObj)  then 
                if (openedDialog) then 
                    CreateArmorTaskPouch(user)
                end
                return false
            end

            local armorItems = FindItemsInContainerRecursive(pouchObj,
                    function(item) 
                        local armorClass = item:GetObjVar("ArmorClass")
                        --DebugMessage("Checking item ",item:GetName())
                        --DebugMessage(armorClass == "Light",armorClass == "VeryLight"," AND ",item:GetObjVar("MaxDurability") or 0,(item:GetObjVar("MaxDurability") or 0) >= 20)
                        --DebugMessage("Returning "..tostring((armorClass == "Light" or armorClass == "VeryLight") and (item:GetObjVar("MaxDurability") or 0) >= 20))
                        return (armorClass == "Light" or armorClass == "VeryLight") and (item:GetObjVar("MaxDurability") or 0) >= 20
                    end)

            return #armorItems >= 5
        end,
        CompletionCallback = function (user,task)
            local pouchObj = GetArmorTaskPouch(user)
            if not(pouchObj) then 
                return false
            end

            local armorItems = FindItemsInContainerRecursive(pouchObj,
                    function(item) 
                        local armorClass = item:GetObjVar("ArmorClass")
                       --DebugMessage("FINSHC CHECK for item ",item:GetName())
                        --DebugMessage(armorClass == "Light",armorClass == "VeryLight"," AND ",item:GetObjVar("MaxDurability") or 0,(item:GetObjVar("MaxDurability") or 0) >= 20)
                        --DebugMessage("Returning "..tostring((armorClass == "Light" or armorClass == "VeryLight") and (item:GetObjVar("MaxDurability") or 0) >= 20))
                        return (armorClass == "Light" or armorClass == "VeryLight") and (item:GetObjVar("MaxDurability") or 0) >= 20
                    end)

            if(#armorItems >= 5) then
                --DebugMessage("Task works.")
                pouchObj:Destroy()
                DoTaskFinish(user,task)
                return true
            end
            return false
        end,
        Faction = "Villagers",
        FactionOnFinish = 1,
    },       ]]
}

--AI.QuestList = {"TailorIntroQuest_V2"}
AI.Settings.KnowName = false 
--AI.Settings.HasQuest = true
--AI.QuestMessages = {"Ah! Another one.","Come talk to me, you'll learn much!"}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$1464]"
} 

AI.GreetingMessages = 
{
	"[$1465]",
    "Ah, hello again! Care to look at my wares?",
    "[$1466]"
}

AI.CantAffordPurchaseMessages = {
	"[$1467]",
    "[$1468]",
    "[$1469]",
}

AI.AskHelpMessages =
{
	"What can this humble merchant assist you with?",
}

AI.RefuseTrainMessage = {
	"[$1470]",
}

AI.WellTrainedMessage = {
	"[$1471]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"[$1472]",
}

AI.NevermindMessages = 
{
    "[$1473]",
}

AI.TalkMessages = 
{
	"Well sure, what would you like to know, good sir?",
}

AI.WhoMessages = {
	"[$1474]",
}

AI.PersonalQuestion = {
	"Well sure, go ahead and ask.",
}

AI.HowMessages = {
	"[$1475]",
}

AI.FamilyMessage = AI.HowMessages

AI.SpareTimeMessages= {
	"[$1476]",
}

AI.WhatMessages = {
	"Well, what would you like to know?",
}

AI.StoryMessages = {
	"[$1477]"
}  

--[[function IntroDialog(user)

    if (user:HasObjVar("OpenedDialog|John the Carpenter")) then
        text = "[$1478]"
    else
        text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
    end
    user:SetObjVar("OpenedDialog|John the Carpenter",true)

    response = {}

    response[1] = {}
    response[1].text = "Show me how to work cloth."
    response[1].handle = "StartIntroQuest" 

    response[2] = {}
    response[2].text = "Nah, I'm good."
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

function Dialog.OpenTailorIntroQuest_V2TalkToRobertAgainDialog(user)
    --DFB TODO: change this to $1479
    QuickDialogMessage(this,user,"[$1479]")
    user:SetObjVar("RobertFinished",true)
    local ProfessionQuestsComplete = user:GetObjVar("ProfessionQuestsComplete") or 0
    user:SetObjVar("ProfessionQuestsComplete",ProfessionQuestsComplete + 1)
end

function Dialog.OpenTailorIntroQuest_V2TalkToRobertTwiceDialog(user)
    --DFB TODO: Change this to $1480
    QuickDialogMessage(this,user,"Ah, perfection! Now take these [ECD905]Bolts of Fabric[-] and begin crafting a shirt.")
    user:SetObjVar("RobertFinished",true)
end

function Dialog.OpenTailorIntroQuest_V2CraftATShirtDialog(user) 
    --Dfb TODO: Change this to $1481
    QuickDialogMessage(this,user,"Ah, perfection! Now take these [ECD905]Bolts of Fabric[-] and begin crafting a shirt.")
end

function Dialog.OpenStartIntroQuestDialog(user)
    --DFB TODO: Change this to $1482
    QuickDialogMessage(this,user,"Well good then, here's what you can do. Take these [ECD905]Bolts of Fabric[-], and begin crafting a shirt.")
    user:SendMessage("StartQuest","TailorIntroQuest_V2")
    user:SetObjVar("Intro|Robert the Tailor",true)
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
    response[1].text = "...The events in Celador?"
    response[1].handle = "Events" 

    response[2] = {}
    response[2].text = "...Your business?"
    response[2].handle = "Business" 

    response[3] = {}
    response[3].text = "...The plight of the people?"
    response[3].handle = "People"

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "What is your story, exactly?"
    response[1].handle = "Story" 

    response[2] = {}
    response[2].text = "How did you become a tailor?"
    response[2].handle = "How" 

    response[3] = {}
    response[3].text = "Might I ask you a personal question?"
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
    response[3].text = "What do you do in your spare time?"
    response[3].handle = "SpareTime"

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)

end

function Dialog.OpenCeladorDialog(user)
	DialogReturnMessage(this,user,"[$1483]","Right.")
end
Dialog.OpenWhereDialog = Dialog.OpenCeladorDialog
function Dialog.OpenEventsDialog(user)
	DialogReturnMessage(this,user,"[$1484]","Alright then.")
end
function Dialog.OpenBusinessDialog(user)
    DialogReturnMessage(this,user,"[$1485]","Right.")
end
function Dialog.OpenPeopleDialog(user)
	DialogReturnMessage(this,user,"[$1486]","Right.")
end
function Dialog.OpenFamilyDialog(user)
	DialogReturnMessage(this,user,"[$1487]","Oh..")
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
    DialogReturnMessage(this,user,"[$1488]","Wow.")
end

OverrideEventHandler("base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)

