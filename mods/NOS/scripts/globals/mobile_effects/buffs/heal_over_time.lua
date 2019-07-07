MobileEffectLibrary.HealOverTime = 
{

	OnEnterState = function(self,root,target,args)
		-- this argument is not optional!
		self.PlayEffect = args.PlayEffect
		
		self.RegenMultiplier = args.RegenMultiplier or self.RegenMultiplier
		self.DamageInterrupts = args.DamageInterrupts or self.DamageInterrupts		
		self.Duration = args.Duration or self.Duration

		if(self:ShouldEnd()) then
			EndMobileEffect(root)
			return
		end

		if(self.PlayEffect) then
			self.ParentObj:PlayEffect("PotionHealEffect")
		end

		if(self.DamageInterrupts) then
			RegisterEventHandler(EventType.Message,"DamageInflicted",
				function (damager,damageAmt)
					if(damageAmt > 0) then
						EndMobileEffect(root)
					end
				end)
		end
		
		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "HealOverTime", "Heal Over Time", "restore", "Increased regeneration rate.", false)
		end
		SetMobileMod(self.ParentObj, "HealthRegenTimes", "HealOverTime", self.RegenMultiplier)
	end,

	OnExitState = function(self,root)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "HealOverTime")
		end
		SetMobileMod(self.ParentObj, "HealthRegenTimes", "HealOverTime", nil)

		UnregisterEventHandler("",EventType.Message,"DamageInflicted")
	end,

	GetPulseFrequency = function(self,root)
		return TimeSpan.FromSeconds(1)
	end,

	AiPulse = function(self,root)
		if(self.TickCount == self.Duration.TotalSeconds or self:ShouldEnd()) then						
			EndMobileEffect(root)
			return
		elseif(self.PlayEffect) then
			self.ParentObj:PlayEffect("PotionHealEffect")			
		end
		self.TickCount = self.TickCount + 1
	end,

	ShouldEnd = function(self)
		return GetCurHealth(self.ParentObj) >= GetMaxHealth(self.ParentObj)
	end,	

	TickCount = 0,
	Duration = TimeSpan.FromSeconds(5),
	RegenMultiplier = 2.0,
	DamageInterrupts = true,
	PlayEffect = true,
}