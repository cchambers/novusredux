require 'base_ai_mob'
require 'base_ai_intelligent'

-- set charge speed and attack range in combat ai
AI.Settings.CanFlee = false
AI.Settings.CanUseCombatAbilities = false

AI.Settings.ChaseRange = 20.0
AI.Settings.LeashDistance = 30

--Special ability

--[[RegisterEventHandler(EventType.Message, "HasDiedMessage",
    function(killer)
    if (IsGuard(killer)) then return end
    local nearbyCombatants = FindObjects(SearchMulti(
        {
            SearchPlayerInRange(20,true), --in 20 units
        }))
        --they took part in killing the demon, they deserve credit
        for i,j in pairs(nearbyCombatants) do
            local roll = math.random(1,100)
            if roll == 1 then 
                CreateObjInBackpack(j,"prestige_scroll_knight")
                j:SystemMessage("You have gained a Prestige Scroll!")
            elseif(roll == 2) then
                CreateObjInBackpack(j,"prestige_scroll_sorcerer")
                j:SystemMessage("You have gained a Prestige Scroll!")
            end
        end
    end)]]
    
RegisterEventHandler(EventType.Arrived,"",function (success)
    if (not success ) then--or IsInCombat(this)) then
        return 
    end
    --DebugMessage(1)
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"NoAttackTimer")
end)
RegisterEventHandler(EventType.StartMoving,"",function (success)
    if (not success ) then--or IsInCombat(this)) then
        return 
    end
    --DebugMessage(0)
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"NoAttackTimer")
end)

--DFB HACK: Collision is wonky with dragon, removing
this:ClearCollisionBounds()
this:SetObjVar("DoNotRestoreCollision",true)

--RegisterEventHandler(EventType.Timer,"debug_change_to_ability",
--    function()
--        AI.StateMachine.ChangeState("DecidingCombat")
--        AI.StateMachine.ChangeState("SpecialAbility")
--    end)

RegisterEventHandler(EventType.Message,"PathBehindDoor",
    function ( ... )
        this:PathTo(this:GetObjVar("SpawnLocation"),2.0,"PathHomeToDoor")
    end)

RegisterEventHandler(EventType.Arrived,"PathHomeToDoor",function ( ... )
    if (IsDead(this)) then return end
    local resetDoor = FindObjects(SearchObjVar("TrapKey","TriggerCerberus"))
    for i,j in pairs(resetDoor) do 
        j:SendMessage("CloseDoor")
    end
    this:Destroy()
end)
--RegisterSingleEventHandler(EventType.ModuleAttached, "ai_ogre", 
--  function()
--  end)

