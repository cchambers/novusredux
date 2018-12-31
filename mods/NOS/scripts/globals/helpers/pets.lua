require 'default:globals.helpers.pets'

function MaxActivePetSlots(master)
    local slots = GetSkillLevel(master, "BeastmasterySkill")/10 or 1
    if (slots < 1) then slots = 1 end
    -- master:SystemMessage(tostring("You can control " .. slots .. " slots worth of pets."))
	return slots
end
