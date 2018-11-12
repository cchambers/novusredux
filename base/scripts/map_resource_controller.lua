require 'incl_resource_source'
require 'incl_regions'

RESOURCE_SPAWN_RATE_SECS = 30
DEPLETION_UPDATE_FREQ = 10
RARE_RESOURCE_DECAY_TIME_SECS = 6 * 60 * 60

--[ Begin Permanent Resources ]--
-- Permanent resources are harvested from map objects which always exist on the map

permanentSourceData = nil

-- NOTE: this only works for rare resources. the default ones are not tracked if they are not depleted
function CountResourceId(resourceId)
	local count = 0
	for objRef, resourceEntry in pairs(permanentSourceData) do
		if( resourceEntry.resourceId == resourceId ) then
			count = count + 1
		end
	end
end

-- finds the first dynamic resource region entry this object applies to and return the info
function GetDynamicResourceSourceInfo(resourceRegions,objRef,sourceId)	
	for i,regionSources in pairs(resourceRegions) do
		if(regionSources[sourceId] and (not(regionSources.Region) or regionSources.Region == "Global" or objRef:IsInRegion(regionSources.Region))) then
			return regionSources[sourceId]
		end
	end
end

function UpdateDepletion(objRef,depletionAmount,user,resourceRegions)
	if(objRef.Id == 0) then
		DebugMessage("ERROR: [UpdateDepletion] Invalid permanent id! (0)")
		return false,nil,"Error"
	end

	-- get our resource static info, if it doesnt exist then success is false
	--DebugMessage("Update Depletion: " .. tostring(objRef) .. " -> " .. tostring(depletionAmount))
	if(depletionAmount == nil) then depletionAmount = 0 end
	local sourceId = GetResourceSourceId(objRef)
	local staticSourceInfo = nil
	if(sourceId) then
		staticSourceInfo = ResourceData.ResourceSourceInfo[sourceId]
	end

	if( staticSourceInfo == nil ) then
		DebugMessage("ERROR: Nil Source Info for Depletion ObjId: "..tostring(objRef.Id).." IsPermanent: "..tostring(objRef:IsPermanent()).." SourceId: "..tostring(sourceId))
		return false,nil,"Error"
	end

	-- retrieve the dynamic resource region info if its not passed in
	resourceRegions = resourceRegions or this:GetObjVar("ResourceRegions") or {}
	-- get the dynamic resource source info based on the region this object is in
	local dynamicSourceInfo = GetDynamicResourceSourceInfo(resourceRegions,objRef,sourceId)

	local depletionSuccess = true
	local failReason = nil
	local shouldUpdateResourceEntry = true

	-- retrieve the resource entry differently if its a permanent object or a dynamic
	local resourceEntry = nil
	if( objRef:IsPermanent() ) then
		resourceEntry = permanentSourceData[objRef] or { Depletion = 0 }
	else
		resourceEntry = objRef:GetObjVar("ResourceSourceData") or { Depletion = 0 }
	end

	local initialDepletion = resourceEntry.Depletion
	local sourceCount = 1
	if(dynamicSourceInfo) then
		sourceCount = dynamicSourceInfo.Count
	end

	-- if the resource type is overridden in the resource entry then this object is rare
	-- we dont regenerate rare resources
	local isRareResource = resourceEntry.ResourceType ~= nil
	local rareInfo = nil
	
	if( isRareResource ) then
		-- we can skip rare resources if we are not depleting since they do not regenerate
		if(depletionAmount == 0) then
			return false,nil,"NoRegen"
		end

		if not(dynamicSourceInfo) then
			DebugMessage("ERROR: Rare resource is missing it associated dynamicSourceInfo. "..tostring(objRef.Id).." IsPermanent: "..tostring(objRef:IsPermanent()).." SourceId: "..tostring(sourceId))
			return false,nil,"Error"
		end

		rareInfo = dynamicSourceInfo.RareResources[resourceEntry.ResourceType]

		if(rareInfo ~= nil and rareInfo.Count ~= nil) then
			sourceCount = rareInfo.Count
		end
	end

	--DebugMessage("Update Depletion: " .. tostring(objRef) .. " -> " .. tostring(depletionAmount))

	-- check to see if we have enough skill to harvest this
	if(user ~= nil and staticSourceInfo.SkillRequired ~= nil) then		
		local minSkill = staticSourceInfo.MinSkill
		if( isRareResource and rareInfo ~= nil and rareInfo.MinSkill ~= nil) then
			minSkill = rareInfo.MinSkill
		end

		if(minSkill ~= nil and GetSkillLevel(user,staticSourceInfo.SkillRequired) < minSkill) then
			return false,nil,"MinSkill:"..minSkill
		end
	end

	-- only regen if it has a regen rate, it has been accessed, depletion > 0, and not rare
	local shouldRegen = dynamicSourceInfo ~= nil 
	        and dynamicSourceInfo.RegenRate ~= nil 
			and resourceEntry.Depletion > 0
			and resourceEntry.LastAccessSecs ~= nil 
			and not(isRareResource)

	--DebugMessage("Depletion start "..tostring(resourceEntry.Depletion))
	-- update the depletion value based on regen rate and time passed since last access
	local curTimeSecs = ServerTimeMs() / 1000.0
	if( shouldRegen ) then
		local elapsedSecs = curTimeSecs - resourceEntry.LastAccessSecs
		local regenCount = dynamicSourceInfo.RegenRate * elapsedSecs
		--DebugMessage("Regen "..tostring(elapsedSecs)..", "..tostring(regenCount))
		resourceEntry.Depletion = math.max(0,resourceEntry.Depletion - regenCount)
	end

	--DebugMessage("New Depletion: " .. tostring(objRef) .. " -> " .. tostring(resourceEntry.Depletion))

	-- update our last access time
	resourceEntry.LastAccessSecs = curTimeSecs

	-- get the resource type before we update the record (in case it changes as a result of the depletion)
	-- the resource entry can override the default type and count for rare resources
	local resourceType = resourceEntry.ResourceType or staticSourceInfo.ResourceType
	local resourceCount = resourceEntry.Count or sourceCount

	-- attempt to deplete the resource if requested
	-- regenerating means the resource was fully depleted and is being regenerated back to full value
	--DebugMessage(resourceType .. "   -=-=-=-=- " .. resourceEntry.Depletion)
	if((depletionAmount > 0) and (resourceEntry.Depletion <= resourceCount) and not(resourceEntry.Regenerating) ) then
		--DebugMessage("Depletion event "..tostring(resourceCount))
		--DebugMessage("Depletion Amount: " .. tostring(depletionAmount))
		resourceEntry.Depletion = resourceEntry.Depletion + depletionAmount
	else
		depletionSuccess = false
		failReason = "Depleted"
	end

	--DebugMessage("Initiating depletions state change.")
	-- if our depletion actually changed
	depletionVal = resourceEntry.Depletion
	if( depletionVal ~= initialDepletion ) then
		--DebugMessage("Depletion changed.")
		-- if we've been fully depleted
		--DebugMessage("depletionVal is " .. tostring (depletionVal) .. " sourceCount is " ..tostring(sourceCount))
		if( depletionVal >= sourceCount ) then
			--DebugMessage("Actually Depleted.")
			-- should we destroy on deplete (only works on dynamic sources)
			-- NOTE: the controller will automatically handle the respawning of these sources
			if( not(objRef:IsPermanent()) and staticSourceInfo.DestroyWhenDepleted ) then
				objRef:Destroy()
				-- dont bother updating the resource entry since we are destroying the source
				shouldUpdateResourceEntry = false
			else
				--DebugMessage("Beginning depletion.")
				-- if we are a rare resource, we need to revert back to the default
				if( isRareResource ) then
					--DebugMessage("---- Rare resource depleted, reverting to default ResourceType: "..resourceEntry.ResourceType)
					resourceEntry.ResourceType = nil
					isRareResource = false
				end

				resourceEntry.Regenerating = true
				--DebugMessage("Regenerating.")
				-- update the visual state
				if( staticSourceInfo.DepletedState ~= nil ) then
					--DebugMessage("Setting Visual State")
					objRef:SetVisualState(staticSourceInfo.DepletedState)
				else
					--DebugMessage("Setting to default, visual state is nil.")
					objRef:SetVisualState("Default")
				end
			end
		-- if we've fully regenerated
		elseif( depletionVal == 0 ) then
			if( staticSourceInfo.DepletedState ~= nil ) then
				objRef:SetVisualState("Default")
			end
		end
	end

	--DebugMessage("Depletion result "..tostring(resourceEntry.Depletion))	

	-- update the source data
	
	-- we keep rare resources in the table even if they are not depleted
	if( shouldUpdateResourceEntry ) then
		if( objRef:IsPermanent() ) then
			--DebugMessage("Updating permanent.")
			if( resourceEntry.Depletion == 0 and not(isRareResource)) then
				--DebugMessage("Clearing.")
				permanentSourceData[objRef] = nil
			else	
				--DebugMessage(DumpTable(resourceEntry))
				permanentSourceData[objRef] = resourceEntry
			end
		else
			if( resourceEntry.Depletion == 0 and not(isRareResource)) then
				objRef:DelObjVar("ResourceSourceData")
			else
				objRef:SetObjVar("ResourceSourceData",resourceEntry)
			end
		end
	end

	return depletionSuccess, resourceType, failReason, sourceCount - depletionVal
end

function DoRareResourceDecay()
	local sourceDataModified = false
	for objRef, sourceEntry in pairs(permanentSourceData) do
		if( sourceEntry.SpawnTime ~= nil and (ServerTimeMs() - sourceEntry.SpawnTime) > (RARE_RESOURCE_DECAY_TIME_SECS * 1000) ) then
			objRef:SetVisualState("Default")
			permanentSourceData[objRef] = nil
			sourceDataModified = true
		end
	end

	if(sourceDataModified) then
		this:SetObjVar("permanentSourceData",permanentSourceData)
	end
end

-- We cache the searches for resource sources that have rare resources since they never change
rareSearchers = {  }
function GetRareSearcher(regionName,sourceId)
	local searcher = nil
	
	if not(rareSearchers[regionName]) then
		rareSearchers[regionName] = {}
	end

	searcher = rareSearchers[regionName][sourceId]
	if not(searcher) then
		if(regionName == "Global") then
			searcher = FindPermanentObjects(PermanentObjSearchSharedStateEntry("ResourceSourceId",sourceId))
		else
			searcher = FindPermanentObjects(PermanentObjSearchMulti{
	            PermanentObjSearchRegion(regionName),
	            PermanentObjSearchSharedStateEntry("ResourceSourceId",sourceId)})
	    end
        rareSearchers[regionName][sourceId] = searcher
	end
	return searcher
end

function DoRareResourceCheck()			
	local resourceRegions = this:GetObjVar("ResourceRegions")
	if(resourceRegions ~= nil) then
		local permanentSourceDataDirty = false

		-- go through all the resource regions ("Global" includes the entire map)
		for i,regionSources in ipairs(resourceRegions) do
			-- go through all the resource sources for this region
			for sourceId, sourceInfo in pairs(regionSources) do
				-- if there are rare resources specified for this source
				if(type(sourceInfo) == "table" and sourceInfo.RareResources) then					
					-- find all the permanents in this resource region with the given source id 
					local regionName = regionSources.Region or "Global"
					local sourceObjs = GetRareSearcher(regionName,sourceId)
					-- if we found matching permanents
					if(#sourceObjs > 0) then
						-- go through each of the rare versions
						for rareSourceId, rareSourceInfo in pairs(sourceInfo.RareResources) do				
							if not(ResourceData.ResourceSourceInfo[sourceId].RareResources[rareSourceId]) then
								DebugMessage("ERROR: Rare resource does not exist in source info table. "..tostring(rareSourceId))
							else
								-- AvailablityPct is the fully spawned percentage of this area that is that resource type
								if(rareSourceInfo.AvailablityPct > 0) then
									--DebugMessage("---- DoRareResourceCheck sourceId: "..sourceId.." ResourceType: "..rareSourceId)

									-- get the total number of sources on the map that should be rare
									local rareCount = math.floor(#sourceObjs * (rareSourceInfo.AvailablityPct/100.0))

									-- count the existing rares
									local existingCount = 0
									for objRef, sourceEntry in pairs(permanentSourceData) do
										if( sourceEntry.ResourceType == rareSourceId and sourceEntry.ResourceRegion == regionName) then
											existingCount = existingCount + 1
										end
									end

									-- if we need more then we spawn one
									--DebugMessage("Should",tostring(regionName),tostring(rareSourceId),tostring(existingCount),tostring(rareCount))
									if( existingCount < rareCount ) then
										--DebugMessage("---- DoRareResourceCheck searching")
										local maxTries = 20
										local found = false
										local resultObj = nil
										while(maxTries > 0 and not(resultObj)) do
											local testObj = sourceObjs[math.random(1,#sourceObjs)]
											-- TODO Only respawn if no players nearby
											if( permanentSourceData[testObj] == nil and testObj:GetVisualState() ~= "Hidden") then
												--DebugMessage("---- DoRareResourceCheck found Obj")
												resultObj = testObj
											else
												maxTries = maxTries - 1
											end
										end

										if( resultObj ~= nil ) then										
											--DebugMessage("---- Spawning rare resource ResourceType: "..rareSourceId.." Loc: "..tostring(resultObj:GetLoc()).." ResourceRegion: "..regionName)
											permanentSourceData[resultObj] = { ResourceType = rareSourceId, Count = rareSourceInfo.Count or 1, Depletion = 0, SpawnTime = ServerTimeMs(), ResourceRegion = regionName }
											permanentSourceDataDirty = true
											-- Get the visual state from the static resource source data										
											local visualState = ResourceData.ResourceSourceInfo[sourceId].RareResources[rareSourceId].VisualState
											if(visualState ~= nil) then
												resultObj:SetVisualState(visualState)
											end										
										end
									end
								end
							end
						end
					end
				end
			end
		end

		if(permanentSourceDataDirty) then
			this:SetObjVar("permanentSourceData",permanentSourceData)	
		end
	end
end

function DoSpawnedSourceCheck(sourceType,sourceEntry)
	--DebugMessage("----- DoSpawnedSourceCheck: "..tostring(sourceType))
	-- first validate
	if( not(sourceType) or not(sourceEntry.Region) or not(sourceEntry.MaxCount) ) then
		--DebugMessage("sourceType is "..tostring(sourceType))
		--DebugMessage("region is "..tostring(sourceEntry.Region))
		--DebugMessage("MaxCount is "..tostring(sourceEntry.MaxCount))
		return
	end

	if( ResourceData.ResourceSourceInfo[sourceType] == nil or ResourceData.ResourceSourceInfo[sourceType].SourceTemplate == nil) then
		--DebugMessage("Opting out - SourceType is "..tostring(sourceType))
		return
	end	

	--DebugMessage("----- DoSpawnedSourceCheck checking old sources")
	
	local spawnedCount = 0
	local oldSpawnedSourceObjs = this:GetObjVar(sourceType..sourceEntry.Region.."SpawnedObjs")
	if( oldSpawnedSourceObjs ~= nil ) then
		--DebugMessage("----- DoSpawnedSourceCheck 1")
		local updatedSpawnedSourceObjs = {}
		-- validate existing objs
		for i, sourceObj in pairs(oldSpawnedSourceObjs) do
			if( sourceObj:IsValid() ) then
				table.insert(updatedSpawnedSourceObjs,sourceObj)
				spawnedCount = spawnedCount + 1
			--else
			--	DebugMessage("----- DoSpawnedSourceCheck found invalid sourceobj")
			end
		end
		if( #oldSpawnedSourceObjs ~= #updatedSpawnedSourceObjs ) then
			--DebugMessage("----- DoSpawnedSourceCheck updating spawnedobjs")
			this:SetObjVar(sourceType..sourceEntry.Region.."SpawnedObjs",updatedSpawnedSourceObjs)
		end
	end

	--DebugMessage("----- DoSpawnedSourceCheck spawnedCount: "..tostring(spawnedCount)..", "..tostring(sourceEntry.MaxCount))

	-- spawn any we are missing
	if(spawnedCount < sourceEntry.MaxCount) then
		local failed = false
		while(spawnedCount < sourceEntry.MaxCount and not(failed)) do
			local excludedRegions = {"NoHousing"}
			local spawnLoc = GetRandomPassableLocation(sourceEntry.Region,true, excludedRegions)
			if( spawnLoc ~= nil ) then
				local sourceTemplate = ResourceData.ResourceSourceInfo[sourceType].SourceTemplate
				--DebugMessage("----- DoSpawnedSourceCheck of "..sourceTemplate.." spawning at: "..tostring(spawnLoc))
				CreateObj(sourceTemplate, spawnLoc, "spawned_source", sourceEntry)
				spawnedCount = spawnedCount + 1
			else
				DebugMessage("ERROR: FAILED TO SPAWN "..this:GetCreationTemplateId().." | "..DumpTable(sourceEntry))
				failed = true
			end
		end
	end		
end

RegisterEventHandler(EventType.Message,"RequestResource",
	function (requester,user,objRef,depletionAmount)		

		if(depletionAmount == nil) then depletionAmount = 0 end
		--DebugMessage("UPDATING DEPLETION")
		local success, resourceType, failReason, countRemaining = UpdateDepletion(objRef,depletionAmount,user)
		--DebugMessage("RequestResource",tostring(success),tostring(resourceType),tostring(failReason))
		requester:SendMessage("RequestResourceResponse",success,user,resourceType,objRef,countRemaining,failReason)
	end)

RegisterEventHandler(EventType.Timer,"UpdateDepletion",
	function ()		
		-- timer should never fire before loaded event
		if not(permanentSourceData) then
			DebugMessage("[map_resource_controller] UpdateDepletion fired before loaded event.")
			return
		end

		-- this is an optimization to avoid getting the dynamic resource region info every time we call update depletion
		local resourceRegions = this:GetObjVar("ResourceRegions")
		for objRef,entry in pairs(permanentSourceData) do
			-- do not update the depletion on hidden trees (under houses)
			if(objRef:GetVisualState() ~= "Hidden") then				
				UpdateDepletion(objRef,0,nil,resourceRegions)
			end
		end
		this:SetObjVar("permanentSourceData",permanentSourceData)	
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(DEPLETION_UPDATE_FREQ),"UpdateDepletion")
	end)

RegisterEventHandler(EventType.Timer,"DoResourceSpawns",
	function()
		-- timer should never fire before loaded event
		if not(permanentSourceData) then
			DebugMessage("[map_resource_controller] DoResourceSpawns fired before loaded event.")
			return
		end

		-- schedule the timer first in case an exception gets thrown
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(RESOURCE_SPAWN_RATE_SECS),"DoResourceSpawns")

		-- decay rare resources
		DoRareResourceDecay()

		-- First: check to see if we need to convert any permanent resources into their rare versions
		-- go through all the resource sources and find ones that need to have some rare resources
		-- this happens if it has resource ids other than the "Default"
		-- the max count must be specified so the controller knows how many there should be on the map
		DoRareResourceCheck()
		
		-- Next: spawn any spawned resources that are not at their max
		local spawnedSourceData = this:GetObjVar("SpawnedSources")
		if( spawnedSourceData ~= nil ) then
			for sourceType, sourceEntry in pairs(spawnedSourceData) do
				DoSpawnedSourceCheck(sourceEntry.Resource,sourceEntry)
			end
		end				
	end)

RegisterEventHandler(EventType.CreatedObject, "spawned_source",
	function(success,objRef,sourceEntry)
		if( success ) then
			--DebugMessage("----- DoSpawnedSourceCheck resource created: "..tostring(sourceType))
			local spawnedSourceObjs = this:GetObjVar(sourceEntry.Resource..sourceEntry.Region.."SpawnedObjs") or {}
			table.insert(spawnedSourceObjs,objRef)
			this:SetObjVar(sourceEntry.Resource..sourceEntry.Region.."SpawnedObjs",spawnedSourceObjs)
			objRef:AddModule("spawn_decay")
		end
	end)

function OnLoad()
	permanentSourceData = this:GetObjVar("permanentSourceData") or {}
	--DebugMessage("LOADING DATA Rare Entry Count",CountTable(permanentSourceData))

	this:ScheduleTimerDelay(TimeSpan.FromSeconds(DEPLETION_UPDATE_FREQ),"UpdateDepletion")
	this:FireTimer("DoResourceSpawns")	
end

RegisterEventHandler(EventType.ModuleAttached,"map_resource_controller",
	function ()
		-- store initializer data
		if( initializer ~= nil and initializer.SpawnedSources ~= nil ) then
			this:SetObjVar("SpawnedSources",initializer.SpawnedSources)
		end

		if( initializer ~= nil and initializer.ResourceRegions ~= nil ) then
			this:SetObjVar("ResourceRegions",initializer.ResourceRegions)
		end

		OnLoad()
	end)

RegisterEventHandler(EventType.LoadedFromBackup,"",
	function ( ... )
		OnLoad()
	end)