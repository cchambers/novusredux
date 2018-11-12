require 'base_idol_player_script'

--Make them really clumsy, failing to hit or harvest anything
function AttachDebuff()
	this:SetObjVar("ModHitChance",-100)
	this:SetObjVar("ResourceHarvestMod",-100)--more means less of a chance of harvesting
end

function DetachDebuff()
	this:DelObjVar("ModHitChance")
	this:DelObjVar("ResourceHarvestMod")
end

AttachDebuff()