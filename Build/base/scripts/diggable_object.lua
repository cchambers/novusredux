RegisterSingleEventHandler(EventType.ModuleAttached,"diggable_object",
	function()
		this:SetObjVar("BuriedItems",initializer.BuriedItems)
	end)

RegisterEventHandler(EventType.Message,"DigItem",
	function (shovelUser,digLoc)		
		
		if (this:HasObjVar("DugUp")) then
       	 	shovelUser:SystemMessage("This area has been dug up already.")
       	 	return
		end
		local buriedItems = this:GetObjVar("BuriedItems")
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(10),"respawnBuriedItem")
		this:SetObjVar("DugUp",true)
		for i,j in pairs(buriedItems) do 
			if (math.random(1,j.chance) == 1) then
				item = j.item
				CreateObj(item,digLoc,"digCreated",shovelUser)		
				shovelUser:SystemMessage("You dug something up!")
				return
			end
		end
        shovelUser:SystemMessage("You find nothing of interest there.")
	end)

RegisterEventHandler(EventType.CreatedObject,"digCreated",
	function(success,objRef,user)
		if (success) then
			if (objRef ~= nil) then
				if (objRef:IsMobile()) then
					objRef:SendMessage("AttackEnemy",user)
				end
			end
		end
	end)

RegisterEventHandler(EventType.Timer,"respawnBuriedItem",
	function()
		this:DelObjVar("DugUp")
	end)
