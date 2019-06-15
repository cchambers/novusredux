require 'base_ai_mob'
require 'incl_regions'
require 'incl_run_path'

AI.Settings.Debug = false
AI.Settings.MaxAgeScale = 1.1 --Maximum scale that a mob can age.
AI.Settings.ChaseRange = 8
MAX_PACK_SIZE = 3
--DFB TODO: MAKE WOLFS STOP AND HOWL

function GetAlpha(wolf)

    if (wolf == nil) then
        wolf = this
    end

    if (wolf:HasObjVar("MySuperior")) then
        superior = wolf
        local i = 0
        while (superior:HasObjVar("MySuperior") and i < 4) do
            superior = superior:GetObjVar("MySuperior")
            i = i + 1
        end
        return superior
    else
        return wolf
    end
end

IsAlpha = false
function GenerateName()
    local TemplateName = this:GetObjVar("TemplateName")

    if (not this:HasObjVar("MySuperior") and IsAlpha) then
        TemplateName = ("Alpha " .. TemplateName)
    end

    local newName = nil
    local age = AI.GetSetting("Age")
    if (age < 6) then
        newName = "Young " .. TemplateName
    elseif  (age <= 13) then
        newName = TemplateName
    elseif  (age <= 30) then
        newName = "Old " .. TemplateName
    else
        newName = "Elder " .. TemplateName
    end
    this:SetName(newName)
    this:SendMessage("UpdateName")
end

AI.StateMachine.AllStates.Idle = {   
    GetPulseFrequencyMS = function() return 1000 end,

    OnEnterState = function ()
        this:StopMoving()
    end,

    AiPulse = function()
    --DebugMessage("Idle pulse")        

    	--Follow mom
        local packleader = this:GetObjVar("MySuperior")
        if( packleader ~= nil and packleader:IsValid() ) then
            AI.StateMachine.ChangeState("Wander")
        elseif math.random(AI.GetSetting("WanderChance")) <= 1 and AI.GetSetting("CanWander") == true then 
            AI.StateMachine.ChangeState("Wander")
        end
    end,
}

following = nil

AI.StateMachine.AllStates.Howl  = {
        GetPulseFrequencyMS = function() return 1500 end,
        
        OnEnterState = function()
            this:StopMoving()
            this:PlayAnimation("howl")
            this:PlayObjectSound("WolfEnvironment2")    
        end,

        AiPulse = function()
            this:PlayAnimation("idle")
            if (AI.MainTarget == nil) then
                AI.StateMachine.ChangeState("Idle")
            else
                DecideCombatState()
            end
        end,
    }


AI.StateMachine.AllStates.Wander = {
    GetPulseFrequencyMS = function() return 5000 end,

    OnEnterState = function()
       --DebugMessage("Wander start")
    end,

    AiPulse = function()
        --D*ebugMessage("Idle pulse")        
        --if( following ~= nil ) then
            --local superior = this:GetObjVar("MySuperior")
            --if( following ~= superior ) then
            --    AI.StateMachine.ChangeState("Idle")
           -- end
        --end       

        local superior = this:GetObjVar("MySuperior")
        if (superior ~= nil) then
            following = superior
            this:PathToTarget(superior,3,1.0)
        else
            --WanderInRegion(homeRegion,"Wander")
            local homeRegion = this:GetObjVar("homeRegion")
            local wolves = FindObjects(SearchMulti(
            {
                SearchMobileInRange(30), --in 30 units
                SearchObjVar("IsAlpha",true), --find alphas
                SearchMobileInRegion(homeRegion), --in my region
                SearchModule("ai_wolf"), --that are wolves
            }))
            if (this:GetObjVar("IsAlpha") ~= true) then
                if (wolves ~= nil) then
                    for i,j in pairs(wolves) do
                        if (j ~= nil and j:IsValid()) then
                            local isFull = j:GetObjVar("PackFull")
                            if (isFull == false) then
                                WanderTowards(j:GetLoc(),30,1.0,"findotherwolves")
                                return
                            end
                        end
                    end
                end
            end

            --otherwise go to a random area in the region
            WanderInRegion(homeRegion,"Wander")
        end
    end,

    OnExitState = function()
        following = nil
    end,
}

RegisterEventHandler(EventType.Arrived, "Wander",
    function ( ... )
        if( AI.StateMachine.CurState == "Wander" ) then
            AI.StateMachine.ChangeState("Idle")
        end
    end)

RegisterEventHandler(EventType.EnterView, "chaseRange", 
    function (otherObj)
        
    if (IsDead(this)) then AI.StateMachine.ChangeState("Dead") return end
    if not(AI.IsActive()) then return end

    	if( otherObj ~= nil and AI.IsValidTarget(otherObj) and otherObj:GetObjVar("MobileTeamType") == "Wolves") then 

            if (this:IsInRegion("GreatTreeArea") or this:HasObjVar("MyPath")) then
                return
            end

            local myWolfList = this:GetObjVar("WolfList")
                --DebugMessage(tostring(this:GetObjVar("WolfList")))
            if (myWolfList ~= nil) then

                if (this:GetObjVar("IsAlpha") ~= true) then
                    this:SetName("Alpha "..this:GetObjVar("TemplateName"))
                    this:SendMessage("UpdateName")
                    this:SetObjVar("IsAlpha",true)
                end

                for i,j in pairs(myWolfList) do --remove dead or invalid wolves
                    if (not j:IsValid() or IsDead(j)) then
                        RemoveFromArray(myWolfList,j)
                    end
                end
                if (#myWolfList >= MAX_PACK_SIZE) then
                    this:SetObjVar("PackFull",true)
                    --this:NpcSpeech("My pack is full")
                    return
                else
                    this:DelObjVar("PackFull")
                end
            end
 
            local thisSuperior = this:GetObjVar("MySuperior")
            local theirSuperior = otherObj:GetObjVar("MySuperior")
            local thisPackIsFull = this:HasObjVar("PackFull")
            local theirPackIsFull = otherObj:HasObjVar("PackFull")
            local otherIsAlpha = otherObj:GetObjVar("IsAlpha")
            local otherAge = otherObj:GetObjVar("AI-Age")
            if (otherAge == nil) then otherAge = 10 end 
            local myDominance = AI.GetSetting("Age") + this:GetScale().X*10 + (GetCurHealth(this)/GetMaxHealth(this))*10
            local otherDominance = otherAge + otherObj:GetScale().X*10 + (GetCurHealth(otherObj)/GetMaxHealth(otherObj))*10
            
            --if my pack is full do nothing
            if (thisPackIsFull) then
                return
            end

            --if it's a lone wolf and I am a worthless beta then do nothing
            if (thisSuperior ~= nil) then
                if (theirSuperior == nil and otherIsAlpha ~= true) then
                    return
                end
            end
            --if thier pack if full and I can't best him do nothing
            if (theirPackIsFull) then
                if (otherIsAlpha == true and myDominance < otherDominance) then
                    return
                end
            end

            --if they are a beta then do nothing
            if (theirSuperior ~= nil) then
                return
            end

			--Found another wolf  
            --DebugMessage("-----------------------------------------")
            --DebugMessage("I am "..tostring(this))
            --DebugMessage("MySuperior is " .. tostring(this:GetObjVar("MySuperior"))) 
            --DebugMessage("And my dominance is " .. myDominance  .. ", His Dominance is " .. otherDominance) 
            --DebugMessage("theirSuperior is " .. tostring(theirSuperior) ) 

            if( myDominance == nil or otherDominance == nil ) then return end
            --if I anm bigger than them, and they are an alpha then
			if (myDominance > otherDominance) then

                if (otherIsAlpha) then
                    this:DelObjVar("MySuperior")
                    AttackEnemy(otherObj)
                end
            --I am weaker, they are my alpha
            elseif (myDominance  < otherDominance) then

                --DebugMessage("I have a new superior "..tostring(otherObj.Id))

               --remove from the current alpha
                local currentAlpha = GetAlpha()
                local alphaList = currentAlpha:GetObjVar("WolfList")

                --remove me from my current alpha's list
                if (alphaList ~= nil) then
                    RemoveFromArray(alphaList,this)
                    currentAlpha:SetObjVar("WolfList",alphaList)
                end

                --get the new alpha's list
                local alpha = GetAlpha(otherObj)
                alphaList = alpha:GetObjVar("WolfList") or {}                

                --add all the wolves in my list to the alpha's list, 
                if (myWolfList ~= nil) then
                    for i,j in pairs(myWolfList) do
                        if(j~= nil and j:IsValid()) then
                            if (#alphaList + 1 <= MAX_PACK_SIZE) then
                                j:SetObjVar("MySuperior",alpha)--setting their superior to the new alpha
                                table.insert(alphaList,j)
                            else --the pack is too large, shed my subordinates
                                j:DelObjVar("MySuperior")--they become lone wolves if this happens
                                if (j:HasObjVar("TemplateName")) then
                                    j:SetName("Lone "..j:GetObjVar("TemplateName"))
                                    j:SendMessage("UpdateName")
                                end
                                j:DelObjVar("IsAlpha")
                            end
                        end
                    end
                end
                --add me to the new alpha's list
                table.insert(alphaList,this)
                alpha:SetObjVar("WolfList",alphaList)

                --My dominance is lower so make me teh beta
                this:SetObjVar("MySuperior",alpha)
                this:DelObjVar("WolfList")
                this:SetName(this:GetObjVar("TemplateName"))
				this:SendMessage("UpdateName")

                --determine that I am a beta by setting this to false
                this:SetObjVar("IsAlpha",false)

                --this:SetObjVar("TemplateName",this:GetName())
            --we are equal, we fight
			elseif (myDominance == otherDominance ) then
                --DebugMessage("We fight! "..tostring(otherObj.Id))
				--two dominant alpha wolfs fight!
                --DebugMessage("wolf fight")
                this:DelObjVar("MySuperior")
                AttackEnemy(otherObj)
			end
    	end
    end)

RegisterEventHandler(EventType.Timer, "EnableHowlingTimer", 
    function ()
        this:SetObjVar("HowlEnabled",true)
    end)

RegisterEventHandler(EventType.Message, "EnableHowling", 
    function ()
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(7),"EnableHowlingTimer")
    end)

RegisterEventHandler(EventType.Message, "HowlMessage", 
    function (faceObject)
        FaceObject(this,faceObject)
        AI.StateMachine.ChangeState("Howl")
    end)

--If I die then the chain of command breaks down
RegisterEventHandler(EventType.Message, "HasDiedMessage", 
    function ()
        local objlist = FindObjects(SearchObjVar("MySuperior",this,30))        
        for i,wolf in pairs(objlist) do
            wolf:DelObjVar("MySuperior")
        end
    end)

if (this:HasObjVar("IsHellHound")) then
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"HellHoundTimer")
    --DebugMessage("Hellhoundz 1")
end

RegisterEventHandler(EventType.Timer,"HellHoundTimer",function ( ... )
    this:PlayEffect("FlameAuraEffect",2.8)
    --DebugMessage("Hellhoundz 2")
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"HellHoundTimer")
end)