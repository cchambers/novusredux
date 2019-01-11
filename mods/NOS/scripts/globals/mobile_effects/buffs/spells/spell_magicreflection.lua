MobileEffectLibrary.SpellMagicReflection = 
{
	OnEnterState = function(self,root,target,args)
		RegisterSingleEventHandler(EventType.Message, "StopReflecting",
		function()	
			EndMobileEffect(root)
		end)
	end,

	OnExitState = function(self,root)
		self.ParentObj:SystemMessage("You reflected a spell.")
	end,
}