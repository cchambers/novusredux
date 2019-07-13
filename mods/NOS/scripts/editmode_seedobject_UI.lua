require 'NOS:base_uicommon'

curEditTab = nil

templateListCategory = ""
templateListCategoryIndex = 1
templateListFilter = ""

function GetCategories()
	local allCats = GetTemplateCategories()
	table.insert(allCats,1,"All")
	return allCats
end

local tabY = 95

WindowTabFuncs = {
	Transform = function (editWindow)
		editWindow:AddLabel(20,tabY+13,"Position:",0,0,18,"left",false,false)	

		local pos = this:GetLoc()
		editWindow:AddTextField(90,tabY+10,80,20,"PosX",string.format("%.2f",pos.X))
		editWindow:AddTextField(190,tabY+10,80,20,"PosY",string.format("%.2f",pos.Y))
		editWindow:AddTextField(290,tabY+10,80,20,"PosZ",string.format("%.2f",pos.Z))

		editWindow:AddLabel(20,tabY+53,"Rotation:",0,0,18,"left",false,false)	

		local rot = this:GetRotation()
		editWindow:AddTextField(90,tabY+50,80,20,"RotX",string.format("%.2f",rot.X))
		editWindow:AddTextField(190,tabY+50,80,20,"RotY",string.format("%.2f",rot.Y))
		editWindow:AddTextField(290,tabY+50,80,20,"RotZ",string.format("%.2f",rot.Z))

		editWindow:AddLabel(20,tabY+93,"Scale:",0,0,18,"left",false,false)	

		local scale = this:GetScale()
		editWindow:AddTextField(90,tabY+90,80,20,"ScaX",string.format("%.2f",scale.X))
		editWindow:AddTextField(190,tabY+90,80,20,"ScaY",string.format("%.2f",scale.Y))
		editWindow:AddTextField(290,tabY+90,80,20,"ScaZ",string.format("%.2f",scale.Z))

		editWindow:AddButton(230,tabY+130,"UpdatePosition","Update Position",170,23,"",nil,false,"")
	end,
	
	Group = function (editWindow)		
		local curMod = GetModName()	
		local curGroup = this:GetObjVar("SeedGroup")

		local allGroups = GetAllGroupInfo()
		local visibleGroups = GetVisibleSeedGroups()

		--DebugMessage(DumpTable(visibleGroups))

		local scrollWindow = ScrollWindow(25,tabY+10,355,260,25)
		for i,group in pairs(allGroups) do
			local scrollElement = ScrollElement()		

			local displayName = group.CategoryName
			if not(visibleGroups[group.GroupName]) then
				displayName = "[424949]"..displayName.."[-]"
			end

			scrollElement:AddLabel(5, 3, displayName,0,0,18)
			if(group.IsOverriden) then
				scrollElement:AddLabel(310, 3, "[F1C40F]Modified[-]",0,0,18,"right")
			elseif not(group.IsDefault) then
	        	scrollElement:AddLabel(310, 3, "[1ABC9C]Added[-]",0,0,18,"right")
	        end

	        local selState = ""
	        if(curGroup == group.GroupName) then
	            selState = "pressed"
	        elseif not(visibleGroups[group.GroupName]) then
	        	selState = "disabled"
	        end
	           
	        scrollElement:AddButton(320, 3, "SelectGroup|"..group.GroupName, "", 0, 18, "", "", false, "Selection",selState)
	        scrollWindow:Add(scrollElement)
		end	

		editWindow:AddScrollWindow(scrollWindow)

		local disabledState = (DEFAULT_READONLY and GetModName()=="Default") and "disabled" or ""
		editWindow:AddButton(20, tabY+290, "NewGroup", "New", 375, 23, "", "", true, "",disabledState)
	end,

	Template = function (editWindow,user,seedData)
		if(templateListCategory == "") then
			templateListCategoryIndex = 0

			editWindow:AddImage(110,tabY+12,"TitleBackground",250,0,"Sliced")
			editWindow:AddButton(80,tabY+16,"CatLeft","",0,0,"","",false,"LeftArrow")
			editWindow:AddLabel(210,tabY+15,"Select Category",400,0,18,"center")
			editWindow:AddButton(330,tabY+16,"CatRight","",0,0,"","",false,"RightArrow")

			local categories = GetCategories()

			local scrollWindow = ScrollWindow(20,tabY+50,370,240,40)

			for i=1,#categories do	
				local scrollElement = ScrollElement()	
				scrollElement:AddButton(0,0, "category:"..categories[i],categories[i], 350, 0, "", "", false, "")
				scrollWindow:Add(scrollElement)
			end
			
			editWindow:AddScrollWindow(scrollWindow)
		else		
			local templatesListTable = nil

			editWindow:AddImage(40,tabY+12,"TitleBackground",250,0,"Sliced")
			editWindow:AddButton(30,tabY+16,"CatLeft","",0,0,"","",false,"LeftArrow")
			editWindow:AddLabel(160,tabY+15,templateListCategory,340,0,18,"center")
			editWindow:AddButton(280,tabY+16,"CatRight","",0,0,"","",false,"RightArrow")
			editWindow:AddButton(310, tabY+12, "SelectCat", "Back", 80, 23, "", "", false, "")

			if(templateListCategory == "All") then
				templatesListTable = GetAllTemplateNames()
			else
				templatesListTable = GetAllTemplateNames(templateListCategory)
			end

			if(templateListFilter ~= nil and templateListFilter ~= "") then
				local fullList = templatesListTable
				templatesListTable = {}
				for i,v in pairs(fullList) do
					if(v:match(templateListFilter)) then
						table.insert(templatesListTable,v)
					end
				end
			end

			table.sort(templatesListTable)

			local scrollWindow = ScrollWindow(20,tabY+50,370,240,40)

			for i=1,#templatesListTable do	
				local scrollElement = ScrollElement()
				local pressedState = (seedData.Template == templatesListTable[i]) and "pressed" or ""
				scrollElement:AddButton(0,0, "select:"..templatesListTable[i],templatesListTable[i], 350, 0, "", "", false, "",pressedState)
				scrollWindow:Add(scrollElement)
			end
			
			editWindow:AddScrollWindow(scrollWindow)			
		end

		editWindow:AddLabel(20,tabY+310,"Filter: ",0,0,20)
		editWindow:AddTextField(100, tabY+310, 200,20, "Filter", templateListFilter)
		editWindow:AddButton(320, tabY+308, "ApplyFilter", "Apply", 80, 23, "", "", false, "")			
	end,	

	Properties = function (editWindow,user,seedData)
		local noInteractOverride = this:GetObjVar("NoInteractOverride") or false
		local buttonState = noInteractOverride and "pressed" or ""		
		editWindow:AddButton(20, tabY+10, "NoInteract", "No Interact Override", 100, 23, "[$1801]", "", false,"Selection",buttonState)	

		editWindow:AddImage(0,tabY+40,"Divider",380,1,"Sliced")

		editWindow:AddLabel(30,tabY+60,"ObjVar Overrides:",0,0,18,"left",false,false)	
		
		local scrollWindow = ScrollWindow(25,tabY+90,360,200,25)
		if(seedData.ObjVarOverrides ~= nil) then
			local i = 1
			for objVarName,objVarData in pairs(seedData.ObjVarOverrides) do
				local scrollElement = ScrollElement()
				if((i-1) % 2 == 1) then
	            	scrollElement:AddImage(0,0,"Blank",330,25,"Sliced","1A1C2B")
	            end    
	 
	            local varName = objVarName
	            if( objVarName:len() > 25 ) then
	                varName = varName:sub(1,22).."..."
	            end
	            scrollElement:AddLabel(5, 3, varName,0,0,18)
	            local varType = type(objVarData)
	            local valueLabel = nil
	            if( varType == "userdata" or varType == "table") then
	                valueLabel = "["..varType.."]"
	            else
	                valueLabel = tostring(objVarData)
	            end
	            scrollElement:AddLabel(200, 3, valueLabel,0,0,18)	

	            local selState = (objVarName == selObjVar) and "pressed" or ""	            
	            scrollElement:AddButton(320, 3, "SelectObjVar|"..objVarName, "", 0, 18, "", "", false, "Selection",selState)
             
	            scrollWindow:Add(scrollElement)

	            i = i + 1	            
			end
		end

		editWindow:AddScrollWindow(scrollWindow)

		editWindow:AddButton(60, tabY+300, "AddObjVar", "Add", 100, 23, "", "", false,"")
 
        local editState = selObjVar and "" or "disabled"
        editWindow:AddButton(160, tabY+300, "EditObjVar", "Edit", 100, 23, "", "", false,"",editState)
        editWindow:AddButton(260, tabY+300, "DelObjVar", "Delete", 100, 23, "", "", false,"",editState)      
	end,
}

function DoEditWindow(user,editTab)	
	editTab = editTab or curEditTab	or "Transform"

	local editWindow = DynamicWindow("EditSeed","Edit Seed Object",440,500)
	local seedData = this:GetObjVar("SeedData")	or {}

	-- main edit labels
	editWindow:AddLabel(20,10,"Seed Group: "..(this:GetObjVar("SeedGroup") or "*Unassigned*"),0,0,18,"left",false,false)
	editWindow:AddLabel(20,40,"Template: "..(seedData.Template or "empty"),0,0,18,"left",false,false)

	-- tab buttons
	pressedState = editTab == "Transform" and "pressed" or ""
	editWindow:AddButton(10,70,"TransformTab","Transform",100,23,"","",false,"",pressedState)
	--
	pressedState = editTab == "Group" and "pressed" or ""
	editWindow:AddButton(110,70,"GroupTab","Group",100,23,"","",false,"",pressedState)
	--
	pressedState = editTab == "Template" and "pressed" or ""
	editWindow:AddButton(210,70,"TemplateTab","Template",100,23,"","",false,"",pressedState)
	--
	pressedState = editTab == "Properties" and "pressed" or ""
	editWindow:AddButton(310,70,"PropertiesTab","Properties",100,23,"","",false,"",pressedState)

	-- tab frame
	editWindow:AddImage(8,93,"SectionBackground",404,350,"Sliced")
	-- tab content
	WindowTabFuncs[editTab](editWindow,user,seedData)

	-- handle client transform	
	if(curEditTab ~= "Transform" and editTab == "Transform") then
		-- parameters are target object, callback object, callback id, stayopen
		-- stayopen tells the transform to not close when you hit the check box
		user:SendClientMessage("EditObjectTransform",{this,this,"seed_edit",true})
	elseif(curEditTab == "Transform" and editTab ~= "Transform") then
		user:SendClientMessage("CancelObjectTransform")
	end

	curEditTab = editTab

	user:OpenDynamicWindow(editWindow,this)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"EditSeed",
	function (user,buttonId,fieldData)
		if(buttonId == nil or buttonId == "") then
			curEditTab = nil
			user:SendClientMessage("CancelObjectTransform")
			return
		end

		if(fieldData ~= nil and fieldData.Filter ~= nil) then
			templateListFilter = fieldData.Filter
		end

		action, arg = string.match(buttonId, "(%a+):([%a_%d]*)")

		if(buttonId == "TransformTab") then
			DoEditWindow(user,"Transform")
		elseif(buttonId == "GroupTab") then
			DoEditWindow(user,"Group")
		elseif(buttonId == "TemplateTab") then
			DoEditWindow(user,"Template")
		elseif(buttonId == "PropertiesTab") then
			DoEditWindow(user,"Properties")
		elseif(buttonId == "ChangeGroup") then
			DoChangeGroupWindow(user)
		elseif(buttonId == "ChangeTemplate") then
			DoChangeTemplateWindow(user)
		elseif(buttonId == "NoInteract") then
			local noInteractOverride = this:GetObjVar("NoInteractOverride") or false
			this:SetObjVar("NoInteractOverride",not(noInteractOverride))
			DoEditWindow(user)
		elseif(buttonId ~= nil and buttonId:match("SelectObjVar")) then
			local dummy,objVarName = buttonId:match("(%a+)|(.+)")
			selObjVar = objVarName
			DoEditWindow(user)
		elseif(buttonId == "AddObjVar") then
			InitObjVarEditWindow(user)
		elseif(buttonId == "EditObjVar") then
			InitObjVarEditWindow(user,selObjVar)
		elseif(buttonId == "DelObjVar") then
			DeleteObjVarOverride(selObjVar)
			DoEditWindow(user)
		elseif(buttonId == "UpdatePosition") then
			if(tonumber(fieldData.PosX) and tonumber(fieldData.PosY) and tonumber(fieldData.PosZ)
					and tonumber(fieldData.RotX) and tonumber(fieldData.RotY) and tonumber(fieldData.RotZ)
					and tonumber(fieldData.ScaX) and tonumber(fieldData.ScaY) and tonumber(fieldData.ScaZ)) then
				local newPos = Loc(tonumber(fieldData.PosX),tonumber(fieldData.PosY),tonumber(fieldData.PosZ))
				local newRot = Loc(tonumber(fieldData.RotX),tonumber(fieldData.RotY),tonumber(fieldData.RotZ))
				local newScale = Loc(tonumber(fieldData.ScaX),tonumber(fieldData.ScaY),tonumber(fieldData.ScaZ))

				this:SetWorldPosition(newPos)
				this:SetRotation(newRot)
				this:SetScale(newScale)
			else
				user:SystemMessage("Invalid position data.")
			end

			DoEditWindow(user)
		elseif(action == "select") then
			local templateId = arg
			local seedData = this:GetObjVar("SeedData")	
			seedData.Template = templateId
			this:SetObjVar("SeedData",seedData)
			InitializeSeedFromTemplate(templateId)
			this:SendMessage("UpdateTooltip")
			DoEditWindow(user)
		elseif(action == "category") then
			local category = arg
			local templateCategories = GetCategories()
			templateListCategory = category
			templateListCategoryIndex = IndexOf(templateCategories,category)
			DoEditWindow(user)
		elseif(buttonId == "CatLeft") then
			local templateCategories = GetCategories()
			templateListCategoryIndex = ((templateListCategoryIndex - 2) % #templateCategories) + 1
			templateListCategory = templateCategories[templateListCategoryIndex]
			DoEditWindow(user)
		elseif( buttonId == "CatRight") then
			local templateCategories = GetCategories()
			templateListCategoryIndex = (templateListCategoryIndex % #templateCategories) + 1
			templateListCategory = templateCategories[templateListCategoryIndex]
			DoEditWindow(user)
		elseif( buttonId == "SelectCat" ) then
			templateListCategoryIndex = 0
			templateListCategory = ""
			DoEditWindow(user)
		elseif( buttonId == "ApplyFilter" ) then
			if(templateListCategoryIndex == 0) then
				templateListCategoryIndex = 1
				templateListCategory = "All"
			end
			DoEditWindow(user)			
		elseif(buttonId ~= nil and buttonId:match("SelectGroup")) then
			local dummy,groupName = buttonId:match("(%a+)|(.+)")
			this:SetObjVar("SeedGroup",groupName)
			DoEditWindow(user)
		elseif(buttonId == "NewGroup") then
			TextFieldDialog.Show{
		        TargetUser = user,
		        Title = "New Seed Group",
		        Description = "[$1802]",
		        ResponseFunc = function(user,newValue)
		            if(newValue ~= nil and newValue ~= "") then
		                if(not(newValue:match("[A-Za-z0-9._-]+"))) then
		                	user:SystemMessage("Invalid Group Name")
		                else		                	
		                	local curMod = GetModName()	
   							local isModRunning = curMod ~= "Default"
   							local newGroupPrefix = "Default"
   							if(isModRunning) then
   								newGroupPrefix = curMod
   							end

		                	this:SetObjVar("SeedGroup",newGroupPrefix.."."..newValue)
		                	this:SendMessage("UpdateTooltip")
		                	DoEditWindow(user)
		                end
		            end
		        end
		    }
		end
	end)


function GetObjVarOverride(objVarName)
	if(objVarName ~= nil and objVarName ~= "") then 
		local seedData = this:GetObjVar("SeedData")
		if(seedData ~= nil and seedData.ObjVarOverrides ~= nil) then
			return seedData.ObjVarOverrides[objVarName]
		end
	end
end

function SetObjVarOverride(objVarName,objVarValue)
	local seedData = this:GetObjVar("SeedData")
	if not(seedData.ObjVarOverrides) then seedData.ObjVarOverrides = {} end

	seedData.ObjVarOverrides[objVarName] = objVarValue
	this:SetObjVar("SeedData",seedData)
end

function GetStateEntryOverride(entryName)
	if(objVarName ~= nil and objVarName ~= "") then 
		local seedData = this:GetObjVar("SeedData")
		if(seedData ~= nil and seedData.StateEntryOverrides ~= nil) then
			return seedData.StateEntryOverrides[entryName]
		end
	end
end

function GetStateEntryOverride(entryName,entryValue)
	local seedData = this:GetObjVar("SeedData")
	if not(seedData.StateEntryOverrides) then seedData.StateEntryOverrides = {} end

	seedData.StateEntryOverrides[entryName] = entryValue
	this:SetObjVar("SeedData",seedData)
end

function InitObjVarEditWindow(user,objVarName)
	local objVarData = GetObjVarOverride(objVarName)	
	local objVarType = GetValueType(objVarData)

	ObjVarEditWindow.Show{ 
		TargetUser = user,
		Name = objVarName or "",
		Target = this,
		IsNew = (objVarName == nil),
		Type = objVarType,
		Data = objVarData,
		ExcludeTypes = { table=true, GameObj=true, PermanentObj=true },
		SaveFunc = function(objVarEditInfo) 
			SetObjVarOverride(objVarEditInfo.Name,objVarEditInfo.Data) 
			DoEditWindow(objVarEditInfo.TargetUser)
		end,
	}
end

function DeleteObjVarOverride(objVarName)
	local seedData = this:GetObjVar("SeedData")
	if(seedData ~= nil and seedData.ObjVarOverrides ~= nil and seedData.ObjVarOverrides[objVarName] ~= nil) then
		seedData.ObjVarOverrides[objVarName] = nil
		this:SetObjVar("SeedData",seedData)
	end
end