MobileEffectLibrary.DeathWave = 
{

	OnEnterState = function(self,root,target,args)
		self.ParentObj:PlayAnimation("cast_heal")
		local loc = self.ParentObj:GetLoc()
		PlayEffectAtLoc("DeathwaveEffect", loc)

		local nearbyMobiles = self.GetNearbyMobiles(loc, self._Range)

		for i,mobile in pairs(nearbyMobiles) do
			if ( mobile ~= self.ParentObj and ValidCombatTarget(self.ParentObj, mobile, true) ) then
				local distance = loc:Distance(mobile:GetLoc())
				-- delay the damage to match the ring effect
				CallFunctionDelayed(TimeSpan.FromSeconds(distance/8), function()
					distance = loc:Distance(mobile:GetLoc())
					if ( distance <= self._Range ) then
						-- only if they are still within the ring
						self.ApplyDamageEffectToTarget(self,root,mobile)
					end
				end)
			end
		end

		-- find any that might have wandered into the ring after it started
		CallFunctionDelayed(TimeSpan.FromSeconds(1.75), function()

			local newMobiles = {}
			for i,mobile in pairs(self.GetNearbyMobiles(loc, self._Range)) do
				if ( mobile ~= self.ParentObj and ValidCombatTarget(self.ParentObj, mobile, true) ) then
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

	GetNearbyMobiles = function(loc, range)
		return FindObjects(SearchMulti({
            SearchRange(loc, range),
            SearchMobile(),
        }), GameObj(0))
	end,

	OnExitState = function(self,root)
	end,

	_Range = 12,
	_StunSeconds = 3,
	_MinDamage = 25,
	_MaxDamage = 50

}