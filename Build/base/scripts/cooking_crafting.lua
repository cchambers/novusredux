require 'incl_container'
require 'container'

function CanOpen(user)
    if (IsImmortal(user)) then
        return true
    end    

    local topmostObj = this:TopmostContainer() or this
    --Make sure we can reach object
    if(topmostObj:GetLoc():Distance(user:GetLoc()) > OBJECT_INTERACTION_RANGE ) then    
        user:SystemMessage("You cannot reach that.")  
        return false
    end

    if not(user:HasLineOfSightToObj(topmostObj,ServerSettings.Combat.LOSEyeLevel)) then 
        user:SystemMessage("[FA0C0C]You cannot see that![-]")
        return false
    end
    
    --if so return true
    return true
end

function DoCook(user,heatSource)
	if(user == nil) then return end

	if(heatSource == nil) then
		heatSource = FindObject(SearchHasObjVar("HeatSource",OBJECT_INTERACTION_RANGE),user)
	end
		
	if(heatSource == nil or user:DistanceFrom(heatSource) > OBJECT_INTERACTION_RANGE) then
		user:SystemMessage("[$1779]")
		return
	end

	local cont = this:TopmostContainer() or this
	if(cont ~= user) then
		user:SystemMessage("[$1780]")
		return 
	end        

	local conts = this:GetContainedObjects()
	if(conts == nil or (#conts < 1)) then 
		user:SystemMessage("[F7CC0A]There is nothing in the pot.[-]")
		return
	end

	StartCooking(user, heatSource)
end

RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if(usedType == "Open" or usedType == "Use") then         
            if( CanOpen(user) ) then
                this:SendOpenContainer(user)
            end
		elseif(usedType == "Cook") then
			DoCook(user)
		end
	end)

RegisterEventHandler(EventType.Message, "CookOverFire", 
	function(user,heatSource)
		DoCook(user,heatSource)
	end)

function StartCooking(chef, fire)
	CookFood(chef, this)
end

RegisterEventHandler(EventType.Message, "CreateCookedItems", function(user, resourceType, amount)
	local createId = "cooking_"..uuid()
	RegisterSingleEventHandler(EventType.CreatedObject, createId,
		function(success, objRef, amount)
			if success then
				if amount > 1 then
					RequestSetStack(objRef,amount)
				end
				SetItemTooltip(objRef)
			end
		end)
	local canCreateInBag, reason = CreateObjInBackpackOrAtLocation(user, FoodStats.BaseFoodStats[resourceType].Template, createId, amount)
end)

--RegisterEventHandler(EventType.CreatedObject, "craftedItem", HandleCraftedItemCreated)

RegisterSingleEventHandler(EventType.ModuleAttached, "cooking_crafting",
	function()
		SetTooltipEntry(this,"cooking","Used to cook stew.")
		AddUseCase(this,"Cook")
	end)
