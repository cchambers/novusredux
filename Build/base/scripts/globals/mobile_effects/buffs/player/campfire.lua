
MobileEffectLibrary.Campfire = 
{

	OnEnterState = function(self,root,target,args)
		if ( not self.ParentObj:IsPlayer() and not IsTamedPet(self.ParentObj) ) then
			EndMobileEffect(root)
			return false
		end

		if ( ServerSettings.Campfire.Disturb.Players ) then
			-- make them disturb campfire if they enter war mode
			RegisterEventHandler(EventType.Message, "CombatStatusUpdate", function(inCombat)
				if ( inCombat ) then
					for id,campfire in pairs(self._Campfires) do
						if ( self.ValidateEffect(self,campfire) ) then
							campfire:SendMessage("DisturbCampfire", self.ParentObj)
						end
					end
				end
			end)
		end

		self.OnStack(self,root,target,args)
		AddBuffIcon(self.ParentObj, "CampfireEffect", "Campfire", "Ignite", "You are warmed by the campfire.\n(cannot gain skills or stats)", false)
	end,

	OnExitState = function(self,root)
		if(ServerSettings.Campfire.Bonus.Health > 0) then
			SetMobileMod(self.ParentObj, "HealthRegenPlus", "Campfire", nil)
		end
		if(ServerSettings.Campfire.Bonus.Mana > 0) then
			SetMobileMod(self.ParentObj, "ManaRegenPlus", "Campfire", nil)
		end
		if(ServerSettings.Campfire.Bonus.Stamina > 0) then
			SetMobileMod(self.ParentObj, "StaminaRegenPlus", "Campfire", nil)
		end
		RemoveBuffIcon(self.ParentObj, "CampfireEffect")
		if ( ServerSettings.Campfire.Disturb.Players ) then
			UnregisterEventHandler("", EventType.Message, "CombatStatusUpdate")
		end
	end,

	OnStack = function(self,root,target,args)
		if ( target == nil or target.Id == nil ) then return end
		-- target refers to the campfire obj that is causing the effect
		self._Campfires[target.Id] = target
		self.UpdateCampfireBonus(self,root)
	end,

	OnEndEffect = function(self,root,endingObj)
		if ( endingObj == nil ) then
			-- this can happen in the event of dying and it being cleared that way.
			EndMobileEffect(root)
			return
		end
		local count = 0
		for id,c in pairs(self._Campfires) do
			count = count + 1
			if ( count > 1 ) then break end
		end

		if ( count > 1 ) then
			-- remove the campfire from the list
			self._Campfires[endingObj.Id] = nil
			-- update bonus.
			self.UpdateCampfireBonus(self,root)
		else
			-- only one campfire, drop the effect.
			EndMobileEffect(root)
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.PulseFrequency
	end,

	AiPulse = function(self,root)
		for id,campfire in pairs(self._Campfires) do
			if not( self.ValidateEffect(self,campfire) ) then
				self.OnEndEffect(self,root,campfire)
			end
		end
	end,

	UpdateCampfireBonus = function(self,root)
		local bonus = self.GetBestBonus(self,root)
		-- bonus hasn't changed, no reason to continue.
		if ( bonus == self._CampfireBaseBonus ) then return end
		self._CampfireBaseBonus = bonus
		if(ServerSettings.Campfire.Bonus.Health > 0) then
			SetMobileMod(self.ParentObj, "HealthRegenPlus", "Campfire", self._CampfireBaseBonus + ServerSettings.Campfire.Bonus.Health)
		end
		if(ServerSettings.Campfire.Bonus.Mana > 0) then
			SetMobileMod(self.ParentObj, "ManaRegenPlus", "Campfire", self._CampfireBaseBonus + ServerSettings.Campfire.Bonus.Mana)
		end
		if(ServerSettings.Campfire.Bonus.Stamina > 0) then
			SetMobileMod(self.ParentObj, "StaminaRegenPlus", "Campfire", self._CampfireBaseBonus + ServerSettings.Campfire.Bonus.Stamina)
		end
	end,

	GetBestBonus = function(self,root)
		local best = -99999
		for id,campfire in pairs(self._Campfires) do
			local bonus = campfire:GetObjVar("BaseBonus") or 0
			-- priority to best campfires always.
			if ( bonus > best ) then best = bonus end
		end
		return best
	end,

	ValidateEffect = function(self, target)
		return ( 
			target ~= nil 
			and target:IsValid() 
			and target:GetSharedObjectProperty("IsLit") 
			and target:DistanceFrom(self.ParentObj) <= ServerSettings.Campfire.MaxRange
		)
	end,

	_CampfireBaseBonus = -1,
	_Campfires = {},

	PulseFrequency = TimeSpan.FromSeconds(5), --used as a way to verify the effect is still valid
}