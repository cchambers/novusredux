RegisterEventHandler(EventType.Message, "CompletionEffectsp_reveal_effect",
	function ()
		if (HasMobileEffect(this, "Hide")) then
			this:NpcSpeech("AM HIDDEN")
		else
			this:NpcSpeech("SAYS NOT HIDDEN")
		end
		
		this:SendMessage("StartMobileEffect", "Revealed")

		CallFunctionDelayed(TimeSpan.FromSeconds(1), function ()
			this:DelModule("sp_reveal_effect")
		end)
	end)