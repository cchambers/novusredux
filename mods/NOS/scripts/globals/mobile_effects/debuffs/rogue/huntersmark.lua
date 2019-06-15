MobileEffectLibrary.HuntersMark = 
{
	--- Optional flag for this effect to apply (if there's enough duration left) on login.
	--PersistSession = true,

	-- Options flag for this effect to not be removed on death
	--PersistDeath = true,

	-- Prevents this effect from being applied to Immune targets and when people go Immune, this effect is dropped.
	Debuff = true,

	-- Can this be resisted by Willpower?
	Resistable = true,

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration
		self.Modifier = args.Modifier or self.Modifier

		self.EffectPulse = TimeSpan.FromSeconds(1)
		RegisterEventHandler(EventType.Timer, "HuntersMarkEffect", function()
			self.ParentObj:PlayEffect("SunderEffect")
			self.ParentObj:ScheduleTimerDelay(self.EffectPulse, "HuntersMarkEffect")
		end)
		self.ParentObj:FireTimer("HuntersMarkEffect")
		self.ParentObj:PlayObjectSound("event:/character/combat_abilities/perforate")

		SetMobileMod(self.ParentObj, "BowDamageTakenTimes", "HuntersMark", self.Modifier)

		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "HuntersMark", "Hunters Mark", "Burning Arrow", string.format("Cannot hide or cloak. Bow damage received increased by %s%%", self.Modifier*100), true)
		end

	end,

	OnExitState = function(self,root)
		SetMobileMod(self.ParentObj, "BowDamageTakenTimes", "HuntersMark", nil)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "HuntersMark")
		end
		UnregisterEventHandler("", EventType.Timer, "HuntersMarkEffect")
		self.ParentObj:RemoveTimer("HuntersMarkEffect")
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	OnStack = OnStackRefreshDuration,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(30),
	Modifier = 0,
}