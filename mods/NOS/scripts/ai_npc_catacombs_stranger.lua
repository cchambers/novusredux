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

AI.QuestList = {}
AI.Settings.KnowName = false 
AI.Settings.HasQuest = false
AI.QuestMessages = {}
AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$732]"
} 

AI.GreetingMessages = 
{
	"[$733]",
    "You have no purpose in being here. Leave.",
    "This is not your struggle. Leave now."
}

AI.CantAffordPurchaseMessages = {
	"",
    "",
    "",
}

AI.AskHelpMessages =
{
	"I have no tasks for you.",
    ""
}

AI.RefuseTrainMessage = {
	"[$734]",
}

AI.WellTrainedMessage = {
	"You already know what I seek to teach you.",
}

AI.CannotAffordMessages = {
    "You do not have enough."
}

AI.TrainScopeMessages = {
	"I can teach you many things.",
}

AI.NevermindMessages = 
{
    "Have you learned enough?",
}

AI.TalkMessages = 
{
	"[$735]",
}

AI.WhoMessages = {
	"[$736]" ,
}

AI.PersonalQuestion = {
	"I have nothing to hide from you, mortal.",
}

AI.HowMessages = {
    "That is not your concern, mortal."
}

AI.FamilyMessage = {
    "That is not your concern, mortal."
}

AI.SpareTimeMessages= {
	"That is not your concern, mortal.",
}

AI.WhatMessages = {
	"That is not your concern, mortal.",
}

AI.StoryMessages = {
	"That is not your concern, mortal.",
}  

RegisterEventHandler(EventType.Timer,"BringDownFromSky",function ( ... )
    this:PlayAnimation("kneel_standup")
    PlayEffectAtLoc("ImpactWaveEffect",this:GetLoc())
    this:PlayEffect("ComeDownFromSkyEffect")
    this:PlayEffect("GoldenFogEffect")
    this:PlayEffectWithArgs("ObjectGlowEffect",0.0,"Color=FFFF00")
end)
this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.1),"BringDownFromSky")

function IntroDialog(user)
    text = "[$737]"

    response = {}


    response[1] = {}
    response[1].text = "What do you mean?"
    response[1].handle = "ExplainCatacombs"

    response[2] = {}
    response[2].text = "...Are you a Stranger?!?"
    response[2].handle = "Stranger" 

    response[3] = {}
    response[3].text = "I have so many questions for you."
    response[3].handle = "Questions" 

    response[4] = {}
    response[4].text = "Can you help me?"
    response[4].handle = "Help"

    response[5] = {}
    response[5].text = "Thanks for nothing. Stupid god."
    response[5].handle = "Slay"

    response[6] = {}
    response[6].text = "Goodbye."
    response[6].handle = "" 

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenExplainCatacombsDialog(user)
    text = "[$738]"

    response = {}

    response[1] = {}
    response[1].text = "What do you need me to do?"
    response[1].handle = "ReturnToCelador"

    response[2] = {}
    response[2].text = "Why keep them here then?"
    response[2].handle = "WhyKeepHere"

    response[3] = {}
    response[3].text = "What are the elder gods?"
    response[3].handle = "Xor"

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenFoundersQuestTalkToKamusDialog(user)
    QuickDialogMessage(this,user,"[$739]")
end

function Dialog.OpenWhyKeepHereDialog(user)
    QuickDialogMessage(this,user,"[$740]")
end

function Dialog.OpenReturnToCeladorDialog(user)
    text = "[$741]"
    
    response = {}
 
    response[1] = {}
    response[1].text = "I will do as you ask."
    response[1].handle = "FinishEncounter"

    response[2] = {}
    response[2].text = "Just one second..."
    response[2].handle = "Nevermind"

    response[2] = {}
    response[2].text = "OK Bye."
    response[2].handle = ""

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenFinishEncounterDialog(user)
    user:SendMessage("AdvanceQuest","SlayTheGeneralQuest","TalkToPriest2")
    noteContents = "[$742]"
    CreateObjInBackpack(user,"scroll_readable","ContactNote","StrangerNote",noteContents) 
    QuickDialogMessage(this,user,"[$743]")
end

RegisterEventHandler(EventType.CreatedObject,"ContactNote",
    function(success,objRef,objVarName,noteContents)
        if (success) then
            objRef:SetObjVar(objVarName,true)
            objRef:SendMessage("WriteNote",noteContents)
        end
    end)

function Dialog.OpenHelpDialog(user)
    QuickDialogMessage(this,user,"[$744]")
end

function Dialog.OpenGreetingDialog(user)
    text = "Anything else, mortal?"

    response = {}
 

    response[1] = {}
    response[1].text = "What of this place?"
    response[1].handle = "ExplainCatacombs"

    response[2] = {}
    response[2].text = "I have so many questions for you."
    response[2].handle = "Questions" 

    response[3] = {}
    response[3].text = "...Are you a Stranger?"
    response[3].handle = "Stranger"

    response[4] = {}
    response[4].text = "Can you help me?"
    response[4].handle = "Help"

    response[5] = {}
    response[5].text = "Thanks for nothing. Stupid god."
    response[5].handle = "Slay"

    response[6] = {}
    response[6].text = "Goodbye."
    response[6].handle = "" 

    NPCInteraction(text,this,user,"Responses",response)
end
NevermindDialog = Dialog.OpenGreetingDialog 

function Dialog.OpenStrangerDialog(user)
    QuickDialogMessage(this,user,"[$745]")
end

function Dialog.OpenSlayDialog(user)
    this:NpcSpeech("Do not insult your patrons, mortal.")
    this:PlayAnimation("no_two")
    user:SendMessage("ProcessTrueDamage", this, 5000, true) 
    CallFunctionDelayed(TimeSpan.FromSeconds(3),
        function()
            this:NpcSpeech("Consider this a warning...")
            user:SendMessage("Resurrect")
        end)
end

function Dialog.OpenQuestionsDialog(user)
    text = "[$746]"

    response = {}

    response[1] = {}
    response[1].text = "Why did you build the gateways?"
    response[1].handle = "Gates" 

    response[2] = {}
    response[2].text = "Where did you come from?"
    response[2].handle = "ComeFrom" 

    response[3] = {}
    response[3].text = "Where did I come from?"
    response[3].handle = "ExplainOrigin"

    response[4] = {}
    response[4].text = "What happens after we die?"
    response[4].handle = "GreatBeyond"

    response[5] = {}
    response[5].text = "Can I become a god too?"
    response[5].handle = "BecomeAGod"

    response[6] = {}
    response[6].text = "Nevermind."
    response[6].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenBecomeAGodDialog(user)
    QuickDialogMessage(this,user,"[$747]")
end

function Dialog.OpenGatesDialog(user)
    text = "[$748]"

    response = {}

    response[1] = {}
    response[1].text = "Who is our mutual 'enemy'?"
    response[1].handle = "Xor" 

    response[2] = {}
    response[2].text = "Where did you come from?"
    response[2].handle = "ComeFrom" 

    response[3] = {}
    response[3].text = "What shattered Aria?"
    response[3].handle = "XorShatter"

    response[4] = {}
    response[4].text = "I'm from Aria?"
    response[4].handle = "ExplainOrigin"

    response[5] = {}
    response[5].text = "But you enslaved us!"
    response[5].handle = "Enslaved"

    response[6] = {}
    response[6].text = "Nevermind."
    response[6].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenXorShatterDialog(user)
    QuickDialogMessage(this,user,"[$749]")
end

function Dialog.OpenEnslavedDialog(user)
    QuickDialogMessage(this,user,"[$750]")
end

function Dialog.OpenXorMoreDialog(user)
    QuickDialogMessage(this,user,"[$751]")
end

function Dialog.OpenXorDialog(user)
    text = "[$752]"
    
    response = {}

    response[1] = {}
    response[1].text = "Tell me more about the Elder Gods."
    response[1].handle = "XorMore" 

    response[2] = {}
    response[2].text = "What is my purpose then."
    response[2].handle = "ExplainOrigin" 

    response[3] = {}
    response[3].text = "Then what of Kho and the Wayward?"
    response[3].handle = "ExplainCatacombs"

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenComeFromDialog(user)
    text = "[$753]"

    response = {}

    response[1] = {}
    response[1].text = "Can I go to the Gateworld?"
    response[1].handle = "Gateworld" 

    response[2] = {}
    response[2].text = "What is the Great Beyond?"
    response[2].handle = "GreatBeyond" 

    response[3] = {}
    response[3].text = "...What was your world like?"
    response[3].handle = "OriginWorld" 

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenGateworldDialog(user)
    QuickDialogMessage(this,user,"[$754]")
end

function Dialog.OpenOriginWorldDialog(user)
    QuickDialogMessage(this,user,"[$755]")--We have a name for it in our language that we have passed down since time immemorial, that which we passed down to you, and is used commonly througout your world. \n\n\"Earth\". \n\nIn our language, it meant ground, but in truth, it was far more than just that. Our sacred home, that we will never forget.")
end

function Dialog.OpenExplainOriginDialog(user)
    text = "[$756]"

    response = {}

    response[1] = {}
    response[1].text = "...I was dead?"
    response[1].handle = "WasDead" 

    response[2] = {}
    response[2].text = "What do you need me to do."
    response[2].handle = "ReturnToCelador" 

    response[3] = {}
    response[3].text = "...Why was I cast out?"
    response[3].handle = "Injust" 

    response[4] = {}
    response[4].text = "Right thanks."
    response[4].handle = "Nevermind"

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenWasDeadDialog(user)
    QuickDialogMessage(this,user,"[$757]")
end

function Dialog.OpenInjustDialog(user)
    text = "[$758]"

    response = {}

    response[1] = {}
    response[1].text = "I need to know who I was."
    response[1].handle = "NeedToKnow" 

    response[2] = {}
    response[2].text = "Well... thanks for your mercy."
    response[2].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenNeedToKnowDialog(user)
    QuickDialogMessage(this,user,"[$759]")
end

function Dialog.OpenGreatBeyondDialog(user)
    text = "[$760]"

    response = {}

    response[1] = {}
    response[1].text = "You built the afterlife?"
    response[1].handle = "WasDead" 

    response[1] = {}
    response[1].text = "What happens if you aren't worthy?"
    response[1].handle = "NotWorthy" 

    response[2] = {}
    response[2].text = "Interesting. Thanks."
    response[2].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenGreatBeyondDialog(user)
    text = "[$761]"

    response = {}

    response[1] = {}
    response[1].text = "Who are you to judge us!"
    response[1].handle = "ExplainOrigin" 

    response[2] = {}
    response[2].text = "What makes someone worthy?"
    response[2].handle = "Worthy"

    response[3] = {}
    response[3].text = "Interesting. Thanks."
    response[3].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenWorthyDialog(user)
    QuickDialogMessage(this,user,"[$762]")
end
--hacky effect that makes him come out of the sky
--DebugMessage(1)
--this:SetWorldPosition(Loc(this:GetLoc().X,100,this:GetLoc().Z))
--this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.1),"ComeDownFromSky")
--RegisterEventHandler(EventType.Timer,"ComeDownFromSky",function ( ... )
--    this:SetWorldPosition(Loc(this:GetLoc().X,this:GetLoc().Y-5,this:GetLoc().Z))
--    if (this:GetLoc().Y < 0.1) then
--        this:SetWorldPosition(Loc(this:GetLoc().X,5,this:GetLoc().Z))
--        return 
--    end
--    this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.1),"ComeDownFromSky")
--end)
OverrideEventHandler("NOS:base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)

