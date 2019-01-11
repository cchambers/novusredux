MobileEffectLibrary.SpellMagicReflection = 
{
	OnEnterState = function(self,root,target,args)
		self.ParentObj:SetObjVar("MagicReflection", true)
		RegisterSingleEventHandler(EventType.Message, "StopReflecting",
		function()	
			EndMobileEffect(root)
		end)
	end,

	OnExitState = function(self,root)
		self.ParentObj:DelObjVar("MagicReflection")
		self.ParentObj:SystemMessage("You reflected a spell.")
	end,
}