require 'NOS:base_merchant'
require 'NOS:base_skill_trainer'
require 'NOS:base_npc_extensions'

SPEAK_DELAY = 15000			-- 5 second interval between greetings
lastHelloTime = 0
lastGoodbyeTime = 0

CanBuyItem = function (buyer,item)
    return IsFounder(buyer)
end
CanUseNPC = CanBuyItem

AI.InteractMessages = {
	"How can I help you?",
	"What would you like?",
	"What do you need?",
}

-- when user clicks on merchant, show menu
RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if(usedType ~= "Interact") then return end
		if (not CanUseNPC(user)) then return end
		
		FaceObject(this,user)

		--menuItems = {"Bank","Appraise","Sell","Train"}

	    this:StopMoving()

		response = {}

		text = AI.InteractMessages[math.random(1,#AI.InteractMessages)]

	    response[1] = {}
	    response[1].text = "I want to buy something."
	    response[1].handle = "Buy" 
		
	    response[6] = {}
	    response[6].text = "Nevermind"
	    response[6].handle = "Close" 

		NPCInteractionLongButton(text,this,user,"merchant_interact",response)	
	end)

-- me
RegisterEventHandler(EventType.DynamicWindowResponse,"merchant_interact", 
	function (user,menuIndex)
		if (not CanUseNPC(user)) then return end
	    if( menuIndex == 0 ) then return end
	    if( user == nil or not(user:IsValid())) then return end
	    if( user:DistanceFrom(this) > OBJECT_INTERACTION_RANGE) then return end
        if (menuIndex == "Bank") then
	    	OpenBank(user,this)
	    elseif( menuIndex == "Appraise" ) then	
	    	Merchant.DoAppraise(user)
	    elseif( menuIndex == "Sell" ) then
	    	Merchant.DoSell(user)
	    elseif( menuIndex == "Train" ) then
	    	SkillTrainer.ShowTrainContextMenu(user)
	    elseif (menuIndex == "Buy") then
	    	QuickDialogMessage(this,user,"[$2072]")
	    elseif(menuIndex == "Close") then
	    	user:CloseDynamicWindow("merchant_interact")
        end
	end)