-- Handles the resource requests for animal corpses
-- Initializer variables:
--    MeatType - resource type for meat
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

function HarvestParts(user)	
	local resourcesToCreate = {}
	local animalPartsDict = this:GetObjVar("AnimalParts")
	local backpackObj = this:GetEquippedObject("Backpack")
	if(backpackObj) then
		local partCount = 0
		if(animalPartsDict) then
			for i,partInfo in pairs(animalPartsDict) do				
				local count = partInfo.Count or 1
				if( count > 0 ) then
			        local templateId = ResourceData.ResourceInfo[partInfo.ResourceType].Template
			        local dropPos = GetRandomDropPosition(backpackObj)
			    	CreateObjInContainer(templateId, backpackObj, dropPos, "create_part", partInfo.Count)	    
			    	partCount = partCount + partInfo.Count
				end
			end
		end

		local meatCount = this:GetObjVar("MeatCount") or 0
		if(meatCount > partCount) then
			local meatType = this:GetObjVar("MeatType")
			local templateId = ResourceData.ResourceInfo[meatType].Template
			local dropPos = GetRandomDropPosition(backpackObj)
	    	CreateObjInContainer(templateId, backpackObj, dropPos, "create_part", partCount - meatCount)	    
		end
		
		if(partCount > 0 or meatCount > 0) then
			user:SystemMessage("You harvest some materials from the corpse.","info")
			backpackObj:SendOpenContainer(user)
			this:SetObjVar("lootable",true) 
			SetDefaultInteraction(this,"Open Pack")
		else
			user:SystemMessage("You were not able to harvest anything","info")
			SetDefaultInteraction(this,"Use")
		end
	end

	this:DelObjVar("ResourceSourceId")
	this:DelObjVar("HandlesHarvest")
	CallFunctionDelayed(TimeSpan.FromSeconds(3),function ( ... )
		this:DelModule("animal_parts")
	end)	
end

RegisterEventHandler(EventType.CreatedObject,"create_part",
	function (success,objRef,count)
		if(success and count > 1) then
			RequestSetStack(objRef,count)
		end
	end)

RegisterSingleEventHandler(EventType.ModuleAttached,"animal_parts",
	function()
		local meatCount = 0
		local partsCount = 0

		if( initializer ~= nil ) then
			if( initializer.MeatType ~= nil and initializer.MeatType ~= "" ) then
				this:SetObjVar("MeatType",initializer.MeatType)
			end
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
		--local success, resourceType, countRemaining = RetrieveResource(user)
		HarvestParts(user)

		--requester:SendMessage("RequestResourceResponse",success,user,resourceType,this,countRemaining)
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
			if not(this:GetEquippedObject("Backpack")) then
				CreateEquippedObj("coffin",this)
			end
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