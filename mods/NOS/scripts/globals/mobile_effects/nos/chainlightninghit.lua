MobileEffectLibrary.ChainLightningHit = 
{
	OnEnterState = function(self, root, from, args)
		caster = args.Caster
		jumps = args.Jumps
		caster:SendMessage("RequestMagicalAttack", "Lightning", self.ParentObj, caster, true)
		from:PlayProjectileEffectTo("ChainLightningEffect", self.ParentObj, 1, 1)
		self.ParentObj:PlayEffect("ChainLightningExplosionEffect")
		self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(2), "ChainLightningHit")
		local targets = FindObjects(SearchMobileInRange(self.Range))
		jumps = jumps + 1
		if (jumps > self.Jumps) then
			EndMobileEffect(root)
			return
		else
			for i = 1, self.Jumps - jumps do
				local who = targets[i]
				if (not(who:HasTimer("ChainLightningHit")) and who ~= caster and not(IsDead(who))) then
					who:SendMessage("StartMobileEffect", "ChainLightningHit", self.ParentObj, { Caster = caster, Jumps = jumps })
				end
			end
		end
		EndMobileEffect(root)
		return
	end,

	Range = 5,
	Jumps = 3,
}
