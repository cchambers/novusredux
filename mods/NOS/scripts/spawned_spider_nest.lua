require 'NOS:incl_regions'

local mTarget = nil

RegisterEventHandler(EventType.EnterView,"nest",
	function (target)
		local hisTeamType = target:GetObjVar("MobileTeamType")
		local myTeamType = target:GetObjVar("MobileTeamType")

		if((not this:GetSharedObjectProperty("IsDestroyed")) and target ~= this:GetObjVar("controller") and (myTeamType == nil or (hisTeamType ~= myTeamType))) then
			mTarget = target
			this:SetSharedObjectProperty("IsDestroyed",true)
			this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(500),"spawn")			
			this:SendMessage("UpdateDecay",10)
		end
	end)

RegisterEventHandler(EventType.Timer,"spawn",
	function ( ... )
		for i=1,math.random(1,3) do			
			CreateObj("graveyard_spider",this:GetLoc(),"onspawn")
		end
	end)

RegisterEventHandler(EventType.CreatedObject,"onspawn",
    function(success,objRef)
    	Decay(objRef, 20)
        objRef:SendMessage("ChangeAge",math.random(5,6))   

        local myTeamType = this:GetObjVar("MobileTeamType")
        if(myTeamType ~= nil) then
        	objRef:SetObjVar("MobileTeamType",myTeamType)
        end
        local myController = this:GetObjVar("controller")
        if(myController ~= nil) then
	        objRef:SetObjVar("controller",myController)
	    end

	    if(mTarget ~= nil) then
        	objRef:SendMessage("AttackEnemy",mTarget)       

        	local myLoc = this:GetLoc()
        	local targLoc = mTarget:GetLoc()
        	local moveLoc = myLoc:Project(myLoc:YAngleTo(targLoc) + math.random(1,60) - 30, math.random() * 1.5 + 1.5)
        	objRef:PathTo(moveLoc,3.0)
        else
	        local moveLoc = GetNearbyPassableLoc(this,360,0.5,2)
    	    objRef:PathTo(moveLoc,3.0)
    	end
    end)

CallFunctionDelayed(TimeSpan.FromSeconds(1),
	function ( ... )
		AddView("nest",SearchMobileInRange(5))
	end)