function ValidateUse(user)
	if( user == nil or not(user:IsValid()) ) then
		return false
	end

	if( this:TopmostContainer() ~= user ) then
		user:SystemMessage("[$1932]")
		return false
	end

	if not(this:HasObjVar("MapName")) then 
		user:SystemMessage("[F7CC0A] Invalid Map")
		return false
	end

	return true
end

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
    	if(usedType ~= "Memorize") then return end
    	
    	if(user == nil or not(user:IsValid())) then
			return
		end

		if not(ValidateUse(user)) then
			return
		end

		mapName = this:GetObjVar("MapName")
		if(mapName ~= nil) then
			availableMaps = user:GetObjVar("AvailableMaps") or {}
			if(availableMaps[mapName] ~= nil) then
				user:SystemMessage("You already have this map.")	
			else
				user:PlayObjectSound("ScrollUse")
				user:SystemMessage("You have obtained the map of "..StripColorFromString(this:GetName())..".","event")
				availableMaps[mapName] = true
				user:SetObjVar("AvailableMaps",availableMaps)
				this:Destroy()
			end
		end
    end)

RegisterSingleEventHandler(EventType.ModuleAttached,"memorize_map",
	function ()
		SetTooltipEntry(this,"map","[$1933]")
		AddUseCase(this,"Memorize",true,"HasObject")
	end)