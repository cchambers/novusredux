MobileEffectLibrary.PotionNOSStamina = 
{
	OnEnterState = function(self,root,target,args)
		self.PotionLevel = args.PotionLevel
		self.Percentage = args.Percentage or self.Percentage

		self.Amount = GetMaxStamina(self.ParentObj) * (self.Percentage * 0.01)
		if ( self.ParentObj:HasTimer("RecentPotion") ) then
			self.ParentObj:SystemMessage("Cannot use again yet.", "info")
			EndMobileEffect(root)
			return false
		end
		
		if ( GetCurStamina(self.ParentObj) >= GetMaxStamina(self.ParentObj) ) then
			self.ParentObj:SystemMessage("You seem fine.", "info")
			EndMobileEffect(root)
			return false
		end
		self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "RecentPotion")

		self.ParentObj:PlayEffect("HeadFlareEffect")--TODO: Change effect.

		AdjustCurStamina(self.ParentObj, self.Amount)
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

	Percentage = 1,
	Amount = 1
}