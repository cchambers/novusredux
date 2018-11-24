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
		if(usedType ~= "Interact") then return end

		text="[$3317]"

		response = {}

		response[1] = {}
		response[1].text = "Yes."
		response[1].handle = "SpawnPortal" 

		response[2] = {}
		response[2].text = "No..."
		response[2].handle = "Nevermind" 

		NPCInteraction(text,this,user,"Responses",response)
	end)

RegisterEventHandler(EventType.CreatedObject,"portal_created",function (success,objRef )
    this:SetObjVar("Portal",objRef)
   	Decay(objRef)
end)

RegisterEventHandler(EventType.DynamicWindowResponse,"Responses",function (user,buttonID)
	if( user == nil or not user:IsValid()) then return end
	if (not CanUseNPC(user)) then return end
	if (buttonID == "SpawnPortal") then
	    this:NpcSpeech("[$3318]")
	    this:PlayAnimation("cast_heal")
	    DebugMessage("Getting here ")
	    if (this:GetObjVar("Portal") == nil or not this:GetObjVar("Portal"):IsValid()) then
	    	DebugMessage("Getting here also")
	        CreateObj("teleporter_to_outlands_smuggler",Loc(-307.66, 0, -3.99),"portal_created")
	    end
	elseif (buttonID == "Why") then
		QuickDialogMessage(this,user,"[$3319]")
	elseif (buttonID == "Nevermind") then
		
		text="Oh. What do you want then?"

		response = {}

		response[1] = {}
		response[1].text = "Why are you helping me?"
		response[1].handle = "Why" 

		response[4] = {}
		response[4].text = "Goodbye."
		response[4].handle = "" 

		NPCInteraction(text,this,user,"Responses",response)
	end
end)

RegisterSingleEventHandler(EventType.ModuleAttached,GetCurrentModule(),
    function( ... )
        AddUseCase(this,"Interact",true)
    end)