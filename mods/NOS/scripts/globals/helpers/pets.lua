require 'default:globals.helpers.pets'

function MaxActivePetSlots(master)
    local slots = GetSkillLevel(master, "BeastmasterySkill")/10 or 2
    if (slots < 2) then slots = 2 end
    -- master:SystemMessage(tostring("You can control " .. slots .. " slots worth of pets."))
	return slots
end