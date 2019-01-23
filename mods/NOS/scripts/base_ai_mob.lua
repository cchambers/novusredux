
require 'default:base_ai_mob'
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
    -- TODO - Verlorens - Make it a more elegant way in which moss turns into bloodmoss.  
    -- Right now it's set so if something dies close enough to it, it turns into bloodmoss.
    -- Right now it's set so if ANY NPC but Undead dies.
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
        Decay(objRef, 900)  -- 900 seconds is 15 minutes
	end
end)