require 'default:pet_controller'
require 'base_pet_casting'

SetCurVitality(this,GetMaxVitality(this))

function ClearState(skipCombat)
    -- CorrectPetStats(this)

	if ( _IsFollowing ) then
		_WasFollowing = _IsFollowing
		_IsFollowing = nil
	end
	if ( skipCombat ~= true and _IsAttacking ) then
		_IsAttacking = nil
		SetCurrentTarget(nil)
		SetInCombat(false, true)
	end
	ClearPath()
end

function StableSelf()
    -- CorrectPetStats(this)

	Verbose("PetController", "StableSelf")
	if ( CheckOwner() ) then
		local tempPack = _MyOwner:GetEquippedObject("TempPack")
		if ( tempPack ~= nil ) then
			ClearState()
			this:MoveToContainer(tempPack,Loc(0,0,0))
		end
	end
end

RegisterEventHandler(EventType.Message, "ClearTarget",
    function()
        AI.ClearAggroList()
        SetAITarget(nil)   
    end)


function UnStableSelf()
    -- CorrectPetStats(this)

	-- should be in backpack.
	local topMost = this:TopmostContainer()
	if ( topMost == nil ) then return end -- can't unstable, already in the world!

	this:SetWorldPosition(topMost:GetLoc())

	if ( CheckOwner() ) then
		UserPetCommand("follow", _MyOwner)
	end
end

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