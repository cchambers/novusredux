require 'base_ai_mob'
require 'base_ai_casting'
require 'base_ai_conversation'
require 'base_ai_intelligent'

AI.Settings.Debug = false
AI.Settings.AggroRange = 10.0
AI.Settings.ChaseRange = 15.0
AI.Settings.LeashDistance = 20
AI.Settings.CanConverse = true
AI.Settings.ScaleToAge = false
AI.Settings.CanWander = false
AI.Settings.CanUseCombatAbilities = true
AI.Settings.CanCast = true
AI.Settings.CanConverse = false
AI.Settings.ChanceToNotAttackOnAlert = 2
AI.Settings.SpeechTable = "Dancer" 

function IsFriend(target)
    --My only enemy is the enemy
    if (AI.InAggroList(target)) then
        --DebugMessage(1)
        return false
    else
        --DebugMessage(2)
        return true
    end
end

function DecideIdleState()
    if (IsInCombat(this)) then
        this:SendMessage("EndCombatMessage")
    end
    
	if (math.random(1,7) == 1) then
		AI.StateMachine.ChangeState("Wander")
	elseif (math.random(1,3) == 1) then
		AI.StateMachine.ChangeState("Idle")
	else
		AI.StateMachine.ChangeState("Dance")
	end
end

danceAnims = {
	"dance_wave",
	"dance_gangamstyle",	
	"dance_bellydance",
	"dance_cabbagepatch",
	"dance_chickendance",
	"dance_guitarsolo",
	"dance_headbang",
	"dance_hiphop",
	"dance_macarena",
	"dance_raisetheroof",
	"dance_robot",
	"dance_runningman",
	"dance_twist",
}

AI.StateMachine.AllStates.Dance = { 
        GetPulseFrequencyMS = function() return math.random(1500,2000) end,
        AiPulse = function() 
        	this:PlayAnimation(danceAnims[math.random(1,#danceAnims)])
        	this:SetFacing(math.random(1,360))
        	DecideIdleState()
        end,        
    }
AI.StateMachine.AllStates.Idle =
{ 
        GetPulseFrequencyMS = function() return math.random(5000,6000) end,
        OnEnterState = function ( ... )
			AI.Settings.CanConverse = true
        	this:PlayAnimation(danceAnims[math.random(1,#danceAnims)])
        	this:SetFacing(math.random(1,360))
        end,
        AiPulse = function() 
        	DecideIdleState()
        end,     
       	OnExitState = function ( ... )
			AI.Settings.CanConverse = false
        end,   
    }

AI.StateMachine.AllStates.Wander.OnEnterState = function()
           --DebugMessage("Wander start")
        	this:PlayAnimation(danceAnims[math.random(1,#danceAnims)])
        	this:SetFacing(math.random(1,360))
            local homeRegion = this:GetObjVar("homeRegion")
            WanderInRegion(homeRegion,"Wander")
        end