MobileEffectLibrary.Destruction = 
{
	PersistSession = true, -- so the arguments are saved and we can access them when we fire the spell.

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration
		self.Modifier = args.Modifier or self.Modifier

		self._IsPlayer = self.ParentObj:IsPlayer()

		if ( self._IsPlayer ) then
			AddBuffIcon(self.ParentObj, "DestructionBuff", "Destruction", "Unholy Blast", "Direct hit spells will do "..(self.Modifier*100).."% damage to enemies within 8 yards of target.", false)
			self.ParentObj:PlayEffect("DestructionEffect")
		end
	end,

	OnExitState = function(self,root)
		if ( self._IsPlayer ) then
			RemoveBuffIcon(self.ParentObj, "DestructionBuff")
			self.ParentObj:StopEffect("DestructionEffect")
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(1),
	Modifier = 0.1,
}

function CheckDestructionMobileEffect(spellSource, atTarget, damage, spellName)
	if ( damage == nil ) then damage = 0 end
	if ( 
		damage > 0
		and
		SpellData.AllSpells[spellName] ~= nil
		and
		SpellData.AllSpells[spellName].TargetType == "targetMobile"
		and
		SpellData.AllSpells[spellName].SpellType == "MagicAttackTypeSpell"
		and
		HasMobileEffect(spellSource, "Destruction")
	) then
		local effects = spellSource:GetObjVar("MobileEffects")
		if ( effects and effects.Destruction and effects.Destruction[2] and effects.Destruction[2].Modifier ) then
			atTarget:SendMessage("StartMobileEffect", "DestructionAoE", spellSource, {Damage=damage * effects.Destruction[2].Modifier})
		end
	end
end