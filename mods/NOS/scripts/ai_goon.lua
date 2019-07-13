require 'NOS:base_ai_mob'
require 'NOS:base_ai_casting'
require 'NOS:base_ai_intelligent'
require 'NOS:base_ai_conversation'

--npc's should all have this
function IsFriend(target)
    --My only enemy is the enemy
    if (AI.InAggroList(target)) then
        return false
    else
        return true
    end
end

AI.StateMachine.AllStates.Follow = {
    GetPulseFrequencyMS = function() return 1000 end,

    AiPulse = function()
        --DebugMessage(this:GetName().." is the goon")
        --D*ebugMessage("Idle pulse")        
        --if( following ~= nil ) then
            --local superior = this:GetObjVar("controller")
            --if( following ~= superior ) then
            --    AI.StateMachine.ChangeState("Idle")
           -- end
        --end       
        local superior = this:GetObjVar("controller")
        if (superior ~= nil) then
            if (superior:GetObjVar("CurrentTarget") ~= nil 
                and superior:GetObjVar("CurrentTarget") ~= superior 
                and IsInCombat(superior) 
                and this:DistanceFrom(superior) < AI.GetSetting("AggroRange")) then
                --DebugMessage("AttackingEnemy")
                this:SendMessage("AttackEnemy",superior:GetObjVar("CurrentTarget"),true)
            else
                --DebugMessage("Following")
                following = superior
                this:PathToTarget(superior,3,4.0)
            end
        else
            AI.StateMachine.ChangeState("Wander")
        end
    end,
}
AI.StateMachine.AllStates.Follow.OnEnterState = function ( ... )
    local superior = this:GetObjVar("controller")
    --DebugMessage("OnEnterState, superior is "..tostring(superior))
    if (superior ~= nil) then
        following = superior
        this:PathToTarget(superior,3,4.0)
    end
end

AI.StateMachine.AllStates.Idle = {   
        GetPulseFrequencyMS = function() return 1000 end,

        OnEnterState = function()
	        local superior = this:GetObjVar("controller")
	        if (superior ~= nil) then
	            AI.StateMachine.ChangeState("Follow")
	        else
	        	AI.StateMachine.ChangeState("Wander")
	        end
        end,
}

AI.StateMachine.AllStates.Wander = {
        GetPulseFrequencyMS = function() return 5000 end,

        OnEnterState = function()
           --DebugMessage("Wander start")
            local homeRegion = this:GetObjVar("homeRegion")
            WanderInRegion(homeRegion,"Wander")
        end,

        AiPulse = function()
	        local superior = this:GetObjVar("controller")
	        
	        if (superior ~= nil) then
	        	AI.StateMachine.ChangeState("Follow")
	        	return
	        end
           --DebugMessage("Wander pulse")
            --this:NpcSpeech("[f70a79]*Wander!*[-]")
			local homeRegion = this:GetObjVar("homeRegion")
            DebugMessageA(this,"Changing state in wander.") 
        	if math.random(AI.GetSetting("WanderChance")) <= 1 then 
        		AI.StateMachine.ChangeState("Idle")
        	else 
        		AI.StateMachine.ChangeState("Wander")
        	end
          	WanderInRegion(homeRegion,"Wander")
        end
},

RegisterEventHandler(EventType.Message, "DamageInflicted",
	function (damager)
		if AI.IsValidTarget(damager) then
            if (IsFriend(attacker) and AI.Anger < 100) then return end
            local myTeamType = this:GetObjVar("MobileTeamType")
		    local nearbyTeamMembers = FindObjects(SearchMulti(
		    {
		        SearchMobileInRange(20), --in 10 units
		        SearchObjVar("MobileTeamType",myTeamType), --find others with my team type
		    }))
		    for i,j in pairs (nearbyTeamMembers) do
		        j:SendMessage("AddThreat",damager,2) --defend me
		    end
		end
	end)

--Check to see if we're outside our leash from my superior and if so, run to him
RegisterEventHandler(EventType.Timer,"CheckFollowerLeash",function ()
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"CheckFollowerLeash")
    local superior = this:GetObjVar("controller")
    if (superior ~= nil and superior:IsValid() and this:TopmostContainer() == nil) then
        if (superior:DistanceFrom(this) > AI.GetSetting("LeashDistance") and AI.StateMachine.CurState ~= "Stay") then
            AI.StateMachine.ChangeState("Follow")
        end
    end
end)
this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"CheckFollowerLeash")

AI.Settings.Debug = false
AI.Settings.AggroRange = 10.0
AI.Settings.ChaseRange = 15.0
AI.Settings.LeashDistance = 10
AI.Settings.CanConverse = true
AI.Settings.ScaleToAge = false
AI.Settings.CanWander = false --overridden in idle state
AI.Settings.CanUseCombatAbilities = true
AI.Settings.CanCast = true
AI.Settings.ChanceToNotAttackOnAlert = 2
