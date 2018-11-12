

function OutputDifferenceMilliseconds(before, after)
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

RegisterEventHandler(EventType.Message, "TestLoad", function()
    
    GlobalVarWrite("Test", nil, function(record)
        for i=1,100 do
            local r = {}
            for ii=1,100 do
                r[ii] = uuid()
            end
            record["Table"..i] = r
        end
        return true
    end)
end)

-- ~11-12ms
RegisterEventHandler(EventType.Message, "TestRead1", function()
    local before = DateTime.UtcNow
    local all = GlobalVarRead("Test")
    --DebugMaTable(all["Table99"])
    local after = DateTime.UtcNow
    OutputDifferenceMilliseconds(before, after)
end)

-- ~0-1ms
RegisterEventHandler(EventType.Message, "TestRead2", function()
    local before = DateTime.UtcNow
    local test1 = GlobalVarReadKey("Test", "Table99")
    --DebugMaTable(test1)
    local after = DateTime.UtcNow
    OutputDifferenceMilliseconds(before, after)
end)