require 'default:pet_controller'

-- require 'base_ai_casting'

SetCurVitality(this,GetMaxVitality(this))

function ClearState(skipCombat)
    CorrectPetStats(this)

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
    CorrectPetStats(this)

	Verbose("PetController", "StableSelf")
	if ( CheckOwner() ) then
		local tempPack = _MyOwner:GetEquippedObject("TempPack")
		if ( tempPack ~= nil ) then
			ClearState()
			this:MoveToContainer(tempPack,Loc(0,0,0))
		end
	end
end

function UnStableSelf()
    CorrectPetStats(this)

	-- should be in backpack.
	local topMost = this:TopmostContainer()
	if ( topMost == nil ) then return end -- can't unstable, already in the world!

	this:SetWorldPosition(topMost:GetLoc())
	this:SetObjectOwner(topMost)

	if ( CheckOwner() ) then
		UserPetCommand("follow", _MyOwner)
	end
end