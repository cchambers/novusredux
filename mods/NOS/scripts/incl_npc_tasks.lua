require 'NOS:base_ai_settings'
require 'NOS:incl_resource_source'
require 'NOS:incl_faction'


CHECK_MOBILE_RANGE = 10

AI.TaskDeclineMessages = {
	"No, thank you.",
	"Not at this time.",
	"I'm not interested.",
	"I don't think so.",
	"No, not interested.",
	"Not interested.",
}

AI.TaskAcceptMessages = {
	"I'll take up your offer.",
	"Sounds good, I accept.",
	"I'm ready to start!",
	"I'll do that job.",
	"I'm interested",
}

AI.TaskMessages = 
{
	"I have these jobs available."
}

AI.TaskCurrentMessages = 
{
	"[$1879]"
}

AI.TaskCompletedMessages = 
{
	"I have what you requested.",
	"The job is done!",
	"I'm finished, here.",
	"I've done what you asked."
}

AI.TaskContinueMessages = 
{
	"Job's not finished yet.",
	"It's not done yet.",
	"I need more time.",
	"I don't have it yet, but I will get it.",
	"I don't have it yet.",
	"I'm working on it.",
	"It's a work in progress.",
}

AI.TaskCancelMessages = 
{
	"I give up.",
	"I'm not doing this anymore.",
	"I'm not doing this.",
	"I quit.",
	"Sorry, but I'm not doing this.",
}

AI.NoTasksMessages = 
{
	"[$1880]",
	"[$1881]",
	"[$1882]"
}

AI.TaskRequestHelpSpeech = 
{
	"I need some help.",
	"I need advice.",
	"Do you know anything else?",
	"I need assistance.",
}

AI.DefaultTaskAssistanceMessages = 
{
	"I'm sorry, I can't help you right now.",
	"I can't help you with that.",
	"I can't help you with that right now.",
	"[$1883]"
}
--You should never see this task if you have an individiual npc task table for your NPC
NPCTasks = {
}

--generic callback functions

NPCTaskCheckCallback =
{
	Items = function (user,task)
		local taskItemList = task.TaskItemList
		if (taskItemList == nil) then
			DebugMessage("[NPCTaskCheckCallback.Items] ERROR: No item list for task for "..task.TaskDisplayName)
			return false
		elseif (user:GetEquippedObject("Backpack") ~= nil) then
			return HasItemsInContainer(user:GetEquippedObject("Backpack"),taskItemList)
		end
	end,
	ObjVar = function (user,task)
		if (user:HasObjVar(task.TaskObjVarName)) then
			return true
		else
			return false
		end
	end,
	ObjVarValue = function (user,task)
		if (user:GetObjVar(task.TaskObjVarName) == task.TaskObjVarValue) then
			return true
		else
			return false
		end
	end,
	Resource = function (user,task)
		local count = this:GetEquippedObject("Backpack"):CountResourcesInContainer(task.ResourceRequired)
		if count > task.ResourceCount then
			return true
		else
			return false
		end
	end,
}

NPCTaskFinishCallback =
{
	Items = function (user,task)
		if (NPCTaskCheckCallback.Items(user,task)) then
			user:GetEquippedObject("Backpack"):ConsumeItemsInContainer(task.TaskItemList,task.TaskForceConsumeItems)
			QuickDialogMessage(this,user,task.TaskFinishedMessage)
			MarkTaskAsFinished(user,task)
			AdjustFaction(user,task.FactionOnFinish,task.Faction)
			CreateReward(user,task)
		else
			QuickDialogMessage(this,user,task.TaskIncompleteMessage)
		end
	end,
	ObjVar = function (user,task)
		if task.TaskDeleteObjVar ~= nil and task.TaskDeleteObjVar ~= false then
			user:DelObjVar(task.TaskObjvarName)
		end
		MarkTaskAsFinished(user,task)
		QuickDialogMessage(this,user,task.TaskFinishedMessage)
		AdjustFaction(user,task.FactionOnFinish,task.Faction)
		CreateReward(user,task)
	end,
	Resource = function (user,task)
		RequestConsumeResource(user,task.ResourceRequired,task.ResourceAmount,"NPCConsumeResource",this)
	end,
	ObjVarValue = ObjVar
}

RegisterEventHandler(EventType.Message, "ConsumeResourceResponse",
function(success,transactionId,user)	
	if (transactionId ~= "NPCConsumeResource") then return end
	if (not success) then 
		QuickDialogMessage(this,user,npcTask.TaskIncompleteMessage)
		return
	end
	MarkTaskAsFinished(user,task)
	QuickDialogMessage(this,user,task.TaskFinishedMessage)
	AdjustFaction(user,task.FactionOnFinish,task.Faction)
	CreateReward(user,task)
end)

--system that takes the task and executes code based on the values in the task table

--internal function that is designed only for quick use in custom callbacks
function DoTaskFinish(user,task)
	QuickDialogMessage(this,user,task.TaskFinishedMessage)
	MarkTaskAsFinished(user,task)
	AdjustFaction(user,task.FactionOnFinish,task.Faction)
	CreateReward(user,task)
end

function CreateReward(user,npcTask)
	if (npcTask.RewardType == "coins") then --reward is currency
		CreateObjInBackpack(user,"coin_purse", "coins", npcTask.RewardAmount)
		user:SystemMessage("[F7F700]You have received "..tostring(npcTask.RewardAmount).. " coins.[-]","event")
	elseif (npcTask.RewardType == "recipe") then
		local recipeIndex,recipeName = GetRandomRecipe(npcTask.RecipeMinSkill,npcTask.RecipeMaxSkill,npcTask.RecipeSkill,ServerSettings.WorldName)--pick a random recipe,
		if (recipeIndex ~= nil and recipeName ~= nil) then
			CreateObjInBackpack(user,"recipe", "recipe",recipeIndex,recipeName)--create the obje
		end
	elseif (ResourceData.ResourceInfo[npcTask.RewardType] ~= nil) then --reward is a resource
		CreateObjInBackpack(user,ResourceData.ResourceInfo[npcTask.RewardType].Template, "reward", {user,npcTask.RewardAmount})
	else --reward is a template
		CreateObjInBackpack(user,npcTask.RewardType, "reward", user,npcTask.RewardAmount)
	end
end

function TaskIsComplete(user,task,openedDialog)
	if (type(task.CheckCompletionCallback) == "function") then
		return task.CheckCompletionCallback(user,task,openedDialog)
	elseif (type(task.CheckCompletionCallback) == "string" and NPCTaskCheckCallback[task.CheckCompletionCallback] ~= nil) then
		return NPCTaskCheckCallback[task.CheckCompletionCallback](user,task,openedDialog)
	else
		DebugMessage("[incl_npc_tasks|TaskIsComplete] ERROR: No valid completion callback in task "..task.TaskDisplayName)
		return false
	end
end

function CompleteTask(user,task)
	if (type(task.CompletionCallback) == "function") then
		return task.CompletionCallback(user,task)
	elseif (type(task.CompletionCallback) == "string" and NPCTaskFinishCallback[task.CompletionCallback] ~= nil) then
		return NPCTaskFinishCallback[task.CompletionCallback](user,task)
	else
		DebugMessage("[incl_npc_tasks|CompleteTask] ERROR: No valid completion callback in task "..task.TaskDisplayName)
		return false
	end
end

function AdjustFaction(user,amount,faction)
	if (amount == nil or faction == nil) then return end
	ChangeFactionByAmount(user,amount,faction)
end

function MarkTaskAsFinished(user,task)
	local playersTasks = user:GetObjVar("NPCTaskList")
	for i,j in pairs (playersTasks) do --flag the task on the player as cancelled
		--DebugMessage("i is "..tostring(i).."j.TaskName is "..tostring(j.TaskName).." task is "..tostring(task))
		if (j.TaskName == task.TaskName) then
			--DebugMessage("set")
			j.Status = "Finished"
		end
	end
	user:SendMessage("NPCTaskUIMessage","TaskFinished",this,task.TaskName,task.TaskDisplayName,task.Description,task.FinishDescription)
    user:SetObjVar("NPCTaskList",playersTasks)
end

--gets the task description from the npc
function GetNPCTask(taskName)
	return NPCTasks[taskName]
end

function ClearInvalidEntries(user)
	local playerTaskEntries = user:GetObjVar("NPCTaskList")
	if (playerTaskEntries == nil) then return end
	for i,j in pairs(playerTaskEntries) do
		if (j.TaskNPC == nil or not j.TaskNPC:IsValid()) then
			table.remove(playerTaskEntries,i)
		end
	end
	user:SetObjVar("NPCTaskList",playerTaskEntries)
end

function GetTasksICanHelpWith(user)
	ClearInvalidEntries(user)
	local playerTaskEntries = user:GetObjVar("NPCTaskList")
	if (playerTaskEntries == nil) then return {} end
	local assists = {}
	for i,j in pairs(playerTaskEntries) do
		local once = true
		for n,k in pairs(j.TaskAssists) do
			if (this:GetCreationTemplateId() == k.Template and once) then
				table.insert(assists,j)
				once = false
			end
		end
	end
	return assists
end

function ShouldShowTaskCurrent(user,taskName)
	ClearInvalidEntries(user)
	local task = GetNPCTask(taskName)
	local entry = GetTaskEntry(user,taskName)
	if (entry == nil or entry.TaskNPC ~= this) then return false end
	local status = entry.Status
	if (status == "Finished") then return false end
	if (status == "Cancelled") then return false end
	return true
end

function HasFaction(user,taskName)
	--DebugMessage("TaskName",taskName)
	local task = GetNPCTask(taskName)
	return not(task.TaskMinimumFaction ~= nil and task.TaskMinimumFaction > (GetFaction(user) or 0) )
end

function TaskStartCheck (user,taskName)
	ClearInvalidEntries(user)
	--DebugMessage(1)
	local task = GetNPCTask(taskName)
	local entry = GetTaskEntry(user,taskName)
	
	if not(HasFaction(user,taskName)) then return false end

	if (entry == nil or entry.TaskNPC ~= this) then return true end
	--DebugMessage(2)
	local status = entry.Status
	if (status == "Finished" and not task.Repeatable) then return false end
	--DebugMessage(3)
	if (status == "Cancelled" and not task.Repeatable) then return false end
	--DebugMessage(4)
	if (status == "Enabled") then return false end
	--DebugMessage(5)
	return true
end

function TaskEnabled (user,taskName)
	ClearInvalidEntries(user)
	local task = GetNPCTask(taskName)
	local entry = GetTaskEntry(user,taskName)
	if (entry == nil or entry.TaskNPC ~= this) then return true end
	local status = entry.Status
	if (status == "Finished" and not task.Repeatable) then return false end
	if (status == "Cancelled" and not task.Repeatable) then return false end
	return true
end
--get the tables in NPCTasks that are referenced in the player's tasks
function GetPlayerTasks(player)
	ClearInvalidEntries(player)
	local playerTaskEntries = player:GetObjVar("NPCTaskList")
	if (playerTaskEntries == nil) then return end
	local result = {}
	for i,j in pairs(NPCTasks) do
		for n,k in pairs(playerTaskEntries) do
			if (j.TaskName == k.TaskName and k.TaskNPC == this) then
				table.insert(result,j)
			end
		end
	end
	return result
end

--Get player's task entry from the taskname
function GetTaskEntry(user,taskName)
	ClearInvalidEntries(user)
	local playerTaskEntries = user:GetObjVar("NPCTaskList")
	if (playerTaskEntries == nil) then return end
	for n,k in pairs(playerTaskEntries) do
			if (k.TaskName == taskName and k.TaskNPC == this) then
			return k
		end
	end
	return nil
end

--determine if the player has a current task with a name
function HasNPCTask(user,taskName)
	ClearInvalidEntries(user)
	local playerTaskEntries = user:GetObjVar("NPCTaskList")
	if (playerTaskEntries == nil) then return false end
	for i,j in pairs(NPCTasks) do
		for n,k in pairs(playerTaskEntries) do
			if (j.TaskName == k.TaskName and k.TaskNPC == this) then
				return true
			end
		end
	end
	return false
end

function HasNPCTaskEnabled(user,taskName)
	ClearInvalidEntries(user)
	local playerTaskEntries = user:GetObjVar("NPCTaskList")
	if (playerTaskEntries == nil) then return false end
	for i,j in pairs(NPCTasks) do
		for n,k in pairs(playerTaskEntries) do
			--DebugMessage("-----------------------------------------")
			--DebugMessage(" j.TaskName is"..tostring(j.TaskName))
			--DebugMessage(" k.TaskName is "..tostring(k.TaskName))
			--DebugMessage(" TaskEnabled is" ..tostring(TaskEnabled(user,taskName)))
			--DebugMessage(" taskName is "..tostring(taskName))
			--DebugMessage(" CHECK 1 IS "..tostring(j.TaskName == k.TaskName))
			--DebugMessage(" CHECK 2 IS "..tostring(j.TaskName == taskName))
			--DebugMessage(" CHECK 3 IS "..tostring(TaskEnabled(user,taskName)))
			--DebugMessage(" CHECK 4 IS "..tostring(k.TaskNPC == this))
			--DebugMessage(" TaskNPC IS "..tostring(j.TaskNPC))
			--DebugMessage(" this IS "..tostring(this))
			if (j.TaskName == k.TaskName and j.TaskName == taskName and ShouldShowTaskCurrent(user,taskName) and k.TaskNPC == this) then
				return true
			end
		end
	end
	return false
end

--gets the task with the highest priority
function GetUrgentTask(player)
	ClearInvalidEntries(player)
	local highestPriority = 0
	local highestPriorityTask = nil
	local currentTasks = GetPlayerTasks(player)
	if (curentTasks == nil) then return nil end
	for i,j in pairs(curentTasks) do 
		if (j.Importance ~= nil and j.Importance > highestPriority ) then --if I have a higher priority task 
			highestPriority = j.Priority
			highestPriorityTask = j
		end
	end
	return highestPriorityTask
end

--Player asked for work
if (Dialog ~= nil) then
	Dialog.OpenNPCTasksDialog = function(user) --All you have to do in an NPC to get their tasks is to set the return handle to Tasks
	    text = AI.TaskMessages[math.random(1,#AI.TaskMessages)]

	    tasks = NPCTasks

	    if (tasks == nil) then
	    	--if you see this you need to make task entries for the npc
	    	QuickDialogMessage(this,user,"Sorry, I don't have any work for you.")
	    	return
	    end

	    --DebugMessage(DumpTable(user:GetObjVar("NPCTaskList")))
	    response = {}
	    local count = 0
	    local needFaction = false
	    for i,j in pairs(tasks) do
	    	local entry =  GetTaskEntry(user,j.TaskName) 
	    	if (TaskStartCheck(user,j.TaskName) and (entry == nil or entry.Status ~= "Enabled") and count <= 5) then
		    	count = count + 1
		    	response[count] = {}
		    	response[count].text = j.TaskDisplayName
		    	response[count].handle = "NPCTask"..j.TaskName
		    	
		    end

		    if not HasFaction(user,j.TaskName) then
		    	needFaction = true
		    end
	    end

		if(count == 0) then
			text = "Sorry I have no work for you."
			if(needFaction) then 
				local factionName = this:GetObjVar("MobileTeamType") or ""
				text = text .. " If you earn more favor with the "..factionName..", I may be able to find you something."				
			end
		elseif(needFaction) then
			local factionName = this:GetObjVar("MobileTeamType") or ""
			text = text .. " If you earn more favor with the "..factionName..", I will have even more work for you!"
		end

	    response[6] = {}
	    response[6].text = "Nevermind."
	    response[6].handle = "Nevermind" 

	    NPCInteractionLongButton(text,this,user,"NPCTasks",response)
	end

	Dialog.OpenNPCCurrentTasksListDialog = function(user) --All you have to do in an NPC to get their tasks is to set the return handle to Tasks
	    --in this function, you should be able to ask an NPC for help on another NPC's task.
	    text = AI.TaskCurrentMessages[math.random(1,#AI.TaskCurrentMessages)]
	    currentTasks = GetPlayerTasks(user)
	    userTaskTable = user:GetObjVar("NPCTaskList")
	    taskAssistTable = GetTasksICanHelpWith(user)

	    if (currentTasks == nil or #currentTasks == 0) and (taskAssistTable == nil or #taskAssistTable == 0) then
	    	QuickDialogMessage(this,user,AI.NoTasksMessages[math.random(1,#AI.NoTasksMessages)])
	    	return
	    end

		table.sort(taskAssistTable,
			function(a,b) 
				return a.Importance<b.Importance 
			end)
		table.sort(currentTasks,
			function(a,b) 
				return a.Importance<b.Importance 
			end)


	    response = {}

	   --DebugMessage(DumpTable(j))
	    local count = 1
	    for i,j in pairs (userTaskTable) do
		    if (ShouldShowTaskCurrent(user,j.TaskName) and count <= 5) then
		    	response[count] = {}
		    	response[count].text = "Regarding the "..j.TaskDisplayName
		    	response[count].handle = "NPCTask-"..j.TaskName --get the name of the table as the task
		    	count = count + 1
		    end
	    end
	    for i,j in pairs(taskAssistTable) do
		    if (j.Status == "Enabled" and count <= 5) then
		    	response[count] = {}
		    	response[count].text = "Regarding the "..j.TaskDisplayName
		    	response[count].handle = "TaskAssist-"..j.TaskName --get the name of the table as the task
		    	count = count + 1
		    end
	    end
	    if (count == 1) then
	    	QuickDialogMessage(this,user,AI.NoTasksMessages[math.random(1,#AI.NoTasksMessages)])
	    	return
	    end



	    response[6] = {}
	    response[6].text = "Nevermind."
	    response[6].handle = "Nevermind" 

	    NPCInteractionLongButton(text,this,user,"NPCCurrentTasksList",response)
	end
	--the speech that happers when you return to talking to an NPC or ask about a task
	Dialog.OpenNPCTasksInquiryDialog = function(user,taskName)
	    response = {}
	    --DebugMessage("taskName is "..taskName)
	    task = GetNPCTask(taskName)
	    if (task == nil) then return end
	    text = task.TaskCurrentSpeech

		if (TaskIsComplete(user,task,true)) then
			response[1] = {}
			response[1].text = AI.TaskCompletedMessages[math.random(1,#AI.TaskCompletedMessages)]
		    response[1].handle = "CompetedNPCTask-"..taskName
		else
		    response[1] = {}
		    response[1].text = AI.TaskContinueMessages[math.random(1,#AI.TaskContinueMessages)]
		    response[1].handle = "StillDoingNPCTask-"..taskName
		end

		response[2] = {}
		response[2].text = AI.TaskCancelMessages[math.random(1,#AI.TaskCancelMessages)]
		response[2].handle = "CancelNPCTask-"..taskName

		if (task.TaskHelpSpeech ~= nil) then
			response[3] = {}
			response[3].text = AI.TaskRequestHelpSpeech[math.random(1,#AI.TaskRequestHelpSpeech)]
			response[3].handle = "RequestHelpOnTask-"..taskName
		end

	    if (task.Priority == nil or task.Priority == 0) then
		    response[5] = {}
		    response[5].text = "Nevermind."
		    response[5].handle = "Nevermind" 
		end

	    NPCInteractionLongButton(text,this,user,"NPCTaskInquiry",response)
	end
else
	DebugMessage("[incl_npc_tasks] ERROR: Dialog table doesn't exist for this npc yet!")
end
--handle choosing of a task
RegisterEventHandler(EventType.DynamicWindowResponse, "NPCCurrentTasksList",function(user,ButtonID)
	local args = StringSplit(ButtonID,"-")--get the task, if accept task isn't there, it's ButtonID
	--DebugMessage("ButtonID is "..tostring(ButtonID))
	local result = args[1]--get the actual button id, this will remove the whole string if AcceptTask isn't there
	local task = args[2]

	if (ButtonID == "Nevermind") then
		if (Dialog.NevermindDialog ~= nil) then
			Dialog.NevermindDialog() --throw up the nevermind dialog
		else
			DebugMessage("[incl_npc_tasks] Warning: No nevermind dialog for "..this:GetName())
		end
		return
	else
		if (result == "TaskAssist") then
			local playerTaskEntries = user:GetObjVar("NPCTaskList")
			for i,j in pairs(playerTaskEntries) do
				for n,k in pairs(j.TaskAssists) do
					if j.TaskName == task and k.Template == this:GetCreationTemplateId() then
						QuickDialogMessage(this,user,k.Text)
						return
					end
				end
			end
		else
			--DebugMessage("user is "..tostring(user).."task is "..tostring(task))
	    	Dialog.OpenNPCTasksInquiryDialog(user,task)
	    end
	end
end)
--Player has selected a task.
RegisterEventHandler(EventType.DynamicWindowResponse, "NPCTasks",function(user,ButtonID)
	if (ButtonID == "Nevermind") then
		if (Dialog.NevermindDialog ~= nil) then
			Dialog.NevermindDialog() --throw up the nevermind dialog
		else
			DebugMessage("[incl_npc_tasks] Warning: No nevermind dialog for "..this:GetName())
		end
		return
	end

	local taskName = StripFromString(ButtonID,"NPCTask")

	currentTask = NPCTasks[taskName]
	if(currentTask == nil) then
		--DebugMessage("ERROR: Task not found!",tostring(taskName))
		return
	end	

	text = currentTask.TaskDescriptionSpeech

	response = {}

	response[1] = {}
	response[1].text = AI.TaskAcceptMessages[math.random(1,#AI.TaskAcceptMessages)]
	response[1].handle = "AcceptTask"..taskName 

	response[2] = {}
	response[2].text = AI.TaskDeclineMessages[math.random(1,#AI.TaskDeclineMessages)]
	response[2].handle = "Nevermind" 

	NPCInteractionLongButton(text,this,user,"NPCTaskResponse",response)
end)

RegisterEventHandler(EventType.Message,"CheckTaskComplete",function(user,taskName)
	local task = GetNPCTask(taskName)
	local taskComplete = TaskIsComplete(user,task,false)
	if (taskComplete) then
		user:SendMessage("NPCTaskUIMessage","TaskComplete",this,taskName,task.TaskDisplayName,task.Description,task.FinishDescription)
	elseif (not taskComplete) then
		user:SendMessage("NPCTaskUIMessage","TaskOngoing",this,taskName,task.TaskDisplayName,task.Description,task.FinishDescription)
	end
end)

RegisterEventHandler(EventType.DynamicWindowResponse, "NPCTaskInquiry",
function (user,ButtonID)
	local args = StringSplit(ButtonID,"-")--get the task, if accept task isn't there, it's ButtonID
	local result = args[1]--get the actual button id, this will remove the whole string if AcceptTask isn't there
	local task = args[2]
	local npcTask = NPCTasks[task]
	--DebugMessage("user is "..tostring(user).."task is "..tostring(task).." npcTask is "..tostring(npcTask))
	--DebugMessage("task is "..tostring(task).."  result is "..tostring(result))
	if (result == "") then result = ButtonID end --when it strips the task if it's a null string then it's probablly Nevermind
	if (ButtonID == "Nevermind") then
		if (Dialog.NevermindDialog ~= nil) then
			Dialog.NevermindDialog() --throw up the nevermind dialog
			return
		else
			DebugMessage("[incl_npc_tasks] Warning: No nevermind dialog for "..this:GetName())
		end
	elseif (result == "CompetedNPCTask") then
		if (TaskIsComplete(user,npcTask,true)) then	
			CompleteTask(user,npcTask)
		else
			QuickDialogMessage(this,user,npcTask.TaskIncompleteMessage)--throw up a dialog where the NPC tells you it's not done yet. 
			--Since this only happens if the backpack objects are destroyed or moved after you throw up the dialog, it'll only appear rarely.
			--Easter eggs?	
		end
	elseif (result == "RequestHelpOnTask") then

		QuickDialogMessage(this,user,npcTask.TaskHelpSpeech)

	elseif (result == "StillDoingNPCTask") then
		--Throw up dialog about the player still doing the task
		QuickDialogMessage(this,user,npcTask.TaskContinueSpeech)
		--handle faction
	--cancel the task
	elseif (result == "CancelNPCTask") then
		local playersTasks = user:GetObjVar("NPCTaskList")

		if (playersTasks == nil) then return nil end

		for i,j in pairs (playersTasks) do --flag the task on the player as cancelled
			if (j.TaskName == task) then
				j.Status = "Cancelled"
			end
		end
		local noDialog = false
		if npcTask.CancelCallback ~= nil then--handle callback code
			noDialog = npcTask.CancelCallback
		end
		--handle faction
		--throw up a dialog
		if (not noDialog) then--if callback code returns a certian key then stop here
			QuickDialogMessage(this,user,npcTask.TaskCancelSpeech)
		end
		user:SetObjVar("NPCTaskList",playersTasks)
	end
end)

RegisterEventHandler(EventType.DynamicWindowResponse, "NPCTaskResponse",
function (user,ButtonID)
	local task = StripFromString(ButtonID,"AcceptTask")--get the task, if accept task isn't there, it's ButtonID
	local result = StripFromString(ButtonID,task)--get the actual button id, this will remove the whole string if AcceptTask isn't there
	if (result == "") then result = ButtonID end --when it strips the task if it's a null string then it's probablly Nevermind
	if (ButtonID == "Nevermind") then --if it's nevermind then 
		if (Dialog.NevermindDialog ~= nil) then
			Dialog.NevermindDialog() --throw up the nevermind dialog
			return
		else
			DebugMessage("[incl_npc_tasks] Warning: No nevermind dialog for "..this:GetName())
		end
	else--they accepted the task
		--get the task from the task ripped from ButtonID
		local npcTask = NPCTasks[task]
		if (npcTask == nil) then
			--throw an error message
			--DebugMessage("[incl_npc_tasks] ERROR: No task for "..this:GetName().." with the name of "..task)
			return
		else
    		local userTasks = user:GetObjVar("NPCTaskList") or {}
    		--DebugMessage("reset")
    		local taskEntry = GetTaskEntry(user,task)
    		if (taskEntry == nil ) then
    			local taskInfo = 
	    		{
				TaskName = task,
				TaskNPC = this,
				Status = "Enabled",
				TaskDisplayName = npcTask.TaskDisplayName,
				TaskAssists = npcTask.TaskAssists,
				Importance = npcTask.Importance,
	    		}	
	    		table.insert(userTasks,taskInfo)
	    	else
				if (userTasks == nil) then return end
				for n,k in pairs(userTasks) do
					if (k.TaskName == k.TaskName and k.TaskNPC == this) then
						k.Status = "Enabled"
					end
				end
	    	end
    		user:SetObjVar("NPCTaskList",userTasks)
			this:SetObjVar("LastActiveQuest","Task")
			this:SetObjVar("LastActiveTask",questName)
			user:SendMessage("UpdateQuestUI",task,true)
			--DebugMessage(1)
    		if (npcTask.FactionOnAccept ~= nil and not npcTask.Repeatable) then
				AdjustFaction(user,task.FactionOnAccept,task.Faction)
    		end
    		QuickDialogMessage(this,user,npcTask.TaskAcceptSpeech)--throw up a dialog message with the NPC agknowledging the task.

    		if(npcTask.AcceptTaskCallback ~= nil) then
    			npcTask.AcceptTaskCallback(user,npcTask)
    		end
    	end
	end
end)

RegisterEventHandler(EventType.CreatedObject, "reward", 
	function(success,objRef,user,amount)
		if(success and amount > 1) then
			if(IsStackable(objRef)) then
				RequestSetStack(objRef,amount)
			else
				for i=2,amount do
					CreateObjInBackpack(user,objRef:GetCreationTemplateId())
					local user = objRef:TopmostContainer()
					user:SystemMessage("[F7F700]You have received "..objRef:GetName().. ".[-]","event")
				end
			end
		end
	end
)

RegisterEventHandler(EventType.CreatedObject, "recipe", 
	function(success,recipe,recipeIndex,recipeName)
		if (success) then
			if (recipeIndex == nil) then 
				DebugMessage("[incl_npc_tasks] ERROR: Tried to create a nil recipe!") 
				return 
			end
			recipe:SetObjVar("Recipe",recipeIndex)
			recipe:SetObjVar("RecipeDisplayName",recipeName)
			recipeName = "[FF0000]Recipe for "..recipeName.."[-]"
			recipe:SetName(recipeName)
			local user = recipe:TopmostContainer()
			user:SystemMessage("[F7F700]You have received a "..tostring(recipeName).. ".[-]","event")
		end
	end
)

RegisterEventHandler(EventType.CreatedObject, "coins", 
	function(success,objRef,amount)
		if(success and amount > 1) then
			RequestSetStack(objRef,amount)
		end
	end
)
