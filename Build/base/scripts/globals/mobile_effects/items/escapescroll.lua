MobileEffectLibrary.EscapeScroll = 
{
	OnEnterState = function(self,root,target,args)
		local escapeLocation = FindObjectWithTag("EscapeLocation")
		if not( escapeLocation ) then
			self.ParentObj:SystemMessage("Unable to locate the escape location.","info")
			EndMobileEffect(root)
			return false
		end

		if ( self.ParentObj:IsMoving() ) then
			self.ParentObj:SystemMessage("Must be still to do that.", "info")
			EndMobileEffect(root)
			return false
		end

		self._Applied = true
        
		SetMobileMod(self.ParentObj, "Busy", "EscapeScroll", true)
        RegisterEventHandler(EventType.Message, "BreakInvisEffect", function(what)
            if ( what ~= "Pickup" ) then
                self.Interrupt(self,root)
            end
        end)
        RegisterEventHandler(EventType.StartMoving, "", function() self.Interrupt(self,root) end)
        self.ParentObj:StopMoving()
        if ( IsInCombat(self.ParentObj) ) then
            self.ParentObj:SendMessage("EndCombatMessage")
        end
			
		ProgressBar.Show {
			Label="Reciting",
			Duration=self.SummonTime,
			TargetUser=self.ParentObj,
			PresetLocation="AboveHotbar",
		}

		self.ParentObj:PlayEffectWithArgs("ConjurePrimeBlueEffect", self.SummonTime.TotalSeconds, "Bone=Ground")
		self.ParentObj:PlayAnimation("cast")		

		self.ScrollObj = target
	end,		

	GetPulseFrequency = function(self,root)
		return self.SummonTime
	end,

	AiPulse = function(self,root)
		local escapeLocation = FindObjectWithTag("EscapeLocation")
		if not(escapeLocation) then
			EndMobileEffect(root)
			return
		end

		TeleportUser(self.ParentObj,self.ParentObj,escapeLocation:GetLoc())
		RequestRemoveFromStack(self.ScrollObj,1)		
		EndMobileEffect(root)
	end,

	Interrupt = function(self,root)
		self._Interrupted = true
		EndMobileEffect(root)
	end,

	OnExitState = function(self,root)
		if ( self._Applied ) then
			if ( self._Interrupted ) then
				ProgressBar.Cancel("Reciting", self.ParentObj)
				self.ParentObj:SystemMessage("Escape scroll interruped.", "info")
			end
			SetMobileMod(self.ParentObj, "Busy", "EscapeScroll", nil)
			UnregisterEventHandler("", EventType.Message, "BreakInvisEffect")
			UnregisterEventHandler("", EventType.StartMoving, "")
			self.ParentObj:PlayAnimation("idle")
			self.ParentObj:StopEffect("ConjurePrimeBlueEffect")
		end
	end,

	SummonTime = TimeSpan.FromSeconds(4),
	ScrollObj = nil,
}