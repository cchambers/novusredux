MobileEffectLibrary.ApplyPoison = 
{
	OnEnterState = function(self,root,target,args)
		-- ask for target, 
		-- on target, check EDGED, FOOD, or DRINK...
		-- apply poison at poison level
		-- consume poison
		EndMobileEffect(root)
	end,

	OnExitState = function(self,root)
		
	end,
}