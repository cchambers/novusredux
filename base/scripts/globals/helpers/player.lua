function IsGod(target)
	return target:HasAccessLevel(AccessLevel.God) or target:HasObjVar("IsGod")
end

function IsDemiGod(target)
	return target:HasAccessLevel(AccessLevel.DemiGod) or target:HasObjVar("IsGod")
end

function IsImmortal(target)
	return target:HasAccessLevel(AccessLevel.Immortal) or target:HasObjVar("IsGod")
end

function LuaCheckAccessLevel(target,accessLevel)
	return target:HasAccessLevel(accessLevel) or target:HasObjVar("IsGod")
end

function TestMortal(target)
	return target:HasObjVar("TestMortal")
end

function IsFounder(user)
	return true
end

function IsCollector(user)
	return true
end

function GetCustomTitles(user)
	return nil
end

-- Hotbar helper functions

function RequestAddUserActionToSlot(target,actionData)
	if not(target:IsPlayer()) then return end

	target:SendMessage("AddUserActionToSlot",actionData)
end

function RemoveUserActionFromSlot(target,slotIndex)
	if not(target:IsPlayer()) then return end

	target:SendMessage("RemoveUserActionFromSlot",slotIndex)
end

function UpdateMatchingUserActions(target,updatedActions)
	if not(target:IsPlayer()) then return end

	target:SendMessage("UpdateMatchingUserActions",updatedActions)
end

function HasHotbarAction(target,actionType,actionId)
	local hotbarActions = target:GetObjVar("HotbarActions")		
	for slot,action in pairs(hotbarActions) do
		if(action.ID == actionId and action.ActionType == actionType) then
			return true
		end
	end
	return false
end

function AddSpellToSlot(playerObj,spellName,slot)
	userAction = GetSpellUserAction(spellName)
	userAction.Slot = slot
	RequestAddUserActionToSlot(playerObj,userAction)
end

function AddTemplateItemToSlot(playerObj,templateName,slot,backpackObj)
	local searchObj = backpackObj or playerObj
	local item = FindItemInContainerByTemplate(searchObj,templateName )
	if(item) then
		userAction = GetItemUserAction(item,playerObj)
		userAction.Slot = slot
		RequestAddUserActionToSlot(playerObj,userAction)
	end
end

function AddBuffIcon(target,identifier,displayName,icon,tooltip,isDebuff,timespan)
	target:SendMessage("AddBuffIcon",{
						Identifier = identifier,
						Icon = icon,
						Tooltip = tooltip,
						DisplayName = displayName,
						IsDebuff =isDebuff,
					},timespan)
end 

function RemoveBuffIcon (target,identifier)
	if ( target == nil ) then
		LuaDebugCallStack("nil target provided.")
	end
	target:SendMessage("RemoveBuffIcon",identifier)
end

function IsInBackpack(object,user,includeSelf)
	local backpackObj = user:GetEquippedObject("Backpack")
	if(includeSelf and backpackObj == object) then
		return true
	end

	return FindItemInContainerRecursive(backpackObj,function(item) return item == object end) ~= nil
end

function GetPlayerSpawnPosition(user)
	local spawnPosEntry = user:GetObjVar("SpawnPosition")
   	if(spawnPosEntry ~= nil and spawnPosEntry.Region == GetRegionAddress()) then
   		return spawnPosEntry.Loc
   	end

   	-- no valid bind so use the map spawn location
	local position, rotation = GetSpawnPosition(user)
   	return position
end

-- this relies on the OnLoad function in player.lua setting LoginTime objvar
function TimeSinceLogin(user)
	local loginTime = user:GetObjVar("LoginTime")	
	local now = DateTime.UtcNow
	if not(loginTime) or now < loginTime then
		return TimeSpan.MaxValue
	end

	return now - loginTime
end

function AddMapMarker(user,mapMarker,type)
	if (user == nil or (not user:IsValid()) or (not user:IsPlayer())) then return end
	local oldMarkers = user:GetObjVar("MapMarkers") or {}
	local newMarkers = {}
	for i,markerEntry in pairs(oldMarkers) do
		if(markerEntry.Type ~= type) then
			table.insert(newMarkers,markerEntry)
		end
	end
	mapMarker.Type = type
	table.insert(newMarkers,mapMarker)

	user:SetObjVar("MapMarkers",newMarkers)
end

function RemoveMapMarker(user,type)
	local oldMarkers = user:GetObjVar("MapMarkers") or {}
	local newMarkers = {}
	for i,markerEntry in pairs(oldMarkers) do
		if (markerEntry.Type ~= type) then
			table.insert(newMarkers,markerEntry)	
		end
	end
	user:SetObjVar("MapMarkers",newMarkers)
end

function IsInActiveTrade(user)
	return user:HasModule("trading_controller") or user:HasModule("trading_target_controller")
end

function ShouldDropFullLoot(user)
	return ServerSettings.PlayerInteractions.FullItemDropOnDeath and not IsInitiate(user)
end