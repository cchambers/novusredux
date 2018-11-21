function UseBed(user)
	user:AddModule("sleeping")
	AddUseCase(user, "Wake Up", false, "IsSelf")
	user:SetObjVar("PositionBeforeUsing",user:GetLoc())

	local offset = this:GetObjVar("AngleOffset") or 0
	local angle = this:GetFacing() + 180 + offset
	if (not this:HasObjVar("LowBed")) then
		user:SetWorldPosition(this:GetLoc():Project(angle,1))
	else
		user:SetWorldPosition(this:GetLoc())
	end
	user:SetFacing(angle-90)
	user:SendMessage("FallAsleep",this)
end

--DFB NOTE: Animation is bugged so don't let them use it for now.
RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)

		if(usedType ~= "Lay Down") then return end
			
		--DebugMessage("Using bed")
		if (user == nil) then
			return
		end

		if ( this:GetLoc():Distance(user:GetLoc()) > OBJECT_INTERACTION_RANGE ) then
			user:SystemMessage("Too far away.", "info")
			return
		end

		if not( user:IsValid() ) then
			return
		end	

		if (not user:HasLineOfSightToObj(this,0)) then
			return
		end

		--prevent laying down while mounted!
		if(IsMounted(user)) then
			user:SystemMessage("You cannot do that while mounted.","info")
			return
		end

		--Animation bugfix.
		if (user:GetSharedObjectProperty("CombatMode")) then
			user:SystemMessage("You cannot do that while in combat.","info")
			return
		end
		
		--use the bed
		if (IsAsleep(user)) then
			user:SendMessage("WakeUp")
			user:SetWorldPosition(user:GetObjVar("PositionBeforeUsing"))
			RemoveUseCase(user, "Wake Up")
		else
			user:SystemMessage("You are now laying down. Move to get up.", "info")
			UseBed(user)
		end
	end)

RegisterSingleEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function()
		AddUseCase(this,"Lay Down",true)
	end)