require 'base_ai_mob'
require 'base_ai_intelligent'
--require 'base_ai_sleeping'
require "incl_dialogwindow"
require 'incl_faction'

AI.Settings.Leash = true
AI.Settings.StationedLeash = true

--npc's should all have this
function IsFriend(target)
    --My only enemy is the enemy
    return false
end

this:SendMessage("ProcessTrueDamage", this, 5000, true) 

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

RegisterEventHandler(EventType.Message,"HasDiedMessage",function()
    AddUseCase(this,"Investigate",true)
end)

--has the variable Visible to All set to true so he isn't really cloaked, it just appears like that.
RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if(usedType ~= "Investigate") then return end
		user:SystemMessage("[$2246]")
        user:SendMessage("AdvanceQuest","InvestigateMurderQuest","TalkToInaius","InvestigateCorpse")
	end)

RegisterEventHandler(EventType.EnterView,"questView",
    function (user)
        user:SendMessage("StartQuest","InvestigateMurderQuest")
    end)
AddView("questView", SearchMobileInRange(7))

RegisterEventHandler(EventType.CreatedObject,"portal_created",function (success,objRef )
    this:SetObjVar("Portal",objRef)
    Decay(objRef)
end)

RegisterEventHandler(EventType.DynamicWindowResponse,"Responses",function (user,buttonID)
	
end)