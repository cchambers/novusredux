--the beauty of this is that it doesn't need to be that long, but theoretically you could add all kinds of features to this
RegisterEventHandler(EventType.Message,"UseObject",function(user,useType)
	--advance a quest on interact from the objvars
	if (not this:HasObjVar("StartQuest")) then
		user:SendMessage("AdvanceQuest",this:GetObjVar("QuestName"),this:GetObjVar("QuestTask"),this:GetObjVar("QuestRequiredTask"))
	end
	--delete an objvar on interact
	if (this:HasObjVar("DeleteObjVar")) then
		user:DelObjVar(this:GetObjVar("DeleteObjVar"))
	end
	--set an objvar on interact
	if (this:HasObjVar("SetObjVar")) then
		user:SetObjVar(this:GetObjVar("SetObjVar"),this:GetObjVar("SetObjVarValue"))
	end
	--and/or send a message on interact
	if (this:HasObjVar("SendMessage")) then
		user:SendMessage(this:GetObjVar("MessageToSend"),this:GetObjVar("MessageArg1"),this:GetObjVar("MessageArg2"),this:GetObjVar("MessageArg3"))
	end

	if (this:HasObjVar("StartQuest")) then
		user:SendMessage("StartQuest",this:GetObjVar("StartQuest"))
	end
end)

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
    function ()
         SetTooltipEntry(this,"quest_item", "Perhaps you should inspect this item further.")
         AddUseCase(this,"Examine",true)
    end)