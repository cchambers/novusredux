require 'base_ai_npc'

AI.Settings.MerchantEnabled = true
AI.Settings.SetIntroObjVar = false
AI.Settings.EnableBuy = true
AI.Settings.StationedLeash = true

fixPrice = 20
AI.IntroMessages =
{ --note that this is a single string on multiple lines
    "I sell all the tool's you'll need to live off of the land. Want to chop wood? Buy a hatchet. Want to make bandages? Better get yourself a hunting knife. Want to mine stone and metals? You'll probablly need a mining pick. Open your coin purse, and gear up friend!"
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


AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.NevermindMessages = 
{
    "Very well then. What else can I do for you?",
}

function Dialog.OpenGreetingDialog(user)
    text = AI.GreetingMessages[math.random(1,#AI.GreetingMessages)]

    response = {}

    if (AI.GetSetting("MerchantEnabled") ~= nil and AI.GetSetting("MerchantEnabled") == true) then
        response[2] = {}
        response[2].text = "I want to trade..."
        response[2].handle = "Trade" 
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

