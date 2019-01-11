MobileEffectLibrary.SpellMagicReflection = 
{
	OnEnterState = function(self,root,target,args)
		self.ParentObj:SetObjVar("MagicReflection", true)
		
		local debuffStr = "You will reflect incoming magical attacks."
		AddBuffIcon(self.ParentObj, "MagicReflectionBuff", "Magic Reflection", "Spell Shield", debuffStr, true)

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