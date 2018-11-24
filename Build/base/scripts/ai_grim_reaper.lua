require 'base_ai_mob'
require 'base_ai_intelligent'
require 'base_ai_casting'
require 'incl_regions'

SkeleCooldown = true
AI.Settings.CanFlee = false

quotes = {
    {Text = "Your souls are MINE!!!",Audio="DeathVoice1"},
    {Text = "Your time is nigh...",Audio="DeathVoice2"},
    {Text = "I will consume you.",Audio="DeathVoice3"},
    {Text = "I... will... consume... you...",Audio="DeathVoice4"},
    {Text = "I will destroy you...",Audio="DeathVoice5"},
    {Text = "I will destroy you...",Audio="DeathVoice6"},
    --"I am the BEGINNING, and the END!!!",
   -- "Prepare to be cast to the Void!!!",
   -- "I'll swallow your soul!",
	--"I never lose, mortal!!!",
	--"Death is only the beginning for you, mortal!!!",
	--"[$70]",
   -- "You cannot cheat DEATH!!!",
   -- "Even if you kill me mortal, I will return!!!",
}
table.insert(AI.CombatStateTable,{StateName = "Deathwave",Type = "melee",Range = 0})
table.insert(AI.CombatStateTable,{StateName = "Deathspin",Type = "melee",Range = 0})
table.insert(AI.CombatStateTable,{StateName = "Megastrike",Type = "rangedattack",Range = 15})
table.insert(AI.CombatStateTable,{StateName = "SpawnSkeletons",Type = "melee",Range = 0})
table.insert(AI.CombatStateTable,{StateName = "Voidteleport",Type = "rangedattack",Range = 15})
table.insert(AI.CombatStateTable,{StateName = "Voidteleport",Type = "melee",Range = 15})

AI.Settings.CheckLOS = false

AI.Settings.ChaseRange = MAX_PATHTO_DIST

function GetRandomTeleportLocation(target)
    local maxTries = 20
    if (target == nil) then target = this end
    local spawnLoc = target:GetLoc():Project(math.random(1,360), math.random(1,7))
    -- try to find a passable location
    while(maxTries > 0 and not(IsPassable(spawnLoc)) ) do
        spawnLoc = target:GetLoc():Project(math.random(1,360), math.random(1,7))
        maxTries = maxTries - 1
    end

    return spawnLoc
end

--make little ones
AI.StateMachine.AllStates.SpawnSkeletons = {
        GetPulseFrequencyMS = function() return 1000 + math.random(400) end,

        OnEnterState = function()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end
            --DebugMessage("Attempting Imp Spawn")
            FaceTarget()
            if (not SkeleCooldown) then
                AI.StateMachine.ChangeState("Chase")                
                return
            end

            this:StopMoving()
            this:PlayAnimation("cast_heal")
            this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(10000), "cooldownSkeletons")
            this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(700), "spawnSkeleton")
            SkeleCooldown = false
        end,

        AiPulse = function()
            DecideCombatState()
        end,
    }

RegisterEventHandler(EventType.Timer,"cooldownSkeletons", function()
  SkeleCooldown = true
  end)

RegisterEventHandler(EventType.Timer,"spawnSkeleton", function()
    local newlist = {}
    local minionsInPlay = this:GetObjVar("SkeletonList") or {}
    for i,j in pairs(minionsInPlay) do
        if j:IsValid() then
            table.insert(newlist,j)
        end
    end
    --local choice = math.random(1,3)
    --local choices = --{"void_shadow","death_minion","death_minion",}
    local spawnCount = 18 - #newlist
    if (spawnCount > 0) then
        for i=1,spawnCount do
          local spawnLoc = this:GetLoc():Project(math.random(0,360), math.random(2,5))
          if this:HasObjVar("HomeRegion") then
            local region = this:GetObjVar("HomeRegion")
            if (GetRegion(region) ~= nil) then
                spawnLoc = GetRandomPassableLocation(region)
            end
          end
          CreateObj("death_minion", spawnLoc, "skeletonSpawn")
          PlayEffectAtLoc("VoidTeleportToEffect",spawnLoc)
          --DebugMessage("Spawning skeleton.")
        end
    end
  end)

RegisterEventHandler(EventType.Message,"SpawnDestroyMessage",function ()
    if not this:HasObjVar("SkeletonList") then
        return
    end
    for i,j in pairs(this:GetObjVar("SkeletonList")) do
        j:Destroy()
    end
end)

RegisterEventHandler(EventType.CreatedObject,"skeletonSpawn",function(success,objRef)
    --DebugMessage("Creating object")
    if (success) then 
        local skeletonList = {}
        --DebugMessage("Success!")
        if (this:HasObjVar("SkeletonList")) then            
            skeletonList = this:GetObjVar("SkeletonList")
        end
        Decay(objRef)

        objRef:PlayEffect("VoidPillar",3)
        table.insert(skeletonList,objRef)
        this:SetObjVar("SkeletonList",skeletonList)
    end
end)


AI.StateMachine.AllStates.Megastrike  = {
        GetPulseFrequencyMS = function() return 2000 end,
        OnEnterState = function()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end
            --DebugMessage("Requesting Megastrike")
            this:SendMessage("RequestCombatStanceUpdate","Aggressive")            
                --DebugMessage("Firing combat ability")
            this:SendMessage("RequestCombatAbility","Megastrike")
        end,
        AiPulse = function()
            DecideCombatState()
        end,
    }


AI.StateMachine.AllStates.Deathspin  = {
        GetPulseFrequencyMS = function() return 6800 end,
        OnEnterState = function()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end
            --DebugMessage("Requesting Deathspin")
            this:SendMessage("RequestCombatStanceUpdate","Aggressive")            
                --DebugMessage("Firing combat ability")
            this:SendMessage("RequestCombatAbility","Deathspin")
        end,
        AiPulse = function()
            DecideCombatState()
        end,
    }

AI.StateMachine.AllStates.Voidteleport  = {
        GetPulseFrequencyMS = function() return 1300 end,
        OnEnterState = function()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end
            --DebugMessage("Requesting Megastrike")
            this:SendMessage("RequestCombatStanceUpdate","Aggressive")            
                --DebugMessage("Firing combat ability")
                --DebugMessage("Entering combat state")
            this:SendMessage("RequestCombatAbility","Voidteleport")
        end,
        AiPulse = function()
            DecideCombatState()
        end,
    }

AI.StateMachine.AllStates.Deathwave  = {
        GetPulseFrequencyMS = function() return 2000 end,
        OnEnterState = function()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            this:SendMessage("RequestCombatStanceUpdate","Aggressive")            
            --DebugMessage("Firing combat ability")
            this:SendMessage("RequestCombatAbility","Deathwave")
        end,
        AiPulse = function()
            DecideCombatState()
        end,
    }


AI.StateMachine.AllStates.DecidingCombat = {
        OnEnterState = function()	
       		if (math.random(1,50) == 1) then
       			this:StopMoving()
       			this:PlayAnimation("rend")
       			Speak(quotes[math.random(1,#quotes)])
       		end
        end,
    }

function CrystalsDead()
    local crystals = FindObjects(SearchTemplate("reaper_room_crystal",50))
    if (#crystals == 0) then return true end

    for i,j in pairs(crystals) do
        if (not j:GetObjVar("Destroyed")) then
            return false
        end
    end    

    return true
end

RegisterEventHandler(EventType.Message, "DamageInflicted",
    function (damager,damageAmt)         
        --if I'm a boss demon
        if (not IsGuard(damager)) then            
            if (CrystalsDead()) then return end
            if (IsGod(damager)) then return end
            --DebugMessage("Recovering")
            --he's invincible unless you get the imbued weapon
            SetCurHealth(this,GetCurHealth(this) + damageAmt)
            this:NpcSpeech("[FCF403]*Invincible!*[-]","combat")
            damager:SystemMessage("[$71]","info")
        end
    end
)

this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"CheckShield")
RegisterEventHandler(EventType.Timer,"CheckShield",
    function ()
        local crystalsDead = CrystalsDead()
        local isShielded = this:GetSharedObjectProperty("Variation") == "Shield"

        if( not(isShielded) and not(crystalsDead)) then
            isShielded = true
            this:SetSharedObjectProperty("Variation","Shield")
            Speak(quotes[math.random(1,#quotes)])
        elseif( isShielded and crystalsDead) then
            isShielded = true
            this:SetSharedObjectProperty("Variation","Default")
            Speak(quotes[math.random(1,#quotes)])
        end
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"CheckShield")
    end)

RegisterEventHandler(EventType.Message, "HasDiedMessage",
    function(killer)
        if (IsGuard(killer)) then return end
        --If I'm a boss demon
        local traps = FindObjects(SearchObjVar("TrapKey","DeathLair",50)) 
        for i,j in pairs(traps) do
            j:SendMessage("Deactivate")
        end

        if(ServerSettings.WorldName == "Catacombs") then
            local destRegionAddress
            local destination
            destRegionAddress, destination = GetStaticPortalSpawn("CatacombsEntrance")
            PlayEffectAtLoc("TeleportFromEffect",Loc(201,0,-175.0))
            CreateObj("portal_red",Loc(201,0,-175.0),"death_transfer_portal_created") 
            RegisterSingleEventHandler(EventType.CreatedObject,"death_transfer_portal_created",
                function (success,objRef)
                    if(success) then
                    objRef:SetObjVar("Destination",destination)
                    objRef:SetObjVar("RegionAddress",destRegionAddress)
                end
            end)

            local loggedOnUsers = FindPlayersInRegion()
            for index,object in pairs(loggedOnUsers) do
--                object:PlayEffectWithArgs("ScreenShakeEffect", 3.0,"Magnitude=5")
                object:SystemMessage("Death's curse descends as he is vanquished from this realm for a time.. Hurry and exit this cursed place!","event")
            end

            local controller = FindObjectWithTag("CatacombsController")
            if(controller) then
                controller:SendMessage("PurgePlayers")
            else
                DebugMessage("CatacombsController missing, unable to set timer to purge players")
            end
        end

        if ( this:HasObjVar("lootable") ) then return end
        
        local nearbyCombatants = FindObjects(SearchMulti(
        {
            SearchPlayerInRange(20,true), --in 20 units
        }))
        this:RemoveTimer("VoidAura")
        --they took part in killing the demon, they deserve credit
        DistributeBossRewards(nearbyCombatants, {TemplateDefines.LootTable.DeathBossGear}, "Death")
    end)

    
RegisterEventHandler(EventType.CreatedObject, "DeathRewardCreated", function(success,objRef,amount)
    if ( success ) then
        SetItemTooltip(objRef)
    end
end)

this:ScheduleTimerDelay(TimeSpan.FromSeconds(4.0),"VoidAura")
RegisterEventHandler(EventType.Timer,"VoidAura",function()
  this:PlayEffect("VoidAuraEffect",6)
  this:ScheduleTimerDelay(TimeSpan.FromSeconds(4.0),"VoidAura")

  --DFB HACK: Keep him from going outside the death chamber
    if (this:HasObjVar("HomeRegion")) then
        if (GetRegion("HomeRegion") ~= nil and not this:IsInRegion(this:GetObjVar("HomeRegion"))) then
            this:SetWorldPosition(this:GetObjVar("SpawnPosition"))
        end
    end
end)
this:FireTimer("VoidAura")
this:SetSharedObjectProperty("CombatMode",true)