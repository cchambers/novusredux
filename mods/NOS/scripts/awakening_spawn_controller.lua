require 'NOS:spawn_controller'

mAwakeningController = nil
mAwakeningStage = nil

RegisterEventHandler(EventType.Message, "MobHasDied",
	function (objRef)
		--DebugMessageB("MobHasDied "..tostring(objRef).." "..tostring(objRef and objRef:GetObjVar("AwakeningStage") or "DESPAWNED").." "..tostring(mAwakeningStage))
		if(IsDead(objRef) and objRef:GetObjVar("AwakeningStage") == mAwakeningStage) then		
			mAwakeningController:SendMessage("AwakeningKill",objRef)
		end
	end)

RegisterEventHandler(EventType.CreatedObject, "created", 
    function(success,objRef,callbackData)
        --spawn the object and save it
        if success then
        	objRef:SetObjVar("AwakeningStage",mAwakeningStage)
        end
    end)

RegisterEventHandler(EventType.Message,"AwakeningStageBegin",
	function (stageIndex,controller)	
		DebugMessageB(this,"AwakeningSpawnController: AwakeningStageBegin "..tostring(stageIndex))

		mAwakeningStage = stageIndex
		mAwakeningController = controller

		-- add 60 second spawn decay to all mobs from the previous stage
		local oldSpawnInfo = this:GetObjVar("SpawnInfo")
		if(oldSpawnInfo ~= nil) then
			for i,spawnEntry in pairs(oldSpawnInfo) do 
				if(spawnEntry.SpawnData ~= nil) then 
					for i,mobEntry in pairs(spawnEntry.SpawnData) do
						if(mobEntry.ObjRef and mobEntry.ObjRef:IsValid() and not(IsDead(mobEntry.ObjRef))) then
							mobEntry.ObjRef:SetObjVar("DecayTime",60)
							if not(mobEntry.ObjRef:HasModule("spawn_decay")) then
								mobEntry.ObjRef:AddModule("spawn_decay")
							else
								mobEntry.ObjRef:SendMessage("RefreshSpawnDecay")
							end
						end
					end
				end
 			end
		end		

		local awakeningSpawnInfo = this:GetObjVar("AwakeningSpawnInfo")
		if(#awakeningSpawnInfo >= stageIndex) then
			local spawnInfo = awakeningSpawnInfo[stageIndex]
			for i,j in pairs(spawnInfo) do --for each entry in spawnInfo
                j.SpawnData = {} --create a new table of spawn data
                for n=1,j.Count do --for each entity to spawn in Count
                    j.SpawnData[n] = { } --create a new entry                    
                end
            end

			DebugMessageB(this,"AwakeningSpawnController: Updating spawn info "..tostring(stageIndex))
			this:SetObjVar("SpawnInfo",spawnInfo)
		end
	end)

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function ( ... )
		if(initializer.AwakeningSpawnInfo) then
			this:SetObjVar("AwakeningSpawnInfo",initializer.AwakeningSpawnInfo)
		end
	end)