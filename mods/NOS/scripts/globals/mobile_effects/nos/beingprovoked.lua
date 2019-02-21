MobileEffectLibrary.BeingProvoked = {
	OnEnterState = function(self, root, tamer)
		if (tamer == nil) then
			EndMobileEffect(root)
			return false
		end
		self.Tamer = tamer

		RegisterSingleEventHandler(
			EventType.ClientTargetGameObjResponse,
			"Crook.Provoke",
			function (target,user)
				self.Target = target
				DebugMessage(self.Target:GetName())
				if (self.Target == nil) then
					self.Tamer:SystemMessage("That's nothing.", "info")
					EndMobileEffect(root)
					return false
				end
				
				if (self.ParentObj:GetLoc():Distance(self.Target:GetLoc()) > 20) then
					self.Tamer:SystemMessage("That's too far away.", "info")
					EndMobileEffect(root)
					return false
				end

				local success = CheckSkill(self.Tamer, "AnimalLoreSkill")
				if (self.Target:IsMobile() and success) then
					self.ParentObj:SendMessage("AttackEnemy", self.Target, true)
					self.Tamer:SystemMessage(tostring("You begin provoking " .. self.ParentObj:GetName()), "info")
				else
					self.Tamer:SystemMessage("[ff0000]You fail to provoke the creature.[-]", "info")
				end
			end
		)

		self.Tamer:SystemMessage("What should it attack?", "info")
		self.Tamer:RequestClientTargetGameObj(self.ParentObj, "Crook.Provoke")
	end,
	OnExitState = function(self, root)
		self.Tamer:SystemMessage(tostring("Provocation has ended.", "info"))
		if (self.ParentObj:GetStatValue("Health") > self.Target:GetStatValue("Health")) then
			self.ParentObj:SendMessage("EndCombatMessage")
		end
	end,
	GetPulseFrequency = function(self, root)
		return self.Duration
	end,
	AiPulse = function(self, root)
		EndMobileEffect(root)
	end,
	Tamer = nil,
	Duration = TimeSpan.FromSeconds(30)
}
