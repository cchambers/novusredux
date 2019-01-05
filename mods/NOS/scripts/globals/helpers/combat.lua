require 'default:globals.helpers.combat'

function DoResist(target, resistLevel, damage)
    local resistAmount = (resistLevel * 10 - 400) / 15
    -- target:SystemMessage(tostring("Damage: " .. damage .. " Resist: " .. resistAmount))
    target:PlayEffect("HoneycombShield", 0.25)
    return (damage * (resistAmount) * 0.01)
end