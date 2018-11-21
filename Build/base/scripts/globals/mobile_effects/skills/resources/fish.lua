MobileEffectLibrary.Fish = 
{

	ValidateUse = function(self)	    
	    if (self.ParentObj:HasTimer("fishingTimer")) then
	        self.ParentObj:SystemMessage("You are already fishing.","info")
	        return false
	    end

	    if (self.ParentObj:HasTimer("ReelSuccessTimer")) then
	        self.ParentObj:SystemMessage("You are reeling in a fish!","info")
	        return false
	    end

	    if (self.ParentObj:HasModule("base_fishing_controller")) then
	        self.ParentObj:SystemMessage("You are already fishing.","info")
	        return false
	    end

	    return true
	end,

	OnEnterState = function(self,root,target,args)
		if(args.TargetLoc ~= nil and self:ValidateUse() ) then 
			self.ParentObj:AddModule("base_fishing_controller",{TargetLoc=args.TargetLoc})	
		end

		EndMobileEffect(root)
	end,

	GetPulseFrequency = nil,
}