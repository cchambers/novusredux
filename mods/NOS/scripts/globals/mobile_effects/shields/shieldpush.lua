MobileEffectLibrary.ShieldPush = 
{

	OnEnterState = function(self,root,target,args)
		if ( target == nil ) then return EndMobileEffect(root) end
		self.MinDamage = args.MinDamage or self.MinDamage
		self.MaxDamage = args.MaxDamage or self.MaxDamage

        self.ParentObj:PlayAnimation("shield_bash")

		CallFunctionDelayed(TimeSpan.FromMilliseconds(250), function()
			target:SendMessage("ProcessTrueDamage", self.ParentObj, math.random(self.MinDamage, self.MaxDamage), false)
		end)

		EndMobileEffect(root)
	end,

	MaxDamage = 1,
	MaxDamage = 2
}