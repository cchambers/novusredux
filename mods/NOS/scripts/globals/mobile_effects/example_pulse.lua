MobileEffectLibrary.Example = 
{
	-- Options flag for this effect to not be removed on death
	--PersistDeath = true,
	
	-- Prevents this effect from being applied to Immune targets and when people go Immune, this effect is dropped.
	--Debuff = true,

	-- Can this be resisted by Willpower?
	--Resistable = true,

	OnEnterState = function(self,root,target,args)
		self.PulseFrequency = args.PulseFrequency or self.PulseFrequency
		self.PulseMax = args.PulseMax or self.PulseMax
		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "ExamplePulse", "Example", "Force Push 02", "This is a description.", true)
		end
	end,

	OnExitState = function(self,root)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "ExamplePulse")
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.PulseFrequency
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
		self.CurrentPulse = self.CurrentPulse + 1
		if ( self.CurrentPulse > self.PulseMax ) then
			EndMobileEffect(root)
		else

		end
	end,

	PulseFrequency = TimeSpan.FromSeconds(1),
	PulseMax = 1,
	CurrentPulse = 0,
}