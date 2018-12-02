MobileEffectLibrary.PowerHourBuff = {
	OnEnterState = function(self, root, target, args)
		DebugMessage("User has entered powerhour.")
		RegisterEventHandler(
			EventType.Timer,
			"PowerHourTimer",
			function()
				EndMobileEffect(root)
				DebugMessage("THAT DID IT!")
			end
		)
	end,
	OnEndEffect = function(self, root, endingObj)
	end
}
