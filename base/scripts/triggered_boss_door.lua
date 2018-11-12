BOSS_TIME = 60*20

function OpenDoor()
	if (not this:GetSharedObjectProperty("IsOpen")) then
	    this:SetSharedObjectProperty("IsOpen", true)
	    this:ClearCollisionBounds()
	    --DebugMessage("Opened door.")
	    this:ScheduleTimerDelay(TimeSpan.FromMinutes(20),"DoNotResetTimer")
	    local notifyModule = this:GetObjVar("NotifyModule")
	    if(notifyModule) then
	    	local notifyObjs = FindObjects(SearchModule(notifyModule,30))
	    	for i,obj in pairs(notifyObjs) do
          		obj:SendMessage("OnDoorOpen")
        	end
        end
	end
end

function CloseDoor()
	if (this:HasTimer("DoNotResetTimer")) then return end
	local boss = FindObject(SearchTemplate(this:GetObjVar("BossTemplate"),30))
	local region = this:GetObjVar("BossRegion")
	local regionPlayers = FindPlayersInGameRegion(region)
	local noPlayers = true
	local allPlayersDead = true
	for i,j in pairs(regionPlayers) do
		noPlayers = false
		if (not IsDead(j)) then
			allPlayersDead = false
		end
	end
	if (boss ~= nil and not (allPlayersDead or noPlayers)) then
		--DebugMessage("ResetTimer 3")
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(BOSS_TIME),"ResetTimer")
		return
	end
	if (this:GetSharedObjectProperty("IsOpen")) then
	    this:SetSharedObjectProperty("IsOpen", false)
	    this:SetCollisionBoundsFromTemplate(this:GetCreationTemplateId())
	    --DebugMessage("Closing door")

	    -- deactivate any traps with a matching trapkey
	    local notifyModule = this:GetObjVar("NotifyModule")
	    if(notifyModule) then
	    	local notifyObjs = FindObjects(SearchModule(notifyModule,30))
	    	for i,obj in pairs(notifyObjs) do
	      		obj:SendMessage("OnDoorClose")
	    	end
	    end
	end
end

RegisterEventHandler(EventType.Message,"Activate",OpenDoor)
RegisterEventHandler(EventType.Message,"CloseDoor",CloseDoor)
RegisterEventHandler(EventType.Timer,"CloseDoor",CloseDoor)
RegisterEventHandler(EventType.Timer,"ResetTimer",CloseDoor)


this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"CheckBoss")

RegisterEventHandler(EventType.Timer,"CheckBoss",function ()
	local region = this:GetObjVar("BossRegion")
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"CheckBoss")
	local boss = FindObject(SearchTemplate(this:GetObjVar("BossTemplate")))
	if (region ~= nil) then
		local regionPlayers = FindPlayersInGameRegion(region)
		local noPlayers = true
		local allPlayersDead = true
		for i,j in pairs(regionPlayers) do
			noPlayers = false
			if (not IsDead(j)) then
				allPlayersDead = false
			end
		end
		if (not this:HasTimer("DoNotResetTimer")) then
			--DebugMessage("Whaat")
			if (noPlayers)  then
				this:SetSharedObjectProperty("PlayClosedIdle",true)
				if (boss ~= nil) then
					boss:Destroy()
				end
				CloseDoor()
			else
				if (allPlayersDead) then
					this:SetSharedObjectProperty("PlayClosedIdle",true)
					if (boss ~= nil) then
						boss:SendMessage("PathBehindDoor")
					end
					--DebugMessage("ResetTimer 1")
					this:ScheduleTimerDelay(TimeSpan.FromSeconds(BOSS_TIME),"ResetTimer")					
				end
			end
			if (boss ~= nil and not IsDead(boss) ) then
				this:SetSharedObjectProperty("PlayClosedIdle",false)
				return
			elseif not this:HasTimer("ResetTimer") then
				this:SetSharedObjectProperty("PlayClosedIdle",true)
				--DebugMessage("ResetTimer 2")
				this:ScheduleTimerDelay(TimeSpan.FromSeconds(BOSS_TIME),"ResetTimer")
			end
		end
	end
end)