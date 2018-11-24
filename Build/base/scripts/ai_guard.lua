require 'incl_humanloot'
require 'incl_combatai'
require 'base_ai_npc'

if (this:GetObjVar("MyPath") ~= nil) then
    path = GetPath(this:GetObjVar("MyPath"))
else
    path = GetPath("GuardPath")
end

currentDestinaion = nil
AI.Settings.Debug = false
AI.Settings.AggroChanceAnimals = 100
AI.Settings.CanCast = false
AI.Settings.StartConversations = true
AI.Settings.StationedLeash = false
AI.Settings.Leash = true
AI.Settings.LeashDistance = 40
AI.Settings.ChaseRange = 40
AI.Settings.SpeechTable = "Guard"
AI.Settings.InstaTeleportRange = 5.0
AI.Settings.EnableTrain = true

-- allow guards to see invisible
this:SetObjVar("SeeInvis", true)

-- increase the range of attack ability
for i=1,#AI.CombatStateTable do
    if ( AI.CombatStateTable[i].StateName == "AttackAbility" ) then
        AI.CombatStateTable[i].Range = 20
    end
end

-- add npc charge to guards.
SetInitializerCombatAbilities(this, {"NPCCharge"})

guardNames = { 
    "Apollos",
    "Cornelius",
    "Enoch",
    "Isaac",
    "Ernie",
    "Jeremy",
    "Peter",
    "Ernesto",
    "Julian",
    "Claudius",
    "Daniel",
    "Gearld",
    "Robert",
    "Demetrius",
    "Matthew",
    "Stephen",
    "Victor"
}

femaleGuardNames = {
    "Octavia",
    "Livia",
    "Diedra",
    "Joan",
    "Hanna",
    "Abigail",
    "Hallie",
    "Heather",
    "Madeleine",
    "Mallory",
    "Thelma",
    "Diana",
    "Isabella",
}

playerResponses = 
{
    "Not a chance.",
    "Whatever, pig.",
    "You get nothing! Good day sir!",
    "Mind your own business.",
    "I know my rights, sir.",
    "Shutup, pig.",
}

playerKilledMessages = {
--    { Text="Acts of aggression will not be tolerated on Uaran.", Audio="GuardPlayerKilledMessage1" },
    { Text="The justice of the Guardian Order is swift.", Audio="GuardPlayerKilledMessage2" },
}

traitorKilledMessages = {
    "Treason is not tolerated."
}

thiefAlertMessages= {
    "Stop that thief!",
    "Halt! Stop right there thief!",
    "Thought you could get away with stealing?",
}

cultistKilledMessages = {
    { Text="These cultists breed like rabbits.", Audio="GuardCultistKilledMessage1" },
    { Text="That is the 10th one today.", Audio="GuardCultistKilledMessage2" },
    { Text="These are dark times indeed.", Audio="GuardCultistKilledMessage3" },
    { Text="The curse of the dead gods runs deep.", Audio="GuardCultistKilledMessage4" },
}

AI.IntroMessages = {
    "Is there something you need? I'm kind of busy. Unless it's a serious crime don't bother me."
} 

-- These settings can be overridden
AI.Settings.AlertRange = 10.0
AI.Settings.ChaseRange = 15.0
AI.Settings.ChanceToNotAttackOnAlert = 1
AI.Settings.ChargeSpeed = 5.0
AI.Settings.MaxChaseTime = 10

function Dialog.OpenWhoDialog(user)
    QuickDialogMessage(this,user,"I am a member of the Guardian Order. Our justice is dealt swiftly. If someone causes trouble, we'll be there to stop them in their tracks. We can't protect everyone everywhere of course. If you venture far away from town, we won't be able to protect you from bandits and monsters.")
end

function Dialog.OpenTalkDialog(user)
    QuickDialogMessage(this,user,"There are plenty of merchants here who would be glad to chat with you some more.")
end

function GetNextLoc(curPathIndex)
    curPathIndex = curPathIndex or 1
    local deviation = Loc(math.random()*2-1,0,math.random()*2-1)
    currentDestination = path[curPathIndex]:Add(deviation)
    return currentDestination
end

function DoPatrol(forceWait)    
    local stopChance = this:GetObjVar("stopChance") or 0
    local shouldWait = math.random(0, 100)
    if( forceWait or shouldWait <= stopChance ) then
        local stopDelay = this:GetObjVar("stopDelay") or 1
        this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(stopDelay), "patrolPause")
    else
        local curPathIndex = this:GetObjVar("curPathIndex") or 1
        local pathLoc = GetNextLoc(curPathIndex)
        if(this:GetLoc():Distance(pathLoc) > MAX_PATHTO_DIST) then
            AI.StateMachine.ChangeState("ReturnToPath")
        else
            curPathIndex = (curPathIndex % #path) + 1
            this:SetObjVar("curPathIndex", curPathIndex)
            this:PathTo(pathLoc,3.0,"patrol")
        end
    end  
end

function IsEnemy(targetObj)
    if (targetObj == nil or not targetObj:IsValid()) then return true end
    if (targetObj:HasObjVar("IsGuard")) then return false end

    if not( AI.IsValidTarget(targetObj) ) then return false end

    if ( AI.MainTarget == targetObj ) then return true end

    if ( targetObj:GetObjVar("GuardIgnore") ) then return false end

    -- get the karma level of the targetObj
    local karmaLevel = GetKarmaLevel(GetKarma(targetObj))

    local isPet = IsPet(targetObj)

    -- handle NPCs (cept pets)
    if ( not IsPlayerCharacter(targetObj) and not isPet ) then

        if ( karmaLevel.GuardHostileNPC ) then return true end

        -- if guards protect this npc, they are never an enemy. 
        if ( karmaLevel.GuardProtectNPC or targetObj:HasObjVar("ImportantNPC") ) then return false end

        -- guards always attack monsters that are not pets
        if ( targetObj:GetMobileType() == "Monster" ) then return true end

        return false
    end

    -- here down is players/pets

    -- if this guard is not neutral
    if ( this:GetObjVar("IsNeutralGuard") ~= true ) then
        -- outcasts, for example, are attacked as soon as the guard sees them.
        if ( karmaLevel.GuardHostilePlayer ) then return true end
    end

    if ( isPet ) then
        -- guards attack pets that have enemy owners
        local petOwner = targetObj:GetObjectOwner() or targetObj
        if ( targetObj ~= petOwner ) then return IsEnemy(petOwner) end
    end

    -- if guards kill aggressors
    if ( ServerSettings.Conflict.GuardsKillAggressors == true ) then
        -- and if the target object is an aggressor(guardIgnore==true), they are an enemy to this guard.
        if ( IsAggressor(targetObj, true) ) then return true end
    end

    return false
end

function IsFriend(target)
    -- DebugMessageA(this,"Checking if not enemy")
    return not IsEnemy(target)
end

function ShouldPatrol()
    return this:GetObjVar("shouldPatrol") == true
end

function GetNearestPathNode(path)
    if(path == nil) then return nil end
    
    local closestNode = nil
    local closestDistance = 0

    for index,loc in pairs(path) do
        local dist = this:GetLoc():Distance(loc)
        if(closestNode == nil or dist < closestDistance) then
            closestNode = index
            closestDistance = dist
        end
    end

    return closestNode, closestDistance
end

AI.StateMachine.AllStates.AttackAbility = {
    GetPulseFrequencyMS = function() return 1000 end,
    OnEnterState = function()
        if( not(AI.IsValidTarget(AI.MainTarget)) ) then
            DecideIdleState()
            return
        end

        PerformPrestigeAbility(this, AI.MainTarget, "NPC", "NPCCharge")

    end,

    AiPulse = function()
        AI.StateMachine.ChangeState("Melee")
    end,
}

AI.StateMachine.AllStates.Start = {
        OnEnterState = function()
            --DebugMessage(this:GetName().." is Start")
            if( ShouldPatrol() ) then
                    --DebugMessage(this:GetName().." is ReturnToPath")   
                AI.StateMachine.ChangeState("ReturnToPath")
            else
                    --DebugMessage(this:GetName().." is ReturnHome")   
                AI.StateMachine.ChangeState("ReturnHome")
            end
        end
    }

AI.StateMachine.AllStates.Idle = {
        OnEnterState = function()
            --DebugMessage(this:GetName().." is Start")
            if( ShouldPatrol() ) then
                    --DebugMessage(this:GetName().." is ReturnToPath")   
                AI.StateMachine.ChangeState("ReturnToPath")
            else
                    --DebugMessage(this:GetName().." is ReturnHome")   
                AI.StateMachine.ChangeState("ReturnHome")
            end
        end
    }

AI.StateMachine.AllStates.ReturnHome = {   
        OnEnterState = function()
            --DebugMessage(this:GetName().." is Return home")
            this:SendMessage("EndCombatMessage")
            local homeLoc = this:GetObjVar("homeLoc")
            if( homeLoc == nil ) then
                --DebugMessage("[ai_guard::ReturnToStation] No valid home location")
                homeLoc = this:GetObjVar("SpawnLocation")
            end
            if(homeLoc == nil) then
                DebugMessage("ERROR: I have no home "..this:GetCreationTemplateId())
                AI.StateMachine.ChangeState("Stationed")                
                return
            end

            if( this:GetLoc():Distance(homeLoc) < 1 ) then
                AI.StateMachine.ChangeState("Stationed")
            elseif(this:GetLoc():Distance(homeLoc) < MAX_PATHTO_DIST) then
                this:PathTo(homeLoc,1.0,"returnHome") 
            else
                WanderTowards(homeLoc,40,3.0,"returnHome")                
            end
        end,

        ReturnAttempts = 0,
    }

AI.StateMachine.AllStates.AwaitResponse = {   
        GetPulseFrequencyMS = function() return 500 end,

        OnEnterState = function()
        end,

        AiPulse = function()   
            if (FineTarget ~= nil and AI.IsValidTarget(FineTarget)) then
                FaceObject(this,FineTarget)
            else    
                FineTarget = nil
                AI.StateMachine.ChangeState("Idle")
            end
        end,

}

AI.StateMachine.AllStates.ReturnToPath = {
        GetPulseFrequencyMS = function() return 3000 end,

        OnEnterState = function(self)
            self:AiPulse()
        end,

        AiPulse = function()
            if (not this:IsMoving()) then
                this:SendMessage("EndCombatMessage")

                if lastLocInPath ~= nil and not (this:CanPathTo(lastLocInPath)) then
                    this:SetWorldPosition(lastLocInPath)
                    PlayEffectAtLoc("TeleportToEffect",this:GetLoc())
                    lastLocInPath = nil
                end

                if(AI.StateMachine.AllStates.ReturnToPath.ReturnAttempts > 10) then
                    -- we are lost just stay put
                    if not(this:DecayScheduled()) then
                        Decay(this)
                    end
                    AI.StateMachine.ChangeState("Stationed")
                    return
                end

                --DebugMessage(this:GetName().." is Return to Path")
                local path = GetPath(this:GetObjVar("MyPath"))
                local pathIndex, pathDist = GetNearestPathNode(path)
                if( pathIndex == nil ) then
                    --DebugMessage("[ai_cultist_guard::ReturnToPath] No valid path node location")
                    AI.StateMachine.ChangeState("Stationed")
                    return
                end

                local pathLoc = path[pathIndex]
                
                -- we made it back to our path lets resume patrol
                if( this:GetLoc():Distance(pathLoc) < 1 ) then
                    this:SetObjVar("curPathIndex", pathIndex)
                    AI.StateMachine.AllStates.ReturnToPath.ReturnAttempts = 0
                    AI.StateMachine.ChangeState("Patrol")
                    return
                end
                
                if(pathDist > MAX_PATHTO_DIST) then
                    WanderTowards(pathLoc,40,3.0,"returnToPath")
                else
                    this:SetObjVar("curPathIndex", pathIndex)
                    this:PathTo(pathLoc,3.0,"returnToPath") 
                end
            end
        end,

        ReturnAttempts = 0,
    }

AI.StateMachine.AllStates.Stationed = {   
        OnEnterState = function()

            local homeFacing = this:GetObjVar("homeFacing")
            if( homeFacing ~= nil and this:GetFacing() ~= homeFacing ) then
                this:SetFacing(homeFacing)
            end
        end,
    }

AI.StateMachine.AllStates.Patrol = {
        OnEnterState = function()
            --DebugMessage(this:GetName().." is patroling")
            DoPatrol()
        end,
    }

function HandleModuleLoaded()
    --DebugMessage("GUARD LOADED")
    if (IsFemale(this)) then
        guardNames = femaleGuardNames
    end

    if (IsLocInRegion(this:GetLoc(), "EldeirVillage"))then
        this:SetSharedObjectProperty("DisplayName", ColorizeMobileName(this, "Eldeir Village Guard"))
    end

    this:SetName(guardNames[math.random(1, #guardNames)].." The Guard")

    --DebugMessage("Creating guard with name of "..this:GetName().."and id of " ..this.Id .." with template name of "..this:GetCreationTemplateId())
    if( ShouldPatrol() ) then
        this:SetObjVar("curPathIndex", 1)
        this:SetObjVar("stopChance", 0)
        this:SetObjVar("stopDelay", 3000)
        this:SetObjVar("isRunning", 0)    
        --DebugMessage("ShouldPatrol")  
        AI.Settings.StationedLeash = false
    else
        this:SetObjVar("homeLoc",this:GetLoc())
        this:SetObjVar("homeFacing",this:GetFacing())
        AI.Settings.StationedLeash = true
        AI.SetSetting("Leash",true)
        --DebugMessage("ShouldNotPatrol")  
    end
    if ( this:GetObjVar("IsNeutralGuard") == true ) then
        this:SetSharedObjectProperty("Title", "Neutral") 
    end
end

--[[
function HandleInteract(user,usedType)
    if(usedType ~= "Interact") then return end
    if (this:IsMoving()) then
        this:NpcSpeech("Can't you see I'm busy?")
        return
    end
    AI.IdleTarget = user
    local text = "Is there something you need? I'm kind of busy. Unless it's a serious crime don't bother me."

    response = {
        --{ text = "I need your help! Follow me!.", handle = "FollowMe" },
        --{ text = "I have to report a crime.", handle = "ReportCrime" },
        { text = "Nevermind.", handle = "Nevermind" } }

    NPCInteraction(text,this,user,"Responses",response)
    AI.StateMachine.ChangeState("Converse")
end
]]--
RegisterEventHandler(EventType.DynamicWindowResponse,"Responses",function(user,buttonId)
    --[[if (buttonId == "FollowMe") then
        this:NpcSpeech("What happened?")
        this:PathToTarget(user,3,3.5)
        user:CloseDynamicWindow("Responses")
        AI.StateMachine.ChangeState("AwaitResponse")
        AI.FineTarget = user
        CallFunctionDelayed(TimeSpan.FromSeconds(10),function ()
            if (AI.MainTarget == nil) then
                this:NpcSpeech("Why do these people waste my time?")
                AI.StateMachine.ChangeState("GoHome")
            end
            end)]]
    if (buttonId == "Nevermind") then
        this:NpcSpeech("Be on your way then.")
        user:CloseDynamicWindow("Responses")

    --DFB DOTO: Handle other cases.
    elseif (response ~= nil or response ~= "") then
        this:NpcSpeech("Sorry, I'm busy.")
    else
        this:NpcSpeech("Whatever.")
        this:StopMoving()
    end
end)

function OnHomeArrived(arriveSuccess)
    if(arriveSuccess) then
        --DebugMessage("Stationed")
        AI.StateMachine.ChangeState("Stationed")
        AI.StateMachine.AllStates.ReturnHome.ReturnAttempts = 0
    else
        AI.StateMachine.AllStates.ReturnHome.ReturnAttempts = AI.StateMachine.AllStates.ReturnHome.ReturnAttempts + 1
        if(AI.StateMachine.AllStates.ReturnHome.ReturnAttempts >= 10) then
            if not(this:DecayScheduled()) then
                Decay(this)
            end
            AI.StateMachine.ChangeState("Stationed")
        end
    end
end

function OnReturnToPathArrived(arriveSuccess)
    if (not arriveSuccess) then
        AI.StateMachine.AllStates.ReturnToPath.ReturnAttempts = AI.StateMachine.AllStates.ReturnToPath.ReturnAttempts + 1
    else 
        AI.StateMachine.ChangeState("Patrol")
    end
end

function OnPatrolArrived(arriveSuccess)
    --DebugMessage("[ai_guard::OnPatrolArrived]")

    if( AI.StateMachine.CurState ~= "Patrol" ) then
        -- ignore this message if we are no longer patrolling
        return
    end

    -- TODO: Handle the case where he fails to path properly
    -- for now we just move on to the next point in the patrol
    if not(arriveSuccess) then
        --DebugMessage("[ai_guard::OnPatrolArrived] Failed to path to destination!")
    end

    -- pause if our arrive failed
    local pausePatrol = not(arriveSuccess)
    DoPatrol(pausePatrol)
end

function HandleApplyDamage(damager, damageAmount, damageType, isCrit, wasBlocked, isReflected)

    if (IsDead(this)) then AI.StateMachine.ChangeState("Dead") return end
    if not(AI.IsActive()) then return end

    local threat = 1
    if( damager:IsPlayer() ) then
        threat = 100
    end

    if (not damager:HasObjVar("IsGuard")) then 
        AI.AddThreat(damager,threat)
        AttackEnemy(damager,true)    
    end

    BaseMobileHandleApplyDamage()
end

local base_AttackEnemy = AttackEnemy
function AttackEnemy(enemy,force)
    --[[
    if(AI.Settings.InstaTeleportRange and enemy and enemy:IsValid()) then
        local myLoc = this:GetLoc()
        local enemyLoc = enemy:GetLoc()
        local enemyDist = myLoc:Distance2(enemyLoc)
        if( enemyDist > AI.Settings.InstaTeleportRange) then
            this:PlayEffect("TeleportFromEffect")
            this:SetWorldPosition(myLoc:Project(myLoc:YAngleTo(enemyLoc),enemyDist - AI.Settings.InstaTeleportRange))
        end
    end]]

    base_AttackEnemy(enemy,force)
    if (ThiefChasing ~= nil) then
        AI.StateMachine.ChangeState("Melee");
    else
        AI.StateMachine.ChangeState("AttackAbility");
    end
end

function OnPatrolPause()
    DoPatrol()
end

function HandleRequestHelp(attacker,crimeIndex,victim)
    --DebugMessage(DumpTable(args))
    local attackerDist = this:DistanceFrom(attacker)
    if( attackerDist < 40 ) then
        AI.AddThreat(attacker,100)
        AttackEnemy(attacker,true)
    end
end

function HandleVictimKilled(victim)
    if( victim ~= nil ) then
        FineTarget = nil
        victim:DelObjVar("Criminal")
        this:SendMessage("ClearTarget")
        if( victim:IsPlayer() ) then
            if (victim == ThiefChasing) then
                ThiefChasing = nil
                AI.SetSetting("ChargeSpeed",5.0)
            end

            local message = playerKilledMessages[math.random(#playerKilledMessages)]
            if (not IsFemale(this)) then
                Speak(message)
            else
                this:NpcSpeech(message.Text)
            end
        else
            victim:SetObjVar("guardKilled",true)
            if( victim:HasModule("ai_cultist") ) then
                local message = cultistKilledMessages[math.random(#cultistKilledMessages)]
                if (not IsFemale(this)) then
                    Speak(message)
                else
                    this:NpcSpeech(message.Text)
                end
            end
        end
    end
end

function DecideIdleState()
    if not(AI.IsActive()) then return end

    if (IsInCombat(this)) then
        this:SendMessage("EndCombatMessage")
    end

    if (AI.GetSetting("ChargeSpeed") < 5.0) then
        AI.SetSetting("ChargeSpeed",5.0)
    end

    if (AI.StateMachine.CurState == "GoHome" or AI.StateMachine.CurState == "ReturnHome") then
        --Teleport guards back to spawn location if we are trying to go back
        if not ShouldPatrol() and not (this:CanPathTo(this:GetObjVar("SpawnLocation"))) then
            this:SetWorldPosition(this:GetObjVar("SpawnLocation"))
            PlayEffectAtLoc("TeleportToEffect",this:GetLoc())
        end
    end

    AI.StateMachine.ChangeState("Idle")
end

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(), HandleModuleLoaded)
--RegisterSingleEventHandler(EventType.LoadedFromBackup, "ai_guard", HandleLoadedFromBackup)
OverrideEventHandler( "base_ai_conversation", EventType.Message, "UseObject", HandleInteract)
RegisterEventHandler(EventType.Arrived, "returnHome", OnHomeArrived)
RegisterEventHandler(EventType.Arrived, "returnToPath", OnReturnToPathArrived)
RegisterEventHandler(EventType.Arrived, "patrol", OnPatrolArrived)
RegisterEventHandler(EventType.Timer, "patrolPause", OnPatrolPause)
--RegisterEventHandler(EventType.EnterView, "alert", OnEnterAlertRange)
--RegisterEventHandler(EventType.LeaveView, "chase", OnLeaveChaseRange)
RegisterEventHandler(EventType.Message, "VictimKilled", HandleVictimKilled)
RegisterEventHandler(EventType.Message, "RequestHelp", HandleRequestHelp)

ThiefChasing = nil
lastLocInPath = nil
RegisterEventHandler(EventType.Message, "StealFailure", 
    function(user)
        if (IsInCombat(this)) then
            return
        end

        if (AI.MainTarget ~= nil) then
            return
        end

        this:NpcSpeech(thiefAlertMessages[math.random(1, #thiefAlertMessages)])

        ThiefChasing = user

        local canPathTo = this:CanPathTo(user:GetLoc())

        if (ShouldPatrol()) then
            lastLocInPath = this:GetLoc()
        end

        if (canPathTo) then
            if (this:HasLineOfSightToObj(user,ServerSettings.Combat.LOSEyeLevel)) then
                this:SendMessage("AddThreat",user,2)
            else
                AI.LastKnownTargetPos = user:GetLoc()
                AI.PursueLastTarget = user
                AI.AddToAggroList(user,2)
                AI.StateMachine.ChangeState("Pursue")
            end
        else
            --If a guard can't find a path to thief, teleport guard to near thief and give thief some time to escape
            local nearThief = GetNearbyPassableLocFromLoc(user:GetLoc(),1,2)
            this:SetWorldPosition(nearThief)
            PlayEffectAtLoc("TeleportToEffect",this:GetLoc())

            CallFunctionDelayed(TimeSpan.FromSeconds(2),
            function()      
                if (this:HasLineOfSightToObj(user,ServerSettings.Combat.LOSEyeLevel)) then
                    this:SendMessage("AddThreat",user,2)
                else
                    AI.LastKnownTargetPos = user:GetLoc()
                    AI.PursueLastTarget = user
                    AI.AddToAggroList(user,2)
                    AI.StateMachine.ChangeState("Pursue")
                end
            end)
        end
    end)

AI.InitialState = "Start"