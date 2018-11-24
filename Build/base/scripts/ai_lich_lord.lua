require 'base_ai_mob'
require 'base_ai_intelligent'

AI.Settings.ChaseRange = 25.0
AI.Settings.LeashDistance = 35

this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"SetColor")

RegisterEventHandler(EventType.Message, "HasDiedMessage",
    function(killer)
        if (not this:HasObjVar("IsGhost")) then
         MoveEquipmentToGround(this,this:GetObjVar("DoNotSpawnChest"))
        else
          --DFB TODO: Create ghost ectoplasm here.
        end
      this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.5),"DestroyWraith")
      PlayEffectAtLoc("VoidPillar",this:GetLoc(),2)
    end)

RegisterEventHandler(EventType.Timer,"DestroyWraith",function ( ... )
  this:Destroy()
end)

RegisterEventHandler(EventType.Timer,"SetColor",
function()
  if (this:HasObjVar("IsGhost")) then
    this:SetObjVar("IsGhost",true)
    this:SetCloak(true)
    --this:GetEquippedObject("Chest"):SetColor("0xC100FFFF")
    --this:GetEquippedObject("Legs"):SetColor("0xC100FFFF")
  end
end)


-- set charge speed and attack range in combat ai
AI.Settings.CanFlee = false

AI.Settings.CanUseCombatAbilities = false

--Special ability
table.insert(AI.CombatStateTable,{StateName = "SpecialAbility",Type = "melee",Range = 0})

AI.StateMachine.AllStates.SpecialAbility  = {
        GetPulseFrequencyMS = function() return 2000 end,
        OnEnterState = function()
            --DebugMessage("Attacking combat ability")
            --FaceTarget()
            --this:StopMoving()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            this:SendMessage("RequestCombatStanceUpdate","Aggressive")            
            --DebugMessage("Firing combat ability")
            this:SendMessage("RequestCombatAbility","MagicBlast")
        end,

        AiPulse = function()
            AI.StateMachine.ChangeState("Melee")
        end,
    }

RegisterEventHandler(EventType.Arrived,"PathHomeToDoor",function ( ... )
    if (IsDead(this)) then return end
    local resetDoor = FindObjects(SearchObjVar("TrapKey","TriggerCerberus"))
    for i,j in pairs(resetDoor) do 
        j:SendMessage("CloseDoor")
    end
    this:Destroy()
end)

