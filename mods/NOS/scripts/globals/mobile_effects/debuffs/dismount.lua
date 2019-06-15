MobileEffectLibrary.Dismount = 
{

	OnEnterState = function(self,root,target,args)
		-- never allow anyone to perform a successful dismount if they themselves are mounted.
		if ( target ~= nil and not IsMounted(target) ) then
			DismountMobile(self.ParentObj)
		end
		EndMobileEffect(root)
	end,
}