MobileEffectLibrary.MagicUntrap = 
{
	OnEnterState = function(self,root,target,args)
		if (not(target:IsContainer())) then
			self.ParentObj:SystemMessage("That is not a container.", "info")
			EndMobileEffect(root)
			return
		end
		local trapLevel = 1
		local magerySkill = GetSkillLevel(self.ParentObj, "MagerySkill")
		
		if (magerySkill > 50 and magerySkill < 90) then
			trapLevel = 2
		elseif (magerySkill >= 90) then
			trapLevel = 3
		end

		if (target:HasObjVar("Trapped") and target:GetObjVar("Trapped") > trapLevel) then
			EndMobileEffect(root)
			return
		end

		if (target:HasObjVar("Trapped")) then
			target:DelObjVar("Trapped")
		end
		target:PlayObjectSound("event:/objects/doors/door/door_unlock",false)
		EndMobileEffect(root)
		return
	end
}