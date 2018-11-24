TRADE_TIMEOUT = 120

mTraderA = this
mTraderB = nil
mPlotTarget = nil

mPlayerA_Accept = false
mPlayerB_Accept = false

mTradingPouchA = nil
mTradingPouchB = nil

function ValidateTradeTarget(traderWith)
	return traderWith and traderWith:IsValid() and not(IsInActiveTrade(traderWith))
end

function CanTradeWith(trader,traderWith)	
	if (not traderWith:IsValid()) then
		trader:SystemMessage("The person you were trading with dissapeared","info")
		return false
	end
	if (IsDead(trader)) then
		trader:SystemMessage("The dead don't trade with the living.","info")
		return false
	end
	if (IsDead(traderWith)) then
		trader:SystemMessage("The dead don't trade with the living.","info")
		return false
	end
	if (not traderWith:IsPlayer()) then
		trader:SystemMessage("[$2641]","info")
		return false
	end
	if (not trader:IsPlayer()) then
		traderWith:SystemMessage("[$2642]","info")
		return false
	end
	if (trader:DistanceFrom(traderWith) > OBJECT_INTERACTION_RANGE) then
		trader:SystemMessage("You strayed too far away to trade.","info")
		return false
	end
	
	--success
	return true
end

function MoveItemsBack()
	mTraderA = mTraderA or this

	if (mTraderA ~= nil) then
		if not(mTradingPouchA) then
			mTradingPouchA = mTraderA:GetEquippedObject("Trade")
		end

		if(mTradingPouchA) then
			local backpackObj = nil
			if(IsDead(mTraderA) and ShouldDropFullLoot(mTraderA)) then
				backpackObj = mTraderA:GetObjVar("CorpseObject")
				if(not(backpackObj) or not(backpackObj:IsValid())) then
					backpackObj = mTraderA:GetEquippedObject("Backpack")	
				end
			else
				backpackObj = mTraderA:GetEquippedObject("Backpack")
			end

			for i,item in pairs(mTradingPouchA:GetContainedObjects()) do
				if(item:GetCreationTemplateId() == "plot_deed") then
					item:Destroy()
				else					
		  			local randomLoc = GetRandomDropPosition(backpackObj)
		  			
					if not(TryPutObjectInContainer(item, backpackObj, randomLoc)) then
						item:SetWorldPosition(this:GetLoc())
					end
				end
			end
		end
	end
	if (mTraderB ~= nil) then
		for i,item in pairs(mTradingPouchB:GetContainedObjects()) do
			local backpackObj = mTraderB:GetEquippedObject("Backpack")
  			local randomLoc = GetRandomDropPosition(backpackObj)
  			
  			if not(TryPutObjectInContainer(item, backpackObj, randomLoc)) then
				item:SetWorldPosition(this:GetLoc())
			end
  		end
	end
end

function InterruptTrading()
	if (mTraderB ~= nil and mTraderB:IsValid()) then
		mTraderB:SystemMessage("The trade was cancelled.","info")
	end
	if (mTraderA ~= nil and mTraderA:IsValid()) then
		mTraderA:SystemMessage("The trade was cancelled.","info")
	end
	
	CleanUp()
end

function CompleteTrade()
	--switch the items
	mTraderA = mTraderA or this
	mTraderB = mTraderB
	if (mTraderA ~= nil and mTraderA:IsValid()) and (mTraderB ~= nil and mTraderB:IsValid()) then		
		if(mPlotTarget) then
			Plot.TransferOwnership(mTraderA,mPlotTarget,mTraderB, function(success)
				if ( success ) then
					TradeItems()
				else
					InterruptTrading()
				end
			end)
			return
		end
		TradeItems()
	else
		InterruptTrading()
	end	
end

function TradeItems()
	--move the items from eachother's trading pouches.
	for i,item in pairs(mTradingPouchA:GetContainedObjects()) do
		if(item:GetCreationTemplateId() == "plot_deed") then
			item:Destroy()
		else
			local backpackObj = mTraderB:GetEquippedObject("Backpack")
			  local randomLoc = GetRandomDropPosition(backpackObj)
			  item:MoveToContainer(backpackObj,randomLoc)
		  end
	end
	for i,item in pairs(mTradingPouchB:GetContainedObjects()) do
		local backpackObj = mTraderA:GetEquippedObject("Backpack")
		  local randomLoc = GetRandomDropPosition(backpackObj)
		  item:MoveToContainer(backpackObj,randomLoc)
	  end

	mTraderA:SystemMessage("You complete the trade with "..mTraderB:GetName(),"info")
	mTraderB:SystemMessage("You complete the trade with "..mTraderA:GetName(),"info")

	CleanUp()
end

function CleanUp()
	MoveItemsBack()
		
	if(mTradingPouchA and mTradingPouchA:IsValid()) then
		mTradingPouchA:Destroy()		
	end
	if(mTradingPouchB and mTradingPouchB:IsValid()) then
		mTradingPouchB:Destroy()
	end

	if (mTraderA ~= nil and mTraderA:IsValid()) then
		mTraderA:CloseDynamicWindow("TradingWindow")
	end
	if (mTraderB ~= nil and mTraderB:IsValid()) then
		mTraderB:CloseDynamicWindow("TradingWindow")
	end
	this:DelModule("trading_controller")
end

function ShowTradingWindow(user)
	--DebugMessage("user is "..tostring(user:GetName()))
	local dynWindow = DynamicWindow("TradingWindow","Trade",485,212,-240,-100,"TransparentDraggable","Center")
	local isTraderA = (user == mTraderA)	
	local canAccept = false

	local leftPouch = (isTraderA and mTradingPouchA) or mTradingPouchB
	local rightPouch = (isTraderA and mTradingPouchB) or mTradingPouchA

	dynWindow:AddImage(-25,-14,"TradeWindow_BG")	

	dynWindow:AddContainerScene(38,24,166,166,leftPouch)
	
	dynWindow:AddContainerScene(286,24,166,166,rightPouch)
		
	local leftAccept = mPlayerB_Accept
	if(isTraderA) then
		leftAccept = mPlayerA_Accept
	end
	local rightAccept = mPlayerA_Accept
	if(isTraderA) then
		rightAccept = mPlayerB_Accept
	end

	local leftAcceptId = (isTraderA and "AcceptA") or "AcceptB"

	dynWindow:AddButton(187,186,leftAcceptId,"",0,0,"Accept the trade","",false,"MyCheck")
	if(leftAccept) then
		dynWindow:AddImage(190,151,"Accept_Knife")
	end	

	if(rightAccept) then
		dynWindow:AddImage(450,151,"Accept_Knife")
	end	

	dynWindow:AddButton(464,6,"Cancel","",18,18,"","",true,"CloseSquare")

	user:OpenDynamicWindow(dynWindow,this)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"TradingWindow",
	function (user,buttonId)
		--DebugMessage("BUTTON INPUT ----------------------------------------------")
		--DebugMessage("user is "..tostring(user))
		--DebugMessage("ButtonId is "..tostring(buttonId))	
		--Check to see if the user is valid
		--DebugMessage(1)
		if (user == nil or not user:IsValid()) then 
			--DebugMessage(2)
			CleanUp()
			return
		end
		local isTraderA = (user == mTraderA)
		--If they closed the window
		--DebugMessage(3)

		--If we cancel then clean up.
		if (not(buttonId) or buttonId == "" or buttonId == "Cancel") then
			--DebugMessage(12)
			InterruptTrading()
			return
		end
		if (not CanTradeWith(mTraderA,mTraderB)) then
			InterruptTrading()
			return
		end
		--if we try to do someone else's accept button do nothing.
		--DebugMessage(5)
		if (isTraderA and "AcceptB" == buttonId) then
			--DebugMessage(6)
			return
		elseif (not isTraderA) and "AcceptA" == buttonId then
			--DebugMessage(7)
			return 
		end
		--DebugMessage(8)
		--if we hit an except button that's ours
		if (buttonId == "AcceptA" or buttonId == "AcceptB") then
			--DebugMessage(9)
			if (isTraderA) then
				--DebugMessage("W "..GetContentsWeight(mTradingPouchA))
				if (not mPlayerA_Accept and not CanAddWeightToContainer(mTraderB:GetEquippedObject("Backpack"),GetContentsWeight(mTradingPouchA))) then
					mTraderA:SystemMessage("You are unable to accept the trade because it would put them over weight.","info")
				else
					mPlayerA_Accept = not mPlayerA_Accept
				end
			else
				--DebugMessage("W2 "..GetContentsWeight(mTradingPouchB))	
				if (not mPlayerB_Accept and not CanAddWeightToContainer(mTraderA:GetEquippedObject("Backpack"),GetContentsWeight(mTradingPouchB))) then
					mTraderB:SystemMessage("You are unable to accept the trade because it would put them over weight.","info")
				else
					mPlayerB_Accept = not mPlayerB_Accept
				end
			end
		end

		--If we both accept then complete the trade
		--DebugMessage(13)
		if (mPlayerA_Accept and mPlayerB_Accept) then
			--DebugMessage(14)
			CompleteTrade()
			return
		end
		--DebugMessage(15)
		--Update the trading windows.
		ShowTradingWindow(mTraderA)
		ShowTradingWindow(mTraderB)
	end)

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),function ( ... )	
	if(initializer ~= nil) then				
		InitiateTrade(initializer.TradeTarget,initializer.PlotTarget)
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(TRADE_TIMEOUT),"CancelTradingTimer")
	else
		CleanUp()
	end	
end)

pendingTradeCreates = 0

function InitiateTrade(target,plotTarget)
	if not(ValidateTradeTarget(target)) then
		this:SystemMessage("That person is already trading with someone.","info")
	elseif (CanTradeWith(this,target)) then
		this:SystemMessage("You invite "..tostring(target:GetName()).." to trade.","info") 
		ClientDialog.Show{
			TargetUser = target,
			DialogId = "TradeInvite"..target.Id,
		    TitleStr = "Trading",
		    DescStr = this:GetName().." invites you to trade.",
		    Button1Str = "Accept",
		    Button2Str = "Decline",
		    ResponseObj= this,
		    ResponseFunc= function(user,buttonId)
				local buttonId = tonumber(buttonId)
				--DebugMessage("Trade: Request Response "..buttonId)
				if (user == nil or buttonId == nil) then 
					CleanUp()
				elseif (buttonId == 0 and ValidateTradeTarget(target) and CanTradeWith(this,target)) then
					--DebugMessage("Bam")
					mTraderA = this
					mTraderB = user
					mPlotTarget = plotTarget
										
					pendingTradeCreates = 2
					CreateEquippedObj("pouch_trade", user, "created_trading_pouch",user)
					CreateEquippedObj("pouch_trade", this, "created_trading_pouch",this)					

					local searchDistanceFromSelf = SearchSingleObject(user,SearchObjectInRange(OBJECT_INTERACTION_RANGE))
					AddView("CheckInTradeProximity",searchDistanceFromSelf,1.0)
					mTraderA:SystemMessage(mTraderB:GetName().." accepts your trade request.","info")
					mTraderB:SystemMessage("You agree to trade with "..mTraderA:GetName(),"info")
					RegisterSingleEventHandler(EventType.LeaveView,"CheckInTradeProximity",
						function()
							CleanUp()
						end)

					this:RemoveTimer("CancelTradingTimer")
				else
					this:SystemMessage(user:GetName().." does not wish to trade at this time.","info")
					user:SystemMessage("You decline to trade with "..this:GetName(),"info")
					--DebugMessage("Bam2")
					CleanUp()
				end
			end
		}
	else
		CleanUp()
	end
end

function CancelAccept()
	mPlayerA_Accept = false
	mPlayerB_Accept = false
end

RegisterEventHandler(EventType.EnterView,"CheckBagsForNewItemsA",
	function()
		CancelAccept()
		ShowTradingWindow(mTraderA)
		ShowTradingWindow(mTraderB)
	end)
RegisterEventHandler(EventType.LeaveView,"CheckBagsForNewItemsA",
	function()
		CancelAccept()
		ShowTradingWindow(mTraderA)
		ShowTradingWindow(mTraderB)
	end)
RegisterEventHandler(EventType.EnterView,"CheckBagsForNewItemsB",
	function()
		CancelAccept()
		ShowTradingWindow(mTraderA)
		ShowTradingWindow(mTraderB)
	end)
RegisterEventHandler(EventType.LeaveView,"CheckBagsForNewItemsB",
	function()
		CancelAccept()
		ShowTradingWindow(mTraderA)
		ShowTradingWindow(mTraderB)
	end)
RegisterEventHandler(EventType.CreatedObject,"created_trading_pouch",function (success,objRef,user)
	--DebugMessage(2.5)
	if (success) then
		objRef:SetObjVar("TradingPouch",true)
		--DebugMessage(tostring(mTraderA).." is mTraderA")
		--DebugMessage(tostring(user).." is user")
		if (user == mTraderA) then
			--DebugMessage("mTradingPouchA")
			mTradingPouchA = objRef
			if(mPlotTarget ~= nil) then
				CreateObjInContainer("plot_deed",mTradingPouchA,Loc(0,1.5,-0.32),"deed_created")
			end
		else
			--DebugMessage("mTradingPouchB")
			mTradingPouchB = objRef
		end
		--DebugMessage("A:",mTradingPouchA,mTradingPouchB)
		--DebugMessage(3)
		pendingTradeCreates = pendingTradeCreates - 1
		if(pendingTradeCreates == 0) then				
			local searcherB = SearchContainer(mTradingPouchA)
			local searcherA = SearchContainer(mTradingPouchA)
			AddView("CheckBagsForNewItemsA",searcherB,0.1)	
			AddView("CheckBagsForNewItemsB",searcherA,0.1)							
			
			ShowTradingWindow(mTraderA)
			ShowTradingWindow(mTraderB)	
		end
	else
		DebugMessage("[trading_controller] ERROR: Failed to create trading pouch for "..user:GetName())
		CleanUp()
	end
end)

RegisterEventHandler(EventType.CreatedObject,"deed_created",
	function(success,objRef,user)
		if(mPlotTarget and mPlotTarget:IsValid()) then
			objRef:SetName("Deed to Plot")
			local bounds = mPlotTarget:GetObjVar("PlotBounds")
			local balance = GlobalVarReadKey("Plot."..mPlotTarget.Id, "Balance") or 0
			SetTooltipEntry(objRef,"plot_balance", string.format("Balance\n%s\n", balance>0 and ValueToAmountStr(balance) or "Empty"), 100)
			SetTooltipEntry(objRef,"plot_size", "Size", 99)
			for i=1,#bounds do
				SetTooltipEntry(objRef,"plot_size_"..i, string.format("%s x %s\n", bounds[i][2].X, bounds[i][2].Z), 99-i)
			end
			SetTooltipEntry(objRef,"plot_rate", string.format("Rate\n%s\n", ValueToAmountStr(Plot.CalculateRate(bounds))), 1)
		end
	end)

RegisterEventHandler(EventType.Timer,"CancelTradingTimer",function ( ... )
	CleanUp()
end)

RegisterEventHandler(EventType.LoadedFromBackup,"",function ( ... )
	CleanUp()
end)

RegisterEventHandler(EventType.UserLogout,"",function ( ... )
	InterruptTrading()
end)

RegisterEventHandler(EventType.Message,"CancelTrade",function ( ... )
	InterruptTrading()
end)

RegisterEventHandler(EventType.Message,"HasDiedMessage",function ( ... )
	InterruptTrading()
end)