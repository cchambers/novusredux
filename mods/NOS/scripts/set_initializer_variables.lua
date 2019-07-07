RegisterEventHandler(EventType.ModuleAttached,"set_initializer_variables",
	function ()
		if(initializer) then
			for k,v in pairs(initializer) do
				this:SetObjVar(k,v)
			end
		end
		this:DelModule("set_initializer_variables")
	end)