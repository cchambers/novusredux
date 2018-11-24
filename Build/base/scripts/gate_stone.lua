
-- Opens a gate to a parallel universe

RegisterEventHandler(EventType.Message,"UseObject",
	function (user,useType)
		if useType ~= "Activate" then return end

		if (this:TopmostContainer() ~= user) then 
			user:SystemMessage("[$1813]","info")
			return
		end

		if not(HasParallelRegion()) then 
			user:SystemMessage("[$1814]","info")
			return
		end

		local portalLoc = user:GetLoc()

		CreateTempObj("gate_stone_portal",portalLoc,"portal_created",portalLoc,user:GetFacing())	
	end)

RegisterEventHandler(EventType.CreatedObject,"portal_created",
	function (success,objRef,portalLoc,destFacing)
		objRef:SetObjVar("DestinationMap",ServerSettings.WorldName)
		objRef:SetObjVar("Destination",portalLoc)
		objRef:SetObjVar("DestinationFacing",destFacing)
		Decay(objRef, 60)
		this:Destroy()
	end)

RegisterSingleEventHandler(EventType.ModuleAttached,"gate_stone",
	function ( ... )
		AddUseCase(this,"Activate",true)
		SetTooltipEntry(this,"gate_stone","[$1815]")
	end)

