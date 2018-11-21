MobileEffectLibrary.Poison = 
{
	--PersistSession = true, TODO: integrate persistence for pulse effects

	Debuff = true,

	OnEnterState = function(self,root,target,args)
		-- TARGET REPRESENTS THE PERSON THAT APPLIED THE POISON
		self.Target = target
		self.PulseFrequency = args.PulseFrequency or self.PulseFrequency
		self.PulseMax = args.PulseMax or self.PulseMax
		self.MinDamage = args.MinDamage or self.MinDamage
		self.MaxDamage = args.MaxDamage or self.MaxDamage
		SetMobileMod(self.ParentObj, "HealingReceivedTimes", "Poison", -0.60)
		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "PoisonDebuff", "Poisoned", "Poison Cloud", self.MinDamage.."-"..self.MaxDamage.." damage every "..self.PulseFrequency.Seconds.." seconds." .. "\nReduced healing received.", true)
		end

		self.ParentObj:PlayEffect("PoisonSpellEffect")
		self.ParentObj:PlayObjectSound("GrimAura",false)

		if ( HasHumanAnimations(self.ParentObj) ) then
			self.ParentObj:PlayAnimation("sunder")
		else
			-- impale is the "heavy attack for mobs"
			self.ParentObj:PlayAnimation("impale")
		end

		AdvanceConflictRelation(target, self.ParentObj)

		RegisterEventHandler(EventType.Message, "CurePoison", function()
			EndMobileEffect(root)
		end)
	end,

	OnExitState = function(self,root)
		SetMobileMod(self.ParentObj, "HealingReceivedTimes", "Poison", nil)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "PoisonDebuff")
		end
		self.ParentObj:StopEffect("PoisonSpellEffect")
		UnregisterEventHandler("", EventType.Message, "CurePoison")
	end,

	GetPulseFrequency = function(self,root)
		return self.PulseFrequency
	end,

	AiPulse = function(self,root)
		self.CurrentPulse = self.CurrentPulse + 1
		if ( IsDead(self.ParentObj) or self.CurrentPulse > self.PulseMax ) then
			EndMobileEffect(root)
		else
			self.ParentObj:SendMessage("ProcessMagicDamage", self.Target, math.random(self.MinDamage, self.MaxDamage))
		end
	end,

	PulseFrequency = TimeSpan.FromSeconds(1),
	PulseMax = 1,
	CurrentPulse = 0,
	MinDamage = 1,
	MaxDamage = 2
}