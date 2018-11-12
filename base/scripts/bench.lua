function UpdateBenchTable()
	local thisLoc = this:GetLoc():Project(this:GetFacing()+90,0.5)
	local left = this:GetLoc():Project(this:GetFacing()-90,0.5)
	local right = this:GetLoc():Project(this:GetFacing()+90,2)

	local benchTable = {}

	for i=1,3 do
		local seatTable = {}
		if (i == 1) then
			seatTable.Location = left
		end
		if (i == 2) then
			seatTable.Location = thisLoc
		end
		if (i == 3) then
			seatTable.Location = right
		end
		seatTable.facing = this:GetFacing() + 180
		table.insert(benchTable,seatTable)
	end
	this:SetObjVar("SeatTable",benchTable)
end

function GetNearestSitLocation(loc)
	local seatTable = this:GetObjVar("SeatTable") or {}
	local lastDistance = 9999
	local closestSeat = nil
	for i,j in pairs(seatTable) do
		local distance = j.Location:Distance(loc)
		if (distance < lastDistance) then
			lastDistance = distance
			closestSeat = j.Location
		end
	end
	return closestSeat
end

function useBench(user,sitLoc)	
	AddUseCase(user, "Stand", false, "IsSelf")
	user:SetObjVar("PositionBeforeUsing",user:GetLoc())
	user:SetWorldPosition(sitLoc)
	user:SetFacing(this:GetFacing()+180)
	user:SendMessage("SitInChair")
end

RegisterEventHandler(EventType.Message, "UseObject", 
function (user,usedType)	
	if(usedType ~= "Sit") then return end
	UpdateBenchTable()
	--DebugMessage("Using bed")
	if (user == nil) then
		return
	end

	if not( user:IsValid() ) then
		return
	end	

	if (not user:HasLineOfSightToObj(this,0)) then
		return
	end

	local sitLoc = GetNearestSitLocation(user:GetLoc())

	if (sitLoc == nil or (FindObject(SearchMulti({SearchRange(sitLoc,0.5),SearchMobile()})) ~= nil) ) then
		user:SystemMessage("You cannot sit there as that seat is occupied.")
		return
	end

	--use the bed
	if (IsSitting(user)) then
		--DebugMessage("StopSitting")
		user:SendMessage("StopSitting")
		user:SetWorldPosition(user:GetObjVar("PositionBeforeUsing"))
		RemoveUseCase(user, "Stand")
	else
		--DebugMessage("useChair")
		user:SystemMessage("[$1732]")
		useBench(user,sitLoc)
	end
end)

RegisterSingleEventHandler(EventType.ModuleAttached, "bench",
	function()
		UpdateBenchTable()
        AddUseCase(this,"Sit",true)
	end)