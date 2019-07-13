--for alpha 1
MIN_GATE_RELICS_WATER = 50
MIN_GATE_RELICS_FIRE = 50
MIN_GATE_RELICS_AIR = 50
MIN_GATE_RELICS_EARTH = 50
MIN_GATE_RELICS_VOID = 50
MIN_GATE_RELICS_ELDER = 50

BUFF_TIME_HOURS = 3
BUFF_INCREASE = 0.2


AddView("NearbyPlayer", SearchPlayerInRange(10), 1.0)

local relicNames = {
	relic_of_the_ancients = "AncientRelic",
	relic_of_the_first_star = "FirstStarRelic",
	relic_of_the_void = "VoidRelic",
	relic_of_the_firstborn = "FirstbornRelic",
	relic_of_the_primordial = "PrimordialRelic",
	cultist_relic = "CultistRelic",
}

local otherControllers = FindObjects(SearchModule("dead_gate_controller"))
for i,j in pairs(otherControllers) do
	if (j ~= this) then
		this:Destroy()
	end
end

this:SetObjectTag("DeadGateController")

RegisterEventHandler(EventType.EnterView, "NearbyPlayer",
	function(playerObj)
		--only players
		if (not playerObj:IsPlayer()) then
			return
		end
		--get the backpack object
		local backpackObj = playerObj:GetEquippedObject("Backpack")

		local relicItems = FindItemsInContainerRecursive(backpackObj,
            function(item)           
            	local templateId = item:GetCreationTemplateId()
                
                return templateId == "relic_of_the_ancients"
                		or templateId == "relic_of_the_first_star"
                		or templateId == "relic_of_the_void"
                		or templateId == "relic_of_the_firstborn"
                		or templateId == "relic_of_the_primordial"
                		or templateId == "cultist_relic"
            end)
		
		if(#relicItems) then
			--add buffs for each relic
			local gateRelicCountData = this:GetObjVar("RelicCounts") or {}
			local playerRelicCountData = playerObj:GetObjVar("RelicCounts") or {}
			
			for i,item in pairs(relicItems) do
				local templateId = item:GetCreationTemplateId()
				local relicName = relicNames[templateId]
				playerObj:PlayEffect("LightningCloudEffect",0.5)
				playerObj:SendMessage("AddSkillBuff",playerObj,"All",BUFF_INCREASE,BUFF_TIME_HOURS*60*60,relicName,true)
				item:Destroy()
				
				gateRelicCountData[relicName] = (gateRelicCountData[relicName] or 0) + 1
				playerRelicCountData[relicName] = (playerRelicCountData[relicName] or 0) + 1						

				playerObj:SendMessage("AdvanceQuest","RelicQuest","TalkToRothchilde2","FindSourceOfPower")
			end		

			this:SetObjVar("RelicCounts",gateRelicCountData)
			playerObj:SetObjVar("RelicCounts",playerRelicCountData)
		end
	end)


