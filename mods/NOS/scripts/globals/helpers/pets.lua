require 'default:globals.helpers.pets'

function GetRemainingActivePetSlots(master)
    Verbose("Pet", "GetRemainingActivePetSlots", master)
    local pets, slots = GetActivePets(master, nil, true)
	local test = MaxActivePetSlots(master) - slots
	DebugMessage(tostring("TEST " .. test))
	return MaxActivePetSlots(master) - test
end

function MaxActivePetSlots(master)
    local slots = GetSkillLevel(master, "BeastmasterySkill")/10 or 1
    if (slots < 1) then slots = 1 end
    -- master:SystemMessage(tostring("You can control " .. slots .. " slots worth of pets."))
	return slots
end

function MaxStabledPetSlots(master)
	return 30 -- all pets count as 1
end

