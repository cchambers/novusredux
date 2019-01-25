
require 'default:base_ai_mob'
require 'harvestable_plant'

--handles when died
UnregisterEventHandler("", EventType.Message,"HasDiedMessage")
RegisterEventHandler(EventType.Message,"HasDiedMessage",
    function ()
        SetAITarget(nil)
        AI.ClearAggroList()
        AI.StateMachine.ChangeState("Dead")
        TurnNearbyMossIntoBloodMoss()
    end)

function TurnNearbyMossIntoBloodMoss()
    -- TODO - Verlorens - Globalize this call, so it's not in base_player_death.lua AND base_ai_mob.lua
    -- Right now it's set so if something that is not Undead, dies close enough to it, it turns into bloodmoss.
    local nearbyMoss = FindObjects(SearchMulti(
		{
			SearchRange(this:GetLoc(), 8),
			SearchObjVar("ResourceSourceId","Moss"),
        }))
    for i,j in pairs(nearbyMoss) do
        if( this:GetObjVar("MobileKind") ~= "Undead") then
            if(math.random(0,10) > 2) then
                CreateTempObj("plant_bloodmoss", j:GetLoc(), "bloodmoss_created_by_death")
                j:Destroy()
            end
        end
    end
end

RegisterEventHandler(EventType.CreatedObject,"bloodmoss_created_by_death",function (success,objRef)
    if (success) then
        if( not (objRef:HasModule("harvestable_plant")) ) then
            -- A safety check in case the harvestable_plant module is not attached.
            objRef:AddModule("harvestable_plant")
        end
        objRef:SendMessage("TransitionColorFromMossToBloodmoss", objRef)
	end
end)