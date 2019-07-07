mDamageFactor = 0
mSource = nil
mActive = false
RegisterEventHandler(EventType.Message, "DamageInflicted",
	function(dmgSource,damageAmt,damageType,isCrit,wasBlocked)
		if not(mActive) then return end
		if(mSource == nil) then return end
		if (damageInfo == nil) then return end
		if(dmgSource == this) then return end
		if(damageInfo.Class == "TrueDamage") then return end
		if(damageInfo.Type == "TrueDamage") then return end
		damageAmt = damageAmt or 1
		local damProp = .4 * damageAmt
		local damInf = {}
	--	DebugTable(damageInfo)
		damInf.damageAmt = damProp
		damInf.Class = "TrueDamage"
		damInf.damType = "TrueDamage"
		damInf.isCrit = false
		damInf.Slot = "Chest"
		damInf.wSource = mShareTarget
		--DebugMessage(dmgSource:GetName() .. " " .. damageAmt)
		mSource:SendMessage("DamageInflicted", mSource, damProp, false, damProp, damInf)
		if not(this:HasTimer("ExistenceTrustTimer")) then
			this:SendMessage("AdjustPetTrust", math.max(1, math.floor(damProp / 4)), mSource)
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"ExistenceTrustTimer")
		end
end)

RegisterEventHandler(EventType.Message, "SharedExistence_init", 
	function(source, damRet, duration)
		if(source ~= nil) and (this:GetObjVar("controller") ~= source) then
			return
		end
		mSource = source
		mDamageFactor = damRet or .4
		mActive = true
		duration = duration or 15
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(duration),"EndExistenceEffectTimer")


	end)
RegisterEventHandler(EventType.Message, "EndSharedExistence", function()
	mActive = false

	this:FireTimer("EndExistenceEffectTimer")
	end)
RegisterEventHandler(EventType.Timer, "EndExistenceEffectTimer", 
	function ()
	this:DelModule("shared_existence_target_effect")
end)
this:ScheduleTimerDelay(TimeSpan.FromSeconds(15), "EndExistenceEffectTimer")