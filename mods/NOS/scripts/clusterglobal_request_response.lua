
--- Sometimes you need to ask a remote region for some information

RegisterEventHandler(EventType.Message, "ValidatePortalLoc",
	function (user, dest)
		local invalidMessage, newDestLoc = ValidatePortalSpawnLoc(user, dest)
		local regionalName = GetRegionalName(dest)
		local protection = GetGuardProtectionForLoc(newDestLoc)

		user:SendMessageGlobal("PortalLocValidated", invalidMessage, newDestLoc, protection, regionalName)
	end)

RegisterEventHandler(EventType.Message, "MapMarkerRequest",
	function(user)
		local worldName = ServerSettings.WorldName
		local subregionName = ServerSettings.SubregionName
		local mapMarkers = GetControllerMapMarkers()

		if (mapMarkers ~= nil and subregionName ~= nil and worldName ~= nil) then
			user:SendMessageGlobal("ClusterControllerMapMarkerResponse", worldName, subregionName, mapMarkers)
		end
		
	end)

RegisterEventHandler(EventType.Message, "ValidateBindLocationRequest", function(playerObj, loc)
	if ( playerObj and loc ) then
		playerObj:SendMessageGlobal("ValidateBindLocationResponse", Plot.ValidateBindLocation(playerObj, loc))
	end
end)

RegisterEventHandler(EventType.Message, "PlotInfoRequest", function(playerObj, controller, id)
	if not( id ) then id = "" end
	playerObj:SendMessageGlobal("PlotInfoResponse"..id, Plot.GetInfo(controller))
end)
RegisterEventHandler(EventType.Message, "TaxPaymentRequest", function(playerObj, controller, amount)
	playerObj:SendMessageGlobal("TaxPaymentResponse", Plot.TaxPayment(controller, playerObj, amount))
end)

RegisterEventHandler(EventType.Message, "IsValidRequest", function(responseObj, obj)
    if ( responseObj and obj ) then
        responseObj:SendMessageGlobal("IsValidResponse", obj:IsValid())
    end
end)

RegisterEventHandler(EventType.Message, "ShrineTeleportLocationRequest", function(responseObj, loc, red)
	if ( responseObj and loc ) then
		responseObj:SendMessageGlobal("ShrineTeleportLocationResponse", GetClosestShrineTeleportLocation(loc, red))
	end
end)