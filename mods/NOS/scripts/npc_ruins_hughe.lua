require 'NOS:base_ai_mob'
require 'NOS:base_ai_intelligent'
--require 'NOS:base_ai_sleeping'
require "NOS:incl_dialogwindow"
require 'NOS:incl_faction'

function IsFriend(target)
   return true
end

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

AI.StateMachine.AllStates.Wander = {
		RepeatState = true,
        OnEnterState = function()
			local regions = GetRegionsAtLoc(this:GetLoc())
			if (regions ~= nil and #regions > 0) then
				--DebugMessage(tostring(#regions) )
				curRegion = regions[math.random(1,#regions)]
			end
			if (curRegion ~= nil) then
            	WanderInRegion(curRegion,"Wander")
        	end
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

--has the variable Visible to All set to true so he isn't really cloaked, it just appears like that.
RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if(usedType ~= "Interact") then return end
		
		GetAttention(user)
		favorability = GetFaction(user)
		if (favorability == nil) then favorability = 0 end
		local introState = user:GetObjVar("HugheOpinion")
		--new person
		
		if (favorability < 0) then		

			text = "Get out of here! I don't want to be beaten again!" 

			response = {}

			response[4] = {}
			response[4].text = "You're free to go."
			response[4].handle = "FreeToGo" 

			response[4] = {}
			response[4].text = "Whatever."
			response[4].handle = "" 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)

		elseif (introState == nil and favorability >= 0) then

			text = "[$2272]"

			response = {}

			response[1] = {}
			response[1].text = "You're free to go."
			response[1].handle = "FreeToGo" 

			response[2] = {}
			response[2].text = "Who are you?"
			response[2].handle = "Who" 

			response[3] = {}
			response[3].text = "You are now my prisoner."
			response[3].handle = "TakeOwnership" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			user:SetObjVar("MysticOpinion","Greetings")

			NPCInteraction(text,this,user,"Question",response)

		--returning customer, not a cult member
		elseif (introState ~= nil and (favorability < 10 and favorability >= 0)) then

			text = "Hau'kommen strange one. How can I serve you?"

			response = {}

			response[1] = {}
			response[1].text = "You're free to go."
			response[1].handle = "FreeToGo" 

			response[2] = {}
			response[2].text = "Who are you?"
			response[2].handle = "Who" 

			response[3] = {}
			response[3].text = "You are now my prisoner."
			response[3].handle = "TakeOwnership" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			user:SetObjVar("MysticOpinion","Greetings")

			NPCInteraction(text,this,user,"Question",response)

		--returning customer, cult member
		elseif (introState ~= nil and (favorability > 10)) then
			
			text = "[$2273]"

			response = {}

			response[1] = {}
			response[1].text = "You're free to go."
			response[1].handle = "FreeToGo" 

			response[2] = {}
			response[2].text = "Who are you?"
			response[2].handle = "Who" 

			response[3] = {}
			response[3].text = "You are now my prisoner."
			response[3].handle = "TakeOwnership" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)
		end
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "Question",
	function (user,buttonId)
		GetAttention(user)

		local opinionOfUser = user:GetObjVar("MysticOpinion")

		favorability = GetFaction(user)
		if (favorability == nil) then favorability = 0 end

		if (buttonId == "Nevermind") then
			
			text="Is there anything I can do for you?"

			response = {}

			response[1] = {}
			response[1].text = "You're free to go."
			response[1].handle = "FreeToGo" 

			response[2] = {}
			response[2].text = "Who are you?"
			response[2].handle = "Who" 

			response[3] = {}
			response[3].text = "You are now my prisoner."
			response[3].handle = "TakeOwnership" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "FreeToGo") then

			text="[$2274]"

			response = {}

			response[1] = {}
			response[1].text = "But you're enslaved!"
			response[1].handle = "IOwnYou" 

			if (favorability > 10 ) then
				response[2] = {}
				response[2].text = "I am a cult member! You are mine!"
				response[2].handle = "IOwnYou" 
			end

			response[4] = {}
			response[4].text = "Whatever."
			response[4].handle = "Nevermind" 


			NPCInteraction(text,this,user,"Question",response)

		end
		if(buttonId == "Who") then

				text="[$2275]"

				response = {}

				response[2] = {}
				response[2].text = "Alright then..."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "TakeOwnership") then

				if (favorability < 10) then

				text="[$2276]"

				response = {}

				response[2] = {}
				response[2].text = "Ok then."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)

				elseif (favorability > 50) then

				text="[$2277]"

				response = {}

				response[2] = {}
				response[2].text = "I have a task for you."
				response[2].handle = "Command" 

				NPCInteraction(text,this,user,"Question",response)

				elseif (favorability > 10) then

				text="A member of the cult! I will do anything you ask!"

				response = {}

				response[2] = {}
				response[2].text = "I have a task for you."
				response[2].handle = "Command" 

				NPCInteraction(text,this,user,"Question",response)

				end
		end
		if(buttonId == "Command") then

				text="[$2278]"

				response = {}

				response[1] = {}
				response[1].text = "You are to accompany me."
				response[1].handle = "Recruit" 

				response[2] = {}
				response[2].text = "You are free to go."
				response[2].handle = "FreeToGo" 

				response[4] = {}
				response[4].text = "Nevermind."
				response[4].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Recruit") then

				text="[$2279]"

				response = {}

				response[4] = {}
				response[4].text = "Nevermind."
				response[4].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "IOwnYou") then

				text="[$2280]"

				response = {}

				response[2] = {}
				response[2].text = "Ok."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
	end)

RegisterSingleEventHandler(EventType.ModuleAttached,GetCurrentModule(),
    function( ... )
        AddUseCase(this,"Interact",true)
    end)