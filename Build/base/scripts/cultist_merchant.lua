require 'base_merchant'
require 'base_skill_trainer'
require 'incl_faction'

local SPEAK_DELAY = 15000			-- 5 second interval between greetings
local lastHelloTime = 0
local lastGoodbyeTime = 0

AddView("MerchantNearbyPlayer", SearchPlayerInRange(OBJECT_INTERACTION_RANGE), 1.0)

function CanBuyItem(buyer,item)
	local favorability = GetFaction(buyer,"Cultists") or 0

	if (favorability == nil or favorability < 10) then 
		this:NpcSpeech("I sell only to members of the cult.")
		return false
	end
	return true
end

RegisterEventHandler(EventType.EnterView, "MerchantNearbyPlayer", 
	function(target)
		local favorability = GetFaction(target,"Cultists")

		if (favorability == nil or favorability < 10) then 
			return 
		end

	    --DebugMessage("npc:HandleEnterView(" .. tostring(target) .. ")")
	    -- Only speak if enough time has passed since last greeting
	    if ((lastHelloTime + SPEAK_DELAY) < ServerTimeMs()) then
	    	Speak{Text="Hau'kommen bretheren. See anything you like?"}
	    	Speak{Text="[$1781]"}
	    	FaceObject(this,target)
	    	lastHelloTime = ServerTimeMs()
	    end
	end)

RegisterEventHandler(EventType.LeaveView, "MerchantNearbyPlayer", 
	function(target)
		if ((lastGoodbyeTime + SPEAK_DELAY) < ServerTimeMs()) then
			Speak{Text="May fate be upon you."}
			lastGoodbyeTime = ServerTimeMs()
		end
	end)

-- when user clicks on merchant, show menu
RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if(usedType ~= "Interact") then return end
		
		FaceObject(this,user)
		local favorability = GetFaction(user,"Cultists")

		if (favorability == nil or favorability < 10) then 
			this:NpcSpeech("I sell only to members of the cult.")
			return 
		end
			
		    this:StopMoving()

			response = {}

			text = AI.InteractMessages[math.random(1,#AI.InteractMessages)]

		    response[1] = {}
		    response[1].text = "I want to buy something."
		    response[1].handle = "Buy" 
		    
		    response[2] = {}
		    response[2].text = "How much would you buy this for?"
		    response[2].handle = "Appraise" 

		    response[3] = {}
		    response[3].text = "I wish to sell something..."
		    response[3].handle = "Sell" 

		    if (AI.GetSetting("EnableBank") ~= nil and AI.GetSetting("EnableBank") == true) then
		        response[4] = {}
		        response[4].text = "I want to bank items."
		        response[4].handle = "Bank" 
		    end

		    if (CanTrain()) then
				response[5] = {}
				response[5].text = "Train me in this skill..."
				response[5].handle = "Train" 
			end

		    response[6] = {}
		    response[6].text = "Nevermind"
		    response[6].handle = "" 

			NPCInteractionLongButton(text,this,user,"merchant_interact",response)
	end)


-- me
RegisterEventHandler(EventType.DynamicWindowResponse,"merchant_interact", 
	function (user,menuIndex)
	    if( menuIndex == 0 ) then return end
	    if( user == nil or not(user:IsValid())) then return end
	    if( user:DistanceFrom(this) > OBJECT_INTERACTION_RANGE) then return end

        if (menuIndex == "Sell") then
            Merchant.DoSell(user)
        elseif (menuIndex == "Appraise") then
	    	Merchant.DoAppraise(user)
        elseif (menuIndex == "Bank") then
	    	OpenBank(user,this)
	    elseif( menuIndex == "Train" ) then
	    	SkillTrainer.ShowTrainContextMenu(user)
	    elseif (menuIndex == "Buy") then
	    	QuickDialogMessage(this,user,AI.HowToPurchaseMessages[math.random(1,#AI.HowToPurchaseMessages)])
        end
	end)