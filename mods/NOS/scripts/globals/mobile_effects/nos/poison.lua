MobileEffectLibrary.Poison = 
{
	--PersistSession = true, TODO: integrate persistence for pulse effects

	Debuff = true,

	-- Can this be resisted by Willpower?
	Resistable = true,

	OnEnterState = function(self,root,target,args)
		-- TARGET REPRESENTS THE PERSON THAT APPLIED THE POISON
		self.Target = target
		self.PulseFrequency = args.PulseFrequency or self.PulseFrequency
		self.PulseMax = args.PulseMax or self.PulseMax
		self.MinDamage = args.MinDamage or self.MinDamage
		self.MaxDamage = args.MaxDamage or self.MaxDamage

		local resistance = GetSkillLevel(target, "PoisoningSkill")
		resistance = (100 - (resistance * 0.2)) * 0.01
		self.MaxDamage = self.MaxDamage * resistance

		SetMobileMod(self.ParentObj, "HealingReceivedTimes", "Poison", -0.50)
		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "PoisonDebuff", "Poisoned", "Poison Cloud", self.MinDamage.."-"..self.MaxDamage.." damage every "..self.PulseFrequency.Seconds.." seconds." .. "\nReduced healing received.", true)
		end

		self.ParentObj:PlayEffect("PoisonSpellEffect")
		self.ParentObj:PlayEffect("StatusEffectPoison")
		self.ParentObj:PlayObjectSound("event:/magic/void/magic_void_grim_aura",false)

		if ( HasHumanAnimations(self.ParentObj) ) then
			self.ParentObj:PlayAnimation("sunder")
		else
			-- impale is the "heavy attack for mobs"
			self.ParentObj:PlayAnimation("impale")
		end

		AdvanceConflictRelation(target, self.ParentObj)
	end,

	OnExitState = function(self,root)
		SetMobileMod(self.ParentObj, "HealingReceivedTimes", "Poison", nil)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "PoisonDebuff")
		end
		self.ParentObj:StopEffect("PoisonSpellEffect")
		self.ParentObj:StopEffect("StatusEffectPoison")
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

	PulseFrequency = TimeSpan.FromSeconds(6),
	PulseMax = 8,
	CurrentPulse = 0,
	MinDamage = 1,
	MaxDamage = 3
}