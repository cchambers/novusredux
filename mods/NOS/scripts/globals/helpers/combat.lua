require 'default:globals.helpers.combat'

function CheckActiveSpellResist(target)
    -- 0 to 50% chance, 10 will = 0, 50 will = 50%
	if ( Success(0.5*((( GetWis(target) or 0 ) - ServerSettings.Stats.IndividualStatMin) / (ServerSettings.Stats.IndividualPlayerStatCap - ServerSettings.Stats.IndividualStatMin))) ) then
		return true
	end
	return false
end

function DoResist(target, resistLevel, damage)
    local resistAmount = (resistLevel * 10 - 400) / 15
    -- target:SystemMessage(tostring("Damage: " .. damage .. " Resist: " .. resistAmount))
    target:PlayEffect("HoneycombShield", 0.25)
    return (damage * (resistAmount) * 0.01)
end