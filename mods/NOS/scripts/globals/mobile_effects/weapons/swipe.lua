MobileEffectLibrary.Swipe = 
{

	OnEnterState = function(self,root,target,args)
		self.Range = args.Range or self.Range
		
		self.ParentObj:PlayAnimation("wideswept_attack")
		self.ParentObj:PlayEffect("BuffEffect_D")

		self.Weapon = GetPrimaryWeapon(self.ParentObj)

		if not( self.Weapon ) then
			return EndMobileEffect(root)
		end

		self.Loc = self.ParentObj:GetLoc()
		self.Facing = self.ParentObj:GetFacing()

		local nearbyMobiles = FindObjects(SearchMobileInRange(self.Range, true))
        for i,mobile in pairs (nearbyMobiles) do
        	if ( self.IsInFront(self, mobile) and ValidCombatTarget(self.ParentObj, mobile, true) ) then
        		mobile:SendMessage("ProcessWeaponDamage", self.ParentObj, false, self.Weapon)
				StartMobileEffect(mobile, "Daze", self.ParentObj, {Duration=TimeSpan.FromSeconds(3)})
        	end
        end

		EndMobileEffect(root)
	end,

	-- determine if mobile is within our 180 degree swing area
	IsInFront = function(self, mobile)
		return ( math.abs( self.Facing - self.Loc:YAngleTo(mobile:GetLoc()) ) <= 90 )
	end,

	GetPulseFrequency = nil,

	Range = 1,
}