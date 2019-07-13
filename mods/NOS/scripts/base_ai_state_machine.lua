-- Create StateMachine namespace

if not(AI) then AI = {} end

AI.StateMachine = {
	AllStates = {},
	CurState = "",
	LastState = "",
}

function ScheduleStateEventTimer(delay,identifier,func,params)
	local eventState = AI.StateMachine.CurState

	if(eventState) then
		this:ScheduleTimerDelay(delay,identifier)
		RegisterSingleEventHandler(EventType.Timer,identifier,function ()
			if(AI.StateMachine.CurState == eventState) then
				stateTable = AI.StateMachine.GetCurStateTable()
				func(stateTable,params)
			end
		end)
	end
end

function ScheduleSubStateEventTimer(delay,identifier,func,params)
	local eventState = AI.StateMachine.CurState
	local eventSubState = AI.StateMachine.GetCurSubStateName()

	if(eventSubState) then
		this:ScheduleTimerDelay(delay,identifier)
		RegisterSingleEventHandler(EventType.Timer,identifier,function ()
			if(AI.StateMachine.CurState == eventState) then
				if(AI.StateMachine.GetCurSubStateName() == eventSubState) then
					func(AI.StateMachine.GetCurSubStateTable(),params)
				end
			end
		end)
	end
end

function RegisterStateEventHandler(eventType,identifier,func)
	local eventState = AI.StateMachine.CurState

	if(eventState) then
		RegisterEventHandler(eventType,identifier,function (...)
			if(AI.StateMachine.CurState == eventState) then
				stateTable = AI.StateMachine.GetCurStateTable()
				func(stateTable,...)
			end
		end)
	end
end

function RegisterSubStateEventHandler(eventType,identifier,func)
	local eventState = AI.StateMachine.CurState
	local eventSubState = AI.StateMachine.GetCurSubStateName()

	if(eventSubState) then
		RegisterEventHandler(eventType,identifier,function (...)
			if(AI.StateMachine.CurState == eventState) then
				if(AI.StateMachine.GetCurSubStateName() == eventSubState) then
					func(AI.StateMachine.GetCurSubStateTable(),...)
				end
			end
		end)
	end
end


function AI.StateMachine.GetCurStateTable()
	return AI.StateMachine.AllStates[AI.StateMachine.CurState]
end

function AI.StateMachine.GetCurSubStateTable()
	local stateTable = AI.StateMachine.GetCurStateTable()
	if(stateTable.CurSubState ~= nil) then
		return stateTable.SubStates[stateTable.CurSubState]
	end
end

function AI.StateMachine.GetCurSubStateName()
	local stateTable = AI.StateMachine.GetCurStateTable()
	return stateTable.CurSubState
end


function AI.StateMachine.GetStateTable(stateName)
	return AI.StateMachine.AllStates[stateName]
end

function AI.StateMachine.GetSubStateTable(stateName,substateName)
	return AI.StateMachine.AllStates[stateName].Substates[substateName]
end

function SchedulePulse()
	if (AI.StateMachine.AllStates ~= nil) then
		local curStateTable = AI.StateMachine.GetCurStateTable()
		if (curStateTable) then			
			local nextPulse = nil
			--DebugMessageA(this,"CurSubState pulse")
			if( curStateTable.CurSubState ~= nil and curStateTable.SubStates ~= nil) then
				--DebugMessageA(this,"CurSubState is not nil")
				local curSubStateTable = curStateTable.SubStates[curStateTable.CurSubState]
				--DebugMessageA(this,"curStateTable.CurSubState is "..tostring(curStateTable.CurSubState))
				if( curSubStateTable.GetPulseFrequencyMS ) then
					--DebugMessageA(this,"CurSubState GetPulseFrequencyMS is not nil")
					nextPulse = curSubStateTable:GetPulseFrequencyMS()
				end
			end

			if( nextPulse == nil and curStateTable.GetPulseFrequencyMS ~= nil ) then
				nextPulse = curStateTable:GetPulseFrequencyMS()								
			end

			if( nextPulse ~= nil ) then
				local minDelay = 250
				nextPulse = math.max(minDelay,nextPulse)
				--this:NpcSpeech("NEXT PULSE: "..tostring(nextPulse).. " MIN: "..tostring(minDelay))
				nextPulse = nextPulse + math.random(1,50)
				this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(nextPulse), "aiPulse")
				return true
			end
		else
			DebugMessage("[ERROR: base_ai_state_machine.SchedulePulse] CurState is nil!")
		end
	else
		DebugMessage("[ERROR: base_ai_state_machine.SchedulePulse] AI.StateMachine.AllStates is nil!")
	end

	return false
end

function AI.StateMachine.Init(initialState)
	--LuaDebugCallStack("[StateMachine::Init] ".. this:GetName() .. ": "..tostring(initialState))
	if(initialState == nil or initialState == "" or AI.StateMachine.AllStates[initialState] == nil) then
		LuaDebugCallStack("[AI][Init] ERROR: Invalid initial state "..initialState)
	end
	AI.StateMachine.CurState = initialState
	DebugMessageA(this,"[AI][Init] initialState: "..tostring(initialState))
	
	if (AI.StateMachine.AllStates ~= nil) then
		local curStateTable = AI.StateMachine.GetCurStateTable()
		if (curStateTable ~= nil) then			
			if( curStateTable.OnEnterState ~= nil ) then
				curStateTable:OnEnterState()
				-- we changed states in enter state so dont mess with the substates
				if(AI.StateMachine.CurState ~= initialState) then
					return
				end
			end	

			if( curStateTable.SubStates ~= nil and curStateTable.InitialSubState ~= nil ) then				
				if( curStateTable.CurSubState == nil ) then
					curStateTable.CurSubState = curStateTable.InitialSubState
				end
				local curSubStateTable = curStateTable.SubStates[curStateTable.CurSubState]
				if( curSubStateTable.OnEnterState ~= nil ) then
					curSubStateTable:OnEnterState(curStateTable)
				end
			end
		else
			DebugMessage("[ERROR: base_ai_state_machine.Init] CurState is nil!")
		end
	else
		DebugMessage("[ERROR: base_ai_state_machine.Init] AI.StateMachine.AllStates is nil!")
	end
	SchedulePulse()
end

function AI.StateMachine.Shutdown()
	this:RemoveTimer("aiPulse")
end

local changeStateProtectCounter = 0
local lastObjectFrameTimeMs = 0
local frameStateChanges = {}

function AI.StateMachine.ChangeState(newState)
	if(newState == nil) then
		DebugMessageA(this,"[AI][ChangeState] ERROR: newState is nil!")
	end

	-- its possible for some code to fire before AI.Init is called so just ignore
	if(AI.StateMachine.CurState == "") then
		DebugMessageA(this,"[AI][ChangeState] Change state called on state machine that has not yet been initialized")
		return
	end

	--DebugMessage(newState .. " from " .. this:GetName())
	if  (AI.StateMachine.CurState == nil) then
		DebugMessageA(this,"[AI][ChangeState] ERROR: Current State is nil!")
	end
	if (this:HasObjVar("Debug")) then
		this:SetObjVar("AI_STATE",newState)
	end
	DebugMessageA(this,"[AI][ChangeState] newState: "..tostring(newState)..", oldState: "..tostring(AI.StateMachine.CurState))
	--this:NpcSpeech("[AI][ChangeState] newState: "..tostring(newState)..", oldState: "..tostring(AI.StateMachine.CurState))

	if( newState ~= AI.StateMachine.CurState ) then
		-- USE THIS CODE TO CHECK FOR MISBEHAVING AI
		if(this:HasTimer("StateDelayProtect") and changeStateProtectCounter > 5) then
			--DebugMessage("[AI][ChangeState] WARNING: Mob changed state more than 5 times in the last few seconds, "..tostring(this:GetName()).."("..tostring(this.Id)..") - "..tostring(newState))
			--LuaDebugCallStack("Callstack:")
		elseif(not(this:HasTimer("StateDelayProtect"))) then
			changeStateProtectCounter = 0
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"StateDelayProtect")
		else			
			changeStateProtectCounter = changeStateProtectCounter + 1
		end

		-- STACK OVERFLOW PROTECTION
		local frameTime = ObjectFrameTimeMs()
		--DebugMessage("FRAMETIME: "..frameTime)
		if(frameTime ~= lastObjectFrameTimeMs) then
			--DebugMessage("CLEARING")
			lastObjectFrameTimeMs = frameTime
			frameStateChanges = {}
		elseif(CountTable(frameStateChanges,newState) > 1) then
			table.insert(frameStateChanges,newState)
			LuaDebugCallStack("["..this.Id.."][AI][ChangeState] ERROR: STACK OVERFLOW PROTECTION: "..GetCurrentModule()..", "..DumpTable(frameStateChanges))
			local controller = this:GetObjVar("controller")
			if(controller and controller:IsValid()) then
				DebugMessage("["..this.Id.."][AI][ChangeState] Owner is "..controller:GetName())
			end
			error()
		end		
		--DebugMessage("ADDING " .. newState)
		table.insert(frameStateChanges,newState)

		this:SetObjVar("CurrentState",newState)		
		local curStateTable = AI.StateMachine.GetCurStateTable()
		if(curStateTable == nil) then
			LuaDebugCallStack("[AI][ChangeState] ERROR: INVALID PREVIOUS STATE: "..tostring(AI.StateMachine.CurState))
		end
		--DebugMessage("Exit State "..tostring(AI.StateMachine.CurState))
		if (curStateTable.SubStates ~= nil and curStateTable.CurSubState ~= nil) then
			local curSubStateTable = curStateTable.SubStates[curStateTable.CurSubState]
			if( curSubStateTable.OnExitState ~= nil ) then
				DebugMessageA(this,"[AI][ChangeState] OnExitSubState: "..tostring(curStateTable.CurSubState))
				curSubStateTable:OnExitState()
			end			
		end

		if( curStateTable.OnExitState ~= nil ) then
			DebugMessageA(this,"[AI][ChangeState] OnExitState: "..tostring(AI.StateMachine.CurState))
			curStateTable:OnExitState(newState)
		end
		
		AI.StateMachine.LastState = AI.StateMachine.CurState
		AI.StateMachine.CurState = newState

		--DebugMessage("Enter State "..AI.StateMachine.CurState)
		curStateTable = AI.StateMachine.GetCurStateTable()
		if (curStateTable ~= nil) then
			if( curStateTable.OnEnterState ~= nil ) then
				DebugMessageA(this,"[AI][ChangeState] OnEnterState: "..tostring(AI.StateMachine.CurState))
				curStateTable:OnEnterState()
				-- we changed states in enter state so dont mess with the substates
				if(AI.StateMachine.CurState ~= newState) then
					return
				end
			end

			if( curStateTable.SubStates ~= nil  ) then	
				if( curStateTable.CurSubState == nil ) then
					if (curStateTable.InitialSubState == nil) then
						DebugMessage("[base_ai_state_machine] Error! InitialSubState is nil for "..this:GetName())
						return
					end
					curStateTable.CurSubState = curStateTable.InitialSubState
				end
				local curSubStateTable = curStateTable.SubStates[curStateTable.CurSubState]
				if( curSubStateTable.OnEnterState ~= nil ) then
					DebugMessageA(this,"[AI][ChangeState] OnEnterSubState: "..tostring(curStateTable.CurSubState))
					curSubStateTable:OnEnterState(curStateTable)
				end
			end
		end
		
		-- if this state has no ai pulse, then remove the previous state pulse
		--if( not(SchedulePulse()) ) then 
		this:RemoveTimer("aiPulse")
		SchedulePulse()
		--end
	end
end

function AI.StateMachine.ChangeSubState(newState)
	local curStateTable = AI.StateMachine.GetCurStateTable()
	if (curStateTable ~= nil) then
		--if( curStateTable.SubStates == nil or curStateTable.SubStates[newState] == nil ) then
		--	DebugMessage("[AI][ChangeSubState] ERROR: Sub state does not exist in current state")		
		--end

		if (curStateTable.SubStates ~= nil) then
			local curSubStateTable = curStateTable.SubStates[curStateTable.CurSubState]
			if( curStateTable.CurSubState ~= nil ) then
				if( curSubStateTable.OnExitState ~= nil ) then
					DebugMessageA(this,"[AI][ChangeSubState] OnExitState: "..tostring(curStateTable.CurSubState))
					curSubStateTable:OnExitState()
				end
			end
		end

		curStateTable.LastSubState = curStateTable.CurSubState
		curStateTable.CurSubState = newState

		if (curStateTable.SubStates ~= nil) then
			local curSubStateTable = curStateTable.SubStates[curStateTable.CurSubState]
			if (curSubStateTable ~= nil) then
				if( curSubStateTable.OnEnterState ~= nil ) then
					DebugMessageA(this,"[AI][ChangeSubState] OnEnterState: "..tostring(curStateTable.CurSubState))
					curSubStateTable:OnEnterState(curStateTable)
				end
			end
		end
		
		-- if this state has no ai pulse, then remove the previous state pulse
		--if( not(SchedulePulse()) ) then 
		this:RemoveTimer("aiPulse")
		SchedulePulse()
		--end
	end
end

function AI.StateMachine.EndSubStates(success,reason)
	local curStateTable = AI.StateMachine.GetCurStateTable()
	if (curStateTable ~= nil and curStateTable.CurSubState ~= nil ) then
		if( curStateTable.OnEndSubStates ~= nil ) then
			DebugMessageA(this,"[AI][EndSubStates] Finalizing Sub State Machine: "..tostring(curStateTable.CurSubState))
			curStateTable.OnEndSubStates(success,reason)
		end

		curStateTable.CurSubState = nil
	end
end

function HandleAiPulse()
	-- DAB HACK: We should never pulse if we are in an invalid state but w/e
	if(AI.StateMachine.CurState == nil or AI.StateMachine.CurState == "") then
		return
	end

	local curStateTable = AI.StateMachine.GetCurStateTable()
	if( AI.StateMachine.CurState == nil or curStateTable == nil ) then
		LuaDebugCallStack("ERROR: Pulse for "..this:GetName().." in state: "..tostring(AI.StateMachine.CurState).. " failed")
		return
	end

	if( curStateTable.AiPulse ~= nil ) then
		DebugMessageA(this,"[AI][HandleAiPulse] CurState: "..tostring(AI.StateMachine.CurState))
		curStateTable:AiPulse()
	end

	if( curStateTable.CurSubState ~= nil and curStateTable.SubStates ~= nil) then
		local curSubStateTable = curStateTable.SubStates[curStateTable.CurSubState]
		if (curSubStateTable ~= nil) then
			if( curSubStateTable.AiPulse ~= nil ) then
				curSubStateTable:AiPulse(curStateTable)
			end
		else
			DebugMessageA(this,"[base_ai_state_machine|HandleAiPulse] ERROR: Substate "..curStateTable.CurSubState.." has no substates!") 
		end
	elseif curStateTable.CurSubState ~= nil then
		DebugMessageA(this,"[base_ai_state_machine|HandleAiPulse] ERROR: Substate "..curStateTable.CurSubState.." has no substates!") 
	end

	--this:NpcSpeech("[AI][ChangeState] State: "..tostring(AI.StateMachine.CurState))

	SchedulePulse()
end

RegisterEventHandler(EventType.Timer, "aiPulse", HandleAiPulse)
-- State machine is not persistent so ignore any scheduled pulses
this:RemoveTimer("aiPulse")
