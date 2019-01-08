MobileEffectLibrary.Criminal = 
{
	--- Optional flag for this effect to apply (if there's enough duration left) on login.
	PersistSession = true,

	-- Options flag for this effect to not be removed on death
	PersistDeath = true,

	-- Prevents this effect from being applied to Immune targets and when people go Immune, this effect is dropped.
	--Debuff = true, -- For Chaotic we leave this false. Stasis shouldn't remove it for example.

	-- Can this be resisted by Willpower?
	--Resistable = true,

	OnEnterState = function(self,root,target,args)

		if not( IsPlayerCharacter(self.ParentObj) ) then
			LuaDebugCallStack("[Chaotic Debuff] Attempting to apply Chaotic Debuff to an NPC?")
			return EndMobileEffect(root)
		end

		self._Applied = true
		self.ApplyIcon(self,root)

		-- flag them temp chaotic
		self.ParentObj:SetObjVar("IsCriminal", true)

		local debuffStr = "You are a Criminal!"
		AddBuffIcon(self.ParentObj, "CriminalDebuff", "Criminal", "Imbue Unholy", debuffStr, true)
		self.ParentObj:SystemMessage(debuffStr, "event")
	end,

	OnExitState = function(self,root)
		if not( self._Applied ) then return end
		self.ParentObj:DelObjVar("IsCriminal")
		RemoveBuffIcon(self.ParentObj, "CriminalDebuff")
		ForeachMobileAndPet(self.ParentObj, function(mobile)
			if ( mobile:HasObjVar("IsCriminal") ) then
				mobile:DelObjVar("IsCriminal")
			end
		end)
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	OnStack = function(self,root,target,args)
		-- anytime this mobile effect is stacked, we just refresh it
		OnStackRefreshDuration(self,root,target,args)
		self.ApplyIcon(self,root)
	end,

	-- apply the order status icon to them so globally everyone knows they are order (or 'temp chaos')
	ApplyIcon = function(self,root)
		ForeachMobileAndPet(self.ParentObj, function(mobile)
			if not( mobile:HasObjVar("IsCriminal") ) then
                mobile:SetObjVar("IsCriminal", true)
                self.ParentObj:SendMessage("UpdateName")
			end
		end)
	end,

	-- Optional function when the effect receives the end effect message, This is NOT called when the effect ends internally, only when an external source trys to end the effect.
--[[
	OnEndEffect = function(self,root)
		self.ParentObj:NpcSpeech("EndEffect!")
		-- must call EndMobileEffect in here (unless you have a reason not to) if OnEndEffect is provided.
		EndMobileEffect(curTable)
	end,
]]

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromMinutes(2),
	_Applied = false,
}