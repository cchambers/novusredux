MobileEffectLibrary.Howl = 
{
   OnEnterState = function(self,root,target,args)
        args = args or {}

        local mobileTeamType = self.ParentObj:GetObjVar("MobileTeamType")

        if(HasHumanAnimations(self.ParentObj)) then
            self.ParentObj:PlayAnimation("roar")
        else
            self.ParentObj:PlayAnimation("howl")
        end
        
        self.ParentObj:PlayEffect("ShockwaveEffect")
        self.ParentObj:PlayObjectSound("event:/monsters/warg/warg_howl", false)

        self.ParentObj:SendMessage("StartMobileEffect", "Rage", self.ParentObj, {
                        Duration = self.RageDuration,
                        PlayerDuration = self.RageDuration,
                    })

        local nearbyMobiles = FindObjects(SearchMobileInRange(self.Radius,true))
        for i,mobile in pairs (nearbyMobiles) do
            if ( ValidCombatTarget(self.ParentObj, mobile) ) then
                --Only enrage mobs on the same team
                local curMobTeamType = mobile:GetObjVar("MobileTeamType")
                if (curMobTeamType == mobileTeamType) then
                    mobile:SendMessage("StartMobileEffect", "Rage", mobile, {
                        Duration = self.RageDuration,
                        PlayerDuration = self.RageDuration,
                    })
                end
            end
        end

        EndMobileEffect(root)
    end,


	OnExitState = function(self,root)

	end,

	GetPulseFrequency = function(self,root)
		return TimeSpan.FromSeconds(0.25)
	end,

	AiPulse = function(self,root)

	end,

    Radius = 5,
    RageDuration = 10,
}