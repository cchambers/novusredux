require 'NOS:incl_combat_abilities'
require 'NOS:incl_skill_animalken'
require 'NOS:incl_magic_sys'

-- we store the 
local carriedAction = nil
local hotbarActions = nil

function PrintHotBarTable(tabledata)
	for slot,slottedAction in pairs(tabledata) do
			DebugMessage("Item: ",slottedAction.ID .. " Action Type: " .. slottedAction.ActionType .. " Slot: " ..slottedAction.Slot)
	end
end

function GetHotbarClientData()
	--DebugMessage("GetHotbarClientData")
	local clientData = {}
	for slot,userAction in pairs(hotbarActions) do
		--DebugMessage("Client Data: Slot:"..slot .. " userAction" .. userAction.ID)
		table.insert(clientData,userAction)
	end
	return clientData
end

function InitializeHotbar()	
--	DebugMessage("Init hotbar")
	-- if the player is just getting created
	hotbarActions = this:GetObjVar("HotbarActions") or hotbarActions or {}
--	PrintHotBarTable(hotbarActions)
	--DebugMessage("-- InitializeHotbar (send to client) -- "..#hotbarActions)
	if(hotbarActions ~= nil) then		
		-- load up the player actions
		if(CountTable(hotbarActions) > 0) then
			--DebugMessage("--UpdateUserAction-- (Load)")
			--DebugMessage(DumpTable(hotbarActions))
			this:SendClientMessage("UpdateUserAction",GetHotbarClientData())
		end
	end
end

function WipeHotbarData()
	hotbarActions = this:GetObjVar("HotbarActions") or hotbarActions or {}
	hotbarActions = {}
	this:SetObjVar("HotbarActions",hotbarActions)
end

function FindItemForSlot(itemslot, actionID, table)
	--DebugMessage("Find item for slot")

	for slot,slottedAction in pairs(table) do
		if(slottedAction.Slot == itemslot and slottedAction.ID == actionID) then
			return slottedAction
		end
	end
	--DebugMessage("No hotbar item found matching actionID: "..actionID .. " and Slot: " .. itemslot)
	return nil
end

function RemoveExistingActionsForSlot(itemslot, table)
	--DebugMessage("Remove existing items for slot")
	local removed = false
	for slot,slottedAction in pairs(table) do
		if(slottedAction.Slot == itemslot) then
			--DebugMessage("Removed item for slot:" .. itemslot .. " itemID: " .. slottedAction.ID)
			table[slot] = nil
			removed = true
		end
	end

	if(removed == false) then
		--DebugMessage("No hotbar items found matching slot:" .. itemslot)
	else
		this:SetObjVar("HotbarActions",table)
	end
end


RegisterEventHandler(EventType.ClientObjectCommand,"pickupAction",
	function (user,sourceId,actionType,actionId,slot)		
		slot = tonumber(slot)
		--if(slot ~= nil) then
		--	DebugMessage("Pickup action Slot: " .. slot)
		--else
		--	DebugMessage("Pickup icon thing sourceID" .. sourceID)
		--end

		hotbarActions = this:GetObjVar("HotbarActions") or hotbarActions or {}
		if(sourceId == "hotbar" and slot ~= nil) then			
			carriedAction = FindItemForSlot(slot, actionId, hotbarActions)
			--if(carriedAction == nil) then
				--DebugMessage("carriedAction is nil when attempting to pickup from slot")
				--PrintHotBarTable(hotbarActions)
			--end

			if(carriedAction ~= nil) then
				RemoveExistingActionsForSlot(carriedAction.Slot, hotbarActions)
				RemoveUserActionFromSlot(slot, hotbarActions)
			--	PrintHotBarTable(hotbarActions)
			end
		end
	end)

RegisterEventHandler(EventType.ClientObjectCommand,"dropAction",
	function (user,sourceId,actionType,actionId,slot)
		if(sourceId == "hotbar") then
			slot = tonumber(slot)
		--	if(slot == nil) then
		--		DebugMessage("Drop action to Ground NIL Slot")
		--	else
		--		DebugMessage("Drop action to slot: "..slot )
		--	end

		--	if(carriedAction == nil) then
		--		DebugMessage("[base_player_hotbar|PlayerHotbar] ERROR: Client is trying to drop an action on the hotbar without picking it up first.")
		--	end

			-- if slot is nil then we cancelled the drag so just clear the carried action
			if(slot == nil or type(slot) ~= "number") then
				carriedAction = nil			
			-- otherwise we are dropping it onto a proper hotbar slot
			elseif(carriedAction ~= nil and carriedAction.ID == actionId and carriedAction.ActionType == actionType) then
				carriedAction.Slot = slot
				AddUserActionToSlot(carriedAction)
				carriedAction = nil				
			else
				-- if the debug message gets sent with carriedAction as nil, we'll know.
				if ( carriedAction == nil ) then
					carriedAction = {
						ID = -1,
						ActionType = nil
					}
				end
				--DebugMessage("[base_player_hotbar|PlayerHotbar] ERROR: Client is trying to drop an action on the hotbar that doesn't match what is carried. Carried ID/Type: "..tostring(carriedAction.ID).."/"..tostring(carriedAction.ActionType)..", Dropped ID/Type: "..tostring(actionId).."/"..tostring(actionType))
				--DebugMessage(type(carriedAction.ID),type(actionId),type(carriedAction.ActionType),type(actionType))
			end
		end
	end)

RegisterEventHandler(EventType.ClientUserCommand,"dropItemToHotbar",
	function(slot)
	--	DebugMessage("Drop to slot:" .. slot)
		if(slot ~= nil) then
			slotIndex = tonumber(slot)
			if(slotIndex > 0 and slotIndex <= 100) then
				--Don't allow replacing weapon ability slots
				if (slotIndex == 29 or slotIndex == 30) then
					UndoPickup()
					return
				end
				local carriedObject = this:CarriedObject()
				if(carriedObject ~= nil and carriedObject:IsValid()) then
					local newAction = GetItemUserAction(carriedObject,this)
					newAction.Slot = slotIndex
					AddUserActionToSlot(newAction)
					UndoPickup();
				end
			end
		end
	end)

function AddUserActionToSlot(actionData)
	--DebugMessage("Add user action to slot:" .. actionData.Slot .. " ".. actionData.ID)
	if not(actionData) then
		LuaDebugCallStack("ERROR: Invalid action")
	end

	if(actionData.ID == nil or actionData.ActionType == nil or not(type(actionData.ID)=="string")) then
		DebugMessage("ERROR: Invalid id for action")
		return
	end

	--[[
	
	]]--

	if(actionData.Slot ~= nil and (type(actionData.Slot) ~= "number" or actionData.Slot <= 0 or actionData.Slot > 100)) then
		DebugMessage("ERROR: Hotbar currently only supports numbered slots between 1 and 100")
		return
	elseif(actionData.Slot == nil) then 
		actionData.Slot = 1
		while(hotbarActions[actionData.Slot] ~= nil) do
			actionData.Slot = actionData.Slot + 1
		end
	end
	hotbarActions = this:GetObjVar("HotbarActions") or hotbarActions or {}
	
	RemoveExistingActionsForSlot(actionData.Slot, hotbarActions)

	hotbarActions[actionData.Slot] = actionData

	--PrintHotBarTable(hotbarActions)

	this:SetObjVar("HotbarActions",hotbarActions)
	-- just send the one action that has changed
	--DebugMessage("--UpdateUserAction-- (Add)")
	--DebugMessage(DumpTable({actionData}))
	this:SendClientMessage("UpdateUserAction",{actionData})
end

function RemoveUserActionFromSlot(slotIndex)
	--DebugMessage("Remove Action From: " .. slotIndex)
	hotbarActions = this:GetObjVar("HotbarActions") or hotbarActions or {}

	hotbarActions[slotIndex] = nil

	--PrintHotBarTable(hotbarActions)

	this:SetObjVar("HotbarActions",hotbarActions)
	-- by sending an entry with a nil id it will clear that slot
	--DebugMessage("--UpdateUserAction-- (Remove) "..tostring(slotIndex))
	--DebugMessage(DumpTable({{Slot=slotIndex}}))
	this:SendClientMessage("UpdateUserAction",{{Slot=slotIndex}})
end

function UpdateMatchingUserActions(updatedActions)
	--DebugMessage("Update Matching Actions")
	-- this is a tricky way to allow a user to send just one action without putting it in a table
	hotbarActions = this:GetObjVar("HotbarActions") or hotbarActions or {}
	if(updatedActions.ID ~= nil) then
		updatedActions = {updatedActions}
	end
	--DebugMessage("UpdateMatchingUserActions")
	-- this can get called before we even load our hotbar, so just ignore it
	if(hotbarActions == nil) then return end
	--DebugMessage("Dumping hotbar actions to update:"..DumpTable(updatedActions))
	clientData = {}
	for i,actionData in pairs(updatedActions) do
		for slot,slottedAction in pairs(hotbarActions) do
			--DebugMessage("Checking: ",slottedAction.ID,actionData.ID,slottedAction.ActionType,actionData.ActionType)
			if(slottedAction.ID == actionData.ID and slottedAction.ActionType == actionData.ActionType) then
				-- copy the data to a new table for this slot
				newSlottedAction = { Slot = slottedAction.Slot }
				for k,v in pairs(actionData) do
					--DebugMessage("COPYING "..tostring(slottedAction.ID).." k: "..tostring(k).." v: "..tostring(v))
					newSlottedAction[k] = v
				end

				table.insert(clientData,newSlottedAction)
				hotbarActions[slot] = newSlottedAction
			end
		end
	end
	--DebugMessage("DUMPING RESULT: "..DumpTable(hotbarActions))
	this:SetObjVar("HotbarActions",hotbarActions)

	if(#clientData > 0) then
		--DebugMessage("--UpdateUserAction-- (Update)")
		--DebugMessage(DumpTable(clientData))
		this:SendClientMessage("UpdateUserAction",clientData)
	end
end

RegisterEventHandler(EventType.Message, "AddUserActionToSlot", AddUserActionToSlot)
RegisterEventHandler(EventType.Message, "RemoveUserActionFromSlot", RemoveUserActionFromSlot)
RegisterEventHandler(EventType.Message, "UpdateMatchingUserActions", UpdateMatchingUserActions)

-- Hotbar Save/Load functionality (Only works on a specific region!)

function SaveHotbarToXML(filename)
	if(xml == nil) then
		this:SystemMessage("Hotbar save/load support not available")
		return
	end

	local hotbarData = this:GetObjVar("HotbarActions")
	local xmlOut = xml.new("HotbarActions")
	for i,item in pairs(hotbarData) do 
		local xmlItem = xmlOut:append("HotbarItem")		
		for k,v in pairs(item) do 
			if(k == "Requirements") then
				for i,requirementItem in pairs(item.Requirements) do
					reqXmlItem = xmlItem:append("Requirement")
					reqXmlItem.Type = requirementItem[1]
					reqXmlItem.Min = requirementItem[2]
				end
			else
				xmlItem[k] = v
			end
		end
	end
	os.execute("mkdir savedhotbars")
	xmlOut:save("savedhotbars/"..filename..".xml")
	this:SystemMessage("Hotbar saved on the region server "..ServerSettings.RegionAddress.." to savedhotbars/"..filename..".xml")
end

function LoadHotbarFromXML(filename)
	if(xml == nil) then
		this:SystemMessage("Hotbar save/load support not available")
		return
	end
	
	local hotbarXml = xml.load("savedhotbars/"..filename..".xml")
	if(hotbarXml ~= nil) then
		local hotbarActions = {}
		for k,actionData in pairs(hotbarXml) do 
			-- only use data that is a hotbar action element
			--DebugMessage("INFO",tostring(k),type(actionData),tostring(actionData[0]))
			if(type(actionData) == "table" and actionData[0] == "HotbarItem") then
				local hotbarItem = {}
				for field,fieldData in pairs(actionData) do 
					-- number fields are tags and subnodes
					if(type(field) ~= "number" ) then
						if(field == "Slot" or field == "IconObject") then
							hotbarItem[field] = tonumber(fieldData)
						elseif(field == "Enabled") then
							hotbarItem[field] = (fieldData == "true") 
						else
							hotbarItem[field] = fieldData					
						end
					elseif(fieldData[0] == "Requirements") then
						hotbarItem.Requirements = {}
						table.insert(hotbarItem.Requirements,{fieldData.Type,fieldData.Min})
					end
				end		
				table.insert(hotbarActions,hotbarItem)
			end
		end
		this:SetObjVar("HotbarActions",hotbarActions)
		InitializeHotbar()
		this:SystemMessage("Hotbar loaded from savedhotbars/"..filename..".xml")
	end
end