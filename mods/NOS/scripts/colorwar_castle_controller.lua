AddView("WinCondition", SearchMobileInRange(6.0))

mTeams = {
    h831 = "Red",
    h835 = "Blue"
}

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
	user:DelObjVar("ColorWarKit")

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
     -- GAME OVER, FIND EVERYONE ON THE MAP AND PORT THEM HOME GIVING CREDITS TO WINNERS
    local players = FindObjects(SearchMulti(
        {
            SearchPlayerInRange(300,true), --in 20 units
        }))

        for i,j in pairs(players) do
            local hue = j:GetHue()
            if (hue == winners) then
                local credits = j:GetObjVar("Credits") or 0
                credits = credits + 2
                j:SetObjVar("Credits", credits)
            end
            if (IsDead(j)) then j:SendMessage("Resurrect", true) end
            j:SystemMessage("Color Wars is over: "..mTeams[tostring("h"..winners)].." wins! Leaving area in 3 seconds...")
            CallFunctionDelayed(TimeSpan.FromSeconds(3), function () 
                ExitColorwars(j)
            end)
        end
end

RegisterEventHandler(EventType.EnterView, "WinCondition", 
    function(obj)
        if (obj:HasObjVar("ColorWarWin")) then
            EndColorWars(obj:GetHue())
        end
    end)

RegisterEventHandler(EventType.Timer,"CheckWinCondition",function ( ... )
    local objects = GetViewObjects("WinCondition")
    for i, obj in pairs(objects) do
        if (obj:HasObjVar("ColorWarWin")) then
            EndColorWars(obj:GetHue())
        end
    end
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"CheckWinCondition")
end)