
mOpen = false

function AddSpell(spellName)
	if ( spellName == nil ) then
		DebugMessage("[spellbook|AddSpell] ERROR: spellName is nil")
		return
	end
	local found = false
	for k,v in pairs(SpellData.AllSpells) do
		if ( k == spellName ) then
			found = true
		end
	end
	if not( found ) then
		DebugMessage("[spellbook|AddSpell] ERROR: invalid spell '"..spellName.."' provided")
		return
	end
	local spellList = this:GetObjVar("SpellList") or {}
	spellList[spellName] = true
	SetSpellList(spellList)
end

function AddAllSpells()
	spellList = {}
	for spellName,spellData in pairs(SpellData.AllSpells) do
		if(spellData.SpellEnabled) then
			spellList[spellName] = true
		end
	end

	SetSpellList(spellList)
end

function SetSpellList(spellList)
	this:SetObjVar("SpellList", spellList);
	this:SetObjVar("SpellCount", CountTable(spellList))
	UpdateTooltip()
end

function UpdateTooltip()
	SetTooltipEntry(this,"spell_count", "Contains "..(this:GetObjVar("SpellCount") or 0).." spells")
end

UpdateTooltip()

RegisterEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
	function()
		AddUseCase(this,"Open", true)
		if ( initializer ~= nil and initializer.Spells ~= nil ) then
			if ( initializer.Spells == "All" ) then
				AddAllSpells()
			else
				SetSpellList(initializer.Spells)
			end
		end
		this:SetObjVar("HandlesDrop",true)
	end)

RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if ( usedType == "Open" or usedType == "Use" ) then
			OpenSpellBook(user,this)
		end
	end)


RegisterEventHandler(EventType.Message, "AddSpell", 
	function(spellName, user)
		AddSpell(spellName)
		if ( user ) then
			user:SystemMessage("Spell "..spellName.." added to spellbook.")
		end
	end)

RegisterEventHandler(EventType.Message, "AddSpellScroll", 
	function(scroll, user)
		local spellName = scroll:GetObjVar("Spell")
		if ( spellName ) then
			AddSpell(spellName)
			scroll:SendMessage("AdjustStack", -1)
			if ( user ) then
				user:SystemMessage("Spell "..spellName.." added to spellbook.")
				local castingSkill = SpellData.AllSpells[spellName].Skill
				local mPageType = castingSkill == "ManifestationSkill" and "ManifestationIndex" or "EvocationIndex"
				OpenSpellBook(user,this,mPageType)
			end
		else
			if ( user ) then
				user:SystemMessage("Failed to add scroll to spellbook, scroll does not have a spell.")
			end
		end
	end)

RegisterEventHandler(EventType.Message, "LoadSpells", 
	function()
		AddAllSpells()
	end)

RegisterEventHandler(EventType.Message,"HandleDrop", 
	function (user,droppedObject)
		if(droppedObject:HasObjVar("Spell")) then
			TryAddSpellToSpellbook(this,droppedObject,user)
		end
	end)