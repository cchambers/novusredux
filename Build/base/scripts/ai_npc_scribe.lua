require 'base_ai_npc'

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = true
AI.Settings.SetIntroObjVar = false
AI.Settings.EnableBuy = true
AI.Settings.StationedLeash = true

fixPrice = 20
AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$3384]",
} 

AI.GreetingMessages = 
{
	"[$1465]",
    "Ah, hello again! Care to look at my wares?",
    "[$1466]"
}

AI.CantAffordPurchaseMessages = {
	"[$1467]",
    "[$1468]",
    "[$1469]",
}

AI.RefuseTrainMessage = {
	"[$1470]",
}

AI.WellTrainedMessage = {
	"[$3386]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.CantAffordTrainPurchaseMessages = {
    "[$1724]"
}

AI.TrainScopeMessages = {
	"[$3385]",
}

AI.NevermindMessages = 
{
    "Very well then. What else can I do for you?",
}

AI.TalkMessages = 
{
	"Well sure, what would you like to know, good sir?",
}

function Dialog.OpenGreetingDialog(user)
    text = AI.GreetingMessages[math.random(1,#AI.GreetingMessages)]

    response = {}

    if (AI.GetSetting("MerchantEnabled") ~= nil and AI.GetSetting("MerchantEnabled") == true) then
        response[2] = {}
        response[2].text = "I want to trade..."
        response[2].handle = "Trade" 
    end

    if (AI.GetSetting("EnableTrain") ~= nil and AI.GetSetting("EnableTrain") == true and CanTrain()) then
        response[5] = {}
        response[5].text = "Train me in a skill..."
        response[5].handle = "Train" 
    end

    response[6] = {}
    response[6].text = "Goodbye."
    response[6].handle = "" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function IntroDialog(user)

    text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]

    response = {}

    if (AI.GetSetting("MerchantEnabled") ~= nil and AI.GetSetting("MerchantEnabled") == true) then
        response[2] = {}
        response[2].text = "I want to trade..."
        response[2].handle = "Trade" 
    end
    if (this:GetObjVar("CraftOrderSkill")~= nil) then
        response[4] = {}
        response[4].text = "About crafting orders..."
        response[4].handle = "Work" 
    end

    if (AI.GetSetting("EnableTrain") ~= nil and AI.GetSetting("EnableTrain") == true and CanTrain()) then
        response[5] = {}
        response[5].text = "Train me in a skill..."
        response[5].handle = "Train" 
    end

    response[6] = {}
    response[6].text = "Goodbye."
    response[6].handle = "" 

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function NevermindDialog(user)
    if (user == nil or not user:IsValid()) then return end
    text = AI.NevermindMessages[math.random(1,#AI.NevermindMessages)]

    response = {}

    if (AI.GetSetting("MerchantEnabled") ~= nil and AI.GetSetting("MerchantEnabled") == true) then
        response[2] = {}
        response[2].text = "I want to trade..."
        response[2].handle = "Trade" 
    end
    if (this:GetObjVar("CraftOrderSkill")~= nil) then
        response[4] = {}
        response[4].text = "About crafting orders..."
        response[4].handle = "Work" 
    end

    if (AI.GetSetting("EnableTrain") ~= nil and AI.GetSetting("EnableTrain") == true and CanTrain()) then
        response[5] = {}
        response[5].text = "Train me in a skill..."
        response[5].handle = "Train" 
    end

    response[6] = {}
    response[6].text = "Goodbye."
    response[6].handle = "" 

    NPCInteractionLongButton(text,this,user,"Responses",response)

    this:StopMoving()
    --DebugMessage(tostring(user))
    this:SetFacing(this:GetLoc():YAngleTo(user:GetLoc()))
    AI.StateMachine.ChangeState("Idle")
end
AI.NevermindDialog = NevermindDialog

OverrideEventHandler("base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)

