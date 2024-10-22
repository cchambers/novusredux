require 'base_template_list_window'

local createAmountStr = "1"
createAmount = 1
templateId = nil
local createType = "Object"

function ShowSelectCategory()
	local newWindow = DynamicWindow("TemplateList","Create Object",450,700)

	AddSelectCategory(newWindow,0)

	newWindow:AddLabel(20,572,"Amount: ",0,0,20)
	newWindow:AddTextField(100, 570, 100,20, "CreateAmount", createAmountStr)

	newWindow:AddButton(220, 565, "Type:", createType, 150, 25, "", "", false, "")

	newWindow:AddLabel(20,610,"Filter: ",0,0,20)
	newWindow:AddTextField(100, 610, 200,20, "Filter", templateListFilter)
	newWindow:AddButton(320, 605, "ApplyFilter:", "Apply", 100, 0, "", "", false, "")

	this:OpenDynamicWindow(newWindow)
end

function ShowPlacableTemplates()
	if(templateListCategory == "") then
		templateListCategoryIndex = 0
		ShowSelectCategory()
		return
	end

	local newWindow = DynamicWindow("TemplateList","Create Object",450,700)
	
	AddSelectTemplate(newWindow,0,false)

	newWindow:AddLabel(20,572,"Amount: ",0,0,20)
	newWindow:AddTextField(100, 570, 100,20, "CreateAmount", createAmountStr)

	newWindow:AddButton(220, 565, "Type:", createType, 150, 25, "", "", false, "")

	newWindow:AddLabel(20,610,"Filter: ",0,0,20)
	newWindow:AddTextField(100, 610, 200,20, "Filter", templateListFilter)
	newWindow:AddButton(320, 605, "ApplyFilter:", "Apply", 100, 0, "", "", false, "")

	this:OpenDynamicWindow(newWindow)
end

function CreateSelected()
	this:RequestClientTargetLocPreview(this,"createTemplateAt",templateId,Loc(0,0,0),GetTemplateObjectScale(templateId))
end

function ConfirmCreateSelected()
	if ( createAmount > 4 and GetTemplateObjVar(templateId, "ResourceType") == nil ) then
		ClientDialog.Show{
			TargetUser = this,
			DialogId = "CreateAlot",
			TitleStr = "Are you sure",
			DescStr = "You're about to create "..createAmount.." "..templateId..". Do you want to continue?",
			Button1Str = "Yes",
			Button2Str = "No",
			ResponseFunc = function ( user, buttonId )
				buttonId = tonumber(buttonId)
				if( buttonId == 0) then				
					CreateSelected()
				end
			end
		}
	else
		CreateSelected()
	end
end

RegisterEventHandler(EventType.ClientTargetLocResponse, "createTemplateAt",
	function(success,targetLoc)
		--DebugMessage("Arriving here.")
		if not(IsDemiGod(this)) then return end
		if (not success) then return end
		if (targetLoc == nil) then return end
		local createFunc = CreateObj
		if(createType == "Temporary") then createFunc = CreateTempObj
		elseif(createType == "Packed") then createFunc = CreatePackedObjectAtLoc end

		if(createAmount > 1 ) then
			if( GetTemplateObjVar(templateId,"ResourceType") ~= nil) then
				createFunc(templateId,targetLoc,"createamount")
			else
				for i=1,createAmount do
					local spawnLoc = GetNearbyPassableLocFromLoc(targetLoc,1,5)
					if(spawnLoc ~= nil) then
						createFunc(templateId,spawnLoc,"CreateCommand")
					end
				end
			end
		else
			createFunc(templateId,targetLoc,"CreateCommand")
		end
		PlayEffectAtLoc("TeleportFromEffect",targetLoc)
	end
)


RegisterEventHandler(EventType.CreatedObject, "CreateCommand", 
	function(success,objRef,amount)
		if ( success ) then
			SetItemTooltip(objRef)
		end
	end
)

RegisterEventHandler(EventType.CreatedObject,"createamount",
	function(success, objref)
		if(IsStackable(objref)) then
			RequestSetStack(objref,createAmount)
		end
		if ( success ) then
			SetItemTooltip(objref)
		end
	end)

RegisterEventHandler(EventType.DynamicWindowResponse,"TemplateList",
	function (user,returnId,fieldData)
		if(returnId ~= nil) then
			local action, template = string.match(returnId, "(%a+):([%a_%d]*)")

			if(HandleCategoryButtons(action, template)) then
				ShowPlacableTemplates()
				return
			end

			createAmountStr = fieldData.CreateAmount
			templateListFilter = fieldData.Filter

			action, template = string.match(returnId, "(%a+):([%a_%d]*)")
			if(action == "select") then
				createAmount = tonumber(createAmountStr) or 1
				templateId = GetTemplateMatch(template)
				if( templateId ~= nil ) then
					ConfirmCreateSelected()
				end
			elseif( action == "ApplyFilter" ) then
				ShowPlacableTemplates()
			elseif( action == "Type") then
				if(createType == "Object") then createType = "Temporary"
				elseif(createType == "Temporary") then createType = "Packed"
				elseif(createType == "Packed") then createType = "Object" end

				ShowPlacableTemplates()
			else
				if ( createAmount > 1 ) then
					-- fix to set create amount back to 1 after closing window.
					createAmountStr = "1"
					createAmount = 1
				end
			end
		end	
	end)

RegisterEventHandler(EventType.ClientObjectCommand,"createfilter",
	function(user,filterStr)
		templateListFilter = filterStr
		ShowPlacableTemplates()
	end)
