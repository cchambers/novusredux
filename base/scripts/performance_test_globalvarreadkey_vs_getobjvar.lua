

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

RegisterEventHandler(EventType.Message, "TestLoad", function()
    local testValue = uuid()
    -- set the objvar test
    this:SetObjVar("SingleVariable", testValue)

    -- set the global data test
    local bigData = {}
    for ii=1,300 do
        table.insert(bigData, {"SOME "..uuid().."STRING HERE", "SOME OTHER STRING "..uuid().." HERE OR WHATEVER", uuid()})
    end
    GlobalVarWrite("Test2", nil, function(record)
        record.SingleVariable = testValue
        --record.Data = bigData
        return true
    end)
end)

-- test reading an objvar
RegisterEventHandler(EventType.Message, "TestRead1", function()
    local before = DateTime.UtcNow
    for i=1,30000 do
        local value = GlobalVarReadKey("Test2", "SingleVariable")
    end
    local after = DateTime.UtcNow
    OutputDifference(before, after)
end)

-- test reading global var read key
RegisterEventHandler(EventType.Message, "TestRead2", function()
    local before = DateTime.UtcNow
    for i=1,30000 do
        local value = this:GetObjVar("SingleVariable")
    end
    local after = DateTime.UtcNow
    OutputDifference(before, after)
end)