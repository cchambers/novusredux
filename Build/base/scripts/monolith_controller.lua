
SpawnLocations = CeladorData.MonolithSpawnLocations

MobList = {
	{"skeleton_forest"},
	{"skeleton_forest"},
	{"skeleton_forest"},
	{"ancient_wraith"},
	{"ancient_wraith"},
}

AddView("questView", SearchMobileInRange(15))

--if the monoliths are not executed in a certain order, create undead
RegisterEventHandler(EventType.Message,"MonolithActivated",
	function(monolithNumber,monolith)
		local ghost = FindObject(SearchModule("npc_ghost_druid"))
		local players = FindObjects(SearchPlayerInRange(20))
		--DebugMessage("Monolith Message Received")
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(60),"ResetMonolith")
		local currentMonolith = this:GetObjVar("CurrentActive") or 0
		--DebugMessage("monlithNumber is "..tostring(monolithNumber).." currentMonolith is "..tostring(currentMonolith))
		if (monolithNumber - 1 ~= currentMonolith) then
			if (ghost ~= nil) then
				ghost:NpcSpeech("[$1943]")
			end
			currentMonolith = math.clamp(currentMonolith,1,5)
			SpawnUndead(currentMonolith)
			ResetMonoliths()
			return
		end
		this:SetObjVar("CurrentActive",monolithNumber)
		if (monolithNumber == 5 and currentMonolith == 4) then
			PlayEffectAtLoc("CloakEffect",this:GetLoc())
			if (ghost == nil) then
				CreateObj("cel_ghost_forest_druid",this:GetLoc(),"ghostCreated")
			end
			for i,j in pairs(players) do
    			j:SendMessage("AdvanceQuest","InvestigateMonolithQuest","TalkToDruid","ActivateMonolith")
				--DebugMessage(j:GetName())
				--DebugMessage("CanSeeGhosts is "..tostring(j:HasObjVar("CanSeeGhosts")))
				TaskDialogNotification(j,"[$1944]","A Mysterious Voice")
			end
			ResetMonoliths()
			return
		end
		monolith:SendMessage("MonolithActivate")
	end)

RegisterEventHandler(EventType.Timer,"ResetMonolith",
	function ()
		ResetMonoliths()
	end)

function SpawnUndead(index)
	local presentUndead = FindObjects(SearchMulti({SearchObjVar("MobileTeamType","UndeadGraveyard"),SearchObjectInRange(20)}))
	if #presentUndead > 7 then 
		return 
	end
	local undead = MobList[index]
	local amount = index+2
	this:PlayObjectSound("event:/magic/air/magic_air_lightning_impact")         
	for i=0,amount do
		local spawnLocation = SpawnLocations[math.random(1,#SpawnLocations)]
		CreateObj(undead[math.random(1,#undead)],spawnLocation,"undeadCreated")
		PlayEffectAtLoc("CloakEffect",spawnLocation)
	end
end

function ResetMonoliths()
	local monoliths = FindObjects(SearchModule("forest_monolith"))
	for i,j in pairs(monoliths) do
		ResetMonolith(j)
	end
	this:DelObjVar("CurrentActive")
end

function ResetMonolith(monolith)
	monolith:SetColor("0xFF272727")
    monolith:StopEffect("YellowPortalEffect")
	monolith:DelObjVar("Active")
end

RegisterEventHandler(EventType.CreatedObject,"undeadCreated", 
	function (success,objRef)
		Decay(objRef, 30)
	end)

RegisterEventHandler(EventType.EnterView,"questView",function(user)
	if (user:IsPlayer()) then
		user:SendMessage("StartQuest","InvestigateMonolithQuest")--send these messages in case the user is doing this again
    end
end)