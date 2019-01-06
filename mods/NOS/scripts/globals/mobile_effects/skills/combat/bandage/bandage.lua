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

				if (self.IsPet and target:GetObjVar("PetSlots") > GetRemainingActivePetSlots(self.ParentObj) ) then
					self.ParentObj:NpcSpeechToUser("Your pets ghost returns, but immediately runs away.  You are not skilled enough to control another pet.",self.ParentObj)
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

		self.Target:SendMessage("HealRequest", self._HealAmount * self._HealMultiplier , self.ParentObj)

		if ( IsPoisoned(self.Target) ) then
			if ( self.Healing >= 60 ) then
				self.Target:SendMessage("EndPoisonEffect")
				self.ParentObj:NpcSpeechToUser("You cured your target of poison!",self.ParentObj)
				EndMobileEffect(root)
				return false
			else
				self.ParentObj:NpcSpeechToUser("You lack the skill to cure poison.",self.ParentObj)
			end
		end

		-- apply no bandage to person that did the bandaging
		StartMobileEffect(self.ParentObj, "NoBandage")

		self.Target:PlayEffect("PotionHealEffect")
		
		-- gain check
		CheckSkillChance(self.ParentObj, "HealingSkill", self.Healing)
		CheckSkillChance(self.ParentObj, self.SupplimentalSkill, self.Supplimental)

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