--objvars
--SpikeActivationTime = 4
--SpikeDelayTime = 10

this:SetObjVar("IsTrap",true)

DAMAGE_AMOUNT = this:GetObjVar("DamageAmount") or 50
RegisterEventHandler(EventType.Timer,"SpikeTic",function(tickNum)
	--DebugMessage(2)
		local SpikeActivationTime = this:GetObjVar("SpikeActivationTime")
		if (tickNum > SpikeActivationTime) then
			local bounds = GetTemplateObjectBounds(this:GetCreationTemplateId())[1]:Add(this:GetLoc()):Flatten()
			--DebugMessage(tostring(bounds))
			local objects = FindObjects(SearchMulti({SearchRect(bounds),SearchMobile()}))
			if (not this:GetSharedObjectProperty("IsTriggered")) then
				this:SetSharedObjectProperty("IsTriggered",true)
				this:PlayObjectSound("SpikeTrapOut",false)
				--DebugMessage("On")
			end		
			for i,obj in pairs(objects) do
				if (not obj:HasObjVar("ImmuneToTraps") and not IsDead(obj)) then
					obj:SendMessage("ProcessTrueDamage", this, 50)
				end
			end
			--for i,obj in pairs(objects) do
			--	obj:SendMessage("DamageInflicted", this , DAMAGE_AMOUNT, false )
			--end
		end
		if (not (tickNum > this:GetObjVar("SpikeDelayTime"))) then
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.25),"SpikeTic",tickNum + 0.25)
		else
			this:SetSharedObjectProperty("IsTriggered",false)
			this:PlayObjectSound("SpikeTrapIn",false)
			--DebugMessage("Off")
		end
	end)

RegisterEventHandler(EventType.Message,"Activate",function ( ... )
	if (not this:HasTimer("SpikeTic") and not this:HasObjVar("Disabled")) then
		this:FireTimer("SpikeTic",this:GetObjVar("SpikeActivationTime")+0.25)
	end
end)

--In case someone's being an asshole with the triggered traps you can disable them
RegisterEventHandler(EventType.Message,"DisableTrap",function (time,user)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(time),"DisableTrapReset")
	this:SetObjVar("Disabled",true)
	this:SetSharedObjectProperty("IsTriggered",false)
end)

RegisterEventHandler(EventType.Timer,"DisableTrapReset",function()
	this:DelObjVar("Disabled")
end)