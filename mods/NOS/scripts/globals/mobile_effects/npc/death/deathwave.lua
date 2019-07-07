MobileEffectLibrary.DeathWave = 
{

	OnEnterState = function(self,root,target,args)
		self.ParentObj:PlayAnimation("cast_heal")
		self.Loc = self.ParentObj:GetLoc()
		PlayEffectAtLoc("DeathwaveEffect", self.Loc)

		local nearbyMobiles = self.GetNearbyMobiles(self)

		for i,mobile in pairs(nearbyMobiles) do
			if ( self.ValidTarget(self, mobile) ) then
				local distance = self.Loc:Distance(mobile:GetLoc())
				-- delay the damage to match the ring effect
				CallFunctionDelayed(TimeSpan.FromSeconds(distance/8), function()
					distance = self.Loc:Distance(mobile:GetLoc())
					if ( distance <= self._Range ) then
						-- only if they are still within the ring
						self.ApplyDamageEffectToTarget(self,root,mobile)
					end
				end)
			end
		end

		-- find any that might have wandered into the ring after it started
		CallFunctionDelayed(TimeSpan.FromSeconds(1.75), function()
			for i,mobile in pairs(self.GetNearbyMobiles(self)) do
				if ( self.ValidTarget(self, mobile) ) then
					local found = false
					for j,m in pairs(nearbyMobiles) do
						if ( mobile == m ) then found = true end
					end
					-- it's a mobile that wasn't part of the original list (wandered into death ring after it started)
					if not( found ) then
						self.ApplyDamageEffectToTarget(self,root,mobile)
					end
				end
			end
		end)

		EndMobileEffect(root)
	end,

	ApplyDamageEffectToTarget = function(self,root,target)
		target:SendMessage("StartMobileEffect", "Stun", self.ParentObj, {
			Duration = TimeSpan.FromSeconds(self._StunSeconds)
		})
		target:SendMessage("ProcessMagicDamage", self.ParentObj, math.random(self._MinDamage,self._MaxDamage))
	end,

	ValidTarget = function(self, target)
		return (
			target ~= self.ParentObj
			and
			target:GetObjVar("MobileKind") ~= "Undead"
			and
			target:HasLineOfSightToLoc(self.Loc,ServerSettings.Combat.LOSEyeLevel)
			and
			ValidCombatTarget(self.ParentObj, target, true)
		)
	end,

	GetNearbyMobiles = function(self)
		return FindObjects(SearchMulti({
            SearchRange(self.Loc, self._Range),
            SearchMobile(),
        }), GameObj(0))
	end,

	OnExitState = function(self,root)
	end,

	_Range = 12,
	_StunSeconds = 3,
	_MinDamage = 125,
	_MaxDamage = 250

}