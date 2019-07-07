
MobileEffectLibrary.MageArmor = 
{

	OnEnterState = function(self,root,target,args)
		-- prevent usage if swift justiced.
		if ( HasMobileEffect(self.ParentObj, "SwiftJustice") ) then
			if ( IsPlayerCharacter(self.ParentObj ) ) then
				self.ParentObj:SystemMessage("The Guardian Order prevents that.", "info")
			end
			EndMobileEffect(root)
			return false
		end

		self.Duration = args.Duration or self.Duration
		self.MaxReflected = args.MaxReflected or self.MaxReflected
		self.ReflectRemaining = self.MaxReflected

		--Sound effect
		self.ParentObj:PlayObjectSound("event:/character/combat_abilities/evasion")

		AddBuffIcon(self.ParentObj, "MageArmorBuff", "Mage Armor", "Arcane Shield2", "Prevents spell interruptions & reflects spell damage back at the attacker, up to "..self.MaxReflected.." damage.", true)

		-- send back 50% damage received to the attacker.
		RegisterEventHandler(EventType.Message, "DamageInflicted", function(damager, damageAmount, damageType, wasCrit, wasBlocked, isReflected)
			if ( CombatDamageType[damageType] and CombatDamageType[damageType].Magic and damager ~= self.ParentObj and not isReflected and not wasBlocked ) then
				CallFunctionDelayed(TimeSpan.FromMilliseconds(250), function()
					self.ReflectRemaining = self.ReflectRemaining - damageAmount
					local amountToReflect = damageAmount
					if ( self.ReflectRemaining < 0 ) then
						-- add the negative
						amountToReflect = amountToReflect + self.ReflectRemaining
					end
					if ( amountToReflect > 0 ) then
						damager:SendMessage("DamageInflicted", self.ParentObj, amountToReflect*0.5, damageType, wasCrit, false, true)
					end
					-- process the remaining damage we couldn't reflect
					if ( self.ReflectRemaining < 0 ) then
						self.ParentObj:SendMessage("DamageInflicted", damager, self.ReflectRemaining*(-1), damageType, wasCrit, false, true)
					end
					if ( self.ReflectRemaining < 1 ) then EndMobileEffect(root) end
				end)
			end
		end)
		
		self.ParentObj:PlayEffect("ForceShield", self.Duration.TotalSeconds)

	end,

	OnExitState = function(self,root)
		UnregisterEventHandler("", EventType.Message, "DamageInflicted")

		RemoveBuffIcon(self.ParentObj, "MageArmorBuff")

		self.ParentObj:StopEffect("ForceShield")
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	MaxReflected = 55,
	ReflectRemaining = 55,
	Duration = TimeSpan.FromSeconds(1),
}