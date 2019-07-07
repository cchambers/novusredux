mCurStage = 1
mStageKills = 0
mPermaments = {}

function BroadcastSpawnerMessage(messageName,...)
	-- send to self incase controller is also a spawner
	this:SendMessage(messageName,...)

	local awakenSpawners = FindObjects(SearchObjVar("AwakeningId",this:GetObjVar("AwakeningId"),50))
	for i,spawnerObj in pairs(awakenSpawners) do 
		DebugMessageB(this,"AwakeningController: Broadcasting to "..tostring(spawnerObj:GetName()))
		spawnerObj:SendMessage(messageName,...)
	end
end

function BroadcastSystemMessage(message)
	if(message) then		
		local awakenPlayers = FindObjects(SearchPlayerInRange(50))
		for i,playerObj in pairs(awakenPlayers) do 		
			playerObj:SystemMessage(message,"event")
		end
	end
end

function RefreshPermanents()
	for stageIndex,permObjs in pairs(mPermaments) do
		for i,permObj in pairs(permObjs) do
			if(stageIndex <= mCurStage) then
				permObj:SetVisualState("Default")
			else
				permObj:SetVisualState("Hidden")
			end
		end
	end
end

function OnLoad()

	if (not(this:HasObjVar("AwakeningLevel"))) then
		this:SetObjVar("AwakeningLevel", 1)
	end

	if (not(this:HasObjVar("AwakeningKills"))) then
		this:SetObjVar("AwakeningKills", 0)
	end

	mCurStage = this:GetObjVar("AwakeningLevel")
	mStageKills = this:GetObjVar("AwakeningKills")

	mPermaments = {}
	local stageInfos = this:GetObjVar("StageInfo") or {}
	for i,stageInfo in pairs(stageInfos) do
		if(stageInfo.PermanentObjectTag) then
			local permObjs = FindPermanentObjects(PermanentObjSearchHasObjectTag(stageInfo.PermanentObjectTag))
			if(#permObjs > 0) then
				DebugMessageB(this,"AwakeningController: Found permanents Stage: "..tostring(i)..", Count: "..tostring(#permObjs))
				mPermaments[i] = permObjs
			end
		end
	end
	CallFunctionDelayed(TimeSpan.FromSeconds(1),function() StageBegin(mCurStage) end)
end

function StageBegin(newStage)
	DebugMessageB(this,"AwakeningController: StageBegin "..tostring(newStage))

	mCurStage = newStage
	this:SetObjVar("AwakeningLevel", mCurStage)
	mStageKills = 0
	this:SetObjVar("AwakeningKills",mStageKills)
	
	local stageInfo = this:GetObjVar("StageInfo")
	local newStageInfo = stageInfo[mCurStage]

	BroadcastSystemMessage(newStageInfo.SystemMessage)

	RefreshPermanents()

	BroadcastSpawnerMessage("AwakeningStageBegin",mCurStage,this)
	
	if(newStageInfo.MaxDuration ~= nil and newStageInfo.MaxDuration.TotalSeconds > 0) then 
		DebugMessageB(this,"AwakeningController: Scheduling duration timer "..tostring(newStageInfo.MaxDuration.TotalMinutes))
		this:ScheduleTimerDelay(newStageInfo.MaxDuration,"DurationTimer")
	else
		this:RemoveTimer("DurationTimer")
	end
end

RegisterEventHandler(EventType.Message,"AwakeningKill",
	function (deadMob)		
		mStageKills = mStageKills + 1
		this:SetObjVar("AwakeningKills",mStageKills)
		DebugMessageB(this,"AwakeningController: AwakeningKill "..tostring(deadMob and deadMob:GetName() or "DESPAWN").." StageKills: "..tostring(mStageKills))
		local stageInfo = this:GetObjVar("StageInfo")
		local curStageInfo = stageInfo[mCurStage]
		if(mStageKills >= (curStageInfo.KillCount or 1)) then			
			local newStageInfo = stageInfo[mCurStage+1]

			if(newStageInfo ~= nil) then
				StageBegin(mCurStage+1)
			else				
				local sleepDuration = this:GetObjVar("SleepDuration") or 0
				DebugMessageB(this,"AwakeningController: Awakening Complete Sleeping "..tostring(sleepDuration or 0))
				if(sleepDuration > 0) then
					BroadcastSpawnerMessage("SetActive",false)
					this:ScheduleTimerDelay(TimeSpan.FromMinutes(sleepDuration),"Wake")
				else
					StageBegin(1)
				end
			end
		end
	end)

RegisterEventHandler(EventType.Timer,"Wake",
	function ( ... )
		BroadcastSpawnerMessage("SetActive",true)
		StageBegin(1)
	end)

RegisterEventHandler(EventType.Timer,"DurationTimer",
	function ( ... )
		if(mCurStage > 1) then 
			DebugMessageB(this,"AwakeningController: Duration timer previous stage")
			StageBegin(mCurStage-1)
		else
			DebugMessageB(this,"AwakeningController: Duration timer reset stage")
			mStageKills = 0
			local stageInfo = this:GetObjVar("StageInfo")
			local curStageInfo = stageInfo[mCurStage]
			this:ScheduleTimerDelay(curStageInfo.MaxDuration,"DurationTimer")
		end
	end)

RegisterSingleEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function ( ... )
		if(initializer.StageInfo) then
			this:SetObjVar("StageInfo",initializer.StageInfo)
		end
		OnLoad()
	end)

RegisterSingleEventHandler(EventType.LoadedFromBackup,"",
	function ( ... )
		OnLoad()
	end)

-- God messages
RegisterEventHandler(EventType.Message,"ChangeStage",
	function (stageIndex,destroyMobs)
		stageIndex = tonumber(stageIndex) or 1
		local awakeningMobs = FindObjects(SearchHasObjVar("AwakeningStage"))
		for i,awakeningMob in pairs(awakeningMobs) do
			if(destroyMobs ~= nil) then 
				awakeningMob:Destroy()
			else
				awakeningMob:SetObjVar("DecayTime",60)
				if not(awakeningMob:HasModule("spawn_decay")) then
					awakeningMob:AddModule("spawn_decay")
				else
					awakeningMob:SendMessage("RefreshSpawnDecay")
				end
			end
		end
		StageBegin(stageIndex)
	end)