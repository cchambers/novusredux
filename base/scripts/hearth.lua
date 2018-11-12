RegisterEventHandler(EventType.EnterView, "NearbyPlayer", function(playerObj)
	if ( IsDead(playerObj) ) then return end
	playerObj:SendMessage("StartMobileEffect", "VitalityHearth", this, {})
end)

RegisterEventHandler(EventType.LeaveView, "NearbyPlayer", function(playerObj)
	playerObj:SendMessage("EndVitalityHearthEffect")
end)

AddView("NearbyPlayer", SearchPlayerInRange(ServerSettings.Vitality.Hearth.MaxRange))

function ValidateUse(user)
	if (IsDead(user)) then 
		return false
	end
	if (this:DistanceFrom(user) > OBJECT_INTERACTION_RANGE) then
		return false
	end

	return true
end

RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if(usedType ~= "Use" and usedType ~= "Bind To Location") then return end

		if not(ValidateUse(user) ) then
			return
		end

		user:SendMessage("BindToLocation",user:GetLoc())
	end)

RegisterSingleEventHandler(EventType.ModuleAttached, "hearth", function()
	AddUseCase(this,"Bind To Location")
	SetTooltipEntry(this, "hearth", "Warms your soul and allows for the restful state required to regenerate vitality.")
end)