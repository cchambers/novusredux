MobileEffectLibrary.Dye = 
{

	OnEnterState = function(self,root,target,args)
		local hue = 0
		if ( args.Hue ~= nil ) then hue = args.Hue end

		if ( not target or not target:IsValid() or not target:HasObjVar("CanDye") ) then
			self.ParentObj:SystemMessage("Cannot dye that!", "info")
			EndMobileEffect(root)
			return false
		end

		if not( IsInBackpack(target, self.ParentObj) ) then
			self.ParentObj:SystemMessage("Cannot reach that.", "info")
			EndMobileEffect(root)
			return false
		end

		target:SetHue(hue)

		self.ParentObj:SystemMessage("You have dyed "..StripColorFromString(target:GetName()), "info")

		EndMobileEffect(root)
	end,

	OnExitState = function(self,root)

	end,

	_Hue = 0,

}