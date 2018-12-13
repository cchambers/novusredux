--require 'base_magic_sys'
local METOR_IMPACT_RANGE = 5
local mTargetLoc = nil
local function ValidateMeteor(targetLoc)
	--DebugMessage("Debuggery Deh Yah")
	if( not(IsPassable(targetLoc)) ) then
		this:SystemMessage("[$2614]","info")
		return false
	end

	if not(this:HasLineOfSightToLoc(targetLoc,ServerSettings.Combat.LOSEyeLevel)) then
		this:SystemMessage("[$2615]","info")
		return false
	end
	return true
end

RegisterEventHandler(EventType.Message,"MeteorSpellTargetResult",
	function (targetLoc)
		if not(ValidateMeteor(targetLoc)) then
			EndEffect()
			return
		end
		mTargetLoc = targetLoc
		PlayEffectAtLoc("MeteorEffect",mTargetLoc, 5)

		this:ScheduleTimerDelay(TimeSpan.FromSeconds(1.5),"MeteorImpact",mTargetLoc)
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"MeteorRemove",mTargetLoc)
	end)

RegisterEventHandler(EventType.Timer, "MeteorImpact",
function()
	this:PlayObjectSound("event:/magic/earth/magic_earth_cast_meteor", false)
	local mobiles = FindObjects(SearchMulti({
					SearchRange(mTargetLoc,METOR_IMPACT_RANGE),
					SearchMobile()}), GameObj(0))
	for i,v in pairs(mobiles) do
		if ( ValidCombatTarget(this, v, true) ) then
			this:SendMessage("RequestMagicalAttack", "Meteor", v, this, true)
		end
	end
	PlayEffectAtLoc("ImpactWaveEffect", mTargetLoc, 5)
end)

RegisterEventHandler(EventType.Timer,"MeteorRemove",
	function()
		EndEffect()
	end)

function EndEffect()
	if(this:HasTimer("MeteorImpact")) then this:RemoveTimer("MeteorImpact") end
	if(this:HasTimer("MeteorRemove")) then this:RemoveTimer("MeteorRemove") end
	this:DelModule("sp_meteor_effect")
end