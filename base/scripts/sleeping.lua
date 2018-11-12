

RegisterEventHandler(EventType.StartMoving, "", function(speedmod)
    this:SendMessage("WakeUp")
end)

RegisterEventHandler(EventType.Message, "DamageInflicted", function()
    this:SendMessage("WakeUp")
end)

_Detaching = false
RegisterEventHandler(EventType.Message, "WakeUp", function()
    if ( _Detaching ) then return end
    _Detaching = true

    this:SetWorldPosition(this:GetObjVar("PositionBeforeUsing"))
    RemoveUseCase(this, "Wake Up")
    
    CallFunctionDelayed(TimeSpan.FromMilliseconds(1), function()
        if ( this:HasModule("sleeping") ) then
            this:DelModule("sleeping")
        end
    end)
end)

RegisterEventHandler(EventType.LoadedFromBackup, "", function()
    CallFunctionDelayed(TimeSpan.FromMilliseconds(1), function()
        
        if ( this:HasModule("sleeping") ) then
            this:SetWorldPosition(this:GetObjVar("PositionBeforeUsing"))
            RemoveUseCase(this, "Wake Up")
            this:DelModule("sleeping")
        end
    end)
end)