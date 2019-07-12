require 'stackable'

activeSplit = false

function GetAmounts(objRef)
	objRef = objRef or this

	local amounts = objRef:GetObjVar("Amounts")
	-- if it's not set, calculate what it should be off the stack size.
	if not(amounts) then
		amounts = {}
		local lowestDenom = GetLowestDenomination()
		if not(lowestDenom) then return end
		local stackCount = objRef:GetObjVar("StackCount") or 1	
		amounts[lowestDenom.Name] = stackCount
		return ChangeUp(amounts)
	end

	return amounts
end

function GetDenomInfo(denom)
	return searchTable(Denominations,denom,function (v,e)
			return e.Name == v
		end)
end

function GetDenomForValue(amount)
	return searchTable(Denominations,amount,function (v,e)
			return e.Value == v
		end)
end

function GetCoinCount(amounts)
	amounts = amounts or GetAmounts()

	local result = 0
	for denom,count in pairs(amounts) do
		result = result + count
	end

	return result
end

function GetValue(amounts)
	amounts = amounts or GetAmounts()

	local result = 0
	for i,denomInfo in pairs(Denominations) do
		if(amounts[denomInfo.Name]) then
			result = result + (amounts[denomInfo.Name] * denomInfo.Value)
		end
	end

	return result
end

function UpdateValue(amounts)
	amounts = amounts or GetAmounts()

	--DebugMessage("UPDATING VALUE "..GetValue(amounts))
	this:SetObjVar("StackCount",GetValue(amounts))
end

function UpdateTooltip(amounts)
	amounts = amounts or GetAmounts()

	this:SetName("[FFBF00]Coin Purse ("..GetAmountStrShort(amounts,false,false)..")[-]")

	local resultStr = "\n"
	local start = false
	for i,entry in pairs(GetDenominationsDescending()) do
		if(start or amounts[entry.Name]) then
			-- we want 0s after the first no zero coin
			start = true
			local val = amounts[entry.Name] or 0
			resultStr = resultStr .. entry.Color..entry.Name..":[-] "..tostring(val).."\n"
		end
	end
	SetTooltipEntry(this,"value",resultStr)

	UpdateSplitStack(this)
end

function UpdateWeight(amounts)
	if(GetWeight(this) ~= -1) then
		local oldWeight = this:GetSharedObjectProperty("Weight")
					
		amounts = amounts or GetAmounts()

		local singleWeight = ServerSettings.Misc.CoinWeight or 1
		local stackWeight = math.ceil(math.max(1,GetCoinCount(amounts)*singleWeight))
		if(this:GetSharedObjectProperty("Weight") ~= stackWeight) then
			this:SetSharedObjectProperty("Weight",stackWeight)
		end

		local newWeight = this:GetSharedObjectProperty("Weight")
		local adjustWeightBy = newWeight - oldWeight		
		if(adjustWeightBy ~= 0) then
			--DebugMessage("Adjusted weight by "..adjustWeightBy)
			local containedObj = this:ContainedBy()
			if(containedObj ~= nil) then
				containedObj:SendMessage("AdjustWeight", adjustWeightBy)
			end
		end
	end
end

function UpdateInfo(amounts)
	amounts = amounts or GetAmounts()

	UpdateAmounts(amounts)
	UpdateValue(amounts)
	UpdateWeight(amounts)	
	UpdateTooltip(amounts)
end

function UpdateAmounts(amounts)
	this:SetObjVar("Amounts",amounts)
end

function DoChangeUp(amounts)
	amounts = ChangeUp(amounts or GetAmounts())
	
	UpdateInfo(amounts)
end

function TrySplitCoins(stackAmounts,user)
	-- you can split any amounts from the bank
	if(IsInBank(this)) then
		local curValue = GetValue()
		local newStackValue = GetValue(stackAmounts)
		if(newStackValue > curValue) then
			user:SystemMessage("There is not enough coins in that coin purse.","info")
			return		
		end
	else
		local amounts = GetAmounts()
		for i,denomInfo in pairs(Denominations) do
			local coinsToTake = stackAmounts[denomInfo.Name] or 0
			if(coinsToTake > 0) then
				local coinCount = amounts[denomInfo.Name] or 0
				if(coinsToTake > coinCount) then
					user:SystemMessage("You do not have enough "..denomInfo.Name..".","info")
					return
				end
			end
		end		
	end

	if(IsInActiveTrade(user)) then
		user:SendMessage("ClearTradeAccept")
	end

	activeSplit = true
	CreateObjInContainer(this:GetCreationTemplateId(), user, Loc(0,0,0), "stack_created", stackAmounts, user)
end

-- this takes a amount table ({Copper = 10}) or another coin object
function AddCoins(arg)
	local addAmounts = nil
	local argType = GetValueType(arg)
	if(argType == "table") then
		addAmounts = arg
	elseif(argType == "GameObj") then
		addAmounts = GetAmounts(arg)
	end

	if(addAmounts) then
		local amounts = GetAmounts()

		for i,denomInfo in pairs(Denominations) do
			if(addAmounts[denomInfo.Name] ~= nil) then
				amounts[denomInfo.Name] = (amounts[denomInfo.Name] or 0) + addAmounts[denomInfo.Name]
			end
		end

		UpdateInfo(amounts)
	end
end

function RemoveCoins(arg)
	local removeAmounts = nil
	local argType = GetValueType(arg)
	if(argType == "table") then
		removeAmounts = arg
	elseif(argType == "GameObj") then
		removeAmounts = GetAmounts(arg)
	end

	if(removeAmounts) then
		local amounts = GetAmounts()
		for i,denomInfo in pairs(Denominations) do
			local coinsToTake = removeAmounts[denomInfo.Name] or 0
			if(coinsToTake > 0) then
				local coinCount = amounts[denomInfo.Name] or 0
				if(coinsToTake > coinCount) then
					return			
				else
					amounts[denomInfo.Name] = coinCount - coinsToTake						
				end
			end
		end	

		UpdateInfo(amounts)	
	end
end

function SetCoins(amounts)
	UpdateInfo(amounts)
end

RegisterEventHandler(EventType.Message,"SetCoins",
	function (amounts)
		SetCoins(amounts)
	end)

-- NOTE: arg can be an amount table OR another coin object
RegisterEventHandler(EventType.Message,"AddCoins",
	function (arg)
		AddCoins(arg)
	end)

RegisterEventHandler(EventType.Message,"ChangeUp",
	function (arg)
		DoChangeUp()
	end)

-- stackable overrides

function SetStack(amount)
	local lowestDenom = GetLowestDenomination()
	if not(lowestDenom) then return end		

	local amounts = {}
	amounts[lowestDenom.Name] = amount
	DoChangeUp(amounts)		
end

-- this always assumes it has the ability to make change (ie create any coin denominations)
-- this allows merchants, banks to treat the coins like a stack
-- when it comes to merging coin purses without changing up denominations, we need to use AddCoins
function AdjustStack(delta)	
	local amounts = GetAmounts()
	
	-- adding coins
	if(delta > 0) then
		local i = #Denominations
		while(i > 0) do
			local denomAmount = amounts[Denominations[i].Name] or 0
			local coinsToAdd = math.floor(delta / Denominations[i].Value)
			--DebugMessage("ADD "..Denominations[i].Name.." "..coinsToAdd)
			if(coinsToAdd > 0) then
				amounts[Denominations[i].Name] = denomAmount + coinsToAdd
				delta = delta - (coinsToAdd * Denominations[i].Value)
			end
			i = i - 1
		end

		if(delta ~= 0) then
			DebugMessage("ERROR: Something went horribly wrong with adjusting coin stack.")
		end

		UpdateInfo(amounts)
	-- removing coins
	else
		local stackValue = GetValue(amounts)
		if(stackValue <= delta) then
			if(stackValue < delta) then
				DebugMessage("WARNING: Took more coins than we have.")
			end
			this:Destroy()
		else
			--DebugMessage(stackValue,delta)
			stackValue = stackValue + delta
			if (stackValue <= 0) then
				this:Destroy()
				return
			end
			--DebugMessage("newStackValue",stackValue)
			amounts = ValueToAmounts(stackValue)
			UpdateInfo(amounts)
		end
	end
end

function HandleLoaded()
	local amounts = nil
	if(initializer ~= nil and initializer.Coins ~= nil) then
		amounts = initializer.Coins
		UpdateInfo(amounts)
	else		
		amounts = this:GetObjVar("Amounts")
		if(amounts == nil) then			
			-- if amounts is not set yet try to convert stack count to a coin amount
			if(this:HasObjVar("StackCount")) then
				SetStack(this:GetObjVar("StackCount"))	    
			end
		else
			UpdateInfo(amounts)
		end
	end	
end

OverrideEventHandler("stackable",EventType.CreatedObject,"stack_created",
	function (success,objRef,stackAmounts,user)
		activeSplit = false

		if(IsInBank(this)) then
			local curValue = GetValue()
			local newStackValue = GetValue(stackAmounts)
			if(newStackValue > curValue) then
				user:SystemMessage("There is not enough coins in that coin purse.","info")
				objRef:Destroy()
			elseif(newStackValue == curValue) then
				this:Destroy()
			else
				--DebugMessage("TAKING FROM BANK "..curValue..", "..newStackValue..", new val in bank: "..curValue - newStackValue)
				AdjustStack(-newStackValue)
			end
		else
			local amounts = GetAmounts()
			for i,denomInfo in pairs(Denominations) do
				local coinsToTake = stackAmounts[denomInfo.Name] or 0
				if(coinsToTake > 0) then
					local coinCount = amounts[denomInfo.Name] or 0
					if(coinsToTake > coinCount) then
						user:SystemMessage("You do not have enough "..denomInfo.Name..".","info")				
						return					
					else
						amounts[denomInfo.Name] = coinCount - coinsToTake						
					end
				end
			end		
			local finalValue = GetValue(amounts)
			if(finalValue <= 0) then
				if(finalValue < 0) then
					DebugMessage("ERROR: Took more coins than we have!")
				end
				this:Destroy()
			else
				UpdateInfo(amounts)
			end
		end

		objRef:SendMessage("SetCoins",stackAmounts)
	end)

OverrideEventHandler("stackable",EventType.Message,"StackOnto",
	function (otherObj)
		if(not(pendingStack) and otherObj:IsValid() and otherObj:GetObjVar("ResourceType") == "coins" and otherObj ~= this) then					
			-- in bank we automatically change up
		    if(IsInBank(this)) then
		    	local amount = GetStackCount(otherObj)
		    	AdjustStack(amount)
		    	otherObj:Destroy("StackOntoAddCoins",GetStackCount(otherObj))
		    	pendingStack = true	
		    	DoChangeUp()		
		    -- otherwise just add the two sets of coins together
		    else
		    	local amounts = GetAmounts(otherObj)
		    	AddCoins(amounts)
		    	otherObj:Destroy("StackOntoAddCoins",amounts)
		    	pendingStack = true	
		    end
			
			this:PlayObjectSound("Drop",true)
		end
	end)

RegisterEventHandler(EventType.DestroyedObject, "StackOntoAddCoins",
	function (success,amounts)
		if not(success) then
			RemoveCoins(amounts)
		end
		this:PlayObjectSound("Drop",true)
		pendingStack = false	
	end)

-- UI

function OpenSplitWindow(user,fieldAmounts)	
	if(type(fieldAmounts) ~= "table") then
		fieldAmounts = {}
	end
	
	local amounts = GetAmounts()

	local highestDenom = 1
	for i,denomInfo in pairs(Denominations) do
		if((amounts[denomInfo.Name] or 0) > 0) then
			highestDenom = i
		end
	end

	local height = (highestDenom * 40) + 90
	local curY = 10

	local newWindow = DynamicWindow("StackSplit","Split Coins",280,height,-150,-height/2,"","Center")

	local i = highestDenom
	while(i > 0) do
		local denomInfo = Denominations[i]
		newWindow:AddLabel(20,curY+4,denomInfo.Color..denomInfo.Name.."[-]",0,0,18)
		newWindow:AddButton(20+130,curY+4,"Minus|"..denomInfo.Name,"",0,0,"","",false,"Previous")
		newWindow:AddTextField(20+147,curY,50,20,denomInfo.Name,fieldAmounts[denomInfo.Name] or "0")
		newWindow:AddButton(20+205,curY+4,"Plus|"..denomInfo.Name,"",0,0,"","",false,"Next")		
		curY = curY + 30
		i = i - 1
	end

	newWindow:AddButton(170,curY+8,"CreateStack|","Accept",0,0,"","",true)

	user:OpenDynamicWindow(newWindow,this)
end

OverrideEventHandler("stackable",EventType.DynamicWindowResponse,"StackSplit",
	function (user,buttonId,fieldData)
		local result = StringSplit(buttonId,"|")
		local action = result[1]
		local arg = result[2]
		if(action == "CreateStack") then
			local stackAmounts = {}

			for i,denomInfo in pairs(Denominations) do
				if(tonumber(fieldData[denomInfo.Name])) then
					local denomAmount = math.floor(tonumber(fieldData[denomInfo.Name]))
					if(denomAmount ~= nil and denomAmount > 0) then
						stackAmounts[denomInfo.Name] = denomAmount
					end
				end
			end
			if (not CanSplit(user)) then
				return 
			end
			if(CountTable(stackAmounts) > 0 and not(activeSplit)) then
				TrySplitCoins(stackAmounts,user)
			else
				user:SystemMessage("You need to take at least one coin.","info")
			end
		elseif(action == "Minus") then			
			local fieldVal = tonumber(fieldData[arg]) or 0
			if(fieldVal > 0) then
				fieldData[arg] = tostring(fieldVal - 1)
			end
			OpenSplitWindow(user,fieldData)
		elseif(action == "Plus") then
			local amounts = GetAmounts()
			local fieldVal = tonumber(fieldData[arg]) or 0
			if((fieldVal < (amounts[arg] or 0)) or IsInBank(this)) then
				fieldData[arg] = tostring(fieldVal + 1)
			end
			OpenSplitWindow(user,fieldData)
		end
	end)

function UpdateWeight(amounts)
	if(GetWeight(this) ~= -1) then
        local oldWeight = this:GetSharedObjectProperty("Weight")
        if (oldWeight ~= "1") then
            this:SetSharedObjectProperty("Weight", "1");
            return
        end
		-- amounts = amounts or GetAmounts()

		-- local singleWeight = ServerSettings.Misc.CoinWeight or 1
		-- local stackWeight = math.ceil(math.max(1,GetCoinCount(amounts)*singleWeight))
		-- if(this:GetSharedObjectProperty("Weight") ~= stackWeight) then
		-- 	this:SetSharedObjectProperty("Weight",stackWeight)
		-- end

		-- local newWeight = this:GetSharedObjectProperty("Weight")
		-- local adjustWeightBy = newWeight - oldWeight		
		-- if(adjustWeightBy ~= 0) then
		-- 	DebugMessage("Adjusted weight by "..adjustWeightBy)
		-- 	local containedObj = this:ContainedBy()
		-- 	if(containedObj ~= nil) then
		-- 		containedObj:SendMessage("AdjustWeight", adjustWeightBy)
		-- 	end
		-- end
	end
end