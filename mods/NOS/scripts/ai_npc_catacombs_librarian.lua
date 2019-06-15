require 'base_ai_npc'

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = false
AI.Settings.SetIntroObjVar = false
AI.Settings.EnableBuy = true
AI.Settings.StationedLeash = true
AI.Settings.CanConverse = false

fixPrice = 20

NPCTasks = {

--[[BooksOfWayunTask = {
        TaskName = "BooksOfWayunTask",
        TaskDisplayName = "Books of the Wayun",
        Description = "Find a copy of each Wayun scripture.",
        FinishDescription = "Bring them back to Hal-Thur",
        RewardType = "kho_token",
        RewardAmount = 8,
        Repeatable = true, --if you can redo the task
        Importance = 1, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$611]",
        TaskAcceptSpeech = "[$612]",
        TaskCurrentSpeech = "Have you found each of the books I seek?",
        TaskContinueSpeech = "[$613]",
        TaskCancelSpeech = "[$614]",
        TaskHelpSpeech = "[$615]",
        TaskPreCompleteSpeech = "[$616]",
        TaskFinishedMessage = "[$617]",
        TaskIncompleteMessage = "[$618]",
        TaskAssists = {
                      {Template = "catacombs_priest",Text = "[$619]"},
                      {Template = "catacombs_ponderer",Text = "[$620]"},
                     },
        CheckCompletionCallback = "Items",
        CompletionCallback = "Items",
        TaskItemList = {{"book_law_of_wayun",1}},
        Faction = "Wayun",
        FactionOnFinish = 4,
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
	"[$621]"
} 

AI.GreetingMessages = 
{
	"If it isn't you! What do you require?",
    "What do you want in my library?",
    "[$622]"
}

AI.CantAffordPurchaseMessages = {
	"[$623]",
}
AI.AskHelpMessages =
{
	"What do you require of me?",
    "You need something? What do you need?"
}

AI.RefuseTrainMessage = {
	"[$624]",
}

AI.WellTrainedMessage = {
	"[$625]",
}

AI.CannotAffordMessages = {
    "[$626]"
}

AI.TrainScopeMessages = {
	"I can teach you these things...",
}

AI.NevermindMessages = 
{
    "Anything else that you need?",
}

AI.TalkMessages = 
{
	"[$627]",
}

AI.WhoMessages = {
	"[$628]" ,
}

AI.PersonalQuestion = {
	"...You wish to ask me a personal question?",
}

AI.HowMessages = {
        "[$629]"
	}

AI.FamilyMessage = {
    "[$630]"
}

AI.SpareTimeMessages= {
	"[$631]",
}

AI.WhatMessages = {
	"I seek out knowledge, what do YOU seek?",
}

AI.StoryMessages = {
	"[$632]",
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
    user:SendMessage("AdvanceQuest","CatacombsStartQuest","ReadScripture","Investigate")
    user:SendMessage("AdvanceQuest","CatacombsStartQuest","ReadScripture","TalkToSomeone")
    --if (user:HasObjVar("CatacombsIgnorePlayerInteract")) then
    --    Dialog.OpenIgnoreDialog(user)
    --    return
    --end
    if ( user:GetObjVar("OpenedDialog|Hal-Thur the Judge")) then
        text = "Are you prepared for this trial that awaits you?"
    else
        text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
    end
    user:SetObjVar("OpenedDialog|Hun-Tirus the Librarian",true)

    response = {}

    response[1] = {}
    response[1].text = "I'll answer the question."
    response[1].handle = "Question1"

    response[2] = {}
    response[2].text = "Who are you?"
    response[2].handle = "Ignore"

    response[3] = {}
    response[3].text = "Nice to meet you."
    response[3].handle = "Ignore" 


    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenQuestion1Dialog(user)

    text = "Question 1: Who are the Wayun?"

    response = {}

    response[1] = {}
    response[1].text = "The Strangers."
    response[1].handle = "Question2"

    response[2] = {}
    response[2].text = "The Elder Gods."
    response[2].handle = "Ignore"

    response[3] = {}
    response[3].text = "The Elemental Gods."
    response[3].handle = "Ignore"

    response[4] = {}
    response[4].text = "Great heros."
    response[4].handle = "Ignore" 

    response[5] = {}
    response[5].text = "Erm... I don't know."
    response[5].handle = "Ignore" 


    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenQuestion2Dialog(user)
    text = "[$633]"

    response = {}

    response[1] = {}
    response[1].text = "Himself."
    response[1].handle = "Question3"

    response[2] = {}
    response[2].text = "A cloud of smoke."
    response[2].handle = "Ignore"

    response[3] = {}
    response[3].text = "A beautiful woman."
    response[3].handle = "Ignore"

    response[4] = {}
    response[4].text = "Creatures from the stars?"
    response[4].handle = "Ignore" 

    response[5] = {}
    response[5].text = "Erm... I don't know."
    response[5].handle = "Ignore" 


    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenQuestion3Dialog(user)
    text = "Finally! Question 3: Why did the Wayun leave us?"

    response = {}

    response[1] = {}
    response[1].text = "They had better things to do?"
    response[1].handle = "Ignore"

    response[2] = {}
    response[2].text = "They had completed their work?"
    response[2].handle = "Finish"

    response[3] = {}
    response[3].text = "The Elemental Gods appeared?"
    response[3].handle = "Ignore"

    response[4] = {}
    response[4].text = "They had others to take care of?"
    response[4].handle = "Ignore" 

    response[5] = {}
    response[5].text = "Their part of the Way ended."
    response[5].handle = "Ignore" 


    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenFinishDialog(user)
    user:SetObjVar("Intro|Hun-Tirus the Librarian",true)
    CheckAchievementStatus(user, "Other", "StudentOfWayun", nil, {Description = "", CustomAchievement = "Student Of Wayun", Reward = {Title = "Student Of Wayun"}})
    ChangeFactionByAmount(user,1,"Wayun")
    user:SendMessage("AdvanceQuest","CatacombsStartQuest","TalkToPriest")
    text = "[$634]"

    response = {}

    response[1] = {}
    response[1].text = "Where am I?"
    response[1].handle = "Where"

    --response[2] = {}
    --response[2].text = "Why did the Strangers send me?"
    --response[2].handle = "SendMe"

    --response[3] = {}
    --response[3].text = "How do you talk to the Strangers?"
    --response[3].handle = "TalkToStrangers"

    response[4] = {}
    response[4].text = "Great, bye!"
    response[4].handle = "Nevermind"


    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenSendMeDialog(user)
    DialogReturnMessage(this,user,"[$635]","Oh.")
end

function Dialog.OpenTalkToStrangersDialog(user)
    DialogReturnMessage(this,user,"[$636]","Alright then.")
end

function Dialog.OpenIgnoreDialog(user)
    --user:SetObjVar("CatacombsIgnorePlayerInteract",true)
    this:NpcSpeech("GO AND READ THE BOOKS!!!")
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
    response[1].text = "...Who wrote these books?"
    response[1].handle = "Books" 

    response[2] = {}
    response[2].text = "...You people here?"
    response[2].handle = "Wayward"

    response[3] = {}
    response[3].text = "...Why are you a Librarian?"
    response[3].handle = "How" 

    response[4] = {}
    response[4].text = "...The Priest?"
    response[4].handle = "Priest" 

    response[5] = {}
    response[5].text = "...That strange merchant?"
    response[5].handle = "Paul"

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
    response[2].text = "How did you end up the librarian?"
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
    DialogReturnMessage(this,user,"[$637]","Oh crap.")
end
function Dialog.OpenBooksDialog(user)
	DialogReturnMessage(this,user,"[$638]","...Right.")
end
function Dialog.OpenWaywardDialog(user)
    DialogReturnMessage(this,user,"[$639]","Um, right. OK.")
end
function Dialog.OpenPriestDialog(user)
    DialogReturnMessage(this,user,"[$640]","Yeah exactly.")
end
function Dialog.OpenPaulDialog(user)
    DialogReturnMessage(this,user,"[$641]","Whatever.")
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
    DialogReturnMessage(this,user,"[$642]","Oh, alright.")
end

OverrideEventHandler("base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)

