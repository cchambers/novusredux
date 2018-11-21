-- This function can be overridden to have special rules based on region address
function GetInitialSeedGroups()		
	-- no special rulse so just return all groups that are not excluded for this map
	return GetAllSeedGroups("All",false)
end

function GetInitialUserUpdateRange()
	if(GetWorldName()=="Login") then
		return 0
	end
	--use default engine user update range of 30. 
	return -1
end

-- Returns two values, the location and the facing
function GetSpawnPosition(playerObj)
--	DebugMessage("A")
	local spawnPosition = FindObjectWithTag("SpawnPosition")
	if(spawnPosition) then
		--DebugMessage("B")
		return spawnPosition:GetLoc(), spawnPosition:GetRotation().Y
	else
		--DebugMessage("C")
		local subregion = GetSubregionName()
		if(subregion and subregion ~= "") then			
			local regionName = "Subregion-"..subregion
			--DebugMessage("D",regionName,tostring(GetRegion(regionName)),tostring(GetRandomPassableLocation(regionName,true)))
			local spawnLoc = GetRandomPassableLocation(regionName,true)
			if(spawnLoc) then
				return spawnLoc, 0
			end		
		end
	end

	return Loc(0,0,0), 0
end

-- This function is called by the core engine before it sends any given object to the users' client
-- It allows you to override the cloaked property of an object
TRAP_DISTANCE_PER_SKILL = 0.3
function ShouldSeeCloakedObject(user, targetObj)
	
	if(user == nil) then 
		--DebugMessage("nil user")
		return false 
	end
	if(targetObj == nil) then 
		--DebugMessage("nil target")
		return false end
	
		
	if (not targetObj:IsCloaked()) then
		return true
	end
	
	if (targetObj:HasObjVar("AlwaysInvisible")) then
		return false
	end

	if( IsImmortal(user) ) then
		--DebugMessage("immortal")
		return true
	end

	if( user:HasObjVar("SeeInvis") ) then
		--DebugMessage("see invis")
		return true
	end

	if (targetObj:HasObjVar("VisibleToAll") ) then
		--DebugMessage("visible to all")
		return true
	end
	
	if (targetObj:HasObjVar("IsGhost")) then
		--DebugMessage("IsGhost")
		--if (user:HasObjVar("IsGhost") or user:HasObjVar("CanSeeGhosts")) then
			return true
		--else
		--	return false
		--end
	end

	if (targetObj:HasObjVar("VisibleToDeadOnly")) then
		if (IsDead(user)) then
			return true
		else
			return false
		end
	end

	if (targetObj:HasObjVar("IsTrap")) then
		--DFB TODO: WHEN RANGER SKILL IS IMPLEMENTED, USE THAT INSTEAD
		local skillLevel = GetSkillLevel(user,"RogueSkill")
		if (targetObj:DistanceFrom(user) < skillLevel * TRAP_DISTANCE_PER_SKILL) then
			return true
		else
			return false
		end
	end

	--DebugMessage(targetObj:GetName() .. " Can See Eval")
	local canSeeList = targetObj:GetObjVar("CanSeeMeList")
	if(canSeeList ~= nil) then
	--	DebugTable(canSeeList)
		local canSee = canSeeList[user]
		if(canSee ~= nil) then 
	--	DebugMessage(user:GetName() .. " Can See " .. targetObj:GetName())
			return true 
		end
	end
	--DebugMessage("CanSee")
	--DebugTable(canSeeList)
	--DebugMessage("----")
	--DebugMessage(user:GetName() .. " Cannot See " .. targetObj:GetName())
			
	return false
end

function CanUseCase(user, targetObj, useCase)
	if(useCase.Restrictions ~= nil) then
		if(type(useCase.Restrictions) ~= "table") then
			if(type(useCase.Restrictions) == "string") then				
				useCase.Restrictions = {useCase.Restrictions}
			else
				DebugMessage("CanUseCase: Invalid restrictions!")
				return false
			end
		end

		for i,restrictionEntry in pairs(useCase.Restrictions) do
			-- add restriction code here
			if(restrictionEntry == "HasObject") then
				if( targetObj:TopmostContainer() ~= user ) then
					return false
				end
			elseif(restrictionEntry == "TargetIsHuman") then
				if (not IsHuman(target)) then
					return false
				end
			elseif (restrictionEntry == "TargetIsDead") then
				if (not target:IsMobile()) then
					return false
				end
				if (not IsDead(targetObj)) then
					return false
				end
			elseif(restrictionEntry == "ContainerIsEmpty") then
				if (targetObj:IsContainer()) then
					local objectsInContainer =  targetObj:GetContainedObjects()
					if #objectsInContainer > 0 then
						return false
					end
				end
			elseif(restrictionEntry == "OwnsContainedHouse") then
				local topCont = targetObj:TopmostContainer() or targetObj
				if(not(IsGod(user)) and not(IsHouseOwnerForLoc(user,topCont:GetLoc())) )then
					return false
				end
			elseif(restrictionEntry == "NotInHouse") then
				local topCont = targetObj:TopmostContainer() or targetObj
				if (HasHouseAtLoc(topCont:GetLoc())) then
					return false
				end
			elseif(restrictionEntry == "HasKey") then
				if not(GetKey(user,targetObj)) then
					return false
				end
			elseif(restrictionEntry == "IsImmortal") then
				if not(IsImmortal(user)) then
					return false
				end
			elseif(restrictionEntry == "IsGod") then
				if not(IsGod(user)) then
					return false
				end
			elseif(restrictionEntry == "IsController") then
				if not(IsController(user,targetObj) ) then
					return false
				end
			elseif(restrictionEntry == "IsSelf") then
				if(targetObj ~= user) then
					return false
				end
			end
		end
	end

	return true
end

function CanHarvest(objRef)
	return objRef:GetObjVar("HandlesHarvest") == true or objRef:HasObjVar("ResourceSourceId")
end

-- Return a list of options for interacting with the specified object
-- each option is an array containing the display name and the return id
-- NOTE: empty string is the default id 
function GetObjectInteractionList(user, targetObj)
	local menuItems = {}
	
	local isPermanent = targetObj:IsPermanent()
	if(isPermanent) then
		local sourceId = targetObj:GetSharedObjectProperty("ResourceSourceId")
		if(sourceId ~= nil) then
			if(sourceId:match("Tree")) then
				table.insert(menuItems,"Chop")	
			elseif(sourceId:match("Rock")) then
				table.insert(menuItems,"Mine")
			else
				table.insert(menuItems,"Harvest")
			end
		end
	else	
		local useCases = targetObj:GetObjVar("UseCases") or {}
		-- DAB TODO: Should you be able to interact with mobiles while in combat?	
		if ( targetObj:IsMobile() ) then
			local isDead = IsDead(targetObj)
			if ( IsPlayerCharacter(targetObj) ) then
				local groupId = GetGroupId(user)
				if ( targetObj ~= user ) then
					if ( groupId == nil ) then
						local targetGroupId = GetGroupId(targetObj)
						if ( targetGroupId == nil ) then
							table.insert(menuItems, "Invite to Group")
						end
					else
						-- if they are in a group you have to be the leader to invite/kick
						local leader = GetGroupVar(groupId, "Leader")
						if ( leader ~= nil ) then
							if ( leader == user ) then
								local targetGroupId = GetGroupId(targetObj)
								if ( targetGroupId == nil ) then
									table.insert(menuItems, "Invite to Group")
								elseif ( targetGroupId == groupId ) then
									table.insert(menuItems, "Kick from Group")
								end
							end
						end
					end

					table.insert(menuItems,"Trade")

					-- if they are in a guild and their target is not, let them attempt to invite
					if (
						targetObj:GetObjVar("Guild") == nil
						and
						user:GetObjVar("Guild") ~= nil
					) then
						table.insert(menuItems,"Invite to Guild")
					end
				else
					if ( groupId ~= nil ) then
						table.insert(menuItems, "Group")
					end
				end
				
				--table.insert(menuItems,"Duel")
			else
				if(isDead) then					
					-- else check to see if you can harvest
					--or chop off their head
					if(CanHarvest(targetObj)) then
						table.insert(menuItems,"Harvest")
					end
					if (targetObj:HasObjVar("lootable") or targetObj:HasObjVar("HasPetPack")) then	
						table.insert(menuItems,"Open Pack")
						table.insert(menuItems,"Loot All")
					end
					if (IsHuman(targetObj)) then
						table.insert(menuItems,"Cut Off Head")
					end
				else
					if ( not targetObj:HasObjVar("merchantOwner") and not targetObj:HasObjVar("itemOwner") ) then
						if (
							(
								(
									IsMount(targetObj)
									and
									GetPetSlots(targetObj) <= ServerSettings.Pets.MaxSlotsToAllowDismiss
								)
								or
								(
									IsGod(user)
									and
									not TestMortal(user)
								)
							)
							and
							IsController(user,targetObj)
						) then
							table.insert(menuItems,"Dismiss")
						end
					end
				end
			end
			if not(isDead) then
				if(targetObj == user) then
					table.insert(menuItems, "Character")
				elseif ( IsPlayerCharacter(targetObj) or IsPet(targetObj) or IsDemiGod(user) ) then
					table.insert(menuItems, "Inspect")
				end

				if(targetObj ~= user and targetObj:GetMobileType() == "Friendly") then
					if (targetObj:GetName() ~= "Magical Guide") then
						table.insert(menuItems,"Interact")
					end
				end
			end
		else
			local equipSlot = GetEquipSlot(targetObj)
			if(CanHarvest(targetObj)) then
				table.insert(menuItems,"Harvest")
			-- DAB TODO: Handle special containers that arent meant to be opened
			-- DAB TODO: Handle containers that you have the key for
			elseif(targetObj:IsContainer() and not targetObj:HasObjVar("FakeContainer")) then
				table.insert(menuItems,"Open")
				if ((not targetObj:IsMobile()) or ((not IsDead(targetObj)) and targetObj:GetEquippedObject("Backpack") ~= nil)) then
					table.insert(menuItems,"Loot All")
				end
				--table.insert(menuItems,"Loot All")
			elseif(equipSlot ~= nil and equipSlot ~= "TempPack" and equipSlot ~= "Bank" and equipSlot ~= "Familiar") then
				if(targetObj:IsEquipped()) then
						table.insert(menuItems,"Unequip")
				elseif (targetObj:TopmostContainer() == user) then
					table.insert(menuItems,"Equip")
				end
			end

			-- this catches lazy scripters that add a use object message but dont add any use cases
			if (#useCases == 0) and (#menuItems == 0) and targetObj:HasEventHandler(EventType.Message,"UseObject") then
				table.insert(menuItems,"Use")
			end

			local objectWeight = targetObj:GetSharedObjectProperty("Weight") or -1
			if(objectWeight ~= -1) then
				table.insert(menuItems,"Pick Up")	
				local topCont = targetObj:TopmostContainer()
				if(topCont ~= user) then
					table.insert(menuItems,"Quick Loot")
				end
			elseif(IsGod(user)) then
				table.insert(menuItems,"God Pick Up")	
			end
		end
		if (IsGod(user) and EDITMODE == false) then
			table.insert(menuItems,"God Info")
		end
		if(useCases ~= nil and (#useCases > 0)) then
			for i,useCase in pairs(useCases) do
				if(CanUseCase(user,targetObj,useCase)) then
					table.insert(menuItems,useCase.MenuStr)
				end
			end
		end
	end	

	if (#menuItems == 0) then
		return
	end

	return menuItems
end

--- Cache the region address to avoid a call out of lua for a simple value
_baseGetRegionAddress = GetRegionAddress
_cachedRegionAddress = nil
function GetRegionAddress()
	local cached = _cachedRegionAddress
	if ( cached == nil ) then
		cached = _baseGetRegionAddress()
		_cachedRegionAddress = cached
	end
	return cached
end