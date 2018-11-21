
AddView("NearbyPlayer", SearchPlayerInRange(5), 1.0)

RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if(usedType ~= "Use" and usedType ~= "Examine") then return end
		
		user:SystemMessage("[$1812]")
    	user:SendMessage("AdvanceQuest","InvestigateMonolithQuest","ActivateMonolith","InvestigateMonolith")
	end)

RegisterEventHandler(EventType.Message,"DamageInflicted",
	function(attacker,damageAmt)
		-- DAB HACK: People are exploiting this to kill mobs turned off for now
		do return end
    	--this:SetColor("0xFF00FFFF")
    	local controller = FindObject(
    	SearchModule("monolith_controller")
    	)
    	if (controller ~= nil) then
    		--DebugMessage("sending Message")
    		controller:SendMessage("MonolithActivated",this:GetObjVar("MonolithNumber"),this)
    	end
	end)

RegisterEventHandler(EventType.Message,"MonolithActivate",
	function()
	    this:SetObjVar("Active",true)
    	this:PlayEffect("YellowPortalEffect",5.0)
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"ActivatedTimer")
		this:PlayObjectSound("Cloak", true)
	end)

RegisterEventHandler(EventType.Timer,"ActivatedTimer",
	function()
		if (not this:HasObjVar("Active")) then return end
		this:PlayEffect("YellowPortalEffect",5.0)
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"ActivatedTimer")
	end)

RegisterEventHandler(EventType.EnterView, "NearbyPlayer",
	function(playerObj)
		--trigger the effect if it's nearby
		playerObj:SetObjVar("campfireEffect",true)
		playerObj:SendMessage("BeginRestState")
	end)

RegisterEventHandler(EventType.LeaveView, "NearbyPlayer", 
	function(playerObj)
		--stop triggering the effect player has left
		playerObj:DelObjVar("campfireEffect")
	end)

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
    function()
        AddUseCase(this,"Examine",true)        
        SetTooltipEntry(this,"examine","Perhaps you should inspect this object closer.\n")		
    end)