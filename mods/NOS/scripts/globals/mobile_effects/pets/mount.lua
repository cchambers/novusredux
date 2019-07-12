MobileEffectLibrary.Mount = 
{

	OnEnterState = function(self,root,target,args)

		if ( not target or not target:IsValid() ) then
			EndMobileEffect(root)
			return false
		end

		-- dismount if mounted
		local mountObj = GetMount(self.ParentObj)
		if ( mountObj ) then DismountMobile(self.ParentObj, mountObj) end

		if ( target:IsMobile() ) then
			self.MountObj = target
		elseif ( target:GetObjVar("ResourceType") == "MountStatue" ) then
			self.Statue = target
			self.MountObj = target:GetObjVar("StatueMount")
		else
			EndMobileEffect(root)
			return false
		end

		-- prevent mounting in certain regions (like dungeons)
		if ( self.ParentObj:IsInRegion("NoMount") ) then
			self.ParentObj:SystemMessage("Cannot mount here.", "info")
			EndMobileEffect(root)
			return false
		end

		if not( self.Can(self,root) ) then
			EndMobileEffect(root)
			return false
		end

		self._Applied = true

        SetMobileMod(self.ParentObj, "Busy", "Mounting", true)
		RegisterEventHandler(EventType.Message, "BreakInvisEffect", function(what)
			EndMobileEffect(root)
		end)
		RegisterEventHandler(EventType.StartMoving, "", function() EndMobileEffect(root) end)
		self.ParentObj:SendMessage("EndCombatMessage")
		self.ParentObj:StopMoving()
		
		self.ParentObj:PlayAnimation("cast")
		if not( self.Statue ) then
			LookAt(self.ParentObj, self.MountObj)
		end
		self.StartProgressBar(self,root)
		
		return true
	end,

	Can = function(self,root)
		if ( HasMobileEffect(self.ParentObj, "NoMount") ) then
			self.ParentObj:SystemMessage("Cannot mount yet.", "info")
			return false
		end
		if ( self.MountObj ) then
			if ( not self.MountObj:IsValid() ) then
				if ( self.Statue ) then
					self.ParentObj:SystemMessage("Statue appears to be broken, sorry!", "info")
				else
					self.ParentObj:SystemMessage("Cannot mount that.", "info")
				end
				return false
			end
			if ( self.MountObj:HasObjVar("Dismissing") ) then
				self.ParentObj:SystemMessage("Cannot mount that right now.", "info")
				return false
			end
		end
		if ( self.Statue ) then
			if not( IsInBackpack(self.Statue, self.ParentObj) ) then
				self.ParentObj:SystemMessage("Statue must be in backpack to summon.", "info")
				return false
			end
		elseif ( self.MountObj and not ValidateRangeWithError(3, self.ParentObj, self.MountObj, "Too far away.") ) then
			return false
		end
		return true
	end,

	CreateFromTemplate = function(self,root)
		local template = self.Statue:GetObjVar("StatueMountTemplate")
		DebugMessage("WHAT IN THE FUCKFUCK >< >< ><")
		if ( template and self.Statue ) then
			local templateData = GetTemplateData(template)
			templateData.LuaModules = {}
			Create.Custom.AtLoc(template, templateData, self.ParentObj:GetLoc(), function(mobile)
				if ( mobile ) then
					self.Statue:DelObjVar("StatueMountTemplate")
                    self.Statue:SetObjVar("StatueMount", mobile)
					self.MountObj = mobile
					self.MountObj:SetObjVar("MountStatue", self.Statue)
					self.MountObj:MoveToContainer(self.Statue,Loc())
					self.OnDone(self,root)
				else
					self.ParentObj:SystemMessage("This statue appears to be broken, failed to create the creatue.", "info")
					EndMobileEffect(root)
				end
			end, true)
		else
			self.ParentObj:SystemMessage("This statue appears to be broken, cannot create the creatue.", "info")
			EndMobileEffect(root)
		end
	end,

	OnDone = function(self,root)
		if ( self.MountObj and self.Can(self,root) ) then
			if ( self.Statue ) then
				self.MountObj:SetWorldPosition(self.ParentObj:GetLoc())
				-- move the statue into mount
				self.Statue:MoveToContainer(self.MountObj,self.Statue:GetLoc())
			end
			-- mount
			MountMobile(self.ParentObj, self.MountObj)
			if ( GetMount(self.ParentObj) ~= self.MountObj ) then
				self.ParentObj:SystemMessage("Failed to mount.", "info")
				DismountMobile(self.ParentObj, self.MountObj)
			end
		end
		EndMobileEffect(root)
	end,

	OnExitState = function(self,root)
		if ( self._Applied ) then
			SetMobileMod(self.ParentObj, "Busy", "Mounting", nil)
			UnregisterEventHandler("", EventType.StartMoving, "")
			UnregisterEventHandler("", EventType.Message, "BreakInvisEffect")
			if ( self.ParentObj:HasTimer("MountingClose") ) then
				self.ParentObj:FireTimer("MountingClose") -- close progress bar
			end
			self.ParentObj:PlayAnimation("idle")
		end
	end,

	AiPulse = function(self,root)
		if ( self.MountObj ) then
			self.OnDone(self,root)
		elseif ( self.Statue ) then
			self.CreateFromTemplate(self,root)
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

    StartProgressBar = function(self,root)
        ProgressBar.Show(
        {
            TargetUser = self.ParentObj,
            Label = self.Statue ~= nil and "Summon Mount" or "Mount",
            Duration = self.Duration,
            PresetLocation = "AboveHotbar",
            DialogId = "Mounting",
        })
    end,

	Duration = TimeSpan.FromSeconds(3),
}
