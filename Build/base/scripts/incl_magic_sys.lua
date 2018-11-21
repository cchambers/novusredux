DEFAULT_SPELL_RANGE = 15

spellScrollBonusesStrings = {
	
			BonusCritChance = "% Bonus Crit Chance",
			BonusSpellDamage = " Bonus SpellDamage ",
			BonusHealing  = " Bonus Healing" ,
			BonusCastingOffset = "s Bonus Casting Speed",
			BonusSpellBuffer = "% Bonus Spell Buffer",
			BonusManaCost = " Bonus Mana Cost",
}

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

function GetSpellReagentInformationText(spellName)
	-- Add reagents to tooltip
	local reagents = GetSpellInformation(spellName, "Reagents") or {}
	local reagentInfoText = ""
	if #reagents > 0 then
		reagentInfoText = "[99CCFF]Reagent"

		--handle plural vs singular reagents
		if #reagents > 1 then reagentInfoText = reagentInfoText .. "s" end
		reagentInfoText = reagentInfoText .. "[-]"

		--put some space between line above and reagent list
		reagentInfoText = "\n\n" .. reagentInfoText

		--list each reagent
		for i,resourceType in ipairs(reagents) do
			reagentInfoText = reagentInfoText .. "\n[FFFF33]" .. resourceType .. "[-]"
		end
	end
	return reagentInfoText
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

function GetSpellCostMod(spellSrc)
	local bonusMod = 1
	 if not (spellSrc:IsMobile()) then return 1 end
	 local myLhand = spellSrc:GetEquippedObject("LeftHand")
	 local myRhand = spellSrc:GetEquippedObject("RightHand")
	 if(myLhand ~= nil) then
	 	if not(myLhand:HasObjVar("SpellConduit")) then
	 		bonusMod = bonusMod + .2
	 	end
	 end
	 if(myRhand ~= nil) then
	 	if not(myRhand:HasObjVar("SpellConduit")) then
	 		bonusMod = bonusMod + .2
	 	end
	 end
	 return bonusMod
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

function GetItemSpellModsString(item)
	if not(item:HasObjVar("SpellBonusesDict")) then
 		return 
	end
	local retStr = ""
	local spBonusDict = item:GetObjVar("SpellBonusesDict") or {}

	local first = true
	
	for spellName, spBonusDatTab in pairs(spBonusDict) do
		
	   local spString = ""
		local first = true
	   retStr = retStr .. "[999911]-" .. spellName .. "-[-] \n"

	   for spBonus, spBonusVal in pairs(spBonusDatTab) do
	   		if(spBonusVal ~= nil) then
		   		local valString = tostring(spBonusVal)					
					if(spBonusVal > 0) then 
						valString = "+" .. valString
					end
	   			spString = spString  .. "[999911] " .. valString .. spellScrollBonusesStrings[spBonus] .. " [-]\n "
	   
	   		end
	   	end
	   	first = true
	   	retStr = retStr .. spString 
	  end
	
	  return ("\n [446677] * Spell Modifiers * [-]\n" .. retStr)
end

function GetSpellCastTime(spellName, spellSource)
	if ( SpellData.AllSpells[spellName] ) then
		if ( SpellData.AllSpells[spellName].CastTime ) then
			return SpellData.AllSpells[spellName].CastTime
		end
		local circle = GetSpellInformation(spellName, "Circle") or 8
		return SpellData.CastTimes[circle]
	end
end


function GetSpellBonusTextInformation(spellName, spellSource)
	local sourceObj = spellSource or this

	--D*ebugMessage("Checking " .. spellName.. " bonus info:")
	local bonusString = ""
	local myVal = 0
	local bonusDict = sourceObj:GetObjVar(spellName.."Info")
	if(this:IsMobile() and bonusDict == nil) then
		tBonusDict = this:GetObjVar("SpellBonusesDict")
		if(tBonusDict ~= nil) then
			bonusDict = tBonusDict[spellName]
		end
		
	end
	if(bonusDict ~= nil) then		
		local first = true
		for k, myVal in pairs (bonusDict) do
			--DebugMessage("Adding Bonus Txt "..k)
			if(myVal ~= nil) and (myVal ~= 0) then
				if not(first) then
					bonusString = bonusString .. "\n"
				end
				first = false

				local valString = tostring(myVal)					
				if(myVal > 0) then 
					valString = "+" .. valString
				end
				bonusString = bonusString .. "[999911] ".. valString .. spellScrollBonusesStrings[k] .. "[-]"
			end
		end
	end
	return bonusString
end

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