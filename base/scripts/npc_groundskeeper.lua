require 'base_ai_mob'
require 'base_ai_intelligent'
--require 'base_ai_sleeping'
require "incl_dialogwindow"
require 'base_npc_extensions'

--npc's should all have this
function IsFriend(target)
    --My only enemy is the enemy
    if (AI.InAggroList(target)) then
        return false
    else
        return true
    end
end

AI.Settings.SleepTime = 24

table.insert(AI.IdleStateTable,{StateName = "GoToGravestone",Type = "pleasure"})
--Changing this sets the default interaction to interact
this:SetSharedObjectProperty("Faction","None")

AI.StateMachine.AllStates.Idle = { 
        GetPulseFrequencyMS = function() return math.random(3000,15000) end,
        AiPulse = function() 
            --aiRoll = math.random(4)
            --if(aiRoll == 1) then
            --    AI.StateMachine.ChangeState("GoLocation")            
            --else
            --    AI.StateMachine.ChangeState("Wander")
            --end
            DecideIdleState()
        end,        
    }

function GetAttention(user)
    if (IsAsleep(this)) then
        return 
    end
    this:StopMoving()
    this:SetFacing(this:GetLoc():YAngleTo(user:GetLoc()))
    AI.StateMachine.ChangeState("Idle")
end

function HasExplorationQuestNote(user)
	local backpack = user:GetEquippedObject("Backpack")
	if (backpack == nil) then return false end
	local NoteObject = FindItemInContainerRecursive(backpack,function (item)
		return item:HasObjVar("MasonContactNote") 
		-- body
	end)
	if (NoteObject ~= nil) then return true end
end

AI.StateMachine.AllStates.Wander = {
		RepeatState = true,
        OnEnterState = function()
			local regions = GetRegionsAtLoc(this:GetLoc())
			if (regions ~= nil and #regions > 0) then
				--DebugMessage(tostring(#regions) )
				curRegion = regions[math.random(1,#regions)]
			end
            WanderInRegion(curRegion,"Wander")
        end,

        OnArrived = function (success)
        	if (AI.MainTarget ~= nil) then return end
        	--DebugMessage("OnArrived executed")
            if (AI.StateMachine.CurState ~= "Wander") then
            	if (AI.StateMachine.CurState ~= "Idle") then
            		DecideIdleState()
            	end
            end
            if( math.random(2) == 1) then
                this:PlayAnimation("fidget")
            end
            DecideIdleState()
        end,
    }

AI.StateMachine.AllStates.GoToGravestone = {
		RepeatState = true,
        OnEnterState = function()
            objects = FindObjects
				(SearchMulti({
                SearchModule("diggable_object"),
                SearchRange(this:GetLoc(), 40),
                })) --find my gravestones mate oi'
                
			if (objects ~= nil and #objects > 0) then
				--DebugMessage(tostring(#objects))
				destinationObject = objects[math.random(1,#objects)]
			end

            if (destinationObject == nil) then
            	destination = this:GetObjVar("SpawnLocation")
            	--DebugMessage("Fail")
            else
				destination = destinationObject:GetLoc()
			end

            this:PathTo(destination,1.0,"GoToGravestone")
        end,

        OnArrived = function (success)
        	if (AI.MainTarget ~= nil) then return end
        	--DebugMessage("OnArrived executed (gravestone)" .. tostring(success))
            if (AI.StateMachine.CurState ~= "GoToGravestone") then
            	if (AI.StateMachine.CurState ~= "Idle") then
            		DecideIdleState()
            	end
                return 
            end
            if( destinationObject ~= nil ) then 
                FaceObject(this,destinationObject)
                this:PlayAnimation("fidget")
            end
            DecideIdleState()
        end,
    }

--has the variable Visible to All set to true so he isn't really cloaked, it just appears like that.
RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if(usedType ~= "Interact") then return end
		if (not CanUseNPC(user)) then return end
		
		GetAttention(user)
		--user:SendMessage("StartQuest","GraveyardQuest")
		local introState = user:GetObjVar("WilliesOpinion")
		if (introState == nil) then

			text = "Oi! What in Pyro's name're you be doing here! " 
			.."[$2217]"
			.."[$2218]"
			response = {}
			response.text = "Sorry."
			response.handle = "Oops"
			user:SetObjVar("WilliesOpinion","GetLost")
			responses = {response}
			NPCInteraction(text,this,user,"WillieIntro",responses)

		elseif (introState == "GetLost") then		

			local hasNote = HasExplorationQuestNote(user)

			text = "[$2219]"

			response = {}

			if (not hasNote) then

				response[1] = {}
				response[1].text = "What is going on here?"
				response[1].handle = "Question" 

				response[2] = {}
				response[2].text = "Tell me about yourself."
				response[2].handle = "Question2" 

				response[3] = {}
				response[3].text = "I need your help."
				response[3].handle = "Question3" 

				response[4] = {}
				response[4].text = "Goodbye."
				response[4].handle = "" 

			else

				response[1] = {}
				response[1].text = "I have a letter for you."
				response[1].handle = "MasonContactNote" 

				response[2] = {}
				response[2].text = "Goodbye."
				response[2].handle = "" 

			end

			responses = {response}

			NPCInteraction(text,this,user,"WillieTalk",response)

		elseif (introState == "ScrewYou") then		
			AI.MainTarget = nil
			this:SendMessage("EndCombatMessage")

			text = "[$2220]"
			response = {}
			response.text = "Sorry."
			response.handle = "Oops"
			user:SetObjVar("WilliesOpinion","GetLost")
			responses = {response}
			NPCInteraction(text,this,user,"WillieIntro",responses)

		end
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "WillieIntro",
	function (user,buttonId)
		if (not CanUseNPC(user)) then return end

			local hasNote = HasExplorationQuestNote(user)
			GetAttention(user)
			text = "[$2221]"

			response = {}

			if (not hasNote) then

				response[1] = {}
				response[1].text = "What is going on here?"
				response[1].handle = "Question" 

				response[2] = {}
				response[2].text = "Tell me about yourself."
				response[2].handle = "Question2" 

				response[3] = {}
				response[3].text = "I need your help."
				response[3].handle = "Question3" 

				response[4] = {}
				response[4].text = "Goodbye."
				response[4].handle = "" 

			else

				response[1] = {}
				response[1].text = "I have a letter for you."
				response[1].handle = "MasonContactNote" 

				response[2] = {}
				response[2].text = "Goodbye."
				response[2].handle = "" 

			end

			NPCInteraction(text,this,user,"WillieTalk",response)
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "WillieTalk",
	function (user,buttonId)
		if (not CanUseNPC(user)) then return end

		GetAttention(user)
		if(buttonId == "Question") then--What is going on here?

			text = "[$2222]"
			
			response = {}

			response[1] = {}
			response[1].text = "Why are the dead rising?"
			response[1].handle = "WhyDead" 

			response[2] = {}
			response[2].text = "How do I stop the Dead?"
			response[2].handle = "StopTheDead"

			response[3] = {}
			response[3].text = "Why are there demons here?"
			response[3].handle = "WhyDemons" 

			response[4] = {}
			response[4].text = "Nevermind."
			response[4].handle = "Nevermind"

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Question2") then

			text = "[$2223]"
			
			response = {}

			response[1] = {}
			response[1].text = "Who are you?"
			response[1].handle = "Who" 

			response[2] = {}
			response[2].text = "What are you doing here?"
			response[2].handle = "What"

			response[3] = {}
			response[3].text = "Why haven't you left?"
			response[3].handle = "Why" 

			response[4] = {}
			response[4].text = "Nevermind."
			response[4].handle = "Nevermind"

			NPCInteraction(text,this,user,"Question",response)

		end
		if(buttonId == "Question3") then

			text = "[$2224]"

			response = {}

			response[1] = {}
			response[1].text = "How do I stop the dead?"
			response[1].handle = "StopTheDead" 

			response[2] = {}
			response[2].text = "Can I talk to the Dead?"
			response[2].handle = "Commune"

			response[3] = {}
			response[3].text = "Who else can help me here?"
			response[3].handle = "WhoElse" 

			response[4] = {}
			response[4].text = "Nevermind."
			response[4].handle = "Nevermind"

			NPCInteraction(text,this,user,"Question",response)
		end
		if (buttonId == "MasonContactNote") then

			local backpack = user:GetEquippedObject("Backpack")
			QuickDialogMessage(this,user,"[$2225]")
			noteContents = "[$2226]"
			CreateObjInBackpack(user,"scroll_readable","ContactNote","MasonNote",noteContents) 
			local NoteObject = FindItemInContainerRecursive(backpack,function (item)
				return item:HasObjVar("MasonContactNote") 
				-- body
			end)
			if (NoteObject ~= nil) then NoteObject:Destroy() end
			user:SetObjVar("WillieFinished",true)

		end
	end)

RegisterEventHandler(EventType.CreatedObject,"ContactNote",
    function(success,objRef,objVarName,noteContents)
        if (success) then
            objRef:SetObjVar(objVarName,true)
            objRef:SendMessage("WriteNote",noteContents)
        end
    end)

RegisterEventHandler(EventType.DynamicWindowResponse, "Question",
	function (user,buttonId)
		if (not CanUseNPC(user)) then return end
		GetAttention(user)
		if(buttonId == "Nevermind") then

			text="Alright then, what else do you want?"

			response = {}

			response[1] = {}
			response[1].text = "What is going on here?"
			response[1].handle = "Question" 

			response[2] = {}
			response[2].text = "Tell me about yourself."
			response[2].handle = "Question2" 

			response[3] = {}
			response[3].text = "I need your help."
			response[3].handle = "Question3" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"WillieTalk",response)

		end
		if(buttonId == "Question2") then

			text = "[$2227]"

			response = {}

			response[1] = {}
			response[1].text = "Who are you?"
			response[1].handle = "Who" 

			response[2] = {}
			response[2].text = "What are you doing here?"
			response[2].handle = "What"

			response[3] = {}
			response[3].text = "Why haven't you left?"
			response[3].handle = "Why" 

			response[4] = {}
			response[4].text = "Nevermind."
			response[4].handle = "Nevermind"

			NPCInteraction(text,this,user,"Question",response)

		end
		if(buttonId == "WhyDead") then

			text="Nobody knows, at least the ones who made it here. "
			.."[$2228]"
			.."[$2229]"

			response = {}

			response[1] = {}
			response[1].text = "Why don't they attack you?"
			response[1].handle = "WhyFriendly" 

			response[2] = {}
			response[2].text = "Tell me about the Void God."
			response[2].handle = "VoidGod" 

			response[3] = {}
			response[3].text = "Thanks."
			response[3].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)			
		end
		if(buttonId == "WhyDemons") then

			text="[$2230]"
			.."[$2231]"
			.."[$2232]"

			response = {}

			response[1] = {}
			response[1].text = "Thanks."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)	

		end
		if(buttonId == "Who") then

			text="[$2233]"
			.."[$2234]"
			.."[$2235]"

			response = {}

			response[1] = {}
			response[1].text = "That's great."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)	
					
		end
		if(buttonId == "What") then

			text="[$2236]"
				.."[$2237]"

			response = {}

			response[1] = {}
			response[1].text = "You're insane."
			response[1].handle = "InsaneHeSays" 

			response[2] = {}
			response[2].text = "Tell me more about yourself."
			response[2].handle = "Question2" 

			response[3] = {}
			response[3].text = "Nevermind."
			response[3].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)	

		end
		if(buttonId == "Why") then

			text="[$2238]"
			
			response = {}

			response[1] = {}
			response[1].text = "Right."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)	
		end
		if(buttonId == "Commune") then

			user:SendMessage("AdvanceQuest","GraveyardQuest","SearchGraveyard")
			--DFB TODO: Add multiple riddles for varied locations
			text="[$2239]"
			.."\n\nDark as night on the eve"
			.."\nSpirits stay still and heave"
			.."\nAs a dragon is the grave"
			.."\nOnly a sorcerer's third eye is what it takes"

			response = {}

			response[1] = {}
			response[1].text = "Right."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)			
		end

		if(buttonId == "WhoElse") then
			text="[$2240]"

			response = {}

			response[1] = {}
			response[1].text = "Right."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)			
		end

		if(buttonId == "WhyFriendly") then
			text= "[$2241]"

			response = {}

			response[1] = {}
			response[1].text = "Right."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)			
		end

		if(buttonId == "VoidGod") then
			text= "[$2242]"
			.."[$2243]"

			response = {}

			response[1] = {}
			response[1].text = "Woah."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)			
		end

		if(buttonId == "InsaneHeSays") then
			text= "[$2244]"

			response = {}

			response[1] = {}
			response[1].text = "Uh... Ok."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)			
		end

		if(buttonId == "StopTheDead") then
			text= "[$2245]"

			response = {}

			response[1] = {}
			response[1].text = "Uh... Ok."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)			
		end
	end)

RegisterEventHandler(EventType.Arrived, "GoToGravestone",AI.StateMachine.AllStates.GoToGravestone.OnArrived)
RegisterEventHandler(EventType.Arrived, "Wander", AI.StateMachine.AllStates.Wander.OnArrived)
