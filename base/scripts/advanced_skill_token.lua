DEFAULT_SKILL_LEVEL = 60

mExpandedCombat = true
mExpandedTrade = false
mSelectedSkill = nil

function GetUsesRemaining()
	return this:GetObjVar("Uses") or 0
end

function GetUsesRemainingStr()
	return "[$1]"..GetUsesRemaining()..")"
end

function GetNewSkillLevel(user)
	local newSkillLevel = DEFAULT_SKILL_LEVEL
	local skillData = SkillData.AllSkills[mSelectedSkill]

	if(this:HasObjVar(mSelectedSkill)) then
		newSkillLevel = this:GetObjVar(mSelectedSkill)
	elseif(skillData ~= nil and this:HasObjVar(skillData.SkillType)) then
		newSkillLevel = this:GetObjVar(skillData.SkillType)
	end

	local specCap = GetSkillCap(user,mSelectedSkill)
	if ( newSkillLevel > specCap ) then
		newSkillLevel = specCap
	end

	return newSkillLevel
end

function ShowTokenWindow(user,selectedSkill)
	mSelectedSkill = selectedSkill or mSelectedSkill
	--DebugMessage(tostring(mSelectedSkill).." is mSelectedSkill")
	
	local dynWindow = DynamicWindow("SkillTokenWindow","Token of Knowledge",890,600,-445,-287,"","Center")
	--dynWindow:AddLabel(0,0,"Hello world!")
	dynWindow:AddImage(0,507,"BasicWindow_Panel",260,40,"Sliced")
	dynWindow:AddImage(0,5,"BasicWindow_Panel",260,500,"Sliced")
	dynWindow:AddLabel(18,520,"Total Skill",100,20,18,"left")
	dynWindow:AddLabel(18+180+50,520,"[STAT:CombatTypeSkill+TradeTypeSkill] / "..ServerSettings.Skills.PlayerSkillCap.Total,100,20,18,"right")
	--skill list
	local skillList = ScrollWindow(12,12,250-14,500-7,35) --423 not 430?
	--add the combat section

	ShowCategory(mExpandedCombat,"CombatTypeSkill",skillList,"Combat","Show all combat skills.",user)
	ShowCategory(mExpandedTrade,"TradeTypeSkill",skillList,"Trade","Show all trade skills.",user)	

	--dynWindow:AddImage(258,0,"ThinFrameBackgroundExpand",620,550,"Sliced")
	--dynWindow:AddImage(258,0,"ExpandBackgroundGradient",20,550,"Sliced")
	dynWindow:AddImage(262,5,"BasicWindow_Panel",608,542,"Sliced")

	dynWindow:AddLabel(568,150,GetUsesRemainingStr(),600,300,24,"center")
	
	dynWindow:AddImage(358,300,"DropHeaderBackground",415,150,"Sliced")

	if not(mSelectedSkill) then
		dynWindow:AddLabel(565,360,"Select a Skill",400,20,24,"center")
	else
		local dispName = SkillData.AllSkills[mSelectedSkill].DisplayName or mSelectedSkill
		dynWindow:AddLabel(565,310,dispName,400,20,24,"center")
		dynWindow:AddLabel(465,345,"Current Skill",400,20,18,"center")
		dynWindow:AddLabel(665,345,"New Skill",400,20,18,"center")

		dynWindow:AddLabel(465,368,tostring(GetSkillLevel(user,mSelectedSkill)),400,20,18,"center")		

		local newSkillLevel = GetNewSkillLevel(user)

		dynWindow:AddLabel(665,368,tostring(newSkillLevel),400,20,18,"center")

		dynWindow:AddImage(565,358,"NextArrow")

		local btnState = (GetSkillLevel(user,mSelectedSkill) < newSkillLevel) and "" or "disabled"
		dynWindow:AddButton(515,405,"Activate|","Activate",100,30,"","",true,"",btnState)
	end

	dynWindow:AddScrollWindow(skillList)

	user:OpenDynamicWindow(dynWindow,this)
end

function ShowCategory(expanded,skillClass,skillList,skillCategoryId,skillTooltip,user,offset)
	local scrollElement = ScrollElement()
	offset = offset or 0
	scrollElement:AddButton(0,0,"ExpandSkills|"..skillCategoryId,"",225+offset,35,skillTooltip,"",false,"Invisible")
	scrollElement:AddImage(0,0,"CategorySelection_Default",225+offset,35,"Sliced")
	
	local capStr = "[a1adcc][STAT:"..skillClass.."]"
	scrollElement:AddLabel(212,10,capStr,225,35,16,"right")	

	scrollElement:AddLabel(30,9,skillCategoryId,225,35,20,"left")
	if (expanded) then
		scrollElement:AddImage(15,13,"CollapseArrow2",11,7)
	else
		scrollElement:AddImage(17,5,"CollapseArrow1",7,16)
	end
	skillList:Add(scrollElement)
	local skillTable = {}
	for i,j in pairs(SkillData.AllSkills) do 
		j.Name = i
		table.insert(skillTable,j)
	end
	table.sort(skillTable,function (a,b)
		return a.Name < b.Name
	end)
	--add the main skills section 
	if (expanded) then
		for index,skill in pairs(skillTable) do
			local skillName = skill.Name
		--if it's not a combat skill
			if (skill.SkillType == skillClass and not (skill.Skip)) then
				if (mSelectedSkill == skillName) then
					selected = "pressed"
				else
					selected = "default"
				end
				scrollElement = ScrollElement()
			--add the section
				scrollElement:AddButton(10,0,"ShowSkill|"..skillName,"",215+offset,35,"Select this skill.","",false,"List",selected)
				scrollElement:AddLabel(30,6,skill.DisplayName,225,35,18,"left")
			--add the name
				scrollElement:AddLabel(200+offset,6,tostring(GetSkillLevel(user,skillName)),225,35,18,"left")
			--add the skill bar
				scrollElement:AddStatBar(19+10,25,190+offset,5,skillName,"FFFFFF",user);
				skillList:Add(scrollElement)
			end
		end
	end
end

RegisterEventHandler(EventType.DynamicWindowResponse,"SkillTokenWindow",
	function ( user,buttonId )
		local result = StringSplit(buttonId,"|")
		local action = result[1]
		local arg = result[2]

		if(action == "ShowSkill") then
			mSelectedSkill = arg
			ShowTokenWindow(user)
		elseif (action == "ExpandSkills") then
			if (arg == "Combat") then
				mExpandedCombat = not mExpandedCombat
			elseif(arg == "Combat Support") then
				mExpandedCombatSupport = not mExpandedCombatSupport
			elseif(arg == "Trade") then
				mExpandedTrade = not mExpandedTrade
			end
			ShowTokenWindow(user)
		elseif(action == "Activate" and mSelectedSkill and GetUsesRemaining() > 0) then
			local newSkillLevel = GetNewSkillLevel(user)
			if ( CanGainSkill(user,mSelectedSkill, newSkillLevel) ) then
				user:SendMessage("SetSkillLevel",user,mSelectedSkill,newSkillLevel,true)
				this:SetObjVar("Uses",GetUsesRemaining()-1)
				user:PlayObjectSound("QuestComplete",false)
				user:PlayEffect("ImpactWaveEffect")
				CallFunctionDelayed(TimeSpan.FromSeconds(2),function()ShowTokenWindow(user)end)
				UpdateTooltip()
			else
				user:SystemMessage("That would put you over your skill cap, please forget some skill points and select again.","info")
				user:SystemMessage("That would put you over your skill cap, please forget some skill points and select again.")
			end
		end
	end)


function ValidateUse(user)
	if( user == nil or not(user:IsValid()) ) then
		return false
	end

	if( this:TopmostContainer() ~= user ) then
		user:SystemMessage("The token must be in your backpack before you can use it.","info")
		return false
	end
	
	return true
end

function UpdateTooltip()
	SetTooltipEntry(this,"skilltoken",GetUsesRemainingStr())
end

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(),
	function()	
		UpdateTooltip()	
        AddUseCase(this,"Examine",true,"HasObject")
	end)

RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if(usedType ~= "Use" and usedType ~= "Examine") then return end
		
		if not(ValidateUse(user) ) then
			return
		end
		
		if(GetUsesRemaining() <= 0) then
			user:SystemMessage("[$4]","info")
			this:Destroy()
		else
			ShowTokenWindow(user)
		end
	end)	