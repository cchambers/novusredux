
-- setup
local now = DateTime.UtcNow
local releaseAt = now:Add(ServerSettings.Death.CorpseDecay)
local controller = this:GetObjVar("controller")
-- immediately have pets stop
SendPetCommandTo(this, "stop", nil, true)

function Release()
    this:Destroy()
end

function CleanUp()
    this:RemoveTimer("PetTempRelease")
    this:DelObjVar("PetTempReleaseAt") -- this can be removed in the future
    OnNextFrame(function()
        this:DelModule("pet_temp_release")
    end)
end

function ResetOwner()
    controller = this:GetObjVar("controller")
    if ( controller ) then
        if ( controller:IsValid() ) then
            this:SetObjectOwner(controller)
            SendPetCommandTo(this, "follow", controller, true)
            CleanUp()
        end
    else
        Release()
    end
end

if ( controller == nil ) then
    ResetOwner()
    return
end

RegisterEventHandler(EventType.Timer, "PetTempRelease", ResetOwner)
this:ScheduleTimerDelay(releaseAt - now, "PetTempRelease")

RegisterEventHandler(EventType.EnterView, "PetTempReleaseView", function(mobile)
    if ( mobile == controller and not IsDead(mobile) ) then
        ResetOwner()
    end
end)
AddView("PetTempReleaseView", SearchPlayerInRange(10,true), 1)

RegisterEventHandler(EventType.Message, "ResetOwner", ResetOwner)

-- when dead, they can still be resurrected if controller objvar is valid, so this is no longer needed
RegisterEventHandler(EventType.Message, "HasDiedMessage", function(damager)
    CleanUp()
end)