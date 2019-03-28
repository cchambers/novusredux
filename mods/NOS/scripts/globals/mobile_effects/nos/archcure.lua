MobileEffectLibrary.ArchCure = 
{
	OnEnterState = function(self,root,target,args)
		local targets = FindObjects(SearchMobileInRange(self.Range))
		for i = 1, #targets do
			local who = targets[i]
			who:AddModule("sp_cure_effect")
			who:SendMessage("SpellHitEffectsp_cure_effect", self.ParentObj)
		end
		EndMobileEffect(root)
	end,

	Range = 5
}
