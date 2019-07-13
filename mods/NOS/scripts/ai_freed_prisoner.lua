require 'NOS:base_ai_mob'
require 'NOS:base_ai_casting'
require 'NOS:base_ai_intelligent'
require 'NOS:base_ai_conversation'
require 'NOS:guard_protect'

path = GetPath("SlaveEscapePath")

thingsToSay = 
{
	"Help!",
	"Help me!",
	"Sorry! Can't talk!",
	"I'm outta here!",
}

--npc's should all have this
function IsFriend(target)
    --My only enemy is the enemy
    if (AI.InAggroList(target)) then
        return false
    else
        return true
    end
end

function GetNextLoc(curPathIndex)
	path = GetPath("SlaveEscapePath")
    local deviation = Loc(math.random()*2-1,0,math.random()*2-1)
    currentDestination = path[curPathIndex]:Add(deviation)
    return currentDestination
end

function RunPath()
	local curPathIndex = this:GetObjVar("curPathIndex")
	if curPathIndex >= #path then 
		this:SetObjVar("shouldRunAway",false)
		return
	end
	curPathIndex = math.min(#path,curPathIndex + 1)
	this:SetObjVar("curPathIndex", curPathIndex)
	this:PathTo(GetNextLoc(curPathIndex),3.0,"runAway")
end

function OnReturnToPathArrived(arriveSuccess)
    if(arriveSuccess) then
       -- --DebugMessage("Patrol")
        AI.StateMachine.ChangeState("RunAway")
    end
end

function OnReturnToPathArrived(arriveSuccess)
    if(arriveSuccess) then
       -- --DebugMessage("Patrol")
        AI.StateMachine.ChangeState("RunAway")
    end
end

function OnNextPath(arriveSuccess)

	local curPathIndex = this:GetObjVar("curPathIndex")

	if curPathIndex >= #path then 
		this:SetObjVar("shouldRunAway",false)
		AI.StateMachine.ChangeState("Idle")
		return
	end
    --DebugMessage("[ai_freed_prisoner::OnNextPath]")
    if( AI.StateMachine.CurState ~= "RunAway" ) then
        -- ignore this message if we are no longer running away
        return
    end
    -- TODO: Handle the case where he fails to path properly
    -- for now we just move on to the next point in the path
    if not(arriveSuccess) then
        --DebugMessage("[ai_freed_prisoner::OnNextPath] Failed to path to destination!")
    end
    RunPath()
end

function GetAttention(user)
    if (IsAsleep(this)) then
        return 
    end
    this:StopMoving()
    this:SetFacing(this:GetLoc():YAngleTo(user:GetLoc()))
    AI.StateMachine.ChangeState("Idle")
end

function ShouldRunAway()
	if (path == nil) then return false end
	if (not this:HasObjVar("shouldRunAway")) then return false end
    return this:GetObjVar("shouldRunAway") == true
end

function GetNearestPathNode()
    local closestNode = nil
    local closestDistance = 0

    if (path~= nil) then
	    for index,loc in pairs(path) do
	        local dist = this:GetLoc():Distance(loc)
	        if(closestNode == nil or dist < closestDistance) then
	            closestNode = index
	            closestDistance = dist
	        end
	    end
	else
		AI.StateMachine.ChangeState("Wander")
		return nil
	end

    return closestNode
end

AI.StateMachine.AllStates.RunAway = {
        OnEnterState = function()
            --DebugMessage(this:GetName().." is pathing")
    		RunPath()
        end,
    }

AI.StateMachine.AllStates.Flee = {
        OnEnterState = function()
	        if (ShouldRunAway()) then
	            AI.StateMachine.ChangeState("RunAway")
	            return
	        end
            if (FleeTalk ~= nil) then
                FleeTalk()
            end
            local fleeAngle = FindSafestAngle()
            local fleeDest = this:GetLoc():Project(fleeAngle, AI.GetSetting("FleeDistance"))
            local fleeSpeed = AI.GetSetting("FleeSpeed")
            this:PathTo(fleeDest,fleeSpeed,"Flee")
        end,
    }

AI.StateMachine.AllStates.Follow =
{
		GetPulseFrequencyMS = function() return 3000 end,

		OnEnterState = function() 
			AI.ClearAggroList()

			local controller = this:GetObjVar("controller")
			if (controller ~= nil and controller:IsValid() and not IsDead(controller)) then
				this:PathToTarget(controller,1.0,4.0)
			else
				AI.StateMachine.ChangeState("Idle")
			end
		end,

		AiPulse = function() 
		end,	
}

AI.StateMachine.AllStates.Idle = {   
        GetPulseFrequencyMS = function() return 5000 end,

        OnEnterState = function()
            if( ShouldRunAway() ) then
                    --DebugMessage(this:GetName().." is ReturnToPath")   
                AI.StateMachine.ChangeState("ReturnToPath")
                return
            end

            if( homeFacing ~= nil ) then
                --DebugMessage("Setting facing to "..tostring(homeFacing))
                this:SetFacing(homeFacing)
            end
            
            --this:NpcSpeech("[f70a79]*Idle!*[-]")
            DebugMessageA(this,"Idle pulse")
                --DebugMessage("Changing state in idle.") 
        end,

        AiPulse = function ()
            DecideIdleState()
            --Reduce anger in idle
            AI.Anger = AI.Anger - 1
            if (AI.Anger < 0)  then
                AI.Anger = 0
            end
            if (not ShouldRunAway()) then
                AI.StateMachine.ChangeState("Wander")
            end
            -- body
        end
    }

AI.StateMachine.AllStates.ReturnToPath = {
        OnEnterState = function()
            --DebugMessage(this:GetName().." is Return to Path")
            local pathIndex = GetNearestPathNode()
            if( pathIndex == nil ) then
                return
            end
            if( this:GetLoc():Distance(path[pathIndex]) < 1 ) then
                AI.StateMachine.ChangeState("RunAway")
                return
            end
            this:SetObjVar("curPathIndex", pathIndex)
            this:PathTo(path[pathIndex],3.0,"returnToPath") 
        end,
    }


--has the variable Visible to All set to true so he isn't really cloaked, it just appears like that.
RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if(usedType ~= "Interact") then return end
		
		GetAttention(user)
		target = user:GetObjVar("SlaveTraderTarget")
		targetName = user:GetObjVar("SlaveTraderTargetName")
		releaser = this:GetObjVar("MyReleaser")
		--new person
		if (target == this) then

			text = "Hello there ... why are you looking at me funny?"

			response = {}

			response[1] = {}
			response[1].text = "Are you "..targetName .."?"
			response[1].handle = "" 

			response[2] = {}
			response[2].text = "Nevermind"
			response[2].handle = "" 

			NPCInteraction(text,this,user,"Question",response)

		elseif (ShouldRunAway()) then		
			this:NpcSpeech(thingsToSay[math.random(1,#thingsToSay)])
			return
		elseif (not ShouldRunAway() and (not this:HasObjVar("GivenReward")) and user == releaser) then

			text = "[$62]"

			response = {}

			local backpackObj = user:GetEquippedObject("Backpack")
			CreateObjInContainer("coin_purse", backpackObj, GetRandomDropPosition(backpackObj), "LootCoinPurse", math.random(1,40))
			
			response[4] = {}
			response[4].text = "Thanks!"
			response[4].handle = "" 

			this:SetObjVar("GivenReward",true)

			NPCInteraction(text,this,user,"Question",response)

		elseif (user == releaser) then

			text = "[$63]"

			response = {}

			response[1] = {}
			response[1].text = "I have a question."
			response[1].handle = "Nevermind" 

			response[2] = {}
			response[2].text = "I need some help."
			response[2].handle = "Nevermind" 

			response[4] = {}
			response[4].text = "You're welcome."
			response[4].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)
		else

			text = "Hello there, is there anything I can do for you?"

			response = {}

			response[1] = {}
			response[1].text = "I have a question."
			response[1].handle = "Question" 

			response[2] = {}
			response[2].text = "I need some help."
			response[2].handle = "Help" 

			response[3] = {}
			response[3].text = "Who are you, anyway?"
			response[3].handle = "Who" 

			response[4] = {}
			response[4].text = "Nevermind."
			response[4].handle = "Goodbye" 

			NPCInteraction(text,this,user,"Question",response)
		end
end)

RegisterEventHandler(EventType.DynamicWindowResponse, "Question",
	function (user,buttonId)
		GetAttention(user)

		local opinionOfUser = user:GetObjVar("MysticOpinion")

		if (buttonId == "Question") then

			text = "What's the question?"

			response = {}

			response[1] = {}
			response[1].text = "Who are you?"
			response[1].handle = "Who" 
			response[2] = {}
			response[2].text = "Where are you from?"
			response[2].handle = "Where" 
			response[3] = {}
			response[3].text = "Nevermind."
			response[3].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)

		elseif (buttonId == "Help") then

			text = "[$64]"

			response = {}

			--response[1] = {}
			--response[1].text = "Need a job?"
			--response[1].handle = "Hire" 

			response[2] = {}
			response[2].text = "Nevermind."
			response[2].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)

		elseif (buttonId == "Who") then
			if (not this:HasObjVar("FirstName")) then
				text = "[$65]"
			else
				text = "I'm "..this:GetObjVar("FirstName").."[$66]"
			end
			response = {}

			response[2] = {}
			response[2].text = "Ah."
			response[2].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)

		elseif (buttonId == "Nevermind") then

			text = "Is there anything else I can do for you?"

			response = {}

			response[1] = {}
			response[1].text = "I have a question."
			response[1].handle = "Question" 

			response[2] = {}
			response[2].text = "I need some help."
			response[2].handle = "Help" 

			response[3] = {}
			response[3].text = "Who are you, anyway?"
			response[3].handle = "Who" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)

		elseif (buttonId == "Prisoner?") then

			if (math.random (1,5) == 5) then

				this:SendMessage("AttackEnemy",user)
				this:NpcSpeech("You'll never take me alive!!!")

			else

				text = "Yes... I was, why do you ask?"

				response = {}

				response[1] = {}
				response[1].text = "Come with me or else."
				response[1].handle = "ComeWithMe" 

				response[1] = {}
				response[1].text = "You are now my prisoner!"
				response[1].handle = "AttackEnemy" 

				response[1] = {}
				response[1].text = "The trader put a hit on you!"
				response[1].handle = "Hit" 

				response[2] = {}
				response[2].text = "Nevermind"
				response[2].handle = "" 

				NPCInteraction(text,this,user,"Question",response)

			end

		elseif (buttonId == "Where") then

			text = "[$67]"

			response = {}

			--response[1] = {}
			--response[1].text = "Need a job?"
			--response[1].handle = "Hire" 

			response[2] = {}
			response[2].text = "Nevermind."
			response[2].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)

		elseif (buttonId == "Prisoner") then

				this:SendMessage("AttackEnemy",user)
				this:NpcSpeech("You'll never take me alive!!!")

		elseif (buttonId == "ComeWithMe") then

				this:SendMessage("AttackEnemy",user)
				this:NpcSpeech("You'll never take me alive!!!")

		elseif (buttonId == "Hit") then
			if (this:HasObjVar("Warned")) then

				text = "[$68]"

				response = {} 

				response[1] = {}
				response[1].text = "I've been sent to take you back."
				response[1].handle = "ComeWithMe" 

				response[4] = {}
				response[4].text = "Thanks!"
				response[4].handle = "" 

				this:SetObjVar("Warned",true)

				NPCInteraction(text,this,user,"Question",response)
			else

				text = "[$69]"

				response = {} 

				local backpackObj = user:GetEquippedObject("Backpack")
				CreateObjInContainer("coin_purse", backpackObj, GetRandomDropPosition(backpackObj), "LootCoinPurse", math.random(1,40))
				
				response[1] = {}
				response[1].text = "Thanks. Now come with me."
				response[1].handle = "ComeWithMe" 

				response[4] = {}
				response[4].text = "Thanks!"
				response[4].handle = "" 

				this:SetObjVar("Warned",true)

				NPCInteraction(text,this,user,"Question",response)

			end

		elseif (buttonId == "Attack") then

			this:SendMessage("AttackEnemy",user)

		end

	end)

AI.Settings.Debug = false
AI.Settings.AggroRange = 10.0
AI.Settings.ChaseRange = 15.0
AI.Settings.LeashDistance = 20
AI.Settings.CanConverse = true
AI.Settings.ScaleToAge = false
AI.Settings.CanWander = true
AI.Settings.CanUseCombatAbilities = true
AI.Settings.CanCast = true
AI.Settings.ChanceToNotAttackOnAlert = 2

RegisterEventHandler(EventType.Arrived, "returnHome", OnHomeArrived)
RegisterEventHandler(EventType.Arrived, "returnToPath", OnReturnToPathArrived)
RegisterEventHandler(EventType.Arrived, "runAway", OnNextPath)

this:SetObjVar("shouldRunAway",true)

RegisterSingleEventHandler(EventType.ModuleAttached,GetCurrentModule(),
    function( ... )
        AddUseCase(this,"Interact",true)
    end)