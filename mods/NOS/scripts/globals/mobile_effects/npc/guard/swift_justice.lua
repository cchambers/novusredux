MobileEffectLibrary.SwiftJustice = 
{
	--- Optional flag for this effect to apply (if there's enough duration left) on login.
	--PersistSession = true,

	-- Options flag for this effect to not be removed on death
	--PersistDeath = true,

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration

		if ( HasMobileEffect(self.ParentObj, "Stasis") ) then
			self.ParentObj:SendMessage("EndStasisEffect")
		end

		if ( HasMobileEffect(self.ParentObj, "Vanguard") ) then
			self.ParentObj:SendMessage("EndVanguardEffect")
		end

		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "SwiftJustice", "Swift Justice", "Force Push 02", "The Justice of the Guardian Order is swift.", true)
		end
	end,

	OnExitState = function(self,root)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "SwiftJustice")
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	OnEndEffect = function(self,root)
		EndMobileEffect(root)
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromMinutes(1),
}