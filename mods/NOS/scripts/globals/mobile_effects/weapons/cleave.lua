MobileEffectLibrary.Cleave = 
{

	OnEnterState = function(self,root,target,args)
		self.Range = args.Range or self.Range
		
		self.ParentObj:PlayAnimation("wideswept_attack")
		self.ParentObj:PlayEffect("BuffEffect_A")
		if (IsMale(self.ParentObj)) then
			self.ParentObj:PlayObjectSound("event:/character/human_male/human_male_attack")
		else
			self.ParentObj:PlayObjectSound("event:/character/human_female/human_female_attack")
		end

		self.Weapon = GetPrimaryWeapon(self.ParentObj)

		if not( self.Weapon ) then
			return EndMobileEffect(root)
		end

		self._Loc = self.ParentObj:GetLoc()
		self._Facing = self.ParentObj:GetFacing()

		local nearbyMobiles = FindObjects(SearchMobileInRange(self.Range, true))
		for i=1,#nearbyMobiles do
			local mobile = nearbyMobiles[i]
        	if ( 
				self.IsInFront(self, mobile)
				and
				ValidCombatTarget(self.ParentObj, mobile, true)
				and
				self.ParentObj:HasLineOfSightToObj(mobile, ServerSettings.Combat.LOSEyeLevel)
			) then
        		mobile:SendMessage("ProcessWeaponDamage", self.ParentObj, false, self.Weapon)
        	end
        end

		EndMobileEffect(root)
	end,

	-- determine if mobile is within our 180 degree swing area
	IsInFront = function(self, mobile)
		return ( math.abs( self._Facing - self._Loc:YAngleTo(mobile:GetLoc()) ) <= 90 )
	end,

	GetPulseFrequency = nil,

	Range = 1,

	_Facing,
	_Loc
}