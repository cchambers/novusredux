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
	end,

	OnExitState = function(self, root)
		if ( self.ParentObj:IsPlayer()) then
			RemoveBuffIcon(self.ParentObj, "ColorWarPlayerEffect")
		end
	end,

	GetPulseFrequency = function(self, root)
		return self.Duration
	end,

	AiPulse = function(self, root)
		local user = self.ParentObj
		local points = user:GetObjVar("ColorWarPoints") or 0
		points = points + 1
		user:NpcSpeechToUser("+[bada55]1[-]CWP",user,"combat")
		user:SetObjVar("ColorWarPoints", points)
	end,

	Duration = TimeSpan.FromMinutes(1)
}
