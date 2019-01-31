
require 'default:base_ai_mob'
--handles when died
UnregisterEventHandler("", EventType.Message,"HasDiedMessage")
RegisterEventHandler(EventType.Message,"HasDiedMessage",
    function ()
        SetAITarget(nil)
        AI.ClearAggroList()
        AI.StateMachine.ChangeState("Dead")
        TurnNearbyMossIntoBloodMoss()
        CreateArrowsInPack()
    end)

function TurnNearbyMossIntoBloodMoss()
    -- TODO - Verlorens - Globalize this call, so it's not in base_player_death.lua AND base_ai_mob.lua
    -- TODO - Verlorens - Make it a more elegant way in which moss turns into bloodmoss.  
    -- Right now it's set so if something dies close enough to it, it turns into bloodmoss.
    -- Right now it's set so if ANY NPC dies.
    local nearbyMoss = FindObjects(SearchMulti(
		{
			SearchRange(this:GetLoc(), 8),
			SearchObjVar("ResourceSourceId","Moss"),
        }))
    for i,j in pairs(nearbyMoss) do
        if( this:GetObjVar("MobileKind") ~= "Undead") then
            CreateObj("plant_bloodmoss",j:GetLoc())
            j:Destroy()
        end
    end
    return
end

function CreateArrowsInPack() 
    local ArrowCount = this:GetObjVar("ArrowCount")
	if (ArrowCount) then
		local backpackObj = this:GetEquippedObject("Backpack")
        for k, v in pairs(ArrowCount) do
            k = k:sub(1,-2)
            local template = AllRecipes["WoodsmithSkill"][k].CraftingTemplateFile
			if (v > 0 ) then CreateStackInBackpack(this, template, v) end
		end
    end
    return
end
