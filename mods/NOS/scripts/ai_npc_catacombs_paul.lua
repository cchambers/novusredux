require 'base_ai_npc'

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

Names = {
    "Paul",
    "Carl",
    "John",
    "Frank",
    "Earl",
    "Ward",
    "Neal",
}

this:SetName(Names[math.random(1,#Names)].." the Merchant")

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$660]"
} 

AI.GreetingMessages = 
{
	"You... again! How are you?",
}

AI.CantAffordPurchaseMessages = {
	"[$661]",
}

AI.AskHelpMessages =
{
	"What help... do you need?",
}

AI.RefuseTrainMessage = {
	"If not trained... then bad.",
}

AI.WellTrainedMessage = {
	"You know too much.",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"I can teach, these things.",
}

AI.NevermindMessages = 
{
    "What, else?",
}

AI.TalkMessages = 
{
	"I can talk to you about things.",
}

AI.WhoMessages = {
	"I am Paul. I am a merchant... Can't you see?" ,
}

AI.PersonalQuestion = {
	"I can answer... questions.",
}

AI.HowMessages = {
        "I came here... and set up shop."
	}

AI.FamilyMessage = {
    "I have no family... No family."
}

AI.SpareTimeMessages= {
	"I sell stuff here...",
}

AI.WhatMessages = {
	"I have things I can do...",
}

AI.StoryMessages = {
	"I came here... and set up shop.",
}  

function CanBuyItem(buyer,item)
    if (not HasFinishedQuest(buyer,"CatacombsStartQuest")) then
        this:NpcSpeech("...")
        return false
    else
        return true
    end
end
    --I'm secretly a wraith, and you... have... 
function RevealMyself(user,procDam)
    if IsGuard(user) then
        SetCurHealth(this,GetCurHealth(this) + procDam*3/4)
        return
    end
    if (this:HasTimer("StartReveal") and not this:HasObjVar("Revealed")) then
        return
    end
    this:StopEffect("EnergyExplosionEffect")
    this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(3000),"StartReveal",user)
    this:PlayEffect("EnergyExplosionEffect")
    this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(300),"RevealProcess")
    --mHue = 255
    --mScale = 1.0
    AI.Settings.CanConverse = false
end
RegisterEventHandler(EventType.Message,"DamageInflicted",RevealMyself)

RegisterEventHandler(EventType.Message, "HasDiedMessage",
    function(killer)
        --If I'm a boss demon

        local nearbyCombatants = FindObjects(SearchMulti(
            {
                SearchMobileInRange(20), --in 20 units
            }))
            --they took part in killing the vcreature, they deserve credit
            
        for i,j in pairs(nearbyCombatants) do
            j:SystemMessage("Your party has slain the creature!","event")
             j:SendMessage("FinishQuest","InvestigateMurderQuest")
         end
    end)

RegisterEventHandler(EventType.CreatedObject,"created_chest",function (success,objRef)
    if (success) then
        Decay(objRef, 120)
    end
end)

--Should execute 10 times
--RegisterEventHandler(EventType.Timer,"RevealProcess",
--    function()
--        --Makes him bigger and turns him into a wraith over the three seconds before he turns!
---        if (this:HasObjVar("Revealed")) then
--            return 
--        end
--        mHue = mHue - (mHue/10)
--        mScale = mScale + 0.1
--        this:SetColor("0xFF"..string.upper(string.format("%02x%02x%02x",mHue,mHue,mHue)))
--        this:SetScale(Loc(mScale,mScale,mScale))
--        this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(300),"RevealProcess")
--    end)

    --...ANGERED ME!
function StartReveal(user)
    this:PlayEffect("ShockwaveEffect")
    local nearbyTargets = FindObjects(SearchMulti(
      {
            SearchRange(this:GetLoc(), 8),
           SearchModule("combat"),
           SearchModule("pet_controller"),
      }))

    if not( IsTableEmpty(nearbyTargets) ) then

        for i, target in pairs(nearbyTargets) do
            target:PlayAnimation("was_hit")
            target:SetFacing(target:GetLoc():YAngleTo(this:GetLoc()))
            target:AddModule("ca_knockback_effect")
            target:SendMessage("knockback_init", this, 6)
            target:SendMessage("ProcessTrueDamage", this, math.random(10,20), false)
        end
    end
    --roawr
    if (not this:HasObjVar("Revealed")) then
        this:SetObjVar("BaseHealth",800)
        SetCurHealth(this,800)
        this:SetObjVar("DecayTime",1200)
        this:SetScale(Loc(2.0,2.0,2.0))
        this:SetColor("0xFF000000")
        this:SendMessage("AttackEnemy",user)
        this:SetMobileType("Monster")
        IsFriend = function() return false end
        local currentChest = this:GetEquippedObject("Chest")
        local currentLegs = this:GetEquippedObject("Legs")
        local currentHead = this:GetEquippedObject("Head")
        if (currentLegs ~= nil) then
            currentLegs:Destroy()
        end
        if (currentHead ~= nil) then
            currentHead:Destroy()
        end
        if (currentChest ~= nil) then
            currentChest:Destroy()
        end
        CreateEquippedObj("long_robes_crude",this,"clothing_create")
        CreateEquippedObj("weapon_long_spear_finesteel",this,"weapon_create")
        CreateEquippedObj("shield_buckler_finesteel",this,"shield_create")
        CreateEquippedObj("bone_helm_worshipper_fractured",this,"helm_create")
        RegisterSingleEventHandler(EventType.CreatedObject,"clothing_create",function(success,objRef)
            if (success) then
                objRef:SetColor("0xFF0C0C0C")
            end
        end)
        this:SetObjVar("MobileTeamType","UndeadGraveyard")
        AI.SetSetting("MerchantEnabled",false)
        AI.SetSetting("EnableTrain",false)
        AI.SetSetting("SetIntroObjVar",false)
        AI.SetSetting("EnableBuy",false)
        AI.SetSetting("StationedLeash",false)
        AI.SetSetting("CanConverse",false)
        this:SetSharedObjectProperty("Faction","UndeadGraveyard")
        this:DelModule("guard_protect")
        this:SetName("[F04646]Greater Nephilim Wraith of Kho[-]")
    end
    this:SetObjVar("Revealed",true)
end

AddView("FearEffect", SearchMobileInRange(10.0))
RegisterEventHandler(EventType.EnterView, "FearEffect", 
    function(mob)
        if (not mob:IsPlayer() and this:HasObjVar("Revealed") and not IsDead(this)) then
            mob:SendMessage("ForceFlee")
        end
    end)
RegisterEventHandler(EventType.Timer,"MobFleeTimer",function ( ... )
    local objects = GetViewObjects("FearEffect")
    for i,mob in pairs(objects) do
        if (not mob:IsPlayer() and this:HasObjVar("Revealed") and not IsDead(this)) then
            mob:SendMessage("ForceFlee")
        end
    end
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"MobFleeTimer")
end)
this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"MobFleeTimer")
RegisterEventHandler(EventType.Timer,"StartReveal",StartReveal)

function IntroDialog(user)
--[[
     if (not HasFinishedQuest(user,"CatacombsStartQuest") or user:HasObjVar("SkipQuest")) then
        this:NpcSpeech("...")
        user:SendMessage("AdvanceQuest","CatacombsStartQuest","TalkToSomeone","Investigate")
        return
    else]]--
        text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
    --end

    user:SetObjVar("Intro|Wrath Merchant",true)
    response = {}

    response[1] = {}
    response[1].text = "What is this place?"
    response[1].handle = "Where"

    response[2] = {}
    response[2].text = "Who are you?"
    response[2].handle = "Who"

    response[3] = {}
    response[3].text = "Nice... to meet you."
    response[3].handle = "Nevermind" 


    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
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
    response[1].text = "...You manner of speech?"
    response[1].handle = "Speech" 

    response[2] = {}
    response[2].text = "...Why you are here?"
    response[2].handle = "Here" 

    response[3] = {}
    response[3].text = "...The Wayward?"
    response[3].handle = "Wayward"

    response[4] = {}
    response[4].text = "...Kho?"
    response[4].handle = "Kho" 

    response[5] = {}
    response[5].text = "...The monsters beneath?"
    response[5].handle = "Monsters"

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

function Dialog.OpenSpeechDialog(user)
	DialogReturnMessage(this,user,"I talk well... what else?","Uh...")
end
function Dialog.OpenHereDialog(user)
    DialogReturnMessage(this,user,"I came here to sell things... Yes.","...Interesting.")
end
function Dialog.OpenWaywardDialog(user)
    DialogReturnMessage(this,user,"I sell things to Wayward... That is all.","Right.")
end
function Dialog.OpenMonstersDialog(user)
    DialogReturnMessage(this,user,"Misunderstood. What do you mean... 'Monsters'?","...Nevermind.")
end
function Dialog.OpenWhereDialog(user)
    DialogReturnMessage(this,user,"You are here... You are here.","Great! Thanks a bunch!.")
end
function Dialog.OpenKhoDialog(user)
    DialogReturnMessage(this,user,"Kho...\n\n","...is what?")
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
    DialogReturnMessage(this,user,"Hi... my name is Paul. What's... yours.","...Um.")
end

function Dialog.OpenInvestigateMurderQuestSlayPaulDialog(user)
    text = "You... Know... Too... Much..."

    response = {}

    response[1] = {}
    response[1].text = "Prepare to die, whoever you are."
    response[1].handle = "Activate"

    response[2] = {}
    response[2].text = "Goodbye."
    response[2].handle = ""

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenActivateDialog(user)
    this:NpcSpeech("No... YOU... WILL... DIE!!!")
    RevealMyself(user)
end

OverrideEventHandler("base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)

