
require 'base_mobile'

RegisterEventHandler(EventType.EnterView, "ClearCorpseData", function(mobile)
    local backpackOwner = this:GetObjVar("BackpackOwner")
    if ( backpackOwner and backpackOwner == mobile and not IsDead(mobile) ) then
        -- clear variables telling us where the corpse object is
        backpackOwner:DelObjVar("CorpseObject")
        backpackOwner:DelObjVar("CorpseAddress")
        backpackOwner:FireTimer("UpdateMapMarkers")
        DelView("ClearCorpseData")
    end
end)
AddView("ClearCorpseData",SearchPlayerInRange(5,true),1)