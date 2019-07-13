require 'NOS:base_ai_npc'

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = false
AI.Settings.SetIntroObjVar = false
AI.Settings.StationedLeash = true

fixPrice = 20

NPCTasks = {}

AI.QuestList = {"RogueIntroQuest"}
AI.Settings.KnowName = false 
AI.Settings.HasQuest = true
AI.QuestMessages = {"Ah. You would make a good pickpocket.","I see a real crook in you. Come talk to me."}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$1494]"
} 

AI.GreetingMessages = 
{
	"Ah, I remember you. How are you my friend?",
    "What can I do for you today?",
    "[$1495]"
}

AI.CantAffordPurchaseMessages = {
	"[$1496]",
    "[$1497]",
    "[$1498]"
}

AI.AskHelpMessages =
{
	"Well of course, what can I help you with then?",
    "Why of course, what do you need help with?",
    "[$1499]"
}

AI.RefuseTrainMessage = {
	"[$1500]",
    "If that is what you wish...",
}

AI.WellTrainedMessage = {
	"[$1501]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"[$1502]",
    "[$1503]"
}

AI.NevermindMessages = 
{
    "...Anything else?",
    "[$1504]",
}

AI.TalkMessages = 
{
	"There is only so much I will tell you.",
    "Only a few things shall you know.",
}

AI.WhoMessages = {
	"[$1505]",
}

AI.PersonalQuestion = {
	"[$1506]",
}

AI.HowMessages = {
	"[$1507]",
}

AI.FamilyMessage ={
    "[$1508]"
}

AI.SpareTimeMessages= {
	"[$1509]",
}

AI.WhatMessages = {
	"...Regarding what, my friend...?",
    "...Respecting what, my friend?"
}

AI.StoryMessages = {
	"[$1510]"
}  

function IntroDialog(user)

    if (user:HasObjVar("OpenedDialog|Rakh the Theif")) then
        text = "[$1511]"
    else
        text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
    end
    user:SetObjVar("OpenedDialog|Rakh the Thief",true)

    response = {}
--[[
    response[1] = {}
    response[1].text = "...Yeah. The mayor sent me."
    response[1].handle = "StartIntroQuest" 
--]]
    response[2] = {}
    response[2].text = "Err... No."
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

function Dialog.OpenFoundersQuestNoteToRakhDialog(user)
    text = "[$1512]"

    response = {}

    response[1] = {}
    response[1].text = "Give me the stones. Now."
    response[1].handle = "Stones" 

    response[3] = {}
    response[3].text = "Goodbye."
    response[3].handle = "" 

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenStonesDialog(user)
    QuickDialogMessage(this,user,"[$1513]")
end

function Dialog.OpenFoundersQuestReturnToRakhDialog(user)
    QuickDialogMessage(this,user,"[$1514]")
end

function Dialog.OpenRogueIntroQuestBringItemBackDialog(user)
    QuickDialogMessage(this,user,"[$1515]")
    user:SetObjVar("RakhFinished",true)
    local ProfessionQuestsComplete = user:GetObjVar("ProfessionQuestsComplete") or 0
    user:SetObjVar("ProfessionQuestsComplete",ProfessionQuestsComplete + 1)
end

function Dialog.OpenRogueIntroQuestTalkToRakhToStealDialog(user)
    QuickDialogMessage(this,user,"[$1516]")
    user:SetObjVar("RakhFinished",true)
end

function Dialog.OpenStartIntroQuestDialog(user)
    --user:SendMessage("StartQuest","RogueIntroQuest")
    QuickDialogMessage(this,user,"[$1517]")
    user:SetObjVar("Intro|Rakh the Thief",true)
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
    response[1].text = "...Killing!"
    response[1].handle = "Killing" 

    response[2] = {}
    response[2].text = "...Your 'work' for the mayor?"
    response[2].handle = "Assassin" 

    response[3] = {}
    response[3].text = "...Being a criminal?"
    response[3].handle = "Criminal"

    response[4] = {}
    response[4].text = "...The fact that what you do is wrong?"
    response[4].handle = "Morals"

    response[5] = {}
    response[5].text = "Nevermind."
    response[5].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "What is your story?"
    response[1].handle = "Story" 

    response[2] = {}
    response[2].text = "How did you become a thief?"
    response[2].handle = "How" 

    response[3] = {}
    response[3].text = "...May I ask you a personal question?"
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
	DialogReturnMessage(this,user,"[$1518]","Right.")
end
Dialog.OpenWhereDialog = Dialog.OpenCeladorDialog
function Dialog.OpenKillingDialog(user)
	DialogReturnMessage(this,user,"[$1519]","Alright then.")
end
function Dialog.OpenAssassinDialog(user)
    DialogReturnMessage(this,user,"[$1520]","I think I get it...")
end
function Dialog.OpenCriminalDialog(user)
	DialogReturnMessage(this,user,"[$1521]","Right.")
end
function Dialog.OpenFamilyDialog(user)
	DialogReturnMessage(this,user,AI.FamilyMessage,"Oh..")
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
    DialogReturnMessage(this,user,"[$1522]","Oh.")
end

OverrideEventHandler("NOS:base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)

