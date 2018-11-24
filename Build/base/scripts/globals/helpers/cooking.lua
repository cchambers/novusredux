
--- Given a mobileObj and a cookingPot, will cook the best possible food for given ingredients, will perform durability loss checks.
-- @param chef mobileObj
-- @param cookingPot container
function CookFood(chef, cookingPot)
    if ( chef == nil or cookingPot == nil ) then return end

    local resourceType = GetBestFoodThatCanBeCooked(cookingPot)
    if ( resourceType and FoodStats.BaseFoodStats[resourceType] and FoodStats.BaseFoodStats[resourceType].Ingredients ) then
        -- determine how many of this resourceType can be made.
        local per = {}
        local contents = cookingPot:GetContainedObjects() or {}
        local ingredients = ConvertListToResourceTypeStackCountIngredients(contents)
        for type,count in pairs(FoodStats.BaseFoodStats[resourceType].Ingredients) do
            per[type] = (ingredients[type] or 0) / count
        end
        local min = 999999
        -- find the smallest amount (meaning this is the most they can make)
        for i,ii in pairs(per) do
            if ( ii < min ) then min = ii end
        end
        min = math.floor(min)

        --chef:NpcSpeech("I can make a max of "..min.." "..resourceType)

        -- check skill chance..
        local skillSuccess = CheckSkill(chef, "CookingSkill", 
            -- fall back on the food classes difficulty if this particular food doesn't have one set.
            FoodStats.BaseFoodStats[resourceType].CookingDifficulty or FoodStats.BaseFoodClass[FoodStats.BaseFoodStats[resourceType].FoodClass].CookingDifficulty
        )

        -- reuse old variable
        per = {}
        -- build a list of all ingredients to consume.
        for type,count in pairs(FoodStats.BaseFoodStats[resourceType].Ingredients) do
            per[type] = count * min
            -- on failure only consume a fraction.
            if not( skillSuccess ) then
                local fraction = math.floor(per[type] * 0.1)
                if (fraction > 1) then
                    per[type] = fraction
                end
            end
        end

        if ( ConsumeIngredients(per, contents) ) then
            if ( skillSuccess ) then
                local template = FoodStats.BaseFoodStats[resourceType].Template
                chef:SystemMessage("You have made "..min.." "..StripColorFromString(GetTemplateObjectName(template)), "info")
                chef:SendMessage("CreateCookedItems", chef, resourceType, min)
            else
                chef:SystemMessage("You fail, destroying some ingredients.", "info")
            end
            if ( Success(ServerSettings.Durability.Chance.OnToolUse) ) then
                AdjustDurability(cookingPot, -1)
            end
        else
            chef:SystemMessage("Those ingredients wouldn't make anything!", "info")
        end
    else
        chef:SystemMessage("Those ingredients wouldn't make anything!", "info")
    end
end

--- Consumes water from water containers
-- @param contents Array (container contents for example)
-- @param count number of water containers to empty
function ConsumeWater(contents,count)
    local foundCount = 0
    for i,item in pairs(contents) do
        if(item:GetObjVar("ResourceType") == "WaterContainer" and item:GetObjVar("State") == "Full") then
           UpdateWaterContainerState(item,"Empty") 
           foundCount = foundCount + 1
        end

        if(foundCount == count) then
            return
        end
    end
end

--- Given a Key/Value table of ResourceType/Amount, and a list of real objects (container contents for example), will remove that amount.
-- @param ingredients Table Key/Value ResourceType/Amount
-- @param contents Array (container contents for example)
function ConsumeIngredients(ingredients, contents)
    for type,count in pairs(ingredients) do
        if((type) == "Water") then
            ConsumeWater(contents,count)
        elseif not( ConsumeResource(contents, type, count) ) then
            return false
        end
    end
    return true
end

--- Determine if a given gameObj is an ingredient for cooking
-- @param item gameObj
-- @return true or false
function IsIngredient(item)
    if ( item ) then
        local resourceType = item:GetObjVar("ResourceType")
        if ( resourceType ~= nil) then
            if(FoodStats.BaseFoodStats[resourceType] ~= nil and FoodStats.BaseFoodStats[resourceType].FoodClass == "Ingredient" ) then
                return true
            end

            if(resourceType == "WaterContainer" and item:GetObjVar("State") == "Full") then
                return true
            end
        end
    end
    return false
end

--- given a list of items, will return a list of Key/Value ResourceType/StackCount of only ingredients
-- @param items lua table of gameObjs
-- @return lua table
function ConvertListToResourceTypeStackCountIngredients(items)
	local ingredients = {}

    -- build a list of all available ingredients as Key/Value ResourceType/StackCount
    for i,item in pairs(items) do
        local resourceType = item:GetObjVar("ResourceType")

        -- special case for water
        if( resourceType == "WaterContainer" and item:GetObjVar("State") == "Full") then
            resourceType = "Water"
        end

        if ( resourceType ) then
            ingredients[resourceType] = (ingredients[resourceType] or 0) + (GetStackCount(item) or 0)
        end
    end

    return ingredients
end

--- Given a cookingPot (or any container really) this function will return the best ResourceType that can made with the contents (decided by total number of ingredients required)
-- @param cookingPot container
-- @return ResourceType string
function GetBestFoodThatCanBeCooked(cookingPot)
    if ( cookingPot == nil ) then
        LuaDebugCallStack("[GetBestFoodThatCanBeCooked] Nil cooking pot provided.")
        return
    end
    local contents = cookingPot:GetContainedObjects() or {}
    -- no ingredients in cooking pot, no reason to continue
    if ( #contents < 1 ) then return nil end

    local ingredients = ConvertListToResourceTypeStackCountIngredients(contents)

    -- keep track of the data to return after traversing our static data, using value to give priorty to more 'expensive' food
    local value = 0
    local type = nil    

    -- loop all possible foods
    for resourceType,data in pairs(FoodStats.BaseFoodStats) do
        -- if the food can be made with ingredients
        if ( data.Ingredients ) then
            local found = 0
            local total = 0
            local thisValue = 0
            -- loop this food's ingredients
            for type,count in pairs(data.Ingredients) do
                total = total + 1
                -- if we have the neccessary amount, add to found count
                if ( (ingredients[type] or 0) >= count ) then
                    found = found + 1
                end
                -- build a value( total number of ingredients so we can pick best possible)
                thisValue = thisValue + count
            end

            if ( found == total and thisValue > value ) then
                -- ding ding ding we have a winner
                value = thisValue
                type = resourceType
            end
        end
    end

    -- return our best option or nil if nothing found
    return type
end