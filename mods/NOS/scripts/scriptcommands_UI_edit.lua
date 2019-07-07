require 'base_template_list_window'
require 'globals.helpers.allegiance'

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
	return {'Mobiles','PlayerTemplates'}
end

function GetEditCharTemplates()
	if(not(templateListCategory) or not(EditTemplatePresets[templateListCategory])) then return nil end

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
	
	local buttons = {
			{ Text = "Template" },
			{ Text = "Skills" },
			{ Text = "Stats" },
			{ Text = "Other" },
        }
    local categories = GetEditCharCategories()
    if(#categories == 0) then
    	table.remove(buttons,1)
    end

	AddTabMenu(newWindow,
	{
        ActiveTab = mCurrentEditTab, 
        Buttons = buttons
    })	
	
	if(mCurrentEditTab == "Template") then		
		if(templateListCategory == "" and #categories == 1) then
			templateListCategory = categories[1]
			templateListCategoryIndex = 1			
		end

		if(not(templateListCategory) or templateListCategory == "" or not(EditTemplatePresets[templateListCategory])) then
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
		newWindow:AddButton(30,590,"UpdateSkills:","Update",190,26,"Set your new skill values.","",false,"")
	
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
		newWindow:AddButton(30,590,"UpdateStats:","Update",190,26,"Set your new stat values.","",false,"")		

		newWindow:AddLabel(300,590, GetTotalBaseStats(target) .. " / "..ServerSettings.Stats.TotalPlayerStatsCap,100,20,18,"right")
	elseif(mCurrentEditTab == "Other")  then
		local curY = 40
		newWindow:AddLabel(24,curY+13,"[A1ADCC]Name[-]",0,35,18,"left")
		newWindow:AddTextField(100,curY+10,200,20,"name",target:GetName())
		newWindow:AddButton(300,curY+8,"UpdateName:","Update",80,23,"","",false,"")		
		curY = curY + 34
		newWindow:AddLabel(24,curY+13,"[A1ADCC]Title[-]",0,35,18,"left")
		newWindow:AddTextField(100,curY+10,200,20,"title",target:GetSharedObjectProperty("Title"))
		newWindow:AddButton(300,curY+8,"UpdateTitle:","Update",80,23,"","",false,"")		
		curY = curY + 34
		newWindow:AddLabel(24,curY+13,"[A1ADCC]Karma[-]",0,35,18,"left")
		newWindow:AddTextField(100,curY+10,200,20,"karma",tostring(target:GetObjVar("Karma") or 0))
		newWindow:AddButton(300,curY+8,"UpdateKarma:","Update",80,23,"","",false,"")		
		curY = curY + 34
		newWindow:AddLabel(24,curY+13,"[A1ADCC]Allegiance[-]",0,35,18,"left")
		newWindow:AddTextField(100,curY+10,200,20,"allegiance",tostring(GetAllegianceName(target) or ""))
		newWindow:AddButton(300,curY+8,"UpdateAllegiance:","Update",80,23,"","",false,"")		
		curY = curY + 34
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
		elseif(action == "UpdateName") then
			mCurrentEditTarget:SetName(fieldData.name)
			mCurrentEditTarget:SendMessage("UpdateName")
		elseif(action == "UpdateTitle") then
			mCurrentEditTarget:SetSharedObjectProperty("Title", fieldData.title)
		elseif(action == "UpdateKarma") then
			mCurrentEditTarget:SetObjVar("Karma",tonumber(fieldData.karma) or 0)
			mCurrentEditTarget:SendMessage("UpdateName")
		elseif(action == "UpdateAllegiance") then
			if(fieldData.allegiance == "Fire" or fieldData.allegiance == "Pyros") then
				AllegianceRemovePlayer(mCurrentEditTarget)
				AllegianceAddPlayer(mCurrentEditTarget,1)
			elseif(fieldData.allegiance == "Water" or fieldData.allegiance == "Tethys") then
				AllegianceRemovePlayer(mCurrentEditTarget)
				AllegianceAddPlayer(mCurrentEditTarget,2)
			else
				AllegianceRemovePlayer(mCurrentEditTarget)
			end			
		end
	end)
