RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function ( ... )
		AddUseCase(this,"Examine",true)
		SetTooltipEntry(this,"demo_book","This book looks very old. Perhaps you should examine it further.")
	end)

RegisterEventHandler(EventType.Message,"UseObject",
	function (user,usedType)
		if(usedType == "Examine" or usedType == "Use") then
			if not(FindObject(SearchTemplate("demo_wisp",20))) then
				local spawnLoc = GetNearbyPassableLoc(user,360,2,4)
				CreateObj("demo_wisp",spawnLoc,"wisp_created",user)
			end
		end
	end)

RegisterEventHandler(EventType.CreatedObject, "wisp_created",
	function (success,objRef,user)
		objRef:SendMessage("Init",user)
	end)