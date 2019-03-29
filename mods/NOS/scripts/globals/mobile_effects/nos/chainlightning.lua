MobileEffectLibrary.ChainLightning = 
{
	OnEnterState = function(self,root,caster,args)		
		caster:PlayProjectileEffectTo("ChainLightningEffect", self.ParentObj, 1, 1)
		self.ParentObj:PlayEffect("ChainLightningExplosionEffect")
		self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(2), "ChainLightningHit")
		local targets = FindObjects(SearchMobileInRange(self.Range))
		local spread = 0

		for i = 1, #targets do
			if (spread >= self.Spread) then
				break
			end
			local who = targets[i]
			if (not(who:HasTimer("ChainLightningHit")) and who ~= caster and not(IsDead(who))) then
				spread = spread + 1
				who:SendMessage("StartMobileEffect", "ChainLightningHit", self.ParentObj, { Caster = caster, Jumps = 1 })
			end
		end
		EndMobileEffect(root)
		return
	end,

	Range = 5,
	Spread = 2
}
