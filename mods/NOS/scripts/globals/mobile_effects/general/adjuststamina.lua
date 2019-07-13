MobileEffectLibrary.AdjustStamina = 
{

	OnEnterState = function(self,root,target,args)
		self.Amount = args.Amount or self.Amount
        AdjustCurStamina(self.ParentObj, self.Amount)
        EndMobileEffect(root)
	end,

	GetPulseFrequency = nil,

	Amount = 10
}