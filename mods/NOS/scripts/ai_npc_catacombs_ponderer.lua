require 'base_ai_npc'

AI.Settings.MerchantEnabled = false
AI.Settings.EnableTrain = false
AI.Settings.SetIntroObjVar = false
AI.Settings.EnableBuy = false
AI.Settings.StationedLeash = true
AI.Settings.CanConverse = false

fixPrice = 20

NPCTasks = {
}

AI.QuestList = {}
AI.Settings.KnowName = false 
AI.Settings.HasQuest = false
AI.QuestMessages = {}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$662]"
} 

AI.GreetingMessages = 
{
	"[$663]",
    "[$664]",
    "[$665]"
}

AI.AskHelpMessages =
{
	"[$666]",
    "I have so much on my mind, what can I do to spare?"
}

AI.RefuseTrainMessage = {
	"If you do not desire my time, then leave me be.",
}

AI.WellTrainedMessage = {
	"You have been trained well enough for my liking.",
}

AI.TrainScopeMessages = {
	"I have learnt much. What would you like to know?",
}

AI.NevermindMessages = 
{
    "Anything else you wish to talk about?",
}

AI.TalkMessages = 
{
	"I can talk, what is it you desire?",
    "If thoughts are your goal, then ask away.",
}

AI.WhoMessages = {
	"[$667]" ,
}

AI.PersonalQuestion = {
	"Why does it matter? Ask anyway?",
}

AI.HowMessages = {
        "[$668]"
	}

AI.FamilyMessage = {
    "[$669]"
}

AI.SpareTimeMessages= {
	"[$670]",
}

AI.WhatMessages = {
	"What is it you want anyway?",
}

AI.StoryMessages = {
	"[$671]",
}  

function CanBuyItem(buyer,item)
    if (not HasFinishedQuest(buyer,"CatacombsStartQuest")) then
        this:NpcSpeech("...")
        return false
    else
        return true
    end
end
function IntroDialog(user)

--[[
     if (not HasFinishedQuest(user,"CatacombsStartQuest") or user:HasObjVar("SkipQuest")) then
        this:NpcSpeech("...")
        user:SendMessage("AdvanceQuest","CatacombsStartQuest","TalkToSomeone","Investigate")
        return
    else
        text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
    end
]]--
    text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]

    user:SetObjVar("Intro|Uthaus the Ponderer",true)

    response = {}

    response[1] = {}
    response[1].text = "What is this place?"
    response[1].handle = "Where"

    response[2] = {}
    response[2].text = "Who are you?"
    response[2].handle = "Who"

    response[3] = {}
    response[3].text = "Nice to meet you."
    response[3].handle = "Nevermind" 


    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
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
    response[1].text = "...The Wayun?"
    response[1].handle = "Wayun" 

    response[2] = {}
    response[2].text = "...This place?"
    response[2].handle = "Where" 

    response[3] = {}
    response[3].text = "...The Elemental Gods?"
    response[3].handle = "Elemental"

    response[4] = {}
    response[4].text = "...The Elder Gods?"
    response[4].handle = "ElderGods" 

    response[5] = {}
    response[5].text = "...The monsters beneath?"
    response[5].handle = "Monsters"

    response[6] = {}
    response[6].text = "Nevermind."
    response[6].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "How did you get here?"
    response[1].handle = "Story" 

    response[2] = {}
    response[2].text = "How did you end up thinking so much?"
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

function Dialog.OpenSpyForElderGodsInvestigateDialog(user)
    user:SendMessage("StartQuest","CatacombsSpyQuest")
    QuickDialogMessage(this,user,"[$672]")
end

function Dialog.OpenWayunDialog(user)
	DialogReturnMessage(this,user,"[$673]","Yeah. Perhaps...")
end
function Dialog.OpenElementalDialog(user)
    DialogReturnMessage(this,user,"[$674]","Huh.")
end
function Dialog.OpenElderGodsDialog(user)
    DialogReturnMessage(this,user,"[$675]","Uh-oh.")
end
function Dialog.OpenMonstersDialog(user)
    DialogReturnMessage(this,user,"[$676]","Right.")
end
function Dialog.OpenWhereDialog(user)
    DialogReturnMessage(this,user,"[$677]","Thanks.")
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
    DialogReturnMessage(this,user,"[$678]","Oh.")
end

OverrideEventHandler("base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)

