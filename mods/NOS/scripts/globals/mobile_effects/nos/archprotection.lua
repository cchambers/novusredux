MobileEffectLibrary.ArchProtection = 
{
	OnEnterState = function(self,root,target,args)
		local targets = FindObjects(SearchMobileInRange(self.Range))
		for i = 1, #targets do
			local who = targets[i]
			who:AddModule("sp_protection_effect")
			who:SendMessage("SpellHitEffectsp_protection_effect", self.ParentObj)
		end
		EndMobileEffect(root)
	end,

	Range = 5
}
