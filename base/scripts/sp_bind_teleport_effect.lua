
RegisterEventHandler(EventType.Message,"CompletionEffectsp_bind_teleport_effect",
	function ()
		if(this:HasTimer("HasActivePortal")) then
			this:SystemMessage("[$2600]")
			return
		end

		-- make it so you don't instantly travel through the portal
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"TeleportDelay")

		local bindLoc = GetPlayerSpawnPosition(this)
		local curRegionAddress = GetRegionAddress()
		local bindRegionAddress = curRegionAddress

		local spawnPosEntry = this:GetObjVar("SpawnPosition")
       	if(spawnPosEntry ~= nil) then
       		bindLoc = spawnPosEntry.Loc
       		bindRegionAddress = spawnPosEntry.Region
       	end

       	if(bindRegionAddress == curRegionAddress) then
			-- validate teleport
			if not(ValidateTeleport(this,bindLoc)) then
				this:DelModule("sp_bind_teleport_effect")
				return
			end
			OpenTwoWayPortal(this:GetLoc(),bindLoc,60)				
		else
			OpenRemoteTwoWayPortal(this:GetLoc(),bindLoc,bindRegionAddress,60)
		end

		-- we can't detach right away because the portal helper needs to handle the created object events	
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"TeleportRemove")
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(60),"HasActivePortal")
	end)

RegisterEventHandler(EventType.Timer,"TeleportRemove",
	function()
		this:DelModule("sp_bind_teleport_effect")
	end)