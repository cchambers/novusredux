-- build static data to fit our resource effect system

for spell,data in pairs(SpellData.AllSpells) do
    ResourceEffectData[spell] = {
        SendUseObject = true,
        UseCases = {
            "Cast",
        },
        OldSchoolUseCases = {
        },
        Tooltip = {
            SpellData.AllSpells[spell].SpellTooltipString,
            "Difficulty "..(SpellData.AllSpells[spell].Circle or 8),
        }
    }
end