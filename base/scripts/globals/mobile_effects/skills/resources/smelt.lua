MobileEffectLibrary.Smelt = 
{

	OnEnterState = function(self,root,target,args)
		if ( target and target:HasObjVar("Smeltable") ) then
			self.ParentObj:AddModule("smelting")
			self.ParentObj:SendMessage("SmeltOre", target)
		else
			self.ParentObj:SendMessage("Cannot smelt that.", "info")
		end
		EndMobileEffect(root)
	end,

	GetPulseFrequency = nil,
}