require 'base_template_list_window'

EditTemplatePresets = {

}

-- add prebuilt categories
EditTemplatePresets.PlayerTemplates = {}
for i,templateName in pairs(GetAllTemplateNames("starting_templates")) do
	table.insert(EditTemplatePresets.PlayerTemplates, templateName)
end
for i,templateName in pairs(GetAllTemplateNames("player_test_templates")) do
	table.insert(EditTemplatePresets.PlayerTemplates, templateName)
end
EditTemplatePresets.Mobiles = {}
for i,templateName in pairs(GetAllTemplateNames("mobiles")) do
	table.insert(EditTemplatePresets.Mobiles, templateName)
end

-- override base_template_list_window functions
function GetEditCharCategories()
	if(IsGod(this)) then
		return {'Mobiles','PlayerTemplates'}
	end

	return {}
end

function GetEditCharTemplates()
	templatesListTable = {}
	for i,templateName in pairs(EditTemplatePresets[templateListCategory]) do 
		table.insert(templatesListTable,templateName)
	end

	table.sort(templatesListTable)

	return templatesListTable
end

function CanChangeAppearance()
	return IsDemiGod(this)
end

------------------

mCurrentEditTab = "Template"
mCurrentEditTarget = nil
mIgnoreEquipment = true
mKeepAppearance = true

function OpenCharEditWindow(target)		
	mCurrentEditTarget = target

	local newWindow = DynamicWindow("EditCharWindow","Edit "..StripColorFromString(target:GetName()),450,670)
	
	AddTabMenu(newWindow,
	{
        ActiveTab = mCurrentEditTab, 
        Buttons = {
			{ Text = "Template" },
			{ Text = "Skills" },
			{ Text = "Stats" },
        }
    })	
	
	if(mCurrentEditTab == "Template") then
		local categories = GetEditCharCategories()
		if(templateListCategory == "" and #categories == 1) then
			templateListCategory = categories[1]
			templateListCategoryIndex = 1			
		end

		if(not(templateListCategory) or templateListCategory == "") then
			if(#categories > 1) then
				templateListCategoryIndex = 0
				AddSelectCategory(newWindow,40,GetEditCharCategories())
			end
		else
			AddSelectTemplate(newWindow,40,true,GetEditCharTemplates(),GetEditCharCategories())

			local checkedState = (mIgnoreEquipment and "pressed") or ""
			newWindow:AddButton(30,590,"IgnoreEquipment:","Ignore Equipment",190,26,"Should you ignore the equipment from the template and just take stats/skills.","",false,"",checkedState)
			if(CanChangeAppearance()) then
				local checkedState = (mKeepAppearance and "pressed") or ""
				newWindow:AddButton(220,590,"KeepAppearance:","Keep Appearance",190,26,"Should you change your body type / customization options.","",false,"",checkedState)
			end
		end
	elseif (mCurrentEditTab == "Skills") then
		local skillTable = {}
		for i,j in pairs(SkillData.AllSkills) do 
			j.Name = i
			table.insert(skillTable,j)
		end
		table.sort(skillTable,function (a,b)
			return a.DisplayName < b.DisplayName
		end)
	
		local skillList = ScrollWindow(12,52,390,520,34)
		for index,skill in pairs(skillTable) do
			local skillName = skill.Name
		--if it's not a combat skill
			if not( skill.Skip ) then
				local selected = "default"
				if (mSelectedSkill == skillName) then
					selected = "pressed"				
				end
				scrollElement = ScrollElement()
			--add the section
				scrollElement:AddImage(2,4,"SkillSelectionFrame_Default",360,31,"Sliced")				
				scrollElement:AddLabel(24,13,"[A1ADCC]"..skill.DisplayName.."[-]",225,35,18,"left")
			--add the name
				local statValue = tostring(GetSkillLevel(target,skillName))				
				scrollElement:AddTextField(262,10,80,20,skillName,statValue)

				skillList:Add(scrollElement)
			end
		end
		newWindow:AddScrollWindow(skillList)
		newWindow:AddButton(30,590,"UpdateSkills:","Update",190,26,"Set your new skill values.","",false,"",checkedState)
	
		newWindow:AddLabel(300,590, GetSkillTotal(target) .. " / "..ServerSettings.Skills.PlayerSkillCap.Total,100,20,18,"right")
	elseif (mCurrentEditTab == "Stats") then			
		local statList = ScrollWindow(12,52,390,520,34)
		for index,statName in pairs(allStatsTable) do
			scrollElement = ScrollElement()
		--add the section
			scrollElement:AddImage(2,4,"SkillSelectionFrame_Default",360,31,"Sliced")
			scrollElement:AddLabel(24,13,"[A1ADCC]"..statName.."[-]",225,35,18,"left")
		--add the name

			local statValue = tostring(GetBaseStatValue(target,statName))
			scrollElement:AddTextField(262,10,80,20,statName,statValue)
		
			statList:Add(scrollElement)
		end
		newWindow:AddScrollWindow(statList)
		newWindow:AddButton(30,590,"UpdateStats:","Update",190,26,"Set your new stat values.","",false,"",checkedState)		

		newWindow:AddLabel(300,590, GetTotalBaseStats(target) .. " / "..ServerSettings.Stats.TotalPlayerStatsCap,100,20,18,"right")
	end

	this:OpenDynamicWindow(newWindow)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"EditCharWindow",
	function ( user, buttonId, fieldData )
		local result = StringSplit(buttonId,":")
		local action = result[1]
		local arg = result[2]
		--DebugMessage("DynamicWindowResponse",action,arg)

		local newTab = HandleTabMenuResponse(buttonId)
		if(newTab) then
			mCurrentEditTab = newTab
			OpenCharEditWindow(mCurrentEditTarget)
		elseif(HandleCategoryButtons(action, arg, GetEditCharCategories())) then
			OpenCharEditWindow(mCurrentEditTarget)			
		elseif(action == "select") then
			local args = {KeepAppearance=mKeepAppearance,IgnoreBodyParts=mKeepAppearance,LoadEquipment=not(mIgnoreEquipment),LoadLoot=false}
			mCurrentEditTarget:SendMessage("ChangeMobileToTemplate",arg,{KeepAppearance=mKeepAppearance,IgnoreBodyParts=mKeepAppearance,LoadEquipment=not(mIgnoreEquipment),LoadLoot=false})				
			if(mCurrentEditTarget == this) then
				this:SendMessage("OpenSkillWindow")
				this:SendMessage("OpenCharacterWindow")
			end
			OpenCharEditWindow(mCurrentEditTarget)
		elseif(action == "IgnoreEquipment") then
			mIgnoreEquipment = not(mIgnoreEquipment)
			OpenCharEditWindow(mCurrentEditTarget)
		elseif(CanChangeAppearance() and action == "KeepAppearance") then
			mKeepAppearance = not(mKeepAppearance)
			OpenCharEditWindow(mCurrentEditTarget)
		elseif(action == "UpdateSkills") then
			-- first make sure they are not going over the cap
			local skillTotal = 0
			local singleOverCap = nil
			for k,v in pairs(fieldData) do
				local skillValue = tonumber(v)
				if(skillValue) then
					if(skillValue > ServerSettings.Skills.PlayerSkillCap.Single) then
						singleOverCap = k
					end
					skillTotal = skillTotal + skillValue
				end
			end

			if( singleOverCap ) then
				this:SystemMessage("Skill "..GetSkillDisplayName(singleOverCap) .." is over cap. ("..tostring(ServerSettings.Skills.PlayerSkillCap.Single)..")","info")
			elseif(skillTotal > ServerSettings.Skills.PlayerSkillCap.Total) then
				this:SystemMessage("Total would bring target over cap. ("..tostring(ServerSettings.Skills.PlayerSkillCap.Total)..")","info")
			else
				for k,v in pairs(fieldData) do
					local skillValue = tonumber(v)
					if(skillValue and skillValue ~= GetSkillLevel(mCurrentEditTarget,k)) then
						SetSkillLevel(mCurrentEditTarget,k,skillValue,true)
					end
				end
			end
			if(mCurrentEditTarget == this) then
				this:SendMessage("OpenSkillWindow")
			end
			OpenCharEditWindow(mCurrentEditTarget)
		elseif(action == "UpdateStats") then
			-- first make sure they are not going over the cap
			local statTotal = 0
			local singleUnderMin = nil
			local singleOverCap = nil
			for k,v in pairs(fieldData) do
				local statValue = tonumber(v)
				if(statValue) then
					if(statValue < ServerSettings.Stats.IndividualStatMin) then
						singleUnderMin = k
					elseif(statValue > ServerSettings.Stats.IndividualPlayerStatCap) then
						singleOverCap = k
					end
					statTotal = statTotal + statValue
				end
			end

			if( singleOverCap ) then
				this:SystemMessage("Stat "..singleOverCap .." is over cap. ("..tostring(ServerSettings.Stats.IndividualPlayerStatCap)..")","info")
			elseif( singleUnderMin ) then
				this:SystemMessage("Stat "..singleUnderMin .." is under minimum. ("..tostring(ServerSettingsStats.IndividualStatMin)..")","info")
			elseif(statTotal > ServerSettings.Stats.TotalPlayerStatsCap) then
				this:SystemMessage("Total would bring target over cap. ("..tostring(ServerSettings.Stats.TotalPlayerStatsCap)..")","info")
			else
				for k,v in pairs(fieldData) do
					local statValue = tonumber(v)
					if(statValue and statValue ~= GetBaseStatValue(mCurrentEditTarget,k)) then
						SetStatByName(mCurrentEditTarget, k, statValue)
						mCurrentEditTarget:SystemMessage(k.." changed to "..tostring(statValue),"info")
					end
				end
			end
			if(mCurrentEditTarget == this) then
				this:SendMessage("OpenCharacterWindow")
			end
			OpenCharEditWindow(mCurrentEditTarget)
		end
	end)
