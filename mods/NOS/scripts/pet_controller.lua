require 'default:pet_controller'
require 'loop_effect'
-- require 'base_pet_casting'

SetCurVitality(this,GetMaxVitality(this))

function CleanUpModule()
	this:SetObjectOwner(nil)
	this:SetSharedObjectProperty("Title", "Released Pet")
	RemoveTooltipEntry(this, "PetOwner", "Released Pet")
	
	local livingName = this:GetObjVar("LivingName")
	if ( livingName ) then
		this:SetName(livingName)
	end
	this:SetObjVar("WasTamed", true)

	this:StopMoving()

	this:AddModule("ai_prey")
	this:AddModule("released_pet")

	-- delete variables no longer needed
	this:DelObjVar("controller")
	this:DelObjVar("NoReset")
	this:DelObjVar("MobileTeamType")
	this:DelObjVar("CommandName")
	this:DelObjVar("TamingDifficulty") -- no longer tamable
	this:DelObjVar("Karma")

	Decay(this)

	this:SendMessage("UpdateName")
	this:DelModule("pet_controller")
end