--familiar.lua

SUMMON_TIME = 4

function CancelSummon()
	this:RemoveTimer("SummonTimer")
end

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
function()
	RemoveUseCase(this,"Equip")
	AddUseCase(this,"Summon",true)
end)

RegisterEventHandler(EventType.Message,"UseObject",function (user,useType)
	if (user == nil or (not user:IsValid()) or useType == nil) then
		return
	end

	if (this:TopmostContainer() ~= user) then
		user:SystemMessage("This needs to be in your backpack to summon it.","info")
		return
	end

	if (this:HasTimer("SummonTimer")) then
		user:SystemMessage("You are already summoning a familiar.","info")
		return 
	end

	local equippedFamiliar = user:GetEquippedObject("Familiar")
	if (equippedFamiliar ~= nil) then
		equippedFamiliar:Destroy()	
	end

	if (useType == "Summon") then
		user:PlayAnimation("cast")
		ProgressBar.Show
		{
			TargetUser=user,
			Label="Summoning",
			Duration=SUMMON_TIME,
			PresetLocation="AboveHotbar",
		}
		SetMobileModExpire(user, "Freeze", "SummonFamiliar", true, TimeSpan.FromSeconds(SUMMON_TIME))
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(SUMMON_TIME),"SummonTimer",user)
	end
end)

RegisterEventHandler(EventType.Timer,"SummonTimer",function (user)
	if (user == nil or not user:IsValid()) then return end

	if (this:TopmostContainer() ~= user) then
		user:SystemMessage("This needs to be in your backpack to summon it.")
		return
	end

	user:PlayAnimation("idle")
	CreateEquippedObj(this:GetObjVar("FamiliarTemplate"),user,"equip_familiar")
end)