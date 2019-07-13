MobileEffectLibrary.Mill = 
{

	OnEnterState = function(self,root,target,args)
		if ( target and target:HasObjVar("Millable") ) then
		    self.ParentObj:AddModule("milling")
		    self.ParentObj:SendMessage("MillWood", target)
		else
			self.ParentObj:SendMessage("Cannot mill that.", "info")
		end
        EndMobileEffect(root)
	end,

	GetPulseFrequency = nil,
}