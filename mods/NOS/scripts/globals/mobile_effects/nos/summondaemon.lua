MobileEffectLibrary.SummonDaemon = {
	ShouldStack = true,
	OnEnterState = function(self, root, target, args)

		self.Location = self.ParentObj:GetLoc()

		local currentMinions = FindObjects(SearchMulti({
			SearchObjVar("controller", self.ParentObj),
			SearchObjVar("Summon", true)
		}))
		if (#currentMinions >= ServerSettings.Combat.MaxMinions + 1) then
			self.ParentObj:SystemMessage("[D70000]You have too many minions in play![-]", "info")
			EndMobileEffect(root)
			return
		end
		self.Template = "demon_summon"

		RegisterSingleEventHandler(
			EventType.CreatedObject,
			"Summon.Daemon",
			function(success, objRef)
				local myResSource = self.ParentObj
				if myResSource == nil or not (myResSource:IsValid()) then
					DebugMessage("[summon creature mobile effect] ERROR: Could not find assigned spell source")
					EndMobileEffect(root)
					return
				end
				objRef:AddModule("ai_follower")
				objRef:AddModule("slay_decay")
				objRef:SetObjVar("SlayDecayTime", self.Lifetime)
				objRef:SetObjVar("Summon", true)
				objRef:SetObjVar("ControllingSkill", "MagerySkill")
				myResSource:SendMessage("AddFollowerMessage", {["pet"] = objRef})
				objRef:SendMessage("ReassignSuperior", myResSource)
				EndMobileEffect(root)
			end
		)

		self.Summon(self, root)
	end,
	Summon = function(self, root)
		CreateObj(self.Template, self.Location, "Summon.Daemon")
		AdjustKarma(self.ParentObj, -500)
	end,
	OnExitState = function(self, root)
		return
	end,
	GetPulseFrequency = function(self, root)
		return self.Duration
	end,
	AiPulse = function(self, root)
		EndMobileEffect(root)
	end,
	Duration = TimeSpan.FromSeconds(2),
	Lifetime = 480
}
