require 'base_ai_npc'

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = false
AI.Settings.SetIntroObjVar = false
AI.Settings.EnableBuy = true
AI.Settings.StationedLeash = true
AI.Settings.CanConverse = false

fixPrice = 20

NPCTasks = {
    --[[LawOfWayunTask = {
        TaskName = "LawOfWayunTask",
        TaskDisplayName = "Law of the Wayun",
        Description = "Find the Laws of the Wayun",
        FinishDescription = "Bring it back to Hal-Thur",
        RewardType = "kho_token",
        RewardAmount = 3,
        Repeatable = true, --if you can redo the task
        Importance = 1, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$563]",
        TaskAcceptSpeech = "[$564]",
        TaskCurrentSpeech = "Have you FOUND the SACRED LAW of the WAYUN?",
        TaskContinueSpeech = "[$565]",
        TaskCancelSpeech = "[$566]",
        TaskHelpSpeech = "[$567]",
        TaskPreCompleteSpeech = "[$568]",
        TaskFinishedMessage = "[$569]",
        TaskIncompleteMessage = "[$570]",
        TaskAssists = {
                      {Template = "catacombs_priest",Text = "[$571]"},
                      {Template = "catacombs_ponderer",Text = "[$572]"},
                     },
        CheckCompletionCallback = "Items",
        CompletionCallback = "Items",
        TaskItemList = {{"book_law_of_wayun",1}},
        Faction = "Wayun",
        FactionOnFinish = 2,
    },
    BooksOfWayunTask = {
        TaskName = "BooksOfWayunTask",
        TaskDisplayName = "Books of the Wayun",
        Description = "Find a copy of each Wayun scripture.",
        FinishDescription = "Bring them back to Hal-Thur",
        RewardType = "kho_token",
        RewardAmount = 8,
        Repeatable = true, --if you can redo the task
        Importance = 1, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "",
        TaskAcceptSpeech = "[$573]",
        TaskCurrentSpeech = "Have you FOUND the SACRED LAW of the WAYUN?",
        TaskContinueSpeech = "[$574]",
        TaskCancelSpeech = "[$575]",
        TaskHelpSpeech = "[$576]",
        TaskPreCompleteSpeech = "[$577]",
        TaskFinishedMessage = "[$578]",
        TaskIncompleteMessage = "[$579]",
        TaskAssists = {
                      {Template = "catacombs_priest",Text = "[$580]"},
                      {Template = "catacombs_ponderer",Text = "[$581]"},
                     },
        CheckCompletionCallback = "Items",
        CompletionCallback = "Items",
        TaskItemList = {{"book_law_of_wayun",1}},
        Faction = "Wayun",
        FactionOnFinish = 2,
    },--]]
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
	"[$582]"
} 

AI.GreetingMessages = 
{
	"[$583]",
    "[$584]",
    "[$585]"
}

AI.CantAffordPurchaseMessages = {
	"[$586]",
    "[$587]",
    "[$588]",
}

AI.AskHelpMessages =
{
	"[$589]",
    "[$590]"
}

AI.RefuseTrainMessage = {
	"[$591]",
}

AI.WellTrainedMessage = {
	"[$592]",
}

AI.CannotAffordMessages = {
    "[$593]"
}

AI.TrainScopeMessages = {
	"[$594]",
}

AI.NevermindMessages = 
{
    "Anything else that you desire of this court!?",
}

AI.TalkMessages = 
{
	"[$595]",
}

AI.WhoMessages = {
	"[$596]" ,
}

AI.PersonalQuestion = {
	"...Erm... a personal question?",
}

AI.HowMessages = {
        "[$597]"
	}

AI.FamilyMessage = {
    "[$598]"
}

AI.SpareTimeMessages= {
	"[$599]",
}

AI.WhatMessages = {
	"What do you REQUIRE of this lawgiver?",
}

AI.StoryMessages = {
	"[$600]",
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
    user:SendMessage("AdvanceQuest","CatacombsStartQuest","TalkToSomeone","Investigate")
    --user:SendMessage("AdvanceQuest","CatacombsStartQuest","ReadScripture","TalkToSomeone")
--[[
     if (not HasFinishedQuest(user,"CatacombsStartQuest") and not user:HasObjVar("SkipQuest")) then
        this:NpcSpeech("BE GONE OR LEARN OUR WAYS!!!")
        user:SendMessage("AdvanceQuest","CatacombsStartQuest","TalkToSomeone","Investigate")
        return
    else
        ]]--
        --if (user:HasObjVar("CatacombsIgnorePlayerInteract")) then
        --    Dialog.OpenIgnoreDialog(user)
        --    return
        --end
        if ( user:GetObjVar("OpenedDialog|Hal-Thur the Judge")) then
            text = "Are you prepared for the questions you face?"
        else
            text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
        end
        user:SetObjVar("OpenedDialog|Hal-Thur the Judge",true)
        response = {}

        response[1] = {}
        response[1].text = "I'll answer the question."
        response[1].handle = "Question1"

        response[2] = {}
        response[2].text = "Who are you?"
        response[2].handle = "Ignore"

        response[4] = {}
        response[4].text = "Nice to meet you."
        response[4].handle = "Ignore" 


        NPCInteraction(text,this,user,"Responses",response)

        GetAttention(user)
    --end
end

function Dialog.OpenQuestion1Dialog(user)

    text = "[$601]"

    response = {}

    response[1] = {}
    response[1].text = "There's more than one question?"
    response[1].handle = "Ignore"

    response[2] = {}
    response[2].text = "The Great Awakening?"
    response[2].handle = "Ignore"

    response[3] = {}
    response[3].text = "The Portal of Old?"
    response[3].handle = "Question2"

    response[4] = {}
    response[4].text = "The Wayun."
    response[4].handle = "Ignore" 

    response[5] = {}
    response[5].text = "Erm... I don't know."
    response[5].handle = "Ignore" 


    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenQuestion2Dialog(user)
    text = "[$602]"

    response = {}

    response[1] = {}
    response[1].text = "A means of achiving perfection?"
    response[1].handle = "Ignore"

    response[2] = {}
    response[2].text = "The Wayun's Will, and our hearts?"
    response[2].handle = "Question3"

    response[3] = {}
    response[3].text = "A method of travel?"
    response[3].handle = "Ignore"

    response[4] = {}
    response[4].text = "Some sort of portal."
    response[4].handle = "Ignore" 

    response[5] = {}
    response[5].text = "Erm... I don't know."
    response[5].handle = "Ignore" 


    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenQuestion3Dialog(user)
    text = "[$603]"

    response = {}

    response[1] = {}
    response[1].text = "The believers in the Elder Gods?"
    response[1].handle = "Ignore"

    response[2] = {}
    response[2].text = "The believers of the Strangers?"
    response[2].handle = "Ignore"

    response[3] = {}
    response[3].text = "Those who didn't believe in any gods?"
    response[3].handle = "Ignore"

    response[4] = {}
    response[4].text = "The believers of the elemental gods?"
    response[4].handle = "Finish" 

    response[5] = {}
    response[5].text = "Whoever didn't follow the Way."
    response[5].handle = "Ignore" 


    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenFinishDialog(user)
    user:SetObjVar("Intro|Hal-Thur the Judge",true)

    ChangeFactionByAmount(user,1,"Wayun")

    text = "[$604]"

    response = {}

    response[1] = {}
    response[1].text = "Why did the Strangers send me?"
    response[1].handle = "SendMe"

    response[2] = {}
    response[2].text = "How do you talk to the Strangers?"
    response[2].handle = "TalkToStrangers"

    response[3] = {}
    response[3].text = "Interesting. Thank you."
    response[3].handle = "Nevermind"


    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenSendMeDialog(user)
    DialogReturnMessage(this,user,"[$605]")
end

function Dialog.OpenIgnoreDialog(user)
    --DebugMessage(1)
    --user:SetObjVar("CatacombsIgnorePlayerInteract",true)
    this:NpcSpeech("FIND THE SCRIPTURE AND READ IT!")
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
    response[1].text = "...Does anyone listen to you?"
    response[1].handle = "Listen" 

    response[2] = {}
    response[2].text = "...Why are you a judge?"
    response[2].handle = "How" 

    response[3] = {}
    response[3].text = "...The Wayward?"
    response[3].handle = "Wayward"

    response[4] = {}
    response[4].text = "...The Priest?"
    response[4].handle = "Priest" 

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

function Dialog.OpenListenDialog(user)
	DialogReturnMessage(this,user,"[$606]","...Right.")
end
function Dialog.OpenWaywardDialog(user)
    DialogReturnMessage(this,user,"[$607]","Right.")
end
function Dialog.OpenPriestDialog(user)
    DialogReturnMessage(this,user,"[$608]","Yeah exactly.")
end
function Dialog.OpenMonstersDialog(user)
    DialogReturnMessage(this,user,"[$609]","Whatever.")
end
function Dialog.OpenSpareTimeDialog(user)
	DialogReturnMessage(this,user,AI.SpareTimeMessages[math.random(1,#AI.SpareTimeMessages)],"Interesting.")
end
function Dialog.OpenFamilyDialog(user)
    DialogReturnMessage(this,user,AI.FamilyMessage[math.random(1,#AI.FamilyMessage)])
end
function Dialog.OpenHowDialog(user)
	DialogReturnMessage(this,user,AI.HowMessages[math.random(1,#AI.HowMessages)],"Oh.")
end
function Dialog.OpenStoryDialog(user)
	DialogReturnMessage(this,user,AI.StoryMessages[math.random(1,#AI.StoryMessages)],"Oh.")
end
function Dialog.OpenLastNameDialog(user)
    DialogReturnMessage(this,user,"[$610]","Oh, alright.")
end

OverrideEventHandler("base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)

