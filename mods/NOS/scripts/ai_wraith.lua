require 'NOS:base_ai_mob'
require 'NOS:base_ai_intelligent'

this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"SetColor")

RegisterEventHandler(EventType.Message, "HasDiedMessage",
    function(killer)
        if (not this:HasObjVar("IsGhost")) then
    	   MoveEquipmentToGround(this,this:GetObjVar("DoNotSpawnChest"))
        else
        	--DFB TODO: Create ghost ectoplasm here.
        end
    	this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.5),"DestroyWraith")
    	PlayEffectAtLoc("VoidPillar",this:GetLoc(),2)
    end)

RegisterEventHandler(EventType.Timer,"DestroyWraith",function ( ... )
	this:Destroy()
end)

RegisterEventHandler(EventType.Timer,"SetColor",
function()
	if (this:HasObjVar("IsGhost")) then
		this:SetObjVar("IsGhost",true)
		this:SetCloak(true)
		--this:GetEquippedObject("Chest"):SetColor("0xC100FFFF")
		--this:GetEquippedObject("Legs"):SetColor("0xC100FFFF")
	end
end)
