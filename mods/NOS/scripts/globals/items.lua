-- This affects the price merchants will buy/sell items with durability for
-- and the amount of resources required to craft and the amount salvaged
DURABILTY_VALUE_MULTIPLIER = 5

OBJECT_INTERACTION_RANGE = 5

DEFAULT_DURABILITY = 5

containerDropAreas = 
{ 
	Backpack = { min = Loc(-0.5,0.0,-0.31),
                 max = Loc(0.5,2.0,-0.31) },

	Chest =    { min = Loc(-0.5,0.1,-0.8),
                 max = Loc(0.5,0.1,-0.3) },

    BoneChest ={ min = Loc(-0.6,0.3,-0.8),
                 max = Loc(0.6,0.3,-0.2) },

    Crate =    { min = Loc(-0.3,0.1,-0.6),
				 max = Loc(0.35,0.1,0.4) },

	Lockbox =  { min = Loc(-0.3,0,-0.6),
				 max = Loc(0.4,0,-0.2) },

	Pouch =    { min = Loc(-0.4,1.1,-0.5),
				 max = Loc(0.5,-0.1,0.4) },

	Coffin =  { min = Loc(-0.4,1.2,-0.4),
                max = Loc(0.4,1.2,0.6) },

    Trade =   { min = Loc(-0.5,0.0,-0.31),
                max = Loc(0.5,2.0,-0.31) }
}


function GetRandomInRange(min, max)
	return min + (math.random() * (max - min))
end

function CanHaveDurability(item)
	if (item == nil) then LuaDebugCallStack("nil item provided to CanHaveDurability") end
	if not((item:HasObjVar("ArmorClass")) or (item:HasObjVar("ShieldClass")) or (item:HasObjVar("WeaponType")) or (item:HasModule("tool_base")) or (item:HasModule("harvest_tool_base"))) then
		--DebugMessage(item:GetName() .. " Cannot Have Durability")
		return false
	end
	return true
end

--[[function MoveEquipmentToGround(target)
	local backpackObj = this:GetEquippedObject("Backpack")
    local leftHand = this:GetEquippedObject("LeftHand")
    local rightHand = this:GetEquippedObject("RightHand")
    local chest = this:GetEquippedObject("Chest")
    local legs = this:GetEquippedObject("Legs")
    local head = this:GetEquippedObject("Head")
    leftHand:SetWorldPosition(this:GetLoc()+Loc(math.random()-0.5,0,math.random()-0.5))
    rightHand:SetWorldPosition(this:GetLoc()+Loc(math.random()-0.5,0,math.random()-0.5))
    chest:SetWorldPosition(this:GetLoc()+Loc(math.random()-0.5,0,math.random()-0.5))
    legs:SetWorldPosition(this:GetLoc()+Loc(math.random()-0.5,0,math.random()-0.5))
    head:SetWorldPosition(this:GetLoc()+Loc(math.random()-0.5,0,math.random()-0.5))
	local lootObjects = backpackObj:GetContainedObjects()
	for i,j in pairs(lootObjects) do 
		--DebugMessage("Yes it's happening")
		j:SetWorldPosition(this:GetLoc()+Loc(math.random()-0.5,0,math.random()-0.5))
	end
end--]]

function GetRandomDropPositionForContainerType(containerType)
	local dropArea = containerDropAreas[containerType]
	if( dropArea == nil ) then
		--DebugMessage("GetRandomDropPosition returning 0")
		return Loc(0,0,0)
	end

	local dropLoc = Loc(GetRandomInRange(dropArea.min.X,dropArea.max.X),
			   GetRandomInRange(dropArea.min.Y,dropArea.max.Y),
		       GetRandomInRange(dropArea.min.Z,dropArea.max.Z))

	return dropLoc
end

-- return a random valid location inside the given container
function GetRandomDropPosition(containerObj)
	-- default to backpack
	local containerType = containerObj:GetSharedObjectProperty("ContainerWindowType") or "Backpack"

	return GetRandomDropPositionForContainerType(containerType)
end

function IsLockedDown(targetObj)
	return targetObj:HasObjVar("LockedDown")
end

function CreateObjInCarrySlot(target,template,eventId,...)
	CreateObjInContainer(template, target, Loc(0,0,0), eventId, ...)
end

function CreateObjInBackpack(target,template,eventId,...)
	local backpackObj = target:GetEquippedObject("Backpack")
	-- TODO: Verify creation success and refund money on failure
	if( target ~= nil and backpackObj ~= nil and template ~= nil ) then
		local randomLoc = GetRandomDropPosition(backpackObj)
		backpackObj:SendOpenContainer(target)
		CreateObjInContainer(template, backpackObj, randomLoc, eventId, ...)	
		return true
	end

	return false
end

function CreateStackInBackpack(target,template,amount,eventId,...)
	local backpackObj = target:GetEquippedObject("Backpack")
	
	if( target ~= nil and backpackObj ~= nil and template ~= nil ) then
		local templateData = GetTemplateData(template)
		if(templateData) then
			local randomLoc = GetRandomDropPosition(backpackObj)
			backpackObj:SendOpenContainer(target)
			
			if not(templateData.ObjectVariables) then templateData.ObjectVariables = {} end
			templateData.ObjectVariables.StackCount = amount

			CreateCustomObjInContainer(template, templateData, backpackObj, randomLoc, eventId, ...)	
			return true
		end
	end

	return false
end

function CreateStackInBank(target,template,amount,eventId,...)
	local bankObj = target:GetEquippedObject("Bank")
	
	if( target ~= nil and bankObj ~= nil and template ~= nil ) then
		local templateData = GetTemplateData(template)
		if(templateData) then
			local randomLoc = GetRandomDropPosition(bankObj)
			--bankObj:SendOpenContainer(target)
			
			if not(templateData.ObjectVariables) then templateData.ObjectVariables = {} end
			templateData.ObjectVariables.StackCount = amount
			CreateCustomObjInContainer(template, templateData, bankObj, randomLoc, eventId, ...)	
			return true
		end
	end

	return false
end

function HasItemInBackpack(target,searchTemplate)
	local backpackObj = target:GetEquippedObject("Backpack")

	if( target == nil or backpackObj == nil or searchTemplate == nil ) then
		return false
	end

	lootObjects = backpackObj:GetContainedObjects()
   	for index, lootObj in pairs(lootObjects) do	    		
   		if(lootObj:GetCreationTemplateId() == searchTemplate ) then
   			return true
   		end
   	end

   	return false
end

function HasItem(target,searchTemplate)
	
	if( target == nil or searchTemplate == nil ) then
		return false
	end

	local equippedObjects = target:GetAllEquippedObjects()
	for index,equippedItem in pairs(equippedObjects) do
		if (equippedItem:GetCreationTemplateId() == searchTemplate) then
			return true
		end
	end

	if (HasItemInBackpack(target,searchTemplate)) then
		return true
	end

   	return false
end

function GetItem(target,searchTemplate)
	
	if( target == nil or searchTemplate == nil ) then
		return nil
	end

	local equippedObjects = target:GetAllEquippedObjects()
	for index,equippedItem in pairs(equippedObjects) do
		if (equippedItem:GetCreationTemplateId() == searchTemplate) then
			return equippedItem
		end
	end

	local backpackObj = target:GetEquippedObject("Backpack")

	if( backpackObj == nil ) then
		return nil
	end

	lootObjects = backpackObj:GetContainedObjects()
   	for index, lootObj in pairs(lootObjects) do	    		
   		if(lootObj:GetCreationTemplateId() == searchTemplate ) then
   			return lootObj
   		end
   	end

   	return nil
end

function HasItemInBackpack(target,searchTemplate)
	local backpackObj = target:GetEquippedObject("Backpack")

	if( target == nil or backpackObj == nil or searchTemplate == nil ) then
		return false
	end

	lootObjects = backpackObj:GetContainedObjects()
   	for index, lootObj in pairs(lootObjects) do	    		
   		if(lootObj:GetCreationTemplateId() == searchTemplate ) then
   			return true
   		end
   	end

   	return false
end

function HasItem(target,searchTemplate)
	
	if( target == nil or searchTemplate == nil ) then
		return false
	end

	local equippedObjects = target:GetAllEquippedObjects()
	for index,equippedItem in pairs(equippedObjects) do
		if (equippedItem:GetCreationTemplateId() == searchTemplate) then
			return true
		end
	end

	if (HasItemInBackpack(target,searchTemplate)) then
		return true
	end

   	return false
end

function GetItemUserAction(target,user)
	local resourceType = target:GetObjVar("ResourceType")
	if(resourceType ~= nil) then
		local itemName = target:GetObjVar("SingularName") or target:GetName()

		return {
			ID=resourceType,
			ActionType="Resource",
			DisplayName=itemName,
			Icon="LighterSlotIcon",
			IconObject=target:GetIconId(),
			IconObjectColor=target:GetColor(),
			IconObjectHue=target:GetHue(),
			Enabled=true,
			ServerCommand="useresource " .. resourceType,
		}
	else
		local actionType = "Object"
		local serverCommand = "use " .. target.Id

		local equipSlot = GetEquipSlot(target)
		if( GetEquipSlot(target) ~= nil 
				and GetEquipSlot(target) ~= "Backpack" 
				and GetEquipSlot(target) ~= "TempPack" 
				and GetEquipSlot(target) ~= "Bank") then
			actionType="Equipment"
			serverCommand="equip " .. target.Id
		end

		return {
			ID=tostring(target.Id),
			ActionType=actionType,
			DisplayName=target:GetName(),
			Icon="LighterSlotIcon",
			IconObject=target:GetIconId(),
			IconObjectColor=target:GetColor(),
			IconObjectHue=target:GetHue(),
			Enabled=true,
			ServerCommand=serverCommand
		}
	end
end

-- Key functions that must be global since they are used by the engine callback (Use cases)

function GetKeyRing(user)
	return user:GetObjVar("KeyRing")
end

function KeyMatches(key,lockUniqueId)
	--Check if key has same lock id and if key actually is a key instead of box
	return ( lockUniqueId ~= nil and key:GetObjVar("lockUniqueId") == lockUniqueId and key:HasModule("key"))
end

function GetKey(user,lockObject)
    if(user ~= nil and lockObject ~= nil and user:IsValid() and lockObject:IsValid()) then
    	local lockUniqueId = lockObject:GetObjVar("lockUniqueId")
    	
    	-- first check keyring
    	local keyRing = GetKeyRing(user)
    	if(keyRing ~= nil and keyRing:IsValid()) then
    		local keyObj = FindItemInContainerRecursive(keyRing,function(item)
	    				return KeyMatches(item,lockUniqueId)
					end)
    		
	    	if(keyObj) then
	    		return keyObj
	    	end
	    end

	    local backpackObj = user:GetEquippedObject("Backpack")
	    if(backpackObj ~= nil and backpackObj:IsValid()) then
	    	local keyObj = FindItemInContainerRecursive(backpackObj,function(item)
	    				return KeyMatches(item,lockUniqueId)
					end)
	    		
	    	if(keyObj) then
	    		return keyObj
	    	end	    	
	    end
	end
	return nil
end

function GetCreationWeight(template,amount)
	amount = amount or 1
	local templateWeight = GetTemplateObjectProperty(template,"Weight") or -1
	if(templateWeight ~= -1 and amount > 1) then
		local unitWeight = GetTemplateObjVar(template,"UnitWeight") or 1
		templateWeight = math.ceil(math.max(1,amount*unitWeight))
	end

	return templateWeight
end

-- get the weight of a single unity of this object (intended for stackables)
function GetUnitWeight(targetObj,amount)
	if(targetObj == nil or not targetObj:IsValid()) then
		return 0
	end
	
	if(not(IsStackable(targetObj))) then
		return GetWeight(targetObj) * amount
	else
		local stackCount = GetStackCount(targetObj)
		-- DAB TODO: Should we assume the unitweight is 1?
		local singleWeight = targetObj:GetObjVar("UnitWeight") or 1
		return singleWeight * amount
	end
end

function GetRandomLootItemIndex(availableItems)
	-- get total weight
	local totalWeight = 0
	for index,item in pairs(availableItems) do
		local weight = item.Weight or 1
		totalWeight = totalWeight + weight
	end

	local roll = math.random(1,totalWeight)
	--DebugMessage("Total Chance: "..totalChance.." Roll: "..roll)
	local curCount = 0
	for index,item in pairs(availableItems) do
		local weight = item.Weight or 1
		--DebugMessage("Cur Chance: "..(tostring(curCount + item.Chance)))
		if( roll <= curCount + weight ) then
			return index
		end
		curCount = curCount + weight
	end
end

-- rolls chance for each item to get a filtered list of
-- items to perform the weight roll
function FilterLootItemsByChance(lootItems)
	local availableItems = {}
	for index, lootEntry in pairs(lootItems) do
		if( lootEntry.Template ~= nil or lootEntry.Templates ~= nil ) then
			local chance = lootEntry.Chance or 100
			local roll = math.random(1,10000)
			if( roll <= (chance * 100) ) then
				table.insert(availableItems, lootEntry)
			end
		end
	end

	return availableItems
end


--- Hook function to set the tooltip of an item, should be called on creation ( like loot and crafting n stuff )
-- @param item gameObj
-- @param noUseCases boolean By default, use cases are applied. Set this to true to prevent that.
function SetItemTooltip(item, noUseCases)
	local tooltipInfo = {}

	-- add the blessed/cursed item property
	if ( item:HasObjVar("Blessed") ) then
		if ( item:HasObjVar("Cursed") ) then
			tooltipInfo.Blessed = {
				TooltipString = "Cursed",
				Priority = 999999,
			}
		else
			tooltipInfo.Blessed = {
				TooltipString = "Blessed",
				Priority = 999999,
			}
		end
	end

	-- add Executioner info
	local executioner = item:GetObjVar("ExecutionerLevel")
	local named = item:GetObjVar("Identified") or item:HasModule("imbued_weapon")
	if ( executioner ~= nil and not(named) ) then
		local name = GetTemplateObjectName(item:GetCreationTemplateId())
		name = tostring(name .. " of " .. ServerSettings.Executioner.LevelString[executioner or 1])
		item:SetName(name)
	end
	
	-- add the maker's mark
	if ( ServerSettings.Crafting.MakersMark.Enabled and item:HasObjVar("CraftedBy") ) then
		tooltipInfo.MakersMark = {
			TooltipString = "\n" .. string.format(ServerSettings.Crafting.MakersMark.MakersMark, item:GetObjVar("CraftedBy")),
			Priority = -8888,
		}
	end

	-- add player merchant prices
	local price = item:GetObjVar("itemPrice")
	if ( price and price > 0 ) then
		tooltipInfo.item_price = {
			TooltipString = "Price: "..ValueToAmountStr(price).."\n",
			Priority = 100,
		}
	end

	-- add equipment tooltips
	tooltipInfo = GetEquipmentTooltipTable(item, tooltipInfo)

	-- default weapons/armor to double click to equip
	local slot = item:GetSharedObjectProperty("EquipSlot")
	if ( slot ~= nil and slot ~= "TempPack" and slot ~= "Bank" and slot ~= "Familiar" and slot ~= "Mount" and not item:IsContainer() ) then
		item:SetSharedObjectProperty("DefaultInteraction", "Equip")
	end

	local resourceType = item:GetObjVar("ResourceType")
	if ( resourceType ) then
		-- add resource tooltips
		tooltipInfo = GetResourceTooltipTable(resourceType, tooltipInfo, item)
		-- add food tooltips
		tooltipInfo = GetFoodTooltipTable(resourceType, tooltipInfo)

		-- by default add the use cases
		if ( noUseCases ~= true ) then
			ApplyResourceUsecases(item, resourceType)
		end

		CallResourceInitFunc(item, resourceType)
	end
	
	if ( tooltipInfo ) then
		for id,data in pairs(tooltipInfo) do -- ensure there's at least one entry.
			SetTooltip(item, tooltipInfo)
			return
		end
	end
end