require 'NOS:incl_magic_sys'

FLAMEAURA_DAMAGE_RANGE = 3.5
--local ignoreView = true
PULSE_COST = -2
PULSE_SPEED = 1000
mPulseID = 0
mTargetsIR = {}
--DebugMessage("flameaura ATTACHY")
mUpkeep = 1
mActive = false
FLAME_AURA_MS_MOD = .8

function StartFlameAuraEffect()
	--DebugMessage("Starting")
		--this:SetObjVar("Dangerous",true)
		if(mActive == false) then
			mActive = true
			this:SetObjVar("AuraoffireBonusCastingOffset", -.4)
		else
			EndEffect()
			--DebugMessage("Ending It")
			return
		end
		if not(HasView("FlameAuraView")) then AddView("FlameAuraView",SearchMobileInRange(FLAMEAURA_DAMAGE_RANGE, true)) end
		local upkeepCost = GetSpellInformation("Auraoffire", "upkeepCost")
		if(upkeepCost ~= nil) and (upkeepCost ~= 0) then
			mUpkeep = upkeepCost
			SetMobileMod(this, "ManaRegenPlus", "FlameAuraUpkeep", upkeepCost)
		end
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"FlameAuraPulse")
		--this:SetObjVar("FlameauraBonusCastingOffset", 1.2)
		this:PlayObjectSound("event:/magic/fire/magic_fire_wall_of_fire", false)
			
		AddBuffIcon(this,"FlameAura","Flame Aura","flameaura","[$2606]",true,30)
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(30),"FlameAuraRemove")
		--this:SendMessage("AddMoveSpeedEffectMessage", "sp_flameaura_effect", "Multiplier", FLAME_AURA_MS_MOD)
		this:PlayEffect("FlameAuraEffect")
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(6), "FlameEffectLoop")
end

RegisterEventHandler(EventType.Timer, "FlameEffectLoop",
	function()
	
			this:PlayEffect("FlameAuraEffect")
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(6), "FlameEffectLoop")
	
	end)
RegisterEventHandler(EventType.Message, "CompletionEffectsp_flameaura_effect",
	function()
		--DebugMessage("LAUNCHE MESSAGE)")
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(1), "FlameAuraLaunchTimer")
		StartFlameAuraEffect()
	end)

function EndEffect()
		this:DelObjVar("AuraoffireBonusCastingOffset")
		this:RemoveTimer("FlameAuraPulse")
		this:RemoveTimer("FlameAuraRemove")
		this:RemoveTimer("FlameEffectLoop")
		RemoveBuffIcon(this,"FlameAura")
		this:StopEffect("FlameAuraEffect")
		SetMobileMod(this, "ManaRegenPlus", "FlameAuraUpkeep", nil)
		--this:SendMessage("RemoveMoveSpeedEffectMessage", "sp_flameaura_effect")
		DelView("FlameAuraView")
		this:FireTimer("FlameAuraCleanUpTimer")
end

RegisterEventHandler(EventType.EnterView, "FlameAuraView", 
	function(damTarget)
		--DebugMessage("Enter Aura View:" .. damTarget:GetName())
			local myPulseId = mPulseID + 1
			if(myPulseId > 3) then myPulseId = 0 end
			mTargetsIR[damTarget] = myPulseId
	end)

RegisterEventHandler(EventType.Timer, "FlameAuraPulse",
	function()
		--DebugMessage("Pulse " ..mPulseID)
		this:SendMessage("BreakInvisEffect", "Casting")
		local curMana = GetCurMana(this)
		if(curMana < (-1* PULSE_COST)) then
			EndEffect()
			return
		end
		local charge =false
		local hit = false
		mPulseID = mPulseID + 1
		if(mPulseID > 3) then mPulseID = 0 end
		hit = false
	for i,v in pairs(mTargetsIR) do
		--DebugMessage(i:GetName())
		if(mTargetsIR[i] == mPulseID) then
			if (not IsDead(i)) and (i:ContainedBy() == nil) then
				hit = true
				--DebugMessage("Hit")
				this:SendMessage("RequestMagicalAttack", "Auraoffire",i, this, true)

			end
		end
	end
		if(hit) then
			this:PlayObjectSound("event:/magic/fire/magic_fire_wall_of_fire", false)
			AdjustCurMana(this,PULSE_COST)
		end
	
	this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(PULSE_SPEED), "FlameAuraPulse")
end)

RegisterEventHandler(EventType.LeaveView, "FlameAuraView",
	function(objLeavin)
		mTargetsIR[objLeavin] = nil
end)

RegisterEventHandler(EventType.Message,"HasDiedMessage",
	function()
		EndEffect()
	end)
RegisterEventHandler(EventType.Timer,"FlameAuraRemove",
	function()
		EndEffect()
	end)



RegisterEventHandler(EventType.Timer, "FlameAuraCleanUpTimer",
	function()
		--this:DelObjVar("Dangerous")
		this:DelModule("sp_flameaura_effect")
		end)