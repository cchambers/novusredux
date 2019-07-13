require 'NOS:base_ai_npc'

AI.Settings.MerchantEnabled = false
AI.Settings.EnableTrain = false
AI.Settings.EnableBuy = false
AI.Settings.SetIntroObjVar = false
AI.Settings.StationedLeash = true

fixPrice = 20

function IsFriend(target)
    --DebugMessage("IsPlayer: ",target:IsPlayer()," GetPlayerQuestState:",(GetPlayerQuestState(target) == "CastHealOnLegas" or GetPlayerQuestState(target) =="TalkToLegas")," AI.Anger: ",AI.Anger)
    if (target:IsPlayer() and (GetPlayerQuestState(target,"MageIntroQuest") == "CastHealOnLegas" or GetPlayerQuestState(target,"MageIntroQuest") =="TalkToLegas") and AI.Anger < 45) then 
        return true
    end
    --My only enemy is the enemy
    if (AI.InAggroList(target)) then
        return false
    else
        return true
    end
end

RegisterEventHandler(EventType.Message,"DamageInflicted",function (attacker)
    --DebugMessage("IsPlayer: ",attacker:IsPlayer()," GetPlayerQuestState:",(GetPlayerQuestState(attacker,"MageIntroQuest") == "CastHealOnLegas" or GetPlayerQuestState(attacker,"MageIntroQuest") =="TalkToLegas")," AI.Anger: ",AI.Anger)
    if (attacker:IsPlayer() and (GetPlayerQuestState(attacker,"MageIntroQuest") == "CastHealOnLegas" or GetPlayerQuestState(attacker,"MageIntroQuest") =="TalkToLegas") and AI.Anger < 45) then 
        this:NpcSpeech("OUCH! I said HEAL me, not hit me!")
    end
end)

NPCTasks = {
}


AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$149]"

} 

AI.TradeMessages = 
{
	"I'm not interested in trading.",
}

AI.GreetingMessages = 
{
	"Salutations my friend. What can I help you with?",
	"Hello again, my friend. What can I help you with?",
}

AI.NotInterestedMessage = 
{
	"I'm not interesed.",
}

AI.NotYoursMessage = {
	"That's not yours to sell!",
}

AI.CantAffordPurchaseMessages = {
	"If you can't afford it, then it's not my problem.",
}

AI.AskHelpMessages =
{
	"[$150]",
}

AI.RefuseTrainMessage = {
	"[$151]",
}

AI.WellTrainedMessage = {
	"[$152]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"I know these things of which I can teach you...",
}

AI.NevermindMessages = 
{
    "Nevermind indeed. Anything else?",
    "Anything else?",
}

AI.TalkMessages = 
{
	"Certainly. I'm open to talking...",
}

AI.WhoMessages = {
	"[$153]",
}

AI.PersonalQuestion = {
	"[$154]",
}

AI.HowMessages = {
	"[$155]",
}

AI.FamilyMessage = {
	"[$156]",
}

AI.SpareTimeMessages= {
	"[$157]",
}

AI.WhatMessages = {
	"What exactly do you want?",
}

AI.StoryMessages = {
	"[$158]"
}

--[[function IntroDialog(user)

    if (user:HasObjVar("OpenedDialog|Vivia The Witch")) then
        text = "[$159]"
    else
        text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
    end
    user:SetObjVar("OpenedDialog|Legas the Sorcerer",true)

    response = {}

    response[1] = {}
    response[1].text = "Yes, I'm here to learn magic."
    response[1].handle = "StartMagicQuest" 

    response[2] = {}
    response[2].text = "No, thank you."
    response[2].handle = "Nevermind"

    response[3] = {}
    response[3].text = "Goodbye."
    response[3].handle = "ResetIntro" 

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenMageIntroQuestFindTheMagicGuyDialog(user)
    IntroDialog(user)    
end

function Dialog.OpenMageIntroQuestAchieveSkillLevelDialog(user)
    QuickDialogMessage(this,user,"[$160]")
end

function Dialog.OpenMageIntroQuestTalkToLegas2Dialog(user)
    QuickDialogMessage(this,user,"[$161]")
    user:SetObjVar("LegasFinished",true)
end

function Dialog.OpenMageIntroQuestTalkToLegas3Dialog(user)
   QuickDialogMessage(this,user,"[$162]")
   user:SetObjVar("LegasFinished",true)
end

function Dialog.OpenMageIntroQuestCastHealOnLegasDialog(user)
   QuickDialogMessage(this,user,"[$163]")
end

RegisterEventHandler(EventType.Message,"AttackedBySpell",
    function(attacker,abilityName)
        if (abilityName == "Heal") then
            attacker:SendMessage("AdvanceQuest","MageIntroQuest","TalkToLegas","CastHealOnLegas")
        end
    end)


function Dialog.OpenMageIntroQuestTalkToLegasDialog(user)
    QuickDialogMessage(this,user,"[$164]")   
    user:SetObjVar("LegasFinished",true)
    local ProfessionQuestsComplete = user:GetObjVar("ProfessionQuestsComplete") or 0
    user:SetObjVar("ProfessionQuestsComplete",ProfessionQuestsComplete + 1)
end

function Dialog.OpenStartMagicQuestDialog(user)
    user:SendMessage("StartQuest","MageIntroQuest")
    CreateObjInBackpack(user,"lscroll_fireball","spawn_items") 
    QuickDialogMessage(this,user,"[$165]")
    --user:SendMessage("AdvanceQuest","MageIntroQuest","")
    user:SetObjVar("Intro|Legas the Sorcerer",true)
end]]

function Dialog.OpenHelpDialog(user)	

	text = AI.AskHelpMessages[math.random(1,#AI.AskHelpMessages)]
	
	response = {}

	response[1] = {}
	response[1].text = "I want to learn witchcraft."
	response[1].handle = "Train" 


	response[4] = {}
	response[4].text = "Nevermind."
	response[4].handle = "Nevermind" 

	NPCInteraction(text,this,user,"Responses",response)

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

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenWhatDialog(user)
    --DebugMessage("WhatDialog")
    text = AI.WhatMessages[math.random(1,#AI.WhatMessages)]

    response = {}

    response[1] = {}
    response[1].text = "...This arena?"
    response[1].handle = "Arena" 

    response[2] = {}
    response[2].text = "...The Gods?"
    response[2].handle = "Gods" 

    response[3] = {}
    response[3].text = "...Being a sorcerer?"
    response[3].handle = "Sorcerer"

    response[6] = {}
    response[6].text = "Nevermind."
    response[6].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "What's your story?"
    response[1].handle = "Story" 

    response[2] = {}
    response[2].text = "Why are you a sorcerer?"
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

    NPCInteractionLongButton(text,this,user,"Responses",response)

end

function Dialog.OpenCantDialog(user)
    --DFB TODO: Make this dialog disappear and implement it based on a per-task basis!
    DialogReturnMessage(this,user,"[$166]","Right.")
end
function Dialog.OpenCeladorDialog(user)
	DialogReturnMessage(this,user,"[$167]","Right.")
end
Dialog.OpenWhereDialog = Dialog.OpenCeladorDialog
function Dialog.OpenArenaDialog(user)
	DialogReturnMessage(this,user,"[$168]","Right.")
end
function Dialog.OpenGodsDialog(user)
	DialogReturnMessage(this,user,"[$169]","Okay.")
end
function Dialog.OpenSorcererDialog(user)
	DialogReturnMessage(this,user,"[$170]","Interesting.")
end
function Dialog.OpenMagicDialog(user)
    DialogReturnMessage(this,user,"[$171]","Oh.")
end
function Dialog.OpenFamilyDialog(user)
	DialogEndMessage(this,user,AI.FamilyMessage[math.random(1,#AI.FamilyMessage)],"Oh... Sorry.")
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
	DialogReturnMessage(this,user,"[$172]","Oh.")
end
