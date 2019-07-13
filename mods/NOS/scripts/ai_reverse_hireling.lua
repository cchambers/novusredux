-- TODO: Handle when an item is release or removed from a lcoked down container. Must remove all items for sale

require 'NOS:ai_follower'
require 'NOS:incl_faction'
require 'NOS:map_markers'


AI.Settings.CanWander = false
AI.Settings.ChaseSpeed = 3.5
AI.Settings.CanConverse = true
AI.Settings.ShouldSleep = false

MAX_FOLLOW_TRIES = 50
followTries = 0

if (initializer ~= nil) then
    if( initializer.Names ~= nil ) then    
        local name = initializer.Names[math.random(1,#initializer.Names)]
        this:SetName(name)
    end
end

function Init()
    this:SetObjVar("TaskComplete", false)
    ReleaseHireling(this)
    AI.StateMachine.ChangeState("Wander")
    AddView("NearbyPlayers", SearchPlayerInRange(5), 1.5)
    this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(1500), "tryFindHirelingOwner")
    --this:SetObjVar("RHirelingRegionalName", nil)
end

function DecideIdleState()
    if (IsDead(this)) then AI.StateMachine.ChangeState("Dead") return end 
    if not(AI.IsActive()) then return end

    if (IsInCombat(this)) then
        this:SendMessage("EndCombatMessage")
    end

    if (this:GetObjVar("TaskComplete") == true) then
        AI.StateMachine.ChangeState("Wander")
        return
    else
        mFollowTarget = this:GetObjVar("controller")
        -- we are supposed to be following someone for a job
        if(mFollowTarget ~= nil) then
            AI.StateMachine.ChangeState("Follow")
        else
            -- not follownig someone so just wander until someone hires us
            AI.StateMachine.ChangeState("Wander")
        end
    end

    if( IsHired() ) then
        AI.StateMachine.ChangeState("Follow")
    end
end

AI.StateMachine.AllStates.Wander = {
        GetPulseFrequencyMS = function() return math.random(1700,2400) end,
        
        OnEnterState = function()
            --local wanderRegion = this:GetObjVar("WanderRegion")
            local regions = GetRegionsAtLoc(this:GetLoc())
            local wanderRegion = regions[1]
            --DebugMessage(wanderRegion)
            WanderInRegion(wanderRegion,"Wander")
        end,

        OnArrived = function (success)
            if (AI.StateMachine.CurState ~= "Wander") then
                return 
            end
            --AI.StateMachine.ChangeState("ReturnToPath")  
        end,

        AiPulse = function()
            DecideIdleState()
        end,
    }

local goonFollow = AI.StateMachine.AllStates.Follow
AI.StateMachine.AllStates.Follow = {
    GetPulseFrequencyMS = function() return 1000 end,

    AiPulse = function()
        goonFollow:AiPulse()
        TryFindHirelingOwner()
    end,
}

local baseConverse = AI.StateMachine.AllStates.Converse
AI.StateMachine.AllStates.Converse = {
    GetPulseFrequencyMS = function() return 1500 end,

    OnEnterState = function() 
            this:StopMoving()
            FaceObject(this,AI.IdleTarget)
            local seed = math.random(1,2)
            if(seed == 1) then
                this:PlayAnimation("roar")
            elseif (seed == 2) then
                this:PlayAnimation("yes_two")
            end
        end,

    AiPulse = function ()
        baseConverse:AiPulse()
        TryFindHirelingOwner()
    end,
}

AI.StateMachine.AllStates.DoNothing = {}

function ShowOwnerDialog(user,dialogText)
    AI.IdleTarget = user
    -- DAB TODO: Add more variety to welcome messages
    dialogText = dialogText or StripColorFromString(user:GetName()).." my friend! What do you need?"

    response = {
        { text = "Remind me, where are we going again?", handle = "ShowDirections" },
        { text = "The hunt no longer interests me.", handle = "ShowDismiss" },
        { text = "Nevermind.", handle = "Close" } }

    NPCInteraction(dialogText,this,user,"Responses",response)
    AI.StateMachine.ChangeState("Converse")
end

function ShowLookingForWorkDialog(user)
    AI.IdleTarget = user
    local taskInfo = this:GetObjVar("RHirelingTask")
    local text = ("Ha haa! The hunt is on my friend. Dangerous beasts ravage these lands and merchants pay a pretty coin for their remains. I head towards "..taskInfo.RegionalName.. " to slay some " ..GetTemplateData(taskInfo.Template).Name.."! Won't you join me friend?")

    response = {
        { text = "Yes! Follow me!", handle = "BeginHire" },
        { text = "No thanks.", handle = "Close" } }

    NPCInteraction(text,this,user,"Responses",response)
    AI.StateMachine.ChangeState("Converse")
end

function ShowDismissDialog(user)

    -- DAB TODO: Add more variety to welcome messages
    local dialogText = AI.FireHirelingMessages or "Perhaps you are merely afraid! Will you suffer the shame of abandoning the hunt?"

    response = {
        { text = "Yes, you can go now.", handle = "DismissConfirm" },            
        { text = "Nevermind.", handle = "Close" } }

    NPCInteraction(dialogText,this,user,"Responses",response)
    AI.StateMachine.ChangeState("Converse")
end

function ShowDirectionsDialog(user)
    local taskInfo = this:GetObjVar("RHirelingTask")
    local dialogText = ""
    local subregionName = ServerSettings.SubregionName
    --DebugMessage(taskInfo.RegionalName.." "..SubregionDisplayNames[subregionName])
    if (GetRegionalName(user:GetLoc()) == taskInfo.RegionalName or taskInfo.RegionalName == GetRegionalName(user:GetLoc())) then
        dialogText = "We'll find some "..GetTemplateData(taskInfo.Template).Name.." over here. I've marked your map."

        local poiLoc = PointsOfInterest[taskInfo.Poi]
        if (poiLoc ~= nil) then
            local mapMarker ={ Icon="marker_circle1", Tooltip=taskInfo.Poi, Location= poiLoc}
            AddDynamicMapMarker(user, mapMarker, "RHirelingTask")
        else
            --DebugMessage("No point of interest "..taskInfo.Poi.." found")
        end
    else
        dialogText = "We head to "..this:GetObjVar("RHirelingTask").RegionalName.." to hunt "..GetTemplateData(taskInfo.Template).Name.."!"
    end

    response = {
        { text = "Thanks.", handle = "Close" } }

    NPCInteraction(dialogText,this,user,"Responses",response)
    AI.StateMachine.ChangeState("Converse")
end

function ShowTaskCompleteDialog(user)
    local dialogText = user:GetName()..", you are an incredible hunter! Here, take a share of my spoils. You earned it!"
    local taskInfo = this:GetObjVar("RHirelingTask")
    CreateStackInBackpack(user, "coin_purse", math.random(taskInfo.RewardMin, taskInfo.RewardMax))
    response = {
        { text = "Thanks.", handle = "TaskComplete" } }

    NPCInteraction(dialogText,this,user,"Responses",response)
    AI.StateMachine.ChangeState("Converse")
end

function ShowPostTaskCompleteDialog(user)
    --local dialogText = "It was a pleasure to hunt with you "..user:GetName().."!"
    --this:NpcSpeech(dialogText)
end

function ShowNotStrongEnoughDialog(user)

    dialogText = "I know the eyes of a greenhorn when I see one. I'm looking for someone to go hunting with, but you would only slow me down. Come back once you've experience more of this world."
    response = {
        { text = "Rude...", handle = "Close" },
        { text = "Goodbye.", handle = "Close" } 
    }

    NPCInteraction(dialogText,this,user,"Responses",response)
    AI.StateMachine.ChangeState("Converse")
    end

function TryFindHirelingOwner()
    local hirelingOwner = this:GetObjVar("HirelingOwner")
    if (hirelingOwner ~= nil) then
        if not (hirelingOwner:IsValid()) then
            --DebugMessage(followTries)
            followTries = followTries - 1
            if (followTries <= 0) then
                EndRHirelingDiversion()
            end
        else
            followTries = MAX_FOLLOW_TRIES
        end
    end
end

function DoDismiss(user)
    this:DelObjVar("controller")
    AI.StateMachine.ChangeState("Wander")
    this:PlayAnimation("fidget")
    CallFunctionDelayed(TimeSpan.FromSeconds(0.5),function ( ... )
        CreateObj("portal",this:GetLoc(),"dismiss_portal_created")
    end)
    CallFunctionDelayed(TimeSpan.FromSeconds(1.5),function ( ... )
        PlayEffectAtLoc("TeleportToEffect",this:GetLoc())
        this:Destroy()
    end)
end

RegisterEventHandler(EventType.CreatedObject,"dismiss_portal_created",
    function (success,objRef )
        Decay(objRef, 5)
    end)

function IsHired()
    return this:GetObjVar("HirelingOwner") ~= nil
end

function RemoveFromSpawner()
    if(this:HasTimer("ClearSpawnerTimer")) then
        this:RemoveTimer("ClearSpawnerTimer")
    end

    local spawner = this:GetObjVar("Spawner")
    if (spawner ~= nil) then
        spawner:SendMessage("RemoveSpawnedObject",this)
    end
end

function HandleInteract(user,usedType)
    if(usedType ~= "Interact") then return end
    if (IsAsleep(this)) then
        return 
    end
    if (user == nil) then return end
    if (not user:IsValid()) then return end
    if (not user:HasObjVar("Invulnerable")) then
        if not(AI.IsValidTarget(user)) then
            return
        end
    end

    if not (this:GetObjVar("Dismissed")) then
        local owner = GetHirelingOwner(this)
        local taskInfo = this:GetObjVar("RHirelingTask")
        local lifetimePrestigeXP = user:GetObjVar("LifetimePrestigeXP")
        if (lifetimePrestigeXP == nil) then
            lifetimePrestigeXP = 0
        end

        if(owner == user and this:GetObjVar("TaskComplete") == false) then
            ShowOwnerDialog(user)
            return
        end

        if (owner == user and this:GetObjVar("TaskComplete")) then
            ShowTaskCompleteDialog(user)
            return
        end

        if (IsHired() == false and lifetimePrestigeXP >= taskInfo.RequiredLifetimePrestige) then
            ShowLookingForWorkDialog(user)
            return
        else
            ShowNotStrongEnoughDialog(user)
            return
        end
    end
end

function TryHire(user)

    if (AddHireling(user, this)) then
        if (user:HasModule("player_reverse_hireling")) then
            user:DelModule("player_reverse_hireling")
        end
        DelView("NearbyPlayers")
        user:AddModule("player_reverse_hireling")
        --user:SetObjVar("RHirelingRegionalName", this:GetObjVar("RHirelingRegionalName"))
        this:NpcSpeech("The hunt is on "..user:GetName().."! Lead the way!")
        user:SendMessage("InitHireling", this)
        user:SystemMessage("Diversion Started", "info")
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"ClearSpawnerTimer")
        CompleteHire(user,user)
    else
        local dialogText = "You appear to have your hands full with someone else. Come back when you're ready to hunt!"
        this:NpcSpeech(dialogText)
    end
end

function CompleteHire(user,targetLoc)
        this:SetObjectOwner(user)
        AI.SetSetting("Leash",false)
        AI.SetSetting("StationedLeash",false)
        this:SendMessage("ReassignSuperior",user)
        this:ClearPathTarget()
        AI.StateMachine.ChangeState("Follow")
    
end

function CompleteTask(user)
    this:SetObjVar("TaskComplete", true)
    local taskInfo = this:GetObjVar("RHirelingTask")
    if (taskInfo ~= nil) then
        user:PlayObjectSound("event:/ui/skill_gain", false)
        user:SystemMessage(GetTemplateData(taskInfo.Template).Name.." hunt complete! Collect your reward from the Hunter.", "info")
    end

    this:SetObjVar("TaskComplete", "true")
end

function EndRHirelingDiversion(taskComplete, fromHireling)
    this:SetObjectOwner(nil)
    DelView("NearbyPlayers")
    local hirelingOwner = this:GetObjVar("HirelingOwner")
    this:SetObjVar("Dismissed", true)

    if (taskComplete) then
        --ShowTaskCompleteDialog(this:GetObjVar("HirelingOwner"))
        this:PlayObjectSound("event:/ui/quest_complete", false)
        if (hirelingOwner~= nil) then
            hirelingOwner:SystemMessage("Diversion Completed", "info")
        end
        --DebugMessage("TASK COMPLETE")

        CallFunctionDelayed(TimeSpan.FromSeconds(5),function ( ... )
        DoDismiss(this)
    end)
    else
        if (hirelingOwner ~= nil) then
            hirelingOwner:SystemMessage("Diversion Ended", "info")
            DoDismiss(this)
        end
    end

    if (fromHireling) then
        if (hirelingOwner ~= nil) then
            if (hirelingOwner:IsValid()) then
                hirelingOwner:SendMessage("EndRHirelingDiversion", true)
            end
        end
    end
end

RegisterEventHandler(EventType.DynamicWindowResponse, "Responses",
    function (user,buttonId)
        if(buttonId == "ShowDismiss") then
            ShowDismissDialog(user)
        elseif(buttonId == "ShowDirections") then
            ShowDirectionsDialog(user)        
        elseif(buttonId == "DismissConfirm") then
            DoDismiss(user)
            this:NpcSpeech("What a waste of my time...")
            EndRHirelingDiversion(false, true)
            user:CloseDynamicWindow("Responses")
        elseif(buttonId == "BeginHire") then
            TryHire(user)
            user:CloseDynamicWindow("Responses")
        elseif(buttonId == "Close") then
            user:CloseDynamicWindow("Responses")
        elseif(buttonId == "TaskComplete") then
            EndRHirelingDiversion(true)
            user:CloseDynamicWindow("Responses")
        end

        DecideIdleState()
    end)

OverrideEventHandler("NOS:base_ai_conversation",EventType.Message, "UseObject", HandleInteract)

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
    function()
        if (initializer ~= nil) then
            local tasks = initializer.Tasks
            if (tasks ~= nil) then
                local randomTask = tasks[math.random(1, #tasks)]
                this:SetObjVar("RHirelingTask", randomTask)
            end
        end
        Init()
    end)

RegisterEventHandler(EventType.Message, "HasDiedMessage",
    function(killer)
        RemoveFromSpawner()
        EndRHirelingDiversion( false, true)
    end)

RegisterEventHandler(EventType.Message, "EndRHirelingDiversion",
    function (taskComplete) 
        EndRHirelingDiversion(taskComplete, false)
    end)

RegisterEventHandler(EventType.EnterView, "NearbyPlayers",
    function (playerObj)
        local taskInfo = this:GetObjVar("RHirelingTask")
        if (taskInfo ~= nil) then
            local playerLifetimePrestige = playerObj:GetObjVar("LifetimePrestigeXP")
            if (playerLifetimePrestige ~= nil) then
                if (playerLifetimePrestige >= taskInfo.RequiredLifetimePrestige) then
                    FaceObject(this, playerObj)
                    this:NpcSpeech("You there! I have a proposition for you!")
                end
            end
        end
    end)

RegisterSingleEventHandler(EventType.Timer,"ClearSpawnerTimer",function ( ... )
        RemoveFromSpawner()
    end)

RegisterEventHandler(EventType.Message, "CompleteTask", 
    function(user)
        CompleteTask(user)
    end)