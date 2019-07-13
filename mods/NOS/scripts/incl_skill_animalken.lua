function GetMaxPets(target)
	local ak = GetSkillLevel(target,"AnimalKenSkill")
	local bm = GetSkillLevel(target,"BeastMasterySkill")
	maxPets = math.max(1,(ak + bm) / 10)
	return maxPets
end

function CurrentPetCount(target)
	local outC = CountMinionsInPlay(target)
	local followers = target:GetObjVar("Minions") 
	if(followers == nil) then followers = {} end
	local count = 0
	for a,b in pairs(followers) do
		count = count + 1
	end
	
	return count
end

function GetPetName(target)
	return target:GetName()
end

function CountMinionsInPlay(controller,minionsTable)	
	if(minionsTable == nil) then
		minionsTable = controller:GetObjVar("Minions") or {}	
	end

	local minionCount = 0
	local minionActive = controller:GetObjVar("MinionsInPlay") or {}
	for minion,v in pairs(minionsTable) do
		--DebugMessage("Checking",tostring(minion))
		if minion:IsValid() and (minion:TopmostContainer() ~= this) then			
			--DebugMessage("Valid",tostring(minion))
			minionActive[minion] = true
			minionCount = minionCount + 1
		end
	end
 	controller:SetObjVar("MinionsInPlay", minionActive)
	return minionCount
end

function GetPetCommandAction(targetObj,commandName,isGroup)
	local commandData = nil
	for i,j in pairs(defaultPetCommands) do
		if (commandName == i) then
			commandData = j
		end
	end
	if (commandData == nil) then
		DebugMessage("[base_player_charwindow|GetPetCommandAction] ERROR: Pet command not found.")
		return nil  
	end

	local icon = commandData.Icon or "blank"
	local iconText = ""
	if not(commandData.Icon) then
		iconText = commandName:sub(0,3)
	end

	-- special case for stance	
	if(commandName == "stance") then
		local currentStance = targetObj:GetSharedObjectProperty("CombatStance")
		icon = "pet_"..currentStance:lower()
		iconText = ""
	end
	if (isGroup) then
		return
		{
			ID=commandName..":"..targetObj.Id,
			ActionType="PetCommand",
			-- for now pet user actions work on all pets
			DisplayName=(commandData.DisplayName or commandName).. " (All)",
			Icon = icon,
			IconText = iconText,
			Tooltip=commandData.ToolTip,
			Enabled=true,
			ServerCommand="pets " .. commandName,
		}		
	else
		--DebugMessage("pet name is "..tostring(GetPetName(targetObj)))
		return
		{
			ID=commandName..":"..targetObj.Id,
			ActionType="PetCommand",
			-- for now pet user actions work on all pets
			DisplayName=(commandData.DisplayName or commandName).. " (" .. GetPetName(targetObj) .. ")",
			Icon = icon,
			IconText = iconText,
			Tooltip=commandData.ToolTip,
			Enabled=true,
			ServerCommand="pet " ..  commandName .. " " .. targetObj.Id,
		}		
	end
end

