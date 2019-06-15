MobileEffectLibrary.EnergyVortex = 
{
    QTarget = true,

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration
		self.Range = args.Range or self.Range
		-- handle a new target
		RegisterEventHandler(EventType.ClientTargetLocResponse, "EnergyVortexTarget",
			function (success,targetLoc,targetObj,user)
				if ( success ) then
					if ( user:GetLoc():Distance(targetLoc) > self.Range ) then
						self.ParentObj:SystemMessage("Too far away.", "info")
						-- ask for target again
						self.PresentTarget(self.ParentObj)
						return
					end

					if not ( targetLoc ) then
						self.ParentObj:SystemMessage("Invalid target.", "info")
						-- ask for target again
						self.PresentTarget(self.ParentObj)
						return
					end

					-- handle the vortex being created
					RegisterSingleEventHandler(EventType.CreatedObject, "CreatedEnergyVortex",
						function (success,objRef)
							if ( success ) then
								objRef:SetObjVar("Summon", true)
								Decay(objRef, self.Duration.TotalSeconds)
							end
							-- exit the mobile effect.
							EndMobileEffect(root)
						end)
					-- create the vortex
					CreateObj("energy_vortex", targetLoc, "CreatedEnergyVortex")
					PlayEffectAtLoc("DarkEnergySpawnEffect",targetLoc)
				else
					EndMobileEffect(root)
				end
			end)
		-- ask for a target
		self.PresentTarget(self.ParentObj)
	end,

	PresentTarget = function(user)
		user:RequestClientTargetLoc(user, "EnergyVortexTarget")
	end,

	OnExitState = function(self,root)
		UnregisterEventHandler("", EventType.ClientTargetLocResponse, "EnergyVortexTarget")
	end,

	Duration = TimeSpan.FromSeconds(30),
	Range = 15
}