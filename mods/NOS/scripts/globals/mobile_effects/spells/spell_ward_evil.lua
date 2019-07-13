MobileEffectLibrary.SpellWardEvil = 
{

	OnEnterState = function(self,root,target,args)

		if not( target ) then
			EndMobileEffect(root)
			return false
		end

		if not( IsPassable(target) ) then
			this:SystemMessage("[$2614]","info")
			EndMobileEffect(root)
			return false
		end
	
		if not( self.ParentObj:HasLineOfSightToLoc(target,ServerSettings.Combat.LOSEyeLevel) ) then
			self.ParentObj:SystemMessage("[$2615]","info")
			EndMobileEffect(root)
			return false
		end

		local current = self.ParentObj:GetObjVar("EvilWard")
		if ( current ) then
			current[1]:SendMessageGlobal("RemoveWard")
			self.ParentObj:SystemMessage("Your previous ward was removed.", "info")
		end

		Create.Temp.AtLoc("blank", target, function(item)
			if ( item ) then
				self.ParentObj:SetObjVar("EvilWard", {item,ServerSettings.RegionAddress})
				item:AddModule("ward_evil", {
					Owner = self.ParentObj,
				})
				if not( self.ParentObj:HasModule("ward_evil_player") ) then
					self.ParentObj:AddModule("ward_evil_player")
				end
			end
		end)
		EndMobileEffect(root)
	end
}