-- Basic NPC mobile effects that could be used on any mob

MobileEffectLibrary.NpcStunAttack = {
	OnEnterState = function(self,root,target,args)
		args = args or {}

		if(HasHumanAnimations(self.ParentObj)) then
			self.ParentObj:PlayAnimation("sunder")
		else
			-- impale is the "heavy attack for mobs"
			self.ParentObj:PlayAnimation("impale")
		end
		
        target:SendMessage("StartMobileEffect", "Stun", self.ParentObj, {
		        Duration = TimeSpan.FromSeconds(2),
		        PlayerDuration = TimeSpan.FromSeconds(2),
		    })

        EndMobileEffect(root)
	end,
}

MobileEffectLibrary.NpcAoeStunAttack = {
	OnEnterState = function(self,root,target,args)
		args = args or {}

		if(HasHumanAnimations(self.ParentObj)) then
			self.ParentObj:PlayAnimation("roar")
		else
			-- cast is roar for mobs that can roar
			self.ParentObj:PlayAnimation("cast")
		end
		
		local nearbyMobiles = FindObjects(SearchMobileInRange(self.Radius,true))
        for i,mobile in pairs (nearbyMobiles) do
        	if ( ValidCombatTarget(self.ParentObj, mobile) ) then
        		mobile:SendMessage("StartMobileEffect", "Stun", self.ParentObj, {
			        Duration = TimeSpan.FromSeconds(2),
			        PlayerDuration = TimeSpan.FromSeconds(2),
			    })
        	end
        end

        EndMobileEffect(root)
	end,

	Radius = 5,
}