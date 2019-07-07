--[[
	This debuff doesn't need to do more than add an icon since the existance of this buff on the mobile is check when calculating MoveSpeed under base_mobilestats
]]
MobileEffectLibrary.HeavyArmorDebuff = 
{

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration

		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "HeavyArmorDebuff", "Heavy Armor", "Force Push 02", "You are exhausted from the weight of recently removed armor.", true)
		end
	end,

	OnExitState = function(self,root)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "HeavyArmorDebuff")
		end
		self.ParentObj:SendMessage("RecalculateStats", {MoveSpeed=true})
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = ServerSettings.Stats.HeavyArmorDebuffDuration,
}