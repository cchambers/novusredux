--[[
 Handles the AoE damage of Destruction
]]

MobileEffectLibrary.DestructionAoE = 
{

	OnEnterState = function(self,root,target,args)
		self.Damage = args.Damage or self.Damage
		local nearbyMobiles = FindObjects(SearchMobileInRange(self.Radius, true))
		for i=1,#nearbyMobiles do
			local mobile = nearbyMobiles[i]
        	if ( mobile ~= self.ParentObj and ValidCombatTarget(target, mobile, true) ) then
				mobile:SendMessage("ProcessMagicDamage", target, self.Damage)
				mobile:PlayEffect("FireballExplosionEffect")
        	end
        end
		EndMobileEffect(root)

	end,

	Damage = 1,
	Radius = 8
}