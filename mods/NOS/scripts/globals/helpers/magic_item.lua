
-- DAB COMBAT CHANGES: THESE WILL BE DONE DIFFERENTLY
function GetMagicItemDamageBonus(item)
	local bonus = 0
	if ( item ~= nil ) then
		local bonusIndex = ( item:GetObjVar("MagicDamageBonus") or 0 )
		if ( bonusIndex > 0 and bonusIndex <= #MagicItemDamageModifiers ) then
			bonus = MagicItemDamageModifiers[bonusIndex]
		end
		bonus = bonus + ( item:GetObjVar("DamageBonus") or 0 )
	end
	return bonus
end

function GetMagicItemSpeedModifier(item)
	local bonus = 1
	if(item) then
		bonus = (item:GetObjVar("SpeedModifier") or 1)
	end

	return bonus 
end

function GetMagicItemCritChanceBonus(item)
	local bonus = 0
	if(item) then
		bonus = (item:GetObjVar("CritChanceBonus") or 0)
	end

	return bonus	
end

function GetMagicItemCritDamageBonus(item)
	local bonus = 0
	if(item) then
		bonus = (item:GetObjVar("CritDamageBonus") or 0)
	end

	return bonus	
end

function GetMagicItemArmorBonus(item)
	local bonus = 0
	if ( item ~= nil and item ~= "Fist" ) then--should Fist bonus be 0??
		local bonusIndex = ( item:GetObjVar("MagicArmorBonus") or 0 )
		if ( bonusIndex > 0 and bonusIndex <= #MagicItemArmorModifiers ) then
			bonus = MagicItemArmorModifiers[bonusIndex]
		end
		bonus = bonus + ( item:GetObjVar("ArmorBonus") or 0 )
	end
	return bonus
end

function DetermineSkillMagicness(skillName)
	if ( skillName == nil ) then
		local skillsLen = math.max(1, CountTable(SkillData.AllSkills))
		skillName = math.random(1, skillsLen)
		local i = 1
		for k,v in pairs(SkillData.AllSkills) do
			if ( i == skillName ) then
				skillName = k
			end
			i = i + 1
		end
		-- remove 'Skill' from the end
		skillName = string.sub(skillName, 1, -6)
	end
	this:SetObjVar("SkillBonus", RandomBonus())
	this:SetObjVar("SkillBonusName", skillName)
end

function GetSkillNameString(name)
	local skillBonusIndex = this:GetObjVar("SkillBonus") or 0
	if ( skillBonusIndex > 0 ) then
		local skillDisplayName = this:GetObjVar("SkillBonusName")
		if ( skillDisplayName == nil ) then
			LuaDebugCallStack("Failed to get the name of the bonus skill")
			skillDisplayName = "N/A"
		end
		name = MagicItemSkillModStrings[skillBonusIndex] .. " " .. name
		if ( skillDisplayName == "Melee" ) then
			return name
		end
		local bonus = this:GetObjVar("MagicDamageBonus") or this:GetObjVar("MagicArmorBonus")
		if ( bonus == nil ) then bonus = 0 end
		if ( bonus > 0 ) then
			name = name .. " and "
		else
			name = name .. " of "
		end
		name = name .. skillDisplayName
	end

	return name
end

function DetermineDurabilityMagicness()
	local baseDurability = this:GetObjVar("BaseDurability")
	local bonusDurability = this:GetObjVar("MagicDurabilityBonus")
	if ( bonusDurability == nil ) then
		local bonus = RandomBonus()
		SetTooltipEntry(this, "magic_durability", "Durability Bonus: "..MagicItemDurabilityModifiers[bonus])
		this:SetObjVar("MagicDurabilityBonus", bonus)
		this:SetObjVar("OriginalDurability", this:GetObjVar("Durability"))
		this:SendMessage("AlterBaseDurabilityMessage", MagicItemDurabilityModifiers[bonus])
	end
end

function GetDurabilityNameString(name)
	local durabilityBonusIndex = this:GetObjVar("MagicDurabilityBonus")
	if ( durabilityBonusIndex ~= nil and durabilityBonusIndex > 0 and durabilityBonusIndex <= #MagicItemDurabilityModStrings ) then
		return MagicItemDurabilityModStrings[durabilityBonusIndex]
	end
	return ""
end

function GetNameColor()
	local getName = this:GetObjVar("OriginalName")
	local color = "[FFFFFF]"
	if ( getName == nil ) then
		return "N/A", color
	end
	local name = StripColorFromString(getName)
	return name, color
end

function GetNameString(name)
	local durabilityString = GetDurabilityNameString()
	if ( durabilityString ~= "" ) then
		name = durabilityString .. " " .. name
	end
	
	return GetSkillNameString(name)
end

function GetSkillBonusTooltipString()
	local skillBonusIndex = this:GetObjVar("SkillBonus") or 0
	local skillBonusString = ""
	if ( skillBonusIndex > 0 ) then
		skillBonusString = this:GetObjVar("SkillBonusName") .. ": "..MagicItemSkillModifiers[skillBonusIndex]
	end
	return skillBonusString
end

function RandomBonus()
	local intensity = this:GetObjVar("Intensity") or MagicItemDefaultIntensity
	local random = math.random(intensity[1], intensity[2])

	if ( 50 > random ) then
		return 1
	else
		random = random - 50
	end

	if ( 25 > random ) then
		return 2
	else
		random = random - 25
	end

	if ( 14 > random ) then
		return 3
	else
		random = random - 14
	end

	if ( 8 > random ) then
		return 4
	end

	return 5
end