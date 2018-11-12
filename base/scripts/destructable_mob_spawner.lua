require 'destroyable_object'

function SetDamageTooltip(curHealth)
	curHealth = math.max(0,curHealth)
    SetTooltipEntry(this,"destructable_mob_spawner","Health: "..curHealth.."/"..this:GetObjVar("BaseHealth"))
	local newScale =  math.max(126,128 * (curHealth/this:GetObjVar("BaseHealth")) + 126)
	this:SetColor( "0xFF"..string.upper(string.format("%02x%02x%02x",newScale,newScale,newScale)))
end

RegisterEventHandler(EventType.Timer,"SpawnTimer",function()
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(this:GetObjVar("SpawnTime")),"SpawnTimer")
		local nearbyMobs = FindObjects(SearchPlayerInRange(this:GetObjVar("SpawnRange")))
		mActive = false
		if (#nearbyMobs > 0) then
			for i,j in pairs(nearbyMobs) do
				if (this:HasLineOfSightToObj(j,ServerSettings.Combat.LOSEyeLevel)) then
					mActive = true
					--DebugMessage("Firing anyway")
				end
			end
		end
		local mobList = this:GetObjVar("MobList") or {}
		local spawns = this:GetObjVar("Spawns")
		local selectedSpawn = spawns[math.random(1,#spawns)]
		if (mActive and not mDead and not this:HasTimer("RespawnTimer") and this:GetObjVar("MaxSpawns") >= #mobList ) then	
			--for i,j in pairs(spawns) do
				--{"template",Loc()},
			if (type(j) == "string") then j = {j} end	
			CreateObj(selectedSpawn,this:GetLoc(),"mob_spawned")
			--end
		end
	end)

RegisterEventHandler(EventType.LeaveView,"SpawnerView",
	function(mob)
		--DebugMessage("Mob leaved spawn view")
		if (mob:IsPlayer()) then
			--DebugMessage("Mob is player")
			local nearbyMobs = FindObjects(SearchPlayerInRange(this:GetObjVar("SpawnRange")))
			if (#nearbyMobs <= 0) then
				--DebugMessage("Deactivating")
				mActive = false
			end
		end
	end)

RegisterEventHandler(EventType.EnterView,"SpawnerView",
	function(mob)
		--DebugMessage("SpawnerView")
		if (mob:IsValid() and mob:IsPlayer()) then
			mActive = true
			--DebugMessage("Active from SpawnerView")
		end
	end)

--add the mobs to a list of spawns
RegisterEventHandler(EventType.CreatedObject,"mob_spawned",
	function(success,objRef)
		local nearbyMobs = FindObjects(SearchPlayerInRange(this:GetObjVar("SpawnRange")))
		if (#nearbyMobs == 0) then
			return
		end
		local chosenPlayer = nearbyMobs[math.random(1,#nearbyMobs)]
		objRef:SendMessage("AttackEnemy",chosenPlayer)
		--DebugMessage("Mob spawned")
		AddToListObjVar(this, "MobList", objRef)
		 Decay(objRef, this:GetObjVar("SpawnDecay"))
	end)

OverrideEventHandler("destroyable_object",EventType.Timer,"RespawnTimer",function()
		--todo Set the visual state here
		--DFB TODO: REMOVE THIS
		this:SetColor("0xFFFFFFFF")
 		--this:SetVisualState("Healthy")

		--DebugMessage("Respawned")
		this:SetObjVar("CurrentHealth",this:GetObjVar("BaseHealth"))
		SetDamageTooltip(this:GetObjVar("BaseHealth"))
		mDead = false
	end)

if (initializer ~= nil) then
	--DebugMessage("initializer")
	this:SetObjVar("Spawns",initializer.Spawns)
	this:SetObjVar("MaxSpawns",initializer.Max or 10)
	this:SetObjVar("SpawnTime", initializer.SpawnTime or 10)
	this:SetObjVar("SpawnRange", initializer.SpawnRange or 10)
	this:SetObjVar("SpawnDecay",initializer.SpawnDecay or 30)
	--this:SetObjVar("RespawnTime",initializer.RespawnTime or 60)
 	--this:SetVisualState("Healthy")
	--this:SetObjVar("CurrentHealth",this:GetObjVar("BaseHealth"))
	--SetDamageTooltip(this:GetObjVar("BaseHealth"))
	mDead = false
	mActive = false
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(initializer.SpawnTime),"SpawnTimer")
	AddView("SpawnerView",SearchMobileInRange(initializer.SpawnRange or 12))
end