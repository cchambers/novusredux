

function HandleUseObject(user,usedType)
	Verbose("Mobile", "HandleUseObject", user,usedType)
	-- TODO: Check for guard protection (if you loot there it should alert the guards)
	if( usedType == "Open Pack" ) then
		if(IsDead(this)) then
			if(this:GetLoc():Distance(user:GetLoc()) > OBJECT_INTERACTION_RANGE ) then    
        		user:SystemMessage("You cannot reach that.","info")  
        		return false
    		end
	    	if not(user:HasLineOfSightToObj(this,ServerSettings.Combat.LOSEyeLevel)) then 
	    		user:SystemMessage("[FA0C0C]You cannot see that![-]","info")
	    		return false
	    	end

			if( this:HasObjVar("guardKilled") ) then
				user:SystemMessage("[$1673]")
			elseif( not(this:HasObjVar("lootable") or this:HasObjVar("HasPetPack")) ) then
				user:SystemMessage("You find there is nothing of value on that corpse.","info")
			else				
		    	local backpackObj = this:GetEquippedObject("Backpack")
			    if ( backpackObj == nil ) then
					this:SendOpenContainer(user)
				else
					if ( #backpackObj:GetContainedObjects() > 0 ) then
						backpackObj:SendOpenContainer(user)
					else
						user:SystemMessage("You find there is nothing of value on that corpse.","info")
					end
				end
			end
		elseif(this:HasObjVar("HasPetPack")) then
			if(IsController(user,this) or IsDemiGod(user)) then
				local backpackObj = this:GetEquippedObject("Backpack")
			    if( backpackObj ~= nil ) then
		    		backpackObj:SendMessage("OpenPack",user)
			    end
			else
				user:SystemMessage("You can't do that.","info")
			end
		end
	elseif( usedType == "Loot All" and IsDead(this) ) then

    	local lootContainer = this:GetEquippedObject("Backpack")
	    if( lootContainer == nil ) then
			lootContainer = this
		end
		if ( #containerObj:GetContainedObjects() > 0 ) then
			user:SendMessage("LootAll", this)
		else
			user:SystemMessage("You find nothing worth looting on this corpse.","info")
			return
		end
	elseif(usedType == "Cut Off Head" and IsDead(this)) then
		if (this:DistanceFrom(user) > 2) then
			user:SystemMessage("You need to be next to them to cut their head off.","info")
			return
		end
		if (this:GetObjVar("CanHarvestHead") == false) then 
			user:SystemMessage("[D74444]Their head has already been cut off.[-]","info")
			return
		end
		if(user:CarriedObject() ~= nil) then
			user:SystemMessage("You are already carrying something.","info")
			return
		end
		this:SetObjVar("CanHarvestHead", false)
		--DebugMessage(1)
		--DFB HACK: This functionality of pausing, playing an animation, and showing a progress bar should be a helper function
		local killerTeam = user:GetObjVar("MobileTeamType")
		local myTeam = this:GetObjVar("MobileTeamType")
		local args = {myTeam,this:GetName(),this:GetCreationTemplateId()}
		user:SendMessage("EndCombatMessage")
		user:PlayObjectSound("event:/character/skills/gathering_skills/hunting/hunting_knife")
		FaceObject(user,this)
		ProgressBar.Show(
		{
			TargetUser = user,
			Label="Slicing Head",
			Duration=TimeSpan.FromSeconds(2.5),
			PresetLocation="AboveHotbar"
		})
		CallFunctionDelayed(TimeSpan.FromSeconds(0.1),function ( ... )
			SetMobileModExpire(this, "Disable", "CuttingHeadsOff", true, TimeSpan.FromSeconds(1))
			user:PlayAnimation("carve")
		end)
		CallFunctionDelayed(TimeSpan.FromSeconds(1),function()	
			user:PlayObjectSound("event:/objects/pickups/bounty_head/bounty_head_pickup",false)
			user:PlayAnimation("idle")
			RegisterEventHandler(EventType.CreatedObject, "CreateMobileBountyHead", HandleHeadCreated)
			CreateObjInBackpack(user,"human_head","CreateMobileBountyHead",args)
		end)
	elseif(usedType == "Dismount" and user == this) then
		local mountObj = this:GetEquippedObject("Mount")
		if(mountObj ~= nil) then
			if ( DismountMobile(this, mountObj) and IsPet(mountObj) ) then
				SendPetCommandTo(mountObj, "follow", this)
			end
		end
	end
end

RegisterEventHandler(EventType.Message, "UseObject", HandleUseObject)