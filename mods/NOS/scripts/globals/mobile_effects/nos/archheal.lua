MobileEffectLibrary.ArchHeal = 
{
	OnEnterState = function(self,root,target,args)
		local targets = FindObjects(SearchMobileInRange(self.Range))
		for i = 1, #targets do
			local who = targets[i]
			if (IsPlayerCharacter(who) or IsPet(who)) then 
				if(GetCurHealth(who) < GetMaxHealth(who)) then
					who:SendMessage("StartMobileEffect", "BeingArchHealed", self.ParentObj)
				end
			end
		end
		EndMobileEffect(root)
	end,

	Range = 3
}
