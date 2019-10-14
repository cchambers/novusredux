MobileEffectLibrary.MagicLock = 
{
	OnEnterState = function(self,root,target,args)
		if (not(target:IsContainer())) then
			self.ParentObj:SystemMessage("That is not a container.", "info")
			EndMobileEffect(root)
			return
		end

		if (target:IsEquipped()) then
			self.ParentObj:SystemMessage("Nice try, but I saw that one coming!", "info")
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

		target:SetObjVar("Locked", true)
		target:SetObjVar("MagicLock", lockLevel)
		target:PlayObjectSound("event:/objects/doors/door/door_lock",false)
		EndMobileEffect(root)
	end
}