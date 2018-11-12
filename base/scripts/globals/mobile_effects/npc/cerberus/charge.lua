MobileEffectLibrary.CerberusCharge = 
{
	OnEnterState = function(self,root,target,args)
        self.ParentObj:SetObjVar("AI-Disable", true)

        self._Loc = self.ParentObj:GetLoc()

        -- find the most far away with line of sight (default to target)
        self._FurthestMobile = target
        self._FurthestDistance = self._Loc:Distance(self._FurthestMobile:GetLoc())

        -- variables re-used in the loop
        local distance = 0
        for i,mobile in pairs(self.GetMobilesInRadius(self,root,self._ChargeDistance)) do
            if ( mobile ~= self.ParentObj and not IsDead(mobile) and mobile ~= target and self.ParentObj:HasLineOfSightToObj(mobile) ) then
                distance = self._Loc:Distance(mobile:GetLoc())
                if ( distance > self._FurthestDistance ) then
                    self._FurthestMobile = mobile
                    self._FurthestDistance = distance
                end
            end
        end

        -- make them look at where they are going to charge
        LookAt(self.ParentObj, self._FurthestMobile)

        -- freeze cerberus
        SetMobileMod(self.ParentObj, "Freeze", "Charge", true)

        self.ParentObj:PlayAnimation("dodge")

        RegisterEventHandler(EventType.Arrived, "ChargeEnd", function(success)
            EndMobileEffect(root)
        end)

	end,

	OnExitState = function(self,root)
        self.ParentObj:DelObjVar("AI-Disable")
        self.ParentObj:StopEffect("AfterburnEffect")
        self.ParentObj:StopEffect("DustTrailEffect")
        UnregisterEventHandler("", EventType.Arrived, "ChargeEnd")
	end,

	GetPulseFrequency = function(self,root)
		return TimeSpan.FromSeconds(0.1)
	end,

	AiPulse = function(self,root)
        self._Pulse = self._Pulse + 1
        if ( self._Pulse > self._MaxPulse ) then
            EndMobileEffect(root)
            return
        end

        if ( self._Pulse < 5 ) then
            if ( self._Pulse == 1 ) then
                self.ParentObj:PlayEffectWithArgs("AfterburnEffect",4.0,"Bone=Ground")
                self.ParentObj:PlayEffectWithArgs("DustTrailEffect",4.0,"Bone=Ground")
            end
            if ( self._Pulse == 4 ) then
                SetMobileMod(self.ParentObj, "Freeze", "Charge", nil)
                local chargeDistance = self._Loc:Distance(self._FurthestMobile:GetLoc()) + 5
                -- prevent a close charge from spamming damage
                self._MaxPulse = (math.max(chargeDistance/4) + 4)
                self._DestinationLocation = self._Loc:Project(self._Loc:YAngleTo(self._FurthestMobile:GetLoc()), chargeDistance)
                self.ParentObj:MoveTo(self._DestinationLocation, self._ChargeSpeed, GetBodySize(self.ParentObj), "ChargeEnd")
            end
            return
        end
        
        for i,mobile in pairs(self.GetMobilesInRadius(self,root,self._ChargeRadius)) do
            if ( not IsDead(mobile) and mobile ~= self.ParentObj ) then
                mobile:SendMessage("ProcessMagicDamage", self.ParentObj, math.random(25,50))
            end
        end
	end,

    GetMobilesInRadius = function(self,root,radius)
        return FindObjects(SearchMulti({
            SearchRange(self.ParentObj:GetLoc(), radius),
            SearchMobile()
        }), GameObj(0))
    end,

    _ChargeSpeed = 14,
    _ChargeRadius = 4,
    _MaxPulse = 12,
    _Pulse = 0,
    _ChargeDistance = 20,

    _DestinationLocation = nil,
}