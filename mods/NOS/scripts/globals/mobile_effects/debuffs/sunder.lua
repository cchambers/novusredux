-- this effect is only good for a single point of damage, please see combat.lua script module
MobileEffectLibrary.Sunder = 
{
	Debuff = true,

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration
		self.ParentObj:PlayObjectSound("event:/character/combat_abilities/puncture")

		if ( HasMobileEffect(self.ParentObj, "NoSunder") ) then
			DoMobileImmune(self.ParentObj, "sunder")
			EndMobileEffect(root)
			return false
		end

		self.isPlayer = self.ParentObj:IsPlayer()
		if ( self.isPlayer ) then
			AddBuffIcon(self.ParentObj, "DebuffSunder", "Sunder", "Windshot", "Armor rating 0 for next physical attack received.", true)
		end
	end,

	OnExitState = function(self,root)
		if ( self.isPlayer ) then
			RemoveBuffIcon(self.ParentObj, "DebuffSunder")
		end
		StartMobileEffect(self.ParentObj, "NoSunder")
	end,

	GetPulseFrequency = function(self,root) 
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(10)
}