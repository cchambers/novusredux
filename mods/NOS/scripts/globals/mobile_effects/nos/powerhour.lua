MobileEffectLibrary.PowerHourBuff = {
	OnEnterState = function(self,root,target,args)
		AddBuffIcon(self.ParentObj, "CampfireEffect", "Power Hour", "Ignite", "You are gaining skills at an increased rate.", false)
	end,

	OnExitState = function(self,root)
	
	end,

	OnEndEffect = function(self,root,endingObj)
		EndMobileEffect(root)
	end,
}