require 'base_ai_npc'

AI.Settings.MerchantEnabled = false
AI.Settings.EnableTrain = false
AI.Settings.SetIntroObjVar = false
AI.Settings.StationedLeash = true

--[[
AI.QuestList = {"GraveyardIntroQuest","ForestIntroQuest","RuinsIntroQuest","DeadGateIntroQuest"}
AI.Settings.KnowName = false 
AI.Settings.HasQuest = true
AI.QuestMessages = {"Hey you. Come here.","You there, I need your help."}

fixPrice = 20

function HasExplorationQuestNote(user,noteObjVar)
    local backpack = user:GetEquippedObject("Backpack")
    if (backpack == nil) then return false end
    local NoteObject = FindItemInContainerRecursive(backpack,
    function (item)
        if (item:HasObjVar(noteObjVar)) then
            return true
        end    
    end)
    if (NoteObject ~= nil) then return true end
end
--]]

--[[NPCTasks = {
    KillBanditsTask = {
        TaskName = "KillBanditsTask",
        TaskDisplayName = "Bandit Slaughter",
        Description = "Slay 5 bandits and take their heads.",
        FinishDescription = "Bring them back to Rufus.",
        RewardType = "coins",
        RewardAmount = 750,
        Repeatable = true, --if you can redo the task
        Importance = 2, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$1331]",
        TaskAcceptSpeech = "[$1332]",
        TaskCurrentSpeech = "[$1333]",
        TaskContinueSpeech = "[$1334]",
        TaskCancelSpeech = "[$1335]",
        TaskHelpSpeech = "[$1336]",
        TaskPreCompleteSpeech = "[$1337]",
        TaskFinishedMessage = "[$1338]",
        TaskIncompleteMessage = "[$1339]",
        TaskAssists = {
                      {Template = "cel_village_beatrix",Text = "[$1340]"},
                      {Template = "cel_merchant_general_store",Text = "[$1341]"},
                      {Template = "cel_blacksmith",Text = "[$1342]"},
                      {Template = "cel_rothchilde",Text = "[$1343]"},
                    },
        TaskObjectQuantity = 5,
        CheckCompletionCallback = function (user,task)
            local backpackObj = user:GetEquippedObject("Backpack")
            if (backpackObj == nil) then return false end
            local items = FindItemsInContainerRecursive(backpackObj,function (item)
                if (item:HasObjVar("DeceasedMobileTeamType") and item:GetCreationTemplateId() == "human_head") then
                    return true
                end
            end)
            if (#items > task.TaskObjectQuantity) then return true end
            return false
        end,
        CompletionCallback = function (user,task)
            local backpackObj = user:GetEquippedObject("Backpack")
            if (backpackObj == nil) then return false end
            local items = FindItemsInContainerRecursive(backpackObj,function (item)
                if (item:HasObjVar("DeceasedMobileTeamType") and item:GetCreationTemplateId() == "human_head") then
                    return true
                end
            end)
            local count = 0
            for i,j in pairs(items) do 
                if (count < task.TaskObjectQuantity) then
                    count = count + 1
                    j:Destroy()
                end
            end
            DoTaskFinish(user,task)
            return false
        end,
        Faction = "Villagers",
        FactionOnFinish = 3,
    },
    KillOgreTask = {
        TaskName = "KillOgreTask",
        TaskDisplayName = "The Ogre",
        Description = "Find the Ogre and kill him.",
        FinishDescription = "Go back and talk to Rufus.",
        RewardType = "coins",
        RewardAmount = 1000,
        Repeatable = true, --if you can redo the task
        Importance = 4, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$1344]",
        TaskAcceptSpeech = "[$1345]",
        TaskCurrentSpeech = "What has been made of the ogre, is it dead?",
        TaskContinueSpeech = "[$1346]",
        TaskCancelSpeech = "[$1347]",
        TaskHelpSpeech = "[$1348]",
        TaskPreCompleteSpeech = "[$1349]",
        TaskFinishedMessage = "[$1350]",
        TaskIncompleteMessage = "[$1351]",
        TaskAssists = {
                      {Template = "cel_village_beatrix",Text = "[$1352]"},
                      {Template = "cel_mayor",Text = "[$1353]"},
                      {Template = "cel_blacksmith",Text = "[$1354]"},
                      {Template = "cel_rothchilde",Text = "[$1355]"},
                    },
        CheckCompletionCallback = "ObjVar",
        CompletionCallback = "ObjVar",
        TaskObjVarName = "KilledOgre",
        Faction = "Villagers",
        FactionOnFinish = 3,
    },
}--]]

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$1356]"
    .."[$1357]"
    .."[$1358]"
    .."[$1359]"
    .."[$1360]"
} 

AI.GreetingMessages = 
{
	"[$1361]",
	"[$1362]",
	"What can I assist you with, newcomer?",
}

AI.CantAffordPurchaseMessages = {
	"[$1363]",
	"I don't think you have enough for training.",
	"[$1364]",
}

AI.AskHelpMessages =
{
	"[$1365]",
	"[$1366]",
	"Anything that concerns the law...?",
	"[$1367]",
}

AI.RefuseTrainMessage = {
	"[$1368]",
	"[$1369]",
}

AI.WellTrainedMessage = {
	"[$1370]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"[$1371]",
	"[$1372]",
	"[$1373]",
    "[$1374]",
}

AI.NevermindMessages = 
{
    "Anything else that concerns me?",
    "Anything else?",
    "What else is going on?",
}

AI.TalkMessages = 
{
	"[$1375]",
	"I know a few things, why?",
	"What do you want to talk about?",
	"[$1376]",
}

AI.WhoMessages = {
	"[$1377]",
	"[$1378]",
}

AI.PersonalQuestion = {
	"[$1379]",
    "[$1380]",
}

AI.HowMessages = {
	"[$1381]",
}

AI.FamilyMessage = AI.HowMessages

AI.SpareTimeMessages= {
	"[$1382]",
}

AI.WhatMessages = {
	"...About what?",
	"...About...?",
	"...What about?",
	"...Regarding...?",
}

AI.StoryMessages = {
	"[$1383]"
}

function IntroDialog(user)

    if (user:HasObjVar("OpenedDialog|Rufus the Head Guard|")) then
        text = "Ah you again. Have you come to take up my offer?"
    else
        text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
    end
    user:SetObjVar("OpenedDialog|Rufus the Head Guard|",true)

    response = {}
--[[
    response[1] = {}
    response[1].text = "I'm interested."
    response[1].handle = "ExplorationQuest" 
--]]
    response[2] = {}
    response[2].text = "No, thank you."
    response[2].handle = "Nevermind"

    response[3] = {}
    response[3].text = "Goodbye."
    response[3].handle = "ResetIntro" 

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
    
end

function Dialog.OpenExplorationQuestsDialog(user)

    text = "[$1384]"

    user:SetObjVar("OpenedDialog|Rufus the Head Guard|",true)

    response = {}
--[[
    response[1] = {}
    response[1].text = "I'm interested."
    response[1].handle = "ExplorationQuest" 
    ]]--

    response[2] = {}
    response[2].text = "No, thank you."
    response[2].handle = "Nevermind"

    response[3] = {}
    response[3].text = "Goodbye."
    response[3].handle = "ResetIntro" 

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenGreetingDialog(user)
    if (not HasFinishedQuest(user,"RuinsIntroQuest") or
        not HasFinishedQuest(user,"GraveyardIntroQuest") or
        not HasFinishedQuest(user,"ForestIntroQuest") or
        not HasFinishedQuest(user,"DeadGateIntroQuest") ) then
        Dialog.OpenExplorationQuestsDialog(user)
        return
    end

    text = AI.GreetingMessages[math.random(1,#AI.GreetingMessages)]

    response = {}

    response[1] = {}
    response[1].text = "I want to know something..."
    response[1].handle = "Talk" 

    if (AI.GetSetting("MerchantEnabled") ~= nil and AI.GetSetting("MerchantEnabled") == true) then
        response[2] = {}
        response[2].text = "I want to trade..."
        response[2].handle = "Trade" 
    else
        response[2] = {}
        response[2].text = "Who are you?"
        response[2].handle = "Who" 
    end

    response[3] = {}
    response[3].text = "It's regarding work..."
    response[3].handle = "Work" 

    if (AI.GetSetting("EnableTrain") ~= nil and AI.GetSetting("EnableTrain") == true and CanTrain()) then
        response[5] = {}
        response[5].text = "Train me in a skill..."
        response[5].handle = "Train" 
    end

    response[6] = {}
    response[6].text = "Goodbye."
    response[6].handle = "" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
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
    response[4].text = "I need assistance regarding..."
    response[4].handle = "Assistance"

    response[5] = {}
    response[5].text = "Nevermind."
    response[5].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenAssistanceDialog(user)
    --DebugMessage("WhatDialog")
    text = AI.WhatMessages[math.random(1,#AI.WhatMessages)]

    response = {}

    response[1] = {}
    response[1].text = "...Reporting a crime!"
    response[1].handle = "ReportCrime" 

    response[2] = {}
    response[2].text = "...Fighting the cultists!"
    response[2].handle = "FightCultists" 

    response[3] = {}
    response[3].text = "...Capturing a bandit!"
    response[3].handle = "SubjectBandit"

    response[4] = {}
    response[4].text = "...Getting stolen merchandise back!"
    response[4].handle = "Stolen"

    response[5] = {}
    response[5].text = "...Regarding a robbery!"
    response[5].handle = "Robbery"

    response[6] = {}
    response[6].text = "Nevermind."
    response[6].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhatDialog(user)
    --DebugMessage("WhatDialog")
    text = AI.WhatMessages[math.random(1,#AI.WhatMessages)]

    response = {}

    response[1] = {}
    response[1].text = "...The cult?"
    response[1].handle = "Cult" 

    response[2] = {}
    response[2].text = "...The bandits?"
    response[2].handle = "Bandits" 

    response[3] = {}
    response[3].text = "...The people here?"
    response[3].handle = "People"

    response[4] = {}
    response[4].text = "...The laws here?"
    response[4].handle = "Law"

    if (user:HasObjVar("RufusAboutBob")) then
        response[5] = {}
        response[5].text = "...your brother???"
        response[5].handle = "Bob"
    else
        response[5] = {}
        response[5].text = "...The crime?"
        response[5].handle = "Crime"
    end

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
    response[2].text = "Why are you a guard?"
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

function Dialog.OpenExplorationQuestDialog(user)
    --should be four, with this dialog as well, ""
    text = "[$1385]"

    response = {}

    if (not HasFinishedQuest(user,"GraveyardIntroQuest")) then
        response[1] = {}
        response[1].text = "I'll check up on Mason."
        response[1].handle = "Mason" 
    end

    if (not HasFinishedQuest(user,"ForestIntroQuest")) then
        response[2] = {}
        response[2].text = "I'll check up on Ron."
        response[2].handle = "Ron" 
    end

    if (not HasFinishedQuest(user,"DeadGateIntroQuest")) then
        response[3] = {}
        response[3].text = "I'll check up on Aegis."
        response[3].handle = "Aegis"
    end

    if (not HasFinishedQuest(user,"RuinsIntroQuest")) then
        response[4] = {}
        response[4].text = "I'll check up on Thomas."
        response[4].handle = "Thomas"
    end

    response[5] = {}
    response[5].text = "Nevermind."
    response[5].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenMasonDialog(user)
    user:SetObjVar("Intro|Rufus the Head Guard",true)
    QuickDialogMessage(this,user,"[$1386]")
    user:SendMessage("StartQuest","GraveyardIntroQuest")
    noteContents = "[$1387]"
    CreateObjInBackpack(user,"scroll_readable","ContactNote","MasonContactNote",noteContents) 
    --DFB TODO: Create the note object, change willie dialog
end

function Dialog.OpenRonDialog(user)
    user:SetObjVar("Intro|Rufus the Head Guard",true)
    QuickDialogMessage(this,user,"[$1388]")
    user:SendMessage("StartQuest","ForestIntroQuest")
    noteContents = "[$1389]"
    CreateObjInBackpack(user,"scroll_readable","ContactNote","RonContactNote",noteContents) 
end

function Dialog.OpenAegisDialog(user)
    user:SetObjVar("Intro|Rufus the Head Guard",true)
    QuickDialogMessage(this,user,"[$1390]")
    user:SendMessage("StartQuest","DeadGateIntroQuest")
    noteContents = "[$1391]"
    CreateObjInBackpack(user,"scroll_readable","ContactNote","AegisContactNote",noteContents) 
end

function Dialog.OpenThomasDialog(user)
    user:SetObjVar("Intro|Rufus the Head Guard",true)
    QuickDialogMessage(this,user,"[$1392]")
    user:SendMessage("StartQuest","RuinsIntroQuest")
    noteContents = "[$1393]"
    CreateObjInBackpack(user,"scroll_readable","ContactNote","ThomasContactNote",noteContents) 
end

function Dialog.OpenOutlandsRebelQuestBringMessageToRufusDialog(user)
    text = "Anything I need to be concerned with citizen?"

    response = {}

    response[1] = {}
    response[1].text = "...I have a message for you."
    response[1].handle = "RebelResponse" 

    response[2] = {}
    response[2].text = "Nothing. Nevermind."
    response[2].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenRebelResponseDialog(user)

    text = "[$1394]"

    response = {}

    response[1] = {}
    response[1].text = "I found them randomly."
    response[1].handle = "RandomlyRebels" 

    response[2] = {}
    response[2].text = "I was sent to kill them."
    response[2].handle = "KillRebels" 

    response[3] = {}
    response[3].text = "Long story."
    response[3].handle = "LongStoryRebels" 

    response[4] = {}
    response[4].text = "...Because screw the government!"
    response[4].handle = "Attack" 

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenRandomlyRebelsDialog(user)
    user:SendMessage("AdvanceQuest","OutlandsRebelQuest","BringMessageToRothchilde")
    DialogReturnMessage(this,user,"[$1395]","Alright then.")
end

function Dialog.OpenKillRebelsDialog(user)
    user:SendMessage("AdvanceQuest","OutlandsRebelQuest","BringMessageToRothchilde")
    DialogReturnMessage(this,user,"[$1396]")
end

function Dialog.OpenLongStoryRebelsDialog(user)
    user:SendMessage("AdvanceQuest","OutlandsRebelQuest","BringMessageToRothchilde")
    DialogReturnMessage(this,user,"[$1397]","Alright then.")

end

function Dialog.OpenAttackDialog(user)
    user:SendMessage("AdvanceQuest","OutlandsRebelQuest","BringMessageToRothchilde")
     this:NpcSpeech("...Traitor!!!")
    PlayerTitles.EntitleFromTable(user,AllTitles.ActivityTitles.Stupid)
    this:SendMessage("AttackEnemy",user)
end

RegisterEventHandler(EventType.CreatedObject,"ContactNote",
    function(success,objRef,objVarName,noteContents)
        if (success) then
            objRef:SetObjVar(objVarName,true)
            objRef:SetObjVar("Worthless",true)
            objRef:SendMessage("WriteNote",noteContents)
        end
    end)

--if the player loses the note
function Dialog.OpenGraveyardIntroQuestTalkToGraveyardKeeperDialog(user)
    text = "Any luck on finding Mason?"

    response = {}

    response[1] = {}
    response[1].text = "I lost the note."
    response[1].handle = "LostMasonNote" 

    response[2] = {}
    response[2].text = "I'm working on it."
    response[2].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)
end
function Dialog.OpenRuinsIntroQuestTalkToThomasDialog(user)
    text = "Any luck on finding Thomas?"

    response = {}

    response[1] = {}
    response[1].text = "I lost the note."
    response[1].handle = "LostThomasNote" 

    response[2] = {}
    response[2].text = "I'm working on it."
    response[2].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)
end
function Dialog.OpenForestIntroQuestTalkToRonDialog(user)
    text = "Any luck on finding Ron?"

    response = {}

    response[1] = {}
    response[1].text = "I lost the note."
    response[1].handle = "LostRonNote" 

    response[2] = {}
    response[2].text = "I'm working on it."
    response[2].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)
end
function Dialog.OpenDeadGateIntroQuestTalkToAegisDialog(user)
    text = "Any luck on finding Aegis?"

    response = {}

    response[1] = {}
    response[1].text = "I lost the note."
    response[1].handle = "LostAegisNote" 

    response[2] = {}
    response[2].text = "I'm working on it."
    response[2].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenLostMasonNoteDialog(user)
    if (not HasExplorationQuestNote(user,"MasonContactNote")) then
        QuickDialogMessage(this,user,"[$1398]") 
        noteContents = "[$1399]"
        CreateObjInBackpack(user,"scroll_readable","ContactNote","MasonContactNote",noteContents) 
    else
        QuickDialogMessage(this,user,"[$1400]")
    end
end
function Dialog.OpenLostThomasNoteDialog(user)
    if (not HasExplorationQuestNote(user,"ThomasContactNote")) then
        QuickDialogMessage(this,user,"[$1401]") 
        noteContents = "[$1402]"
        CreateObjInBackpack(user,"scroll_readable","ContactNote","ThomasContactNote",noteContents)
    else
        QuickDialogMessage(this,user,"[$1403]")
    end
end
function Dialog.OpenLostRonNoteDialog(user)
    if (not HasExplorationQuestNote(user,"RonContactNote")) then
        QuickDialogMessage(this,user,"[$1404]") 
        noteContents = "[$1405]"
        CreateObjInBackpack(user,"scroll_readable","ContactNote","RonContactNote",noteContents) 
    else
        QuickDialogMessage(this,user,"[$1406]")
    end
end
function Dialog.OpenLostAegisNoteDialog(user)
    if (not HasExplorationQuestNote(user,"AegisContactNote")) then
        QuickDialogMessage(this,user,"[$1407]") 
        noteContents = "[$1408]"
        CreateObjInBackpack(user,"scroll_readable","ContactNote","AegisContactNote",noteContents) 
     else
        QuickDialogMessage(this,user,"[$1409]")
    end
end

--when the player returns with the NPC's note
function Dialog.OpenGraveyardIntroQuestGoBackToRufusDialog(user)
    local ProfessionQuestsComplete = user:GetObjVar("ExplorationQuestsComplete") or 0
    user:SetObjVar("ExplorationQuestsComplete",ProfessionQuestsComplete + 1)
    QuickDialogMessage(this,user,"[$1410]")
    user:SetObjVar("RufusGraveyardFinish",true)
end
function Dialog.OpenRuinsIntroQuestGoBackToRufusDialog(user)
    local ProfessionQuestsComplete = user:GetObjVar("ExplorationQuestsComplete") or 0
    user:SetObjVar("ExplorationQuestsComplete",ProfessionQuestsComplete + 1)
    QuickDialogMessage(this,user,"[$1412]")
    user:SetObjVar("RufusRuinsFinish",true)
end
function Dialog.OpenForestIntroQuestGoBackToRufusDialog(user)
    local ProfessionQuestsComplete = user:GetObjVar("ExplorationQuestsComplete") or 0
    user:SetObjVar("ExplorationQuestsComplete",ProfessionQuestsComplete + 1)
    QuickDialogMessage(this,user,"[$1414]")
    user:SetObjVar("RufusForestFinish",true)
end
function Dialog.OpenDeadGateIntroQuestGoBackToRufusDialog(user)
    local ProfessionQuestsComplete = user:GetObjVar("ExplorationQuestsComplete") or 0
    user:SetObjVar("ExplorationQuestsComplete",ProfessionQuestsComplete + 1)
    QuickDialogMessage(this,user,"[$1416]")
    user:SetObjVar("RufusDeadGateFinish",true)
end


function Dialog.OpenCeladorDialog(user)
	DialogReturnMessage(this,user,"[$1418]","Right.")
end
Dialog.OpenWhereDialog = Dialog.OpenCeladorDialog
function Dialog.OpenBobDialog(user)
    DialogReturnMessage(this,user,"[$1419]","...Sorry to hear that...")
end
function Dialog.OpenDeadGateDialog(user)
	DialogReturnMessage(this,user,"It's a magic gate. Duh.","Right.")
end
function Dialog.OpenPetraDialog(user)
	DialogReturnMessage(this,user,"It's a City. Duh.","OK.")
end
function Dialog.OpenPeopleDialog(user)
	DialogReturnMessage(this,user,"[$1420]","Right.")
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
function Dialog.OpenReportCrimeDialog(user)
	DialogReturnMessage(this,user,"[$1421]","Right.")
end
function Dialog.OpenFightCultistsDialog(user)
    DialogReturnMessage(this,user,"[$1422]","Right.")
end
function Dialog.OpenBanditsDialog(user)
    DialogReturnMessage(this,user,"[$1423]","Right.")
end
function Dialog.OpenStolenDialog(user)
    DialogReturnMessage(this,user,"[$1424]","Gee, thanks.")
end
function Dialog.OpenRobberyDialog(user)
    DialogReturnMessage(this,user,"[$1425]","Yeah right.")
end
function Dialog.OpenCultDialog(user)
    DialogReturnMessage(this,user,"[$1426]","Right.")
end
function Dialog.OpenSubjectBanditDialog(user)
    DialogReturnMessage(this,user,"[$1427]","Wow.")
end
function Dialog.OpenLawDialog(user)
    DialogReturnMessage(this,user,"[$1428]","Right...")
end
function Dialog.OpenCrimeDialog(user)
    DialogReturnMessage(this,user,"[$1429]","Um... Ok.")
end
function Dialog.OpenLastNameDialog(user)
    DialogReturnMessage(this,user,"[$1430]","That's cool.")
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

function HandleVictimKilled(victim)
    if( victim ~= nil ) then
        if( victim:IsPlayer() ) then
            if (GetFaction(victim) < -40) then
                return
            end
        else
            victim:SetObjVar("guardKilled",true)
        end
    end
end
RegisterEventHandler(EventType.Message, "VictimKilled", HandleVictimKilled)

OverrideEventHandler("base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)
