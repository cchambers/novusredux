require 'NOS:incl_regions'

REWARD_RESPAWN_TIME = 20

function PlayersInRoom()
	local mobs = GetViewObjects("RoomView") or {}
	for i,j in pairs(mobs) do
		if (j:IsPlayer() and not IsDead(j)) then
			return true
		end
	end
	return false
end

--if a player walks into the room start the event
RegisterEventHandler(EventType.EnterView,"RoomView",
	function(mob)
		--DebugMessage("EnteringView")
		if (mob:IsPlayer()) then
			--DebugMessage("RoomView")
			if (not this:HasTimer("ResetEvent")) then
				this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"StartEvent")
				this:ScheduleTimerDelay(TimeSpan.FromMinutes(5),"ResetEvent")
			end
		end
	end)

RegisterEventHandler(EventType.Timer,"StartEvent", function()
		--DebugMessage("StartEvent")
		--lock the doors
		if (not PlayersInRoom()) then 
			this:FireTimer("ResetEvent") 
			return 
		end
		--DebugMessage(this:GetObjVar("RoomRegion").."Is the region")
		local doors = FindObjects(SearchMulti({SearchModule("door"),SearchRegion(this:GetObjVar("RoomRegion"))}))
		for i,door in pairs(doors) do 
			door:SendMessage("CloseDoor")
			door:SendMessage("Lock")
			--DebugMessage("Locking door with ID"..tostring(door.Id))
		end
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(4.5),"SpawnMobs")
	end)

RegisterEventHandler(EventType.Timer,"SpawnMobs",function ( ... )
	if (not PlayersInRoom()) then 
		this:FireTimer("ResetEvent") 
		return 
	end

	local roomRegion = this:GetObjVar("RoomRegion")

	--DebugMessage("Spawning Mobs")
 	local mobSpawnList = this:GetObjVar("MobSpawnList")
 	for i,j in pairs(mobSpawnList) do
 		--DebugMessage("length is "..j[2])
 		for n=1,(j[2] or 1),1 do
 			--DebugMessage(n)
 			--local pos = GetNearbyPassableLocFromLoc(this:GetLoc(),2,4)
 			local pos = GetRandomPassableLocation(roomRegion)	
 			if (j[2] == 1 or j[2] == nil) then
 				pos = this:GetLoc()
 			end
 			if (#mobSpawnList > 5) then
 				pos = GetRandomPassableLocation(roomRegion)	
 			end
 			CreateObj(j[1], pos, "mob_spawned")
 		end
 	end
 	this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"CheckEventComplete")
end)

RegisterEventHandler(EventType.Timer,"CheckEventComplete",function ()
	if (not PlayersInRoom()) then 
		this:FireTimer("ResetEvent") 
		return 
	end
	local finished = true
	local mobList = this:GetObjVar("MobList") or {}
	--DebugMessage(DumpTable(mobList))
	for i,mob in pairs(mobList) do
		--DebugMessage(mob:IsValid())
		--DebugMessage(IsDead(mob))
		if (mob:IsValid() == true and IsDead(mob) == false) then
			finished = false
		end
	end
	if (finished) then
		local doors = FindObjects(SearchMulti({SearchModule("door"),SearchRegion(this:GetObjVar("RoomRegion"))}))
		for i,door in pairs(doors) do 
			door:SendMessage("OpenDoor")
			door:SendMessage("Unlock")
		end
		if (this:HasObjVar("Reward") and not this:HasTimer("RewardTimer")) then
			CreateObj(this:GetObjVar("Reward"),this:GetLoc(),"created_chest")
			this:ScheduleTimerDelay(TimeSpan.FromMinutes(REWARD_RESPAWN_TIME),"RewardTimer")
			--DebugMessage("Creating chest")
		end
		return
	else
	 	this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"CheckEventComplete")
	end
end)

RegisterEventHandler(EventType.Timer,"ResetEvent",function ( ... )
		--respring the trap
		this:RemoveTimer("CheckEventComplete")
		local doors = FindObjects(SearchMulti({SearchModule("door"),SearchRegion(this:GetObjVar("RoomRegion"))}))
		for i,door in pairs(doors) do 
			door:SendMessage("OpenDoor")
			door:SendMessage("Unlock")
		end
		--Destroy the mobs
 		local mobList = this:GetObjVar("MobList")
 		if (mobList ~= nil) then
 			for i,mob in pairs(mobList) do
 				if (mob:IsValid()) then
					PlayEffectAtLoc("TeleportFromEffect",mob:GetLoc())
 					mob:Destroy()
 				end
 			end
 		end
 		--clean up a hopefully empty chest
 		local reward = this:GetObjVar("RewardObj")
 		if (reward ~= nil and reward:IsValid()) then
 			reward:Destroy()
			PlayEffectAtLoc("TeleportFromEffect",reward:GetLoc())
 			--DebugMessage("destroying chest")
 		end
 		--delete unused obj var
 		this:DelObjVar("MobList")
end)

RegisterEventHandler(EventType.CreatedObject,"mob_spawned",
	function(succes,objRef)
		AddToListObjVar(this, "MobList", objRef)
		PlayEffectAtLoc("TeleportFromEffect",objRef:GetLoc())
	end)
RegisterEventHandler(EventType.CreatedObject,"created_chest",
	function(succes,objRef)
		this:SetObjVar("RewardObj",objRef)
		--DebugMessage("Setting chest")
		PlayEffectAtLoc("TeleportFromEffect",objRef:GetLoc())
	end)

if (initializer ~= nil) then
	this:SetObjVar("MobSpawnList",initializer.Spawns)
	if (initializer.Reward ~= nil) then
		this:SetObjVar("Reward",initializer.Reward)
	end
	if (initializer.StartInitially) then
		this:FireTimer("StartEvent")
	end
	--DebugMessage(DumpTable(initializer))
	local searcherType = initializer.RoomType 
	--if (searcherType == "Circle") then
	--	AddView("RoomView",SearchMobileInRange(initializer.RoomSize))
	--elseif (searcherType == "Box")
	--	AddView("RoomView")
	--if (searcherType == "Region") then
	--	DebugMessage(2)
		this:SetObjVar("RoomRegion",initializer.Region)
		AddView("RoomView",SearchMulti({SearchMobileInRange(30,true),SearchMobileInRegion(initializer.Region,true)}))
	--end
end