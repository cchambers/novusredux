
States.Attack = {
    Name = "Attack",
    Init = function(self)
        if not( self.BodySize ) then
            self.BodySize = GetBodySize(self.ParentObj)
        end
        self.NearbyEnemy = {}
        RegisterEventHandler(EventType.EnterView, "NearbyEnemy", function(mobile)
            self.NearbyEnemy[#self.NearbyEnemy+1] = mobile
        end)
        RegisterEventHandler(EventType.LeaveView, "NearbyEnemy", function(mobile)
            for i=1,#self.NearbyEnemy do
                if ( self.NearbyEnemy[i] == mobile ) then
                    self.NearbyEnemy[i] = nil
                    break
                end
            end
        end)
    end,
    OnResume = function(self)
        AddView("NearbyEnemy", SearchOtherMobileTeamTypeInRange(self.BodySize + (self.AttackRange or 10) + 2, self.CanSeeInvis or false), 2)
    end,
    OnPause = function(self)
        DelView("NearbyEnemy")
    end,
    ShouldRun = function(self)
        -- already have a target, no reason to seek one
        if ( self.CurrentTarget ~= nil ) then return false end

        self.AttackTarget = nil
        local loc, d, ld
        local nearbyMobile
        for i=1,#self.NearbyEnemy do
            nearbyMobile = self.NearbyEnemy[i]
            if (
                self.ParentObj:HasLineOfSightToObj(nearbyMobile, ServerSettings.Combat.LOSEyeLevel)
                and
                self.ValidCombatTarget(nearbyMobile)
            ) then
                loc = nearbyMobile:GetLoc()
                d = self.Loc:Distance(loc)
                -- super close or in field of view
                if ( d <= (self.BodySize + 4) or math.abs( self.ParentObj:GetFacing() - self.Loc:YAngleTo(loc) ) < 90 ) then
                    -- closer than any others
                    if ( ld == nil or d < ld ) then
                        self.AttackTarget = nearbyMobile
                        ld = d
                    end
                end
            end
        end
        return ( self.AttackTarget ~= nil )
    end,
    Run = function(self)
        if ( self.AttackTarget ~= nil ) then
            self.SetTarget(self.AttackTarget)
            self.AttackTarget = nil
            self.Pulse()
            return true -- prevent default schedule post run
        end
    end,
}