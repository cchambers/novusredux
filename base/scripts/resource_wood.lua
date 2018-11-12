CAMPFIRE_WOOD_REQUIRED = 4

function ValidateUse(user)
	if( user == nil or not(user:IsValid()) ) then
		DebugMessage("ERROR: User Not Valid")
		return false
	end

	if( this:TopmostContainer() == user ) then
		return true
	end
	--TODO Add Distance Check
	return true
end

function ValidateCampfirePrep(user)
	local stackCount = GetStackCount(this)
	
	if( stackCount < CAMPFIRE_WOOD_REQUIRED ) then
		user:SystemMessage("You need at least 4 wood to prepare a campfire.")
		return false
	end

	if (not IsInBackpack(this,user)) then
		user:SystemMessage("[$2448]")
		return false
	end

	return true
end

RegisterEventHandler(EventType.Message,"UseObject",
	function(user,useType)
		if(useType == "Prepare Campfire") then
			if (this:HasModule("merchant_sale_item")) then
				this:DelModule("resource_wood")
				return
			end
			
			--DebugMessage("Received Use Request")
			if not( ValidateUse(user) ) then return end

			
			if not(ValidateCampfirePrep(user)) then return end

			user:RequestClientTargetLoc(this, "campfireLoc")
		end
	end)

RegisterEventHandler(EventType.ClientTargetLocResponse, "campfireLoc",
	function (success, targetLoc,targetObj,user)	
		if not(success) then return end		
		if not( ValidateUse(user) ) then return end
		if not(ValidateCampfirePrep(user)) then return end

		if( user:GetLoc():Distance(targetLoc) > OBJECT_INTERACTION_RANGE ) then
			user:SystemMessage("That is too far away.")
			return
		end

		if not(IsPassable(targetLoc)) then
			user:SystemMessage("That is not the best place for a campfire.")
			return
		end

		if not(user:HasLineOfSightToLoc(targetLoc)) then
			user:SystemMessage("You cannot see that location.")
			return
		end
		
		CreateObj("campfire_simple",targetLoc,"campfire",user)
	end)

RegisterEventHandler(EventType.CreatedObject,"campfire",
	function (success,objRef,user)
		if(success) then
			RequestConsumeResource(user,"Wood",4,"wood",this)
			Decay(objRef)
			objRef:SetObjVar("CanPutOut",true)
		end
	end)

if( initializer ~= nil ) then
	AddUseCase(this,"Prepare Campfire",true)
    SetTooltipEntry(this,"resource_wood_desc","Can be used to prepare a campfire.\n")	
end