

function OutputDifference(before, after)
    local difference = after:Subtract(before)
    this:SystemMessage(string.format("Test completed in %s milliseconds.", difference.TotalMilliseconds))
end

function DebugMaTable(table)
    if ( table == nil ) then
        DebugMessage("Nil table!")
        return
    end
    for key,val in pairs(table) do
        DebugMessage(val)
    end
end

-- test reading an objvar
RegisterEventHandler(EventType.Message, "TestRead1", function()
    local before = DateTime.UtcNow
    for i=1,30000 do
        local value = GlobalVarReadKey("User.Name", this)
    end
    local after = DateTime.UtcNow
    OutputDifference(before, after)
end)

-- test reading global var read key
RegisterEventHandler(EventType.Message, "TestRead2", function()
    local before = DateTime.UtcNow
    for i=1,30000 do
		if ( this:IsValid() ) then -- add this as part of the cost
        	local value = StripColorFromString(this:GetName())
		end
    end
    local after = DateTime.UtcNow
    OutputDifference(before, after)
end)