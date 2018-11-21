function GetHousePlot(template, location, angle)
	local bounds = GetTemplateObjectBounds(template)
	--DebugMessage(DumpTable(bounds))
	if(bounds == nil or #bounds == 0 ) then
		return nil
	end
	--DFB NOTE: This only takes the first bounds, if we want more object bounds later we have to change it
	bounds = bounds[1]

	if (angle) then
		bounds = bounds:Rotate(angle)
	end
	--DebugMessage(bounds:Add(location):Flatten())
	return bounds:Add(location):Flatten()
end

function GetHouseInterior(template, location)
	local bounds = GetTemplateRoofBounds(template)
	--DebugMessage(DumpTable(bounds))
	if(bounds == nil or #bounds == 0 ) then
		return nil
	end

	interior = {}
	for i,boundsEntry in pairs(bounds) do
		table.insert(interior,boundsEntry:Add(location):Flatten())
	end

	--DebugMessage(bounds:Add(location):Flatten())
	return interior
end

function GetUserHouse(user)
	local userId = user:GetAttachedUserId()
	if(userId) then
		local housingRecordId = user:GetAttachedUserId() .. ".Housing"
	 	local housingRecord = GlobalVarRead(housingRecordId)
	 	if(housingRecord ~= nil and housingRecord.Owned ~= nil and #housingRecord.Owned > 0) then
	 		return housingRecord.Owned[1].HouseObj
	 	end
	end
end

function UserHasHouse(user)
	return GetUserHouse(user) ~= nil
end

function SetUserHouse(user,house,region)
	region = region or GetRegionAddress()
	local newEntry = {HouseObj=house,Region=region} 

	local housingRecordId = user:GetAttachedUserId() .. ".Housing"
	GlobalVarWrite(housingRecordId,nil,
		function (record)
			if(record.Owned == nil) then
				record.Owned = {newEntry}
			else
				table.insert(record.Owned,newEntry)
			end
			return true
		end)
end

function GetHousePlot(template, location, angle)
	local bounds = GetTemplateObjectBounds(template)
	--DebugMessage(DumpTable(bounds))
	if(bounds == nil or #bounds == 0 ) then
		return nil
	end
	--DFB NOTE: This only takes the first bounds, if we want more object bounds later we have to change it
	bounds = bounds[1]

	if (angle) then
		bounds = bounds:Rotate(angle)
	end
	--DebugMessage(bounds:Add(location):Flatten())
	return bounds:Add(location):Flatten()
end

function GetHouseControlPlot(houseControlObj)
	local houseObj = houseControlObj:GetObjVar("HouseObject")
	if(houseObj == nil or not(houseObj:IsValid())) then return nil end

	local houseTemplate = houseObj:GetCreationTemplateId()
	return GetHousePlot(houseTemplate,houseObj:GetLoc(),houseObj:GetFacing())
end

function GetHouseControlInterior(houseControlObj)
	local houseObj = houseControlObj:GetObjVar("HouseObject")
	if(houseObj == nil or not(houseObj:IsValid())) then return nil end

	local houseTemplate = houseObj:GetCreationTemplateId()
	return GetHouseInterior(houseTemplate,houseObj:GetLoc())
end

function GetNearbyHouses(targetLoc,range)
	range = range or 30
	return FindObjects(SearchMulti({SearchRange(targetLoc, range),SearchModule("house_control")}),GameObj(0))
end

function IsObjInHouse(targetObj)
	return GetContainingHouseForObj(targetObj) ~= nil
end

function HasHouseAtLoc(targetLoc)
	return GetContainingHouseForLoc(targetLoc) ~= nil
end

function GetContainingHouseForObj(targetObj)
	local worldObj = targetObj:TopmostContainer() or targetObj

	return GetContainingHouseForLoc(worldObj:GetLoc())
end

function GetContainingHouseForLoc(targetLoc)
	local nearbyHouses = GetNearbyHouses(targetLoc)
	if(#nearbyHouses > 0) then
		for i,houseControlObj in pairs(nearbyHouses) do
			if(IsLocInHouse(houseControlObj,targetLoc)) then
				return houseControlObj
			end
		end
	end

	return nil
end

function IsObjInHouse(houseControlObj,targetObj)
	local worldObj = targetObj:TopmostContainer() or targetObj

	return IsLocInHouse(houseControlObj,worldObj:GetLoc())
end

function IsLocInHouse(houseControlObj,targetLoc)
	local housePlot = GetHouseControlPlot(houseControlObj)	
	if(housePlot == nil) then
		LuaDebugCallStack("ERROR: Control obj has no plot! " .. tostring(houseControlObj))
		return
	end
	return housePlot:Contains(targetLoc)		
end

function IsObjInInterior(houseControlObj,targetObj)
	local worldObj = targetObj:TopmostContainer() or targetObj

	return IsLocInInterior(houseControlObj,worldObj:GetLoc())
end

function IsLocInInterior(houseControlObj,targetLoc)
	local houseInteriorArray = GetHouseControlInterior(houseControlObj)	
	if(houseInteriorArray == nil) then
		LuaDebugCallStack("ERROR: Control obj has no interior! " .. tostring(houseControlObj))
		return
	end

	for i,bounds in pairs(houseInteriorArray) do
		if(bounds:Contains(targetLoc)) then
			return true
		end
	end

	return false
end

function IsHouseOwner(user,houseControlObj)	
	return GetHouseOwner(houseControlObj) == user
end

function GetHouseOwner(houseControlObj)
	if(houseControlObj ~= nil 
			and houseControlObj:IsValid()) then
		return houseControlObj:GetObjVar("Owner")
	end
end

function IsHouseOwnerForLoc(user,targetLoc)
	local containedHouse = GetContainingHouseForLoc(targetLoc)

	return IsHouseOwner(user,containedHouse)
end

function IsHouseLocked(houseControlObj)
	if(houseControlObj == nil or not(houseControlObj:IsValid())) then
		return false
	end

	local doorObj = houseControlObj:GetObjVar("DoorObject")
	return doorObj ~= nil and doorObj:IsValid() and doorObj:GetObjVar("locked")
end

function GetTreesInBounds(bounds)
	if(bounds == nil) then
		LuaDebugCallStack("ERROR: Bounds is nil")
		return {}
	end

	local searcher = PermanentObjSearchSharedStateEntry("ResourceSourceId","Tree")
	local nearbyTrees = FindPermanentObjects(searcher)
	local treesInBounds = {}
	for i,objRef in pairs(nearbyTrees) do		
		if(bounds:Contains(objRef:GetLoc())) then
			table.insert(treesInBounds,objRef)
		end
	end

	return treesInBounds
end

function LockDownObject(targetObj)
	if(targetObj:HasModule("hireling_merchant_sale_item")) then
		return
	end
	if (targetObj:HasObjVar("DisableLockDown")) then
		return 
	end
	targetObj:SetObjVar("LockedDown",true)
	targetObj:SetObjVar("NoReset",true)
	SetTooltipEntry(targetObj,"locked_down","Locked Down",98)

	if(targetObj:DecayScheduled()) then	
		targetObj:RemoveDecay()
	end
	local containedObjects = targetObj:GetContainedObjects()
	for i,j in pairs(containedObjects) do
		if (j:DecayScheduled()) then
			j:RemoveDecay()
		end
	end
end

function ReleaseObject(targetObj)
	if(targetObj:HasObjVar("LockedDown")) then
		targetObj:DelObjVar("LockedDown")
		targetObj:DelObjVar("NoReset")
		RemoveTooltipEntry(targetObj,"locked_down")
		Decay(targetObj)

		if(targetObj:HasModule("hireling_merchant_sale_item")) then
			targetObj:SendMessage("RemoveFromSale")
		end

		local saleItem = FindItemsInContainerRecursive(targetObj, 
			function(item)
				return ( item:HasModule("hireling_merchant_sale_item") )
			end)

		for key,value in pairs(saleItem) do
			if (value:HasModule("hireling_merchant_sale_item")) then
				value:SendMessage("RemoveFromSale")
			end
		end
	end
end

function DeleteGlobalHouseRecord(ownerUserId, houseObj, resultEventId)
	-- update the global record before destorying the control obj
	local housingRecordId = ownerUserId .. ".Housing"
	GlobalVarWrite(housingRecordId,resultEventId,
		function (record)
			if(record.Owned == nil) then return end
			
			local newOwned = {}			
			for i,houseEntry in pairs(record.Owned) do
				if(houseEntry.HouseObj ~= houseObj) then
					table.insert(newOwned,houseEntry)
				end
			end

			local updated = #newOwned ~= record.Owned
			if(updated) then
				record.Owned = newOwned					
			end			

			return updated
		end)
end

function TransferHouseOwnership(user,houseObj,newOwner)
	if not(IsGod(user)) then
		houseObj = GetUserHouse(user)
		if not(houseObj) then
			return false,"NotFound"
		end
	end

	-- validate new owner can take a house
	if(not(IsGod(newOwner)) and UserHasHouse(newOwner)) then
		return false,"AlreadyOwner"
	end

	local oldOwnerUserId = houseObj:GetObjVar("OwnerUserId")
	
	local newOwnerName = newOwner:GetName()
	houseObj:SetObjVar("Owner",newOwner)
	houseObj:SetObjVar("OwnerName",newOwnerName)
	houseObj:SetObjVar("OwnerUserId",newOwner:GetAttachedUserId())
	
	-- Update old global var
	DeleteGlobalHouseRecord(oldOwnerUserId, houseObj)

	-- Create new house key
	houseObj:SendMessage("RekeyHouse",newOwner,true)

	-- Rename house sign + owner tooltip
	SetTooltipEntry(houseObj,"house_control_owner", "Owner: "..newOwnerName)
	
	SetUserHouse(newOwner,houseObj)

	return true	
end

function MoveMobiles(box, targetLoc)
	local nearbyMobile = FindObjects(SearchMulti({SearchRect(box),SearchMobile()}),GameObj(0))
	local finalLocation = nil
	local playersLocTable = {}

	for i,nearbyMobileObj in pairs(nearbyMobile) do
		if (nearbyMobileObj ~= nil) then
			local mobileLocation = nearbyMobileObj:GetLoc()
			local houseControlObj = GetContainingHouseForObj(nearbyMobileObj)
			local isInInterior = nil
			local closestPointTable = {}

			for key,value in pairs(box.Points) do
				local point = {}
				local pointDistance = mobileLocation:DistanceSquared(Loc(value))

				table.insert(point,value)
				table.insert(point,pointDistance)
				table.insert(closestPointTable, point)
			end

			local finalClosestPoint = CheckClosestBound(nearbyMobileObj, closestPointTable, 1)
			
			if (houseControlObj ~= nil) then
				isInInterior = IsLocInInterior(houseControlObj,targetLoc)
			end

			if (nearbyMobileObj:IsUser()) then
				finalClosestPoint = TryRelocateRecursive(mobileLocation, 1, box, isInInterior, houseControlObj, closestPointTable, nearbyMobileObj, 1)

				if (finalClosestPoint == nil) then
					return false
				end
				local playersLocTemp = {}
				table.insert(playersLocTemp, nearbyMobileObj)
				table.insert(playersLocTemp, finalClosestPoint)
				table.insert(playersLocTable, playersLocTemp)
			else
				local following = nearbyMobileObj:GetObjVar("controller") or nearbyMobileObj:GetObjVar("MySuperior") or nearbyMobileObj:GetObjVar("FollowTarget")
				if (following ~= nil) then
					local nearbyLoc = GetNearbyPassableLocFromLoc(following:GetLoc(),1,4)
					if (nearbyLoc == nil or (
						houseControlObj ~= nil and
						(
							(isInInterior == true and not(IsLocInInterior(houseControlObj, nearbyLoc))) 
							or (isInInterior == false and IsLocInInterior(houseControlObj, nearbyLoc)))
						)
					) then
						DebugMessage("Failed to get a passable location for pets or followers")
						nearbyLoc = following:GetLoc()
					end
					nearbyMobileObj:SetWorldPosition(nearbyLoc)
				else
					if not(IsPassable(finalClosestPoint)) then
						finalClosestPoint = TryRelocateRecursive(mobileLocation, 1, box, isInInterior, houseControlObj, closestPointTable, nearbyMobileObj, -1)
					end

					if (finalClosestPoint == nil) then
						nearbyMobileObj:Destroy()
					else
						nearbyMobileObj:SetWorldPosition(finalClosestPoint)
					end
				end
			end
		end
	end

	for key,value in pairs(playersLocTable) do
		value[1]:SetWorldPosition(value[2])
		DoUnstick(value[1], box)
	end

	return true

end

function DoUnstick(user, box)
	--teleport pets and followers

	local objsToTeleport = user:GetOwnedObjects() or {}

	for i, follower in pairs(objsToTeleport) do
		if (follower ~= user and follower:IsValid() and follower:IsMobile()) then
			local nearbyLoc = GetNearbyPassableLocFromLoc(user:GetLoc(),1,4)
			if(nearbyLoc == nil or box:Contains(nearbyLoc)) then
				DebugMessage("Failed to get a passable location for pets or followers")
				nearbyLoc = user:GetLoc()
			end
			follower:SetWorldPosition(nearbyLoc)
		end
	end
end

function TryRelocateRecursive(location, try, box, isInInterior, houseControlObj, closestPointTable, user, currentIndex)
	if (try > 10) then
		if (currentIndex >= 0 and currentIndex < 4) then
			DebugMessage("Failed to move mobile after placing object (Tried 10 times). Trying with other closest bound.")
			local closestPoint = CheckClosestBound(user, closestPointTable, currentIndex + 1)
			local newLocation = TryRelocateRecursive(closestPoint, 1, box, isInInterior, houseControlObj, closestPointTable, user, currentIndex + 1)
			return newLocation
		else
			DebugMessage("Failed to move mobile after building house.")
			return nil
		end
	end

	local newLocation = GetNearbyPassableLocFromLoc(location,2,4)

	if (box:Contains(newLocation)) then
		newLocation = TryRelocateRecursive(location, try + 1, box, isInInterior, houseControlObj, closestPointTable, user, currentIndex)
	elseif houseControlObj ~= nil and ((isInInterior == true and not(IsLocInInterior(houseControlObj, newLocation))) 
		or (isInInterior == false and IsLocInInterior(houseControlObj,newLocation))) then
		newLocation = TryRelocateRecursive(location, try + 1, box, isInInterior, houseControlObj, closestPointTable, user, currentIndex)
	elseif not(IsPassable(newLocation)) then
		newLocation = TryRelocateRecursive(location, try + 1, box, isInInterior, houseControlObj, closestPointTable, user, currentIndex)
	end

	return newLocation
end

function CheckClosestBound(user, closestPointTable, currentIndex)
	local userLoc = user:GetLoc()
	local closestPointX = Loc(closestPointTable[currentIndex][1].X,userLoc.Y,userLoc.Z)
	local closestPointZ = Loc(userLoc.X, userLoc.Y, closestPointTable[currentIndex][1].Z)

	if (userLoc:DistanceSquared(closestPointX) < userLoc:DistanceSquared(closestPointZ)) then
		return closestPointX
	else
		return closestPointZ
	end
end