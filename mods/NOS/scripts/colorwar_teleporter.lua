USE_RANGE = 2
confirmDialogOpen = false
function DoTeleport(user, targetLoc, destRegionAddress)
	if (user:HasModule("sitting")) then
		user:SendMessage("StopSitting")
	end

	TeleportUser(this, user, targetLoc, destRegionAddress)
end

function ActivateTeleporter(user)
	local newTime = ServerTimeSecs()
	local carriedObject = user:CarriedObject()
	if (carriedObject ~= nil) then
		user:SystemMessage("You can't carry objects through a portal.", "info")
		return
	end

	if not (this:HasObjVar("TeleporterRange")) then
		if ((this:DistanceFrom(user) > USE_RANGE) and this:GetObjVar("Summoner")) then
			return
		end
	else
		if (this:DistanceFrom(user) > (this:GetObjVar("TeleportRange") or 2)) then
			return
		end
	end

	local keyTemplate = this:GetObjVar("KeyTemplate")
	if (keyTemplate ~= nil and not (IsImmortal(user))) then
		local found = false
		local backpackObj = user:GetEquippedObject("Backpack")
		if (backpackObj ~= nil) then
			local packObjects = backpackObj:GetContainedObjects()
			for index, packObj in pairs(packObjects) do
				if (packObj:GetCreationTemplateId() == keyTemplate) then
					found = true
				end
			end
		end

		if not (found) then
			user:SystemMessage("[$2633]", "info")
			return
		else
			--DFB HACK: Send a message to update the quest system for the starting portal
			user:SendMessage("QuestUpdate")
		end
	end

	local requiredObjVar = this:GetObjVar("RequiredObjVar")
	if (requiredObjVar ~= nil and not user:HasObjVar(requiredObjVar) and not (IsImmortal(user))) then
		user:SystemMessage(this:GetObjVar("InvalidUseMessage") or "The portal fails to respond to your presence.")
		this:SendMessage("TeleportFailEventMessage", user)
		return
	end

	local requiredQuestState = this:GetObjVar("QuestTaskRequired")
	if (requiredQuestState ~= nil and not IsImmortal(user)) then
		local questArgs = StringSplit(requiredQuestState, "|")
		local questName = questArgs[1]
		local questTaskComplete = questArgs[2]
		--DebugMessage("----------------------------------------------")
		--DebugMessage(questName,questTaskComplete)
		if (questArgs ~= nil and not HasFinishedQuestTask(user, questName, questTaskComplete)) then
			user:SystemMessage("The portal's magic forbids you from using it yet.", "info")
			return
		end
	end

	local teleType = this:GetObjVar("Type")
	if (teleType ~= nil) then
		local matchingTeleporters = FindObjects(SearchObjVar("Type", teleType), this)
		if (#matchingTeleporters > 0) then
			targetObj = matchingTeleporters[math.random(1, #matchingTeleporters)]
			DoTeleport(user, targetObj:GetLoc())
			return
		end
	end

	local destLoc = this:GetObjVar("Destination")
	if (type(destLoc) == "string") then
		destLoc = Loc.ConvertFrom(destLoc)
	end

	if (destLoc ~= nil) then
		DoTeleport(user, destLoc, this:GetObjVar("RegionAddress"))
		return
	end

	user:SystemMessage(this:GetObjVar("InvalidUseMessage") or "The portal fails to respond to your presence.")
end

function ChooseClass(user)
	local backpackObj = this:GetEquippedObject("Backpack")
	local backpackObjects = GetResourcesInContainer(backpackObj, "ColorwarItem", true)
	for index, resourceObj in pairs(backpackObjects) do
		user:SendMessage("You still have some stuff in your pack.")
		return false
	end

	if(this:GetEquippedObject("LeftHand")) then 
		user:SendMessage("You still have something in your left hand.")
		return false
	end

	if(this:GetEquippedObject("RightHand")) then 
		user:SendMessage("You still have something in your right hand.")
		return false
	end

	local remainingPets = GetRemainingActivePetSlots(this)
	local maxPets = MaxActivePetSlots(this)
	
	if (maxPets ~= remainingPets) then
		user:SendMessage("Stable your pets.")
		return false
	end

	-- POP OPEN THE "CHOOSE YOUR CLASS" DYNAMIC WINDOW AND THEN...
	-- SPAWN THEIR KIT... 
	-- COLOR THEM... 
	-- TELEPORT THEM...

	ActivateTeleporter(user)
end

RegisterEventHandler(
	EventType.EnterView,
	"TeleportPlayer",
	function(user)
		if (this:GetSharedObjectProperty("Weight") >= 0) then
			DelView("TeleportPlayer")
			return
		end
		-- prevent repeated teleports
		if (user:HasTimer("TeleportDelay") or user:HasTimer("EnteringWorld")) then
			return
		end

		ChooseClass(user)
	end
)

RegisterEventHandler(
	EventType.Message,
	"UseObject",
	function(user, usedType)
		if (usedType == "Use" or usedType == "Activate") then
			-- SHOW "CHOOSE YOUR CLASS KIT" WINDOW
			ChooseClass(user)
		end
	end
)

RegisterEventHandler(
	EventType.ModuleAttached,
	"colorwar_teleporter",
	function(...)
		
		AddView("TeleportPlayer", SearchPlayerInRange(1.0, true))
		local portalName = this:GetObjVar("PortalName")
		if (portalName) then
			this:SetName(portalName)
			this:DelObjVar("PortalName")
		end
		AddUseCase(this, "Activate", true)
	end
)
