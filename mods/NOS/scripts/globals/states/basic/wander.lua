
States.Wander = {
    Name = "Wander",
    Init = function(self)
        if not( self.ParentObj:HasObjVar("SpawnLocation") ) then
            self.SpawnLocation = self.Loc
            self.ParentObj:SetObjVar("SpawnLocation", self.SpawnLocation)
        end
        if not ( self.SpawnLocation ) then
            self.SpawnLocation = self.ParentObj:GetObjVar("SpawnLocation")
        end
    end,
    ShouldRun = function(self)
        return (not self.IsPathing)
    end,
    Run = function(self)
        local maxHP = GetMaxHealth(self.ParentObj)
        if not( GetCurHealth(self.ParentObj) == maxHP ) then
            SetCurHealth(self.ParentObj, maxHP)
        end
        local loc = self.SpawnLocation:Project(math.random(0,360), math.random(self.WanderMin or 2, self.WanderMax or 4))
        if ( IsPassable(loc) ) then
            self.PathTo(loc, self.WanderSpeed or 1)
        end
    end,
}