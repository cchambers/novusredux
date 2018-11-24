MINS_TO_RECHARGE = 30
TimePercentage = {
	{Label="completely exhausted.",Amount=100},
	{Label="exhausted.",Amount=95},
	{Label="nearly decharged.",Amount=80},
	{Label="very slightly charged.",Amount=70},
	{Label="slightly charged.",Amount=60},
	{Label="just under halfway charged.",Amount=50},
	{Label="halfway charged.",Amount=40},
	{Label="just over halfway charged.",Amount=30},
	{Label="mostly charged.",Amount=20},
	{Label="almost charged.",Amount=10},
	{Label="just about charged.",Amount=0},
	{Label="overcharged.",Amount=-10},
}
AddUseCase(this,"Activate",true,"HasObject")

RegisterEventHandler(EventType.Message,"UseObject",function (user,useType)
	if useType ~= "Activate" then return end

	if (this:TopmostContainer() ~= user) then 
		user:SystemMessage("[$1733]","info")
		return
	end

	if(this:HasTimer("RechargingPortal")) then
    	local delay = this:GetTimerDelay("RechargingPortal")
    	local percentage = 100 * (delay.Minutes / MINS_TO_RECHARGE)
    	local label = "broken!"
    	for i,j in pairs (TimePercentage) do 
    		if (j.Amount >= percentage) then
    			label = j.Label
    		end
    	end
		user:SystemMessage("[$1734]"..label)
		return
	end

	-- make it so you don't instantly travel through the portal
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"TeleportDelay")

	local bindLoc = GetPlayerSpawnPosition(user)
	local curRegionAddress = ServerSettings.RegionAddress
	local bindRegionAddress = curRegionAddress

	local spawnPosEntry = this:GetObjVar("SpawnPosition")
    if(spawnPosEntry ~= nil) then
       	bindLoc = spawnPosEntry.Loc
       	bindRegionAddress = spawnPosEntry.Region
    end

    if(bindRegionAddress == curRegionAddress) then
		-- validate teleport
		if not(ValidateTeleport(this,bindLoc)) then
			this:DelModule("sp_bind_teleport_effect")
			return
		end
		OpenTwoWayPortal(user:GetLoc(),bindLoc,60)				
	else
		OpenRemoteTwoWayPortal(user:GetLoc(),bindLoc,bindRegionAddress,60)
	end

	-- we can't detach right away because the portal helper needs to handle the created object events	
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"TeleportRemove")
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(MINS_TO_RECHARGE),"RechargingPortal")
end)