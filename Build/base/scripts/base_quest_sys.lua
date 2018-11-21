require 'incl_container'
require 'incl_faction'

--minimum range to search for NPC's dialog
NPC_SEARCH_RANGE = 30

--callbacks that check to see if the respective task in the quest is complete
QuestCallbacks = {

	NPCInteraction = function(user,task,templateId)
		--DebugMessage("template ID is "..tostring(templateId),"task.NPCTemplate is "..tostring(task.NPCTemplate))
		if templateId == task.NPCTemplate then
			return true
		else
			return false
		end
	end,

	HaveFaction = function (user,task)
		local curFaction = GetFaction(user,task.FactionName)
		if (curFaction >= task.FactionAmount) then
			return true
		end
		return false
	end,

	HaveItemWithObjVar = function (user,task)
		local backpackObj = user:GetEquippedObject("Backpack")
		if (backpackObj == nil) then return false end
		local item = FindItemInContainerRecursive(backpackObj,function(item)
			return item:HasObjVar(task.ItemObjVarName)
		end)

		if (item ~= nil) then
			return true
		else
			return false
		end
	end,

	HaveItemsWithObjVar = function (user,task)
		local backpackObj = user:GetEquippedObject("Backpack")
		local items = FindItemsInContainerRecursive(backpackObj,function (item)
			if (item:HasObjVar(task.ItemObjVarName)) then
				return true
			end
		end)

		if (items ~= nil and #items >= task.NumItems) then
			return true
		else
			return false
		end
	end,

	HasItemsWithObjVarValue = function (user,task)
		local backpackObj = user:GetEquippedObject("Backpack")
		if not(backpackObj) then
			return false
		end
		--DebugMessage("------------------------------------------")
		local items = FindItemsInContainerRecursive(backpackObj,
		function (item)
			--DebugMessage("item name is "..tostring(item:GetName()))
			--DebugMessage("ItemObjVarName is "..tostring(item:GetObjVar(task.ItemObjVarName)))
			if (item:GetObjVar(task.ItemObjVarName) == task.ItemObjVarValue) then
				--DebugMessage("MATCH")
				return true
			end
		end)
		--DebugMessage("count is "..tostring(#items))

		if (items ~= nil and #items >= task.NumItems) then
			return true
		else
			return false
		end
	end,

	HasItemInList = function (user,task)
		local backpackObj = user:GetEquippedObject("Backpack")
		if (backpackObj == nil) then return false end
		local items = FindItemsInContainerRecursive(backpackObj)

		for i,j in pairs(items) do
			for i,itemId in pairs(task.ItemList) do
				if (j:GetCreationTemplateId() == itemId) then
					return true
				end
			end
		end
		return false
	end,

	HasPet = function (user,task)
		if (user:HasObjVar("Minions")) then
			return true
		end
		return false
	end,

	KnowRecipe = function(user,task)
		if (HasRecipe(user,task.TaskRecipe)) then
			return true
		else
			return false
		end
	end,

	HasRecipe = function(user,task)
		--DFB NOTE: This is going to return true always now that we got rid of recipes.
		return true
	end,

	Items = function (user,task)
		if (user:GetEquippedObject("Backpack") == nil) then return false end
		local taskItemList = task.TaskItemList
		if (taskItemList == nil) then
			--DebugMessage("[base_quest_sys|Items] ERROR: No item list for task for "..task.TaskDisplayName)
			return false
		else
			return user:GetEquippedObject("Backpack"):HasItemsInContainer(taskItemList)
		end
	end,
	ObjVar = function (user,task)
		--DebugMessage("Task.TaskObjvarName is "..tostring(task.TaskObjVarName))
		if (user:HasObjVar(task.TaskObjVarName)) then
			--DebugMessage(1)
			return true
		else
			return false
		end
	end,
	ObjVarValue = function (user,task)
		if (task.TaskObjVarName == nil) then 
			DebugMessage("[base_quest_sys|ObjVarValue] ERROR: taskObjVarName is nil")
			return false
		end
		if (not user:HasObjVar(task.TaskObjVarName)) then 
			return false
		end
		if (user:GetObjVar(task.TaskObjVarName) == task.TaskObjVarValue) then
			return true
		else
			return false
		end
	end,

	ObjVarValueMin = function (user,task)
		if (task.TaskObjVarName == nil) then 
			DebugMessage("[base_quest_sys|ObjVarValueMin] ERROR: taskObjVarName is nil")
			return false
		end
		if (not user:HasObjVar(task.TaskObjVarName)) then 
			return false
		end
		if (user:GetObjVar(task.TaskObjVarName) >= task.TaskObjVarValue) then
			return true
		else
			return false
		end
	end,
	Resource = function (user,task)
		local count = user:GetEquippedObject("Backpack"):CountResourcesInContainer(task.ResourceRequired)
		--DebugMessage("Count is "..tostring(count))
		if count >= task.ResourceCount then
			return true
		else
			return false
		end
	end,

	ExitRegion = function(user,task)--left region
		if (not user:IsInRegion(task.TaskRegion)) then
			return true
		end
		return false
	end,

	EnterRegion = function(user,task)--entered region
		if (user:IsInRegion(task.TaskRegion)) then
			return true
		end
		return false
	end,
	
	EnterRegions = function(user,task)--left region
		for i,j in pairs(task.TaskRegions) do
			if (user:IsInRegion(j)) then
				return true
			end
		end
		return false
	end,

	CompleteOnEnter = function(user,task)
		return true--complete on enter
	end,

	HasModule = function(user,task)
		return this:HasModule(task.ModuleName)
	end,

	HaveObjVars = function (user,task)
		for i,j in pairs(task.TaskObjVars) do
			if (not user:HasObjVar(j)) then
				return false
			end
		end
		return true
	end,

	HaveSkillLevel = function (user,task)
		--DebugMessage("task.TaskSkillType is "..tostring(task.TaskSkillType))
		--DebugMessage("task.TaskSkillLevel is "..tostring(task.TaskSkillLevel))
		--DebugMessage("amount of skill is "..tostring(GetSkillLevel(this,task.TaskSkillType)))
		--DebugMessage("Result is "..tostring(GetSkillLevel(this,task.TaskSkillType) >= task.TaskSkillLevel))
		if (GetSkillLevel(this,task.TaskSkillType) >= task.TaskSkillLevel) then
			return true
		else
			return false
		end
	end,

	HasCombatStance = function (user,task)
		local stance = this:GetSharedObjectProperty("CombatStance")
		--DebugMessage("Stance == " ..tostring(stance).." task.StanceRequired == "..tostring(task.StanceRequired))
		if (stance == task.StanceRequired) then
			return true
		else
			return false
		end
	end,

	GainSkillLevel = function(user,task)
		local lastSkillLevel = mLastSkillLevel or GetSkillLevel(this,task.TaskSkillType)
		--DebugMessage("lastSkillLevel is "..lastSkillLevel.." mLastSkillLevel is "..tostring(mLastSkillLevel))
		mLastSkillLevel = GetSkillLevel(this,task.TaskSkillType)
		if (lastSkillLevel < mLastSkillLevel) then
			return true
		else
			return false
		end
	end,

	NearbyObject = function (user,task)
		local object = FindObject(SearchMulti({SearchRange(this:GetLoc(),15),SearchTemplate(task.NearbyObject)}))
		if (object ~= nil) then
			--DebugMessage(object:GetName(),task.NearbyObject)
			return true
		else
			--DebugMessage("Nope")
			return false
		end
	end,

	NearbyObjectHasObjVar = function (user,task)
		local object = FindObject(SearchMulti({SearchRange(this:GetLoc(),15),SearchTemplate(task.NearbyObject)}))
		if (object ~= nil) then
			if (object:HasObjVar(task.ObjectObjVar)) then
				return true
			else
				return false
			end
		else
			--DebugMessage("Nope")
			return false
		end
	end,
}

--a mouthful, but really just a function that's called when a task is finished or initiated
QuestTaskActions = {
	--todo learn recipe
	--todo learn skill
	--todo learn spell
	MemorizeMap = function (user,task)
		local availableMaps = user:GetObjVar("AvailableMaps") or {}
		user:SystemMessage("You have obtained the map of "..StripColorFromString(task.MapRegionName)..".","event")
		availableMaps[task.MapRegionName] = true
		user:SetObjVar("AvailableMaps",availableMaps)
	end,
	ConsumeItems = function (user,task)
		local backpackObj = user:GetEquippedObject("Backpack")
		if(backpackObj ~= nil) then
			--DebugMessage("CONSUMING "..DumpTable(task.TaskConsumeItemList))
			ConsumeItemsInContainer(backpackObj,task.TaskConsumeItemList,task.TaskForceConsumeItems)
		end
	end,

	ObjVar = function (user,task)
		if task.TaskDeleteObjVar ~= nil and task.TaskDeleteObjVar ~= false then
			user:DelObjVar(task.TaskObjVarName)
		end
	end,

	SetObjVar = function (user,task)
		user:SetObjVar(task.TaskSetObjVar,task.TaskSetObjVarValue)
	end,

	Resource = function (user,task)
		RequestConsumeResource(user,task.ResourceRequired,task.ResourceAmount,"QuestConsumeResource",this)
	end,

	ObjVarValue = ObjVar,

	SetObjVar = function (user,task)
		--DebugMessage(2)
		user:SetObjVar(task.TaskSetObjVar,task.TaskSetObjVarValue)
	end,

	Dialog = function (user,task) --throw up dialog
		local response = {{text="Ok.",handle="Ok"}}
		NPCInteraction(task.DialogText,nil,user,"Responses",response,task.DialogTitle)
	end,

	--THIS IS NOT GUARENTEED TO THROW A DIALOG UP IF YOU'RE OUTSIDE OF RANGE
	--throw up npc dialog
	NPCDialog = function (user,task)--throw up dialog
		local response = task.DialogResponses or {{text="Ok.",handle="Ok"}}
		--DebugMessage("template is "..tostring(task.NPCTemplate))
		local npc = FindObject(SearchMulti({
				SearchMobileInRange(5),
				SearchTemplate(task.NPCTemplate),
			}))
		if (npc == nil) then DebugMessage("[base_quest_sys|NPCDialog] NPC not found, "..tostring(task.NPCTemplate))return end
		--DebugMessage("npc is "..tostring(npc))
		NPCInteraction(task.DialogText,npc,user,"Responses",response,nil,NPC_SEARCH_RANGE)
	end,

	--play an effect
	PlayEffect = function(user,task)
		this:PlayEffect(task.EffectToPlay)
	end,

	--AS A RULE OF THUMB, ONLY CALL THIS IF YOU KNOW YOU WILL BE IN PROXIMITY TO A GIVEN NPC
	--create object lists
	CreateItem = function(user,task)
		local creationTemplate = task.Reward or task.RewardItem or task.TaskItem or task.Item
		if (creationTemplate == nil) then
			DebugMessage("[base_quest_sys|CreateItem] ERROR: Item list not found in task "..tostring(task.TaskName))
			return 
		end
		local backpackObj = user:GetEquippedObject("Backpack") 
		if( backpackObj ~= nil ) then
			local resourceType = GetTemplateObjVar(creationTemplate,"ResourceType")
			local name = GetTemplateObjectName(creationTemplate)
			-- try to add to the stack in the players pack	
			if not( TryAddToStack(resourceType,backpackObj,1) ) then
		  		-- no stack in players pack so create an object in the pack
			   backpackObj:SendOpenContainer(user)
			   CreateObjInBackpackOrAtLocation(user,creationTemplate)
		   	end

			this:SystemMessage("[D7D700]You have received a "..name,"event")
		end 
		--CreateObjInBackpack(user,creationTemplate,"spawn_items") 
	end,

	RandomItem = function(user,task)
		local creationTemplate = task.RewardChoices[math.random(1,#task.RewardChoices)]
		if (creationTemplate == nil) then
			DebugMessage("[base_quest_sys|CreateItem] ERROR: Item list not found in task "..tostring(task.TaskName))
			return 
		end
		local backpackObj = user:GetEquippedObject("Backpack") 
		if( backpackObj ~= nil ) then
			local resourceType = GetTemplateObjVar(creationTemplate,"ResourceType")
			local name = GetTemplateObjectName(creationTemplate)
			-- try to add to the stack in the players pack	
			if not( TryAddToStack(resourceType,backpackObj,1) ) then		  		
			   backpackObj:SendOpenContainer(user)
			   CreateObjInBackpackOrAtLocation(user,creationTemplate)
		   	end

			this:SystemMessage("[D7D700]You have received a "..name,"event")
		end 
		--CreateObjInBackpack(user,creationTemplate,"spawn_items") 
	end,

	--AS A RULE OF THUMB, ONLY CALL THIS IF YOU KNOW YOU WILL BE IN PROXIMITY TO A GIVEN NPC
	CreateItems = function (user,task)
		if (task.RewardItems == nil) then
			DebugMessage("[base_quest_sys|CreateItems]ERROR:  No reward items specified for task "..task.TaskName)
		end
		for i,j in pairs (task.RewardItems) do
			local backpackObj = user:GetEquippedObject("Backpack")
			backpackObj:SendOpenContainer(user)
			if (backpackObj == nil) then
				return
			else
				local creationTemplate = j[1]
				local resourceType = GetTemplateObjVar(creationTemplate,"ResourceType")
				if (resourceType == nil) then
					for n=1,j[2],1 do
						-- try to add to the stack in the players pack	
						CreateObjInBackpack(user,j[1],"spawn_items",1) 
					end
				else
					CreateObjInBackpack(user,j[1],"spawn_items",j[2]) 
				end
			end
		end
	end,

	--AS A RULE OF THUMB, ONLY CALL THIS IF YOU KNOW YOU WILL BE IN PROXIMITY TO A GIVEN NPC
	ConsumeItemsWithObjVar = function (user,task)
		local backpackObj = user:GetEquippedObject("Backpack")
		local items = FindItemsInContainerRecursive(backpackObj,function (item)
			if (item:HasObjVar(task.ItemObjVarName)) then
				return true
			end
		end)

		if (items ~= nil and #items ~= 0) then
			for i,j in pairs(items) do
				j:Destroy()
			end
			return true
		else
			return false
		end
	end,

	--create mobiles or other objects
	CreateObjects = function(user,task)
		for i=0,task.SpawnAmount,1 do
			CreateObj(task.SpawnTemplates[math.random(1,#task.SpawnTemplates)],  task.SpawnLocations[math.random(1,#task.SpawnLocations)],"created")
		end
	end,

	--send a message to a player
	SendMessageToPlayer = function(user,task)
		user:SendMessage(task.TaskMessage,task.TaskMessageArgs)
	end,

	--show a hint to a player
	Hint = function(user,task)
		user:SendMessage("ShowHint",task.Hint)
	end,
}

function HasUnfinishedQuest()
	local questEntries = this:GetObjVar("QuestTable") or {}
	for index,questEntry in pairs (questEntries) do								
		if (questEntry ~= nil and not(questEntry.QuestFinished) ) then
			return true
		end
	end

	return false
end

local taskY = 25
function AddTaskElement(taskWindow,label,isComplete,taskOffset)
	taskWindow:AddLabel(180,taskY + 2+taskOffset,label,300,0,18,"right",false,true)
	if(isComplete) then
		taskWindow:AddImage(190,taskY+taskOffset,"Checkbox32px_On",24,24)
	else
		taskWindow:AddImage(190,taskY+taskOffset,"Checkbox32px_Off",24,24)
	end
	taskY = taskY + 26
end

--Differs from tracking quests because mainly it uses an older system. 
--It doesn't actually track the quest here, instead it will track it on the NPC and send messages to the player periodically
--this is the callback
function UpdateNPCTaskUI(state,npc,taskName,taskDisplayName,description,finishDescription)
	--DebugMessage(state,npc,taskName,taskDisplayName,description,finishDescription)
	if (npc == nil or not npc:IsValid()) then
		DebugMessage("[base_quest_sys|UpdateNPCTaskUI] NPC does not exist.")
		this:DelObjVar("LastActiveQuest")
		this:DelObjVar("LastActiveTask")
		this:CloseDynamicWindow("TaskUI")
		return
	end
	--DebugMessage(1)
	if (taskName == nil) then 
		this:DelObjVar("LastActiveQuest")
		this:DelObjVar("LastActiveTask")
		this:CloseDynamicWindow("TaskUI")
		return
	else
		this:SetObjVar("LastActiveQuest","Task")
		this:SetObjVar("LastActiveTask",taskName)
	end
	--DebugMessage(2)
	local taskWindow = DynamicWindow("TaskUI","",200,180,-220,220,"Transparent","TopRight")
	local taskOffset = #(this:GetObjVar("TrackedSkills") or {})*SKILL_TRACKER_SIZE + 10

	if (taskDisplayName ~= nil) then
		taskWindow:AddLabel(180,0+taskOffset,taskDisplayName,0,0,18,"right",false,true)
	else
		DebugMessage("[base_quest_sys|UpdateNPCTaskUI] ERROR: taskDisplayName is nil for task "..taskName.." "..state)
	end
	--DebugMessage(3)
	taskY = 25
	--Ideally we would share the actual task every so often but we can't send functions in messages
	if (state == "TaskOngoing") then
		--DebugMessage(4)
		AddTaskElement(taskWindow,description,false,taskOffset)
	else
		--DebugMessage(5)
		AddTaskElement(taskWindow,description,true,taskOffset)	
	end
	if (state == "TaskComplete" ) then 
		--DebugMessage(6)
		--DebugMessage(questEntry.CurrentTask)
		AddTaskElement(taskWindow,finishDescription,false,taskOffset)	
	end
	if (state == "TaskFinished") then
		--DebugMessage(7)
		AddTaskElement(taskWindow,finishDescription,true,taskOffset)
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"CloseTaskUI")
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"QuestUpdateCheck")
		this:DelObjVar("LastActiveQuest")
		this:DelObjVar("LastActiveTask")
		this:SystemMessage("[FFFF00]Task Complete: " .. taskDisplayName .."[-]","event")
	end
	this:OpenDynamicWindow(taskWindow)
end

RegisterEventHandler(EventType.Timer,"CloseTaskUI",function()
	this:CloseDynamicWindow("TaskUI")
end)

function UpdateQuestUI(questName,isTask)
	local quest = AllQuests[questName]
	--DebugMessage("RECEIVED QUEST UPDATE MESSAGE")
	--DebugMessage("LastActiveQuest = "..tostring(this:GetObjVar("LastActiveQuest")))
	--DebugMessage("QuestName is "..tostring(questName))
	if (isTask or this:GetObjVar("LastActiveQuest") == "Task") then

		local playersTasks = this:GetObjVar("NPCTaskList")
		local taskEntry = nil
		for i,j in pairs (playersTasks) do
			if (j.TaskName == questName) then
				taskEntry = j
			end
		end

		if (taskEntry == nil) then
			DebugMessage("[base_quest_sys|UpdateQuestUI] Warning: "..tostring(questName).." not found as NPC task name")
			this:DelObjVar("LastActiveQuest")
			this:DelObjVar("LastActiveTask")
			this:CloseDynamicWindow("TaskUI")
			return
		end
		--DebugMessage(questName)
		local npc = taskEntry.TaskNPC

		if (npc == nil or not npc:IsValid()) then
			DebugMessage("[base_quest_sys|UpdateQuestUI] NPC for NPC task does not exist.")
			this:DelObjVar("LastActiveQuest")
			this:DelObjVar("LastActiveTask")
			this:CloseDynamicWindow("TaskUI")
			return
		end
		--DebugMessage(DumpTable(taskEntry))
		npc:SendMessage("CheckTaskComplete",this,taskEntry.TaskName)
	else
		if (questName == nil) then 
			this:DelObjVar("LastActiveQuest")
			this:CloseDynamicWindow("TaskUI")
			UpdateQuestMapMarkers()
			return
		else
			this:SetObjVar("LastActiveQuest",questName)
		end

		if (quest == nil) then
			DebugMessage("[base_quest_sys|UpdateQuestUI] ERROR: Invalid quest name specified")
			return
		end
		local taskOffset = #(this:GetObjVar("TrackedSkills") or {})*SKILL_TRACKER_SIZE + 10
		local taskWindow = DynamicWindow("TaskUI","",200,180,-220,220,"Transparent","TopRight")
		if (quest.QuestDisplayName ~= nil) then
			taskWindow:AddLabel(180,0+taskOffset,quest.QuestDisplayName,0,0,18,"right",false,true)
		else
			DebugMessage("[base_quest_sys|UpdateQuestUI] ERROR: QuestDisplayName is nil for quest "..questName)
		end
		taskY = 25
		local questEntry = GetQuestStatusEntry(questName)
		if (questEntry == nil) then return end

		local curTask = quest.Tasks[questEntry.CurrentTask]

		for n,k in pairs(questEntry.TasksComplete) do
			if ( quest.Tasks[k] == nil ) then
				DebugMessage("[base_quest_sys|UpdateQuestUI] ERROR: Quest '"..questName.."' does not have task '"..k.."'.")
			elseif ( quest.Tasks[k].Description == nil ) then
				DebugMessage("[base_quest_sys|UpdateQuestUI] ERROR: Quest '"..questName.."' task '"..k.."' does not have a description.")
			else
				AddTaskElement(taskWindow,quest.Tasks[k].Description,true,taskOffset)
			end	
		end
		--bit of a hack we should loop though the table
		if (questEntry ~= nil and (not (questEntry.QuestFinished == true)) ) then 
			if (curTask == nil) then
				DebugMessage("[base_quest_sys|UpdateQuestUI] ERROR: Invalid task name in Quest UI:")
				DebugMessage("Quest: "..quest.QuestDisplayName)
				DebugMessage("Task: "..questEntry.CurrentTask)
			elseif ( curTask.Description == nil ) then
				DebugMessage("[base_quest_sys|UpdateQuestUI] ERROR: Current Task does not have a description.'")
			else
				AddTaskElement(taskWindow,curTask.Description,false,taskOffset)
			end
		end		

		this:OpenDynamicWindow(taskWindow)
		UpdateQuestMapMarkers(curTask)
	end
end

function UpdateQuestMapMarkers(curTask)	
	local oldMarkers = this:GetObjVar("MapMarkers") or {}
	local newMarkers = {}
	for i,markerEntry in pairs(oldMarkers) do
		if(markerEntry.Type ~= "Quest") then
			table.insert(newMarkers,markerEntry)		
		end
	end

	if(curTask ~= nil and curTask.MapMarkers ~= nil) then
		for i,markerEntry in pairs(curTask.MapMarkers) do
			markerEntry.Type = "Quest"
			table.insert(newMarkers,markerEntry)
		end
	end
	this:SetObjVar("MapMarkers",newMarkers)
end

RegisterEventHandler(EventType.Message,"NPCTaskUIMessage",UpdateNPCTaskUI)

function SetActiveQuest(questName)
	if (GetQuestStatusEntry(questName) ~= nil) then 
		UpdateQuestUI(questName)
	end
end

function RefreshQuestUI()
	if (this:HasObjVar("LastActiveQuest")) then
		--DebugMessage("LastActiveQuest = "..tostring(this:GetObjVar("LastActiveQuest")))
		SetActiveQuest(this:GetObjVar("LastActiveQuest"))
	end
end

--assign a new quest to the player, can be done through a message
function StartNewQuest(questName,startingTask)
	--DebugMessage(DumpTable(QuestName))
	--DebugMessage("QuestName",questName)
	local questEntries = this:GetObjVar("QuestTable") or {}
	local quest = AllQuests[questName]
	if (quest == nil) then
		DebugMessage("[base_quest_sys] StartNewQuest: Quest "..tostring(questName) .." doesn't exist. startingTask = "..tostring(startingTask))
		return
	end
	local questStarted = false
	if (GetQuestStatusEntry(questName) ~= nil) then 
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"QuestUpdateCheck")
		if (not AllQuests[questName].Repeatable) then
			--DebugMessage("[base_quest_sys|StartNewQuest] ERROR: Entry already detected in "..this:GetName().."'s entry table")
			return
		else
			for i,j in pairs(questEntries) do
				if (j.QuestName == questName and j.QuestFinished == true) then
					j.QuestFinished = false
					j.CurrentTask = quest.StartingTask
					j.TasksComplete = {}
					questStarted = true
					this:SendMessage("UpdateQuestUI",questName)
					--DebugMessage("Firing.")
					--else
					--DebugMessage("[base_quest_sys|StartNewQuest] ERROR: Repeatable quest not completed before attempting to start again "..this:GetName().."'s entry table")
				end
			end
		end
	else
		--DebugMessage(1)
		--search for the quest and add it.
		for i,quest in pairs(AllQuests) do
			--DebugMessage(2)
			--DebugMessage(i)
			if (i == questName) then
				local newQuestEntry = {
					CurrentTask = quest.StartingTask,
					QuestName = i,
					TasksComplete = {},
				}
				--DebugMessage("Found")
				questStarted = true
				table.insert(questEntries,newQuestEntry)
				RunStartActions(quest.Tasks[quest.StartingTask])
				this:SendMessage("UpdateQuestUI",questName)
			end
		end
	end

	if (questStarted) then
		if (quest.Notify ~= false) then
			this:SystemMessage("Quest Started: "..quest.QuestDisplayName)
			this:SystemMessage("Quest Started: "..quest.QuestDisplayName,"event")
		end
		--DFB TODO: System messages, update the quest window, quest thing under compass
	end
	this:SetObjVar("QuestTable",questEntries)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"QuestUpdateCheck")
	RunStartActions(quest.Tasks[quest.StartingTask])
	if (startingTask ~= nil) then

		this:SendMessage("AdvanceQuest",questName,startingTask)
	end
	return
	--DebugMessage("[base_quest_sys|StartNewQuest] No quest found with name "..tostring(questName))
end

--handler for a message that will make the quest jump to any given task. Very powerful, can create branching quests, 
--quests with multiple endings, etc.
-- if prerequisiteTask is set, the user must be on this task in order to advance
function AdvanceTask(questName,questTaskName,prerequisiteTask)
	--DebugMessage(1)
	local questEntryTable = this:GetObjVar("QuestTable") or {}
	local quest = AllQuests[questName]
	if (quest == nil) then
		DebugMessage("[base_quest_sys|AdvanceTask] ERROR: Received invalid quest to advance with name of "..tostring(questName).. ", task name is "..tostring(questTaskName))
		return
	end
	--DebugMessage(2)
	local questEntry = {
		QuestName = questName,
		CurrentTask = questTaskName,
		TasksComplete = {}
	}
	--assign the task entry
	local task = quest.Tasks[questEntry.CurrentTask]
	--DebugMessage(questEntry.CurrentTask)
	--DebugMessage(DumpTable(quest.Tasks[questEntry.currentTask]))
	--DebugMessage(DumpTable(quest.Tasks[questEntry.currentTask].NextTask))
	--DebugMessage(DumpTable(quest.Tasks[quests.Tasks[questEntry.CurrentTask].NextTask]))
	local hasEntry = false
	--DebugMessage(3)
	local lastTask = quest.Tasks[quest.StartingTask]
	for i,j in pairs(questEntryTable) do
		--DebugMessage("check")
		if (j.QuestName == questName) then
			--DebugMessage("found it")
			if(prerequisiteTask ~= nil and j.CurrentTask ~= prerequisiteTask) then
				--DebugMessage("User is not on required task",questName,questTaskName,prerequisiteTask)
				return
			end
			lastTask = quest.Tasks[j.CurrentTask]
			questEntry.TasksComplete = j.TasksComplete
			questEntryTable[i] = questEntry
			hasEntry = true
		end
	end
	
	--DebugMessage(4)
	--add the dependent tasks to the finished task list.
	if (lastTask ~= nil) then
		--Don't loop into the same task over and over.
		--DebugMessage("lastTask.TaskName is ",lastTask.TaskName,"questTaskName is ",questTaskName)
		if (lastTask.TaskName == questTaskName) then
			--DebugMessage("Check works.")
			return
		end
	
		if (not lastTask.Hidden) then
			local hasTask = false
			if (task == nil) then 
				DebugMessage("[base_quest_sys] ERROR: Task "..questTaskName.." does not exist!")
				return
			end
			if (task.DependentTasks ~= nil ) then
				for i,j in pairs(task.DependentTasks) do
					if (j == lastTask.TaskName) then
						hasTask = true
					end
				end
				local newTable = {}
				for i,j in pairs(questEntry.TasksComplete) do
					local newEntry = true
					for n,k in pairs(task.DependentTasks) do 
						if (k == j) then
							newEntry = false
						end
					end
					if (newEntry == true) then
						table.insert(newTable,j)
					end
				end
				questEntry.TasksComplete = newTable
				for i,j in pairs(task.DependentTasks) do
					table.insert(questEntry.TasksComplete,j)
				end
			end
			if (not hasTask) then
				table.insert(questEntry.TasksComplete,lastTask.TaskName)
			end
		end
	end
	--DebugMessage(5)
	--get the current task if there is one
	if (task == nil)  then
		DebugMessage("[base_quest_sys|AdvanceTask] ERROR: Invalid task, "..tostring(questEntry.CurrentTask).." quest is "..tostring(questName))
		return
	end
	--DebugMessage(6)
	if (hasEntry == false and prerequisiteTask == nil) then--the player has advanced in the quest without starting it, they're going in in the middle of it
		table.insert(questEntryTable,newQuestEntry)
		this:SendMessage("UpdateQuestUI",questName)
		this:SystemMessage("Quest Started: "..quest.QuestDisplayName,"event") --notify them they have a new quest
		this:SetObjVar("QuestTable",questEntryTable)
		return
	elseif (hasEntry == false and prerequisiteTask ~= nil) then
		--do nothing, don't start the quest, they haven't even started it
		return 
	end
	--DebugMessage(7)
	--DFB TODO: Notify player, update questing windows here
	if (lastTask ~= nil) then
		if (lastTask.FinishActions ~= nil) then
			for i,j in pairs(lastTask.FinishActions) do
				QuestTaskActions[j](this,lastTask) --callback some code for each task
			end
		end
	end
	--DebugMessage(8)
	this:SendMessage("UpdateQuestUI",quest.QuestName) --have to do this instead of calling it cause objvar is being set 
	this:SystemMessage("[FFFF00]Quest Updated: " .. task.Description .."[-]")
	this:PlayObjectSound("SkillGain",false)
	RunStartActions(task)

	this:SetObjVar("QuestTable",questEntryTable)
end

function SetQuestStatusEntry(questName,questEntry)
	--DebugMessage(DumpTable(questEntry))
	--assign the quest entry here
	local questEntries = this:GetObjVar("QuestTable") or {}
	local entryIndex = nil
	for index,entry in pairs(questEntries) do
		if (entry.QuestName == questName) then
			entryIndex = index
		end
	end
	if (entryIndex == nil) then
		table.insert(questEntries,questEntry)
	else
		questEntries[entryIndex] = questEntry
	end
	this:SetObjVar("QuestTable",questEntries)
end

function RunStartActions(task)
	--LuaDebugCallStack("Idle")
	if (task == nil) then
		LuaDebugCallStack("Invalid task called in StartQuest")
		return
	end
	if (task.StartActions == nil) then
		return 
	end
	for i,j in pairs(task.StartActions) do
		QuestTaskActions[j](this,task) --callback some code for each task
	end
end

--load a quest entry, returning nil if it doesn't exist
function GetQuestStatusEntry(questName)
	local questEntries = this:GetObjVar("QuestTable") or {}
		for index,questEntry in pairs(questEntries) do
			if (questEntry.QuestName == questName) then
				return questEntry
			end
		end
	return nil
end

function OpenQuestCompleteWindow(quest)
 	local dynWindow = DynamicWindow("QuestComplete","",4000,4000,-2000,-2000,"Transparent","Center")
	--dynWindow:AddImage(0,0,"GreyOutImage",4000,4000,"Sliced","000000")
	dynWindow:AddButton(0,0,"close","",4000,4000,"","",false,"Invisible")	
	dynWindow:AddImage(1460,1636,"QuestCompletionRibbonDesign",0,0)
	dynWindow:AddLabel(1980,1845,"Quest Complete: "..StripColorFromString(quest.QuestDisplayName),1000,0,32,"center")		
	if(quest.QuestCompleteMessage) then
		dynWindow:AddImage(1660,1900,"SectionBackground",630,100,"Sliced")	
		dynWindow:AddLabel(1975,1918,quest.QuestCompleteMessage,550,0,22,"center",false,true)	
	end
	this:OpenDynamicWindow(dynWindow)
	this:PlayObjectSound("QuestComplete",false)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"QuestCompleteCloseDelay")
	RegisterEventHandler(EventType.DynamicWindowResponse,"QuestComplete",
		function(user,buttonId)
			if(buttonId == "close" and not(this:HasTimer("QuestCompleteCloseDelay"))) then
				user:CloseDynamicWindow("QuestComplete")
				UnregisterEventHandler("base_quest_sys",EventType.DynamicWindowResponse,"QuestComplete")
			end
		end)
end

function CanStartQuest(questName)
	local questEntry = GetQuestStatusEntry(questName)
	if (questEntry == nil) then return true end
	if (questEntry.QuestComplete) then
		if (AllQuests[questName].Repeatable) then
			return true
		end
	end
	return false
end

--pulsing function that checks to see if a quest is complete
--if quest is not complete then don't bother with it

function QuestUpdateCheck(callbackData)

		--wait to check the next task list
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(9 + math.random()),"QuestUpdateCheck")

--local start = ServerTimeMs()
		--A nasty hack but since it's a different system it has to work seperately.
		--advancing a task will override the quest system.
		--If you track a task, it will still update the quest system, but it will track the task through the event handler
		--DebugMessage("LastActiveQuest is "..tostring(this:GetObjVar("LastActiveQuest")))
		if (this:GetObjVar("LastActiveQuest") == "Task") then
			--DebugMessage(this:GetObjVar("LastActiveTask"))
			this:SendMessage("UpdateQuestUI",this:GetObjVar("LastActiveTask"),true)
		end
		--DebugMessage("Firing")


		--added functionality to start quests automatically
		for questName,quest in pairs(AllQuests) do
			--DebugMessage("questName is "..tostring(questName))
--local queststart = ServerTimeMs()
			if (CanStartQuest(questName)) then
				if (quest.StartConditions ~= nil) then
					local startTheQuest = true
					for n,condition in pairs(quest.StartConditions) do
						--DebugMessage("condition = "..tostring(condition))
						--DebugMessage("quest.StartConditionArgs is "..tostring(quest.StartConditionArgs))
						--DebugMessage("callbackData is "..tostring(callbackData))
						if (quest.StartConditionArgs ~= nil) then
							if not QuestCallbacks[condition](this,quest.StartConditionArgs,callbackData) then
								--DebugMessage("Fired")
								startTheQuest = false
							end
						else
							DebugMessage("[base_quest_sys] ERROR: Quest "..tostring(questName).." has no start condition arguments!")
						end
					end
					if (startTheQuest) then
						this:SendMessage("StartQuest",questName)
					end
				end
			end
--DebugMessage("Quest is "..tostring(questName),ServerTimeMs() - queststart)
		end
--DebugMessage("PreQuests",ServerTimeMs() - start)
--local start = ServerTimeMs()

		local questEntries = this:GetObjVar("QuestTable") or {}
		for index,questEntry in pairs (questEntries) do
			--if (this:GetObjVar("LastActiveQuest") == nil and not(questEntry.QuestFinished)) then
			--	this:SetObjVar("LastActiveQuest",questEntry.QuestName)
			--	this:SendMessage("UpdateQuestUI",questEntry.QuestName) --have to do this instead of calling it cause objvar is being set 
			--end
--ocal queststart = ServerTimeMs()
			local quest = AllQuests[questEntry.QuestName]
			if (quest ~= nil and quest.Tasks ~= nil and questEntry ~= nil and (not (questEntry.QuestFinished == true)) ) then --if I have an entry for the quest (I've started the quest)
				for taskIndex,task in pairs(quest.Tasks) do --for each task in the quest
					if (questEntry.CurrentTask == taskIndex and not questEntry.Failed) then--if it's the current task and I haven't failed the quest
						local taskComplete = true
						--check if I should skip this task
						--DebugMessage(DumpTable(task))
						--DebugMessage(task.JumpIfTaskComplete)
						--DebugMessage(1)
						if (task.JumpIfTaskComplete ~= nil) then
							--DebugMessage(2)
							for subTaskIndex,subTask in pairs(task.JumpIfTaskComplete) do
								--DebugMessage(3)
								otherTask = quest.Tasks[subTask]
								if (otherTask.CompletionConditions ~= nil) then
									--DebugMessage(4)
									local preCompleteTask = true
									for i,j in pairs (otherTask.CompletionConditions) do --if I meet all the completion conditions for the current task
										--DebugMessage(5)
										--DebugMessage(j)
										if (not QuestCallbacks[j](this,otherTask,callbackData)) then --TODO: Add the quest callbacks
											--DebugMessage(6)
											preCompleteTask = false
											--taskComplete = false --quest is not complete
										end
									end 
									--if the task I check to see if I skip is complete, go to that task's next.
									if (preCompleteTask) then
										--DebugMessage(7)
										this:SendMessage("AdvanceQuest",questEntry.QuestName,otherTask.NextTask)
										return
									end
								end
							end
						end
						--DebugMessage("Found Quest")
						--DebugMessage(questEntry.CurrentTask)
						local nextTaskIndex = 0 
						if (task.CompletionConditions ~= nil) then
							for i,j in pairs (task.CompletionConditions) do --if I meet all the completion conditions for the current task
								if (not QuestCallbacks[j](this,task,callbackData)) then --TODO: Add the quest callbacks
									--DebugMessage(j)
									taskComplete = false --quest is not complete
									--DebugMessage("false")
								end
							end 
						else
							taskComplete = false
						end
						if (taskComplete) then--so if I've completed the task
							--DFB TODO: Notify player, update questing windows here
							--DebugMessage("taskComplete")
							if (not task.Hidden) then
								table.insert(questEntry.TasksComplete,taskIndex)
							end
							--DebugMessage(DumpTable(task))
							if (task.FinishActions ~= nil) then
								for i,j in pairs(task.FinishActions) do
									--DebugMessage(j)
									QuestTaskActions[j](this,task) --callback some code for each task
								end
							end

							if (task.IsQuestEnding ~= true) then
								this:SendMessage("UpdateQuestUI",quest.QuestName) --have to do this instead of calling it cause objvar is being set 

								if (task.NextTask ~= nil) then
									nextTaskIndex = task.NextTask --go to the next task 
									--DebugMessage("next task assigned")
								else
									DebugMessage("[base_quest_sys|QuestUpdateCheck] ERROR: NextTask is invalid, has value of "..tostring(task.NextTask))
									return
								end
								questEntry.CurrentTask = nextTaskIndex --assign the new task id

								local nextTask = quest.Tasks[questEntry.CurrentTask]
								this:SystemMessage("[FFFF00]Quest Updated: " .. nextTask.Description .."[-]")
								this:PlayObjectSound("SkillGain",false)
								--DebugMessage("questEntry.CurrentTask is "..tostring(questEntry.CurrentTask))
								--DebugMessage("nextTask is "..tostring(nextTask))
								--DebugMessage(DumpTable(quest.Tasks))
								RunStartActions(nextTask)
							else
								--DebugMessage("Quest complete")
								questEntry.QuestFinished = true
								this:CloseDynamicWindow("TaskUI")
								questEntry.CurrentTask = nil --assign the new task id
								this:DelObjVar("LastActiveQuest")
								OpenQuestCompleteWindow(quest)
								UpdateQuestMapMarkers()
							end
							SetQuestStatusEntry(quest.QuestName,questEntry) --change the task entry to go to the next task							
						end
					end
				end
			end
--DebugMessage("Quest "..tostring(quest.QuestName),ServerTimeMs() - queststart)

		end		
--DebugMessage("MainQuestLoop",ServerTimeMs() - start)

end

RegisterEventHandler(EventType.Timer,"QuestUpdateCheck",QuestUpdateCheck)

--message to send to check if quest tasks are complete
RegisterEventHandler(EventType.Message,"QuestUpdate",
	function()
		this:FireTimer("QuestUpdateCheck")
	end)


RegisterEventHandler(EventType.CreatedObject,"spawn_items",
	function(success,objRef,amount)
		local name = objRef:GetName()
		SetItemTooltip(objRef)
		if (amount == 1 or amount == nil) then 
			this:SystemMessage("[D7D700]You have received a "..name..".")
		else
			RequestSetStack(objRef,amount)
			local pluralName = objRef:GetObjVar("PluralName") or objRef:GetName()
			this:SystemMessage("[D7D700]You have received "..tostring(amount).." "..pluralName..".")
		end
	end)

RegisterEventHandler(EventType.LoadedFromBackup,"",
	function ()
		--DebugMessage(1)
		--DebugMessage("this:HasTimer(QuestUpdateCheck = "..tostring(this:HasTimer("QuestUpdateCheck")))
		if(not(this:HasTimer("QuestUpdateCheck")) and HasUnfinishedQuest()) then
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"QuestUpdateCheck")
		end
	end)

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function ()
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"QuestUpdateCheck")
	end)

function FinishQuest(questName,runFinishActions)
	local questEntry = GetQuestStatusEntry(questName)
	local quest = AllQuests[questName]
	if quest == nil then DebugMessage("[base_quest_sys] Quest not found, Could not finish quest "..tostring(questName)) return end

	--if runFinishActions is not nil then it will run the finish actions for the current task
	if (runFinishActions) then
		local lastTask = quest.Tasks[questEntry.CurrentTask]
		if (lastTask.FinishActions ~= nil) then
			for i,j in pairs(lastTask.FinishActions) do
				QuestTaskActions[j](this,lastTask) --callback some code for each task
			end
		end
	end

	--DebugMessage("Quest complete")
	questEntry.QuestFinished = true
	this:CloseDynamicWindow("TaskUI")
	questEntry.CurrentTask = nil --assign the new task id
	this:DelObjVar("LastActiveQuest")
	OpenQuestCompleteWindow(quest)
	UpdateQuestMapMarkers()
	SetQuestStatusEntry(questName,questEntry)
end

function FailQuest(questName)
	local quest = AllQuests[questName]
	if quest == nil then DebugMessage("[base_quest_sys] Quest not found, Could not fail quest "..tostring(questName)) return end
	--assign the quest entry here
	local questEntries = this:GetObjVar("QuestTable") or {}
	local entryIndex = nil
	for index,entry in pairs(questEntries) do
		if (entry.QuestName == questName) then
			entryIndex = index
		end
	end
	questEntries[entryIndex] = nil
	this:SetObjVar("QuestTable",questEntries)

	--DebugMessage("Quest complete")
	this:CloseDynamicWindow("TaskUI")
	this:DelObjVar("LastActiveQuest")
	this:SystemMessage("[F70000]Quest Failed[-]:".. quest.QuestDisplayName)
	UpdateQuestMapMarkers()
end

RegisterEventHandler(EventType.Message,"NPCInteraction",function(npc)
    	QuestUpdateCheck(npc:GetCreationTemplateId())
    end)

--sets the active quest in the UI
RegisterEventHandler(EventType.Message,"SetActiveQuest",SetActiveQuest)
RegisterEventHandler(EventType.Message,"RefreshQuestUI",RefreshQuestUI)
RegisterEventHandler(EventType.Message,"UpdateQuestUI",UpdateQuestUI)
RegisterEventHandler(EventType.Message,"AdvanceQuest",AdvanceTask)
RegisterEventHandler(EventType.Message,"FailQuest",FailQuest)
RegisterEventHandler(EventType.Message,"FinishQuest",FinishQuest)

--message to send to trigger a new quest
RegisterEventHandler(EventType.Message,"StartQuest",StartNewQuest)