require 'incl_magic_sys'

function ValidateUse(user)
	if( user == nil or not(user:IsValid()) ) then
		return false
	end
	if( this:TopmostContainer() ~= user or IsInBank(this)) then
		user:SystemMessage("The scroll must be in your backpack before you can use it.","info")
		return false
	end

	if not(this:HasObjVar("Spell")) then 
		user:SystemMessage("Invalid scroll, no spell set.","info")
		return false
	end

	return true
end

RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if(usedType ~= "Use" and usedType ~= "Cast") then return end

		if not(ValidateUse(user)) then
			return
		end

		if ( usedType == "Cast") then
			local spellName = this:GetObjVar("Spell")
			if ( spellName ) then
				user:SendMessage("ScrollCastSpell", spellName, this)
			end
		end
	end)