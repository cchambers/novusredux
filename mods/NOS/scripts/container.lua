require 'NOS:incl_keyhelpers'

debugLogging = false
resetTimer = nil
resetChance = nil

function CanOpen(user)
    if (IsImmortal(user)) then
        return true
    end
    
    if(GetCurrentModule() == "bank_box") then
        return false end

    local capacity = this:GetSharedObjectProperty("Capacity")
    if( capacity <= 0 ) then
        user:SystemMessage("That cannot be opened.", "info")  
    	return false
    end

    WarnContainerOverflow(this, user, capacity)

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

    if (IsPet(topmostObj) and not IsController(user, topmostObj)) then
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
        -- Secure Containers allow a user to open and view contents without unlocking and rendering the container vulnerable
		if ( not this:HasObjVar("SecureContainer") or not Plot.HasObjectControl(user, this, this:HasObjVar("FriendContainer")) ) then
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
	if ( this:HasSharedObjectProperty("NumItems") ) then
		this:SetSharedObjectProperty("NumItems", this:GetItemCount())
	end
	local container = this:ContainedBy()
    while ( container and container:IsContainer() ) do
        if ( container:HasSharedObjectProperty("NumItems") ) then
            container:SetSharedObjectProperty("NumItems", container:GetItemCount())
        end
		container = container:ContainedBy()
	end
end

function Lock(user,key)
    if ( this:HasObjVar("LockedDown") ) then
        user:SystemMessage("Cannot lock containers that are locked down.", "info")
        return
    end

    if(user ~= nil and key == nil) then
        key = GetKey(user,this)
    end

    -- user must always have a key!
    if(user ~= nil and key == nil) then
        user:SystemMessage("Do not have proper key to lock this.", "info")
        return
    end

    if (key ~= nil and key:ContainedBy() == this) then
        if(user ~= nil) then
            user:SystemMessage("Cannot lock while key is inside.", "info")
        end
        return
    end

    this:SetObjVar("locked",true)
    if(user ~= nil) then
        user:SystemMessage("*locked*","info")
    end
    this:PlayObjectSound("event:/objects/doors/door/door_lock")

    SetTooltipEntry(this,"lock","[FF0000]*Locked*[-]",10)

    if(key ~= nil and user ~= nil) then
        CloseContainerRecursive(user, this)
    end
end

function Unlock(user,key)
    if(user ~= nil and key == nil) then
        key = GetKey(user,this)
    end

    -- user must always have a key!
    if(user ~= nil and key == nil) then
        user:SystemMessage("Do not have proper key to unlock this.", "info")
        return
    end

    this:DelObjVar("locked")

    if(user ~= nil) then
        user:SystemMessage("*unlocked*", "info")
    end

    this:PlayObjectSound("event:/objects/doors/door/door_unlock")

    if (key ~= nil and key:HasObjVar("OneTimeKey")) then
        if(user ~= nil) then
            user:SystemMessage("The key disintegrates.", "event")
        end
        key:Destroy()
    end

    if (resetTimer ~= nil) then
        this:ScheduleTimerDelay(TimeSpan.FromMinutes(resetTimer), "ContainerReset")
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
                if (this:HasObjVar("Trapped")) then
                    user:SendMessage("StartMobileEffect", "TrapTriggered", this)
                end
                this:SendOpenContainer(user)            
            end
        elseif(usedType == "Lock") then
            Lock(user)
        elseif(usedType == "Unlock") then
            Unlock(user)
        elseif(usedType == "Secure: Friends" or usedType == "Secure: Owners") then
            Plot.ToggleHouseFriendContainer(user, this)
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

    if (this:HasObjVar("locked")) then
        SetTooltipEntry(this,"lock","[FF0000]*Locked*[-]",10)
    end

    -- ensure item count is correct
	if ( this:HasSharedObjectProperty("NumItems") ) then
		this:SetSharedObjectProperty("NumItems", this:GetItemCount())
	end

    -- DAB NOTE: This automatically updates container capacities to match the template
    local capacity = this:GetSharedObjectProperty("Capacity");
    local templateCapacity = GetTemplateObjectProperty(this:GetCreationTemplateId(),"Capacity")
    if not(capacity) then
        DebugMessage("This container has no capacity: "..this:GetCreationTemplateId())
    end
    if not(templateCapacity) then
        -- this is not an error: currently only happens on test server mod
        --DebugMessage("This container has no capacity: "..this:GetCreationTemplateId())
    elseif(templateCapacity > capacity) then
        this:SetSharedObjectProperty("Capacity",templateCapacity)
    end

    local initializer = initializer or GetInitializerFromTemplate(this:GetCreationTemplateId(), "container")

    if (initializer ~= nil and initializer.ResetTimer ~= nil) then
        resetTimer = initializer.ResetTimer.DelayMin
        resetChance = initializer.ResetTimer.Chance
    end

    if (this:HasObjVar("Refilling")) then
        this:ScheduleTimerDelay(TimeSpan.FromMinutes(resetTimer), "ContainerReset")
    end

    this:SetSharedObjectProperty("MaxWeight",GetContainerMaxWeight(this))

    HandleContentsChanged()
    RefreshWeight()
end

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
    function()
        Init()

        local curModule = GetCurrentModule()
        if(curModule ~= "bank_box"  and curModule ~= "cooking_crafting") then
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

RegisterEventHandler(EventType.Message, "Lockpicked",
    function(user)
        RemoveTooltipEntry(this,"lock")
        if (resetTimer ~= nil) then
            this:SetObjVar("Refilling", true)

            --Refill the loot on chest being lockpicked
            this:SendMessage("refill_random_loot")

            this:ScheduleTimerDelay(TimeSpan.FromMinutes(resetTimer), "ContainerReset")
        end
    end)

RegisterEventHandler(EventType.Timer, "ContainerReset",
    function()
        if (resetChance == nil) then
            return
        end
        
        local randomRoll = math.random(100)

        if (randomRoll <= resetChance) then
            this:SetObjVar("locked", true)
            SetTooltipEntry(this,"lock","[FF0000]*Locked*[-]",10)
            this:PlayEffect("TeleportToEffect")

            --Destroy whatever is in when the chest gets locked again
            if (this:HasModule("fill_random_loot")) then
                local contObjects = this:GetContainedObjects()
                for key,value in pairs(contObjects) do
                    value:Destroy()
                end
            end

            this:DelObjVar("Refilling")
        else
            this:ScheduleTimerDelay(TimeSpan.FromMinutes(resetTimer), "ContainerReset")
        end
    end)