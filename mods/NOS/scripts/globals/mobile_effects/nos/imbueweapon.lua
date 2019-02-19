MobileEffectLibrary.ImbueWeapon = 
{
	OnEnterState = function(self,root,target,args)
		local WeaponType = target:GetObjVar("WeaponType")

		if (WeaponType == nil) then
		 	self.ParentObj:SystemMessage("That is not a weapon.", "info")
		 	EndMobileEffect(root)
		 	return
		end

		if((target:TopmostContainer() ~= self.ParentObj or IsInBank(target))) then
			self.ParentObj:SystemMessage("That must be in your backpack to imbue.","info")
			EndMobileEffect(root)
			return
		end

		if (target:HasObjVar("Executioner")) then
			self.ParentObj:SystemMessage("That is already magical.", "info")
		 	EndMobileEffect(root)
		 	return
		end

		self.Target = target
		self.ImbueWeapon(self,root)
	end,

	ImbueWeapon = function(self,root)
		-- get skill level
		local magerySkill = GetSkillLevel(self.ParentObj, "MagerySkill")
		local armsLoreSkill = GetSkillLevel(self.ParentObj, "ArmsLoreSkill")
		local level = math.min(magerySkill, armsLoreSkill) or 1
		local executionerLevels = ServerSettings.Executioner.LevelString

		local tierGap = 100 / #executionerLevels
		for i=1, #executionerLevels do
			self.Level = i
			if (i * tierGap >= level) then 
				EndMobileEffect(root)
				return
			end
		end
		
	end,

	OnExitState = function(self,root)
		if (self.Success) then
			self.ParentObj:SystemMessage("Not bad.", "info")
			self.Target:SetObjVar("ExecutionerLevel", self.Level)
			self.Target:AddModule("imbued_weapon")
		end
	end,

	Level = 1,
	Target = nil,
	Success = true
}