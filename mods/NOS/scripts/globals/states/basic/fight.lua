
States.Fight = {
    Name = "Fight",
    Init = function(self)
        if not( self.WeaponRange ) then
            if ( self.ParentObj:HasObjVar("WeaponRange") ) then
                self.WeaponRange = self.ParentObj:GetObjVar("WeaponRange")
            else
                self.WeaponRange = Weapon.GetRange(
                    self.ParentObj:GetObjVar("AI-WeaponType") or "BareHand"
                )
            end
        end
        if not( self.BodySize ) then
            self.BodySize = GetBodySize(self.ParentObj)
        end
    end,
    ShouldRun = function(self)
        return ( self.CurrentTarget ~= nil )
    end,
    Run = function(self)
        if ( self.ValidCombatTarget(self.CurrentTarget) ) then
            self.ParentObj:SetFacing(self.Loc:YAngleTo(self.CurrentTarget:GetLoc()))
            if not( self.IsPathing ) then
                self.PathFollow(self.CurrentTarget, self.WeaponRange + self.BodySize + GetBodySize(self.CurrentTarget))
            end
            if not( self.ParentObj:GetSharedObjectProperty("CombatMode") ) then
                self.ParentObj:SendMessage("ForceCombat", self.CurrentTarget)
            end
        else
            self.SetTarget(nil)
        end
    end,
}