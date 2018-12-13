MobileEffectLibrary.Tame = 
{

	OnEnterState = function(self,root,target,args)
		if ( target == nil ) then
			EndMobileEffect(root)
			return false
		end
		
		local mountObj = GetMount(self.ParentObj)
		if ( mountObj ~= nil ) then
			DismountMobile(self.ParentObj, mountObj)
		end

		self.Target = target
		self.Duration = TimeSpan.FromSeconds(math.random(6,12))

		self._Player = self.ParentObj:IsPlayer()

		local valid, error = ValidAnimalTamingTarget(self.Target, self.ParentObj)
		if not( valid ) then
			self.ParentObj:SystemMessage(error, "info")
			EndMobileEffect(root)
			return false
		end

		RegisterEventHandler(EventType.Message, "DamageInflictedWhileBeingTamed", function()
			if ( self._Player ) then
				self.ParentObj:SystemMessage("That creature is too angry to continue taming.", "info")
			end
			self._Cancelled = true
			EndMobileEffect(root)
		end)
		-- start the effect on the target to listen for damage
		self.Target:SendMessage("StartMobileEffect", "BeingTamed", self.ParentObj)

		RegisterEventHandler(EventType.LeaveView, "TamingCreatureView", function (leavingObj)
			if( leavingObj == self.Target ) then
				if ( self._Player ) then
					self.ParentObj:SystemMessage("You are too far from that creature to continue taming it.", "info")
				end
				self._Cancelled = true
				EndMobileEffect(root)
			end
		end)

		if ( self._Player ) then
			AddBuffIcon(self.ParentObj, "TameBuff", "Taming", "Track Beasts", "You are currently taming a creature", true)
		end

		AddView("TamingCreatureView", SearchMobileInRange(ServerSettings.Pets.Taming.Distance, false))

		--self.ParentObj:NpcSpeech("[00ccff]*starts to tame ".. StripColorFromString(self.Target:GetName()) .."*[-]")
		self.ParentObj:PlayAnimation("holdcrook")
		self._Applied = true
	end,

	OnExitState = function(self,root)
		if ( self._Player ) then
			RemoveBuffIcon(self.ParentObj, "TameBuff")
			self.ParentObj:PlayAnimation("idle")
		end
		if ( self._Applied ) then
			UnregisterEventHandler("", EventType.Message, "DamageInflictedWhileBeingTamed")
			UnregisterEventHandler("", EventType.LeaveView, "TamingCreatureView")
			DelView("TamingCreatureView")
			self.Target:SendMessage("EndBeingTamedEffect")
			if not( self._Cancelled ) then
				local crookObj = self.ParentObj:GetEquippedObject("RightHand")
				local isCrook = crookObj and GetWeaponType(crookObj) == "Crook" 

				if not(isCrook) then
					if ( self._Player ) then
						self.ParentObj:SystemMessage("You can not tame without a crook.", "info")
					end
				else
					if ( Success(ServerSettings.Durability.Chance.OnToolUse) ) then
                        AdjustDurability(crookObj, -1)
                    end
					if ( CheckAnimalTamingSuccess(self.Target, self.ParentObj) ) then
						SetCreatureAsPet(self.Target, self.ParentObj)
					else
						if ( self._Player ) then
							self.ParentObj:SystemMessage("Failed to tame the creature.", "info")
						end
					end
				end
			end
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Target = nil,
	Duration = nil,

	_Applied = false,
	_Cancelled = false,
	_Player = false
}