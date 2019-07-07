curManageTab = "Default"

selectedGroupName = nil
expandedGroups = {}

--[[function LoadEditorSeeds(seedGroups,newGroupName)	
	for i,seedGroup in pairs(seedGroups) do		
		local newSeedGroup = newGroupName or seedGroup
		local seedData = GetSeedGroupData(seedGroup)
		for i,seedEntry in pairs(seedData) do				
			local templateData = GetTemplateData(seedEntry.Template)

			local scale = seedEntry.Scale or Loc(1,1,1)
			if(templateData ~= nil and templateData.ScaleModifier) then
				scale = Loc(scale.X * templateData.ScaleModifier,scale.Y * templateData.ScaleModifier,scale.Z * templateData.ScaleModifier)
			end
			CreateObjExtended("empty", nil, seedEntry.Position, seedEntry.Rotation, scale, "seed_create", newSeedGroup, seedEntry)
		end
	end
end

function CommitSeedGroup(seedGroup)
	local saveSeedData = {}
	local seedsToSave = FindObjects(SearchObjVar("SeedGroup",seedGroup))
	for i,seedObj in pairs(seedsToSave) do
		local curSeedData = seedObj:GetObjVar("SeedData")
		if(curSeedData.Template ~= nil) then
			curSeedData.Position = seedObj:GetLoc()
			curSeedData.Rotation = seedObj:GetRotation()
			curSeedData.Scale = seedObj:GetScale()
			table.insert(saveSeedData,curSeedData)
		end
	end
	SaveSeedGroup(seedGroup,saveSeedData)
end--]]



function DoManageWindow()	
	--[[local curMod = GetModName()	
	local isModRunning = curMod ~= "Default"

	local visibleSeedGroups = GetVisibleSeedGroups()	
	local allGroups = GetAllGroupInfo()

	local manageWindow = DynamicWindow("ManageSeeds","Manage Seeds",440,500)

	local scrollWindow = ScrollWindow(25,20,355,225,25)
	for i,group in pairs(allGroups) do
		local scrollElement = ScrollElement()		

		local displayName = group.CategoryName
		if not(visibleSeedGroups[group.GroupName]) then
			displayName = "[424949]"..displayName.."[-]"
		end

		scrollElement:AddLabel(5, 3, displayName,0,0,18)
		if(group.IsOverriden) then
			scrollElement:AddLabel(310, 3, "[F1C40F]Override[-]",0,0,18,"right")
		elseif not(group.IsDefault) then
        	scrollElement:AddLabel(310, 3, "[1ABC9C]Added[-]",0,0,18,"right")
        end

        local selState = ""
        if(selectedGroupName == group.GroupName) then
            selState = "pressed"
        end
           
        scrollElement:AddButton(320, 3, "Select|"..group.GroupName, "", 0, 18, "", "", false, "Selection",selState)
        scrollWindow:Add(scrollElement)
	end	

	manageWindow:AddScrollWindow(scrollWindow)

	local selectedGroup = searchTable(allGroups,selectedGroupName,
		function (group,groupName)
			return group.GroupName == groupName
		end)

	-- buttons that require a selection are disabled if nothing is selected
	local selState = selectedGroupName and "" or "disabled"
	-- we can edit if default is not read only or we are not on the default tab
	local canEdit = selectedGroup and (not(DEFAULT_READONLY) or not(selectedGroup.IsDefault))
	-- buttons that require editing are disabled if we can't edit or nothing is selected
	local editState = (selectedGroupName and canEdit) and "" or "disabled"
	-- the new button is disabled if we can't edit
	local newState = canEdit and "" or "disabled"

	manageWindow:AddButton(25, 280, "ShowGroup", "Show", 90, 23, "[$1788]", "", false,"",selState) 	
    manageWindow:AddButton(120, 280, "HideGroup", "Hide", 90, 23, "[$1789]", "", false,"",selState)
    manageWindow:AddButton(215, 280, "SaveGroup", "Save", 90, 23, "[$1790]", "", false,"",editState) 
    manageWindow:AddButton(310, 280, "DelGroup", "Delete", 90, 23, "[$1791]", "", false,"",editState) 
	
    manageWindow:AddButton(25, 310, "DupGroup", "Copy", 90, 23, "Copies the currently selected seed group.", "", false,"",selState) 

    manageWindow:AddImage(0,345,"Divider",400,1,"Sliced")

    manageWindow:AddButton(25, 360, "NewGroup", "New", 90, 23, "[$1792]", "", false,"",newState) 
    manageWindow:AddButton(120, 360, "ShowAll", "Show All", 90, 23, "Show every seed group.", "", false,"")
    manageWindow:AddButton(215, 360, "HideAll", "Hide All", 90, 23, "Hide every seed group.", "", false,"")
    manageWindow:AddButton(310, 360, "ResetWorld", "Show Initial", 90, 23, "[$1793]", "", false,"") 
    manageWindow:AddButton(25, 390, "Save", "Save All", 90, 23, "[$1794]", "", false,"") 
    
    this:OpenDynamicWindow(manageWindow)]]--

	local curMod = GetModName()	
	local isModRunning = curMod ~= "Default"	

	local manageWindow = DynamicWindow("ManageSeeds","Manage Seeds",440,500)

    local defaultState = ""
    if(curManageTab == "Default") then
        defaultState = "pressed"
    end    
    manageWindow:AddButton(20,10,"DefaultTab","Default",190,23,"","",false,"",defaultState)

    if(isModRunning) then
	    local modState = ""
	    if(curManageTab == "Mod") then
	        modState = "pressed"
	    end
	    manageWindow:AddButton(210,10,"ModTab",curMod,190,23,"","",false,"",modState)
	end

	local workspace = GetEditModeWorkspace()

	local scrollWindow = ScrollWindow(25,45,355,225,25)
	for groupName,groupInfo in pairs(workspace.Groups[curManageTab]) do
		local scrollElement = ScrollElement()		        

        local displayName = groupName
		if not(groupInfo.Visible) then
			displayName = "[424949]"..displayName.."[-]"
		end
        scrollElement:AddLabel(5, 3, displayName,0,0,18)

        if(groupInfo.IsExcluded) then
			scrollElement:AddLabel(310, 3, "[F1C40F]Excluded[-]",0,0,18,"right")
		end

        local selState = ""
        if(selectedGroupName == groupName) then
            selState = "pressed"
        end
           
        scrollElement:AddButton(320, 3, "Select|"..groupName, "", 0, 18, "", "", false, "Selection",selState)
        scrollWindow:Add(scrollElement)
	end	

	manageWindow:AddScrollWindow(scrollWindow)

	-- buttons that require a selection are disabled if nothing is selected
	local selState = selectedGroupName and "" or "disabled"
	-- we can edit if default is not read only or we are not on the default tab
	local canEdit = not(DEFAULT_READONLY) or curManageTab ~= "Default"	
	-- buttons that require editing are disabled if we can't edit or nothing is selected
	local editState = (selectedGroupName and canEdit) and "" or "disabled"
	-- the new button is disabled if we can't edit
	local newState = canEdit and "" or "disabled"

	manageWindow:AddButton(25, 280, "ShowGroup", "Show", 90, 23, "[$1795]", "", false,"",selState) 	
    manageWindow:AddButton(120, 280, "HideGroup", "Hide", 90, 23, "[$1796]", "", false,"",selState)
    manageWindow:AddButton(215, 280, "DelGroup", "Delete", 90, 23, "[$1797]", "", false,"",editState) 	
    manageWindow:AddButton(310, 280, "DupGroup", "Copy", 90, 23, "Copies the currently selected seed group.", "", false,"",selState) 
    manageWindow:AddButton(25, 310, "ExcludeGroup", "Exclude", 90, 23, "[$1798]", "", false,"",selState) 

    manageWindow:AddImage(0,345,"Divider",400,1,"Sliced")

    manageWindow:AddButton(25, 360, "NewGroup", "New", 90, 23, "[$1799]", "", false,"",newState) 
    manageWindow:AddButton(120, 360, "ShowAll", "Show All", 90, 23, "Show every seed group.", "", false,"")
    manageWindow:AddButton(215, 360, "HideAll", "Hide All", 90, 23, "Hide every seed group.", "", false,"")
    manageWindow:AddButton(310, 360, "ResetWorld", "Show World Reset", 90, 23, "[$1800]", "", false,"") 
    manageWindow:AddButton(25, 390, "Save", "Save", 90, 23, "Saves the seed groups for this mod.", "", false,"") 
    manageWindow:AddButton(25, 390, "Revert", "Revert", 90, 23, "Revert the world back to the last save.", "", false,"") 
       
    this:OpenDynamicWindow(manageWindow)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"ManageSeeds",
	function (user,buttonId)
		if(buttonId == "DefaultTab") then
			if(curManageTab ~= "Default") then
				curManageTab = "Default"				
				selectedGroupName = nil
			end
			DoManageWindow()
		elseif(buttonId == "ModTab") then
			local modName = GetModName()
			if(curManageTab ~= "Mod") then
				curManageTab = "Mod"
				selectedGroupName = nil
			end
			DoManageWindow()
		elseif(buttonId:match("Select")) then
			local dummy,groupName = buttonId:match("(%a+)|(.+)")
			selectedGroupName = groupName
			if(curManageTab ~= "Default" or not(DEFAULT_READONLY)) then
				this:SetObjVar("ActiveGroupName",selectedGroupName)
			end
			DoManageWindow()
		elseif(buttonId:match("ShowGroup")) then
			if(selectedGroupName ~= nil) then
				GetEditModeController():SendMessage("ShowGroup",selectedGroupName)
				CallFunctionDelayed(TimeSpan.FromSeconds(0.5),function () DoManageWindow() end)
			end			
		elseif(buttonId:match("HideGroup")) then
			if(selectedGroupName ~= nil) then
				GetEditModeController():SendMessage("HideGroup",selectedGroupName)
				CallFunctionDelayed(TimeSpan.FromSeconds(0.5),function () DoManageWindow() end)
			end			
		--elseif(buttonId:match("SaveGroup")) then
		--	CommitSeedGroup(selectedGroupName)
		elseif(buttonId:match("DelGroup")) then
			GetEditModeController():SendMessage("DeleteGroup",selectedGroupName)
			CallFunctionDelayed(TimeSpan.FromSeconds(0.5),function () DoManageWindow() end)
		elseif(buttonId:match("DupGroup")) then
			if(selectedGroupName ~= nil) then
				TextFieldDialog.Show{
			        TargetUser = user,
			        Title = "Duplicate Seed Group",
			        Description = "Enter the new seed group name.",
			        ResponseFunc = function(user,newValue)
			            if(newValue ~= nil and newValue ~= "") then
			                if(not(newValue:match("[A-Za-z0-9._-]+"))) then
			                	user:SystemMessage("Invalid Group Name")
			                else		                	
			                	-- you can override the seed group for the new seed objects
			                	-- by passing the override name as the second parameter
			                	--LoadEditorSeeds({selectedGroupName},newGroupName)
			                	--selectedGroupName = newGroupName
			                	GetEditModeController():SendMessage("DuplicateGroup",selectedGroupName,newValue)
			                	if(curMod ~= "Default") then
				                	curManageTab = "Mod"
				                end
				                selectedGroupName = newValue
				                CallFunctionDelayed(TimeSpan.FromSeconds(0.5),function () DoManageWindow() end)
			                end
			            end
			        end
			    }
			end
		elseif(buttonId:match("NewGroup")) then
			TextFieldDialog.Show{
			        TargetUser = user,
			        Title = "New Seed Group",
			        Description = "Enter the new seed group name.",
			        ResponseFunc = function(user,newValue)
			            if(newValue ~= nil and newValue ~= "") then
			                if(not(newValue:match("[A-Za-z0-9._-]+"))) then
			                	user:SystemMessage("Invalid Group Name")
			                else		                	
			                	-- you can override the seed group for the new seed objects
			                	-- by passing the override name as the second parameter
			                	--LoadEditorSeeds({selectedGroupName},newGroupName)
			                	--selectedGroupName = newGroupName
			                	GetEditModeController():SendMessage("NewGroup",newValue)
			                	if(curMod ~= "Default") then
				                	curManageTab = "Mod"
				                end
				                selectedGroupName = newValue
				                CallFunctionDelayed(TimeSpan.FromSeconds(0.5),function () DoManageWindow() end)
			                end
			            end
			        end
			    }
		elseif(buttonId:match("ShowAll")) then
			GetEditModeController():SendMessage("ShowAll")
			CallFunctionDelayed(TimeSpan.FromSeconds(0.5),function () DoManageWindow() end)
		elseif(buttonId:match("HideAll")) then
			GetEditModeController():SendMessage("HideAll")
			CallFunctionDelayed(TimeSpan.FromSeconds(0.5),function () DoManageWindow() end)
		elseif(buttonId:match("ResetWorld")) then
			GetEditModeController():SendMessage("ResetWorld")
			CallFunctionDelayed(TimeSpan.FromSeconds(0.5),function () DoManageWindow() end)
		elseif(buttonId:match("Save")) then
			GetEditModeController():SendMessage("Save",this)
			CallFunctionDelayed(TimeSpan.FromSeconds(0.5),function () DoManageWindow() end)
		elseif(buttonId:match("Revert")) then
			GetEditModeController():SendMessage("Revert",this)
			CallFunctionDelayed(TimeSpan.FromSeconds(0.5),function () DoManageWindow() end)
		end
	end)