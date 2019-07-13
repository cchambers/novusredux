function useChair(user,usedType)
	user:AddModule("sitting")

	user:SetObjVar("PositionBeforeUsing",user:GetLoc())

	local angle = this:GetFacing() - 90
	user:SetWorldPosition(this:GetLoc():Project(angle,0.5))

	--DebugMessage("SETTING WORLD POS",tostring(user),tostring(this:GetLoc():Project(angle,0.5)))
	
	AddUseCase(user, "Stand", false, "IsSelf")

	user:SetFacing(this:GetFacing())
	user:SendMessage("SitInChair")
end

function standUp(user)
	if (IsSitting(user)) then
		user:SendMessage("StopSitting")
		user:SetWorldPosition(user:GetObjVar("PositionBeforeUsing"))
	end
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
		user:SystemMessage("You can't see that.","info")
		return
	end

	if( user:DistanceFrom(this) > OBJECT_INTERACTION_RANGE) then
		user:SystemMessage("You can't reach that.","info")
	    return
	end

	--Animation bugfix.
	if (user:GetSharedObjectProperty("CombatMode")) then 
		user:SystemMessage("You can't sit while you are in combat.","info")
		return 
	end

	--use the chair
	if (IsSitting(user)) then
		standUp(user)
	else
		local angle = this:GetFacing() - 90
		if (FindObject(SearchMulti({SearchRange(this:GetLoc():Project(angle,0.5),0.4),SearchMobile()})) ~= nil) then
			user:SystemMessage("Someone is sitting in that seat!","info")
			return
		end
		--DebugMessage("useChair")
		user:SystemMessage("[$1760]")
		useChair(user)
	end
end)

RegisterEventHandler(EventType.Message, "ForceSit", 
	function (npc)
		useChair(npc)
	end)

RegisterEventHandler(EventType.Message, "ForceStand", 
	function (npc)
		standUp(npc)
	end)


RegisterSingleEventHandler(EventType.ModuleAttached, "chair",
	function()
        AddUseCase(this,"Sit",true)
	end)