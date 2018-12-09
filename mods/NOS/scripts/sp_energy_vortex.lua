--MAX_MINIONS = ServerSettings.Combat.MaxMinions
--IMPS_LIFETIME = 90
--DebugMessage(1)

function HandleLoaded(location)
	--DFB TODO: THIS SHOULD BE MORE SOPHISTICATED
	local myResSource = this
	local currentMinions = FindObjects(SearchObjVar("controller",myResSource))
	--DebugMessage("followers = "..#currentFollowers)
	if (#currentMinions >= MAX_MINIONS) then
		myResSource:SystemMessage("[D70000]You have too many minions in play![-]","info")
		EndEffect()
		return
	end
	
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.5), "SpawnTimer", location)
	PlayEffectAtLoc("VoidTeleportToEffect",location,4)
end

function EndEffect()
	this:DelModule("sp_energy_vortex")
end

RegisterEventHandler(EventType.Timer, "EndResEffect", 
	function ()
		EndEffect()
	end)
RegisterEventHandler(EventType.Message, "EnergyvortexSpellTargetResult", 
	function (location)
		--DebugMessage(2)
		HandleLoaded(location)
	end)


RegisterEventHandler(EventType.Timer, "SpawnTimer", 
	function (location)
		--DebugMessage("Creating skelton")
		CreateObj("energy_vortex",location,"CreateEnergyVortex")
		this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(1500), "EndResEffect")
	end)

RegisterEventHandler(EventType.CreatedObject,"CreateEnergyVortex",
function (success,objRef)
	local myResSource = this
	if myResSource == nil or not(myResSource:IsValid()) then
		DebugMessage("[sp_energy_vortex] ERROR: Could not find assigned spell source")
		EndEffect()
		return
	end

    objRef:AddModule("slay_decay")
    objRef:SetObjVar("SlayDecayTime",IMPS_LIFETIME)
    objRef:SetObjVar("Summon", true)
	
	EndEffect()
end)