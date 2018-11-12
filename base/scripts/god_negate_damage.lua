RegisterEventHandler(EventType.Message, "DamageInflicted",
	function(damager,procDam)
		if (this:HasObjVar("SlayOnAttack")) then
			damager:SendMessage("ProcessTrueDamage", this, 5000, true)
		end
		SetCurHealth(this,GetCurHealth(this) + procDam)
	end)