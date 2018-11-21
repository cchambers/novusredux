MAX_HEAL_AMOUNT = 20
MIN_HEAL_AMOUNT = 1

function HandleLoaded()
	local myResSource = this:GetObjVar("sp_mana_Fdrain_regenSource")
	if not(this:HasObjVar("sp_drain_regenSource")) then
		EndEffect()
		return
	end
	local amount = math.random(MIN_HEAL_AMOUNT,MAX_HEAL_AMOUNT)
	myResSource:SystemMessage("[D7D700]You regain "..amount.." mana")
	AdjustCurMana(myResSource,amount)
	EndEffect()
end

function EndEffect()
	if(this:HasTimer("HealEffectTickTimer")) then this:RemoveTimer("HealEffectTickTimer") end
	this:DelModule("sp_drain_regen")
	--this:StopEffect("DrainEffect")
end

RegisterEventHandler(EventType.Message, "CritEffectsp_drain_regen", 
	function ()
		HandleLoaded()
	end)

RegisterSingleEventHandler(EventType.ModuleAttached, "sp_drain_regen", 
	function ()
		HandleLoaded()
	end)