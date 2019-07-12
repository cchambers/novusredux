function GetAIModuleName(targetObj)
	for i,behaviorName in pairs(targetObj:GetAllModules()) do
		if(behaviorName:match("ai") or behaviorName == "base_mobile" or behaviorName == "base_mobile_advanced") then
			return behaviorName
		end
	end
end

function SaveAI(targetObj)
	aiList = {}
	for i,behaviorName in pairs(targetObj:GetAllModules()) do
		if(behaviorName:match("ai")) then
			--DebugMessage("Removing AI: " .. behaviorName)
			table.insert(aiList,behaviorName)
			targetObj:DelModule(behaviorName)
		end
	end
	targetObj:SetObjVar("StoredAI", aiList)	
end

function RestoreAI(targetObj)
	local storedAI = targetObj:GetObjVar("StoredAI")
	if ( storedAI ~= nil ) then
		for i,behaviorName in pairs(storedAI) do
			targetObj:AddModule(behaviorName)
		end
		targetObj:DelObjVar("StoredAI")
	end
end

--- Stop movement, pathing, and if it's a possessee, undo disable and freeze, used for starting and ending possessions
-- @param target(mobileObj)
-- @return none
function ResetMovement(mobileObj)
	mobileObj:ClearPathTarget()
	mobileObj:StopMoving()
	if ( mobileObj:HasModule("possessee") ) then
		mobileObj:DelObjVar("Disabled")
		mobileObj:SetMobileFrozen(false, false)
	end
end

--- Determine if a gameObj has player module, user attached, or controlled by the former
-- @param target(gameObj)
-- @return true or false
function IsPlayerCharacter(target)
    --Verbose("General", "IsPlayerCharacter", target)
	if not( target ) then
		LuaDebugCallStack("[IsPlayerCharacter] target not provided.")
		return false
	end
	if not( target:IsValid() ) then
		LuaDebugCallStack("[IsPlayerCharacter] invalid target provided.")
		return false
	end
	
    return target:IsPlayer() or target:HasModule("player")
end

--- Determine if a gameObj has player module, user attached, or controlled by the former, or is a player corpse
-- @param target(gameObj)
-- @return true or false
function IsPlayerObject(objRef)
    Verbose("General", "IsPlayerObject", objRef)
	if not( objRef ) then
		LuaDebugCallStack("[IsPlayerObject] objRef not provided.")
		return false
	end
	if not( objRef:IsValid() ) then
		LuaDebugCallStack("[IsPlayerObject] invalid objRef provided.")
		return false
	end

	local controller = objRef:GetObjVar("controller")
	if ( controller and controller:IsValid() ) then
		objRef = controller
	end

	-- player corpses are player objects.
    if ( IsPlayerCorpse(objRef) ) then return true end
    
    return IsPlayerCharacter(objRef)
end

--- Determine if a gameObj is a player corpse via GetCreationTemplateId()
-- @param target(gameObj)
-- @return true or false
function IsPlayerCorpse(target)
    Verbose("General", "IsPlayerCorpse", target)
	if ( target == nil ) then
		LuaDebugCallStack("[IsPlayerCorpse] nil target provided.")
		return false
	end
	return target:GetCreationTemplateId() == "player_corpse"
end

--- Validate that a mobile is a valid possessee, with a valid possessor, and that they are linked
-- @param possessee(gameObj), the target to check if possessed
-- @return true or false
function IsPossessed(possessee)
	Verbose("General", "IsPossessed", possessee)
	if not( possessee ) then
		return false
	end
	if not( possessee:IsValid() ) then
		return false
	end

	--validate possessor
	local possessor = GetPossessor(possessee)
	if not(possessor) then return false end
	--validate possessee of above
	local possesseeOfPossessor = GetPossessee(possessor)
	if not(possesseeOfPossessor) then return false end

	--make sure the possessor's possessee and the possessee input match
	if not(possesseeOfPossessor == possessee) then return false end
	
	return true
end

--- Validate that a mobile is a valid possessor, with a valid possessee, and that they are linked
-- @param possessor(gameObj), the target to check if possessing
-- @return true or false
function IsPossessing(possessor)
	Verbose("General", "IsPossessing", possessor)
	if not( possessor ) then
		return false
	end
	if not( possessor:IsValid() ) then
		return false
	end

	--validate possessor
	local possessor = GetPossessor(possessee)
	if not(possessor) then return false end
	--validate possessor of above
	local possessorOfPossessee = GetPossessor(possessee)
	if not(possessorOfPossessee) then return false end

	--make sure the possessee's possessor and the possessor input match
	if not(possessorOfPossessee == possessor) then return false end
	
	return true
end

--- Validate and return the possessor of a possessee, cleans up invalid ObjVar and module
-- @param possessee(gameObj), the target to get the possessor of
-- @return gameObj ID of the possessor or nil
function GetPossessor(possessee)
	Verbose("General", "GetPossessor", possessee)
	if not( possessee ) then
		return
	end
	if not( possessee:IsValid() ) then
		return
	end

	local possessor = possessee:GetObjVar("controller")
	if ( possessor ~= nil ) then
		if ( possessor:IsValid()
		and not(possessor:IsPlayer())
		and possessee:IsPlayer()
		and possessee:HasModule("possessee") ) then
			return possessor
		else
			--CleanupPossessRemnants(possessee)
		end
	end
end

--- Validate and return the possessee of a possessor, cleans up invalid ObjVar
-- @param possessor(gameObj), the target to get the possessee of
-- @return gameObj ID of the possessee or nil
function GetPossessee(possessor)
	Verbose("General", "GetPossessee", possessor)
	if not( possessor ) then
		return false
	end
	if not( possessor:IsValid() ) then
		return false
	end

	local possessee = possessor:GetObjVar("possessee")
	if ( possessee ~= nil ) then
		if ( possessee:IsValid()
		and possessee:IsPlayer()
		and not(possessor:IsPlayer()) ) then
			return possessee
		else	
			--CleanupPossessRemnants(possessor)
		end
	end
end

--- Returns possessor of a gameObj, or returns the input unchanged
-- @param gameObj(gameObj), the target to check for a possessor
-- @return gameObj ID of the possessor or nil
function ChangeToPossessor(gameObj)
	local possessor = GetPossessor(gameObj)
	if (possessor) then
		return possessor
	end
	return gameObj
end

--- Returns possessee of a gameObj, or returns the input unchanged
-- @param gameObj(gameObj), the target to check for a possessee
-- @return gameObj ID of the possessee or nil
function ChangeToPossessee(gameObj)
	local possessee = GetPossessee(gameObj)
	if (possessee and possessee:IsValid()) then
		return possessee
	end
	return gameObj
end

--- Attempts to revert any changes made to a mob during possession. Can be used for possessions that broke/bugged, should not be used on possessed mobs.
-- @param mobileObj(mobileObj), the target to check for a possessee
-- @return none
function CleanupPossessRemnants(mobileObj)
	if not( mobileObj:IsMobile() or IsPlayerCharacter(mobileObj) or mobileObj == nil or mobileObj:IsValid() ) then return false end
	local possessee = mobileObj:GetObjVar("possessee")
	local controller = mobileObj:GetObjVar("controller")

	if ( possessee ~= nil ) then 
		mobileObj:DelObjVar("possessee") 
	end
	if ( controller ~= nil ) then
		mobileObj:DelObjVar("controller")
	end
	if ( mobileObj:HasModule("possessee") ) then mobileObj:DelModule("possessee") end
	RestoreAI(mobileObj)
end

--- Determine if the base minimum requirements for possession are met
-- @possessor(gameObj)
-- @possessee(gameObj)
-- @return true or false
function ValidateTryPossess(possessor,possessee)
	if not( possessor ) then
		return false
	elseif not( possessee ) then
		return false
	elseif not( possessor:IsValid() ) then
		return false
	elseif not( possessee:IsValid() ) then
		return false
	elseif ( possessor == possessee ) then
		possessor:SystemMessage("Cannot possess yourself!","info")
		return false
	elseif ( IsPossessing(possessor) ) then
		possessor:SystemMessage("You are already possessing something.","info")
		return false
	elseif ( IsPossessed(possessee) ) then
		possessor:SystemMessage("Something is already possessing that.","info")
		return false
	elseif ( IsPlayerCharacter(possessee) ) then
		possessor:SystemMessage("That looks too stubborn to possess.","info")
		return false
	elseif ( IsDead(possessee) ) then
		possessor:SystemMessage("Can't do that on the dead.","info")
		return false
	end
	return true
end

function TryPossess(possessor,possessee)
	if not( ValidateTryPossess(possessor,possessee) ) then return false end
	--save mob stuff
	--SaveAI(possessee)
	--possess the target
	possessor:SetObjVar("possessee", possessee)
	possessee:SetObjVar("controller", possessor)
	possessee:AttachUser(possessor:GetAttachedUserId())
	if not( possessee:HasModule("possessee") ) then possessee:AddModule("possessee") end
	--reset movement
	ResetMovement(possessor)
	ResetMovement(possessee)
end

function ValidateEndPossess(possessee)
	if not(IsPossessed(possessee)) then
		return false
	end

	return true
end

function EndPossess(possessee)
	if not( ValidateEndPossess(possessee) ) then return false end
	local possessor = possessee:GetObjVar("controller")
	--restore possessee
	CleanupPossessRemnants(possessee)
	--restore possessor
	CleanupPossessRemnants(possessor)
	--back to player
	possessor:AttachUser(possessee:GetAttachedUserId())
	possessor:SendMessage("OnLoad",false)
	--reset movement
	ResetMovement(possessor)
	ResetMovement(possessee)
end

function IsPoisoned(target)
	return HasMobileEffect(target, "Poison")
end

function CountCoins(target)
	local backpackObj = target:GetEquippedObject("Backpack")
	if( backpackObj == nil ) then
		return 0
	end

	return CountResourcesInContainer(backpackObj,"coins")	
end

-- A "ConsumeResourceResponse" message will be sent to the responseObj with
-- a boolean argument indicating success
function RequestConsumeResource(target,resourceType,amount,transactionId,responseObj, ...)	
	target:SendMessage("ConsumeResource",resourceType, amount, transactionId, responseObj, ...)
end

function IsHuman(target)	
	return target:HasObjectTag("Human")
end
function IsUndead(target)
	return target:HasObjectTag("Undead")
end
function IsMale(target)
	return target:HasObjectTag("Male")
end
function IsFemale(target)
	return target:HasObjectTag("Female")
end

function IsGuard(target)
	if (target:HasObjVar("IsGuard")) then
		return true
	end
	return false
end

function GetBodySize(target)
	--DFB TODO URGENT:  Find out what is causing this to return nil
	if ( target ~= nil and target:IsMobile() ) then
		local bodyOffset = target:GetSharedObjectProperty("BodyOffset")
		if not(bodyOffset) then
			DebugMessage("ERROR: Mobile has no body offset! "..tostring(target:GetCreationTemplateId()))
			return ServerSettings.Combat.DefaultBodySize
		else
			return bodyOffset * target:GetScale().X
		end
	else
		local objectOffset = target:GetSharedObjectProperty("ObjectOffset")
		if (objectOffset ~= nil) then
			return objectOffset
		end
		return ServerSettings.Combat.DefaultBodySize
	end
end

function FaceObject(target,faceTarget)
    if(faceTarget~=nil and faceTarget:IsValid()) then
        --DebugMessage("Facing target")
        target:SetFacing(target:GetLoc():YAngleTo(faceTarget:GetLoc()))
    end
end

function OpenBank(user,bankSource)
	user:SendMessage("OpenBank",bankSource)
end

function OpenTax(user,taxer)
	local plots = Plot.GetUserPlots(user:GetAttachedUserId())
	if(plots and #plots > 0) then
		buttonList = {}
		for i=1,#plots do
			buttonList[i] = { Id=tostring(plots[i].Id), Text=GlobalVarReadKey("Plot."..plots[i].Id, "Name") or "A Plot of Land." }
		end

		ButtonMenu.Show{
	        TargetUser = user,
	        DialogId = "paytax",
	        TitleStr = "Choose Plot",
	        ResponseType = "id",
	        Buttons = buttonList,
	        ResponseObj = taxer,
			ResponseFunc = function(usr,plotId)
				if(plotId ~= nil and usr == user) then
					if not( user:HasModule("plot_tax_window") ) then
						user:AddModule("plot_tax_window")
					end
					local controller = GameObj(tonumber(plotId))
					user:SendMessage("InitTaxWindow", controller)
	            end
	        end,
	    }
	else
		user:SystemMessage("You do not own any plots", "info")
	end
end

--Returns nil if not doing the quest, an empty string if the quest is finished, or the name of the current task in the quest
function GetPlayerQuestState (user,questName)
	if (not user:IsPlayer()) then return end
	local questEntries = user:GetObjVar("QuestTable") or {}
		for index,questEntry in pairs(questEntries) do
			if (questEntry.QuestName == questName) then
				if (questEntry.QuestFinished) then
					return ""
				else
					return questEntry.CurrentTask
				end
			end
		end
	return nil
end

function IsMount(targetObj)
	return ( GetEquipSlot(targetObj) == "Mount" )
end

function HasFinishedQuest (user,questName)
	if (not user:IsPlayer()) then return end
	local questEntries = user:GetObjVar("QuestTable") or {}
		for index,questEntry in pairs(questEntries) do
			if (questEntry.QuestName == questName) then
				if (questEntry.QuestFinished) then
					return true
				else
					return false
				end
			end
		end
	return false
end

function HasFinishedQuestTask(user,questName,task)
	local questEntries = user:GetObjVar("QuestTable") or {}
	if (not user:IsPlayer()) then return end
		for index,questEntry in pairs(questEntries) do
			for taskindex,taskName in pairs(questEntry.TasksComplete) do
				--DebugMessage(taskName,task)
				if (taskName == task) then
					return true
				end
			end
		end
	return false
end

function IsValidInteractTarget(target)
	return target ~= nil and target:IsValid() and not(IsDead(target)) and (not(target:IsCloaked()) or ShouldSeeCloakedObject(this, target))
end


function FacingAngleDiff(attacker, defender)
if(attacker == nil) then return 0 end
if(defender == nil) then return 0 end
if not(attacker:IsValid()) then return 0 end
if not(defender: IsValid()) then return 0 end
	local myFace = attacker:GetFacing()
	local theirFace = defender:GetFacing()
	local myToThem = defender:GetLoc():YAngleTo(attacker:GetLoc())
	--DebugMessage(attacker:GetName() ..tostring(myFace)..defender:GetName() ..tostring(theirFace).." MtT:" ..tostring(myToThem))
	local facingDif = math.abs(theirFace - myToThem)
	if(facingDif > 180) then
		facingDif = 360 - facingDif
	end
	--DebugMessage(tostring(facingDif).."->" .. attacker:GetName())
	if(facingDif % math.floor(facingDif) >= .5) then 
		facingDif = math.ceil(facingDif)
	else
		facingDif = math.floor(facingDif)
	end
	return facingDif
end

ANGLE_FRONT_WINDOW = 60
ANGLE_SIDE_WINDOW = 110
ANGLE_SIDE_BACK_WINDOW = 160
ANGLE_BACK_WINDOW = 180
function GetFacingZone(attacker, defender)
myFaceDiff = FacingAngleDiff(attacker,defender)
	if(myFaceDiff == nil) then return 1 end
	local myFace = 1
	if(myFaceDiff <= ANGLE_BACK_WINDOW) then myFace = 4 end
	if(myFaceDiff <= ANGLE_SIDE_BACK_WINDOW) then myFace = 3 end
	if(myFaceDiff <= ANGLE_SIDE_WINDOW) then myFace = 2 end
	if(myFaceDiff <= ANGLE_FRONT_WINDOW) then myFace = 1 end
	return myFace

end

function GetFactionFromName (factionName)
	for i,j in pairs(Factions) do 
		if (j.Name == factionName) then
			return j
		end
	end
end

function GetFactionFromInternalName (factionName)
	--DebugMessage("factionName is "..tostring(factionName))
	for i,j in pairs(Factions) do 
		--DebugMessage("j.InternalName is "..tostring(j.InternalName))
		if (j.InternalName == factionName) then
			--DebugMessage("Returning last entry")
			return j
		end
	end
	--DebugMessage("Returning nil")
end

function AddToStatistic(target, statName, amount)
	if ( statName == nil ) then return end
	if ( amount == nil ) then amount = 1 end
	local currentStats = target:GetObjVar("Statistics") or {}
	if ( currentStats[statName] == nil ) then
		currentStats[statName] = 0
	end
	currentStats[statName] = currentStats[statName] + amount
	target:SetObjVar("Statistics", currentStats)
end

--- Responsible for giving fame/ability xp, consolidated to a single function
-- @param victim The victim that died and should now reward those tagged to it.
-- @param karmaLevel The karma level for the victim, return value from GetKarmaLevel(GetKarma(victim))
function HandleMobileDeathRewards(victim, karmaLevel)
	if ( karmaLevel == nil ) then
		LuaDebugCallStack("[HandleMobileDeathRewards] Nil karmaLevel provided.")
		return
	end
	Verbose("NpcDeath", "HandleMobileDeathRewards", victim)
	-- tag the mobile whilst getting a list of those to reward
	local killers = TagMob(victim) or {}
	local xpAmount = victim:GetObjVar("PrestigeXP")
	local fameValue = victim:GetObjVar("FameXP")
	if ( #killers > 0 ) then

		local karmaAction = nil
		if ( karmaLevel.SlayMonsterModifier ~= nil ) then
			-- alter the karma action of SlayMonster by the Karma level of the monster.
			karmaAction = AlterKarmaAction(KarmaActions.Positive.SlayMonster, math.floor((KarmaActions.Positive.SlayMonster.Adjust*karmaLevel.SlayMonsterModifier)/#killers))
		end

		local splitXpAmount = xpAmount
		local splitFameXP = fameValue
		if ( xpAmount ) then
			-- split the value among all involved if more than 1
			if ( #killers > 1 ) then
				splitXpAmount = math.ceil(xpAmount / #killers)
			end
		end
		if ( fameValue ) then
			-- hack so we don't have to change hundreds of templates..
			fameValue = fameValue / 100
			-- split the value among all involved if more than 1
			if ( #killers > 1 ) then
				splitFameXP = math.ceil(fameValue / #killers)
			end
		end
		for i=1,#killers do
			if not( IsDead(killers[i]) ) then
				if ( xpAmount ) then
					AddPrestigeXP(killers[i], splitXpAmount)
				end
				if ( fameValue ) then
					RewardFame(killers[i], splitFameXP)
				end
			end
			if ( karmaAction ) then
				ExecuteKarmaAction(killers[i], karmaAction, victim)
			end
		end
	end
	-- prevent resurrecting and killing to get more
	if ( xpAmount ) then
		victim:DelObjVar("PrestigeXP")
	end
	if ( fameValue ) then
		victim:DelObjVar("FameXP")
	end
end

function RequestConsumeResource(target,resourceType,amount,transactionId,responseObj, ...)
	if (resourceType == "coins") then
		target:SendMessage("ConsumeCoins", amount, transactionId, responseObj, ...)
	else
		target:SendMessage("ConsumeResource", resourceType, amount, transactionId, responseObj, ...)
	end
end

function CountCoins(target)

	local total = 0
	local bankObj = target:GetEquippedObject("Bank")
	if( bankObj == nil ) then
		return 0
	end
	
	local backpackObj = target:GetEquippedObject("Backpack")
	if( backpackObj == nil ) then
		return 0
	end

	total = CountResourcesInContainer(bankObj,"coins")
	total = total + CountResourcesInContainer(backpackObj,"coins")	

	return total
end