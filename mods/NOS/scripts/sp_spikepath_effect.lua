
mEndLoc = nil
mLoc = {}
COST_PER_UNIT = 5
MINIMUM_DISTANCE = SpellData.AllSpells.Spikepath.SpellRange
mProjAngle = 0
this:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "SpikePathRemoveTimer")
function ValidateSpikeDestination(targetLoc)
	------DebugMessage("----Debuggery Deh Yah")
	if( not(IsPassable(targetLoc)) ) then
		this:SystemMessage("[$2628]","info")
		return falses
	end

	if not(this:HasLineOfSightToLoc(targetLoc,ServerSettings.Combat.LOSEyeLevel)) then
		this:SystemMessage("[$2629]","info")
		return false
	end

	return true
end

function InitiateSpikepath(targetLoc)
	local startPoint =this:GetLoc()
	local projAngle = startPoint:YAngleTo(targetLoc)
	local mana = GetCurMana(this)
	local curProj = 0
	mProjAngle = projAngle
	----DebugMessage("Fire At :" .. tostring(startPoint))
	--DebugMessage("EndIt : " ..tostring(mEndLoc))
	mEndLoc = startPoint:Project(projAngle,MINIMUM_DISTANCE)
	dist = (startPoint:Distance(mEndLoc) / 2)

	--DebugMessage("Dist:" .. dist)
	nextProj = 2
	while(curProj <= dist) do
	
		local nextLoc = startPoint:Project(projAngle,(curProj * nextProj) + 1.5 )
		--DebugMessage("Fire At :" .. "pt: " .. curProj.. tostring(nextLoc))
		if(mana > (COST_PER_UNIT * curProj)) then
			mLoc[curProj] = nextLoc
			AdjustCurMana(this, -1 * COST_PER_UNIT)
			curProj = curProj + 1
		else
			break
		end
	end
	this:PlayObjectSound("event:/magic/earth/magic_earth_spike_path", false)
	this:FireTimer("SpikepathTickTimer" , 1)
end
RegisterEventHandler(EventType.Timer, "SpikepathTickTimer", 
	function(tick)
		HandleSpikePathTick(tick)
		end)

RegisterEventHandler(EventType.CreatedObject,"aoe_created",function (success,objRef)
	if (success) then
		objRef:SetObjVar("DecayTime",3)
	end
end)
function HandleSpikePathTick(tickNum)
	--DebugMessage("Ticking: " ..tickNum)
			--DebugMessage("Playing")
			if(tickNum == nil) or (mLoc[math.floor(tickNum)] == nil)then 
				this:FireTimer("SpikePathRemoveTimer")
			return
		end
			local curLoc = mLoc[math.floor(tickNum)]

			if(tickNum == math.floor(tickNum)) then 
				PlayEffectAtLoc("GroundSpikeEffect",Loc(curLoc)) 
				CreateTempObj("spell_aoe",Loc(curLoc),"aoe_created")
			end
		
			------DebugMessage("PULSE!!")
			--local damLoc = curLoc:Project(projAngle, 1 )
		local mobiles = FindObjects(SearchMulti({
					SearchRange(curLoc,1.5),
					SearchMobile()}), GameObj(0))
		for i,v in pairs(mobiles) do
		--v:NpcSpeech("Burning Burning burning")
			if(not IsDead(v)) and not v:HasTimer("SpikePathDamageTimer") then
				v:ScheduleTimerDelay(TimeSpan.FromSeconds(.5), "SpikePathDamageTimer")
				this:SendMessage("RequestMagicalAttack", "Spikepath", v, this, true)
			end
		end
	
	if((curLoc:Distance(mEndLoc) < .5) and (tickNum == math.floor(tickNum))) then
		this:FireTimer(SpikePathRemoveTimer)
	else
		this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(250), "SpikepathTickTimer", tickNum + 0.5)
	end
end
RegisterEventHandler(EventType.Message,"SpikepathSpellTargetResult",
	function (targetLoc)
		-- validate teleport
		------DebugMessage("----Debuggery Here2")
		--DebugMessage("Loc:" ..tostring(targetLoc))
				if not(ValidateSpikeDestination(targetLoc)) then
					this:DelModule("sp_spikepath_effect")
					return
				end
		--DebugMessage("----Debuggery Here")
		this:RemoveTimer("SpikepathTickTimer")
		this:StopObjectSound("event:/magic/earth/magic_earth_spike_path", false, 0.2)
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "SpikePathRemoveTimer")
		InitiateSpikepath(targetLoc)
	end)



RegisterEventHandler(EventType.Timer,"SpikePathRemoveTimer",
	function()
		this:DelModule("sp_spikepath_effect")
	end)


