
States.Death = {
    Name = "Death",
    Init = function(self)
        RegisterEventHandler(EventType.Message, "OnResurrect", function()
            -- resume on a resurrect
            self.Schedule()
        end)
    end,
    ShouldRun = function(self)
        return IsDead(self.ParentObj)
    end,
    Run = function(self)
        self.SetTarget(nil)
        -- stop all ai while dead.
        return true
    end,
}