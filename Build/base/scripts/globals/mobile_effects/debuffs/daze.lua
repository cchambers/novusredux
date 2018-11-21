MobileEffectLibrary.Daze = 
{
	Debuff = true,

	OnEnterState = function(self,root,opponent,args)
		args = args or {}
		self.Opponent = opponent
		self.Duration = args.Duration or self.Duration

		SetMobileMod(self.ParentObj, "Disable", "Daze", true)

		self.ParentObj:NpcSpeech("[FF0000]*dazed*[-]", "combat")
		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "DebuffDazed", "Dazed", "Force Push 02", "Cannot move or cast, any damage will interrupt the effect.", true)
			RegisterEventHandler(EventType.Message, "DamageInflicted", function(damager, damageAmount)
				if ( damageAmount > 0 ) then
					EndMobileEffect(root)
				end
			end)
		end
		self.ParentObj:PlayEffect("StunnedEffectObject")
	end,

	OnExitState = function(self,root)
		SetMobileMod(self.ParentObj, "Disable", "Daze", nil)

		self.ParentObj:SendMessage("ResetSwingTimer", 0)

		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "DebuffDazed")
			UnregisterEventHandler("", EventType.Message, "DamageInflicted")
		end

		self.ParentObj:StopEffect("StunnedEffectObject")
	end,

	GetPulseFrequency = function(self,root) 
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(1)
}