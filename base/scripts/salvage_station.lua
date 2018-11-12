
USAGE_DISTANCE = 5
mSelectSalvage = {}
mValidSalvage = {}
mTargItem = nil
mSelectSalvage = false

function ValidateUse(user)
	if( user == nil or not(user:IsValid()) ) then
		return false
	end
	local targOrig = this:TopmostContainer() or this
	local targLoc = targOrig:GetLoc()

	local tDist = targLoc:Distance(user:GetLoc())
	if(tDist > USAGE_DISTANCE) then
		user:SystemMessage("[F7CC0A] You are too far away to use that![-]")
		return false 
	end
	--TODO Add Distance Check
	return true
end

RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,useType)		
		
		if not (useType == "Salvage") then
			mSelectSalvage = false
			return
		end

		if not(ValidateUse(user) ) then
			--DebugMessage("3")
			return
		end
		
		if (not this:HasObjVar("ToolSkill")) then
			return
		end 

		if not user:HasModule("salvage_controller") then
			user:AddModule("salvage_controller")
		end
		user:SendMessage("RESTART_SALVAGE_PROCESS", user,this,this:GetObjVar("ToolSkill"))

	end)

RegisterSingleEventHandler(EventType.ModuleAttached, "salvage_station", 
	function()
		AddUseCase(this,"Salvage")		
    	SetTooltipEntry(this,"salvage_station","Can be used to salvage specific items.")
		
		mSelectSalvage = initializer.AvailableSalvage	
	end)
