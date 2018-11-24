--objvars
--SpikeActivationTime = 4
--SpikeDelayTime = 10
this:SetObjVar("IsTrap",true)
DAMAGE_AMOUNT = this:GetObjVar("DamageAmount") or 50
RegisterEventHandler(EventType.Timer,"SpikeTic",function(tickNum)
	--DebugMessage(tickNum.." is tick counter")
	if (not this:HasObjVar("Disabled")) then
		local SpikeActivationTime = this:GetObjVar("SpikeActivationTime")
		if (tickNum > SpikeActivationTime) then
			local bounds = GetTemplateObjectBounds(this:GetCreationTemplateId())[1]:Add(this:GetLoc()):Flatten()
			--DebugMessage(DumpTable(bounds))
			--DebugMessage(tostring(bounds))
			local objects = FindObjects(SearchMulti({SearchRect(bounds),SearchMobile()}))
			if (not this:GetSharedObjectProperty("IsTriggered")) then
				this:SetSharedObjectProperty("IsTriggered",true)
				this:PlayObjectSound("event:/environment/misc/spike_trap/spike_trap_out",false)
				--DebugMessage("On")
			end			
			for i,obj in pairs(objects) do
				if (not obj:HasObjVar("ImmuneToTraps") and not IsDead(obj)) then
					--DFB HACK: Make mobs only recieve 5 damage from traps
					if not obj:IsPlayer() then
						obj:SendMessage("ProcessTrueDamage", this, 10)
					else
						obj:SendMessage("ProcessTrueDamage", this, 50)
					end
				end
			end
		else
			if (this:GetSharedObjectProperty("IsTriggered")) then
				this:SetSharedObjectProperty("IsTriggered",false)
				this:PlayObjectSound("event:/environment/misc/spike_trap/spike_trap_in",false)
				--DebugMessage("Off")
			end
		end
	end
	if (tickNum > this:GetObjVar("SpikeDelayTime")) then
		tickNum = 0
	end
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.25),"SpikeTic",tickNum + 0.25)
end)

if (this:GetObjVar("InitialTimerOffset") ~= 0) then
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(this:GetObjVar("InitialTimerOffset")),"SpikeTic",0)
else
	this:FireTimer("SpikeTic",0)
end

RegisterEventHandler(EventType.Message,"DisableTrap",function (time,user)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(time),"DisableTrapReset")
	this:SetObjVar("Disabled",true)
	this:SetSharedObjectProperty("IsTriggered",false)
end)

RegisterEventHandler(EventType.Timer,"DisableTrapReset",function()
	this:DelObjVar("Disabled")
end)
