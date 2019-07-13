require 'NOS:incl_celador_locations'
require 'NOS:base_ai_mob'
require 'NOS:base_ai_intelligent' 
require 'NOS:base_ai_conversation' 
require 'NOS:guard_protect'
require 'NOS:incl_ai_patrolling'
require 'NOS:incl_faction'
require 'NOS:incl_gametime'
--require 'NOS:base_ai_sleeping'

table.insert(AI.IdleStateTable,{StateName = "Wander",Type = "nothing"})
table.insert(AI.IdleStateTable,{StateName = "ReturnToPath",Type = "pleasure"})
table.insert(AI.IdleStateTable, {StateName = "GoLocation",Type = "pleasure"})

AI.SetSetting("ChanceToNotAttackOnAlert",20)

AI.Settings.AlertRange = 10.0
AI.Settings.AggroRange = 5
AI.Settings.PatrolSpeed = 1.0
AI.Settings.DoNotBoast = true
AI.Settings.SpeechTable = "Villager"

--Function that determine's what team I'm on. Override this for custom behaviour.
function IsFriend(target)
    if (not AI.IsValidTarget(target)) then return true end
    if (target == nil) then
        DebugMessage("[ai_villager|IsFriend] ERROR: target is nil")
        return true
    end
    local otherTeam = target:GetObjVar("MobileTeamType")
    local myTeam = this:GetObjVar("MobileTeamType")
    local targetFaction = GetFaction(target,this:GetObjVar("MobileTeamType"))
    local minFriendly = GetFactionMinFriendlyLevel(this:GetObjVar("MobileTeamType"))
    if (target:IsPlayer() and minFriendly ~= nil) then
        if (targetFaction < minFriendly) then return false end
    end

    if (target:IsPlayer()) then return true end

    --Override if this is my "target"
    if (AI.InAggroList(target)) then
        return false
    end

    DebugMessageA(this,tostring(target))
    if (target == nil) then
        return true
    end

    if (myTeam == nil) then --If I have no team, then attack nobody in this case.
        DebugMessageA(this,"NO TEAM")
        return true
    end

    if (this:HasObjVar("NaturalEnemy") ~= nil)  then
        if (this:GetObjVar("NaturalEnemy") == otherTeam and otherTeam ~= nil) then
            return false
        end
    end

    if (target:GetMobileType() == "Friendly") then
        return true
    end

    if (target:GetMobileType() == "Animal" ) then --Animals don't usually attack animals
        if (this:DistanceFrom(target) < AI.Settings.AggroRange or math.random(AI.GetSetting("AggroChanceAnimals")) == 1) then            
            --AI.AddThreat(damager,-1)--Don't aggro them
            return (myTeam == otherTeam) 
        else
            return true
        end
    end
    if (otherTeam == nil) then
        return true
    end

    return (myTeam == otherTeam) --Return true if they have the same team, false if not.
end

AI.StateMachine.AllStates.Alert = {       
        OnEnterState = function() 
            this:PlayAnimation("alarmed")
            
            alertTarget = FindAITarget()


            if( alertTarget == nil ) then
               DebugMessageA(this,"Changing to idle from alert")
                AI.StateMachine.ChangeState("Idle")
            else
                FaceObject(this,alertTarget)
                AI.SetSetting("CanConverse",false)
            end
            ----AI.StateMachine.--DebugMessage("ENTER ALERT")
        end,

        OnExitState = function()
            AI.SetSetting("CanConverse",true)
        end,

        GetPulseFrequencyMS = function() return 1700 end,

        AiPulse = function()    
            --AI.StateMachine.--DebugMessage("Alert pulse")
            --this:NpcSpeech("[f70a79]*Alert!*[-]")
            alertTarget = FindAITarget()
            if( alertTarget == nil ) then
               DebugMessageA(this,"Changing to idle from alert")
                AI.StateMachine.ChangeState("Idle")
            else
                FaceObject(this,alertTarget)
                --We found a new mobile, handle it

                --if I should attack then
                local shouldAttack = false --should I attack
                local targetFaction = GetFaction(alertTarget,this:GetObjVar("MobileTeamType"))
                local faction = GetFactionFromInternalName(this:GetObjVar("MobileTeamType"))
                local chanceAttackAnyway = 10 --should I attack anyway

                --if I'm an enemy of the village attack
                if (facion ~= nil and targetFaction < faction.MinFriendlyLevel) then
                    shouldInsult = true
                end

                if (targetFaction >= faction.MinFriendlyLevel - 10) then
                    shouldAttack = false
                else
                    shouldAttack = true
                end

                if (shouldAttack) then
                    AttackEnemy(alertTarget,true)
                end
                --I treat it as if it's something I should attack
                if (shouldInsult) then
                        --if (math.random(1,chanceAttackAnyway) == 1 ) then
                        --     if (not IsFriend(alertTarget)) then --I'm going to bop you to show you a thing or two
                        --        AttackEnemy(alertTarget)
                        --    else --not a threat, go to idle
                        --        AI.StateMachine.ChangeState("Idle")
                        --    end
                        --else
                    if (math.random(1,3) == 1 ) then --three times more likely to insult you rather than attack
                        InsultTarget(alertTarget)
                    end
                end

                if not(shouldAttack) and not(shouldInsult) then
                    AI.StateMachine.ChangeState("Idle")
                end
            end
        end,
    }


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
            WanderInRegion(wanderRegion,"Wander")
        end,

        OnArrived = function (success)
            if (AI.StateMachine.CurState ~= "Wander") then
                return 
            end
            --if( math.random(2) == 1) then
            --    this:PlayAnimation("fidget")
            --end         
            if (this:HasObjVar("MyPath")) then
               AI.StateMachine.ChangeState("ReturnToPath")   
            end
        end,

        AiPulse = function()  
            DecideIdleState()
        end,
    }



AI.StateMachine.AllStates.GoLocation = {
        OnEnterState = function()
            destination = CeladorLocations[math.random(#CeladorLocations)]
            -- if the destination we chose is too far away just wander
            if(this:GetLoc():Distance(destination.Loc) > MAX_PATHTO_DIST) then
                AI.StateMachine.ChangeState("Wander")
            else
                this:PathTo(destination.Loc,1.0,"GoLocation")
            end
        end,

        OnArrived = function (success)
            if(success) then
                if (AI.StateMachine.CurState ~= "GoLocation") then
                    return 
                end
                if( destination ~= nil ) then 
                    this:SetFacing(destination.Facing)
                    if( destination.Name == "VillageWell" ) then
                        this:PlayAnimation("cast")
                    end
                    if (destination.Type == "Merchant") then
                        nearestMerchant = FindObject(SearchMulti({
                            SearchHasObjVar("IsMerchant"),
                            SearchObjectInRange(10)}))
                        if (nearestMerchant ~= nil) then
                            nearestMerchant:SendMessage("NPCAskPrice")
                            AI.IdleTarget = nearestMerchant
                            this:NpcSpeech(GetSpeechTable("MerchantBuyerSpeech")[math.random(1,#GetSpeechTable("MerchantBuyerSpeech"))])
                            AI.StateMachine.ChangeState("Converse")
                            return
                        end
                    end
                end
                DecideIdleState()
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

--On the target coming into range have a chance to alert to his presense
RegisterEventHandler(EventType.EnterView, "chaseRange", 
    function (mobileObj)
        --DebugMessage(1)
        if (AI.IsValidTarget(mobileObj)) then
            if (not IsFriend(mobileObj)) then
                this:SendMessage("AlertEnemy",mobileObj)
            end
        end
    end)

RegisterEventHandler(EventType.Arrived, "GoLocation",AI.StateMachine.AllStates.GoLocation.OnArrived)

RegisterSingleEventHandler(EventType.ModuleAttached,"ai_villager",
    function()
        if( initializer.VillagerNames ~= nil ) then    
            local name = initializer.VillagerNames[math.random(#initializer.VillagerNames)]
            local job = initializer.VillagerJobs[math.random(#initializer.VillagerJobs)]
            this:SetName(name.." the "..job)
            this:SendMessage("UpdateName")
        end
        if (IsNightTime()) then
            -- Wait for mob to get equipped by template
            CallFunctionDelayed(TimeSpan.FromSeconds(2),function()
                local torch = this:GetEquippedObject("torch")
                if (torch == nil) then
                    CreateEquippedObj("torch", this)
                end
            end)
        end
        
        AddUseCase(this,"Interact",true)
    end)
