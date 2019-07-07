
States.Leash = {
    Name = "Leash",
    Init = function(self)
        if not( self.ParentObj:HasObjVar("SpawnLocation") ) then
            self.SpawnLocation = self.Loc
            self.ParentObj:SetObjVar("SpawnLocation", self.SpawnLocation)
        end
        if not ( self.SpawnLocation ) then
            self.SpawnLocation = self.ParentObj:GetObjVar("SpawnLocation")
        end
    end,
    EnterState = function(self)
        SetMobileMod(self.ParentObj, "HealthRegenTimes", "Leashing", 1000)
        self.ParentObj:SetObjVar("Invulnerable", true)
    end,
    ExitState = function(self)
        SetMobileMod(self.ParentObj, "HealthRegenTimes", "Leashing", nil)
        self.ParentObj:DelObjVar("Invulnerable")
    end,
    ShouldRun = function(self)
        return (
            self.IsLeashing
            or
            (
                ( self.CurrentTarget == nil and self.Loc:Distance(self.SpawnLocation) > (self.WanderMax or 8) + 3 )
                or
                ( self.Loc:Distance(self.SpawnLocation) >= (self.LeashDistance or 45) )
            )
        )
    end,
    Run = function(self)
        if ( self.IsLeashing ) then
            if not( self.IsPathing ) then
                self.IsLeashing = nil
            end
        else
            self.SetTarget(nil)
            if ( self.Loc:Distance(self.SpawnLocation) >= MAX_PATHTO_DIST ) then
                -- teleport them, too far away
                PlayEffectAtLoc("TeleportFromEffect", self.Loc)
                self.ParentObj:SetWorldPosition(self.SpawnLocation)
                return
            end
            self.PathTo(self.SpawnLocation, (self.LeashSpeed or 7))
            if ( self.IsPathing ) then
                self.IsLeashing = true
            end
        end
    end,
}