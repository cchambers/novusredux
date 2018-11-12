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

--has the variable Visible to All set to true so he isn't really cloaked, it just appears like that.
RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if (not CanUseNPC(user)) then return end
		if(usedType ~= "Interact") then return end

		text="[$2247]"

		response = {}


		if (GetPlayerQuestState(user,"FoundersQuest") == "SpeakToHermit" or GetPlayerQuestState(user,"FoundersQuest") == "ReturnForReward") then
			response[1] = {}
			response[1].text = "Give me a Pedesii's Stone."
			response[1].handle = "FoundersInteraction" 
		elseif (GetPlayerQuestState(user,"FoundersQuest2") == "SpeakToHermit") then
			response[1] = {}
			response[1].text = "I was told to speak to you."
			response[1].handle = "SpawnGem" 
		else
			response[1] = {}
			response[1].text = "Yes."
			response[1].handle = "Yes" 
		end

		response[3] = {}
		response[3].text = "No..."
		response[3].handle = "No" 

		NPCInteraction(text,this,user,"Responses",response)
	end)

RegisterEventHandler(EventType.DynamicWindowResponse,"Responses",function (user,buttonID)
	if( user == nil or not user:IsValid()) then return end
	if (not CanUseNPC(user)) then return end
	if (buttonID == "FoundersInteraction") then
		CreateObjInBackpack(user,"stone_of_pedesii","stone_created")
		DialogReturnMessage(this,user,"[$2248]","Wonderful. Finally.")
		user:SendMessage("NPCInteraction",this)
	elseif(buttonID == "SpawnGem") then
		user:SendMessage("NPCInteraction",this)
		DialogReturnMessage(this,user,"[$2249]")
	elseif (buttonID == "Yes") then
		DialogReturnMessage(this,user,"[$2250]","Whatever you say.")
	elseif (buttonID == "No") then
		this:NpcSpeech("Then so be it. Bother me not.")
	end
end)
