
RegisterSingleEventHandler(EventType.ModuleAttached, "fill_container", 
	function()
		for i,itemInfo in pairs(initializer.Items) do
			local location = itemInfo.Location or GetRandomDropPosition(this)
			if not(itemInfo.Packed) then				
				CreateObjInContainer(itemInfo.Template,this,location,"item_created")
			else
				CreatePackedObjectInContainer(itemInfo.Template,false,this,location)
			end
		end

		CallFunctionDelayed(TimeSpan.FromSeconds(5),function() this:DelModule("fill_container") end)
	end)

RegisterEventHandler(EventType.CreatedObject,"item_created",
	function (success,objRef)
		if(success) then
			SetItemTooltip(objRef)
		end
	end)