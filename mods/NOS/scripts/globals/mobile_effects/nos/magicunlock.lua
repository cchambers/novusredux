MobileEffectLibrary.MagicUnlock = 
{
	OnEnterState = function(self,root,target,args)
		if (not(target:IsContainer())) then
			self.ParentObj:SystemMessage("That is not a container.", "info")
			EndMobileEffect(root)
			return
		end
		local lockLevel = 1
		local magerySkill = GetSkillLevel(self.ParentObj, "MagerySkill")
		
		if (magerySkill > 50 and magerySkill < 90) then
			lockLevel = 2
		elseif (magerySkill >= 90) then
			lockLevel = 3
		end

		if (target:HasObjVar("LockpickingDifficulty") and target:GetObjVar("LockpickingDifficulty") > 55) then
			self.ParentObj:SystemMessage("That is too high of a level for you to unlock with magic.", "info")	
			EndMobileEffect(root)
			return
		end

		if (target:HasObjVar("MagicLock") and target:GetObjVar("MagicLock") > lockLevel) then
			self.ParentObj:SystemMessage("The locking magic is stronger.", "info")	
			EndMobileEffect(root)
			return
		end

		if (target:HasObjVar("LockpickingDifficulty")) then
			local tooHigh = false
			local diff = target:GetObjVar("LockpickingDifficulty")
			if (lockLevel == 1 and diff > 15) then tooHigh = true end
			if (lockLevel == 2 and diff > 35) then tooHigh = true end
			if (lockLevel == 3 and diff > 55) then tooHigh = true end
			if (tooHigh) then
				self.ParentObj:SystemMessage("That is too high of a level for you, yet.", "info")	
				EndMobileEffect(root)
				return
			end
		end
		
		target:SetObjVar("Locked", false)
		if (target:HasObjVar("MagicLock")) then
			target:DelObjVar("MagicLock")
		end
		target:PlayObjectSound("event:/objects/doors/door/door_unlock",false)
		EndMobileEffect(root)
		return
	end
}