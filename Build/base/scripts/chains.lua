--Behaviour for capturing an npc
CHAIN_USE_DISTANCE = 5

RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if(usedType ~= "Use" and usedType ~= "Capture") then return end
		if (this:TopmostContainer() ~= user) then 
			user:SystemMessage("[$1759]")
			return
		end
		user:SystemMessage("Select the person to capture.")
		user:RequestClientTargetGameObj(this, "chainsTarget")
	end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "chainsTarget", 
	function(target,user)
		

		-- validate target
		if( target == nil or not(target:IsValid())) then
			return
		end
		
		if (target:HasObjVar("CannotBeCaptured")) then
			user:SystemMessage("This foe cannot be chained up!")
			return
		end

		if( IsDead(target) ) then 
			user:SystemMessage("He is dead!")
			return
		end	

		if( target == user ) then --DFB TODO: Change this?
			user:SystemMessage("You shouldn't chain yourself up.")
			return
		end	

		if (target:GetMobileType() == "Animal") then
			user:SystemMessage("You can't chain up animals with these chains.")
			return
		end	 

		if (not IsHuman(target)) then
			user:SystemMessage("You can only chain up living humans.")
			return
		end

		if( target:IsPlayer() ) then --DFB TODO: Change this?
			user:SystemMessage("You can't chain up players.")
			return
		end	

		if (target:DistanceFrom(user) > CHAIN_USE_DISTANCE) then
			user:SystemMessage("You're too far away!")
			return
		end	


		--check to make sure the health is low enough
		if( GetCurHealth(target)/GetMaxHealth(target) > 0.4 ) then
			user:SystemMessage("His health is too high!")
			target:SendMessage("AttackEnemy",user)
			return
		end

		--finish cooking
		user:SystemMessage("You captured your target!")
		
		PlayEffectAtLoc("ChainEffect",target:GetLoc())
		user:PlayObjectSound("event:/objects/pickups/armor/armor_plate_drop")

		target:AddModule("ai_slave")
		target:NpcSpeech("No! Let me go!")

    	user:SendMessage("EndCombatMessage")
    	target:SendMessage("EndCombatMessage")

		this:Destroy()
	end)

RegisterSingleEventHandler(EventType.ModuleAttached, "chains",
	function()
		SetTooltipEntry(this,"chains","Can be used to capture another human being.")
        AddUseCase(this,"Capture",true,"HasObject")
	end)