--- Find all spellbook objects on/in another object
-- @param obj
-- @return lua list of spellbook objects
function FindSpellbooksOn(obj)
	local spellbooks = {}

	-- look for spellbooks in their backpack
	local backpack = obj:GetEquippedObject("Backpack")
	if ( backpack ) then
		spellbooks = FindItemsInContainerRecursive(backpack, function(fobj)
			return ( fobj:HasModule("spellbook") )
		end)
	end

	-- look for one equipped
	local equipped = obj:GetEquippedObject("RightHand")
	if ( equipped ) then
		table.insert(spellbooks, equipped)
	end

	return spellbooks
end

--- Determine if a spellbook has a spell
-- @param spellbook
-- @param spellname
-- @return true if spellbook as spellname
function SpellbookHasSpell(spellbook, spellname)
	if ( spellbook == nil or spellname == nil or spellname == "" ) then return false end
	return ( ( spellbook:GetObjVar("SpellList") or {} )[spellname] or false )
end

--- Given a list of spellbooks objects and a spellname, determine if a spell is available
-- @param spellbooks lua list of spellbook objs, return restul from FindSpellbooksOn
-- @param spellname
-- @return true of any of the spellbooks have the spellname.
function SpellbooksHaveSpell(spellbooks, spellname)
	for i=1,#spellbooks do
		if ( SpellbookHasSpell(spellbooks[i], spellname) ) then
			return true
		end
	end
	return false
end

function OpenSpellBook(user,spellbook,pageType)
	if not( user:HasModule("cicle_spellbook_dynamic_window") ) then
		user:AddModule("cicle_spellbook_dynamic_window")
	end
	user:SendMessage("OpenSpellBook", spellbook, pageType)
end

function TryAddSpellToSpellbook(spellbook, spellScroll, user)
	if ( spellbook == nil ) then return end
	if ( spellbook:HasModule("spellbook") ) then
		local spellname = spellScroll:GetObjVar("Spell")
		if ( spellname ) then
			if ( SpellbookHasSpell(spellbook, spellname) ) then
				user:SystemMessage("Spellbook already has that spell.","info")
			else
				spellbook:SendMessage("AddSpellScroll", spellScroll, user)
			end
		else
			user:SystemMessage("Something seems to be broken with this scroll, it doesn't have the information it needs. Sorry.")
		end
	else
		user:SystemMessage("That is not a spellbook.","info")
	end
end