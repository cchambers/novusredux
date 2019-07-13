
States.Aggro = {
    Name = "Aggro",
    OnAggro = function(self, damager, amount)
        if ( damager and damager:GetObjVar("MobileTeamType") ~= self.TeamType ) then
            if not( self.AggroList[damager] ) then self.AggroList[damager] = 0 end
            self.AggroList[damager] = self.AggroList[damager] + (amount or 1)
            if ( self.AggroMost[2] < self.AggroList[damager] ) then
                self.AggroMost = {damager, self.AggroList[damager]}
            end
        end
        
        -- attack the damager with the most aggro
        if ( self.AggroMost[1] and self.AggroMost[1] ~= self.CurrentTarget and self.ValidCombatTarget(self.AggroMost[1]) ) then
            self.SetTarget(self.AggroMost[1])
            self.Pulse()
        end
    end,
    Init = function(self)
        self.AggroList = {}
        self.AggroMost = {nil,0}
        RegisterEventHandler(EventType.Message, "DamageInflicted", function(damager, amount)
            States.Aggro.OnAggro(self, damager, amount)
        end)
        RegisterEventHandler(EventType.Message, "SwungOn", function(attacker)
            States.Aggro.OnAggro(self, attacker)
        end)
        RegisterEventHandler(EventType.Message, "AddAggro", function(attacker, amount)
            States.Aggro.OnAggro(self, attacker, amount)
        end)
    end,
    --TODO: ShouldRun/Run to clear aggro list
}