

States.FightAdvanced = {
    Name = "FightAdvanced",
    Init = function(self)
        -- call base fight
        States.Fight.Init(self)
        FSMHelper.WeaponAbilityInit(self)
        FSMHelper.CombatAbilityInit(self)
        FSMHelper.SpellInit(self)
        self.FightAdvancedList = {}
        if ( self.WeaponAbilities ) then
            self.FightAdvancedList[#self.FightAdvancedList+1] = function()
                FSMHelper.RandomWeaponAbility(self, math.random(self.WeaponAbilityMin or 6, self.WeaponAbilityMax or 12))
            end
        end
        if ( self.CombatAbilities ) then
            self.FightAdvancedList[#self.FightAdvancedList+1] = function()
                FSMHelper.RandomCombatAbility(self, math.random(self.CombatAbilityMin or 6, self.CombatAbilityMax or 12))
            end
        end
        if ( self.Spells ) then
            self.FightAdvancedList[#self.FightAdvancedList+1] = function()
                FSMHelper.RandomSpell(self, math.random(self.SpellDelayMin or 6, self.SpellDelayMax or 12))
            end
        end
    end,
    ShouldRun = States.Fight.ShouldRun,
    Run = function(self)
        -- call base fight
        States.Fight.Run(self)
        if not( self.CurrentTarget ) then return end

        if ( #self.FightAdvancedList > 0 ) then
            if ( #self.FightAdvancedList == 1 ) then
                self.FightAdvancedList[1]()
            else
                self.FightAdvancedList[math.random(1,#self.FightAdvancedList)]()
            end
        end
    end,
}