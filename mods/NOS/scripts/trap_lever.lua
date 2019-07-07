RegisterEventHandler(EventType.Message,"UseObject",
function (user,usedType)
    if (usedType ~= "Use" and usedType ~= "Pull") then return end
    if (this:HasTimer("ResetTimer")) then return end
    local traps = FindObjects(SearchObjVar("TrapKey",this:GetObjVar("TrapKey")))
    for i,trap in pairs(traps) do
    	trap:SendMessage("Activate")
    end
    --DebugMessage(1)
    --make the lever appear pulled
	this:SetSharedObjectProperty("IsActivated",true)
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(this:GetObjVar("ResetTime")),"ResetTimer")
end)

RegisterEventHandler(EventType.Timer,"ResetTimer",function ( ... )
	--set the lever back to normal
	this:SetSharedObjectProperty("IsActivated",false)
end)

--Create the spawn list
if (initializer ~= nil) then
	this:SetObjVar("ResetTime",initializer.Time)
end

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
    function()
        AddUseCase(this,"Pull",true)        
    end)