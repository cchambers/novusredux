--TRAP_SPEED = 0.5
--TRAP_RESPRING_SPEED = 0.2
--mCount = 0
--this:SetObjVar("IsTrap",true)
--[[
RegisterEventHandler(EventType.Message,"TriggerWall",function()
	--in case the trap gets stuck somehow
	this:SetWorldPosition(this:GetObjVar("StartPos"))
	this:FireTimer("MoveWall",0)
	mCount = 0
end)

RegisterEventHandler(EventType.Timer,"MoveWall",function(time)
	--when triggered it starts at zero
	--Retract if the timer is past a certain amount
	--once the amount has reached it's maximum, then reset the trap
	if (not this:HasObjVar("Disabled")) then
		local maxTrapDistance = this:GetObjVar("MaxDistance")
		local trapTriggerTime = this:GetObjVar("TrapTravelTime")
		local trapReturnTime = this:GetObjVar("TrapReturnTime")
		--local triggerDelta = maxTrapDistance/trapTriggerTime
		--local returnDelta = maxTrapDistance/trapReturnTime
		local nextPosition = this:GetLoc()

		--if the trap is past triggered
		if (time > trapTriggerTime) then
			mCount = mCount + 1
			--if it's fully retracted
			if time > trapReturnTime + trapTriggerTime then
				this:SetWorldPosition(this:GetObjVar("StartPos"))
				mCount = 0
				return
			else
				this:SetSharedObjectProperty("IsTriggered",false)
				--else it's returning
				--take the amount of time that you have after it has extended (time - trapTriggerTime)
				--as a fraction of the total amount of time till it has fully returned
				--invert it, and multiply that by the total distance of the trap
				--after this black magic here you should have the distance during retraction
				nextPosition = this:GetObjVar("StartPos"):Project(this:GetObjVar("StartFacing"),maxTrapDistance*((1-((time-trapTriggerTime)/trapReturnTime))))
			end
		--otherwise the trap is triggering because the timer is being fired
		elseif (time <= trapTriggerTime) then
			this:SetSharedObjectProperty("IsTriggered",true)
			--take the distance, and find a fraction of it based on time
			--then project out and set it there
			nextPosition = this:GetObjVar("StartPos"):Project(this:GetObjVar("StartFacing"),maxTrapDistance*(time/trapTriggerTime))
			if (mCount % 5) == 0 then
				--DebugMessage("Firing")
				local mobiles = FindObjects(SearchMulti({
									SearchRange(this:GetLoc(),1.2),
									SearchMobile()}))
				for i,v in pairs(mobiles) do
				--v:NpcSpeech("Burning Burning burning")
					v:PushTo(nextPosition:Project(this:GetObjVar("StartFacing"),1.5),8,GetBodySize(v))
					if(not IsDead(v)) then
						--DebugMessage("Yes")
						if (not v:HasObjVar("ImmuneToTraps")) then
							v:SendMessage("ProcessTrueDamage", this, 50)
						end
					end
				end
			end
		end
		this:SetWorldPosition(nextPosition)
		--only do damage once a second cause searchers are expensive
		--math.floor doesn't work here for some wierd floating point reason
	else
		time = time - 0.05
	end
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.05),"MoveWall",(time + 0.05))
end)

RegisterEventHandler(EventType.EnterView,"RegionView",function(mob)
	if (mob:IsPlayer() and not this:HasTimer("MoveWall")) then
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"MoveWall",0)
		this:SetWorldPosition(this:GetObjVar("StartPos"))
		--DebugMessage("Entering RegionView")
		mCount = 0
	end
end)
-]]
RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),function ( ... )
	--DFB TODO: FIX CAUSE THESE DON'T WORK WHEN LAGGING. 
	this:Destroy()

	--this:SetObjVar("StartPos",this:GetLoc())
	--this:SetObjVar("StartFacing",this:GetFacing()+90)
	--this:SetSharedObjectProperty("IsTriggered",true)

	--DebugMessage("Firing")
	--DebugMessage(this:GetObjVar("RoomRegion").." is the region")
	--AddView("RegionView",SearchMulti({SearchMobile(),SearchRegion(this:GetObjVar("RoomRegion"),true)}))
end)
--[[
RegisterEventHandler(EventType.Message,"DisableTrap",function (time)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(time),"DisableTrapReset")
	this:SetObjVar("Disabled",true)
	this:SetSharedObjectProperty("IsTriggered",false)
end)

RegisterEventHandler(EventType.Timer,"DisableTrapReset",function()
	this:DelObjVar("Disabled")
end)
--]]