PlayerObj = nil

RegisterEventHandler(EventType.Message,"Init",function (target)
	PlayerObj = target
	this:FireTimer("DoUpdate")
end)

local playedEvents = {}

function WispEventCheck()
	local wispEvent = FindObject(SearchTemplate("demo_wisp_event",5))
	if(wispEvent and not(playedEvents[wispEvent])) then
		playedEvents[wispEvent] = true
		this:NpcSpeech(wispEvent:GetObjVar("Message"))
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"MessageExtended",wispEvent,1)
	end
end

RegisterEventHandler(EventType.Timer,"MessageExtended",
	function (wispEvent,index)
		local objVarName = "Message"..tostring(index)
		if(wispEvent:HasObjVar(objVarName)) then
			this:NpcSpeech(wispEvent:GetObjVar(objVarName))
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"MessageExtended",wispEvent,index+1)
		elseif(wispEvent:HasObjVar("Destroy")) then
			if(wispEvent:HasObjVar("RewardTemplate")) then
				CreateObj(wispEvent:GetObjVar("RewardTemplate"),this:GetLoc())
			end
			PlayEffectAtLoc("VoidTeleportToEffect",this:GetLoc())
			this:Destroy()
		end
	end)

local oldSpeed = 0

RegisterEventHandler(EventType.Timer,"DoUpdate",
	function ( ... )
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.5),"DoUpdate")

		if(PlayerObj ~= nil and PlayerObj:IsValid()) then
			if(PlayerObj:DistanceFrom(this) > 20) then
				local spawnLoc = GetNearbyPassableLoc(PlayerObj,360,2,4)
				this:SetWorldPosition(spawnLoc)
				this:PlayEffect("TeleportToEffect")
				this:PlayObjectSound("event:/magic/air/magic_air_teleport")
			else
				local speedMod = ServerSettings.Stats.RunSpeedModifier
				if(PlayerObj:GetEquippedObject("Mount")) then
					speedMod = ServerSettings.Stats.MountSpeedModifier * ServerSettings.Stats.RunSpeedModifier
				end

				if(speedMod ~= oldSpeed) then
					this:StopMoving()
					this:PathToTarget(PlayerObj,1.5,speedMod)
					oldSpeed = speedMod
				end
			end

			WispEventCheck()
		end
	end)