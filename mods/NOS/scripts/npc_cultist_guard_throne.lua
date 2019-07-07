require 'ai_cultist'
require 'incl_faction'
require 'base_npc_extensions'

AI.Settings.Leash = true
AI.Settings.StationedLeash = true


AddView("ThroneGuardRange", SearchPlayerInRange(10), 1.0)

RegisterEventHandler(EventType.EnterView,"ThroneGuardRange",
function (object)
	if (not CanUseNPC(object)) then return end
	
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"CheckEntryThrone",object)
			
			if (IsInCombat(this) or IsInCombat(object) or not (AI.StateMachine.CurState == "Idle" or AI.StateMachine.CurState == "Converse" or AI.StateMachine.CurState == "Alert")) then 
				--DebugMessage("Current state is "..tostring(AI.StateMachine.CurState)) 
				return 
			end
			
			--this:PlayAnimation("point")

			--DebugMessageA(this,"Firing")


			local king = FindObject(SearchModule("ai_cultist_king"))
			local faction = GetFaction(object)

			if (faction ~= nil and faction < 0) then DebugMessageA(this,"Enemy at the Throne") return end --no entry for enemies of the religion
			
			if (faction == nil or faction <= 20) then
				text = "[$2054]"
			elseif (faction ~= nil or faction >= 50 and king ~= nil) then
				text = "[$2055]" .. king:GetName()..", and utilize his counsul."
			elseif (faction ~= nil or faction >= 50 and king == nil) then
				text = "[$2056]"
			else 
				text = "[$2057]"
			end

			response = {}

			response[2] = {}
			response[2].text = "Ok."
			response[2].handle = "" 

			NPCInteraction(text,this,object,"Answer",response,nil,15)
end)

RegisterEventHandler(EventType.Timer, "CheckEntryThrone",
	function(target)
	if (not CanUseNPC(target)) then return end
	if (IsInCombat(this)) then return end
		if (target ~= nil and target:IsValid()) then
			DebugMessageA(this,"Checking if in throne room")
			if (target:DistanceFrom(this) > 30) then 
				return 
			end
			--check to see if he's got access
			local faction = GetFaction(target)
			if (faction == nil or faction < 50) then
				if( target:IsInRegion("RuinsThroneRoom") ) then
					this:SendMessage("AttackEnemy",target)
					return
				end
			end
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"CheckEntryRuins",target)
		end
	end)

