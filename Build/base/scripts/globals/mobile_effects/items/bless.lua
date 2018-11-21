MobileEffectLibrary.Bless = 
{

	OnEnterState = function(self,root,target,args)

		if ( not target or not target:IsValid() or not target:HasObjVar("CanDye") ) then
			self.ParentObj:SystemMessage("Cannot bless that!", "info")
			EndMobileEffect(root)
			return false
		end

		if ( target:TopmostContainer() ~= self.ParentObj ) then
			self.ParentObj:SystemMessage("Cannot reach that.", "info")
			EndMobileEffect(root)
			return false
		end

		target:SetObjVar("Blessed", true)
		SetItemTooltip(target)

		self.ParentObj:SystemMessage("You have blessed "..StripColorFromString(target:GetName()), "info")

		EndMobileEffect(root)
	end,

}