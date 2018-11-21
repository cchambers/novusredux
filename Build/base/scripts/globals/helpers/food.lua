
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

--- Attempts to eat food, will update Hunger system
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

    local hunger = player:GetObjVar("Hunger") or 0    
	if ( hunger < 1 and foodClass ~= "Refreshment" ) then
		player:SystemMessage("You are too full to consume that.", "info")
		return false
	end

    if ( FoodStats.BaseFoodStats[resourceType].Replenish == 0 ) then
        player:SystemMessage("You try some "..resourceType.." and get nothing out of it.", "info")
        return false
    end

    if ( FoodStats.BaseFoodStats[resourceType].Gross and hunger < ServerSettings.Hunger.Threshold ) then
		player:SystemMessage("You are not hungry enough to consume that.", "info")
        return false
    end

    if not( ConsumeResourceBackpack(player, resourceType, 1) ) then
        player:SystemMessage("Cannot consume what you do not have.", "info")
        return false
    end

    if(FoodStats.BaseFoodStats[resourceType].DrugEffect) then
        player:PlayLocalEffect(player,FoodStats.BaseFoodStats[resourceType].DrugEffect,FoodStats.BaseFoodStats[resourceType].DrugDuration)
    end
    
    player:SendMessage("HungerUpdate", - ( FoodStats.BaseFoodStats[resourceType].Replenish or FoodStats.BaseFoodClass[FoodStats.BaseFoodStats[resourceType].FoodClass].Replenish ) )
    if ( FoodStats.BaseFoodStats[resourceType].Gross ) then
        player:SystemMessage(BadEatwords[math.random(1,#BadEatwords)], "info")
    else
        player:SystemMessage(GoodEatWords[math.random(1,#GoodEatWords)], "info")
    end
	
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

        -- add what kind of food item it is
        tooltipInfo.FoodClass = {
            TooltipString = FoodStats.BaseFoodStats[resourceType].FoodClass,
            Priority = 100,
        }

    end

    return tooltipInfo
end