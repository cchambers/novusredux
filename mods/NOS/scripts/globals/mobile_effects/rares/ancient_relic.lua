MobileEffectLibrary.AncientRelic = 
{
	OnEnterState = function(self,root,target,args)
		if ( target ) then
			target:PlayObjectSound("event:/magic/air/magic_air_cast_air",false,0.5)
			target:PlayObjectSound("event:/animals/worm/worm_death",false)
		end
		EndMobileEffect(root)
	end,
}