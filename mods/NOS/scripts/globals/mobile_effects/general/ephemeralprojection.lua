MobileEffectLibrary.EphemeralProjection = 
{
    
	OnEnterState = function(self,root,target,args)
        self.Duration = args.Duration or self.Duration

        if not( self.ParentObj:HasObjVar("IsGhost") ) then
            EndMobileEffect(root)
            return false
        end

        local corpse = self.ParentObj:GetObjVar("CorpseObject")
        if ( corpse == nil or not corpse:IsValid() or self.ParentObj:GetLoc():Distance(corpse:GetLoc()) > ServerSettings.Death.SelfResurrectDistance) then
            self.ParentObj:SystemMessage("Must be near your corpse to project.", "info")
            OnNextFrame(function()
                StartWeaponAbilityCooldown(self.ParentObj, false, TimeSpan.FromSeconds(5))
            end)
            EndMobileEffect(root)
            return false
        end

        self._Applied = true
        
        AddBuffIcon(self.ParentObj, "EphemeralProjection", "Ephemeral Projection", "Force Push 02", "Can see physical entities.")
        
        AstralPlane.Leave(self.ParentObj)

    end,

	OnExitState = function(self,root)
        if ( self._Applied ) then
            RemoveBuffIcon(self.ParentObj, "EphemeralProjection")
            if ( self.ParentObj:HasObjVar("IsGhost") ) then
                AstralPlane.Join(self.ParentObj)
            end
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

    AiPulse = function(self,root)
        EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(5),
}