-- System globals required in the global environment table of every Lua VM
-- NOTE: Do not modify variables in the space in object behavior modules

-- lua extensions
require 'globals.lua.extensions'
require 'globals.lua.statemachine'
require 'globals.lua.email'

xml = LoadExternalModule("LuaXml")
json = LoadExternalModule("cjson")

-- server settings
require 'globals.server_settings.main'
-- server data files
require 'globals.static_data.main'

require 'globals.event_tracking.main'
require 'globals.skill_system'
require 'globals.equipment'
require 'globals.equipment_functions'
require 'globals.items'
require 'globals.crafting'
require 'globals.colors'
require 'globals.regions'
require 'globals.cluster_helpers'
require 'globals.badwords'
require 'globals.speech_helpers'
require 'globals.currency_helpers'
require 'globals.use_cases'

-- global defines (these can be used in template initializers)
require 'defines_templates'

require 'defines_crafting_orders'

-- Lua gameobj extensions
require 'globals.mobile_extensions_misc'
require 'globals.mobile_extensions_stats'
require 'globals.mobile_extensions_skills'

-- Dynamic window helpers
require 'globals.dynamic_window.main'

require 'globals.debug'

-- Contains functions that are called directly from the game engine
require 'globals.engine_callbacks'

NEW_PLAYER_GUILD_ID = "0000"



if(ServerSettings.EditMode == true) then
	require 'globals.editmode'
end

require 'globals.htmlwindows.htmlwindows'

require 'globals.helpers.main'
require 'globals.mobile_effects.main'
require 'globals.special_effects.main'

-- Common global variables
-- Lua Helpers

--Add an object to the list of objects that can see the invis object. cType specifies the reason the object is allowed to see target.
function AddToCanSeeList(objInvis, viewer, cType)
	--DebugMessage(objInvis:GetName() .. " Adding: " .. viewer:GetName() .. " for " .. cType)
 	local canSeeMeList = objInvis:GetObjVar("CanSeeMeList")
 	if(canSeeMeList == nil) then canSeeMeList = {} end
 	local canSeeViewer = canSeeMeList[viewer] 
 	if(canSeeViewer == nil) then canSeeViewer = {} end
 	canSeeViewer[cType] = true
 	canSeeMeList[viewer] = canSeeViewer
 	objInvis:SetObjVar("CanSeeMeList", canSeeMeList)
 	--DebugTable(canSeeMeList)
 	--DebugMessage(objInvis:GetName() .. " Can Now Be Seen By " .. viewer:GetName())
	

end

function IsInvuln(target)
	if(target:HasObjVar("Invulnerable")) then
		return target:GetObjVar("Invulnerable") == true
	end
	return false
end

--gets a random element in a table
function GetRandomElementInTable(_table)
	local resultTable = {}
	for i,j in pairs(table) do
		table.insert(resultTable,j) 
	end
	return resultTable[math.random(1,#resultTable)]
end

function GetRandomKeyInTable(_table)
	local resultTable = {}
	for i,j in pairs(table) do
		table.insert(resultTable,i) 
	end
	return resultTable[math.random(1,#resultTable)]
end


--Remove an object to the list of objects that can see the invis object
-- Will only remove this if all reasons that they should be able to see the invis object are removed as well.

function RemoveFromCanSeeGroup(objInvis, viewer, cType)
    local canSeeMeList = objInvis:GetObjVar("CanSeeMeList")
    if(canSeeMeList == nil) then return end
    local canSeeViewer = canSeeMeList[viewer] 
    if(canSeeViewer == nil) then return end
    canSeeViewer[cType] = nil
    if IsTableEmpty(canSeeViewer) then
        canSeeMeList[viewer] = nil
    else
        canSeeMeList[viewer] = canSeeViewer
    end
    objInvis:SetObjVar("CanSeeMeList", canSeeMeList)
end

function ClearCanSeeGroup(objInvis)
	objInvis:DelObjVar("CanSeeMeList")
end

--[[
	Function:: Sends Table keys and values to debug message
	Input: table
	Output: none
]]--
function DebugTable(tableName)
	for mKs, mVs in pairs(tableName) do
	DebugMessage(" --> " .. tostring(mKs) .. " & " ..tostring(mVs))
	end
end

--TODO
		
-- GameObj Helpers
-- DAB TODO: We cant add these to the meta table because boolean returns
-- are acting funky (WTF?)

function IsNilOrInvalid(target)
	return (target == nil) or not(target:IsValid())
end

function IsInCombat(target)
	if ( target == nil ) then
		LuaDebugCallStack("[globals|IsInCombat] ERROR: target is nil.")
		return false
	end
	return target:GetSharedObjectProperty("CombatMode") == true
end

function IsDead(target)
	--LuaDebugCallStack("Target")
	if ( IsNilOrInvalid(target) ) then
		--LuaDebugCallStack("[globals|IsDead] ERROR: target is nil.")
		return true
	end
	if not( target:IsMobile() ) then
		--LuaDebugCallStack("ERROR: Trying to check IsDead on non mobile.")
		return true
	end
	if ( target:IsPlayer() ) then
		return target:HasObjVar("IsDead") -- even having this var set counts.
	else
		-- SharedObjectProperty("IsDead") will toggle corpse of mobile, since players
			-- themselves aren't corpses then this only for work mobs.
		return target:GetSharedObjectProperty("IsDead") == true
	end
end

function IsAsleep(target)
	if ( target == nil ) then
		LuaDebugCallStack("[globals|IsAsleep] ERROR: target is nil.")
		return false
	end
	return target:GetObjVar("Sleeping") == true
end

function IsStabled(target)
	if ( target == nil and not(target:IsEquipped())) then
		LuaDebugCallStack("[globals|IsStabled] ERROR: target is nil.")
		return false
	end
	return target:ContainedBy() ~= nil
end

function IsMyPet(target)
	if(target == nil or not(target:IsValid())) then return false end

	local controller = target:GetObjVar("controller")
	return controller == this and target:HasModule("pet_controller")
end

function FactionExists(factionName)
	for i,j in pairs(Factions) do 
		--DebugMessage("j.InternalName is "..tostring(j.InternalName))
		if (j.InternalName == factionName) then
			--DebugMessage("Returning last entry")
			return true
		end
	end
	return false
end
--DFB HACK: This is a hacky way of doing this.
TRAP_DAMAGE_DIST = 4
function TrapAtLocation(location)
    local traps = FindObjects(SearchMulti({SearchHasObjVar("IsTrap"),SearchRange(location,TRAP_DAMAGE_DIST)}))
    if (#traps >= 1) then return true else return false end
end

function IsSitting(target)
	--DebugMessage("pose is "..tostring(target:GetSharedObjectProperty("Pose")) )
	return target:GetSharedObjectProperty("Pose") == "Sitting"
end
-- objvar Helpers
function AddToListObjVar(objRef, objVarName, valueToAdd)
	if( objRef == nil or not(objRef:IsValid()) ) then
		return 
	end

	local listObjVar = objRef:GetObjVar(objVarName) or {}
	table.insert(listObjVar,valueToAdd)
	objRef:SetObjVar(objVarName,listObjVar)
end

function AddToTableObjVar(objRef, objVarName, keyToAdd, valueToAdd)
	if( objRef == nil or not(objRef:IsValid()) ) then
		return 
	end

	local listObjVar = objRef:GetObjVar(objVarName) or {}
	listObjVar[keyToAdd] = valueToAdd
	objRef:SetObjVar(objVarName,listObjVar)
end

function StripColorFromString(inputStr)
	if not(inputStr) then
		return nil
	end
	
	local color = string.match(inputStr,"%[......%]")
	local outStr = string.gsub(inputStr,"%[......%]","")
	local outStr = string.gsub(outStr,"%[%-%]","")
	return outStr, color
end

function StripFromString(inputStr,stripString)
	local outStr = string.gsub(inputStr,tostring(stripString),"")
	return outStr
end

function ParseLoc(locStr)
	local locComps = StringSplit(locStr,",")

	if( #locComps ~= 3 ) then
		return nil
	end

	return Loc(tonumber(locComps[1]),tonumber(locComps[2]),tonumber(locComps[3]))
end

function ServerBroadcast(message,isEvent)
	local onlineUsers = GlobalVarRead("User.Online")

	if( isEvent == nil ) then
		isEvent = false
	end

	for user,y in pairs(onlineUsers) do
		if( isEvent ) then
			user:SendMessageGlobal("SystemMessage",message,"event")
		else
			user:SendMessageGlobal("SystemMessage",message)
		end
	end

	DebugMessage("** ServerWideBroadcast: "..message)
end

function PvPBroadcast(message)
	local pvpPlayers = FindObjects(SearchModule("incl_PvPPlayer"))

	--DebugMessage(tostring(loggedOnUser) .. message)
	for index,object in pairs(pvpPlayers) do
		object:SystemMessage(message, "event")
	end

end

function GetPlayersByName(playerName)
	local loggedOnUsers = FindPlayersInRegion()
	
	local foundPlayers = {}
	for index,object in pairs(loggedOnUsers) do	
		if( object:GetName():lower():match(playerName:lower())) then
			foundPlayers[#foundPlayers+1] = object
		end
	end

	return foundPlayers
end

function ForEachPlayerInRegion(functor)
	for i,playerObj in pairs(FindObjectsWithTag("AttachedUser")) do
		functor(playerObj)
	end
end

function FindPlayersInRegion(compFunc)
	local result = {}

	for i,playerObj in pairs(FindObjectsWithTag("AttachedUser")) do
		if(not(compFunc) or compFunc(playerObj)) then
			table.insert(result,playerObj)
		end
	end

	return result
end

function FindPlayersInGameRegion(regionName)
	return FindPlayersInRegion(function(playerObj) return playerObj:IsInRegion(regionName) end)
end

function FindItemInContainerByTemplate(contObj,template)
	if not(contObj) or not(contObj:IsContainer()) then return nil end

	for i,containedObj in pairs(contObj:GetContainedObjects()) do
		if(containedObj:GetCreationTemplateId() == template) then
			return containedObj		
		end
	end
end

function FindItemInContainer(contObj,compFunc)
	if not(contObj) or not(contObj:IsContainer()) then return nil end

	for i,containedObj in pairs(contObj:GetContainedObjects()) do
		if(compFunc(containedObj)) then
			return containedObj		
		end
	end
end

function FindItemInContainerByTemplateRecursive(contObj,template)
	return FindItemInContainerRecursive(contObj,function (containedItem)
		return containedItem:GetCreationTemplateId() == template
	end)
end

function FindItemInContainerRecursive(contObj,compFunc)
	if not(contObj) or not(contObj:IsContainer()) then return nil end

	for i,containedObj in pairs(contObj:GetContainedObjects()) do		
		if(not(compFunc) or compFunc(containedObj)) then
			return containedObj
		end

		local subResult = FindItemInContainerRecursive(containedObj,compFunc)
		if(subResult) then
			return subResult
		end
	end
end

function FindItemsInContainerByTemplateRecursive(contObj,template)
	return FindItemsInContainerRecursive(contObj,function (objRef)
		return objRef:GetCreationTemplateId() == template
	end)
end

function FindItemsInContainerRecursive(contObj,compFunc)
	if not(contObj) or not(contObj:IsContainer()) then return {} end

	local result = {}
	for i,containedObj in pairs(contObj:GetContainedObjects()) do
		if(not(compFunc) or compFunc(containedObj)) then
			table.insert(result,containedObj)
		end
		local subResults = FindItemsInContainerRecursive(containedObj,compFunc)
		if(#subResults > 0) then
			for i,subResult in pairs(subResults) do
				table.insert(result,subResult)
			end
		end
	end

	return result
end

-- this runs until the functor returns false
function ForEachItemInContainerRecursive(contObj,functor,depth)
	if not(contObj:IsContainer()) then return end

	if(depth == nil) then
		depth = 1
	else
		depth = depth + 1	
	end

	for i,containedObj in pairs(contObj:GetContainedObjects()) do
		if not(functor(containedObj,depth)) then
			return
		else			
			ForEachItemInContainerRecursive(containedObj,functor,depth)
		end
	end
end

function ForEachParentContainerRecursive(contObj,includeSelf,functor)
	local curObj = contObj
	if not(includeSelf) then
		curObj = contObj:ContainedBy()
	end

	while curObj ~= nil do 
		if not(functor(curObj)) then
			return
		end

		curObj = curObj:ContainedBy()
	end
end

-- shortens the length of a string to the length specified and adds ... if necesary
function ShortenColoredString(str,length)
	local strippedName, color = StripColorFromString(str)
	if(strippedName:len() > length) then
		str = strippedName:sub(0,length).."..."
		if(color ~= nil) then
			str = color..str.."[-]"
		end
	end

	return str
end

PercentToString = {
	{ Name="Impossible", Percent= 0 },
	{ Name="Almost Certainly Not", Percent= 2 },
	{ Name="Probably Not", Percent= 12 },
	{ Name="Chances About Even", Percent= 40 },
	{ Name="Probable", Percent= 63 },
	{ Name="Almost Certain", Percent= 87 },
	{ Name="Certain", Percent= 100 },
}

function ConvertPercentToString(percent)
	if(percent == nil) then return "" end

	percentStr = "Impossible"
	for i,percentInfo in pairs(PercentToString) do
		if(percent <= percentInfo.Percent) then
			return percentStr
		end
		percentStr = percentInfo.Name
	end	
	return percentStr
end

function GetStatTableFromTemplate(template,templateData)	
	--DebugMessage(template)
	local templateData = templateData or GetTemplateData(template)
	local templateModule = ""
	if not(templateData) then
		LuaDebugCallStack("ERROR Invalid template "..template)
	end
	--DebugMessage(DumpTable(templateData))
	for moduleName,initializer in pairs(templateData.LuaModules) do 
		if(initializer.Stats ~= nil or initializer.EquipTable ~= nil) then
			templateModule = moduleName
		end
	end

	--DebugMessage("BALHA",tostring(template),tostring(templateModule))
	return GetInitializerFromTemplate(template,templateModule)
end

function AngleDiff(angle1, angle2)
	if(angle1 == nil) then return 0 end
	if(angle2 == nil) then return 0 end
	--DebugMessage(attacker:GetName() ..tostring(myFace)..defender:GetName() ..tostring(theirFace).." MtT:" ..tostring(myToThem))
	local angleDif = math.abs(angle1 - angle2)
	if(angleDif > 180) then
		angleDif = 360 - angleDif
	end
	--DebugMessage(tostring(facingDif).."->" .. attacker:GetName())
	if(angleDif % math.floor(angleDif) >= .5) then 
		angleDif = math.ceil(angleDif)
	else
		angleDif = math.floor(angleDif)
	end
	return angleDif
end

-- these are the ObjVars that will be used per stat, done this way to help keep track of all statistics used.
Statistics = {
	ItemsCrafted = "ItemsCrafted"
}

-- uncomment this on test map to run tests
--require 'globals.tests.main'