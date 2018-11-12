

_Guard_Pets = {}

RegisterEventHandler(EventType.Message, "AddGuardPet", function(pet)
    if ( pet == this ) then return end
    table.insert(_Guard_Pets, pet)
end)

RegisterEventHandler(EventType.Message, "RemoveGuardPet", function(pet)
    for i=1,#_Guard_Pets do
        if ( _Guard_Pets[i] == pet ) then
            _Guard_Pets[i] = nil
            return
        end
    end
end)

function PetGuard(attacker)
    local thisLoc = this:GetLoc()

    local indexesToRemove = {}
    for i=1,#_Guard_Pets do
        if (
            _Guard_Pets[i]
            and 
            _Guard_Pets[i]:IsValid()
            and
            IsPet(_Guard_Pets[i])
            and
            _Guard_Pets[i]:GetObjVar("Guarding") == this
        ) then -- check the stuff that if fails, we remove this module
            if (
                thisLoc:Distance(_Guard_Pets[i]:GetLoc()) < ServerSettings.Pets.Command.Distance
            ) then
                SendPetCommandTo(_Guard_Pets[i], "attack", attacker, true)
            end
        else
            table.insert(indexesToRemove, i)
        end
    end

    for i=1,#indexesToRemove do
        _Guard_Pets[indexesToRemove[i]] = nil
    end

    if ( #_Guard_Pets < 1 ) then
        this:DelModule("pet_guard")
    end

end

RegisterEventHandler(EventType.Message, "DamageInflicted", PetGuard)
RegisterEventHandler(EventType.Message, "SwungOn", PetGuard)