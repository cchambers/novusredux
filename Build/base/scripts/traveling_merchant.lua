require 'base_merchant'
require 'base_skill_trainer'

SPEAK_DELAY = 15000			-- 5 second interval between greetings
lastHelloTime = 0
lastGoodbyeTime = 0
AI.Settings.MerchantEnabled = true

AddView("MerchantNearbyPlayer", SearchPlayerInRange(OBJECT_INTERACTION_RANGE), 1.0)

RegisterEventHandler(EventType.EnterView, "MerchantNearbyPlayer", 
	function(target)
	    --DebugMessage("npc:HandleEnterView(" .. tostring(target) .. ")")

	    -- Only speak if enough time has passed since last greeting
	    if ((lastHelloTime + SPEAK_DELAY) < ServerTimeMs()) then
	    	Speak{Text="Greetings my friends. See anything you like?", Audio="MerchantGreeting"}
	    	Speak{Text="[$2643]"}
	    	FaceObject(this,target)
	    	lastHelloTime = ServerTimeMs()
	    end
	end)

RegisterEventHandler(EventType.LeaveView, "MerchantNearbyPlayer", 
	function(target)
		if ((lastGoodbyeTime + SPEAK_DELAY) < ServerTimeMs()) then
			Speak{Text="Cheers", Audio="MerchantPlayerNoPurchase"}
			lastGoodbyeTime = ServerTimeMs()
		end
	end)

-- when user clicks on merchant, show menu
RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if(usedType ~= "Interact") then return end
		
		FaceObject(this,user)

		--menuItems = {"Bank","Appraise","Sell","Train"}

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

		if (AI.GetSetting("EnableTax") ~= nil and AI.GetSetting("EnableTax") == true) then
		    response[5] = {}
		    response[5].text = "I want to pay tax."
		    response[5].handle = "Tax" 
		end

		if (CanTrain()) then
			response[6] = {}
			response[6].text = "Train me in this skill..."
			response[6].handle = "Train" 
		end
		
	    response[7] = {}
	    response[7].text = "Nevermind"
	    response[7].handle = "" 

		NPCInteractionLongButton(text,this,user,"merchant_interact",response)	
	end)

-- me
RegisterEventHandler(EventType.DynamicWindowResponse,"merchant_interact", 
	function (user,menuIndex)
	    if( menuIndex == 0 ) then return end
	    if( user == nil or not(user:IsValid())) then return end
	    if( user:DistanceFrom(this) > OBJECT_INTERACTION_RANGE) then return end
        if (menuIndex == "Bank") then
	    	OpenBank(user,this)
	    elseif( menuIndex == "Tax" ) then	
	    	OpenTax(user,this)
	    elseif( menuIndex == "Appraise" ) then	
	    	Merchant.DoAppraise(user)
	    elseif( menuIndex == "Sell" ) then
	    	Merchant.DoSell(user)
	    elseif( menuIndex == "Train" ) then
	    	SkillTrainer.ShowTrainContextMenu(user)
	    elseif (menuIndex == "Buy") then
	    	QuickDialogMessage(this,user,AI.HowToPurchaseMessages[math.random(1,#AI.HowToPurchaseMessages)])
        end
	end)