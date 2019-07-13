require 'NOS:ai_guard'
require 'NOS:incl_faction'

AI.Settings.CanConverse = false

guardNames = { "Sal-Than",
               "Cul-Thaus",
               "Al-Narus",
               "Un-Gul",
               "Tha-Tais",
               "Ala-Tus",
               "Gal-Far",
               "Onu-Galus",
               "Nal-Teer",
               "Fal-Gaus",
               "Pul-Wat",
               "Nor-Thanus",
               "Oru-Viaus",
               "Aus-Vall",
               "Tan-Wul",
               "Ban-Far" }

femaleGuardNames = {
    "Tara-Gani",
    "Luv-Ani",
    "Ort-Anii",
    "Lu-Gali",
    "Pert-Hausa",
    "Pan-Thusa",
    "Nor-Taski",
    "Tal-Falli",
    "Maaus-Fali",
    "Onus-Fali",
    "Tal-Naski",
    "Dian-Dusi",
    "Oali-Tali",
}

AI.ProsecuteMessages =
{
    "[$20]",
    "[$21]",
    "[$22]",
    "[$23]",
    "[$24]",
    "[$25]",
    "[$26]",
    "[$27]",
    "[$28]"
}

AI.DelayMessages = {
  "I am waiting...",
  "Rush yourself!",  
}

AI.KilledMonsterMessages = {
  "Death to you!",
  "Go back to the shadow!",
  "You have become lost to the Way!",
  "Leave this place for the Great Beyond!",
  "I fear you not, creature!",
  "DIE!",
  "You are nothing to me!",
  "The Wayun shalt be triumphant!",  
  "The Wayun will TRIUMPH.",
  "The Wayun curse you.",
  "THIS TEMPLE IS OURS!",
  "May your soul rest finally.",
  "May you return anew in the next life!"
}

playerResponses = 
{
    "Not a chance.",
    "Whatever, fanatic.",
    "Get out of my face!",
    "Mind your own business.",
    "Grow up.",
}

playerKilledMessages = {
--    { Text="Acts of aggression will not be tolerated on Uaran.", Audio="GuardPlayerKilledMessage1" },
    { Text="Your disobdience to the Way is noted...", Audio=nil},
}

traitorKilledMessages = {
    "Die traitor!"
}

AI.SetSetting("StationedLeash",true)


function IsEnemy(targetObj)
    if (
        ServerSettings.WorldName == "Catacombs"
        and
        not targetObj:IsInRegion("ZealotEncampment")
        and
        not targetObj:IsInRegion("FollowerHubRegion")
    ) then
        return false
    end
    return IsGuardEnemy(targetObj, this, AI)
end


function HandleModuleLoaded()
    --DebugMessage("GUARD LOADED")
    if (IsFemale(this)) then
        guardNames = femaleGuardNames
    end
    this:SetName(guardNames[math.random(1, #guardNames)].." the Zealot")

    --DebugMessage("Creating guard with name of "..this:GetName().."and id of " ..this.Id .." with template name of "..this:GetCreationTemplateId())
    if( ShouldPatrol() ) then
        this:SetObjVar("curPathIndex", 1)
        this:SetObjVar("stopChance", 0)
        this:SetObjVar("stopDelay", 3000)
        this:SetObjVar("isRunning", 0)    
        --DebugMessage("ShouldPatrol")  
    else
        this:SetObjVar("homeLoc",this:GetLoc())
        this:SetObjVar("homeFacing",this:GetFacing())
        AI.Settings.StationedLeash = true
        AI.SetSetting("Leash",true)
        --DebugMessage("ShouldNotPatrol")  
    end
end
OverrideEventHandler( "ai_guard", EventType.ModuleAttached, GetCurrentModule(), HandleModuleLoaded)

function HandleRequestHelp(attacker,crimeIndex,victim)
    --DebugMessage(DumpTable(args))
    local attackerDist = this:DistanceFrom(attacker)
    if( attackerDist < 40 and (attacker:IsInRegion("FollowerHubRegion") or attacker:IsInRegion("ZealotEncampment"))) then
        AI.AddThreat(attacker,100)
        if (attacker:IsPlayer() ) then--and not(IsImmortal(attacker))) then
            FinePlayer(attacker,crimeIndex,victim) --
        else
            --DebugMessage("Attacking enemy")
            AttackEnemy(attacker)
        end
    end
end
OverrideEventHandler( "ai_guard", EventType.Message, "RequestHelp", HandleRequestHelp)

function HandleInteract(user,usedType)
    if(usedType ~= "Interact") then return end
     if (not HasFinishedQuest(user,"CatacombsStartQuest") or user:HasObjVar("SkipQuest")) then
        user:SendMessage("AdvanceQuest","CatacombsStartQuest","TalkToSomeone","Investigate")
        this:NpcSpeech("Back off!")
        return
    end
    this:NpcSpeech("I have much to do.")
end
OverrideEventHandler( "base_ai_conversation", EventType.Message, "UseObject", HandleInteract)

function HandleVictimKilled(victim)
    if( victim ~= nil ) then
        FineTarget = nil
        this:SendMessage("ClearTarget")
        if( victim:IsPlayer() ) then
            if (GetFaction(victim) < -40) then
                this:NpcSpeech(traitorKilledMessages[math.random(1,#traitorKilledMessages)])
                return
            end
            local message = playerKilledMessages[math.random(#playerKilledMessages)]
            if (not IsFemale(this)) then
                Speak(message)
            else
                this:NpcSpeech(message.Text)
            end
            victim:CloseDynamicWindow("Prosecute")
        else
            victim:SetObjVar("guardKilled",true)
            if (victim:GetMobileType() == "Monster") then
               this:NpcSpeech(AI.KilledMonsterMessages[math.random(1,#AI.KilledMonsterMessages)])
            end
        end
    end
end

OverrideEventHandler( "ai_guard", EventType.Message, "VictimKilled", HandleVictimKilled)