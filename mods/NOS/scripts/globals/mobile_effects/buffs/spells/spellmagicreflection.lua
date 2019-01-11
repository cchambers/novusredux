MobileEffectLibrary.SpellMagicReflection = 
{
	OnEnterState = function(self,root,target,args)
		self.ParentObj:SetObjVar("MagicReflection", true)
		
		AddBuffIcon(
            self.ParentObj,
            "MagicReflectionBuff",
            "Magic Reflection",
            "Spell Shield",
            "You will reflect an incoming magical attack.",
            false
        )
		RegisterSingleEventHandler(EventType.Message, "StopReflecting",
		function()	
			EndMobileEffect(root)
		end)
	end,

	OnExitState = function(self,root)
		self.ParentObj:DelObjVar("MagicReflection")
		RemoveBuffIcon(self.ParentObj, "MagicReflectionBuff")
		self.ParentObj:SystemMessage("You reflected a spell.")
	end,
}