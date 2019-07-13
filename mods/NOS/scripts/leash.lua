require 'NOS:incl_combatai'

DEFAULT_LEASHDISTANCE = 25

function IsActive()
    return not(IsDead(this) or this:ContainedBy() or IsAsleep(this))
end


RegisterSingleEventHandler(EventType.ModuleAttached, "leash", 
	function()
		this:SetObjVar("homeLoc",this:GetLoc())

		if( not this:HasObjVar("leashDistance") ) then
			this:SetObjVar("leashDistance",DEFAULT_LEASHDISTANCE)
		end

		this:ScheduleTimerDelay(TimeSpan.FromSeconds(2), "leashCheck")
	end)

RegisterEventHandler(EventType.Timer, "leashCheck", 
	function()
		if not(IsActive()) then
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(2), "leashCheck")
			return 
		end
		
		--DebugMessage("CheckLeash")
		-- only leash if not in combat
		if( not IsInCombat(this) ) then
			local leashDist = this:GetObjVar("leashDistance")
			local homeLoc = this:GetObjVar("homeLoc")
			local myLoc = this:GetLoc()

			if(homeLoc:Distance(myLoc) > leashDist) then
				--DebugMessage("Npc leashing")
				this:PathTo(homeLoc)
				this:SetObjVar("isLeashing",true)
				-- dont set the timer
				return
			end
		end

		this:ScheduleTimerDelay(TimeSpan.FromSeconds(2), "leashCheck")
	end)

RegisterEventHandler(EventType.Arrived, nil, 
	function(arriveSuccess)
		if( arriveSuccess ) then
			this:SetObjVar("isLeashing",false)		
		end

		this:ScheduleTimerDelay(TimeSpan.FromSeconds(2), "leashCheck")
	end)
