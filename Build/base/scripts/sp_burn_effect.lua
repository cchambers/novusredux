BURN_TICKS = 4
MAX_BURN_DAMAGE = 6
MIN_BURN_DAMAGE = 3
FIRE_DAMAGE_MOD = 1.25
mBurnTicks = 0
mBurnSource = nil
this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(2200), "ValidateBurnEffect")

function HandleLoaded(source)
	--DebugMessage(tostring(this) .. " Burning from " .. tostring(source))
	--[[if not(this:HasObjVar("sp_burn_effectSource")) then
		EndEffect()
		return
	end]]
	local myBurnSource = source or this:GetObjVar("sp_burn_effectSource")
	if (myBurnSource == nil) or not(myBurnSource:IsValid()) then
		EndEffect()
		return
	end
	--[[local myDamageModifiersDict = {}
	if(this:HasObjVar("IncomingDamageModsMagicDict")) then myDamageModifiersDict = this:GetObjVar("IncomingDamageModsMagicDict") end
	local myTable = {Fire = FIRE_DAMAGE_MOD}
	myDamageModifiersDict.MAGIC_BURN_EFFECT = myTable
	this:SetObjVar("IncomingDamageModsMagicDict",myDamageModifiersDict)
]]
	--D*ebugTable(myTable)
	--D*ebugDict(myDamageModifiersDict)
	mBurnTicks = BURN_TICKS
	AddBuffIcon(this,"Burning","On Fire!","Immolation","Damage dealt to self while on fire.",true,BURN_TICKS)
	this:SystemMessage("[F7CC0A] Your skin begins to char and burn.[-]")
	this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(1000), "BurnEffectTickTimer", myBurnSource)
	this:PlayEffect("IgnitedEffect", 5)

end

function EndEffect()
	if(this:HasTimer("BurnEffectTickTimer")) then this:RemoveTimer("BurnEffectTickTimer") end
--[[
	local myDict = {}
	if(this:HasObjVar("IncomingDamageModsMagicDict")) then
		myDict = this:GetObjVar("IncomingDamageModsMagicDict")
		myDict.MAGIC_BURN_EFFECT = nil
		this:SetObjVar("IncomingDamageModsMagicDict", myDict)
	end
	]]
	--DebugMessage(tostring(this) .. " Stopped Burning")
	this:StopEffect("IgnitedEffect")
	this:RemoveTimer("BurnEffectTickTimer")
	this:RemoveTimer("ValidateBurnEffect")
	this:DelObjVar("sp_burn_effectSource")
	this:FireTimer("sp_burn_effect_removemodule")
end

function ModuleCleanUp()
	this:DelModule("sp_burn_effect")
end
RegisterEventHandler(EventType.Timer, "sp_burn_effect_removemodule", ModuleCleanUp)


RegisterEventHandler(EventType.Message, "CritEffectsp_burn_effect", 
	function (source)
		--DebugMessage("Burned By" .. tostring(source))
		HandleLoaded(source)
	end)


RegisterEventHandler(EventType.Timer, "BurnEffectTickTimer", 
	function (burnSource)	
		
		if(mBurnTicks > 0) then
			local damAmount = math.random(MIN_BURN_DAMAGE, MAX_BURN_DAMAGE)
			this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(1000),"BurnEffectTickTimer", burnSource)
			this:SendMessage("ProcessTrueDamage", burnSource, damAmount, false, "Chest")
			mBurnTicks = mBurnTicks - 1
			
			return
		end
		this:SystemMessage("[F7CC0A] That burning sensation has cleared up.[-]")
		EndEffect()
	end)

RegisterEventHandler(EventType.Timer, "ValidateBurnEffect", 
	function ()
		if not(this:HasTimer("BurnEffectTickTimer")) then
			EndEffect()
			return
		end
	end)