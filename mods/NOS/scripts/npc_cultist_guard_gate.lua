require 'ai_cultist'
require 'incl_faction'
require 'base_npc_extensions'

DebugMessageA(this,"Module loaded")

AI.Settings.Leash = true
AI.Settings.StationedLeash = true


AddView("GateGuardRange", SearchMulti({SearchUser(),SearchRange(this:GetLoc(),10)}), 1.0)

RegisterEventHandler(EventType.EnterView,"GateGuardRange",
function (object)
	if (object == nil or not object:IsValid()) then return end
		if (not CanUseNPC(object)) then return end
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"CheckEntryRuins",object)

			if (IsInCombat(this) or IsInCombat(object) or not (AI.StateMachine.CurState == "Idle" or AI.StateMachine.CurState == "Converse" or AI.StateMachine.CurState == "Alert")) then 
				--DebugMessage("Current state is "..tostring(AI.StateMachine.CurState)) 
				return 
			end

			DebugMessageA(this,"Passing inital args")


			object:SendMessage("StartQuest","JoinCultQuest")
			if( object:IsInRegion("UpperRuins") ) then DebugMessageA(this,"UpperRuins") return end
			if( object:HasObjVar("RuinsEntryBribe" ) )then DebugMessageA(this,"Bribed") return end

			local faction = GetFaction(object)

			if (faction ~= nil and faction < 0) then DebugMessageA(this,"Enemy") return end --no entry for enemies of the religion

			--this:PlayAnimation("point")

			if (faction == nil or faction <= 10) then
				text = "[$2051]"
			else 
				text = "You are free to come and go, bretheren."
			end

			response = {}

			if (faction == nil or faction <= 10) then
				response[1] = {}
				response[1].text = "What does it take to get in?"
				response[1].handle = "Bribe" 
		    end

			response[2] = {}
			response[2].text = "Ok."
			response[2].handle = "" 

			NPCInteraction(text,this,object,"Answer",response,nil,15)
end)

RegisterEventHandler(EventType.DynamicWindowResponse, "Answer",
function (object,buttonID)

	if (IsInCombat(this)) then return end
	if (not CanUseNPC(object)) then return end
	
	local amount = 100
	if (buttonID == "Bribe") then

			text = "[$2052]"..amount.." coin[-] ... provided you keep quiet and not disturb the faithful."
			

			response = {}

			response[1] = {}
			response[1].text = "I'll pay to get in.[FFFF00](100 gold)[-]"
			response[1].handle = "Pay" 

			response[2] = {}
			response[2].text = "Whatever."
			response[2].handle = "" 

			NPCInteraction(text,this,object,"Answer",response,nil,15)
	end
	if (buttonID == "Pay") then
			RequestConsumeResource(object,"coins",100,"Bribe",this)

			this:PlayAnimation("transaction")

	end
end)

RegisterEventHandler(EventType.Message, "ConsumeResourceResponse", 
	function (success,transactionId,user)
	if (not CanUseNPC(user)) then return end
		if (transactionId ~= "Bribe") then
			return false
		end
		-- something went wrong taking the coins
		if( not(success) ) then
			text = "[$2053]"				
					
			response = {}

			response[2] = {}
			response[2].text = "Whatever."
			response[2].handle = "" 

			NPCInteraction(text,this,user,"Answer",response,nil,15)
			return
		else
			local faction = GetFaction(user)
			if (faction == nil or faction <= 3) then
				faction = 3
			end

			text = "Very well, you may enter ... unbeliever."

			response = {}

			response[2] = {}
			response[2].text = "Thanks."
			response[2].handle = "" 

			SetFactionToAmount(user,faction,this:GetObjVar("MobileTeamType"))
			user:SetObjVar("RuinsEntryBribe",true)
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(60*15),"RemoveBribe",user)

			NPCInteraction(text,this,user,"Answer",response,nil,15)	
		end

	end)

RegisterEventHandler(EventType.LeaveView, "chaseRange", function()
	this:SendMessage("EndCombatMessage")
end)

RegisterEventHandler(EventType.Timer, "CheckEntryRuins",
	function(target)
	if (not CanUseNPC(target)) then return end
		if (IsInCombat(this)) then return end
		if (target ~= nil and target:IsValid()) then
			DebugMessageA(this,"Checking if in ruins")
			if (target:DistanceFrom(this) > 30) then 
				return 
			end
			--check to see if he's got access
			if (not target:HasObjVar("RuinsEntryBribe")) then
				local faction = GetFaction(target)
				if (faction == nil or faction < 10) then
					if( target:IsInRegion("CultistRuins") ) then
						this:SendMessage("AttackEnemy",target)
						return
					end
				end
			else 
				return 
			end
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(10),"CheckEntryRuins",target)
		end
	end)

--remove bribe effect once he leaves ruins.
RegisterEventHandler(EventType.Timer, "RemoveBribe",
	function(target)
	if (target ~= nil or not target:IsValid() or not target:HasObjVar("RuinsEntryBribe")) then
		if( not target:IsInRegion("CultistRuins")  ) then
			target:DelObjVar("RuinsEntryBribe")
			return
		end
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(60*15),"RemoveBribe",target)
	end
end)
