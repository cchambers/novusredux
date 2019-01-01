require 'default:globals.helpers.pets'

function MaxActivePetSlots(master)
    local slots = GetSkillLevel(master, "BeastmasterySkill")/10 or 1
    if (slots < 4) then slots = 4 end
    -- master:SystemMessage(tostring("You can control " .. slots .. " slots worth of pets."))
	return slots
end

function MaxStabledPetSlots(master)
	return 30 -- all pets count as 1
end

