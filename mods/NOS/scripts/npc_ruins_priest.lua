require 'NOS:base_ai_mob'
require 'NOS:base_ai_intelligent'
--require 'NOS:base_ai_sleeping'
require 'NOS:incl_faction'
require 'NOS:incl_gametime'

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

--has the variable Visible to All set to true so he isn't really cloaked, it just appears like that.
RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if(usedType ~= "Interact") then return end
		user:SendMessage("NPCInteraction",this)
		GetAttention(user)
		favorability = GetFaction(user)
		if (favorability == nil) then favorability = 0 end
		local introState = user:GetObjVar("EnuasOpinion")
		--new person
		
		if (favorability < 0) then		

			this:SendMessage("AttackEnemy",user)

		elseif (introState == nil and favorability >= 0) then

			text = "[$2310]"

			response = {}

			response[1] = {}
			response[1].text = "I want to join the cult."
			response[1].handle = "Join" 

			response[2] = {}
			response[2].text = "Who are you?"
			response[2].handle = "Who" 

			response[3] = {}
			response[3].text = "I have a question."
			response[3].handle = "Question" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			user:SetObjVar("EnuasOpinion","Greetings")

			NPCInteraction(text,this,user,"Question",response)

		--returning customer, not a cult member
		elseif (introState ~= nil and (favorability < 10 and favorability >= 0)) then

			text = "Ah, the outsider returns! What can I do for you?"

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
			response[4].text = "I want to join the cult."
			response[4].handle = "Join" 

			response[5] = {}
			response[5].text = "Goodbye."
			response[5].handle = "" 

			user:SetObjVar("EnuasOpinion","Greetings")

			NPCInteraction(text,this,user,"Question",response)

		--returning customer, cult member
		elseif (introState ~= nil and (favorability >= 10)) then
			
			text = "[$2311]"

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
			response[4].text = "I want to join the cult."
			response[4].handle = "AlreadyAMember" 

			response[5] = {}
			response[5].text = "Goodbye."
			response[5].handle = "" 

			NPCInteraction(text,this,user,"Question",response)
		end
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "Question",
	function (user,buttonId)
		GetAttention(user)

		local opinionOfUser = user:GetObjVar("EnuasOpinion")

		if (favorability == nil) then favorability = 0 end

		if (buttonId == "Nevermind") then
			
			text="Anything else that I can do for you?"

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
		if(buttonId == "Question") then

			text="[$2312]"

			response = {}

			response[1] = {}
			response[1].text = "Who wrote the scriptures?"
			response[1].handle = "Learn" 

			response[2] = {}
			response[2].text = "What do you believe?"
			response[2].handle = "Believe" 

			--if (favorability < 10) then
			--	response[3] = {}
			--	response[3].text = "How can I join the Cult?"
			--	response[3].handle = "Join" 
			--else
			--	response[3] = {}
			--	response[3].text = "What do the scriptures say?"
			--	response[3].handle = "Knowledge" 
			--end

			response[4] = {}
			response[4].text = "Nevermind."
			response[4].handle = "Nevermind" 


			NPCInteraction(text,this,user,"Question",response)

		end
		if(buttonId == "Who") then

			text="[$2313]"

			response = {}

			response[1] = {}
			response[1].text = "What do the scriptures say?"
			response[1].handle = "Knowledge" 

			response[2] = {}
			response[2].text = "What do you believe?"
			response[2].handle = "Believe" 

			response[4] = {}
			response[4].text = "Nevermind."
			response[4].handle = "Nevermind" 


			NPCInteraction(text,this,user,"Question",response)

		end
		if (buttonId == "AlreadyAMember") then
			QuickDialogMessage(this,user,"[$2314]")
		end
		if(buttonId == "Believe") then

				text="[$2315]"

				response = {}

				response[2] = {}
				response[2].text = "Wow."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Learn") then

				text="[$2316]"

				response = {}

				response[1] = {}
				response[1].text = "Where can I find these tablets?"
				response[1].handle = "WhereTablets" 

				response[2] = {}
				response[2].text = "What do the scriptures say?"
				response[2].handle = "Knowledge" 

				response[3] = {}
				response[3].text = "That's great."
				response[3].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Help") then

			if (favorability < 10) then		

				text="[$2317]"

				response = {}

				response[2] = {}
				response[2].text = "Nevermind then."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)

			else

				text="What do you need help with, bretheren?"

				response = {}

				response[1] = {}
				response[1].text = "I need scriptures."
				response[1].handle = "BuyScripture" 

				response[2] = {}
				response[2].text = "I need artifacts."
				response[2].handle = "Artifacts" 

				response[2] = {}
				response[2].text = "I need money."
				response[2].handle = "GetLoan" 

				response[4] = {}
				response[4].text = "Nevermind."
				response[4].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
			end
		end
		--DebugMessage("buttonId is "..tostring(buttonId))
		if (buttonId == "BookOfAshunturath") then
			AttemptToSellScripture(user,"cultist_scripture_c")
		end
		if (buttonId == "BookOfIhauactu") then
			AttemptToSellScripture(user,"cultist_scripture_d")
		end
		if (buttonId == "BookOfKhutnartash") then
			AttemptToSellScripture(user,"cultist_scripture_e")
		end
		if (buttonId == "BookOfRthaugnaa") then
			AttemptToSellScripture(user,"cultist_scripture_f")
		end
		if(buttonId == "BuyScripture") then
			 text="[$2318]"

				response[1] = {}
				response[1].text = "[$2319]"
				response[1].handle = "BookOfAshunturath" 

				response[2] = {}
				response[2].text = "[00FF00]Book Of Ihauactu.[-][FFFF00](75 gold)[-]"
				response[2].handle = "BookOfIhauactu" 

				response[3] = {}
				response[3].text = "[$2320]"
				response[3].handle = "BookOfKhutnartash" 

				response[4] = {}
				response[4].text = "[$2321]"
				response[4].handle = "BookOfRthaugnaa" 
				--Ekignarhi
				response[5] = {}
				response[5].text = "Nevermind."
				response[5].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Artifacts") then
			text="[$2322]"

				response[1] = {}
				response[1].text = "Alright then.[FFFF00](Pay 44 gold)[-]"
				response[1].handle = "BuyArtifactMap" 

				response[2] = {}
				response[2].text = "Nevermind then."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "GetLoan") then
			text="[$2323]"
				.."[$2324]"
				.."[$2325]"
				.."[$2326]"
				.."[$2327]" --bad for your credit

				response = {}

				response[1] = {}
				response[1].text = "[$2328]"
				response[1].handle = "TakeLoan" 

				response[2] = {}
				response[2].text = "Nevermind then."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Join") then

				text="You will need to commit the Ritual of Shaganthu."
				.."[$2329]"
				.."[$2330]"
				.."[$2331]" 
				.."[$2332]"

				response = {}

				--response[1] = {}
				--response[1].text = "I'll take your offer up."
				--response[1].handle = "Accept" 

				response[2] = {}
				response[2].text = "That's sick and wrong!"
				response[2].handle = "Sick" 

				response[3] = {}
				response[3].text = "...Is there another way."
				response[3].handle = "OtherWay" 

				response[4] = {}
				response[4].text = "Sorry, but I'm not interested."
				response[4].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if (buttonId == "OtherWay") then
			QuickDialogMessage(this,user,"[$2333]")
		end
		if(buttonId == "Knowledge") then

			if (not user:GetObjVar("EnuasScroll")) then

				text="[$2334]"

				user:SetObjVar("EnuasScroll",true)

				response = {}

				response[2] = {}
				response[2].text = "Thanks."
				response[2].handle = "Nevermind" 

				user:SetObjVar("EnuasOpinion","Scripture")

				ChangeFactionByAmount(user,1)

				local backpackObj = user:GetEquippedObject("Backpack")  
				local dropPos = GetRandomDropPosition(backpackObj)
	    		CreateObjInContainer("cultist_scripture_a", backpackObj, dropPos, nil)
	            user:SystemMessage("You have received a piece of Cultist Scripture!","info")

				NPCInteraction(text,this,user,"Question",response)

			else
				text="[$2335]"

				response = {}

				response[2] = {}
				response[2].text = "Right."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
			end
		end
	end)

function AttemptToSellScripture(user,scripture)
	DebugMessage("Arrived")
	if (CountCoins(user) < 50) then
	    this:NpcSpeech("It seems you do not have enough, friend...")
	    return
	end
	DebugMessage("Scripture is "..tostring(scripture))
	RequestConsumeResource(user,"coins",50,"CreateScripture",this,scripture)
end

RegisterEventHandler(EventType.Message, "ConsumeResourceResponse", 
    function (success,transactionId,user,template)
    	if (not success) then return end
    	if (transactionId == "CreateScripture") then
	   		if (not user:IsValid()) then return end
	   		this:NpcSpeech("Here, improve the mind...")
	   		DebugMessage("Template is "..tostring(template))
	 		CreateObjInBackpack(user,template,"spawn_scripture")
	 	end
    end)

RegisterSingleEventHandler(EventType.ModuleAttached,GetCurrentModule(),
    function( ... )
        AddUseCase(this,"Interact",true)
    end)