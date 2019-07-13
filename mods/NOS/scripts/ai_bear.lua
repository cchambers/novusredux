require 'NOS:base_ai_mob'
require 'NOS:incl_regions'

AI.Settings.MaxAgeScale = 1.5 --Maximum scale that a mob can age.

AI.StateMachine.AllStates.Idle = {   
        GetPulseFrequencyMS = function() return 1000 end,

        AiPulse = function()
            --DebugMessage("Idle pulse")
            if math.random(AI.GetSetting("WanderChance")) <= 1 and AI.GetSetting("CanWander") == true then 
                AI.StateMachine.ChangeState("Wander")
            elseif (AI.GetSetting("Age") <= 6) then
            	--Follow mom
	            local bearMother = this:GetObjVar("cubMother")
	            local followRange = this:GetObjVar("cubFollowRange")
	            if( bearMother ~= nil and bearMother:IsValid() ) then
	                this:PathToTarget(bearMother,followRange,1.0)
	            else
	                local homeRegion = this:GetObjVar("homeRegion")
	                WanderInRegion(homeRegion)
	            end
        	end
        end,
    }

--Tell mother we are getting attacked
RegisterEventHandler(EventType.Message, "DamageInflicted",
function (damager,damageAmt)    
    if (IsFriend(attacker) and AI.Anger < 100) then return end
    
    if (IsDead(this)) then AI.StateMachine.ChangeState("Dead") return end
    if not(AI.IsActive()) then
        return 
    end

	local bearMother = this:GetObjVar("cubMother")
    if( bearMother ~= nil and bearMother:IsValid() ) then
    	bearMother:SendMessage("cubDamaged",damager)
    end
end) 

--Get Enraged when cubs are killed
RegisterEventHandler(EventType.Message, "cubDamaged",
	function (damager)
		AttackEnemy(damager)
	end)