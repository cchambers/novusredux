
States.Flee = {
    Name = "Flee",
    ShouldRun = function(self)
        return (
            (
                self.IsFleeing -- lock us in flee until path clears
                or
                (GetCurHealth(self.ParentObj) / GetMaxHealth(self.ParentObj)) <= 0.5
            )
            and
            not self.ParentObj:HasTimer("NoFlee")
        )
    end,
    Run = function(self)
        if not( self.IsFleeing ) then
            local loc
            local nearbyFriend = FSMHelper.NearbyFriend(self, 25)[1]
            if ( nearbyFriend ) then
                loc = self.Loc:Project(self.Loc:YAngleTo(nearbyFriend:GetLoc()), math.random(6,12))
            else
                loc = self.Loc:Project(math.random(0,360), math.random(6,12))
            end
            if ( loc and IsPassable(loc) ) then
                self.PathTo(loc, 2)
                self.IsFleeing = true
            end
        else
            if not( self.IsPathing ) then
                self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "NoFlee") -- prevent fleeing for duration
                self.IsFleeing = false
            end
        end
    end,
}