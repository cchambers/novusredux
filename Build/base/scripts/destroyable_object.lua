NEARBY_MOB_RANGE = 15

maxHealth = this:GetObjVar("BaseHealth") or 100
this:SetStatMaxValue("Health", math.floor(maxHealth))
this:SetStatValue("Health", maxHealth)
this:SetStatVisibility("Health","Global")

function HandleDamage(damager,damageAmt)
	if (this:HasObjVar("ControllerTemplate")) then
		local controller = FindObject(SearchTemplate(this:GetObjVar("ControllerTemplate"),50))
		if (controller == nil) then 
			damager:SystemMessage("You can't damage this now.","info")
			return 
		end
	end

	local curHealth = this:GetStatValue("Health")
	curHealth = math.ceil(curHealth - damageAmt)
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
		--this:PlayEffect("FireballExplosionEffect")
		mActive = false
			--this:SetVisualState("Destroyed")

		curHealth = 0
		mDead = true
		RemoveUseCase(this,"Attack")
		damager:SendMessage("ClearTarget")
		this:SendMessage("ObjectDestroyed")

		if (this:HasSharedObjectProperty("IsDestroyed")) then
			this:SetSharedObjectProperty("IsDestroyed",true)
		end
		if (this:HasObjVar("RespawnTime")) then
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(this:GetObjVar("RespawnTime")),"RespawnTimer")
		end
	end
	this:SetStatValue("Health",curHealth)
end

if (initializer ~= nil) then
	--DebugMessage("initializer")
	this:SetObjVar("RespawnTime",initializer.RespawnTime)
 	--this:SetVisualState("Healthy")
 	if not (this:HasObjVar("BaseHealth")) then
 		this:SetObjVar("BaseHealth", 100)
 	end
	this:SetStatValue("Health", GetMaxHealth(this))
	mDead = false
	mActive = false
	--this:ScheduleTimerDelay(TimeSpan.FromSeconds(initializer.SpawnTime),"SpawnTimer")
end

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function ( ... )
		this:SetObjVar("Attackable", true)
		AddUseCase(this,"Attack",true)
	end)


RegisterEventHandler(EventType.Message, "DamageInflicted", HandleDamage)

RegisterEventHandler(EventType.Timer,"RespawnTimer",function()
		--todo Set the visual state here
		--DFB TODO: REMOVE THIS
		this:SetColor("0xFFFFFFFF")
 		--this:SetVisualState("Healthy")

		--DebugMessage("Respawned")
		this:SetStatValue("Health", GetMaxHealth(this))
		this:SetSharedObjectProperty("IsDestroyed",false)
		mDead = false
		AddUseCase(this,"Attack",true)
	end)



RegisterEventHandler(EventType.Message, "ObjectDestroyed", 
	function()

	end)

