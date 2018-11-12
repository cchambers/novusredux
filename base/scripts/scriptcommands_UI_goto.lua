
function GetAllLocations(worldName)
	local allLocs = {}
	local defaultLocs = MapLocations[worldName] or {}
	for name, loc in pairs(defaultLocs) do
		table.insert(allLocs,{Name=name,Loc=loc,Type="Default"})
	end

	local customLocs = (this:GetObjVar("CustomMapLocations") or {})[worldName]
	if(customLocs ~= nil) then
		for name, loc in pairs(customLocs) do 
			table.insert(allLocs,{Name=name,Loc=loc,Type="Custom"})
		end
	end

	table.sort(allLocs,function(a,b) return a.Name < b.Name end)

	return allLocs
end

function GetLocInfo(worldName,locIndex)
	local allLocs = GetAllLocations(worldName)	
	if(allLocs ~= nil and locIndex <= #allLocs) then
		return allLocs[locIndex]
	end
end

local curGotoRegion = GetRegionAddress()
local curGotoWorld = GetWorldName()
local selectedItem

function ShowGoToList()
	local newWindow = DynamicWindow("GoToList","Goto",450,530)

	local regionStr = curGotoRegion .. " - " .. curGotoWorld
	if(curGotoRegion == GetRegionAddress()) then
		regionStr = regionStr .. " (Current)"
	end
	newWindow:AddLabel(20,10,"Region: "..regionStr,0,0,18)
	newWindow:AddImage(10,35,"Divider",380,1,"Sliced")
	
	local allLocs = GetAllLocations(curGotoWorld)
	if(#allLocs == 0) then
		table.insert(allLocs,{Name="Center",Loc=Loc(0,0,0)})
	end

	local scrollWindow = ScrollWindow(20,40,380,375,25)
	for i,locInfo in pairs(allLocs) do
		local scrollElement = ScrollElement()	

		if((i-1) % 2 == 1) then
            scrollElement:AddImage(0,0,"Blank",360,25,"Sliced","1A1C2B")
        end
		
		scrollElement:AddLabel(5, 3, locInfo.Name,0,0,18)

		local selState = ""
		if(i == selectedItem) then
			selState = "pressed"
		end
		scrollElement:AddButton(340, 3, "Select|"..i, "", 0, 18, "", "", false, "Selection",selState)
		scrollWindow:Add(scrollElement)
	end
	newWindow:AddScrollWindow(scrollWindow)

	local buttonState = ""
	if(selectedItem == nil) then
		buttonState = "disabled"
	end
	-- Goto
	newWindow:AddButton(15, 420, "Goto", "Goto", 100, 23, "", "", false,"",buttonState)
	-- Portal
	newWindow:AddButton(115, 420, "Portal", "Portal", 100, 23, "", "", false,"",buttonState)

	-- rename and delete only work for custom locations
	if(selectedItem ~= nil and allLocs[selectedItem] ~= nil and allLocs[selectedItem].Type ~= "Custom") then
		buttonState = "disabled"
	end

	-- Rename
	newWindow:AddButton(215, 420, "Rename", "Rename", 100, 23, "", "", false,"",buttonState)
	-- Delete
	newWindow:AddButton(315, 420, "Delete", "Delete", 100, 23, "", "", false,"",buttonState)

	-- Add New
	newWindow:AddButton(15, 443, "Add", "Add Custom Location", 200, 23, "", "", false,"")
	-- Change Region
	newWindow:AddButton(215, 443, "ChangeRegion", "Change Region", 200, 23, "", "", false,"")
	
	this:OpenDynamicWindow(newWindow)
end

function ShowChangeRegion()
	local newWindow = DynamicWindow("GoToList","Goto",450,530)

	local regionStr = curGotoRegion .. " - " .. curGotoWorld
	if(curGotoRegion == GetRegionAddress()) then
		regionStr = regionStr .. " (Current)"
	end
	newWindow:AddLabel(20,10,"Region: "..regionStr,0,0,18)
	newWindow:AddImage(10,35,"Divider",380,1,"Sliced")
	
	local allRegions = GetClusterRegions()

	local scrollWindow = ScrollWindow(20,40,380,400,25)
	for regionAddress,regionInfo in pairs(allRegions) do
		local scrollElement = ScrollElement()
		scrollElement:AddButton(10, 0, "Change|"..regionAddress, regionAddress, 360, 25, "", "", false,"List")
		scrollWindow:Add(scrollElement)
	end
	newWindow:AddScrollWindow(scrollWindow)

	this:OpenDynamicWindow(newWindow)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"GoToList",
	function (user,command)
		local commandInfo = GetCommandInfo("gotolocation")
		if not(LuaCheckAccessLevel(this,commandInfo.AccessLevel)) then return end	

		if(command ~= nil) then
			if(command:match("Select")) then
				local dummy,index  = string.match(command, "(%a+)|(.+)")
				selectedItem = tonumber(index)
				ShowGoToList()
			elseif(command == "Goto") then				
				local locInfo = GetLocInfo(curGotoWorld,selectedItem)
				local dest = (locInfo and locInfo.Loc) or Loc(0,0,0)				
				this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"TeleportDelay")
				if(curGotoRegion == GetRegionAddress()) then		
					this:SetWorldPosition(dest)					
				else
					this:TransferRegionRequest(curGotoRegion,dest)
				end
			elseif(command == "Portal") then
				local locInfo = GetLocInfo(curGotoWorld,selectedItem)
				local dest = (locInfo and locInfo.Loc) or Loc(0,0,0)
				-- this little hack shoudl stop the god from instantly travelling into the portal
				this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"TeleportDelay")
				if(curGotoRegion == GetRegionAddress()) then	
					OpenTwoWayPortal(this:GetLoc(),dest,60)
				else
					OpenRemoteTwoWayPortal(this:GetLoc(),dest,curGotoRegion,60)
				end
			elseif(command == "Rename") then
				local locInfo = GetLocInfo(curGotoWorld,selectedItem)
				TextFieldDialog.Show{
			        TargetUser = this,
			        Title = "Rename Custom Loc",
			        Description = "",
			        ResponseFunc = function(user,newName)
			        	if(newName ~= nil and newName ~= "") then
				        	local customLocs = this:GetObjVar("CustomMapLocations")
				        	customLocs[curGotoWorld][locInfo.Name] = nil
				        	customLocs[curGotoWorld][newName] = locInfo.Loc
				        	this:SetObjVar("CustomMapLocations",customLocs)
				        	selectedItem = nil
				        	ShowGoToList()
				        end
			        end
			    }
			elseif(command == "Delete") then
				local locInfo = GetLocInfo(curGotoWorld,selectedItem)
				local customLocs = this:GetObjVar("CustomMapLocations")
				customLocs[curGotoWorld][locInfo.Name] = nil
				this:SetObjVar("CustomMapLocations",customLocs)
	        	selectedItem = nil
	        	ShowGoToList()
			elseif(command == "Add") then
				TextFieldDialog.Show{
			        TargetUser = this,
			        Title = "Add Custom Loc",
			        Description = "",
			        ResponseFunc = function(user,newName)
			        	if(newName ~= nil and newName ~= "") then
				        	local customLocs = this:GetObjVar("CustomMapLocations") or {}
				        	if(customLocs[curGotoWorld] == nil) then
				        		customLocs[curGotoWorld] = {}
				        	end
				        	customLocs[curGotoWorld][newName] = this:GetLoc()
				        	this:SetObjVar("CustomMapLocations",customLocs)
				        	selectedItem = nil
				        	ShowGoToList()
				        end
			        end
			    }
			elseif(command == "ChangeRegion") then
				ShowChangeRegion()
			elseif(command:match("Change")) then
				dummy,regionAddress = string.match(command, "(%a+)|(.+)")
				local allRegions = GetClusterRegions()
				curGotoRegion = regionAddress
				curGotoWorld = allRegions[regionAddress].WorldName
				ShowGoToList()
			end
		end
	end)