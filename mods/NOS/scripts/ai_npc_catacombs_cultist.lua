require 'NOS:base_ai_npc'

AI.Settings.MerchantEnabled = false
AI.Settings.EnableTrain = false
AI.Settings.SetIntroObjVar = true
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
	"[$505]"
} 

AI.GreetingMessages = 
{
	"Hau'Kommen strange one, what do you want?",
    "[$506]",
    "[$507]"
}

AI.AskHelpMessages =
{
	"What do you need my help for, outsider?",
    "[$508]"
}

AI.RefuseTrainMessage = {
	"",
}

AI.WellTrainedMessage = {
	"",
}

AI.CannotAffordMessages = {
    ""
}

AI.TrainScopeMessages = {
	"",
}

AI.NevermindMessages = 
{
    "Anything else, He who hath no Faith?",
    "What else, He of No Snakes?"
}

AI.TalkMessages = 
{
	"[$509]",
    "Ah yes, what do you wish to know."
}

AI.WhoMessages = {
	"[$510]" ,
}

AI.PersonalQuestion = {
	"[$511]",
}

AI.HowMessages = {
    "[$512]"
}

AI.FamilyMessage = {
    "[$513]"
}

AI.SpareTimeMessages= {
	"[$514]",
}

AI.WhatMessages = {
	"[$515]",
}

AI.StoryMessages = {
	"[$516]",
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

    text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]

    user:SetObjVar("Intro|Duredan the Bedkeeper",true)

    response = {}

    response[1] = {}
    response[1].text = "What are YOU doing here?"
    response[1].handle = "YouDoingHere"

    response[2] = {}
    response[2].text = "Fighting Kho's forces."
    response[2].handle = "FightingKho"

    response[3] = {}
    response[3].text = "I'm making bank. That's why."
    response[3].handle = "DoForYou"

    response[4] = {}
    response[4].text = "None of your business..."
    response[4].handle = "Nevermind"

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenYouDoingHereDialog(user)

    text = "[$517]"

    response = {}

    response[1] = {}
    response[1].text = "Sure."
    response[1].handle = "HelpCultists"

    response[2] = {}
    response[2].text = "I'm not helping you."
    response[2].handle = "YouWouldBeWise"

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenDoForYouDialog(user)

    text = "[$518]"

    response = {}

    response[1] = {}
    response[1].text = "Sure."
    response[1].handle = "HelpCultists"

    response[2] = {}
    response[2].text = "I'm not helping you."
    response[2].handle = "YouWouldBeWise"

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenYouWouldBeWiseDialog(user)
    user:SendMessage("StartQuest","CatacombsSpyQuest")
    text = "[$519]"

    response = {}

    response[1] = {}
    response[1].text = "Whatever."
    response[1].handle = ""

    response[1] = {}
    response[1].text = "I'll think about it."
    response[1].handle = "Nevermind"

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenHelpCultistsDialog(user)
    user:SendMessage("StartQuest","SpyForElderGods")
    QuickDialogMessage(this,user,"[$520]")
    noteContents = "[$521]"
    CreateObjInBackpack(user,"scroll_readable","ContactNote","CultistNote",noteContents) 
end

function Dialog.OpenFightingKhoDialog(user)
    DialogReturnMessage(this,user,"[$522]","Right.")
end

RegisterEventHandler(EventType.CreatedObject,"ContactNote",
    function(success,objRef,objVarName,noteContents)
        if (success) then
            objRef:SetObjVar(objVarName,true)
            objRef:SendMessage("WriteNote",noteContents)
        end
    end)

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
    response[1].text = "...Why did you come here?"
    response[1].handle = "YouDoingHere"

    response[2] = {}
    response[2].text = "...What is your opinion of Kho?"
    response[2].handle = "Kho" 

    response[3] = {}
    response[3].text = "...Is there anything I can do for you?"
    response[3].handle = "DoForYou" 

    response[4] = {}
    response[4].text = "...What is your opinion of the Wayun?"
    response[4].handle = "Wayun"

    response[5] = {}
    response[5].text = "Nevermind."
    response[5].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "...How did you get here?"
    response[1].handle = "How"

    response[2] = {}
    response[2].text = "What is your story?"
    response[2].handle = "Story" 

    response[3] = {}
    response[3].text = "What is down here for you?"
    response[3].handle = "DoForYou" 

    response[4] = {}
    response[4].text = "Might I ask you a personal question?"
    response[4].handle = "PersonalQuestion"

    response[5] = {}
    response[5].text = "Nevermind."
    response[5].handle = "Nevermind" 

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

function Dialog.OpenFamilyDialog(user)
    DialogReturnMessage(this,user,AI.FamilyMessage[math.random(1,#AI.FamilyMessage)],"Oh.")
end
function Dialog.OpenSpareTimeDialog(user)
	DialogReturnMessage(this,user,AI.SpareTimeMessages[math.random(1,#AI.SpareTimeMessages)],"Err, no thanks.")
end
function Dialog.OpenHowDialog(user)
	DialogReturnMessage(this,user,AI.HowMessages[math.random(1,#AI.HowMessages)],"Oh.")
end
function Dialog.OpenStoryDialog(user)
	DialogReturnMessage(this,user,AI.StoryMessages[math.random(1,#AI.StoryMessages)],"Oh.")
end
function Dialog.OpenLastNameDialog(user)
    DialogReturnMessage(this,user,"[$523]","Oh, alright.")
end
function Dialog.OpenKhoDialog(user)
    DialogReturnMessage(this,user,"[$524]","Oh, alright.")
end
function Dialog.OpenWayunDialog(user)
    DialogReturnMessage(this,user,"[$525]","Oh, alright.")
end

OverrideEventHandler("NOS:base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)

