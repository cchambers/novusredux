TIME_TO_RESPAWN = 60*10

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
    	if(usedType ~= "Attack" and usedType ~= "Use") then return end

    	user:PlayAnimation("attack")
    	FaceObject(user,this)
    	this:SetSharedObjectProperty("IsDestroyed",true)
    	this:ScheduleTimerDelay(TimeSpan.FromSeconds(TIME_TO_RESPAWN),"respawn")
    end)

RegisterEventHandler(EventType.Message,"DamageInflicted",
	function(attacker,damageAmt)
	    if(damageAmt > 0 and this:GetSharedObjectProperty("IsDestroyed") == false) then
	    	user:PlayAnimation("attack")
	    	FaceObject(user,this)
	    	this:SetSharedObjectProperty("IsDestroyed",true)
	    	this:ScheduleTimerDelay(TimeSpan.FromSeconds(TIME_TO_RESPAWN),"respawn")
	    end
	end)

RegisterEventHandler(EventType.Timer,"respawn", 
	function()
		this:SetSharedObjectProperty("IsDestroyed",false)
	end)

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(), 
	function()
		AddUseCase(this,"Attack",true)
	end)