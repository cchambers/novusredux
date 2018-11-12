AddView("Enter Hub", SearchPlayerInRegion(this:GetObjVar("QuestRegion")))

RegisterEventHandler(EventType.EnterView,"EnterHub",function(mob)
	if (mob:IsPlayer()) then
		mob:SendMessage("StartQuest",this:GetObjVar("QuestName"))
	end
end)