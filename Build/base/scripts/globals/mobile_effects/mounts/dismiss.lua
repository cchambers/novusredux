MobileEffectLibrary.MountDismiss = 
{

    OnEnterState = function(self,root,target,args)

        self.Backpack = self.ParentObj:GetEquippedObject("Backpack")
        if not( self.Backpack ) then
            EndMobileEffect(root)
            return false
        end
        
        self.Pet = target

        if ( not self.Pet or not self.Pet:IsValid() or not self.Pet:IsMobile() ) then
            EndMobileEffect(root)
            return false
        end

        if not( self.Can(self,root) ) then
            EndMobileEffect(root)
            return false
        end

        self.Pet:SetObjVar("Dismissing", true)

        self.Pet:PlayEffect("CloakEffect")
        self.Pet:PlayObjectSound("Pain")

        -- get the pet's statue (if any)
        self.Statue = self.Pet:GetObjVar("PetStatue")

    end,

    AiPulse = function(self,root)
        if ( self.Statue and self.Statue:IsValid() ) then
            self.Statue:MoveToContainer(self.Backpack, self.Statue:GetLoc())
            self.ToStatue(self,root)
        else
            -- this pet has never been turned into a statue before (or old one is invalid?), we need to create the statue
            local mountType = self.Pet:GetObjVar("MountType") or "Horse"
            Create.InContainer(PetMountStatueTypes[mountType], self.Backpack, nil, function(statue)
                if ( statue and statue:IsValid() ) then
                    self.Statue = statue
                    self.Statue:SetObjVar("StatuePet", self.Pet)
                    self.Pet:SetObjVar("PetStatue", self.Statue)
                    self.ToStatue(self,root)
                else
                    self.ParentObj:SystemMessage("Failed to create statue, sorry.", "info")
                    EndMobileEffect(root)
                end
            end)
        end
	end,

    ToStatue = function(self,root)
        self.Pet:DelObjVar("Dismissing")
        self.Pet:SetObjectOwner(nil)
        self.Pet:MoveToContainer(self.Statue,Loc())
        EndMobileEffect(root)
    end,

    Can = function(self,root)
        if ( IsGod(self.ParentObj) and not TestMortal(self.ParentObj) ) then
            return true
        end

        if ( not IsTamedPet(self.Pet) or self.Pet:GetObjectOwner() ~= self.ParentObj ) then
            self.ParentObj:SystemMessage("That is not your pet.", "info")
            return false
        end
    
        if not( IsMount(self.Pet) ) then
            self.ParentObj:SystemMessage("Can only dismiss mounts.", "info")
            return false
        end
    
        if ( GetPetSlots(self.Pet) > ServerSettings.Pets.MaxSlotsToAllowDismiss ) then
            self.ParentObj:SystemMessage("Mount is too strong to dismiss.", "info")
            return false
        end		
    
        if ( IsPetCarryingItems(self.Pet) ) then
            self.ParentObj:SystemMessage("Cannot dismiss a mount that is carrying something.", "info")
            return false
        end
    
        return ValidateRangeWithError(5, self.ParentObj, self.Pet, "Too far away.")
    end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	Duration = TimeSpan.FromSeconds(0.5),

}