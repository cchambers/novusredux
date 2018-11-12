mTraderA = nil

function MoveItemsBack(tradePouch)	
	if(tradePouch) then
		for i,item in pairs(mTradingPouchA:GetContainedObjects()) do				
			local backpackObj = this:GetEquippedObject("Backpack")
  			local randomLoc = GetRandomDropPosition(backpackObj)
  			
			if not(TryPutObjectInContainer(item, backpackObj, randomLoc)) then
				item:SetWorldPosition(this:GetLoc())
			end
		end
	end
end

function CleanUp()
	local tradePouch = this:GetEquippedObject("Trade")
	MoveItemsBack(tradePouch)
	
	if(tradePouch) then
		tradePouch:Destroy()		
	end
		
	this:CloseDynamicWindow("TradingWindow")
	
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