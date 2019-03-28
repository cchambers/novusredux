MobileEffectLibrary.MassCurse = 
{
	OnEnterState = function(self,root,target,args)
		local targets = FindObjects(SearchMobileInRange(self.Range))
		for i = 1, #targets do
			local who = targets[i]
			who:AddModule("sp_curse_effect")
			who:SendMessage("SpellHitEffectsp_curse_effect", self.ParentObj)
			-- who:SendMessage("StartMobileEffect", "BeingCursed", self.ParentObj)
		end
		EndMobileEffect(root)
	end,

	Range = 3
}
