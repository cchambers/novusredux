MobileEffectLibrary.ApplyPoison = 
{
	OnEnterState = function(self,root,target,args)
		-- ask for target, 
		
		RegisterSingleEventHandler(EventType.ClientTargetLocResponse, "Poison.Apply",
		function (success, targetLoc, targetObj, user)
			if (success) then
				if (targetObj) then
				-- on target, check EDGED, FOOD, or DRINK...
				-- apply poison at poison level
				-- consume poison
				end
			end
			EndMobileEffect(root)
		end)
	self.ParentObj:SystemMessage("What do you wish to poison?", "info")
	self.ParentObj:RequestClientTargetLoc(self.ParentObj, "Poison.Apply")
		EndMobileEffect(root)
	end,

	OnExitState = function(self,root)

	end,
}