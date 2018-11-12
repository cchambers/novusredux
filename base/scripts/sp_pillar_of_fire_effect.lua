
local PILLAROFFIRE_DAMAGE_RANGE = 2
local mTargetLoc = nil
local mPillarActive = false
local function ValidatePillarOfFire(targetLoc)

	if( not(IsPassable(targetLoc)) ) then
		this:SystemMessage("[$2616]")
		return false
	end

	if not(this:HasLineOfSightToLoc(targetLoc,ServerSettings.Combat.LOSEyeLevel)) then
		this:SystemMessage("[$2617]")
		return false
	end
	return true
end

RegisterEventHandler(EventType.Message,"PillaroffireSpellTargetResult",
	function (targetLoc)
		if not(ValidatePillarOfFire(targetLoc)) then
			EndEffect()
			return
		end
		if(mPillarActive == false) then
			mTargetLoc = targetLoc
		end
		this:PlayObjectSound("PillarofFire", false)
		PlayEffectAtLoc("FireTornadoEffect",mTargetLoc, 5)
		local mobiles = FindObjects(SearchMulti({
						SearchRange(mTargetLoc,PILLAROFFIRE_DAMAGE_RANGE),
						SearchMobile()}), GameObj(0))
		for i,v in pairs(mobiles) do
			if(not IsDead(v)) then
				this:SendMessage("RequestMagicalAttack", "Pillaroffire", v, this, true)
			end
		end

		EndEffect()

	end)



function EndEffect()
	this:DelModule("sp_pillar_of_fire_effect")
end