local who
local toLoc

function teleportGo() 
    this:RequestClientTargetGameObj(this, "select_teleport_target")
    this:SystemMessage("Who do you want to move?")
end

function handleWhoTarget(target, user)
    who = target
    user:SystemMessage("Where to?")
    user:RequestClientTargetLoc(this, "select_teleport_destination")
end

function moveTarget(target, user)
    who:SetWorldPosition(target)
    user:SystemMessage("Moved!")
end


RegisterEventHandler(EventType.Message, "use_tool_teleport", teleportGo)
RegisterEventHandler(EventType.ClientTargetGameObjResponse, "select_teleport_target", handleWhoTarget)
RegisterEventHandler(EventType.ClientTargetLocResponse, "select_teleport_destination", moveTarget)


