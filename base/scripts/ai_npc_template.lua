require 'base_ai_npc'

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = false
AI.Settings.EnableBuy = false
AI.Settings.StationedLeash = true
AI.Settings.SpeechTable = "VillagerPyros"

--[[NPCTasks = {
    CraftChairs = {
        TaskName = "CraftChairs",
        TaskDisplayName = "Chair Delivery",
        Description = "",
        FinishDescription = "",
        RewardType = "coins",
        RewardAmount = 100,
        Repeatable = true, --if you can redo the task
        Importance = 2, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "Bring me 10 chairs and I will reward you.",
        TaskAcceptSpeech = "Good luck.",
        TaskCurrentSpeech = "Any luck?",
        TaskContinueSpeech = "3",
        TaskCancelSpeech = "Nevermind",
        TaskHelpSpeech = "4",
        TaskPreCompleteSpeech = "5",
        TaskFinishedMessage = "6",
        TaskIncompleteMessage = "6",
        TaskAssists = {
            {Template = "cel_blacksmith",Text = "1"},
        },
        CheckCompletionCallback = "Items",
        CompletionCallback = "Items",
        TaskItemList = {
            {"furniture_chair",10},
        },
        Faction = "Villagers",
        FactionOnFinish = 6,
    },
}--]]

AI.IntroMessages =
{ --note that this is a single string on multiple lines
    "",
} 

AI.TradeMessages = 
{
    "",
    "",
    "",
    "",
}

AI.GreetingMessages = 
{
    "",
    "",
}

AI.HowToPurchaseMessages = {
    ""
}

AI.NotInterestedMessage = 
{
    "",
}

AI.NotYoursMessage = {
    "",
}

AI.CantAffordPurchaseMessages = {
    "",
}

AI.AskHelpMessages =
{
    "",
}

AI.RefuseTrainMessage = {
    "",
}

AI.WellTrainedMessage = {
    "",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
    "",
}

AI.NevermindMessages = 
{
    "",
}

AI.TalkMessages = 
{
    "",
}

AI.WhoMessages = {
    "",
}

AI.PersonalQuestion = {
    "",
}

AI.HowMessages = {
    "",
}

AI.FamilyMessage = {
    "",
    }

AI.SpareTimeMessages= {
    "",
}

AI.WhatMessages = {
    "",
}

AI.StoryMessages = AI.HowMessages

function Dialog.OpenTalkDialog(user)

    text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]

    response = {}

    response[1] = {}
    response[1].text = "...Yes?"
    response[1].handle = "YesMembership" 

    response[2] = {}
    response[2].text = "Don't think so."
    response[2].handle = "NoMembership"

    response[3] = {}
    response[3].text = "I don't know."
    response[3].handle = "IDontKnowMembership"

    response[4] = {}
    response[4].text = "Goodbye."
    response[4].handle = "" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function IntroDialog(user)

    text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]

    response = {}

    response[1] = {}
    response[1].text = "...Yes?"
    response[1].handle = "YesMembership" 

    response[2] = {}
    response[2].text = "Don't think so."
    response[2].handle = "NoMembership"

    response[3] = {}
    response[3].text = "I don't know."
    response[3].handle = "IDontKnowMembership"

    response[4] = {}
    response[4].text = "Goodbye."
    response[4].handle = "" 

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenNoMembershipDialog(user)
    --DebugMessage("WhatDialog")
    text = "HEY MAN"

    response = {}

    response[1] = {}
    response[1].text = "Yes"
    response[1].handle = "Yes" 

    response[2] = {}
    response[2].text = "No"
    response[2].handle = "No" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhatDialog(user)
    --DebugMessage("WhatDialog")
    text = AI.WhatMessages[math.random(1,#AI.WhatMessages)]

    response = {}

    response[1] = {}
    response[1].text = "Becoming a member?"
    response[1].handle = "Member" 

    response[2] = {}
    response[2].text = "What's inside?"
    response[2].handle = "Contents" 

    response[3] = {}
    response[3].text = "Where are you all from?"
    response[3].handle = "Backstory"

    response[6] = {}
    response[6].text = "Nevermind."
    response[6].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "How did you start working here?"
    response[1].handle = "Story" 

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

    NPCInteractionLongButton(text,this,user,"Responses",response)

end
function IntroDialog(user)

    text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]

    response = {}

    response[1] = {}
    response[1].text = "I have a question..."
    response[1].handle = "Talk" 

    response[2] = {}
    response[2].text = "Who are you?"
    response[2].handle = "Who"

    response[3] = {}
    response[3].text = "I need something."
    response[3].handle = "Nevermind"

    response[4] = {}
    response[4].text = "Goodbye."
    response[4].handle = "" 

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end
function Dialog.OpenCantDialog(user)
    --DFB TODO: Make this dialog disappear and implement it based on a per-task basis!
    DialogReturnMessage(this,user,"Sorry I can't do that.","Right.")
end
function Dialog.OpenYesMembershipDialog(user)
    DialogReturnMessage(this,user,"text","Great, thanks.")
end

function Dialog.OpenFamilyDialog(user)
    DialogEndMessage(this,user,AI.FamilyMessage[math.random(1,#AI.FamilyMessage)],"Oh...")
end
function Dialog.OpenSpareTimeDialog(user)
    DialogReturnMessage(this,user,AI.SpareTimeMessages[math.random(1,#AI.SpareTimeMessages)],"Oh.")
end
function Dialog.OpenHowDialog(user)
    DialogReturnMessage(this,user,AI.HowMessages[math.random(1,#AI.HowMessages)],"Oh.")
end
function Dialog.OpenStoryDialog(user)
    DialogReturnMessage(this,user,AI.StoryMessages[math.random(1,#AI.StoryMessages)],"Oh.")
end
function Dialog.OpenLastNameDialog(user)
    DialogReturnMessage(this,user,"","Okay, cool.")
end

OverrideEventHandler("base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)
