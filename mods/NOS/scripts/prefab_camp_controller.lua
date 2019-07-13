require 'NOS:incl_keyhelpers'

function ScheduleMobCheckTimer()
	--DebugMessage("---ScheduleMobCheckTimer")
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(10 + math.random()),"MobCheckTimer")
end

function HasMobs()
	local prefabObjects = this:GetObjVar("PrefabObjects")
	if(prefabObjects) then
		for i,prefabObject in pairs(prefabObjects) do
			if(prefabObject and prefabObject:IsValid() and prefabObject:IsMobile()) then
				--DebugMessage("---HasMobs true")
				return true
			end
		end
	end
	--DebugMessage("---HasMobs false")
end

function MobCheck()
	--DebugMessage("---MobCheck")
	if(HasMobs()) then
		ScheduleMobCheckTimer()
	else
		--DebugMessage("---No mobs fire decay")
		-- no mobs left in camp, trigger decay
		this:FireTimer("MobDecayTimer")
	end
end
RegisterEventHandler(EventType.Timer,"MobCheckTimer",function () MobCheck() end)

function GetMobsFromPrefab(prefabObjects)
	local mobs = {}
	if (prefabObjects ~= nil) then
        for i,prefabObj in pairs(prefabObjects) do
        	if (prefabObj:IsMobile()) then
        		mobs[#mobs+1] = prefabObj
        		--DebugMessage(prefabMobs[i]:GetName())
        	end
    	end
    	return mobs
    end
end

function GetContainerFromPrefab(prefabObjects)
	local chest = nil
	for i, prefabObj in pairs(prefabObjects) do
		if (prefabObj:HasModule("container") and prefabObj:HasObjVar("Reward")) then
			return prefabObj
		end
	end
end

function CreateLockAndKey(prefabMobs, prefabChest)
	if (#prefabMobs > 0 and prefabChest ~= nil) then
		local randomMob = prefabMobs[math.random(1, #prefabMobs)]
		--DebugMessage("Giving key to " .. randomMob:GetName() .. " in " .. this:ToString())
		local lockUniqueId = randomMob:GetName()..this:ToString()
		CreateKeyInBackpack(randomMob,randomMob:GetName() .. "'s key",lockUniqueId, true)
		prefabChest:SendMessage("Lock")
		prefabChest:SetObjVar("lockUniqueId", lockUniqueId)
	end
end

function CampSetup(noDecay)
	local prefabObjects = this:GetObjVar("PrefabObjects")
	if(prefabObjects) then
		for i,prefabObj in pairs(prefabObjects) do
			prefabObj:Destroy()
		end
	end

	campName = this:GetObjVar("PrefabName")
	if(campName) then
		if not(noDecay) then
			if(this:HasModule("spawn_decay")) then
				this:SendMessage("RefreshSpawnDecay")
			else
			    this:AddModule("spawn_decay")
			end
		end

    	CreatePrefab(campName,this:GetLoc(),Loc(0,0,0),"prefab_object_spawned",this)

		--Pick a random mob in the prefab to give a key to
		CallFunctionDelayed(TimeSpan.FromSeconds(1),
			function()
				prefabObjects = this:GetObjVar("PrefabObjects")
			    if (prefabObjects ~= nil) then
			        local prefabMobs = GetMobsFromPrefab(prefabObjects)
			    	local prefabChest = GetContainerFromPrefab(prefabObjects)

			    	for key,value in pairs(prefabMobs) do
			    		if (not IsPassable(value:GetLoc())) then
			    			RelocateObject(value,1)
			    		end
			    	end
			    	CreateLockAndKey(prefabMobs, prefabChest)
				end
			end)
    end
end

function RelocateObject(mob,try)
	if (try > 10) then
		DebugMessage("Failed to relocate camp mob (10 times)")
		return
	end
	local currentLoc = mob:GetLoc()
	mob:SetWorldPosition(Loc(currentLoc.X + math.random(0,6) - 3,currentLoc.Y,currentLoc.Z + math.random(0,6) - 3))
	local collision = GetCollisionInfoAtLoc(mob:GetLoc())
	if (#collision ~= 0) then
		RelocateObject(mob,try + 1)
	end
	return
end

RegisterEventHandler(EventType.Message,"Reset",
	function (noDecay)
		CampSetup(noDecay ~= nil)
	end)

RegisterEventHandler(EventType.CreatedObject,"prefab_object_spawned",
    function (success,objRef,prefabController)
        if(success) then
        	if(objRef:IsMobile()) then
        		ScheduleMobCheckTimer()
        	end
            AddToListObjVar(prefabController,"PrefabObjects",objRef)
        end
    end)

RegisterEventHandler(EventType.Message,"Destroy",
	function ( ... )
		local prefabObjects = this:GetObjVar("PrefabObjects")
		if(prefabObjects) then
			for i,prefabObj in pairs(prefabObjects) do
				prefabObj:Destroy()
			end
		end

		this:Destroy()
	end)
