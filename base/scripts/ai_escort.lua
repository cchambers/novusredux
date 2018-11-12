require 'ai_follower'
require 'incl_faction'
require 'map_markers'

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

AI.StateMachine.AllStates.Wander = {
        GetPulseFrequencyMS = function() return math.random(1700,2400) end,
        
        OnEnterState = function()
            local regions = GetRegionsAtLoc(this:GetLoc())
            local wanderRegion = regions[1]
            --DebugMessage(wanderRegion)
            WanderInRegion(wanderRegion,"Wander")
        end,

        OnArrived = function (success)
            if (AI.StateMachine.CurState ~= "Wander") then
                return 
            end
            AI.StateMachine.ChangeState("ReturnToPath")   
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
        DecideIdleState()
        TryFindHirelingOwner()
    end,
}

local baseConverse = AI.StateMachine.AllStates.Converse
AI.StateMachine.AllStates.Converse = {
    GetPulseFrequencyMS = function() return 1500 end,

    OnEnterState = function() 
            baseConverse:OnEnterState()
        end,

    AiPulse = function ()
        baseConverse:AiPulse()
    	--DecideIdleState()
        TryFindHirelingOwner()
    end,
}

function Init()
    this:SetObjVar("TaskComplete", false)
    AI.StateMachine.ChangeState("Idle")
    AddView("NearbyPlayers", SearchPlayerInRange(5), 1.5)
end

function PickTask()
   	if (initializer.Tasks ~= nil) then

   		--Create a list of tasks that don't start where the escort spawned
   		local availableTasks = {}
   		for i, task in pairs(initializer.Tasks) do
   			if (task.DestinationRegionalName ~= GetRegionalName(this:GetLoc())) then
   				availableTasks[#availableTasks +1] = task
   			end
   		end

   		--Pick a random task from available tasks
   		local pickedTask
   		if (#availableTasks >= 1) then
   			pickedTask = availableTasks[math.random(1, #availableTasks)]
   		else
   			pickedTask = initializer.Tasks[math.random(1, #initializer.Tasks)]
   		end

   		--Get the distance from the escort to the destination
   		--Uses DefaultMapMarkers
   		local destinationLoc = nil
   		for i, subRegionMarker in pairs(DefaultMapMarkers.NewCelador) do
   			for j, marker in pairs(subRegionMarker) do
   				if (marker.Tooltip == pickedTask.MapMarker) then
   					--DebugMessage(marker.Tooltip.." - ".. pickedTask.MapMarker)
   					destinationLoc = marker.Location
   				end
   			end
   		end
   		if (destinationLoc ~= nil) then
   			local distanceToDestination = this:GetLoc():Distance(destinationLoc)

	   		--Calculate reward based on distance
	   		local reward = nil
	   		if (distanceToDestination <= 1250) then
	   			reward = 125
	   		end
	   		if (distanceToDestination >= 1250) then
	   			reward = 250
	   		end
			if (distanceToDestination >= 2500) then
				reward = 375
			end
			if (distanceToDestination >= 5000) then
				reward = 500
			end
			if (distanceToDestination >= 7500) then
				reward = 700
			end
	   		this:SetObjVar("Reward", reward)
   		end

   		this:SetObjVar("EscortTask", pickedTask)
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

    if (this:GetObjVar("TaskComplete") == false) then
        if not (IsHired()) then
        	ShowLookingForWorkDialog(user)
        	return
        end

        if (this:GetObjVar("HirelingOwner") == user and not AtDestination()) then
    		ShowTaskInfoDialog(user)
    		return
    	elseif (this:GetObjVar("HirelingOwner") == user and AtDestination()) then
    			ShowTaskCompleteDialog(user)
    		return
    	end
    end
end

function DecideIdleState()
    if (IsDead(this)) then AI.StateMachine.ChangeState("Dead") return end 
    if not(AI.IsActive()) then return end

    if (IsInCombat(this)) then
        this:SendMessage("EndCombatMessage")
    end

    mFollowTarget = this:GetObjVar("controller")
    -- we are supposed to be following someone for a job
    if(mFollowTarget ~= nil) then
        AI.StateMachine.ChangeState("Follow")
    else
        -- not follownig someone so just wander until someone hires us
        AI.StateMachine.ChangeState("Wander")
    end


    if( IsHired() ) then
        AI.StateMachine.ChangeState("Follow")
    end
end

function ShowLookingForWorkDialog(user)
    AI.IdleTarget = user
    local taskInfo = this:GetObjVar("EscortTask")
    local text = ("Excuse me fellow traveller! These lands are dangerous, and I seek to make my ways towards "..taskInfo.DestinationRegionalName.." to perform my act! A handsome reward lies in your future if you help me get to "..taskInfo.DestinationRegionalName..". What say you?")

    response = 
    {
        { text = "Yes! Follow me!", handle = "BeginHire" },
        { text = "No thanks.", handle = "Close" } 
    }

    NPCInteraction(text,this,user,"Responses",response)
    AI.StateMachine.ChangeState("Converse")
end

function ShowTaskStartedSpeech(user)
	this:NpcSpeech(user:GetName().." was it?! Lead the way!")
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"ClearSpawnerTimer")
    CompleteHire(user)
end

function ShowTaskInfoDialog(user)
	AI.IdleTarget = user
	local taskInfo = this:GetObjVar("EscortTask")
	local text = ("Yes ".. user:GetName().. "? What do you need?")
	response = 
	{
        { text = "Remind me, where are we going?", handle = "ShowDirectionsDialog" },
        { text = "I'm leaving you.", handle = "Dismiss"},
        { text = "Nevermind.", handle = "Close"}
    }

    NPCInteraction(text,this,user,"Responses",response)
    AI.StateMachine.ChangeState("Converse")
end

function ShowDirectionsDialog(user)
	AI.IdleTarget = user
	local taskInfo = this:GetObjVar("EscortTask")
	local text = ("We're heading to ".. taskInfo.DestinationRegionalName..".")
	response = 
	{
		{text = "Thanks.", handle = "ShowTaskInfo"}
	}
	NPCInteraction(text,this,user,"Responses",response)
    AI.StateMachine.ChangeState("Converse")
end

function ShowDismissConfirmDialog(user)
	AI.IdleTarget = user
	--local taskInfo = this:GetObjVar("EscortTask")

	local text = ""
	if not (this:GetObjVar("AllowDismiss")) then
		text = ("But we've only just started "..user:GetName().."! Give yourself some time to reconsider.")
		response = 
		{
	        { text = "Okay.", handle = "Close"},
	    }
	else
		text = ("I'm disappointed "..user:GetName()..". This will set me back quite a ways. Are you sure you want to leave me behind?")
		response = 
		{
	        { text = "Sorry, but yes.", handle = "PoliteDismiss" },
	        { text = "I've grown sick of you. Get out of my sight.", handle = "RudeDismiss"},
	        { text = "Nevermind.", handle = "Close"},
	    }
	end

    NPCInteraction(text,this,user,"Responses",response)
    AI.StateMachine.ChangeState("Converse")
end

function ShowTaskCompleteDialog(user)
    this:SetObjVar("TaskComplete", true)
	AI.IdleTarget = user
	local taskInfo = this:GetObjVar("EscortTask")
	local text = ("Ah! Here we are! "..taskInfo.DestinationRegionalName.. "! Here is your reward ".. user:GetName()..". Thanks for the protection, and the fine company!")
	response = 
	{
        { text = "Thank you.", handle = "Close" },
    }
    --CompleteTask(user)
    local reward = this:GetObjVar("Reward")
    if (reward == nil) then
    	reward = 350
    end

	CreateStackInBackpack(user, "coin_purse", math.random(reward - 75, reward + 75))
    NPCInteraction(text,this,user,"Responses",response)
    AI.StateMachine.ChangeState("Converse")
    EndEscortDiversion(true)
end

function CompleteHire(user)
    this:SetObjectOwner(user)
	AI.SetSetting("Leash",false)
    AI.SetSetting("StationedLeash",false)
    this:SendMessage("ReassignSuperior",user)
    this:ClearPathTarget()
    AddHireling(user, this)
    AI.StateMachine.ChangeState("Follow")
    RemoveFromSpawner()
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(30), "allowDismiss")
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

function TryFindHirelingOwner()
    local hirelingOwner = this:GetObjVar("HirelingOwner")
    if (hirelingOwner ~= nil) then
        if not (hirelingOwner:IsValid()) then
            --DebugMessage(followTries)
            followTries = followTries - 1
            if (followTries <= 0) then
                EndEscortDiversion(false)
            end
        else
            followTries = MAX_FOLLOW_TRIES
        end
    end
end

function IsHired()
    return this:GetObjVar("HirelingOwner") ~= nil
end

function AtDestination()
	--DebugMessage(GetRegionalName(this:GetLoc()).. " == ".. this:GetObjVar("EscortTask").DestinationRegionalName)
	return (GetRegionalName(this:GetLoc()) == this:GetObjVar("EscortTask").DestinationRegionalName)
end

function EndEscortDiversion(taskComplete)
    this:SetObjectOwner(nil)
    DelView("NearbyPlayers")
    local controller = this:GetObjVar("controller")

    if (taskComplete) then
        this:PlayObjectSound("QuestComplete", false)
        if (controller~= nil) then
        end
        --DebugMessage("TASK COMPLETE")

        CallFunctionDelayed(TimeSpan.FromSeconds(5),function ( ... )
        DoDismiss(this)
    end)
    else
        if (controller ~= nil) then
            DoDismiss(this)
        end
    end
end

function DoDismiss(user)
	ReleaseHireling(this)
    this:DelObjVar("controller")
    AI.StateMachine.ChangeState("Wander")
    this:PlayAnimation("cast_heal")
    CallFunctionDelayed(TimeSpan.FromSeconds(0.5),function ( ... )
        CreateObj("portal",this:GetLoc(),"dismiss_portal_created")
    end)
    CallFunctionDelayed(TimeSpan.FromSeconds(1.5),function ( ... )
        PlayEffectAtLoc("TeleportToEffect",this:GetLoc())
        this:Destroy()
    end)
end

RegisterEventHandler(EventType.Timer, "allowDismiss", 
	function()
		this:SetObjVar("AllowDismiss", true)
	end)

RegisterEventHandler(EventType.CreatedObject,"dismiss_portal_created",
    function (success,objRef )
		Decay(objRef, 5)
    end)

    RegisterEventHandler(EventType.Message, "HasDiedMessage",
    function(killer)
        RemoveFromSpawner()
        EndEscortDiversion(false)
    end)

    RegisterEventHandler(EventType.EnterView, "NearbyPlayers",
    function (playerObj)
        local taskInfo = this:GetObjVar("EscortTask")
    	if (taskInfo ~= nil) then
    		if (not IsHired() and CanAddHireling(playerObj)) then
                FaceObject(this, playerObj)
                this:NpcSpeech(initializer.HailPlayerSpeech[math.random(1,#initializer.HailPlayerSpeech)])
            end
        end
    end)

OverrideEventHandler("base_ai_conversation",EventType.Message, "UseObject", HandleInteract)
RegisterEventHandler(EventType.DynamicWindowResponse, "Responses",
    function (user,buttonId)
        if(buttonId == "BeginHire") then
        	if (CanAddHireling(user)) then
        		ShowTaskStartedSpeech(user)
        	else
        		this:NpcSpeech("You already appear to have your hands full with someone else.")
        	end
        	user:CloseDynamicWindow("Responses")
        elseif(buttonId == "Close") then
        	DecideIdleState()
            user:CloseDynamicWindow("Responses")
        elseif(buttonId == "ShowTaskInfo") then
            ShowTaskInfoDialog(user)
        elseif(buttonId == "Dismiss") then
            ShowDismissConfirmDialog(user)
        elseif (buttonId == "PoliteDismiss") then
        	user:CloseDynamicWindow("Responses")
        	this:NpcSpeech("I'm sorry to have wasted your time.")
        	EndEscortDiversion(false)
    	elseif(buttonId == "RudeDismiss") then
    		user:CloseDynamicWindow("Responses")
    		this:NpcSpeech("Well I never!")
    		EndEscortDiversion(false)
		elseif (buttonId == "ShowDirectionsDialog") then
			ShowDirectionsDialog(user)
        end
        --DecideIdleState()
    end)

RegisterEventHandler(EventType.Message, "EndEscortDiversion", function()
    EndEscortDiversion(false)
    end)

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
    function()
        if (initializer ~= nil) then
        	PickTask()
        end
        Init()
    end)