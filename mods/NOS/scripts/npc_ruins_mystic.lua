require 'NOS:base_ai_mob'
require 'NOS:base_ai_intelligent'
--require 'NOS:base_ai_sleeping'
require 'NOS:incl_faction'
require 'NOS:base_npc_extensions'

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
		if (not CanUseNPC(user)) then return end
		
		user:SendMessage("StartQuest","SacredCactusQuest")
		GetAttention(user)
		favorability = GetFaction(user)
		if (favorability == nil) then favorability = 0 end
		local introState = user:GetObjVar("GolgathaOpinion")
		--new person
		
		if (favorability < 0) then		

			text = "[$2281]" 

			response = {}

			response[4] = {}
			response[4].text = "Whatever."
			response[4].handle = "" 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)

		elseif (introState == nil and favorability >= 0) then

			text = "[$2282]"

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

			user:SetObjVar("GolgathaOpinion","Greetings")

			NPCInteraction(text,this,user,"Question",response)
			
		elseif (introState == "Mission") then	

			text = "Do you have the Plant of Spiritual Truths?"

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
		elseif (introState == "PlantGiver" and (favorability >= 0)) then

			text = "[$2283]"

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

			text = "[$2284]"

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
			
			text = "[$2285]"

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
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "Question",
	function (user,buttonId)
		if (not CanUseNPC(user)) then return end
		GetAttention(user)
		favorability = GetFaction(user)

		local opinionOfUser = user:GetObjVar("GolgathaOpinion")

		if (favorability == nil) then favorability = 0 end

		if (buttonId == "WaitAMinute") then
			user:SetObjVar("GolgathaOpinion","Mission")
			QuickDialogMessage(this,user,"[$2286]")
		end
		if (buttonId == "Nevermind") then
			
			text="Anything else this seer can divulge?"

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

			text="What do you wish to know, he of the Unaware?"

			response = {}

			response[1] = {}
			response[1].text = "What have you learned?"
			response[1].handle = "Learned" 

			response[2] = {}
			response[2].text = "How do you commune?"
			response[2].handle = "How" 

			response[4] = {}
			response[4].text = "Nevermind."
			response[4].handle = "Nevermind" 


			NPCInteraction(text,this,user,"Question",response)

		end
		if(buttonId == "Who") then

			text="[$2287]"

			response = {}

			response[1] = {}
			response[1].text = "Tell me what you've learned."
			response[1].handle = "Learned" 

			response[2] = {}
			response[2].text = "How do you commune?"
			response[2].handle = "How" 

			response[4] = {}
			response[4].text = "Nevermind."
			response[4].handle = "Nevermind" 


			NPCInteraction(text,this,user,"Question",response)

		end
		if(buttonId == "How") then

				text="[$2288]"

				response = {}

				response[1] = {}
				response[1].text = "Where can I find this plant?"
				response[1].handle = "WhereCactus" 

				response[2] = {}
				response[2].text = "That's ... great."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Help") then

				text="[$2289]"

				response = {}

				response[1] = {}
				response[1].text = "What can I help you with?"
				response[1].handle = "HelpYou" 

				if (user:HasObjVar("SacredCactusQuestAmount")) then
					response[1] = {}
					response[1].text = "Didn't I do this for you already?"
					response[1].handle = "WaitAMinute" 
				end


				response[2] = {}
				response[2].text = "Nevermind then."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "HelpYou") then

				text="[$2290]"

				response = {}

				response[1] = {}
				response[1].text = "I'll take your offer up."
				response[1].handle = "Accept" 

				response[4] = {}
				response[4].text = "Sorry, but I'm not interested."
				response[4].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Accept") then
    			CheckAchievementStatus(user, "Other", "PlantGiver", nil, {Description = "", CustomAchievement = "Plant Giver", Reward = {Title = "Plant Giver"}})

				text="[$2291]"

				response = {}

				response[2] = {}
				response[2].text = "Right."
				response[2].handle = "Nevermind" 

				user:SetObjVar("GolgathaOpinion","Mission")

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Learned") then

				text="[$2292]"
				.."[$2293]"
				.."[$2294]"
				.."[$2295]"
				.."[$2296]"
				
				response = {}

				response[1] = {}
				response[1].text = "That's insane."
				response[1].handle = "Insane"

				response[2] = {}
				response[2].text = "Continue..."
				response[2].handle = "Continue" 

				NPCInteraction(text,this,user,"Question", response)
		end
		if (buttonId == "Continue") then
				text = "[$2297]"
				.."[$2298]"
				.."[$2299]"
				.."[$2300]"
				.."[$2301]"
				.."[$2302]"

				response = {}

				response[1] = {}
				response[1].text = "That's insane."
				response[1].handle = "Insane" 

				response[2] = {}
				response[2].text = "From the Cactus right?"
				response[2].handle = "Cactus" 

				response[3] = {}
				response[3].text = "What an interesting story!"
				response[3].handle = "Interesting" 

				response[4] = {}
				response[4].text = "... Nevermind."
				response[4].handle = "Nevermind"

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Cactus") then

				text="[$2303]"

				response = {}

				response[2] = {}
				response[2].text = "Alright then."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Insane") then

				text="[$2304]"

				response = {}

				response[2] = {}
				response[2].text = "Right."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Interesting") then

				text="[$2305]"

				response = {}

				response[2] = {}
				response[2].text = "Ah."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "MissionAccomplished") then
				local backpackObj = user:GetEquippedObject("Backpack")
				local giveCactus = false
				local hasRegularCactus = false
				local cactuses = GetResourcesInContainer(backpackObj,"SacredCactus")
				if (#cactuses ~= 0) then
					--DebugMessage(DumpTable(cactuses))
					if (CountResourcesInContainer(backpackObj,"SacredCactus") ~= 0) then giveCactus = true end
				end
				local notsacred_cactuses = GetResourcesInContainer(backpackObj,"Cactus")
				if (#cactuses ~= 0) then
					if (CountResourcesInContainer(backpackObj,"Cactus") ~= 0) then hasRegularCactus = true end
				end
				if (giveCactus) then

					local amountOfCactus = CountResourcesInContainer(backpackObj,"SacredCactus")
					local cactusGiven = user:GetObjVar("SacredCactusQuestAmount") or 0
					local factionToAdd = amountOfCactus
					local favorability = GetFaction(user,"Cultists") or 0
					local CACTUS_VALUE = 10 --how much cactus is worth to golgatha
					local coinsToAdd = 0


					--no more faction can be gained if above 7
					if favorability > 7 then
						factionToAdd = 0
						coinsToAdd = amountOfCactus * CACTUS_VALUE

								--DebugMessage(4)
								--DebugMessage("factionToAdd",factionToAdd)
								--DebugMessage("coinsToAdd",coinsToAdd)
					elseif (amountOfCactus <= 7 and amountOfCactus > 0) then
						if (favorability > 7) then
							factionToAdd = 0
							coinsToAdd = (amountOfCactus)*CACTUS_VALUE
								--DebugMessage(3)
								--DebugMessage("factionToAdd",factionToAdd)
								--DebugMessage("coinsToAdd",coinsToAdd)
						else
							--factionToAdd = math.max(amountOfCactus + favorability,7)
							local sum = math.min(amountOfCactus + favorability)
							if (sum > 7) then
								factionToAdd = (7 - favorability)
								coinsToAdd = (sum - 7)*CACTUS_VALUE
								--DebugMessage(1)
								--DebugMessage("factionToAdd",factionToAdd)
								--DebugMessage("coinsToAdd",coinsToAdd)
							else
								factionToAdd = amountOfCactus
								coins = 0
								--DebugMessage(2)
								--DebugMessage("factionToAdd",factionToAdd)
								--DebugMessage("coinsToAdd",coinsToAdd)
							end
						end
					end
					--change favorability up
					if (factionToAdd > 0) then 
						ChangeFactionByAmount(user,factionToAdd)
					end
					--give coins if there's no favorability to be gained
					if (coinsToAdd >= 0) then
    					CreateObjInBackpack(user,"coin_purse","create_coins",coinsToAdd)
    					user:SystemMessage("You received "..coinsToAdd.." coin.","info")
    				end

					user:SetObjVar("SacredCactusQuestAmount",cactusGiven + amountOfCactus)
					--DebugMessage(DumpTable(cactuses))
					for i,j in pairs(cactuses) do
						j:Destroy()
					end

					if (factionToAdd > 0) then
						text="[$2306]"
					else
						text="[$2307]"
						
					end


					user:SetObjVar("GolgathaOpinion","PlantGiver")

					response = {}

					response[2] = {}
					response[2].text = "Thanks."
					response[2].handle = "" 

					NPCInteraction(text,this,user,"Question",response)
				elseif hasRegularCactus then

					text="[$2308]"

					response = {}

					response[2] = {}
					response[2].text = "Thanks."
					response[2].handle = "" 

					NPCInteraction(text,this,user,"Question",response)
				else

					text="[$2309]"

					response = {}

					response[2] = {}
					response[2].text = "Thanks."
					response[2].handle = "" 

					NPCInteraction(text,this,user,"Question",response)
				end
		end
	end)

RegisterEventHandler(EventType.CreatedObject,"create_coins",
function(success,objRef,amount)
	if (success) then
		RequestSetStackCount(objRef,amount)
	end
end)

RegisterSingleEventHandler(EventType.ModuleAttached,GetCurrentModule(),
    function( ... )
        AddUseCase(this,"Interact",true)
    end)