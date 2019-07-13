require 'NOS:base_ai_mob'
require 'NOS:base_ai_casting'
require 'NOS:base_ai_intelligent'
require 'NOS:base_ai_conversation'

AI.Settings.Debug = false
AI.Settings.AggroRange = 10.0
AI.Settings.ChaseRange = 15.0
AI.Settings.Leash = true
AI.Settings.LeashDistance = 20
AI.Settings.CanConverse = true
AI.Settings.ScaleToAge = false
AI.Settings.CanWander = false
AI.Settings.CanUseCombatAbilities = true
AI.Settings.CanCast = true
AI.Settings.ChanceToNotAttackOnAlert = 2

gotAttacked = false

RegisterEventHandler(EventType.Message, "DamageInflicted",
	function (damager)
        gotAttacked = true
        if (IsFriend(attacker) and AI.Anger < 100) then return end
		if AI.IsValidTarget(damager) then
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

AI.StateMachine.AllStates.Alert = {       
        OnEnterState = function() 
            this:PlayAnimation("alarmed")
            
            alertTarget = FindAITarget()

            if( alertTarget == nil ) then
               DebugMessageA(this,"Changing to idle from alert")
               gotAttacked = false
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
                local chanceAttackAnyway = 10 --should I attack anyway
                local shouldInsult = true
				local nearbyPlants = FindObjects(SearchMulti({SearchRange(this:GetLoc(),15),SearchHasObjVar("ResourceSourceId")}))

				for i,j in pairs(nearbyPlants) do
					if (alertTarget:DistanceFrom(j) < 2) then
						shouldAttack = true
					end
				end

				if (alertTarget:HasTimer("CompleteHarvest")) then
					shouldAttack = true
				end

                if (shouldAttack) then
					this:NpcSpeech("GET OUT OF MY CROPS!!!")
                    AttackEnemy(alertTarget,true)
                elseif (gotAttacked) then
                    AttackEnemy(alertTarget, true)
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
            end
        end,
    }

--Function that determine's what team I'm on. Override this for custom behaviour.
function IsFriend(target)
    if (not AI.IsValidTarget(target)) then return true end
    if (target == nil) then
        DebugMessage("[ai_villager|IsFriend] ERROR: target is nil")
        return true
    end
    local otherTeam = target:GetObjVar("MobileTeamType")
    local myTeam = this:GetObjVar("MobileTeamType")

    if (target:IsPlayer()) then return false end

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