require 'ai_goon'
require 'incl_faction'
require 'incl_ai_stabled'

--Function that determine's what team I'm on. Override this for custom behaviour.
function IsFriend(target)
    if (target == nil) then
        --LuaDebugCallStack("Nil target")
        return true
    end

    --DebugMessage(1)
    if (not AI.IsValidTarget(target) and not target:HasObjVar("Invulnerable")) then
        return true
    end

    if (AI.InAggroList(target)) then
        return false
    end
    --DebugMessage(1.1)
    if (this:HasObjVar("controller")) then
        if (target:GetObjVar("controller") == this:GetObjVar("controller")) then
            return true
        end
        --DebugMessage(1.2)
        if (this:HasObjVar("HirelingOwner")) then
            if (target:GetObjVar("HirelingOwner") == this:GetObjVar("HirelingOwner")) then
                return true
            end
            --DebugMessage(1.3)
            if (target:GetObjVar("controller") == this:GetObjVar("HirelingOwner")) then
                return true
            end
            --DebugMessage(1.4)
            if (target:GetObjVar("HirelingOwner") == this:GetObjVar("controller")) then
                return true
            end
        end
        if (target == this:GetObjVar("controller")) then
            return true
        end
    elseif (target:IsPlayer()) then
        return true
    end
    --DebugMessage(1.5)
    DebugMessageA(this,"Checking if friend")
    --DebugMessage(2)
    --Override if this is my "target"
    if (this:HasObjVar("NoAggro")) then
        return true
    end
    --DebugMessage(3)

    if (not AI.GetSetting("ShouldAggro")) then
        return true
    end
    --DebugMessage(4)

    DebugMessageA(this,tostring(target))
    if (target == nil) then
        return true
    end

    local otherTeam = target:GetObjVar("MobileTeamType") 

    --DebugMessage(4)
    local superior = this:GetObjVar("controller") or this:GetObjVar("HirelingOwner")
    local myTeam = this:GetObjVar("MobileTeamType")
    if (superior ~= nil) then
    	myTeam = superior:GetObjVar("MobileTeamType")

        if (FactionExists(otherTeam) and superior:IsPlayer()) then
            if (GetFaction(superior,otherTeam) >= GetFactionMinFriendlyLevel(otherTeam)) then
                return true
            else
                return false
            end
        end
    end
    --DebugMessage(5)
    
    --DebugMessage(otherTeam)
    --DebugMessage(GetFaction(superior,otherTeam))
    
    --DebugMessage(6)
    if (this:HasObjVar("NaturalEnemy") ~= nil)  then
        if (this:GetObjVar("NaturalEnemy") == otherTeam and otherTeam ~= nil) then
            AI.AddThreat(damager,4)
            return false
        end
    end
    --DebugMessage(7)
    if ((target:GetMobileType() == "Friendly" or target:IsPlayer()) and (superior ~= nil and superior:IsPlayer()) ) then
    	return true
	else
        --DebugMessage(8)
	    if (target:GetMobileType() == "Animal" ) then --Animals don't usually attack animals          
            if (this:DistanceFrom(target) < AI.Settings.AggroRange or math.random(AI.GetSetting("AggroChanceAnimals")) == 1) then            
                --AI.AddThreat(damager,-1)--Don't aggro them
                return false
            else
                return true
            end
	    end
	    if (otherTeam == nil) then
            --DebugMessage(-1)
	        return false
	    end
	end

    return (myTeam == otherTeam) --Return true if they have the same team, false if not.
end

--Open mob window messages on interact
OverrideEventHandler("base_ai_conversation",EventType.Message,"UseObject",
	function(user,useType)
        --DebugMessage(useType)
		if (useType ~= "Interact") then return end
        --For now just do this
        --if (user == this:GetObjVar("controller")) then
        --    this:SendMessage("ForceFollow")
        --end
        local controller = this:GetObjVar("controller") or this:GetObjVar("HirelingOwner")
		if (user == controller) then
			user:SendMessage("ShowMobWindowMessage",this)
		end
	end)

function AttackEnemy(enemy,force)
    --DebugMessage("Force is "..tostring(force))
    local controller = this:GetObjVar("controller") or this:GetObjVar("HirelingOwner")
    if (enemy == controller) then
        return
    end
    --DebugMessage(-1)
    DebugMessageA(this,"Attacking object "..tostring(enemy))
    --DebugMessage("Should be attacking")
     if (enemy ~= nil and enemy:IsValid() and ((enemy:IsCloaked() and not ShouldSeeCloakedObject(this, enemy)) or (not enemy:IsMobile()))) then
         --DebugMessage("Firing")
         --perhaps they should do something more interesting
         AI.StateMachine.ChangeState("Flee")
         return
    end
    --DebugMessage(0)
    if (not AI.IsValidTarget(enemy)) then
        return
    end
    SetAITarget(enemy)
    DebugMessageA(this,"attacking enemy")
    --DebugMessage(1)
    if(IsFriend(enemy) and not force) then
        return
    end
    --DebugMessage(2)
    AI.AddThreat(enemy,2)
    RunToTarget(enemy)
    DecideCombatState()
end

AI.StateMachine.AllStates.Stay = {
        OnEnterState = function()        
        end
    }

RegisterEventHandler(EventType.Message, "UserPetCommand",
    function(args)      
        --DebugMessage("Recieved"..DumpTable(args))
        local recCmd = args.cmd
        local recArgs = args.cmdArgs
        local forceAccept = args.forceAccept or false
        local cmdInfo = defaultPetCommands[recCmd]
        if (IsDead(this)) then return end

   ---DebugMessage("Received UserPetCommand " ..tostring(recCmd))
        cmdName = recCmd
        if(IsStabled(this) and cmdName ~= "unstable") then return end

        local mMyOwner = this:GetObjVar("controller") or this:GetObjVar("HirelingOwner")
    --DebugMessage("Owner:" .. mMyOwner:GetName())
        if(cmdInfo == nil) then return end
        if this:HasTimer("FailedCommandTimeOut" ..cmdName) then
                mMyOwner:SystemMessage("[F7CC0A]" .. tostring(this:GetSharedObjectProperty("Title")) .. " is ignoring your commands.[-]","info")
                return
        end
        local myLoc = this:GetLoc()
        local ownLoc = mMyOwner:GetLoc()
        if((myLoc:Distance(ownLoc) > 10) and (this:ContainedBy() == nil)) and (cmdName ~= "summon") then
            mMyOwner:SystemMessage("[$49]")
            return
        end
    --DebugMessage("Cmd: " .. cmdName)
        if(cmdName == "attack") then
        --DebugMessage("Attacking")
            local atTarg = args.target
        --DebugMessage("Target: " ..tostring(atTarg))
            if(atTarg == nil) then
                if(recArgs == nil) then
                    mCmd = cmdName
                    mMyOwner:RequestClientTargetGameObj(this, "petCommandTarget")
                    return
                else
                --DebugMessage("attacking predef targ:" .. tostring(recArgs))
                    atTarg = GameObj(tonumber(recArgs))
                end
                if(atTarg == nil) or not atTarg:IsValid() then
                    mMyOwner:SystemMessage("[FA0C0C] Invalid Target For Pet Command.","info")
                    return
                end
            end
            if (not this:HasTimer("FollowerSkillGain") and this:GetObjVar("ControllingSkill") ~= nil) then
                mMyOwner:SendMessage("RequestSkillGainCheck", (this:GetObjVar("ControllingSkill") or "AnimalKenSkill"))
            end
            this:DelObjVar("NoAggro")
            this:ScheduleTimerDelay(TimeSpan.FromSeconds(45),"FollowerSkillGain")
            this:SendMessage("AttackEnemy",atTarg,true)
            --DebugMessage("Sent message to attack "..atTarg:GetName())
            return
        end

        if(cmdName == "follow") then
            AI.StateMachine.ChangeState("Follow")
            if (not this:HasTimer("FollowerSkillGain") and this:GetObjVar("ControllingSkill") ~= nil) then
                mMyOwner:SendMessage("RequestSkillGainCheck", (this:GetObjVar("ControllingSkill") or "AnimalKenSkill"))
            end
            this:ScheduleTimerDelay(TimeSpan.FromSeconds(45),"FollowerSkillGain")
        end
        if(cmdName == "heel") then
            this:SendMessage("EndCombatMessage")
            this:SetObjVar("NoAggro",true)
            AI.ClearAggroList()
            this:SendMessage("ClearTarget")
            CallFunctionDelayed(TimeSpan.FromSeconds(30),function() this:DelObjVar("NoAggro") end )
            AI.StateMachine.ChangeState("Follow")
            if (not this:HasTimer("FollowerSkillGain") and this:GetObjVar("ControllingSkill") ~= nil) then
                mMyOwner:SendMessage("RequestSkillGainCheck", (this:GetObjVar("ControllingSkill") or "AnimalKenSkill"))
            end
            this:ScheduleTimerDelay(TimeSpan.FromSeconds(45),"FollowerSkillGain")
        end
        if(cmdName == "stance") then
            this:SendMessage("RequestCombatStanceUpdate")
            return
        end
        if(cmdName == "stay") then
            --DebugMessage("Staying")
            this:StopMoving()
            AI.StateMachine.ChangeState("Stay")
        end
        if(cmdName == "summon") then
            BeginSummon()
        end
        if(cmdName == "feed") then
            return
        end         
end)

RegisterEventHandler(EventType.Timer, "SummonPetTimer", 
    function()
        mMyOwner = this:GetObjVar("controller") or this:GetObjVar("HirelingOwner")
        if(this:ContainedBy() ~= nil) then return end
        if not(mMyOwner:IsValid()) then return end
    --DebugMessage("Summoning Complete")
        local ownLoc = mMyOwner:GetLoc()
        this:StopEffect("SummonEffect")
        local myLoc = this:GetLoc()
        PlayEffectAtLoc("TeleportToEffect",myLoc)
        this:SetWorldPosition(ownLoc)
        PlayEffectAtLoc("TeleportFromEffect",ownLoc)
        mSummoning = false
        end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "petCommandTarget", 
    function(targ)
        SendPetCommandTo(this, mCmd, targ)
        mCmd = nil
        end)

RegisterEventHandler(EventType.Message,"ForceFollow",
function()
    if (IsDead(this)) then return end
    AI.StateMachine.ChangeState("Follow")
end)

AI.StateMachine.AllStates.Flee = {
        OnEnterState = function()
            if (IsDead(this)) then return end
            AI.StateMachine.ChangeState("Follow")
        end,
    }

RegisterEventHandler(EventType.Message,"ReassignSuperior",function(controller)
    this:SetObjVar("controller",controller)
    if (controller:HasObjVar("MobileTeamType")) then
        this:SetObjVar("MobileTeamType",controller:GetObjVar("MobileTeamType"))
    end
    if (controller:IsPlayer()) then
        ownerStr = ""..controller:GetName()..""
        this:SetMobileType("Friendly")
    else
        ownerStr = ""
        this:SetMobileType(controller:GetMobileType())
    end
    AI.Settings.CanWander = false
    AI.Settings.StartConversations = false
    this:SetName(this:GetName())
    this:SetSharedObjectProperty("Title",ownerStr)
    
    local targAgi = GetAgi(this)
    local targStr = GetStr(this)
    local targInt = GetInt(this)
    local targCon = GetCon(this)
    local targWis = GetWis(this)
    local targWill = GetWill(this)
        
    --Set the maximum amount of skill you can gain
    local skill = this:GetObjVar("ControllingSkill")
    local potency = 50
    if (skill ~= nil) then
        potency = GetSkillLevel(controller,skill)
    end
    local maxGain = math.floor((potency / 5) * 5.2)
    this:SetObjVar("AgilityStatCap", targAgi + math.floor(maxGain / 3))
    this:SetObjVar("StrengthStatCap", targStr + math.floor(maxGain / 3))
    this:SetObjVar("IntelligenceStatCap", targInt + math.floor(maxGain / 3))
    this:SetObjVar("ConstitutionStatCap", targCon + math.floor(maxGain / 3))
    this:SetObjVar("WisdomStatCap", targWis + math.floor(maxGain / 3))
    this:SetObjVar("WillStatCap", targWill + math.floor(maxGain / 3))
    this:SetObjVar("HasSkillCap",true)
end)

--Summoning (copied from pet_controller)
function InterruptSummon()
    if(mSummoning) then
        local mMyOwner = this:GetObjVar("controller")
        this:RemoveTimer("SummonTimer")  
        mMyOwner:SystemMessage("[FA0C0C] Your follower summoning was interrupted.", "info")
        mMyOwner:SendMessage("EndSummoning")
        mSummoning = false
    end
end
RegisterEventHandler(EventType.Message, "InterruptSummoning", InterruptSummon)
RegisterEventHandler(EventType.Timer, "SummonTimer", 
    function()
        local mMyOwner = this:GetObjVar("controller")
        if not(mMyOwner:IsValid()) then return end
    --DebugMessage("Summoning Complete")
        local ownLoc = mMyOwner:GetLoc()
        this:StopEffect("SummonEffect")
        local myLoc = this:GetLoc()
        PlayEffectAtLoc("TeleportToEffect",myLoc)
        this:SetWorldPosition(ownLoc)
        PlayEffectAtLoc("TeleportFromEffect",ownLoc)
        mSummoning = false
        end)

function BeginSummon()
    local mMyOwner = this:GetObjVar("controller")
    if(mMyOwner ~= nil) and mMyOwner:IsValid() then
        if(mMyOwner:IsMoving()) then
            mMyOwner:SystemMessage("[$51]","info")
            return
        end
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "SummonTimer")
        mMyOwner:SendMessage("SummoningPet", {["pet"] = this})
        mMyOwner:SystemMessage("[F7CC0A] Summoning Minion", "info")
        ProgressBar.Show{
            Label="Summoning Pet",
            Duration=10,
            TargetUser=mMyOwner
        }
        mSummoning = true
    end
end

--internal flag for followers
this:SetObjVar("IsFollower",true)

AI.Settings.Debug = false
-- set charge speed and attack range in combat ai
AI.Settings.ChargeSpeed = 4.0
AI.Settings.CanConverse = false
AI.Settings.AggroRange = 6.0
AI.Settings.ChaseRange = 10.0
AI.Settings.LeashDistance = 10
AI.Settings.CanWander = false --overridden in idle state
AI.Settings.CanUseCombatAbilities = true
AI.Settings.CanCast = true
AI.Settings.ChanceToNotAttackOnAlert = 2
