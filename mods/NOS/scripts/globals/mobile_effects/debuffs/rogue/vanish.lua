MobileEffectLibrary.Vanish = 
{

    OnEnterState = function(self,root,target,args)
        -- clear all debuffs
		ClearDebuffs(self.ParentObj)
        self.ParentObj:PlayEffect("CloakEffect")
        -- force hide them
        self.ParentObj:SendMessage("StartMobileEffect", "Hide", nil, {Force=true})

        self.ParentObj:PlayObjectSound("event:/magic/air/magic_air_cloack")

        EndMobileEffect(root)
	end,
    
}