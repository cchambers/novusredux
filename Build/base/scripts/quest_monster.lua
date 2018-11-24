RegisterEventHandler(EventType.Message, "HasDiedMessage",
    function(killer)
    if (IsGuard(killer)) then return end
    local nearbyCombatants = FindObjects(SearchMulti(
        {
            SearchPlayerInRange(20,true), --in 20 units
        }))
        --they took part in killing the demon, they deserve credit
        for i,j in pairs(nearbyCombatants) do
	        if (this:GetObjVar("RewardTemplate") ~= nil) then
	            CreateObjInBackpack(j,this:GetObjVar("RewardTemplate"),"spawn_relic") 
	            j:SystemMessage("[D7D700]You have received an item![-]","info")
	        end
	        if (this:GetObjVar("QuestName") ~= nil and this:GetObjVar("QuestTask") ~= nil) then
				j:SendMessage("AdvanceQuest",this:GetObjVar("QuestName"),this:GetObjVar("QuestTask"),this:GetObjVar("QuestRequiredTask"))
            end
        end
    end)
