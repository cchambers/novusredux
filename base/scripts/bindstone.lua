function ValidateUse(user)
	local topmostObj = this:TopmostContainer() or this
	if(topmostObj:GetLoc():Distance(user:GetLoc()) > OBJECT_INTERACTION_RANGE ) then    
        user:SystemMessage("You cannot reach that.")  
        return false
    end

    local spawnLoc = GetPlayerSpawnPosition(user)
    if( spawnLoc ~= nil and spawnLoc:Distance(this:GetLoc()) < 5) then
		user:SystemMessage("You are already bound to this location.")  
        return false
    end    	

    return true
end

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
        if(usedType ~= "Bind Soul") then return end
        if( ValidateUse(user) ) then
            user:SendMessage("BindToLocation",user:GetLoc())                    
        end
    end)

RegisterSingleEventHandler(EventType.ModuleAttached, "bindstone",
	function()
		SetTooltipEntry(this,"bindstone","[$1735]")
        AddUseCase(this,"Bind Soul",true)
	end)

this:SetObjVar("UseableWhileDead",true)
