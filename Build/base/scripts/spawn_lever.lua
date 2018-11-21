RegisterEventHandler(EventType.Message,"UseObject",
function (user,usedType)
    if (usedType ~= "Use") then return end
    if (this:HasTimer("ResetTimer")) then return end
    --make the lever appear pulled
	this:SetSharedObjectProperty("IsActivated",true)
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(this:GetObjVar("ResetTime")),"ResetTimer")
	local spawnList = this:GetObjVar("SpawnList")
	for i,j in pairs(spawnList) do
			--j[1] is the template name
			--j[2] is the location
			--j[3] is the time that they are spawned
			CreateObj(j[1], j[2], "objSpawned", j[3])
	end
end)

RegisterEventHandler(EventType.Timer,"ResetTimer",function ( ... )
	--set the lever back to normal
	this:SetSharedObjectProperty("IsActivated",false)
end)

--if there's a spawned object, and it has a time, schedule a time to decay it
RegisterEventHandler(EventType.CreatedObject,"objSpawned",
function(success,objRef,time)
	if (success) then
		if (time ~= nil) then
			Decay(objRef, time)
		end
	end
end)

--Create the spawn list
if (initializer ~= nil) then
	this:SetObjVar("SpawnList",initializer.Spawns)
	this:SetObjVar("ResetTime",initializer.Time)
end

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
    function ()
    	AddUseCase(this,"Use",true,"HasObject")
	end)