require 'incl_keyhelpers'

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
        if(usedType == "Open/Close" or usedType == "Open" or usedType == "Close" or usedType == "Use") then 
            if not(this:HasTimer("OpenCloseDelay")) then
                if (this:HasObjVar("OneWay")) then
                    if (FacingAngleDiff(user,this) > 90) then
                        user:SystemMessage("The door opens from this direction...")
                        OpenDoor()
                        return
                     end
                end
                if (this:GetObjVar("locked") ~= nil) then
                    local key = GetKey(user,this)
                    if(key) then
                        user:SystemMessage("That door is locked, but you use the key.")
                        --Unlock(user,key)
                        if (key ~= nil) then
                            if (key:HasObjVar("OneTimeKey")) then
                                user:SystemMessage("The key disintegrates.")
                                key:Destroy()
                            end
                        end
                    else
                        user:SystemMessage("That door appears to be locked.")
                        return
                    end            
                end

                local isOpen = this:GetSharedObjectProperty("IsOpen");

                if( isOpen ) then
                    CloseDoor()
                else
                    OpenDoor()
                end
                this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"OpenCloseDelay")
            end
        elseif(usedType == "Lock") then
            Lock(user)
        elseif(usedType == "Unlock") then
            Unlock(user)
        end
    end)

function CloseDoor()
    this:SetSharedObjectProperty("IsOpen", false)
    this:SetCollisionBoundsFromTemplate(this:GetCreationTemplateId())
    --DebugMessage("Closing door")
end
function OpenDoor()
    this:SetSharedObjectProperty("IsOpen", true)
    this:ClearCollisionBounds()
    --DebugMessage("Opening door")
    if (not this:HasObjVar("NoAutoClose")) then
        CallFunctionDelayed(TimeSpan.FromSeconds(5),
            function( ... )
                this:SetSharedObjectProperty("IsOpen", false)
                this:SetCollisionBoundsFromTemplate(this:GetCreationTemplateId())
            end)
    end
    
    if (this:HasObjVar("AutoLock")) then
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(10),"AutoLock")
    end
end
RegisterEventHandler(EventType.Message,"OpenDoor",OpenDoor)
RegisterEventHandler(EventType.Message,"CloseDoor",CloseDoor)

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
        user:SystemMessage("*click*")
    end

    this:PlayObjectSound("DoorUnlock")

    if (key ~= nil) then
        if (key:HasObjVar("OneTimeKey")) then
            user:SystemMessage("The key disintegrates.")
            key:Destroy()
        end
    end

    if (this:HasObjVar("AutoLock")) then
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(10),"AutoLock")
    end

    RemoveTooltipEntry(this,"lock")

    local houseObj = this:GetObjVar("HouseObject")
    if(houseObj) then
        local houseControlObj = GetContainingHouseForObj(this)
        houseControlObj:SendMessage("DoorUnlocked")
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

    this:SetObjVar("locked",true)
    if(user ~= nil) then
        user:SystemMessage("*ka-chink*")
    end
    this:PlayObjectSound("DoorLock")

    SetTooltipEntry(this,"lock","[FF0000]*Locked*[-]",10)

    local houseObj = this:GetObjVar("HouseObject")
    if(houseObj) then
        local houseControlObj = GetContainingHouseForObj(this)
        houseControlObj:SendMessage("DoorLocked")
    end
end

function AutoLock()
    Lock()
    CloseDoor()
end

RegisterEventHandler(EventType.Message,"Unlock",Unlock)
RegisterEventHandler(EventType.Message,"Activate",Unlock)
RegisterEventHandler(EventType.Message,"Lock",Lock)
RegisterEventHandler(EventType.Timer,"AutoLock",AutoLock)

--make doors lockable from template
if (this:HasObjVar("AutoLock")) then
    Lock(nil,nil)
end

RegisterSingleEventHandler(EventType.ModuleAttached, "door", 
    function()
        AddUseCase(this,"Open/Close",true)
        AddUseCase(this,"Lock",false,"HasKey")
        AddUseCase(this,"Unlock",false,"HasKey")
    end)

this:SetObjVar("UseableWhileDead",true)