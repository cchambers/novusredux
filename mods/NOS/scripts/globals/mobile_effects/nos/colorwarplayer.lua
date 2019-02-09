MobileEffectLibrary.ColorWarPlayer = {
	OnEnterState = function(self, root, target, args)
		AddBuffIcon(
            self.ParentObj,
            "ColorWarPlayerEffect",
            "[FF0000]C[-][FF7F00]O[-][FFFF00]L[-][00FF00]O[-][0000FF]R[-] [4B0082]W[-][9400D3]A[-][FF0000]R[-][FF7F00]S[-]",
            "transience",
            "You are playing color wars, apparently!",
            false
		)
		self.ParentObj:SystemMessage("You are playing Color Wars!")
		
		self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(5), "ColorWar.CheckWin")
		RegisterEventHandler(EventType.Timer,"ColorWar.CheckWin", function()
			self.CheckWinCondition(self, root)
		end)
	end,

	OnExitState = function(self, root)
		if ( self.ParentObj:IsPlayer()) then
			RemoveBuffIcon(self.ParentObj, "ColorWarPlayerEffect")
		end
	end,

	GetPulseFrequency = function(self, root)
		return self.Duration
	end,

	CheckWinCondition = function (self, root) 
		local user = self.ParentObj
		local backpackObj = user:GetEquippedObject("Backpack")
		local count = 0
		local items = FindItemInContainerRecursive(backpackObj,function (item)
			if (item:HasObjVar("ColorWarFlag")) then
				count = count + 1
			end
		end)

		if (count >= 2) then
			user:PlayEffectWithArgs("SlimeTrailEffect", 0.0,"Bone=Ground")
			self.HadFlag = true
			self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "ColorWar.CheckWin")
		else
			if (self.HadFlag == true) then
				user:StopEffect("SlimeTrailEffect")
				self.HadFlag = false
			end
			self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(5), "ColorWar.CheckWin")
		end
	end,

	AiPulse = function(self, root)
		local user = self.ParentObj
		local points = user:GetObjVar("ColorWarPoints") or 0
		points = points + 1
		user:NpcSpeechToUser("+[bada55]1[-]CWP",user,"combat")
		user:SetObjVar("ColorWarPoints", points)
	end,

	Duration = TimeSpan.FromMinutes(1),

	HadFlag = false
}
