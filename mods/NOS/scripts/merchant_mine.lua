require 'NOS:base_merchant'
require 'NOS:base_skill_trainer'

SPEAK_DELAY = 15000			-- 5 second interval between greetings
lastHelloTime = 0
lastGoodbyeTime = 0

AddView("MerchantNearbyPlayer", SearchPlayerInRange(OBJECT_INTERACTION_RANGE),1.0)

AI.InteractMessages = 
{
	"What can I do to help you sweetie?",
	"[$1934]",
	"Need something?",
	"A customer? Yes! Can I help you sir?",
	"What can I do for you today?",
}

RegisterEventHandler(EventType.EnterView, "MerchantNearbyPlayer", 
	function(target)
	    --DebugMessage("npc:HandleEnterView(" .. tostring(target) .. ")")

	    -- Only speak if enough time has passed since last greeting
	    if ((lastHelloTime + SPEAK_DELAY) < ServerTimeMs()) then
	    	Speak{Text="Hey there. See anything you like?"}
	    	Speak{Text="Anything that's out is for sale."}
	    	FaceObject(this,target)
	    	lastHelloTime = ServerTimeMs()
	    end
	end)

RegisterEventHandler(EventType.LeaveView, "MerchantNearbyPlayer", 
	function(target)
		if ((lastGoodbyeTime + SPEAK_DELAY) < ServerTimeMs()) then
			Speak{Text="Come back soon!"}
			lastGoodbyeTime = ServerTimeMs()
		end
	end)

-- when user clicks on merchant, show menu
RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if(usedType ~= "Interact") then return end

		FaceObject(this,user)

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

	    if( menuIndex == "Appraise" ) then	
	    	Merchant.DoAppraise(user)
	    elseif( menuIndex == "Sell" ) then
	    	Merchant.DoSell(user)
	    elseif (menuIndex == "Buy") then
	    	QuickDialogMessage(this,user,AI.HowToPurchaseMessages[math.random(1,#AI.HowToPurchaseMessages)])
	    end
	end)