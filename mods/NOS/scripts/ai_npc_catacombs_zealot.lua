require 'NOS:base_ai_npc'

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = false
AI.Settings.SetIntroObjVar = false
AI.Settings.EnableBuy = true
AI.Settings.StationedLeash = true
AI.Settings.CanConverse = false

NPCTasks = {
}

AI.QuestList = {}
AI.Settings.KnowName = false 
AI.Settings.HasQuest = false
AI.QuestMessages = {}


AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$763]"
} 

AI.GreetingMessages = 
{
	"[$764]",
    "Indeed it is you. What do you require?",
    "What do you seek, outsider?"
}

AI.CantAffordPurchaseMessages = {
	"",
    "",
    "",
}

AI.AskHelpMessages =
{
	"[$765]",
    "You need our help! We alone have what you seek!"
}

AI.RefuseTrainMessage = {
	"[$766]",
}

AI.WellTrainedMessage = {
	"[$767]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"I know these skills of the Way!",
}

AI.NevermindMessages = 
{
    "Anything else then, outsider?",
    "What else can this Wayward speak to you regarding?"
}

AI.TalkMessages = 
{
	"[$768]",
    "An answer to all your questions is the Way!"
}

AI.WhoMessages = {
	"[$769]" ,
}

AI.PersonalQuestion = {
	"...What is it you ask?",
}

AI.HowMessages = {
        "[$770]"
	}

AI.FamilyMessage = {
    "[$771]"
}

AI.SpareTimeMessages= {
	"[$772]",
}

AI.WhatMessages = {
	"What is it you want!",
}

AI.StoryMessages = {
	"[$773]",
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
        this:NpcSpeech("...")
        user:SendMessage("AdvanceQuest","CatacombsStartQuest","TalkToSomeone","Investigate")
        return
    else
        text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
    end
    user:SetObjVar("Intro|Ina-Ius the Zealot Leader",true)

    response = {}

    response[1] = {}
    response[1].text = "What is this place?"
    response[1].handle = "Where"

    response[2] = {}
    response[2].text = "Who are you?"
    response[2].handle = "Where"

    response[3] = {}
    response[3].text = "Nice to meet you."
    response[3].handle = "Nevermind" 


    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenSaveGuardQuestTalkToHeadZealotDialog(user)
    --DebugMessage(1)
    text = "[$774]"

    user:SetObjVar("Intro|Ina-Ius the Zealot Leader",true)

    response = {}

    response[1] = {}
    response[1].text = "What happened?"
    response[1].handle = "ExplainRescue"

    --response[2] = {}
    --response[2].text = "Who are you?"
    --response[2].handle = "Who"

    --response[3] = {}
    --response[3].text = "Nice to meet you."
    --response[3].handle = "Who" 

    response[4] = {}
    response[4].text = "Just tell me what you need."
    response[4].handle = "NeedMeRescue" 

    response[5] = {}
    response[5].text = "Goodbye."
    response[5].handle = "" 

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenCatacombsSpyQuestInvestigateDialog(user)
    --DebugMessage(1)
    text = "You look troubled, indeed! What bothers you?"

    response = {}

    response[1] = {}
    response[1].text = "There is a spy here."
    response[1].handle = "Spy"

    response[5] = {}
    response[5].text = "Nevermind. Goodbye."
    response[5].handle = "" 

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenSpyDialog(user)
    text = "[$775]"

    response = {}

    response[1] = {}
    response[1].text = "Are you deaf? I have proof!"
    response[1].handle = "Deaf"

    response[2] = {}
    response[2].text = "You don't understand!"
    response[2].handle = "Deaf"

    response[5] = {}
    response[5].text = "Whatever. Goodbye."
    response[5].handle = "" 

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenDeafDialog(user)
    DialogReturnMessage(this,user,"[$776]","Sure. Thanks.")
    --DFB TODO: Change the reward?
    local creationTemplate = "topaz_gem"
    local name = GetTemplateObjectName(creationTemplate)
    CreateObjInBackpackOrAtLocation(user,creationTemplate)
    user:SystemMessage("[D7D700]You have received a "..name,"info")
end

function Dialog.OpenInvestigateMurderQuestTalkToInaiusDialog(user)
    text = "You look troubled, he of the Wayun. What ails you?"

    response = {}

    response[1] = {}
    response[1].text = "I found a man, Tai-Naius."
    response[1].handle = "Murdered"

    response[2] = {}
    response[2].text = "Goodbye."
    response[2].handle = ""

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenMurderedDialog(user)
    text = "[$777]"

    response = {}

    response[1] = {}
    response[1].text = "He was kidnapped and murdered."
    response[1].handle = "Tainaius"

    response[2] = {}
    response[2].text = "...Nevermind."
    response[2].handle = ""

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenTainaiusDialog(user)
    QuickDialogMessage(this,user,"[$778]")
    user:SendMessage("AdvanceQuest","InvestigateMurderQuest","GetMagnifyingGlass","TalkToInaius")
end

function Dialog.OpenExplainRescueDialog(user)
    text = "[$780]"

    response = {}

    response[1] = {}
    response[1].text = "What can I do to help."
    response[1].handle = "NeedMeRescue"

    response[2] = {}
    response[2].text = "Goodbye."
    response[2].handle = ""

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenNeedMeRescueDialog(user)

    text = "[$781]"

    response = {}

    response[1] = {}
    response[1].text = "Alright, I'll help you."
    response[1].handle = "AcceptRescue"

    response[2] = {}
    response[2].text = "No, thank you."
    response[2].handle = ""

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenAcceptRescueDialog(user)
    user:SendMessage("AdvanceQuest","SaveGuardQuest","SaveWarrior","TalkToHeadZealot")
    user:SetObjVar("AccessAllowed|Inaius the Zealot Leader",true)
    QuickDialogMessage(this,user,"[$782]")
    user:SystemMessage("[$783]","info")
end

function Dialog.OpenSaveGuardQuestTalkToInaiusDialog(user)
    CheckAchievementStatus(user, "Other", "ProtectorOfWayward", nil, {Description = "", CustomAchievement = "Protector Of Wayward", Reward = {Title = "Protector Of Wayward"}})
    QuickDialogMessage(this,user,"[$784]")
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
    response[1].text = "...What you believe?"
    response[1].handle = "Beliefs" 

    response[2] = {}
    response[2].text = "...Why you are here?"
    response[2].handle = "Story" 

    response[3] = {}
    response[3].text = "...The Wayward?"
    response[3].handle = "Wayward"

    response[4] = {}
    response[4].text = "...This place?"
    response[4].handle = "Place" 

    response[5] = {}
    response[5].text = "...The fight against Kho?"
    response[5].handle = "Fight"

    response[6] = {}
    response[6].text = "Nevermind."
    response[6].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "Why are you a warrior?"
    response[1].handle = "How" 

    response[2] = {}
    response[2].text = "How did you end up leading them?"
    response[2].handle = "Story" 

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

function Dialog.OpenBeliefsDialog(user)
	QuickDialogMessage(this,user,"[$785]")
end
function Dialog.OpenWaywardDialog(user)
    DialogReturnMessage(this,user,"[$786]","Nice.")
end
function Dialog.OpenWhereDialog(user)
    DialogReturnMessage(this,user,"[$787]","Right.")
end
function Dialog.OpenFightDialog(user)
    DialogReturnMessage(this,user,"[$788]","Yeah right.")
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
    DialogReturnMessage(this,user,"[$789]","Right")
end

OverrideEventHandler("NOS:base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)

