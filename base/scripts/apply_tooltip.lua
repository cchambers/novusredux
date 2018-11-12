RegisterSingleEventHandler(EventType.ModuleAttached,"apply_tooltip",
	function ( ... )
		if(initializer and initializer.Tooltip) then
			SetTooltipEntry(this,"apply_tooltip",initializer.Tooltip,1000)
		end

		this:DelModule("apply_tooltip")
	end)