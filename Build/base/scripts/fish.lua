RegisterEventHandler(EventType.Message,"UseObject",
function (user,useCase)
	--DebugMessage(1)
	if (useCase == "Fillet") then
		if (this:TopmostContainer() ~= user) then
			user:SystemMessage("The item needs to be in your backpack to use it.")
			return 
		end
		if (not HasItem(user,"tool_hunting_knife") ) then
			user:SystemMessage("You need a hunting knife to fillet the fish.")
			return
		end
		local filletType = this:GetObjVar("FilletType") or "animalparts_fish_fillet"

		--local weight = this:GetSharedObjectProperty("Weight")
		local weight = GetUnitWeight(this, GetStackCount(this))
        local filletCount = GetStackCount(this) + math.floor(weight/2 + 1)

		local templateData = GetTemplateData(filletType)        
        local templateResourceType = templateData.ObjectVariables.ResourceType or "FishFillet"

        local backpackObj = user:GetEquippedObject("Backpack")
        if( backpackObj == nil ) then return end

        local canCreate = CanCreateItemInContainer(filletType, backpackObj, filletCount)

        if not (canCreate) then
    		CreateObj(filletType, user:GetLoc(), "fillet_fish", filletCount)
    		this:Destroy()
    		return
    	end

		local stackSuccess, stackObj = TryAddToStack(templateResourceType,backpackObj,filletCount)
        if not ( stackSuccess ) then
        	if (canCreate) then
        		CreateObjInBackpack(user,filletType,"fillet_fish",filletCount)
        	end
        else
        	this:Destroy()
        end
	end
end)

RegisterEventHandler(EventType.CreatedObject,"fillet_fish",function (success,objRef,amount)
	if (success) then
		if (objRef:TopmostContainer() == nil) then
			Decay(objRef)
		end

		SetItemTooltip(objRef)
		RequestSetStackCount(objRef,amount)
		this:Destroy()
	end
end)

--DebugMessage(2)
AddUseCase(this,"Fillet",true)