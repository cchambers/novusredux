
HEAL_TICKS = 4
MAX_HEAL_AMOUNT = 8
MIN_HEAL_AMOUNT = 4
mHealTicks = 0
this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(2500), "ValidateHealEffect")

function HandleLoaded()
	if not(this:HasObjVar("sp_heal_effectSource")) then
		EndEffect()
		return
	end
	local myHealSource = this:GetObjVar("sp_heal_effectSource")
	if not(myHealSource:IsValid()) then
		EndEffect()
		return
	end

	--D*ebugTable(myTable)
	--D*ebugDict(myDamageModifiersDict)
	AddBuffIcon(this,"CriticalHealing","Heal Over Time","heal","Heals on a pulse for a period of time.",true,8)
	mHealTicks = HEAL_TICKS
	this:SystemMessage("[$2611]")
	this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(1000), "HealEffectTickTimer", myHealSource)
end

function EndEffect()
	if(this:HasTimer("HealEffectTickTimer")) then this:RemoveTimer("HealEffectTickTimer") end
	RemoveBuffIcon(this,"CritHealing")
	this:DelModule("sp_heal_effect")
end

RegisterEventHandler(EventType.Message, "CritEffectsp_heal_effect", 
	function ()
		HandleLoaded()
	end)

RegisterSingleEventHandler(EventType.ModuleAttached, "sp_heal_effect", 
	function ()
		HandleLoaded()
	end)

RegisterEventHandler(EventType.Timer, "HealEffectTickTimer", 
	function (healSource)
		if(mHealTicks > 0) then
			local healAmount = math.random(MIN_HEAL_AMOUNT, MAX_HEAL_AMOUNT)
			this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(2000),"HealEffectTickTimer", healSource)		
			this:SendMessage("HealRequest", healAmount,healSource)
			mHealTicks = mHealTicks - 1
			return
		end
		this:SystemMessage("[F7CC0A] The rejuvination effect has ended.[-]")
		EndEffect()
	end)

RegisterEventHandler(EventType.Timer, "ValidateHealEffect", 
	function()
		if not(this:HasTimer("HealEffectTickTimer")) then
			EndEffect()
			return
		end
	end)