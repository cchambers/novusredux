TRAP_DELAY = this:GetObjVar("TrapDelay") or 0
TRAP_SOUND_DELAY = this:GetObjVar("TrapSoundDelay") or 0
TRAP_INFO = Traps[this:GetObjVar("TrapType")] or Traps["FirePillarTrap"]
TRAP_LOCKPICK_DISABLE_TIME = 300

this:SetObjVar("IsTrap",true)

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
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(TRAP_INFO.ResetTime),"ResetTimer")
   --DebugMessage(3)
    --this:PlayObjectSound("LeatherArmorPickup")
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(TRAP_DELAY),"TriggerTrap")
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(TRAP_SOUND_DELAY),"PlayTrapSound")
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(this:GetObjVar("Duration")),"DurationTimer")
	this:SendMessage("DisableTrap", TRAP_INFO.ResetTime)
end)

function TriggerTrap()
	local newLoc = this:GetObjVar("RelativeLoc") or Loc(0,0,0)
	for i=0,TRAP_INFO.Amount,1 do
		local randomizeLocation = Loc(0,0,0)
		if (TRAP_INFO.Randomize) then
			randomizeLocation = Loc(
				math.random()*2*TRAP_INFO.RandomizeAmount-TRAP_INFO.RandomizeAmount,
			    0,
			    math.random()*2*TRAP_INFO.RandomizeAmount-TRAP_INFO.RandomizeAmount)
		end
		local curLoc = this:GetLoc():Add(newLoc):Add(randomizeLocation)
		--DebugMessage(4)
		DealDamage(curLoc)
		--DebugMessage("curLoc = "..tostring(curLoc))
		PlayEffectAtLoc(TRAP_INFO.Effect,curLoc,TRAP_INFO.Duration)
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
		SearchRange(curLoc,TRAP_INFO.DamageRadius),
		SearchMobile()}), 
		GameObj(0))
	for n,mob in pairs(mobiles) do
		if (mob:IsPlayer()) then
			mob:SendMessage("ProcessTrueDamage", this, TRAP_INFO.DamageAmount)
		else
			mob:SendMessage("ProcessTrueDamage",this,10)
		end
	end
	if (this:HasTimer("DurationTimer")) then
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"DealDamage",curLoc)
	end
end

function EnableTrap()
	this:SetObjVar("locked", true)
	this:DelObjVar("Disabled")
end

function CheckSuction(curLoc)
	if (not TRAP_INFO.Suction) then return end
	if (curLoc == nil) then LuaDebugCallStack("curLoc is nil") return end
	--DebugMessage(curLoc," is curLoc,",this:GetObjVar("SuctionRadius")," is SuctionRadius")
	local mobiles = FindObjects(
		SearchMulti({
		SearchRange(curLoc,TRAP_INFO.SuctionRadius),
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

RegisterEventHandler(EventType.Timer,"EnableTrap",EnableTrap)

RegisterEventHandler(EventType.Message,"Lockpicked",
	function(user)
		user:NpcSpeech("[C0C0C0]Disabled Trap[-]", "combat")
		this:SendMessage("DisableTrap", TRAP_LOCKPICK_DISABLE_TIME)
	end)

RegisterEventHandler(EventType.Timer,"DisableTrapReset",function()
	EnableTrap()
end)