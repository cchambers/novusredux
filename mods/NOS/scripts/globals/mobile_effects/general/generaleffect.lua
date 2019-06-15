--[[
	Useful for applying visual and sound effects for weapon abilities that don't utilize a mobile_effect.
]]

MobileEffectLibrary.GeneralEffect = 
{

	OnEnterState = function(self,root,target,args)
		self.VisualEffects = args.VisualEffects or self.VisualEffects
		self.SoundEffects = args.SoundEffects or self.SoundEffects

		for i=1,#self.VisualEffects do
			self.ParentObj:PlayEffect(self.VisualEffects[i])
		end
		for i=1,#self.SoundEffects do
			self.ParentObj:PlayObjectSound(self.SoundEffects[i])
		end
	end,

	OnExitState = function(self,root)
		for i=1,#self.VisualEffects do
			self.ParentObj:StopEffect(self.VisualEffects[i])
		end
		--[[ is this necessary?
		for i=1,#self.SoundEffects do
			self.ParentObj:StopEffect(self.VisualEffects[i])
		end
		]]
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(1),
	VisualEffects = {},
	SoundEffects = {}
}