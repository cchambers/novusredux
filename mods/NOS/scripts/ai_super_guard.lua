require 'base_ai_mob'

-- We do not want super guards going to sleep on spawn
AI.InitialState = "Idle"
ViewsSleeping = false
 
AI.Settings.CanConverse = false

-- allow guards to see invisible
this:SetObjVar("SeeInvis", true)

function AI.IsValidTarget(target)   
    local result = target ~= nil and target:IsValid() and not(IsDead(target))

    --if(target ~= nil) then        
    --  DebugMessageA(this,"IsValidTarget " .. target:GetName() .. " from " .. this:GetName() .. " result: "..tostring(result))
    --end

    return result
end


function AttackEnemy(enemy)
    if (not AI.IsValidTarget(enemy)) then return end
    enemy:SendMessage("BreakInvisEffect", "Action")
    DebugMessageA(this,"Attacking object "..tostring(enemy))
    --DebugMessage("Should be attacking")
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"TeleportToThem")
    SetAITarget(enemy)
    DebugMessageA(this,"attacking enemy")
    
    if(IsFriend(enemy)) then
        return
    end
    AI.AddThreat(enemy,2)
    RunToTarget(enemy)
    DecideCombatState()
end

RegisterEventHandler(EventType.Timer,"TeleportToThem",function ( ... )
    if (AI.MainTarget ~= nil and not IsDead(AI.MainTarget)) then
        PlayEffectAtLoc("TeleportFromEffect",this:GetLoc())
        this:SetWorldPosition(AI.MainTarget:GetLoc())
        PlayEffectAtLoc("TeleportToEffect",this:GetLoc())
    end
end)


function IsEnemy(targetObj)
    if (targetObj == nil or not targetObj:IsValid()) then return true end
    if (targetObj:HasObjVar("IsGuard")) then return false end

    if not( AI.IsValidTarget(targetObj) ) then return false end

    if ( AI.MainTarget == targetObj ) then return true end

    if ( targetObj:GetObjVar("GuardIgnore") ) then return false end

    -- get the karma level of the targetObj
    local karmaLevel = GetKarmaLevel(GetKarma(targetObj))

    if not( IsPlayerCharacter(targetObj) ) then

        if ( karmaLevel.GuardHostileNPC ) then return true end

        -- if guards protect this npc, they are never an enemy. 
        if ( karmaLevel.GuardProtectNPC or targetObj:HasObjVar("ImportantNPC") ) then return false end

        if ( IsPet(targetObj) ) then
            -- guards attack pets that have enemy owners
            local petOwner = targetObj:GetObjectOwner() or targetObj
            if ( targetObj ~= petOwner ) then return IsEnemy(petOwner) end
        else
            -- guards always attack monsters that are not pets
            if ( targetObj:GetMobileType() == "Monster" ) then return true end
            
            -- guards attack animals that are not pets
            if ( targetObj:GetMobileType() == "Animal" ) then
                -- aslong as the distance is randomly close enough to their agro range?
                if (this:DistanceFrom(targetObj) < AI.Settings.AggroRange/2 or math.random(8) == 1) then     
                    return true
                end
            end
        end

        return false
    end

    -- here down is players

    -- if this guard is not neutral
    if ( this:GetObjVar("IsNeutralGuard") ~= true ) then

        -- outcasts, for example, are attacked as soon as the guard sees them.
        if ( karmaLevel.GuardHostilePlayer ) then return true end
    
        -- if guards kill aggressors
        if ( ServerSettings.Conflict.GuardsKillAggressors == true ) then
            -- and if the target object is an aggressor(guardIgnore==true), they are an enemy to this guard.
            if ( IsAggressor(targetObj, true) ) then return true end
        end

    end

    return false
end


function IsFriend(target)
    --DebugMessageA(this,"Checking if not enemy")
    return not IsEnemy(target)
end

RegisterEventHandler(EventType.Arrived,"",function (success)
    if (success) then
        return
    else
        PlayEffectAtLoc("TeleportFromEffect",this:GetLoc())
        if (AI.MainTarget ~= nil) then
            this:SetWorldPosition(AI.MainTarget:GetLoc())
        end
        PlayEffectAtLoc("TeleportToEffect",this:GetLoc())
    end
end)

AI.StateMachine.AllStates.Idle = {
    GetPulseFrequencyMS = function() return 3500 end,

    OnEnterState = function()
    end,

    AiPulse = function()
		local spawnLoc = this:GetLoc():Project(math.random(0,360), math.random(2,4))

        if (mSpawnPortal ~= nil) then
            mSpawnPortal:SendMessage("UpdateDecay",10)
            this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"RemoveMe")
            this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"PathToPortal")
            return
        else
    	    CreateObj("spawn_portal",spawnLoc,"spawn_portal")
            this:PlayAnimation("cast_heal")
        end
	end
}


RegisterEventHandler(EventType.Message,"RequestHelp",
    function(damager,crimeIndex,guard_caller)
        AttackEnemy(damager)
    end)

RegisterEventHandler(EventType.Timer,"PathToPortal",
	function()
		if (mSpawnPortal ~= nil and mSpawnPortal:IsValid()) then
			this:PathTo(mSpawnPortal:GetLoc(),4.0,"GoToPortal")
		else
            --DebugMessage("[ai_super_guard] ERROR: NO PORTAL!")
            PlayEffectAtLoc("TeleportToEffect",this:GetLoc())
            this:Destroy()
        end
	end)

RegisterEventHandler(EventType.CreatedObject,"spawn_portal",
	function(success,objRef,args)
		if (not success) then
			this:Destroy()
			PlayEffectAtLoc("TeleportToEffect",this:GetLoc())
			return
		end
		FaceObject(this,objRef)
		mSpawnPortal = objRef
        mSpawnPortal:SendMessage("UpdateDecay",10)
    	this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"PathToPortal")
	end)

function DecideIdleState()
    if (IsDead(this)) then AI.StateMachine.ChangeState("Dead") return end
    if not(AI.IsActive()) then return end
    
    AI.StateMachine.ChangeState("Idle")
end

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
function()
    if ( this:GetObjVar("IsNeutralGuard") == true ) then
        this:SetSharedObjectProperty("Title", "Neutral") 
    end
    CreateObj("spawn_portal",this:GetLoc(),"spawn_portal")
end)

RegisterEventHandler(EventType.CreatedObject,"spawn_portal",
function(success,objRef,target)
    if (success and objRef ~= nil) then
        mSpawnPortal = objRef
        objRef:SendMessage("UpdateDecay",10)
    end
end)

RegisterEventHandler(EventType.Arrived,"GoToPortal",
    function (success)
        --if (not success) then
            --DebugMessage("[ai_super_guard] ERROR: Failed to path back to portal.")
        --end
        if (AI.MainTarget == nil) then
            PlayEffectAtLoc("TeleportToEffect",this:GetLoc())
            this:Destroy()
            if (mSpawnPortal ~= nil) then
                mSpawnPortal:SendMessage("UpdateDecay",2)
            end
        elseif (mSpawnPortal ~= nil) then
            mSpawnPortal:SendMessage("DestroyPortal")
        end
    end)

AI.Settings.Debug = false
-- set charge speed and attack range in combat ai
AI.Settings.ChargeSpeed = 6.0

AI.Settings.AggroRange = 10.0
AI.Settings.ChaseRange = 15.0
AI.Settings.LeashDistance = 20
AI.Settings.CanConverse = true
AI.Settings.ScaleToAge = false
AI.Settings.CanWander = false
AI.Settings.CanUseCombatAbilities = true
AI.Settings.CanCast = false
AI.Settings.ChanceToNotAttackOnAlert = 2