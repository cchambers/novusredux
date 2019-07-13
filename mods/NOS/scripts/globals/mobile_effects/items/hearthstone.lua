MobileEffectLibrary.Hearthstone = 
{
	OnEnterState = function(self,root,target,args)
		local cooldownTime = self.ParentObj:GetObjVar("HearthCooldown")
		local now = DateTime.UtcNow
		if ( cooldownTime and now < cooldownTime ) then
			self.ParentObj:SystemMessage(string.format("Recharging, can use again in %s.", TimeSpanToWords(cooldownTime-now)), "info")
			EndMobileEffect(root)
			return false
		end

		if not( self.ParentObj:HasObjVar("SpawnPosition") ) then
			self.ParentObj:SystemMessage("Not yet bound to a location, please visit a hearth to do so.","info")
			EndMobileEffect(root)
			return false
		end

		if ( self.ParentObj:IsMoving() ) then
			self.ParentObj:SystemMessage("Must be still to do that.", "info")
			EndMobileEffect(root)
			return false
		end

		self.SpawnInfo = self.ParentObj:GetObjVar("SpawnPosition")
		if not( self.SpawnInfo ) then
			EndMobileEffect(root)
			return false
		end

		self._Blocked = false
		if not( self.ValidateLoc(self,root,true) ) then
			EndMobileEffect(root)
			return false
		end

		self.BeginCast(self,root)
	end,

	ValidateLoc = function(self,root,initial)
		if ( self.SpawnInfo.Region ~= ServerSettings.RegionAddress and IsClusterRegionOnline(self.SpawnInfo.Region) == false) then
			self.ParentObj:SystemMessage("Cannot teleport right now.", "info")
			return false
		end

		if ( initial ) then
			if ( self.SpawnInfo.Region == ServerSettings.RegionAddress ) then
				local success = Plot.ValidateBindLocation(self.ParentObj, self.SpawnInfo.Loc)
				if ( success ~= true ) then
					self.ParentObj:SystemMessage(success, "info")
					return false
				end
			else
				RegisterSingleEventHandler(EventType.Message, "ValidateBindLocationResponse", function(success)
					if ( success ~= true ) then
						self.ParentObj:SystemMessage(success, "info")
						self._Blocked = true
						self._Interrupted = true
						CallFunctionDelayed(TimeSpan.FromMilliseconds(1), function()
							EndMobileEffect(root)
						end)
					end
				end)
				MessageRemoteClusterController(self.SpawnInfo.Region, "ValidateBindLocationRequest", self.ParentObj, self.SpawnInfo.Loc)
			end
		end

		return true
	end,

	BeginCast = function(self,root)
		if ( self._Blocked ) then return end
		self._Applied = true
        
		SetMobileMod(self.ParentObj, "Busy", "Hearthstone", true)
        RegisterEventHandler(EventType.Message, "BreakInvisEffect", function(what)
			if ( what ~= "Pickup" ) then
				self.Interrupt(self,root)
            end
        end)
        RegisterEventHandler(EventType.StartMoving, "", function() self.Interrupt(self,root) end)
        RegisterEventHandler(EventType.Message, "Overweight", function() self.Interrupt(self,root) end)
        self.ParentObj:StopMoving()
        if ( IsInCombat(self.ParentObj) ) then
            self.ParentObj:SendMessage("EndCombatMessage")
        end
			
        ProgressBar.Show{
            Label="Activating",
            Duration=self.SummonTime,
            TargetUser=self.ParentObj,
            PresetLocation="AboveHotbar",
        }

		self.ParentObj:PlayEffectWithArgs("ConjurePrimeBlueEffect", self.SummonTime.TotalSeconds, "Bone=Ground")
		self.ParentObj:PlayAnimation("cast")
	end,

	GetPulseFrequency = function(self,root)
		return self.SummonTime
	end,

	AiPulse = function(self,root)

		if ( self.ValidateLoc(self,root) ) then
			TeleportUser(self.ParentObj,self.ParentObj,self.SpawnInfo.Loc,self.SpawnInfo.Region)
			if not( IsGod(self.ParentObj) ) then
				self.ParentObj:SetObjVar("HearthCooldown",DateTime.UtcNow + ServerSettings.Misc.HearthstoneCooldown)
			end
		end

		EndMobileEffect(root)
	end,

	Interrupt = function(self,root)
		self._Interrupted = true
		EndMobileEffect(root)
	end,

	OnExitState = function(self,root)
		if ( self._Applied ) then
			if ( self._Interrupted ) then
				ProgressBar.Cancel("Activating", self.ParentObj)
				self.ParentObj:SystemMessage("Hearthstone interruped.", "info")
			end
			SetMobileMod(self.ParentObj, "Busy", "Hearthstone", nil)
			UnregisterEventHandler("", EventType.Message, "BreakInvisEffect")
			UnregisterEventHandler("", EventType.StartMoving, "")
			UnregisterEventHandler("", EventType.Message, "Overweight")
			self.ParentObj:PlayAnimation("idle")
			self.ParentObj:StopEffect("ConjurePrimeBlueEffect")
		end
	end,

	SummonTime = TimeSpan.FromSeconds(4),
}

function BindLocationIfNot(playerObj)
	if not( playerObj:HasObjVar("SpawnPosition") ) then
		local hearth = FindObject(SearchModule("hearth"))
		if ( hearth and hearth:HasObjVar("BindLocation") ) then
			playerObj:SendMessage("BindToLocation", hearth:GetObjVar("BindLocation"))
		end
	end
end