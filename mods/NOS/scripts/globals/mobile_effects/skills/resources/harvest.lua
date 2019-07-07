MobileEffectLibrary.Harvest = 
{

	OnEnterState = function(self,root,target,args)
		-- args
		self.Duration = args.Duration or self.Duration

		if(target) then
			local tool = root.ParentObj:GetEquippedObject("RightHand")
			if(tool) then
				tool:SendMessage("HarvestObject",target,root.ParentObj)
			end
		end

		EndMobileEffect(root)
	end,
}