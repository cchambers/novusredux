FREEZE_SECONDS = 2
this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(2000), "RemoveFreezeEffect")

function HandleLoaded()
	if not(this:HasObjVar("sp_freeze_effectSource")) then
		EndEffect()
		return
	end
	local myBurnSource = this:GetObjVar("sp_freeze_effectSource")
	if not(myBurnSource:IsValid()) then
		EndEffect()
		return
	end

	--D*ebugTable(myTable)
	--D*ebugDict(myDamageModifiersDict)
	SetMobileModExpire(this, "Freeze", "IceFrozen", true, TimeSpan.FromSeconds(FREEZE_SECONDS))
	AddBuffIcon(this,"FrozenSolid","Frozen Solid","Ice Barrier","Cannot move!",true,FREEZE_SECONDS)
	this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(FREEZE_SECONDS * 1000), "RemoveFreezeEffect")
	this:SystemMessage("[F7CC0A] Your body freezes in place.[-]")
	myBurnSource:SystemMessage("[F7CC0A] Your target's body freezes in place.[-]")
	this:PlayEffect("FrozenObjectEffect")
end

function EndEffect()
	this:RemoveTimer("RemoveFreezeEffect")
	this:StopEffect("FrozenObjectEffect")
	SetMobileMod(this, "Freeze", "IceFrozen", nil)
	this:DelObjVar("sp_freeze_effectSource")
	this:FireTimer("sp_freeze_effect_removemodule")
end

function ModuleCleanUp()
	this:DelModule("sp_freeze_effect")
end
RegisterEventHandler(EventType.Timer, "sp_freeze_effect_removemodule", ModuleCleanUp)


RegisterEventHandler(EventType.Message, "CritEffectsp_freeze_effect", 
	function ()
		HandleLoaded()
	end)


RegisterEventHandler(EventType.Timer, "RemoveFreezeEffect", 
	function ()
			EndEffect()
			return
		
	end)