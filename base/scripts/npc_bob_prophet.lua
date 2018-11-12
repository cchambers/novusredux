require 'base_ai_mob'
require 'base_ai_intelligent'
--require 'base_ai_sleeping'
require "incl_dialogwindow"
require 'base_npc_extensions'

AI.Settings.Leash = true
AI.Settings.StationedLeash = true

if not this:HasModule("guard_protect") then
	this:AddModule("guard_protect")
end

AI.RandomAnimations = {
	"cast_heal",
	"dance_1",
	"wave",
	"was_hit",
	"cast",
	"followthrough",
}

AI.ThingsToSay = {
	"[$2026]",
	"[$2027]",
	"[$2028]",
	"[$2029]",
	"[$2030]",
	"[$2031]",
	"[$2032]",
	"[$2033]",
	"[$2034]",
	"[$2035]",
	"[$2036]",
}

AI.ThingsToTell = 
{
	"[$2037]",
	"[$2038]",
	"[$2039]",
	"[$2040]",
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

AI.StateMachine.AllStates.Idle = { 
        GetPulseFrequencyMS = function() return math.random(8000,15000) end,
        AiPulse = function() 
			this:PlayAnimation(AI.RandomAnimations[math.random(1,#AI.RandomAnimations)])
			this:NpcSpeech(AI.ThingsToSay[math.random(1,#AI.ThingsToSay)])
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

--has the variable Visible to All set to true so he isn't really cloaked, it just appears like that.
RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if(usedType ~= "Interact") then return end
		if (not CanUseNPC(user)) then return end
		
		GetAttention(user)		
			local index = math.random(1,#AI.ThingsToSay)
			this:PlayAnimation(AI.RandomAnimations[math.random(1,#AI.RandomAnimations)])
			text = AI.ThingsToSay[index]
			--add option to talk to rufus
			if (index == 11) then user:SetObjVar("RufusAboutBob",true) end

			response = {}

			response[1] = {}
			response[1].text = "What?"
			response[1].handle = "" 

			response[2] = {}
			response[2].text = "What are you doing."
			response[2].handle = "What" 

			response[3] = {}
			response[3].text = "I have a question..."
			response[3].handle = "Question" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "Question",
	function (user,buttonId)
		if (not CanUseNPC(user)) then return end
		if(buttonId == "What") then
			if (math.random(1,5) ~= 1) then
				text = AI.ThingsToTell[math.random(1,#AI.ThingsToTell)]

				response = {}

				response[4] = {}
				response[4].text = "...Right."
				response[4].handle = "" 

				responses = {response}

				NPCInteraction(text,this,user,"Question",response)

			else
				text="[$2041]"

	            this:StopMoving()
	            this:PlayAnimation("cast_heal")
	            this:PlayEffect("PrimedVoid",300)

				response = {}

				response[3] = {}
				response[3].text = "...Uh."
				response[3].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)	

			end
		end
	end)

--RegisterEventHandler(EventType.ClientTargetGameObjResponse, "decipher", 
--	function(target,user)
--	end)
