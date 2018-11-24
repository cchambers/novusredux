--[[
 Handles the AoE of Empower
]]

MobileEffectLibrary.EmpowerAoE = 
{

	OnEnterState = function(self,root,target,args)
		self.Heal = math.ceil(args.Heal or self.Heal)
		if ( self.Heal < 1 ) then self.Heal = 1 end

		local nearbyMobiles = FindObjects(SearchMobileInRange(self.Radius))
		for i=1,#nearbyMobiles do
			local mobile = nearbyMobiles[i]
        	if ( mobile ~= self.ParentObj and not ValidCombatTarget(target, mobile, true) ) then
				mobile:SendMessage("HealRequest", self.Heal, target)
				mobile:PlayEffect("Restoration")
        	end
		end
		
		EndMobileEffect(root)
	end,

	Heal = 1,
	Radius = 8
}