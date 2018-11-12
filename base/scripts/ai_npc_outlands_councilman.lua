require 'base_ai_npc'

AI.Settings.MerchantEnabled = false
AI.Settings.EnableTrain = false
AI.Settings.SetIntroObjVar = true
AI.Settings.EnableBuy = false
AI.Settings.StationedLeash = true
AI.Settings.CanConverse = false

fixPrice = 20

NPCTasks = {
}

--AI.QuestList = {}
AI.Settings.KnowName = true 
--AI.Settings.HasQuest = false
--AI.QuestMessages = {", come here."}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"Hello there. What can I help you with?"
} 

AI.GreetingMessages = 
{
	"[$1180]",
}

AI.CantAffordPurchaseMessages = {
	"We still have a use for money out here. Sorry.",
}

AI.AskHelpMessages =
{
	"Well what can I help you with?",
}

AI.RefuseTrainMessage = {
	"[$1181]",
}

AI.WellTrainedMessage = {
	"[$1182]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"What would you like to be trained in, comrade?",
}

AI.NevermindMessages = 
{
    "Alright then, anything else?",
}

AI.TalkMessages = 
{
	"...Well what would you like to talk about.",
}

AI.WhoMessages = {
	"I am Councilman Beauregard. You know this, right?" ,
}

AI.PersonalQuestion = {
	"...If you wish to know, so be it. Ask.",
}

AI.HowMessages = {
        ""
	}

AI.FamilyMessage = {
    "[$1183]"
}

AI.SpareTimeMessages= {
	"[$1184]",
}

AI.WhatMessages = {
	"Well what would you like to know?",
}

AI.StoryMessages = {
	"[$1185]",
}  


RegisterEventHandler(EventType.Message, "DamageInflicted",
    function (damager)
        if AI.IsValidTarget(damager) then
            local myTeamType = this:GetObjVar("MobileTeamType")
            local nearbyTeamMembers = FindObjects(SearchMulti(
            {
                SearchMobileInRange(20), --in 10 units
                SearchObjVar("MobileTeamType",myTeamType), --find others with my team type
            }))
            for i,j in pairs (nearbyTeamMembers) do
                j:SendMessage("AttackEnemy",damager) --defend me
            end
        end

        if (damager ~= nil and damager:IsValid()) then
            local targetFaction = GetFaction(alertTarget,this:GetObjVar("MobileTeamType")) 

            if (targetFaction == nil) then targetFaction = 0 end
     

            --bottoms out at -30
            if (targetFaction < -30) then
                targetFaction = -30
            end
            DebugMessageA(this,"RebelsFavorability is "..targetFaction)
            ChangeFactionByAmount(damager,-4,this:GetObjVar("MobileTeamType"))
        end
    end)


--[[function IntroDialog(user)
    user:SendMessage("StartQuest","OutlandsRebelQuest")
    text = "[$1186]"

    response = {}

    response[1] = {}
    response[1].text = "Sure thing."
    response[1].handle = "DeliverMessage"

    response[2] = {}
    response[2].text = "No thank you."
    response[2].handle = ""

    response[3] = {}
    response[3].text = "You traitor!"
    response[3].handle = "Traitor"

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end
Dialog.OpenOutlandsRebelQuestInvestigateDialog = IntroDialog
Dialog.OpenOutlandsRebelQuestReenterDialog = IntroDialog

function Dialog.OpenDeliverMessageDialog(user)
    user:SendMessage("AdvanceQuest","OutlandsRebelQuest","BringMessageToRufus","Investigate")
    DialogReturnMessage(this,user,"[$1187]","Alright then.")
    noteContents1 = "[$1188]"
    noteContents2 = "[$1189]"   
    CreateObjInBackpack(user,"scroll_readable","ContactNote",noteContents1) 
    CreateObjInBackpack(user,"scroll_readable","ContactNote",noteContents2) 
end

RegisterEventHandler(EventType.CreatedObject,"ContactNote",
    function(success,objRef,noteContents)
        if (success) then
            objRef:SendMessage("WriteNote",noteContents)
        end
    end)]]

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

    --response[4] = {}
    --response[4].text = "...How can I help the rebellion?"
    --response[4].handle = "StartKillMayorQuest"

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

--[[function Dialog.OpenStartKillMayorQuestDialog(user)
    user:SendMessage("StartQuest","KillMayorQuest")
    text = "[$1190]"

    response = {}

    response[1] = {}
    response[1].text = "I'll do it quick."
    response[1].handle = "KillTheMayor"

    response[2] = {}
    response[2].text = "I'm not interested."
    response[2].handle = ""

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenKillTheMayorDialog(user)
    user:SendMessage("AdvanceQuest","KillMayorQuest","SlayMayor")
    QuickDialogMessage(this,user,"[$1191]")
end

function Dialog.OpenKillMayorQuestReturnForRewardDialog(user)
    QuickDialogMessage(this,user,"[$1192]")
end]]

function Dialog.OpenFoundersQuestGoldenNoteDialog(user)
    QuickDialogMessage(this,user,"[$1193]")
end

function Dialog.OpenWhatDialog(user)
    --DebugMessage("WhatDialog")
    text = AI.WhatMessages[math.random(1,#AI.WhatMessages)]

    response = {}

    response[1] = {}
    response[1].text = "...Rothchilde?"
    response[1].handle = "Rothchilde" 

    response[2] = {}
    response[2].text = "...The Council?"
    response[2].handle = "Council" 

    response[3] = {}
    response[3].text = "...The Mayor?"
    response[3].handle = "Mayor"

    response[4] = {}
    response[4].text = "...The Rebellion?"
    response[4].handle = "Rebellion" 

    response[5] = {}
    response[5].text = "...The Outlands?"
    response[5].handle = "Outlands"

    response[6] = {}
    response[6].text = "...Nevermind"
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
    response[2].text = "Why are you rebelling?"
    response[2].handle = "Rebellion" 

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

function Dialog.OpenRothchildeDialog(user)
	DialogReturnMessage(this,user,"[$1194]","Uh...")
end
function Dialog.OpenCouncilDialog(user)
    DialogReturnMessage(this,user,"[$1195]","...Right.")
end
function Dialog.OpenMayorDialog(user)
    DialogReturnMessage(this,user,"[$1196]","Right.")
end
function Dialog.OpenRebellionDialog(user)
    DialogReturnMessage(this,user,"[$1197]","Interesting.")
end
function Dialog.OpenWhereDialog(user)
    DialogReturnMessage(this,user,"[$1198]","Right.")
end
function Dialog.OpenOutlandsDialog(user)
    DialogReturnMessage(this,user,"[$1199]","Interesting. Thanks")
end
function Dialog.OpenFamilyDialog(user)
    DialogReturnMessage(this,user,AI.FamilyMessage[math.random(1,#AI.FamilyMessage)])
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
    DialogReturnMessage(this,user,"[$1200]","...Um.")
end
function Dialog.OpenOutlandsRebelQuestSpeakToBeauregardDialog(user)
    text = "[$1201]"

    response = {}

    response[1] = {}
    response[1].text = "Thanks."
    response[1].handle = ""

    response[2] = {}
    response[2].text = "Rothchilde gave me something."
    response[2].handle = "HeadDialog"

    response[3] = {}
    response[3].text = "You traitor!"
    response[3].handle = "Traitor"

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end
function Dialog.OpenHeadDialogDialog(user)
    if (GetItem(user,"head_of_spy")) then
        DialogReturnMessage(this,user,"[$1202]","Just thought you should know...")
        PlayerTitles.EntitleFromTable(user,AllTitles.ActivityTitles.TheMessager)
    else
        this:NpcSpeech("Gave you what?")
    end
end

function Dialog.OpenTraitorDialog(player)
    ChangeFactionByAmount(player,-30,this:GetObjVar("MobileTeamType"))
    this:SendMessage("AttackEnemy",player)
    local nearbyRebels = FindObjects(SearchMulti(
    {
        SearchMobileInRange(20), --in 10 units
        SearchObjVar("MobileTeamType","Rebels"), --find slaver guards
    }))
    for i,j in pairs (nearbyRebels) do
        j:SendMessage("AttackEnemy",player) --defend me
    end
end
OverrideEventHandler("base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)

