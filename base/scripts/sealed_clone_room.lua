require 'sealed_room'

REWARD_RESPAWN_TIME = 20

OverrideEventHandler("sealed_room",EventType.Timer,"CheckEventComplete",function ()
	if (not PlayersInRoom()) then 
		this:FireTimer("ResetEvent") 
		return 
	else
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
			local doors = FindObjects(SearchMulti({SearchModule("door",30),SearchHasObjVar("CloneDoor2"),SearchRegion(this:GetObjVar("RoomRegion"))}))
			for i,door in pairs(doors) do 
				door:SendMessage("OpenDoor")
				door:SendMessage("Unlock")
			end
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"ResetEvent") 
			if (this:HasObjVar("Reward") and not this:HasTimer("RewardTimer")) then
				CreateObj(this:GetObjVar("Reward"),this:GetLoc(),"created_chest")
				this:ScheduleTimerDelay(TimeSpan.FromMinutes(REWARD_RESPAWN_TIME),"RewardTimer")
				--DebugMessage("Creating chest")
			end
			return
		else
		 	this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"CheckEventComplete")
		end
	end
end)

OverrideEventHandler("sealed_room",EventType.Timer,"ResetEvent",function ( ... )
		if (PlayersInRoom()) then 
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"ResetEvent") 
			return 
		end
		--respring the trap
		this:RemoveTimer("CheckEventComplete")
		local doors = FindObjects(SearchMulti({SearchModule("door",30),SearchHasObjVar("CloneDoor2"),SearchRegion(this:GetObjVar("RoomRegion"),true)}))
		for i,door in pairs(doors) do 
			--DebugMessage("Locking door "..tostring(door.Id))
			door:SendMessage("CloseDoor")
			door:SendMessage("Lock")
		end
		local doors = FindObjects(SearchMulti({SearchModule("door",30),SearchHasObjVar("CloneDoor1"),SearchRegion(this:GetObjVar("RoomRegion"),true)}))
		for i,door in pairs(doors) do 
			--DebugMessage("Opening door "..tostring(door.Id))
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


function GetPlayers()
	local players = {}
	local mobs = GetViewObjects("RoomView") 
	for i,j in pairs(mobs) do
		if (j:IsPlayer() and not IsDead(j)) then
			table.insert(players,j)
		end
	end
	return players
end

OverrideEventHandler("sealed_room",EventType.Timer,"SpawnMobs",function ( ... )
	if (not PlayersInRoom()) then 
		this:FireTimer("ResetEvent") 
		return 
	end
	local players = GetPlayers()
	for i,j in pairs(players) do
 		CreateObj("void_shadow", this:GetLoc(), "mob_spawned")
 	end
 	this:ScheduleTimerDelay(TimeSpan.FromSeconds(1.5),"ChangeMobsToPlayers")
 	this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"CheckEventComplete")
end)


RegisterEventHandler(EventType.Timer,"ChangeMobsToPlayers",function()
		local MobList = this:GetObjVar("MobList")
		local players = GetPlayers()
		if (MobList == nil) then
			DebugMessage("ERROR: No Void Shadows spawned in Clone Room!!!")
			return
		end
		for i,j in pairs(players) do
			MobList[i]:SendMessage("CopyOtherMobile",j)
			PlayEffectAtLoc("VoidPillar",MobList[i]:GetLoc(),2)
			MobList[i]:SetName("[F04646]"..StripColorFromString(MobList[i]:GetName()).."[-]")
		end
	end)
