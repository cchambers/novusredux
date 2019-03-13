require "default:incl_magic_sys"

function GetSpellCastTime(spellName, spellSource)
	if ( SpellData.AllSpells[spellName] ) then
		if ( SpellData.AllSpells[spellName].CastTime ) then
			return SpellData.AllSpells[spellName].CastTime
		end
		local circle = GetSpellInformation(spellName, "Circle") or 8

		local castTime = SpellData.CastTimes[circle]

		spellSource:NpcSpeech(tostring("Base: " ..castTime))

		if (spellSource:HasObjVar("ProtectionSpell")) then
			castTime = castTime + 0.5
			spellSource:NpcSpeech(tostring("Prot+: " ..castTime))
		end

		local mainHand = spellSource:GetEquippedObject("RightHand")
		if (mainHand and mainHand:GetObjVar("WeaponType") == "Spellbook") then
			castTime = castTime - 0.25
			spellSource:NpcSpeech(tostring("Book-: " ..castTime))
		end

		return castTime
	end
end