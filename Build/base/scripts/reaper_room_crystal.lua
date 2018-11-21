require 'destroyable_object'


OverrideEventHandler("destroyable_object",EventType.Message, "DamageInflicted", 
	function (damager,damageAmt)    
		if (this:HasObjVar("ControllerTemplate")) then
			local controller = FindObject(SearchTemplate(this:GetObjVar("ControllerTemplate"),50))
			if (controller == nil) then 
				damager:SystemMessage("You can't damage this now.")
				return 
			end
		end
		local curHealth = this:GetObjVar("CurrentHealth") 
		curHealth = math.max(0,curHealth - damageAmt )
		SetDamageTooltip(curHealth)
		mActive = true
		if (this:HasObjVar("Important") and this:HasObjVar("MobileTeamType")) then
			local nearbyMobs = FindObjects(SearchMulti({SearchRange(this:GetLoc(),NEARBY_MOB_RANGE),SearchObjVar("MobileTeamType",this:GetObjVar("MobileTeamType"))}))
			for i,j in pairs(nearbyMobs) do
				j:SendMessage("AddThreat",damager,10)
			end
		end
		if (curHealth <= 0) then
			--DFB TODO: REMOVE THIS
			--todo Set the visual state here
			--DebugMessage("Destroyed")
			mActive = false
 			--this:SetVisualState("Destroyed")
			mDead = true
			this:SetObjVar("Destroyed",true)
			this:SetSharedObjectProperty("IsDestroyed",true)

			--this:ScheduleTimerDelay(TimeSpan.FromSeconds(this:GetObjVar("RespawnTime")),"RespawnTimer")
		end
		this:SetObjVar("CurrentHealth",curHealth)
	end)

--send respawn timer only when all crystals are destroyed.
this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"CheckRespawn")
RegisterEventHandler(EventType.Timer,"CheckRespawn",function()
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"CheckRespawn")
		if (not this:HasTimer("RespawnTimer")) then
			local crystals = FindObjects(SearchTemplate("reaper_room_crystal",50),GameObj(0)) 
			--DebugMessage(DumpTable(crystals))
			for i,j in pairs(crystals) do
				if (j:GetObjVar("CurrentHealth") > 0) then
					return
				end
			end
			--DebugMessage("Respawning timer")
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(this:GetObjVar("RespawnTime")),"RespawnTimer")
		end
	end)