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
	for i,behaviorName in pairs(storedAI) do
		targetObj:AddModule(behaviorName)
	end
	targetObj:DelObjVar("StoredAI")	
end

function IsPlayerCharacter(target)
    Verbose("General", "IsPlayerCharacter", target)
	if ( target == nil ) then
		LuaDebugCallStack("[IsPlayerCharacter] nil target provided.")
		return false
	end
	return target:IsPlayer() and not(IsPossessed(target))
end

function IsPlayerCorpse(target)
    Verbose("General", "IsPlayerCorpse", target)
	if ( target == nil ) then
		LuaDebugCallStack("[IsPlayerCorpse] nil target provided.")
		return false
	end
	return target:GetCreationTemplateId() == "player_corpse"
end

function IsPossessed(target)
	return target:HasObjVar("PossessionOwner")
end

function GetPossessionOwner(target)
	return target:GetObjVar("PossessionOwner")
end

function DoPossession(possessor,targetObj)		
	local possessionOwner = possessor:GetObjVar("PossessionOwner")
	targetObj = targetObj or possessionOwner	

	local attachType = "ReturnToOwner"
	if(targetObj ~= possessionOwner) then
		SaveAI(targetObj)
		attachType = "Possess"
	end

	-- possessionOwner is not set then we are going from the god to the object
	if not(possessionOwner) then		
		targetObj:SetObjVar("PossessionOwner",possessor)		
	-- otherwise we are jumping to another mob
	else
		RestoreAI(possessor)
		if(targetObj ~= possessionOwner) then
			targetObj:SetObjVar("PossessionOwner",possessionOwner)
		end
	end	

	targetObj:ClearPathTarget()
	if (targetObj:HasModule("spawn_decay")) then
		targetObj:DelModule("spawn_decay")
		targetObj:SetObjVar("ShouldDecay",true)
	end
	targetObj:AttachUser(possessor:GetAttachedUserId())
	if(targetObj ~= possessionOwner) then
		targetObj:AddModule("player",{ AttachType = attachType})	
	else
		-- manually init the player script since it was never detached
		targetObj:SendMessage("OnLoad",false)
	end
	targetObj:SendMessage("PossessionBegin")

	-- Do not remove the player script from the god's actual character
	if (possessionOwner) then
		possessor:DelModule("player")	
	end
end

function EndPossession(targetObj)
	local possessionOwner = GetPossessionOwner(targetObj)
	if(possessionOwner) then
		RestoreAI(targetObj)
		targetObj:DelModule("player")		
		if(targetObj:HasObjVar("ShouldDecay")) then
			targetObj:AddModule("spawn_decay")
		end

		targetObj:SendMessage("PossessionEnd")
	end
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

function GetBodySize (target)
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
			karmaAction = AlterKarmaAction(KarmaActions.Positive.SlayMonster, KarmaActions.Positive.SlayMonster.Adjust*karmaLevel.SlayMonsterModifier)
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
			if ( xpAmount ) then
				AddPrestigeXP(killers[i], splitXpAmount)
			end
			if ( fameValue ) then
				RewardFame(killers[i], splitFameXP)
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