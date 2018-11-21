
RegisterEventHandler(EventType.Message,"Activate",function ( ... )
	local players = FindPlayersInGameRegion(this:GetObjVar("Region"))
	for i,j in pairs(players) do
		TaskDialogNotification(j,this:GetObjVar("Dialog"),this:GetObjVar("Name"))
	end
end)