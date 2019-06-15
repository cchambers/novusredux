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

RegisterEventHandler(EventType.LoadedFromBackup,"", function()
	this:DelObjVar("PortalActive")
end)

--has the variable Visible to All set to true so he isn't really cloaked, it just appears like that.
RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if(usedType ~= "Interact") then return end

		text="[$2042]"

		response = {}

		response[1] = {}
		response[1].text = "Yes."
		response[1].handle = "SpawnPortal" 

		response[2] = {}
		response[2].text = "No..."
		response[2].handle = "Nevermind" 

		NPCInteraction(text,this,user,"Responses",response)
	end)

RegisterEventHandler(EventType.Timer, "PortalTimer", function()
	this:SetObjVar("PortalActive",false)
end)

RegisterEventHandler(EventType.DynamicWindowResponse,"Responses",function (user,buttonID)
	if( user == nil or not user:IsValid()) then return end
	if (not CanUseNPC(user)) then return end
	if (buttonID == "SpawnPortal") then
	    if (this:HasObjVar("PortalActive") == false or this:GetObjVar("PortalActive") == false) then
		    this:NpcSpeech("Use this portal then...")
		    user:CloseDynamicWindow("Responses")
		    this:PlayAnimation("cast_heal")

	    	local destRegionAddress = nil
	    	local destination = nil
	    	destRegionAddress, destination = GetStaticPortalSpawn(this:GetObjVar("StaticDestination"))

	    	if (destRegionAddress == nil or destination == nil) then
	    		local destNotValid = true
	    		for j, k in pairs (ServerSettings.Teleport.Destination) do
	    			destRegionAddress, destination = GetStaticPortalSpawn(j)
	    			if (destRegionAddress ~= nil and destination ~= nil) then
	    				destNotValid = false
	    			end
	    		end
	    	end

	    	if (destNotValid) then
	    		this:NpcSpeech("Odd, I couldn't seem to summon the portal.")
    		else
    			this:SetObjVar("PortalActive",true)
    			this:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "PortalTimer")
	    		PlayEffectAtLoc("TeleportFromEffect",Loc(24.64, -0.3892002, 8.56))
				CreateObj("portal_red",Loc(24.64, -0.3892002, 8.56),"transfer_portal_created")	
				RegisterSingleEventHandler(EventType.CreatedObject,"transfer_portal_created",
					function (success,objRef)
					if(success) then
						objRef:SetObjVar("Destination",destination)
						objRef:SetObjVar("RegionAddress",destRegionAddress)
						Decay(objRef, 10)
					end
				end)
    		end
	    else
	    	this:NpcSpeech("I've already summoned a portal. Just use that one.")
	    end

	elseif (buttonID == "Why") then
		QuickDialogMessage(this,user,"[$2043]")
	elseif (buttonID == "Who") then
		QuickDialogMessage(this,user,"[$2044]")
	elseif (buttonID == "What") then
		QuickDialogMessage(this,user,"[$2045]")
	elseif (buttonID == "Nevermind") then
		
		text="Oh. What do you want then?"

		response = {}

		response[1] = {}
		response[1].text = "Why are you helping me?"
		response[1].handle = "Why" 

		response[2] = {}
		response[2].text = "What is this place?"
		response[2].handle = "What" 

		response[3] = {}
		response[3].text = "Who are you?"
		response[3].handle = "Who" 

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