-- Handles the resource requests for animal corpses
-- Initializer variables:
--    MeatCount - the amount of animal meat that can be harvested from this source
--    AnimalParts - an array of rare animal parts that can be harvested Format:
--          ResourceType - resource type for rare part
--          RarityPct - percent chance to get item with average skill
--          Count (default 1) - number of resource available to be harvested

function CleanupModule()
	this:DelObjVar("ResourceSourceId")
	this:DelObjVar("HarvestToolType")
	this:DelObjVar("HandlesHarvest")
	this:DelObjVar("HarvestCount")	

	this:DelModule("animal_parts")	

	if (this:GetSharedObjectProperty("DefaultInteraction") ~= "Open Pack") then
		if(this:HasObjVar("lootable")) then
			this:SetSharedObjectProperty("DefaultInteraction","Loot")
		else
			this:SetSharedObjectProperty("DefaultInteraction","Use")
		end
	end
end

function RetrieveResource(user)
	local resourceType = nil
	local harvestCount = this:GetObjVar("HarvestCount") or 0
	if( harvestCount > 0 ) then	
		local animalPartsDict = this:GetObjVar("AnimalParts")	
		if( animalPartsDict ~= nil ) then
			for i,partInfo in pairs(animalPartsDict) do				
				local count = partInfo.Count or 1
				if( count > 0 ) then
					resourceType = partInfo.ResourceType
					partInfo.Count = partInfo.Count - 1
					break
				end
			end			
		end

		if(resourceType == nil) then
			local meatCount = this:GetObjVar("MeatCount") or 0
			if( meatCount > 0 ) then
				--DebugMessage("GOT MEAT NEW COUNT: "..tostring(meatCount))
				meatCount = meatCount - 1
				this:SetObjVar("MeatCount",meatCount)	
				resourceType = "AnimalMeat"			
			end
		else
			this:SetObjVar("AnimalParts",animalPartsDict)
		end		

		-- update harvest count
		harvestCount = harvestCount - 1
		-- nothing left to harvest, no longer a source
		if( harvestCount == 0 ) then			
			CleanupModule()	
		else
			this:SetObjVar("HarvestCount",harvestCount)
		end
	end

	--DebugMessage("RESOURCE TYPE "..tostring(resourceType))

	local success = resourceType ~= nil
	return success, resourceType, harvestCount
end

RegisterSingleEventHandler(EventType.ModuleAttached,"animal_parts",
	function()
		local meatCount = 0
		local partsCount = 0

		if( initializer ~= nil ) then
			if( initializer.MeatCount ~= nil and initializer.MeatCount > 0 ) then
				meatCount = initializer.MeatCount
				this:SetObjVar("MeatCount",initializer.MeatCount)
			end
			
			local mobParts = {}
			if( initializer.AnimalParts ~= nil ) then
				for i,partInfo in pairs(initializer.AnimalParts) do
					--DebugMessage("Checking "..tostring(partInfo.ResourceType))
					local partCount = partInfo.Count or 1
					local droppedCount = 0
					for i=1,partCount do
						local rarity = partInfo.RarityPct or 100
						local itemRoll = math.random(1,100)
						local shouldGet = itemRoll <= rarity
						--DebugMessage("--Rolled "..tostring(itemRoll))
						if( shouldGet ) then
							--DebugMessage("--Success")
							droppedCount = droppedCount + 1
						end
					end

					if(droppedCount > 0) then
						partInfo.Count = droppedCount
						table.insert(mobParts,partInfo)
						partsCount = partsCount + droppedCount
					end					
				end
				this:SetObjVar("AnimalParts",mobParts)
			end			
		end

		this:SetObjVar("HarvestCount",math.max(meatCount,partsCount))
	end)

RegisterEventHandler(EventType.Message,"RequestResource",
	function(requester, user)

		--DebugMessage("AnimalParts RequestResource "..tostring(this:GetName()))
		local success, resourceType, countRemaining = RetrieveResource(user)

		requester:SendMessage("RequestResourceResponse",success,user,resourceType,this,countRemaining)
	end)

RegisterEventHandler(EventType.Message,"HasDiedMessage",
	function(args)
		-- this tells the harvest tool to send the resource request 
		-- directly to the source (in this case this corpse)
		local harvestCount = this:GetObjVar("HarvestCount") or 0
		if( harvestCount > 0 ) then
			this:SetObjVar("ResourceSourceId","AnimalParts")
			this:SetObjVar("HandlesHarvest",true)		
			this:SetObjVar("HarvestToolType","Knife")
			this:SetSharedObjectProperty("DefaultInteraction","Harvest")
		end
	end)

RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
    	if(usedType ~= "Harvest" and usedType ~= "Skin" and usedType ~= "Use") then return end

		if( this:HasObjVar("guardKilled") or (this:HasObjVar("HarvestCount") and this:GetObjVar("HarvestCount") <= 0) ) then
			CleanupModule()			
		else
			user:SendMessage("TryHarvest",this)
		end
	end)