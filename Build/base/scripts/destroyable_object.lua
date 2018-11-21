
function SetDamageTooltip(curHealth)
	curHealth = math.max(0,curHealth)
    SetTooltipEntry(this,GetCurrentModule(),"Health: "..curHealth.."/"..this:GetObjVar("BaseHealth"))	
end

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function ( ... )
		AddUseCase(this,"Attack",true)
	end)

NEARBY_MOB_RANGE = 15

RegisterEventHandler(EventType.Message, "DamageInflicted", 
	function (damager,damageAmt)    
		if (this:HasObjVar("ControllerTemplate")) then
			local controller = FindObject(SearchTemplate(this:GetObjVar("ControllerTemplate"),50))
			if (controller == nil) then 
				damager:SystemMessage("You can't damage this now.")
				return 
			end
		end
		local curHealth = this:GetObjVar("CurrentHealth") 
		curHealth = math.max(0,curHealth - damageAmt )
		SetDamageTooltip(curHealth)
		mActive = true
		if (this:HasObjVar("Important") and this:HasObjVar("MobileTeamType")) then
			local nearbyMobs = FindObjects(SearchMulti({SearchRange(this:GetLoc(),NEARBY_MOB_RANGE),SearchObjVar("MobileTeamType",this:GetObjVar("MobileTeamType"))}))
			for i,j in pairs(nearbyMobs) do
				j:SendMessage("AddThreat",damager,10)
			end
		end
		if (curHealth <= 0) then
			--DFB TODO: REMOVE THIS
			--todo Set the visual state here
			--DebugMessage("Destroyed")
			mActive = false
 			--this:SetVisualState("Destroyed")
			mDead = true
			this:SetObjVar("Destroyed",true)
			if (this:HasSharedObjectProperty("IsDestroyed")) then
				this:SetSharedObjectProperty("IsDestroyed",true)
			end
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(this:GetObjVar("RespawnTime")),"RespawnTimer")
		end
		this:SetObjVar("CurrentHealth",curHealth)
	end)

RegisterEventHandler(EventType.Timer,"RespawnTimer",function()
		--todo Set the visual state here
		--DFB TODO: REMOVE THIS
		this:SetColor("0xFFFFFFFF")
 		--this:SetVisualState("Healthy")

		--DebugMessage("Respawned")
		this:SetObjVar("CurrentHealth",this:GetObjVar("BaseHealth"))
		this:SetObjVar("Destroyed",false)
		SetDamageTooltip(this:GetObjVar("BaseHealth"))
		this:SetSharedObjectProperty("IsDestroyed",false)
		mDead = false
	end)

if (initializer ~= nil) then
	--DebugMessage("initializer")
	this:SetObjVar("RespawnTime",initializer.RespawnTime or 300)
 	--this:SetVisualState("Healthy")
	this:SetObjVar("CurrentHealth",this:GetObjVar("BaseHealth"))
	SetDamageTooltip(this:GetObjVar("BaseHealth"))
	mDead = false
	mActive = false
	--this:ScheduleTimerDelay(TimeSpan.FromSeconds(initializer.SpawnTime),"SpawnTimer")
end