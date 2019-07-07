mAwakeningController = nil
mAwakeningStage = nil

RegisterEventHandler(EventType.Message,"AwakeningStageBegin",
	function (stageIndex,controller)
		DebugMessageB(this,"AwakeningMobSpawner: AwakeningStageBegin "..tostring(stageIndex))
		mAwakeningController = controller
		mAwakeningStage = stageIndex

		local templateObjVarName = "Stage"..stageIndex.."Template"
		local templateId = this:GetObjVar(templateObjVarName)

		local spawnedMob = this:GetObjVar("spawnRef")
		local spawnedMobTemplate = nil
		if (spawnedMob) then
			spawnedMobTemplate = spawnedMob:GetCreationTemplateId()
		end

		if(templateId and (not spawnedMob or templateId ~= spawnedMobTemplate)) then
			CreateObj(templateId, this:GetLoc(), "mobSpawned")
		end
	end)

RegisterEventHandler(EventType.CreatedObject, "mobSpawned", 
	function(success, objref, index)
		if( success) then
			this:SetObjVar("spawnRef",objref)
            objref:SetObjVar("Spawner",this)
            --DebugMessage("Set facing to " .. tostring(this:GetFacing()))
	        objref:SetFacing(this:GetFacing())
	        objref:SetObjVar("AwakeningStage",mAwakeningStage)
		end
	end)

RegisterEventHandler(EventType.Message, "MobHasDied",	
	function (objRef)
		--DebugMessageB("MobHasDied "..tostring(objRef).." "..tostring(objRef and objRef:GetObjVar("AwakeningStage") or "DESPAWNED").." "..tostring(mAwakeningStage))
		if(IsDead(objRef) and objRef:GetObjVar("AwakeningStage") == mAwakeningStage) then		
			if (objRef == this:GetObjVar("spawnRef")) then
				this:DelObjVar("spawnRef")
			end
			mAwakeningController:SendMessage("AwakeningKill",objRef)
		end
	end)