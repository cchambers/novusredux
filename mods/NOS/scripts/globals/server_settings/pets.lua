ServerSettings.Pets = {
    Follow = {
        Distance = 5, -- closest a following pet will get to leader.
        Speed = {
            OnFoot = 5, -- speed that pets will follow at while owner is on foot
            Mounted = 12, -- speed that pets will follow at while owner is mounted.
        },
    },
    Command = {
        Distance = 30, -- distance owner can command pet from
    },
    Combat = {
        Speed = 4.6, -- speed that pets will chase stuff to attack
    },
    Taming = {
        Distance = 7 -- distance a player can be from a pet to tame it
    },

    -- if a pet(mount) takes this many, or fewer, pet slots they can be dismissed.
        -- (prevents dismissing powerful mounts that could be brought out for combat instantly.) 
    MaxSlotsToAllowDismiss = 2,
}