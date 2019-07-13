MobileEffectLibrary.Food = 
{
	OnEnterState = function(self,root,target,args)

		-- target is the food object
		if ( not target or not target:IsValid() ) then
			EndMobileEffect(root)
			return false
		end

		self.isPlayer = IsPlayerCharacter(self.ParentObj)

		SetMobileMod(self.ParentObj, "Busy", "Eating", true)
		RegisterEventHandler(EventType.Message, "BreakInvisEffect", function(what)
			if ( what ~= "Pickup" ) then
				EndMobileEffect(root)
			end
		end)
		RegisterEventHandler(EventType.StartMoving, "", function() EndMobileEffect(root) end)
		self.ParentObj:StopMoving()
		if ( IsInCombat(self.ParentObj) ) then
			self.ParentObj:SendMessage("EndCombatMessage")
		end

		local foodType = target:GetObjVar("ResourceType") or "Wheat"
		local foodClass = FoodStats.BaseFoodStats[foodType].FoodClass
		self.StamRegen = FoodStats.BaseFoodStats[foodType].Replenish or FoodStats.BaseFoodClass[foodClass].Replenish or 2
		-- hack it in half so we don't have to edit static files?
		self.StamRegen = self.StamRegen * 0.5
		local hpRegen = self.StamRegen * 4
		SetMobileMod(self.ParentObj, "StaminaRegenPlus", "Food", self.StamRegen)
		SetMobileMod(self.ParentObj, "HealthRegenPlus", "Food", hpRegen)
		
		self.ParentObj:PlayAnimation("eat")
		self.PlayEffect(self,root)
		
		if ( self.isPlayer ) then
			AddBuffIcon(self.ParentObj, "Food", "Eating", "food", self.StamRegen>0 and "Stamina and Health regeneration increased." or "Consuming food.", false)
			ProgressBar.Show{
				Label="Eating",
				Duration=self.PulseFrequency.TotalSeconds * self.PulseMax,
				TargetUser=self.ParentObj
			}
		end

	end,

	PlayEffect = function(self,root)
		if ( self.StamRegen > 0 ) then
			self.ParentObj:PlayEffectWithArgs("PotionHealEffect",0.0,"Color=ffffff")
		end
	end,

	OnExitState = function(self,root)
		SetMobileMod(self.ParentObj, "Busy", "Eating", nil)
		SetMobileMod(self.ParentObj, "StaminaRegenPlus", "Food", nil)
		SetMobileMod(self.ParentObj, "HealthRegenPlus", "Food", nil)

		if ( self.isPlayer ) then
			RemoveBuffIcon(self.ParentObj, "Food")
			ProgressBar.Cancel("Eating", self.ParentObj)
		end

		UnregisterEventHandler("", EventType.Message, "BreakInvisEffect")
		UnregisterEventHandler("", EventType.StartMoving, "")
		self.ParentObj:PlayAnimation("idle")
	end,

	GetPulseFrequency = function(self,root)
		return self.PulseFrequency
	end,

	AiPulse = function(self,root)
		self.CurrentPulse = self.CurrentPulse + 1
		if ( self.CurrentPulse >= self.PulseMax ) then
			EndMobileEffect(root)
		else
			if ( self.CurrentPulse == 3 ) then
				self.ParentObj:PlayAnimation("eat")
			end
			self.PlayEffect(self,root)
		end
	end,
	
	PulseFrequency = TimeSpan.FromSeconds(2.2),
	PulseMax = 5,
	CurrentPulse = 0,
}
