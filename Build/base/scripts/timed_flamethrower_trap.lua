--objvars

this:SetObjVar("IsTrap",true)

DAMAGE_AMOUNT = this:GetObjVar("DamageAmount") or 10
RegisterEventHandler(EventType.Timer,"FlameTic",function(tickNum)
	--this:SetSharedObjectProperty("IsTriggered",false)
	--DebugMessage(tickNum.." is tick counter")
		if (not this:HasObjVar("Disabled")) then
			local FlameActivationTime = this:GetObjVar("FlameActivationTime")
			if (tickNum > FlameActivationTime) then
				local bounds = Box(-3,0,-1,3,1,2):Rotate(this:GetFacing()):Add(this:GetLoc()):Flatten()
				--CreateObj("spike",Loc(bounds.TopLeft),"blah")
				--CreateObj("spike",Loc(bounds.TopRight),"blah")
				--CreateObj("spike",Loc(bounds.BottomLeft),"blah")
				--CreateObj("spike",Loc(bounds.BottomRight),"blah")
				--DebugMessage(tostring(bounds))
				--DebugMessage(DumpTable(bounds))
				--DebugMessage(tostring(bounds))
				local objects = FindObjects(SearchMulti({SearchRect(bounds),SearchMobileInRange(5,true)}))
				if (not this:GetSharedObjectProperty("IsTriggered")) then
					this:SetSharedObjectProperty("IsTriggered",true)
					this:PlayObjectSound("event:/environment/fire/fire_trap",false)
					--DebugMessage("On")
				end			
				for i,obj in pairs(objects) do
					if (not obj:HasObjVar("ImmuneToTraps") and not IsDead(obj)) then
						if not obj:IsPlayer() then
							obj:SendMessage("ProcessTrueDamage", this, 10)
						else
							obj:SendMessage("ProcessTrueDamage", this, DAMAGE_AMOUNT)
						end
					end
				end
			else
				if (this:GetSharedObjectProperty("IsTriggered")) then
					this:SetSharedObjectProperty("IsTriggered",false)
					this:StopObjectSound("event:/environment/fire/fire_trap",false,0.2)
					--DebugMessage("Off")
				end
			end
		end
		if (tickNum > this:GetObjVar("FlameDelayTime")) then
			tickNum = 0
		end
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.5),"FlameTic",tickNum + 0.5)
	end)

if (this:GetObjVar("InitialTimerOffset") ~= 0) then
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(this:GetObjVar("InitialTimerOffset")),"FlameTic",0)
else
	this:FireTimer("FlameTic",0)
end

RegisterEventHandler(EventType.Message,"DisableTrap",function (time,user)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(time),"DisableTrapReset")
	this:SetObjVar("Disabled",true)
	this:SetSharedObjectProperty("IsTriggered",false)
	this:StopObjectSound("event:/environment/fire/fire_trap",false,0.2)
end)

RegisterEventHandler(EventType.Timer,"DisableTrapReset",function()
	this:DelObjVar("Disabled")
end)

--RegisterEventHandler(EventType.CreatedObject,"blah",
--function (success,objRef)
--	objRef:SetObjVar("DecayTime",2)
--	objRef:AddModule("decay")
--end)