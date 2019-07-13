RegisterEventHandler(EventType.Message,"Activate",
	function ()
		if not(this:GetSharedObjectProperty("IsActivated")) then
			this:SetSharedObjectProperty("IsActivated",true)
			CallFunctionDelayed(TimeSpan.FromSeconds(0.3),function ( ... )
				this:SetSharedObjectProperty("IsActivated",false)
			end)
		end
	end)