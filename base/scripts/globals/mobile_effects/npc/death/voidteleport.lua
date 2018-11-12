MobileEffectLibrary.VoidTeleport = 
{

	OnEnterState = function(self,root,target,args)
		self.PulseMax = math.random(3,7)
	end,

	OnExitState = function(self,root)

	end,

	GetPulseFrequency = function(self,root)
		local rand = math.random(1,3)
		local delay = 0.3
		if ( rand == 1 ) then
			delay = 0.6
		elseif( rand == 2 ) then
			delay = 0.9
		elseif( rand == 3 ) then
			delay = 1.2
		end
		return TimeSpan.FromSeconds(delay)
	end,

	AiPulse = function(self,root)
		self.CurrentPulse = self.CurrentPulse + 1
		if ( self.CurrentPulse > self.PulseMax ) then
			EndMobileEffect(root)
		else
			self.TeleportToRandomMobile(self,root)
		end
	end,

	TeleportToRandomMobile = function(self,root)
		local loc = self.ParentObj:GetLoc()
        local nearbyMobiles = FindObjects(SearchMulti({
            SearchRange(loc, self._TeleportRadius),
            SearchMobile(),
        }), GameObj(0))

		local potentialTargets = {}
		for i,mobile in pairs(nearbyMobiles) do
			if ( mobile ~= self.ParentObj and mobile ~= self._LastTeleportMobile and ValidCombatTarget(self.ParentObj, mobile, true) ) then
				table.insert(potentialTargets, mobile)
			end
		end

		if ( #potentialTargets > 0 ) then
			local target = potentialTargets[math.random(1,#potentialTargets)]
			local teleportLoc = target:GetLoc()
			if not( IsPassable(teleportLoc) ) then
				EndMobileEffect(root)
				return
			end
			self.ParentObj:SendMessage("AttackEnemy", target, true)
			PlayEffectAtLoc("VoidTeleportToEffect", loc)
			PlayEffectAtLoc("VoidTeleportToEffect", teleportLoc)
			self.ParentObj:PlayAnimation("shield_bash")
			self.ParentObj:SetWorldPosition(teleportLoc)
			self._LastTeleportMobile = target
		end
	end,

	PulseMax = 5,
	CurrentPulse = 0,

	_TeleportRadius = 20,
	_LastTeleportMobile = nil
}