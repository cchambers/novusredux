local purgeComplete = false

function OnLoad()
	this:SetObjectTag("CatacombsController")
end

RegisterEventHandler(EventType.LoadedFromBackup,"",
	function ()
		OnLoad()
	end)

RegisterEventHandler(EventType.Message,"Reset",
	function()
			DebugMessage("Reset command acknowledged")
			DestroyAllObjects(false,"WorldReset")
	end)

RegisterEventHandler(EventType.Message,"PurgePlayers",
	function()
		DebugMessage("Purge Players command acknowledged")
		purgeComplete = false
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(15),"shake")
		CallFunctionDelayed(TimeSpan.FromMinutes(3),function ( ... )
            local sendto = GetRegionAddressesForName("SouthernHills")
            for i = 1, #sendto do
                SendRemoteMessage(sendto[i], MapLocations.NewCelador["Southern Hills: Catacombs Portal"], 5, "close_catacombs_portal")
            end

            purgeComplete = true
            local loggedOnUsers = FindPlayersInRegion()
            for index,object in pairs(loggedOnUsers) do
            	--object:PlayEffectWithArgs("ScreenShakeEffect",2.0,"Magnitude=5")
                TeleportUser(object,object,MapLocations.NewCelador["Southern Hills: Catacombs Portal"],sendto[1], 0, true)
            end
        end)	
	end)

RegisterEventHandler(EventType.DestroyAllComplete,"WorldReset", function ()
	LoadSeeds()
	ResetPermanentObjectStates()
end)


RegisterEventHandler(EventType.Timer,"shake",
	function ( ... )
		local loggedOnUsers = FindPlayersInRegion()
        for index,object in pairs(loggedOnUsers) do
--            object:PlayEffectWithArgs("ScreenShakeEffect", math.random(2,5),"Magnitude=10")
        end

		if(purgeComplete == false) then
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(math.random(8,25)),"shake")
		end
	end)
