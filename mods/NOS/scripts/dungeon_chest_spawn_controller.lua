function GetMaxSpawnPercent()
	return this:GetObjVar("MaxSpawnPercent") or 1.0
end

function IsPaused()
	return this:GetObjVar("Paused") or false
end

function GetSpawnPulseFrequency()
	return this:GetObjVar("SpawnPulseFrequency") or TimeSpan.FromSeconds(10)
end

function GetSpawnPulseChance()
	return this:GetObjVar("SpawnPulseChance") or 1
end


function ControllerInit()
	if (initializer and initializer.SpawnPulseFrequency) then
		this:SetObjVar("SpawnPulseFrequency",initializer.SpawnPulseFrequency)
	end
	if (initializer and initializer.SpawnPulseChance) then
		this:SetObjVar("SpawnPulseChance",initializer.SpawnPulseChance)
	end
	if(initializer and initializer.SpawnTable) then
		this:SetObjVar("SpawnTable",initializer.SpawnTable)
	end
	if(initializer and initializer.MaxSpawnPercent) then
		this:SetObjVar("MaxSpawnPercent",initializer.MaxSpawnPercent)
	end
	this:ScheduleTimerDelay(GetSpawnPulseFrequency(),"SpawnPulse")
end

function IsSpawned(spawnNode)
	local isValid = spawnNode.SpawnObj and spawnNode.SpawnObj:IsValid()
	if not(isValid) then
		return false
	end

	-- if its not a mob this is all we need to check
	if not(spawnNode.SpawnObj:IsMobile()) then
		return true
	end

    local isDead = IsDead(spawnNode.SpawnObj)
    if isDead then
    	return false
    end

    if( IsPet(spawnNode.SpawnObj) ) then
        return false
    end

    return true
end

RegisterEventHandler(EventType.ModuleAttached,"dungeon_chest_spawn_controller",
	function ()
		ControllerInit()
	end)

RegisterEventHandler(EventType.LoadedFromBackup,"",
	function ()
		ControllerInit()
	end)

RegisterEventHandler(EventType.Timer,"SpawnPulse",
	function ()
		this:ScheduleTimerDelay(GetSpawnPulseFrequency(),"SpawnPulse")

		if(IsPaused()) then return end

		local pulseChance = GetSpawnPulseChance()
		if(pulseChance < 1 and not(Success(pulseChance))) then
			--DebugMessage("Pulse chance failed")
			return
		end

		spawnNodes = this:GetObjVar("SpawnNodes") or {}
		local maxSpawnPercent = GetMaxSpawnPercent()
		local fullSpawnCount = math.floor(#spawnNodes * maxSpawnPercent)
		if(fullSpawnCount > 0) then
			local spawnCount = 0
			local availableNodes = {}
			for i,spawnNode in pairs(spawnNodes) do
				if(IsSpawned(spawnNode)) then
					spawnCount = spawnCount + 1
				else
					table.insert(availableNodes,i)
				end
			end

			if(#availableNodes > 0 and spawnCount < fullSpawnCount) then
				--DebugMessage("SpawnCount "..tostring(spawnCount).." Full: "..tostring(fullSpawnCount).." Total: "..tostring(#spawnNodes))
				local spawnTable = this:GetObjVar("SpawnTable")
				if(spawnTable) then
					local totalWeight = 0
			        for i,spawnEntry in pairs(spawnTable) do
			            totalWeight = totalWeight + (spawnEntry.Weight or 1)
			        end

			        local weightRoll = math.random(1,totalWeight)
			        totalWeight = 0
			        for i,spawnEntry in pairs(spawnTable) do
			            if( weightRoll <= totalWeight + spawnEntry.Weight ) then
			                local nodeIndex = availableNodes[math.random(#availableNodes)]
							local spawnNode = spawnNodes[nodeIndex]
							if(spawnNode.Node and spawnNode.Node:IsValid()) then
								local spawnLoc = spawnNode.Node:GetLoc()
								--Change rotation of the chest, so it will face opposite side of the wall
								local spawnRotation = spawnNode.Node:GetRotation() + Loc(0,180,0)
								CreateObjExtended(spawnEntry.Template,nil,spawnLoc,spawnRotation,Loc(1,1,1),"spawnEntry_created",nodeIndex)
								return -- only spawn one item per tick
							end
			            end
			            totalWeight = totalWeight + (spawnEntry.Weight or 1)
			        end
				end
			end
		end
	end)

RegisterEventHandler(EventType.CreatedObject,"spawnEntry_created",
	function (success,objRef,nodeIndex)
		if(success) then
			local spawnNodes = this:GetObjVar("SpawnNodes") or {}
			spawnNodes[nodeIndex].SpawnObj = objRef
			this:SetObjVar("SpawnNodes",spawnNodes)
			MoveMobilesOutOfObject(objRef)
		end
	end)

RegisterEventHandler(EventType.Message,"NodeInit",
	function (nodeObj)
		local spawnNodes = this:GetObjVar("SpawnNodes") or {}
		if not(IndexOf(spawnNodes,nodeObj,function (spawnNode,item) return spawnNode.Node == item end)) then
			table.insert(spawnNodes,{Node=nodeObj})
		end
		this:SetObjVar("SpawnNodes",spawnNodes)
	end)