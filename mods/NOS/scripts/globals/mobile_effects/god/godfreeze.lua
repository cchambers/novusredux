MobileEffectLibrary.GodFreeze = 
{
	--- Optional flag for this effect to apply (if there's enough duration left) on login.
	PersistSession = true,

	-- Options flag for this effect to not be removed on death
	PersistDeath = true,

	-- Prevents this effect from being applied to Immune targets and when people go Immune, this effect is dropped.
	Debuff = false,

	-- Can this be resisted by Willpower?
	Resistable = false,

	OnEnterState = function(self,root,target,args)
        
        SetMobileMod(self.ParentObj, "Disable", "GodFreeze", true)
        SetMobileMod(self.ParentObj, "Freeze", "GodFreeze", true)
		
		self.IsPlayer = self.ParentObj:IsPlayer()
		if ( self.IsPlayer ) then
			AddBuffIcon(self.ParentObj, "GodFrozen", "Frozen", "Force Push 02", "Cannot move. Only time can remove this.", true)
		end

		RegisterEventHandler(EventType.Message, "OnResurrect", function()
			self.ParentObj:SetMobileFrozen(true, true)
		end)
	end,

    OnExitState = function(self,root)
        
        SetMobileMod(self.ParentObj, "Disable", "GodFreeze", nil)
        SetMobileMod(self.ParentObj, "Freeze", "GodFreeze", nil)

		if ( self.IsPlayer ) then
			RemoveBuffIcon(self.ParentObj, "GodFrozen")
		end

		UnregisterEventHandler("", EventType.Message, "OnResurrect")
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	Duration = TimeSpan.FromDays(3)
}