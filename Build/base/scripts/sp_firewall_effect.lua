mTotalProjs = 0
mTickCount = 0
mEndLoc = nil
mLoc = {}
COST_PER_UNIT = 5
function ValidateWall(targetLoc)
	----DebugMessage("--Debuggery Deh Yah")
	if( not(IsPassable(targetLoc)) ) then
		this:SystemMessage("[$2603]")
		return falses
	end

	if not(this:HasLineOfSightToLoc(targetLoc,ServerSettings.Combat.LOSEyeLevel)) then
		this:SystemMessage("[$2604]")
		return false
	end

	return true
end

function InitiateFireWall()
	local startPoint = Loc(mLoc[0])
	local projAngle = startPoint:YAngleTo(mEndLoc)
	local mana = GetCurMana(this)
	local curProj = 1
	--DebugMessage("Fire At :" .. tostring(startPoint))
	--DebugMessage("EndIt : " ..tostring(mEndLoc))
		PlayEffectAtLoc("FirePillarEffect",startPoint, 5)
	local dist = startPoint:Distance(mEndLoc)
	--DebugMessage("Dist:" .. dist)
	while(curProj < dist) do
	
		local nextLoc = startPoint:Project(projAngle,curProj)
		if (this:HasLineOfSightToLoc(Loc(nextLoc))) then
			--DebugMessage("Fire At :" .. "pt: " .. curProj.. tostring(nextLoc))
			--need to make this to tell mobs to avoid it
			--CreateTempObj("spell_aoe",nextLoc,"aoe_created")
			if(mana > (COST_PER_UNIT * curProj)) then
				mLoc[curProj] = nextLoc
				PlayEffectAtLoc("FirePillarEffect",nextLoc, 5)
				AdjustCurMana(this, -1 * COST_PER_UNIT)
				mTotalProjs = curProj
			else
				break
			end			
		end
		curProj = curProj + 1
	end
	this:PlayObjectSound("WallofFire", false)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "FirewallRemoveTimer")
	this:FireTimer("FireWallTickTimer")
end
RegisterEventHandler(EventType.Timer, "FireWallTickTimer", 
	function()
		HandleFirewallTick()
		end)

RegisterEventHandler(EventType.CreatedObject,"aoe_created",function (success,objRef)
	if (success) then
		objRef:SetObjVar("DecayTime",5)
	end
end)
RegisterEventHandler(EventType.CreatedObject,"aoe_created_short",function (success,objRef)
	if (success) then
		objRef:SetObjVar("DecayTime",3)
	end
end)

function HandleFirewallTick()
	--DebugMessage("Ticking: " ..mTickCount)
	if((math.floor(mTickCount/2) * mTickCount)  == mTickCount) then
		--DebugMessage("Playing Firewall")
	end
	if(mTickCount == -1) then return end
	for indy, fLocs in pairs(mLoc) do
		--DebugMessage("CHECK 1 WOF: ",this:HasLineOfSightToLoc(Loc(fLocs)))
		if (this:HasLineOfSightToLoc(Loc(fLocs))) then
			if(mTickCount == 0) then
				--DebugMessage("Playing")
				--CreateTempObj("spell_aoe",Loc(fLocs),"aoe_created_short")
				PlayEffectAtLoc("FirePillarEffect",Loc(fLocs), 3)
			end
				----DebugMessage("PULSE!!")
				local mobiles = FindObjects(SearchMulti({
							SearchRange(fLocs,1),
							SearchMobile()}), GameObj(0))
			for i,v in pairs(mobiles) do
			--v:NpcSpeech("Burning Burning burning")
				if ( ValidCombatTarget(this, v, true) ) then
					this:SendMessage("RequestMagicalAttack", "Walloffire", v, this, true)
					if(not v:HasModule("sp_burn_effect")) then
						v:SetObjVar("sp_burn_effectSource" , this)
						v:AddModule("sp_burn_effect")
					end
				end
			end
		end
	end
	mTickCount = mTickCount + 1
	if(mTickCount > 0) then mTickCount = 0 end
	--DebugMessage("Scheduling")
	this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(1000), "FireWallTickTimer")
end

RegisterEventHandler(EventType.Message,"WalloffireSpellTargetResult",
	function (targetLoc)
		-- validate teleport
--DebugMessage("--Debuggery Here2")
----DebugMessage("Loc:" ..tostring(targetLoc))
		if not(ValidateWall(targetLoc)) then
			this:DelModule("sp_firewall_effect")
			return
		end

--	--DebugMessage("--Debuggery Here")

this:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "FirewallRemoveTimer")
		mLoc = {}
		mLoc[0] = targetLoc
		mEndLoc = nil
		mTickCount = -1
		mTotalProjs = 0
		this:SystemMessage("[08FFFF] Select Firewall End Point.[-]")
		this:RequestClientTargetLoc(this, "SelectFireWallEndPoint")
	end)



RegisterEventHandler(EventType.Timer,"FirewallRemoveTimer",
	function()
		this:DelModule("sp_firewall_effect")
	end)


RegisterEventHandler(EventType.ClientTargetLocResponse, "SelectFireWallEndPoint", 
	function(success, endLoc)
	if not (success) then
				this:SystemMessage("[$2605]")
		this:RequestClientTargetLoc(this, "SelectFireWallEndPoint")
		return
	end
	--DebugMessage("endLoc" ..tostring(endLoc))
		if(ValidateWall(endLoc)) then
			mEndLoc = endLoc
			--DebugMessage("InitWall")
			mTickCount = 0
			InitiateFireWall()
		end
	end)