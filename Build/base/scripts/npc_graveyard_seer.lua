require 'base_ai_mob'
require 'base_ai_intelligent'
--require 'base_ai_sleeping'
require "incl_dialogwindow"
require 'incl_faction'
require 'base_npc_extensions'

AI.Settings.Leash = true
AI.Settings.StationedLeash = true


--npc's should all have this
function IsFriend(target)
    --My only enemy is the enemy
    if (AI.InAggroList(target)) then
        return false
    else
        return true
    end
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

RegisterEventHandler(EventType.CreatedObject,"ContactNote",
    function(success,objRef,objVarName,noteContents)
        if (success) then
            objRef:SendMessage("WriteNote","[$2189]")
        end
    end)

--has the variable Visible to All set to true so he isn't really cloaked, it just appears like that.
RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if(usedType ~= "Interact") then return end
		if (not CanUseNPC(user)) then return end
		
		GetAttention(user)
		favorability = GetFaction(user)
		if (favorability == nil) then favorability = 0 end
		local introState = user:GetObjVar("GulthanOpinion")
		--new person
		if (GetPlayerQuestState(user,"FoundersQuest") == "TalkToGulthan") then
			DialogReturnMessage(this,user,"[$2190]")
			user:SendMessage("NPCInteraction",this)
			return
		end
		if (GetPlayerQuestState(user,"FoundersQuest") == "ReturnToGolthan") then
			DialogReturnMessage(this,user,"[$2191]")
    		CreateObjInBackpack(user,"scroll_readable","ContactNote") 
			user:SendMessage("NPCInteraction",this)
			return
		end
		
		if (favorability < 0) then		

			text = "[$2192]" 

			response = {}

			response[1] = {}
			response[1].text = "Wait, you're glad?"
			response[1].handle = "What" 

			response[4] = {}
			response[4].text = "Right."
			response[4].handle = "" 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)

		elseif (introState == nil and favorability >= 0) then

			text = "[$2193]"

			response = {}

			response[1] = {}
			response[1].text = "How do you know that?"
			response[1].handle = "How" 

			response[2] = {}
			response[2].text = "Who are you?"
			response[2].handle = "Who" 

			response[3] = {}
			response[3].text = "I have a question."
			response[3].handle = "Question" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			user:SetObjVar("GulthanOpinion","Greetings")

			NPCInteraction(text,this,user,"Question",response)

		--completed a mission to kill an escaped slave or sold 3 or more slaves
		elseif (introState == "GoodFriend" and (favorability >= 0)) then

			text = "[$2194]"

			response = {}

			response[1] = {}
			response[1].text = "I need your help."
			response[1].handle = "Help" 

			response[2] = {}
			response[2].text = "Who are you?"
			response[2].handle = "Who" 

			response[3] = {}
			response[3].text = "I have a question."
			response[3].handle = "Question" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)

		--returning customer, not a cult member
		elseif (introState ~= nil and (favorability < 10 and favorability >= 0)) then

			text = "[$2195]"

			response = {}

			response[1] = {}
			response[1].text = "I need your help."
			response[1].handle = "Help" 

			response[2] = {}
			response[2].text = "Who are you?"
			response[2].handle = "Who" 

			response[3] = {}
			response[3].text = "I have a question."
			response[3].handle = "Question" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			user:SetObjVar("GulthanOpinion","Greetings")

			NPCInteraction(text,this,user,"Question",response)

		--returning customer, cult member
		elseif (introState ~= nil and (favorability > 10)) then
			
			text = "[$2196]"

			response = {}

			response[1] = {}
			response[1].text = "I need your help."
			response[1].handle = "Help" 

			response[2] = {}
			response[2].text = "Who are you?"
			response[2].handle = "Who" 

			response[3] = {}
			response[3].text = "I have a question."
			response[3].handle = "Question" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)

		elseif (introState == "Mission") then	

			text = "Have you accomplished what I have asked of you?"

			response = {}

			response[1] = {}
			response[1].text = "I need your help."
			response[1].handle = "Help" 

			response[2] = {}
			response[2].text = "Yes I have."
			response[2].handle = "MissionAccomplished" 

			response[3] = {}
			response[3].text = "I have a question."
			response[3].handle = "Question" 

			response[4] = {}
			response[4].text = "Not yet."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)
		end
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "Question",
	function (user,buttonId)
		GetAttention(user)
		if (not CanUseNPC(user)) then return end

		local opinionOfUser = user:GetObjVar("GulthanOpinion")

		if (favorability == nil) then favorability = 0 end

		if (buttonId == "Nevermind") then
			
			text="Anything else, outsider."

			response = {}

			response[1] = {}
			response[1].text = "I need your help."
			response[1].handle = "Help" 

			response[2] = {}
			response[2].text = "Who are you?"
			response[2].handle = "Who" 

			response[3] = {}
			response[3].text = "I have a question."
			response[3].handle = "Question" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Who") then

			text="[$2197]"

			response = {}

			response[1] = {}
			response[1].text = "What have you seen?"
			response[1].handle = "Seen" 

			response[2] = {}
			response[2].text = "Why do you do this?"
			response[2].handle = "Why" 

			response[3] = {}
			response[3].text = "Tell me your story."
			response[3].handle = "LifeStory" 

			response[4] = {}
			response[4].text = "Nevermind."
			response[4].handle = "Nevermind" 


			NPCInteraction(text,this,user,"Question",response)

		end
		if(buttonId == "What") then

				text="[$2198]"
				.."[$2199]"
				.."[$2200]"
				.."[$2201]"

				response = {}

				response[2] = {}
				response[2].text = "Sure thing."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Why") then

				text="[$2202]"

				response = {}

				response[2] = {}
				response[2].text = "Right."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Question") then

				text="[$2203]"

				response = {}

				response[1] = {}
				response[1].text = "What have you seen?"
				response[1].handle = "Seen" 

				response[2] = {}
				response[2].text = "Why are you in the graveyard?"
				response[2].handle = "Why" 

				response[3] = {}
				response[3].text = "Why is the Cult so hostile?"
				response[3].handle = "HostileCult" 

				response[4] = {}
				response[4].text = "Nevermind."
				response[4].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Help") then

				text="What do you seek, outsider?"

				response = {}

				response[1] = {}
				response[1].text = "I need to get into the Ruins."
				response[1].handle = "Ruins" 

				response[2] = {}
				response[2].text = "I need to ... see spirits."
				response[2].handle = "Ghosts" 

				response[3] = {}
				response[3].text = "I need to defeat the demon."
				response[3].handle = "Demon" 

				response[4] = {}
				response[4].text = "Nevermind."
				response[4].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Ruins") then

				text="[$2204]"

				response = {}

				response[2] = {}
				response[2].text = "Right."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "How") then

				text="[$2205]"
				.."[$2206]"
				.."[$2207]"

				response = {}

				response[2] = {}
				response[2].text = "Right."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Ghosts") then

				text="[$2208]"
				.."[$2209]"
				.."[$2210]"
				.."[$2211]"

				response = {}

				response[2] = {}
				response[2].text = "Right."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Demon") then

				text="[$2212]"

				response = {}

				response[2] = {}
				response[2].text = "Right."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "HostileCult") then

				text="[$2213]"

				response = {}

				response[1] = {}
				response[1].text = "People are born into the cult?"
				response[1].handle = "LifeStory" 

				response[2] = {}
				response[2].text = "Ah."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "LifeStory") then

				text="[$2214]"

				response = {}

				response[2] = {}
				response[2].text = "Thanks."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Seen") then

				text = "[$2215]"

				response = {}

				response[1] = {}
				response[1].text = "What about me?"
				response[1].handle = "AboutMe" 

				response[2] = {}
				response[2].text = "Uh, nevermind."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "AboutMe") then

				text="[$2216]"

				response = {}

				response[2] = {}
				response[2].text = "Thanks."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
	end)
