MobileEffectLibrary.Spellshield = 
{

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration
		self.MaxReflected = args.MaxReflected or self.MaxReflected
		self.ReflectRemaining = self.MaxReflected

		self.IsPlayer = self.ParentObj:IsPlayer()

		if ( self.IsPlayer ) then
			AddBuffIcon(self.ParentObj, "SpellshieldBuff", "Spell Shield", "Force Push 02", "Reflects spell damage back at the attacker, up to "..self.MaxReflected.." damage.", false)
		end
		
		self.ParentObj:PlayEffect("HoneycombShield", self.Duration.TotalSeconds)

		-- send back all spell damage to attacker
		RegisterEventHandler(EventType.Message, "DamageInflicted", function(damager, damageAmount, damageType, isCrit, wasBlocked, isReflected)
			if ( damageType == "MAGIC" ) then
				self.ReflectRemaining = self.ReflectRemaining - damageAmount
				-- if more damage was done than reflect we have remaining
				if ( self.ReflectRemaining < 0 ) then
					-- set damage to damage + the negative remainder
					damageAmount = damageAmount + self.ReflectRemaining
				end
				-- don't reflect damage that is reflected damage.
				if ( not isReflected and damageAmount > 0 and damager ~= self.ParentObj ) then
					CallFunctionDelayed(TimeSpan.FromMilliseconds(500), function()
						-- cause the reflected damage
						damager:SendMessage("ProcessMagicDamage", self.ParentObj, damageAmount, isCrit, nil, true)
					end)
				end
				-- if no more reflect remaining
				if ( self.ReflectRemaining <= 0 ) then
					-- it's over.
					EndMobileEffect(root)
					-- cause any remainder damage that couldn't be fully reflected
					self.ReflectRemaining = math.abs(self.ReflectRemaining)
					if ( self.ReflectRemaining > 0 and damager ~= self.ParentObj ) then
						CallFunctionDelayed(TimeSpan.FromMilliseconds(250), function()
							self.ParentObj:SendMessage("ProcessMagicDamage", damager, self.ReflectRemaining, isCrit, nil, true)
						end)
					end
				end
			end
		end)
	end,

	OnExitState = function(self,root)
		if ( self.IsPlayer ) then
			RemoveBuffIcon(self.ParentObj, "SpellshieldBuff")
		end
		UnregisterEventHandler("", EventType.Message, "DamageInflicted")
		self.ParentObj:StopEffect("HoneycombShield")
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	IsPlayer = false,
	Duration = TimeSpan.FromMinutes(1),
	MaxReflected = 55,
	ReflectRemaining = nil -- keep track of the damage we have reflected as to not reflect too much ( get's set on start )
}