require 'merchant_generic'

AI.Settings.EnableBuy = true

MAX_TURN_IN = 5

function SetRandomTask()
	if (initializer ~= nil) then

			--Get templates with valid static values
			local validTaskItems = {}
			for i, item in pairs(initializer.TaskItems) do				
				if (GetStaticItemValue(item.Template) ~= nil) then
					table.insert(validTaskItems, item)
				end
			end

			if (#validTaskItems >0) then
			this:SetObjVar("TaskItem", validTaskItems[math.random(1, #validTaskItems)])
			this:SetObjVar("KnownPlayers", {})
			this:SetObjVar("TaskBonus", 1)
			CalculateReward()
			--DebugMessage(this:GetObjVar("TaskItem").Template)
			else
				DebugMessage("NO VALID CAMP MERCHANT TASK ITEMS FOUND")
				return
			end
		else
			DebugMessage("Initializer is nil")
	end
end

function GetKnownPlayer(user)
	if (this:GetObjVar("KnownPlayers") ~= nil) then
		for i, player in pairs(this:GetObjVar("KnownPlayers")) do
			if (user == player) then
				return player
			end
		end
		return nil
	end
end

function AddKnownPlayer(user)
	local knownPlayers = this:GetObjVar("KnownPlayers")
	if (knownPlayers == nil) then
		knownPlayers = {user}
	else
		knownPlayers[#knownPlayers+1] = user
	end
	this:SetObjVar("KnownPlayers", knownPlayers)
end

function PlayerHasTaskItem(user)
	local backpackObj = user:GetEquippedObject("Backpack")
	local backpackTaskItem = FindItemInContainerByTemplate(backpackObj, this:GetObjVar("TaskItem").Template)
	if (backpackTaskItem ~= nil) then
		return backpackTaskItem
	end
end

function HandleSelectedTaskItem(target, user)
	local taskResourceType = GetTemplateObjVar(this:GetObjVar("TaskItem").Template, "ResourceType")
	if (target:GetObjVar("ResourceType") == taskResourceType) then
		--DebugMessage(target:GetObjVar("StackCount"))
		if (target:GetObjVar("StackCount") >= this:GetObjVar("TaskItem").Amount) then
			RequestConsumeResource(user,taskResourceType, this:GetObjVar("TaskItem").Amount,"ConsumeResourceResponse",this, target)
			return
		else
			HandleNotEnoughTaskItem(user)
			return
		end
	else
		HandleWrongTaskItem(user)
	end
end

function HandleNotEnoughTaskItem(user)
	AI.IdleTarget = user

	local taskResourceType = GetTemplateObjVar(this:GetObjVar("TaskItem").Template, "ResourceType")
	--DebugMessage(taskResourceType)

    local dialogText = "Hmmm... This is a good start, but I'm going to need more then this if I'm going to part ways with my hard earned coin."

    response = {
        { text = "Sorry.", handle = "Close" } }

    NPCInteraction(dialogText,this,user,"merchant_interact",response)
    AI.StateMachine.ChangeState("Converse")
end

function HandleWrongTaskItem(user)
	AI.IdleTarget = user

	local taskResourceType = GetTemplateObjVar(this:GetObjVar("TaskItem").Template, "ResourceType")

    local dialogText = "I'm not paying extra for that. I'm looking for "..taskResourceType.."."

    response = {
        { text = "Sorry.", handle = "Close" } }

    NPCInteraction(dialogText,this,user,"merchant_interact",response)
    AI.StateMachine.ChangeState("Converse")
end

function HandleTurnInTaskItem(user)
	AI.IdleTarget = user
    local dialogText = "Oh? Show me!"
    user:RequestClientTargetGameObj(this, "select_task_item")

    response = {
        { text = "Nevermind.", handle = "Close" } }

    NPCInteraction(dialogText,this,user,"merchant_interact",response)
    AI.StateMachine.ChangeState("Converse")
end

function HandleReward(user, target)
	--DebugMessage(GetItemValue(this:GetObjVar("TaskItem")))
	AI.IdleTarget = user
    local dialogText = "Excellent! Thank you!"
    response = 
    { { text = "Sure thing.", handle = "Close" } }

    CalculateReward()
    CreateStackInBackpack(user, "coin_purse", this:GetObjVar("TaskReward"))
	if (this:GetObjVar("TaskBonus") > 0) then
		local currBonus = this:GetObjVar("TaskBonus")
		this:SetObjVar("TaskBonus", currBonus - (1/MAX_TURN_IN))
	end
    NPCInteraction(dialogText,this,user,"merchant_interact",response)
    AI.StateMachine.ChangeState("Converse")
end

function CalculateReward()
    --Reward is based on a modified TaskBonus. 
    --Bonus = (Max percentage * TaskBonus) * (itemValue * stack)/100
    --Total = Bonus + (itemValue * amount)
	local taskItem = this:GetObjVar("TaskItem")
    local itemValue = GetStaticItemValue(taskItem.Template)
    this:SetObjVar("TaskReward", math.ceil((taskItem.MaxPercentage * this:GetObjVar("TaskBonus") * (itemValue * taskItem.Amount)/100) + (itemValue * taskItem.Amount)))
end

-- when user clicks on merchant, show menu
RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if(usedType ~= "Interact") then return end

		FaceObject(this,user)

	    this:StopMoving()

		response = {}
		local text = "Welcome traveller. I've been around the world and offer many goods you may find useful on your journey. Care to peruse my wares?"
		--[[
		if (GetKnownPlayer(user) == nil) then
			text = "Looking to buy something? If you're looking to make some coin yourself, I'm currently in the market for some "..GetTemplateObjVar(this:GetObjVar("TaskItem").Template, "ResourceType")..". Bring some back to me and I'll pay you handsomely!"
			AddKnownPlayer(user)
		else
			text = "Welcome back! Can I interest you in my wares? Or have you perhaps brought me some "..GetTemplateObjVar(this:GetObjVar("TaskItem").Template, "ResourceType").."?"
			
		end
		]]--

		if (this:GetObjVar("TaskReward") ~= nil) then
				text = text.." I'm currently offering ".. this:GetObjVar("TaskReward").. " coin for "..this:GetObjVar("TaskItem").Amount.." of them."
		end

		if (AI.GetSetting("EnableBuy") ~= nil and AI.GetSetting("EnableBuy") == true) then
		    response[1] = {}
		    response[1].text = "I want to buy something."
		    response[1].handle = "Buy" 
		    
		    response[2] = {}
		    response[2].text = "How much would you buy this for?"
		    response[2].handle = "Appraise" 

		    response[3] = {}
		    response[3].text = "I wish to sell something..."
		    response[3].handle = "Sell" 
		end

--[[
		if (PlayerHasTaskItem(user)) then
			response[4] = {}
			response[4].text = "I brought you this."
			response[4].handle = "TurnIn" 
		end
]]--
	    if (CanTrain()) then
			response[5] = {}
			response[5].text = "Train me in this skill..."
			response[5].handle = "Train" 
		end 

	    response[6] = {}
	    response[6].text = "Nevermind"
	    response[6].handle = "Close" 

		NPCInteractionLongButton(text,this,user,"merchant_interact",response)
	end)

-- me
RegisterEventHandler(EventType.DynamicWindowResponse,"merchant_interact", 
	function (user,menuIndex)
	    if( menuIndex == 0 ) then return end
	    if( user == nil or not(user:IsValid())) then return end
	    if( user:DistanceFrom(this) > OBJECT_INTERACTION_RANGE) then return end

		    if( menuIndex == "Bank" ) then
		    	OpenBank(user,this)
		    elseif( menuIndex == "Appraise" ) then	
		    	Merchant.DoAppraise(user)
		    elseif( menuIndex == "Sell" ) then
		    	Merchant.DoSell(user)
		    elseif( menuIndex == "Train" ) then
		    	SkillTrainer.ShowTrainContextMenu(user)
		    elseif (menuIndex == "Buy") then
		    	QuickDialogMessage(this,user,AI.HowToPurchaseMessages[math.random(1,#AI.HowToPurchaseMessages)])
	    	elseif (menuIndex == "TurnIn") then
		    	HandleTurnInTaskItem(user)
		    elseif (menuIndex == "Close") then
		    	user:CloseDynamicWindow("merchant_interact")

		    end
	end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "select_task_item", HandleSelectedTaskItem)

RegisterEventHandler(EventType.Message, "ConsumeResourceResponse", 
    function (success,transactionId,user, target)
    	if (success) then
    		HandleReward(user, target)
    	end
    end)

RegisterEventHandler(EventType.ModuleAttached, GetCurrentModule(),
	function()
		--SetRandomTask()
		--this:ScheduleTimerDelay(TimeSpan.FromMinutes(45), "ChangeTaskTimer")
	end)

--[[RegisterEventHandler(EventType.Timer, "ChangeTaskTimer", 
	function()
		SetRandomTask()
		this:ScheduleTimerDelay(TimeSpan.FromMinutes(45), "ChangeTaskTimer")
	end)
	]]--

OverrideEventHandler("merchant_generic", EventType.EnterView, "MerchantNearbyPlayer", 
	function(target)
	    --DebugMessage("npc:HandleEnterView(" .. tostring(target) .. ")")

	    -- Only speak if enough time has passed since last greeting
	    if ((lastHelloTime + SPEAK_DELAY) < ServerTimeMs()) then
	    	Speak{Text="Have a look at my wares!"}
	    	if (this:GetObjVar("TaskItem") ~= nil) then
	    		Speak{Text="If you have some "..GetTemplateObjVar(this:GetObjVar("TaskItem").Template, "ResourceType")..", I'll pay handsomely for it!"}
	    	end

	    	FaceObject(this,target)
	    	lastHelloTime = ServerTimeMs()
	    end
	end)