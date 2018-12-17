require 'base_mobile'
-- helper functions
require 'incl_humanloot'
-- this module gives the mobile skills
require 'base_skill_sys'

--[[ General Helper functions ]]--

local BaseDoMobileDeath = DoMobileDeath
function DoMobileDeath(damager, damageSource)
	BaseDoMobileDeath(damager, damageSource)

	CancelCastPrestigeAbility(this)

	local mountObj = this:GetEquippedObject("Mount")
	if(mountObj ~= nil) then
		DismountMobile(this, mountObj)
	end

	if not( IsPlayerCharacter(this) ) then

		-- keeping default interaction (left clicking a dead non-player) standard to always try to open the corpse.
		this:SetSharedObjectProperty("DefaultInteraction","Harvest")
		
		if( not this:HasObjVar("noloot") and not this:HasObjVar("guardKilled") and not this:HasObjVar("lootable") ) then
			local lootContainer = this:GetEquippedObject("Backpack")
			if (lootContainer ~= nil) then
				this:SetSharedObjectProperty("DefaultInteraction","Open Pack")
				lootContainer:SetAppearanceFromTemplate("coffin")
				lootContainer:SetName(this:GetSharedObjectProperty("DisplayName"))

				local lootTables = this:GetObjVar("LootTables")
				if(lootTables) then
					this:SetObjVar("lootable", true)
					LootTables.SpawnLoot(lootTables,lootContainer)
				end
			end
		end
	end
end

-- Overriding the base_mobile apply damage to check for pvp rules
local BaseHandleApplyDamage = HandleApplyDamage
function HandleApplyDamage(damager, damageAmount, damageType, isCrit, wasBlocked, isReflected, damageSource)
	Verbose("AdvancedMobile", "HandleApplyDamage", damager, damageAmount, damageType, isCrit, wasBlocked, isReflected, damageSource)
	local newHealth = BaseHandleApplyDamage(damager, damageAmount, damageType, isCrit, wasBlocked, isReflected, damageSource)

	--wake up if we're asleep
	if (IsAsleep(this)) then
		HaveMobileWakeUp()
	end

	return newHealth
end

function ChangeToTemplate(template,options)
	local defaultOptions = {
		Quiet = true,
		SetStats = true,
		SetName = true,
		KeepAppearance = false,		
		LoadEquipment = true,
		IgnoreBodyParts = false,
		LoadLoot = true,
		SpawnLoot = false,
		LoadAbilities = true,
		DestroyExistingItems = true,
		ChangeMobileType = false,
		-- this option determines if the AI should try to equip items from the loot
		BuildHotbar = true,
	}
	--DebugMessage(DumpTable(options))
	if(options == nil) then
		options = defaultOptions
	else
		for k,v in pairs(defaultOptions) do
			if(options[k] == nil) then
				options[k] = defaultOptions[k]
			end
		end
	end
	--DebugMessage(DumpTable(options))

	this:SetObjVar("FormTemplate",template)	

	local templateData = GetTemplateData(template)	
	local statTable = GetStatTableFromTemplate(template,templateData)

	if(options.SetStats) then
		-- base health
		-- DO THIS BEFORE SetStartingStats 
		local baseHealth = templateData.ObjectVariables.BaseHealth
		if(baseHealth ~= nil) then
			this:SetObjVar("BaseHealth",baseHealth)
		elseif(this:HasObjVar("BaseHealth")) then
			this:DelObjVar("BaseHealth")
		end

		SetStartingStats(statTable,options.Quiet)
	end

	-- appearance
	if (not options.KeepAppearance) then
		this:SetAppearanceFromTemplate(template)
		if (templateData.Hue ~= nil) then
			this:SetColor(templateData.Hue)
		end
		if (templateData.ScaleModifier ~= nil) then
			this:SetScale(Loc(templateData.ScaleModifier,templateData.ScaleModifier,templateData.ScaleModifier))	
		end
	end

	if not(options.Quiet) then
		this:SystemMessage("Your appearance has changed.","info")
	end	

	-- natural weapon/armor
	if(templateData.ObjectVariables.NaturalWeaponType ~= nil) then 
		this:SetObjVar("NaturalWeaponType",templateData.ObjectVariables.NaturalWeaponType)
	else
		this:DelObjVar("NaturalWeaponType")
	end
	if(templateData.ObjectVariables.NaturalArmor ~= nil) then 
		this:SetObjVar("NaturalArmor",templateData.ObjectVariables.NaturalArmor)
	else
		this:DelObjVar("NaturalArmor")
	end
	
	-- body offset
	if(templateData.SharedObjectProperties.BodyOffset ~= nil) then
		this:SetSharedObjectProperty("BodyOffset",templateData.SharedObjectProperties.BodyOffset)
	else
		this:SetSharedObjectProperty("BodyOffset",ServerSettings.Combat.DefaultBodySize)			
	end

	--audio override
	if(templateData.SharedObjectProperties.AudioIdentifierOverride ~= nil) then
		this:SetSharedObjectProperty("AudioIdentifierOverride",templateData.SharedObjectProperties.AudioIdentifierOverride)		
	end
	
	-- mobile type
	if (options.ChangeMobileType) then
		this:SetMobileType(templateData.MobileType)
	end

	-- dynamic combat abilities
	if(options.LoadAbilities and statTable) then
		if ( statTable.CombatAbilities ~= nil) then
			SetInitializerCombatAbilities(this, statTable.CombatAbilities)
		end

		-- dynamic weapon abilities
		if ( statTable.WeaponAbilities ~= nil ) then
			this:SetObjVar("WeaponAbilities", statTable.WeaponAbilities)
			this:SendMessage("UpdateFixedAbilitySlots")
		end
	end	

	--DebugMessage("options.DestroyExistingItems is "..tostring(options.DestroyExistingItems))
	--DebugMessage("EquipMobile",tostring(options.LoadEquipment),tostring(options.LoadLoot),tostring(options.SpawnLoot))
	if (options.LoadEquipment or options.LoadLoot) then
		local equipTable = nil
		if(options.LoadEquipment and statTable) then
			equipTable = statTable.EquipTable
		end
		local lootTables = nil
		if(options.LoadLoot and statTable) then
			lootTables = statTable.LootTables
		end

		EquipMobile(equipTable, lootTables, options.DestroyExistingItems, options.SpawnLoot, options.IgnoreBodyParts)
	end
	
	-- update our name	
	if(options.SetName) then
		this:SendMessage("UpdateName")
	end

	-- copy over hotbar
	if(options.BuildHotbar and this:IsPlayer()) then
		if(statTable.SavedHotbar) then
			LoadHotbarFromXML(statTable.SavedHotbar)
		else			
			CallFunctionDelayed(TimeSpan.FromSeconds(1),function ( ... )
				BuildHotbar(statTable.HotbarActions)
			end)
		end
	end

	--DebugMessage("bodyTemplateId is "..tostring(bodyTemplateId))			
end

function BuildHotbar(hotbarActionDefinitions)
	local hotbarActions = {}
	local abilityCount = 0

	--DebugMessage("-- BuildHotbar (create HoatbarActions objvar) -- "..#hotbarActionDefinitions)
	if(hotbarActionDefinitions ~= nil) then
		for i,entry in pairs(hotbarActionDefinitions) do
			local userAction = nil
			if(entry.Type == "Resource") then
				userAction = GetResourceTypeUserAction(entry.Name,this)
			elseif(entry.Type == "Object") then
				local objectRef = FindItemInContainerByTemplateRecursive(this,entry.Name) 
				if(objectRef) then
					userAction = GetItemUserAction(objectRef,this)
				end
			elseif(entry.Type == "CombatAbility") then				
				userAction = GetAbilityUserAction(entry.Name)				
			elseif(entry.Type == "Spell") then
				userAction = GetSpellUserAction(entry.Name)
			end

			if(userAction) then
				userAction.Slot = entry.Slot
				userAction.Enabled = true
				table.insert(hotbarActions,userAction)							
			end
			abilityCount = abilityCount + 1
		end
	end

	this:SetObjVar("HotbarActions",hotbarActions)

	InitializeHotbar()

	for i=abilityCount+1,9 do
		RemoveUserActionFromSlot(i)
	end
end

function CloneEquipment(object)
	--DebugMessage("Equipment object is "..tostring(object))
	if (object == nil) then return end
  	CreateObjInContainer(object:GetCreationTemplateId(), this, GetRandomDropPosition(this), "EquipObject"..object:GetCreationTemplateId(), object)
	RegisterSingleEventHandler(EventType.CreatedObject,"EquipObject"..object:GetCreationTemplateId(),
		function (success,objRef)
		  	if (success) then
		  		-- cloned items should never be lootable
		  		objRef:SetObjVar("noloot", true)
		  		objRef:SetColor(object:GetColor())

				this:EquipObject(objRef)
			end
		end)
end

--copy this mobile from another one
function CopyOtherMobile(otherMob,appearanceOnly,takeEquipment)
	--DebugMessage("COPYING FORM FROM "..otherMob:GetName().." to "..this:GetName())
	--DebugMessage("==============================================================")
	if (type(otherMob) == "string") then
		otherMob = GameObj(tonumber(otherMob))
	elseif( type(otherMob) == "number") then
		otherMob = GameObj(otherMob)
	end
	if (otherMob:IsPermanent()) then
		return
	end

	--Uses the same stat table as in a template
	if (not appearanceOnly) then
		SetStr(this,GetStr(otherMob))
		SetAgi(this,GetAgi(otherMob))
		SetInt(this,GetInt(otherMob))
		SetCon(this,GetCon(otherMob))
		SetWis(this,GetWis(otherMob))
		SetWill(this,GetWill(otherMob))
		this:SetObjVar("Sleeping",false)
		DoRecalculateStats()
		SetCurHealth(this,GetCurHealth(otherMob))
		SetCurMana(this,GetCurMana(otherMob))
		SetCurStamina(this,GetCurStamina(otherMob))
		
		if (otherMob:HasObjVar("SkillDictionary")) then
			this:SetObjVar("SkillDictionary",otherMob:GetObjVar("SkillDictionary"))
		else
			this:DelObjVar("SkilLDictionary")
		end
	end
	for i,equipObj in pairs(this:GetAllEquippedObjects()) do
		--DebugMessage("Destroying object"..tostring(equipObj:GetName()))
		equipObj:Destroy()
	end
	--DebugMessage("Template is changing to "..tostring(otherMob:GetObjVar("FormTemplate") or otherMob:GetCreationTemplateId()))
	this:SetAppearanceFromTemplate(otherMob:GetObjVar("FormTemplate") or otherMob:GetCreationTemplateId())
	-- find the equipment table
	local backpackObj = otherMob:GetEquippedObject("Backpack")
    local leftHand = otherMob:GetEquippedObject("LeftHand")
    local rightHand = otherMob:GetEquippedObject("RightHand")
    local chest = otherMob:GetEquippedObject("Chest")
    local legs = otherMob:GetEquippedObject("Legs")
    local head = otherMob:GetEquippedObject("Head")
    local body = otherMob:GetEquippedObject("BodyPartHead")
    local hair = otherMob:GetEquippedObject("BodyPartHair")
   --DebugMessage(this:GetLoc()+Loc(math.random()-0.5,0,math.random()-0.5))
   --DebugMessage("Going to equipment")
   	if (takeEquipment) then
	  	--this:EquipObject(backpackObj)
	  	if ( leftHand ~= nil and not leftHand:HasObjVar("Blessed") ) then
		  	this:EquipObject(leftHand)
		end
	  	if ( rightHand ~= nil and not rightHand:HasObjVar("Blessed") ) then
	  		this:EquipObject(rightHand)
		end
	  	if ( chest ~= nil and not chest:HasObjVar("Blessed") ) then
	  		this:EquipObject(chest)
		end
	  	if ( legs ~= nil and not legs:HasObjVar("Blessed") ) then
	  		this:EquipObject(legs)
		end
	  	if ( head ~= nil and not head:HasObjVar("Blessed") ) then
	  		this:EquipObject(head)
		end
	end
	--DebugMessage("Copying body")
	CloneEquipment(body)
	CloneEquipment(hair)
	if (not appearanceOnly) then
		local baseHealth = otherMob:GetObjVar("BaseHealth")
		if(baseHealth ~= nil) then
			this:SetObjVar("BaseHealth",baseHealth)
		elseif(this:HasObjVar("BaseHealth")) then
			this:DelObjVar("BaseHealth")
		end
	end
	--DebugMessage("Scale hue")
	this:SetColor(otherMob:GetColor())
	this:SetScale(otherMob:GetScale())	

	if (not appearanceOnly) then
		if (this:HasObjVar("NaturalWeaponType")) then
			this:SetObjVar("NaturalWeaponType",otherMob:GetObjVar("NaturalWeaponType"))
		else
			this:DelObjVar("NaturalWeaponType")
		end
	end
	--DebugMessage("Name")

	this:SetName(otherMob:GetName())
	this:SendMessage("UpdateName")

	if (not appearanceOnly) then
		if (otherMob:HasObjVar("AvailableSpellsDictionary")) then
			this:SetObjVar("AvailableSpellsDictionary",otherMob:GetObjVar("AvailableSpellsDictionary"))	
		else
			this:DelObjVar("AvailableSpellsDictionary")
		end
		this:FireTimer("RetrieveKnownSpells")

		--[[ TODO: Support for copying a mobile's combat abilities/weapon abilites.
		if (otherMob:HasObjVar("CombatAbilities")) then
			this:SetObjVar("CombatAbilities", otherMob:GetObjVar("CombatAbilities"))
		else
			this:DelObjVar("CombatAbilities")
		end]]
	end
	this:SetObjVar("FormTemplate",otherMob:GetObjVar("FormTemplate") or otherMob:GetCreationTemplateId())

	otherMob:SendMessage("CopyOtherMobileCompleted", this)
end

RegisterEventHandler(EventType.Message, "ChangeMobileToTemplate", ChangeToTemplate)
RegisterEventHandler(EventType.Message, "CopyOtherMobile", CopyOtherMobile)

RegisterEventHandler(EventType.Message, "EquipMobile", 
	function (equipTable,lootTables,destroyExistingItems,ignoreBodyParts)
		EquipMobile(equipTable,lootTables,destroyExistingItems,ignoreBodyParts)
	end)

--[[ Message handler functions ]]--
-- remove the specified amount from the players inventory, the objects are identified by the resource type
function HandleConsumeResource(resourceType,amount,transactionId,responseObj,...)
	local success = false

	--DebugMessage(tostring(resourceType) .."   ".. tostring(amount) .."   "..tostring(transactionId) .."   "..tostring(response) .."   "..tostring(success))
	local backpackObj = this:GetEquippedObject("Backpack")
	local bankObj = this:GetEquippedObject("Bank")
	if( backpackObj ~= nil and CountResourcesInContainer(backpackObj,resourceType) >= amount ) then
		local resourceObjs = GetResourcesInContainer(backpackObj,resourceType)
		-- sort stackable objects from smallest to largest
		table.sort(resourceObjs,function(a,b) return GetStackCount(a)<GetStackCount(b) end)
		local remainingAmount = amount
		for index, resourceObj in pairs(resourceObjs) do
			local resourceCount = GetStackCount(resourceObj)
			if( resourceCount > remainingAmount ) then				
				RequestSetStackCount(resourceObj,resourceCount - remainingAmount)
				remainingAmount = 0
			else
				remainingAmount = remainingAmount - resourceCount
				resourceObj:Destroy()
			end

			if( remainingAmount == 0 ) then
				break
			end
		end

		success = true
	end
	--DebugMessage(tostring(resourceType) .."   ".. tostring(amount) .."   "..tostring(transactionId) .."   "..tostring(response) .."   "..tostring(success))
	if( responseObj ~= nil and responseObj:IsValid() ) then
		responseObj:SendMessage("ConsumeResourceResponse",success,transactionId,this,...)
	end
end

RegisterEventHandler(EventType.Message, "ConsumeResource", HandleConsumeResource)

--[[ Sitting and sleeping code ]]--

function InterruptSittingAndSleeping()
	--DebugMessage("Firing")
	this:SendMessage("WakeUp")
	this:SendMessage("StopSitting",true)
	if (IsSitting(this) or IsAsleep(this)) then
		this:PlayAnimation("idle")--plays the animation quicker
	end
end

RegisterEventHandler(EventType.StartMoving, "", InterruptSittingAndSleeping)

function HaveMobileSleep(bed)
	if (this:GetSharedObjectProperty("CombatMode")) then return end
	this:StopMoving()
	this:SendMessage("SleepMessage", damager)
	this:SetObjVar("Sleeping",true)
	this:SetSharedObjectProperty("Pose", "Laying")
	if (bed == nil or bed:HasObjVar("LowBed")) then
		this:PlayAnimation("lay_ground")
	else
		this:PlayAnimation("lay")
	end
	--this:SetMobileFrozen(true,true)		
	--mMoveSpeedEffects = {}
	--this:DelObjVar("MoveSpeedEffects")
	this:SystemMessage("Move to get up.","info")
	--DebugMessage("Sleeping")
end

function HaveMobileWakeUp()
	if( not(IsAsleep(this)) ) then
		return
	end

	--AddView("alert", SearchMobileInRange(GetSetting("AlertRange")))
	-- default to full stat values 
	local newStatPct = statPct or 1.0
	this:SetObjVar("Sleeping",false)
	this:SetSharedObjectProperty("Pose", "Standing")
	--this:PlayAnimation("rise")
	--this:SetMobileFrozen(false, false)
	this:SendMessage("OnWakeUp")
	--DebugMessage("woke up")
end

function HaveMobileSitChair()
	if (this:GetSharedObjectProperty("CombatMode")) then return end
	this:StopMoving()
	this:SetSharedObjectProperty("Pose", "Sitting")
	this:PlayAnimation("sit")
	--this:SetMobileFrozen(true,true)
	--mMoveSpeedEffects = {}
	--this:DelObjVar("MoveSpeedEffects")
	--DebugMessage("Sitting")
end

function HaveMobileStandChair(standInstantly)
	if( not(IsSitting(this)) ) then
		--DebugMessage("not isSitting")
		return
	end
	--DebugMessage("Should be standing up")
	--AddView("alert", SearchMobileInRange(GetSetting("AlertRange")))
	-- default to full stat values 
	local newStatPct = statPct or 1.0
	this:SetSharedObjectProperty("Pose", "Standing")
	if (standInstantly) then
		this:PlayAnimation("idle")
	else
		this:PlayAnimation("stand") --DFB TODO REPLACE WITH BETTER STANDING ANIMATION
	end
	--this:SetMobileFrozen(false, false)

	this:SendMessage("OnStandFromChair")
	--DebugMessage("Stood up")
end

RegisterEventHandler(EventType.Message, "StopSitting", 
	function (standInstantly)
		HaveMobileStandChair(standInstantly)
	end)

RegisterEventHandler(EventType.Message, "WakeUp", 
	function ()
		HaveMobileWakeUp()
	end)

RegisterEventHandler(EventType.Message, "FallAsleep" , HaveMobileSleep)
RegisterEventHandler(EventType.Message, "SitInChair" , HaveMobileSitChair)


function HandleEquipmentChanged(item,isEquipped)
	this:SendMessage("BreakInvisEffect", "Equipment")
	local slot = GetEquipSlot(item)
	if ( slot == "LeftHand" or slot == "RightHand" ) then
		if ( isEquipped ) then
			UpdateWeaponCache(slot)
		else
			UpdateWeaponCache(slot, false)
		end
	end
	-- important to call this after updating cache since it uses cached weapons.
	StatsHandleEquipmentChanged(item)
end

RegisterEventHandler(EventType.ItemEquipped, "", function(item) HandleEquipmentChanged(item,true) end)
RegisterEventHandler(EventType.ItemUnequipped, "", function(item) HandleEquipmentChanged(item,false) end)

local BaseOnMobileCreated = OnMobileCreated
function OnMobileCreated()
	BaseOnMobileCreated()

	if(initializer.SpawnLoot ~= nil) then
		EquipMobile(initializer.EquipTable,initializer.LootTables,false, true)
	else
		EquipMobile(initializer.EquipTable,initializer.LootTables,false)
	end

	if ( initializer.ScavengeTables ~= nil ) then
		this:SetObjVar("Scavengable", true)
	end

	this:SetObjVar("Sleeping",false)
end

--- cache some info on our weapons since they get used a lot.
UpdateWeaponCache("LeftHand")
UpdateWeaponCache("RightHand")

RegisterEventHandler(EventType.Message,"PerformPrestigeAbilityByName",function(...) PerformPrestigeAbilityByName(this,...) end)