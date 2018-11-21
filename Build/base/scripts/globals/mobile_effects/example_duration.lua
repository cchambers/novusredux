MobileEffectLibrary.Example = 
{
	--- Optional flag for this effect to apply (if there's enough duration left) on login.
	--PersistSession = true,

	-- Options flag for this effect to not be removed on death
	--PersistDeath = true,

	-- Prevents this effect from being applied to Immune targets and when people go Immune, this effect is dropped.
	--Debuff = true,

	-- Can this be resisted by Willpower?
	--Resistable = true,

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration
		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "ExampleBuffDuration", "ExampleBuff", "Force Push 02", "This is a description.")
			AddBuffIcon(self.ParentObj, "ExampleDebuffDuration", "ExampleDebuff", "Force Push 02", "This is a description.", true)
		end
	end,

	OnExitState = function(self,root)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "ExampleBuffDuration")
			RemoveBuffIcon(self.ParentObj, "ExampleDebuffDuration")
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	-- Optional function to handle when the effect is applied while already active, set nil or keep commented out when not needed.
--[[
	OnStack = function(self,root,target,args)

	end,
]]

	-- Optional function when the effect receives the end effect message, This is NOT called when the effect ends internally, only when an external source trys to end the effect.
--[[
	OnEndEffect = function(self,root)
		self.ParentObj:NpcSpeech("EndEffect!")
		-- must call EndMobileEffect in here (unless you have a reason not to) if OnEndEffect is provided.
		EndMobileEffect(curTable)
	end,
]]

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(1),
}