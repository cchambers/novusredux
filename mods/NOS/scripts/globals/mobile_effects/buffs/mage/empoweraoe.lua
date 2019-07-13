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
        	if ( AllowFriendlyActions(target, nearbyMobiles[i]) ) then
				nearbyMobiles[i]:SendMessage("HealRequest", self.Heal, target)
				nearbyMobiles[i]:PlayEffect("Restoration")
        	end
		end
		
		EndMobileEffect(root)
	end,

	Heal = 1,
	Radius = 8
}