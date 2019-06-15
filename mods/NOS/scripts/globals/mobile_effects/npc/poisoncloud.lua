MobileEffectLibrary.PoisonCloud = 
{
   OnEnterState = function(self,root,target,args)
        args = args or {}

        local mobileTeamType = self.ParentObj:GetObjVar("MobileTeamType")

        if(HasHumanAnimations(self.ParentObj)) then
            self.ParentObj:PlayAnimation("roar")
        else
            self.ParentObj:PlayAnimation("cast")
        end
        
        PlayEffectAtLoc("PoisonRingEffect",self.ParentObj:GetLoc())
        self.ParentObj:PlayObjectSound("event:/character/combat_abilities/adrenaline_rush", false, 0, true)


        local nearbyMobiles = FindObjects(SearchMobileInRange(self.Radius,true))
        for i,mobile in pairs (nearbyMobiles) do
            if ( ValidCombatTarget(self.ParentObj, mobile) ) then
                --Only enrage mobs on the same team
                local curMobTeamType = mobile:GetObjVar("MobileTeamType")
                if (curMobTeamType ~= mobileTeamType) then
                    mobile:SendMessage("StartMobileEffect", "Poison", self.ParentObj, {
                        MinDamage = 10,
                        MaxDamage = 25,
                        PulseMax = 14,
                        PulseFrequency = TimeSpan.FromSeconds(5)
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

    Radius = 4,
}