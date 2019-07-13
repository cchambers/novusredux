NUM_TRAP_TYPES = 5
local chanceToTrap = this:GetObjVar("ChanceToBeTrapped") or 0
local roll = math.random(1,100)
if (roll < chanceToTrap) then
	this:SetObjVar("TrapType",math.random(1,NUM_TRAP_TYPES))
	this:AddModule("trapped_object")
end