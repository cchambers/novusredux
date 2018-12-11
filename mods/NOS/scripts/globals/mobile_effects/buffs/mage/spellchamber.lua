MobileEffectLibrary.SpellChamber = 
{

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration
		self.MaxDifficulty = args.MaxDifficulty or self.MaxDifficulty
		-- mark our mobile as ready to chamber a spell, next time a cast happens it will look for this variable.
		self.ParentObj:SetObjVar("SpellChamberLevel", self.MaxDifficulty)
		self.ParentObj:SystemMessage("Next successful spell cast will be chambered.","info")

		--Sound effect
		self.ParentObj:PlayObjectSound("event:/character/combat_abilities/eviscerate")

		AddBuffIcon(self.ParentObj, "PreSpellChamber", "Spell Chamber", "Unholy Mastery", "Next successful spell cast, difficulty "..self.MaxDifficulty.." and under, will chamber.", true)
		RegisterSingleEventHandler(EventType.Message, "ChamberSpell", function(spell, displayName)
			-- reset prestige cooldown (if existant) so the spell can be fired
			ResetPrestigeCooldown(self.ParentObj, "Mage", "SpellChamber")

			self._Spell = spell
			self.ParentObj:DelObjVar("SpellChamberLevel")
			RemoveBuffIcon(self.ParentObj, "Casting")
			RemoveBuffIcon(self.ParentObj, "PreSpellChamber")
			AddBuffIcon(self.ParentObj, "SpellChambered", "Spell Chambered", (SpellData.AllSpells[self._Spell].Icon or spell:lower()), "Spell "..displayName.." ready to fire.", false)

			self.PrimedEffect = "PrimedAir"
			local spellData = SpellData.AllSpells[spell]
			if(spellData.Skill == "MagerySkill") then
				self.PrimedEffect = "PrimedFire"
			end

			self.ParentObj:PlayEffect(self.PrimedEffect)
		end)
	end,

	OnExitState = function(self,root)
		RemoveBuffIcon(self.ParentObj, "SpellChamber")
		RemoveBuffIcon(self.ParentObj, "SpellChambered")
		UnregisterEventHandler("", EventType.Message, "ChamberSpell")

		if ( self.PrimedEffect ) then
			self.ParentObj:StopEffect(self.PrimedEffect)
		end
		self.ParentObj:PlayEffect("Teleport1Effect")
	end,

	OnStack = function(self,root)
		-- a spell was chambered, good.
		if ( self._Spell ~= nil ) then
			-- fire the spell.
			self.ParentObj:ScheduleTimerDelay(TimeSpan.FromMilliseconds(100), "SpellPrimeTimer", self._Spell, self.ParentObj, true)
		else
			LuaDebugCallStack("Tried to stack SpellChamber (fire chambered spell) with no spell set.")
		end
		RemoveBuffIcon(self.ParentObj, "SpellChambered")
		EndMobileEffect(root)
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromMinutes(2),
	MaxDifficulty = 2,

	_Spell = nil
}