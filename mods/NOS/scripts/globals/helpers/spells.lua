-- REAGENTS

function HasReagents(spell, mobileObj, scrollObj)
    if ( SpellData.AllSpells[spell] == nil ) then return false end
    -- mobs don't use reagents
	if not( mobileObj:IsPlayer() ) then return true end
    -- valid scroll means we have reagents.
    if ( scrollObj ~= nil and scrollObj:HasModule("spell_scroll") and scrollObj:GetObjVar("Spell") == spell ) then return true end
    if ( SpellData.AllSpells[spell].Reagents == nil ) then
		LuaDebugCallStack("Error: Reagents is nil for spell: "..spell)
        return false
    end
    local backpack = mobileObj:GetEquippedObject("Backpack")
    if ( backpack ~= nil ) then
        local have = 0
        for i,resourceType in ipairs(SpellData.AllSpells[spell].Reagents) do
            if ( resourceType ~= nil and CountResourcesInContainer(backpack,resourceType) > 0) then
                have = have + 1
            end
        end
        if ( have == #SpellData.AllSpells[spell].Reagents ) then
            return true
        end
    end
	return false
end

function ConsumeReagents(spell, mobileObj)
    if ( SpellData.AllSpells[spell] == nil ) then return false end
    if ( SpellData.AllSpells[spell].Reagents == nil ) then
		LuaDebugCallStack("Error: Reagents is nil for spell: "..spell)
        return false
    end

	-- backpack required for reagent consume..
	local backpack = mobileObj:GetEquippedObject("Backpack")
	if not( backpack ) then return false end
	
	-- consume all reagents
    for i,resourceType in pairs(SpellData.AllSpells[spell].Reagents) do
		if not( ConsumeResourceContainer(backpack, resourceType, 1) ) then
			mobileObj:SendMessage("Do not have reagents.", "info")
			return false
		end
    end

	return true
end

-- END REAGENTS

-- consumes scroll if passed
function CheckSpellCastSuccess(spell, mobileObj, scrollObj)
    if ( SpellData.AllSpells[spell] == nil or SpellData.AllSpells[spell].Skill == nil ) then return false end
	-- mobs always succeed.
	if not( IsPlayerCharacter(mobileObj) ) then return true end
	-- Releasing a primed spell while stunned will result in cast failure.
	if ( HasMobileEffect(mobileObj, "Stun") ) then
		DoFizzle(mobileObj)
		return false
	end

	if ( SpellData.AllSpells[spell].Circle == nil ) then
		LuaDebugCallStack("Error: Circle is nil for spell: "..spell)
		return false
	end

	if ( SpellData.AllSpells[spell].Skill == nil ) then
		LuaDebugCallStack("Error: Skill is nil for spell: "..spell)
		return false
	end

	local circle = SpellData.AllSpells[spell].Circle
	local castSkillName = SpellData.AllSpells[spell].Skill

	-- TODO: BRYCE OMG D=
	-- if (self.IsPet and target:GetObjVar("PetSlots") > GetRemainingActivePetSlots(self.ParentObj) ) then
	-- 	self.ParentObj:NpcSpeechToUser("Your pets ghost returns, but immediately runs away.  You are not skilled enough to control another pet.",self.ParentObj)
	-- 	EndMobileEffect(root)
	-- 	return false
	-- end
	
	-- if no scrollObj was passed
	if ( scrollObj == nil ) then
		circle = circle + 2 -- it's two circles easier to cast from scrolls
	end

	local skillDictionary = GetSkillDictionary(mobileObj)

	local skillLevel = GetSkillLevel(mobileObj, castSkillName, skillDictionary) or 0
	local skillGainMinMax = SkillValueMinMax(skillLevel, SpellData.CircleSkills[circle][1], SpellData.CircleSkills[circle][2])
	local success = Success( skillGainMinMax )

	--- when scroll casting, skill check only on a success
	if ( scrollObj == nil or success ) then
		-- only beneficial spells can gain channeling with casting
		if ( SpellData.AllSpells[spell].BeneficialSpellType == true ) then
			local channelingSkillLevel = GetSkillLevel(mobileObj, "ChannelingSkill", skillDictionary) or 0
			CheckSkillChance(
				mobileObj,
				"ChannelingSkill",
				channelingSkillLevel,
				SkillValueMinMax(channelingSkillLevel, SpellData.CircleSkills[circle][1], SpellData.CircleSkills[circle][2])
			)
		else
			-- non-bene spells can gain affinity with casting
			local affinitySkillLevel = GetSkillLevel(mobileObj, "MagicAffinitySkill", skillDictionary) or 0
			CheckSkillChance(
				mobileObj,
				"MagicAffinitySkill",
				affinitySkillLevel,
				SkillValueMinMax(affinitySkillLevel, SpellData.CircleSkills[circle][1], SpellData.CircleSkills[circle][2])
			)
		end

		CheckSkillChance(mobileObj, castSkillName, skillLevel, skillGainMinMax)
	end
	
	-- only consume scroll on success
	if ( success and scrollObj ~= nil ) then
		-- consume the scroll, altering success along the way
		local resourceType = scrollObj:GetObjVar("ResourceType")
		-- TODO: MOVE STACKABLE FUNCTIONS TO GLOBALS SO WE CAN JUST ADJUST STACK DIRECTLY ON THE SCROLL OBJ
		success = ( scrollObj:IsValid() and scrollObj:GetObjVar("Spell") == spell 
				and resourceType and ConsumeResourceContainer(mobileObj, resourceType) )
	end

	if not( success ) then
		DoFizzle(mobileObj)
	end

	return success
end

--- Convenience to allow a single entry before actually doing an interrupt
function CheckSpellCastInterrupt(mobileObj)
    if ( IsPlayerCharacter(mobileObj) ) then
        SpellCastInterrupt(mobileObj)
    end
end

function SpellCastInterrupt(mobileObj)
    if not( mobileObj:HasTimer("SpellPrimeTimer") ) then return end
    mobileObj:SendMessage("CancelSpellCast")
    mobileObj:SystemMessage("[FCF403]Casting interrupted.[-]", "info")
    mobileObj:NpcSpeech("[FCF403]*interrupted*[-]","combat")
	mobileObj:SendMessage("ResetSwingTimer", 1)
end

function HasSpell(spell, mobileObj, scrollObj)
	-- give mobs all spells
	if not( mobileObj:IsPlayer() ) then return true end
	-- casting from scroll... so..
	if ( scrollObj ~= nil and scrollObj:TopmostContainer() == mobileObj ) then return true end
	-- finally check for a spellbook that has the spell on mobileObj
	return SpellbooksHaveSpell(FindSpellbooksOn(mobileObj), spell)
end

function DoFizzle(mobileObj)
	mobileObj:NpcSpeech("[FF0000]*fizzle*[-]", "combat")
	mobileObj:PlayObjectSound("event:/animals/worm/worm_pain",false)
	if ( mobileObj:IsPlayer() ) then
		mobileObj:SystemMessage("Cast failed.", "info")
	end
end