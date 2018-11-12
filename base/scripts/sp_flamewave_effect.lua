
mEndLoc = nil
mStartLoc = nil
COST_PER_UNIT = 5
WAVE_SEPERATION = 2
MIN_FLAME_DISTANCE = 4
MIN_ADDITIONAL_DISTANCE = 2
mProjAngle = 0
WAVE_ANGLE = 25

this:ScheduleTimerDelay(TimeSpan.FromSeconds(2), "FlamewaveRemoveTimer")
function ValidateFlameDestination(targetLoc)
	------DebugMessage("----Debuggery Deh Yah")
	if( not(IsPassable(targetLoc)) ) then
		this:SystemMessage("[$2607]")
		return falses
	end

	if not(this:HasLineOfSightToLoc(targetLoc,ServerSettings.Combat.LOSEyeLevel)) then
		this:SystemMessage("[$2608]")
		return false
	end

	return true
end

function InitiateFlamewave(targetLoc)
	mStartLoc = this:GetLoc()
	mStartFacing = mStartLoc:YAngleTo(targetLoc)
	mEndLoc = targetLoc:Project(mStartFacing,MIN_FLAME_DISTANCE)
	mDistance = math.max(mStartLoc:Distance(mEndLoc),MIN_FLAME_DISTANCE)
	CreateTempObj("spell_aoe",this:GetLoc(),"aoe_created")
	CreateTempObj("spell_aoe",mStartLoc,"aoe_created")
	this:FireTimer("FlamewaveTickTimer" , 1)
end
RegisterEventHandler(EventType.CreatedObject,"aoe_created",function (success,objRef)
	if (success) then
		objRef:SetObjVar("DecayTime",3)
	end
end)
RegisterEventHandler(EventType.Timer, "FlamewaveTickTimer", 
	function(tick)
		HandleFlamewaveTick(tick)
		end)

function HandleFlamewaveTick(tickNum)
	--DebugMessage("Ticking: " ..tickNum)
		if (tickNum == nil or mDistance == nil) then
			this:FireTimer("FlamewaveRemoveTimer")
			return
		end
			--DebugMessage("Playing")
		if(tickNum == nil or tickNum > mDistance) then 
			this:FireTimer("FlamewaveRemoveTimer")
			return
		end

			local curAngleLocMin = mStartLoc:Project((mStartFacing + WAVE_ANGLE),tickNum)
			local curAngleLocMax = mStartLoc:Project((mStartFacing - WAVE_ANGLE),tickNum)
			local distance = curAngleLocMax:Distance(curAngleLocMin)
			local amt = 0
			while (amt < distance) do
				local waveAngle = curAngleLocMin:YAngleTo(curAngleLocMax)
				curLoc = curAngleLocMin:Project(waveAngle,amt)
				PlayEffectAtLoc("FirePillarEffect",Loc(curLoc),2.5)
				amt = amt + WAVE_SEPERATION
				if (tickNum % 2 == 0) then
					local mobiles = FindObjects(SearchMulti({
								SearchRange(curLoc,1.5),
								SearchMobile()}), GameObj(0))
					for i,v in pairs(mobiles) do
					--v:NpcSpeech("Burning Burning burning")
						if(not IsDead(v)) then
							this:SendMessage("RequestMagicalAttack", "Flamewave", v, this, true)
							v:PlayEffect("IgnitedEffect", 5)
							v:PlayAnimation("was_hit")
						end
					end
				end
			end
			------DebugMessage("PULSE!!")
	this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(250), "FlamewaveTickTimer", tickNum + 1)
end

RegisterEventHandler(EventType.Message,"FlamewaveSpellTargetResult",
	function (targetLoc)
		-- validate teleport
		if not(ValidateFlameDestination(targetLoc)) then
			this:DelModule("sp_flamewave_effect")
			return
		end
	this:RemoveTimer("FlamewaveTickTimer")
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(5), "FlamewaveTickTimer")
	InitiateFlamewave(targetLoc)
end)



RegisterEventHandler(EventType.Timer,"FlamewaveRemoveTimer",
	function()
		this:DelModule("sp_flamewave_effect")
	end)


