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
		local spawnInfo = self.ParentObj:GetObjVar("SpawnPosition")
		if not(spawnInfo) then
			EndMobileEffect(root)
			return
		end
		
		if (spawnInfo.Region ~= ServerSettings.RegionAddress and IsClusterRegionOnline(spawnInfo.Region) == false) then
			self.ParentObj:SystemMessage("Cannot teleport right now.", "info")			
		else
			TeleportUser(self.ParentObj,self.ParentObj,spawnInfo.Loc,spawnInfo.Region)
			self.ParentObj:SetObjVar("HearthCooldown",DateTime.UtcNow + ServerSettings.Misc.HearthstoneCooldown)
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