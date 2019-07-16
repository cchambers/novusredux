-- Use global_overrides.lua to override these options
-- verbose logging for debugging and following the trail of events.
VERBOSE_INCLUDE = nil

--[[ 
VERBOSE_INCLUDE = {
    General = true,
    Player = true,
    Combat= true,
    Magic= true,
    Mobile= true,
    Pet= true,
    Guard= true,
    AdvancedMobile= true,
    MobileMod= true,
    MobileEffect= true,
    Karma= true,
    Conflict= true,
    Death= true,
}]]

-- if verbose is enabled 
function Verbose(messageType, message, ...)
    if ( VERBOSE_INCLUDE and VERBOSE_INCLUDE[messageType] ~= nil ) then
        DebugMessage("VERBOSE:"..messageType .. ":"..message, ...)
    end
end

function DebugMessageA(target,message)
    if not(_DEBUG) then return end
    
    if( target:HasObjVar("Debug") ) then  
        DebugMessage(message)       
    end
    if( target:HasObjVar("Debug2") ) then
        DebugMessage(message)   
        target:NpcSpeech(message)
    end
end

function DebugMessageB(target,message)
    if not(_DEBUG) then return end

    DebugMessage(message)
    local nearbyPlayers = FindObjects(SearchPlayerInRange(30),target)
    for i,playerObj in pairs(nearbyPlayers) do
        if(IsGod(playerObj)) then
            playerObj:SystemMessage(message)
        end
    end

    if(IsGod(target)) then
        target:SystemMessage(message)
    end
end