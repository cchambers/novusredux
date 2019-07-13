PetStance = {
	Passive = "Passive",
	Aggressive = "Aggressive"
}

--- Perform a callback function on each active pet
-- @param mobile(mobileObj)
-- @param cb(function)
function ForeachActivePet(mobile, cb, includeMount)
	Verbose("Pet", "ForeachActivePet", mobile, cb)
	local list = GetActivePets(mobile, nil, includeMount)
	for i=1,#list do
		if ( list[i] and list[i]:IsValid() ) then
			cb(list[i])
		end
	end
end

--- Returns a list containing all pets and the owner.
-- @param mobile, can be the owner or any pets
-- @return luaTable (Array)
function GetMobileAndPets(mobile)
	Verbose("Pet", "GetMobileAndPets", mobile)
	mobile = mobile:GetObjectOwner() or mobile
	local list = GetActivePets(mobile)
	list[#list+1] = mobile
	return list
end

--- Perform a callback function on each valid mobile and all their active/valid pets
-- @param mobile(mobileObj)
-- @param cb(function)
function ForeachMobileAndPet(mobile, cb, includeMount)
    Verbose("Pet", "ForeachMobileAndPet", mobile)
	if ( cb == nil ) then return end
	local list = GetMobileAndPets(mobile, nil, includeMount)
	for i=1,#list do
		if ( list[i] and list[i]:IsValid() ) then
			cb(list[i])
		end
	end
end


--- Get the chance a master has to control a creature.
-- @param master mobileObj
-- @param creature mobileObj
-- @return from 0 to 1 percent based chance
function ChanceToControlCreature(master, creature)
    Verbose("Pet", "ChanceToControlCreature", master, creature)
    if(IsGod(master)) then return 1 end
	if ( creature == nil or not creature:IsValid() or IsDead(creature) ) then return 0 end
	-- prevent any chance to control on players and if the master somehow has too many pets.
	if ( IsPlayerCharacter(creature) ) then return 0 end
	if ( GetRemainingActivePetSlots(master) < 0 ) then
		if ( IsPlayerCharacter(master) ) then
			master:SystemMessage("Too many pets to control.", "info")
		end
		return 0
	end

	local petDifficulty = creature:GetObjVar("TamingDifficulty")
	if ( petDifficulty == nil ) then return 0 end

	local skillDictionary = GetSkillDictionary(master)

	if ( petDifficulty >= 100 ) then
		return ChanceToControl(skillDictionary, petDifficulty - 100, "BeastmasterySkill")
	end

	return ChanceToControl(skillDictionary, petDifficulty)
end

function ChanceToControl(masterSkillDictionary, petDifficulty, tamingSkill)
    Verbose("Pet", "ChanceToControl", {}, petDifficulty, tamingSkill)

	if not ( tamingSkill ) then
		if ( petDifficulty <= 29.1 ) then return 1 end
		tamingSkill = "AnimalTamingSkill"
	end

	petDifficulty = petDifficulty * 10
	local taming = (GetSkillLevelFromDictionary(tamingSkill, masterSkillDictionary)*10) - petDifficulty
	local lore = (GetSkillLevelFromDictionary("AnimalLoreSkill", masterSkillDictionary)*10) - petDifficulty

	if ( taming < 0 ) then taming = taming * 28 else taming = taming * 6 end
	if ( lore < 0 ) then lore = lore * 14 else lore = lore * 6 end
	local chance = 700 + ( (taming + lore) / 2 )
	if ( chance >= 0 and chance < 200 ) then chance = 200 end
	return ( chance / 1000 )
end

function CheckControlSuccess(master, creature)
	local chance = ChanceToControlCreature(master, creature)
	if ( chance >= 1 ) then return true end
	return Success(chance)
end

function SyncPetsToOwner(owner)
	ForeachActivePet(owner, function(pet)
		SyncPetToOwner(owner, pet)
	end, true)
end

function SyncPetToOwner(owner, pet)
	-- karma level ( and name color )
	local karma = GetKarma(owner)
	local karmaLevel = GetKarmaLevel(karma)
	if ( karmaLevel.Name ~= GetKarmaLevel(GetKarma(pet)).Name ) then
		SetKarma(pet, karma)
		pet:SendMessage("UpdateName")
	end

	-- group consent
	local karmaGroup = owner:GetObjVar("GroupKarma")
	if ( karmaGroup ) then
		pet:SetObjVar("GroupKarma", karmaGroup)
	else
		if ( pet:HasObjVar("GroupKarma") ) then
			pet:DelObjVar("GroupKarma")
		end
	end

	-- order flags
	if ( owner:HasObjVar("IsChaotic") ) then
		if not( pet:HasObjVar("IsChaotic") ) then
			pet:SetObjVar("IsChaotic", true)
			SetStatusIconOverride(pet,"Order")
		end
	else
		if ( pet:HasObjVar("IsChaotic") ) then
			pet:DelObjVar("IsChaotic")
			SetStatusIconOverride(pet,"")
		end
	end
	
	-- allegiance
    local allegianceId = GetAllegianceId(owner)
    local allegianceData = nil
    if ( allegianceId ) then
        allegianceData = GetAllegianceDataById(allegianceId)
    end
    UpdatePetAllegiance(pet, allegianceId, allegianceData)
end

function UpdatePetAllegiance(pet, allegianceId, allegianceData)
    if ( allegianceId ) then
        if ( allegianceData ) then
            pet:SetObjVar("Allegiance", allegianceId)
            -- set the allegiance icon
            pet:SetSharedObjectProperty("Faction", allegianceData.Icon)
        end
    else
        if ( pet:HasObjVar("Allegiance") ) then
            pet:DelObjVar("Allegiance")
            pet:SetSharedObjectProperty("Faction", "None")
        end
    end
end

--- Send a pet command to a specific pet
-- @param pet mobileObj
-- @param command string The command to send
-- @param target(optional) mobileObj/Location
-- @param force(optional) boolean
function SendPetCommandTo(pet, command, target, force)
    Verbose("Pet", "SendPetCommandTo", pet, command, target, force)
	if ( pet ~= nil and ValidPetCommand(command) ) then
		pet:SendMessage("UserPetCommand", command, target, force)
	end
end

--- Send a pet command to all pets in a list
-- @param pets luaArray Use the returned value from something like GetActivePets()
-- @param command string The command to send
-- @param target(optional) mobileObj/Location
-- @param force(optional) boolean
function SendPetCommandToAll(pets, command, target, force)
    Verbose("Pet", "SendPetCommandToAll", pets, command, target, force)
	if not( ValidPetCommand(command) ) then return end
	if not( pets ) then
		LuaDebugCallStack("Pets list not provided, use GetActivePets().")
		return
	end
    if ( #pets > 0 ) then
		for i,pet in pairs(pets) do
			if ( command == "go" and #pets > 1 ) then
				target = target:Project(72*i, 2)
			end
			
    		SendPetCommandTo(pet, command, target, force)
    	end
    end
end

--- Processes a pet command string
-- @param master mobileObj
-- @param cmd string First word in command string
-- @param args luaArray The rest of the words in the command string
function ProcessPetCommand(master, cmd, args)
    Verbose("Pet", "ProcessPetCommand", master, cmd, args)
	if ( #args == 1 or #args == 2 ) then
		-- should do better alias handling, but this works.
		if ( args[1] == "kill" ) then args[1] = "attack" end
		
		local command = args[1]
		local target = nil

		if ( PetCommands[command].target ) then
			if ( args[2] == "me" ) then
				target = master
			elseif ( args[2] == "target" or args[2] == "them" ) then
				target = master:GetObjVar("CurrentTarget")
				if ( not target or not target:IsValid() ) then
					return
				end
			else
				local eventId = "ProcessPetCommandRequestTarget"
				RegisterSingleEventHandler(EventType.ClientTargetLocResponse, eventId,
					function (success,targetLoc,targetObj,user)
						-- return on failure or targetobj and targetloc both non-truthy
						if not( success or (targetObj or targetLoc) ) then return end
						-- return if target is out of sight
						if (
							(
								(targetObj == nil or not ValidCombatTarget(user, targetObj))
								and
								(targetLoc
								and not
								user:HasLineOfSightToLoc(targetLoc, ServerSettings.Combat.LOSEyeLevel))
							)
							or
							(
								targetObj
								and not
								user:HasLineOfSightToObj(targetObj, ServerSettings.Combat.LOSEyeLevel)
							)
						) then
							user:SystemMessage("Cannot see that.", "info")
							return
						end
						if ( targetObj and targetObj ~= master ) then
							FaceObject(master, targetObj)
							master:PlayAnimation("point")
						end
						-- special case for go command, since it accepts locations as a target, not objects.
						-- Probably would be better to put this in petcommands.lua? but I can't imagine another use case. -KH
						if ( command == "go" ) then
							FinalizePetCommand(master, cmd, command, targetLoc or targetObj:GetLoc())
						else
							FinalizePetCommand(master, cmd, command, targetObj)
						end
					end
				)
				master:RequestClientTargetLoc(master, eventId)
				return
			end
		end
		FinalizePetCommand(master, cmd, command, target)
	end
end

--- Finialize a pet command, extracted ending to ProcessPetCommand so we can request a target between start and finish
-- @param master mobileObj
-- @param name string Name of the creature you want to send this command to, send 'all' for all pets.
-- @param command string The pet command, check PetCommands
-- @param target(optional)
function FinalizePetCommand(master, name, command, target)
    Verbose("Pet", "FinalizePetCommand", master, name, command, target)
	if ( name == "all" ) then
		SendPetCommandToAll(GetActivePets(master), command, target)
	else
		SendPetCommandTo(GetActivePetByCommandName(GetActivePets(master), name), command, target)
	end
end

-- Determine if a given command for a pet is valid
-- @param cmd string
-- @return true/false
function ValidPetCommand(cmd)
	return PetCommands[cmd] ~= nil
end

--- Determine if a mobileObj is tamable
-- @param mobileObj
-- @return true if mobileObj is tamable
function IsTamable(mobileObj)
    Verbose("Pet", "IsTamable", mobileObj)
	return mobileObj and mobileObj:HasObjVar("TamingDifficulty") and not mobileObj:HasModule("merchant_sale_item") and not IsDead(mobileObj)
end

--- Determine if a mobileObj is a pet
-- @param mobileObj
-- @return true if mobileObj is a pet
function IsPet(mobileObj)
    Verbose("Pet", "IsPet", mobileObj)
	return mobileObj and mobileObj:HasModule("pet_controller")
end

--- Determine if a mobileObj is a tamed pet
-- @param mobileObj
-- @return true if mobileObj is a tamed pet
-- DAB TODO: This should check if the controller is a player instead of just checking for TamingDifficulty
function IsTamedPet(mobileObj)
    Verbose("Pet", "IsTamedPet", mobileObj)
	return ( IsPet(mobileObj) and mobileObj:HasObjVar("TamingDifficulty") )
end

--- Determine if this container is in your pets backpack
function IsInPetPack(gameObj,user,topmostContainer,requireController)
	topmostContainer = topmostContainer or gameObj:TopmostContainer() or gameObj

	local isPet = (requireController and IsController(user,topmostContainer)) or IsPet(topmostContainer)
	-- if this is a pet and it has a pack and this object is in that pack return true
	return isPet and topmostContainer:HasObjVar("HasPetPack") and IsInBackpack(gameObj,topmostContainer,true)
end

-- Returns true if the pet has anything in it's pack
function IsPetCarryingItems(pet)
	if not(pet:HasObjVar("HasPetPack")) then
		return false
	end

	local backpackObj = pet:GetEquippedObject("Backpack")
	if not(backpackObj) then
		return false
	end

	return #backpackObj:GetContainedObjects() > 0
end

function IsController(controller,mobileObj)
    Verbose("Pet", "IsController", controller,mobileObj)
	return controller ~= nil and (mobileObj:GetObjectOwner() == controller or mobileObj:GetObjVar("controller") == controller)
end

function GetPetOwner(mobileObj)
	return (mobileObj:GetObjectOwner() or mobileObj:GetObjVar("controller"))
end

function GetPetStance(mobileObj)
    Verbose("Pet", "GetPetStance", mobileObj)
	if ( mobileObj == nil ) then return nil end
	return mobileObj:GetObjVar("PetStance") or PetStance.Passive
end

--- Get the number of slots a pet takes up, does not enforce mobileObj being a pet
-- @param mobileObj The Pet
-- @return #slots(number)
function GetPetSlots(mobileObj)
    Verbose("Pet", "GetPetSlots", mobileObj)
	if ( mobileObj == nil ) then
		LuaDebugCallStack("[GetPetSlots] Nil mobileObj provided.")
		return
	end
	-- default to a large number incase a pet doesn't have PetSlots set, we don't want it to glitch and allow unlimited.
	return mobileObj:GetObjVar("PetSlots") or 1000
end

function ValidPetStance(stance)
	local found = false
	for key,val in pairs(PetStance) do
		if ( key == stance ) then
			found = true
			break
		end
	end
	if not( found ) then
		LuaDebugCallStack("Invalid Pet Stance: '"..tostring(stance).."' provided")
	end
	return found
end

function SetPetStance(mobileObj, stance)
    Verbose("Pet", "SetPetStance", mobileObj, stance)
	stance = stance or PetStance.Passive
	if ( not mobileObj or not ValidPetStance(stance) ) then return end
	if ( stance == PetStance.Passive ) then
		mobileObj:DelObjVar("PetStance")
	else
		mobileObj:SetObjVar("PetStance", stance)
	end
end

--- Get the maximum stable pet slots a master can have, each pet counts as 1 stable slot.
-- @param master mobileObj
-- @return number of maximum stable pet slots for master.
-- function MaxStabledPetSlots(master)
-- 	return 15 -- all pets count as 1
-- end

--- Get the maximum active pet slots a master can have, each pet has individual slot count toward active pets slots.
-- @param master mobileObj
-- @return number of maximum active pet slots for master.
-- function MaxActivePetSlots(master)
-- 	return 5
-- end

--- Get a master's stabled pet by a pet's gameObj id
-- @param master mobileObj
-- @param id double
-- @return stabledPet, totalStabledSlots
function GetStabledPetById(master, id)
    Verbose("Pet", "GetStabledPetById", master, id)
	local stabledPets, slots = GetStabledPets(master)
	for i,pet in pairs(stabledPets) do
		if pet.Id == id then
			return pet, slots
		end
	end
	return nil, slots
end

--- Get a list of master's pets currently in stable
-- @param master mobileObj
-- @return stabledPets, totalStabledSlots
function GetStabledPets(master)
    Verbose("Pet", "GetStabledPets", master)
	local tempPack = master:GetEquippedObject("TempPack")
	if ( tempPack ) then
        local stabledPets = FindItemsInContainerRecursive(tempPack, IsPet)
        return stabledPets, #stabledPets
	end
	return {}, MaxStabledPetSlots(master) -- failed to lookup how many are stabled (missing temp pack?) so default
end

--- Get a master's active pet by a pet's gameObj id
-- @param master mobileObj
-- @param id double
-- @param stance(optional) string Get only pets with this stance.
-- @return activePet
function GetActivePetById(master, id, stance)
    Verbose("Pet", "GetActivePetById", master, id, stance)
	local activePets = GetActivePets(master, stance)
	for i,pet in pairs(activePets) do
		if ( pet.Id == id ) then
			return pet
		end
	end
	return nil
end

--- Get an active pet by the command name of the pet (see SetCommandName for rules)
-- @param pets luaArray Use the return value from GetActivePets()
-- @param commandName string The command name of the pet you seek
-- @return mobileObj or nil
function GetActivePetByCommandName(pets, commandName)
    Verbose("Pet", "GetActivePetByCommandName", pets, commandName)
	if not ( commandName ) then return end
	if not( pets ) then
		LuaDebugCallStack("Pets list not provided, use GetActivePets().")
		return
	end
	if ( #pets > 0 ) then
		for i,pet in pairs(pets) do
			if ( commandName == pet:GetObjVar("CommandName") ) then
				return pet
			end
		end
	end
	return nil
end

--- Get a list of active pets for a master, and also the slots taken by all active pets.
-- @param master mobileObj
-- @param stance, string(optional) Only return pets in this stance
-- @param includeMount, boolean(optional), set true to include the mount in the returned list
-- @return activePets, totalActiveSlots
function GetActivePets(master, stance, includeMount)
    Verbose("Pet", "GetActivePets", master, stance, includeMount)
	if ( master == nil ) then
		LuaDebugCallStack("[GetActivePets] Nil master provided.")
		return {}
	end
	local pets = master:GetOwnedObjects() or {}
	-- account for mounted pet as well since they are technically in player's body container and not an Owned Object.
	if ( includeMount == true and IsMounted(master) ) then
		table.insert(pets, GetMount(master))
	end

	local slots = 0
	local out = {}
	for i=1,#pets do
		local pet = pets[i]
		if ( pet ~= master and not IsDead(pet) and IsPet(pet) and (stance == nil or GetPetStance(pet) == stance) ) then
			table.insert(out, pet)
			slots = slots + GetPetSlots(pet)
		end
	end

	--master:NpcSpeech("Active pet slots: "..slots)
	return out, slots
end

--- Returns the number of active pet slots left for a master, ie how many more active pet slots can be filled.
-- @param master mobileObj
-- @return number of pet slot
function GetRemainingActivePetSlots(master)
    Verbose("Pet", "GetRemainingActivePetSlots", master)
	local pets, slots = GetActivePets(master, nil, true)
	return MaxActivePetSlots(master) - slots
end

--- Set's a pets command name, this is used in text commands when giving commands to specific pets.
-- @param pet mobileObj
-- @param name string
function UpdatePetCommandName(pet, name)
    Verbose("Pet", "UpdatePetCommandName", pet, name)
	pet:SetObjVar("CommandName", string.match( string.lower( StripColorFromString(name) ), "(%w+)") )
end

--- Set's a creature as a pet to a master, doesn't enforce valid Tamable creatures.
-- @param creature mobileObj
-- @param master mobileObj
-- @return boolean true if success
function SetCreatureAsPet(creature, master)
    Verbose("Pet", "SetCreatureAsPet", creature, master)
	if ( master == nil or creature == nil or not master:IsValid() or not creature:IsValid() or creature:IsPlayer() ) then return false end

	creature:DelObjVar("MobileTeamType")

	local nameStr = StripColorFromString(creature:GetName())
	creature:SetObjVar("LivingName", nameStr)
	UpdatePetCommandName(creature, nameStr)
	
	creature:AddModule("pet_controller")
	creature:SendMessage("SetPetOwner", master)

	creature:SetObjVar("MobileTeamType","Villagers")
	creature:SetMobileType("Friendly")

	creature:SetObjVar("NoReset",true)
	
	if(creature:DecayScheduled()) then
		creature:RemoveDecay()
	end

	creature:SetObjVar("HasSkillCap",true)
	creature:SendMessage("EndCombatMessage")
	creature:PlayObjectSound("Pain")

	master:SystemMessage("You have tamed "..nameStr,"info")

	return true
end

function UpdatePetName(mobileObj, newName, colorized)
    Verbose("Pet", "UpdatePetName", mobileObj, newName, colorized)
	mobileObj:SetName(colorized)
	UpdatePetCommandName(mobileObj, newName)
	mobileObj:SetSharedObjectProperty("DisplayName", colorized)
end


--- Determine if a master can control a creature
-- @param master mobileObj
-- @param creature mobileObj
-- @return true/false
function CanControlCreature(master, creature)
	Verbose("Pet", "CanControlCreature", master, creature)
	if(IsGod(master)) then
		return true
	end

	return ChanceToControlCreature(master, creature) > 0
end

--- Get the chance to tame a animal/beast
-- @param tamingSkillRequired double
-- @param animalTamingSkillLevel double
-- @param beastmasterSkillLevel double
-- @return animalChance(double), beastChance(double) (or nil if not beast)
function ChanceToTameAnimalBeast(tamingSkillRequired, animalTamingSkillLevel, beastmasterSkillLevel)
    Verbose("Pet", "ChanceToTameAnimalBeast", tamingSkillRequired, animalTamingSkillLevel, beastmasterSkillLevel)
	if ( tamingSkillRequired == nil or animalTamingSkillLevel == nil or beastmasterSkillLevel == nil ) then return 0 end

	local beastChance = nil
	if ( tamingSkillRequired >= 100 ) then
		beastChance = tamingSkillRequired - 100
		beastChance = SkillValueMinMax( beastmasterSkillLevel, beastChance, beastChance + 50 )
	end

	return SkillValueMinMax( animalTamingSkillLevel, tamingSkillRequired, tamingSkillRequired + 50 ), beastChance
end

--- given a target and a potential master, returns true/false for a successful tame, also skill checks proper.
-- @param creature mobileObj
-- @param master mobileObj
-- @return boolean true is success, otherwise false
function CheckAnimalTamingSuccess(creature, master)
    Verbose("Pet", "CheckAnimalTamingSuccess", creature, master)
	if ( creature == nil or master == nil or not creature:IsValid() or not master:IsValid() ) then return false end
	
	local previousOwners = creature:GetObjVar("PreviousOwners") or {}
	for i,id in pairs(previousOwners) do
		if ( id == master.Id ) then
			-- master has previously tamed this creature, 100% chance
			return true
		end
	end

	local requiredSkillToTame = creature:GetObjVar("TamingDifficulty")
	if ( requiredSkillToTame == nil ) then return false end

	local skillDictionary = GetSkillDictionary(master)
	local animalTamingSkillLevel = GetSkillLevelFromDictionary("AnimalTamingSkill", skillDictionary)
	local animalLoreSkillLevel = GetSkillLevelFromDictionary("AnimalLoreSkill", skillDictionary)
	local beastmasterSkillLevel = GetSkillLevelFromDictionary("BeastmasterySkill", skillDictionary)

	local animalChance, beastChance = ChanceToTameAnimalBeast(requiredSkillToTame, animalTamingSkillLevel, beastmasterSkillLevel)
	--master:NpcSpeech("animalChance: "..animalChance)
	if ( beastChance ~= nil ) then
		--master:NpcSpeech("beastChance: "..beastChance)
		AnimalTamingInformVeryDifficult(master, beastChance)
		-- skill check animal lore ( for gains )
		CheckSkillChance(master, "AnimalLoreSkill", animalLoreSkillLevel, animalChance)
		-- skill check taming ( for gains)
		CheckSkillChance(master, "AnimalTamingSkill", animalTamingSkillLevel, animalChance)
		return CheckSkillChance(master, "BeastmasterySkill", beastmasterSkillLevel, beastChance)
	else
		AnimalTamingInformVeryDifficult(master, animalChance)
		-- skill check animal lore ( for gains )
		CheckSkillChance(master, "AnimalLoreSkill", animalLoreSkillLevel, animalChance)
		return CheckSkillChance(master, "AnimalTamingSkill", animalTamingSkillLevel, animalChance)
	end

end

--- Function that takes a chance and alerts the master if the chance is very difficult.
-- @param master
-- @param chance
-- @return none
function AnimalTamingInformVeryDifficult(master, chance)
	if ( chance < 0.075 ) then
		master:SystemMessage("You have almost no chance of taming this creature.", "info")
	end
end

--- Given a creature and master will determine if a creature can be tamed in the given moment.
-- @param creature mobileObj
-- @param master mobileObj
-- @return boolean true if valid taming target, string Error message if not success
function ValidAnimalTamingTarget(creature, master)
    Verbose("Pet", "ValidAnimalTamingTarget", creature, master)
	if ( creature == nil or not(IsTamable(creature)) or creature:HasModule('pet_controller') ) then
		return false, "That cannot be tamed."
	end
	if not( CanAddToActivePets(master, creature) ) then
		return false, "Cannot control that many creatures at once."
	end
	if not( CanControlCreature(master, creature) ) then
		return false, "You have no chance of controlling that creature."
	end
	if ( HasMobileEffect(creature, "BeingTamed") ) then
		return false, "That creature is already being tamed."
	end
	if ( master:GetLoc():Distance(creature:GetLoc()) > ServerSettings.Pets.Taming.Distance ) then
		return false, "Too far away to tame that."
	end
	return true
end

function CanAddToActivePets(master, creature)
    Verbose("Pet", "CanAddToActivePets", master, creature)
	return (creature:GetObjVar("PetSlots") or MaxActivePetSlots(master)) <= GetRemainingActivePetSlots(master)
end

-- NOS EDITS

function MaxActivePetSlots(master)
    local slots = GetSkillLevel(master, "BeastmasterySkill")/10 or 1
    if (slots < 4) then slots = 4 end
    -- master:SystemMessage(tostring("You can control " .. slots .. " slots worth of pets."))
	return slots
end

function MaxStabledPetSlots(master)
    local slots = GetSkillLevel(master, "AnimalTamingSkill")/2
	return math.max(30, slots)
end

function CorrectPetStats(localPet)
    if(localPet ~= nil) then
        -- DebugMessage(IsPet(localPet))
        -- DebugMessage(localPet)
        --DebugMessage(localPet:GetObjVar("TemplateId"))
        
        local templateId = localPet:GetCreationTemplateId()
        local petPetSlots = GetTemplateObjVar(templateId, "PetSlots")
        if(petPetSlots ~= nil) then localPet:SetObjVar("PetSlots", petPetSlots) end
        
        local petBaseHealth = GetTemplateObjVar(templateId, "BaseHealth")
        if(petBaseHealth ~= nil) then localPet:SetObjVar("BaseHealth", petBaseHealth) end
        
        local petArmor = GetTemplateObjVar(templateId, "Armor")
        if(petArmor ~= nil) then localPet:SetObjVar("Armor", petArmor) end

        local petAttack = GetTemplateObjVar(templateId, "Attack")
        if(petAttack ~= nil) then localPet:SetObjVar("Attack", petAttack) end
        
        local petPower = GetTemplateObjVar(templateId, "Power")
        if(petPower ~= nil) then localPet:SetObjVar("Power", petPower) end
        
        local templateData = GetTemplateData(templateId)
        -- DebugMessage(" --- templateData:")
        -- if(templateData ~= nil) then
        --     for i, v in pairs(templateData) do
        --         DebugMessage(i.." : "..tostring(v))
        --     end
        -- end

        -- Disabled updating Name because of choice.
        --local petName = templateData.Name
        --if(petName ~= nil) then localPet:SetObjVar("Name", petName) end
        
        local petSpeed = templateData.BaseSpeed
        -- BRYCE, CHECK THIS
        -- if(petSpeed ~= nil) then localPet:SetBaseMoveSpeed(petSpeed) end
        
        -- Disabled updating Scale because of choice.
        --local petScale = GetTemplateObjectScale(templateId)
        --if(petScale ~= nil) then localPet:SetScale(petScale) end
        
        --DebugMessage(" --- LuaModules:")
        if(templateData.LuaModules ~= nil) then
            for i, v in pairs(templateData.LuaModules) do
                --DebugMessage(i.." : "..tostring(v))
                if(string.find(i, "ai_")) then
                    -- BRYCE, CHECK THIS
                    --DebugMessage("    AI MODULE FOUND:")
                    if (v.Stats == nil) then return end
                    --DebugMessage("    Stats:")
                    for statName, statValue in pairs(v.Stats) do
                        if(statValue ~= nil and statName ~= nil) then 
                            --DebugMessage(statName.." : "..tostring(statValue))
                            SetStatByName(localPet, statName, statValue)	
                        end
                    end
                    
                    -- DebugMessage("    Skills:")
                    -- for ii, vv in pairs(v.Skills) do
                    --     DebugMessage(ii.." : "..tostring(vv))
                    -- end
                end
            end
        end
        
        --SendMobileDataToDebugMessage(localPet)

        -- We might be able to use the below to correctly update Character Info screen data..  But there is a scope issue it may not be accessible.
        -- dirtyTable = {
        --     Strength = true,
        --     Agility = true,
        --     Intelligence = true,
        --     Constitution = true,
        --     Wisdom = true,
        --     Will = true,
        --     Accuracy = true,
        --     Evasion = true,
        --     Attack = true,
        --     Power = true,
        --     Force = true,
        --     Defense = true,
        --     AttackSpeed = true,
        --     CritChance = true,
        --     CritChanceReduction = true,
        --     MoveSpeed = true,
        --     MountMoveSpeed = true,
        -- }
        -- MarkStatsDirty(dirtyTable)
    end
end

function GetPetOwner(pet)
	return (pet:GetObjectOwner() or pet:GetObjVar("controller"))
end

function SendMobileDataToDebugMessage(localMobile)
    -- This method is used to pump a lot of gameobject and template data into the console.

    if(localMobile == nil) then
        DebugMessage("The mobile provided is nil, not possible to get any data off of it.")
    else
        DebugMessage(" ========================================= ")
        DebugMessage(" === Start SendMobilDataToDebugMessage === ")
        local templateId2 = localMobile:GetCreationTemplateId()
        if(templateId2 ~= nil) then 
            DebugMessage(" --- templateId2: ")
            DebugMessage(templateId2)
        end
        local test = localMobile:GetObjVar("TemplateName")
        if(test ~= nil) then
            DebugMessage(" --- test: ")
            DebugMessage(test)
        end
        local test2 = GetTemplateObjectName(templateId2)
        if(test2 ~= nil) then
            DebugMessage(" --- test2: ")
            DebugMessage(test2)
        end
        local petScale = GetTemplateObjectScale(templateId2)
        if(petScale ~= nil) then 
            DebugMessage(" --- Template Scale:")
            DebugMessage(petScale) 
        end
        local petScale2 = localMobile:GetScale()
        if(petScale2 ~= nil) then 
            DebugMessage(" --- GameObject Scale:")
            DebugMessage(petScale2) 
        end
        local test3 = GetUserdataType(localMobile)
        if(test3 ~= nil) then
            DebugMessage(" --- test3: ")
            DebugMessage(test3)
        end

    DebugMessage(" --- localMobile:GetAllObjVars:")
        if(localMobile ~= nil) then
            for i, v in pairs(localMobile:GetAllObjVars()) do
                DebugMessage(i.." : "..tostring(v))
            end
        end

        -- DebugMessage(" --- localMobile:GetObjectTags:")
        -- if(localMobile ~= nil) then
        --     for i, v in pairs(localMobile:GetObjectTags()) do
        --         DebugMessage(i.." : "..tostring(v))
        --     end
        -- end

        -- DebugMessage(" --- localMobile:GetAllSharedObjectProperties:")
        -- if(localMobile ~= nil) then
        --     for i, v in pairs(localMobile:GetAllSharedObjectProperties()) do
        --         DebugMessage(i.." : "..tostring(v))
        --     end
        -- end

        -- DebugMessage(" --- localMobile:GetAllEquippedObjects:")
        -- if(localMobile ~= nil) then
        --     for i, v in pairs(localMobile:GetAllEquippedObjects()) do
        --         DebugMessage(i.." : "..tostring(v))
        --     end
        -- end

        -- DebugMessage(" --- localMobile:GetAllStats:")
        -- if(localMobile ~= nil) then
        --     for i, v in pairs(localMobile:GetAllStats()) do
        --         DebugMessage(i.." : "..tostring(v))
        --     end
        -- end

        -- Used to get the Initializer table from the template file for the provided module_name.
        -- GetInitializerFromTemplate(templateId2, module_name)

        --DebugMessage(ass(templateData.BaseHealth).." : "..ass(templateData.Armor).." : "..ass(templateData.Attack).." : "..ass(templateData.Power).." : "..ass(templatedata.ScaleModifier).." : "..ass(templateData.BaseRunSpeed))
        --local statTable = GetStatTableFromTemplate(template,templateData)

        -- petSpeed = templateData.BaseRunSpeed 
        -- petScale = templateData.ScaleModifier

        DebugMessage(" ==== End SendMobilDataToDebugMessage ==== ")
        DebugMessage(" ========================================= ")
    end
end