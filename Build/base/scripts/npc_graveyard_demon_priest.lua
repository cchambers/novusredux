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

function GuardsKillHim(target)
	target:SetObjVar("DemonGuyIntro","Attack")
	this:NpcSpeech("Kill him!!!")
	this:PlayAnimation("point")
	FaceObject(this,target)
	target:DelObjVar("Initiate|Kho")
	this:SendMessage("AttackEnemy",target)
    local nearby = FindObjects(SearchMulti(
    {
        SearchMobileInRange(20), --in 10 units
        SearchObjVar("MobileTeamType","UndeadGraveyard"), --find everything that serves kho
    }))
    for i,j in pairs (nearby) do
    	--DebugMessage("Sending AttackEnemy")
        j:SendMessage("AttackEnemy",target) --defend me
    end
end

--has the variable Visible to All set to true so he isn't really cloaked, it just appears like that.
RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if (not CanUseNPC(user)) then return end
		if(usedType ~= "Interact") then return end
		
		GetAttention(user)
		--new person
			
		text = "[$2165]"

		response = {}

		response[1] = {}
		response[1].text = "Who are you?"
		response[1].handle = "Who" 

		response[2] = {}
		response[2].text = "Why are you here?"
		response[2].handle = "Why" 

		response[3] = {}
		response[3].text = "You worship Kho?"
		response[3].handle = "Worship" 

		response[4] = {}
		response[4].text = "What is this thing here?"
		response[4].handle = "Catacombs" 

		response[5] = {}
		response[5].text = "Goodbye."
		response[5].handle = "" 

		user:SetObjVar("DemonGuyIntro","Greetings")

		NPCInteraction(text,this,user,"Question",response)
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "Question",
	function (user,buttonId)
		if (not CanUseNPC(user)) then return end
		GetAttention(user)

		local opinionOfUser = user:GetObjVar("DemonGuyIntro")

		if (favorability == nil) then favorability = 0 end

		if(buttonId == "Attack") then

			GuardsKillHim(user)
		end
		if (buttonId == "Nevermind") then
			
			text="[$2166]"

			response = {}

			response[1] = {}
			response[1].text = "Who are you?"
			response[1].handle = "Who" 

			response[2] = {}
			response[2].text = "Why are you here?"
			response[2].handle = "Why" 

			response[3] = {}
			response[3].text = "You worship Kho?"
			response[3].handle = "Worship" 

			response[4] = {}
			response[4].text = "What is this thing here?"
			response[4].handle = "Catacombs" 

			response[5] = {}
			response[5].text = "Goodbye."
			response[5].handle = "" 

			NPCInteraction(text,this,user,"Question",response)
		end
		if (buttonId == "Nevermind2") then
			
			text="[$2167]"

			response = {}

			response[1] = {}
			response[1].text = "Who are you?"
			response[1].handle = "Who" 

			response[2] = {}
			response[2].text = "Why are you here?"
			response[2].handle = "Why" 

			response[3] = {}
			response[3].text = "You worship Kho?"
			response[3].handle = "Worship" 

			response[4] = {}
			response[4].text = "What is this thing here?"
			response[4].handle = "Catacombs" 

			response[5] = {}
			response[5].text = "Goodbye."
			response[5].handle = "" 

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Why") then

			text = "[$2168]"
			.."[$2169]"
			.."[$2170]"
			.."[$2171]"
			.."[$2172]"

			response = {}

			response[1] = {}
			response[1].text = "Why do the dead rise?"
			response[1].handle = "TheDead" 

			response[2] = {}
			response[2].text = "You've been brainwashed."
			response[2].handle = "Brainwashed" 

			response[3] = {}
			response[3].text = "Goodbye."
			response[3].handle = "" 

			NPCInteraction(text,this,user,"Question",response,nil,600)
		end


		if(buttonId == "Worship") then

			text = "[$2173]"

			response = {}

			response[2] = {}
			response[2].text = "Is Kho evil?"
			response[2].handle = "Evil?" 

			response[3] = {}
			response[3].text = "Right."
			response[3].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)

		end
		if(buttonId == "Join") then
			this:SetObjVar("Initiate|Kho",true)
			GetAttention(user)
			this:PlayAnimation("Dance_GuitarSolo")

			text = "[$2174]"

			response = {}

			response[1] = {}
			response[1].text = "...Thanks brother."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)

		end
		if(buttonId == "Deserve") then
			GetAttention(user)

			this:PlayAnimation("point")

			text = "[$2175]"

			response = {}

			response[1] = {}
			response[1].text = "Whatever."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)

		end
		if(buttonId == "Activate") then
			user:SendMessage("NPCInteraction",this)
			--DFB TODO: Localize this once we have the second alpha build out.
			--text = "[$2176]"
			text = "You seek ETERNAL DAMNATION, and ETERNAL TORTURE that is THE VOID for those who lack faith such as yourself?!? Let me tell you that beyond this portal, there is only SUFFERING for YOU!!!\n\n...I know you seek justice for the townsfolk, do you not? It will please Kho to bring you his torments. Heed these words:\n\n The bones of ten souls already condemned forever are needed. Place them in the center of the Altar of His Hatred. Then the three Skulls of Passing are needed, the Skull of the Void, the Skull of Pestilence, and the Skull of Deception. These cursed artifacts are found in the halls of the cursed depths of Pestlience, Contempt, and Deception, various names given by the unbelievers to the corrupted tombs of Kho's most valued servants. Bring these cursed artifacts here, and THEN you will see... what lies beyond for you. Go now. Embrace your curiosity, unbeliever."
			--if (this:HasObjVar("Initiate|Kho")) then
			--	text = "[$2177]"
			--end
			user:SendMessage("AdvanceQuest","CatacombsReDiscoveryQuest","FindBones","TalkToGregory")
			response = {}

			response[1] = {}
			response[1].text = "You'll get what you deserve."
			response[1].handle = "Deserve" 

			response[2] = {}
			response[2].text = "...Err...Thanks."
			response[2].handle = "Nevermind" 

			response[3] = {}
			response[3].text = "I wish to join you... with Kho."
			response[3].handle = "Join" 

			NPCInteraction(text,this,user,"Question",response)

		end

		if(buttonId == "Catacombs") then

			text = "[$2178]"

			response = {}

			response[1] = {}
			response[1].text = "...How do I activate it?"
			response[1].handle = "Activate"

			response[2] = {}
			response[2].text = "...Why???"
			response[2].handle = "TheDead"

			response[3] = {}
			response[3].text = "...How dare you! Stop this madness!"
			response[3].handle = "Attack"

			response[4] = {}
			response[4].text = "...Ok."
			response[4].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)
		end

		if(buttonId == "Evil?") then

			text = "[$2179]"

			response = {}

			response[3] = {}
			response[3].text = "Right."
			response[3].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Who") then

			text = "[$2180]"

			response = {}

			response[1] = {}
			response[1].text = "Messages?"
			response[1].handle = "Say" 

			response[3] = {}
			response[3].text = "Right."
			response[3].handle = "Nevermind" 


			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Say") then
			local WayunFaction = GetFaction(user,"Wayun")
			local statsObjVar = user:GetObjVar("LifetimePlayerStats") or {UndeadGraveyard = 0}
			local khoKills = user:GetObjVar("LifetimePlayerStats")["UndeadGraveyard"] or 0
			local openedPortal = user:GetObjVar("EnteredCatacombs")
			if (khoKills > 150 and WayunFaction > 10) then
				text = "[$2181]"

				this:PlayEffect("VoidAuraEffect",7.0)

				this:PlayAnimation("ThroatSlash")

				response = {}

				response[3] = {}
				response[3].text = "Right."
				response[3].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
			elseif (khoKills > 120) then
				text = "[$2182]"

				response = {}

				response[3] = {}
				response[3].text = "Right."
				response[3].handle = "Nevermind" 


				NPCInteraction(text,this,user,"Question",response)
			elseif (khoKills > 80) then
				text = "[$2183]"

				response = {}

				response[3] = {}
				response[3].text = "Right."
				response[3].handle = "Nevermind" 


				NPCInteraction(text,this,user,"Question",response)
			elseif (khoKills > 50) then
				text = "[$2184]"

				response = {}

				response[3] = {}
				response[3].text = "Right."
				response[3].handle = "Nevermind" 


				NPCInteraction(text,this,user,"Question",response)
			else
				text = "[$2185]"

				response = {}

				response[3] = {}
				response[3].text = "Right."
				response[3].handle = "Nevermind" 


				NPCInteraction(text,this,user,"Question",response)
			end
		end
		if(buttonId == "TheDead") then

			text = "[$2186]"
			if (this:HasObjVar("Initiate|Kho")) then
				text = "[$2187]"
			end
			response = {}

			response[3] = {}
			response[3].text = "Nevermind."
			response[3].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Brainwashed") then

			text = "[$2188]"

			response = {}

			response[2] = {}
			response[2].text = "No, you're delusional."
			response[2].handle = "Attack" 

			response[3] = {}
			response[3].text = "Sorry."
			response[3].handle = "Nevermind2" 

			NPCInteraction(text,this,user,"Question",response)
		end
	end)
