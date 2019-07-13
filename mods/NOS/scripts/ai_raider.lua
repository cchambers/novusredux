require 'NOS:ai_default_human'
require 'NOS:incl_faction'

AI.Settings.SpeechTable = "Nomad"
AI.Settings.Debug = false
AI.Settings.AggroRange = 10.0
AI.Settings.ChaseRange = 15.0
AI.Settings.LeashDistance = 20
AI.Settings.CanConverse = true
AI.Settings.ScaleToAge = false
AI.Settings.CanWander = false
AI.Settings.CanUseCombatAbilities = true
AI.Settings.Leash = true
AI.Settings.CanCast = true
AI.Settings.ChanceToNotAttackOnAlert = 2
AI.Settings.SpeechTable = "Nomad"

RegisterEventHandler(EventType.Message, "DamageInflicted",
    function (damager)
        if AI.IsValidTarget(damager) then
        if (IsFriend(attacker) and AI.Anger < 100) then return end
            local myTeamType = this:GetObjVar("MobileTeamType")
            local nearbyTeamMembers = FindObjects(SearchMulti(
            {
                SearchMobileInRange(20), --in 10 units
                SearchObjVar("MobileTeamType",myTeamType), --find others with my team type
            }))
            for i,j in pairs (nearbyTeamMembers) do
                j:SendMessage("AttackEnemy",damager) --defend me
            end
        end

        if (damager ~= nil and damager:IsValid()) then
            local targetFaction = GetFaction(alertTarget,this:GetObjVar("MobileTeamType")) 

            if (targetFaction == nil) then targetFaction = 0 end
     

            --bottoms out at -30
            if (targetFaction < -30) then
                targetFaction = -30
            end
            DebugMessageA(this,"ClanFavorability is "..targetFaction)
            ChangeFactionByAmount(damager,-4,this:GetObjVar("MobileTeamType"))
        end
    end)


AI.StateMachine.AllStates.Alert = {       
        OnEnterState = function() 
            this:PlayAnimation("alarmed")
            
            alertTarget = FindAITarget()
            if( alertTarget == nil ) then
               DebugMessageA(this,"Changing to idle from alert")
                AI.StateMachine.ChangeState("Idle")
            else
                FaceObject(this,alertTarget)
            end
            ----AI.StateMachine.--DebugMessage("ENTER ALERT")
        end,

        GetPulseFrequencyMS = function() return 1700 end,

        AiPulse = function()    
            --AI.StateMachine.--DebugMessage("Alert pulse")
            --this:NpcSpeech("[f70a79]*Alert!*[-]")
            alertTarget = FindAITarget()
            if( alertTarget == nil ) then
               DebugMessageA(this,"Changing to idle from alert")
                AI.StateMachine.ChangeState("Idle")
            else
                FaceObject(this,alertTarget)
                --We found a new mobile, handle it
                if (not IsFriend(alertTarget) and ((not alertTarget:IsPlayer()) or GetFaction(alertTarget) < 0)) then
                    if (math.random(1,AI.GetSetting("ChanceToNotAttackOnAlert")) == 1  or alertTarget:DistanceFrom(this) < AI.GetSetting("AggroRange")) then
                         AttackEnemy(alertTarget)
                    end
                else
                    HaltPlayer(alertTarget)
                end 
            end
        end,
    }

AI.StateMachine.AllStates.AwaitResponse = {   
        GetPulseFrequencyMS = function() return 5000 end,

        OnEnterState = function()
        end,

        AiPulse = function()   
            if (mPlayer ~= nil) then
                FaceObject(this,FineTarget)
            else    
                AI.StateMachine.ChangeState("Idle")
            end
        end,

}

function HaltPlayer(target)
    if (target == nil or not target:IsValid() or not target:IsPlayer()) then return end
    target:SendMessage("StartQuest","OutlandsRebelQuest")
    AI.StateMachine.ChangeState("AwaitResponse")
    this:PathToTarget(target,4.0,4)
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(45),"attack_timer",target)
    mPlayer = target
    local coins = CountCoins(target)

    this:SendMessage("AttackTarget",nil)

    text = "Who is you ... to enter our lands!"

    response = {}
    
    response[1] = {}
    response[1].text = "My name is "..target:GetName()
    response[1].handle = "ExplainFaction" 

    response[2] = {}
    response[2].text = "Who's asking?"
    response[2].handle = "Explain" 

    response[3] = {}
    response[3].text = "Whoever you are, prepare to die!"
    --if (math.random(1,300) == 1) then response[2].text = "Fuck you, asshole!" end
    response[3].handle = "Fight" 

    --response[3] = {}
    --response[3].text = "Need a job?"
    --response[3].handle = "Hire" 

    NPCInteraction(text,this,mPlayer,"Confront",response,nil,20)
end


RegisterEventHandler(EventType.DynamicWindowResponse, "Confront",
    function (user,buttonId)
        this:RemoveTimer("attack_timer")
	    this:StopMoving()
        if (user == nil) then return end
        if (buttonId == "Fight") then 
            this:FireTimer("attack_timer",user)
        elseif (buttonId == "TellOthers") then
        elseif (buttonId == "Suave") then
	        AI.StateMachine.ChangeState("Idle")
            this:NpcSpeech("A friend of the clan indeed...")
        elseif (buttonId == "Explain") then
        	--if I have faction
        		--Throw up a dialog
        	--otherwise
        		--warn them away
        	this:NpcSpeech("LEAVE! Leave NOW!")

        elseif (buttonId == "ExplainFaction") then
            --if I have faction
        		--Throw up a dialog
        	--otherwise
        		--warn them away
        	this:NpcSpeech("We don't care ... LEAVE!")
            
        end
    end)

function AttackPlayer(player)
    player:CloseDynamicWindow("Confront")
    ChangeFactionByAmount(player,-4,this:GetObjVar("MobileTeamType"))
    this:SendMessage("AttackEnemy",player)
    local nearbyRebels = FindObjects(SearchMulti(
    {
        SearchMobileInRange(20), --in 10 units
        SearchObjVar("MobileTeamType","Rebels"), --find slaver guards
    }))
    for i,j in pairs (nearbyRebels) do
        j:SendMessage("AttackEnemy",player) --defend me
    end
    player = nil
end

RegisterEventHandler(EventType.Timer, "attack_timer", 
    function (player)
        if (mPlayer ~= nil) then
            this:NpcSpeech("Kill him!")
            AttackPlayer(player)
        end
    end)

function HandleMobEnterView(mobileObj,ignoreVision,forceAttack)
    --DebugMessage("---------------------------")
    --DebugMessage(mobileObj:GetName().." entered view ")
    if (ignoreVision == nil) then ignoreVision = false end
    if not(AI.IsActive()) then return end

    if (not AI.IsValidTarget(mobileObj)) then 
        return 
    end
    DebugMessageA(this,mobileObj:GetName() .." entered range")
    DebugMessageA(this,"Main target is "..tostring(AI.MainTarget).." and not IsFriend is "..tostring(mobileObj))
    local isFriend = IsFriend(mobileObj)
    if (forceAttack) then
        isFriend = false
    end
    DebugMessageA(this,"IsFriend is "..tostring(isFriend))
    DebugMessageA(this,"MainTarget is "..tostring(AI.MainTarget).." mobileObj is "..tostring(mobileObj))
    if (not isFriend) then
        AI.AddToAggroList(mobileObj,2)
       --DebugMessage(4)
        if (forceAttack and ( ((not mobileObj:IsPlayer()) or mobileObj:HasObjVar("MetRebels")))) then
            this:SendMessage("AttackEnemy",mobileObj,true)  
        else
            --DebugMessage("entering alert")
            AI.StateMachine.ChangeState("Alert")   
        end         
        DebugMessageA(this,"ChangingToAlert")
    end
end
--Function that determine's what team I'm on. Override this for custom behaviour.
function IsFriend(target)
    if (not AI.IsValidTarget(target)) then return false end
    if (target == nil) then
        DebugMessage("[ai_villager|IsFriend] ERROR: target is nil")
        return true
    end
    local otherTeam = target:GetObjVar("MobileTeamType")
    local myTeam = this:GetObjVar("MobileTeamType")


    if (AI.InAggroList(target)) then
        return false
    end
    if (target:IsPlayer()) then 
        local targetFaction = GetFaction(target,this:GetObjVar("MobileTeamType"))
        if (targetFaction < 10) then return false end
    end
    --Override if this is my "target"
    
    DebugMessageA(this,tostring(target))
    if (target == nil) then
        return true
    end

    if (myTeam == nil) then --If I have no team, then attack nobody in this case.
        DebugMessageA(this,"NO TEAM")
        return true
    end

    if (this:HasObjVar("NaturalEnemy") ~= nil)  then
        if (this:GetObjVar("NaturalEnemy") == otherTeam and otherTeam ~= nil) then
            return false
        end
    end

    if (target:GetMobileType() == "Animal" ) then --Animals don't usually attack animals
        if (this:DistanceFrom(target) < AI.Settings.AggroRange or math.random(AI.GetSetting("AggroChanceAnimals")) == 1) then            
            --AI.AddThreat(damager,-1)--Don't aggro them
            return (myTeam == otherTeam) 
        else
            return true
        end
    end
    if (otherTeam == nil) then
        return true
    end

    return (myTeam == otherTeam) --Return true if they have the same team, false if not.
end