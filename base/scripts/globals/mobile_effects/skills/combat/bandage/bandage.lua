MobileEffectLibrary.Bandage = 
{

	OnEnterState = function(self,root,target,args)
		self.Target = target or self.ParentObj

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
			self.ParentObj:SystemMessage("Cannot bandage that.", "info")
			EndMobileEffect(root)
			return false
		end

		if ( HasMobileEffect(target, "MortalStruck") ) then
			if ( self.IsPlayer ) then
				if ( self.ParentObj == target ) then
					self.ParentObj:SystemMessage("Cannot bandaged right now.", "info")
				else
					self.ParentObj:SystemMessage("They cannot be bandaged right now.", "info")
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

		if ( IsDead(self.Target) ) then
			-- attempt to resurrect.
			if ( IsPlayerCharacter(self.Target) ) then
				-- you can't bandage a ghost back to life, only bodies.
				self.ParentObj:SystemMessage("Cannot bandage a ghost.", "info")
				EndMobileEffect(root)
				return false
			end
			if (
				self.Healing >= SkillData.AllSkills.HealingSkill.Options.SkillRequiredToResurrect
				and
				self.Supplimental >= SkillData.AllSkills.HealingSkill.Options.SkillRequiredToResurrect
			) then
				LookAt(self.ParentObj, self.Target)
				self.ParentObj:SystemMessage("Attempting to revive your target.", "info")
				if ( IsPlayerCharacter(self.Target) ) then
					self.Target:SystemMessage("" .. self.ParentObj:GetName() .. " is attempting to revive you.", "info")
				end
			else
				self.ParentObj:SystemMessage("Not skilled enough to revive this corpse.", "info")
				EndMobileEffect(root)
				return false
			end
			return -- stop the rest of OnEnterState execution, but wait for the pulse still.
		end
		-- clear theses since we aren't resurrecting.
		self.GetPulseFrequency = nil
		self.AiPulse = nil

		if ( HasMobileEffect(self.Target, "NoBandage") ) then
			if ( self.ParentObj:IsPlayer() ) then
				if ( self.ParentObj == self.Target ) then
					self.ParentObj:SystemMessage("Cannot bandage again yet.", "info")
				else
					self.ParentObj:SystemMessage("Target cannot be bandaged again yet.", "info")
				end
			end
			EndMobileEffect(root)
			return false
		end

		self._MaxHealth = GetMaxHealth(self.Target)

		if ( GetCurHealth(self.Target) >= self._MaxHealth ) then
			if ( self.ParentObj:IsPlayer() ) then
				self.ParentObj:SystemMessage("Patient seems just fine.", "info")
			end
			EndMobileEffect(root)
			return false
		end

		if ( self.ParentObj ~= self.Target ) then
			LookAt(self.ParentObj, self.Target)
		end

		self._HealAmount = 0.5 + ( (self.Healing+self.Supplimental) / (ServerSettings.Skills.PlayerSkillCap.Single*1.2) )

		self.Target:SendMessage("HealRequest", ( self._MaxHealth / 3.5 ) * self._HealAmount, self.ParentObj)
		self.Target:SendMessage("StartMobileEffect", "NoBandage", self.ParentObj)

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
				self.ParentObj:SystemMessage("Fail to stir the corpse.", "info")
			end
		end
		EndMobileEffect(root)
	end,
	
	ParentObj = nil,
	_HealAmount = 0,
	_MaxHealth = 0
}