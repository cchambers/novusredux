--[[
	Animal control.
]]

MobileEffectLibrary.Command = 
{
	OnEnterState = function(self,root,target,args)
		RegisterEventHandler(EventType.Message, "BreakInvisEffect", function(what)
			if ( what == "Action" ) then
				EndMobileEffect(root)
			end
		end)
		self.RequestInitialTarget(self,root,target,args)
	end,

	RequestInitialTarget = function(self,root,target,args)
		-- handle a new target
		RegisterSingleEventHandler(EventType.ClientTargetLocResponse, "PetCommandInitialTarget",
			function (success,targetLoc,targetObj,user)
				if ( success ) then
					self.ProcessCommand(self,root,targetObj,{TargetLoc=targetLoc})
				else
					EndMobileEffect(root)
				end
			end)
		self.ParentObj:RequestClientTargetLoc(self.ParentObj, "PetCommandInitialTarget")
	end,

	ProcessCommand = function(self,root,target,args)
		self.Pet = args.Pet
		if ( target ~= nil ) then -- targted a dynamic object
			if ( target == self.ParentObj ) then
				-- targeting ourself, do follow.
				self.SendPetCommand(self, "follow", self.ParentObj)
			elseif ( self.Pet == nil and target:GetObjectOwner() == self.ParentObj ) then -- targeted a pet of ours, no pet is set
				-- set the target to the Pet argument
				args.Pet = target
				-- handle a new target
				RegisterSingleEventHandler(EventType.ClientTargetLocResponse, "PetCommandTarget",
					function (success,targetLoc,targetObj,user)
						if ( success ) then
							-- update the arguments with the new loc (if any)
							args.TargetLoc = targetLoc
							-- run command again
							self.ProcessCommand(self,root,targetObj,args)
						else
							-- target cancelled
							EndMobileEffect(root)
						end
					end)
				self.ParentObj:SystemMessage("Commanding "..StripColorFromString(target:GetName())..".", "info")
				-- ask for a new target
				self.ParentObj:RequestClientTargetLoc(self.ParentObj, "PetCommandTarget")
				return -- prevent ending mobile effect this go around.
			elseif ( self.Pet == target ) then
				-- targeted a pet on its self, make them stay.
				SendPetCommandTo(self.Pet, "stay")
			else
				if ( ValidCombatTarget(self.ParentObj, target) ) then
					-- targeted something that's attackable, send pets in to attack.
					self.SendPetCommand(self, "attack", target)
				else
					-- targeted a non-attackable target, follow target
					self.SendPetCommand(self, "follow", target)
				end
			end
		elseif ( args.TargetLoc ~= nil ) then -- targeted a location
			self.SendPetCommand(self, "go", args.TargetLoc)
		end
		EndMobileEffect(root)
	end,

	SendPetCommand = function(self, cmd, target)
		if ( self.Pet ) then
			SendPetCommandTo(self.Pet, cmd, target)
		else
			SendPetCommandToAll(GetActivePets(self.ParentObj), cmd, target)
		end
	end,

	OnExitState = function(self,root)
		UnregisterEventHandler("", EventType.Message, "BreakInvisEffect")
	end,

	Pet = nil, -- hold a reference to a pet
}