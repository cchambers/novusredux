require 'npc_founders_bartender'

CanBuyItem = function (buyer,item)
    return IsCollector(buyer)
end
CanUseNPC = CanBuyItem

-- me
OverrideEventHandler("npc_founders_bartender",EventType.DynamicWindowResponse,"merchant_interact", 
	function (user,menuIndex)
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
	    	QuickDialogMessage(this,user,"[$2073]")
        end
	end)