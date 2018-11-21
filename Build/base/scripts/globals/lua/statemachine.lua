StateMachine = {
	-- Name mostly used for debugging purposes
	Name = "default",
	-- Object to schedule pulse timers on
	ParentObj = nil,
	-- Current state name (including dot separated path)
	CurStateName = "root",
	-- Current state path table
	CurStatePaths = nil,
	-- Current state table (cached to save on lookups)
	CurStateTables = nil,
	-- Minimum pulse delay (prevents states from pulsing too fast)
	MinPulseDelay = TimeSpan.FromMilliseconds(250),
	-- Initial state when state machine initializes
	InitialState = nil,

	-- this is automatically generated on init and is used to uniquely identify the pulse events
	PulseId = nil,
}

-- Internal state machine helper functions

function _Traverse(name,stateTable,func)
	if(func(name,stateTable)) then
		if(self.SubStates ~= nil) then
			for name,subStateTable in self.SubStates do 
				_Traverse(name,subStateTable,func)
			end
		end
	end
end

function _BuildTablePath(rootTable,stateTablePath)
	-- travel down the path and collect the state tables
	local stateTables = { rootTable }
	local stateTablePaths = { "root" }
	local curPath = ""
	local curTable = rootTable
	local tablePath = StringSplit(stateTablePath,'%.')
	for i,pathElement in pairs(tablePath) do
		-- the root element is automatically added
		if(pathElement ~= "root") then
			if(curTable.SubStates ~= nil and curTable.SubStates[pathElement] ~= nil) then
				if(i==1) then
					curPath = curPath .. pathElement
				else
					curPath = curPath .. "." .. pathElement
				end

				curTable = curTable.SubStates[pathElement]
				table.insert(stateTablePaths,curPath)
				table.insert(stateTables,curTable)
			else
				return
			end
		end
	end

	return stateTablePaths, stateTables
end

function _WalkUp(rootTable,func)
	for i=#rootTable.CurStateTables,1,-1 do
		local curTable = rootTable.CurStateTables[i]
		local curTablePath = rootTable.CurStatePaths[i]

		func(curTablePath,curTable)
	end
end

function _WalkDown(rootTable,func)
	for i=1,#rootTable.CurStateTables do
		local curTable = rootTable.CurStateTables[i]
		local curTablePath = rootTable.CurStatePaths[i]

		func(curTablePath,curTable)
	end
end

function _SchedulePulse(rootTable,stateTablePath,stateTable)
	stateTable = stateTable or rootTable:GetStateTable(stateTablePath)
	if(stateTable == nil) then
		LuaDebugCallStack("[FSM][SchedulePulse] ERROR: Invalid state "..stateTablePath)
		return
	end

	local nextPulse = stateTable:GetPulseFrequency()		
	if( nextPulse ~= nil ) then
		-- negative number means nextPulse is smaller than MinPulse
		if(nextPulse:CompareTo(rootTable.MinPulseDelay) < 0) then
			nextPulse = rootTable.MinPulseDelay
		end

		-- add a tiny bit of randomness to all delays to avoid stacking
		nextPulse = nextPulse + TimeSpan.FromMilliseconds(math.random(1,50))
		-- we don't pass the table because it would be unnecesary serialization. we just pass the table path
		rootTable.ParentObj:ScheduleTimerDelay(nextPulse, rootTable.PulseId.."-"..stateTablePath)
		RegisterEventHandler(EventType.Timer,rootTable.PulseId.."-"..stateTablePath,
			function()
				rootTable.ParentObj:ScheduleTimerDelay(nextPulse, rootTable.PulseId.."-"..stateTablePath)
				stateTable:AiPulse(rootTable)
			end)

		return true
	end
		
	return false
end

function _ExitState(root)
	-- Exits the current state (unregistering pulses)
	if(root.CurStateTables ~= nil) then
		_WalkUp(root,
			function(curTablePath,curTable)
				if(curTable.GetPulseFrequency ~= nil) then
					root.ParentObj:RemoveTimer(root.PulseId.."-"..curTablePath)
					UnregisterEventHandler("",EventType.Timer,root.PulseId.."-"..curTablePath)
				end

				if(curTable.OnExitState ~= nil) then
					curTable:OnExitState(root,newStatePath)
				end
				
				-- handle mobile effects.
				if ( curTable.EffectName ~= nil ) then
					UnregisterEventHandler("", EventType.Message, "End"..curTable.EffectName.."Effect")

					if ( curTable.OnStack ~= nil ) then
						-- handle mobile effect stack event.
						UnregisterEventHandler("", EventType.Message, curTable.EffectName.."Stack")
					end
				end
			end)
	end
end

-- State machine public functions

function StateMachine.ForEach(self,func)
	_Traverse("root",self,func)
end

--- Converts a string path to a table reference
function StateMachine.GetStateTable(self,stateName)
	local tablePath = StringSplit(stateName,'%.')
	local curTable = self
	for i,pathElement in pairs(tablePath) do
		-- ignore the root table since that is what we start with
		if(pathElement ~= "root") then
			if(curTable.SubStates ~= nil and curTable.SubStates[pathElement] ~= nil) then
				curTable = curTable.SubStates[pathElement]
			else
				curTable = nil
			end
		end
	end

	return curTable
end

function StateMachine.ChangeState(self,newStatePath,...)
	_ExitState(self)
	
	local success = true

	if(newStatePath ~= nil) then
		local tablePath, tableRef = _BuildTablePath(self,newStatePath)
		if(tablePath == nil) then
			LuaDebugCallStack("[FSM][HandleChangeState] ERROR: Invalid state "..tostring(newStatePath))
			return false
		end

		self.CurStatePaths = tablePath
		self.CurStateTables = tableRef

		self.CurStateName = newStatePath

		--if(GetAISetting(self,"Debug")) then
		--	self.ParentObj:NpcSpeech("Enter: "..newStatePath)
		--	DebugMessage("[FSM][HandleChangeState] Enter: "..newStatePath)
		--end

		local args = table.pack(...)
		_WalkDown(self,
			function(curTablePath,curTable)

				if ( curTable.OnEnterState ~= nil ) then				
					if not( curTable:OnEnterState(self,table.unpack(args)) == false ) then
						-- only set this stuff if entering the state didn't return false
						if ( curTable.GetPulseFrequency ~= nil ) then
							_SchedulePulse(self,curTablePath,curTable)					
						end
					else
						-- entering state returned a false, stop here.
						success = false
						return false
					end

				end

				-- handle mobile effects.
				if ( curTable.EffectName ~= nil ) then
					RegisterEventHandler(EventType.Message, "End"..curTable.EffectName.."Effect", function(endingObj)
						if ( curTable.OnEndEffect ~= nil ) then
							curTable:OnEndEffect(self,endingObj)
						else
							EndMobileEffect(curTable)
						end
					end)

					if ( curTable.OnStack ~= nil ) then
						-- handle mobile effect stack event.
						RegisterEventHandler(EventType.Message, curTable.EffectName.."Stack", function(target,arg)
							curTable:OnStack(self,target,arg)
						end)
					end
				end
			end)
	end
	return success
end

function StateMachine.Register(rootTable,parentObj,...)
	setmetatable(rootTable,{__index=StateMachine})

	rootTable.ParentObj = parentObj
	rootTable.PulseId = uuid()

	if(rootTable.InitialState) then
		return rootTable:ChangeState(rootTable.InitialState,...)
	else
		return rootTable:ChangeState("root",...)
	end
end

function StateMachine.Unregister(rootTable)
	_ExitState(rootTable)
end