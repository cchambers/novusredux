-- TODO Handle Defending if attacked
require 'NOS:base_ai_intelligent' 
require 'NOS:base_ai_conversation' 

AI.SetSetting("CanConverse",true)
AI.SetSetting("CanWander",true)
AI.Settings.Leash = false
AI.Settings.DoNotBoast = true
AI.Settings.SpeechTable = "Villager"

AI.Settings.WorkAnimation = "minerock"
AI.Settings.WorkAnimationLoops = true
AI.Settings.WorkAnimationDelay = 2
AI.Settings.WorkAnimationMax = 9

AnimationCount = 0

thingsToSay = {
    "Do not disturb me. I'm working.",
    "I am busy doing my job.",
    "Talk to the boss if you want to talk.",
    "I am on clock, yes?.",
    "Go away now.",
    "Leave, I'm busy.",
    "Go away, I'm busy.",
}

function IsFriend(target)
    --My only enemy is the enemy
    
    if (AI.InAggroList(target)) then
        return false
    else
        return true
    end
end

table.insert(AI.IdleStateTable,{StateName = "Working",Type = "routine"})

AI.StateMachine.AllStates.Working = {

        InitialSubState = "Begin",

        OnEnterState = function(self)        
        	AI.SetSetting("CanConverse",false)
    		AI.SetSetting("CanWander",false)

    		this:ScheduleTimerDelay(TimeSpan.FromSeconds(60*20 + math.random(20,60)),"DecideIdle")  
        end,

        OnExitState = function(self)
        	AI.SetSetting("CanConverse",true)
    		AI.SetSetting("CanWander",true)
        end,

        SubStates =
        {
	        Begin = {
	            OnEnterState = function()
	                AI.StateMachine.ChangeSubState("Transfer")
	            end,
	        },
	        Work = {
	        	OnEnterState = function()
					local animToPlay = AI.GetSetting("WorkAnimation")
					if( animToPlay ~= nil ) then
						this:PlayAnimation(animToPlay)
					end
	        		AnimationCount = 0
	                DebugMessageA(this,"Enter work")
	        	end,

	        	GetPulseFrequencyMS = function() return AI.GetSetting("WorkAnimationDelay") * 1000 end,

	        	AiPulse = function()
	        		if not(AI.GetSetting("WorkAnimationLoops")) then
						local animToPlay = AI.GetSetting("WorkAnimation")
						if( animToPlay ~= nil ) then
							this:PlayAnimation(animToPlay)
						end
					end
	        		AnimationCount = AnimationCount + 1
	                DebugMessageA(this,"Pulse Work")
	        		if (AnimationCount > AI.GetSetting("WorkAnimationMax")) then
	                    DebugMessageA(this,"Transfer Work")
	        			AI.StateMachine.ChangeSubState("Transfer")
	        		end
	        	end,
			},
	    	Transfer = {
	        	OnEnterState = function(self)
	                local destination = self:GetValidDestination()
	            	DebugMessageA(this,"destination: "..tostring(destination))
		            if(destination == nil) then
	    	            -- what happened?
	        	        if not(this:HasModule("spawn_decay")) then
	            	    	this:AddModule("spawn_decay")
		                end
	    	            this:SetObjVar("DecayTime",5.0)
	        	        this:SendMessage("RefreshSpawnDecay")
		            else
	    	        	DebugMessageA(this,"PATHING")
	        	        this:PathTo(destination.Loc,1.0,"StartWorking")
	            	end 
	        	end,


	            IsValidDestination = function (destination)
	                if(this:GetLoc():Distance(destination.Loc) > MAX_PATHTO_DIST) then
	                    return false                
	                end

	                return IsPassable(destination.Loc)
	            end,

	            GetValidDestination = function(self)
	                local destination = nil
	                for i=1,#WorkLocations do 
	                    destination = WorkLocations[math.random(#WorkLocations)]
	                    DebugMessageA(this,"Checking work location "..tostring(destination.Loc))
	                    if not(self.IsValidDestination(destination)) then
	                        destination = nil
	                    else
	                        break
	                    end
	                end

	                return destination
	            end
    		},
    	},

        OnArrived = function (success)
            DebugMessageA(this,"Arrived, Success is "..tostring(success))
            if(success) then
                if (AI.StateMachine.CurState ~= "Working") then
                    return 
                end
                if( destination and destination.Facing) then 
                    this:SetFacing(destination.Facing)
                end
                AI.StateMachine.ChangeSubState("Work")
            else 
                AI.StateMachine.ChangeState("Wander")
            end
        end,

        OnExitState = function ()
            AI.SetSetting("CanConverse",true)
            AI.SetSetting("CanWander",true)
        end,
    }

function OnInit()
	if(initializer and initializer.WorkLocations) then
		WorkLocations = initializer.WorkLocations
		this:SetObjVar("WorkLocations",WorkLocations)
	else
		WorkLocations = this:GetObjVar("WorkLocations") or {}			
	end

	 if( initializer and initializer.VillagerNames ~= nil ) then    
        local name = initializer.VillagerNames[math.random(#initializer.VillagerNames)]
        local job = initializer.VillagerJobs[math.random(#initializer.VillagerJobs)]
        this:SetName(name.." the "..job)
        this:SendMessage("UpdateName")
     end
end

RegisterSingleEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function ( ... )
		OnInit()
	end)

RegisterSingleEventHandler(EventType.LoadedFromBackup,"",
	function ( ... )
		OnInit()
	end)

RegisterEventHandler(EventType.Arrived, "StartWorking",AI.StateMachine.AllStates.Working.OnArrived)

RegisterEventHandler(EventType.Timer, "DecideIdle",
	function ()
		DecideIdleState()
	end)

