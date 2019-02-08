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

function ExitColorwars(user)
	local hue = user:GetObjVar("HueActual")
	if (hue ~= nil) then
		user:DelObjVar("HueActual")
		user:SetHue(hue)
	end
	local backpackObj = user:GetEquippedObject("Backpack")
	local items = FindItemsInContainerRecursive(user:GetEquippedObject("Backpack"),
		function (item)
			return item:Destroy()
		end)

	local RightHand = user:GetEquippedObject("RightHand")
	if (RightHand ~= nil) then RightHand:Destroy() end
	local LeftHand = user:GetEquippedObject("LeftHand")
	if (LeftHand ~= nil) then LeftHand:Destroy() end
	local Chest = user:GetEquippedObject("Chest")
	if (Chest ~= nil) then Chest:Destroy() end
	local Legs = user:GetEquippedObject("Legs")
	if (Legs ~= nil) then Legs:Destroy() end
	local Head = user:GetEquippedObject("Head")
	if (Head ~= nil) then Head:Destroy() end

	user:DelObjVar("ColorWarPlayer")
	user:DelObjVar("ColorWarPoints")

	local StatsActual = user:GetObjVar("StatsActual")
	
	user:DelObjVar("IsRed")
	for stat, value in pairs(StatsActual) do
		if (value == 0 and stat == "Murders") then
			user:DelObjVar("Murders")
		else
			user:SetObjVar(stat, value)
		end
	end

	ActivateTeleporter(user)
end


-- RegisterEventHandler(
-- 	EventType.EnterView,
-- 	"TeleportPlayer",
-- 	function(user)
-- 		if (this:GetSharedObjectProperty("Weight") >= 0) then
-- 			DelView("TeleportPlayer")
-- 			return
-- 		end
-- 		-- prevent repeated teleports
-- 		if (user:HasTimer("TeleportDelay") or user:HasTimer("EnteringWorld")) then
-- 			return
-- 		end

-- 		ChooseClass(user)
-- 	end
-- )

RegisterEventHandler(
	EventType.Message,
	"UseObject",
	function(user, usedType)
		if (usedType == "Use" or usedType == "Activate") then
			if(user:HasLineOfSightToObj(this)) then
				ExitColorwars(user)
			end
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
