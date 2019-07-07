-- DAB TODO: Need event handlers for players entering / leaving a region
AddView("FoundersAreaProtection",SearchMulti({SearchUser(),SearchRegion("FoundersArea",true)}))
AddView("VIPAreaProtection",SearchMulti({SearchUser(),SearchRegion("VIPArea",true)}))

RegisterEventHandler(EventType.EnterView,"FoundersAreaProtection",function (user)
	if not IsFounder(user) then
        PlayEffectAtLoc("TeleportToEffect",user:GetLoc())
		user:SetWorldPosition(Loc(27.41497, -0.03605413, 15.69382))
		user:SystemMessage("You are not on the guest list. This place is only open to early explorers.","info")
        PlayEffectAtLoc("TeleportFromEffect",Loc(27.41497, -0.03605413, 15.69382))
	end 
end)

RegisterEventHandler(EventType.EnterView,"VIPAreaProtection",function (user)
	if not IsCollector(user) then
        PlayEffectAtLoc("TeleportToEffect",user:GetLoc())
		user:SetWorldPosition(Loc(-9.23,0,-12.1))
		user:SystemMessage("You are not pemitted to enter the VIP area.","info")
        PlayEffectAtLoc("TeleportFromEffect",Loc(-9.23,0,-12.1))
	end 
end)