require 'NOS:loop_effect'

require 'NOS:base_ai_mob'
require 'NOS:base_ai_casting'
require 'NOS:base_ai_intelligent'

AI.Settings.ChaseRange = 20
AI.Settings.LeashDistance = 30

ChanceToNotAttackOnAlert = 1 --1 out of this number chance to attack when alerted

ImpCooldown = true

--make little ones
AI.StateMachine.AllStates.SpawnImps = {
        GetPulseFrequencyMS = function() return 1000 + math.random(400) end,

        OnEnterState = function()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end
            --DebugMessage("Attempting Imp Spawn")
            FaceTarget()
            if (not ImpCooldown) then
                AI.StateMachine.ChangeState("Chase")                
                return
            end

            this:StopMoving()
            this:PlayAnimation("cast")
            this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(10000), "cooldownImps")
            this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(700), "spawnImps")
            ImpCooldown = false
        end,

        AiPulse = function()
            DecideCombatState()
        end,
    }

RegisterEventHandler(EventType.Message,"SpawnDestroyMessage",function ()
    
    if not this:HasObjVar("ImpList") then
        return
    end

    for i,j in pairs(this:GetObjVar("ImpList")) do
        j:Destroy()
    end

end)

RegisterEventHandler(EventType.Message, "DamageInflicted",
    function (damager,damageAmt)         
        --if I'm a boss demon
        if (this:HasObjVar("BossDemonGraveyard") and not IsGuard(damager)) then
            if (damager:IsValid() and damager ~= nil) then
                damagerQuestState = damager:GetObjVar("HeroQuestState")
            end
            --if they got hit with an attack that massive or got slayed then kill em
            if (damageAmt > 4999) then
                --DebugMessage("Slayed")
                return
            end

            --if they have an imbued weapon then return
            if (damagerQuestState == "ImbuedWeapon") then
                --DebugMessage("Damaged imbued")
                return
            end
            --DebugMessage("Recovering")
            --he's invincible unless you get the imbued weapon
            SetCurHealth(this,GetCurHealth(this) + damageAmt)
            this:NpcSpeech("[FCF403]*Invincible!*[-]","combat")
            damager:SystemMessage("This creature cannot be killed by ordinary means!","info")
        end
    end
)

RegisterEventHandler(EventType.Message, "HasDiedMessage",
    function(killer)
        this:PlayEffect("FireTornadoEffect",7)
        this:SendMessage("SpawnDestroyMessage")
        if (IsGuard(killer)) then return end
        --If I'm a boss demon
        if (this:HasObjVar("BossDemonGraveyard")) then

            CreateObj("cel_graveyard_sorcerer", this:GetObjVar("SpawnLocation"), "ghostSpawned")

            --only spawn once a night
            this:SendMessage("UpdateDecay",15*60)

            killer:SetObjVar("HeroQuestState","KilledDemon")
            --find all the nearby participants in the quest
            local nearbyCombatants = FindObjects(SearchMulti(
            {
                SearchMobileInRange(20), --in 20 units
                SearchHasObjVar("HeroQuestState"), --find demon quest slayers
            }))
            --they took part in killing the demon, they deserve credit
            for i,j in pairs(nearbyCombatants) do
                j:SystemMessage("Your party has slain the demon!","event")
                j:SetObjVar("HeroQuestState","KilledDemon")
                j:SendMessage("AdvanceQuest","SlayDemonQuest","TalkToElivar","SlayDemon")
            end
            --do a search for all players around me with the combating demon quest state, then set their obj var to killed demon
        end
    end)
