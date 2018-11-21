require 'incl_fishing'

RegisterSingleEventHandler(EventType.ModuleAttached, "tool_fishing_rod", 
    function()
        SetTooltipEntry(this,"fishing_use", "Used for catching fish.")
        --AddUseCase(this,"Fish",true,"HasObject")
    end)

fisher = nil

--[[function ValidateUse(user)
    if( user == nil or not(user:IsValid()) ) then
        return false
    end

    if( this:TopmostContainer() ~= user ) then
        user:SystemMessage("[$2640]")
        return false
    end

    if (user:HasTimer("fishingTimer")) then
        user:SystemMessage("You are already fishing.")
        return false
    end

    if (user:HasTimer("ReelSuccessTimer")) then
        user:SystemMessage("You are reeling in a fish!")
        return false
    end

    if (user:HasModule("base_fishing_controller")) then
        user:SystemMessage("You are already fishing.")
        return false
    end

    return true
end

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
        if(usedType ~= "Fish") then return end

        if not( ValidateUse(user) ) then return end
       --user:AddModule("base_fishing_controller")
    end)]]



        --local schoolsOfFish = FindObjects(SearchTemplate("school_of_fish",30),fisher)
        --DebugMessage("Fish found  " ..DumpTable(schoolsOfFish))
        --for i,j in pairs(schoolsOfFish) do
            -- local decayTime = j:GetTimerDelay("decay")
            --local fishPerc = 100-(decayTime.TotalSeconds % DEFAULT_DECAYTIME) / DEFAULT_DECAYTIME * 100
            --DebugMessage("fishPerc:"..tostring(fishPerc))
            --local roll = math.random(1,100)
            --DebugMessage("sizeOfFishRoll:"..tostring(roll))
                --medium fish
            --if (roll > fishPerc) then
            --    fisher:SystemMessage("You caught a large fish!")
            ----    --create the fish
            --    return
            --else
            --    fisher:SystemMessage("You caught a small fish!")
            --    --create the fish
            ---    return
            --end
        --end