MobileEffectLibrary.MountSummon = 
{

	OnEnterState = function(self,root,target,args)

		-- target is the statue
		self.Statue = target

		if ( not self.Statue or not self.Statue:IsValid() ) then
			EndMobileEffect(root)
			return false
		end

		-- get pet
		self.Pet = self.Statue:GetObjVar("StatuePet")

		if not( self.Can(self,root) ) then
			EndMobileEffect(root)
			return false
		end

		self._Applied = true

        SetMobileMod(self.ParentObj, "Busy", "MountSummon", true)
		RegisterEventHandler(EventType.Message, "BreakInvisEffect", function(what)
			EndMobileEffect(root)
		end)
		RegisterEventHandler(EventType.StartMoving, "", function() EndMobileEffect(root) end)
		self.ParentObj:SendMessage("EndCombatMessage")
		self.ParentObj:StopMoving()
		
		self.ParentObj:PlayAnimation("cast")
		self.StartProgressBar(self,root)
		
		return true
	end,

	Can = function(self,root)
		if ( self.Pet and not self.Pet:IsValid() ) then
			self.ParentObj:SystemMessage("Statue appears to be broken, sorry!", "info")
			return false
		end
		if not( IsInBackpack(self.Statue, self.ParentObj) ) then
			self.ParentObj:SystemMessage("Statue must be in your backpack to summon.", "info")
			return false
		end
		-- make sure they can control the pet
		if ( self.Pet and not CanControlCreature(self.ParentObj, self.Pet) ) then
			self.ParentObj:SystemMessage("You have no chance of controlling this pet.", "info")
			return false
		end
		-- make sure the player has room to take this pet
		if ( self.Pet and GetPetSlots(self.Pet) > GetRemainingActivePetSlots(self.ParentObj) ) then
			self.ParentObj:SystemMessage("You cannot control anymore pets.", "info")
			return false
		end
		return true
	end,

	CreateFromTemplate = function(self,root)
		local template = self.Statue:GetObjVar("StatuePetTemplate")
		DebugMessage("WHAT IN THE FUCK >< >< ><")
		if ( template ) then
			Create.AtLoc(template, self.ParentObj:GetLoc(), function(mobile)
				if ( mobile ) then
					SetCreatureAsPet(mobile, self.ParentObj)
					self.Pet = mobile
                    self.Statue:SetObjVar("StatuePet", self.Pet)
                    self.Pet:SetObjVar("PetStatue", self.Statue)
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
		if ( self._Applied ) then
			SetMobileMod(self.ParentObj, "Busy", "MountSummon", nil)
			UnregisterEventHandler("", EventType.StartMoving, "")
			UnregisterEventHandler("", EventType.Message, "BreakInvisEffect")
			if ( self.ParentObj:HasTimer("MountSummonClose") ) then
				self.ParentObj:FireTimer("MountSummonClose") -- close progress bar
			end
			self.ParentObj:PlayAnimation("idle")
		end
		if ( self.Done and self.Pet and self.Can(self,root) ) then
			self.Pet:SetWorldPosition(self.ParentObj:GetLoc())
			if ( self.Pet:GetObjVar("controller") == self.ParentObj ) then
				self.Pet:SetObjectOwner(self.ParentObj)
			else
				-- reassign owner
				self.Pet:SendMessage("SetPetOwner", self.ParentObj)
			end
			-- move the statue into pet
			self.Statue:MoveToContainer(self.Pet,self.Statue:GetLoc())

			-- auto mount
			MountMobile(self.ParentObj, self.Pet)
		end
	end,

	OnExitState = function(self,root)
		if ( self.Pet ) then
			self.OnDone(self,root)
		else
			self.CreateFromTemplate(self,root)
		end
	end,

	AiPulse = function(self,root)
		self.Done = true
		EndMobileEffect(root)
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

    StartProgressBar = function(self,root)
        ProgressBar.Show(
        {
            TargetUser = self.ParentObj,
            Label = "Summon Mount",
            Duration = self.Duration,
            PresetLocation = "AboveHotbar",
            DialogId = "MountSummon",
            CanCancel = true,
			CancelFunc = function()
				EndMobileEffect(self,root)
            end,
        })
    end,

	Duration = TimeSpan.FromSeconds(3),
}
