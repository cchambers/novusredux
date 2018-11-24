



MobileEffectLibrary.FillWaterContainer = 
{
	OnEnterState = function(self,root,target,args)
		if (target:GetObjVar("State") == "Full") then
			-- no need for system message as this should not have a fill use case when already full
			EndMobileEffect(root)
			return false
		end

		local nearWater = false
		if (self.ParentObj:IsInRegion("Water")) then 
			nearWater = true
		else
			local waterSource = FindObject(SearchHasObjVar("WaterSource",OBJECT_INTERACTION_RANGE))
			nearWater = (waterSource ~= nil)
		end

		if not(nearWater) then
			self.ParentObj:SystemMessage("You don't see anywhere nearby to fill it.","info")
			EndMobileEffect(root)
			return false
		end

		if(self.DamageInterrupts) then
			RegisterEventHandler(EventType.Message,"DamageInflicted",
			function (damager,damageAmt)
				if(damageAmt > 0) then
					EndMobileEffect(root)
				end
			end)
		end

		RegisterSingleEventHandler(EventType.Timer, "FillingTimer", function()
			self.ParentObj:PlayAnimation("kneel_standup")
			UnregisterEventHandler("", EventType.Message, "DamageInflicted")
			SetMobileMod(self.ParentObj, "Disable", "FillWaterMod", nil)
			self.CompleteFill(self, root, target)
		end)

		self.ParentObj:PlayAnimation("forage")	
		self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(self.FillingTime),"FillingTimer")
		SetMobileMod(self.ParentObj, "Disable", "FillWaterMod", true)
		ProgressBar.Show
		{
			Label="Filling",
			Duration=self.FillingTime,
			TargetUser = self.ParentObj,
			PresetLocation="AboveHotbar",
		}
	end,

	CompleteFill = function(self, root, target)
		self.ParentObj:SystemMessage("You fill the "..(StripColorFromString(target:GetObjVar("OriginalName")) or "container")..".","info")
		UpdateWaterContainerState(target,"Full")

		EndMobileEffect(root)
	end,

	OnExitState = function(self,root)
		self.ParentObj:PlayAnimation("idle")
		UnregisterEventHandler("", EventType.Message, "DamageInflicted")
		self.ParentObj:RemoveTimer("FillingTimer")
		ProgressBar.Cancel("Filling", self.ParentObj)
		SetMobileMod(self.ParentObj, "Disable", "FillWaterMod", nil)
	end,

	DamageInterrupts = true,
	FillingTime = 4,
}

MobileEffectLibrary.DrinkContainer = 
{
	OnEnterState = function(self,root,target,args)
		if (target:GetObjVar("State") ~= "Full") then
			-- no need for system message as this should not have a fill use case when already full
			EndMobileEffect(root)
			return false
		end

		CompleteEatFood(self.ParentObj)

		UpdateWaterContainerState(target,"Empty")

		EndMobileEffect(root)
	end,

	FoodClass = "Refreshment"
}