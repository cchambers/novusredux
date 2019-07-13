require 'NOS:base_ai_npc'

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = false
AI.Settings.SetIntroObjVar = false
AI.Settings.EnableBuy = true
AI.Settings.StationedLeash = true
AI.Settings.CanConverse = false

fixPrice = 20

NPCTasks = {
}

Merchant.CurrencyInfo =
    {
        CurrencyType = "resource",
        ObjVarName = nil,
        CurrencyDisplayStr = "tokens",
        Resource = "KhoToken",
    }

AI.QuestList = {}
AI.Settings.KnowName = false 
AI.Settings.HasQuest = false
AI.QuestMessages = {}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$488]"
} 

AI.GreetingMessages = 
{
	"What can I do for you outsider?",
    "[$489]",
    "In the name of the Wayun, I bid you greetings."
}

AI.AskHelpMessages =
{
	"What do you require of me.",
    "What do you need?"
}

AI.RefuseTrainMessage = {
	"Only the Dead know of this sin.",
}

AI.WellTrainedMessage = {
	"[$490]",
}

AI.CantAffordPurchaseMessages = {
    "[$491]"
}
AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"[$492]",
}

AI.NevermindMessages = 
{
    "What else can I help with.",
}

AI.TalkMessages = 
{
	"What can I make you know?",
}

AI.WhoMessages = {
	"[$493]" ,
}

AI.PersonalQuestion = {
	"...Speak your mind.",
}

AI.HowMessages = {
        "[$494]"
	}

AI.FamilyMessage = {
    "[$495]"
}

AI.SpareTimeMessages= {
	"[$496]",
}

AI.WhatMessages = {
	"What do you wish to know?",
}

AI.StoryMessages = {
	"[$497]",
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

     if (not HasFinishedQuest(user,"CatacombsStartQuest") or user:HasObjVar("SkipQuest")) then
        this:NpcSpeech("Be gone from here!")
        user:SendMessage("AdvanceQuest","CatacombsStartQuest","TalkToSomeone","Investigate")
        return
    else
        text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
    end

    response = {}

    response[1] = {}
    response[1].text = "Yes, I am."
    response[1].handle = "YesIntro"

    response[2] = {}
    response[2].text = "Definitely not."
    response[2].handle = "NoIntro"

    response[3] = {}
    response[3].text = "The Strangers have sent me."
    response[3].handle = "Strangers" 

    response[4] = {}
    response[4].text = "...Bye."
    response[4].handle = "" 


    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenYesIntroDialog(user)
    this:NpcSpeech("Then be gone from here before you be slain!")
end

function Dialog.OpenNoIntroDialog(user)
    ChangeFactionByAmount(user,1,"Wayun")
    QuickDialogMessage(this,user,"[$498]")
    user:SetObjVar("Intro|Nihi-Lius the Bonemaster",true)
end

function Dialog.OpenStrangersDialog(user)
    user:SetObjVar("Intro|Nihi-Lius the Bonemaster",true)
    QuickDialogMessage(this,user,"[$499]")
    AdjustFaction(user,2,"Wayun")--bonus faction for telling them the strangers sent you.
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
    response[1].text = "...This place?"
    response[1].handle = "Where" 

    response[2] = {}
    response[2].text = "...Your Void magic?"
    response[2].handle = "Story" 

    response[3] = {}
    response[3].text = "...The Wayward?"
    response[3].handle = "Wayward"

    response[4] = {}
    response[4].text = "...Your gods?"
    response[4].handle = "Gods" 

    response[5] = {}
    response[5].text = "...The evil below?"
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
    response[2].text = "How did you end up a merchant?"
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

function Dialog.OpenWhereDialog(user)
	DialogReturnMessage(this,user,"[$500]","Interesting.")
end
function Dialog.OpenWaywardDialog(user)
    DialogReturnMessage(this,user,"[$501]","Interesting.")
end
function Dialog.OpenGodsDialog(user)
    DialogReturnMessage(this,user,"[$502]","Great. Thanks.")
end
function Dialog.OpenMonstersDialog(user)
    DialogReturnMessage(this,user,"[$503]","Yeah right.")
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
function Dialog.OpenFamilyDialog(user)
    DialogReturnMessage(this,user,AI.FamilyMessage[math.random(1,#AI.FamilyMessage)],"Oh.")
end
function Dialog.OpenLastNameDialog(user)
    DialogReturnMessage(this,user,"[$504]","Oh, alright.")
end

OverrideEventHandler("NOS:base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)

