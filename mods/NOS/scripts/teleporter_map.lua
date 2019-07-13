-- This script uses the default rules concept of "universes" to allow a teleporter to send
-- a user to any region server running the DestinationMap. If there is more than one,
-- it opens a UI window

require 'NOS:teleporter'

function ShowRegionSelectWindow(user,validDestinations)
	local title = this:GetObjVar("WindowTitle") or "Select Universe"		

	local numRegions = #validDestinations
	local newWindow
	if(numRegions < 5) then
		newWindow = DynamicWindow("Universe",title,355,70 + 26 * numRegions,-187,-82,"","Center")
		local curY = 10
		for i,regionAddress in pairs(validDestinations) do
			local universeName = GetUniverseName(regionAddress)
			newWindow:AddButton(20, curY, regionAddress, universeName, 290, 26, "", "", false,"List")
			curY = curY + 25
		end
	else
		newWindow = DynamicWindow("Universe",title,355,165,-187,-82,"","Center")

		local scrollWindow = ScrollWindow(10,0,300,104,26)
		for i,regionAddress in pairs(validDestinations) do
			local scrollElement = ScrollElement()
			local universeName = GetUniverseName(regionAddress)
			scrollElement:AddButton(10, 0, regionAddress, universeName, 270, 26, "", "", false,"List")
			scrollWindow:Add(scrollElement)
		end
		newWindow:AddScrollWindow(scrollWindow)
	end

	user:OpenDynamicWindow(newWindow,this)
end

local currentTargetLoc = nil
local oldDoTeleport = DoTeleport
function DoTeleport(user,targetLoc)
	local chooseUniverse = this:GetObjVar("ChooseUniverse")
	if(chooseUniverse == nil) then chooseUniverse = true end
	
	local destinationMap = this:GetObjVar("DestinationMap") or ServerSettings.WorldName
	-- DAB TODO: Figure out subregion automatically!
	local destinationSubregion = this:GetObjVar("DestinationSubregion") or ServerSettings.SubregionName

	if not(chooseUniverse) then
		local destRegionAddress = GetCurrentUniverseName() .. "." .. destinationMap
		oldDoTeleport(user,targetLoc,destRegionAddress)
	else
		local curRegionAddress = ServerSettings.RegionAddress
		local validDestinations = {}
		for regionName,regionInfo in pairs(GetClusterRegions()) do 
			if(regionName ~= curRegionAddress and regionInfo.WorldName == destinationMap and regionInfo.SubregionName == destinationSubregion) then
				table.insert(validDestinations,regionName)
			end
		end

		if(#validDestinations == 1) then
			oldDoTeleport(user,targetLoc,validDestinations[1])
		elseif(#validDestinations > 1) then
			currentTargetLoc = targetLoc
			ShowRegionSelectWindow(user,validDestinations)
		end
	end
end

RegisterEventHandler(EventType.DynamicWindowResponse,"Universe",
	function(user,buttonId)
		if(buttonId ~= nil and buttonId ~= "") then
			oldDoTeleport(user,currentTargetLoc,buttonId)
		end
	end)

RegisterEventHandler(EventType.LeaveView, "TeleportPlayer", 
	function(user)
		user:CloseDynamicWindow("Universe")
	end)