MobileEffectLibrary.ApplyPoison = 
{
	OnEnterState = function(self,root,target,args)
		-- ask for target, 
		
		RegisterSingleEventHandler(EventType.ClientTargetGameObjResponse, "Poison.Apply",
		function (target)
			if (target) then
			-- on target, check EDGED, FOOD, or DRINK...
			-- target:SetObjVar("PoisonLevel", self.PoisonLevel)
			-- target:SetObjVar("PoisonCharges", self.PoisonCharges)
			-- consume poison
			end
		end)
	self.ParentObj:SystemMessage("What do you wish to poison?", "info")
	self.ParentObj:RequestClientTargetGameObj(self.ParentObj, "Poison.Apply")
		EndMobileEffect(root)
	end,

	OnExitState = function(self,root)

	end,
}