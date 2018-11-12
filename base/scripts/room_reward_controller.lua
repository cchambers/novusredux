--simple script that creates spawns from a template then spawns a reward/boss/something when done
require 'incl_regions'

RegisterEventHandler(EventType.Timer,"CheckEnemyContent",function()
	--DebugMessage(mSet)
	if (mSet) then
		local enemies = this:GetObjVar("MobList")
		if (enemies ~= nil) then
			local allDead = true
			for i,enemy in pairs(enemies) do 
				if (enemy:IsValid()) then
					if (enemy:IsMobile() and not IsDead(enemy)) then
						allDead = false
					end
				end
			end
			--DebugMessage("AllDead = "..tostring(allDead).. " mPlayerInside = "..tostring(mPlayerInside))
			if (allDead) then
				mSet = false
				this:DelObjVar("MobList")
				local reward = this:GetObjVar("Reward") 
				CreateObj(reward,this:GetLoc(),"reward",this:GetObjVar("RewardDecayTime"))
			end
		end
	end
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"CheckEnemyContent")
end)

RegisterEventHandler(EventType.CreatedObject,"reward",function (success,objRef,decayTime)
	if (success) then
		Decay(objRef)
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(decayTime),"ResetTimer")
	end
end)

RegisterEventHandler(EventType.Timer,"ResetTimer",function ( ... )
	--reset the room
	mSet = true
	local spawns = this:GetObjVar("Spawns")
	this:DelObjVar("MobList")
	for i,j in pairs(spawns) do
		--{"template",Loc()},
		if (type(j) == "string") then j = {j} end
 		local loc = GetNearbyPassableLocFromLoc(this:GetLoc(),0,7)	
		CreateObj(j[1],j[2] or loc,"mob_spawned")
	end
end)

--first when we load the script we get the spawns
if (initializer ~= nil) then
	this:SetObjVar("Reward",initializer.Reward)
	this:SetObjVar("RewardDecayTime",initializer.RewardDecayTime)
	local spawns = initializer.Spawns
	this:SetObjVar("Spawns",spawns)
	--create the mobs, etc.
	for i,j in pairs(spawns) do
		--{"template",Loc()},
		if (type(j) == "string") then j = {j} end
 		local loc = GetNearbyPassableLocFromLoc(this:GetLoc(),0,7)	
		CreateObj(j[1],j[2] or loc,"mob_spawned")
	end
end
--add the mobs to a list of spawns
RegisterEventHandler(EventType.CreatedObject,"mob_spawned",
	function(success,objRef)
		AddToListObjVar(this, "MobList", objRef)
		objRef:SetObjVar("AI-CanWander",false)
		--PlayEffectAtLoc("TeleportFromEffect",objRef:GetLoc())
	end)

--add the mobs to a list of spawns
RegisterEventHandler(EventType.CreatedObject,"reward",
	function(success,objRef)
		PlayEffectAtLoc("TeleportFromEffect",objRef:GetLoc())
	end)

--AddView("RoomView",SearchMulti({SearchMobileInRange(30),SearchMobileInRegion(this:GetObjVar("Region"))}))
this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"CheckEnemyContent")
mSet = true