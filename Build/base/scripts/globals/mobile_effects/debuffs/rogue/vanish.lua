MobileEffectLibrary.Vanish = 
{

    OnEnterState = function(self,root,target,args)
        -- clear all debuffs
		ClearDebuffs(self.ParentObj)
        -- force sneak them
        self.ParentObj:SendMessage("BeginSneak", true)
        self.ParentObj:PlayEffect("CloakEffect")

        EndMobileEffect(root)
	end
    
}