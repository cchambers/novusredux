require 'pressure_plate'

--this:SetCloak(true)
this:SetObjVar("IsTrap",true)
this:SetObjVar("TrapDelay",1)
this:SetObjVar("TrapSoundDelay",0.1)

OverrideEventHandler("pressure_plate",EventType.EnterView, "Activate", 
    function (user)
    	--DebugMessage(0)
    	if (not this:HasObjVar("Disabled")) then
	        if (IsDead(user) or user:HasModule("npe_magical_guide")) then
	          return
	        end
        	this:SendMessage("UseObject",user,"Trigger")
        	SetPlateActivated(true)
   	     	this:SetCloak(false)
   	     	--DebugMessage(1)
    	end
    end)

RegisterEventHandler(EventType.Message,"DisableTrap",function (time)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(time),"DisableTrapReset")
  this:SetObjVar("Disabled",true)
  SetPlateActivated(true)
end)

RegisterEventHandler(EventType.Timer,"DisableTrapReset",function()
	this:DelObjVar("Disabled")
  SetPlateActivated(false)
end)

OverrideEventHandler("pressure_plate", EventType.LeaveView, "Activate", 
    function(user)
      local mobileObjects = GetViewObjects("Activate")
        if(#mobileObjects == 0 and not this:HasObjVar("Disabled")) then
            SetPlateActivated(false)
        end
    end)