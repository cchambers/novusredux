function UsePetStatue(user)	
	local useLoc = this:TopmostContainer()
	if useLoc ~= user then return end

	local pet = this:GetObjVar("PetTarget")
	if not(pet and pet:IsValid()) then 
		local mountTemplate = this:GetObjVar("PetTemplate")
		if(mountTemplate) then
			RegisterSingleEventHandler(EventType.CreatedObject,"PetCreated",
				function(success,objRef,user)
					SetCreatureAsPet(objRef, user, true, this)
					-- it's easier to let the pet create the statue on the next dismiss
					this:Destroy()
				end)
			CreateObj(mountTemplate,user:GetLoc(),"PetCreated",user)

			return
		else
			return
		end
	end

	if(pet:TopmostContainer() ~= user) then 
		return 
	end
	
	pet:SendMessage("UnStatuify", user)
end

RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if(usedType ~= "Summon Pet") then return end
			
		--DebugMessage("Using bed")
		if (user == nil) then
			return
		end

		if not( user:IsValid() ) then
			return
		end	
		if (user:GetSharedObjectProperty("CombatMode")) then
			user:SystemMessage("You cannot do that while in combat.","info")
			return
		end
		if(this:HasTimer("PetSummonTimeOut")) then
			user:SystemMessage("That is not ready yet..", "info")
			return
		end
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(5), "PetSummonTimeOut")
		UsePetStatue(user)
	end)

RegisterSingleEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function()
		AddUseCase(this,"Summon Pet",true)
	end)