

function ValidateSkillCapRequest(skillName, requestedCap, target)

	-- ensure cap is between 0 and max
	requestedCap = math.floor(requestedCap)
	requestedCap = math.min(requestedCap, ServerSettings.Skills.PlayerSkillCap.Single)
	requestedCap = math.max(requestedCap, 0)

	if not(IsValidSkill(skillName)) then
		return "Invalid skill '"..skillName.."'.", requestedCap
	end

	if(target == nil) or not(target:IsValid()) then
		return "Invalid Target", requestedCap
	end

	return nil, requestedCap

end

function HandleAdjustSkillCapRequest(skillName, requestedCap, myTarg)
	myTarg = myTarg or this

	if (requestedCap == nil ) then requestedCap = 0 end
	local err, cap = ValidateSkillCapRequest(skillName, requestedCap, myTarg)

	if err == nil then
		-- get their current skill
		local skillLevel = GetSkillLevel(myTarg, skillName, nil, true) or 0

		if (skillLevel > cap) then
		    -- warn them if they will loose any skill points with this change
			local difference = skillLevel - cap
			ClientDialog.Show {
				TargetUser = myTarg,
				TitleStr = "Warning",
				DescStr = "[$1720]"..difference.." points of "..GetSkillDisplayName(skillName).." if you choose to proceed.[-]",
				Button1Str = "Confirm",
				Button2Str = "Cancel",
				ResponseObj = this,
				ResponseFunc = 
				function (user, buttonId)
					if buttonId == 0 then
						ConfirmSkillCapRequest(skillName, cap, myTarg)
					else
						this:SystemMessage("Cancelled.","info")
						-- reload the skill window to snap the slider back
						OpenSkillWindow()
					end
				end
			}
		else
			-- auto confirm otherwise
			ConfirmSkillCapRequest(skillName, cap, myTarg)
		end
	else
		this:SystemMessage(err)
	end

end

function ConfirmSkillCapRequest(skillName, cap, target)
	-- get their current REAL skill level (again)
	local skillDictionary = GetSkillDictionary(target)
	local skillLevel = GetSkillLevel(target, skillName, skillDictionary, true)
	-- set their data for this skill
	if (skillDictionary == nil) then
		skillDictionary = {
			[skillName] = {
				SkillMaxAttained = skillLevel,
				SkillCap = cap
			}
		}
	else
		local skillTable = skillDictionary[skillName]
		if (skillTable == nil) then
			skillTable = {
				SkillMaxAttained = skillLevel,
				SkillCap = cap
			}
		else
			local maxAttained = skillTable.SkillMaxAttained or 0
			-- if their current skill level is greater than previous max attained
			if(skillLevel > maxAttained) then
				-- then set their current max attained to their current skill level
				maxAttained = skillLevel
			end
			skillTable.SkillMaxAttained = maxAttained
			skillTable.SkillCap = cap
		end
		skillDictionary[skillName] = skillTable
	end

	SetSkillDictionary(target, skillDictionary)

	-- adjust their skill down if they set a cap lower than current level. They have been warned.
	this:SystemMessage("You set your personal "..GetSkillDisplayName(skillName) .." skill cap to "..cap..".","info")
	if (skillLevel > cap) then
		SetSkillLevel(target, skillName, cap, false)
		this:SystemMessage("You have forgotten "..(skillLevel - cap).." skill points of "..GetSkillDisplayName(skillName)..".","info")
		UpdateAllPrestigeAbilityActions(this)
	end
end

function SendSkillList()	
	local clientSkillList = {}

	-- for now just send the skill name and initial value
	local skillDict = this:GetObjVar("SkillDictionary")
	for curSkillId, skillData in pairs(SkillData.AllSkills) do
		if( skillData["Skip"]~=true) then						
			local clientData = {curSkillId,skillData.DisplayName,skillData.SkillType,skillData.Description,skillData.DirectlyUsable}
			table.insert(clientSkillList,clientData)
		end
	end

	this:SendClientMessage("SkillList", clientSkillList)
end


RegisterEventHandler(EventType.Message,"SetSkillLevel",
	function(targMob,skillName,actualNewSkill,isGained)
		SetSkillLevel(targMob, skillName, actualNewSkill, isGained)
	end)

RegisterEventHandler(EventType.Message, "UpdateClientSkill", 
	function(skillName,playerObj) 
		playerObj = playerObj or this
		UpdateClientSkill(playerObj,this,skillName) 
	end)

RegisterEventHandler(EventType.Message, "OnSkillLevelChanged", 
	function(skillName) 
		UpdateClientSkill(this,this,skillName) 
	end)
