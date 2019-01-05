RegisterEventHandler(EventType.Message, "CompletionEffectsp_reveal_effect",
	function ()
		if (HasMobileEffect(this, "Hide")) then
			this:SendMessage("StartMobileEffect", "Revealed")
		end
		CallFunctionDelayed(TimeSpan.FromSeconds(1), function ()
			this:DelModule("sp_reveal_effect")
		end)
	end)