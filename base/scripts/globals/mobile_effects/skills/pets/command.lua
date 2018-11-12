--[[
	Animal control.
]]

MobileEffectLibrary.Command = 
{
	OnEnterState = function(self,root,target,args)
		self.RequestInitialTarget(self,root,target,args)
	end,

	RequestInitialTarget = function(self,root,target,args)
		-- handle a new target
		RegisterSingleEventHandler(EventType.ClientTargetLocResponse, "PetCommandInitialTarget",
			function (success,targetLoc,targetObj,user)
				if(success) then
					self.ProcessCommand(self,root,targetObj,{TargetLoc=targetLoc})
				else
					self.ParentObj:SystemMessage("Command cancelled.","info")
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
						self.EventRegistered = false
						UnregisterEventHandler("", EventType.ClientUserCommand, "cancelspellcast")
						if ( success ) then
							-- update the arguments with the new loc
							args.TargetLoc = targetLoc
							-- run command again
							self.ProcessCommand(self,root,targetObj,args)
						end
					end)
				RegisterEventHandler(EventType.ClientUserCommand, "cancelspellcast",
					function()
						-- target cancelled
						EndMobileEffect(root)
					end)
				self.ParentObj:SystemMessage("Commanding "..target:GetName()..".", "info")
				-- ask for a new target
				self.ParentObj:RequestClientTargetLoc(self.ParentObj, "PetCommandTarget")
				self.EventRegistered = true
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
		if ( self.EventRegistered ) then
			UnregisterEventHandler("", EventType.ClientTargetLocResponse, "PetCommandTarget")
			UnregisterEventHandler("", EventType.ClientUserCommand, "cancelspellcast")
		end
	end,

	Pet = nil, -- hold a reference to a pet
	EventRegistered = false -- keep track of the necessity to unregister this event handler.
}