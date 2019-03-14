function HandleLoaded(caster)
	if (this:HasObjVar("ProtectionSpell")) then
		this:DelObjVar("ProtectionSpell")
		this:SystemMessage("You are no longer protected.", "info")
		RemoveBuffIcon(this, "ProtectionBuff")
		if (this ~= caster) then
			caster:SystemMessage("They are no longer protected.", "info")
		end
		HandleIcon()
	else
		this:SetObjVar("ProtectionSpell", true)
		this:SystemMessage("You are now protected. Spell casting will take longer.", "info")
		AddBuffIcon(this, "ProtectionBuff", "Protection", "Holy Shield", "Physical and Magical resist reduced. Cast time increased, but you cannot be interrupted.", false)
		if (this ~= caster) then
			caster:SystemMessage("They are now protected.", "info")
		end
		HandleIcon(true)
	end
	CleanUp()
end

function CleanUp()
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(EventType.Message, "ProtectionIcon", HandleIcon)

RegisterEventHandler(EventType.Message, "SpellHitEffectsp_protection_effect", HandleLoaded)
