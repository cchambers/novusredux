RegisterEventHandler(EventType.Message,"Activate",
function ( ... )
	if (this:HasObjVar("Timer")) then
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(this:GetObjVar("Timer")),"SpawnBoss") 
	else
		this:FireTimer("SpawnBoss")
	end
end)

RegisterEventHandler(EventType.Timer,"SpawnBoss",function()
		if (not this:HasObjVar("Boss") or this:GetObjVar("Boss"):IsValid() == false) then
			CreateObj(this:GetObjVar("BossTemplate"),this:GetLoc(),"boss_created")
			if (this:HasObjVar("Effect")) then
				PlayEffectAtLoc(this:GetObjVar("Effect"),this:GetLoc())
			end
		end
	end)

RegisterEventHandler(EventType.CreatedObject,"boss_created",
function (success,objRef)
	if (success) then
		this:SetObjVar("Boss",objRef)
		objRef:SendMessage(this:GetObjVar("BossSpawnMessage"))
	end
end)