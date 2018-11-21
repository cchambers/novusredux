

RegisterEventHandler(EventType.StartMoving, "", function(speedmod)
    this:SendMessage("StopSitting")
end)

RegisterEventHandler(EventType.Message, "DamageInflicted", function()
    this:SendMessage("StopSitting")
end)

_Detaching = false
RegisterEventHandler(EventType.Message, "StopSitting", function()
    if ( _Detaching ) then return end
    _Detaching = true

    this:SetWorldPosition(this:GetObjVar("PositionBeforeUsing"))
    RemoveUseCase(this, "Stand")
    
    CallFunctionDelayed(TimeSpan.FromMilliseconds(1), function()
        if ( this:HasModule("sitting") ) then
            this:DelModule("sitting")
        end
    end)
end)

RegisterEventHandler(EventType.LoadedFromBackup, "", function()
    CallFunctionDelayed(TimeSpan.FromMilliseconds(1), function()
        if ( this:HasModule("sitting") ) then
            this:DelModule("sitting")
        end
    end)
end)