
Tests = {}


Test = {
    Current = 0,
    Name = "All",
    Next = function()
        Test.Current = Test.Current + 1
        if ( Tests[Test.Current] == nil ) then
            Test.Name = "All"
            Test.Log("Complete")
            return
        end
        Tests[Test.Current](function()
            Test.Next()
        end)
    end,
    OutputDifference = function(before, after)
        DebugMessage(string.format("Test completed in %s milliseconds.", after:Subtract(before).TotalMilliseconds))
    end,
    Start = function()
        Test.Next()
    end,
    Log = function(msg, ...)
        DebugMessage(string.format("TEST:%s: %s", Test.Name, string.format(msg or "", ...)))
    end,
    Pass = function(msg, ...)
        Test.Log("PASSED\n%s", string.format(msg or "", ...))
        Test.Next()
    end,
    Fail = function(msg, ...)
        Test.Log("FAILED\n\t%s", string.format(msg or "", ...))
    end,
    SetName = function(name)
        Test.Name = name
        Test.Log("Starting.")
    end,
    Assert = {
        Equals = function(a, b, identifier)
            if not( a == b ) then
                Test.Fail("%s Expected %s, got %s", identifier, b, a)
                return false
            end
            return true
        end,
    }
}

require 'globals.tests.karma.main'