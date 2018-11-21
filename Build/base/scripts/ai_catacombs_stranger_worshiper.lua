require 'incl_catacombs_locations'
require 'base_ai_mob'
require 'base_ai_conversation'
require 'base_ai_intelligent'  
require 'guard_protect'
require 'incl_ai_patrolling'
require 'incl_faction'
--require 'base_ai_sleeping'

table.insert(AI.IdleStateTable,{StateName = "Wander",Type = "nothing"})
table.insert(AI.IdleStateTable,{StateName = "ReturnToPath",Type = "pleasure"})
table.insert(AI.IdleStateTable, {StateName = "GoLocation",Type = "pleasure"})
--table.insert(AI.IdleStateTable,{StateName = "GoPray",Type = "pleasure"})

AI.SetSetting("ChanceToNotAttackOnAlert",20)

currentDestinaion = nil
AI.Settings.Debug = false
AI.Settings.AlertRange = 10.0
AI.SetSetting("AggroRange",5)
AI.Settings.PatrolSpeed = 1.0
AI.Settings.FleeUnlessAngry = true --only fight if the mob is angry
AI.Settings.CanConverse = false 
AI.Settings.SpeechTable = "StrangerWorshipper"

if (initializer ~= nil) then
    if( initializer.VillagerNames ~= nil ) then    
        local name = initializer.VillagerNames[math.random(#initializer.VillagerNames)]
        this:SetName(name.." of the Wayward")
    end
end

--Function that determine's what team I'm on. Override this for custom behaviour.
function IsFriend(target)
--DebugMessage("Target is "..tostring(target:GetName()))
    --DebugMessage("worshipper 1")
    if (not AI.IsValidTarget(target)) then return false end
    if (target == nil) then
        DebugMessage("[ai_catacombs_stranger_worshiper|IsFriend] ERROR: target is nil")
        return true
    end
    --DebugMessage("worshipper 2")

    local otherTeam = target:GetObjVar("MobileTeamType")
    local myTeam = this:GetObjVar("MobileTeamType")
    local targetFaction = GetFaction(target,this:GetObjVar("MobileTeamType"))
    --DebugMessage("worshipper 3")

    --Override if this is my "target"
    if (AI.InAggroList(target)) then
        return false
    end
    --DebugMessage("worshipper 4")

    
    if (target:IsPlayer()) then return true end
   -- DebugMessage("worshipper 5")

    if (target == nil) then
        return true
    end
   -- DebugMessage("worshipper 6")

    if (myTeam == nil) then --If I have no team, then attack nobody in this case.
        DebugMessageA(this,"NO TEAM")
        return true
    end
    --DebugMessage("worshipper 7")

    if (this:HasObjVar("NaturalEnemy") ~= nil)  then
        if (this:GetObjVar("NaturalEnemy") == otherTeam and otherTeam ~= nil) then
            return false
        end
    end
   -- DebugMessage("worshipper 8")
   -- DebugMessage("target mobile type is "..tostring(target:GetMobileType()))
    if (target:GetMobileType() == "Animal" or target:GetMobileType() == "Friendly" ) then --There aren't any animals in the Hub area except for pets.
         return true
    end
   -- DebugMessage("worshipper 9")
    if (otherTeam == nil) then
        return true
    end

    if otherTeam == "Wesselton" then
        return true
    end

    return (myTeam == otherTeam) --Return true if they have the same team, false if not.
end

oldDecideIdleState = DecideIdleState
function DecideIdleState()
    if (IsInCombat(this)) then
        this:SendMessage("EndCombatMessage")
    end
    
    if AI.StateMachine.CurState ~= "GoPray" then
        oldDecideIdleState()
    else
        --LuaDebugCallStack("Should not be called")
    end
end

function ShouldAlert(target)
    local targetFaction = GetFaction(target,this:GetObjVar("MobileTeamType"))
    local targetTeam = target:GetObjVar("MobileTeamType")
    if (targetTeam == "Wesselton") then
        return false
    end
    if (targetFaction < 10) then
        return true
    else
        return false
    end
end

AI.StateMachine.AllStates.ReturnToPath.OnEnterState = function(self)
            self:AiPulse()
        end

AI.StateMachine.AllStates.ReturnToPath.OnExitState = function()
        end

AI.StateMachine.AllStates.Idle = { 
        GetPulseFrequencyMS = function() return math.random(3000,4000) end,
        AiPulse = function() 
            --aiRoll = math.random(4)
            --if(aiRoll == 1) then
            --    AI.StateMachine.ChangeState("GoLocation")            
            --else
            --    AI.StateMachine.ChangeState("Wander")
            --end         
            --LuaDebugCallStack("Idle")
            DecideIdleState()
        end,        
    }

AI.StateMachine.AllStates.Wander = {
        GetPulseFrequencyMS = function() return math.random(1700,2400) end,
        
        OnEnterState = function()
            local wanderRegion = this:GetObjVar("WanderRegion")
            if wanderRegion ~= nil then
                WanderInRegion(wanderRegion,"Wander")
            end
        end,

        OnArrived = function (success)
            if (AI.StateMachine.CurState ~= "Wander") then
                return 
            end
            --if( math.random(2) == 1) then
            --    this:PlayAnimation("fidget")
            --end         
            AI.StateMachine.ChangeState("ReturnToPath")   
        end,

        AiPulse = function()  
            DecideIdleState()
        end,
    }

function SitInSeat()
    --seat table is as follows
    --Location
    --Occupied
    --Facing
    local benches = FindObjects(SearchHasObjVar("SeatTable",5))
    closestSeat = nil
    currentBench = nil
    if (#benches ~= 0) then
        local closestDistance = 9999
        for benchIndex,bench in pairs(benches) do
            local seats = bench:GetObjVar("SeatTable")
            for seatIndex,seat in pairs(seats) do
                local seats = FindObjects(SearchMobileInRange(5))
                local taken = false
                for i,j in pairs(seats) do
                    if (j:GetLoc() == seat.Location) then
                        taken = true
                    end
                end
                if (closestDistance > seat.Location:Distance(this:GetLoc()) and not taken) then
                    closestDistance = seat.Location:Distance(this:GetLoc())
                    closestSeat = seat
                    currentBench = bench
                end
            end
        end
    end
    if (closestSeat ~= nil) then
        --sit in the seat
        this:SetWorldPosition(closestSeat.Location)
        this:SetFacing(closestSeat.facing)
        this:SetObjVar("CurrentSeat",currentBench)
        HaveMobileSitChair() --Don't need to specify a chair object in this case
    end
end

function GetWorshipLocation()
    --local worshipLocs = {}
    --local objectOfWorship = this:GetObjVar("WorshipObj") or FindObject(SearchHasObjVar("ObjectOfWorship"))
    --if (objectOfWorship == nil) then return nil end
    --for i,j in pairs(CatacombsLocations) do
   --     if (objectOfWorship:GetLoc():Distance(j.Loc)) < 15 then
   --         table.insert(worshipLocs,j)
   --     end
   -- end
   -- local randomization = Loc(math.random(1,5)/2,0 - 2.5,math.random(1,5)/2 - 2.5)
   -- local destination = worshipLocs[math.random(1,#worshipLocs)].Loc
   --DebugMessage("INFO",tostring(destination),tostring(randomization),tostring(destination.Add))
    local benches = FindObjects(SearchHasObjVar("SeatTable"))
    local resultTable = {}
    for i,j in pairs(benches) do
        local seatTable = j:GetObjVar("SeatTable")
        for n,k in pairs(seatTable) do
            table.insert(resultTable,k.Location)
        end
    end
    return resultTable[math.random(1,#resultTable)]
end
SERMON_TIME = 60*4 + 25 --5 minutes
AI.StateMachine.AllStates.GoPray = {
        GetPulseFrequencyMS = function() return 5000 + math.random(1,1000) end,

        OnEnterState = function()
            --DebugMessage("mCount is "..tostring(mCount))
            this:ScheduleTimerDelay(TimeSpan.FromSeconds(SERMON_TIME),"IdleMe")
            this:RemoveTimer("DecideIdle")
            --AI.StateMachine.AllStates.GoPray.GetPulseFrequencyMS = function() return 4000 end
            mCount = nil
            destination = GetWorshipLocation()
            AI.SetSetting("ShouldPatrol",false)
            this:SetObjVar("StuckOverride",destination)
            if (destination == nil) then
                AI.StateMachine.ChangeState("Idle")
            end
            -- if the destination we chose is too far away just wander
            if(this:GetLoc():Distance(destination) > MAX_PATHTO_DIST) then
                AI.StateMachine.ChangeState("Wander")
            else
                this:PathTo(destination,1.0,"GoPray")
            end
        end,

        AiPulse = function()
            local chance = 20
            --start ritualing if 
            if (mCount == nil) then
                mCount = 4000
            end
            --DebugMessage(this:GetName().."'s ritual is ",tostring(this:GetObjVar("Ritual"))," sitting is "..tostring(IsSitting(this))," mCount is "..tostring(mCount))
            if (this:HasObjVar("Ritual")) then
                --if (IsSitting(this)) then
                --    this:SendMessage("StopSitting")
                    --DebugMessage("Sending stop sitting message")
                --    return
                --end
                chance = 10
                this:PlayAnimation("sit_standing_armstothesky")
                --don't chant too fast
                --mCount = math.max(mCount/1.3,1000)
                --AI.StateMachine.AllStates.GoPray.GetPulseFrequencyMS = function() return mCount end
            end
            if (math.random(1,chance) == 1 and GetSpeechTable("PraySpeech") ~= nil) then
                local speech = math.random(1,#GetSpeechTable("PraySpeech"))
                this:NpcSpeech(GetSpeechTable("PraySpeech")[speech])
            end
            --local destLoc = this:GetObjVar("StuckOverride") or this:GetLoc()
            --if not this:IsMoving() and this:GetObjVar("StuckOverride"):Distance(this:GetLoc()) < 4 then
            --    this:PlayAnimation("cast_heal")
            --    local worshipObj = this:GetObjVar("WorshipObj")
            --    FaceObject(this,worshipObj)
            --end
        end,

        OnArrived = function (success)
                local destLoc = this:GetObjVar("StuckOverride") or this:GetLoc()
                this:ScheduleTimerDelay(TimeSpan.FromSeconds(SERMON_TIME),"DecideIdle") 
                if not (success) then
                   this:SetWorldPosition(destLoc)
                end
                SitInSeat()
            --DebugMessage("Go Location")
        end,

        OnExitState = function()
            this:DelObjVar("WorshipObj")
            this:DelObjVar("Ritual")
            AI.SetSetting("ShouldPatrol",true)
            DecideIdleState()
        end,
    }
RegisterEventHandler(EventType.Timer,"IdleMe",function()
    AI.StateMachine.ChangeState("Idle")
end)


AI.StateMachine.AllStates.GoLocation = {
        OnEnterState = function()
            destination = CatacombsLocations[math.random(#CatacombsLocations)]
            this:SetObjVar("StuckOverride",destination.Loc)
            -- if the destination we chose is too far away just wander
            if((destination.Loc):Distance(this:GetLoc()) > MAX_PATHTO_DIST) then
                AI.StateMachine.ChangeState("Wander")
            else
                this:PathTo(destination.Loc,1.0,"GoLocation")
            end
        end,

        OnArrived = function (success)
            if (AI.StateMachine.CurState ~= "GoLocation" or this:HasObjVar("WorshipObj")) then return end
            local destLoc = this:GetObjVar("StuckOverride") or this:GetLoc()
            if not (success) then
                this:SetWorldPosition(destLoc)
                AI.StateMachine.ChangeState("Idle")
                this:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"DecideIdle") 
            else 
                --destination = this:GetObjVar("StuckOverride")
                if (AI.StateMachine.CurState ~= "GoLocation") then
                    return 
                end
                if( destination ~= nil ) then 
                    this:SetFacing(destination.Facing)
                    if( destination.Type == "Shrine" ) then
                        this:PlayAnimation("cast")
                    end
                    if( destination.Type == "Altar" ) then
                        this:PlayAnimation("cast_heal")
                    end
                    if (destination.Type == "Merchant") then
                        this:PlayAnimation("transaction")
                    end
                end
                AI.StateMachine.ChangeState("Idle")
                this:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"DecideIdle") 
            end
            --DebugMessage("Go Location")
        end,
    }
-- external inputs

AI.StateMachine.AllStates.Patrol = {
        OnEnterState = function(self)
            DoPatrol()
        end,
    }

function HandleInteract(user,usedType)
    if(usedType ~= "Interact") then return end
    
    if (IsAsleep(this)) then
        return 
    end

    if (GetFaction(user,"Wayun") < -30) then
        InsultTarget(user)
        return
    end
    --DebugMessage(GetFaction(user,"Wayun"))
    if (GetFaction(user,"Wayun") >= 10) then
        this:NpcSpeech(GetSpeechTable("InteractFactionSpeech")[math.random(1,#GetSpeechTable("InteractFactionSpeech"))])
        --this:StopMoving()
        --this:SetFacing(this:GetLoc():YAngleTo(user:GetLoc()))
        return
    end
    --DFB TODO: DIALOG FOR EVERY VILLAGER
    this:NpcSpeech(GetSpeechTable("InteractSpeech")[math.random(1,#GetSpeechTable("InteractSpeech"))])
    --user:SendMessage("AdvanceQuest","CatacombsStartQuest","TalkToSomeone","Investigate")
end

RegisterEventHandler(EventType.Message,"GoPrayMessage",
    function(objRef)
        this:SetObjVar("WorshipObj",objRef)
        AI.StateMachine.ChangeState("GoPray")
    end)

RegisterEventHandler(EventType.Message,"EndPrayMessage",
    function(objRef)
        AI.StateMachine.ChangeState("Idle")
    end)

RegisterEventHandler(EventType.Timer,"DecideIdle",DecideIdleState)
OverrideEventHandler("base_ai_conversation",EventType.Message, "UseObject", HandleInteract)
RegisterEventHandler(EventType.Arrived, "GoLocation",AI.StateMachine.AllStates.GoLocation.OnArrived)
RegisterEventHandler(EventType.Arrived, "GoPray",AI.StateMachine.AllStates.GoPray.OnArrived)
