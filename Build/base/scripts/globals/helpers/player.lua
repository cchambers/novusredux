function IsGod(target)
	return target:HasAccessLevel(AccessLevel.God) or target:HasObjVar("IsGod")
end

function IsDemiGod(target)
	return target:HasAccessLevel(AccessLevel.DemiGod) or target:HasObjVar("IsGod")
end

function IsImmortal(target)
	if not( target ) then
		LuaDebugCallStack("[IsImmortal] target not provided.")
		return false
	end
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

function GetCustomAchievements(user)
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
	if ( includeSelf and backpackObj == object ) then return true end
	local container = object:ContainedBy()
	while ( container and container:IsContainer() ) do
		if ( container == backpackObj ) then return true end
		container = container:ContainedBy()
	end
	return false
end

function GetPlayerSpawnPosition(user)
	local spawnPosEntry = user:GetObjVar("SpawnPosition")
   	if(spawnPosEntry ~= nil and spawnPosEntry.Region == ServerSettings.RegionAddress) then
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

function IsInActiveTrade(user)
	return user:HasModule("trading_controller") or user:HasModule("trading_target_controller")
end

function ShouldDropFullLoot(user)
	return ServerSettings.PlayerInteractions.FullItemDropOnDeath and not IsInitiate(user)
end

function UnstickPlayer(playerObj)
    local loc,reason = GetUnstuckLoc(playerObj, false)
    -- didn't move anywhere, don't give the benefits
    if ( reason == "NotStuck" ) then
        playerObj:SystemMessage("You are not stuck.", "info")
        return
    end
	playerObj:SetMobileFrozen(false, false)
	playerObj:SendMessage("StopSitting")
	playerObj:SendMessage("WakeUp")

	playerObj:SystemMessage("[$2408]","event")

	playerObj:SendMessage("BreakInvisEffect", "Damage")
	-- hack to fix people being perma cloaked
	if (not playerObj:HasObjVar("IsGhost")) then
		playerObj:SetCloak(false)
    end

    -- failed to find a nearby location
    if not( loc ) then
        if ( GetKarmaLevel(GetKarma(playerObj)).GuardHostilePlayer ) then
            local spawnPosition = FindObjectWithTag("OutcastSpawnPosition")
            if ( spawnPosition ) then
                loc = spawnPosition:GetLoc()
            end
        end
    end

    -- loc still not set, use player spawn position
	if not( loc ) then
        loc = GetPlayerSpawnPosition(playerObj)
    end

    if ( loc ) then
        -- move player and any pets
        ForeachMobileAndPet(playerObj, function(mobile)
            mobile:SetWorldPosition(loc)
		end)
		
		-- drop whatever is currently held at feet
		local carriedObject = playerObj:CarriedObject()
		if ( carriedObject ~= nil and carriedObject:IsValid() ) then
			carriedObject:SetWorldPosition(loc)
		end
    end

end

function GetUnstuckLoc(mobile, checkCurrent)
	local math, Plot = math, Plot
	local mobileLoc = mobile:GetLoc()
	local dungeonBounds = GetDungeonBounds()
    local start, center = 1, mobileLoc
	-- if this was not called from inside a dungeon
	if not( dungeonBounds ) then
		local plot, bounds, index = Plot.GetAtLoc(mobileLoc)
		-- if the mobile is in a plot and they have no control to the plot
		if ( plot and not Plot.HasControl(mobile, plot) ) then
			-- start looking for a place to put them that's outside the plot
			start = (bounds[index].Height * bounds[index].Width) + 1
			center = bounds[index].Center
		end
	end
	for i=1,500 do
		local loc = (checkCurrent and i == 0) and mobileLoc or GetSpiralLoc(start+i, center)
		if ( 
			( dungeonBounds and ValidDungeonPosition(dungeonBounds, loc) )
			or
			( not dungeonBounds and IsPassable(loc) )
		) then
			-- going 30 degrees at a time, loop a circle. 
			-- if from this loc they can path 14 units in any direction it's considered a valid location to move the mobile to.
			local canPathTo = false
			for ii=1,12 do
				if ( CanPathTo(loc, loc:Project(ii*30, 14)) ) then
					canPathTo = true
					break
				end
			end
			if ( canPathTo and (dungeonBounds or Plot.CanTeleportToLoc(mobile, loc)) ) then
				--[[
				if ( checkCurrent and i == 0 and loc:Equals(mobileLoc) ) then
					return nil,"NotStuck"
				end
				]]
				return loc
			end
		end
	end
	DebugMessage("[UNSTUCK] Failed too many times for Loc", mobileLoc)
	return nil,"Failed"
end

ValidatePlayerInputTypes = {
	Alpha = 0,
	Any = 1
}

function ValidatePlayerInput(input, min, max, type)
	if not( type ) then type = ValidatePlayerInputTypes.Alpha end

	if ( string.len(input) < min ) then
		return false, string.format("must longer than %d characters.", min)
	end

	if ( string.len(input) > max ) then
		return false, string.format("must be less than %d characters.", max)
	end

	if ( type == ValidatePlayerInputTypes.Alpha and #input:gsub("[%a ]","") ~= 0 ) then
		return false, "may only contain letters and spaces."
	end

	if ( ServerSettings.Misc.EnforceBadWordFilter and HasBadWords(input) ) then
		return false, "may not contain any foul language. Sorry!"
	end

	return true
end