RegisterEventHandler(EventType.Message,"UseObject",
	function (user)
		local infoMessage = this:GetObjVar("InfoMessage")
		if(infoMessage) then
			user:SystemMessage(infoMessage,"info")
		end
	end)

RegisterEventHandler(EventType.ModuleAttached,"info_on_use",
	function ()
		AddUseCase(this,"Activate",true)
	end)