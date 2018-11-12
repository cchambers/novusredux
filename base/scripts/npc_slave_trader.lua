require 'base_ai_mob'
require 'base_ai_intelligent'
--require 'base_ai_sleeping'
require "incl_dialogwindow"
require "incl_faction"

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

function GuardsKillHim(target)
	target:SetObjVar("HaruusOpinion","AttackedSlaver")
	this:NpcSpeech("Guards, Kill Him!")
	FaceObject(this,target)
	this:SendMessage("AttackEnemy",target)
    local nearbyGuards = FindObjects(SearchMulti(
    {
        SearchMobileInRange(20), --in 10 units
        SearchModule("ai_slaver_guard"), --find slaver guards
    }))
    for i,j in pairs (nearbyGuards) do
    	--DebugMessage("Sending AttackEnemy")
        j:SendMessage("AttackEnemy",target) --defend me
    end
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
		
		GetAttention(user)
		favorability = GetFaction(user)
		if (favorability == nil) then favorability = 0 end
		local introState = user:GetObjVar("HaruusOpinion")
		--new person
		
		if (introState ~= nil and (favorability >= 45)) then
			
			text = "[$2336]"

			response = {}

			response[1] = {}
			response[1].text = "I want to barter."
			response[1].handle = "Barter" 

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
		elseif (introState == "AttackedSlaver") and (favorability < 0) then		

			text = "[$2337]" 

			response = {}

			response[1] = {}
			response[1].text = "You're sick."
			response[1].handle = "ScrewYou" 

			response[4] = {}
			response[4].text = "Whatever."
			response[4].handle = "" 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)

		elseif (introState == nil and favorability >= 0) then

			text = "[$2338]"

			response = {}

			response[1] = {}
			response[1].text = "You're sick."
			response[1].handle = "SickTwisted" 

			response[2] = {}
			response[2].text = "Who are you?"
			response[2].handle = "Who" 

			response[3] = {}
			response[3].text = "I have a question."
			response[3].handle = "Question" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			user:SetObjVar("HaruusOpinion","Greetings")

			NPCInteraction(text,this,user,"Question",response)

		--completed a mission to kill an escaped slave or sold 3 or more slaves
		elseif (introState == "GoodFriend" and (favorability >= 0)) then

			text = "Ny good friend "..user:GetName().."[$2339]"

			response = {}

			response[1] = {}
			response[1].text = "I want to barter."
			response[1].handle = "Barter" 

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

			text = "[$2340]"

			response = {}

			response[1] = {}
			response[1].text = "I want to barter."
			response[1].handle = "Barter" 

			response[2] = {}
			response[2].text = "Who are you?"
			response[2].handle = "Who" 

			response[3] = {}
			response[3].text = "I have a question."
			response[3].handle = "Question" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			user:SetObjVar("HaruusOpinion","Greetings")

			NPCInteraction(text,this,user,"Question",response)

		--returning customer, cult member
		elseif (introState ~= nil and (favorability >= 10)) then
			
			text = "[$2341]"

			response = {}

			response[1] = {}
			response[1].text = "I want to barter."
			response[1].handle = "Barter" 

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

		elseif (introState == "SlaveMission") then	

			text = "[$2342]"

			response = {}

			response[1] = {}
			response[1].text = "I want to barter."
			response[1].handle = "Barter" 

			response[2] = {}
			response[2].text = "Yes I have."
			response[2].handle = "SlaverEvidence" 

			response[3] = {}
			response[3].text = "I have a question."
			response[3].handle = "QuestionMission" 

			response[4] = {}
			response[4].text = "Not yet, Goodbye."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)
		end
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "Question",
	function (user,buttonId)
		GetAttention(user)

		local opinionOfUser = user:GetObjVar("HaruusOpinion")

		if (favorability == nil) then favorability = 0 end

		if (buttonId == "Nevermind") then
			
			text="[$2343]"

			response = {}

			response[1] = {}
			response[1].text = "I want to barter."
			response[1].handle = "Barter" 

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
		if(buttonId == "ScrewYou") then

			GuardsKillHim(user)

		end
		if(buttonId == "SickTwisted") then

			text = "[$2344]"

			response = {}

			response[1] = {}
			response[1].text = "Ok, Sure."
			response[1].handle = "Barter" 

			response[2] = {}
			response[2].text = "I have a question."
			response[2].handle = "Question" 

			response[2] = {}
			response[2].text = "Who are you?"
			response[2].handle = "Who" 

			response[4] = {}
			response[4].text = "No, thank you."
			response[4].handle = "" 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)
		end

		if(buttonId == "Question") then

			text = "[$2345]"

			response = {}

			--response[1] = {}
			--response[1].text = "Do you need help?"
			--response[1].handle = "EscapedSlave" 

			response[2] = {}
			response[2].text = "Why do you do this?"
			response[2].handle = "Why" 

			response[3] = {}
			response[3].text = "Nevermind."
			response[3].handle = "Nevermind" 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Who" and opinionOfUser ~= "GoodFriend") then


			text="[$2346]"

            this:StopMoving()

			response = {}

			response[1] = {}
			response[1].text = "Nevermind."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)

		end
		if(buttonId == "Who" and opinionOfUser == "GoodFriend") then

			text = "[$2347]"
			.."[$2348]"
			.."[$2349]"

            this:StopMoving()

			response = {}

			response[1] = {}
			response[1].text = "You're sick."
			response[1].handle = "SickTwisted" 

			response[2] = {}
			response[2].text = "Right."
			response[2].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)

		end
		if(buttonId == "Why") then

				text="My good friend, I'm a bandit. "
				.."[$2350]"
				.."[$2351]"
				.."[$2352]"
				.."[$2353]"
				.."[$2354]"

	            this:StopMoving()

				response = {}

				response[1] = {}
				response[1].text = "You're sick."
				response[1].handle = "SickTwisted" 

				response[2] = {}
				response[2].text = "Nevermind."
				response[2].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Barter") then

				text="Excellent Indeed! Are you looking to sell, or buy?"

	            this:StopMoving()

				response = {}

				response[1] = {}
				response[1].text = "Sell."
				response[1].handle = "Sell" 

				response[2] = {}
				response[2].text = "Buy."
				response[2].handle = "Buy" 

				response[3] = {}
				response[3].text = "Nevermind."
				response[3].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Actions",response)
		end
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "Actions",
	function (user,buttonId)
		GetAttention(user)

		favorability = user:GetObjVar("ThomasFavorability")

		if(buttonId == "Sell") then

			text="Who are you looking to sell, good sir?"

			user:SystemMessage("What prisoner to you wish to sell?")
			user:RequestClientTargetGameObj(this, "sellSlave")

			response = {}

			response[1] = {}
			response[1].text = "Nevermind."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)	

		end
		if(buttonId == "Buy") then
			--DFB TODO: Should we implement this?

			--text="[$2355]"
			text = "[$2356]"

			response = {}

			response[1] = {}
			response[1].text = "I'll buy chains. [F7F700]20 Copper[-]"
			response[1].handle = "BuyChains" 

			response[2] = {}
			response[2].text = "Nevermind."
			response[2].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Actions",response)	

		end
		if (buttonId == "Nevermind") then

			text="Well then, anything else I can do for you?"

			response = {}

			response[1] = {}
			response[1].text = "I want to barter."
			response[1].handle = "Barter" 

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
		if (buttonId == "BuyChains") then

			RequestConsumeResource(user,"coins",20,"BuyChains",this)

			this:PlayAnimation("transaction")

		end
		if (buttonId == "Accept" and sellTarget ~= nil) then

			local backpackObj = user:GetEquippedObject("Backpack")

			CreateObjInContainer("coin_purse", backpackObj, GetRandomDropPosition(backpackObj), "LootCoinPurse", GetPrice(sellTarget))
			
			local lifetimeStats = user:GetObjVar("LifetimePlayerStats")
			lifetimeStats.SlavesTraded = (lifetimeStats.SlavesTraded or 0) + 1
			PlayerTitles.CheckTitleGain(user,AllTitles.ActivityTitles.SlaveTrader,lifetimeStats.SlavesTraded)
			user:SetObjVar("LifetimePlayerStats",lifetimeStats)

			--give the slave over to the trader
			sellTarget:SetObjVar("controller",this)
			sellTarget:SendMessage("SoldSlaveMessage")
			local destinationMarker = FindObject(SearchHasObjVar("SlaveDestinationMarker"))
			--DebugMessage("marker is "..tostring(destinationMarker))
			if (destinationMarker ~= nil) then
				sellTarget:PathToTarget(destinationMarker,1.0,1.0)
			end
			sellTarget = nil
			ChangeFactionByAmount(user,1)

			text="[$2357]"

			response = {}

			response[1] = {}
			response[1].text = "I want to barter."
			response[1].handle = "Barter" 

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

			--if yes, give player coins.
			--remove ownership of player over slave
			--have slave path to behind wall
			--add to list of sellable slaves
	end)
--get the price of the target
function GetPrice(target)
	if (target == nil or not target:IsValid()) then return 0 end
	local targetStr = GetStr(target)
	local targetAgi = GetStr(target)
	local targetInt = GetStr(target)
	local SkillDictionary = target:GetObjVar("SkillDictionary")
	local SkillSum = 0
	for i,j in pairs(SkillDictionary) do
		SkillSum = SkillSum + j.SkillLevel
	end
	local price = targetStr/9 + targetAgi/9 + targetInt/7 + SkillSum/15
	return math.floor(price)*10
end


RegisterEventHandler(EventType.Message, "ConsumeResourceResponse", function (success,transactionId,user)

	if (transactionId ~= "BuyChains") then
		return false
	end

	if (not success) then

			text = "[$2358]"

			response = {}

			response[2] = {}
			response[2].text = "Right."
			response[2].handle = "" 

			NPCInteraction(text,this,user,"Actions",response)
			local backpackObj = user:GetEquippedObject("Backpack")
			local amount = 20

	else
			local backpackObj = user:GetEquippedObject("Backpack")  
			local dropPos = GetRandomDropPosition(backpackObj)
	    	CreateObjInContainer("capture_chains", backpackObj, dropPos, nil)

			text="[$2359]"

			response = {}

			response[1] = {}
			response[1].text = "I want to barter."
			response[1].handle = "Barter" 

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

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "sellSlave", 
	function(target,user)
		--check if it's a sellable slave
		user:CloseDynamicWindow("Question")
		if (target == nil or not target:IsValid()) then return end

		local isHuman = false
		local tags = target:GetObjectTags()
		for i,j in pairs(tags) do
			if (j == "Human") then
				isHuman = true
			end
		end
		if (target:GetCreationTemplateId() == "cultist_slave" or target:GetCreationTemplateId() == "cultist_slave_female") then
			QuickDialogMessage(this,user,"[$2360]")
			return
		end
		--check to see if it's a person
		if (not target:IsMobile() or target:GetMobileType() == "Animal" or isHuman == false ) then

			text="[$2361]"

			response = {}

			response[1] = {}
			response[1].text = "Right."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)	

		end
		--always check to see if he's not trying to sell another person's ... property
		local targetOwner = target:GetObjVar("controller")

		--if not, have slaver throw up dialog telling player off
		if (not target:HasModule("ai_slave") or targetOwner ~= user) then

			text="[$2362]"

			response = {}

			response[1] = {}
			response[1].text = "Right."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)	

		else
			local price = GetPrice(target)
			sellTarget = target
			--if he/she's sellable, pop up dialog asking if he wants to sell it.

			text="That looks good to me, I'll buy em' for [F7F700]"..price.."[-] copper!"

			response = {}

			response[1] = {}
			response[1].text = "Sounds good.[F7F700](Receive "..price.." copper)[-]"
			response[1].handle = "Accept" 

			response[2] = {}
			response[2].text = "No, I don't think so."
			response[2].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Actions",response)	
		end

	end)

RegisterEventHandler(EventType.Message, "DamageInflicted",
	function (damager)
		if AI.IsValidTarget(damager) then
			GuardsKillHim(damager)
		end
	end)
