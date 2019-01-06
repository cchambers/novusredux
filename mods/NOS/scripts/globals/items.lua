
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
	local executioner = item:GetObjVar("Executioner")
	if ( executioner ~= nil ) then

		local name = item:GetName()
		name = name .. " of " .. string.format(ServerSettings.Executioner.LevelString[item:GetObjVar("ExecutionerLevel") or 1], executioner)
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