require 'NOS:ai_guard'
require 'NOS:incl_faction'

AI.Settings.CanConverse = false

guardNames = { "Thanuis",
               "Luke",
               "Ranus",
               "Dorus",
               "Asor",
               "Alber",
               "Jerroy",
               "Goroy",
               "Athan",
               "Soner",
               "Epher",
               "Tonand",
               "Sephua",
               "Jesse",
               "Ramirez",
               "Brookson" }

femaleGuardNames = {
    "Lynie",
    "Sara",
    "Jane",
    "Mildri",
    "Kimby",
    "Jacquel",
    "Jorlanda",
}

AI.ProsecuteMessages =
{
    "[$52]",
    "[$53]",
    "[$54]",
    "[$55]",
    "[$56]",
    "[$57]",
    "[$58]",
    "[$59]",
    "[$60]"
}

AI.DelayMessages = {
  "Hurry the hell up...", 
}

playerResponses = 
{
    "Whatever you thug.",
}

playerKilledMessages = {
--    { Text="Acts of aggression will not be tolerated on Uaran.", Audio="GuardPlayerKilledMessage1" },
    { Text="That'll show you...", Audio=nil},
}

traitorKilledMessages = {
    "Hah! Yeah!"
}

AI.SetSetting("StationedLeash",true)

function HandleModuleLoaded()
    --DebugMessage("GUARD LOADED")
    if (IsFemale(this)) then
        guardNames = femaleGuardNames
    end
    this:SetName(guardNames[math.random(1, #guardNames)].." the Bouncer")

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
    --DebugMessage("A")
    local attackerDist = this:DistanceFrom(attacker)
    --DebugMessage("B")
    if( attackerDist < 40) then
        --DebugMessage("C")
        AI.AddThreat(attacker,100)
        if (attacker:IsPlayer() ) then--and not(IsImmortal(attacker))) then
            --DebugMessage("D")
            FinePlayer(attacker,crimeIndex,victim) --
        else
            --DebugMessage("Attacking enemy ",attacker:GetName())
            AttackEnemy(attacker,true)
        end
    end
end
OverrideEventHandler( "ai_guard", EventType.Message, "RequestHelp", HandleRequestHelp)

function HandleInteract(user,usedType)
    if(usedType ~= "Interact") then return end
    this:NpcSpeech("[$61]")
end
OverrideEventHandler( "base_ai_conversation", EventType.Message, "UseObject", HandleInteract)

function HandleVictimKilled(victim)
    if( victim ~= nil ) then
        FineTarget = nil
        this:SendMessage("ClearTarget")
        if( victim:IsPlayer() ) then
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