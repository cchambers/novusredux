
DEFAULT_TRAIN_PRICE = 300
-- DAB HACK: This must be the same number as STARTING_SKILL_VALUE from base_skill_sys
STARTING_SKILL_VALUE = 30
menuItemSkills = nil

AI.RefuseTrainMessage = {
	"Fine. I have better things to do anyway.",
}

AI.WellTrainedMessage = {
	"[$1723]",
}

AI.MaxTrainedMessage = {
	"You have too much experience. Anything I could teach you would be lost immediatley. Come back when you're ready to learn."
}

AI.CannotAffordMessages = {
	"[$1724]",
}

AI.TrainScopeMessages = {
	"[$1725]",
}

SkillTrainer = {
	IgnoredSkills = 
	{
	
	}
}

function CanTrain()
	for skillName,skillEntry in pairs(SkillData.AllSkills) do
		--DebugMessage("-------------------------------------------------------")
		--DebugMessage("Skill is "..tostring(skillName))
		--DebugMessage("IsInTableArray = "..tostring(not(IsInTableArray(SkillTrainer.IgnoredSkills,skillName))))
		--DebugMessage("skillEntry.Skip = "..tostring( not(skillEntry.Skip)))
		--DebugMessage("This.GetSkillLevel = "..tostring(GetSkillLevel(this,skillName) >= 30))
		--DebugMessage(tostring(GetSkillLevel(this,skillName)))
		if( not(IsInTableArray(SkillTrainer.IgnoredSkills,skillName))
				and not(skillEntry.Skip)
				and GetSkillLevel(this,skillName) >= 30 ) then
			--DebugMessage(skillName)
			return true
		end
	end
	return false
end

function SkillTrainer.ShowTrainContextMenu(user)
	menuItems = {}

	-- train skills this mobile is an expert in
	for skillName,skillEntry in pairs(SkillData.AllSkills) do
		--DebugMessage("-------------------------------------------------------")
		--DebugMessage("Skill is "..tostring(skillName))
		--DebugMessage("IsInTableArray = "..tostring(not(IsInTableArray(SkillTrainer.IgnoredSkills,skillName))))
		--DebugMessage("skillEntry.Skip = "..tostring( not(skillEntry.Skip)))
		--DebugMessage("This.GetSkillLevel = "..tostring(GetSkillLevel(this,skillName) >= 30))
		--DebugMessage(tostring(GetSkillLevel(this,skillName)))
		if( not(IsInTableArray(SkillTrainer.IgnoredSkills,skillName))
				and not(skillEntry.Skip)
				and GetSkillLevel(this,skillName) >= 30 ) then
			local nextSkill = {
				SkillName = skillName,
				DisplayName = skillEntry.DisplayName
			}
			table.insert(menuItems,nextSkill)
		end
	end	

	text = AI.TrainScopeMessages[math.random(1,#AI.TrainScopeMessages)]

	response = {}
	local n = 0
	for i,j in pairs(menuItems) do
		if (i < 6) then
			local skillData = SkillData.AllSkills[j.SkillName]
			local nextResponse = {}
    		nextResponse = {}
    		nextResponse.text = "I want to learn ".. skillData.DisplayName
    		nextResponse.handle = j.SkillName .."SkillResponse"
    		table.insert(response,nextResponse)
    		n = i
    	else
    		DebugMessage("[base_skill_trainer|SkillTrainer.ShowTrainContextMenu] ERROR: No more than 4 skills supported! Implement Scroll Bars!")
    	end
	end

	response[n+1] = {}
	response[n+1].text = "Nevermind"
	response[n+1].handle = "Nevermind"

	NPCInteractionLongButton(text,this,user,"TrainDialog",response)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"TrainDialog",
	function (user,buttonID)
	    if( buttonID == nil or buttonID == "") then return end
	    if( user == nil or not(user:IsValid())) then return end
	    if( user:DistanceFrom(this) > OBJECT_INTERACTION_RANGE) then return end

	    local skillName = StripFromString(buttonID,"SkillResponse")
	    --DebugMessage("buttonID is '"..tostring(buttonID) .."'")

		if( buttonID == "Nevermind") then		
			if (AI.RefuseTrainMessage ~= nil) then	
				this:NpcSpeech(AI.RefuseTrainMessage[math.random(1,#AI.RefuseTrainMessage)])
				user:CloseDynamicWindow("TrainDialog")
				return
			else
				NevermindDialog()
				return
			end
		end


	    local skillData = SkillData.AllSkills[skillName]
		if (skillData == nil ) then 
			DebugMessage("[base_skill_trainer|TrainDialog] ERROR: skillData is nil for: "..this:GetName().." skillName: "..skillName)
			return
		end		
		
	    FaceObject(this,user)
	    if( GetSkillLevel(user,skillName) >= STARTING_SKILL_VALUE) then

			response = {}

	    	text = AI.WellTrainedMessage[math.random(1,#AI.WellTrainedMessage)]

			response[1] = {}
			response[1].text = "Right"
			response[1].handle = "Nevermind"

			NPCInteractionLongButton(text,this,user,"TrainDialog",response)

	    	return
		end

		if (GetSkillTotal(user) >= (ServerSettings.Skills.PlayerSkillCap.Total - STARTING_SKILL_VALUE)) then
			response = {}

	    	text = AI.MaxTrainedMessage[math.random(1,#AI.MaxTrainedMessage)]

			response[1] = {}
			response[1].text = "Right"
			response[1].handle = "Nevermind"

			NPCInteractionLongButton(text,this,user,"TrainDialog",response)

	    	return
		end

		if (GetSkillCap(user, skillName, GetSkillDictionary(user)) < STARTING_SKILL_VALUE) then
			response = {}

	    	text = "I can't teach someone who doesn't want to learn. Come back when you give yourself the capacity to learn from me."

			response[1] = {}
			response[1].text = "Right"
			response[1].handle = "Nevermind"

			NPCInteractionLongButton(text,this,user,"TrainDialog",response)

	    	return
		end

		if( CountCoins(user) < 30 ) then

			--DebugMessage("Error here 1")
			if (AI.CantAffordTrainPurchaseMessages) then
				text = AI.CantAffordTrainPurchaseMessages[math.random(1,#AI.CantAffordTrainPurchaseMessages)]
			else
				text = AI.CannotAffordMessages[math.random(1,#AI.CannotAffordMessages)]
			end

			text = text..""..ValueToAmountStr(DEFAULT_TRAIN_PRICE,false,true).."."
		
			response = {}

			response[1] = {}
			response[1].text = "Oh..."
			response[1].handle = "Nevermind"

			NPCInteractionLongButton(text,this,user,"TrainDialog",response)
			
			return
		end			
	    
		user:CloseDynamicWindow("TrainDialog")

		text = "I can teach you the basics of "..skillData.DisplayName.." for "..ValueToAmountStr(DEFAULT_TRAIN_PRICE,false,true).."."
		response = {}

		response[1] = {}
		response[1].text = "Yes, please."
		response[1].handle = "Teach"..skillName

		response[2] = {}
		response[2].text = "No, thank you."
		response[2].handle = "Nevermind"

		NPCInteractionLongButton(text,this,user,"TeachSkill",response,nil,nil,max_distance)
	    
	end)

RegisterEventHandler(EventType.DynamicWindowResponse,"TeachSkill", 
	function (user,buttonId)
	    --local skillName = StripFromString(buttonID,"Teach")

		if( buttonId == "Nevermind") then		
			if (NevermindDialog == nil) then	
				this:NpcSpeech(AI.RefuseTrainMessage[math.random(1,#AI.RefuseTrainMessage)])
			else
				NevermindDialog()
			end
		elseif (buttonId:match("Teach")) then
			RequestConsumeResource(user,"coins",DEFAULT_TRAIN_PRICE,buttonId,this)
		end
		user:CloseDynamicWindow("TeachSkill")
	end)

RegisterEventHandler(EventType.Message, "ConsumeResourceResponse", 
	function (success,transactionId,user)	
		if not(transactionId:match("Teach")) then return end

		if not(success) then
			if (AI.CantAffordTrainPurchaseMessages) then
				text = AI.CantAffordTrainPurchaseMessages[math.random(1,#AI.CantAffordTrainPurchaseMessages)]
			else
				text = AI.CannotAffordMessages[math.random(1,#AI.CannotAffordMessages)]
			end

			text = text..""..ValueToAmountStr(DEFAULT_TRAIN_PRICE,false,true).."."

			response = {}
			
			response[1] = {}
			response[1].text = "Oh..."
			response[1].handle = "Nevermind"

			NPCInteractionLongButton(text,this,user,"Responses",response)
	    	return
		else
			-- cut train off the id	
	    	local skillName = StripFromString(transactionId,"Teach")		
			--DebugMessage(skillName)
			SetSkillLevel(user, skillName, 30, true)
		end
	end)

if (initializer ~= nil) then
	if (initializer.IgnoredSkills ~= nil) then
		SkillTrainer.IgnoredSkills = initializer.IgnoredSkills
	end
end
