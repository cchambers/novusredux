MobileEffectLibrary.PoisonBreath = 
{
	OnEnterState = function(self,root,target,args)
        self._Loc = self.ParentObj:GetLoc()

        self._DestinationLocation = self._Loc:Project(self._Loc:YAngleTo(target:GetLoc()), 5)

        -- make them look at where they are going to spew
        LookAtLoc(self.ParentObj, self._DestinationLocation, self._Loc)

        -- freeze cerberus
        SetMobileMod(self.ParentObj, "Freeze", "PoisonBreath", true)

	end,

	OnExitState = function(self,root)
        SetMobileMod(self.ParentObj, "Freeze", "PoisonBreath", nil)
	end,

	GetPulseFrequency = function(self,root)
		return TimeSpan.FromSeconds(0.25)
	end,

	AiPulse = function(self,root)
        self._Pulse = self._Pulse + 1
        if ( self._Pulse > self._MaxPulse ) then
            EndMobileEffect(root)
            return
        end

        if ( self._Pulse == 1 ) then
            self.ParentObj:PlayEffectWithArgs("SpitAcidEffect",0.0,"Bone=mouth_R_effect_node_VFX")
            self.ParentObj:PlayEffectWithArgs("SpitAcidEffect",0.0,"Bone=mouth_L_effect_node_VFX")
            self.ParentObj:PlayEffectWithArgs("SpitAcidEffect",0.0,"Bone=mouth_M_effect_node_VFX")
            return
        end

        self._Mobiles = FindObjects(SearchMulti({
            SearchRange(self._DestinationLocation, self._PoisonRadius),
            SearchMobile()
        }), GameObj(0))
        
        for i,mobile in pairs(self._Mobiles) do
            if ( not IsDead(mobile) and mobile ~= self.ParentObj ) then
                if not( HasMobileEffect(mobile, "Poison") ) then
                    mobile:SendMessage("StartMobileEffect", "Poison", self.ParentObj, {
                        MinDamage = 10,
                        MaxDamage = 40,
                        PulseMax = 14,
                        PulseFrequency = TimeSpan.FromSeconds(5)
                    })
                end
            end
        end
	end,

    _PoisonRadius = 5,
    _MaxPulse = 5,

    _Pulse = 0,
    _DestinationLocation = nil,
}