AddView("WinCondition", SearchMobileInRange(6.0))

mTeams = {
	h831 = "[ff0000]Red[-]",
	h835 = "[0000ff]Blue[-]"
}

function ExitColorwars(user)
	local hue = user:GetObjVar("HueActual")
	if (hue ~= nil) then
		user:DelObjVar("HueActual")
		user:SetHue(hue)
	end
	local backpackObj = user:GetEquippedObject("Backpack")
	local items =
		FindItemsInContainerRecursive(
		user:GetEquippedObject("Backpack"),
		function(item)
			return item:Destroy()
		end
	)

	local RightHand = user:GetEquippedObject("RightHand")
	if (RightHand ~= nil) then
		RightHand:Destroy()
	end
	local LeftHand = user:GetEquippedObject("LeftHand")
	if (LeftHand ~= nil) then
		LeftHand:Destroy()
	end
	local Chest = user:GetEquippedObject("Chest")
	if (Chest ~= nil) then
		Chest:Destroy()
	end
	local Legs = user:GetEquippedObject("Legs")
	if (Legs ~= nil) then
		Legs:Destroy()
	end
	local Head = user:GetEquippedObject("Head")
	if (Head ~= nil) then
		Head:Destroy()
	end

	user:DelObjVar("ColorWarPlayer")
	user:DelObjVar("ColorWarPoints")
	user:DelObjVar("ColorWarKit")
	user:DelObjVar("ColorWarWin")
	
	if (user:HasObjVar("ColorWarCaptain")) then user:DelObjVar("ColorWarCaptain") end

	local StatsActual = user:GetObjVar("StatsActual")

	user:DelObjVar("IsRed")
	for stat, value in pairs(StatsActual) do
		if (value == 0 and stat == "Murders") then
			user:DelObjVar("Murders")
		else
			user:SetObjVar(stat, value)
		end
	end

	local newTime = ServerTimeSecs()
	local destLoc = this:GetObjVar("Destination")
	local region = this:GetObjVar("RegionAddress")
	if (type(destLoc) == "string") then
		destLoc = Loc.ConvertFrom(destLoc)
	end

	if (destLoc ~= nil) then
		TeleportUser(this, user, destLoc, region)
		return
	end
end

function EndColorWars(winners)
	local players = FindPlayersInRegion()
	local players =
		FindObjects(
		SearchMulti(
			{
				SearchPlayerInRange(300, true) --in 20 units
			}
		)
	)

	for i, j in pairs(players) do
		if (j:HasObjVar("ColorWarPlayer")) then
			local hue = j:GetHue()
			if (hue == winners) then
				local credits = j:GetObjVar("Credits") or 0
				credits = credits + 2
				j:SetObjVar("Credits", credits)
				if (j:HasObjVar("ColorWarCaptain")) then
					credits = credits + 1
				end
			end
			j:SystemMessage(
				"Color Wars is over: " .. mTeams[tostring("h" .. winners)] .. " wins! Leaving area in 5 seconds...",
				"info"
			)
			if (IsDead(j)) then
				CallFunctionDelayed(
					TimeSpan.FromSeconds(4),
					function()
						j:SendMessage("Resurrect", true)
					end
				)
			end
			CallFunctionDelayed(
				TimeSpan.FromSeconds(3),
				function()
					j:SendMessage("Resurrect", 100, this, true)
				end
			)
		end
	end
end

RegisterEventHandler(
	EventType.EnterView,
	"WinCondition",
	function(obj)
		local hue = obj:GetHue()
		if (obj:HasObjVar("ColorWarWin") and this:GetObjVar("TeamHue") == hue) then
			EndColorWars(obj:GetHue())
		end
	end
)

RegisterEventHandler(
	EventType.Timer,
	"CheckWinCondition",
	function(...)
		local objects = GetViewObjects("WinCondition")
		for i, obj in pairs(objects) do
			if (obj:HasObjVar("ColorWarWin")) then
				EndColorWars(obj:GetHue())
			end
		end
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(1), "CheckWinCondition")
	end
)
