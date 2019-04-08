RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if(usedType ~= "Use") then return end
		if (IsInBackpack(this,user) or IsInBank(this) or this:IsInContainer()) then
			user:SystemMessage("You wouldn't want to open that there. Place it on the ground first!","info")
			return false
		end
		user:SystemMessage("Test")
		local template = this:GetObjVar("Template") or "chicken"
		local petSlots = GetTemplateObjVar(template, "PetSlots")
		if (petSlots or MaxActivePetSlots(user)) <= GetRemainingActivePetSlots(user) then
			RegisterSingleEventHandler(
				EventType.CreatedObject,
				"Summon.Creature",
				function(success, objRef)
					local myResSource = user
					if myResSource == nil or not (myResSource:IsValid()) then
						DebugMessage("[summon creature mobile effect] ERROR: Could not find assigned spell source")
						objRef:Destroy()
						return
					end
					this:Destroy()
					SetCreatureAsPet(objRef, user)
				end
			)

			CreateObj(template, this:GetLoc(), "Summon.Creature")
		else 
			user:SystemMessage("You have too many pets out already.", "info")
			return false
		end
	end)	