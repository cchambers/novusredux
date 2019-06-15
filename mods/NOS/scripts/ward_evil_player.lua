--[[

    This Lua Module is attahed to player and reveives events/remote controlls the ward in the world

]]

local wardInfo = this:GetObjVar("EvilWard")

function CleanUp()
    this:DelObjVar("EvilWard")
    -- detach in new frame
    CallFunctionDelayed(TimeSpan.FromMilliseconds(1), function()
        this:DelModule("ward_evil_player")
    end)
end

function WardIsValid(cb)
    if not( cb ) then cb = function(valid) end end
    if not ( wardInfo ) then cb(false) return end
    if ( wardInfo[2] == ServerSettings.RegionAddress ) then
        cb(wardInfo[1]:IsValid())
    else
        if not( IsClusterRegionOnline(wardInfo[2]) ) then cb(false) return end
        RegisterSingleEventHandler(EventType.Message, "IsValidResponse", cb)
        MessageRemoteClusterController(wardInfo[2], "IsValidRequest", this, wardInfo[1])
    end
end

RegisterEventHandler(EventType.Message, "WardUpdate", function(type)
    if ( type == "Evil" ) then
        this:SystemMessage("Your ward has been destroyed by an evil presence.", "event")
    elseif ( type == "Fade" ) then
        this:SystemMessage("Your ward has faded.", "info")
    end
    CleanUp()
end)

-- check for a valid ward on each attach/login/region transfer
WardIsValid(function(valid)
    if not( valid ) then
        CleanUp()
    end
end)