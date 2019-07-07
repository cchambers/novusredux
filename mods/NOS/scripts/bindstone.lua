function ValidateUse(user)
    if ( user:HasTimer("RecentlyBoundToLocation") ) then
        user:SystemMessage("Please wait to bind again.", "info")
        return false
    end
    local loc = user:GetLoc()
	local topmostObj = this:TopmostContainer() or this
	if(topmostObj:GetLoc():Distance(loc) > 2.2 ) then    
        user:SystemMessage("Too far away.","info")  
        return false
    end

    local spawnLoc = GetPlayerSpawnPosition(user)
    if( spawnLoc ~= nil and spawnLoc:Distance(loc) < 1.2 ) then
		user:SystemMessage("You are already bound to this location.", "info")  
        return false
    end

    local success = Plot.ValidateBindLocation(user, loc)
    if ( success ~= true ) then
        user:SystemMessage(success, "info")
        return false
    end

    return true
end

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
        if(usedType ~= "Bind Soul") then return end
        if( ValidateUse(user) ) then
            user:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "RecentlyBoundToLocation")
            user:SendMessage("BindToLocation",user:GetLoc())                    
        end
    end)

RegisterSingleEventHandler(EventType.ModuleAttached, "bindstone",
	function()
		SetTooltipEntry(this,"bindstone","[$1735]")
        AddUseCase(this,"Bind Soul",true)
	end)

this:SetObjVar("UseableWhileDead",true)
