
GoodEatWords = {
	"Yummy!",
	"Mmmmm",
	"Tasty!",
	"Good!",
	"Yum",
	"Delicious!"
}

BadEatwords = {
    "Yuck!",
    "Gross",
    "Disgusting",
    "Ewwww",
    "Horrible!",
    "Nasty!"
}

function CompleteEatFood(player, isGross)
    if ( isGross ) then
        player:SystemMessage(BadEatwords[math.random(1,#BadEatwords)], "info")
    else
        player:SystemMessage(GoodEatWords[math.random(1,#GoodEatWords)], "info")
    end
end

--- Attempts to eat food
-- @param player mobileObj
-- @param resourceType string
-- @param object you are eating
-- @return true or false (success/fail)
function TryEatFood(player, resourceType, resourceObj)
    if ( player == nil or IsDead(player) ) then return false end

    if ( resourceType == nil or FoodStats.BaseFoodStats[resourceType] == nil ) then
        player:SystemMessage("That is not food.", "info")
        return false
    end

    local foodClass = FoodStats.BaseFoodStats[resourceType].FoodClass

    -- prevent eating food marked as raw
	if ( FoodStats.BaseFoodStats[resourceType].Raw ) then
		player:SystemMessage("That is raw, cook it first.", "info")
		return false
	end

    if not( ConsumeResourceBackpack(player, resourceType, 1) ) then
        player:SystemMessage("Cannot consume what you do not have.", "info")
        return false
    end

    if(FoodStats.BaseFoodStats[resourceType].DrugEffect) then
        player:PlayLocalEffect(player,FoodStats.BaseFoodStats[resourceType].DrugEffect,FoodStats.BaseFoodStats[resourceType].DrugDuration)
    end
    
    CompleteEatFood(player, FoodStats.BaseFoodStats[resourceType].Gross)
	
    return true
end

function GetFoodTooltipTable(resourceType, tooltipInfo)
    tooltipInfo = tooltipInfo or {}

    if ( resourceType and FoodStats.BaseFoodStats[resourceType] ~= nil ) then

        if ( FoodStats.BaseFoodStats[resourceType].Raw ) then
            tooltipInfo.FoodClass = {
                TooltipString = "Raw",
                Priority = 40,
            }
        end

        if ( FoodStats.BaseFoodStats[resourceType].Gross ) then
            tooltipInfo.FoodClass = {
                TooltipString = "Gross",
                Priority = 50,
            }
        end

        local foodClass = FoodStats.BaseFoodStats[resourceType].FoodClass or "Ingredient"

        -- add what kind of food item it is
        tooltipInfo.FoodClass = {
            TooltipString = foodClass,
            Priority = 100,
        }
        
        local replenish = FoodStats.BaseFoodStats[resourceType].Replenish or FoodStats.BaseFoodClass[foodClass].Replenish or 2
        if ( replenish > 0 ) then
            tooltipInfo.Replenish = {
                TooltipString = "Eat to regain health and stamina. Entering Combat will remove the effect.",
                Priority = 20,
            }
        end

        -- add side effects
        if ( FoodStats.BaseFoodStats[resourceType].DrugEffect ) then
            if ( FoodStats.BaseFoodStats[resourceType].DrugEffect == "DrunkenEffect" ) then
                tooltipInfo.SideEffect = {
                    TooltipString = "Drunk Side Effects",
                    Priority = -1
                }
            else
                tooltipInfo.SideEffect = {
                    TooltipString = "Side Effects",
                    Priority = -1
                }
            end
        end

    end

    return tooltipInfo
end

function UpdateWaterContainerState(item,state)
    --DebugMessage("HEY "..tostring(item))
    state = state or item:GetObjVar("State") or "Empty"

    local originalName = item:GetObjVar("OriginalName")
    if not(originalName) then
        originalName = item:GetName()
        item:SetObjVar("OriginalName",originalName)
    end

    local stateStr = state or "Empty"
    local nameStr,color = StripColorFromString(originalName)
    local nameStr = state.." "..nameStr
    if(color) then
        nameStr = color..nameStr.."[-]"
    end
    item:SetName(nameStr)
    item:SetObjVar("State",state)

    if(state == "Empty") then
        RemoveUseCase(item,"Drink")
        AddUseCase(item,"Fill",true)
    elseif(state == "Full") then
        AddUseCase(item,"Drink",true)
        RemoveUseCase(item,"Fill")
    end
end