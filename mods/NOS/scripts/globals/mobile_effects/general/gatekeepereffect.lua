-- This mobile effect handles teleporting someone who has purchased travel through a gatekeeper
MobileEffectLibrary.GatekeeperEffect = {

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration			

		if not(args.Destination) or not(target) then
			EndMobileEffect(root)
		end

		self.TeleporterRange = target:GetObjVar("TeleportRange") or self.TeleporterRange

		local displayName = args.DisplayName or "Unknown"
		AddBuffIcon(self.ParentObj, "GatekeeperBuff", "Attuned", "Cold Mastery", "You are attuned for travel to the "..displayName..".", false, self.Duration.TotalSeconds)
		AddView("GatekeeperTeleporterView",SearchSingleObject(target,SearchObjectInRange(self.TeleporterRange)))
		RegisterEventHandler(EventType.EnterView,"GatekeeperTeleporterView",
			function ( ... )
				CallFunctionDelayed(TimeSpan.FromSeconds(0.8),function ( ... )
					TeleportUser(target,self.ParentObj,args.Destination,nil,args.DestFacing)
					EndMobileEffect(root)
				end)

				local gatekeeperTower = FindObject(SearchTemplate("mage_tower",10))
				-- DAB TODO: Handle multiple people going through
				if(gatekeeperTower) then
					gatekeeperTower:SendMessage("Activate")
				end				
			end)
	end,

	OnExitState = function (self)
		RemoveBuffIcon(self.ParentObj,"GatekeeperBuff")
	end,

	TeleporterRange = 1,
	Duration = TimeSpan.FromMinutes(5),
}