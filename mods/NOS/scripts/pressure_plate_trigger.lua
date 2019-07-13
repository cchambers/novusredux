require 'NOS:pressure_plate'

OverrideEventHandler("NOS:pressure_plate",EventType.EnterView, "Activate", 
    function (user)
        if (IsDead(user) or user:HasModule("npe_magical_guide")) then
            return
        end

        if ( this:HasTimer("PressurePlateCoolingDown") ) then
            user:SystemMessage("You step on the plate but nothing seems to happen, perhaps if you try again later.")
            return
        end
    	if ( not this:HasObjVar("Disabled") ) then
        	this:SendMessage("UseObject",user,"Trigger")
   	     	this:SetCloak(false)
		    local traps = FindObjects(SearchObjVar("TrapKey",this:GetObjVar("TrapKey")))
		    for i,trap in pairs(traps) do
		        trap:SendMessage("Activate")
		    end
            local cdSeconds = this:GetObjVar("CooldownSeconds")
            if ( cdSeconds ) then
                this:ScheduleTimerDelay(TimeSpan.FromSeconds(cdSeconds), "PressurePlateCoolingDown")
            end
    	end
    end)