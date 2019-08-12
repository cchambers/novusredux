require 'container'

function CanOpen(user)
    if (IsImmortal(user)) then
        return true
    end 
    local topmostObj = this:TopmostContainer() or this

    if not (IsInBackpack(this,user)) then
    	user:SystemMessage("Cooking pot must be in your backpack to use.","info")
    	return false
    end

    --Make sure we can reach object
    if(topmostObj:GetLoc():Distance(user:GetLoc()) > OBJECT_INTERACTION_RANGE ) then    
        user:SystemMessage("You cannot reach that.","info")  
        return false
    end

    if not(user:HasLineOfSightToObj(topmostObj,ServerSettings.Combat.LOSEyeLevel)) then 
        user:SystemMessage("[FA0C0C]You cannot see that![-]","info")
        return false
    end
    
    --if so return true
    return true
end

--[[
function DoCook(user,heatSource)
	if(user == nil) then return end

	if(heatSource == nil) then
		heatSource = FindObject(SearchHasObjVar("HeatSource",OBJECT_INTERACTION_RANGE),user)
	end

	if not (IsInBackpack(this, user)) then
		user:SystemMessage("Cooking pot must be in your backpack to use.","info")
    	return
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
		user:SystemMessage("[F7CC0A]There is nothing in the pot.[-]","info")
		return
	end

	StartCooking(user, heatSource)
end
]]--
OverrideEventHandler("NOS:container",EventType.Message, "UseObject", 
	function (user,usedType)
		if(usedType == "Open" or usedType == "Use") then   
            if( CanOpen(user) ) then
                --this:SendOpenContainer(user)
                ShowCookingWindow(user)
            end
		end
	end)

--[[
RegisterEventHandler(EventType.Message, "CookOverFire", 
	function(user,heatSource)
		DoCook(user,heatSource)
	end)

function StartCooking(chef, fire)
	CookFood(chef, this)
end
]]--


function ShowCookingWindow(user)
	local dynWindow = DynamicWindow("CookingWindow","",256,296,-240,-100,"TransparentDraggable","Center")
	dynWindow:AddContainerScene(0,0,256,256,this)
	dynWindow:AddButton(192, 64,"CloseButton","",18,18,"","",true,"CloseSquare")
	dynWindow:AddImage(32,256,"TextFieldChatUnsliced",192,40,"Sliced")
	dynWindow:AddButton(64,265 ,"CookButton","Start Cooking",128,18,"","",false,"")

	user:OpenDynamicWindow(dynWindow)
end

--RegisterEventHandler(EventType.CreatedObject, "craftedItem", HandleCraftedItemCreated)

RegisterSingleEventHandler(EventType.ModuleAttached, "cooking_crafting",
	function()
		SetTooltipEntry(this,"cooking","Used to cook a variety of different recipes.")
		--AddUseCase(this,"Cook")
	end)

RegisterEventHandler(EventType.DynamicWindowResponse,"CookingWindow",
    function (user,buttonId)
	    if( buttonId == 0 ) then return end
	    if( user == nil or not(user:IsValid())) then return end

	    if (buttonId == "CloseButton") then
	    	user:CloseDynamicWindow("CookingWindow")
	    elseif(buttonId == "CookButton") then
	    	if not (HasMobileEffect(user, "CookingPot") ) then
	    		user:SendMessage("StartMobileEffect", "CookingPot", this)
	    	end
	    end
	end)