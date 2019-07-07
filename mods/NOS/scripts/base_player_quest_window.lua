function GetAllQuests()
	return this:GetObjVar("QuestTable")
end

function GetAllTasks()
	local taskList = this:GetObjVar("NPCTaskList")
	if (taskList == nil) then return {} end
	local returnTable = {}
	for i,j in pairs(taskList) do
		local newQuestEntry = {
			CurrentTask = j.TaskName,
			QuestName = j.TaskDisplayName,
			TasksComplete = {},
			IsTask = true,
		}
		table.insert(returnTable,newQuestEntry)
	end
	return returnTable
end

function GetAllQuestsAndTasks()
	local taskList = this:GetObjVar("NPCTaskList")
	local questList = this:GetObjVar("QuestTable") 
	local returnTable = {}
	if (taskList ~= nil) then
		for i,j in pairs(taskList) do
			local newQuestEntry = {
				CurrentTask = j.TaskName,
				QuestName = j.TaskDisplayName,
				TasksComplete = {},
				TaskStatus = j.Status,
				IsTask = true,
			}
			table.insert(returnTable,newQuestEntry)
		end
	end
	if (questList ~= nil) then
		for i,j in pairs(questList) do
			table.insert(returnTable,j)
		end
	end
	return returnTable
end

mQuestWindowOpen = false
function ToggleQuestWindow(user)
	mQuestWindowOpen = not mQuestWindowOpen
	if (mQuestWindowOpen) == false then
		user:CloseDynamicWindow("PlayerQuestWindow")
	else
		OpenQuestWindow(user)
	end
end

function OpenQuestWindow(user)
	local quests = nil--PlayerTitles.GetAll(user)
	local window = DynamicWindow("PlayerQuestWindow","Quest Tracker",600,640,-300,-380,"","Center")
	local scrollWindow = ScrollWindow(20,85,540,500,100)

	if (mQuestTab == nil) then
		mQuestTab = "Unfinished"
	end
	if (mQuestTab == "Unfinished") then
		quests = GetAllQuests()
	elseif (mQuestTab == "Finished") then
		quests = GetAllQuests()
	elseif (mQuestTab == "Tasks") then
		quests = GetAllTasks()
	elseif (mQuestTab == "All") then
		quests = GetAllQuestsAndTasks()
	end
	--33
	window:AddButton(23,23,"Unfinished","Unfinished",133,40,"Show unfinished quests.","",false,"")
	window:AddButton(156,23,"Finished","Finished",133,40,"Show finished quests.","",false,"")
	window:AddButton(290,23,"Tasks","Tasks",133,40,"Show tasks to be done for NPC's.","",false,"")
	window:AddButton(423,23,"All","All",133,40,"Show all tasks and quests.","",false,"")

	local showCount = 0
	if (quests ~= nil and #quests > 0) then
		for i,j in pairs(quests) do
			if(AllQuests[j.QuestName]) then
				local show = false
				if (mQuestTab == "All") then
					show = true
				elseif (not j.IsTask and HasFinishedQuest(this,j.QuestName) and mQuestTab == "Finished") then
					show = true
				elseif (not j.IsTask and not HasFinishedQuest(this,j.QuestName) and mQuestTab == "Unfinished") then
					show = true
				elseif (j.IsTask and mQuestTab == "Tasks") then
					show = true
				end

				--add them if they are
				if (show) then
					local questTaskDescription = ""
					if (not j.IsTask and HasFinishedQuest(this,j.QuestName)) then
						questTaskDescription = "[F7F700]Finished[-]"
						j.QuestDisplayName = AllQuests[j.QuestName].QuestDisplayName
						j.Description = AllQuests[j.QuestName].Description
					elseif (not j.IsTask and AllQuests[j.QuestName] and AllQuests[j.QuestName].Tasks[j.CurrentTask]) then
						questTaskDescription = AllQuests[j.QuestName].Tasks[j.CurrentTask].Description
						j.QuestDisplayName = AllQuests[j.QuestName].QuestDisplayName
						j.Description = AllQuests[j.QuestName].Description
					elseif (j.IsTask) then
						questTaskDescription = "[$1712]"--DFB TODO: FIX THIS SO THAT IT TELLS YOU WHO/WHAT ITEMS.
						j.QuestDisplayName = j.QuestName
					end

					showCount = showCount + 1
					local scrollElement = ScrollElement()
					scrollElement:AddImage(0,0,"SectionBackground",528,100,"Sliced")
					local enabled = "default"
					local buttonString = "Track Progress"
					--DebugMessage("Checking window...")
					--DebugMessage("LastActiveQuest is "..tostring(this:GetObjVar("LastActiveQuest")))
					if (this:GetObjVar("LastActiveQuest") == j.QuestName or (this:GetObjVar("LastActiveTask") == j.CurrentTask and this:GetObjVar("LastActiveTask") ~= nil and j.CurrentTask ~= nil) ) then
						--enabled = "disabled"
						buttonString = "[F7F700]Untrack[-]"
					end

					--flag as a task if so
					local TaskStr = ""
					if (j.IsTask) then
						TaskStr = "|Task"
						if (j.TaskStatus ~= "Finished" and j.TaskStatus ~= "Cancelled") then
							scrollElement:AddButton(360,30,j.CurrentTask..TaskStr,buttonString,150,40,buttonString,"",false,"",enabled)
						end
					else						
						scrollElement:AddButton(360,30,j.QuestName..TaskStr,buttonString,150,40,buttonString,"",false,"",enabled)
					end
					--Don't allow tracking of finished tasks
					if(j.Description ~= nil and not j.IsTask) then
						scrollElement:AddLabel(15,15,"Quest Name: "..j.QuestDisplayName.."\nDescription:   [888888]"..j.Description.."\n[-]Current Task:   [888888]"..questTaskDescription,340,80,18,"left")					
					else
						scrollElement:AddLabel(15,15,"Quest Name: "..j.QuestDisplayName.."\nDescription:   [888888]"..questTaskDescription,340,80,18,"left")
					end
					scrollWindow:Add(scrollElement)
				end
			end
		end
	end

	if (quests == nil or showCount == 0) then
		local scrollElement = ScrollElement()
		scrollElement:AddImage(0,0,"SectionBackground",528,100,"Sliced")
		scrollElement:AddLabel(270,15,"No quests/tasks in this section...",340,80,18,"center")
		scrollWindow:Add(scrollElement)
	end

	window:AddScrollWindow(scrollWindow)
	this:OpenDynamicWindow(window,this)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"PlayerQuestWindow",
	function (user,buttonId)
		local isTask = false

		args = StringSplit (buttonId,"|")
		buttonId = args[1]

		if (args[2] == "Task") then
			isTask = true
		else
			isTask = false
		end
		if (buttonId == "" or buttonId == nil) then 
			mQuestWindowOpen = false 
			return 
		end

		--if (buttonId == "Clear") then
		--	this:SetObjVar("titleIndex",0)
		--	this:SetSharedObjectProperty("Title","")
		--	this:SystemMessage("Your title has been cleared.")
		--	return
		if (buttonId == "Unfinished") then
			mQuestTab = "Unfinished"
			OpenQuestWindow(user)
			return
		elseif (buttonId == "Finished") then
			mQuestTab = "Finished"
			OpenQuestWindow(user)
			return
		elseif (buttonId == "Tasks") then
			mQuestTab = "Tasks"
			OpenQuestWindow(user)
			return
		elseif (buttonId == "All") then
			mQuestTab = "All"
			OpenQuestWindow(user)
			return
		end
		if (not isTask) then
			local questName = buttonId
			local activeQuest = this:GetObjVar("LastActiveQuest")
			if (activeQuest == questName) then
				this:DelObjVar("LastActiveQuest")
				questName = nil
			else
				this:SetObjVar("LastActiveQuest",questName)
			end
			this:SendMessage("UpdateQuestUI",questName)
			this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(250),"OpenQuestWindow")
			--DebugMessage("Sending Message")
			--DFB TODO: System message?
		else
			local taskName = buttonId
			local activeTask = this:GetObjVar("LastActiveTask")
			if (activeTask == taskName) then
				this:DelObjVar("LastActiveQuest")
				this:DelObjVar("LastActiveTask")
				taskName = nil
				isTask = nil
			else
				this:SetObjVar("LastActiveQuest","Task")
				this:SetObjVar("LastActiveTask",questName)
			end
			this:SendMessage("UpdateQuestUI",taskName,isTask)
			this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(250),"OpenQuestWindow")

		end
	end)

RegisterEventHandler(EventType.Message,"OpenQuestWindow",OpenQuestWindow)
RegisterEventHandler(EventType.Timer,"OpenQuestWindow",
	function()
		OpenQuestWindow()
	end)