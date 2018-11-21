require 'ai_cultist'

SnakeCooldown = true

table.insert(AI.CombatStateTable,{StateName = "SpawnSnakes",Type = "rangedattack",Range = 7})

function HandleCreated(success,objRef,snakeList)
	if( success ) then
		objRef:SendMessage("AttackEnemy",AI.MainTarget)
        table.insert(snakeList,objRef)
        this:SetObjVar("SnakeList",snakeList)
	end
end

--make little ones
AI.StateMachine.AllStates.SpawnSnakes = {
        GetPulseFrequencyMS = function() return 1000 + math.random(400) end,

        OnEnterState = function()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end
            --DebugMessage("Attempting Imp Spawn")
            FaceTarget()
            if (not SnakeCooldown) then
                AI.StateMachine.ChangeState("Chase")                
                return
            end

            this:StopMoving()
            this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(10000), "cooldownSnakes")
            this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(700), "SpawnSnakes")
			this:PlayAnimation("cast")
            this:PlayEffect("CastAir",0.5)
            this:PlayObjectSound("CastAir",false,0.7)
			
            SnakeCooldown = false
        end,

        AiPulse = function()
            DecideCombatState()
        end,
        
        OnExitState = function()
            this:SendMessage("CancelSpellCast")
        end,
    }

RegisterEventHandler(EventType.Timer,"cooldownSnakes", function()
	SnakeCooldown = true
	end)

RegisterEventHandler(EventType.Timer,"SpawnSnakes", function()

        local SnakeList = {}
        if (this:HasObjVar("SnakeList")) then            
            SnakeList = this:GetObjVar("SnakeList")
        end
        --DebugMessage("SnakeList is size "..#SnakeList)
		if (#SnakeList >= 3) then return end

		this:PlayAnimation("cast")
		this:PlayEffect("CastAir",0.5)
		this:PlayObjectSound("CastAir",false,0.7)
        SpawnSnake(SnakeList)
        
        this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(700), "SpawnSnakes")
	end)
		--gameObj:SendMessage("Resurrect",1.0)

function SpawnSnake(snakeList)
		this:PlayAnimation("cast")
		local spawnLoc = this:GetLoc():Project(this:GetFacing(), math.random(2,5))
		local snake = CreateObj("viper", spawnLoc, "viperSpawned", snakeList)
end

AI.Settings.Debug = false
AI.Settings.AggroRange = 8.0
AI.Settings.ChaseRange = 8.0
AI.Settings.LeashDistance = 20
AI.Settings.CanConverse = true
AI.Settings.ScaleToAge = false
AI.Settings.CanWander = false
AI.Settings.CanUseCombatAbilities = true
AI.Settings.CanCast = true
AI.Settings.ChanceToNotAttackOnAlert = 2

RegisterEventHandler(EventType.CreatedObject, "viperSpawned", HandleCreated)

