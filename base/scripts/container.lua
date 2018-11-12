require 'incl_keyhelpers'

debugLogging = false

function CanOpen(user)
    if (IsImmortal(user)) then
        return true
    end
    
    if(GetCurrentModule() == "bank_box") then
        return false end

    local capacity = this:GetSharedObjectProperty("Capacity");
    if( capacity <= 0 ) then
        user:SystemMessage("You can't open that.","info")  
    	return false
    end

    local topmostObj = this:TopmostContainer() or this
    --Make sure we can reach object
    if(topmostObj:GetLoc():Distance(user:GetLoc()) > OBJECT_INTERACTION_RANGE ) then    
        user:SystemMessage("You cannot reach that.","info")  
        return false
    end

    if(topmostObj:IsMobile() and topmostObj ~= user and not(IsInPetPack(this,user,topCont,true)) and not(IsGod(user))) then
        user:SystemMessage("You can't open that.","info")  
        return false
    end

    if not(user:HasLineOfSightToObj(topmostObj,ServerSettings.Combat.LOSEyeLevel)) then 
        user:SystemMessage("You cannot see that!","info")
        return false
    end
    
    if (this:HasModule("merchant_sale_item")) then
        user:SystemMessage("You can't open that.","info")
        return false
    end

    if ((topmostObj ~= nil and (topmostObj:HasObjVar("noloot")) or this:HasObjVar("noloot"))) then 
        user:SystemMessage("You can't open that.","info")
        return false
    end

    if( this:HasObjVar("locked") ) then 
        local key = GetKey(user,this)
        if(key and key:GetObjVar("IsHouseKey") == true and this:GetObjVar("LockedDown") == true) then
             -- house keys allow a user to open and view contents without unlocking and rendering the container vulnerable
            user:SystemMessage("[$1770]","info")
        else
    	   user:SystemMessage("That appears to be locked.","info")
    	   return false
        end
    end
    --if so return true
    return true
end

function RefreshWeight()    
    if (this:HasModule("merchant_sale_item") or this:HasModule("hireling_merchant_sale_item")) then
        this:SetObjVar("LockDown",true)
        this:SetSharedObjectProperty("DenyPickup", true)
        return
    end
    
    local emptyWeight = this:GetObjVar("EmptyWeight") or -1
    if(emptyWeight ~= -1) then
        local totalWeight = emptyWeight
        for i,containedObj in pairs(this:GetContainedObjects()) do
            local containedObjWeight = GetWeight(containedObj)
            if(containedObjWeight and containedObjWeight ~= -1) then
                totalWeight = totalWeight + containedObjWeight
            end
        end
        
        this:SetSharedObjectProperty("Weight",totalWeight)        
    end    
end

function HandleContentsChanged()
	local contObjects = this:GetContainedObjects()

	if( this:HasSharedObjectProperty("NumItems") ) then
		this:SetSharedObjectProperty("NumItems", #contObjects)
	end    
end

function Lock(user,key)
    if(user ~= nil and key == nil) then
        key = GetKey(user,this)
    end

    -- user must always have a key!
    if(user ~= nil and key == nil) then
        user:SystemMessage("You do not have the proper key to lock this.")
        return
    end

    if (key ~= nil and key:ContainedBy() == this) then
        if(user ~= nil) then
            user:SystemMessage("You can't lock this while the key is inside it.")
        end
        return
    end

    this:SetObjVar("locked",true)
    if(user ~= nil) then
        user:SystemMessage("*locked*")
    end
    this:PlayObjectSound("DoorLock")

    SetTooltipEntry(this,"lock","[FF0000]*Locked*[-]",10)

    if(key ~= nil and user ~= nil and (key:GetObjVar("IsHouseKey") ~= true or this:GetObjVar("LockedDown") ~= true)) then
        CloseContainerRecursive(user, this)
    end
end

function Unlock(user,key)
    if(user ~= nil and key == nil) then
        key = GetKey(user,this)
    end

    -- user must always have a key!
    if(user ~= nil and key == nil) then
        user:SystemMessage("You do not have the proper key to unlock this.")
        return
    end

    this:DelObjVar("locked")

    if(user ~= nil) then
        user:SystemMessage("*unlocked*")
    end

    this:PlayObjectSound("DoorUnlock")

    if (key ~= nil and key:HasObjVar("OneTimeKey")) then
        if(user ~= nil) then
            user:SystemMessage("The key disintegrates.")
        end
        key:Destroy()
    end

    RemoveTooltipEntry(this,"lock")
end

function AdjustWeightRecursive(delta)
    --DebugMessage("AdjustWeightRecursive",GetWeight(this),delta)
    local totalWeight = GetWeight(this)
    if(totalWeight and totalWeight ~= -1) then
        this:SetSharedObjectProperty("Weight",totalWeight+delta)
        local parentObj = this:ContainedBy()
        if(parentObj) then
            parentObj:SendMessage("AdjustWeight",delta)
        end
    end  
end

RegisterEventHandler(EventType.Message,"Unlock",Unlock)
RegisterEventHandler(EventType.Message,"Lock",Lock)

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
        if(usedType == "Open" or usedType == "Use") then         
            if( CanOpen(user) ) then
                this:SendOpenContainer(user)            
            end
        elseif(usedType == "Lock") then
            Lock(user)
        elseif(usedType == "Unlock") then
            Unlock(user)
        elseif(usedType == "Make/Unmake Loot Bag") then
            if(this:HasObjVar("LootBag")) then
                this:DelObjVar("LootBag")
                RemoveTooltipEntry(this,"lootbag")
            else
                this:SetObjVar("LootBag",true)
                SetTooltipEntry(this,"lootbag", "[528CEA]Loot Bag[-]")        
            end
        end
    end)

RegisterEventHandler(EventType.ContainerItemRemoved, "", 
    function(itemRemoved)
        HandleContentsChanged()

        local objWeight = GetWeight(itemRemoved)
        if(objWeight ~= -1) then
            AdjustWeightRecursive(-objWeight)  
        end

        if(debugLogging) then
            local contRecords = this:GetObjVar("DebugContainerLog") or {}
            if(#contRecords > 10) then
                table.remove(contRecords,1)
            end
            table.insert(contRecords,"[Removed]["..itemRemoved.Id.."] Name: "..itemRemoved:GetName())
            this:SetObjVar("DebugContainerLog",contRecords)
        end
    end)

RegisterEventHandler(EventType.ContainerItemAdded, "", 
    function(itemAdded)
        HandleContentsChanged()

        local objWeight = GetWeight(itemAdded)
        if(objWeight ~= -1) then
            AdjustWeightRecursive(objWeight)  
        end

        if(debugLogging) then
            local contRecords = this:GetObjVar("DebugContainerLog") or {}
            if(#contRecords > 10) then
                table.remove(contRecords,1)
            end
            table.insert(contRecords,"[Added]["..itemAdded.Id.."] Name: "..itemAdded:GetName())
            this:SetObjVar("DebugContainerLog",contRecords)
        end
    end)

RegisterEventHandler(EventType.Message,"RefreshWeight",RefreshWeight)
RegisterEventHandler(EventType.Message,"AdjustWeight",AdjustWeightRecursive)

function Init()
    if not(this:HasObjVar("EmptyWeight")) then
        this:SetObjVar("EmptyWeight",GetWeight(this))        
    end

    -- DAB NOTE: This automatically updates container capacities to match the template
    local capacity = this:GetSharedObjectProperty("Capacity");
    local templateCapacity = GetTemplateObjectProperty(this:GetCreationTemplateId(),"Capacity")
    if not(templateCapacity) then
        -- this is not an error: currently only happens on test server mod
        --DebugMessage("This container has no capacity: "..this:GetCreationTemplateId())
    elseif(templateCapacity > capacity) then
        this:SetSharedObjectProperty("Capacity",templateCapacity)
    end

    this:SetSharedObjectProperty("MaxWeight",GetContainerMaxWeight(this))

    HandleContentsChanged()
    RefreshWeight()
end

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
    function()
        Init()

        if(GetCurrentModule() ~= "bank_box") then
            AddUseCase(this,"Lock",false,"HasKey")
            AddUseCase(this,"Unlock",false,"HasKey")       
            if(GetWeight(this) ~= -1) then
                AddUseCase(this,"Make/Unmake Loot Bag",false,"HasObject")
            end
        end
    end)

RegisterSingleEventHandler(EventType.LoadedFromBackup, "", 
    function()
        Init()
    end)