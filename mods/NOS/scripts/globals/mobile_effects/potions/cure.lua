MobileEffectLibrary.PotionNOSCure = 
{
	OnEnterState = function(self,root,target,args)
		self.PoisonReductionLevel = args.PoisonLevelReduction or self.PoisonReductionLevel
		self.PotionLevel = self.PoisonReductionLevel

		if ( self.ParentObj:HasTimer("RecentPotion") ) then
			self.ParentObj:SystemMessage("Cannot use again yet.", "info")
			EndMobileEffect(root)
			return false
		end
		
		if not( IsPoisoned(self.ParentObj) ) then
			self.ParentObj:SystemMessage("You are not poisoned.", "info")
			EndMobileEffect(root)
			return false
		end
		self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "RecentPotion")
		self.ParentObj:PlayEffect("HealEffect")
		self.ParentObj:SendMessage("ReducePoisonEffect", args.PoisonLevelReduction)
		self.DoBottleReturn(self, root)
		EndMobileEffect(root)
	end,

	DoBottleReturn = function(self, root) 
		local backpackObj = self.ParentObj:GetEquippedObject("Backpack")
		local template = tostring("empty_bottle_"..self.PotionLevel)
		local lootObjects = backpackObj:GetContainedObjects()
		local pots = false
		for index, lootObj in pairs(lootObjects) do	    		
			if(lootObj:GetCreationTemplateId() == template ) then
				pots = true
				lootObj:SetObjVar("StackCount", (lootObj:GetObjVar("StackCount") or 1) + 1)
				CallFunctionDelayed(TimeSpan.FromSeconds(0.5), function () SetItemTooltip(lootObj) end)
				break
			end
		end

		if (not(pots)) then
			CreateObjInBackpack(self.ParentObj, template)
		end
		-- self.PotionLevel
	end,

	PoisonReductionLevel = 1
}