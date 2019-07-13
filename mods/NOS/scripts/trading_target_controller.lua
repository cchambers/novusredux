mTraderA = nil

function CleanUp()
	this:DelModule("trading_target_controller")
end

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),function ( ... )	
	if(initializer ~= nil) then
		mTraderA = initializer.TradeTarget
		--this:ScheduleTimerDelay(TimeSpan.FromSeconds(TRADE_TIMEOUT),"CancelTradingTimer")
	else
		CleanUp()
	end	
end)

RegisterEventHandler(EventType.LoadedFromBackup,"",function ( ... )
	CleanUp()
end)

RegisterEventHandler(EventType.UserLogout,"",function ( ... )
	if(mTraderA and mTraderA:IsValid()) then
		mTraderA:SendMessage("CancelTrade")
	else
		CleanUp()
	end
end)

RegisterEventHandler(EventType.Message,"HasDiedMessage",function ( ... )
	if(mTraderA and mTraderA:IsValid()) then
		mTraderA:SendMessage("CancelTrade")
	else
		CleanUp()
	end
end)

RegisterEventHandler(EventType.Message,"ClearTradeAccept",function()
	if(mTraderA and mTraderA:IsValid()) then
		mTraderA:SendMessage("ClearTradeAccept")
	else
		CleanUp()
	end		
end)