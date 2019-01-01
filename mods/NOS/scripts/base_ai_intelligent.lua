require 'default:base_ai_mob'
--require 'base_ai_conversation' --Intelligent beings converse
require 'default:incl_gametime' --Intelligent beings have an internal clock
require 'default:base_ai_casting' --intelligent beings can cast spells


--Who I'm speaking to, who I'm following, etc. 
AI.IdleTarget = nil

AI.Settings.Debug = false
AI.Settings.AggroRange = 10.0
AI.Settings.ChaseRange = 15.0
--AI.Settings.HasBeserk = false
--AI.Settings.LeashDistance = 20
AI.Settings.ScaleToAge = false
AI.Settings.CanWander = true
AI.Settings.CanUseCombatAbilities = true
AI.Settings.CanCast = true
AI.Settings.ChanceToNotAttackOnAlert = 2
AI.Settings.CanOpenDoors = true
AI.Settings.CanUseTeleporters = true

--types = nothing, pleasure, work, routine, event
AI.IdleStateTable = {
    {StateName = "Idle",Type = "nothing"},
    {StateName = "Wander",Type = "nothing"},
    --{StateName = "Sit",Type = "nothing",},
    --{StateName = "Hunt",Type = "pleasure",},
    --{StateName = "StrollGuardPath",Type = "pleasure",},
    --{StateName = "EatLunch",Type = "routine",Time = 12},
    --{StateName = "EatBreakfast",Type = "routine",Time = 9},
    --{StateName = "EatDinner",Type = "routine",Time = 16},
}

AI.StateMachine.AllStates.ChangeIdleState = {
}

--Determine if we are dumb animals or thinking machines
function ShouldThink()
    if (AI.GetSetting("CanUseCombatAbilities") or AI.GetSetting("CanCast") or AI.GetSetting("CanConverse")) then
        return true
    else
        return false
    end
end

lastDecideCall = nil
oldDecideCombatState = DecideCombatState
--------------------------------------------------------------------------------------------------------------
-- The brains of the operation. The AI literally weighs out it's options. Takes a series of values and determines the priorities of each.
--NOTE: BE CAREFUL WHERE YOU CALL THIS FUNCTION AS CALLING IT ON AN ON ENTER OR EXIT STATE CAN LEAD TO INFINITE LOOPS!!!
function DecideCombatState()

    if (this:HasObjVar("Invulnerable")) then DecideIdleState() return end

    local frameTime = ObjectFrameTimeMs()
    if(frameTime == lastDecideCall) then
        --DebugMessage("SAME FRAME")
        return
    --elseif(lastDecideCall ~= nil and frameTime - lastDecideCall < 1000) then
    --    LuaDebugCallStack("Calling DecideCombatState more than once in one second")
    end
    lastDecideCall = frameTime
        -----------------------------------------------------------------------------------------------------------------------------------
    --local start = ServerTimeMs()
    local totalLoading = ServerTimeMs()
    --DebugMessage("Got here.")
    --LuaDebugCallStack("When is this happening?:")
    if (IsDead(this)) then AI.StateMachine.ChangeState("Dead") return end
    if not(AI.IsActive()) then return end
    --DebugMessage("CHECK: ",tostring(()),tostring(CheckLeash()),tostring(AI.StateMachine.AllStates.GoHome:CanGoHome()))
    if ((CheckStrongLeash() or CheckLeash()) and AI.StateMachine.AllStates.GoHome:CanGoHome()) then
        this:ClearPathTarget()
        AI.StateMachine.ChangeState("GoHome")
        return
    end
    if (ShouldFlee() and AI.StateMachine.CurState ~= "Flee")  then
        AI.StateMachine.ChangeState("Flee")
        return
    end
    -- This forces the current state to exit before we do our evaluation
    AI.StateMachine.ChangeState("DecidingCombat") 

    if (ShouldThink() == false) then
        oldDecideCombatState()
        return
    end
    
    --yell at the other guy
    if (math.random(1,10) == 1 and AI.GetSetting("CanConverse") and CombatTalk ~= nil) then
        CombatTalk()
    end
        --DebugMessage("LoadingPart1",ServerTimeMs() - start)
        -----------------------------------------------------------------------------------------------------------------------------------
        --local start = ServerTimeMs()
    --override if leashing
    local target = FindAITarget()--if I have no targets
        --DebugMessage("FindAITarget",ServerTimeMs() - start)
        -----------------------------------------------------------------------------------------------------------------------------------
        --local start = ServerTimeMs()

    if (target ~= nil) then
        AI.LastKnownTargetPos = target:GetLoc()
    else
        AI.LastKnownTargetPos = nil
    end
        --DebugMessage("LoadingPart2",ServerTimeMs() - start)
        -----------------------------------------------------------------------------------------------------------------------------------    if (target == nil or not(target:IsValid())) then         ------------------------------------------------------------------------------------------------------------=

    if (target == nil or not(target:IsValid())) then 
        ------------------------------------------------------------------------------------------------------------=
        --local start = ServerTimeMs()
        this:ClearPathTarget()
        DecideIdleState()
        --DebugMessage("DecideIdleState",ServerTimeMs() - start)
        --------------------------------------------------------------------------------------------------------------=
        return     
    end
        --local start = ServerTimeMs()
   --DebugMessage("Got farther.")
    local mysize = GetBodySize(this)
    local theirsize = GetBodySize(target)
    local distanceFrom = target:DistanceFrom(this) 
    local weaponSkill= GetPrimaryWeaponSkill(this)
    local weaponSkillLevel= GetSkillLevel(this,weaponSkill) or 0
    local evocationSkill= GetSkillLevel(this,"Magery")
    local aggroRange = AI.GetSetting("AggroRange")
    local knownSpellList = this:GetObjVar("AvailableSpellsDictionary") or {}
    local chaseState = nil
        -----------------------------------------------------------------------------------------------------------------------------------
    --DebugMessage("LoadingPart3",ServerTimeMs() - start)
    --DebugMessage("TOTAL LOADING = ",ServerTimeMs() - totalLoading)
    --Sort through all of them, assign them an inital priority, and then add to default priority if within range
    --local start = ServerTimeMs()
    local isDamageLoc = IsDamageableLoc(AI.MainTarget:GetLoc(),this)

    --DebugMessage("DamageableLoc",ServerTimeMs() - start)
    --Sort through all of them, assign them an inital priority, and then add to default priority if within range
        -----------------------------------------------------------------------------------------------------------------------------------
    --local start = ServerTimeMs()
    --start weighting my options
    for i,state in pairs(AI.CombatStateTable) do
        state.Priority = math.random(3,5)
        if  (state.Priority > 0 and state.Type == "Chase") then
            chaseState = state
        end
        if (state.Priority > 0 and distanceFrom <= state.Range and state.Type ~= "flee")  then
            state.Priority = 5
            --DebugMessage("Change Priority of " ..  tostring(state.Type) .. " to " .. tostring(state.Priority) .. "at line"  .. 448)
            --DebugMessage("Priority: Within Range "..  this:GetName())
            onewithinrange = true
        end
        --If I have no weapons and I'm a mage,
        --if (this:GetEquippedObject("LeftHand") == nil and this:GetEquippedObject("RightHand") == nil and state.Type == "melee") then
        --    state.Priority = state.Priority - 2
        --    --DebugMessage("Priority: No weapons "..  this:GetName())
        --reduce the priority for melee
        --end
        --If I can't flee then don't flee
        if (state.Priority > 0 and state.Spell ~= nil) then
            if (state.Priority > 0 and (state.Type == "offensivespell" or state.Type == "buffspell") and (not(AI.GetSetting("CanCast") or not CanCast(state.Spell,target)))  ) then
                --DebugMessage("Priority: Cannot Cast Spell from "..  this:GetName())
                state.Priority = -100
                --DebugMessage("Change Priority of " ..  tostring(state.Type) .. " to " .. tostring(state.Priority) .. "at line"  .. 457)
                --remove spells
            end
        end
        if (state.Priority > 0 and (state.Type == "melee" or state.Type == "chase") and AI.GetSetting("NoMelee")) then
            state.Priority = -100
        end

        if (state.Priority > 0 and (state.StateName == "Alert") and AI.Settings.ChanceToNotAttackOnAlert == 1) then
            state.Priority = -100
        end

        if (state.Priority > 0 and state.Type == "flee" and AI.GetSetting("CanFlee") == false) then
            state.Priority = -100
            --DebugMessage("Change Priority of " ..  tostring(state.Type) .. " to " .. tostring(state.Priority) .. "at line"  .. 483)
        end
        --If I can't talk then don't taunt
        if (state.Priority > 0 and state.StateName == "Taunt" and AI.GetSetting("CanConverse") == false) then
            state.Priority = -100
            --DebugMessage("Change Priority of " ..  tostring(state.Type) .. " to " .. tostring(state.Priority) .. "at line"  .. 488)
        end

        --Animals don't have combat abilities
        if (state.Priority > 0 and state.StateName == "AttackAbility" and AI.GetSetting("CanUseCombatAbilities") ~= true and not( this:HasObjVar("CombatAbilities") or this:HasObjVar("WeaponAbilities") )) then
            state.Priority = -100
            --DebugMessage("Change Priority of " ..  tostring(state.Type) .. " to " .. tostring(state.Priority) .. "at line"  .. 488)
        end
        if (state.Priority > 0 and state.Spell ~= nil) then
            local iHaveIt = knownSpellList[state.Spell]
            if (not iHaveIt) then
                state.Priority = -100
            end
            if (this:HasTimer("CastCooldownTimer")) then
                state.Priority = -100

            end
        end
        if (state.Priority > 0) then

            --if I shouldn't flee, don't.
            if (state.Type == "flee" and not ShouldFlee()) then
                state.Priority = state.Priority - math.random(0,4)
            end

             --if they flee, howl or taunt
            if (AI.LastTargetDistance ~= nil) then
               if (distanceFrom > aggroRange 
                        and AI.LastTargetDistance < distanceFrom 
                        and state.Type == "offensivenoncombat") then
                    state.Priority = state.Priority + math.random(0,8)
                --DebugMessage("Change Priority of " ..  tostring(state.Type) .. " to " .. tostring(state.Priority) .. "at line"  .. 505)
                end
            --increase chance to taunt if we've been fighting for a while or we just started fighting
            elseif (state.Type == "offensivenoncombat") then
                if (AI.Anger > 15  or AI.Anger < 5) then
                    state.Priority = state.Priority + math.random(0,8)
                    --DebugMessage("Change Priority of " ..  tostring(state.Type) .. " to " .. tostring(state.Priority) .. "at line"  .. 512)
                end
            end

            --Add priority if within range in general
            if (distanceFrom <= state.Range and state.Type ~= "flee") then
                state.Priority = state.Priority + math.random(0,1)
                --DebugMessage("Change Priority of " ..  tostring(state.Type) .. " to " .. tostring(state.Priority) .. "at line"  .. 520)
            elseif (state.Type == "chase") then
                state.Priority = state.Priority + math.random(0,4)
                --DebugMessage("Change Priority of " ..  tostring(state.Type) .. " to " .. tostring(state.Priority) .. "at line"  .. 523)
            end
            --DebugMessage("Priority: Within Range "..  this:GetName())
            --Add priority to howl and beserk if enraged
            --I will act irrationally if I am angry, howling or taunting
            if (state.Type == "offensivenoncombat" and AI.Anger > 20) then
                state.Priority =  state.Priority + math.random(0,2)
                --DebugMessage("Change Priority of " ..  tostring(state.Type) .. " to " .. tostring(state.Priority) .. "at line"  .. 529)
                --DebugMessage("Priority: Non Combat "..  this:GetName())
            --Engraged NPCS should melee
            elseif (state.Type == "melee" or state.Type == "rangedattack" and AI.Anger > 30) then
                state.Priority =  state.Priority + math.random(0,4)
                --DebugMessage("Change Priority of " ..  tostring(state.Type) .. " to " .. tostring(state.Priority) .. "at line"  .. 533)
                 --DebugMessage("Priority: Melee "..  this:GetName())
            end
            --if outside aggro range and chase state then increase chances of picking that.
            if (state.StateName == "Chase" and distanceFrom > aggroRange) then
                state.Priority = state.Priority + math.random(0,4)
            end
            --add priority to ranged attacks if outside of aggro range
            if (state.Type == "rangedattack" and distanceFrom > aggroRange) then
                state.Priority = state.Priority + math.random(0,6)
            end
                --if within range of a ranged attack then add
            if (state.Type == "rangedattack" and distanceFrom > state.Range) then
                state.Priority = state.Priority + math.random(0,4)
            end
             --Reduce priority if opponent is way too close
            if (state.Type ~= "melee" and distanceFrom < aggroRange/2 ) then
                if (ShouldFlee()  and state.Type == "flee") then
                    --DebugMessage("should flee in  1/2 of aggro")
                    state.Priority = state.Priority + math.random(0,4)
                    --DebugMessage("Change Priority of " ..  tostring(state.Type) .. " to " .. tostring(state.Priority) .. "at line"  .. 546)
                elseif (state.type == "flee") then
                    state.Priority = state.Priority - math.random(0,5) --Don't flee unless we have to
                    --DebugMessage("Change Priority of " ..  tostring(state.Type) .. " to " .. tostring(state.Priority) .. "at line"  .. 549)
                end
                state.Priority = state.Priority - math.random(0,2)
                --DebugMessage("Change Priority of " ..  tostring(state.Type) .. " to " .. tostring(state.Priority) .. "at line"  .. 552)
                --DebugMessage("Priority: Reduce Non Aggro Melee "..  this:GetName())
            end

            --DebugMessage("Priority: Aggro Melee base"..  this:GetName())
            if (distanceFrom < aggroRange/3) then
                if (evocationSkill <= weaponSkillLevel) then
                    state.Priority = state.Priority  + math.random(0,4)
                    --DebugMessage("Change Priority of " ..  tostring(state.Type) .. " to " .. tostring(state.Priority) .. "at line"  .. 560)
                end
                --if (this:GetEquippedObject("LeftHand") == nil and this:GetEquippedObject("RightHand") == nil and state.Type == "flee") then
                --state.Priority = state.Priority + 4
                --If we're hurt, increase chance of flee further
                if (state.Type == "flee" ) then
                    if(ShouldFlee()) then
                        --DebugMessage("Should flee within 1/3 of aggro")
                        state.Priority = state.Priority  + math.random(0,4)
                        --DebugMessage("Change Priority of " ..  tostring(state.Type) .. " to " .. tostring(state.Priority) .. "at line"  .. 568)
                    else
                        state.Priority = state.Priority  - math.random(0,4)
                        --DebugMessage("Change Priority of " ..  tostring(state.Type) .. " to " .. tostring(state.Priority) .. "at line"  .. 573)
                    end
                end
                    --melee opponents if they get too close
                if (state.Type == "melee") then
                    state.Priority = state.Priority  + math.random(0,4)
                    --DebugMessage("Change Priority of " ..  tostring(state.Type) .. " to " .. tostring(state.Priority) .. "at line"  .. 577)
                end
                    --DebugMessage("Priority: Add Superclose Melee "..  this:GetName())                    
            end

                -- DFB HACK - This is a dirty hack and should be fixed some other way
                --If outside range of a spell chase
            if (distanceFrom > state.Range and chaseState ~= nil) then
                chasestate.Priority = chasestate.Priority + math.random(0,4)
                --DebugMessage("Change Priority of " ..  tostring(state.Type) .. " to " .. tostring(state.Priority) .. "at line"  .. 585)
            end

            if (state.Type == "melee" or state.Type == "chase") and isDamageLoc then
                state.Priority = state.Priority - 10
                if (AI.Anger > 75) then
                    state.Priority = state.Priority + 5
                end
            end

            if (state.Type == "wait" and isDamageLoc) then
                state.Priority = state.Priority + math.random(3,5)
            end

            if (state.Type == "resurrectspell") then
                --DebugMessage(#GetNearbyDeadMobiles())
                if (AI.Anger < 30) then
                    if (#GetNearbyDeadMobiles() > 0) then
                        state.Priority = state.Priority + math.random(0,4)
                        if (#GetNearbyAllies(6,true) > 0) then
                            state.Priority = state.Priority + math.random(0,6)
                        end
                    end
                end
                    --DebugMessage(#GetNearbyAllies(6,true))
            end
                    --Add priority to spells if they are available
            if(state.Type == "healspell" and CanCast(state.Spell,target)) then
                state.Priority = state.Priority + math.random(0,6)
                local manifestationSkill= GetSkillLevel(this,"Magery")
                if (manifestationSkill > weaponSkillLevel and distanceFrom <= state.Range) then
                    --DebugMessage("Change Priority of " ..  tostring(state.Type) .. " to " .. tostring(state.Priority) .. "at line"  .. 593)
                    state.Priority = state.Priority  + math.random(1,3)
                end
            end

            if (state.Type == "offensivespell" and CanCast(state.Spell,target)) then
                state.Priority = state.Priority + math.random(0,6)
                 --DebugMessage("Change Priority of " ..  tostring(state.Type) .. " to " .. tostring(state.Priority) .. "at line"  .. 590)
                --DebugMessage("Priority: Add Spells "..  this:GetName())
                if (evocationSkill > weaponSkillLevel and distanceFrom <= state.Range) then
                    --DebugMessage("Change Priority of " ..  tostring(state.Type) .. " to " .. tostring(state.Priority) .. "at line"  .. 593)
                    state.Priority = state.Priority  + math.random(1,3)
                end
            end
        end
    end
    --DebugMessage("LogicCore",ServerTimeMs() - start)
    --local start = ServerTimeMs()
    getHighestPriority(AI.CombatStateTable,target)
    --DebugMessage("HighestPriority",ServerTimeMs() - start)
end

--decide what the mobile is going to do
function DecideIdleState()
    --DebugMessage("Resetting chase time C")
    if (IsDead(this)) then AI.StateMachine.ChangeState("Dead") return end
    if not(AI.IsActive()) then return end

    if (IsInCombat(this)) then
        this:SendMessage("EndCombatMessage")
    end

    --DebugMessage("HERE"..tostring(this:GetName()))
    --CheckViewMobs()
    if ((CheckStrongLeash() or CheckLeash()) and AI.StateMachine.AllStates.GoHome:CanGoHome()) then
        --DebugMessage("NOW HERE"..tostring(this:GetName()))
        AI.StateMachine.ChangeState("GoHome")
        return
    end
    --if we can talk do so.
    if (AI.GetSetting("CanConverse") == true) then
        --Idle conversations
        if (math.random(1,5) == 1 and ReceivedSpeech == nil) then
            --Pick someone to talk to if I'm idle
            local friendlies = GetNearbyFriends(AI.GetSetting("AggroRange"))
            if (friendlies ~= nil and #friendlies ~= 0) then
                local friend = math.random(1,#friendlies)
                local friendToTalkTo = friendlies[friend]     
                if (InitiateConversation == nil) then
                    DebugMessage(this:GetName().." can converse but does not have a base_ai_conversation module!")
                    return
                end           
                InitiateConversation(friendToTalkTo,false)
                return                   
            end
        end
    end

    for i,state in pairs(AI.IdleStateTable) do
        state.Priority = math.random(3,5)
        --If it's a routine 
        --if (AI.StateMachine.CurState == state.Name) then
        --    state.Priority = -100
        --end        

        if (state.Time ~= nil and state.Duration ~= nil) then
            --Do things if it's time to do them
            shouldExecuteState = InGameTimeSpan(state.Time,state.Time + state.Duration)

            if ((shouldExecuteState == true)) then
                state.Priority = state.Priority + 100
                --DebugMessage("Adding 100 priority to "..state.StateName)
            else
                state.Priority = -100  --don't worry about it
                --DebugMessage("Ignoring routine "..state.StateName)
            end

        elseif state.Time ~= nil then
            --NOTE: NOT SPECIFIYING A DURATION MAKES THEM OCCUR ONLY ONCE A DAY

            --set new events for a new day
            if (GetGameTimeOfDay() < state.Time and state.LastExecutionTime ~= nil ) then
                state.LastExecutionTime = nil
                this:SetObjVar("LastExecutionTime",state.LastExecutionTime)
            end

            if (GetGameTimeOfDay() >= state.Time and (lastExecutionTime ~= nil)) then
                state.Priority = state.Priority + 100
                DebugMessageA(this,"Adding 100 priority to "..state.StateName)
            else
                state.Priority = -100  --don't worry about it
                DebugMessageA(this,"Ignoring routine "..state.StateName)
            end
        end

        if (state.Name == "Idle") then
            state.Priority = state.Priority - math.random(0,3)
            --DebugMessage("Adding 2 priority to "..state.StateName)
        end

        --do fun things before I get bored.
        if (state.Type == "pleasure" ) then--and state.LastExecutionTime ~= nil) then
            state.Priority = state.Priority + math.random(0,2)
            --DebugMessage("Adding 2 priority to "..state.StateName)
        end
        -- increase chance that i will work
        if(state.Type == "routine") then
            state.Priority = state.Priority + math.random(0,10)
        end
        --Don't wander if we can't.
        if (state.StateName  == "Wander" and AI.GetSetting("CanWander") == false) then
            state.Priority = -100
        end           
    end
    local chosenState = getHighestPriority(AI.IdleStateTable,target)
    --this:NpcSpeech("[f70a79]*"..tostring(chosenState).."!*[-]")
    --This state is being done, so remember not to do it again today
    for i,state in pairs(AI.IdleStateTable) do
        if state.StateName == chosenState then
            state.LastExecutionTime = GetCurrentTimeOfDay()
            --this:SetObjVar("LastExecutionTime",state.LastExecutionTime)
        end
    end
end

--returns the highest priority from the given decidecombatstate table
function getHighestPriority(StateTable,target)
    --Sort by highest priority
    GetHighestPriority = 
        function()
            local highestpriority = 0
            local nextstate = "Idle" --If we're going into idle during combat this is an error
            local stateTableChoices = {}
            --get highest priority
            for i,state in pairs(StateTable) do
                if (highestpriority < state.Priority ) then
                    highestpriority = state.Priority
                end
            DebugMessageA(this,"State " .. state.StateName ..  " Has Priority of  " .. state.Priority)
            end
            --get all avaliable choices
            for i,state in pairs(StateTable) do
                if (state.Priority == highestpriority) then
                    table.insert(stateTableChoices,state.StateName)
                end
            end
            --pick one at random if they have the same priority
            if (#stateTableChoices > 0) then
                local choice = math.random(1,#stateTableChoices)
                nextstate = stateTableChoices[choice]
            end
            DebugMessageA(this,"State chosen is  " .. nextstate)
            return nextstate
        end

    --Do the action with the highest priority
    local chosenState = GetHighestPriority()
    if AI.StateMachine.AllStates[chosenState] ~= nil then
        if (AI.StateMachine.AllStates[chosenState].RepeatState == true) then
            AI.StateMachine.ChangeState("ChangeIdleState")
        end
    else
        LuaDebugCallStack("[base_ai_intelligent]ERROR: CHOSEN AI STATE DOES NOT EXIST IN "..this:GetName().." chosenState: "..chosenState)
    end
    AI.StateMachine.ChangeState(chosenState)
    if (target ~= nil) then
        AI.LastTargetDistance = target:DistanceFrom(this)
    end
    return chosenState
    --set to check next time to see if enemy is fleeing
    --TODO: 
    --Add priority if within range but outside of opponents range
    --Add priority to hesitation if not enraged
    --Add priority to melee if I have them
    --if ally nearby is damaged, add priority to heal
    --if I'm damaged severly, add priority to heal
    --reduce priority to heal if i'm in melee
end

------------------------------------------------------------------------------------------------------------------  