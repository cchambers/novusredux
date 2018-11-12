function GetAmounts(objRef)
	if ( objRef ~= nil ) then
		LuaDebugCallStack("nil objRef provided to GetAmounts")
	end

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

function GetLowestDenomination()
	local lowestDenom = Denominations[1]
	if (not(lowestDenom) or lowestDenom.Value ~= 1) then
		DebugMessage("ERROR: coins do not have single unit denomination")
		return nil
	end	

	return lowestDenom
end

function GetDenominationsDescending()
    local reversedTable = {}
    local itemCount = #Denominations
    for i, denomInfo in ipairs(Denominations) do
        reversedTable[itemCount + 1 - i] = denomInfo
    end
    return reversedTable
end

function GetAmountStr(amounts,includeLowerDenom,stripcolor)
	amounts = amounts or GetAmounts()

	local resultStr = ""
	local start = false
	for i,entry in pairs(GetDenominationsDescending()) do
		if((includeLowerDenom and start) or (amounts[entry.Name] and amounts[entry.Name] ~= 0)) then
			local colorBegin = (stripcolor and "" or entry.Color)
			local colorEnd = (stripcolor and "" or "[-]")
			-- we want 0s after the first no zero coin
			start = true
			local val = amounts[entry.Name] or 0
			resultStr = resultStr .. colorBegin.. tostring(val) .. " " .. entry.Name:lower() .. colorEnd..", "
		end
	end

	return StripTrailingComma(resultStr)
end

-- uses the Abbrev
function GetAmountStrShort(amounts,includeLowerDenom)
	amounts = amounts or GetAmounts()

	local resultStr = ""
	local start = false
	for i,entry in pairs(GetDenominationsDescending()) do
		if((includeLowerDenom and start) or (amounts[entry.Name] and amounts[entry.Name] ~= 0)) then
			-- we want 0s after the first no zero coin
			start = true
			local val = amounts[entry.Name] or 0
			resultStr = resultStr .. tostring(val) .. entry.Abbrev:lower() .. ", "
		end
	end

	return StripTrailingComma(resultStr)
end

function ChangeUp(amounts)
	for i,denomInfo in pairs(Denominations) do
		local nextDenomInfo = Denominations[i+1]
		if(amounts[denomInfo.Name] ~= nil and nextDenomInfo ~= nil) then
			local curAmount = amounts[denomInfo.Name]			
			local nextValue = nextDenomInfo.Value
			local ratio = nextValue / denomInfo.Value
			local nextAmount = math.floor(curAmount/ratio)
			if(nextAmount > 0) then
				amounts[nextDenomInfo.Name]	= (amounts[nextDenomInfo.Name] or 0) + nextAmount
				amounts[denomInfo.Name] = curAmount % ratio
			end
		end
	end
	
	return amounts
end

function ValueToAmounts(value)
	local lowestDenom = GetLowestDenomination()
	if not(lowestDenom) then return end		

	local amounts = {}
	amounts[lowestDenom.Name] = value

	return ChangeUp(amounts)
end

function ValueToAmountStr(value,includeLowerDenom,stripcolor)
	return GetAmountStr(ValueToAmounts(value),includeLowerDenom,stripcolor)
end