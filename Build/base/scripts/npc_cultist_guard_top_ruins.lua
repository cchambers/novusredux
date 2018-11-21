require 'ai_cultist'
require 'incl_faction'
require 'base_npc_extensions'

AI.Settings.Leash = true
AI.Settings.StationedLeash = true


AddView("TopGuardRange", SearchPlayerInRange(10), 1.0)

RegisterEventHandler(EventType.EnterView,"TopGuardRange",
function (object)
		if (not CanUseNPC(object)) then return end

			this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"CheckEntryTopRuins",object)
			if (IsInCombat(this) or IsInCombat(object) or not (AI.StateMachine.CurState == "Idle" or AI.StateMachine.CurState == "Converse" or AI.StateMachine.CurState == "Alert")) then 
				--DebugMessage("Current state is "..tostring(AI.StateMachine.CurState)) 
				return 
			end
			--this:SendMessage("StartQuest","JoinCultQuest")
			--this:PlayAnimation("point")

			--DebugMessageA(this,"Firing")

			local faction = GetFaction(object)

			if (faction ~= nil and faction < 0) then DebugMessageA(this,"Enemy Top Ruins") return end --no entry for enemies of the religion
			
			if (faction == nil or faction <= 10) then
				text = "[$2058]"
			else 
				text = "You are free to come and go, brethren."
			end

			response = {}

			if (faction == nil or faction <= 10) then
				response[1] = {}
				response[1].text = "I'll pay to get in."
				response[1].handle = "Bribe" 
		    end

			response[2] = {}
			response[2].text = "Ok."
			response[2].handle = "" 

			NPCInteraction(text,this,object,"Answer",response,nil,15)
end)

RegisterEventHandler(EventType.DynamicWindowResponse, "Answer",
function (object,buttonID)
	DebugMessageA(this,"Try")
	if (not CanUseNPC(object)) then return end
	if (IsInCombat(this)) then return end
	if (buttonID == "Bribe") then

			local king = FindObject(SearchModule("ai_cultist_king"))
			if (object == nil or not object:IsValid()) then
				text = "[$2059]"
			else
				text = "[$2060]" ..king:GetName().. ", our dear and faithful lord."
			end

			response = {}

			response[2] = {}
			response[2].text = "Whatever."
			response[2].handle = "" 

			NPCInteraction(text,this,object,"Answer",response,nil,15)
	end
end)

RegisterEventHandler(EventType.Timer, "CheckEntryTopRuins",
	function(target)
		if (not CanUseNPC(target)) then return end
		if (IsInCombat(this)) then return end
		if (target ~= nil and target:IsValid()) then
			DebugMessageA(this,"Checking if in ruins")
			if (target:DistanceFrom(this) > 30) then 
				return 
			end
			--check to see if he's got access
			local faction = GetFaction(target)
			if (faction == nil or faction < 10) then
				if( target:IsInRegion("TopRuins") ) then
					this:SendMessage("AttackEnemy",target)
					return
				end
			end
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"CheckEntryRuins",target)
		end
	end)

