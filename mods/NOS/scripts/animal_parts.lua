-- Handles the resource requests for animal corpses
-- Initializer variables:
--    MeatType - resource type for meat
--    MeatCount - the amount of animal meat that can be harvested from this source
--    AnimalParts - an array of rare animal parts that can be harvested Format:
--          ResourceType - resource type for rare part
--          RarityPct - percent chance to get item with average skill
--          Count (default 1) - number of resource available to be harvested

local function CheckAmount(harvestingSkill, amount)
	-- Quick handling of edge case of bosses dropping 7 vile leather on harvest.
	if (amount <= 5) then
		if (harvestingSkill > 90) then
			local maxBonus = math.floor((harvestingSkill / 200) * amount)
			--DebugMessage("CheckAmount:    amount: "..tostring(amount)..", harvestingSkill: "..tostring(harvestingSkill)..", maxBonus: "..tostring(maxBonus))
			-- For some reason amount can come in at a negative value.. safety check on it.
			if (maxBonus < 0) then
				return amount
			end
			local additional = math.random(0, maxBonus)
			return amount + additional
		end
	end
	return amount
end

function CleanupModule()
	this:DelObjVar("ResourceSourceId")
	this:DelObjVar("HarvestToolType")
	this:DelObjVar("HandlesHarvest")
	this:DelObjVar("HarvestCount")

	this:DelModule("animal_parts")

	if (this:GetSharedObjectProperty("DefaultInteraction") ~= "Open Pack") then
		if (this:HasObjVar("lootable")) then
			this:SetSharedObjectProperty("DefaultInteraction", "Loot")
		else
			this:SetSharedObjectProperty("DefaultInteraction", "Use")
		end
	end
end

function HarvestParts(user)
	local resourcesToCreate = {}
	local animalPartsDict = this:GetObjVar("AnimalParts")
	local backpackObj = this:GetEquippedObject("Backpack")
	local harvestingSkill = GetSkillLevel(user, "HarvestingSkill")
	local resource = {}
	if (backpackObj) then
		local partCount = 0
		if (animalPartsDict) then
			for i, partInfo in pairs(animalPartsDict) do
				local count = partInfo.Count or 1
				if (count > 0) then
					resource = ResourceData.ResourceInfo[partInfo.ResourceType]
					if (resource == nil) then
						user:SystemMessage("Hey! This is bugged, please send a screenshot to Khi! <3", "info")
						DebugMessage("KHI! NIL RESOURCE")
						DebugMessage(partInfo.ResourceType)
						return false
					end
					local templateId = resource.Template
					local dropPos = GetRandomDropPosition(backpackObj)

					-- Used to see if any extra's are given thanks to the harvesting skill.
					local amount = CheckAmount(harvestingSkill, count)
					CreateObjInContainer(templateId, backpackObj, dropPos, "create_part", amount)
					partCount = partCount + count
				--DebugMessage("templateId: "..tostring(templateId)..", amount: "..tostring(amount)..", partCount: "..tostring(partCount)..", resourceType: "..tostring(partInfo.ResourceType))
				end
			end
		end

		local meatCount = this:GetObjVar("MeatCount") or 0
		local meatAmount = CheckAmount(harvestingSkill, meatCount)
		--DebugMessage("Meat:   partCount: "..tostring(partCount)..", meatCount: "..tostring(meatCount)..", meatAmount: "..tostring(meatAmount))
		if (meatAmount > partCount) then
			local meatType = this:GetObjVar("MeatType") or "MysteryMeat"
			local templateId = ResourceData.ResourceInfo[meatType].Template
			local dropPos = GetRandomDropPosition(backpackObj)

			-- Used to see if any extra's are given thanks to the harvesting skill.
			--local amount = CheckAmount(user, partCount - meatAmount)
			CreateObjInContainer(templateId, backpackObj, dropPos, "create_part", meatAmount)
		end

		if (partCount > 0 or meatAmount > 0) then
			user:SystemMessage("You harvest some materials from the corpse.", "info")
			backpackObj:SendOpenContainer(user)
			this:SetObjVar("lootable", true)

			local HarvestGateMin = resource.HarvestGateMin or 0
			local HarvestGateMax = resource.HarvestGateMax or 100
			local skipGains = false

			if ((harvestingSkill < HarvestGateMin) or (harvestingSkill > HarvestGateMax)) then
				skipGains = true
			end

			CheckSkillChance(user, "HarvestingSkill", harvestingSkill, 0.10, skipGains)
			SetDefaultInteraction(this, "Open Pack")
			user:SendMessage("CancelHarvesting",user)
			
			SetMobileMod(user, "Busy", "BusyHarvesting")
			user:DelObjVar("HarvestingTool")
			user:DelObjVar("IsHarvesting")
		else
			user:SystemMessage("You were not able to harvest anything", "info")
			SetDefaultInteraction(this, "Use")
			user:SendMessage("CancelHarvesting",user)
		end
	end

	this:DelObjVar("ResourceSourceId")
	this:DelObjVar("HandlesHarvest")
	CallFunctionDelayed(
		TimeSpan.FromSeconds(3),
		function(...)
			this:DelModule("animal_parts")
		end
	)
end

RegisterEventHandler(
	EventType.CreatedObject,
	"create_part",
	function(success, objRef, count)
		if (success and count > 1) then
			RequestSetStack(objRef, count)
		end
	end
)

RegisterSingleEventHandler(
	EventType.ModuleAttached,
	"animal_parts",
	function()
		local meatCount = 0
		local partsCount = 0

		if (initializer ~= nil) then
			if (initializer.MeatType ~= nil and initializer.MeatType ~= "") then
				this:SetObjVar("MeatType", initializer.MeatType)
			end
			if (initializer.MeatCount ~= nil and initializer.MeatCount > 0) then
				meatCount = initializer.MeatCount
				this:SetObjVar("MeatCount", initializer.MeatCount)
			end

			local mobParts = {}
			if (initializer.AnimalParts ~= nil) then
				for i, partInfo in pairs(initializer.AnimalParts) do
					--DebugMessage("Checking "..tostring(partInfo.ResourceType))
					local partCount = partInfo.Count or 1
					local droppedCount = 0
					for i = 1, partCount do
						local rarity = partInfo.RarityPct or 100
						local itemRoll = math.random(1, 100)
						local shouldGet = itemRoll <= rarity
						--DebugMessage("--Rolled "..tostring(itemRoll))
						if (shouldGet) then
							--DebugMessage("--Success")
							droppedCount = droppedCount + 1
						end
					end

					if (droppedCount > 0) then
						partInfo.Count = droppedCount
						table.insert(mobParts, partInfo)
						partsCount = partsCount + droppedCount
					end
				end
				this:SetObjVar("AnimalParts", mobParts)
			end
		end

		this:SetObjVar("HarvestCount", math.max(meatCount, partsCount))
	end
)

RegisterEventHandler(
	EventType.Message,
	"RequestResource",
	function(requester, user)
		--DebugMessage("AnimalParts RequestResource "..tostring(this:GetName()))
		--local success, resourceType, countRemaining = RetrieveResource(user)
		HarvestParts(user)

		--requester:SendMessage("RequestResourceResponse",success,user,resourceType,this,countRemaining)
	end
)

RegisterEventHandler(
	EventType.Message,
	"HasDiedMessage",
	function(args)
		-- this tells the harvest tool to send the resource request
		-- directly to the source (in this case this corpse)
		local harvestCount = this:GetObjVar("HarvestCount") or 0
		if (harvestCount > 0) then
			this:SetObjVar("ResourceSourceId", "AnimalParts")
			this:SetObjVar("HandlesHarvest", true)
			this:SetObjVar("HarvestToolType", "Knife")
			this:SetSharedObjectProperty("DefaultInteraction", "Harvest")
			if not (this:GetEquippedObject("Backpack")) then
				CreateEquippedObj("coffin", this)
			end
		end
	end
)

RegisterEventHandler(
	EventType.Message,
	"UseObject",
	function(user, usedType)
		if (usedType ~= "Harvest" and usedType ~= "Skin" and usedType ~= "Use") then
			return
		end

		if (this:HasObjVar("guardKilled") or (this:HasObjVar("HarvestCount") and this:GetObjVar("HarvestCount") <= 0)) then
			CleanupModule()
		else
			user:SendMessage("TryHarvest", this)
		end
	end
)
