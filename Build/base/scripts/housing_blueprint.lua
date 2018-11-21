require 'incl_player_titles'
mFlip = false
selectedFacing = nil

function RequestPlacementLoc(user,previewTemplate)
	user:SystemMessage("[$1842]")
	local rotation = Loc(0,0,0)
	if (mFlip) then
		rotation = Loc(0,180,0)
	end
	user:RequestClientTargetLocPreview(this, "houseLoc",previewTemplate,rotation)	
end

function ValidateUse(user)
	if( user == nil or not(user:IsValid()) ) then
		return false
	end

	if( this:TopmostContainer() ~= user ) then
    	user:SystemMessage("[$1843]")
   		return false
    end

	if( not(IsGod(user)) and UserHasHouse(user) ) then
		user:SystemMessage("You already have a place you call home.")
		return false
	end

	return true
end

function ValidatePlacement(user,location,template,facingAngle)
	if(IsGod(user)) then return true end

	local bounds = GetHousePlot(template,location,facingAngle)
	if(bounds == nil) then
		DebugMessage("ERROR: House template does not contain bounds")
	end
	
	local housingRegion = GetRegion("Housing")	
	-- if this map has no valid housing region, fail
	if(housingRegion == nil) then
		user:SystemMessage("That is not a valid location to place a house.")
		return false
	end

	local noHousingRegion = GetRegion("NoHousing")
	if(noHousingRegion ~= nil and noHousingRegion:Intersects(bounds)) then
		user:SystemMessage("That is not a valid location to place a house.")
		RequestPlacementLoc(user,selectedFacing.TemplateName)
		return false
	end

	local waterRegion = GetRegion("Water")
	if(waterRegion ~= nil and waterRegion:Intersects(bounds)) then
		user:SystemMessage("That is not a valid location to place a house.")
		RequestPlacementLoc(user,selectedFacing.TemplateName)
		return false
	end

	-- if any of the four corners are in a no housing area, fail
	local pointsToCheck = bounds.Points
	table.insert(pointsToCheck,bounds.Center)
	for i,point in pairs(pointsToCheck) do
		if(not(housingRegion:Contains(point))) then 
			user:SystemMessage("That is not a valid location to place a house.")
			RequestPlacementLoc(user,selectedFacing.TemplateName)
			return false
		end
	end

	local success,reason = CheckBounds(bounds,true)
	if not(success) then
		user:SystemMessage("That is not a valid location to place a house.")
		RequestPlacementLoc(user,selectedFacing.TemplateName)
		return false
	end
	
	return true
end

function HandleUseTool(user,usedType)
	if (usedType:match("Build")) then
		if not(ValidateUse(user) ) then
			return
		end

		local blueprintInfo = this:GetObjVar("BlueprintInfo")
		if(usedType == "Build East Facing") then
			selectedFacing = blueprintInfo.East		
			mFlip = false
		elseif(usedType == "Build South Facing") then
			selectedFacing = blueprintInfo.South
			mFlip = false
		elseif(usedType == "Build West Facing") then
			selectedFacing = blueprintInfo.East		
			mFlip = true
		elseif(usedType == "Build North Facing") then
			selectedFacing = blueprintInfo.South
			mFlip = true
		end

		ClientDialog.Show{
		    TargetUser = user,
		    ResponseObj = this,
		    DialogId = "HousingWarning",
		    TitleStr = "Warning",
		    DescStr = "[$1845]",
		    Button1Str = "OK",
		    ResponseFunc = function(user,buttonId)
		    	--DebugMessage("A")
		    	RequestPlacementLoc(user,selectedFacing.TemplateName)
		    end
		}
	end
end

function HandleTargetResponse(success, targetLoc, targetObj, user)	
	-- validate target
	if( not(success) or not(ValidateUse(user)) ) then
		return
	end
	facing = Loc(0,0,0)
	local facingAngle = 0
	if (mFlip) then
		facing = Loc(0,180,0)
		facingAngle = 180
	end
	if not(selectedFacing == nil) and ValidatePlacement(user,targetLoc,selectedFacing.TemplateName,facingAngle) then
		local bounds = GetHousePlot(selectedFacing.TemplateName, targetLoc, facingAngle)

		local housePoints = {}
		housePoints[1] = bounds.Points[1]
		housePoints[2] = bounds.Points[2]
		housePoints[3] = bounds.Points[3]
		housePoints[4] = bounds.Points[4]
		local pointCenter = bounds.Center
		local houseBox = Box2(housePoints[1],housePoints[2],housePoints[3],housePoints[4])

		if (MoveMobiles(houseBox,targetLoc) ~= false) then
			CreateObjExtended(selectedFacing.TemplateName,nil, targetLoc,facing,Loc(1,1,1), "house_created",{User=user,Flip = mFlip, angle = facingAngle})
		end
	end
end

RegisterEventHandler(EventType.CreatedObject, "house_created",
	function (success,objRef,houseArgs)
		if(success) then
			houseArgs.HouseObj = objRef
			local flip = houseArgs.Flip or false

			objRef:SetObjVar("NoReset",true)			
			objRef:SetObjVar("IsHouse",true)
			--DFB TODO: When construction of houses is complete, do this when the house is fully built
			local lifetimeStats = this:TopmostContainer():GetObjVar("LifetimePlayerStats")
			lifetimeStats.HousesMade = (lifetimeStats.HousesMade or 0) + 1
			PlayerTitles.CheckTitleGain(this:TopmostContainer(),AllTitles.ActivityTitles.HouseBuilding,lifetimeStats.HousesMade)
			this:TopmostContainer():SetObjVar("LifetimePlayerStats",lifetimeStats)

			-- We have a house! now make the plot markers
			local houseLoc = objRef:GetLoc()
			local bounds = GetHousePlot(selectedFacing.TemplateName,houseLoc,objRef:GetFacing())
			for i,corner in pairs(bounds.Points) do
				-- we have to convert the corner from Loc2 to Loc
				CreateObj("house_plot_marker", Loc(corner), "plot_created", houseArgs)
			end

			-- Then make the sign (house controller) object
			if(selectedFacing.SignTemplate ~= nil) then
				local signLoc = houseLoc:Add(selectedFacing.SignLoc)
				if (flip) then
					signLoc = houseLoc:Add(Loc(-selectedFacing.SignLoc.X,selectedFacing.SignLoc.Y,-selectedFacing.SignLoc.Z))
				end
				local signRot = Loc(0,selectedFacing.SignRot or 0,0)

				if (flip) then
				--DebugMessage("Getting here also")
					signRot = signRot:Add(Loc(0,180,0))
				end

				local signScale = Loc(1,1,1)
				--DebugMessage("Sign: "..tostring(signLoc))
				
				CreateObjExtended(selectedFacing.SignTemplate, nil, signLoc, signRot, signScale, "sign_created", houseArgs)
			end

			-- Clear all the trees
			local treesInBounds = GetTreesInBounds(bounds)
			for i,objRef in pairs(treesInBounds) do
				objRef:SetVisualState("Hidden")
			end
		end
	end)


RegisterEventHandler(EventType.CreatedObject, "plot_created",
	function (success,objRef,houseArgs)
		if(success) then
			objRef:SetObjVar("NoReset",true)
			objRef:SetObjVar("HouseObject",houseArgs.HouseObj)
		end
	end)

RegisterEventHandler(EventType.CreatedObject, "sign_created",
	function (success,objRef,houseArgs)
		if(success) then
			-- We have a sign! so make the door object so we can pass it along to the house control script
			local houseLoc = houseArgs.HouseObj:GetLoc()
			local flip = houseArgs.Flip or false
			local doorLoc = houseLoc:Add(selectedFacing.DoorLoc)

			if (flip) then
				doorLoc = houseLoc:Add(Loc(-selectedFacing.DoorLoc.X,selectedFacing.DoorLoc.Y,-selectedFacing.DoorLoc.Z))
			end

			local doorRot = Loc(0,selectedFacing.DoorRot or 0,0)

			if (flip) then
				doorRot = doorRot:Add(Loc(0,180,0))
			end

			local doorScale = Loc(1,1,1)

			objRef:SetObjVar("NoReset",true)
			
			houseArgs.SignObj = objRef
			CreateObjExtended(selectedFacing.DoorTemplate, nil, doorLoc, doorRot, doorScale, "door_created", houseArgs)
		end
	end)

RegisterEventHandler(EventType.CreatedObject, "door_created",
	function (success,objRef,houseArgs)
		if(success) then 
			-- now that we have a door, we can initialize the sign (house control)
			houseArgs.DoorObj = objRef
			objRef:SetObjVar("HouseObject",houseArgs.HouseObj)
			objRef:SetObjVar("NoReset",true)
			houseArgs.SignObj:SendMessage("Initialize",houseArgs)
			--this is the last thing to be created so we destroy it here.
			this:Destroy()
		end
	end)

RegisterEventHandler(EventType.Message, "UseObject", HandleUseTool)
RegisterEventHandler(EventType.ClientTargetLocResponse, "houseLoc", HandleTargetResponse)

function Initialize()
	this:SetObjVar("BlueprintInfo",initializer.BlueprintInfo)

	AddUseCase(this,"Build East Facing",false,"HasObject")
	AddUseCase(this,"Build South Facing",false,"HasObject")
	AddUseCase(this,"Build North Facing",false,"HasObject")
	AddUseCase(this,"Build West Facing",false,"HasObject")
	SetTooltipEntry(this,"[$1846]")
end

if(initializer ~= nil) then
	Initialize()
end
