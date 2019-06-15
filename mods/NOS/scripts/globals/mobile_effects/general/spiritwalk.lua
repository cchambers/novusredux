MobileEffectLibrary.SpiritWalk = 
{
	OnEnterState = function(self,root,target,args)
        self.Duration = args.Duration or self.Duration

        if not( self.ParentObj:HasObjVar("IsGhost") ) then
            EndMobileEffect(root)
            return false
        end

        self._Applied = true

        RegisterEventHandler(EventType.StartMoving, "", function()
            self.Interrupted(self, root)
        end)
        self.ParentObj:StopMoving()

        self.ParentObj:PlayAnimation("cast")
        
    end,
    
    Interrupted = function(self, root)
        self.ParentObj:SystemMessage("Spirit Walk interrupted.", "info")
        -- reset cooldown of primary ability (Spirit Walk)
        ResetWeaponAbilityCooldown(self.ParentObj, true)
        EndMobileEffect(root)
    end,

	OnExitState = function(self,root)
		if ( self._Applied ) then
            self.ParentObj:PlayAnimation("idle")
            UnregisterEventHandler("", EventType.StartMoving, "")
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

    AiPulse = function(self,root)
        if ( IsDead(self.ParentObj) ) then
            -- teleport them to closest shrine
            TeleportToClosestShrine(self.ParentObj, function(success)
                if not( success ) then
                    self.ParentObj:SystemMessage("Failed to spirit walk, internal server error.", "info")
                end
                EndMobileEffect(root)
            end)
        end
	end,

	Duration = TimeSpan.FromSeconds(5),
}