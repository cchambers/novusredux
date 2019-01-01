require 'default:base_ai_mob'

--Set to cast
AI.SetSetting("CanCast", true)

AI.SetSetting("SpellRangeMod", 20)

AI.SetSetting("ChaseRange", AI.GetSetting("LeashDistance") - 5)
AI.Spells = {
    Heal = {
        Type = "healspell"
    },
    Greaterheal = {
        Type = "healspell"
    },
    Fireball = {
        Type = "offensivespell"
    },
    Frost = {
        Type = "offensivespell"
    },
    Lightning = {
        Type = "offensivespell"
    },
    Teleport = {
        Type = "offensivespell"
    },
    
    Resurrect = {
        Type = "resurrectspell"
    },
    Poison = {
        Type = "offensivespell"
    },
    Electricbolt = {
        Type = "offensivespell"
    },
    Bombardment = {
        Type = "offensivespell"
    },
    Meteor = {
        Type = "offensivespell"
    },
    Ruin = {
        Type = "offensivespell"
    },
}

--DFB TODO: AI FOR WALL OF FIRE

--Add choices to the combat state table of spells to use
for spellName,data in pairs(AI.Spells) do
    table.insert(AI.CombatStateTable, {
        StateName = "Cast"..spellName,
        Type = data.Type,
        Range = GetSpellRange(spellName, this),
        Spell = spellName
    })
end

--Use these states for casting with AI
AI.StateMachine.AllStates.CastFireball = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Fireball", this)*1000 + math.random(400) end,

        OnEnterState = function()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            FaceTarget()
            if ((not CanCast("Fireball",AI.MainTarget)) or this:DistanceFrom(AI.MainTarget) > (GetSpellRange("Fireball",this) + AI.GetSetting("SpellRangeMod"))) then
                --DebugMessage("Can't Cast Fireball in OnEnterState")
                AI.StateMachine.ChangeState("Chase")                
                return
            end
            --DebugMessage("Attempting Cast Fireball")
            this:StopMoving()
            this:SendMessage("CastSpellMessage","Fireball",this,AI.MainTarget)
        end,

        AiPulse = function()
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
            --this:SetMobileFrozen(false,false)
        end,
    }

    AI.StateMachine.AllStates.CastFrost = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Frost", this)*1000 + math.random(400) end,

        OnEnterState = function()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            FaceTarget()
            if ((not CanCast("Frost",AI.MainTarget)) or this:DistanceFrom(AI.MainTarget) > (GetSpellRange("Frost",this) + AI.GetSetting("SpellRangeMod"))) then
                AI.StateMachine.ChangeState("Chase")                
                return
            end
            this:StopMoving()
            this:SendMessage("CastSpellMessage","Frost",this,AI.MainTarget)
        end,

        AiPulse = function()
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
        end,
    }







    AI.StateMachine.AllStates.CastRuin = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Ruin", this)*1000 + math.random(400) end,

        OnEnterState = function()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            FaceTarget()
            if ((not CanCast("Ruin",AI.MainTarget)) or this:DistanceFrom(AI.MainTarget) > (GetSpellRange("Ruin",this) + AI.GetSetting("SpellRangeMod"))) then
                --DebugMessage("Can't Cast Fireball in OnEnterState")
                AI.StateMachine.ChangeState("Chase")                
                return
            end
            --DebugMessage("Attempting Cast Fireball")
            this:StopMoving()
            this:SendMessage("CastSpellMessage","Ruin",this,AI.MainTarget)
        end,

        AiPulse = function()
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
            --this:SetMobileFrozen(false,false)
        end,
    }

AI.StateMachine.AllStates.CastElectricbolt = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Electricbolt", this)*1000 + math.random(400) end,

        OnEnterState = function()
        FaceTarget()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            if ((not CanCast("Electricbolt",AI.MainTarget)) or this:DistanceFrom(AI.MainTarget) > GetSpellRange("Electricbolt",this)+AI.GetSetting("SpellRangeMod")) then
                -- DebugMessage("Can't Cast Lightning in OnEnterState")
                AI.StateMachine.ChangeState("Chase")
                return
            end
            -- DebugMessage("Attempting Cast Lightning")
            this:StopMoving()            
            this:SendMessage("CastSpellMessage","Electricbolt",this,AI.MainTarget)
        end,

        AiPulse = function()
        --    DebugMessage("Exiting Cast Lightning")
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
           -- this:SetMobileFrozen(false,false)--DFB HACK: ONLY FOR PLAYTEST
        end,
    }
    
AI.StateMachine.AllStates.CastPoison = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Poison", this)*1000 + math.random(400) end,

        OnEnterState = function()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            FaceTarget()
            if ((not CanCast("Poison",AI.MainTarget)) or this:DistanceFrom(AI.MainTarget) > GetSpellRange("Poison",this)+AI.GetSetting("SpellRangeMod")) then
                -- DebugMessage("Can't Cast Fireball in OnEnterState")
                AI.StateMachine.ChangeState("Chase")                
                return
            end
            -- DebugMessage("Attempting Cast Fireball")
            this:StopMoving()
            this:SendMessage("CastSpellMessage","Poison",this,AI.MainTarget)
        end,

        AiPulse = function()
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
            --this:SetMobileFrozen(false,false)
        end,
    }

AI.StateMachine.AllStates.CastVoidblast = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Voidblast", this)*1000 + math.random(400) end,

        OnEnterState = function()
        FaceTarget()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            if ((not CanCast("Voidblast",AI.MainTarget)) or this:DistanceFrom(AI.MainTarget) > GetSpellRange("Voidblast",this)+AI.GetSetting("SpellRangeMod")) then
                --DebugMessage("Can't Cast Lightning in OnEnterState")
                AI.StateMachine.ChangeState("Chase")
                return
            end
            --DebugMessage("Attempting Cast Lightning")
            this:StopMoving()            
            this:SendMessage("CastSpellMessage","Voidblast",this,AI.MainTarget)
        end,

        AiPulse = function()
           --DebugMessage("Exiting Cast Lightning")
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
           -- this:SetMobileFrozen(false,false)--DFB HACK: ONLY FOR PLAYTEST
        end,
    }
AI.StateMachine.AllStates.CastSouldrain = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Souldrain", this)*1000 + math.random(400) end,

        OnEnterState = function()
        FaceTarget()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            if ((not CanCast("Souldrain",AI.MainTarget)) or this:DistanceFrom(AI.MainTarget) > GetSpellRange("Souldrain",this)+AI.GetSetting("SpellRangeMod")) then
                --DebugMessage("Can't Cast Lightning in OnEnterState")
                AI.StateMachine.ChangeState("Chase")
                return
            end
            --DebugMessage("Attempting Cast Lightning")
            this:StopMoving()            
            this:SendMessage("CastSpellMessage","Souldrain",this,AI.MainTarget)
        end,

        AiPulse = function()
           --DebugMessage("Exiting Cast Lightning")
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
           -- this:SetMobileFrozen(false,false)--DFB HACK: ONLY FOR PLAYTEST
        end,
    }
AI.StateMachine.AllStates.CastLightning = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Lightning", this)*1000 + math.random(400) end,

        OnEnterState = function()
        FaceTarget()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            if ((not CanCast("Lightning",AI.MainTarget)) or this:DistanceFrom(AI.MainTarget) > GetSpellRange("Lightning",this)+AI.GetSetting("SpellRangeMod")) then
                --DebugMessage("Can't Cast Lightning in OnEnterState")
                AI.StateMachine.ChangeState("Chase")
                return
            end
            --DebugMessage("Attempting Cast Lightning")
            this:StopMoving()            
            this:SendMessage("CastSpellMessage","Lightning",this,AI.MainTarget)
        end,

        AiPulse = function()
           --DebugMessage("Exiting Cast Lightning")
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
           -- this:SetMobileFrozen(false,false)--DFB HACK: ONLY FOR PLAYTEST
        end,
    }

AI.StateMachine.AllStates.CastChainlightning = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Chainlightning", this)*1000 + math.random(400) end,

        OnEnterState = function()
        FaceTarget()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            if ((not CanCast("Chainlightning",AI.MainTarget)) or this:DistanceFrom(AI.MainTarget) > GetSpellRange("Chainlightning",this)+AI.GetSetting("SpellRangeMod")) then
                --DebugMessage("Can't Cast Lightning in OnEnterState")
                AI.StateMachine.ChangeState("Chase")
                return
            end
            --DebugMessage("Attempting Cast Lightning")
            this:StopMoving()            
            this:SendMessage("CastSpellMessage","Chainlightning",this,AI.MainTarget)
        end,

        AiPulse = function()
           --DebugMessage("Exiting Cast Lightning")
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
           -- this:SetMobileFrozen(false,false)--DFB HACK: ONLY FOR PLAYTEST
        end,
    }

AI.StateMachine.AllStates.CastBombardment = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Bombardment", this)*1000 + math.random(400) end,

        OnEnterState = function()
        FaceTarget()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            if ((not CanCast("Bombardment",AI.MainTarget)) or this:DistanceFrom(AI.MainTarget) > GetSpellRange("Bombardment",this)+AI.GetSetting("SpellRangeMod")) then
                --DebugMessage("Can't Cast Lightning in OnEnterState")
                AI.StateMachine.ChangeState("Chase")
                return
            end
            --DebugMessage("Attempting Cast Lightning")
            this:StopMoving()            
            this:SendMessage("CastSpellMessage","Bombardment",this,AI.MainTarget)
        end,

        AiPulse = function()
           --DebugMessage("Exiting Cast Lightning")
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
           -- this:SetMobileFrozen(false,false)--DFB HACK: ONLY FOR PLAYTEST
        end,
    }

function GetRandomTeleportLocation(target)
    local maxTries = 20
    if (target == nil) then target = this end
    local spawnLoc = target:GetLoc():Project(math.random(1,360), math.random(4,7))
    -- try to find a passable location
    while(maxTries > 0 and not(IsPassable(spawnLoc)) ) do
        spawnLoc = target:GetLoc():Project(math.random(1,360), math.random(4,7))
        maxTries = maxTries - 1
    end

    return spawnLoc
end

AI.StateMachine.AllStates.CastTeleport = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Teleport", this)*1000 + math.random(400) end,

        OnEnterState = function()
            FaceTarget()
            --DebugMessage("Casting teleport")
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            if (not CanCast("Teleport",AI.MainTarget)) then
                --DebugMessage("Can't Cast Teleport in OnEnterState")
                AI.StateMachine.ChangeState("Chase")
                return
            end
            --DebugMessage("Attempting Cast Lightning")
            this:StopMoving()            
            local teleLoc = GetRandomTeleportLocation(AI.MainTarget)
            this:SendMessage("CastSpellMessage","Teleport",this,nil,teleLoc)
        end,

        AiPulse = function()
            --DebugMessage("Exiting Cast Lightning")
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
            --this:SetMobileFrozen(false,false)--DFB HACK: ONLY FOR PLAYTEST
        end,
    }

AI.StateMachine.AllStates.CastBlackhole = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Blackhole", this)*1000 + math.random(400) end,

        OnEnterState = function()
            FaceTarget()
            --DebugMessageA(this,"Casttimems is "..tostring(GetSpellCastTime("Blackhole", this)*1000))
            --DebugMessage("Casting teleport")
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                --DebugMessage(1)
                return
            end
            local teleLoc = GetRandomTeleportLocation(AI.MainTarget)

            if ((not CanCast("Blackhole",AI.MainTarget)) or this:GetLoc():Distance(teleLoc) > GetSpellRange("Blackhole",this)+AI.GetSetting("SpellRangeMod")) then
                --DebugMessage("Can't Cast Teleport in OnEnterState")
                --DebugMessage(2)
                AI.StateMachine.ChangeState("Chase")
                return
            end
            --DebugMessage("Attempting Cast Lightning")
               --DebugMessage(3)
            this:StopMoving()            
            this:SendMessage("CastSpellMessage","Blackhole",this,nil,teleLoc)
        end,

        AiPulse = function()
                --DebugMessage(5)
            --DebugMessage("Exiting Cast Lightning")
            DecideCombatState()
        end,

        OnExitState = function()
               --DebugMessage(4)
            --DebugMessage("Casttimems is "..tostring(GetSpellCastTime("Blackhole", this)*1000))
            this:SendMessage("CancelSpellCast")
            --this:SetMobileFrozen(false,false)--DFB HACK: ONLY FOR PLAYTEST
        end,
    }

AI.StateMachine.AllStates.CastSpawnskeleton = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Spawnskeleton", this)*1000 + math.random(400) end,

        OnEnterState = function()

            --pick a nearby friendly target that's dead, including me.
            --DebugMessage(1)
            local friends = GetNearbyDeadMobiles(GetSpellRange("Spawnskeleton",this))
            local healTarget = this
            --DebugMessage(DumpTable(friends))
            if (friends ~= nil) then
                for i,j in pairs(friends) do
                    if (IsDead(j)) then
                        healTarget = j
                    end
                end
            end

            if (healTarget ~= this) then
                FaceObject(this,healTarget)
            end
            DebugMessageA(this,CanCast("Spawnskeleton"),healTarget == this)
            if ((not CanCast("Spawnskeleton",healTarget)) or (healTarget == this) or (this:DistanceFrom(healTarget) > GetSpellRange("Spawnskeleton",this)+AI.GetSetting("SpellRangeMod"))) then
                --DebugMessage("Can't Cast Lightning in OnEnterState")
                AI.StateMachine.ChangeState("Chase")
                return
            end
            --6DebugMessage("Attempting Cast Lightning")
            this:StopMoving()            
            this:SendMessage("CastSpellMessage","Spawnskeleton",this,healTarget)
        end,

        AiPulse = function()
            --DebugMessage("Exiting Cast Lightning")
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
            --this:SetMobileFrozen(false,false) --DFB HACK: ONLY FOR PLAYTEST
        end,
    }

AI.StateMachine.AllStates.CastResurrect = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Resurrect", this)*1000 + math.random(400) end,

        OnEnterState = function()

            --pick a nearby friendly target that's dead, including me.
            local friends = GetNearbyAllies(GetSpellRange("Resurrect",this),true)
            local healTarget = this
            if (friends ~= nil) then
                for i,j in pairs(friends) do
                    if (IsDead(j)) then
                        healTarget = j
                    end
                end
            end

            if (healTarget ~= this) then
                FaceObject(this,healTarget)
            end

            DebugMessageA(this,CanCast("Spawnskeleton"),healTarget == this)
            if (not CanCast("Resurrect",healTarget) or healTarget == this) then
                --DebugMessage("Can't Cast Lightning in OnEnterState")
                AI.StateMachine.ChangeState("Chase")
                return
            end
            --6DebugMessage("Attempting Cast Lightning")
            this:StopMoving()            
            this:SendMessage("CastSpellMessage","Resurrect",this,healTarget)
        end,

        AiPulse = function()
            --DebugMessage("Exiting Cast Lightning")
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
            --this:SetMobileFrozen(false,false) --DFB HACK: ONLY FOR PLAYTEST
        end,
    }

MIN_CLOAK_HEALTH = 15
AI.StateMachine.AllStates.CastCloak = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Cloak", this)*1000 + math.random(400) end,

        OnEnterState = function()

            --pick a nearby target with the lowest health and cloak them, including me.
            --DFB TODO: Make them cloak whatever is attacking their target
            local friends = GetNearbyAllies(GetSpellRange("Cloak",this))
            local healTarget = this
            local lowestHeal = MIN_CLOAK_HEALTH
            if (friends ~= nil) then
                for i,j in pairs(friends) do
                    if (GetCurHealth(j)<lowestHeal) then
                        healTarget = j
                        lowestHeal = GetCurHealth(j)
                    end
                end
            end

            if (healTarget ~= this) then
                FaceObject(this,healTarget)
            end

            if( not(AI.IsValidTarget(healTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            if (not CanCast("Cloak",healTarget)) then
                --DebugMessage("Can't Cast Lightning in OnEnterState")
                AI.StateMachine.ChangeState("Chase")
                return
            end
            --6DebugMessage("Attempting Cast Lightning")
            this:StopMoving()            
            this:SendMessage("CastSpellMessage","Cloak",this,healTarget)
        end,

        AiPulse = function()
            --DebugMessage("Exiting Cast Lightning")
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
            --this:SetMobileFrozen(false,false) --DFB HACK: ONLY FOR PLAYTEST
        end,
    }

AI.StateMachine.AllStates.CastAuraoffire = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Auraoffire", this)*1000 + math.random(400) end,

        OnEnterState = function()

            --pick a nearby target with the lowest health and cloak them, including me.
            --DFB TODO: Make them cloak whatever is attacking their target
            if (not CanCast("Auraoffire",this)) then
                --DebugMessage("Can't Cast Lightning in OnEnterState")
                AI.StateMachine.ChangeState("Chase")
                return
            end
            --6DebugMessage("Attempting Cast Lightning")
            this:StopMoving()            
            this:SendMessage("CastSpellMessage","Auraoffire",this,this)
        end,

        AiPulse = function()
            --DebugMessage("Exiting Cast Lightning")
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
            --this:SetMobileFrozen(false,false) --DFB HACK: ONLY FOR PLAYTEST
        end,
    }


AI.StateMachine.AllStates.CastHeal = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Heal", this)*1000 + math.random(400) end,

        OnEnterState = function()

            --pick a nearby target with the lowest health and heal it, including me.
            local friends = GetNearbyAllies(GetSpellRange("Heal",this))
            local healTarget = this
            local lowestHeal = GetCurHealth(this)
            if (friends ~= nil) then
                for i,j in pairs(friends) do
                    if (GetCurHealth(j) < GetCurHealth(this) and GetCurHealth(j)<lowestHeal) then
                        healTarget = j
                        lowestHeal = GetCurHealth(j)
                    end
                end
            end

            -- check that lowest health is worth healing            
            local HealthPercentToAllowHeal = AI.GetSetting("HealthPercentToAllowHeal") or ServerSettings.AI.Casting.HealthPercentToAllowHeal
            if ( (GetCurHealth(healTarget) / GetMaxHealth(healTarget)) > HealthPercentToAllowHeal ) then
                AI.StateMachine.ChangeState("Chase")
                -- not worth healing.
                this:RemoveTimer("CastCooldownTimer")
                return
            end

            if (healTarget ~= this) then
                FaceObject(this,healTarget)
            end

            if( healTarget ~= this and not(AI.IsValidTarget(healTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            if ((not CanCast("Heal",healTarget)) or this:DistanceFrom(healTarget) > GetSpellRange("Heal",this)+AI.GetSetting("SpellRangeMod")) then
                --DebugMessage("Can't Cast Lightning in OnEnterState")
                AI.StateMachine.ChangeState("Chase")
                return
            end
            --6DebugMessage("Attempting Cast Lightning")
            this:StopMoving()            

            this:SendMessage("CastSpellMessage","Heal",this,healTarget)
        end,

        AiPulse = function()
            --DebugMessage("Exiting Cast Lightning")
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
            --this:SetMobileFrozen(false,false) --DFB HACK: ONLY FOR PLAYTEST
        end,
    }

AI.StateMachine.AllStates.CastGreaterheal = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Greaterheal", this)*1000 + math.random(400) end,

        OnEnterState = function()

            --pick a nearby target with the lowest health and heal it, including me.
            local friends = GetNearbyAllies(GetSpellRange("Greaterheal",this))
            local healTarget = this
            local lowestHeal = GetCurHealth(this)
            if (friends ~= nil) then
                for i,j in pairs(friends) do
                    if (GetCurHealth(j) < GetCurHealth(this) and GetCurHealth(j)<lowestHeal) then
                        healTarget = j
                        lowestHeal = GetCurHealth(j)
                    end
                end
            end

            -- check that lowest health is worth healing            
            local HealthPercentToAllowHeal = AI.GetSetting("HealthPercentToAllowHeal") or ServerSettings.AI.Casting.HealthPercentToAllowHeal
            if ( (GetCurHealth(healTarget) / GetMaxHealth(healTarget)) > HealthPercentToAllowHeal ) then
                AI.StateMachine.ChangeState("Chase")
                -- not worth healing.
                this:RemoveTimer("CastCooldownTimer")
                return
            end

            if (healTarget ~= this) then
                FaceObject(this,healTarget)
            end

            if( healTarget ~= this and not(AI.IsValidTarget(healTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            if ((not CanCast("Heal",healTarget)) or this:DistanceFrom(healTarget) > GetSpellRange("Greaterheal",this)+AI.GetSetting("SpellRangeMod")) then
                --DebugMessage("Can't Cast Lightning in OnEnterState")
                AI.StateMachine.ChangeState("Chase")
                return
            end
            --6DebugMessage("Attempting Cast Lightning")
            this:StopMoving()            

            this:SendMessage("CastSpellMessage","Greaterheal",this,healTarget)
        end,

        AiPulse = function()
            --DebugMessage("Exiting Cast Lightning")
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
            --this:SetMobileFrozen(false,false) --DFB HACK: ONLY FOR PLAYTEST
        end,
    }

--Use these states for casting with AI
AI.StateMachine.AllStates.CastPillaroffire = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Pillaroffire", this)*1000 + math.random(400) end,

        OnEnterState = function()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            FaceTarget()
            if (not CanCast("Pillaroffire",AI.MainTarget)) or this:DistanceFrom(AI.MainTarget) > GetSpellRange("Pillaroffire",this)+AI.GetSetting("SpellRangeMod") then
                --DebugMessage("Can't Cast Fireball in OnEnterState")
                AI.StateMachine.ChangeState("Chase")                
                return
            end
            --DebugMessage("Attempting Cast Fireball")
            this:StopMoving()
            this:SendMessage("CastSpellMessage","Pillaroffire",this,nil,AI.MainTarget:GetLoc())
        end,

        AiPulse = function()
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
            --this:SetMobileFrozen(false,false)
        end,
    }

AI.StateMachine.AllStates.CastMeteor = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Meteor", this)*1000 + math.random(400) end,

        OnEnterState = function()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            FaceTarget()
            if (not CanCast("Meteor",AI.MainTarget)) or this:DistanceFrom(AI.MainTarget) > GetSpellRange("Meteor",this)+AI.GetSetting("SpellRangeMod") then
                --DebugMessage("Can't Cast Fireball in OnEnterState")
                AI.StateMachine.ChangeState("Chase")                
                return
            end
            --DebugMessage("Attempting Cast Fireball")
            this:StopMoving()
            this:SendMessage("CastSpellMessage","Meteor",this,nil,AI.MainTarget:GetLoc())
        end,

        AiPulse = function()
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
            --this:SetMobileFrozen(false,false)
        end,
    }

--Use these states for casting with AI
AI.StateMachine.AllStates.CastGrimaura = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Grimaura", this)*1000 + math.random(400) end,

        OnEnterState = function()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            FaceTarget()
            if (not CanCast("Grimaura",AI.MainTarget)) or this:DistanceFrom(AI.MainTarget) > GetSpellRange("Grimaura",this)+AI.GetSetting("SpellRangeMod") then
                --DebugMessage("Can't Cast Fireball in OnEnterState")
                AI.StateMachine.ChangeState("Chase")                
                return
            end
            --DebugMessage("Attempting Cast Fireball")
            this:StopMoving()
            this:SendMessage("CastSpellMessage","Grimaura",this,nil,AI.MainTarget:GetLoc())
        end,

        AiPulse = function()
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
            --this:SetMobileFrozen(false,false)
        end,
    }

--Use these states for casting with AI
AI.StateMachine.AllStates.CastIcerain = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Icerain", this)*1000 + math.random(400) end,

        OnEnterState = function()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            FaceTarget()
            if (not CanCast("Icerain",AI.MainTarget)) or this:DistanceFrom(AI.MainTarget) > GetSpellRange("Icerain",this)+AI.GetSetting("SpellRangeMod") then
                --DebugMessage("Can't Cast Fireball in OnEnterState")
                AI.StateMachine.ChangeState("Chase")                
                return
            end
            --DebugMessage("Attempting Cast Fireball")
            this:StopMoving()
            this:SendMessage("CastSpellMessage","Icerain",this,nil,AI.MainTarget:GetLoc())
        end,

        AiPulse = function()
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
            --this:SetMobileFrozen(false,false)
        end,
    }
--Use these states for casting with AI
AI.StateMachine.AllStates.CastSpikepath = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Spikepath", this)*1000 + math.random(400) end,

        OnEnterState = function()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            FaceTarget()
            if (not CanCast("Spikepath",AI.MainTarget)) or this:DistanceFrom(AI.MainTarget) > GetSpellRange("Spikepath",this)+AI.GetSetting("SpellRangeMod") then
                --DebugMessage("Can't Cast Fireball in OnEnterState")
                AI.StateMachine.ChangeState("Chase")                
                return
            end

            --DFB TODO: CHECK IF THERE ARE FRIENDLIES IN WAY

            --DebugMessage("Attempting Cast Fireball")
            this:StopMoving()
            this:SendMessage("CastSpellMessage","Spikepath",this,nil,AI.MainTarget:GetLoc())
        end,

        AiPulse = function()
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
            --this:SetMobileFrozen(false,false)
        end,
    }

--Use these states for casting with AI
AI.StateMachine.AllStates.CastFlamewave = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Flamewave", this)*1000 + math.random(400) end,

        OnEnterState = function()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            FaceTarget()
            if (not CanCast("Flamewave",AI.MainTarget)) or this:DistanceFrom(AI.MainTarget) > GetSpellRange("Flamewave",this)+AI.GetSetting("SpellRangeMod") then
                --DebugMessage("Can't Cast Fireball in OnEnterState")
                AI.StateMachine.ChangeState("Chase")                
                return
            end

            --DFB TODO: CHECK IF THERE ARE FRIENDLIES IN WAY

            --DebugMessage("Attempting Cast Fireball")
            this:StopMoving()
            this:SendMessage("CastSpellMessage","Flamewave",this,nil,AI.MainTarget:GetLoc())
        end,

        AiPulse = function()
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
            --this:SetMobileFrozen(false,false)
        end,
    }

--Use these states for casting with AI
AI.StateMachine.AllStates.CastIcelance = {
        GetPulseFrequencyMS = function() return GetSpellCastTime("Icelance", this)*1000 + math.random(400) end,

        OnEnterState = function()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            FaceTarget()
            if (not CanCast("Icelance",AI.MainTarget)) or this:DistanceFrom(AI.MainTarget) > GetSpellRange("Icelance",this)+AI.GetSetting("SpellRangeMod") then
                --DebugMessage("Can't Cast Fireball in OnEnterState")
                AI.StateMachine.ChangeState("Chase")                
                return
            end
            --DebugMessage("Attempting Cast Fireball")
            this:StopMoving()
            this:SendMessage("CastSpellMessage","Icelance",this,AI.MainTarget)
        end,

        AiPulse = function()
            DecideCombatState()
        end,

        OnExitState = function()
            this:SendMessage("CancelSpellCast")
            --this:SetMobileFrozen(false,false)
        end,
    }
availableSpellsDict = this:GetObjVar("AvailableSpellsDictionary")
if( availableSpellsDict ~= nil ) then
    for i,state in pairs(AI.CombatStateTable) do
        --DebugMessage("Evaulating state "..state.StateName)
        --remove states that the AI isn't specifically set to cast
        local canCastState = false
        --DebugMessage("Evaulating state spell"..tostring(state.StateName))
        
        if (state.Spell ~= nil and availableSpellsDict ~= nil) then
            --DebugMessage("Checking through spell "..state.Spell)
            if (availableSpellsDict[state.Spell] == nil) then
                --DebugMessage("Removing spell "..i.." from combat state table, i is "..i)
                table.remove(AI.CombatStateTable,i)
                AI.StateMachine.AllStates[state.StateName] = nil
            end
        end
    end
end

RegisterEventHandler(EventType.Message, "CastSpellMessage", 
    function(...)
        -- Set a timer to prevent spell spam
        local seconds = math.random(
                            AI.GetSetting("MinSecondsBetweenCasts") or ServerSettings.AI.Casting.MinSecondsBetweenCasts,
                            AI.GetSetting("MaxSecondsBetweenCasts") or ServerSettings.AI.Casting.MaxSecondsBetweenCasts
                        )
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(seconds), "CastCooldownTimer")
    end)