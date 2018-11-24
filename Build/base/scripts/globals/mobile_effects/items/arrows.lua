MobileEffectLibrary.Arrows = 
{

	OnEnterState = function(self,root,target,args)
		self.ParentObj:SendMessage("PreferredArrowType", args.ArrowType or "Arrows")
		EndMobileEffect(root)
	end,

}