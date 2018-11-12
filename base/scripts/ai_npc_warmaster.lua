require 'base_ai_npc'

AI.Settings.MerchantEnabled = false
AI.Settings.EnableTrain = false
AI.Settings.SetIntroObjVar = false
AI.Settings.StationedLeash = true

fixPrice = 20

NPCTasks = {}

AI.QuestList = {"WarriorIntroQuest"}
AI.Settings.KnowName = false 
AI.Settings.HasQuest = true
AI.QuestMessages = {"Ah. Come talk to me newcomer.","Another one, come here and let me teach you."}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$1540]"
    .."[$1541]"
    .."[$1542]"
} 

AI.GreetingMessages = 
{
	"[$1543]",
	"[$1544]",
	"What do you want with me today?",
}

AI.CantAffordPurchaseMessages = {
	"[$1545]",
	"[$1546]",
	"[$1547]",
}

AI.AskHelpMessages =
{
	"What do you need assistance with?",
	"I can help you with a few problems. What ails you?",
	"[$1548]",
	"If you require assistance, tell me so...",
}

AI.RefuseTrainMessage = {
	"[$1549]",
	"[$1550]",
}

AI.WellTrainedMessage = {
	"[$1551]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"[$1552]",
	"[$1553]",
	"[$1554]",
    "[$1555]",
}

AI.NevermindMessages = 
{
    "Is that all that you need?",
    "Anything else?",
    "Anything else that concerns me?",
}

AI.TalkMessages = 
{
	"[$1556]",
	"If you wish to know, then I shall tell you.",
	"If you desire knowledge, then I shall give it.",
	"If you wish to know about me, then I'm obliged.",
}

AI.WhoMessages = {
	"[$1557]",
}

AI.PersonalQuestion = {
	"[$1558]",
    "[$1559]",
}

AI.HowMessages = {
	"[$1560]",
}

AI.FamilyMessage = AI.HowMessages

AI.SpareTimeMessages= {
	"[$1561]",
}

AI.WhatMessages = {
	"...In what sense?",
	"...About...?",
	"...Regarding...?",
}

AI.StoryMessages = {
	"[$1562]"
}


function IntroDialog(user)

    if (user:HasObjVar("OpenedDialog|Ciro the Warmaster")) then
        text = "[$1563]"
    else
        text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
    end
    user:SetObjVar("OpenedDialog|Ciro the Warmaster",true)

    response = {}
--[[
    response[1] = {}
    response[1].text = "Show me the art of combat."
    response[1].handle = "StartFightQuest" 
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

function Dialog.OpenStartingQuestProfessionQuestDialog(user)
    IntroDialog(user)    
end

function Dialog.OpenWarriorIntroQuestTalkToTrainerAgainDialog(user)
    QuickDialogMessage(this,user,"[$1564]")
    user:SetObjVar("CiroFinish",true)
    local ProfessionQuestsComplete = user:GetObjVar("ProfessionQuestsComplete") or 0
    user:SetObjVar("ProfessionQuestsComplete",ProfessionQuestsComplete + 1)
end

function Dialog.OpenWarriorIntroQuestAchieveSkillLevelDialog(user)
    QuickDialogMessage(this,user,"[$1565]")
end

function Dialog.OpenWarriorIntroQuestChangeCombatStanceDialog(user)
    QuickDialogMessage(this,user,"[$1566]")
end

function Dialog.OpenStartFightQuestDialog(user)
    QuickDialogMessage(this,user,"[$1567]")
    user:SendMessage("StartQuest","WarriorIntroQuest","TalkToTrainer")
    user:SetObjVar("Intro|Ciro the Warmaster",true)
end

function Dialog.OpenWarriorIntroQuestLearnCombatAbilitiesDialog(user)
    Dialog.OpenStartFightQuestDialog(user)
end

function Dialog.OpenWarriorIntroQuestUseFlurryAbilityDialog(user)
    QuickDialogMessage(this,user,"[$1568]")
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

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhatDialog(user)
    --DebugMessage("WhatDialog")
    text = AI.WhatMessages[math.random(1,#AI.WhatMessages)]

    response = {}

    response[1] = {}
    response[1].text = "...Fighting?"
    response[1].handle = "Fighting" 

    response[2] = {}
    response[2].text = "...The Cult?"
    response[2].handle = "Cult" 

    response[3] = {}
    response[3].text = "...The people here?"
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
    response[1].text = "What's your story?"
    response[1].handle = "Story" 

    response[2] = {}
    response[2].text = "Why are you the Warmaster?"
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
	DialogReturnMessage(this,user,"[$1569]","Right.")
end
Dialog.OpenWhereDialog = Dialog.OpenCeladorDialog
function Dialog.OpenFightingDialog(user)
	DialogReturnMessage(this,user,"[$1570]","Alright then.")
end
function Dialog.OpenCultDialog(user)
    DialogReturnMessage(this,user,"[$1571]","Right.")
end
function Dialog.OpenPeopleDialog(user)
	DialogReturnMessage(this,user,"[$1572]","Right.")
end
function Dialog.OpenFamilyDialog(user)
	DialogReturnMessage(this,user,"[$1573]","Oh..")
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
    DialogReturnMessage(this,user,"[$1574]","We are alike then...")
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

