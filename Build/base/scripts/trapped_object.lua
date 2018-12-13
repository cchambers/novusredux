local trapType = this:GetObjVar("TrapType") or math.random(1,this:GetObjVar("TrapChance")) or math.random(1,35)
TRAP_DELAY = this:GetObjVar("TrapDelay") or 1
TRAP_SOUND_DELAY = this:GetObjVar("TrapSoundDelay") or 0.5

this:SetObjVar("IsTrap",true)

if (trapType == 1) then --Flame pillars trap
initializer = {
		Effect = "FirePillarEffect",
		DamageAmount = 8,
		DamageRadius = 2,
		Duration = 3,
		Amount = 4,
		Randomize = true,
		RandomizeAmount = 2,
		ResetTime = 45,
	}
elseif (trapType == 2) then --Poison gas
initializer = {
		Effect = "PoisonCloudEffectSmall",
		DamageAmount = 15,
		DamageRadius = 2.5,
		Duration = 3,
		Amount = 1,
		Randomize = false,
		ResetTime = 45,
	}
elseif (trapType == 3) then --electric shock trap
initializer = {
		Effect = "LightningExplosionEffect",
		DamageAmount = 15,
		DamageRadius = 3,
		Duration = 3,
		Amount = 1,
		Randomize = false,
		ResetTime = 45,
	} 
elseif (trapType == 4) then --earth spikes trap
initializer = {
		Effect = "GroundSpikeEffect",
		DamageAmount = 45,
		DamageRadius = 2,
		Duration = 1,
		Amount = 1,
		Randomize = false,
		ResetTime = 45,
	}
elseif (trapType == 5) then --shockwave trap
initializer = {
		Effect = "ShockwaveEffect",
		DamageAmount = 30,
		DamageRadius = 4,
		Duration = 1,
		Amount = 1,
		Randomize = false,
		ResetTime = 45,
	}
elseif (trapType == 6) then --black hole trap
initializer = {
		Effect = "BlackHoleEffect",
		DamageAmount = 30,
		DamageRadius = 2,
		Duration = 5,
		Amount = 1,
		Randomize = false,
		ResetTime = 30,
		Continuious = true,
		Suction = true,
		SuctionRadius = 5,
	}
end


RegisterEventHandler(EventType.Message,"UseObject",
function (user,usedType)
	--DebugMessage("A")
	--if(usedType ~= "Use") then return end
	--DebugMessage(2)
	if (this:HasObjVar("Disabled")) then return end
	--DebugMessage(3)
	--DebugMessage(2)
    if (this:HasTimer("ResetTimer")) then return end
    --make the lever appear pulled
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(this:GetObjVar("ResetTime")),"ResetTimer")
   --DebugMessage(3)
    --this:PlayObjectSound("LeatherArmorPickup")
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(TRAP_DELAY),"TriggerTrap")
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(TRAP_SOUND_DELAY),"PlayTrapSound")
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(this:GetObjVar("Duration")),"DurationTimer")
end)

function TriggerTrap()
	local newLoc = this:GetObjVar("RelativeLoc") or Loc(0,0,0)
	for i=0,this:GetObjVar("Amount"),1 do
		local randomizeLocation = Loc(0,0,0)
		if (this:GetObjVar("Randomize")) then
			randomizeLocation = Loc(math.random()*2*this:GetObjVar("RandomizeAmount")-this:GetObjVar("RandomizeAmount"),
								    0,
								    math.random()*2*this:GetObjVar("RandomizeAmount")-this:GetObjVar("RandomizeAmount"))
		end
		local curLoc = this:GetLoc():Add(newLoc):Add(randomizeLocation)
		--DebugMessage(4)
		DealDamage(curLoc)
		--DebugMessage("curLoc = "..tostring(curLoc))
		PlayEffectAtLoc(this:GetObjVar("Effect"),curLoc,this:GetObjVar("Duration"))
	end
	if (this:GetObjVar("Continuious")) then
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"DealDamage",curLoc)
	end
end
function PlayTrapSound()
    this:PlayObjectSound("event:/objects/doors/door/door_lock")
end
function DealDamage(curLoc)
	CheckSuction(curLoc)
	if (curLoc == nil) then LuaDebugCallStack("curLoc is nil") return end
	--DebugMessage(curLoc," is curLoc,",this:GetObjVar("DamageRadius")," is DamageRadius")
	local mobiles = FindObjects(
		SearchMulti({
		SearchRange(curLoc,this:GetObjVar("DamageRadius")),
		SearchMobile()}), 
		GameObj(0))
	for n,mob in pairs(mobiles) do
		if (mob:IsPlayer()) then
			mob:SendMessage("ProcessTrueDamage", this, this:GetObjVar("DamageAmount"))
		else
			mob:SendMessage("ProcessTrueDamage",this,10)
		end
	end
	if (this:HasTimer("DurationTimer")) then
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"DealDamage",curLoc)
	end
end

function CheckSuction(curLoc)
	if (not this:HasObjVar("Suction")) then return end
	if (curLoc == nil) then LuaDebugCallStack("curLoc is nil") return end
	--DebugMessage(curLoc," is curLoc,",this:GetObjVar("SuctionRadius")," is SuctionRadius")
	local mobiles = FindObjects(
		SearchMulti({
		SearchRange(curLoc,this:GetObjVar("SuctionRadius")),
		SearchMobile()}), 
		GameObj(0))
	for n,mob in pairs(mobiles) do
		mob:PushTo(curLoc, 6,GetBodySize(mob))
	end
end
RegisterEventHandler(EventType.Timer,"TriggerTrap",TriggerTrap)
RegisterEventHandler(EventType.Timer,"DealDamage",DealDamage)
RegisterEventHandler(EventType.Timer,"PlayTrapSound",PlayTrapSound)

RegisterEventHandler(EventType.Timer,"ResetTimer",function ( ... )
	--set the lever back to normal
end)

--if there's a spawned object, and it has a time, schedule a time to decay it
RegisterEventHandler(EventType.CreatedObject,"objSpawned",
function(success,objRef,time)
	if (success) then
		if (time ~= nil) then
			Decay(objRef, time)
		end
	end
end)
--Create the spawn list
if (initializer ~= nil) then
	this:SetObjVar("Effect",initializer.Effect)
	this:SetObjVar("RelativeLoc",initializer.RelativeLoc)
	this:SetObjVar("DamageAmount",initializer.DamageAmount)
	this:SetObjVar("DamageRadius",initializer.DamageRadius)
	this:SetObjVar("Duration",initializer.Duration)
	this:SetObjVar("Amount",initializer.Amount)
	this:SetObjVar("Randomize",initializer.Randomize)
	this:SetObjVar("RandomizeAmount",initializer.RandomizeAmount)
	this:SetObjVar("ResetTime",initializer.ResetTime)
	this:SetObjVar("Suction",initializer.Suction)
	this:SetObjVar("SuctionRadius",initializer.SuctionRadius)
	this:SetObjVar("Continuious",initializer.Continuious)
end

RegisterEventHandler(EventType.Message,"DisableTrap",function (time,user)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(time),"DisableTrapReset")
	this:SetObjVar("Disabled",true)
end)

RegisterEventHandler(EventType.Timer,"EnableTrap",function()
	this:DelObjVar("Disabled")
end)