function useChair(user,usedType)
	user:AddModule("sitting")
	local angle = this:GetFacing() - 90
	--DebugMessage("SETTING WORLD POS",tostring(user),tostring(this:GetLoc():Project(angle,0.5)))
	user:SetObjVar("PositionBeforeUsing",user:GetLoc())
	AddUseCase(user, "Stand", false, "IsSelf")
	user:SetWorldPosition(this:GetLoc())
	user:SetFacing(this:GetFacing())
	user:SendMessage("SitInChair")
end

RegisterEventHandler(EventType.Message, "UseObject", 
function (user,usedType)
	if(usedType ~= "Use" and usedType ~= "Sit") then return end

	--DebugMessage("Using chair")
	if (user == nil) then
		return
	end

	if not( user:IsValid() ) then
		return
	end

	if (not user:HasLineOfSightToObj(this,0)) then
		return
	end

	if( user:DistanceFrom(this) > OBJECT_INTERACTION_RANGE) then return end

	--Animation bugfix.
	if (user:GetSharedObjectProperty("CombatMode")) then return end
	--use the chair
	if (IsSitting(user)) then
		user:SendMessage("StopSitting")
		user:SetWorldPosition(user:GetObjVar("PositionBeforeUsing"))
		RemoveUseCase(user, "Stand")
	else
		local angle = this:GetFacing() - 90
		if (FindObject(SearchMulti({SearchRange(this:GetLoc():Project(angle,0.5),0.4),SearchMobile()})) ~= nil) then
			user:SystemMessage("Someone is sitting in that seat!")
			return
		end
		--DebugMessage("useChair")
		user:SystemMessage("[$1760]")
		useChair(user)
	end
end)

RegisterSingleEventHandler(EventType.ModuleAttached, "chair",
	function()
        AddUseCase(this,"Sit",true)
	end)