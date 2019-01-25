MobileEffectLibrary.Bandage = 
{

	OnEnterState = function(self,root,target,args)
		self.Target = target or self.ParentObj

		if ( HasMobileEffect(self.ParentObj, "NoBandage") ) then
			if ( self.ParentObj:IsPlayer() ) then
				self.ParentObj:NpcSpeechToUser("You cannot bandage yet.",self.ParentObj)
			end
			EndMobileEffect(root)
			return false
		end

		if not( ValidateRangeWithError(SkillData.AllSkills.HealingSkill.Options.BandageRange, self.ParentObj, self.Target, "Too far away.") ) then
			EndMobileEffect(root)
			return false
		end

		-- cache if target is player
		self.IsPlayer = IsPlayerCharacter(target)
		self.IsPet = false
		if not ( self.IsPlayer ) then
			self.IsPet = IsPet(target)
		end

		if ( not self.IsPlayer and not self.IsPet and not target:HasObjVar("CanBandage") ) then
			self.ParentObj:NpcSpeechToUser("You cannot bandage that.",self.ParentObj)
			EndMobileEffect(root)
			return false
		end

		if ( HasMobileEffect(target, "MortalStruck") ) then
			if ( self.IsPlayer ) then
				if ( self.ParentObj == target ) then
					self.ParentObj:NpcSpeechToUser("You cannot bandage right now.",self.ParentObj)
				else
					self.ParentObj:NpcSpeechToUser("They cannot be bandaged right now.",self.ParentObj)
				end
			end
			EndMobileEffect(root)
			return false
		end

		self.SupplimentalSkill = "MeleeSkill" -- default to vigor

		if ( self.IsPet ) then
			self.SupplimentalSkill = "AnimalLoreSkill"
		end

		local skillDictionary = GetSkillDictionary(self.ParentObj)
		self.Healing = GetSkillLevel(self.ParentObj, "HealingSkill", skillDictionary)
		self.Supplimental = GetSkillLevel(self.ParentObj, self.SupplimentalSkill, skillDictionary)
		self._BaseHeal = 50

		if ( IsDead(self.Target) ) then
			-- attempt to resurrect.
			if ( IsPlayerCharacter(self.Target) ) then
				-- you can't bandage a ghost back to life, only bodies.
				self.ParentObj:NpcSpeechToUser("You cannot bandage a ghost.",self.ParentObj)
				EndMobileEffect(root)
				return false
			end

			if (
				self.Healing >= SkillData.AllSkills.HealingSkill.Options.SkillRequiredToResurrect
				and
				self.Supplimental >= SkillData.AllSkills.HealingSkill.Options.SkillRequiredToResurrect
			) then
				LookAt(self.ParentObj, self.Target)

				if (self.IsPet and not ( CanAddToActivePets(target:GetObjVar("controller"), target) ) ) then
					self.ParentObj:NpcSpeechToUser("The pets ghost returns, but immediately runs away.  It cannot be controlled by it's owner at this time.",self.ParentObj)
					EndMobileEffect(root)
					return false
				end

				if ( IsPlayerCharacter(self.Target) ) then
					self.Target:SystemMessage("" .. self.ParentObj:GetName() .. " is attempting to revive you.", "info")
				end
			else
				self.ParentObj:NpcSpeechToUser("You are not skilled enough to revive this corpse.",self.ParentObj)
				EndMobileEffect(root)
				return false
			end
			return -- stop the rest of OnEnterState execution, but wait for the pulse still.
		end
		-- clear theses since we aren't resurrecting.
		self.GetPulseFrequency = nil
		self.AiPulse = nil

		self._MaxHealth = GetMaxHealth(self.Target)

		if ( GetCurHealth(self.Target) >= self._MaxHealth ) then
			if ( self.ParentObj:IsPlayer() ) then
				self.ParentObj:NpcSpeechToUser("That patient seems fine.",self.ParentObj)
			end
			EndMobileEffect(root)
			return false
		end

		self._HealMultiplier = 0.1 + ( (self.Healing) / 150 )
		self._HealAmount = 10 + self._BaseHeal + ((self.Supplimental) * 2.75)
		--DebugMessage("self._HealMultiplier" .. self._HealMultiplier)
		--DebugMessage("self._HealAmount" .. self._HealAmount)

		if ( self.ParentObj ~= self.Target ) then
			LookAt(self.ParentObj, self.Target)
			-- cut the heal in half for healing other players
			if not( self.IsPet ) then
				self._HealAmount = self._HealAmount * 0.5
			end
		end

		if ( IsPoisoned(self.Target) ) then
			if ( self.Healing >= 60 ) then
				local poisonLevel = 1
				if ( self.Healing >= 75 ) then poisonLevel = 2 end
				if ( self.Healing >= 90 ) then poisonLevel = 3 end
				if ( self.Healing >= 100 ) then	poisonLevel = 4 end
				self.Target:SendMessage("ReducePoisonEffect", poisonLevel)
				self.ParentObj:NpcSpeechToUser("You cure some of the poison!",self.ParentObj)
			else
				self.ParentObj:NpcSpeechToUser("You lack the skill to cure poison.",self.ParentObj)
				self._HealMultiplier = self._HealMultiplier / 2
				self.Target:SendMessage("HealRequest", self._HealAmount * self._HealMultiplier , self.ParentObj)
			end
		else
			self.Target:SendMessage("HealRequest", self._HealAmount * self._HealMultiplier , self.ParentObj)
		end	

		-- apply no bandage to person that did the bandaging
		StartMobileEffect(self.ParentObj, "NoBandage")

		self.Target:PlayEffect("PotionHealEffect")
		
		-- gain check
		CheckSkillChance(self.ParentObj, "HealingSkill", self.Healing)
		CheckSkillChance(self.ParentObj, self.SupplimentalSkill, self.Supplimental)
		local backpackObj = self.ParentObj:GetEquippedObject("Backpack")
		local bloodies = FindResourceInContainer(backpackObj, "bandage_bloody")
		local bAmount = 1

		local lootObjects = backpackObj:GetContainedObjects()
		for index, lootObj in pairs(lootObjects) do	    		
			if(lootObj:GetCreationTemplateId() == "bandage_bloody" ) then
				break
			end
		end

		if( not( TryAddToStack("BloodyBandage",backpackObj,bAmount))) then
			CreateObjInBackpack(self.ParentObj, "bandage_bloody")
		end
		
		EndMobileEffect(root)
	end,

	-- for resurrecting.
	GetPulseFrequency = function(self,root) 
		return TimeSpan.FromSeconds(4)
	end,

	AiPulse = function(self,root)
		if ( ValidateRangeWithError(SkillData.AllSkills.HealingSkill.Options.BandageRange, self.ParentObj, self.Target, "Too far away.") ) then
			if ( Success(0.25) and IsDead(self.Target) ) then
				-- resurrect the corpse
				self.Target:SetObjVar("sp_resurrect_effectSource", self.ParentObj)
				self.Target:AddModule("sp_resurrect_effect")
				-- skill gain check
				CheckSkill(self.ParentObj, "HealingSkill", self.Healing, SkillData.AllSkills.HealingSkill.Options.SkillRequiredToResurrect)
				CheckSkill(self.ParentObj, self.SupplimentalSkill, self.Supplimental, SkillData.AllSkills.HealingSkill.Options.SkillRequiredToResurrect)
			else
				self.ParentObj:NpcSpeechToUser("You fail to stir the corpse.",self.ParentObj)
			end
		end
		EndMobileEffect(root)
	end,
	
	ParentObj = nil,
	_HealAmount = 0,
	_MaxHealth = 0
}



MobileEffectLibrary.WashBandage = 
{

	OnEnterState = function(self,root,target,args)
		self.Target = target
		local isWater = false

		-- check if target is water, if it is convert stack to clean bandages
		-- if (IsLocInRegion(target,"Water")) then
		-- 	isWater = true
		-- end
		
		if (target:GetObjVar("State") == "Full") then
				isWater = true
			else
				self.ParentObj:SystemMessage("That is empty.")
				return false
			end

		if (isWater == true) then
			local backpackObj = self.ParentObj:GetEquippedObject("Backpack")
			local bloodies = FindResourceInContainer(backpackObj, "")
			local bAmount = 1

			local lootObjects = backpackObj:GetContainedObjects()
			for index, lootObj in pairs(lootObjects) do	    		
				if(lootObj:GetCreationTemplateId() == "bandage_bloody" ) then
					bloodies = lootObj
					bAmount = lootObj:GetObjVar("StackCount")
					break
				end
			end

			-- if( not( TryAddToStack("Bandage",backpackObj,bAmount))) then
				CreateStackInBackpack(self.ParentObj, "bandage", bAmount)
			-- end
			bloodies:Destroy() 

			if (bAmount > 50) then
				-- check if target is waterskin
				UpdateWaterContainerState(target, "Empty")
				self.ParentObj:NpcSpeech("The container has been emptied.")
			end
		else
			self.ParentObj:NpcSpeech("That doesn't seem to be water.")
			return false
		end
	
		EndMobileEffect(root)
	end
}