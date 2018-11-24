

Currencies = {
	coins = 1,
	KhoToken = 12,
}

function GetItemBaseBonusValueMod(item)
	return 0
end

function GetResourceValue(resourceTemplate,item)	
	if(resourceTemplate ~= nil) then
		-- no explicit price for this base tempalte so lets
		-- extrapolate from the resource values		

		local recipeTable = GetRecipeForBaseTemplate(resourceTemplate)
		if(recipeTable ~= nil) then
			local canUseResourceMethod = true
			local baseRet = 0
			local material = nil
			if(item) then 
				material = GetItemCraftedMaterial(item,recipeTable)
			end

			local resourceTable = GetQualityResourceTable(recipeTable.Resources,material)
			if(resourceTable == nil) then
				DebugMessage("WARNING: Recipe based item has invalid resource table "..tostring(quality),tostring(recipeTable.DisplayName),resourceTemplate)				
			else
				for resourceName,recipeAmount in pairs (resourceTable) do
					if(ResourceData.ResourceInfo[resourceName] ~= nil) then
						local templateName = ResourceData.ResourceInfo[resourceName].Template
						if(CustomItemValues[templateName] ~= nil) then
							baseRet = baseRet + (CustomItemValues[templateName] * recipeAmount)
						else
							-- attempt to get the value from the raw resource
							local resValue = GetResourceValue(templateName)
							if(resValue > 0) then
								baseRet = baseRet + (resValue * recipeAmount)
							else
								-- if one or more of the resources do not have a value specified we can not use this method
								canUseResourceMethod = false
								DebugMessage("WARNING: Recipe based item contains a resource which has no CustomItemValue "..tostring(resourceType),templateName)
							end
						end
					else
						canUseResourceMethod = false
						DebugMessage("WARNING: Recipe based item contains a resource which has no Resource entry in ResourceData.ResourceInfo table. "..resourceName,recipeTable.DisplayName)
					end
				end

				if(recipeTable.StackCount) then
					baseRet = baseRet / recipeTable.StackCount
				end

				if(canUseResourceMethod) then
					--DebugMessage("Price evaluation from resources "..baseRet,itemBaseTemp,quality)
					return baseRet
				end
			end
		end		
	end

	return 0
end

function GetBaseItemValue(item)
	-- first check for custom value by template id
	--LuaDebugCallStack("tf")
	local itemTemplateId = item:GetCreationTemplateId()
	if(itemTemplateId == nil) then
		DebugMessage("WARNING: Item has no creation template! "..tostring(item:GetName()))
		return 0
	end
	
	if (item:HasObjVar("Worthless")) then
		return 0 
	end

	if (item:GetObjVar("ResourceType") == "PackedObject") then
		itemTemplateId = item:GetObjVar("UnpackedTemplate")
	end

	local purchaseTemplate = item:GetObjVar("PurchaseTemplate")
	if (purchaseTemplate) then
		itemTemplateId = purchaseTemplate
	end

	if ( item:IsValid() and ( item:HasObjVar("lockObject") or item:HasObjVar("lockUniqueId") ) ) then
		return 0
	end

	if (item:HasObjVar("Valuable")) then
		return item:GetObjVar("Valuable")
	end
	
	if( CustomItemValues[itemTemplateId] ~= nil ) then
		return CustomItemValues[itemTemplateId]
	end

	local templateId = item:GetObjVar("CraftedTemplate") or itemTemplateId
	local resourceValue = GetResourceValue(templateId,item)
	if(resourceValue > 0) then
		local durRatio = 1
		local dur = item:GetObjVar("Durability")
		local maxDur = GetMaxDurabilityValue(item)			
		if (dur ~= nil and maxDur ~= 0 ) then
			durRatio = dur/maxDur
		end
		
		return resourceValue * durRatio
	end

	return 0
end

function GetStaticItemValue(itemName)
	for i, price in pairs(CustomItemValues) do
		if (i == itemName) then 
		return price end
	end
	return nil
end

function GetCurrencyValue(currency)
	return Currencies[currency]
end

function GetItemValue(item,currency)
	currency = currency or "coins"
	--DebugMessage("ItemValue",tostring(item),GetBaseItemValue(item),GetItemBaseBonusValueMod(item))
	return math.ceil((GetBaseItemValue(item) + GetItemBaseBonusValueMod(item))/GetCurrencyValue(currency))
end