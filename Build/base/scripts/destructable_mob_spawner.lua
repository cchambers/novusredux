require 'destroyable_object'

mCurTarget = nil

RegisterEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
	function()

		mActive = true

		local mobList = {}
		local spawns = this:GetObjVar("Spawns") or {}
		for mobEntryIndex, mobEntry in pairs(spawns) do
			mobList[mobEntry.Template] = 0
		end

		--Mob list keeps a counter for each type of mob in the spawner template
		this:SetObjVar("MobList", mobList)

		CheckSpawns()
	end)

OverrideEventHandler("destroyable_object", EventType.Message, "DamageInflicted", 
	function(damager,damageAmt)
		HandleDamage(damager,damageAmt)
		mCurTarget = damager
		mActive = true
		CheckDamagePercentage()
	end)

--add the mobs to a list of spawns
RegisterEventHandler(EventType.CreatedObject,"mob_spawned",
	function(success,objRef)
		PlayEffectAtLoc("GhostEffect", objRef:GetLoc())
		objRef:SetObjVar("Source", this)
		objRef:AddModule("mob_spawner_mob")

		if (mCurTarget ~= nil and mCurTarget:IsPlayer()) then
			objRef:SendMessage("AttackEnemy",mCurTarget, true)
		end

		local mobList = this:GetObjVar("MobList") or {}
		local template = objRef:GetCreationTemplateId()
		if (mobList[template] == nil) then
			mobList[template] = 0
		end

		mobList[template] = mobList[template] + 1
		this:SetObjVar("MobList", mobList)

	end)

RegisterEventHandler(EventType.Message, "mobSlain", 
	function(slainMob)
		if not (slainMob:IsValid()) then return end
		Decay(slainMob, 5)
		local mobList = this:GetObjVar("MobList")
		local template = slainMob:GetCreationTemplateId()

		for mobTemplate, mobCount in pairs(mobList) do
			if (mobTemplate == template) then
				mobList[template] = mobList[template] - 1
			end
		end

		this:SetObjVar("MobList", mobList)
	end)

if (initializer ~= nil) then
	this:SetObjVar("Spawns",initializer.Spawns)
	this:SetObjVar("SpawnRange", initializer.SpawnRange or 5)
end

function CheckDamagePercentage()
	local baseHealth = GetMaxHealth(this)
	local curHealth = this:GetStatValue("Health")
	local percentage = (curHealth/baseHealth)*100
	
	if (SpawnAtPercent[curPercentIndex] ~= nil) then
		if (percentage < (SpawnAtPercent[curPercentIndex] or 0)) then
			curPercentIndex = curPercentIndex + 1
			AddSpawns()
		end
	end
end

--Spawns mobs up to max
function CheckSpawns()
	local mobList = this:GetObjVar("MobList") or {}
	local spawns = this:GetObjVar("Spawns") or {}

	for mobEntryIndex, mobEntry in pairs(spawns) do
		if (mActive and not mDead) and (mobList[mobEntry.Template] < mobEntry.Max) then
			local mobCount = mobEntry.Max - mobList[mobEntry.Template]
			for i=1,mobCount do
				local spawnLoc = GetNearbyPassableLocFromLoc(this:GetLoc(), 2, this:GetObjVar("SpawnRange") or 20)
				CreateObj(mobEntry.Template,spawnLoc,"mob_spawned")
			end
		end
	end
end

--Spawns mobs beyond max
function AddSpawns()
	local mobList = this:GetObjVar("MobList") or {}
	local spawns = this:GetObjVar("Spawns") or {}
	for mobEntryIndex, mobEntry in pairs(spawns) do
		for i=1,(mobEntry.AddSpawns or 2) do
			local spawnLoc = GetNearbyPassableLocFromLoc(this:GetLoc(), 2, this:GetObjVar("SpawnRange") or 20)
			CreateObj(mobEntry.Template,spawnLoc,"mob_spawned")
		end
	end
end

--If the current health reaches below a percentage, it will respawn mobs and start checking for the next percentage
SpawnAtPercent = 
{
	100,
	80,
	60,
	40,
	20
}
curPercentIndex = 1