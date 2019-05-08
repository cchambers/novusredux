require "default:globals.helpers.mobile"

function CanMount(mobileObj)
    if (IsMobileDisabled(mobileObj)) then
        if (mobileObj:IsPlayer()) then
            mobileObj:SystemMessage("Cannot mount now.", "info")
        end
        return false
    end

    if (HasMobileEffect(mobileObj, "NoMount")) then
        if (mobileObj:IsPlayer()) then
            mobileObj:SystemMessage("Cannot mount yet.", "info")
        end
        return false
    end

    -- prevent mounting in certain regions (like dungeons)
    if (mobileObj:IsInRegion("NoMount")) then
        if (mobileObj:IsPlayer()) then
            mobileObj:SystemMessage("Cannot mount here.", "info")
        end
        return false
    end

    -- prevent mounting when already mounted
    if (mobileObj:GetEquippedObject("Mount") ~= nil) then
        if (mobileObj:IsPlayer()) then
            mobileObj:SystemMessage("Already mounted.", "info")
        end
        return false
    end

    return true
end
