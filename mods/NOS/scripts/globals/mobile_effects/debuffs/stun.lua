MobileEffectLibrary.Stun = 
{

	Debuff = true,

	-- Can this be resisted by Willpower?
	Resistable = true,

	OnEnterState = function(self,root,target,args)
		args = args or {}

		if ( HasMobileEffect(self.ParentObj, "NoStun") ) then
			DoMobileImmune(self.ParentObj, "stun")
			EndMobileEffect(root)
			return false
		end

		self._Applied = true
		self._isPlayer = IsPlayerCharacter(self.ParentObj)

		-- always set this (other effects pass PlayerDuration as Duration)
		self.Duration = args.Duration or self.Duration
		if ( self._isPlayer ) then
			self.Duration = args.PlayerDuration or self.Duration
		end

		SpellCastInterrupt(self.ParentObj)

		SetMobileMod(self.ParentObj, "Disable", "Stun", true)

		if ( target ) then
			-- Target is the mobile that stuned us, since this effect runs on the mobile that's stunned (called target for naming convention)
			AdvanceConflictRelation(target, self.ParentObj)
		end

		self.ParentObj:NpcSpeech("[FF0000]*stunned*[-]", "combat")
		if ( self._isPlayer ) then
			AddBuffIcon(self.ParentObj, "DebuffStunned", "Stunned", "Force Push 02", "Cannot move or cast.", true)
		end
		self.ParentObj:PlayEffect("StunnedEffectObject")
	end,

	OnExitState = function(self,root)
		if not ( self._Applied ) then return end

		SetMobileMod(self.ParentObj, "Disable", "Stun", nil)

		if ( self._isPlayer ) then
			RemoveBuffIcon(self.ParentObj, "DebuffStunned")
		end

		StartMobileEffect(self.ParentObj, "NoStun")
		self.ParentObj:StopEffect("StunnedEffectObject")
	end,

	--OnStack = OnStackRefreshDuration,

	GetPulseFrequency = function(self,root) 
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(0.5),

	_isPlayer = false,
	_Applied = false,
}