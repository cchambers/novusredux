MAX_HIRELING_COUNT = 1

function GetHirelings(user)
	local hirelings = user:GetObjVar("Hirelings") or {}
	local activeHirelings = {}
	local hasMerchant = false
	for i,hirelingObj in pairs(hirelings) do
		if(hirelingObj ~= nil and hirelingObj:IsValid() and hirelingObj:GetObjVar("HirelingOwner") == user) then
			if(hirelingObj:GetObjVar("ShopLocation")) then
				hasMerchant = true
			else
				table.insert(activeHirelings,hirelingObj)
			end
		end
	end

	return activeHirelings, hasMerchant
end

function CanAddHireling(user, isMerchant)
	local hirelings, hasMerchant = GetHirelings(user)
	-- can only have one hired merchant at a time
	if(isMerchant and hasMerchant) then
		return false
	end
	return #hirelings < MAX_HIRELING_COUNT
end

function AddHireling(user,hirelingObj, isMerchant)
	if not(CanAddHireling(user, isMerchant)) then return false end

	local hirelings = GetHirelings(user)

	table.insert(hirelings,hirelingObj)
	user:SetObjVar("Hirelings",hirelings)
	hirelingObj:SetObjVar("HirelingOwner",user)
	user:SetObjVar("NoReset",true)

	return true
end

function GetHirelingOwner(hirelingObj)
	return hirelingObj:GetObjVar("HirelingOwner")
end

function ReleaseHireling(hirelingObj)
	local owner = GetHirelingOwner(hirelingObj)
	if(owner ~= nil and owner:IsValid()) then
		local hirelings = GetHirelings(owner)
		RemoveFromArray(hirelings, hirelingObj)
		if(#hirelings > 0) then
			owner:SetObjVar("Hirelings",hirelings)
		else
			owner:DelObjVar("Hirelings")
		end
	end
	hirelingObj:DelObjVar("HirelingOwner")
end

function IsHiredMerchant(owner,hirelingObj)
	if (GetHirelingOwner(hirelingObj) ~= owner) then
		return false
	end

	if not(hirelingObj:HasObjVar("ShopLocation")) then
		return false
	end

	return true
end