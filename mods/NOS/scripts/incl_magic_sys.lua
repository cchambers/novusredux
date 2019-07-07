DEFAULT_SPELL_RANGE = 15

function GetReagentStr(reagentTable)
	local reagentStr = ""
	if(reagentTable and #reagentTable > 0) then
		for i,reg in pairs(reagentTable) do 
			if(reagentStr ~= "") then
				reagentStr = reagentStr .. "\n"
			end
			reagentStr = reagentStr .. reg
		end
	end

	return reagentStr
end

function GetSpellUserAction(spell)
	local spellData = SpellData.AllSpells[spell]
	local icon = spellData.Icon or spell:lower()
	if(spellData.Icon == nil and spellData.IconText ~= nil) then
		icon = "LighterSlotIcon"
	end
	local displayName = spellData.SpellDisplayName or spell
	local tooltip = spellData.SpellTooltipString
	local reagentStr = GetReagentStr(spellData.Reagents)
	if(reagentStr ~= "") then
		tooltip = tooltip .. "\n\nReagents:\n"..reagentStr
	end

	local requirements = {}
	local manaCost = spellData.manaCost
	if(manaCost>0) then
		table.insert(requirements,{"Mana",manaCost})
	end

	local actionData = {
		ID = spell,
		ActionType = "Spell",
		DisplayName = displayName,
		Tooltip = tooltip,
		Icon = icon,
		IconText = spellData.IconText,
		Enabled = true,
		ServerCommand = "sp "..spell,
		Requirements = requirements
	}
	return actionData
end

function GetSpellSchoolTable(spellName)
	local myTable = SpellData.AllSpells[spellName]
	--DebugMessage(DumpTable(SpellData.AllSpells))
	if(myTable == nil ) then 
		DebugMessage("[ERROR] Spell Table Returned nil "..tostring(spellName))
		return nil 
	end
	return myTable
end

function GetSpellInformation(spellName, infoReq)
	if(spellName == nil) then return nil end
	if(infoReq == nil) then
		--DebugMessage("[ERROR] Spell Info Request was Nil") 
		return nil
	end
	local myTable = GetSpellSchoolTable(spellName)
	if(myTable == nil) then 
		--DebugMessage("SpellSchoolTable Returned Nil: " .. infoReq)
		return nil 
	end
	local myInfo = myTable[infoReq]
	--DebugMessage("GetInfo for " ..tostring(spellName).. " on " ..tostring(infoReq).. " returning " .. tostring(myInfo))
	if(myInfo == nil) then return nil end
	return myInfo
end

function GetManaCost(spellName)
	return GetSpellInformation(spellName, "manaCost") or 1000
end

function HasManaForSpell(spellName, targMob)
	if(targMob == nil) then targMob = this end
	local manaCost = GetManaCost(spellName)
	local curMana = GetCurMana(targMob)
	if(curMana >= manaCost) then return true end
	return false
end

function GetMinSkillToCast(spellName)
	local spellCircle = GetSpellInformation(spellName, "Circle") or 1
	-- add two because its not cast from a scroll
	local spellSkillRange = SpellData.CircleSkills[spellCircle+2]

	return spellSkillRange[1]
end

function MeetsSkillRequirements(castMob, spellName)
	local skillUsed = GetSpellInformation(spellName, "Skill") or "ManifestationSkill"
	local skillLevel = GetSkillLevel(castMob,skillUsed) or 0
	
	--DebugMessage("MeetsSkillRequirements",tostring(castMob:GetName()),tostring(spellName),tostring(GetMinSkillToCast(spellName)),tostring(skillLevel))
	return skillLevel >= GetMinSkillToCast(spellName)
end

function IsCasting(target)
	return target:HasTimer("SpellPrimeTimer")
end

function GetSpellRange(spellName,spellSource)
	local spellRange = GetSpellInformation(spellName, "SpellRange")
	if(spellRange == nil) then return DEFAULT_SPELL_RANGE end
	return spellRange
end

-- function GetSpellCastTime(spellName, spellSource)
-- 	if ( SpellData.AllSpells[spellName] ) then
-- 		if ( SpellData.AllSpells[spellName].CastTime ) then
-- 			return SpellData.AllSpells[spellName].CastTime
-- 		end
-- 		local circle = GetSpellInformation(spellName, "Circle") or 8
-- 		return SpellData.CastTimes[circle]
-- 	end
-- end

-- also consumes.
function CheckReagents(spellName, spellSource, scrollObj)
	if not( this:IsPlayer() ) then return true end
	if ( scrollObj ~= nil and scrollObj:HasModule("spell_scroll") and scrollObj:HasObjVar("Spell") ) then
		return true
	end
	if not( HasReagents(spellName, spellSource) ) then
		if ( spellSource:IsPlayer() ) then
			spellSource:SystemMessage("Missing reagents.", "info")
		end
		return false
	end
	return ConsumeReagents(spellName, spellSource)
end

function CheckMana(spellName, spellSource)
	if not( HasManaForSpell(spellName, spellSource) ) then
		if ( spellSource:IsPlayer() ) then
			spellSource:SystemMessage("Not enough mana.", "info")
		end
		return false
	end
	return true
end

function GetSpellCastTime(spellName, spellSource)
	if ( SpellData.AllSpells[spellName] ) then
		if ( SpellData.AllSpells[spellName].CastTime ) then
			return SpellData.AllSpells[spellName].CastTime
		end
		local circle = GetSpellInformation(spellName, "Circle") or 8

		local castTime = SpellData.CastTimes[circle]

		-- spellSource:NpcSpeech(tostring("Base: " ..castTime))

		if (spellSource:HasObjVar("ProtectionSpell")) then
			castTime = castTime + 0.5
			-- spellSource:NpcSpeech(tostring("Prot+: " ..castTime))
		end

		local mainHand = spellSource:GetEquippedObject("RightHand")
		if (mainHand and mainHand:GetObjVar("WeaponType") == "Spellbook") then
			castTime = castTime - 0.25
			-- spellSource:NpcSpeech(tostring("Book-: " ..castTime))
		end

		return castTime
	end
end