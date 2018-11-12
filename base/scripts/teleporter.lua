USE_RANGE = 2
dismissDialogOpen = false
function DoTeleport(user,targetLoc,destRegionAddress)
	local hirelings = user:GetObjVar("Hirelings")
	if (hirelings ~= nil) then
		if (dismissDialogOpen == true) then return end
		local escort = nil
		for i, j in pairs(hirelings) do
			if (j:HasModule("ai_escort")) then
				EscortDismissDialog(user, j, targetLoc, destRegionAddress)
				return
			end
		end
	end

	TeleportUser(this,user,targetLoc,destRegionAddress)
end

--If player has escort, let them know entering portal will dismiss escort
function EscortDismissDialog(user, escort, targetLoc, destRegionAddress)
	dismissDialogOpen = true
	ClientDialog.Show
	{
	    TargetUser = user,
	    TitleStr = "Confirm Dismiss",
	    DescStr = "Entering a portal will dismiss your escort. Are you sure you want to do this?",
	    Button1Str = "Confirm",
	    Button2Str = "Cancel",
	    ResponseObj = this,
	    ResponseFunc = function (user,buttonId)
	    	if (buttonId == 1) then 
	    		dismissDialogOpen = false
	    		return
	    	end
	    	if (buttonId == 0) then
	    		escort:SendMessage("EndEscortDiversion")
	    		if not (IsDead(user)) then
					TeleportUser(this,user,targetLoc,destRegionAddress)
				end
	    	end
    		dismissDialogOpen = false
		end,
	}
end

function ActivateTeleporter(user)	
	if ( GetKarmaLevel(GetKarma(user)).GuardHostilePlayer and this:GetObjVar("Summoner") ~= nil) then
		user:SystemMessage("You must attone for your negative actions before the gods will allow you to do this.","info")
		EndMobileEffect(root)
		return false
	end

	local newTime = ServerTimeSecs()
	if (this:HasObjVar("CannotUseInCombat")) then
		--[[
    	local OffensiveAttackers = user:GetObjVar("OffensiveAttackers") or {}
    	for i,j in pairs(OffensiveAttackers) do
    		if (i:IsValid() and (not IsDead(i)) and (newTime - OffensiveAttackers[i] <= CRIMINAL_ATTACK_TIMEOUT)) then
    			user:SystemMessage("[$2632]")
    			return
    		end
    	end]]
    end

	local carriedObject = user:CarriedObject()
	if (carriedObject ~= nil) then
		user:SystemMessage("You can't carry objects through a portal.")
		return
	end

	if (this:DistanceFrom(user) > USE_RANGE and this:GetObjVar("Summoner")) then return end

	local keyTemplate = this:GetObjVar("KeyTemplate")
	if( keyTemplate ~= nil and not(IsImmortal(user))) then
		local found = false
		local backpackObj = user:GetEquippedObject("Backpack")
	    if( backpackObj ~= nil ) then		    			    
	    	local packObjects = backpackObj:GetContainedObjects()
	    	for index, packObj in pairs(packObjects) do	    		
	    		if( packObj:GetCreationTemplateId() == keyTemplate ) then
	    			found = true
	    		end
   			end
   		end

		if not(found) then
			user:SystemMessage("[$2633]")
			return
		else
			--DFB HACK: Send a message to update the quest system for the starting portal
			user:SendMessage("QuestUpdate")
		end
	end

	local requiredObjVar = this:GetObjVar("RequiredObjVar") 
	if (requiredObjVar ~= nil and not user:HasObjVar(requiredObjVar) and not(IsImmortal(user)) ) then
		user:SystemMessage(this:GetObjVar("InvalidUseMessage") or "The portal fails to respond to your presence.")
		this:SendMessage("TeleportFailEventMessage",user)
		return
	end

	local requiredQuestState = this:GetObjVar("QuestTaskRequired")
	if (requiredQuestState ~= nil and not IsImmortal(user)) then
		local questArgs = StringSplit(requiredQuestState,"|")
		local questName = questArgs[1]
		local questTaskComplete = questArgs[2]
		--DebugMessage("----------------------------------------------")
		--DebugMessage(questName,questTaskComplete)
		if (questArgs ~= nil and not HasFinishedQuestTask(user,questName,questTaskComplete)) then
			user:SystemMessage("The portal's magic forbids you from using it yet.")
			return
		end
	end

	local teleType = this:GetObjVar("Type")
	if( teleType ~= nil ) then
		local matchingTeleporters = FindObjects(SearchObjVar("Type",teleType),this)
		if( #matchingTeleporters > 0 ) then
			targetObj = matchingTeleporters[math.random(1,#matchingTeleporters)]
			DoTeleport(user,targetObj:GetLoc())			
			return
		end
	end

	local destLoc = this:GetObjVar("Destination")
	if (type(destLoc) == "string") then
		destLoc = Loc.ConvertFrom(destLoc) 
	end

	if( destLoc ~= nil ) then
		DoTeleport(user,destLoc,this:GetObjVar("RegionAddress"))
		return
	end

	user:SystemMessage(this:GetObjVar("InvalidUseMessage") or "The portal fails to respond to your presence.")
end

--[[function DoMobTeleport(target)
	if (target == nil or not target:IsValid()) then return end
	if (target:HasTimer("TeleportDelay")) then return end
	target:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"TeleportDelay")
	--DebugMessage("Teleporting "..target:GetName())
	--DFB NOTE: Teleporting mobs across regions isn't supported yet.
	local destination = this:GetObjVar("Destination")
	--DebugMessage(tostring(destination).." is Destination and the type is "..type(destination))
	if (type(destination) == "string") then
		destination = Loc.ConvertFrom(destination) 
	end
	if (this:GetObjVar("RegionAddress") ~= nil) then
		return 
	end
	if not(this:HasObjVar("NoTeleportEffect")) then
		target:PlayEffect("TeleportToEffect")						
		target:PlayObjectSound("Teleport")
	end
	if (this:GetObjVar("Type") ~= nil) then
		local matchingTeleporters = FindObjects(SearchObjVar("Type",this:GetObjVar("Type")),this)
		if( #matchingTeleporters > 0 ) then
			targetObj = matchingTeleporters[math.random(1,#matchingTeleporters)]
			--DebugMessage("location is "..tostring(targetObj:GetLoc()).." targetObj is "..targetObj:GetName())
			target:SetWorldPosition(targetObj:GetLoc())		
		end
		target:PlayEffect("TeleportFromEffect")	
	else
		target:SetWorldPosition(destination)	
		target:PlayEffect("TeleportFromEffect")	
	end
	local destFacing = this:GetObjVar("DestinationFacing")	
	if( destFacing ~= nil ) then
		target:SetFacing(destFacing)
	end
end--]]

local curGotoRegion = GetRegionAddress()
local curGotoWorld = GetWorldName()

function GetAllLocations(worldName)
	local allLocs = {}
	local defaultLocs = MapLocations[worldName] or {}
	for name, loc in pairs(defaultLocs) do
		table.insert(allLocs,{Name=name,Loc=loc})
	end

	return allLocs
end

function ShowSetDestinationWindow(user)
	-- DAB TODO: Allow user to set edit level
	if not(IsGod(user)) then
		return
	end

	local newWindow = DynamicWindow("SetDestination","Set Destination",450,300)	

	newWindow:AddLabel(20, 10, "[F3F781]Destination[-]",600,0,18,"left",false)
	local destination = this:GetObjVar("Destination")
	newWindow:AddLabel(20, 43, "[F3F781]X:[-]",600,0,18,"left",false)
	newWindow:AddTextField(40, 40, 100, 20,"DestXValue", destination and tostring(destination.X) or "")
	newWindow:AddLabel(150, 43, "[F3F781]Y:[-]",600,0,18,"left",false)
	newWindow:AddTextField(170, 40, 100,20, "DestYValue", destination and tostring(destination.Y) or "")
	newWindow:AddLabel(280, 43, "[F3F781]Z:[-]",600,0,18,"left",false)
	newWindow:AddTextField(300, 40, 100, 20,"DestZValue", destination and tostring(destination.Z) or "")

	newWindow:AddLabel(20, 83, "[F3F781]RegionAddress:[-]",600,0,18,"left",false)
	newWindow:AddTextField(140, 80, 240, 20,"RegionAddress", this:GetObjVar("RegionAddress") or "")

	newWindow:AddImage(10,120,"Divider",380,1,"Sliced")
	
	newWindow:AddLabel(20, 138, "[F3F781]Type:[-]",600,0,18,"left",false)
	newWindow:AddTextField(80, 135, 300, 20,"Type", this:GetObjVar("Type") or "")
	newWindow:AddLabel(20, 170, "[$2634]",380,200,18,"left",false)

	newWindow:AddButton(15, 215, "SelectDest", "Select Destination", 200, 23, "", "", false,"")
	newWindow:AddButton(215, 215, "Save", "Save", 200, 23, "", "", false,"")

	user:OpenDynamicWindow(newWindow,this)
end

function ShowSelectDestination(user)
	local newWindow = DynamicWindow("SetDestination","Set Destination",450,350)	

	local regionStr = curGotoRegion .. " - " .. curGotoWorld
	if(curGotoRegion == GetRegionAddress()) then
		regionStr = regionStr .. " (Current)"
	end
	newWindow:AddLabel(20,10,"Region: "..regionStr,0,0,18)
	newWindow:AddImage(10,35,"Divider",380,1,"Sliced")
	
	local allLocs = GetAllLocations(curGotoWorld)

	local scrollWindow = ScrollWindow(20,40,380,200,25)
	for i,locInfo in pairs(allLocs) do
		local scrollElement = ScrollElement()	
		scrollElement:AddButton(10, 0, "Select|"..i, locInfo.Name, 360, 25, "", "", false,"List")
		scrollWindow:Add(scrollElement)
	end
	newWindow:AddScrollWindow(scrollWindow)
	
	-- Change Region
	newWindow:AddButton(115, 248, "ChangeRegion", "Change Region", 200, 23, "", "", false,"")

	user:OpenDynamicWindow(newWindow,this)
end
function ShowChangeRegion(user)
	local newWindow = DynamicWindow("SetDestination","Set Destination",450,350)

	local regionStr = curGotoRegion .. " - " .. curGotoWorld
	if(curGotoRegion == GetRegionAddress()) then
		regionStr = regionStr .. " (Current)"
	end
	newWindow:AddLabel(20,10,"Region: "..regionStr,0,0,18)
	newWindow:AddImage(10,35,"Divider",380,1,"Sliced")
	
	local allRegions = GetClusterRegions()

	local scrollWindow = ScrollWindow(20,40,380,200,25)
	for regionAddress,regionInfo in pairs(allRegions) do
		local scrollElement = ScrollElement()
		scrollElement:AddButton(10, 0, "Change|"..regionAddress, regionAddress, 360, 25, "", "", false,"List")
		scrollWindow:Add(scrollElement)
	end
	newWindow:AddScrollWindow(scrollWindow)

	user:OpenDynamicWindow(newWindow,this)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"SetDestination",
	function (user,buttonId,fieldData)
		if not(IsGod(user)) then return end

		if(buttonId == "Save") then 
			if(fieldData.DestXValue == "" or fieldData.DestYValue == "" or fieldData.DestZValue == "") then 
				if(this:HasObjVar("Destination")) then
					this:DelObjVar("Destination")
				end
			else
				this:SetObjVar("Destination",Loc(tonumber(fieldData.DestXValue),tonumber(fieldData.DestYValue),tonumber(fieldData.DestZValue)))
			end

			if(fieldData.RegionAddress == "") then
				if(this:HasObjVar("RegionAddress")) then
					this:DelObjVar("RegionAddress")
				end
			else
				this:SetObjVar("RegionAddress",fieldData.RegionAddress)
			end

			if(fieldData.Type == "") then
				if(this:HasObjVar("Type")) then
					this:DelObjVar("Type")
				end
			else
				this:SetObjVar("Type",fieldData.Type)
			end
		elseif(buttonId == "SelectDest") then
			ShowSelectDestination(user)
		elseif(buttonId:match("Select")) then
			local dummy,index  = string.match(buttonId, "(%a+)|(.+)")
			local allLocs = GetAllLocations(curGotoWorld)
			local newLoc = allLocs[tonumber(index)]
			this:SetObjVar("Destination",newLoc.Loc)
			if(curGotoRegion ~= GetRegionAddress()) then
				this:SetObjVar("RegionAddress",curGotoRegion)
			elseif(this:HasObjVar("RegionAddress")) then
				this:DelObjVar("RegionAddress")
			end
			ShowSetDestinationWindow(user)
		elseif(buttonId == "ChangeRegion") then
			ShowChangeRegion(user)
		elseif(buttonId:match("Change")) then
			dummy,regionAddress = string.match(buttonId, "(%a+)|(.+)")
			local allRegions = GetClusterRegions()
			curGotoRegion = regionAddress
			curGotoWorld = allRegions[regionAddress].WorldName
			ShowSelectDestination(user)
		end
	end)

RegisterEventHandler(EventType.EnterView, "TeleportPlayer", 
	function(user)
		if (this:GetSharedObjectProperty("Weight") >= 0) then
			DelView("TeleportPlayer")
			return
		end
		-- prevent repeated teleports
		if(user:HasTimer("TeleportDelay") or user:HasTimer("EnteringWorld")) then
			return
		end

		--if (not user:IsPlayer()) then
		--	DoMobTeleport(user)
		--	return
		--end
		
		ActivateTeleporter(user)
	end)

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
    	if(usedType == "Use" or usedType == "Activate") then 
    		ActivateTeleporter(user)
    	elseif(usedType == "Set Destination") then
    		ShowSetDestinationWindow(user)
    	end
    end)

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function ( ... )
		this:SetObjVar("UseableWhileDead",true)
		
		-- DAB HACK: Messy way to set portal names from Seed Objects
		local portalName = this:GetObjVar("PortalName")
		if(portalName) then
			this:SetName(portalName)
			this:DelObjVar("PortalName")
		end

		--[[
		local destination = this:GetObjVar("Destination")
		if (destination ~= nil) then
			SetPortalDisplayName(this, destination)
		end
		]]--

		if not (this:GetObjVar("PortalLocked")) then
			AddUseCase(this,"Activate",true)
		end
		AddUseCase(this,"Set Destination",false,"IsGod")
	end)

if(this:GetIconId() == 2) then
	local teleportRange = this:GetObjVar("TeleportRange")
	if(teleportRange ~= 0) then
		AddView("TeleportPlayer", SearchPlayerInRange(teleportRange or 1.0,true))--SearchMobileInRange(this:GetObjVar("TeleportRange") or 1.0))
	end
end

if (initializer ~= nil) then
	this:SetObjVar("TeleporterConsumeItems",initializer.ConsumeItems)
end