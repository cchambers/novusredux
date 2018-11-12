MAX_HIRELING_COUNT = 1

function GetHirelings(user)
	local hirelings = user:GetObjVar("Hirelings") or {}
	local activeHirelings = {}
	for i,hirelingObj in pairs(hirelings) do
		if(hirelingObj ~= nil and hirelingObj:IsValid() and hirelingObj:GetObjVar("HirelingOwner") == user) then
			table.insert(activeHirelings,hirelingObj)
		end
	end

	return activeHirelings
end

function CanAddHireling(user)
	local hirelings = GetHirelings(user)
	return #hirelings < MAX_HIRELING_COUNT
end

function AddHireling(user,hirelingObj)
	if not(CanAddHireling(user)) then return false end

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