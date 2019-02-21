MobileEffectLibrary.BeingProvoked = 
{

	OnEnterState = function(self,root,tamer)
		if ( tamer == nil ) then
			EndMobileEffect(root)
			return false
		end
		self.Tamer = tamer
		self.ParentObj:NpcSpeech("ARRRGHHH!")

		RegisterSingleEventHandler(EventType.ClientTargetLocResponse, "Crook.Provoke",
		function (success, targetLoc, targetObj, user)
			if (success) then
				local target = targetObj
				if (target:IsMobile()) then
					self.Target = target
					self.ParentObj:SendMessage("AttackEnemy", target)
					self.Tamer:SystemMessage(tostring("You begin provoking the " .. self.ParentObj:GetName()), "info")
				else 
					self.Tamer:SystemMessage("[ff0000]You fail to provoke the creature.[-]", "info")
				end
				EndMobileEffect(root)
			end
		end)

		self.Tamer:SystemMessage("What should it attack?", "info")
		self.Tamer:RequestClientTargetLoc(self.ParentObj, "Crook.Provoke")
	end,

	OnExitState = function(self,root)
		self.Tamer:SystemMessage(tostring("Provocation has ended.", "info"))
		if (self.ParentObj:GetStatValue("Health") > self.Target:GetStatValue("Health")) then
			self.ParentObj:SendMessage("EndCombatMessage")
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Tamer = nil,
	Duration = TimeSpan.FromSeconds(30)
}